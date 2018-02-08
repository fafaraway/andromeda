local _, private = ...

-- [[ Lua Globals ]]
local next, ipairs = _G.next, _G.ipairs

-- [[ WoW API ]]
local hooksecurefunc, CreateFrame = _G.hooksecurefunc, _G.CreateFrame

-- [[ Core ]]
local F = _G.unpack(private.Aurora)

function private.FrameXML.ChatConfigFrame()
    F.CreateBD(_G.ChatConfigFrame)
    F.CreateSD(_G.ChatConfigFrame)

    _G.ChatConfigFrameHeader:SetTexture("")
    _G.ChatConfigFrameHeader:ClearAllPoints()
    _G.ChatConfigFrameHeader:SetPoint("TOP")

    --[[ Catagories ]]
    _G.ChatConfigCategoryFrame:SetBackdrop(nil)
    local line = _G.ChatConfigFrame:CreateTexture()
    line:SetSize(1, 460)
    line:SetPoint("TOPLEFT", _G.ChatConfigCategoryFrame, "TOPRIGHT")
    line:SetColorTexture(1, 1, 1, .2)

    _G.ChatConfigBackgroundFrame:SetBackdrop(nil)

    --[[ Chat Settings ]]
    F.CreateBD(_G.ChatConfigChatSettingsClassColorLegend, .25)

    --[[ Channel Settings ]]
    F.CreateBD(_G.ChatConfigChannelSettingsClassColorLegend, .25)

    --[[ Combat Settings ]]
    _G.ChatConfigCombatSettingsFilters:SetBackdrop(nil)

    local combatBG = _G.CreateFrame("Frame", nil, _G.ChatConfigCombatSettingsFilters)
    combatBG:SetPoint("TOPLEFT", 3, 0)
    combatBG:SetPoint("BOTTOMRIGHT", 0, 1)
    combatBG:SetFrameLevel(_G.ChatConfigCombatSettingsFilters:GetFrameLevel()-1)
    F.CreateBD(combatBG, .25)

    F.Reskin(_G.ChatConfigCombatSettingsFiltersDeleteButton)
    F.Reskin(_G.ChatConfigCombatSettingsFiltersAddFilterButton)
    F.Reskin(_G.ChatConfigCombatSettingsFiltersCopyFilterButton)
    _G.ChatConfigCombatSettingsFiltersAddFilterButton:SetPoint("RIGHT", _G.ChatConfigCombatSettingsFiltersDeleteButton, "LEFT", -1, 0)
    _G.ChatConfigCombatSettingsFiltersCopyFilterButton:SetPoint("RIGHT", _G.ChatConfigCombatSettingsFiltersAddFilterButton, "LEFT", -1, 0)

    _G.ChatConfigMoveFilterUpButton:SetSize(28, 28)
    _G.ChatConfigMoveFilterDownButton:SetSize(28, 28)
    _G.ChatConfigMoveFilterUpButton:SetPoint("TOPLEFT", _G.ChatConfigCombatSettingsFilters, "BOTTOMLEFT", 3, 0)
    _G.ChatConfigMoveFilterDownButton:SetPoint("LEFT", _G.ChatConfigMoveFilterUpButton, "RIGHT", 1, 0)
    F.ReskinArrow(_G.ChatConfigMoveFilterUpButton, "Up")
    F.ReskinArrow(_G.ChatConfigMoveFilterDownButton, "Down")

    for i = 1, 5 do
        _G["CombatConfigTab"..i.."Left"]:Hide()
        _G["CombatConfigTab"..i.."Middle"]:Hide()
        _G["CombatConfigTab"..i.."Right"]:Hide()
    end

    -- Combat Highlighting
    _G.CombatConfigColorsHighlighting:SetBackdrop(nil)
    local highlightBoxes = {"CombatConfigColorsHighlightingLine", "CombatConfigColorsHighlightingAbility", "CombatConfigColorsHighlightingDamage", "CombatConfigColorsHighlightingSchool"}
    for _, box in next, highlightBoxes do
        F.ReskinCheck(_G[box])
    end

    -- Combat Colorize
    local colorizeBoxes = {"CombatConfigColorsColorizeUnitNameCheck", "CombatConfigColorsColorizeSpellNamesCheck", "CombatConfigColorsColorizeSpellNamesSchoolColoring", "CombatConfigColorsColorizeDamageNumberCheck", "CombatConfigColorsColorizeDamageNumberSchoolColoring", "CombatConfigColorsColorizeDamageSchoolCheck", "CombatConfigColorsColorizeEntireLineCheck"}
    for _, box in next, colorizeBoxes do
        F.ReskinCheck(_G[box])
    end

    _G.CombatConfigColorsColorizeUnitName:SetBackdrop(nil)
    _G.CombatConfigColorsColorizeSpellNames:SetBackdrop(nil)
    _G.CombatConfigColorsColorizeDamageNumber:SetBackdrop(nil)
    _G.CombatConfigColorsColorizeDamageSchool:SetBackdrop(nil)
    _G.CombatConfigColorsColorizeEntireLine:SetBackdrop(nil)
    F.ReskinRadio(_G.CombatConfigColorsColorizeEntireLineBySource)
    F.ReskinRadio(_G.CombatConfigColorsColorizeEntireLineByTarget)
    F.ReskinColourSwatch(_G.CombatConfigColorsColorizeSpellNamesColorSwatch)
    F.ReskinColourSwatch(_G.CombatConfigColorsColorizeDamageNumberColorSwatch)

    -- Combat Formatting
    local formatBoxes = {"CombatConfigFormattingShowTimeStamp", "CombatConfigFormattingShowBraces", "CombatConfigFormattingUnitNames", "CombatConfigFormattingSpellNames", "CombatConfigFormattingItemNames", "CombatConfigFormattingFullText"}
    for _, box in next, formatBoxes do
        F.ReskinCheck(_G[box])
    end

    -- Combat Settings
    local settingsBoxes = {"CombatConfigSettingsShowQuickButton", "CombatConfigSettingsSolo", "CombatConfigSettingsParty", "CombatConfigSettingsRaid"}
    for _, box in next, settingsBoxes do
        F.ReskinCheck(_G[box])
    end
    F.ReskinInput(_G.CombatConfigSettingsNameEditBox)
    F.Reskin(_G.CombatConfigSettingsSaveButton)

    F.Reskin(_G.ChatConfigFrame.DefaultButton)
    F.Reskin(_G.ChatConfigFrame.RedockButton)
    F.Reskin(_G.CombatLogDefaultButton)
    _G.ChatConfigFrame.DefaultButton:SetPoint("BOTTOMLEFT", 10, 10)
    _G.ChatConfigFrame.RedockButton:SetPoint("BOTTOMLEFT", _G.ChatConfigFrame.DefaultButton, "BOTTOMRIGHT", 5, 0)

    F.Reskin(_G.ChatConfigFrameOkayButton)
    _G.ChatConfigFrameOkayButton:ClearAllPoints()
    _G.ChatConfigFrameOkayButton:SetPoint("BOTTOMRIGHT", -10, 10)

    hooksecurefunc("ChatConfig_CreateCheckboxes", function(frame, checkBoxTable, checkBoxTemplate)
        if frame.styled then return end

        frame:SetBackdrop(nil)

        local checkBoxNameString = frame:GetName().."CheckBox"

        if checkBoxTemplate == "ChatConfigCheckBoxTemplate" then
            for index, value in ipairs(checkBoxTable) do
                local checkBoxName = checkBoxNameString..index
                local checkbox = _G[checkBoxName]

                checkbox:SetBackdrop(nil)

                local bg = CreateFrame("Frame", nil, checkbox)
                bg:SetPoint("TOPLEFT")
                bg:SetPoint("BOTTOMRIGHT", 0, 1)
                bg:SetFrameLevel(checkbox:GetFrameLevel()-1)
                F.CreateBD(bg, .25)

                F.ReskinCheck(_G[checkBoxName.."Check"])
            end
        elseif checkBoxTemplate == "ChatConfigCheckBoxWithSwatchTemplate" or checkBoxTemplate == "ChatConfigCheckBoxWithSwatchAndClassColorTemplate" then
            for index, value in ipairs(checkBoxTable) do
                local checkBoxName = checkBoxNameString..index
                local checkbox = _G[checkBoxName]

                checkbox:SetBackdrop(nil)

                local bg = CreateFrame("Frame", nil, checkbox)
                bg:SetPoint("TOPLEFT")
                bg:SetPoint("BOTTOMRIGHT", 0, 1)
                bg:SetFrameLevel(checkbox:GetFrameLevel()-1)
                F.CreateBD(bg, .25)

                F.ReskinColourSwatch(_G[checkBoxName.."ColorSwatch"])

                F.ReskinCheck(_G[checkBoxName.."Check"])

                if checkBoxTemplate == "ChatConfigCheckBoxWithSwatchAndClassColorTemplate" then
                    F.ReskinCheck(_G[checkBoxName.."ColorClasses"])
                end
            end
        end

        frame.styled = true
    end)

    hooksecurefunc("ChatConfig_CreateTieredCheckboxes", function(frame, checkBoxTable, checkBoxTemplate, subCheckBoxTemplate)
        if frame.styled then return end

        local checkBoxNameString = frame:GetName().."CheckBox"

        for index, value in ipairs(checkBoxTable) do
            local checkBoxName = checkBoxNameString..index

            F.ReskinCheck(_G[checkBoxName])

            if value.subTypes then
                local subCheckBoxNameString = checkBoxName.."_"

                for k, v in ipairs(value.subTypes) do
                    F.ReskinCheck(_G[subCheckBoxNameString..k])
                end
            end
        end

        frame.styled = true
    end)

    hooksecurefunc("ChatConfig_CreateColorSwatches", function(frame, swatchTable, swatchTemplate)
        if frame.styled then return end

        frame:SetBackdrop(nil)

        local nameString = frame:GetName().."Swatch"

        for index, value in ipairs(swatchTable) do
            local swatchName = nameString..index
            local swatch = _G[swatchName]

            swatch:SetBackdrop(nil)

            local bg = CreateFrame("Frame", nil, swatch)
            bg:SetPoint("TOPLEFT")
            bg:SetPoint("BOTTOMRIGHT", 0, 1)
            bg:SetFrameLevel(swatch:GetFrameLevel()-1)
            F.CreateBD(bg, .25)

            F.ReskinColourSwatch(_G[swatchName.."ColorSwatch"])
        end

        frame.styled = true
    end)
end
