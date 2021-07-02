local _G = _G
local unpack = unpack
local select = select
local hooksecurefunc = hooksecurefunc

local F, C = unpack(select(2, ...))

local function ReskinTableAttribute(frame)
    if frame.styled then
        return
    end

    F.StripTextures(frame)
    F.SetBD(frame)
    F.ReskinClose(frame.CloseButton)
    F.ReskinCheck(frame.VisibilityButton)
    F.ReskinCheck(frame.HighlightButton)
    F.ReskinCheck(frame.DynamicUpdateButton)
    F.ReskinInput(frame.FilterBox)

    F.ReskinArrow(frame.OpenParentButton, 'up')
    F.ReskinArrow(frame.NavigateBackwardButton, 'left')
    F.ReskinArrow(frame.NavigateForwardButton, 'right')
    F.ReskinArrow(frame.DuplicateButton, 'up')

    frame.NavigateBackwardButton:ClearAllPoints()
    frame.NavigateBackwardButton:SetPoint('LEFT', frame.OpenParentButton, 'RIGHT')
    frame.NavigateForwardButton:ClearAllPoints()
    frame.NavigateForwardButton:SetPoint('LEFT', frame.NavigateBackwardButton, 'RIGHT')
    frame.DuplicateButton:ClearAllPoints()
    frame.DuplicateButton:SetPoint('LEFT', frame.NavigateForwardButton, 'RIGHT')

    F.StripTextures(frame.ScrollFrameArt)
    F.CreateBDFrame(frame.ScrollFrameArt, .25)
    F.ReskinScroll(frame.LinesScrollFrame.ScrollBar)

    frame.styled = true
end

C.Themes['Blizzard_DebugTools'] = function()
    -- Table Attribute Display
    ReskinTableAttribute(_G.TableAttributeDisplay)
    hooksecurefunc(_G.TableInspectorMixin, 'InspectTable', ReskinTableAttribute)
end
