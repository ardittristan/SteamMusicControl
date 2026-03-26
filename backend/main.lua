---@diagnostic disable: lowercase-global
local logger = require("logger")
local millennium = require("millennium")
local smtc = require("smtc")

-- function test_frontend_message_callback(message, status, count)
--     logger:info("test_frontend_message_callback called")
--     logger:info("Received args: " .. table.concat({message, tostring(status), tostring(count)}, ", "))

--     return "Response from backend"
-- end

SMTC = smtc

local function PlayNext()
    millennium.call_frontend_method("MusicController.PlayNext")
end

local function PlayPrevious()
    millennium.call_frontend_method("MusicController.PlayPrevious")
end

local function TogglePlayPause()
    millennium.call_frontend_method("MusicController.TogglePlayPause")
end

function setup_smtc()
    -- TODO: this crashes with access violation :(

    -- SMTC.set_is_play_enabled(true)
    -- SMTC.set_is_stop_enabled(false)
    -- SMTC.set_is_pause_enabled(true)
    -- SMTC.set_is_record_enabled(false)
    -- SMTC.set_is_fastforward_enabled(false)
    -- SMTC.set_is_rewind_enabled(false)
    -- SMTC.set_is_previous_enabled(true)
    -- SMTC.set_is_next_enabled(true)
    -- SMTC.set_is_channelup_enabled(false)
    -- SMTC.set_is_channeldown_enabled(false)
    -- SMTC.set_is_enabled(true)
    -- SMTC.set_media_type(SMTC.MediaPlaybackType.Music)
    -- SMTC.update_display_properties()

    -- TODO: listen to buttons and call js methods
end

local function on_load()
    smtc.init()

    print("Plugin loaded")

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
