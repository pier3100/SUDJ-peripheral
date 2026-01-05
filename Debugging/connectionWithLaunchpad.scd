MIDIClient.init
MIDIIn.connectAll
MIDIIn.connect(10,6)
MIDIClient.disposeClient
MIDIIn.connect(6,6)
MIDIIn.connect(12,5);
~mLaunchPad = MidiInOutPair("LPMini-SuperCollider","MIDIOUT2 (LPMiniMK3 MIDI)", [240, 0, 32, 41, 2, 13, 14, 1, 247], [45, 21]); // we send the

~hello =3
~doei=5;
~hello.addDependant(~doei);

// connetion blink light
~blink = Value.new(0);
~blink.value
~blink.changed
~blink.value_(0);
~blink.value_(1);
t = TestDependant.new
~blink.addDependant(t)
t.update("hoi")
MidiButton([18, 0, ~mLaunchPad.customLighting([7,55])], BoolLangLangTarget(~blink, \value), mode: \feedbackOnly, buttonValue: 0.5);
Value
~mainPLC.tempo;
~mainPLC.add({~blink.value_(~blink.value.not)});
~mainPLC.funcList.array
0.not
true.neg

~blink = Value.new(0);
~mainPLC.add({~blink.value_(~blink.value.not)});
MidiButton([18, 0, ~mLaunchPad.customLighting([7,55])], BoolLangLangTarget(~blink, \value), mode: \feedbackOnly, buttonValue: 0.5);

MIDIClient.initialized

// send sysex message
~sysexMessage = [240, 0, 32, 41, 2, 13, 14, 1, 247];
~sysexMessage = [240, 0, 32, 41, 2, 13, 16, 247];
~mLaunchPad.midiOut.sysex(Int8Array.newFrom(~sysexMessage));
5
midiOut.sysex(Int8Array.newFrom(sysexInit))
"hello world".postln;