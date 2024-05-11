using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityGameFramework.Runtime;
public class MissileExplodeAnimationControll
{
    public static MissileExplodeAnimationControll Instance
    {
        get
        {
            if (_instance == null)
            {
                _instance = new MissileExplodeAnimationControll();
            }

            return _instance;
        }
    }
    private static MissileExplodeAnimationControll _instance;
    private List<string> _saveList;
    private GameObject _missileAniObj;
    private List<MissileExplodeAnimation> _saveAniList;
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
            string assetKey = GameEntry.Resource.LoadAssetAsync<GameObject>(GameDefines.EntityAssets.MissileExplodeFrameAnimation, (key, asset, err) =>
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
            _saveAniList = new List<MissileExplodeAnimation>();
        }
        GameObject mwa = GameObject.Instantiate(_missileAniObj);
        MissileExplodeAnimation mwAni = mwa.GetComponent<MissileExplodeAnimation>();
        mwAni.CSShow(m_userData);
        _saveAniList.Add(mwAni);

    }
    public void HideAni(GameObject temp)
    {
        if (_saveAniList != null && _saveAniList.Count > 0)
        {
            var tem = temp.GetComponent<MissileExplodeAnimation>();
            if (tem != null)
            {
                if (_saveAniList.Contains(tem))
                {
                    _saveAniList.Remove(tem);
                }
            }
        }
        if (_saveAniList.Count <= 0)
        {
            UnInit();
        }
    }
    public void UnInit()
    {
         _saveAniList = null;
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
public class MissileExplodeAnimation : MonoBehaviour {
    public class Param
    {
        public Vector3 pos;
    }

    protected internal  void CSShow(object userData)
    {
        Param param = userData as Param;
        if (param != null)
            transform.position = param.pos;
    }

    public void OnAnimationDone()
    {
        GameObject.Destroy(gameObject);
        MissileExplodeAnimationControll.Instance.HideAni(gameObject);
    }
}
