using System;

[Flags]
public enum WayPointFlag
{
    None = 0,
    City = 1 << 0,
    Digging = 1 << 1,
    Entrance = 1 << 2,
    Exit = 1 << 3,
    Hunting = 1 << 4,
    Special = 1 << 5,
    Invade = 1 << 6,
    Zombie = 1 << 7,
    SafeHide = 1 << 8,
    ZombieSpawn = 1 << 9,
    Chopping = 1 << 10,
    Center = 1 << 11,
    Outside = 1 << 12,
    Inside = 1 << 13,
    All = 0x7FFFFFFF,
}