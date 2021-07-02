--[[
    Allow space bar, escape key and enter key to cancel cinematic without confirmation
]]

local _G = _G
local unpack = unpack
local select = select

local F, C = unpack(select(2, ...))
local FMS = F:RegisterModule('FasterMovieSkip')

local function CinematicFrame_OnKeyDown(self, key)
    if key == 'ESCAPE' then
        if self:IsShown() and self.closeDialog and self.closeDialog.confirmButton then
            self.closeDialog:Hide()
        end
    end
end

local function CinematicFrame_OnKeyUp(self, key)
    if key == 'SPACE' or key == 'ESCAPE' or key == 'ENTER' then
        if self:IsShown() and self.closeDialog and self.closeDialog.confirmButton then
            self.closeDialog.confirmButton:Click()
        end
    end
end

local function MovieFrame_OnKeyUp(self, key)
    if key == 'SPACE' or key == 'ESCAPE' or key == 'ENTER' then
        if self:IsShown() and self.CloseDialog and self.CloseDialog.ConfirmButton then
            self.CloseDialog.ConfirmButton:Click()
        end
    end
end

function FMS:OnLogin()
    if not C.DB.General.FasterMovieSkip then
        return
    end

    if _G.CinematicFrame.closeDialog and not _G.CinematicFrame.closeDialog.confirmButton then
        _G.CinematicFrame.closeDialog.confirmButton = _G.CinematicFrameCloseDialogConfirmButton
    end

    _G.CinematicFrame:HookScript('OnKeyDown', CinematicFrame_OnKeyDown)
    _G.CinematicFrame:HookScript('OnKeyUp', CinematicFrame_OnKeyUp)
    _G.MovieFrame:HookScript('OnKeyUp', MovieFrame_OnKeyUp)
end
