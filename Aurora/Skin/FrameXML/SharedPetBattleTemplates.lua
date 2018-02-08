local _, private = ...

--[[ Lua Globals ]]
-- luacheck: globals

--[[ Core ]]
local Aurora = private.Aurora
local Skin = Aurora.Skin

--[[ do FrameXML\SharedPetBattleTemplates.lua
end ]]

do --[[ FrameXML\SharedPetBattleTemplates.xml ]]
    function Skin.SharedPetBattleAbilityTooltipTemplate(frame)
        Skin.TooltipBorderedFrameTemplate(frame)

        frame.Delimiter1:SetHeight(1)
        frame.Delimiter2:SetHeight(1)

        --[[ Scale ]]--
        frame:SetSize(260, 90)
        frame.AbilityPetType:SetSize(33, 33)
        frame.AbilityPetType:SetPoint("TOPLEFT", 11, -10)
        frame.CurrentCooldown:SetPoint("TOPLEFT", frame.MaxCooldown, "BOTTOMLEFT", 0, -5)
        frame.Description:SetWidth(239)

        frame.Delimiter1:SetSize(250, 2)
        frame.Delimiter1:SetPoint("TOP", frame.Description, "BOTTOM", 0, -7)
        frame.StrongAgainstIcon:SetSize(32, 32)
        frame.StrongAgainstIcon:SetPoint("TOPLEFT", frame.Delimiter1, "BOTTOMLEFT", 5, -5)
        frame.StrongAgainstLabel:SetPoint("LEFT", frame.StrongAgainstIcon, "RIGHT", 5, 0)
        frame.StrongAgainstType1:SetSize(33, 33)
        frame.StrongAgainstType1:SetPoint("LEFT", frame.StrongAgainstLabel, "RIGHT", 5, -2)
        frame.StrongAgainstType1Label:SetPoint("LEFT", frame.StrongAgainstType1, "RIGHT", 5, 0)

        frame.Delimiter2:SetSize(250, 2)
        frame.Delimiter2:SetPoint("TOPLEFT", frame.StrongAgainstIcon, "BOTTOMLEFT", -5, -5)
        frame.WeakAgainstIcon:SetSize(32, 32)
        frame.WeakAgainstIcon:SetPoint("TOPLEFT", frame.Delimiter2, "BOTTOMLEFT", 5, -5)
        frame.WeakAgainstLabel:SetPoint("LEFT", frame.WeakAgainstIcon, "RIGHT", 5, 0)
        frame.WeakAgainstType1:SetSize(33, 33)
        frame.WeakAgainstType1:SetPoint("LEFT", frame.WeakAgainstLabel, "RIGHT", 5, -2)
        frame.WeakAgainstType1Label:SetPoint("LEFT", frame.WeakAgainstType1, "RIGHT", 5, 0)

        frame._auroraNoSetHeight = true
    end
end

function private.FrameXML.SharedPetBattleTemplates()
    --[[
    ]]
end
