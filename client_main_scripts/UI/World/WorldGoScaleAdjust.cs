using System.Collections;
using System.Collections.Generic;
using UnityEngine;

/// <summary>
/// 已有通用脚本AutoAdjustScale，所以这个单给联盟标记用了
/// </summary>
public class WorldGoScaleAdjust : MonoBehaviour
{
    [SerializeField] private List<Transform> _transGoScaleList;
    [SerializeField] private List<Transform> _transGoPosList;
    [SerializeField] private AnimationCurve _scaleCurve;
    [SerializeField] private AnimationCurve _posCurve;
    

    [Header("Data")]
    [SerializeField] private int _maxDistance;
    [SerializeField] private Vector3 _maxScale;
    [SerializeField] private float _maxLocalPosY;//新加支持高度

    private float _cacheDistance;
    
    void Update()
    {
        float curDistance = SceneManager.World.GetLodDistance();
        if (!Mathf.Approximately(_cacheDistance, curDistance))
        {
            _cacheDistance = curDistance;
            if (_scaleCurve != null && _transGoScaleList != null && _transGoScaleList.Count > 0)
            {
                Vector3 newScale = _scaleCurve.Evaluate(curDistance / _maxDistance) * _maxScale;
                foreach (var tempNode in _transGoScaleList)
                {
                    tempNode.transform.localScale = newScale;
                }
            }
            if (_posCurve != null && _transGoPosList != null && _transGoPosList.Count > 0)
            {
                float newPosY = _posCurve.Evaluate(curDistance / _maxDistance) * _maxLocalPosY;
                foreach (var tempNode in _transGoPosList)
                {
                    tempNode.transform.localPosition = new Vector3(tempNode.transform.localPosition.x,  newPosY, tempNode.transform.localPosition.z);
                }
            }
        }

    }
}

