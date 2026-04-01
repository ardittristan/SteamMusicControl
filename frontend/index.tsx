import { Millennium, IconsModule, definePlugin, callable, MusicTrack, EAudioPlayback, Field, TextField, SteamAppOverview } from '@steambrew/client';
import anyAscii from "any-ascii"

const localStorageKey = "ardittristan.SteamMusicControl.config";

let pluginConfig = {
	buttonPollInterval: 50
}

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

const lua_event_loop = callable<[], void>("SMTC_event_loop");
const setup_smtc = callable<[], void>("SMTC_setup");
const set_playback_status = callable<[{status: SmtcPlaybackStatusEnum}], void>("SMTC_set_playback_status");
const set_display = callable<[{album_artist: string; album_title: string; song_artist: string; song_title: string; track_number: string}], void>("SMTC_set_display");

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

const SettingsContent = () => {
	const saveConfig = () => {
		localStorage.setItem(localStorageKey, JSON.stringify(pluginConfig))
	}

	return (
		<Field label="Button poll interval" description="How often (in ms) to check for play/next/previous button presses" icon={<IconsModule.Settings />} bottomSeparator="standard" focusable>
			<TextField
				defaultValue={pluginConfig.buttonPollInterval}
				mustBeNumeric={true}
				onChange={(e: React.ChangeEvent<HTMLInputElement>) =>  {
					let value = parseInt(e.currentTarget.value);
					if (1 > value)
						value = 50;
					pluginConfig.buttonPollInterval = value;
					saveConfig();
				}}
			/>
		</Field>
	);
};

let firstMusicPlayed = false;
let lastAlbumAppId = 0;
let lastTrackNum = -1;

async function MusicPlaybackChange(param0: boolean | MusicTrack) {
	if (param0 === false)
		return;

	if (firstMusicPlayed === false) {
		await setup_smtc();
		firstMusicPlayed = true;
	}

	const status: MusicTrack = param0 as MusicTrack;
	const albumAppId = status.uSoundtrackAppId;
	const trackNum = status.nActiveTrack;
	const playbackStatus = status.ePlaybackStatus;
	const albumTracksInfo = await SteamClient.Apps.GetSoundtrackDetails(albumAppId)
	const albumStoreInfo = ((window.appStore as any).allApps as SteamAppOverview[]).find(x => x.appid === albumAppId)
	const trackInfo = albumTracksInfo.tracks[trackNum]

	await set_playback_status({status: SteamToSmtcPlaybackStatus(playbackStatus)})

	if (lastAlbumAppId === albumAppId && lastTrackNum === trackNum)
		return;

	lastAlbumAppId = albumAppId;
	lastTrackNum = trackNum;

	await set_display({
		album_artist: anyAscii(albumTracksInfo.metadata.artist ?? ""),
		album_title: anyAscii(albumStoreInfo.display_name ?? ""),
		song_artist: anyAscii(albumTracksInfo.metadata.artist ?? ""),
		song_title: anyAscii(trackInfo.trackDisplayName ?? ""),
		track_number: trackNum.toString()
	})
}

export default definePlugin(() => {
	const storedConfig = JSON.parse(localStorage.getItem(localStorageKey))
	pluginConfig = { ...pluginConfig, ...storedConfig };

	const playbackChangeCallback = SteamClient.Music.RegisterForMusicPlaybackChanges(MusicPlaybackChange);
	const event_loop = setInterval(function() {if (firstMusicPlayed) lua_event_loop();}, pluginConfig.buttonPollInterval);

	return {
		title: 'SteamMusicControl',
		icon: <IconsModule.Settings />,
		content: <SettingsContent />,
		onDismount: () => {
			clearInterval(event_loop);
			firstMusicPlayed = false;
			lastAlbumAppId = 0;
			lastTrackNum = -1;
			playbackChangeCallback.unregister();
		}
	};
});
