local F, C = unpack(select(2, ...))
local THEME = F.THEME


function THEME:ReskinREHack()
	if not _G.REHack then return end

	if _G.HackListFrame then
		F.StripTextures(_G.HackListFrame, true)
		F.SetBD(_G.HackListFrame)
		F.ReskinClose(_G.HackListFrameClose)
		F.ReskinCheck(_G.HackSearchName, true)
		_G.HackSearchName:SetSize(20, 20)
		F.ReskinCheck(_G.HackSearchBody, true)
		_G.HackSearchBody:SetSize(20, 20)
		F.ReskinEditBox(_G.HackSearchEdit)
		_G.HackSearchEdit:SetSize(120, 16)
		F.ReskinTab(_G.HackListFrameTab1)
		F.ReskinTab(_G.HackListFrameTab2)
		_G.HackListFrameTab2:ClearAllPoints()
		_G.HackListFrameTab2:SetPoint('LEFT', _G.HackListFrameTab1, 'RIGHT', -4, 0)
	end

	if _G.HackEditFrame then
		F.StripTextures(_G.HackEditFrame, true)
		F.SetBD(_G.HackEditFrame)
		F.ReskinClose(_G.HackEditFrameClose)
		F.ReskinScroll(_G.HackEditScrollFrameScrollBar)
		F.CreateBDFrame(_G.HackEditScrollFrame, .25)
		_G.HackEditBoxLineBG:SetColorTexture(0, 0, 0, .25)

		local SetPoint = _G.HackEditFrame.SetPoint
		_G.HackEditFrame.SetPoint = function(frame, point, relativeFrame, relativePoint, x, y)
			if point == 'TOPLEFT' and relativePoint == 'TOPRIGHT' and x and y == 0 then
				x = x + 6
			end
			SetPoint(frame, point, relativeFrame, relativePoint, x, y)
		end
		local tempPos = {_G.HackEditFrame:GetPoint()}
		_G.HackEditFrame:ClearAllPoints()
		_G.HackEditFrame:SetPoint(unpack(tempPos))
	end
end


