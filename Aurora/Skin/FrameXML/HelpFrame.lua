local _, private = ...

-- [[ Lua Globals ]]
local next, select = _G.next, _G.select

-- [[ Core ]]
local F, C = _G.unpack(private.Aurora)

function private.FrameXML.HelpFrame()
    local r, g, b = C.r, C.g, C.b

    local HelpFrame = _G.HelpFrame
    HelpFrame:DisableDrawLayer("BACKGROUND")
    HelpFrame:DisableDrawLayer("BORDER")
    F.SetBD(HelpFrame)

    HelpFrame.header:Hide()
    F.ReskinClose(_G.HelpFrameCloseButton)

    HelpFrame.leftInset:DisableDrawLayer("BACKGROUND")
    HelpFrame.leftInset:DisableDrawLayer("BORDER")

    HelpFrame.mainInset:DisableDrawLayer("BACKGROUND")
    HelpFrame.mainInset:DisableDrawLayer("BORDER")

    local function styleButton(button)
        F.Reskin(button)
        button.selected:SetTexCoord(0.01953125, 0.65625, 0.67578125, 0.84765625)
        button.selected:SetDesaturated(true)
        button.selected:SetVertexColor(r, g, b)
    end

    for i = 1, 6 do
        styleButton(_G["HelpFrameButton"..i])
    end
    styleButton(_G.HelpFrameButton16)

    -- AccountSecurity
    F.Reskin(HelpFrame.asec.ticketButton)
    F.Reskin(_G.HelpFrameCharacterStuckStuck)

    -- CharacterStuck
    F.Reskin(_G.HelpFrameCharacterStuckStuck)
    _G.HelpFrameCharacterStuckHearthstone:SetSize(56, 56)
    F.ReskinIcon(_G.HelpFrameCharacterStuckHearthstoneIconTexture)

    -- ReportBug
    F.Reskin(HelpFrame.bug.submitButton)
    select(3, HelpFrame.bug:GetChildren()):Hide()

    local bugScrollFrame = _G.HelpFrameReportBugScrollFrame
    F.CreateBD(bugScrollFrame, .25)
    F.ReskinScroll(bugScrollFrame.ScrollBar)
    bugScrollFrame.ScrollBar:SetPoint("TOPLEFT", bugScrollFrame, "TOPRIGHT", -17, -17)
    bugScrollFrame.ScrollBar:SetPoint("BOTTOMLEFT", bugScrollFrame, "BOTTOMRIGHT", -17, 17)

    -- SubmitSuggestion
    F.Reskin(HelpFrame.suggestion.submitButton)
    select(3, HelpFrame.suggestion:GetChildren()):Hide()

    local suggestionScrollFrame = _G.HelpFrameSubmitSuggestionScrollFrame
    F.CreateBD(suggestionScrollFrame, .25)
    F.ReskinScroll(suggestionScrollFrame.ScrollBar)
    suggestionScrollFrame.ScrollBar:SetPoint("TOPLEFT", suggestionScrollFrame, "TOPRIGHT", -17, -17)
    suggestionScrollFrame.ScrollBar:SetPoint("BOTTOMLEFT", suggestionScrollFrame, "BOTTOMRIGHT", -17, 17)


    -- HelpBrowser
    local HelpBrowser = _G.HelpBrowser
    HelpBrowser.BrowserInset:Hide()
    F.CreateBDFrame(HelpBrowser)

    for key, arrow in next, {settings=false, home=false, back = "Left", forward = "Right", reload=false, stop=false} do
        if arrow then
            F.ReskinArrow(HelpBrowser[key], arrow)
        else
            F.Reskin(HelpBrowser[key])
            HelpBrowser[key].Icon:SetDesaturated(true)
        end
        HelpBrowser[key]:SetSize(20, 20)
    end
    HelpBrowser.settings:SetPoint("TOPRIGHT", HelpBrowser, "TOPLEFT", 19, 22)
    HelpBrowser.home:SetPoint("BOTTOMLEFT", HelpBrowser.settings, "BOTTOMRIGHT", 3, 0)
    HelpBrowser.loading:SetPoint("TOPLEFT", HelpBrowser.stop, "TOPRIGHT", -8, 10)

    for i = 1, 9 do
        select(i, _G.BrowserSettingsTooltip:GetRegions()):Hide()
    end

    F.CreateBD(_G.BrowserSettingsTooltip)
    F.Reskin(_G.BrowserSettingsTooltip.CacheButton)
    F.Reskin(_G.BrowserSettingsTooltip.CookiesButton)

    -- TicketStatusFrame
    F.CreateBD(_G.TicketStatusFrameButton)
    _G.TicketStatusFrameIcon:SetTexCoord(.08, .92, .08, .92)

    -- ReportCheatingDialog
    local ReportCheatingDialog = _G.ReportCheatingDialog
    F.CreateBD(ReportCheatingDialog)
    F.CreateBD(ReportCheatingDialog.CommentFrame, .25)
    for i = 1, 9 do
        select(i, ReportCheatingDialog.CommentFrame:GetRegions()):Hide()
    end
    F.Reskin(ReportCheatingDialog.reportButton)
    F.Reskin(_G.ReportCheatingDialogCancelButton)
end
