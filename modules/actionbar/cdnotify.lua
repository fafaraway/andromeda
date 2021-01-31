local F, C, L = unpack(select(2, ...))
local ACTIONBAR = F.ACTIONBAR

local _G = _G
local format = format
local GetSpellCooldown = GetSpellCooldown
local GetSpellLink = GetSpellLink
local GetItemCooldown = GetItemCooldown
local GetActionInfo = GetActionInfo
local GetItemInfo = GetItemInfo
local SendChatMessage = SendChatMessage
local GetMacroSpell = GetMacroSpell
local GetMacroItem = GetMacroItem
local GetItemInfoFromHyperlink = GetItemInfoFromHyperlink
local IsInGroup = IsInGroup
local GetTime = GetTime
local IsPartyLFG = IsPartyLFG
local IsInRaid = IsInRaid

local debugMode = false
local function sendNotifyMsg(msg)
	if debugMode and C.isDeveloper then
		print(msg)
	elseif IsPartyLFG() then
		SendChatMessage(msg, 'INSTANCE_CHAT')
	elseif IsInRaid() then
		SendChatMessage(msg, 'RAID')
	elseif IsInGroup() then
		SendChatMessage(msg, 'PARTY')
	end
end

local function GetRemainTime(second)
	if second > 60 then
		return format('%d:%.2d', second / 60, second % 60)
	else
		return format('%ds', second)
	end
end

local lastCDSend = 0
function ACTIONBAR:SendCurrentSpell(thisTime, spellID)
	local start, duration = GetSpellCooldown(spellID)
	local spellLink = GetSpellLink(spellID)
	if start and duration > 0 then
		local remain = start + duration - thisTime
		sendNotifyMsg(format(L.ACTIONBAR.CD_REMAINING, spellLink, GetRemainTime(remain)))
	else
		sendNotifyMsg(format(L.ACTIONBAR.CD_FINISHED, spellLink))
	end
end

function ACTIONBAR:SendCurrentItem(thisTime, itemID, itemLink)
	local start, duration = GetItemCooldown(itemID)
	if start and duration > 0 then
		local remain = start + duration - thisTime
		sendNotifyMsg(format(L.ACTIONBAR.CD_REMAINING, itemLink, GetRemainTime(remain)))
	else
		sendNotifyMsg(format(L.ACTIONBAR.CD_FINISHED, itemLink))
	end
end

function ACTIONBAR:AnalyzeButtonCooldown()
	if not C.DB.Actionbar.CDNotify then
		return
	end
	if not IsInGroup() then
		return
	end

	local thisTime = GetTime()
	if thisTime - lastCDSend < 1.5 then
		return
	end
	lastCDSend = thisTime

	local spellType, id = GetActionInfo(self.action)
	if spellType == 'spell' then
		ACTIONBAR:SendCurrentSpell(thisTime, id)
	elseif spellType == 'item' then
		local itemName, itemLink = GetItemInfo(id)
		ACTIONBAR:SendCurrentItem(thisTime, id, itemLink or itemName)
	elseif spellType == 'macro' then
		local spellID = GetMacroSpell(id)
		local _, itemLink = GetMacroItem(id)
		local itemID = itemLink and GetItemInfoFromHyperlink(itemLink)
		if spellID then
			ACTIONBAR:SendCurrentSpell(thisTime, spellID)
		elseif itemID then
			ACTIONBAR:SendCurrentItem(thisTime, itemID, itemLink)
		end
	end
end

function ACTIONBAR:CooldownNotify()
	if not C.DB.Actionbar.Enable then
		return
	end

	local Bar = F.ACTIONBAR
	for _, button in pairs(Bar.buttons) do
		button:HookScript('OnMouseWheel', ACTIONBAR.AnalyzeButtonCooldown)
	end
end
