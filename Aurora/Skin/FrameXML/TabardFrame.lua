local _, private = ...

-- [[ Core ]]
local F = _G.unpack(private.Aurora)
local Skin = private.Aurora.Skin

function private.FrameXML.TabardFrame()
    F.ReskinPortraitFrame(_G.TabardFrame, true)

    for i = 19, 28 do -- OuterFrame textures
        _G.select(i, _G.TabardFrame:GetRegions()):Hide()
    end
    _G.TabardFrameEmblemTopRight:SetPoint("TOPRIGHT", 15, -50)

    _G.TabardFrameNameText:ClearAllPoints()
    _G.TabardFrameNameText:SetPoint("TOPLEFT")
    _G.TabardFrameNameText:SetPoint("BOTTOMRIGHT", _G.TabardFrame, "TOPRIGHT", 0, -29)

    _G.TabardFrameGreetingText:ClearAllPoints()
    _G.TabardFrameGreetingText:SetPoint("TOPLEFT", 50, -30)
    _G.TabardFrameGreetingText:SetPoint("BOTTOMRIGHT", _G.TabardFrame, "TOPRIGHT", -50, -69)

    F.ReskinArrow(_G.TabardCharacterModelRotateLeftButton, "Left")
    F.ReskinArrow(_G.TabardCharacterModelRotateRightButton, "Right")
    _G.TabardCharacterModelRotateRightButton:SetPoint("TOPLEFT", _G.TabardCharacterModelRotateLeftButton, "TOPRIGHT", 1, 0)

    _G.TabardFrameCostFrame:SetBackdrop(nil)

    _G.TabardFrameCustomizationBorder:Hide()
    _G.TabardFrameCustomization1:ClearAllPoints()
    _G.TabardFrameCustomization1:SetPoint("BOTTOMRIGHT", _G.TabardFrame, -3, 140)
    for i = 1, 5 do
        _G["TabardFrameCustomization"..i.."Left"]:Hide()
        _G["TabardFrameCustomization"..i.."Middle"]:Hide()
        _G["TabardFrameCustomization"..i.."Right"]:Hide()
        F.ReskinArrow(_G["TabardFrameCustomization"..i.."LeftButton"], "Left")
        F.ReskinArrow(_G["TabardFrameCustomization"..i.."RightButton"], "Right")
    end

    Skin.InsetFrameTemplate(_G.TabardFrameMoneyInset)
    Skin.ThinGoldEdgeTemplate(_G.TabardFrameMoneyBg)
    _G.TabardFrameMoneyBg:Hide()

    F.Reskin(_G.TabardFrameAcceptButton)
    F.Reskin(_G.TabardFrameCancelButton)
end
