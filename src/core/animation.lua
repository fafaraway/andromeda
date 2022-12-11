-- Credit: ElvUI, ElvUI_WindTool

local F = unpack(select(2, ...))

local animShake = {
    { -9, 7, -7, 12 },
    { -5, 9, -9, 5 },
    { -5, 7, -7, 5 },
    { -9, 9, -9, 9 },
    { -5, 7, -7, 5 },
    { -9, 7, -9, 5 },
}
local animShakeH = { -5, 5, -2, 5, -2, 5 }

function F:FlashLoopFinished(requested)
    if not requested then
        self:Play()
    end
end

function F:RandomAnimShake(index)
    local s = animShake[index]
    return random(s[1], s[2]), random(s[3], s[4])
end

function F:SetUpAnimGroup(obj, Type, ...)
    if not Type then
        Type = 'Flash'
    end

    if strsub(Type, 1, 5) == 'Flash' then
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
    elseif strsub(Type, 1, 5) == 'Shake' then
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
FADEMANAGER.delay = 0.025

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

function F.CreateAnimationGroup(frame, name)
    if not frame then
        F:Debug('Animation.CreateAnimationGroup: frame not found')
        return
    end

    name = name or 'anime'

    local animationGroup = frame:CreateAnimationGroup()
    frame[name] = animationGroup

    return animationGroup
end

function F.AddTranslation(animationGroup, name)
    if not (animationGroup and animationGroup:IsObjectType('AnimationGroup')) then
        return
    end
    if not name then
        F:Debug('Animation.AddTranslation: name not found')
        return
    end

    local animation = animationGroup:CreateAnimation('Translation')
    animation:SetParent(animationGroup)
    animationGroup[name] = animation
end

function F.AddFadeIn(animationGroup, name)
    if not (animationGroup and animationGroup:IsObjectType('AnimationGroup')) then
        F:Debug('Animation.AddFadeIn: animation group not found')
        return
    end

    if not name then
        F:Debug('Animation.AddFadeIn: name not found')
        return
    end

    local animation = animationGroup:CreateAnimation('Alpha')
    animation:SetFromAlpha(0)
    animation:SetToAlpha(1)
    animation:SetSmoothing('IN')
    animation:SetParent(animationGroup)
    animationGroup[name] = animation
end

function F.AddFadeOut(animationGroup, name)
    if not (animationGroup and animationGroup:IsObjectType('AnimationGroup')) then
        F:Debug('Animation.AddFadeOut: animation group not found')
        return
    end

    if not name then
        F:Debug('Animation.AddFadeOut: name not found')
        return
    end

    local animation = animationGroup:CreateAnimation('Alpha')
    animation:SetFromAlpha(1)
    animation:SetToAlpha(0)
    animation:SetSmoothing('OUT')
    animation:SetParent(animationGroup)
    animationGroup[name] = animation
end

function F.AddScale(animationGroup, name, fromScale, toScale)
    if not (animationGroup and animationGroup:IsObjectType('AnimationGroup')) then
        F:Debug('Animation.AddScale: animation group not found')
        return
    end

    if not name then
        F:Debug('Animation.AddScale: name not found')
        return
    end

    if not fromScale or type(fromScale) ~= 'table' or getn(fromScale) < 2 then
        F:Debug('Animation.AddScale: invalid fromScale (x, y)')
        return
    end

    if not toScale or type(toScale) ~= 'table' or getn(toScale) < 2 then
        F:Debug('Animation.AddScale: invalid toScale (x, y)')
        return
    end

    local animation = animationGroup:CreateAnimation('Scale')
    animation:SetScaleFrom(unpack(fromScale))
    animation:SetScaleTo(unpack(toScale))
    animation:SetParent(animationGroup)
    animationGroup[name] = animation
end

function F.PlayAnimationOnShow(frame, animationGroup)
    if not animationGroup or type(animationGroup) == 'string' then
        animationGroup = frame[animationGroup]
    end

    if not (animationGroup and animationGroup:IsObjectType('AnimationGroup')) then
        F:Debug('Animation.PlayAnimationOnShow: animation group not found')
        return
    end

    frame:SetScript('OnShow', function()
        animationGroup:Play()
    end)
end

function F.CloseAnimationOnHide(frame, animationGroup, callback)
    if not animationGroup or type(animationGroup) == 'string' then
        animationGroup = frame[animationGroup]
    end

    if not (animationGroup and animationGroup:IsObjectType('AnimationGroup')) then
        F:Debug('Animation.CloseAnimationOnHide: animation group not found')
        return
    end

    animationGroup:SetScript('OnFinished', function()
        frame:Hide()
        if callback then
            callback()
        end
    end)
end

function F.SpeedAnimationGroup(animationGroup, speed)
    if not speed or type(speed) ~= 'number' then
        F:Debug('Animation.SpeedAnimationGroup: speed not found')
        return
    end

    if not (animationGroup and animationGroup:IsObjectType('AnimationGroup')) then
        F:Debug('Animation.SpeedAnimationGroup: animation group not found')
        return
    end

    if not animationGroup.GetAnimations then
        F:Debug('Animation.SpeedAnimationGroup: animation not found')
        return
    end

    local durationTimer = 1 / speed

    for _, animation in pairs({ animationGroup:GetAnimations() }) do
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
