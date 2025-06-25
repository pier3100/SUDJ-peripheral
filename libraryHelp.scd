(
~reload = true;
~musicLibrary = MusicLibrary.loadFromTraktor(Library.at(\musicLibraryPath), Library.at(\musicLibraryCustomPartPath), Library.at(\traktorLibraryPath), forceLoad: ~reload); // reusing existing library is broken; but it is also redundant is reloading from scratch is considerably faster
if(~reload){
	Smartlist.new("All", { true }, "7375646A7375646A416C6C7375646A7375646A").addToLibrary;
	Smartlist.new("History", { false }, "f0f86c15c3a940e9a3c93b4a66d3f37d").addToLibrary;
	Smartlist.new("Session", { false }, "1e0f57a1b3d24d0cbd5e6ffb5e37359f").addToLibrary;
	~musicLibrary.barcodeDictionary_;
};
)