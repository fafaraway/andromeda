local _, private = ...

--[[ Lua Globals ]]
-- luacheck: globals

--[[ Core ]]
local Aurora = private.Aurora
local Base, Skin = Aurora.Base, Aurora.Skin

--[[ do FrameXML\ExtraActionBar.lua
end ]]

do --[[ FrameXML\ExtraActionBar.xml ]]
    -- /run ActionButton_StartFlash(ExtraActionButton1)
    function Skin.ExtraActionButtonTemplate(checkbutton)
        Base.CropIcon(checkbutton.icon, checkbutton)

        checkbutton.HotKey:SetPoint("TOPLEFT", 5, -5)
        checkbutton.Count:SetPoint("TOPLEFT", -5, 5)

        checkbutton.Flash:SetColorTexture(1, 0, 0, 0.5)
        checkbutton.style:Hide()

        checkbutton.cooldown:SetPoint("TOPLEFT")
        checkbutton.cooldown:SetPoint("BOTTOMRIGHT")

        checkbutton:SetNormalTexture("")
        Base.CropIcon(checkbutton:GetHighlightTexture())
        Base.CropIcon(checkbutton:GetCheckedTexture())
    end
end

function private.FrameXML.ExtraActionBar()
    if private.disabled.mainmenubar then return end

    Skin.ExtraActionButtonTemplate(_G.ExtraActionButton1)
end
