local Packages = script.Packages
---- // fusion stuff \\ ---
local fusion = require(Packages.fusion)
local New = fusion.New
local Children = fusion.Children
local ForPairs = fusion.ForPairs
local Value = fusion.Value
local OnEvent = fusion.OnEvent
local Ref = fusion.Ref
local Observer = fusion.Observer
---- // Components \\ ----
local Components = script.Components
local Checkbox = require(Components.Checkbox).new()
local SlotTemp = require(Components.Slot)
---- // Plugin Stuff \\ ----
local toolbar = plugin:CreateToolbar("Baseplate Templates")
local button = toolbar:CreateButton("Baseplate Templates", "", "rbxassetid://18806264222")
local mouse = plugin:GetMouse()
---- // Variables \\ ----
local childNum = Value(1)
local outAbsolutePos = Value(nil)
local parentFrame = Value()
local CurrSelected = Value(plugin:GetSetting("Selected") or 0)

local selectedObserver = Observer(CurrSelected)
---- // Idk \\ ----
local Trove = require(Packages.Trove)

local trove = Trove.new()

local function SerializeBaseplate()
    local Baseplate = workspace.Baseplate
    local serializedMaterial = {string.split(tostring(Baseplate.Material), ".")[2], string.split(tostring(Baseplate.Material), ".")[3]}
    local serializedColor = {
        R = Baseplate.Color.R,
        G = Baseplate.Color.G,
        B = Baseplate.Color.B
    }
    local info = {
        Color = serializedColor,
        Material = serializedMaterial,
        Texture = Baseplate.Texture.Texture,
        Transparency = Baseplate.Texture.Transparency
    }
    return info
end

local widgetInfo = DockWidgetPluginGuiInfo.new(
    Enum.InitialDockState.Float,
    false,
    false,
    700,
    300,
    150,
    150
)

local widget = plugin:CreateDockWidgetPluginGui("Baseplate Templates", widgetInfo)
widget.Title = "Templates"

button.Click:Connect(function()
    widget.Enabled = not widget.Enabled
end)

widget:GetPropertyChangedSignal("Enabled"):Connect(function()
    if widget.Enabled == false then
        button.Enabled = false
        button:SetActive(false)
        button.Enabled = true
    end
end)

local Templates = plugin:GetSetting("_Baseplates")

Checkbox.Active:set(plugin:GetSetting("AutoSet"))

local conn = Checkbox.Changed:Connect(function()
    plugin:SetSetting("AutoSet", Checkbox.Active)
end)

local Disconnect = selectedObserver:onChange(function()
    if CurrSelected:get(false) ~= 0 then
        plugin:SetSetting("Selected", CurrSelected:get(false))
    end
end)

if plugin:GetSetting("AutoSet") and plugin:GetSetting("_Baseplates")[plugin:GetSetting("Selected")] ~= nil then
    local Baseplate = workspace.Baseplate
    if Baseplate == nil then
        Baseplate = Instance.new("Part")
        Baseplate.Size = Vector3.new(2048, 16, 2048)
        Baseplate.Position = Vector3.new(0, -8, 0)
    end
    local Info = plugin:GetSetting("_Baseplates")[plugin:GetSetting("Selected")]
    Baseplate.Color = Color3.new(Info.Color.R, Info.Color.G, Info.Color.B)
    Baseplate.Texture.Texture = Info.Texture
    Baseplate.Texture.Transparency = Info.Transparency
end

local Slots = Value(Templates or {})

New "Frame" {
    Parent = widget,
    Size = UDim2.fromScale(1,1),
    BackgroundTransparency = 1,
    [Children] = {
        New "UIListLayout" {
            HorizontalAlignment = Enum.HorizontalAlignment.Left,
            Padding = UDim.new(0.05,0),
            SortOrder = Enum.SortOrder.LayoutOrder
        },
        New "UIPadding" {
            PaddingLeft = UDim.new(0.01,0),
            PaddingTop = UDim.new(0.02,0),
            PaddingRight = UDim.new(0.01,0),
            PaddingBottom = UDim.new(0.12,0)
        },
        New "TextLabel" {
            Text = "Auto Change",
            Size = UDim2.fromOffset(700, 25),
            Position = UDim2.fromScale(0,0),
            BackgroundTransparency = 1,
            TextXAlignment = Enum.TextXAlignment.Left,
            TextColor3 = Color3.fromRGB(170,170,170),
            FontFace = Font.new("rbxasset://fonts/families/Ubuntu.json"),
            TextSize = 15,
            LayoutOrder = 1,
            [Children] = {
                New "UIPadding" {
                    PaddingLeft = UDim.new(0.05,0)
                },
                Checkbox.Box {
                    Position = UDim2.fromScale(-0.03,0.5)
                },
            }
        },
        New "Frame" {
            Size = UDim2.fromScale(1,1),
            LayoutOrder = 2,
            BackgroundTransparency = 1,
            Name = "SlotsHolder",
            [Children] = {
                New "ScrollingFrame" {
                    Size = UDim2.fromScale(1,1),
                    CanvasSize = UDim2.new(0,0,0,0),
                    BackgroundColor3 = Color3.fromRGB(53,53,53),
                    ScrollBarThickness = 6,
                    ScrollBarImageColor3 = Color3.fromRGB(255,255,255),
                    AutomaticCanvasSize = Enum.AutomaticSize.Y,
                    Name = "Sf",

                    [Children] = {
                        New "UIGridLayout" {
                            SortOrder = Enum.SortOrder.LayoutOrder
                        },
                        ForPairs(Slots, function(index, slot)
                            local newSlot = SlotTemp.new()
                            local ref = Value()
                            return index, newSlot.Slot {
                                Image = slot.Texture,
                                Transparency = slot.Transparency,
                                LayoutOrder = index,
                                Color = Color3.new(slot.Color.R, slot.Color.G, slot.Color.B),
                                Selected = CurrSelected,
                                OutAbsolutePos = outAbsolutePos,
                                Changed = function()
                                    
                                end,
                                Delete = function()

                                local newFrame
                                newFrame = New "Frame" {
                                    Size = UDim2.fromOffset(200,100),
                                    Position = UDim2.fromScale(0.5,0.5),
                                    AnchorPoint = Vector2.new(0.5,0.5),
                                    ZIndex = 5,
                                    BackgroundColor3 = Color3.fromRGB(46,46,46),
                                    [Children] = {
                                        New "TextButton" {
                                            Text = "Delete",
                                            Size = UDim2.fromOffset(65,15),
                                            Position = UDim2.fromScale(0.3,0.7),
                                            AnchorPoint = Vector2.new(0.5,0.5),
                                            ZIndex = 5,
                                            BackgroundColor3 = Color3.fromRGB(221, 89, 89),
                                            FontFace = Font.new("rbxasset://fonts/families/Ubuntu.json"),
                                            TextColor3 = Color3.fromRGB(170,170,170),
                                            [OnEvent "Activated"] = function()
                                                newFrame:Destroy()
                                                ref:get():Destroy()
                                                table.remove(Templates, index)
                                                plugin:SetSetting("_Baseplates", Templates)
                                            end
                                        },
                                        New "TextButton" {
                                            Text = "Cancel",
                                            Size = UDim2.fromOffset(65,15),
                                            Position = UDim2.fromScale(0.7,0.7),
                                            AnchorPoint = Vector2.new(0.5,0.5),
                                            ZIndex = 5,
                                            FontFace = Font.new("rbxasset://fonts/families/Ubuntu.json"),
                                            BackgroundColor3 = Color3.fromRGB(53,53,53),
                                            TextColor3 = Color3.fromRGB(170,170,170),
                                            [OnEvent "Activated"] = function()
                                                newFrame:Destroy()
                                            end
                                        },

                                        New "TextLabel" {
                                            Text = "Are you sure?",
                                            Size = UDim2.fromScale(0.5,0.5),
                                            BackgroundTransparency = 1,
                                            TextScaled = true,
                                            AnchorPoint = Vector2.new(0.5,0.5),
                                            Position = UDim2.fromScale(0.5,0.27),
                                            ZIndex = 5,
                                            TextColor3 = Color3.fromRGB(170,170,170),
                                            FontFace = Font.new("rbxasset://fonts/families/Ubuntu.json"),
                                        }
                                    },
                                    Parent = parentFrame
                                }
                                end,
                                Activated = function()
                                    local Baseplate = workspace.Baseplate
                                    Baseplate.Color = Color3.new(slot.Color.R, slot.Color.G, slot.Color.B)
                                    Baseplate.Texture.Texture = slot.Texture
                                    Baseplate.Texture.Transparency = slot.Transparency
                                    Baseplate.Material = Enum.Material[slot.Material[2]]
                                end,
                                mouse = mouse,
                                ref = ref
                            }
                        end, fusion.cleanup),
                        New "UIPadding" {
                            PaddingLeft = UDim.new(0,4),
                            PaddingTop = UDim.new(0,4),
                            PaddingRight = UDim.new(0,4),
                            PaddingBottom = UDim.new(0,4)
                        },
                        New "ImageButton" {
                            BackgroundColor3 = Color3.fromRGB(104, 182, 255),
                            Image = "rbxassetid://14937464266",
                            LayoutOrder = childNum,
                            
                            [OnEvent "Activated"] = function()
                                table.insert(Templates, SerializeBaseplate())
                                plugin:SetSetting("_Baseplates", Templates)
                                Slots:set(Templates)
                                childNum:set(childNum:get(false) + 1)
                                print(Templates)
                            end
                        },
                        New "Folder" {
                            Name = "_Ignore",
                            [Ref] = parentFrame,
                        }
                    }
                }
            }
        }
    },
}

trove:Add(conn, "Disconnect")
trove:Add(Disconnect)

plugin.Unloading:Connect(function()
    trove:Destroy()
end)