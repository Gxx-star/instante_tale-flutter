"""
@Author:  ljp
@Time: 2025/11/11
@Desc: 生成角色
"""
from entity.character import Character
from util.uuid_util import create_uuid

"""
生成三视图图片
"""


def generate_three_view(content: str, img: str = None):
    """生成三视图"""
    return ""


def create_character_entity(name: str, desc: str, main_avatar: str,
                            user_id: str, three_view: str = None, id: str = create_uuid()):
    """生成角色"""
    if three_view is None:
        three_view = generate_three_view()

    return Character(id=id, name=name, desc=desc, main_avatar=main_avatar,
                     three_view=three_view, user_id=user_id)
