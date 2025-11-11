# -*- coding=utf-8
from qcloud_cos  import CosConfig
from qcloud_cos  import CosS3Client
import sys
import os
import logging

# 正常情况日志级别使用 INFO，需要定位时可以修改为 DEBUG，此时 SDK 会打印和服务端的通信信息
logging.basicConfig(level=logging.INFO, stream=sys.stdout)

# 1. 设置用户属性, 包括 secret_id, secret_key, region等。Appid 已在 CosConfig 中移除，请在参数 Bucket 中带上 Appid。Bucket 由 BucketName-Appid 组成
secret_id = "AKIDnWcl7Yv9HKG3kIj1KWdbQ6d2MYbXKyTp"     # 用户的 SecretId，建议使用子账号密钥，授权遵循最小权限指引，降低使用风险。子账号密钥获取可参见 https://cloud.tencent.com/document/product/598/37140
secret_key = "To03RpCSa7XowvkQxQm07IMI9jNCBC8y"   # 用户的 SecretKey，建议使用子账号密钥，授权遵循最小权限指引，降低使用风险。子账号密钥获取可参见 https://cloud.tencent.com/document/product/598/37140
region = 'ap-beijing'      # 替换为用户的 region，已创建桶归属的 region 可以在控制台查看，https://console.cloud.tencent.com/cos5/bucket
                           # COS 支持的所有 region 列表参见 https://cloud.tencent.com/document/product/436/6224
scheme = 'https'           # 指定使用 http/https 协议来访问 COS，默认为 https，可不填

config = CosConfig(Region=region, SecretId=secret_id, SecretKey=secret_key, Scheme=scheme)
cos_client = CosS3Client(config)

base_url =  "https://draw-1369048677.cos.ap-beijing.myqcloud.com/"
bucket = 'draw-1369048677'
#### 高级上传接口（推荐）
# 根据文件大小自动选择简单上传或分块上传，分块上传具备断点续传功能。
if __name__ == "__main__":
    response = cos_client.upload_file(
        Bucket=bucket,
        LocalFilePath='C:/Users/ljp/PycharmProjects/instant_tale/require_txt.txt',
        Key='require_txt.txt',
        PartSize=1,
        MAXThread=10,
        EnableMD5=False
    )

    # pp
    print(response)