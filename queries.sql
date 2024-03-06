create table internet.host_lang_counts
(
    host String,
    host_rev String,
    lang_count UInt32,
    single_lang_host Boolean
)
engine = MergeTree
order by host as
select
    host,
    any(host_rev),
    count(distinct(lang)) as lang_count,
    (lang_count == 1) as single_lang_host
from sites
where lang != ''
group by host;

create table internet.host_lang_combinations
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

create table internet.host_top_lang
(
    host String,
    top_lang String
)
engine = MergeTree
order by host as
select
    host,
    argMax(lang, total) as top_lang
from internet.host_lang_combinations
group by host;

-- what language go together most commonly
-- set intersections, most common pairs?
-- for each lang get sums of all other lang occurencies