local UIHeroTrialRewardCell = BaseClass("UIHeroTrialRewardCell", UIBaseContainer)
local base = UIBaseContainer
local UICommonItem = require "UI.UICommonItem.UICommonItem"

local tipTxt_path = "Tip"
local content_path = "rewardBg/Rewards"
local selfRankBg_path = "rewardBg/selfRankBg"


function UIHeroTrialRewardCell:OnCreate()
    base.OnCreate(self)

    self.rewardModels ={}
    self.rewardItemsList = {}
    
    self.tipN = self:AddComponent(UITextMeshProUGUIEx, tipTxt_path)
    self.contentN = self:AddComponent(UIBaseContainer, content_path)
    self.selfRankBgN = self:AddComponent(UIBaseContainer, selfRankBg_path)

    self.starTagObj = {}
    for i = 1, 5 do
        local star = { imageObj = self:AddComponent(UIImage,"rewardBg/Star/Image"..i) }
        table.insert(self.starTagObj, star)
    end
end

function UIHeroTrialRewardCell:OnDestroy()
    self.rewardModels = nil
    self.rewardItemsList = nil

    self.titleN = nil
    self.tipN = nil
    self.contentN = nil
	self.starTagObj = {}
    base.OnDestroy(self)
end


function UIHeroTrialRewardCell:ShowRewards(param,isSelf,index)
    -- self.selfRankBgN:SetActive(isSelf)
    self:SetAllRewardsDestroy()
    self.rewardModelCount =0
    for i = 1, #self.starTagObj do
        self.starTagObj[i].imageObj.gameObject:SetActive(i <= index)
    end
    local list = param.reward
    if list~=nil and #list>0 then
        for i = 1, table.length(list) do
            --复制基础prefab，每次循环创建一次
            self.rewardModelCount= self.rewardModelCount+1
            self.rewardModels[self.rewardModelCount] = self:GameObjectInstantiateAsync(UIAssets.UICommonItemSize, function(request)
                if request.isError then
                    return
                end
                local go = request.gameObject;
                go.gameObject:SetActive(true)
                go.transform:SetParent(self.contentN.transform)
                go.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
                local nameStr = tostring(NameCount)
                go.name = nameStr
                NameCount = NameCount + 1
                local cell = self.contentN:AddComponent(UICommonItem,nameStr)
                cell:ReInit(list[i])
                table.insert(self.rewardItemsList,cell)
            end)
        end
    end
end

function UIHeroTrialRewardCell:SetAllRewardsDestroy()
    self.contentN:RemoveComponents(UICommonItem)
    if self.rewardModels~=nil then
        for k,v in pairs(self.rewardModels) do
            if v ~= nil then
                self:GameObjectDestroy(v)
            end
        end
    end
    self.rewardModels ={}
    self.rewardItemsList = {}
end

return UIHeroTrialRewardCell