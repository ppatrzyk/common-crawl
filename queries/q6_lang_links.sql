-- links between hosts, how often sites in one lang link to sites in other lang
select 
    from_lang,
    to_lang,
    perc_links
from internet.lang_links
where rank <= 20
order by from_lang asc, count desc
format JSONColumns;
