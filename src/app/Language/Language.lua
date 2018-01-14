--region *.lua
--Date
--此文件由[BabeLua]插件自动生成
local Language=Language or {}
Language.datas={
    'app.Language.Chinese',
    'app.Language.Chinese',
    'app.Language.Chinese',
    'app.Language.Chinese',
    'app.Language.Chinese',
}

function Language.GetStringText(Name)
    return require(Language.datas[GAME_LANGUAGE] )[Name]
end




return Language
--endregion
