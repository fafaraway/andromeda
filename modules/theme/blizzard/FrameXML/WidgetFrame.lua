local F, C = unpack(select(2, ...))

-- Credit: ShestakUI
local atlasColors = {
	["UI-Frame-Bar-Fill-Blue"] = {.2, .6, 1},
	["UI-Frame-Bar-Fill-Red"] = {.9, .2, .2},
	["UI-Frame-Bar-Fill-Yellow"] = {1, .6, 0},
	["objectivewidget-bar-fill-left"] = {.2, .6, 1},
	["objectivewidget-bar-fill-right"] = {.9, .2, .2},
	["EmberCourtScenario-Tracker-barfill"] = {.9, .2, .2},
}

function F:ReplaceWidgetBarTexture(atlas)
	if atlasColors[atlas] then
		self:SetStatusBarTexture(C.Assets.norm_tex)
		self:SetStatusBarColor(unpack(atlasColors[atlas]))
	end
end

local function ReskinWidgetStatusBar(bar)
	if bar and not bar.styled then
		if bar.BG then bar.BG:SetAlpha(0) end
		if bar.BGLeft then bar.BGLeft:SetAlpha(0) end
		if bar.BGRight then bar.BGRight:SetAlpha(0) end
		if bar.BGCenter then bar.BGCenter:SetAlpha(0) end
		if bar.BorderLeft then bar.BorderLeft:SetAlpha(0) end
		if bar.BorderRight then bar.BorderRight:SetAlpha(0) end
		if bar.BorderCenter then bar.BorderCenter:SetAlpha(0) end
		if bar.Spark then bar.Spark:SetAlpha(0) end
		if bar.SparkGlow then bar.SparkGlow:SetAlpha(0) end
		if bar.BorderGlow then bar.BorderGlow:SetAlpha(0) end
		F.SetBD(bar)
		hooksecurefunc(bar, "SetStatusBarAtlas", F.ReplaceWidgetBarTexture)

		bar.styled = true
	end
end

local Type_StatusBar = _G.Enum.UIWidgetVisualizationType.StatusBar
local Type_SpellDisplay = _G.Enum.UIWidgetVisualizationType.SpellDisplay
local Type_DoubleStatusBar = _G.Enum.UIWidgetVisualizationType.DoubleStatusBar

local function ReskinWidgetFrames()
	for _, widgetFrame in pairs(_G.UIWidgetTopCenterContainerFrame.widgetFrames) do
		local widgetType = widgetFrame.widgetType
		if widgetType == Type_DoubleStatusBar then
			if not widgetFrame.styled then
				ReskinWidgetStatusBar(widgetFrame.LeftBar)
				ReskinWidgetStatusBar(widgetFrame.RightBar)

				widgetFrame.styled = true
			end
		elseif widgetType == Type_SpellDisplay then
			if not widgetFrame.styled then
				local widgetSpell = widgetFrame.Spell
				widgetSpell.IconMask:Hide()
				widgetSpell.Border:SetTexture(nil)
				widgetSpell.DebuffBorder:SetTexture(nil)
				F.ReskinIcon(widgetSpell.Icon)

				widgetFrame.styled = true
			end
		elseif widgetType == Type_StatusBar then
			ReskinWidgetStatusBar(widgetFrame.Bar)
		end
	end
end

tinsert(C.BlizzThemes, function()
	if not _G.FREE_ADB.ReskinBlizz then return end

	F:RegisterEvent("PLAYER_ENTERING_WORLD", ReskinWidgetFrames)
	F:RegisterEvent("UPDATE_ALL_UI_WIDGETS", ReskinWidgetFrames)

	hooksecurefunc(_G.UIWidgetTemplateStatusBarMixin, "Setup", function(self)
		ReskinWidgetStatusBar(self.Bar)
	end)

	hooksecurefunc(_G.UIWidgetTemplateCaptureBarMixin, "Setup", function(self)
		self.LeftLine:SetAlpha(0)
		self.RightLine:SetAlpha(0)
		self.BarBackground:SetAlpha(0)
		self.Glow1:SetAlpha(0)
		self.Glow2:SetAlpha(0)
		self.Glow3:SetAlpha(0)

		self.LeftBar:SetTexture(C.Assets.norm_tex)
		self.NeutralBar:SetTexture(C.Assets.norm_tex)
		self.RightBar:SetTexture(C.Assets.norm_tex)

		self.LeftBar:SetVertexColor(.2, .6, 1)
		self.NeutralBar:SetVertexColor(.8, .8, .8)
		self.RightBar:SetVertexColor(.9, .2, .2)

		if not self.bg then
			self.bg = F.SetBD(self)
			self.bg:SetPoint("TOPLEFT", self.LeftBar, -2, 2)
			self.bg:SetPoint("BOTTOMRIGHT", self.RightBar, 2, -2)
		end
	end)
end)
