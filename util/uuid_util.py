"""
@Author:ljp
@Time:2025/11/11
@desc:uuid工具类
"""
from datetime import datetime
import uuid


def create_uuid(name="", namespace=uuid.NAMESPACE_DNS):
    if name == "":
        name = datetime.now().strftime("%H:%M:%S")
    return uuid.uuid5(namespace, name)


if __name__ == "__main__":
    print(create_uuid())
