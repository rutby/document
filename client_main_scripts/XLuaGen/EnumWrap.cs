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
    
    public class UnityEngineCameraGateFitModeWrap
    {
		public static void __Register(RealStatePtr L)
        {
		    ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
		    Utils.BeginObjectRegister(typeof(UnityEngine.Camera.GateFitMode), L, translator, 0, 0, 0, 0);
			Utils.EndObjectRegister(typeof(UnityEngine.Camera.GateFitMode), L, translator, null, null, null, null, null);
			
			Utils.BeginClassRegister(typeof(UnityEngine.Camera.GateFitMode), L, null, 6, 0, 0);

            
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "Vertical", UnityEngine.Camera.GateFitMode.Vertical);
            
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "Horizontal", UnityEngine.Camera.GateFitMode.Horizontal);
            
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "Fill", UnityEngine.Camera.GateFitMode.Fill);
            
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "Overscan", UnityEngine.Camera.GateFitMode.Overscan);
            
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "None", UnityEngine.Camera.GateFitMode.None);
            

			Utils.RegisterFunc(L, Utils.CLS_IDX, "__CastFrom", __CastFrom);
            
            Utils.EndClassRegister(typeof(UnityEngine.Camera.GateFitMode), L, translator);
        }
		
		[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int __CastFrom(RealStatePtr L)
		{
			ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			LuaTypes lua_type = LuaAPI.lua_type(L, 1);
            if (lua_type == LuaTypes.LUA_TNUMBER)
            {
                translator.PushUnityEngineCameraGateFitMode(L, (UnityEngine.Camera.GateFitMode)LuaAPI.xlua_tointeger(L, 1));
            }
			
            else if(lua_type == LuaTypes.LUA_TSTRING)
            {

			    if (LuaAPI.xlua_is_eq_str(L, 1, "Vertical"))
                {
                    translator.PushUnityEngineCameraGateFitMode(L, UnityEngine.Camera.GateFitMode.Vertical);
                }
				else if (LuaAPI.xlua_is_eq_str(L, 1, "Horizontal"))
                {
                    translator.PushUnityEngineCameraGateFitMode(L, UnityEngine.Camera.GateFitMode.Horizontal);
                }
				else if (LuaAPI.xlua_is_eq_str(L, 1, "Fill"))
                {
                    translator.PushUnityEngineCameraGateFitMode(L, UnityEngine.Camera.GateFitMode.Fill);
                }
				else if (LuaAPI.xlua_is_eq_str(L, 1, "Overscan"))
                {
                    translator.PushUnityEngineCameraGateFitMode(L, UnityEngine.Camera.GateFitMode.Overscan);
                }
				else if (LuaAPI.xlua_is_eq_str(L, 1, "None"))
                {
                    translator.PushUnityEngineCameraGateFitMode(L, UnityEngine.Camera.GateFitMode.None);
                }
				else
                {
                    return LuaAPI.luaL_error(L, "invalid string for UnityEngine.Camera.GateFitMode!");
                }

            }
			
            else
            {
                return LuaAPI.luaL_error(L, "invalid lua type for UnityEngine.Camera.GateFitMode! Expect number or string, got + " + lua_type);
            }

            return 1;
		}
	}
    
    public class UnityEngineCameraFieldOfViewAxisWrap
    {
		public static void __Register(RealStatePtr L)
        {
		    ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
		    Utils.BeginObjectRegister(typeof(UnityEngine.Camera.FieldOfViewAxis), L, translator, 0, 0, 0, 0);
			Utils.EndObjectRegister(typeof(UnityEngine.Camera.FieldOfViewAxis), L, translator, null, null, null, null, null);
			
			Utils.BeginClassRegister(typeof(UnityEngine.Camera.FieldOfViewAxis), L, null, 3, 0, 0);

            
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "Vertical", UnityEngine.Camera.FieldOfViewAxis.Vertical);
            
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "Horizontal", UnityEngine.Camera.FieldOfViewAxis.Horizontal);
            

			Utils.RegisterFunc(L, Utils.CLS_IDX, "__CastFrom", __CastFrom);
            
            Utils.EndClassRegister(typeof(UnityEngine.Camera.FieldOfViewAxis), L, translator);
        }
		
		[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int __CastFrom(RealStatePtr L)
		{
			ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			LuaTypes lua_type = LuaAPI.lua_type(L, 1);
            if (lua_type == LuaTypes.LUA_TNUMBER)
            {
                translator.PushUnityEngineCameraFieldOfViewAxis(L, (UnityEngine.Camera.FieldOfViewAxis)LuaAPI.xlua_tointeger(L, 1));
            }
			
            else if(lua_type == LuaTypes.LUA_TSTRING)
            {

			    if (LuaAPI.xlua_is_eq_str(L, 1, "Vertical"))
                {
                    translator.PushUnityEngineCameraFieldOfViewAxis(L, UnityEngine.Camera.FieldOfViewAxis.Vertical);
                }
				else if (LuaAPI.xlua_is_eq_str(L, 1, "Horizontal"))
                {
                    translator.PushUnityEngineCameraFieldOfViewAxis(L, UnityEngine.Camera.FieldOfViewAxis.Horizontal);
                }
				else
                {
                    return LuaAPI.luaL_error(L, "invalid string for UnityEngine.Camera.FieldOfViewAxis!");
                }

            }
			
            else
            {
                return LuaAPI.luaL_error(L, "invalid lua type for UnityEngine.Camera.FieldOfViewAxis! Expect number or string, got + " + lua_type);
            }

            return 1;
		}
	}
    
    public class DGTweeningDOTweenAnimationAnimationTypeWrap
    {
		public static void __Register(RealStatePtr L)
        {
		    ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
		    Utils.BeginObjectRegister(typeof(DG.Tweening.DOTweenAnimation.AnimationType), L, translator, 0, 0, 0, 0);
			Utils.EndObjectRegister(typeof(DG.Tweening.DOTweenAnimation.AnimationType), L, translator, null, null, null, null, null);
			
			Utils.BeginClassRegister(typeof(DG.Tweening.DOTweenAnimation.AnimationType), L, null, 23, 0, 0);

            Utils.RegisterEnumType(L, typeof(DG.Tweening.DOTweenAnimation.AnimationType));

			Utils.RegisterFunc(L, Utils.CLS_IDX, "__CastFrom", __CastFrom);
            
            Utils.EndClassRegister(typeof(DG.Tweening.DOTweenAnimation.AnimationType), L, translator);
        }
		
		[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int __CastFrom(RealStatePtr L)
		{
			ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			LuaTypes lua_type = LuaAPI.lua_type(L, 1);
            if (lua_type == LuaTypes.LUA_TNUMBER)
            {
                translator.PushDGTweeningDOTweenAnimationAnimationType(L, (DG.Tweening.DOTweenAnimation.AnimationType)LuaAPI.xlua_tointeger(L, 1));
            }
			
            else if(lua_type == LuaTypes.LUA_TSTRING)
            {

                try
				{
                    translator.TranslateToEnumToTop(L, typeof(DG.Tweening.DOTweenAnimation.AnimationType), 1);
				}
				catch (System.Exception e)
				{
					return LuaAPI.luaL_error(L, "cast to " + typeof(DG.Tweening.DOTweenAnimation.AnimationType) + " exception:" + e);
				}

            }
			
            else
            {
                return LuaAPI.luaL_error(L, "invalid lua type for DG.Tweening.DOTweenAnimation.AnimationType! Expect number or string, got + " + lua_type);
            }

            return 1;
		}
	}
    
    public class DGTweeningDOTweenAnimationTargetTypeWrap
    {
		public static void __Register(RealStatePtr L)
        {
		    ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
		    Utils.BeginObjectRegister(typeof(DG.Tweening.DOTweenAnimation.TargetType), L, translator, 0, 0, 0, 0);
			Utils.EndObjectRegister(typeof(DG.Tweening.DOTweenAnimation.TargetType), L, translator, null, null, null, null, null);
			
			Utils.BeginClassRegister(typeof(DG.Tweening.DOTweenAnimation.TargetType), L, null, 17, 0, 0);

            
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "Unset", DG.Tweening.DOTweenAnimation.TargetType.Unset);
            
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "Camera", DG.Tweening.DOTweenAnimation.TargetType.Camera);
            
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "CanvasGroup", DG.Tweening.DOTweenAnimation.TargetType.CanvasGroup);
            
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "Image", DG.Tweening.DOTweenAnimation.TargetType.Image);
            
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "Light", DG.Tweening.DOTweenAnimation.TargetType.Light);
            
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "RectTransform", DG.Tweening.DOTweenAnimation.TargetType.RectTransform);
            
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "Renderer", DG.Tweening.DOTweenAnimation.TargetType.Renderer);
            
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "SpriteRenderer", DG.Tweening.DOTweenAnimation.TargetType.SpriteRenderer);
            
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "Rigidbody", DG.Tweening.DOTweenAnimation.TargetType.Rigidbody);
            
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "Rigidbody2D", DG.Tweening.DOTweenAnimation.TargetType.Rigidbody2D);
            
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "Text", DG.Tweening.DOTweenAnimation.TargetType.Text);
            
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "Transform", DG.Tweening.DOTweenAnimation.TargetType.Transform);
            
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "tk2dBaseSprite", DG.Tweening.DOTweenAnimation.TargetType.tk2dBaseSprite);
            
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "tk2dTextMesh", DG.Tweening.DOTweenAnimation.TargetType.tk2dTextMesh);
            
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "TextMeshPro", DG.Tweening.DOTweenAnimation.TargetType.TextMeshPro);
            
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "TextMeshProUGUI", DG.Tweening.DOTweenAnimation.TargetType.TextMeshProUGUI);
            

			Utils.RegisterFunc(L, Utils.CLS_IDX, "__CastFrom", __CastFrom);
            
            Utils.EndClassRegister(typeof(DG.Tweening.DOTweenAnimation.TargetType), L, translator);
        }
		
		[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int __CastFrom(RealStatePtr L)
		{
			ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			LuaTypes lua_type = LuaAPI.lua_type(L, 1);
            if (lua_type == LuaTypes.LUA_TNUMBER)
            {
                translator.PushDGTweeningDOTweenAnimationTargetType(L, (DG.Tweening.DOTweenAnimation.TargetType)LuaAPI.xlua_tointeger(L, 1));
            }
			
            else if(lua_type == LuaTypes.LUA_TSTRING)
            {

			    if (LuaAPI.xlua_is_eq_str(L, 1, "Unset"))
                {
                    translator.PushDGTweeningDOTweenAnimationTargetType(L, DG.Tweening.DOTweenAnimation.TargetType.Unset);
                }
				else if (LuaAPI.xlua_is_eq_str(L, 1, "Camera"))
                {
                    translator.PushDGTweeningDOTweenAnimationTargetType(L, DG.Tweening.DOTweenAnimation.TargetType.Camera);
                }
				else if (LuaAPI.xlua_is_eq_str(L, 1, "CanvasGroup"))
                {
                    translator.PushDGTweeningDOTweenAnimationTargetType(L, DG.Tweening.DOTweenAnimation.TargetType.CanvasGroup);
                }
				else if (LuaAPI.xlua_is_eq_str(L, 1, "Image"))
                {
                    translator.PushDGTweeningDOTweenAnimationTargetType(L, DG.Tweening.DOTweenAnimation.TargetType.Image);
                }
				else if (LuaAPI.xlua_is_eq_str(L, 1, "Light"))
                {
                    translator.PushDGTweeningDOTweenAnimationTargetType(L, DG.Tweening.DOTweenAnimation.TargetType.Light);
                }
				else if (LuaAPI.xlua_is_eq_str(L, 1, "RectTransform"))
                {
                    translator.PushDGTweeningDOTweenAnimationTargetType(L, DG.Tweening.DOTweenAnimation.TargetType.RectTransform);
                }
				else if (LuaAPI.xlua_is_eq_str(L, 1, "Renderer"))
                {
                    translator.PushDGTweeningDOTweenAnimationTargetType(L, DG.Tweening.DOTweenAnimation.TargetType.Renderer);
                }
				else if (LuaAPI.xlua_is_eq_str(L, 1, "SpriteRenderer"))
                {
                    translator.PushDGTweeningDOTweenAnimationTargetType(L, DG.Tweening.DOTweenAnimation.TargetType.SpriteRenderer);
                }
				else if (LuaAPI.xlua_is_eq_str(L, 1, "Rigidbody"))
                {
                    translator.PushDGTweeningDOTweenAnimationTargetType(L, DG.Tweening.DOTweenAnimation.TargetType.Rigidbody);
                }
				else if (LuaAPI.xlua_is_eq_str(L, 1, "Rigidbody2D"))
                {
                    translator.PushDGTweeningDOTweenAnimationTargetType(L, DG.Tweening.DOTweenAnimation.TargetType.Rigidbody2D);
                }
				else if (LuaAPI.xlua_is_eq_str(L, 1, "Text"))
                {
                    translator.PushDGTweeningDOTweenAnimationTargetType(L, DG.Tweening.DOTweenAnimation.TargetType.Text);
                }
				else if (LuaAPI.xlua_is_eq_str(L, 1, "Transform"))
                {
                    translator.PushDGTweeningDOTweenAnimationTargetType(L, DG.Tweening.DOTweenAnimation.TargetType.Transform);
                }
				else if (LuaAPI.xlua_is_eq_str(L, 1, "tk2dBaseSprite"))
                {
                    translator.PushDGTweeningDOTweenAnimationTargetType(L, DG.Tweening.DOTweenAnimation.TargetType.tk2dBaseSprite);
                }
				else if (LuaAPI.xlua_is_eq_str(L, 1, "tk2dTextMesh"))
                {
                    translator.PushDGTweeningDOTweenAnimationTargetType(L, DG.Tweening.DOTweenAnimation.TargetType.tk2dTextMesh);
                }
				else if (LuaAPI.xlua_is_eq_str(L, 1, "TextMeshPro"))
                {
                    translator.PushDGTweeningDOTweenAnimationTargetType(L, DG.Tweening.DOTweenAnimation.TargetType.TextMeshPro);
                }
				else if (LuaAPI.xlua_is_eq_str(L, 1, "TextMeshProUGUI"))
                {
                    translator.PushDGTweeningDOTweenAnimationTargetType(L, DG.Tweening.DOTweenAnimation.TargetType.TextMeshProUGUI);
                }
				else
                {
                    return LuaAPI.luaL_error(L, "invalid string for DG.Tweening.DOTweenAnimation.TargetType!");
                }

            }
			
            else
            {
                return LuaAPI.luaL_error(L, "invalid lua type for DG.Tweening.DOTweenAnimation.TargetType! Expect number or string, got + " + lua_type);
            }

            return 1;
		}
	}
    
    public class UnityEngineRectTransformEdgeWrap
    {
		public static void __Register(RealStatePtr L)
        {
		    ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
		    Utils.BeginObjectRegister(typeof(UnityEngine.RectTransform.Edge), L, translator, 0, 0, 0, 0);
			Utils.EndObjectRegister(typeof(UnityEngine.RectTransform.Edge), L, translator, null, null, null, null, null);
			
			Utils.BeginClassRegister(typeof(UnityEngine.RectTransform.Edge), L, null, 5, 0, 0);

            
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "Left", UnityEngine.RectTransform.Edge.Left);
            
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "Right", UnityEngine.RectTransform.Edge.Right);
            
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "Top", UnityEngine.RectTransform.Edge.Top);
            
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "Bottom", UnityEngine.RectTransform.Edge.Bottom);
            

			Utils.RegisterFunc(L, Utils.CLS_IDX, "__CastFrom", __CastFrom);
            
            Utils.EndClassRegister(typeof(UnityEngine.RectTransform.Edge), L, translator);
        }
		
		[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int __CastFrom(RealStatePtr L)
		{
			ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			LuaTypes lua_type = LuaAPI.lua_type(L, 1);
            if (lua_type == LuaTypes.LUA_TNUMBER)
            {
                translator.PushUnityEngineRectTransformEdge(L, (UnityEngine.RectTransform.Edge)LuaAPI.xlua_tointeger(L, 1));
            }
			
            else if(lua_type == LuaTypes.LUA_TSTRING)
            {

			    if (LuaAPI.xlua_is_eq_str(L, 1, "Left"))
                {
                    translator.PushUnityEngineRectTransformEdge(L, UnityEngine.RectTransform.Edge.Left);
                }
				else if (LuaAPI.xlua_is_eq_str(L, 1, "Right"))
                {
                    translator.PushUnityEngineRectTransformEdge(L, UnityEngine.RectTransform.Edge.Right);
                }
				else if (LuaAPI.xlua_is_eq_str(L, 1, "Top"))
                {
                    translator.PushUnityEngineRectTransformEdge(L, UnityEngine.RectTransform.Edge.Top);
                }
				else if (LuaAPI.xlua_is_eq_str(L, 1, "Bottom"))
                {
                    translator.PushUnityEngineRectTransformEdge(L, UnityEngine.RectTransform.Edge.Bottom);
                }
				else
                {
                    return LuaAPI.luaL_error(L, "invalid string for UnityEngine.RectTransform.Edge!");
                }

            }
			
            else
            {
                return LuaAPI.luaL_error(L, "invalid lua type for UnityEngine.RectTransform.Edge! Expect number or string, got + " + lua_type);
            }

            return 1;
		}
	}
    
    public class UnityEngineRectTransformAxisWrap
    {
		public static void __Register(RealStatePtr L)
        {
		    ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
		    Utils.BeginObjectRegister(typeof(UnityEngine.RectTransform.Axis), L, translator, 0, 0, 0, 0);
			Utils.EndObjectRegister(typeof(UnityEngine.RectTransform.Axis), L, translator, null, null, null, null, null);
			
			Utils.BeginClassRegister(typeof(UnityEngine.RectTransform.Axis), L, null, 3, 0, 0);

            
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "Horizontal", UnityEngine.RectTransform.Axis.Horizontal);
            
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "Vertical", UnityEngine.RectTransform.Axis.Vertical);
            

			Utils.RegisterFunc(L, Utils.CLS_IDX, "__CastFrom", __CastFrom);
            
            Utils.EndClassRegister(typeof(UnityEngine.RectTransform.Axis), L, translator);
        }
		
		[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int __CastFrom(RealStatePtr L)
		{
			ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			LuaTypes lua_type = LuaAPI.lua_type(L, 1);
            if (lua_type == LuaTypes.LUA_TNUMBER)
            {
                translator.PushUnityEngineRectTransformAxis(L, (UnityEngine.RectTransform.Axis)LuaAPI.xlua_tointeger(L, 1));
            }
			
            else if(lua_type == LuaTypes.LUA_TSTRING)
            {

			    if (LuaAPI.xlua_is_eq_str(L, 1, "Horizontal"))
                {
                    translator.PushUnityEngineRectTransformAxis(L, UnityEngine.RectTransform.Axis.Horizontal);
                }
				else if (LuaAPI.xlua_is_eq_str(L, 1, "Vertical"))
                {
                    translator.PushUnityEngineRectTransformAxis(L, UnityEngine.RectTransform.Axis.Vertical);
                }
				else
                {
                    return LuaAPI.luaL_error(L, "invalid string for UnityEngine.RectTransform.Axis!");
                }

            }
			
            else
            {
                return LuaAPI.luaL_error(L, "invalid lua type for UnityEngine.RectTransform.Axis! Expect number or string, got + " + lua_type);
            }

            return 1;
		}
	}
    
    public class UnityEngineEventSystemsPointerEventDataInputButtonWrap
    {
		public static void __Register(RealStatePtr L)
        {
		    ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
		    Utils.BeginObjectRegister(typeof(UnityEngine.EventSystems.PointerEventData.InputButton), L, translator, 0, 0, 0, 0);
			Utils.EndObjectRegister(typeof(UnityEngine.EventSystems.PointerEventData.InputButton), L, translator, null, null, null, null, null);
			
			Utils.BeginClassRegister(typeof(UnityEngine.EventSystems.PointerEventData.InputButton), L, null, 4, 0, 0);

            
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "Left", UnityEngine.EventSystems.PointerEventData.InputButton.Left);
            
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "Right", UnityEngine.EventSystems.PointerEventData.InputButton.Right);
            
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "Middle", UnityEngine.EventSystems.PointerEventData.InputButton.Middle);
            

			Utils.RegisterFunc(L, Utils.CLS_IDX, "__CastFrom", __CastFrom);
            
            Utils.EndClassRegister(typeof(UnityEngine.EventSystems.PointerEventData.InputButton), L, translator);
        }
		
		[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int __CastFrom(RealStatePtr L)
		{
			ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			LuaTypes lua_type = LuaAPI.lua_type(L, 1);
            if (lua_type == LuaTypes.LUA_TNUMBER)
            {
                translator.PushUnityEngineEventSystemsPointerEventDataInputButton(L, (UnityEngine.EventSystems.PointerEventData.InputButton)LuaAPI.xlua_tointeger(L, 1));
            }
			
            else if(lua_type == LuaTypes.LUA_TSTRING)
            {

			    if (LuaAPI.xlua_is_eq_str(L, 1, "Left"))
                {
                    translator.PushUnityEngineEventSystemsPointerEventDataInputButton(L, UnityEngine.EventSystems.PointerEventData.InputButton.Left);
                }
				else if (LuaAPI.xlua_is_eq_str(L, 1, "Right"))
                {
                    translator.PushUnityEngineEventSystemsPointerEventDataInputButton(L, UnityEngine.EventSystems.PointerEventData.InputButton.Right);
                }
				else if (LuaAPI.xlua_is_eq_str(L, 1, "Middle"))
                {
                    translator.PushUnityEngineEventSystemsPointerEventDataInputButton(L, UnityEngine.EventSystems.PointerEventData.InputButton.Middle);
                }
				else
                {
                    return LuaAPI.luaL_error(L, "invalid string for UnityEngine.EventSystems.PointerEventData.InputButton!");
                }

            }
			
            else
            {
                return LuaAPI.luaL_error(L, "invalid lua type for UnityEngine.EventSystems.PointerEventData.InputButton! Expect number or string, got + " + lua_type);
            }

            return 1;
		}
	}
    
    public class UnityEngineEventSystemsPointerEventDataFramePressStateWrap
    {
		public static void __Register(RealStatePtr L)
        {
		    ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
		    Utils.BeginObjectRegister(typeof(UnityEngine.EventSystems.PointerEventData.FramePressState), L, translator, 0, 0, 0, 0);
			Utils.EndObjectRegister(typeof(UnityEngine.EventSystems.PointerEventData.FramePressState), L, translator, null, null, null, null, null);
			
			Utils.BeginClassRegister(typeof(UnityEngine.EventSystems.PointerEventData.FramePressState), L, null, 5, 0, 0);

            
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "Pressed", UnityEngine.EventSystems.PointerEventData.FramePressState.Pressed);
            
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "Released", UnityEngine.EventSystems.PointerEventData.FramePressState.Released);
            
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "PressedAndReleased", UnityEngine.EventSystems.PointerEventData.FramePressState.PressedAndReleased);
            
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "NotChanged", UnityEngine.EventSystems.PointerEventData.FramePressState.NotChanged);
            

			Utils.RegisterFunc(L, Utils.CLS_IDX, "__CastFrom", __CastFrom);
            
            Utils.EndClassRegister(typeof(UnityEngine.EventSystems.PointerEventData.FramePressState), L, translator);
        }
		
		[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int __CastFrom(RealStatePtr L)
		{
			ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			LuaTypes lua_type = LuaAPI.lua_type(L, 1);
            if (lua_type == LuaTypes.LUA_TNUMBER)
            {
                translator.PushUnityEngineEventSystemsPointerEventDataFramePressState(L, (UnityEngine.EventSystems.PointerEventData.FramePressState)LuaAPI.xlua_tointeger(L, 1));
            }
			
            else if(lua_type == LuaTypes.LUA_TSTRING)
            {

			    if (LuaAPI.xlua_is_eq_str(L, 1, "Pressed"))
                {
                    translator.PushUnityEngineEventSystemsPointerEventDataFramePressState(L, UnityEngine.EventSystems.PointerEventData.FramePressState.Pressed);
                }
				else if (LuaAPI.xlua_is_eq_str(L, 1, "Released"))
                {
                    translator.PushUnityEngineEventSystemsPointerEventDataFramePressState(L, UnityEngine.EventSystems.PointerEventData.FramePressState.Released);
                }
				else if (LuaAPI.xlua_is_eq_str(L, 1, "PressedAndReleased"))
                {
                    translator.PushUnityEngineEventSystemsPointerEventDataFramePressState(L, UnityEngine.EventSystems.PointerEventData.FramePressState.PressedAndReleased);
                }
				else if (LuaAPI.xlua_is_eq_str(L, 1, "NotChanged"))
                {
                    translator.PushUnityEngineEventSystemsPointerEventDataFramePressState(L, UnityEngine.EventSystems.PointerEventData.FramePressState.NotChanged);
                }
				else
                {
                    return LuaAPI.luaL_error(L, "invalid string for UnityEngine.EventSystems.PointerEventData.FramePressState!");
                }

            }
			
            else
            {
                return LuaAPI.luaL_error(L, "invalid lua type for UnityEngine.EventSystems.PointerEventData.FramePressState! Expect number or string, got + " + lua_type);
            }

            return 1;
		}
	}
    
    public class UnityEngineRenderTextureFormatWrap
    {
		public static void __Register(RealStatePtr L)
        {
		    ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
		    Utils.BeginObjectRegister(typeof(UnityEngine.RenderTextureFormat), L, translator, 0, 0, 0, 0);
			Utils.EndObjectRegister(typeof(UnityEngine.RenderTextureFormat), L, translator, null, null, null, null, null);
			
			Utils.BeginClassRegister(typeof(UnityEngine.RenderTextureFormat), L, null, 29, 0, 0);

            Utils.RegisterEnumType(L, typeof(UnityEngine.RenderTextureFormat));

			Utils.RegisterFunc(L, Utils.CLS_IDX, "__CastFrom", __CastFrom);
            
            Utils.EndClassRegister(typeof(UnityEngine.RenderTextureFormat), L, translator);
        }
		
		[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int __CastFrom(RealStatePtr L)
		{
			ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			LuaTypes lua_type = LuaAPI.lua_type(L, 1);
            if (lua_type == LuaTypes.LUA_TNUMBER)
            {
                translator.PushUnityEngineRenderTextureFormat(L, (UnityEngine.RenderTextureFormat)LuaAPI.xlua_tointeger(L, 1));
            }
			
            else if(lua_type == LuaTypes.LUA_TSTRING)
            {

                try
				{
                    translator.TranslateToEnumToTop(L, typeof(UnityEngine.RenderTextureFormat), 1);
				}
				catch (System.Exception e)
				{
					return LuaAPI.luaL_error(L, "cast to " + typeof(UnityEngine.RenderTextureFormat) + " exception:" + e);
				}

            }
			
            else
            {
                return LuaAPI.luaL_error(L, "invalid lua type for UnityEngine.RenderTextureFormat! Expect number or string, got + " + lua_type);
            }

            return 1;
		}
	}
    
    public class UnityEngineUISelectableTransitionWrap
    {
		public static void __Register(RealStatePtr L)
        {
		    ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
		    Utils.BeginObjectRegister(typeof(UnityEngine.UI.Selectable.Transition), L, translator, 0, 0, 0, 0);
			Utils.EndObjectRegister(typeof(UnityEngine.UI.Selectable.Transition), L, translator, null, null, null, null, null);
			
			Utils.BeginClassRegister(typeof(UnityEngine.UI.Selectable.Transition), L, null, 5, 0, 0);

            
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "None", UnityEngine.UI.Selectable.Transition.None);
            
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "ColorTint", UnityEngine.UI.Selectable.Transition.ColorTint);
            
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "SpriteSwap", UnityEngine.UI.Selectable.Transition.SpriteSwap);
            
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "Animation", UnityEngine.UI.Selectable.Transition.Animation);
            

			Utils.RegisterFunc(L, Utils.CLS_IDX, "__CastFrom", __CastFrom);
            
            Utils.EndClassRegister(typeof(UnityEngine.UI.Selectable.Transition), L, translator);
        }
		
		[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int __CastFrom(RealStatePtr L)
		{
			ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			LuaTypes lua_type = LuaAPI.lua_type(L, 1);
            if (lua_type == LuaTypes.LUA_TNUMBER)
            {
                translator.PushUnityEngineUISelectableTransition(L, (UnityEngine.UI.Selectable.Transition)LuaAPI.xlua_tointeger(L, 1));
            }
			
            else if(lua_type == LuaTypes.LUA_TSTRING)
            {

			    if (LuaAPI.xlua_is_eq_str(L, 1, "None"))
                {
                    translator.PushUnityEngineUISelectableTransition(L, UnityEngine.UI.Selectable.Transition.None);
                }
				else if (LuaAPI.xlua_is_eq_str(L, 1, "ColorTint"))
                {
                    translator.PushUnityEngineUISelectableTransition(L, UnityEngine.UI.Selectable.Transition.ColorTint);
                }
				else if (LuaAPI.xlua_is_eq_str(L, 1, "SpriteSwap"))
                {
                    translator.PushUnityEngineUISelectableTransition(L, UnityEngine.UI.Selectable.Transition.SpriteSwap);
                }
				else if (LuaAPI.xlua_is_eq_str(L, 1, "Animation"))
                {
                    translator.PushUnityEngineUISelectableTransition(L, UnityEngine.UI.Selectable.Transition.Animation);
                }
				else
                {
                    return LuaAPI.luaL_error(L, "invalid string for UnityEngine.UI.Selectable.Transition!");
                }

            }
			
            else
            {
                return LuaAPI.luaL_error(L, "invalid lua type for UnityEngine.UI.Selectable.Transition! Expect number or string, got + " + lua_type);
            }

            return 1;
		}
	}
    
    public class UnityEngineUIInputFieldContentTypeWrap
    {
		public static void __Register(RealStatePtr L)
        {
		    ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
		    Utils.BeginObjectRegister(typeof(UnityEngine.UI.InputField.ContentType), L, translator, 0, 0, 0, 0);
			Utils.EndObjectRegister(typeof(UnityEngine.UI.InputField.ContentType), L, translator, null, null, null, null, null);
			
			Utils.BeginClassRegister(typeof(UnityEngine.UI.InputField.ContentType), L, null, 11, 0, 0);

            
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "Standard", UnityEngine.UI.InputField.ContentType.Standard);
            
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "Autocorrected", UnityEngine.UI.InputField.ContentType.Autocorrected);
            
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "IntegerNumber", UnityEngine.UI.InputField.ContentType.IntegerNumber);
            
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "DecimalNumber", UnityEngine.UI.InputField.ContentType.DecimalNumber);
            
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "Alphanumeric", UnityEngine.UI.InputField.ContentType.Alphanumeric);
            
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "Name", UnityEngine.UI.InputField.ContentType.Name);
            
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "EmailAddress", UnityEngine.UI.InputField.ContentType.EmailAddress);
            
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "Password", UnityEngine.UI.InputField.ContentType.Password);
            
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "Pin", UnityEngine.UI.InputField.ContentType.Pin);
            
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "Custom", UnityEngine.UI.InputField.ContentType.Custom);
            

			Utils.RegisterFunc(L, Utils.CLS_IDX, "__CastFrom", __CastFrom);
            
            Utils.EndClassRegister(typeof(UnityEngine.UI.InputField.ContentType), L, translator);
        }
		
		[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int __CastFrom(RealStatePtr L)
		{
			ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			LuaTypes lua_type = LuaAPI.lua_type(L, 1);
            if (lua_type == LuaTypes.LUA_TNUMBER)
            {
                translator.PushUnityEngineUIInputFieldContentType(L, (UnityEngine.UI.InputField.ContentType)LuaAPI.xlua_tointeger(L, 1));
            }
			
            else if(lua_type == LuaTypes.LUA_TSTRING)
            {

			    if (LuaAPI.xlua_is_eq_str(L, 1, "Standard"))
                {
                    translator.PushUnityEngineUIInputFieldContentType(L, UnityEngine.UI.InputField.ContentType.Standard);
                }
				else if (LuaAPI.xlua_is_eq_str(L, 1, "Autocorrected"))
                {
                    translator.PushUnityEngineUIInputFieldContentType(L, UnityEngine.UI.InputField.ContentType.Autocorrected);
                }
				else if (LuaAPI.xlua_is_eq_str(L, 1, "IntegerNumber"))
                {
                    translator.PushUnityEngineUIInputFieldContentType(L, UnityEngine.UI.InputField.ContentType.IntegerNumber);
                }
				else if (LuaAPI.xlua_is_eq_str(L, 1, "DecimalNumber"))
                {
                    translator.PushUnityEngineUIInputFieldContentType(L, UnityEngine.UI.InputField.ContentType.DecimalNumber);
                }
				else if (LuaAPI.xlua_is_eq_str(L, 1, "Alphanumeric"))
                {
                    translator.PushUnityEngineUIInputFieldContentType(L, UnityEngine.UI.InputField.ContentType.Alphanumeric);
                }
				else if (LuaAPI.xlua_is_eq_str(L, 1, "Name"))
                {
                    translator.PushUnityEngineUIInputFieldContentType(L, UnityEngine.UI.InputField.ContentType.Name);
                }
				else if (LuaAPI.xlua_is_eq_str(L, 1, "EmailAddress"))
                {
                    translator.PushUnityEngineUIInputFieldContentType(L, UnityEngine.UI.InputField.ContentType.EmailAddress);
                }
				else if (LuaAPI.xlua_is_eq_str(L, 1, "Password"))
                {
                    translator.PushUnityEngineUIInputFieldContentType(L, UnityEngine.UI.InputField.ContentType.Password);
                }
				else if (LuaAPI.xlua_is_eq_str(L, 1, "Pin"))
                {
                    translator.PushUnityEngineUIInputFieldContentType(L, UnityEngine.UI.InputField.ContentType.Pin);
                }
				else if (LuaAPI.xlua_is_eq_str(L, 1, "Custom"))
                {
                    translator.PushUnityEngineUIInputFieldContentType(L, UnityEngine.UI.InputField.ContentType.Custom);
                }
				else
                {
                    return LuaAPI.luaL_error(L, "invalid string for UnityEngine.UI.InputField.ContentType!");
                }

            }
			
            else
            {
                return LuaAPI.luaL_error(L, "invalid lua type for UnityEngine.UI.InputField.ContentType! Expect number or string, got + " + lua_type);
            }

            return 1;
		}
	}
    
    public class UnityEngineUIInputFieldInputTypeWrap
    {
		public static void __Register(RealStatePtr L)
        {
		    ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
		    Utils.BeginObjectRegister(typeof(UnityEngine.UI.InputField.InputType), L, translator, 0, 0, 0, 0);
			Utils.EndObjectRegister(typeof(UnityEngine.UI.InputField.InputType), L, translator, null, null, null, null, null);
			
			Utils.BeginClassRegister(typeof(UnityEngine.UI.InputField.InputType), L, null, 4, 0, 0);

            
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "Standard", UnityEngine.UI.InputField.InputType.Standard);
            
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "AutoCorrect", UnityEngine.UI.InputField.InputType.AutoCorrect);
            
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "Password", UnityEngine.UI.InputField.InputType.Password);
            

			Utils.RegisterFunc(L, Utils.CLS_IDX, "__CastFrom", __CastFrom);
            
            Utils.EndClassRegister(typeof(UnityEngine.UI.InputField.InputType), L, translator);
        }
		
		[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int __CastFrom(RealStatePtr L)
		{
			ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			LuaTypes lua_type = LuaAPI.lua_type(L, 1);
            if (lua_type == LuaTypes.LUA_TNUMBER)
            {
                translator.PushUnityEngineUIInputFieldInputType(L, (UnityEngine.UI.InputField.InputType)LuaAPI.xlua_tointeger(L, 1));
            }
			
            else if(lua_type == LuaTypes.LUA_TSTRING)
            {

			    if (LuaAPI.xlua_is_eq_str(L, 1, "Standard"))
                {
                    translator.PushUnityEngineUIInputFieldInputType(L, UnityEngine.UI.InputField.InputType.Standard);
                }
				else if (LuaAPI.xlua_is_eq_str(L, 1, "AutoCorrect"))
                {
                    translator.PushUnityEngineUIInputFieldInputType(L, UnityEngine.UI.InputField.InputType.AutoCorrect);
                }
				else if (LuaAPI.xlua_is_eq_str(L, 1, "Password"))
                {
                    translator.PushUnityEngineUIInputFieldInputType(L, UnityEngine.UI.InputField.InputType.Password);
                }
				else
                {
                    return LuaAPI.luaL_error(L, "invalid string for UnityEngine.UI.InputField.InputType!");
                }

            }
			
            else
            {
                return LuaAPI.luaL_error(L, "invalid lua type for UnityEngine.UI.InputField.InputType! Expect number or string, got + " + lua_type);
            }

            return 1;
		}
	}
    
    public class UnityEngineUIInputFieldCharacterValidationWrap
    {
		public static void __Register(RealStatePtr L)
        {
		    ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
		    Utils.BeginObjectRegister(typeof(UnityEngine.UI.InputField.CharacterValidation), L, translator, 0, 0, 0, 0);
			Utils.EndObjectRegister(typeof(UnityEngine.UI.InputField.CharacterValidation), L, translator, null, null, null, null, null);
			
			Utils.BeginClassRegister(typeof(UnityEngine.UI.InputField.CharacterValidation), L, null, 7, 0, 0);

            
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "None", UnityEngine.UI.InputField.CharacterValidation.None);
            
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "Integer", UnityEngine.UI.InputField.CharacterValidation.Integer);
            
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "Decimal", UnityEngine.UI.InputField.CharacterValidation.Decimal);
            
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "Alphanumeric", UnityEngine.UI.InputField.CharacterValidation.Alphanumeric);
            
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "Name", UnityEngine.UI.InputField.CharacterValidation.Name);
            
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "EmailAddress", UnityEngine.UI.InputField.CharacterValidation.EmailAddress);
            

			Utils.RegisterFunc(L, Utils.CLS_IDX, "__CastFrom", __CastFrom);
            
            Utils.EndClassRegister(typeof(UnityEngine.UI.InputField.CharacterValidation), L, translator);
        }
		
		[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int __CastFrom(RealStatePtr L)
		{
			ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			LuaTypes lua_type = LuaAPI.lua_type(L, 1);
            if (lua_type == LuaTypes.LUA_TNUMBER)
            {
                translator.PushUnityEngineUIInputFieldCharacterValidation(L, (UnityEngine.UI.InputField.CharacterValidation)LuaAPI.xlua_tointeger(L, 1));
            }
			
            else if(lua_type == LuaTypes.LUA_TSTRING)
            {

			    if (LuaAPI.xlua_is_eq_str(L, 1, "None"))
                {
                    translator.PushUnityEngineUIInputFieldCharacterValidation(L, UnityEngine.UI.InputField.CharacterValidation.None);
                }
				else if (LuaAPI.xlua_is_eq_str(L, 1, "Integer"))
                {
                    translator.PushUnityEngineUIInputFieldCharacterValidation(L, UnityEngine.UI.InputField.CharacterValidation.Integer);
                }
				else if (LuaAPI.xlua_is_eq_str(L, 1, "Decimal"))
                {
                    translator.PushUnityEngineUIInputFieldCharacterValidation(L, UnityEngine.UI.InputField.CharacterValidation.Decimal);
                }
				else if (LuaAPI.xlua_is_eq_str(L, 1, "Alphanumeric"))
                {
                    translator.PushUnityEngineUIInputFieldCharacterValidation(L, UnityEngine.UI.InputField.CharacterValidation.Alphanumeric);
                }
				else if (LuaAPI.xlua_is_eq_str(L, 1, "Name"))
                {
                    translator.PushUnityEngineUIInputFieldCharacterValidation(L, UnityEngine.UI.InputField.CharacterValidation.Name);
                }
				else if (LuaAPI.xlua_is_eq_str(L, 1, "EmailAddress"))
                {
                    translator.PushUnityEngineUIInputFieldCharacterValidation(L, UnityEngine.UI.InputField.CharacterValidation.EmailAddress);
                }
				else
                {
                    return LuaAPI.luaL_error(L, "invalid string for UnityEngine.UI.InputField.CharacterValidation!");
                }

            }
			
            else
            {
                return LuaAPI.luaL_error(L, "invalid lua type for UnityEngine.UI.InputField.CharacterValidation! Expect number or string, got + " + lua_type);
            }

            return 1;
		}
	}
    
    public class UnityEngineUIInputFieldLineTypeWrap
    {
		public static void __Register(RealStatePtr L)
        {
		    ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
		    Utils.BeginObjectRegister(typeof(UnityEngine.UI.InputField.LineType), L, translator, 0, 0, 0, 0);
			Utils.EndObjectRegister(typeof(UnityEngine.UI.InputField.LineType), L, translator, null, null, null, null, null);
			
			Utils.BeginClassRegister(typeof(UnityEngine.UI.InputField.LineType), L, null, 4, 0, 0);

            
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "SingleLine", UnityEngine.UI.InputField.LineType.SingleLine);
            
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "MultiLineSubmit", UnityEngine.UI.InputField.LineType.MultiLineSubmit);
            
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "MultiLineNewline", UnityEngine.UI.InputField.LineType.MultiLineNewline);
            

			Utils.RegisterFunc(L, Utils.CLS_IDX, "__CastFrom", __CastFrom);
            
            Utils.EndClassRegister(typeof(UnityEngine.UI.InputField.LineType), L, translator);
        }
		
		[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int __CastFrom(RealStatePtr L)
		{
			ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			LuaTypes lua_type = LuaAPI.lua_type(L, 1);
            if (lua_type == LuaTypes.LUA_TNUMBER)
            {
                translator.PushUnityEngineUIInputFieldLineType(L, (UnityEngine.UI.InputField.LineType)LuaAPI.xlua_tointeger(L, 1));
            }
			
            else if(lua_type == LuaTypes.LUA_TSTRING)
            {

			    if (LuaAPI.xlua_is_eq_str(L, 1, "SingleLine"))
                {
                    translator.PushUnityEngineUIInputFieldLineType(L, UnityEngine.UI.InputField.LineType.SingleLine);
                }
				else if (LuaAPI.xlua_is_eq_str(L, 1, "MultiLineSubmit"))
                {
                    translator.PushUnityEngineUIInputFieldLineType(L, UnityEngine.UI.InputField.LineType.MultiLineSubmit);
                }
				else if (LuaAPI.xlua_is_eq_str(L, 1, "MultiLineNewline"))
                {
                    translator.PushUnityEngineUIInputFieldLineType(L, UnityEngine.UI.InputField.LineType.MultiLineNewline);
                }
				else
                {
                    return LuaAPI.luaL_error(L, "invalid string for UnityEngine.UI.InputField.LineType!");
                }

            }
			
            else
            {
                return LuaAPI.luaL_error(L, "invalid lua type for UnityEngine.UI.InputField.LineType! Expect number or string, got + " + lua_type);
            }

            return 1;
		}
	}
    
    public class UnityEngineUIImageTypeWrap
    {
		public static void __Register(RealStatePtr L)
        {
		    ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
		    Utils.BeginObjectRegister(typeof(UnityEngine.UI.Image.Type), L, translator, 0, 0, 0, 0);
			Utils.EndObjectRegister(typeof(UnityEngine.UI.Image.Type), L, translator, null, null, null, null, null);
			
			Utils.BeginClassRegister(typeof(UnityEngine.UI.Image.Type), L, null, 5, 0, 0);

            
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "Simple", UnityEngine.UI.Image.Type.Simple);
            
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "Sliced", UnityEngine.UI.Image.Type.Sliced);
            
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "Tiled", UnityEngine.UI.Image.Type.Tiled);
            
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "Filled", UnityEngine.UI.Image.Type.Filled);
            

			Utils.RegisterFunc(L, Utils.CLS_IDX, "__CastFrom", __CastFrom);
            
            Utils.EndClassRegister(typeof(UnityEngine.UI.Image.Type), L, translator);
        }
		
		[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int __CastFrom(RealStatePtr L)
		{
			ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			LuaTypes lua_type = LuaAPI.lua_type(L, 1);
            if (lua_type == LuaTypes.LUA_TNUMBER)
            {
                translator.PushUnityEngineUIImageType(L, (UnityEngine.UI.Image.Type)LuaAPI.xlua_tointeger(L, 1));
            }
			
            else if(lua_type == LuaTypes.LUA_TSTRING)
            {

			    if (LuaAPI.xlua_is_eq_str(L, 1, "Simple"))
                {
                    translator.PushUnityEngineUIImageType(L, UnityEngine.UI.Image.Type.Simple);
                }
				else if (LuaAPI.xlua_is_eq_str(L, 1, "Sliced"))
                {
                    translator.PushUnityEngineUIImageType(L, UnityEngine.UI.Image.Type.Sliced);
                }
				else if (LuaAPI.xlua_is_eq_str(L, 1, "Tiled"))
                {
                    translator.PushUnityEngineUIImageType(L, UnityEngine.UI.Image.Type.Tiled);
                }
				else if (LuaAPI.xlua_is_eq_str(L, 1, "Filled"))
                {
                    translator.PushUnityEngineUIImageType(L, UnityEngine.UI.Image.Type.Filled);
                }
				else
                {
                    return LuaAPI.luaL_error(L, "invalid string for UnityEngine.UI.Image.Type!");
                }

            }
			
            else
            {
                return LuaAPI.luaL_error(L, "invalid lua type for UnityEngine.UI.Image.Type! Expect number or string, got + " + lua_type);
            }

            return 1;
		}
	}
    
    public class UnityEngineUIImageFillMethodWrap
    {
		public static void __Register(RealStatePtr L)
        {
		    ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
		    Utils.BeginObjectRegister(typeof(UnityEngine.UI.Image.FillMethod), L, translator, 0, 0, 0, 0);
			Utils.EndObjectRegister(typeof(UnityEngine.UI.Image.FillMethod), L, translator, null, null, null, null, null);
			
			Utils.BeginClassRegister(typeof(UnityEngine.UI.Image.FillMethod), L, null, 6, 0, 0);

            
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "Horizontal", UnityEngine.UI.Image.FillMethod.Horizontal);
            
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "Vertical", UnityEngine.UI.Image.FillMethod.Vertical);
            
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "Radial90", UnityEngine.UI.Image.FillMethod.Radial90);
            
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "Radial180", UnityEngine.UI.Image.FillMethod.Radial180);
            
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "Radial360", UnityEngine.UI.Image.FillMethod.Radial360);
            

			Utils.RegisterFunc(L, Utils.CLS_IDX, "__CastFrom", __CastFrom);
            
            Utils.EndClassRegister(typeof(UnityEngine.UI.Image.FillMethod), L, translator);
        }
		
		[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int __CastFrom(RealStatePtr L)
		{
			ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			LuaTypes lua_type = LuaAPI.lua_type(L, 1);
            if (lua_type == LuaTypes.LUA_TNUMBER)
            {
                translator.PushUnityEngineUIImageFillMethod(L, (UnityEngine.UI.Image.FillMethod)LuaAPI.xlua_tointeger(L, 1));
            }
			
            else if(lua_type == LuaTypes.LUA_TSTRING)
            {

			    if (LuaAPI.xlua_is_eq_str(L, 1, "Horizontal"))
                {
                    translator.PushUnityEngineUIImageFillMethod(L, UnityEngine.UI.Image.FillMethod.Horizontal);
                }
				else if (LuaAPI.xlua_is_eq_str(L, 1, "Vertical"))
                {
                    translator.PushUnityEngineUIImageFillMethod(L, UnityEngine.UI.Image.FillMethod.Vertical);
                }
				else if (LuaAPI.xlua_is_eq_str(L, 1, "Radial90"))
                {
                    translator.PushUnityEngineUIImageFillMethod(L, UnityEngine.UI.Image.FillMethod.Radial90);
                }
				else if (LuaAPI.xlua_is_eq_str(L, 1, "Radial180"))
                {
                    translator.PushUnityEngineUIImageFillMethod(L, UnityEngine.UI.Image.FillMethod.Radial180);
                }
				else if (LuaAPI.xlua_is_eq_str(L, 1, "Radial360"))
                {
                    translator.PushUnityEngineUIImageFillMethod(L, UnityEngine.UI.Image.FillMethod.Radial360);
                }
				else
                {
                    return LuaAPI.luaL_error(L, "invalid string for UnityEngine.UI.Image.FillMethod!");
                }

            }
			
            else
            {
                return LuaAPI.luaL_error(L, "invalid lua type for UnityEngine.UI.Image.FillMethod! Expect number or string, got + " + lua_type);
            }

            return 1;
		}
	}
    
    public class UnityEngineUIImageOriginHorizontalWrap
    {
		public static void __Register(RealStatePtr L)
        {
		    ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
		    Utils.BeginObjectRegister(typeof(UnityEngine.UI.Image.OriginHorizontal), L, translator, 0, 0, 0, 0);
			Utils.EndObjectRegister(typeof(UnityEngine.UI.Image.OriginHorizontal), L, translator, null, null, null, null, null);
			
			Utils.BeginClassRegister(typeof(UnityEngine.UI.Image.OriginHorizontal), L, null, 3, 0, 0);

            
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "Left", UnityEngine.UI.Image.OriginHorizontal.Left);
            
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "Right", UnityEngine.UI.Image.OriginHorizontal.Right);
            

			Utils.RegisterFunc(L, Utils.CLS_IDX, "__CastFrom", __CastFrom);
            
            Utils.EndClassRegister(typeof(UnityEngine.UI.Image.OriginHorizontal), L, translator);
        }
		
		[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int __CastFrom(RealStatePtr L)
		{
			ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			LuaTypes lua_type = LuaAPI.lua_type(L, 1);
            if (lua_type == LuaTypes.LUA_TNUMBER)
            {
                translator.PushUnityEngineUIImageOriginHorizontal(L, (UnityEngine.UI.Image.OriginHorizontal)LuaAPI.xlua_tointeger(L, 1));
            }
			
            else if(lua_type == LuaTypes.LUA_TSTRING)
            {

			    if (LuaAPI.xlua_is_eq_str(L, 1, "Left"))
                {
                    translator.PushUnityEngineUIImageOriginHorizontal(L, UnityEngine.UI.Image.OriginHorizontal.Left);
                }
				else if (LuaAPI.xlua_is_eq_str(L, 1, "Right"))
                {
                    translator.PushUnityEngineUIImageOriginHorizontal(L, UnityEngine.UI.Image.OriginHorizontal.Right);
                }
				else
                {
                    return LuaAPI.luaL_error(L, "invalid string for UnityEngine.UI.Image.OriginHorizontal!");
                }

            }
			
            else
            {
                return LuaAPI.luaL_error(L, "invalid lua type for UnityEngine.UI.Image.OriginHorizontal! Expect number or string, got + " + lua_type);
            }

            return 1;
		}
	}
    
    public class UnityEngineUIImageOriginVerticalWrap
    {
		public static void __Register(RealStatePtr L)
        {
		    ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
		    Utils.BeginObjectRegister(typeof(UnityEngine.UI.Image.OriginVertical), L, translator, 0, 0, 0, 0);
			Utils.EndObjectRegister(typeof(UnityEngine.UI.Image.OriginVertical), L, translator, null, null, null, null, null);
			
			Utils.BeginClassRegister(typeof(UnityEngine.UI.Image.OriginVertical), L, null, 3, 0, 0);

            
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "Bottom", UnityEngine.UI.Image.OriginVertical.Bottom);
            
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "Top", UnityEngine.UI.Image.OriginVertical.Top);
            

			Utils.RegisterFunc(L, Utils.CLS_IDX, "__CastFrom", __CastFrom);
            
            Utils.EndClassRegister(typeof(UnityEngine.UI.Image.OriginVertical), L, translator);
        }
		
		[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int __CastFrom(RealStatePtr L)
		{
			ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			LuaTypes lua_type = LuaAPI.lua_type(L, 1);
            if (lua_type == LuaTypes.LUA_TNUMBER)
            {
                translator.PushUnityEngineUIImageOriginVertical(L, (UnityEngine.UI.Image.OriginVertical)LuaAPI.xlua_tointeger(L, 1));
            }
			
            else if(lua_type == LuaTypes.LUA_TSTRING)
            {

			    if (LuaAPI.xlua_is_eq_str(L, 1, "Bottom"))
                {
                    translator.PushUnityEngineUIImageOriginVertical(L, UnityEngine.UI.Image.OriginVertical.Bottom);
                }
				else if (LuaAPI.xlua_is_eq_str(L, 1, "Top"))
                {
                    translator.PushUnityEngineUIImageOriginVertical(L, UnityEngine.UI.Image.OriginVertical.Top);
                }
				else
                {
                    return LuaAPI.luaL_error(L, "invalid string for UnityEngine.UI.Image.OriginVertical!");
                }

            }
			
            else
            {
                return LuaAPI.luaL_error(L, "invalid lua type for UnityEngine.UI.Image.OriginVertical! Expect number or string, got + " + lua_type);
            }

            return 1;
		}
	}
    
    public class UnityEngineUIImageOrigin90Wrap
    {
		public static void __Register(RealStatePtr L)
        {
		    ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
		    Utils.BeginObjectRegister(typeof(UnityEngine.UI.Image.Origin90), L, translator, 0, 0, 0, 0);
			Utils.EndObjectRegister(typeof(UnityEngine.UI.Image.Origin90), L, translator, null, null, null, null, null);
			
			Utils.BeginClassRegister(typeof(UnityEngine.UI.Image.Origin90), L, null, 5, 0, 0);

            
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "BottomLeft", UnityEngine.UI.Image.Origin90.BottomLeft);
            
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "TopLeft", UnityEngine.UI.Image.Origin90.TopLeft);
            
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "TopRight", UnityEngine.UI.Image.Origin90.TopRight);
            
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "BottomRight", UnityEngine.UI.Image.Origin90.BottomRight);
            

			Utils.RegisterFunc(L, Utils.CLS_IDX, "__CastFrom", __CastFrom);
            
            Utils.EndClassRegister(typeof(UnityEngine.UI.Image.Origin90), L, translator);
        }
		
		[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int __CastFrom(RealStatePtr L)
		{
			ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			LuaTypes lua_type = LuaAPI.lua_type(L, 1);
            if (lua_type == LuaTypes.LUA_TNUMBER)
            {
                translator.PushUnityEngineUIImageOrigin90(L, (UnityEngine.UI.Image.Origin90)LuaAPI.xlua_tointeger(L, 1));
            }
			
            else if(lua_type == LuaTypes.LUA_TSTRING)
            {

			    if (LuaAPI.xlua_is_eq_str(L, 1, "BottomLeft"))
                {
                    translator.PushUnityEngineUIImageOrigin90(L, UnityEngine.UI.Image.Origin90.BottomLeft);
                }
				else if (LuaAPI.xlua_is_eq_str(L, 1, "TopLeft"))
                {
                    translator.PushUnityEngineUIImageOrigin90(L, UnityEngine.UI.Image.Origin90.TopLeft);
                }
				else if (LuaAPI.xlua_is_eq_str(L, 1, "TopRight"))
                {
                    translator.PushUnityEngineUIImageOrigin90(L, UnityEngine.UI.Image.Origin90.TopRight);
                }
				else if (LuaAPI.xlua_is_eq_str(L, 1, "BottomRight"))
                {
                    translator.PushUnityEngineUIImageOrigin90(L, UnityEngine.UI.Image.Origin90.BottomRight);
                }
				else
                {
                    return LuaAPI.luaL_error(L, "invalid string for UnityEngine.UI.Image.Origin90!");
                }

            }
			
            else
            {
                return LuaAPI.luaL_error(L, "invalid lua type for UnityEngine.UI.Image.Origin90! Expect number or string, got + " + lua_type);
            }

            return 1;
		}
	}
    
    public class UnityEngineUIImageOrigin180Wrap
    {
		public static void __Register(RealStatePtr L)
        {
		    ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
		    Utils.BeginObjectRegister(typeof(UnityEngine.UI.Image.Origin180), L, translator, 0, 0, 0, 0);
			Utils.EndObjectRegister(typeof(UnityEngine.UI.Image.Origin180), L, translator, null, null, null, null, null);
			
			Utils.BeginClassRegister(typeof(UnityEngine.UI.Image.Origin180), L, null, 5, 0, 0);

            
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "Bottom", UnityEngine.UI.Image.Origin180.Bottom);
            
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "Left", UnityEngine.UI.Image.Origin180.Left);
            
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "Top", UnityEngine.UI.Image.Origin180.Top);
            
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "Right", UnityEngine.UI.Image.Origin180.Right);
            

			Utils.RegisterFunc(L, Utils.CLS_IDX, "__CastFrom", __CastFrom);
            
            Utils.EndClassRegister(typeof(UnityEngine.UI.Image.Origin180), L, translator);
        }
		
		[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int __CastFrom(RealStatePtr L)
		{
			ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			LuaTypes lua_type = LuaAPI.lua_type(L, 1);
            if (lua_type == LuaTypes.LUA_TNUMBER)
            {
                translator.PushUnityEngineUIImageOrigin180(L, (UnityEngine.UI.Image.Origin180)LuaAPI.xlua_tointeger(L, 1));
            }
			
            else if(lua_type == LuaTypes.LUA_TSTRING)
            {

			    if (LuaAPI.xlua_is_eq_str(L, 1, "Bottom"))
                {
                    translator.PushUnityEngineUIImageOrigin180(L, UnityEngine.UI.Image.Origin180.Bottom);
                }
				else if (LuaAPI.xlua_is_eq_str(L, 1, "Left"))
                {
                    translator.PushUnityEngineUIImageOrigin180(L, UnityEngine.UI.Image.Origin180.Left);
                }
				else if (LuaAPI.xlua_is_eq_str(L, 1, "Top"))
                {
                    translator.PushUnityEngineUIImageOrigin180(L, UnityEngine.UI.Image.Origin180.Top);
                }
				else if (LuaAPI.xlua_is_eq_str(L, 1, "Right"))
                {
                    translator.PushUnityEngineUIImageOrigin180(L, UnityEngine.UI.Image.Origin180.Right);
                }
				else
                {
                    return LuaAPI.luaL_error(L, "invalid string for UnityEngine.UI.Image.Origin180!");
                }

            }
			
            else
            {
                return LuaAPI.luaL_error(L, "invalid lua type for UnityEngine.UI.Image.Origin180! Expect number or string, got + " + lua_type);
            }

            return 1;
		}
	}
    
    public class UnityEngineUIImageOrigin360Wrap
    {
		public static void __Register(RealStatePtr L)
        {
		    ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
		    Utils.BeginObjectRegister(typeof(UnityEngine.UI.Image.Origin360), L, translator, 0, 0, 0, 0);
			Utils.EndObjectRegister(typeof(UnityEngine.UI.Image.Origin360), L, translator, null, null, null, null, null);
			
			Utils.BeginClassRegister(typeof(UnityEngine.UI.Image.Origin360), L, null, 5, 0, 0);

            
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "Bottom", UnityEngine.UI.Image.Origin360.Bottom);
            
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "Right", UnityEngine.UI.Image.Origin360.Right);
            
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "Top", UnityEngine.UI.Image.Origin360.Top);
            
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "Left", UnityEngine.UI.Image.Origin360.Left);
            

			Utils.RegisterFunc(L, Utils.CLS_IDX, "__CastFrom", __CastFrom);
            
            Utils.EndClassRegister(typeof(UnityEngine.UI.Image.Origin360), L, translator);
        }
		
		[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int __CastFrom(RealStatePtr L)
		{
			ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			LuaTypes lua_type = LuaAPI.lua_type(L, 1);
            if (lua_type == LuaTypes.LUA_TNUMBER)
            {
                translator.PushUnityEngineUIImageOrigin360(L, (UnityEngine.UI.Image.Origin360)LuaAPI.xlua_tointeger(L, 1));
            }
			
            else if(lua_type == LuaTypes.LUA_TSTRING)
            {

			    if (LuaAPI.xlua_is_eq_str(L, 1, "Bottom"))
                {
                    translator.PushUnityEngineUIImageOrigin360(L, UnityEngine.UI.Image.Origin360.Bottom);
                }
				else if (LuaAPI.xlua_is_eq_str(L, 1, "Right"))
                {
                    translator.PushUnityEngineUIImageOrigin360(L, UnityEngine.UI.Image.Origin360.Right);
                }
				else if (LuaAPI.xlua_is_eq_str(L, 1, "Top"))
                {
                    translator.PushUnityEngineUIImageOrigin360(L, UnityEngine.UI.Image.Origin360.Top);
                }
				else if (LuaAPI.xlua_is_eq_str(L, 1, "Left"))
                {
                    translator.PushUnityEngineUIImageOrigin360(L, UnityEngine.UI.Image.Origin360.Left);
                }
				else
                {
                    return LuaAPI.luaL_error(L, "invalid string for UnityEngine.UI.Image.Origin360!");
                }

            }
			
            else
            {
                return LuaAPI.luaL_error(L, "invalid lua type for UnityEngine.UI.Image.Origin360! Expect number or string, got + " + lua_type);
            }

            return 1;
		}
	}
    
    public class UnityEngineUIScrollRectMovementTypeWrap
    {
		public static void __Register(RealStatePtr L)
        {
		    ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
		    Utils.BeginObjectRegister(typeof(UnityEngine.UI.ScrollRect.MovementType), L, translator, 0, 0, 0, 0);
			Utils.EndObjectRegister(typeof(UnityEngine.UI.ScrollRect.MovementType), L, translator, null, null, null, null, null);
			
			Utils.BeginClassRegister(typeof(UnityEngine.UI.ScrollRect.MovementType), L, null, 4, 0, 0);

            
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "Unrestricted", UnityEngine.UI.ScrollRect.MovementType.Unrestricted);
            
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "Elastic", UnityEngine.UI.ScrollRect.MovementType.Elastic);
            
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "Clamped", UnityEngine.UI.ScrollRect.MovementType.Clamped);
            

			Utils.RegisterFunc(L, Utils.CLS_IDX, "__CastFrom", __CastFrom);
            
            Utils.EndClassRegister(typeof(UnityEngine.UI.ScrollRect.MovementType), L, translator);
        }
		
		[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int __CastFrom(RealStatePtr L)
		{
			ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			LuaTypes lua_type = LuaAPI.lua_type(L, 1);
            if (lua_type == LuaTypes.LUA_TNUMBER)
            {
                translator.PushUnityEngineUIScrollRectMovementType(L, (UnityEngine.UI.ScrollRect.MovementType)LuaAPI.xlua_tointeger(L, 1));
            }
			
            else if(lua_type == LuaTypes.LUA_TSTRING)
            {

			    if (LuaAPI.xlua_is_eq_str(L, 1, "Unrestricted"))
                {
                    translator.PushUnityEngineUIScrollRectMovementType(L, UnityEngine.UI.ScrollRect.MovementType.Unrestricted);
                }
				else if (LuaAPI.xlua_is_eq_str(L, 1, "Elastic"))
                {
                    translator.PushUnityEngineUIScrollRectMovementType(L, UnityEngine.UI.ScrollRect.MovementType.Elastic);
                }
				else if (LuaAPI.xlua_is_eq_str(L, 1, "Clamped"))
                {
                    translator.PushUnityEngineUIScrollRectMovementType(L, UnityEngine.UI.ScrollRect.MovementType.Clamped);
                }
				else
                {
                    return LuaAPI.luaL_error(L, "invalid string for UnityEngine.UI.ScrollRect.MovementType!");
                }

            }
			
            else
            {
                return LuaAPI.luaL_error(L, "invalid lua type for UnityEngine.UI.ScrollRect.MovementType! Expect number or string, got + " + lua_type);
            }

            return 1;
		}
	}
    
    public class UnityEngineUIScrollRectScrollbarVisibilityWrap
    {
		public static void __Register(RealStatePtr L)
        {
		    ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
		    Utils.BeginObjectRegister(typeof(UnityEngine.UI.ScrollRect.ScrollbarVisibility), L, translator, 0, 0, 0, 0);
			Utils.EndObjectRegister(typeof(UnityEngine.UI.ScrollRect.ScrollbarVisibility), L, translator, null, null, null, null, null);
			
			Utils.BeginClassRegister(typeof(UnityEngine.UI.ScrollRect.ScrollbarVisibility), L, null, 4, 0, 0);

            
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "Permanent", UnityEngine.UI.ScrollRect.ScrollbarVisibility.Permanent);
            
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "AutoHide", UnityEngine.UI.ScrollRect.ScrollbarVisibility.AutoHide);
            
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "AutoHideAndExpandViewport", UnityEngine.UI.ScrollRect.ScrollbarVisibility.AutoHideAndExpandViewport);
            

			Utils.RegisterFunc(L, Utils.CLS_IDX, "__CastFrom", __CastFrom);
            
            Utils.EndClassRegister(typeof(UnityEngine.UI.ScrollRect.ScrollbarVisibility), L, translator);
        }
		
		[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int __CastFrom(RealStatePtr L)
		{
			ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			LuaTypes lua_type = LuaAPI.lua_type(L, 1);
            if (lua_type == LuaTypes.LUA_TNUMBER)
            {
                translator.PushUnityEngineUIScrollRectScrollbarVisibility(L, (UnityEngine.UI.ScrollRect.ScrollbarVisibility)LuaAPI.xlua_tointeger(L, 1));
            }
			
            else if(lua_type == LuaTypes.LUA_TSTRING)
            {

			    if (LuaAPI.xlua_is_eq_str(L, 1, "Permanent"))
                {
                    translator.PushUnityEngineUIScrollRectScrollbarVisibility(L, UnityEngine.UI.ScrollRect.ScrollbarVisibility.Permanent);
                }
				else if (LuaAPI.xlua_is_eq_str(L, 1, "AutoHide"))
                {
                    translator.PushUnityEngineUIScrollRectScrollbarVisibility(L, UnityEngine.UI.ScrollRect.ScrollbarVisibility.AutoHide);
                }
				else if (LuaAPI.xlua_is_eq_str(L, 1, "AutoHideAndExpandViewport"))
                {
                    translator.PushUnityEngineUIScrollRectScrollbarVisibility(L, UnityEngine.UI.ScrollRect.ScrollbarVisibility.AutoHideAndExpandViewport);
                }
				else
                {
                    return LuaAPI.luaL_error(L, "invalid string for UnityEngine.UI.ScrollRect.ScrollbarVisibility!");
                }

            }
			
            else
            {
                return LuaAPI.luaL_error(L, "invalid lua type for UnityEngine.UI.ScrollRect.ScrollbarVisibility! Expect number or string, got + " + lua_type);
            }

            return 1;
		}
	}
    
    public class UnityEngineUISliderDirectionWrap
    {
		public static void __Register(RealStatePtr L)
        {
		    ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
		    Utils.BeginObjectRegister(typeof(UnityEngine.UI.Slider.Direction), L, translator, 0, 0, 0, 0);
			Utils.EndObjectRegister(typeof(UnityEngine.UI.Slider.Direction), L, translator, null, null, null, null, null);
			
			Utils.BeginClassRegister(typeof(UnityEngine.UI.Slider.Direction), L, null, 5, 0, 0);

            
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "LeftToRight", UnityEngine.UI.Slider.Direction.LeftToRight);
            
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "RightToLeft", UnityEngine.UI.Slider.Direction.RightToLeft);
            
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "BottomToTop", UnityEngine.UI.Slider.Direction.BottomToTop);
            
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "TopToBottom", UnityEngine.UI.Slider.Direction.TopToBottom);
            

			Utils.RegisterFunc(L, Utils.CLS_IDX, "__CastFrom", __CastFrom);
            
            Utils.EndClassRegister(typeof(UnityEngine.UI.Slider.Direction), L, translator);
        }
		
		[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int __CastFrom(RealStatePtr L)
		{
			ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			LuaTypes lua_type = LuaAPI.lua_type(L, 1);
            if (lua_type == LuaTypes.LUA_TNUMBER)
            {
                translator.PushUnityEngineUISliderDirection(L, (UnityEngine.UI.Slider.Direction)LuaAPI.xlua_tointeger(L, 1));
            }
			
            else if(lua_type == LuaTypes.LUA_TSTRING)
            {

			    if (LuaAPI.xlua_is_eq_str(L, 1, "LeftToRight"))
                {
                    translator.PushUnityEngineUISliderDirection(L, UnityEngine.UI.Slider.Direction.LeftToRight);
                }
				else if (LuaAPI.xlua_is_eq_str(L, 1, "RightToLeft"))
                {
                    translator.PushUnityEngineUISliderDirection(L, UnityEngine.UI.Slider.Direction.RightToLeft);
                }
				else if (LuaAPI.xlua_is_eq_str(L, 1, "BottomToTop"))
                {
                    translator.PushUnityEngineUISliderDirection(L, UnityEngine.UI.Slider.Direction.BottomToTop);
                }
				else if (LuaAPI.xlua_is_eq_str(L, 1, "TopToBottom"))
                {
                    translator.PushUnityEngineUISliderDirection(L, UnityEngine.UI.Slider.Direction.TopToBottom);
                }
				else
                {
                    return LuaAPI.luaL_error(L, "invalid string for UnityEngine.UI.Slider.Direction!");
                }

            }
			
            else
            {
                return LuaAPI.luaL_error(L, "invalid lua type for UnityEngine.UI.Slider.Direction! Expect number or string, got + " + lua_type);
            }

            return 1;
		}
	}
    
    public class UnityEngineUIToggleToggleTransitionWrap
    {
		public static void __Register(RealStatePtr L)
        {
		    ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
		    Utils.BeginObjectRegister(typeof(UnityEngine.UI.Toggle.ToggleTransition), L, translator, 0, 0, 0, 0);
			Utils.EndObjectRegister(typeof(UnityEngine.UI.Toggle.ToggleTransition), L, translator, null, null, null, null, null);
			
			Utils.BeginClassRegister(typeof(UnityEngine.UI.Toggle.ToggleTransition), L, null, 3, 0, 0);

            
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "None", UnityEngine.UI.Toggle.ToggleTransition.None);
            
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "Fade", UnityEngine.UI.Toggle.ToggleTransition.Fade);
            

			Utils.RegisterFunc(L, Utils.CLS_IDX, "__CastFrom", __CastFrom);
            
            Utils.EndClassRegister(typeof(UnityEngine.UI.Toggle.ToggleTransition), L, translator);
        }
		
		[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int __CastFrom(RealStatePtr L)
		{
			ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			LuaTypes lua_type = LuaAPI.lua_type(L, 1);
            if (lua_type == LuaTypes.LUA_TNUMBER)
            {
                translator.PushUnityEngineUIToggleToggleTransition(L, (UnityEngine.UI.Toggle.ToggleTransition)LuaAPI.xlua_tointeger(L, 1));
            }
			
            else if(lua_type == LuaTypes.LUA_TSTRING)
            {

			    if (LuaAPI.xlua_is_eq_str(L, 1, "None"))
                {
                    translator.PushUnityEngineUIToggleToggleTransition(L, UnityEngine.UI.Toggle.ToggleTransition.None);
                }
				else if (LuaAPI.xlua_is_eq_str(L, 1, "Fade"))
                {
                    translator.PushUnityEngineUIToggleToggleTransition(L, UnityEngine.UI.Toggle.ToggleTransition.Fade);
                }
				else
                {
                    return LuaAPI.luaL_error(L, "invalid string for UnityEngine.UI.Toggle.ToggleTransition!");
                }

            }
			
            else
            {
                return LuaAPI.luaL_error(L, "invalid lua type for UnityEngine.UI.Toggle.ToggleTransition! Expect number or string, got + " + lua_type);
            }

            return 1;
		}
	}
    
    public class SuperTextMeshAlignmentWrap
    {
		public static void __Register(RealStatePtr L)
        {
		    ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
		    Utils.BeginObjectRegister(typeof(SuperTextMesh.Alignment), L, translator, 0, 0, 0, 0);
			Utils.EndObjectRegister(typeof(SuperTextMesh.Alignment), L, translator, null, null, null, null, null);
			
			Utils.BeginClassRegister(typeof(SuperTextMesh.Alignment), L, null, 10, 0, 0);

            
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "TopLeft", SuperTextMesh.Alignment.TopLeft);
            
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "TopCenter", SuperTextMesh.Alignment.TopCenter);
            
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "TopRight", SuperTextMesh.Alignment.TopRight);
            
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "MidLeft", SuperTextMesh.Alignment.MidLeft);
            
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "MidCenter", SuperTextMesh.Alignment.MidCenter);
            
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "MidRight", SuperTextMesh.Alignment.MidRight);
            
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "BotLeft", SuperTextMesh.Alignment.BotLeft);
            
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "BotCenter", SuperTextMesh.Alignment.BotCenter);
            
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "BotRight", SuperTextMesh.Alignment.BotRight);
            

			Utils.RegisterFunc(L, Utils.CLS_IDX, "__CastFrom", __CastFrom);
            
            Utils.EndClassRegister(typeof(SuperTextMesh.Alignment), L, translator);
        }
		
		[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int __CastFrom(RealStatePtr L)
		{
			ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			LuaTypes lua_type = LuaAPI.lua_type(L, 1);
            if (lua_type == LuaTypes.LUA_TNUMBER)
            {
                translator.PushSuperTextMeshAlignment(L, (SuperTextMesh.Alignment)LuaAPI.xlua_tointeger(L, 1));
            }
			
            else if(lua_type == LuaTypes.LUA_TSTRING)
            {

			    if (LuaAPI.xlua_is_eq_str(L, 1, "TopLeft"))
                {
                    translator.PushSuperTextMeshAlignment(L, SuperTextMesh.Alignment.TopLeft);
                }
				else if (LuaAPI.xlua_is_eq_str(L, 1, "TopCenter"))
                {
                    translator.PushSuperTextMeshAlignment(L, SuperTextMesh.Alignment.TopCenter);
                }
				else if (LuaAPI.xlua_is_eq_str(L, 1, "TopRight"))
                {
                    translator.PushSuperTextMeshAlignment(L, SuperTextMesh.Alignment.TopRight);
                }
				else if (LuaAPI.xlua_is_eq_str(L, 1, "MidLeft"))
                {
                    translator.PushSuperTextMeshAlignment(L, SuperTextMesh.Alignment.MidLeft);
                }
				else if (LuaAPI.xlua_is_eq_str(L, 1, "MidCenter"))
                {
                    translator.PushSuperTextMeshAlignment(L, SuperTextMesh.Alignment.MidCenter);
                }
				else if (LuaAPI.xlua_is_eq_str(L, 1, "MidRight"))
                {
                    translator.PushSuperTextMeshAlignment(L, SuperTextMesh.Alignment.MidRight);
                }
				else if (LuaAPI.xlua_is_eq_str(L, 1, "BotLeft"))
                {
                    translator.PushSuperTextMeshAlignment(L, SuperTextMesh.Alignment.BotLeft);
                }
				else if (LuaAPI.xlua_is_eq_str(L, 1, "BotCenter"))
                {
                    translator.PushSuperTextMeshAlignment(L, SuperTextMesh.Alignment.BotCenter);
                }
				else if (LuaAPI.xlua_is_eq_str(L, 1, "BotRight"))
                {
                    translator.PushSuperTextMeshAlignment(L, SuperTextMesh.Alignment.BotRight);
                }
				else
                {
                    return LuaAPI.luaL_error(L, "invalid string for SuperTextMesh.Alignment!");
                }

            }
			
            else
            {
                return LuaAPI.luaL_error(L, "invalid lua type for SuperTextMesh.Alignment! Expect number or string, got + " + lua_type);
            }

            return 1;
		}
	}
    
    public class UnityEngineAINavMeshPathStatusWrap
    {
		public static void __Register(RealStatePtr L)
        {
		    ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
		    Utils.BeginObjectRegister(typeof(UnityEngine.AI.NavMeshPathStatus), L, translator, 0, 0, 0, 0);
			Utils.EndObjectRegister(typeof(UnityEngine.AI.NavMeshPathStatus), L, translator, null, null, null, null, null);
			
			Utils.BeginClassRegister(typeof(UnityEngine.AI.NavMeshPathStatus), L, null, 4, 0, 0);

            
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "PathComplete", UnityEngine.AI.NavMeshPathStatus.PathComplete);
            
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "PathPartial", UnityEngine.AI.NavMeshPathStatus.PathPartial);
            
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "PathInvalid", UnityEngine.AI.NavMeshPathStatus.PathInvalid);
            

			Utils.RegisterFunc(L, Utils.CLS_IDX, "__CastFrom", __CastFrom);
            
            Utils.EndClassRegister(typeof(UnityEngine.AI.NavMeshPathStatus), L, translator);
        }
		
		[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int __CastFrom(RealStatePtr L)
		{
			ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			LuaTypes lua_type = LuaAPI.lua_type(L, 1);
            if (lua_type == LuaTypes.LUA_TNUMBER)
            {
                translator.PushUnityEngineAINavMeshPathStatus(L, (UnityEngine.AI.NavMeshPathStatus)LuaAPI.xlua_tointeger(L, 1));
            }
			
            else if(lua_type == LuaTypes.LUA_TSTRING)
            {

			    if (LuaAPI.xlua_is_eq_str(L, 1, "PathComplete"))
                {
                    translator.PushUnityEngineAINavMeshPathStatus(L, UnityEngine.AI.NavMeshPathStatus.PathComplete);
                }
				else if (LuaAPI.xlua_is_eq_str(L, 1, "PathPartial"))
                {
                    translator.PushUnityEngineAINavMeshPathStatus(L, UnityEngine.AI.NavMeshPathStatus.PathPartial);
                }
				else if (LuaAPI.xlua_is_eq_str(L, 1, "PathInvalid"))
                {
                    translator.PushUnityEngineAINavMeshPathStatus(L, UnityEngine.AI.NavMeshPathStatus.PathInvalid);
                }
				else
                {
                    return LuaAPI.luaL_error(L, "invalid string for UnityEngine.AI.NavMeshPathStatus!");
                }

            }
			
            else
            {
                return LuaAPI.luaL_error(L, "invalid lua type for UnityEngine.AI.NavMeshPathStatus! Expect number or string, got + " + lua_type);
            }

            return 1;
		}
	}
    
    public class ScrollViewMovementTypeWrap
    {
		public static void __Register(RealStatePtr L)
        {
		    ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
		    Utils.BeginObjectRegister(typeof(ScrollView.MovementType), L, translator, 0, 0, 0, 0);
			Utils.EndObjectRegister(typeof(ScrollView.MovementType), L, translator, null, null, null, null, null);
			
			Utils.BeginClassRegister(typeof(ScrollView.MovementType), L, null, 4, 0, 0);

            
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "Unrestricted", ScrollView.MovementType.Unrestricted);
            
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "Elastic", ScrollView.MovementType.Elastic);
            
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "Clamped", ScrollView.MovementType.Clamped);
            

			Utils.RegisterFunc(L, Utils.CLS_IDX, "__CastFrom", __CastFrom);
            
            Utils.EndClassRegister(typeof(ScrollView.MovementType), L, translator);
        }
		
		[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int __CastFrom(RealStatePtr L)
		{
			ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			LuaTypes lua_type = LuaAPI.lua_type(L, 1);
            if (lua_type == LuaTypes.LUA_TNUMBER)
            {
                translator.PushScrollViewMovementType(L, (ScrollView.MovementType)LuaAPI.xlua_tointeger(L, 1));
            }
			
            else if(lua_type == LuaTypes.LUA_TSTRING)
            {

			    if (LuaAPI.xlua_is_eq_str(L, 1, "Unrestricted"))
                {
                    translator.PushScrollViewMovementType(L, ScrollView.MovementType.Unrestricted);
                }
				else if (LuaAPI.xlua_is_eq_str(L, 1, "Elastic"))
                {
                    translator.PushScrollViewMovementType(L, ScrollView.MovementType.Elastic);
                }
				else if (LuaAPI.xlua_is_eq_str(L, 1, "Clamped"))
                {
                    translator.PushScrollViewMovementType(L, ScrollView.MovementType.Clamped);
                }
				else
                {
                    return LuaAPI.luaL_error(L, "invalid string for ScrollView.MovementType!");
                }

            }
			
            else
            {
                return LuaAPI.luaL_error(L, "invalid lua type for ScrollView.MovementType! Expect number or string, got + " + lua_type);
            }

            return 1;
		}
	}
    
    public class ScrollViewScrollbarVisibilityWrap
    {
		public static void __Register(RealStatePtr L)
        {
		    ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
		    Utils.BeginObjectRegister(typeof(ScrollView.ScrollbarVisibility), L, translator, 0, 0, 0, 0);
			Utils.EndObjectRegister(typeof(ScrollView.ScrollbarVisibility), L, translator, null, null, null, null, null);
			
			Utils.BeginClassRegister(typeof(ScrollView.ScrollbarVisibility), L, null, 4, 0, 0);

            
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "Permanent", ScrollView.ScrollbarVisibility.Permanent);
            
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "AutoHide", ScrollView.ScrollbarVisibility.AutoHide);
            
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "AutoHideAndExpandViewport", ScrollView.ScrollbarVisibility.AutoHideAndExpandViewport);
            

			Utils.RegisterFunc(L, Utils.CLS_IDX, "__CastFrom", __CastFrom);
            
            Utils.EndClassRegister(typeof(ScrollView.ScrollbarVisibility), L, translator);
        }
		
		[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int __CastFrom(RealStatePtr L)
		{
			ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			LuaTypes lua_type = LuaAPI.lua_type(L, 1);
            if (lua_type == LuaTypes.LUA_TNUMBER)
            {
                translator.PushScrollViewScrollbarVisibility(L, (ScrollView.ScrollbarVisibility)LuaAPI.xlua_tointeger(L, 1));
            }
			
            else if(lua_type == LuaTypes.LUA_TSTRING)
            {

			    if (LuaAPI.xlua_is_eq_str(L, 1, "Permanent"))
                {
                    translator.PushScrollViewScrollbarVisibility(L, ScrollView.ScrollbarVisibility.Permanent);
                }
				else if (LuaAPI.xlua_is_eq_str(L, 1, "AutoHide"))
                {
                    translator.PushScrollViewScrollbarVisibility(L, ScrollView.ScrollbarVisibility.AutoHide);
                }
				else if (LuaAPI.xlua_is_eq_str(L, 1, "AutoHideAndExpandViewport"))
                {
                    translator.PushScrollViewScrollbarVisibility(L, ScrollView.ScrollbarVisibility.AutoHideAndExpandViewport);
                }
				else
                {
                    return LuaAPI.luaL_error(L, "invalid string for ScrollView.ScrollbarVisibility!");
                }

            }
			
            else
            {
                return LuaAPI.luaL_error(L, "invalid lua type for ScrollView.ScrollbarVisibility! Expect number or string, got + " + lua_type);
            }

            return 1;
		}
	}
    
    public class ScrollViewScrollViewLayoutTypeWrap
    {
		public static void __Register(RealStatePtr L)
        {
		    ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
		    Utils.BeginObjectRegister(typeof(ScrollView.ScrollViewLayoutType), L, translator, 0, 0, 0, 0);
			Utils.EndObjectRegister(typeof(ScrollView.ScrollViewLayoutType), L, translator, null, null, null, null, null);
			
			Utils.BeginClassRegister(typeof(ScrollView.ScrollViewLayoutType), L, null, 3, 0, 0);

            
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "Horizontal", ScrollView.ScrollViewLayoutType.Horizontal);
            
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "Vertical", ScrollView.ScrollViewLayoutType.Vertical);
            

			Utils.RegisterFunc(L, Utils.CLS_IDX, "__CastFrom", __CastFrom);
            
            Utils.EndClassRegister(typeof(ScrollView.ScrollViewLayoutType), L, translator);
        }
		
		[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int __CastFrom(RealStatePtr L)
		{
			ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			LuaTypes lua_type = LuaAPI.lua_type(L, 1);
            if (lua_type == LuaTypes.LUA_TNUMBER)
            {
                translator.PushScrollViewScrollViewLayoutType(L, (ScrollView.ScrollViewLayoutType)LuaAPI.xlua_tointeger(L, 1));
            }
			
            else if(lua_type == LuaTypes.LUA_TSTRING)
            {

			    if (LuaAPI.xlua_is_eq_str(L, 1, "Horizontal"))
                {
                    translator.PushScrollViewScrollViewLayoutType(L, ScrollView.ScrollViewLayoutType.Horizontal);
                }
				else if (LuaAPI.xlua_is_eq_str(L, 1, "Vertical"))
                {
                    translator.PushScrollViewScrollViewLayoutType(L, ScrollView.ScrollViewLayoutType.Vertical);
                }
				else
                {
                    return LuaAPI.luaL_error(L, "invalid string for ScrollView.ScrollViewLayoutType!");
                }

            }
			
            else
            {
                return LuaAPI.luaL_error(L, "invalid lua type for ScrollView.ScrollViewLayoutType! Expect number or string, got + " + lua_type);
            }

            return 1;
		}
	}
    
    public class UnityEngineTouchPhaseWrap
    {
		public static void __Register(RealStatePtr L)
        {
		    ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
		    Utils.BeginObjectRegister(typeof(UnityEngine.TouchPhase), L, translator, 0, 0, 0, 0);
			Utils.EndObjectRegister(typeof(UnityEngine.TouchPhase), L, translator, null, null, null, null, null);
			
			Utils.BeginClassRegister(typeof(UnityEngine.TouchPhase), L, null, 6, 0, 0);

            
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "Began", UnityEngine.TouchPhase.Began);
            
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "Moved", UnityEngine.TouchPhase.Moved);
            
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "Stationary", UnityEngine.TouchPhase.Stationary);
            
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "Ended", UnityEngine.TouchPhase.Ended);
            
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "Canceled", UnityEngine.TouchPhase.Canceled);
            

			Utils.RegisterFunc(L, Utils.CLS_IDX, "__CastFrom", __CastFrom);
            
            Utils.EndClassRegister(typeof(UnityEngine.TouchPhase), L, translator);
        }
		
		[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int __CastFrom(RealStatePtr L)
		{
			ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			LuaTypes lua_type = LuaAPI.lua_type(L, 1);
            if (lua_type == LuaTypes.LUA_TNUMBER)
            {
                translator.PushUnityEngineTouchPhase(L, (UnityEngine.TouchPhase)LuaAPI.xlua_tointeger(L, 1));
            }
			
            else if(lua_type == LuaTypes.LUA_TSTRING)
            {

			    if (LuaAPI.xlua_is_eq_str(L, 1, "Began"))
                {
                    translator.PushUnityEngineTouchPhase(L, UnityEngine.TouchPhase.Began);
                }
				else if (LuaAPI.xlua_is_eq_str(L, 1, "Moved"))
                {
                    translator.PushUnityEngineTouchPhase(L, UnityEngine.TouchPhase.Moved);
                }
				else if (LuaAPI.xlua_is_eq_str(L, 1, "Stationary"))
                {
                    translator.PushUnityEngineTouchPhase(L, UnityEngine.TouchPhase.Stationary);
                }
				else if (LuaAPI.xlua_is_eq_str(L, 1, "Ended"))
                {
                    translator.PushUnityEngineTouchPhase(L, UnityEngine.TouchPhase.Ended);
                }
				else if (LuaAPI.xlua_is_eq_str(L, 1, "Canceled"))
                {
                    translator.PushUnityEngineTouchPhase(L, UnityEngine.TouchPhase.Canceled);
                }
				else
                {
                    return LuaAPI.luaL_error(L, "invalid string for UnityEngine.TouchPhase!");
                }

            }
			
            else
            {
                return LuaAPI.luaL_error(L, "invalid lua type for UnityEngine.TouchPhase! Expect number or string, got + " + lua_type);
            }

            return 1;
		}
	}
    
    public class ResourceManagerPreloadTypeWrap
    {
		public static void __Register(RealStatePtr L)
        {
		    ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
		    Utils.BeginObjectRegister(typeof(ResourceManager.PreloadType), L, translator, 0, 0, 0, 0);
			Utils.EndObjectRegister(typeof(ResourceManager.PreloadType), L, translator, null, null, null, null, null);
			
			Utils.BeginClassRegister(typeof(ResourceManager.PreloadType), L, null, 3, 0, 0);

            
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "Cache", ResourceManager.PreloadType.Cache);
            
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "KeepAlive", ResourceManager.PreloadType.KeepAlive);
            

			Utils.RegisterFunc(L, Utils.CLS_IDX, "__CastFrom", __CastFrom);
            
            Utils.EndClassRegister(typeof(ResourceManager.PreloadType), L, translator);
        }
		
		[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int __CastFrom(RealStatePtr L)
		{
			ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			LuaTypes lua_type = LuaAPI.lua_type(L, 1);
            if (lua_type == LuaTypes.LUA_TNUMBER)
            {
                translator.PushResourceManagerPreloadType(L, (ResourceManager.PreloadType)LuaAPI.xlua_tointeger(L, 1));
            }
			
            else if(lua_type == LuaTypes.LUA_TSTRING)
            {

			    if (LuaAPI.xlua_is_eq_str(L, 1, "Cache"))
                {
                    translator.PushResourceManagerPreloadType(L, ResourceManager.PreloadType.Cache);
                }
				else if (LuaAPI.xlua_is_eq_str(L, 1, "KeepAlive"))
                {
                    translator.PushResourceManagerPreloadType(L, ResourceManager.PreloadType.KeepAlive);
                }
				else
                {
                    return LuaAPI.luaL_error(L, "invalid string for ResourceManager.PreloadType!");
                }

            }
			
            else
            {
                return LuaAPI.luaL_error(L, "invalid lua type for ResourceManager.PreloadType! Expect number or string, got + " + lua_type);
            }

            return 1;
		}
	}
    
    public class SceneManagerSceneIDWrap
    {
		public static void __Register(RealStatePtr L)
        {
		    ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
		    Utils.BeginObjectRegister(typeof(SceneManager.SceneID), L, translator, 0, 0, 0, 0);
			Utils.EndObjectRegister(typeof(SceneManager.SceneID), L, translator, null, null, null, null, null);
			
			Utils.BeginClassRegister(typeof(SceneManager.SceneID), L, null, 6, 0, 0);

            
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "None", SceneManager.SceneID.None);
            
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "City", SceneManager.SceneID.City);
            
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "World", SceneManager.SceneID.World);
            
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "PVE", SceneManager.SceneID.PVE);
            
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "Bridge", SceneManager.SceneID.Bridge);
            

			Utils.RegisterFunc(L, Utils.CLS_IDX, "__CastFrom", __CastFrom);
            
            Utils.EndClassRegister(typeof(SceneManager.SceneID), L, translator);
        }
		
		[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int __CastFrom(RealStatePtr L)
		{
			ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			LuaTypes lua_type = LuaAPI.lua_type(L, 1);
            if (lua_type == LuaTypes.LUA_TNUMBER)
            {
                translator.PushSceneManagerSceneID(L, (SceneManager.SceneID)LuaAPI.xlua_tointeger(L, 1));
            }
			
            else if(lua_type == LuaTypes.LUA_TSTRING)
            {

			    if (LuaAPI.xlua_is_eq_str(L, 1, "None"))
                {
                    translator.PushSceneManagerSceneID(L, SceneManager.SceneID.None);
                }
				else if (LuaAPI.xlua_is_eq_str(L, 1, "City"))
                {
                    translator.PushSceneManagerSceneID(L, SceneManager.SceneID.City);
                }
				else if (LuaAPI.xlua_is_eq_str(L, 1, "World"))
                {
                    translator.PushSceneManagerSceneID(L, SceneManager.SceneID.World);
                }
				else if (LuaAPI.xlua_is_eq_str(L, 1, "PVE"))
                {
                    translator.PushSceneManagerSceneID(L, SceneManager.SceneID.PVE);
                }
				else if (LuaAPI.xlua_is_eq_str(L, 1, "Bridge"))
                {
                    translator.PushSceneManagerSceneID(L, SceneManager.SceneID.Bridge);
                }
				else
                {
                    return LuaAPI.luaL_error(L, "invalid string for SceneManager.SceneID!");
                }

            }
			
            else
            {
                return LuaAPI.luaL_error(L, "invalid lua type for SceneManager.SceneID! Expect number or string, got + " + lua_type);
            }

            return 1;
		}
	}
    
    public class NewQueueStateWrap
    {
		public static void __Register(RealStatePtr L)
        {
		    ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
		    Utils.BeginObjectRegister(typeof(NewQueueState), L, translator, 0, 0, 0, 0);
			Utils.EndObjectRegister(typeof(NewQueueState), L, translator, null, null, null, null, null);
			
			Utils.BeginClassRegister(typeof(NewQueueState), L, null, 5, 0, 0);

            
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "Free", NewQueueState.Free);
            
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "Prepare", NewQueueState.Prepare);
            
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "Work", NewQueueState.Work);
            
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "Finish", NewQueueState.Finish);
            

			Utils.RegisterFunc(L, Utils.CLS_IDX, "__CastFrom", __CastFrom);
            
            Utils.EndClassRegister(typeof(NewQueueState), L, translator);
        }
		
		[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int __CastFrom(RealStatePtr L)
		{
			ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			LuaTypes lua_type = LuaAPI.lua_type(L, 1);
            if (lua_type == LuaTypes.LUA_TNUMBER)
            {
                translator.PushNewQueueState(L, (NewQueueState)LuaAPI.xlua_tointeger(L, 1));
            }
			
            else if(lua_type == LuaTypes.LUA_TSTRING)
            {

			    if (LuaAPI.xlua_is_eq_str(L, 1, "Free"))
                {
                    translator.PushNewQueueState(L, NewQueueState.Free);
                }
				else if (LuaAPI.xlua_is_eq_str(L, 1, "Prepare"))
                {
                    translator.PushNewQueueState(L, NewQueueState.Prepare);
                }
				else if (LuaAPI.xlua_is_eq_str(L, 1, "Work"))
                {
                    translator.PushNewQueueState(L, NewQueueState.Work);
                }
				else if (LuaAPI.xlua_is_eq_str(L, 1, "Finish"))
                {
                    translator.PushNewQueueState(L, NewQueueState.Finish);
                }
				else
                {
                    return LuaAPI.luaL_error(L, "invalid string for NewQueueState!");
                }

            }
			
            else
            {
                return LuaAPI.luaL_error(L, "invalid lua type for NewQueueState! Expect number or string, got + " + lua_type);
            }

            return 1;
		}
	}
    
    public class ResourceTypeWrap
    {
		public static void __Register(RealStatePtr L)
        {
		    ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
		    Utils.BeginObjectRegister(typeof(ResourceType), L, translator, 0, 0, 0, 0);
			Utils.EndObjectRegister(typeof(ResourceType), L, translator, null, null, null, null, null);
			
			Utils.BeginClassRegister(typeof(ResourceType), L, null, 8, 0, 0);

            
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "None", ResourceType.None);
            
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "Oil", ResourceType.Oil);
            
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "Metal", ResourceType.Metal);
            
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "Water", ResourceType.Water);
            
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "Electricity", ResourceType.Electricity);
            
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "Money", ResourceType.Money);
            
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "GOLD", ResourceType.GOLD);
            

			Utils.RegisterFunc(L, Utils.CLS_IDX, "__CastFrom", __CastFrom);
            
            Utils.EndClassRegister(typeof(ResourceType), L, translator);
        }
		
		[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int __CastFrom(RealStatePtr L)
		{
			ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			LuaTypes lua_type = LuaAPI.lua_type(L, 1);
            if (lua_type == LuaTypes.LUA_TNUMBER)
            {
                translator.PushResourceType(L, (ResourceType)LuaAPI.xlua_tointeger(L, 1));
            }
			
            else if(lua_type == LuaTypes.LUA_TSTRING)
            {

			    if (LuaAPI.xlua_is_eq_str(L, 1, "None"))
                {
                    translator.PushResourceType(L, ResourceType.None);
                }
				else if (LuaAPI.xlua_is_eq_str(L, 1, "Oil"))
                {
                    translator.PushResourceType(L, ResourceType.Oil);
                }
				else if (LuaAPI.xlua_is_eq_str(L, 1, "Metal"))
                {
                    translator.PushResourceType(L, ResourceType.Metal);
                }
				else if (LuaAPI.xlua_is_eq_str(L, 1, "Water"))
                {
                    translator.PushResourceType(L, ResourceType.Water);
                }
				else if (LuaAPI.xlua_is_eq_str(L, 1, "Electricity"))
                {
                    translator.PushResourceType(L, ResourceType.Electricity);
                }
				else if (LuaAPI.xlua_is_eq_str(L, 1, "Money"))
                {
                    translator.PushResourceType(L, ResourceType.Money);
                }
				else if (LuaAPI.xlua_is_eq_str(L, 1, "GOLD"))
                {
                    translator.PushResourceType(L, ResourceType.GOLD);
                }
				else
                {
                    return LuaAPI.luaL_error(L, "invalid string for ResourceType!");
                }

            }
			
            else
            {
                return LuaAPI.luaL_error(L, "invalid lua type for ResourceType! Expect number or string, got + " + lua_type);
            }

            return 1;
		}
	}
    
    public class BuildingStateWrap
    {
		public static void __Register(RealStatePtr L)
        {
		    ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
		    Utils.BeginObjectRegister(typeof(BuildingState), L, translator, 0, 0, 0, 0);
			Utils.EndObjectRegister(typeof(BuildingState), L, translator, null, null, null, null, null);
			
			Utils.BeginClassRegister(typeof(BuildingState), L, null, 10, 0, 0);

            
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "None", BuildingState.None);
            
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "FindingPathState", BuildingState.FindingPathState);
            
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "PrepareBuild", BuildingState.PrepareBuild);
            
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "Building", BuildingState.Building);
            
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "Upgrading", BuildingState.Upgrading);
            
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "Idle", BuildingState.Idle);
            
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "Moving", BuildingState.Moving);
            
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "Producting", BuildingState.Producting);
            
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "WaitCollecting", BuildingState.WaitCollecting);
            

			Utils.RegisterFunc(L, Utils.CLS_IDX, "__CastFrom", __CastFrom);
            
            Utils.EndClassRegister(typeof(BuildingState), L, translator);
        }
		
		[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int __CastFrom(RealStatePtr L)
		{
			ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			LuaTypes lua_type = LuaAPI.lua_type(L, 1);
            if (lua_type == LuaTypes.LUA_TNUMBER)
            {
                translator.PushBuildingState(L, (BuildingState)LuaAPI.xlua_tointeger(L, 1));
            }
			
            else if(lua_type == LuaTypes.LUA_TSTRING)
            {

			    if (LuaAPI.xlua_is_eq_str(L, 1, "None"))
                {
                    translator.PushBuildingState(L, BuildingState.None);
                }
				else if (LuaAPI.xlua_is_eq_str(L, 1, "FindingPathState"))
                {
                    translator.PushBuildingState(L, BuildingState.FindingPathState);
                }
				else if (LuaAPI.xlua_is_eq_str(L, 1, "PrepareBuild"))
                {
                    translator.PushBuildingState(L, BuildingState.PrepareBuild);
                }
				else if (LuaAPI.xlua_is_eq_str(L, 1, "Building"))
                {
                    translator.PushBuildingState(L, BuildingState.Building);
                }
				else if (LuaAPI.xlua_is_eq_str(L, 1, "Upgrading"))
                {
                    translator.PushBuildingState(L, BuildingState.Upgrading);
                }
				else if (LuaAPI.xlua_is_eq_str(L, 1, "Idle"))
                {
                    translator.PushBuildingState(L, BuildingState.Idle);
                }
				else if (LuaAPI.xlua_is_eq_str(L, 1, "Moving"))
                {
                    translator.PushBuildingState(L, BuildingState.Moving);
                }
				else if (LuaAPI.xlua_is_eq_str(L, 1, "Producting"))
                {
                    translator.PushBuildingState(L, BuildingState.Producting);
                }
				else if (LuaAPI.xlua_is_eq_str(L, 1, "WaitCollecting"))
                {
                    translator.PushBuildingState(L, BuildingState.WaitCollecting);
                }
				else
                {
                    return LuaAPI.luaL_error(L, "invalid string for BuildingState!");
                }

            }
			
            else
            {
                return LuaAPI.luaL_error(L, "invalid lua type for BuildingState! Expect number or string, got + " + lua_type);
            }

            return 1;
		}
	}
    
    public class PlaceBuildTypeWrap
    {
		public static void __Register(RealStatePtr L)
        {
		    ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
		    Utils.BeginObjectRegister(typeof(PlaceBuildType), L, translator, 0, 0, 0, 0);
			Utils.EndObjectRegister(typeof(PlaceBuildType), L, translator, null, null, null, null, null);
			
			Utils.BeginClassRegister(typeof(PlaceBuildType), L, null, 6, 0, 0);

            
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "None", PlaceBuildType.None);
            
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "Build", PlaceBuildType.Build);
            
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "Move", PlaceBuildType.Move);
            
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "Replace", PlaceBuildType.Replace);
            
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "MoveCity", PlaceBuildType.MoveCity);
            

			Utils.RegisterFunc(L, Utils.CLS_IDX, "__CastFrom", __CastFrom);
            
            Utils.EndClassRegister(typeof(PlaceBuildType), L, translator);
        }
		
		[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int __CastFrom(RealStatePtr L)
		{
			ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			LuaTypes lua_type = LuaAPI.lua_type(L, 1);
            if (lua_type == LuaTypes.LUA_TNUMBER)
            {
                translator.PushPlaceBuildType(L, (PlaceBuildType)LuaAPI.xlua_tointeger(L, 1));
            }
			
            else if(lua_type == LuaTypes.LUA_TSTRING)
            {

			    if (LuaAPI.xlua_is_eq_str(L, 1, "None"))
                {
                    translator.PushPlaceBuildType(L, PlaceBuildType.None);
                }
				else if (LuaAPI.xlua_is_eq_str(L, 1, "Build"))
                {
                    translator.PushPlaceBuildType(L, PlaceBuildType.Build);
                }
				else if (LuaAPI.xlua_is_eq_str(L, 1, "Move"))
                {
                    translator.PushPlaceBuildType(L, PlaceBuildType.Move);
                }
				else if (LuaAPI.xlua_is_eq_str(L, 1, "Replace"))
                {
                    translator.PushPlaceBuildType(L, PlaceBuildType.Replace);
                }
				else if (LuaAPI.xlua_is_eq_str(L, 1, "MoveCity"))
                {
                    translator.PushPlaceBuildType(L, PlaceBuildType.MoveCity);
                }
				else
                {
                    return LuaAPI.luaL_error(L, "invalid string for PlaceBuildType!");
                }

            }
			
            else
            {
                return LuaAPI.luaL_error(L, "invalid lua type for PlaceBuildType! Expect number or string, got + " + lua_type);
            }

            return 1;
		}
	}
    
    public class MarchStatusWrap
    {
		public static void __Register(RealStatePtr L)
        {
		    ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
		    Utils.BeginObjectRegister(typeof(MarchStatus), L, translator, 0, 0, 0, 0);
			Utils.EndObjectRegister(typeof(MarchStatus), L, translator, null, null, null, null, null);
			
			Utils.BeginClassRegister(typeof(MarchStatus), L, null, 24, 0, 0);

            Utils.RegisterEnumType(L, typeof(MarchStatus));

			Utils.RegisterFunc(L, Utils.CLS_IDX, "__CastFrom", __CastFrom);
            
            Utils.EndClassRegister(typeof(MarchStatus), L, translator);
        }
		
		[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int __CastFrom(RealStatePtr L)
		{
			ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			LuaTypes lua_type = LuaAPI.lua_type(L, 1);
            if (lua_type == LuaTypes.LUA_TNUMBER)
            {
                translator.PushMarchStatus(L, (MarchStatus)LuaAPI.xlua_tointeger(L, 1));
            }
			
            else if(lua_type == LuaTypes.LUA_TSTRING)
            {

                try
				{
                    translator.TranslateToEnumToTop(L, typeof(MarchStatus), 1);
				}
				catch (System.Exception e)
				{
					return LuaAPI.luaL_error(L, "cast to " + typeof(MarchStatus) + " exception:" + e);
				}

            }
			
            else
            {
                return LuaAPI.luaL_error(L, "invalid lua type for MarchStatus! Expect number or string, got + " + lua_type);
            }

            return 1;
		}
	}
    
    public class UnityEngineTimelineClipCapsWrap
    {
		public static void __Register(RealStatePtr L)
        {
		    ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
		    Utils.BeginObjectRegister(typeof(UnityEngine.Timeline.ClipCaps), L, translator, 0, 0, 0, 0);
			Utils.EndObjectRegister(typeof(UnityEngine.Timeline.ClipCaps), L, translator, null, null, null, null, null);
			
			Utils.BeginClassRegister(typeof(UnityEngine.Timeline.ClipCaps), L, null, 9, 0, 0);

            
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "None", UnityEngine.Timeline.ClipCaps.None);
            
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "Looping", UnityEngine.Timeline.ClipCaps.Looping);
            
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "Extrapolation", UnityEngine.Timeline.ClipCaps.Extrapolation);
            
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "ClipIn", UnityEngine.Timeline.ClipCaps.ClipIn);
            
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "SpeedMultiplier", UnityEngine.Timeline.ClipCaps.SpeedMultiplier);
            
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "Blending", UnityEngine.Timeline.ClipCaps.Blending);
            
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "AutoScale", UnityEngine.Timeline.ClipCaps.AutoScale);
            
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "All", UnityEngine.Timeline.ClipCaps.All);
            

			Utils.RegisterFunc(L, Utils.CLS_IDX, "__CastFrom", __CastFrom);
            
            Utils.EndClassRegister(typeof(UnityEngine.Timeline.ClipCaps), L, translator);
        }
		
		[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int __CastFrom(RealStatePtr L)
		{
			ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			LuaTypes lua_type = LuaAPI.lua_type(L, 1);
            if (lua_type == LuaTypes.LUA_TNUMBER)
            {
                translator.PushUnityEngineTimelineClipCaps(L, (UnityEngine.Timeline.ClipCaps)LuaAPI.xlua_tointeger(L, 1));
            }
			
            else if(lua_type == LuaTypes.LUA_TSTRING)
            {

			    if (LuaAPI.xlua_is_eq_str(L, 1, "None"))
                {
                    translator.PushUnityEngineTimelineClipCaps(L, UnityEngine.Timeline.ClipCaps.None);
                }
				else if (LuaAPI.xlua_is_eq_str(L, 1, "Looping"))
                {
                    translator.PushUnityEngineTimelineClipCaps(L, UnityEngine.Timeline.ClipCaps.Looping);
                }
				else if (LuaAPI.xlua_is_eq_str(L, 1, "Extrapolation"))
                {
                    translator.PushUnityEngineTimelineClipCaps(L, UnityEngine.Timeline.ClipCaps.Extrapolation);
                }
				else if (LuaAPI.xlua_is_eq_str(L, 1, "ClipIn"))
                {
                    translator.PushUnityEngineTimelineClipCaps(L, UnityEngine.Timeline.ClipCaps.ClipIn);
                }
				else if (LuaAPI.xlua_is_eq_str(L, 1, "SpeedMultiplier"))
                {
                    translator.PushUnityEngineTimelineClipCaps(L, UnityEngine.Timeline.ClipCaps.SpeedMultiplier);
                }
				else if (LuaAPI.xlua_is_eq_str(L, 1, "Blending"))
                {
                    translator.PushUnityEngineTimelineClipCaps(L, UnityEngine.Timeline.ClipCaps.Blending);
                }
				else if (LuaAPI.xlua_is_eq_str(L, 1, "AutoScale"))
                {
                    translator.PushUnityEngineTimelineClipCaps(L, UnityEngine.Timeline.ClipCaps.AutoScale);
                }
				else if (LuaAPI.xlua_is_eq_str(L, 1, "All"))
                {
                    translator.PushUnityEngineTimelineClipCaps(L, UnityEngine.Timeline.ClipCaps.All);
                }
				else
                {
                    return LuaAPI.luaL_error(L, "invalid string for UnityEngine.Timeline.ClipCaps!");
                }

            }
			
            else
            {
                return LuaAPI.luaL_error(L, "invalid lua type for UnityEngine.Timeline.ClipCaps! Expect number or string, got + " + lua_type);
            }

            return 1;
		}
	}
    
    public class InstanceRequestStateWrap
    {
		public static void __Register(RealStatePtr L)
        {
		    ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
		    Utils.BeginObjectRegister(typeof(InstanceRequest.State), L, translator, 0, 0, 0, 0);
			Utils.EndObjectRegister(typeof(InstanceRequest.State), L, translator, null, null, null, null, null);
			
			Utils.BeginClassRegister(typeof(InstanceRequest.State), L, null, 5, 0, 0);

            
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "Init", InstanceRequest.State.Init);
            
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "Loading", InstanceRequest.State.Loading);
            
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "Instanced", InstanceRequest.State.Instanced);
            
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "Destroy", InstanceRequest.State.Destroy);
            

			Utils.RegisterFunc(L, Utils.CLS_IDX, "__CastFrom", __CastFrom);
            
            Utils.EndClassRegister(typeof(InstanceRequest.State), L, translator);
        }
		
		[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int __CastFrom(RealStatePtr L)
		{
			ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			LuaTypes lua_type = LuaAPI.lua_type(L, 1);
            if (lua_type == LuaTypes.LUA_TNUMBER)
            {
                translator.PushInstanceRequestState(L, (InstanceRequest.State)LuaAPI.xlua_tointeger(L, 1));
            }
			
            else if(lua_type == LuaTypes.LUA_TSTRING)
            {

			    if (LuaAPI.xlua_is_eq_str(L, 1, "Init"))
                {
                    translator.PushInstanceRequestState(L, InstanceRequest.State.Init);
                }
				else if (LuaAPI.xlua_is_eq_str(L, 1, "Loading"))
                {
                    translator.PushInstanceRequestState(L, InstanceRequest.State.Loading);
                }
				else if (LuaAPI.xlua_is_eq_str(L, 1, "Instanced"))
                {
                    translator.PushInstanceRequestState(L, InstanceRequest.State.Instanced);
                }
				else if (LuaAPI.xlua_is_eq_str(L, 1, "Destroy"))
                {
                    translator.PushInstanceRequestState(L, InstanceRequest.State.Destroy);
                }
				else
                {
                    return LuaAPI.luaL_error(L, "invalid string for InstanceRequest.State!");
                }

            }
			
            else
            {
                return LuaAPI.luaL_error(L, "invalid lua type for InstanceRequest.State! Expect number or string, got + " + lua_type);
            }

            return 1;
		}
	}
    
    public class NewMarchTypeWrap
    {
		public static void __Register(RealStatePtr L)
        {
		    ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
		    Utils.BeginObjectRegister(typeof(NewMarchType), L, translator, 0, 0, 0, 0);
			Utils.EndObjectRegister(typeof(NewMarchType), L, translator, null, null, null, null, null);
			
			Utils.BeginClassRegister(typeof(NewMarchType), L, null, 17, 0, 0);

            
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "DEFAULT", NewMarchType.DEFAULT);
            
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "NORMAL", NewMarchType.NORMAL);
            
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "ASSEMBLY_MARCH", NewMarchType.ASSEMBLY_MARCH);
            
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "MONSTER", NewMarchType.MONSTER);
            
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "BOSS", NewMarchType.BOSS);
            
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "SCOUT", NewMarchType.SCOUT);
            
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "EXPLORE", NewMarchType.EXPLORE);
            
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "RESOURCE_HELP", NewMarchType.RESOURCE_HELP);
            
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "GOLLOES_EXPLORE", NewMarchType.GOLLOES_EXPLORE);
            
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "GOLLOES_TRADE", NewMarchType.GOLLOES_TRADE);
            
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "ACT_BOSS", NewMarchType.ACT_BOSS);
            
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "PUZZLE_BOSS", NewMarchType.PUZZLE_BOSS);
            
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "DIRECT_MOVE_MARCH", NewMarchType.DIRECT_MOVE_MARCH);
            
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "CHALLENGE_BOSS", NewMarchType.CHALLENGE_BOSS);
            
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "MONSTER_SIEGE", NewMarchType.MONSTER_SIEGE);
            
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "ALLIANCE_BOSS", NewMarchType.ALLIANCE_BOSS);
            

			Utils.RegisterFunc(L, Utils.CLS_IDX, "__CastFrom", __CastFrom);
            
            Utils.EndClassRegister(typeof(NewMarchType), L, translator);
        }
		
		[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int __CastFrom(RealStatePtr L)
		{
			ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			LuaTypes lua_type = LuaAPI.lua_type(L, 1);
            if (lua_type == LuaTypes.LUA_TNUMBER)
            {
                translator.PushNewMarchType(L, (NewMarchType)LuaAPI.xlua_tointeger(L, 1));
            }
			
            else if(lua_type == LuaTypes.LUA_TSTRING)
            {

			    if (LuaAPI.xlua_is_eq_str(L, 1, "DEFAULT"))
                {
                    translator.PushNewMarchType(L, NewMarchType.DEFAULT);
                }
				else if (LuaAPI.xlua_is_eq_str(L, 1, "NORMAL"))
                {
                    translator.PushNewMarchType(L, NewMarchType.NORMAL);
                }
				else if (LuaAPI.xlua_is_eq_str(L, 1, "ASSEMBLY_MARCH"))
                {
                    translator.PushNewMarchType(L, NewMarchType.ASSEMBLY_MARCH);
                }
				else if (LuaAPI.xlua_is_eq_str(L, 1, "MONSTER"))
                {
                    translator.PushNewMarchType(L, NewMarchType.MONSTER);
                }
				else if (LuaAPI.xlua_is_eq_str(L, 1, "BOSS"))
                {
                    translator.PushNewMarchType(L, NewMarchType.BOSS);
                }
				else if (LuaAPI.xlua_is_eq_str(L, 1, "SCOUT"))
                {
                    translator.PushNewMarchType(L, NewMarchType.SCOUT);
                }
				else if (LuaAPI.xlua_is_eq_str(L, 1, "EXPLORE"))
                {
                    translator.PushNewMarchType(L, NewMarchType.EXPLORE);
                }
				else if (LuaAPI.xlua_is_eq_str(L, 1, "RESOURCE_HELP"))
                {
                    translator.PushNewMarchType(L, NewMarchType.RESOURCE_HELP);
                }
				else if (LuaAPI.xlua_is_eq_str(L, 1, "GOLLOES_EXPLORE"))
                {
                    translator.PushNewMarchType(L, NewMarchType.GOLLOES_EXPLORE);
                }
				else if (LuaAPI.xlua_is_eq_str(L, 1, "GOLLOES_TRADE"))
                {
                    translator.PushNewMarchType(L, NewMarchType.GOLLOES_TRADE);
                }
				else if (LuaAPI.xlua_is_eq_str(L, 1, "ACT_BOSS"))
                {
                    translator.PushNewMarchType(L, NewMarchType.ACT_BOSS);
                }
				else if (LuaAPI.xlua_is_eq_str(L, 1, "PUZZLE_BOSS"))
                {
                    translator.PushNewMarchType(L, NewMarchType.PUZZLE_BOSS);
                }
				else if (LuaAPI.xlua_is_eq_str(L, 1, "DIRECT_MOVE_MARCH"))
                {
                    translator.PushNewMarchType(L, NewMarchType.DIRECT_MOVE_MARCH);
                }
				else if (LuaAPI.xlua_is_eq_str(L, 1, "CHALLENGE_BOSS"))
                {
                    translator.PushNewMarchType(L, NewMarchType.CHALLENGE_BOSS);
                }
				else if (LuaAPI.xlua_is_eq_str(L, 1, "MONSTER_SIEGE"))
                {
                    translator.PushNewMarchType(L, NewMarchType.MONSTER_SIEGE);
                }
				else if (LuaAPI.xlua_is_eq_str(L, 1, "ALLIANCE_BOSS"))
                {
                    translator.PushNewMarchType(L, NewMarchType.ALLIANCE_BOSS);
                }
				else
                {
                    return LuaAPI.luaL_error(L, "invalid string for NewMarchType!");
                }

            }
			
            else
            {
                return LuaAPI.luaL_error(L, "invalid lua type for NewMarchType! Expect number or string, got + " + lua_type);
            }

            return 1;
		}
	}
    
    public class WorldPointTypeWrap
    {
		public static void __Register(RealStatePtr L)
        {
		    ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
		    Utils.BeginObjectRegister(typeof(WorldPointType), L, translator, 0, 0, 0, 0);
			Utils.EndObjectRegister(typeof(WorldPointType), L, translator, null, null, null, null, null);
			
			Utils.BeginClassRegister(typeof(WorldPointType), L, null, 28, 0, 0);

            Utils.RegisterEnumType(L, typeof(WorldPointType));

			Utils.RegisterFunc(L, Utils.CLS_IDX, "__CastFrom", __CastFrom);
            
            Utils.EndClassRegister(typeof(WorldPointType), L, translator);
        }
		
		[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int __CastFrom(RealStatePtr L)
		{
			ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			LuaTypes lua_type = LuaAPI.lua_type(L, 1);
            if (lua_type == LuaTypes.LUA_TNUMBER)
            {
                translator.PushWorldPointType(L, (WorldPointType)LuaAPI.xlua_tointeger(L, 1));
            }
			
            else if(lua_type == LuaTypes.LUA_TSTRING)
            {

                try
				{
                    translator.TranslateToEnumToTop(L, typeof(WorldPointType), 1);
				}
				catch (System.Exception e)
				{
					return LuaAPI.luaL_error(L, "cast to " + typeof(WorldPointType) + " exception:" + e);
				}

            }
			
            else
            {
                return LuaAPI.luaL_error(L, "invalid lua type for WorldPointType! Expect number or string, got + " + lua_type);
            }

            return 1;
		}
	}
    
}