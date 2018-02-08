local _, private = ...

--[[ Lua Globals ]]
-- luacheck: globals type floor mod

-- [[ Core ]]
local Aurora = private.Aurora
local Base, Scale = Aurora.Base, Aurora.Scale
local Hook, Skin = Aurora.Hook, Aurora.Skin

do --[[ FrameXML\MoneyFrame.lua ]]
    function Hook.MoneyFrame_Update(frameName, money, forceShow)
        local frame
        if ( type(frameName) == "table" ) then
            frame = frameName
            frameName = frame:GetName()
        else
            frame = _G[frameName]
        end
        local info = frame.info

        -- Breakdown the money into denominations
        local gold = floor(money / (_G.COPPER_PER_SILVER * _G.SILVER_PER_GOLD))
        local silver = floor((money - (gold * _G.COPPER_PER_SILVER * _G.SILVER_PER_GOLD)) / _G.COPPER_PER_SILVER)
        local copper = mod(money, _G.COPPER_PER_SILVER)

        local goldButton = _G[frameName.."GoldButton"]
        local silverButton = _G[frameName.."SilverButton"]
        local copperButton = _G[frameName.."CopperButton"]

        local iconWidth = _G.MONEY_ICON_WIDTH
        local spacing = _G.MONEY_BUTTON_SPACING
        if ( frame.small ) then
            iconWidth = _G.MONEY_ICON_WIDTH_SMALL
            spacing = _G.MONEY_BUTTON_SPACING_SMALL
        end
        iconWidth = Scale.Value(iconWidth)
        spacing = Scale.Value(spacing)

        local maxDisplayWidth = frame.maxDisplayWidth

        -- Set values for each denomination
        if ( _G.ENABLE_COLORBLIND_MODE == "1" ) then
            Scale.RawSetWidth(goldButton, goldButton:GetTextWidth())
            Scale.RawSetWidth(silverButton, silverButton:GetTextWidth())
            Scale.RawSetWidth(copperButton, copperButton:GetTextWidth())
        else
            Scale.RawSetWidth(goldButton, goldButton:GetTextWidth() + iconWidth)
            Scale.RawSetWidth(silverButton, silverButton:GetTextWidth() + iconWidth)
            Scale.RawSetWidth(copperButton, copperButton:GetTextWidth() + iconWidth)
        end

        -- Store how much money the frame is displaying
        frame.staticMoney = money
        frame.showTooltip = nil

        -- If not collapsable or not using maxDisplayWidth don't need to continue
        if ( not info.collapse and not maxDisplayWidth ) then
            return
        end

        local width = iconWidth

        local showLowerDenominations, truncateCopper
        if ( gold > 0 ) then
            width = width + goldButton:GetWidth()
            if ( info.showSmallerCoins ) then
                showLowerDenominations = 1
            end
            if ( info.truncateSmallCoins ) then
                truncateCopper = 1
            end
        else
            goldButton:Hide()
        end

        goldButton:ClearAllPoints()
        local hideSilver = true
        if ( silver > 0 or showLowerDenominations ) then
            hideSilver = false
            -- Exception if showLowerDenominations and fixedWidth
            if ( showLowerDenominations and info.fixedWidth ) then
                silverButton:SetWidth(_G.COIN_BUTTON_WIDTH)
            end

            local silverWidth = silverButton:GetWidth()
            Scale.RawSetPoint(goldButton, "RIGHT", silverButton, "LEFT", spacing, 0)
            if ( goldButton:IsShown() ) then
                silverWidth = silverWidth - spacing
            end
            if ( info.showSmallerCoins ) then
                showLowerDenominations = 1
            end
            -- hide silver if not enough room
            if ( maxDisplayWidth and (width + silverWidth) > maxDisplayWidth ) then
                hideSilver = true
                frame.showTooltip = true
            else
                width = width + silverWidth
            end
        end
        if ( hideSilver ) then
            silverButton:Hide()
            goldButton:SetPoint("RIGHT", silverButton, 0, 0)
        end

        -- Used if we're not showing lower denominations
        silverButton:ClearAllPoints()
        local hideCopper = true
        if ( (copper > 0 or showLowerDenominations or info.showSmallerCoins == "Backpack" or forceShow) and not truncateCopper) then
            hideCopper = false
            -- Exception if showLowerDenominations and fixedWidth
            if ( showLowerDenominations and info.fixedWidth ) then
                copperButton:SetWidth(_G.COIN_BUTTON_WIDTH)
            end

            local copperWidth = copperButton:GetWidth()
            Scale.RawSetPoint(silverButton, "RIGHT", copperButton, "LEFT", spacing, 0)
            if ( silverButton:IsShown() or goldButton:IsShown() ) then
                copperWidth = copperWidth - spacing
            end
            -- hide copper if not enough room
            if ( maxDisplayWidth and (width + copperWidth) > maxDisplayWidth ) then
                hideCopper = true
                frame.showTooltip = true
            else
                width = width + copperWidth
            end
        end
        if ( hideCopper ) then
            copperButton:Hide()
            silverButton:SetPoint("RIGHT", copperButton, 0, 0)
        end

        -- make sure the copper button is in the right place
        copperButton:ClearAllPoints()
        copperButton:SetPoint("RIGHT", frameName, -13, 0)

        -- attach text now that denominations have been computed
        local prefixText = _G[frameName.."PrefixText"]
        if ( prefixText ) then
            if ( prefixText:GetText() and money > 0 ) then
                prefixText:Show()
                copperButton:ClearAllPoints()
                Scale.RawSetPoint(copperButton, "RIGHT", frameName.."PrefixText", "RIGHT", width, 0)
                width = width + prefixText:GetWidth()
            else
                prefixText:Hide()
            end
        end
        local suffixText = _G[frameName.."SuffixText"]
        if ( suffixText ) then
            if ( suffixText:GetText() and money > 0 ) then
                suffixText:Show()
                suffixText:ClearAllPoints()
                suffixText:SetPoint("LEFT", copperButton, "RIGHT", 0, 0)
                width = width + suffixText:GetWidth()
            else
                suffixText:Hide()
            end
        end

        Scale.RawSetWidth(frame, width)
    end
end

do --[[ FrameXML\MoneyFrame.xml ]]
    function Skin.SmallMoneyFrameTemplate(frame)
        local name = frame:GetName()

        local copper = _G[name.."CopperButton"]
        local silver = _G[name.."SilverButton"]
        local gold = _G[name.."GoldButton"]

        --[[ Scale ]]--
        frame:SetSize(128, 13)

        copper:SetSize(32, 13)
        copper:SetPoint("RIGHT", -13, 0)
        copper:GetNormalTexture():SetSize(13, 13)

        silver:SetSize(32, 13)
        silver:SetPoint("RIGHT", copper, "LEFT", -4, 0)
        silver:GetNormalTexture():SetSize(13, 13)

        gold:SetSize(32, 13)
        gold:SetPoint("RIGHT", silver, "LEFT", -4, 0)
        gold:GetNormalTexture():SetSize(13, 13)
    end
    function Skin.SmallDenominationTemplate(button)
        local name = button:GetName()
        Base.CropIcon(_G[name.."Texture"], button)
    end
    function Skin.SmallAlternateCurrencyFrameTemplate(frame)
        local name = frame:GetName()
        Skin.SmallDenominationTemplate(_G[name.."Item1"])
        Skin.SmallDenominationTemplate(_G[name.."Item2"])
        Skin.SmallDenominationTemplate(_G[name.."Item3"])
    end
end

function private.FrameXML.MoneyFrame()
    _G.hooksecurefunc("MoneyFrame_Update", Hook.MoneyFrame_Update)
    --_G.hooksecurefunc("MoneyFrame_SetMaxDisplayWidth", Hook.MoneyFrame_Update)
end
