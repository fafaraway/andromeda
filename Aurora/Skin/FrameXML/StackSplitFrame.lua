local _, private = ...

-- [[ Core ]]
local F = _G.unpack(private.Aurora)

function private.FrameXML.StackSplitFrame()
    F.CreateBD(_G.StackSplitFrame)
    _G.StackSplitFrame:GetRegions():Hide()

    local textBG = _G.CreateFrame("Frame", nil, _G.StackSplitFrame)
    textBG:SetPoint("TOPLEFT", 31, -18)
    textBG:SetPoint("BOTTOMRIGHT", -29, 55)
    F.CreateBD(textBG, 0.4)

    _G.StackSplitText:SetParent(textBG)

    F.Reskin(_G.StackSplitOkayButton)
    F.Reskin(_G.StackSplitCancelButton)
end
