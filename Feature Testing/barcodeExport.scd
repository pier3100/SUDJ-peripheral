~musicLibrary.exportBarcodes("C:\\Users\\piert\\MakingMusic\\SuperCollider\\SUDJ-data\\playlistBarcodes.csv", ["E1", "E2", "E3", "E4", "E5", "Elements", "Set Parts", "Ma Tracks", "Custom"]);
(
var string;
var folderNames;
var i = 0;
folderNames = ["E1", "E2", "E3", "E4", "E5", "Elements", "Set Parts", "Ma Tracks", "Custom"];
~musicLibrary.playlists.at("$ROOT".asSymbol,folderNames[i].asSymbol).do({ |playlist|
    playlist.class.postln;
	// string = playlist.barcodeId.asString.barcodeId2EAN13(1) ++ "; " ++ folderNames[i].asString ++ ":: " ++ playlist.name ++ "; \n"; // we need to convert the barcode ID to an actual barcode
            });
)
~musicLibrary.playlists.postTree