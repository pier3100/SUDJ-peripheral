(
MIDIClient.init;
~mOutID_launchpad = MIDIClient.destinations.detectIndex { |endpoint| endpoint.name.contains("MIDIOUT2 (LPMiniMK3 MIDI)")};
~mInID_launchpad = MIDIClient.sources.detectIndex { |endpoint| endpoint.name.contains("MIDIIN2 (LPMiniMK3 MIDI)")};
~mOut_launchpad = MIDIOut(~mOutID_launchpad);
)

m.noteOn(0,65,41);
m.noteOff(0,65,0);
	//.noteOn(chan, note: 60, veloc: 64)

ButtonOnMIDISockettest([~mInID_launchpad, 0],{arg val; val.postln},65);
ButtonPushMIDISocket(~m_launchpad.channel_(0),{arg val; val.postln},64);
ButtonPushWithFeedbackMIDISocket(~m_launchpad.channel_(0),{arg val; val.postln},65);
[5, 0].asChannelIndex;
5.asChannelIndex;

~m_launchpad = MidiInOutPair(MIDIClient.sources.detectIndex { |endpoint| endpoint.name.contains("MIDIIN2 (LPMiniMK3 MIDI)")},MIDIClient.destinations.detectIndex { |endpoint| endpoint.name.contains("MIDIOUT2 (LPMiniMK3 MIDI)")});
~m_launchpad.indexOut;
~m_launchpad.isMidiInOutPair;
[~m_launchpad,0].asChannelIndex;
~m_launchpad.channel_(0).asChannelIndex;

~m_traktor = MIDIClient.destinations.detectIndex { |endpoint| endpoint.name.contains("loopMIDI Port 3")};
m = MIDIOut(~m_traktor);
m.noteOn(0,65,41);
m.noteOff(0,65,41);