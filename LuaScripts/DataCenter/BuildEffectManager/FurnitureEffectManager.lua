--家具界面特效管理器
local FurnitureEffectManager = BaseClass("FurnitureEffectManager")
local ResourceManager = CS.GameEntry.Resource
local TrailFinishDestroyTime = 2

function FurnitureEffectManager:__init()
	self.allEffect = {} --所有特效
	self.timerList = {}
	self.timer_callback = function(request)
		self:OnTimerCallBack(request)
	end
end

function FurnitureEffectManager:__delete()
	self:DestroyAllTimer()--计时器要在加载资源前删除
	self:DestroyAllEffect()
	self.allEffect = {} --所有特效
	self.timerList = {}
end

function FurnitureEffectManager:Startup()
end

function FurnitureEffectManager:DestroyAllEffect()
	for k,v in pairs(self.allEffect) do
		v:Destroy()
	end
	self.allEffect = {}
end

function FurnitureEffectManager:DestroyOneEffect(effect)
	if self.allEffect[effect] ~= nil then
		self.allEffect[effect]:Destroy()
		self.allEffect[effect] = nil
	end
end

--显示一个拖尾特效
function FurnitureEffectManager:ShowOneFurnitureTrailEffect(startPos, endPos, time, callback)
	local request = ResourceManager:InstantiateAsync(UIAssets.UIFurnitureTrailEffect)
	request:completed('+', function()
		if request.isError then
			return
		end
		request.gameObject:SetActive(true)
		SoundUtil.PlayEffect(SoundAssets.Music_Effect_Furniture_Trail)
		local tf = request.gameObject.transform
		if tf ~= nil then
			tf:SetParent(CS.GameEntry.UIContainer)
			tf:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
			tf:Set_position(startPos.x, startPos.y, startPos.z)
			local rectTransform = tf:GetComponent(typeof(CS.UnityEngine.RectTransform))
			if rectTransform ~= nil then
				local lossyScaleX = rectTransform.transform.lossyScale.x
				if lossyScaleX <= 0 then
					lossyScaleX = 1
				end
				local lossyScaleY = rectTransform.transform.lossyScale.y
				if lossyScaleY <= 0 then
					lossyScaleY = 1
				end
				local pos = Vector2.New(((endPos.x - startPos.x) / lossyScaleX + rectTransform.anchoredPosition.x),
						(endPos.y - startPos.y) / lossyScaleY + rectTransform.anchoredPosition.y  )
				rectTransform:DOAnchorPos(pos, time, true):OnComplete(function()
					if callback ~= nil then
						callback()
					end
					self:DestroyOneEffect(request)
					self:ShowOneFurnitureTrailFinishEffect(endPos)
				end):SetEase(CS.DG.Tweening.Ease.Linear)
			end
		end
	end)
	self.allEffect[request] = request
end

function FurnitureEffectManager:ShowOneFurnitureTrailFinishEffect(pos)
	local request = ResourceManager:InstantiateAsync(UIAssets.UIFurnitureTrailFinishEffect)
	request:completed('+', function()
		if request.isError then
			return
		end
		request.gameObject:SetActive(true)
		local tf = request.gameObject.transform
		if tf ~= nil then
			tf:SetParent(CS.GameEntry.UIContainer)
			tf:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
			tf:Set_position(pos.x, pos.y, pos.z)
			self:AddOneTime(TrailFinishDestroyTime, request)
		end
	end)
	self.allEffect[request] = request
end

function FurnitureEffectManager:AddOneTime(time, request)
	local timer = TimerManager:GetInstance():GetTimer(time, self.timer_callback, request, true, false, false)
	timer:Start()
	self.timerList[request] = timer
end

function FurnitureEffectManager:RemoveOneTime(request)
	if self.timerList[request] ~= nil then
		self.timerList[request]:Stop()
		self.timerList[request] = nil
	end
end

function FurnitureEffectManager:OnTimerCallBack(request)
	self:RemoveOneTime(request)
	self:DestroyOneEffect(request)
end

function FurnitureEffectManager:DestroyAllTimer()
	for k,v in pairs(self.timerList) do
		v:Stop()
	end
	self.timerList = {}
end




return FurnitureEffectManager