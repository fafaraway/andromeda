local _, ns = ...
local F, C, L = unpack(select(2, ...))

if not C.unitframe.enable then return end

local module, cfg = F:GetModule('Unitframe'), C.unitframe

local oUF = ns.oUF


local function PostUpdateHealth(health, unit)
	local self = health:GetParent()
	local reaction = oUF.colors.reaction[UnitReaction(unit, 'player') or 5]
	local offline = not UnitIsConnected(unit)
	local tapped = not UnitPlayerControlled(unit) and UnitIsTapDenied(unit)

	self.Health.bg:SetPoint('LEFT', health:GetStatusBarTexture(), 'RIGHT')
	self.Health.bg:SetHeight(health:GetHeight())

	if cfg.gradient then
		self.Gradient:SetGradientAlpha('VERTICAL', .3, .3, .3, .6, .1, .1, .1, .6)
	else
		self.Gradient:Hide()
	end

	if cfg.transMode then
		local _, class = UnitClass(unit)
		local color = CUSTOM_CLASS_COLORS and CUSTOM_CLASS_COLORS[class] or RAID_CLASS_COLORS[class]

		if tapped or offline then
			self.Health:SetStatusBarColor(.6, .6, .6, .4)
			self.Health.bg:SetVertexColor(.6, .6, .6)
		elseif UnitIsDeadOrGhost(unit) then
			self.Health:SetStatusBarColor(0, 0, 0, .4)
			self.Health.bg:SetVertexColor(0, 0, 0, 1)
		elseif UnitIsPlayer(unit) and color then
			self.Health:SetStatusBarColor(0, 0, 0, .4)
			self.Health.bg:SetVertexColor(color.r, color.g, color.b, 1)
		else
			self.Health:SetStatusBarColor(0, 0, 0, .4)
			self.Health.bg:SetVertexColor(unpack(reaction))
		end
	end
end

function module:AddhealthBar(self)
	self.Bg = F.CreateBDFrame(self, 0)
	self.Glow = F.CreateSD(self.Bg, .35, 3, 3)

	local highlight = self:CreateTexture(nil, 'OVERLAY')
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

	local health = CreateFrame('StatusBar', nil, self)
	health:SetFrameStrata('LOW')
	health:SetStatusBarTexture(C.media.sbTex)
	health:GetStatusBarTexture():SetHorizTile(true)

	health:SetPoint('TOP')
	health:SetPoint('LEFT')
	health:SetPoint('RIGHT')
	health:SetPoint('BOTTOM', 0, C.Mult + cfg.power_height)
	health:SetHeight(self:GetHeight() - cfg.power_height - C.Mult)

	health.bg = health:CreateTexture(nil, 'BACKGROUND')
	health.bg:SetTexture(C.media.sbTex)

	if cfg.transMode then
		health.bg:SetPoint('LEFT')
		health.bg:SetPoint('RIGHT')
		health.bg:SetPoint('LEFT', health:GetStatusBarTexture(), 'RIGHT')
	else
		health.bg:SetAllPoints(health)
		health.bg.multiplier = .2
	end

	health.colorDisconnected = true
	health.colorTapping = true

	if cfg.classColour then
		health.colorClass = true
		health.colorReaction = true
	else
		health.colorSmooth = true
	end

	health.frequentUpdates = true
	F.SmoothBar(health)
		
	self.Health = health
	self.Health.PostUpdate = PostUpdateHealth

	local Gradient = health:CreateTexture(nil, 'OVERLAY')
	Gradient:SetAllPoints(self)
	Gradient:SetTexture(C.media.backdrop)
	self.Gradient = Gradient
end