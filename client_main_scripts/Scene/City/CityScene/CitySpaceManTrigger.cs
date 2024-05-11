using System;
using GameFramework;
using UnityEngine;
using System.Collections.Generic;

public class CitySpaceManTrigger : MonoBehaviour
{
    public long ObjectId { get; set; }
    public int resType { set; get; }
    public Action<long, int> TriggerEnterAction { get; set; }
    public Action<long> TriggerExitAction { get; set; }

    private Dictionary<Collider, CitySpaceManTrigger> triggerDic = new Dictionary<Collider, CitySpaceManTrigger>();

    public Vector3 Center { get; private set; }
    
    public float Radius { get; private set; }

    public float SizeX { get; private set; }

    public float SizeZ { get; private set; }

    private void Awake()
    {
        Center.Set(0, 0, 0);
        Radius = 0;
        SizeX = 0;
        SizeZ = 0;
    }

    public void RefreshSize()
    {
        float scale = transform.localScale.x;
        SphereCollider sphereCollider = GetComponent<SphereCollider>();
        if (sphereCollider != null)
        {
            Center = sphereCollider.center * scale;
            Radius = sphereCollider.radius * scale;
            return;
        }
        
        CapsuleCollider capsuleCollider = GetComponent<CapsuleCollider>();
        if (capsuleCollider != null)
        {
            Center = capsuleCollider.center;
            if (capsuleCollider.direction == 0) // X
            {
                SizeX = capsuleCollider.radius * scale * 2;
                SizeZ = capsuleCollider.height * scale;
            }
            else if (capsuleCollider.direction == 1) // Y
            {
                Radius = capsuleCollider.radius * scale;
            }
            else if (capsuleCollider.direction == 2) // Z
            {
                SizeX = capsuleCollider.height * scale;
                SizeZ = capsuleCollider.radius * scale * 2;
            }
            return;
        }
        
        BoxCollider boxCollider = GetComponent<BoxCollider>();
        if (boxCollider != null)
        {
            Vector3 size = boxCollider.size;
            SizeX = size.x * scale;
            SizeZ = size.z * scale;
            return;
        }
    }

    public Vector3 GetCurCenter()
    {
        return transform.position + Center;
    }
    
    private void OnEnable()
    {
        if (SceneManager.World != null)
        {
            SceneManager.World.RegisterPhysics(this);
        }
    }

    private void OnDisable()
    {
        if (SceneManager.World != null)
        {
            SceneManager.World.UnregisterPhysics(this);
        }
    }
    
    private void OnCollisionEnter(Collision other)
    {
        var trigger = other.gameObject.GetComponentInParent<CitySpaceManTrigger>();
        if (trigger != null)
        {
            TriggerEnterAction?.Invoke(trigger.ObjectId, trigger.resType);
        }
    }

    private void OnCollisionExit(Collision other)
    {
        var trigger = other.gameObject.GetComponentInParent<CitySpaceManTrigger>();
        if (trigger != null)
        {
            TriggerExitAction?.Invoke(trigger.ObjectId);
        }
    }

    private void OnTriggerEnter(Collider other)
    {
        CitySpaceManTrigger trigger = null;
        if (triggerDic.TryGetValue(other,out trigger))
        {
            if (trigger != null)
            {
                TriggerEnterAction?.Invoke(trigger.ObjectId, trigger.resType);
            }
        }
        else
        {
            var tmpTrigger = other.gameObject.GetComponentInParent<CitySpaceManTrigger>();
            if (tmpTrigger != null)
            {
                TriggerEnterAction?.Invoke(tmpTrigger.ObjectId, tmpTrigger.resType);
                triggerDic.Add(other, tmpTrigger);
            }

        }
   
       
    }

    private void OnTriggerExit(Collider other)
    {
        CitySpaceManTrigger trigger = null;
        if (triggerDic.TryGetValue(other, out trigger))
        {
            if (trigger != null)
            {
                TriggerExitAction?.Invoke(trigger.ObjectId);
            }
        }
        else
        {
            var tmpTrigger = other.gameObject.GetComponentInParent<CitySpaceManTrigger>();
            if (tmpTrigger != null)
            {
                TriggerExitAction?.Invoke(trigger.ObjectId);
                triggerDic.Add(other, tmpTrigger);
            }

        }
    }
    private void OnDestroy()
    {
        triggerDic.Clear();
    }
    
    #if UNITY_EDITOR

    private void OnDrawGizmos()
    {
        Vector3 c = GetCurCenter();
        if (Radius > 0)
        {
            Gizmos.DrawWireSphere(c, Radius);
        }
        else if (SizeX > 0 && SizeZ > 0)
        {
            Gizmos.DrawWireCube(c, new Vector3(SizeX, Mathf.Min(SizeX, SizeZ), SizeZ));
        }
    }

#endif
}