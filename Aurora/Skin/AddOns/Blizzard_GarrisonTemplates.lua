local _, private = ...

-- [[ WoW API ]]
local hooksecurefunc = _G.hooksecurefunc

-- [[ Core ]]
local Aurora = private.Aurora
local Skin = Aurora.Skin
local F = _G.unpack(private.Aurora)

function private.AddOns.Blizzard_GarrisonTemplates()
    --[[
        This addon is a dependancy for the GarrisonUI, which is in turn a dependancy for the OrderHallUI.
        The hooks made here will persist into both of those, greatly reducing posible duplicate code.
    ]]

    --[[ AddOns\Blizzard_GarrisonTemplates\Blizzard_GarrisonSharedTemplates ]]
    hooksecurefunc(_G.GarrisonFollowerTabMixin, "ShowFollower", function(self, followerID, followerList)
        private.debug("FollowerTabMixin:ShowFollower", self:GetParent().followerTypeID, followerID, followerList)
        if self:GetParent().followerTypeID == _G.LE_FOLLOWER_TYPE_GARRISON_7_0 then return end -- we're not skinning OrderHallUI just yet

        local followerInfo = _G.C_Garrison.GetFollowerInfo(followerID)
        private.debug("followerInfo", followerInfo and followerInfo.name)
        if not followerInfo then return end -- not sure if this is needed

        if not self.PortraitFrame.styled then
            F.ReskinGarrisonPortrait(self.PortraitFrame)
            self.PortraitFrame.styled = true
        end

        local color = _G.ITEM_QUALITY_COLORS[followerInfo.quality]
        self.PortraitFrame:SetBackdropBorderColor(color.r, color.g, color.b)
    end)

    --[[ AddOns\Blizzard_GarrisonTemplates\Blizzard_GarrisonMissionTemplates ]]
    if not private.disabled.tooltips then
        Skin.GameTooltipTemplate(_G.GarrisonMissionMechanicTooltip)
        Skin.PositionGarrisonAbiltyBorder(_G.GarrisonMissionMechanicTooltip.Border, _G.GarrisonMissionMechanicTooltip.Icon)
        Skin.GameTooltipTemplate(_G.GarrisonMissionMechanicFollowerCounterTooltip)
        Skin.PositionGarrisonAbiltyBorder(_G.GarrisonMissionMechanicFollowerCounterTooltip.Border, _G.GarrisonMissionMechanicFollowerCounterTooltip.Icon)
    end
end
