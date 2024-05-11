
using Sfs2X.Entities.Data;
using Sfs2X.Requests;
using XLua;

[Hotfix]
public class BuildMainCityMessage : BaseMessage {

    public class Request
    {
    }
    public static BuildMainCityMessage Instance;
    public BuildMainCityMessage()
    {
        Instance = this;
    }
    public override string GetMsgId()
    {
        return "build.main.city";
    }

    protected override IRequest CSSetData(params object[] args)
    {
        ISFSObject retObj = new SFSObject();
        int fuId = GameEntry.Network.getFutureManager().getFutureId();
        retObj.PutInt("_id", fuId);
        GameEntry.Network.getFutureManager().onSendRequest(fuId, GetMsgId());
        return new ExtensionRequest(GetMsgId(), retObj);
    }

    protected override void CSHandleResponse(ISFSObject message)
    {
        if (message.ContainsKey("errorCode"))
        {
            UIUtils.ShowTips(message.TryGetString("errorCode"));
        }
        else
        {
            // 这里的table有可能是LuaTable，也有可能是LuaStackTable!!!
            object table = ((SFSObject) message).ToLuaTable(GameEntry.Lua.Env);

            GameEntry.Lua.Call("CSharpCallLuaInterface.UpdateBuildings", table);
            SceneManager.World.ClearReInitObject();
            SceneManager.World.ReInitObject();
            
            // var buildData = GameEntry.Lua.CallWithReturn<LuaBuildData, int>(
            //     "CSharpCallLuaInterface.GetBuildingDataByBuildId", GameDefines.BuildingTypes.FUN_BUILD_MAIN);
            
            var buildData = GameEntry.Data.Building.GetBuildingDataByBuildId(GameDefines.BuildingTypes.FUN_BUILD_MAIN);
            if (buildData != null)
            {
                GameEntry.Event.Fire(EventId.BuildUpgradeFinish, buildData.uuid);
                GameEntry.Sound.PlayEffect(GameDefines.SoundAssets.Music_Effect_Finish);
            }
            GameEntry.Event.Fire(EventId.BuildMainZeroUpgradeSuccess);
        }
    }
}
