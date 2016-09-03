local F, C = unpack(select(2, ...))

C.themes["Blizzard_GarrisonTemplates"] = function()
	--[[
		This addon is a dependancy for the GarrisonUI, which is in turn a dependancy for the OrderHallUI.
		The hooks made here will persist into both of those, greatly reducing posible duplicate code.
	]]

	--[[ SharedTemplates ]]
	hooksecurefunc(GarrisonFollowerTabMixin, "ShowFollower", function(self, followerID, followerList)
		if self:GetParent().followerTypeID == LE_FOLLOWER_TYPE_GARRISON_7_0 then return end -- we're not skinning OrderHallUI just yet

		local followerInfo = C_Garrison.GetFollowerInfo(followerID)
		if not followerInfo then return end -- not sure if this is needed

		if not self.PortraitFrame.styled then
			F.ReskinGarrisonPortrait(self.PortraitFrame)
			self.PortraitFrame.styled = true
		end

		local color = ITEM_QUALITY_COLORS[followerInfo.quality]
		self.PortraitFrame:SetBackdropBorderColor(color.r, color.g, color.b)
	end)

	--[[ MissionTemplates ]]
end
