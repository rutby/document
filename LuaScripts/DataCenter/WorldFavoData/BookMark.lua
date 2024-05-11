---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by guqu.
--- DateTime: 2020/10/29 16:51
---
local BookMark = BaseClass("BookMark")

local function __init(self)
    self.pos = 0                 --地块坐标
    self.server = -1                      --服务器id
    self.name =""                     --书签名称
    self.type = 0                       --收藏夹类型（分类标签：0.特殊 1.朋友 2.敌人 3.个人标记）
    self.createTime = 0                 --创建时间（排序用）
    self.topFlag = 0                     --是否置顶
end

local function __delete(self)
    self.pos =nil
    self.server = nil
    self.name =nil
    self.type = nil
    self.createTime = nil
    self.topFlag = nil
end
local function ParseData(self, message)
    if message ==nil then
        return
    end
    if message["point"]~=nil  then
        self.pos = message["point"]
    end
    if message["server"]~=nil  then
        self.server = message["server"]
    end
    if message["name"]~=nil  then
        self.name = message["name"]
    end
    if message["type"]~=nil  then
        self.type = message["type"]
    end
    if message["createTime"]~=nil  then
        self.createTime = message["createTime"]
    end
    if message["topFlag"]~=nil  then
        self.topFlag = message["topFlag"]
    end
end


BookMark.__init = __init
BookMark.__delete = __delete
BookMark.ParseData = ParseData
return BookMark