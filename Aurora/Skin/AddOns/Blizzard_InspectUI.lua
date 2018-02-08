local _, private = ...

-- [[ Lua Globals ]]
local select = _G.select

-- [[ Core ]]
local F, C = _G.unpack(private.Aurora)

function private.AddOns.Blizzard_InspectUI()
    _G.InspectModelFrame:DisableDrawLayer("OVERLAY")

    _G.InspectTalentFrame:GetRegions():Hide()
    select(2, _G.InspectTalentFrame:GetRegions()):Hide()
    _G.InspectGuildFrameBG:Hide()
    for i = 1, 5 do
        select(i, _G.InspectModelFrame:GetRegions()):Hide()
    end
    F.Reskin(_G.InspectPaperDollFrame.ViewButton)

    -- Character

    select(10, _G.InspectMainHandSlot:GetRegions()):Hide()

    local slots = {
        "Head", "Neck", "Shoulder", "Shirt", "Chest", "Waist", "Legs", "Feet", "Wrist",
        "Hands", "Finger0", "Finger1", "Trinket0", "Trinket1", "Back", "MainHand",
        "SecondaryHand", "Tabard",
    }

    for i = 1, #slots do
        local slot = _G["Inspect"..slots[i].."Slot"]
        local border = slot.IconBorder

        _G["Inspect"..slots[i].."SlotFrame"]:Hide()

        slot:SetNormalTexture("")
        slot:SetPushedTexture("")

        border:SetPoint("TOPLEFT", -1, 1)
        border:SetPoint("BOTTOMRIGHT", 1, -1)
        border:SetDrawLayer("BACKGROUND")

        slot.icon:SetTexCoord(.08, .92, .08, .92)
    end

    _G.hooksecurefunc("InspectPaperDollItemSlotButton_Update", function(button)
        button.IconBorder:SetTexture(C.media.backdrop)
        button.icon:SetShown(button.hasItem)
    end)

    -- PvP

    _G.InspectPVPFrame.BG:Hide()

    for tier = 1, _G.MAX_PVP_TALENT_TIERS do
        for column = 1, _G.MAX_PVP_TALENT_COLUMNS do
            local bu = _G.InspectPVPFrame.Talents["Tier"..tier]["Talent"..column]

            bu.Slot:Hide()
            bu.border:SetTexture("")

            bu.Icon:SetDrawLayer("ARTWORK")
            bu.Icon:SetTexCoord(.08, .92, .08, .92)

            F.CreateBG(bu.Icon)
        end
    end

    -- Talents

    local inspectSpec = _G.InspectTalentFrame.InspectSpec

    inspectSpec.ring:Hide()

    for i = 1, 7 do
        local row = _G.InspectTalentFrame.InspectTalents["tier"..i]
        for j = 1, 3 do
            local bu = row["talent"..j]

            bu.Slot:Hide()
            bu.border:SetTexture("")

            bu.icon:SetDrawLayer("ARTWORK")
            bu.icon:SetTexCoord(.08, .92, .08, .92)

            F.CreateBG(bu.icon)
        end
    end

    inspectSpec.specIcon:SetTexCoord(.08, .92, .08, .92)
    F.CreateBG(inspectSpec.specIcon)

    local function updateIcon(self)
        local spec = nil
        if _G.INSPECTED_UNIT ~= nil then
            spec = _G.GetInspectSpecialization(_G.INSPECTED_UNIT)
        end
        if spec ~= nil and spec > 0 then
            local role1 = _G.GetSpecializationRoleByID(spec)
            if role1 ~= nil then
                local _, _, _, icon = _G.GetSpecializationInfoByID(spec)
                self.specIcon:SetTexture(icon)
            end
        end
    end

    inspectSpec:HookScript("OnShow", updateIcon)
    _G.InspectTalentFrame:HookScript("OnEvent", function(self, event, unit)
        if not _G.InspectFrame:IsShown() then return end
        if event == "INSPECT_READY" and _G.InspectFrame.unit and _G.UnitGUID(_G.InspectFrame.unit) == unit then
            updateIcon(self.InspectSpec)
        end
    end)

    local roleIcon = inspectSpec.roleIcon

    roleIcon:SetTexture(C.media.roleIcons)

    do
        local left = inspectSpec:CreateTexture(nil, "OVERLAY")
        left:SetWidth(1)
        left:SetTexture(C.media.backdrop)
        left:SetVertexColor(0, 0, 0)
        left:SetPoint("TOPLEFT", roleIcon, 2, -2)
        left:SetPoint("BOTTOMLEFT", roleIcon, 2, 2)

        local right = inspectSpec:CreateTexture(nil, "OVERLAY")
        right:SetWidth(1)
        right:SetTexture(C.media.backdrop)
        right:SetVertexColor(0, 0, 0)
        right:SetPoint("TOPRIGHT", roleIcon, -2, -2)
        right:SetPoint("BOTTOMRIGHT", roleIcon, -2, 2)

        local top = inspectSpec:CreateTexture(nil, "OVERLAY")
        top:SetHeight(1)
        top:SetTexture(C.media.backdrop)
        top:SetVertexColor(0, 0, 0)
        top:SetPoint("TOPLEFT", roleIcon, 2, -2)
        top:SetPoint("TOPRIGHT", roleIcon, -2, -2)

        local bottom = inspectSpec:CreateTexture(nil, "OVERLAY")
        bottom:SetHeight(1)
        bottom:SetTexture(C.media.backdrop)
        bottom:SetVertexColor(0, 0, 0)
        bottom:SetPoint("BOTTOMLEFT", roleIcon, 2, 2)
        bottom:SetPoint("BOTTOMRIGHT", roleIcon, -2, 2)
    end

    for i = 1, 4 do
        local tab = _G["InspectFrameTab"..i]
        F.ReskinTab(tab)
        if i ~= 1 then
            tab:SetPoint("LEFT", _G["InspectFrameTab"..i-1], "RIGHT", -15, 0)
        end
    end

    F.ReskinPortraitFrame(_G.InspectFrame, true)
    F.CreateBD(_G.InspectFrame)
    F.CreateSD(_G.InspectFrame)
end
