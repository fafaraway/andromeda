local _, private = ...

-- [[ Core ]]
local Aurora = private.Aurora
local Base, Hook, Skin = Aurora.Base, Aurora.Hook, Aurora.Skin
local F = _G.unpack(private.Aurora)

do --[[ FrameXML\PVPHelper.lua ]]
    function Hook.PVPReadyDialog_Display(self, index, displayName, isRated, queueType, gameType, role)
        Base.SetTexture(self.roleIcon.texture, "role"..role)
    end
end

function private.FrameXML.PVPHelper()
    _G.hooksecurefunc("PVPReadyDialog_Display", Hook.PVPReadyDialog_Display)

    --[[ PVPFramePopup ]]--

    --[[ PVPRoleCheckPopup ]]--

    --[[ PVPReadyDialog ]]--
    local PVPReadyDialog = _G.PVPReadyDialog
    Base.SetBackdrop(PVPReadyDialog)
    F.CreateBD(_G.PVPReadyDialog)
    F.CreateSD(_G.PVPReadyDialog)

    PVPReadyDialog.background:SetAlpha(0.75)
    PVPReadyDialog.background:ClearAllPoints()
    PVPReadyDialog.background:SetPoint("TOPLEFT")
    PVPReadyDialog.background:SetPoint("BOTTOMRIGHT", 0, 68)

    PVPReadyDialog.filigree:Hide()
    PVPReadyDialog.bottomArt:Hide()

    do
        local button = _G["PVPReadyDialogCloseButton"]
        button:SetSize(17, 17)
        button:SetNormalTexture("")
        button:SetHighlightTexture("")
        button:SetPushedTexture("")

        Base.SetBackdrop(button, Aurora.buttonColor:GetRGBA())

        button._auroraHighlight = {}
        local hline = button:CreateTexture()
        hline:SetColorTexture(1, 1, 1)
        hline:SetSize(7, 1)
        hline:SetPoint("BOTTOM", 0, 4)
        _G.tinsert(button._auroraHighlight, hline)
        Base.SetHighlight(button, "color")
    end

    -- Skin.UIPanelButtonTemplate(PVPReadyDialog.enterButton)
    -- Skin.UIPanelButtonTemplate(PVPReadyDialog.leaveButton)

    F.Reskin(PVPReadyDialog.enterButton)
    F.Reskin(PVPReadyDialog.leaveButton)

    PVPReadyDialog.roleIcon:SetSize(64, 64)
end
