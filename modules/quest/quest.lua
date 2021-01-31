local F, C = unpack(select(2, ...))
local QUEST = F.QUEST

function QUEST:OnLogin()
	if not C.DB.Quest.Enable then
		return
	end

	QUEST:WorldQuestTool()
end
