local AL3 = LibStub("AceLocale-3.0")
local L = AL3:NewLocale("MakeRoom", "enUS", true, true)

if L then
    L["CURSOR_BUSY"] = "You're already holding something"
    L["DESTROY_ALL"] = "Destroy All"
    L["IGNORE_BUTTON"] = "Ignore"
    L["IGNORE_LIST"] = "Ignore list"
    L["INVENTORY_IS_FULL"] = "Inventory is full."
    L["ITEM_QUALITY"] = "Item quality"
    L["MAKEROOM_WINDOW_TITLE"] = "MakeRoom"
    L["NO_GREY_ITEMS"] = "No grey items to destroy."
    L["TOOLTIP_INSTRUCTIONS"] = "shift-click to destroy"
    L["WRONG_CONTAINER"] = "That item doesn't go in that container."
end
