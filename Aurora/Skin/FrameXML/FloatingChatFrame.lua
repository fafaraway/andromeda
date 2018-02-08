local _, private = ...

--[[ Lua Globals ]]
-- luacheck: globals

--[[ Core ]]
local Aurora = private.Aurora
local Base = Aurora.Base

--[[do  FrameXML\FloatingChatFrame.lua
end ]]

--[[do  FrameXML\FloatingChatFrame.xml
end ]]

function private.FrameXML.FloatingChatFrame()
    Base.SetBackdrop(_G.ChatMenu)
    Base.SetBackdrop(_G.EmoteMenu)
    Base.SetBackdrop(_G.LanguageMenu)
    Base.SetBackdrop(_G.VoiceMacroMenu)
end
