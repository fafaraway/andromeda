local F, C, L = unpack(select(2, ...))
local TEST = F:RegisterModule('Test')

do
    -- print('tests')
end

function TEST:OnLogin()
    -- local backDrop = {
    --     bgFile = C.Assets.Textures.Backdrop,
    --     edgeFile = C.Assets.Textures.Backdrop,
    --     edgeSize = 5,
    -- }
    -- local f = CreateFrame('Frame', nil, _G.UIParent, 'BackdropTemplate')
    -- f:SetPoint('CENTER')
    -- f:SetSize(300, 600)
    -- f:SetBackdrop(backDrop)
    -- f:SetBackdropColor(1, 1, 1, 0.25)

    -- local font = C.Assets.Fonts.Bold

    -- f.text1 = F.CreateFS(f, font, 30, nil, 'AndromedaUI', nil, 'NONE', 'TOP', 0, -20)

    -- f.text2 = F.CreateFS(f, font, 30, nil, 'AndromedaUI', nil, 'NORMAL', 'TOP', 0, -60)

    -- f.text3 = F.CreateFS(f, font, 30, nil, 'AndromedaUI', nil, 'THICK', 'TOP', 0, -100)

    -- f.text4 = F.CreateFS(f, font, 30, nil, 'AndromedaUI', nil, nil, 'TOP', 0, -140)

    -- f.text5 = F.CreateFS(f, font, 30, true, 'AndromedaUI', nil, nil, 'TOP', 0, -180)

    -- f.text6 = F.CreateFS(f, nil, nil, nil, 'AndromedaUI', nil, nil, 'TOP', 0, -220)

end
