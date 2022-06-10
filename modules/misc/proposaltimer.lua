local F, C = unpack(select(2, ...))
local PT = F:RegisterModule('ProposalTimer')

_G.LFGDungeonReadyDialog.nextUpdate = 0
_G.PVPReadyDialog.nextUpdate = 0

local function CreateTimerBar()
    local LFGTimer = CreateFrame('Frame', nil, _G.LFGDungeonReadyDialog)
    LFGTimer:SetPoint('BOTTOMLEFT')
    LFGTimer:SetPoint('BOTTOMRIGHT')
    LFGTimer:SetHeight(3)

    LFGTimer.bar = CreateFrame('StatusBar', nil, LFGTimer)
    LFGTimer.bar:SetStatusBarTexture(C.Assets.Statusbar.Normal)
    LFGTimer.bar:SetPoint('TOPLEFT', C.MULT, -C.MULT)
    LFGTimer.bar:SetPoint('BOTTOMLEFT', -C.MULT, C.MULT)
    LFGTimer.bar:SetFrameLevel(_G.LFGDungeonReadyDialog:GetFrameLevel() + 1)
    LFGTimer.bar:SetStatusBarColor(C.r, C.g, C.b)

    PT.LFGTimer = LFGTimer

    local PVPTimer = CreateFrame('Frame', nil, _G.PVPReadyDialog)
    PVPTimer:SetPoint('BOTTOMLEFT')
    PVPTimer:SetPoint('BOTTOMRIGHT')
    PVPTimer:SetHeight(3)

    PVPTimer.bar = CreateFrame('StatusBar', nil, PVPTimer)
    PVPTimer.bar:SetStatusBarTexture(C.Assets.Statusbar.Normal)
    PVPTimer.bar:SetPoint('TOPLEFT', C.MULT, -C.MULT)
    PVPTimer.bar:SetPoint('BOTTOMLEFT', -C.MULT, C.MULT)
    PVPTimer.bar:SetFrameLevel(_G.PVPReadyDialog:GetFrameLevel() + 1)
    PVPTimer.bar:SetStatusBarColor(C.r, C.g, C.b)

    PT.PVPTimer = PVPTimer
end

local function UpdateLFGTimer()
    local LFGTimer = PT.LFGTimer
    local obj = _G.LFGDungeonReadyDialog
    local oldTime = GetTime()
    local flag = 0
    local duration = 40
    local interval = 0.1
    obj:SetScript('OnUpdate', function(self, elapsed)
        obj.nextUpdate = obj.nextUpdate + elapsed
        if obj.nextUpdate > interval then
            local newTime = GetTime()
            if (newTime - oldTime) < duration then
                local width = LFGTimer:GetWidth() * (newTime - oldTime) / duration
                LFGTimer.bar:SetPoint('BOTTOMRIGHT', LFGTimer, 0 - width, 0)
                flag = flag + 1
                if flag >= 10 then
                    flag = 0
                end
            else
                obj:SetScript('OnUpdate', nil)
            end
            obj.nextUpdate = 0
        end
    end)
end

local function UpdatePVPTimer()
    local PVPTimer = PT.PVPTimer
    local obj = _G.PVPReadyDialog
    local oldTime = GetTime()
    local flag = 0
    local duration = 90
    local interval = 0.1
    obj:SetScript('OnUpdate', function(self, elapsed)
        obj.nextUpdate = obj.nextUpdate + elapsed
        if obj.nextUpdate > interval then
            local newTime = GetTime()
            if (newTime - oldTime) < duration then
                local width = PVPTimer:GetWidth() * (newTime - oldTime) / duration
                PVPTimer.bar:SetPoint('BOTTOMRIGHT', PVPTimer, 0 - width, 0)
                flag = flag + 1
                if flag >= 10 then
                    flag = 0
                end
            else
                obj:SetScript('OnUpdate', nil)
            end
            obj.nextUpdate = 0
        end
    end)
end

local function LFG_OnEvent()
    if _G.LFGDungeonReadyDialog:IsShown() then
        UpdateLFGTimer()
    end
end

local function PVP_OnEvent()
    if _G.PVPReadyDialog:IsShown() then
        UpdatePVPTimer()
    end
end

function PT:OnLogin()
    if _G.BigWigsLoader then
        return
    end

    if not C.DB.General.ProposalTimer then
        return
    end

    CreateTimerBar()

    PT.LFGTimer:RegisterEvent('LFG_PROPOSAL_SHOW')
    PT.LFGTimer:SetScript('OnEvent', LFG_OnEvent)

    PT.PVPTimer:RegisterEvent('UPDATE_BATTLEFIELD_STATUS')
    PT.PVPTimer:SetScript('OnEvent', PVP_OnEvent)
end
