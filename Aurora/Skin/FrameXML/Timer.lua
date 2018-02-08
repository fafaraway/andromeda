local _, private = ...

--[[ Lua Globals ]]
-- luacheck: globals

--[[ Core ]]
local Aurora = private.Aurora
local Base = Aurora.Base
local Hook, Skin = Aurora.Hook, Aurora.Skin

do --[[ FrameXML\Timer.lua ]]
    function Hook.StartTimer_SetGoTexture(timer)
        if not timer._auroraSkinned then
            Skin.StartTimerBar(timer)
            timer._auroraSkinned = true
        end
    end
end

do --[[ FrameXML\Timer.xml ]]
    function Skin.StartTimerBar(frame)
        Base.SetTexture(frame.bar:GetStatusBarTexture(), "gradientUp")
        local bg, border = frame.bar:GetRegions()
        bg:Hide()
        border:Hide()

        local backdrop = _G.CreateFrame("Frame", nil, frame.bar)
        backdrop:SetPoint("TOPLEFT", -1, 1)
        backdrop:SetPoint("BOTTOMRIGHT", 1, -1)
        backdrop:SetFrameLevel(frame.bar:GetFrameLevel() - 1)
        Base.SetBackdrop(backdrop)

        --[[ Scale ]]--
        frame:SetSize(206, 26)
        frame.GoTexture:SetSize(256, 256)
        frame.bar:SetSize(195, 13)
        frame.bar:SetPoint("TOP", 0 -2)
    end
end

function private.FrameXML.Timer()
    _G.hooksecurefunc("StartTimer_SetGoTexture", Hook.StartTimer_SetGoTexture)
end
