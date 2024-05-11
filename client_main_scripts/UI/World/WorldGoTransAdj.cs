using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class WorldGoTransAdj : MonoBehaviour
{
    [SerializeField] private List<WorldGoTransAdjCurve> _curveList;
    [SerializeField] private List<WorldGoTransAdjParam> _worldTransList;
    [SerializeField] private float _maxCameraDistance;

    private float _cacheDistance;
    private Dictionary<string, AnimationCurve> _curveDic = new Dictionary<string, AnimationCurve>();

    void Start()
    {
        foreach (var tempCurve in _curveList)
        {
            _curveDic[tempCurve.CurveName] = tempCurve.Curve;
        }

        if (_maxCameraDistance <= 0)
        {
            _maxCameraDistance = int.MaxValue;
        }
    }

    private void Update()
    {
        float curDistance = SceneManager.World.GetLodDistance();
        if (!Mathf.Approximately(_cacheDistance, curDistance))
        {
            _cacheDistance = curDistance;
            
            foreach (var adjParam in _worldTransList)
            {
                if (adjParam.AdjType != WorldGoTransAdjParam.AdjustType.None)
                {
                    if (_curveDic.ContainsKey(adjParam.RefCurveName))
                    {
                        var curCurve = _curveDic[adjParam.RefCurveName];
                        if (adjParam.AdjType == WorldGoTransAdjParam.AdjustType.LocalScale)
                        {
                            Vector3 tempScale = curCurve.Evaluate(curDistance / _maxCameraDistance) * adjParam.V3Param;
                            adjParam.TransNode.localScale = tempScale;
                        }
                        else if (adjParam.AdjType == WorldGoTransAdjParam.AdjustType.LocalPos)
                        {
                            Vector3 tempPos = curCurve.Evaluate(curDistance / _maxCameraDistance) * adjParam.V3Param;
                            adjParam.TransNode.localPosition = tempPos;
                        }
                        else if (adjParam.AdjType == WorldGoTransAdjParam.AdjustType.LocalPosZ)
                        {
                            float tempPosZ = curCurve.Evaluate(curDistance / _maxCameraDistance) * adjParam.ParamNumF;
                            adjParam.TransNode.localPosition = new Vector3(adjParam.TransNode.localPosition.x, adjParam.TransNode.localPosition.y, tempPosZ);
                        }
                    }
                }
                
            }
        }
    }

    /*
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
    */
}

[System.Serializable]
public class WorldGoTransAdjCurve
{
    public string CurveName;
    public AnimationCurve Curve;
}

[System.Serializable]
public class WorldGoTransAdjParam
{
    public enum AdjustType
    {
        None,
        LocalScale,
        LocalPos,
        LocalPosZ,
    }
    
    public Transform TransNode;
    public AdjustType AdjType;
    public string RefCurveName;
    public float ParamNumF;
    public Vector3 V3Param;
}