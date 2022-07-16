local F, C = unpack(select(2, ...))

tinsert(C.BlizzThemes, function()
    hooksecurefunc('QueueStatusFrame_Update', function()
        for frame in _G.QueueStatusFrame.statusEntriesPool:EnumerateActive() do
            frame.HealersFound.Texture:SetTexture(C.Assets.Texture.Roles)
            frame.TanksFound.Texture:SetTexture(C.Assets.Texture.Roles)
            frame.DamagersFound.Texture:SetTexture(C.Assets.Texture.Roles)
            frame.HealersFound.Texture:SetTexCoord(_G.LFDQueueFrameRoleButtonHealer.background:GetTexCoord())
            frame.TanksFound.Texture:SetTexCoord(_G.LFDQueueFrameRoleButtonTank.background:GetTexCoord())
            frame.DamagersFound.Texture:SetTexCoord(_G.LFDQueueFrameRoleButtonDPS.background:GetTexCoord())
        end
    end)

    hooksecurefunc('QueueStatusEntry_SetFullDisplay', function(entry, _, _, _, isTank, isHealer, isDPS)
        if not entry then
            return
        end
        local nextRoleIcon = 1
        if isDPS then
            local icon = entry['RoleIcon' .. nextRoleIcon]
            if icon then
                icon:SetTexture(C.Assets.Texture.Roles)
                icon:SetTexCoord(_G.LFDQueueFrameRoleButtonDPS.background:GetTexCoord())
                nextRoleIcon = nextRoleIcon + 1
            end
        end
        if isHealer then
            local icon = entry['RoleIcon' .. nextRoleIcon]
            if icon then
                icon:SetTexture(C.Assets.Texture.Roles)
                icon:SetTexCoord(_G.LFDQueueFrameRoleButtonHealer.background:GetTexCoord())
                nextRoleIcon = nextRoleIcon + 1
            end
        end
        if isTank then
            local icon = entry['RoleIcon' .. nextRoleIcon]
            if icon then
                icon:SetTexture(C.Assets.Texture.Roles)
                icon:SetTexCoord(_G.LFDQueueFrameRoleButtonTank.background:GetTexCoord())
            end
        end
    end)
end)
