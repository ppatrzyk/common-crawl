-- most common secondary languages for each primary
select lang_main, lang, perc_sites
from internet.host_secondary_langs
where lang_main != lang and rank <= 21
order by lang_main asc, count desc
format JSONColumns;
