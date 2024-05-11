using System.Collections.Generic;
using UnityEngine;

public class WorldCulling : WorldManagerBase
{
    public interface ICullingObject
    {
        int CullingBoundsIndex { get; set; }
        BoundingSphere GetBoundingSphere();
        void OnCullingStateVisible(bool visible);
    }
    
    private CullingGroup cullingGroup = null;
    private GPUSkinningBetterList<BoundingSphere> cullingBounds = new GPUSkinningBetterList<BoundingSphere>(1000);
    private Dictionary<int, ICullingObject> objs = new Dictionary<int, ICullingObject>();

    public WorldCulling(WorldScene scene) : base(scene)
    {
    }
    
    public override void Init()
    {
        cullingGroup = new CullingGroup();
        cullingGroup.targetCamera = Camera.main;
        cullingGroup.SetBoundingDistances(new[] {float.PositiveInfinity});
        cullingGroup.SetDistanceReferencePoint(Camera.main.transform);
        cullingGroup.onStateChanged = OnCullingGroupStateChanged;
    }

    public override void UnInit()
    {
        cullingBounds.Release();
        objs.Clear();

        if (cullingGroup != null)
        {
            cullingGroup.Dispose();
            cullingGroup = null;
        }
    }

    public override void OnUpdate(float deltaTime)
    {
        base.OnUpdate(deltaTime);
        UpdateCullingBounds();
    }

    public void AddCullingBounds(ICullingObject cullingObject)
    {
        int idx = cullingBounds.size;
        cullingObject.CullingBoundsIndex = idx;
        objs.Add(idx, cullingObject);

        cullingBounds.Add(new BoundingSphere());
        cullingGroup.SetBoundingSpheres(cullingBounds.buffer);
        cullingGroup.SetBoundingSphereCount(cullingBounds.size);
    }

    public void RemoveCullingBounds(ICullingObject cullingObject)
    {
        if (cullingObject == null || cullingObject.CullingBoundsIndex < 0)
            return;


        int lastIdx = cullingBounds.size - 1;
        var lastObj = objs[lastIdx];
        lastObj.CullingBoundsIndex = cullingObject.CullingBoundsIndex;
        objs[lastObj.CullingBoundsIndex] = lastObj;
        objs.Remove(lastIdx);
        cullingBounds.RemoveAt(cullingBounds.size - 1);
        cullingGroup.SetBoundingSphereCount(cullingBounds.size);
        cullingObject.CullingBoundsIndex = -1;
    }

    private void UpdateCullingBounds()
    {
        foreach (var i in objs.Values)
        {
            cullingBounds[i.CullingBoundsIndex] = i.GetBoundingSphere();
        }
    }

    private void OnCullingGroupStateChanged(CullingGroupEvent evt)
    {
        var o = objs[evt.index];
        o.OnCullingStateVisible(evt.isVisible);
    }
}