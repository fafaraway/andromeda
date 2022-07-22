local F, C = unpack(select(2, ...))

local function reskinPanelSection(frame)
    F.StripTextures(frame)
    F.CreateBDFrame(frame, 0.25)
    _G[frame:GetName() .. 'Title']:SetPoint('BOTTOMLEFT', frame, 'TOPLEFT', 5, 2)
end

tinsert(C.BlizzThemes, function()
    local styledOptions = false

    _G.VideoOptionsFrame:HookScript('OnShow', function()
        if styledOptions then
            return
        end

        F.StripTextures(_G.VideoOptionsFrameCategoryFrame)
        F.StripTextures(_G.VideoOptionsFramePanelContainer)
        F.StripTextures(_G.VideoOptionsFrame.Header)
        _G.VideoOptionsFrame.Header:ClearAllPoints()
        _G.VideoOptionsFrame.Header:SetPoint('TOP', _G.VideoOptionsFrame, 0, 0)

        F.SetBD(_G.VideoOptionsFrame)
        _G.VideoOptionsFrame.Border:Hide()
        F.Reskin(_G.VideoOptionsFrameOkay)
        F.Reskin(_G.VideoOptionsFrameCancel)
        F.Reskin(_G.VideoOptionsFrameDefaults)
        F.Reskin(_G.VideoOptionsFrameApply)

        local line = _G.VideoOptionsFrame:CreateTexture(nil, 'ARTWORK')
        line:SetSize(C.MULT, 512)
        line:SetPoint('LEFT', 205, 30)
        line:SetColorTexture(1, 1, 1, 0.25)

        _G.Display_:HideBackdrop()
        _G.Graphics_:HideBackdrop()
        _G.RaidGraphics_:HideBackdrop()

        _G.GraphicsButton:DisableDrawLayer('BACKGROUND')
        _G.RaidButton:DisableDrawLayer('BACKGROUND')

        reskinPanelSection(_G.AudioOptionsSoundPanelPlayback)
        reskinPanelSection(_G.AudioOptionsSoundPanelHardware)
        reskinPanelSection(_G.AudioOptionsSoundPanelVolume)

        local hline = _G.Display_:CreateTexture(nil, 'ARTWORK')
        hline:SetSize(580, C.MULT)
        hline:SetPoint('TOPLEFT', _G.GraphicsButton, 'BOTTOMLEFT', 14, -4)
        hline:SetColorTexture(1, 1, 1, 0.2)

        local videoPanels = {
            'Display_',
            'Graphics_',
            'RaidGraphics_',
            'Advanced_',
            'NetworkOptionsPanel',
            'InterfaceOptionsLanguagesPanel',
            'AudioOptionsSoundPanel',
            'AudioOptionsVoicePanel',
        }

        for _, name in pairs(videoPanels) do
            local frame = _G[name]
            if frame then
                for i = 1, frame:GetNumChildren() do
                    local child = select(i, frame:GetChildren())
                    if child:IsObjectType('CheckButton') then
                        F.ReskinCheckbox(child)
                    elseif child:IsObjectType('Button') then
                        F.Reskin(child)
                    elseif child:IsObjectType('Slider') then
                        F.ReskinSlider(child)
                    elseif child:IsObjectType('Frame') and child.Left and child.Middle and child.Right then
                        F.ReskinDropDown(child)
                    end
                end
            else
                if C.IS_DEVELOPER then
                    print(name, 'not found.')
                end
            end
        end

        local testInputDevie = _G.AudioOptionsVoicePanelTestInputDevice
        F.Reskin(testInputDevie.ToggleTest)
        F.StripTextures(testInputDevie.VUMeter)
        testInputDevie.VUMeter.Status:SetStatusBarTexture(C.Assets.Textures.Backdrop)
        local bg = F.CreateBDFrame(testInputDevie.VUMeter, 0.3)
        bg:SetInside(nil, 4, 4)

        styledOptions = true
    end)

    hooksecurefunc('AudioOptionsVoicePanel_InitializeCommunicationModeUI', function(self)
        if not self.styled then
            F.Reskin(self.PushToTalkKeybindButton)
            self.styled = true
        end
    end)
end)
