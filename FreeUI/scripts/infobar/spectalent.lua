local F, C, L = unpack(select(2, ...))
local INFOBAR = F:GetModule('Infobar')


local currentSpec = GetSpecialization()
local numSpec = GetNumSpecializations()

local function addIcon(texture)
	texture = texture and '|T'..texture..':12:16:0:0:50:50:4:46:4:46|t' or ''
	return texture
end

local pvpTalents

local FreeUISpecButton = INFOBAR.FreeUISpecButton


function INFOBAR:SpecTalent()
	if not C.infobar.enable then return end
	if not C.infobar.specTalent then return end

	FreeUISpecButton = INFOBAR:addButton('', INFOBAR.POSITION_RIGHT, 300, function(self, button)
		if InCombatLockdown() then UIErrorsFrame:AddMessage(C.InfoColor..ERR_NOT_IN_COMBAT) return end

		if not (currentSpec and numSpec) then return end

		if button == 'LeftButton' then
			if (UnitLevel('player') > 10) then
				local index = currentSpec + 1
				if index > numSpec then
					index = 1
				end
				SetSpecialization(index)
			end
		elseif button == 'RightButton' then
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

	FreeUISpecButton:RegisterEvent('PLAYER_ENTERING_WORLD')
	FreeUISpecButton:RegisterEvent('ACTIVE_TALENT_GROUP_CHANGED')
	FreeUISpecButton:RegisterEvent('PLAYER_LOOT_SPEC_UPDATED')
	FreeUISpecButton:SetScript('OnEvent', function(self)
		local currentSpec = GetSpecialization()
		local lootSpecID = GetLootSpecialization()

		if currentSpec then
			local _, name = GetSpecializationInfo(currentSpec)
			if not name then return end
			local _, lootname = GetSpecializationInfoByID(lootSpecID)
			local role = GetSpecializationRole(currentSpec)
			local lootrole = GetSpecializationRoleByID(lootSpecID)

			if not lootname or name == lootname then
				self.Text:SetText(format(L['INFOBAR_SPEC']..': '..C.MyColor..'%s  |r'..L['INFOBAR_LOOT']..':'..C.MyColor..' %s', name, name))
			else
				self.Text:SetText(format(L['INFOBAR_SPEC']..': '..C.MyColor..'%s  |r'..L['INFOBAR_LOOT']..':'..C.MyColor..' %s', name, lootname))
			end

			F.SetFS(self.Text, C.isCNClient)

			INFOBAR:showButton(self)
		else
			INFOBAR:hideButton(self)
		end
	end)

	FreeUISpecButton:HookScript('OnEnter', function(self)
		if not GetSpecialization() then return end
		GameTooltip:SetOwner(self, 'ANCHOR_BOTTOM', 0, -15)
		GameTooltip:ClearLines()
		GameTooltip:AddLine(TALENTS_BUTTON, .9, .8, .6)
		GameTooltip:AddLine(' ')

		local _, specName, _, specIcon = GetSpecializationInfo(GetSpecialization())
		GameTooltip:AddLine(addIcon(specIcon)..' '..specName, .6,.8,1)

		for t = 1, MAX_TALENT_TIERS do
			for c = 1, 3 do
				local _, name, icon, selected = GetTalentInfo(t, c, 1)
				if selected then
					GameTooltip:AddLine(addIcon(icon)..' '..name, 1, 1, 1)
				end
			end
		end

		if UnitLevel('player') >= SHOW_PVP_TALENT_LEVEL then
			pvpTalents = C_SpecializationInfo.GetAllSelectedPvpTalentIDs()

			if #pvpTalents > 0 then
				local texture = select(3, GetCurrencyInfo(104))
				GameTooltip:AddLine(' ')
				GameTooltip:AddLine(addIcon(texture)..' '..PVP_TALENTS, .6,.8,1)
				for _, talentID in next, pvpTalents do
					local _, name, icon, _, _, _, unlocked = GetPvpTalentInfoByID(talentID)
					if name and unlocked then
						GameTooltip:AddLine(addIcon(icon)..' '..name, 1, 1, 1)
					end
				end
			end

			wipe(pvpTalents)
		end

		GameTooltip:AddDoubleLine(' ', C.LineString)
		GameTooltip:AddDoubleLine(' ', C.LeftButton..L['INFOBAR_OPEN_SPEC_PANEL']..' ', 1,1,1, .9, .8, .6)
		GameTooltip:AddDoubleLine(' ', C.RightButton..L['INFOBAR_CHANGE_SPEC']..' ', 1,1,1, .9, .8, .6)
		GameTooltip:AddDoubleLine(' ', C.MiddleButton..L['INFOBAR_CHANGE_LOOT_SPEC']..' ', 1,1,1, .9, .8, .6)
		GameTooltip:Show()
	end)

	FreeUISpecButton:HookScript('OnLeave', function(self)
		GameTooltip:Hide()
	end)
end






