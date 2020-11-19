local F, C, L = unpack(select(2, ...))
local COMBAT = F.COMBAT


-- Combat alert
-- Credits: ElvUI_WindTools by fang2hou
-- https://github.com/fang2hou/ElvUI_WindTools

local isPlaying = false
local alertQueue = {}


function COMBAT:CreateAnimationFrame()
	if self.animationFrame then
		return
	end

	local frame, anime
	frame = CreateFrame('Frame', nil, _G.UIParent)
	frame:SetPoint('TOP', 0, -200)
	self.animationFrame = frame

	-- 盾
	frame = F.CreateAnimationFrame(nil, self.animationFrame, 'HIGH', 3, true, C.Assets.shield_tex, false, {1, 1, 1})
	anime = F.CreateAnimationGroup(frame, 'enter') -- 进入战斗
	F.AddTranslation(anime, 'moveToCenter')
	F.AddFadeIn(anime, 'fadeIn')
	F.AddFadeOut(anime, 'fadeOut')
	F.CloseAnimationOnHide(frame, anime, COMBAT.LoadNextAlert)
	anime.moveToCenter:SetDuration(0.2)
	anime.moveToCenter:SetStartDelay(0)
	anime.fadeIn:SetDuration(0.2)
	anime.fadeIn:SetStartDelay(0)
	anime.fadeOut:SetDuration(0.3)
	anime.fadeOut:SetStartDelay(0.5)
	anime = F.CreateAnimationGroup(frame, 'leave') -- 离开战斗
	F.AddScale(anime, 'scale', {1, 1}, {0.1, 0.1})
	F.AddFadeIn(anime, 'fadeIn')
	F.AddFadeOut(anime, 'fadeOut')
	anime.fadeIn:SetDuration(0.3)
	anime.fadeIn:SetStartDelay(0)
	anime.scale:SetDuration(0.6)
	anime.scale:SetStartDelay(0.6)
	anime.fadeOut:SetDuration(0.6)
	anime.fadeOut:SetStartDelay(0.6)
	F.CloseAnimationOnHide(frame, anime, COMBAT.LoadNextAlert)
	self.animationFrame.shield = frame

	-- 剑 ↗
	frame = F.CreateAnimationFrame(nil, self.animationFrame, 'HIGH', 2, true, C.Assets.sword_tex, false, {1, 1, 1})
	anime = F.CreateAnimationGroup(frame, 'enter') -- 进入战斗
	F.AddTranslation(anime, 'moveToCenter')
	F.AddFadeIn(anime, 'fadeIn')
	F.AddFadeOut(anime, 'fadeOut')
	F.CloseAnimationOnHide(frame, anime)
	anime.moveToCenter:SetDuration(0.4)
	anime.moveToCenter:SetStartDelay(0)
	anime.fadeIn:SetDuration(0.4)
	anime.fadeIn:SetStartDelay(0)
	anime.fadeOut:SetDuration(0.3)
	anime.fadeOut:SetStartDelay(0.9)
	anime.fadeIn:SetScript(
		'OnFinished',
		function()
			self.animationFrame.shield:Show()
			self.animationFrame.shield.enter:Play()
		end
	)
	anime = F.CreateAnimationGroup(frame, 'leave') -- 离开战斗
	F.AddTranslation(anime, 'moveToCorner')
	F.AddFadeIn(anime, 'fadeIn')
	F.AddFadeOut(anime, 'fadeOut')
	anime.fadeIn:SetDuration(0.3)
	anime.fadeIn:SetStartDelay(0)
	anime.moveToCorner:SetDuration(0.6)
	anime.moveToCorner:SetStartDelay(0.6)
	anime.fadeOut:SetDuration(0.6)
	anime.fadeOut:SetStartDelay(0.6)
	F.CloseAnimationOnHide(frame, anime)
	self.animationFrame.swordLeftToRight = frame

	-- 剑 ↖
	frame = F.CreateAnimationFrame(nil, self.animationFrame, 'HIGH', 2, true, C.Assets.sword_tex, true, {1, 1, 1})
	anime = F.CreateAnimationGroup(frame, 'enter') -- 进入战斗
	F.AddTranslation(anime, 'moveToCenter')
	F.AddFadeIn(anime, 'fadeIn')
	F.AddFadeOut(anime, 'fadeOut')
	F.CloseAnimationOnHide(frame, anime)
	anime.moveToCenter:SetDuration(0.4)
	anime.moveToCenter:SetStartDelay(0)
	anime.fadeIn:SetDuration(0.4)
	anime.fadeIn:SetStartDelay(0)
	anime.fadeOut:SetDuration(0.3)
	anime.fadeOut:SetStartDelay(0.9)
	anime = F.CreateAnimationGroup(frame, 'leave') -- 离开战斗
	F.AddTranslation(anime, 'moveToCorner')
	F.AddFadeIn(anime, 'fadeIn')
	F.AddFadeOut(anime, 'fadeOut')
	anime.fadeIn:SetDuration(0.3)
	anime.fadeIn:SetStartDelay(0)
	anime.moveToCorner:SetDuration(0.6)
	anime.moveToCorner:SetStartDelay(0.6)
	anime.fadeOut:SetDuration(0.6)
	anime.fadeOut:SetStartDelay(0.6)
	F.CloseAnimationOnHide(frame, anime)
	self.animationFrame.swordRightToLeft = frame

end

function COMBAT:UpdateAnimationFrame()
	if not self.animationFrame then
		return
	end

	local animationFrameSize = {240 * C.DB.combat.alert_scale, 220 * C.DB.combat.alert_scale}
	local textureSize = 200 * C.DB.combat.alert_scale
	local swordAnimationRange = 130 * C.DB.combat.alert_scale
	local shieldAnimationRange = 65 * C.DB.combat.alert_scale

	local f = self.animationFrame

	f:SetSize(unpack(animationFrameSize))

	f.shield:Hide()
	f.shield:SetSize(0.8 * textureSize, 0.8 * textureSize)
	f.shield.enter.moveToCenter:SetOffset(0, -shieldAnimationRange)

	f.swordLeftToRight:Hide()
	f.swordLeftToRight:SetSize(textureSize, textureSize)
	f.swordLeftToRight.enter.moveToCenter:SetOffset(swordAnimationRange, swordAnimationRange)
	f.swordLeftToRight.leave.moveToCorner:SetOffset(swordAnimationRange, swordAnimationRange)

	f.swordRightToLeft:Hide()
	f.swordRightToLeft:SetSize(textureSize, textureSize)
	f.swordRightToLeft.enter.moveToCenter:SetOffset(-swordAnimationRange, swordAnimationRange)
	f.swordRightToLeft.leave.moveToCorner:SetOffset(-swordAnimationRange, swordAnimationRange)

	F.SpeedAnimationGroup(f.shield.enter, C.DB.combat.alert_speed)
	F.SpeedAnimationGroup(f.swordLeftToRight.enter, C.DB.combat.alert_speed)
	F.SpeedAnimationGroup(f.swordRightToLeft.enter, C.DB.combat.alert_speed)
	F.SpeedAnimationGroup(f.shield.leave, C.DB.combat.alert_speed)
	F.SpeedAnimationGroup(f.swordLeftToRight.leave, C.DB.combat.alert_speed)
	F.SpeedAnimationGroup(f.swordRightToLeft.leave, C.DB.combat.alert_speed)
end

function COMBAT:CreateTextFrame()
	if self.textFrame then
		return
	end

	local frame = F.CreateAnimationFrame(nil, _G.UIParent, 'HIGH', 4, true)
	frame.text = frame:CreateFontString()
	frame.text:SetPoint('CENTER', 0, 0)
	frame.text:SetJustifyV('MIDDLE')
	frame.text:SetJustifyH('CENTER')

	local anime = F.CreateAnimationGroup(frame, 'enter')
	F.AddTranslation(anime, 'moveUp')
	F.AddTranslation(anime, 'moveDown')
	F.AddFadeIn(anime, 'fadeIn')
	F.AddFadeOut(anime, 'fadeOut')
	anime.moveUp:SetDuration(0.4)
	anime.moveUp:SetStartDelay(0)
	anime.moveDown:SetDuration(0.1)
	anime.moveDown:SetStartDelay(0.4)
	anime.fadeIn:SetDuration(0.5)
	anime.fadeIn:SetStartDelay(0)
	anime.fadeOut:SetDuration(0.3)
	anime.fadeOut:SetStartDelay(0.9)
	anime = F.CreateAnimationGroup(frame, 'leave')
	F.AddFadeIn(anime, 'fadeIn')
	F.AddFadeOut(anime, 'fadeOut')
	F.AddTranslation(anime, 'moveUp')
	anime.fadeIn:SetDuration(0.3)
	anime.fadeIn:SetStartDelay(0)
	anime.fadeOut:SetDuration(0.6)
	anime.fadeOut:SetStartDelay(0.6)
	anime.moveUp:SetDuration(0.6)
	anime.moveUp:SetStartDelay(0.6)

	self.textFrame = frame
end

function COMBAT:UpdateTextFrame()
	if not self.textFrame then
		return
	end

	local moveUpOffset = 160 * C.DB.combat.alert_scale
	local moveDownOffset = -40 * C.DB.combat.alert_scale

	local f = self.textFrame

	f:Hide()
	f.text:SetFont(C.Assets.Fonts.Header, 28)
	f.text:SetText(L['COMBAT_ENTER'])
	f:SetSize(f.text:GetStringWidth(), f.text:GetStringHeight())

	f.enter.moveUp:SetOffset(0, moveUpOffset)
	f.enter.moveDown:SetOffset(0, moveDownOffset)
	f.leave.moveUp:SetOffset(0, -moveDownOffset)

	F.SpeedAnimationGroup(f.enter, C.DB.combat.alert_speed)
	F.SpeedAnimationGroup(f.leave, C.DB.combat.alert_speed)

	-- 上方动画窗体如果不存在，确认下个提示的工作就交给文字窗体了
	-- if not self.db.animation then
		F.CloseAnimationOnHide(f, 'enter', COMBAT.LoadNextAlert)
		F.CloseAnimationOnHide(f, 'leave', COMBAT.LoadNextAlert)
	-- else
	-- 	F.CloseAnimationOnHide(f, 'enter')
	-- 	F.CloseAnimationOnHide(f, 'leave')
	-- end
end

function COMBAT:ShowAlert(alertType)
	-- if not self.animationFrame then
	-- 	F.DebugMessage(MISC, '找不到动画框架')
	-- end

	-- if not self.textFrame then
	-- 	F.DebugMessage(MISC, '找不到文字框架')
	-- end

	if isPlaying then
		self:QueueAlert(alertType)
		return
	end

	isPlaying = true

	local a = self.animationFrame
	local t = self.textFrame
	local swordOffsetEnter = 150 * C.DB.combat.alert_scale
	local swordOffsetLeave = 20 * C.DB.combat.alert_scale
	local shieldOffsetEnter = 50 * C.DB.combat.alert_scale
	local shieldOffsetLeave = -15 * C.DB.combat.alert_scale
	local textOffsetEnter = -120 * C.DB.combat.alert_scale
	local textOffsetLeave = -20 * C.DB.combat.alert_scale

	--if self.db.animation then
		a.shield.enter:Stop()
		a.swordLeftToRight.enter:Stop()
		a.swordRightToLeft.enter:Stop()
		a.shield.leave:Stop()
		a.swordLeftToRight.leave:Stop()
		a.swordRightToLeft.leave:Stop()
	--end

	--if self.db.text then
		t.enter:Stop()
		t.leave:Stop()
	--end

	if alertType == 'ENTER' then
		--if self.db.animation then
			-- 盾牌动画会由左到右的剑自动触发
			a.shield:SetPoint('CENTER', 0, shieldOffsetEnter)
			a.swordLeftToRight:SetPoint('CENTER', -swordOffsetEnter, -swordOffsetEnter)
			a.swordRightToLeft:SetPoint('CENTER', swordOffsetEnter, -swordOffsetEnter)
			a.swordLeftToRight:Show()
			a.swordRightToLeft:Show()
			a.swordLeftToRight.enter:Restart()
			a.swordRightToLeft.enter:Restart()
		--end

		--if self.db.text then
			-- t.text:SetText(L['COMBAT_ENTER'])
			--F.SetFontColorWithDB(t.text, self.db.enterColor)
			-- t.text:SetTextColor(1, 0, 0)
			F.SetFS(t.text, C.Assets.Fonts.Header, 26, nil, L['COMBAT_ENTER'], 'RED', 'THICK')
			t:SetSize(t.text:GetStringWidth(), t.text:GetStringHeight())
			t:SetPoint('TOP', self.animationFrame or _G.UIParent, 'BOTTOM', 0, textOffsetEnter)
			t:Show()
			t.enter:Restart()
		--end
	else
		--if self.db.animation then
			a.shield:SetPoint('CENTER', 0, shieldOffsetLeave)
			a.swordLeftToRight:SetPoint('CENTER', -swordOffsetLeave, -swordOffsetLeave)
			a.swordRightToLeft:SetPoint('CENTER', swordOffsetLeave, -swordOffsetLeave)
			a.shield:Show()
			a.swordLeftToRight:Show()
			a.swordRightToLeft:Show()
			a.shield.leave:Restart()
			a.swordLeftToRight.leave:Restart()
			a.swordRightToLeft.leave:Restart()
		--end

		--if self.db.text then
			--t.text:SetText(L['COMBAT_LEAVE'])
			--F.SetFontColorWithDB(t.text, self.db.leaveColor)
			F.SetFS(t.text, C.Assets.Fonts.Header, 26, nil, L['COMBAT_LEAVE'], 'GREEN', 'THICK')
			t:SetSize(t.text:GetStringWidth(), t.text:GetStringHeight())
			t:SetPoint('TOP', self.animationFrame or _G.UIParent, 'BOTTOM', 0, textOffsetLeave)
			t:Show()
			t.leave:Restart()
		--end
	end
end

function COMBAT:QueueAlert(alertType)
	tinsert(alertQueue, alertType)
end

function COMBAT.LoadNextAlert()
	isPlaying = false

	if alertQueue and alertQueue[1] then
		COMBAT:ShowAlert(alertQueue[1])
		tremove(alertQueue, 1)
	end
end

function COMBAT:PLAYER_REGEN_DISABLED()
	COMBAT:ShowAlert('ENTER')
end

function COMBAT:PLAYER_REGEN_ENABLED()
	COMBAT:ShowAlert('LEAVE')
end


function COMBAT:CombatAlert()
	if C.DB.combat.combat_alert then
		COMBAT:CreateAnimationFrame()
		COMBAT:CreateTextFrame()
		COMBAT:UpdateAnimationFrame()
		COMBAT:UpdateTextFrame()

		F:RegisterEvent('PLAYER_REGEN_DISABLED', COMBAT.PLAYER_REGEN_DISABLED)
		F:RegisterEvent('PLAYER_REGEN_ENABLED', COMBAT.PLAYER_REGEN_ENABLED)
	else
		F:UnregisterEvent('PLAYER_REGEN_DISABLED', COMBAT.PLAYER_REGEN_DISABLED)
		F:UnregisterEvent('PLAYER_REGEN_ENABLED', COMBAT.PLAYER_REGEN_ENABLED)
	end
end



local function SpellSound_OnEvent()
	local _, eventType, _, sourceGUID = CombatLogGetCurrentEventInfo()

	if sourceGUID ~= UnitGUID('player') and sourceGUID ~= UnitGUID('pet') then return end

	if eventType == 'SPELL_INTERRUPT' then
		PlaySoundFile(C.Assets.Sounds.interrupt, 'Master')
	end

	if eventType == 'SPELL_DISPEL' then
		PlaySoundFile(C.Assets.Sounds.dispel, 'Master')
	end

	if eventType == 'SPELL_STOLEN' then
		PlaySoundFile(C.Assets.Sounds.dispel, 'Master')
	end
end

function COMBAT:SpellSound()
	if C.DB.combat.spell_sound then
		F:RegisterEvent('COMBAT_LOG_EVENT_UNFILTERED', SpellSound_OnEvent)
	else
		F:UnregisterEvent('COMBAT_LOG_EVENT_UNFILTERED', SpellSound_OnEvent)
	end
end


function COMBAT:OnLogin()
	if not C.DB.combat.enable then return end

	COMBAT:CombatAlert()
	COMBAT:SpellSound()
	COMBAT:FloatingCombatText()
	COMBAT:PvPSound()
	COMBAT:Tabber()
	COMBAT:Focuser()
	COMBAT:Marker()
end
