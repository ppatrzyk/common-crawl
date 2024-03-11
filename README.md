# common-crawl

Code for processing common crawl files

https://www.commoncrawl.org/blog/november-december-2023-crawl-archive-now-available

https://data.commoncrawl.org/projects/hyperlinkgraph/cc-main-2023-may-sep-nov/index.html

1. setup

redis clickhouse running

2. Get paths

```
# url index paths
curl https://data.commoncrawl.org/crawl-data/CC-MAIN-2023-50/cc-index-table.paths.gz | gzip -d > ingest/index_paths.txt
```

3. trigger jobs

```
python3 create_tasks.py
```

TODO create service configs

```
rq-dashboard
rq worker
```

4. run transformation queries

```
cat queries/q0_create_tables.sql | clickhouse-client --database internet --user clickhouse --multiline --multiquery --ask-password
cat queries/q1_top_langs.sql | clickhouse-client --database internet --user clickhouse --multiline --multiquery --ask-password > analysis/q1_top_langs.json
cat queries/q2_tld_top_langs.sql | clickhouse-client --database internet --user clickhouse --multiline --multiquery --ask-password > analysis/q2_tld_top_langs.json
cat queries/q3_secondary_langs.sql | clickhouse-client --database internet --user clickhouse --multiline --multiquery --ask-password > analysis/q3_secondary_langs.json
cat queries/q4_secondary_lang_prevalence.sql | clickhouse-client --database internet --user clickhouse --multiline --multiquery --ask-password > analysis/q4_secondary_lang_prevalence.json
cat queries/q5_secondary_lang_top_primaries.sql | clickhouse-client --database internet --user clickhouse --multiline --multiquery --ask-password > analysis/q5_secondary_lang_top_primaries.json
```

TODO
reinstall no neo4, service configs
pip3 install clickhouse-driver neo4j rq redis requests
map with top foreign lang on country tld
https://github.com/datasets/country-codes
https://github.com/datasets/language-codes
decide on "q6" queries - trash
```
python3 -m http.server
```