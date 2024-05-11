using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using System;

namespace LW.CountBattle
{
    /**
    * 模拟一组简单集群
    */
    public class SteerGroup : MonoBehaviour
    {
        private static int _SPAWN_TASK_ID = 0;
        struct SpawnTask
        {
            public int id;
            public int amount;
            public int point;
            public float radius;
            public float timer;
            public SpawnTask(int amount, int point, float radius, float timer = 0f)
            {
                this.id = ++_SPAWN_TASK_ID;
                this.amount = amount;
                this.point = point;
                this.radius = radius;
                this.timer = timer;
            }

            public int GetSpawnAmount(float dt, float spawnPerSecond)
            {
                timer += dt;
                int spawnAmount = Mathf.FloorToInt(timer * spawnPerSecond);
                timer -= spawnAmount / spawnPerSecond;
                spawnAmount = Mathf.Min(spawnAmount, amount);
                amount -= spawnAmount;
                return spawnAmount;
            }
        }

        public static float TICK_INTERVAL = 0.02f;      // 物理模拟帧率
        private int __unit_inc_id = 0;

        public string groupTag = string.Empty;
        public int spawnPerSecond = 50;
        public float repForceFactor = 10f;
        public float attForceFactor = 0.1f;

        private float _tickTimer = 0f;
        private float _tickCD = 0f;
        private float _currY = 0f;
        private Vector2 _velocity = Vector2.zero;
        private List<SteerUnit> _units = new List<SteerUnit>();
        private List<SpawnTask> _spawnTasks = new List<SpawnTask>();
        private List<SteerCollider> _trapColliders = new List<SteerCollider>();
        private SteerDisplay _display;

        public int GroupPoint { get; set;}
        public Circle GroupCircle { get; set; }
        public float GroupRadius { get { return GroupCircle.radius; } }
        public float GroupBoundLeft { get; set; }
        public float GroupBoundRight { get; set; }
        public float GroupBoundTop { get; set; }
        public float GroupBoundBottom { get; set; }
        public Box GroupBoundBox {
            get
            {
                Vector2 center = new Vector2((GroupBoundLeft + GroupBoundRight) * 0.5f, (GroupBoundTop + GroupBoundBottom) * 0.5f) + GroupCircle.pos;
                Vector2 size = new Vector2(GroupBoundRight - GroupBoundLeft, GroupBoundTop - GroupBoundBottom);
                return new Box(center, 0, size);
            }
        }
        public int UnitCount { get { return _units.Count; } }
        public bool DisableLogic { get; set;}
        public bool RepSwitch { get; set;}
        public bool AttSwitch { get; set;}
        public Vector3 GroupPos { get { return GroupCircle == null ? Vector3.zero : new Vector3(GroupCircle.pos.x, _currY, GroupCircle.pos.y); } }
        public float GroupPosX { get { return GroupCircle == null ? 0f : GroupCircle.pos.x; } }
        public float GroupPosY { get { return _currY; } }
        public float GroupPosZ { get { return GroupCircle == null ? 0f : GroupCircle.pos.y; } }
        public List<SteerUnit> Units { get { return _units; } }
        public SteerGroup EngageGroup { get; set; }

        public Action<int, SteerUnit> OnUnitSpawn;
        public Action<int> OnUnitRemoved;
        public Action<int> OnGroupPointChanged;
        public Action<int, int> OnCollideTrap;

        void Awake()
        {
            GroupCircle = new Circle(Vector2.zero, 0f, 0f);
            SetPos(transform.position.x, transform.position.y, transform.position.z);

            _display = new SteerDisplay(GroupCircle.pos);
        }

        void OnDestroy()
        {
            OnUnitSpawn = null;
            foreach (var unit in _units)
            {
                unit.Destroy();
            }
            _units = null;
            _spawnTasks = null;
            _trapColliders = null;
            _display = null;

            GroupCircle = null;
        }

        public void SetPosX(float x)
        {
            SetPos(x, _currY, GroupCircle.pos.y);
        }
        public void SetPosY(float y)
        {
            SetPos(GroupCircle.pos.x, y, GroupCircle.pos.y);
        }
        public void SetPosXZ(float x, float z)
        {
            SetPos(x, _currY, z);
        }
        public void SetPos(float x, float y, float z)
        {
            _currY = y;
            Vector2 newPos = new Vector2(x, z);
            Vector2 diffVec = newPos - GroupCircle.pos;
            GroupCircle.pos = newPos;
            for (int i = 0; i < _units.Count; i++)
            {
                _units[i].Move(diffVec);
            }
        }

        public void SetVelocity(float vx, float vz)
        {
            _velocity = new Vector2(vx, vz);
        }

        // 注意Collider上center必须保持Vector3.zero
        public bool AddTrapCollider(int id, Collider collider)
        {
            if (collider == null)
            {
                GameFramework.Log.Error("SteerGroup.AddTrapCollider collider is null");
                return false;
            }
            if (FindTrapCollider(id) != null)
            {
                GameFramework.Log.Error("SteerGroup.AddTrapCollider collider id {0} already exist", id);
                return false;
            }
            if (collider is BoxCollider)
            {
                var boxTrans = collider.transform;
                var boxCollider = collider as BoxCollider;
                var pos = new Vector2(boxTrans.position.x, boxTrans.position.z);
                var angle = boxTrans.rotation.eulerAngles.y;
                var size = new Vector2(boxCollider.size.x * boxTrans.localScale.x, boxCollider.size.z * boxTrans.localScale.z);
                var box = new Box(pos, angle, size);
                _trapColliders.Add(new SteerCollider(id, box));
                return true;
            }
            else if (collider is SphereCollider)
            {
                var sphereTrans = collider.transform;
                var sphereCollider = collider as SphereCollider;
                var pos = new Vector2(sphereTrans.position.x, sphereTrans.position.z);
                var radius = sphereCollider.radius * sphereTrans.localScale.x;
                var circle = new Circle(pos, 0f, radius);
                _trapColliders.Add(new SteerCollider(id, circle));
                return true;
            }
            else
            {
                GameFramework.Log.Error($"SteerGroup.AddTrapShape Error! unknown collider id:{id} type:{collider.GetType().Name}");
                return false;
            }
        }

        public SteerCollider FindTrapCollider(int id)
        {
            return _trapColliders.Find((collider) => { return collider.id == id; });
        }

        // 注意Collider上center必须保持Vector3.zero
        public void UpdateTrapCollider(int id, Collider collider)
        {
            if (collider == null)
            {
                GameFramework.Log.Error($"SteerGroup.UpdateTrapShape Error! collider is null id:{id}");
                return;
            }
            UpdateTrapCollider(id, collider.transform.position.x, collider.transform.position.z, collider.transform.rotation.eulerAngles.y);
        }

        public void UpdateTrapCollider(int id, float x, float z, float angle)
        {
            var collider = FindTrapCollider(id);
            if (collider != null)
            {
                collider.shape.pos = new Vector2(x, z);
                collider.shape.angle = angle;
            }
            else
            {
                GameFramework.Log.Error($"SteerGroup.UpdateTrapShape Error! unregistered id:{id}");
            }
        }

        public void RemoveTrapCollider(int id)
        {
            for (int i = 0; i < _trapColliders.Count; i++)
            {
                if (_trapColliders[i].id == id)
                {
                    _trapColliders.RemoveAt(i);
                    return;
                }
            }
        }
        
        public int Spawn(int amount, int point, float radius)
        {
            var task = new SpawnTask(amount, point, radius);
            _spawnTasks.Add(task);
            return task.id;
        }

        void __Spawn(int taskId, int amount, int point, float radius, float firstTickTimeFix)
        {
            for (int i = 0; i < amount; i++)
            {
                Vector2 pos0 = GroupCircle.pos;
                Vector2 randDir = Quaternion.Euler(0, 0, UnityEngine.Random.Range(0, 360)) * Vector3.up;
                pos0 += randDir * UnityEngine.Random.Range(0f, GroupCircle.radius * 0.5f);
                var unit = new SteerUnit(++__unit_inc_id, new Vector3(pos0.x, _currY, pos0.y), point, radius, firstTickTimeFix);
                _units.Add(unit);
                OnUnitSpawn?.Invoke(taskId, unit);
            }
        }

        public void RemoveUnit(SteerUnit unit)
        {
            int idx = _units.IndexOf(unit);
            if (idx < 0 || idx >= _units.Count)
            {
                // GameFramework.Log.Error($"SteerGroup.DestroyUnit Error! unit not found");
                return;
            }
            _units.RemoveAt(idx);
            OnUnitRemoved?.Invoke(unit.id);
        }

        public void Vibrate()
        {
            Handheld.Vibrate();
        }

        void Update()
        {
            if (DisableLogic) return;

            float dt = Time.deltaTime;
            _tickCD += dt;
            // Debug.LogError($"Update:{dt}->{_tickCD}");

            // deal ticks
            while (_tickCD >= TICK_INTERVAL)
            {
                _tickCD -= TICK_INTERVAL;
                Tick(TICK_INTERVAL);
            }
            // 提前预支一帧
            if (_tickCD > 0f)
            {
                Tick(TICK_INTERVAL);
                _tickCD -= TICK_INTERVAL;
            }

            // deal spawn tasks
            float aheadTime = -_tickCD;
            for (int i = _spawnTasks.Count - 1; i >= 0; i--)
            {
                var task = _spawnTasks[i];
                int amount = task.GetSpawnAmount(dt, spawnPerSecond);
                __Spawn(task.id, amount, task.point, task.radius, aheadTime);
                if (task.amount <= 0) _spawnTasks.RemoveAt(i);
                else _spawnTasks[i] = task;
            }

            // sync display
            _display.Update(dt);
            transform.position = _display.Position;

            // sync units & group point
            int lastPoint = GroupPoint;
            GroupPoint = 0;
            for (int i = 0; i < _units.Count; i++)
            {
                _units[i].Update(dt);
                GroupPoint += _units[i].point;
            }
            if (lastPoint != GroupPoint)
            {
                OnGroupPointChanged?.Invoke(GroupPoint);
            }
        }

        int __SortUnits(SteerUnit a, SteerUnit b)
        {
            if (a == null || b == null) return 0;
            if (b.initPoint == a.initPoint)
            {
                if (a.sqrMag2Center == b.sqrMag2Center)
                {
                    if (a.id == b.id) return 0;
                    else return a.id > b.id ? 1 : -1;
                }
                else return a.sqrMag2Center > b.sqrMag2Center ? 1 : -1;
            }
            else return b.initPoint > a.initPoint ? 1 : -1;
        }

        void Tick(float dt)
        {
            _tickTimer += dt;

            // group motion
            GroupMotion(dt);
            _display.Push(new Vector3(GroupCircle.pos.x, _currY, GroupCircle.pos.y), _tickTimer);

            CalcBound();

            // detect traps
            TrapDetection();
            if (EngageGroup != null && EngageGroup.GroupCircle.Overlap(GroupCircle))
            {
                EngageDetection();
            }

            _units.Sort(__SortUnits);

            if (RepSwitch) Repulsion();
            if (AttSwitch) Attraction();

            foreach (var unit in _units)
            {
                unit.Move(unit.velocity);
                unit.velocity = Vector2.zero;
            }

            CalcBound();

            foreach (var unit in _units)
            {
                unit.Tick(dt, _currY);
            }
        }

        void GroupMotion(float dt)
        {
            Vector2 moveVec = _velocity * dt;
            GroupCircle.pos += moveVec;
            foreach (var unit in _units)
            {
                if (unit.IsDead) continue;
                unit.Move(moveVec);
            }
        }

        void CalcBound()
        {
            float[] boundary = new float[4];
            float maxSqrMag = -1f;
            float farestUnitR = 0f;
            foreach (var unit in _units)
            {
                if (unit.IsDead) continue;

                Vector2 vec = unit.pos - GroupCircle.pos;
                float sqrMag = vec.sqrMagnitude;
                if (sqrMag > maxSqrMag)
                {
                    maxSqrMag = sqrMag;
                    farestUnitR = unit.shape.radius;
                }
                if (vec.x - unit.shape.radius < boundary[0]) boundary[0] = vec.x - unit.shape.radius;
                if (vec.x + unit.shape.radius > boundary[1]) boundary[1] = vec.x + unit.shape.radius;
                if (vec.y + unit.shape.radius < boundary[2]) boundary[2] = vec.y + unit.shape.radius;
                if (vec.y - unit.shape.radius > boundary[3]) boundary[3] = vec.y - unit.shape.radius;

                unit.sqrMag2Center = sqrMag;
            }
            maxSqrMag = Mathf.Max(maxSqrMag, 0f);
            GroupCircle.radius = Mathf.Sqrt(maxSqrMag) + farestUnitR;
            GroupBoundLeft = boundary[0];
            GroupBoundRight = boundary[1];
            GroupBoundTop = boundary[2];
            GroupBoundBottom = boundary[3];
        }

        void Repulsion()
        {
            for (int i = 0; i < _units.Count; i++)
            {
                SteerUnit curr = _units[i];
                if (curr.IsDead) continue;
                for (int j = i + 1; j < _units.Count; j++)
                {
                    SteerUnit other = _units[j];
                    if (other.IsDead) continue;

                    var vec = curr.pos - other.pos;
                    var sqrMagnitude = vec.sqrMagnitude;

                    if (sqrMagnitude < Mathf.Pow(curr.shape.radius + other.shape.radius, 2))
                    {
                        //var dir = vec.normalized;
                        //var mag = vec.magnitude;
                        var mag = (float)Math.Sqrt(sqrMagnitude);
                        var dir = mag > 1e-05 ? vec / mag : Vector2.zero;
                        if (dir == Vector2.zero)
                        {
                            dir = Quaternion.Euler(0, 0, UnityEngine.Random.Range(0, 360)) * Vector3.up;
                        }

                        // curr.velocity += dir * (curr.shape.radius + other.shape.radius - mag) * repForceFactor;
                        other.velocity -= dir * (curr.shape.radius + other.shape.radius - mag) * repForceFactor;
                    }
                }
            }
        }

        void Attraction()
        {
            for (int i = 0; i < _units.Count; i++)
            {
                SteerUnit curr = _units[i];
                if (curr.IsDead) continue;

                var vec = GroupCircle.pos - curr.pos;
                var dir = vec.normalized;
                var sqrMag = vec.sqrMagnitude;
                curr.velocity += dir * Mathf.Min(sqrMag, 1) * attForceFactor;
            }
        }

        void TrapDetection()
        {
            for (int j = _trapColliders.Count - 1; j >= 0; j--)
            {
                var collider = _trapColliders[j];
                if (!collider.shape.Overlap(GroupCircle)) continue;
                for (int i = _units.Count - 1; i >= 0; i--)
                {
                    var unit = _units[i];
                    if (unit.IsDead) continue;
                    if (collider.shape.Overlap(unit.shape))
                    {
                        // unit.Kill();
                        // RemoveUnit(unit);
                        OnCollideTrap?.Invoke(collider.id, unit.id);
                    }
                }
            }
        }

        void EngageDetection()
        {
            for (int i = _units.Count - 1; i >= 0; i--)
            {
                var unit = _units[i];
                if (unit.IsDead) continue;
                for (int j = EngageGroup.Units.Count - 1; j >= 0; j--)
                {
                    var other = EngageGroup.Units[j];
                    if (other.IsDead) continue;
                    if (unit.shape.Overlap(other.shape))
                    {
                        int unitPt = unit.point;
                        int otherPt = other.point;
                        unit.point -= otherPt;
                        other.point -= unitPt;
                        if (other.point <= 0)
                        {
                            other.Kill();
                            EngageGroup.RemoveUnit(other);
                        }
                        if (unit.point <= 0)
                        {
                            unit.Kill();
                            RemoveUnit(unit);
                            break;
                        }
                    }
                }
            }
        }                
    }
}
