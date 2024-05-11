using UnityEngine;

public class GuideGM : MonoBehaviour
{
    public int _guideId;
    [Sirenix.OdinInspector.Button(Sirenix.OdinInspector.ButtonSizes.Large)]
    private void SetGuideId()
    {
        GameEntry.Lua.Call("DataCenter.GuideManager:SetCurGuideId", _guideId);
        GameEntry.Lua.Call("DataCenter.GuideManager:DoGuide");
    }
}
