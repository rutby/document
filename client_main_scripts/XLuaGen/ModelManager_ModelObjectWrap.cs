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
    public class ModelManagerModelObjectWrap 
    {
        public static void __Register(RealStatePtr L)
        {
			ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			System.Type type = typeof(ModelManager.ModelObject);
			Utils.BeginObjectRegister(type, L, translator, 0, 9, 6, 6);
			
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "Destroy", _m_Destroy);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "UpdateLod", _m_UpdateLod);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "UpdateFog", _m_UpdateFog);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "CreateGameObject", _m_CreateGameObject);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "UpdateGameObject", _m_UpdateGameObject);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "OnUpdate", _m_OnUpdate);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "DoGuideStartAnim", _m_DoGuideStartAnim);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "SetIsVisible", _m_SetIsVisible);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "SetLabelActive", _m_SetLabelActive);
			
			
			Utils.RegisterFunc(L, Utils.GETTER_IDX, "instance", _g_get_instance);
            Utils.RegisterFunc(L, Utils.GETTER_IDX, "oldInstances", _g_get_oldInstances);
            Utils.RegisterFunc(L, Utils.GETTER_IDX, "pointIndex", _g_get_pointIndex);
            Utils.RegisterFunc(L, Utils.GETTER_IDX, "modelObjectType", _g_get_modelObjectType);
            Utils.RegisterFunc(L, Utils.GETTER_IDX, "isVisible", _g_get_isVisible);
            Utils.RegisterFunc(L, Utils.GETTER_IDX, "parent", _g_get_parent);
            
			Utils.RegisterFunc(L, Utils.SETTER_IDX, "instance", _s_set_instance);
            Utils.RegisterFunc(L, Utils.SETTER_IDX, "oldInstances", _s_set_oldInstances);
            Utils.RegisterFunc(L, Utils.SETTER_IDX, "pointIndex", _s_set_pointIndex);
            Utils.RegisterFunc(L, Utils.SETTER_IDX, "modelObjectType", _s_set_modelObjectType);
            Utils.RegisterFunc(L, Utils.SETTER_IDX, "isVisible", _s_set_isVisible);
            Utils.RegisterFunc(L, Utils.SETTER_IDX, "parent", _s_set_parent);
            
			
			Utils.EndObjectRegister(type, L, translator, null, null,
			    null, null, null);

		    Utils.BeginClassRegister(type, L, __CreateInstance, 1, 0, 0);
			
			
            
			
			
			
			Utils.EndClassRegister(type, L, translator);
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int __CreateInstance(RealStatePtr L)
        {
            return LuaAPI.luaL_error(L, "ModelManager.ModelObject does not have a constructor!");
        }
        
		
        
		
        
        
        
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_Destroy(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                ModelManager.ModelObject gen_to_be_invoked = (ModelManager.ModelObject)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    
                    gen_to_be_invoked.Destroy(  );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_UpdateLod(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                ModelManager.ModelObject gen_to_be_invoked = (ModelManager.ModelObject)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    int _lod = LuaAPI.xlua_tointeger(L, 2);
                    
                    gen_to_be_invoked.UpdateLod( _lod );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_UpdateFog(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                ModelManager.ModelObject gen_to_be_invoked = (ModelManager.ModelObject)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    int _fogId = LuaAPI.xlua_tointeger(L, 2);
                    
                    gen_to_be_invoked.UpdateFog( _fogId );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_CreateGameObject(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                ModelManager.ModelObject gen_to_be_invoked = (ModelManager.ModelObject)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    
                    gen_to_be_invoked.CreateGameObject(  );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_UpdateGameObject(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                ModelManager.ModelObject gen_to_be_invoked = (ModelManager.ModelObject)translator.FastGetCSObj(L, 1);
            
            
			    int gen_param_count = LuaAPI.lua_gettop(L);
            
                if(gen_param_count == 2&& translator.Assignable<object>(L, 2)) 
                {
                    object _param = translator.GetObject(L, 2, typeof(object));
                    
                    gen_to_be_invoked.UpdateGameObject( _param );
                    
                    
                    
                    return 0;
                }
                if(gen_param_count == 1) 
                {
                    
                    gen_to_be_invoked.UpdateGameObject(  );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
            return LuaAPI.luaL_error(L, "invalid arguments to ModelManager.ModelObject.UpdateGameObject!");
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_OnUpdate(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                ModelManager.ModelObject gen_to_be_invoked = (ModelManager.ModelObject)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    float _deltaTime = (float)LuaAPI.lua_tonumber(L, 2);
                    
                    gen_to_be_invoked.OnUpdate( _deltaTime );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_DoGuideStartAnim(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                ModelManager.ModelObject gen_to_be_invoked = (ModelManager.ModelObject)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    int _time = LuaAPI.xlua_tointeger(L, 2);
                    
                    gen_to_be_invoked.DoGuideStartAnim( _time );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_SetIsVisible(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                ModelManager.ModelObject gen_to_be_invoked = (ModelManager.ModelObject)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    bool _visible = LuaAPI.lua_toboolean(L, 2);
                    
                    gen_to_be_invoked.SetIsVisible( _visible );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_SetLabelActive(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                ModelManager.ModelObject gen_to_be_invoked = (ModelManager.ModelObject)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    bool _visible = LuaAPI.lua_toboolean(L, 2);
                    
                    gen_to_be_invoked.SetLabelActive( _visible );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        
        
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_instance(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                ModelManager.ModelObject gen_to_be_invoked = (ModelManager.ModelObject)translator.FastGetCSObj(L, 1);
                translator.Push(L, gen_to_be_invoked.instance);
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 1;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_oldInstances(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                ModelManager.ModelObject gen_to_be_invoked = (ModelManager.ModelObject)translator.FastGetCSObj(L, 1);
                translator.Push(L, gen_to_be_invoked.oldInstances);
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 1;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_pointIndex(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                ModelManager.ModelObject gen_to_be_invoked = (ModelManager.ModelObject)translator.FastGetCSObj(L, 1);
                LuaAPI.xlua_pushinteger(L, gen_to_be_invoked.pointIndex);
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 1;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_modelObjectType(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                ModelManager.ModelObject gen_to_be_invoked = (ModelManager.ModelObject)translator.FastGetCSObj(L, 1);
                translator.Push(L, gen_to_be_invoked.modelObjectType);
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 1;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_isVisible(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                ModelManager.ModelObject gen_to_be_invoked = (ModelManager.ModelObject)translator.FastGetCSObj(L, 1);
                LuaAPI.lua_pushboolean(L, gen_to_be_invoked.isVisible);
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 1;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_parent(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                ModelManager.ModelObject gen_to_be_invoked = (ModelManager.ModelObject)translator.FastGetCSObj(L, 1);
                translator.Push(L, gen_to_be_invoked.parent);
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 1;
        }
        
        
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _s_set_instance(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                ModelManager.ModelObject gen_to_be_invoked = (ModelManager.ModelObject)translator.FastGetCSObj(L, 1);
                gen_to_be_invoked.instance = (InstanceRequest)translator.GetObject(L, 2, typeof(InstanceRequest));
            
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 0;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _s_set_oldInstances(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                ModelManager.ModelObject gen_to_be_invoked = (ModelManager.ModelObject)translator.FastGetCSObj(L, 1);
                gen_to_be_invoked.oldInstances = (System.Collections.Generic.List<InstanceRequest>)translator.GetObject(L, 2, typeof(System.Collections.Generic.List<InstanceRequest>));
            
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 0;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _s_set_pointIndex(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                ModelManager.ModelObject gen_to_be_invoked = (ModelManager.ModelObject)translator.FastGetCSObj(L, 1);
                gen_to_be_invoked.pointIndex = LuaAPI.xlua_tointeger(L, 2);
            
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 0;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _s_set_modelObjectType(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                ModelManager.ModelObject gen_to_be_invoked = (ModelManager.ModelObject)translator.FastGetCSObj(L, 1);
                ModelManager.ModelObjectType gen_value;translator.Get(L, 2, out gen_value);
				gen_to_be_invoked.modelObjectType = gen_value;
            
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 0;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _s_set_isVisible(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                ModelManager.ModelObject gen_to_be_invoked = (ModelManager.ModelObject)translator.FastGetCSObj(L, 1);
                gen_to_be_invoked.isVisible = LuaAPI.lua_toboolean(L, 2);
            
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 0;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _s_set_parent(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                ModelManager.ModelObject gen_to_be_invoked = (ModelManager.ModelObject)translator.FastGetCSObj(L, 1);
                gen_to_be_invoked.parent = (ModelManager)translator.GetObject(L, 2, typeof(ModelManager));
            
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 0;
        }
        
		
		
		
		
    }
}
