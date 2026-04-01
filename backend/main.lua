---@diagnostic disable: lowercase-global
local logger = require("logger")
local millennium = require("millennium")
local smtc = require("smtc")

function SMTC_set_playback_status(status) smtc.set_playback_status(status) end
function SMTC_set_display(title, artist, album_title, album_artist, track_number) smtc.set_display(title, artist, album_title, album_artist, track_number) end

function SMTC_setup()
    smtc.set_is_play_enabled(true)
    smtc.set_is_stop_enabled(false)
    smtc.set_is_pause_enabled(true)
    smtc.set_is_record_enabled(false)
    smtc.set_is_fastforward_enabled(false)
    smtc.set_is_rewind_enabled(false)
    smtc.set_is_previous_enabled(true)
    smtc.set_is_next_enabled(true)
    smtc.set_is_channelup_enabled(false)
    smtc.set_is_channeldown_enabled(false)
    smtc.set_is_enabled(true)
end

local function pressed_button_event_loop()
    local pressedButton = smtc.get_pressed_button()
    if pressedButton == -1 then return end

    if pressedButton == smtc.SystemMediaTransportControlsButton.Play or pressedButton == smtc.SystemMediaTransportControlsButton.Pause then
        millennium.call_frontend_method("MusicController.TogglePlayPause")
    elseif pressedButton == smtc.SystemMediaTransportControlsButton.Next then
        millennium.call_frontend_method("MusicController.PlayNext")
    elseif pressedButton == smtc.SystemMediaTransportControlsButton.Previous then
        millennium.call_frontend_method("MusicController.PlayPrevious")
    end

    logger:info("Pressed button " .. pressedButton)
end

function SMTC_event_loop()
    pressed_button_event_loop()
end

local function on_load()
    smtc.init()

    logger:info("Plugin loaded")

    millennium.ready()
end

-- Called when your plugin is unloaded. This happens when the plugin is disabled or Steam is shutting down.
-- NOTE: If Steam crashes or is force closed by task manager, this function may not be called -- so don't rely on it for critical cleanup.
local function on_unload()
    smtc.release()

    logger:info("Plugin unloaded")
end

-- Called when the Steam UI has fully loaded.
local function on_frontend_loaded()
    logger:info("Frontend loaded")
    -- local result = millennium.call_frontend_method("classname.method", { 18, "USA", false })
    -- logger:info(result)
end

return {
    on_frontend_loaded = on_frontend_loaded,
    on_load = on_load,
    on_unload = on_unload
}
