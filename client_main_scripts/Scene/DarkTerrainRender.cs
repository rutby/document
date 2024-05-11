using System.Collections.Generic;
using System.IO;
using Sirenix.OdinInspector;
using UnityEngine;

#if UNITY_EDITOR
using UnityEditor;
#endif

[ExecuteInEditMode]
public class DarkTerrainRender : MonoBehaviour
{
#if UNITY_EDITOR
    private const string SplatMapPath = "Assets/Main/Texture/TerrainMars/SplatControl0.png";
    private const string TerrainRaycastLayer = "Terrain Raycast";
    private const string MaskTexutePath = "Assets/_Art/Models/Environment/Map/Terrain/texture/mask/";
    
    [Tooltip("遮罩图放大/缩小比例")]
    public float ExtentScale = 1f;
    
    [Header("Single")]
    public GameObject SingleObject;
    public Texture SingleMask;
    
    [Space(10), Header("Batch")]
    public GameObject[] groups;

    
    [Button(ButtonSizes.Large)]
    void RenderSingle()
    {
        var camera = GetComponent<Camera>();
        var terrain = FindObjectOfType(typeof(Terrain)) as Terrain;
        if (terrain == null || SingleObject == null)
        {
            return;
        }
        var td = terrain.terrainData;
        RenderSingle(td, camera, SingleObject);
    }
   
    [Button(ButtonSizes.Large)]
    public void RenderBatch()
    {
        var camera = GetComponent<Camera>();
        var terrain = FindObjectOfType(typeof(Terrain)) as Terrain;
        if (terrain == null || groups == null || groups.Length == 0)
        {
            return;
        }
        var td = terrain.terrainData;
        RenderBatch(td, camera, groups);
    }

    [Button(ButtonSizes.Large)]
    void ClearTerrain()
    {
        var terrain = FindObjectOfType(typeof(Terrain)) as Terrain;
        if (terrain == null || SingleObject == null)
        {
            return;
        }
        var td = terrain.terrainData;
        
        var alphamaps = new float[td.alphamapHeight, td.alphamapWidth, td.alphamapLayers];
        for (int y = 0; y < td.alphamapHeight; y++)
        {
            for (int x = 0; x < td.alphamapWidth; x++)
            {
                alphamaps[y, x, 0] = 1;
                alphamaps[y, x, 1] = 0;
            }
        }

        td.SetAlphamaps(0, 0, alphamaps);
        ExportSplatmap(td);
    }

    private void RenderBatch(TerrainData td, Camera camera, GameObject[] groups)
    {
        // 准备
        var boundsObjList = new List<GameObject>();

        foreach (var g in groups)
        {
            var mountains = g.GetComponentsInChildren<MeshRenderer>();
            foreach (var m in mountains)
            {
                var path = UnityEditor.AssetDatabase.GetAssetPath(
                    UnityEditor.PrefabUtility.GetCorrespondingObjectFromOriginalSource(m.gameObject));

                var maskName = Path.GetFileNameWithoutExtension(path);
                var maskTex = AssetDatabase.LoadAssetAtPath<Texture>(MaskTexutePath + maskName + ".tga");
                if (maskTex != null)
                {
                    boundsObjList.Add(PrepareBoundObj(m.gameObject, ExtentScale, maskTex));
                }
            }
        }

        // 将山的轮廓渲染RT
        var rt = Render(camera, td.alphamapWidth, td.alphamapHeight);

        // 读取RT，然后设置到地表控制图中
        SetRenderResultToTerrain(td, rt);
        ExportSplatmap(td);
        
        // 销毁或释放
        RenderTexture.ReleaseTemporary(rt);
        camera.targetTexture = null;
        foreach (var i in boundsObjList)
        {
            DestroyImmediate(i.GetComponent<Renderer>().sharedMaterial);
            DestroyImmediate(i);
        }
    }

    private void RenderSingle(TerrainData td, Camera camera, GameObject go)
    {
        // 准备
        var boundsObj = PrepareBoundObj(go, ExtentScale, SingleMask);
        
        // 将山的轮廓渲染RT
        var rt = Render(camera, td.alphamapWidth, td.alphamapHeight);
        
        // 读取RT，然后设置到地表控制图中
        SetRenderResultToTerrain(td, rt);
        ExportSplatmap(td);

        // 销毁或释放
        RenderTexture.ReleaseTemporary(rt);
        camera.targetTexture = null;
        DestroyImmediate(boundsObj.GetComponent<Renderer>().sharedMaterial);
        DestroyImmediate(boundsObj);
    }

    private static RenderTexture Render(Camera camera, int width, int height)
    {
        var rt = RenderTexture.GetTemporary(width, height);
        camera.cullingMask = LayerMask.GetMask(TerrainRaycastLayer);;
        camera.targetTexture = rt;
        camera.Render();
        return rt;
    }

    private static GameObject PrepareBoundObj(GameObject go, float extent, Texture mask)
    {
        var bounds = GetBounds(go);
        var boundsObj = GameObject.CreatePrimitive(PrimitiveType.Cube);
        boundsObj.layer = LayerMask.NameToLayer(TerrainRaycastLayer);
        boundsObj.transform.SetParent(go.transform);
        boundsObj.transform.localPosition = bounds.center;
        boundsObj.transform.localScale = new Vector3(bounds.size.x * extent, bounds.size.y,bounds.size.z * extent);
        boundsObj.transform.localRotation = Quaternion.Euler(0, 180, 0);

        var material = new Material(Shader.Find("Hidden/MountainMask"));
        material.SetTexture("_MainTex", mask);
        boundsObj.GetComponent<Renderer>().sharedMaterial = material;
        
        return boundsObj;
    }

    private static void SetRenderResultToTerrain(TerrainData td, RenderTexture rt)
    {
        var oldRT = RenderTexture.active;
        RenderTexture.active = rt;

        var tex = new Texture2D(rt.width, rt.height, TextureFormat.ARGB32, false, true);
        tex.ReadPixels(new Rect(0, 0, rt.width, rt.height), 0, 0);

        var alphamaps = new float[rt.height, rt.width, td.alphamapLayers];
        for (int y = 0; y < tex.height; y++)
        {
            for (int x = 0; x < tex.width; x++)
            {
                var col = tex.GetPixel(x, y);
                alphamaps[y, x, 0] = 1 - col.r;
                alphamaps[y, x, 1] = col.r;
            }
        }

        td.SetAlphamaps(0, 0, alphamaps);
        
        DestroyImmediate(tex);
        RenderTexture.active = oldRT;
    }

    private static Bounds GetBounds(GameObject go)
    {
        Bounds bounds = new Bounds(Vector3.zero, new Vector3(0.1f, 0.1f, 0.1f));
        var meshFilters = go.GetComponentsInChildren<MeshFilter>();
        foreach (var i in meshFilters)
        {
            bounds.Encapsulate(i.sharedMesh.bounds);
        }

        return bounds;
    }

    private void ExportSplatmap(TerrainData td)
    {
        var terrainData = td;
        var splatTex = new Texture2D(terrainData.alphamapWidth, terrainData.alphamapHeight, TextureFormat.RGBA32, false);
        var map = terrainData.GetAlphamaps(0, 0, terrainData.alphamapWidth, terrainData.alphamapHeight);
        for (int y = 0; y < terrainData.alphamapHeight; y++)
        {
            for (int x = 0; x < terrainData.alphamapWidth; x++)
            {
                var color = new Color(0, 0, 0, 0);
                if (terrainData.alphamapLayers > 0)
                {
                    color.r = map[y, x, 0];
                }
                if (terrainData.alphamapLayers > 1)
                {
                    color.g = map[y, x, 1];
                }
                if (terrainData.alphamapLayers > 2)
                {
                    color.b = map[y, x, 2];
                }
                if (terrainData.alphamapLayers > 3)
                {
                    color.a = map[y, x, 3];
                }

                splatTex.SetPixel(x, y, color);
            }
        }
        
        splatTex.Apply();
        var pngBytes = splatTex.EncodeToPNG();
        
        File.WriteAllBytes(SplatMapPath, pngBytes);
        GameObject.DestroyImmediate(splatTex);
        AssetDatabase.Refresh();

        var importer = AssetImporter.GetAtPath(SplatMapPath) as TextureImporter;
        importer.mipmapEnabled = false;
        importer.textureCompression = TextureImporterCompression.Uncompressed;
        importer.SaveAndReimport();
    }
#endif
}