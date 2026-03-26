import { Millennium, IconsModule, definePlugin, callable, MusicTrack } from '@steambrew/client';

// class classname {
// 	static method(country: string, age: number) {
// 		console.log(`age: ${age}, country: ${country}`);
// 		return 'method called';
// 	}
// }

// export classname class to global context
// Millennium.exposeObj({ classname });

class MusicController {
	static PlayNext() {
		SteamClient.Music.PlayNext();
	}

	static PlayPrevious() {
		SteamClient.Music.PlayPrevious();
	}

	static TogglePlayPause() {
		SteamClient.Music.TogglePlayPause();
		
	}
}
Millennium.exposeObj({MusicController});

// function windowCreated(context: any) {
// 	// window create event.
// 	// you can interact directly with the document and monitor it with dom observers
// 	// you can then render components in specific pages.
// 	console.log(context);
// }

// Declare a function that exists on the backend
// const backendMethod = callable<[{ message: string; status: boolean; count: number }], boolean>('test_frontend_message_callback');
const SMTC = {
	get_playback_status: callable<[], number>("SMTC.get_playback_status"),
	set_playback_status: callable<[{status: number}], boolean>("SMTC.set_playback_status"),
	get_is_enabled: callable<[], boolean>("SMTC.get_is_enabled"),
	set_is_enabled: callable<[{value: boolean}], boolean>("SMTC.set_is_enabled"),
	get_media_type: callable<[], number>("SMTC.get_media_type"),
	set_media_type: callable<[{type: number}], boolean>("SMTC.set_media_type"),
	update_display_properties: callable<[], boolean>("SMTC.update_display_properties"),
	get_title: callable<[], string>("SMTC.get_title"),
	set_title: callable<[{title: string}], boolean>("SMTC.set_title"),
	get_album_title: callable<[], string>("SMTC.get_album_title"),
	set_album_title: callable<[{title: string}], boolean>("SMTC.set_album_title"),
	get_album_artist: callable<[], string>("SMTC.get_album_artist"),
	set_album_artist: callable<[{artist: string}], boolean>("SMTC.set_album_artist"),
	get_artist: callable<[], string>("SMTC.get_artist"),
	set_artist: callable<[{artist: string}], boolean>("SMTC.set_artist"),
	get_track_number: callable<[], string>("SMTC.get_track_number"),
	set_track_number: callable<[{number: number}], boolean>("SMTC.set_track_number")
};
const setup_smtc = callable<[], void>("setup_smtc");

// const SettingsContent = () => {
// 	return (
// 		<Field label="Plugin Settings" description="This is a description of the plugin settings." icon={<IconsModule.Settings />} bottomSeparator="standard" focusable>
// 			<DialogButton
// 				onClick={() => {
// 					console.log('Button clicked!');
// 				}}
// 			>
// 				Click Me
// 			</DialogButton>
// 		</Field>
// 	);
// };

let firstMusicPlayed = false;

async function MusicPlaybackChange(param0: boolean | MusicTrack) {
	if (param0 === false)
		return;

	if (firstMusicPlayed === false) {
		await setup_smtc();
		firstMusicPlayed = true;
	}

	const status: MusicTrack = param0 as MusicTrack;

	
	console.log(param0)
}

function MusicPositionChange(position: number) {
	console.log(position)
}

export default definePlugin(() => {
	// Call the backend method
	// backendMethod({
	// 	message: 'Hello World From Frontend!',
	// 	status: true,
	// 	count: 69,
	// }).then((message: any) => {
	// 	console.log('Result from backendMethod:', message);
	// });

	const playbackChangeCallback = SteamClient.Music.RegisterForMusicPlaybackChanges(MusicPlaybackChange);
	const positionChangeCallback = SteamClient.Music.RegisterForMusicPlaybackPosition(MusicPositionChange);

	// Millennium.AddWindowCreateHook(windowCreated);

	return {
		title: 'My Plugin',
		icon: <IconsModule.Settings />,
		// content: <SettingsContent />,
		onDismount: () => {
			playbackChangeCallback.unregister();
			positionChangeCallback.unregister();
		}
	};
});
