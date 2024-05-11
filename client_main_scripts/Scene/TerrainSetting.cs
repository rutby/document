using UnityEngine;

namespace Main.Scripts.Scene
{
    [CreateAssetMenu(fileName = "TerrainSetting", menuName = "APS - TerrainSetting", order = 0)]
    public class TerrainSetting : ScriptableObject
    {
        // 地表贴图
        public Texture2D control;
        public Texture2D splat0;
        public Texture2D splat1;
        // 地表贴图tiling & offset
        public Vector4 control_st;
        public Vector4 splat0_st;
        public Vector4 splat1_st;
        // 地表宽高（zw）
        public Vector4 terrainBounds;
    }
}