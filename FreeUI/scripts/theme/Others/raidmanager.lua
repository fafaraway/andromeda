local F, C, L = unpack(select(2, ...))
local MISC = F:GetModule('Misc')


local converttip

local f = CreateFrame('Frame', 'FreeUIRaidManager', UIParent)
f:SetFrameStrata('MEDIUM')
f:SetHeight(250)
f:SetWidth(32)
f:SetPoint('LEFT')
f:Hide()

local function ButtonTemplate(button, parent, size, a1, a2, x, y, fsize, text, tip)
	local bu = CreateFrame('Button', button, f)
	bu:SetSize(size, size)
	bu:SetPoint(a1, parent, a2, x, y)
	bu.text = F.CreateFS(bu, {C.AssetsPath..'font\\symbol.ttf', fsize}, text, nil, nil, true, 'CENTER', 0, 0) 
	bu.text:SetTextColor(1, 1, 1, .2)
	bu:RegisterEvent('PLAYER_ENTERING_WORLD')
	bu:RegisterEvent('GROUP_ROSTER_UPDATE')
	bu:SetScript('OnEnter', function(self)
		self.text:SetTextColor(C.r, C.g, C.b, 1) 
		GameTooltip:SetOwner(self, 'ANCHOR_RIGHT', 0, 0)
		if tip then GameTooltip:AddLine(tip) else GameTooltip:AddLine(converttip) end
		GameTooltip:Show()
	end)
	bu:SetScript('OnLeave', function(self) 
		self.text:SetTextColor(1, 1, 1, .2)
		GameTooltip:Hide()	
	end)
end

local function CreateButtons()
	ButtonTemplate('pull', f, 30, 'TOPRIGHT', 'TOPRIGHT', 0, -5, 27, 'B', L['Pull'])
	pull:SetAttribute('type', 'macro')

	if IsAddOnLoaded('DBM-Core') then
		pull:SetAttribute('macrotext', format('/dbm pull %d', 10))
	elseif IsAddOnLoaded('BigWigs') then
		pull:SetAttribute('macrotext', format('/pull %d', 10))
	end

	ButtonTemplate('readycheck', pull, 30, 'TOP', 'BOTTOM', 1, -4, 24, 'x', READY_CHECK)
	readycheck:SetScript('OnMouseUp', function(self)
		if UnitIsGroupLeader('player') or UnitIsGroupAssistant('player') then
			DoReadyCheck()
		else
			UIErrorsFrame:AddMessage(C.InfoColor..ERR_NOT_LEADER)
		end
	end)

	ButtonTemplate('rolecheck', readycheck, 30, 'TOP', 'BOTTOM', 0, 0, 24, 'z' ,ROLE_POLL)
	rolecheck:SetScript('OnMouseUp', function(self)
		if UnitIsGroupLeader('player') or UnitIsGroupAssistant('player') then
			InitiateRolePoll()
		else
			UIErrorsFrame:AddMessage(C.InfoColor..ERR_NOT_LEADER)
		end
	end)

	ButtonTemplate('disband', rolecheck, 30, 'TOP', 'BOTTOM', 0, -0, 24, 'p', PARTY_LEAVE)
	disband:SetScript('OnMouseUp', function(self) 
		LeaveParty()
	end)

	ButtonTemplate('raid', disband, 30, 'TOP', 'BOTTOM', 0, 0, 24, 'u', RAID_CONTROL)
	raid:SetScript('OnMouseUp', function(self) ToggleFriendsFrame(3) end)

	ButtonTemplate('convert', raid, 30, 'TOP', 'BOTTOM', 0, 5, 22, 'h')
	convert:SetScript('OnMouseUp', function(self)
		if UnitIsGroupLeader('player') or UnitIsGroupAssistant('player') then
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
end



f:RegisterEvent('GROUP_ROSTER_UPDATE')
f:RegisterEvent('PLAYER_ENTERING_WORLD')
f:SetScript('OnEvent', function(self, event)
	converttip = UnitInRaid('player') and CONVERT_TO_PARTY or CONVERT_TO_RAID

	if event == 'PLAYER_ENTERING_WORLD' then
		CreateButtons()
	end

	self:UnregisterEvent('PLAYER_ENTERING_WORLD')

	if IsInGroup() then
		f:Show()
	else
		f:Hide()
	end
end)


