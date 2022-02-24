local F, C = unpack(select(2, ...))

local function UpdateNewGlow(self)
    if self.NewOutline:IsShown() then
        self.bg:SetBackdropBorderColor(0, .7, .08)
    else
        self.bg:SetBackdropBorderColor(0, 0, 0)
    end
end

local function UpdateIconGlow(self, show)
    if show then
        self.__owner.bg:SetBackdropBorderColor(0, .7, .08)
    else
        self.__owner.bg:SetBackdropBorderColor(0, 0, 0)
    end
end

local function ReskinScrollChild(self)
    for i = 1, self.ScrollTarget:GetNumChildren() do
        local child = select(i, self.ScrollTarget:GetChildren())
        local icon = child and child.Icon
        if icon and not icon.bg then
            icon.bg = F.ReskinIcon(icon)
            child.Background:Hide()
            child.bg = F.CreateBDFrame(child.Background, .25)

            F.Reskin(child.DeleteButton)
            child.DeleteButton:SetSize(20, 20)
            child.FrameHighlight:SetInside(child.bg)
            child.FrameHighlight:SetColorTexture(1, 1, 1, .15) -- 0.25 might be too much

            child.NewOutline:SetTexture('')
            child.BindingText:SetFontObject(_G.Game12Font)
            hooksecurefunc(child, 'Init', UpdateNewGlow)

            local iconHighlight = child.IconHighlight
            iconHighlight:SetTexture('')
            iconHighlight.__owner = icon
            hooksecurefunc(iconHighlight, 'SetShown', UpdateIconGlow)
        end
    end
end

local function UpdateButtonSelection(button, isSelected)
    if isSelected then
        button.bg:SetBackdropBorderColor(1, .8, 0)
    else
        button.bg:SetBackdropBorderColor(0, 0, 0)
    end
end

local function ReskinPortraitIcon(button, texture)
    F.StripTextures(button)
    button.Portrait:SetTexture(texture)
    button.bg = F.ReskinIcon(button.Portrait)
    button.bg:SetBackdropColor(0, 0, 0)
    button.Highlight:SetColorTexture(1, 1, 1, .25)
    button.Highlight:SetInside(button.bg)
    hooksecurefunc(button, 'SetSelectedState', UpdateButtonSelection)
end

C.Themes['Blizzard_ClickBindingUI'] = function()
    local frame = _G.ClickBindingFrame

    F.ReskinPortraitFrame(frame)
    frame.TutorialButton.Ring:Hide()
    frame.TutorialButton:SetPoint('TOPLEFT', frame, 'TOPLEFT', -12, 12)

    F.Reskin(frame.ResetButton)
    F.Reskin(frame.AddBindingButton)
    F.Reskin(frame.SaveButton)
    F.ReskinTrimScroll(frame.ScrollBar)

    frame.ScrollBoxBackground:Hide()
    hooksecurefunc(frame.ScrollBox, 'Update', ReskinScrollChild)

    ReskinPortraitIcon(frame.SpellbookPortrait, 136830)
    ReskinPortraitIcon(frame.MacrosPortrait, 136377)

    frame.TutorialFrame.Bg:Hide()
    frame.TutorialFrame.NineSlice:Hide()
    frame.TutorialFrame.TitleBg:Hide()
    F.SetBD(frame.TutorialFrame)
    F.ReskinClose(frame.TutorialFrame.CloseButton)
end
