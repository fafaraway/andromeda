local _, private = ...

-- [[ Lua Globals ]]
local next = _G.next

-- [[ WoW API ]]
local hooksecurefunc = _G.hooksecurefunc

-- [[ Core ]]
local F, C = _G.unpack(private.Aurora)

function private.FrameXML.SpellBookFrame()
    local r, g, b = C.r, C.g, C.b

    local SpellBookFrame = _G.SpellBookFrame
    F.ReskinPortraitFrame(SpellBookFrame, true)
    F.CreateBD(_G.SpellBookFrame)
    F.CreateSD(_G.SpellBookFrame)
    _G.SetUIPanelAttribute(SpellBookFrame, "width", 490)
    _G.SetUIPanelAttribute(SpellBookFrame, "height", 492)
    SpellBookFrame:SetSize(465, 472)
    _G.SpellBookPage1:Hide()
    _G.SpellBookPage2:Hide()

    SpellBookFrame.MainHelpButton.Ring:Hide()
    SpellBookFrame.MainHelpButton:SetPoint("TOPLEFT", -18, 18)

    _G.SpellBookFrameTabButton1:SetPoint("TOPLEFT", _G.SpellBookFrame, "BOTTOMLEFT", 0, 2)
    for i = 1, 5 do
        F.ReskinTab(_G["SpellBookFrameTabButton"..i])
    end

    _G.SpellBookPageText:SetTextColor(.8, .8, .8)
    _G.SpellBookPageText:SetPoint("BOTTOMRIGHT", -110, 28)
    F.ReskinArrow(_G.SpellBookPrevPageButton, "Left")
    F.ReskinArrow(_G.SpellBookNextPageButton, "Right")

    _G.SpellButton1:SetPoint("TOPLEFT", 32, -40)
    for i = 1, _G.SPELLS_PER_PAGE do
        local name = "SpellButton"..i
        local button = _G[name]

        button.EmptySlot:Hide()

        local icon = _G[name.."IconTexture"]
        local iconBG = F.ReskinIcon(icon)
        iconBG:SetPoint("TOPLEFT", button, -1, 1)
        iconBG:SetPoint("BOTTOMRIGHT", button, 1, -1)
        button._auroraIconBG = iconBG
        button.SeeTrainerString:SetTextColor(.7, .7, .7)

        _G[name.."SlotFrame"]:SetAlpha(0)
        button.UnlearnedFrame:SetAlpha(0)

        local autoCast = _G[name.."AutoCastable"]
        autoCast:ClearAllPoints()
        autoCast:SetPoint("TOPLEFT")
        autoCast:SetPoint("BOTTOMRIGHT")
        autoCast:SetTexCoord(0.2344, 0.75, 0.25, 0.75)

        local spellHighlight = button.SpellHighlightTexture
        spellHighlight:ClearAllPoints()
        spellHighlight:SetPoint("TOPLEFT")
        spellHighlight:SetPoint("BOTTOMRIGHT")
        spellHighlight:SetTexCoord(0.125, 0.882, 0.135, 0.885)

        button:SetPushedTexture("")
        button:SetCheckedTexture(C.media.checked)
    end
    hooksecurefunc("SpellButton_UpdateButton", function(self)
        if _G.SpellBookFrame.bookType == _G.BOOKTYPE_PROFESSION then return end

        self.TextBackground:SetDesaturated(true)
        local isOffSpec = self.offSpecID ~= 0 and _G.SpellBookFrame.bookType == _G.BOOKTYPE_SPELL
        local slot, slotType = _G.SpellBook_GetSpellBookSlot(self)
        if slot then
            if slotType == "FUTURESPELL" then
                local level = _G.GetSpellAvailableLevel(slot, _G.SpellBookFrame.bookType)
                if _G.IsCharacterNewlyBoosted() or (level and level > _G.UnitLevel("player")) then
                    self.SpellName:SetTextColor(.7, .7, .7)
                    self.SpellSubName:SetTextColor(.5, .5, .5)
                    self.RequiredLevelString:SetTextColor(.5, .5, .5)
                    self._auroraIconBG:SetBackdropBorderColor(.5, .5, .5)
                else
                    -- Can learn spell, but hasn't yet. eg. riding skill
                    self.TrainFrame:Hide()
                    self.TrainTextBackground:Hide()

                    self.SpellSubName:SetTextColor(.7, .7, .7)
                    self._auroraIconBG:SetBackdropBorderColor(1, 1, 0)
                end
            else
                self.SpellSubName:SetTextColor(.5, .5, .5)

                if isOffSpec then
                    local level = _G.GetSpellAvailableLevel(slot, _G.SpellBookFrame.bookType)
                    if level and level > _G.UnitLevel("player") then
                        self.RequiredLevelString:SetTextColor(.5, .5, .5)
                    end
                    self._auroraIconBG:SetBackdropBorderColor(.5, .5, .5)
                elseif self.SpellHighlightTexture and self.SpellHighlightTexture:IsShown() then
                    self._auroraIconBG:SetBackdropBorderColor(1, 1, 0)
                else
                    self._auroraIconBG:SetBackdropBorderColor(r, g, b)
                end
            end

            if self.shine then
                local shine = self.shine
                shine:ClearAllPoints()
                shine:SetPoint("TOPLEFT", 3, -2)
                shine:SetPoint("BOTTOMRIGHT", -1, 1)
            end
        else
            self._auroraIconBG:SetBackdropBorderColor(0, 0, 0)
        end
    end)

    _G.SpellBookSkillLineTab1:SetPoint("TOPLEFT", _G.SpellBookSideTabsFrame, "TOPRIGHT", 2, -36)
    for i = 1, _G.MAX_SKILLLINE_TABS do
        local skillLineTab = _G["SpellBookSkillLineTab"..i]
        skillLineTab:GetRegions():Hide()
        skillLineTab:SetCheckedTexture(C.media.checked)

        F.CreateBG(skillLineTab)

        local icon = skillLineTab:GetNormalTexture()
        if icon then
            icon:SetTexCoord(.08, .92, .08, .92)
        end
    end

    _G.PrimaryProfession1:SetPoint("TOPLEFT", 12, -28)
    _G.PrimaryProfession2:SetPoint("TOPLEFT", _G.PrimaryProfession1, "BOTTOMLEFT", 0, -8)

    _G.SecondaryProfession1:SetPoint("TOPLEFT", _G.PrimaryProfession2, "BOTTOMLEFT", 0, -18)
    _G.SecondaryProfession2:SetPoint("TOPLEFT", _G.SecondaryProfession1, "BOTTOMLEFT", 0, -8)
    _G.SecondaryProfession3:SetPoint("TOPLEFT", _G.SecondaryProfession2, "BOTTOMLEFT", 0, -8)
    _G.SecondaryProfession4:SetPoint("TOPLEFT", _G.SecondaryProfession3, "BOTTOMLEFT", 0, -8)
    local professions = {
        PrimaryProfession1 = true,
        PrimaryProfession2 = true,

        SecondaryProfession1 = false,
        SecondaryProfession2 = false,
        SecondaryProfession3 = false,
        SecondaryProfession4 = false
    }
    for name, isPrimary in next, professions do
        local prof = _G[name]
        F.CreateBD(prof, .25)

        prof.professionName:SetTextColor(1, 1, 1)
        prof.missingHeader:SetTextColor(1, 1, 1)
        prof.missingText:SetTextColor(1, 1, 1)

        for i = 1, 2 do
            local button = prof["button"..i]
            button:SetSize(41, 41)
            button.Icon = button.iconTexture
            button.NameFrame = _G[button:GetName().."NameFrame"]
            F.ReskinItemFrame(button)
            button:SetPushedTexture("")
            button:SetCheckedTexture(C.media.checked)
        end

        prof.statusBar:SetSize(115, 12)
        prof.statusBar:ClearAllPoints()
        prof.statusBar:SetStatusBarTexture(C.media.backdrop)
        prof.statusBar:GetStatusBarTexture():SetGradient("VERTICAL", 0, .6, 0, 0, .8, 0)
        prof.statusBar.rankText:SetPoint("CENTER")

        _G[name.."StatusBarLeft"]:Hide()
        prof.statusBar.capRight:SetAlpha(0)
        _G[name.."StatusBarBGLeft"]:Hide()
        _G[name.."StatusBarBGMiddle"]:Hide()
        _G[name.."StatusBarBGRight"]:Hide()
        F.CreateBDFrame(prof.statusBar, .25)

        if isPrimary then
            prof:SetSize(441, 93)
            prof.professionName:SetPoint("TOPLEFT", prof.icon, "TOPRIGHT", 4, 0)
            prof.rank:SetPoint("BOTTOMLEFT", prof.statusBar, "TOPLEFT", 0, 3)
            _G[name.."IconBorder"]:Hide()

            prof.icon:ClearAllPoints()
            prof.icon:SetPoint("TOPLEFT", 6, -6)
            prof.icon:SetSize(81, 81)
            F.ReskinIcon(prof.icon)

            prof.button2:SetPoint("TOPRIGHT", -108, -4)
            prof.button1:SetPoint("TOPLEFT", prof.button2, "BOTTOMLEFT", 0, -3)
            prof.statusBar:SetPoint("BOTTOMLEFT", prof.icon, "BOTTOMRIGHT", 4, 0)
            prof.unlearn:ClearAllPoints()
            prof.unlearn:SetPoint("BOTTOMRIGHT", prof.icon)
        else
            prof:SetSize(441, 49)
            prof.professionName:SetPoint("TOPLEFT", 4, -3)
            prof.button1:SetPoint("TOPRIGHT", -108, -4)
            prof.button2:SetPoint("TOPRIGHT", prof.button1, "TOPLEFT", -107, 0)
            prof.statusBar:SetPoint("TOPLEFT", prof.rank, "BOTTOMLEFT", 0, -3)
        end
    end
    hooksecurefunc("FormatProfession", function(frame, index)
        if index then
            local _, texture = _G.GetProfessionInfo(index)
            if frame.icon and texture then
                frame.icon:SetTexture(texture)
            end
        end
    end)
end
