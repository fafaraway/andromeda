local _, private = ...

-- [[ Core ]]
local F = _G.unpack(private.Aurora)

function private.FrameXML.InterfaceOptionsFrame()
    local restyled = false

    _G.InterfaceOptionsFrame:HookScript("OnShow", function()
        if restyled then return end

        _G.InterfaceOptionsFrameCategories:DisableDrawLayer("BACKGROUND")
        _G.InterfaceOptionsFrameAddOns:DisableDrawLayer("BACKGROUND")
        _G.InterfaceOptionsFramePanelContainer:DisableDrawLayer("BORDER")
        _G.InterfaceOptionsFrameTab1TabSpacer:SetAlpha(0)
        for i = 1, 2 do
            _G["InterfaceOptionsFrameTab"..i.."Left"]:SetAlpha(0)
            _G["InterfaceOptionsFrameTab"..i.."Middle"]:SetAlpha(0)
            _G["InterfaceOptionsFrameTab"..i.."Right"]:SetAlpha(0)
            _G["InterfaceOptionsFrameTab"..i.."LeftDisabled"]:SetAlpha(0)
            _G["InterfaceOptionsFrameTab"..i.."MiddleDisabled"]:SetAlpha(0)
            _G["InterfaceOptionsFrameTab"..i.."RightDisabled"]:SetAlpha(0)
            _G["InterfaceOptionsFrameTab2TabSpacer"..i]:SetAlpha(0)
        end

        F.CreateBD(_G.InterfaceOptionsFrame)
        F.CreateSD(_G.InterfaceOptionsFrame)
        F.Reskin(_G.InterfaceOptionsFrameDefaults)
        F.Reskin(_G.InterfaceOptionsFrameOkay)
        F.Reskin(_G.InterfaceOptionsFrameCancel)

        _G.InterfaceOptionsFrameOkay:SetPoint("BOTTOMRIGHT", _G.InterfaceOptionsFrameCancel, "BOTTOMLEFT", -1, 0)

        _G.InterfaceOptionsFrameHeader:SetTexture("")
        _G.InterfaceOptionsFrameHeader:ClearAllPoints()
        _G.InterfaceOptionsFrameHeader:SetPoint("TOP", _G.InterfaceOptionsFrame, 0, 0)

        local line = _G.InterfaceOptionsFrame:CreateTexture(nil, "ARTWORK")
        line:SetSize(1, 546)
        line:SetPoint("LEFT", 205, 10)
        line:SetColorTexture(1, 1, 1, .2)

        local checkboxes, dropdowns
        -- Controls
        checkboxes = {
            "InterfaceOptionsControlsPanelStickyTargeting",
            "InterfaceOptionsControlsPanelAutoDismount",
            "InterfaceOptionsControlsPanelAutoClearAFK",
            "InterfaceOptionsControlsPanelAutoLootCorpse",
            "InterfaceOptionsControlsPanelInteractOnLeftClick",
            "InterfaceOptionsControlsPanelLootAtMouse"
        }
        for i = 1, #checkboxes do
            F.ReskinCheck(_G[checkboxes[i]])
        end
        F.ReskinDropDown(_G.InterfaceOptionsControlsPanelAutoLootKeyDropDown)

        -- Combat
        checkboxes = {
            "InterfaceOptionsCombatPanelTargetOfTarget",
            "InterfaceOptionsCombatPanelFlashLowHealthWarning",
            "InterfaceOptionsCombatPanelLossOfControl",
            "InterfaceOptionsCombatPanelAutoSelfCast",
            "InterfaceOptionsCombatPanelEnableFloatingCombatText"
        }
        for i = 1, #checkboxes do
            F.ReskinCheck(_G[checkboxes[i]])
        end
        F.ReskinDropDown(_G.InterfaceOptionsCombatPanelFocusCastKeyDropDown)
        F.ReskinDropDown(_G.InterfaceOptionsCombatPanelSelfCastKeyDropDown)
        F.ReskinSlider(_G.InterfaceOptionsCombatPanelSpellAlertOpacitySlider)

        -- Display
        checkboxes = {
            "InterfaceOptionsDisplayPanelRotateMinimap",
            "InterfaceOptionsDisplayPanelAJAlerts",
            "InterfaceOptionsDisplayPanelShowTutorials"
        }
        for i = 1, #checkboxes do
            F.ReskinCheck(_G[checkboxes[i]])
        end
        dropdowns = {
            "InterfaceOptionsDisplayPanelOutlineDropDown",
            "InterfaceOptionsDisplayPanelSelfHighlightDropDown",
            "InterfaceOptionsDisplayPanelDisplayDropDown",
            "InterfaceOptionsDisplayPanelChatBubblesDropDown"
        }
        for i = 1, #dropdowns do
            F.ReskinDropDown(_G[dropdowns[i]])
        end
        F.Reskin(_G.InterfaceOptionsDisplayPanelResetTutorials)

        -- Social
        checkboxes = {
            "InterfaceOptionsSocialPanelProfanityFilter",
            "InterfaceOptionsSocialPanelSpamFilter",
            "InterfaceOptionsSocialPanelGuildMemberAlert",
            "InterfaceOptionsSocialPanelBlockTrades",
            "InterfaceOptionsSocialPanelBlockGuildInvites",
            "InterfaceOptionsSocialPanelBlockChatChannelInvites",
            "InterfaceOptionsSocialPanelShowAccountAchievments",

            "InterfaceOptionsSocialPanelOnlineFriends",
            "InterfaceOptionsSocialPanelOfflineFriends",
            "InterfaceOptionsSocialPanelBroadcasts",
            "InterfaceOptionsSocialPanelAutoAcceptQuickJoinRequests",
            "InterfaceOptionsSocialPanelFriendRequests",
            "InterfaceOptionsSocialPanelShowToastWindow",
            "InterfaceOptionsSocialPanelEnableTwitter"
        }
        for i = 1, #checkboxes do
            F.ReskinCheck(_G[checkboxes[i]])
        end
        dropdowns = {
            "InterfaceOptionsSocialPanelChatStyle",
            "InterfaceOptionsSocialPanelTimestamps",
            "InterfaceOptionsSocialPanelWhisperMode"
        }
        for i = 1, #dropdowns do
            F.ReskinDropDown(_G[dropdowns[i]])
        end
        F.Reskin(_G.InterfaceOptionsSocialPanelTwitterLoginButton)
        F.Reskin(_G.InterfaceOptionsSocialPanelRedockChat)

        -- ActionBars
        checkboxes = {
            "InterfaceOptionsActionBarsPanelBottomLeft",
            "InterfaceOptionsActionBarsPanelBottomRight",
            "InterfaceOptionsActionBarsPanelRight",
            "InterfaceOptionsActionBarsPanelRightTwo",
            "InterfaceOptionsActionBarsPanelLockActionBars",
            "InterfaceOptionsActionBarsPanelAlwaysShowActionBars",
            "InterfaceOptionsActionBarsPanelCountdownCooldowns"
        }
        for i = 1, #checkboxes do
            F.ReskinCheck(_G[checkboxes[i]])
        end
        F.ReskinDropDown(_G.InterfaceOptionsActionBarsPanelPickupActionKeyDropDown)

        -- Names
        checkboxes = {
            "InterfaceOptionsNamesPanelMyName",
            "InterfaceOptionsNamesPanelNonCombatCreature",
            "InterfaceOptionsNamesPanelFriendlyPlayerNames",
            "InterfaceOptionsNamesPanelFriendlyMinions",
            "InterfaceOptionsNamesPanelEnemyPlayerNames",
            "InterfaceOptionsNamesPanelEnemyMinions",

            "InterfaceOptionsNamesPanelUnitNameplatesPersonalResource",
            "InterfaceOptionsNamesPanelUnitNameplatesPersonalResourceOnEnemy",
            "InterfaceOptionsNamesPanelUnitNameplatesMakeLarger",
            "InterfaceOptionsNamesPanelUnitNameplatesAggroFlash",

            "InterfaceOptionsNamesPanelUnitNameplatesShowAll",
            "InterfaceOptionsNamesPanelUnitNameplatesEnemies",
            "InterfaceOptionsNamesPanelUnitNameplatesEnemyMinions",
            "InterfaceOptionsNamesPanelUnitNameplatesEnemyMinus",
            "InterfaceOptionsNamesPanelUnitNameplatesFriends",
            "InterfaceOptionsNamesPanelUnitNameplatesFriendlyMinions"
        }
        for i = 1, #checkboxes do
            F.ReskinCheck(_G[checkboxes[i]])
        end
        F.ReskinDropDown(_G.InterfaceOptionsNamesPanelNPCNamesDropDown)
        F.ReskinDropDown(_G.InterfaceOptionsNamesPanelUnitNameplatesMotionDropDown)

        -- Camera
        F.ReskinCheck(_G.InterfaceOptionsCameraPanelWaterCollision)
        F.ReskinDropDown(_G.InterfaceOptionsCameraPanelStyleDropDown)
        F.ReskinSlider(_G.InterfaceOptionsCameraPanelFollowSpeedSlider)

        -- Mouse
        checkboxes = {
            "InterfaceOptionsMousePanelInvertMouse",
            "InterfaceOptionsMousePanelEnableMouseSpeed",
            "InterfaceOptionsMousePanelClickToMove"
        }
        for i = 1, #checkboxes do
            F.ReskinCheck(_G[checkboxes[i]])
        end
        F.ReskinDropDown(_G.InterfaceOptionsMousePanelClickMoveStyleDropDown)
        F.ReskinSlider(_G.InterfaceOptionsMousePanelMouseLookSpeedSlider)
        F.ReskinSlider(_G.InterfaceOptionsMousePanelMouseSensitivitySlider)

        -- Accessibility
        checkboxes = {
            "InterfaceOptionsAccessibilityPanelMovePad",
            "InterfaceOptionsAccessibilityPanelCinematicSubtitles",
            "InterfaceOptionsAccessibilityPanelColorblindMode"
        }
        for i = 1, #checkboxes do
            F.ReskinCheck(_G[checkboxes[i]])
        end
        F.ReskinDropDown(_G.InterfaceOptionsAccessibilityPanelColorFilterDropDown)
        F.ReskinSlider(_G.InterfaceOptionsAccessibilityPanelColorblindStrengthSlider)

        if _G.IsAddOnLoaded("Blizzard_CompactRaidFrames") then
            _G.CompactUnitFrameProfilesGeneralOptionsFrameAutoActivateBG:Hide()

            local boxes = {
                "CompactUnitFrameProfilesRaidStylePartyFrames",

                "CompactUnitFrameProfilesGeneralOptionsFrameKeepGroupsTogether",
                "CompactUnitFrameProfilesGeneralOptionsFrameHorizontalGroups",
                "CompactUnitFrameProfilesGeneralOptionsFrameDisplayIncomingHeals",
                "CompactUnitFrameProfilesGeneralOptionsFrameDisplayPowerBar",
                "CompactUnitFrameProfilesGeneralOptionsFrameDisplayAggroHighlight",
                "CompactUnitFrameProfilesGeneralOptionsFrameUseClassColors",
                "CompactUnitFrameProfilesGeneralOptionsFrameDisplayPets",
                "CompactUnitFrameProfilesGeneralOptionsFrameDisplayMainTankAndAssist",
                "CompactUnitFrameProfilesGeneralOptionsFrameDisplayBorder",
                "CompactUnitFrameProfilesGeneralOptionsFrameShowDebuffs",
                "CompactUnitFrameProfilesGeneralOptionsFrameDisplayOnlyDispellableDebuffs",

                "CompactUnitFrameProfilesGeneralOptionsFrameAutoActivate2Players",
                "CompactUnitFrameProfilesGeneralOptionsFrameAutoActivate3Players",
                "CompactUnitFrameProfilesGeneralOptionsFrameAutoActivate5Players",
                "CompactUnitFrameProfilesGeneralOptionsFrameAutoActivate10Players",
                "CompactUnitFrameProfilesGeneralOptionsFrameAutoActivate15Players",
                "CompactUnitFrameProfilesGeneralOptionsFrameAutoActivate25Players",
                "CompactUnitFrameProfilesGeneralOptionsFrameAutoActivate40Players",

                "CompactUnitFrameProfilesGeneralOptionsFrameAutoActivateSpec1",
                "CompactUnitFrameProfilesGeneralOptionsFrameAutoActivateSpec2",
                "CompactUnitFrameProfilesGeneralOptionsFrameAutoActivateSpec3",

                "CompactUnitFrameProfilesGeneralOptionsFrameAutoActivatePvP",
                "CompactUnitFrameProfilesGeneralOptionsFrameAutoActivatePvE"
            }
            for i = 1, #boxes do
                F.ReskinCheck(_G[boxes[i]])
            end

            F.Reskin(_G.CompactUnitFrameProfilesSaveButton)
            F.Reskin(_G.CompactUnitFrameProfilesDeleteButton)
            F.Reskin(_G.CompactUnitFrameProfilesGeneralOptionsFrameResetPositionButton)
            F.ReskinDropDown(_G.CompactUnitFrameProfilesProfileSelector)
            F.ReskinDropDown(_G.CompactUnitFrameProfilesGeneralOptionsFrameSortByDropdown)
            F.ReskinDropDown(_G.CompactUnitFrameProfilesGeneralOptionsFrameHealthTextDropdown)
            F.ReskinSlider(_G.CompactUnitFrameProfilesGeneralOptionsFrameHeightSlider)
            F.ReskinSlider(_G.CompactUnitFrameProfilesGeneralOptionsFrameWidthSlider)
        end

        restyled = true
    end)

    _G.hooksecurefunc("InterfaceOptions_AddCategory", function()
        local num = #_G.INTERFACEOPTIONS_ADDONCATEGORIES
        for i = 1, num do
            local bu = _G["InterfaceOptionsFrameAddOnsButton"..i.."Toggle"]
            if bu and not bu._auroraSkinned then
                F.ReskinExpandOrCollapse(bu)
                bu._auroraSkinned = true
            end
            --bu:SetPushedTexture("")
        end
    end)
end
