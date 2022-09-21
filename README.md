# common-crawl

Code for processing common crawl files

https://commoncrawl.org/2022/08/august-2022-crawl-archive-now-available/

```
curl https://data.commoncrawl.org/crawl-data/CC-MAIN-2022-33/warc.paths.gz | gzip -d > paths.txt

# TODO loop through paths
wget https://data.commoncrawl.org/crawl-data/CC-MAIN-2022-33/segments/1659882570651.49/warc/CC-MAIN-20220807150925-20220807180925-00000.warc.gz
```
