local _, private = ...

-- [[ Lua Globals ]]
local select = _G.select

-- [[ WoW API ]]
local CreateFrame = _G.CreateFrame

-- [[ Core ]]
local F, C = _G.unpack(private.Aurora)

function private.AddOns.Blizzard_ArchaeologyUI()
    F.SetBD(_G.ArchaeologyFrame)
    F.Reskin(_G.ArchaeologyFrameArtifactPageSolveFrameSolveButton)
    F.Reskin(_G.ArchaeologyFrameArtifactPageBackButton)
    _G.ArchaeologyFramePortrait:Hide()
    _G.ArchaeologyFrame:DisableDrawLayer("BACKGROUND")
    _G.ArchaeologyFrame:DisableDrawLayer("BORDER")
    _G.ArchaeologyFrame:DisableDrawLayer("OVERLAY")
    _G.ArchaeologyFrameInset:DisableDrawLayer("BACKGROUND")
    _G.ArchaeologyFrameInset:DisableDrawLayer("BORDER")
    _G.ArchaeologyFrameSummaryPageTitle:SetTextColor(1, 1, 1)
    _G.ArchaeologyFrameArtifactPageHistoryTitle:SetTextColor(1, 1, 1)
    _G.ArchaeologyFrameArtifactPageHistoryScrollChildText:SetTextColor(1, 1, 1)
    _G.ArchaeologyFrameHelpPageTitle:SetTextColor(1, 1, 1)
    _G.ArchaeologyFrameHelpPageDigTitle:SetTextColor(1, 1, 1)
    _G.ArchaeologyFrameHelpPageHelpScrollHelpText:SetTextColor(1, 1, 1)
    _G.ArchaeologyFrameCompletedPage:GetRegions():SetTextColor(1, 1, 1)
    _G.ArchaeologyFrameCompletedPageTitle:SetTextColor(1, 1, 1)
    _G.ArchaeologyFrameCompletedPageTitleTop:SetTextColor(1, 1, 1)
    _G.ArchaeologyFrameCompletedPageTitleMid:SetTextColor(1, 1, 1)
    _G.ArchaeologyFrameCompletedPagePageText:SetTextColor(1, 1, 1)
    _G.ArchaeologyFrameSummaryPagePageText:SetTextColor(1, 1, 1)

    for i = 1, _G.ARCHAEOLOGY_MAX_RACES do
        _G["ArchaeologyFrameSummaryPageRace"..i]:GetRegions():SetTextColor(1, 1, 1)
    end

    for i = 1, _G.ARCHAEOLOGY_MAX_COMPLETED_SHOWN do
        local bu = _G["ArchaeologyFrameCompletedPageArtifact"..i]
        bu:GetRegions():Hide()
        select(2, bu:GetRegions()):Hide()
        select(3, bu:GetRegions()):SetTexCoord(.08, .92, .08, .92)
        select(4, bu:GetRegions()):SetTextColor(1, 1, 1)
        select(5, bu:GetRegions()):SetTextColor(1, 1, 1)
        local bg = CreateFrame("Frame", nil, bu)
        bg:SetPoint("TOPLEFT", -1, 1)
        bg:SetPoint("BOTTOMRIGHT", 1, -1)
        bg:SetFrameLevel(bu:GetFrameLevel()-1)
        F.CreateBD(bg, .25)
        local vline = CreateFrame("Frame", nil, bu)
        vline:SetPoint("LEFT", 44, 0)
        vline:SetSize(1, 44)
        F.CreateBD(vline)
    end

    _G.ArchaeologyFrameInfoButton:SetPoint("TOPLEFT", 3, -3)

    _G.ArchaeologyFrameSummarytButton:SetPoint("TOPLEFT", _G.ArchaeologyFrame, "TOPRIGHT", 1, -50)
    _G.ArchaeologyFrameSummarytButton:SetFrameLevel(_G.ArchaeologyFrame:GetFrameLevel()-1)
    _G.ArchaeologyFrameCompletedButton:SetPoint("TOPLEFT", _G.ArchaeologyFrame, "TOPRIGHT", 1, -120)
    _G.ArchaeologyFrameCompletedButton:SetFrameLevel(_G.ArchaeologyFrame:GetFrameLevel()-1)

    F.ReskinDropDown(_G.ArchaeologyFrameRaceFilter)
    F.ReskinClose(_G.ArchaeologyFrameCloseButton)
    F.ReskinScroll(_G.ArchaeologyFrameArtifactPageHistoryScrollScrollBar)
    F.ReskinArrow(_G.ArchaeologyFrameCompletedPagePrevPageButton, "Left")
    F.ReskinArrow(_G.ArchaeologyFrameCompletedPageNextPageButton, "Right")
    _G.ArchaeologyFrameCompletedPagePrevPageButtonIcon:Hide()
    _G.ArchaeologyFrameCompletedPageNextPageButtonIcon:Hide()
    F.ReskinArrow(_G.ArchaeologyFrameSummaryPagePrevPageButton, "Left")
    F.ReskinArrow(_G.ArchaeologyFrameSummaryPageNextPageButton, "Right")
    _G.ArchaeologyFrameSummaryPagePrevPageButtonIcon:Hide()
    _G.ArchaeologyFrameSummaryPageNextPageButtonIcon:Hide()

    _G.ArchaeologyFrameRankBarBorder:Hide()
    _G.ArchaeologyFrameRankBarBackground:Hide()
    _G.ArchaeologyFrameRankBarBar:SetTexture(C.media.backdrop)
    _G.ArchaeologyFrameRankBarBar:SetGradient("VERTICAL", 0, .65, 0, 0, .75, 0)
    _G.ArchaeologyFrameRankBar:SetHeight(14)
    F.CreateBD(_G.ArchaeologyFrameRankBar, .25)

    _G.ArchaeologyFrameArtifactPageSolveFrameStatusBarBarBG:Hide()
    local bar = select(3, _G.ArchaeologyFrameArtifactPageSolveFrameStatusBar:GetRegions())
    bar:SetTexture(C.media.backdrop)
    bar:SetGradient("VERTICAL", .65, .25, 0, .75, .35, .1)

    local bg = CreateFrame("Frame", nil, _G.ArchaeologyFrameArtifactPageSolveFrameStatusBar)
    bg:SetPoint("TOPLEFT", -1, 1)
    bg:SetPoint("BOTTOMRIGHT", 1, -1)
    bg:SetFrameLevel(0)
    F.CreateBD(bg, .25)

    _G.ArchaeologyFrameArtifactPageIcon:SetTexCoord(.08, .92, .08, .92)
    F.CreateBG(_G.ArchaeologyFrameArtifactPageIcon)
end
