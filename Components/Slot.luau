local Packages = script.Parent.Parent.Packages

local fusion = require(Packages.fusion)
local New = fusion.New
local Children = fusion.Children
local OnEvent = fusion.OnEvent
local Ref = fusion.Ref
local Observer = fusion.Observer

local Components = script.Parent

local Slot = {}

function Slot.new()
    local self = {}
    local Checkbox = require(Components.Checkbox).new()
    self.Slot = function(props)

        local selectedObserver = Observer(props.Selected)

        selectedObserver:onChange(function()
            if props.Selected:get(false) ~= props.LayoutOrder then
                Checkbox.Active:set(false)
            end
        end)

        if props.Selected:get(false) == props.LayoutOrder then
            Checkbox.Active:set(true)
        end

        Checkbox.Changed:Connect(function()

            if Checkbox.Active:get(false) then
                props.Selected:set(props.LayoutOrder)
            else
                props.Selected:set(nil)
            end
        end)
        return New "Frame" {
            BackgroundColor3 = props.BackgroundColor or Color3.fromRGB(46,46,46),
            [Ref] = props.ref,
            [Children] = {
                New "ImageButton" {
                    Size = UDim2.fromScale(0.95,0.95),
                    BackgroundTransparency = 1,
                    Image = props.Image,
                    AnchorPoint = Vector2.new(0.5,0.5),
                    Position = UDim2.fromScale(0.5,0.5),
                    ImageTransparency = props.Transparency or 0,
                    LayoutOrder = props.LayoutOrder or 1,
                    [Children] = {
                        New "ImageButton" {
                            Size = UDim2.fromOffset(20,20),
                            AnchorPoint = Vector2.new(0.5,0.5),
                            Position = UDim2.fromScale(0.9,0.1),
                            BackgroundColor3 = Color3.fromRGB(221, 89, 89),
                            Image = "rbxassetid://13863399279",
                            [OnEvent "Activated"] = function()
                                if props.Delete ~= nil then
                                    props.Delete()
                                end
                            end
                        }
                    },
                    [OnEvent "Activated"] = function()
                        if props.Activated ~= nil then
                            props.Activated()
                        end
                    end
                },
                Checkbox.Box {
                    Position = UDim2.fromScale(0.15,0.15),
                    Activated = function()
                        
                    end
                },
            }
        }
    end
    return self
end

return Slot