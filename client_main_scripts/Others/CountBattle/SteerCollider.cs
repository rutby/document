using System.Collections;
using System.Collections.Generic;
using UnityEngine;

namespace LW.CountBattle
{
    public class SteerCollider
    {
        public int id;
        public Shape shape;
        public SteerCollider(int id, Shape shape)
        {
            this.id = id;
            this.shape = shape;
        }
    }

    /**
    * 用于简单物理碰撞检测的2D形状
    */
    public abstract class Shape
    {
        public Vector2 pos;
        public float angle;
        public abstract Vector2 World2Local(Vector2 worldPoint);
        public abstract Vector2 Local2World(Vector2 worldPoint);
        public abstract bool Contains(Vector2 point);
        public abstract bool Overlap(Shape other);

        public Shape(Vector2 pos, float angle)
        {
            this.pos = pos;
            this.angle = angle;
        }

        public void SetPos(float x, float y)
        {
            pos.x = x;
            pos.y = y;
        }

        // 跟xLuaOptiUtils统一
        public void Get_pos(out float x, out float y)
        {
            x = pos.x;
            y = pos.y;
        }

        // 跟Get_pos成对
        public void Set_pos(float x, float y)
        {
            pos.x = x;
            pos.y = y;
        }
    }

    public class Circle : Shape
    {
        public float radius;

        public Circle(Vector2 pos, float angle, float radius) : base(pos, angle)
        {
            this.radius = radius;
        }

        public override Vector2 World2Local(Vector2 worldPoint)
        {
            return worldPoint - pos;
        }

        public override Vector2 Local2World(Vector2 localPoint)
        {
            return localPoint + pos;
        }

        public override bool Contains(Vector2 point)
        {
            return (point - pos).sqrMagnitude < radius * radius;
        }

        public override bool Overlap(Shape other)
        {
            if (other is Circle)
            {
                Circle otherCircle = other as Circle;
                return (otherCircle.pos - pos).sqrMagnitude < (otherCircle.radius + radius) * (otherCircle.radius + radius);
            }
            else if (other is Box)
            {
                Box otherBox = other as Box;
                Vector2 localPoint = otherBox.World2Local(pos);
                float x = localPoint.x;
                float y = localPoint.y;
                float dx = Mathf.Abs(x) - otherBox.size.x * 0.5f;
                if (dx >= radius) return false;
                float dy = Mathf.Abs(y) - otherBox.size.y * 0.5f;
                if (dy >= radius) return false;
                return true;
            }
            return false;
        }

        public override string ToString()
        {
            return "Circle: pos=" + pos + ", angle=" + angle + ", radius=" + radius;
        }
    }
    public class Box : Shape
    {
        public Vector2 size;

        public Box(Vector2 pos, float angle, Vector2 size) : base(pos, angle)
        {
            this.size = size;
        }

        public void Get_size(out float x, out float y)
        {
            x = size.x;
            y = size.y;
        }

        public void Set_size(float x, float y)
        {
            size.x = x;
            size.y = y;
        }

        public Vector2[] GetLocalCorners()
        {
            Vector2[] corners = new Vector2[4];
            corners[0] = new Vector2(-size.x * 0.5f, -size.y * 0.5f);
            corners[1] = new Vector2(size.x * 0.5f, -size.y * 0.5f);
            corners[2] = new Vector2(size.x * 0.5f, size.y * 0.5f);
            corners[3] = new Vector2(-size.x * 0.5f, size.y * 0.5f);
            return corners;
        }

        public Vector2[] GetWorldCorners()
        {
            Vector2[] corners = GetLocalCorners();
            for (int i = 0; i < corners.Length; i++)
            {
                corners[i] = Local2World(corners[i]);
            }
            return corners;
        }

        public override Vector2 World2Local(Vector2 worldPoint)
        {
            Vector3 worldPoint3 = new Vector3(worldPoint.x, 0, worldPoint.y);
            Vector3 localPoint3 = Quaternion.Euler(0, -angle, 0) * (worldPoint3 - new Vector3(pos.x, 0, pos.y));
            Vector2 localPoint = new Vector2(localPoint3.x, localPoint3.z);
            return localPoint;
        }

        public override Vector2 Local2World(Vector2 localPoint)
        {
            Vector3 localPoint3 = new Vector3(localPoint.x, 0, localPoint.y);
            Vector3 worldPoint3 = Quaternion.Euler(0, angle, 0) * localPoint3 + new Vector3(pos.x, 0, pos.y);
            Vector2 worldPoint = new Vector2(worldPoint3.x, worldPoint3.z);
            return worldPoint;
        }

        public override bool Contains(Vector2 point)
        {
            Vector2 localPoint = World2Local(point);
            float x = localPoint.x;
            float y = localPoint.y;
            return Mathf.Abs(x) < size.x * 0.5f && Mathf.Abs(y) < size.y * 0.5f;
        }

        public override bool Overlap(Shape other)
        {
            if (other is Circle)
            {
                Circle otherCircle = other as Circle;
                return otherCircle.Overlap(this);
            }
            else if (other is Box)
            {
                Box otherBox = other as Box;
                Vector2[] worldCornersA = GetWorldCorners();
                Vector2[] worldCornersB = otherBox.GetWorldCorners();
                Vector2 axis1 = worldCornersA[1] - worldCornersA[0];
                if (!OverlapOnAxis(worldCornersA, worldCornersB, axis1)) return false;
                Vector2 axis2 = worldCornersA[3] - worldCornersA[0];
                if (!OverlapOnAxis(worldCornersA, worldCornersB, axis2)) return false;
                Vector2 axis3 = worldCornersB[1] - worldCornersB[0];
                if (!OverlapOnAxis(worldCornersA, worldCornersB, axis3)) return false;
                Vector2 axis4 = worldCornersB[3] - worldCornersB[0];
                if (!OverlapOnAxis(worldCornersA, worldCornersB, axis4)) return false;
                return true;
            }
            return false;
        }

        private bool OverlapOnAxis(Vector2[] worldCornersA, Vector2[] worldCornersB, Vector2 axis)
        {
            float minA = float.MaxValue;
            float maxA = float.MinValue;
            float minB = float.MaxValue;
            float maxB = float.MinValue;
            for (int i = 0; i < worldCornersA.Length; i++)
            {
                float dot = Vector2.Dot(worldCornersA[i], axis);
                if (dot < minA) minA = dot;
                if (dot > maxA) maxA = dot;
            }
            for (int i = 0; i < worldCornersB.Length; i++)
            {
                float dot = Vector2.Dot(worldCornersB[i], axis);
                if (dot < minB) minB = dot;
                if (dot > maxB) maxB = dot;
            }
            if (minA > maxB) return false;
            if (maxA < minB) return false;
            return true;
        }

        public override string ToString()
        {
            return "Box: pos=" + pos + ", angle=" + angle + ", size=" + size;
        }
    }
}
