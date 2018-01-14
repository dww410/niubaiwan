--region *.lua
--Date
--此文件由[BabeLua]插件自动生成
local Chinese=Chinese or{}

Chinese.TEXT1="商店"
Chinese.TEXT2="卡牌"
Chinese.TEXT3="对战"
Chinese.TEXT4="公会"
Chinese.TEXT5="休闲"
Chinese.TEXT6="稀有度:"
Chinese.TEXT7="类型:"
Chinese.TEXT8="约战"
Chinese.TEXT15="解锁卡牌:"

Chinese.TEXT20="星陨原矿"
Chinese.TEXT21="黄金原矿"
Chinese.TEXT22="龙血原矿"

Chinese.TEXT31="一小袋金币"
Chinese.TEXT32="一小桶金币"
Chinese.TEXT33="一小箱金币"
Chinese.TEXT41="1000"
Chinese.TEXT42="10000"
Chinese.TEXT43="100000"

Chinese.TEXT44="解锁"
Chinese.TEXT45="升级后可以获得"


Chinese.PLAYERNOUNION="无公会"

Chinese.PLAYERINFTIP1={"玩家等级","                 表明了领主塔与护卫塔的战斗力.\n\n收集卡牌和向公会成员捐赠卡牌都可以获得经验值.",260,85,-50,0.25,cc.c3b(0,184,255)}
Chinese.PLAYERINFTIP2={"奖杯","          代表了您的战绩.\n\n对战胜利您将获得奖杯,但是您也会因战败而丢失奖杯.",195,65,-20,0.475,cc.c3b(255,164,0)}
Chinese.PLAYERINFTIP3={"金币","          可以用来升级和购买卡牌.\n\n您可以通过原矿或者向公会成员捐赠卡牌来获得金币.\n\n金币最大数额为5000000枚.",230,105,20,0.6,cc.c3b(255,164,0)}
Chinese.PLAYERINFTIP4={"龙晶","          可以用来购买金币或加速打开原矿.",200,35,50,0.82,cc.c3b(0,184,255)}

Chinese.PLAYERINFO1="玩家信息"
Chinese.PLAYERINFO2="领主与护卫"
Chinese.PLAYERINFO3="生命值"
Chinese.PLAYERINFO4="射程"
Chinese.PLAYERINFO5="攻击速度"
Chinese.PLAYERINFO6="伤害值"
Chinese.PLAYERINFO7="数据统计"
Chinese.PLAYERINFO8="获胜次数"
Chinese.PLAYERINFO9="胜率"
Chinese.PLAYERINF10="三战旗胜利次数"
Chinese.PLAYERINF11="已收集卡牌"
Chinese.PLAYERINF12="最高奖杯数"
Chinese.PLAYERINF13="捐赠总量"
Chinese.PLAYERINF14="光环"
Chinese.PLAYERINF15="出战卡牌"
Chinese.PLAYERINF16="平均花费龙血："
Chinese.PLAYERINF17="头像"
Chinese.PLAYERINF18="复制到出战卡组"

Chinese.PLAYERPOSTION1="会长"
Chinese.PLAYERPOSTION2="成员"
Chinese.PLAYERRANKNAME="阶竞技场"
Chinese.PLAYERRANKNAME2="新手训练营"

Chinese.RANGETYPE1="近战"
Chinese.RANGETYPE2="远程"
Chinese.SPEED="秒"
Chinese.JI="级"

Chinese.NUM1="一"
Chinese.NUM2="二"
Chinese.NUM3="三"
Chinese.NUM4="四"
Chinese.NUM5="五"
Chinese.NUM6="六"
Chinese.NUM7="七"
Chinese.NUM8="八"
Chinese.NUM9="九"
Chinese.NUM10="十"


Chinese.TIP1="无法复制该卡组,您还缺少"
Chinese.TIP2="种卡牌"
Chinese.TIP3="每隔4小时可获得一个黑铁原矿"
Chinese.TIP4="该卡组已复制到您的出战卡组"
Chinese.TIP5="复制卡组失败"
Chinese.TIP6="条件未满足 无法领取"
Chinese.TIP7="金币不够"
Chinese.TIP8="解锁等级 新手训练场"
Chinese.TIP9="解锁等级 1阶竞技场"
Chinese.TIP10="解锁等级 2阶竞技场"
Chinese.TIP11="解锁等级 3阶竞技场"
Chinese.TIP12="解锁等级 4阶竞技场"
Chinese.TIP13="解锁等级 5阶竞技场"
Chinese.TIP14="解锁等级 6阶竞技场"
Chinese.TIP15="解锁等级 7阶竞技场"
Chinese.TIP16="解锁等级 8阶竞技场"
Chinese.TIP17="尚未收集"
Chinese.TIP18="需要达到"
Chinese.TIP19="阶竞技场才能解锁"
Chinese.TIP20="龙晶不够"
Chinese.TIP21="在"
Chinese.TIP22="及更高级别的竞技场可收集"
Chinese.TIP23="每隔24小时可获得一个水晶原矿"
Chinese.TIP24="集齐10个战旗可获得一个水晶原矿"

Chinese.kechang = "客场"
Chinese.zhuchang = "主场"
Chinese.winner = "获胜者"
Chinese.sure = "确定"
Chinese.NoGongHui = "无公会"
Chinese.FightAgain = "再试"
Chinese.FightQuit = "退出"
Chinese.ReplayQuit = "确定要退出录像吗"
Chinese.ReplayAgain = "重播"
Chinese.TrainQuit = "确定要退出训练场吗"


Chinese.BUTTONTEXT1="关闭"
Chinese.BUTTONTEXT2="对战日志"
Chinese.BUTTONTEXT3="收藏夹"
Chinese.BUTTONTEXT4="邮件"
Chinese.BUTTONTEXT5="收藏"
Chinese.BUTTONTEXT6="分享"
Chinese.BUTTONTEXT7="观看"
Chinese.BUTTONTEXT8="已收藏"
Chinese.BUTTONTEXT9="升级"
Chinese.BUTTONTEXT10="查看"
Chinese.BUTTONTEXT11="使用"
Chinese.BUTTONTEXT12="个人"
Chinese.BUTTONTEXT13="公会"
Chinese.BUTTONTEXT14="好友"
Chinese.BUTTONTEXT15="推荐"
Chinese.BUTTONTEXT16="创建"
Chinese.BUTTONTEXT17="搜索"
Chinese.BUTTONTEXT18="聊天"


Chinese.SHOPTITLE1="卡牌商店"
Chinese.SHOPTITLE2="龙晶原矿"
Chinese.SHOPTITLE3="金币"
Chinese.SHOPTITLE4="龙晶"

Chinese.CARDLISTTITLE1="光环"
Chinese.CARDLISTTITLE2="当前出战卡牌"
Chinese.CARDLISTTITLE3="未出战卡牌"
Chinese.CARDLISTTITLE4="未收集卡牌"

Chinese.CARDTYPE1="普通"
Chinese.CARDTYPE2="稀有"
Chinese.CARDTYPE3="史诗"
Chinese.CARDLEIXINGTYPE1="部队"
Chinese.CARDLEIXINGTYPE2="法术"
Chinese.CARDLEIXINGTYPE3="建筑"
Chinese.CARDLEIXINGTYPE4="光环"


Chinese.ChatText1="祝你好运"
Chinese.ChatText2="厉害"
Chinese.ChatText3="Wow"
Chinese.ChatText4="承让"
Chinese.ChatText5="Good Game"
Chinese.ChatText6="Oops"

Chinese.FightTipsNoEnoughWater="龙血不足,不能丢牌"
Chinese.FightTipsCannotPutCard="此区域不能丢牌"

Chinese.FightTipsFullChestPos ="原矿栏位已满"
Chinese.FightTipsNoGold = "金币已达上限"

Chinese.TEXTMAIL1="版本号:"


Chinese.MemberType1="会长"
Chinese.MemberType2="成员"

return Chinese
--endregion
