local F, C, L = unpack(select(2, ...))
local UNITFRAME, cfg = F:GetModule('Unitframe'), C.Unitframe


local playFocusSound = function(self, event)
	if event == "PLAYER_FOCUS_CHANGED" then
		if UnitExists(self.unit) then
			if UnitIsEnemy(self.unit, 'player') then
				PlaySound(SOUNDKIT.IG_CREATURE_AGGRO_SELECT)
			elseif UnitIsFriend('player', self.unit) then
				PlaySound(SOUNDKIT.IG_CHARACTER_NPC_SELECT)
			else
				PlaySound(SOUNDKIT.IG_CREATURE_NEUTRAL_SELECT)
			end
		else
			PlaySound(SOUNDKIT.INTERFACE_SOUND_LOST_TARGET_UNIT)
		end
	end
end

local function CreateFocusStyle(self)
	self.unitStyle = 'focus'
	self:SetSize(cfg.focus_width, cfg.focus_height)

	UNITFRAME:AddBackDrop(self)
	UNITFRAME:AddHealthBar(self)
	UNITFRAME:AddHealthPrediction(self)
	UNITFRAME:AddPowerBar(self)
	UNITFRAME:AddNameText(self)
	UNITFRAME:AddCastBar(self)
	UNITFRAME:AddAuras(self)
	UNITFRAME:AddRaidTargetIndicator(self)
	UNITFRAME:AddRangeCheck(self)
	UNITFRAME:AddFader(self)

	self:RegisterEvent("PLAYER_FOCUS_CHANGED", playFocusSound)
	self.Health:SetScript("OnShow", function()
        playFocusSound(self, "PLAYER_FOCUS_CHANGED")
    end)
end

function UNITFRAME:SpawnFocus()
	F.oUF:RegisterStyle('Focus', CreateFocusStyle)
	F.oUF:SetActiveStyle('Focus')

	local isHealer = FreeUIConfig['unitframe']['layout'] == "HEALER"
	local focus = F.oUF:Spawn('focus', 'oUF_Focus')

	F.Mover(focus, L['MOVER_UNITFRAME_FOCUS'], 'FocusFrame', (isHealer and {'TOPRIGHT', 'oUF_Player', 'TOPLEFT', -120, 0}) or {'TOPRIGHT', 'oUF_Player', 'TOPLEFT', -120, 0}, focus:GetWidth(), focus:GetHeight())
end