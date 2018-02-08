local _, private = ...

-- [[ Lua Globals ]]
local select, pairs = _G.select, _G.pairs

-- [[ WoW API ]]
local hooksecurefunc = _G.hooksecurefunc

-- [[ Core ]]
local F, C = _G.unpack(private.Aurora)

function private.AddOns.Blizzard_TalentUI()
    local r, g, b = C.r, C.g, C.b

    _G.PlayerTalentFrameTalents:DisableDrawLayer("BORDER")
    _G.PlayerTalentFrameTalentsBg:Hide()
    _G.PlayerTalentFrameActiveSpecTabHighlight:SetTexture("")
    _G.PlayerTalentFrameTitleGlowLeft:SetTexture("")
    _G.PlayerTalentFrameTitleGlowRight:SetTexture("")
    _G.PlayerTalentFrameTitleGlowCenter:SetTexture("")

    for i = 1, 6 do
        select(i, _G.PlayerTalentFrameSpecialization:GetRegions()):Hide()
    end

    select(7, _G.PlayerTalentFrameSpecialization:GetChildren()):DisableDrawLayer("OVERLAY")

    for i = 1, 5 do
        select(i, _G.PlayerTalentFrameSpecializationSpellScrollFrameScrollChild:GetRegions()):Hide()
    end

    _G.PlayerTalentFrameSpecializationSpellScrollFrameScrollChild.Seperator:SetColorTexture(1, 1, 1)
    _G.PlayerTalentFrameSpecializationSpellScrollFrameScrollChild.Seperator:SetAlpha(.2)

    if private.charClass.token == "HUNTER" then
        for i = 1, 6 do
            select(i, _G.PlayerTalentFramePetSpecialization:GetRegions()):Hide()
        end
        select(7, _G.PlayerTalentFramePetSpecialization:GetChildren()):DisableDrawLayer("OVERLAY")
        for i = 1, 5 do
            select(i, _G.PlayerTalentFramePetSpecializationSpellScrollFrameScrollChild:GetRegions()):Hide()
        end

        _G.PlayerTalentFramePetSpecializationSpellScrollFrameScrollChild.Seperator:SetColorTexture(1, 1, 1)
        _G.PlayerTalentFramePetSpecializationSpellScrollFrameScrollChild.Seperator:SetAlpha(.2)

        for i = 1, _G.GetNumSpecializations(false, true) do
            local _, _, _, icon = _G.GetSpecializationInfo(i, false, true)
            _G.PlayerTalentFramePetSpecialization["specButton"..i].specIcon:SetTexture(icon)
        end
    end

    hooksecurefunc("PlayerTalentFrame_UpdateTabs", function()
        for i = 1, _G.NUM_TALENT_FRAME_TABS do
            local tab = _G["PlayerTalentFrameTab"..i]
            local a1, p, a2, x = tab:GetPoint()

            tab:ClearAllPoints()
            tab:SetPoint(a1, p, a2, x, 2)
        end
    end)

    for i = 1, _G.NUM_TALENT_FRAME_TABS do
        F.ReskinTab(_G["PlayerTalentFrameTab"..i])
    end

    for _, frame in pairs({_G.PlayerTalentFrameSpecialization, _G.PlayerTalentFramePetSpecialization}) do
        local scrollChild = frame.spellsScroll.child

        scrollChild.ring:Hide()
        scrollChild.specIcon:SetTexCoord(.08, .92, .08, .92)
        F.CreateBG(scrollChild.specIcon)

        local roleIcon = scrollChild.roleIcon

        roleIcon:SetTexture(C.media.roleIcons)

        local left = scrollChild:CreateTexture(nil, "OVERLAY")
        left:SetWidth(1)
        left:SetTexture(C.media.backdrop)
        left:SetVertexColor(0, 0, 0)
        left:SetPoint("TOPLEFT", roleIcon, 3, -3)
        left:SetPoint("BOTTOMLEFT", roleIcon, 3, 4)

        local right = scrollChild:CreateTexture(nil, "OVERLAY")
        right:SetWidth(1)
        right:SetTexture(C.media.backdrop)
        right:SetVertexColor(0, 0, 0)
        right:SetPoint("TOPRIGHT", roleIcon, -3, -3)
        right:SetPoint("BOTTOMRIGHT", roleIcon, -3, 4)

        local top = scrollChild:CreateTexture(nil, "OVERLAY")
        top:SetHeight(1)
        top:SetTexture(C.media.backdrop)
        top:SetVertexColor(0, 0, 0)
        top:SetPoint("TOPLEFT", roleIcon, 3, -3)
        top:SetPoint("TOPRIGHT", roleIcon, -3, -3)

        local bottom = scrollChild:CreateTexture(nil, "OVERLAY")
        bottom:SetHeight(1)
        bottom:SetTexture(C.media.backdrop)
        bottom:SetVertexColor(0, 0, 0)
        bottom:SetPoint("BOTTOMLEFT", roleIcon, 3, 4)
        bottom:SetPoint("BOTTOMRIGHT", roleIcon, -3, 4)
    end

    hooksecurefunc("PlayerTalentFrame_UpdateSpecFrame", function(self, spec)
        local playerTalentSpec = _G.GetSpecialization(nil, self.isPet, _G.PlayerSpecTab2:GetChecked() and 2 or 1)
        local shownSpec = spec or playerTalentSpec or 1

        local id, _, _, icon = _G.GetSpecializationInfo(shownSpec, nil, self.isPet)
        local scrollChild = self.spellsScroll.child

        scrollChild.specIcon:SetTexture(icon)

        local index = 1
        local bonuses
        if self.isPet then
            bonuses = {_G.GetSpecializationSpells(shownSpec, nil, self.isPet, true)}
        else
            bonuses = _G.SPEC_SPELLS_DISPLAY[id]
        end

        if bonuses then
            for i = 1, #bonuses, 2 do
                local frame = scrollChild["abilityButton"..index]
                local _, spellIcon = _G.GetSpellTexture(bonuses[i])

                frame.icon:SetTexture(spellIcon)
                frame.subText:SetTextColor(.75, .75, .75)

                if not frame.styled then
                    frame.ring:Hide()
                    frame.icon:SetTexCoord(.08, .92, .08, .92)
                    F.CreateBG(frame.icon)

                    frame.styled = true
                end

                index = index + 1
            end
        end

        for i = 1, _G.GetNumSpecializations(nil, self.isPet) do
            local bu = self["specButton"..i]

            if bu.disabled then
                bu.roleName:SetTextColor(.5, .5, .5)
            else
                bu.roleName:SetTextColor(1, 1, 1)
            end
        end
    end)

    for i = 1, _G.GetNumSpecializations(false, nil) do
        local _, _, _, icon = _G.GetSpecializationInfo(i, false, nil)
        _G.PlayerTalentFrameSpecialization["specButton"..i].specIcon:SetTexture(icon)
    end

    local buttons = {"PlayerTalentFrameSpecializationSpecButton", "PlayerTalentFramePetSpecializationSpecButton"}

    for _, name in pairs(buttons) do
        for i = 1, 4 do
            local bu = _G[name..i]

            bu.bg:SetAlpha(0)
            bu.ring:Hide()
            _G[name..i.."Glow"]:SetTexture("")

            F.Reskin(bu, true)

            bu.learnedTex:SetTexture("")
            bu.selectedTex:SetTexture(C.media.backdrop)
            bu.selectedTex:SetVertexColor(r, g, b, .2)
            bu.selectedTex:SetDrawLayer("BACKGROUND")
            bu.selectedTex:SetAllPoints()

            bu.specIcon:SetTexCoord(.08, .92, .08, .92)
            bu.specIcon:SetSize(58, 58)
            bu.specIcon:SetPoint("LEFT", bu, "LEFT")
            bu.specIcon:SetDrawLayer("OVERLAY")
            local bg = F.CreateBG(bu.specIcon)
            bg:SetDrawLayer("BORDER")

            local roleIcon = bu.roleIcon

            roleIcon:SetTexture(C.media.roleIcons)

            local left = bu:CreateTexture(nil, "OVERLAY")
            left:SetWidth(1)
            left:SetTexture(C.media.backdrop)
            left:SetVertexColor(0, 0, 0)
            left:SetPoint("TOPLEFT", roleIcon, 2, -2)
            left:SetPoint("BOTTOMLEFT", roleIcon, 2, 3)

            local right = bu:CreateTexture(nil, "OVERLAY")
            right:SetWidth(1)
            right:SetTexture(C.media.backdrop)
            right:SetVertexColor(0, 0, 0)
            right:SetPoint("TOPRIGHT", roleIcon, -2, -2)
            right:SetPoint("BOTTOMRIGHT", roleIcon, -2, 3)

            local top = bu:CreateTexture(nil, "OVERLAY")
            top:SetHeight(1)
            top:SetTexture(C.media.backdrop)
            top:SetVertexColor(0, 0, 0)
            top:SetPoint("TOPLEFT", roleIcon, 2, -2)
            top:SetPoint("TOPRIGHT", roleIcon, -2, -2)

            local bottom = bu:CreateTexture(nil, "OVERLAY")
            bottom:SetHeight(1)
            bottom:SetTexture(C.media.backdrop)
            bottom:SetVertexColor(0, 0, 0)
            bottom:SetPoint("BOTTOMLEFT", roleIcon, 2, 3)
            bottom:SetPoint("BOTTOMRIGHT", roleIcon, -2, 3)
        end
    end

    for i = 1, _G.MAX_TALENT_TIERS do
        local row = _G["PlayerTalentFrameTalentsTalentRow"..i]
        _G["PlayerTalentFrameTalentsTalentRow"..i.."Bg"]:Hide()
        row:DisableDrawLayer("BORDER")

        row.TopLine:SetDesaturated(true)
        row.TopLine:SetVertexColor(r, g, b)
        row.BottomLine:SetDesaturated(true)
        row.BottomLine:SetVertexColor(r, g, b)

        for j = 1, _G.NUM_TALENT_COLUMNS do
            local bu = _G["PlayerTalentFrameTalentsTalentRow"..i.."Talent"..j]
            local ic = _G["PlayerTalentFrameTalentsTalentRow"..i.."Talent"..j.."IconTexture"]

            bu:SetHighlightTexture("")
            bu.Slot:SetAlpha(0)
            bu.knownSelection:SetAlpha(0)

            ic:SetDrawLayer("ARTWORK")
            ic:SetTexCoord(.08, .92, .08, .92)
            F.CreateBG(ic)

            bu.bg = _G.CreateFrame("Frame", nil, bu)
            bu.bg:SetPoint("TOPLEFT", 10, 0)
            bu.bg:SetPoint("BOTTOMRIGHT")
            bu.bg:SetFrameLevel(bu:GetFrameLevel()-1)
            F.CreateBD(bu.bg, .25)
        end
    end

    hooksecurefunc("TalentFrame_Update", function()
        for i = 1, _G.MAX_TALENT_TIERS do
            for j = 1, _G.NUM_TALENT_COLUMNS do
                local _, _, _, selected, _, _, _, _, _, _, known = GetTalentInfo(i, j, 1)
                local bu = _G["PlayerTalentFrameTalentsTalentRow"..i.."Talent"..j]
                if known then
                    bu.bg:SetBackdropColor(r, g, b, .7)
                elseif selected then
                    bu.bg:SetBackdropColor(r, g, b, .25)
                else
                    bu.bg:SetBackdropColor(0, 0, 0, .25)
                end
            end
        end
    end)

    for i = 1, 2 do
        local tab = _G["PlayerSpecTab"..i]
        _G["PlayerSpecTab"..i.."Background"]:Hide()

        tab:SetCheckedTexture(C.media.checked)

        local bg = _G.CreateFrame("Frame", nil, tab)
        bg:SetPoint("TOPLEFT", -1, 1)
        bg:SetPoint("BOTTOMRIGHT", 1, -1)
        bg:SetFrameLevel(tab:GetFrameLevel()-1)
        F.CreateBD(bg)

        select(2, tab:GetRegions()):SetTexCoord(.08, .92, .08, .92)
    end

    hooksecurefunc("PlayerTalentFrame_UpdateSpecs", function()
        _G.PlayerSpecTab1:SetPoint("TOPLEFT", _G.PlayerTalentFrame, "TOPRIGHT", 2, -36)
        _G.PlayerSpecTab2:SetPoint("TOP", _G.PlayerSpecTab1, "BOTTOM")
    end)

    _G.PlayerTalentFrameTalentsTutorialButton.Ring:Hide()
    _G.PlayerTalentFrameTalentsTutorialButton:SetPoint("TOPLEFT", _G.PlayerTalentFrame, "TOPLEFT", -12, 12)
    _G.PlayerTalentFrameSpecializationTutorialButton.Ring:Hide()
    _G.PlayerTalentFrameSpecializationTutorialButton:SetPoint("TOPLEFT", _G.PlayerTalentFrame, "TOPLEFT", -12, 12)

    F.ReskinPortraitFrame(_G.PlayerTalentFrame, true)
    F.Reskin(_G.PlayerTalentFrameSpecializationLearnButton)
    F.Reskin(_G.PlayerTalentFrameActivateButton)
    F.Reskin(_G.PlayerTalentFramePetSpecializationLearnButton)

    F.CreateBD(_G.PlayerTalentFrame)
    F.CreateSD(_G.PlayerTalentFrame)
end
