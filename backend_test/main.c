#include "main.h"

DEFINE_GUID(IID_ISystemMediaTransportControlsInterop, 0xddb0472d, 0xc911, 0x4a1f, 0x86,0xd9, 0xdc,0x3d,0x71,0xa9,0x5f,0x5a);
DEFINE_GUID(IID_ISystemMediaTransportControls, 0x99fa3ff4, 0x1742, 0x42a6, 0x90,0x2e, 0x08,0x7d,0x41,0xf9,0x65,0xec);
DEFINE_GUID(IID_IMusicDisplayProperties2, 0x00368462, 0x97d3, 0x44b9, 0xb0,0x0f, 0x00,0x8a,0xfc,0xef,0xaf,0x18);

int main(void) {
    RoInitialize(RO_INIT_MULTITHREADED);

    HSTRING media_control_statics_name_hstring;
    WindowsCreateString(L"Windows.Media.SystemMediaTransportControls", 42, &media_control_statics_name_hstring);

    IActivationFactory *factory;
    RoGetActivationFactory(media_control_statics_name_hstring, &IID_IActivationFactory, (void**)&factory);

    WindowsDeleteString(media_control_statics_name_hstring);

    ISystemMediaTransportControlsInterop *smtci;
    factory->lpVtbl->QueryInterface(factory, &IID_ISystemMediaTransportControlsInterop, (void**)&smtci);

    HWND window = CreateWindowExA(0, "static", "MediaControlWindow", 0, 0x80000000, 0x80000000, 800, 600, NULL, NULL, GetModuleHandleA(NULL), NULL);

    ISystemMediaTransportControls *smtc;
    smtci->lpVtbl->GetForWindow(smtci, window, &IID_ISystemMediaTransportControls, (void**)&smtc);

    ISystemMediaTransportControlsDisplayUpdater *smtc_display_updater;
    smtc->lpVtbl->get_DisplayUpdater(smtc, &smtc_display_updater);

    smtc->lpVtbl->put_IsPlayEnabled(smtc, TRUE);
    smtc->lpVtbl->put_IsStopEnabled(smtc, FALSE);
    smtc->lpVtbl->put_IsPauseEnabled(smtc, TRUE);
    smtc->lpVtbl->put_IsRecordEnabled(smtc, FALSE);
    smtc->lpVtbl->put_IsFastForwardEnabled(smtc, FALSE);
    smtc->lpVtbl->put_IsRewindEnabled(smtc, FALSE);
    smtc->lpVtbl->put_IsPreviousEnabled(smtc, TRUE);
    smtc->lpVtbl->put_IsNextEnabled(smtc, TRUE);
    smtc->lpVtbl->put_IsChannelUpEnabled(smtc, FALSE);
    smtc->lpVtbl->put_IsChannelDownEnabled(smtc, FALSE);
    smtc->lpVtbl->put_IsEnabled(smtc, TRUE);
    smtc_display_updater->lpVtbl->put_Type(smtc_display_updater, MediaPlaybackType_Music);
    smtc_display_updater->lpVtbl->Update(smtc_display_updater);



    IMusicDisplayProperties *music_display_properties;
    smtc_display_updater->lpVtbl->get_MusicProperties(smtc_display_updater, &music_display_properties);

    IMusicDisplayProperties2 *music_display_properties2;
    music_display_properties->lpVtbl->QueryInterface(music_display_properties, &IID_IMusicDisplayProperties2, (void**)&music_display_properties2);

    return 0;
}