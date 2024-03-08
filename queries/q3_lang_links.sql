-- #######################################################
-- TODO remove this entire section, replace by host_links in subsequent query
-- fake host_links
CREATE TABLE if not exists internet.host_links_fake
(
    from_host_id UInt32,
    to_host_id UInt32,
)
ENGINE = MergeTree
ORDER BY (from_host_id, to_host_id) as
select cast(randUniform(1, 214392), 'UInt32') as from_host_id, t.to_host_id
from hosts
inner join
(
    select host_id, cast(randUniform(1, 214392), 'UInt32') as to_host_id
from hosts
) as t
using host_id;
-- #######################################################

-- hosts + lang_main
-- select host_rev, lang_main, host_id
-- from host_lang_main
-- inner join hosts
-- using host_rev
-- where single_lang_host = true;

-- lang-lang links fake
CREATE TABLE if not exists internet.lang_links
(
    from_lang String,
    to_lang String,
    count UInt32
)
ENGINE = MergeTree
ORDER BY (from_lang, to_lang) as
select l1.from_lang, l2.to_lang, count(*) as count
from host_links_fake
left outer join
(
    -- fake hosts + lang_main, replace
    select lang_main as from_lang, row_number() over (order by host_rev) AS host_id
    from host_lang_main
) l1
on host_links_fake.from_host_id = l1.host_id
left outer join
(
    -- fake hosts + lang_main, replace
    select lang_main as to_lang, row_number() over (order by host_rev) AS host_id
    from host_lang_main
) l2
on host_links_fake.to_host_id = l2.host_id
group by l1.from_lang, l2.to_lang;

select * 
from internet.lang_links
format JSON;
