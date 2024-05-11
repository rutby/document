using System.Collections;
using System.Collections.Generic;
using GameFramework;
using UnityEngine;

/// <summary>
/// 头像战斗跟随
/// </summary>
public class TargetFlow : MonoBehaviour
{
    public GameObject drawPoint;
    public LineRenderer render = null;
    public Transform target;
    public float zOffset = 0;
    public float xOffset = 0;
    public Color lineColor = Color.green;
    public float maxYoffset = 5;
    public float minYoffset = 2;
    private bool toggleShowLine = true;
    private Transform tran;
    public Transform _a, _b;
    private bool doAnim = false;
    private float startTime = 0;
    private float continueTime = 0;

    // Start is called before the first frame update
    private void Awake()
    {
        tran = transform;
    }
    private void Start()
    {
        this.DoFlow();
    }
    void DoFlow()
    {
        if (target == null)
        {
            if (toggleShowLine)
            {
                render.gameObject.SetActive(false);
                toggleShowLine = false;
            }

            return;
        }
        var root = target.parent;
        float y = 0;
        var rot = root.rotation.eulerAngles.y % 180f;

        if (root.rotation.eulerAngles.y < 180)
        {
            y = Mathf.Lerp(maxYoffset, minYoffset, rot / 180f);
        }
        else
        {
            y = Mathf.Lerp(minYoffset, maxYoffset, rot / 180f);

        }
        if (!toggleShowLine)
        {
            render.gameObject.SetActive(true);
            toggleShowLine = true;

        }
        render.startColor = lineColor;
        render.endColor = lineColor;
        render.SetPosition(0, drawPoint.transform.position);
        render.SetPosition(1, target.parent.transform.position);
        float z = zOffset;
        var circle = root.localRotation.eulerAngles.y;
        if (circle > 180f)
        {
            circle -= 360f;
        }
        // if (circle >= -15.0f && circle <= 15.0f)
        // {
        //     z = 1.3f * zOffset;
        // }
        // else if ((circle >= 15.0f && circle <= 45.0f) || (circle >= -45.0f && circle <= -15.0f))
        // {
        //     z = 1.3f * zOffset;
        // }
        // else
        {
            z = zOffset;
        }
        // else
        // {
        //     z = Mathf.Lerp(zOffset, zOffset*(1.6f), rot / 180f);
        //
        // }
        target.transform.localPosition = new Vector3(xOffset, y, z);

        tran.position = target.transform.position;

        if (_a != null && _b != null)
        {
            _a.position = _b.position;
        }

    }

    public void DoFlowAnim(float deltaTime)
    {
        if (target == null)
        {
            if (toggleShowLine)
            {
                render.gameObject.SetActive(false);
                toggleShowLine = false;
            }

            return;
        }
        if (tran == null)
        {
            if (toggleShowLine)
            {
                render.gameObject.SetActive(false);
                toggleShowLine = false;
            }
            return;
        }
        continueTime = deltaTime;
        startTime = 0;
        doAnim = true;
        SetRotation(0);
    }

    private void SetRotation(float percent)
    {
        if (target == null)
        {
            if (toggleShowLine)
            {
                render.gameObject.SetActive(false);
                toggleShowLine = false;
            }

            return;
        }
        var root = target.parent;
        float y = 0;
        var rot = root.rotation.eulerAngles.y % 180f;

        if (root.rotation.eulerAngles.y < 180)
        {
            y = Mathf.Lerp(maxYoffset, minYoffset, rot / 180f);
        }
        else
        {
            y = Mathf.Lerp(minYoffset, maxYoffset, rot / 180f);

        }
        if (!toggleShowLine)
        {
            render.gameObject.SetActive(true);
            toggleShowLine = true;

        }
        render.startColor = lineColor;
        render.endColor = lineColor;
        render.SetPosition(0, drawPoint.transform.position);
        render.SetPosition(1, target.parent.transform.position);
        float z = zOffset;
        var circle = root.localRotation.eulerAngles.y;
        if (circle > 180f)
        {
            circle -= 360f;
        }
        // if (circle >= -15.0f && circle <= 15.0f)
        // {
        //     z = 2.1f * zOffset;
        // }
        // else if ((circle >= 15.0f && circle <= 45.0f) || (circle >= -45.0f && circle <= -15.0f))
        // {
        //     z = 1.3f * zOffset;
        // }
        // else
        // {
            z = zOffset;
        // }
        target.transform.localPosition = new Vector3(xOffset, y, z*percent);

        tran.position = target.transform.position;

        if (_a != null && _b != null)
        {
            _a.position = _b.position;
        }
    }
    // Update is called once per frame
    public void Update()
    {
        if (doAnim)
        {
            startTime += Time.deltaTime;
            if (startTime > continueTime)
            {
                doAnim = false;
                startTime = 0;
                SetRotation(1);
            }
            else
            {
                SetRotation((float)startTime/continueTime);
            }
        }
        else
        {
            this.DoFlow();
        }
        

    }
}
