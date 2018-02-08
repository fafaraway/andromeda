local _, private = ...

-- [[ Lua Globals ]]
local pairs = _G.pairs

-- [[ Core ]]
local F, C = _G.unpack(private.Aurora)

function private.FrameXML.RolePoll()
    F.CreateBD(_G.RolePollPopup)
    F.Reskin(_G.RolePollPopupAcceptButton)
    F.ReskinClose(_G.RolePollPopupCloseButton)

    for _, roleButton in pairs({_G.RolePollPopupRoleButtonTank, _G.RolePollPopupRoleButtonHealer, _G.RolePollPopupRoleButtonDPS}) do
        roleButton.cover:SetTexture(C.media.roleIcons)
        roleButton:SetNormalTexture(C.media.roleIcons)

        roleButton.checkButton:SetFrameLevel(roleButton:GetFrameLevel() + 2)

        local left = roleButton:CreateTexture(nil, "OVERLAY")
        left:SetWidth(1)
        left:SetTexture(C.media.backdrop)
        left:SetVertexColor(0, 0, 0)
        left:SetPoint("TOPLEFT", 9, -7)
        left:SetPoint("BOTTOMLEFT", 9, 11)

        local right = roleButton:CreateTexture(nil, "OVERLAY")
        right:SetWidth(1)
        right:SetTexture(C.media.backdrop)
        right:SetVertexColor(0, 0, 0)
        right:SetPoint("TOPRIGHT", -9, -7)
        right:SetPoint("BOTTOMRIGHT", -9, 11)

        local top = roleButton:CreateTexture(nil, "OVERLAY")
        top:SetHeight(1)
        top:SetTexture(C.media.backdrop)
        top:SetVertexColor(0, 0, 0)
        top:SetPoint("TOPLEFT", 9, -7)
        top:SetPoint("TOPRIGHT", -9, -7)

        local bottom = roleButton:CreateTexture(nil, "OVERLAY")
        bottom:SetHeight(1)
        bottom:SetTexture(C.media.backdrop)
        bottom:SetVertexColor(0, 0, 0)
        bottom:SetPoint("BOTTOMLEFT", 9, 11)
        bottom:SetPoint("BOTTOMRIGHT", -9, 11)

        F.ReskinRadio(roleButton.checkButton)
    end
end
