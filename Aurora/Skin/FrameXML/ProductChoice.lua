local _, private = ...

-- [[ Core ]]
local F = _G.unpack(private.Aurora)

function private.FrameXML.ProductChoice()
    local ProductChoiceFrame = _G.ProductChoiceFrame

    ProductChoiceFrame.Inset.Bg:Hide()
    ProductChoiceFrame.Inset:DisableDrawLayer("BORDER")

    F.ReskinPortraitFrame(ProductChoiceFrame)
    F.Reskin(ProductChoiceFrame.Inset.ClaimButton)
end
