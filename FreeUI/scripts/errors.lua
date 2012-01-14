-- FastError by AlleyKat, modified.

local F, C, L = unpack(select(2, ...))

local holdtime = 0.52 -- hold time (seconds)
local fadeintime = 0.08 -- fadein time (seconds)
local fadeouttime = 0.16 -- fade out time (seconds)

UIErrorsFrame:UnregisterEvent("UI_ERROR_MESSAGE")
	
local FirstErrorFrame = CreateFrame ("Frame", nil, UIParent)
FirstErrorFrame:SetScript("OnUpdate", FadingFrame_OnUpdate)
FirstErrorFrame.fadeInTime = fadeintime
FirstErrorFrame.fadeOutTime = fadeouttime
FirstErrorFrame.holdTime = holdtime
FirstErrorFrame:Hide()
FirstErrorFrame:SetFrameStrata("TOOLTIP")
FirstErrorFrame:SetFrameLevel(30)

local SecondErrorFrame = CreateFrame ("Frame", nil, UIParent)
SecondErrorFrame:SetScript("OnUpdate", FadingFrame_OnUpdate)
SecondErrorFrame.fadeInTime = fadeintime
SecondErrorFrame.fadeOutTime = fadeouttime
SecondErrorFrame.holdTime = holdtime
SecondErrorFrame:Hide()
SecondErrorFrame:SetFrameStrata("TOOLTIP")
SecondErrorFrame:SetFrameLevel(30)

local TextOne = F.CreateFS(FirstErrorFrame, 8)
TextOne:SetPoint("TOP", UIParent, 0, -76)
local TextTwo = F.CreateFS(SecondErrorFrame, 8)
TextTwo:SetPoint("TOP", UIParent, 0, -85)

local state = 0
FirstErrorFrame:SetScript("OnHide",function() state = 0 end)
local Error = CreateFrame("Frame")
Error:RegisterEvent("UI_ERROR_MESSAGE")
Error:SetScript("OnEvent", function(_, _, error)
	if state == 0 then 
		TextOne:SetText(error)
		FadingFrame_Show(FirstErrorFrame)
		state = 1
	 else 
		TextTwo:SetText(error)
		FadingFrame_Show(SecondErrorFrame)
		state = 0
	 end
end)