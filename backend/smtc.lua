---@diagnostic disable: undefined-field
local logger = require("logger")
local ffi = require("ffi")
local combase = ffi.load("combase.dll")
local msvcrt = ffi.load("msvcrt.dll")
local winrt_string = ffi.load("api-ms-win-core-winrt-string-l1-1-0.dll")
local winrt_core = ffi.load("api-ms-win-core-winrt-l1-1-0.dll")

require("smtc_h")

local hstring = ffi.typeof("HSTRING[1]")
local voidptr = ffi.typeof("void*[1]")
local IID = ffi.typeof("IID")
local boolean = ffi.typeof("boolean[1]")
local ISystemMediaTransportControlsDisplayUpdaterPtr = ffi.typeof("ISystemMediaTransportControlsDisplayUpdater*[1]")
local MediaPlaybackType = ffi.typeof("MediaPlaybackType[1]")
local IMusicDisplayPropertiesPtr = ffi.typeof("IMusicDisplayProperties*[1]")
local IMusicDisplayProperties2Ptr_Raw = ffi.typeof("IMusicDisplayProperties2*")
local wchar = ffi.typeof("wchar_t[?]")
local cWcharPtr = ffi.typeof("const wchar_t*")

---@param s string|nil
local function str2wstr(s)
    if s == nil then
        return nil
    end
    local szbuf = s:len()
    local buf = wchar(szbuf+1)
    if msvcrt.mbstowcs(buf, s, szbuf) == -1 then
        return nil
    end
    return buf
end

---@param s string|nil
local function str2cwstr(s)
    if s == nil then
        return nil
    end
    local p = str2wstr(s)
    if p == nil then
        return nil
    end
    return ffi.cast(cWcharPtr, p)
end

---@param value boolean
local function bool_to_num(value)
    return value and 1 or 0
end

local IID_ISystemMediaTransportControls = IID({
    Data1 = 0x99fa3ff4,
    Data2 = 0x1742,
    Data3 = 0x42a6,
    Data4 = {0x90,0x2e, 0x08,0x7d,0x41,0xf9,0x65,0xec}
})

local IID_ISystemMediaTransportControlsInterop = IID({
    Data1 = 0xddb0472d,
    Data2 = 0xc911,
    Data3 = 0x4a1f,
    Data4 = {0x86,0xd9, 0xdc,0x3d,0x71,0xa9,0x5f,0x5a}
})

local IID_IActivationFactory = IID({
    Data1 = 0x00000035,
    Data2 = 0x0000,
    Data3 = 0x0000,
    Data4 = {0xc0,0x00, 0x00,0x00,0x00,0x00,0x00,0x46}
})

local IID_IMusicDisplayProperties2 = IID({
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

---@type vtable
local factory = nil
---@type vtable
local smtci = nil
local window = nil
---@type vtable
local smtc = nil

function SMTC.init()
    local hr = winrt_core.RoInitialize(1)
    logger:info(string.format("RoInitialize hr = 0x%08X", hr))

    if factory == nil then
        local media_control_statics_name = str2cwstr("Windows.Media.SystemMediaTransportControls")
        local media_control_statics_name_hstring = hstring()

        hr = winrt_string.WindowsCreateString(media_control_statics_name, 42, media_control_statics_name_hstring)
        logger:info(string.format("WindowsCreateString hr = 0x%08X", hr))

        local pFactory = voidptr()
        hr = combase.RoGetActivationFactory(media_control_statics_name_hstring[0], IID_IActivationFactory, pFactory)
        factory = ffi.cast("IActivationFactory*", pFactory[0])
        logger:info(string.format("RoGetActivationFactory hr = 0x%08X", hr))

        hr = winrt_string.WindowsDeleteString(media_control_statics_name_hstring[0])
        logger:info(string.format("WindowsDeleteString hr = 0x%08X", hr))
    end

    if smtci == nil then
        local pSmtci = voidptr()
        hr = factory.lpVtbl.QueryInterface(factory, IID_ISystemMediaTransportControlsInterop, pSmtci)
        smtci = ffi.cast("ISystemMediaTransportControlsInterop*", pSmtci[0])
        logger:info(string.format("IActivationFactory_QueryInterface hr = 0x%08X", hr))
    end

    if window == nil then
        window = ffi.C.CreateWindowExA(0, "static", "MediaControllerWindow", 0, 0x80000000, 0x80000000, 800, 600, nil, nil, ffi.C.GetModuleHandleA(nil), nil)
    end

    if smtc == nil then
        local pSmtc = voidptr()
        hr = smtci.lpVtbl.GetForWindow(smtci, window, IID_ISystemMediaTransportControls, pSmtc)
        smtc = ffi.cast("ISystemMediaTransportControls*", pSmtc[0])
        logger:info(string.format("ISystemMediaTransportControlsInterop_GetForWindow hr = 0x%08X", hr))
    end

-- event handler: https://github.com/FoxCouncil/OrgZ/blob/faed618017d4f6389e795e4f635d2566dc9d7929/Services/SmtcService.cs#L223
-- https://learn.microsoft.com/en-us/office/client-developer/outlook/mapi/implementing-iunknown-in-c

end

---@param title string
---@param artist string
---@param album_title string|nil
---@param album_artist string|nil
---@param track_number string|nil
function SMTC.set_display(title, artist, album_title, album_artist, track_number)
    local cTitle = str2cwstr(title)
    local cArtist = str2cwstr(artist)
    local cAlbumTitle = str2cwstr(album_title)
    local cAlbumArtist = str2cwstr(album_artist)
    local cTrackNumber = str2cwstr(track_number)
    local pHstring = hstring()

    local pSmtc_display_updater = ISystemMediaTransportControlsDisplayUpdaterPtr()
    local hr = smtc.lpVtbl.get_DisplayUpdater(smtc, pSmtc_display_updater)
    local smtc_display_updater = pSmtc_display_updater[0]
    logger:info(string.format("ISystemMediaTransportControls_get_DisplayUpdater hr = 0x%08X", hr))

    local mediaType = MediaPlaybackType()
    smtc_display_updater.lpVtbl.get_Type(smtc_display_updater, mediaType)

    if mediaType ~= SMTC.MediaPlaybackType.Music then
        smtc_display_updater.lpVtbl.put_Type(smtc_display_updater, SMTC.MediaPlaybackType.Music)
        smtc_display_updater.lpVtbl.Update(smtc_display_updater)
    end

    local pSmtc_music_properties = IMusicDisplayPropertiesPtr()
    hr = smtc_display_updater.lpVtbl.get_MusicProperties(smtc_display_updater, pSmtc_music_properties)
    local smtc_music_properties = pSmtc_music_properties[0]
    logger:info(string.format("ISystemMediaTransportControlsDisplayUpdater_get_MusicProperties hr = 0x%08X", hr))

    local pSmtc_music_properties2 = voidptr()
    hr = smtc_music_properties.lpVtbl.QueryInterface(smtc_music_properties, IID_IMusicDisplayProperties2, pSmtc_music_properties2)
    logger:info(string.format("IMusicDisplayProperties_QueryInterface hr = 0x%08X", hr))
    local smtc_music_properties2 = ffi.cast(IMusicDisplayProperties2Ptr_Raw, pSmtc_music_properties2[0])

    --- put title
    hr = winrt_string.WindowsCreateString(cTitle, msvcrt.wcslen(cTitle), pHstring)
    logger:info(string.format("put title WindowsCreateString hr = 0x%08X", hr))
    hr = smtc_music_properties.lpVtbl.put_Title(smtc_music_properties, pHstring[0])
    winrt_string.WindowsDeleteString(pHstring[0])
    logger:info(string.format("put_Title hr = 0x%08X", hr))
    -- end put title

    --- put artist
    hr = winrt_string.WindowsCreateString(cArtist, msvcrt.wcslen(cArtist), pHstring)
    logger:info(string.format("put artist WindowsCreateString hr = 0x%08X", hr))
    hr = smtc_music_properties.lpVtbl.put_Artist(smtc_music_properties, pHstring[0])
    winrt_string.WindowsDeleteString(pHstring[0])
    logger:info(string.format("put_Artist hr = 0x%08X", hr))
    -- end put artist

    --- put album artist
    if album_artist ~= nil then
        hr = winrt_string.WindowsCreateString(cAlbumArtist, msvcrt.wcslen(cAlbumArtist), pHstring)
        logger:info(string.format("put album_artist WindowsCreateString hr = 0x%08X", hr))
        hr = smtc_music_properties.lpVtbl.put_AlbumArtist(smtc_music_properties, pHstring[0])
        winrt_string.WindowsDeleteString(pHstring[0])
        logger:info(string.format("put_AlbumArtist hr = 0x%08X", hr))
    end
    -- end put album artist

    --- put album title
    if album_title ~= nil then
        hr = winrt_string.WindowsCreateString(cAlbumTitle, msvcrt.wcslen(cAlbumTitle), pHstring)
        logger:info(string.format("put album_title WindowsCreateString hr = 0x%08X", hr))
        hr = smtc_music_properties2.lpVtbl.put_AlbumTitle(smtc_music_properties2, pHstring[0])
        winrt_string.WindowsDeleteString(pHstring[0])
        logger:info(string.format("put_AlbumTitle hr = 0x%08X", hr))
    end
    -- end put album title

    --- put track number
    if track_number ~= nil then
        hr = winrt_string.WindowsCreateString(cTrackNumber, msvcrt.wcslen(cTrackNumber), pHstring)
        logger:info(string.format("put track_number WindowsCreateString hr = 0x%08X", hr))
        hr = smtc_music_properties2.lpVtbl.put_TrackNumber(smtc_music_properties2, pHstring[0])
        winrt_string.WindowsDeleteString(pHstring[0])
        logger:info(string.format("put_TrackNumber hr = 0x%08X", hr))
    end
    -- end put track number

    smtc_display_updater.lpVtbl.Update(smtc_display_updater)

    smtc_music_properties2.lpVtbl.Release(smtc_music_properties2)
    smtc_music_properties.lpVtbl.Release(smtc_music_properties)
    smtc_display_updater.lpVtbl.Release(smtc_display_updater)
end

---@diagnostic disable: cast-local-type
function SMTC.release()
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
    local ret = boolean()
    smtc.lpVtbl.get_IsEnabled(smtc, ret)
    return ret[0] ~= 0
end

---@param value boolean
function SMTC.set_is_enabled(value)
    return smtc.lpVtbl.put_IsEnabled(smtc, bool_to_num(value)) == 0
end

function SMTC.get_is_play_enabled()
    local ret = boolean()
    smtc.lpVtbl.get_IsPlayEnabled(smtc, ret)
    return ret[0] ~= 0
end

---@param value boolean
function SMTC.set_is_play_enabled(value)
    return smtc.lpVtbl.put_IsPlayEnabled(smtc, bool_to_num(value)) == 0
end

function SMTC.get_is_stop_enabled()
    local ret = boolean()
    smtc.lpVtbl.get_IsStopEnabled(smtc, ret)
    return ret[0] ~= 0
end

---@param value boolean
function SMTC.set_is_stop_enabled(value)
    return smtc.lpVtbl.put_IsStopEnabled(smtc, bool_to_num(value)) == 0
end

function SMTC.get_is_pause_enabled()
    local ret = boolean()
    smtc.lpVtbl.get_IsPauseEnabled(smtc, ret)
    return ret[0] ~= 0
end

---@param value boolean
function SMTC.set_is_pause_enabled(value)
    return smtc.lpVtbl.put_IsPauseEnabled(smtc, bool_to_num(value)) == 0
end

function SMTC.get_is_record_enabled()
    local ret = boolean()
    smtc.lpVtbl.get_IsRecordEnabled(smtc, ret)
    return ret[0] ~= 0
end

---@param value boolean
function SMTC.set_is_record_enabled(value)
    return smtc.lpVtbl.put_IsRecordEnabled(smtc, bool_to_num(value)) == 0
end

function SMTC.get_is_fastforward_enabled()
    local ret = boolean()
    smtc.lpVtbl.get_IsFastForwardEnabled(smtc, ret)
    return ret[0] ~= 0
end

---@param value boolean
function SMTC.set_is_fastforward_enabled(value)
    return smtc.lpVtbl.put_IsFastForwardEnabled(smtc, bool_to_num(value)) == 0
end

function SMTC.get_is_rewind_enabled()
    local ret = boolean()
    smtc.lpVtbl.get_IsRewindEnabled(smtc, ret)
    return ret[0] ~= 0
end

---@param value boolean
function SMTC.set_is_rewind_enabled(value)
    return smtc.lpVtbl.put_IsRewindEnabled(smtc, bool_to_num(value)) == 0
end

function SMTC.get_is_previous_enabled()
    local ret = boolean()
    smtc.lpVtbl.get_IsPreviousEnabled(smtc, ret)
    return ret[0] ~= 0
end

---@param value boolean
function SMTC.set_is_previous_enabled(value)
    return smtc.lpVtbl.put_IsPreviousEnabled(smtc, bool_to_num(value)) == 0
end

function SMTC.get_is_next_enabled()
    local ret = boolean()
    smtc.lpVtbl.get_IsNextEnabled(smtc, ret)
    return ret[0] ~= 0
end

---@param value boolean
function SMTC.set_is_next_enabled(value)
    return smtc.lpVtbl.put_IsNextEnabled(smtc, bool_to_num(value)) == 0
end

function SMTC.get_is_channelup_enabled()
    local ret = boolean()
    smtc.lpVtbl.get_IsChannelUpEnabled(smtc, ret)
    return ret[0] ~= 0
end

---@param value boolean
function SMTC.set_is_channelup_enabled(value)
    return smtc.lpVtbl.put_IsChannelUpEnabled(smtc, bool_to_num(value)) == 0
end

function SMTC.get_is_channeldown_enabled()
    local ret = boolean()
    smtc.lpVtbl.get_IsChannelDownEnabled(smtc, ret)
    return ret[0] ~= 0
end

---@param value boolean
function SMTC.set_is_channeldown_enabled(value)
    return smtc.lpVtbl.put_IsChannelDownEnabled(smtc, bool_to_num(value)) == 0
end

return SMTC
