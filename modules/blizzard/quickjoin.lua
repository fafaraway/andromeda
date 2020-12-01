local F, C, L = unpack(select(2, ...))
local BLIZZARD = F:GetModule('BLIZZARD')


function BLIZZARD:HookApplicationClick()
	if LFGListFrame.SearchPanel.SignUpButton:IsEnabled() then
		LFGListFrame.SearchPanel.SignUpButton:Click()
	end
	if LFGListApplicationDialog:IsShown() and LFGListApplicationDialog.SignUpButton:IsEnabled() then
		LFGListApplicationDialog.SignUpButton:Click()
	end
end

local pendingFrame
function BLIZZARD:DialogHideInSecond()
	if not pendingFrame then return end

	if pendingFrame.informational then
		StaticPopupSpecial_Hide(pendingFrame)
	elseif pendingFrame == 'LFG_LIST_ENTRY_EXPIRED_TOO_MANY_PLAYERS' then
		StaticPopup_Hide(pendingFrame)
	end
	pendingFrame = nil
end

function BLIZZARD:HookDialogOnShow()
	pendingFrame = self
	C_Timer.After(1, BLIZZARD.DialogHideInSecond)
end

function BLIZZARD:QuickJoin()
	for i = 1, 10 do
		local bu = _G['LFGListSearchPanelScrollFrameButton'..i]
		if bu then
			bu:HookScript('OnDoubleClick', BLIZZARD.HookApplicationClick)
		end
	end

	hooksecurefunc('LFGListInviteDialog_Accept', function()
		if PVEFrame:IsShown() then HideUIPanel(PVEFrame) end
	end)

	hooksecurefunc('StaticPopup_Show', BLIZZARD.HookDialogOnShow)
	hooksecurefunc('LFGListInviteDialog_Show', BLIZZARD.HookDialogOnShow)
end

BLIZZARD:RegisterBlizz('QuickJoin', BLIZZARD.QuickJoin)
