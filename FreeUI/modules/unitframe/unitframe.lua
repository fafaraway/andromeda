local F, C = unpack(select(2, ...))
local UNITFRAME = F:GetModule('Unitframe')
local oUF = FreeUI.oUF
local cfg = C.Unitframe


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

	local bg = F.CreateBDFrame(self)
	bg:SetBackdropBorderColor(0, 0, 0, 1)
	bg:SetBackdropColor(0, 0, 0, 0)
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
	if not cfg.enable_module then return end

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