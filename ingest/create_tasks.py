from tasks import insert_urls
from redis import Redis
from rq import Queue, Retry
import re

REDIS = Redis()
QUEUE = Queue(connection=REDIS, default_timeout=3600)

if __name__ == '__main__':
    with open("paths.txt", "r") as f:
        paths = f.readlines()
    paths = (re.sub('\n', '', path) for path in paths if re.search("subset=warc", path))
    paths = tuple(paths)[:1]
    tasks = [Queue.prepare_data(insert_urls, args=(path, ), retry=Retry(max=3)) for path in paths]
    QUEUE.enqueue_many(tasks)
