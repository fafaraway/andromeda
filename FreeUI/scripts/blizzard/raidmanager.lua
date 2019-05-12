local F, C, L = unpack(select(2, ...))
local BLIZZARD = F:GetModule('Blizzard')





function BLIZZARD:RaidManager()
	if not C.general.raidManager then return end

	local converttip

	

	local rm = CreateFrame('Frame', 'FreeUIRaidManager', UIParent)
	rm:SetFrameStrata('MEDIUM')
	rm:SetHeight(250)
	rm:SetWidth(32)
	rm:SetPoint('LEFT')
	rm:Hide()
	rm:RegisterEvent('GROUP_ROSTER_UPDATE')
	rm:RegisterEvent('PLAYER_ENTERING_WORLD')
	rm:SetScript('OnEvent', function(self, event)
		local function ButtonTemplate(button, parent, size, a1, a2, x, y, fsize, text, tip)
			b = CreateFrame('Button', button, rm)
			b:SetSize(size, size)
			b:SetPoint(a1, parent, a2, x, y)
			b.text = F.CreateFS(b, {'Interface\\AddOns\\FreeUI\\assets\\font\\symbol.ttf', fsize}, text, nil, nil, true, 'CENTER', 0, 0) 
			b.text:SetTextColor(1, 1, 1, .2)
			b:RegisterEvent('PLAYER_ENTERING_WORLD')
			b:RegisterEvent('GROUP_ROSTER_UPDATE')
			b:SetScript('OnEnter', function(self)
				self.text:SetTextColor(C.r, C.g, C.b, 1) 
				GameTooltip:SetOwner(self, 'ANCHOR_RIGHT', 0, 0)
				if tip then GameTooltip:AddLine(tip) else GameTooltip:AddLine(converttip) end
				GameTooltip:Show()
			end)
			b:SetScript('OnLeave', function(self) 
				self.text:SetTextColor(1, 1, 1, .2)
				GameTooltip:Hide()	
			end)
		end

		local function CreateButtons()
			ButtonTemplate('pull', rm, 30, 'TOPRIGHT', 'TOPRIGHT', 0, -5, 27, 'B', L['Pull'])
			pull:SetAttribute('type', 'macro')

			if IsAddOnLoaded('DBM-Core') then
				pull:SetAttribute('macrotext', format('/dbm pull %d', 10))
			elseif IsAddOnLoaded('BigWigs') then
				pull:SetAttribute('macrotext', format('/pull %d', 10))
			end

			ButtonTemplate('readycheck', pull, 30, 'TOP', 'BOTTOM', 1, -4, 24, 'x', READY_CHECK)
			readycheck:SetScript('OnMouseUp', function(self)
				if UnitIsGroupLeader('player') or UnitIsGroupAssistant('player') then
					DoReadyCheck()
				else
					UIErrorsFrame:AddMessage(C.InfoColor..ERR_NOT_LEADER)
				end
			end)

			ButtonTemplate('rolecheck', readycheck, 30, 'TOP', 'BOTTOM', 0, 0, 24, 'z' ,ROLE_POLL)
			rolecheck:SetScript('OnMouseUp', function(self)
				if UnitIsGroupLeader('player') or UnitIsGroupAssistant('player') then
					InitiateRolePoll()
				else
					UIErrorsFrame:AddMessage(C.InfoColor..ERR_NOT_LEADER)
				end
			end)

			ButtonTemplate('disband', rolecheck, 30, 'TOP', 'BOTTOM', 0, -0, 24, 'p', PARTY_LEAVE)
			disband:SetScript('OnMouseUp', function(self) 
				LeaveParty()
			end)

			ButtonTemplate('raid', disband, 30, 'TOP', 'BOTTOM', 0, 0, 24, 'u', RAID_CONTROL)
			raid:SetScript('OnMouseUp', function(self) ToggleFriendsFrame(3) end)

			ButtonTemplate('convert', raid, 30, 'TOP', 'BOTTOM', 0, 5, 22, 'h')
			convert:SetScript('OnMouseUp', function(self)
				if UnitIsGroupLeader('player') or UnitIsGroupAssistant('player') then
					if UnitInRaid('player') then
						ConvertToParty()
						converttip = CONVERT_TO_RAID
					elseif UnitInParty('player') then
						ConvertToRaid()
						converttip = CONVERT_TO_RAID
					end
				else
					UIErrorsFrame:AddMessage(C.InfoColor..ERR_NOT_LEADER)
				end
			end)
		end
		
		

		converttip = UnitInRaid('player') and CONVERT_TO_PARTY or CONVERT_TO_RAID

		if event == 'PLAYER_ENTERING_WORLD' then
			CreateButtons()
		end

		self:UnregisterEvent('PLAYER_ENTERING_WORLD')

		if IsInGroup() then
			rm:Show()
		else
			rm:Hide()
		end
	end)
end

