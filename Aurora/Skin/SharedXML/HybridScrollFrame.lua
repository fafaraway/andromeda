local _, private = ...

-- [[ Core ]]
local Aurora = private.Aurora
local Base, Hook, Skin = Aurora.Base, Aurora.Hook, Aurora.Skin

do --[[ SharedXML\HybridScrollFrame.lua ]]
    function Hook.HybridScrollFrame_CreateButtons(self, buttonTemplate, initialOffsetX, initialOffsetY, initialPoint, initialRelative, offsetX, offsetY, point, relativePoint)
        --print("Hook.HybridScrollFrame_CreateButtons", buttonTemplate)
        if Skin[buttonTemplate] then
            local numButtons = #self.buttons
            local numSkinned = self._auroraNumSkinned or 0

            for i = numSkinned + 1, numButtons do
                Skin[buttonTemplate](self.buttons[i])
            end
            self._auroraNumSkinned = numButtons
        end
    end
end

do --[[ SharedXML\HybridScrollFrame.xml ]]
    function Skin.HybridScrollBarTemplate(slider)
        local name = slider:GetName()

        local parent = slider:GetParent()
        slider:SetPoint("TOPLEFT", parent, "TOPRIGHT", 0, -17)
        slider:SetPoint("BOTTOMLEFT", parent, "BOTTOMRIGHT", 0, 17)

        slider.trackBG:SetAlpha(0)

        slider.ScrollBarTop:Hide()
        slider.ScrollBarMiddle:Hide()
        slider.ScrollBarBottom:Hide()

        local upButton = _G[name.."ScrollUpButton"]
        upButton:SetPoint("BOTTOM", slider, "TOP")
        Skin.UIPanelScrollUpButtonTemplate(upButton)

        local downButton = _G[name.."ScrollDownButton"]
        downButton:SetPoint("TOP", slider, "BOTTOM")
        Skin.UIPanelScrollDownButtonTemplate(downButton)

        slider.thumbTexture:SetAlpha(0)
        slider.thumbTexture:SetWidth(17)

        local thumb = _G.CreateFrame("Frame", nil, slider)
        thumb:SetPoint("TOPLEFT", slider.thumbTexture, 0, -2)
        thumb:SetPoint("BOTTOMRIGHT", slider.thumbTexture, 0, 2)
        Base.SetBackdrop(thumb, Aurora.buttonColor:GetRGBA())
        slider._auroraThumb = thumb
    end
    function Skin.HybridScrollBarTrimTemplate(slider)
        local parent = slider:GetParent()
        slider:SetPoint("TOPLEFT", parent, "TOPRIGHT", 0, -17)
        slider:SetPoint("BOTTOMLEFT", parent, "BOTTOMRIGHT", 0, 17)

        slider.trackBG:SetAlpha(0)

        slider.Top:Hide()
        slider.Bottom:Hide()
        slider.Middle:Hide()

        local upButton = slider.UpButton
        upButton:SetPoint("BOTTOM", slider, "TOP")
        Skin.UIPanelScrollUpButtonTemplate(upButton)

        local downButton = slider.DownButton
        downButton:SetPoint("TOP", slider, "BOTTOM")
        Skin.UIPanelScrollDownButtonTemplate(downButton)

        slider.thumbTexture:SetAlpha(0)
        slider.thumbTexture:SetWidth(17)

        local thumb = _G.CreateFrame("Frame", nil, slider)
        thumb:SetPoint("TOPLEFT", slider.thumbTexture, 0, -2)
        thumb:SetPoint("BOTTOMRIGHT", slider.thumbTexture, 0, 2)
        Base.SetBackdrop(thumb, Aurora.buttonColor:GetRGBA())
        slider._auroraThumb = thumb
    end
    function Skin.BasicHybridScrollFrameTemplate(scrollframe)
        local name = scrollframe:GetName()
        Skin.HybridScrollBarTemplate(_G[name.."ScrollBar"])
    end
end

function private.SharedXML.HybridScrollFrame()
    _G.hooksecurefunc("HybridScrollFrame_CreateButtons", Hook.HybridScrollFrame_CreateButtons)
end
