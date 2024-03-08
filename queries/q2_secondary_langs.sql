-- host-level data
create table if not exists internet.host_lang_all
(
    host String,
    lang String,
    total UInt32,
)
engine = MergeTree
order by host as
select
    host,
    lang,
    count(*) as total
from sites
where lang != ''
group by host, lang;

create table if not exists internet.host_lang_main
(
    host String,
    host_rev String,
    lang_main String,
    lang_count UInt32,
    single_lang_host Boolean
)
engine = MergeTree
order by host as
select
    l.host,
    l.host_rev,
    m.lang_main,
    l.lang_count,
    l.single_lang_host
from
(
    select
        host,
        any(host_rev) as host_rev,
        count(distinct(lang)) as lang_count,
        (lang_count == 1) as single_lang_host
    from sites
    where lang != ''
    group by host
) as l
left outer join
(
    select
        host,
        argMax(lang, total) as lang_main
    from internet.host_lang_all
    group by host
) as m
using host;

-- total = total number of pages on hosts having given main (primary) language
select
    lang_main,
    lang,
    sites,
    sum(sites) over (partition by lang_main) as total,
    round(100 * sites / total, 2) as perc_sites
from 
(
    select
        m.lang_main,
        l.lang,
        sum(l.total) as sites
    from internet.host_lang_all l
    left join internet.host_lang_main m
    using host
    group by lang_main, lang
)
order by lang_main asc, perc_sites desc
format JSON;
