using System.Collections.Generic;

namespace XLua.LuaDLL
{
    using System.Runtime.InteropServices;

    public partial class Lua
    {
        [DllImport(LUADLL, CallingConvention = CallingConvention.Cdecl)]
        public static extern int luaopen_rapidjson(System.IntPtr L);

        [MonoPInvokeCallback(typeof(LuaDLL.lua_CSFunction))]
        public static int LoadRapidJson(System.IntPtr L)
        {
            return luaopen_rapidjson(L);
        }

        [DllImport(LUADLL, CallingConvention = CallingConvention.Cdecl)]
        public static extern int luaopen_lpeg(System.IntPtr L);

        [MonoPInvokeCallback(typeof(LuaDLL.lua_CSFunction))]
        public static int LoadLpeg(System.IntPtr L)
        {
            return luaopen_lpeg(L);
        }

        [DllImport(LUADLL, CallingConvention = CallingConvention.Cdecl)]
        public static extern int luaopen_pb(System.IntPtr L);

        [MonoPInvokeCallback(typeof(LuaDLL.lua_CSFunction))]
        public static int LoadLuaProfobuf(System.IntPtr L)
        {
            return luaopen_pb(L);
        }

        [DllImport(LUADLL, CallingConvention = CallingConvention.Cdecl)]
        public static extern int luaopen_ffi(System.IntPtr L);

        [MonoPInvokeCallback(typeof(LuaDLL.lua_CSFunction))]
        public static int LoadFFI(System.IntPtr L)
        {
            return luaopen_ffi(L);
        }
        
        
        /// 测试
        [DllImport(LUADLL, CallingConvention = CallingConvention.Cdecl)]
        public static extern int loadPbSchemeBinary(System.IntPtr L, byte[] pointer, int length);
        
        [DllImport(LUADLL, CallingConvention = CallingConvention.Cdecl)]
        public static extern int StackTopToBin(System.IntPtr L, byte[] buffer, int length);

        
        
        [DllImport(LUADLL, CallingConvention = CallingConvention.Cdecl)]
        public static extern System.IntPtr GetStackTopBufLen(System.IntPtr L, out System.IntPtr length);
        
        [DllImport(LUADLL, CallingConvention = CallingConvention.Cdecl)]
        public static extern int CopyAndFreeStackTopBuf(System.IntPtr L, System.IntPtr baBytes, byte[] buffer, int length);
        
        [DllImport(LUADLL, CallingConvention = CallingConvention.Cdecl)]
        public static extern int BinToStackTable(System.IntPtr L, byte[] buffer, int length);
        
        
        [DllImport(LUADLL, CallingConvention = CallingConvention.Cdecl)]
        public static extern int ZLibCompressBound(int level);
        
        [DllImport(LUADLL, CallingConvention = CallingConvention.Cdecl)]
        public static extern int ZLibCompress(byte[] src, int srcLen, byte[] dst, int dstLen, int level);
        
        [DllImport(LUADLL, CallingConvention = CallingConvention.Cdecl)]
        public static extern int ZLibUnCompress(byte[] src, int srcLen, byte[] dst, int dstLen);

        [DllImport(LUADLL, CallingConvention = CallingConvention.Cdecl)]
        public static extern int luaL_traceback(System.IntPtr L, System.IntPtr L1, byte[] msg, int level);
        
        public static string Traceback(System.IntPtr L)
        {
            int top = lua_gettop(L);
            luaL_traceback(L, L, null, 1);
            string s = lua_tostring(L, -1);
            lua_settop(L, top);
            return s;
        }
        
        private delegate void UnityLogger(int logLevel, System.IntPtr pointer);
        [DllImport(LUADLL, CallingConvention = CallingConvention.Cdecl)]
        private static extern void RegisterUnityLogger(UnityLogger logger);

        public static void RegisterUnityLogger()
        {
            RegisterUnityLogger(Unity_Log);
        }
        
        private static readonly Dictionary<long, string> StrCache = new Dictionary<long, string>(32);
        [MonoPInvokeCallback(typeof(UnityLogger))]
        private static void Unity_Log(int logLevel, System.IntPtr pointer)
        {
            // var pValue = pointer.ToInt64();
            // if (!StrCache.TryGetValue(pValue, out var message))
            // {
            //     message = Marshal.PtrToStringAnsi(pointer);
            //     StrCache[pValue] = message;
            // }
// #if FINAL_RELEASE
//             return;
// #endif
            string message = Marshal.PtrToStringAnsi(pointer);

            if (logLevel == 0)
            {
                UnityEngine.Debug.Log(message);
            }
            else
            {
                UnityEngine.Debug.LogError(message);
            }
        }
        
        
        
        [MonoPInvokeCallback(typeof(LuaDLL.lua_CSFunction))]
        public static int Load_luaUtil(System.IntPtr L, byte[] pointer, int length)
        {
            return loadPbSchemeBinary(L, pointer, length);
        }
        
        
        [DllImport(LUADLL, CallingConvention = CallingConvention.Cdecl)]
        public static extern int luaopen_split(System.IntPtr L);

        [MonoPInvokeCallback(typeof(LuaDLL.lua_CSFunction))]
        public static int LoadStringExt(System.IntPtr L)
        {
            return luaopen_split(L);
        }
        
        
        //本地库
        [DllImport(LUADLL, CallingConvention = CallingConvention.Cdecl)]
        public static extern int luaopen_native(System.IntPtr L);

        [MonoPInvokeCallback(typeof(LuaDLL.lua_CSFunction))]
        public static int LoadLuaCNativeCode(System.IntPtr L)
        {
            return luaopen_native(L);
        }
        

    }
}