local _, private = ...

-- [[ Lua Globals ]]
local select, pairs = _G.select, _G.pairs

-- [[ WoW API ]]
local hooksecurefunc, CreateFrame = _G.hooksecurefunc, _G.CreateFrame

-- [[ Core ]]
local Aurora = private.Aurora
local Base, Skin = Aurora.Base, Aurora.Skin
local F, C = _G.unpack(private.Aurora)

function private.AddOns.Blizzard_PVPUI()
    local r, g, b = C.r, C.g, C.b

    local PVPQueueFrame = _G.PVPQueueFrame
    local HonorFrame = _G.HonorFrame
    local ConquestFrame = _G.ConquestFrame
    local WarGamesFrame = _G.WarGamesFrame

    if not private.disabled.tooltips then
        Base.SetBackdrop(_G.PVPRewardTooltip)
        Skin.EmbeddedItemTooltip(_G.PVPRewardTooltip.ItemTooltip)
    end

    local function SkinRoleInset(roleInset)
        roleInset:DisableDrawLayer("BACKGROUND")
        roleInset:DisableDrawLayer("BORDER")

        for _, roleButton in pairs({roleInset.HealerIcon, roleInset.TankIcon, roleInset.DPSIcon}) do
            roleButton.cover:SetTexture(C.media.roleIcons)
            roleButton:SetNormalTexture(C.media.roleIcons)

            for i = 1, 4 do
                -- These textures cover up a texture scaling artifact along the border
                local tex = roleButton:CreateTexture(nil, "OVERLAY", nil, 7)
                tex:SetColorTexture(0, 0, 0)
                tex:SetSize(1, 1)
                if i == 1 then
                    -- Left
                    tex:SetPoint("TOPLEFT", roleButton, 6, -4)
                    tex:SetPoint("BOTTOMLEFT", roleButton, 6, 7)
                elseif i == 2 then
                    -- Right
                    tex:SetPoint("TOPRIGHT", roleButton, -5, -4)
                    tex:SetPoint("BOTTOMRIGHT", roleButton, -5, 7)
                elseif i == 3 then
                    -- Top
                    tex:SetPoint("TOPLEFT", roleButton, 6, -4)
                    tex:SetPoint("TOPRIGHT", roleButton, -6, -4)
                elseif i == 4 then
                    -- Bottom
                    tex:SetPoint("BOTTOMLEFT", roleButton, 6, 7)
                    tex:SetPoint("BOTTOMRIGHT", roleButton, -6, 7)
                end
            end

            roleButton.checkButton:SetFrameLevel(roleButton:GetFrameLevel() + 2)
            F.ReskinCheck(roleButton.checkButton)
        end
    end

    -- Category buttons

    for i = 1, 4 do
        local bu = PVPQueueFrame["CategoryButton"..i]
        local icon = bu.Icon
        local cu = bu.CurrencyDisplay

        bu.Ring:Hide()

        F.Reskin(bu, true)

        bu.Background:SetAllPoints()
        bu.Background:SetColorTexture(r, g, b, .2)
        bu.Background:Hide()

        icon:SetTexCoord(.08, .92, .08, .92)
        icon:SetPoint("LEFT", bu, "LEFT")
        icon:SetDrawLayer("OVERLAY")
        icon.bg = F.CreateBG(icon)
        icon.bg:SetDrawLayer("ARTWORK")

        if cu then
            local ic = cu.Icon

            ic:SetSize(16, 16)
            ic:SetPoint("TOPLEFT", bu.Name, "BOTTOMLEFT", 0, -8)
            cu.Amount:SetPoint("LEFT", ic, "RIGHT", 4, 0)

            ic:SetTexCoord(.08, .92, .08, .92)
            ic.bg = F.CreateBG(ic)
            ic.bg:SetDrawLayer("BACKGROUND", 1)
        end
    end

    PVPQueueFrame.CategoryButton1.Icon:SetTexture("Interface\\Icons\\achievement_bg_winwsg")
    PVPQueueFrame.CategoryButton2.Icon:SetTexture("Interface\\Icons\\achievement_bg_killxenemies_generalsroom")
    PVPQueueFrame.CategoryButton3.Icon:SetTexture("Interface\\Icons\\ability_warrior_offensivestance")

    hooksecurefunc("PVPQueueFrame_SelectButton", function(index)
        local self = PVPQueueFrame
        for i = 1, 4 do
            local bu = self["CategoryButton"..i]
            if i == index then
                bu.Background:Show()
            else
                bu.Background:Hide()
            end
        end
    end)

    PVPQueueFrame.CategoryButton1.Background:Show()

    -- Casual - HonorFrame

    local Inset = HonorFrame.Inset
    local BonusFrame = HonorFrame.BonusFrame

    for i = 1, 9 do
        select(i, Inset:GetRegions()):Hide()
    end
    BonusFrame.WorldBattlesTexture:Hide()
    BonusFrame.ShadowOverlay:Hide()

    F.Reskin(BonusFrame.DiceButton)

    for _, bonusButton in pairs({"RandomBGButton", "Arena1Button", "AshranButton", "BrawlButton"}) do
        local bu = BonusFrame[bonusButton]
        local reward = bu.Reward

        F.Reskin(bu)

        bu.SelectedTexture:SetDrawLayer("BACKGROUND")
        bu.SelectedTexture:SetColorTexture(r, g, b, .2)
        bu.SelectedTexture:SetAllPoints()

        if reward then
            reward.Border:Hide()
            F.ReskinIcon(reward.Icon)
        end
    end

    _G.IncludedBattlegroundsDropDown:SetPoint("TOPRIGHT", BonusFrame.DiceButton, 40, 26)
    SkinRoleInset(HonorFrame.RoleInset)

    -- Honor frame specific

    for _, bu in pairs(HonorFrame.SpecificFrame.buttons) do
        bu.Bg:Hide()
        bu.Border:Hide()

        bu:SetNormalTexture("")
        bu:SetHighlightTexture("")

        local bg = CreateFrame("Frame", nil, bu)
        bg:SetPoint("TOPLEFT", 2, 0)
        bg:SetPoint("BOTTOMRIGHT", -1, 2)
        F.CreateBD(bg, 0)
        bg:SetFrameLevel(bu:GetFrameLevel()-1)

        bu.tex = F.CreateGradient(bu)
        bu.tex:SetDrawLayer("BACKGROUND")
        bu.tex:SetPoint("TOPLEFT", bg, 1, -1)
        bu.tex:SetPoint("BOTTOMRIGHT", bg, -1, 1)

        bu.SelectedTexture:SetDrawLayer("BACKGROUND")
        bu.SelectedTexture:SetColorTexture(r, g, b, .2)
        bu.SelectedTexture:SetAllPoints(bu.tex)

        bu.Icon:SetTexCoord(.08, .92, .08, .92)
        bu.Icon.bg = F.CreateBG(bu.Icon)
        bu.Icon.bg:SetDrawLayer("BACKGROUND", 1)
        bu.Icon:SetPoint("TOPLEFT", 5, -3)
    end

    -- Rated - ConquestFrame

    Inset = ConquestFrame.Inset

    for i = 1, 9 do
        select(i, Inset:GetRegions()):Hide()
    end
    ConquestFrame.ArenaTexture:Hide()
    ConquestFrame.RatedBGTexture:Hide()
    ConquestFrame.ArenaHeader:Hide()
    ConquestFrame.RatedBGHeader:Hide()
    ConquestFrame.ShadowOverlay:Hide()

    F.CreateBD(_G.ConquestTooltip)
    SkinRoleInset(ConquestFrame.RoleInset)

    local ConquestFrameButton_OnEnter = function(self)
        _G.ConquestTooltip:SetPoint("TOPLEFT", self, "TOPRIGHT", 1, 0)
    end

    ConquestFrame.Arena2v2:HookScript("OnEnter", ConquestFrameButton_OnEnter)
    ConquestFrame.Arena3v3:HookScript("OnEnter", ConquestFrameButton_OnEnter)
    ConquestFrame.RatedBG:HookScript("OnEnter", ConquestFrameButton_OnEnter)

    for _, bu in pairs({ConquestFrame.Arena2v2, ConquestFrame.Arena3v3, ConquestFrame.RatedBG}) do
        F.Reskin(bu)
        local reward = bu.Reward

        bu.SelectedTexture:SetDrawLayer("BACKGROUND")
        bu.SelectedTexture:SetColorTexture(r, g, b, .2)
        bu.SelectedTexture:SetAllPoints()

        if reward then
            reward.Border:Hide()
            F.ReskinIcon(reward.Icon)
        end
    end

    ConquestFrame.Arena3v3:SetPoint("TOP", ConquestFrame.Arena2v2, "BOTTOM", 0, -1)

    -- War Games

    Inset = WarGamesFrame.RightInset

    for i = 1, 9 do
        select(i, Inset:GetRegions()):Hide()
    end
    WarGamesFrame.InfoBG:Hide()
    WarGamesFrame.HorizontalBar:Hide()
    _G.WarGamesFrameInfoScrollFrame.scrollBarBackground:Hide()
    _G.WarGamesFrameInfoScrollFrame.scrollBarArtTop:Hide()
    _G.WarGamesFrameInfoScrollFrame.scrollBarArtBottom:Hide()

    _G.WarGamesFrameDescription:SetTextColor(.9, .9, .9)

    for _, button in pairs(WarGamesFrame.scrollFrame.buttons) do
        local bu = button.Entry
        local SelectedTexture = bu.SelectedTexture

        bu.Bg:Hide()
        bu.Border:Hide()

        bu:SetNormalTexture("")
        bu:SetHighlightTexture("")

        local bg = CreateFrame("Frame", nil, bu)
        bg:SetPoint("TOPLEFT", 2, 0)
        bg:SetPoint("BOTTOMRIGHT", -1, 2)
        F.CreateBD(bg, 0)
        bg:SetFrameLevel(bu:GetFrameLevel()-1)

        local tex = F.CreateGradient(bu)
        tex:SetDrawLayer("BACKGROUND")
        tex:SetPoint("TOPLEFT", 3, -1)
        tex:SetPoint("BOTTOMRIGHT", -2, 3)

        SelectedTexture:SetDrawLayer("BACKGROUND")
        SelectedTexture:SetColorTexture(r, g, b, .2)
        SelectedTexture:SetPoint("TOPLEFT", 2, 0)
        SelectedTexture:SetPoint("BOTTOMRIGHT", -1, 2)

        bu.Icon:SetTexCoord(.08, .92, .08, .92)
        bu.Icon.bg = F.CreateBG(bu.Icon)
        bu.Icon.bg:SetDrawLayer("BACKGROUND", 1)
        bu.Icon:SetPoint("TOPLEFT", 5, -3)

        F.ReskinExpandOrCollapse(button.Header)
    end

    F.ReskinCheck(_G.WarGameTournamentModeCheckButton)

    -- Main style

    F.Reskin(HonorFrame.QueueButton)
    F.Reskin(ConquestFrame.JoinButton)
    F.Reskin(_G.WarGameStartButton)
    F.ReskinDropDown(_G.HonorFrameTypeDropDown)
    F.ReskinScroll(_G.HonorFrameSpecificFrameScrollBar)
    F.ReskinScroll(_G.WarGamesFrameScrollFrameScrollBar)
    F.ReskinScroll(_G.WarGamesFrameInfoScrollFrameScrollBar)
end
