local _, private = ...

-- [[ Lua Globals ]]
local select = _G.select

-- [[ Core ]]
local F, C = _G.unpack(private.Aurora)

function private.AddOns.Blizzard_MacroUI()
    select(18, _G.MacroFrame:GetRegions()):Hide()
    _G.MacroHorizontalBarLeft:Hide()
    select(21, _G.MacroFrame:GetRegions()):Hide()

    for i = 1, 6 do
        select(i, _G.MacroFrameTab1:GetRegions()):Hide()
        select(i, _G.MacroFrameTab2:GetRegions()):Hide()
        select(i, _G.MacroFrameTab1:GetRegions()).Show = F.dummy
        select(i, _G.MacroFrameTab2:GetRegions()).Show = F.dummy
    end
    _G.MacroFrameTextBackground:SetBackdrop(nil)
    select(2, _G.MacroFrameSelectedMacroButton:GetRegions()):Hide()
    _G.MacroFrameSelectedMacroBackground:SetAlpha(0)
    _G.MacroButtonScrollFrameTop:Hide()
    _G.MacroButtonScrollFrameMiddle:Hide()
    _G.MacroButtonScrollFrameBottom:Hide()

    _G.MacroFrameSelectedMacroButton:SetPoint("TOPLEFT", _G.MacroFrameSelectedMacroBackground, "TOPLEFT", 12, -16)
    _G.MacroFrameSelectedMacroButtonIcon:SetPoint("TOPLEFT", 1, -1)
    _G.MacroFrameSelectedMacroButtonIcon:SetPoint("BOTTOMRIGHT", -1, 1)
    _G.MacroFrameSelectedMacroButtonIcon:SetTexCoord(.08, .92, .08, .92)


    _G.MacroNewButton:ClearAllPoints()
    _G.MacroNewButton:SetPoint("RIGHT", _G.MacroExitButton, "LEFT", -1, 0)

    for i = 1, _G.MAX_ACCOUNT_MACROS do
        local bu = _G["MacroButton"..i]
        local ic = _G["MacroButton"..i.."Icon"]
        local na = _G["MacroButton"..i.."Name"]

        na:SetFont("Interface\\AddOns\\FreeUI\\Media\\pixel.ttf", 8, "OUTLINEMONOCHROME")

        bu:SetCheckedTexture(C.media.checked)
        select(2, bu:GetRegions()):Hide()

        ic:SetPoint("TOPLEFT", 1, -1)
        ic:SetPoint("BOTTOMRIGHT", -1, 1)
        ic:SetTexCoord(.08, .92, .08, .92)

        F.CreateBD(bu, .25)
    end

    F.ReskinPortraitFrame(_G.MacroFrame, true)
    F.CreateBD(_G.MacroFrame)
    F.CreateSD(_G.MacroFrame)
    F.CreateBD(_G.MacroFrameScrollFrame, .25)
    F.CreateBD(_G.MacroFrameSelectedMacroButton, .25)
    F.Reskin(_G.MacroDeleteButton)
    F.Reskin(_G.MacroNewButton)
    F.Reskin(_G.MacroExitButton)
    F.Reskin(_G.MacroEditButton)
    F.Reskin(_G.MacroSaveButton)
    F.Reskin(_G.MacroCancelButton)
    F.ReskinScroll(_G.MacroButtonScrollFrameScrollBar)
    F.ReskinScroll(_G.MacroFrameScrollFrameScrollBar)


    local MacroPopupFrame = _G.MacroPopupFrame
    MacroPopupFrame:SetPoint("TOPLEFT", _G.MacroFrame, "TOPRIGHT", 3, -30)
    MacroPopupFrame:SetHeight(520)
    F.CreateBD(MacroPopupFrame)
    MacroPopupFrame.BG:Hide()
    for i = 1, 8 do
        select(i, MacroPopupFrame.BorderBox:GetRegions()):Hide()
    end

    _G.MacroPopupNameLeft:Hide()
    _G.MacroPopupNameMiddle:Hide()
    _G.MacroPopupNameRight:Hide()
    F.CreateBD(_G.MacroPopupEditBox, .25)
    F.Reskin(_G.MacroPopupCancelButton)
    F.Reskin(_G.MacroPopupOkayButton)

    _G.MacroPopupScrollFrameTop:Hide()
    _G.MacroPopupScrollFrameMiddle:Hide()
    _G.MacroPopupScrollFrameBottom:Hide()
    F.ReskinScroll(_G.MacroPopupScrollFrameScrollBar)
    _G.MacroPopupScrollFrame:SetHeight(400)
end
