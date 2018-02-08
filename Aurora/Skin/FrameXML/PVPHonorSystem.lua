local _, private = ...

--[[ Lua Globals ]]
-- luacheck: globals

--[[ Core ]]
local Aurora = private.Aurora
local Base, Hook, Skin = Aurora.Base, Aurora.Hook, Aurora.Skin

do --[[ FrameXML\PVPHonorSystem.lua ]]
    function Hook.PVPHonorXPBar_Update(self)
        self.Bar:SetStatusBarAtlas("")
        if _G.GetHonorRestState() == 1 then
            Base.SetTexture(self.Bar:GetStatusBarTexture(), "gradientDown")
            self.Bar:SetStatusBarColor(1.0, 0.71, 0)
        else
            Base.SetTexture(self.Bar:GetStatusBarTexture(), "gradientUp")
            self.Bar:SetStatusBarColor(1.0, 0.24, 0)
        end

        self.Bar.Spark:Hide()

        if self.rewardInfo and not self.rewardInfo.texCoords then
            Base.CropIcon(self.NextAvailable.Icon)
        end
    end
end

do --[[ FrameXML\PVPHonorSystem.xml ]]
    function Skin.PVPHonorSystemLargeXPBar(frame)
        frame:HookScript("OnEvent", Hook.PVPHonorXPBar_Update)
        frame:HookScript("OnShow", Hook.PVPHonorXPBar_Update)

        frame.Frame:Hide()

        local bar = frame.Bar
        bar.Background:Hide()
        Base.SetBackdrop(bar, Aurora.frameColor:GetRGBA())

        local layer, sublevel = bar:GetStatusBarTexture():GetDrawLayer()
        bar:SetBackdropBorderLayer(layer, sublevel + 1)

        for i = 1, 4 do
            local tick = frame:CreateTexture()
            tick:SetPoint("TOPLEFT", bar, 93 * i + 2, 0)
            tick:SetColorTexture(0, 0, 0)
            tick:SetSize(1, 17)
        end

        frame.NextAvailable.Frame:SetAlpha(0)
        Base.CropIcon(frame.NextAvailable.Icon, frame.NextAvailable)
    end
end

function private.FrameXML.PVPHonorSystem()
    _G.hooksecurefunc("PVPHonorXPBar_Update", Hook.PVPHonorXPBar_Update)
end
