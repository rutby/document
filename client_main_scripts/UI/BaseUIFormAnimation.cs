using GameKit.Base;
using UnityEngine;
using UnityEngine.Events;

public class BaseUIFormAnimation : MonoBehaviour
{
    private void Awake()
    {
        AddOpenKeyFrame();
        AddCloseKeyFrame();
        
        group = gameObject.GetOrAddComponent<CanvasGroup>();
    }

    private void OnEnable()
    {
        //group.interactable = true;

        openCurveTime = OpenCurveMaxTime;
        closeCurveTime = CloseCurveMaxTime;
    }

    private void Update()
    {
        UpdateOpenAnim();
        UpdateCloseAnim();
    }

    //////////////////////////////////////////////////////////////////////////
    /// 关闭界面动画
    private const float CloseCurveMaxTime = 0.17f;

    private float closeCurveTime;
    
    private Vector3AnimationCurve closeScaleCurve = new Vector3AnimationCurve();
    private AnimationCurve closeAlphaCurve = new AnimationCurve();

    private CanvasGroup group;

    public event UnityAction OnCloseEnd;

    private void AddCloseKeyFrame()
    {
        closeScaleCurve.AddKey(0, Vector3.one);
        closeScaleCurve.AddKey(CloseCurveMaxTime, new Vector3(1.03f, 1.03f, 1.03f));

        closeAlphaCurve.AddKey(0, 1);
        closeAlphaCurve.AddKey(CloseCurveMaxTime, 0);
    }
    
    private void UpdateCloseAnim()
    {
        if (closeCurveTime >= CloseCurveMaxTime)
            return;
        
        closeCurveTime += Time.deltaTime;
        if (closeCurveTime > CloseCurveMaxTime)
        {
            closeCurveTime = CloseCurveMaxTime;
        }
        
        transform.localScale = closeScaleCurve.Evaluate(closeCurveTime);
        group.alpha = closeAlphaCurve.Evaluate(closeCurveTime);

        if (closeCurveTime >= CloseCurveMaxTime && OnCloseEnd != null)
        {
            //group.interactable = false;
            OnCloseEnd.Invoke();
        }
    }

    public void PlayCloseAnim()
    {
        closeCurveTime = 0;
    }
    
    //////////////////////////////////////////////////////////////////////////
    /// 打开界面动画
    
    private const float OpenCurveMaxTime = 0.27f;

    private float openCurveTime;
    private Vector3AnimationCurve openScaleCurve = new Vector3AnimationCurve();
    private AnimationCurve openAlphaCurve = new AnimationCurve();
    
    private void AddOpenKeyFrame()
    {
        openScaleCurve.AddKey(0, new Vector3(1.02f, 1.02f, 1.02f));
        openScaleCurve.AddKey(0.13f, new Vector3(1.03f, 1.03f, 1.03f));
        openScaleCurve.AddKey(OpenCurveMaxTime, Vector3.one);

        openAlphaCurve.AddKey(0, 0.5f);
        openAlphaCurve.AddKey(0.13f, 1);
        openAlphaCurve.AddKey(OpenCurveMaxTime, 1);
    }

    private void UpdateOpenAnim()
    {
        if (openCurveTime >= OpenCurveMaxTime)
            return;

        openCurveTime += Time.deltaTime;
        if (openCurveTime > OpenCurveMaxTime)
        {
            openCurveTime = OpenCurveMaxTime;
        }
        
        transform.localScale = openScaleCurve.Evaluate(openCurveTime);
        group.alpha = openAlphaCurve.Evaluate(openCurveTime);
    }

    public void PlayOpenAnim()
    {
        openCurveTime = 0;
    }
}