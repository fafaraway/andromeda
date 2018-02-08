local _, private = ...

--[[ Lua Globals ]]
-- luacheck: globals

--[[ Core ]]
local Aurora = private.Aurora
local Base = Aurora.Base
local Skin = Aurora.Skin

do --[[ FrameXML\ActionButtonTemplate.xml ]]
	function Skin.ActionButtonTemplate(checkbutton)
        Base.CropIcon(checkbutton.icon)

        checkbutton.Flash:SetColorTexture(1, 0, 0, 0.5)
        Base.CropIcon(checkbutton.NewActionTexture)
        Base.CropIcon(checkbutton.SpellHighlightTexture)

        checkbutton:SetNormalTexture("")
        Base.CropIcon(checkbutton:GetPushedTexture())
        Base.CropIcon(checkbutton:GetHighlightTexture())
        Base.CropIcon(checkbutton:GetCheckedTexture())

		--[[ Scale ]]--
		checkbutton:SetSize(36, 36)
        checkbutton.HotKey:SetPoint("TOPLEFT", 1, -3)
        checkbutton.HotKey:SetPoint("BOTTOMRIGHT", checkbutton, "TOPRIGHT", -1, -13)
        checkbutton.Count:SetPoint("BOTTOMRIGHT", -2, 2)

        checkbutton.Name:ClearAllPoints()
        checkbutton.Name:SetPoint("TOPLEFT", checkbutton, "BOTTOMLEFT", 0, 12)
        checkbutton.Name:SetPoint("BOTTOMRIGHT", 0, 2)

        checkbutton.cooldown:SetPoint("TOPLEFT")
        checkbutton.cooldown:SetPoint("BOTTOMRIGHT")
	end
end

function private.FrameXML.ActionButtonTemplate()
    --[[
    ]]
end
