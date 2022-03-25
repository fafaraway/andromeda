local F, C = unpack(select(2, ...))
local UNITFRAME = F:GetModule('UnitFrame')
local oUF = F.Libs.oUF

local unitFrames = {
    ['player'] = true,
    ['pet'] = true
}

function UNITFRAME:ConfigureFader(frame)
    if C.DB.Unitframe.Fader then
        if not frame:IsElementEnabled('Fader') then
            frame:EnableElement('Fader')
        end

        frame.Fader:SetOption('Instance', C.DB.Unitframe['Instance'])
        frame.Fader:SetOption('Hover', C.DB.Unitframe['Hover'])
        frame.Fader:SetOption('Combat', C.DB.Unitframe['Combat'])
        frame.Fader:SetOption('PlayerTarget', C.DB.Unitframe['Target'])
        frame.Fader:SetOption('Focus', C.DB.Unitframe['Target'])
        frame.Fader:SetOption('Power', C.DB.Unitframe['Power'])
        frame.Fader:SetOption('Health', C.DB.Unitframe['Health'])
        frame.Fader:SetOption('Vehicle', C.DB.Unitframe['Vehicle'])
        frame.Fader:SetOption('Casting', C.DB.Unitframe['Casting'])
        frame.Fader:SetOption('MinAlpha', C.DB.Unitframe['MinAlpha'])
        frame.Fader:SetOption('MaxAlpha', C.DB.Unitframe['MaxAlpha'])

        if frame ~= _G.oUF_Player then
            frame.Fader:SetOption('UnitTarget', C.DB.Unitframe['Target'])
        end

        frame.Fader:SetOption('Smooth', .3)
        frame.Fader:SetOption('Delay', C.DB.Unitframe['Delay'])

        frame.Fader:ClearTimers()
        frame.Fader.configTimer = F:ScheduleTimer(frame.Fader.ForceUpdate, .3, frame.Fader, true)
    elseif frame:IsElementEnabled('Fader') then
        frame:DisableElement('Fader')
        F:UIFrameFadeIn(frame, 1, frame:GetAlpha(), 1)
    end
end

function UNITFRAME:UpdateFader()
    for _, frame in pairs(oUF.objects) do
        local style = frame.unitStyle
        if style and unitFrames[style] then
            frame.Fader = frame.Fader or {}
            UNITFRAME:ConfigureFader(frame)
        end
    end
end
