using System;
using UnityEngine;

public class ResourceUpEffect : MonoBehaviour
{
    public class Param
    {
        public Vector3 worldPos;
        public Transform target;
        public ResourceType resType;
        public Action EffectUpDone; //特效飞行完毕后的添加委托
        public bool notTrans;
    }

    private Param paramData;
    private float _time;
    private Vector3 _startPos;

    public void Init(object userData)
    {
        transform.SetParent(SceneManager.World.DynamicObjNode);
        transform.localScale = Vector3.one;
        paramData = userData as Param;

		if (userData != null)
        {
            Vector3 sourcePos = paramData.worldPos;
			if (!paramData.notTrans)
            {
                _startPos = Camera.main.WorldToScreenPoint(sourcePos);
            }
            else
            {
                _startPos = sourcePos;
            }
        }

        _time = 0;
    }

    private void Update()
    {
        if (paramData == null || paramData.target == null) return;
        _time += Time.deltaTime;
        transform.position =
            Vector3.Lerp(_startPos, paramData.target.transform.position, _time);
        if (_time > .99)
        {
            paramData.EffectUpDone?.Invoke();
            //SceneManager.World.CityEffectManager.ReturnResourceUpEffect(this.gameObject);
        }
    }

    private void OnDisable()
    {
        paramData.EffectUpDone = null;
        paramData = null;
    }

}