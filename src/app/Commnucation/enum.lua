--斗地主返回消息
cc.exports.Enum = {
    ERROR_CLIENT = 10000, --错误码

    HEART_SERVER = 10001, --心跳
    HEART_CLIENT = 10002,

    LOGIN_SERVER = 10003, --登录
    LOGIN_CLIENT = 10004,

    GET_ROOM_SERVER = 10005, --获取房间信息
    GET_ROOM_CLIENT = 10006, 

    REPEAT_LOGIN_CLIENT = 10007, --重复登录 
     
    NOTICE_SERVER = 10008, --跑马灯公告
    NOTICE_CLIENT = 10009, 

    ROOMS_SERVER = 10010,--房间列表
    ROOMS_CLIENT = 10011,--房间列表

    RECHARGE_SERVER = 10012,--充值列表
    RECHARGE_CLIENT = 10013,--充值列表

    INVITE_SERVER = 10014,--绑定邀请码
    INVITE_CLIENT = 10015,--绑定邀请码

    SYSTEM_SERVER = 10016,--系统信息
    SYSTEM_CLIENT = 10017,--系统信息

    GAME_RECORD_SERVER = 10018,--游戏记录
    GAME_RECORD_CLIENT = 10019,--游戏记录

    RECEIVE_GOLD_SERVER = 10020,--领取金币
    RECEIVE_GOLD_CLIENT = 10021,--领取金币

    RECEIVE_BENEFIT_SERVER = 10022,--领取救济金
    RECEIVE_BENEFIT_CLIENT = 10023,--领取救济金

    USER_INFO_SERVER = 10024,--个人信息
    USER_INFO_CLIENT = 10025,--个人信息

    RECHARGE_PAY_SERVER = 10026,--请求微信充值
    RECHARGE_PAY_CLIENT = 10027,--返回微信充值信息
    RECHARGE_PAY_RESUILT_CLIENT = 10028,--返回充值结果

    INTO_ROOM_SERVER = 20001,--加入房间
    INTO_ROOM_CLIENT = 20002,

    ADD_ROOM_CLIENT = 20003,--有人进入

    SEAT_ROOM_SERVER = 20004,--坐下

    START_SERVER = 20005,--开始
    START_CLIENT = 20006,

    GRAB_SERVER = 20007,--抢庄
    GRAB_CLIENT = 20008,

    PLAY_SERVER = 20009,--下注
    PLAY_CLIENT = 20010,

    SET_BANKER_CLIENT = 20011,--确定庄家

    DEAL_CARD_CLIENT = 20012,--发牌

    OPEN_CARD_SERVER = 20013,--亮牌
    OPEN_CARD_CLIENT = 20014,--亮牌

    RESULT_CLIENT = 20015,--开始比牌

    READY_SERVER = 20016,--准备
    READY_CLIENT = 20017,--准备

    EXIT_SERVER = 20018,--退出
    EXIT_CLIENT = 20019,--退出

    DELETE_SERVER = 20020,--请求解散
    DELETE_CLIENT = 20021,--请求解散

    DELETE_CONFIRM_SERVER = 20022,--请求解散
    DELETE_CONFIRM_CLIENT = 20023,--请求解散

    DELETED_CLIENT = 20024,--解散成功

    IMG_TEXT_SERVER = 20025,--表情文字
    IMG_TEXT_CLIENT = 20026,--表情文字

    INTERACTION_SERVER = 20027,--互动
    INTERACTION_CLIENT = 20028,--互动

    VOICE_SERVER = 20029,--语音
    VOICE_CLIENT = 20030,--语音

    COMPLETE_SERVER = 20031,--完成
    COMPLETE_CLIENT = 20032,--完成

    OVER_CLIENT = 20033,--游戏结束
}

--错误码
cc.exports.ErrorCode ={
    ERROR_UNKNOWN=10000,--("未知错误", 10000),
    NO_FOUND=10001,--("数据不存在", 10001),
    SUCCESS=10002,--("处理成功", 10002),
    FAILURE=10003,--("处理失败", 10003),
    ERROR_DATA=10004,--("数据异常", 10004),

    AUTHENTICATION_FAILURE=20000,--("鉴权失败", 20000),
    ILLEGAL_ARGUMENT=20001,--("不合法参数", 20001),

    ERROR_DATA_NOT_FOUND=30001,--("相关数据没有找到", 30001),
    ERROR_ACCOUNT_LOCKED=30002,--("账户被禁用", 30002),
    ERROR_NO_LOGIN=30003,--("没有登录", 30003),
    ERROR_MONEY_NOT_ENOUGH=30004,--("您没有足够的钻石", 30004),
    ERROR_NOT_ALLOW=30005,--("不允许的操作", 30005),
    ERROR_ACCOUNT_EXCEPTION=30006,--("账号异常", 30006),
    ERROR_MAINTENANCE=30007,--("服务器维护中", 30007),
    ERROR_INVITATIONMSG=30008,--("该邀请码已经使用", 30007),
    ERROR_INVITATIONONMSG=30009,--("已绑定邀请码", 30007),
    ERROR_COUNT_NOT_ENOUGH=30010,--("领取次数不足", 30010),
    ERROR_ROOM_NOT_EXISTS=40008,--("房间不存在", 40008),
    ERROR_FULL=40009,--("房间人数已满", 40009),
    ERROR_DELETE_FREQUENT=40010,--("不能频繁解散", 40010),
    ERROR_USER_LITTLE=40011,--("人数太少，不能开始游戏", 40011),
    ERROR_ALREADY_STARTED=40012,--("游戏开始后禁止加入", 40012);
    ERROR_ALREADY_INGAME=40013,--("您已经在其它游戏中，先去结束游戏再来", 40013);
    ERROR_NOT_JOINGAME=40014,--("游戏开始后禁止加入", 40014);
    ERROR_NOT_CODENOTFOUND=40015,--("邀请码不存在", 40015);
}

--花色
cc.exports.CardColor ={
    SPADE = 0, --黑桃
    HEART = 1, --红桃
    PLUM = 2, --梅花
    BLOCK = 3, --方块
    LITTLE_JOKER = 4, --小王
    BIG_JOKER = 5, --大王
}
--性别
cc.exports.Sex ={
    MAN = 0,--男
    WOMAN = 1, --女
}
--游戏状态
cc.exports.GameStatus ={
    WAITING = 0, --等待其它玩家加入
    READYING = 1, --准备
    GRABING = 2, --抢庄
    PLAYING = 3, --下注
    OPENING = 4, --亮牌
    ENDING = 5, --比牌阶段
}

--游戏类型
cc.exports.GameType ={
    [1] = "牛牛上庄",
    [2] = "固定庄家",
    [3] = "自由抢庄",
    [4] = "明牌抢庄",
    [5] = "通比牛牛",
}

cc.exports.roomRule ={
    [1] = "房主支付",
    [2] = "AA支付",
}

cc.exports.FpRule ={
    [1] = "牛牛X4倍 牛九X3倍 牛八X2倍 牛七X2倍",
    [2] = "牛牛X3倍 牛九X2倍 牛八X2倍",
}

cc.exports.roomType ={
    [0] = "初级场",
    [1] = "中级场",
    [2] = "高级场",
    [3] = "至尊场",
}

cc.exports.roomBase ={
    [0] = "2",
    [1] = "4",
    [2] = "8",
    [3] = "16",
}
--游戏类型
cc.exports.NIUNIUTYPE ={
    [0] = "niuniu_cow_0.png", --没牛
    [1] = "niuniu_cow_1.png", --牛一
    [2] = "niuniu_cow_2.png", --牛二
    [3] = "niuniu_cow_3.png", --牛三
    [4] = "niuniu_cow_4.png", --牛四
    [5] = "niuniu_cow_5.png", --牛五
    [6] = "niuniu_cow_6.png", --牛六
    [7] = "niuniu_cow_7.png", --牛七
    [8] = "niuniu_cow_8.png", --牛八
    [9] = "niuniu_cow_9.png", --牛九
    [10] = "niuniu_cow_10.png", --牛牛
    [11] = "niuniu_cow_11.png", --对子牛
    [12] = "niuniu_cow_12.png", --顺子牛
    [13] = "niuniu_cow_13.png", --五花牛
    [14] = "niuniu_cow_14.png", --同花牛
    [15] = "niuniu_cow_15.png", --葫芦牛
    [16] = "niuniu_cow_16.png", --炸弹牛
    [17] = "niuniu_cow_17.png", --快乐牛
}

--游戏提示语
cc.exports.GAMETSY ={
    [1] = "大家一起浪起来", 
    [2] = "一点小钱，那都不是事",
    [3] = "不要走,决战到天亮", 
    [4] = "快点啊,等得花儿都谢了",
    [5] = "风水轮流转,底裤都输光了",
    [6] = "竟然被看穿了,你真厉害", 
    [7] = "看我通杀全场,这些钱都是我的", 
    [8] = "底牌亮出来,绝对吓死你", 
    [9] = "快点下注吧,一会儿就没机会了", 
    [10] = "我是庄家,谁敢挑战我", 
    [11] = "我早就看穿你的牌了", 
    [12] = "大牛吃小牛，不要伤心哟", 
    [13] = "你真是一个天生的演员", 
}

--玩家手牌牌型
cc.exports.CardType= {
    DANPAI=1, --"单牌"
    DUIZI=2, --"对子"
    SANZHANG=3, --"三张"
    SANDAIYI=4, --"三带一"
    SUNZI=5, --"顺子"
    SHUANGSHUN=6, --"双顺"
    SANSHUN=7, --"三顺"
    FEIJI=8, --"飞机"
    SIDAIER=9, --"四带二"
    ZHADAN=10, --"炸弹"
    HUOJIAN=11, --"火箭"
    ERROR=12 --"牌型错误"
}
