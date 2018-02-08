local _, private = ...

--[[ Lua Globals ]]
-- luacheck: globals

--[[ Core ]]
local Aurora = private.Aurora
local Skin = Aurora.Skin

--[[ do FrameXML\InterfaceOptionsPanels.lua
end ]]

do --[[ FrameXML\InterfaceOptionsPanels.xml ]]
    function Skin.InterfaceOptionsBaseCheckButtonTemplate(checkbutton)
        Skin.OptionsBaseCheckButtonTemplate(checkbutton)
    end
    function Skin.InterfaceOptionsCheckButtonTemplate(checkbutton)
        Skin.InterfaceOptionsBaseCheckButtonTemplate(checkbutton)
        checkbutton.Text:SetPoint("LEFT", checkbutton, "RIGHT", 3, 0)
    end
    function Skin.InterfaceOptionsSmallCheckButtonTemplate(checkbutton)
        Skin.OptionsBaseCheckButtonTemplate(checkbutton)
        local name = checkbutton:GetName()
        _G[name.."Text"]:SetPoint("LEFT", checkbutton, "RIGHT", 3, 0)
    end
end

function private.FrameXML.InterfaceOptionsPanels()
    --[[
    ]]
end
