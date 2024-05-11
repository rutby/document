using System;
using System.Collections.Generic;
using System.Threading;

namespace ProtoBufNet
{
    internal class ActiveQueue
    {
        public ActiveQueue(int size)
        {
            actions = new LinkedList<Action<NetIOService>>();
            semNotFull = new Semaphore(size, size);
            semNotEmpty = new Semaphore(0, size);
        }

        public void Put(Action<NetIOService> act)
        {
            semNotFull.WaitOne();
            lock (actions)
            {
                actions.AddLast(act);
            }
            semNotEmpty.Release();
        }

        public Action<NetIOService> Get()
        {
            semNotEmpty.WaitOne();
            Action<NetIOService> act = null;
            lock (actions)
            {
                act = actions.First.Value;
                actions.RemoveFirst();
            }
            semNotFull.Release();
            return act;
        }

        public Action<NetIOService> TryGet()
        {
            Action<NetIOService> act = null;

            if (semNotEmpty.WaitOne(0))
            {
                lock (actions)
                {
                    act = actions.First.Value;
                    actions.RemoveFirst();
                }
            }

            return act;
        }


        private LinkedList<Action<NetIOService>> actions;
        private Semaphore semNotFull;
        private Semaphore semNotEmpty;
    }

    internal class ActiveQueue2
    {
        public ActiveQueue2(int size)
        {
            actions = new LinkedList<Action<NetIOService>>();
        }

        public void Put(Action<NetIOService> act)
        {
            lock (actions)
            {
                actions.AddLast(act);
            }
        }

        public Action<NetIOService> TryGet()
        {
            Action<NetIOService> act = null;

            lock (actions)
            {
                if (actions.Count != 0)
                {
                    act = actions.First.Value;
                    actions.RemoveFirst();
                }
            }

            return act;
        }

        private LinkedList<Action<NetIOService>> actions;
    }

    public class NetIOService
    {
        public readonly int QueueSize = 10000;

        public NetIOService()
        {
            queue = new ActiveQueue2(QueueSize);
            Start();
        }

        public void Post(Action<NetIOService> callback)
        {
            queue.Put(callback);
        }

        //public void Run()
        //{
        //    while (true)
        //    {
        //        var callback = queue.Get();
        //        if (callback == null)
        //            return;

        //        callback.Invoke(this);
        //    }
        //}

        public void Poll()
        {
            if (!isRunning)
            {
                return;
            }

            Action<NetIOService> callback = null;
            do
            {
                callback = queue.TryGet();
                if (callback != null)
                {
                    callback.Invoke(this);
                }
            }
            while (callback != null && isRunning);
        }

        public void Start()
        {
            isRunning = true;
        }

        public void Stop()
        {
            isRunning = false;
        }

        private bool isRunning = false;

        private ActiveQueue2 queue;
    }
}
