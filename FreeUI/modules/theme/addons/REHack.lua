local F, C = unpack(select(2, ...))
local THEME = F.THEME


function THEME:ReskinREHack()
	local RE = _G.REHack
	if not _G.REHack then return end
	F.StripTextures(_G.HackListFrame, true)
	F.SetBD(_G.HackListFrame)

	F.StripTextures(_G.HackEditFrame, true)
	F.SetBD(_G.HackEditFrame)

	hooksecurefunc(_G.HackEditFrame, 'Show', function(self)
		_G.HackEditFrame:ClearAllPoints()
		_G.HackEditFrame:SetPoint('TOPLEFT', _G.HackListFrame, 'TOPRIGHT', 5, 0)
	end)

	F.ReskinClose(_G.HackListFrameClose)
	F.ReskinClose(_G.HackEditFrameClose)

	F.ReskinCheck(_G.HackSearchName, true)
	_G.HackSearchName:SetSize(20, 20)
	F.ReskinCheck(_G.HackSearchBody, true)
	_G.HackSearchBody:SetSize(20, 20)

	F.ReskinEditBox(_G.HackSearchEdit)
	_G.HackSearchEdit:SetSize(120, 16)

	F.ReskinScroll(_G.HackEditScrollFrameScrollBar)

	F.ReskinTab(_G.HackListFrameTab1)
	F.ReskinTab(_G.HackListFrameTab2)
	_G.HackListFrameTab2:ClearAllPoints()
	_G.HackListFrameTab2:SetPoint('LEFT', _G.HackListFrameTab1, 'RIGHT', -4, 0)

	_G.HackEditBoxLineBG:SetColorTexture(0, 0, 0, 0.25)

end


