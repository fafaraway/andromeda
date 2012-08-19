-- aThreatmeter by Alza, partially modified.

local F, C, L = unpack(select(2, ...))

local f = CreateFrame("StatusBar", "FreeUIThreatMeter", UIParent)
f:SetStatusBarTexture(C.media.texture)
f:SetMinMaxValues(0, 100)
f:SetWidth(C.unitframes.target_width)
f:SetHeight(1)
f:Hide()

local bg = CreateFrame("Frame", nil, f)
bg:SetPoint("TOPLEFT", f, -1, 1)
bg:SetPoint("BOTTOMRIGHT", f, 1, -1)
bg:SetFrameLevel(f:GetFrameLevel()-1)
F.CreateBD(bg)

local nametext = F.CreateFS(f, 8, "LEFT")
nametext:SetPoint("BOTTOMLEFT", f, "TOPLEFT", 0, 2)

local addonLoaded
addonLoaded = function(_, addon)
	if addon ~= "FreeUI" then return end
	if FreeUIConfig.layout == 2 then
		aThreatMeter:UnregisterAllEvents()
		aThreatMeter:Hide()
	end
	F.UnregisterEvent("ADDON_LOADED", addonLoaded)
	addonLoaded = nil
end
F.RegisterEvent("ADDON_LOADED", addonLoaded)

local format, wipe, sort, tinsert, tremove, ipairs =
format, table.wipe, sort, tinsert, tremove, ipairs
local pname = UnitName("player")
local tunit, tguid = "target", ""
local tlist = {}

local function AddThreat(unit)
	if(not UnitIsVisible(unit)) then return end

	local _, _, perc = UnitDetailedThreatSituation(unit, tunit)
	if(not perc or perc<1) then return end

	local _, class = UnitClass(unit)
	local name = UnitName(unit)

	for index, value in ipairs(tlist) do
		if(value.name==name) then
			tremove(tlist, index)
			break
		end
	end

	tinsert(tlist, {
		name = name,
		class = class,
		perc = perc,
	})
end

local function SortThreat(a, b)
	return a.perc > b.perc
end

local function UpdateBar()
	sort(tlist, SortThreat)
	local tanking = UnitDetailedThreatSituation("player", tunit)
	for i, v in ipairs(tlist) do
		if((tanking and i==2) or (not tanking and v.name==pname)) then
			f:SetStatusBarColor(.3, 1, .3)
			f:SetValue(floor(v.perc))
			if(tanking) then
				nametext:SetText(v.name)
			else
				f:SetStatusBarColor(1, 30/255, 60/255)
				nametext:SetText("")
			end
			return f:Show()
		end
	end
	f:Hide()
end

f:RegisterEvent("PLAYER_ENTERING_WORLD")
function f:PLAYER_ENTERING_WORLD()
	f:UnregisterEvent("PLAYER_ENTERING_WORLD")
	f:SetPoint("BOTTOM", oUF_FreeTarget, "TOP", 0, 13)
end

f:RegisterEvent("PLAYER_REGEN_ENABLED")
function f:PLAYER_REGEN_ENABLED()
	wipe(tlist)
	UpdateBar()
end

f:RegisterEvent("PLAYER_TARGET_CHANGED")
function f:PLAYER_TARGET_CHANGED()
	wipe(tlist)
	if(UnitExists(tunit) and not UnitIsDead(tunit) and not UnitIsPlayer(tunit) and not UnitIsFriend("player", tunit)) then
		tguid = UnitGUID(tunit)
		if(UnitThreatSituation("player", tunit)) then
			f:UNIT_THREAT_LIST_UPDATE("UNIT_THREAT_LIST_UPDATE", tunit)
		else
			UpdateBar()
		end
	else
		tguid = ""
		UpdateBar()
	end
end

f:RegisterEvent("UNIT_THREAT_LIST_UPDATE")
function f:UNIT_THREAT_LIST_UPDATE(event, unit)
	if(unit and UnitExists(unit) and UnitGUID(unit)==tguid) then
		local num = GetNumGroupMembers()
		if num > 5 then
			for i = 1, num do
				AddThreat("raid"..i)
			end
		elseif num > 0 then
			AddThreat("player")
			for i = 1, num do
				AddThreat("party"..i)
			end
		end
		UpdateBar()
	end
end

f:RegisterEvent("UNIT_THREAT_SITUATION_UPDATE")
f.UNIT_THREAT_SITUATION_UPDATE = f.UNIT_THREAT_LIST_UPDATE

f:SetScript("OnEvent", function(s, e, u) s[e](s, e, u) end)