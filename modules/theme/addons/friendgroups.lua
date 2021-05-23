local _G = _G
local select = select
local unpack = unpack
local strfind = strfind
local IsAddOnLoaded = IsAddOnLoaded
local hooksecurefunc = hooksecurefunc

local F = unpack(select(2, ...))
local THEME = F:GetModule('Theme')

function THEME:ReskinFriendGroups()
    if not _G.FREE_ADB.ReskinAddons then
        return
    end
    if not IsAddOnLoaded('FriendGroups') then
        return
    end

    if _G.FriendGroups_UpdateFriendButton then
        local function replaceButtonStatus(self, texture)
            self:SetPoint('TOPLEFT', 4, 1)
            self.bg:Show()
            if strfind(texture, 'PlusButton') then
                self:SetAtlas('Soulbinds_Collection_CategoryHeader_Collapse', true)
            elseif strfind(texture, 'MinusButton') then
                self:SetAtlas('Soulbinds_Collection_CategoryHeader_Expand', true)
            else
                self:SetPoint('TOPLEFT', 4, -3)
                self.bg:Hide()
            end
        end

        hooksecurefunc('FriendGroups_UpdateFriendButton', function(button)
            if not button.styled then
                local bg = F.CreateBDFrame(button.status, .25)
                bg:SetInside(button.status, 3, 3)
                button.status.bg = bg
                hooksecurefunc(button.status, 'SetTexture', replaceButtonStatus)

                button.styled = true
            end
        end)
    end
end
