--[[--------------------------------------------------------------------
	Broker_Time
	Shows the time. Hover for the date. Click to open the calendar.
	Copyright (c) 2014 Phanx <addons@phanx.net>. All rights reserved.
	https://github.com/Phanx/Broker_Time
----------------------------------------------------------------------]]

local TIME, DATEF, RIGHT_CLICK_CALENDAR = "Time", "%A, %B %d, %Y", "Right-Click to toggle the calendar."
if GetLocale() == "deDE" then
	TIME = "Zeit"
	DATEF = "%A, %d. %B %Y"
	RIGHT_CLICK_CALENDAR = "Rechtsklick, um den Kalender anzuzeigen."
elseif GetLocale():match("^es") then
	TIME = "Hora"
	DATEF = "%A, %d de %B de %Y"
	RIGHT_CLICK_CALENDAR = "Clic derecho para mostrar el calendario."
elseif GetLocale() == "frFR" then
	TIME = "Heure"
	DATEF = "%A %d %B %Y"
elseif GetLocale() == "itIT" then
	TIME = "Ora"
	DATEF = "%A %d %B %Y"
elseif GetLocale() == "ptBR" then
	TIME = "Hora"
	DATEF = "%d de %B de %Y"
elseif GetLocale() == "ruRU" then
	TIME = "Время"
	DATEF = "%A, %d %B %Y"
elseif GetLocale() == "koKR" then
	TIME = "시간"
	DATEF = "%A %Y년 %m월 %d일"
elseif GetLocale() == "zhCN" then
	TIME = "时间"
	DATEF = "%A%Y年%m月%d日"
elseif GetLocale() == "zhTW" then
	TIME = "時候"
	DATEF = "%A%Y年%m月%d日"
end

local Clock = LibStub("LibDataBroker-1.1"):NewDataObject(TIME, {
	type  = "data source",
	icon  = "Interface\\TimeManager\\GlobeIcon",
	text  = "--:--",
	label = TIME,
})

local function GetTooltipPoint(self, offset)
	local x, y = GetCursorPosition()
	if (y * 2) > UIParent:GetHeight() then
		return "TOP", self, "BOTTOM", 0, offset  and -offset or 0
	else
		return "BOTTOM", self, "TOP", 0, offset or 0
	end
end

function Clock:OnClick(button)
	if button == "RightButton" then
		ToggleCalendar()
	else
		ToggleTimeManager()
		if TimeManagerFrame:IsShown() then
			TimeManagerFrame:SetClampedToScreen(true)
			TimeManagerFrame:ClearAllPoints()
			TimeManagerFrame:SetPoint(GetTooltipPoint(self))
		end
	end
end

local function CleanDate(...)
	local text = date(...)
	text = gsub(text, "^0", "")
	text = gsub(text, "([^:%d])0", "%1")
	return text
end

function Clock:OnEnter()
	GameTooltip:SetOwner(self, "ANCHOR_NONE")
	GameTooltip:SetPoint(GetTooltipPoint(self))
	TimeManagerClockButton_UpdateTooltip()
	GameTooltipTextLeft1:SetText(CleanDate(DATEF))
	GameTooltip:AddLine(RIGHT_CLICK_CALENDAR)
	GameTooltip:Show()
end

function Clock:OnLeave()
	GameTooltip:Hide()
end

local INTERVAL, t = 1, 0
local f = CreateFrame("Frame")
f:SetScript("OnUpdate", function(self, elapsed)
	t = t + elapsed
	if t > INTERVAL then
		local text = GameTime_GetTime(not GetCVarBool("timeMgrUseMilitaryTime"))
		if TimeManager_ShouldCheckAlarm() then
			TimeManager_CheckAlarm(elapsed)
		end
		if TimeManagerClockButton.alarmFiring then
			Clock.text = "*** " .. text .. " ***"
		else
			Clock.text = text
		end
		t = 0
	end
end)
