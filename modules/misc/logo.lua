local F, C = unpack(select(2, ...))
local LOGO = F:RegisterModule('Logo')

local needAnimation

function LOGO:Logo_PlayAnimation()
    if needAnimation then
        LOGO.logoFrame:Show()
        F:UnregisterEvent(self, LOGO.Logo_PlayAnimation)
        needAnimation = false
    end
end

function LOGO:Logo_CheckStatus(isInitialLogin)
    if isInitialLogin and not (IsInInstance() and InCombatLockdown()) then
        needAnimation = true
        LOGO:Logo_Create()
        F:RegisterEvent('PLAYER_STARTED_MOVING', LOGO.Logo_PlayAnimation)
        -- F:RegisterEvent('PLAYER_ENTERING_WORLD', LOGO.Logo_PlayAnimation)
    end
    F:UnregisterEvent(self, LOGO.Logo_CheckStatus)
end

function LOGO:Logo_Create()
    local frame = CreateFrame('Frame', nil, _G.UIParent)
    frame:SetSize(512, 512)
    frame:SetPoint('CENTER', _G.UIParent, 'BOTTOM', -500, GetScreenHeight() * 0.618)
    frame:SetFrameStrata('HIGH')
    frame:SetAlpha(0)
    frame:Hide()

    local tex = frame:CreateTexture()
    tex:SetAllPoints()
    tex:SetTexture(C.Assets.Texture.Logo)
    tex:SetBlendMode('ADD')
    tex:SetDesaturated(true)
    -- tex:SetGradientAlpha('Vertical', 1, 1, 1, .75, 1, 1, 1, .75)

    local delayTime = 0
    local timer1 = 0.5
    local timer2 = 2.5
    local timer3 = 0.2

    local anim = frame:CreateAnimationGroup()

    anim.move1 = anim:CreateAnimation('Translation')
    anim.move1:SetOffset(480, 0)
    anim.move1:SetDuration(timer1)
    anim.move1:SetStartDelay(delayTime)

    anim.fadeIn = anim:CreateAnimation('Alpha')
    anim.fadeIn:SetFromAlpha(0)
    anim.fadeIn:SetToAlpha(1)
    anim.fadeIn:SetDuration(timer1)
    anim.fadeIn:SetSmoothing('IN')
    anim.fadeIn:SetStartDelay(delayTime)

    delayTime = delayTime + timer1

    anim.move2 = anim:CreateAnimation('Translation')
    anim.move2:SetOffset(80, 0)
    anim.move2:SetDuration(timer2)
    anim.move2:SetStartDelay(delayTime)

    delayTime = delayTime + timer2

    anim.move3 = anim:CreateAnimation('Translation')
    anim.move3:SetOffset(-40, 0)
    anim.move3:SetDuration(timer3)
    anim.move3:SetStartDelay(delayTime)

    delayTime = delayTime + timer3

    anim.move4 = anim:CreateAnimation('Translation')
    anim.move4:SetOffset(480, 0)
    anim.move4:SetDuration(timer1)
    anim.move4:SetStartDelay(delayTime)

    anim.fadeOut = anim:CreateAnimation('Alpha')
    anim.fadeOut:SetFromAlpha(1)
    anim.fadeOut:SetToAlpha(0)
    anim.fadeOut:SetDuration(timer1)
    anim.fadeOut:SetSmoothing('OUT')
    anim.fadeOut:SetStartDelay(delayTime)

    frame:SetScript('OnShow', function()
        anim:Play()
    end)
    anim:SetScript('OnFinished', function()
        frame:Hide()
    end)
    anim.fadeIn:SetScript('OnFinished', function()
        PlaySoundFile(C.Assets.Sound.Intro, 'Master')
    end)

    LOGO.logoFrame = frame
end

function LOGO:LoginAnimation()
    F:RegisterEvent('PLAYER_ENTERING_WORLD', LOGO.Logo_CheckStatus)

    _G.SlashCmdList['FREEUI_PLAYLOGO'] = function()
        if not LOGO.logoFrame then
            LOGO:Logo_Create()
        end
        LOGO.logoFrame:Show()
    end
    _G.SLASH_FREEUI_PLAYLOGO1 = '/logo'
end

function LOGO:OnLogin()
    if not C.DB.InstallationComplete then
        return
    end

    self:LoginAnimation()
end
