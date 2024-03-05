import clickhouse_driver
import logging
import os
import pathlib
import requests

CONN_STR = "clickhouse://clickhouse:clickhouse@localhost:9000/internet"
# adjust this path
DIR = "/home/piotr/Documents/Github/common-crawl/data_clickhouse/user_files"

CLICKHOUSE_SQL = """
insert into sites 
select 
    url_host_name,
    url_path,
    url_host_tld,
    url_host_registered_domain,
    content_languages,
    splitByChar(',', assumeNotNull(content_languages))[1]
from file(%(file)s);
"""

def _get_file(segment_path, file):
    """
    Get new segment file
    """
    url = f'https://data.commoncrawl.org/{segment_path}'
    r = requests.get(url, stream=True)
    with open(file, "wb") as f:
        for chunk in r.iter_content(chunk_size=1024):
            if chunk:
                f.write(chunk)
    return True

def insert_urls(segment_path):
    """
    Execute sql
    """
    file_name = segment_path.split("/")[-1]
    file_path = os.path.join(DIR, file_name)
    try:
        assert _get_file(segment_path, file_path), "Failed to download"
        logging.info("Downloaded")
        with clickhouse_driver.dbapi.connect(CONN_STR) as conn:
            cursor = conn.cursor()
            cursor.execute(operation=CLICKHOUSE_SQL, parameters={"file": file_name})
    except Exception as e:
        logging.warning(f"Failed to insert {segment_path}; error: {str(e)}")
        raise e
    finally:
        try:
            os.remove(file_path)
            pass
        except:
            pass
    return True
