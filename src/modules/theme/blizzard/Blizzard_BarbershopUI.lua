local F, C = unpack(select(2, ...))

C.Themes['Blizzard_BarbershopUI'] = function()
    local frame = _G.BarberShopFrame

    F.ReskinButton(frame.AcceptButton)
    F.ReskinButton(frame.CancelButton)
    F.ReskinButton(frame.ResetButton)
end

local function ReskinCustomizeButton(button)
    F.ReskinButton(button)
    button.__bg:SetInside(nil, 5, 5)
end

local function ReskinCustomizeTooltip(tooltip)
    F:GetModule('Tooltip').ReskinTooltip(tooltip)
    tooltip:SetScale(_G.UIParent:GetScale())
end

local function ReskinCustomizeArrow(button, direction)
    F.StripTextures(button, 0)

    local tex = button:CreateTexture(nil, 'ARTWORK')
    tex:SetInside(button, 3, 3)
    F.SetupArrow(tex, direction)
    button.__texture = tex

    button:HookScript('OnEnter', F.Texture_OnEnter)
    button:HookScript('OnLeave', F.Texture_OnLeave)
end

C.Themes['Blizzard_CharacterCustomize'] = function()
    local frame = _G.CharCustomizeFrame

    ReskinCustomizeButton(frame.SmallButtons.ResetCameraButton)
    ReskinCustomizeButton(frame.SmallButtons.ZoomOutButton)
    ReskinCustomizeButton(frame.SmallButtons.ZoomInButton)
    ReskinCustomizeButton(frame.SmallButtons.RotateLeftButton)
    ReskinCustomizeButton(frame.SmallButtons.RotateRightButton)
    ReskinCustomizeButton(frame.RandomizeAppearanceButton)

    hooksecurefunc(frame, 'UpdateOptionButtons', function(self)
        for button in self.selectionPopoutPool:EnumerateActive() do
            if not button.styled then
                ReskinCustomizeArrow(button.DecrementButton, 'left')
                ReskinCustomizeArrow(button.IncrementButton, 'right')

                local popoutButton = button.Button
                popoutButton.HighlightTexture:SetAlpha(0)
                popoutButton.NormalTexture:SetAlpha(0)
                ReskinCustomizeButton(popoutButton)
                F.StripTextures(popoutButton.Popout)
                local bg = F.SetBD(popoutButton.Popout, 1)
                bg:SetFrameLevel(popoutButton.Popout:GetFrameLevel())

                button.styled = true
            end
        end

        local optionPool = self.pools:GetPool('CharCustomizeOptionCheckButtonTemplate')
        for button in optionPool:EnumerateActive() do
            if not button.styled then
                F.ReskinCheckbox(button.Button)
                button.styled = true
            end
        end
    end)

    ReskinCustomizeTooltip(_G.CharCustomizeTooltip)
    ReskinCustomizeTooltip(_G.CharCustomizeNoHeaderTooltip)
end
