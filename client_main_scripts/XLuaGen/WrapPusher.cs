#if USE_UNI_LUA
using LuaAPI = UniLua.Lua;
using RealStatePtr = UniLua.ILuaState;
using LuaCSFunction = UniLua.CSharpFunctionDelegate;
#else
using LuaAPI = XLua.LuaDLL.Lua;
using RealStatePtr = System.IntPtr;
using LuaCSFunction = XLua.LuaDLL.lua_CSFunction;
#endif

using System;


namespace XLua
{
    public static partial class ObjectTranslator_Gen
    {
		public static void Init(LuaEnv luaenv, ObjectTranslator translator)
		{
		
			UnityEngineVector2_TypeID = -1;
		
			UnityEngineVector3_TypeID = -1;
		
			UnityEngineVector4_TypeID = -1;
		
			UnityEngineColor_TypeID = -1;
		
			UnityEngineQuaternion_TypeID = -1;
		
			UnityEngineRay_TypeID = -1;
		
			UnityEngineBounds_TypeID = -1;
		
			UnityEngineRay2D_TypeID = -1;
		
			UnityEngineCameraGateFitMode_TypeID = -1;
			UnityEngineCameraGateFitMode_EnumRef = -1;
		
			UnityEngineCameraFieldOfViewAxis_TypeID = -1;
			UnityEngineCameraFieldOfViewAxis_EnumRef = -1;
		
			DGTweeningDOTweenAnimationAnimationType_TypeID = -1;
			DGTweeningDOTweenAnimationAnimationType_EnumRef = -1;
		
			DGTweeningDOTweenAnimationTargetType_TypeID = -1;
			DGTweeningDOTweenAnimationTargetType_EnumRef = -1;
		
			UnityEngineRectTransformEdge_TypeID = -1;
			UnityEngineRectTransformEdge_EnumRef = -1;
		
			UnityEngineRectTransformAxis_TypeID = -1;
			UnityEngineRectTransformAxis_EnumRef = -1;
		
			UnityEngineEventSystemsPointerEventDataInputButton_TypeID = -1;
			UnityEngineEventSystemsPointerEventDataInputButton_EnumRef = -1;
		
			UnityEngineEventSystemsPointerEventDataFramePressState_TypeID = -1;
			UnityEngineEventSystemsPointerEventDataFramePressState_EnumRef = -1;
		
			UnityEngineRenderTextureFormat_TypeID = -1;
			UnityEngineRenderTextureFormat_EnumRef = -1;
		
			UnityEngineUISelectableTransition_TypeID = -1;
			UnityEngineUISelectableTransition_EnumRef = -1;
		
			UnityEngineUIInputFieldContentType_TypeID = -1;
			UnityEngineUIInputFieldContentType_EnumRef = -1;
		
			UnityEngineUIInputFieldInputType_TypeID = -1;
			UnityEngineUIInputFieldInputType_EnumRef = -1;
		
			UnityEngineUIInputFieldCharacterValidation_TypeID = -1;
			UnityEngineUIInputFieldCharacterValidation_EnumRef = -1;
		
			UnityEngineUIInputFieldLineType_TypeID = -1;
			UnityEngineUIInputFieldLineType_EnumRef = -1;
		
			UnityEngineUIImageType_TypeID = -1;
			UnityEngineUIImageType_EnumRef = -1;
		
			UnityEngineUIImageFillMethod_TypeID = -1;
			UnityEngineUIImageFillMethod_EnumRef = -1;
		
			UnityEngineUIImageOriginHorizontal_TypeID = -1;
			UnityEngineUIImageOriginHorizontal_EnumRef = -1;
		
			UnityEngineUIImageOriginVertical_TypeID = -1;
			UnityEngineUIImageOriginVertical_EnumRef = -1;
		
			UnityEngineUIImageOrigin90_TypeID = -1;
			UnityEngineUIImageOrigin90_EnumRef = -1;
		
			UnityEngineUIImageOrigin180_TypeID = -1;
			UnityEngineUIImageOrigin180_EnumRef = -1;
		
			UnityEngineUIImageOrigin360_TypeID = -1;
			UnityEngineUIImageOrigin360_EnumRef = -1;
		
			UnityEngineUIScrollRectMovementType_TypeID = -1;
			UnityEngineUIScrollRectMovementType_EnumRef = -1;
		
			UnityEngineUIScrollRectScrollbarVisibility_TypeID = -1;
			UnityEngineUIScrollRectScrollbarVisibility_EnumRef = -1;
		
			UnityEngineUISliderDirection_TypeID = -1;
			UnityEngineUISliderDirection_EnumRef = -1;
		
			UnityEngineUIToggleToggleTransition_TypeID = -1;
			UnityEngineUIToggleToggleTransition_EnumRef = -1;
		
			SuperTextMeshAlignment_TypeID = -1;
			SuperTextMeshAlignment_EnumRef = -1;
		
			UnityEngineAINavMeshPathStatus_TypeID = -1;
			UnityEngineAINavMeshPathStatus_EnumRef = -1;
		
			ScrollViewMovementType_TypeID = -1;
			ScrollViewMovementType_EnumRef = -1;
		
			ScrollViewScrollbarVisibility_TypeID = -1;
			ScrollViewScrollbarVisibility_EnumRef = -1;
		
			ScrollViewScrollViewLayoutType_TypeID = -1;
			ScrollViewScrollViewLayoutType_EnumRef = -1;
		
			UnityEngineTouchPhase_TypeID = -1;
			UnityEngineTouchPhase_EnumRef = -1;
		
			ResourceManagerPreloadType_TypeID = -1;
			ResourceManagerPreloadType_EnumRef = -1;
		
			SceneManagerSceneID_TypeID = -1;
			SceneManagerSceneID_EnumRef = -1;
		
			NewQueueState_TypeID = -1;
			NewQueueState_EnumRef = -1;
		
			ResourceType_TypeID = -1;
			ResourceType_EnumRef = -1;
		
			BuildingState_TypeID = -1;
			BuildingState_EnumRef = -1;
		
			PlaceBuildType_TypeID = -1;
			PlaceBuildType_EnumRef = -1;
		
			MarchStatus_TypeID = -1;
			MarchStatus_EnumRef = -1;
		
			UnityEngineTimelineClipCaps_TypeID = -1;
			UnityEngineTimelineClipCaps_EnumRef = -1;
		
			InstanceRequestState_TypeID = -1;
			InstanceRequestState_EnumRef = -1;
		
			NewMarchType_TypeID = -1;
			NewMarchType_EnumRef = -1;
		
			WorldPointType_TypeID = -1;
			WorldPointType_EnumRef = -1;
		

		
			translator.RegisterPushAndGetAndUpdate<UnityEngine.Vector2>(translator.PushUnityEngineVector2, translator.GetUnityEngineVector2, translator.UpdateUnityEngineVector2);
			translator.RegisterPushAndGetAndUpdate<UnityEngine.Vector3>(translator.PushUnityEngineVector3, translator.GetUnityEngineVector3, translator.UpdateUnityEngineVector3);
			translator.RegisterPushAndGetAndUpdate<UnityEngine.Vector4>(translator.PushUnityEngineVector4, translator.GetUnityEngineVector4, translator.UpdateUnityEngineVector4);
			translator.RegisterPushAndGetAndUpdate<UnityEngine.Color>(translator.PushUnityEngineColor, translator.GetUnityEngineColor, translator.UpdateUnityEngineColor);
			translator.RegisterPushAndGetAndUpdate<UnityEngine.Quaternion>(translator.PushUnityEngineQuaternion, translator.GetUnityEngineQuaternion, translator.UpdateUnityEngineQuaternion);
			translator.RegisterPushAndGetAndUpdate<UnityEngine.Ray>(translator.PushUnityEngineRay, translator.GetUnityEngineRay, translator.UpdateUnityEngineRay);
			translator.RegisterPushAndGetAndUpdate<UnityEngine.Bounds>(translator.PushUnityEngineBounds, translator.GetUnityEngineBounds, translator.UpdateUnityEngineBounds);
			translator.RegisterPushAndGetAndUpdate<UnityEngine.Ray2D>(translator.PushUnityEngineRay2D, translator.GetUnityEngineRay2D, translator.UpdateUnityEngineRay2D);
			translator.RegisterPushAndGetAndUpdate<UnityEngine.Camera.GateFitMode>(translator.PushUnityEngineCameraGateFitMode, translator.GetUnityEngineCameraGateFitMode, translator.UpdateUnityEngineCameraGateFitMode);
			translator.RegisterPushAndGetAndUpdate<UnityEngine.Camera.FieldOfViewAxis>(translator.PushUnityEngineCameraFieldOfViewAxis, translator.GetUnityEngineCameraFieldOfViewAxis, translator.UpdateUnityEngineCameraFieldOfViewAxis);
			translator.RegisterPushAndGetAndUpdate<DG.Tweening.DOTweenAnimation.AnimationType>(translator.PushDGTweeningDOTweenAnimationAnimationType, translator.GetDGTweeningDOTweenAnimationAnimationType, translator.UpdateDGTweeningDOTweenAnimationAnimationType);
			translator.RegisterPushAndGetAndUpdate<DG.Tweening.DOTweenAnimation.TargetType>(translator.PushDGTweeningDOTweenAnimationTargetType, translator.GetDGTweeningDOTweenAnimationTargetType, translator.UpdateDGTweeningDOTweenAnimationTargetType);
			translator.RegisterPushAndGetAndUpdate<UnityEngine.RectTransform.Edge>(translator.PushUnityEngineRectTransformEdge, translator.GetUnityEngineRectTransformEdge, translator.UpdateUnityEngineRectTransformEdge);
			translator.RegisterPushAndGetAndUpdate<UnityEngine.RectTransform.Axis>(translator.PushUnityEngineRectTransformAxis, translator.GetUnityEngineRectTransformAxis, translator.UpdateUnityEngineRectTransformAxis);
			translator.RegisterPushAndGetAndUpdate<UnityEngine.EventSystems.PointerEventData.InputButton>(translator.PushUnityEngineEventSystemsPointerEventDataInputButton, translator.GetUnityEngineEventSystemsPointerEventDataInputButton, translator.UpdateUnityEngineEventSystemsPointerEventDataInputButton);
			translator.RegisterPushAndGetAndUpdate<UnityEngine.EventSystems.PointerEventData.FramePressState>(translator.PushUnityEngineEventSystemsPointerEventDataFramePressState, translator.GetUnityEngineEventSystemsPointerEventDataFramePressState, translator.UpdateUnityEngineEventSystemsPointerEventDataFramePressState);
			translator.RegisterPushAndGetAndUpdate<UnityEngine.RenderTextureFormat>(translator.PushUnityEngineRenderTextureFormat, translator.GetUnityEngineRenderTextureFormat, translator.UpdateUnityEngineRenderTextureFormat);
			translator.RegisterPushAndGetAndUpdate<UnityEngine.UI.Selectable.Transition>(translator.PushUnityEngineUISelectableTransition, translator.GetUnityEngineUISelectableTransition, translator.UpdateUnityEngineUISelectableTransition);
			translator.RegisterPushAndGetAndUpdate<UnityEngine.UI.InputField.ContentType>(translator.PushUnityEngineUIInputFieldContentType, translator.GetUnityEngineUIInputFieldContentType, translator.UpdateUnityEngineUIInputFieldContentType);
			translator.RegisterPushAndGetAndUpdate<UnityEngine.UI.InputField.InputType>(translator.PushUnityEngineUIInputFieldInputType, translator.GetUnityEngineUIInputFieldInputType, translator.UpdateUnityEngineUIInputFieldInputType);
			translator.RegisterPushAndGetAndUpdate<UnityEngine.UI.InputField.CharacterValidation>(translator.PushUnityEngineUIInputFieldCharacterValidation, translator.GetUnityEngineUIInputFieldCharacterValidation, translator.UpdateUnityEngineUIInputFieldCharacterValidation);
			translator.RegisterPushAndGetAndUpdate<UnityEngine.UI.InputField.LineType>(translator.PushUnityEngineUIInputFieldLineType, translator.GetUnityEngineUIInputFieldLineType, translator.UpdateUnityEngineUIInputFieldLineType);
			translator.RegisterPushAndGetAndUpdate<UnityEngine.UI.Image.Type>(translator.PushUnityEngineUIImageType, translator.GetUnityEngineUIImageType, translator.UpdateUnityEngineUIImageType);
			translator.RegisterPushAndGetAndUpdate<UnityEngine.UI.Image.FillMethod>(translator.PushUnityEngineUIImageFillMethod, translator.GetUnityEngineUIImageFillMethod, translator.UpdateUnityEngineUIImageFillMethod);
			translator.RegisterPushAndGetAndUpdate<UnityEngine.UI.Image.OriginHorizontal>(translator.PushUnityEngineUIImageOriginHorizontal, translator.GetUnityEngineUIImageOriginHorizontal, translator.UpdateUnityEngineUIImageOriginHorizontal);
			translator.RegisterPushAndGetAndUpdate<UnityEngine.UI.Image.OriginVertical>(translator.PushUnityEngineUIImageOriginVertical, translator.GetUnityEngineUIImageOriginVertical, translator.UpdateUnityEngineUIImageOriginVertical);
			translator.RegisterPushAndGetAndUpdate<UnityEngine.UI.Image.Origin90>(translator.PushUnityEngineUIImageOrigin90, translator.GetUnityEngineUIImageOrigin90, translator.UpdateUnityEngineUIImageOrigin90);
			translator.RegisterPushAndGetAndUpdate<UnityEngine.UI.Image.Origin180>(translator.PushUnityEngineUIImageOrigin180, translator.GetUnityEngineUIImageOrigin180, translator.UpdateUnityEngineUIImageOrigin180);
			translator.RegisterPushAndGetAndUpdate<UnityEngine.UI.Image.Origin360>(translator.PushUnityEngineUIImageOrigin360, translator.GetUnityEngineUIImageOrigin360, translator.UpdateUnityEngineUIImageOrigin360);
			translator.RegisterPushAndGetAndUpdate<UnityEngine.UI.ScrollRect.MovementType>(translator.PushUnityEngineUIScrollRectMovementType, translator.GetUnityEngineUIScrollRectMovementType, translator.UpdateUnityEngineUIScrollRectMovementType);
			translator.RegisterPushAndGetAndUpdate<UnityEngine.UI.ScrollRect.ScrollbarVisibility>(translator.PushUnityEngineUIScrollRectScrollbarVisibility, translator.GetUnityEngineUIScrollRectScrollbarVisibility, translator.UpdateUnityEngineUIScrollRectScrollbarVisibility);
			translator.RegisterPushAndGetAndUpdate<UnityEngine.UI.Slider.Direction>(translator.PushUnityEngineUISliderDirection, translator.GetUnityEngineUISliderDirection, translator.UpdateUnityEngineUISliderDirection);
			translator.RegisterPushAndGetAndUpdate<UnityEngine.UI.Toggle.ToggleTransition>(translator.PushUnityEngineUIToggleToggleTransition, translator.GetUnityEngineUIToggleToggleTransition, translator.UpdateUnityEngineUIToggleToggleTransition);
			translator.RegisterPushAndGetAndUpdate<SuperTextMesh.Alignment>(translator.PushSuperTextMeshAlignment, translator.GetSuperTextMeshAlignment, translator.UpdateSuperTextMeshAlignment);
			translator.RegisterPushAndGetAndUpdate<UnityEngine.AI.NavMeshPathStatus>(translator.PushUnityEngineAINavMeshPathStatus, translator.GetUnityEngineAINavMeshPathStatus, translator.UpdateUnityEngineAINavMeshPathStatus);
			translator.RegisterPushAndGetAndUpdate<ScrollView.MovementType>(translator.PushScrollViewMovementType, translator.GetScrollViewMovementType, translator.UpdateScrollViewMovementType);
			translator.RegisterPushAndGetAndUpdate<ScrollView.ScrollbarVisibility>(translator.PushScrollViewScrollbarVisibility, translator.GetScrollViewScrollbarVisibility, translator.UpdateScrollViewScrollbarVisibility);
			translator.RegisterPushAndGetAndUpdate<ScrollView.ScrollViewLayoutType>(translator.PushScrollViewScrollViewLayoutType, translator.GetScrollViewScrollViewLayoutType, translator.UpdateScrollViewScrollViewLayoutType);
			translator.RegisterPushAndGetAndUpdate<UnityEngine.TouchPhase>(translator.PushUnityEngineTouchPhase, translator.GetUnityEngineTouchPhase, translator.UpdateUnityEngineTouchPhase);
			translator.RegisterPushAndGetAndUpdate<ResourceManager.PreloadType>(translator.PushResourceManagerPreloadType, translator.GetResourceManagerPreloadType, translator.UpdateResourceManagerPreloadType);
			translator.RegisterPushAndGetAndUpdate<SceneManager.SceneID>(translator.PushSceneManagerSceneID, translator.GetSceneManagerSceneID, translator.UpdateSceneManagerSceneID);
			translator.RegisterPushAndGetAndUpdate<NewQueueState>(translator.PushNewQueueState, translator.GetNewQueueState, translator.UpdateNewQueueState);
			translator.RegisterPushAndGetAndUpdate<ResourceType>(translator.PushResourceType, translator.GetResourceType, translator.UpdateResourceType);
			translator.RegisterPushAndGetAndUpdate<BuildingState>(translator.PushBuildingState, translator.GetBuildingState, translator.UpdateBuildingState);
			translator.RegisterPushAndGetAndUpdate<PlaceBuildType>(translator.PushPlaceBuildType, translator.GetPlaceBuildType, translator.UpdatePlaceBuildType);
			translator.RegisterPushAndGetAndUpdate<MarchStatus>(translator.PushMarchStatus, translator.GetMarchStatus, translator.UpdateMarchStatus);
			translator.RegisterPushAndGetAndUpdate<UnityEngine.Timeline.ClipCaps>(translator.PushUnityEngineTimelineClipCaps, translator.GetUnityEngineTimelineClipCaps, translator.UpdateUnityEngineTimelineClipCaps);
			translator.RegisterPushAndGetAndUpdate<InstanceRequest.State>(translator.PushInstanceRequestState, translator.GetInstanceRequestState, translator.UpdateInstanceRequestState);
			translator.RegisterPushAndGetAndUpdate<NewMarchType>(translator.PushNewMarchType, translator.GetNewMarchType, translator.UpdateNewMarchType);
			translator.RegisterPushAndGetAndUpdate<WorldPointType>(translator.PushWorldPointType, translator.GetWorldPointType, translator.UpdateWorldPointType);
		
		}
        
        static int UnityEngineVector2_TypeID = -1;
        public static void PushUnityEngineVector2(this ObjectTranslator thiz, RealStatePtr L, UnityEngine.Vector2 val)
        {
            if (UnityEngineVector2_TypeID == -1)
            {
			    bool is_first;
                UnityEngineVector2_TypeID = thiz.getTypeId(L, typeof(UnityEngine.Vector2), out is_first);
				
            }
			
            IntPtr buff = LuaAPI.xlua_pushstruct(L, 8, UnityEngineVector2_TypeID);
            if (!CopyByValue_Gen.Pack(buff, 0, val))
            {
                throw new Exception("pack fail fail for UnityEngine.Vector2 ,value="+val);
            }
			
        }
		
        public static void GetUnityEngineVector2(this ObjectTranslator thiz, RealStatePtr L, int index, out UnityEngine.Vector2 val)
        {
		    LuaTypes type = LuaAPI.lua_type(L, index);
            if (type == LuaTypes.LUA_TUSERDATA )
            {
			    if (LuaAPI.xlua_gettypeid(L, index) != UnityEngineVector2_TypeID)
				{
				    throw new Exception("invalid userdata for UnityEngine.Vector2");
				}
				
                IntPtr buff = LuaAPI.lua_touserdata(L, index);if (!CopyByValue_Gen.UnPack(buff, 0, out val))
                {
                    throw new Exception("unpack fail for UnityEngine.Vector2");
                }
            }
			else if (type ==LuaTypes.LUA_TTABLE)
			{
			    CopyByValue_Gen.UnPack(thiz, L, index, out val);
			}
            else
            {
                val = (UnityEngine.Vector2)thiz.objectCasters.GetCaster(typeof(UnityEngine.Vector2))(L, index, null);
            }
        }
		
        public static void UpdateUnityEngineVector2(this ObjectTranslator thiz, RealStatePtr L, int index, UnityEngine.Vector2 val)
        {
		    
            if (LuaAPI.lua_type(L, index) == LuaTypes.LUA_TUSERDATA)
            {
			    if (LuaAPI.xlua_gettypeid(L, index) != UnityEngineVector2_TypeID)
				{
				    throw new Exception("invalid userdata for UnityEngine.Vector2");
				}
				
                IntPtr buff = LuaAPI.lua_touserdata(L, index);
                if (!CopyByValue_Gen.Pack(buff, 0,  val))
                {
                    throw new Exception("pack fail for UnityEngine.Vector2 ,value="+val);
                }
            }
			
            else
            {
                throw new Exception("try to update a data with lua type:" + LuaAPI.lua_type(L, index));
            }
        }
        
        static int UnityEngineVector3_TypeID = -1;
        public static void PushUnityEngineVector3(this ObjectTranslator thiz, RealStatePtr L, UnityEngine.Vector3 val)
        {
            if (UnityEngineVector3_TypeID == -1)
            {
			    bool is_first;
                UnityEngineVector3_TypeID = thiz.getTypeId(L, typeof(UnityEngine.Vector3), out is_first);
				
            }
			
            IntPtr buff = LuaAPI.xlua_pushstruct(L, 12, UnityEngineVector3_TypeID);
            if (!CopyByValue_Gen.Pack(buff, 0, val))
            {
                throw new Exception("pack fail fail for UnityEngine.Vector3 ,value="+val);
            }
			
        }
		
        public static void GetUnityEngineVector3(this ObjectTranslator thiz, RealStatePtr L, int index, out UnityEngine.Vector3 val)
        {
		    LuaTypes type = LuaAPI.lua_type(L, index);
            if (type == LuaTypes.LUA_TUSERDATA )
            {
			    if (LuaAPI.xlua_gettypeid(L, index) != UnityEngineVector3_TypeID)
				{
				    throw new Exception("invalid userdata for UnityEngine.Vector3");
				}
				
                IntPtr buff = LuaAPI.lua_touserdata(L, index);if (!CopyByValue_Gen.UnPack(buff, 0, out val))
                {
                    throw new Exception("unpack fail for UnityEngine.Vector3");
                }
            }
			else if (type ==LuaTypes.LUA_TTABLE)
			{
			    CopyByValue_Gen.UnPack(thiz, L, index, out val);
			}
            else
            {
                val = (UnityEngine.Vector3)thiz.objectCasters.GetCaster(typeof(UnityEngine.Vector3))(L, index, null);
            }
        }
		
        public static void UpdateUnityEngineVector3(this ObjectTranslator thiz, RealStatePtr L, int index, UnityEngine.Vector3 val)
        {
		    
            if (LuaAPI.lua_type(L, index) == LuaTypes.LUA_TUSERDATA)
            {
			    if (LuaAPI.xlua_gettypeid(L, index) != UnityEngineVector3_TypeID)
				{
				    throw new Exception("invalid userdata for UnityEngine.Vector3");
				}
				
                IntPtr buff = LuaAPI.lua_touserdata(L, index);
                if (!CopyByValue_Gen.Pack(buff, 0,  val))
                {
                    throw new Exception("pack fail for UnityEngine.Vector3 ,value="+val);
                }
            }
			
            else
            {
                throw new Exception("try to update a data with lua type:" + LuaAPI.lua_type(L, index));
            }
        }
        
        static int UnityEngineVector4_TypeID = -1;
        public static void PushUnityEngineVector4(this ObjectTranslator thiz, RealStatePtr L, UnityEngine.Vector4 val)
        {
            if (UnityEngineVector4_TypeID == -1)
            {
			    bool is_first;
                UnityEngineVector4_TypeID = thiz.getTypeId(L, typeof(UnityEngine.Vector4), out is_first);
				
            }
			
            IntPtr buff = LuaAPI.xlua_pushstruct(L, 16, UnityEngineVector4_TypeID);
            if (!CopyByValue_Gen.Pack(buff, 0, val))
            {
                throw new Exception("pack fail fail for UnityEngine.Vector4 ,value="+val);
            }
			
        }
		
        public static void GetUnityEngineVector4(this ObjectTranslator thiz, RealStatePtr L, int index, out UnityEngine.Vector4 val)
        {
		    LuaTypes type = LuaAPI.lua_type(L, index);
            if (type == LuaTypes.LUA_TUSERDATA )
            {
			    if (LuaAPI.xlua_gettypeid(L, index) != UnityEngineVector4_TypeID)
				{
				    throw new Exception("invalid userdata for UnityEngine.Vector4");
				}
				
                IntPtr buff = LuaAPI.lua_touserdata(L, index);if (!CopyByValue_Gen.UnPack(buff, 0, out val))
                {
                    throw new Exception("unpack fail for UnityEngine.Vector4");
                }
            }
			else if (type ==LuaTypes.LUA_TTABLE)
			{
			    CopyByValue_Gen.UnPack(thiz, L, index, out val);
			}
            else
            {
                val = (UnityEngine.Vector4)thiz.objectCasters.GetCaster(typeof(UnityEngine.Vector4))(L, index, null);
            }
        }
		
        public static void UpdateUnityEngineVector4(this ObjectTranslator thiz, RealStatePtr L, int index, UnityEngine.Vector4 val)
        {
		    
            if (LuaAPI.lua_type(L, index) == LuaTypes.LUA_TUSERDATA)
            {
			    if (LuaAPI.xlua_gettypeid(L, index) != UnityEngineVector4_TypeID)
				{
				    throw new Exception("invalid userdata for UnityEngine.Vector4");
				}
				
                IntPtr buff = LuaAPI.lua_touserdata(L, index);
                if (!CopyByValue_Gen.Pack(buff, 0,  val))
                {
                    throw new Exception("pack fail for UnityEngine.Vector4 ,value="+val);
                }
            }
			
            else
            {
                throw new Exception("try to update a data with lua type:" + LuaAPI.lua_type(L, index));
            }
        }
        
        static int UnityEngineColor_TypeID = -1;
        public static void PushUnityEngineColor(this ObjectTranslator thiz, RealStatePtr L, UnityEngine.Color val)
        {
            if (UnityEngineColor_TypeID == -1)
            {
			    bool is_first;
                UnityEngineColor_TypeID = thiz.getTypeId(L, typeof(UnityEngine.Color), out is_first);
				
            }
			
            IntPtr buff = LuaAPI.xlua_pushstruct(L, 16, UnityEngineColor_TypeID);
            if (!CopyByValue_Gen.Pack(buff, 0, val))
            {
                throw new Exception("pack fail fail for UnityEngine.Color ,value="+val);
            }
			
        }
		
        public static void GetUnityEngineColor(this ObjectTranslator thiz, RealStatePtr L, int index, out UnityEngine.Color val)
        {
		    LuaTypes type = LuaAPI.lua_type(L, index);
            if (type == LuaTypes.LUA_TUSERDATA )
            {
			    if (LuaAPI.xlua_gettypeid(L, index) != UnityEngineColor_TypeID)
				{
				    throw new Exception("invalid userdata for UnityEngine.Color");
				}
				
                IntPtr buff = LuaAPI.lua_touserdata(L, index);if (!CopyByValue_Gen.UnPack(buff, 0, out val))
                {
                    throw new Exception("unpack fail for UnityEngine.Color");
                }
            }
			else if (type ==LuaTypes.LUA_TTABLE)
			{
			    CopyByValue_Gen.UnPack(thiz, L, index, out val);
			}
            else
            {
                val = (UnityEngine.Color)thiz.objectCasters.GetCaster(typeof(UnityEngine.Color))(L, index, null);
            }
        }
		
        public static void UpdateUnityEngineColor(this ObjectTranslator thiz, RealStatePtr L, int index, UnityEngine.Color val)
        {
		    
            if (LuaAPI.lua_type(L, index) == LuaTypes.LUA_TUSERDATA)
            {
			    if (LuaAPI.xlua_gettypeid(L, index) != UnityEngineColor_TypeID)
				{
				    throw new Exception("invalid userdata for UnityEngine.Color");
				}
				
                IntPtr buff = LuaAPI.lua_touserdata(L, index);
                if (!CopyByValue_Gen.Pack(buff, 0,  val))
                {
                    throw new Exception("pack fail for UnityEngine.Color ,value="+val);
                }
            }
			
            else
            {
                throw new Exception("try to update a data with lua type:" + LuaAPI.lua_type(L, index));
            }
        }
        
        static int UnityEngineQuaternion_TypeID = -1;
        public static void PushUnityEngineQuaternion(this ObjectTranslator thiz, RealStatePtr L, UnityEngine.Quaternion val)
        {
            if (UnityEngineQuaternion_TypeID == -1)
            {
			    bool is_first;
                UnityEngineQuaternion_TypeID = thiz.getTypeId(L, typeof(UnityEngine.Quaternion), out is_first);
				
            }
			
            IntPtr buff = LuaAPI.xlua_pushstruct(L, 16, UnityEngineQuaternion_TypeID);
            if (!CopyByValue_Gen.Pack(buff, 0, val))
            {
                throw new Exception("pack fail fail for UnityEngine.Quaternion ,value="+val);
            }
			
        }
		
        public static void GetUnityEngineQuaternion(this ObjectTranslator thiz, RealStatePtr L, int index, out UnityEngine.Quaternion val)
        {
		    LuaTypes type = LuaAPI.lua_type(L, index);
            if (type == LuaTypes.LUA_TUSERDATA )
            {
			    if (LuaAPI.xlua_gettypeid(L, index) != UnityEngineQuaternion_TypeID)
				{
				    throw new Exception("invalid userdata for UnityEngine.Quaternion");
				}
				
                IntPtr buff = LuaAPI.lua_touserdata(L, index);if (!CopyByValue_Gen.UnPack(buff, 0, out val))
                {
                    throw new Exception("unpack fail for UnityEngine.Quaternion");
                }
            }
			else if (type ==LuaTypes.LUA_TTABLE)
			{
			    CopyByValue_Gen.UnPack(thiz, L, index, out val);
			}
            else
            {
                val = (UnityEngine.Quaternion)thiz.objectCasters.GetCaster(typeof(UnityEngine.Quaternion))(L, index, null);
            }
        }
		
        public static void UpdateUnityEngineQuaternion(this ObjectTranslator thiz, RealStatePtr L, int index, UnityEngine.Quaternion val)
        {
		    
            if (LuaAPI.lua_type(L, index) == LuaTypes.LUA_TUSERDATA)
            {
			    if (LuaAPI.xlua_gettypeid(L, index) != UnityEngineQuaternion_TypeID)
				{
				    throw new Exception("invalid userdata for UnityEngine.Quaternion");
				}
				
                IntPtr buff = LuaAPI.lua_touserdata(L, index);
                if (!CopyByValue_Gen.Pack(buff, 0,  val))
                {
                    throw new Exception("pack fail for UnityEngine.Quaternion ,value="+val);
                }
            }
			
            else
            {
                throw new Exception("try to update a data with lua type:" + LuaAPI.lua_type(L, index));
            }
        }
        
        static int UnityEngineRay_TypeID = -1;
        public static void PushUnityEngineRay(this ObjectTranslator thiz, RealStatePtr L, UnityEngine.Ray val)
        {
            if (UnityEngineRay_TypeID == -1)
            {
			    bool is_first;
                UnityEngineRay_TypeID = thiz.getTypeId(L, typeof(UnityEngine.Ray), out is_first);
				
            }
			
            IntPtr buff = LuaAPI.xlua_pushstruct(L, 24, UnityEngineRay_TypeID);
            if (!CopyByValue_Gen.Pack(buff, 0, val))
            {
                throw new Exception("pack fail fail for UnityEngine.Ray ,value="+val);
            }
			
        }
		
        public static void GetUnityEngineRay(this ObjectTranslator thiz, RealStatePtr L, int index, out UnityEngine.Ray val)
        {
		    LuaTypes type = LuaAPI.lua_type(L, index);
            if (type == LuaTypes.LUA_TUSERDATA )
            {
			    if (LuaAPI.xlua_gettypeid(L, index) != UnityEngineRay_TypeID)
				{
				    throw new Exception("invalid userdata for UnityEngine.Ray");
				}
				
                IntPtr buff = LuaAPI.lua_touserdata(L, index);if (!CopyByValue_Gen.UnPack(buff, 0, out val))
                {
                    throw new Exception("unpack fail for UnityEngine.Ray");
                }
            }
			else if (type ==LuaTypes.LUA_TTABLE)
			{
			    CopyByValue_Gen.UnPack(thiz, L, index, out val);
			}
            else
            {
                val = (UnityEngine.Ray)thiz.objectCasters.GetCaster(typeof(UnityEngine.Ray))(L, index, null);
            }
        }
		
        public static void UpdateUnityEngineRay(this ObjectTranslator thiz, RealStatePtr L, int index, UnityEngine.Ray val)
        {
		    
            if (LuaAPI.lua_type(L, index) == LuaTypes.LUA_TUSERDATA)
            {
			    if (LuaAPI.xlua_gettypeid(L, index) != UnityEngineRay_TypeID)
				{
				    throw new Exception("invalid userdata for UnityEngine.Ray");
				}
				
                IntPtr buff = LuaAPI.lua_touserdata(L, index);
                if (!CopyByValue_Gen.Pack(buff, 0,  val))
                {
                    throw new Exception("pack fail for UnityEngine.Ray ,value="+val);
                }
            }
			
            else
            {
                throw new Exception("try to update a data with lua type:" + LuaAPI.lua_type(L, index));
            }
        }
        
        static int UnityEngineBounds_TypeID = -1;
        public static void PushUnityEngineBounds(this ObjectTranslator thiz, RealStatePtr L, UnityEngine.Bounds val)
        {
            if (UnityEngineBounds_TypeID == -1)
            {
			    bool is_first;
                UnityEngineBounds_TypeID = thiz.getTypeId(L, typeof(UnityEngine.Bounds), out is_first);
				
            }
			
            IntPtr buff = LuaAPI.xlua_pushstruct(L, 24, UnityEngineBounds_TypeID);
            if (!CopyByValue_Gen.Pack(buff, 0, val))
            {
                throw new Exception("pack fail fail for UnityEngine.Bounds ,value="+val);
            }
			
        }
		
        public static void GetUnityEngineBounds(this ObjectTranslator thiz, RealStatePtr L, int index, out UnityEngine.Bounds val)
        {
		    LuaTypes type = LuaAPI.lua_type(L, index);
            if (type == LuaTypes.LUA_TUSERDATA )
            {
			    if (LuaAPI.xlua_gettypeid(L, index) != UnityEngineBounds_TypeID)
				{
				    throw new Exception("invalid userdata for UnityEngine.Bounds");
				}
				
                IntPtr buff = LuaAPI.lua_touserdata(L, index);if (!CopyByValue_Gen.UnPack(buff, 0, out val))
                {
                    throw new Exception("unpack fail for UnityEngine.Bounds");
                }
            }
			else if (type ==LuaTypes.LUA_TTABLE)
			{
			    CopyByValue_Gen.UnPack(thiz, L, index, out val);
			}
            else
            {
                val = (UnityEngine.Bounds)thiz.objectCasters.GetCaster(typeof(UnityEngine.Bounds))(L, index, null);
            }
        }
		
        public static void UpdateUnityEngineBounds(this ObjectTranslator thiz, RealStatePtr L, int index, UnityEngine.Bounds val)
        {
		    
            if (LuaAPI.lua_type(L, index) == LuaTypes.LUA_TUSERDATA)
            {
			    if (LuaAPI.xlua_gettypeid(L, index) != UnityEngineBounds_TypeID)
				{
				    throw new Exception("invalid userdata for UnityEngine.Bounds");
				}
				
                IntPtr buff = LuaAPI.lua_touserdata(L, index);
                if (!CopyByValue_Gen.Pack(buff, 0,  val))
                {
                    throw new Exception("pack fail for UnityEngine.Bounds ,value="+val);
                }
            }
			
            else
            {
                throw new Exception("try to update a data with lua type:" + LuaAPI.lua_type(L, index));
            }
        }
        
        static int UnityEngineRay2D_TypeID = -1;
        public static void PushUnityEngineRay2D(this ObjectTranslator thiz, RealStatePtr L, UnityEngine.Ray2D val)
        {
            if (UnityEngineRay2D_TypeID == -1)
            {
			    bool is_first;
                UnityEngineRay2D_TypeID = thiz.getTypeId(L, typeof(UnityEngine.Ray2D), out is_first);
				
            }
			
            IntPtr buff = LuaAPI.xlua_pushstruct(L, 16, UnityEngineRay2D_TypeID);
            if (!CopyByValue_Gen.Pack(buff, 0, val))
            {
                throw new Exception("pack fail fail for UnityEngine.Ray2D ,value="+val);
            }
			
        }
		
        public static void GetUnityEngineRay2D(this ObjectTranslator thiz, RealStatePtr L, int index, out UnityEngine.Ray2D val)
        {
		    LuaTypes type = LuaAPI.lua_type(L, index);
            if (type == LuaTypes.LUA_TUSERDATA )
            {
			    if (LuaAPI.xlua_gettypeid(L, index) != UnityEngineRay2D_TypeID)
				{
				    throw new Exception("invalid userdata for UnityEngine.Ray2D");
				}
				
                IntPtr buff = LuaAPI.lua_touserdata(L, index);if (!CopyByValue_Gen.UnPack(buff, 0, out val))
                {
                    throw new Exception("unpack fail for UnityEngine.Ray2D");
                }
            }
			else if (type ==LuaTypes.LUA_TTABLE)
			{
			    CopyByValue_Gen.UnPack(thiz, L, index, out val);
			}
            else
            {
                val = (UnityEngine.Ray2D)thiz.objectCasters.GetCaster(typeof(UnityEngine.Ray2D))(L, index, null);
            }
        }
		
        public static void UpdateUnityEngineRay2D(this ObjectTranslator thiz, RealStatePtr L, int index, UnityEngine.Ray2D val)
        {
		    
            if (LuaAPI.lua_type(L, index) == LuaTypes.LUA_TUSERDATA)
            {
			    if (LuaAPI.xlua_gettypeid(L, index) != UnityEngineRay2D_TypeID)
				{
				    throw new Exception("invalid userdata for UnityEngine.Ray2D");
				}
				
                IntPtr buff = LuaAPI.lua_touserdata(L, index);
                if (!CopyByValue_Gen.Pack(buff, 0,  val))
                {
                    throw new Exception("pack fail for UnityEngine.Ray2D ,value="+val);
                }
            }
			
            else
            {
                throw new Exception("try to update a data with lua type:" + LuaAPI.lua_type(L, index));
            }
        }
        
        static int UnityEngineCameraGateFitMode_TypeID = -1;
		static int UnityEngineCameraGateFitMode_EnumRef = -1;
        
        public static void PushUnityEngineCameraGateFitMode(this ObjectTranslator thiz, RealStatePtr L, UnityEngine.Camera.GateFitMode val)
        {
            if (UnityEngineCameraGateFitMode_TypeID == -1)
            {
			    bool is_first;
                UnityEngineCameraGateFitMode_TypeID = thiz.getTypeId(L, typeof(UnityEngine.Camera.GateFitMode), out is_first);
				
				if (UnityEngineCameraGateFitMode_EnumRef == -1)
				{
				    Utils.LoadCSTable(L, typeof(UnityEngine.Camera.GateFitMode));
				    UnityEngineCameraGateFitMode_EnumRef = LuaAPI.luaL_ref(L, LuaIndexes.LUA_REGISTRYINDEX);
				}
				
            }
			
			if (LuaAPI.xlua_tryget_cachedud(L, (int)val, UnityEngineCameraGateFitMode_EnumRef) == 1)
            {
			    return;
			}
			
            IntPtr buff = LuaAPI.xlua_pushstruct(L, 4, UnityEngineCameraGateFitMode_TypeID);
            if (!CopyByValue_Gen.Pack(buff, 0, (int)val))
            {
                throw new Exception("pack fail fail for UnityEngine.Camera.GateFitMode ,value="+val);
            }
			
			LuaAPI.lua_getref(L, UnityEngineCameraGateFitMode_EnumRef);
			LuaAPI.lua_pushvalue(L, -2);
			LuaAPI.xlua_rawseti(L, -2, (int)val);
			LuaAPI.lua_pop(L, 1);
			
        }
		
        public static void GetUnityEngineCameraGateFitMode(this ObjectTranslator thiz, RealStatePtr L, int index, out UnityEngine.Camera.GateFitMode val)
        {
		    LuaTypes type = LuaAPI.lua_type(L, index);
            if (type == LuaTypes.LUA_TUSERDATA )
            {
			    if (LuaAPI.xlua_gettypeid(L, index) != UnityEngineCameraGateFitMode_TypeID)
				{
				    throw new Exception("invalid userdata for UnityEngine.Camera.GateFitMode");
				}
				
                IntPtr buff = LuaAPI.lua_touserdata(L, index);
				int e;
                if (!CopyByValue_Gen.UnPack(buff, 0, out e))
                {
                    throw new Exception("unpack fail for UnityEngine.Camera.GateFitMode");
                }
				val = (UnityEngine.Camera.GateFitMode)e;
                
            }
            else
            {
                val = (UnityEngine.Camera.GateFitMode)thiz.objectCasters.GetCaster(typeof(UnityEngine.Camera.GateFitMode))(L, index, null);
            }
        }
		
        public static void UpdateUnityEngineCameraGateFitMode(this ObjectTranslator thiz, RealStatePtr L, int index, UnityEngine.Camera.GateFitMode val)
        {
		    
            if (LuaAPI.lua_type(L, index) == LuaTypes.LUA_TUSERDATA)
            {
			    if (LuaAPI.xlua_gettypeid(L, index) != UnityEngineCameraGateFitMode_TypeID)
				{
				    throw new Exception("invalid userdata for UnityEngine.Camera.GateFitMode");
				}
				
                IntPtr buff = LuaAPI.lua_touserdata(L, index);
                if (!CopyByValue_Gen.Pack(buff, 0,  (int)val))
                {
                    throw new Exception("pack fail for UnityEngine.Camera.GateFitMode ,value="+val);
                }
            }
			
            else
            {
                throw new Exception("try to update a data with lua type:" + LuaAPI.lua_type(L, index));
            }
        }
        
        static int UnityEngineCameraFieldOfViewAxis_TypeID = -1;
		static int UnityEngineCameraFieldOfViewAxis_EnumRef = -1;
        
        public static void PushUnityEngineCameraFieldOfViewAxis(this ObjectTranslator thiz, RealStatePtr L, UnityEngine.Camera.FieldOfViewAxis val)
        {
            if (UnityEngineCameraFieldOfViewAxis_TypeID == -1)
            {
			    bool is_first;
                UnityEngineCameraFieldOfViewAxis_TypeID = thiz.getTypeId(L, typeof(UnityEngine.Camera.FieldOfViewAxis), out is_first);
				
				if (UnityEngineCameraFieldOfViewAxis_EnumRef == -1)
				{
				    Utils.LoadCSTable(L, typeof(UnityEngine.Camera.FieldOfViewAxis));
				    UnityEngineCameraFieldOfViewAxis_EnumRef = LuaAPI.luaL_ref(L, LuaIndexes.LUA_REGISTRYINDEX);
				}
				
            }
			
			if (LuaAPI.xlua_tryget_cachedud(L, (int)val, UnityEngineCameraFieldOfViewAxis_EnumRef) == 1)
            {
			    return;
			}
			
            IntPtr buff = LuaAPI.xlua_pushstruct(L, 4, UnityEngineCameraFieldOfViewAxis_TypeID);
            if (!CopyByValue_Gen.Pack(buff, 0, (int)val))
            {
                throw new Exception("pack fail fail for UnityEngine.Camera.FieldOfViewAxis ,value="+val);
            }
			
			LuaAPI.lua_getref(L, UnityEngineCameraFieldOfViewAxis_EnumRef);
			LuaAPI.lua_pushvalue(L, -2);
			LuaAPI.xlua_rawseti(L, -2, (int)val);
			LuaAPI.lua_pop(L, 1);
			
        }
		
        public static void GetUnityEngineCameraFieldOfViewAxis(this ObjectTranslator thiz, RealStatePtr L, int index, out UnityEngine.Camera.FieldOfViewAxis val)
        {
		    LuaTypes type = LuaAPI.lua_type(L, index);
            if (type == LuaTypes.LUA_TUSERDATA )
            {
			    if (LuaAPI.xlua_gettypeid(L, index) != UnityEngineCameraFieldOfViewAxis_TypeID)
				{
				    throw new Exception("invalid userdata for UnityEngine.Camera.FieldOfViewAxis");
				}
				
                IntPtr buff = LuaAPI.lua_touserdata(L, index);
				int e;
                if (!CopyByValue_Gen.UnPack(buff, 0, out e))
                {
                    throw new Exception("unpack fail for UnityEngine.Camera.FieldOfViewAxis");
                }
				val = (UnityEngine.Camera.FieldOfViewAxis)e;
                
            }
            else
            {
                val = (UnityEngine.Camera.FieldOfViewAxis)thiz.objectCasters.GetCaster(typeof(UnityEngine.Camera.FieldOfViewAxis))(L, index, null);
            }
        }
		
        public static void UpdateUnityEngineCameraFieldOfViewAxis(this ObjectTranslator thiz, RealStatePtr L, int index, UnityEngine.Camera.FieldOfViewAxis val)
        {
		    
            if (LuaAPI.lua_type(L, index) == LuaTypes.LUA_TUSERDATA)
            {
			    if (LuaAPI.xlua_gettypeid(L, index) != UnityEngineCameraFieldOfViewAxis_TypeID)
				{
				    throw new Exception("invalid userdata for UnityEngine.Camera.FieldOfViewAxis");
				}
				
                IntPtr buff = LuaAPI.lua_touserdata(L, index);
                if (!CopyByValue_Gen.Pack(buff, 0,  (int)val))
                {
                    throw new Exception("pack fail for UnityEngine.Camera.FieldOfViewAxis ,value="+val);
                }
            }
			
            else
            {
                throw new Exception("try to update a data with lua type:" + LuaAPI.lua_type(L, index));
            }
        }
        
        static int DGTweeningDOTweenAnimationAnimationType_TypeID = -1;
		static int DGTweeningDOTweenAnimationAnimationType_EnumRef = -1;
        
        public static void PushDGTweeningDOTweenAnimationAnimationType(this ObjectTranslator thiz, RealStatePtr L, DG.Tweening.DOTweenAnimation.AnimationType val)
        {
            if (DGTweeningDOTweenAnimationAnimationType_TypeID == -1)
            {
			    bool is_first;
                DGTweeningDOTweenAnimationAnimationType_TypeID = thiz.getTypeId(L, typeof(DG.Tweening.DOTweenAnimation.AnimationType), out is_first);
				
				if (DGTweeningDOTweenAnimationAnimationType_EnumRef == -1)
				{
				    Utils.LoadCSTable(L, typeof(DG.Tweening.DOTweenAnimation.AnimationType));
				    DGTweeningDOTweenAnimationAnimationType_EnumRef = LuaAPI.luaL_ref(L, LuaIndexes.LUA_REGISTRYINDEX);
				}
				
            }
			
			if (LuaAPI.xlua_tryget_cachedud(L, (int)val, DGTweeningDOTweenAnimationAnimationType_EnumRef) == 1)
            {
			    return;
			}
			
            IntPtr buff = LuaAPI.xlua_pushstruct(L, 4, DGTweeningDOTweenAnimationAnimationType_TypeID);
            if (!CopyByValue_Gen.Pack(buff, 0, (int)val))
            {
                throw new Exception("pack fail fail for DG.Tweening.DOTweenAnimation.AnimationType ,value="+val);
            }
			
			LuaAPI.lua_getref(L, DGTweeningDOTweenAnimationAnimationType_EnumRef);
			LuaAPI.lua_pushvalue(L, -2);
			LuaAPI.xlua_rawseti(L, -2, (int)val);
			LuaAPI.lua_pop(L, 1);
			
        }
		
        public static void GetDGTweeningDOTweenAnimationAnimationType(this ObjectTranslator thiz, RealStatePtr L, int index, out DG.Tweening.DOTweenAnimation.AnimationType val)
        {
		    LuaTypes type = LuaAPI.lua_type(L, index);
            if (type == LuaTypes.LUA_TUSERDATA )
            {
			    if (LuaAPI.xlua_gettypeid(L, index) != DGTweeningDOTweenAnimationAnimationType_TypeID)
				{
				    throw new Exception("invalid userdata for DG.Tweening.DOTweenAnimation.AnimationType");
				}
				
                IntPtr buff = LuaAPI.lua_touserdata(L, index);
				int e;
                if (!CopyByValue_Gen.UnPack(buff, 0, out e))
                {
                    throw new Exception("unpack fail for DG.Tweening.DOTweenAnimation.AnimationType");
                }
				val = (DG.Tweening.DOTweenAnimation.AnimationType)e;
                
            }
            else
            {
                val = (DG.Tweening.DOTweenAnimation.AnimationType)thiz.objectCasters.GetCaster(typeof(DG.Tweening.DOTweenAnimation.AnimationType))(L, index, null);
            }
        }
		
        public static void UpdateDGTweeningDOTweenAnimationAnimationType(this ObjectTranslator thiz, RealStatePtr L, int index, DG.Tweening.DOTweenAnimation.AnimationType val)
        {
		    
            if (LuaAPI.lua_type(L, index) == LuaTypes.LUA_TUSERDATA)
            {
			    if (LuaAPI.xlua_gettypeid(L, index) != DGTweeningDOTweenAnimationAnimationType_TypeID)
				{
				    throw new Exception("invalid userdata for DG.Tweening.DOTweenAnimation.AnimationType");
				}
				
                IntPtr buff = LuaAPI.lua_touserdata(L, index);
                if (!CopyByValue_Gen.Pack(buff, 0,  (int)val))
                {
                    throw new Exception("pack fail for DG.Tweening.DOTweenAnimation.AnimationType ,value="+val);
                }
            }
			
            else
            {
                throw new Exception("try to update a data with lua type:" + LuaAPI.lua_type(L, index));
            }
        }
        
        static int DGTweeningDOTweenAnimationTargetType_TypeID = -1;
		static int DGTweeningDOTweenAnimationTargetType_EnumRef = -1;
        
        public static void PushDGTweeningDOTweenAnimationTargetType(this ObjectTranslator thiz, RealStatePtr L, DG.Tweening.DOTweenAnimation.TargetType val)
        {
            if (DGTweeningDOTweenAnimationTargetType_TypeID == -1)
            {
			    bool is_first;
                DGTweeningDOTweenAnimationTargetType_TypeID = thiz.getTypeId(L, typeof(DG.Tweening.DOTweenAnimation.TargetType), out is_first);
				
				if (DGTweeningDOTweenAnimationTargetType_EnumRef == -1)
				{
				    Utils.LoadCSTable(L, typeof(DG.Tweening.DOTweenAnimation.TargetType));
				    DGTweeningDOTweenAnimationTargetType_EnumRef = LuaAPI.luaL_ref(L, LuaIndexes.LUA_REGISTRYINDEX);
				}
				
            }
			
			if (LuaAPI.xlua_tryget_cachedud(L, (int)val, DGTweeningDOTweenAnimationTargetType_EnumRef) == 1)
            {
			    return;
			}
			
            IntPtr buff = LuaAPI.xlua_pushstruct(L, 4, DGTweeningDOTweenAnimationTargetType_TypeID);
            if (!CopyByValue_Gen.Pack(buff, 0, (int)val))
            {
                throw new Exception("pack fail fail for DG.Tweening.DOTweenAnimation.TargetType ,value="+val);
            }
			
			LuaAPI.lua_getref(L, DGTweeningDOTweenAnimationTargetType_EnumRef);
			LuaAPI.lua_pushvalue(L, -2);
			LuaAPI.xlua_rawseti(L, -2, (int)val);
			LuaAPI.lua_pop(L, 1);
			
        }
		
        public static void GetDGTweeningDOTweenAnimationTargetType(this ObjectTranslator thiz, RealStatePtr L, int index, out DG.Tweening.DOTweenAnimation.TargetType val)
        {
		    LuaTypes type = LuaAPI.lua_type(L, index);
            if (type == LuaTypes.LUA_TUSERDATA )
            {
			    if (LuaAPI.xlua_gettypeid(L, index) != DGTweeningDOTweenAnimationTargetType_TypeID)
				{
				    throw new Exception("invalid userdata for DG.Tweening.DOTweenAnimation.TargetType");
				}
				
                IntPtr buff = LuaAPI.lua_touserdata(L, index);
				int e;
                if (!CopyByValue_Gen.UnPack(buff, 0, out e))
                {
                    throw new Exception("unpack fail for DG.Tweening.DOTweenAnimation.TargetType");
                }
				val = (DG.Tweening.DOTweenAnimation.TargetType)e;
                
            }
            else
            {
                val = (DG.Tweening.DOTweenAnimation.TargetType)thiz.objectCasters.GetCaster(typeof(DG.Tweening.DOTweenAnimation.TargetType))(L, index, null);
            }
        }
		
        public static void UpdateDGTweeningDOTweenAnimationTargetType(this ObjectTranslator thiz, RealStatePtr L, int index, DG.Tweening.DOTweenAnimation.TargetType val)
        {
		    
            if (LuaAPI.lua_type(L, index) == LuaTypes.LUA_TUSERDATA)
            {
			    if (LuaAPI.xlua_gettypeid(L, index) != DGTweeningDOTweenAnimationTargetType_TypeID)
				{
				    throw new Exception("invalid userdata for DG.Tweening.DOTweenAnimation.TargetType");
				}
				
                IntPtr buff = LuaAPI.lua_touserdata(L, index);
                if (!CopyByValue_Gen.Pack(buff, 0,  (int)val))
                {
                    throw new Exception("pack fail for DG.Tweening.DOTweenAnimation.TargetType ,value="+val);
                }
            }
			
            else
            {
                throw new Exception("try to update a data with lua type:" + LuaAPI.lua_type(L, index));
            }
        }
        
        static int UnityEngineRectTransformEdge_TypeID = -1;
		static int UnityEngineRectTransformEdge_EnumRef = -1;
        
        public static void PushUnityEngineRectTransformEdge(this ObjectTranslator thiz, RealStatePtr L, UnityEngine.RectTransform.Edge val)
        {
            if (UnityEngineRectTransformEdge_TypeID == -1)
            {
			    bool is_first;
                UnityEngineRectTransformEdge_TypeID = thiz.getTypeId(L, typeof(UnityEngine.RectTransform.Edge), out is_first);
				
				if (UnityEngineRectTransformEdge_EnumRef == -1)
				{
				    Utils.LoadCSTable(L, typeof(UnityEngine.RectTransform.Edge));
				    UnityEngineRectTransformEdge_EnumRef = LuaAPI.luaL_ref(L, LuaIndexes.LUA_REGISTRYINDEX);
				}
				
            }
			
			if (LuaAPI.xlua_tryget_cachedud(L, (int)val, UnityEngineRectTransformEdge_EnumRef) == 1)
            {
			    return;
			}
			
            IntPtr buff = LuaAPI.xlua_pushstruct(L, 4, UnityEngineRectTransformEdge_TypeID);
            if (!CopyByValue_Gen.Pack(buff, 0, (int)val))
            {
                throw new Exception("pack fail fail for UnityEngine.RectTransform.Edge ,value="+val);
            }
			
			LuaAPI.lua_getref(L, UnityEngineRectTransformEdge_EnumRef);
			LuaAPI.lua_pushvalue(L, -2);
			LuaAPI.xlua_rawseti(L, -2, (int)val);
			LuaAPI.lua_pop(L, 1);
			
        }
		
        public static void GetUnityEngineRectTransformEdge(this ObjectTranslator thiz, RealStatePtr L, int index, out UnityEngine.RectTransform.Edge val)
        {
		    LuaTypes type = LuaAPI.lua_type(L, index);
            if (type == LuaTypes.LUA_TUSERDATA )
            {
			    if (LuaAPI.xlua_gettypeid(L, index) != UnityEngineRectTransformEdge_TypeID)
				{
				    throw new Exception("invalid userdata for UnityEngine.RectTransform.Edge");
				}
				
                IntPtr buff = LuaAPI.lua_touserdata(L, index);
				int e;
                if (!CopyByValue_Gen.UnPack(buff, 0, out e))
                {
                    throw new Exception("unpack fail for UnityEngine.RectTransform.Edge");
                }
				val = (UnityEngine.RectTransform.Edge)e;
                
            }
            else
            {
                val = (UnityEngine.RectTransform.Edge)thiz.objectCasters.GetCaster(typeof(UnityEngine.RectTransform.Edge))(L, index, null);
            }
        }
		
        public static void UpdateUnityEngineRectTransformEdge(this ObjectTranslator thiz, RealStatePtr L, int index, UnityEngine.RectTransform.Edge val)
        {
		    
            if (LuaAPI.lua_type(L, index) == LuaTypes.LUA_TUSERDATA)
            {
			    if (LuaAPI.xlua_gettypeid(L, index) != UnityEngineRectTransformEdge_TypeID)
				{
				    throw new Exception("invalid userdata for UnityEngine.RectTransform.Edge");
				}
				
                IntPtr buff = LuaAPI.lua_touserdata(L, index);
                if (!CopyByValue_Gen.Pack(buff, 0,  (int)val))
                {
                    throw new Exception("pack fail for UnityEngine.RectTransform.Edge ,value="+val);
                }
            }
			
            else
            {
                throw new Exception("try to update a data with lua type:" + LuaAPI.lua_type(L, index));
            }
        }
        
        static int UnityEngineRectTransformAxis_TypeID = -1;
		static int UnityEngineRectTransformAxis_EnumRef = -1;
        
        public static void PushUnityEngineRectTransformAxis(this ObjectTranslator thiz, RealStatePtr L, UnityEngine.RectTransform.Axis val)
        {
            if (UnityEngineRectTransformAxis_TypeID == -1)
            {
			    bool is_first;
                UnityEngineRectTransformAxis_TypeID = thiz.getTypeId(L, typeof(UnityEngine.RectTransform.Axis), out is_first);
				
				if (UnityEngineRectTransformAxis_EnumRef == -1)
				{
				    Utils.LoadCSTable(L, typeof(UnityEngine.RectTransform.Axis));
				    UnityEngineRectTransformAxis_EnumRef = LuaAPI.luaL_ref(L, LuaIndexes.LUA_REGISTRYINDEX);
				}
				
            }
			
			if (LuaAPI.xlua_tryget_cachedud(L, (int)val, UnityEngineRectTransformAxis_EnumRef) == 1)
            {
			    return;
			}
			
            IntPtr buff = LuaAPI.xlua_pushstruct(L, 4, UnityEngineRectTransformAxis_TypeID);
            if (!CopyByValue_Gen.Pack(buff, 0, (int)val))
            {
                throw new Exception("pack fail fail for UnityEngine.RectTransform.Axis ,value="+val);
            }
			
			LuaAPI.lua_getref(L, UnityEngineRectTransformAxis_EnumRef);
			LuaAPI.lua_pushvalue(L, -2);
			LuaAPI.xlua_rawseti(L, -2, (int)val);
			LuaAPI.lua_pop(L, 1);
			
        }
		
        public static void GetUnityEngineRectTransformAxis(this ObjectTranslator thiz, RealStatePtr L, int index, out UnityEngine.RectTransform.Axis val)
        {
		    LuaTypes type = LuaAPI.lua_type(L, index);
            if (type == LuaTypes.LUA_TUSERDATA )
            {
			    if (LuaAPI.xlua_gettypeid(L, index) != UnityEngineRectTransformAxis_TypeID)
				{
				    throw new Exception("invalid userdata for UnityEngine.RectTransform.Axis");
				}
				
                IntPtr buff = LuaAPI.lua_touserdata(L, index);
				int e;
                if (!CopyByValue_Gen.UnPack(buff, 0, out e))
                {
                    throw new Exception("unpack fail for UnityEngine.RectTransform.Axis");
                }
				val = (UnityEngine.RectTransform.Axis)e;
                
            }
            else
            {
                val = (UnityEngine.RectTransform.Axis)thiz.objectCasters.GetCaster(typeof(UnityEngine.RectTransform.Axis))(L, index, null);
            }
        }
		
        public static void UpdateUnityEngineRectTransformAxis(this ObjectTranslator thiz, RealStatePtr L, int index, UnityEngine.RectTransform.Axis val)
        {
		    
            if (LuaAPI.lua_type(L, index) == LuaTypes.LUA_TUSERDATA)
            {
			    if (LuaAPI.xlua_gettypeid(L, index) != UnityEngineRectTransformAxis_TypeID)
				{
				    throw new Exception("invalid userdata for UnityEngine.RectTransform.Axis");
				}
				
                IntPtr buff = LuaAPI.lua_touserdata(L, index);
                if (!CopyByValue_Gen.Pack(buff, 0,  (int)val))
                {
                    throw new Exception("pack fail for UnityEngine.RectTransform.Axis ,value="+val);
                }
            }
			
            else
            {
                throw new Exception("try to update a data with lua type:" + LuaAPI.lua_type(L, index));
            }
        }
        
        static int UnityEngineEventSystemsPointerEventDataInputButton_TypeID = -1;
		static int UnityEngineEventSystemsPointerEventDataInputButton_EnumRef = -1;
        
        public static void PushUnityEngineEventSystemsPointerEventDataInputButton(this ObjectTranslator thiz, RealStatePtr L, UnityEngine.EventSystems.PointerEventData.InputButton val)
        {
            if (UnityEngineEventSystemsPointerEventDataInputButton_TypeID == -1)
            {
			    bool is_first;
                UnityEngineEventSystemsPointerEventDataInputButton_TypeID = thiz.getTypeId(L, typeof(UnityEngine.EventSystems.PointerEventData.InputButton), out is_first);
				
				if (UnityEngineEventSystemsPointerEventDataInputButton_EnumRef == -1)
				{
				    Utils.LoadCSTable(L, typeof(UnityEngine.EventSystems.PointerEventData.InputButton));
				    UnityEngineEventSystemsPointerEventDataInputButton_EnumRef = LuaAPI.luaL_ref(L, LuaIndexes.LUA_REGISTRYINDEX);
				}
				
            }
			
			if (LuaAPI.xlua_tryget_cachedud(L, (int)val, UnityEngineEventSystemsPointerEventDataInputButton_EnumRef) == 1)
            {
			    return;
			}
			
            IntPtr buff = LuaAPI.xlua_pushstruct(L, 4, UnityEngineEventSystemsPointerEventDataInputButton_TypeID);
            if (!CopyByValue_Gen.Pack(buff, 0, (int)val))
            {
                throw new Exception("pack fail fail for UnityEngine.EventSystems.PointerEventData.InputButton ,value="+val);
            }
			
			LuaAPI.lua_getref(L, UnityEngineEventSystemsPointerEventDataInputButton_EnumRef);
			LuaAPI.lua_pushvalue(L, -2);
			LuaAPI.xlua_rawseti(L, -2, (int)val);
			LuaAPI.lua_pop(L, 1);
			
        }
		
        public static void GetUnityEngineEventSystemsPointerEventDataInputButton(this ObjectTranslator thiz, RealStatePtr L, int index, out UnityEngine.EventSystems.PointerEventData.InputButton val)
        {
		    LuaTypes type = LuaAPI.lua_type(L, index);
            if (type == LuaTypes.LUA_TUSERDATA )
            {
			    if (LuaAPI.xlua_gettypeid(L, index) != UnityEngineEventSystemsPointerEventDataInputButton_TypeID)
				{
				    throw new Exception("invalid userdata for UnityEngine.EventSystems.PointerEventData.InputButton");
				}
				
                IntPtr buff = LuaAPI.lua_touserdata(L, index);
				int e;
                if (!CopyByValue_Gen.UnPack(buff, 0, out e))
                {
                    throw new Exception("unpack fail for UnityEngine.EventSystems.PointerEventData.InputButton");
                }
				val = (UnityEngine.EventSystems.PointerEventData.InputButton)e;
                
            }
            else
            {
                val = (UnityEngine.EventSystems.PointerEventData.InputButton)thiz.objectCasters.GetCaster(typeof(UnityEngine.EventSystems.PointerEventData.InputButton))(L, index, null);
            }
        }
		
        public static void UpdateUnityEngineEventSystemsPointerEventDataInputButton(this ObjectTranslator thiz, RealStatePtr L, int index, UnityEngine.EventSystems.PointerEventData.InputButton val)
        {
		    
            if (LuaAPI.lua_type(L, index) == LuaTypes.LUA_TUSERDATA)
            {
			    if (LuaAPI.xlua_gettypeid(L, index) != UnityEngineEventSystemsPointerEventDataInputButton_TypeID)
				{
				    throw new Exception("invalid userdata for UnityEngine.EventSystems.PointerEventData.InputButton");
				}
				
                IntPtr buff = LuaAPI.lua_touserdata(L, index);
                if (!CopyByValue_Gen.Pack(buff, 0,  (int)val))
                {
                    throw new Exception("pack fail for UnityEngine.EventSystems.PointerEventData.InputButton ,value="+val);
                }
            }
			
            else
            {
                throw new Exception("try to update a data with lua type:" + LuaAPI.lua_type(L, index));
            }
        }
        
        static int UnityEngineEventSystemsPointerEventDataFramePressState_TypeID = -1;
		static int UnityEngineEventSystemsPointerEventDataFramePressState_EnumRef = -1;
        
        public static void PushUnityEngineEventSystemsPointerEventDataFramePressState(this ObjectTranslator thiz, RealStatePtr L, UnityEngine.EventSystems.PointerEventData.FramePressState val)
        {
            if (UnityEngineEventSystemsPointerEventDataFramePressState_TypeID == -1)
            {
			    bool is_first;
                UnityEngineEventSystemsPointerEventDataFramePressState_TypeID = thiz.getTypeId(L, typeof(UnityEngine.EventSystems.PointerEventData.FramePressState), out is_first);
				
				if (UnityEngineEventSystemsPointerEventDataFramePressState_EnumRef == -1)
				{
				    Utils.LoadCSTable(L, typeof(UnityEngine.EventSystems.PointerEventData.FramePressState));
				    UnityEngineEventSystemsPointerEventDataFramePressState_EnumRef = LuaAPI.luaL_ref(L, LuaIndexes.LUA_REGISTRYINDEX);
				}
				
            }
			
			if (LuaAPI.xlua_tryget_cachedud(L, (int)val, UnityEngineEventSystemsPointerEventDataFramePressState_EnumRef) == 1)
            {
			    return;
			}
			
            IntPtr buff = LuaAPI.xlua_pushstruct(L, 4, UnityEngineEventSystemsPointerEventDataFramePressState_TypeID);
            if (!CopyByValue_Gen.Pack(buff, 0, (int)val))
            {
                throw new Exception("pack fail fail for UnityEngine.EventSystems.PointerEventData.FramePressState ,value="+val);
            }
			
			LuaAPI.lua_getref(L, UnityEngineEventSystemsPointerEventDataFramePressState_EnumRef);
			LuaAPI.lua_pushvalue(L, -2);
			LuaAPI.xlua_rawseti(L, -2, (int)val);
			LuaAPI.lua_pop(L, 1);
			
        }
		
        public static void GetUnityEngineEventSystemsPointerEventDataFramePressState(this ObjectTranslator thiz, RealStatePtr L, int index, out UnityEngine.EventSystems.PointerEventData.FramePressState val)
        {
		    LuaTypes type = LuaAPI.lua_type(L, index);
            if (type == LuaTypes.LUA_TUSERDATA )
            {
			    if (LuaAPI.xlua_gettypeid(L, index) != UnityEngineEventSystemsPointerEventDataFramePressState_TypeID)
				{
				    throw new Exception("invalid userdata for UnityEngine.EventSystems.PointerEventData.FramePressState");
				}
				
                IntPtr buff = LuaAPI.lua_touserdata(L, index);
				int e;
                if (!CopyByValue_Gen.UnPack(buff, 0, out e))
                {
                    throw new Exception("unpack fail for UnityEngine.EventSystems.PointerEventData.FramePressState");
                }
				val = (UnityEngine.EventSystems.PointerEventData.FramePressState)e;
                
            }
            else
            {
                val = (UnityEngine.EventSystems.PointerEventData.FramePressState)thiz.objectCasters.GetCaster(typeof(UnityEngine.EventSystems.PointerEventData.FramePressState))(L, index, null);
            }
        }
		
        public static void UpdateUnityEngineEventSystemsPointerEventDataFramePressState(this ObjectTranslator thiz, RealStatePtr L, int index, UnityEngine.EventSystems.PointerEventData.FramePressState val)
        {
		    
            if (LuaAPI.lua_type(L, index) == LuaTypes.LUA_TUSERDATA)
            {
			    if (LuaAPI.xlua_gettypeid(L, index) != UnityEngineEventSystemsPointerEventDataFramePressState_TypeID)
				{
				    throw new Exception("invalid userdata for UnityEngine.EventSystems.PointerEventData.FramePressState");
				}
				
                IntPtr buff = LuaAPI.lua_touserdata(L, index);
                if (!CopyByValue_Gen.Pack(buff, 0,  (int)val))
                {
                    throw new Exception("pack fail for UnityEngine.EventSystems.PointerEventData.FramePressState ,value="+val);
                }
            }
			
            else
            {
                throw new Exception("try to update a data with lua type:" + LuaAPI.lua_type(L, index));
            }
        }
        
        static int UnityEngineRenderTextureFormat_TypeID = -1;
		static int UnityEngineRenderTextureFormat_EnumRef = -1;
        
        public static void PushUnityEngineRenderTextureFormat(this ObjectTranslator thiz, RealStatePtr L, UnityEngine.RenderTextureFormat val)
        {
            if (UnityEngineRenderTextureFormat_TypeID == -1)
            {
			    bool is_first;
                UnityEngineRenderTextureFormat_TypeID = thiz.getTypeId(L, typeof(UnityEngine.RenderTextureFormat), out is_first);
				
				if (UnityEngineRenderTextureFormat_EnumRef == -1)
				{
				    Utils.LoadCSTable(L, typeof(UnityEngine.RenderTextureFormat));
				    UnityEngineRenderTextureFormat_EnumRef = LuaAPI.luaL_ref(L, LuaIndexes.LUA_REGISTRYINDEX);
				}
				
            }
			
			if (LuaAPI.xlua_tryget_cachedud(L, (int)val, UnityEngineRenderTextureFormat_EnumRef) == 1)
            {
			    return;
			}
			
            IntPtr buff = LuaAPI.xlua_pushstruct(L, 4, UnityEngineRenderTextureFormat_TypeID);
            if (!CopyByValue_Gen.Pack(buff, 0, (int)val))
            {
                throw new Exception("pack fail fail for UnityEngine.RenderTextureFormat ,value="+val);
            }
			
			LuaAPI.lua_getref(L, UnityEngineRenderTextureFormat_EnumRef);
			LuaAPI.lua_pushvalue(L, -2);
			LuaAPI.xlua_rawseti(L, -2, (int)val);
			LuaAPI.lua_pop(L, 1);
			
        }
		
        public static void GetUnityEngineRenderTextureFormat(this ObjectTranslator thiz, RealStatePtr L, int index, out UnityEngine.RenderTextureFormat val)
        {
		    LuaTypes type = LuaAPI.lua_type(L, index);
            if (type == LuaTypes.LUA_TUSERDATA )
            {
			    if (LuaAPI.xlua_gettypeid(L, index) != UnityEngineRenderTextureFormat_TypeID)
				{
				    throw new Exception("invalid userdata for UnityEngine.RenderTextureFormat");
				}
				
                IntPtr buff = LuaAPI.lua_touserdata(L, index);
				int e;
                if (!CopyByValue_Gen.UnPack(buff, 0, out e))
                {
                    throw new Exception("unpack fail for UnityEngine.RenderTextureFormat");
                }
				val = (UnityEngine.RenderTextureFormat)e;
                
            }
            else
            {
                val = (UnityEngine.RenderTextureFormat)thiz.objectCasters.GetCaster(typeof(UnityEngine.RenderTextureFormat))(L, index, null);
            }
        }
		
        public static void UpdateUnityEngineRenderTextureFormat(this ObjectTranslator thiz, RealStatePtr L, int index, UnityEngine.RenderTextureFormat val)
        {
		    
            if (LuaAPI.lua_type(L, index) == LuaTypes.LUA_TUSERDATA)
            {
			    if (LuaAPI.xlua_gettypeid(L, index) != UnityEngineRenderTextureFormat_TypeID)
				{
				    throw new Exception("invalid userdata for UnityEngine.RenderTextureFormat");
				}
				
                IntPtr buff = LuaAPI.lua_touserdata(L, index);
                if (!CopyByValue_Gen.Pack(buff, 0,  (int)val))
                {
                    throw new Exception("pack fail for UnityEngine.RenderTextureFormat ,value="+val);
                }
            }
			
            else
            {
                throw new Exception("try to update a data with lua type:" + LuaAPI.lua_type(L, index));
            }
        }
        
        static int UnityEngineUISelectableTransition_TypeID = -1;
		static int UnityEngineUISelectableTransition_EnumRef = -1;
        
        public static void PushUnityEngineUISelectableTransition(this ObjectTranslator thiz, RealStatePtr L, UnityEngine.UI.Selectable.Transition val)
        {
            if (UnityEngineUISelectableTransition_TypeID == -1)
            {
			    bool is_first;
                UnityEngineUISelectableTransition_TypeID = thiz.getTypeId(L, typeof(UnityEngine.UI.Selectable.Transition), out is_first);
				
				if (UnityEngineUISelectableTransition_EnumRef == -1)
				{
				    Utils.LoadCSTable(L, typeof(UnityEngine.UI.Selectable.Transition));
				    UnityEngineUISelectableTransition_EnumRef = LuaAPI.luaL_ref(L, LuaIndexes.LUA_REGISTRYINDEX);
				}
				
            }
			
			if (LuaAPI.xlua_tryget_cachedud(L, (int)val, UnityEngineUISelectableTransition_EnumRef) == 1)
            {
			    return;
			}
			
            IntPtr buff = LuaAPI.xlua_pushstruct(L, 4, UnityEngineUISelectableTransition_TypeID);
            if (!CopyByValue_Gen.Pack(buff, 0, (int)val))
            {
                throw new Exception("pack fail fail for UnityEngine.UI.Selectable.Transition ,value="+val);
            }
			
			LuaAPI.lua_getref(L, UnityEngineUISelectableTransition_EnumRef);
			LuaAPI.lua_pushvalue(L, -2);
			LuaAPI.xlua_rawseti(L, -2, (int)val);
			LuaAPI.lua_pop(L, 1);
			
        }
		
        public static void GetUnityEngineUISelectableTransition(this ObjectTranslator thiz, RealStatePtr L, int index, out UnityEngine.UI.Selectable.Transition val)
        {
		    LuaTypes type = LuaAPI.lua_type(L, index);
            if (type == LuaTypes.LUA_TUSERDATA )
            {
			    if (LuaAPI.xlua_gettypeid(L, index) != UnityEngineUISelectableTransition_TypeID)
				{
				    throw new Exception("invalid userdata for UnityEngine.UI.Selectable.Transition");
				}
				
                IntPtr buff = LuaAPI.lua_touserdata(L, index);
				int e;
                if (!CopyByValue_Gen.UnPack(buff, 0, out e))
                {
                    throw new Exception("unpack fail for UnityEngine.UI.Selectable.Transition");
                }
				val = (UnityEngine.UI.Selectable.Transition)e;
                
            }
            else
            {
                val = (UnityEngine.UI.Selectable.Transition)thiz.objectCasters.GetCaster(typeof(UnityEngine.UI.Selectable.Transition))(L, index, null);
            }
        }
		
        public static void UpdateUnityEngineUISelectableTransition(this ObjectTranslator thiz, RealStatePtr L, int index, UnityEngine.UI.Selectable.Transition val)
        {
		    
            if (LuaAPI.lua_type(L, index) == LuaTypes.LUA_TUSERDATA)
            {
			    if (LuaAPI.xlua_gettypeid(L, index) != UnityEngineUISelectableTransition_TypeID)
				{
				    throw new Exception("invalid userdata for UnityEngine.UI.Selectable.Transition");
				}
				
                IntPtr buff = LuaAPI.lua_touserdata(L, index);
                if (!CopyByValue_Gen.Pack(buff, 0,  (int)val))
                {
                    throw new Exception("pack fail for UnityEngine.UI.Selectable.Transition ,value="+val);
                }
            }
			
            else
            {
                throw new Exception("try to update a data with lua type:" + LuaAPI.lua_type(L, index));
            }
        }
        
        static int UnityEngineUIInputFieldContentType_TypeID = -1;
		static int UnityEngineUIInputFieldContentType_EnumRef = -1;
        
        public static void PushUnityEngineUIInputFieldContentType(this ObjectTranslator thiz, RealStatePtr L, UnityEngine.UI.InputField.ContentType val)
        {
            if (UnityEngineUIInputFieldContentType_TypeID == -1)
            {
			    bool is_first;
                UnityEngineUIInputFieldContentType_TypeID = thiz.getTypeId(L, typeof(UnityEngine.UI.InputField.ContentType), out is_first);
				
				if (UnityEngineUIInputFieldContentType_EnumRef == -1)
				{
				    Utils.LoadCSTable(L, typeof(UnityEngine.UI.InputField.ContentType));
				    UnityEngineUIInputFieldContentType_EnumRef = LuaAPI.luaL_ref(L, LuaIndexes.LUA_REGISTRYINDEX);
				}
				
            }
			
			if (LuaAPI.xlua_tryget_cachedud(L, (int)val, UnityEngineUIInputFieldContentType_EnumRef) == 1)
            {
			    return;
			}
			
            IntPtr buff = LuaAPI.xlua_pushstruct(L, 4, UnityEngineUIInputFieldContentType_TypeID);
            if (!CopyByValue_Gen.Pack(buff, 0, (int)val))
            {
                throw new Exception("pack fail fail for UnityEngine.UI.InputField.ContentType ,value="+val);
            }
			
			LuaAPI.lua_getref(L, UnityEngineUIInputFieldContentType_EnumRef);
			LuaAPI.lua_pushvalue(L, -2);
			LuaAPI.xlua_rawseti(L, -2, (int)val);
			LuaAPI.lua_pop(L, 1);
			
        }
		
        public static void GetUnityEngineUIInputFieldContentType(this ObjectTranslator thiz, RealStatePtr L, int index, out UnityEngine.UI.InputField.ContentType val)
        {
		    LuaTypes type = LuaAPI.lua_type(L, index);
            if (type == LuaTypes.LUA_TUSERDATA )
            {
			    if (LuaAPI.xlua_gettypeid(L, index) != UnityEngineUIInputFieldContentType_TypeID)
				{
				    throw new Exception("invalid userdata for UnityEngine.UI.InputField.ContentType");
				}
				
                IntPtr buff = LuaAPI.lua_touserdata(L, index);
				int e;
                if (!CopyByValue_Gen.UnPack(buff, 0, out e))
                {
                    throw new Exception("unpack fail for UnityEngine.UI.InputField.ContentType");
                }
				val = (UnityEngine.UI.InputField.ContentType)e;
                
            }
            else
            {
                val = (UnityEngine.UI.InputField.ContentType)thiz.objectCasters.GetCaster(typeof(UnityEngine.UI.InputField.ContentType))(L, index, null);
            }
        }
		
        public static void UpdateUnityEngineUIInputFieldContentType(this ObjectTranslator thiz, RealStatePtr L, int index, UnityEngine.UI.InputField.ContentType val)
        {
		    
            if (LuaAPI.lua_type(L, index) == LuaTypes.LUA_TUSERDATA)
            {
			    if (LuaAPI.xlua_gettypeid(L, index) != UnityEngineUIInputFieldContentType_TypeID)
				{
				    throw new Exception("invalid userdata for UnityEngine.UI.InputField.ContentType");
				}
				
                IntPtr buff = LuaAPI.lua_touserdata(L, index);
                if (!CopyByValue_Gen.Pack(buff, 0,  (int)val))
                {
                    throw new Exception("pack fail for UnityEngine.UI.InputField.ContentType ,value="+val);
                }
            }
			
            else
            {
                throw new Exception("try to update a data with lua type:" + LuaAPI.lua_type(L, index));
            }
        }
        
        static int UnityEngineUIInputFieldInputType_TypeID = -1;
		static int UnityEngineUIInputFieldInputType_EnumRef = -1;
        
        public static void PushUnityEngineUIInputFieldInputType(this ObjectTranslator thiz, RealStatePtr L, UnityEngine.UI.InputField.InputType val)
        {
            if (UnityEngineUIInputFieldInputType_TypeID == -1)
            {
			    bool is_first;
                UnityEngineUIInputFieldInputType_TypeID = thiz.getTypeId(L, typeof(UnityEngine.UI.InputField.InputType), out is_first);
				
				if (UnityEngineUIInputFieldInputType_EnumRef == -1)
				{
				    Utils.LoadCSTable(L, typeof(UnityEngine.UI.InputField.InputType));
				    UnityEngineUIInputFieldInputType_EnumRef = LuaAPI.luaL_ref(L, LuaIndexes.LUA_REGISTRYINDEX);
				}
				
            }
			
			if (LuaAPI.xlua_tryget_cachedud(L, (int)val, UnityEngineUIInputFieldInputType_EnumRef) == 1)
            {
			    return;
			}
			
            IntPtr buff = LuaAPI.xlua_pushstruct(L, 4, UnityEngineUIInputFieldInputType_TypeID);
            if (!CopyByValue_Gen.Pack(buff, 0, (int)val))
            {
                throw new Exception("pack fail fail for UnityEngine.UI.InputField.InputType ,value="+val);
            }
			
			LuaAPI.lua_getref(L, UnityEngineUIInputFieldInputType_EnumRef);
			LuaAPI.lua_pushvalue(L, -2);
			LuaAPI.xlua_rawseti(L, -2, (int)val);
			LuaAPI.lua_pop(L, 1);
			
        }
		
        public static void GetUnityEngineUIInputFieldInputType(this ObjectTranslator thiz, RealStatePtr L, int index, out UnityEngine.UI.InputField.InputType val)
        {
		    LuaTypes type = LuaAPI.lua_type(L, index);
            if (type == LuaTypes.LUA_TUSERDATA )
            {
			    if (LuaAPI.xlua_gettypeid(L, index) != UnityEngineUIInputFieldInputType_TypeID)
				{
				    throw new Exception("invalid userdata for UnityEngine.UI.InputField.InputType");
				}
				
                IntPtr buff = LuaAPI.lua_touserdata(L, index);
				int e;
                if (!CopyByValue_Gen.UnPack(buff, 0, out e))
                {
                    throw new Exception("unpack fail for UnityEngine.UI.InputField.InputType");
                }
				val = (UnityEngine.UI.InputField.InputType)e;
                
            }
            else
            {
                val = (UnityEngine.UI.InputField.InputType)thiz.objectCasters.GetCaster(typeof(UnityEngine.UI.InputField.InputType))(L, index, null);
            }
        }
		
        public static void UpdateUnityEngineUIInputFieldInputType(this ObjectTranslator thiz, RealStatePtr L, int index, UnityEngine.UI.InputField.InputType val)
        {
		    
            if (LuaAPI.lua_type(L, index) == LuaTypes.LUA_TUSERDATA)
            {
			    if (LuaAPI.xlua_gettypeid(L, index) != UnityEngineUIInputFieldInputType_TypeID)
				{
				    throw new Exception("invalid userdata for UnityEngine.UI.InputField.InputType");
				}
				
                IntPtr buff = LuaAPI.lua_touserdata(L, index);
                if (!CopyByValue_Gen.Pack(buff, 0,  (int)val))
                {
                    throw new Exception("pack fail for UnityEngine.UI.InputField.InputType ,value="+val);
                }
            }
			
            else
            {
                throw new Exception("try to update a data with lua type:" + LuaAPI.lua_type(L, index));
            }
        }
        
        static int UnityEngineUIInputFieldCharacterValidation_TypeID = -1;
		static int UnityEngineUIInputFieldCharacterValidation_EnumRef = -1;
        
        public static void PushUnityEngineUIInputFieldCharacterValidation(this ObjectTranslator thiz, RealStatePtr L, UnityEngine.UI.InputField.CharacterValidation val)
        {
            if (UnityEngineUIInputFieldCharacterValidation_TypeID == -1)
            {
			    bool is_first;
                UnityEngineUIInputFieldCharacterValidation_TypeID = thiz.getTypeId(L, typeof(UnityEngine.UI.InputField.CharacterValidation), out is_first);
				
				if (UnityEngineUIInputFieldCharacterValidation_EnumRef == -1)
				{
				    Utils.LoadCSTable(L, typeof(UnityEngine.UI.InputField.CharacterValidation));
				    UnityEngineUIInputFieldCharacterValidation_EnumRef = LuaAPI.luaL_ref(L, LuaIndexes.LUA_REGISTRYINDEX);
				}
				
            }
			
			if (LuaAPI.xlua_tryget_cachedud(L, (int)val, UnityEngineUIInputFieldCharacterValidation_EnumRef) == 1)
            {
			    return;
			}
			
            IntPtr buff = LuaAPI.xlua_pushstruct(L, 4, UnityEngineUIInputFieldCharacterValidation_TypeID);
            if (!CopyByValue_Gen.Pack(buff, 0, (int)val))
            {
                throw new Exception("pack fail fail for UnityEngine.UI.InputField.CharacterValidation ,value="+val);
            }
			
			LuaAPI.lua_getref(L, UnityEngineUIInputFieldCharacterValidation_EnumRef);
			LuaAPI.lua_pushvalue(L, -2);
			LuaAPI.xlua_rawseti(L, -2, (int)val);
			LuaAPI.lua_pop(L, 1);
			
        }
		
        public static void GetUnityEngineUIInputFieldCharacterValidation(this ObjectTranslator thiz, RealStatePtr L, int index, out UnityEngine.UI.InputField.CharacterValidation val)
        {
		    LuaTypes type = LuaAPI.lua_type(L, index);
            if (type == LuaTypes.LUA_TUSERDATA )
            {
			    if (LuaAPI.xlua_gettypeid(L, index) != UnityEngineUIInputFieldCharacterValidation_TypeID)
				{
				    throw new Exception("invalid userdata for UnityEngine.UI.InputField.CharacterValidation");
				}
				
                IntPtr buff = LuaAPI.lua_touserdata(L, index);
				int e;
                if (!CopyByValue_Gen.UnPack(buff, 0, out e))
                {
                    throw new Exception("unpack fail for UnityEngine.UI.InputField.CharacterValidation");
                }
				val = (UnityEngine.UI.InputField.CharacterValidation)e;
                
            }
            else
            {
                val = (UnityEngine.UI.InputField.CharacterValidation)thiz.objectCasters.GetCaster(typeof(UnityEngine.UI.InputField.CharacterValidation))(L, index, null);
            }
        }
		
        public static void UpdateUnityEngineUIInputFieldCharacterValidation(this ObjectTranslator thiz, RealStatePtr L, int index, UnityEngine.UI.InputField.CharacterValidation val)
        {
		    
            if (LuaAPI.lua_type(L, index) == LuaTypes.LUA_TUSERDATA)
            {
			    if (LuaAPI.xlua_gettypeid(L, index) != UnityEngineUIInputFieldCharacterValidation_TypeID)
				{
				    throw new Exception("invalid userdata for UnityEngine.UI.InputField.CharacterValidation");
				}
				
                IntPtr buff = LuaAPI.lua_touserdata(L, index);
                if (!CopyByValue_Gen.Pack(buff, 0,  (int)val))
                {
                    throw new Exception("pack fail for UnityEngine.UI.InputField.CharacterValidation ,value="+val);
                }
            }
			
            else
            {
                throw new Exception("try to update a data with lua type:" + LuaAPI.lua_type(L, index));
            }
        }
        
        static int UnityEngineUIInputFieldLineType_TypeID = -1;
		static int UnityEngineUIInputFieldLineType_EnumRef = -1;
        
        public static void PushUnityEngineUIInputFieldLineType(this ObjectTranslator thiz, RealStatePtr L, UnityEngine.UI.InputField.LineType val)
        {
            if (UnityEngineUIInputFieldLineType_TypeID == -1)
            {
			    bool is_first;
                UnityEngineUIInputFieldLineType_TypeID = thiz.getTypeId(L, typeof(UnityEngine.UI.InputField.LineType), out is_first);
				
				if (UnityEngineUIInputFieldLineType_EnumRef == -1)
				{
				    Utils.LoadCSTable(L, typeof(UnityEngine.UI.InputField.LineType));
				    UnityEngineUIInputFieldLineType_EnumRef = LuaAPI.luaL_ref(L, LuaIndexes.LUA_REGISTRYINDEX);
				}
				
            }
			
			if (LuaAPI.xlua_tryget_cachedud(L, (int)val, UnityEngineUIInputFieldLineType_EnumRef) == 1)
            {
			    return;
			}
			
            IntPtr buff = LuaAPI.xlua_pushstruct(L, 4, UnityEngineUIInputFieldLineType_TypeID);
            if (!CopyByValue_Gen.Pack(buff, 0, (int)val))
            {
                throw new Exception("pack fail fail for UnityEngine.UI.InputField.LineType ,value="+val);
            }
			
			LuaAPI.lua_getref(L, UnityEngineUIInputFieldLineType_EnumRef);
			LuaAPI.lua_pushvalue(L, -2);
			LuaAPI.xlua_rawseti(L, -2, (int)val);
			LuaAPI.lua_pop(L, 1);
			
        }
		
        public static void GetUnityEngineUIInputFieldLineType(this ObjectTranslator thiz, RealStatePtr L, int index, out UnityEngine.UI.InputField.LineType val)
        {
		    LuaTypes type = LuaAPI.lua_type(L, index);
            if (type == LuaTypes.LUA_TUSERDATA )
            {
			    if (LuaAPI.xlua_gettypeid(L, index) != UnityEngineUIInputFieldLineType_TypeID)
				{
				    throw new Exception("invalid userdata for UnityEngine.UI.InputField.LineType");
				}
				
                IntPtr buff = LuaAPI.lua_touserdata(L, index);
				int e;
                if (!CopyByValue_Gen.UnPack(buff, 0, out e))
                {
                    throw new Exception("unpack fail for UnityEngine.UI.InputField.LineType");
                }
				val = (UnityEngine.UI.InputField.LineType)e;
                
            }
            else
            {
                val = (UnityEngine.UI.InputField.LineType)thiz.objectCasters.GetCaster(typeof(UnityEngine.UI.InputField.LineType))(L, index, null);
            }
        }
		
        public static void UpdateUnityEngineUIInputFieldLineType(this ObjectTranslator thiz, RealStatePtr L, int index, UnityEngine.UI.InputField.LineType val)
        {
		    
            if (LuaAPI.lua_type(L, index) == LuaTypes.LUA_TUSERDATA)
            {
			    if (LuaAPI.xlua_gettypeid(L, index) != UnityEngineUIInputFieldLineType_TypeID)
				{
				    throw new Exception("invalid userdata for UnityEngine.UI.InputField.LineType");
				}
				
                IntPtr buff = LuaAPI.lua_touserdata(L, index);
                if (!CopyByValue_Gen.Pack(buff, 0,  (int)val))
                {
                    throw new Exception("pack fail for UnityEngine.UI.InputField.LineType ,value="+val);
                }
            }
			
            else
            {
                throw new Exception("try to update a data with lua type:" + LuaAPI.lua_type(L, index));
            }
        }
        
        static int UnityEngineUIImageType_TypeID = -1;
		static int UnityEngineUIImageType_EnumRef = -1;
        
        public static void PushUnityEngineUIImageType(this ObjectTranslator thiz, RealStatePtr L, UnityEngine.UI.Image.Type val)
        {
            if (UnityEngineUIImageType_TypeID == -1)
            {
			    bool is_first;
                UnityEngineUIImageType_TypeID = thiz.getTypeId(L, typeof(UnityEngine.UI.Image.Type), out is_first);
				
				if (UnityEngineUIImageType_EnumRef == -1)
				{
				    Utils.LoadCSTable(L, typeof(UnityEngine.UI.Image.Type));
				    UnityEngineUIImageType_EnumRef = LuaAPI.luaL_ref(L, LuaIndexes.LUA_REGISTRYINDEX);
				}
				
            }
			
			if (LuaAPI.xlua_tryget_cachedud(L, (int)val, UnityEngineUIImageType_EnumRef) == 1)
            {
			    return;
			}
			
            IntPtr buff = LuaAPI.xlua_pushstruct(L, 4, UnityEngineUIImageType_TypeID);
            if (!CopyByValue_Gen.Pack(buff, 0, (int)val))
            {
                throw new Exception("pack fail fail for UnityEngine.UI.Image.Type ,value="+val);
            }
			
			LuaAPI.lua_getref(L, UnityEngineUIImageType_EnumRef);
			LuaAPI.lua_pushvalue(L, -2);
			LuaAPI.xlua_rawseti(L, -2, (int)val);
			LuaAPI.lua_pop(L, 1);
			
        }
		
        public static void GetUnityEngineUIImageType(this ObjectTranslator thiz, RealStatePtr L, int index, out UnityEngine.UI.Image.Type val)
        {
		    LuaTypes type = LuaAPI.lua_type(L, index);
            if (type == LuaTypes.LUA_TUSERDATA )
            {
			    if (LuaAPI.xlua_gettypeid(L, index) != UnityEngineUIImageType_TypeID)
				{
				    throw new Exception("invalid userdata for UnityEngine.UI.Image.Type");
				}
				
                IntPtr buff = LuaAPI.lua_touserdata(L, index);
				int e;
                if (!CopyByValue_Gen.UnPack(buff, 0, out e))
                {
                    throw new Exception("unpack fail for UnityEngine.UI.Image.Type");
                }
				val = (UnityEngine.UI.Image.Type)e;
                
            }
            else
            {
                val = (UnityEngine.UI.Image.Type)thiz.objectCasters.GetCaster(typeof(UnityEngine.UI.Image.Type))(L, index, null);
            }
        }
		
        public static void UpdateUnityEngineUIImageType(this ObjectTranslator thiz, RealStatePtr L, int index, UnityEngine.UI.Image.Type val)
        {
		    
            if (LuaAPI.lua_type(L, index) == LuaTypes.LUA_TUSERDATA)
            {
			    if (LuaAPI.xlua_gettypeid(L, index) != UnityEngineUIImageType_TypeID)
				{
				    throw new Exception("invalid userdata for UnityEngine.UI.Image.Type");
				}
				
                IntPtr buff = LuaAPI.lua_touserdata(L, index);
                if (!CopyByValue_Gen.Pack(buff, 0,  (int)val))
                {
                    throw new Exception("pack fail for UnityEngine.UI.Image.Type ,value="+val);
                }
            }
			
            else
            {
                throw new Exception("try to update a data with lua type:" + LuaAPI.lua_type(L, index));
            }
        }
        
        static int UnityEngineUIImageFillMethod_TypeID = -1;
		static int UnityEngineUIImageFillMethod_EnumRef = -1;
        
        public static void PushUnityEngineUIImageFillMethod(this ObjectTranslator thiz, RealStatePtr L, UnityEngine.UI.Image.FillMethod val)
        {
            if (UnityEngineUIImageFillMethod_TypeID == -1)
            {
			    bool is_first;
                UnityEngineUIImageFillMethod_TypeID = thiz.getTypeId(L, typeof(UnityEngine.UI.Image.FillMethod), out is_first);
				
				if (UnityEngineUIImageFillMethod_EnumRef == -1)
				{
				    Utils.LoadCSTable(L, typeof(UnityEngine.UI.Image.FillMethod));
				    UnityEngineUIImageFillMethod_EnumRef = LuaAPI.luaL_ref(L, LuaIndexes.LUA_REGISTRYINDEX);
				}
				
            }
			
			if (LuaAPI.xlua_tryget_cachedud(L, (int)val, UnityEngineUIImageFillMethod_EnumRef) == 1)
            {
			    return;
			}
			
            IntPtr buff = LuaAPI.xlua_pushstruct(L, 4, UnityEngineUIImageFillMethod_TypeID);
            if (!CopyByValue_Gen.Pack(buff, 0, (int)val))
            {
                throw new Exception("pack fail fail for UnityEngine.UI.Image.FillMethod ,value="+val);
            }
			
			LuaAPI.lua_getref(L, UnityEngineUIImageFillMethod_EnumRef);
			LuaAPI.lua_pushvalue(L, -2);
			LuaAPI.xlua_rawseti(L, -2, (int)val);
			LuaAPI.lua_pop(L, 1);
			
        }
		
        public static void GetUnityEngineUIImageFillMethod(this ObjectTranslator thiz, RealStatePtr L, int index, out UnityEngine.UI.Image.FillMethod val)
        {
		    LuaTypes type = LuaAPI.lua_type(L, index);
            if (type == LuaTypes.LUA_TUSERDATA )
            {
			    if (LuaAPI.xlua_gettypeid(L, index) != UnityEngineUIImageFillMethod_TypeID)
				{
				    throw new Exception("invalid userdata for UnityEngine.UI.Image.FillMethod");
				}
				
                IntPtr buff = LuaAPI.lua_touserdata(L, index);
				int e;
                if (!CopyByValue_Gen.UnPack(buff, 0, out e))
                {
                    throw new Exception("unpack fail for UnityEngine.UI.Image.FillMethod");
                }
				val = (UnityEngine.UI.Image.FillMethod)e;
                
            }
            else
            {
                val = (UnityEngine.UI.Image.FillMethod)thiz.objectCasters.GetCaster(typeof(UnityEngine.UI.Image.FillMethod))(L, index, null);
            }
        }
		
        public static void UpdateUnityEngineUIImageFillMethod(this ObjectTranslator thiz, RealStatePtr L, int index, UnityEngine.UI.Image.FillMethod val)
        {
		    
            if (LuaAPI.lua_type(L, index) == LuaTypes.LUA_TUSERDATA)
            {
			    if (LuaAPI.xlua_gettypeid(L, index) != UnityEngineUIImageFillMethod_TypeID)
				{
				    throw new Exception("invalid userdata for UnityEngine.UI.Image.FillMethod");
				}
				
                IntPtr buff = LuaAPI.lua_touserdata(L, index);
                if (!CopyByValue_Gen.Pack(buff, 0,  (int)val))
                {
                    throw new Exception("pack fail for UnityEngine.UI.Image.FillMethod ,value="+val);
                }
            }
			
            else
            {
                throw new Exception("try to update a data with lua type:" + LuaAPI.lua_type(L, index));
            }
        }
        
        static int UnityEngineUIImageOriginHorizontal_TypeID = -1;
		static int UnityEngineUIImageOriginHorizontal_EnumRef = -1;
        
        public static void PushUnityEngineUIImageOriginHorizontal(this ObjectTranslator thiz, RealStatePtr L, UnityEngine.UI.Image.OriginHorizontal val)
        {
            if (UnityEngineUIImageOriginHorizontal_TypeID == -1)
            {
			    bool is_first;
                UnityEngineUIImageOriginHorizontal_TypeID = thiz.getTypeId(L, typeof(UnityEngine.UI.Image.OriginHorizontal), out is_first);
				
				if (UnityEngineUIImageOriginHorizontal_EnumRef == -1)
				{
				    Utils.LoadCSTable(L, typeof(UnityEngine.UI.Image.OriginHorizontal));
				    UnityEngineUIImageOriginHorizontal_EnumRef = LuaAPI.luaL_ref(L, LuaIndexes.LUA_REGISTRYINDEX);
				}
				
            }
			
			if (LuaAPI.xlua_tryget_cachedud(L, (int)val, UnityEngineUIImageOriginHorizontal_EnumRef) == 1)
            {
			    return;
			}
			
            IntPtr buff = LuaAPI.xlua_pushstruct(L, 4, UnityEngineUIImageOriginHorizontal_TypeID);
            if (!CopyByValue_Gen.Pack(buff, 0, (int)val))
            {
                throw new Exception("pack fail fail for UnityEngine.UI.Image.OriginHorizontal ,value="+val);
            }
			
			LuaAPI.lua_getref(L, UnityEngineUIImageOriginHorizontal_EnumRef);
			LuaAPI.lua_pushvalue(L, -2);
			LuaAPI.xlua_rawseti(L, -2, (int)val);
			LuaAPI.lua_pop(L, 1);
			
        }
		
        public static void GetUnityEngineUIImageOriginHorizontal(this ObjectTranslator thiz, RealStatePtr L, int index, out UnityEngine.UI.Image.OriginHorizontal val)
        {
		    LuaTypes type = LuaAPI.lua_type(L, index);
            if (type == LuaTypes.LUA_TUSERDATA )
            {
			    if (LuaAPI.xlua_gettypeid(L, index) != UnityEngineUIImageOriginHorizontal_TypeID)
				{
				    throw new Exception("invalid userdata for UnityEngine.UI.Image.OriginHorizontal");
				}
				
                IntPtr buff = LuaAPI.lua_touserdata(L, index);
				int e;
                if (!CopyByValue_Gen.UnPack(buff, 0, out e))
                {
                    throw new Exception("unpack fail for UnityEngine.UI.Image.OriginHorizontal");
                }
				val = (UnityEngine.UI.Image.OriginHorizontal)e;
                
            }
            else
            {
                val = (UnityEngine.UI.Image.OriginHorizontal)thiz.objectCasters.GetCaster(typeof(UnityEngine.UI.Image.OriginHorizontal))(L, index, null);
            }
        }
		
        public static void UpdateUnityEngineUIImageOriginHorizontal(this ObjectTranslator thiz, RealStatePtr L, int index, UnityEngine.UI.Image.OriginHorizontal val)
        {
		    
            if (LuaAPI.lua_type(L, index) == LuaTypes.LUA_TUSERDATA)
            {
			    if (LuaAPI.xlua_gettypeid(L, index) != UnityEngineUIImageOriginHorizontal_TypeID)
				{
				    throw new Exception("invalid userdata for UnityEngine.UI.Image.OriginHorizontal");
				}
				
                IntPtr buff = LuaAPI.lua_touserdata(L, index);
                if (!CopyByValue_Gen.Pack(buff, 0,  (int)val))
                {
                    throw new Exception("pack fail for UnityEngine.UI.Image.OriginHorizontal ,value="+val);
                }
            }
			
            else
            {
                throw new Exception("try to update a data with lua type:" + LuaAPI.lua_type(L, index));
            }
        }
        
        static int UnityEngineUIImageOriginVertical_TypeID = -1;
		static int UnityEngineUIImageOriginVertical_EnumRef = -1;
        
        public static void PushUnityEngineUIImageOriginVertical(this ObjectTranslator thiz, RealStatePtr L, UnityEngine.UI.Image.OriginVertical val)
        {
            if (UnityEngineUIImageOriginVertical_TypeID == -1)
            {
			    bool is_first;
                UnityEngineUIImageOriginVertical_TypeID = thiz.getTypeId(L, typeof(UnityEngine.UI.Image.OriginVertical), out is_first);
				
				if (UnityEngineUIImageOriginVertical_EnumRef == -1)
				{
				    Utils.LoadCSTable(L, typeof(UnityEngine.UI.Image.OriginVertical));
				    UnityEngineUIImageOriginVertical_EnumRef = LuaAPI.luaL_ref(L, LuaIndexes.LUA_REGISTRYINDEX);
				}
				
            }
			
			if (LuaAPI.xlua_tryget_cachedud(L, (int)val, UnityEngineUIImageOriginVertical_EnumRef) == 1)
            {
			    return;
			}
			
            IntPtr buff = LuaAPI.xlua_pushstruct(L, 4, UnityEngineUIImageOriginVertical_TypeID);
            if (!CopyByValue_Gen.Pack(buff, 0, (int)val))
            {
                throw new Exception("pack fail fail for UnityEngine.UI.Image.OriginVertical ,value="+val);
            }
			
			LuaAPI.lua_getref(L, UnityEngineUIImageOriginVertical_EnumRef);
			LuaAPI.lua_pushvalue(L, -2);
			LuaAPI.xlua_rawseti(L, -2, (int)val);
			LuaAPI.lua_pop(L, 1);
			
        }
		
        public static void GetUnityEngineUIImageOriginVertical(this ObjectTranslator thiz, RealStatePtr L, int index, out UnityEngine.UI.Image.OriginVertical val)
        {
		    LuaTypes type = LuaAPI.lua_type(L, index);
            if (type == LuaTypes.LUA_TUSERDATA )
            {
			    if (LuaAPI.xlua_gettypeid(L, index) != UnityEngineUIImageOriginVertical_TypeID)
				{
				    throw new Exception("invalid userdata for UnityEngine.UI.Image.OriginVertical");
				}
				
                IntPtr buff = LuaAPI.lua_touserdata(L, index);
				int e;
                if (!CopyByValue_Gen.UnPack(buff, 0, out e))
                {
                    throw new Exception("unpack fail for UnityEngine.UI.Image.OriginVertical");
                }
				val = (UnityEngine.UI.Image.OriginVertical)e;
                
            }
            else
            {
                val = (UnityEngine.UI.Image.OriginVertical)thiz.objectCasters.GetCaster(typeof(UnityEngine.UI.Image.OriginVertical))(L, index, null);
            }
        }
		
        public static void UpdateUnityEngineUIImageOriginVertical(this ObjectTranslator thiz, RealStatePtr L, int index, UnityEngine.UI.Image.OriginVertical val)
        {
		    
            if (LuaAPI.lua_type(L, index) == LuaTypes.LUA_TUSERDATA)
            {
			    if (LuaAPI.xlua_gettypeid(L, index) != UnityEngineUIImageOriginVertical_TypeID)
				{
				    throw new Exception("invalid userdata for UnityEngine.UI.Image.OriginVertical");
				}
				
                IntPtr buff = LuaAPI.lua_touserdata(L, index);
                if (!CopyByValue_Gen.Pack(buff, 0,  (int)val))
                {
                    throw new Exception("pack fail for UnityEngine.UI.Image.OriginVertical ,value="+val);
                }
            }
			
            else
            {
                throw new Exception("try to update a data with lua type:" + LuaAPI.lua_type(L, index));
            }
        }
        
        static int UnityEngineUIImageOrigin90_TypeID = -1;
		static int UnityEngineUIImageOrigin90_EnumRef = -1;
        
        public static void PushUnityEngineUIImageOrigin90(this ObjectTranslator thiz, RealStatePtr L, UnityEngine.UI.Image.Origin90 val)
        {
            if (UnityEngineUIImageOrigin90_TypeID == -1)
            {
			    bool is_first;
                UnityEngineUIImageOrigin90_TypeID = thiz.getTypeId(L, typeof(UnityEngine.UI.Image.Origin90), out is_first);
				
				if (UnityEngineUIImageOrigin90_EnumRef == -1)
				{
				    Utils.LoadCSTable(L, typeof(UnityEngine.UI.Image.Origin90));
				    UnityEngineUIImageOrigin90_EnumRef = LuaAPI.luaL_ref(L, LuaIndexes.LUA_REGISTRYINDEX);
				}
				
            }
			
			if (LuaAPI.xlua_tryget_cachedud(L, (int)val, UnityEngineUIImageOrigin90_EnumRef) == 1)
            {
			    return;
			}
			
            IntPtr buff = LuaAPI.xlua_pushstruct(L, 4, UnityEngineUIImageOrigin90_TypeID);
            if (!CopyByValue_Gen.Pack(buff, 0, (int)val))
            {
                throw new Exception("pack fail fail for UnityEngine.UI.Image.Origin90 ,value="+val);
            }
			
			LuaAPI.lua_getref(L, UnityEngineUIImageOrigin90_EnumRef);
			LuaAPI.lua_pushvalue(L, -2);
			LuaAPI.xlua_rawseti(L, -2, (int)val);
			LuaAPI.lua_pop(L, 1);
			
        }
		
        public static void GetUnityEngineUIImageOrigin90(this ObjectTranslator thiz, RealStatePtr L, int index, out UnityEngine.UI.Image.Origin90 val)
        {
		    LuaTypes type = LuaAPI.lua_type(L, index);
            if (type == LuaTypes.LUA_TUSERDATA )
            {
			    if (LuaAPI.xlua_gettypeid(L, index) != UnityEngineUIImageOrigin90_TypeID)
				{
				    throw new Exception("invalid userdata for UnityEngine.UI.Image.Origin90");
				}
				
                IntPtr buff = LuaAPI.lua_touserdata(L, index);
				int e;
                if (!CopyByValue_Gen.UnPack(buff, 0, out e))
                {
                    throw new Exception("unpack fail for UnityEngine.UI.Image.Origin90");
                }
				val = (UnityEngine.UI.Image.Origin90)e;
                
            }
            else
            {
                val = (UnityEngine.UI.Image.Origin90)thiz.objectCasters.GetCaster(typeof(UnityEngine.UI.Image.Origin90))(L, index, null);
            }
        }
		
        public static void UpdateUnityEngineUIImageOrigin90(this ObjectTranslator thiz, RealStatePtr L, int index, UnityEngine.UI.Image.Origin90 val)
        {
		    
            if (LuaAPI.lua_type(L, index) == LuaTypes.LUA_TUSERDATA)
            {
			    if (LuaAPI.xlua_gettypeid(L, index) != UnityEngineUIImageOrigin90_TypeID)
				{
				    throw new Exception("invalid userdata for UnityEngine.UI.Image.Origin90");
				}
				
                IntPtr buff = LuaAPI.lua_touserdata(L, index);
                if (!CopyByValue_Gen.Pack(buff, 0,  (int)val))
                {
                    throw new Exception("pack fail for UnityEngine.UI.Image.Origin90 ,value="+val);
                }
            }
			
            else
            {
                throw new Exception("try to update a data with lua type:" + LuaAPI.lua_type(L, index));
            }
        }
        
        static int UnityEngineUIImageOrigin180_TypeID = -1;
		static int UnityEngineUIImageOrigin180_EnumRef = -1;
        
        public static void PushUnityEngineUIImageOrigin180(this ObjectTranslator thiz, RealStatePtr L, UnityEngine.UI.Image.Origin180 val)
        {
            if (UnityEngineUIImageOrigin180_TypeID == -1)
            {
			    bool is_first;
                UnityEngineUIImageOrigin180_TypeID = thiz.getTypeId(L, typeof(UnityEngine.UI.Image.Origin180), out is_first);
				
				if (UnityEngineUIImageOrigin180_EnumRef == -1)
				{
				    Utils.LoadCSTable(L, typeof(UnityEngine.UI.Image.Origin180));
				    UnityEngineUIImageOrigin180_EnumRef = LuaAPI.luaL_ref(L, LuaIndexes.LUA_REGISTRYINDEX);
				}
				
            }
			
			if (LuaAPI.xlua_tryget_cachedud(L, (int)val, UnityEngineUIImageOrigin180_EnumRef) == 1)
            {
			    return;
			}
			
            IntPtr buff = LuaAPI.xlua_pushstruct(L, 4, UnityEngineUIImageOrigin180_TypeID);
            if (!CopyByValue_Gen.Pack(buff, 0, (int)val))
            {
                throw new Exception("pack fail fail for UnityEngine.UI.Image.Origin180 ,value="+val);
            }
			
			LuaAPI.lua_getref(L, UnityEngineUIImageOrigin180_EnumRef);
			LuaAPI.lua_pushvalue(L, -2);
			LuaAPI.xlua_rawseti(L, -2, (int)val);
			LuaAPI.lua_pop(L, 1);
			
        }
		
        public static void GetUnityEngineUIImageOrigin180(this ObjectTranslator thiz, RealStatePtr L, int index, out UnityEngine.UI.Image.Origin180 val)
        {
		    LuaTypes type = LuaAPI.lua_type(L, index);
            if (type == LuaTypes.LUA_TUSERDATA )
            {
			    if (LuaAPI.xlua_gettypeid(L, index) != UnityEngineUIImageOrigin180_TypeID)
				{
				    throw new Exception("invalid userdata for UnityEngine.UI.Image.Origin180");
				}
				
                IntPtr buff = LuaAPI.lua_touserdata(L, index);
				int e;
                if (!CopyByValue_Gen.UnPack(buff, 0, out e))
                {
                    throw new Exception("unpack fail for UnityEngine.UI.Image.Origin180");
                }
				val = (UnityEngine.UI.Image.Origin180)e;
                
            }
            else
            {
                val = (UnityEngine.UI.Image.Origin180)thiz.objectCasters.GetCaster(typeof(UnityEngine.UI.Image.Origin180))(L, index, null);
            }
        }
		
        public static void UpdateUnityEngineUIImageOrigin180(this ObjectTranslator thiz, RealStatePtr L, int index, UnityEngine.UI.Image.Origin180 val)
        {
		    
            if (LuaAPI.lua_type(L, index) == LuaTypes.LUA_TUSERDATA)
            {
			    if (LuaAPI.xlua_gettypeid(L, index) != UnityEngineUIImageOrigin180_TypeID)
				{
				    throw new Exception("invalid userdata for UnityEngine.UI.Image.Origin180");
				}
				
                IntPtr buff = LuaAPI.lua_touserdata(L, index);
                if (!CopyByValue_Gen.Pack(buff, 0,  (int)val))
                {
                    throw new Exception("pack fail for UnityEngine.UI.Image.Origin180 ,value="+val);
                }
            }
			
            else
            {
                throw new Exception("try to update a data with lua type:" + LuaAPI.lua_type(L, index));
            }
        }
        
        static int UnityEngineUIImageOrigin360_TypeID = -1;
		static int UnityEngineUIImageOrigin360_EnumRef = -1;
        
        public static void PushUnityEngineUIImageOrigin360(this ObjectTranslator thiz, RealStatePtr L, UnityEngine.UI.Image.Origin360 val)
        {
            if (UnityEngineUIImageOrigin360_TypeID == -1)
            {
			    bool is_first;
                UnityEngineUIImageOrigin360_TypeID = thiz.getTypeId(L, typeof(UnityEngine.UI.Image.Origin360), out is_first);
				
				if (UnityEngineUIImageOrigin360_EnumRef == -1)
				{
				    Utils.LoadCSTable(L, typeof(UnityEngine.UI.Image.Origin360));
				    UnityEngineUIImageOrigin360_EnumRef = LuaAPI.luaL_ref(L, LuaIndexes.LUA_REGISTRYINDEX);
				}
				
            }
			
			if (LuaAPI.xlua_tryget_cachedud(L, (int)val, UnityEngineUIImageOrigin360_EnumRef) == 1)
            {
			    return;
			}
			
            IntPtr buff = LuaAPI.xlua_pushstruct(L, 4, UnityEngineUIImageOrigin360_TypeID);
            if (!CopyByValue_Gen.Pack(buff, 0, (int)val))
            {
                throw new Exception("pack fail fail for UnityEngine.UI.Image.Origin360 ,value="+val);
            }
			
			LuaAPI.lua_getref(L, UnityEngineUIImageOrigin360_EnumRef);
			LuaAPI.lua_pushvalue(L, -2);
			LuaAPI.xlua_rawseti(L, -2, (int)val);
			LuaAPI.lua_pop(L, 1);
			
        }
		
        public static void GetUnityEngineUIImageOrigin360(this ObjectTranslator thiz, RealStatePtr L, int index, out UnityEngine.UI.Image.Origin360 val)
        {
		    LuaTypes type = LuaAPI.lua_type(L, index);
            if (type == LuaTypes.LUA_TUSERDATA )
            {
			    if (LuaAPI.xlua_gettypeid(L, index) != UnityEngineUIImageOrigin360_TypeID)
				{
				    throw new Exception("invalid userdata for UnityEngine.UI.Image.Origin360");
				}
				
                IntPtr buff = LuaAPI.lua_touserdata(L, index);
				int e;
                if (!CopyByValue_Gen.UnPack(buff, 0, out e))
                {
                    throw new Exception("unpack fail for UnityEngine.UI.Image.Origin360");
                }
				val = (UnityEngine.UI.Image.Origin360)e;
                
            }
            else
            {
                val = (UnityEngine.UI.Image.Origin360)thiz.objectCasters.GetCaster(typeof(UnityEngine.UI.Image.Origin360))(L, index, null);
            }
        }
		
        public static void UpdateUnityEngineUIImageOrigin360(this ObjectTranslator thiz, RealStatePtr L, int index, UnityEngine.UI.Image.Origin360 val)
        {
		    
            if (LuaAPI.lua_type(L, index) == LuaTypes.LUA_TUSERDATA)
            {
			    if (LuaAPI.xlua_gettypeid(L, index) != UnityEngineUIImageOrigin360_TypeID)
				{
				    throw new Exception("invalid userdata for UnityEngine.UI.Image.Origin360");
				}
				
                IntPtr buff = LuaAPI.lua_touserdata(L, index);
                if (!CopyByValue_Gen.Pack(buff, 0,  (int)val))
                {
                    throw new Exception("pack fail for UnityEngine.UI.Image.Origin360 ,value="+val);
                }
            }
			
            else
            {
                throw new Exception("try to update a data with lua type:" + LuaAPI.lua_type(L, index));
            }
        }
        
        static int UnityEngineUIScrollRectMovementType_TypeID = -1;
		static int UnityEngineUIScrollRectMovementType_EnumRef = -1;
        
        public static void PushUnityEngineUIScrollRectMovementType(this ObjectTranslator thiz, RealStatePtr L, UnityEngine.UI.ScrollRect.MovementType val)
        {
            if (UnityEngineUIScrollRectMovementType_TypeID == -1)
            {
			    bool is_first;
                UnityEngineUIScrollRectMovementType_TypeID = thiz.getTypeId(L, typeof(UnityEngine.UI.ScrollRect.MovementType), out is_first);
				
				if (UnityEngineUIScrollRectMovementType_EnumRef == -1)
				{
				    Utils.LoadCSTable(L, typeof(UnityEngine.UI.ScrollRect.MovementType));
				    UnityEngineUIScrollRectMovementType_EnumRef = LuaAPI.luaL_ref(L, LuaIndexes.LUA_REGISTRYINDEX);
				}
				
            }
			
			if (LuaAPI.xlua_tryget_cachedud(L, (int)val, UnityEngineUIScrollRectMovementType_EnumRef) == 1)
            {
			    return;
			}
			
            IntPtr buff = LuaAPI.xlua_pushstruct(L, 4, UnityEngineUIScrollRectMovementType_TypeID);
            if (!CopyByValue_Gen.Pack(buff, 0, (int)val))
            {
                throw new Exception("pack fail fail for UnityEngine.UI.ScrollRect.MovementType ,value="+val);
            }
			
			LuaAPI.lua_getref(L, UnityEngineUIScrollRectMovementType_EnumRef);
			LuaAPI.lua_pushvalue(L, -2);
			LuaAPI.xlua_rawseti(L, -2, (int)val);
			LuaAPI.lua_pop(L, 1);
			
        }
		
        public static void GetUnityEngineUIScrollRectMovementType(this ObjectTranslator thiz, RealStatePtr L, int index, out UnityEngine.UI.ScrollRect.MovementType val)
        {
		    LuaTypes type = LuaAPI.lua_type(L, index);
            if (type == LuaTypes.LUA_TUSERDATA )
            {
			    if (LuaAPI.xlua_gettypeid(L, index) != UnityEngineUIScrollRectMovementType_TypeID)
				{
				    throw new Exception("invalid userdata for UnityEngine.UI.ScrollRect.MovementType");
				}
				
                IntPtr buff = LuaAPI.lua_touserdata(L, index);
				int e;
                if (!CopyByValue_Gen.UnPack(buff, 0, out e))
                {
                    throw new Exception("unpack fail for UnityEngine.UI.ScrollRect.MovementType");
                }
				val = (UnityEngine.UI.ScrollRect.MovementType)e;
                
            }
            else
            {
                val = (UnityEngine.UI.ScrollRect.MovementType)thiz.objectCasters.GetCaster(typeof(UnityEngine.UI.ScrollRect.MovementType))(L, index, null);
            }
        }
		
        public static void UpdateUnityEngineUIScrollRectMovementType(this ObjectTranslator thiz, RealStatePtr L, int index, UnityEngine.UI.ScrollRect.MovementType val)
        {
		    
            if (LuaAPI.lua_type(L, index) == LuaTypes.LUA_TUSERDATA)
            {
			    if (LuaAPI.xlua_gettypeid(L, index) != UnityEngineUIScrollRectMovementType_TypeID)
				{
				    throw new Exception("invalid userdata for UnityEngine.UI.ScrollRect.MovementType");
				}
				
                IntPtr buff = LuaAPI.lua_touserdata(L, index);
                if (!CopyByValue_Gen.Pack(buff, 0,  (int)val))
                {
                    throw new Exception("pack fail for UnityEngine.UI.ScrollRect.MovementType ,value="+val);
                }
            }
			
            else
            {
                throw new Exception("try to update a data with lua type:" + LuaAPI.lua_type(L, index));
            }
        }
        
        static int UnityEngineUIScrollRectScrollbarVisibility_TypeID = -1;
		static int UnityEngineUIScrollRectScrollbarVisibility_EnumRef = -1;
        
        public static void PushUnityEngineUIScrollRectScrollbarVisibility(this ObjectTranslator thiz, RealStatePtr L, UnityEngine.UI.ScrollRect.ScrollbarVisibility val)
        {
            if (UnityEngineUIScrollRectScrollbarVisibility_TypeID == -1)
            {
			    bool is_first;
                UnityEngineUIScrollRectScrollbarVisibility_TypeID = thiz.getTypeId(L, typeof(UnityEngine.UI.ScrollRect.ScrollbarVisibility), out is_first);
				
				if (UnityEngineUIScrollRectScrollbarVisibility_EnumRef == -1)
				{
				    Utils.LoadCSTable(L, typeof(UnityEngine.UI.ScrollRect.ScrollbarVisibility));
				    UnityEngineUIScrollRectScrollbarVisibility_EnumRef = LuaAPI.luaL_ref(L, LuaIndexes.LUA_REGISTRYINDEX);
				}
				
            }
			
			if (LuaAPI.xlua_tryget_cachedud(L, (int)val, UnityEngineUIScrollRectScrollbarVisibility_EnumRef) == 1)
            {
			    return;
			}
			
            IntPtr buff = LuaAPI.xlua_pushstruct(L, 4, UnityEngineUIScrollRectScrollbarVisibility_TypeID);
            if (!CopyByValue_Gen.Pack(buff, 0, (int)val))
            {
                throw new Exception("pack fail fail for UnityEngine.UI.ScrollRect.ScrollbarVisibility ,value="+val);
            }
			
			LuaAPI.lua_getref(L, UnityEngineUIScrollRectScrollbarVisibility_EnumRef);
			LuaAPI.lua_pushvalue(L, -2);
			LuaAPI.xlua_rawseti(L, -2, (int)val);
			LuaAPI.lua_pop(L, 1);
			
        }
		
        public static void GetUnityEngineUIScrollRectScrollbarVisibility(this ObjectTranslator thiz, RealStatePtr L, int index, out UnityEngine.UI.ScrollRect.ScrollbarVisibility val)
        {
		    LuaTypes type = LuaAPI.lua_type(L, index);
            if (type == LuaTypes.LUA_TUSERDATA )
            {
			    if (LuaAPI.xlua_gettypeid(L, index) != UnityEngineUIScrollRectScrollbarVisibility_TypeID)
				{
				    throw new Exception("invalid userdata for UnityEngine.UI.ScrollRect.ScrollbarVisibility");
				}
				
                IntPtr buff = LuaAPI.lua_touserdata(L, index);
				int e;
                if (!CopyByValue_Gen.UnPack(buff, 0, out e))
                {
                    throw new Exception("unpack fail for UnityEngine.UI.ScrollRect.ScrollbarVisibility");
                }
				val = (UnityEngine.UI.ScrollRect.ScrollbarVisibility)e;
                
            }
            else
            {
                val = (UnityEngine.UI.ScrollRect.ScrollbarVisibility)thiz.objectCasters.GetCaster(typeof(UnityEngine.UI.ScrollRect.ScrollbarVisibility))(L, index, null);
            }
        }
		
        public static void UpdateUnityEngineUIScrollRectScrollbarVisibility(this ObjectTranslator thiz, RealStatePtr L, int index, UnityEngine.UI.ScrollRect.ScrollbarVisibility val)
        {
		    
            if (LuaAPI.lua_type(L, index) == LuaTypes.LUA_TUSERDATA)
            {
			    if (LuaAPI.xlua_gettypeid(L, index) != UnityEngineUIScrollRectScrollbarVisibility_TypeID)
				{
				    throw new Exception("invalid userdata for UnityEngine.UI.ScrollRect.ScrollbarVisibility");
				}
				
                IntPtr buff = LuaAPI.lua_touserdata(L, index);
                if (!CopyByValue_Gen.Pack(buff, 0,  (int)val))
                {
                    throw new Exception("pack fail for UnityEngine.UI.ScrollRect.ScrollbarVisibility ,value="+val);
                }
            }
			
            else
            {
                throw new Exception("try to update a data with lua type:" + LuaAPI.lua_type(L, index));
            }
        }
        
        static int UnityEngineUISliderDirection_TypeID = -1;
		static int UnityEngineUISliderDirection_EnumRef = -1;
        
        public static void PushUnityEngineUISliderDirection(this ObjectTranslator thiz, RealStatePtr L, UnityEngine.UI.Slider.Direction val)
        {
            if (UnityEngineUISliderDirection_TypeID == -1)
            {
			    bool is_first;
                UnityEngineUISliderDirection_TypeID = thiz.getTypeId(L, typeof(UnityEngine.UI.Slider.Direction), out is_first);
				
				if (UnityEngineUISliderDirection_EnumRef == -1)
				{
				    Utils.LoadCSTable(L, typeof(UnityEngine.UI.Slider.Direction));
				    UnityEngineUISliderDirection_EnumRef = LuaAPI.luaL_ref(L, LuaIndexes.LUA_REGISTRYINDEX);
				}
				
            }
			
			if (LuaAPI.xlua_tryget_cachedud(L, (int)val, UnityEngineUISliderDirection_EnumRef) == 1)
            {
			    return;
			}
			
            IntPtr buff = LuaAPI.xlua_pushstruct(L, 4, UnityEngineUISliderDirection_TypeID);
            if (!CopyByValue_Gen.Pack(buff, 0, (int)val))
            {
                throw new Exception("pack fail fail for UnityEngine.UI.Slider.Direction ,value="+val);
            }
			
			LuaAPI.lua_getref(L, UnityEngineUISliderDirection_EnumRef);
			LuaAPI.lua_pushvalue(L, -2);
			LuaAPI.xlua_rawseti(L, -2, (int)val);
			LuaAPI.lua_pop(L, 1);
			
        }
		
        public static void GetUnityEngineUISliderDirection(this ObjectTranslator thiz, RealStatePtr L, int index, out UnityEngine.UI.Slider.Direction val)
        {
		    LuaTypes type = LuaAPI.lua_type(L, index);
            if (type == LuaTypes.LUA_TUSERDATA )
            {
			    if (LuaAPI.xlua_gettypeid(L, index) != UnityEngineUISliderDirection_TypeID)
				{
				    throw new Exception("invalid userdata for UnityEngine.UI.Slider.Direction");
				}
				
                IntPtr buff = LuaAPI.lua_touserdata(L, index);
				int e;
                if (!CopyByValue_Gen.UnPack(buff, 0, out e))
                {
                    throw new Exception("unpack fail for UnityEngine.UI.Slider.Direction");
                }
				val = (UnityEngine.UI.Slider.Direction)e;
                
            }
            else
            {
                val = (UnityEngine.UI.Slider.Direction)thiz.objectCasters.GetCaster(typeof(UnityEngine.UI.Slider.Direction))(L, index, null);
            }
        }
		
        public static void UpdateUnityEngineUISliderDirection(this ObjectTranslator thiz, RealStatePtr L, int index, UnityEngine.UI.Slider.Direction val)
        {
		    
            if (LuaAPI.lua_type(L, index) == LuaTypes.LUA_TUSERDATA)
            {
			    if (LuaAPI.xlua_gettypeid(L, index) != UnityEngineUISliderDirection_TypeID)
				{
				    throw new Exception("invalid userdata for UnityEngine.UI.Slider.Direction");
				}
				
                IntPtr buff = LuaAPI.lua_touserdata(L, index);
                if (!CopyByValue_Gen.Pack(buff, 0,  (int)val))
                {
                    throw new Exception("pack fail for UnityEngine.UI.Slider.Direction ,value="+val);
                }
            }
			
            else
            {
                throw new Exception("try to update a data with lua type:" + LuaAPI.lua_type(L, index));
            }
        }
        
        static int UnityEngineUIToggleToggleTransition_TypeID = -1;
		static int UnityEngineUIToggleToggleTransition_EnumRef = -1;
        
        public static void PushUnityEngineUIToggleToggleTransition(this ObjectTranslator thiz, RealStatePtr L, UnityEngine.UI.Toggle.ToggleTransition val)
        {
            if (UnityEngineUIToggleToggleTransition_TypeID == -1)
            {
			    bool is_first;
                UnityEngineUIToggleToggleTransition_TypeID = thiz.getTypeId(L, typeof(UnityEngine.UI.Toggle.ToggleTransition), out is_first);
				
				if (UnityEngineUIToggleToggleTransition_EnumRef == -1)
				{
				    Utils.LoadCSTable(L, typeof(UnityEngine.UI.Toggle.ToggleTransition));
				    UnityEngineUIToggleToggleTransition_EnumRef = LuaAPI.luaL_ref(L, LuaIndexes.LUA_REGISTRYINDEX);
				}
				
            }
			
			if (LuaAPI.xlua_tryget_cachedud(L, (int)val, UnityEngineUIToggleToggleTransition_EnumRef) == 1)
            {
			    return;
			}
			
            IntPtr buff = LuaAPI.xlua_pushstruct(L, 4, UnityEngineUIToggleToggleTransition_TypeID);
            if (!CopyByValue_Gen.Pack(buff, 0, (int)val))
            {
                throw new Exception("pack fail fail for UnityEngine.UI.Toggle.ToggleTransition ,value="+val);
            }
			
			LuaAPI.lua_getref(L, UnityEngineUIToggleToggleTransition_EnumRef);
			LuaAPI.lua_pushvalue(L, -2);
			LuaAPI.xlua_rawseti(L, -2, (int)val);
			LuaAPI.lua_pop(L, 1);
			
        }
		
        public static void GetUnityEngineUIToggleToggleTransition(this ObjectTranslator thiz, RealStatePtr L, int index, out UnityEngine.UI.Toggle.ToggleTransition val)
        {
		    LuaTypes type = LuaAPI.lua_type(L, index);
            if (type == LuaTypes.LUA_TUSERDATA )
            {
			    if (LuaAPI.xlua_gettypeid(L, index) != UnityEngineUIToggleToggleTransition_TypeID)
				{
				    throw new Exception("invalid userdata for UnityEngine.UI.Toggle.ToggleTransition");
				}
				
                IntPtr buff = LuaAPI.lua_touserdata(L, index);
				int e;
                if (!CopyByValue_Gen.UnPack(buff, 0, out e))
                {
                    throw new Exception("unpack fail for UnityEngine.UI.Toggle.ToggleTransition");
                }
				val = (UnityEngine.UI.Toggle.ToggleTransition)e;
                
            }
            else
            {
                val = (UnityEngine.UI.Toggle.ToggleTransition)thiz.objectCasters.GetCaster(typeof(UnityEngine.UI.Toggle.ToggleTransition))(L, index, null);
            }
        }
		
        public static void UpdateUnityEngineUIToggleToggleTransition(this ObjectTranslator thiz, RealStatePtr L, int index, UnityEngine.UI.Toggle.ToggleTransition val)
        {
		    
            if (LuaAPI.lua_type(L, index) == LuaTypes.LUA_TUSERDATA)
            {
			    if (LuaAPI.xlua_gettypeid(L, index) != UnityEngineUIToggleToggleTransition_TypeID)
				{
				    throw new Exception("invalid userdata for UnityEngine.UI.Toggle.ToggleTransition");
				}
				
                IntPtr buff = LuaAPI.lua_touserdata(L, index);
                if (!CopyByValue_Gen.Pack(buff, 0,  (int)val))
                {
                    throw new Exception("pack fail for UnityEngine.UI.Toggle.ToggleTransition ,value="+val);
                }
            }
			
            else
            {
                throw new Exception("try to update a data with lua type:" + LuaAPI.lua_type(L, index));
            }
        }
        
        static int SuperTextMeshAlignment_TypeID = -1;
		static int SuperTextMeshAlignment_EnumRef = -1;
        
        public static void PushSuperTextMeshAlignment(this ObjectTranslator thiz, RealStatePtr L, SuperTextMesh.Alignment val)
        {
            if (SuperTextMeshAlignment_TypeID == -1)
            {
			    bool is_first;
                SuperTextMeshAlignment_TypeID = thiz.getTypeId(L, typeof(SuperTextMesh.Alignment), out is_first);
				
				if (SuperTextMeshAlignment_EnumRef == -1)
				{
				    Utils.LoadCSTable(L, typeof(SuperTextMesh.Alignment));
				    SuperTextMeshAlignment_EnumRef = LuaAPI.luaL_ref(L, LuaIndexes.LUA_REGISTRYINDEX);
				}
				
            }
			
			if (LuaAPI.xlua_tryget_cachedud(L, (int)val, SuperTextMeshAlignment_EnumRef) == 1)
            {
			    return;
			}
			
            IntPtr buff = LuaAPI.xlua_pushstruct(L, 4, SuperTextMeshAlignment_TypeID);
            if (!CopyByValue_Gen.Pack(buff, 0, (int)val))
            {
                throw new Exception("pack fail fail for SuperTextMesh.Alignment ,value="+val);
            }
			
			LuaAPI.lua_getref(L, SuperTextMeshAlignment_EnumRef);
			LuaAPI.lua_pushvalue(L, -2);
			LuaAPI.xlua_rawseti(L, -2, (int)val);
			LuaAPI.lua_pop(L, 1);
			
        }
		
        public static void GetSuperTextMeshAlignment(this ObjectTranslator thiz, RealStatePtr L, int index, out SuperTextMesh.Alignment val)
        {
		    LuaTypes type = LuaAPI.lua_type(L, index);
            if (type == LuaTypes.LUA_TUSERDATA )
            {
			    if (LuaAPI.xlua_gettypeid(L, index) != SuperTextMeshAlignment_TypeID)
				{
				    throw new Exception("invalid userdata for SuperTextMesh.Alignment");
				}
				
                IntPtr buff = LuaAPI.lua_touserdata(L, index);
				int e;
                if (!CopyByValue_Gen.UnPack(buff, 0, out e))
                {
                    throw new Exception("unpack fail for SuperTextMesh.Alignment");
                }
				val = (SuperTextMesh.Alignment)e;
                
            }
            else
            {
                val = (SuperTextMesh.Alignment)thiz.objectCasters.GetCaster(typeof(SuperTextMesh.Alignment))(L, index, null);
            }
        }
		
        public static void UpdateSuperTextMeshAlignment(this ObjectTranslator thiz, RealStatePtr L, int index, SuperTextMesh.Alignment val)
        {
		    
            if (LuaAPI.lua_type(L, index) == LuaTypes.LUA_TUSERDATA)
            {
			    if (LuaAPI.xlua_gettypeid(L, index) != SuperTextMeshAlignment_TypeID)
				{
				    throw new Exception("invalid userdata for SuperTextMesh.Alignment");
				}
				
                IntPtr buff = LuaAPI.lua_touserdata(L, index);
                if (!CopyByValue_Gen.Pack(buff, 0,  (int)val))
                {
                    throw new Exception("pack fail for SuperTextMesh.Alignment ,value="+val);
                }
            }
			
            else
            {
                throw new Exception("try to update a data with lua type:" + LuaAPI.lua_type(L, index));
            }
        }
        
        static int UnityEngineAINavMeshPathStatus_TypeID = -1;
		static int UnityEngineAINavMeshPathStatus_EnumRef = -1;
        
        public static void PushUnityEngineAINavMeshPathStatus(this ObjectTranslator thiz, RealStatePtr L, UnityEngine.AI.NavMeshPathStatus val)
        {
            if (UnityEngineAINavMeshPathStatus_TypeID == -1)
            {
			    bool is_first;
                UnityEngineAINavMeshPathStatus_TypeID = thiz.getTypeId(L, typeof(UnityEngine.AI.NavMeshPathStatus), out is_first);
				
				if (UnityEngineAINavMeshPathStatus_EnumRef == -1)
				{
				    Utils.LoadCSTable(L, typeof(UnityEngine.AI.NavMeshPathStatus));
				    UnityEngineAINavMeshPathStatus_EnumRef = LuaAPI.luaL_ref(L, LuaIndexes.LUA_REGISTRYINDEX);
				}
				
            }
			
			if (LuaAPI.xlua_tryget_cachedud(L, (int)val, UnityEngineAINavMeshPathStatus_EnumRef) == 1)
            {
			    return;
			}
			
            IntPtr buff = LuaAPI.xlua_pushstruct(L, 4, UnityEngineAINavMeshPathStatus_TypeID);
            if (!CopyByValue_Gen.Pack(buff, 0, (int)val))
            {
                throw new Exception("pack fail fail for UnityEngine.AI.NavMeshPathStatus ,value="+val);
            }
			
			LuaAPI.lua_getref(L, UnityEngineAINavMeshPathStatus_EnumRef);
			LuaAPI.lua_pushvalue(L, -2);
			LuaAPI.xlua_rawseti(L, -2, (int)val);
			LuaAPI.lua_pop(L, 1);
			
        }
		
        public static void GetUnityEngineAINavMeshPathStatus(this ObjectTranslator thiz, RealStatePtr L, int index, out UnityEngine.AI.NavMeshPathStatus val)
        {
		    LuaTypes type = LuaAPI.lua_type(L, index);
            if (type == LuaTypes.LUA_TUSERDATA )
            {
			    if (LuaAPI.xlua_gettypeid(L, index) != UnityEngineAINavMeshPathStatus_TypeID)
				{
				    throw new Exception("invalid userdata for UnityEngine.AI.NavMeshPathStatus");
				}
				
                IntPtr buff = LuaAPI.lua_touserdata(L, index);
				int e;
                if (!CopyByValue_Gen.UnPack(buff, 0, out e))
                {
                    throw new Exception("unpack fail for UnityEngine.AI.NavMeshPathStatus");
                }
				val = (UnityEngine.AI.NavMeshPathStatus)e;
                
            }
            else
            {
                val = (UnityEngine.AI.NavMeshPathStatus)thiz.objectCasters.GetCaster(typeof(UnityEngine.AI.NavMeshPathStatus))(L, index, null);
            }
        }
		
        public static void UpdateUnityEngineAINavMeshPathStatus(this ObjectTranslator thiz, RealStatePtr L, int index, UnityEngine.AI.NavMeshPathStatus val)
        {
		    
            if (LuaAPI.lua_type(L, index) == LuaTypes.LUA_TUSERDATA)
            {
			    if (LuaAPI.xlua_gettypeid(L, index) != UnityEngineAINavMeshPathStatus_TypeID)
				{
				    throw new Exception("invalid userdata for UnityEngine.AI.NavMeshPathStatus");
				}
				
                IntPtr buff = LuaAPI.lua_touserdata(L, index);
                if (!CopyByValue_Gen.Pack(buff, 0,  (int)val))
                {
                    throw new Exception("pack fail for UnityEngine.AI.NavMeshPathStatus ,value="+val);
                }
            }
			
            else
            {
                throw new Exception("try to update a data with lua type:" + LuaAPI.lua_type(L, index));
            }
        }
        
        static int ScrollViewMovementType_TypeID = -1;
		static int ScrollViewMovementType_EnumRef = -1;
        
        public static void PushScrollViewMovementType(this ObjectTranslator thiz, RealStatePtr L, ScrollView.MovementType val)
        {
            if (ScrollViewMovementType_TypeID == -1)
            {
			    bool is_first;
                ScrollViewMovementType_TypeID = thiz.getTypeId(L, typeof(ScrollView.MovementType), out is_first);
				
				if (ScrollViewMovementType_EnumRef == -1)
				{
				    Utils.LoadCSTable(L, typeof(ScrollView.MovementType));
				    ScrollViewMovementType_EnumRef = LuaAPI.luaL_ref(L, LuaIndexes.LUA_REGISTRYINDEX);
				}
				
            }
			
			if (LuaAPI.xlua_tryget_cachedud(L, (int)val, ScrollViewMovementType_EnumRef) == 1)
            {
			    return;
			}
			
            IntPtr buff = LuaAPI.xlua_pushstruct(L, 4, ScrollViewMovementType_TypeID);
            if (!CopyByValue_Gen.Pack(buff, 0, (int)val))
            {
                throw new Exception("pack fail fail for ScrollView.MovementType ,value="+val);
            }
			
			LuaAPI.lua_getref(L, ScrollViewMovementType_EnumRef);
			LuaAPI.lua_pushvalue(L, -2);
			LuaAPI.xlua_rawseti(L, -2, (int)val);
			LuaAPI.lua_pop(L, 1);
			
        }
		
        public static void GetScrollViewMovementType(this ObjectTranslator thiz, RealStatePtr L, int index, out ScrollView.MovementType val)
        {
		    LuaTypes type = LuaAPI.lua_type(L, index);
            if (type == LuaTypes.LUA_TUSERDATA )
            {
			    if (LuaAPI.xlua_gettypeid(L, index) != ScrollViewMovementType_TypeID)
				{
				    throw new Exception("invalid userdata for ScrollView.MovementType");
				}
				
                IntPtr buff = LuaAPI.lua_touserdata(L, index);
				int e;
                if (!CopyByValue_Gen.UnPack(buff, 0, out e))
                {
                    throw new Exception("unpack fail for ScrollView.MovementType");
                }
				val = (ScrollView.MovementType)e;
                
            }
            else
            {
                val = (ScrollView.MovementType)thiz.objectCasters.GetCaster(typeof(ScrollView.MovementType))(L, index, null);
            }
        }
		
        public static void UpdateScrollViewMovementType(this ObjectTranslator thiz, RealStatePtr L, int index, ScrollView.MovementType val)
        {
		    
            if (LuaAPI.lua_type(L, index) == LuaTypes.LUA_TUSERDATA)
            {
			    if (LuaAPI.xlua_gettypeid(L, index) != ScrollViewMovementType_TypeID)
				{
				    throw new Exception("invalid userdata for ScrollView.MovementType");
				}
				
                IntPtr buff = LuaAPI.lua_touserdata(L, index);
                if (!CopyByValue_Gen.Pack(buff, 0,  (int)val))
                {
                    throw new Exception("pack fail for ScrollView.MovementType ,value="+val);
                }
            }
			
            else
            {
                throw new Exception("try to update a data with lua type:" + LuaAPI.lua_type(L, index));
            }
        }
        
        static int ScrollViewScrollbarVisibility_TypeID = -1;
		static int ScrollViewScrollbarVisibility_EnumRef = -1;
        
        public static void PushScrollViewScrollbarVisibility(this ObjectTranslator thiz, RealStatePtr L, ScrollView.ScrollbarVisibility val)
        {
            if (ScrollViewScrollbarVisibility_TypeID == -1)
            {
			    bool is_first;
                ScrollViewScrollbarVisibility_TypeID = thiz.getTypeId(L, typeof(ScrollView.ScrollbarVisibility), out is_first);
				
				if (ScrollViewScrollbarVisibility_EnumRef == -1)
				{
				    Utils.LoadCSTable(L, typeof(ScrollView.ScrollbarVisibility));
				    ScrollViewScrollbarVisibility_EnumRef = LuaAPI.luaL_ref(L, LuaIndexes.LUA_REGISTRYINDEX);
				}
				
            }
			
			if (LuaAPI.xlua_tryget_cachedud(L, (int)val, ScrollViewScrollbarVisibility_EnumRef) == 1)
            {
			    return;
			}
			
            IntPtr buff = LuaAPI.xlua_pushstruct(L, 4, ScrollViewScrollbarVisibility_TypeID);
            if (!CopyByValue_Gen.Pack(buff, 0, (int)val))
            {
                throw new Exception("pack fail fail for ScrollView.ScrollbarVisibility ,value="+val);
            }
			
			LuaAPI.lua_getref(L, ScrollViewScrollbarVisibility_EnumRef);
			LuaAPI.lua_pushvalue(L, -2);
			LuaAPI.xlua_rawseti(L, -2, (int)val);
			LuaAPI.lua_pop(L, 1);
			
        }
		
        public static void GetScrollViewScrollbarVisibility(this ObjectTranslator thiz, RealStatePtr L, int index, out ScrollView.ScrollbarVisibility val)
        {
		    LuaTypes type = LuaAPI.lua_type(L, index);
            if (type == LuaTypes.LUA_TUSERDATA )
            {
			    if (LuaAPI.xlua_gettypeid(L, index) != ScrollViewScrollbarVisibility_TypeID)
				{
				    throw new Exception("invalid userdata for ScrollView.ScrollbarVisibility");
				}
				
                IntPtr buff = LuaAPI.lua_touserdata(L, index);
				int e;
                if (!CopyByValue_Gen.UnPack(buff, 0, out e))
                {
                    throw new Exception("unpack fail for ScrollView.ScrollbarVisibility");
                }
				val = (ScrollView.ScrollbarVisibility)e;
                
            }
            else
            {
                val = (ScrollView.ScrollbarVisibility)thiz.objectCasters.GetCaster(typeof(ScrollView.ScrollbarVisibility))(L, index, null);
            }
        }
		
        public static void UpdateScrollViewScrollbarVisibility(this ObjectTranslator thiz, RealStatePtr L, int index, ScrollView.ScrollbarVisibility val)
        {
		    
            if (LuaAPI.lua_type(L, index) == LuaTypes.LUA_TUSERDATA)
            {
			    if (LuaAPI.xlua_gettypeid(L, index) != ScrollViewScrollbarVisibility_TypeID)
				{
				    throw new Exception("invalid userdata for ScrollView.ScrollbarVisibility");
				}
				
                IntPtr buff = LuaAPI.lua_touserdata(L, index);
                if (!CopyByValue_Gen.Pack(buff, 0,  (int)val))
                {
                    throw new Exception("pack fail for ScrollView.ScrollbarVisibility ,value="+val);
                }
            }
			
            else
            {
                throw new Exception("try to update a data with lua type:" + LuaAPI.lua_type(L, index));
            }
        }
        
        static int ScrollViewScrollViewLayoutType_TypeID = -1;
		static int ScrollViewScrollViewLayoutType_EnumRef = -1;
        
        public static void PushScrollViewScrollViewLayoutType(this ObjectTranslator thiz, RealStatePtr L, ScrollView.ScrollViewLayoutType val)
        {
            if (ScrollViewScrollViewLayoutType_TypeID == -1)
            {
			    bool is_first;
                ScrollViewScrollViewLayoutType_TypeID = thiz.getTypeId(L, typeof(ScrollView.ScrollViewLayoutType), out is_first);
				
				if (ScrollViewScrollViewLayoutType_EnumRef == -1)
				{
				    Utils.LoadCSTable(L, typeof(ScrollView.ScrollViewLayoutType));
				    ScrollViewScrollViewLayoutType_EnumRef = LuaAPI.luaL_ref(L, LuaIndexes.LUA_REGISTRYINDEX);
				}
				
            }
			
			if (LuaAPI.xlua_tryget_cachedud(L, (int)val, ScrollViewScrollViewLayoutType_EnumRef) == 1)
            {
			    return;
			}
			
            IntPtr buff = LuaAPI.xlua_pushstruct(L, 4, ScrollViewScrollViewLayoutType_TypeID);
            if (!CopyByValue_Gen.Pack(buff, 0, (int)val))
            {
                throw new Exception("pack fail fail for ScrollView.ScrollViewLayoutType ,value="+val);
            }
			
			LuaAPI.lua_getref(L, ScrollViewScrollViewLayoutType_EnumRef);
			LuaAPI.lua_pushvalue(L, -2);
			LuaAPI.xlua_rawseti(L, -2, (int)val);
			LuaAPI.lua_pop(L, 1);
			
        }
		
        public static void GetScrollViewScrollViewLayoutType(this ObjectTranslator thiz, RealStatePtr L, int index, out ScrollView.ScrollViewLayoutType val)
        {
		    LuaTypes type = LuaAPI.lua_type(L, index);
            if (type == LuaTypes.LUA_TUSERDATA )
            {
			    if (LuaAPI.xlua_gettypeid(L, index) != ScrollViewScrollViewLayoutType_TypeID)
				{
				    throw new Exception("invalid userdata for ScrollView.ScrollViewLayoutType");
				}
				
                IntPtr buff = LuaAPI.lua_touserdata(L, index);
				int e;
                if (!CopyByValue_Gen.UnPack(buff, 0, out e))
                {
                    throw new Exception("unpack fail for ScrollView.ScrollViewLayoutType");
                }
				val = (ScrollView.ScrollViewLayoutType)e;
                
            }
            else
            {
                val = (ScrollView.ScrollViewLayoutType)thiz.objectCasters.GetCaster(typeof(ScrollView.ScrollViewLayoutType))(L, index, null);
            }
        }
		
        public static void UpdateScrollViewScrollViewLayoutType(this ObjectTranslator thiz, RealStatePtr L, int index, ScrollView.ScrollViewLayoutType val)
        {
		    
            if (LuaAPI.lua_type(L, index) == LuaTypes.LUA_TUSERDATA)
            {
			    if (LuaAPI.xlua_gettypeid(L, index) != ScrollViewScrollViewLayoutType_TypeID)
				{
				    throw new Exception("invalid userdata for ScrollView.ScrollViewLayoutType");
				}
				
                IntPtr buff = LuaAPI.lua_touserdata(L, index);
                if (!CopyByValue_Gen.Pack(buff, 0,  (int)val))
                {
                    throw new Exception("pack fail for ScrollView.ScrollViewLayoutType ,value="+val);
                }
            }
			
            else
            {
                throw new Exception("try to update a data with lua type:" + LuaAPI.lua_type(L, index));
            }
        }
        
        static int UnityEngineTouchPhase_TypeID = -1;
		static int UnityEngineTouchPhase_EnumRef = -1;
        
        public static void PushUnityEngineTouchPhase(this ObjectTranslator thiz, RealStatePtr L, UnityEngine.TouchPhase val)
        {
            if (UnityEngineTouchPhase_TypeID == -1)
            {
			    bool is_first;
                UnityEngineTouchPhase_TypeID = thiz.getTypeId(L, typeof(UnityEngine.TouchPhase), out is_first);
				
				if (UnityEngineTouchPhase_EnumRef == -1)
				{
				    Utils.LoadCSTable(L, typeof(UnityEngine.TouchPhase));
				    UnityEngineTouchPhase_EnumRef = LuaAPI.luaL_ref(L, LuaIndexes.LUA_REGISTRYINDEX);
				}
				
            }
			
			if (LuaAPI.xlua_tryget_cachedud(L, (int)val, UnityEngineTouchPhase_EnumRef) == 1)
            {
			    return;
			}
			
            IntPtr buff = LuaAPI.xlua_pushstruct(L, 4, UnityEngineTouchPhase_TypeID);
            if (!CopyByValue_Gen.Pack(buff, 0, (int)val))
            {
                throw new Exception("pack fail fail for UnityEngine.TouchPhase ,value="+val);
            }
			
			LuaAPI.lua_getref(L, UnityEngineTouchPhase_EnumRef);
			LuaAPI.lua_pushvalue(L, -2);
			LuaAPI.xlua_rawseti(L, -2, (int)val);
			LuaAPI.lua_pop(L, 1);
			
        }
		
        public static void GetUnityEngineTouchPhase(this ObjectTranslator thiz, RealStatePtr L, int index, out UnityEngine.TouchPhase val)
        {
		    LuaTypes type = LuaAPI.lua_type(L, index);
            if (type == LuaTypes.LUA_TUSERDATA )
            {
			    if (LuaAPI.xlua_gettypeid(L, index) != UnityEngineTouchPhase_TypeID)
				{
				    throw new Exception("invalid userdata for UnityEngine.TouchPhase");
				}
				
                IntPtr buff = LuaAPI.lua_touserdata(L, index);
				int e;
                if (!CopyByValue_Gen.UnPack(buff, 0, out e))
                {
                    throw new Exception("unpack fail for UnityEngine.TouchPhase");
                }
				val = (UnityEngine.TouchPhase)e;
                
            }
            else
            {
                val = (UnityEngine.TouchPhase)thiz.objectCasters.GetCaster(typeof(UnityEngine.TouchPhase))(L, index, null);
            }
        }
		
        public static void UpdateUnityEngineTouchPhase(this ObjectTranslator thiz, RealStatePtr L, int index, UnityEngine.TouchPhase val)
        {
		    
            if (LuaAPI.lua_type(L, index) == LuaTypes.LUA_TUSERDATA)
            {
			    if (LuaAPI.xlua_gettypeid(L, index) != UnityEngineTouchPhase_TypeID)
				{
				    throw new Exception("invalid userdata for UnityEngine.TouchPhase");
				}
				
                IntPtr buff = LuaAPI.lua_touserdata(L, index);
                if (!CopyByValue_Gen.Pack(buff, 0,  (int)val))
                {
                    throw new Exception("pack fail for UnityEngine.TouchPhase ,value="+val);
                }
            }
			
            else
            {
                throw new Exception("try to update a data with lua type:" + LuaAPI.lua_type(L, index));
            }
        }
        
        static int ResourceManagerPreloadType_TypeID = -1;
		static int ResourceManagerPreloadType_EnumRef = -1;
        
        public static void PushResourceManagerPreloadType(this ObjectTranslator thiz, RealStatePtr L, ResourceManager.PreloadType val)
        {
            if (ResourceManagerPreloadType_TypeID == -1)
            {
			    bool is_first;
                ResourceManagerPreloadType_TypeID = thiz.getTypeId(L, typeof(ResourceManager.PreloadType), out is_first);
				
				if (ResourceManagerPreloadType_EnumRef == -1)
				{
				    Utils.LoadCSTable(L, typeof(ResourceManager.PreloadType));
				    ResourceManagerPreloadType_EnumRef = LuaAPI.luaL_ref(L, LuaIndexes.LUA_REGISTRYINDEX);
				}
				
            }
			
			if (LuaAPI.xlua_tryget_cachedud(L, (int)val, ResourceManagerPreloadType_EnumRef) == 1)
            {
			    return;
			}
			
            IntPtr buff = LuaAPI.xlua_pushstruct(L, 4, ResourceManagerPreloadType_TypeID);
            if (!CopyByValue_Gen.Pack(buff, 0, (int)val))
            {
                throw new Exception("pack fail fail for ResourceManager.PreloadType ,value="+val);
            }
			
			LuaAPI.lua_getref(L, ResourceManagerPreloadType_EnumRef);
			LuaAPI.lua_pushvalue(L, -2);
			LuaAPI.xlua_rawseti(L, -2, (int)val);
			LuaAPI.lua_pop(L, 1);
			
        }
		
        public static void GetResourceManagerPreloadType(this ObjectTranslator thiz, RealStatePtr L, int index, out ResourceManager.PreloadType val)
        {
		    LuaTypes type = LuaAPI.lua_type(L, index);
            if (type == LuaTypes.LUA_TUSERDATA )
            {
			    if (LuaAPI.xlua_gettypeid(L, index) != ResourceManagerPreloadType_TypeID)
				{
				    throw new Exception("invalid userdata for ResourceManager.PreloadType");
				}
				
                IntPtr buff = LuaAPI.lua_touserdata(L, index);
				int e;
                if (!CopyByValue_Gen.UnPack(buff, 0, out e))
                {
                    throw new Exception("unpack fail for ResourceManager.PreloadType");
                }
				val = (ResourceManager.PreloadType)e;
                
            }
            else
            {
                val = (ResourceManager.PreloadType)thiz.objectCasters.GetCaster(typeof(ResourceManager.PreloadType))(L, index, null);
            }
        }
		
        public static void UpdateResourceManagerPreloadType(this ObjectTranslator thiz, RealStatePtr L, int index, ResourceManager.PreloadType val)
        {
		    
            if (LuaAPI.lua_type(L, index) == LuaTypes.LUA_TUSERDATA)
            {
			    if (LuaAPI.xlua_gettypeid(L, index) != ResourceManagerPreloadType_TypeID)
				{
				    throw new Exception("invalid userdata for ResourceManager.PreloadType");
				}
				
                IntPtr buff = LuaAPI.lua_touserdata(L, index);
                if (!CopyByValue_Gen.Pack(buff, 0,  (int)val))
                {
                    throw new Exception("pack fail for ResourceManager.PreloadType ,value="+val);
                }
            }
			
            else
            {
                throw new Exception("try to update a data with lua type:" + LuaAPI.lua_type(L, index));
            }
        }
        
        static int SceneManagerSceneID_TypeID = -1;
		static int SceneManagerSceneID_EnumRef = -1;
        
        public static void PushSceneManagerSceneID(this ObjectTranslator thiz, RealStatePtr L, SceneManager.SceneID val)
        {
            if (SceneManagerSceneID_TypeID == -1)
            {
			    bool is_first;
                SceneManagerSceneID_TypeID = thiz.getTypeId(L, typeof(SceneManager.SceneID), out is_first);
				
				if (SceneManagerSceneID_EnumRef == -1)
				{
				    Utils.LoadCSTable(L, typeof(SceneManager.SceneID));
				    SceneManagerSceneID_EnumRef = LuaAPI.luaL_ref(L, LuaIndexes.LUA_REGISTRYINDEX);
				}
				
            }
			
			if (LuaAPI.xlua_tryget_cachedud(L, (int)val, SceneManagerSceneID_EnumRef) == 1)
            {
			    return;
			}
			
            IntPtr buff = LuaAPI.xlua_pushstruct(L, 4, SceneManagerSceneID_TypeID);
            if (!CopyByValue_Gen.Pack(buff, 0, (int)val))
            {
                throw new Exception("pack fail fail for SceneManager.SceneID ,value="+val);
            }
			
			LuaAPI.lua_getref(L, SceneManagerSceneID_EnumRef);
			LuaAPI.lua_pushvalue(L, -2);
			LuaAPI.xlua_rawseti(L, -2, (int)val);
			LuaAPI.lua_pop(L, 1);
			
        }
		
        public static void GetSceneManagerSceneID(this ObjectTranslator thiz, RealStatePtr L, int index, out SceneManager.SceneID val)
        {
		    LuaTypes type = LuaAPI.lua_type(L, index);
            if (type == LuaTypes.LUA_TUSERDATA )
            {
			    if (LuaAPI.xlua_gettypeid(L, index) != SceneManagerSceneID_TypeID)
				{
				    throw new Exception("invalid userdata for SceneManager.SceneID");
				}
				
                IntPtr buff = LuaAPI.lua_touserdata(L, index);
				int e;
                if (!CopyByValue_Gen.UnPack(buff, 0, out e))
                {
                    throw new Exception("unpack fail for SceneManager.SceneID");
                }
				val = (SceneManager.SceneID)e;
                
            }
            else
            {
                val = (SceneManager.SceneID)thiz.objectCasters.GetCaster(typeof(SceneManager.SceneID))(L, index, null);
            }
        }
		
        public static void UpdateSceneManagerSceneID(this ObjectTranslator thiz, RealStatePtr L, int index, SceneManager.SceneID val)
        {
		    
            if (LuaAPI.lua_type(L, index) == LuaTypes.LUA_TUSERDATA)
            {
			    if (LuaAPI.xlua_gettypeid(L, index) != SceneManagerSceneID_TypeID)
				{
				    throw new Exception("invalid userdata for SceneManager.SceneID");
				}
				
                IntPtr buff = LuaAPI.lua_touserdata(L, index);
                if (!CopyByValue_Gen.Pack(buff, 0,  (int)val))
                {
                    throw new Exception("pack fail for SceneManager.SceneID ,value="+val);
                }
            }
			
            else
            {
                throw new Exception("try to update a data with lua type:" + LuaAPI.lua_type(L, index));
            }
        }
        
        static int NewQueueState_TypeID = -1;
		static int NewQueueState_EnumRef = -1;
        
        public static void PushNewQueueState(this ObjectTranslator thiz, RealStatePtr L, NewQueueState val)
        {
            if (NewQueueState_TypeID == -1)
            {
			    bool is_first;
                NewQueueState_TypeID = thiz.getTypeId(L, typeof(NewQueueState), out is_first);
				
				if (NewQueueState_EnumRef == -1)
				{
				    Utils.LoadCSTable(L, typeof(NewQueueState));
				    NewQueueState_EnumRef = LuaAPI.luaL_ref(L, LuaIndexes.LUA_REGISTRYINDEX);
				}
				
            }
			
			if (LuaAPI.xlua_tryget_cachedud(L, (int)val, NewQueueState_EnumRef) == 1)
            {
			    return;
			}
			
            IntPtr buff = LuaAPI.xlua_pushstruct(L, 4, NewQueueState_TypeID);
            if (!CopyByValue_Gen.Pack(buff, 0, (int)val))
            {
                throw new Exception("pack fail fail for NewQueueState ,value="+val);
            }
			
			LuaAPI.lua_getref(L, NewQueueState_EnumRef);
			LuaAPI.lua_pushvalue(L, -2);
			LuaAPI.xlua_rawseti(L, -2, (int)val);
			LuaAPI.lua_pop(L, 1);
			
        }
		
        public static void GetNewQueueState(this ObjectTranslator thiz, RealStatePtr L, int index, out NewQueueState val)
        {
		    LuaTypes type = LuaAPI.lua_type(L, index);
            if (type == LuaTypes.LUA_TUSERDATA )
            {
			    if (LuaAPI.xlua_gettypeid(L, index) != NewQueueState_TypeID)
				{
				    throw new Exception("invalid userdata for NewQueueState");
				}
				
                IntPtr buff = LuaAPI.lua_touserdata(L, index);
				int e;
                if (!CopyByValue_Gen.UnPack(buff, 0, out e))
                {
                    throw new Exception("unpack fail for NewQueueState");
                }
				val = (NewQueueState)e;
                
            }
            else
            {
                val = (NewQueueState)thiz.objectCasters.GetCaster(typeof(NewQueueState))(L, index, null);
            }
        }
		
        public static void UpdateNewQueueState(this ObjectTranslator thiz, RealStatePtr L, int index, NewQueueState val)
        {
		    
            if (LuaAPI.lua_type(L, index) == LuaTypes.LUA_TUSERDATA)
            {
			    if (LuaAPI.xlua_gettypeid(L, index) != NewQueueState_TypeID)
				{
				    throw new Exception("invalid userdata for NewQueueState");
				}
				
                IntPtr buff = LuaAPI.lua_touserdata(L, index);
                if (!CopyByValue_Gen.Pack(buff, 0,  (int)val))
                {
                    throw new Exception("pack fail for NewQueueState ,value="+val);
                }
            }
			
            else
            {
                throw new Exception("try to update a data with lua type:" + LuaAPI.lua_type(L, index));
            }
        }
        
        static int ResourceType_TypeID = -1;
		static int ResourceType_EnumRef = -1;
        
        public static void PushResourceType(this ObjectTranslator thiz, RealStatePtr L, ResourceType val)
        {
            if (ResourceType_TypeID == -1)
            {
			    bool is_first;
                ResourceType_TypeID = thiz.getTypeId(L, typeof(ResourceType), out is_first);
				
				if (ResourceType_EnumRef == -1)
				{
				    Utils.LoadCSTable(L, typeof(ResourceType));
				    ResourceType_EnumRef = LuaAPI.luaL_ref(L, LuaIndexes.LUA_REGISTRYINDEX);
				}
				
            }
			
			if (LuaAPI.xlua_tryget_cachedud(L, (int)val, ResourceType_EnumRef) == 1)
            {
			    return;
			}
			
            IntPtr buff = LuaAPI.xlua_pushstruct(L, 4, ResourceType_TypeID);
            if (!CopyByValue_Gen.Pack(buff, 0, (int)val))
            {
                throw new Exception("pack fail fail for ResourceType ,value="+val);
            }
			
			LuaAPI.lua_getref(L, ResourceType_EnumRef);
			LuaAPI.lua_pushvalue(L, -2);
			LuaAPI.xlua_rawseti(L, -2, (int)val);
			LuaAPI.lua_pop(L, 1);
			
        }
		
        public static void GetResourceType(this ObjectTranslator thiz, RealStatePtr L, int index, out ResourceType val)
        {
		    LuaTypes type = LuaAPI.lua_type(L, index);
            if (type == LuaTypes.LUA_TUSERDATA )
            {
			    if (LuaAPI.xlua_gettypeid(L, index) != ResourceType_TypeID)
				{
				    throw new Exception("invalid userdata for ResourceType");
				}
				
                IntPtr buff = LuaAPI.lua_touserdata(L, index);
				int e;
                if (!CopyByValue_Gen.UnPack(buff, 0, out e))
                {
                    throw new Exception("unpack fail for ResourceType");
                }
				val = (ResourceType)e;
                
            }
            else
            {
                val = (ResourceType)thiz.objectCasters.GetCaster(typeof(ResourceType))(L, index, null);
            }
        }
		
        public static void UpdateResourceType(this ObjectTranslator thiz, RealStatePtr L, int index, ResourceType val)
        {
		    
            if (LuaAPI.lua_type(L, index) == LuaTypes.LUA_TUSERDATA)
            {
			    if (LuaAPI.xlua_gettypeid(L, index) != ResourceType_TypeID)
				{
				    throw new Exception("invalid userdata for ResourceType");
				}
				
                IntPtr buff = LuaAPI.lua_touserdata(L, index);
                if (!CopyByValue_Gen.Pack(buff, 0,  (int)val))
                {
                    throw new Exception("pack fail for ResourceType ,value="+val);
                }
            }
			
            else
            {
                throw new Exception("try to update a data with lua type:" + LuaAPI.lua_type(L, index));
            }
        }
        
        static int BuildingState_TypeID = -1;
		static int BuildingState_EnumRef = -1;
        
        public static void PushBuildingState(this ObjectTranslator thiz, RealStatePtr L, BuildingState val)
        {
            if (BuildingState_TypeID == -1)
            {
			    bool is_first;
                BuildingState_TypeID = thiz.getTypeId(L, typeof(BuildingState), out is_first);
				
				if (BuildingState_EnumRef == -1)
				{
				    Utils.LoadCSTable(L, typeof(BuildingState));
				    BuildingState_EnumRef = LuaAPI.luaL_ref(L, LuaIndexes.LUA_REGISTRYINDEX);
				}
				
            }
			
			if (LuaAPI.xlua_tryget_cachedud(L, (int)val, BuildingState_EnumRef) == 1)
            {
			    return;
			}
			
            IntPtr buff = LuaAPI.xlua_pushstruct(L, 4, BuildingState_TypeID);
            if (!CopyByValue_Gen.Pack(buff, 0, (int)val))
            {
                throw new Exception("pack fail fail for BuildingState ,value="+val);
            }
			
			LuaAPI.lua_getref(L, BuildingState_EnumRef);
			LuaAPI.lua_pushvalue(L, -2);
			LuaAPI.xlua_rawseti(L, -2, (int)val);
			LuaAPI.lua_pop(L, 1);
			
        }
		
        public static void GetBuildingState(this ObjectTranslator thiz, RealStatePtr L, int index, out BuildingState val)
        {
		    LuaTypes type = LuaAPI.lua_type(L, index);
            if (type == LuaTypes.LUA_TUSERDATA )
            {
			    if (LuaAPI.xlua_gettypeid(L, index) != BuildingState_TypeID)
				{
				    throw new Exception("invalid userdata for BuildingState");
				}
				
                IntPtr buff = LuaAPI.lua_touserdata(L, index);
				int e;
                if (!CopyByValue_Gen.UnPack(buff, 0, out e))
                {
                    throw new Exception("unpack fail for BuildingState");
                }
				val = (BuildingState)e;
                
            }
            else
            {
                val = (BuildingState)thiz.objectCasters.GetCaster(typeof(BuildingState))(L, index, null);
            }
        }
		
        public static void UpdateBuildingState(this ObjectTranslator thiz, RealStatePtr L, int index, BuildingState val)
        {
		    
            if (LuaAPI.lua_type(L, index) == LuaTypes.LUA_TUSERDATA)
            {
			    if (LuaAPI.xlua_gettypeid(L, index) != BuildingState_TypeID)
				{
				    throw new Exception("invalid userdata for BuildingState");
				}
				
                IntPtr buff = LuaAPI.lua_touserdata(L, index);
                if (!CopyByValue_Gen.Pack(buff, 0,  (int)val))
                {
                    throw new Exception("pack fail for BuildingState ,value="+val);
                }
            }
			
            else
            {
                throw new Exception("try to update a data with lua type:" + LuaAPI.lua_type(L, index));
            }
        }
        
        static int PlaceBuildType_TypeID = -1;
		static int PlaceBuildType_EnumRef = -1;
        
        public static void PushPlaceBuildType(this ObjectTranslator thiz, RealStatePtr L, PlaceBuildType val)
        {
            if (PlaceBuildType_TypeID == -1)
            {
			    bool is_first;
                PlaceBuildType_TypeID = thiz.getTypeId(L, typeof(PlaceBuildType), out is_first);
				
				if (PlaceBuildType_EnumRef == -1)
				{
				    Utils.LoadCSTable(L, typeof(PlaceBuildType));
				    PlaceBuildType_EnumRef = LuaAPI.luaL_ref(L, LuaIndexes.LUA_REGISTRYINDEX);
				}
				
            }
			
			if (LuaAPI.xlua_tryget_cachedud(L, (int)val, PlaceBuildType_EnumRef) == 1)
            {
			    return;
			}
			
            IntPtr buff = LuaAPI.xlua_pushstruct(L, 4, PlaceBuildType_TypeID);
            if (!CopyByValue_Gen.Pack(buff, 0, (int)val))
            {
                throw new Exception("pack fail fail for PlaceBuildType ,value="+val);
            }
			
			LuaAPI.lua_getref(L, PlaceBuildType_EnumRef);
			LuaAPI.lua_pushvalue(L, -2);
			LuaAPI.xlua_rawseti(L, -2, (int)val);
			LuaAPI.lua_pop(L, 1);
			
        }
		
        public static void GetPlaceBuildType(this ObjectTranslator thiz, RealStatePtr L, int index, out PlaceBuildType val)
        {
		    LuaTypes type = LuaAPI.lua_type(L, index);
            if (type == LuaTypes.LUA_TUSERDATA )
            {
			    if (LuaAPI.xlua_gettypeid(L, index) != PlaceBuildType_TypeID)
				{
				    throw new Exception("invalid userdata for PlaceBuildType");
				}
				
                IntPtr buff = LuaAPI.lua_touserdata(L, index);
				int e;
                if (!CopyByValue_Gen.UnPack(buff, 0, out e))
                {
                    throw new Exception("unpack fail for PlaceBuildType");
                }
				val = (PlaceBuildType)e;
                
            }
            else
            {
                val = (PlaceBuildType)thiz.objectCasters.GetCaster(typeof(PlaceBuildType))(L, index, null);
            }
        }
		
        public static void UpdatePlaceBuildType(this ObjectTranslator thiz, RealStatePtr L, int index, PlaceBuildType val)
        {
		    
            if (LuaAPI.lua_type(L, index) == LuaTypes.LUA_TUSERDATA)
            {
			    if (LuaAPI.xlua_gettypeid(L, index) != PlaceBuildType_TypeID)
				{
				    throw new Exception("invalid userdata for PlaceBuildType");
				}
				
                IntPtr buff = LuaAPI.lua_touserdata(L, index);
                if (!CopyByValue_Gen.Pack(buff, 0,  (int)val))
                {
                    throw new Exception("pack fail for PlaceBuildType ,value="+val);
                }
            }
			
            else
            {
                throw new Exception("try to update a data with lua type:" + LuaAPI.lua_type(L, index));
            }
        }
        
        static int MarchStatus_TypeID = -1;
		static int MarchStatus_EnumRef = -1;
        
        public static void PushMarchStatus(this ObjectTranslator thiz, RealStatePtr L, MarchStatus val)
        {
            if (MarchStatus_TypeID == -1)
            {
			    bool is_first;
                MarchStatus_TypeID = thiz.getTypeId(L, typeof(MarchStatus), out is_first);
				
				if (MarchStatus_EnumRef == -1)
				{
				    Utils.LoadCSTable(L, typeof(MarchStatus));
				    MarchStatus_EnumRef = LuaAPI.luaL_ref(L, LuaIndexes.LUA_REGISTRYINDEX);
				}
				
            }
			
			if (LuaAPI.xlua_tryget_cachedud(L, (int)val, MarchStatus_EnumRef) == 1)
            {
			    return;
			}
			
            IntPtr buff = LuaAPI.xlua_pushstruct(L, 4, MarchStatus_TypeID);
            if (!CopyByValue_Gen.Pack(buff, 0, (int)val))
            {
                throw new Exception("pack fail fail for MarchStatus ,value="+val);
            }
			
			LuaAPI.lua_getref(L, MarchStatus_EnumRef);
			LuaAPI.lua_pushvalue(L, -2);
			LuaAPI.xlua_rawseti(L, -2, (int)val);
			LuaAPI.lua_pop(L, 1);
			
        }
		
        public static void GetMarchStatus(this ObjectTranslator thiz, RealStatePtr L, int index, out MarchStatus val)
        {
		    LuaTypes type = LuaAPI.lua_type(L, index);
            if (type == LuaTypes.LUA_TUSERDATA )
            {
			    if (LuaAPI.xlua_gettypeid(L, index) != MarchStatus_TypeID)
				{
				    throw new Exception("invalid userdata for MarchStatus");
				}
				
                IntPtr buff = LuaAPI.lua_touserdata(L, index);
				int e;
                if (!CopyByValue_Gen.UnPack(buff, 0, out e))
                {
                    throw new Exception("unpack fail for MarchStatus");
                }
				val = (MarchStatus)e;
                
            }
            else
            {
                val = (MarchStatus)thiz.objectCasters.GetCaster(typeof(MarchStatus))(L, index, null);
            }
        }
		
        public static void UpdateMarchStatus(this ObjectTranslator thiz, RealStatePtr L, int index, MarchStatus val)
        {
		    
            if (LuaAPI.lua_type(L, index) == LuaTypes.LUA_TUSERDATA)
            {
			    if (LuaAPI.xlua_gettypeid(L, index) != MarchStatus_TypeID)
				{
				    throw new Exception("invalid userdata for MarchStatus");
				}
				
                IntPtr buff = LuaAPI.lua_touserdata(L, index);
                if (!CopyByValue_Gen.Pack(buff, 0,  (int)val))
                {
                    throw new Exception("pack fail for MarchStatus ,value="+val);
                }
            }
			
            else
            {
                throw new Exception("try to update a data with lua type:" + LuaAPI.lua_type(L, index));
            }
        }
        
        static int UnityEngineTimelineClipCaps_TypeID = -1;
		static int UnityEngineTimelineClipCaps_EnumRef = -1;
        
        public static void PushUnityEngineTimelineClipCaps(this ObjectTranslator thiz, RealStatePtr L, UnityEngine.Timeline.ClipCaps val)
        {
            if (UnityEngineTimelineClipCaps_TypeID == -1)
            {
			    bool is_first;
                UnityEngineTimelineClipCaps_TypeID = thiz.getTypeId(L, typeof(UnityEngine.Timeline.ClipCaps), out is_first);
				
				if (UnityEngineTimelineClipCaps_EnumRef == -1)
				{
				    Utils.LoadCSTable(L, typeof(UnityEngine.Timeline.ClipCaps));
				    UnityEngineTimelineClipCaps_EnumRef = LuaAPI.luaL_ref(L, LuaIndexes.LUA_REGISTRYINDEX);
				}
				
            }
			
			if (LuaAPI.xlua_tryget_cachedud(L, (int)val, UnityEngineTimelineClipCaps_EnumRef) == 1)
            {
			    return;
			}
			
            IntPtr buff = LuaAPI.xlua_pushstruct(L, 4, UnityEngineTimelineClipCaps_TypeID);
            if (!CopyByValue_Gen.Pack(buff, 0, (int)val))
            {
                throw new Exception("pack fail fail for UnityEngine.Timeline.ClipCaps ,value="+val);
            }
			
			LuaAPI.lua_getref(L, UnityEngineTimelineClipCaps_EnumRef);
			LuaAPI.lua_pushvalue(L, -2);
			LuaAPI.xlua_rawseti(L, -2, (int)val);
			LuaAPI.lua_pop(L, 1);
			
        }
		
        public static void GetUnityEngineTimelineClipCaps(this ObjectTranslator thiz, RealStatePtr L, int index, out UnityEngine.Timeline.ClipCaps val)
        {
		    LuaTypes type = LuaAPI.lua_type(L, index);
            if (type == LuaTypes.LUA_TUSERDATA )
            {
			    if (LuaAPI.xlua_gettypeid(L, index) != UnityEngineTimelineClipCaps_TypeID)
				{
				    throw new Exception("invalid userdata for UnityEngine.Timeline.ClipCaps");
				}
				
                IntPtr buff = LuaAPI.lua_touserdata(L, index);
				int e;
                if (!CopyByValue_Gen.UnPack(buff, 0, out e))
                {
                    throw new Exception("unpack fail for UnityEngine.Timeline.ClipCaps");
                }
				val = (UnityEngine.Timeline.ClipCaps)e;
                
            }
            else
            {
                val = (UnityEngine.Timeline.ClipCaps)thiz.objectCasters.GetCaster(typeof(UnityEngine.Timeline.ClipCaps))(L, index, null);
            }
        }
		
        public static void UpdateUnityEngineTimelineClipCaps(this ObjectTranslator thiz, RealStatePtr L, int index, UnityEngine.Timeline.ClipCaps val)
        {
		    
            if (LuaAPI.lua_type(L, index) == LuaTypes.LUA_TUSERDATA)
            {
			    if (LuaAPI.xlua_gettypeid(L, index) != UnityEngineTimelineClipCaps_TypeID)
				{
				    throw new Exception("invalid userdata for UnityEngine.Timeline.ClipCaps");
				}
				
                IntPtr buff = LuaAPI.lua_touserdata(L, index);
                if (!CopyByValue_Gen.Pack(buff, 0,  (int)val))
                {
                    throw new Exception("pack fail for UnityEngine.Timeline.ClipCaps ,value="+val);
                }
            }
			
            else
            {
                throw new Exception("try to update a data with lua type:" + LuaAPI.lua_type(L, index));
            }
        }
        
        static int InstanceRequestState_TypeID = -1;
		static int InstanceRequestState_EnumRef = -1;
        
        public static void PushInstanceRequestState(this ObjectTranslator thiz, RealStatePtr L, InstanceRequest.State val)
        {
            if (InstanceRequestState_TypeID == -1)
            {
			    bool is_first;
                InstanceRequestState_TypeID = thiz.getTypeId(L, typeof(InstanceRequest.State), out is_first);
				
				if (InstanceRequestState_EnumRef == -1)
				{
				    Utils.LoadCSTable(L, typeof(InstanceRequest.State));
				    InstanceRequestState_EnumRef = LuaAPI.luaL_ref(L, LuaIndexes.LUA_REGISTRYINDEX);
				}
				
            }
			
			if (LuaAPI.xlua_tryget_cachedud(L, (int)val, InstanceRequestState_EnumRef) == 1)
            {
			    return;
			}
			
            IntPtr buff = LuaAPI.xlua_pushstruct(L, 4, InstanceRequestState_TypeID);
            if (!CopyByValue_Gen.Pack(buff, 0, (int)val))
            {
                throw new Exception("pack fail fail for InstanceRequest.State ,value="+val);
            }
			
			LuaAPI.lua_getref(L, InstanceRequestState_EnumRef);
			LuaAPI.lua_pushvalue(L, -2);
			LuaAPI.xlua_rawseti(L, -2, (int)val);
			LuaAPI.lua_pop(L, 1);
			
        }
		
        public static void GetInstanceRequestState(this ObjectTranslator thiz, RealStatePtr L, int index, out InstanceRequest.State val)
        {
		    LuaTypes type = LuaAPI.lua_type(L, index);
            if (type == LuaTypes.LUA_TUSERDATA )
            {
			    if (LuaAPI.xlua_gettypeid(L, index) != InstanceRequestState_TypeID)
				{
				    throw new Exception("invalid userdata for InstanceRequest.State");
				}
				
                IntPtr buff = LuaAPI.lua_touserdata(L, index);
				int e;
                if (!CopyByValue_Gen.UnPack(buff, 0, out e))
                {
                    throw new Exception("unpack fail for InstanceRequest.State");
                }
				val = (InstanceRequest.State)e;
                
            }
            else
            {
                val = (InstanceRequest.State)thiz.objectCasters.GetCaster(typeof(InstanceRequest.State))(L, index, null);
            }
        }
		
        public static void UpdateInstanceRequestState(this ObjectTranslator thiz, RealStatePtr L, int index, InstanceRequest.State val)
        {
		    
            if (LuaAPI.lua_type(L, index) == LuaTypes.LUA_TUSERDATA)
            {
			    if (LuaAPI.xlua_gettypeid(L, index) != InstanceRequestState_TypeID)
				{
				    throw new Exception("invalid userdata for InstanceRequest.State");
				}
				
                IntPtr buff = LuaAPI.lua_touserdata(L, index);
                if (!CopyByValue_Gen.Pack(buff, 0,  (int)val))
                {
                    throw new Exception("pack fail for InstanceRequest.State ,value="+val);
                }
            }
			
            else
            {
                throw new Exception("try to update a data with lua type:" + LuaAPI.lua_type(L, index));
            }
        }
        
        static int NewMarchType_TypeID = -1;
		static int NewMarchType_EnumRef = -1;
        
        public static void PushNewMarchType(this ObjectTranslator thiz, RealStatePtr L, NewMarchType val)
        {
            if (NewMarchType_TypeID == -1)
            {
			    bool is_first;
                NewMarchType_TypeID = thiz.getTypeId(L, typeof(NewMarchType), out is_first);
				
				if (NewMarchType_EnumRef == -1)
				{
				    Utils.LoadCSTable(L, typeof(NewMarchType));
				    NewMarchType_EnumRef = LuaAPI.luaL_ref(L, LuaIndexes.LUA_REGISTRYINDEX);
				}
				
            }
			
			if (LuaAPI.xlua_tryget_cachedud(L, (int)val, NewMarchType_EnumRef) == 1)
            {
			    return;
			}
			
            IntPtr buff = LuaAPI.xlua_pushstruct(L, 4, NewMarchType_TypeID);
            if (!CopyByValue_Gen.Pack(buff, 0, (int)val))
            {
                throw new Exception("pack fail fail for NewMarchType ,value="+val);
            }
			
			LuaAPI.lua_getref(L, NewMarchType_EnumRef);
			LuaAPI.lua_pushvalue(L, -2);
			LuaAPI.xlua_rawseti(L, -2, (int)val);
			LuaAPI.lua_pop(L, 1);
			
        }
		
        public static void GetNewMarchType(this ObjectTranslator thiz, RealStatePtr L, int index, out NewMarchType val)
        {
		    LuaTypes type = LuaAPI.lua_type(L, index);
            if (type == LuaTypes.LUA_TUSERDATA )
            {
			    if (LuaAPI.xlua_gettypeid(L, index) != NewMarchType_TypeID)
				{
				    throw new Exception("invalid userdata for NewMarchType");
				}
				
                IntPtr buff = LuaAPI.lua_touserdata(L, index);
				int e;
                if (!CopyByValue_Gen.UnPack(buff, 0, out e))
                {
                    throw new Exception("unpack fail for NewMarchType");
                }
				val = (NewMarchType)e;
                
            }
            else
            {
                val = (NewMarchType)thiz.objectCasters.GetCaster(typeof(NewMarchType))(L, index, null);
            }
        }
		
        public static void UpdateNewMarchType(this ObjectTranslator thiz, RealStatePtr L, int index, NewMarchType val)
        {
		    
            if (LuaAPI.lua_type(L, index) == LuaTypes.LUA_TUSERDATA)
            {
			    if (LuaAPI.xlua_gettypeid(L, index) != NewMarchType_TypeID)
				{
				    throw new Exception("invalid userdata for NewMarchType");
				}
				
                IntPtr buff = LuaAPI.lua_touserdata(L, index);
                if (!CopyByValue_Gen.Pack(buff, 0,  (int)val))
                {
                    throw new Exception("pack fail for NewMarchType ,value="+val);
                }
            }
			
            else
            {
                throw new Exception("try to update a data with lua type:" + LuaAPI.lua_type(L, index));
            }
        }
        
        static int WorldPointType_TypeID = -1;
		static int WorldPointType_EnumRef = -1;
        
        public static void PushWorldPointType(this ObjectTranslator thiz, RealStatePtr L, WorldPointType val)
        {
            if (WorldPointType_TypeID == -1)
            {
			    bool is_first;
                WorldPointType_TypeID = thiz.getTypeId(L, typeof(WorldPointType), out is_first);
				
				if (WorldPointType_EnumRef == -1)
				{
				    Utils.LoadCSTable(L, typeof(WorldPointType));
				    WorldPointType_EnumRef = LuaAPI.luaL_ref(L, LuaIndexes.LUA_REGISTRYINDEX);
				}
				
            }
			
			if (LuaAPI.xlua_tryget_cachedud(L, (int)val, WorldPointType_EnumRef) == 1)
            {
			    return;
			}
			
            IntPtr buff = LuaAPI.xlua_pushstruct(L, 4, WorldPointType_TypeID);
            if (!CopyByValue_Gen.Pack(buff, 0, (int)val))
            {
                throw new Exception("pack fail fail for WorldPointType ,value="+val);
            }
			
			LuaAPI.lua_getref(L, WorldPointType_EnumRef);
			LuaAPI.lua_pushvalue(L, -2);
			LuaAPI.xlua_rawseti(L, -2, (int)val);
			LuaAPI.lua_pop(L, 1);
			
        }
		
        public static void GetWorldPointType(this ObjectTranslator thiz, RealStatePtr L, int index, out WorldPointType val)
        {
		    LuaTypes type = LuaAPI.lua_type(L, index);
            if (type == LuaTypes.LUA_TUSERDATA )
            {
			    if (LuaAPI.xlua_gettypeid(L, index) != WorldPointType_TypeID)
				{
				    throw new Exception("invalid userdata for WorldPointType");
				}
				
                IntPtr buff = LuaAPI.lua_touserdata(L, index);
				int e;
                if (!CopyByValue_Gen.UnPack(buff, 0, out e))
                {
                    throw new Exception("unpack fail for WorldPointType");
                }
				val = (WorldPointType)e;
                
            }
            else
            {
                val = (WorldPointType)thiz.objectCasters.GetCaster(typeof(WorldPointType))(L, index, null);
            }
        }
		
        public static void UpdateWorldPointType(this ObjectTranslator thiz, RealStatePtr L, int index, WorldPointType val)
        {
		    
            if (LuaAPI.lua_type(L, index) == LuaTypes.LUA_TUSERDATA)
            {
			    if (LuaAPI.xlua_gettypeid(L, index) != WorldPointType_TypeID)
				{
				    throw new Exception("invalid userdata for WorldPointType");
				}
				
                IntPtr buff = LuaAPI.lua_touserdata(L, index);
                if (!CopyByValue_Gen.Pack(buff, 0,  (int)val))
                {
                    throw new Exception("pack fail for WorldPointType ,value="+val);
                }
            }
			
            else
            {
                throw new Exception("try to update a data with lua type:" + LuaAPI.lua_type(L, index));
            }
        }
        
        
		// table cast optimze
		
        
    }
	
	public partial class StaticLuaCallbacks_Wrap
    {
	    internal static bool __tryArrayGet(Type type, RealStatePtr L, ObjectTranslator translator, object obj, int index)
		{
		
			if (type == typeof(UnityEngine.Vector2[]))
			{
			    UnityEngine.Vector2[] array = obj as UnityEngine.Vector2[];
				translator.PushUnityEngineVector2(L, array[index]);
				return true;
			}
			else if (type == typeof(UnityEngine.Vector3[]))
			{
			    UnityEngine.Vector3[] array = obj as UnityEngine.Vector3[];
				translator.PushUnityEngineVector3(L, array[index]);
				return true;
			}
			else if (type == typeof(UnityEngine.Vector4[]))
			{
			    UnityEngine.Vector4[] array = obj as UnityEngine.Vector4[];
				translator.PushUnityEngineVector4(L, array[index]);
				return true;
			}
			else if (type == typeof(UnityEngine.Color[]))
			{
			    UnityEngine.Color[] array = obj as UnityEngine.Color[];
				translator.PushUnityEngineColor(L, array[index]);
				return true;
			}
			else if (type == typeof(UnityEngine.Quaternion[]))
			{
			    UnityEngine.Quaternion[] array = obj as UnityEngine.Quaternion[];
				translator.PushUnityEngineQuaternion(L, array[index]);
				return true;
			}
			else if (type == typeof(UnityEngine.Ray[]))
			{
			    UnityEngine.Ray[] array = obj as UnityEngine.Ray[];
				translator.PushUnityEngineRay(L, array[index]);
				return true;
			}
			else if (type == typeof(UnityEngine.Bounds[]))
			{
			    UnityEngine.Bounds[] array = obj as UnityEngine.Bounds[];
				translator.PushUnityEngineBounds(L, array[index]);
				return true;
			}
			else if (type == typeof(UnityEngine.Ray2D[]))
			{
			    UnityEngine.Ray2D[] array = obj as UnityEngine.Ray2D[];
				translator.PushUnityEngineRay2D(L, array[index]);
				return true;
			}
			else if (type == typeof(UnityEngine.Camera.GateFitMode[]))
			{
			    UnityEngine.Camera.GateFitMode[] array = obj as UnityEngine.Camera.GateFitMode[];
				translator.PushUnityEngineCameraGateFitMode(L, array[index]);
				return true;
			}
			else if (type == typeof(UnityEngine.Camera.FieldOfViewAxis[]))
			{
			    UnityEngine.Camera.FieldOfViewAxis[] array = obj as UnityEngine.Camera.FieldOfViewAxis[];
				translator.PushUnityEngineCameraFieldOfViewAxis(L, array[index]);
				return true;
			}
			else if (type == typeof(DG.Tweening.DOTweenAnimation.AnimationType[]))
			{
			    DG.Tweening.DOTweenAnimation.AnimationType[] array = obj as DG.Tweening.DOTweenAnimation.AnimationType[];
				translator.PushDGTweeningDOTweenAnimationAnimationType(L, array[index]);
				return true;
			}
			else if (type == typeof(DG.Tweening.DOTweenAnimation.TargetType[]))
			{
			    DG.Tweening.DOTweenAnimation.TargetType[] array = obj as DG.Tweening.DOTweenAnimation.TargetType[];
				translator.PushDGTweeningDOTweenAnimationTargetType(L, array[index]);
				return true;
			}
			else if (type == typeof(UnityEngine.RectTransform.Edge[]))
			{
			    UnityEngine.RectTransform.Edge[] array = obj as UnityEngine.RectTransform.Edge[];
				translator.PushUnityEngineRectTransformEdge(L, array[index]);
				return true;
			}
			else if (type == typeof(UnityEngine.RectTransform.Axis[]))
			{
			    UnityEngine.RectTransform.Axis[] array = obj as UnityEngine.RectTransform.Axis[];
				translator.PushUnityEngineRectTransformAxis(L, array[index]);
				return true;
			}
			else if (type == typeof(UnityEngine.EventSystems.PointerEventData.InputButton[]))
			{
			    UnityEngine.EventSystems.PointerEventData.InputButton[] array = obj as UnityEngine.EventSystems.PointerEventData.InputButton[];
				translator.PushUnityEngineEventSystemsPointerEventDataInputButton(L, array[index]);
				return true;
			}
			else if (type == typeof(UnityEngine.EventSystems.PointerEventData.FramePressState[]))
			{
			    UnityEngine.EventSystems.PointerEventData.FramePressState[] array = obj as UnityEngine.EventSystems.PointerEventData.FramePressState[];
				translator.PushUnityEngineEventSystemsPointerEventDataFramePressState(L, array[index]);
				return true;
			}
			else if (type == typeof(UnityEngine.RenderTextureFormat[]))
			{
			    UnityEngine.RenderTextureFormat[] array = obj as UnityEngine.RenderTextureFormat[];
				translator.PushUnityEngineRenderTextureFormat(L, array[index]);
				return true;
			}
			else if (type == typeof(UnityEngine.UI.Selectable.Transition[]))
			{
			    UnityEngine.UI.Selectable.Transition[] array = obj as UnityEngine.UI.Selectable.Transition[];
				translator.PushUnityEngineUISelectableTransition(L, array[index]);
				return true;
			}
			else if (type == typeof(UnityEngine.UI.InputField.ContentType[]))
			{
			    UnityEngine.UI.InputField.ContentType[] array = obj as UnityEngine.UI.InputField.ContentType[];
				translator.PushUnityEngineUIInputFieldContentType(L, array[index]);
				return true;
			}
			else if (type == typeof(UnityEngine.UI.InputField.InputType[]))
			{
			    UnityEngine.UI.InputField.InputType[] array = obj as UnityEngine.UI.InputField.InputType[];
				translator.PushUnityEngineUIInputFieldInputType(L, array[index]);
				return true;
			}
			else if (type == typeof(UnityEngine.UI.InputField.CharacterValidation[]))
			{
			    UnityEngine.UI.InputField.CharacterValidation[] array = obj as UnityEngine.UI.InputField.CharacterValidation[];
				translator.PushUnityEngineUIInputFieldCharacterValidation(L, array[index]);
				return true;
			}
			else if (type == typeof(UnityEngine.UI.InputField.LineType[]))
			{
			    UnityEngine.UI.InputField.LineType[] array = obj as UnityEngine.UI.InputField.LineType[];
				translator.PushUnityEngineUIInputFieldLineType(L, array[index]);
				return true;
			}
			else if (type == typeof(UnityEngine.UI.Image.Type[]))
			{
			    UnityEngine.UI.Image.Type[] array = obj as UnityEngine.UI.Image.Type[];
				translator.PushUnityEngineUIImageType(L, array[index]);
				return true;
			}
			else if (type == typeof(UnityEngine.UI.Image.FillMethod[]))
			{
			    UnityEngine.UI.Image.FillMethod[] array = obj as UnityEngine.UI.Image.FillMethod[];
				translator.PushUnityEngineUIImageFillMethod(L, array[index]);
				return true;
			}
			else if (type == typeof(UnityEngine.UI.Image.OriginHorizontal[]))
			{
			    UnityEngine.UI.Image.OriginHorizontal[] array = obj as UnityEngine.UI.Image.OriginHorizontal[];
				translator.PushUnityEngineUIImageOriginHorizontal(L, array[index]);
				return true;
			}
			else if (type == typeof(UnityEngine.UI.Image.OriginVertical[]))
			{
			    UnityEngine.UI.Image.OriginVertical[] array = obj as UnityEngine.UI.Image.OriginVertical[];
				translator.PushUnityEngineUIImageOriginVertical(L, array[index]);
				return true;
			}
			else if (type == typeof(UnityEngine.UI.Image.Origin90[]))
			{
			    UnityEngine.UI.Image.Origin90[] array = obj as UnityEngine.UI.Image.Origin90[];
				translator.PushUnityEngineUIImageOrigin90(L, array[index]);
				return true;
			}
			else if (type == typeof(UnityEngine.UI.Image.Origin180[]))
			{
			    UnityEngine.UI.Image.Origin180[] array = obj as UnityEngine.UI.Image.Origin180[];
				translator.PushUnityEngineUIImageOrigin180(L, array[index]);
				return true;
			}
			else if (type == typeof(UnityEngine.UI.Image.Origin360[]))
			{
			    UnityEngine.UI.Image.Origin360[] array = obj as UnityEngine.UI.Image.Origin360[];
				translator.PushUnityEngineUIImageOrigin360(L, array[index]);
				return true;
			}
			else if (type == typeof(UnityEngine.UI.ScrollRect.MovementType[]))
			{
			    UnityEngine.UI.ScrollRect.MovementType[] array = obj as UnityEngine.UI.ScrollRect.MovementType[];
				translator.PushUnityEngineUIScrollRectMovementType(L, array[index]);
				return true;
			}
			else if (type == typeof(UnityEngine.UI.ScrollRect.ScrollbarVisibility[]))
			{
			    UnityEngine.UI.ScrollRect.ScrollbarVisibility[] array = obj as UnityEngine.UI.ScrollRect.ScrollbarVisibility[];
				translator.PushUnityEngineUIScrollRectScrollbarVisibility(L, array[index]);
				return true;
			}
			else if (type == typeof(UnityEngine.UI.Slider.Direction[]))
			{
			    UnityEngine.UI.Slider.Direction[] array = obj as UnityEngine.UI.Slider.Direction[];
				translator.PushUnityEngineUISliderDirection(L, array[index]);
				return true;
			}
			else if (type == typeof(UnityEngine.UI.Toggle.ToggleTransition[]))
			{
			    UnityEngine.UI.Toggle.ToggleTransition[] array = obj as UnityEngine.UI.Toggle.ToggleTransition[];
				translator.PushUnityEngineUIToggleToggleTransition(L, array[index]);
				return true;
			}
			else if (type == typeof(SuperTextMesh.Alignment[]))
			{
			    SuperTextMesh.Alignment[] array = obj as SuperTextMesh.Alignment[];
				translator.PushSuperTextMeshAlignment(L, array[index]);
				return true;
			}
			else if (type == typeof(UnityEngine.AI.NavMeshPathStatus[]))
			{
			    UnityEngine.AI.NavMeshPathStatus[] array = obj as UnityEngine.AI.NavMeshPathStatus[];
				translator.PushUnityEngineAINavMeshPathStatus(L, array[index]);
				return true;
			}
			else if (type == typeof(ScrollView.MovementType[]))
			{
			    ScrollView.MovementType[] array = obj as ScrollView.MovementType[];
				translator.PushScrollViewMovementType(L, array[index]);
				return true;
			}
			else if (type == typeof(ScrollView.ScrollbarVisibility[]))
			{
			    ScrollView.ScrollbarVisibility[] array = obj as ScrollView.ScrollbarVisibility[];
				translator.PushScrollViewScrollbarVisibility(L, array[index]);
				return true;
			}
			else if (type == typeof(ScrollView.ScrollViewLayoutType[]))
			{
			    ScrollView.ScrollViewLayoutType[] array = obj as ScrollView.ScrollViewLayoutType[];
				translator.PushScrollViewScrollViewLayoutType(L, array[index]);
				return true;
			}
			else if (type == typeof(UnityEngine.TouchPhase[]))
			{
			    UnityEngine.TouchPhase[] array = obj as UnityEngine.TouchPhase[];
				translator.PushUnityEngineTouchPhase(L, array[index]);
				return true;
			}
			else if (type == typeof(ResourceManager.PreloadType[]))
			{
			    ResourceManager.PreloadType[] array = obj as ResourceManager.PreloadType[];
				translator.PushResourceManagerPreloadType(L, array[index]);
				return true;
			}
			else if (type == typeof(SceneManager.SceneID[]))
			{
			    SceneManager.SceneID[] array = obj as SceneManager.SceneID[];
				translator.PushSceneManagerSceneID(L, array[index]);
				return true;
			}
			else if (type == typeof(NewQueueState[]))
			{
			    NewQueueState[] array = obj as NewQueueState[];
				translator.PushNewQueueState(L, array[index]);
				return true;
			}
			else if (type == typeof(ResourceType[]))
			{
			    ResourceType[] array = obj as ResourceType[];
				translator.PushResourceType(L, array[index]);
				return true;
			}
			else if (type == typeof(BuildingState[]))
			{
			    BuildingState[] array = obj as BuildingState[];
				translator.PushBuildingState(L, array[index]);
				return true;
			}
			else if (type == typeof(PlaceBuildType[]))
			{
			    PlaceBuildType[] array = obj as PlaceBuildType[];
				translator.PushPlaceBuildType(L, array[index]);
				return true;
			}
			else if (type == typeof(MarchStatus[]))
			{
			    MarchStatus[] array = obj as MarchStatus[];
				translator.PushMarchStatus(L, array[index]);
				return true;
			}
			else if (type == typeof(UnityEngine.Timeline.ClipCaps[]))
			{
			    UnityEngine.Timeline.ClipCaps[] array = obj as UnityEngine.Timeline.ClipCaps[];
				translator.PushUnityEngineTimelineClipCaps(L, array[index]);
				return true;
			}
			else if (type == typeof(InstanceRequest.State[]))
			{
			    InstanceRequest.State[] array = obj as InstanceRequest.State[];
				translator.PushInstanceRequestState(L, array[index]);
				return true;
			}
			else if (type == typeof(NewMarchType[]))
			{
			    NewMarchType[] array = obj as NewMarchType[];
				translator.PushNewMarchType(L, array[index]);
				return true;
			}
			else if (type == typeof(WorldPointType[]))
			{
			    WorldPointType[] array = obj as WorldPointType[];
				translator.PushWorldPointType(L, array[index]);
				return true;
			}
            return false;
		}
		
		internal static bool __tryArraySet(Type type, RealStatePtr L, ObjectTranslator translator, object obj, int array_idx, int obj_idx)
		{
		
			if (type == typeof(UnityEngine.Vector2[]))
			{
			    UnityEngine.Vector2[] array = obj as UnityEngine.Vector2[];
				translator.Get(L, obj_idx, out array[array_idx]);
				return true;
			}
			else if (type == typeof(UnityEngine.Vector3[]))
			{
			    UnityEngine.Vector3[] array = obj as UnityEngine.Vector3[];
				translator.Get(L, obj_idx, out array[array_idx]);
				return true;
			}
			else if (type == typeof(UnityEngine.Vector4[]))
			{
			    UnityEngine.Vector4[] array = obj as UnityEngine.Vector4[];
				translator.Get(L, obj_idx, out array[array_idx]);
				return true;
			}
			else if (type == typeof(UnityEngine.Color[]))
			{
			    UnityEngine.Color[] array = obj as UnityEngine.Color[];
				translator.Get(L, obj_idx, out array[array_idx]);
				return true;
			}
			else if (type == typeof(UnityEngine.Quaternion[]))
			{
			    UnityEngine.Quaternion[] array = obj as UnityEngine.Quaternion[];
				translator.Get(L, obj_idx, out array[array_idx]);
				return true;
			}
			else if (type == typeof(UnityEngine.Ray[]))
			{
			    UnityEngine.Ray[] array = obj as UnityEngine.Ray[];
				translator.Get(L, obj_idx, out array[array_idx]);
				return true;
			}
			else if (type == typeof(UnityEngine.Bounds[]))
			{
			    UnityEngine.Bounds[] array = obj as UnityEngine.Bounds[];
				translator.Get(L, obj_idx, out array[array_idx]);
				return true;
			}
			else if (type == typeof(UnityEngine.Ray2D[]))
			{
			    UnityEngine.Ray2D[] array = obj as UnityEngine.Ray2D[];
				translator.Get(L, obj_idx, out array[array_idx]);
				return true;
			}
			else if (type == typeof(UnityEngine.Camera.GateFitMode[]))
			{
			    UnityEngine.Camera.GateFitMode[] array = obj as UnityEngine.Camera.GateFitMode[];
				translator.Get(L, obj_idx, out array[array_idx]);
				return true;
			}
			else if (type == typeof(UnityEngine.Camera.FieldOfViewAxis[]))
			{
			    UnityEngine.Camera.FieldOfViewAxis[] array = obj as UnityEngine.Camera.FieldOfViewAxis[];
				translator.Get(L, obj_idx, out array[array_idx]);
				return true;
			}
			else if (type == typeof(DG.Tweening.DOTweenAnimation.AnimationType[]))
			{
			    DG.Tweening.DOTweenAnimation.AnimationType[] array = obj as DG.Tweening.DOTweenAnimation.AnimationType[];
				translator.Get(L, obj_idx, out array[array_idx]);
				return true;
			}
			else if (type == typeof(DG.Tweening.DOTweenAnimation.TargetType[]))
			{
			    DG.Tweening.DOTweenAnimation.TargetType[] array = obj as DG.Tweening.DOTweenAnimation.TargetType[];
				translator.Get(L, obj_idx, out array[array_idx]);
				return true;
			}
			else if (type == typeof(UnityEngine.RectTransform.Edge[]))
			{
			    UnityEngine.RectTransform.Edge[] array = obj as UnityEngine.RectTransform.Edge[];
				translator.Get(L, obj_idx, out array[array_idx]);
				return true;
			}
			else if (type == typeof(UnityEngine.RectTransform.Axis[]))
			{
			    UnityEngine.RectTransform.Axis[] array = obj as UnityEngine.RectTransform.Axis[];
				translator.Get(L, obj_idx, out array[array_idx]);
				return true;
			}
			else if (type == typeof(UnityEngine.EventSystems.PointerEventData.InputButton[]))
			{
			    UnityEngine.EventSystems.PointerEventData.InputButton[] array = obj as UnityEngine.EventSystems.PointerEventData.InputButton[];
				translator.Get(L, obj_idx, out array[array_idx]);
				return true;
			}
			else if (type == typeof(UnityEngine.EventSystems.PointerEventData.FramePressState[]))
			{
			    UnityEngine.EventSystems.PointerEventData.FramePressState[] array = obj as UnityEngine.EventSystems.PointerEventData.FramePressState[];
				translator.Get(L, obj_idx, out array[array_idx]);
				return true;
			}
			else if (type == typeof(UnityEngine.RenderTextureFormat[]))
			{
			    UnityEngine.RenderTextureFormat[] array = obj as UnityEngine.RenderTextureFormat[];
				translator.Get(L, obj_idx, out array[array_idx]);
				return true;
			}
			else if (type == typeof(UnityEngine.UI.Selectable.Transition[]))
			{
			    UnityEngine.UI.Selectable.Transition[] array = obj as UnityEngine.UI.Selectable.Transition[];
				translator.Get(L, obj_idx, out array[array_idx]);
				return true;
			}
			else if (type == typeof(UnityEngine.UI.InputField.ContentType[]))
			{
			    UnityEngine.UI.InputField.ContentType[] array = obj as UnityEngine.UI.InputField.ContentType[];
				translator.Get(L, obj_idx, out array[array_idx]);
				return true;
			}
			else if (type == typeof(UnityEngine.UI.InputField.InputType[]))
			{
			    UnityEngine.UI.InputField.InputType[] array = obj as UnityEngine.UI.InputField.InputType[];
				translator.Get(L, obj_idx, out array[array_idx]);
				return true;
			}
			else if (type == typeof(UnityEngine.UI.InputField.CharacterValidation[]))
			{
			    UnityEngine.UI.InputField.CharacterValidation[] array = obj as UnityEngine.UI.InputField.CharacterValidation[];
				translator.Get(L, obj_idx, out array[array_idx]);
				return true;
			}
			else if (type == typeof(UnityEngine.UI.InputField.LineType[]))
			{
			    UnityEngine.UI.InputField.LineType[] array = obj as UnityEngine.UI.InputField.LineType[];
				translator.Get(L, obj_idx, out array[array_idx]);
				return true;
			}
			else if (type == typeof(UnityEngine.UI.Image.Type[]))
			{
			    UnityEngine.UI.Image.Type[] array = obj as UnityEngine.UI.Image.Type[];
				translator.Get(L, obj_idx, out array[array_idx]);
				return true;
			}
			else if (type == typeof(UnityEngine.UI.Image.FillMethod[]))
			{
			    UnityEngine.UI.Image.FillMethod[] array = obj as UnityEngine.UI.Image.FillMethod[];
				translator.Get(L, obj_idx, out array[array_idx]);
				return true;
			}
			else if (type == typeof(UnityEngine.UI.Image.OriginHorizontal[]))
			{
			    UnityEngine.UI.Image.OriginHorizontal[] array = obj as UnityEngine.UI.Image.OriginHorizontal[];
				translator.Get(L, obj_idx, out array[array_idx]);
				return true;
			}
			else if (type == typeof(UnityEngine.UI.Image.OriginVertical[]))
			{
			    UnityEngine.UI.Image.OriginVertical[] array = obj as UnityEngine.UI.Image.OriginVertical[];
				translator.Get(L, obj_idx, out array[array_idx]);
				return true;
			}
			else if (type == typeof(UnityEngine.UI.Image.Origin90[]))
			{
			    UnityEngine.UI.Image.Origin90[] array = obj as UnityEngine.UI.Image.Origin90[];
				translator.Get(L, obj_idx, out array[array_idx]);
				return true;
			}
			else if (type == typeof(UnityEngine.UI.Image.Origin180[]))
			{
			    UnityEngine.UI.Image.Origin180[] array = obj as UnityEngine.UI.Image.Origin180[];
				translator.Get(L, obj_idx, out array[array_idx]);
				return true;
			}
			else if (type == typeof(UnityEngine.UI.Image.Origin360[]))
			{
			    UnityEngine.UI.Image.Origin360[] array = obj as UnityEngine.UI.Image.Origin360[];
				translator.Get(L, obj_idx, out array[array_idx]);
				return true;
			}
			else if (type == typeof(UnityEngine.UI.ScrollRect.MovementType[]))
			{
			    UnityEngine.UI.ScrollRect.MovementType[] array = obj as UnityEngine.UI.ScrollRect.MovementType[];
				translator.Get(L, obj_idx, out array[array_idx]);
				return true;
			}
			else if (type == typeof(UnityEngine.UI.ScrollRect.ScrollbarVisibility[]))
			{
			    UnityEngine.UI.ScrollRect.ScrollbarVisibility[] array = obj as UnityEngine.UI.ScrollRect.ScrollbarVisibility[];
				translator.Get(L, obj_idx, out array[array_idx]);
				return true;
			}
			else if (type == typeof(UnityEngine.UI.Slider.Direction[]))
			{
			    UnityEngine.UI.Slider.Direction[] array = obj as UnityEngine.UI.Slider.Direction[];
				translator.Get(L, obj_idx, out array[array_idx]);
				return true;
			}
			else if (type == typeof(UnityEngine.UI.Toggle.ToggleTransition[]))
			{
			    UnityEngine.UI.Toggle.ToggleTransition[] array = obj as UnityEngine.UI.Toggle.ToggleTransition[];
				translator.Get(L, obj_idx, out array[array_idx]);
				return true;
			}
			else if (type == typeof(SuperTextMesh.Alignment[]))
			{
			    SuperTextMesh.Alignment[] array = obj as SuperTextMesh.Alignment[];
				translator.Get(L, obj_idx, out array[array_idx]);
				return true;
			}
			else if (type == typeof(UnityEngine.AI.NavMeshPathStatus[]))
			{
			    UnityEngine.AI.NavMeshPathStatus[] array = obj as UnityEngine.AI.NavMeshPathStatus[];
				translator.Get(L, obj_idx, out array[array_idx]);
				return true;
			}
			else if (type == typeof(ScrollView.MovementType[]))
			{
			    ScrollView.MovementType[] array = obj as ScrollView.MovementType[];
				translator.Get(L, obj_idx, out array[array_idx]);
				return true;
			}
			else if (type == typeof(ScrollView.ScrollbarVisibility[]))
			{
			    ScrollView.ScrollbarVisibility[] array = obj as ScrollView.ScrollbarVisibility[];
				translator.Get(L, obj_idx, out array[array_idx]);
				return true;
			}
			else if (type == typeof(ScrollView.ScrollViewLayoutType[]))
			{
			    ScrollView.ScrollViewLayoutType[] array = obj as ScrollView.ScrollViewLayoutType[];
				translator.Get(L, obj_idx, out array[array_idx]);
				return true;
			}
			else if (type == typeof(UnityEngine.TouchPhase[]))
			{
			    UnityEngine.TouchPhase[] array = obj as UnityEngine.TouchPhase[];
				translator.Get(L, obj_idx, out array[array_idx]);
				return true;
			}
			else if (type == typeof(ResourceManager.PreloadType[]))
			{
			    ResourceManager.PreloadType[] array = obj as ResourceManager.PreloadType[];
				translator.Get(L, obj_idx, out array[array_idx]);
				return true;
			}
			else if (type == typeof(SceneManager.SceneID[]))
			{
			    SceneManager.SceneID[] array = obj as SceneManager.SceneID[];
				translator.Get(L, obj_idx, out array[array_idx]);
				return true;
			}
			else if (type == typeof(NewQueueState[]))
			{
			    NewQueueState[] array = obj as NewQueueState[];
				translator.Get(L, obj_idx, out array[array_idx]);
				return true;
			}
			else if (type == typeof(ResourceType[]))
			{
			    ResourceType[] array = obj as ResourceType[];
				translator.Get(L, obj_idx, out array[array_idx]);
				return true;
			}
			else if (type == typeof(BuildingState[]))
			{
			    BuildingState[] array = obj as BuildingState[];
				translator.Get(L, obj_idx, out array[array_idx]);
				return true;
			}
			else if (type == typeof(PlaceBuildType[]))
			{
			    PlaceBuildType[] array = obj as PlaceBuildType[];
				translator.Get(L, obj_idx, out array[array_idx]);
				return true;
			}
			else if (type == typeof(MarchStatus[]))
			{
			    MarchStatus[] array = obj as MarchStatus[];
				translator.Get(L, obj_idx, out array[array_idx]);
				return true;
			}
			else if (type == typeof(UnityEngine.Timeline.ClipCaps[]))
			{
			    UnityEngine.Timeline.ClipCaps[] array = obj as UnityEngine.Timeline.ClipCaps[];
				translator.Get(L, obj_idx, out array[array_idx]);
				return true;
			}
			else if (type == typeof(InstanceRequest.State[]))
			{
			    InstanceRequest.State[] array = obj as InstanceRequest.State[];
				translator.Get(L, obj_idx, out array[array_idx]);
				return true;
			}
			else if (type == typeof(NewMarchType[]))
			{
			    NewMarchType[] array = obj as NewMarchType[];
				translator.Get(L, obj_idx, out array[array_idx]);
				return true;
			}
			else if (type == typeof(WorldPointType[]))
			{
			    WorldPointType[] array = obj as WorldPointType[];
				translator.Get(L, obj_idx, out array[array_idx]);
				return true;
			}
            return false;
		}
	}
}