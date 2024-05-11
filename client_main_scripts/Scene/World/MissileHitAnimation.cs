using System.Collections;
using System.Collections.Generic;
using Spine.Unity;
using UnityEngine;
using UnityGameFramework.Runtime;
public class MissileHitAniContro
{
    public static MissileHitAniContro Instance
    {
        get
        {
            if (_instance == null)
            {
                _instance = new MissileHitAniContro();
            }

            return _instance;
        }
    }
    private static MissileHitAniContro _instance;
    private List<string> _saveList;
    private GameObject _missileAniObj;
    private List<MissileHitAnimation> _saveAniList;
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
            string assetKey = GameEntry.Resource.LoadAssetAsync<GameObject>(GameDefines.EntityAssets.MissileHitSkeletonAnimation, (key, asset, err) =>
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
            _saveAniList = new List<MissileHitAnimation>();
        }
        GameObject mwa = GameObject.Instantiate(_missileAniObj);
        MissileHitAnimation mwAni = mwa.GetComponent<MissileHitAnimation>();
        mwAni.CSShow(m_userData);
        _saveAniList.Add(mwAni);

    }
    public void HideAni(GameObject temp)
    {
        if (_saveAniList != null && _saveAniList.Count > 0)
        {
           var tem=  temp.GetComponent<MissileHitAnimation>();
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
public class MissileHitAnimation : MonoBehaviour {
    public class Param
    {
        public Vector3 pos;
    }
    private SkeletonAnimation skeletonAnimation;
    protected internal  void CSShow(object userData)
    {
        Param param = userData as Param;
        if (param != null)
            transform.position = param.pos;

         skeletonAnimation = GetComponent<SkeletonAnimation>();
        if (skeletonAnimation != null)
        {
            skeletonAnimation.AnimationState.End += OnAnimationDone;
            skeletonAnimation.AnimationState.Complete += OnAnimationDone;
        }
           
    }

    void OnAnimationDone(Spine.TrackEntry trackEntry)
    {
        skeletonAnimation.AnimationState.End -= OnAnimationDone;
        skeletonAnimation.AnimationState.Complete -= OnAnimationDone;
        GameObject.Destroy(gameObject);
        MissileHitAniContro.Instance.HideAni(gameObject);
    }
}
