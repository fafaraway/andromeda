local _, private = ...

-- [[ Core ]]
local F, C = _G.unpack(private.Aurora)

function private.FrameXML.AutoComplete()
    local r, g, b = C.r, C.g, C.b
    F.CreateBD(_G.AutoCompleteBox)

    _G.hooksecurefunc("AutoComplete_Update", function()
        if not _G.AutoCompleteBox._skinned then
            for i = 1, 5 do
                local btn = _G["AutoCompleteButton"..i]

                local hl = btn:GetHighlightTexture()
                hl:SetPoint("TOPLEFT", 1, 0)
                hl:SetPoint("BOTTOM", 0, 0)
                hl:SetPoint("RIGHT", _G.AutoCompleteBox, -1, 0)
                hl:SetColorTexture(r, g, b, .2)
            end
            _G.AutoCompleteBox._skinned = true
        end
    end)
end
