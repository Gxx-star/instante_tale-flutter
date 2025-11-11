"""
@author:ljp
@time: 2025/11/11
@desc:角色实体类
"""


class Character(object):
    """角色实体类"""
    # 角色id
    _id: str
    # 角色name
    _name: str
    # 角色描述
    _desc: str
    # 展示主头像
    _main_avatar: str
    # 三视图 //使用对象存储服务
    _three_view: str
    # 用户id
    _user_id:str

    # 带参数的构造函数
    def __init__(self, id: str = "", name: str = "", desc: str = "",
                 main_avatar: str = "", three_view: str = "",user_id:str=""):
        self._id = id
        self._name = name
        self._desc = desc
        self._main_avatar = main_avatar
        self._three_view = three_view
        self._user_id = user_id

