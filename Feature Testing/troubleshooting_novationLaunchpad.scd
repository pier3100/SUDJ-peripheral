



MIDIClient.init();
~m_launchpad =  MidiInOutPair(MIDIClient.sources.detectIndex { |endpoint| endpoint.name.contains("MIDIIN2 (LPMiniMK3 MIDI)")},MIDIClient.destinations.detectIndex { |endpoint| endpoint.name.contains("MIDIOUT2 (LPMiniMK3 MIDI)")});

~m_launchpad.indexOut;
MIDIClient.destinations;
~midiOut = MIDIOut(~m_launchpad.indexOut);
~midiOut.noteOn(0,64,30);
~midiOut.noteOff(0,64,30);

MIDIIn.connectAll;
MIDIdef.noteOn(\noteOn,{arg ...args; args.postln});

// switching to programmer mode, suing sysez
p = Int8Array.newFrom([240, 0, 32, 41, 2, 13, 14, 1, 247]);
o = Int8Array.newFrom(p);
~mLaunchPad.midiOut.sysex(p);

240 0 32 41 2 13 14 <mode> 247