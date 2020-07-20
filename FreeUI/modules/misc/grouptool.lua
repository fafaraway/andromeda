local F, C, L = unpack(select(2, ...))
local MISC, cfg = F:GetModule('Misc'), C.General

-- # TODO need refactor group tool

local function CheckVisibility(f)
	if IsInGroup() then
		f:Show()
	else
		f:Hide()
	end
end

local function CheckPermission()
	if UnitIsGroupLeader('player') or UnitIsGroupAssistant('player') then
		return true
	else
		UIErrorsFrame:AddMessage(C.RedColor..ERR_NOT_LEADER)
	end
end

local function CreateHolder()
	local f = CreateFrame('Frame', nil, UIParent)
	f:SetFrameStrata('MEDIUM')
	f:SetHeight(250)
	f:SetWidth(32)
	f:SetPoint('CENTER')

	CheckVisibility(f)
	F:RegisterEvent("GROUP_ROSTER_UPDATE", function()
		CheckVisibility(f)
	end)
end


local converttip
local function ButtonTemplate(button, parent, size, a1, a2, x, y, fsize, text, tip)
	local bu = CreateFrame('Button', button, f)
	bu:SetSize(size, size)
	bu:SetPoint(a1, parent, a2, x, y)
	bu.text = F.CreateFS(bu, C.Assets.Fonts.Symbol, fsize, nil, text, nil, true, 'CENTER', 0, 0) 
	bu.text:SetTextColor(1, 1, 1, .2)

	--bu:RegisterEvent('PLAYER_ENTERING_WORLD')
	--bu:RegisterEvent('GROUP_ROSTER_UPDATE')

	bu:SetScript('OnEnter', function(self)
		self.text:SetTextColor(C.r, C.g, C.b, 1) 
		GameTooltip:SetOwner(self, 'ANCHOR_RIGHT')
		if tip then GameTooltip:AddLine(tip) else GameTooltip:AddLine(converttip) end
		GameTooltip:Show()
	end)

	bu:SetScript('OnLeave', function(self) 
		self.text:SetTextColor(1, 1, 1, .2)
		GameTooltip:Hide()	
	end)
end

local function CreateButtons()
	if not IsInGroup() then return end

	F:RegisterEvent("GROUP_ROSTER_UPDATE", function()
		CreateHolder()
	end)

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

	ButtonTemplate('rolecheck', readycheck, 30, 'TOP', 'BOTTOM', 0, 0, 24, '|' ,ROLE_POLL)
	rolecheck:SetScript('OnMouseUp', function(self)
		if UnitIsGroupLeader('player') or UnitIsGroupAssistant('player') then
			InitiateRolePoll()
		else
			UIErrorsFrame:AddMessage(C.InfoColor..ERR_NOT_LEADER)
		end
	end)

	

	ButtonTemplate('raid', rolecheck, 30, 'TOP', 'BOTTOM', -2, 0, 24, 'r', RAID_CONTROL)
	raid:SetScript('OnMouseUp', function(self) ToggleFriendsFrame(3) end)

	ButtonTemplate('convert', raid, 30, 'TOP', 'BOTTOM', 2, 5, 22, 'h')
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

	ButtonTemplate('mark', convert, 30, 'TOP', 'BOTTOM', -4, -2, 24, 'y', 'mark')

	ButtonTemplate('disband', mark, 30, 'TOP', 'BOTTOM', 2, 0, 24, 'Z', PARTY_LEAVE)
	disband:SetScript('OnMouseUp', function(self) 
		LeaveParty()
	end)
end


-- F:RegisterEvent("PLAYER_ENTERING_WORLD", function()
-- 	CreateButtons()
-- end)

function MISC:GroupTool()
	CreateHolder()
	CreateButtons()
end


--f:SetScript('OnEvent', CreateButtons)


--[[f:RegisterEvent('PLAYER_ENTERING_WORLD')
f:RegisterEvent('GROUP_ROSTER_UPDATE')
f:SetScript('OnEvent', function(self, event)
	converttip = UnitInRaid('player') and CONVERT_TO_PARTY or CONVERT_TO_RAID

	--if event == 'PLAYER_ENTERING_WORLD' then
	--	CreateButtons()
	--end

	--self:UnregisterEvent('PLAYER_ENTERING_WORLD')

	if IsInGroup() then
		self:Show()
	else
		self:Hide()
	end
end)--]]


-- local check = CreateFrame('Frame')
-- check:RegisterEvent('GROUP_ROSTER_UPDATE')
-- check:RegisterEvent('PLAYER_ENTERING_WORLD')
-- check:SetScript('OnEvent', function(self, event)
-- 	converttip = UnitInRaid('player') and CONVERT_TO_PARTY or CONVERT_TO_RAID
-- 	if InCombatLockdown() then
-- 		self:RegisterEvent("PLAYER_REGEN_ENABLED")
-- 		return
-- 	end	
-- 	if CheckRaidStatus() then
-- 		f:Show()
-- 	else
-- 		f:Hide()
-- 	end
-- 	if event == "PLAYER_REGEN_ENABLED" then
-- 		self:UnregisterEvent("PLAYER_REGEN_ENABLED")
-- 	end
-- end)