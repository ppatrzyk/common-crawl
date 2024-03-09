-- TODO additional query most diverse vs least diverse tlds (top lang percent max min)
-- TODO finish on complete data
select 
    tld,
    lang as most_common_lang,
    perc_of_tld
from tld_lang_all
where rank == 1
order by perc_of_tld desc;
