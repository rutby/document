using System;
using UnityEngine;
using UnityEngine.UI;
using UnityEngine.Rendering.Universal;
using UnityEngine.Experimental.Rendering.Universal;
using System.Reflection;
using GameFramework;

[RequireComponent(typeof(RawImage))]
public class UIFormBlurEffect : MonoBehaviour
{
    private RawImage blurImage;
    private string rfName = "";
    private string keyWorldName = "";
    private bool isOpen = false;
    private Material mat;
    private void Awake()
    {
        blurImage = GetComponent<RawImage>();
        blurImage.enabled = false;
    }

    private void OnEnable()
    {
    }

    private void OnDisable()
    {
         HideBlurImage();
    }
    
    private void OnDestroy()
    {
        HideBlurImage();
    }
    public void HideBlurImage()
    {
        if (isOpen)
        {
            blurImage.material.DisableKeyword(keyWorldName);
            blurImage.enabled = false;
            isOpen = false;
        }

    }

    public void CreateRt(int blurOrder)
    {
        
    }
    public void ShowBlurImage(int blurOrder)
    {
        if (blurOrder <= 0)
        {
            return;
        }
        mat = new Material(blurImage.material); 
        blurImage.material = mat;
        blurImage.enabled = true;
            
        keyWorldName = "_Layer_" + blurOrder;
        blurImage.material.EnableKeyword(keyWorldName);
        isOpen = true;
    }

}