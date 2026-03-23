local logger = require("logger")
local ffi = require("ffi")
local combase = ffi.load("combase")
local winrt_string = ffi.load("api-ms-win-core-winrt-string-l1-1-0.dll")
local msvcrt = ffi.load('msvcrt.dll')

ffi.cdef[[
typedef struct {
    uint32_t Data1;
    uint16_t Data2;
    uint16_t Data3;
    uint8_t Data4[8];
} GUID;

typedef struct HSTRING__ {
    int unused;
} HSTRING__;
typedef HSTRING__* HSTRING;

typedef enum TrustLevel {
    BaseTrust = 0,
    PartialTrust = 1,
    FullTrust = 2
} TrustLevel;

typedef GUID IID;
typedef void* HWND;
typedef const void* REFIID;
typedef long HRESULT;
typedef unsigned long ULONG;
typedef unsigned int UINT32;
typedef const wchar_t* LPCWSTR;

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

HRESULT __stdcall WindowsCreateString(LPCWSTR sourceString, UINT32 length, HSTRING *string);
unsigned int mbstowcs(wchar_t* w, const char* s, unsigned int c);
]]

local function str2wstr(s)
    local szbuf = s:len()
    local buf = ffi.new('wchar_t[?]', szbuf+1)
    if msvcrt.mbstowcs(buf, s, szbuf) == -1 then
        return nil
    end
    return buf
end

local IID_ISystemMediaTransportControlsInterop = ffi.new("IID", {
    Data1 = 0xddb0472d,
    Data2 = 0xc911,
    Data3 = 0x4a1f,
    Data4 = {0x86,0xd9, 0xdc,0x3d,0x71,0xa9,0x5f,0x5a}
})

local media_control_statics_name = ffi.cast('const wchar_t*', str2wstr('Windows.Media.SystemMediaTransportControls'))
local media_control_statics_name_hstring = ffi.new("HSTRING*");

-- media_control_statics_name is null, aaaaah
local hr = winrt_string.WindowsCreateString(media_control_statics_name, 42, media_control_statics_name_hstring);
logger:info(string.format("WindowsCreateString hr = 0x%08X", hr))
