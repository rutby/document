using System.Collections;
using System.Collections.Generic;
using System.IO;
using GameKit.Base;
using UnityEngine;
using UnityEngine.Networking;

#if ODIN_INSPECTOR
using Sirenix.OdinInspector;
#endif

public class DynamicResourceManager : MonoBehaviour
{
    private static DynamicResourceManager _instance;
    private static readonly object _lock = new object();

    public static DynamicResourceManager Instance
    {
        get
        {
            // Double-Checked Locking
            if (_instance == null)
            {
                lock (_lock)
                {
                    if (_instance == null)
                    {
                        _instance = FindObjectOfType<DynamicResourceManager>();

                        if (FindObjectsOfType<DynamicResourceManager>().Length > 1)
                        {
                            return _instance;
                        }

                        if (_instance == null)
                        {
                            GameObject singleton = new GameObject("(Singleton) " + typeof(DynamicResourceManager));
                            _instance = singleton.AddComponent<DynamicResourceManager>();

                            DontDestroyOnLoad(singleton);
                        }
                    }
                }
            }

            return _instance;
        }
    }

#if ODIN_INSPECTOR
    [SerializeField]
    private bool showOdinInfo;
#endif

    public delegate void OnLoadComplete(string key, Object asset, object userdata);

    private readonly Dictionary<string, List<System.Delegate>> m_CallbackStack = new Dictionary<string, List<System.Delegate>>();
#if ODIN_INSPECTOR
    [ShowInInspector, ShowIf("showOdinInfo"), DictionaryDrawerSettings(IsReadOnly = true)]
#endif
    private readonly Dictionary<string, DynamicAsset> m_CachedAssetFromUrl = new Dictionary<string, DynamicAsset>();

    public void LoadTextureFromURL(string url, bool nonReadable, string cacheKey, OnLoadComplete action, string cacheFolder = "Images", object userdata = null)
    {
        if (string.IsNullOrEmpty(url))
        {
            Debug.LogError("url is null or empty");
            return;
        }

        if (!string.IsNullOrEmpty(cacheKey))
        {
            if (m_CachedAssetFromUrl.TryGetValue(cacheKey, out DynamicAsset asset))
            {
                action?.Invoke(cacheKey, asset.Object, userdata);
                return;
            }

            //避免同个url多次请求
            if (m_CallbackStack.ContainsKey(cacheKey))
            {
                RegistCallback(cacheKey, action);
                return;
            }

            RegistCallback(cacheKey, action);
        }
        else
        {
            RegistCallback(url, action);
        }

        WebRequestManager.Instance.LoadTexture(url, nonReadable, (request, isErr, data) =>
        {
            if (isErr)
            {
                Debug.LogErrorFormat("{0}: {1}", request.error, request.url);
                Callback(cacheKey, null, data);
            }
            else
            {
                if (request.isDone)
                {
                    if (WebRequestManager.Instance.IsDownloadResult(request, "file no exists"))
                    {
                        Debug.LogErrorFormat("{0} is not exist!", request.url);
                        Callback(cacheKey, null, data);
                    }
                    else
                    {
                        Texture2D texture = DownloadHandlerTexture.GetContent(request);

                        if (texture != null)
                        {
                            if (CacheAssetInLocal(request, cacheKey, cacheFolder))
                                m_CachedAssetFromUrl[cacheKey] = new DynamicAsset(texture);

                            if (string.IsNullOrEmpty(cacheKey))
                                Callback(request.url, texture, data);
                            else
                                Callback(cacheKey, texture, data);
                        }
                        else
                        {
                            Debug.LogErrorFormat("{0} is not a texture!", request.url);
                            Callback(cacheKey, null, data);
                        }
                    }
                }
            }
        }, 0, 0, userdata);
    }

    /// <summary>
    /// 从URL读取一个多媒体音频文件.
    /// </summary>
    /// <param name="url">下载URL.也可以是本地的file://文件</param>
    /// <param name="type">AudioType.</param>
    /// <param name="action">回调Action.</param>
    /// <param name="cacheFolder">缓存文件夹</param>
    /// <param name="cacheKey">本地缓存的文件名，可以包含相对路径，默认缓存地址为：files/Audio/cacheKey.</param>
    /// <param name="userdata">Userdata.</param>
    public void LoadMultimediaFromUrl(string url, AudioType type, OnLoadComplete action, string cacheFolder = "Audio", string cacheKey = null, object userdata = null)
    {
        if (string.IsNullOrEmpty(url))
        {
            Debug.LogError("url is null or empty");
            return;
        }

        if (!string.IsNullOrEmpty(cacheKey))
        {
            if (m_CachedAssetFromUrl.TryGetValue(cacheKey, out DynamicAsset asset))
            {
                action?.Invoke(cacheKey, asset.Object, userdata);
                return;
            }

            if (m_CallbackStack.ContainsKey(cacheKey))
            {
                RegistCallback(cacheKey, action);
                return;
            }

            RegistCallback(cacheKey, action);
        }
        else
        {
            RegistCallback(url, action);
        }

        WebRequestManager.Instance.LoadMultimedia(url, type, (request, isErr, data) =>
        {
            if (isErr)
            {
                Debug.LogErrorFormat("{0}: {1}", request.error, request.url);
                Callback(cacheKey, null, data);
            }
            else
            {
                if (request.isDone)
                {
                    if (WebRequestManager.Instance.IsDownloadResult(request, "file no exists"))
                    {
                        Debug.LogErrorFormat("{0} is not exist!", request.url);
                        Callback(cacheKey, null, data);
                    }
                    else
                    {
                        AudioClip audioClip = DownloadHandlerAudioClip.GetContent(request);

                        if (audioClip != null)
                        {
                            if (CacheAssetInLocal(request, cacheKey, cacheFolder))
                                m_CachedAssetFromUrl[cacheKey] = new DynamicAsset(audioClip);

                            if (string.IsNullOrEmpty(cacheKey))
                                Callback(request.url, audioClip, data);
                            else
                                Callback(cacheKey, audioClip, data);
                        }
                        else
                        {
                            Debug.LogErrorFormat("{0} is not a texture!", request.url);

                            Debug.LogErrorFormat("{0} is not an audio clip!", request.url);
                            Callback(cacheKey, null, data);
                        }
                    }
                }
            }
        }, 0, 0, userdata);
    }

    private void RegistCallback(string key, System.Delegate callback)
    {
        if (callback != null && !string.IsNullOrEmpty(key))
        {
            if (!m_CallbackStack.ContainsKey(key))
                m_CallbackStack.Add(key, new List<System.Delegate>());
            if (!m_CallbackStack[key].Contains(callback))
                m_CallbackStack[key].Add(callback);
        }
    }

    private void Callback(string key, Object obj, object userdata)
    {
        if (m_CallbackStack.TryGetValue(key, out List<System.Delegate> callbackList))
        {
            m_CallbackStack.Remove(key);
            foreach (OnLoadComplete callback in callbackList)
            {
                try
                {
                    if (callback != null)
                        callback.Invoke(key, obj, userdata);
                }
                catch (System.Exception e)
                {
                    Debug.LogError(e);
                }
            }
        }
    }

    private static bool CacheAssetInLocal(UnityWebRequest request, string cacheKey, string cacheFolder)
    {
        if (string.IsNullOrEmpty(cacheKey))
            return false;

        if (!request.url.StartsWith("file://", System.StringComparison.Ordinal))
        {
            string cachePath = Path.Combine(Application.temporaryCachePath, cacheFolder, cacheKey);

            string cacheDirectory = Path.GetDirectoryName(cachePath);
            if (!Directory.Exists(cacheDirectory))
                Directory.CreateDirectory(cacheDirectory);

            using (FileStream fs = new FileStream(cachePath, FileMode.Create, FileAccess.Write))
            {
                fs.Write(request.downloadHandler.data, 0, request.downloadHandler.data.Length);
            }

            string dataPath = Path.Combine(Application.persistentDataPath, cacheFolder, cacheKey);
            if (File.Exists(dataPath))
                File.Delete(dataPath);

            string dataDirectory = Path.GetDirectoryName(dataPath);
            if (!Directory.Exists(dataDirectory))
                Directory.CreateDirectory(dataDirectory);

            File.Move(cachePath, dataPath);
            Directory.Delete(cacheDirectory);
        }

        return true;
    }
}

[System.Serializable]
public class DynamicAsset
{
    private Object m_Object;
    private int m_ReferencedCount;

    public DynamicAsset(Object obj)
    {
        Name = obj.name;
        m_Object = obj;
        m_ReferencedCount = 1;
    }

    public DynamicAsset(Object obj, int referencedCount)
    {
        Name = obj.name;
        m_Object = obj;
        m_ReferencedCount = referencedCount;
    }

    public string Name { get; }

    public Object Object
    {
        get
        {
            m_ReferencedCount++;
            return m_Object;
        }
    }
}
