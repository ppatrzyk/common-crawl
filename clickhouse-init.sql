CREATE TABLE internet.sites
(
    host String,
    path String,
    domain String,
    tld String,
    lang_all String,
    lang String,
)
ENGINE = MergeTree
ORDER BY (host, lang);
