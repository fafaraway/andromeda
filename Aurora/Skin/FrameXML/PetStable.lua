local _, private = ...

local Aurora = private.Aurora
local F, C = _G.unpack(Aurora)
local Hook, Skin = Aurora.Hook, Aurora.Skin

do --[[ FrameXML\PetStable.lua ]]
    function Hook.PetStable_SetSelectedPetInfo(icon, name, level, family, talent)
        if family then
            _G.PetStableTypeText:SetText(family)
        else
            _G.PetStableTypeText:SetText("")
        end
    end
end

do --[[ FrameXML\PetStable.xml ]]
    function Skin.PetStableSlotTemplate(slot)
        local slotName = slot:GetName()

        _G[slotName.."IconTexture"]:SetTexCoord(.08, .92, .08, .92)
        slot.Background:SetColorTexture(0, 0, 0, 1)
        slot.Background:SetPoint("TOPLEFT", slot, -1, 1)
        slot.Background:SetPoint("BOTTOMRIGHT", slot, 1, -1)
        slot.Checked:SetTexture(C.media.checked)
    end
    function Skin.PetStableActiveSlotTemplate(slot)
        Skin.PetStableSlotTemplate(slot)

        slot.Border:Hide()
        slot.PetName:SetPoint("BOTTOMLEFT", slot, "TOPLEFT", -16, 5)
        slot.PetName:SetPoint("BOTTOMRIGHT", slot, "TOPRIGHT", 16, 5)
    end
end

function private.FrameXML.PetStable()
    _G.hooksecurefunc("PetStable_SetSelectedPetInfo", Hook.PetStable_SetSelectedPetInfo)

    local PetStableFrame = _G.PetStableFrame
    Skin.ButtonFrameTemplate(PetStableFrame)
    F.CreateBD(PetStableFrame.Inset, 0.2)

    _G.PetStableFrameModelBg:SetAtlas("GarrFollower-Shadow")
    _G.PetStableFrameModelBg:SetPoint("TOPLEFT", PetStableFrame.Inset, 0, -160)
    _G.PetStableFrameModelBg:SetPoint("BOTTOMRIGHT", PetStableFrame.Inset, 0, 0)
    _G.PetStableFrameModelBg:SetTexCoord(0.2, 0.8, 0, 0.8)

    Skin.InsetFrameTemplate(PetStableFrame.LeftInset)
    PetStableFrame.LeftInset:SetPoint("TOPLEFT", 0, -private.FRAME_TITLE_HEIGHT)
    PetStableFrame.LeftInset:SetPoint("BOTTOMRIGHT", PetStableFrame, "BOTTOMLEFT", 91, 0)
    _G.PetStableActiveBg:Hide()

    Skin.InsetFrameTemplate(PetStableFrame.BottomInset)
    _G.PetStableFrameStableBg:Hide()

    _G.PetStableModel:SetPoint("TOPLEFT", PetStableFrame.Inset)
    _G.PetStableModel:SetPoint("BOTTOMRIGHT", PetStableFrame.Inset)
    _G.PetStableModelRotateLeftButton:Hide()
    _G.PetStableModelRotateRightButton:Hide()
    _G.PetStableModelShadow:Hide()

    _G.PetStablePetInfo:SetPoint("TOPLEFT", PetStableFrame.Inset)
    _G.PetStablePetInfo:SetPoint("BOTTOMRIGHT", PetStableFrame.Inset, "TOPRIGHT", 0, -52)

    _G.PetStableSelectedPetIcon:SetPoint("TOPLEFT", 6, -6)
    _G.PetStableSelectedPetIcon:SetTexCoord(.08, .92, .08, .92)
    F.CreateBG(_G.PetStableSelectedPetIcon)

    _G.PetStableNameText:SetFontObject("GameFontNormalHuge2")
    _G.PetStableNameText:SetPoint("TOPLEFT", _G.PetStableSelectedPetIcon, "TOPRIGHT", 2, 0)
    _G.PetStableLevelText:SetPoint("BOTTOMLEFT", _G.PetStableSelectedPetIcon, "BOTTOMRIGHT", 2, 0)
    _G.PetStableTypeText:SetPoint("BOTTOMRIGHT", -6, 6)

    _G.PetStableDiet:SetSize(20, 20)
    _G.PetStableDiet:SetPoint("TOPRIGHT", -6, -6)

    _G.PetStableDietTexture:SetTexture([[Interface\Icons\Ability_Hunter_BeastTraining]])
    _G.PetStableDietTexture:SetDrawLayer("ARTWORK")
    _G.PetStableDietTexture:SetAllPoints()
    _G.PetStableDietTexture:SetTexCoord(.08, .92, .08, .92)
    F.CreateBG(_G.PetStableDietTexture)

    for i = 1, _G.NUM_PET_ACTIVE_SLOTS do
        local slot = _G["PetStableActivePet"..i]
        Skin.PetStableActiveSlotTemplate(slot)
        if i > 1 then
            slot:SetPoint("TOPLEFT", _G["PetStableActivePet"..(i - 1)], "BOTTOMLEFT", 0, -35)
        end
    end

    for i = 1, _G.NUM_PET_STABLE_SLOTS do
        Skin.PetStableSlotTemplate(_G["PetStableStabledPet"..i])
    end

    Skin.UIPanelSquareButton(_G.PetStableNextPageButton)
    Skin.UIPanelSquareButton(_G.PetStablePrevPageButton)
end
