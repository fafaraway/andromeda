-- rBuffFrameStyler by Roth, modified.

local F, C, L = unpack(select(2, ...))

local BuffFrame               = BuffFrame
local ConsolidatedBuffs       = ConsolidatedBuffs

BUFFS_PER_ROW = BUFFS_PER_ROW

local function durationSetText(duration, arg1, arg2)
	duration:SetText(format("|cffffffff"..string.gsub(arg1, " ", "").."|r", arg2))
end

local function applySkin(b)
	if not b or (b and b.styled) then return end

	local name = b:GetName()

	local border = _G[name.."Border"]
	if border then border:Hide() end

	local icon = _G[name.."Icon"]
	icon:SetTexCoord(.08, .92, .08, .92)
	icon:SetDrawLayer("BACKGROUND", 1)

	b.duration:SetFont(C.media.font, 8, "OUTLINEMONOCHROME")
	b.duration:SetShadowOffset(0, 0)
	b.duration:ClearAllPoints()
	b.duration:SetPoint("BOTTOM", 1, -2)

	hooksecurefunc(b.duration, "SetFormattedText", durationSetText)

	b.count:SetFont(C.media.font, 8, "OUTLINEMONOCHROME")
	b.count:ClearAllPoints()
	b.count:SetPoint("TOP", b, "TOP", 2, -2)

	F.CreateBG(b)

	b.styled = true
end

local updateBuffAnchors = function()
	local buff, previousBuff, aboveBuff, index
	local numBuffs = 0
	local slack = 0

	if ConsolidatedBuffs:IsShown() then
		slack = slack + 1
	end

	for i = 1, BUFF_ACTUAL_DISPLAY do
		buff = _G["BuffButton"..i]
		if not buff.consolidated then
			if not buff.styled then applySkin(buff) end
			--[[buff:SetParent(BuffFrame)
			buff.consolidated = nil
			buff.parent = BuffFrame]]
			buff:ClearAllPoints()
			numBuffs = numBuffs + 1
			index = numBuffs + slack
			if index > 1 and (mod(index, BUFFS_PER_ROW) == 1) then
				if index == BUFFS_PER_ROW + 1 then
					buff:SetPoint("TOP", ConsolidatedBuffs, "BOTTOM", 0, -4)
				else
					buff:SetPoint("TOP", aboveBuff, "BOTTOM", 0, -4)
				end
				aboveBuff = buff
			elseif index == 1 then
				buff:SetPoint("TOPRIGHT", BuffFrame, "TOPRIGHT", 0, 0)
				--aboveBuff = buff
			else
				if numBuffs == 1 then
					buff:SetPoint("TOPRIGHT", ConsolidatedBuffs, "TOPLEFT", -3, 0)
				else
					buff:SetPoint("RIGHT", previousBuff, "LEFT", -3, 0)
				end
			end
			previousBuff = buff
		end
	end
end

local function updateDebuffAnchors(_, index)
	_G["DebuffButton"..index]:Hide()
end

local f = CreateFrame("Frame", "FreeUI_BuffFrameHolder", UIParent)
f:SetSize(50, 50)
f:SetPoint("TOPRIGHT", UIParent, "TOPRIGHT", -50, -50)

BuffFrame:SetParent(f)
BuffFrame:ClearAllPoints()
BuffFrame:SetPoint("TOPRIGHT")

ConsolidatedBuffs:SetParent(f)
ConsolidatedBuffs:ClearAllPoints()
ConsolidatedBuffs:SetPoint("TOPRIGHT")

ConsolidatedBuffs.count:SetFont(C.media.font, 8, "OUTLINEMONOCHROME")
ConsolidatedBuffs.count:ClearAllPoints()
ConsolidatedBuffs.count:SetPoint("TOP", ConsolidatedBuffs, "TOP", 2, -2)
ConsolidatedBuffsIcon:SetSize(30, 30)
ConsolidatedBuffsIcon:SetTexCoord(.16, .34, .31, .69)
ConsolidatedBuffsIcon:SetDrawLayer("BACKGROUND", 1)
F.CreateBG(ConsolidatedBuffs)

ConsolidatedBuffsTooltip:SetScale(1)
F.CreateBD(ConsolidatedBuffsTooltip)

for i = 1, NUM_LE_RAID_BUFF_TYPES do
	local buff = ConsolidatedBuffsTooltip["Buff"..i]

	buff.label:SetFont(C.media.font, 8, "OUTLINEMONOCHROME")
	buff.label:SetShadowColor(0, 0, 0, 0)
	buff.icon:SetTexCoord(.08, .92, .08, .92)

	F.CreateBDFrame(buff.icon, .25)
end

hooksecurefunc("RaidBuffTray_Update", function()
	if ShouldShowConsolidatedBuffFrame() then
		for i = 1, NUM_LE_RAID_BUFF_TYPES do
			local buff = ConsolidatedBuffsTooltip["Buff"..i]
			if not buff.name then buff.icon:SetTexture("") end
		end
	end
end)

for i = 1, NUM_TEMP_ENCHANT_FRAMES do
	local bu = _G["TempEnchant"..i]
	bu:ClearAllPoints()
	bu:SetPoint("BOTTOMRIGHT", UIParent, "BOTTOMRIGHT", -10, 15+35*i)
	applySkin(bu)
end

hooksecurefunc("BuffFrame_UpdateAllBuffAnchors", updateBuffAnchors)
hooksecurefunc("DebuffButton_UpdateAnchors", updateDebuffAnchors)

local function reposition()
	BuffFrame:ClearAllPoints()
	BuffFrame:SetPoint("TOPRIGHT")
end

TicketStatusFrame:HookScript("OnShow", reposition)
TicketStatusFrame:HookScript("OnHide", reposition)