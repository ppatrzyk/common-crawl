# common-crawl

Code for ingesting and analyzing common crawl index files ([February/March 2024 Crawl Archive](https://data.commoncrawl.org/crawl-data/CC-MAIN-2024-10/index.html))

1. server requirements

- install [clickhouse](https://clickhouse.com/docs/en/install#install-from-deb-packages)
- install redis server
- `pip3 install -r requirements.txt` from this repo
- install systemd services from [config](config) folder


2. trigger jobs

```
# from ingest
curl https://data.commoncrawl.org/crawl-data/CC-MAIN-2024-10/cc-index-table.paths.gz | gzip -d > index_paths.txt
python3 create_tasks.py
```

3. run transformation queries

```
# once all data from previous step loaded
cat queries/q0_create_tables.sql | clickhouse-client --database internet --user clickhouse --multiline --multiquery --ask-password
cat queries/q1_top_langs.sql | clickhouse-client --database internet --user clickhouse --multiline --multiquery --ask-password > analysis/q1_top_langs.json
cat queries/q2_tld_top_langs.sql | clickhouse-client --database internet --user clickhouse --multiline --multiquery --ask-password > analysis/q2_tld_top_langs.json
cat queries/q3_secondary_langs.sql | clickhouse-client --database internet --user clickhouse --multiline --multiquery --ask-password > analysis/q3_secondary_langs.json
cat queries/q4_secondary_lang_prevalence.sql | clickhouse-client --database internet --user clickhouse --multiline --multiquery --ask-password > analysis/q4_secondary_lang_prevalence.json
cat queries/q5_secondary_lang_top_primaries.sql | clickhouse-client --database internet --user clickhouse --multiline --multiquery --ask-password > analysis/q5_secondary_lang_top_primaries.json
```
