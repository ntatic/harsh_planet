-- namespace
HUD = HUD or {}

function HUD:Notify(text)
	GameRules:SendCustomMessage(text, DOTA_TEAM_NOTEAM , 1)
end