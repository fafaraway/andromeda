local _, private = ...

--[[ Lua Globals ]]
-- luacheck: globals next ipairs floor max

--[[ Core ]]
local Aurora = private.Aurora
local Base, Scale = Aurora.Base, Aurora.Scale
local Hook, Skin = Aurora.Hook, Aurora.Skin

do --[[ AddOns\Blizzard_PetBattleUI.lua ]]
    function Hook.PetBattleUnitFrame_UpdateDisplay(self)
        local petOwner = self.petOwner
        local petIndex = self.petIndex

        if not petOwner or not petIndex then
            return
        end

        if petIndex > _G.C_PetBattles.GetNumPets(petOwner) then
            return
        end

        if self.Icon then
            if petOwner == _G.LE_BATTLE_PET_ALLY then
                self.Icon:SetTexCoord(.92, .08, .08, .92)
            else
                self.Icon:SetTexCoord(.08, .92, .08, .92)
            end
        end

        if self._auroraIconBG then
            if _G.C_PetBattles.GetHealth(petOwner, petIndex) == 0 then
                self._auroraIconBG:SetColorTexture(1, 0, 0)
            else
                local rarity = _G.C_PetBattles.GetBreedQuality(petOwner, petIndex)
                local color = _G.ITEM_QUALITY_COLORS[rarity-1]
                self._auroraIconBG:SetColorTexture(color.r, color.g, color.b)
            end
        end
    end
    function Hook.PetBattleUnitFrame_UpdateHealthInstant(self)
        local petOwner = self.petOwner
        local petIndex = self.petIndex

        local health = _G.C_PetBattles.GetHealth(petOwner, petIndex)
        local maxHealth = _G.C_PetBattles.GetMaxHealth(petOwner, petIndex)
        if ( self.ActualHealthBar ) then
            if ( health == 0 ) then
                self.ActualHealthBar:Hide()
            else
                self.ActualHealthBar:Show()
            end

            local healthWidth = self.HealthBarBG and self.HealthBarBG:GetWidth() or Scale.Value(self.healthBarWidth)
            self.ActualHealthBar:SetWidth((health / max(maxHealth, 1)) * healthWidth)
        end
    end
    function Hook.PetBattleUnitTooltip_UpdateForUnit(self)
        for i, frame in ipairs(self.Debuffs.frames) do
            if not frame._auroraSkinned then
                Skin.PetBattleUnitTooltipAuraTemplate(frame)
                frame._auroraSkinned = true
            end
        end
    end
    function Hook.PetBattleFrame_UpdateActionButtonLevel(self, actionButton)
        if actionButton.Icon and not actionButton._auroraSkinned then
            Skin.PetBattleAbilityButtonTemplate(actionButton)
            actionButton._auroraSkinned = true
        end
    end
    function Hook.PetBattleFrame_UpdateActionBarLayout(self)
        local usedX = _G.FlowContainer_GetUsedBounds(self.BottomFrame.FlowFrame)
        Scale.RawSetWidth(self.BottomFrame.FlowFrame, usedX)
        Scale.RawSetWidth(self.BottomFrame, usedX + Scale.Value(200))

        _G.C_Timer.After(0, function()
            -- wait 1 frame to allow xpBar to update its size
            local xpBar = self.BottomFrame.xpBar
            local divWidth = xpBar:GetWidth() / 7
            local xpos = divWidth
            for i = 1, #xpBar._auroraDivs do
                Scale.RawSetPoint(xpBar._auroraDivs[i], "LEFT", floor(xpos), 0)
                xpos = xpos + divWidth
            end
        end)
    end
    function Hook.PetBattleAuraHolder_Update(self)
        if not self.petOwner or not self.petIndex then return end

        local nextFrame = 1
        for i, frame in ipairs(self.frames) do
            if not frame._auroraSkinned then
                Skin.PetBattleAuraTemplate(frame)
                frame._auroraSkinned = true
            end
            nextFrame = nextFrame + 1
        end

        if nextFrame > 1 then
            --We have at least one aura displayed
            local numRows = floor((nextFrame - 2) / self.numPerRow) + 1 -- -2, 1 for this being the "next", not "previous" frame, 1 for 0-based math.
            self:SetHeight(self.frames[1]:GetHeight() * numRows)
            self:Show()
        end
    end
end

do --[[ AddOns\Blizzard_PetBattleUI.xml ]]
    function Skin.PetBattleAuraTemplate(frame)
        Base.CropIcon(frame.Icon)
        frame.DebuffBorder:SetDrawLayer("BORDER")
        frame.DebuffBorder:SetColorTexture(1, 0, 0)
        frame.DebuffBorder:ClearAllPoints()
        frame.DebuffBorder:SetPoint("TOPLEFT", frame.Icon, -1, 1)
        frame.DebuffBorder:SetPoint("BOTTOMRIGHT", frame.Icon, 1, -1)

        --[[ Scale ]]--
        frame:SetSize(60, 49)
        frame.Icon:SetSize(30, 30)
        frame.Duration:SetPoint("TOP", frame.Icon, "BOTTOM", 0, -2)
    end
    function Skin.PetBattleAuraHolderTemplate(frame)
        --[[ Scale ]]--
        frame:SetSize(222, 1)
        frame._auroraNoSetHeight = true
    end
    function Skin.PetBattleUnitTooltipAuraTemplate(frame)
        Base.CropIcon(frame.Icon)
        frame.DebuffBorder:SetDrawLayer("BORDER")
        frame.DebuffBorder:SetColorTexture(1, 0, 0)
        frame.DebuffBorder:ClearAllPoints()
        frame.DebuffBorder:SetPoint("TOPLEFT", frame.Icon, -1, 1)
        frame.DebuffBorder:SetPoint("BOTTOMRIGHT", frame.Icon, 1, -1)

        --[[ Scale ]]--
        frame:SetSize(250, 32)
        frame.Icon:SetSize(30, 30)
        frame.Name:SetPoint("TOPLEFT", frame.Icon, "TOPRIGHT", 5, 0)
        frame.Name:SetPoint("BOTTOMRIGHT", frame.Icon, 210, 12)
        frame.Duration:SetPoint("TOPLEFT", frame.Icon, "BOTTOMRIGHT", 5, 10)
        frame.Duration:SetPoint("BOTTOMRIGHT", frame.Icon, 210, 0)
    end
    function Skin.PetBattleMiniUnitFrameAlly(button)
        button._auroraIconBG = Base.CropIcon(button.Icon, button)

        button.HealthBarBG:SetPoint("BOTTOMLEFT")
        button.HealthBarBG:SetPoint("TOPRIGHT", button, "BOTTOMRIGHT", 0, 7)
        Base.SetTexture(button.ActualHealthBar, "gradientUp")

        button.ActualHealthBar:SetPoint("BOTTOMLEFT", button.HealthBarBG)
        button.ActualHealthBar:SetPoint("TOPLEFT", button.HealthBarBG)

        button.BorderAlive:SetAlpha(0)
        button.BorderDead:SetTexture([[Interface\PetBattles\DeadPetIcon]])
        button.BorderDead:SetTexCoord(0, 1, 0, 1)
        button.BorderDead:SetAllPoints()

        button.HealthDivider:SetAlpha(0)

        --[[ Scale ]]--
        button:SetSize(button:GetSize())
    end
    function Skin.PetBattleMiniUnitFrameEnemy(button)
        button._auroraIconBG = Base.CropIcon(button.Icon, button)

        button.BorderAlive:SetAlpha(0)
        button.BorderDead:SetTexture([[Interface\PetBattles\DeadPetIcon]])
        button.BorderDead:SetTexCoord(0, 1, 0, 1)
        button.BorderDead:SetAllPoints()

        --[[ Scale ]]--
        button:SetSize(button:GetSize())
    end
    function Skin.PetBattleUnitTooltipTemplate(frame)
        Skin.TooltipBorderedFrameTemplate(frame)

        frame._auroraIconBG = Base.CropIcon(frame.Icon, frame)
        frame.HealthBorder:Hide()
        frame.XPBorder:SetAlpha(0)

        frame.Border:Hide()
        Base.SetTexture(frame.ActualHealthBar, "gradientUp")
        Base.SetTexture(frame.XPBar, "gradientUp")

        frame.Delimiter:SetHeight(1)
        frame.Delimiter2:SetHeight(1)


        --[[ Scale ]]--
        frame:SetSize(260, 190)

        frame.Icon:SetSize(38, 38)
        frame.Icon:SetPoint("TOPLEFT", 15, -15)
        frame.Name:SetSize(160, 33)
        frame.Name:SetPoint("TOPLEFT", frame.Icon, "TOPRIGHT", 7, -5)
        frame.SpeciesName:SetPoint("TOPLEFT", frame.Icon, "TOPRIGHT", 7, -21)
        frame.CollectedText:SetPoint("TOPLEFT", frame.Icon, "BOTTOMLEFT", 0, -4)

        frame.HealthBorder:SetSize(232, 16)
        frame.HealthBorder:SetPoint("TOPLEFT", frame.Icon, "BOTTOMLEFT", -1, -6)
        frame.XPBorder:SetSize(232, 16)
        frame.XPBorder:SetPoint("TOPLEFT", frame.HealthBorder, "BOTTOMLEFT", 0, -5)

        frame.HealthBG:SetSize(230, 14)
        frame.HealthBG:SetPoint("TOPLEFT", frame.HealthBorder, 1, -1)
        frame.XPBG:SetSize(230, 14)
        frame.XPBG:SetPoint("TOPLEFT", frame.XPBorder, 1, -1)

        frame.ActualHealthBar:SetPoint("BOTTOMLEFT", frame.HealthBG)
        frame.XPBar:SetPoint("BOTTOMLEFT", frame.XPBG)
        frame.Delimiter:SetSize(250, 2)
        frame.Delimiter:SetPoint("TOP", frame.XPBG, "BOTTOM", 0, -15)
        frame.StatsLabel:SetPoint("TOPLEFT", frame.Delimiter, "BOTTOMLEFT", 15, -8)
        frame.AbilitiesLabel:SetPoint("TOPLEFT", frame.Delimiter, "BOTTOMLEFT", 90, -8)
        frame.AttackIcon:SetSize(16, 16)
        frame.AttackIcon:SetPoint("TOPLEFT", frame.StatsLabel, "BOTTOMLEFT", 3, -7)
        frame.AttackAmount:SetPoint("LEFT", frame.AttackIcon, "RIGHT", 10, 0)
        frame.SpeedIcon:SetSize(16, 16)
        frame.SpeedIcon:SetPoint("TOPLEFT", frame.AttackIcon, "BOTTOMLEFT", 0, -7)
        frame.SpeedAmount:SetPoint("LEFT", frame.SpeedIcon, "RIGHT", 10, 0)

        for i = 1, 3 do
            local icon = frame["AbilityIcon"..i]
            icon:SetSize(20, 20)
            if i == 1 then
                icon:SetPoint("TOPLEFT", frame.AbilitiesLabel, "BOTTOMLEFT", 3, -6)
            else
                icon:SetPoint("TOPLEFT", frame["AbilityIcon"..i-1], "BOTTOMLEFT", 0, -7)
            end

            frame["AbilityName"..i]:SetSize(120, 28)
            frame["AbilityName"..i]:SetPoint("LEFT", icon, "RIGHT", 5, 0)
        end

        frame.HealthText:SetPoint("CENTER", frame.HealthBG)
        frame.XPText:SetPoint("CENTER", frame.XPBG)
        frame.SpeedAdvantageIcon:SetSize(16, 16)
        frame.SpeedAdvantageIcon:SetPoint("TOPLEFT", frame.AbilityIcon3, "BOTTOMLEFT", -90, -10)
        frame.SpeedAdvantage:SetWidth(226)
        frame.SpeedAdvantage:SetPoint("LEFT", frame.SpeedAdvantageIcon, "RIGHT", 2, 0)
        frame.Delimiter2:SetSize(250, 2)
        frame.Delimiter2:SetPoint("TOPLEFT", frame.SpeedAdvantageIcon, "BOTTOMLEFT", -3, -15)

        frame.PetType:SetSize(33, 33)
        frame.PetType:SetPoint("TOPRIGHT", -5, -5)
        frame.Debuffs:SetWidth(250)
        frame.Debuffs:SetPoint("TOPLEFT", frame.Delimiter2, "BOTTOMLEFT", 8, -10)
    end
    function Skin.PetBattleActionButtonTemplate(button)
        Base.CropIcon(button.Icon, button)

        --button.Count:SetPoint("TOPLEFT", -5, 5)

        --button.Flash:SetColorTexture(1, 0, 0, 0.5)
        --button.style:Hide()

        --button.cooldown:SetPoint("TOPLEFT")
        --button.cooldown:SetPoint("BOTTOMRIGHT")

        button:SetNormalTexture("")
        Base.CropIcon(button:GetHighlightTexture())
        Base.CropIcon(button:GetPushedTexture())

        --[[ Scale ]]--
        button:SetSize(52, 52)
        button.CooldownShadow:SetSize(52, 52)
        button.HotKey:SetSize(36, 10)
        button.HotKey:SetPoint("TOPRIGHT", -1, -3)
        button.SelectedHighlight:SetSize(93, 93)
        button.Lock:SetSize(32, 32)
        button.BetterIcon:SetSize(32, 32)
        button.BetterIcon:SetPoint("BOTTOMRIGHT", 9, -9)
    end
    Skin.PetBattleAbilityButtonTemplate = Skin.PetBattleActionButtonTemplate
end

function private.AddOns.Blizzard_PetBattleUI()
    _G.hooksecurefunc("PetBattleUnitFrame_UpdateDisplay", Hook.PetBattleUnitFrame_UpdateDisplay)
    _G.hooksecurefunc("PetBattleUnitTooltip_UpdateForUnit", Hook.PetBattleUnitTooltip_UpdateForUnit)
    _G.hooksecurefunc("PetBattleFrame_UpdateActionButtonLevel", Hook.PetBattleFrame_UpdateActionButtonLevel)
    _G.hooksecurefunc("PetBattleFrame_UpdateActionBarLayout", Hook.PetBattleFrame_UpdateActionBarLayout)
    _G.hooksecurefunc("PetBattleAuraHolder_Update", Hook.PetBattleAuraHolder_Update)

    local PetBattleFrame = _G.PetBattleFrame
    PetBattleFrame.TopArtLeft:Hide()
    PetBattleFrame.TopArtRight:Hide()

    PetBattleFrame.TopVersus:SetSize(155, 85)
    PetBattleFrame.TopVersus:SetTexture([[Interface\LevelUp\LevelUpTex]])
    PetBattleFrame.TopVersus:SetTexCoord(0.00195313, 0.6386719, 0.23828125, 0.03710938)

    local WeatherFrame = PetBattleFrame.WeatherFrame
    WeatherFrame:ClearAllPoints()
    WeatherFrame:SetPoint("TOP", 0, -60)

    local weatherMask = WeatherFrame:CreateMaskTexture(nil, "BORDER")
    weatherMask:SetTexture([[Interface\PetBattles\BattleBar-AbilityBadge-Neutral]], "CLAMPTOBLACKADDITIVE", "CLAMPTOBLACKADDITIVE")
    weatherMask:SetPoint("TOP", PetBattleFrame, 0, 256)
    weatherMask:SetSize(512, 512)
    weatherMask:Show()
    WeatherFrame.BackgroundArt:ClearAllPoints()
    WeatherFrame.BackgroundArt:SetPoint("TOP", 0, 60)
    WeatherFrame.BackgroundArt:SetSize(640, 160)
    WeatherFrame.BackgroundArt:AddMaskTexture(weatherMask)

    Base.CropIcon(WeatherFrame.Icon)
    WeatherFrame.Label:SetPoint("TOPLEFT", WeatherFrame.Icon, "TOPRIGHT", 2, -2)

    Skin.PetBattleAuraHolderTemplate(PetBattleFrame.EnemyPadBuffFrame)
    Skin.PetBattleAuraHolderTemplate(PetBattleFrame.EnemyPadDebuffFrame)
    Skin.PetBattleAuraHolderTemplate(PetBattleFrame.AllyPadBuffFrame)
    Skin.PetBattleAuraHolderTemplate(PetBattleFrame.AllyPadDebuffFrame)
    Skin.PetBattleAuraHolderTemplate(PetBattleFrame.EnemyBuffFrame)
    Skin.PetBattleAuraHolderTemplate(PetBattleFrame.EnemyDebuffFrame)
    Skin.PetBattleAuraHolderTemplate(PetBattleFrame.AllyBuffFrame)
    Skin.PetBattleAuraHolderTemplate(PetBattleFrame.AllyDebuffFrame)

    for index, unit in next, {PetBattleFrame.ActiveAlly, PetBattleFrame.ActiveEnemy} do
        unit._auroraIconBG = Base.CropIcon(unit.Icon, unit)

        unit.Border:SetAlpha(0)
        unit.HealthBarBG:SetSize(145, 37)
        unit.HealthBarBG:SetColorTexture(0, 0, 0, 0.5)

        unit.Border2:SetAlpha(0)
        unit.BorderFlash:Hide()

        unit.LevelUnderlay:Hide()
        unit.SpeedUnderlay:SetAlpha(0)
        Base.SetTexture(unit.ActualHealthBar, "gradientUp")
        unit.ActualHealthBar:SetVertexColor(0, 1, 0)

        unit.HealthBarFrame:Hide()

        local mask = unit.PetType:CreateMaskTexture(nil, "BORDER")
        mask:SetTexture([[Interface\PetBattles\BattleBar-AbilityBadge-Neutral]], "CLAMPTOBLACKADDITIVE", "CLAMPTOBLACKADDITIVE")
        mask:SetPoint("CENTER")
        mask:SetSize(32, 32)
        mask:Show()
        unit.PetType.Background:AddMaskTexture(mask)
        unit.PetType.Icon:AddMaskTexture(mask)

        if index == 1 then
            -- ActiveAlly
            unit.HealthBarBG:SetPoint("BOTTOMLEFT", unit.Icon, "BOTTOMRIGHT", 13, 5)
        else
            -- ActiveEnemy
            unit.HealthBarBG:SetPoint("BOTTOMRIGHT", unit.Icon, "BOTTOMLEFT", -13, 5)
        end


        --[[ Scale ]]--
        unit:SetSize(270, 80)
        unit.Icon:SetSize(68, 68)
        unit.LevelUnderlay:SetSize(24, 24)
        unit.SpeedUnderlay:SetSize(24, 24)
        unit.SpeedIcon:SetSize(16, 16)
        unit.ActualHealthBar:SetHeight(37)
        unit.PetType:SetSize(36, 36)
        unit.PetType.Icon:SetSize(33, 33)
        unit.PetType.ActiveStatus:SetSize(45, 45)

        if index == 1 then
            -- ActiveAlly
            unit:SetPoint("TOPLEFT", PetBattleFrame.TopArtLeft, 115, -5)
            unit.Name:SetPoint("TOPLEFT", unit.Icon, "TOPRIGHT", 13, 0)
            unit.LevelUnderlay:SetPoint("BOTTOMLEFT", unit.Icon, -3, -3)
            unit.SpeedUnderlay:SetPoint("BOTTOMRIGHT", unit.Icon, 3, -3)
            unit.ActualHealthBar:SetPoint("LEFT", unit.HealthBarBG)
            unit.PetType:SetPoint("BOTTOMRIGHT", -2, 12)
        else
            -- ActiveEnemy
            unit:SetPoint("TOPRIGHT", PetBattleFrame.TopArtRight, -115, -5)
            unit.Name:SetPoint("TOPRIGHT", unit.Icon, "TOPLEFT", -13, 0)
            unit.LevelUnderlay:SetPoint("BOTTOMRIGHT", unit.Icon, 3, -3)
            unit.SpeedUnderlay:SetPoint("BOTTOMLEFT", unit.Icon, -3, -3)
            unit.ActualHealthBar:SetPoint("RIGHT", unit.HealthBarBG)
            unit.PetType:SetPoint("BOTTOMLEFT", 2, 12)
        end
    end

    Skin.PetBattleMiniUnitFrameAlly(PetBattleFrame.Ally2)
    Skin.PetBattleMiniUnitFrameAlly(PetBattleFrame.Ally3)

    Skin.PetBattleMiniUnitFrameEnemy(PetBattleFrame.Enemy2)
    Skin.PetBattleMiniUnitFrameEnemy(PetBattleFrame.Enemy3)

    local BottomFrame = PetBattleFrame.BottomFrame
    BottomFrame:SetSize(300, 100)
    BottomFrame.RightEndCap:Hide()
    BottomFrame.LeftEndCap:Hide()
    BottomFrame.Background:Hide()

    local xpBar = BottomFrame.xpBar
    xpBar:SetHeight(10)
    xpBar:ClearAllPoints()
    xpBar:SetPoint("BOTTOMLEFT")
    xpBar:SetPoint("BOTTOMRIGHT")
    Base.SetTexture(xpBar:GetStatusBarTexture(), "gradientUp")
    local _, xpLeft, xpRight, xpMid = xpBar:GetRegions()
    xpLeft:Hide()
    xpRight:Hide()
    xpMid:Hide()

    xpBar._auroraDivs = {}
    for i = 1, 6 do
        local texture
        texture = _G["PetBattleXPBarDiv"..i]
        texture:SetColorTexture(0, 0, 0)
        texture:SetSize(1, 10)
        xpBar._auroraDivs[i] = texture
    end

    local TurnTimer = BottomFrame.TurnTimer
    TurnTimer.TimerBG:SetColorTexture(0, 0, 0, 0.5)
    TurnTimer.TimerBG:SetPoint("TOPLEFT", TurnTimer.ArtFrame)
    TurnTimer.TimerBG:SetPoint("BOTTOMRIGHT", TurnTimer.ArtFrame)
    TurnTimer.ArtFrame:SetAlpha(0)
    TurnTimer.ArtFrame2:SetAlpha(0)
    Skin.UIPanelButtonTemplate(TurnTimer.SkipButton)

    BottomFrame.FlowFrame:SetPoint("LEFT", 15, 0)
    local flowLeft, flowRight, flowMid = BottomFrame.FlowFrame:GetRegions()
    flowLeft:Hide()
    flowRight:Hide()
    flowMid:Hide()

    Base.CropIcon(BottomFrame.SwitchPetButton:GetCheckedTexture())
    BottomFrame.Delimiter:SetSize(1, 56)
    local delim = BottomFrame.Delimiter:GetRegions()
    delim:SetColorTexture(1, 1, 1, 0.5)
    delim:SetSize(1, 56)

    BottomFrame.MicroButtonFrame:SetPoint("RIGHT", -20, 0)
    local microLeft, microRight, microMid = BottomFrame.MicroButtonFrame:GetRegions()
    microLeft:Hide()
    microRight:Hide()
    microMid:Hide()

    --[[ Scale ]]--
    WeatherFrame:SetSize(170, 40)
    WeatherFrame.Icon:SetSize(32, 32)
    PetBattleFrame.TopArtLeft:SetSize(574, 118)
    PetBattleFrame.TopArtRight:SetSize(574, 118)
    PetBattleFrame.TopVersusText:SetPoint("TOP", 0, -6)

    PetBattleFrame.EnemyPadBuffFrame:SetPoint("TOPLEFT", PetBattleFrame.TopArtRight, "BOTTOMRIGHT", -400, 20)
    PetBattleFrame.AllyPadBuffFrame:SetPoint("TOPRIGHT", PetBattleFrame.TopArtLeft, "BOTTOMLEFT", 400, 20)
    PetBattleFrame.AllyBuffFrame:SetPoint("TOPLEFT", PetBattleFrame.TopArtLeft, "BOTTOMLEFT", 70, 20)
    PetBattleFrame.EnemyBuffFrame:SetPoint("TOPRIGHT", PetBattleFrame.TopArtRight, "BOTTOMRIGHT", -70, 20)

    PetBattleFrame.Ally2:SetPoint("TOPLEFT", PetBattleFrame.TopArtLeft, 65, -2)
    PetBattleFrame.Ally3:SetPoint("TOPLEFT", PetBattleFrame.Ally2, "BOTTOMLEFT", 0, -5)

    PetBattleFrame.Enemy2:SetPoint("TOPRIGHT", PetBattleFrame.TopArtRight, -65, -2)
    PetBattleFrame.Enemy3:SetPoint("TOPRIGHT", PetBattleFrame.Enemy2, "BOTTOMRIGHT", 0, -5)

    BottomFrame.FlowFrame:SetSize(1024, 56)
    delim:SetPoint("CENTER", 0, 2)
    BottomFrame.MicroButtonFrame:SetSize(140, 56)

    if not private.disabled.tooltips then
        Skin.PetBattleUnitTooltipTemplate(_G.PetBattlePrimaryUnitTooltip)
        Skin.SharedPetBattleAbilityTooltipTemplate(_G.PetBattlePrimaryAbilityTooltip)
    end
end
