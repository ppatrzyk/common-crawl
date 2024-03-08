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

# vertices paths
curl https://data.commoncrawl.org/projects/hyperlinkgraph/cc-main-2023-may-sep-nov/host/cc-main-2023-may-sep-nov-host-vertices.paths.gz | gzip -d > ingest/vertices_paths.txt

# edges paths
curl https://data.commoncrawl.org/projects/hyperlinkgraph/cc-main-2023-may-sep-nov/host/cc-main-2023-may-sep-nov-host-edges.paths.gz | gzip -d > ingest/edges_paths.txt
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
cat queries/q1_tld_lang_all.sql | clickhouse-client --database internet --user clickhouse --multiline --multiquery --ask-password > analysis/q1_tld_lang_all.json
cat queries/q2_secondary_langs.sql | clickhouse-client --database internet --user clickhouse --multiline --multiquery --ask-password > analysis/q2_secondary_langs.json
cat queries/q3_lang_links.sql | clickhouse-client --database internet --user clickhouse --multiline --multiquery --ask-password > analysis/q3_lang_links.json
```

TODO
queries into json based data
plotly js html analysis terminal css style
reinstall no neo4, service configs
pip3 install clickhouse-driver neo4j rq redis requests

```
python3 -m http.server
```