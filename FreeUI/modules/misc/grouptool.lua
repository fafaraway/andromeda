local F, C, L = unpack(select(2, ...))
local MISC = F.MISC


local tinsert, strsplit, format = table.insert, string.split, string.format
local next, pairs, mod = next, pairs, mod
local LeaveParty = C_PartyInfo.LeaveParty
local ConvertToRaid = C_PartyInfo.ConvertToRaid
local ConvertToParty = C_PartyInfo.ConvertToParty



function MISC:GroupTool()
	if not FreeDB.misc.group_tool then return end

	local header = CreateFrame('Button', nil, UIParent, 'BackdropTemplate')
	header:SetSize(120, 28)
	header:SetFrameLevel(2)
	F.ReskinMenuButton(header)
	F.Mover(header, L.GUI.MOVER.GROUP_TOOL, 'GroupTool', {'TOP', 0, -30})
	header:RegisterEvent('GROUP_ROSTER_UPDATE')
	header:RegisterEvent('PLAYER_ENTERING_WORLD')
	header:SetScript('OnEvent', function(self)
		self:UnregisterEvent('PLAYER_ENTERING_WORLD')
		if IsInGroup() then
			self:Show()
		else
			self:Hide()
		end
	end)

	local function IsManagerOnTop()
		local y = select(2, header:GetCenter())
		local screenHeight = UIParent:GetTop()
		return y > screenHeight/2
	end

	-- Role counts
	local function getRaidMaxGroup()
		local _, instType, difficulty = GetInstanceInfo()
		if (instType == 'party' or instType == 'scenario') and not IsInRaid() then
			return 1
		elseif instType ~= 'raid' then
			return 8
		elseif difficulty == 8 or difficulty == 1 or difficulty == 2 or difficulty == 24 then
			return 1
		elseif difficulty == 14 or difficulty == 15 then
			return 6
		elseif difficulty == 16 then
			return 4
		elseif difficulty == 3 or difficulty == 5 then
			return 2
		elseif difficulty == 9 then
			return 8
		else
			return 5
		end
	end

	local roleIcons = {
		C.AssetsPath..'textures\\roles_tank',
		C.AssetsPath..'textures\\roles_healer',
		C.AssetsPath..'textures\\roles_dps',
	}

	local roleFrame = CreateFrame('Frame', nil, header)
	roleFrame:SetAllPoints()
	local role = {}
	for i = 1, 3 do
		role[i] = roleFrame:CreateTexture(nil, 'OVERLAY')
		role[i]:SetPoint('LEFT', 36*i-30, 0)
		role[i]:SetSize(15, 15)
		role[i]:SetTexture(roleIcons[i])
		role[i].text = F.CreateFS(roleFrame, C.Assets.Fonts.Regular, 11, nil, '0')
		role[i].text:ClearAllPoints()
		role[i].text:SetPoint('CENTER', role[i], 'RIGHT', 10, 0)
	end

	local raidCounts = {totalTANK = 0, totalHEALER = 0, totalDAMAGER = 0}
	roleFrame:RegisterEvent('GROUP_ROSTER_UPDATE')
	roleFrame:RegisterEvent('UPDATE_ACTIVE_BATTLEFIELD')
	roleFrame:RegisterEvent('UNIT_FLAGS')
	roleFrame:RegisterEvent('PLAYER_FLAGS_CHANGED')
	roleFrame:RegisterEvent('PLAYER_ENTERING_WORLD')
	roleFrame:SetScript('OnEvent', function()
		for k in pairs(raidCounts) do
			raidCounts[k] = 0
		end

		local maxgroup = getRaidMaxGroup()
		for i = 1, GetNumGroupMembers() do
			local name, _, subgroup, _, _, _, _, online, isDead, _, _, assignedRole = GetRaidRosterInfo(i)
			if name and online and subgroup <= maxgroup and not isDead and assignedRole ~= 'NONE' then
				raidCounts['total'..assignedRole] = raidCounts['total'..assignedRole] + 1
			end
		end

		role[1].text:SetText(raidCounts.totalTANK)
		role[2].text:SetText(raidCounts.totalHEALER)
		role[3].text:SetText(raidCounts.totalDAMAGER)
	end)

	-- Battle resurrect
	local resFrame = CreateFrame('Frame', nil, header)
	resFrame:SetAllPoints()
	resFrame:SetAlpha(0)
	local res = CreateFrame('Frame', nil, resFrame)
	res:SetSize(22, 22)
	res:SetPoint('LEFT', 5, 0)
	F.PixelIcon(res, GetSpellTexture(20484))
	res.Count = F.CreateFS(res, C.Assets.Fonts.Regular, 16, nil, '0')
	res.Count:ClearAllPoints()
	res.Count:SetPoint('LEFT', res, 'RIGHT', 10, 0)
	res.Timer = F.CreateFS(resFrame, C.Assets.Fonts.Regular, 16, nil, '00:00', nil, nil, 'RIGHT', -5, 0)

	res:SetScript('OnUpdate', function(self, elapsed)
		self.elapsed = (self.elapsed or 0) + elapsed
		if self.elapsed > .1 then
			local charges, _, started, duration = GetSpellCharges(20484)
			if charges then
				local timer = duration - (GetTime() - started)
				if timer < 0 then
					self.Timer:SetText('--:--')
				else
					self.Timer:SetFormattedText('%d:%.2d', timer/60, timer%60)
				end
				self.Count:SetText(charges)
				if charges == 0 then
					self.Count:SetTextColor(1, 0, 0)
				else
					self.Count:SetTextColor(0, 1, 0)
				end
				resFrame:SetAlpha(1)
				roleFrame:SetAlpha(0)
			else
				resFrame:SetAlpha(0)
				roleFrame:SetAlpha(1)
			end

			self.elapsed = 0
		end
	end)

	-- Ready check indicator
	local rcFrame = CreateFrame('Frame', nil, header)
	rcFrame:SetPoint('TOP', header, 'BOTTOM', 0, -3)
	rcFrame:SetSize(120, 50)
	rcFrame:Hide()
	F.SetBD(rcFrame)
	F.CreateFS(rcFrame, C.Assets.Fonts.Regular, 14, nil, READY_CHECK, nil, nil, 'TOP', 0, -8)
	local rc = F.CreateFS(rcFrame, C.Assets.Fonts.Regular, 14, nil, '', nil, nil, 'TOP', 0, -28)

	local count, total
	local function hideRCFrame()
		rcFrame:Hide()
		rc:SetText('')
		count, total = 0, 0
	end

	rcFrame:RegisterEvent('READY_CHECK')
	rcFrame:RegisterEvent('READY_CHECK_CONFIRM')
	rcFrame:RegisterEvent('READY_CHECK_FINISHED')
	rcFrame:SetScript('OnEvent', function(self, event)
		if event == 'READY_CHECK_FINISHED' then
			if count == total then
				rc:SetTextColor(0, 1, 0)
			else
				rc:SetTextColor(1, 0, 0)
			end
			C_Timer.After(5, hideRCFrame)
		else
			count, total = 0, 0

			self:ClearAllPoints()
			if IsManagerOnTop() then
				self:SetPoint('TOP', header, 'BOTTOM', 0, -3)
			else
				self:SetPoint('BOTTOM', header, 'TOP', 0, 3)
			end
			self:Show()

			local maxgroup = getRaidMaxGroup()
			for i = 1, GetNumGroupMembers() do
				local name, _, subgroup, _, _, _, _, online = GetRaidRosterInfo(i)
				if name and online and subgroup <= maxgroup then
					total = total + 1
					local status = GetReadyCheckStatus(name)
					if status and status == 'ready' then
						count = count + 1
					end
				end
			end
			rc:SetText(count..' / '..total)
			if count == total then
				rc:SetTextColor(0, 1, 0)
			else
				rc:SetTextColor(1, 1, 0)
			end
		end
	end)
	rcFrame:SetScript('OnMouseUp', function(self) self:Hide() end)

	-- World marker
	local marker = _G.CompactRaidFrameManagerDisplayFrameLeaderOptionsRaidWorldMarkerButton
	if not marker then
		for _, addon in next, {'Blizzard_CUFProfiles', 'Blizzard_CompactRaidFrames'} do
			EnableAddOn(addon)
			LoadAddOn(addon)
		end
	end
	if marker then
		marker:ClearAllPoints()
		marker:SetPoint('RIGHT', header, 'LEFT', -3, 0)
		marker:SetParent(header)
		marker:SetSize(28, 28)
		F.StripTextures(marker)
		F.ReskinMenuButton(marker)
		marker:SetNormalTexture('Interface\\RaidFrame\\Raid-WorldPing')
		marker:GetNormalTexture():SetVertexColor(0, 1, 0)
		marker:HookScript('OnMouseUp', function()
			if (IsInGroup() and not IsInRaid()) or UnitIsGroupLeader('player') or UnitIsGroupAssistant('player') then return end
			UIErrorsFrame:AddMessage(C.InfoColor..ERR_NOT_LEADER)
		end)
	end

	-- Buff checker
	local checker = CreateFrame('Button', nil, header)
	checker:SetPoint('LEFT', header, 'RIGHT', 3, 0)
	checker:SetSize(28, 28)
	checker.tex = checker:CreateTexture(nil, 'ARTWORK')
	checker.tex:SetSize(16, 16)
	checker.tex:SetPoint('CENTER')
	checker.tex:SetTexture(C.Assets.classify_tex)
	checker.tex:SetTexCoord(.5, 1, 0, .5)
	F.ReskinMenuButton(checker)

	local BuffName, numPlayer = {L['MISC_FLASK'], L['MISC_FOOD'], SPELL_STAT4_NAME, RAID_BUFF_2, RAID_BUFF_3, RUNES}
	local NoBuff, numGroups = {}, 6
	for i = 1, numGroups do NoBuff[i] = {} end

	local debugMode = false
	local function sendMsg(text)
		if debugMode then
			print(text)
		else
			SendChatMessage(text, IsPartyLFG() and 'INSTANCE_CHAT' or IsInRaid() and 'RAID' or 'PARTY')
		end
	end

	local function sendResult(i)
		local countPlayer = #NoBuff[i]
		if countPlayer > 0 then
			if countPlayer >= numPlayer then
				sendMsg(L['MISC_LACK']..BuffName[i]..': '..ALL..PLAYER)
			elseif countPlayer >= 5 and i > 2 then
				sendMsg(L['MISC_LACK']..BuffName[i]..': '..format(L['MISC_PLAYER_COUNT'], countPlayer))
			else
				local str = L['MISC_LACK']..BuffName[i]..': '
				for j = 1, countPlayer do
					str = str..NoBuff[i][j]..(j < #NoBuff[i] and ', ' or '')
					if #str > 230 then
						sendMsg(str)
						str = ''
					end
				end
				sendMsg(str)
			end
		end
	end

	local function scanBuff()
		for i = 1, numGroups do wipe(NoBuff[i]) end
		numPlayer = 0

		local maxgroup = getRaidMaxGroup()
		for i = 1, GetNumGroupMembers() do
			local name, _, subgroup, _, _, _, _, online, isDead = GetRaidRosterInfo(i)
			if name and online and subgroup <= maxgroup and not isDead then
				numPlayer = numPlayer + 1
				for j = 1, numGroups do
					local HasBuff
					local buffTable = C.BuffList[j]
					for k = 1, #buffTable do
						local buffName = GetSpellInfo(buffTable[k])
						for index = 1, 32 do
							local currentBuff = UnitAura(name, index)
							if currentBuff and currentBuff == buffName then
								HasBuff = true
								break
							end
						end
					end
					if not HasBuff then
						name = strsplit('-', name)	-- remove realm name
						tinsert(NoBuff[j], name)
					end
				end
			end
		end
		if not FreeDB.misc.rune_check then NoBuff[numGroups] = {} end

		if #NoBuff[1] == 0 and #NoBuff[2] == 0 and #NoBuff[3] == 0 and #NoBuff[4] == 0 and #NoBuff[5] == 0 and #NoBuff[6] == 0 then
			sendMsg(L['MISC_BUFFS_READY'])
		else
			sendMsg(L['MISC_RAID_BUFF_CHECK'])
			for i = 1, 5 do sendResult(i) end
			if FreeDB.misc.rune_check then sendResult(numGroups) end
		end
	end

	local potionCheck
	if IsAddOnLoaded('ExRT') then potionCheck = true end

	checker:HookScript('OnEnter', function(self)
		GameTooltip:SetOwner(self, 'ANCHOR_BOTTOMRIGHT')
		GameTooltip:ClearLines()
		GameTooltip:AddLine(L['MISC_GROUP_TOOL'], .9, .8, .6)
		GameTooltip:AddLine(' ')
		GameTooltip:AddDoubleLine(C.Assets.mouse_left..C.BlueColor..READY_CHECK)
		GameTooltip:AddDoubleLine(C.Assets.mouse_middle..C.BlueColor..L['MISC_COUNT_DOWN'])
		GameTooltip:AddDoubleLine(C.Assets.mouse_right..'(Ctrl) '..C.BlueColor..L['MISC_CHECK_STATUS'])
		if potionCheck then
			GameTooltip:AddDoubleLine(C.Assets.mouse_right..'(Alt) '..C.BlueColor..L['MISC_EXRT_POTION_CHECK'])
		end
		GameTooltip:Show()
	end)
	checker:HookScript('OnLeave', F.HideTooltip)

	local reset = true
	checker:HookScript('OnMouseDown', function(_, btn)
		if btn == 'RightButton' then
			if IsAltKeyDown() and potionCheck then
				SlashCmdList['exrtSlash']('potionchat')
			elseif IsControlKeyDown() then
				scanBuff()
			end
		elseif btn == 'LeftButton' then
			if InCombatLockdown() then UIErrorsFrame:AddMessage(C.InfoColor..ERR_NOT_IN_COMBAT) return end
			if IsInGroup() and (UnitIsGroupLeader('player') or (UnitIsGroupAssistant('player') and IsInRaid())) then
				DoReadyCheck()
			else
				UIErrorsFrame:AddMessage(C.InfoColor..ERR_NOT_LEADER)
			end
		else
			if IsInGroup() and (UnitIsGroupLeader('player') or (UnitIsGroupAssistant('player') and IsInRaid())) then
				if IsAddOnLoaded('DBM-Core') then
					if reset then
						SlashCmdList['DEADLYBOSSMODS']('pull '..FreeDB.misc.countdown)
					else
						SlashCmdList['DEADLYBOSSMODS']('pull 0')
					end
					reset = not reset
				elseif IsAddOnLoaded('BigWigs') then
					if not SlashCmdList['BIGWIGSPULL'] then LoadAddOn('BigWigs_Plugins') end
					if reset then
						SlashCmdList['BIGWIGSPULL'](FreeDB.misc.countdown)
					else
						SlashCmdList['BIGWIGSPULL']('0')
					end
					reset = not reset
				else
					UIErrorsFrame:AddMessage(C.InfoColor..L['MISC_ADDON_REQUIRED'])
				end
			else
				UIErrorsFrame:AddMessage(C.InfoColor..ERR_NOT_LEADER)
			end
		end
	end)
	checker:RegisterEvent('PLAYER_REGEN_ENABLED')
	checker:SetScript('OnEvent', function() reset = true end)

	-- Others
	local menu = CreateFrame('Frame', nil, header)
	menu:SetPoint('TOP', header, 'BOTTOM', 0, -3)
	menu:SetSize(182, 70)
	F.SetBD(menu)
	menu:Hide()
	menu:SetScript('OnLeave', function(self)
		self:SetScript('OnUpdate', function(self, elapsed)
			self.timer = (self.timer or 0) + elapsed
			if self.timer > .1 then
				if not menu:IsMouseOver() then
					self:Hide()
					self:SetScript('OnUpdate', nil)
				end

				self.timer = 0
			end
		end)
	end)

	StaticPopupDialogs['Group_Disband'] = {
		text = L['MISC_DISBAND_CHECK'],
		button1 = YES,
		button2 = NO,
		OnAccept = function()
			if InCombatLockdown() then UIErrorsFrame:AddMessage(C.InfoColor..ERR_NOT_IN_COMBAT) return end
			if IsInRaid() then
				SendChatMessage(L['MISC_DISBAND_PROCESS'], 'RAID')
				for i = 1, GetNumGroupMembers() do
					local name, _, _, _, _, _, _, online = GetRaidRosterInfo(i)
					if online and name ~= C.MyName then
						UninviteUnit(name)
					end
				end
			else
				for i = _G.MAX_PARTY_MEMBERS, 1, -1 do
					if UnitExists('party'..i) then
						UninviteUnit(UnitName('party'..i))
					end
				end
			end
			LeaveParty()
		end,
		timeout = 0,
		whileDead = 1,
	}

	local buttons = {
		{TEAM_DISBAND, function()
			if UnitIsGroupLeader('player') then
				StaticPopup_Show('Group_Disband')
			else
				UIErrorsFrame:AddMessage(C.InfoColor..ERR_NOT_LEADER)
			end
		end},
		{CONVERT_TO_RAID, function()
			if UnitIsGroupLeader('player') and not HasLFGRestrictions() and GetNumGroupMembers() <= 5 then
				if IsInRaid() then ConvertToParty() else ConvertToRaid() end
				menu:Hide()
				menu:SetScript('OnUpdate', nil)
			else
				UIErrorsFrame:AddMessage(C.InfoColor..ERR_NOT_LEADER)
			end
		end},
		{ROLE_POLL, function()
			if IsInGroup() and not HasLFGRestrictions() and (UnitIsGroupLeader('player') or (UnitIsGroupAssistant('player') and IsInRaid())) then
				InitiateRolePoll()
			else
				UIErrorsFrame:AddMessage(C.InfoColor..ERR_NOT_LEADER)
			end
		end},
		{RAID_CONTROL, function() ToggleFriendsFrame(3) end},
	}
	local bu = {}
	for i, j in pairs(buttons) do
		bu[i] = F.CreateButton(menu, 84, 28, j[1], 12)
		bu[i]:SetPoint(mod(i, 2) == 0 and 'TOPRIGHT' or 'TOPLEFT', mod(i, 2) == 0 and -5 or 5, i > 2 and -37 or -5)
		bu[i]:SetScript('OnClick', j[2])
	end

	local function updateText(text)
		if IsInRaid() then
			text:SetText(CONVERT_TO_PARTY)
		else
			text:SetText(CONVERT_TO_RAID)
		end
	end
	header:RegisterForClicks('AnyUp')
	header:SetScript('OnClick', function(_, btn)
		if btn == 'LeftButton' then
			F:TogglePanel(menu)

			if menu:IsShown() then
				menu:ClearAllPoints()
				if IsManagerOnTop() then
					menu:SetPoint('TOP', header, 'BOTTOM', 0, -3)
				else
					menu:SetPoint('BOTTOM', header, 'TOP', 0, 3)
				end

				updateText(bu[2].text)
			end
		end
	end)
	header:SetScript('OnDoubleClick', function(_, btn)
		if btn == 'RightButton' and (IsPartyLFG() and IsLFGComplete() or not IsInInstance()) then
			LeaveParty()
		end
	end)
	header:HookScript('OnShow', function(self)
		self:SetBackdropColor(0, 0, 0, .6)
		self:SetBackdropBorderColor(0, 0, 0, 1)
	end)



	-- UIWidget reanchor
	if not UIWidgetTopCenterContainerFrame:IsMovable() then -- can be movable for some addons, eg BattleInfo
		UIWidgetTopCenterContainerFrame:ClearAllPoints()
		UIWidgetTopCenterContainerFrame:SetPoint('TOP', 0, -35)
	end
end
MISC:RegisterMisc('GroupTool', MISC.GroupTool)
