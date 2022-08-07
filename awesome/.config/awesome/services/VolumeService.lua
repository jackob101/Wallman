local INC_VOLUME_CMD = "amixer -D pulse sset Master 5%+"
local DEC_VOLUME_CMD = "amixer -D pulse sset Master 5%-"
local TOG_VOLUME_CMD = "amixer -D pulse sset Master toggle"
local UPDATE_SIGNAL = "module::volume::widgets:update"

--- @class VolumeUpdatableWidget : BaseWidget
--- @field update fun(self: Widget, newVolume: number, isMute:boolean, shouldDisplay: boolean)


--- @class VolumeService : Initializable This class is a singletoon responsible for all things about handling Volume
--- @field toUpdate VolumeUpdatableWidget[]
--- @field canServe boolean Indicates if service can handle another request
VolumeService = {
    isInitialized = false,
    toUpdate = {},
    canServe = true,
}

--- @return VolumeService
function VolumeService.init()

    if VolumeService.isInitialized then
        return
    end

    Gears.timer {
        timeout = 5,
        autostart = true,
        call_now = true,
        callback = function()
            VolumeService.update(false)
        end

    }

    VolumeService._initKeybinds()

    VolumeService.isInitialized = true
end

--- @param widget VolumeUpdatableWidget
function VolumeService.connect(widget)
    table.insert(VolumeService.toUpdate, widget)
end

function VolumeService.update(shouldDisplay)
    Awful.spawn.easy_async_with_shell("amixer -D pulse sget Master", function(out)
        local isMute = string.match(out, "%[(o%D%D?)%]") == "off"  -- \[(o\D\D?)\] - [on] or [off]
        local newVolume = tonumber(string.match(out, "(%d?%d?%d)%%"))

        for _, w in ipairs(VolumeService.toUpdate) do
            if shouldDisplay == nil then
                shouldDisplay = false
            end
            w:update(newVolume, isMute, shouldDisplay)
        end
        canServe = true;
    end)
end

function VolumeService.increase(shouldDisplay)
    if canServe then
        canServe = false
        Awful.spawn.easy_async_with_shell(INC_VOLUME_CMD, function()
            VolumeService.update(shouldDisplay)
        end)
        return true
    end
    return false
end

function VolumeService.decrease(shouldDisplay)
    if canServe then
        canServe = false
        Awful.spawn.easy_async_with_shell(DEC_VOLUME_CMD, function()
            VolumeService.update(shouldDisplay)
        end)
        return true
    end
    return false
end

function VolumeService.toggle(shouldDisplay)
    if canServe then
        canServe = false
        Awful.spawn.easy_async_with_shell(TOG_VOLUME_CMD, function()
            VolumeService.update(shouldDisplay)
        end)
        return true
    end
    return false
end

--- @param amount number Amount to set volume to
function VolumeService.set(amount, shouldDisplay)
    if canServe then
        if amount and type(amount) == "number" then
            if amount >= 0 and amount <= 100 then
                canServe = false
                Awful.spawn.easy_async_with_shell("amixer -D pulse sset Master " .. amount .. "%", function()
                    VolumeService.update(shouldDisplay)
                end)
                return true
            end
        end
    end
    return false
end

function VolumeService._initKeybinds()
    Keybinds.connectForGlobal(Gears.table.join(
            Awful.key(
                    {  },
                    "XF86AudioRaiseVolume",
                    function()
                        VolumeService.increase(true)
                    end,
                    { description = "Increase volume", group = "audio" }
            ),

            Awful.key(
                    {  },
                    "XF86AudioLowerVolume",
                    function()
                        VolumeService.decrease(true)
                    end,
                    { description = "Decrease volume", group = "audio" }
            ),

            Awful.key(
                    {  },
                    "XF86AudioMute",
                    function()
                        VolumeService.toggle(false)
                    end,
                    { description = "Mute audio", group = "audio" }
            )
    ))
end

