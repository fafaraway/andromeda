local F, C, L = unpack(select(2, ...))
local COMBAT, cfg = F:GetModule('Combat'), C.Combat


local function updateAlert(self, color, text)
	self.top:SetVertexColor(color[1], color[2], color[3], color[4])
	self.bottom:SetVertexColor(color[1], color[2], color[3], color[4])
	self.text:SetText(text)
	self.text:SetTextColor(color[1], color[2], color[3], color[4])
	
	self:Show()
end

local ca = CreateFrame('Frame', 'FreeUI_CombatAlert', UIParent)
ca:SetSize(418, 72)
ca:SetPoint('TOP', 0, -240)
ca:SetScale(1)
ca:Hide()

ca.bg = ca:CreateTexture(nil, 'BACKGROUND')
ca.bg:SetTexture([[Interface\LevelUp\LevelUpTex]])
ca.bg:SetPoint('BOTTOM')
ca.bg:SetSize(326, 103)
ca.bg:SetTexCoord(0.00195313, 0.63867188, 0.03710938, 0.23828125)
ca.bg:SetVertexColor(0, 0, 0, .75)

ca.top = ca:CreateTexture(nil, 'BACKGROUND')
ca.top:SetDrawLayer('BACKGROUND', 2)
ca.top:SetTexture([[Interface\LevelUp\LevelUpTex]])
ca.top:SetPoint('TOP')
ca.top:SetSize(418, 7)
ca.top:SetTexCoord(0.00195313, 0.81835938, 0.01953125, 0.03320313)

ca.bottom = ca:CreateTexture(nil, 'BACKGROUND')
ca.bottom:SetDrawLayer('BACKGROUND', 2)
ca.bottom:SetTexture([[Interface\LevelUp\LevelUpTex]])
ca.bottom:SetPoint('BOTTOM')
ca.bottom:SetSize(418, 7)
ca.bottom:SetTexCoord(0.00195313, 0.81835938, 0.01953125, 0.03320313)

ca.text = F.CreateFS(ca, C.Assets.Fonts.Header, 30, nil, '', nil, 'THICK', 'CENTER', 0, -6)
ca.text:SetJustifyH('CENTER')

local timer = 0
ca:SetScript('OnShow', function(self)
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
end)

local playedHp
ca:SetScript('OnEvent', function(self, event, unit)
	-- Enter combat
	if event == 'PLAYER_REGEN_DISABLED' then
		updateAlert(self, {1, 210/255, 0, 1}, L['COMBAT_ENTER_COMBAT'])
	end

	-- Leave combat
	if event == 'PLAYER_REGEN_ENABLED' then
		updateAlert(self, {32/255, 1, 32/255, 1}, L['COMBAT_LEAVE_COMBAT'])
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
		if cfg.health_alert and (UnitHealth('player') / UnitHealthMax('player')) < cfg.health_alert_threshold then
			if not playedHp then
				playedHp = true

				PlaySoundFile(C.Assets.Sounds.health)
			end
		else
			playedHp = false
		end
	end
end)

function COMBAT:CombatAlert()
	if cfg.combat_alert then
		ca:RegisterEvent('PLAYER_REGEN_ENABLED')
		ca:RegisterEvent('PLAYER_REGEN_DISABLED')
	end

	if cfg.health_alert then
		ca:RegisterEvent('UNIT_HEALTH')
		ca:RegisterEvent('UNIT_MAXHEALTH')
	end	

	if cfg.spell_alert then
		ca:RegisterEvent('COMBAT_LOG_EVENT_UNFILTERED')
	end
end


local COMBAT_LIST = {}

function COMBAT:RegisterCombat(name, func)
	if not COMBAT_LIST[name] then
		COMBAT_LIST[name] = func
	end
end


function COMBAT:OnLogin()
	if not cfg.enable then return end

	for name, func in next, COMBAT_LIST do
		if name and type(func) == "function" then
			func()
		end
	end

	self:CombatAlert()
end