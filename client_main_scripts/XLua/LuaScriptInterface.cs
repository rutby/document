
using System.Collections.Generic;
using XLua;

namespace LuaScriptInterface
{
    public interface UIManager
    {
        void OpenWindow(string uiName, params object[] args);
        void DestroyWindow(string uiName, params object[] args);
        bool IsWindowOpen(string uiName);
    }

    public interface EventManager
    {
        void DispatchCSEvent(int eventId, object userData);
        void DispatchCSEventSFSObject(int eventId, byte[] sfsObjBinary);
    }

    public interface QueueDataManager
    {
        void UpdateQueueData(LuaTable message);
        QueueData GetQueueByType(int qType);
        void ResetAllQueue();
    }
    public interface BuildQueueManager
    {
        void UpdateQueueData(LuaTable message);
    }

    public interface ItemData
    {
        void UpdateItems(LuaTable data);
        void UpdateOneItem(LuaTable data);
        
        ItemInfo GetItemById(string itemId);
        StatusItemData GetStatusItem(int type);
    }


    [CSharpCallLua]
    public interface QueueData
    {
        long uuid { get; set; }
        string itemId{ get;set; }
        long startTime { get; set; }
        long endTime { get; set; }
        string newItemId { get; set; }
        int GetQueueState();
        int GetParaState();
        int type { get; set; }
    }
    
    public interface ItemInfo
    {
        string uuid { get; set; }
        string itemId{ get;set; }
        int count { get; set; }
    }
    
    public interface StatusItemData
    {
        int startTime { get; set; }
        int endTime{ get;set; }
        int stateId { get; set; }
    }




}


