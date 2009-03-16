local AL3 = LibStub("AceLocale-3.0")
local L = AL3:NewLocale("MakeRoom", "esMX", false)

if L then
    L["CURSOR_BUSY"] = "Ya estas sosteniendo algo"
    L["DESTROY_ALL"] = "Destruir todos"
    L["IGNORE_BUTTON"] = "Ignore" -- Requires localization
    L["IGNORE_LIST"] = "Ignore list" -- Requires localization
    L["INVENTORY_IS_FULL"] = "El inventario esta lleno."
    L["ITEM_QUALITY"] = "Item quality" -- Requires localization
    L["MAKEROOM_WINDOW_TITLE"] = "MakeRoom"
    L["NO_GREY_ITEMS"] = "No hay objetos grices para destruir."
    L["TOOLTIP_INSTRUCTIONS"] = "Shift-Click para destruir."
    L["WRONG_CONTAINER"] = "That item doesn't go in that container." -- Requires localization

end
