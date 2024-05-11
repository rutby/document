using GameFramework;
using UnityEngine;
using XLua;
using System.IO;
using System.Reflection;
using UnityEngine.AI;
using UnityEngine.Experimental.Rendering.Universal;
using UnityEngine.Rendering.Universal;

#if UNITY_EDITOR
using UnityEditor;
#endif

[Hotfix]
public class CommonUtils
{
    public static bool IsDebug()
    {
        bool isDebug = false;

#if DEBUG
        isDebug = true;
#endif

        return isDebug;
    }

    public static bool IsWriteLog()
    {
            // 如果是在editor下，直接返回true
#if UNITY_EDITOR
        return true;
#endif
            
#if __LOG
        return true;
#else
        return false;
#endif
    }
    
            /// <summary>
        ///     检查是否为覆盖安装：如果覆盖安装，删除cache/Builtin，cache/DownLoad，files/AssetBundles文件夹
        /// </summary>
        public static bool CheckIsOverridePackage()
        {
            var isOverride = false;
            var needCheckStr = "";
#if UNITY_IOS
            needCheckStr = GameEntry.Sdk.Version;
#else
            needCheckStr = GameEntry.Sdk.Version + ";" + GameEntry.Sdk.VersionCode;
#endif
            Log.Debug("cur version{0}",needCheckStr);
            var path = Application.persistentDataPath + "/CheckVersion.txt";
            if (File.Exists(path))
            {
                Log.Debug("already have CheckVersion.txt");
                var versionStr = File.ReadAllText(path);
                Log.Debug("file version{0}",versionStr);
                if (versionStr.Contains(needCheckStr)==false)
                {
                    isOverride = true;
                }
            }
            else
            {
                isOverride = true;
            }

            return isOverride;

        }

        public static void DeleteCache()
        {
            var assetBundlesPath = $"{Application.persistentDataPath}/{VEngine.Utility.buildPath}";
            if (Directory.Exists(assetBundlesPath))
            {
                Log.Debug("delete{0}",assetBundlesPath);
                Directory.Delete(assetBundlesPath,true);
            }
            var builtinPath = $"{Application.temporaryCachePath}/Builtin";
            if (Directory.Exists(builtinPath))
            {
                Directory.Delete(builtinPath,true);
                Log.Debug("delete{0}",builtinPath);
            }
            var downloadPath = $"{Application.temporaryCachePath}/Download";
            if (Directory.Exists(downloadPath))
            {
                Directory.Delete(downloadPath,true);
                Log.Debug("delete{0}",downloadPath);
            }
        }

        public static void WriteVersion()
        {
            var path = Application.persistentDataPath + "/CheckVersion.txt";
            var needCheckStr = "";
#if UNITY_IOS
            needCheckStr = GameEntry.Sdk.Version;
#else
            needCheckStr = GameEntry.Sdk.Version + ";" + GameEntry.Sdk.VersionCode;
#endif
            File.WriteAllText(path,needCheckStr);
            Log.Debug("write{0}",needCheckStr);
        }
    
        public static bool FindPathByNavMesh(NavMeshPath navMeshPath, Vector3 startPos, Vector3 dstPos,
            float sampleDistance = 6)
        {
            navMeshPath.ClearCorners();
            var ret1 = NavMesh.SamplePosition(dstPos, out var sampleHit, sampleDistance, NavMesh.AllAreas);
            if (!ret1)
            {
                return false;
            }

            var ret2 = NavMesh.CalculatePath(startPos, sampleHit.position, NavMesh.AllAreas, navMeshPath);
            if (ret2 && navMeshPath.status == NavMeshPathStatus.PathComplete)
            {
                return true;
            }

            return false;
        }
        
        public static void ChangeCameraStack(Camera camera, Camera stackCamera)
        {
            UniversalAdditionalCameraData data = camera.GetUniversalAdditionalCameraData();
            data.cameraStack.Clear();
            data.cameraStack.Add(stackCamera);
        }

        public static RenderObjects GetURPRenderFeature(string name)
        {
            UniversalRenderPipelineAsset URPAsset = QualitySettings.renderPipeline as UniversalRenderPipelineAsset;
            if (URPAsset == null)
                return null;
            
            FieldInfo fieldInfo = typeof(UniversalRenderPipelineAsset).GetField("m_RendererDataList", BindingFlags.Instance | BindingFlags.NonPublic);
            if (fieldInfo == null)
                return null;
            
            ScriptableRendererData[] scriptableRendererDataArr = fieldInfo.GetValue(URPAsset) as ScriptableRendererData[];
            if (scriptableRendererDataArr == null || scriptableRendererDataArr.Length == 0)
                return null;
            
            UniversalRendererData URPData = scriptableRendererDataArr[0] as UniversalRendererData;
            if (URPData == null)
                return null;

            RenderObjects renderFeature = URPData.rendererFeatures.Find(x => x.name == name) as RenderObjects;
            return renderFeature;
        }

        public static void SetURPRenderFeatureMaterial(string name, Material material)
        {
            RenderObjects renderFeature = GetURPRenderFeature(name);
            if (renderFeature == null)
                return;
            
#if UNITY_EDITOR
            EditorUtility.SetDirty(renderFeature);
#endif
            renderFeature.settings.overrideMaterial = material;
        }

        public static Material GetURPRenderFeatureMaterial(string name)
        {
            RenderObjects renderFeature = GetURPRenderFeature(name);
            if (renderFeature == null)
                return null;

            return renderFeature.settings.overrideMaterial;
        }
}