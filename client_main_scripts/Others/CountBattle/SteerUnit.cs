using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using System;

namespace LW.CountBattle
{
    public class SteerUnit
    {
        public int id;
        public int initPoint;
        public int point;
        public Circle shape;
        public Vector2 velocity;
        public Vector2 pos
        {
            get { return shape.pos; }
        }
        public float radius
        {
            get { return shape.radius; }
        }
        public float sqrMag2Center = 0f;

        private bool _isDead = false;
        private float _tickTimer = 0f;
        private SteerDisplay _display;
        public Vector3 DisplayPos { get { return _display.Position; } }
        public bool IsDead { get { return _isDead; } }

        public Action OnDead;

        public SteerUnit(int id, Vector3 pos0, int point, float radius, float firstTickTimeFix)
        {
            this.id = id;
            this.initPoint = point;
            this.point = point;
            this.shape = new Circle(new Vector2(pos0.x, pos0.z), 0f, radius);
            _display = new SteerDisplay(pos0, firstTickTimeFix);
        }

        public void Destroy()
        {
            shape = null;
            OnDead = null;
            _display = null;
        }

        public void SetPos(float x, float z)
        {
            if (shape == null) return;
            var pos = new Vector2(x, z);
            shape.pos = pos;
        }

        public void Move(Vector2 vec)
        {
            if (shape == null) return; 
            shape.pos += vec;
        }

        public void Kill()
        {
            if (!_isDead)
            {
                _isDead = true;
                OnDead?.Invoke();
            }
        }

        public void Tick(float dt, float y)
        {
            _tickTimer += dt;
            _display.Push(new Vector3(shape.pos.x, y, shape.pos.y), _tickTimer);
        }

        public void Update(float dt)
        {
            _display.Update(dt);
        }
        
        public void Sync(Transform transform)
        {
            if (transform == null) return;
            transform.position = _display.Position;
        }
    }
}