local F, C = unpack(select(2, ...))

C.Themes['Blizzard_TorghastLevelPicker'] = function()
    local frame = _G.TorghastLevelPickerFrame

    F.ReskinClose(frame.CloseButton, frame, -60, -60)
    F.ReskinButton(frame.OpenPortalButton)
    F.ReskinArrow(frame.Pager.PreviousPage, 'left')
    F.ReskinArrow(frame.Pager.NextPage, 'right')
end
