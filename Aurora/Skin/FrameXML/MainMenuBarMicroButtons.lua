local _, private = ...

-- [[ Core ]]
local Aurora = private.Aurora
local Base, Hook, Skin = Aurora.Base, Aurora.Hook, Aurora.Skin

local function SetTexture(texture, anchor, left, right, top, bottom)
    if left then
        texture:SetTexCoord(left, right, top, bottom)
    end
    texture:ClearAllPoints()
    texture:SetPoint("TOPLEFT", anchor, 1, -1)
    texture:SetPoint("BOTTOMRIGHT", anchor, -1, 1)
end
local function SetMicroButton(button, file, left, right, top, bottom)
    if file == "" then
        if not left then
            left, right, top, bottom = 0.2, 0.8, 0.5, 0.9
        end
        SetTexture(button:GetNormalTexture(), button._auroraBDFrame, left, right, top, bottom)
        SetTexture(button:GetPushedTexture(), button._auroraBDFrame, left, right, top, bottom)
        SetTexture(button:GetDisabledTexture(), button._auroraBDFrame, left, right, top, bottom)
    elseif file then
        if not left then
            left, right, top, bottom = 0.2, 0.8, 0.08, 0.92
        end
        button:SetNormalTexture(file)
        SetTexture(button:GetNormalTexture(), button._auroraBDFrame, left, right - 0.04, top + 0.04, bottom)

        button:SetPushedTexture(file)
        local pushed = button:GetPushedTexture()
        SetTexture(pushed, button._auroraBDFrame, left + 0.04, right, top, bottom - 0.04)
        pushed:SetVertexColor(0.5, 0.5, 0.5)

        button:SetDisabledTexture(file)
        local disabled = button:GetDisabledTexture()
        SetTexture(disabled, button._auroraBDFrame, left, right, top, bottom)
        disabled:SetDesaturated(true)
    else
        button:SetNormalTexture("")
        button:SetPushedTexture("")
        button:SetDisabledTexture("")
    end
end

do --[[ FrameXML\MainMenuBarMicroButtons.lua ]]
    function Hook.MoveMicroButtons(anchor, anchorTo, relAnchor, x, y, isStacked)
        _G.LFDMicroButton:ClearAllPoints()
        if isStacked then
            if private.isPatch then
                _G.LFDMicroButton:SetPoint("TOPLEFT", _G.CharacterMicroButton, "BOTTOMLEFT", 0, -1)
            else
                _G.LFDMicroButton:SetPoint("TOPLEFT", _G.CharacterMicroButton, "BOTTOMLEFT", 0, 22)
            end
        else
            _G.LFDMicroButton:SetPoint("BOTTOMLEFT", _G.GuildMicroButton, "BOTTOMRIGHT", -2, 0)
        end
    end
    function Hook.MainMenuMicroButton_OnUpdate(self, elapsed)
        if self.updateInterval == _G.PERFORMANCEBAR_UPDATE_INTERVAL then
            local status = _G.GetFileStreamingStatus()
            if status == 0 then
                status = _G.GetBackgroundLoadingStatus() ~= 0 and 1 or 0
            end

            if status == 0 then
                SetMicroButton(self, [[Interface\Icons\INV_Misc_QuestionMark]])
            else
                SetMicroButton(self, "")
            end
        end
    end
end

do --[[ FrameXML\MainMenuBarMicroButtons.xml ]]
    function Skin.MainMenuBarMicroButton(button)
        -- 24 x 34
        local bd = _G.CreateFrame("Frame", nil, button)
        bd:SetPoint("TOPLEFT", 2, -22)
        bd:SetPoint("BOTTOMRIGHT", -2, 2)
        bd:SetFrameLevel(button:GetFrameLevel())
        Base.SetBackdrop(bd, Aurora.buttonColor:GetRGBA())

        button:SetHighlightTexture("")
        button.Flash:SetTexCoord(0.0938, 0.4375, 0.1094, 0.5625)
        button.Flash:SetPoint("TOPLEFT", bd)
        button.Flash:SetPoint("BOTTOMRIGHT", bd)

        button._auroraBDFrame = bd
        Base.SetHighlight(button, "backdrop")

        --[[ Scale ]]--
        if private.isPatch then
            button:SetSize(26, 30)
        else
            button:SetSize(28, 58)
        end
        button:SetPoint(button:GetPoint())
    end
    function Skin.MicroButtonAlertTemplate(frame)
        Skin.GlowBoxTemplate(frame)

        Skin.UIPanelCloseButton(frame.CloseButton)
        frame.CloseButton:SetPoint("TOPRIGHT", -4, -4)

        Skin.GlowBoxArrowTemplate(frame.Arrow)
        frame.Arrow:SetPoint("TOP", frame, "BOTTOM")

        --[[ Scale ]]--
        frame:SetSize(220, 100)
        frame.Text:SetSize(188, 0)
        frame.Text:SetPoint("TOPLEFT", 16, -24)
    end
end

function private.FrameXML.MainMenuBarMicroButtons()
    if not private.disabled.mainmenubar then
        _G.hooksecurefunc("MoveMicroButtons", Hook.MoveMicroButtons)
        _G.MainMenuMicroButton:HookScript("OnUpdate", Hook.MainMenuMicroButton_OnUpdate)

        for i, name in _G.ipairs(_G.MICRO_BUTTONS) do
            local button = _G[name]
            Skin.MainMenuBarMicroButton(button)

            local iconTexture, left, right, top, bottom
            if name == "CharacterMicroButton" then
                SetTexture(_G.MicroButtonPortrait, button._auroraBDFrame)
            elseif name == "SpellbookMicroButton" then
                iconTexture = [[Interface\Icons\INV_Misc_Book_09]]
            elseif name == "TalentMicroButton" then
                iconTexture = [[Interface\Icons\Ability_Marksmanship]]
            elseif name == "GuildMicroButton" then
                iconTexture = ""
                SetTexture(_G.GuildMicroButtonTabard.background, button._auroraBDFrame, 0.13, 0.87, 0.48, 0.9)

                --[[ Scale ]]--
                _G.GuildMicroButtonTabard:SetSize(28, 58)
                _G.GuildMicroButtonTabard.emblem:SetSize(16, 16)
                _G.GuildMicroButtonTabard.emblem:SetPoint("CENTER", 0, -9)
            elseif name == "EJMicroButton" then
                iconTexture = [[Interface\EncounterJournal\UI-EJ-PortraitIcon]]
            elseif name == "CollectionsMicroButton" then
                iconTexture = [[Interface\Icons\MountJournalPortrait]]
                left, right, top, bottom = 0.3, 0.92, 0.08, 0.92
            elseif name == "MainMenuMicroButton" then
                iconTexture = [[Interface\Icons\INV_Misc_QuestionMark]]

                SetTexture(_G.MainMenuBarPerformanceBar, button._auroraBDFrame, 0.2, 0.8, 0.08, 0.94)
                _G.MainMenuBarDownload:SetPoint("BOTTOM", 0, 4)
                button:SetPoint("BOTTOMLEFT", _G.StoreMicroButton, "BOTTOMRIGHT", -2, 0)
            elseif name == "StoreMicroButton" then
                iconTexture = [[Interface\Icons\WoW_Store]]
            else
                iconTexture = ""
            end

            SetMicroButton(button, iconTexture, left, right, top, bottom)
        end
    end

    Skin.MicroButtonAlertTemplate(_G.TalentMicroButtonAlert)
    Skin.MicroButtonAlertTemplate(_G.CollectionsMicroButtonAlert)
    Skin.MicroButtonAlertTemplate(_G.LFDMicroButtonAlert)
    Skin.MicroButtonAlertTemplate(_G.EJMicroButtonAlert)

    --[[ Scale ]]--
    if not private.isPatch then
        _G.TalentMicroButtonAlert:SetPoint("BOTTOM", _G.TalentMicroButtonAlert.MicroButton, "TOP", 0, -8)
        _G.CollectionsMicroButtonAlert:SetPoint("BOTTOM", _G.CollectionsMicroButtonAlert.MicroButton, "TOP", 0, -8)
        _G.LFDMicroButtonAlert:SetPoint("BOTTOM", _G.LFDMicroButtonAlert.MicroButton, "TOP", 0, -8)
        _G.EJMicroButtonAlert:SetPoint("BOTTOM", _G.EJMicroButtonAlert.MicroButton, "TOP", 0, -8)
    end
end
