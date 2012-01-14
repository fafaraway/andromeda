-- rBuffFrameStyler by Roth, modified.

local F, C, L = unpack(select(2, ...))

local BuffFrame               = _G["BuffFrame"]
local TemporaryEnchantFrame   = _G["TemporaryEnchantFrame"]
local ConsolidatedBuffs       = _G["ConsolidatedBuffs"]

local updateBuffAnchors = function()
	local numBuffs = 0
	local buff, previousBuff, aboveBuff
	for i = 1, BUFF_ACTUAL_DISPLAY do
		buff = _G["BuffButton"..i]
		buff:SetParent(BuffFrame)
		buff.consolidated = nil		buff.parent = BuffFrame
		buff:ClearAllPoints()
		numBuffs = numBuffs + 1
		index = numBuffs
		if ((index > 1) and (mod(index, 8) == 1)) then
			buff:SetPoint("TOP", aboveBuff, "BOTTOM", 0, -4)
			aboveBuff = buff
		elseif index == 1 then
			buff:SetPoint("TOPRIGHT", BuffFrame, "TOPRIGHT", 0, 0)
			aboveBuff = buff
		else
			buff:SetPoint("RIGHT", previousBuff, "LEFT", -3, 0)
		end
		previousBuff = buff
	end
end

local f = CreateFrame("Frame", "FreeUI_BuffFrameHolder", UIParent)
f:SetSize(50, 50)
f:SetPoint("TOPRIGHT", UIParent, "TOPRIGHT", -50, -50)

for i = 1, 3 do
	local bu = _G["TempEnchant"..i]
	bu:ClearAllPoints()
	bu:SetPoint("BOTTOMRIGHT", UIParent, "BOTTOMRIGHT", -10, 15+35*i)
end
  
BuffFrame:SetParent(f)
BuffFrame:ClearAllPoints()
BuffFrame:SetPoint("TOPRIGHT")
BuffFrame.SetPoint = F.dummy

local function durationSetText(duration, arg1, arg2)
	duration:SetText(format("|cffffffff"..string.gsub(arg1, " ", "").."|r", arg2))
end

local function applySkin(b, button)
	if b then
		local border = _G[button.."Border"]
		if border then border:Hide() end
      
		local icon = _G[button.."Icon"]
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

		local bg = b:CreateTexture(nil, "BACKGROUND")
		bg:SetPoint("TOPLEFT", -1, 1)
		bg:SetPoint("BOTTOMRIGHT", 1, -1)
		bg:SetTexture(C.media.backdrop)
		bg:SetVertexColor(0, 0, 0)

		b.styled = true
	end
end

local function checkauras()
	for i = 1, BUFF_MAX_DISPLAY do
		local b = _G["BuffButton"..i]
		if b and not b.styled then
			applySkin(b, "BuffButton"..i)
		end
	end
	for i = 1, DEBUFF_MAX_DISPLAY do
		local b = _G["DebuffButton"..i]
		if b then
			b:Hide()
			b.Show = b.Hide
		end
	end
end

for i = 1, NUM_TEMP_ENCHANT_FRAMES do
	applySkin(_G["TempEnchant"..i], "TempEnchant"..i)
end

hooksecurefunc("BuffFrame_UpdateAllBuffAnchors", updateBuffAnchors)

local a = CreateFrame("Frame")
a:RegisterEvent("PLAYER_ENTERING_WORLD")
a:RegisterEvent("UNIT_AURA")
a:SetScript("OnEvent", function(self, event, ...)
	local unit = ...
	if event == "PLAYER_ENTERING_WORLD" then
		checkauras()
	elseif event == "UNIT_AURA" then
		if (unit == PlayerFrame.unit) then
			checkauras()
		end
	end
end)