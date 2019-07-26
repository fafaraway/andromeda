local F, C, L = unpack(select(2, ...))
local BLIZZARD = F:RegisterModule('Blizzard')


-- Reanchor durability indicator
function BLIZZARD:ReanchorDurabilityIndicator()
	hooksecurefunc(DurabilityFrame, 'SetPoint', function(_, _, parent)
		if parent ~= UIParent then
			DurabilityFrame:SetScale(1)
			DurabilityFrame:ClearAllPoints()
			DurabilityFrame:SetClampedToScreen(true)
			DurabilityFrame:SetPoint('TOP', UIParent, 'TOP', 0, -200)
		end
	end)
end

-- Reanchor vehicle indicator
function BLIZZARD:ReanchorVehicleIndicator()
	local frame = CreateFrame('Frame', 'FreeUIVehicleIndicatorMover', UIParent)
	frame:SetSize(125, 125)
	F.Mover(frame, L['MOVER_VEHICLE_INDICATOR'], 'VehicleIndicator', {'BOTTOMRIGHT', Minimap, 'TOPRIGHT', 0, 0})

	hooksecurefunc(VehicleSeatIndicator, 'SetPoint', function(self, _, parent)
		if parent == 'MinimapCluster' or parent == MinimapCluster then
			self:ClearAllPoints()
			self:SetPoint('TOPLEFT', frame)
			self:SetScale(.7)
		end
	end)
end

-- Remove Boss Banner
function BLIZZARD:RemoveBossBanner()
	if C.general.hideBossBanner then
		BossBanner:UnregisterAllEvents()
	end
end

-- Reanchor UIWidgetBelowMinimapContainerFrame
function BLIZZARD:ReanchorUIWidgetFrame()
	UIWidgetTopCenterContainerFrame:ClearAllPoints()
	UIWidgetTopCenterContainerFrame:SetPoint('TOP', 0, -30)

	hooksecurefunc(UIWidgetBelowMinimapContainerFrame, 'SetPoint', function(self, _, parent)
		if parent == 'MinimapCluster' or parent == MinimapCluster then
			self:ClearAllPoints()
			self:SetPoint('TOP', UIParent, 0, -120)
		end
	end)
end



function BLIZZARD:SkipAzeriteAnimation()
	if not (IsAddOnLoaded('Blizzard_AzeriteUI')) then
		UIParentLoadAddOn('Blizzard_AzeriteUI')
	end
	hooksecurefunc(AzeriteEmpoweredItemUI,'OnItemSet',function(self)
		local itemLocation = self.azeriteItemDataSource:GetItemLocation()
		if self:IsAnyTierRevealing() then
			C_Timer.After(0.7,function() 
				OpenAzeriteEmpoweredItemUIFromItemLocation(itemLocation)
			end)
		end
	end)
end


function BLIZZARD:RemoveNewTalentAlert()
	if PlayerTalentFrame then
		PlayerTalentFrame:UnregisterEvent('ACTIVE_TALENT_GROUP_CHANGED')
	else
		hooksecurefunc('TalentFrame_LoadUI', function()
			PlayerTalentFrame:UnregisterEvent('ACTIVE_TALENT_GROUP_CHANGED')
		end)
	end
end


function BLIZZARD:OnLogin()
	self:ReskinBuffFrame()
	self:ReskinPetBattleUI()
	self:ColourPickerEnhancement()
	self:ReanchorUIWidgetFrame()
	self:ReskinQuestTracker()
	self:ReskinCooldown()
	self:RemoveBossBanner()
	self:SkipAzeriteAnimation()
	self:ReskinErrorFrame()
	self:ReskinLootFrame()
	self:RaidManager()
	self:ReanchorDurabilityIndicator()
	self:ReanchorVehicleIndicator()
	self:QuickJoin()
	self:ReskinCommandBar()
	self:RemoveNewTalentAlert()
	self:ReanchorAlertFrame()
end