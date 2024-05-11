local CountBattleConfig = {}
local Consts = require("DataCenter.LWBattle.Logic.CountBattle.CountBattleConsts")
local Quaternion = CS.UnityEngine.Quaternion

local TRAP_MOTION_PATH_FORMAT = "DataCenter.LWBattle.Logic.CountBattle.Traps.Motion.Motion%s"
local SOILDER_WEAPON_PATH_FORMAT = "DataCenter.LWBattle.Logic.CountBattle.Unit.Weapon.%s"

-- RAW DATA ----------------------------------------------------------------------------------
local _TrapConfigCache = {}
function CountBattleConfig.GetTrapRawCfg(rawCfgID)
    local rawCfg = _TrapConfigCache[rawCfgID]
    if not rawCfg then
        rawCfg = {}
        local line = LocalController:instance():getLine(LuaEntry.Player:GetABTestTableName(TableName.LW_Count_Stage_Trap), rawCfgID)
        if not line then
            Logger.LogError("Count Battle config error! trap id not found:" .. rawCfgID)
            return nil
        end
        rawCfg.res = line:getValue("prefab")
        rawCfg.maxHp = line:getValue("max_hp")
        rawCfg.maxPt = line:getValue("max_pt")
        rawCfg.sleepTime = tonumber(line:getValue("sleep_time")) or 0
        rawCfg.bubbleH = line:getValue("bubble_height")
        rawCfg.deadVfx = line:getValue("dead_vfx")
        rawCfg.hitVfx = line:getValue("hit_vfx")
        rawCfg.motionCfgs = {}
        local motionParts = line:getValue("motion_parts")
        local motionType = line:getValue("motion_type")
        local motionParam1 = line:getValue("motion_param1")
        local motionParam2 = line:getValue("motion_param2")
        local motionParam3 = line:getValue("motion_param3")
        for i = 1, #motionParts do
            local motionCfg = {}
            motionCfg.part = motionParts[i]
            motionCfg.type = motionType[i]
            motionCfg.class = require(string.format(TRAP_MOTION_PATH_FORMAT, motionCfg.type))
            if not motionCfg.class then
                Logger.LogError("Count Battle config error! invalide trap motion type:" .. motionCfg.type)
                return nil
            end
            motionCfg.class.ParseParams(motionCfg, { motionParam1[i], motionParam2[i], motionParam3[i] })
            table.insert(rawCfg.motionCfgs, motionCfg)
        end
        rawCfg.headIcon = line:getValue("head_icon")
        rawCfg.deadEffects = {}
        local eff = line:getValue("dead_effect")
        if not string.IsNullOrEmpty(eff) then
            local effs = string.split(eff, "|")
            for _, e in ipairs(effs) do
                local es = string.split(e, ";")
                assert(#es == 3, "Count Battle Config error ! invalid trap deadEffect ： ".. rawCfgID)
                table.insert(rawCfg.deadEffects, {tonumber(es[1]), tonumber(es[2]), es[3]})
            end
        end
        _TrapConfigCache[rawCfgID] = rawCfg
    end
    return rawCfg
end

local _SoilderConfigCache = {}
function CountBattleConfig.GetSoilderRawCfg(rawCfgID)
    local rawCfg = _SoilderConfigCache[rawCfgID]
    if not rawCfg then
        rawCfg = {}
        local line = LocalController:instance():getLine(LuaEntry.Player:GetABTestTableName(TableName.LW_Count_Stage_Soilder), rawCfgID)
        if not line then
            Logger.LogError("Count Battle config error! soilder id not found:" .. rawCfgID)
            return nil
        end
        rawCfg.id = rawCfgID
        rawCfg.point = line:getValue("point")
        rawCfg.radius = line:getValue("radius") * 0.001
        rawCfg.endLineSize = line:getValue("end_line_size")
        rawCfg.weaponClass = require(string.format(SOILDER_WEAPON_PATH_FORMAT, line:getValue("weapon")))
        rawCfg.muzzleBone = line:getValue("muzzle_bone")
        rawCfg.prefab = line:getValue("prefab")
        rawCfg.deadVfx = line:getValue("dead_vfx")
        rawCfg.marchAnim = line:getValue("march_anim")
        rawCfg.moveAnim = line:getValue("move_anim")
        rawCfg.contactAnim = line:getValue("contact_anim")
        rawCfg.aimAnim = line:getValue("aim_anim")
        rawCfg.shootAnim = line:getValue("shoot_anim")
        rawCfg.idleAnim = line:getValue("idle_anim")
        _SoilderConfigCache[rawCfgID] = rawCfg
    end
    return rawCfg
end

-- STAGE DATA --------------------------------------------------------------------------------

function CountBattleConfig.ParseInitSoilders(cfg, line)
    cfg.initSoilderCfgs = {}
    local soilderInfos = line:getValue("init_soilders")
    for _, soilderInfo in ipairs(soilderInfos) do
        local paramArr = string.split(soilderInfo, ";")
        assert(#paramArr == 2, "Count Battle config error! invalide init soilder info:" .. soilderInfo.." | levelId:" .. cfg.levelId)
        local soilderCfg = {}
        soilderCfg.raw = CountBattleConfig.GetSoilderRawCfg(tonumber(paramArr[1]))
        soilderCfg.amount = tonumber(paramArr[2])
        table.insert(cfg.initSoilderCfgs, soilderCfg)
    end
end

function CountBattleConfig.ParseDoors(cfg, line)
    local doorColor = { 'blue', 'red', 'blue', 'red' }
    local DoorResPath = {
        ["blue"] = "Assets/Main/Prefabs/LWCountBattle/Doors/DoorBlue.prefab",
        ["red"] = "Assets/Main/Prefabs/LWCountBattle/Doors/DoorRed.prefab",
    }
    cfg.doorCfgs = {}
    local doorInfos = line:getValue("door_infos")
    for _, doorInfo in ipairs(doorInfos) do
        local paramArr = string.split(doorInfo, ";")
        assert(#paramArr == 3, "Count Battle config error! invalide door info:" .. doorInfo.." | levelId:" .. cfg.levelId)
        local posArr = string.split(paramArr[3], ",")
        local doorCfg = {}
        doorCfg.pos = Vector3.New(tonumber(posArr[1]), tonumber(posArr[2]), tonumber(posArr[3]))
        doorCfg.args = { tonumber(paramArr[1]), tonumber(paramArr[2]) }
        if doorCfg.args[1] <= 4 then
            doorCfg.resPath = DoorResPath[doorColor[tonumber(paramArr[1])]]
        else
            doorCfg.resPath = nil
            table.insert(doorCfg.args, CountBattleConfig.GetSoilderRawCfg(doorCfg.args[1]))
        end
        table.insert(cfg.doorCfgs, doorCfg)
    end
end

function CountBattleConfig.ParseTraps(cfg, line)
    cfg.trapCfgs = {}
    local trapInfos = line:getValue("trap_infos")
    for _, trapInfo in ipairs(trapInfos) do
        local paramArr = string.split(trapInfo, ";")
        assert(#paramArr >= 2 and #paramArr <= 3, "Count Battle config error! invalide trap info:" .. trapInfo.." | levelId:" .. cfg.levelId)
        local posArr = string.split(paramArr[2], ",")
        local trapCfg = {}
        trapCfg.pos = Vector3.New(tonumber(posArr[1]), tonumber(posArr[2]), tonumber(posArr[3]))
        trapCfg.angle = paramArr[3] and tonumber(paramArr[3]) or 0
        trapCfg.raw = CountBattleConfig.GetTrapRawCfg(tonumber(paramArr[1]))
        if trapCfg.raw then
            table.insert(cfg.trapCfgs, trapCfg)
        end
    end
end

function CountBattleConfig.ParseGroups(cfg, line)
    cfg.groupCfgs = {}
    local groupInfos = line:getValue("group_infos")
    for _, groupInfo in ipairs(groupInfos) do
        local paramArr = string.split(groupInfo, ";")
        assert(#paramArr == 3, "Count Battle config error! invalide group info:" .. groupInfo.." | levelId:" .. cfg.levelId)
        local posArr = string.split(paramArr[2], ",")
        local groupCfg = {}
        groupCfg.initPos = Vector3.New(tonumber(posArr[1]), tonumber(posArr[2]), tonumber(posArr[3]))
        
        --同一group内支持配置多组怪
        local amountArr = string.split(paramArr[3], ",")
        if #amountArr == 1 then
            --原逻辑不变
            groupCfg.amount = tonumber(paramArr[3])
            local groupLine = LocalController:instance():getLine(LuaEntry.Player:GetABTestTableName(TableName.LW_Count_Stage_Group), tonumber(paramArr[1]))
            groupCfg.maxHp = tonumber(groupLine:getValue("max_hp"))
            groupCfg.class = groupLine:getValue("class")
            groupCfg.radius = tonumber(groupLine:getValue("unit_radius")) * 0.001
            groupCfg.moveSpeed = tonumber(groupLine:getValue("move_speed"))
            local faceDirAngle = tonumber(groupLine:getValue("face_dir"))
            groupCfg.faceDir = faceDirAngle >= 0 and Quaternion.Euler(0, faceDirAngle, 0) * Vector3.forward or nil
            groupCfg.point = tonumber(groupLine:getValue("unit_pt"))
            groupCfg.res = groupLine:getValue("unit_prefab")
            groupCfg.deadVfx = groupLine:getValue("dead_vfx")
            groupCfg.hitVfx = groupLine:getValue("hit_vfx")
            groupCfg.moveAnim = groupLine:getValue("move_anim")
            groupCfg.engageAnim = groupLine:getValue("engage_anim")
            groupCfg.contactAnim = groupLine:getValue("contact_anim")
            groupCfg.hpBarH = tonumber(groupLine:getValue("hp_bar_height"))
            groupCfg.alertRange = tonumber(groupLine:getValue("alert_range"))
            groupCfg.deathAnim = groupLine:getValue("death_anim")

        else
            groupCfg.subCfgs = {}
            local groupArr = string.split(paramArr[1], ",")
            if #groupArr == #amountArr then

                for i = 1, #groupArr do

                    local subCfg = {}
                    subCfg.amount = tonumber(amountArr[i])
                    local groupLine = LocalController:instance():getLine(LuaEntry.Player:GetABTestTableName(TableName.LW_Count_Stage_Group), tonumber(groupArr[i]))
                    subCfg.maxHp = tonumber(groupLine:getValue("max_hp"))
                    subCfg.class = groupLine:getValue("class")
                    subCfg.radius = tonumber(groupLine:getValue("unit_radius")) * 0.001
                    subCfg.moveSpeed = tonumber(groupLine:getValue("move_speed"))
                    local faceDirAngle = tonumber(groupLine:getValue("face_dir"))
                    subCfg.faceDir = faceDirAngle >= 0 and Quaternion.Euler(0, faceDirAngle, 0) * Vector3.forward or nil
                    subCfg.point = tonumber(groupLine:getValue("unit_pt"))
                    subCfg.res = groupLine:getValue("unit_prefab")
                    subCfg.deadVfx = groupLine:getValue("dead_vfx")
                    subCfg.hitVfx = groupLine:getValue("hit_vfx")
                    subCfg.moveAnim = groupLine:getValue("move_anim")
                    subCfg.engageAnim = groupLine:getValue("engage_anim")
                    subCfg.contactAnim = groupLine:getValue("contact_anim")
                    subCfg.hpBarH = tonumber(groupLine:getValue("hp_bar_height"))
                    subCfg.alertRange = tonumber(groupLine:getValue("alert_range"))
                    subCfg.deathAnim = groupLine:getValue("death_anim")

                    if i == 1 then
                        groupCfg.maxHp = subCfg.maxHp
                        groupCfg.class = subCfg.class
                        groupCfg.radius = subCfg.radius
                        groupCfg.moveSpeed = subCfg.moveSpeed
                        groupCfg.faceDir = subCfg.faceDir
                        groupCfg.point = subCfg.point
                        groupCfg.res = subCfg.res
                        groupCfg.deadVfx = subCfg.deadVfx
                        groupCfg.hitVfx = subCfg.hitVfx
                        groupCfg.moveAnim = subCfg.moveAnim
                        groupCfg.engageAnim = subCfg.engageAnim
                        groupCfg.contactAnim = subCfg.contactAnim
                        groupCfg.hpBarH = subCfg.hpBarH
                        groupCfg.alertRange = subCfg.alertRange
                    end
                    
                    table.insert(groupCfg.subCfgs, subCfg)
                end
            end
            
        end
        
        table.insert(cfg.groupCfgs, groupCfg)
    end

    local defaultSoilderRaw = CountBattleConfig.GetSoilderRawCfg(1000)
    cfg.playerGroupCfg = {
        initPos = cfg.initPos,
        amount = 0,
        maxHp = 0,
        class = "Soilder",
        defaultSoilderCfg = defaultSoilderRaw,
        radius = defaultSoilderRaw.radius,
        moveSpeed = 1,
        faceDir = Vector3.forward,
        point = defaultSoilderRaw.point,
        res = defaultSoilderRaw.prefab,
        deadVfx = defaultSoilderRaw.deadVfx,
    }
end

function CountBattleConfig.ParseEndParams(cfg, line)
    local endParam1 = line:getValue("end_param1")
    local endParam2 = line:getValue("end_param2")
    local endParam3 = line:getValue("end_param3")
    cfg.endParams = {}
    if cfg.endType == 1 then
    elseif cfg.endType == 2 then
        local amountArr = string.split(endParam1, "|")
        local trapIdArr = string.split(endParam2, "|")
        cfg.endParams.spawnInfos = {}
        for i, trapId in ipairs(trapIdArr) do
            local rawCfg = CountBattleConfig.GetTrapRawCfg(tonumber(trapId))
            if rawCfg then
                local spawnInfo = {rawCfg=rawCfg, amount=tonumber(amountArr[i])}
                table.insert(cfg.endParams.spawnInfos, spawnInfo)
            end
        end
        assert(#cfg.endParams.spawnInfos > 0, "Count Battle config error! invalide end param:" .. endParam1.." | levelId:" .. cfg.levelId)
    end
end

function CountBattleConfig.Parse(levelId)
    local cfg = {}
    local line = LocalController:instance():getLine(LuaEntry.Player:GetABTestTableName(TableName.LW_Count_Stage), levelId)
    assert(line, "lw_count_stage not found, levelId:" .. levelId)
    cfg.levelId = levelId
    
    local initPos = string.split(line:getValue("birth_point") or "", "|")
    cfg.initPos = Vector3.New(tonumber(initPos[1]), 0, tonumber(initPos[2]))
    cfg.limitWidth = tonumber(line:getValue("limit_width"))
    local limitWH = cfg.limitWidth * 0.5
    cfg.boundary = { cfg.initPos.x - limitWH, cfg.initPos.x + limitWH }
    
    cfg.sceneCfgs = {}
    local sceneAssetArray = string.split(line:getValue("scene_assets") or "", "|")
    local offset = 0;
    for _, sceneAsset in ipairs(sceneAssetArray) do
        local sceneCfg = {}
        sceneCfg.asset = sceneAsset
        sceneCfg.offset = offset
        table.insert(cfg.sceneCfgs, sceneCfg)
        offset = offset + Consts.SCENE_CHUNK_SIZE
    end

    cfg.marchSpeed = tonumber(line:getValue("march_speed"))
    cfg.endZ = tonumber(line:getValue("end_z"))
    cfg.endType = tonumber(line:getValue("end_type"))
    CountBattleConfig.ParseEndParams(cfg, line)

    cfg.baseScore = tonumber(line:getValue("base_score"))

    CountBattleConfig.ParseInitSoilders(cfg, line)
    CountBattleConfig.ParseDoors(cfg, line)
    CountBattleConfig.ParseTraps(cfg, line)
    CountBattleConfig.ParseGroups(cfg, line)

    cfg.saveRestSoilders = tonumber(line:getValue("save_rest_soilders")) or 0
    cfg.saveRestSoilders = cfg.saveRestSoilders > 0

    cfg.canSkip = tonumber(line:getValue("is_skip")) or 0
    cfg.canSkip = cfg.canSkip > 0
    cfg.bgm = line:getValue("bgm")
    cfg.stageType = line:getValue("stage_type")
    cfg.nightColor = line:getValue("night_color")
    local red_circle = tonumber(line:getValue("red_circle")) or 0
    cfg.hideEnemyCircle = red_circle == 1
    
    return cfg
end

return CountBattleConfig