--- 批量使用资源道具
--- Created by shimin.
--- DateTime: 2024/1/18 16:20
local UseResItemMultiMessage = BaseClass("UseResItemMultiMessage", SFSBaseMessage)
local base = SFSBaseMessage

function UseResItemMultiMessage:OnCreate(param)
    base.OnCreate(self)
    if param.goodsArr ~= nil then
        local array = SFSArray.New()
        for k, v in ipairs(param.goodsArr) do
            local obj = SFSObject.New()
            obj:PutUtfString("goodsId", tostring(v.itemId))
            obj:PutInt("count", v.count)
            if v.index then
                obj:PutInt("chooseIndex", v.index)
            end
            array:AddSFSObject(obj)
        end
        self.sfsObj:PutSFSArray("goodsArr", array)
    end
end

function UseResItemMultiMessage:HandleMessage(t)
    base.HandleMessage(self, t)
    DataCenter.ItemManager:UseResItemMultiHandle(t)
end

return UseResItemMultiMessage