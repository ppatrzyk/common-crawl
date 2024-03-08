-- tld-level data
create table if not exists internet.tld_lang_all
(
    tld String,
    lang String,
    total UInt32,
)
engine = MergeTree
order by tld as
select
    tld,
    lang,
    count(*) as total
from sites
where lang != ''
group by tld, lang;

select *
from tld_lang_all
format JSON;
