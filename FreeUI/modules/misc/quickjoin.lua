local F, C = unpack(select(2, ...))
local MISC = F:GetModule('Misc')


function MISC:HookApplicationClick()
	if LFGListFrame.SearchPanel.SignUpButton:IsEnabled() then
		LFGListFrame.SearchPanel.SignUpButton:Click()
	end
	if LFGListApplicationDialog:IsShown() and LFGListApplicationDialog.SignUpButton:IsEnabled() then
		LFGListApplicationDialog.SignUpButton:Click()
	end
end

local pendingFrame
function MISC:DialogHideInSecond()
	if not pendingFrame then return end

	if pendingFrame.informational then
		StaticPopupSpecial_Hide(pendingFrame)
	elseif pendingFrame == 'LFG_LIST_ENTRY_EXPIRED_TOO_MANY_PLAYERS' then
		StaticPopup_Hide(pendingFrame)
	end
	pendingFrame = nil
end

function MISC:HookDialogOnShow()
	pendingFrame = self
	C_Timer.After(1, MISC.DialogHideInSecond)
end

function MISC:QuickJoin()
	if C.Client == 'zhCN' then
		StaticPopupDialogs['LFG_LIST_ENTRY_EXPIRED_TOO_MANY_PLAYERS'].text = '针对此项活动，你的队伍人数已满，将被移出列表。'
	end

	for i = 1, 10 do
		local bu = _G['LFGListSearchPanelScrollFrameButton'..i]
		if bu then
			bu:HookScript('OnDoubleClick', MISC.HookApplicationClick)
		end
	end

	hooksecurefunc('LFGListInviteDialog_Accept', function()
		if PVEFrame:IsShown() then HideUIPanel(PVEFrame) end
	end)

	hooksecurefunc('StaticPopup_Show', MISC.HookDialogOnShow)
	hooksecurefunc('LFGListInviteDialog_Show', MISC.HookDialogOnShow)
end
MISC:RegisterMisc('QuickJoin', MISC.QuickJoin)
