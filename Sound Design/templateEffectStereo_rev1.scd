(
s = Server.local;
s.options.maxLogins_(2);
s.options.inDevice_("ASIO : XONE:DX USB ASIO driver");
s.options.outDevice_("ASIO : JackRouter");
s.options.numInputBusChannels_(10);
s.options.numOutputBusChannels_(8);
s.options.memSize_(8192*(2**2));
s.boot;
)

~m_bcr2000 = MidiInOutPair("BCR2000-SuperCollider","SuperCollider-BCR2000");
~m_akai = MidiInOutPair("MPK","MPK");
MIDIClient.init

(
~hoaChannels = 2;
~bOutMain = Bus.audio(s,2);
b = Buffer.read(s,"C:\\Users\\piert\\Music\\ZSpotify Music\\Maybe Set1\\Brian Eno, David Byrne - Regiment.ogg");
)

\\template
SynthDef(\temp,{
	var input, wet, output;
	input = In.ar(~bOutMain,~bOutMain.numChannels);
	wet = input;
	output = XFade2.ar(input,wet,ServerControl.kr(\drywet).linlin(0,1,-1,1));
	ReplaceOut.ar(~bOutMain,output);
}).add;


(
SynthDef(\track, { |buf|
	var output;
	output = PlayBuf.ar(2,buf);
	Out.ar(~bOutMain,output);
}).add;

SynthDef(\dust,{
	var output;
	output = Dust2.ar(ServerControl.kr(\density).linexp(0,1,0.01,6000)*Array.ones(~hoaChannels));
	Out.ar(~bOutMain,output);
}).add;

SynthDef(\analogDist, {
	var input, wet, output;
	input = In.ar(~bOutMain,~bOutMain.numChannels);
	wet = AnalogVintageDistortion.ar(input, ServerControl.kr(\drive));
	output = XFade2.ar(input,wet,ServerControl.kr(\drywet, 1).linlin(0,1,-1,1));
	ReplaceOut.ar(~bOutMain,output);
}).add;

SynthDef(\myDist, {
	var input, wet, output, bass, carrier, freq;
	input = In.ar(~bOutMain,~bOutMain.numChannels);
	freq = ServerControl.kr(\freq).linexp(0,1,100,20000);
	bass = RLPF.ar(input,freq,ServerControl.kr(\rq, 0.5).linlin(0,1,0.2,3));
	carrier = BLOsc.ar(freq,ServerControl.kr(\pulse));
	wet = input * ServerControl.kr(\drive).linlin(0,1,0,30) * DiodeRingMod.ar(carrier, input);
	output = XFade2.ar(input,wet,ServerControl.kr(\drywet, 1).linlin(0,1,-1,1));
	ReplaceOut.ar(~bOutMain,output);
}).add;

SynthDef(\dist,{
	var input, output;
	input = In.ar(~bOutMain,~bOutMain.numChannels);
	output = LPF.ar(input,ServerControl.kr(\freq).linexp(0,1,22000,44000));
	output = output.clip2(1);
	ReplaceOut.ar(~bOutMain,output);
}).add;

SynthDef(\filt,{
	var input, output;
	input = In.ar(~bOutMain,~bOutMain.numChannels);
	output = VadimFilter.ar(input,ServerControl.kr(\filtHP).linexp(0,1,500,20000),0,4);//HP
	output = VadimFilter.ar(output,ServerControl.kr(\filtLP,1).linexp(0,1,4000,20000),0);//LP
	ReplaceOut.ar(~bOutMain,output);
}).add;

SynthDef(\outputs, {
	var input, output;
	input = In.ar(~bOutMain,~bOutMain.numChannels);
	output = input * ServerControl.kr(\volume);
    output = output.clip2(1);
	output = LeakDC.ar(output);
    Out.ar(0, output);
}).add;
)

(
g = Group.new();
//q = Synth.tail(g,\dust);
q = Synth.head(g,\track);
w = Synth.tail(g,\dist);
r = Synth.after(w,\myDist);
e = Synth.tail(g,\filt);
p = Synth.tail(g,\outputs);
)

q.trace
Stethoscope.new

(
MidiCC([~m_akai,0,1], ServerTarget(r,\rq), mode:\absolute);
MidiCC([~m_akai,0,2], ServerTarget(r,\pulse), mode:\absolute);
MidiCC([~m_akai,0,3], ServerTarget(r,\drywet), mode:\absolute);
MidiCC([~m_akai,0,4], ServerTarget(r,\drive), mode:\absolute);
MidiCC([~m_akai,0,5], ServerTarget(r,\freq), mode:\absolute);
MidiCC([~m_akai,0,6], ServerTarget(e,\filtHP), mode:\absolute);
MidiCC([~m_akai,0,7], ServerTarget(e,\filtLP), mode:\absolute);
MidiCC([~m_akai,0,8], ServerTarget(p,\volume), mode:\absolute);
)



(
MyMIDI2.resetLibraries;
MidiCC(\normal,[~m_akai,0,1],ServerTarget(q,\density, \relative));

//MidiCC(\normal,[~m_xone,0,3],CCAbstractTarget(w,\freq, \relative));
//MidiCC(\normal,[~m_xone,0,4],CCAbstractTarget(w,\damp, \relative));
//MidiCC(\normal,[~m_xone,0,5],CCAbstractTarget(e,\freq, \relative));

)
