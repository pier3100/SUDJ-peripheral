// connect to joystick
(
~hidList = HID.findAvailable;
~hidList.selectKeys({ |item| item.productName =="T.Flight Stick X" })[0] !? {|hidID| // if we can find the a hid device with a corresponding name, then open this device and set it up
    ~thrustMaster = HID.openAt(hidID); // we find and open the hid Pos device, assuming there is only one, and it is the barcode scanner
};
)

// deisgn synthdef
(
SynthDef(\s1,{
	var freq, freqs, width, positions, detune, saw, out;
	freq = ServerControlLag.kr(\freq, 0,5).linlin(0,1,220,660);
	width = ServerControlLag.kr(\width, 0,5);
	detune = width;
	freqs = [freq+detune, freq+(0.5 * detune), freq +(0.25*detune), freq, freq+(0.5*detune), freq+detune, freq+(0.25*detune)];
	positions = [-1, -0.7, -0.3, 0, 0.3, 0.7, 1]*width;
	saw = Saw.ar(freqs);
	out = Pan2.ar(saw, positions);
	out = Hasher.ar(out);
	out = Formlet.ar(out,freq,width*2);
	out = out * ServerControlLag.kr(\vol, 1).linlin(0,1,1,0);
	Out.ar(0,out);
}).add;
)

(
SynthDef(\riser1,{
	var freq, filterFreq, freqs, sin, out, klank, times, lr, ud,par1;
	lr = ServerControlLag.kr(\lr,0.5);
	ud = ServerControlLag.kr(\ud,0.5);
	freq = 440;
	filterFreq = ud.linexp(0,1,20000,440);
	freqs = [0.75, 0.89 ,1]*filterFreq;
	sin = SinOsc.ar(freq);
	out = Pan2.ar(sin);
	out = Hasher.ar(out);
	out =Slew.ar(out,1000,1000);
	klank = out * VolumeFaderCurve.kr(lr.linlin(0,0.5,0.2,0));
	par1 = (lr*ud*16).clip(0,1);
	par1 = Lag.kr(par1,6);
	times = [1,2,1] + ([10,8,6] * par1);
	klank = DynKlank.ar(`[freqs,[0.8, 1, 0.7], times], klank);
	out = out + klank;
	out = RLPF.ar(out,filterFreq,lr.linlin(0.6,1,1,0.02));

	out = out * VolumeFaderCurve.kr(ServerControlLag.kr(\vol, 1).linlin(0,1,1,0));
	Out.ar(0,out);
}).add;
)

// routine
(
r = Routine({
	[0.75, 0.89 ,1].yield;
	[1,1,1].yield;
});
)
r.next
r.reset
(
// TODO if we have a class hit button, we can use the buttons to step trough a list (using a routine) of chords, these chords are then send to the server; the chords will be C-E-A; E-A-C; F-A-C
// launch synth
q.free;
q = Synth(\riser1);

// connect controls
HidCC([1,~thrustMaster], ServerTarget(q,\vol));
HidCC([3,~thrustMaster], ServerTarget(q,\ud));
HidCC([4,~thrustMaster], ServerTarget(q,\lr));
)

// synth debug
q.trace

// HID debug
HidCC([4,~thrustMaster], { |val| val.postln});
HidSystem.initializedHid
MidiHidSystem.post
MidiHidSystem.remove(0)
HID.action_({arg ...args; args.postln})
HidSystem.initHid
0.3.not