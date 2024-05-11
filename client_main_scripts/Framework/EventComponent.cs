//------------------------------------------------------------
// Game Framework v3.x
// Copyright © 2013-2018 Jiang Yin. All rights reserved.
// Homepage: http://gameframework.cn/
// Feedback: mailto:jiangyin@gameframework.cn
//------------------------------------------------------------

using GameFramework;

using System;
using System.Collections.Generic;
using Sfs2X.Entities.Data;
using UnityEngine;
using XLua;

namespace UnityGameFramework.Runtime
{
    
    public class CommonEventArgs : GameEventArgs
    {
        private int m_EventId;
        private object m_UserData;

        public CommonEventArgs(EventId eventId)
        {
            m_EventId = (int)eventId;
        }
        
        public override int Id
        {
            get { return m_EventId; }
        }


        public override void Clear()
        {
            m_EventId = 0;
            m_UserData = null;
        }
    }
    public abstract class GameEventArgs : BaseEventArgs {}
    public abstract class BaseEventArgs : GameFrameworkEventArgs, IReference
    {
        /// <summary>
        /// 获取类型编号。
        /// </summary>
        public abstract int Id
        {
            get;
        }

        /// <summary>
        /// 清理引用。
        /// </summary>
        public abstract void Clear();
    }
    
    public enum EventPoolMode
    {
        /// <summary>
        /// 默认事件池模式，即必须存在有且只有一个事件处理函数。
        /// </summary>
        Default = 0,

        /// <summary>
        /// 允许不存在事件处理函数。
        /// </summary>
        AllowNoHandler = 1,

        /// <summary>
        /// 允许存在多个事件处理函数。
        /// </summary>
        AllowMultiHandler = 2,

        /// <summary>
        /// 允许存在重复的事件处理函数。
        /// </summary>
        AllowDuplicateHandler = 4,
    }
    
    /// <summary>
    /// 事件组件。
    /// </summary>
    public class EventComponent : IGameController
    {
        public class ObjectPool<T>
        {
//            private readonly ConcurrentBag<T> _objects;    
            private readonly Queue<T> _objects; 
            private readonly Func<T> _objectGenerator;

            public ObjectPool(Func<T> objectGenerator)
            {
                _objectGenerator = objectGenerator ?? throw new ArgumentNullException(nameof(objectGenerator));
//                _objects = new ConcurrentBag<T>();
                _objects = new Queue<T>();
            }

            public T Get()
            {
//                var o = _objects.TryTake(out T item) ? item : _objectGenerator();

                if (_objects.Count > 0)
                {
                    return _objects.Dequeue();
                }
                
                return _objectGenerator();
//                var o = _objects.TryTake(out T item) ? item : _objectGenerator();
//                return o;
            }

            public void Return(T item)
            {
//                _objects.Add(item);
                _objects.Enqueue(item);
            }

            public int Count()
            {
                return _objects.Count;
            }
        }
        
        private ObjectPool<List<Action<object>>> m_Pool = new ObjectPool<List<Action<object>>>(() => new List<Action<object>>(1));

        
        private readonly Dictionary<int, List<Action<object>>> m_EventHandlers;
        private readonly EventPoolMode m_EventPoolMode;
        
        /// <summary>
        /// 初始化事件池的新实例。
        /// </summary>
        /// <param name="mode">事件池模式。</param>
        public EventComponent(EventPoolMode mode)
        {
            m_EventHandlers = new Dictionary<int, List<Action<object>>>();
            m_EventPoolMode = mode;
        }

        public void OnUpdate(float elapseSeconds)
        {
        }

        /// <summary>
        /// 关闭并清理事件池。
        /// </summary>
        public void Shutdown()
        {
            m_EventHandlers.Clear();
        }

        /// <summary>
        /// 检查订阅事件处理函数。
        /// </summary>
        /// <param name="id">事件类型编号。</param>
        /// <param name="handler">要检查的事件处理函数。</param>
        /// <returns>是否存在事件处理函数。</returns>
        private bool Check(EventId id, Action<object> handler)
        {
#if UNITY_EDITOR
            if (handler == null)
            {
                throw new GameFrameworkException("Event handler is invalid.");
            }

            List<Action<object>> handlers = null;
            if (!m_EventHandlers.TryGetValue((int)id, out handlers))
            {
                return false;
            }

            if (handlers == null || handlers.Count == 0)
            {
                return false;
            }

            foreach (Action<object> i in handlers)
            {
                if (i == handler)
                {
                    return true;
                }
            }
#endif
            return false;
        }

        /// <summary>
        /// 订阅事件处理函数。
        /// </summary>
        /// <param name="eventID">事件类型编号。</param>
        /// <param name="handler">要订阅的事件处理函数。</param>
        public void Subscribe(EventId eventID, Action<object> handler)
        {
            if (handler == null)
            {
                throw new GameFrameworkException("Event handler is invalid.");
            }

            int id = (int)eventID;

            List<Action<object>> handlers = null;
            if (!m_EventHandlers.TryGetValue(id, out handlers) || handlers == null)
            {
                handlers = m_Pool.Get();
                handlers.Clear();
                handlers.Add(handler);
                
                m_EventHandlers[id] = handlers;
            }
            else if ((m_EventPoolMode & EventPoolMode.AllowMultiHandler) == 0)
            {
                Log.Error(string.Format("Event '{0}' not allow multi handler.", id.ToString()));
                return;
            }
            else if ((m_EventPoolMode & EventPoolMode.AllowDuplicateHandler) == 0 && Check(eventID, handler))
            {
                Log.Error(string.Format("Event '{0}' not allow duplicate handler.", id.ToString()));
                return;
            }
            else
            {
                //eventHandler += handler;
                //m_EventHandlers[id] = eventHandler;
                
                handlers.Add(handler);
            }
        }
        
        /// <summary>
        /// 取消订阅事件处理函数。
        /// </summary>
        /// <param name="eventId">事件类型编号。</param>
        /// <param name="handler">要取消订阅的事件处理函数。</param>
        public void Unsubscribe(EventId eventId, Action<object> handler)
        {
            if (handler == null)
            {
                throw new GameFrameworkException("Event handler is invalid.");
            }

            int id = (int) eventId;
            
            // if (m_EventHandlers.ContainsKey(id))
            // {
            //     m_EventHandlers[id] -= handler;
            // }
            
            
            //这里要检查下value是否为null
            if (m_EventHandlers.TryGetValue(id, out var eventHandler) && eventHandler != null)
            {
                // 从后往前删除
                for (int i= eventHandler.Count - 1; i>=0; --i)
                {
                    if (eventHandler[i] == handler)
                    {
                        eventHandler.RemoveAt(i);
                    }
                }

                // 如果数量为0，则直接删除
                if (eventHandler.Count == 0)
                {
                    if (m_Pool.Count() < 128)
                    {
                        m_Pool.Return(eventHandler);
                    }

                    m_EventHandlers[id] = null;
                }
            }
        }

        /// <summary>
        /// 抛出事件
        /// </summary>
        public void Fire(EventId eventId, object userData = null)
        {
            if (userData == null
                || userData is int
                || userData is long
                || userData is bool
                || userData is string
                || userData is LuaTable
                || userData is SFSObject)
            {
                HandleEvent(eventId, userData);
            }
            else
            {
                Log.Error("Fire event, unsupported data types {0}", userData.GetType().ToString());
            }
        }

        /// <summary>
        /// 处理事件
        /// </summary>
        private void HandleEvent(EventId eventId, object userData)
        {
            int id = (int)eventId;
            //
            // 通知 CS 端处理
            //
            if (m_EventHandlers.TryGetValue(id, out var handlers) && handlers != null)
            {
                //Note: 这里不要用global list, 因为在handlerEvent过程中 极有可能会fire其他事件，然后再次调用HandleEvent 相当于递归调用 此时global list就会被清除 引起逻辑错误
                var current = m_Pool.Get();
                current.Clear();
                
                for (var i = 0; i < handlers.Count; i++)
                {
                    current.Add(handlers[i]);
                }

                int c = current.Count;
                for (int i = 0; i < c; ++i)
                {
                    try
                    {
                        current[i](userData);
                    }
                    catch(Exception exception)
                    {
                        Log.Error("HandleEvent process exception!!! exception:{0}", exception.ToString());
                    }
                }
                
                m_Pool.Return(current);
            }
            
            if (handlers == null && (m_EventPoolMode & EventPoolMode.AllowNoHandler) == 0)
            {
                throw new GameFrameworkException(string.Format("Event '{0}' not allow no handler.", eventId.ToString()));
            }

            //
            // 通知 Lua 端处理
            //
            if (userData is SFSObject)
            {
                GameEntry.Lua.EventManager?.DispatchCSEventSFSObject(id, (userData as SFSObject).ToBinary().GetRawBytes());
            }
            else
            {
                GameEntry.Lua.EventManager?.DispatchCSEvent(id, userData);
            }
        }
    }
}
