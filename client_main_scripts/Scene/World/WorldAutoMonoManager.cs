using System.Collections.Generic;
using UnityEngine;

public class WorldAutoMonoManager : WorldManagerBase
{
    private HashSet<AutoFaceToCamera> autoFaceSet;
    private HashSet<AutoAdjustScale> autoScaleSet;
    private Camera mainCamera;

    public WorldAutoMonoManager(WorldScene scene) : base(scene)
    {
        autoFaceSet = new HashSet<AutoFaceToCamera>();
        autoScaleSet = new HashSet<AutoAdjustScale>();
        mainCamera = Camera.main;
    }

    public override void OnUpdate(float deltaTime)
    {
        foreach (AutoFaceToCamera autoFace in autoFaceSet)
        {
            autoFace.OnUpdate(mainCamera);
        }
        foreach (AutoAdjustScale autoScale in autoScaleSet)
        {
            autoScale.OnUpdate(mainCamera);
        }
    }

    public void AddAutoFace(AutoFaceToCamera autoFace)
    {
        autoFaceSet.Add(autoFace);
    }

    public void RemoveAutoFace(AutoFaceToCamera autoFace)
    {
        autoFaceSet.Remove(autoFace);
    }

    public void AddAutoScale(AutoAdjustScale autoScale)
    {
        autoScaleSet.Add(autoScale);
    }

    public void RemoveAutoScale(AutoAdjustScale autoScale)
    {
        autoScaleSet.Remove(autoScale);
    }
}
