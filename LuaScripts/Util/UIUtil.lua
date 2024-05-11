
--[[
-- added by wsh @ 2017-12-03
-- UI工具类
--]]

local UIUtil = {}
local NORMAL = NewMarchType.NORMAL
local DIRECT_MOVE_MARCH = NewMarchType.DIRECT_MOVE_MARCH
local BOSS = NewMarchType.BOSS
local MONSTER = NewMarchType.MONSTER
local ACT_BOSS = NewMarchType.ACT_BOSS
local ASSEMBLY_MARCH = NewMarchType.ASSEMBLY_MARCH
local SCOUT = NewMarchType.SCOUT
local RESOURCE_HELP = NewMarchType.RESOURCE_HELP
local GOLLOES_EXPLORE = NewMarchType.GOLLOES_EXPLORE
local GOLLOES_TRADE = NewMarchType.GOLLOES_TRADE
local PUZZLE_BOSS = NewMarchType.PUZZLE_BOSS
local CHALLENGE_BOSS = NewMarchType.CHALLENGE_BOSS
local ALLIANCE_BOSS = NewMarchType.ALLIANCE_BOSS
local Localization = CS.GameEntry.Localization
local Data = CS.GameEntry.Data

local function ShowMessage(tipText,btnNum,text1,text2,action1,action2,closeAction,titleText,isChangeImg,noPlayCloseEffect,enableBtn1,enableBtn2,ClickBgDisable)
    UIManager:GetInstance():OpenWindow(UIWindowNames.UICommonMessageTip, {anim = true, isBlur = true})
    local window = UIManager:GetInstance():GetWindow(UIWindowNames.UICommonMessageTip)
    if window~=nil and window.View~=nil then
        window.View:SetData(tipText,btnNum,text1,text2,action1,action2,closeAction,titleText,isChangeImg,noPlayCloseEffect,enableBtn1,enableBtn2,ClickBgDisable)
        if window.View:GetActive() then
            window.View:RefreshData()
        end
    end
end

local function IsPad()
    local ret = false
    pcall(function()
        ret = not CS.UIUtils:IsPhone()
    end)
    return ret;
end

local function ShowIntro(title, subtitle, intro, closeAction, time, timeDialog)
    local param = {}
    param.title = title
    param.subtitle = subtitle
    param.intro = intro
    param.closeAction = closeAction
    param.time = time
    param.timeDialog = timeDialog
    UIManager:GetInstance():OpenWindow(UIWindowNames.UICommonIntroTip, NormalBlurPanelAnim, param)
end

-- confirmStr, cancelStr 为空时，显示默认值
local function ShowUseItemTip(title, param)
    UIManager:GetInstance():OpenWindow(UIWindowNames.UICommonUseItemTip, { anim = true, UIMainAnim = UIMainAnimType.LeftRightBottomHide })
    local window = UIManager:GetInstance():GetWindow(UIWindowNames.UICommonUseItemTip)
    if window and window.View then
        window.View:SetData(title, param)
        return window.View
    end
end

-- 展示一个复杂的Tip
-- tipInfo 格式见 UIComplexTipView.lua
local function ShowComplexTip(tipInfo)
    local window = UIManager:GetInstance():GetWindow(UIWindowNames.UIComplexTip)
    if window then
        window.View:PushTipInfo(tipInfo)
    else
        UIManager:GetInstance():OpenWindow(UIWindowNames.UIComplexTip, { anim = true, playEffect = false }, tipInfo)
    end
end

-- 显示是否再次弹出窗口
-- title:标题文本
-- tipText:描述文本
-- btnNum:按钮个数
-- text1:左边按钮名称（当btnNoUseDialog为true时表示内容，为空时表示多语言）
-- text2:右边按钮名称（当btnNoUseDialog为true时表示内容，为空时表示多语言）
-- sureAction:点击左边按钮回调函数
-- toggleAction:点击中间复选框按钮回调函数
-- cancelAction:点击右边按钮回调函数
-- closeAction:点击x和黑色背景回调函数
-- isChangeImg:为true 左边红色按钮，右边黄色按钮  为空 左边蓝色按钮，右边黄色按钮
-- toggleText:中间复选框文本描述
-- btnNoUseDialog:text1和text2类型 为true表示文本 为空表示多语言
-- leftBtnPicName:左边按钮图片路径
-- rightBtnPicName:右边按钮图片路径
local function ShowSecondMessage(titleText,tipText,btnNum,text1,text2,sureAction,toggleAction,cancelAction,closeAction,isChangeImg,toggleText, btnNoUseDialog, leftBtnPicName, rightBtnPicName)
    UIManager:GetInstance():OpenWindow(UIWindowNames.UISellConfirm,{anim = true,playEffect = false,isBlur = true})
    local window = UIManager:GetInstance():GetWindow(UIWindowNames.UISellConfirm)
    if window~=nil and window.View~=nil then
        window.View:SetData(titleText,tipText,btnNum,text1,text2,sureAction,toggleAction,cancelAction,closeAction,isChangeImg,toggleText, btnNoUseDialog, leftBtnPicName, rightBtnPicName)
        if window.View:GetActive() then
            window.View:RefreshView()
        end
    end
end

--canCover 下一个可以瞬间显示压住第一个
local function ShowTips(msg,showTime, playerHead,heroHead, canCover)
    UIManager:GetInstance():OpenWindow(UIWindowNames.UICommonMessageBar,{anim = true,playEffect = false})
    local window = UIManager:GetInstance():GetWindow(UIWindowNames.UICommonMessageBar)
    if window~=nil and window.View~=nil then
        window.View:AddNewMsg_Msg(msg,showTime, playerHead,heroHead, canCover)
        --window.View:SetData(msg,img,messageBarType)
        --if window.View:GetActive() then
        --    window.View:RefreshData()
        --end

    end
end

local function ShowSpecialTips(msg,showTime)
    UIManager:GetInstance():OpenWindow(UIWindowNames.UICommonMessageSpecialBar,{anim = true,playEffect = false})
    local window = UIManager:GetInstance():GetWindow(UIWindowNames.UICommonMessageSpecialBar)
    if window~=nil and window.View~=nil then
        window.View:AddNewMsg_Msg(msg,showTime)
    end
end

local function ShowSingleTip(msg)
    UIManager:GetInstance():OpenWindow(UIWindowNames.UICommonSingleMsgBar,{anim = true,playEffect = false})
    local window = UIManager:GetInstance():GetWindow(UIWindowNames.UICommonSingleMsgBar)
    if window~=nil and window.View~=nil then
        window.View:ShowStrTip(msg)
    end
end

local function ShowTipsId(msgId,showTime, playerHead,heroHead, canCover)
    UIManager:GetInstance():OpenWindow(UIWindowNames.UICommonMessageBar,{anim = true,playEffect = false})
    local window = UIManager:GetInstance():GetWindow(UIWindowNames.UICommonMessageBar)
    if window~=nil and window.View~=nil then
        window.View:AddNewMsg_MsgId(msgId,showTime, playerHead,heroHead, canCover)
        --window.View:SetData(msg,img,messageBarType)
        --if window.View:GetActive() then
        --    window.View:RefreshData()
        --end

    end
end

local function ShowBuyMessage(tipText,btnNum,text1,text2,action1,action2,closeAction,titleText,btnPriceTxt,item,noPlayCloseEffect,enableBtn1,enableBtn2)
    UIManager:GetInstance():OpenWindow(UIWindowNames.UICommonBuyItem)
    local window = UIManager:GetInstance():GetWindow(UIWindowNames.UICommonBuyItem)
    if window~=nil and window.View~=nil then
        window.View:SetData(tipText,btnNum,text1,text2,action1,action2,closeAction,titleText,btnPriceTxt,item,noPlayCloseEffect,enableBtn1,enableBtn2)
        if window.View:GetActive() then
            window.View:RefreshData()
        end
    end
end

local function CalcConstructMilePointer(leftPadding, topPadding, mainWorldPos, targetWorldPos)
    local show, dist, pos, eulerAngleZ = false, 0, VecZero, 0
    local world = CS.SceneManager.World
    if world == nil then
        return show, dist
    end

    local mainTilePos = SceneUtils.WorldToTile(mainWorldPos)
    local mainScreenPos = world:WorldToScreenPoint(mainWorldPos)
    local targetTilePos = SceneUtils.WorldToTile(targetWorldPos)
    local targetScreenPos = world:WorldToScreenPoint(targetWorldPos)

    if (mainTilePos.x == 0 and mainTilePos.y == 0) or CrossServerUtil:GetIsCrossServer() then
        return false
    end

    local screenX = CS.UnityEngine.Screen.width
    local screenY = CS.UnityEngine.Screen.height
    if mainScreenPos.x > 0 and mainScreenPos.x < screenX and mainScreenPos.y > 0 and mainScreenPos.y < screenY then
        return show, dist, pos.x, pos.y, eulerAngleZ
    end

    show = true
    local scaleFactor = UIManager:GetInstance():GetScaleFactor()
    leftPadding = leftPadding * scaleFactor
    topPadding = topPadding * scaleFactor

    if mainScreenPos.x < leftPadding then
        mainScreenPos.x = leftPadding
    elseif mainScreenPos.x > (screenX - leftPadding) then
        mainScreenPos.x = screenX - leftPadding
    end

    if mainScreenPos.y < topPadding then
        mainScreenPos.y = topPadding
    elseif mainScreenPos.y > (screenY - topPadding) then
        mainScreenPos.y = screenY - topPadding
    end

    local dir = mainScreenPos - Vector3.New(screenX / 2, screenY / 2, 0)
    local dirVec = CS.UnityEngine.Vector3(dir.x, dir.y, 0)
    local rot = CS.UnityEngine.Quaternion.FromToRotation(CS.UnityEngine.Vector3.up, dirVec)
    eulerAngleZ = rot.eulerAngles.z

    dist = math.floor(Vector2.Distance(mainTilePos, targetTilePos))
    pos = CS.GameEntry.UICamera:ScreenToWorldPoint(mainScreenPos);

    return show, dist, pos.x, pos.y, eulerAngleZ
end

local function CalcMilePointer(leftPadding, topPadding)
    local world = CS.SceneManager.World
    if world == nil then
        return false, 0
    end
    local mainIndex = LuaEntry.Player:GetMainWorldPos()
    if mainIndex <= 0 then
        return false, 0
    end
    local mainWorldPos = SceneUtils.TileIndexToWorld(mainIndex)
    local targetWorldPos = world.CurTarget
    return UIUtil.CalcConstructMilePointer(leftPadding, topPadding, mainWorldPos, targetWorldPos)
end

local function GetAllianceItemPos(aItemType)
    if UIManager:GetInstance():IsPanelLoadingComplete(UIWindowNames.UIMain) then
        local window = UIManager:GetInstance():GetWindow(UIWindowNames.UIMain)
        if window ~= nil and window.View ~= nil then
            return window.View:GetAllianceItemPos(aItemType)
        end
    end
end

--点击世界关闭已打开世界UI
local function ClickWorldCloseWorldUI()
    UIUtil.ClickCloseWorldUI(CloseUIType.ClickWorld)
end

--点击UI关闭已打开世界UI
local function ClickUICloseWorldUI()
    UIUtil.ClickCloseWorldUI(CloseUIType.ClickUI)
end

--拖动世界关闭已打开世界UI
local function DragWorldCloseWorldUI()
    UIUtil.ClickCloseWorldUI(CloseUIType.DragWorld)
end

local function CheckNeedQuitFocus()
    local needQuit = false
    for k,v in ipairs(DragWorldNeedCloseExtraWorldUI) do
        if needQuit==false then
            if UIManager:GetInstance():IsWindowOpen(v) then
                needQuit = true
            end
        end
    end
    return needQuit
end
local function ClickCloseWorldUI(closeUIType)
    local needCloseList = {}
    if CS.SceneManager:IsInCity() and closeUIType == CloseUIType.DragWorld then
        local window = UIManager:GetInstance():GetWindow(UIWindowNames.UIWorldPoint)
        if window ~= nil and window.View ~= nil and window.View.activeSelf == true and window.Ctrl ~= nil then
            if window.Ctrl.type == WorldPointUIType.SingleMapGarbage then
                table.insert(needCloseList, UIWindowNames.UIWorldPoint)
            end
        end
    end
    for k,v in ipairs(ClickWorldNeedCloseWorldUI) do
        table.insert(needCloseList,v)
    end
    if closeUIType == CloseUIType.ClickUI then
        for k1,v1 in ipairs(ClickUINeedCloseExtraWorldUI) do
            table.insert(needCloseList,v1)
        end
        table.insert(needCloseList,UIWindowNames.UIWorldPoint)
    elseif closeUIType == CloseUIType.DragWorld then
        for k1,v1 in ipairs(DragWorldNeedCloseExtraWorldUI) do
            table.insert(needCloseList,v1)
        end
    end
    UIManager:GetInstance():DestroyViewList(needCloseList,closeUIType ~= CloseUIType.ClickUI)
    EventManager:GetInstance():Broadcast(EventId.HideMarchTip)
    --if isOpenWindow and closeUIType ~= CloseUIType.ClickUI then
    --    EventManager:GetInstance():Broadcast(EventId.UIMAIN_VISIBLE, true);
    --end
end

local function PlayAnimationReturnTime(unity_animator,animName)
    local duration = 0
    local clips = unity_animator.runtimeAnimatorController.animationClips
    for i = 0, clips.Length - 1 do
        if string.endswith(clips[i].name,animName) then
            duration = clips[i].length
            unity_animator:Play(animName, 0, 0)
            return true, duration
        end
    end

    return false
end

local function ClickBuildAdjustCameraView(worldPoint,adjustTable,lossyScale)
    local screen = CS.SceneManager.World:WorldToScreenPoint(worldPoint)
    local Screen = CS.UnityEngine.Screen
    local ScreenY = Screen.height
    local ScreenX = Screen.width
    local maxTop = ScreenY - adjustTable.top * lossyScale
    local maxBottom = adjustTable.bottom * lossyScale
    local maxLeft = adjustTable.left * lossyScale
    local maxRight = ScreenX - adjustTable.right * lossyScale
    local needMove = false
    if screen.x > maxRight then
        needMove = true
        screen.x = maxRight
    elseif screen.x < maxLeft then
        needMove = true
        screen.x = maxLeft
    end
    if screen.y > maxTop then
        needMove = true
        screen.y = maxTop
    elseif screen.y < maxBottom then
        needMove = true
        screen.y = maxBottom
    end
    if needMove then
        --CS.SceneManager.World:QuitFocus(worldPoint,LookAtFocusTime)
        local posWorld = CS.SceneManager.World:ScreenPointToWorld(screen)
        local curPos = CS.SceneManager.World.CurTarget + worldPoint - posWorld
        GoToUtil.GotoPos(curPos,CS.SceneManager.World.Zoom,nil,nil,LuaEntry.Player:GetCurServerId(),LuaEntry.Player:GetCurWorldId())
    end
    --local posWorld = CS.SceneManager.World:ScreenPointToWorld(screen)
    --local curPos = CS.SceneManager.World.CurTarget + worldPoint - posWorld
    --GoToUtil.GotoPos(worldPoint)
end

--是否在视野内
local function IsInView(worldPoint)
    local screen = CS.SceneManager.World:WorldToScreenPoint(worldPoint)
    local Screen = CS.UnityEngine.Screen
    return screen.x < Screen.width and screen.y < Screen.height
end

local function OnClickWorldTroop(marchUuid)
    UIUtil.ClickWorldCloseWorldUI()
    local needCloseUI = {}
    for k,v in ipairs(ClickUINeedCloseExtraWorldUI) do
        needCloseUI[v] = true
    end
    local needCloseWorldPointUI = true
    local marchInfo = DataCenter.WorldMarchDataManager:GetMarch(marchUuid)
    if marchInfo~=nil then
        if not string.IsNullOrEmpty(marchInfo.eventId) then
            --DataCenter.TroopActionManager:DoTroopAction(TroopActionType.TROOP_ACTION_TYPE_RADAR_CENTER)
        end
        if marchInfo:GetMarchType()== NORMAL or marchInfo:GetMarchType() == ASSEMBLY_MARCH or marchInfo:GetMarchType() == SCOUT or marchInfo:GetMarchType() == RESOURCE_HELP
                or marchInfo:GetMarchType() == GOLLOES_EXPLORE or marchInfo:GetMarchType() == GOLLOES_TRADE or marchInfo:GetMarchType() == DIRECT_MOVE_MARCH
                or marchInfo:GetMarchType() == NewMarchType.MONSTER_SIEGE then
            CS.SceneManager.World.marchUuid = marchUuid
            --DataCenter.WorldMarchDataManager:TrackMarch(marchUuid)
            WorldMarchTileUIManager:GetInstance():ShowTroop(marchUuid)
            --CS.WorldTileUI.ShowTroop(marchUuid, CS.SceneManager.World,false)
        elseif marchInfo:GetMarchType() == MONSTER or marchInfo:GetMarchType() == BOSS then
            WorldMarchTileUIManager:GetInstance():RemoveTroop()
            SoundUtil.PlayEffect(SoundAssets.Music_Effect_Click_Enemy1)
            needCloseUI[UIWindowNames.UIWorldPoint] = nil
            if UIManager:GetInstance():IsWindowOpen(UIWindowNames.UIWorldPoint) then
                local str = marchUuid..";"..marchInfo.targetPos..";"..""..";"..WorldPointUIType.Monster..";".."0"..";".."0"
                EventManager:GetInstance():Broadcast(EventId.RefreshUIWorldPointView,str)
            else
                UIManager:GetInstance():OpenWindow(UIWindowNames.UIWorldPoint,{anim = true,playEffect = false,UIMainAnim = UIMainAnimType.LeftRightBottomHide},marchUuid,marchInfo.targetPos,"",WorldPointUIType.Monster,0,0)
            end
            --雷打怪走引导
            local param = {}
            param.monster = true
            DataCenter.GuideManager:SetCompleteNeedParam(param)
            DataCenter.GuideManager:CheckGuideComplete()
            if DataCenter.RadarCenterDataManager:GetDetectEventInfoByPointId(marchInfo.targetPos) ~= nil then
                DataCenter.GuideManager:CheckDoTriggerGuide(GuideTriggerType.ClickRadarMonster, SaveGuideDoneValue)
            else
                DataCenter.GuideManager:CheckDoTriggerGuide(GuideTriggerType.ClickMonster, tostring(marchInfo.monsterId))
            end
            needCloseWorldPointUI = false
            --UIManager:GetInstance():OpenWindow(UIWindowNames.WorldDesUI,marchUuid)
        elseif marchInfo:GetMarchType() == ACT_BOSS then
            WorldMarchTileUIManager:GetInstance():RemoveTroop()
            needCloseUI[UIWindowNames.UIWorldPoint] = nil
            if UIManager:GetInstance():IsWindowOpen(UIWindowNames.UIWorldPoint) then
                local str = marchUuid..";"..marchInfo.targetPos..";"..""..";"..WorldPointUIType.ActBoss..";".."0"..";".."0"
                EventManager:GetInstance():Broadcast(EventId.RefreshUIWorldPointView,str)
            else
                UIManager:GetInstance():OpenWindow(UIWindowNames.UIWorldPoint,{anim = true,playEffect = false,UIMainAnim = UIMainAnimType.LeftRightBottomHide},marchUuid,marchInfo.targetPos,"",WorldPointUIType.ActBoss,0,0)
            end
            needCloseWorldPointUI = false
        elseif marchInfo:GetMarchType()== PUZZLE_BOSS then
            WorldMarchTileUIManager:GetInstance():RemoveTroop()
            needCloseUI[UIWindowNames.UIWorldPoint] = nil
            if UIManager:GetInstance():IsWindowOpen(UIWindowNames.UIWorldPoint) then
                local str = marchUuid..";"..marchInfo.targetPos..";"..""..";"..WorldPointUIType.PuzzleBoss..";".."0"..";".."0"
                EventManager:GetInstance():Broadcast(EventId.RefreshUIWorldPointView,str)
            else
                UIManager:GetInstance():OpenWindow(UIWindowNames.UIWorldPoint,{anim = true,playEffect = false,UIMainAnim = UIMainAnimType.LeftRightBottomHide},marchUuid,marchInfo.targetPos,"",WorldPointUIType.PuzzleBoss,0,0)
            end
            needCloseWorldPointUI = false
        elseif marchInfo:GetMarchType() == CHALLENGE_BOSS then
            WorldMarchTileUIManager:GetInstance():RemoveTroop()
            needCloseUI[UIWindowNames.UIWorldPoint] = nil
            if UIManager:GetInstance():IsWindowOpen(UIWindowNames.UIWorldPoint) then
                local str = marchUuid..";"..marchInfo.targetPos..";"..""..";"..WorldPointUIType.ChallengeBoss..";".."0"..";".."0"
                EventManager:GetInstance():Broadcast(EventId.RefreshUIWorldPointView,str)
            else
                UIManager:GetInstance():OpenWindow(UIWindowNames.UIWorldPoint,{anim = true,playEffect = false,UIMainAnim = UIMainAnimType.LeftRightBottomHide},marchUuid,marchInfo.targetPos,"",WorldPointUIType.ChallengeBoss,0,0)
            end
            needCloseWorldPointUI = false
        elseif marchInfo:GetMarchType() == ALLIANCE_BOSS then
            WorldMarchTileUIManager:GetInstance():RemoveTroop()
            needCloseUI[UIWindowNames.UIWorldPoint] = nil
            if UIManager:GetInstance():IsWindowOpen(UIWindowNames.UIWorldPoint) then
                local str = marchUuid..";"..marchInfo.targetPos..";"..""..";"..WorldPointUIType.AllianceBoss..";".."0"..";".."0"
                EventManager:GetInstance():Broadcast(EventId.RefreshUIWorldPointView,str)
            else
                UIManager:GetInstance():OpenWindow(UIWindowNames.UIWorldPoint,{anim = true,playEffect = false,UIMainAnim = UIMainAnimType.LeftRightBottomHide},marchUuid,marchInfo.targetPos,"",WorldPointUIType.AllianceBoss,0,0,nil, nil, marchInfo.allianceUid)
            end
            needCloseWorldPointUI = false
        end
    end
    for k,v in pairs(needCloseUI) do
        if v then
            UIManager:GetInstance():DestroyWindow(k)
        end
    end
    if needCloseWorldPointUI == true then
        if UIManager:GetInstance():IsWindowOpen(UIWindowNames.UIWorldPoint) then
            UIManager:GetInstance():DestroyWindow(UIWindowNames.UIWorldPoint)
        end
    end
end

local function OnClickWorld(curIndex,clickType)
    local lod = CS.SceneManager.World:GetLodLevel()
    if lod >= 4 then
        return
    end
    local needChangeCamera =  UIUtil.CheckNeedQuitFocus()
    UIUtil.ClickWorldCloseWorldUI()
    local needCloseIsFocus = true
    local needCloseWorldPointUI = true
    EventManager:GetInstance():Broadcast(EventId.ClickAny)

    local needCloseUI = {}
    for k,v in ipairs(ClickUINeedCloseExtraWorldUI) do
        needCloseUI[v] = true
    end
    for k,v in ipairs(DragWorldNeedCloseExtraWorldUI) do
        needCloseUI[v] = true
    end

    WorldMarchTileUIManager:GetInstance():RemoveTroop()
    WorldMarchEmotionManager:GetInstance():HideCurBtns()
    EventManager:GetInstance():Broadcast(EventId.OnClickWorld,curIndex)
    local info = DataCenter.WorldPointManager:GetPointInfo(curIndex)
    if info ~= nil then
        if info.PointType == WorldPointType.PlayerBuilding then
            local build = DataCenter.WorldPointManager:GetBuildDataByPointIndex(curIndex)
            if build ~= nil then
                if build.ownerUid == LuaEntry.Player.uid then
                    local buildData = DataCenter.BuildManager:GetBuildingDataByUuid(build.uuid)
                    Logger.Log("main Uuid"..build.uuid)
                    if buildData ~= nil then
                        if buildData.destroyStartTime>0 then
                            local isFinish = DataCenter.BuildManager:CheckSendFixBuildFinish(build.uuid)
                            if build.level >= 0 and isFinish == true then
                                needCloseUI[UIWindowNames.UIWorldTileUI] = nil
                                if UIManager:GetInstance():IsWindowOpen(UIWindowNames.UIWorldTileUI) then
                                    EventManager:GetInstance():Broadcast(EventId.RefreshUIWorldTileUI, tostring(build.mainIndex))
                                else
                                    UIManager:GetInstance():OpenWindow(UIWindowNames.UIWorldTileUI, { anim = true, playEffect = false}, tostring(build.mainIndex), needChangeCamera)
                                end
                            end
                        else
                            local isFinish = DataCenter.BuildManager:CheckSendBuildFinish(build.uuid)
                            local itemId = build.itemId
                            if itemId ==nil or itemId == 0 then
                                itemId = build.buildId
                            end
                            --0级虫洞特殊处理
                            if build.level == 0 and (build.itemId == BuildingTypes.APS_BUILD_WORMHOLE_SUB or BuildingUtils.IsInEdenSubwayGroup(itemId)== true) then
                                needCloseUI[UIWindowNames.UIWorldTileUI] = nil
                                UIManager:GetInstance():OpenWindow(UIWindowNames.UIWorldTileUI,{anim = true,playEffect = false},tostring(build.mainIndex),needChangeCamera)
                            elseif build.level >= 0 and isFinish ==true then
                                local buildTemplate = DataCenter.BuildTemplateManager:GetBuildingDesTemplate(itemId)
                                if buildTemplate~=nil then
                                    if buildData ~= nil then
                                        local bUuid = buildData.uuid
                                        local buildId = itemId
                                        if build.level == 0 then
                                            if buildData.updateTime == 0 then
                                                GoToUtil.GotoOpenBuildCreateWindow(UIWindowNames.UIBuildCreate, NormalPanelAnim, {buildId = itemId})
                                            end
                                        else
                                            if buildId == BuildingTypes.FUN_BUILD_ELECTRICITY then
                                                if buildData.unavailableTime == 0 then
                                                    local now = UITimeManager:GetInstance():GetServerTime()
                                                    if buildData.produceEndTime > now and buildData.produceEndTime > buildData.lastCollectTime then
                                                        if UIManager:GetInstance():IsWindowOpen(UIWindowNames.UIResourceCost) then
                                                            EventManager:GetInstance():Broadcast(EventId.UIResourceCostChangeState,bUuid)
                                                        else
                                                            UIManager:GetInstance():OpenWindow(UIWindowNames.UIResourceCost,bUuid)
                                                        end
                                                        needCloseUI[UIWindowNames.UIResourceCost] = nil
                                                    end
                                                end
                                            end
                                            if buildTemplate.build_type ~= BuildType.Second or buildTemplate.id == BuildingTypes.APS_BUILD_WORMHOLE_MAIN
                                                    or buildTemplate.id == BuildingTypes.APS_BUILD_WORMHOLE_SUB or buildTemplate.id == BuildingTypes.WORM_HOLE_CROSS or BuildingUtils.IsInEdenSubwayGroup(buildTemplate.id)== true then--加了虫洞特殊规则
                                                if buildTemplate.id == BuildingTypes.FUN_BUILD_CONDOMINIUM then
                                                    SoundUtil.PlayEffect(SoundAssets.Music_Effect_Click_LIBRARY)
                                                elseif buildTemplate.id == BuildingTypes.FUN_BUILD_GROCERY_STORE then
                                                    SoundUtil.PlayEffect(SoundAssets.Music_Effect_Golloes_Build)
                                                elseif buildTemplate.id == BuildingTypes.FUN_BUILD_MAIN  then
                                                    SoundUtil.PlayEffect(SoundAssets.Music_Effect_Click_Main_City)
                                                elseif buildTemplate.id == BuildingTypes.FUN_BUILD_BARRACKS  then
                                                    SoundUtil.PlayEffect(SoundAssets.Music_Effect_Click_BARRACKS)
                                                elseif buildTemplate.id == BuildingTypes.FUN_BUILD_CAR_BARRACK  then
                                                    SoundUtil.PlayEffect(SoundAssets.Music_Effect_Click_CAR_BARRACK)
                                                elseif buildTemplate.id == BuildingTypes.APS_BUILD_PUB  then
                                                    SoundUtil.PlayEffect(SoundAssets.Music_Effect_Click_Hero_Build)
                                                elseif buildTemplate.id == BuildingTypes.FUN_BUILD_INFANTRY_BARRACK  then
                                                    SoundUtil.PlayEffect(SoundAssets.Music_Effect_Click_INFANTRY_BARRACK)
                                                elseif buildTemplate.id == BuildingTypes.FUN_BUILD_AIRCRAFT_BARRACK then
                                                    SoundUtil.PlayEffect(SoundAssets.Music_Effect_Click_AIRCRAFT_BARRACK)
                                                elseif buildTemplate.id == BuildingTypes.FUN_BUILD_TRAP_BARRACK then
                                                    SoundUtil.PlayEffect(SoundAssets.Music_Effect_Click_TRAP_BARRACK)
                                                elseif buildTemplate.id == BuildingTypes.FUN_BUILD_POLICE_STATION then
                                                    SoundUtil.PlayEffect(SoundAssets.Music_Effect_Click_POLICE_STATION)
                                                elseif buildTemplate.id == BuildingTypes.FUN_BUILD_RADAR_CENTER then
                                                    SoundUtil.PlayEffect(SoundAssets.Music_Effect_Click_Radar)
                                                elseif buildTemplate.id == BuildingTypes.FUN_BUILD_DRONE then
                                                    SoundUtil.PlayEffect(SoundAssets.Music_Effect_Click_DRONE)
                                                elseif buildTemplate.id == BuildingTypes.FUND_BUILD_ALLIANCE_CENTER then
                                                    SoundUtil.PlayEffect(SoundAssets.Music_Effect_Click_ALLIANCE_CENTER)
                                                elseif buildTemplate.id == BuildingTypes.FUN_BUILD_LIBRARY then
                                                    SoundUtil.PlayEffect(SoundAssets.Music_Effect_Click_Apartment)
                                                elseif buildTemplate.id == BuildingTypes.FUN_BUILD_COLD_STORAGE then
                                                    SoundUtil.PlayEffect(SoundAssets.Music_Effect_Click_COLD_STORAGE)
                                                elseif buildTemplate.id == BuildingTypes.FUN_BUILD_SCIENE then
                                                    SoundUtil.PlayEffect(SoundAssets.Music_Effect_Click_SCIENE)
                                                elseif buildTemplate.id == BuildingTypes.FUN_BUILD_TRAINFIELD_1
                                                        or buildTemplate.id == BuildingTypes.FUN_BUILD_TRAINFIELD_2
                                                        or buildTemplate.id == BuildingTypes.FUN_BUILD_TRAINFIELD_3
                                                        or buildTemplate.id == BuildingTypes.FUN_BUILD_TRAINFIELD_4 then
                                                    SoundUtil.PlayEffect(SoundAssets.Music_Effect_Click_TRAINFIELD)
                                                else
                                                    SoundUtil.PlayEffect(SoundAssets.Music_Effect_Click_Building)
                                                end
                                                if itemId == BuildingTypes.FUN_BUILD_MAIN then
                                                    needCloseWorldPointUI = false
                                                    needCloseUI[UIWindowNames.UIWorldPoint] = nil
                                                    local worldPointPos = BuildingUtils.GetBuildModelCenterVec(build.mainIndex, 3)
                                                    GoToUtil.GotoWorldPos(worldPointPos, CS.SceneManager.World.Zoom, LookAtFocusTime, function ()
                                                        SoundUtil.PlayEffect(SoundAssets.Music_Effect_Click_Building)
                                                        if UIManager:GetInstance():IsWindowOpen(UIWindowNames.UIWorldPoint) then
                                                            local str = build.uuid..";"..build.mainIndex..";"..build.ownerUid..";"..WorldPointUIType.City..";".."1"..";"..itemId
                                                            EventManager:GetInstance():Broadcast(EventId.RefreshUIWorldPointView,str)
                                                        else
                                                            UIManager:GetInstance():OpenWindow(UIWindowNames.UIWorldPoint,{anim = true,playEffect = false,UIMainAnim = UIMainAnimType.LeftRightBottomHide},build.uuid,build.mainIndex,build.ownerUid,WorldPointUIType.City,1,itemId)
                                                        end
                                                    end,LuaEntry.Player:GetCurServerId(),LuaEntry.Player:GetCurWorldId())
                                                else
                                                    needCloseUI[UIWindowNames.UIWorldTileUI] = nil
                                                    if UIManager:GetInstance():IsWindowOpen(UIWindowNames.UIWorldTileUI) then
                                                        EventManager:GetInstance():Broadcast(EventId.RefreshUIWorldTileUI,tostring(build.mainIndex))
                                                    else
                                                        UIManager:GetInstance():OpenWindow(UIWindowNames.UIWorldTileUI,{anim = true,playEffect = false},tostring(build.mainIndex),needChangeCamera)
                                                    end
                                                end

                                            end
                                        end
                                    end
                                end
                            end
                        end
                    end

                elseif build.ownerUid ~= LuaEntry.Player.uid then
                    if build.level >= 0 then
                        local allianceId = LuaEntry.Player.allianceId
                        local itemId = build.itemId
                        if itemId ==nil or itemId == 0 then
                            itemId = build.buildId
                        end
                        if build.allianceId~=nil and allianceId~=nil and allianceId~="" and build.allianceId~="" and build.allianceId == allianceId then
                            if itemId == BuildingTypes.FUN_BUILD_MAIN then
                                needCloseWorldPointUI = false
                                needCloseUI[UIWindowNames.UIWorldPoint] = nil
                                local worldPointPos = BuildingUtils.GetBuildModelCenterVec(build.mainIndex, 3)
                                GoToUtil.GotoWorldPos(worldPointPos, CS.SceneManager.World.Zoom, LookAtFocusTime, function ()
                                    SoundUtil.PlayEffect(SoundAssets.Music_Effect_Click_Building)
                                    if UIManager:GetInstance():IsWindowOpen(UIWindowNames.UIWorldPoint) then
                                        local str = build.uuid..";"..build.mainIndex..";"..build.ownerUid..";"..WorldPointUIType.City..";".."1"..";"..itemId
                                        EventManager:GetInstance():Broadcast(EventId.RefreshUIWorldPointView,str)
                                    else
                                        UIManager:GetInstance():OpenWindow(UIWindowNames.UIWorldPoint,{anim = true,playEffect = false,UIMainAnim = UIMainAnimType.LeftRightBottomHide},build.uuid,build.mainIndex,build.ownerUid,WorldPointUIType.City,1,itemId)
                                    end
                                end,LuaEntry.Player:GetCurServerId(),LuaEntry.Player:GetCurWorldId())

                            else
                                needCloseWorldPointUI = false
                                needCloseUI[UIWindowNames.UIWorldPoint] = nil
                                SoundUtil.PlayEffect(SoundAssets.Music_Effect_Click_Building)
                                if UIManager:GetInstance():IsWindowOpen(UIWindowNames.UIWorldPoint) then
                                    local str = build.uuid..";"..build.mainIndex..";"..build.ownerUid..";"..WorldPointUIType.Build..";".."1"..";"..itemId
                                    EventManager:GetInstance():Broadcast(EventId.RefreshUIWorldPointView,str)
                                else
                                    UIManager:GetInstance():OpenWindow(UIWindowNames.UIWorldPoint,{anim = true,playEffect = false,UIMainAnim = UIMainAnimType.LeftRightBottomHide},build.uuid,build.mainIndex,build.ownerUid,WorldPointUIType.Build,1,itemId)
                                end
                                --UIManager:GetInstance():OpenWindow(UIWindowNames.UIWorldPlayerPoint,info.mainIndex,info.ownerUid,1,info.uuid)
                            end
                        else
                            if itemId == BuildingTypes.FUN_BUILD_MAIN then
                                needCloseWorldPointUI = false
                                needCloseUI[UIWindowNames.UIWorldPoint] = nil
                                local worldPointPos = BuildingUtils.GetBuildModelCenterVec(info.mainIndex, 3)
                                GoToUtil.GotoWorldPos(worldPointPos, CS.SceneManager.World.Zoom, LookAtFocusTime, function ()
                                    SoundUtil.PlayEffect(SoundAssets.Music_Effect_Click_Building)
                                    if UIManager:GetInstance():IsWindowOpen(UIWindowNames.UIWorldPoint) then
                                        local str = build.uuid..";"..build.mainIndex..";"..build.ownerUid..";"..WorldPointUIType.City..";".."0"..";"..itemId
                                        EventManager:GetInstance():Broadcast(EventId.RefreshUIWorldPointView,str)
                                    else
                                        UIManager:GetInstance():OpenWindow(UIWindowNames.UIWorldPoint,{anim = true,playEffect = false,UIMainAnim = UIMainAnimType.LeftRightBottomHide},build.uuid,build.mainIndex,build.ownerUid,WorldPointUIType.City,0,itemId)
                                    end

                                    --UIManager:GetInstance():OpenWindow(UIWindowNames.UIWorldPlayerBuild,info.inside,info.ownerUid,0,info.uuid)
                                end,LuaEntry.Player:GetCurServerId(),LuaEntry.Player:GetCurWorldId())
                            else
                                needCloseWorldPointUI = false
                                needCloseUI[UIWindowNames.UIWorldPoint] = nil
                                SoundUtil.PlayEffect(SoundAssets.Music_Effect_Click_Building)
                                if UIManager:GetInstance():IsWindowOpen(UIWindowNames.UIWorldPoint) then
                                    local str = build.uuid..";"..build.mainIndex..";"..build.ownerUid..";"..WorldPointUIType.Build..";".."0"..";"..itemId
                                    EventManager:GetInstance():Broadcast(EventId.RefreshUIWorldPointView,str)
                                else
                                    UIManager:GetInstance():OpenWindow(UIWindowNames.UIWorldPoint,{anim = true,playEffect = false,UIMainAnim = UIMainAnimType.LeftRightBottomHide},build.uuid,build.mainIndex,build.ownerUid,WorldPointUIType.Build,0,itemId)
                                end
                                --UIManager:GetInstance():OpenWindow(UIWindowNames.UIWorldPoint,info.uuid,info.mainIndex,info.ownerUid,WorldPointUIType.Build,0,info.itemId)
                                --UIManager:GetInstance():OpenWindow(UIWindowNames.UIWorldPlayerPoint,info.mainIndex,info.ownerUid,0,info.uuid)
                            end

                        end
                    end
                end
            end
        elseif info.PointType == WorldPointType.WorldResource then
            local data =  DataCenter.WorldPointManager:GetResourcePointInfoByIndex(info.pointIndex)
            if data ~= nil then
                local gatherUuid = data.gatherMarchUuid
                if gatherUuid ==nil or gatherUuid == 0 then
                    gatherUuid = data.gatherUuid
                end
                if gatherUuid~=nil and gatherUuid ~= 0 then
                    --依次判断自己-->盟友-->敌人
                    local marchInfo = DataCenter.WorldMarchDataManager:GetMarch(gatherUuid)
                    needCloseWorldPointUI = false
                    needCloseUI[UIWindowNames.UIWorldPoint] = nil
                    local isAlliance = 0
                    if marchInfo.allianceUid ~= "" and marchInfo.allianceUid == LuaEntry.Player.allianceId then
                        isAlliance = 1
                    end
                    if UIManager:GetInstance():IsWindowOpen(UIWindowNames.UIWorldPoint) then
                        local str = gatherUuid..";"..info.mainIndex..";"..marchInfo.ownerUid..";"..WorldPointUIType.CollectArmy..";"..isAlliance
                        EventManager:GetInstance():Broadcast(EventId.RefreshUIWorldPointView,str)
                    else
                        UIManager:GetInstance():OpenWindow(UIWindowNames.UIWorldPoint,{anim = true,playEffect = false,UIMainAnim = UIMainAnimType.LeftRightBottomHide},gatherUuid,info.mainIndex,marchInfo.ownerUid,WorldPointUIType.CollectArmy,isAlliance)
                    end
                else
                    local id = info.id
                    if id ==nil then
                        id = data.resourceId
                    end
                    local triggerType = GetTableData(TableName.GatherResource, id,"resource_type")
                    local resourceType = tonumber(triggerType)
                    triggerType = tostring(triggerType)
                    if DataCenter.GuideManager:CheckDoTriggerGuide(GuideTriggerType.ClickWorldCollectPoint, triggerType) then
                        local pos = SceneUtils.TileIndexToWorld(curIndex, ForceChangeScene.World)
                        GoToUtil.GotoWorldPos(pos)
                    else
                        needCloseWorldPointUI = false
                        needCloseUI[UIWindowNames.UIWorldPoint] = nil
                        local uiType = WorldPointUIType.CollectPoint
                        if UIManager:GetInstance():IsWindowOpen(UIWindowNames.UIWorldPoint) then
                            local str = "0"..";"..info.mainIndex..";"..""..";"..uiType..";".."0"..";".."0"
                            EventManager:GetInstance():Broadcast(EventId.RefreshUIWorldPointView,str)
                        else
                            UIManager:GetInstance():OpenWindow(UIWindowNames.UIWorldPoint,{anim = true,playEffect = false,UIMainAnim = UIMainAnimType.LeftRightBottomHide},0,info.mainIndex,"",uiType,0)
                        end
                    end
                end
                local param = {}
                param.point = info.pointIndex
                DataCenter.GuideManager:SetCompleteNeedParam(param)
                DataCenter.GuideManager:CheckGuideComplete()
            end
        elseif info.PointType == WorldPointType.SAMPLE_POINT or info.PointType == WorldPointType.SAMPLE_POINT_NEW then
            --local data = CS.SceneManager.World:GetSamplePointInfoByIndex(info.pointIndex)
            --UIManager:GetInstance():OpenWindow(UIWindowNames.UIWorldSamplePointUI, info.pointIndex, data.uuid)
            local data = DataCenter.WorldPointManager:GetSamplePointInfoByIndex(info.pointIndex)
            needCloseWorldPointUI = false
            needCloseUI[UIWindowNames.UIWorldPoint] = nil
            --DataCenter.TroopActionManager:DoTroopAction(TroopActionType.TROOP_ACTION_TYPE_RADAR_CENTER)
            if UIManager:GetInstance():IsWindowOpen(UIWindowNames.UIWorldPoint) then
                local str = data.uuid..";"..info.pointIndex..";"..""..";"..WorldPointUIType.Sample..";".."0"..";".."0"
                EventManager:GetInstance():Broadcast(EventId.RefreshUIWorldPointView,str)
            else
                UIManager:GetInstance():OpenWindow(UIWindowNames.UIWorldPoint,{anim = true,playEffect = false,UIMainAnim = UIMainAnimType.LeftRightBottomHide}, data.uuid, info.pointIndex, "", WorldPointUIType.Sample, 0)
            end
        elseif info.PointType == WorldPointType.EXPLORE_POINT or info.PointType == WorldPointType.DETECT_EVENT_PVE then
            local data = DataCenter.WorldPointManager:GetExplorePointInfoByIndex(info.pointIndex)
            needCloseWorldPointUI = false
            needCloseUI[UIWindowNames.UIWorldPoint] = nil
            if info.PointType == WorldPointType.EXPLORE_POINT then
                SoundUtil.PlayEffect(SoundAssets.Music_Effect_Click_Gulu)
            end
            --DataCenter.TroopActionManager:DoTroopAction(TroopActionType.TROOP_ACTION_TYPE_RADAR_CENTER)
            if UIManager:GetInstance():IsWindowOpen(UIWindowNames.UIWorldPoint) then
                local str = data.uuid..";"..info.pointIndex..";"..""..";"..WorldPointUIType.Explore..";".."0"..";".."0"
                EventManager:GetInstance():Broadcast(EventId.RefreshUIWorldPointView,str)
            else
                UIManager:GetInstance():OpenWindow(UIWindowNames.UIWorldPoint,{anim = true,playEffect = false,UIMainAnim = UIMainAnimType.LeftRightBottomHide}, data.uuid, info.pointIndex, "", WorldPointUIType.Explore, 0)
            end
            --UIManager:GetInstance():OpenWindow(UIWindowNames.UIWorldExplorePointUI, info.pointIndex, data.uuid)

        elseif info.PointType == WorldPointType.GARBAGE then
            SoundUtil.PlayEffect(SoundAssets.Music_Effect_Click_GroundGoods)
            local param = {}
            param.isClickGarbage = true
            DataCenter.GuideManager:SetCompleteNeedParam(param)
            DataCenter.GuideManager:CheckGuideComplete()
            --UIManager:GetInstance():OpenWindow(UIWindowNames.UIWorldGarbagePointUI, info.pointIndex)
            local data = DataCenter.WorldPointManager:GetGarbagePointInfoByIndex(info.pointIndex)
            needCloseWorldPointUI = false
            needCloseUI[UIWindowNames.UIWorldPoint] = nil
            if UIManager:GetInstance():IsWindowOpen(UIWindowNames.UIWorldPoint) then
                local str = data.uuid..";"..info.pointIndex..";"..""..";"..WorldPointUIType.PickGarbage..";".."0"..";".."0"
                EventManager:GetInstance():Broadcast(EventId.RefreshUIWorldPointView,str)
            else
                UIManager:GetInstance():OpenWindow(UIWindowNames.UIWorldPoint,{anim = true,playEffect = false,UIMainAnim = UIMainAnimType.LeftRightBottomHide}, data.uuid, info.pointIndex, "", WorldPointUIType.PickGarbage, 0)
            end

        elseif info.PointType == WorldPointType.WORLD_ALLIANCE_CITY then
            if info~=nil then
                local allianceCityPointInfo = PBController.ParsePbFromBytes(info.extraInfo, "protobuf.AllianceCityPointInfo")
                if allianceCityPointInfo~=nil then
                    needCloseUI[UIWindowNames.UIWorldSiegePoint] = nil
                    local cityId = allianceCityPointInfo.cityId
                    local tile = GetTableData(TableName.WorldCity,cityId, "size")
                    local eden_city_type = GetTableData(TableName.WorldCity,cityId, "eden_city_type")
                    local showGuide = false
                    if LuaEntry.Player.serverType == ServerType.EDEN_SERVER then
                        if eden_city_type == WorldCityType.AlliancePass then
                            showGuide = DataCenter.GuideManager:CheckDoTriggerGuide(GuideTriggerType.EnterSeasonOpenIntro,tostring(SeasonIntroType.Pass))
                        elseif eden_city_type == WorldCityType.StrongHold then
                            showGuide = DataCenter.GuideManager:CheckDoTriggerGuide(GuideTriggerType.EnterSeasonOpenIntro,tostring(SeasonIntroType.Stronghold))
                        end
                    end
                    if showGuide ==false then
                        local worldPos = SceneUtils.TileIndexToWorld(info.mainIndex)
                        worldPos.x = worldPos.x - tile+1
                        worldPos.z = worldPos.z - tile+1
                        local pointIndex = SceneUtils.WorldToTileIndex(worldPos)
                        UIManager:GetInstance():OpenWindow(UIWindowNames.UIWorldSiegePoint, allianceCityPointInfo.cityId,pointIndex)
                    else
                        local worldPos = SceneUtils.TileIndexToWorld(info.mainIndex)
                        worldPos.x = worldPos.x - tile+1
                        worldPos.z = worldPos.z - tile+1
                        local pointIndex = SceneUtils.WorldToTileIndex(worldPos)
                        DataCenter.GuideManager:SetGuideEndCallBack(function()
                            UIManager:GetInstance():OpenWindow(UIWindowNames.UIWorldSiegePoint, cityId,pointIndex)
                        end)
                    end
                end
            end
        elseif info.PointType == WorldPointType.WORLD_ALLIANCE_BUILD then
            local alMinePointInfo = PBController.ParsePbFromBytes(info.extraInfo, "protobuf.AllianceBuildingPointInfo")
            if alMinePointInfo then
                needCloseWorldPointUI = false
                needCloseUI[UIWindowNames.UIWorldPoint] = nil
                local buildId = alMinePointInfo["buildId"]
                if buildId == BuildingTypes.ALLIANCE_FLAG_BUILD or WorldAllianceBuildUtil.IsAllianceCenterGroup(buildId) ==true or WorldAllianceBuildUtil.IsAllianceFrontGroup(buildId) then
                    if UIManager:GetInstance():IsWindowOpen(UIWindowNames.UIWorldPoint) then
                        local str = info.uuid..";"..info.mainIndex..";"..""..";"..WorldPointUIType.AllianceBuild..";".."0"..";"..buildId
                        EventManager:GetInstance():Broadcast(EventId.RefreshUIWorldPointView,str)
                    else
                        UIManager:GetInstance():OpenWindow(UIWindowNames.UIWorldPoint,{anim = true,playEffect = false,UIMainAnim = UIMainAnimType.LeftRightBottomHide},info.uuid,info.mainIndex,"",WorldPointUIType.AllianceBuild,0,buildId)
                    end
                elseif WorldAllianceBuildUtil.IsAllianceMineGroup(buildId) then
                    if UIManager:GetInstance():IsWindowOpen(UIWindowNames.UIWorldPoint) then
                        local str = info.uuid..";"..info.mainIndex..";"..""..";"..WorldPointUIType.AllianceMine..";".."0"..";"..buildId
                        EventManager:GetInstance():Broadcast(EventId.RefreshUIWorldPointView,str)
                    else
                        UIManager:GetInstance():OpenWindow(UIWindowNames.UIWorldPoint,{anim = true,playEffect = false,UIMainAnim = UIMainAnimType.LeftRightBottomHide},info.uuid,info.mainIndex,"",WorldPointUIType.AllianceMine,0,buildId)
                    end
                elseif WorldAllianceBuildUtil.IsAllianceActMineGroup(buildId) then
                    if UIManager:GetInstance():IsWindowOpen(UIWindowNames.UIWorldPoint) then
                        local str = info.uuid..";"..info.mainIndex..";"..""..";"..WorldPointUIType.AllianceActMine..";".."0"..";"..buildId
                        EventManager:GetInstance():Broadcast(EventId.RefreshUIWorldPointView,str)
                    else
                        UIManager:GetInstance():OpenWindow(UIWindowNames.UIWorldPoint,{anim = true,playEffect = false,UIMainAnim = UIMainAnimType.LeftRightBottomHide},info.uuid,info.mainIndex,"",WorldPointUIType.AllianceActMine,0,buildId)
                    end
                end
                
            end
        elseif info.PointType == WorldPointType.DRAGON_BUILDING then
            local buildInfo = PBController.ParsePbFromBytes(info.extraInfo, "protobuf.DragonBuildingPointInfo")
            if buildInfo then
                needCloseWorldPointUI = false
                needCloseUI[UIWindowNames.UIWorldPoint] = nil
                local buildId = buildInfo["buildId"]
                if UIManager:GetInstance():IsWindowOpen(UIWindowNames.UIWorldPoint) then
                    local str = info.uuid..";"..info.mainIndex..";"..""..";"..WorldPointUIType.DragonBuild..";".."0"..";"..buildId
                    EventManager:GetInstance():Broadcast(EventId.RefreshUIWorldPointView,str)
                else
                    UIManager:GetInstance():OpenWindow(UIWindowNames.UIWorldPoint,{anim = true,playEffect = false,UIMainAnim = UIMainAnimType.LeftRightBottomHide},info.uuid,info.mainIndex,"",WorldPointUIType.DragonBuild,0,buildId)
                end

            end
        elseif info.PointType == WorldPointType.SECRET_KEY then
            needCloseWorldPointUI = false
            needCloseUI[UIWindowNames.UIWorldPoint] = nil
            if UIManager:GetInstance():IsWindowOpen(UIWindowNames.UIWorldPoint) then
                local str = info.uuid..";"..info.mainIndex..";"..""..";"..WorldPointUIType.DragonSecretKey
                EventManager:GetInstance():Broadcast(EventId.RefreshUIWorldPointView,str)
            else
                UIManager:GetInstance():OpenWindow(UIWindowNames.UIWorldPoint,{anim = true,playEffect = false,UIMainAnim = UIMainAnimType.LeftRightBottomHide},info.uuid,info.mainIndex,"",WorldPointUIType.DragonSecretKey)
            end
        elseif info.PointType == WorldPointType.HERO_DISPATCH then
            needCloseWorldPointUI = false
            needCloseUI[UIWindowNames.UIWorldPoint] = nil
            if UIManager:GetInstance():IsWindowOpen(UIWindowNames.UIWorldPoint) then
                local str = info.uuid..";"..info.mainIndex..";"..""..";"..WorldPointUIType.DispatchTask..";".."0"..";".."0"
                EventManager:GetInstance():Broadcast(EventId.RefreshUIWorldPointView,str)
            else
                UIManager:GetInstance():OpenWindow(UIWindowNames.UIWorldPoint,{anim = true,playEffect = false,UIMainAnim = UIMainAnimType.LeftRightBottomHide}, info.uuid, info.mainIndex, "", WorldPointUIType.DispatchTask, 0)
            end
        elseif info.PointType == WorldPointType.WorldRuinPoint then
            needCloseWorldPointUI = false
            needCloseUI[UIWindowNames.UIWorldPoint] = nil
            local ownerUid = ""
            local isAlliance = 0
            local desertId = 0
            local uuid = 0

            if LuaEntry.Player.serverType ~= ServerType.DRAGON_BATTLE_FIGHT_SERVER and ((SeasonUtil.IsInSeasonDesertMode() and CrossServerUtil:GetIsCrossServer() ==false) or (CrossServerUtil:GetIsCrossServer() and CrossServerUtil.GetCrossServerFightIsInSeason()) or (CrossServerUtil:GetIsCrossServer() and CrossServerUtil:GetIsInBattleServerGroup(LuaEntry.Player:GetCurServerId())==true))then
                local worldTileInfo = CS.SceneManager.World:GetWorldTileInfo(curIndex)
                if worldTileInfo~=nil then
                    local desertInfo = worldTileInfo:GetWorldDesertInfo()
                    if desertInfo~=nil then
                        ownerUid = desertInfo.ownerUid
                        local allianceId = desertInfo.allianceId
                        if allianceId ~= "" and allianceId == LuaEntry.Player.allianceId then
                            isAlliance = 1
                        end
                        desertId = desertInfo.desertId
                        uuid =desertInfo.uuid
                    end
                end
                local level = GetTableData(TableName.Desert,desertId, "desert_level")
                local checkLevel = toInt(level)
                local canClick = true
                if checkLevel == nil or checkLevel<=0 then
                    if (SceneUtils.IsInBlackRange(curIndex)==true and LuaEntry.DataConfig:CheckSwitch("rocky_groud_season")==false) then
                        canClick = false
                    end
                end
                if canClick== true and (not string.IsNullOrEmpty(ownerUid) or not DataCenter.MissileManager:IsRuinPoint(curIndex)) then
                    if UIManager:GetInstance():IsWindowOpen(UIWindowNames.UIWorldPoint)==false then
                        UIManager:GetInstance():OpenWindow(UIWindowNames.UIWorldPoint,{anim = true,playEffect = false,UIMainAnim = UIMainAnimType.LeftRightBottomHide},uuid, curIndex,ownerUid, WorldPointUIType.Desert, isAlliance,0,nil,desertId)
                    else
                        if tonumber(level) ~= nil and tonumber(level) > 0 then
                            local str = uuid..";"..curIndex..";"..ownerUid..";"..WorldPointUIType.Desert..";"..isAlliance..";".."0"..";".."0"..";"..desertId
                            EventManager:GetInstance():Broadcast(EventId.RefreshUIWorldPointView,str)
                        end
                    end
                end
            end
            if string.IsNullOrEmpty(ownerUid) then
                if UIManager:GetInstance():IsWindowOpen(UIWindowNames.UIWorldPoint) then
                    local str = info.uuid..";"..info.pointIndex..";"..""..";"..WorldPointUIType.Ruin..";"..isAlliance..";".."0"..";".."0"..";"..desertId
                    EventManager:GetInstance():Broadcast(EventId.RefreshUIWorldPointView,str)
                else
                    UIManager:GetInstance():OpenWindow(UIWindowNames.UIWorldPoint,{anim = true,playEffect = false,UIMainAnim = UIMainAnimType.LeftRightBottomHide}, info.uuid, info.pointIndex, "", WorldPointUIType.Ruin, isAlliance, 0,nil,desertId)
                end
            end
        elseif info.PointType == WorldPointType.WorldMonster then
            local marchInfo = PBController.ParsePbFromBytes(info.extraInfo, "protobuf.WorldPointMonster")
            if marchInfo then
                needCloseWorldPointUI = false
                needCloseUI[UIWindowNames.UIWorldPoint] = nil
                if marchInfo.type == MONSTER or marchInfo.type == BOSS then
                    if UIManager:GetInstance():IsWindowOpen(UIWindowNames.UIWorldPoint) then
                        local str = info.uuid..";"..info.pointIndex..";"..""..";"..WorldPointUIType.Monster..";".."0"..";".."0"
                        EventManager:GetInstance():Broadcast(EventId.RefreshUIWorldPointView,str)
                    else
                        UIManager:GetInstance():OpenWindow(UIWindowNames.UIWorldPoint,{anim = true,playEffect = false,UIMainAnim = UIMainAnimType.LeftRightBottomHide},info.uuid, info.pointIndex,"",WorldPointUIType.Monster,0,0)
                    end
                elseif marchInfo.type == ACT_BOSS then
                    local isCanShowWorldPointView = false
                    local dataList = DataCenter.ActivityListDataManager:GetActivityDataByType(ActivityEnum.ActivityType.WorldBoss)
                    if #dataList > 0 then
                        isCanShowWorldPointView = DataCenter.ActivityListDataManager:CheckIsSend(dataList[1])
                    end
                    if isCanShowWorldPointView then
                        if UIManager:GetInstance():IsWindowOpen(UIWindowNames.UIWorldPoint) then
                            local str = info.uuid..";"..info.pointIndex..";"..""..";"..WorldPointUIType.ActBoss..";".."0"..";".."0"
                            EventManager:GetInstance():Broadcast(EventId.RefreshUIWorldPointView,str)
                        else
                            UIManager:GetInstance():OpenWindow(UIWindowNames.UIWorldPoint,{anim = true,playEffect = false,UIMainAnim = UIMainAnimType.LeftRightBottomHide},info.uuid, info.pointIndex,"",WorldPointUIType.ActBoss,0,0)
                        end
                    else
                        if UIManager:GetInstance():IsWindowOpen(UIWindowNames.UIWorldPoint) then
                            UIManager:GetInstance():DestroyWindow(UIWindowNames.UIWorldPoint)
                        end
                        UIUtil.ShowTips(Localization:GetString("140212", dataList[1].needMainCityLevel))
                    end
                    
                elseif marchInfo.type == PUZZLE_BOSS then
                    if UIManager:GetInstance():IsWindowOpen(UIWindowNames.UIWorldPoint) then
                        local str = info.uuid..";"..info.pointIndex..";"..""..";"..WorldPointUIType.PuzzleBoss..";".."0"..";".."0"
                        EventManager:GetInstance():Broadcast(EventId.RefreshUIWorldPointView,str)
                    else
                        UIManager:GetInstance():OpenWindow(UIWindowNames.UIWorldPoint,{anim = true,playEffect = false,UIMainAnim = UIMainAnimType.LeftRightBottomHide},info.uuid, info.pointIndex,"",WorldPointUIType.PuzzleBoss,0,0)
                    end
                elseif marchInfo.type == CHALLENGE_BOSS then
                    local isCanShowWorldPointView = false
                    local dataList = DataCenter.ActivityListDataManager:GetActivityDataByType(ActivityEnum.ActivityType.MonsterTower)
                    if #dataList > 0 then
                        isCanShowWorldPointView = DataCenter.ActivityListDataManager:CheckIsSend(dataList[1])
                    end
                    if isCanShowWorldPointView then
                        if UIManager:GetInstance():IsWindowOpen(UIWindowNames.UIWorldPoint) then
                            local str = info.uuid..";"..info.pointIndex..";"..""..";"..WorldPointUIType.ChallengeBoss..";".."0"..";".."0"
                            EventManager:GetInstance():Broadcast(EventId.RefreshUIWorldPointView,str)
                        else
                            UIManager:GetInstance():OpenWindow(UIWindowNames.UIWorldPoint,{anim = true,playEffect = false,UIMainAnim = UIMainAnimType.LeftRightBottomHide},info.uuid, info.pointIndex,"",WorldPointUIType.ChallengeBoss,0,0)
                        end
                    else
                        if UIManager:GetInstance():IsWindowOpen(UIWindowNames.UIWorldPoint) then
                            UIManager:GetInstance():DestroyWindow(UIWindowNames.UIWorldPoint)
                        end
                        UIUtil.ShowTips(Localization:GetString("140212", dataList[1].needMainCityLevel))
                    end
                elseif marchInfo.type == ALLIANCE_BOSS then
                    if UIManager:GetInstance():IsWindowOpen(UIWindowNames.UIWorldPoint) then
                        local str = info.uuid..";"..info.pointIndex..";"..""..";"..WorldPointUIType.AllianceBoss..";".."0"..";".."0"
                        EventManager:GetInstance():Broadcast(EventId.RefreshUIWorldPointView,str)
                    else
                        UIManager:GetInstance():OpenWindow(UIWindowNames.UIWorldPoint,{anim = true,playEffect = false,UIMainAnim = UIMainAnimType.LeftRightBottomHide},info.uuid, info.pointIndex,"",WorldPointUIType.AllianceBoss,0,0)
                    end
                end
            end
        end
    else
        if  LuaEntry.Player.serverType ~= ServerType.DRAGON_BATTLE_FIGHT_SERVER and ((SeasonUtil.IsInSeasonDesertMode() and CrossServerUtil:GetIsCrossServer() ==false) or (CrossServerUtil:GetIsCrossServer() and CrossServerUtil.GetCrossServerFightIsInSeason()) or (CrossServerUtil:GetIsCrossServer() and CrossServerUtil:GetIsInBattleServerGroup(LuaEntry.Player:GetCurServerId())==true)) 
           or  (CrossServerUtil:GetIsCrossServer() and CrossServerUtil.GetActCrossServerIsInSeason())   then
            local ownerUid = ""
            local isAlliance = 0
            local desertId = 0
            local uuid = 0
            local worldTileInfo = CS.SceneManager.World:GetWorldTileInfo(curIndex)
            if worldTileInfo~=nil then
                local desertInfo = worldTileInfo:GetWorldDesertInfo()
                if desertInfo~=nil then
                    ownerUid = desertInfo.ownerUid
                    local allianceId = desertInfo.allianceId
                    if allianceId ~= "" and allianceId == LuaEntry.Player.allianceId then
                        isAlliance = 1
                    end
                    desertId = desertInfo.desertId
                    uuid =desertInfo.uuid
                end
            end
            local level = GetTableData(TableName.Desert,desertId, "desert_level")
            local checkLevel = toInt(level)
            local canClick = true
            if checkLevel == nil or checkLevel<=0 then

                if LuaEntry.Player.serverType == ServerType.EDEN_SERVER then
                    if CS.SceneManager.World:IsTileWalkable(CS.SceneManager.World:IndexToTilePos(curIndex))==false then
                        canClick = false
                    end
                else
                    if (SceneUtils.IsInBlackRange(curIndex)==true and LuaEntry.DataConfig:CheckSwitch("rocky_groud_season")==false) then
                        canClick = false
                    end
                end
            end
            if canClick == true then
                if UIManager:GetInstance():IsWindowOpen(UIWindowNames.UIWorldPoint)==false then
                    needCloseWorldPointUI = false
                    needCloseUI[UIWindowNames.UIWorldPoint] = nil
                    UIManager:GetInstance():OpenWindow(UIWindowNames.UIWorldPoint,{anim = true,playEffect = false,UIMainAnim = UIMainAnimType.LeftRightBottomHide},uuid, curIndex,ownerUid, WorldPointUIType.Desert, isAlliance,0,nil,desertId)
                else
                    if tonumber(level) ~= nil and tonumber(level) > 0 then
                        needCloseWorldPointUI = false
                        needCloseUI[UIWindowNames.UIWorldPoint] = nil
                        local str = uuid..";"..curIndex..";"..ownerUid..";"..WorldPointUIType.Desert..";"..isAlliance..";".."0"..";".."0"..";"..desertId
                        EventManager:GetInstance():Broadcast(EventId.RefreshUIWorldPointView,str)
                    end
                end
            end
        end
        
    end
    if needCloseWorldPointUI == true then
        SoundUtil.PlayEffect(SoundAssets.Music_Effect_Click_Empty)
        if UIManager:GetInstance():IsWindowOpen(UIWindowNames.UIWorldPoint) then
            UIManager:GetInstance():DestroyWindow(UIWindowNames.UIWorldPoint)
        end
    end
    for k,v in pairs(needCloseUI) do
        if v then
            if k == UIWindowNames.UIFormationSelectListNew then
                if UIManager:GetInstance():IsWindowOpen(k) then
                    EventManager:GetInstance():Broadcast(EventId.UIMAIN_VISIBLE, true)
                end

            end
            UIManager:GetInstance():DestroyWindow(k)
        end
    end
    --if UIManager:GetInstance():IsWindowOpen(UIWindowNames.UIFormationSelectListNew) then
    --    UIManager:GetInstance():DestroyWindow(UIWindowNames.UIFormationSelectListNew)
    --    EventManager:GetInstance():Broadcast(EventId.UIMAIN_VISIBLE, true)
    --end

    if needCloseIsFocus then
        --先特殊处理
        if not UIManager:GetInstance():IsWindowOpen(UIWindowNames.UIMoveCity) then
            CS.SceneManager.World:QuitFocus(LookAtFocusTime)
        end
    end
end

local function CloseWorldMarchTileUI(uuid)
    if uuid~=nil then
        WorldBattleSiegeEffectManager:GetInstance():CheckRemove(uuid)
        WorldMarchTileUIManager:GetInstance():RemoveTroopByUuid(uuid)
        WorldMarchEmotionManager:GetInstance():DestroyPanel(uuid)
    else
        WorldMarchTileUIManager:GetInstance():RemoveTroop()
        WorldMarchEmotionManager:GetInstance():DestroyAllPanels()
    end
end

local function OnClickCity(curIndex,clickType)
    if DataCenter.GuideManager:GetGuideType() == GuideType.Bubble then
        return
    end
    if UIManager:GetInstance():IsWindowOpen(UIWindowNames.UINoInput) or
       UIManager:GetInstance():IsWindowOpen(UIWindowNames.UISceneNoInput) then
        return
    end
    local needChangeCamera =  UIUtil.CheckNeedQuitFocus()
    UIUtil.ClickWorldCloseWorldUI()
    local needCloseIsFocus = true
    --if UIManager:GetInstance():IsWindowOpen(UIWindowNames.UIFormationSelectListNew) then
    --    UIManager:GetInstance():DestroyWindow(UIWindowNames.UIFormationSelectListNew)
    --    EventManager:GetInstance():Broadcast(EventId.UIMAIN_VISIBLE, true)
    --end
    EventManager:GetInstance():Broadcast(EventId.ClickAny)
    local needCloseUI = {}
    for k,v in ipairs(ClickUINeedCloseExtraWorldUI) do
        needCloseUI[v] = true
    end
    local needCloseGotoMoveBubble = true
    local needCloseWorldPointUI = true
    EventManager:GetInstance():Broadcast(EventId.OnClickWorld,curIndex)

    local type = DataCenter.CityPointManager:GetPointType(curIndex)
    if clickType == ClickWorldType.Collider then
        if type ~= CityPointType.Other then
            WorldMarchTileUIManager:GetInstance():RemoveTroop()
        end
    elseif clickType == ClickWorldType.Ground then
        WorldMarchTileUIManager:GetInstance():RemoveTroop()
    end

    if type == CityPointType.Building then
        local buildData = DataCenter.BuildManager:GetBuildingDataByPointId(curIndex, false)
        if buildData ~= nil then
            local buildId = buildData.itemId
            local buildTemplate = DataCenter.BuildTemplateManager:GetBuildingDesTemplate(buildId)
            if buildData.itemId == BuildingTypes.FUN_BUILD_MAIN then
                local isFinish = DataCenter.BuildManager:CheckSendBuildFinish(buildData.uuid)
                if isFinish then
                    if not DataCenter.GuideManager:InGuide() then
                        DataCenter.FurnitureManager:SetEnterPanelCameraPosParam(CS.SceneManager.World.CurTarget)
                    end
                    UIManager:GetInstance():OpenWindow(UIWindowNames.UIBuildOpenFire)
                end
            elseif buildData.itemId~= BuildingTypes.APS_BUILD_WORMHOLE_SUB and buildData.itemId~= BuildingTypes.WORM_HOLE_CROSS and BuildingUtils.IsInEdenSubwayGroup(buildData.itemId)==false then
                --点击建筑
                local isFinish = DataCenter.BuildManager:CheckSendBuildFinish(buildData.uuid)
                if isFinish ==true then
                    local bUuid = buildData.uuid
                    if buildData.level == 0 then
                        if buildData.updateTime == 0 then
                            if not DataCenter.GuideManager:InGuide() then
                                DataCenter.FurnitureManager:SetEnterPanelCameraPosParam(CS.SceneManager.World.CurTarget)
                            end
                            GoToUtil.GotoOpenBuildCreateWindow(UIWindowNames.UIBuildCreate, NormalPanelAnim, {buildId = buildData.itemId})
                        end
                    else
                        if buildTemplate.build_type ~= BuildType.Second or buildTemplate.id == BuildingTypes.APS_BUILD_WORMHOLE_MAIN
                                or buildTemplate.id == BuildingTypes.APS_BUILD_WORMHOLE_SUB or BuildingUtils.IsInEdenSubwayGroup(buildTemplate.id)==true then--加了虫洞特殊规则
                            needCloseUI[UIWindowNames.UIWorldTileUI] = nil
                            if buildData ~= nil then
                                if buildData:IsUpgrading()== true then
                                    SoundUtil.PlayEffect(SoundAssets.Music_Effect_Click_Building_In_Upgrade)
                                else
                                    SoundUtil.PlayEffect(SoundAssets.Music_Effect_Click_Building)
                                end
                            else
                                SoundUtil.PlayEffect(SoundAssets.Music_Effect_Click_Building)
                            end
                            if buildTemplate.id == BuildingTypes.FUN_BUILD_ARENA then
                                UIManager:GetInstance():OpenWindow(UIWindowNames.UIArenaMain,{anim = false})
                            elseif buildTemplate.id == BuildingTypes.FUN_BUILD_MILESTONE then
                            elseif buildTemplate.id == BuildingTypes.FUN_BUILD_BELL then
                                DataCenter.BellManager:ClickBell()
                            --elseif buildTemplate.id == BuildingTypes.FUN_BUILD_RADAR_CENTER then
                            --    UIManager:GetInstance():OpenWindow(UIWindowNames.UIDetectEvent)
                            --elseif buildTemplate.id == BuildingTypes.APS_BUILD_PUB then
                            --    UIManager:GetInstance():OpenWindow(UIWindowNames.UIHeroRecruit)
                            elseif buildTemplate.id == BuildingTypes.FUN_BUILD_OPINION_BOX then
                                UIManager:GetInstance():OpenWindow(UIWindowNames.UIOpinionBox)
                            elseif buildTemplate.id == BuildingTypes.DS_EXPLORER_CAMP then
                                if DataCenter.LandManager:IsFunctionEnd() then
                                    --打开推图关
                                    UIManager:GetInstance():OpenWindow(UIWindowNames.UIJeepAdventureMain,  { anim = true })
                                else
                                    --打开挂机奖励
                                    UIManager:GetInstance():OpenWindow(UIWindowNames.UIJeepAdventureReward, NormalPanelAnim)
                                end
                            elseif buildTemplate.id == BuildingTypes.FUN_BUILD_TRAINFIELD_4 and DataCenter.MonthCardNewManager:CheckIfGolloesMonthCardAvailable() and DataCenter.MonthCardNewManager:CheckIfMonthCardActive()==false then
                                UIManager:GetInstance():OpenWindow(UIWindowNames.UIGiftPackage, { anim = true }, { welfareTagType = WelfareTagType.MonthCard })
                            else
                                local levelTemplate = DataCenter.BuildTemplateManager:GetBuildingLevelTemplate(buildTemplate.id, 0)
                                if levelTemplate ~= nil and levelTemplate:IsFurnitureBuild() then
                                    if not DataCenter.GuideManager:InGuide() then
                                        DataCenter.FurnitureManager:SetEnterPanelCameraPosParam(CS.SceneManager.World.CurTarget)
                                    end
                                    if buildData:IsUpgrading() then
                                        GoToUtil.GotoOpenBuildCreateWindow(UIWindowNames.UIBuildCreate, NormalPanelAnim, {buildId = buildData.itemId})
                                    else
                                        UIManager:GetInstance():OpenWindow(UIWindowNames.UIFurnitureUpgrade, NormalPanelAnim, {buildUuid = bUuid})
                                    end
                                    --local destroyType = buildData:GetDestroyType()
                                    --if destroyType == BuildingDestroyType.None then
                                    --    -- 未被毁
                                    --    if buildData:IsUpgrading() then
                                    --        GoToUtil.GotoOpenBuildCreateWindow(UIWindowNames.UIBuildCreate, NormalPanelAnim, {buildId = buildData.itemId})
                                    --    else
                                    --        UIManager:GetInstance():OpenWindow(UIWindowNames.UIFurnitureUpgrade, NormalPanelAnim, {buildUuid = bUuid})
                                    --    end
                                    --else
                                    --    -- 已被毁
                                    --    local curTime = UITimeManager:GetInstance():GetServerTime()
                                    --    local dayNight = DataCenter.VitaManager:GetDayNight(curTime)
                                    --    if dayNight == VitaDefines.DayNight.Day then
                                    --        local hudItem = DataCenter.CityHudManager:GetHudItem(buildData.uuid, CityHudType.Repair)
                                    --        if hudItem and hudItem.OnClick then
                                    --            hudItem:OnClick()
                                    --        end
                                    --    else
                                    --        UIUtil.ShowTipsId(450226)
                                    --    end
                                    --end
                                else
                                    if UIManager:GetInstance():IsWindowOpen(UIWindowNames.UIWorldTileUI) then
                                        EventManager:GetInstance():Broadcast(EventId.RefreshUIWorldTileUI, tostring(curIndex))
                                    else
                                        UIManager:GetInstance():OpenWindow(UIWindowNames.UIWorldTileUI,
                                                {anim = true, playEffect = false},
                                                tostring(curIndex),needChangeCamera)
                                    end
                                end
                            end
                        end
                    end
                end
            end
            local param = {}
            param.buildId = buildId
            DataCenter.GuideManager:SetCompleteNeedParam(param)
            DataCenter.GuideManager:CheckGuideComplete()
        end
    elseif type == CityPointType.ZeroFakeBuild then
        local info = DataCenter.BuildCityBuildManager:GetCityBuildDataByPoint(curIndex)
        if info ~= nil then
            local buildData = DataCenter.BuildManager:GetBuildingDataByPointId(curIndex, false)
            if buildData ~= nil then
                local isFinish = DataCenter.BuildManager:CheckSendBuildFinish(buildData.uuid)
                if isFinish ==true then
                    if info.state == BuildCityBuildState.Fake then
                        if not DataCenter.GuideManager:InGuide() then
                            DataCenter.FurnitureManager:SetEnterPanelCameraPosParam(CS.SceneManager.World.CurTarget)
                        end
                        GoToUtil.GotoOpenBuildCreateWindow(UIWindowNames.UIBuildCreate, NormalPanelAnim, {buildId = info.buildId})
                        local param = {}
                        param.buildId = info.buildId
                        DataCenter.GuideManager:SetCompleteNeedParam(param)
                        DataCenter.GuideManager:CheckGuideComplete()
                    end
                end
            else
                if info.state == BuildCityBuildState.Fake then
                    local buildingId = info.buildId
                    local needOpen = true
                    if not DataCenter.GuideManager:InGuide() then
                        DataCenter.FurnitureManager:SetEnterPanelCameraPosParam(CS.SceneManager.World.CurTarget)
                    end
                    local levelTemplate = DataCenter.BuildTemplateManager:GetBuildingLevelTemplate(buildingId,0)
                    if levelTemplate ~= nil then
                        local needBoxConfig = toInt(levelTemplate.need_open)
                        if needBoxConfig ==1 then
                            needOpen = false
                        end
                    end
                    if needOpen ==false then
                        local param = {}
                        param.robotUuid = 0
                        param.buildingId = buildingId
                        param.itemUuid = ""
                        local needPathTime = 0
                        param.pathTime = needPathTime
                        param.targetServerId = LuaEntry.Player:GetCurServerId()
                        if DataCenter.BuildQueueManager:IsCanUpgrade(buildingId, 0) then
                            local curLevelTemplate = DataCenter.BuildTemplateManager:GetBuildingLevelTemplate(buildingId, 0)
                            if curLevelTemplate.no_queue == BuildNoQueue.No then
                                local useTime = curLevelTemplate:GetBuildTime()
                                if useTime > 0 then
                                    local buildTemplate = DataCenter.BuildTemplateManager:GetBuildingDesTemplate(buildingId)
                                    local robot = DataCenter.BuildQueueManager:GetFreeQueue(buildTemplate:IsSeasonBuild())
                                    if robot ~= nil then
                                        param.robotUuid = robot.uuid
                                    end
                                end
                            end
                            SFSNetwork.SendMessage(MsgDefines.FreeBuildingPlaceNew, param)
                        else
                            local buildQueueParam = {}
                            buildQueueParam.enterType = UIBuildQueueEnterType.Build
                            buildQueueParam.messageParam = param
                            buildQueueParam.buildId = buildingId
                            GoToUtil.GotoOpenBuildQueueWindow(buildQueueParam)
                        end
                    else
                        GoToUtil.GotoOpenBuildCreateWindow(UIWindowNames.UIBuildCreate, NormalPanelAnim, {buildId = info.buildId})
                        local param = {}
                        param.buildId = info.buildId
                        DataCenter.GuideManager:SetCompleteNeedParam(param)
                        DataCenter.GuideManager:CheckGuideComplete()
                    end
                    
                   
                end
            end
            
        end
    else

    end
    if needCloseGotoMoveBubble then
        DataCenter.GotoMoveBubbleManager:RemoveUI()
    end
    if needCloseWorldPointUI == true then
        if UIManager:GetInstance():IsWindowOpen(UIWindowNames.UIWorldPoint) then
            UIManager:GetInstance():DestroyWindow(UIWindowNames.UIWorldPoint)
        end
    end
    for k,v in pairs(needCloseUI) do
        if v then
            if DataCenter.GuideManager:IsCanCloseUI(k) then
                UIManager:GetInstance():DestroyWindow(k)
            else
                needCloseIsFocus = false
            end
        end
    end
    if needCloseIsFocus then
        --先特殊处理
        if not UIManager:GetInstance():IsWindowOpen(UIWindowNames.UIMoveCity) then
            CS.SceneManager.World:QuitFocus(LookAtFocusTime)
        end
    end
end

-- titleText:标题文本
-- tipText:描述文本
-- btnNum:按钮个数
-- text1:左边按钮名称（当btnNoUseDialog为true时表示内容，为空时表示多语言）
-- text2:右边按钮名称（当btnNoUseDialog为true时表示内容，为空时表示多语言）
-- action1:点击左边按钮回调函数
-- action2:点击右边按钮回调函数
-- closeAction:点击x和黑色背景回调函数
-- btnNoUseDialog:text1和text2类型 为true表示文本 为空表示多语言
-- leftBtnPicName:左边按钮图片路径
-- rightBtnPicName:右边按钮图片路径
local function ShowUseDiamondConfirm(todayType, tipText, btnNum, text1, text2, action1, action2, closeAction, titleText, btnNoUseDialog, leftBtnPicName, rightBtnPicName)
    local needShowConfirm = Setting:GetBool(SettingKeys.SHOW_USE_DIAMOND_ALERT, true)
    if needShowConfirm == true and DataCenter.SecondConfirmManager:GetTodayCanShowSecondConfirm(todayType) then
        UIUtil.ShowSecondMessage(titleText,tipText,btnNum,text1,text2, function()
            action1()
        end, function(needSellConfirm)
            DataCenter.SecondConfirmManager:SetTodayNoShowSecondConfirm(todayType, not needSellConfirm)
        end,action2,closeAction,nil,Localization:GetString(GameDialogDefine.TODAY_NO_SHOW), btnNoUseDialog, leftBtnPicName, rightBtnPicName)
    else
        action1()
    end
end

local function ShowUnlockWindow(title, icon, intro, type, flyEndPos)
    DataCenter.UnlockDataManager:AddData(title, icon, intro, type, flyEndPos)
    if UIManager:GetInstance():GetWindow(UIWindowNames.UIUnLockSuccess) == nil then
        local data = DataCenter.UnlockDataManager:GetFirstData()
        if data ~= nil then
            UIManager:GetInstance():OpenWindow(UIWindowNames.UIUnLockSuccess, { anim = true, playEffect = false, UIMainAnim = UIMainAnimType.LeftRightBottomHide }, data)
        end
    end
end

local function ShowGuideBtnUnlockWindow(title, icon, intro, btnType)
    DataCenter.UnlockDataManager:AddGuideBtnData(title, icon, intro, btnType)
    if UIManager:GetInstance():GetWindow(UIWindowNames.UIUnLockSuccess) == nil then
        local data = DataCenter.UnlockDataManager:GetFirstData()
        if data ~= nil then
            UIManager:GetInstance():OpenWindow(UIWindowNames.UIUnLockSuccess, { anim = true, playEffect = false, UIMainAnim = UIMainAnimType.LeftRightBottomHide }, data)
        end
    end
end

--获取UIMain保存节点的位置
local function GetUIMainSavePos(posType)
    if UIManager:GetInstance():IsPanelLoadingComplete(UIWindowNames.UIMain) then
        local window = UIManager:GetInstance():GetWindow(UIWindowNames.UIMain)
        if window ~= nil and window.View ~= nil then
            return window.View:GetSavePos(posType)
        end
    end
end

local function OnPointDownMarch(marchUuid)
    --TroopHeadUIManager:GetInstance():OnPointDownMarch(marchUuid)
end

local function OnPointUpMarch(marchUuid)
    --TroopHeadUIManager:GetInstance():OnPointUpMarch(marchUuid)
end

local function OnMarchDragStart(marchUuid)
    --UIUtil.CloseWorldMarchTileUI(marchUuid,true)
end

local function DoFly(rewardType, num, icon, srcPos, destPos, width, height, callback, useTextFormat,moveTime)
    DataCenter.FlyController.DoFly(rewardType, num, icon, srcPos, destPos, width, height, callback, useTextFormat,moveTime)
end

local function DoFlyCustom(icon, content, num, srcPos, destPos, width, height, callback, model,minRange ,maxRange, iconScale)
    DataCenter.FlyController.DoFlyCustom(icon, content, num, srcPos, destPos, width, height, callback, model, minRange, maxRange, iconScale)
end

local function GetSelfMarchCountExceptGolloes()
    local allianceId = LuaEntry.Player.allianceId
    local selfMarches = DataCenter.WorldMarchDataManager:GetOwnerMarches(LuaEntry.Player.uid, allianceId)
    local retCount = 0
    local count = #selfMarches
    for i = 1, count do
        local tempMarch = selfMarches[i]
        if tempMarch:GetMarchType()== NewMarchType.GOLLOES_EXPLORE and tempMarch:GetMarchType() == NewMarchType.GOLLOES_TRADE then
            retCount = retCount + 1
        end
    end
    return retCount
end

local function OpenConsumeItemView(consumeType)
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIConsumeItem, { anim = true}, consumeType)
end

local function OpenHeroStationByBuildUuid(bUuid)
    local stationId = DataCenter.HeroStationManager:GetStationIdByBuildUuid(bUuid)
    UIUtil.OpenHeroStationByStationId(stationId)
end

local function OpenHeroStationByStationId(stationId)
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIHeroStation, { anim = true, UIMainAnim = UIMainAnimType.AllHide }, stationId)
end

local function OpenHeroStationByEffectType(effectType, isArrow, highlightLevelUp)
    local skillId = DataCenter.HeroStationManager:GetSkillIdByEffectType(effectType)
    local stationId = DataCenter.HeroStationManager:GetStationIdBySkillId(skillId)
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIHeroStation, { anim = true, UIMainAnim = UIMainAnimType.AllHide }, stationId, isArrow, highlightLevelUp)
end

local function ShowPiggyBankTip(param)
    if UIManager:GetInstance():IsWindowOpen(UIWindowNames.UIPiggyBankTip) then
        local window = UIManager:GetInstance():GetWindow(UIWindowNames.UIPiggyBankTip)
        window.View:Refresh(param, 0)
    else
        UIManager:GetInstance():OpenWindow(UIWindowNames.UIPiggyBankTip, {anim = false}, param)
    end
end

local function ShowEnergyBankTip(param)
    if UIManager:GetInstance():IsWindowOpen(UIWindowNames.UIEnergyBankTip) then
        local window = UIManager:GetInstance():GetWindow(UIWindowNames.UIEnergyBankTip)
        window.View:Refresh(param, 0)
    else
        UIManager:GetInstance():OpenWindow(UIWindowNames.UIEnergyBankTip, {anim = false}, param)
    end
end

local function GetUIMainEnergySlider()
    if UIManager:GetInstance():IsPanelLoadingComplete(UIWindowNames.UIMain) then
        local window = UIManager:GetInstance():GetWindow(UIWindowNames.UIMain)
        if window ~= nil and window.View ~= nil then
            return window.View:GetEnergySlider()
        end
    end
    return nil
end

local function GetEnergyIconPos()
    return UIUtil.GetUIMainSavePos(UIMainSavePosType.Stamina)
end

local function ShowSelectArmy(param)
    local window = UIManager:GetInstance():GetWindow(UIWindowNames.UISelectArmy)
    if window == nil then
        UIManager:GetInstance():OpenWindow(UIWindowNames.UISelectArmy, { anim = false }, param)
    else
        window.View:ReInit(param)
        window.View:Show()
    end
end

local function ShowSelectHero(param)
    local window = UIManager:GetInstance():GetWindow(UIWindowNames.UISelectHero)
    if window == nil then
        UIManager:GetInstance():OpenWindow(UIWindowNames.UISelectHero, { anim = false }, param)
    else
        window.View:ReInit(param)
        window.View:Show()
    end
end

local function TryMoveCity(topType, targetPointIndex)
    if CrossServerUtil:GetIsCrossServer() then
        UIUtil.ShowTipsId(104266)
    else
        local mainBuild = DataCenter.BuildManager:GetFunbuildByItemID(BuildingTypes.FUN_BUILD_MAIN)
        if mainBuild~=nil then
            --local city = CS.SceneManager.World:GetWorldBuildingByUuid(mainBuild.uuid)
            --if city ~=nil then
            --    city:SetMoveState(true)
            --end
            if not targetPointIndex then
                targetPointIndex = LuaEntry.Player:GetMainWorldPos()
            end
            local level = mainBuild.level
            local id = BuildingTypes.FUN_BUILD_MAIN+level-1
            CS.SceneManager.World:UICreateBuilding(id, mainBuild.uuid, targetPointIndex, topType)
        end
    end
end

local function GetFlyTargetPosByRewardType(rewardType)
    if rewardType == RewardType.PEOPLE then
        return UIUtil.GetUIMainSavePos(UIMainSavePosType.People)
    elseif rewardType == RewardType.GOLD then
        return UIUtil.GetUIMainSavePos(UIMainSavePosType.Gold)
    elseif rewardType == RewardType.PVE_STAMINA then
        return UIUtil.GetUIMainSavePos(UIMainSavePosType.Stamina)
    elseif rewardType == RewardType.POWER then
        return UIUtil.GetUIMainSavePos(UIMainSavePosType.Power)
    elseif rewardType == RewardType.FORMATION_STAMINA then
        return UIUtil.GetUIMainSavePos(UIMainSavePosType.Stamina)
    elseif rewardType == RewardType.HERO then
        return UIUtil.GetUIMainSavePos(UIMainSavePosType.Hero)
    elseif rewardType == RewardType.GOODS then
        return UIUtil.GetUIMainSavePos(UIMainSavePosType.Goods)
    else
        return UIUtil.GetUIMainSavePos(UIMainSavePosType.Resource)
    end
end

local function ShowPvePowerLack(param)
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIPVEPowerLack, { anim = true }, param)
end

local function PveSceneHeroListRefresh()
    local window = UIManager:GetInstance():GetWindow(UIWindowNames.UIPVEScene)
    if window then
        window.View.hero_list:ResetHeroList()
        window.View.ctrl:OnOneKeyFillClick()
        window.View:RefreshArmy()
    end
end

local function PveSceneHeroListScrollToHero(heroUuid)
    local window = UIManager:GetInstance():GetWindow(UIWindowNames.UIPVEScene)
    if window then
        window.View.hero_list:ResetHeroList()
        window.View.hero_list:ScrollToHero(heroUuid, true)
    end
end

-- 每回一点体力需要时间
local function GetEnergyRecoverTime()
    local timeBase = LuaEntry.DataConfig:TryGetNum("car_stamina", "k2")
    local add = LuaEntry.Effect:GetGameEffect(EffectDefine.STAMINA_RECOVER_SPEED_ADD)
    local time = timeBase / (1 + (add / 100))
    return time
end

local function GetSpeedUpIcon(type)
    if LuaEntry.DataConfig:CheckSwitch("ABtest_aps_new_heroes") then
        if type == SpeedUpType.Build then
            return "Speedup_secretary"
        elseif type == SpeedUpType.Science then
            return "Speedup_Consigliere"
        end
    else
        if type == SpeedUpType.Build then
            return "Speedup_Consigliere"
        elseif type == SpeedUpType.Science then
            return "Speedup_FederalCop"
        end
    end
    return ""
end

local function GetSpeedUpHeroName(type)
    if LuaEntry.DataConfig:CheckSwitch("ABtest_aps_new_heroes") then
        if type == SpeedUpType.Build then
            return HeroUtils.GetHeroNameByConfigId(1012)
        elseif type == SpeedUpType.Science then
            return HeroUtils.GetHeroNameByConfigId(11001)
        end
    else
        if type == SpeedUpType.Build then
            return HeroUtils.GetHeroNameByConfigId(11001)
        elseif type == SpeedUpType.Science then
            return HeroUtils.GetHeroNameByConfigId(22001)
        end
    end
    return ""
end

local function IsSpeedUpIcon(icon)
    return icon == "Speedup_FederalCop" or
           icon == "Speedup_Consigliere" or
           icon == "Speedup_secretary" or
           icon == "Speedup_kongzhitai"
end

local function ShowVersionMessage(tipText,titleText)
    UIManager:GetInstance():OpenWindow(UIWindowNames.UICommonVersionUpdate)
    local window = UIManager:GetInstance():GetWindow(UIWindowNames.UICommonVersionUpdate)
    if window~=nil and window.View~=nil then
        window.View:SetData(tipText,titleText)
        if window.View:GetActive() then
            window.View:RefreshData()
        end
    end
end

--求AB对CD的交点
local function SegmentsInterPoint(a,b,c,d)
    --v1×v2=x1y2-y1x2
    --以线段ab为准，是否c，d在同一侧
    local ab = b - a
    local ac = c - a;
    local abXac = UIUtil.Cross(ab, ac)

    local ad = d - a
    local abXad = UIUtil.Cross(ab, ad)

    if abXac * abXad >= 0 then
        return nil
    end
    --以线段cd为准，是否ab在同一侧
    local cd = d - c
    local ca = a - c
    local cb = b - c

    local cdXca = UIUtil.Cross(cd, ca)
    local cdXcb = UIUtil.Cross(cd, cb)
    if cdXca * cdXcb >= 0 then
        return nil
    end

    --计算交点坐标
    local t = UIUtil.Cross(a - c, d - c) / UIUtil.Cross(d - c, b - a)
    local dx = t * (b.x - a.x)
    local dy = t * (b.y - a.y)
    return Vector2.New(a.x + dx, a.y + dy)
end

local function Cross(a,b)
    return a.x * b.y - b.x * a.y
end

--获取目标点距离中心点的位置关系
local function GetDirectionByXY(targetPointX, targetPointY, centerPointX, centerPointY)
    local isRight = targetPointX >= centerPointX
    local isTop = targetPointY >= centerPointY
    if isRight then
        if isTop then
            return CommonDirection.RightTop
        end
        return CommonDirection.RightDown
    else
        if isTop then
            return CommonDirection.LeftTop
        end
    end
    return CommonDirection.LeftDown
end

local function ShowStarTip(descText, leftText, rightText)
    if UIManager:GetInstance():IsWindowOpen(UIWindowNames.UICommonStarTip) then
        local window = UIManager:GetInstance():GetWindow(UIWindowNames.UICommonStarTip)
        window.View:SetData(descText, leftText, rightText)
    else
        UIManager:GetInstance():OpenWindow(UIWindowNames.UICommonStarTip, {anim = true}, descText, leftText, rightText)
    end
end

local function GetAllianceWholeName(serverId, abbr, name)
    return string.format("#%s[%s]%s", serverId, abbr, name)
end

--function UIUtil:getPosOfTowLine(pointA, pointB, pointM, pointN) -- AB线段，MN线段
--    local Xa, Ya = pointA.x,pointA.y -- AB线段 首坐标
--    local Xb, Yb = pointB.x, pointB.y -- AB线段 尾坐标
--    local Xm, Ym = pointM.x, pointM.y -- MN线段 首坐标
--    local Xn, Yn = pointN.x, pointN.y -- MN线段 尾坐标
--
--    -- 两条线段的斜率，需要考虑斜率不存在的情况 
--    local Kab = (Xb - Xa ~= 0) and (Yb - Ya) / (Xb - Xa) or nil -- 线段AB斜率，方程式：y = x * Kab + Ya - Xa * Kab 
--    local Kmn = (Xn - Xm ~= 0) and (Yn - Ym) / (Xn - Xm) or nil -- 线段MN斜率，方程式：y = x * Kmn + Ym - Xm * Kmn 
--    Logger.Log("Kab, Kmn is ---"..tostring(Kab)..tostring(Kmn))
--
--    -- 两条线段斜率不同时 才会相交。先求出两直线交点坐标，再判断该点是否在线段ab上
--    local Xp, Yp -- 设交点坐标为 P
--    if Kab and Kmn then -- 斜率都存在
--        if Kab ~= Kmn then -- 还要考虑斜率为0不能做分母的情况
--            if Kab == 0 then -- 线段ab：解析式 y = Ya
--                Xp = (Ya - Ym + Xm * Kmn) / Kmn
--                Yp = Ya
--            elseif Kmn == 0 then -- 线段mn：解析式 y = Ym
--                Xp = (Ym - Ya + Xa * Kab) / Kab
--                Yp = Ym
--            else
--                Xp = (Ya - Ym - Xa * Kab + Xm * Kmn) / (Kmn - Kab)
--                Yp = (Xm * Kmn * Kab - Ym * Kab + Ya * Kmn - Xa * Kab * Kmn ) / (Kmn - Kab)
--            end
--        
--        end
--    elseif Kab then --线段mn: Kmn不存在,解析式 x = Xm
--        Xp = Xm
--        if Kab == 0 then -- 线段ab：解析式 y = Ya
--            Yp = Ya
--        else
--            Yp = Xm * Kab + Ya - Xa * Kab
--        end
--    elseif Kmn then -- 线段ab: Kab不存在, 解析式 x = Xa
--        Xp = Xa
--        if Kmn == 0 then -- 线段mn：解析式 y = Ym
--            Yp = Ym
--        else
--            Yp = Xa * Kmn + Ym - Xm * Kmn
--        end
--    end
--    Logger.Log("交点坐标 is ----"..Xp..";"..Yp)
--    if Xp and Yp then
--        -- 判断交点在不在线段上
--        if ((Xp >= Xa and Xp <= Xb) or (Xp >= Xb and Xp <= Xa)) and ((Yp >= Ya and Yp <= Yb) or (Yp >= Yb and Yp <= Ya)) then
--            local v2 = {}
--            v2.x = Xp
--            v2.y = Yp
--            return v2
--        end
--    end
--
--    return nil
--end

local function GetPosOfTowLine(pointA, pointB, pointM, pointN)
    local x1, y1 = pointA.x,pointA.y -- AB线段 首坐标
    local x2, y2 = pointB.x, pointB.y -- AB线段 尾坐标
    local x3, y3 = pointM.x, pointM.y -- MN线段 首坐标
    local x4, y4 = pointN.x, pointN.y -- MN线段 尾坐标
    local v2 ={}
    v2.x = -1
    v2.y = -1
    --判断 (x1, y1)~(x2, y2) 和 (x3, y3)~(x4, y4) 是否平行
    if ((y4 - y3) * (x2 - x1) == (y2 - y1) * (x4 - x3)) then
        --若平行，则判断 (x3, y3) 是否在「直线」(x1, y1)~(x2, y2) 上
        if ((y2 - y1) * (x3 - x1) == (y3 - y1) * (x2 - x1)) then
            --判断 (x3, y3) 是否在「线段」(x1, y1)~(x2, y2) 上
            if (UIUtil.IsInSide(x1,y1,x2,y2,x3,y3)) then
                v2 = UIUtil.UpdatePoint(v2,x3,y3)
            end
            --判断 (x4, y4) 是否在「线段」(x1, y1)~(x2, y2) 上
            if (UIUtil.IsInSide(x1,y1,x2,y2,x4,y4)) then
                v2 =UIUtil.UpdatePoint(v2,x4,y4)
            end
            --判断 (x1, y1) 是否在「线段」(x3, y3)~(x4, y4) 上
            if (UIUtil.IsInSide(x3,y3,x4,y4,x1,y1)) then
                v2 =UIUtil.UpdatePoint(v2,x1,y1)
            end
        --判断 (x2, y2) 是否在「线段」(x3, y3)~(x4, y4) 上
            if (UIUtil.IsInSide(x3,y3,x4,y4,x2,y2)) then
                v2 =UIUtil.UpdatePoint(v2,x2,y2)
            end
        end
        --在平行时，其余的所有情况都不会有交点
    else
        --联立方程得到 t1 和 t2 的值
        local t1 = (x3 * (y4 - y3) + y1 * (x4 - x3) - y3 * (x4 - x3) - x1 * (y4 - y3)) / ((x2 - x1) * (y4 - y3) - (x4 - x3) * (y2 - y1));
        local t2 = (x1 * (y2 - y1) + y3 * (x2 - x1) - y1 * (x2 - x1) - x3 * (y2 - y1)) / ((x4 - x3) * (y2 - y1) - (x2 - x1) * (y4 - y3));
        --判断 t1 和 t2 是否均在 [0, 1] 之间
        if (t1 >= 0 and  t1 <= 1 and t2 >= 0 and t2 <= 1) then
            v2.x = math.floor(x1 + t1 * (x2 - x1))
            v2.y = math.floor(y1 + t1 * (y2 - y1))
        end
    end

    if v2.x>=0 and v2.y>=0 then
        return SceneUtils.TilePosToIndex(v2,ForceChangeScene.World)
    end
    return nil
end

--判断 (xk, yk) 是否在「线段」(x1, y1)~(x2, y2) 上
--这里的前提是 (xk, yk) 一定在「直线」(x1, y1)~(x2, y2) 上
local function IsInSide(tx1,ty1,tx2,ty2,txk,tyk)
    --若与 x 轴平行，只需要判断 x 的部分
    --若与 y 轴平行，只需要判断 y 的部分
    --若为普通线段，则都要判断
    return (tx1 == tx2 or (math.min(tx1, tx2) <= txk and txk <= math.max(tx1, tx2))) and (ty1 == ty2 or (math.min(ty1, ty2) <= tyk and tyk <= math.max(ty1, ty2)));
end

local function UpdatePoint(tv2,txk,tyk)
    local v2 = {}
    v2.x = tv2.x
    v2.y = tv2.y
    if (v2.x<0 and v2.y<0) or txk<v2.x or (txk<v2.x and tyk<v2.y) then
        v2.x = txk
        v2.y = tyk
    end
    return v2
end

local function IntersectsSegment(rect,p1,p2)
    local num1 = math.min(p1.x, p2.x)
    local num2 = math.max(p1.x, p2.x)
    if num2 > rect.xMax then
        num2 = rect.xMax
    end
    if num1 > rect.xMin then
        num1 = rect.xMin
    end
    if num1 > num2 then
        return false
    end
    local num3 = math.min(p1.y, p2.y)
    local num4 = math.max(p1.y, p2.y)
    local f = p2.x - p1.x
    if math.abs(f)> 1.40129846432482E-45 then
        local num5 = (p2.y - p1.y) / f
        local num6 = p1.y - num5 * p1.x
        num3 = num5 * num1 + num6
        num4 = num5 * num2 + num6
    end
    if num3 > num4 then
        local num5 = num4
        num4 = num3
        num3 = num5
    end
    if num4>rect.yMax then
        num4 = rect.yMax
    end
    if num3>rect.yMin then
        num3 = rect.yMin
    end
    return num3<=num4
end

local function GetEffectNumByType(val, type)
    local intType = tonumber(type)
    if intType == EffectLocalTypeInEffectDesc.Num then
        local a, b = math.modf(val)
        if b == 0 then
            return string.GetFormattedSeperatorNum(a)
        end
        return string.GetFormattedSeperatorNum(val)
    elseif intType == EffectLocalTypeInEffectDesc.Percent then
        local a, b = math.modf(val)
        if b == 0 then
            return string.GetFormattedSeperatorNum(a) .. "%"
        end
        return string.GetFormattedSeperatorNum(val) .. "%"
    elseif intType == EffectLocalTypeInEffectDesc.Thousandth then
        return string.GetFormattedThousandthStr(val / 1000)
    elseif intType == EffectLocalTypeInEffectDesc.NegativePercent then
        local a, b = math.modf(val)
        if b == 0 then
            return "-" .. string.GetFormattedSeperatorNum(a) .. "%"
        end
        return "-" .. string.GetFormattedSeperatorNum(val) .. "%"
    end
    return ""
end

local function GetEffectNumWithType(val, type)
    local intType = tonumber(type)
    if intType == EffectLocalTypeInEffectDesc.Num then
        return "+" .. string.GetFormattedSeperatorNum(val)
    elseif intType == EffectLocalTypeInEffectDesc.Percent then
        local a, b = math.modf(val)
        if b == 0 then
            return "+" .. string.GetFormattedSeperatorNum(a) .. "%"
        end
        return "+" .. string.GetFormattedSeperatorNum(val) .. "%"
    elseif intType == EffectLocalTypeInEffectDesc.Thousandth then
        return "+" .. string.GetFormattedThousandthStr(val / 1000)
    elseif intType == EffectLocalTypeInEffectDesc.NegativePercent then
        local a, b = math.modf(val)
        if b == 0 then
            return "-" .. string.GetFormattedSeperatorNum(a) .. "%"
        end
        return "-" .. string.GetFormattedSeperatorNum(val) .. "%"
    end
    return ""
end

-- 如果该玩家已移民，则名字置灰
local function GetChampionBattleMigrateName(name, migrate)
    if migrate == 1 then
        return "<color=#4C4C4C>" .. Localization:GetString("250398", name) .. "</color>"
    else
        return name
    end
end

local function GetMasteryExpByItemId(itemId)
    itemId = tostring(itemId)
    local oneExp = 0
    if itemId == "251112" then
        oneExp = 1000
    elseif itemId == "251114" then
        oneExp = 100
    elseif itemId == "251115" then
        oneExp = 10000
    elseif itemId == "251116" then
        oneExp = 100000
    elseif itemId == "23001" then
        oneExp = 10000
    elseif itemId == "23002" then
        oneExp = 60000
    elseif itemId == "23003" then
        oneExp = 1000000
    end
    return oneExp
end

local function GetMasteryExpItemMaxCount(itemId)
    itemId = tostring(itemId)
    local oneExp = UIUtil.GetMasteryExpByItemId(itemId)
    if oneExp == 0 then
        return IntMaxValue
    end
    local restExp = DataCenter.MasteryManager:GetRestExpToMaxLevel()
    if restExp <= 0 then
        return 0
    end
    return restExp // oneExp + 1
end

-- param: { pos, desc, dataList, isLeft, offsetY }
-- dataList: List<{ reward, count, rate }>
local function ShowRateTip(param)
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIRateTip, { anim = false }, param)
end

local function OnDispatchTaskClick(pointIndex,openFuc)
    local actList = DataCenter.ActivityListDataManager:GetActivityDataByType(EnumActivity.DispatchTask.Type)
    local actInfo = #actList > 0 and actList[1] or nil
    if actInfo == nil then
        UIUtil.ShowTipsId(130231)
        return
    end
    -- 等级不够
    if actInfo.needMainCityLevel and actInfo.needMainCityLevel > DataCenter.BuildManager.MainLv then
        UIUtil.ShowTips(Localization:GetString("302235",actInfo.needMainCityLevel))
        return
    end
    -- 区分 自己领取 ？ 盟友协助 ？ 还是别人偷
    local info = DataCenter.WorldPointManager:GetPointInfo(pointIndex)
    if info~=nil and info.extraInfo~=nil then
        if info.pointType == WorldPointType.HERO_DISPATCH then
            local dispatchMission = PBController.ParsePbFromBytes(info.extraInfo, "protobuf.DispatchMission")
            if dispatchMission~=nil then
                local mgr = DataCenter.ActDispatchTaskDataManager
                local player = LuaEntry.Player
                local selfUid = player.uid
                local now = UITimeManager:GetInstance():GetServerTime()
                local canAward = dispatchMission.finishTime > 0 and dispatchMission.finishTime <= now
                if canAward then
                    if selfUid == dispatchMission.ownerUid then
                        --自己操作
                        --info.rewarded = 1   -- 防止多次点击?
                        SFSNetwork.SendMessage(MsgDefines.DispatchReward, dispatchMission.uuid)
                    elseif dispatchMission.allianceId~=nil and dispatchMission.allianceId~=""  and dispatchMission.allianceId == LuaEntry.Player.allianceId then
                        --盟友
                        local todayAssistNum = mgr:GetTodayAssistNum()
                        local assistMax = toInt(mgr:GetDispatchSetting("aid_count"))
                        if todayAssistNum < assistMax then
                            SFSNetwork.SendMessage(MsgDefines.DispatchAssist, dispatchMission.uuid)
                        else
                            UIUtil.ShowTipsId(461054) -- 456225=今日协助次数已达上限
                        end
                    else
                        local steal_max_count = toInt(GetTableData(TableName.LwDispatchTask, dispatchMission.missionId,"steal_maxtimes"))
                        local curCount = table.count(dispatchMission.stealUids)
                        if curCount<steal_max_count then
                            local hasSteal = false
                            if curCount>0 then
                                for i = 1,curCount do
                                    if dispatchMission.stealUids[i] == LuaEntry.Player.uid then
                                        hasSteal = true
                                    end
                                end
                            end
                            if hasSteal == true then
                                UIUtil.ShowTipsId(461057) -- 456235=这个据点已经偷过了，给他留点奖励吧！
                            else
                                local todayStealNum = DataCenter.ActDispatchTaskDataManager:GetTodayStealNum()
                                local maxStealNum = DataCenter.ActDispatchTaskDataManager:GetDispatchSetting("steal_count")
                                if todayStealNum<maxStealNum then
                                    SFSNetwork.SendMessage(MsgDefines.DispatchSteal,dispatchMission.uuid)
                                else
                                    UIUtil.ShowTipsId(461054) -- 456226=今日偷取次数已达上限
                                end
                            end
                        else
                            UIUtil.ShowTipsId(461055) -- 456227=这个探索点已经被偷光了！
                        end
                    end
                else
                    if openFuc~=nil then
                        local isSelf = selfUid == dispatchMission.ownerUid
                        local finishTime = dispatchMission.finishTime
                        local uuid = dispatchMission.uuid
                        openFuc(isSelf,finishTime,uuid)
                    end
                end
            end
        end
    end
end

UIUtil.ShowMessage =ShowMessage
UIUtil.ShowIntro =ShowIntro
UIUtil.ShowUseItemTip =ShowUseItemTip
UIUtil.ShowComplexTip =ShowComplexTip
UIUtil.ShowTips =ShowTips
UIUtil.ShowTipsId =ShowTipsId
UIUtil.ShowBuyMessage = ShowBuyMessage
UIUtil.ShowVersionMessage = ShowVersionMessage
UIUtil.CalcConstructMilePointer = CalcConstructMilePointer
UIUtil.CalcMilePointer = CalcMilePointer
UIUtil.PlayAnimationReturnTime =PlayAnimationReturnTime
UIUtil.ClickBuildAdjustCameraView =ClickBuildAdjustCameraView
UIUtil.IsInView =IsInView
UIUtil.OnClickWorld = OnClickWorld
UIUtil.OnClickWorldTroop = OnClickWorldTroop
UIUtil.ShowSecondMessage = ShowSecondMessage
UIUtil.CloseWorldMarchTileUI =CloseWorldMarchTileUI
UIUtil.ClickCloseWorldUI =ClickCloseWorldUI
UIUtil.ClickWorldCloseWorldUI =ClickWorldCloseWorldUI
UIUtil.ClickUICloseWorldUI =ClickUICloseWorldUI
UIUtil.OnClickCity =OnClickCity
UIUtil.DragWorldCloseWorldUI =DragWorldCloseWorldUI
UIUtil.ShowUseDiamondConfirm = ShowUseDiamondConfirm
UIUtil.ShowUnlockWindow = ShowUnlockWindow
UIUtil.ShowGuideBtnUnlockWindow = ShowGuideBtnUnlockWindow
UIUtil.ShowNextUnlockWindow = ShowNextUnlockWindow
UIUtil.CheckNeedQuitFocus= CheckNeedQuitFocus
UIUtil.GetUIMainSavePos = GetUIMainSavePos
UIUtil.OnPointDownMarch = OnPointDownMarch
UIUtil.OnPointUpMarch = OnPointUpMarch
UIUtil.OnMarchDragStart = OnMarchDragStart
UIUtil.DoFly = DoFly
UIUtil.DoFlyCustom = DoFlyCustom
UIUtil.GetSelfMarchCountExceptGolloes = GetSelfMarchCountExceptGolloes
UIUtil.ShowSingleTip = ShowSingleTip
UIUtil.IsPad = IsPad
UIUtil.OpenConsumeItemView = OpenConsumeItemView
UIUtil.OpenHeroStationByBuildUuid = OpenHeroStationByBuildUuid
UIUtil.OpenHeroStationByStationId = OpenHeroStationByStationId
UIUtil.OpenHeroStationByEffectType = OpenHeroStationByEffectType
UIUtil.ShowPiggyBankTip = ShowPiggyBankTip
UIUtil.ShowEnergyBankTip = ShowEnergyBankTip
UIUtil.GetAllianceItemPos = GetAllianceItemPos
UIUtil.GetUIMainEnergySlider = GetUIMainEnergySlider
UIUtil.GetEnergyIconPos = GetEnergyIconPos
UIUtil.ShowSpecialTips = ShowSpecialTips
UIUtil.ShowSelectArmy = ShowSelectArmy
UIUtil.ShowSelectHero = ShowSelectHero
UIUtil.TryMoveCity = TryMoveCity
UIUtil.GetFlyTargetPosByRewardType = GetFlyTargetPosByRewardType
UIUtil.ShowPvePowerLack = ShowPvePowerLack
UIUtil.PveSceneHeroListRefresh = PveSceneHeroListRefresh
UIUtil.PveSceneHeroListScrollToHero = PveSceneHeroListScrollToHero
UIUtil.GetEnergyRecoverTime = GetEnergyRecoverTime
UIUtil.GetSpeedUpIcon = GetSpeedUpIcon
UIUtil.GetSpeedUpHeroName = GetSpeedUpHeroName
UIUtil.IsSpeedUpIcon = IsSpeedUpIcon
UIUtil.SegmentsInterPoint = SegmentsInterPoint
UIUtil.Cross = Cross
UIUtil.GetDirectionByXY = GetDirectionByXY
UIUtil.ShowStarTip = ShowStarTip
UIUtil.GetAllianceWholeName = GetAllianceWholeName
UIUtil.UpdatePoint = UpdatePoint
UIUtil.IsInSide =IsInSide
UIUtil.GetPosOfTowLine =GetPosOfTowLine
UIUtil.GetEffectNumByType =GetEffectNumByType
UIUtil.GetChampionBattleMigrateName = GetChampionBattleMigrateName
UIUtil.GetMasteryExpByItemId = GetMasteryExpByItemId
UIUtil.GetMasteryExpItemMaxCount = GetMasteryExpItemMaxCount
UIUtil.ShowRateTip = ShowRateTip
UIUtil.GetEffectNumWithType = GetEffectNumWithType
UIUtil.IntersectsSegment =IntersectsSegment
UIUtil.OnDispatchTaskClick =OnDispatchTaskClick
return ConstClass("UIUtil", UIUtil)