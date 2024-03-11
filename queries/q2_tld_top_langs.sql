-- top 20 languages by tld
select tld, lang, perc_of_tld
from tld_lang_all
where rank <= 20
order by tld asc, count desc
format JSONColumns;
