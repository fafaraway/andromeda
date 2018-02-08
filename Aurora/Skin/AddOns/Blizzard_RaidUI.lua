local _, private = ...

-- [[ Core ]]
local F = _G.unpack(private.Aurora)

function private.AddOns.Blizzard_RaidUI()
    local function onEnter(self)
        if self.class then
            self:SetBackdropBorderColor(_G.CUSTOM_CLASS_COLORS[self.class].r, _G.CUSTOM_CLASS_COLORS[self.class].g, _G.CUSTOM_CLASS_COLORS[self.class].b)
        else
            self:SetBackdropBorderColor(0.5, 0.5, 0.5)
        end
    end
    local function onLeave(self)
        self:SetBackdropBorderColor(0, 0, 0)
    end

    for grpNum = 1, 8 do
        local name = "RaidGroup"..grpNum
        local group = _G[name]
        group:GetRegions():Hide()
        for slotNum = 1, 5 do
            local slot = _G[name.."Slot"..slotNum]
            slot:SetHighlightTexture("")
            F.CreateBD(slot, 0.5)

            slot:HookScript("OnEnter", onEnter)
            slot:HookScript("OnLeave", onLeave)
        end
    end
    for btnNum = 1, 40 do
        local name = "RaidGroupButton"..btnNum
        local btn = _G[name]
        F.Reskin(btn, true)

        btn:HookScript("OnEnter", onEnter)
        btn:HookScript("OnLeave", onLeave)
        --raidButtons[btnNum] = btn
    end
end
