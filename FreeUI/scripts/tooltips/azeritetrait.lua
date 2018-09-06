local F, C, L = unpack(select(2, ...))
if C.tooltip.enable ~= true or C.tooltip.azeriteTrait ~= true then return end

local addon, AzeriteTooltip = ...

local addText = ""
local currentLevel = 0

function AzeriteTooltip_GetSpellID(powerID)
	local powerInfo = C_AzeriteEmpoweredItem.GetPowerInfo(powerID)
  	if (powerInfo) then
    	local azeriteSpellID = powerInfo["spellID"]
    	return azeriteSpellID
  	end
end

function AzeriteTooltip_ScanSelectedTraits(tooltip, powerName)
	for i = 10, tooltip:NumLines() do
		local left = _G[tooltip:GetName().."TextLeft"..i]
		local text = left:GetText()
        if text and text:find(powerName) then
        	return true
        end
    end
end

function AzeriteTooltip_ClearBlizzardText(tooltip, powerName)
	local textLeft = tooltip.textLeft
	if not textLeft then
		local tooltipName = tooltip:GetName()
		textLeft = setmetatable({}, { __index = function(t, i)
			local line = _G[tooltipName .. "TextLeft" .. i]
			t[i] = line
			return line
		end })
		tooltip.textLeft = textLeft
	end
	for i = 8, tooltip:NumLines() do
		if textLeft then
			local line = textLeft[i]		
			local text = line:GetText()
			local r, g, b = line:GetTextColor()
			if text then
				local ActiveAzeritePowers = strsplit("(%d/%d)", CURRENTLY_SELECTED_AZERITE_POWERS) -- Active Azerite Powers (%d/%d)
				local AzeritePowers = strsplit("(0/%d)", TOOLTIP_AZERITE_UNLOCK_LEVELS) -- Azerite Powers (0/%d)
				local AzeriteUnlock = strsplit("%d", AZERITE_POWER_UNLOCKED_AT_LEVEL) -- Unlocked at Heart of Azeroth Level %d
				local Durability = strsplit("%d / %d", DURABILITY_TEMPLATE)

				if text:match(CURRENTLY_SELECTED_AZERITE_POWERS_INSPECT) then return end

				if text:find(ActiveAzeritePowers) or text:find(AzeritePowers) then
					textLeft[i-1]:SetText("")
					line:SetText("")
					textLeft[i+1]:SetText(addText)
				end

				if text:find(AzeriteUnlock) or text:find(NEW_AZERITE_POWER_AVAILABLE) then
					line:SetText("")
					textLeft[i+1]:SetText("")
				end

				if powerName then
					if text:find("- "..powerName) then
						line:SetText("")
						textLeft[i+1]:SetText("")
					end
					if r < 0.1 and g > 0.9 and b < 0.1 and not text:match(ITEM_AZERITE_EMPOWERED_VIEWABLE) then
						line:SetText("")
						textLeft[i+1]:SetText("")
					end
				end

				if text:find(Durability) then
					textLeft[i-1]:SetText("")
				end

			end
		end
	end
end


function AzeriteTooltip_BuildTooltip(self)	
	addText = ""
	local name, link = self:GetItem()
  	if not name then return end

  	if C_AzeriteEmpoweredItem.IsAzeriteEmpoweredItemByID(link) then

		local azeriteItemLocation = C_AzeriteItem.FindActiveAzeriteItem()
		if azeriteItemLocation then
			currentLevel = C_AzeriteItem.GetPowerLevel(azeriteItemLocation)
		end

		local specID = GetSpecializationInfo(GetSpecialization())
		local allTierInfo = C_AzeriteEmpoweredItem.GetAllTierInfoByItemID(link)

		if not allTierInfo then return end

		local activePowers = {}
		local activeAzeriteTrait = false

		for j=1, 3 do
			local tierLevel = allTierInfo[j]["unlockLevel"]
			local azeritePowerID = allTierInfo[j]["azeritePowerIDs"][1]

			if azeritePowerID == 13 then break end -- Ignore +5 item level tier

			local azeriteTooltipText = " "
			for i, _ in pairs(allTierInfo[j]["azeritePowerIDs"]) do
				local azeritePowerID = allTierInfo[j]["azeritePowerIDs"][i]
				local azeriteSpellID = AzeriteTooltip_GetSpellID(azeritePowerID)				
				local azeritePowerName, _, icon = GetSpellInfo(azeriteSpellID)	

				if tierLevel <= currentLevel then
					if AzeriteTooltip_ScanSelectedTraits(self, azeritePowerName) then
						local azeriteIcon = '|T'..icon..':24:24:0:0:64:64:4:60:4:60:255:255:255|t'
						azeriteTooltipText = azeriteTooltipText.."  "..azeriteIcon

						tinsert(activePowers, {name = azeritePowerName})
						activeAzeriteTrait = true
					elseif C_AzeriteEmpoweredItem.IsPowerAvailableForSpec(azeritePowerID, specID) then
						local azeriteIcon = '|T'..icon..':24:24:0:0:64:64:4:60:4:60:150:150:150|t'
						azeriteTooltipText = azeriteTooltipText.."  "..azeriteIcon
					end
				else
					local azeriteIcon = '|T'..icon..':24:24:0:0:64:64:4:60:4:60:150:150:150|t'
					azeriteTooltipText = azeriteTooltipText.."  "..azeriteIcon
				end				
			end

			if tierLevel <= currentLevel then
				if j > 1 then 
					addText = addText.."\n \n|cFFffcc00Level "..tierLevel..azeriteTooltipText.."|r"
				else
					addText = addText.."\n|cFFffcc00Level "..tierLevel..azeriteTooltipText.."|r"
				end
			else
				if j > 1 then 
					addText = addText.."\n \n|cFF7a7a7aLevel "..tierLevel..azeriteTooltipText.."|r"
				else
					addText = addText.."\n|cFF7a7a7aLevel "..tierLevel..azeriteTooltipText.."|r"
				end
			end
		end

		if activeAzeriteTrait then
			for k, v in pairs(activePowers) do
				AzeriteTooltip_ClearBlizzardText(self, v.name)
			end
		else
			AzeriteTooltip_ClearBlizzardText(self, nil)
		end

		wipe(activePowers)	
	end
end

GameTooltip:HookScript("OnTooltipSetItem", AzeriteTooltip_BuildTooltip)
ItemRefTooltip:HookScript("OnTooltipSetItem", AzeriteTooltip_BuildTooltip)
ShoppingTooltip1:HookScript("OnTooltipSetItem", AzeriteTooltip_BuildTooltip)
WorldMapTooltip.ItemTooltip.Tooltip:HookScript('OnTooltipSetItem', AzeriteTooltip_BuildTooltip)