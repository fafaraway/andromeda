local _, private = ...

-- [[ Core ]]
local Aurora = private.Aurora
local Base, Hook, Skin = Aurora.Base, Aurora.Hook, Aurora.Skin

do --[[ FrameXML\ContainerFrame.lua ]]
    local BAG_FILTER_ICONS = {
        ["bags-icon-equipment"] = [[Interface\Icons\INV_Chest_Chain]],
        ["bags-icon-consumables"] = [[Interface\Icons\INV_Potion_93]],
        ["bags-icon-tradegoods"] = [[Interface\Icons\INV_Fabric_Silk_02]],
    }
    function Hook.ContainerFrameFilterIcon_SetAtlas(self, atlas)
        self:SetTexture(BAG_FILTER_ICONS[atlas])
    end
    function Hook.ContainerFrame_GenerateFrame(frame, size, id)
        local color
        if id > _G.NUM_BAG_FRAMES then
            -- bank bags
            color = Aurora.buttonColor
        else
            color = Aurora.frameColor
        end

        frame._auroraBDFrame:SetBackdropColor(color.r, color.g, color.b)
    end
    function Hook.ContainerFrame_Update(frame)
        local id = frame:GetID()
        local name = frame:GetName()

        if id == 0 then
            _G.BagItemSearchBox:ClearAllPoints()
            _G.BagItemSearchBox:SetPoint("TOPLEFT", frame, 20, -35)
            _G.BagItemAutoSortButton:ClearAllPoints()
            _G.BagItemAutoSortButton:SetPoint("TOPRIGHT", frame, -16, -31)
        end

        for i = 1, frame.size do
            local itemButton = _G[name.."Item"..i]
            if not itemButton._auroraIconBorder then
                local container = itemButton:GetParent():GetID()
                local buttonID = itemButton:GetID()

                Skin.ContainerFrameItemButtonTemplate(itemButton)

                local _, _, _, quality, _, _, _, _, _, itemID = _G.GetContainerItemInfo(container, buttonID)
                Hook.SetItemButtonQuality(itemButton, quality, itemID)
            end

            local questTexture = _G[name.."Item"..i.."IconQuestTexture"]
            if questTexture:IsShown() then
                itemButton._auroraIconBorder:SetBackdropBorderColor(1, 1, 0)
            end
        end
    end
end

do --[[ FrameXML\ContainerFrame.xml ]]
    function Skin.ContainerFrameItemButtonTemplate(button)
        local name = button:GetName()

        Skin.ItemButtonTemplate(button)
        Base.CropIcon(_G[name.."IconQuestTexture"])
    end

    function Skin.ContainerFrameTemplate(frame)
        _G.hooksecurefunc(frame.FilterIcon.Icon, "SetAtlas", Hook.ContainerFrameFilterIcon_SetAtlas)
        _G.hooksecurefunc("ContainerFrame_GenerateFrame", Hook.ContainerFrame_GenerateFrame)

        local name = frame:GetName()

        frame.Portrait:Hide()
        _G[name.."BackgroundTop"]:SetAlpha(0)
        _G[name.."BackgroundMiddle1"]:SetAlpha(0)
        _G[name.."BackgroundMiddle2"]:SetAlpha(0)
        _G[name.."BackgroundBottom"]:SetAlpha(0)
        _G[name.."Background1Slot"]:SetAlpha(0)

        local nameText = _G[name.."Name"]
        nameText:ClearAllPoints()
        nameText:SetPoint("TOPLEFT", frame.ClickableTitleFrame, 19, 0)
        nameText:SetPoint("BOTTOMRIGHT", frame.ClickableTitleFrame, -19, 0)

        local bdFrame = _G.CreateFrame("Frame", nil, frame)
        bdFrame:SetPoint("TOPLEFT", 11, -4)
        bdFrame:SetPoint("BOTTOMRIGHT", -6, 3)
        bdFrame:SetFrameLevel(frame:GetFrameLevel())
        Base.SetBackdrop(bdFrame)
        frame._auroraBDFrame = bdFrame

        local moneyFrame = _G[name.."MoneyFrame"]
        local moneyBG = _G.CreateFrame("Frame", nil, _G[name.."MoneyFrame"])
        Base.SetBackdrop(moneyBG, Aurora.frameColor:GetRGBA())
        moneyBG:SetBackdropBorderColor(1, 0.95, 0.15)
        moneyBG:SetPoint("TOP", moneyFrame, 0, 2)
        moneyBG:SetPoint("BOTTOM", moneyFrame, 0, -2)
        moneyBG:SetPoint("LEFT", bdFrame, 3, 0)
        moneyBG:SetPoint("RIGHT", bdFrame, -3, 0)

        frame.PortraitButton:Hide()
        frame.FilterIcon:ClearAllPoints()
        frame.FilterIcon:SetPoint("TOPLEFT", bdFrame, 3, -3)
        frame.FilterIcon:SetSize(17, 17)
        frame.FilterIcon.Icon:SetAllPoints()

        Base.CropIcon(frame.FilterIcon.Icon, frame.FilterIcon)

        Skin.UIPanelCloseButton(_G[name.."CloseButton"])
        _G[name.."CloseButton"]:SetPoint("TOPRIGHT", bdFrame, -3, -3)

        frame.ClickableTitleFrame:ClearAllPoints()
        frame.ClickableTitleFrame:SetPoint("TOPLEFT", bdFrame)
        frame.ClickableTitleFrame:SetPoint("BOTTOMRIGHT", bdFrame, "TOPRIGHT", 0, -private.FRAME_TITLE_HEIGHT)
    end
end

function private.FrameXML.ContainerFrame()
    if private.disabled.bags then return end
    _G.hooksecurefunc("ContainerFrame_Update", Hook.ContainerFrame_Update)


    Skin.GlowBoxTemplate(_G.ArtifactRelicHelpBox)
    Skin.UIPanelCloseButton(_G.ArtifactRelicHelpBox.CloseButton)
    _G.ArtifactRelicHelpBox.CloseButton:SetPoint("TOPRIGHT", -4, -4)

    Skin.GlowBoxArrowTemplate(_G.ArtifactRelicHelpBox.Arrow, "Right")
    _G.ArtifactRelicHelpBox.Arrow:SetPoint("LEFT", _G.ArtifactRelicHelpBox, "RIGHT")

    for i = 1, 12 do
        Skin.ContainerFrameTemplate(_G["ContainerFrame"..i])
    end

    Skin.BagSearchBoxTemplate(_G.BagItemSearchBox)
    _G.BagItemSearchBox:SetWidth(120)

    local autoSort = _G.BagItemAutoSortButton
    autoSort:SetSize(26, 26)
    autoSort:SetNormalTexture([[Interface\Icons\INV_Pet_Broom]])
    autoSort:GetNormalTexture():SetTexCoord(.13, .92, .13, .92)

    autoSort:SetPushedTexture([[Interface\Icons\INV_Pet_Broom]])
    autoSort:GetPushedTexture():SetTexCoord(.08, .87, .08, .87)

    local iconBorder = autoSort:CreateTexture(nil, "BACKGROUND")
    iconBorder:SetPoint("TOPLEFT", autoSort, -1, 1)
    iconBorder:SetPoint("BOTTOMRIGHT", autoSort, 1, -1)
    iconBorder:SetColorTexture(0, 0, 0)
end
