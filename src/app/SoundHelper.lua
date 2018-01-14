--region *.lua
--Date
--此文件由[BabeLua]插件自动生成
local SoundHelper = SoundHelper or {}
local targetPlatform = cc.Application:getInstance():getTargetPlatform()
if (cc.PLATFORM_OS_IPHONE == targetPlatform) or (cc.PLATFORM_OS_IPAD == targetPlatform) then
    MUSIC_FILE = ".mp3"
    EFFECT_FILE = ".mp3"
--elseif cc.PLATFORM_OS_ANDROID == targetPlatform then
--    MUSIC_FILE = ".ogg"
--    EFFECT_FILE = ".ogg"
else
    MUSIC_FILE = ".mp3"
    EFFECT_FILE = ".mp3"
end

function SoundHelper.preloadMusic(name)

    AudioEngine.preloadMusic(name .. MUSIC_FILE)
end

function SoundHelper.playMusic(name, loop)
    --    if cc.UserDefault:getInstance():getIntegerForKey("isMusic",100)~=0 then
    AudioEngine.playMusic(name .. MUSIC_FILE, loop)
    print(name .. MUSIC_FILE)
    --    end
end

function SoundHelper.pauseBackgroundMusic()
    AudioEngine.pauseBackgroundMusic()
end

function SoundHelper.resumeAllEffects()
    AudioEngine.resumeAllEffects()
end

function SoundHelper.resumeBackgroundMusic()
    AudioEngine.resumeBackgroundMusic()
end

function SoundHelper.isMusicPlaying()
    return AudioEngine.isMusicPlaying()
end

function SoundHelper.stopMusic()
    AudioEngine.stopMusic()
end

function SoundHelper.playEffect(name, loop)
    local data = nil
    if cc.UserDefault:getInstance():getIntegerForKey("isEffect", 100) ~= 0 then
        print(name .. EFFECT_FILE)
        data = AudioEngine.playEffect(name .. EFFECT_FILE, loop)
    end
    return data
end

function SoundHelper.stopEffect(name)
    if name ~= nil then
        AudioEngine.stopEffect(name .. EFFECT_FILE)
    end
end

function SoundHelper.preloadEffect(name)
    print(name)
    AudioEngine.preloadEffect(name .. EFFECT_FILE)
end

function SoundHelper.unloadEffect(name)
    AudioEngine.unloadEffect(name .. EFFECT_FILE)
end

function SoundHelper.pauseAllEffects()
    AudioEngine.pauseAllEffects()
end

function SoundHelper.setMusicVolume(value)
    local variable = value / 100

    print("设置音乐音量:" .. variable)
    AudioEngine.setMusicVolume(variable)
    --    if value == 0 then
    --        if AudioEngine.isMusicPlaying() then
    --            AudioEngine.pauseMusic()
    --        end
    --    else
    --         if AudioEngine.isMusicPlaying() == false then
    --            AudioEngine.resumeMusic()
    --        end
    --    end
end

function SoundHelper.setEffectsVolume(value)
    local variable = value / 100
    print("设置音效音量:" .. variable)
    AudioEngine.setEffectsVolume(variable)
    --    if value == 0 then
    --        AudioEngine.pauseAllEffects()
    --    end
end

function SoundHelper.playMusicSound(soundresIndex, sex, loop)
    local soundres = s_sound[soundresIndex]
    local resPath = "sound/"
    if soundres.sencetype == 1 then
    elseif soundres.sencetype == 2 then
    elseif soundres.sencetype == 3 then
        resPath = resPath .. "land/"
    elseif soundres.sencetype == 4 then
        resPath = resPath .. "ZhaJinHua/"
    elseif soundres.sencetype == 5 then
        resPath = resPath .. "NiuNiu/"
    end

    if soundres.effecttype == 1 then
        resPath = resPath .. "music/"
    elseif soundres.effecttype == 2 then
        if sex == 1 or sex == "男" then
            resPath = resPath .. "man/"
            print("男")
        else
            resPath = resPath .. "woman/"
            print("女")
        end
    end

    resPath = resPath .. soundres.resouce

    --print("要播放的音乐或者音效路径："..resPath)
    if soundres.restype == 1 then
        SoundHelper.preloadMusic(resPath)
        SoundHelper.playMusic(resPath, loop)
    elseif soundres.restype == 2 then
        SoundHelper.playEffect(resPath, loop)
    end
end

return SoundHelper

--endregion
