local _, private = ...

-- [[ Core ]]
local Aurora = private.Aurora
local Hook, Skin = Aurora.Hook, Aurora.Skin
local F = _G.unpack(private.Aurora)

do --[[ FrameXML\CharacterFrame.xml ]]
    function Skin.CharacterStatFrameCategoryTemplate(button)
        local bg = button.Background
        bg:SetTexture([[Interface\LFGFrame\UI-LFG-SEPARATOR]])
        bg:SetTexCoord(0, 0.6640625, 0, 0.3125)
        bg:ClearAllPoints()
        bg:SetPoint("CENTER", 0, -5)
        bg:SetSize(210, 30)

        local r, g, b = Aurora.highlightColor:GetRGB()
        bg:SetVertexColor(r * 0.7, g * 0.7, b * 0.7)
    end
    function Skin.CharacterStatFrameTemplate(button)
        local bg = button.Background
        bg:ClearAllPoints()
        bg:SetPoint("TOPLEFT")
        bg:SetPoint("BOTTOMRIGHT")
        bg:SetColorTexture(1, 1, 1, 0.2)
    end
end

function private.FrameXML.CharacterFrame()
    _G.hooksecurefunc(_G.CharacterStatsPane.statsFramePool, "Acquire", Hook.ObjectPoolMixin_Acquire)

    Skin.ButtonFrameTemplate(_G.CharacterFrame)
    F.CreateBD(_G.CharacterFrame)
    F.CreateSD(_G.CharacterFrame)

    _G.CharacterFrame.TitleText:SetPoint("BOTTOMRIGHT", _G.CharacterFrameInset, "TOPRIGHT", 0, 0)
    _G.CharacterFrameInset:SetPoint("TOPLEFT", 4, -private.FRAME_TITLE_HEIGHT)
    _G.CharacterFrameInset:SetPoint("BOTTOMRIGHT", _G.CharacterFrame, "BOTTOMLEFT", _G.CharacterFrame:GetWidth() - 4, 4)

    Skin.CharacterFrameTabButtonTemplate(_G.CharacterFrameTab1)
    _G.CharacterFrameTab1:SetPoint("TOPLEFT", _G.CharacterFrame, "BOTTOMLEFT", 20, -1)
    Skin.CharacterFrameTabButtonTemplate(_G.CharacterFrameTab2)
    _G.CharacterFrameTab2:SetPoint("TOPLEFT", _G.CharacterFrameTab1, "TOPRIGHT", 1, 0)
    Skin.CharacterFrameTabButtonTemplate(_G.CharacterFrameTab3)
    _G.CharacterFrameTab3:SetPoint("TOPLEFT", _G.CharacterFrameTab2, "TOPRIGHT", 1, 0)

    Skin.InsetFrameTemplate(_G.CharacterFrameInsetRight)
    _G.CharacterFrameInsetRight:SetPoint("TOPLEFT", _G.CharacterFrameInset, "TOPRIGHT", 1, -20)

    local CharacterStatsPane = _G.CharacterStatsPane

    local ClassBackground = CharacterStatsPane.ClassBackground
    local atlas = "legionmission-landingpage-background-"..private.charClass.token
    local _, width, height = _G.GetAtlasInfo(atlas)
    width, height = _G.Round(width * 0.7), _G.Round(height * 0.7)
    ClassBackground:ClearAllPoints()
    ClassBackground:SetPoint("CENTER")
    ClassBackground:SetSize(width, height)
    ClassBackground:SetAtlas(atlas)
    ClassBackground:SetDesaturated(true)
    ClassBackground:SetAlpha(0)


    CharacterStatsPane.ItemLevelFrame.Value:SetFontObject("SystemFont_Shadow_Huge2")
    CharacterStatsPane.ItemLevelFrame.Value:SetShadowOffset(0, 0)
    CharacterStatsPane.ItemLevelFrame.Background:Hide()
    Skin.CharacterStatFrameCategoryTemplate(CharacterStatsPane.ItemLevelCategory)
    Skin.CharacterStatFrameCategoryTemplate(CharacterStatsPane.AttributesCategory)
    Skin.CharacterStatFrameCategoryTemplate(CharacterStatsPane.EnhancementsCategory)
end
