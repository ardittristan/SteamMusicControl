import { Millennium, IconsModule, definePlugin, callable, MusicTrack, EAudioPlayback } from '@steambrew/client';

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

declare enum SmtcPlaybackStatusEnum {
	Closed = 0,
	Changing = 1,
	Stopped = 2,
	Playing = 3,
	Paused = 4
}

const SmtcPlaybackStatus = {
	Closed: 0,
	Changing: 1,
	Stopped: 2,
	Playing: 3,
	Paused: 4
}

const setup_smtc = callable<[], void>("setup_smtc");
const set_playback_status = callable<[{status: SmtcPlaybackStatusEnum}], void>("SMTC_set_playback_status");
const set_display = callable<[{title: string, artist: string, album_title: string | undefined, album_artist: string | undefined, track_number: string | undefined}], void>("SMTC_set_display");

function SteamToSmtcPlaybackStatus(status: EAudioPlayback) {
	switch (status) {
		case EAudioPlayback.Playing:
			return SmtcPlaybackStatus.Playing;
		case EAudioPlayback.Paused:
			return SmtcPlaybackStatus.Paused;
		case EAudioPlayback.Idle:
			return SmtcPlaybackStatus.Stopped;
		case EAudioPlayback.Undefined:
		default:
			return SmtcPlaybackStatus.Closed;
	}
}

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
	const albumId = status.uSoundtrackAppId;
	const trackNum = status.nActiveTrack;
	const playbackStatus = status.ePlaybackStatus;

	await set_playback_status({status: SteamToSmtcPlaybackStatus(playbackStatus)})

	// TODO: these crash for now \/

	await set_display({
		title: "Track " + trackNum.toString(),
		artist: "test2",
		album_title: "test",
		album_artist: "test",
		track_number: "2"
	})

	// await SMTC.update_display_properties()

	console.log(param0)
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

	// Millennium.AddWindowCreateHook(windowCreated);

	return {
		title: 'My Plugin',
		icon: <IconsModule.Settings />,
		// content: <SettingsContent />,
		onDismount: () => {
			firstMusicPlayed = false;
			playbackChangeCallback.unregister();
		}
	};
});
