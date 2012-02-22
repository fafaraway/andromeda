-- rBuffFrameStyler by Roth, modified.

local F, C, L = unpack(select(2, ...))

local BuffFrame               = _G["BuffFrame"]
local TemporaryEnchantFrame   = _G["TemporaryEnchantFrame"]
local ConsolidatedBuffs       = _G["ConsolidatedBuffs"]

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

	local bg = b:CreateTexture(nil, "BACKGROUND")
	bg:SetPoint("TOPLEFT", -1, 1)
	bg:SetPoint("BOTTOMRIGHT", 1, -1)
	bg:SetTexture(C.media.backdrop)
	bg:SetVertexColor(0, 0, 0)

	b.styled = true
end

local updateBuffAnchors = function()
	local numBuffs = 0
	local buff, previousBuff, aboveBuff
	for i = 1, BUFF_ACTUAL_DISPLAY do
		buff = _G["BuffButton"..i]
		if not buff.styled then applySkin(buff) end
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

local function updateDebuffAnchors(_, index)
	_G["DebuffButton"..index]:Hide()
end

local f = CreateFrame("Frame", "FreeUI_BuffFrameHolder", UIParent)
f:SetSize(50, 50)
f:SetPoint("TOPRIGHT", UIParent, "TOPRIGHT", -50, -50)
  
BuffFrame:SetParent(f)
BuffFrame:ClearAllPoints()
BuffFrame:SetPoint("TOPRIGHT")
BuffFrame.SetPoint = F.dummy

for i = 1, NUM_TEMP_ENCHANT_FRAMES do
	local bu = _G["TempEnchant"..i]
	bu:ClearAllPoints()
	bu:SetPoint("BOTTOMRIGHT", UIParent, "BOTTOMRIGHT", -10, 15+35*i)
	applySkin(bu)
end

hooksecurefunc("BuffFrame_UpdateAllBuffAnchors", updateBuffAnchors)
hooksecurefunc("DebuffButton_UpdateAnchors", updateDebuffAnchors)