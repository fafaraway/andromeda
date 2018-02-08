local _, private = ...

--[[ Lua Globals ]]
-- luacheck: globals

--[[ Core ]]
local Aurora = private.Aurora
local Base = Aurora.Base
local Skin = Aurora.Skin

--[[ do FrameXML\MoneyInputFrame.lua
end ]]

do --[[ FrameXML\MoneyInputFrame.xml ]]
    local money = {"gold", "silver", "copper"}
    function Skin.MoneyInputFrameTemplate(frame)
        for i = 1, #money do
            local editbox = frame[money[i]]

            local name = editbox:GetName()
            _G[name.."Left"]:Hide()
            _G[name.."Middle"]:Hide()
            _G[name.."Right"]:Hide()

            local bd = _G.CreateFrame("Frame", nil, editbox)
            bd:SetPoint("TOPLEFT", -2, 0)
            bd:SetPoint("BOTTOMRIGHT")
            bd:SetFrameLevel(editbox:GetFrameLevel()-1)
            Base.SetBackdrop(bd, Aurora.frameColor:GetRGBA())

            if i > 1 then
                editbox:SetPoint("LEFT", frame[money[i - 1]], "RIGHT", 6, 0)
                editbox:SetSize(35, 20)
            else
                editbox:SetSize(70, 20)
            end

            --[[ Scale ]]--
            editbox.texture:SetSize(13, 13)
            editbox.texture:SetPoint("RIGHT", -4, 0)
        end

        --[[ Scale ]]--
        frame:SetSize(176, 18)
    end
end

function private.FrameXML.MoneyInputFrame()
    --[[
    ]]
end
