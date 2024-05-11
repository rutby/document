


local str = [[
syntax = "proto3";
package protobuf;
option java_package = "net.im30.aps.model.protobuf";
import "Wrappers.proto";

//邮件通用内容生成
message Mail {
  MailHeader header = 1;
  MailBody body = 2;
  MailCustom custom = 3;
}

message MailHeader {
  //标题
  Message title = 1;
  //副标题
  Message subTitle = 2;
}

message MailBody {
  //正文
  Message content = 1;
  //充值
  Pay pay = 2;
  //奖励
  Reward reward = 3;
  //玩家信息
  UserInfo userInfo = 4;
  //联盟信息
  AllianceInfo allianceInfo = 5;
  //联盟邀请迁城邮件
  AllianceInviteMove allianceInviteMove = 6;
  //激活码
  Activation activation = 7;
}

message MailCustom {
  //是否可以回复
  int32 reply = 1;
  //是否可以分享
  int32 share = 2;
  //是否可以点赞
  int32 like = 3;
  //全服公告id
  string activity = 4;
  //表示邮件已处理，如邀请入盟
  int32 deal = 5;
}

message Message {
  DialogColor color = 1;
  //加粗
  bool bold = 2;
  oneof data {
    //文本
    string text = 101;
    //多语言
    Dialog dialog = 102;
    //坐标
    PointInfo point = 103;
    //玩家信息
    User user = 104;
    //联盟信息
    Alliance alliance = 105;
    //怪物信息
    Monster monster = 106;
    //百分比
    Percent percent = 107;
    //侦察目标
    Scout scout = 108;
    //日期
    DateTime dateTime = 109;
    //联盟世界城信息
    WorldAllianceCity worldAllianceCity = 110;
    //跳转链接
    Url url = 111;
    //带参数的文本 GM用
    TextWithParams textWithParams = 112;
  }
}

enum DialogColor {
  DEFAULT_COLOR = 0;
  BLACK = 1;
  WHITE = 2;
  RED = 3;
  GREEN = 4;
  YELLOW = 5;
  BLUE = 6;
}

message Dialog {
  string id = 1;
  repeated Message params = 2;
}

message Pay {
  google.protobuf.Int32Value gold = 1;
  google.protobuf.Int32Value choose = 2;
}

message Reward {
  //reward配置中的id，原先为gold,0,100|goods,209302,1
  string reward = 1;
  //大本等级不低于此才能领奖
  google.protobuf.Int32Value rewardLevel = 2;
  //需要更新到指定版本才能领奖
  string rewardVersion = 3;
  //奖励来源，统计用
  google.protobuf.Int32Value rewardModule = 4;
  //奖励列表
  repeated RewardInfo rewardInfo = 5;
}

message RewardInfo {
  google.protobuf.Int32Value type = 1;
  google.protobuf.StringValue id = 2;
  google.protobuf.Int64Value num = 3;
}

message PointInfo {
  google.protobuf.Int32Value server = 1;
  google.protobuf.Int32Value x = 2;
  google.protobuf.Int32Value y = 3;
}

message User {
  string abbr = 1;
  string name = 2;
  string uid = 3;
}

message Alliance {
  string abbr = 1;
  string name = 2;
}

message Monster {
  string id = 1;
}

message Percent {
  google.protobuf.Int32Value intValue = 1;
  google.protobuf.DoubleValue doubleValue = 2;
}

message Scout {
  enum Target {
    DEFAULT = 0;
    BASE = 1;
    BUILDING = 2;
    ARMY = 3;
    ALLIANCE_CITY = 4;
  }
  Target target = 1;
  string targetId = 2;
}

message DateTime {
  google.protobuf.Int64Value milliseconds = 1;
  google.protobuf.Int32Value seconds = 2;
}

message WorldAllianceCity {
  int32 id = 1;
  string cityName = 2;
}

message Url {
  string href = 1;
  string text = 2;
}

message TextWithParams {
  string text = 1;
  repeated Message params = 2;
}

//额外邮件信息
message UserInfo {
  string uid = 1;
  string name = 2;
  string pic = 3;
  google.protobuf.Int32Value picVer = 4;
}

message AllianceInfo {
  string uid = 1;
  string name = 2;
  string abbr = 3;
  string lang = 4;
  string icon = 5;
  google.protobuf.Int32Value curMember = 6;
  google.protobuf.Int32Value maxMember = 7;
  google.protobuf.Int64Value fightPower = 8;
  string leaderName = 9;
}

message AllianceInviteMove {
  string inviteeUid = 1;
  string inviteeName = 2;
  string inviterUid = 3;
  string inviterName = 4;
  google.protobuf.Int32Value targetPoint = 5;
  google.protobuf.Int32Value serverId = 6;
}

message Activation {
  string code = 1;
}

//特殊邮件，侦察
message ScoutReport {
  enum TargetType {
      DEFAULT = 0;
      MAIN_BUILDING = 1;
      STORAGE = 2;
      COLLECT_BUILDING = 3;
      TOWER = 4;
      BUILDING = 5;
      MARCH = 6;
      ALLIANCE_CITY = 7;
  }
  TargetType targetType = 101;
  //侦察目标
  ScoutUser targetUser = 1;
  ScoutUserWall userWall = 2;
  ScoutResource resource = 3;
  ScoutArmy army = 4;
  ScoutTower tower = 5;
  //侦察联盟城
  ScoutAllianceCity targetAllianceCity = 6;
  ScoutAllianceCityWall allianceCityWall = 7;
}

enum ScoutVisible {
  DEFAULT = 0;
  //目标此类型可用，且满足可见条件，显示数据
  ENABLE = 1;
  //目标此类型可用，不满足可见条件，提示特殊文字
  DISABLE = 2;
  //目标此类型不可用，隐藏
  NOT_MATCH = 3;
  //目标此类型可用，且满足可见条件，但是没有数据
  ENABLE_EMPTY = 4;
}

message ScoutUser {
  string abbr = 1;
  string name = 2;
  string pic = 3;
  google.protobuf.Int32Value picVer = 4;
  PointInfo point = 5;
  string uid = 6;
}

message ScoutUserWall {
  google.protobuf.Int32Value hp = 1;
  google.protobuf.Int32Value hpMax = 2;
  google.protobuf.Int32Value visible = 3;
  string buildingId = 4;
}

message ScoutAllianceCity {
  google.protobuf.Int32Value city_id = 1;
  PointInfo point = 2;
  string abbr = 3;
  string name = 4;
  string cityName = 5;
}

message ScoutAllianceCityWall {
  google.protobuf.Int32Value hp = 1;
  google.protobuf.Int32Value hpMax = 2;
  google.protobuf.Int32Value visible = 3;
}

message ScoutResource {
  repeated Resource data = 1;
  google.protobuf.Int32Value visible = 2;
}

message Resource {
  google.protobuf.Int32Value type = 1;
  google.protobuf.Int32Value value = 2;
}

message ScoutArmy {
  //目标
  ScoutTargetArmyUnit target = 1;
  //援军
  ScoutHelpArmy help = 2;
  //目标总数
  ScoutTargetArmyTotal targetTotal = 3;
}

message ScoutTargetArmyUnit {
  repeated ScoutFormation formation = 1;
  google.protobuf.Int32Value visible = 2;
}

message ScoutTargetArmyTotal {
  google.protobuf.Int32Value visible = 1;
  google.protobuf.Int64Value total = 2;
}

message ScoutHelpArmy {
  repeated ScoutHelpArmyUnit formation = 1;
  google.protobuf.Int32Value visible = 2;
}

message ScoutHelpArmyUnit {
  ScoutFormation formation = 1;
  User user = 2;
}

message ScoutFormation {
  //兵力总量
  google.protobuf.Int32Value soldierTotal = 1;
  //英雄列表
  repeated ScoutHero hero = 2;
  //带兵列表
  repeated ScoutSoldier soldier = 3;
}

message ScoutHero {
  //英雄id
  google.protobuf.Int32Value heroId = 1;
  //英雄等级 未空表示不显示
  google.protobuf.Int32Value heroLevel = 2;
  //英雄品质
  google.protobuf.Int32Value heroQuality = 3;
}

message ScoutSoldier {
  //兵种id 为空表示分类汇总，用兵种分类
  string armsId = 1;
  //兵种分类
  google.protobuf.Int32Value type = 2;
  //兵种数量
  google.protobuf.Int32Value total = 3;
}

//炮台建筑
message ScoutTower {
  repeated ScoutTowerUnit tower = 1;
  google.protobuf.Int32Value visible = 2;
}

message ScoutTowerUnit {
  google.protobuf.Int32Value level = 1;
  google.protobuf.Int32Value attack = 2;
  google.protobuf.Int32Value hp = 3;
  google.protobuf.Int32Value hpMax = 4;
}




]]

return str