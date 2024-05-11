---------------------------------------------------------------------
-- dr_client (C) CompanyName, All Rights Reserved
-- Created by: AuthorName
-- Date: 2024-03-22 15:52:00
---------------------------------------------------------------------

-- To edit this template in: Data/Config/Template.lua
-- To disable this template, check off menuitem: Options-Enable Template File

---@class HeroEquipConst
local HeroEquipConst = {}


--装备位置
HeroEquipConst.Position =
{
	Equip_Position_1 = 1,--武器
	Equip_Position_2 = 2,--衣服
	Equip_Position_3 = 3,--头
	Equip_Position_4 = 4,--鞋子
}

HeroEquipConst.EquipColor = {
	EquipColor_White = 1,--
	EquipColor_Green = 2,--
	EquipColor_Blue = 3,--
	EquipColor_Purple = 4,--
	EquipColor_Orange = 5,--
}

HeroEquipConst.EquipSlot = 4
HeroEquipConst.EquipPromoteStage = 5

HeroEquipConst.EQUIP_ICON = "110100"
return HeroEquipConst