~mLaunchPad = MidiInOutPair("MIDIIN2 (LPMiniMK3 MIDI)","MIDIOUT2 (LPMiniMK3 MIDI)", lightingSkin:[45, 21]); // we send the sysex message to change to programmer mode
~sysex = [240, 0, 32, 41, 2, 13, 14, 1, 247];
~mLaunchPad.midiOut.sysex(Int8Array.newFrom(~sysex))
// waarom failed primitive send sysex? het enige wat ik anders heb gedaan is die virtual audio cable te gerbuiken