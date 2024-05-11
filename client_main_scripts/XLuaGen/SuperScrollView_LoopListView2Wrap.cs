﻿#if USE_UNI_LUA
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
    public class SuperScrollViewLoopListView2Wrap 
    {
        public static void __Register(RealStatePtr L)
        {
			ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			System.Type type = typeof(SuperScrollView.LoopListView2);
			Utils.BeginObjectRegister(type, L, translator, 0, 36, 19, 11);
			
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "SetOnBeginDragAction", _m_SetOnBeginDragAction);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "SetOnDragingAction", _m_SetOnDragingAction);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "SetOnEndDragAction", _m_SetOnEndDragAction);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "SetOnListClickAction", _m_SetOnListClickAction);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "OnPointerClick", _m_OnPointerClick);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "GetItemPrefabConfData", _m_GetItemPrefabConfData);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "OnItemPrefabChanged", _m_OnItemPrefabChanged);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "InitListView", _m_InitListView);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "ResetListView", _m_ResetListView);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "SetListItemCount", _m_SetListItemCount);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "GetShownItemByItemIndex", _m_GetShownItemByItemIndex);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "GetShownItemByIndex", _m_GetShownItemByIndex);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "GetShownItemByIndexWithoutCheck", _m_GetShownItemByIndexWithoutCheck);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "GetIndexInShownItemList", _m_GetIndexInShownItemList);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "DoActionForEachShownItem", _m_DoActionForEachShownItem);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "NewListViewItem", _m_NewListViewItem);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "OnItemSizeChanged", _m_OnItemSizeChanged);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "RefreshItemByItemIndex", _m_RefreshItemByItemIndex);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "FinishSnapImmediately", _m_FinishSnapImmediately);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "GetCurShowIndexes", _m_GetCurShowIndexes);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "GetMovePanelToIndexPos", _m_GetMovePanelToIndexPos);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "MovePanelToItemIndex", _m_MovePanelToItemIndex);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "RefreshAllShownItem", _m_RefreshAllShownItem);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "RefreshAllShownItemWithFirstIndex", _m_RefreshAllShownItemWithFirstIndex);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "RefreshAllShownItemWithFirstIndexAndPos", _m_RefreshAllShownItemWithFirstIndexAndPos);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "OnBeginDrag", _m_OnBeginDrag);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "OnEndDrag", _m_OnEndDrag);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "OnDrag", _m_OnDrag);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "GetItemCornerPosInViewPort", _m_GetItemCornerPosInViewPort);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "ForceUpdate", _m_ForceUpdate);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "UpdateAllShownItemSnapData", _m_UpdateAllShownItemSnapData);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "ClearSnapData", _m_ClearSnapData);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "SetSnapTargetItemIndex", _m_SetSnapTargetItemIndex);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "ForceSnapUpdateCheck", _m_ForceSnapUpdateCheck);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "UpdateListView", _m_UpdateListView);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "ClearAllItems", _m_ClearAllItems);
			
			
			Utils.RegisterFunc(L, Utils.GETTER_IDX, "ArrangeType", _g_get_ArrangeType);
            Utils.RegisterFunc(L, Utils.GETTER_IDX, "IsVertList", _g_get_IsVertList);
            Utils.RegisterFunc(L, Utils.GETTER_IDX, "ItemTotalCount", _g_get_ItemTotalCount);
            Utils.RegisterFunc(L, Utils.GETTER_IDX, "ContainerTrans", _g_get_ContainerTrans);
            Utils.RegisterFunc(L, Utils.GETTER_IDX, "ScrollRect", _g_get_ScrollRect);
            Utils.RegisterFunc(L, Utils.GETTER_IDX, "IsDraging", _g_get_IsDraging);
            Utils.RegisterFunc(L, Utils.GETTER_IDX, "ItemSnapEnable", _g_get_ItemSnapEnable);
            Utils.RegisterFunc(L, Utils.GETTER_IDX, "SupportScrollBar", _g_get_SupportScrollBar);
            Utils.RegisterFunc(L, Utils.GETTER_IDX, "ShownItemCount", _g_get_ShownItemCount);
            Utils.RegisterFunc(L, Utils.GETTER_IDX, "ViewPortSize", _g_get_ViewPortSize);
            Utils.RegisterFunc(L, Utils.GETTER_IDX, "ViewPortWidth", _g_get_ViewPortWidth);
            Utils.RegisterFunc(L, Utils.GETTER_IDX, "ViewPortHeight", _g_get_ViewPortHeight);
            Utils.RegisterFunc(L, Utils.GETTER_IDX, "CurSnapNearestItemIndex", _g_get_CurSnapNearestItemIndex);
            Utils.RegisterFunc(L, Utils.GETTER_IDX, "mOnBeginDragAction", _g_get_mOnBeginDragAction);
            Utils.RegisterFunc(L, Utils.GETTER_IDX, "mOnDragingAction", _g_get_mOnDragingAction);
            Utils.RegisterFunc(L, Utils.GETTER_IDX, "mOnEndDragAction", _g_get_mOnEndDragAction);
            Utils.RegisterFunc(L, Utils.GETTER_IDX, "mOnListClickAction", _g_get_mOnListClickAction);
            Utils.RegisterFunc(L, Utils.GETTER_IDX, "mOnSnapItemFinished", _g_get_mOnSnapItemFinished);
            Utils.RegisterFunc(L, Utils.GETTER_IDX, "mOnSnapNearestChanged", _g_get_mOnSnapNearestChanged);
            
			Utils.RegisterFunc(L, Utils.SETTER_IDX, "ArrangeType", _s_set_ArrangeType);
            Utils.RegisterFunc(L, Utils.SETTER_IDX, "OnGetItemByIndex", _s_set_OnGetItemByIndex);
            Utils.RegisterFunc(L, Utils.SETTER_IDX, "OnGetItemNameByIndex", _s_set_OnGetItemNameByIndex);
            Utils.RegisterFunc(L, Utils.SETTER_IDX, "ItemSnapEnable", _s_set_ItemSnapEnable);
            Utils.RegisterFunc(L, Utils.SETTER_IDX, "SupportScrollBar", _s_set_SupportScrollBar);
            Utils.RegisterFunc(L, Utils.SETTER_IDX, "mOnBeginDragAction", _s_set_mOnBeginDragAction);
            Utils.RegisterFunc(L, Utils.SETTER_IDX, "mOnDragingAction", _s_set_mOnDragingAction);
            Utils.RegisterFunc(L, Utils.SETTER_IDX, "mOnEndDragAction", _s_set_mOnEndDragAction);
            Utils.RegisterFunc(L, Utils.SETTER_IDX, "mOnListClickAction", _s_set_mOnListClickAction);
            Utils.RegisterFunc(L, Utils.SETTER_IDX, "mOnSnapItemFinished", _s_set_mOnSnapItemFinished);
            Utils.RegisterFunc(L, Utils.SETTER_IDX, "mOnSnapNearestChanged", _s_set_mOnSnapNearestChanged);
            
			
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
					
					var gen_ret = new SuperScrollView.LoopListView2();
					translator.Push(L, gen_ret);
                    
					return 1;
				}
				
			}
			catch(System.Exception gen_e) {
				return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
			}
            return LuaAPI.luaL_error(L, "invalid arguments to SuperScrollView.LoopListView2 constructor!");
            
        }
        
		
        
		
        
        
        
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_SetOnBeginDragAction(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                SuperScrollView.LoopListView2 gen_to_be_invoked = (SuperScrollView.LoopListView2)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    System.Action _callback = translator.GetDelegate<System.Action>(L, 2);
                    
                    gen_to_be_invoked.SetOnBeginDragAction( _callback );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_SetOnDragingAction(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                SuperScrollView.LoopListView2 gen_to_be_invoked = (SuperScrollView.LoopListView2)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    System.Action _callback = translator.GetDelegate<System.Action>(L, 2);
                    
                    gen_to_be_invoked.SetOnDragingAction( _callback );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_SetOnEndDragAction(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                SuperScrollView.LoopListView2 gen_to_be_invoked = (SuperScrollView.LoopListView2)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    System.Action _callback = translator.GetDelegate<System.Action>(L, 2);
                    
                    gen_to_be_invoked.SetOnEndDragAction( _callback );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_SetOnListClickAction(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                SuperScrollView.LoopListView2 gen_to_be_invoked = (SuperScrollView.LoopListView2)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    System.Action _callback = translator.GetDelegate<System.Action>(L, 2);
                    
                    gen_to_be_invoked.SetOnListClickAction( _callback );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_OnPointerClick(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                SuperScrollView.LoopListView2 gen_to_be_invoked = (SuperScrollView.LoopListView2)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    UnityEngine.EventSystems.PointerEventData _eventData = (UnityEngine.EventSystems.PointerEventData)translator.GetObject(L, 2, typeof(UnityEngine.EventSystems.PointerEventData));
                    
                    gen_to_be_invoked.OnPointerClick( _eventData );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_GetItemPrefabConfData(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                SuperScrollView.LoopListView2 gen_to_be_invoked = (SuperScrollView.LoopListView2)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    string _prefabName = LuaAPI.lua_tostring(L, 2);
                    
                        var gen_ret = gen_to_be_invoked.GetItemPrefabConfData( _prefabName );
                        translator.Push(L, gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_OnItemPrefabChanged(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                SuperScrollView.LoopListView2 gen_to_be_invoked = (SuperScrollView.LoopListView2)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    string _prefabName = LuaAPI.lua_tostring(L, 2);
                    
                    gen_to_be_invoked.OnItemPrefabChanged( _prefabName );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_InitListView(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                SuperScrollView.LoopListView2 gen_to_be_invoked = (SuperScrollView.LoopListView2)translator.FastGetCSObj(L, 1);
            
            
			    int gen_param_count = LuaAPI.lua_gettop(L);
            
                if(gen_param_count == 5&& LuaTypes.LUA_TNUMBER == LuaAPI.lua_type(L, 2)&& translator.Assignable<System.Func<SuperScrollView.LoopListView2, int, SuperScrollView.LoopListViewItem2>>(L, 3)&& translator.Assignable<SuperScrollView.LoopListViewInitParam>(L, 4)&& translator.Assignable<System.Func<SuperScrollView.LoopListView2, int, string>>(L, 5)) 
                {
                    int _itemTotalCount = LuaAPI.xlua_tointeger(L, 2);
                    System.Func<SuperScrollView.LoopListView2, int, SuperScrollView.LoopListViewItem2> _onGetItemByIndex = translator.GetDelegate<System.Func<SuperScrollView.LoopListView2, int, SuperScrollView.LoopListViewItem2>>(L, 3);
                    SuperScrollView.LoopListViewInitParam _initParam = (SuperScrollView.LoopListViewInitParam)translator.GetObject(L, 4, typeof(SuperScrollView.LoopListViewInitParam));
                    System.Func<SuperScrollView.LoopListView2, int, string> _onGetItemNameByIndex = translator.GetDelegate<System.Func<SuperScrollView.LoopListView2, int, string>>(L, 5);
                    
                    gen_to_be_invoked.InitListView( _itemTotalCount, _onGetItemByIndex, _initParam, _onGetItemNameByIndex );
                    
                    
                    
                    return 0;
                }
                if(gen_param_count == 4&& LuaTypes.LUA_TNUMBER == LuaAPI.lua_type(L, 2)&& translator.Assignable<System.Func<SuperScrollView.LoopListView2, int, SuperScrollView.LoopListViewItem2>>(L, 3)&& translator.Assignable<SuperScrollView.LoopListViewInitParam>(L, 4)) 
                {
                    int _itemTotalCount = LuaAPI.xlua_tointeger(L, 2);
                    System.Func<SuperScrollView.LoopListView2, int, SuperScrollView.LoopListViewItem2> _onGetItemByIndex = translator.GetDelegate<System.Func<SuperScrollView.LoopListView2, int, SuperScrollView.LoopListViewItem2>>(L, 3);
                    SuperScrollView.LoopListViewInitParam _initParam = (SuperScrollView.LoopListViewInitParam)translator.GetObject(L, 4, typeof(SuperScrollView.LoopListViewInitParam));
                    
                    gen_to_be_invoked.InitListView( _itemTotalCount, _onGetItemByIndex, _initParam );
                    
                    
                    
                    return 0;
                }
                if(gen_param_count == 3&& LuaTypes.LUA_TNUMBER == LuaAPI.lua_type(L, 2)&& translator.Assignable<System.Func<SuperScrollView.LoopListView2, int, SuperScrollView.LoopListViewItem2>>(L, 3)) 
                {
                    int _itemTotalCount = LuaAPI.xlua_tointeger(L, 2);
                    System.Func<SuperScrollView.LoopListView2, int, SuperScrollView.LoopListViewItem2> _onGetItemByIndex = translator.GetDelegate<System.Func<SuperScrollView.LoopListView2, int, SuperScrollView.LoopListViewItem2>>(L, 3);
                    
                    gen_to_be_invoked.InitListView( _itemTotalCount, _onGetItemByIndex );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
            return LuaAPI.luaL_error(L, "invalid arguments to SuperScrollView.LoopListView2.InitListView!");
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_ResetListView(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                SuperScrollView.LoopListView2 gen_to_be_invoked = (SuperScrollView.LoopListView2)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    
                    gen_to_be_invoked.ResetListView(  );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_SetListItemCount(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                SuperScrollView.LoopListView2 gen_to_be_invoked = (SuperScrollView.LoopListView2)translator.FastGetCSObj(L, 1);
            
            
			    int gen_param_count = LuaAPI.lua_gettop(L);
            
                if(gen_param_count == 4&& LuaTypes.LUA_TNUMBER == LuaAPI.lua_type(L, 2)&& LuaTypes.LUA_TBOOLEAN == LuaAPI.lua_type(L, 3)&& LuaTypes.LUA_TBOOLEAN == LuaAPI.lua_type(L, 4)) 
                {
                    int _itemCount = LuaAPI.xlua_tointeger(L, 2);
                    bool _resetPos = LuaAPI.lua_toboolean(L, 3);
                    bool _needMoveToIndex = LuaAPI.lua_toboolean(L, 4);
                    
                    gen_to_be_invoked.SetListItemCount( _itemCount, _resetPos, _needMoveToIndex );
                    
                    
                    
                    return 0;
                }
                if(gen_param_count == 3&& LuaTypes.LUA_TNUMBER == LuaAPI.lua_type(L, 2)&& LuaTypes.LUA_TBOOLEAN == LuaAPI.lua_type(L, 3)) 
                {
                    int _itemCount = LuaAPI.xlua_tointeger(L, 2);
                    bool _resetPos = LuaAPI.lua_toboolean(L, 3);
                    
                    gen_to_be_invoked.SetListItemCount( _itemCount, _resetPos );
                    
                    
                    
                    return 0;
                }
                if(gen_param_count == 2&& LuaTypes.LUA_TNUMBER == LuaAPI.lua_type(L, 2)) 
                {
                    int _itemCount = LuaAPI.xlua_tointeger(L, 2);
                    
                    gen_to_be_invoked.SetListItemCount( _itemCount );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
            return LuaAPI.luaL_error(L, "invalid arguments to SuperScrollView.LoopListView2.SetListItemCount!");
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_GetShownItemByItemIndex(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                SuperScrollView.LoopListView2 gen_to_be_invoked = (SuperScrollView.LoopListView2)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    int _itemIndex = LuaAPI.xlua_tointeger(L, 2);
                    
                        var gen_ret = gen_to_be_invoked.GetShownItemByItemIndex( _itemIndex );
                        translator.Push(L, gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_GetShownItemByIndex(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                SuperScrollView.LoopListView2 gen_to_be_invoked = (SuperScrollView.LoopListView2)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    int _index = LuaAPI.xlua_tointeger(L, 2);
                    
                        var gen_ret = gen_to_be_invoked.GetShownItemByIndex( _index );
                        translator.Push(L, gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_GetShownItemByIndexWithoutCheck(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                SuperScrollView.LoopListView2 gen_to_be_invoked = (SuperScrollView.LoopListView2)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    int _index = LuaAPI.xlua_tointeger(L, 2);
                    
                        var gen_ret = gen_to_be_invoked.GetShownItemByIndexWithoutCheck( _index );
                        translator.Push(L, gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_GetIndexInShownItemList(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                SuperScrollView.LoopListView2 gen_to_be_invoked = (SuperScrollView.LoopListView2)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    SuperScrollView.LoopListViewItem2 _item = (SuperScrollView.LoopListViewItem2)translator.GetObject(L, 2, typeof(SuperScrollView.LoopListViewItem2));
                    
                        var gen_ret = gen_to_be_invoked.GetIndexInShownItemList( _item );
                        LuaAPI.xlua_pushinteger(L, gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_DoActionForEachShownItem(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                SuperScrollView.LoopListView2 gen_to_be_invoked = (SuperScrollView.LoopListView2)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    System.Action<SuperScrollView.LoopListViewItem2, object> _action = translator.GetDelegate<System.Action<SuperScrollView.LoopListViewItem2, object>>(L, 2);
                    object _param = translator.GetObject(L, 3, typeof(object));
                    
                    gen_to_be_invoked.DoActionForEachShownItem( _action, _param );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_NewListViewItem(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                SuperScrollView.LoopListView2 gen_to_be_invoked = (SuperScrollView.LoopListView2)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    string _itemPrefabName = LuaAPI.lua_tostring(L, 2);
                    
                        var gen_ret = gen_to_be_invoked.NewListViewItem( _itemPrefabName );
                        translator.Push(L, gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_OnItemSizeChanged(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                SuperScrollView.LoopListView2 gen_to_be_invoked = (SuperScrollView.LoopListView2)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    int _itemIndex = LuaAPI.xlua_tointeger(L, 2);
                    
                    gen_to_be_invoked.OnItemSizeChanged( _itemIndex );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_RefreshItemByItemIndex(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                SuperScrollView.LoopListView2 gen_to_be_invoked = (SuperScrollView.LoopListView2)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    int _itemIndex = LuaAPI.xlua_tointeger(L, 2);
                    
                    gen_to_be_invoked.RefreshItemByItemIndex( _itemIndex );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_FinishSnapImmediately(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                SuperScrollView.LoopListView2 gen_to_be_invoked = (SuperScrollView.LoopListView2)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    
                    gen_to_be_invoked.FinishSnapImmediately(  );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_GetCurShowIndexes(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                SuperScrollView.LoopListView2 gen_to_be_invoked = (SuperScrollView.LoopListView2)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    
                        var gen_ret = gen_to_be_invoked.GetCurShowIndexes(  );
                        translator.Push(L, gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_GetMovePanelToIndexPos(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                SuperScrollView.LoopListView2 gen_to_be_invoked = (SuperScrollView.LoopListView2)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    int _itemIndex = LuaAPI.xlua_tointeger(L, 2);
                    float _offset = (float)LuaAPI.lua_tonumber(L, 3);
                    
                        var gen_ret = gen_to_be_invoked.GetMovePanelToIndexPos( _itemIndex, _offset );
                        translator.PushUnityEngineVector3(L, gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_MovePanelToItemIndex(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                SuperScrollView.LoopListView2 gen_to_be_invoked = (SuperScrollView.LoopListView2)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    int _itemIndex = LuaAPI.xlua_tointeger(L, 2);
                    float _offset = (float)LuaAPI.lua_tonumber(L, 3);
                    
                    gen_to_be_invoked.MovePanelToItemIndex( _itemIndex, _offset );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_RefreshAllShownItem(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                SuperScrollView.LoopListView2 gen_to_be_invoked = (SuperScrollView.LoopListView2)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    
                    gen_to_be_invoked.RefreshAllShownItem(  );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_RefreshAllShownItemWithFirstIndex(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                SuperScrollView.LoopListView2 gen_to_be_invoked = (SuperScrollView.LoopListView2)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    int _firstItemIndex = LuaAPI.xlua_tointeger(L, 2);
                    
                    gen_to_be_invoked.RefreshAllShownItemWithFirstIndex( _firstItemIndex );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_RefreshAllShownItemWithFirstIndexAndPos(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                SuperScrollView.LoopListView2 gen_to_be_invoked = (SuperScrollView.LoopListView2)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    int _firstItemIndex = LuaAPI.xlua_tointeger(L, 2);
                    UnityEngine.Vector3 _pos;translator.Get(L, 3, out _pos);
                    
                    gen_to_be_invoked.RefreshAllShownItemWithFirstIndexAndPos( _firstItemIndex, _pos );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_OnBeginDrag(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                SuperScrollView.LoopListView2 gen_to_be_invoked = (SuperScrollView.LoopListView2)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    UnityEngine.EventSystems.PointerEventData _eventData = (UnityEngine.EventSystems.PointerEventData)translator.GetObject(L, 2, typeof(UnityEngine.EventSystems.PointerEventData));
                    
                    gen_to_be_invoked.OnBeginDrag( _eventData );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_OnEndDrag(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                SuperScrollView.LoopListView2 gen_to_be_invoked = (SuperScrollView.LoopListView2)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    UnityEngine.EventSystems.PointerEventData _eventData = (UnityEngine.EventSystems.PointerEventData)translator.GetObject(L, 2, typeof(UnityEngine.EventSystems.PointerEventData));
                    
                    gen_to_be_invoked.OnEndDrag( _eventData );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_OnDrag(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                SuperScrollView.LoopListView2 gen_to_be_invoked = (SuperScrollView.LoopListView2)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    UnityEngine.EventSystems.PointerEventData _eventData = (UnityEngine.EventSystems.PointerEventData)translator.GetObject(L, 2, typeof(UnityEngine.EventSystems.PointerEventData));
                    
                    gen_to_be_invoked.OnDrag( _eventData );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_GetItemCornerPosInViewPort(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                SuperScrollView.LoopListView2 gen_to_be_invoked = (SuperScrollView.LoopListView2)translator.FastGetCSObj(L, 1);
            
            
			    int gen_param_count = LuaAPI.lua_gettop(L);
            
                if(gen_param_count == 3&& translator.Assignable<SuperScrollView.LoopListViewItem2>(L, 2)&& translator.Assignable<SuperScrollView.ItemCornerEnum>(L, 3)) 
                {
                    SuperScrollView.LoopListViewItem2 _item = (SuperScrollView.LoopListViewItem2)translator.GetObject(L, 2, typeof(SuperScrollView.LoopListViewItem2));
                    SuperScrollView.ItemCornerEnum _corner;translator.Get(L, 3, out _corner);
                    
                        var gen_ret = gen_to_be_invoked.GetItemCornerPosInViewPort( _item, _corner );
                        translator.PushUnityEngineVector3(L, gen_ret);
                    
                    
                    
                    return 1;
                }
                if(gen_param_count == 2&& translator.Assignable<SuperScrollView.LoopListViewItem2>(L, 2)) 
                {
                    SuperScrollView.LoopListViewItem2 _item = (SuperScrollView.LoopListViewItem2)translator.GetObject(L, 2, typeof(SuperScrollView.LoopListViewItem2));
                    
                        var gen_ret = gen_to_be_invoked.GetItemCornerPosInViewPort( _item );
                        translator.PushUnityEngineVector3(L, gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
            return LuaAPI.luaL_error(L, "invalid arguments to SuperScrollView.LoopListView2.GetItemCornerPosInViewPort!");
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_ForceUpdate(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                SuperScrollView.LoopListView2 gen_to_be_invoked = (SuperScrollView.LoopListView2)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    
                    gen_to_be_invoked.ForceUpdate(  );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_UpdateAllShownItemSnapData(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                SuperScrollView.LoopListView2 gen_to_be_invoked = (SuperScrollView.LoopListView2)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    
                    gen_to_be_invoked.UpdateAllShownItemSnapData(  );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_ClearSnapData(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                SuperScrollView.LoopListView2 gen_to_be_invoked = (SuperScrollView.LoopListView2)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    
                    gen_to_be_invoked.ClearSnapData(  );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_SetSnapTargetItemIndex(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                SuperScrollView.LoopListView2 gen_to_be_invoked = (SuperScrollView.LoopListView2)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    int _itemIndex = LuaAPI.xlua_tointeger(L, 2);
                    
                    gen_to_be_invoked.SetSnapTargetItemIndex( _itemIndex );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_ForceSnapUpdateCheck(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                SuperScrollView.LoopListView2 gen_to_be_invoked = (SuperScrollView.LoopListView2)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    
                    gen_to_be_invoked.ForceSnapUpdateCheck(  );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_UpdateListView(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                SuperScrollView.LoopListView2 gen_to_be_invoked = (SuperScrollView.LoopListView2)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    float _distanceForRecycle0 = (float)LuaAPI.lua_tonumber(L, 2);
                    float _distanceForRecycle1 = (float)LuaAPI.lua_tonumber(L, 3);
                    float _distanceForNew0 = (float)LuaAPI.lua_tonumber(L, 4);
                    float _distanceForNew1 = (float)LuaAPI.lua_tonumber(L, 5);
                    
                    gen_to_be_invoked.UpdateListView( _distanceForRecycle0, _distanceForRecycle1, _distanceForNew0, _distanceForNew1 );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_ClearAllItems(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                SuperScrollView.LoopListView2 gen_to_be_invoked = (SuperScrollView.LoopListView2)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    
                    gen_to_be_invoked.ClearAllItems(  );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        
        
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_ArrangeType(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                SuperScrollView.LoopListView2 gen_to_be_invoked = (SuperScrollView.LoopListView2)translator.FastGetCSObj(L, 1);
                translator.Push(L, gen_to_be_invoked.ArrangeType);
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 1;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_IsVertList(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                SuperScrollView.LoopListView2 gen_to_be_invoked = (SuperScrollView.LoopListView2)translator.FastGetCSObj(L, 1);
                LuaAPI.lua_pushboolean(L, gen_to_be_invoked.IsVertList);
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 1;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_ItemTotalCount(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                SuperScrollView.LoopListView2 gen_to_be_invoked = (SuperScrollView.LoopListView2)translator.FastGetCSObj(L, 1);
                LuaAPI.xlua_pushinteger(L, gen_to_be_invoked.ItemTotalCount);
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 1;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_ContainerTrans(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                SuperScrollView.LoopListView2 gen_to_be_invoked = (SuperScrollView.LoopListView2)translator.FastGetCSObj(L, 1);
                translator.Push(L, gen_to_be_invoked.ContainerTrans);
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 1;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_ScrollRect(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                SuperScrollView.LoopListView2 gen_to_be_invoked = (SuperScrollView.LoopListView2)translator.FastGetCSObj(L, 1);
                translator.Push(L, gen_to_be_invoked.ScrollRect);
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 1;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_IsDraging(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                SuperScrollView.LoopListView2 gen_to_be_invoked = (SuperScrollView.LoopListView2)translator.FastGetCSObj(L, 1);
                LuaAPI.lua_pushboolean(L, gen_to_be_invoked.IsDraging);
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 1;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_ItemSnapEnable(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                SuperScrollView.LoopListView2 gen_to_be_invoked = (SuperScrollView.LoopListView2)translator.FastGetCSObj(L, 1);
                LuaAPI.lua_pushboolean(L, gen_to_be_invoked.ItemSnapEnable);
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 1;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_SupportScrollBar(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                SuperScrollView.LoopListView2 gen_to_be_invoked = (SuperScrollView.LoopListView2)translator.FastGetCSObj(L, 1);
                LuaAPI.lua_pushboolean(L, gen_to_be_invoked.SupportScrollBar);
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 1;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_ShownItemCount(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                SuperScrollView.LoopListView2 gen_to_be_invoked = (SuperScrollView.LoopListView2)translator.FastGetCSObj(L, 1);
                LuaAPI.xlua_pushinteger(L, gen_to_be_invoked.ShownItemCount);
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 1;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_ViewPortSize(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                SuperScrollView.LoopListView2 gen_to_be_invoked = (SuperScrollView.LoopListView2)translator.FastGetCSObj(L, 1);
                LuaAPI.lua_pushnumber(L, gen_to_be_invoked.ViewPortSize);
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 1;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_ViewPortWidth(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                SuperScrollView.LoopListView2 gen_to_be_invoked = (SuperScrollView.LoopListView2)translator.FastGetCSObj(L, 1);
                LuaAPI.lua_pushnumber(L, gen_to_be_invoked.ViewPortWidth);
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 1;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_ViewPortHeight(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                SuperScrollView.LoopListView2 gen_to_be_invoked = (SuperScrollView.LoopListView2)translator.FastGetCSObj(L, 1);
                LuaAPI.lua_pushnumber(L, gen_to_be_invoked.ViewPortHeight);
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 1;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_CurSnapNearestItemIndex(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                SuperScrollView.LoopListView2 gen_to_be_invoked = (SuperScrollView.LoopListView2)translator.FastGetCSObj(L, 1);
                LuaAPI.xlua_pushinteger(L, gen_to_be_invoked.CurSnapNearestItemIndex);
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 1;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_mOnBeginDragAction(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                SuperScrollView.LoopListView2 gen_to_be_invoked = (SuperScrollView.LoopListView2)translator.FastGetCSObj(L, 1);
                translator.Push(L, gen_to_be_invoked.mOnBeginDragAction);
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 1;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_mOnDragingAction(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                SuperScrollView.LoopListView2 gen_to_be_invoked = (SuperScrollView.LoopListView2)translator.FastGetCSObj(L, 1);
                translator.Push(L, gen_to_be_invoked.mOnDragingAction);
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 1;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_mOnEndDragAction(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                SuperScrollView.LoopListView2 gen_to_be_invoked = (SuperScrollView.LoopListView2)translator.FastGetCSObj(L, 1);
                translator.Push(L, gen_to_be_invoked.mOnEndDragAction);
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 1;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_mOnListClickAction(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                SuperScrollView.LoopListView2 gen_to_be_invoked = (SuperScrollView.LoopListView2)translator.FastGetCSObj(L, 1);
                translator.Push(L, gen_to_be_invoked.mOnListClickAction);
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 1;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_mOnSnapItemFinished(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                SuperScrollView.LoopListView2 gen_to_be_invoked = (SuperScrollView.LoopListView2)translator.FastGetCSObj(L, 1);
                translator.Push(L, gen_to_be_invoked.mOnSnapItemFinished);
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 1;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_mOnSnapNearestChanged(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                SuperScrollView.LoopListView2 gen_to_be_invoked = (SuperScrollView.LoopListView2)translator.FastGetCSObj(L, 1);
                translator.Push(L, gen_to_be_invoked.mOnSnapNearestChanged);
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 1;
        }
        
        
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _s_set_ArrangeType(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                SuperScrollView.LoopListView2 gen_to_be_invoked = (SuperScrollView.LoopListView2)translator.FastGetCSObj(L, 1);
                SuperScrollView.ListItemArrangeType gen_value;translator.Get(L, 2, out gen_value);
				gen_to_be_invoked.ArrangeType = gen_value;
            
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 0;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _s_set_OnGetItemByIndex(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                SuperScrollView.LoopListView2 gen_to_be_invoked = (SuperScrollView.LoopListView2)translator.FastGetCSObj(L, 1);
                gen_to_be_invoked.OnGetItemByIndex = translator.GetDelegate<System.Func<SuperScrollView.LoopListView2, int, SuperScrollView.LoopListViewItem2>>(L, 2);
            
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 0;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _s_set_OnGetItemNameByIndex(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                SuperScrollView.LoopListView2 gen_to_be_invoked = (SuperScrollView.LoopListView2)translator.FastGetCSObj(L, 1);
                gen_to_be_invoked.OnGetItemNameByIndex = translator.GetDelegate<System.Func<SuperScrollView.LoopListView2, int, string>>(L, 2);
            
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 0;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _s_set_ItemSnapEnable(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                SuperScrollView.LoopListView2 gen_to_be_invoked = (SuperScrollView.LoopListView2)translator.FastGetCSObj(L, 1);
                gen_to_be_invoked.ItemSnapEnable = LuaAPI.lua_toboolean(L, 2);
            
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 0;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _s_set_SupportScrollBar(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                SuperScrollView.LoopListView2 gen_to_be_invoked = (SuperScrollView.LoopListView2)translator.FastGetCSObj(L, 1);
                gen_to_be_invoked.SupportScrollBar = LuaAPI.lua_toboolean(L, 2);
            
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 0;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _s_set_mOnBeginDragAction(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                SuperScrollView.LoopListView2 gen_to_be_invoked = (SuperScrollView.LoopListView2)translator.FastGetCSObj(L, 1);
                gen_to_be_invoked.mOnBeginDragAction = translator.GetDelegate<System.Action>(L, 2);
            
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 0;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _s_set_mOnDragingAction(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                SuperScrollView.LoopListView2 gen_to_be_invoked = (SuperScrollView.LoopListView2)translator.FastGetCSObj(L, 1);
                gen_to_be_invoked.mOnDragingAction = translator.GetDelegate<System.Action>(L, 2);
            
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 0;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _s_set_mOnEndDragAction(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                SuperScrollView.LoopListView2 gen_to_be_invoked = (SuperScrollView.LoopListView2)translator.FastGetCSObj(L, 1);
                gen_to_be_invoked.mOnEndDragAction = translator.GetDelegate<System.Action>(L, 2);
            
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 0;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _s_set_mOnListClickAction(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                SuperScrollView.LoopListView2 gen_to_be_invoked = (SuperScrollView.LoopListView2)translator.FastGetCSObj(L, 1);
                gen_to_be_invoked.mOnListClickAction = translator.GetDelegate<System.Action>(L, 2);
            
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 0;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _s_set_mOnSnapItemFinished(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                SuperScrollView.LoopListView2 gen_to_be_invoked = (SuperScrollView.LoopListView2)translator.FastGetCSObj(L, 1);
                gen_to_be_invoked.mOnSnapItemFinished = translator.GetDelegate<System.Action<SuperScrollView.LoopListView2, SuperScrollView.LoopListViewItem2>>(L, 2);
            
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 0;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _s_set_mOnSnapNearestChanged(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                SuperScrollView.LoopListView2 gen_to_be_invoked = (SuperScrollView.LoopListView2)translator.FastGetCSObj(L, 1);
                gen_to_be_invoked.mOnSnapNearestChanged = translator.GetDelegate<System.Action<SuperScrollView.LoopListView2, SuperScrollView.LoopListViewItem2>>(L, 2);
            
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 0;
        }
        
		
		
		
		
    }
}
