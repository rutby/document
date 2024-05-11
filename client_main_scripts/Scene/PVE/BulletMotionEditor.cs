using System;
using System.Globalization;
using System.Text;
using Sirenix.OdinInspector;
using UnityEngine;




public class BulletMotionEditor : MonoBehaviour
{
    [SerializeField]
    [Title("技能配置id")]
    private int skillId=200100;
    public int SkillId
    {
        get { return skillId;}
        set { skillId = value; }
    }
    
    [SerializeField]
    [Title("技能索敌距离")]
    private float attackRange;
    public float AttackRange
    {
        get { return attackRange;}
        set { attackRange = value; }
    }
    
    [SerializeField]
    [Title("技能CD")]
    private float cooldown=2;
    public float Cooldown
    {
        get { return cooldown;}
        set { cooldown = value; }
    }
    
    [SerializeField]
    [Title("子弹特效预制体")]
    private GameObject bulletEffect;
    public GameObject BulletEffect
    {
        get { return bulletEffect;}
        set { bulletEffect = value; }
    }

    [SerializeField]
    [Title("子弹轨迹高宽比（仅抛物线型使用，直线型子弹无效）")]
    private float heightWidthRatio=0.5f;
    public float HeightWidthRatio
    {
        get { return heightWidthRatio;}
        set { heightWidthRatio = value; }
    }
    
    [SerializeField]
    [Title("子弹轨迹高度（仅抛物线型使用，会覆盖\"高宽比\"配置）")]
    private float height=1f;
    public float Height
    {
        get { return height;}
        set { height = value; }
    }

    [SerializeField]
    [Title("子弹平均速率")]
    private float flySpeed=20;
    public float FlySpeed
    {
        get { return flySpeed;}
        set { flySpeed = value; }
    }

    [SerializeField]
    [Title("子弹路程随时间变化曲线")]
    private AnimationCurve motionCurve;
    public AnimationCurve MotionCurve
    {
        get { return motionCurve;}
        set { motionCurve = value; }
    }
    [SerializeField]
    [Title("上述曲线对应的字符串")]
    private string curveString="";
    public string CurveString
    {
        get { return curveString;}
        set { curveString = value; }
    }
    [SerializeField]
    [Title("将曲线转化为字符串")]
    private bool curveToString=false;  
    [SerializeField]
    [Title("将字符串转化为曲线")]
    private bool stringToCurve=false;
    [SerializeField]
    [Title("丧尸矩形")]
    public RectInt Rectangle=new RectInt(31,15,10,10);
    [SerializeField]
    [Title("是否大招")]
    private bool isUltimate=false;
    public bool IsUltimate
    {
        get { return isUltimate;}
        set { isUltimate = value; }
    }
    private void Update()
    {
        GameObject s;
        if (curveToString)
        {
            curveToString = false;
            curveString = CurveToString(motionCurve);
        }
        if (stringToCurve)
        {
            stringToCurve = false;
            motionCurve = StringToCurve(curveString);
        }
    }

    
    public static string CurveToString(AnimationCurve curve)
    {
        StringBuilder sb = new StringBuilder();

        for (int i = 0; i < curve.length; i++)
        {
            if (i>0)
            {
                sb.Append("|");
            }
            // sb.Append(string.Format("{0:F3},{1:F3},{2:F3},{3:F3},{4:F3},{5:F3},{6}",
            //     curve[i].time, curve[i].value, curve[i].inTangent,
            //     curve[i].outTangent, curve[i].inWeight, curve[i].outWeight,(int)curve[i].weightedMode));
            sb.Append(string.Format("{0:F3},{1:F3},{2:F3},{3:F3}",
                curve[i].time, curve[i].value, curve[i].inTangent,
                curve[i].outTangent));
        }
        return sb.ToString();
    }

    public static AnimationCurve StringToCurve(string str)
    {
        try
        {
            var key = str.Split('|');
            AnimationCurve newCurve = new AnimationCurve();
            for (int i = 0; i < key.Length; i++)
            {
                var keyParam=key[i].Split(',');
                float[] param = new float[4];
                for (int j = 0; j < 4; j++)
                {
                    param[j] = float.Parse(keyParam[j], NumberStyles.AllowLeadingSign | NumberStyles.AllowDecimalPoint | NumberStyles.AllowExponent, CultureInfo.InvariantCulture);
                }
                //Keyframe kf = new Keyframe(param[0], param[1],param[2], param[3],param[4], param[5]);
                // }
                //     kf.weightedMode = (WeightedMode)param7;
                //     int param7=int.Parse(keyParam[6]);
                // {
                // if (keyParam.Length==7)
                Keyframe kf = new Keyframe(param[0], param[1],param[2], param[3])
                {
                    weightedMode = WeightedMode.None
                };
                newCurve.AddKey(kf);
            }
            return newCurve;
        }
        catch (Exception e)
        {
            Console.WriteLine(e);
            return null;
        }
    }

}

