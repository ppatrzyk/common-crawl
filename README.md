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
