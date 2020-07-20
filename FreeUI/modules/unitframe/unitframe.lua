local F, C = unpack(select(2, ...))
local UNITFRAME, cfg = F:GetModule('Unitframe'), C.Unitframe

local colors = F.oUF.colors

colors.disconnected = {
	0.5, 0.5, 0.5
}

colors.runes = {
	[1] = {0.69, 0.31, 0.31},
	[2] = {0.41, 0.80, 1.00},
	[3] = {0.65, 0.63, 0.35},
}

colors.reaction = {
	[1] = {1.00, 0.32, 0.29}, 	-- Hated
	[2] = {1.00, 0.32, 0.29}, 	-- Hostile
	[3] = {1.00, 0.32, 0.29}, 	-- Unfriendly
	[4] = {1.00, 0.93, 0.47}, 	-- Neutral
	[5] = {0.34, 1.00, 0.36}, 	-- Friendly
	[6] = {0.34, 1.00, 0.36}, 	-- Honored
	[7] = {0.34, 1.00, 0.36}, 	-- Revered
	[8] = {0.34, 1.00, 0.36}, 	-- Exalted
}

colors.debuffType = {
	['Curse']   = {0.8, 0, 1},
	['Disease'] = {0.8, 0.6, 0},
	['Magic']   = {0, 0.8, 1},
	['Poison']  = {0, 0.8, 0},
	['none']    = {0, 0, 0}
}

colors.power = {
	["MANA"]              = {111/255, 185/255, 237/255},
	["INSANITY"]          = {0.40, 0.00, 0.80},
	["MAELSTROM"]         = {0.00, 0.50, 1.00},
	["LUNAR_POWER"]       = {0.93, 0.51, 0.93},
	["HOLY_POWER"]        = {0.95, 0.90, 0.60},
	["RAGE"]              = {0.69, 0.31, 0.31},
	["FOCUS"]             = {0.71, 0.43, 0.27},
	["ENERGY"]            = {1, 222/255, 80/255},
	["CHI"]               = {0.71, 1.00, 0.92},
	["RUNES"]             = {0.55, 0.57, 0.61},
	["SOUL_SHARDS"]       = {0.50, 0.32, 0.55},
	["FURY"]              = {54/255, 199/255, 63/255},
	["PAIN"]              = {255/255, 156/255, 0},
	["RUNIC_POWER"]       = {0.00, 0.82, 1.00},
	["AMMOSLOT"]          = {0.80, 0.60, 0.00},
	["FUEL"]              = {0.00, 0.55, 0.50},
	["POWER_TYPE_STEAM"]  = {0.55, 0.57, 0.61},
	["POWER_TYPE_PYRITE"] = {0.60, 0.09, 0.17},
	["ALTPOWER"]          = {0.00, 1.00, 1.00},
}

colors.runes = {
	[1] = {151/255, 25/255, 0}, -- Blood
	[2] = {193/255, 219/255, 233/255}, -- Frost
	[3] = {98/255, 153/255, 51/255}, -- Unholy
}


function UNITFRAME:AddBackDrop(self)
	local highlight = self:CreateTexture(nil, 'BORDER')
	highlight:SetAllPoints()
	highlight:SetTexture('Interface\\PETBATTLES\\PetBattle-SelectedPetGlow')
	highlight:SetTexCoord(0, 1, .5, 1)
	highlight:SetVertexColor(.6, .6, .6)
	highlight:SetBlendMode('ADD')
	highlight:Hide()

	self:RegisterForClicks('AnyUp')
	self:HookScript('OnEnter', function()
		UnitFrame_OnEnter(self)
		highlight:Show()
	end)
	self:HookScript('OnLeave', function()
		UnitFrame_OnLeave(self)
		highlight:Hide()
	end)

	self.Highlight = highlight

	F.CreateTex(self)

	local bg = F.CreateBDFrame(self, 0)
	self.Bg = bg

	local glow = F.CreateSD(self.Bg)
	self.Glow = glow
end

local function updateSelectedBorder(self)
	if UnitIsUnit('target', self.unit) then
		self.Border:Show()
	else
		self.Border:Hide()
	end
end

function UNITFRAME:AddSelectedBorder(self)
	local border = F.CreateBDFrame(self.Bg)
	border:SetBackdropBorderColor(1, 1, 1, 1)
	border:SetBackdropColor(0, 0, 0, 0)
	border:SetFrameLevel(self:GetFrameLevel()+5)
	border:Hide()

	self.Border = border
	self:RegisterEvent('PLAYER_TARGET_CHANGED', updateSelectedBorder, true)
	self:RegisterEvent('GROUP_ROSTER_UPDATE', updateSelectedBorder, true)
end

function UNITFRAME:AddGroupNameText(self)
	local groupName = F.CreateFS(self.Health, C.Assets.Fonts.Normal, 11, nil, nil, nil, 'THICK')

	self:Tag(groupName, '[free:groupname][free:offline][free:dead]')
	self.GroupName = groupName
end

function UNITFRAME:AddNameText(self)
	local name = F.CreateFS(self.Health, C.Assets.Fonts.Normal, 11, nil, nil, nil, 'THICK')

	if self.unitStyle == 'target' then
		name:SetPoint('BOTTOMRIGHT', self, 'TOPRIGHT', 0, 3)
	elseif self.unitStyle == 'arena' or self.unitStyle == 'boss' then
		name:SetPoint('BOTTOMLEFT', self, 'TOPLEFT', 0, 3)
	else
		name:SetPoint('BOTTOM', self, 'TOP', 0, 3)
	end

	self:Tag(name, '[free:name] [arenaspec]')
	self.Name = name
end

function UNITFRAME:AddHealthValueText(self)
	local healthValue = F.CreateFS(self.Health, {C.Assets.Fonts.Number, 11, nil}, nil, nil, nil, nil, 'THICK')
	healthValue:SetPoint('BOTTOMLEFT', self, 'TOPLEFT', 0, 3)

	if self.unitStyle == 'player' then
		self:Tag(healthValue, '[free:dead][free:health]')
	elseif self.unitStyle == 'target' then
		self:Tag(healthValue, '[free:dead][free:offline][free:health] [free:healthpercentage]')
	elseif self.unitStyle == 'boss' then
		healthValue:ClearAllPoints()
		healthValue:SetPoint('BOTTOMRIGHT', self, 'TOPRIGHT', 0, 3)
		healthValue:SetJustifyH('RIGHT')
		self:Tag(healthValue, '[free:dead][free:health] [free:healthpercentage]')
	elseif self.unitStyle == 'arena' then
		healthValue:ClearAllPoints()
		healthValue:SetPoint('BOTTOMRIGHT', self, 'TOPRIGHT', 0, 3)
		healthValue:SetJustifyH('RIGHT')
		self:Tag(healthValue, '[free:dead][free:offline][free:health]')
	end

	self.HealthValue = healthValue
end

function UNITFRAME:AddPowerValueText(self)
	local powerValue = F.CreateFS(self.Health, {C.Assets.Fonts.Number, 11, nil}, nil, nil, nil, nil, 'THICK')
	powerValue:SetPoint('BOTTOMRIGHT', self, 'TOPRIGHT', 0, 3)

	if self.unitStyle == 'target' then
		powerValue:ClearAllPoints()
		powerValue:SetPoint('BOTTOMLEFT', self.HealthValue, 'BOTTOMRIGHT', 4, 0)
	elseif self.unitStyle == 'boss' then
		powerValue:ClearAllPoints()
		powerValue:SetPoint('BOTTOMRIGHT', self.HealthValue, 'BOTTOMLEFT', -4, 0)
	end

	self:Tag(powerValue, '[powercolor][free:power]')
	powerValue.frequentUpdates = true

	self.PowerValue = powerValue
end

function UNITFRAME:AddAlternativePowerValueText(self)
	local altPowerValue = F.CreateFS(self.Health, {C.Assets.Fonts.Number, 11, nil}, nil, nil, nil, nil, 'THICK')

	if self.unitStyle == 'boss' then
		altPowerValue:SetPoint('LEFT', self, 'RIGHT', 2, 0)
	else
		altPowerValue:SetPoint('BOTTOM', self.Health, 'TOP', 4, 0)
	end

	self:Tag(altPowerValue, '[free:altpower]')

	self.AlternativePowerValue = altPowerValue
end





function UNITFRAME:OnLogin()
	if not cfg.enable then return end

	F:SetSmoothingAmount(.3)
	
	self:SpawnPlayer()
	self:SpawnPet()
	self:SpawnTarget()
	self:SpawnTargetTarget()
	self:SpawnFocus()
	self:SpawnFocusTarget()

	if cfg.boss then
		self:SpawnBoss()
	end

	if cfg.arena then
		self:SpawnArena()
	end


	if not cfg.group then return end

	-- Hide Default RaidFrame
	if CompactRaidFrameManager_SetSetting then
		CompactRaidFrameManager_SetSetting("IsShown", "0")
		UIParent:UnregisterEvent("GROUP_ROSTER_UPDATE")
		CompactRaidFrameManager:UnregisterAllEvents()
		CompactRaidFrameManager:SetParent(F.HiddenFrame)
	end

	self:SpawnParty()
	self:SpawnRaid()
end