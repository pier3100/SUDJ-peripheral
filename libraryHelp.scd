(
~reload = true;
~musicLibrary = MusicLibrary.loadFromTraktor(Library.at(\musicLibraryPath), Library.at(\musicLibraryCustomPartPath), Library.at(\traktorLibraryPath), forceLoad: ~reload); // reusing existing library is broken; but it is also redundant is reloading from scratch is considerably faster
if(~reload){
	PseudoPlaylist.new("E1", ["$ROOT".asSymbol, \E1]).addToLibrary;
	PseudoPlaylist.new("E2", ["$ROOT".asSymbol, \E2]).addToLibrary;
	PseudoPlaylist.new("E3", ["$ROOT".asSymbol, \E3]).addToLibrary;
	PseudoPlaylist.new("E4", ["$ROOT".asSymbol, \E4]).addToLibrary;
	PseudoPlaylist.new("E5", ["$ROOT".asSymbol, \E5]).addToLibrary;
	Smartlist.new("All", { true }, "7375646A7375646A416C6C7375646A7375646A").addToLibrary;
	Smartlist.new("Session", { false }, "1e0f57a1b3d24d0cbd5e6ffb5e37359f").addToLibrary;
	~musicLibrary.barcodeDictionary_;
};
)