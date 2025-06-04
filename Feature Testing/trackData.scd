~track = ~prelistenDeck.track;

~results = ~musicLibrary.findTrackByTitle("QTE");
~track = ~results.asArray[0];
~track.path

~cmd = "ffprobe \"" ++ ~track.path + "\"";
~cmd = "ffprobe -v quiet -print_format json -show_entries stream_tags \"" ++ ~track.path + "\"";
~cmd = "ffprobe -v quiet -print_format json -show_entries stream_tags \"C:\\Users\\piert\\Music\\ZSpotify Music\\Maybe Set1\\Simon Popp - 7O4.ogg\""
~cmd
~metaData = ~cmd.unixCmdGetStdOut.parseJSON.at("streams")[0].at("tags").invert.keysValuesChange({|key, value| value.asSymbol}).invert;
~metaData.post

~cmd.unixCmd
~metaData = ~cmd.unixCmdGetStdOut;
~metaData

// we need to check how fast we can read this for many files, we need to see if we can read the energy level from the comment tag, we need to see if the energy level makes any sense
(
~track = ~prelistenDeck.track;
~cmd = "ffprobe -v quiet -print_format json -show_entries stream_tags \"" ++ ~track.path + "\"";
~cmd.unixCmd;
)

// get energy for .ogg
~results = ~musicLibrary.findTrackByTitle("QTE");
~track = ~results.asArray[0];
~cmd = "ffprobe -v quiet -print_format json -show_entries stream_tags=ORGANIZATION \"" ++ ~track.path + "\"";
~energy = ~cmd.unixCmdGetStdOut.findInBetween("ORGANIZATION\": \"", "\"").string

// get energy for .mp3
~results = ~musicLibrary.findTrackByTitle("Finally Happy");
~track = ~results.asArray[0];
~cmd = "ffprobe -v quiet -print_format json -show_entries format_tags=publisher \"" ++ ~track.path + "\"";
~energy = ~cmd.unixCmdGetStdOut.findInBetween("publisher\": \"", "\"").string

// combined
(
f = { |track|
	var command, energy;
	if(track.path.extension == "ogg"){
		command = "ffprobe -v quiet -print_format json -show_entries stream_tags=ORGANIZATION \"" ++ track.path + "\"";
		energy = command.unixCmdGetStdOut.findInBetween("ORGANIZATION\": \"", "\"").string;
	};
	if(track.path.extension == "mp3"){
		command = "ffprobe -v quiet -print_format json -show_entries format_tags=publisher \"" ++ track.path + "\"";
		energy = command.unixCmdGetStdOut.findInBetween("publisher\": \"", "\"").string;
	};
	energy.postln;
};
)
~energy = f.value(~track);

~track.energyFromMetaData;
~track.energy == "E1"

//
~path = "C:\\Users\\piert\\MakingMusic\\SuperCollider\\SUDJ-data\\test.txt";
~string = File.readAllString(~path);
~track = TrackDescription.newFromTraktor(~string);
~track


audio = ID3("C:/Users/piert/Music\ZSpotify Music/Maybe Set1\Abyss - Illusions - Finally Happy.mp3")
audio.getall("TPUB")
https://id3.org/id3v2.4.0-frames
https://mutagen.readthedocs.io/en/latest/user/id3.html

// fix loading from archive
// implement python script for reading all metadata and storing it in a big YAML file
// make a powerpoint in this topic