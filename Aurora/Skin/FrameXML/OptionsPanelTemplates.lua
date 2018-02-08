local _, private = ...

-- [[ Core ]]
local Aurora = private.Aurora
local Base, Skin = Aurora.Base, Aurora.Skin

do --[[ FrameXML\OptionsPanelTemplates.xml ]]
    function Skin.OptionsButtonTemplate(button)
        Skin.UIPanelButtonTemplate(button)
    end
    function Skin.OptionsBaseCheckButtonTemplate(checkbutton)
        checkbutton:SetSize(18, 18)

        checkbutton:SetNormalTexture("")
        checkbutton:SetPushedTexture("")
        checkbutton:SetHighlightTexture("")

        local check = checkbutton:GetCheckedTexture()
        check:ClearAllPoints()
        check:SetPoint("TOPLEFT", -7, 7)
        check:SetPoint("BOTTOMRIGHT", 7, -7)
        check:SetDesaturated(true)
        check:SetVertexColor(Aurora.highlightColor:GetRGB())

        local disabled = checkbutton:GetDisabledCheckedTexture()
        disabled:ClearAllPoints()
        disabled:SetPoint("TOPLEFT", -7, 7)
        disabled:SetPoint("BOTTOMRIGHT", 7, -7)

        Base.SetBackdrop(checkbutton, Aurora.frameColor:GetRGBA())
        Base.SetHighlight(checkbutton, "backdrop")
    end

    function Skin.OptionsCheckButtonTemplate(checkbutton)
        Skin.OptionsBaseCheckButtonTemplate(checkbutton)
        local name = checkbutton:GetName()
        _G[name.."Text"]:SetPoint("LEFT", checkbutton, "RIGHT", 3, 0)
    end
    function Skin.OptionsSmallCheckButtonTemplate(checkbutton)
        Skin.OptionsBaseCheckButtonTemplate(checkbutton)
        local name = checkbutton:GetName()
        _G[name.."Text"]:SetPoint("LEFT", checkbutton, "RIGHT", 3, 0)
    end
    function Skin.OptionsSliderTemplate(slider)
        if private.isPatch then
            Skin.HorizontalSliderTemplate(slider)
        else
            slider:SetBackdrop(nil)

            local bg = _G.CreateFrame("Frame", nil, slider)
            bg:SetPoint("TOPLEFT", slider, 5, -5)
            bg:SetPoint("BOTTOMRIGHT", slider, -5, 5)
            bg:SetFrameLevel(slider:GetFrameLevel())
            Base.SetBackdrop(bg, Aurora.frameColor:GetRGBA())

            local thumbTexture = slider:GetThumbTexture()
            thumbTexture:SetAlpha(0)
            thumbTexture:SetSize(8, 16)

            local thumb = _G.CreateFrame("Frame", nil, bg)
            thumb:SetPoint("TOPLEFT", thumbTexture, 0, 0)
            thumb:SetPoint("BOTTOMRIGHT", thumbTexture, 0, 0)
            Base.SetBackdrop(thumb, Aurora.buttonColor:GetRGBA())
            slider._auroraThumb = thumb
        end
    end
end

function private.FrameXML.OptionsPanelTemplates()
    --[[
    ]]
end
