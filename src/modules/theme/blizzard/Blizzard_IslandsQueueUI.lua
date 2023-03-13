local F, C = unpack(select(2, ...))

C.Themes['Blizzard_IslandsQueueUI'] = function()
    local IslandsQueueFrame = _G.IslandsQueueFrame

    F.ReskinPortraitFrame(IslandsQueueFrame)
    IslandsQueueFrame.ArtOverlayFrame.PortraitFrame:SetAlpha(0)
    IslandsQueueFrame.ArtOverlayFrame.portrait:SetAlpha(0)
    F.ReskinButton(IslandsQueueFrame.DifficultySelectorFrame.QueueButton)
    IslandsQueueFrame.HelpButton.Ring:SetAlpha(0)

    local tutorial = IslandsQueueFrame.TutorialFrame
    F.ReskinClose(tutorial.CloseButton)
    local closeButton = tutorial:GetChildren()
    F.ReskinButton(closeButton)
    tutorial.TutorialText:SetTextColor(1, 1, 1)
end
