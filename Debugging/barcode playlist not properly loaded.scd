// we get: "Meta_HidValRaw: playlist Stingray loaded to libraryConsole by barcode", however when scrolling through the tracks in the list are E-Snare, E-Kick
// finding: the filtering was not implemented correctly
~libraryConsole.loadPlaylist(~musicLibrary.playlists[1])
~musicLibrary.tracks
~musicLibrary = MusicLibrary.loadFromTraktor(Library.at(\musicLibraryPath), Library.at(\traktorLibraryPath), true);

(
~barcodeScanner = HID.open(3118, 2823, "\\\\?\\hid#vid_0c2e&pid_0b07&mi_00#8&12aced56&0&0000#{4d1e55b2-f16f-11cf-88cb-001111000030}");
~barcodeSource = HidSource(4,~barcodeScanner);
HidValRaw(~barcodeSource, {|valRaw|
    var valRawString, playlist;
    valRawString = valRaw.asString;
    // we check whether the barcode refers to a playlist (meaning the first digit is 1)
    if(valRawString[0].digit == 1){
        playlist = ~musicLibrary.barcodeDictionary.at(valRawString.copyRange(1, 10).asSymbol);
        ~libraryConsole.loadPlaylist(playlist);
        "playlist % loaded to libraryConsole by barcode".format(playlist.name).log(HidValRaw);
    }
});
)