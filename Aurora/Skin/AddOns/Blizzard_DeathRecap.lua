local _, private = ...

-- [[ Core ]]
local F = _G.unpack(private.Aurora)

function private.AddOns.Blizzard_DeathRecap()
    local DeathRecapFrame = _G.DeathRecapFrame

    DeathRecapFrame:DisableDrawLayer("BORDER")
    DeathRecapFrame.Background:Hide()
    DeathRecapFrame.BackgroundInnerGlow:Hide()
    DeathRecapFrame.Divider:Hide()

    F.CreateBD(DeathRecapFrame)
    F.CreateSD(DeathRecapFrame)
    F.Reskin(_G.select(8, DeathRecapFrame:GetChildren())) -- bottom close button has no parentKey
    F.ReskinClose(DeathRecapFrame.CloseXButton)

    for i = 1, _G.NUM_DEATH_RECAP_EVENTS do
        local recap = DeathRecapFrame["Recap"..i].SpellInfo
        recap.IconBorder:Hide()
        recap.Icon:SetTexCoord(.08, .92, .08, .92)
        F.CreateBG(recap.Icon)
    end
end
