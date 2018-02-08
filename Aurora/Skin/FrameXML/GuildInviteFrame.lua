local _, private = ...

-- [[ Core ]]
local Aurora = private.Aurora
local F = _G.unpack(Aurora)
local Skin = private.Aurora.Skin

function private.FrameXML.GuildInviteFrame()
    Skin.TranslucentFrameTemplate(_G.GuildInviteFrame)

    _G.GuildInviteFrameBackground:Hide()

    _G.GuildInviteFrameInviterName:SetPoint("TOP", 0, -20)
    _G.GuildInviteFrameTabardBorder:SetPoint("TOPLEFT", "$parentTabardBackground", 0, 0)
    _G.GuildInviteFrameTabardBorder:SetSize(62, 62)

    _G.GuildInviteFrameTabardRing:Hide()

    F.Reskin(_G.GuildInviteFrameJoinButton)
    F.Reskin(_G.GuildInviteFrameDeclineButton)
end
