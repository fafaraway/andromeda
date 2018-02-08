local _, private = ...

-- [[ Lua Globals ]]
local ipairs = _G.ipairs

-- [[ Core ]]
local F = _G.unpack(private.Aurora)
local skinned = {}

function private.AddOns.Blizzard_ChallengesUI()

    -- Reskin Affixes
    local function AffixesSetup(parent)
        for i, frame in ipairs(parent) do
            frame.Border:SetTexture(nil)
            frame.Portrait:SetTexture(nil)
            if not frame.bg then
                frame.bg = F.ReskinIcon(frame.Portrait)
            end

            if frame.info then
                frame.Portrait:SetTexture(CHALLENGE_MODE_EXTRA_AFFIX_INFO[frame.info.key].texture)
            elseif frame.affixID then
                local _, _, filedataid = C_ChallengeMode.GetAffixInfo(frame.affixID)
                frame.Portrait:SetTexture(filedataid)
            end
        end
    end

    --[[ ChallengesKeystoneFrame ]]--
    local KeystoneFrame = _G.ChallengesKeystoneFrame
    F.CreateBD(KeystoneFrame)
    F.CreateSD(KeystoneFrame)
    F.ReskinClose(KeystoneFrame.CloseButton)
    F.Reskin(KeystoneFrame.StartButton)

    _G.hooksecurefunc(KeystoneFrame, "Reset", function(self)
        self:GetRegions():Hide()
        KeystoneFrame.InstructionBackground:SetAlpha(.2)
    end)
    _G.hooksecurefunc(KeystoneFrame, "OnKeystoneSlotted", function(self)
        for i, affix in ipairs(self.Affixes) do
            affix.Border:Hide()

            affix.Portrait:SetTexture(nil)
            F.ReskinIcon(affix.Portrait)
            if affix.info then
                affix.Portrait:SetTexture(_G.CHALLENGE_MODE_EXTRA_AFFIX_INFO[affix.info.key].texture)
            elseif affix.affixID then
                local _, _, filedataid = _G.C_ChallengeMode.GetAffixInfo(affix.affixID)
                affix.Portrait:SetTexture(filedataid)
            end
        end
    end)

    --[[ ChallengesFrame ]]--
    local ChallengesFrame = _G.ChallengesFrame
    ChallengesFrameInset:DisableDrawLayer("BORDER")
    ChallengesFrameInsetBg:Hide()
    for i = 1, 2 do
        select(i, ChallengesFrame:GetRegions()):Hide()
    end

    select(1, ChallengesFrame.GuildBest:GetRegions()):Hide()
    select(3, ChallengesFrame.GuildBest:GetRegions()):Hide()
    F.CreateBD(ChallengesFrame.GuildBest, .3)
    F.CreateSD(ChallengesFrame.GuildBest)

    -- addon AngryKeystones
    local angryStyle
    ChallengesFrame:HookScript("OnShow", function()
        for i = 1, 13 do
            local bu = ChallengesFrame.DungeonIcons[i]
            if bu and not bu.styled then
                bu:GetRegions():SetAlpha(0)
                bu.Icon:SetTexCoord(.08, .92, .08, .92)
                F.CreateBD(bu, .3)
                bu.styled = true
            end
        end

        if IsAddOnLoaded("AngryKeystones") and not angryStyle then
            local scheduel = select(6, ChallengesFrame:GetChildren())
            select(1, scheduel:GetRegions()):SetAlpha(0)
            select(3, scheduel:GetRegions()):SetAlpha(0)
            F.CreateBD(scheduel, .3)
            F.CreateSD(scheduel)

            if scheduel.Entries then
                for i = 1, 4 do
                    AffixesSetup(scheduel.Entries[i].Affixes)
                end
            end
            angryStyle = true
        end
    end)

    -- Fix position
    ChallengesFrame.WeeklyBest:ClearAllPoints()
    ChallengesFrame.WeeklyBest:SetPoint("TOP", 0, -5)
    ChallengesFrame.GuildBest:SetPoint("TOPLEFT", ChallengesFrame.WeeklyBest.Child.Star, "BOTTOMRIGHT", -16, 30)
end
