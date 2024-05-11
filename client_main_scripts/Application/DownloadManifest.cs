using System;
using System.Collections.Generic;
using System.IO;
using System.IO.Compression;
using UnityEngine.Networking;
using GameFramework;
using Main.Scripts.Application.LoadingState;
using UnityEngine.Networking;
using UnityEngine;

#region Download Manifest

class DownloadManifest
{
    private VEngine.Manifest _manifest;
    private VEngine.ManifestVersionFile _versionFile;
    private string _versionName;
    private string _pathOrURL;
    private Status _status;
    private HttpRequest _httpRequest;
    private string _error;

    private enum Status
    {
        Loading, CheckVersion, Downloading, Success, Failed, WaitRetry
    }
    
    public bool isDone => _status == Status.Success || _status == Status.Failed;

    public string error => _error;
    
    public VEngine.Manifest manifest => _manifest;
    
    private int _retryTime = 0;
    private const int MAX_RETRY_TIME = 5;
    private const float RETRY_INTERVAL = 1;
    private float _retryDelay = 0;
    private float _retryElapseTime = 0;
    
    public DownloadManifest(string name)
    {
        _manifest = new VEngine.Manifest
        {
            name = name.ToLower(),
            onReadAsset = VEngine.Versions.OnReadAsset
        };
    }

    public void Dispose()
    {
        if (_httpRequest != null)
        {
            _httpRequest.Dispose();
            _httpRequest = null;
        }
    }
    
    public static DownloadManifest LoadAsync(string name)
    {
        var download = new DownloadManifest(name);
        download.Load();
        return download;
    }

    private void Load()
    {
        _versionName = VEngine.Manifest.GetVersionFile(_manifest.name);
        var versionPath = GameEntry.Resource.GetTempDownloadPath(_versionName);
        if (!File.Exists(versionPath))
        {
            Finish("version not exist.");
            return;
        }
        Log.Info("download manifest -> version path:" + versionPath);
        _versionFile = VEngine.ManifestVersionFile.Load(versionPath);
        _pathOrURL = VEngine.Versions.GetDownloadURL($"{_manifest.name}{VEngine.ManifestFile.CompressPosfix}_v{_versionFile.version}");

        _status = Status.CheckVersion;
        _retryTime = 0;
        _retryDelay = 0;
    }

    public void OnUpdate()
    {
        switch (_status)
        {
            case Status.CheckVersion:
                UpdateVersion();
                break;

            case Status.Downloading:
                UpdateDownloading();
                break;

            case Status.Loading:
                var path = GameEntry.Resource.GetTempDownloadPath(_manifest.name);
                _manifest.Load(path);
                Finish();
                break;
            case Status.WaitRetry:
                UpdateRetry();
                break;
        }
    }

    private void UpdateVersion()
    {
        var path = GameEntry.Resource.GetTempDownloadPath(_manifest.name);
        if (VEngine.Versions.Manifests.Exists(m => m.version == _versionFile.version && _manifest.name.Contains(m.name)))
        {
            Log.Info("Skip to download {0}, local version == remote version", _manifest.name);
            if (File.Exists(path))
            {
                File.Delete(path);
            }
            Finish();
            return;
        }
        
        if (File.Exists(path))
        {
            using (var stream = File.OpenRead(path))
            {
                if (VEngine.Utility.ComputeCRC32(stream) == _versionFile.crc)
                {
                    Log.Info("Skip to download {0}, remote manifest exist (same crc)", _manifest.name);
                    _status = Status.Loading;
                    return;
                }
                else
                {
                    Log.Info("crc not same ,versionFile crc:{0},downloadFile crc:{1},path:{2}",_versionFile.crc,VEngine.Utility.ComputeCRC32(stream),path);
                }
            }
        }
        if (File.Exists(path))
        {
            File.Delete(path);
        }
        StartDownload();
    }
    
    private void StartDownload()
    {
        if (_httpRequest != null)
        {
            _httpRequest.Dispose();
            _httpRequest = null;
        }

        _status = Status.Downloading;

        string path = _pathOrURL;
        string oriCdn = GameEntry.Resource.DownloadURL;
        string[] cdns = GameEntry.Resource.GetCDNLineList();
        int cdnIndex = (_retryTime) % cdns.Length;
        if (cdnIndex != 0 && path.StartsWith(oriCdn))
        {
            path = path.Replace(oriCdn, cdns[cdnIndex]);
        }
        if (cdnIndex != 1)
        {
            Log.Debug($"use back up cdn to download resource {path}");
        }
        
        Log.Info("begin to download manifest: {0}", path);

        _httpRequest = new HttpRequest(path);
        _httpRequest.Timeout = 30;
        _httpRequest.MaxTryCount = 1;
        _httpRequest.onFailed += delegate(HttpRequest req,string error)
        {
            if (_retryTime < MAX_RETRY_TIME)
            {
                Retry();
            }
            else
            {
                PostEventLog.Record(PostEventLog.Defines.DOWNLOAD_MANIFEST_FAILED, $"{_manifest.name} {error}");
                
                var errorMsg = "TimeOut";
                if (error != null)
                {
                    errorMsg = error;
                }
                Finish(errorMsg);
            }
            _httpRequest = null;
        };
        _httpRequest.onTimeOut += delegate(HttpRequest req)
        {
            if (_retryTime < MAX_RETRY_TIME)
            {
                Retry();
            }
            else
            {
                PostEventLog.Record(PostEventLog.Defines.DOWNLOAD_MANIFEST_TIMEOUT, _manifest.name);
                
                var errorMsg = "TimeOut";
                if (req.error != null)
                {
                    errorMsg = req.error;
                }
                Finish(errorMsg);
            }
            _httpRequest = null;
        };
        _httpRequest.onSuccess += delegate(HttpRequest req,DownloadHandler downloadHandler)
        {
            PostEventLog.Record(PostEventLog.Defines.DOWNLOAD_MANIFEST_SUCCESS, _manifest.name);
            Log.Info("download manifest finish: {0},cur net name:{1}", _manifest.name,req.url.ToString());
            try
            {
                var path = GameEntry.Resource.GetTempDownloadPath(_manifest.name);
                Unzip(req.data, path);
            }
            catch (Exception e)
            {
                int len = _httpRequest.data != null ? _httpRequest.data.Length : 0;
                var exception = e.Message + "\n" + e.StackTrace;
                Log.Error("OnSendReportCallback Error:{0}",exception);
                PostEventLog.Record(PostEventLog.Defines.DOWNLOAD_MANIFEST_FAILED, $"{_manifest.name} {exception}");
                Finish(exception);
                return;
            }
            _httpRequest = null;
            _status = Status.Loading;
        };
        
        _httpRequest.SendRequest();
        PostEventLog.Record(PostEventLog.Defines.DOWNLOAD_MANIFEST_START, _manifest.name);
    }
    private void UpdateDownloading()
    {
        _httpRequest.OnUpdate();
    }

    private void Finish(string error = null)
    {
        _error = error;
        _status = string.IsNullOrEmpty(_error) ? Status.Success : Status.Failed;
        if (_status == Status.Success)
        {
            Log.Info($"download manifest Success: {_manifest.name}");
        }
        else
        {
            Log.Error($"download manifest Error: {_manifest.name} {error}");
        }
    }
    private void Retry()
    {
        _status = Status.WaitRetry;
        ++_retryTime;
        _retryDelay += RETRY_INTERVAL;
        _retryElapseTime = 0;
        Log.Info($"download manifest:{_manifest.name} retry: {_retryTime}/{MAX_RETRY_TIME}");
    }
    private void UpdateRetry()
    {
        _retryElapseTime += Time.deltaTime;
        if (_retryElapseTime >= _retryDelay)
        {
            Log.Info($"DownLoadManifest retry::{_retryTime}/{MAX_RETRY_TIME} {_manifest.name}");
            StartDownload();
        }
    }
    private void Unzip(byte[] data, string path)
    {
        using (var stream = new MemoryStream(data))
        using (var zip = new ZipArchive(stream))
        {
            string dirName = Path.GetDirectoryName(path);
        
            foreach (ZipArchiveEntry entry in zip.Entries)
            {
                string fullPath = Path.Combine(dirName, entry.FullName);
                Directory.CreateDirectory(Path.GetDirectoryName(fullPath));
                using (Stream destination = File.Open(fullPath, FileMode.Create, FileAccess.Write, FileShare.None))
                {
                    using (Stream entryStream = entry.Open())
                        entryStream.CopyTo(destination);
                }
            }
        }
    }
}

#endregion
