local UINoInputManager = BaseClass("UINoInputManager")
--共两种界面：1.放在scene层，挡住场景点击 2.放在Dialog层，挡住除guide外UI点击
local function __init(self)
	self:AddListener()
	self.uINoInputType = UINoInputType.Close
end

local function __delete(self)
	self:RemoveListener()
	self.uINoInputType = nil
end

local function Startup()
end

local function AddListener(self)
	EventManager:GetInstance():AddListener(EventId.UINoInput, self.UINoInputSignal)
	EventManager:GetInstance():AddListener(EventId.SetMovingUI, self.UIMovingSignal)
	EventManager:GetInstance():AddListener(EventId.OnSetMigratingUI, self.UIMigrateSignal)
	EventManager:GetInstance():AddListener(EventId.OnEnterDragonUI, self.UIEnterDragonSignal)
	EventManager:GetInstance():AddListener(EventId.OnQuitDragonUI, self.UIQuitDragonSignal)
	EventManager:GetInstance():AddListener(EventId.OnSetEdenUI, self.UISetEdenSignal)
end

local function RemoveListener(self)
	EventManager:GetInstance():RemoveListener(EventId.UINoInput, self.UINoInputSignal)
	EventManager:GetInstance():RemoveListener(EventId.SetMovingUI, self.UIMovingSignal)
	EventManager:GetInstance():RemoveListener(EventId.OnSetMigratingUI, self.UIMigrateSignal)
	EventManager:GetInstance():RemoveListener(EventId.OnEnterDragonUI, self.UIEnterDragonSignal)
	EventManager:GetInstance():RemoveListener(EventId.OnQuitDragonUI, self.UIQuitDragonSignal)
	EventManager:GetInstance():RemoveListener(EventId.OnSetEdenUI, self.UISetEdenSignal)
end

local function UINoInputSignal(uINoInputType)
	DataCenter.UINoInputManager.uINoInputType = uINoInputType
	if uINoInputType == UINoInputType.ShowNoScene then
		if not UIManager:GetInstance():IsWindowOpen(UIWindowNames.UISceneNoInput) then
			UIManager:GetInstance():OpenWindow(UIWindowNames.UISceneNoInput,{anim = true, playEffect = false})
		else
			DataCenter.UINoInputManager:CloseWindow(UIWindowNames.UINoInput)
		end
	elseif uINoInputType == UINoInputType.ShowNoUI then
		if not UIManager:GetInstance():IsWindowOpen(UIWindowNames.UINoInput) then
			UIManager:GetInstance():OpenWindow(UIWindowNames.UINoInput,{anim = true, playEffect = false})
		end
	elseif uINoInputType == UINoInputType.Close then
		DataCenter.UINoInputManager:CloseWindow(UIWindowNames.UINoInput)
		DataCenter.UINoInputManager:CloseWindow(UIWindowNames.UISceneNoInput)
	end
end

local function UIMovingSignal(uiMovingType)
	if uiMovingType == UIMovingType.Open then
		if not UIManager:GetInstance():IsWindowOpen(UIWindowNames.UIMoving) then
			UIManager:GetInstance():OpenWindow(UIWindowNames.UIMoving,{anim = true, playEffect = false})
		end
	elseif uiMovingType == UIMovingType.Close then
		UIManager:GetInstance():DestroyWindow(UIWindowNames.UIMoving,{ anim = false , playEffect = false})
	end
end

local function CloseWindow(self,windowName)
	if (self.uINoInputType == UINoInputType.ShowNoScene and windowName == UIWindowNames.UISceneNoInput) then
		return
	end
	UIManager:GetInstance():DestroyWindow(windowName)
end

local function UIMigrateSignal(uiMigrateType)
	if uiMigrateType == UIMigrateType.Open then
		if not UIManager:GetInstance():IsWindowOpen(UIWindowNames.UIMigrating) then
			UIManager:GetInstance():OpenWindow(UIWindowNames.UIMigrating,{anim = true, playEffect = false})
		end
	elseif uiMigrateType == UIMigrateType.Close then
		UIManager:GetInstance():DestroyWindow(UIWindowNames.UIMigrating,{ anim = false , playEffect = false})
	end
end
local function UISetEdenSignal(uiMigrateType)
	if uiMigrateType == UISetEdenType.Open then
		if not UIManager:GetInstance():IsWindowOpen(UIWindowNames.UIMovingEden) then
			UIManager:GetInstance():OpenWindow(UIWindowNames.UIMovingEden,{anim = true, playEffect = false})
		end
	elseif uiMigrateType == UISetEdenType.Close then
		UIManager:GetInstance():DestroyWindow(UIWindowNames.UIMovingEden,{ anim = false , playEffect = false})
	end
end
local function UIEnterDragonSignal(uiEnterDragonType)
	if uiEnterDragonType == UIEnterDragonType.Open then
		if not UIManager:GetInstance():IsWindowOpen(UIWindowNames.UIEnterDragonWorld) then
			UIManager:GetInstance():OpenWindow(UIWindowNames.UIEnterDragonWorld,{anim = true, playEffect = false})
		end
	elseif uiEnterDragonType == UIEnterDragonType.Close then
		UIManager:GetInstance():DestroyWindow(UIWindowNames.UIEnterDragonWorld,{ anim = false , playEffect = false})
	end
end

local function UIQuitDragonSignal(uiQuitDragonType)
	if uiQuitDragonType == UIQuitDragonType.Open then
		if not UIManager:GetInstance():IsWindowOpen(UIWindowNames.UIEnterDragonWorld) then
			UIManager:GetInstance():OpenWindow(UIWindowNames.UIEnterDragonWorld,{anim = true, playEffect = false})
		end
	elseif uiQuitDragonType == UIQuitDragonType.Close then
		UIManager:GetInstance():DestroyWindow(UIWindowNames.UIEnterDragonWorld,{ anim = false , playEffect = false})
	end
end


UINoInputManager.__init = __init
UINoInputManager.__delete = __delete
UINoInputManager.Startup = Startup
UINoInputManager.AddListener = AddListener
UINoInputManager.RemoveListener = RemoveListener
UINoInputManager.UINoInputSignal = UINoInputSignal
UINoInputManager.CloseWindow = CloseWindow
UINoInputManager.UIMovingSignal =UIMovingSignal
UINoInputManager.UIMigrateSignal = UIMigrateSignal
UINoInputManager.UIEnterDragonSignal = UIEnterDragonSignal
UINoInputManager.UIQuitDragonSignal = UIQuitDragonSignal
UINoInputManager.UISetEdenSignal = UISetEdenSignal
return UINoInputManager