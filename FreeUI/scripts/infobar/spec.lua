local F, C, L = unpack(select(2, ...))
if not C.infobar.enable then return end
if not C.infobar.specTalent then return end
local module = F:GetModule("Infobar")

local function addIcon(texture)
	texture = texture and "|T"..texture..":12:16:0:0:50:50:4:46:4:46|t" or ""
	return texture
end

local FreeUISpecButton = module.FreeUISpecButton
local pvpTalents


function module:SpecTalent()
	FreeUISpecButton = module:addButton("", module.POSITION_RIGHT, 220, function(self, button)
		local currentSpec = GetSpecialization()
		local numSpec = GetNumSpecializations()
		if not (currentSpec and numSpec) then return end

		if button == "LeftButton" then
			if (UnitLevel("player") > 10) then
				local index = currentSpec + 1
				if index > numSpec then
					index = 1
				end
				SetSpecialization(index)
			end
		elseif button == "RightButton" then
			local index = {}
			for i = 1, numSpec do
				index[i] = GetSpecializationInfo(i)
			end

			local currentId = GetLootSpecialization()
			if currentId == 0 then
				currentId = GetSpecializationInfo(currentSpec)
			end

			if currentId == index[1] then
				SetLootSpecialization(index[2])
			elseif currentId == index[2] then
				SetLootSpecialization(index[3] or index[1])
			elseif currentId == index[3] then
				SetLootSpecialization(index[4] or index[1])
			elseif currentId == index[4] then
				SetLootSpecialization(index[1])
			end
		else
			ToggleTalentFrame(2)
		end
	end)

	FreeUISpecButton:RegisterEvent("PLAYER_ENTERING_WORLD")
	FreeUISpecButton:RegisterEvent("ACTIVE_TALENT_GROUP_CHANGED")
	FreeUISpecButton:RegisterEvent("PLAYER_LOOT_SPEC_UPDATED")
	FreeUISpecButton:SetScript("OnEvent", function(self)
		local currentSpec = GetSpecialization()
		local lootSpecID = GetLootSpecialization()

		if currentSpec then
			local _, name = GetSpecializationInfo(currentSpec)
			if not name then return end
			local _, lootname = GetSpecializationInfoByID(lootSpecID)
			local role = GetSpecializationRole(currentSpec)
			local lootrole = GetSpecializationRoleByID(lootSpecID)

			if not lootname or name == lootname then
				self.Text:SetText(format(SPECIALIZATION..": "..C.MyColor.."%s  |r"..ITEM_LOOT..":"..C.MyColor.." %s", name, name))
			else
				self.Text:SetText(format(SPECIALIZATION..": "..C.MyColor.."%s  |r"..ITEM_LOOT..":"..C.MyColor.." %s", name, lootname))
			end

			if C.Client == "zhCN" or C.Client == "zhTW" then
				self.Text:SetFont(C.font.normal, 11)
			end

			module:showButton(self)

		else
			module:hideButton(self)
		end
	end)

	FreeUISpecButton:HookScript("OnEnter", function(self)
		if not GetSpecialization() then return end
		GameTooltip:SetOwner(Minimap, "ANCHOR_NONE")
		GameTooltip:SetPoint("TOPRIGHT", Minimap, "TOPLEFT", -5, -33)
		GameTooltip:ClearLines()
		GameTooltip:AddLine(TALENTS_BUTTON, .9, .82, .62)
		GameTooltip:AddLine(" ")

		local _, specName, _, specIcon = GetSpecializationInfo(GetSpecialization())
		GameTooltip:AddLine(addIcon(specIcon).." "..specName, .6,.8,1)

		for t = 1, MAX_TALENT_TIERS do
			for c = 1, 3 do
				local _, name, icon, selected = GetTalentInfo(t, c, 1)
				if selected then
					GameTooltip:AddLine(addIcon(icon).." "..name, 1,1,1)
				end
			end
		end

		if UnitLevel("player") >= SHOW_PVP_TALENT_LEVEL then
			pvpTalents = C_SpecializationInfo.GetAllSelectedPvpTalentIDs()

			if #pvpTalents > 0 then
				local texture = select(3, GetCurrencyInfo(104))
				GameTooltip:AddLine(" ")
				GameTooltip:AddLine(addIcon(texture).." "..PVP_TALENTS, .6,.8,1)
				for _, talentID in next, pvpTalents do
					local _, name, icon, _, _, _, unlocked = GetPvpTalentInfoByID(talentID)
					if name and unlocked then
						GameTooltip:AddLine(addIcon(icon).." "..name, 1,1,1)
					end
				end
			end

			wipe(pvpTalents)
		end

		GameTooltip:AddDoubleLine(" ", C.LineString)
		GameTooltip:AddDoubleLine(" ", C.LeftButton..L["ChangeSpec"].." ", 1,1,1, .9, .82, .62)
		GameTooltip:AddDoubleLine(" ", C.RightButton..L["ChangeLootSpec"].." ", 1,1,1, .9, .82, .62)
		GameTooltip:AddDoubleLine(" ", C.MiddleButton..L["SpecPanel"].." ", 1,1,1, .9, .82, .62)
		GameTooltip:Show()
	end)

	FreeUISpecButton:HookScript("OnLeave", function(self)
		GameTooltip:Hide()
	end)
end






