local F, C = unpack(select(2, ...))

local function replaceCheckText(self, text)
    if not text then
        return
    end

    local newText, count = gsub(text, '|TInterface.+UI%-CheckBox%-Check.-|t', '|A:checkmark-minimal:20:20:0:-3|a')
    if count > 0 then
        self:SetFormattedText('%s', newText)
    end
end

tinsert(C.BlizzThemes, function()
    if not _G.ANDROMEDA_ADB.ReskinBlizz then
        return
    end

    local dropdowns = { 'DropDownList', 'L_DropDownList', 'Lib_DropDownList' }
    hooksecurefunc('UIDropDownMenu_CreateFrames', function()
        for _, name in next, dropdowns do
            for i = 1, _G.UIDROPDOWNMENU_MAXLEVELS do
                local backdrop = _G[name .. i .. 'Backdrop']
                if backdrop and not backdrop.styled then
                    F.StripTextures(backdrop)
                    F.SetBD(backdrop, 0.7)

                    backdrop.styled = true
                end
            end
        end
    end)

    hooksecurefunc('ToggleDropDownMenu', function(level)
        if not level then
            level = 1
        end

        local listFrame = _G['DropDownList' .. level]
        for i = 1, _G.UIDROPDOWNMENU_MAXBUTTONS do
            local name = 'DropDownList' .. level .. 'Button' .. i
            local bu = _G[name]
            local _, _, _, x = bu:GetPoint()
            if bu:IsShown() and x then
                local check = _G[name .. 'Check']
                local uncheck = _G[name .. 'UnCheck']
                local hl = _G[name .. 'Highlight']
                local arrow = _G[name .. 'ExpandArrow']

                if not bu.bg then
                    bu.bg = F.CreateBDFrame(bu)
                    bu.bg:ClearAllPoints()
                    bu.bg:SetPoint('CENTER', check)
                    bu.bg:SetSize(12, 12)
                    hl:SetColorTexture(C.r, C.g, C.b, 0.25)

                    if arrow then
                        F.SetupArrow(arrow:GetNormalTexture(), 'right')
                        arrow:SetSize(14, 14)
                    end

                    replaceCheckText(bu, bu:GetText())
                    hooksecurefunc(bu, 'SetText', replaceCheckText)
                end

                bu.bg:Hide()
                hl:SetPoint('TOPLEFT', -x + C.MULT, 0)
                hl:SetPoint('BOTTOMRIGHT', listFrame:GetWidth() - bu:GetWidth() - x - C.MULT, 0)
                if uncheck then
                    uncheck:SetTexture('')
                end

                if not bu.notCheckable then
                    -- only reliable way to see if button is radio or or check...
                    local _, co = check:GetTexCoord()
                    if co == 0 then
                        if C.IS_NEW_PATCH then
                            check:SetAtlas('checkmark-minimal')
                        else
                            check:SetTexture('Interface\\Buttons\\UI-CheckBox-Check')
                        end
                        check:SetVertexColor(C.r, C.g, C.b, 1)
                        check:SetSize(20, 20)
                        check:SetDesaturated(true)
                    else
                        check:SetColorTexture(C.r, C.g, C.b, 0.6)
                        check:SetSize(10, 10)
                        check:SetDesaturated(false)
                    end

                    check:SetTexCoord(0, 1, 0, 1)
                    bu.bg:Show()
                end
            end
        end
    end)

    hooksecurefunc('UIDropDownMenu_SetIconImage', function(icon, texture)
        if texture:find('Divider') then
            icon:SetColorTexture(1, 1, 1, 0.2)
            icon:SetHeight(C.MULT)
        end
    end)
end)
