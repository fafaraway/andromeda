local _, private = ...

-- [[ Core ]]
local Aurora = private.Aurora
local F, C = _G.unpack(Aurora)
local Base, Hook, Skin = Aurora.Base, Aurora.Hook, Aurora.Skin

do --[[ FrameXML\ItemButtonTemplate.lua ]]
    local size = 6
    local vertexOffsets = {
        {"TOPLEFT", 4, -size},
        {"BOTTOMLEFT", 3, -size},
        {"TOPRIGHT", 2, size},
        {"BOTTOMRIGHT", 1, size},
    }
    local function SetRelic(button, isRelic, color)
        if isRelic then
            if not button._auroraRelicTex then
                local relic = _G.CreateFrame("Frame", nil, button)
                relic:SetAllPoints(button._auroraIconBorder)

                for i = 1, 4 do
                    local tex = relic:CreateTexture(nil, "OVERLAY")
                    tex:SetSize(size, size)

                    local vertexInfo = vertexOffsets[i]
                    tex:SetPoint(vertexInfo[1])
                    tex:SetVertexOffset(vertexInfo[2], vertexInfo[3], 0)
                    relic[i] = tex
                end

                button._auroraRelicTex = relic
            end

            for i = 1, #button._auroraRelicTex do
                local tex = button._auroraRelicTex[i]
                tex:SetColorTexture(color.r, color.g, color.b)
            end
            button._auroraRelicTex:Show()
        elseif button._auroraRelicTex then
            button._auroraRelicTex:Hide()
        end
    end
    function Hook.SetItemButtonQuality(button, quality, itemIDOrLink)
        if button._auroraIconBorder then
            local isRelic = (itemIDOrLink and _G.IsArtifactRelicItem(itemIDOrLink))

            if quality then
                local color = _G.type(quality) == "table" and quality or _G.BAG_ITEM_QUALITY_COLORS[quality]
                if color and color == quality or quality >= _G.LE_ITEM_QUALITY_COMMON then
                    SetRelic(button, isRelic, color)
                    button._auroraIconBorder:SetBackdropBorderColor(color.r, color.g, color.b)
                    button.IconBorder:Hide()
                else
                    SetRelic(button, false)
                    button._auroraIconBorder:SetBackdropBorderColor(0, 0, 0)
                end
            else
                SetRelic(button, false)
                button._auroraIconBorder:SetBackdropBorderColor(0, 0, 0)
            end
        end
    end
end

do --[[ FrameXML\ItemButtonTemplate.xml ]]
    function Skin.ItemButtonTemplate(button)
        button:SetNormalTexture("")
        button:SetHighlightTexture("")
        button:SetPushedTexture("")
        button._auroraIconBorder = F.ReskinIcon(button.icon)
    end
    function Skin.SimplePopupButtonTemplate(checkbutton)
        _G.select(2, checkbutton:GetRegions()):Hide()
    end
    function Skin.PopupButtonTemplate(checkbutton)
        Skin.SimplePopupButtonTemplate(checkbutton)
        Base.CropIcon(_G[checkbutton:GetName().."Icon"], checkbutton)
        checkbutton:SetCheckedTexture(C.media.checked)
    end
    function Skin.LargeItemButtonTemplate(button)
        local icon = button.Icon
        button._auroraIconBorder = F.ReskinIcon(icon)

        local nameFrame = button.NameFrame
        nameFrame:SetAlpha(0)

        local bg = _G.CreateFrame("Frame", nil, button)
        bg:SetPoint("TOPLEFT", icon, "TOPRIGHT", 2, 1)
        bg:SetPoint("BOTTOMRIGHT", -3, 1)
        Base.SetBackdrop(bg, Aurora.frameColor:GetRGBA())
        button._auroraNameBG = bg
    end
    function Skin.SmallItemButtonTemplate(button)
        local icon = button.Icon
        icon:SetSize(29, 29)
        button._auroraIconBorder = F.ReskinIcon(icon)

        local nameFrame = button.NameFrame
        nameFrame:SetAlpha(0)

        local bg = _G.CreateFrame("Frame", nil, button)
        bg:SetPoint("TOPLEFT", icon, "TOPRIGHT", 2, 1)
        bg:SetPoint("BOTTOMRIGHT", nameFrame, 0, 0)
        Base.SetBackdrop(bg, Aurora.frameColor:GetRGBA())
        button._auroraNameBG = bg
    end
end

function private.FrameXML.ItemButtonTemplate()
    _G.hooksecurefunc("SetItemButtonQuality", Hook.SetItemButtonQuality)
end
