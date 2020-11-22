local F, C = unpack(select(2, ...))

tinsert(C.BlizzThemes, function()
	if not FREE_ADB.reskin_blizz then return end

	F.StripTextures(VideoOptionsFrameCategoryFrame)
	F.StripTextures(VideoOptionsFramePanelContainer)
	F.StripTextures(VideoOptionsFrame.Header)
	VideoOptionsFrame.Header:ClearAllPoints()
	VideoOptionsFrame.Header:SetPoint("TOP", VideoOptionsFrame, 0, 0)

	F.SetBD(VideoOptionsFrame)
	VideoOptionsFrame.Border:Hide()
	F.Reskin(VideoOptionsFrameOkay)
	F.Reskin(VideoOptionsFrameCancel)
	F.Reskin(VideoOptionsFrameDefaults)
	F.Reskin(VideoOptionsFrameApply)

	VideoOptionsFrameOkay:SetPoint("BOTTOMRIGHT", VideoOptionsFrameCancel, "BOTTOMLEFT", -1, 0)

	local styledOptions = false
	VideoOptionsFrame:HookScript("OnShow", function()
		if styledOptions then return end

		local line = VideoOptionsFrame:CreateTexture(nil, "ARTWORK")
		line:SetSize(C.Mult, 512)
		line:SetPoint("LEFT", 205, 30)
		line:SetColorTexture(1, 1, 1, .25)

		Display_:SetBackdrop(nil)
		Graphics_:SetBackdrop(nil)
		RaidGraphics_:SetBackdrop(nil)

		GraphicsButton:DisableDrawLayer("BACKGROUND")
		RaidButton:DisableDrawLayer("BACKGROUND")

		local hline = Display_:CreateTexture(nil, "ARTWORK")
		hline:SetSize(580, C.Mult)
		hline:SetPoint("TOPLEFT", GraphicsButton, "BOTTOMLEFT", 14, -4)
		hline:SetColorTexture(1, 1, 1, .2)

		F.StripTextures(AudioOptionsSoundPanelPlayback)
		F.CreateBDFrame(AudioOptionsSoundPanelPlayback, .25)
		F.StripTextures(AudioOptionsSoundPanelHardware)
		F.CreateBDFrame(AudioOptionsSoundPanelHardware, .25)
		F.StripTextures(AudioOptionsSoundPanelVolume)
		F.CreateBDFrame(AudioOptionsSoundPanelVolume, .25)

		AudioOptionsSoundPanelPlaybackTitle:SetPoint("BOTTOMLEFT", AudioOptionsSoundPanelPlayback, "TOPLEFT", 5, 2)
		AudioOptionsSoundPanelHardwareTitle:SetPoint("BOTTOMLEFT", AudioOptionsSoundPanelHardware, "TOPLEFT", 5, 2)
		AudioOptionsSoundPanelVolumeTitle:SetPoint("BOTTOMLEFT", AudioOptionsSoundPanelVolume, "TOPLEFT", 5, 2)

		local dropdowns = {
			"Display_DisplayModeDropDown",
			"Display_ResolutionDropDown",
			"Display_PrimaryMonitorDropDown",
			"Display_AntiAliasingDropDown",
			"Display_VerticalSyncDropDown",
			"Graphics_TextureResolutionDropDown",
			"Graphics_SpellDensityDropDown",
			"Graphics_ProjectedTexturesDropDown",
			"Graphics_ShadowsDropDown",
			"Graphics_LiquidDetailDropDown",
			"Graphics_SunshaftsDropDown",
			"Graphics_ParticleDensityDropDown",
			"Graphics_SSAODropDown",
			"Graphics_DepthEffectsDropDown",
			"Graphics_OutlineModeDropDown",
			"RaidGraphics_TextureResolutionDropDown",
			"RaidGraphics_SpellDensityDropDown",
			"RaidGraphics_ProjectedTexturesDropDown",
			"RaidGraphics_ShadowsDropDown",
			"RaidGraphics_LiquidDetailDropDown",
			"RaidGraphics_SunshaftsDropDown",
			"RaidGraphics_ParticleDensityDropDown",
			"RaidGraphics_SSAODropDown",
			"RaidGraphics_DepthEffectsDropDown",
			"RaidGraphics_OutlineModeDropDown",
			"Advanced_BufferingDropDown",
			"Advanced_FilteringDropDown",
			"Advanced_RTShadowQualityDropDown",
			"Advanced_SSAOTypeDropDown",
			"Advanced_MultisampleAntiAliasingDropDown",
			"Advanced_MultisampleAlphaTest",
			"Advanced_PostProcessAntiAliasingDropDown",
			"Advanced_ResampleQualityDropDown",
			"Advanced_PhysicsInteractionDropDown",
			"Advanced_AdapterDropDown",
			"Advanced_GraphicsAPIDropDown",
			"AudioOptionsSoundPanelHardwareDropDown",
			"AudioOptionsSoundPanelSoundChannelsDropDown",
			"AudioOptionsSoundPanelSoundCacheSizeDropDown",
			"AudioOptionsVoicePanelOutputDeviceDropdown",
			"AudioOptionsVoicePanelMicDeviceDropdown",
			"AudioOptionsVoicePanelChatModeDropdown",
			"InterfaceOptionsLanguagesPanelLocaleDropDown",
			"InterfaceOptionsLanguagesPanelAudioLocaleDropDown"
		}
		for i = 1, #dropdowns do
			local dropdown = _G[dropdowns[i]]
			if not dropdown then
				if C.isDeveloper then print(dropdowns[i], "not found.") end
			else
				F.ReskinDropDown(dropdown)
			end
		end

		local sliders = {
			"Display_RenderScaleSlider",
			"Display_UIScaleSlider",
			"Graphics_Quality",
			"Graphics_ViewDistanceSlider",
			"Graphics_EnvironmentalDetailSlider",
			"Graphics_GroundClutterSlider",
			"RaidGraphics_Quality",
			"RaidGraphics_ViewDistanceSlider",
			"RaidGraphics_EnvironmentalDetailSlider",
			"RaidGraphics_GroundClutterSlider",
			"Advanced_MaxFPSSlider",
			"Advanced_MaxFPSBKSlider",
			"Advanced_TargetFPSSlider",
			"Advanced_GammaSlider",
			"Advanced_ContrastSlider",
			"Advanced_BrightnessSlider",
			"AudioOptionsSoundPanelMasterVolume",
			"AudioOptionsSoundPanelSoundVolume",
			"AudioOptionsSoundPanelMusicVolume",
			"AudioOptionsSoundPanelAmbienceVolume",
			"AudioOptionsSoundPanelDialogVolume",
			"AudioOptionsVoicePanelVoiceChatVolume",
			"AudioOptionsVoicePanelVoiceChatDucking",
			"AudioOptionsVoicePanelVoiceChatMicVolume",
			"AudioOptionsVoicePanelVoiceChatMicSensitivity",
		}
		for i = 1, #sliders do
			local slider = _G[sliders[i]]
			if not slider then
				if C.isDeveloper then print(sliders[i], "not found.") end
			else
				F.ReskinSlider(slider)
			end
		end

		local checkboxes = {
			"Display_UseUIScale",
			"Display_RaidSettingsEnabledCheckBox",
			"Advanced_MaxFPSCheckBox",
			"Advanced_MaxFPSBKCheckBox",
			"Advanced_TargetFPSCheckBox",
			"NetworkOptionsPanelOptimizeSpeed",
			"NetworkOptionsPanelUseIPv6",
			"NetworkOptionsPanelAdvancedCombatLogging",
			"AudioOptionsSoundPanelEnableSound",
			"AudioOptionsSoundPanelSoundEffects",
			"AudioOptionsSoundPanelErrorSpeech",
			"AudioOptionsSoundPanelEmoteSounds",
			"AudioOptionsSoundPanelPetSounds",
			"AudioOptionsSoundPanelMusic",
			"AudioOptionsSoundPanelLoopMusic",
			"AudioOptionsSoundPanelPetBattleMusic",
			"AudioOptionsSoundPanelAmbientSounds",
			"AudioOptionsSoundPanelDialogSounds",
			"AudioOptionsSoundPanelSoundInBG",
			"AudioOptionsSoundPanelReverb",
			"AudioOptionsSoundPanelHRTF",
		}
		for i = 1, #checkboxes do
			local checkbox = _G[checkboxes[i]]
			if not checkbox then
				if C.isDeveloper then print(checkbox[i], "not found.") end
			else
				F.ReskinCheck(checkbox)
			end
		end

		local testInputDevie = AudioOptionsVoicePanelTestInputDevice
		F.Reskin(testInputDevie.ToggleTest)
		F.StripTextures(testInputDevie.VUMeter)
		testInputDevie.VUMeter.Status:SetStatusBarTexture(C.Assets.bd_tex)
		local bg = F.CreateBDFrame(testInputDevie.VUMeter, .3)
		bg:SetPoint("TOPLEFT", 4, -4)
		bg:SetPoint("BOTTOMRIGHT", -4, 4)

		styledOptions = true
	end)

	hooksecurefunc("AudioOptionsVoicePanel_InitializeCommunicationModeUI", function(self)
		if not self.styled then
			F.Reskin(self.PushToTalkKeybindButton)
			self.styled = true
		end
	end)

	-- Deprecated
	F.StripTextures(AudioOptionsFrame.Header)
	AudioOptionsFrame.Header:ClearAllPoints()
	AudioOptionsFrame.Header:SetPoint("TOP", AudioOptionsFrame, 0, 0)
	F.SetBD(AudioOptionsFrame)
	F.Reskin(AudioOptionsFrameOkay)
	F.Reskin(AudioOptionsFrameCancel)
	F.Reskin(AudioOptionsFrameDefaults)
end)
