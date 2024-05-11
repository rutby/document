// /***
//  * Created by zhangliheng.
//  * DateTime: 2023/06/16 5:04 PM
//  * Description:
//  ***/

using System;
using System.Linq;
using Sirenix.OdinInspector;
using UnityEngine;
using UnityEngine.Serialization;

[ExecuteInEditMode]
public class UISurvivalParticleSetUp : MonoBehaviour
{
    [Serializable]
    public class SpecialNodeCfg
    {
        public Renderer render;
        public int order;
    }

    [Title("父节点orderInLayer为：")]
    [ReadOnly] public int parentSortingOrder = 0;
    [Title("当前最终orderInLayer为：")]
    [ReadOnly] public int finalOrderInLayer = 0;
    
    [FormerlySerializedAs("globalLayer")] [Title("默认order：")]
    public int orderInLayer = 1;
    [Title("特殊节点设置：")]
    public SpecialNodeCfg[] specialNodeList;

    
    private void Start()
    {
        Refresh();
    }

    [Button("设置")]
    public void Refresh()
    {
        var parentCanvas = transform.GetComponentInParentExt<Canvas>(false);
        parentSortingOrder = parentCanvas != null ? parentCanvas.sortingOrder : 0;
        
        finalOrderInLayer = parentSortingOrder + orderInLayer;
        
        var renderList = transform.GetComponentsInChildren<Renderer>();
        foreach (var renderer in renderList)
        {
            if(specialNodeList != null && specialNodeList.Any(x => x.render == renderer))
                continue;
            
            renderer.sortingLayerName = "Default";
            renderer.sortingOrder = finalOrderInLayer;
        }

        if (specialNodeList != null)
        {
            foreach (var t in specialNodeList)
            {
                if (t.render)
                {
                    t.render.sortingLayerName = "Default";
                    t.render.sortingOrder = parentSortingOrder + t.order;
                }
            }
        }
    }

    public void SetLocalOrder(int order)
    {
        orderInLayer = order;
        Refresh();
    }
}
