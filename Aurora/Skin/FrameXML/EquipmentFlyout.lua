local _, private = ...

-- [[ Core ]]
local F, C = _G.unpack(private.Aurora)

function private.FrameXML.EquipmentFlyout()
    _G.EquipmentFlyoutFrameHighlight:Hide()

    local border = F.CreateBDFrame(_G.EquipmentFlyoutFrame, 0)
    border:SetBackdropBorderColor(1, 1, 1)
    border:SetPoint("TOPLEFT", 2, -2)
    border:SetPoint("BOTTOMRIGHT", -2, 2)

    local navFrame = _G.EquipmentFlyoutFrame.NavigationFrame

    _G.EquipmentFlyoutFrameButtons.bg1:SetAlpha(0)
    _G.EquipmentFlyoutFrameButtons:DisableDrawLayer("ARTWORK")
    _G.Test2:Hide() -- wat

    navFrame:SetWidth(204)
    navFrame:SetPoint("TOPLEFT", _G.EquipmentFlyoutFrameButtons, "BOTTOMLEFT", 1, 0)

    _G.hooksecurefunc("EquipmentFlyout_CreateButton", function()
        local bu = _G.EquipmentFlyoutFrame.buttons[#_G.EquipmentFlyoutFrame.buttons]
        local iconBorder = bu.IconBorder

        bu:SetNormalTexture("")
        bu:SetPushedTexture("")
        F.CreateBG(bu)

        iconBorder:SetTexture(C.media.backdrop)
        iconBorder:SetPoint("TOPLEFT", -1, 1)
        iconBorder:SetPoint("BOTTOMRIGHT", 1, -1)
        iconBorder:SetDrawLayer("BACKGROUND", 1)

        bu.icon:SetTexCoord(.08, .92, .08, .92)
    end)

    F.CreateBD(_G.EquipmentFlyoutFrame.NavigationFrame)
    F.ReskinArrow(_G.EquipmentFlyoutFrame.NavigationFrame.PrevButton, "Left")
    F.ReskinArrow(_G.EquipmentFlyoutFrame.NavigationFrame.NextButton, "Right")
end
