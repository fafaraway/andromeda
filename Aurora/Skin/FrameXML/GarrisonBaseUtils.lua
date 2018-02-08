local _, private = ...

--[[ Lua Globals ]]
-- luacheck: globals

-- [[ Core ]]
local Aurora = private.Aurora
local Base, Hook, Skin = Aurora.Base, Aurora.Hook, Aurora.Skin

do --[[ FrameXML\GarrisonBaseUtils.lua ]]
    function Hook.GarrisonFollowerPortraitMixin_SetQuality(self, quality)
        local color = _G.ITEM_QUALITY_COLORS[quality]
        self:SetBackdropBorderColor(color.r, color.g, color.b)
    end
end

do --[[ FrameXML\GarrisonBaseUtils.xml ]]
    function Skin.PositionGarrisonAbiltyBorder(border, icon)
        border:ClearAllPoints()
        border:SetPoint("TOPLEFT", icon, -8, 8)
        border:SetPoint("BOTTOMRIGHT", icon, 8, -8)
    end
    function Skin.GarrisonFollowerPortraitTemplate(frame)
        _G.hooksecurefunc(frame, "SetQuality", Hook.GarrisonFollowerPortraitMixin_SetQuality)

        local size = frame.Portrait:GetSize() + 2
        frame:SetSize(size, size)
        Base.SetBackdrop(frame, Aurora.frameColor.r, Aurora.frameColor.g, Aurora.frameColor.b, 1)

        frame.PortraitRing:Hide()

        frame.Portrait:ClearAllPoints()
        frame.Portrait:SetPoint("TOPLEFT", 1, -1)

        frame.PortraitRingQuality:SetTexture("")
        frame.LevelBorder:SetAlpha(0)

        local lvlBG = frame:CreateTexture(nil, "BORDER")
        lvlBG:SetColorTexture(0, 0, 0, 0.5)
        lvlBG:SetPoint("TOPLEFT", frame, "BOTTOMLEFT", 1, 12)
        lvlBG:SetPoint("BOTTOMRIGHT", frame, -1, 1)

        local level = frame.Level
        level:ClearAllPoints()
        level:SetPoint("CENTER", lvlBG)

        frame.PortraitRingCover:SetTexture("")
    end
end

function private.FrameXML.GarrisonBaseUtils()
    --[[
    ]]
end
