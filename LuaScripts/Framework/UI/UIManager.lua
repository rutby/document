--[[
-- added by wsh @ 2017-11-30
-- UI管理系统：提供UI操作、UI层级、UI消息、UI资源加载、UI调度、UI缓存等管理
-- 注意：
-- 1、Window包括：Model、Ctrl、View、和Active状态等构成的一个整体概念
-- 2、所有带Window接口的都是操作整个窗口，如CloseWindow以后：整个窗口将不再活动
-- 3、所有带View接口的都是操作视图层展示，如CloseView以后：View、Model依然活跃，只是看不见，可看做切入了后台
-- 4、如果只是要监听数据，可以创建不带View、Ctrl的后台窗口，配置为nil，比如多窗口需要共享某控制model（配置为后台窗口）
-- 5、可将UIManager看做一个挂载在UIRoot上的不完全UI组件，但是它是Singleton，不使用多重继承，UI组件特性隐式实现
--]]

local UIManager = BaseClass("UIManager", Singleton)

local UIRootPath = "GameFramework/UI"
local ResourceManager = CS.GameEntry.Resource
local GameObject = CS.UnityEngine.GameObject
local Sound = CS.GameEntry.Sound
local LayerOrder = { "Scene", "UIResource","Background", "Normal", "Info", "Dialog", "Guide", "TopMost" }
local RectTransform = typeof(CS.UnityEngine.RectTransform)
local Canvas = typeof(CS.UnityEngine.Canvas)
local Input = CS.UnityEngine.Input
local Localization = CS.GameEntry.Localization
local KeyCode_Escape = CS.UnityEngine.KeyCode.Escape
local WindowState = { Create = 0, Loading = 1, Open = 2, Close = 3, Destroying = 4 }
--弹出页面管理类型
local PopStackWindowType =
{
    Ignore = 1,--忽略
    Other = 2,--由other管理
    Normal = 3,--正常管理
}

-- 构造函数
local function __init(self)
    -- 所有存活的窗体
    self.windows = {}
    self.windowsConfig = {}
    -- 所有可用的层级
    self.layers = {}
    -- 初始化组件
    self.transform = GameObject.Find(UIRootPath).transform
    self.blurImgObj = GameObject.Find("UIContainer/blurImg").gameObject
    local container = self.transform:Find("UIContainer")

    self.canvas = container:GetComponent(Canvas)
    self.windowStack = list:new()
    self.otherWindowStack = list:new()
    self.UIMainAnim = nil
    -- 初始化层级
    self.layers = {}
    for _, layerName in ipairs(LayerOrder) do
        local layerPath = "UIContainer/"..layerName
        local layerObj = nil
        local trans = self.transform:Find(layerPath)
        if trans~=nil then
            layerObj = trans.gameObject
        end
        if layerObj == nil then
            layerObj = GameObject(layerName, RectTransform)
            layerObj.transform:SetParent(container, false)
            if (layerName == "TopCanvas") then
                local canvas = layerObj.transform:GetOrAddComponent(typeof(CS.UnityEngine.Canvas))
                canvas.overrideSorting = true
                canvas.sortingLayerName = 'Default'
                canvas.sortingOrder = 8000
            end
        end
        local layerConf = UILayer[layerName]
        local layer = UILayerComponent.New(self, layerConf.Name)
        layer:OnCreate(layerConf)
        self.layers[layerConf.Name] = layer
    end

    local layerConf = UILayer["World"]
    local layerObj = self.transform:Find("WorldUIContainer").gameObject
    local layer = UILayerComponent.New(self, layerObj)
    layer:OnCreate()
    self.layers[layerConf.Name] = layer
    self:AddListener()
    self.blurList = {false,false,false,false}
    
end

local function __delete(self)
    self:DestroyAllWindow()
    self:RemoveListener()
    self:DeleteAllLayer()
end

local function DeleteAllLayer(self)
    for k,v in pairs(self.layers) do
        GameObject.Destroy(v)
    end
    self.layers= nil
end
local function AddListener(self)
    EventManager:GetInstance():AddListener(EventId.OnKeyCodeEscape, self.OnKeyCodeEscape)
end

local function RemoveListener(self)
    EventManager:GetInstance():RemoveListener(EventId.OnKeyCodeEscape, self.OnKeyCodeEscape)
end

-- 获取窗口
local function GetWindow(self, ui_name)
    return self.windows[ui_name]
end

local function GetLayer(self,layerName)
    return self.layers[layerName]
end

local function GetScaleFactor(self)
    return self.canvas.scaleFactor
end

local function GetWindowConfig(self, ui_name)
    local configPath = UIConfig[ui_name]
    assert(configPath, "No window named : "..ui_name..".You should add it to UIConfig first!")

    local config = self.windowsConfig[ui_name]
    if config == nil then
        _, config = next(require(configPath))
        self.windowsConfig[ui_name] = config
    end
    return config
end

local function ProtectCall(fun)
    local ok, msg = xpcall(fun, debug.traceback)
    if not ok then
        local now = UITimeManager:GetInstance():GetServerSeconds()
        local str = "UIManager Error:"..msg
        CommonUtil.SendErrorMessageToServer(now, now, str)
        Logger.LogError(str)
    end
end

local function PlayAnimation(go, animName)
    if IsNull(go) or not go.activeSelf then
        return
    end

    local ani = go:GetComponent(typeof(CS.UnityEngine.Animator))
    if IsNull(ani) then
        return
    end

    if not animName then
        return
    end

    local duration = 0.01
    local clips = ani.runtimeAnimatorController.animationClips
    for i = 0, clips.Length - 1 do
        if string.endswith(clips[i].name,animName) then
            duration = clips[i].length
            ani:Play(animName, 0, 0)
            return true, duration
        end
    end

    return false
end

local function GetFileNameWithoutExtension(filepath)
    local filename
    local i = filepath:findlast("[/\\]")
    if i then
        filename = filepath:sub(i + 1)
    else
        filename = filepath
    end

    i = filename:findlast(".", true)
    if i then
        return filename:sub(1, i - 1)
    else
        return filename
    end
end

local function PlayMoveInAnim(self, window)
    if not window.OpenOptions.anim then
        return
    end

    local go = window.View.gameObject
    local prefabName = GetFileNameWithoutExtension(window.PrefabPath)
    local ok = PlayAnimation(go, prefabName .. "_movein")
    if not ok then
        PlayAnimation(go, "CommonPopup_movein")
    end
end

local function PlayMoveOutAnim(self, window)
    local go = window.View.gameObject
    local prefabName = GetFileNameWithoutExtension(window.PrefabPath)
    local ok, duration = PlayAnimation(go, prefabName .. "_moveout")
    if not ok then
        ok, duration = PlayAnimation(go, "CommonPopup_moveout")
    end
    return ok, duration
end

-- 关闭窗口
local function InnerCloseWindow(self, window)
    if window and window.View:GetActive() then
        window.View:SetActive(false)
        window.State = WindowState.Close
    end
end

local function Startup(self)
end

local function OnKeyCodeEscape(data)
    UIManager:GetInstance():KeyCodeEscape()
end


local function KeyCodeEscape(self)
    if DataCenter.GuideManager:InGuide() or AppStartupLoading:GetInstance():IsLoading() then
        return
    end
    local stack = nil
    if self.otherWindowStack.length > 0 then
        stack = self.otherWindowStack
    elseif self.windowStack.length > 0 then
        stack = self.windowStack
    end

    if stack == nil then
        UIUtil.ShowMessage(Localization:GetString("dialog_message_exit_confirm"), 2, GameDialogDefine.CONFIRM, GameDialogDefine.CANCEL, function()
            CS.ApplicationLaunch.Instance:Quit()
        end)
    else
        local topWin = stack:tail()
        if topWin.View.OnKeyEscape then
            topWin.View:OnKeyEscape()
        else
            self:DestroyWindow(topWin.Name, { anim = true })
        end
    end
end

-- 打开窗口
--[[ 
    参数1：窗口名
    参数2：可选参数，窗口打开选项
    参数3……：用户数据，不要用table作为用户数据
    
    窗口打开选项
    options = {
        打开窗口时是否播放动画
        anim = true/false
        
        窗口是否常驻内存不释放
        dontdestroy = true/false,
        
        关闭窗口时要返回到前一窗口
        back = { ui = "ui_name", anim = true/false },
        
        打开窗口时，主界面做动画 (只有Layer = Background,UIResource,Normal,Guide层才做)
        UIMainAnim = UIMainAnimType.AllHide,
                    (UIMainAnimType为动画枚举)
                         1:主界面上下左右全部隐藏
                         2:主界面上部保留（资源条和头像），下左右全部隐藏
         示例：
           1.默认options为空做UIMainAnimType.LeftRightBottomHide动画 
                例如 UIManager:GetInstance():OpenWindow("UIPop")
           2.打开界面需要主界面做UIMainAnimType.AllHide动画 需要在打开界面写 
                例如 UIManager:GetInstance():OpenWindow("UIPop",{anim = true,UIMainAnim = UIMainAnimType.AllHide})
           3.有界面1，打开的新界面2需要隐藏界面1，返回时显示界面1 需要在打开界面写 
                    UIManager:GetInstance():OpenWindow("UIPop", { anim = true，back = {ui = "UIDemo2", anim = false} }, "user data")
           4.有界面1，打开的新界面2需要和界面1共同显示的 需要在打开界面写 
                    UIManager:GetInstance():OpenWindow("UIPop", { anim = true }, "user data")
           5.特殊情况：界面1关闭打开界面2不做动画，界面2关闭做动画 需要这样做
                     界面1关闭时写：
                        UIManager:GetInstance():OpenWindow(UIWindowNames.UIBookMark,{anim = true})
                        UIManager:GetInstance():DestroyWindow(UIWindowNames.UIBookMarkPositionCollect,{anim = true})
                     界面2关闭时写
                         UIManager:GetInstance():DestroyWindow(UIWindowNames.UIBookMark,{anim = true,UIMainAnim = UIMainAnimType.LeftRightBottomShow})
             
       
    }
   
    示例：
    1. 打开窗口，默认情况下播放窗口打开动画
    需要播放动画的窗口在其根结点添加 Animator，播放动画时，先查找 Animator 中是否有与窗口
    同名的动画，如 "UISearch_movein"，若找不到同名动画时，播放通用弹出动画 CommonPopup_movein
    UIManager:GetInstance():OpenWindow("UIPop")
    
    2. 打开窗口，不播放打开动画
    UIManager:GetInstance():OpenWindow("UIPop", { anim = false }, "user data")
    
    3. 打开窗口，会关闭指定窗口，如 UIOther，并在此窗口关闭时，自动返回 UIOther，在返回 UIOther 时，UIOther是否播放打开动画由 back.anim 控制
    UIManager:GetInstance():OpenWindow("UIPop", { anim = true, back = { ui = "UIOther", anim = true })
]]
local function OpenWindow(self, ui_name, ...)
    local config = GetWindowConfig(self, ui_name)
    if config.Layer == UILayer.Background or config.Layer == UILayer.Normal then
        if ui_name ~= UIWindowNames.UIBuildUpgradeAddDes and ui_name ~= UIWindowNames.UIItemTips and ui_name ~= UIWindowNames.UIHeroTip and ui_name ~= UIWindowNames.UIFormationTip and ui_name ~= UIWindowNames.UIDragonBuffTip then
            UIUtil.ClickUICloseWorldUI()
        end
    end
    local window = self.windows[ui_name]
    if window ~= nil and window.State == WindowState.Create then
        Logger.Log("OpenWindow create, not done ", ui_name)
        return
    end
    if window ~= nil and window.State == WindowState.Loading then
        Logger.Log("OpenWindow loading, not done ", ui_name)
        return
    end
    if window ~= nil and window.State == WindowState.Destroying and window.CloseTimer ~= nil then
        window.CloseTimer:Stop()
        window.CloseTimer = nil
        self:OnDestroyWindow(window)
        window = nil
    end

    --
    -- 创建窗口
    --
    if not window then
        window = UIWindow.New()
        self.windows[ui_name] = window

        local layer = self.layers[config.Layer.Name]
        assert(layer, "No layer named : "..config.Layer.Name..".You should create it first!")

        if config.Ctrl then
            window.Ctrl = config.Ctrl.New()
        end
        if config.View then
            window.View = config.View.New(layer, ui_name, window.Ctrl)
        end

        window.Name = ui_name
        window.Layer = layer
        window.PrefabPath = config.PrefabPath
        window.State = WindowState.Create
    end

    local arg1 = select(1, ...)
    if type(arg1) == "table" then
        window.OpenOptions = arg1
        window.View:SetUserData(SafePack(select(2, ...)))
    else
        window.OpenOptions = { anim = true, UIMainAnim = UIMainAnimType.LeftRightBottomHide }
        window.View:SetUserData(SafePack(...))
    end
    --
    -- 实例化并显示
    --
    --window.OpenOptions.hideTop
    self:PushStackWindow(window)
    if not window.View.gameObject then
        local blurRtOrder = -1
        if window.OpenOptions.isBlur == true then
            blurRtOrder = self:AddBlur()
            window.blurRtOrder = blurRtOrder
            --BlurURP 截屏需要等待1-2帧，所以延迟 0.1s执行延迟创建界面
            window.timer = TimerManager:GetInstance():DelayInvoke(function()
                self:InnerCreateWindow(window,config,blurRtOrder)
            end, 0.1)
        else
            self:InnerCreateWindow(window,config)
        end

    else
        window.View:SetActive(true)
        self:OnCreateWindow(window, config)
    end
    --if window.OpenOptions.playEffect == nil or window.OpenOptions.playEffect == true then
    --    Sound:PlayEffect(SoundAssets.Music_Effect_Open)
    --end
    --self:StopWorldCameraMove(window)
end

function UIManager:InnerCreateWindow(window,config,blurRtOrder)

    window.InstanceRequest = ResourceManager:InstantiateAsync(window.PrefabPath);
    window.State = WindowState.Loading
    if window.InstanceRequest ~= nil then
        window.InstanceRequest:completed('+', function(request)
            if request.isError then
                return
            end

            local go = request.gameObject
            local trans = go.transform
            trans:SetParent(window.Layer.transform, false)
            trans.name = window.Name
            local blurItem = nil
            --拷贝模糊背景object
            if blurRtOrder~=nil and blurRtOrder>0 then
                blurItem = self.blurImgObj:GameObjectSpawn(trans)
                blurItem.transform:SetAsFirstSibling()
            end
            --由view管理
            ProtectCall(function() window.View:SetBlurObj(blurItem,blurRtOrder)  end)
            ProtectCall(function() window.View:OnCreate() end)
            if window.State ~= WindowState.Close and window.State ~= WindowState.Destroying then
                window.View.activeSelf = true
                window.View.gameObject:SetActive(true)
                ProtectCall(function() window.View:OnEnable() end)
                --直接将当前所在UI所在的Layer重排下
                UIManager.Instance:ResortLayer(window.Layer)
                self:OnCreateWindow(window, config)
            end
        end)
    end
end
-------------------------UI与特效排序-----------------------
function UIManager:ResortLayer(layer)
    local baseLayerOrder = layer:GetOrderInLayer()
    --遍历一下当前所有的window
    for _, window in pairs(self.windows) do
        if window.Layer == layer then
            window.View:ResortOrder(baseLayerOrder)
        end
    end
end
-----------------------------------------------------------
---
local function StopWorldCameraMove(self, window)
    if window.Name ~= UIWindowNames.UIMain and (window.Layer:GetName() == UILayer.Background.Name or
            window.Layer:GetName() == UILayer.UIResource.Name or
            window.Layer:GetName() == UILayer.Normal.Name) then
        local world = CS.SceneManager.World
        if world ~= nil then
            pcall(function() world:StopCameraMove() end)
        end
    end
end

local function InnerDestroyWindow(self, window)
    ProtectCall(function()
        --由view管理删除
        if window.View:HideBlur() then
            --如果删除成功，计数-1
            self:RemoveBlur(window.blurRtOrder)
        end
        window.Ctrl:Delete()
        window.View:Delete()
    end)
    if window.timer~=nil then
        window.timer:Stop()
        window.timer = nil
    end
    if window.InstanceRequest ~= nil then
        window.InstanceRequest:Destroy()
        window.InstanceRequest = nil
    end
    self.windows[window.Name] = nil
end

local function OnDestroyWindow(self, win)
    InnerCloseWindow(self, win)
    InnerDestroyWindow(self, win)
    EventManager:GetInstance():Broadcast(EventId.CloseUI, win.Name)
end

local function OnCreateWindow(self, window, config)
    window.State = WindowState.Open
    self:PlayMoveInAnim(window)
    --做UIMain动画
    if window.OpenOptions.UIMainAnim ~= nil and self.UIMainAnim == nil then
        if config.Layer == UILayer.Background or config.Layer == UILayer.Normal or config.Layer == UILayer.Guide then
            local UIMain = self.windows[UIWindowNames.UIMain]
            if UIMain and UIMain.InstanceRequest and UIMain.InstanceRequest.isDone then
                self.UIMainAnim = window.OpenOptions.UIMainAnim
                --Logger.Log("OpenWindow UIMain.View:PlayAnim, " .. ui_name .. " " .. tostring(self.UIMainAnim))
                UIMain.View:PlayAnim(window.OpenOptions.UIMainAnim)
                EventManager:GetInstance():Broadcast(EventId.SetGoldStoreBtnVisible, window.OpenOptions.UIMainAnim)
            end
        end
        --if self:GetStackWindowCount() > 0 then
        --    print("OpenWindow " .. ui_name)
        --    local index = 0
        --    for i, v in ilist(self.windowStack) do
        --        print(string.format("WindowStack %d %s", index, v.Name))
        --        index = index + 1
        --    end
        --end
    end
    if window.OpenOptions.hideTop then
        local tail = self.windowStack:findByIndex(self.windowStack.length - 1)
        window.OpenOptions.hideTopWindow =  tail.value
        self:SetLastTopWindowActive(window.OpenOptions.hideTopWindow, false)
    end

    EventManager:GetInstance():Broadcast(EventId.OpenUI, window.Name)
end

-- 销毁窗口
--[[
    options = {
        关闭窗口时是否播放关闭动画
        anim = true/false
        
        关闭窗口时，主界面做动画(只有Layer = Background,UIResource,Normal,Guide层才做)
        UIMainAnim = UIMainAnimType.AllShow,
                    (UIMainAnimType为动画枚举)
                         1:主界面上下左右全部显示
                         2:主界面上部不动（资源条和头像），下左右全部显示
       规则：
          1.如果打开该界面时没有做主界面动画则关闭也不会做
          2.有界面1，打开的新界面2需要隐藏界面1，返回时显示界面1 此时界面2关闭不回做动画，只有界面1关闭才会做动画
          3.如果强制界面关闭做动画 需要写
               UIManager:GetInstance():DestroyWindow(UIWindowNames.UIBookMark,{anim = true,UIMainAnim = UIMainAnimType.LeftRightBottomShow})
          4.如果强制界面关闭不做动画 需要写
               UIManager:GetInstance():DestroyWindow(UIWindowNames.UIBookMark,{anim = true})
]]

local function GetUIMainShowAnim(animType)
    if animType == UIMainAnimType.AllHide then
        return UIMainAnimType.AllShow
    elseif animType == UIMainAnimType.LeftRightBottomHide then
        return UIMainAnimType.LeftRightBottomShow
    end
end

local function PlayUIMainShowAnimation(self, animName, window)
    if self:GetStackWindowCount() == 1 and self:GetStackTopWindow() == window then
        --Logger.Log("DestroyWindow closeOptions.UIMainAnim " .. tostring(closeOptions.UIMainAnim) .. " " .. tostring(self:IsCanDoShowAnim(window)))
        if animName then
            local UIMain = self.windows[UIWindowNames.UIMain]
            if UIMain and UIMain.InstanceRequest and UIMain.InstanceRequest.isDone then
                --Logger.Log("DestroyWindow UIMain.View:PlayAnim, " .. window.Name .. " " .. animName)
                UIMain.View:PlayAnim(animName)
                EventManager:GetInstance():Broadcast(EventId.SetGoldStoreBtnVisible, animName)
                self.UIMainAnim = nil
            end
        end
    end
end

local function OnAfterWindowDestroy(ui_name)
    if ui_name == UIWindowNames.UIFormationSelectListNew then
        if CS.SceneManager.World then
            CS.SceneManager.World:QuitFocus(LookAtFocusTime)
        end
    end
    DataCenter.UIPopWindowManager:OnWindowDestroy(ui_name)
end

local function DestroyWindow(self, ui_name, closeOptions)
    local window = self.windows[ui_name]
    if not window or window.State == WindowState.Destroying then
        return
    end
    if not closeOptions then
        closeOptions = { anim = true }
    end
    if closeOptions.UIMainAnim == nil then
        closeOptions.UIMainAnim = GetUIMainShowAnim(self.UIMainAnim)
    end

    --local playEffectWhenOpen = closeOptions.playEffect
    --Logger.Log("DestroyWindow stack count: " .. tostring(self:GetStackWindowCount()) .. " " .. (self:GetStackWindowCount() >= 1 and self:GetStackTopWindow().Name or ""))
    self:PlayUIMainShowAnimation(closeOptions.UIMainAnim, window)

    local ok, duration
    if closeOptions.anim then
        ok, duration = self:PlayMoveOutAnim(window)
    end
    self:PopStackWindow(window)
    if closeOptions.anim and ok then
        local closeTimer = TimerManager:GetInstance():GetTimer(duration or 0.2, function()
            window.CloseTimer = nil
            --Logger.Log("DestroyWindow window.CloseTimer = nil, " .. ui_name)
            if not IsNull(window.View.gameObject) then
                --Logger.Log("DestroyWindow onDestroy, " .. ui_name)
                self:OnDestroyWindow(window)
            end
        end, nil, true, false, true)

        closeTimer:Start()
        window.CloseTimer = closeTimer
        window.State = WindowState.Destroying
    else
        self:OnDestroyWindow(window)
    end

    OnAfterWindowDestroy(ui_name)

    --if playEffectWhenOpen == nil or playEffectWhenOpen == true then
    --    Sound:PlayEffect(SoundAssets.Music_Effect_Close)
    --end
end

local function IsWindowOpen(self,ui_name)
    local window = self.windows[ui_name]
    if not window then
        return false
    end
    return window.State == WindowState.Create or window.State == WindowState.Loading or window.State == WindowState.Open
end

-- 销毁层级所有窗口
local function DestroyWindowByLayer(self, layer)
    local windows = {}
    for k, v in pairs(self.windows) do
        windows[k] = v
    end

    for k,v in pairs(windows) do
        if v.Layer:GetName() == layer.Name then
            local ui_name = v.Name
            self:PlayUIMainShowAnimation(GetUIMainShowAnim(self.UIMainAnim), v)
            self:PopStackWindow(v)
            self:OnDestroyWindow(v)
            OnAfterWindowDestroy(ui_name)
        end
    end
    if layer == UILayer.Normal or layer == UILayer.Background or layer == UILayer.Guide then
        local UIMain = self.windows[UIWindowNames.UIMain]
        if UIMain and UIMain.InstanceRequest and UIMain.InstanceRequest.isDone then
            UIMain.View:PlayAnim(UIMainAnimType.ChangeAllShow)
        end
    end
end

-- 销毁所有窗口
local function DestroyAllWindow(self)
    for k,v in pairs(self.windows) do
        local ui_name = v.Name
        --print(string.format("<color=#ffff00>DestroyAllWindow %s</color>", tostring(ui_name)))
        --self:PopStackWindow(v)
        InnerCloseWindow(self, v)
        InnerDestroyWindow(self, v)
        OnAfterWindowDestroy(self, ui_name)
    end
    self.windowStack:clear()
    self.otherWindowStack:clear()
end

-- 是否有打开界面
local function HasWindow(self)
    for k,v in pairs(self.windows) do
        local layerName = v.Layer:GetName()
        if layerName == UILayer.Normal.Name or layerName == UILayer.Background.Name or layerName == UILayer.Guide.Name then
            if v.Name ~= UIWindowNames.UIArrow and v.Name ~= UIWindowNames.UIGuideArrow then
                return true
            end
        end
    end
    return false
end

--只有主界面显示 excludeList = 排除的界面
local function CheckIfIsMainUIOpenOnly(self, ignoreGuide, excludeList)
    local exDict = {}
    if excludeList ~= nil then
        for k,v in ipairs(excludeList) do
            exDict[v] = true
        end
    end
    for _, v in pairs(self.windows) do
        if v.Name ~= UIWindowNames.TouchScreenEffect and
                v.Name ~= UIWindowNames.UICommonMessageTip and
                v.Name ~= UIWindowNames.UIArrow and
                v.Name ~= UIWindowNames.UIMain and
                v.Name ~= UIWindowNames.UINoticeHeroTips and
                v.Name ~= UIWindowNames.UINoticeTips and
                v.Name ~= UIWindowNames.UICommonMessageBar and
                v.Name ~= UIWindowNames.UIVitaResidentSetWorkTip and
                v.Name ~= UIWindowNames.UICityHud and
                v.Name ~= UIWindowNames.UIBubble and
                v.Name ~= UIWindowNames.UIQueueList and
                v.Name ~= UIWindowNames.UIFormationDispatchTip and
                v.Name ~= UIWindowNames.UIVitaMatter and
                v.Name ~= UIWindowNames.UINoInput and
                v.Name ~= UIWindowNames.UISceneNoInput and
                v.Name ~= UIWindowNames.UIGuideWindScreenEffect and
                v.Name ~= UIWindowNames.UISandStorm and
                v.Name ~= UIWindowNames.UIGuideArrow and (not exDict[v.Name])
        then
            if self:IsWindowOpen(v.Name) then
                return false
            end
        end
    end
    if not ignoreGuide and DataCenter.GuideManager:InGuide() then
        return false
    end
    return true
end

local function PushStackWindow(self, window)
    local popType = self:GetPopStackWindowType(window)
    if popType == PopStackWindowType.Normal then
        local windowStack = self.windowStack
        windowStack:erase(window)
        windowStack:push(window)
    elseif popType == PopStackWindowType.Other then
        self.otherWindowStack:erase(window)
        self.otherWindowStack:push(window)
    end
end

local function PopStackWindow(self, window)
    local popType = self:GetPopStackWindowType(window)
    if popType == PopStackWindowType.Normal then
        local windowStack = self.windowStack
        if window.OpenOptions.hideTop then
            self:SetLastTopWindowActive(window.OpenOptions.hideTopWindow, true)
        end
        if windowStack:tail() == window then
            windowStack:pop()
        else
            windowStack:erase(window)
        end
    elseif popType == PopStackWindowType.Other then
        self.otherWindowStack:erase(window)
    end
end

local function GetStackWindowCount(self)
    local windowStack = self.windowStack
    return windowStack.length
end

local function GetStackTopWindow(self)
    local windowStack = self.windowStack
    return windowStack:tail()
end


local function DestroyViewList(self,needCloseList,needPlayCloseEffect)
    for k,v in ipairs(needCloseList) do
        if DataCenter.GuideManager:IsCanCloseUI(v) then
            local window = self.windows[v]
            if window ~= nil then
                if needPlayCloseEffect then
                    self:DestroyWindow(v)
                else
                    self:DestroyWindow(v, { anim = true ,playEffect = false})
                end
            end
        end
    end
end

local function GetUIMainAnim(self)
    return self.UIMainAnim
end

--设置UI层级显示/隐藏（播放timeline时调用）
local function SetLayerActive(self,layerName,active)
    local layer = self:GetLayer(layerName)
    if layer ~= nil then
        layer.gameObject:SetActive(active)
    end
end

--该页面是否加载完成
local function IsPanelLoadingComplete(self,ui_name)
    local window = self:GetWindow(ui_name)
    if window ~= nil and window.State == WindowState.Open then
        return true
    end
    return false
end


local function SetUIMainEnable(self,value)
    local window = self:GetWindow(UIWindowNames.UIMain)
    if window ~= nil and window.View~=nil then
        window.View:SetActive(value)
    end
end

--公共接口获取屏幕实际缩放比
local function GetScreenScale(self)
    return Screen.width / ScreenDefaultWidth
end

function UIManager:GetUICamera()
    return self.canvas.worldCamera
end
function UIManager:AddBlur()
    local blurNum = 1
    for i=1,#self.blurList do
        if self.blurList[i] == false then
            blurNum = i
            break
        end
    end
    local tfName = "BlurURP"..blurNum
    RenderSetting.ToggleBlur(true,tfName,blurNum)
    self.blurList[blurNum] = true
    return blurNum
end
function UIManager:RemoveBlur(blurNum)
    local tfName = "BlurURP"..blurNum
    RenderSetting.ToggleBlur(false,tfName,blurNum)
    self.blurList[blurNum] = false
end

function UIManager:SetLastTopWindowActive(topWin, active)
    if topWin ~= nil and topWin.View ~= nil and topWin.View.gameObject ~= nil then
        topWin.View.gameObject:SetActive(active)
    end
end
--获取页面管理类型
function UIManager:GetPopStackWindowType(window)
    if window ~= nil then
        local windowName = window.Name
        local layerName = window.Layer:GetName()
        if windowName == UIWindowNames.UIMain or
                windowName == UIWindowNames.UIPVELoading or
                windowName == UIWindowNames.UIMainMiniMap or
                windowName == UIWindowNames.UIGuideArrow or
                windowName == UIWindowNames.UIArrow or
                windowName == UIWindowNames.UIGuideHeadTalk or
                windowName == UIWindowNames.UIGuideWindScreenEffect or
                windowName == UIWindowNames.UIGuideRedScreenEffect or
                layerName == UILayer.TopMost.Name or
                layerName == UILayer.Scene.Name or
                layerName == UILayer.World.Name then
            return PopStackWindowType.Ignore
        elseif layerName == UILayer.Info.Name or layerName == UILayer.Dialog.Name then
            return PopStackWindowType.Other
        end
    end

    return PopStackWindowType.Normal
end

UIManager.__init = __init
UIManager.__delete =__delete
UIManager.Startup = Startup
UIManager.GetWindow = GetWindow
UIManager.OpenWindow = OpenWindow
UIManager.DestroyWindow = DestroyWindow
UIManager.IsWindowOpen = IsWindowOpen
UIManager.DestroyWindowByLayer = DestroyWindowByLayer
UIManager.DestroyAllWindow = DestroyAllWindow
UIManager.GetLayer = GetLayer
UIManager.HasWindow = HasWindow
UIManager.CheckIfIsMainUIOpenOnly = CheckIfIsMainUIOpenOnly
UIManager.GetScaleFactor = GetScaleFactor

UIManager.PushStackWindow = PushStackWindow
UIManager.PopStackWindow = PopStackWindow
UIManager.GetStackTopWindow = GetStackTopWindow
UIManager.GetStackWindowCount = GetStackWindowCount
UIManager.PlayMoveInAnim = PlayMoveInAnim
UIManager.PlayMoveOutAnim = PlayMoveOutAnim
UIManager.OnDestroyWindow = OnDestroyWindow
UIManager.PlayUIMainShowAnimation = PlayUIMainShowAnimation
UIManager.DestroyViewList = DestroyViewList
UIManager.GetUIMainAnim = GetUIMainAnim
UIManager.StopWorldCameraMove = StopWorldCameraMove
UIManager.SetLayerActive = SetLayerActive
UIManager.IsPanelLoadingComplete = IsPanelLoadingComplete
UIManager.AddListener = AddListener
UIManager.RemoveListener = RemoveListener
UIManager.OnKeyCodeEscape = OnKeyCodeEscape
UIManager.KeyCodeEscape = KeyCodeEscape
UIManager.DeleteAllLayer = DeleteAllLayer
UIManager.SetUIMainEnable = SetUIMainEnable
UIManager.OnCreateWindow = OnCreateWindow
UIManager.GetScreenScale = GetScreenScale

return UIManager