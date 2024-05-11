using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using DG.Tweening;
using System;
using UnityEngine.UI;
using Coffee.UIExtensions;
using GameFramework;
using UnityEngine.Profiling;
using UnityEngine.Serialization;

public class UIGoodsFly : MonoBehaviour
{
    #region 测试
    public bool isRun = false;
    public Vector3 targetPos = Vector3.zero;
    public float minSize = -100;
    public float maxSize = 100;
    public bool isReset = false;
    public Vector3 oldPos = Vector3.zero;

    #endregion
    public float moveTime = 1;
    private static float _pointCount = 5f;
    private static int SEGMENT_COUNT = 20;
    public AnimationCurve firstCurve;
    public AnimationCurve secondCurve;
    public AnimationCurve thirdCurve;
    public Vector3 controlPointOffset = new Vector3(0, 300, 0);
    private int SearchFlyType = 999;
    public Image img;
    public Text txt;
    // Start is called before the first frame update

    // 这里也是用一个全局的列表做缓存
    private static List<TrailRenderer> _listTrail = new List<TrailRenderer>(4);
    // private Dictionary<GameObject, TrailRenderer[]> gameObjectTrailRenders = new Dictionary<GameObject, TrailRenderer[]>();
    // 因为我们都是单线程的，所以这里用一个全局的path来保存每次贝塞尔曲线的20个数据点。
    private static Vector3[] _paths = new Vector3[UIGoodsFly.SEGMENT_COUNT];

    private void Awake()
    {
       // img = GetComponent<Image>();
  
    }
    private void OnEnable()
    {


    }
    private void OnDisable()
    {
        ClearTrailRenderPoint();
    }
 
    void ClearTrailRenderPoint()
    {
        if (gameObject != null)
        {
            //Log.Debug(string.Format("ClearTrailRenderPoint  ---  id: {0}", gameObject.GetInstanceID()));
            _listTrail.Clear();
            gameObject.GetComponentsInChildren<TrailRenderer>(false, _listTrail);
            for (var n = 0; n < _listTrail.Count; ++n)
            {
                _listTrail[n].Clear();
            }

            //TrailRenderer[] trailRenderers;
            // if (!gameObjectTrailRenders.ContainsKey(gameObject))
            // {
            //     gameObjectTrailRenders.Add(gameObject, gameObject.GetComponentsInChildren<TrailRenderer>());
            // }
            // if (gameObjectTrailRenders.TryGetValue(gameObject, out trailRenderers))
            // trailRenderers = gameObject.GetComponentsInChildren<TrailRenderer>();
            // if (trailRenderers != null)
            // {
            //     int length = trailRenderers.Length;
            //     if (length > 0)
            //     {
            //         for (var n = 0; n < length; ++n)
            //         {
            //             trailRenderers[n].Clear();
            //         }
            //     }
            // }
        }
    }

    private void Update()
    {
        if(isRun)
        {
            oldPos = transform.position;

            targetPos = GameObject.Find("Garbage_3444").transform.position;// new Vector3(transform.position.x, 0, transform.position.z);

            //DoAnim(minSize, maxSize, targetPos, null);
  

            isRun = false;
        }
        if(isReset)
        {
            transform.position = oldPos;
            isReset = false;
        }
    }


    public void DoAnimForLua(float minRange, float maxRange, int rewardType, string pic, int num, Vector3 destPos, Action onComplete)
    {
        DoAnim(minRange, maxRange, rewardType, pic, num, destPos, onComplete);
    }

    public void DoAnim(float minRange, float maxRange, int rewardType, string pic, int num, Vector3 destPos, Action onComplete)
    {
        if (txt != null)
        {
            txt.text = $"+{num}";
        }

        DoAnim(minRange, maxRange, rewardType, pic, destPos, onComplete);
    }
    public void DoAnimBox(float minRange, float maxRange, Vector3 startPos,Vector3 destPos, Action onComplete)
    {
        //Debug.LogError("time.............................." + Time.time);
      //  var destPos = GameObject.Find("sold_point").transform.position;
      
        //var newPos = new Vector3(destPos.x, startPos.y, destPos.z);
        // var dir = newPos - startPos;
        // dir = dir.normalized;
        float t1 = UnityEngine.Random.Range(-3, 3);
        float t2 = UnityEngine.Random.Range(0, 3);
        float t3 = UnityEngine.Random.Range(-3, 3);
        startPos = new Vector3(startPos.x +  t1, startPos.y +  t2, startPos.z +  t3);
        var cross = Vector3.Cross(startPos, destPos);
        Vector3 controlPos = Vector3.zero;
        if (cross.y > 0) //左边
        {
            controlPos = (startPos + destPos) * middleValue + controlPointOffset;
        }
        else//右边
        {
            controlPos = (startPos + destPos) * middleValue - controlPointOffset;
        }

        // DOTween.defaultRecyclable = true;  

        Vector3[] pathvec = Bezier2Path(startPos, controlPos, destPos);
        Sequence seq = DOTween.Sequence();
        seq.Append(transform.DOMove(startPos, 0.2f)).SetEase(firstCurve);
        seq.Append(transform.DOPath(pathvec, moveTime)).SetEase(secondCurve);
        seq.AppendCallback(()=> { onComplete?.Invoke(); });
        
        //seq.Insert(0.2f, transform.DOPath(pathvec, moveTime)).SetEase(secondCurve)
        //  StartCoroutine(DelayComplete(onComplete));
        // seq.onComplete = () =>
        // {
        //     //     Debug.LogError("endtime.............................." + Time.time);
        //     onComplete();
        // };
    }

    //飞3D物体
    public void DoAnim(float minRange,float maxRange,Vector3 destPos,Vector3 startPos, Action onComplete)
    {
        //Debug.LogError("time.............................." + Time.time);
       // var startPos = GameObject.Find("sold_point1").transform.position;
        var newPos = new Vector3(destPos.x, startPos.y, destPos.z);
        var dir = newPos - startPos;
        dir = dir.normalized;
        float t1 = UnityEngine.Random.Range(0, 3);
        float t2 = UnityEngine.Random.Range(0, 3);
        float t3 = UnityEngine.Random.Range(0, 3);
        startPos = new Vector3(startPos.x + dir.x*t1, startPos.y + dir.y*t2, startPos.z + dir.z*t3);
        var cross = Vector3.Cross(startPos, destPos);
        Vector3 controlPos = Vector3.zero;
        if (cross.y > 0) //左边
        {
            controlPos = (startPos + destPos) * middleValue + controlPointOffset;
        }
        else//右边
        {
            controlPos = (startPos + destPos) * middleValue - controlPointOffset;
        }

        Vector3[] pathvec = Bezier2Path(startPos, controlPos, destPos);
        Sequence seq = DOTween.Sequence();
        seq.Append(transform.DOMove(startPos, 0.2f)).SetEase(firstCurve);
        seq.Insert(0.2f, transform.DOPath(pathvec, moveTime)).SetEase(secondCurve);
      //  StartCoroutine(DelayComplete(onComplete));
        seq.onComplete = () =>
        {
       //     Debug.LogError("endtime.............................." + Time.time);
            onComplete();
        };
     
    }
    WaitForSeconds tt1 = new WaitForSeconds(0.5f);
    IEnumerator DelayComplete(Action onComplete)
    {
        yield return tt1;
        onComplete();
    }


    public void DoAnim(float minRange,float maxRange, int rewardType,string pic,Vector3 destPos,Action onComplete)
    {
        if(img!=null)
        {
            img.LoadSprite(pic);
            img.color = new Color(1, 1, 1, 1);
        }
 


        var startPos = transform.position + new Vector3(UnityEngine.Random.Range(minRange, maxRange), UnityEngine.Random.Range(minRange, maxRange), 0);

        var cross = Vector3.Cross(startPos, destPos);

        Vector3 controlPos = Vector3.zero;
        if (cross.y > 0) //左边
        {
            controlPos = (startPos + destPos) * middleValue + controlPointOffset;
        }
        else//右边
        {
            controlPos = (startPos + destPos) * middleValue - controlPointOffset;
        }
      
        Vector3[] pathvec = Bezier2Path(startPos, controlPos, destPos);
        Sequence seq = DOTween.Sequence();
        seq.Append(transform.DOMove(startPos, 0.2f)).SetEase(firstCurve);
        seq.Insert(0.2f, transform.DOPath(pathvec, moveTime)).SetEase(secondCurve);
        seq.onComplete = () =>
        {
            if (rewardType != null)
            {
                GameEntry.Event.Fire(EventId.RewardItemAdd,rewardType);
            }
            onComplete();
        };


    }
    public float middleValue = 0.5f;
    //获取二阶贝塞尔曲线路径数组
    private Vector3[] Bezier2Path(Vector3 startPos, Vector3 controlPos, Vector3 endPos)
    {
        // 这地方不好做缓存，因为startPos是做了一次随机的，所以这里很难有命中
        //List<Vector3> v = new List<Vector3>();
        for (int i = 1; i <= SEGMENT_COUNT; i++)
        {
            float t = i / (float)SEGMENT_COUNT;
            Vector3 pixel = CalculateCubicBezierPointfor2C(t, startPos, controlPos, endPos);

            _paths[i - 1] = pixel;
            //  v.Add(pixel);
        }
        //return v.ToArray();
        return _paths;
    }
    // 2阶贝塞尔曲线
    public static Vector3 Bezier2(Vector3 startPos, Vector3 controlPos, Vector3 endPos, float t)
    {
        return (1 - t) * (1 - t) * startPos + 2 * t * (1 - t) * controlPos + t * t * endPos;
    }

    // 3阶贝塞尔曲线
    public static Vector3 Bezier3(Vector3 startPos, Vector3 controlPos1, Vector3 controlPos2, Vector3 endPos, float t)
    {
        float t2 = 1 - t;
        return t2 * t2 * t2 * startPos
            + 3 * t * t2 * t2 * controlPos1
            + 3 * t * t * t2 * controlPos2
            + t * t * t * endPos;
    }
    /// <summary>
    /// 二次 贝塞尔 坐标点
    /// </summary>
    Vector3 CalculateCubicBezierPointfor2C(float t, Vector3 p0, Vector3 p1, Vector3 p2)
    {
        //B(t) = (1-t)(1-t)P0+ 2 (1-t) tP1 + ttP2,   0 <= t <= 1 
        float u = 1 - t;
        float tt = t * t;
        float uu = u * u;

        Vector3 p = uu * p0;
        p += 2 * u * t * p1;
        p += tt * p2;
        return p;
    }

}
