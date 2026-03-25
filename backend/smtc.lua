---@diagnostic disable: undefined-field
local logger = require("logger")
local ffi = require("ffi")
local combase = ffi.load("combase.dll")
local msvcrt = ffi.load('msvcrt.dll')
local winrt_string = ffi.load("api-ms-win-core-winrt-string-l1-1-0.dll")
local winrt_core = ffi.load("api-ms-win-core-winrt-l1-1-0.dll")

ffi.cdef[[
typedef struct {
    uint32_t Data1;
    uint16_t Data2;
    uint16_t Data3;
    uint8_t Data4[8];
} GUID;

typedef enum TrustLevel {
    BaseTrust = 0,
    PartialTrust = 1,
    FullTrust = 2
} TrustLevel;

typedef enum RO_INIT_TYPE {
    RO_INIT_SINGLETHREADED = 0,
    RO_INIT_MULTITHREADED = 1
} RO_INIT_TYPE;

typedef unsigned char boolean;

typedef GUID IID;
typedef void* HWND;
typedef void* HSTRING;
typedef void* HINSTANCE;
typedef HINSTANCE HMODULE;
typedef void* HMENU;
typedef const void* REFIID;
typedef long HRESULT;
typedef unsigned long ULONG;
typedef unsigned int UINT32;
typedef signed long long INT64;
typedef const wchar_t* LPCWSTR;
typedef const char* LPCSTR;
typedef unsigned long DWORD;
typedef void* LPVOID;

typedef struct ISystemMediaTransportControlsInterop ISystemMediaTransportControlsInterop;
typedef struct ISystemMediaTransportControlsInteropVtbl {
    HRESULT (__stdcall *QueryInterface)(ISystemMediaTransportControlsInterop*, REFIID, void**);
    ULONG (__stdcall *AddRef)(ISystemMediaTransportControlsInterop*);
    ULONG (__stdcall *Release)(ISystemMediaTransportControlsInterop*);
    HRESULT (__stdcall *GetIids)(ISystemMediaTransportControlsInterop*, ULONG*, IID**);
    HRESULT (__stdcall *GetRuntimeClassName)(ISystemMediaTransportControlsInterop*, HSTRING*);
    HRESULT (__stdcall *GetTrustLevel)(ISystemMediaTransportControlsInterop*, TrustLevel*);
    HRESULT (__stdcall *GetForWindow)(ISystemMediaTransportControlsInterop*, HWND, REFIID, void**);
} ISystemMediaTransportControlsInteropVtbl;
struct ISystemMediaTransportControlsInterop { ISystemMediaTransportControlsInteropVtbl* lpVtbl; };

typedef struct IInspectable IInspectable;
typedef struct IInspectableVtbl {
    HRESULT (__stdcall *QueryInterface)(IInspectable*, REFIID, void**);
    ULONG (__stdcall *AddRef)(IInspectable*);
    ULONG (__stdcall *Release)(IInspectable*);
    HRESULT (__stdcall *GetIids)(IInspectable*, ULONG*, IID**);
    HRESULT (__stdcall *GetRuntimeClassName)(IInspectable*, HSTRING*);
    HRESULT (__stdcall *GetTrustLevel)(IInspectable*, TrustLevel*);
} IInspectableVtbl;
struct IInspectable { IInspectableVtbl* lpVtbl; };

typedef struct IActivationFactory IActivationFactory;
typedef struct IActivationFactoryVtbl {
    HRESULT (__stdcall *QueryInterface)(IActivationFactory*, REFIID, void**);
    ULONG (__stdcall *AddRef)(IActivationFactory*);
    ULONG (__stdcall *Release)(IActivationFactory*);
    HRESULT (__stdcall *GetIids)(IActivationFactory*, ULONG*, IID**);
    HRESULT (__stdcall *GetRuntimeClassName)(IActivationFactory*, HSTRING*);
    HRESULT (__stdcall *GetTrustLevel)(IActivationFactory*, TrustLevel*);
    HRESULT (__stdcall *ActivateInstance)(IActivationFactory*, IInspectable**);
} IActivationFactoryVtbl;
struct IActivationFactory { IActivationFactoryVtbl* lpVtbl; };

typedef enum MediaPlaybackStatus {
    MediaPlaybackStatus_Closed = 0,
    MediaPlaybackStatus_Changing = 1,
    MediaPlaybackStatus_Stopped = 2,
    MediaPlaybackStatus_Playing = 3,
    MediaPlaybackStatus_Paused = 4
} MediaPlaybackStatus;

typedef enum MediaPlaybackType {
    MediaPlaybackType_Unknown = 0,
    MediaPlaybackType_Music = 1,
    MediaPlaybackType_Video = 2,
    MediaPlaybackType_Image = 3
} MediaPlaybackType;

typedef enum SoundLevel {
    SoundLevel_Muted = 0,
    SoundLevel_Low = 1,
    SoundLevel_Full = 2
} SoundLevel;

typedef enum SystemMediaTransportControlsButton {
    SystemMediaTransportControlsButton_Play = 0,
    SystemMediaTransportControlsButton_Pause = 1,
    SystemMediaTransportControlsButton_Stop = 2,
    SystemMediaTransportControlsButton_Record = 3,
    SystemMediaTransportControlsButton_FastForward = 4,
    SystemMediaTransportControlsButton_Rewind = 5,
    SystemMediaTransportControlsButton_Next = 6,
    SystemMediaTransportControlsButton_Previous = 7,
    SystemMediaTransportControlsButton_ChannelUp = 8,
    SystemMediaTransportControlsButton_ChannelDown = 9
} SystemMediaTransportControlsButton;

typedef enum SystemMediaTransportControlsProperty {
    SystemMediaTransportControlsProperty_SoundLevel = 0
} SystemMediaTransportControlsProperty;

typedef struct EventRegistrationToken EventRegistrationToken;
struct EventRegistrationToken {
    INT64 value;
};

typedef struct IMusicDisplayProperties IMusicDisplayProperties;
typedef struct IMusicDisplayPropertiesVtbl {
    HRESULT (__stdcall *QueryInterface)(IMusicDisplayProperties*, REFIID, void**);
    ULONG (__stdcall *AddRef)(IMusicDisplayProperties*);
    ULONG (__stdcall *Release)(IMusicDisplayProperties*);
    HRESULT (__stdcall *GetIids)(IMusicDisplayProperties*, ULONG*, IID**);
    HRESULT (__stdcall *GetRuntimeClassName)(IMusicDisplayProperties*, HSTRING*);
    HRESULT (__stdcall *GetTrustLevel)(IMusicDisplayProperties*, TrustLevel*);
    HRESULT (__stdcall *get_Title)(IMusicDisplayProperties*, HSTRING*);
    HRESULT (__stdcall *put_Title)(IMusicDisplayProperties*, HSTRING);
    HRESULT (__stdcall *get_AlbumArtist)(IMusicDisplayProperties*, HSTRING*);
    HRESULT (__stdcall *put_AlbumArtist)(IMusicDisplayProperties*, HSTRING);
    HRESULT (__stdcall *get_Artist)(IMusicDisplayProperties*, HSTRING*);
    HRESULT (__stdcall *put_Artist)(IMusicDisplayProperties*, HSTRING);
} IMusicDisplayPropertiesVtbl;
struct IMusicDisplayProperties { IMusicDisplayPropertiesVtbl* lpVtbl; };

typedef struct IVideoDisplayProperties IVideoDisplayProperties;
typedef struct IVideoDisplayPropertiesVtbl {
    HRESULT (__stdcall *QueryInterface)(IVideoDisplayProperties*, REFIID, void**);
    ULONG (__stdcall *AddRef)(IVideoDisplayProperties*);
    ULONG (__stdcall *Release)(IVideoDisplayProperties*);
    HRESULT (__stdcall *GetIids)(IVideoDisplayProperties*, ULONG*, IID**);
    HRESULT (__stdcall *GetRuntimeClassName)(IVideoDisplayProperties*, HSTRING*);
    HRESULT (__stdcall *GetTrustLevel)(IVideoDisplayProperties*, TrustLevel*);
    HRESULT (__stdcall *get_Title)(IVideoDisplayProperties*, HSTRING*);
    HRESULT (__stdcall *put_Title)(IVideoDisplayProperties*, HSTRING);
    HRESULT (__stdcall *get_Subtitle)(IVideoDisplayProperties*, HSTRING*);
    HRESULT (__stdcall *put_Subtitle)(IVideoDisplayProperties*, HSTRING);
} IVideoDisplayPropertiesVtbl;
struct IVideoDisplayProperties { IVideoDisplayPropertiesVtbl* lpVtbl; };

typedef struct IImageDisplayProperties IImageDisplayProperties;
typedef struct IImageDisplayPropertiesVtbl {
    HRESULT (__stdcall *QueryInterface)(IImageDisplayProperties*, REFIID, void**);
    ULONG (__stdcall *AddRef)(IImageDisplayProperties*);
    ULONG (__stdcall *Release)(IImageDisplayProperties*);
    HRESULT (__stdcall *GetIids)(IImageDisplayProperties*, ULONG*, IID**);
    HRESULT (__stdcall *GetRuntimeClassName)(IImageDisplayProperties*, HSTRING*);
    HRESULT (__stdcall *GetTrustLevel)(IImageDisplayProperties*, TrustLevel*);
    HRESULT (__stdcall *get_Title)(IImageDisplayProperties*, HSTRING*);
    HRESULT (__stdcall *put_Title)(IImageDisplayProperties*, HSTRING);
    HRESULT (__stdcall *get_Subtitle)(IImageDisplayProperties*, HSTRING*);
    HRESULT (__stdcall *put_Subtitle)(IImageDisplayProperties*, HSTRING);
} IImageDisplayPropertiesVtbl;
struct IImageDisplayProperties { IImageDisplayPropertiesVtbl* lpVtbl; };

typedef struct ISystemMediaTransportControlsDisplayUpdater ISystemMediaTransportControlsDisplayUpdater;
typedef struct ISystemMediaTransportControlsDisplayUpdaterVtbl {
    HRESULT (__stdcall *QueryInterface)(ISystemMediaTransportControlsDisplayUpdater*, REFIID, void**);
    ULONG (__stdcall *AddRef)(ISystemMediaTransportControlsDisplayUpdater*);
    ULONG (__stdcall *Release)(ISystemMediaTransportControlsDisplayUpdater*);
    HRESULT (__stdcall *GetIids)(ISystemMediaTransportControlsDisplayUpdater*, ULONG*, IID**);
    HRESULT (__stdcall *GetRuntimeClassName)(ISystemMediaTransportControlsDisplayUpdater*, HSTRING*);
    HRESULT (__stdcall *GetTrustLevel)(ISystemMediaTransportControlsDisplayUpdater*, TrustLevel*);
    HRESULT (__stdcall *get_Type)(ISystemMediaTransportControlsDisplayUpdater*, MediaPlaybackType*);
    HRESULT (__stdcall *put_Type)(ISystemMediaTransportControlsDisplayUpdater*, MediaPlaybackType);
    HRESULT (__stdcall *get_AppMediaId)(ISystemMediaTransportControlsDisplayUpdater*, HSTRING*);
    HRESULT (__stdcall *put_AppMediaId)(ISystemMediaTransportControlsDisplayUpdater*, HSTRING);
    HRESULT (__stdcall *get_Thumbnail)(ISystemMediaTransportControlsDisplayUpdater*, /* IRandomAccessStreamReference */ void**);
    HRESULT (__stdcall *put_Thumbnail)(ISystemMediaTransportControlsDisplayUpdater*, /* IRandomAccessStreamReference */ void*);
    HRESULT (__stdcall *get_MusicProperties)(ISystemMediaTransportControlsDisplayUpdater*, IMusicDisplayProperties**);
    HRESULT (__stdcall *get_VideoProperties)(ISystemMediaTransportControlsDisplayUpdater*, IVideoDisplayProperties**);
    HRESULT (__stdcall *get_ImageProperties)(ISystemMediaTransportControlsDisplayUpdater*, IImageDisplayProperties**);
    HRESULT (__stdcall *CopyFromFileAsync)(ISystemMediaTransportControlsDisplayUpdater*, MediaPlaybackType, /* IStorageFile */ void*, /* async_boolean */ void**);
    HRESULT (__stdcall *ClearAll)(ISystemMediaTransportControlsDisplayUpdater*);
    HRESULT (__stdcall *Update)(ISystemMediaTransportControlsDisplayUpdater*);
} ISystemMediaTransportControlsDisplayUpdaterVtbl;
struct ISystemMediaTransportControlsDisplayUpdater { ISystemMediaTransportControlsDisplayUpdaterVtbl* lpVtbl; };

typedef struct ISystemMediaTransportControlsButtonPressedEventArgs ISystemMediaTransportControlsButtonPressedEventArgs;
typedef struct ISystemMediaTransportControlsButtonPressedEventArgsVtbl {
    HRESULT (__stdcall *QueryInterface)(ISystemMediaTransportControlsButtonPressedEventArgs*, REFIID, void**);
    ULONG (__stdcall *AddRef)(ISystemMediaTransportControlsButtonPressedEventArgs*);
    ULONG (__stdcall *Release)(ISystemMediaTransportControlsButtonPressedEventArgs*);
    HRESULT (__stdcall *GetIids)(ISystemMediaTransportControlsButtonPressedEventArgs*, ULONG*, IID**);
    HRESULT (__stdcall *GetRuntimeClassName)(ISystemMediaTransportControlsButtonPressedEventArgs*, HSTRING*);
    HRESULT (__stdcall *GetTrustLevel)(ISystemMediaTransportControlsButtonPressedEventArgs*, TrustLevel*);
    HRESULT (__stdcall *get_Button)(ISystemMediaTransportControlsButtonPressedEventArgs*, SystemMediaTransportControlsButton*);
} ISystemMediaTransportControlsButtonPressedEventArgsVtbl;
struct ISystemMediaTransportControlsButtonPressedEventArgs { ISystemMediaTransportControlsButtonPressedEventArgsVtbl* lpVtbl; };

typedef struct ISystemMediaTransportControlsPropertyChangedEventArgs ISystemMediaTransportControlsPropertyChangedEventArgs;
typedef struct ISystemMediaTransportControlsPropertyChangedEventArgsVtbl {
    HRESULT (__stdcall *QueryInterface)(ISystemMediaTransportControlsPropertyChangedEventArgs*, REFIID, void**);
    ULONG (__stdcall *AddRef)(ISystemMediaTransportControlsPropertyChangedEventArgs*);
    ULONG (__stdcall *Release)(ISystemMediaTransportControlsPropertyChangedEventArgs*);
    HRESULT (__stdcall *GetIids)(ISystemMediaTransportControlsPropertyChangedEventArgs*, ULONG*, IID**);
    HRESULT (__stdcall *GetRuntimeClassName)(ISystemMediaTransportControlsPropertyChangedEventArgs*, HSTRING*);
    HRESULT (__stdcall *GetTrustLevel)(ISystemMediaTransportControlsPropertyChangedEventArgs*, TrustLevel*);
    HRESULT (__stdcall *get_Property)(ISystemMediaTransportControlsPropertyChangedEventArgs*, SystemMediaTransportControlsProperty*);
} ISystemMediaTransportControlsPropertyChangedEventArgsVtbl;
struct ISystemMediaTransportControlsPropertyChangedEventArgs { ISystemMediaTransportControlsPropertyChangedEventArgsVtbl lpVtbl; };

typedef struct ISystemMediaTransportControls ISystemMediaTransportControls;

typedef struct SystemMediaTransportControlsButtonPressedEventArgs SystemMediaTransportControlsButtonPressedEventArgs;
typedef struct SystemMediaTransportControlsButtonPressedEventArgsVtbl {
    HRESULT (__stdcall *QueryInterface)(SystemMediaTransportControlsButtonPressedEventArgs*, REFIID, void**);
    ULONG (__stdcall *AddRef)(SystemMediaTransportControlsButtonPressedEventArgs*);
    ULONG (__stdcall *Release)(SystemMediaTransportControlsButtonPressedEventArgs*);
    HRESULT (__stdcall *Invoke)(SystemMediaTransportControlsButtonPressedEventArgs*, ISystemMediaTransportControls*, ISystemMediaTransportControlsButtonPressedEventArgs*);
} SystemMediaTransportControlsButtonPressedEventArgsVtbl;
struct SystemMediaTransportControlsButtonPressedEventArgs { SystemMediaTransportControlsButtonPressedEventArgsVtbl* lpVtbl; };

typedef struct SystemMediaTransportControlsPropertyChangedEventArgs SystemMediaTransportControlsPropertyChangedEventArgs;
typedef struct SystemMediaTransportControlsPropertyChangedEventArgsVtbl {
    HRESULT (__stdcall *QueryInterface)(SystemMediaTransportControlsPropertyChangedEventArgs*, REFIID, void**);
    ULONG (__stdcall *AddRef)(SystemMediaTransportControlsPropertyChangedEventArgs*);
    ULONG (__stdcall *Release)(SystemMediaTransportControlsPropertyChangedEventArgs*);
    HRESULT (__stdcall *Invoke)(SystemMediaTransportControlsPropertyChangedEventArgs*, ISystemMediaTransportControls*, ISystemMediaTransportControlsPropertyChangedEventArgs*);
} SystemMediaTransportControlsPropertyChangedEventArgsVtbl;
struct SystemMediaTransportControlsPropertyChangedEventArgs { SystemMediaTransportControlsPropertyChangedEventArgsVtbl* lpVtbl; };

typedef struct ISystemMediaTransportControlsVtbl {
    HRESULT (__stdcall *QueryInterface)(ISystemMediaTransportControls*, REFIID, void**);
    ULONG (__stdcall *AddRef)(ISystemMediaTransportControls*);
    ULONG (__stdcall *Release)(ISystemMediaTransportControls*);
    HRESULT (__stdcall *GetIids)(ISystemMediaTransportControls*, ULONG*, IID**);
    HRESULT (__stdcall *GetRuntimeClassName)(ISystemMediaTransportControls*, HSTRING*);
    HRESULT (__stdcall *GetTrustLevel)(ISystemMediaTransportControls*, TrustLevel*);
    HRESULT (__stdcall *get_PlaybackStatus)(ISystemMediaTransportControls*, MediaPlaybackStatus*);
    HRESULT (__stdcall *put_PlaybackStatus)(ISystemMediaTransportControls*, MediaPlaybackStatus);
    HRESULT (__stdcall *get_DisplayUpdater)(ISystemMediaTransportControls*, ISystemMediaTransportControlsDisplayUpdater**);
    HRESULT (__stdcall *get_SoundLevel)(ISystemMediaTransportControls*, SoundLevel*);
    HRESULT (__stdcall *get_IsEnabled)(ISystemMediaTransportControls*, boolean*);
    HRESULT (__stdcall *put_IsEnabled)(ISystemMediaTransportControls*, boolean);
    HRESULT (__stdcall *get_IsPlayEnabled)(ISystemMediaTransportControls*, boolean*);
    HRESULT (__stdcall *put_IsPlayEnabled)(ISystemMediaTransportControls*, boolean);
    HRESULT (__stdcall *get_IsStopEnabled)(ISystemMediaTransportControls*, boolean*);
    HRESULT (__stdcall *put_IsStopEnabled)(ISystemMediaTransportControls*, boolean);
    HRESULT (__stdcall *get_IsPauseEnabled)(ISystemMediaTransportControls*, boolean*);
    HRESULT (__stdcall *put_IsPauseEnabled)(ISystemMediaTransportControls*, boolean);
    HRESULT (__stdcall *get_IsRecordEnabled)(ISystemMediaTransportControls*, boolean*);
    HRESULT (__stdcall *put_IsRecordEnabled)(ISystemMediaTransportControls*, boolean);
    HRESULT (__stdcall *get_IsFastForwardEnabled)(ISystemMediaTransportControls*, boolean*);
    HRESULT (__stdcall *put_IsFastForwardEnabled)(ISystemMediaTransportControls*, boolean);
    HRESULT (__stdcall *get_IsRewindEnabled)(ISystemMediaTransportControls*, boolean*);
    HRESULT (__stdcall *put_IsRewindEnabled)(ISystemMediaTransportControls*, boolean);
    HRESULT (__stdcall *get_IsPreviousEnabled)(ISystemMediaTransportControls*, boolean*);
    HRESULT (__stdcall *put_IsPreviousEnabled)(ISystemMediaTransportControls*, boolean);
    HRESULT (__stdcall *get_IsNextEnabled)(ISystemMediaTransportControls*, boolean*);
    HRESULT (__stdcall *put_IsNextEnabled)(ISystemMediaTransportControls*, boolean);
    HRESULT (__stdcall *get_IsChannelUpEnabled)(ISystemMediaTransportControls*, boolean*);
    HRESULT (__stdcall *put_IsChannelUpEnabled)(ISystemMediaTransportControls*, boolean);
    HRESULT (__stdcall *get_IsChannelDownEnabled)(ISystemMediaTransportControls*, boolean*);
    HRESULT (__stdcall *put_IsChannelDownEnabled)(ISystemMediaTransportControls*, boolean);
    HRESULT (__stdcall *add_ButtonPressed)(ISystemMediaTransportControls*, SystemMediaTransportControlsButtonPressedEventArgs*, EventRegistrationToken*);
    HRESULT (__stdcall *remove_ButtonPressed)(ISystemMediaTransportControls*, EventRegistrationToken*);
    HRESULT (__stdcall *add_PropertyChanged)(ISystemMediaTransportControls*, SystemMediaTransportControlsPropertyChangedEventArgs*, EventRegistrationToken*);
    HRESULT (__stdcall *remove_PropertyChanged)(ISystemMediaTransportControls*, EventRegistrationToken*);
} ISystemMediaTransportControlsVtbl;
struct ISystemMediaTransportControls { ISystemMediaTransportControlsVtbl* lpVtbl; };

HRESULT __stdcall WindowsCreateString(LPCWSTR sourceString, UINT32 length, HSTRING* string);
HRESULT __stdcall WindowsDeleteString(HSTRING string);
PCWSTR __stdcall WindowsGetStringRawBuffer(HSTRING string, UINT32* length);
size_t __cdecl mbstowcs(wchar_t* w, const char* s, size_t c);
size_t __cdecl wcstombs(char* s, const wchar_t* w, size_t c);
size_t __cdecl wcslen(const wchar_t* s);
HRESULT __stdcall RoGetActivationFactory(HSTRING activatableClassId, REFIID iid, void** factory);
HRESULT __stdcall RoInitialize(RO_INIT_TYPE initType);
void __stdcall RoUninitialize(void);
HWND __stdcall CreateWindowExA(DWORD dwExStyle, LPCSTR lpClassName, LPCSTR lpWindowName, DWORD dwStyle, int X, int Y, int nWidth, int nHeight, HWND hWndParent, HMENU hMenu, HINSTANCE hInstance, LPVOID lpParam);
HMODULE __stdcall GetModuleHandleA(LPCSTR lpModuleName);
]]

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

local media_control_statics_name = str2cwstr("Windows.Media.SystemMediaTransportControls")
local media_control_statics_name_hstring = ffi.new("HSTRING[1]")

local hr = winrt_core.RoInitialize(1)
logger:info(string.format("RoInitialize hr = 0x%08X", hr))
logger:info(string.format("hrtype = %s", type(hr)))

hr = winrt_string.WindowsCreateString(media_control_statics_name, 42, media_control_statics_name_hstring)
logger:info(string.format("WindowsCreateString hr = 0x%08X", hr))

local pFactory = ffi.new("void*[1]")
hr = combase.RoGetActivationFactory(media_control_statics_name_hstring[0], IID_IActivationFactory, pFactory)
local factory = ffi.cast("IActivationFactory*", pFactory[0])
logger:info(string.format("RoGetActivationFactory hr = 0x%08X", hr))

hr = winrt_string.WindowsDeleteString(media_control_statics_name_hstring[0])
logger:info(string.format("WindowsDeleteString hr = 0x%08X", hr))

local pSmtci = ffi.new("void*[1]")
hr = factory.lpVtbl.QueryInterface(factory, IID_ISystemMediaTransportControlsInterop, pSmtci)
local smtci = ffi.cast("ISystemMediaTransportControlsInterop*", pSmtci[0])
logger:info(string.format("IActivationFactory_QueryInterface hr = 0x%08X", hr))

local window = ffi.C.CreateWindowExA(0, "static", "MediaControllerWindow", 0, 0x80000000, 0x80000000, 800, 600, nil, nil, ffi.C.GetModuleHandleA(nil), nil)
local pSmtc = ffi.new("void*[1]")
hr = smtci.lpVtbl.GetForWindow(smtci, window, IID_ISystemMediaTransportControls, pSmtc)
local smtc = ffi.cast("ISystemMediaTransportControls*", pSmtc[0])
logger:info(string.format("ISystemMediaTransportControlsInterop_GetForWindow hr = 0x%08X", hr))

local pSmtc_display_updater = ffi.new("ISystemMediaTransportControlsDisplayUpdater*[1]")
hr = smtc.lpVtbl.get_DisplayUpdater(smtc, pSmtc_display_updater)
local smtc_display_updater = pSmtc_display_updater[0]
logger:info(string.format("ISystemMediaTransportControls_get_DisplayUpdater hr = 0x%08X", hr))

local pSmtc_music_properties = ffi.new("IMusicDisplayProperties*[1]")
hr = smtc_display_updater.lpVtbl.get_MusicProperties(smtc_display_updater, pSmtc_music_properties)
local smtc_music_properties = pSmtc_music_properties[0]
logger:info(string.format("ISystemMediaTransportControlsDisplayUpdater_get_MusicProperties hr = 0x%08X", hr))

local pSmtc_video_properties = ffi.new("IVideoisplayProperties*[1]")
hr = smtc_display_updater.lpVtbl.get_VideoProperties(smtc_display_updater, pSmtc_video_properties)
local smtc_video_properties = pSmtc_video_properties[0]
logger:info(string.format("ISystemMediaTransportControlsDisplayUpdater_get_VideoProperties hr = 0x%08X", hr))

local pSmtc_image_properties = ffi.new("IImageDisplayProperties*[1]")
hr = smtc_display_updater.lpVtbl.get_ImageProperties(smtc_display_updater, pSmtc_image_properties)
local smtc_image_properties = pSmtc_image_properties[0]
logger:info(string.format("ISystemMediaTransportControlsDisplayUpdater_get_ImageProperties hr = 0x%08X", hr))


winrt_core.RoUninitialize()

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

return SMTC