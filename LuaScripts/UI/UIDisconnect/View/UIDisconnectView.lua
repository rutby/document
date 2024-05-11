--
-- 断线重连界面
-- 分两种情况
-- 1、网络是连接的 ， 此时发送同步数据的协议来同步登录数据，如果3秒内没回包就显示菊花  如果又过了10秒还是没回包就跳转到登录界面
-- 2、网络时断开的    此时重新连接网络  如果一定时间内没连上跳转到登录界面
--

local UIDisconnectView = BaseClass("UIDisconnectView", UIBaseView)
local base = UIBaseView
local wifi_path = "WifiCircleBg"

local function OnCreate(self)
    base.OnCreate(self)
    self.wifi = self.transform:Find(wifi_path)
end

local function OnDestroy(self)
    base.OnDestroy(self)
end

local function OnEnable(self)
    base.OnEnable(self)
    Logger.Log("打开断线重连界面")
    if CS.GameEntry.Network.IsConnected then
        Logger.Log("网络还是连着的！！！");
        -- 同步数据 此时不转菊花，如果一定时间内还没返回才转菊花
        self.wifi.gameObject:SetActive(false);
        self.showLoadingTimer = TimerManager:GetInstance():GetTimer(3, self.OnShowLoading, self, true, false, false)
        self.showLoadingTimer:Start()
        CommonUtil.OnDisConnect()
        self.ctrl:SendLoginInit()
    else
        Logger.Log("网络已经断开了！！！");
        -- 重新登录，此时转菊花，如果一定时间内还没登录成功就进入登录界面
        self.wifi.gameObject:SetActive(true);
        CommonUtil.OnDisConnect()
        AppStartupLoading:GetInstance():ReConnect()
        self.reconnectTimer = TimerManager:GetInstance():GetTimer(10, self.OnReconnectTimeOut, self, true, false, false)
        self.reconnectTimer:Start()
    end
end

local function OnShowLoading(self)
    self.wifi.gameObject:SetActive(true)
    self.gotoLoadingTimer = TimerManager:GetInstance():GetTimer(10, self.GotoLoadingView, self, true, false, false)
    self.gotoLoadingTimer:Start()
end

local function OnReconnectTimeOut(self)
    self:GotoLoadingView()
end

local function OnDisable(self)
    base.OnDisable(self)

    if self.showLoadingTimer ~= nil then
        self.showLoadingTimer:Stop()
        self.showLoadingTimer = nil
    end
    if self.gotoLoadingTimer ~= nil then
        self.gotoLoadingTimer:Stop()
        self.gotoLoadingTimer = nil
    end
    if self.reconnectTimer ~= nil  then
        self.reconnectTimer:Stop()
        self.reconnectTimer = nil
    end
end

local function GotoLoadingView(self)
    self.ctrl:CloseSelf()
    CS.ApplicationLaunch.Instance:ReStartGame()
end

local function OnEventClose(self)
    Logger.Log("onEventClose 关闭断线重连界面")
    self.ctrl:CloseSelf()
end

local function OnNetError(self)
    self:GotoLoadingView()
end

local function OnAddListener(self)
    base.OnAddListener(self)
    self:AddUIListener(EventId.Net_Connect_Error, self.OnNetError)
    self:AddUIListener(EventId.Net_Server_Status, self.OnNetError)
    self:AddUIListener(EventId.LoginInitError, self.OnNetError)
    self:AddUIListener(EventId.LoginCommandError, self.OnNetError)
    self:AddUIListener(EventId.CloseDisconnectView, self.OnEventClose)
end

local function OnRemoveListener(self)
    base.OnRemoveListener(self)
    self:RemoveUIListener(EventId.Net_Connect_Error, self.OnNetError)
    self:RemoveUIListener(EventId.Net_Server_Status, self.OnNetError)
    self:RemoveUIListener(EventId.LoginInitError, self.OnNetError)
    self:RemoveUIListener(EventId.LoginCommandError, self.OnNetError)
    self:RemoveUIListener(EventId.CloseDisconnectView, self.OnEventClose)
end


UIDisconnectView.OnCreate = OnCreate
UIDisconnectView.OnDestroy = OnDestroy
UIDisconnectView.OnEnable = OnEnable
UIDisconnectView.OnDisable = OnDisable
UIDisconnectView.OnAddListener = OnAddListener
UIDisconnectView.OnRemoveListener = OnRemoveListener
UIDisconnectView.OnEventClose = OnEventClose
UIDisconnectView.GotoLoadingView = GotoLoadingView
UIDisconnectView.OnNetError = OnNetError
UIDisconnectView.OnShowLoading = OnShowLoading
UIDisconnectView.OnReconnectTimeOut = OnReconnectTimeOut

return UIDisconnectView
