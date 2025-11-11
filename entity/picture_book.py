"""
@Author: ljp
@Time: 2025/11/11
@Desc: 绘本实体类
"""
from entity.character import Character


class PictureBook(object):
    """绘本实体类"""
    # 绘本id
    _id: str
    # 绘本name
    _name: str
    # 绘本封面 //使用对象存储服务
    _pc_cover:str
    # 角色列表
    _character_list: list[Character]
    # 绘本页数
    _page_count: int
    # 绘本集id
    _pc_bk_id: str

    # 带参数的构造函数
    def __init__(self, id: str = "", name: str = "",_pc_cover:str="", character_list=None,
                 page_count: int = 0, set_id: str = ""):
        if character_list is None:
            character_list = []
        self._id = id
        self._name = name
        self._character_list = character_list
        self._page_count = page_count
        self._pc_bk_id = set_id
        self._pc_cover = _pc_cover

    def get_pc_cover(self):
        return self._pc_cover

    def set_pc_cover(self,pc_cover:str):
        self._pc_cover = pc_cover

    def get_pc_bk_id(self):
        return self._pc_bk_id

    def set_pc_bk_id(self,pc_bk_id:str):
        self._pc_bk_id = pc_bk_id

    def get_page_count(self):
        return self._page_count

    def set_page_count(self,page_count:int):
        self._page_count = page_count

    def get_character_list(self):
        return self._character_list

    def set_character_list(self,character_list:list[Character]):
        self._character_list = character_list

    def get_name(self):
        return self._name

    def set_name(self,name:str):
        self._name = name
