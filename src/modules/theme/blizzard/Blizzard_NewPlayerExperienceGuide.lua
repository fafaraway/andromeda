local F, C = unpack(select(2, ...))

C.Themes['Blizzard_NewPlayerExperience'] = function()
    F.Reskin(_G.KeyboardMouseConfirmButton)

    if _G.NPE_TutorialWalk_Frame then
        _G.NPE_TutorialWalk_Frame.ContainerFrame.TURNLEFT.KeyBind:SetTextColor(1, 0.8, 0)
        _G.NPE_TutorialWalk_Frame.ContainerFrame.TURNRIGHT.KeyBind:SetTextColor(1, 0.8, 0)
        _G.NPE_TutorialWalk_Frame.ContainerFrame.MOVEFORWARD.KeyBind:SetTextColor(1, 0.8, 0)
        _G.NPE_TutorialWalk_Frame.ContainerFrame.MOVEBACKWARD.KeyBind:SetTextColor(1, 0.8, 0)
        _G.NPE_TutorialSingleKey_Frame.ContainerFrame.KeyBind.KeyBind:SetTextColor(1, 0.8, 0)
    end
end

C.Themes['Blizzard_NewPlayerExperienceGuide'] = function()
    local GuideFrame = _G.GuideFrame

    F.ReskinPortraitFrame(GuideFrame)
    GuideFrame.Title:SetTextColor(1, 0.8, 0)
    GuideFrame.ScrollFrame.Child.Text:SetTextColor(1, 1, 1)
    F.ReskinScroll(GuideFrame.ScrollFrame.ScrollBar)
    F.Reskin(GuideFrame.ScrollFrame.ConfirmationButton)
end
