local _, private = ...

-- [[ Lua Globals ]]
local select = _G.select

-- [[ Core ]]
local F = _G.unpack(private.Aurora)
local Skin = private.Aurora.Skin

function private.FrameXML.DressUpFrames()
    -- SideDressUp
    for i = 1, 4 do
        select(i, _G.SideDressUpFrame:GetRegions()):Hide()
    end
    select(5, _G.SideDressUpModelCloseButton:GetRegions()):Hide()

    _G.SideDressUpModel:HookScript("OnShow", function(self)
        self:ClearAllPoints()
        self:SetPoint("LEFT", self:GetParent():GetParent(), "RIGHT", 1, 0)
    end)

    F.Reskin(_G.SideDressUpModelResetButton)
    F.ReskinClose(_G.SideDressUpModelCloseButton)

    _G.SideDressUpModel.bg = _G.CreateFrame("Frame", nil, _G.SideDressUpModel)
    _G.SideDressUpModel.bg:SetPoint("TOPLEFT", 0, 1)
    _G.SideDressUpModel.bg:SetPoint("BOTTOMRIGHT", 1, -1)
    _G.SideDressUpModel.bg:SetFrameLevel(_G.SideDressUpModel:GetFrameLevel()-1)
    F.CreateBD(_G.SideDressUpModel.bg)


    -- Dressup Frame
    local DressUpFrame = _G.DressUpFrame
    F.ReskinPortraitFrame(DressUpFrame, true)
    F.CreateBD(_G.DressUpFrame)
    F.CreateSD(_G.DressUpFrame)

    F.ReskinDropDown(_G.DressUpFrameOutfitDropDown)
    F.Reskin(_G.DressUpFrameOutfitDropDown.SaveButton)

    Skin.MaximizeMinimizeButtonFrameTemplate(DressUpFrame.MaxMinButtonFrame)
    DressUpFrame.MaxMinButtonFrame:ClearAllPoints()
    DressUpFrame.MaxMinButtonFrame:SetPoint("TOPRIGHT", DressUpFrame.CloseButton, "TOPLEFT", -1, 0)
    DressUpFrame.MaxMinButtonFrame:GetRegions():Hide()

    F.Reskin(_G.DressUpFrameCancelButton)
    F.Reskin(_G.DressUpFrameResetButton)
    _G.DressUpFrameResetButton:SetPoint("RIGHT", _G.DressUpFrameCancelButton, "LEFT", -1, 0)

    DressUpFrame.ModelBackground:SetDrawLayer("BACKGROUND", 3)
    DressUpFrame.ModelBackground:ClearAllPoints()
    DressUpFrame.ModelBackground:SetPoint("TOPLEFT")
    DressUpFrame.ModelBackground:SetPoint("BOTTOMRIGHT")
    DressUpFrame.ModelBackground:SetAlpha(.2)
end
