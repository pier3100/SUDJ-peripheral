
(
var array1;
array1 = [1, 2, 3, 5, 7];
array1.any({arg item; item ==2})
)

Platform.userExtensionDir;   // Extensions available only to your user account
Platform.systemExtensionDir; // Extensions available to all users on the machine

(
var onPlayer, noteOn;
onPlayer = {arg note; note.postln};
noteOn = { arg note, vel; onPlayer.value(note, vel) };
noteOn.value(3,10);
)
AbstractMIDISocket.browse;

ButtonPushMIDISocket([~m_xone, 11], SetSynthKey(~synthy,\que),5);

s.boot;

(
		SynthDef("outputs", {arg wut, dut;
			Out.ar(0, 0*wut);
		}).add;
)

SetSynthKey(~synth_out2,\wut);
{arg val; ~synth_out2.set(\wut,val)};

e.value(2);
~synth_out2 = Synth.new("outputs");

~synth_out2.get(\wut,{arg value; value.postln});
t = ToggleSynthKey.new(~synth_out2,\wut,2);
t.value();
f = t.return;
f.class;
t = nil;

3.postln;
4
Function.browse;