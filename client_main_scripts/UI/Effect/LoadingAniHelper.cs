using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
[ExecuteAlways]
public class LoadingAniHelper : MonoBehaviour
{
    public float alpha = 1;

    private Image image;
    private void Awake()
    {
        image = GetComponent<Image>();
 
        
    }

    // Update is called once per frame
    void Update()
    {
        if (image == null)
        {
            return;
        }
        alpha = Mathf.Clamp(alpha, 0, 1);
        image.material.SetFloat("_Alpha", alpha);


    }
}
