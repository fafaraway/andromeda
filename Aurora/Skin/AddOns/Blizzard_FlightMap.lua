local _, private = ...

-- [[ Core ]]
local Aurora = private.Aurora
local F, C = _G.unpack(Aurora)

function private.AddOns.Blizzard_FlightMap()
	F.SetBD(_G.FlightMapFrame, -5, 10, 5, -5)
	-- F.ReskinClose(_G.FlightMapFrameCloseButton, "TOPRIGHT", _G.FlightMapFrame, "TOPRIGHT", -14, -4)
	_G.FlightMapFrameCloseButton:Hide()
	_G.FlightMapFrameLeftBorder:Hide()
	_G.FlightMapFrameRightBorder:Hide()
	_G.FlightMapFrameTopBorder:Hide()
	_G.FlightMapFrameBottomBorder:Hide()
	_G.FlightMapFrameBotLeftCorner:Hide()
	_G.FlightMapFrameBotRightCorner:Hide()
	_G.FlightMapFrameTopRightCorner:Hide()
	_G.FlightMapFramePortrait:Hide()
	_G.FlightMapFramePortraitFrame:Hide()
	_G.FlightMapFrameTitleBg:Hide()
	_G.FlightMapFrame.BorderFrame.TopBorder:Hide()
end