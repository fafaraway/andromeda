local F, C = unpack(select(2, ...))

local function reskinSubscribeButton(button)
    F.CreateBDFrame(button, 0.25)
    button.ButtonText:SetTextColor(1, 0.8, 0)
end

C.Themes['Blizzard_SubscriptionInterstitialUI'] = function()
    local frame = _G.SubscriptionInterstitialFrame

    F.StripTextures(frame)
    frame.ShadowOverlay:Hide()
    F.SetBD(frame)
    F.Reskin(frame.ClosePanelButton)
    F.ReskinClose(frame.CloseButton)

    reskinSubscribeButton(frame.UpgradeButton)
    reskinSubscribeButton(frame.SubscribeButton)
end
