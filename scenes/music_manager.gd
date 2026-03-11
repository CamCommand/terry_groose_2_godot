extends Node

# Music list and playback index
var music_list = []
var current_index = 0
var music_player: AudioStreamPlayer

# Call this once at game start
func init(player: AudioStreamPlayer):
	music_player = player
	create_music_folder()
	load_custom_music()
	shuffle_playlist()
	connect_signal()
	play_next_song()

# Ensure folder exists
func create_music_folder():
	var dir = DirAccess.open("user://")
	if not dir.dir_exists("music"):
		dir.make_dir("music")

# Load all songs
func load_custom_music():
	var path = "user://music"
	var dir = DirAccess.open(path)
	if not dir:
		print("Could not open music folder")
		return

	dir.list_dir_begin()
	var file = dir.get_next()
	while file != "":
		if not dir.current_is_dir():
			var full_path = path + "/" + file
			var stream = null

			if file.ends_with(".ogg"):
				stream = AudioStreamOggVorbis.load_from_file(full_path)
			elif file.ends_with(".mp3"):
				stream = AudioStreamMP3.load_from_file(full_path)
			elif file.ends_with(".wav"):
				stream = AudioStreamWAV.load_from_file(full_path)

			if stream:
				music_list.append(stream)
				print("Loaded:", file)

		file = dir.get_next()

	print("Total songs loaded:", music_list.size())

# Shuffle the playlist
func shuffle_playlist():
	music_list.shuffle()
	current_index = 0

# Connect finished signal
func connect_signal():
	if not music_player.is_connected("finished", Callable(self, "_on_music_finished")):
		music_player.finished.connect(Callable(self, "_on_music_finished"))

# Play next song
func play_next_song():
	if music_list.is_empty():
		print("No songs to play")
		return

	if current_index >= music_list.size():
		shuffle_playlist()

	music_player.stream = music_list[current_index]
	music_player.play()
	current_index += 1

# Signal when song finishes
func _on_music_finished():
	play_next_song()

# Reload folder (called from PauseMenu)
func reload_music():
	music_list.clear()
	load_custom_music()
	shuffle_playlist()
	current_index = 0
	play_next_song()

# Skip to next song
func skip_song():
	play_next_song()
