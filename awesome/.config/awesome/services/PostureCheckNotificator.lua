local icons = require("icons")

--- @class PostureCheckNotificator : Initializable
PostureCheckNotificator = {
    isInitialized = false,
    isOn = false,
}

--- @return PostureCheckNotificator
function PostureCheckNotificator.init()

    if PostureCheckNotificator.isInitialized then
        return PostureCheckNotificator
    end

    PostureCheckNotificator.timer = Gears.timer {
        timeout = 1800,
        autostart = true,
        call_now = false,
        callback = PostureCheckNotificator.createNotification,
    }

    PostureCheckNotificator.isInitialized = true
    PostureCheckNotificator.isOn = true
end

function PostureCheckNotificator.createNotification()
    Naughty.notification({
        title = "Posture check",
        message = "Are you sitting properly?",
        icon = IconsHandler.icons.posture.path,
        urgency = "normal",
        store = false,
    })
end

function PostureCheckNotificator.start()

    if not PostureCheckNotificator.isInitialized then
        PostureCheckNotificator.new()
    end

    PostureCheckNotificator.isOn = true
    PostureCheckNotificator.timer:start()
end

function PostureCheckNotificator.stop()

    if not PostureCheckNotificator.isInitialized then
        PostureCheckNotificator.new()
    end

    PostureCheckNotificator.isOn = false
    PostureCheckNotificator.timer:stop()
end
