-- most prevalent language to be used as secondary ones
select 
    lang,
    median(rank) as median_rank,
    round(avg(rank), 2) as avg_rank,
    round(avg(perc_sites), 2) as avg_perc_sites
from internet.host_secondary_langs
where lang_main != lang
group by lang
order by avg_rank asc
limit 20
format JSONColumns;