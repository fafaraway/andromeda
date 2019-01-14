local F, C, L = unpack(select(2, ...))

if not C.general.raidManager then return end

local converttip

local f = CreateFrame('Frame', 'RaidManagerFrame', UIParent)
f:SetFrameStrata('MEDIUM')
f:SetHeight(250)
f:SetWidth(40)
f:SetPoint(unpack(C.general.raidManager_Position))
f:Hide()
f:RegisterEvent('PLAYER_LOGIN')


local marker = CompactRaidFrameManagerDisplayFrameLeaderOptionsRaidWorldMarkerButton
if not marker then
	for _, addon in next, {"Blizzard_CUFProfiles", "Blizzard_CompactRaidFrames"} do
		EnableAddOn(addon)
		LoadAddOn(addon)
	end
end


local function CheckRaidStatus()
	if IsInGroup() then
		return true
	else
		return false
	end
end

local function textbutton(button, parent, size, a1, a2, x, y, fsize, text, tip)
	b = CreateFrame('Button', button, f, 'SecureActionButtonTemplate')
	b:SetSize(size,size)
	b:SetPoint(a1,parent,a2,x,y)
	b.text = F.CreateFS(b, 'Interface\\AddOns\\FreeUI\\assets\\font\\symbol.ttf', fsize, nil, {1,1,1,.3}, {0,0,0}, 1, -1) 
	b.text:SetText(text)
	b.text:SetPoint('CENTER')
	b.text:SetTextColor(1, 1, 1, .2)
	b:RegisterEvent('GROUP_ROSTER_UPDATE')
	b:SetScript('OnEnter', function(self)
		self.text:SetTextColor(C.r, C.g, C.b, 1) 
		GameTooltip:SetOwner(self, 'ANCHOR_RIGHT', 0, 0)
		if tip then GameTooltip:AddLine(tip) else GameTooltip:AddLine(converttip) end
		GameTooltip:Show()
	end)
	b:SetScript('OnLeave', function(self) 
		self.text:SetTextColor(1, 1, 1, .2)
		GameTooltip:Hide()	
	end)
end

local function buttons()
	textbutton('pull', f, 30, 'TOPRIGHT', 'TOPRIGHT', 0, -5, 27, 'B', L['Pull'])
	pull:SetAttribute('type', 'macro')

	if IsAddOnLoaded("DBM-Core") then
		pull:SetAttribute('macrotext', format('/dbm pull %d', 10))
	elseif IsAddOnLoaded("BigWigs") then
		pull:SetAttribute('macrotext', format('/pull %d', 10))
	end

	textbutton('readycheck', pull, 30, 'TOP', 'BOTTOM', 1, -4, 24, 'x', READY_CHECK)
	readycheck:SetScript("OnMouseUp", function(self)
		if UnitIsGroupLeader("player") or UnitIsGroupAssistant("player") then
			DoReadyCheck()
		else
			UIErrorsFrame:AddMessage(C.InfoColor..ERR_NOT_LEADER)
		end
	end)

	textbutton('rolecheck', readycheck, 30, 'TOP', 'BOTTOM', 0, 0, 24, 'z' ,ROLE_POLL)
	rolecheck:SetScript("OnMouseUp", function(self)
		if UnitIsGroupLeader("player") or UnitIsGroupAssistant("player") then
			InitiateRolePoll()
		else
			UIErrorsFrame:AddMessage(C.InfoColor..ERR_NOT_LEADER)
		end
	end)
	
	textbutton('assist', rolecheck, 30, 'TOP', 'BOTTOM', 0, 0, 24, '|', SET_RAID_ASSISTANT)

	assist:SetScript("OnMouseUp", function(self)
		if UnitIsGroupLeader("player") or UnitIsGroupAssistant("player") then
			if not UnitIsGroupAssistant('target') then
				PromoteToAssistant('target') 
			else
				DemoteAssistant('target')
			end
		else
			UIErrorsFrame:AddMessage(C.InfoColor..ERR_NOT_LEADER)
		end
	end)
	
	textbutton('maintank', assist, 30, 'TOP', 'BOTTOM', 0, 0, 24, '{', SET_MAIN_TANK)
	maintank:SetScript("OnMouseUp", function(self)
		if UnitIsGroupLeader("player") or UnitIsGroupAssistant("player") then
			maintank:SetAttribute('type', 'maintank')
			maintank:SetAttribute('unit', 'target')
			maintank:SetAttribute('action', 'toggle')
		else
			UIErrorsFrame:AddMessage(C.InfoColor..ERR_NOT_LEADER)
		end
	end)

	textbutton('disband', maintank, 30, 'TOP', 'BOTTOM', 0, -0, 24, 'p', PARTY_LEAVE)
	disband:SetScript('OnMouseUp', function(self) 
		LeaveParty()
	end)

	textbutton('raid', disband, 30, 'TOP', 'BOTTOM', 0, 0, 24, 'u', RAID_CONTROL)
	raid:SetScript('OnMouseUp', function(self) ToggleFriendsFrame(3) end)

	textbutton('convert', raid, 30, 'TOP', 'BOTTOM', 0, 5, 22, 'h')
	convert:SetScript('OnMouseUp', function(self)
		if UnitIsGroupLeader("player") or UnitIsGroupAssistant("player") then
			if UnitInRaid('player') then
				ConvertToParty()
				converttip = CONVERT_TO_RAID
			elseif UnitInParty('player') then
				ConvertToRaid()
				converttip = CONVERT_TO_RAID
			end
		else
			UIErrorsFrame:AddMessage(C.InfoColor..ERR_NOT_LEADER)
		end
	end)

	if marker then
		textbutton('mark', convert, 30, 'TOP', 'BOTTOM', 0, 0, 28, '[', WORLD_MARKER)
		marker:ClearAllPoints()
		marker:SetAllPoints(mark)
		marker:SetParent(mark)
		marker:SetAlpha(0)
		marker:HookScript('OnEnter', function() mark.text:SetVertexColor(C.r, C.g, C.b, 1) end)
		marker:HookScript('OnLeave', function() mark.text:SetVertexColor(1, 1, 1, .2) end)
		marker:HookScript("OnMouseUp", function(_, btn)
			if (IsInGroup() and not IsInRaid()) or UnitIsGroupLeader("player") or UnitIsGroupAssistant("player") then
				if btn == "RightButton" then ClearRaidMarker() end
			else
				UIErrorsFrame:AddMessage(C.InfoColor..ERR_NOT_LEADER)
			end
		end)
	end
end

f:SetScript('OnEvent', buttons)

local check = CreateFrame('Frame')
check:RegisterEvent('GROUP_ROSTER_UPDATE')
check:RegisterEvent('PLAYER_ENTERING_WORLD')
check:SetScript('OnEvent', function(self, event)
	converttip = UnitInRaid('player') and CONVERT_TO_PARTY or CONVERT_TO_RAID
	if InCombatLockdown() then
		self:RegisterEvent("PLAYER_REGEN_ENABLED")
		return
	end	
	if CheckRaidStatus() then
		f:Show()
	else
		f:Hide()
	end
	if event == "PLAYER_REGEN_ENABLED" then
		self:UnregisterEvent("PLAYER_REGEN_ENABLED")
	end
end)