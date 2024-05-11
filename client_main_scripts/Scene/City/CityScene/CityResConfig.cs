using UnityEngine;

public class CityResConfig : MonoBehaviour
{
    public int objId;
    public int resType = 21;
    public int maxBlood = 6;//砍多少次
    public int refreshCd = 10;//cd
    public int buffId = 0;//buff
    public float outBuffRate = 0;//砍最后一刀爆buff的概率
    public float superRate = 0;//成为黄金树的概率
    public float outSuperBuffRate = 0;//黄金树砍一刀报buff的概率
    
    public float extraParaFloat;
    public string extraParaString;

    private void Start()
    {
        objId = gameObject.GetInstanceID();
    }
}