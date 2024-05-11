using System.Collections.Generic;
using UnityEngine;
using usky;
using XLua;

public class CityLightManager : CityManagerBase
{

    private Light pointLight;
    private GameObject uSkyGo;
    private uSkyTimeline directLight;
    private uSkyLighting uSkyLighting;
    

    private float dayValue = 12.0f;
    private float nightValue = 0.0f;
    private float changeDirectTime = 4.0f;
    private float curDirectTime = 0.0f;
    private float targetDirectValue = 0.0f;
    private float startDirectValue = 0.0f;
    private float curDirectValue = 0.0f;
    private bool isInDirectightChange = false;
    
    private float targetPointValue = 0.0f;
    private float startPointValue = 0.0f;
    private float curPointValue = 0.0f;
    private bool isInPointLightChange = false;
    private float changePointTime = 4.0f;
    private float curPointTime = 0.0f;
    private float openLightValue = 15.5f;
    private float closeLightValue = 0.0f;
    private bool pointLightShow = false;
    private float curGlobalFloat = 0.0f;
    private float startGlobalFloat = 0.0f;
    private float targetGlobalFloat = 0.0f;

    private float startPointLightRange = 0.0f;
    private float curPointLightRange = 0.0f;
    private float targetPointLightRange = 0.0f;
    private bool IsInPointLightRangeChange = false;
    private float changePointRangeTime = 4.0f;
    private float curPointRangeTime = 0.0f;
    private float light1Value = 13.0f;
    private float light2Value = 16.0f;

    private bool isInit = false;

    private float cachePointLight = -1.0f;
    public CityLightManager(CityScene scene) : base(scene)
    {
    }

    public override void Init()
    {
        base.Init();
        GameEntry.Event.Subscribe(EventId.VitaFireStateChange, RefreshFireStateSignal);
        GameEntry.Event.Subscribe(EventId.VitaDayNightChange, RefreshDayNightSignal);
        GameEntry.Event.Subscribe(EventId.BuildLvUpChangeRange, RefreshRangeSignal);
        GameEntry.Event.Subscribe(EventId.ForceSetPointLightRangeValueForGuide, ForceSetPointLightValue);//这个是改亮度大小
        GameEntry.Event.Subscribe(EventId.ForceResetPointLightRangeValue, ForceResetPointLightValue);
        GameEntry.Event.Subscribe(EventId.ForceSetLight1Value,ForceSetLight1Value);//这个是改灯光范围
    }
    public override void UnInit()
    {
        base.UnInit();
        GameEntry.Event.Unsubscribe(EventId.VitaFireStateChange, RefreshFireStateSignal);
        GameEntry.Event.Unsubscribe(EventId.VitaDayNightChange, RefreshDayNightSignal);
        GameEntry.Event.Unsubscribe(EventId.BuildLvUpChangeRange, RefreshRangeSignal);
        GameEntry.Event.Unsubscribe(EventId.ForceSetPointLightRangeValueForGuide, ForceSetPointLightValue);
        GameEntry.Event.Unsubscribe(EventId.ForceResetPointLightRangeValue, ForceResetPointLightValue);
        GameEntry.Event.Unsubscribe(EventId.ForceSetLight1Value,ForceSetLight1Value);
    }
    public override void OnUpdate(float deltaTime)
    {
        if (isInPointLightChange)
        {
            curPointTime += deltaTime;
            if (curPointTime > changePointTime)
            {
                SetPointLightValue(targetPointValue);
                if (targetPointValue < 0.1f)
                {
                    SetPointLightShow(false);
                }
                isInPointLightChange = false;
                OnPointLightChangeFinish();
            }
            else
            {
                var value = (targetPointValue - startPointValue) * (curPointTime / changePointTime) + startPointValue;
                SetPointLightValue(value);
                var globalValue = (targetGlobalFloat - startGlobalFloat) * (curPointTime / changePointTime) + startGlobalFloat;
                Shader.SetGlobalFloat("_GolbalDuringTimeLine", globalValue);
                //Debug.LogError(globalValue);
                curGlobalFloat = globalValue;
            }
        }

        if (isInDirectightChange)
        {
            curDirectTime += deltaTime;
            if (curDirectTime > changeDirectTime)
            {
                SetDirectLightValue(targetDirectValue);
                isInDirectightChange = false;
            }
            else
            {
                var value = (targetDirectValue - startDirectValue) * (curDirectTime/ changeDirectTime) + startDirectValue;
                SetDirectLightValue(value);
            }
        }
        if (IsInPointLightRangeChange)
        {
            curPointRangeTime += deltaTime;
            if (curPointRangeTime > changePointRangeTime)
            {
                SetPointLightRangeValue(targetPointLightRange);
                IsInPointLightRangeChange = false;
            }
            else
            {
                var value = (targetPointLightRange- startPointLightRange) * (curPointRangeTime / changePointRangeTime) + startPointLightRange;
                SetPointLightRangeValue(value);
            }
        }
    }
    public void AddParam(GameObject obj)
    {
        pointLight = obj.transform.Find("Lights/PointLight")?.GetComponent<Light>();
        uSkyGo = obj.transform.Find("uSkyPro").gameObject;
        uSkyGo.SetActive(true);
        directLight = obj.transform.Find("uSkyPro")?.GetComponent<uSkyTimeline>();
        uSkyLighting = obj.transform.Find("uSkyPro")?.GetComponent<uSkyLighting>();
        var luaTable = GameEntry.Lua.CallWithReturn<LuaTable>("CSharpCallLuaInterface.GetLightParam");
        if (luaTable != null)
        {
            dayValue = luaTable.Get<int>("k1");
            nightValue = luaTable.Get<int>("k2");
            changeDirectTime = luaTable.Get<int>("k3");

            openLightValue = luaTable.Get<int>("k4");
            closeLightValue = luaTable.Get<int>("k5");
            changePointTime = luaTable.Get<int>("k6");
            
            light1Value = luaTable.Get<int>("k7");
            light2Value = luaTable.Get<int>("k8");
            changePointRangeTime = luaTable.Get<int>("k9");
        }
        InitDirectLight();
        InitPointLight();
    }
    private void InitDirectLight()
    {
        if (directLight != null)
        {
            var isDay = GameEntry.Lua.CallWithReturn<bool>("CSharpCallLuaInterface.GetIsDay");
            SetShaderDayOfNight(isDay);
            if (isDay)
            {
                SetDirectLightValue(dayValue);
            }
            else
            {
                SetDirectLightValue(nightValue);
            }
        }
        GameEntry.Lua.Call("CSharpCallLuaInterface.PlayMainSceneBGMusic");
    }
    private void RefreshDayNightSignal(object userData)
    {
        RefreshDirectLight();
    }
    private void RefreshDirectLight()
    {
        if (directLight != null)
        {
            var isDay = GameEntry.Lua.CallWithReturn<bool>("CSharpCallLuaInterface.GetIsDay");
            DirectLightOpen(isDay);
            PointLightDayNightChange();
        }
        GameEntry.Lua.Call("CSharpCallLuaInterface.PlayMainSceneBGMusic");
    }
    private void DirectLightOpen(bool isDay)
    {
        if (isDay)
        {
            DirectLightDoChange(dayValue);
        }
        else
        {
            DirectLightDoChange(nightValue);
        }
    }
    private void SetDirectLightValue(float value)
    {

        if (directLight != null)

        {
            directLight.SetTime(value);
        }
        curDirectValue = value;
    }
    private void DirectLightDoChange(float targetValue)
    {
       // Debug.LogError(curDirectValue + ":" + targetValue);
        if (Mathf.Abs(curDirectValue - targetValue) > 1)
        {
            targetDirectValue = targetValue;
            startDirectValue = curDirectValue;
            curDirectTime = 0.0f;
            isInDirectightChange = true;
        }
    }
    
    private void InitPointLight()
    {
        if (pointLight != null)
        {
            var isShowFire = GameEntry.Lua.CallWithReturn<bool>("CSharpCallLuaInterface.GetMainBuildFireIsOpen");
            var isDay = GameEntry.Lua.CallWithReturn<bool>("CSharpCallLuaInterface.GetIsDay");
            //开灯黑天
            if (isShowFire && (isDay == false))
            {
                SetPointLightShow(true);
                SetPointLightValue(openLightValue);
            }
            else
            {
                SetPointLightValue(closeLightValue);
                SetPointLightShow(false);
            }

            SetShaderOfToggleLight(isDay, isShowFire);
            ForceSetShaderGlobalValue(isShowFire);
            
            var isUseBig = GameEntry.Lua.CallWithReturn<bool>("CSharpCallLuaInterface.GetPointLightUseBigRange");
            if (isUseBig)
            {
                SetPointLightRangeValue(light2Value);
            }
            else
            {
                SetPointLightRangeValue(light1Value);
            }
        }
    }

    private void SetPointLightShow(bool isShow)
    {
        if (pointLightShow != isShow)
        {
            pointLightShow = isShow;
            pointLight.gameObject.SetActive(pointLightShow);
        }

    }
    // ReSharper disable Unity.PerformanceAnalysis
    private void RefreshPointLight()
    {
        if (pointLight != null)
        {
            var isShowFire = GameEntry.Lua.CallWithReturn<bool>("CSharpCallLuaInterface.GetMainBuildFireIsOpen");
            var isDay = GameEntry.Lua.CallWithReturn<bool>("CSharpCallLuaInterface.GetIsDay");
            if (isShowFire && isDay ==false)
            {
                //白天黑夜切换，先enable再变化亮度值
                SetPointLightShow(true);
                PointLightDoChange(openLightValue, false,0);
                

            }
            else
            {
                if (isShowFire==false && isDay == false)
                {
                    SetShaderOfToggleLight(isDay, isShowFire);
                }
                PointLightDoChange(closeLightValue,false,1);
            }
        }
    }
    
    private void SetPointLightValue(float value)
    {
        if (pointLight != null)
        {
            pointLight.intensity = value;
        }
        curPointValue = value;
    }

    private void PointLightDayNightChange()
    {
        var isOpen = GameEntry.Lua.CallWithReturn<bool>("CSharpCallLuaInterface.GetMainBuildFireIsOpen");
        var isDay = GameEntry.Lua.CallWithReturn<bool>("CSharpCallLuaInterface.GetIsDay");
        if (isOpen == true && isDay ==false)
        {
            //白天黑夜切换，先enable再变化亮度值
            SetPointLightShow(true);
            PointLightDoChange(openLightValue,true,0);
        }
        else
        {
            //白天黑夜切换，先变化亮度值再disable
            PointLightDoChange(closeLightValue,true,1);
        }
    }
    private void PointLightDoChange(float targetValue,bool isDayNight,float globalValue)
    {
        
        if (Mathf.Abs(curPointValue - targetValue) > 0.05f || isDayNight)
        {
            targetPointValue = targetValue;
            startPointValue = curPointValue;
            startGlobalFloat = curGlobalFloat;
            targetGlobalFloat = globalValue;
            curPointTime = 0.0f;
            isInPointLightChange = true;
            if (isDayNight)//白天黑夜过渡
            {
                OnPointLightChangeStart();
            }
            
        }
        
    }

    private void RefreshFireStateSignal(object userData)
    {
        RefreshPointLight();
    }
    public void SetUSkyLightingPointDistanceFalloff(float val)
    {
        uSkyLighting.pointDistanceFalloff = val;
    }

    public float GetUSkyLightingPointDistanceFalloff()
    {
        return uSkyLighting.pointDistanceFalloff;
    }

    public void SetUSkyActive(bool active)
    {
        if (uSkyGo != null)
        {
            uSkyGo.SetActive(active);
        }
    }

    public void OnPointLightChangeFinish()
    {
        var isDay = GameEntry.Lua.CallWithReturn<bool>("CSharpCallLuaInterface.GetIsDay");
        var isOpen = GameEntry.Lua.CallWithReturn<bool>("CSharpCallLuaInterface.GetMainBuildFireIsOpen");
        SetShaderDayOfNight(isDay);
        SetShaderOfToggleLight(isDay, isOpen);
        ForceSetShaderGlobalValue(isOpen);
    }
    public void OnPointLightChangeStart()
    {
        Shader.DisableKeyword("_Toggle_Day");
        Shader.DisableKeyword("_Toggle_Night");
    }
    void SetShaderDayOfNight(bool isDay)
    {

        if (isDay)
        {
            //Debug.LogError("Change Day");
            Shader.EnableKeyword("_Toggle_Day");
            Shader.DisableKeyword("_Toggle_Night");
        }
        else
        {
           // Debug.LogError("Change night");
            Shader.EnableKeyword("_Toggle_Night");
            Shader.DisableKeyword("_Toggle_Day");
        }


    }
    void SetShaderOfToggleLight(bool isDay,bool isOpen)
    {

        if (!isDay && !isOpen)
        {
            //Debug.LogError("EnableKeyword");
            Shader.EnableKeyword("_Toggle_Light");
        }
        else
        {
            //Debug.LogError("DisableKeyword");
            Shader.DisableKeyword("_Toggle_Light");
        }


    }
    void ForceSetShaderGlobalValue(bool isOpen)
    {

        if (!isOpen)
        {
            Shader.SetGlobalFloat("_GolbalDuringTimeLine", 1);
            curGlobalFloat = 1;
        }
        else
        {
            Shader.SetGlobalFloat("_GolbalDuringTimeLine", 0);
            curGlobalFloat = 0;

        }


    }

    private void RefreshRangeSignal(object userData)
    {
        var isUseBig = GameEntry.Lua.CallWithReturn<bool>("CSharpCallLuaInterface.GetPointLightUseBigRange");
        if (isUseBig)
        {
            PointLightRangeDoChange(light2Value);
        }
        else
        {
            PointLightRangeDoChange(light1Value);
        }
    }
    private void SetPointLightRangeValue(float value)
    {
        if (pointLight != null)
        {
            pointLight.range = value;
        }
        curPointLightRange = value;
    }
    private void PointLightRangeDoChange(float targetValue)
    {
        
        if (Mathf.Abs(curPointLightRange - targetValue) > 0.05f)
        {
            targetPointLightRange = targetValue;
            startPointLightRange = curPointLightRange;
            curPointRangeTime = 0.0f;
            IsInPointLightRangeChange = true;
        }
    }

    private void ForceSetPointLightValue(object userData)
    {
        var valueStr = userData as string;
        if (valueStr.IsNullOrEmpty())
        {
            return;
        }
        var value = valueStr.ToFloat();
        if (value >= -0.01f)
        {
            cachePointLight = curPointValue;
            SetPointLightValue(value);
        }
    }

    private void ForceResetPointLightValue(object userData)
    {
        if (cachePointLight >= -0.01f)
        {
            SetPointLightValue(cachePointLight);
            cachePointLight = -1.0f;
        }
    }

    private void ForceSetLight1Value(object userData)
    {
        var valueStr = userData as string;
        if (valueStr.IsNullOrEmpty())
        {
            return;
        }
        var value = valueStr.ToFloat();
        if (value >= -0.01f)
        {
            light1Value = value;
        }
        SetPointLightRangeValue(light1Value);
            
    }
}