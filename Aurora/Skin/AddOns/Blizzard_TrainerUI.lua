local _, private = ...

-- [[ Lua Globals ]]
local next = _G.next

-- [[ WoW API ]]
local hooksecurefunc, CreateFrame = _G.hooksecurefunc, _G.CreateFrame

-- [[ Core ]]
local F, C = _G.unpack(private.Aurora)

function private.AddOns.Blizzard_TrainerUI()
    local r, g, b = C.r, C.g, C.b

    _G.ClassTrainerFrameBottomInset:DisableDrawLayer("BORDER")
    _G.ClassTrainerFrame.BG:Hide()
    _G.ClassTrainerFrameBottomInsetBg:Hide()
    _G.ClassTrainerFrameMoneyBg:SetAlpha(0)

    _G.ClassTrainerStatusBarSkillRank:ClearAllPoints()
    _G.ClassTrainerStatusBarSkillRank:SetPoint("CENTER", _G.ClassTrainerStatusBar, "CENTER", 0, 0)

    local skillBG = CreateFrame("Frame", nil, _G.ClassTrainerFrameSkillStepButton)
    skillBG:SetPoint("TOPLEFT", 42, -2)
    skillBG:SetPoint("BOTTOMRIGHT", 0, 2)
    skillBG:SetFrameLevel(_G.ClassTrainerFrameSkillStepButton:GetFrameLevel()-1)
    F.CreateBD(skillBG, .25)

    _G.ClassTrainerFrameSkillStepButton:SetNormalTexture("")
    _G.ClassTrainerFrameSkillStepButton:SetHighlightTexture("")
    _G.ClassTrainerFrameSkillStepButton.disabledBG:SetTexture("")

    _G.ClassTrainerFrameSkillStepButton.selectedTex:SetPoint("TOPLEFT", 43, -3)
    _G.ClassTrainerFrameSkillStepButton.selectedTex:SetPoint("BOTTOMRIGHT", -1, 3)
    _G.ClassTrainerFrameSkillStepButton.selectedTex:SetTexture(C.media.backdrop)
    _G.ClassTrainerFrameSkillStepButton.selectedTex:SetVertexColor(r, g, b, .2)

    local icbg = CreateFrame("Frame", nil, _G.ClassTrainerFrameSkillStepButton)
    icbg:SetPoint("TOPLEFT", _G.ClassTrainerFrameSkillStepButtonIcon, -1, 1)
    icbg:SetPoint("BOTTOMRIGHT", _G.ClassTrainerFrameSkillStepButtonIcon, 1, -1)
    F.CreateBD(icbg, 0)

    _G.ClassTrainerFrameSkillStepButtonIcon:SetTexCoord(.08, .92, .08, .92)

    hooksecurefunc("ClassTrainerFrame_Update", function()
        for _, bu in next, _G.ClassTrainerFrame.scrollFrame.buttons do
            if not bu.styled then
                local bg = CreateFrame("Frame", nil, bu)
                bg:SetPoint("TOPLEFT", 42, -6)
                bg:SetPoint("BOTTOMRIGHT", 0, 6)
                bg:SetFrameLevel(bu:GetFrameLevel()-1)
                F.CreateBD(bg, .25)

                bu.name:SetParent(bg)
                bu.name:SetPoint("TOPLEFT", bu.icon, "TOPRIGHT", 6, -2)
                bu.subText:SetParent(bg)
                bu.money:SetParent(bg)
                bu.money:SetPoint("TOPRIGHT", bu, "TOPRIGHT", 5, -8)
                bu:SetNormalTexture("")
                bu:SetHighlightTexture("")
                bu.disabledBG:Hide()
                bu.disabledBG.Show = F.dummy

                bu.selectedTex:SetPoint("TOPLEFT", 43, -6)
                bu.selectedTex:SetPoint("BOTTOMRIGHT", -1, 7)
                bu.selectedTex:SetTexture(C.media.backdrop)
                bu.selectedTex:SetVertexColor(r, g, b, .2)

                bu.icon:SetTexCoord(.08, .92, .08, .92)
                F.CreateBG(bu.icon)

                bu.styled = true
            end
        end
    end)

    _G.ClassTrainerStatusBarLeft:Hide()
    _G.ClassTrainerStatusBarMiddle:Hide()
    _G.ClassTrainerStatusBarRight:Hide()
    _G.ClassTrainerStatusBarBackground:Hide()
    _G.ClassTrainerStatusBar:SetPoint("TOPLEFT", _G.ClassTrainerFrame, "TOPLEFT", 64, -35)
    _G.ClassTrainerStatusBar:SetStatusBarTexture(C.media.backdrop)

    _G.ClassTrainerStatusBar:GetStatusBarTexture():SetGradient("VERTICAL", .1, .3, .9, .2, .4, 1)

    local bd = CreateFrame("Frame", nil, _G.ClassTrainerStatusBar)
    bd:SetPoint("TOPLEFT", -1, 1)
    bd:SetPoint("BOTTOMRIGHT", 1, -1)
    bd:SetFrameLevel(_G.ClassTrainerStatusBar:GetFrameLevel()-1)
    F.CreateBD(bd, .25)

    F.ReskinPortraitFrame(_G.ClassTrainerFrame, true)
    F.CreateBD(_G.ClassTrainerFrame)
    F.CreateSD(_G.ClassTrainerFrame)
    F.Reskin(_G.ClassTrainerTrainButton)
    F.ReskinScroll(_G.ClassTrainerScrollFrameScrollBar)
    F.ReskinDropDown(_G.ClassTrainerFrameFilterDropDown)
end
