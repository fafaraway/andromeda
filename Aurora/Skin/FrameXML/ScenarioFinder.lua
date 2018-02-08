local _, private = ...

-- [[ Core ]]
local F = _G.unpack(private.Aurora)

function private.FrameXML.ScenarioFinder()
    _G.ScenarioFinderFrameInset:DisableDrawLayer("BORDER")
    _G.ScenarioFinderFrame.TopTileStreaks:Hide()
    _G.ScenarioFinderFrameBtnCornerRight:Hide()
    _G.ScenarioFinderFrameButtonBottomBorder:Hide()
    _G.ScenarioQueueFrameRandomScrollFrameScrollBackground:Hide()
    _G.ScenarioQueueFrameRandomScrollFrameScrollBackgroundTopLeft:Hide()
    _G.ScenarioQueueFrameRandomScrollFrameScrollBackgroundBottomRight:Hide()
    _G.ScenarioQueueFrameSpecificScrollFrameScrollBackgroundTopLeft:Hide()
    _G.ScenarioQueueFrameSpecificScrollFrameScrollBackgroundBottomRight:Hide()
    _G.ScenarioQueueFrame.Bg:Hide()
    _G.ScenarioFinderFrameInset:GetRegions():Hide()

    _G.ScenarioQueueFrameRandomScrollFrame:SetWidth(304)

    F.Reskin(_G.ScenarioQueueFrameFindGroupButton)
    F.Reskin(_G.ScenarioQueueFrameRandomScrollFrameChildFrame.bonusRepFrame.ChooseButton)
    F.ReskinDropDown(_G.ScenarioQueueFrameTypeDropDown)
    F.ReskinScroll(_G.ScenarioQueueFrameRandomScrollFrameScrollBar)
    F.ReskinScroll(_G.ScenarioQueueFrameSpecificScrollFrameScrollBar)
end
