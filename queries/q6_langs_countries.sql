-- language vs country-level tld
-- https://github.com/datasets/country-codes
select lang, country, perc_of_tld
from tld_lang_all
inner join
(
    select 
        TLD,
        substring(TLD, 2) as tld,
        `ISO3166-1-Alpha-3` as country
    from url('https://r2.datahub.io/clt97y5hy0000jz087j66iiuk/master/raw/data/country-codes.csv', 'CSVWithNames')
) c
using tld
order by lang asc, count desc
format JSONColumns;
