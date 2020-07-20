local F, C, L = unpack(select(2, ...))
local UNITFRAME, cfg = F:GetModule('Unitframe'), C.Unitframe


local playTargetSound = function(self, event)
    if event == "PLAYER_TARGET_CHANGED" then
        if (UnitExists(self.unit)) then
            if (UnitIsEnemy(self.unit, "player")) then
                PlaySound(SOUNDKIT.IG_CREATURE_AGGRO_SELECT)
            elseif (UnitIsFriend("player", self.unit)) then
                PlaySound(SOUNDKIT.IG_CHARACTER_NPC_SELECT)
            else
                PlaySound(SOUNDKIT.IG_CREATURE_NEUTRAL_SELECT)
            end
        else
            PlaySound(SOUNDKIT.INTERFACE_SOUND_LOST_TARGET_UNIT)
        end
    end
end

local function CreateTargetStyle(self)
	self.unitStyle = 'target'
	self:SetSize(cfg.target_width, cfg.target_height)

	UNITFRAME:AddBackDrop(self)
	UNITFRAME:AddHealthBar(self)
	UNITFRAME:AddHealthPrediction(self)
	UNITFRAME:AddPowerBar(self)
	UNITFRAME:AddPortrait(self)
	UNITFRAME:AddNameText(self)
	UNITFRAME:AddHealthValueText(self)
	UNITFRAME:AddPowerValueText(self)
	UNITFRAME:AddCastBar(self)
	UNITFRAME:AddAuras(self)
	UNITFRAME:AddRaidTargetIndicator(self)
	UNITFRAME:AddQuestIndicator(self)
	UNITFRAME:AddRangeCheck(self)
	UNITFRAME:AddFader(self)

	self:RegisterEvent("PLAYER_TARGET_CHANGED", playTargetSound)
	self.Health:SetScript("OnShow", function()
        playTargetSound(self, "PLAYER_TARGET_CHANGED")
    end)
end

function UNITFRAME:SpawnTarget()
	F.oUF:RegisterStyle('Target', CreateTargetStyle)
	F.oUF:SetActiveStyle('Target')

	local isHealer = FreeUIConfig['unitframe']['layout'] == "HEALER"
	local target = F.oUF:Spawn('target', 'oUF_Target')

	F.Mover(target, L['MOVER_UNITFRAME_TARGET'], 'TargetFrame', (isHealer and {'BOTTOMLEFT', UIParent, 'BOTTOM', 50, 300}) or {"LEFT", 'oUF_Player', "RIGHT", 60, 80}, target:GetWidth(), target:GetHeight())
end