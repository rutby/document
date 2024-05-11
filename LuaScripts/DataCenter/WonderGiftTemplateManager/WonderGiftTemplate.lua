---
--- Created by shimin
--- DateTime: 2023/3/17 17:37
--- 王座礼包表管理器
---
local WonderGiftTemplate = BaseClass("WonderGiftTemplate")

function WonderGiftTemplate:__init()
    self.id = 0--礼包id
    self.name = 0--礼包名字
    self.type = 0--礼包类型（国王礼包，精英礼包等）
    self.num = 0--礼包可发放数量
    self.icon = ""--图片名字
    self.worth = 0--礼包价值
end

function WonderGiftTemplate:__delete()
    self.id = 0--礼包id
    self.name = 0--礼包名字
    self.type = 0--礼包类型（国王礼包，精英礼包等）
    self.num = 0--礼包可发放数量
    self.icon = ""--图片名字
    self.worth = 0--礼包价值
end

function WonderGiftTemplate:InitData(row)
    if row == nil then
        return
    end
    self.id = row:getValue("id")
    self.name = row:getValue("name")
    self.type = row:getValue("type")
    self.num = row:getValue("num")
    self.icon = row:getValue("icon")
    self.worth = row:getValue("worth") or 0
end

return WonderGiftTemplate