local _, private = ...

-- [[ Core ]]
local Aurora = private.Aurora
local Base, Skin = Aurora.Base, Aurora.Skin

do --[[ FrameXML\UIPanelTemplates.xml ]]
    function Skin.SearchBoxTemplate(editbox)
        Skin.InputBoxInstructionsTemplate(editbox)
    end
    function Skin.BagSearchBoxTemplate(editbox)
        Skin.SearchBoxTemplate(editbox)
    end
    function Skin.UIPanelInfoButton(button)
        button:SetSize(16, 16)
        button.texture:SetTexture([[Interface\Common\help-i]])
        button.texture:SetTexCoord(0.234375, 0.765625, 0.234375, 0.765625)
        button.texture:SetSize(16, 16)

        local highlight = button:GetHighlightTexture()
        highlight:SetTexture([[Interface\Common\help-i]])
        highlight:SetTexCoord(0.234375, 0.765625, 0.234375, 0.765625)
        highlight:SetSize(16, 16)
    end
    function Skin.UIPanelSquareButton(button)
        button:SetSize(19.5, 19.5)
        button:SetNormalTexture("")
        button:SetHighlightTexture("")
        button:SetPushedTexture("")
        Base.SetBackdrop(button, Aurora.buttonColor:GetRGBA())
    end
    function Skin.UIPanelLargeSilverButton(button)
        local buttonName = button:GetName()
        _G[buttonName.."Left"]:Hide()
        _G[buttonName.."Right"]:Hide()
        _G[buttonName.."Middle"]:Hide()
        for i = 3, 6 do
            _G.select(i, button:GetRegions()):Hide()
        end
        Base.SetBackdrop(button, Aurora.buttonColor:GetRGBA())
        Base.SetHighlight(button, "backdrop")
    end
    function Skin.GlowBoxTemplate(frame)
        frame.BG:Hide()

        frame.GlowTopLeft:Hide()
        frame.GlowTopRight:Hide()
        frame.GlowBottomLeft:Hide()
        frame.GlowBottomRight:Hide()

        frame.GlowTop:Hide()
        frame.GlowBottom:Hide()
        frame.GlowLeft:Hide()
        frame.GlowRight:Hide()

        frame.ShadowTopLeft:Hide()
        frame.ShadowTopRight:Hide()
        frame.ShadowBottomLeft:Hide()
        frame.ShadowBottomRight:Hide()

        frame.ShadowTop:Hide()
        frame.ShadowBottom:Hide()
        frame.ShadowLeft:Hide()
        frame.ShadowRight:Hide()
        Base.SetBackdrop(frame, 0.8, 0.8, 0, 0.75)
    end
    function Skin.GlowBoxArrowTemplate(frame, direction)
        if direction and direction == "Left" or direction == "Right" then
            frame:SetSize(21, 53)
        end
        Base.SetTexture(frame.Arrow, direction and "arrow"..direction or "arrowDown")
        frame.Arrow:SetVertexColor(1, 1, 0)
        frame.Glow:Hide()
    end
    function Skin.TranslucentFrameTemplate(frame)
        frame.Bg:Hide()

        frame.TopLeftCorner:Hide()
        frame.TopRightCorner:Hide()
        frame.BottomLeftCorner:Hide()
        frame.BottomRightCorner:Hide()

        frame.TopBorder:Hide()
        frame.BottomBorder:Hide()
        frame.LeftBorder:Hide()
        frame.RightBorder:Hide()
        Base.SetBackdrop(frame)
    end
    function Skin.ThinGoldEdgeTemplate(frame)
        local name = frame:GetName()
        _G[name.."Left"]:Hide()
        _G[name.."Right"]:Hide()
        _G[name.."Middle"]:Hide()

        Base.SetBackdrop(frame, Aurora.frameColor:GetRGBA())
        frame:SetBackdropBorderColor(1, 0.95, 0.15)
    end
end

function private.FrameXML.UIPanelTemplates()
end
