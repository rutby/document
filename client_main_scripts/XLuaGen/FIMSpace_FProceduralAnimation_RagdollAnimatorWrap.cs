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
    public class FIMSpaceFProceduralAnimationRagdollAnimatorWrap 
    {
        public static void __Register(RealStatePtr L)
        {
			ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			System.Type type = typeof(FIMSpace.FProceduralAnimation.RagdollAnimator);
			Utils.BeginObjectRegister(type, L, translator, 0, 45, 9, 7);
			
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "User_GetRagdollBone", _m_User_GetRagdollBone);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "User_GetRagdollBoneUsingCharacterBone", _m_User_GetRagdollBoneUsingCharacterBone);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "User_GetRagdollBoneUsingName", _m_User_GetRagdollBoneUsingName);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "User_GetRagdollBoneController", _m_User_GetRagdollBoneController);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "User_GetRagdollBoneControllerUsingCharacterBone", _m_User_GetRagdollBoneControllerUsingCharacterBone);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "User_GetRagdollBoneControllerUsingName", _m_User_GetRagdollBoneControllerUsingName);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "User_TryGetCustomLimbChainsBone", _m_User_TryGetCustomLimbChainsBone);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "User_GetCustomLimbChainUsingName", _m_User_GetCustomLimbChainUsingName);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "User_GetCustomLimbChainBoneSetup", _m_User_GetCustomLimbChainBoneSetup);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "User_GetCustomLimbChainBoneController", _m_User_GetCustomLimbChainBoneController);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "User_GetCustomLimbChainBone", _m_User_GetCustomLimbChainBone);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "User_SetLimbImpact", _m_User_SetLimbImpact);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "User_SetAllLimbsVelocity", _m_User_SetAllLimbsVelocity);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "User_SetFallAndLimbImpact", _m_User_SetFallAndLimbImpact);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "User_SetPhysicalImpactAll", _m_User_SetPhysicalImpactAll);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "User_SetFallAndPhysicalImpactAll", _m_User_SetFallAndPhysicalImpactAll);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "User_SetPhysicalTorque", _m_User_SetPhysicalTorque);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "User_SetPhysicalTorqueFromLocal", _m_User_SetPhysicalTorqueFromLocal);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "User_SetVelocityAll", _m_User_SetVelocityAll);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "User_SetHumanoidLimbImpact", _m_User_SetHumanoidLimbImpact);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "User_ChangeReposeAndRestore", _m_User_ChangeReposeAndRestore);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "User_ChangeBlendOnCollisionAndRestore", _m_User_ChangeBlendOnCollisionAndRestore);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "User_SwitchFreeFallRagdoll", _m_User_SwitchFreeFallRagdoll);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "User_TransitionToNonFreeFallRagdoll", _m_User_TransitionToNonFreeFallRagdoll);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "User_EnableFreeRagdoll", _m_User_EnableFreeRagdoll);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "User_SwitchAnimator", _m_User_SwitchAnimator);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "User_GetUpStack", _m_User_GetUpStack);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "User_GetUpStackV2", _m_User_GetUpStackV2);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "User_OverrideRagdollStateWithCurrentAnimationState", _m_User_OverrideRagdollStateWithCurrentAnimationState);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "User_UpdateBonesToRagdollPose", _m_User_UpdateBonesToRagdollPose);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "User_FadeMuscles", _m_User_FadeMuscles);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "User_ForceRagdollToAnimatorFor", _m_User_ForceRagdollToAnimatorFor);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "User_FadeRagdolledBlend", _m_User_FadeRagdolledBlend);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "User_HardSwitchOffRagdollAnimator", _m_User_HardSwitchOffRagdollAnimator);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "User_DestroyRagdollAnimatorAndKeepPhysics", _m_User_DestroyRagdollAnimatorAndKeepPhysics);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "User_DestroyRagdollAnimatorAndFreeze", _m_User_DestroyRagdollAnimatorAndFreeze);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "User_Coroutine_DisableAnimatingAndKeepPose", _m_User_Coroutine_DisableAnimatingAndKeepPose);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "User_GetRagdollBonesStateBounds", _m_User_GetRagdollBonesStateBounds);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "User_Teleport", _m_User_Teleport);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "User_SetAllKinematic", _m_User_SetAllKinematic);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "User_SetAllAngularSpeedLimit", _m_User_SetAllAngularSpeedLimit);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "User_AnchorPelvis", _m_User_AnchorPelvis);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "User_RepositionRoot", _m_User_RepositionRoot);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "Reset", _m_Reset);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "Start", _m_Start);
			
			
			Utils.RegisterFunc(L, Utils.GETTER_IDX, "IsFadeRagdollCoroutineRunning", _g_get_IsFadeRagdollCoroutineRunning);
            Utils.RegisterFunc(L, Utils.GETTER_IDX, "Parameters", _g_get_Parameters);
            Utils.RegisterFunc(L, Utils.GETTER_IDX, "_initialReposeMode", _g_get__initialReposeMode);
            Utils.RegisterFunc(L, Utils.GETTER_IDX, "ObjectWithAnimator", _g_get_ObjectWithAnimator);
            Utils.RegisterFunc(L, Utils.GETTER_IDX, "RootBone", _g_get_RootBone);
            Utils.RegisterFunc(L, Utils.GETTER_IDX, "CustomRagdollAnimator", _g_get_CustomRagdollAnimator);
            Utils.RegisterFunc(L, Utils.GETTER_IDX, "AutoDestroy", _g_get_AutoDestroy);
            Utils.RegisterFunc(L, Utils.GETTER_IDX, "PreGenerateDummy", _g_get_PreGenerateDummy);
            Utils.RegisterFunc(L, Utils.GETTER_IDX, "TargetParentForRagdollDummy", _g_get_TargetParentForRagdollDummy);
            
			Utils.RegisterFunc(L, Utils.SETTER_IDX, "_initialReposeMode", _s_set__initialReposeMode);
            Utils.RegisterFunc(L, Utils.SETTER_IDX, "ObjectWithAnimator", _s_set_ObjectWithAnimator);
            Utils.RegisterFunc(L, Utils.SETTER_IDX, "RootBone", _s_set_RootBone);
            Utils.RegisterFunc(L, Utils.SETTER_IDX, "CustomRagdollAnimator", _s_set_CustomRagdollAnimator);
            Utils.RegisterFunc(L, Utils.SETTER_IDX, "AutoDestroy", _s_set_AutoDestroy);
            Utils.RegisterFunc(L, Utils.SETTER_IDX, "PreGenerateDummy", _s_set_PreGenerateDummy);
            Utils.RegisterFunc(L, Utils.SETTER_IDX, "TargetParentForRagdollDummy", _s_set_TargetParentForRagdollDummy);
            
			
			Utils.EndObjectRegister(type, L, translator, null, null,
			    null, null, null);

		    Utils.BeginClassRegister(type, L, __CreateInstance, 1, 0, 0);
			
			
            
			
			
			
			Utils.EndClassRegister(type, L, translator);
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int __CreateInstance(RealStatePtr L)
        {
            
			try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
				if(LuaAPI.lua_gettop(L) == 1)
				{
					
					var gen_ret = new FIMSpace.FProceduralAnimation.RagdollAnimator();
					translator.Push(L, gen_ret);
                    
					return 1;
				}
				
			}
			catch(System.Exception gen_e) {
				return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
			}
            return LuaAPI.luaL_error(L, "invalid arguments to FIMSpace.FProceduralAnimation.RagdollAnimator constructor!");
            
        }
        
		
        
		
        
        
        
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_User_GetRagdollBone(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                FIMSpace.FProceduralAnimation.RagdollAnimator gen_to_be_invoked = (FIMSpace.FProceduralAnimation.RagdollAnimator)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    UnityEngine.HumanBodyBones _humanoidBone;translator.Get(L, 2, out _humanoidBone);
                    
                        var gen_ret = gen_to_be_invoked.User_GetRagdollBone( _humanoidBone );
                        translator.Push(L, gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_User_GetRagdollBoneUsingCharacterBone(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                FIMSpace.FProceduralAnimation.RagdollAnimator gen_to_be_invoked = (FIMSpace.FProceduralAnimation.RagdollAnimator)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    UnityEngine.Transform _characterBone = (UnityEngine.Transform)translator.GetObject(L, 2, typeof(UnityEngine.Transform));
                    
                        var gen_ret = gen_to_be_invoked.User_GetRagdollBoneUsingCharacterBone( _characterBone );
                        translator.Push(L, gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_User_GetRagdollBoneUsingName(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                FIMSpace.FProceduralAnimation.RagdollAnimator gen_to_be_invoked = (FIMSpace.FProceduralAnimation.RagdollAnimator)translator.FastGetCSObj(L, 1);
            
            
			    int gen_param_count = LuaAPI.lua_gettop(L);
            
                if(gen_param_count == 3&& (LuaAPI.lua_isnil(L, 2) || LuaAPI.lua_type(L, 2) == LuaTypes.LUA_TSTRING)&& LuaTypes.LUA_TBOOLEAN == LuaAPI.lua_type(L, 3)) 
                {
                    string _boneName = LuaAPI.lua_tostring(L, 2);
                    bool _caseSensitive = LuaAPI.lua_toboolean(L, 3);
                    
                        var gen_ret = gen_to_be_invoked.User_GetRagdollBoneUsingName( _boneName, _caseSensitive );
                        translator.Push(L, gen_ret);
                    
                    
                    
                    return 1;
                }
                if(gen_param_count == 2&& (LuaAPI.lua_isnil(L, 2) || LuaAPI.lua_type(L, 2) == LuaTypes.LUA_TSTRING)) 
                {
                    string _boneName = LuaAPI.lua_tostring(L, 2);
                    
                        var gen_ret = gen_to_be_invoked.User_GetRagdollBoneUsingName( _boneName );
                        translator.Push(L, gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
            return LuaAPI.luaL_error(L, "invalid arguments to FIMSpace.FProceduralAnimation.RagdollAnimator.User_GetRagdollBoneUsingName!");
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_User_GetRagdollBoneController(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                FIMSpace.FProceduralAnimation.RagdollAnimator gen_to_be_invoked = (FIMSpace.FProceduralAnimation.RagdollAnimator)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    UnityEngine.HumanBodyBones _humanoidBone;translator.Get(L, 2, out _humanoidBone);
                    
                        var gen_ret = gen_to_be_invoked.User_GetRagdollBoneController( _humanoidBone );
                        translator.Push(L, gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_User_GetRagdollBoneControllerUsingCharacterBone(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                FIMSpace.FProceduralAnimation.RagdollAnimator gen_to_be_invoked = (FIMSpace.FProceduralAnimation.RagdollAnimator)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    UnityEngine.Transform _characterBone = (UnityEngine.Transform)translator.GetObject(L, 2, typeof(UnityEngine.Transform));
                    
                        var gen_ret = gen_to_be_invoked.User_GetRagdollBoneControllerUsingCharacterBone( _characterBone );
                        translator.Push(L, gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_User_GetRagdollBoneControllerUsingName(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                FIMSpace.FProceduralAnimation.RagdollAnimator gen_to_be_invoked = (FIMSpace.FProceduralAnimation.RagdollAnimator)translator.FastGetCSObj(L, 1);
            
            
			    int gen_param_count = LuaAPI.lua_gettop(L);
            
                if(gen_param_count == 3&& (LuaAPI.lua_isnil(L, 2) || LuaAPI.lua_type(L, 2) == LuaTypes.LUA_TSTRING)&& LuaTypes.LUA_TBOOLEAN == LuaAPI.lua_type(L, 3)) 
                {
                    string _boneName = LuaAPI.lua_tostring(L, 2);
                    bool _caseSensitive = LuaAPI.lua_toboolean(L, 3);
                    
                        var gen_ret = gen_to_be_invoked.User_GetRagdollBoneControllerUsingName( _boneName, _caseSensitive );
                        translator.Push(L, gen_ret);
                    
                    
                    
                    return 1;
                }
                if(gen_param_count == 2&& (LuaAPI.lua_isnil(L, 2) || LuaAPI.lua_type(L, 2) == LuaTypes.LUA_TSTRING)) 
                {
                    string _boneName = LuaAPI.lua_tostring(L, 2);
                    
                        var gen_ret = gen_to_be_invoked.User_GetRagdollBoneControllerUsingName( _boneName );
                        translator.Push(L, gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
            return LuaAPI.luaL_error(L, "invalid arguments to FIMSpace.FProceduralAnimation.RagdollAnimator.User_GetRagdollBoneControllerUsingName!");
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_User_TryGetCustomLimbChainsBone(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                FIMSpace.FProceduralAnimation.RagdollAnimator gen_to_be_invoked = (FIMSpace.FProceduralAnimation.RagdollAnimator)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    UnityEngine.HumanBodyBones _humanoidBone;translator.Get(L, 2, out _humanoidBone);
                    
                        var gen_ret = gen_to_be_invoked.User_TryGetCustomLimbChainsBone( _humanoidBone );
                        translator.Push(L, gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_User_GetCustomLimbChainUsingName(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                FIMSpace.FProceduralAnimation.RagdollAnimator gen_to_be_invoked = (FIMSpace.FProceduralAnimation.RagdollAnimator)translator.FastGetCSObj(L, 1);
            
            
			    int gen_param_count = LuaAPI.lua_gettop(L);
            
                if(gen_param_count == 3&& (LuaAPI.lua_isnil(L, 2) || LuaAPI.lua_type(L, 2) == LuaTypes.LUA_TSTRING)&& LuaTypes.LUA_TBOOLEAN == LuaAPI.lua_type(L, 3)) 
                {
                    string _chainName = LuaAPI.lua_tostring(L, 2);
                    bool _caseSensitive = LuaAPI.lua_toboolean(L, 3);
                    
                        var gen_ret = gen_to_be_invoked.User_GetCustomLimbChainUsingName( _chainName, _caseSensitive );
                        translator.Push(L, gen_ret);
                    
                    
                    
                    return 1;
                }
                if(gen_param_count == 2&& (LuaAPI.lua_isnil(L, 2) || LuaAPI.lua_type(L, 2) == LuaTypes.LUA_TSTRING)) 
                {
                    string _chainName = LuaAPI.lua_tostring(L, 2);
                    
                        var gen_ret = gen_to_be_invoked.User_GetCustomLimbChainUsingName( _chainName );
                        translator.Push(L, gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
            return LuaAPI.luaL_error(L, "invalid arguments to FIMSpace.FProceduralAnimation.RagdollAnimator.User_GetCustomLimbChainUsingName!");
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_User_GetCustomLimbChainBoneSetup(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                FIMSpace.FProceduralAnimation.RagdollAnimator gen_to_be_invoked = (FIMSpace.FProceduralAnimation.RagdollAnimator)translator.FastGetCSObj(L, 1);
            
            
			    int gen_param_count = LuaAPI.lua_gettop(L);
            
                if(gen_param_count == 4&& (LuaAPI.lua_isnil(L, 2) || LuaAPI.lua_type(L, 2) == LuaTypes.LUA_TSTRING)&& LuaTypes.LUA_TNUMBER == LuaAPI.lua_type(L, 3)&& LuaTypes.LUA_TBOOLEAN == LuaAPI.lua_type(L, 4)) 
                {
                    string _chainName = LuaAPI.lua_tostring(L, 2);
                    int _chainBoneIndex = LuaAPI.xlua_tointeger(L, 3);
                    bool _caseSensitive = LuaAPI.lua_toboolean(L, 4);
                    
                        var gen_ret = gen_to_be_invoked.User_GetCustomLimbChainBoneSetup( _chainName, _chainBoneIndex, _caseSensitive );
                        translator.Push(L, gen_ret);
                    
                    
                    
                    return 1;
                }
                if(gen_param_count == 3&& (LuaAPI.lua_isnil(L, 2) || LuaAPI.lua_type(L, 2) == LuaTypes.LUA_TSTRING)&& LuaTypes.LUA_TNUMBER == LuaAPI.lua_type(L, 3)) 
                {
                    string _chainName = LuaAPI.lua_tostring(L, 2);
                    int _chainBoneIndex = LuaAPI.xlua_tointeger(L, 3);
                    
                        var gen_ret = gen_to_be_invoked.User_GetCustomLimbChainBoneSetup( _chainName, _chainBoneIndex );
                        translator.Push(L, gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
            return LuaAPI.luaL_error(L, "invalid arguments to FIMSpace.FProceduralAnimation.RagdollAnimator.User_GetCustomLimbChainBoneSetup!");
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_User_GetCustomLimbChainBoneController(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                FIMSpace.FProceduralAnimation.RagdollAnimator gen_to_be_invoked = (FIMSpace.FProceduralAnimation.RagdollAnimator)translator.FastGetCSObj(L, 1);
            
            
			    int gen_param_count = LuaAPI.lua_gettop(L);
            
                if(gen_param_count == 4&& (LuaAPI.lua_isnil(L, 2) || LuaAPI.lua_type(L, 2) == LuaTypes.LUA_TSTRING)&& LuaTypes.LUA_TNUMBER == LuaAPI.lua_type(L, 3)&& LuaTypes.LUA_TBOOLEAN == LuaAPI.lua_type(L, 4)) 
                {
                    string _chainName = LuaAPI.lua_tostring(L, 2);
                    int _chainBoneIndex = LuaAPI.xlua_tointeger(L, 3);
                    bool _caseSensitive = LuaAPI.lua_toboolean(L, 4);
                    
                        var gen_ret = gen_to_be_invoked.User_GetCustomLimbChainBoneController( _chainName, _chainBoneIndex, _caseSensitive );
                        translator.Push(L, gen_ret);
                    
                    
                    
                    return 1;
                }
                if(gen_param_count == 3&& (LuaAPI.lua_isnil(L, 2) || LuaAPI.lua_type(L, 2) == LuaTypes.LUA_TSTRING)&& LuaTypes.LUA_TNUMBER == LuaAPI.lua_type(L, 3)) 
                {
                    string _chainName = LuaAPI.lua_tostring(L, 2);
                    int _chainBoneIndex = LuaAPI.xlua_tointeger(L, 3);
                    
                        var gen_ret = gen_to_be_invoked.User_GetCustomLimbChainBoneController( _chainName, _chainBoneIndex );
                        translator.Push(L, gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
            return LuaAPI.luaL_error(L, "invalid arguments to FIMSpace.FProceduralAnimation.RagdollAnimator.User_GetCustomLimbChainBoneController!");
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_User_GetCustomLimbChainBone(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                FIMSpace.FProceduralAnimation.RagdollAnimator gen_to_be_invoked = (FIMSpace.FProceduralAnimation.RagdollAnimator)translator.FastGetCSObj(L, 1);
            
            
			    int gen_param_count = LuaAPI.lua_gettop(L);
            
                if(gen_param_count == 4&& (LuaAPI.lua_isnil(L, 2) || LuaAPI.lua_type(L, 2) == LuaTypes.LUA_TSTRING)&& LuaTypes.LUA_TNUMBER == LuaAPI.lua_type(L, 3)&& LuaTypes.LUA_TBOOLEAN == LuaAPI.lua_type(L, 4)) 
                {
                    string _chainName = LuaAPI.lua_tostring(L, 2);
                    int _chainBoneIndex = LuaAPI.xlua_tointeger(L, 3);
                    bool _caseSensitive = LuaAPI.lua_toboolean(L, 4);
                    
                        var gen_ret = gen_to_be_invoked.User_GetCustomLimbChainBone( _chainName, _chainBoneIndex, _caseSensitive );
                        translator.Push(L, gen_ret);
                    
                    
                    
                    return 1;
                }
                if(gen_param_count == 3&& (LuaAPI.lua_isnil(L, 2) || LuaAPI.lua_type(L, 2) == LuaTypes.LUA_TSTRING)&& LuaTypes.LUA_TNUMBER == LuaAPI.lua_type(L, 3)) 
                {
                    string _chainName = LuaAPI.lua_tostring(L, 2);
                    int _chainBoneIndex = LuaAPI.xlua_tointeger(L, 3);
                    
                        var gen_ret = gen_to_be_invoked.User_GetCustomLimbChainBone( _chainName, _chainBoneIndex );
                        translator.Push(L, gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
            return LuaAPI.luaL_error(L, "invalid arguments to FIMSpace.FProceduralAnimation.RagdollAnimator.User_GetCustomLimbChainBone!");
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_User_SetLimbImpact(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                FIMSpace.FProceduralAnimation.RagdollAnimator gen_to_be_invoked = (FIMSpace.FProceduralAnimation.RagdollAnimator)translator.FastGetCSObj(L, 1);
            
            
			    int gen_param_count = LuaAPI.lua_gettop(L);
            
                if(gen_param_count == 5&& translator.Assignable<UnityEngine.Rigidbody>(L, 2)&& translator.Assignable<UnityEngine.Vector3>(L, 3)&& LuaTypes.LUA_TNUMBER == LuaAPI.lua_type(L, 4)&& translator.Assignable<UnityEngine.ForceMode>(L, 5)) 
                {
                    UnityEngine.Rigidbody _limb = (UnityEngine.Rigidbody)translator.GetObject(L, 2, typeof(UnityEngine.Rigidbody));
                    UnityEngine.Vector3 _powerDirection;translator.Get(L, 3, out _powerDirection);
                    float _duration = (float)LuaAPI.lua_tonumber(L, 4);
                    UnityEngine.ForceMode _forceMode;translator.Get(L, 5, out _forceMode);
                    
                    gen_to_be_invoked.User_SetLimbImpact( _limb, _powerDirection, _duration, _forceMode );
                    
                    
                    
                    return 0;
                }
                if(gen_param_count == 4&& translator.Assignable<UnityEngine.Rigidbody>(L, 2)&& translator.Assignable<UnityEngine.Vector3>(L, 3)&& LuaTypes.LUA_TNUMBER == LuaAPI.lua_type(L, 4)) 
                {
                    UnityEngine.Rigidbody _limb = (UnityEngine.Rigidbody)translator.GetObject(L, 2, typeof(UnityEngine.Rigidbody));
                    UnityEngine.Vector3 _powerDirection;translator.Get(L, 3, out _powerDirection);
                    float _duration = (float)LuaAPI.lua_tonumber(L, 4);
                    
                    gen_to_be_invoked.User_SetLimbImpact( _limb, _powerDirection, _duration );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
            return LuaAPI.luaL_error(L, "invalid arguments to FIMSpace.FProceduralAnimation.RagdollAnimator.User_SetLimbImpact!");
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_User_SetAllLimbsVelocity(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                FIMSpace.FProceduralAnimation.RagdollAnimator gen_to_be_invoked = (FIMSpace.FProceduralAnimation.RagdollAnimator)translator.FastGetCSObj(L, 1);
            
            
			    int gen_param_count = LuaAPI.lua_gettop(L);
            
                if(gen_param_count == 4&& translator.Assignable<UnityEngine.Vector3>(L, 2)&& LuaTypes.LUA_TNUMBER == LuaAPI.lua_type(L, 3)&& LuaTypes.LUA_TBOOLEAN == LuaAPI.lua_type(L, 4)) 
                {
                    UnityEngine.Vector3 _velocity;translator.Get(L, 2, out _velocity);
                    float _delay = (float)LuaAPI.lua_tonumber(L, 3);
                    bool _waitExtraFixedStep = LuaAPI.lua_toboolean(L, 4);
                    
                    gen_to_be_invoked.User_SetAllLimbsVelocity( _velocity, _delay, _waitExtraFixedStep );
                    
                    
                    
                    return 0;
                }
                if(gen_param_count == 3&& translator.Assignable<UnityEngine.Vector3>(L, 2)&& LuaTypes.LUA_TNUMBER == LuaAPI.lua_type(L, 3)) 
                {
                    UnityEngine.Vector3 _velocity;translator.Get(L, 2, out _velocity);
                    float _delay = (float)LuaAPI.lua_tonumber(L, 3);
                    
                    gen_to_be_invoked.User_SetAllLimbsVelocity( _velocity, _delay );
                    
                    
                    
                    return 0;
                }
                if(gen_param_count == 2&& translator.Assignable<UnityEngine.Vector3>(L, 2)) 
                {
                    UnityEngine.Vector3 _velocity;translator.Get(L, 2, out _velocity);
                    
                    gen_to_be_invoked.User_SetAllLimbsVelocity( _velocity );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
            return LuaAPI.luaL_error(L, "invalid arguments to FIMSpace.FProceduralAnimation.RagdollAnimator.User_SetAllLimbsVelocity!");
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_User_SetFallAndLimbImpact(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                FIMSpace.FProceduralAnimation.RagdollAnimator gen_to_be_invoked = (FIMSpace.FProceduralAnimation.RagdollAnimator)translator.FastGetCSObj(L, 1);
            
            
			    int gen_param_count = LuaAPI.lua_gettop(L);
            
                if(gen_param_count == 6&& translator.Assignable<System.Nullable<float>>(L, 2)&& translator.Assignable<UnityEngine.Rigidbody>(L, 3)&& translator.Assignable<UnityEngine.Vector3>(L, 4)&& LuaTypes.LUA_TNUMBER == LuaAPI.lua_type(L, 5)&& translator.Assignable<UnityEngine.ForceMode>(L, 6)) 
                {
                    System.Nullable<float> _fadeMusclesTo;translator.Get(L, 2, out _fadeMusclesTo);
                    UnityEngine.Rigidbody _limb = (UnityEngine.Rigidbody)translator.GetObject(L, 3, typeof(UnityEngine.Rigidbody));
                    UnityEngine.Vector3 _powerDirection;translator.Get(L, 4, out _powerDirection);
                    float _duration = (float)LuaAPI.lua_tonumber(L, 5);
                    UnityEngine.ForceMode _forceMode;translator.Get(L, 6, out _forceMode);
                    
                    gen_to_be_invoked.User_SetFallAndLimbImpact( _fadeMusclesTo, _limb, _powerDirection, _duration, _forceMode );
                    
                    
                    
                    return 0;
                }
                if(gen_param_count == 5&& translator.Assignable<System.Nullable<float>>(L, 2)&& translator.Assignable<UnityEngine.Rigidbody>(L, 3)&& translator.Assignable<UnityEngine.Vector3>(L, 4)&& LuaTypes.LUA_TNUMBER == LuaAPI.lua_type(L, 5)) 
                {
                    System.Nullable<float> _fadeMusclesTo;translator.Get(L, 2, out _fadeMusclesTo);
                    UnityEngine.Rigidbody _limb = (UnityEngine.Rigidbody)translator.GetObject(L, 3, typeof(UnityEngine.Rigidbody));
                    UnityEngine.Vector3 _powerDirection;translator.Get(L, 4, out _powerDirection);
                    float _duration = (float)LuaAPI.lua_tonumber(L, 5);
                    
                    gen_to_be_invoked.User_SetFallAndLimbImpact( _fadeMusclesTo, _limb, _powerDirection, _duration );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
            return LuaAPI.luaL_error(L, "invalid arguments to FIMSpace.FProceduralAnimation.RagdollAnimator.User_SetFallAndLimbImpact!");
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_User_SetPhysicalImpactAll(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                FIMSpace.FProceduralAnimation.RagdollAnimator gen_to_be_invoked = (FIMSpace.FProceduralAnimation.RagdollAnimator)translator.FastGetCSObj(L, 1);
            
            
			    int gen_param_count = LuaAPI.lua_gettop(L);
            
                if(gen_param_count == 4&& translator.Assignable<UnityEngine.Vector3>(L, 2)&& LuaTypes.LUA_TNUMBER == LuaAPI.lua_type(L, 3)&& translator.Assignable<UnityEngine.ForceMode>(L, 4)) 
                {
                    UnityEngine.Vector3 _powerDirection;translator.Get(L, 2, out _powerDirection);
                    float _duration = (float)LuaAPI.lua_tonumber(L, 3);
                    UnityEngine.ForceMode _forceMode;translator.Get(L, 4, out _forceMode);
                    
                    gen_to_be_invoked.User_SetPhysicalImpactAll( _powerDirection, _duration, _forceMode );
                    
                    
                    
                    return 0;
                }
                if(gen_param_count == 3&& translator.Assignable<UnityEngine.Vector3>(L, 2)&& LuaTypes.LUA_TNUMBER == LuaAPI.lua_type(L, 3)) 
                {
                    UnityEngine.Vector3 _powerDirection;translator.Get(L, 2, out _powerDirection);
                    float _duration = (float)LuaAPI.lua_tonumber(L, 3);
                    
                    gen_to_be_invoked.User_SetPhysicalImpactAll( _powerDirection, _duration );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
            return LuaAPI.luaL_error(L, "invalid arguments to FIMSpace.FProceduralAnimation.RagdollAnimator.User_SetPhysicalImpactAll!");
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_User_SetFallAndPhysicalImpactAll(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                FIMSpace.FProceduralAnimation.RagdollAnimator gen_to_be_invoked = (FIMSpace.FProceduralAnimation.RagdollAnimator)translator.FastGetCSObj(L, 1);
            
            
			    int gen_param_count = LuaAPI.lua_gettop(L);
            
                if(gen_param_count == 5&& translator.Assignable<System.Nullable<float>>(L, 2)&& translator.Assignable<UnityEngine.Vector3>(L, 3)&& LuaTypes.LUA_TNUMBER == LuaAPI.lua_type(L, 4)&& translator.Assignable<UnityEngine.ForceMode>(L, 5)) 
                {
                    System.Nullable<float> _fadeMusclesTo;translator.Get(L, 2, out _fadeMusclesTo);
                    UnityEngine.Vector3 _powerDirection;translator.Get(L, 3, out _powerDirection);
                    float _duration = (float)LuaAPI.lua_tonumber(L, 4);
                    UnityEngine.ForceMode _forceMode;translator.Get(L, 5, out _forceMode);
                    
                    gen_to_be_invoked.User_SetFallAndPhysicalImpactAll( _fadeMusclesTo, _powerDirection, _duration, _forceMode );
                    
                    
                    
                    return 0;
                }
                if(gen_param_count == 4&& translator.Assignable<System.Nullable<float>>(L, 2)&& translator.Assignable<UnityEngine.Vector3>(L, 3)&& LuaTypes.LUA_TNUMBER == LuaAPI.lua_type(L, 4)) 
                {
                    System.Nullable<float> _fadeMusclesTo;translator.Get(L, 2, out _fadeMusclesTo);
                    UnityEngine.Vector3 _powerDirection;translator.Get(L, 3, out _powerDirection);
                    float _duration = (float)LuaAPI.lua_tonumber(L, 4);
                    
                    gen_to_be_invoked.User_SetFallAndPhysicalImpactAll( _fadeMusclesTo, _powerDirection, _duration );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
            return LuaAPI.luaL_error(L, "invalid arguments to FIMSpace.FProceduralAnimation.RagdollAnimator.User_SetFallAndPhysicalImpactAll!");
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_User_SetPhysicalTorque(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                FIMSpace.FProceduralAnimation.RagdollAnimator gen_to_be_invoked = (FIMSpace.FProceduralAnimation.RagdollAnimator)translator.FastGetCSObj(L, 1);
            
            
			    int gen_param_count = LuaAPI.lua_gettop(L);
            
                if(gen_param_count == 6&& translator.Assignable<UnityEngine.Vector3>(L, 2)&& LuaTypes.LUA_TNUMBER == LuaAPI.lua_type(L, 3)&& LuaTypes.LUA_TBOOLEAN == LuaAPI.lua_type(L, 4)&& translator.Assignable<UnityEngine.ForceMode>(L, 5)&& LuaTypes.LUA_TBOOLEAN == LuaAPI.lua_type(L, 6)) 
                {
                    UnityEngine.Vector3 _rotationPower;translator.Get(L, 2, out _rotationPower);
                    float _duration = (float)LuaAPI.lua_tonumber(L, 3);
                    bool _relativeSpace = LuaAPI.lua_toboolean(L, 4);
                    UnityEngine.ForceMode _forceMode;translator.Get(L, 5, out _forceMode);
                    bool _deltaScale = LuaAPI.lua_toboolean(L, 6);
                    
                    gen_to_be_invoked.User_SetPhysicalTorque( _rotationPower, _duration, _relativeSpace, _forceMode, _deltaScale );
                    
                    
                    
                    return 0;
                }
                if(gen_param_count == 5&& translator.Assignable<UnityEngine.Vector3>(L, 2)&& LuaTypes.LUA_TNUMBER == LuaAPI.lua_type(L, 3)&& LuaTypes.LUA_TBOOLEAN == LuaAPI.lua_type(L, 4)&& translator.Assignable<UnityEngine.ForceMode>(L, 5)) 
                {
                    UnityEngine.Vector3 _rotationPower;translator.Get(L, 2, out _rotationPower);
                    float _duration = (float)LuaAPI.lua_tonumber(L, 3);
                    bool _relativeSpace = LuaAPI.lua_toboolean(L, 4);
                    UnityEngine.ForceMode _forceMode;translator.Get(L, 5, out _forceMode);
                    
                    gen_to_be_invoked.User_SetPhysicalTorque( _rotationPower, _duration, _relativeSpace, _forceMode );
                    
                    
                    
                    return 0;
                }
                if(gen_param_count == 4&& translator.Assignable<UnityEngine.Vector3>(L, 2)&& LuaTypes.LUA_TNUMBER == LuaAPI.lua_type(L, 3)&& LuaTypes.LUA_TBOOLEAN == LuaAPI.lua_type(L, 4)) 
                {
                    UnityEngine.Vector3 _rotationPower;translator.Get(L, 2, out _rotationPower);
                    float _duration = (float)LuaAPI.lua_tonumber(L, 3);
                    bool _relativeSpace = LuaAPI.lua_toboolean(L, 4);
                    
                    gen_to_be_invoked.User_SetPhysicalTorque( _rotationPower, _duration, _relativeSpace );
                    
                    
                    
                    return 0;
                }
                if(gen_param_count == 3&& translator.Assignable<UnityEngine.Vector3>(L, 2)&& LuaTypes.LUA_TNUMBER == LuaAPI.lua_type(L, 3)) 
                {
                    UnityEngine.Vector3 _rotationPower;translator.Get(L, 2, out _rotationPower);
                    float _duration = (float)LuaAPI.lua_tonumber(L, 3);
                    
                    gen_to_be_invoked.User_SetPhysicalTorque( _rotationPower, _duration );
                    
                    
                    
                    return 0;
                }
                if(gen_param_count == 7&& translator.Assignable<UnityEngine.Rigidbody>(L, 2)&& translator.Assignable<UnityEngine.Vector3>(L, 3)&& LuaTypes.LUA_TNUMBER == LuaAPI.lua_type(L, 4)&& LuaTypes.LUA_TBOOLEAN == LuaAPI.lua_type(L, 5)&& translator.Assignable<UnityEngine.ForceMode>(L, 6)&& LuaTypes.LUA_TBOOLEAN == LuaAPI.lua_type(L, 7)) 
                {
                    UnityEngine.Rigidbody _limb = (UnityEngine.Rigidbody)translator.GetObject(L, 2, typeof(UnityEngine.Rigidbody));
                    UnityEngine.Vector3 _rotationPower;translator.Get(L, 3, out _rotationPower);
                    float _duration = (float)LuaAPI.lua_tonumber(L, 4);
                    bool _relativeSpace = LuaAPI.lua_toboolean(L, 5);
                    UnityEngine.ForceMode _forceMode;translator.Get(L, 6, out _forceMode);
                    bool _deltaScale = LuaAPI.lua_toboolean(L, 7);
                    
                    gen_to_be_invoked.User_SetPhysicalTorque( _limb, _rotationPower, _duration, _relativeSpace, _forceMode, _deltaScale );
                    
                    
                    
                    return 0;
                }
                if(gen_param_count == 6&& translator.Assignable<UnityEngine.Rigidbody>(L, 2)&& translator.Assignable<UnityEngine.Vector3>(L, 3)&& LuaTypes.LUA_TNUMBER == LuaAPI.lua_type(L, 4)&& LuaTypes.LUA_TBOOLEAN == LuaAPI.lua_type(L, 5)&& translator.Assignable<UnityEngine.ForceMode>(L, 6)) 
                {
                    UnityEngine.Rigidbody _limb = (UnityEngine.Rigidbody)translator.GetObject(L, 2, typeof(UnityEngine.Rigidbody));
                    UnityEngine.Vector3 _rotationPower;translator.Get(L, 3, out _rotationPower);
                    float _duration = (float)LuaAPI.lua_tonumber(L, 4);
                    bool _relativeSpace = LuaAPI.lua_toboolean(L, 5);
                    UnityEngine.ForceMode _forceMode;translator.Get(L, 6, out _forceMode);
                    
                    gen_to_be_invoked.User_SetPhysicalTorque( _limb, _rotationPower, _duration, _relativeSpace, _forceMode );
                    
                    
                    
                    return 0;
                }
                if(gen_param_count == 5&& translator.Assignable<UnityEngine.Rigidbody>(L, 2)&& translator.Assignable<UnityEngine.Vector3>(L, 3)&& LuaTypes.LUA_TNUMBER == LuaAPI.lua_type(L, 4)&& LuaTypes.LUA_TBOOLEAN == LuaAPI.lua_type(L, 5)) 
                {
                    UnityEngine.Rigidbody _limb = (UnityEngine.Rigidbody)translator.GetObject(L, 2, typeof(UnityEngine.Rigidbody));
                    UnityEngine.Vector3 _rotationPower;translator.Get(L, 3, out _rotationPower);
                    float _duration = (float)LuaAPI.lua_tonumber(L, 4);
                    bool _relativeSpace = LuaAPI.lua_toboolean(L, 5);
                    
                    gen_to_be_invoked.User_SetPhysicalTorque( _limb, _rotationPower, _duration, _relativeSpace );
                    
                    
                    
                    return 0;
                }
                if(gen_param_count == 4&& translator.Assignable<UnityEngine.Rigidbody>(L, 2)&& translator.Assignable<UnityEngine.Vector3>(L, 3)&& LuaTypes.LUA_TNUMBER == LuaAPI.lua_type(L, 4)) 
                {
                    UnityEngine.Rigidbody _limb = (UnityEngine.Rigidbody)translator.GetObject(L, 2, typeof(UnityEngine.Rigidbody));
                    UnityEngine.Vector3 _rotationPower;translator.Get(L, 3, out _rotationPower);
                    float _duration = (float)LuaAPI.lua_tonumber(L, 4);
                    
                    gen_to_be_invoked.User_SetPhysicalTorque( _limb, _rotationPower, _duration );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
            return LuaAPI.luaL_error(L, "invalid arguments to FIMSpace.FProceduralAnimation.RagdollAnimator.User_SetPhysicalTorque!");
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_User_SetPhysicalTorqueFromLocal(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                FIMSpace.FProceduralAnimation.RagdollAnimator gen_to_be_invoked = (FIMSpace.FProceduralAnimation.RagdollAnimator)translator.FastGetCSObj(L, 1);
            
            
			    int gen_param_count = LuaAPI.lua_gettop(L);
            
                if(gen_param_count == 5&& translator.Assignable<UnityEngine.Vector3>(L, 2)&& translator.Assignable<UnityEngine.Transform>(L, 3)&& LuaTypes.LUA_TNUMBER == LuaAPI.lua_type(L, 4)&& translator.Assignable<System.Nullable<UnityEngine.Vector3>>(L, 5)) 
                {
                    UnityEngine.Vector3 _localEuler;translator.Get(L, 2, out _localEuler);
                    UnityEngine.Transform _localOf = (UnityEngine.Transform)translator.GetObject(L, 3, typeof(UnityEngine.Transform));
                    float _duration = (float)LuaAPI.lua_tonumber(L, 4);
                    System.Nullable<UnityEngine.Vector3> _power;translator.Get(L, 5, out _power);
                    
                    gen_to_be_invoked.User_SetPhysicalTorqueFromLocal( _localEuler, _localOf, _duration, _power );
                    
                    
                    
                    return 0;
                }
                if(gen_param_count == 4&& translator.Assignable<UnityEngine.Vector3>(L, 2)&& translator.Assignable<UnityEngine.Transform>(L, 3)&& LuaTypes.LUA_TNUMBER == LuaAPI.lua_type(L, 4)) 
                {
                    UnityEngine.Vector3 _localEuler;translator.Get(L, 2, out _localEuler);
                    UnityEngine.Transform _localOf = (UnityEngine.Transform)translator.GetObject(L, 3, typeof(UnityEngine.Transform));
                    float _duration = (float)LuaAPI.lua_tonumber(L, 4);
                    
                    gen_to_be_invoked.User_SetPhysicalTorqueFromLocal( _localEuler, _localOf, _duration );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
            return LuaAPI.luaL_error(L, "invalid arguments to FIMSpace.FProceduralAnimation.RagdollAnimator.User_SetPhysicalTorqueFromLocal!");
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_User_SetVelocityAll(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                FIMSpace.FProceduralAnimation.RagdollAnimator gen_to_be_invoked = (FIMSpace.FProceduralAnimation.RagdollAnimator)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    UnityEngine.Vector3 _newVelocity;translator.Get(L, 2, out _newVelocity);
                    
                    gen_to_be_invoked.User_SetVelocityAll( _newVelocity );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_User_SetHumanoidLimbImpact(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                FIMSpace.FProceduralAnimation.RagdollAnimator gen_to_be_invoked = (FIMSpace.FProceduralAnimation.RagdollAnimator)translator.FastGetCSObj(L, 1);
            
            
			    int gen_param_count = LuaAPI.lua_gettop(L);
            
                if(gen_param_count == 5&& translator.Assignable<UnityEngine.HumanBodyBones>(L, 2)&& translator.Assignable<UnityEngine.Vector3>(L, 3)&& LuaTypes.LUA_TNUMBER == LuaAPI.lua_type(L, 4)&& translator.Assignable<UnityEngine.ForceMode>(L, 5)) 
                {
                    UnityEngine.HumanBodyBones _limb;translator.Get(L, 2, out _limb);
                    UnityEngine.Vector3 _powerDirection;translator.Get(L, 3, out _powerDirection);
                    float _duration = (float)LuaAPI.lua_tonumber(L, 4);
                    UnityEngine.ForceMode _forceMode;translator.Get(L, 5, out _forceMode);
                    
                    gen_to_be_invoked.User_SetHumanoidLimbImpact( _limb, _powerDirection, _duration, _forceMode );
                    
                    
                    
                    return 0;
                }
                if(gen_param_count == 4&& translator.Assignable<UnityEngine.HumanBodyBones>(L, 2)&& translator.Assignable<UnityEngine.Vector3>(L, 3)&& LuaTypes.LUA_TNUMBER == LuaAPI.lua_type(L, 4)) 
                {
                    UnityEngine.HumanBodyBones _limb;translator.Get(L, 2, out _limb);
                    UnityEngine.Vector3 _powerDirection;translator.Get(L, 3, out _powerDirection);
                    float _duration = (float)LuaAPI.lua_tonumber(L, 4);
                    
                    gen_to_be_invoked.User_SetHumanoidLimbImpact( _limb, _powerDirection, _duration );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
            return LuaAPI.luaL_error(L, "invalid arguments to FIMSpace.FProceduralAnimation.RagdollAnimator.User_SetHumanoidLimbImpact!");
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_User_ChangeReposeAndRestore(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                FIMSpace.FProceduralAnimation.RagdollAnimator gen_to_be_invoked = (FIMSpace.FProceduralAnimation.RagdollAnimator)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    FIMSpace.FProceduralAnimation.RagdollProcessor.EBaseTransformRepose _set;translator.Get(L, 2, out _set);
                    float _restoreAfter = (float)LuaAPI.lua_tonumber(L, 3);
                    
                    gen_to_be_invoked.User_ChangeReposeAndRestore( _set, _restoreAfter );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_User_ChangeBlendOnCollisionAndRestore(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                FIMSpace.FProceduralAnimation.RagdollAnimator gen_to_be_invoked = (FIMSpace.FProceduralAnimation.RagdollAnimator)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    bool _temporaryBlend = LuaAPI.lua_toboolean(L, 2);
                    float _delay = (float)LuaAPI.lua_tonumber(L, 3);
                    
                    gen_to_be_invoked.User_ChangeBlendOnCollisionAndRestore( _temporaryBlend, _delay );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_User_SwitchFreeFallRagdoll(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                FIMSpace.FProceduralAnimation.RagdollAnimator gen_to_be_invoked = (FIMSpace.FProceduralAnimation.RagdollAnimator)translator.FastGetCSObj(L, 1);
            
            
			    int gen_param_count = LuaAPI.lua_gettop(L);
            
                if(gen_param_count == 3&& LuaTypes.LUA_TBOOLEAN == LuaAPI.lua_type(L, 2)&& LuaTypes.LUA_TNUMBER == LuaAPI.lua_type(L, 3)) 
                {
                    bool _freeFall = LuaAPI.lua_toboolean(L, 2);
                    float _delay = (float)LuaAPI.lua_tonumber(L, 3);
                    
                    gen_to_be_invoked.User_SwitchFreeFallRagdoll( _freeFall, _delay );
                    
                    
                    
                    return 0;
                }
                if(gen_param_count == 2&& LuaTypes.LUA_TBOOLEAN == LuaAPI.lua_type(L, 2)) 
                {
                    bool _freeFall = LuaAPI.lua_toboolean(L, 2);
                    
                    gen_to_be_invoked.User_SwitchFreeFallRagdoll( _freeFall );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
            return LuaAPI.luaL_error(L, "invalid arguments to FIMSpace.FProceduralAnimation.RagdollAnimator.User_SwitchFreeFallRagdoll!");
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_User_TransitionToNonFreeFallRagdoll(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                FIMSpace.FProceduralAnimation.RagdollAnimator gen_to_be_invoked = (FIMSpace.FProceduralAnimation.RagdollAnimator)translator.FastGetCSObj(L, 1);
            
            
			    int gen_param_count = LuaAPI.lua_gettop(L);
            
                if(gen_param_count == 3&& LuaTypes.LUA_TNUMBER == LuaAPI.lua_type(L, 2)&& LuaTypes.LUA_TNUMBER == LuaAPI.lua_type(L, 3)) 
                {
                    float _duration = (float)LuaAPI.lua_tonumber(L, 2);
                    float _delay = (float)LuaAPI.lua_tonumber(L, 3);
                    
                    gen_to_be_invoked.User_TransitionToNonFreeFallRagdoll( _duration, _delay );
                    
                    
                    
                    return 0;
                }
                if(gen_param_count == 2&& LuaTypes.LUA_TNUMBER == LuaAPI.lua_type(L, 2)) 
                {
                    float _duration = (float)LuaAPI.lua_tonumber(L, 2);
                    
                    gen_to_be_invoked.User_TransitionToNonFreeFallRagdoll( _duration );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
            return LuaAPI.luaL_error(L, "invalid arguments to FIMSpace.FProceduralAnimation.RagdollAnimator.User_TransitionToNonFreeFallRagdoll!");
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_User_EnableFreeRagdoll(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                FIMSpace.FProceduralAnimation.RagdollAnimator gen_to_be_invoked = (FIMSpace.FProceduralAnimation.RagdollAnimator)translator.FastGetCSObj(L, 1);
            
            
			    int gen_param_count = LuaAPI.lua_gettop(L);
            
                if(gen_param_count == 3&& LuaTypes.LUA_TNUMBER == LuaAPI.lua_type(L, 2)&& LuaTypes.LUA_TNUMBER == LuaAPI.lua_type(L, 3)) 
                {
                    float _blend = (float)LuaAPI.lua_tonumber(L, 2);
                    float _transitionDuration = (float)LuaAPI.lua_tonumber(L, 3);
                    
                    gen_to_be_invoked.User_EnableFreeRagdoll( _blend, _transitionDuration );
                    
                    
                    
                    return 0;
                }
                if(gen_param_count == 2&& LuaTypes.LUA_TNUMBER == LuaAPI.lua_type(L, 2)) 
                {
                    float _blend = (float)LuaAPI.lua_tonumber(L, 2);
                    
                    gen_to_be_invoked.User_EnableFreeRagdoll( _blend );
                    
                    
                    
                    return 0;
                }
                if(gen_param_count == 1) 
                {
                    
                    gen_to_be_invoked.User_EnableFreeRagdoll(  );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
            return LuaAPI.luaL_error(L, "invalid arguments to FIMSpace.FProceduralAnimation.RagdollAnimator.User_EnableFreeRagdoll!");
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_User_SwitchAnimator(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                FIMSpace.FProceduralAnimation.RagdollAnimator gen_to_be_invoked = (FIMSpace.FProceduralAnimation.RagdollAnimator)translator.FastGetCSObj(L, 1);
            
            
			    int gen_param_count = LuaAPI.lua_gettop(L);
            
                if(gen_param_count == 4&& translator.Assignable<UnityEngine.Transform>(L, 2)&& LuaTypes.LUA_TBOOLEAN == LuaAPI.lua_type(L, 3)&& LuaTypes.LUA_TNUMBER == LuaAPI.lua_type(L, 4)) 
                {
                    UnityEngine.Transform _unityAnimator = (UnityEngine.Transform)translator.GetObject(L, 2, typeof(UnityEngine.Transform));
                    bool _enabled = LuaAPI.lua_toboolean(L, 3);
                    float _delay = (float)LuaAPI.lua_tonumber(L, 4);
                    
                    gen_to_be_invoked.User_SwitchAnimator( _unityAnimator, _enabled, _delay );
                    
                    
                    
                    return 0;
                }
                if(gen_param_count == 3&& translator.Assignable<UnityEngine.Transform>(L, 2)&& LuaTypes.LUA_TBOOLEAN == LuaAPI.lua_type(L, 3)) 
                {
                    UnityEngine.Transform _unityAnimator = (UnityEngine.Transform)translator.GetObject(L, 2, typeof(UnityEngine.Transform));
                    bool _enabled = LuaAPI.lua_toboolean(L, 3);
                    
                    gen_to_be_invoked.User_SwitchAnimator( _unityAnimator, _enabled );
                    
                    
                    
                    return 0;
                }
                if(gen_param_count == 2&& translator.Assignable<UnityEngine.Transform>(L, 2)) 
                {
                    UnityEngine.Transform _unityAnimator = (UnityEngine.Transform)translator.GetObject(L, 2, typeof(UnityEngine.Transform));
                    
                    gen_to_be_invoked.User_SwitchAnimator( _unityAnimator );
                    
                    
                    
                    return 0;
                }
                if(gen_param_count == 1) 
                {
                    
                    gen_to_be_invoked.User_SwitchAnimator(  );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
            return LuaAPI.luaL_error(L, "invalid arguments to FIMSpace.FProceduralAnimation.RagdollAnimator.User_SwitchAnimator!");
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_User_GetUpStack(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                FIMSpace.FProceduralAnimation.RagdollAnimator gen_to_be_invoked = (FIMSpace.FProceduralAnimation.RagdollAnimator)translator.FastGetCSObj(L, 1);
            
            
			    int gen_param_count = LuaAPI.lua_gettop(L);
            
                if(gen_param_count == 6&& translator.Assignable<FIMSpace.FProceduralAnimation.RagdollProcessor.EGetUpType>(L, 2)&& translator.Assignable<UnityEngine.LayerMask>(L, 3)&& LuaTypes.LUA_TNUMBER == LuaAPI.lua_type(L, 4)&& LuaTypes.LUA_TNUMBER == LuaAPI.lua_type(L, 5)&& LuaTypes.LUA_TNUMBER == LuaAPI.lua_type(L, 6)) 
                {
                    FIMSpace.FProceduralAnimation.RagdollProcessor.EGetUpType _getUpType;translator.Get(L, 2, out _getUpType);
                    UnityEngine.LayerMask _groundMask;translator.Get(L, 3, out _groundMask);
                    float _targetRagdollBlend = (float)LuaAPI.lua_tonumber(L, 4);
                    float _targetMusclesPower = (float)LuaAPI.lua_tonumber(L, 5);
                    float _duration = (float)LuaAPI.lua_tonumber(L, 6);
                    
                    gen_to_be_invoked.User_GetUpStack( _getUpType, _groundMask, _targetRagdollBlend, _targetMusclesPower, _duration );
                    
                    
                    
                    return 0;
                }
                if(gen_param_count == 5&& translator.Assignable<FIMSpace.FProceduralAnimation.RagdollProcessor.EGetUpType>(L, 2)&& translator.Assignable<UnityEngine.LayerMask>(L, 3)&& LuaTypes.LUA_TNUMBER == LuaAPI.lua_type(L, 4)&& LuaTypes.LUA_TNUMBER == LuaAPI.lua_type(L, 5)) 
                {
                    FIMSpace.FProceduralAnimation.RagdollProcessor.EGetUpType _getUpType;translator.Get(L, 2, out _getUpType);
                    UnityEngine.LayerMask _groundMask;translator.Get(L, 3, out _groundMask);
                    float _targetRagdollBlend = (float)LuaAPI.lua_tonumber(L, 4);
                    float _targetMusclesPower = (float)LuaAPI.lua_tonumber(L, 5);
                    
                    gen_to_be_invoked.User_GetUpStack( _getUpType, _groundMask, _targetRagdollBlend, _targetMusclesPower );
                    
                    
                    
                    return 0;
                }
                if(gen_param_count == 4&& translator.Assignable<FIMSpace.FProceduralAnimation.RagdollProcessor.EGetUpType>(L, 2)&& translator.Assignable<UnityEngine.LayerMask>(L, 3)&& LuaTypes.LUA_TNUMBER == LuaAPI.lua_type(L, 4)) 
                {
                    FIMSpace.FProceduralAnimation.RagdollProcessor.EGetUpType _getUpType;translator.Get(L, 2, out _getUpType);
                    UnityEngine.LayerMask _groundMask;translator.Get(L, 3, out _groundMask);
                    float _targetRagdollBlend = (float)LuaAPI.lua_tonumber(L, 4);
                    
                    gen_to_be_invoked.User_GetUpStack( _getUpType, _groundMask, _targetRagdollBlend );
                    
                    
                    
                    return 0;
                }
                if(gen_param_count == 3&& translator.Assignable<FIMSpace.FProceduralAnimation.RagdollProcessor.EGetUpType>(L, 2)&& translator.Assignable<UnityEngine.LayerMask>(L, 3)) 
                {
                    FIMSpace.FProceduralAnimation.RagdollProcessor.EGetUpType _getUpType;translator.Get(L, 2, out _getUpType);
                    UnityEngine.LayerMask _groundMask;translator.Get(L, 3, out _groundMask);
                    
                    gen_to_be_invoked.User_GetUpStack( _getUpType, _groundMask );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
            return LuaAPI.luaL_error(L, "invalid arguments to FIMSpace.FProceduralAnimation.RagdollAnimator.User_GetUpStack!");
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_User_GetUpStackV2(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                FIMSpace.FProceduralAnimation.RagdollAnimator gen_to_be_invoked = (FIMSpace.FProceduralAnimation.RagdollAnimator)translator.FastGetCSObj(L, 1);
            
            
			    int gen_param_count = LuaAPI.lua_gettop(L);
            
                if(gen_param_count == 5&& LuaTypes.LUA_TNUMBER == LuaAPI.lua_type(L, 2)&& LuaTypes.LUA_TNUMBER == LuaAPI.lua_type(L, 3)&& LuaTypes.LUA_TNUMBER == LuaAPI.lua_type(L, 4)&& translator.Assignable<System.Nullable<float>>(L, 5)) 
                {
                    float _targetRagdollBlend = (float)LuaAPI.lua_tonumber(L, 2);
                    float _targetMusclesPower = (float)LuaAPI.lua_tonumber(L, 3);
                    float _duration = (float)LuaAPI.lua_tonumber(L, 4);
                    System.Nullable<float> _enableBackCollisionAfter;translator.Get(L, 5, out _enableBackCollisionAfter);
                    
                    gen_to_be_invoked.User_GetUpStackV2( _targetRagdollBlend, _targetMusclesPower, _duration, _enableBackCollisionAfter );
                    
                    
                    
                    return 0;
                }
                if(gen_param_count == 4&& LuaTypes.LUA_TNUMBER == LuaAPI.lua_type(L, 2)&& LuaTypes.LUA_TNUMBER == LuaAPI.lua_type(L, 3)&& LuaTypes.LUA_TNUMBER == LuaAPI.lua_type(L, 4)) 
                {
                    float _targetRagdollBlend = (float)LuaAPI.lua_tonumber(L, 2);
                    float _targetMusclesPower = (float)LuaAPI.lua_tonumber(L, 3);
                    float _duration = (float)LuaAPI.lua_tonumber(L, 4);
                    
                    gen_to_be_invoked.User_GetUpStackV2( _targetRagdollBlend, _targetMusclesPower, _duration );
                    
                    
                    
                    return 0;
                }
                if(gen_param_count == 3&& LuaTypes.LUA_TNUMBER == LuaAPI.lua_type(L, 2)&& LuaTypes.LUA_TNUMBER == LuaAPI.lua_type(L, 3)) 
                {
                    float _targetRagdollBlend = (float)LuaAPI.lua_tonumber(L, 2);
                    float _targetMusclesPower = (float)LuaAPI.lua_tonumber(L, 3);
                    
                    gen_to_be_invoked.User_GetUpStackV2( _targetRagdollBlend, _targetMusclesPower );
                    
                    
                    
                    return 0;
                }
                if(gen_param_count == 2&& LuaTypes.LUA_TNUMBER == LuaAPI.lua_type(L, 2)) 
                {
                    float _targetRagdollBlend = (float)LuaAPI.lua_tonumber(L, 2);
                    
                    gen_to_be_invoked.User_GetUpStackV2( _targetRagdollBlend );
                    
                    
                    
                    return 0;
                }
                if(gen_param_count == 1) 
                {
                    
                    gen_to_be_invoked.User_GetUpStackV2(  );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
            return LuaAPI.luaL_error(L, "invalid arguments to FIMSpace.FProceduralAnimation.RagdollAnimator.User_GetUpStackV2!");
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_User_OverrideRagdollStateWithCurrentAnimationState(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                FIMSpace.FProceduralAnimation.RagdollAnimator gen_to_be_invoked = (FIMSpace.FProceduralAnimation.RagdollAnimator)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    
                    gen_to_be_invoked.User_OverrideRagdollStateWithCurrentAnimationState(  );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_User_UpdateBonesToRagdollPose(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                FIMSpace.FProceduralAnimation.RagdollAnimator gen_to_be_invoked = (FIMSpace.FProceduralAnimation.RagdollAnimator)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    
                    gen_to_be_invoked.User_UpdateBonesToRagdollPose(  );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_User_FadeMuscles(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                FIMSpace.FProceduralAnimation.RagdollAnimator gen_to_be_invoked = (FIMSpace.FProceduralAnimation.RagdollAnimator)translator.FastGetCSObj(L, 1);
            
            
			    int gen_param_count = LuaAPI.lua_gettop(L);
            
                if(gen_param_count == 4&& LuaTypes.LUA_TNUMBER == LuaAPI.lua_type(L, 2)&& LuaTypes.LUA_TNUMBER == LuaAPI.lua_type(L, 3)&& LuaTypes.LUA_TNUMBER == LuaAPI.lua_type(L, 4)) 
                {
                    float _forcePoseEnd = (float)LuaAPI.lua_tonumber(L, 2);
                    float _duration = (float)LuaAPI.lua_tonumber(L, 3);
                    float _delay = (float)LuaAPI.lua_tonumber(L, 4);
                    
                    gen_to_be_invoked.User_FadeMuscles( _forcePoseEnd, _duration, _delay );
                    
                    
                    
                    return 0;
                }
                if(gen_param_count == 3&& LuaTypes.LUA_TNUMBER == LuaAPI.lua_type(L, 2)&& LuaTypes.LUA_TNUMBER == LuaAPI.lua_type(L, 3)) 
                {
                    float _forcePoseEnd = (float)LuaAPI.lua_tonumber(L, 2);
                    float _duration = (float)LuaAPI.lua_tonumber(L, 3);
                    
                    gen_to_be_invoked.User_FadeMuscles( _forcePoseEnd, _duration );
                    
                    
                    
                    return 0;
                }
                if(gen_param_count == 2&& LuaTypes.LUA_TNUMBER == LuaAPI.lua_type(L, 2)) 
                {
                    float _forcePoseEnd = (float)LuaAPI.lua_tonumber(L, 2);
                    
                    gen_to_be_invoked.User_FadeMuscles( _forcePoseEnd );
                    
                    
                    
                    return 0;
                }
                if(gen_param_count == 1) 
                {
                    
                    gen_to_be_invoked.User_FadeMuscles(  );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
            return LuaAPI.luaL_error(L, "invalid arguments to FIMSpace.FProceduralAnimation.RagdollAnimator.User_FadeMuscles!");
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_User_ForceRagdollToAnimatorFor(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                FIMSpace.FProceduralAnimation.RagdollAnimator gen_to_be_invoked = (FIMSpace.FProceduralAnimation.RagdollAnimator)translator.FastGetCSObj(L, 1);
            
            
			    int gen_param_count = LuaAPI.lua_gettop(L);
            
                if(gen_param_count == 3&& LuaTypes.LUA_TNUMBER == LuaAPI.lua_type(L, 2)&& LuaTypes.LUA_TNUMBER == LuaAPI.lua_type(L, 3)) 
                {
                    float _duration = (float)LuaAPI.lua_tonumber(L, 2);
                    float _forcingFullDelay = (float)LuaAPI.lua_tonumber(L, 3);
                    
                    gen_to_be_invoked.User_ForceRagdollToAnimatorFor( _duration, _forcingFullDelay );
                    
                    
                    
                    return 0;
                }
                if(gen_param_count == 2&& LuaTypes.LUA_TNUMBER == LuaAPI.lua_type(L, 2)) 
                {
                    float _duration = (float)LuaAPI.lua_tonumber(L, 2);
                    
                    gen_to_be_invoked.User_ForceRagdollToAnimatorFor( _duration );
                    
                    
                    
                    return 0;
                }
                if(gen_param_count == 1) 
                {
                    
                    gen_to_be_invoked.User_ForceRagdollToAnimatorFor(  );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
            return LuaAPI.luaL_error(L, "invalid arguments to FIMSpace.FProceduralAnimation.RagdollAnimator.User_ForceRagdollToAnimatorFor!");
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_User_FadeRagdolledBlend(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                FIMSpace.FProceduralAnimation.RagdollAnimator gen_to_be_invoked = (FIMSpace.FProceduralAnimation.RagdollAnimator)translator.FastGetCSObj(L, 1);
            
            
			    int gen_param_count = LuaAPI.lua_gettop(L);
            
                if(gen_param_count == 4&& LuaTypes.LUA_TNUMBER == LuaAPI.lua_type(L, 2)&& LuaTypes.LUA_TNUMBER == LuaAPI.lua_type(L, 3)&& LuaTypes.LUA_TNUMBER == LuaAPI.lua_type(L, 4)) 
                {
                    float _targetBlend = (float)LuaAPI.lua_tonumber(L, 2);
                    float _duration = (float)LuaAPI.lua_tonumber(L, 3);
                    float _delay = (float)LuaAPI.lua_tonumber(L, 4);
                    
                    gen_to_be_invoked.User_FadeRagdolledBlend( _targetBlend, _duration, _delay );
                    
                    
                    
                    return 0;
                }
                if(gen_param_count == 3&& LuaTypes.LUA_TNUMBER == LuaAPI.lua_type(L, 2)&& LuaTypes.LUA_TNUMBER == LuaAPI.lua_type(L, 3)) 
                {
                    float _targetBlend = (float)LuaAPI.lua_tonumber(L, 2);
                    float _duration = (float)LuaAPI.lua_tonumber(L, 3);
                    
                    gen_to_be_invoked.User_FadeRagdolledBlend( _targetBlend, _duration );
                    
                    
                    
                    return 0;
                }
                if(gen_param_count == 2&& LuaTypes.LUA_TNUMBER == LuaAPI.lua_type(L, 2)) 
                {
                    float _targetBlend = (float)LuaAPI.lua_tonumber(L, 2);
                    
                    gen_to_be_invoked.User_FadeRagdolledBlend( _targetBlend );
                    
                    
                    
                    return 0;
                }
                if(gen_param_count == 1) 
                {
                    
                    gen_to_be_invoked.User_FadeRagdolledBlend(  );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
            return LuaAPI.luaL_error(L, "invalid arguments to FIMSpace.FProceduralAnimation.RagdollAnimator.User_FadeRagdolledBlend!");
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_User_HardSwitchOffRagdollAnimator(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                FIMSpace.FProceduralAnimation.RagdollAnimator gen_to_be_invoked = (FIMSpace.FProceduralAnimation.RagdollAnimator)translator.FastGetCSObj(L, 1);
            
            
			    int gen_param_count = LuaAPI.lua_gettop(L);
            
                if(gen_param_count == 3&& LuaTypes.LUA_TBOOLEAN == LuaAPI.lua_type(L, 2)&& LuaTypes.LUA_TBOOLEAN == LuaAPI.lua_type(L, 3)) 
                {
                    bool _turnOn = LuaAPI.lua_toboolean(L, 2);
                    bool _disableCollisions = LuaAPI.lua_toboolean(L, 3);
                    
                    gen_to_be_invoked.User_HardSwitchOffRagdollAnimator( _turnOn, _disableCollisions );
                    
                    
                    
                    return 0;
                }
                if(gen_param_count == 2&& LuaTypes.LUA_TBOOLEAN == LuaAPI.lua_type(L, 2)) 
                {
                    bool _turnOn = LuaAPI.lua_toboolean(L, 2);
                    
                    gen_to_be_invoked.User_HardSwitchOffRagdollAnimator( _turnOn );
                    
                    
                    
                    return 0;
                }
                if(gen_param_count == 1) 
                {
                    
                    gen_to_be_invoked.User_HardSwitchOffRagdollAnimator(  );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
            return LuaAPI.luaL_error(L, "invalid arguments to FIMSpace.FProceduralAnimation.RagdollAnimator.User_HardSwitchOffRagdollAnimator!");
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_User_DestroyRagdollAnimatorAndKeepPhysics(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                FIMSpace.FProceduralAnimation.RagdollAnimator gen_to_be_invoked = (FIMSpace.FProceduralAnimation.RagdollAnimator)translator.FastGetCSObj(L, 1);
            
            
			    int gen_param_count = LuaAPI.lua_gettop(L);
            
                if(gen_param_count == 4&& LuaTypes.LUA_TNUMBER == LuaAPI.lua_type(L, 2)&& LuaTypes.LUA_TNUMBER == LuaAPI.lua_type(L, 3)&& LuaTypes.LUA_TBOOLEAN == LuaAPI.lua_type(L, 4)) 
                {
                    float _removeAfter = (float)LuaAPI.lua_tonumber(L, 2);
                    float _removeOnlyWhenLowVelocity = (float)LuaAPI.lua_tonumber(L, 3);
                    bool _destroyAndFreeze = LuaAPI.lua_toboolean(L, 4);
                    
                    gen_to_be_invoked.User_DestroyRagdollAnimatorAndKeepPhysics( _removeAfter, _removeOnlyWhenLowVelocity, _destroyAndFreeze );
                    
                    
                    
                    return 0;
                }
                if(gen_param_count == 3&& LuaTypes.LUA_TNUMBER == LuaAPI.lua_type(L, 2)&& LuaTypes.LUA_TNUMBER == LuaAPI.lua_type(L, 3)) 
                {
                    float _removeAfter = (float)LuaAPI.lua_tonumber(L, 2);
                    float _removeOnlyWhenLowVelocity = (float)LuaAPI.lua_tonumber(L, 3);
                    
                    gen_to_be_invoked.User_DestroyRagdollAnimatorAndKeepPhysics( _removeAfter, _removeOnlyWhenLowVelocity );
                    
                    
                    
                    return 0;
                }
                if(gen_param_count == 2&& LuaTypes.LUA_TNUMBER == LuaAPI.lua_type(L, 2)) 
                {
                    float _removeAfter = (float)LuaAPI.lua_tonumber(L, 2);
                    
                    gen_to_be_invoked.User_DestroyRagdollAnimatorAndKeepPhysics( _removeAfter );
                    
                    
                    
                    return 0;
                }
                if(gen_param_count == 1) 
                {
                    
                    gen_to_be_invoked.User_DestroyRagdollAnimatorAndKeepPhysics(  );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
            return LuaAPI.luaL_error(L, "invalid arguments to FIMSpace.FProceduralAnimation.RagdollAnimator.User_DestroyRagdollAnimatorAndKeepPhysics!");
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_User_DestroyRagdollAnimatorAndFreeze(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                FIMSpace.FProceduralAnimation.RagdollAnimator gen_to_be_invoked = (FIMSpace.FProceduralAnimation.RagdollAnimator)translator.FastGetCSObj(L, 1);
            
            
			    int gen_param_count = LuaAPI.lua_gettop(L);
            
                if(gen_param_count == 3&& LuaTypes.LUA_TNUMBER == LuaAPI.lua_type(L, 2)&& LuaTypes.LUA_TBOOLEAN == LuaAPI.lua_type(L, 3)) 
                {
                    float _destroyAfter = (float)LuaAPI.lua_tonumber(L, 2);
                    bool _disableAnimator = LuaAPI.lua_toboolean(L, 3);
                    
                    gen_to_be_invoked.User_DestroyRagdollAnimatorAndFreeze( _destroyAfter, _disableAnimator );
                    
                    
                    
                    return 0;
                }
                if(gen_param_count == 2&& LuaTypes.LUA_TNUMBER == LuaAPI.lua_type(L, 2)) 
                {
                    float _destroyAfter = (float)LuaAPI.lua_tonumber(L, 2);
                    
                    gen_to_be_invoked.User_DestroyRagdollAnimatorAndFreeze( _destroyAfter );
                    
                    
                    
                    return 0;
                }
                if(gen_param_count == 1) 
                {
                    
                    gen_to_be_invoked.User_DestroyRagdollAnimatorAndFreeze(  );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
            return LuaAPI.luaL_error(L, "invalid arguments to FIMSpace.FProceduralAnimation.RagdollAnimator.User_DestroyRagdollAnimatorAndFreeze!");
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_User_Coroutine_DisableAnimatingAndKeepPose(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                FIMSpace.FProceduralAnimation.RagdollAnimator gen_to_be_invoked = (FIMSpace.FProceduralAnimation.RagdollAnimator)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    UnityEngine.Animator _animatorToDisable = (UnityEngine.Animator)translator.GetObject(L, 2, typeof(UnityEngine.Animator));
                    
                        var gen_ret = gen_to_be_invoked.User_Coroutine_DisableAnimatingAndKeepPose( _animatorToDisable );
                        translator.PushAny(L, gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_User_GetRagdollBonesStateBounds(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                FIMSpace.FProceduralAnimation.RagdollAnimator gen_to_be_invoked = (FIMSpace.FProceduralAnimation.RagdollAnimator)translator.FastGetCSObj(L, 1);
            
            
			    int gen_param_count = LuaAPI.lua_gettop(L);
            
                if(gen_param_count == 2&& LuaTypes.LUA_TBOOLEAN == LuaAPI.lua_type(L, 2)) 
                {
                    bool _fast = LuaAPI.lua_toboolean(L, 2);
                    
                        var gen_ret = gen_to_be_invoked.User_GetRagdollBonesStateBounds( _fast );
                        translator.PushUnityEngineBounds(L, gen_ret);
                    
                    
                    
                    return 1;
                }
                if(gen_param_count == 1) 
                {
                    
                        var gen_ret = gen_to_be_invoked.User_GetRagdollBonesStateBounds(  );
                        translator.PushUnityEngineBounds(L, gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
            return LuaAPI.luaL_error(L, "invalid arguments to FIMSpace.FProceduralAnimation.RagdollAnimator.User_GetRagdollBonesStateBounds!");
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_User_Teleport(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                FIMSpace.FProceduralAnimation.RagdollAnimator gen_to_be_invoked = (FIMSpace.FProceduralAnimation.RagdollAnimator)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    UnityEngine.Vector3 _newWorldPos;translator.Get(L, 2, out _newWorldPos);
                    
                    gen_to_be_invoked.User_Teleport( _newWorldPos );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_User_SetAllKinematic(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                FIMSpace.FProceduralAnimation.RagdollAnimator gen_to_be_invoked = (FIMSpace.FProceduralAnimation.RagdollAnimator)translator.FastGetCSObj(L, 1);
            
            
			    int gen_param_count = LuaAPI.lua_gettop(L);
            
                if(gen_param_count == 2&& LuaTypes.LUA_TBOOLEAN == LuaAPI.lua_type(L, 2)) 
                {
                    bool _kinematic = LuaAPI.lua_toboolean(L, 2);
                    
                    gen_to_be_invoked.User_SetAllKinematic( _kinematic );
                    
                    
                    
                    return 0;
                }
                if(gen_param_count == 1) 
                {
                    
                    gen_to_be_invoked.User_SetAllKinematic(  );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
            return LuaAPI.luaL_error(L, "invalid arguments to FIMSpace.FProceduralAnimation.RagdollAnimator.User_SetAllKinematic!");
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_User_SetAllAngularSpeedLimit(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                FIMSpace.FProceduralAnimation.RagdollAnimator gen_to_be_invoked = (FIMSpace.FProceduralAnimation.RagdollAnimator)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    float _angularLimit = (float)LuaAPI.lua_tonumber(L, 2);
                    
                    gen_to_be_invoked.User_SetAllAngularSpeedLimit( _angularLimit );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_User_AnchorPelvis(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                FIMSpace.FProceduralAnimation.RagdollAnimator gen_to_be_invoked = (FIMSpace.FProceduralAnimation.RagdollAnimator)translator.FastGetCSObj(L, 1);
            
            
			    int gen_param_count = LuaAPI.lua_gettop(L);
            
                if(gen_param_count == 3&& LuaTypes.LUA_TBOOLEAN == LuaAPI.lua_type(L, 2)&& LuaTypes.LUA_TNUMBER == LuaAPI.lua_type(L, 3)) 
                {
                    bool _anchor = LuaAPI.lua_toboolean(L, 2);
                    float _duration = (float)LuaAPI.lua_tonumber(L, 3);
                    
                    gen_to_be_invoked.User_AnchorPelvis( _anchor, _duration );
                    
                    
                    
                    return 0;
                }
                if(gen_param_count == 2&& LuaTypes.LUA_TBOOLEAN == LuaAPI.lua_type(L, 2)) 
                {
                    bool _anchor = LuaAPI.lua_toboolean(L, 2);
                    
                    gen_to_be_invoked.User_AnchorPelvis( _anchor );
                    
                    
                    
                    return 0;
                }
                if(gen_param_count == 1) 
                {
                    
                    gen_to_be_invoked.User_AnchorPelvis(  );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
            return LuaAPI.luaL_error(L, "invalid arguments to FIMSpace.FProceduralAnimation.RagdollAnimator.User_AnchorPelvis!");
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_User_RepositionRoot(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                FIMSpace.FProceduralAnimation.RagdollAnimator gen_to_be_invoked = (FIMSpace.FProceduralAnimation.RagdollAnimator)translator.FastGetCSObj(L, 1);
            
            
			    int gen_param_count = LuaAPI.lua_gettop(L);
            
                if(gen_param_count == 5&& translator.Assignable<UnityEngine.Transform>(L, 2)&& translator.Assignable<System.Nullable<UnityEngine.Vector3>>(L, 3)&& translator.Assignable<FIMSpace.FProceduralAnimation.RagdollProcessor.EGetUpType>(L, 4)&& translator.Assignable<System.Nullable<UnityEngine.LayerMask>>(L, 5)) 
                {
                    UnityEngine.Transform _root = (UnityEngine.Transform)translator.GetObject(L, 2, typeof(UnityEngine.Transform));
                    System.Nullable<UnityEngine.Vector3> _worldUp;translator.Get(L, 3, out _worldUp);
                    FIMSpace.FProceduralAnimation.RagdollProcessor.EGetUpType _getupType;translator.Get(L, 4, out _getupType);
                    System.Nullable<UnityEngine.LayerMask> _snapToGround;translator.Get(L, 5, out _snapToGround);
                    
                    gen_to_be_invoked.User_RepositionRoot( _root, _worldUp, _getupType, _snapToGround );
                    
                    
                    
                    return 0;
                }
                if(gen_param_count == 4&& translator.Assignable<UnityEngine.Transform>(L, 2)&& translator.Assignable<System.Nullable<UnityEngine.Vector3>>(L, 3)&& translator.Assignable<FIMSpace.FProceduralAnimation.RagdollProcessor.EGetUpType>(L, 4)) 
                {
                    UnityEngine.Transform _root = (UnityEngine.Transform)translator.GetObject(L, 2, typeof(UnityEngine.Transform));
                    System.Nullable<UnityEngine.Vector3> _worldUp;translator.Get(L, 3, out _worldUp);
                    FIMSpace.FProceduralAnimation.RagdollProcessor.EGetUpType _getupType;translator.Get(L, 4, out _getupType);
                    
                    gen_to_be_invoked.User_RepositionRoot( _root, _worldUp, _getupType );
                    
                    
                    
                    return 0;
                }
                if(gen_param_count == 3&& translator.Assignable<UnityEngine.Transform>(L, 2)&& translator.Assignable<System.Nullable<UnityEngine.Vector3>>(L, 3)) 
                {
                    UnityEngine.Transform _root = (UnityEngine.Transform)translator.GetObject(L, 2, typeof(UnityEngine.Transform));
                    System.Nullable<UnityEngine.Vector3> _worldUp;translator.Get(L, 3, out _worldUp);
                    
                    gen_to_be_invoked.User_RepositionRoot( _root, _worldUp );
                    
                    
                    
                    return 0;
                }
                if(gen_param_count == 2&& translator.Assignable<UnityEngine.Transform>(L, 2)) 
                {
                    UnityEngine.Transform _root = (UnityEngine.Transform)translator.GetObject(L, 2, typeof(UnityEngine.Transform));
                    
                    gen_to_be_invoked.User_RepositionRoot( _root );
                    
                    
                    
                    return 0;
                }
                if(gen_param_count == 1) 
                {
                    
                    gen_to_be_invoked.User_RepositionRoot(  );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
            return LuaAPI.luaL_error(L, "invalid arguments to FIMSpace.FProceduralAnimation.RagdollAnimator.User_RepositionRoot!");
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_Reset(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                FIMSpace.FProceduralAnimation.RagdollAnimator gen_to_be_invoked = (FIMSpace.FProceduralAnimation.RagdollAnimator)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    
                    gen_to_be_invoked.Reset(  );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_Start(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                FIMSpace.FProceduralAnimation.RagdollAnimator gen_to_be_invoked = (FIMSpace.FProceduralAnimation.RagdollAnimator)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    
                    gen_to_be_invoked.Start(  );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        
        
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_IsFadeRagdollCoroutineRunning(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                FIMSpace.FProceduralAnimation.RagdollAnimator gen_to_be_invoked = (FIMSpace.FProceduralAnimation.RagdollAnimator)translator.FastGetCSObj(L, 1);
                LuaAPI.lua_pushboolean(L, gen_to_be_invoked.IsFadeRagdollCoroutineRunning);
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 1;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_Parameters(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                FIMSpace.FProceduralAnimation.RagdollAnimator gen_to_be_invoked = (FIMSpace.FProceduralAnimation.RagdollAnimator)translator.FastGetCSObj(L, 1);
                translator.Push(L, gen_to_be_invoked.Parameters);
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 1;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get__initialReposeMode(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                FIMSpace.FProceduralAnimation.RagdollAnimator gen_to_be_invoked = (FIMSpace.FProceduralAnimation.RagdollAnimator)translator.FastGetCSObj(L, 1);
                translator.Push(L, gen_to_be_invoked._initialReposeMode);
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 1;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_ObjectWithAnimator(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                FIMSpace.FProceduralAnimation.RagdollAnimator gen_to_be_invoked = (FIMSpace.FProceduralAnimation.RagdollAnimator)translator.FastGetCSObj(L, 1);
                translator.Push(L, gen_to_be_invoked.ObjectWithAnimator);
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 1;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_RootBone(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                FIMSpace.FProceduralAnimation.RagdollAnimator gen_to_be_invoked = (FIMSpace.FProceduralAnimation.RagdollAnimator)translator.FastGetCSObj(L, 1);
                translator.Push(L, gen_to_be_invoked.RootBone);
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 1;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_CustomRagdollAnimator(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                FIMSpace.FProceduralAnimation.RagdollAnimator gen_to_be_invoked = (FIMSpace.FProceduralAnimation.RagdollAnimator)translator.FastGetCSObj(L, 1);
                translator.Push(L, gen_to_be_invoked.CustomRagdollAnimator);
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 1;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_AutoDestroy(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                FIMSpace.FProceduralAnimation.RagdollAnimator gen_to_be_invoked = (FIMSpace.FProceduralAnimation.RagdollAnimator)translator.FastGetCSObj(L, 1);
                LuaAPI.lua_pushboolean(L, gen_to_be_invoked.AutoDestroy);
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 1;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_PreGenerateDummy(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                FIMSpace.FProceduralAnimation.RagdollAnimator gen_to_be_invoked = (FIMSpace.FProceduralAnimation.RagdollAnimator)translator.FastGetCSObj(L, 1);
                LuaAPI.lua_pushboolean(L, gen_to_be_invoked.PreGenerateDummy);
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 1;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_TargetParentForRagdollDummy(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                FIMSpace.FProceduralAnimation.RagdollAnimator gen_to_be_invoked = (FIMSpace.FProceduralAnimation.RagdollAnimator)translator.FastGetCSObj(L, 1);
                translator.Push(L, gen_to_be_invoked.TargetParentForRagdollDummy);
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 1;
        }
        
        
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _s_set__initialReposeMode(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                FIMSpace.FProceduralAnimation.RagdollAnimator gen_to_be_invoked = (FIMSpace.FProceduralAnimation.RagdollAnimator)translator.FastGetCSObj(L, 1);
                FIMSpace.FProceduralAnimation.RagdollProcessor.EBaseTransformRepose gen_value;translator.Get(L, 2, out gen_value);
				gen_to_be_invoked._initialReposeMode = gen_value;
            
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 0;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _s_set_ObjectWithAnimator(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                FIMSpace.FProceduralAnimation.RagdollAnimator gen_to_be_invoked = (FIMSpace.FProceduralAnimation.RagdollAnimator)translator.FastGetCSObj(L, 1);
                gen_to_be_invoked.ObjectWithAnimator = (UnityEngine.Transform)translator.GetObject(L, 2, typeof(UnityEngine.Transform));
            
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 0;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _s_set_RootBone(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                FIMSpace.FProceduralAnimation.RagdollAnimator gen_to_be_invoked = (FIMSpace.FProceduralAnimation.RagdollAnimator)translator.FastGetCSObj(L, 1);
                gen_to_be_invoked.RootBone = (UnityEngine.Transform)translator.GetObject(L, 2, typeof(UnityEngine.Transform));
            
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 0;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _s_set_CustomRagdollAnimator(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                FIMSpace.FProceduralAnimation.RagdollAnimator gen_to_be_invoked = (FIMSpace.FProceduralAnimation.RagdollAnimator)translator.FastGetCSObj(L, 1);
                gen_to_be_invoked.CustomRagdollAnimator = (UnityEngine.Transform)translator.GetObject(L, 2, typeof(UnityEngine.Transform));
            
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 0;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _s_set_AutoDestroy(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                FIMSpace.FProceduralAnimation.RagdollAnimator gen_to_be_invoked = (FIMSpace.FProceduralAnimation.RagdollAnimator)translator.FastGetCSObj(L, 1);
                gen_to_be_invoked.AutoDestroy = LuaAPI.lua_toboolean(L, 2);
            
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 0;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _s_set_PreGenerateDummy(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                FIMSpace.FProceduralAnimation.RagdollAnimator gen_to_be_invoked = (FIMSpace.FProceduralAnimation.RagdollAnimator)translator.FastGetCSObj(L, 1);
                gen_to_be_invoked.PreGenerateDummy = LuaAPI.lua_toboolean(L, 2);
            
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 0;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _s_set_TargetParentForRagdollDummy(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                FIMSpace.FProceduralAnimation.RagdollAnimator gen_to_be_invoked = (FIMSpace.FProceduralAnimation.RagdollAnimator)translator.FastGetCSObj(L, 1);
                gen_to_be_invoked.TargetParentForRagdollDummy = (UnityEngine.Transform)translator.GetObject(L, 2, typeof(UnityEngine.Transform));
            
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 0;
        }
        
		
		
		
		
    }
}
