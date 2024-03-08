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
group by tld, lang
order by tld asc, count desc;

select *
from tld_lang_all
where rank <= 20
format JSONColumns;

-- TODO additional query most diverse vs least diverse tlds (top lang percent max min)