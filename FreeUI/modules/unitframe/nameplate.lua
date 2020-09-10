local F, C, L = unpack(select(2, ...))
local UNITFRAME = F.UNITFRAME
local oUF = F.oUF


local playerColor = RAID_CLASS_COLORS[select(2, UnitClass('player'))]

local function CreateBackdrop(frame)
   frame:SetBackdrop({bgFile = 'Interface\\Buttons\\WHITE8x8',
		insets = {top = -2, left = -2, bottom = -2, right = -2}})
		frame:SetBackdropColor(0,0,0,0.75)
		frame:SetBackdropBorderColor(0,0,0,1)
end


oUF:RegisterStyle('oUF_Nameplates', function(frame, unit)
	-----------------
	--  Mouse Code --
	-----------------
	frame:SetScript('OnEnter', UnitFrame_OnEnter)
	frame:SetScript('OnLeave', UnitFrame_OnLeave)

	frame:RegisterForClicks'AnyUp'

	frame:SetSize(88, 10)
	frame:SetPoint('CENTER', 0, 0)


	if unit == 'player' then
		-- your player-specific code here
	elseif unit == 'boss1' then
		-- your boss1-specific code here
	elseif unit:match('nameplate') then


		-- health bar
		local health = CreateFrame('StatusBar', nil, frame)
		health:SetAllPoints()
		health:SetStatusBarTexture('Interface\\TargetingFrame\\UI-StatusBar')
		health:GetStatusBarTexture():SetHorizTile(false)
		health:GetStatusBarTexture():SetVertTile(false)
		health.colorHealth = true
		health.colorTapping = true
		health.colorSmooth = true
		health.frequentUpdates = true
		health.colorDisconnected = true
		health.colorReaction = true
		frame.Health = health
		frame.Health:SetFrameLevel(1)

		CreateBackdrop(health)

		-- set size and points



		------------------
		--   Name Text --
		------------------
		local NameText = frame:CreateFontString(nil, 'OVERLAY', 'TextStatusBarText') -- parent to last child to make sure it's on top
		NameText:SetPoint('TOPLEFT', frame, 0,14) -- but anchor to the base element so it doesn't wiggle
		NameText:SetFont('SystemFont_Med1', 14, 'OUTLINE')
		NameText:SetJustifyH('LEFT')
		NameText:SetWidth(400)
		frame:Tag(NameText, '[name]')

		------------------
		--   Level Text --
		------------------
		local LevelText = frame:CreateFontString(nil, 'OVERLAY', 'TextStatusBarText') -- parent to last child to make sure it's on top
		LevelText:SetPoint('LEFT', frame, -25,0) -- but anchor to the base element so it doesn't wiggle
		LevelText:SetFont('SystemFont_Med1', 14, 'OUTLINE')
		LevelText:SetJustifyH('LEFT')
		frame:Tag(LevelText, '[level]')

		------------------
		--   Health Text --
		------------------
		local HealthText = frame:CreateFontString(nil, 'OVERLAY', 'TextStatusBarText')
		--HealthText:SetFrameLevel(12)		-- parent to last child to make sure it's on top
		HealthText:SetPoint('CENTER', frame, 0,0) -- but anchor to the base element so it doesn't wiggle
		HealthText:SetFont('SystemFont_Med1', 14, 'OUTLINE')
		HealthText:SetJustifyH('LEFT')
		frame:Tag(HealthText, '[perhp<%]')
		--------------
		-- Cast Bar --
		--------------
		local Castbar = CreateFrame('StatusBar', nil, frame)
		Castbar:SetStatusBarTexture('Interface\\TargetingFrame\\UI-StatusBar')
		Castbar:SetStatusBarColor(0.25, 0, 0.85, 0.85)
		Castbar:SetSize(88, 10)
		Castbar:SetPoint('BOTTOMLEFT', frame, 0, -16)


		CreateBackdrop(Castbar)
		-- Add a spark
		local Spark = Castbar:CreateTexture(nil, 'OVERLAY')
		Spark:SetSize(25, 8)
		Spark:SetBlendMode('ADD')

		-- Add a timer
		local Time = Castbar:CreateFontString(nil, 'OVERLAY', 'GameFontNormalSmall')
		Time:SetFont('SystemFont_Med1', 14, 'OUTLINE')
		Time:SetTextColor(0.95, 0.95, 0.95)
		Time:SetPoint('RIGHT', Castbar, -3, 1)

		-- Add spell text
		local Text = Castbar:CreateFontString(nil, 'OVERLAY', 'GameFontNormalSmall')
		Text:SetFont('SystemFont_Med1', 14, 'OUTLINE')
		Text:SetTextColor(0.95, 0.95, 0.95)
		Text:SetPoint('LEFT', Castbar, 3, 1)

		-- Add Shield
		local Shield = Castbar:CreateTexture(nil, 'OVERLAY')
		Shield:SetSize(14, 14)
		Shield:SetPoint('CENTER', Castbar)

		local Icon = Castbar:CreateTexture(nil, 'OVERLAY')
		Icon:SetSize(14, 14)
		Icon:SetPoint('LEFT', Castbar, 'LEFT',-25,0)
		-- Add safezone
		local SafeZone = Castbar:CreateTexture(nil, 'OVERLAY')

		-- Register it with oUF
		frame.Castbar = Castbar
		frame.Castbar.bg = Background
		frame.Castbar.Spark = Spark
		frame.Castbar.Time = Time
		frame.Castbar.Text = Text
		frame.Castbar.SafeZone = SafeZone
		frame.Castbar.Icon = Icon

		-----------
		-- Auras --
		-----------

		local Auras = CreateFrame('Frame', nil, frame)
		Auras:SetPoint('BOTTOMLEFT', frame, 'TOPLEFT', 0,15)
		Auras:SetPoint('BOTTOMRIGHT', frame, 'TOPRIGHT', 128, 15)
		Auras:SetHeight(20 + 4)
		Auras.disableMouse = false

		Auras.size = 20
		Auras.onlyShowPlayer = false
		Auras.gap = 2
		Auras.spacing = 2
		Auras.showStealableAuras = true
		Auras.disableCooldown = false
		Auras.num = 32

		Auras.PostCreateIcon = Aura_PostCreateIcon
		frame.Auras = Auras




		--------------------
		--  Elite Units   --
		--------------------
		local EliteText = frame:CreateFontString(nil, 'OVERLAY', 'TextStatusBarText') -- parent to last child to make sure it's on top
		EliteText:SetWidth(50)
		EliteText:SetPoint('RIGHT', frame, 33,0) -- but anchor to the base element so it doesn't wiggle
		EliteText:SetFont('SystemFont_Med1', 14, 'OUTLINE')
		EliteText:SetJustifyH('RIGHT')--classification
		frame:Tag(EliteText, '[classification]')



	end
end)

oUF:Factory(function(self)

	self:SetActiveStyle('oUF_Nameplates')

	local cvars = {
		-- important, strongly recommend to set these to 1
		nameplateGlobalScale = 1,
		NamePlateHorizontalScale = 1,
		NamePlateVerticalScale = 1,
		-- optional, you may use any values
		nameplateLargerScale = 1,
		nameplateMaxScale = 1,
		nameplateMinScale = 1,
		nameplateSelectedScale = 1,
		nameplateSelfScale = 1,
	}

	oUF:SpawnNamePlates(nil, nil, cvars)
end)
