~musicLibrary.playlists.postTree;

// testing custom UUIDS
~musicLibrary.playlists.at("$ROOT".asSymbol)
~newUUIDs = ["1e0f57a1b3d24d0cbd5e6ffb5e37359f", "3e4fdbaedb7a4087bbd6a67c276a1b89", "d1b663b69d374d91b7a59a7bce27413b", "33d1c4e9c937404086768998f384e44f", "0ceffb32db8048b4b51f8301b70f296e", "fc4cb05b5da442e983019388a2b8e3c5", "7eb4c269c3644c0ba1bfe2a62a57db9f", "4173cbf5574f4b92827a2d51e7b7d6ed", "1e256130a8ff43c8844a8d3d56f37a71", "dcbe7e16fbc54a88b6a29339bfcaf0d9", "5e180153c08445f7bff4f81c157f3de7", "a3a0df06dbd54069ae2380045b5eb6d4", "f0f86c15c3a940e9a3c93b4a66d3f37d", "e0f01e9a67c04b54a9fc40442909a126", "e2178794fa8b43b2a14c0709b4aa4b46", "f3fc5d2e0f4e47018f8c79c3be85f9aa", "a559f9023a024249a498249407013a32", "84ad0adfb49f4185a77a81697a3ea12d", "90a8367b0d164a57806b171ed05f2da8", "23963e325e4147d2bd8cfce8323d2e88"];~musicLibrary.playlists.leafDo({|path, item| if(~newUUIDs.includes(item.uuId)){item.name.postln}});

// generating pseudo playlists
~musicLibrary.addPseudoPlaylist("E1", ~musicLibrary.playlists.at("$ROOT".asSymbol, "E1".asSymbol));
~musicLibrary.addPseudoPlaylist("E2", ~musicLibrary.playlists.at("$ROOT".asSymbol, "E2".asSymbol));
~musicLibrary.addPseudoPlaylist("E3", ~musicLibrary.playlists.at("$ROOT".asSymbol, "E3".asSymbol));
~musicLibrary.addPseudoPlaylist("E4", ~musicLibrary.playlists.at("$ROOT".asSymbol, "E4".asSymbol));
~musicLibrary.addPseudoPlaylist("E5", ~musicLibrary.playlists.at("$ROOT".asSymbol, "E5".asSymbol));
~musicLibrary.playlists.put("$ROOT".asSymbol, \Special, \All, Playlist.new("All", Array.series(~musicLibrary.tracks.size, 0, 1)));

// generate special playlist new way
PseudoPlaylist.new("E1", ["$ROOT".asSymbol, \E1]).addToLibrary;
PseudoPlaylist.new("E2", ["$ROOT".asSymbol, \E2]).addToLibrary;
PseudoPlaylist.new("E3", ["$ROOT".asSymbol, \E3]).addToLibrary;
PseudoPlaylist.new("E4", ["$ROOT".asSymbol, \E4]).addToLibrary;
PseudoPlaylist.new("E5", ["$ROOT".asSymbol, \E5]).addToLibrary;
Smartlist.new("All", { true }, "7375646A7375646A416C6C7375646A7375646A").addToLibrary;
Smartlist.new("Session", { false }, "1e0f57a1b3d24d0cbd5e6ffb5e37359f").addToLibrary;

// generate custom playlist


// accessing a playlist
~musicLibrary.playlists.at("$ROOT".asSymbol, \Special, \None).name;
~musicLibrary.playlists.at(*['$ROOT', 'E2', 'Break n Bounce Mellow and easy']).trackKeyArray.size;

// compare UUID
~musicLibrary.playlists.at("$ROOT".asSymbol, \Special, \E1).uuId == ~musicLibrary.playlists.at("$ROOT".asSymbol, \Custom, \E1).uuId;
~musicLibrary.playlists.at("$ROOT".asSymbol, \Custom, \All).uuId

// storing library
~musicLibrary.store(Library.at(\musicLibraryPath)); // happens automatically when closing the server

// delete a playlist
~musicLibrary.playlists.removeAt(*['$ROOT', 'Special', 'None']);

// find a playlist
~musicLibrary.findPlaylistByTitle("Jungle");
~musicLibrary.findPlaylistByTitle("None");
~musicLibrary.findPlaylistByTitle("Mellow and easy");

// rename a playlist
~musicLibrary.renamePlaylist(['$ROOT', 'Special', 'None'], "doei")

// hash test
a = 3;
b = 5;
c = [a, b];
a.hash
c.atIdentityHash(1661238)

// working with Dictionary
q = Dictionary.new;
q.put(\hoi, 5);
q.put(\doei, 3);
q.selectKeys({|item| item == 3})

d = Dictionary[\a -> "hello", \b -> "robot", \c -> [1, 2, 3]];
d.at(\oo)
d.do { |item, i| [item, i].postln };
d = Dictionary[\a -> 5, \b -> 7, \c -> 1, \d -> 0];
d.asSortedArray;

// testing new dictionary structure of tracks
~musicLibrary.tracks
~testId = "AL01VHNVR6lldnZ3vWZYdmetlldnd3vWZYdmaclldnd4vXZYdmaclldod3vXZYd2acp1d3d3vXZYd3adp2d3d2vXZYd3acp2d3Z2vXZYdmeEdlZVZknFVHRmR6l1ZWd1nGZIVmacp1dnd2vXZIV2etp2d3d2vXZYZ2acp1d3d2vXdpZ2acplZmZmrXZXV3acp2ZndmrXZXZ2acplZ3Z3vXZXd2acplZmZmvYdYd3esp2Z3d3vXdYd3acp2eHd3vYdod3act2Z3d3rXdpd2acpmZlZkjGZHRmSKp2Z3Z3vYdZZ3ast2Z3Z2rXZUdGZUiJEREREBAAAAAAAAAAAAAAAA==";
~musicLibrary.tracks.at(~testId.asSymbol).path.asSymbol;
~musicLibrary.tracks.select({|item| item.usable}).size;

a = Routine.new({ 1.yield; 2.yield; });
a.next.postln;
t = r.next;
t.usable

//
~musicLibrary.findPlaylistByTitle("E1");
q = ~musicLibrary.playlists.at(*['$ROOT', 'Special', 'E1']).asTrackArray
"C:\Users\piert\Music\ZSpotify Music\Maybe Set1\Tim Reaper - Hardcore & Rubble - Agony Tonight.mp3"

~musicLibrary.tracks.at("E1")
~musicLibrary.tracks.keysDo({|key| if(key.asString.find("Agony Tonight").isNil.not){key.postln}});
~musicLibrary.barcodeDictionary.at("530616793".asSymbol);
~musicLibrary.barcodeDictionary.at("512420248".asSymbol);
~musicLibrary.barcodeDictionary