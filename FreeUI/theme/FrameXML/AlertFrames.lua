local F, C = unpack(select(2, ...))

tinsert(C.themes["FreeUI"], function()
	local OnShow = {}

	do --[[ Achievement alert ]]
		local r, g, b, a
		local function fixBg(f)
			if f:GetObjectType() == "AnimationGroup" then
				f = f:GetParent()
			end
			f:SetBackdropColor(r, g, b, a)
		end

		OnShow.Achievement = function(self)
			if not self.isSkinned then
				self.Background:Hide()
				F.CreateBD(self)

				r, g, b, a = self:GetBackdropColor()
				self:HookScript("OnEnter", fixBg)
				self:HookScript("OnShow", fixBg)
				self.animIn:HookScript("OnFinished", fixBg)

				self.Unlocked:SetTextColor(1, 1, 1)
				self.GuildName:SetPoint("TOPLEFT", 50, -2)
				self.GuildName:SetPoint("TOPRIGHT", -50, -2)

				self.GuildBanner:SetPoint("TOPRIGHT", -10, 0)
				self.GuildBorder:SetPoint("TOPRIGHT", -10, 0)

				F.ReskinIcon(self.Icon.Texture)
				self.Icon.Overlay:Hide()

				self.isSkinned = true
			end

			self:SetHeight(72)
			self.Icon:SetPoint("TOPLEFT", -26, 23)
			if self.guildDisplay then
				self.Unlocked:SetPoint("TOP", 0, -17)
				self.Name:SetPoint("BOTTOMLEFT", 65, 23)
				self.Name:SetPoint("BOTTOMRIGHT", -65, 23)

				self.Shield:SetPoint("TOPRIGHT", -12, 0)
			else
				self.Unlocked:SetPoint("TOP", 0, -5)
				self.Name:SetPoint("BOTTOMLEFT", 65, 30)
				self.Name:SetPoint("BOTTOMRIGHT", -65, 30)

				self.Shield:SetPoint("TOPRIGHT", -10, -5)
			end
		end
	end
end)
