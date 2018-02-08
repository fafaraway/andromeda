local _, private = ...

--[[ Lua Globals ]]
-- luacheck: globals

--[[ Core ]]
local Aurora = private.Aurora
local Base, Skin = Aurora.Base, Aurora.Skin
local F = _G.unpack(private.Aurora)

--[[ do AddOns\Blizzard_Contribution.lua
end ]]

 --[[ doAddOns\Blizzard_Contribution.xml
end ]]

function private.AddOns.Blizzard_Contribution()
	local frame = ContributionCollectionFrame
	F.SetBD(frame)
	F.ReskinClose(frame.CloseButton)
	frame.CloseButton.CloseButtonBackground:Hide()
	frame.Background:Hide()

	hooksecurefunc(ContributionMixin, "Update", function(self)
		if not self.styled then
			self.Header.Text:SetTextColor(1, .8, 0)
			F.Reskin(self.ContributeButton)

			self.styled = true
		end
	end)

	hooksecurefunc(ContributionRewardMixin, "Setup", function(self)
		if not self.styled then
			self.RewardName:SetTextColor(1, 1, 1)
			self.Icon:SetTexCoord(.08, .92, .08, .92)
			self.Border:Hide()
			self:GetRegions():Hide()
			F.CreateBDFrame(self.Icon)

			self.styled = true
		end
	end)

    if not private.disabled.tooltips then
        Skin.GameTooltipTemplate(_G.ContributionTooltip)
        Skin.EmbeddedItemTooltip(_G.ContributionTooltip.ItemTooltip)

        Skin.TooltipBorderedFrameTemplate(_G.ContributionBuffTooltip)
        Base.CropIcon(_G.ContributionBuffTooltip.Icon, _G.ContributionBuffTooltip)
        _G.ContributionBuffTooltip.Border:Hide()
    end
end
