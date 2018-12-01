local F, C, L = unpack(select(2, ...))

local module = F:RegisterModule("auras")


local BuffFrame = BuffFrame
local buffsPerRow, buffSize, margin, offset = C.auras.buffPerRow, C.auras.buffSize, C.auras.paddingX, C.auras.paddingY
local debuffsPerRow, debuffSize = C.auras.buffPerRow, C.auras.debuffSize
local buffAnchor, debuffAnchor

function module:OnLogin()
	buffAnchor = CreateFrame("Frame", nil, UIParent)
	buffAnchor:SetPoint(unpack(C.auras.position))
	buffAnchor:SetSize((buffSize + margin)*buffsPerRow, (buffSize + offset)*3)

	debuffAnchor = CreateFrame("Frame", nil, UIParent)
	debuffAnchor:SetPoint("TOPRIGHT", buffAnchor, "BOTTOMRIGHT", 0, -offset+30)
	debuffAnchor:SetSize((debuffSize + margin)*debuffsPerRow, (debuffSize + offset)*2)

	for i = 1, 3 do
		local enchant = _G["TempEnchant"..i]
		enchant:ClearAllPoints()
		if i == 1 then
			enchant:SetPoint("TOPRIGHT", buffAnchor)
		else
			enchant:SetPoint("TOPRIGHT", _G["TempEnchant"..(i-1)], "TOPLEFT", -margin, 0)
		end
	end
	TempEnchant3:Hide()
	BuffFrame.ignoreFramePositionManager = true
end

local function styleButton(bu, isDebuff)
	if not bu or bu.styled then return end
	local name = bu:GetName()

	local iconSize = buffSize
	if isDebuff then iconSize = debuffSize end

	local border = _G[name.."Border"]
	if border then border:Hide() end

	local icon = _G[name.."Icon"]
	icon:SetAllPoints()
	icon:SetTexCoord(unpack(C.TexCoord))
	icon:SetDrawLayer("BACKGROUND", 1)

	local duration = _G[name.."Duration"]
	duration:ClearAllPoints()
	duration:SetPoint("TOP", bu, "BOTTOM", 2, 2)
	F.SetFS(duration)

	local count = _G[name.."Count"]
	count:ClearAllPoints()
	count:SetParent(bu)
	count:SetPoint("TOPRIGHT", bu, "TOPRIGHT", -1, -3)
	F.SetFS(count)

	bu:SetSize(iconSize, iconSize)
	bu.HL = bu:CreateTexture(nil, "HIGHLIGHT")
	bu.HL:SetColorTexture(1, 1, 1, .25)
	bu.HL:SetAllPoints(icon)

	local bg = F.CreateBG(bu)
	local sd = F.CreateSD(bg)
	bu.bg = bg
	bu.sd = sd

	bu.styled = true
end

local function reskinBuffs()
	local buff, previousBuff, aboveBuff, index
	local numBuffs = 0
	local slack = BuffFrame.numEnchants

	for i = 1, BUFF_ACTUAL_DISPLAY do
		buff = _G["BuffButton"..i]
		styleButton(buff)

		numBuffs = numBuffs + 1
		index = numBuffs + slack
		buff:ClearAllPoints()
		if index > 1 and mod(index, buffsPerRow) == 1 then
			if index == buffsPerRow + 1 then
				buff:SetPoint("TOP", TempEnchant1, "BOTTOM", 0, -offset)
			else
				buff:SetPoint("TOP", aboveBuff, "BOTTOM", 0, -offset)
			end
			aboveBuff = buff
		elseif numBuffs == 1 and slack == 0 then
			buff:SetPoint("TOPRIGHT", buffAnchor)
		elseif numBuffs == 1 and slack > 0 then
			buff:SetPoint("TOPRIGHT", _G["TempEnchant"..slack], "TOPLEFT", -margin, 0)
		else
			buff:SetPoint("RIGHT", previousBuff, "LEFT", -margin, 0)
		end
		previousBuff = buff
	end
end
hooksecurefunc("BuffFrame_UpdateAllBuffAnchors", reskinBuffs)

local function reskinTempEnchant()
	for i = 1, NUM_TEMP_ENCHANT_FRAMES do
		local bu = _G["TempEnchant"..i]
		styleButton(bu)
	end
end
hooksecurefunc("TemporaryEnchantFrame_Update", reskinTempEnchant)

local function reskinDebuffs(buttonName, i)
	local debuff = _G[buttonName..i]
	styleButton(debuff, true)

	debuff:ClearAllPoints()
	if i > 1 and mod(i, debuffsPerRow) == 1 then
		debuff:SetPoint("TOP", _G[buttonName..(i-debuffsPerRow)], "BOTTOM", 0, -offset)
	elseif i == 1 then
		debuff:SetPoint("TOPRIGHT", debuffAnchor)
	else
		debuff:SetPoint("RIGHT", _G[buttonName..(i-1)], "LEFT", -margin, 0)
	end
end
hooksecurefunc("DebuffButton_UpdateAnchors", reskinDebuffs)

local function updateDebuffBorder(buttonName, index, filter)
	local unit = PlayerFrame.unit
	local name, _, _, debuffType = UnitAura(unit, index, filter)
	if not name then return end
	local bu = _G[buttonName..index]
	if not (bu and bu.bg) then return end

	if filter == "HARMFUL" then
		local color = DebuffTypeColor[debuffType or "none"]
		bu.bg:SetVertexColor(color.r, color.g, color.b)
	end
end
hooksecurefunc("AuraButton_Update", updateDebuffBorder)

local function flashOnEnd(self)
	if self.timeLeft < 10 then
		self:SetAlpha(BuffFrame.BuffAlphaValue)
	else
		self:SetAlpha(1)
	end
end
hooksecurefunc("AuraButton_OnUpdate", flashOnEnd)

local function formatAuraTime(seconds)
	local d, h, m, str = 0, 0, 0
	if seconds >= 86400 then
		d = seconds/86400
		seconds = seconds%86400
	end
	if seconds >= 3600 then
		h = seconds/3600
		seconds = seconds%3600
	end
	if seconds >= 60 then
		m = seconds/60
		seconds = seconds%60
	end
	if d > 0 then
		str = format("%d"..C.InfoColor.."d", d)
	elseif h > 0 then
		str = format("%d"..C.InfoColor.."h", h)
	elseif m >= 10 then
		str = format("%d"..C.InfoColor.."m", m)
	elseif m > 0 and m < 10 then
		str = format("%d:%.2d", m, seconds)
	else
		if seconds <= 5 then
			str = format("|cffff0000%.1f|r", seconds) -- red
		elseif seconds <= 10 then
			str = format("|cffffff00%.1f|r", seconds) -- yellow
		else
			str = format("%d"..C.InfoColor.."s", seconds)
		end
	end

	return str
end

hooksecurefunc("AuraButton_UpdateDuration", function(button, timeLeft)
	local duration = button.duration
	if SHOW_BUFF_DURATIONS == "1" and timeLeft then
		duration:SetText(formatAuraTime(timeLeft))
		duration:SetVertexColor(1, 1, 1)
		duration:Show()
	else
		duration:Hide()
	end
end)
