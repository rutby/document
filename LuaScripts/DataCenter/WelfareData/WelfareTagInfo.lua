---@class WelfareTagInfo 福利中心页签信息
WelfareTagInfo = BaseClass("WelfareTagInfo")
local M        = WelfareTagInfo

function M:ctor()
    self._id        = -1
    ---@type WelfareTagType
    self._type      = WelfareTagType.Unknown    -- 页签类型
    self._name      = ""                        -- 页签名称
    self._isHot     = false                     -- 是否显示热门角标
    self._order     = 0                         -- 页签排序权重，越小越靠前
    self._iconOrder = 0                         -- 页签对应的 icon 的排序权重 越小越靠前
    self._imagePath = ""
    self._icon      = ""                        -- 页签对应的icon 显示在主UI第二个入口
    self._showIcon  = false                     -- 是否展示icon
    self._iconUnlockLv = 0                         -- icon解锁等级
    self._isOff     = false                     -- 页签是否显示 默认为false显示页签 为true不显示
    self.activity_daily = 0                    --显示位置
end

---@param data BaseXmlData
---@return boolean
function M:parse(data)
    if data == nil then
        return false
    end

    self._id        = tonumber(data:getValue("id"))
    self._type      = tonumber(data:getValue("type"))
    self._name      = tonumber(data:getValue("name"))
    self._isHot     = tonumber(data:getValue("hot")) == 1
    self._order     = tonumber(data:getValue("order"))
    self._imagePath = tonumber(data:getValue("id"))
    self._icon      = tostring(data:getValue("icon"))
    self._showIcon  = tonumber(data:getValue("show_icon")) == 1 or tonumber(data:getValue("show_icon")) == 2
    self._iconPos   = tonumber(data:getValue("show_icon")) 
    self._isOff     = tonumber(data:getValue("onoff")) == 1         -- 这字段命名真难受。。。 实际含义代表是否关闭 为1就是关闭 0或null就是打开
    self._iconUnlockLv = tonumber(data:getValue("unlock_lv"))       -- 这个字段只是代表icon解锁等级，页签是否显示不受影响
    self._iconOrder = tonumber(data:getValue("icon_order"))
    self.activity_daily = tonumber(data:getValue("activity_daily"))
    return true
end

function M:getID()
    return self._id
end

---@return WelfareTagType
function M:getType()
    return self._type
end

function M:isSpecialPackTag()
    return WelfareController.isSpecialPackTag(self:getType())
end

function M:getDailyType()
    return self.activity_daily
end

function M:isHot()
    return self._isHot
end

function M:getOrder()
    return self._order
end

function M:GetOrder()
    return self._order
end

function M:getIconOrder()
    return self._iconOrder
end

function M:getName()
    return self._name
end

--- 目前仅用于特殊礼包，因为特殊礼包的 Icon 名字使用第一个礼包的名字
function M:getNameForIcon()
    return self._name
end

function M:getImagePath()
    return self._imagePath
end

---@return string icon prefab 名字
function M:getIconName()
    return self._icon
end

function M:isShowIcon()
    return self._showIcon
end

function M:iconPos()
    return self._iconPos
end

function M:isUnlockIcon(level)
    if self._iconUnlockLv == nil then
        return true
    else
        return level >= self._iconUnlockLv
    end
end

---新增字段控制是否显示 子类实现时需调用超类方法
function M:isShow()
    return (not _isOff) and self:isUnlockIcon(DataCenter.BuildManager.MainLv)
end

function M:hasRedPoint()
    return false
end

function M:getRedDotNum()
    return 0
end

function M:hasSpecialBg()
    return false
end

--- 目前有的背景是长的 有的是短的。。。 先这么处理下
function M:isFullBg()
    return false
end

--临时 子类重写写死名字 之后有需求从配置转换
function M:getBgName()
    return ""
end

---@param isSort boolean 是否排序，默认排序
---@return GiftPackInfoDefault[]
function M:getPackList(isSort)
    return {}
end

function M:GetPveShowPacks()
    local packIds = {}
    local lineData = LocalController:instance():getLine("recharge", tostring(self._id))
    local para1 = lineData:getValue("para1")
    if not string.IsNullOrEmpty(para1) then
        for _, packId in ipairs(string.split(para1, ";")) do
            table.insert(packIds, packId)
        end
    end
    return packIds
end

function M:GetPveShowLevels()
    local pveLevels = {}
    local lineData = LocalController:instance():getLine("recharge", tostring(self._id))
    local para2 = lineData:getValue("para2")
    if not string.IsNullOrEmpty(para2) then
        for _, str in ipairs(string.split(para2, ";")) do
            table.insert(pveLevels, tonumber(str))
        end
    end
    return pveLevels
end

return M