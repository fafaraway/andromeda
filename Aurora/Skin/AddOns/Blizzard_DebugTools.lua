local _, private = ...

-- [[ Core ]]
local Aurora = private.Aurora
local Skin = Aurora.Skin
local F = _G.unpack(private.Aurora)

function private.AddOns.Blizzard_DebugTools()
    --[[ EventTrace ]]--
    for i = 1, _G.EventTraceFrame:GetNumRegions() do
        local region = _G.select(i, _G.EventTraceFrame:GetRegions())
        if region:GetObjectType() == "Texture" then
            region:SetTexture(nil)
        end
    end
    _G.EventTraceFrame:SetHeight(600)
    F.CreateBD(_G.EventTraceFrame)
    F.CreateSD(_G.EventTraceFrame)
    F.ReskinClose(_G.EventTraceFrameCloseButton)

    _G.EventTraceFrameTitleButton:ClearAllPoints()
    _G.EventTraceFrameTitleButton:SetPoint("TOPLEFT")
    _G.EventTraceFrameTitleButton:SetPoint("BOTTOMRIGHT", _G.EventTraceFrame, "TOPRIGHT", 0, -24)

    _G.EventTraceFrameScrollBG:Hide()
    local thumb = _G.EventTraceFrameScroll.thumb
    thumb:SetAlpha(0)
    thumb:SetWidth(17)
    local etraceBG = _G.CreateFrame("Frame", nil, _G.EventTraceFrameScroll)
    etraceBG:SetPoint("TOPLEFT", thumb, 0, 0)
    etraceBG:SetPoint("BOTTOMRIGHT", thumb, 0, 0)
    F.CreateBD(etraceBG, 0)
    F.CreateGradient(etraceBG)

    if not private.disabled.tooltips then
        Skin.GameTooltipTemplate(_G.FrameStackTooltip)
        Skin.GameTooltipTemplate(_G.EventTraceTooltip)
    end
end
