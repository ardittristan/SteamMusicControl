local millennium = require("millennium")

function PlayNext()
    millennium.call_frontend_method("MusicController.PlayNext")
end

function PlayPrevious()
    millennium.call_frontend_method("MusicController.PlayPrevious")
end

function TogglePlayPause()
    millennium.call_frontend_method("MusicController.TogglePlayPause")
end