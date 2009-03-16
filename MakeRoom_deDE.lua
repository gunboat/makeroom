local AL3 = LibStub("AceLocale-3.0")
local L = AL3:NewLocale("MakeRoom", "deDE", false)

if L then
    L["CURSOR_BUSY"] = "Du hast davon bereits etwas" -- Needs review
    L["DESTROY_ALL"] = "Alles zerstören"
    L["IGNORE_BUTTON"] = "Ignore" -- Requires localization
    L["IGNORE_LIST"] = "Ignore list" -- Requires localization
    L["INVENTORY_IS_FULL"] = "Inventar ist voll"
    L["ITEM_QUALITY"] = "Item quality" -- Requires localization
    L["MAKEROOM_WINDOW_TITLE"] = "MakeRoom"
    L["NO_GREY_ITEMS"] = "Keine grauen Items zum zerstören"
    L["TOOLTIP_INSTRUCTIONS"] = "Shift+Klick drücken zum zerstören"
    L["WRONG_CONTAINER"] = "That item doesn't go in that container." -- Requires localization

end
