from tasks import insert
from redis import Redis
from rq import Queue, Retry
import re

REDIS = Redis()
QUEUE = Queue(connection=REDIS, default_timeout=3600)

if __name__ == '__main__':
    tasks = list()
    # index paths
    with open("index_paths.txt", "r") as f:
        index_paths = f.readlines()
    index_paths = (re.sub('\n', '', path) for path in index_paths if re.search("subset=warc", path))
    tasks.extend(tuple(Queue.prepare_data(insert, args=(path, "index", ), retry=Retry(max=3)) for path in index_paths))
    # vertices paths
    with open("vertices_paths.txt", "r") as f:
        vertices_paths = f.readlines()
    vertices_paths = (re.sub('\n', '', path) for path in vertices_paths)
    tasks.extend(tuple(Queue.prepare_data(insert, args=(path, "vertices", ), retry=Retry(max=3)) for path in vertices_paths))
    # edges paths
    with open("edges_paths.txt", "r") as f:
        edges_paths = f.readlines()
    edges_paths = (re.sub('\n', '', path) for path in edges_paths)
    tasks.extend(tuple(Queue.prepare_data(insert, args=(path, "edges", ), retry=Retry(max=3)) for path in edges_paths))
    QUEUE.enqueue_many(tasks)
