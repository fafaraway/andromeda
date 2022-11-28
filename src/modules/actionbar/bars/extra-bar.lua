local F, C, L = unpack(select(2, ...))
local ACTIONBAR = F:GetModule('ActionBar')

function ACTIONBAR:CreateExtraBar()
    local padding = C.DB['Actionbar']['BarPadding']
    local buttonList = {}
    local size = C.DB['Actionbar']['BarExtraButtonSize']

    -- ExtraActionButton
    local frame = CreateFrame('Frame', C.ADDON_TITLE .. 'ActionBarExtra', _G.UIParent, 'SecureHandlerStateTemplate')
    frame:SetWidth(size + 2 * padding)
    frame:SetHeight(size + 2 * padding)
    frame.mover = F.Mover(frame, L['ExtraBar'], 'ExtraBar', { 'BOTTOM', _G.UIParent, 'BOTTOM', 250, 100 })

    local ExtraActionBarFrame = _G.ExtraActionBarFrame
    ExtraActionBarFrame:EnableMouse(false)
    ExtraActionBarFrame:ClearAllPoints()
    ExtraActionBarFrame:SetPoint('CENTER', frame)
    ExtraActionBarFrame.ignoreFramePositionManager = true

    hooksecurefunc(ExtraActionBarFrame, 'SetParent', function(self, parent)
        if parent == _G.ExtraAbilityContainer then
            self:SetParent(frame)
        end
    end)

    local button = _G.ExtraActionButton1
    tinsert(buttonList, button)
    tinsert(ACTIONBAR.buttons, button)
    button:SetSize(size, size)

    frame.frameVisibility = '[extrabar] show; hide'
    RegisterStateDriver(frame, 'visibility', frame.frameVisibility)

    -- ZoneAbility
    local zoneFrame = CreateFrame('Frame', C.ADDON_TITLE .. 'ActionBarZone', _G.UIParent)
    zoneFrame:SetWidth(size + 2 * padding)
    zoneFrame:SetHeight(size + 2 * padding)
    zoneFrame.mover = F.Mover(zoneFrame, L['ZoneAbility'], 'ZoneAbility', { 'BOTTOM', _G.UIParent, 'BOTTOM', -250, 100 })

    local ZoneAbilityFrame = _G.ZoneAbilityFrame
    ZoneAbilityFrame:SetParent(zoneFrame)
    ZoneAbilityFrame:ClearAllPoints()
    ZoneAbilityFrame:SetPoint('CENTER', zoneFrame)
    ZoneAbilityFrame.ignoreFramePositionManager = true
    ZoneAbilityFrame.Style:SetAlpha(0)

    hooksecurefunc(ZoneAbilityFrame, 'UpdateDisplayedZoneAbilities', function(self)
        for spellButton in self.SpellButtonContainer:EnumerateActive() do
            if spellButton and not spellButton.styled then
                spellButton.NormalTexture:SetAlpha(0)
                spellButton:SetPushedTexture(C.Assets.Textures.ButtonPushed) --force it to gain a texture
                spellButton:GetHighlightTexture():SetColorTexture(1, 1, 1, 0.25)
                spellButton:GetHighlightTexture():SetInside()
                spellButton.Icon:SetInside()
                F.ReskinIcon(spellButton.Icon, true)
                spellButton.styled = true
            end
        end
    end)

    -- Fix button visibility
    hooksecurefunc(ZoneAbilityFrame, 'SetParent', function(self, parent)
        if parent == _G.ExtraAbilityContainer then
            self:SetParent(zoneFrame)
        end
    end)
end
