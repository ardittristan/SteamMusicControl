---@diagnostic disable: undefined-field
local logger = require("logger")
local ffi = require("ffi")
local combase = ffi.load("combase.dll")
local msvcrt = ffi.load("msvcrt.dll")
local winrt_string = ffi.load("api-ms-win-core-winrt-string-l1-1-0.dll")
local winrt_core = ffi.load("api-ms-win-core-winrt-l1-1-0.dll")

require("smtc_h")

---@param ws ffi.cdata*
local function wcslen(ws)
    return tonumber(msvcrt.wcslen(ffi.cast("const wchar_t*", ws)))
end

---@param ws ffi.cdata*
---@param length number|nil
local function wstr2str(ws, length)
    local szbuf = length or wcslen(ws)
    local buf = ffi.new("char[?]", szbuf+1)
    if msvcrt.wcstombs(buf, ffi.cast("const wchar_t*", ws), szbuf) == -1 then
        return nil
    end
    return ffi.string(buf, szbuf)
end

---@param s string
local function str2wstr(s)
    local szbuf = s:len()
    local buf = ffi.new('wchar_t[?]', szbuf+1)
    if msvcrt.mbstowcs(buf, s, szbuf) == -1 then
        return nil
    end
    return buf
end

---@param s string
local function str2cwstr(s)
    local p = str2wstr(s)
    if p == nil then
        return nil
    end
    return ffi.cast("const wchar_t*", p)
end

---@param value boolean
local function bool_to_num(value)
    return value and 1 or 0
end

local IID_ISystemMediaTransportControls = ffi.new("IID", {
    Data1 = 0x99fa3ff4,
    Data2 = 0x1742,
    Data3 = 0x42a6,
    Data4 = {0x90,0x2e, 0x08,0x7d,0x41,0xf9,0x65,0xec}
})

local IID_ISystemMediaTransportControlsInterop = ffi.new("IID", {
    Data1 = 0xddb0472d,
    Data2 = 0xc911,
    Data3 = 0x4a1f,
    Data4 = {0x86,0xd9, 0xdc,0x3d,0x71,0xa9,0x5f,0x5a}
})

local IID_IActivationFactory = ffi.new("IID", {
    Data1 = 0x00000035,
    Data2 = 0x0000,
    Data3 = 0x0000,
    Data4 = {0xc0,0x00, 0x00,0x00,0x00,0x00,0x00,0x46}
})

local IID_IMusicDisplayProperties2 = ffi.new("IID", {
    Data1 = 0x00368462,
    Data2 = 0x97d3,
    Data3 = 0x44b9,
    Data4 = {0xb0,0x0f, 0x00,0x8a,0xfc,0xef,0xaf,0x18}
})

--- you MUST call init() before using and release() when shutting down
local SMTC = {
    ---@enum MediaPlaybackStatus
    MediaPlaybackStatus = {
        Closed = 0,
        Changing = 1,
        Stopped = 2,
        Playing = 3,
        Paused = 4
    },

    ---@enum MediaPlaybackType
    MediaPlaybackType = {
        Unknown = 0,
        Music = 1,
        Video = 2,
        Image = 3
    },

    ---@enum SoundLevel
    SoundLevel = {
        Muted = 0,
        Low = 1,
        Full = 2
    },

    ---@enum SystemMediaTransportControlsButton
    SystemMediaTransportControlsButton = {
        Play = 0,
        Pause = 1,
        Stop = 2,
        Record = 3,
        FastForward = 4,
        Rewind = 5,
        Next = 6,
        Previous = 7,
        ChannelUp = 8,
        ChannelDown = 9
    },

    ---@enum SystemMediaTransportControlsProperty
    SystemMediaTransportControlsProperty = {
        SoundLevel = 0
    }
}

---@alias vtable {lpVtbl: unknown}

---@type ffi.cdata*
local pFactory = nil
---@type vtable
local factory = nil
---@type ffi.cdata*
local pSmtci = nil
---@type vtable
local smtci = nil
local window = nil
---@type ffi.cdata*
local pSmtc = nil
---@type vtable
local smtc = nil
---@type ffi.cdata*
local pSmtc_display_updater = nil
---@type vtable
local smtc_display_updater = nil
---@type ffi.cdata*
local pSmtc_music_properties = nil
---@type vtable
local smtc_music_properties = nil
local pSmtc_music_properties2 = nil
---@type vtable
local smtc_music_properties2 = nil

function SMTC.init()
    local hr = winrt_core.RoInitialize(1)
    logger:info(string.format("RoInitialize hr = 0x%08X", hr))

    if factory == nil then
        local media_control_statics_name = str2cwstr("Windows.Media.SystemMediaTransportControls")
        local media_control_statics_name_hstring = ffi.new("HSTRING[1]")

        hr = winrt_string.WindowsCreateString(media_control_statics_name, 42, media_control_statics_name_hstring)
        logger:info(string.format("WindowsCreateString hr = 0x%08X", hr))

        pFactory = ffi.new("void*[1]")
        hr = combase.RoGetActivationFactory(media_control_statics_name_hstring[0], IID_IActivationFactory, pFactory)
        factory = ffi.cast("IActivationFactory*", pFactory[0])
        logger:info(string.format("RoGetActivationFactory hr = 0x%08X", hr))

        hr = winrt_string.WindowsDeleteString(media_control_statics_name_hstring[0])
        logger:info(string.format("WindowsDeleteString hr = 0x%08X", hr))
    end

    if smtci == nil then
        pSmtci = ffi.new("void*[1]")
        hr = factory.lpVtbl.QueryInterface(factory, IID_ISystemMediaTransportControlsInterop, pSmtci)
        smtci = ffi.cast("ISystemMediaTransportControlsInterop*", pSmtci[0])
        logger:info(string.format("IActivationFactory_QueryInterface hr = 0x%08X", hr))
    end

    if window == nil then
        window = ffi.C.CreateWindowExA(0, "static", "MediaControllerWindow", 0, 0x80000000, 0x80000000, 800, 600, nil, nil, ffi.C.GetModuleHandleA(nil), nil)
    end

    if smtc == nil then
        pSmtc = ffi.new("void*[1]")
        hr = smtci.lpVtbl.GetForWindow(smtci, window, IID_ISystemMediaTransportControls, pSmtc)
        smtc = ffi.cast("ISystemMediaTransportControls*", pSmtc[0])
        logger:info(string.format("ISystemMediaTransportControlsInterop_GetForWindow hr = 0x%08X", hr))
    end

    if smtc_display_updater == nil then
        pSmtc_display_updater = ffi.new("ISystemMediaTransportControlsDisplayUpdater*[1]")
        hr = smtc.lpVtbl.get_DisplayUpdater(smtc, pSmtc_display_updater)
        smtc_display_updater = pSmtc_display_updater[0]
        logger:info(string.format("ISystemMediaTransportControls_get_DisplayUpdater hr = 0x%08X", hr))
    end

end

---@diagnostic disable: cast-local-type
local function release_display_properties()
    if smtc_music_properties ~= nil then
        smtc_music_properties.lpVtbl.Release(smtc_music_properties)
        smtc_music_properties = nil
    end
    if smtc_music_properties2 ~= nil then
        smtc_music_properties2.lpVtbl.Release(smtc_music_properties2)
        smtc_music_properties2 = nil
    end
end

function SMTC.release()
    release_display_properties()

    if smtc_display_updater ~= nil then
        smtc_display_updater.lpVtbl.Release(smtc_display_updater)
        smtc_display_updater = nil
    end

    if smtc ~= nil then
        smtc.lpVtbl.Release(smtc)
        smtc = nil
    end

    if window ~= nil then
        ffi.C.DestroyWindow(window)
        window = nil
    end

    if smtci ~= nil then
        smtci.lpVtbl.Release(smtci)
        smtci = nil
    end

    if factory ~= nil then
        factory.lpVtbl.Release(factory)
        factory = nil
    end

    winrt_core.RoUninitialize()
end
---@diagnostic enable: cast-local-type

local function ensure_music_properties()
    if smtc_music_properties ~= nil then
        return true
    end
    pSmtc_music_properties = ffi.new("IMusicDisplayProperties*[1]")
    local hr = smtc_display_updater.lpVtbl.get_MusicProperties(smtc_display_updater, pSmtc_music_properties)
    logger:info(string.format("ISystemMediaTransportControlsDisplayUpdater_get_MusicProperties hr = 0x%08X", hr))
    if hr ~= 0 then
        return false
    end
    smtc_music_properties = pSmtc_music_properties[0]
    return true
end

local function ensure_music_properties2()
    if smtc_music_properties2 ~= nil then
        return true
    end
    if not ensure_music_properties() then
        return false
    end
    pSmtc_music_properties2 = ffi.new("IMusicDisplayProperties2*[1]")
    local hr = smtc_music_properties.lpVtbl.QueryInterface(smtc_music_properties, IID_IMusicDisplayProperties2, pSmtc_music_properties2)
    logger:info(string.format("IMusicDisplayProperties_QueryInterface hr = 0x%08X", hr))
    if hr ~= 0 then
        return false
    end
    smtc_music_properties2 = pSmtc_music_properties2[0]
    return true
end

function SMTC.get_playback_status()
    local ret = ffi.new("MediaPlaybackStatus[1]")
    smtc.lpVtbl.get_PlaybackStatus(smtc, ret)
    return ret[0] or 0
end

---@param status MediaPlaybackStatus
function SMTC.set_playback_status(status)
    return smtc.lpVtbl.put_PlaybackStatus(smtc, status) == 0
end

function SMTC.get_is_enabled()
    local ret = ffi.new("boolean[1]")
    smtc.lpVtbl.get_IsEnabled(smtc, ret)
    return ret[0] ~= 0
end

---@param value boolean
function SMTC.set_is_enabled(value)
    return smtc.lpVtbl.put_IsEnabled(smtc, bool_to_num(value)) == 0
end

function SMTC.get_is_play_enabled()
    local ret = ffi.new("boolean[1]")
    smtc.lpVtbl.get_IsPlayEnabled(smtc, ret)
    return ret[0] ~= 0
end

---@param value boolean
function SMTC.set_is_play_enabled(value)
    return smtc.lpVtbl.put_IsPlayEnabled(smtc, bool_to_num(value)) == 0
end

function SMTC.get_is_stop_enabled()
    local ret = ffi.new("boolean[1]")
    smtc.lpVtbl.get_IsStopEnabled(smtc, ret)
    return ret[0] ~= 0
end

---@param value boolean
function SMTC.set_is_stop_enabled(value)
    return smtc.lpVtbl.put_IsStopEnabled(smtc, bool_to_num(value)) == 0
end

function SMTC.get_is_pause_enabled()
    local ret = ffi.new("boolean[1]")
    smtc.lpVtbl.get_IsPauseEnabled(smtc, ret)
    return ret[0] ~= 0
end

---@param value boolean
function SMTC.set_is_pause_enabled(value)
    return smtc.lpVtbl.put_IsPauseEnabled(smtc, bool_to_num(value)) == 0
end

function SMTC.get_is_record_enabled()
    local ret = ffi.new("boolean[1]")
    smtc.lpVtbl.get_IsRecordEnabled(smtc, ret)
    return ret[0] ~= 0
end

---@param value boolean
function SMTC.set_is_record_enabled(value)
    return smtc.lpVtbl.put_IsRecordEnabled(smtc, bool_to_num(value)) == 0
end

function SMTC.get_is_fastforward_enabled()
    local ret = ffi.new("boolean[1]")
    smtc.lpVtbl.get_IsFastForwardEnabled(smtc, ret)
    return ret[0] ~= 0
end

---@param value boolean
function SMTC.set_is_fastforward_enabled(value)
    return smtc.lpVtbl.put_IsFastForwardEnabled(smtc, bool_to_num(value)) == 0
end

function SMTC.get_is_rewind_enabled()
    local ret = ffi.new("boolean[1]")
    smtc.lpVtbl.get_IsRewindEnabled(smtc, ret)
    return ret[0] ~= 0
end

---@param value boolean
function SMTC.set_is_rewind_enabled(value)
    return smtc.lpVtbl.put_IsRewindEnabled(smtc, bool_to_num(value)) == 0
end

function SMTC.get_is_previous_enabled()
    local ret = ffi.new("boolean[1]")
    smtc.lpVtbl.get_IsPreviousEnabled(smtc, ret)
    return ret[0] ~= 0
end

---@param value boolean
function SMTC.set_is_previous_enabled(value)
    return smtc.lpVtbl.put_IsPreviousEnabled(smtc, bool_to_num(value)) == 0
end

function SMTC.get_is_next_enabled()
    local ret = ffi.new("boolean[1]")
    smtc.lpVtbl.get_IsNextEnabled(smtc, ret)
    return ret[0] ~= 0
end

---@param value boolean
function SMTC.set_is_next_enabled(value)
    return smtc.lpVtbl.put_IsNextEnabled(smtc, bool_to_num(value)) == 0
end

function SMTC.get_is_channelup_enabled()
    local ret = ffi.new("boolean[1]")
    smtc.lpVtbl.get_IsChannelUpEnabled(smtc, ret)
    return ret[0] ~= 0
end

---@param value boolean
function SMTC.set_is_channelup_enabled(value)
    return smtc.lpVtbl.put_IsChannelUpEnabled(smtc, bool_to_num(value)) == 0
end

function SMTC.get_is_channeldown_enabled()
    local ret = ffi.new("boolean[1]")
    smtc.lpVtbl.get_IsChannelDownEnabled(smtc, ret)
    return ret[0] ~= 0
end

---@param value boolean
function SMTC.set_is_channeldown_enabled(value)
    return smtc.lpVtbl.put_IsChannelDownEnabled(smtc, bool_to_num(value)) == 0
end

---@return MediaPlaybackType
function SMTC.get_media_type()
    local ret = ffi.new("MediaPlaybackType[1]")
    smtc_display_updater.lpVtbl.get_Type(smtc_display_updater, ret)
    return ret[0] or 0
end

---@param type MediaPlaybackType
function SMTC.set_media_type(type)
    return smtc_display_updater.lpVtbl.put_Type(smtc_display_updater, type) == 0
end

function SMTC.update_display_properties()
    return smtc_display_updater.lpVtbl.Update(smtc_display_updater) == 0
end

function SMTC.get_title()
    if not ensure_music_properties() then
        return nil
    end
    local retHstring = ffi.new("HSTRING[1]")
    smtc_music_properties.lpVtbl.get_Title(smtc_music_properties, retHstring)
    local ret = wstr2str(winrt_string.WindowsGetStringRawBuffer(retHstring[0], nil))
    winrt_string.WindowsDeleteString(retHstring[0])
    return ret
end

---@param title string
function SMTC.set_title(title)
    if not ensure_music_properties() then
        return false
    end
    local cwstring = str2cwstr(title)
    local hstring = ffi.new("HSTRING[1]")

    local hr = winrt_string.WindowsCreateString(cwstring, hstring)
    logger:info(string.format("set_title WindowsCreateString hr = 0x%08X", hr))

    local ret = smtc_music_properties.lpVtbl.put_Title(smtc_music_properties, hstring[0])
    winrt_string.WindowsDeleteString(hstring[0])
    return ret == 0
end

function SMTC.get_album_title()
    if not ensure_music_properties2() then
        return nil
    end
    local retHstring = ffi.new("HSTRING[1]")
    smtc_music_properties2.lpVtbl.get_AlbumTitle(smtc_music_properties2, retHstring)
    local ret = wstr2str(winrt_string.WindowsGetStringRawBuffer(retHstring[0], nil))
    winrt_string.WindowsDeleteString(retHstring[0])
    return ret
end

---@param title string
function SMTC.set_album_title(title)
    if not ensure_music_properties2() then
        return false
    end
    local cwstring = str2cwstr(title)
    local hstring = ffi.new("HSTRING[1]")

    local hr = winrt_string.WindowsCreateString(cwstring, hstring)
    logger:info(string.format("set_album_title WindowsCreateString hr = 0x%08X", hr))

    local ret = smtc_music_properties2.lpVtbl.put_AlbumTitle(smtc_music_properties2, hstring[0])
    winrt_string.WindowsDeleteString(hstring[0])
    return ret == 0
end

function SMTC.get_album_artist()
    if not ensure_music_properties() then
        return nil
    end
    local retHstring = ffi.new("HSTRING[1]")
    smtc_music_properties.lpVtbl.get_AlbumArtist(smtc_music_properties, retHstring)
    local ret = wstr2str(winrt_string.WindowsGetStringRawBuffer(retHstring[0], nil))
    winrt_string.WindowsDeleteString(retHstring[0])
    return ret
end

---@param artist string
function SMTC.set_album_artist(artist)
    if not ensure_music_properties() then
        return false
    end
    local cwstring = str2cwstr(artist)
    local hstring = ffi.new("HSTRING[1]")

    local hr = winrt_string.WindowsCreateString(cwstring, hstring)
    logger:info(string.format("set_album_artist WindowsCreateString hr = 0x%08X", hr))

    local ret = smtc_music_properties.lpVtbl.put_AlbumArtist(smtc_music_properties, hstring[0])
    winrt_string.WindowsDeleteString(hstring[0])
    return ret == 0
end

function SMTC.get_artist()
    if not ensure_music_properties() then
        return nil
    end
    local retHstring = ffi.new("HSTRING[1]")
    smtc_music_properties.lpVtbl.get_Artist(smtc_music_properties, retHstring)
    local ret = wstr2str(winrt_string.WindowsGetStringRawBuffer(retHstring[0], nil))
    winrt_string.WindowsDeleteString(retHstring[0])
    return ret
end

---@param artist string
function SMTC.set_artist(artist)
    if not ensure_music_properties() then
        return false
    end
    local cwstring = str2cwstr(artist)
    local hstring = ffi.new("HSTRING[1]")

    local hr = winrt_string.WindowsCreateString(cwstring, hstring)
    logger:info(string.format("set_artist WindowsCreateString hr = 0x%08X", hr))

    local ret = smtc_music_properties.lpVtbl.put_Artist(smtc_music_properties, hstring[0])
    winrt_string.WindowsDeleteString(hstring[0])
    return ret == 0
end

function SMTC.get_track_number()
    if not ensure_music_properties2() then
        return nil
    end
    local retHstring = ffi.new("HSTRING[1]")
    smtc_music_properties2.lpVtbl.get_TrackNumber(smtc_music_properties2, retHstring)
    local ret = wstr2str(winrt_string.WindowsGetStringRawBuffer(retHstring[0], nil))
    winrt_string.WindowsDeleteString(retHstring[0])
    return ret
end

---@param number string
function SMTC.set_track_number(number)
    if not ensure_music_properties2() then
        return false
    end
    local cwstring = str2cwstr(number)
    local hstring = ffi.new("HSTRING[1]")

    local hr = winrt_string.WindowsCreateString(cwstring, hstring)
    logger:info(string.format("set_track_number WindowsCreateString hr = 0x%08X", hr))

    local ret = smtc_music_properties2.lpVtbl.put_TrackNumber(smtc_music_properties2, hstring[0])
    winrt_string.WindowsDeleteString(hstring[0])
    return ret == 0
end

return SMTC
