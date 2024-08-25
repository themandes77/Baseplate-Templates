local Packages = script.Parent.Parent.Packages

local fusion = require(Packages.fusion)
local New = fusion.New
local Children = fusion.Children
local OnEvent = fusion.OnEvent
local Value = fusion.Value

local Signal = require(Packages.Signal)

local Checkbox = {}
Checkbox.__index = Checkbox

function Checkbox.new()
    local self = setmetatable({}, Checkbox)
    self.Active = Value(false)
    self.Changed = Signal.new()
    self.Box = function(props)
        return New "ImageButton" {
            Size = UDim2.fromOffset(25,25),
            Position = props.Position or UDim2.fromScale(0.5,0.5),
            AnchorPoint = Vector2.new(0.5,0.5),
            BackgroundTransparency = 1,
            Image = "rbxassetid://14929065909",
            ImageColor3 = Color3.fromRGB(29, 28, 28),
            [Children] = {
                New "UICorner" {
                    CornerRadius = UDim.new(0,6)
                },
                New "ImageLabel" {
                    AnchorPoint = Vector2.new(0.5,0.5),
                    Position = UDim2.fromScale(0.5,0.5),
                    Size = UDim2.fromScale(1,1),
                    BackgroundTransparency = 1,
                    Image = "rbxassetid://14929062955",
                    Visible = self.Active,
                    ImageColor3 = Color3.fromRGB(104, 182, 255)
                }
            },
            [OnEvent "Activated"] = function()
                if props.Activated ~= nil then
                    props.Activated()
                end
                if self.Active:get() then
                    self.Active:set(false)
                else
                    self.Active:set(true)
                end
                self.Changed:Fire(self.Active:get(false))
            end
        }
    end
    return self
end

return Checkbox