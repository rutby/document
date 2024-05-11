local Consts = {}

Consts.CAMERA_Y_OFFSET = 18        -- 镜头Y轴偏移
Consts.CAMERA_Z_OFFSET = -12       -- 镜头Z轴偏移
Consts.CAMERA_X_ANGLE = 42         -- 镜头X轴仰角
Consts.SCENE_VIEW_OFFSET = Vector3.New(0, 0, 60)
Consts.FOLLOW_VIEW_OFFSET = Vector3.New(0, Consts.CAMERA_Y_OFFSET, Consts.CAMERA_Z_OFFSET)
Consts.SCENE_CHUNK_SIZE = 66

Consts.ENGAGING_SPEED = 6           -- 两群接触后相对移动速度

Consts.DEFAULT_REP_FACTOR = 0.5        -- 默认引力因数
Consts.DEFAULT_ATT_FACTOR = 0.02       -- 默认引力因数

-- Consts.FIRE_RANGE = 50              -- 射程
-- Consts.FIRE_CD = 1                  -- 射击CD
-- Consts.UNIT_FIRE_DELAY = 0.5        -- 单位射击延迟，实际延迟为 0 ~ (Consts.FIRE_CD * Consts.UNIT_FIRE_DELAY) 之间随机
-- Consts.BULLETS_LIMIT = 80           -- 同屏子弹数限制

Consts.VIBRATE_CD = 1               -- 振动CD

Consts.END_ZOMBIE_LIMIT = 50         -- 排队枪毙关底僵尸同屏数量上限
Consts.END_UNITS_PER_LINE = 12       -- 排队枪毙关底一排士兵数量
Consts.END_UNITS_LINE_LIMIT = 13     -- 排队枪毙关底最大排数


return Consts