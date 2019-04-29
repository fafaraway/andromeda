local F, C, L = unpack(select(2, ...))

-- RandomHearthstone by Voidiver

local tinsert, tremove = tinsert, tremove

local HearthStoneListChecked, HearthStoneName = {}, {}


local HearthStoneList = {
	165802,		-- 复活节的炉石
	162973, 	-- 冬天爷爷的炉石 278244
	163045, 	-- 无头骑士的炉石 278559
	165669, 	-- 春节长者的炉石 285362
	165670, 	-- 小匹德菲特的可爱炉石 
	93672, 		-- 黑暗之门
	54452,      -- 虚灵之门
	--64488,    -- 旅店老板的女儿
	--142542,   -- 城镇传送门 231504
	--6948,     -- 炉石 8690
}

local function HearthStoneToUse_UpdateList()
	for k, v in ipairs(HearthStoneList) do
		if PlayerHasToy(v) then
			tinsert(HearthStoneListChecked, v)
		end
	end
	local num = #HearthStoneListChecked
	if num and num >=1 then
		for k, v in ipairs(HearthStoneListChecked) do
			local name = GetItemInfo(v)
			if name then
				tinsert(HearthStoneName, name)
				tremove(HearthStoneListChecked, k)
			end
		end
	end
end

local function HearthStoneToUse_Random(frame)
	if (#HearthStoneName >= 1) then
		if (not InCombatLockdown()) then
			HearthStoneToUse = HearthStoneName[random(#HearthStoneName)]
			frame: SetAttribute("item", HearthStoneToUse)
			frame.NeedToRandom = false
		else
			frame.NeedToRandom = true
		end
	end
end

local function Macro_Create()
	local name = GetMacroInfo("RHS")
	local HSNAME = GetItemInfo(6948)
	if (not HSNAME) or (InCombatLockdown()) then return end
	if not name then
		local gNum, pNum = GetNumMacros()
		if (gNum == 72) then return end
		local macroId = CreateMacro("RHS", "INV_MISC_QUESTIONMARK", 
		"#showtooltip "..HSNAME..[[

]]..[[
/rhs check
/click RandomHearthStone]],
		nil, 1)
		DEFAULT_CHAT_FRAME:AddMessage(GetMacroInfo("RHS"))
	end
end

local function Macro_Refresh()
	local name = GetMacroInfo("RHS")
	local HSNAME = GetItemInfo(6948)
	if (not HSNAME) or (InCombatLockdown()) then return end
	if not name then
		local gNum, pNum = GetNumMacros()
		if (gNum == 72) then return end
		local macroId = CreateMacro("RHS", "INV_MISC_QUESTIONMARK", 
		"#showtooltip "..HSNAME..[[

]]..[[
/rhs check
/click RandomHearthStone]],
		nil, 1)
		--DEFAULT_CHAT_FRAME:AddMessage(GetMacroInfo("RHS"))
	else
		local macroID = EditMacro("RHS", "RHS", "INV_MISC_QUESTIONMARK", 
		"#showtooltip "..HSNAME..[[

]]..[[
/rhs check
/click RandomHearthStone]])
		--DEFAULT_CHAT_FRAME:AddMessage(GetMacroInfo("RHS"))
	end
end

local HearthStoneToUse = GetItemInfo(6948)
local RandomHearthStone = CreateFrame("Button", "RandomHearthStone", nil, "SecureActionButtonTemplate")
RandomHearthStone: SetAttribute("type","item")
RandomHearthStone: SetAttribute("item", HearthStoneToUse)
RandomHearthStone.NeedToRandom = false

RandomHearthStone: RegisterEvent("PLAYER_ENTERING_WORLD")
RandomHearthStone: RegisterEvent("PLAYER_REGEN_ENABLED")
RandomHearthStone: SetScript("OnEvent", function(self, event)
	if event == "PLAYER_ENTERING_WORLD" then
		Macro_Create()
		Macro_Refresh()

		HearthStoneToUse_UpdateList()
		HearthStoneToUse_Random(RandomHearthStone)
		C_Timer.After(5, function(self2)
			HearthStoneToUse_UpdateList()
			HearthStoneToUse_Random(RandomHearthStone)
		end)
	end
	if event == "PLAYER_REGEN_ENABLED" then
		if self.NeedToRandom == true then
			HearthStoneToUse_UpdateList()
			HearthStoneToUse_Random(RandomHearthStone)
		end
	end
end)


SlashCmdList["RHS"] = function(msg)
	--msg = msg:lower()

	if msg == "check" then
		HearthStoneToUse_UpdateList()
		HearthStoneToUse_Random(RandomHearthStone)
	else
		Macro_Refresh()
	end
end
SLASH_RHS1 = "/rhs"
