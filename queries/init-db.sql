CREATE TABLE if not exists internet.sites
(
    host String,
    host_rev String,
    path String,
    domain String,
    tld String,
    lang_all String,
    lang String,
)
ENGINE = MergeTree
ORDER BY (host, lang);
-- SETTINGS storage_policy = 'disk_name_1';
