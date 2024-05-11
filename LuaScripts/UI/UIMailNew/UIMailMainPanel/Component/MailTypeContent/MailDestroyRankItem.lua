---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Imaginaerum.
--- DateTime: 2022/2/23 16:39
---
local MailDestroyRankItem = BaseClass("MailDestroyRankItem",UIBaseContainer)
local base = UIBaseContainer
local RewardUtil = require "Util.RewardUtil"
local Localization = CS.GameEntry.Localization
local bg_path = "bg"
local name_txt_path = "bg/name_txt"
local num_txt_path = "bg/num_txt"
local reward_txt_path = "bg/reward_txt"
local reward_icon_path = "bg/reward_txt/reward_icon"
local head_obj_path = "bg/UIPlayerHead"
local player_head_path = "bg/UIPlayerHead/HeadIcon"
local headFg_path = "bg/UIPlayerHead/Foreground"
local titleBg_path = "titleBg"
local titleName_path = "titleBg/titleName"
local titleHurt_path = "titleBg/titleHurt"
local titleReward_path = "titleBg/titleReward"
local first_flag_path = "bg/firstImg"
local second_flag_path = "bg/secondImg"
local third_flag_path = "bg/thirdImg"
local rank_txt_path = "bg/rank_txt"
local A_Color = Color.New(0.9607843,0.8941177,0.8,1)
local Self_Color = Color.New(0.9921569,0.8627451,0.5607843,1)
local B_Color = Color.New(0.9607843,0.8666667,0.7411765,1)
function MailDestroyRankItem:OnCreate()
    base.OnCreate(self)
    self.bg = self:AddComponent(UIImage, bg_path)
    self.head_obj = self:AddComponent(UIBaseContainer,head_obj_path)
    self.titleBg = self:AddComponent(UIBaseContainer,titleBg_path)
    self.title_Name = self:AddComponent(UITextMeshProUGUIEx,titleName_path)
    self.title_Hurt = self:AddComponent(UITextMeshProUGUIEx,titleHurt_path)
    self.title_Reward = self:AddComponent(UITextMeshProUGUIEx,titleReward_path)
    self.player_head = self:AddComponent(UIPlayerHead,player_head_path)
    self.playerHeadFg = self:AddComponent(UIImage, headFg_path)
    self.name_txt = self:AddComponent(UITextMeshProUGUIEx,name_txt_path)
    self.num_txt = self:AddComponent(UITextMeshProUGUIEx,num_txt_path)
    self.rank_txt = self:AddComponent(UITextMeshProUGUIEx,rank_txt_path)
    self.reward_txt = self:AddComponent(UITextMeshProUGUIEx,reward_txt_path)
    self.reward_icon = self:AddComponent(UIImage,reward_icon_path)

    self.first_flag = self:AddComponent(UIBaseContainer,first_flag_path)
    self.second_flag = self:AddComponent(UIBaseContainer,second_flag_path)
    self.third_flag = self:AddComponent(UIBaseContainer,third_flag_path)
end

function MailDestroyRankItem:SetData(isTitle,rankType,rankData)
    if isTitle then
        self.titleBg:SetActive(true)
        self.bg:SetActive(false)
        -- self.bg:SetColor(A_Color)
        -- self.head_obj:SetActive(false)
        self.title_Name:SetText(Localization:GetString("110188"))
        if rankType == DestroyRankType.Blood then
            self.title_Hurt:SetText(Localization:GetString("110186"))
        else
            self.title_Hurt:SetText(Localization:GetString("110187"))
        end
        self.title_Reward:SetText(Localization:GetString("130065"))
        -- self.reward_icon:SetActive(false)
    else
        self.bg:SetActive(true)
        self.titleBg:SetActive(false)
        local rank = rankData.rank
        self.first_flag:SetActive(rank ==1)
        self.third_flag:SetActive(rank ==3)
        self.second_flag:SetActive(rank ==2)
        self.rank_txt:SetActive(rank >3)
        if rank>3 then
            self.bg:LoadSprite("Assets/Main/Sprites/UI/UIArena/arena_img_columns04.png")
            self.rank_txt:SetText(rank)
        else
            self.bg:LoadSprite("Assets/Main/Sprites/UI/UIArena/arena_img_columns0" .. rank)
        end
        local playerInfo = rankData.playerInfo
        local uid = playerInfo.uid
        if uid == LuaEntry.Player.uid then
            self.bg:SetColor(Self_Color)
        end
        local userPic = playerInfo.pic or ""
        local userPicVer = playerInfo.picVer or 0
        local name = playerInfo.name
        local userinfo = ChatInterface.getUserData(uid)
        if userinfo~=nil then
            userPic = userinfo["headPic"] or ""
            userPicVer = userinfo["headPicVer"] or 0
            --name = userinfo["userName"]
            local tempFg = userinfo:GetHeadBgImg()
            if tempFg then
                self.playerHeadFg:SetActive(true)
                self.playerHeadFg:LoadSprite(tempFg)
            else
                self.playerHeadFg:SetActive(false)
            end
        end
        self.player_head:SetData(uid, userPic, userPicVer)
        self.name_txt:SetText(name)
        self.num_txt:SetText(string.GetFormattedSeperatorNum(rankData.scord))
        local rewardList = rankData.rewardInfo
        if rewardList~=nil and table.count(rewardList)>0 then
            local hasGet = false
            for k,v in pairs(rewardList) do
                if hasGet ==false then
                    local rewardItem = v
                    local tempType =RewardType.MONEY
                    local tempId =0
                    local count = 0
                    if rewardItem.type~=nil then
                        tempType = rewardItem.type.value
                    end
                    if rewardItem.id~=nil then
                        tempId = rewardItem.id.value
                    end
                    if rewardItem.num~=nil then
                        count = rewardItem.num.value
                    end
                    local pic =RewardUtil.GetPic(tempType,tempId)
                    self.reward_icon:SetActive(true)
                    self.reward_icon:LoadSprite(pic)
                    self.reward_txt:SetText(string.GetFormattedSeperatorNum(count))
                    hasGet = true
                end
            end
            
        else
            self.reward_txt:SetText("-")
            self.reward_icon:SetActive(false)
        end
        
    end
    
end

return MailDestroyRankItem