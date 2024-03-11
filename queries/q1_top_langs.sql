select
    lang,
    perc_sites
from
(
    select
        lang,
        count(*) as count,
        sum(count) over () as total,
        round(100 * count / total, 2) as perc_sites
    from internet.sites
    where lang != ''
    group by lang
)
order by count desc
limit 20
format JSONColumns;
