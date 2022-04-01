local F = unpack(select(2, ...))

local animShake = {
    {-9, 7, -7, 12},
    {-5, 9, -9, 5},
    {-5, 7, -7, 5},
    {-9, 9, -9, 9},
    {-5, 7, -7, 5},
    {-9, 7, -9, 5}
}
local animShakeH = {-5, 5, -2, 5, -2, 5}

function F:FlashLoopFinished(requested)
    if not requested then
        self:Play()
    end
end

function F:RandomAnimShake(index)
    local s = animShake[index]
    return math.random(s[1], s[2]), math.random(s[3], s[4])
end

function F:SetUpAnimGroup(obj, Type, ...)
    if not Type then
        Type = 'Flash'
    end

    if string.sub(Type, 1, 5) == 'Flash' then
        obj.anim = obj:CreateAnimationGroup('Flash')
        obj.anim.fadein = obj.anim:CreateAnimation('ALPHA', 'FadeIn')
        obj.anim.fadein:SetFromAlpha(0)
        obj.anim.fadein:SetToAlpha(1)
        obj.anim.fadein:SetOrder(2)

        obj.anim.fadeout = obj.anim:CreateAnimation('ALPHA', 'FadeOut')
        obj.anim.fadeout:SetFromAlpha(1)
        obj.anim.fadeout:SetToAlpha(0)
        obj.anim.fadeout:SetOrder(1)

        if Type == 'FlashLoop' then
            obj.anim:SetScript('OnFinished', F.FlashLoopFinished)
        end
    elseif string.sub(Type, 1, 5) == 'Shake' then
        local shake = obj:CreateAnimationGroup(Type)
        shake:SetLooping('REPEAT')
        shake.path = shake:CreateAnimation('Path')

        if Type == 'Shake' then
            shake.path:SetDuration(0.7)
            obj.shake = shake
        elseif Type == 'ShakeH' then
            shake.path:SetDuration(2)
            obj.shakeh = shake
        end

        for i = 1, 6 do
            shake.path[i] = shake.path:CreateControlPoint()
            shake.path[i]:SetOrder(i)

            if Type == 'Shake' then
                shake.path[i]:SetOffset(F:RandomAnimShake(i))
            else
                shake.path[i]:SetOffset(animShakeH[i], 0)
            end
        end
    elseif Type == 'Elastic' then
        local width, height, duration, loop = ...
        obj.elastic = _G.CreateAnimationGroup(obj)

        for i = 1, 4 do
            local anim = obj.elastic:CreateAnimation(i < 3 and 'width' or 'height')
            anim:SetChange((i == 1 and width * 0.45) or (i == 2 and width) or (i == 3 and height * 0.45) or height)
            anim:SetEasing('inout-elastic')
            anim:SetDuration(duration)
            obj.elastic[i] = anim
        end

        obj.elastic[1]:SetScript('OnFinished', function(anim)
            anim:Stop()
            obj.elastic[2]:Play()
        end)
        obj.elastic[3]:SetScript('OnFinished', function(anim)
            anim:Stop()
            obj.elastic[4]:Play()
        end)
        obj.elastic[2]:SetScript('OnFinished', function(anim)
            anim:Stop()
            if loop then
                obj.elastic[1]:Play()
            end
        end)
        obj.elastic[4]:SetScript('OnFinished', function(anim)
            anim:Stop()
            if loop then
                obj.elastic[3]:Play()
            end
        end)
    elseif Type == 'Number' then
        local endingNumber, duration = ...
        obj.NumberAnimGroup = _G.CreateAnimationGroup(obj)
        obj.NumberAnim = obj.NumberAnimGroup:CreateAnimation('number')
        obj.NumberAnim:SetChange(endingNumber)
        obj.NumberAnim:SetEasing('in-circular')
        obj.NumberAnim:SetDuration(duration)
    else
        local x, y, duration, customName = ...
        if not customName then
            customName = 'anim'
        end

        local anim = obj:CreateAnimationGroup('Move_In')
        obj[customName] = anim

        anim.in1 = anim:CreateAnimation('Translation')
        anim.in1:SetDuration(0)
        anim.in1:SetOrder(1)
        anim.in1:SetOffset(x, y)

        anim.in2 = anim:CreateAnimation('Translation')
        anim.in2:SetDuration(duration)
        anim.in2:SetOrder(2)
        anim.in2:SetSmoothing('OUT')
        anim.in2:SetOffset(-x, -y)

        anim.out1 = obj:CreateAnimationGroup('Move_Out')
        anim.out1:SetScript('OnFinished', function()
            obj:Hide()
        end)

        anim.out2 = anim.out1:CreateAnimation('Translation')
        anim.out2:SetDuration(duration)
        anim.out2:SetOrder(1)
        anim.out2:SetSmoothing('IN')
        anim.out2:SetOffset(x, y)
    end
end

function F:Elasticize(obj, width, height)
    if not obj.elastic then
        if not width then
            width = obj:GetWidth()
        end
        if not height then
            height = obj:GetHeight()
        end
        F:SetUpAnimGroup(obj, 'Elastic', width, height, 2, false)
    end

    obj.elastic[1]:Play()
    obj.elastic[3]:Play()
end

function F:StopElasticize(obj)
    if obj.elastic then
        obj.elastic[1]:Stop(true)
        obj.elastic[3]:Stop(true)
    end
end

function F:Shake(obj)
    if not obj.shake then
        F:SetUpAnimGroup(obj, 'Shake')
    end

    obj.shake:Play()
end

function F:StopShake(obj)
    if obj.shake then
        obj.shake:Finish()
    end
end

function F:ShakeHorizontal(obj)
    if not obj.shakeh then
        F:SetUpAnimGroup(obj, 'ShakeH')
    end

    obj.shakeh:Play()
end

function F:StopShakeHorizontal(obj)
    if obj.shakeh then
        obj.shakeh:Finish()
    end
end

function F:Flash(obj, duration, loop)
    if not obj.anim then
        F:SetUpAnimGroup(obj, loop and 'FlashLoop' or 'Flash')
    end

    if not obj.anim:IsPlaying() then
        obj.anim.fadein:SetDuration(duration)
        obj.anim.fadeout:SetDuration(duration)
        obj.anim:Play()
    end
end

function F:StopFlash(obj)
    if obj.anim and obj.anim:IsPlaying() then
        obj.anim:Stop()
    end
end

function F:SlideIn(obj, customName)
    if not customName then
        customName = 'anim'
    end
    if not obj[customName] then
        return
    end

    obj[customName].out1:Stop()
    obj[customName]:Play()
    obj:Show()
end

function F:SlideOut(obj, customName)
    if not customName then
        customName = 'anim'
    end
    if not obj[customName] then
        return
    end

    obj[customName]:Finish()
    obj[customName]:Stop()
    obj[customName].out1:Play()
end

local FADEMANAGER = CreateFrame('FRAME')
local FADEFRAMES = {}
FADEMANAGER.delay = .025

function F:UIFrameFade_OnUpdate(elapsed)
    FADEMANAGER.timer = (FADEMANAGER.timer or 0) + elapsed

    if FADEMANAGER.timer > FADEMANAGER.delay then
        FADEMANAGER.timer = 0

        for frame, info in next, FADEFRAMES do
            -- Reset the timer if there isn't one, this is just an internal counter
            if frame:IsVisible() then
                info.fadeTimer = (info.fadeTimer or 0) + (elapsed + FADEMANAGER.delay)
            else
                info.fadeTimer = info.timeToFade + 1
            end

            -- If the fadeTimer is less then the desired fade time then set the alpha otherwise hold the fade state, call the finished function, or just finish the fade
            if info.fadeTimer < info.timeToFade then
                if info.mode == 'IN' then
                    frame:SetAlpha((info.fadeTimer / info.timeToFade) * info.diffAlpha + info.startAlpha)
                else
                    frame:SetAlpha(((info.timeToFade - info.fadeTimer) / info.timeToFade) * info.diffAlpha + info.endAlpha)
                end
            else
                frame:SetAlpha(info.endAlpha)

                -- If there is a fadeHoldTime then wait until its passed to continue on
                if info.fadeHoldTime and info.fadeHoldTime > 0 then
                    info.fadeHoldTime = info.fadeHoldTime - elapsed
                else
                    -- Complete the fade and call the finished function if there is one
                    F:UIFrameFadeRemoveFrame(frame)

                    if info.finishedFunc then
                        if info.finishedArgs then
                            info.finishedFunc(unpack(info.finishedArgs))
                        else -- optional method
                            info.finishedFunc(info.finishedArg1, info.finishedArg2, info.finishedArg3, info.finishedArg4, info.finishedArg5)
                        end

                        if not info.finishedFuncKeep then
                            info.finishedFunc = nil
                        end
                    end
                end
            end
        end

        if not next(FADEFRAMES) then
            FADEMANAGER:SetScript('OnUpdate', nil)
        end
    end
end

-- Generic fade function
function F:UIFrameFade(frame, info)
    if not frame or frame:IsForbidden() then
        return
    end

    frame.fadeInfo = info

    if not info.mode then
        info.mode = 'IN'
    end

    if info.mode == 'IN' then
        if not info.startAlpha then
            info.startAlpha = 0
        end
        if not info.endAlpha then
            info.endAlpha = 1
        end
        if not info.diffAlpha then
            info.diffAlpha = info.endAlpha - info.startAlpha
        end
    else
        if not info.startAlpha then
            info.startAlpha = 1
        end
        if not info.endAlpha then
            info.endAlpha = 0
        end
        if not info.diffAlpha then
            info.diffAlpha = info.startAlpha - info.endAlpha
        end
    end

    frame:SetAlpha(info.startAlpha)

    if not frame:IsProtected() then
        frame:Show()
    end

    if not FADEFRAMES[frame] then
        FADEFRAMES[frame] = info -- read below comment
        FADEMANAGER:SetScript('OnUpdate', F.UIFrameFade_OnUpdate)
    else
        FADEFRAMES[frame] = info -- keep these both, we need this updated in the event its changed to another ref from a plugin or sth, don't move it up!
    end
end

-- Convenience function to do a simple fade in
function F:UIFrameFadeIn(frame, timeToFade, startAlpha, endAlpha)
    if not frame or frame:IsForbidden() then
        return
    end

    if frame.FadeObject then
        frame.FadeObject.fadeTimer = nil
    else
        frame.FadeObject = {}
    end

    frame.FadeObject.mode = 'IN'
    frame.FadeObject.timeToFade = timeToFade
    frame.FadeObject.startAlpha = startAlpha
    frame.FadeObject.endAlpha = endAlpha
    frame.FadeObject.diffAlpha = endAlpha - startAlpha

    F:UIFrameFade(frame, frame.FadeObject)
end

-- Convenience function to do a simple fade out
function F:UIFrameFadeOut(frame, timeToFade, startAlpha, endAlpha)
    if not frame or frame:IsForbidden() then
        return
    end

    if frame.FadeObject then
        frame.FadeObject.fadeTimer = nil
    else
        frame.FadeObject = {}
    end

    frame.FadeObject.mode = 'OUT'
    frame.FadeObject.timeToFade = timeToFade
    frame.FadeObject.startAlpha = startAlpha
    frame.FadeObject.endAlpha = endAlpha
    frame.FadeObject.diffAlpha = startAlpha - endAlpha

    F:UIFrameFade(frame, frame.FadeObject)
end

function F:UIFrameFadeRemoveFrame(frame)
    if frame and FADEFRAMES[frame] then
        if frame.FadeObject then
            frame.FadeObject.fadeTimer = nil
        end

        FADEFRAMES[frame] = nil
    end
end

-- From ElvUI_WindTool

--[[
    创建动画窗体
    @param {string} [name] 动画窗体名
    @param {object} [parent=ElvUIParent] 父窗体
    @param {strata} [string] 窗体层级
    @param {level} [number] 窗体等级
    @param {hidden} [boolean] 窗体创建后隐藏
    @param {texture} [string] 材质路径
    @param {isMirror} [boolean] 使材质沿 y 轴翻折
    @returns object 创建的窗体
]]
function F.CreateAnimationFrame(name, parent, strata, level, hidden, texture, isMirror, color)
    parent = parent or _G.UIParent

    local frame = CreateFrame('Frame', name, parent)

    if strata then
        frame:SetFrameStrata(strata)
    end

    if level then
        frame:SetFrameLevel(level)
    end

    if hidden then
        frame:SetAlpha(0)
        frame:Hide()
    end

    if texture then
        local tex = frame:CreateTexture()
        tex:SetTexture(texture)

        if isMirror then
            local ULx, ULy, LLx, LLy, URx, URy, LRx, LRy = tex:GetTexCoord() -- 沿 y 轴翻转素材
            tex:SetTexCoord(URx, URy, LRx, LRy, ULx, ULy, LLx, LLy)
        end

        if color then
            tex:SetVertexColor(unpack(color))
        end

        tex:SetAllPoints()
        frame.texture = tex
    end

    return frame
end

--[[
    创建动画组
    @param {object} parent 父窗体
    @param {string} [name] 动画组名
    @returns object 生成的动画组
]]
function F.CreateAnimationGroup(frame, name)
    if not frame then
        F:DebugPrintMessage('动画', '[1]父窗体缺失')
        return
    end

    name = name or 'anime'

    local animationGroup = frame:CreateAnimationGroup()
    frame[name] = animationGroup

    return animationGroup
end

--[[
    添加移动动画
    @param {object} animationGroup 从属动画组
    @param {string} name 动画索引名
]]
function F.AddTranslation(animationGroup, name)
    if not (animationGroup and animationGroup:IsObjectType('AnimationGroup')) then
        return
    end
    if not name then
        F:DebugPrintMessage('动画', '[1]动画名缺失')
        return
    end

    local animation = animationGroup:CreateAnimation('Translation')
    animation:SetParent(animationGroup)
    animationGroup[name] = animation
end

--[[
    添加渐入动画
    @param {object} animationGroup 从属动画组
    @param {string} name 动画索引名
]]
function F.AddFadeIn(animationGroup, name)
    if not (animationGroup and animationGroup:IsObjectType('AnimationGroup')) then
        F:DebugPrintMessage('动画', '[1]找不到动画组')
        return
    end

    if not name then
        F:DebugPrintMessage('动画', '[2]动画名缺失')
        return
    end

    local animation = animationGroup:CreateAnimation('Alpha')
    animation:SetFromAlpha(0)
    animation:SetToAlpha(1)
    animation:SetSmoothing('IN')
    animation:SetParent(animationGroup)
    animationGroup[name] = animation
end

--[[
    添加渐隐动画
    @param {object} animationGroup 从属动画组
    @param {string} name 动画索引名
]]
function F.AddFadeOut(animationGroup, name)
    if not (animationGroup and animationGroup:IsObjectType('AnimationGroup')) then
        F:DebugPrintMessage('动画', '[2]找不到动画组')
        return
    end

    if not name then
        F:DebugPrintMessage('动画', '[3]动画名缺失')
        return
    end

    local animation = animationGroup:CreateAnimation('Alpha')
    animation:SetFromAlpha(1)
    animation:SetToAlpha(0)
    animation:SetSmoothing('OUT')
    animation:SetParent(animationGroup)
    animationGroup[name] = animation
end

--[[
    添加缩放动画
    @param {object} animationGroup 从属动画组
    @param {string} name 动画索引名
    @param {number[2]} fromScale 原尺寸 x, y
    @param {number[2]} toScale 动画后尺寸 x, y
]]
function F.AddScale(animationGroup, name, fromScale, toScale)
    if not (animationGroup and animationGroup:IsObjectType('AnimationGroup')) then
        F:DebugPrintMessage('动画', '[3]找不到动画组')
        return
    end

    if not name then
        F:DebugPrintMessage('动画', '[4]动画名缺失')
        return
    end

    if not fromScale or type(fromScale) ~= 'table' or #(fromScale) < 2 then
        F:DebugPrintMessage('动画', '[1]缩放动画初始x,y错误')
        return
    end

    if not toScale or type(toScale) ~= 'table' or #(toScale) < 2 then
        F:DebugPrintMessage('动画', '[1]缩放动画目标x,y错误')
        return
    end

    local animation = animationGroup:CreateAnimation('Scale')
    animation:SetFromScale(unpack(fromScale))
    animation:SetToScale(unpack(toScale))
    animation:SetParent(animationGroup)
    animationGroup[name] = animation
end

--[[
    设定动画随显示属性而播放
    @param {object} frame 动画窗体
    @param {object} animationGroup 动画组
]]
function F.PlayAnimationOnShow(frame, animationGroup)
    if not animationGroup or type(animationGroup) == 'string' then
        animationGroup = frame[animationGroup]
    end

    if not (animationGroup and animationGroup:IsObjectType('AnimationGroup')) then
        F:DebugPrintMessage('动画', '[3]找不到动画组')
        return
    end

    frame:SetScript('OnShow', function()
        animationGroup:Play()
    end)
end

--[[
    设定动画随显示属性而播放
    @param {object} frame 动画窗体
    @param {object} animationGroup 动画组
    @param {function} [callback] 结束时的回调
]]
function F.CloseAnimationOnHide(frame, animationGroup, callback)
    if not animationGroup or type(animationGroup) == 'string' then
        animationGroup = frame[animationGroup]
    end

    if not (animationGroup and animationGroup:IsObjectType('AnimationGroup')) then
        F:DebugPrintMessage('动画', '[3]找不到动画组')
        return
    end

    animationGroup:SetScript('OnFinished', function()
        frame:Hide()
        if callback then
            callback()
        end
    end)
end

--[[
    调整动画组速度
    @param {object} animationGroup 动画组
    @param {number} speed 相较于原速度的倍数
]]
function F.SpeedAnimationGroup(animationGroup, speed)
    if not speed or type(speed) ~= 'number' then
        F:DebugPrintMessage('动画', '[1]找不到速度')
        return
    end

    if not (animationGroup and animationGroup:IsObjectType('AnimationGroup')) then
        F:DebugPrintMessage('动画', '[4]找不到动画组')
        return
    end

    if not animationGroup.GetAnimations then
        F:DebugPrintMessage('动画', '[1]无法找到动画组的子成员')
        return
    end

    local durationTimer = 1 / speed

    for _, animation in pairs({animationGroup:GetAnimations()}) do
        if not animation.originalDuration then
            animation.originalDuration = animation:GetDuration()
        end
        if not animation.originalStartDelay then
            animation.originalStartDelay = animation:GetStartDelay()
        end
        animation:SetDuration(animation.originalDuration * durationTimer)
        animation:SetStartDelay(animation.originalStartDelay * durationTimer)
    end
end
