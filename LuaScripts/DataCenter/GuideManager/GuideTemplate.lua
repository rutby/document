---
--- Created by shimin
--- DateTime: 2021/8/18 11:07
---
local GuideTemplate = BaseClass("GuideTemplate")

function GuideTemplate:__init()
    self.id = 0 --引导id
    self.triggertype = GuideTriggerType.None --触发类型
    self.triggerpara = ""--触发参数  GuideTriggerType.Quest时为任务id, GuideTriggerType.UIPanel时为界面名称
    self.gotype = GuideGoType.None
    self.gobuild = 0--GuideGoType.Build时表示建筑id
    self.type = GuideType.None
    self.para1 = ""--引导参数 self.type = GuideType.ClickButton时按钮路径 = GuideType.ShowTalk时填写多长时间不跳过则自动播放下一步，不填则没有跳过 = GuideType.ClickBuild时则此处填写建筑id，若玩家此时有多个同类建筑，则随机选择一个
    self.forcetype = GuideForceType.Soft--引导类型（强/软）
    self.nextid = -1--下一步引导id  -1表示结束
    self.returnstepid = -1--用于断线后做的引导id
    self.arrowtype = GuideArrowStyle.Finger
    self.para2 = ""--引导参数 self.type = GuideType.ClickButton时表示手指指向的位置，用于按钮位置不准确时
    self.arrowdirection = 0
    self.showcircletype = ShowCircleType.Show--是否显示光圈
    self.waittime = 0--引导等待的时间
    self.para3 = ""--引导参数 self.type = GuideType.ClickButton时表示需要重新排序，且配置id在第一个
    self.para4 = ""--引导参数
    self.tipspic = ""--对话提示spine名称
    self.tipsdirection = ""--对话出现方向
    self.tipsposition = ""--对话屏幕坐标
    self.tipsdialog = ""--对话显示多语言id
    self.dub = ""--引导语音名称
    self.tipswaittime = {}--触发引导，没触发时保存的条件
    self.savedoneid = 0--保存做过的引导id
    self.gototime = ""--timeline跳转时间
    self.para5 = ""

    self.jumptype=nil--跳转类型，当引导不满足跳转类型时，走跳转id
    self.jumppara = nil--跳转参数
    self.jumpid = 0--跳转id
    self.para6 = ""
end

function GuideTemplate:__delete()
    self.id = nil
    self.triggertype = nil
    self.triggerpara = nil
    self.gotype = nil
    self.gobuild = nil
    self.type = nil
    self.para1 = nil
    self.forcetype = nil
    self.nextid = nil
    self.returnstepid = nil
    self.arrowtype = nil
    self.para2 = nil
    self.jumpid = nil
    self.arrowdirection = nil
    self.showcircletype = nil
    self.waittime = nil
    self.para3 = nil
    self.para4 = nil
    self.tipspic = nil
    self.tipsdirection = nil
    self.tipsposition = nil
    self.tipsdialog = nil
    self.dub = nil
    self.savedoneid = nil
    self.gototime = nil
    self.para5 = nil
    self.jumptype = nil
    self.jumppara = nil
    self.para6 = ""
end

function GuideTemplate:InitData(row)
    if row ==nil then
        return
    end
    self.id = row:getValue("id")
    self.triggertype = row:getValue("triggertype")
    self.triggerpara = row:getValue("triggerpara")
    self.gotype = row:getValue("gotype")
    self.type = row:getValue("type")
    self.para1 = row:getValue("para1")
    self.forcetype = row:getValue("forcetype")
    self.nextid = row:getValue("nextid")
    self.returnstepid = row:getValue("returnstepid")
    self.arrowtype = row:getValue("arrowtype")
    self.para2 = row:getValue("para2")
    self.jumpid = row:getValue("jumpid")
    self.arrowdirection = row:getValue("arrowdirection")
    self.showcircletype = row:getValue("showcircletype")
    self.waittime = row:getValue("waittime")
    self.para3 = row:getValue("para3")
    self.para4 = row:getValue("para4")
    self.tipspic = row:getValue("tipspic")
    self.tipsdirection = row:getValue("tipsdirection")
    self.tipsposition = row:getValue("tipsposition")
    self.tipsdialog = row:getValue("tipsdialog")
    self.dub = row:getValue("dub")
    self.tipswaittime = row:getValue("tipswaittime", {})
    self.savedoneid = row:getValue("savedoneid")
    self.gototime = row:getValue("gototime")
    self.para5 = row:getValue("para5")
    self.jumptype = row:getValue("jumptype")
    self.jumppara = row:getValue("jumppara")
    self.para6 = row:getValue("para6") or ""
end

--获取自动跳过的时间(秒)
function GuideTemplate:GetAutoDoNextTime()
    local time = 0
    if self.type == GuideType.ShowTalk or self.type == GuideType.ShowGuideTip or self.type == GuideType.ShowCommunicationTalk then
        if self.para1 ~= nil and self.para1 ~= "" then
            time = tonumber(self.para1)
        end
    end
    return time
end

return GuideTemplate