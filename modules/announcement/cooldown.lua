local F, C, L = unpack(select(2, ...))
local ANNOUNCEMENT = F.ANNOUNCEMENT

local function GetRemainTime(second)
	if second > 60 then
		return format('%d:%.2d', second / 60, second % 60)
	else
		return format('%ds', second)
	end
end

local lastCDSend = 0
function ANNOUNCEMENT:SendCurrentSpell(thisTime, spellID)
	local start, duration = GetSpellCooldown(spellID)
	local spellLink = GetSpellLink(spellID)
	if start and duration > 0 then
		local remain = start + duration - thisTime
		SendChatMessage(format(L['ANNOUNCEMENT_COOLDOWN_REMAINING'], spellLink, GetRemainTime(remain)), ANNOUNCEMENT:GetChannel())
	else
		SendChatMessage(format(L['ANNOUNCEMENT_COOLDOWN_COMPLETED'], spellLink), ANNOUNCEMENT:GetChannel())
	end
end

function ANNOUNCEMENT:SendCurrentItem(thisTime, itemID, itemLink)
	local start, duration = GetItemCooldown(itemID)
	if start and duration > 0 then
		local remain = start + duration - thisTime
		SendChatMessage(format(L['ANNOUNCEMENT_COOLDOWN_REMAINING'], itemLink, GetRemainTime(remain)), ANNOUNCEMENT:GetChannel())
	else
		SendChatMessage(format(L['ANNOUNCEMENT_COOLDOWN_COMPLETED'], itemLink), ANNOUNCEMENT:GetChannel())
	end
end

function ANNOUNCEMENT:AnalyzeButtonCooldown()
	if not C.DB.announcement.cooldown then
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
		ANNOUNCEMENT:SendCurrentSpell(thisTime, id)
	elseif spellType == 'item' then
		local itemName, itemLink = GetItemInfo(id)
		ANNOUNCEMENT:SendCurrentItem(thisTime, id, itemLink or itemName)
	elseif spellType == 'macro' then
		local spellID = GetMacroSpell(id)
		local _, itemLink = GetMacroItem(id)
		local itemID = itemLink and GetItemInfoFromHyperlink(itemLink)
		if spellID then
			ANNOUNCEMENT:SendCurrentSpell(thisTime, spellID)
		elseif itemID then
			ANNOUNCEMENT:SendCurrentItem(thisTime, itemID, itemLink)
		end
	end
end

function ANNOUNCEMENT:SendCDStatus()
	if not C.DB.actionbar.enable then
		return
	end

	local Bar = F.ACTIONBAR
	for _, button in pairs(Bar.buttons) do
		button:HookScript('OnMouseWheel', ANNOUNCEMENT.AnalyzeButtonCooldown)
	end
end
