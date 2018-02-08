local _, private = ...

-- [[ Lua Globals ]]
local next = _G.next

-- [[ Core ]]
local F = _G.unpack(private.Aurora)

function private.FrameXML.VideoOptionsFrame()
    _G.VideoOptionsFrameCategoryFrame:DisableDrawLayer("BACKGROUND")
    _G.VideoOptionsFramePanelContainer:DisableDrawLayer("BORDER")

    _G.VideoOptionsFrameHeader:SetTexture("")
    _G.VideoOptionsFrameHeader:ClearAllPoints()
    _G.VideoOptionsFrameHeader:SetPoint("TOP", _G.VideoOptionsFrame, 0, 0)

    F.CreateBD(_G.VideoOptionsFrame)
    F.Reskin(_G.VideoOptionsFrameOkay)
    F.Reskin(_G.VideoOptionsFrameCancel)
    F.Reskin(_G.VideoOptionsFrameDefaults)
    F.Reskin(_G.VideoOptionsFrameApply)

    _G.VideoOptionsFrameOkay:SetPoint("BOTTOMRIGHT", _G.VideoOptionsFrameCancel, "BOTTOMLEFT", -1, 0)

    local styledOptions = false
    _G.VideoOptionsFrame:HookScript("OnShow", function()
        if styledOptions then return end

        local line = _G.VideoOptionsFrame:CreateTexture(nil, "ARTWORK")
        line:SetSize(1, 512)
        line:SetPoint("LEFT", 205, 30)
        line:SetColorTexture(1, 1, 1, .2)
        local groups, checkboxes, dropdowns, sliders

        --[[ Graphics ]]--

        -- Display
        _G.Display_:SetBackdrop(nil)
        local hline = _G.Display_:CreateTexture(nil, "ARTWORK")
        hline:SetSize(580, 1)
        hline:SetPoint("TOPLEFT", _G.GraphicsButton, "BOTTOMLEFT", 14, -4)
        hline:SetColorTexture(1, 1, 1, .2)

        dropdowns = {"Display_DisplayModeDropDown", "Display_ResolutionDropDown", "Display_RefreshDropDown", "Display_PrimaryMonitorDropDown", "Display_AntiAliasingDropDown", "Display_VerticalSyncDropDown"}
        for i = 1, #dropdowns do
            F.ReskinDropDown(_G[dropdowns[i]])
        end

        _G.GraphicsButton:DisableDrawLayer("BACKGROUND")
        _G.RaidButton:DisableDrawLayer("BACKGROUND")
        F.ReskinCheck(_G.Display_RaidSettingsEnabledCheckBox)

        -- Graphics Settings
        for _, graphicsGroup in next, {"Graphics_", "RaidGraphics_"} do
            _G[graphicsGroup]:SetBackdrop(nil)

            dropdowns = {"TextureResolutionDropDown", "FilteringDropDown", "ProjectedTexturesDropDown",
                        "ShadowsDropDown", "LiquidDetailDropDown", "SunshaftsDropDown", "ParticleDensityDropDown", "SSAODropDown", "DepthEffectsDropDown", "LightingQualityDropDown", "OutlineModeDropDown"}
            for i = 1, #dropdowns do
                F.ReskinDropDown(_G[graphicsGroup..dropdowns[i]])
            end
            sliders = {"Quality", "ViewDistanceSlider", "EnvironmentalDetailSlider", "GroundClutterSlider"}
            for i = 1, #sliders do
                F.ReskinSlider(_G[graphicsGroup..sliders[i]])
            end
        end

        --[[ Advanced ]]--
        checkboxes = {"Advanced_UseUIScale", "Advanced_MaxFPSCheckBox", "Advanced_MaxFPSBKCheckBox", "Advanced_ShowHDModels"}
        if not private.isPatch then
            _G.tinsert(checkboxes, "Advanced_DesktopGamma")
        end
        for i = 1, #checkboxes do
            F.ReskinCheck(_G[checkboxes[i]])
        end
        dropdowns = {"Advanced_BufferingDropDown", "Advanced_LagDropDown", "Advanced_HardwareCursorDropDown", "Advanced_MultisampleAntiAliasingDropDown", "Advanced_MultisampleAlphaTest", "Advanced_PostProcessAntiAliasingDropDown", "Advanced_ResampleQualityDropDown", "Advanced_GraphicsAPIDropDown", "Advanced_PhysicsInteractionDropDown"}
        for i = 1, #dropdowns do
            F.ReskinDropDown(_G[dropdowns[i]])
        end
        sliders = {"Advanced_UIScaleSlider", "Advanced_MaxFPSSlider", "Advanced_MaxFPSBKSlider", "Advanced_RenderScaleSlider"}
        if not private.isPatch then
            _G.tinsert(sliders, "Advanced_GammaSlider")
        end
        for i = 1, #sliders do
            F.ReskinSlider(_G[sliders[i]])
        end

        --[[ Network ]]--
        checkboxes = {"NetworkOptionsPanelOptimizeSpeed", "NetworkOptionsPanelUseIPv6", "NetworkOptionsPanelAdvancedCombatLogging"}
        for i = 1, #checkboxes do
            F.ReskinCheck(_G[checkboxes[i]])
        end

        --[[ Languages ]]--
        F.ReskinDropDown(_G.InterfaceOptionsLanguagesPanelLocaleDropDown)
        F.ReskinDropDown(_G.InterfaceOptionsLanguagesPanelAudioLocaleDropDown)

        --[[ Sound ]]--
        groups = {"AudioOptionsSoundPanelPlayback", "AudioOptionsSoundPanelHardware", "AudioOptionsSoundPanelVolume"}
        for i = 1, #groups do
            local group = _G[groups[i]]
            F.CreateBD(group, .25)
            _G[groups[i].."Title"]:SetPoint("BOTTOMLEFT", group, "TOPLEFT", 5, 2)
        end
        checkboxes = {"AudioOptionsSoundPanelEnableSound", "AudioOptionsSoundPanelSoundEffects", "AudioOptionsSoundPanelErrorSpeech", "AudioOptionsSoundPanelEmoteSounds", "AudioOptionsSoundPanelPetSounds", "AudioOptionsSoundPanelMusic", "AudioOptionsSoundPanelLoopMusic", "AudioOptionsSoundPanelPetBattleMusic", "AudioOptionsSoundPanelAmbientSounds", "AudioOptionsSoundPanelDialogSounds", "AudioOptionsSoundPanelSoundInBG", "AudioOptionsSoundPanelReverb", "AudioOptionsSoundPanelHRTF", "AudioOptionsSoundPanelEnableDSPs"}
        for i = 1, #checkboxes do
            F.ReskinCheck(_G[checkboxes[i]])
        end
        dropdowns = {"AudioOptionsSoundPanelHardwareDropDown", "AudioOptionsSoundPanelSoundChannelsDropDown", "AudioOptionsSoundPanelSoundCacheSizeDropDown"}
        for i = 1, #dropdowns do
            F.ReskinDropDown(_G[dropdowns[i]])
        end
        sliders = {"AudioOptionsSoundPanelMasterVolume", "AudioOptionsSoundPanelSoundVolume", "AudioOptionsSoundPanelMusicVolume", "AudioOptionsSoundPanelAmbienceVolume", "AudioOptionsSoundPanelDialogVolume"}
        for i = 1, #sliders do
            F.ReskinSlider(_G[sliders[i]])
        end

        styledOptions = true
    end)
end
