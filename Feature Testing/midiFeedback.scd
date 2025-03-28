MidiHidSystem.enabled_(false)
MidiHidSystem.enabled_(true)

MidiHidSystem.post

m = MidiButton([71, 0, ~mLaunchPad], ContinuousLangTarget(~libraryConsole, \tempoFilter, clip: false), mode: \direct, buttonValue: 2);

~libraryConsole.tempoFilter;
~libraryConsole.dependants;
m.buttonValue
m.targetOut.value
m.targetOn.outputValue
2.0==2
(
var track;
track = ~libraryConsole.activeTrackArrayFiltered[3];
track.key.scale.postln;
track.key.rootNote.postln;
)

(
var track;
track = ~libraryConsole.referenceTrack;
track.key.scale.postln;
track.key.rootNote.postln;
)