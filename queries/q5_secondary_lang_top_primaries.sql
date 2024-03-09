-- where each lang is most common as a secondary language
select 
    lang,
    lang_main,
    rank_as_secondary
from 
(
    select 
        lang,
        lang_main,
        rank as rank_as_secondary,
        rank() over (partition by lang order by rank asc, lang_main desc) as rank_top_lang_main
    from internet.host_secondary_langs
    where lang_main != lang
)
where rank_top_lang_main <= 20
order by lang asc, rank_as_secondary asc
format JSONColumns;
