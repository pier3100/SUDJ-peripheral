// connect to joystick
(
~hidList = HID.findAvailable;
~hidList.selectKeys({ |item| item.productName =="T.Flight Stick X" })[0] !? {|hidID| // if we can find the a hid device with a corresponding name, then open this device and set it up
    ~thrustMaster = HID.openAt(hidID); // we find and open the hid Pos device, assuming there is only one, and it is the barcode scanner
};
)
// buffer
(
b = Buffer.readChannel(s, "C:/Users/piert/MakingMusic/Samples/leaves-crunching-6954-bounce-2.wav", channels: [0]);
)

// synthdef
(
SynthDef(\riser2,{ |bus|
	var out, freq, freqLfo, lr, ud, gasBrake, wheel, speed, direction, engine, wind, brake, windBrake;
	// controls
	lr = ServerControlLag.kr(\lr,0.5);
	ud = ServerControlLag.kr(\ud,0.5);
    gasBrake = ud.linlin(0,1,1,-1);
	wheel = lr.linlin(0,1,-1,1);
	speed = Slew.kr(InRange.kr(gasBrake, 0.0001, 2), gasBrake.linlin(0,1,0,1), (gasBrake.linexp(-1,0,10,0.04)));
	direction = Slew.kr(wheel.sign, wheel.linlin(0,1,0,0.6), wheel.linlin(-1,0,0.6,0));//TODO should go from -1 to 1
	// freq
	freq = 4400*direction.linexp(-1,1,0.25,4);
	freqLfo = 100*direction.linexp(-1,1,0.5,2);
	// engine sound generator
	engine = PlayBuf.ar(1,b,freq,loop: 1);
	engine = engine * VolumeFaderCurve.kr(speed);
	engine = DjFilter.ar(engine,lr);
	// windreverb
	//wind = FreeVerb2.ar(engine[0],engine[1],1,1,0.1);
	//wind = GVerb.ar(engine, drylevel: 0);
	wind = engine;
	//windBrake = Slope.kr(gasBrake).neg.clip(0,1);
	windBrake = gasBrake.linlin(-1,0,0.1,1);
	wind = Compander.ar(wind, wind, windBrake, 1, 0) / windBrake; // to compensate for volume
	wind = GVerb.ar(wind, roomsize: 50, damping: 0.8,);
	wind = wind * SinOsc.ar(freqLfo,0,0.1,1);
	//wind = AnalogVintageDistortion.ar(wind,gasBrake.linlin(-0.15,0,1,0));
	//out
	out = engine + (1 * wind);// + brake;
	out = out * ServerControlLag.kr(\gain, 0.5).linlin(0, 1, 25, -25).dbamp; // -6 to +6 gain
	Out.ar(bus,out);
}).add;
)
// hid
(
q.free;
q = Synth(\riser2);
HidCC([1,~thrustMaster], ServerTarget(q,\gain));
HidCC([3,~thrustMaster], ServerTarget(q,\ud));
HidCC([4,~thrustMaster], ServerTarget(q,\lr));
)

// debug
MidiHidSystem.post;
MidiHidSystem.removeAll;
q.trace;
s.plotTree;
Stethoscope.new