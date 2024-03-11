-- tld-level data
create table if not exists internet.tld_lang_all
(
    tld String,
    lang String,
    count UInt32,
    rank UInt32,
    tld_total UInt32,
    perc_of_tld Float32,
)
engine = MergeTree
order by tld as
select
    tld,
    lang,
    count(*) as count,
    rank() over (partition by tld order by count desc, lang desc) as rank,
    sum(count) over (partition by tld) as tld_total,
    round(100 * count / tld_total, 2) as perc_of_tld
from sites
where lang != ''
group by tld, lang;

-- host-level data
create table if not exists internet.host_lang_all
(
    host String,
    lang String,
    count UInt32,
)
engine = MergeTree
order by host as
select
    host,
    lang,
    count(*) as count
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
        argMax(lang, count) as lang_main
    from internet.host_lang_all
    group by host
) as m
using host;

create table if not exists internet.host_secondary_langs
(
    lang_main String,
    lang String,
    count UInt32,
    rank UInt32,
    total_lang_main UInt32,
    perc_sites Float32
)
engine = MergeTree
order by lang_main as
select
    lang_main,
    lang,
    count,
    rank() over (partition by lang_main order by count desc, lang desc) as rank,
    sum(count) over (partition by lang_main) as total_lang_main,
    round(100 * count / total_lang_main, 2) as perc_sites
from 
(
    select
        m.lang_main,
        l.lang,
        sum(l.count) as count
    from internet.host_lang_all l
    left join internet.host_lang_main m
    using host
    group by lang_main, lang
);
