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

-- 
-- #######################################################
-- TODO remove this entire section, replace by host_links in subsequent query
-- fake host_links
CREATE TABLE if not exists internet.host_links_fake
(
    from_host_id UInt32,
    to_host_id UInt32,
)
ENGINE = MergeTree
ORDER BY (from_host_id, to_host_id) as
select cast(randUniform(1, 214392), 'UInt32') as from_host_id, t.to_host_id
from hosts
inner join
(
    select host_id, cast(randUniform(1, 214392), 'UInt32') as to_host_id
from hosts
) as t
using host_id;
-- #######################################################

-- hosts + lang_main
-- select host_rev, lang_main, host_id
-- from host_lang_main
-- inner join hosts
-- using host_rev
-- where single_lang_host = true;

-- lang-lang links fake
CREATE TABLE if not exists internet.lang_links
(
    from_lang String,
    to_lang String,
    count UInt32,
    rank UInt32,
    total_from_lang UInt32,
    perc_links Float32
)
ENGINE = MergeTree
ORDER BY (from_lang, to_lang) as
select 
    l1.from_lang,
    l2.to_lang,
    count(*) as count,
    rank() over (partition by l1.from_lang order by count desc, l2.to_lang desc) as rank,
    sum(count) over (partition by l1.from_lang) as total_from_lang,
    round(100 * count / total_from_lang, 2) as perc_links
from host_links_fake
left outer join
(
    -- fake hosts + lang_main, replace
    select lang_main as from_lang, row_number() over (order by host_rev) AS host_id
    from host_lang_main
) l1
on host_links_fake.from_host_id = l1.host_id
left outer join
(
    -- fake hosts + lang_main, replace
    select lang_main as to_lang, row_number() over (order by host_rev) AS host_id
    from host_lang_main
) l2
on host_links_fake.to_host_id = l2.host_id
group by l1.from_lang, l2.to_lang;
