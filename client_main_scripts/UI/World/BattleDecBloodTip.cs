
using System;
using System.Collections;
using GameFramework;
using UnityEngine;
using UnityEngine.UI;
using UnityGameFramework.Runtime;
using Gradient = UnityEngine.UI.Gradient;

public class BattleDecBloodTip : MonoBehaviour
{
    public class Param
    {
        public Vector3 startPos;
        public int num;
        public string path;
    }
    [SerializeField] private SuperTextMesh _num;
	[SerializeField] private float _delay = 0.5f;
    [SerializeField] public float duringTime = 0;
    [SerializeField] private SimpleAnimation anim;
	Vector3 newpos;
    float distance;
    private bool _isShow;
    private bool _isOnce;
	private float time = 0;
    private InstanceRequest _InstanceRequest;

    protected internal void CSShow(object userData,InstanceRequest instanceRequest)
    {
  
        _InstanceRequest = instanceRequest;
		time = 0;

        if (userData is Param)
        {
            Param p = userData as Param;
            if (p.path != null && (p.path == WorldTroop.skillWordPath || p.path == WorldTroop.skillCarWordPath))
            {
                transform.position = p.startPos+ new Vector3(0, 0.1f, 0);
                newpos = transform.localPosition;
            }
            else
            {
                transform.position = p.startPos + new Vector3(0, 0.1f, 0);
                newpos = transform.localPosition;
            }
            _isShow = true;
            
            if (p.num <= 0)
            {
                p.num = Math.Abs(p.num);
                //_num.color = Color.green;
                _num.text = string.Format("+{0}", p.num.ToString());
            }
            else
            {
                //_num.color = new Color(1, 0.106156f, 0.106156f);
                _num.text = string.Format("-{0}", p.num.ToString());
            }
 
            _isOnce = true;
        }
    }
    private void Update()
    {
        if (!_isShow)
            return;

        distance = Vector3.Distance(transform.localPosition, newpos);
        time += Time.deltaTime;

        if (distance < 2)
        {
            if (_isOnce)
            {
                if (_InstanceRequest != null)
                {
                    if (anim != null)
                    {
                        anim.Play("showScale");
                    }
                    _isShow = false;
                    Destroy(_InstanceRequest.gameObject, duringTime);
                    //_InstanceRequest.Destroy();
                }
            }
            else
            {
                gameObject.SetActive(false);
                _isShow = false;
            }
            return;
        }

        if (time > _delay)
        {
            transform.localPosition = Vector3.Lerp(transform.localPosition, newpos, 0.05f);
        }
    }
}