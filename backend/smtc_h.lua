local ffi = require("ffi")

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
typedef int BOOL;
typedef unsigned long ULONG;
typedef unsigned int UINT32;
typedef signed long long INT64;
typedef const wchar_t* PCWSTR;
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

typedef struct IMusicDisplayProperties2 IMusicDisplayProperties2;
typedef struct IMusicDisplayProperties2Vtbl {
    HRESULT (__stdcall *QueryInterface)(IMusicDisplayProperties2*, REFIID, void**);
    ULONG (__stdcall *AddRef)(IMusicDisplayProperties2*);
    ULONG (__stdcall *Release)(IMusicDisplayProperties2*);
    HRESULT (__stdcall *GetIids)(IMusicDisplayProperties2*, ULONG*, IID**);
    HRESULT (__stdcall *GetRuntimeClassName)(IMusicDisplayProperties2*, HSTRING*);
    HRESULT (__stdcall *GetTrustLevel)(IMusicDisplayProperties2*, TrustLevel*);
    HRESULT (__stdcall *get_AlbumTitle)(IMusicDisplayProperties2*, HSTRING*);
    HRESULT (__stdcall *put_AlbumTitle)(IMusicDisplayProperties2*, HSTRING);
    HRESULT (__stdcall *get_TrackNumber)(IMusicDisplayProperties2*, HSTRING*);
    HRESULT (__stdcall *put_TrackNumber)(IMusicDisplayProperties2*, HSTRING);
    HRESULT (__stdcall *get_Genres)(IMusicDisplayProperties2*, /* Vector<HSTRING> */ void**);
} IMusicDisplayProperties2Vtbl;
struct IMusicDisplayProperties2 { IMusicDisplayProperties2Vtbl* lpVtbl; };

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
    HRESULT (__stdcall *get_VideoProperties)(ISystemMediaTransportControlsDisplayUpdater*, /* IVideoDisplayProperties */ void**);
    HRESULT (__stdcall *get_ImageProperties)(ISystemMediaTransportControlsDisplayUpdater*, /* IImageDisplayProperties */ void**);
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
BOOL __stdcall DestroyWindow(HWND hWnd);
HMODULE __stdcall GetModuleHandleA(LPCSTR lpModuleName);
]]