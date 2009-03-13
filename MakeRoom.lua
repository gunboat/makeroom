function out(msg)
    DEFAULT_CHAT_FRAME:AddMessage(msg)
    UIErrorsFrame:AddMessage(msg, 1.0, 0.5, 0, 1, 10)
end

MakeRoom = LibStub("AceAddon-3.0"):NewAddon("MakeRoom", "AceConsole-3.0", "AceEvent-3.0")
local T = LibStub("AceLocale-3.0"):GetLocale("MakeRoom", false)
local ItemPrice = LibStub("ItemPrice-1.1")
local greyItems = {}
local emptyItem = {texture=nil, itemLink=nil, itemLink=nil, empty=true}
local db = nil
local colors = {}

local options = {
    name = "MakeRoom",
    handler = MakeRoom,
    type = 'group',
    args = { },
}

function MakeRoom:OnInitialize()
    LibStub("AceConfig-3.0"):RegisterOptionsTable("MakeRoom", options)
    self:RegisterChatCommand("MakeRoom", "SlashCommand")
    self:RegisterChatCommand("mr", "SlashCommand")
    self:RegisterEvent("UI_ERROR_MESSAGE")
    self:RegisterEvent("LOOT_CLOSED")

    db = LibStub("AceDB-3.0"):New("MakeRoomDB")

    if (not db.char.itemQuality)
            or (db.char.itemQuality < 1 or db.char.itemQuality > 3) then
        db.char.itemQuality = 1
    end

    MakeRoom:InitializeColors()

    -- Allow our frame to be closed with the Escape key
    tinsert(UISpecialFrames, "MakeRoomPanel")
end

function MakeRoom:InitializeColors()
    for i = 0, 2 do
        local _, _, _, hex = GetItemQualityColor(i)
        colors[i] = hex..getglobal("ITEM_QUALITY"..i.."_DESC")
    end
end

function MakeRoom:OnEnable()
    self:Print("v1.0.3 loaded")
end

function MakeRoom:OnDisable()
end

function MakeRoom:UpdateItem(slot, itemDescription)
    getglobal("MakeRoomPanel_Item" .. slot .. "IconTexture"):SetTexture(itemDescription.texture)
    getglobal("MakeRoomPanel_Item" .. slot .. "Text"):SetText(itemDescription.itemLink)
    MakeRoom:SetItemCount(
        getglobal("MakeRoomPanel_Item" .. slot .. "Count"),
        itemDescription.itemCount)
end

function MakeRoom:SetItemCount(widget, itemCount)
    if itemCount == 1 then
        widget:Hide()
    else
        widget:SetText(itemCount)
        widget:Show()
    end
end

function MakeRoom:MakeRoomPanel_OnLoad(self)
    self:RegisterEvent("LOOT_CLOSED")

    MakeRoomPanel_Title:SetText(T["MAKEROOM_WINDOW_TITLE"])
    MakeRoomPanel_DestroyAll:SetText(T["DESTROY_ALL"])
end

function MakeRoom:MakeRoomPanel_OnEvent(self, event, ...)
    if event == "LOOT_CLOSED" then
        HideUIPanel(self)
        return
    end
end

function MakeRoom:Options_OnShow(widget)
    MakeRoom:Options_QualityDropdown_Update()
end

function MakeRoom:Options_ChooseQuality(self)
    db.char.itemQuality = self:GetID()
    UIDropDownMenu_ClearAll(MakeRoomOptionsPanelQualityDropdown)
    UIDropDownMenu_SetSelectedID(MakeRoomOptionsPanelQualityDropdown, db.char.itemQuality)
end

function MakeRoom:Options_QualityDropdown_Initialize()
    local info = UIDropDownMenu_CreateInfo()
    local func = function(self) MakeRoom:Options_ChooseQuality(self) end

    info.text = colors[0]
    info.func = func
    info.checked = nil
    UIDropDownMenu_AddButton(info)

    info.text = colors[1]
    info.checked = nil
    UIDropDownMenu_AddButton(info)

    info.text = colors[2]
    info.checked = nil
    UIDropDownMenu_AddButton(info)
end

function MakeRoom:Options_QualityDropdown_Update()
    local func = function() MakeRoom:Options_QualityDropdown_Initialize() end
    UIDropDownMenu_Initialize(MakeRoomOptionsPanelQualityDropdown, func)
    UIDropDownMenu_SetWidth(MakeRoomOptionsPanelQualityDropdown, 130)

    UIDropDownMenu_ClearAll(MakeRoomOptionsPanelQualityDropdown)
    UIDropDownMenu_SetSelectedID(MakeRoomOptionsPanelQualityDropdown, db.char.itemQuality)
end

function MakeRoom:SlashCommand()
    MakeRoom:MakeRoom()
    if not MakeRoomPanel:IsVisible() then
        MakeRoomPanel:Show()
    end
end

function MakeRoom:MakeRoomPanel_OnShow(widget)
    self:RegisterEvent("BAG_UPDATE");
end

function MakeRoom:MakeRoomPanel_OnHide(widget)
    self:UnregisterEvent("BAG_UPDATE");
end

function MakeRoom:DestroyItem(i)
    MakeRoom:UnregisterEvent("BAG_UPDATE");
    if i <= #greyItems and not greyItems[i].empty then
        GameTooltip:Hide()
        PickupContainerItem(greyItems[i].bag, greyItems[i].slot)
        DeleteCursorItem()
        greyItems[i].empty = true
        MakeRoom:UpdateItem(i, emptyItem)
    end
    MakeRoom:RegisterEvent("BAG_UPDATE");
end

function MakeRoom:DestroyAllItems(self)
    for i = 1, 4, 1 do
        MakeRoom:DestroyItem(i)
    end
    MakeRoomPanel:Hide()
end

function MakeRoom:OnClick(widget, button, ...)
    if IsShiftKeyDown() then
        if CursorHasItem() then
            out(T["CURSOR_BUSY"])
        else
            local i = widget:GetID()
            MakeRoom:DestroyItem(i)
        end
    end
end

function MakeRoom:OnDragStart(widget, button, ...)
    local i = widget:GetID()
    if i <= #greyItems and not greyItems[i].empty then
        GameTooltip:Hide()
        PickupContainerItem(greyItems[i].bag, greyItems[i].slot)
    end
end

function MakeRoom:OnEnter(widget)
    local i = widget:GetID()
    if i <= # greyItems and not greyItems[i].empty then
        GameTooltip:SetOwner(widget, "ANCHOR_RIGHT")
        GameTooltip:SetBagItem(greyItems[i].bag, greyItems[i].slot)
        GameTooltip:AddLine(T["TOOLTIP_INSTRUCTIONS"])
        GameTooltip:Show()
    end
end

function MakeRoom:UI_ERROR_MESSAGE(event, msg)
    if msg == T["INVENTORY_IS_FULL"] then
        MakeRoom:SlashCommand()
    end
end

function MakeRoom:LOOT_CLOSED(event)
    if MakeRoomPanel:IsVisible() then
        MakeRoomPanel:Hide()
    end
end

function MakeRoom:BAG_UPDATE(event, bagId)
    if MakeRoomPanel:IsVisible() then
        MakeRoom:MakeRoom()
    end
end

function MakeRoom:MakeRoom()
    greyItems = {}
    for bag = 0, 4, 1 do
        for slot = 1, GetContainerNumSlots(bag), 1 do
            local itemLink = GetContainerItemLink(bag, slot)
            if itemLink then
                local texture, itemCount, locked, quality, readable = GetContainerItemInfo(bag, slot)
                local itemName, _, itemRarity = GetItemInfo(itemLink)
                if itemRarity <= (db.char.itemQuality-1) then
                    local found, _, itemString = string.find(itemLink, "^|c%x+|H(.+)|h%[.+%]")
                    local _, itemId = strsplit(":", itemString)
                    itemId = tonumber(itemId)
                
                    local valuePer = MakeRoom:GetVendorSellPrice(itemId)
                    if valuePer and valuePer > 0 then
                        local total = valuePer * itemCount
                        table.insert(greyItems, {itemLink=itemLink, texture=texture, bag=bag, slot=slot, itemCount=itemCount, total=total})
                    end
                end
            end
        end
    end
    
    if # greyItems == 0 then
        out(T["NO_GREY_ITEMS"])
    else
        table.sort(greyItems, function(arg1, arg2)      return arg1.total < arg2.total end)
    end

    for i = #greyItems+1, 4, 1 do
        table.insert(greyItems, emptyItem)
    end

    for i = 1, 4, 1 do
        if not greyItems[i].empty then
            MakeRoom:UpdateItem(i, greyItems[i])
        else
            MakeRoom:UpdateItem(i, emptyItem)
        end
    end
end

function MakeRoom:GetVendorSellPrice(itemId)
    -- Use Informant if it's loaded
    if Informant then
        local ret = Informant.GetItem(itemId)
        if ret then
            return ret.sell
        end
    end

    -- We always have ItemPrice
    local ret = ItemPrice:GetPriceById(itemId)
    if ret and ret ~= 0 then
	return ret
    end

    -- Unsalable and unknown items are both ignored
    return nil
end

function MakeRoom:Options_OnLoad(panel)
    panel.name = "MakeRoom"
    panel.default = function(this) self:Print("default pressed") end

    InterfaceOptions_AddCategory(panel)
end
