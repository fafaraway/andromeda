local F, C = unpack(select(2, ...))

table.insert(
    C.BlizzThemes,
    function()
        hooksecurefunc(
            'LootFrame_UpdateButton',
            function(index)
                local name = 'LootButton' .. index
                local bu = _G[name]
                if not bu:IsShown() then
                    return
                end

                local nameFrame = _G[name .. 'NameFrame']
                local questTexture = _G[name .. 'IconQuestTexture']

                if not bu.bg then
                    nameFrame:Hide()
                    questTexture:SetAlpha(0)
                    bu:SetNormalTexture('')
                    bu:SetPushedTexture('')
                    bu:GetHighlightTexture():SetColorTexture(1, 1, 1, .25)
                    bu.IconBorder:SetAlpha(0)
                    bu.bg = F.ReskinIcon(bu.icon)

                    local bg = F.CreateBDFrame(bu, .25)
                    bg:SetPoint('TOPLEFT', bu.bg, 'TOPRIGHT', 1, 0)
                    bg:SetPoint('BOTTOMRIGHT', bu.bg, 115, 0)
                end

                if questTexture:IsShown() then
                    bu.bg:SetBackdropBorderColor(.8, .8, 0)
                else
                    bu.bg:SetBackdropBorderColor(0, 0, 0)
                end
            end
        )

        _G.LootFrameDownButton:ClearAllPoints()
        _G.LootFrameDownButton:SetPoint('BOTTOMRIGHT', -8, 6)
        _G.LootFramePrev:ClearAllPoints()
        _G.LootFramePrev:SetPoint('LEFT', _G.LootFrameUpButton, 'RIGHT', 4, 0)
        _G.LootFrameNext:ClearAllPoints()
        _G.LootFrameNext:SetPoint('RIGHT', _G.LootFrameDownButton, 'LEFT', -4, 0)

        F.ReskinPortraitFrame(_G.LootFrame)
        F.ReskinArrow(_G.LootFrameUpButton, 'up')
        F.ReskinArrow(_G.LootFrameDownButton, 'down')
        _G.LootFramePortraitOverlay:Hide()

        -- Bonus roll
        _G.BonusRollFrame.Background:SetAlpha(0)
        _G.BonusRollFrame.IconBorder:Hide()
        _G.BonusRollFrame.BlackBackgroundHoist.Background:Hide()
        _G.BonusRollFrame.SpecRing:SetAlpha(0)
        F.SetBD(_G.BonusRollFrame)

        local specIcon = _G.BonusRollFrame.SpecIcon
        specIcon:ClearAllPoints()
        specIcon:SetPoint('TOPRIGHT', -90, -18)
        local bg = F.ReskinIcon(specIcon)
        hooksecurefunc(
            'BonusRollFrame_StartBonusRoll',
            function()
                bg:SetShown(specIcon:IsShown())
            end
        )

        local promptFrame = _G.BonusRollFrame.PromptFrame
        F.ReskinIcon(promptFrame.Icon)
        promptFrame.Timer.Bar:SetTexture(C.Assets.Textures.SBNormal)
        F.CreateBDFrame(promptFrame.Timer, .25)

        local from, to = '|T.+|t', '|T%%s:14:14:0:0:64:64:5:59:5:59|t'
        _G.BONUS_ROLL_COST = _G.BONUS_ROLL_COST:gsub(from, to)
        _G.BONUS_ROLL_CURRENT_COUNT = _G.BONUS_ROLL_CURRENT_COUNT:gsub(from, to)

        -- Loot Roll Frame
        hooksecurefunc(
            'GroupLootFrame_OpenNewFrame',
            function()
                for i = 1, _G.NUM_GROUP_LOOT_FRAMES do
                    local frame = _G['GroupLootFrame' .. i]
                    if not frame.styled then
                        frame.Border:SetAlpha(0)
                        frame.Background:SetAlpha(0)
                        frame.bg = F.SetBD(frame)

                        frame.Timer.Bar:SetTexture(C.Assets.Textures.Backdrop)
                        frame.Timer.Bar:SetVertexColor(1, .8, 0)
                        frame.Timer.Background:SetAlpha(0)
                        F.CreateBDFrame(frame.Timer, .25)

                        frame.IconFrame.Border:SetAlpha(0)
                        F.ReskinIcon(frame.IconFrame.Icon)

                        local bg = F.CreateBDFrame(frame, .25)
                        bg:SetPoint('TOPLEFT', frame.IconFrame.Icon, 'TOPRIGHT', 0, 1)
                        bg:SetPoint('BOTTOMRIGHT', frame.IconFrame.Icon, 'BOTTOMRIGHT', 150, -1)

                        frame.styled = true
                    end

                    if frame:IsShown() then
                        local _, _, _, quality = GetLootRollItemInfo(frame.rollID)
                        local color = C.QualityColors[quality]
                        frame.bg:SetBackdropBorderColor(color.r, color.g, color.b)
                    end
                end
            end
        )

        -- Bossbanner
        hooksecurefunc(
            'BossBanner_ConfigureLootFrame',
            function(lootFrame)
                local iconHitBox = lootFrame.IconHitBox
                if not iconHitBox.bg then
                    iconHitBox.bg = F.CreateBDFrame(iconHitBox)
                    iconHitBox.bg:SetOutside(lootFrame.Icon)
                    lootFrame.Icon:SetTexCoord(unpack(C.TexCoord))
                    F.ReskinIconBorder(iconHitBox.IconBorder, true)
                end

                iconHitBox.IconBorder:SetTexture(nil)
            end
        )
    end
)
