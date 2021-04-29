--[[
    Allow space bar, escape key and enter key to cancel cinematic without confirmation
 ]]

local _G = _G
local unpack = unpack
local select = select

local F, C = unpack(select(2, ...))
local FMS = F:RegisterModule('FasterMovieSkip')

local cf = _G.CinematicFrame
local cfd = _G.CinematicFrameCloseDialog
local cfb = _G.CinematicFrameCloseDialogConfirmButton
local mf = _G.MovieFrame

local function CinematicFrame_OnKeyDown(self, key)
    if key == 'ESCAPE' then
        if cf:IsShown() and cf.closeDialog and cfb then
            cfd:Hide()
        end
    end
end

local function CinematicFrame_OnKeyUp(self, key)
    if key == 'SPACE' or key == 'ESCAPE' or key == 'ENTER' then
        if cf:IsShown() and cf.closeDialog and cfb then
            cfb:Click()
        end
    end
end

local function MovieFrame_OnKeyUp(self, key)
    if key == 'SPACE' or key == 'ESCAPE' or key == 'ENTER' then
        if mf:IsShown() and mf.CloseDialog and mf.CloseDialog.ConfirmButton then
            mf.CloseDialog.ConfirmButton:Click()
        end
    end
end

function FMS:OnLogin()
    if not C.DB.General.FasterMovieSkip then
        return
    end

    cf:HookScript('OnKeyDown', CinematicFrame_OnKeyDown)
    cf:HookScript('OnKeyUp', CinematicFrame_OnKeyUp)
    mf:HookScript('OnKeyUp', MovieFrame_OnKeyUp)
end
