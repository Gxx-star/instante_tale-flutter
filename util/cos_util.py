"""
@author: ljp
@desc: 对象存储服务工具
@time: 2021/11/11
"""
from util.cos_client import cos_client, base_url, bucket
from util.uuid_util import create_uuid
import requests

# 上传文件因为url
async def cos_upload_file_for_url(url:str):
    key = "img-" + create_uuid()
    return_url = ""
    try:
        stream = requests.get(url)
        cos_client.put_object(
            Bucket=bucket,
            Body=stream,
            Key=key
        )
        return_url =  base_url + key
    except Exception as e:
        print(e)
    finally:
        return return_url
# 上传文件因为文件
async def cos_upload_file_for_file(localPath:str,):
    key = "img-" + create_uuid()
    url= ""
    try:
        cos_client.upload_file(
            Bucket=bucket,
            LocalFilePath=localPath,
            Key=key,
            PartSize=1,
            MAXThread=10,
            EnableMD5=False
        )
        url = base_url + key
    except Exception as e:
        print(e)
    finally:
        return url
# 上传文件因为数据
def cos_upload_file_for_data():
    pass
# 下载文件
def cos_download_file():
    pass

