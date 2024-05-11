--- Created by shimin.
--- DateTime: 2022/7/13 15:34
--- Pve采集物上血量条
local CollectionBlood = BaseClass("CollectionBlood")
local Resource = CS.GameEntry.Resource

local hp_spr_path = "hp"

local SprWidth = 1.38
local SprHeight = 0.17

function CollectionBlood:__init(param)
    self.req = nil
    self.gameObject = nil
    self.transform = nil
    self.param = param
    self:Create()
end

function CollectionBlood:Destroy()
    if self.req ~= nil then
        self.req:Destroy()
    end
    self.transform = nil
    self.gameObject = nil
end

function CollectionBlood:Create()
    if self.req == nil then
        self.req = Resource:InstantiateAsync(UIAssets.CollectionBlood)
        self.req:completed('+', function()
            self.gameObject = self.req.gameObject
            self.transform = self.req.gameObject.transform
            self.transform.position = self.param.pos
            self:InitComponent()
            self.gameObject:SetActive(self.param.visible)
            self:RefreshCameraRotation(self.param.rotation)
            self:RefreshBlood(self.param.curBlood, self.param.maxBlood)
        end)
    end
end

function CollectionBlood:InitComponent()
    self.hp_spr = self.transform:Find(hp_spr_path):GetComponent(typeof(CS.UnityEngine.SpriteRenderer))
end

function CollectionBlood:SetVisible(visible)
    if self.param.visible ~= visible then
        self.param.visible = visible
        if self.gameObject ~= nil then
            self.gameObject:SetActive(visible)
        end
    end
end

function CollectionBlood:RefreshCameraRotation(rotation)
    if self.param.visible and self.transform ~= nil then
        self.transform.rotation = rotation
    else
        self.param.rotation = rotation
    end
end

function CollectionBlood:RefreshBlood(curBlood, maxBlood)
    if self.param.visible and self.hp_spr ~= nil then
        self.hp_spr.size = Vector2.New((curBlood / maxBlood * SprWidth), SprHeight)
    else
        self.param.curBlood = curBlood
        self.param.maxBlood = maxBlood
    end
end


return CollectionBlood