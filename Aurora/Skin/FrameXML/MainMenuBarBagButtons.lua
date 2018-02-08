local _, private = ...

--[[ Lua Globals ]]
-- luacheck: globals

--[[ Core ]]
local Aurora = private.Aurora
local Skin = Aurora.Skin

--[[ do FrameXML\MainMenuBarBagButtons.lua
end ]]

do --[[ FrameXML\MainMenuBarBagButtons.xml ]]
    function Skin.BagSlotButtonTemplate(checkbutton)
        Skin.ItemButtonTemplate(checkbutton)

        --[[ Scale ]]--
        checkbutton:SetSize(30, 30)
    end
end

function private.FrameXML.MainMenuBarBagButtons()
    if private.disabled.mainmenubar then return end
    
    Skin.BagSlotButtonTemplate(_G.MainMenuBarBackpackButton)

    Skin.BagSlotButtonTemplate(_G.CharacterBag0Slot)
    Skin.BagSlotButtonTemplate(_G.CharacterBag1Slot)
    Skin.BagSlotButtonTemplate(_G.CharacterBag2Slot)
    Skin.BagSlotButtonTemplate(_G.CharacterBag3Slot)
    _G.CharacterBag0Slot:SetPoint("RIGHT", _G.MainMenuBarBackpackButton, "LEFT", -3, 0)
    _G.CharacterBag1Slot:SetPoint("RIGHT", _G.CharacterBag0Slot, "LEFT", -3, 0)
    _G.CharacterBag2Slot:SetPoint("RIGHT", _G.CharacterBag1Slot, "LEFT", -3, 0)
    _G.CharacterBag3Slot:SetPoint("RIGHT", _G.CharacterBag2Slot, "LEFT", -3, 0)

    --[[ Scale ]]--
    if private.isPatch then
        _G.MainMenuBarBackpackButton:SetPoint("TOPRIGHT", -4, -4)
    else
        _G.MainMenuBarBackpackButton:SetPoint("BOTTOMRIGHT", -4, 6)
    end
end
