local F, C, L = unpack(select(2, ...))
local COMBAT = F:GetModule('Combat')


local timer = 0
local playedHp

local function UpdateAlert(self, color, text)
	self.top:SetVertexColor(color[1], color[2], color[3], color[4])
	self.bottom:SetVertexColor(color[1], color[2], color[3], color[4])
	self.text:SetText(text)
	self.text:SetTextColor(color[1], color[2], color[3], color[4])

	self:Show()
end

local function OnShow(self)
	timer = 0
	self:SetScript('OnUpdate', function(self, elasped)
		timer = timer + elasped

		if timer < 0.5 then
			self:SetAlpha(timer * 2)
		end

		if timer > 1 and timer < 2 then
			self:SetAlpha(1 - (timer - 1) * 2)
		end

		if timer >= 2 then
			self:Hide()
		end
	end)
end

local function OnEvent(self, event, unit)
	-- Enter combat
	if event == 'PLAYER_REGEN_DISABLED' then
		UpdateAlert(self, {1, 210/255, 0, 1}, L['COMBAT_ENTER_COMBAT'])
	end

	-- Leave combat
	if event == 'PLAYER_REGEN_ENABLED' then
		UpdateAlert(self, {32/255, 1, 32/255, 1}, L['COMBAT_LEAVE_COMBAT'])
	end

	-- Interrup Dispel Stolen
	if event == 'COMBAT_LOG_EVENT_UNFILTERED' then
		local _, eventType, _, sourceGUID = CombatLogGetCurrentEventInfo()
		local isMine = sourceGUID == UnitGUID('player') or sourceGUID == UnitGUID('pet')

		if eventType == 'SPELL_INTERRUPT' and isMine then
			PlaySoundFile(C.Assets.Sounds.interrupt, 'Master')
		end

		if eventType == 'SPELL_DISPEL' and isMine then
			PlaySoundFile(C.Assets.Sounds.dispel, 'Master')
		end

		if eventType == 'SPELL_STOLEN' and isMine then
			PlaySoundFile(C.Assets.Sounds.dispel, 'Master')
		end
	end

	if unit ~= 'player' then return end
	if event == 'UNIT_HEALTH' or event == 'UNIT_MAXHEALTH' then
		if FreeUIConfigs.combat.health_alert and (UnitHealth('player') / UnitHealthMax('player')) < FreeUIConfigs.combat.health_alert_threshold then
			if not playedHp then
				playedHp = true

				PlaySoundFile(C.Assets.Sounds.health)
			end
		else
			playedHp = false
		end
	end
end

function COMBAT:CombatAlert()
	local f = CreateFrame('Frame', 'FreeUI_CombatAlert', UIParent)
	f:SetSize(380, 66)
	f:SetPoint('CENTER', 0, 260)
	f:SetScale(.8)
	f:Hide()

	f.bg = f:CreateTexture(nil, 'BACKGROUND')
	f.bg:SetTexture([[Interface\LevelUp\LevelUpTex]])
	f.bg:SetPoint('BOTTOM')
	f.bg:SetSize(326, 103)
	f.bg:SetTexCoord(0.00195313, 0.63867188, 0.03710938, 0.23828125)
	f.bg:SetVertexColor(0, 0, 0, .75)

	f.top = f:CreateTexture(nil, 'BACKGROUND')
	f.top:SetDrawLayer('BACKGROUND', 2)
	f.top:SetTexture([[Interface\LevelUp\LevelUpTex]])
	f.top:SetPoint('TOP')
	f.top:SetSize(380, 7)
	f.top:SetTexCoord(0.00195313, 0.81835938, 0.01953125, 0.03320313)

	f.bottom = f:CreateTexture(nil, 'BACKGROUND')
	f.bottom:SetDrawLayer('BACKGROUND', 2)
	f.bottom:SetTexture([[Interface\LevelUp\LevelUpTex]])
	f.bottom:SetPoint('BOTTOM')
	f.bottom:SetSize(380, 7)
	f.bottom:SetTexCoord(0.00195313, 0.81835938, 0.01953125, 0.03320313)

	f.text = F.CreateFS(f, C.Assets.Fonts.Header, 36, nil, '', nil, 'THICK', 'CENTER', 0, -6)
	f.text:SetJustifyH('CENTER')

	f:SetScript('OnShow', OnShow)
	f:SetScript('OnEvent', OnEvent)


	if FreeUIConfigs.combat.combat_alert then
		f:RegisterEvent('PLAYER_REGEN_ENABLED')
		f:RegisterEvent('PLAYER_REGEN_DISABLED')
	end

	if FreeUIConfigs.combat.health_alert then
		f:RegisterEvent('UNIT_HEALTH')
		f:RegisterEvent('UNIT_MAXHEALTH')
	end

	if FreeUIConfigs.combat.spell_alert then
		f:RegisterEvent('COMBAT_LOG_EVENT_UNFILTERED')
	end
end


function COMBAT:OnLogin()
	if not FreeUIConfigs.combat.enable_combat then return end

	self:CombatAlert()
	self:AutoTab()
	self:PvPSound()
end
