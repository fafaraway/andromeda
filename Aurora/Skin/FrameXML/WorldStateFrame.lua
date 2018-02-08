local _, private = ...

--[[ Lua Globals ]]
-- luacheck: globals

--[[ Core ]]
local Aurora = private.Aurora
local Base, Hook, Skin = Aurora.Base, Aurora.Hook, Aurora.Skin
local F, C = _G.unpack(private.Aurora)

do --[[ FrameXML\WorldStateFrame.lua ]]
    function Hook.CaptureBar_Create(id)
        Skin.WorldStateCaptureBarTemplate(_G["WorldStateCaptureBar"..id])
     end
    function Hook.CaptureBar_Update(id, value, neutralPercent)
        local bar = _G["WorldStateCaptureBar"..id]
        bar:ClearAllPoints()
        bar:SetPoint("TOP", _G.UIParent, "TOP", 0, -120)
        if bar.style == "LFD_BATTLEFIELD" then
            bar._auroraLeftFaction:SetTexture([[Interface\WorldStateFrame\ColumnIcon-FlagCapture2]])

            bar._auroraRightFaction:SetTexture([[Interface\WorldStateFrame\ColumnIcon-FlagCapture2]])
            bar._auroraRightFaction:SetDesaturated(true)
            bar._auroraRightFaction:SetVertexColor(0.75, 0.5, 1)
        else
            bar._auroraLeftFaction:SetTexture([[Interface\WorldStateFrame\AllianceFlag]])

            bar._auroraRightFaction:SetTexture([[Interface\WorldStateFrame\HordeFlag]])
            bar._auroraRightFaction:SetDesaturated(false)
            bar._auroraRightFaction:SetVertexColor(1, 1, 1)
        end
     end
end

do --[[ FrameXML\WorldStateFrame.xml ]]
    function Skin.WorldStateScoreTemplate(frame)
        frame.factionLeft:ClearAllPoints()
        frame.factionLeft:SetPoint("TOPLEFT", 20, -1)
        frame.factionLeft:SetPoint("BOTTOMRIGHT", frame, "BOTTOM", 0, 1)
        frame.factionLeft:SetTexture([[Interface\Buttons\WHITE8x8]])
        frame.factionLeft:SetBlendMode("ADD")
        frame.factionLeft:SetAlpha(0.8)

        frame.factionRight:ClearAllPoints()
        frame.factionRight:SetPoint("TOPLEFT", frame.factionLeft, "TOPRIGHT", 0, 0)
        frame.factionRight:SetPoint("BOTTOMRIGHT", 0, 1)
        frame.factionRight:SetTexture([[Interface\Buttons\WHITE8x8]])
        frame.factionRight:SetBlendMode("ADD")
        frame.factionRight:SetAlpha(0.8)
    end
    function Skin.WorldStateCaptureBarTemplate(frame)
        frame.BarBackground:Hide()

        local bg = _G.CreateFrame("Frame", nil, frame)
        bg:SetFrameLevel(frame:GetFrameLevel())
        bg:SetPoint("TOPLEFT", 25, -7)
        bg:SetPoint("BOTTOMRIGHT", -25, 8)
        Base.SetBackdrop(bg)

        local leftFaction = frame:CreateTexture()
        leftFaction:SetTexture([[Interface\WorldStateFrame\AllianceFlag]])
        leftFaction:SetPoint("LEFT", -5, 0)
        leftFaction:SetSize(32, 32)
        frame._auroraLeftFaction = leftFaction

        local rightFaction = frame:CreateTexture()
        rightFaction:SetTexture([[Interface\WorldStateFrame\HordeFlag]])
        rightFaction:SetPoint("RIGHT", 5, 0)
        rightFaction:SetSize(32, 32)
        frame._auroraRightFaction = rightFaction

        frame.RightLine:SetColorTexture(0, 0, 0)
        frame.RightLine:SetSize(2, 9)
        frame.LeftLine:SetColorTexture(0, 0, 0)
        frame.LeftLine:SetSize(2, 9)

        frame.LeftIconHighlight:SetTexture([[Interface\WorldStateFrame\HordeFlagFlash]])
        frame.LeftIconHighlight:SetAllPoints(leftFaction)
        frame.RightIconHighlight:SetTexture([[Interface\WorldStateFrame\HordeFlagFlash]])
        frame.RightIconHighlight:SetAllPoints(rightFaction)
    end
end

function private.FrameXML.WorldStateFrame()
    _G.hooksecurefunc(_G.ExtendedUI["CAPTUREPOINT"], "create", Hook.CaptureBar_Create)
    _G.hooksecurefunc(_G.ExtendedUI["CAPTUREPOINT"], "update", Hook.CaptureBar_Update)


    Skin.ButtonFrameTemplate(_G.WorldStateScoreFrame)
    F.CreateSD(_G.WorldStateScoreFrame)
    Skin.PVPHonorSystemLargeXPBar(_G.WorldStateScoreFrame.XPBar)

    for i = 1, _G.MAX_WORLDSTATE_SCORE_BUTTONS do
        Skin.WorldStateScoreTemplate(_G["WorldStateScoreButton" .. i])
    end
    Skin.FauxScrollFrameTemplate(_G.WorldStateScoreScrollFrame)
    local top, mid, bottom = _G.WorldStateScoreScrollFrame:GetRegions()
    top:Hide()
    mid:Hide()
    bottom:Hide()

    Skin.CharacterFrameTabButtonTemplate(_G.WorldStateScoreFrameTab1)
    _G.WorldStateScoreFrameTab1:SetPoint("TOPLEFT", _G.WorldStateScoreFrame, "BOTTOMLEFT", 20, -1)
    Skin.CharacterFrameTabButtonTemplate(_G.WorldStateScoreFrameTab2)
    _G.WorldStateScoreFrameTab2:SetPoint("TOPLEFT", _G.WorldStateScoreFrameTab1, "TOPRIGHT", 1, 0)
    Skin.CharacterFrameTabButtonTemplate(_G.WorldStateScoreFrameTab3)
    _G.WorldStateScoreFrameTab3:SetPoint("TOPLEFT", _G.WorldStateScoreFrameTab2, "TOPRIGHT", 1, 0)

    -- Skin.UIPanelButtonTemplate(_G.WorldStateScoreFrameQueueButton)
    -- Skin.UIPanelButtonTemplate(_G.WorldStateScoreFrameLeaveButton)
    F.Reskin(_G.WorldStateScoreFrameQueueButton)
    F.Reskin(_G.WorldStateScoreFrameLeaveButton)

    _G.WorldStateScoreWinnerFrameLeft:SetTexture([[Interface\Buttons\WHITE8x8]])
    _G.WorldStateScoreWinnerFrameRight:SetTexture([[Interface\Buttons\WHITE8x8]])
end
