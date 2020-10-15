local F, C = unpack(select(2, ...))
local THEME = F.THEME

local _G = getfenv(0)

function THEME:ReskinWowLua()
	if not IsAddOnLoaded('WowLua') then return end
	if not FreeADB.appearance.reskin_wowlua then return end

	F.ReskinPortraitFrame(_G.WowLuaFrame)

	_G.WowLuaFrameTitle:SetPoint('TOP', 15, -5)

	F.ReskinClose(_G.WowLuaButton_Close)
	_G.WowLuaButton_Close:SetPoint('TOPRIGHT', -5 , -5)

	F.StripTextures(_G.WowLuaFrameResizeBar)
	F.ReskinScroll(_G.WowLuaFrameEditScrollFrameScrollBar)
	_G.WowLuaFrameLineNumScrollFrame:DisableDrawLayer('ARTWORK')

	_G.WowLuaFrameLineNumScrollFrame.bg = F.CreateBDFrame(_G.WowLuaFrameLineNumScrollFrame, .3)
	_G.WowLuaFrameLineNumScrollFrame.bg:SetPoint('TOPLEFT', -1, 3)
	_G.WowLuaFrameLineNumScrollFrame.bg:SetPoint('BOTTOMRIGHT', -2, -2)

	_G.WowLuaFrameEditFocusGrabber.bg = F.CreateBDFrame(_G.WowLuaFrameEditFocusGrabber, .3)
	_G.WowLuaFrameEditFocusGrabber.bg:SetPoint('BOTTOMRIGHT', 6, -6)

	_G.WowLuaFrameOutput.bg = F.CreateBDFrame(_G.WowLuaFrameOutput, .3)
	_G.WowLuaFrameOutput.bg:SetPoint('TOPLEFT', -2, 1)
	_G.WowLuaFrameOutput.bg:SetPoint('BOTTOMRIGHT', -20, 10)

	_G.WowLuaFrameCommand:DisableDrawLayer('BACKGROUND')
	F.ReskinEditBox(_G.WowLuaFrameCommand)
	_G.WowLuaFrameCommand:SetPoint('BOTTOMLEFT', 19, 4)
	_G.WowLuaFrameCommand:SetPoint('BOTTOMRIGHT', -23, 4)

	_G.WowLuaButton_New:SetPoint('LEFT', -30, 5)

	local buttons = {
		_G.WowLuaButton_New,
		_G.WowLuaButton_Open,
		_G.WowLuaButton_Save,
		_G.WowLuaButton_Undo,
		_G.WowLuaButton_Redo,
		_G.WowLuaButton_Delete,
		_G.WowLuaButton_Lock,
		_G.WowLuaButton_Unlock,
		_G.WowLuaButton_Config,
		_G.WowLuaButton_Previous,
		_G.WowLuaButton_Next,
		_G.WowLuaButton_Run,
	}

	for _, object in pairs(buttons) do
		F.ReskinIcon(object:GetNormalTexture())
		if object:GetDisabledTexture() then
			F.ReskinIcon(object:GetDisabledTexture())
		end
		object:GetHighlightTexture():SetColorTexture(1, 1, 1, .25)
	end
end
