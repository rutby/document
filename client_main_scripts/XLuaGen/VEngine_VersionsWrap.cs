#if USE_UNI_LUA
using LuaAPI = UniLua.Lua;
using RealStatePtr = UniLua.ILuaState;
using LuaCSFunction = UniLua.CSharpFunctionDelegate;
#else
using LuaAPI = XLua.LuaDLL.Lua;
using RealStatePtr = System.IntPtr;
using LuaCSFunction = XLua.LuaDLL.lua_CSFunction;
#endif

using XLua;
using System.Collections.Generic;


namespace XLua.CSObjectWrap
{
    using Utils = XLua.Utils;

    [Unity.IL2CPP.CompilerServices.Il2CppSetOption(Unity.IL2CPP.CompilerServices.Option.NullChecks, false)]
    public class VEngineVersionsWrap 
    {
        public static void __Register(RealStatePtr L)
        {
			ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			System.Type type = typeof(VEngine.Versions);
			Utils.BeginObjectRegister(type, L, translator, 0, 0, 0, 0);
			
			
			
			
			
			
			Utils.EndObjectRegister(type, L, translator, null, null,
			    null, null, null);

		    Utils.BeginClassRegister(type, L, __CreateInstance, 32, 15, 14);
			Utils.RegisterFunc(L, Utils.CLS_IDX, "GetManifest", _m_GetManifest_xlua_st_);
            Utils.RegisterFunc(L, Utils.CLS_IDX, "CreateAsset", _m_CreateAsset_xlua_st_);
            Utils.RegisterFunc(L, Utils.CLS_IDX, "IsAssetDownloaded", _m_IsAssetDownloaded_xlua_st_);
            Utils.RegisterFunc(L, Utils.CLS_IDX, "CreateScene", _m_CreateScene_xlua_st_);
            Utils.RegisterFunc(L, Utils.CLS_IDX, "CreateManifest", _m_CreateManifest_xlua_st_);
            Utils.RegisterFunc(L, Utils.CLS_IDX, "OnReadAsset", _m_OnReadAsset_xlua_st_);
            Utils.RegisterFunc(L, Utils.CLS_IDX, "Override", _m_Override_xlua_st_);
            Utils.RegisterFunc(L, Utils.CLS_IDX, "GetActualPath", _m_GetActualPath_xlua_st_);
            Utils.RegisterFunc(L, Utils.CLS_IDX, "GetDownloadDataPath", _m_GetDownloadDataPath_xlua_st_);
            Utils.RegisterFunc(L, Utils.CLS_IDX, "GetDownloadDataSystemPath", _m_GetDownloadDataSystemPath_xlua_st_);
            Utils.RegisterFunc(L, Utils.CLS_IDX, "GetPlayerDataURL", _m_GetPlayerDataURL_xlua_st_);
            Utils.RegisterFunc(L, Utils.CLS_IDX, "GetPlayerDataPath", _m_GetPlayerDataPath_xlua_st_);
            Utils.RegisterFunc(L, Utils.CLS_IDX, "GetDownloadURL", _m_GetDownloadURL_xlua_st_);
            Utils.RegisterFunc(L, Utils.CLS_IDX, "GetTemporaryPath", _m_GetTemporaryPath_xlua_st_);
            Utils.RegisterFunc(L, Utils.CLS_IDX, "ClearDownloadData", _m_ClearDownloadData_xlua_st_);
            Utils.RegisterFunc(L, Utils.CLS_IDX, "ClearAsync", _m_ClearAsync_xlua_st_);
            Utils.RegisterFunc(L, Utils.CLS_IDX, "InitializeOnLoad", _m_InitializeOnLoad_xlua_st_);
            Utils.RegisterFunc(L, Utils.CLS_IDX, "InitializeAsync", _m_InitializeAsync_xlua_st_);
            Utils.RegisterFunc(L, Utils.CLS_IDX, "UpdateAsync", _m_UpdateAsync_xlua_st_);
            Utils.RegisterFunc(L, Utils.CLS_IDX, "GetDownloadSizeAsync", _m_GetDownloadSizeAsync_xlua_st_);
            Utils.RegisterFunc(L, Utils.CLS_IDX, "DownloadAsync", _m_DownloadAsync_xlua_st_);
            Utils.RegisterFunc(L, Utils.CLS_IDX, "IsDownloaded", _m_IsDownloaded_xlua_st_);
            Utils.RegisterFunc(L, Utils.CLS_IDX, "IsChanged", _m_IsChanged_xlua_st_);
            Utils.RegisterFunc(L, Utils.CLS_IDX, "IsInWhiteList", _m_IsInWhiteList_xlua_st_);
            Utils.RegisterFunc(L, Utils.CLS_IDX, "GetAsset", _m_GetAsset_xlua_st_);
            Utils.RegisterFunc(L, Utils.CLS_IDX, "GetDependencies", _m_GetDependencies_xlua_st_);
            Utils.RegisterFunc(L, Utils.CLS_IDX, "GetBundlesWithGroups", _m_GetBundlesWithGroups_xlua_st_);
            Utils.RegisterFunc(L, Utils.CLS_IDX, "GetAllAssetPaths", _m_GetAllAssetPaths_xlua_st_);
            
			
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "APIVersion", VEngine.Versions.APIVersion);
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "Manifests", VEngine.Versions.Manifests);
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "WhiteListFailed", VEngine.Versions.WhiteListFailed);
            
			Utils.RegisterFunc(L, Utils.CLS_GETTER_IDX, "FuncCreateAsset", _g_get_FuncCreateAsset);
            Utils.RegisterFunc(L, Utils.CLS_GETTER_IDX, "FuncCreateScene", _g_get_FuncCreateScene);
            Utils.RegisterFunc(L, Utils.CLS_GETTER_IDX, "FuncCreateManifest", _g_get_FuncCreateManifest);
            Utils.RegisterFunc(L, Utils.CLS_GETTER_IDX, "FuncIsAssetDownloaded", _g_get_FuncIsAssetDownloaded);
            Utils.RegisterFunc(L, Utils.CLS_GETTER_IDX, "ManifestsVersion", _g_get_ManifestsVersion);
            Utils.RegisterFunc(L, Utils.CLS_GETTER_IDX, "PlayerDataPath", _g_get_PlayerDataPath);
            Utils.RegisterFunc(L, Utils.CLS_GETTER_IDX, "DownloadURL", _g_get_DownloadURL);
            Utils.RegisterFunc(L, Utils.CLS_GETTER_IDX, "CheckVersionURL", _g_get_CheckVersionURL);
            Utils.RegisterFunc(L, Utils.CLS_GETTER_IDX, "DownloadDataPath", _g_get_DownloadDataPath);
            Utils.RegisterFunc(L, Utils.CLS_GETTER_IDX, "PlatformName", _g_get_PlatformName);
            Utils.RegisterFunc(L, Utils.CLS_GETTER_IDX, "customLoadPath", _g_get_customLoadPath);
            Utils.RegisterFunc(L, Utils.CLS_GETTER_IDX, "SkipUpdate", _g_get_SkipUpdate);
            Utils.RegisterFunc(L, Utils.CLS_GETTER_IDX, "IsSimulation", _g_get_IsSimulation);
            Utils.RegisterFunc(L, Utils.CLS_GETTER_IDX, "CheckWhiteList", _g_get_CheckWhiteList);
            Utils.RegisterFunc(L, Utils.CLS_GETTER_IDX, "getDownloadURL", _g_get_getDownloadURL);
            
			Utils.RegisterFunc(L, Utils.CLS_SETTER_IDX, "FuncCreateAsset", _s_set_FuncCreateAsset);
            Utils.RegisterFunc(L, Utils.CLS_SETTER_IDX, "FuncCreateScene", _s_set_FuncCreateScene);
            Utils.RegisterFunc(L, Utils.CLS_SETTER_IDX, "FuncCreateManifest", _s_set_FuncCreateManifest);
            Utils.RegisterFunc(L, Utils.CLS_SETTER_IDX, "FuncIsAssetDownloaded", _s_set_FuncIsAssetDownloaded);
            Utils.RegisterFunc(L, Utils.CLS_SETTER_IDX, "PlayerDataPath", _s_set_PlayerDataPath);
            Utils.RegisterFunc(L, Utils.CLS_SETTER_IDX, "DownloadURL", _s_set_DownloadURL);
            Utils.RegisterFunc(L, Utils.CLS_SETTER_IDX, "CheckVersionURL", _s_set_CheckVersionURL);
            Utils.RegisterFunc(L, Utils.CLS_SETTER_IDX, "DownloadDataPath", _s_set_DownloadDataPath);
            Utils.RegisterFunc(L, Utils.CLS_SETTER_IDX, "PlatformName", _s_set_PlatformName);
            Utils.RegisterFunc(L, Utils.CLS_SETTER_IDX, "customLoadPath", _s_set_customLoadPath);
            Utils.RegisterFunc(L, Utils.CLS_SETTER_IDX, "SkipUpdate", _s_set_SkipUpdate);
            Utils.RegisterFunc(L, Utils.CLS_SETTER_IDX, "IsSimulation", _s_set_IsSimulation);
            Utils.RegisterFunc(L, Utils.CLS_SETTER_IDX, "CheckWhiteList", _s_set_CheckWhiteList);
            Utils.RegisterFunc(L, Utils.CLS_SETTER_IDX, "getDownloadURL", _s_set_getDownloadURL);
            
			
			Utils.EndClassRegister(type, L, translator);
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int __CreateInstance(RealStatePtr L)
        {
            return LuaAPI.luaL_error(L, "VEngine.Versions does not have a constructor!");
        }
        
		
        
		
        
        
        
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_GetManifest_xlua_st_(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
            
                
                {
                    string _name = LuaAPI.lua_tostring(L, 1);
                    
                        var gen_ret = VEngine.Versions.GetManifest( _name );
                        translator.Push(L, gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_CreateAsset_xlua_st_(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
            
                
                {
                    string _path = LuaAPI.lua_tostring(L, 1);
                    System.Type _type = (System.Type)translator.GetObject(L, 2, typeof(System.Type));
                    
                        var gen_ret = VEngine.Versions.CreateAsset( _path, _type );
                        translator.Push(L, gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_IsAssetDownloaded_xlua_st_(RealStatePtr L)
        {
		    try {
            
            
            
                
                {
                    string _path = LuaAPI.lua_tostring(L, 1);
                    
                        var gen_ret = VEngine.Versions.IsAssetDownloaded( _path );
                        LuaAPI.lua_pushboolean(L, gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_CreateScene_xlua_st_(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
            
                
                {
                    string _path = LuaAPI.lua_tostring(L, 1);
                    bool _additive = LuaAPI.lua_toboolean(L, 2);
                    
                        var gen_ret = VEngine.Versions.CreateScene( _path, _additive );
                        translator.Push(L, gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_CreateManifest_xlua_st_(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
            
                
                {
                    string _name = LuaAPI.lua_tostring(L, 1);
                    bool _builtin = LuaAPI.lua_toboolean(L, 2);
                    
                        var gen_ret = VEngine.Versions.CreateManifest( _name, _builtin );
                        translator.Push(L, gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_OnReadAsset_xlua_st_(RealStatePtr L)
        {
		    try {
            
            
            
                
                {
                    string _assetPath = LuaAPI.lua_tostring(L, 1);
                    
                    VEngine.Versions.OnReadAsset( _assetPath );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_Override_xlua_st_(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
            
                
                {
                    VEngine.Manifest _target = (VEngine.Manifest)translator.GetObject(L, 1, typeof(VEngine.Manifest));
                    
                    VEngine.Versions.Override( _target );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_GetActualPath_xlua_st_(RealStatePtr L)
        {
		    try {
            
            
            
                
                {
                    string _path = LuaAPI.lua_tostring(L, 1);
                    
                    VEngine.Versions.GetActualPath( ref _path );
                    LuaAPI.lua_pushstring(L, _path);
                        
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_GetDownloadDataPath_xlua_st_(RealStatePtr L)
        {
		    try {
            
            
            
                
                {
                    string _file = LuaAPI.lua_tostring(L, 1);
                    
                        var gen_ret = VEngine.Versions.GetDownloadDataPath( _file );
                        LuaAPI.lua_pushstring(L, gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_GetDownloadDataSystemPath_xlua_st_(RealStatePtr L)
        {
		    try {
            
            
            
                
                {
                    string _file = LuaAPI.lua_tostring(L, 1);
                    
                        var gen_ret = VEngine.Versions.GetDownloadDataSystemPath( _file );
                        LuaAPI.lua_pushstring(L, gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_GetPlayerDataURL_xlua_st_(RealStatePtr L)
        {
		    try {
            
            
            
                
                {
                    string _file = LuaAPI.lua_tostring(L, 1);
                    
                        var gen_ret = VEngine.Versions.GetPlayerDataURL( _file );
                        LuaAPI.lua_pushstring(L, gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_GetPlayerDataPath_xlua_st_(RealStatePtr L)
        {
		    try {
            
            
            
                
                {
                    string _file = LuaAPI.lua_tostring(L, 1);
                    
                        var gen_ret = VEngine.Versions.GetPlayerDataPath( _file );
                        LuaAPI.lua_pushstring(L, gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_GetDownloadURL_xlua_st_(RealStatePtr L)
        {
		    try {
            
            
            
                
                {
                    string _file = LuaAPI.lua_tostring(L, 1);
                    
                        var gen_ret = VEngine.Versions.GetDownloadURL( _file );
                        LuaAPI.lua_pushstring(L, gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_GetTemporaryPath_xlua_st_(RealStatePtr L)
        {
		    try {
            
            
            
                
                {
                    string _file = LuaAPI.lua_tostring(L, 1);
                    
                        var gen_ret = VEngine.Versions.GetTemporaryPath( _file );
                        LuaAPI.lua_pushstring(L, gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_ClearDownloadData_xlua_st_(RealStatePtr L)
        {
		    try {
            
            
            
                
                {
                    
                    VEngine.Versions.ClearDownloadData(  );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_ClearAsync_xlua_st_(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
            
                
                {
                    
                        var gen_ret = VEngine.Versions.ClearAsync(  );
                        translator.Push(L, gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_InitializeOnLoad_xlua_st_(RealStatePtr L)
        {
		    try {
            
            
            
                
                {
                    
                    VEngine.Versions.InitializeOnLoad(  );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_InitializeAsync_xlua_st_(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
            
                
                {
                    
                        var gen_ret = VEngine.Versions.InitializeAsync(  );
                        translator.Push(L, gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_UpdateAsync_xlua_st_(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
            
                
                {
                    string[] _manifests = translator.GetParams<string>(L, 1);
                    
                        var gen_ret = VEngine.Versions.UpdateAsync( _manifests );
                        translator.Push(L, gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_GetDownloadSizeAsync_xlua_st_(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
            
                
                {
                    VEngine.GetDownloadSizeMode _mode;translator.Get(L, 1, out _mode);
                    VEngine.Manifest[] _manifests = (VEngine.Manifest[])translator.GetObject(L, 2, typeof(VEngine.Manifest[]));
                    string[] _items = translator.GetParams<string>(L, 3);
                    
                        var gen_ret = VEngine.Versions.GetDownloadSizeAsync( _mode, _manifests, _items );
                        translator.Push(L, gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_DownloadAsync_xlua_st_(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
            
                
                {
                    VEngine.DownloadInfo[] _groups = (VEngine.DownloadInfo[])translator.GetObject(L, 1, typeof(VEngine.DownloadInfo[]));
                    
                        var gen_ret = VEngine.Versions.DownloadAsync( _groups );
                        translator.Push(L, gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_IsDownloaded_xlua_st_(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
            
                
                {
                    VEngine.BundleInfo _bundle = (VEngine.BundleInfo)translator.GetObject(L, 1, typeof(VEngine.BundleInfo));
                    
                        var gen_ret = VEngine.Versions.IsDownloaded( _bundle );
                        LuaAPI.lua_pushboolean(L, gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_IsChanged_xlua_st_(RealStatePtr L)
        {
		    try {
            
            
            
                
                {
                    string _manifest = LuaAPI.lua_tostring(L, 1);
                    
                        var gen_ret = VEngine.Versions.IsChanged( _manifest );
                        LuaAPI.lua_pushboolean(L, gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_IsInWhiteList_xlua_st_(RealStatePtr L)
        {
		    try {
            
            
            
                
                {
                    string _bundleName = LuaAPI.lua_tostring(L, 1);
                    
                        var gen_ret = VEngine.Versions.IsInWhiteList( _bundleName );
                        LuaAPI.lua_pushboolean(L, gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_GetAsset_xlua_st_(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
            
                
                {
                    string _path = LuaAPI.lua_tostring(L, 1);
                    VEngine.AssetInfo _asset;
                    
                        var gen_ret = VEngine.Versions.GetAsset( ref _path, out _asset );
                        LuaAPI.lua_pushboolean(L, gen_ret);
                    LuaAPI.lua_pushstring(L, _path);
                        
                    translator.Push(L, _asset);
                        
                    
                    
                    
                    return 3;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_GetDependencies_xlua_st_(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
            
                
                {
                    string _assetPath = LuaAPI.lua_tostring(L, 1);
                    VEngine.BundleInfo _bundle;
                    VEngine.BundleInfo[] _bundles;
                    
                        var gen_ret = VEngine.Versions.GetDependencies( _assetPath, out _bundle, out _bundles );
                        LuaAPI.lua_pushboolean(L, gen_ret);
                    translator.Push(L, _bundle);
                        
                    translator.Push(L, _bundles);
                        
                    
                    
                    
                    return 3;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_GetBundlesWithGroups_xlua_st_(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
            
                
                {
                    VEngine.Manifest[] _manifests = (VEngine.Manifest[])translator.GetObject(L, 1, typeof(VEngine.Manifest[]));
                    string[] _groupsNames = (string[])translator.GetObject(L, 2, typeof(string[]));
                    
                        var gen_ret = VEngine.Versions.GetBundlesWithGroups( _manifests, _groupsNames );
                        translator.Push(L, gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_GetAllAssetPaths_xlua_st_(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
            
                
                {
                    
                        var gen_ret = VEngine.Versions.GetAllAssetPaths(  );
                        translator.Push(L, gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        
        
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_FuncCreateAsset(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			    translator.Push(L, VEngine.Versions.FuncCreateAsset);
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 1;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_FuncCreateScene(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			    translator.Push(L, VEngine.Versions.FuncCreateScene);
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 1;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_FuncCreateManifest(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			    translator.Push(L, VEngine.Versions.FuncCreateManifest);
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 1;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_FuncIsAssetDownloaded(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			    translator.Push(L, VEngine.Versions.FuncIsAssetDownloaded);
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 1;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_ManifestsVersion(RealStatePtr L)
        {
		    try {
            
			    LuaAPI.lua_pushstring(L, VEngine.Versions.ManifestsVersion);
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 1;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_PlayerDataPath(RealStatePtr L)
        {
		    try {
            
			    LuaAPI.lua_pushstring(L, VEngine.Versions.PlayerDataPath);
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 1;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_DownloadURL(RealStatePtr L)
        {
		    try {
            
			    LuaAPI.lua_pushstring(L, VEngine.Versions.DownloadURL);
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 1;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_CheckVersionURL(RealStatePtr L)
        {
		    try {
            
			    LuaAPI.lua_pushstring(L, VEngine.Versions.CheckVersionURL);
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 1;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_DownloadDataPath(RealStatePtr L)
        {
		    try {
            
			    LuaAPI.lua_pushstring(L, VEngine.Versions.DownloadDataPath);
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 1;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_PlatformName(RealStatePtr L)
        {
		    try {
            
			    LuaAPI.lua_pushstring(L, VEngine.Versions.PlatformName);
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 1;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_customLoadPath(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			    translator.Push(L, VEngine.Versions.customLoadPath);
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 1;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_SkipUpdate(RealStatePtr L)
        {
		    try {
            
			    LuaAPI.lua_pushboolean(L, VEngine.Versions.SkipUpdate);
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 1;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_IsSimulation(RealStatePtr L)
        {
		    try {
            
			    LuaAPI.lua_pushboolean(L, VEngine.Versions.IsSimulation);
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 1;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_CheckWhiteList(RealStatePtr L)
        {
		    try {
            
			    LuaAPI.lua_pushboolean(L, VEngine.Versions.CheckWhiteList);
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 1;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_getDownloadURL(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			    translator.Push(L, VEngine.Versions.getDownloadURL);
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 1;
        }
        
        
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _s_set_FuncCreateAsset(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			    VEngine.Versions.FuncCreateAsset = translator.GetDelegate<System.Func<string, System.Type, VEngine.Asset>>(L, 1);
            
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 0;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _s_set_FuncCreateScene(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			    VEngine.Versions.FuncCreateScene = translator.GetDelegate<System.Func<string, bool, VEngine.Scene>>(L, 1);
            
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 0;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _s_set_FuncCreateManifest(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			    VEngine.Versions.FuncCreateManifest = translator.GetDelegate<System.Func<string, bool, VEngine.ManifestFile>>(L, 1);
            
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 0;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _s_set_FuncIsAssetDownloaded(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			    VEngine.Versions.FuncIsAssetDownloaded = translator.GetDelegate<System.Func<string, bool>>(L, 1);
            
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 0;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _s_set_PlayerDataPath(RealStatePtr L)
        {
		    try {
                
			    VEngine.Versions.PlayerDataPath = LuaAPI.lua_tostring(L, 1);
            
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 0;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _s_set_DownloadURL(RealStatePtr L)
        {
		    try {
                
			    VEngine.Versions.DownloadURL = LuaAPI.lua_tostring(L, 1);
            
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 0;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _s_set_CheckVersionURL(RealStatePtr L)
        {
		    try {
                
			    VEngine.Versions.CheckVersionURL = LuaAPI.lua_tostring(L, 1);
            
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 0;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _s_set_DownloadDataPath(RealStatePtr L)
        {
		    try {
                
			    VEngine.Versions.DownloadDataPath = LuaAPI.lua_tostring(L, 1);
            
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 0;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _s_set_PlatformName(RealStatePtr L)
        {
		    try {
                
			    VEngine.Versions.PlatformName = LuaAPI.lua_tostring(L, 1);
            
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 0;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _s_set_customLoadPath(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			    VEngine.Versions.customLoadPath = translator.GetDelegate<System.Func<string, string>>(L, 1);
            
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 0;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _s_set_SkipUpdate(RealStatePtr L)
        {
		    try {
                
			    VEngine.Versions.SkipUpdate = LuaAPI.lua_toboolean(L, 1);
            
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 0;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _s_set_IsSimulation(RealStatePtr L)
        {
		    try {
                
			    VEngine.Versions.IsSimulation = LuaAPI.lua_toboolean(L, 1);
            
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 0;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _s_set_CheckWhiteList(RealStatePtr L)
        {
		    try {
                
			    VEngine.Versions.CheckWhiteList = LuaAPI.lua_toboolean(L, 1);
            
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 0;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _s_set_getDownloadURL(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			    VEngine.Versions.getDownloadURL = translator.GetDelegate<System.Func<string, string>>(L, 1);
            
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 0;
        }
        
		
		
		
		
    }
}
