local AL3 = LibStub("AceLocale-3.0")
local L = AL3:NewLocale("MakeRoom", "deDE", false)

if L then
    L["CURSOR_BUSY"] = "Du hast davon bereits etwas" -- Needs review
    L["DESTROY_ALL"] = "Alles zerstören"
    L["INVENTORY_IS_FULL"] = "Inventar ist voll"
    L["MAKEROOM_WINDOW_TITLE"] = "MakeRoom"
    L["NO_GREY_ITEMS"] = "Keine grauen Items zum zerstören"
    L["TOOLTIP_INSTRUCTIONS"] = "Shift+Klick drücken zum zerstören"
end
