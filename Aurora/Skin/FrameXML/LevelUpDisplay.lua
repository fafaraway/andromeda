local _, private = ...

-- [[ Core ]]
local Aurora = private.Aurora
local Base, Hook, Skin = Aurora.Base, Aurora.Hook, Aurora.Skin

do --[[ FrameXML\LevelUpDisplay.lua ]]
    function Hook.LevelUpDisplaySide_OnShow(self)
        local prev
        for i = 1, #self.unlockList do
            local frame = _G["LevelUpDisplaySideUnlockFrame"..i]

            if not frame._auroraSkinned then
                Skin.LevelUpSkillTemplate(frame)
                if prev then
                    frame:SetPoint("TOP", prev, "BOTTOM", 0, -5)
                end
                frame._auroraSkinned = true
            end
            prev = frame
        end
    end
end

do --[[ FrameXML\LevelUpDisplay.xml ]]
    function Skin.LevelUpSkillTemplate(frame)
        Base.CropIcon(frame.icon, frame)
    end
end

function private.FrameXML.LevelUpDisplay()
    _G.LevelUpDisplaySide:HookScript("OnShow", Hook.LevelUpDisplaySide_OnShow)

    _G.LevelUpDisplaySideUnlockFrame1:SetPoint("TOP", _G.LevelUpDisplaySide.goldBG, "BOTTOM", 0, -10)
end
