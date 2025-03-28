~deck3.loop
~deck3.loopSize
~deck1.loop
~deck1.loopSize
~deck1.clock.beats
~deck1.clock.tempo
~deck1.clock.isPlaying
~deck1.beatJump(0)
~deck1.time2beatAdjusted(0)
~deck1.userInducedGridOffsetActual
~deck1.userInducedGridOffsetSetpoint
~deck1.userInducedGridOffsetStatic
b = BoolLangTarget(~deck3, \loop);
m = MidiButton([1, 14, ~mXone], b, mode: \toggle);

b.value(true)
b.parameterValue_(true)
b.parameterValue
b.outputValue

~prelistenDeck.track.userInducedGridOffset
~prelistenDeck.track.title

~deck1.track.title
~deck1.track.userInducedGridOffset
~deck1.userInducedGridOffsetSetpoint
~deck1.trackTempo
~deck1.track.duration