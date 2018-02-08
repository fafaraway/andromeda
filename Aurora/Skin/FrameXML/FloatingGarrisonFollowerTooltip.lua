local _, private = ...

--[[ Lua Globals ]]
-- luacheck: globals next

--[[ Core ]]
local Aurora = private.Aurora
local Base, Hook, Skin = Aurora.Base, Aurora.Hook, Aurora.Skin

do --[[ FrameXML\FloatingGarrisonFollowerTooltip.lua ]]
    function Hook.GarrisonFollowerAbilityTooltipTemplate_SetAbility(tooltipFrame, garrFollowerAbilityID, followerTypeID)
        if tooltipFrame.CounterIcon then
            tooltipFrame._auroraCounterIconBG:SetShown(tooltipFrame.CounterIcon:IsShown())
        end
    end
    function Hook.GarrisonFollowerTooltipTemplate_SetGarrisonFollower(tooltipFrame, data, xpWidth)
        for i = 1, #tooltipFrame.Abilities do
            local Ability = tooltipFrame.Abilities[i]
            if not Ability._auroraSkinned then
                Skin.GarrisonFollowerAbilityTemplate(Ability)
                Ability._auroraSkinned = true
            end
        end

        for i = 1, #tooltipFrame.Traits do
            local Trait = tooltipFrame.Traits[i]
            if not Trait._auroraSkinned then
                Skin.GarrisonFollowerAbilityTemplate(Trait)
                Trait._auroraSkinned = true
            end
        end
    end
end

do --[[ FrameXML\FloatingGarrisonFollowerTooltip.xml ]]
    function Skin.GarrisonFollowerTooltipTemplate(frame)
        Skin.TooltipBorderedFrameTemplate(frame)

        frame.Class:SetPoint("TOPRIGHT", -2, -2)
        frame.XPBarBackground:SetPoint("TOPLEFT", frame.PortraitFrame, "BOTTOMRIGHT", 0, -2)

        frame.Name:SetPoint("TOPLEFT", frame.PortraitFrame, "TOPRIGHT", 4, -4)
        frame.ClassSpecName:SetPoint("TOPLEFT", frame.Name, "BOTTOMLEFT", 0, -15)
        frame.ILevel:SetPoint("TOPLEFT", frame.ClassSpecName, "BOTTOMLEFT", 0, -15)
        frame.Quality:ClearAllPoints()
        frame.Quality:SetPoint("TOP", frame.PortraitFrame, "BOTTOM", 0, -2)
        frame.Quality:SetJustifyH("CENTER")

        frame.XPBar:SetPoint("TOPLEFT", frame.XPBarBackground)

        Skin.GarrisonFollowerPortraitTemplate(frame.PortraitFrame)
        frame.PortraitFrame:SetPoint("TOPLEFT", 4, -4)
    end
    function Skin.GarrisonShipyardFollowerTooltipTemplate(frame)
        Skin.TooltipBorderedFrameTemplate(frame)

        frame.XPBarBackground:SetPoint("TOPLEFT", frame, "BOTTOMRIGHT", 0, -2)

        frame.Name:SetPoint("TOPLEFT", frame, "TOPRIGHT", 4, -4)
        frame.ClassSpecName:SetPoint("TOPLEFT", frame.Name, "BOTTOMLEFT", 0, -15)
        frame.Quality:ClearAllPoints()
        frame.Quality:SetPoint("TOP", frame, "BOTTOM", 0, -2)
        frame.Quality:SetJustifyH("CENTER")

        frame.XPBar:SetPoint("TOPLEFT", frame.XPBarBackground)
    end
    function Skin.GarrisonFollowerAbilityTemplate(frame)
        Base.CropIcon(frame.Icon, frame)
        Skin.PositionGarrisonAbiltyBorder(frame.Border, frame.Icon)
    end
    function Skin.GarrisonFollowerAbilityTooltipTemplate(frame)
        Skin.TooltipBorderedFrameTemplate(frame)

        Base.CropIcon(frame.Icon, frame)
        frame._auroraCounterIconBG = Base.CropIcon(frame.CounterIcon, frame)
        Skin.PositionGarrisonAbiltyBorder(frame.CounterIconBorder, frame.CounterIcon)
    end
    function Skin.GarrisonFollowerAbilityWithoutCountersTooltipTemplate(frame)
        Skin.TooltipBorderedFrameTemplate(frame)

        Base.CropIcon(frame.Icon, frame)
        Skin.PositionGarrisonAbiltyBorder(frame.AbilityBorder, frame.Icon)
    end
    function Skin.GarrisonFollowerMissionAbilityWithoutCountersTooltipTemplate(frame)
        Skin.TooltipBorderedFrameTemplate(frame)

        Base.CropIcon(frame.Icon, frame)
        Skin.PositionGarrisonAbiltyBorder(frame.AbilityBorder, frame.Icon)
    end
end

function private.FrameXML.FloatingGarrisonFollowerTooltip()
    if private.disabled.tooltips then return end

    --[[ FrameXML\FloatingGarrisonFollowerTooltip ]]
    _G.hooksecurefunc("GarrisonFollowerAbilityTooltipTemplate_SetAbility", Hook.GarrisonFollowerAbilityTooltipTemplate_SetAbility)
    _G.hooksecurefunc("GarrisonFollowerTooltipTemplate_SetGarrisonFollower", Hook.GarrisonFollowerTooltipTemplate_SetGarrisonFollower)

    local floatingTooltips = {
        ["GarrisonFollowerTooltipTemplate"] = _G.FloatingGarrisonFollowerTooltip,
        ["GarrisonShipyardFollowerTooltipTemplate"] = _G.FloatingGarrisonShipyardFollowerTooltip,
        ["GarrisonFollowerAbilityTooltipTemplate"] = _G.FloatingGarrisonFollowerAbilityTooltip,
        ["TooltipBorderedFrameTemplate"] = _G.FloatingGarrisonMissionTooltip,
    }

    for template, frame in next, floatingTooltips do
        Skin[template](frame)
        Skin.UIPanelCloseButton(frame.CloseButton)
        frame.CloseButton:SetPoint("TOPRIGHT", -3, -3)
    end

    --[[ FrameXML\GarrisonFollowerTooltip ]]
    Skin.GarrisonFollowerTooltipTemplate(_G.GarrisonFollowerTooltip)
    Skin.GarrisonFollowerAbilityTooltipTemplate(_G.GarrisonFollowerAbilityTooltip)
    Skin.GarrisonFollowerAbilityWithoutCountersTooltipTemplate(_G.GarrisonFollowerAbilityWithoutCountersTooltip)
    Skin.GarrisonFollowerMissionAbilityWithoutCountersTooltipTemplate(_G.GarrisonFollowerMissionAbilityWithoutCountersTooltip)
    Skin.GarrisonShipyardFollowerTooltipTemplate(_G.GarrisonShipyardFollowerTooltip)
end
