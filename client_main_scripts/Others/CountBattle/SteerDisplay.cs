using System.Collections;
using System.Collections.Generic;
using UnityEngine;

namespace LW.CountBattle
{
    /**
    * 用于平滑插值显示物理模拟物体
    */
    public class SteerDisplay
    {
        public static int AUTO_INC_ID = 0;
        public static int DELAY_TICKS = 3;

        struct SyncState
        {
            public Vector3 position;
            public float timestamp;
            public SyncState(Vector3 position, float timestamp)
            {
                this.position = position;
                this.timestamp = timestamp;
            }
        }

        private List<SyncState> _buffer = new List<SyncState>();
        private float _syncTimer = 0f;
        private float _firstTickTimeFix = 1f;
        private int _id = ++AUTO_INC_ID;

        private Vector3 _position = Vector3.zero;
        public Vector3 Position { get { return _position; } }

        public SteerDisplay(Vector3 pos0, float firstTickTimeFix = 0f)
        {
            Push(pos0, 0f);
            _firstTickTimeFix = firstTickTimeFix;
        }

        public void Push(Vector3 position, float timestamp)
        {
            // if (_id == 3) Debug.LogError($"{_id}::Push->{timestamp}");
            _buffer.Add(new SyncState(position, timestamp));
        }

        public void Update(float dt)
        {
            if (_buffer.Count < DELAY_TICKS) return;
            _syncTimer += dt - _firstTickTimeFix;
            _firstTickTimeFix = 0f;

            // if (_id == 3) Debug.LogError($"{_id}::Sync->{_syncTimer}");
            
            float lerpT = (_syncTimer - _buffer[0].timestamp) / (_buffer[1].timestamp - _buffer[0].timestamp);

            bool bounded = false;
            if (lerpT > 1)
            {
                int jump = (int)lerpT;
                lerpT -= jump;
                while (jump > 0)
                {
                    if (_buffer.Count <= 2)
                    {
                        DELAY_TICKS++;
                        bounded = true;
                        break;
                    }
                    _buffer.RemoveAt(0);
                    --jump;
                }
            }

            if (bounded)
            {
                // Debug.LogError($"{_id}::BOUNDED::{DEFAULT_DELAY_TICKS}");
                _position = _buffer[0].position;
                return;
            }

            if (lerpT < 1)
            {
                _position = Vector3.Lerp(_buffer[0].position, _buffer[1].position, lerpT);
            }
            else if (lerpT == 1)
            {
                _position = _buffer[1].position;
                _buffer.RemoveAt(0);
            }
        }
    }
}