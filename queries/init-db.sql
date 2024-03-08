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

CREATE TABLE if not exists internet.hosts
(
    host_id UInt32,
    host_rev String,
)
ENGINE = MergeTree
ORDER BY (host_id, host_rev);

CREATE TABLE if not exists internet.host_links
(
    from_host_id UInt32,
    to_host_id UInt32,
)
ENGINE = MergeTree
ORDER BY (from_host_id, to_host_id);
