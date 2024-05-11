using System;
using System.Collections;
using System.Linq;
using UnityEngine;

public class WorldTouchEffect : MonoBehaviour
{
    [SerializeField]
    private MeshRenderer renderer;

    private Coroutine co;
    public void FadeIn()
    {
        if (co != null)
        {
            StopCoroutine(co);
        }
        co = StartCoroutine(CoFadeIn());
    }

    IEnumerator CoFadeIn()
    {
        float fadeInTime = 0.2f;
        float time = 0;
        while (time < fadeInTime)
        {
            time += Time.deltaTime;
            renderer.sharedMaterial.SetFloat("_Progress", time / fadeInTime);
            yield return null;
        }
        renderer.sharedMaterial.SetFloat("_Progress", 1);
    }
}