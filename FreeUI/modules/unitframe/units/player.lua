local F, C, L = unpack(select(2, ...))
local UNITFRAME, cfg = F:GetModule('Unitframe'), C.Unitframe


local function CreatePlayerStyle(self)
	self.unitStyle = 'player'
	self:SetSize(cfg.player_width, cfg.player_height)

	UNITFRAME:AddBackDrop(self)
	UNITFRAME:AddHealthBar(self)
	UNITFRAME:AddHealthPrediction(self)
	UNITFRAME:AddHealthValueText(self)
	UNITFRAME:AddPowerBar(self)
	UNITFRAME:AddPowerValueText(self)
	UNITFRAME:AddAlternativePowerBar(self)
	UNITFRAME:AddAlternativePowerValueText(self)
	UNITFRAME:AddPortrait(self)
	UNITFRAME:AddCastBar(self)
	UNITFRAME:AddAuras(self)
	UNITFRAME:AddPvPIndicator(self)
	UNITFRAME:AddCombatIndicator(self)
	UNITFRAME:AddRestingIndicator(self)
	UNITFRAME:AddRaidTargetIndicator(self)
	UNITFRAME:AddGCDSpark(self)
	UNITFRAME:AddSwingSpark(self)
	UNITFRAME:AddFader(self)

	if C.MyClass == 'DEATHKNIGHT' then
		UNITFRAME:AddRunes(self)
	elseif C.MyClass == 'MONK' then
		UNITFRAME:AddStagger(self)
	elseif C.MyClass == 'SHAMAN' then
		UNITFRAME:AddTotems(self)
	else
		UNITFRAME:AddClassPower(self)
	end
end

function UNITFRAME:SpawnPlayer()
	F.oUF:RegisterStyle('Player', CreatePlayerStyle)
	F.oUF:SetActiveStyle('Player')

	local isHealer = FreeUIConfig['unitframe']['layout'] == "HEALER"
	local player = F.oUF:Spawn('player', 'oUF_Player')

	F.Mover(player, L['MOVER_UNITFRAME_PLAYER'], 'PlayerFrame', (isHealer and {'BOTTOMRIGHT', UIParent, 'BOTTOM', -50, 300}) or {"BOTTOM", UIParent, "BOTTOM", 0, 220}, player:GetWidth(), player:GetHeight())

	if not C.Actionbar.enable then return end
	FreeUI_LeaveVehicleBar:SetParent(player)
	FreeUI_LeaveVehicleButton:ClearAllPoints()
	FreeUI_LeaveVehicleButton:SetPoint('LEFT', player, 'RIGHT', 4, 0 )
	F.ReskinClose(FreeUI_LeaveVehicleButton)
	F.CreateSD(FreeUI_LeaveVehicleButton)
	FreeUI_LeaveVehicleButton:SetSize(player:GetHeight()+4, player:GetHeight()+4)
end