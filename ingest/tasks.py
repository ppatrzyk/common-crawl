import clickhouse_driver
import logging
import os
import requests

CLICKHOUSE_CONN_STR = "clickhouse://clickhouse:clickhouse@localhost:9000/internet"
# adjust this path
DIR = "/home/piotr/Documents/Github/common-crawl/data_clickhouse/user_files"

QUERIES = {
    "index": """
        insert into internet.sites 
        select 
            url_host_name,
            url_host_name_reversed,
            url_path,
            url_host_registered_domain,
            url_host_tld,
            content_languages,
            splitByChar(',', assumeNotNull(content_languages))[1]
        from file(%(file)s);
    """,
    "vertices": """
        insert into internet.hosts
        select *
        from file(%(file)s, 'TSV', 'host_id UInt32, host_rev String', 'gz')
    """,
    "edges": """
        insert into internet.host_links
        select *
        from file(%(file)s, 'TSV', 'from_host_id UInt32, to_host_id UInt32', 'gz')
    """,
}

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

def _gen_file_name(segment_path):
    """
    Generate file name from file paths
    """
    file_name = segment_path.split("/")[-1]
    file_path = os.path.join(DIR, file_name)
    return file_name, file_path

def insert(segment_path, query_key):
    """
    Execute sql
    """
    file_name, file_path = _gen_file_name(segment_path)
    try:
        assert _get_file(segment_path, file_path), "Failed to download"
        with clickhouse_driver.dbapi.connect(CLICKHOUSE_CONN_STR) as conn:
            cursor = conn.cursor()
            cursor.execute(operation=QUERIES.get(query_key), parameters={"file": file_name})
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
