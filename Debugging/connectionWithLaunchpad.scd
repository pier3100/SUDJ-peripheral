MIDIClient.init
MIDIIn.connectAll
MIDIIn.connect(10,6)
MIDIClient.disposeClient
MIDIIn.connect(6,6)
MIDIIn.connect(12,5);
~mLaunchPad = MidiInOutPair("LPMini-SuperCollider","MIDIOUT2 (LPMiniMK3 MIDI)", [240, 0, 32, 41, 2, 13, 14, 1, 247], [45, 21]); // we send the