local F, C = unpack(select(2, ...))

C.Themes['Blizzard_InspectUI'] = function()
    F.StripTextures(_G.InspectModelFrame, true)
    _G.InspectGuildFrameBG:Hide()
    F.ReskinButton(_G.InspectPaperDollFrame.ViewButton)
    _G.InspectPaperDollFrame.ViewButton:ClearAllPoints()
    _G.InspectPaperDollFrame.ViewButton:SetPoint('TOP', _G.InspectFrame, 0, -45)
    _G.InspectPVPFrame.BG:Hide()
    F.ReskinButton(_G.InspectPaperDollItemsFrame.InspectTalents)

    -- Character
    local slots = {
        'Head',
        'Neck',
        'Shoulder',
        'Shirt',
        'Chest',
        'Waist',
        'Legs',
        'Feet',
        'Wrist',
        'Hands',
        'Finger0',
        'Finger1',
        'Trinket0',
        'Trinket1',
        'Back',
        'MainHand',
        'SecondaryHand',
        'Tabard',
    }

    for i = 1, #slots do
        local slot = _G['Inspect' .. slots[i] .. 'Slot']
        F.StripTextures(slot)
        slot.icon:SetTexCoord(unpack(C.TEX_COORD))
        slot.icon:SetInside()
        slot.bg = F.CreateBDFrame(slot.icon, 0.25)
        slot:GetHighlightTexture():SetColorTexture(1, 1, 1, 0.25)
        F.ReskinIconBorder(slot.IconBorder)
        slot.IconOverlay:SetAtlas('CosmeticIconFrame')
        slot.IconOverlay:SetInside()
    end

    local function UpdateCosmetic(self)
        local unit = _G.InspectFrame.unit
        local itemLink = unit and GetInventoryItemLink(unit, self:GetID())
        self.IconOverlay:SetShown(itemLink and IsCosmeticItem(itemLink))
    end

    hooksecurefunc('InspectPaperDollItemSlotButton_Update', function(button)
        button.icon:SetShown(button.hasItem)
        UpdateCosmetic(button)
    end)

    for i = 1, 4 do
		local tab = _G["InspectFrameTab"..i]
		if tab then
			F.ReskinTab(tab)
			if i ~= 1 then
				tab:ClearAllPoints()
				tab:SetPoint("LEFT", _G["InspectFrameTab"..i-1], "RIGHT", -15, 0)
			end
		end
	end

    F.ReskinPortraitFrame(InspectFrame)

    _G.InspectFrameTab1:ClearAllPoints()
    _G.InspectFrameTab1:SetPoint('TOPLEFT', _G.InspectFrame, 'BOTTOMLEFT', 10, 1)
    for i = 1, 4 do
        local tab = _G['InspectFrameTab' .. i]
        if tab then
            F.ReskinTab(tab)
            if i ~= 1 then
                tab:SetPoint('LEFT', _G['InspectFrameTab' .. i - 1], 'RIGHT', -15, 0)
            end
        end
    end

    F.ReskinPortraitFrame(_G.InspectFrame)
end
