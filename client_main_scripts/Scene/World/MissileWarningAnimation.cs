using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityGameFramework.Runtime;

public class MissileWarningController
{
    public static MissileWarningController Instance
    {
        get
        {
            if (_instance == null)
            {
                _instance = new MissileWarningController();
            }

            return _instance;
        }
    }
    private static MissileWarningController _instance;
    private List<string> _saveList;
    private GameObject _missileAniObj;
    private List<MissileWarningAnimation> _saveAniList;
    private object m_userData; 
    public bool StarAdd(object userData)
    {

        if (_saveList == null)
        {
            _saveList = new List<string>();
        }
        m_userData = userData;
        bool useLoad = false;
        if (_missileAniObj == null)
        {
            useLoad = true;
            /*
            string assetKey = GameEntry.Resource.LoadAssetAsync<GameObject>(GameDefines.EntityAssets.MissileWarningAnimation, (key, asset, err) =>
            {
                if (err.IsNullOrEmpty())
                {
                    _missileAniObj = asset as GameObject;
                    CheckLoad();
                }
            });
            _saveList.Add(assetKey);
            */
        }

        if (!useLoad)
        {
            CheckLoad();
        }
        return true;
    }

    private void CheckLoad()
    {
        InitAfterLoad();
    }

    private void InitAfterLoad()
    {
        if (_saveAniList == null)
        {
            _saveAniList = new List<MissileWarningAnimation>();
        }
        GameObject mwa = GameObject.Instantiate(_missileAniObj) ;
        MissileWarningAnimation mwAni = mwa.GetComponent<MissileWarningAnimation>();
        mwAni.CSShow(m_userData);
        _saveAniList.Add(mwAni);

    }
    public void UnInit()
    {
        if (_saveAniList != null && _saveAniList.Count > 0)
        {
            foreach (var per in _saveAniList)
            {
                 GameObject.Destroy(per.gameObject);
            }
            _saveAniList = null;
        }
        if (_saveList != null && _saveList.Count > 0)
        {
            foreach (var per in _saveList)
            {
                //GameEntry.Resource.UnloadAssetWithKey(per);
            }
            _saveList = null;
        }
        if (_missileAniObj != null)
        {
            _missileAniObj = null;
        }
    }
}
public class MissileWarningAnimation : MonoBehaviour {
    public class Param
    {
        public Vector3 pos;
    }
    public Param param;
    protected internal  void CSShow(object userData)
    {
        param = userData as Param;
        if (param != null)
        {
            // if (CommonUtils.CheckIsOpenNewCity())
            // {
            //     //param.pos.z += WorldScene.TileDiagonalSize * 0.5f - 2;
            // }
            // else
            // {
            //     //param.pos.z += WorldScene.TileDiagonalSize * 0.5f;
            // }
           // param.pos.y += 0.8f;
          
        }
        transform.position = param.pos;
    }
}
