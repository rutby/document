using System.Collections;
using System.Collections.Generic;
using UnityEngine;
[ExecuteAlways]
public class FogControll : MonoBehaviour
{
    public Color DistanceFog = Color.white;
    public float DistanceFogStart = 10.0f;
    public float DistanceFogEnd = 100.0f;
    public float HeightFogStart = 0.0f;
    public float HeightFogEnd = 10.0f;
    public bool EnableFog = false;
    private bool toggle = false;
    // Shader Uniforms.
    public static class Uniforms
    {
        // Fog.
        internal static readonly int _DistanceFogColor = Shader.PropertyToID("_FogColor");
        internal static readonly int _DistanceFogStart = Shader.PropertyToID("_FogStart");
        internal static readonly int _DistanceFogEnd = Shader.PropertyToID("_FogEnd");
        internal static readonly int _HeightFogStart = Shader.PropertyToID("_FogMinHeight");
        internal static readonly int _HeightFogEnd = Shader.PropertyToID("_FogMaxHeight");

    }

    public void Open()
    {
        Shader.SetGlobalColor(Uniforms._DistanceFogColor, DistanceFog);
        Shader.SetGlobalFloat(Uniforms._DistanceFogStart, DistanceFogStart);
        Shader.SetGlobalFloat(Uniforms._DistanceFogEnd, DistanceFogEnd);
        Shader.SetGlobalFloat(Uniforms._HeightFogStart, HeightFogStart);
        Shader.SetGlobalFloat(Uniforms._HeightFogEnd, HeightFogEnd);
        Shader.EnableKeyword("TOGGLE_FOG");
    }

    public void Close()
    {
        Shader.DisableKeyword("TOGGLE_FOG");
    }
    private void OnDestroy()
    {
        Shader.DisableKeyword("TOGGLE_FOG");
    }

}
