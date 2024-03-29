local F, C = unpack(select(2, ...))

tinsert(C.BlizzThemes, function()
    if not _G.ANDROMEDA_ADB.ReskinBlizz then
        return
    end

    local EquipmentFlyoutFrame = _G.EquipmentFlyoutFrame
    local EquipmentFlyoutFrameButtons = _G.EquipmentFlyoutFrameButtons

    hooksecurefunc('EquipmentFlyout_CreateButton', function()
        local button = EquipmentFlyoutFrame.buttons[#EquipmentFlyoutFrame.buttons]

        button:SetNormalTexture(0)
        button:SetPushedTexture(0)
        button:GetHighlightTexture():SetColorTexture(1, 1, 1, 0.25)
        button.bg = F.ReskinIcon(button.icon)
        F.ReskinIconBorder(button.IconBorder)
    end)

    hooksecurefunc('EquipmentFlyout_DisplayButton', function(button)
        local location = button.location
        local border = button.IconBorder
        if not location or not border then
            return
        end

        border:SetShown(location < _G.EQUIPMENTFLYOUT_FIRST_SPECIAL_LOCATION)
    end)

    hooksecurefunc('EquipmentFlyout_UpdateItems', function()
        local frame = EquipmentFlyoutFrame.buttonFrame
        if not frame.bg then
            frame.bg = F.SetBD(EquipmentFlyoutFrame.buttonFrame)
        end
        frame:SetWidth(frame:GetWidth() + 3)
    end)

    EquipmentFlyoutFrameButtons.bg1:SetAlpha(0)
    EquipmentFlyoutFrameButtons:DisableDrawLayer('ARTWORK')

    local navigationFrame = EquipmentFlyoutFrame.NavigationFrame
    F.SetBD(navigationFrame)
    navigationFrame:SetPoint('TOPLEFT', EquipmentFlyoutFrameButtons, 'BOTTOMLEFT', 0, -3)
    navigationFrame:SetPoint('TOPRIGHT', EquipmentFlyoutFrameButtons, 'BOTTOMRIGHT', 0, -3)
    F.ReskinArrow(navigationFrame.PrevButton, 'left')
    F.ReskinArrow(navigationFrame.NextButton, 'right')
    navigationFrame.BottomBackground:Hide()
end)
