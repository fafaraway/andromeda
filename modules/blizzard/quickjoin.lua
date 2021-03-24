local _G = _G
local unpack = unpack
local select = select
local hooksecurefunc = hooksecurefunc
local StaticPopup_Hide = StaticPopup_Hide
local StaticPopupSpecial_Hide = StaticPopupSpecial_Hide
local HideUIPanel = HideUIPanel
local C_Timer_After = C_Timer.After

local F = unpack(select(2, ...))
local BLIZZARD = F.BLIZZARD

function BLIZZARD:HookApplicationClick()
    if _G.LFGListFrame.SearchPanel.SignUpButton:IsEnabled() then
        _G.LFGListFrame.SearchPanel.SignUpButton:Click()
    end
    if _G.LFGListApplicationDialog:IsShown() and _G.LFGListApplicationDialog.SignUpButton:IsEnabled() then
        _G.LFGListApplicationDialog.SignUpButton:Click()
    end
end

local pendingFrame
function BLIZZARD:DialogHideInSecond()
    if not pendingFrame then
        return
    end

    if pendingFrame.informational then
        StaticPopupSpecial_Hide(pendingFrame)
    elseif pendingFrame == 'LFG_LIST_ENTRY_EXPIRED_TOO_MANY_PLAYERS' then
        StaticPopup_Hide(pendingFrame)
    end
    pendingFrame = nil
end

function BLIZZARD:HookDialogOnShow()
    pendingFrame = self
    C_Timer_After(1, BLIZZARD.DialogHideInSecond)
end

function BLIZZARD:QuickJoin()
    for i = 1, 10 do
        local bu = _G['LFGListSearchPanelScrollFrameButton' .. i]
        if bu then
            bu:HookScript('OnDoubleClick', BLIZZARD.HookApplicationClick)
        end
    end

    hooksecurefunc('LFGListInviteDialog_Accept', function()
        if _G.PVEFrame:IsShown() then
            HideUIPanel(_G.PVEFrame)
        end
    end)

    hooksecurefunc('StaticPopup_Show', BLIZZARD.HookDialogOnShow)
    hooksecurefunc('LFGListInviteDialog_Show', BLIZZARD.HookDialogOnShow)
end

BLIZZARD:RegisterBlizz('QuickJoin', BLIZZARD.QuickJoin)
