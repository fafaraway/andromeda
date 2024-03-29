local F, C = unpack(select(2, ...))

tinsert(C.BlizzThemes, function()
    -- Tooltip close buttons
    F.ReskinClose(_G.ItemRefTooltip.CloseButton)
    F.ReskinClose(_G.FloatingBattlePetTooltip.CloseButton)
    F.ReskinClose(_G.FloatingPetBattleAbilityTooltip.CloseButton)

    if not _G.ANDROMEDA_ADB.ReskinBlizz then
        return
    end

    -- Tooltips
    function F:ReskinGarrisonTooltip()
        if self.Icon then
            F.ReskinIcon(self.Icon)
        end
        if self.CloseButton then
            F.ReskinClose(self.CloseButton)
        end
    end

    F.ReskinGarrisonTooltip(_G.FloatingGarrisonMissionTooltip)
    F.ReskinGarrisonTooltip(_G.GarrisonFollowerTooltip)
    F.ReskinGarrisonTooltip(_G.FloatingGarrisonFollowerTooltip)
    F.ReskinGarrisonTooltip(_G.GarrisonFollowerAbilityTooltip)
    F.ReskinGarrisonTooltip(_G.FloatingGarrisonFollowerAbilityTooltip)
    F.ReskinGarrisonTooltip(_G.GarrisonShipyardFollowerTooltip)
    F.ReskinGarrisonTooltip(_G.FloatingGarrisonShipyardFollowerTooltip)

    hooksecurefunc('GarrisonFollowerTooltipTemplate_SetGarrisonFollower', function(tooltipFrame)
        -- Abilities
        if tooltipFrame.numAbilitiesStyled == nil then
            tooltipFrame.numAbilitiesStyled = 1
        end

        local numAbilitiesStyled = tooltipFrame.numAbilitiesStyled
        local abilities = tooltipFrame.Abilities
        local ability = abilities[numAbilitiesStyled]
        while ability do
            F.ReskinIcon(ability.Icon)

            numAbilitiesStyled = numAbilitiesStyled + 1
            ability = abilities[numAbilitiesStyled]
        end

        tooltipFrame.numAbilitiesStyled = numAbilitiesStyled

        -- Traits
        if tooltipFrame.numTraitsStyled == nil then
            tooltipFrame.numTraitsStyled = 1
        end

        local numTraitsStyled = tooltipFrame.numTraitsStyled
        local traits = tooltipFrame.Traits
        local trait = traits[numTraitsStyled]
        while trait do
            F.ReskinIcon(trait.Icon)

            numTraitsStyled = numTraitsStyled + 1
            trait = traits[numTraitsStyled]
        end

        tooltipFrame.numTraitsStyled = numTraitsStyled
    end)
end)
