(
s = Server.local;
s.options.maxLogins_(2);
s.options.inDevice_("ASIO : JackRouter");
s.options.outDevice_("ASIO : JackRouter");
s.options.numInputBusChannels_(10);
s.options.numOutputBusChannels_(8);
s.boot;
)

(
MyMIDI2.classInit;
~m_xone = MidiInOutPair("XONE","XONE");
)

b = Bus.audio(s,2);
b.scope

(
SynthDef(\dust,{
	var output, env;
	env = Env.new([0,1,1,0],[5,170,5]);
	output = Dust2.ar(ServerControl.kr(\density).linlin(0,1,1,6000));
	output = Pan2.ar(output,ServerControl.kr(\pos).linlin(0,1,-1,1));
	output = output * EnvGen.kr(env, doneAction: Done.freeSelf);
	Out.ar(b,output);
}).add;

SynthDef(\exp1,{
	var input, output;
	input = In.ar(b,2);
    output = StringVoice.ar(
		input,
		freq: ServerControl.kr(\freq).linexp(0,1,440,20000),
		damping: ServerControl.kr(\damp),
	);
	ReplaceOut.ar(b,output);
}).add;

SynthDef(\dist,{
	var input, output;
	input = In.ar(b,2);
	output = LPF.ar(input,ServerControl.kr(\freq).linexp(0,1,22000,44000));
	output = output.clip2(1);
	ReplaceOut.ar(b,output);
}).add;


SynthDef(\filt,{
	var input, output;
	input = In.ar(b,2);
	output = VadimFilter.ar(input,ServerControl.kr(\filt).linexp(0,1,4000,20000),0);
	output = output.clip2(1);
	//output = LPF.ar(output,4000);
	ReplaceOut.ar(b,output);
}).add;

SynthDef(\out,{
	var input, output;
	input = In.ar(b,2);
	output = LeakDC.ar(input);
	output = output * ServerControl.kr(\vol,0);
	Out.ar(0,output);
}).add;
)

(
g = Group.new();
q = Synth.tail(g,\dust);
w = Synth.tail(g,\exp1);
e = Synth.tail(g,\dist);
r = Synth.tail(g,\filt);
p = Synth.tail(g,\out);
)

q.trace;

(
MyMIDI2.resetLibraries;
MidiCC(\normal,[~m_xone,0,1],CCAbstractTarget(q,\density, \relative));
MidiCC(\normal,[~m_xone,0,2],CCAbstractTarget(q,\pos, \relative));

MidiCC(\normal,[~m_xone,0,3],CCAbstractTarget(w,\freq, \relative));
MidiCC(\normal,[~m_xone,0,4],CCAbstractTarget(w,\damp, \relative));

MidiCC(\normal,[~m_xone,0,5],CCAbstractTarget(e,\freq, \relative));

MidiCC(\normal,[~m_xone,0,7],CCAbstractTarget(r,\filt, \relative));

MidiCC(\normal,[~m_xone,0,8],CCAbstractTarget(p,\vol, \relative));
)

CmdPeriod.objects
f= {3.value};
a = SkipJack(f);
SkipJack.verbose = true;
MyMIDI2.normalCCMappingDictionary[5].[1].parameterBus.getSynchronous;
s.sampleRate