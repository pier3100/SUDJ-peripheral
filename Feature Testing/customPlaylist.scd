"sudj".asHexAscii
"sudj".asHexString
~musicLibrary.playlists.at("$ROOT".asSymbol, "E1".asSymbol);
[] ++ [0,3]
[].class
[1,2,3,2].asSet.asArray
~musicLibrary.playlists.put("$ROOT".asSymbol,"hoi")
~musicLibrary.playlists.put("$ROOT".asSymbol,"doei")
~musicLibrary.playlists.postTree

Library.addFromJSON("C:\\Users\\piert\\MakingMusic\\SuperCollider\\SUDJ-execute\\config.JSON");
~musicLibrary = MusicLibrary.loadFromTraktor(Library.at(\musicLibraryPath), Library.at(\traktorLibraryPath), true);
Array.series(100,0,1)

// load configuration
Library.addFromJSON("C:\\Users\\piert\\MakingMusic\\SuperCollider\\SUDJ-execute\\config.JSON");



// music library
~musicLibrary = MusicLibrary.loadFromTraktor(Library.at(\musicLibraryPath), Library.at(\traktorLibraryPath), true);
~musicLibrary.addPseudoPlaylist("E1", ~musicLibrary.playlists.at("$ROOT".asSymbol, "E1".asSymbol));
~musicLibrary.addPseudoPlaylist("E2", ~musicLibrary.playlists.at("$ROOT".asSymbol, "E2".asSymbol));
~musicLibrary.addPseudoPlaylist("E3", ~musicLibrary.playlists.at("$ROOT".asSymbol, "E3".asSymbol));
~musicLibrary.addPseudoPlaylist("E4", ~musicLibrary.playlists.at("$ROOT".asSymbol, "E4".asSymbol));
~musicLibrary.addPseudoPlaylist("E5", ~musicLibrary.playlists.at("$ROOT".asSymbol, "E5".asSymbol));
~musicLibrary.playlists.put("$ROOT".asSymbol, \custom, \all, Playlist.new("all", Array.series(~musicLibrary.tracks.size, 0, 1)));

~musicLibrary.playlists.at("$ROOT".asSymbol, \Custom, \All).tracksIndex.size
~musicLibrary.playlists.at("$ROOT".asSymbol, \Custom, \E1).barcodeId.asString.barcodeId2EAN13(1)

~musicLibrary.barcodeDictionary.at(\212249645);
~musicLibrary.barcodeDictionary.at(\247813578);

~musicLibrary.tracks.size