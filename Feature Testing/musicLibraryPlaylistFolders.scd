m = MultiLevelIdentityDictionary.new;
m.put(\hoi,5)
m.put(\hoi2,\doei,6)
m.put(\poo,3)
t = "sfubaogbhoisuiyvescseovy"
w = t.findInBetween("ho","ui",10-2)
w.string
w.endIndex
w.startIndex
m
m.put(\hoi2,\drie,\vier,5)
m.put(\drie,\acht,8)
m.postTree
m.at(\hoi2,\drie).put(\joe,IdentityDictionary.new)

m.put(\root,IdentityDictionary.new)
m.at(\hoi2).class
5!=4

Library.addFromJSON("C:\\Users\\piert\\MakingMusic\\SuperCollider\\SUDJ-execute\\config.JSON");
~musicLibrary = MusicLibrary.loadFromTraktor(Library.at(\musicLibraryPath), Library.at(\traktorLibraryPath), true);
~musicLibrary.playlists.postTree
~musicLibrary.barcodeDictionary
~musicLibrary.tracks
(
for(0,4){|i|
	i.postln;
})

~musicLibrary.playlists.at("\$ROOT".asSymbol, "00 old".asSymbol, "00 160 main".asSymbol, "00 160 old".asSymbol)
~musicLibrary.playlists.at(\NoKicks)
~musicLibrary.playlists.asList.postln
"\$Root".asSymbol
m.dictionary
m.postTree
m.at(.do({|item| item.postln})
m.leafDo({|item, val| item.postln; val.postln})


	~libraryConsole.loadPlaylist(~musicLibrary.playlists.at("$ROOT".asSymbol, \E3, \Jungle))
~prelistenDeck.loadTrack(~libraryConsole.activePlaylist.asArray[1])
~libraryConsole.nextTrack_
	~libraryConsole.activeTrackArrayFiltered;
	~libraryConsole.count