local F, C = unpack(select(2, ...))

C.Themes['Blizzard_RaidUI'] = function()
    local r, g, b = C.r, C.g, C.b

    for i = 1, _G.NUM_RAID_GROUPS do
        local group = _G['RaidGroup' .. i]
        group:GetRegions():SetAlpha(0)
        for j = 1, _G.MEMBERS_PER_RAID_GROUP do
            local slot = _G['RaidGroup' .. i .. 'Slot' .. j]
            select(1, slot:GetRegions()):SetAlpha(0)
            select(2, slot:GetRegions()):SetColorTexture(r, g, b, 0.25)
            F.CreateBDFrame(slot, 0.2)
        end
    end

    for i = 1, _G.MAX_RAID_MEMBERS do
        local bu = _G['RaidGroupButton' .. i]
        select(4, bu:GetRegions()):SetAlpha(0)
        select(5, bu:GetRegions()):SetColorTexture(r, g, b, 0.2)
        F.CreateBDFrame(bu)
    end
end
