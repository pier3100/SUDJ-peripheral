c.tempo * 60;

// playback
~deck1.loadDouble(~prelistenDeck);
~deck1.pitchbend_(10);

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
~deck3.endOfTrackEvent;
~deck3.clock.beats
~deck3.time2beat(~deck3.track.duration)

~sChannel1.trace
s.options.numOutputBusChannels

// settings
~sOutputs.setControlVal(\headPhoneGainDb, -25);

// libraryConsole
~prelistenDeck.track.postInfo;
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

Stethoscope.new
{ [SinOsc.ar(440, 0, 0.2),SinOsc.ar(450, 0, 0.2) ]}.play;
Array.series((s.options.numOutputBusChannels-2).clip(2,6));