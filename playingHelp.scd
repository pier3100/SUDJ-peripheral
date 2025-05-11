c.tempo * 60;

// playback
~deck1.loadDouble(~prelistenDeck);
~deck1.pitchbend_(10);
~deck1.track.postInfo
~deck1.playPause;
~deck1.align
~deck1.synth.trace
~deck1.playPause_(true);
~deck1.playPause_(false);
~deck1.playPause
~deck1.track.postInfo;
~deck1.track.duration;
~deck1.clock.tempo *60;
~deck1.clock.sync
~deck1.relativePosition;
~deck1.loop;
~deck1.loopSize;
~deck1.track.gridOffset
~deck3.track.postInfo;
~deck3.clock.tempo *60;
~deck3.clock.sync
~deck3.playPause;
~deck3.clock.bus.getSynchronous;
~deck3.synth.trace
~deck3.align;
~deck3.pauseBus.getSynchronous
~deck3.position2beat(0)
~deck3.referenceBus.getnSynchronous(3)
(
var d1,d2,d3;
# d1, d2, d3 = ~deck3.referenceBus.getnSynchronous(3);
~deck3.position2beat(d3).postln;
~deck3.clock.beats.postln;
" ".postln;
~deck3.jumpTask.schedAtTime.postln;
~deck3.beatJumpBeats.postln;

)
~deck3.jumpAtBeat
~deck3.scratchEventNumber
~deck3.referenceBus.getSynchronous
~deck3.positionSetBus.getSynchronous
~deck3.beat2position(0);

~deck3.synth.trace

~deck3.track.userInducedGridOffset
(
~deck3.quePoint.postln;
~deck3.jumpTask.cancel.postln;
~deck3.clock.beats.postln;
~deck3.clock.tempo.postln;
~deck3.clock.beatOfTurning.postln;

)
~deck3.clock.beats_(0);
~deck3.beatJumpBeats
~deck3.endOfTrackEvent;
~deck3.clock.beats
~deck3.time2beat(~deck3.track.duration)

~sChannel1.trace
s.options.numOutputBusChannels

~deck3.clock.seconds
~deck3.clock.beats

~deck3.track.postInfo;
~deck3.info;
~deck3.clock.tempo
// settings
~sOutputs.setControlVal(\headPhoneGainDb, -25);
~sOutputs.setControlVal(\masterVolume, 0);

// libraryConsole
~prelistenDeck.track.postInfo;
~prelistenDeck.info;

~prelistenDeck.clock.beats_(0)

~prelistenDeck.loadTrackFromBuffer(~libraryConsole.activeTrackArrayFiltered[2], ~libraryConsole.bufferArray[2]);
~libraryConsole.referenceTrack.postInfo;
~libraryConsole.activeTrackArrayFiltered.do({ |track| track.postInfo })
~libraryConsole.nextTrack_;
(
~libraryConsole.nextTrack_(false);
~prelistenDeck.playPause_(true);
)
~prelistenDeck.playPause_(true);
~prelistenDeck.playPause_(false);
~prelistenDeck.playPause;
~prelistenDeck.trackBufferReady
~musicLibrary.playlists.at("$ROOT".asSymbol,\E4)
~libraryConsole.keyFilter_(4);
~libraryConsole.tempoFilter_(5);
~libraryConsole.loadPlaylist(~musicLibrary.playlists.at("$ROOT".asSymbol,\E3,"Jungle".asSymbol));
~libraryConsole.activeTrackArrayFiltered.size
~libraryConsole.activeTrackArrayFiltered[0].loadBuffer
~libraryConsole.activePlaylist.asArray.removeNotUsable.size
~libraryConsole.minorMajorFilterCoefficient
~libraryConsole.activePlaylist
~libraryConsole.loadPlaylist(~musicLibrary.playlists.at("$ROOT".asSymbol, \Special, \All));
~musicLibrary.playlists.at("$ROOT".asSymbol, \Special, \All).asTrackArray
~musicLibrary = MusicLibrary.loadFromTraktor(Library.at(\musicLibraryPath), Library.at(\traktorLibraryPath), forceLoad: true);
~musicLibrary = MusicLibrary.loadFromTraktor(Library.at(\musicLibraryPath), Library.at(\traktorLibraryPath), forceLoad: false);
~musicLibrary.store(Library.at(\musicLibraryPath))
(
var instance;
instance = Object.readTextArchive(Library.at(\musicLibraryPath));
instance.tracks;
)
Stethoscope.new
{ [SinOsc.ar(440, 0, 0.2),SinOsc.ar(450, 0, 0.2) ]}.play;
Array.series((s.options.numOutputBusChannels-2).clip(2,6));

~musicLibrary.playlists.at("$ROOT".asSymbol, \Custom)