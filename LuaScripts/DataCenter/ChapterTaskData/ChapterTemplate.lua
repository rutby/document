--- 章节表
--- Created by shimin
--- DateTime: 2023/5/10 14:35
---
local ChapterTemplate = BaseClass("ChapterTemplate")

function ChapterTemplate:__init()
    self.id = 0
    self.chapter = 0--章节
    self.base_lv = 0
    self.name = 0--名字
    self.description = 0--描述
    self.pic = ""--图片名字
    self.dialogue = 0
    self.quest = {}--包含的任务id
end

function ChapterTemplate:__delete()
    self.id = 0
    self.chapter = 0--章节
    self.base_lv = 0
    self.name = 0--名字
    self.description = 0--描述
    self.pic = ""--图片名字
    self.dialogue = 0
    self.quest = {}--包含的任务id
end

function ChapterTemplate:InitData(row)
    if row ==nil then
        return
    end
    self.id = row:getValue("id") or 0
    self.chapter = row:getValue("chapter") or 0
    self.description = row:getValue("description") or 0
    self.base_lv = row:getValue("base_lv") or 0
    self.name = row:getValue("name") or 0
    self.pic = row:getValue("pic") or ""
    self.dialogue = row:getValue("dialogue") or 0
    self.quest = row:getValue("quest") or {}
end

return ChapterTemplate