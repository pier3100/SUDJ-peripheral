f = FoaEncoderKernel.newSuper(2048)
f.kernelSize
f.numOutputs








MIDIClient.init;
~m_akai_mpk = MIDIClient.sources.detectIndex { |endpoint| endpoint.name.contains("MPKmini2")};
~knob1 = 0.0;
~knob1;
BasicMIDIControl([~m_akai_mpk, \omni], 1, { arg val; ~knob1 = val.linlin(0,127,-1,1)});
BasicMIDIControl([~m_akai_mpk, \omni], 1, { arg val; u.set(\ang,val.linlin(0,127,-2*pi,2*pi))});

~sD = IdentityDictionary.new;
~b_out = Bus.audio(s,8);
~b_out.scope;
FreqScope(busNum: ~b_out);
Stethoscope.new;

(
SynthDef("out",{
	Out.ar(0,In.ar(~b_out,8))}).add;
)

(
SynthDef("pad",{arg pos;
	var out, outPanL,outPanR, env;
	env = Env([0, 1, 0],[0.3, 0.4]);
	out = SinOsc.ar([440, 880]) ;
	outPanL = PanAz.ar(6, out[0], pos:pos, level: 1.0, width: 2.0, orientation: 0.5);
	outPanR = PanAz.ar(6, out[1], pos:pos+(2/6), level: 1.0, width: 2.0, orientation: 0.5);
	Out.ar(~b_out,(outPanL+outPanR)*EnvGen.kr(env,doneAction: Done.freeSelf));
}).add;
)

(
SynthDef("pad2",{arg pos;
	var out, outPanL,outPanR, env;
	env = Env([0, 1, 0],[0.3, 0.4]);
	out = SinOsc.ar([440, 440*2, 440*3]) ;
	Out.ar(~b_out,out.sum*EnvGen.kr(env,doneAction: Done.freeSelf));
}).add;
)

Synth("out");
Synth("pad",[\pos, -1/6]).key(\pad);

\\ATK
Atk.downloadKernels;
Atk.downloadMatrices;
Atk.downloadSounds;
Atk.openUserSupportDir;
Platform.userExtensionDir;

~decoder = FoaDecoderMatrix.newPanto(numChans: 6, orientation: 'flat', k: 'dual');

~sndbuf = Buffer.read(s, Atk.userSoundsDir ++ "/b-format/Anderson-Pacific_Slope.wav")
~sndbuf = Buffer.read(s, Atk.userSoundsDir ++ "/b-format/Howle-Calling_Tunes.wav")
~sndbuf = Buffer.read(s, Atk.userSoundsDir ++ "/b-format/Pampin-On_Space.wav")

(
SynthDef("surr1",{
    var sig;                            // audio signal


    // display encoder and decoder
    "Ambisonic decoding via % decoder".format(~decoder.kind).postln;

    // ------------------------------------------------------------
    // test sig
    sig = PlayBuf.ar(~sndbuf.numChannels, ~sndbuf, BufRateScale.kr(~sndbuf), doneAction:2);   // soundfile


    // ------------------------------------------------------------
    // decode (via ~renderDecode)
    //~renderDecode.value(sig, ~decoder)
	Out.ar(0,FoaDecode.ar(sig, ~decoder));

}).add;
)

u = Synth("surr1");

// free buffer
~sndbuf.free
// ------------------



//HOA
~matrixEncoder = HoaMatrixEncoder.newDirections([-30, 30].degrad, order: 2);

~matrixDecoder = HoaMatrixDecoder.newPanto(numChans: 6, orientation: 'flat', beamShape: 'basic', match: 'amp', order: 2);
~matrixDecoder = HoaMatrixDecoder.newProjection([-30, 30, -90, 90, -150, 150].degrad, beamShape: 'basic', match: 'amp', order: 2);
~decoder.directions.raddeg;
(
SynthDef("surr2",{arg ang;
	var input, ambiPre, ambiAfter, output;

	input = In.ar(8,2);
	ambiPre = HoaEncodeMatrix.ar(input, ~matrixEncoder);
	ambiAfter = HoaRotate.ar(ambiPre, angle: ang, order: 2);
    output = HoaDecodeMatrix.ar(ambiAfter, ~matrixDecoder);
	output = output * ServerControl.kr(\volume);
	Out.ar(0,output);
}).add;
)

u = Synth("surr2");
u.get(\ang,{arg val;val.postln});

//
(
s = Server.local;
s.options.maxLogins_(2);
s.options.inDevice_("ASIO : JackRouter");
s.options.outDevice_("ASIO : JackRouter");
s.options.numInputBusChannels_(10);
s.options.numOutputBusChannels_(8);
s.options.memSize_(8192*(2**2));
s.boot;
)

//ableton link clock, and 1/16 clock
(
c = LinkClock.new.latency_(s.latency);
~c16th = TempoClock.new(c.tempo, 0, 0);

~bTempo = Bus.control();
)
//syncing the clocks
(
~changeClock_func = {arg tempo;
	c.tempo_(tempo);
	~c16th.tempo_(tempo*4);
	~bTempo.setSynchronous(tempo);
};
)

~changeClock_func.value(130/60);

(
~hoaOrder = 2;
~speakerDegrees = [-30, 30, -90, 90, -150, 160];
~speakerDbsCorrection = [0, 0, 0, 4, 0, 4]; //In a free field - a doubling of the distance from a noise source reduces the sound pressure level with 6 decibel.
~matrixDecoder = HoaMatrixDecoder.newModeMatch(~speakerDegrees.degrad, beamShape: 'basic', match: 'amp', order: ~hoaOrder);
~matrixEncoder = HoaMatrixEncoder.newDirections([-30, 30].degrad, order: ~hoaOrder);
~hoaChannels = ~matrixEncoder.numOutputs;
~bOutMain = Bus.audio(s,~hoaChannels);
~b_out_heads = Bus.audio(s,2);
)

~bOutMain.numChannels

\\template
(
SynthDef(\auto, { |bus|
	AutoIn.ar(bus);
}).add;
)

(
SynthDef(\man, { |bus|
	In.ar(bus,bus.numChannels);
}).add;
)


q = Synth(\auto,[\bus, ~b_out_heads]);
q.trace;

w = Synth(\man,[\bus, ~bOutMain]);
w.trace;

SynthDef(\temp,{
	var input, output;
	input = In.ar(~bOutMain,~bOutMain.numChannels);
	output = input;
	ReplaceOut.ar(~bOutMain,output);
}).add;

(
SynthDef("surr2",{
	var input, output;
	input = In.ar(8,2);
	output = HoaEncodeMatrix.ar(input, ~matrixEncoder);
	output = HoaRotate.ar(output, angle: ServerControl.kr(\pan,0.5).linlin(0,1,-pi,pi), order: 2);
	Out.ar(~bOutMain,output);
}).add;

SynthDef("delay",{
	var input, wet, output;
	input = In.ar(~bOutMain,~bOutMain.numChannels);
	wet = DelayL.ar(input,6,ServerControl.kr(\delay).linlin(0,1,0.1,4).ceil/In.kr(~bTempo));
	output = XFade2.ar(input,wet,ServerControl.kr(\drywet).linlin(0,1,-1,1));
	ReplaceOut.ar(~bOutMain,output);
}).add;

SynthDef("outputs", {
	var input, output;
	input = In.ar(~bOutMain,~bOutMain.numChannels);
	output =  HoaDecodeMatrix.ar(input, ~matrixDecoder);
	output = MulAdd(output,~speakerDbsCorrection.dbamp);
	output = output * ServerControl.kr(\volume);
    Out.ar(0, output);
    Out.ar(6, In.ar(~b_out_heads,2));
}).add;
)

(
g = Group.new();
q = Synth.tail(g,\surr2);
w = Synth.tail(g,\delay);
p = Synth.tail(g,\outputs);
)

MyMIDI2.classInit;
~bTempo.getnSynchronous(2)
~m_bcr2000 = MidiInOutPair("BCR2000-SuperCollider","SuperCollider-BCR2000");

(
MyMIDI2.resetLibraries;
f = MidiCC(\normal,[~m_bcr2000,0,1],CCAbstractTarget(q,\pan,\relative));
g = MidiCC(\normal,[~m_bcr2000,0,2],CCAbstractTarget(w,\delay,\relative));
MidiCC(\normal,[~m_bcr2000,0,3],CCAbstractTarget(w,\drywet,\relative));
h = MidiCC(\normal,[~m_bcr2000,0,8],CCAbstractTarget(p,\volume,\relative));

)
g.target.parameterBus.getSynchronous

p = ServerTarget(~sChannel1,\pan);
p.parameterValue
p.outputValue;
p.parameterValue_(0.8);
MidiCC([~mBcr,0,1],p);
MidiCC([~mBcr,0,2],ServerTarget(~sChannel2,\pan));