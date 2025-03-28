(
s = Server.local;
s.options.maxLogins_(2);
s.options.inDevice_("MME : Microphone (Realtek(R) Audio)");
s.options.outDevice_("MME : Speakers (Realtek(R) Audio)");
s.options.numInputBusChannels_(2);
s.options.numOutputBusChannels_(2);
s.boot;
)



//initializing MyMIDI
(
//synthDef
SynthDef("mainSynth",{
	var env, freq;
	freq = ServerControl.kr(\freq,1).linlin(0,1,400,800);
	env = Env([0, 1, 0],[100, 2]);
	Out.ar(0,SinOsc.ar(freq)*EnvGen.kr(env));
	//Out.ar(0,SinOsc.ar(freq)*EnvGen.kr(env, doneAction: Done.freeSelf));
}).add;

SynthDef(\macroLFO,{arg macroBus;
	var output, amplitude, reference, modulator;
	modulator = SinOsc.kr(\freq.kr(0.1));
	modulator = LinXFade2.kr(-1,modulator,\crossfade.kr(0).linlin(0,1,-1,1));
	reference = \ref.kr(0);
	Out.kr(macroBus,[modulator, reference]);
}).add;

MySynthDef(\macroLine,{arg macroBus;
	var trig, rate, reference, modulator;
	rate = \rate.kr(0);
	trig = Changed.kr(rate);
	modulator = -1+(2*Sweep.kr(trig,rate));
	modulator = modulator.clip(-1,1);
	modulator = LinXFade2.kr(-1,modulator,\crossfade.kr(0).linlin(0,1,-1,1));
	reference = \ref.kr(0);
	Out.kr(macroBus,[modulator, reference]);
}).add.reset({ |synth, clockArg| var clock; clockArg ?? clock = TempoClock.default; synth.set(\rate,1/((clock.nextBar+16-clock.beats)/clock.tempo))});

MySynthDef(\testbutton,{
	var button;
	button = ServerControl.kr(\button,0);
}).add;
)


//synths
(
q = Synth(\testbutton);
w = Synth(\macroLFO).installMacro;
e = Synth(\macroLine).installMacro;

// langcontrol
t = TempoClock.new;
)

// midi
(
~m_bcr = MidiInOutPair("BCR2000-SuperCollider","SuperCollider-BCR2000");
~m_xone = MidiInOutPair("XoneDX-SuperCollider");
MidiHidSystem.resetAllLibraries;

a = AbstractLangTarget(t,\tempo,[0.001,1]);
MidiCC([~m_bcr,0,1],a);

d = MacroTarget(w,\crossfade);
x =  MidiCC([~m_bcr,0,5],d);

f = MacroTarget(w,\ref);
c = MidiCC([~m_bcr,0,6],f);

MidiCC([~m_bcr,0,7],MacroTarget(w,\freq));
MidiButton([~m_bcr, 0, 60],BoolLangTarget(MidiHidSystem,\macroToggle));
MidiButton([~m_bcr, 0, 61],BoolLangTarget(MidiHidSystem,\activateGlobalSensitivity));
)
MidiHidSystem.globalSensitivity
t.tempo
a.macroBus.index
MidiHidSystem.activeMacroTarget.macroBus
MidiHidSystem.dummyTarget.macroBus
MidiHidSystem.dummyBus.index
MidiHidSystem.activateGlobalSensitivity




~m_bcr.midiOut.noteOn(0,60,127);
~m_bcr.midiOut.noteOff(0,60,0);

o = [1,2]

b = Bus.control(numChannels: 2);
b.free
Bus.

(
q = Synth("mainSynth");
w = Synth(\macroLFO,[\macroBus, ~b_macro_1]); //create a synth which we can call by key, where the key is stored in the library ~synthDictionary
e = Synth(\macroLine, [\macroBus, ~b_macro_2]);
)

e.trace
e.reset

TempoClock.schedAbs(1,{e.trace; TempoClock.beats.postln; 1})
2784/4
//midi

//Button
MidiHidSystem.prInit;
~m_bcr = MidiInOutPair("BCR2000-SuperCollider","SuperCollider-BCR2000");

(
MidiButton([~m_bcr, 0, 60],BoolLangTarget(MidiHidSystem,\macroToggle););

a = ServerControlTarget(q,\freq);
z = MidiCC([~m_bcr,0,1],a,sensitivity: 0.5);

d = MacroTarget(w,\crossfade);
x =  MidiCC([~m_bcr,0,5],d);

f = MacroTarget(w,\ref);
c = MidiCC([~m_bcr,0,6],f);

MidiCC([~m_bcr,0,7],MacroTarget(w,\freq));

//l = LangControl();
//t = MidiCC([~m_bcr,0,64],l,mode: \absolute);

MidiCC([~m_bcr,0,81],MacroTarget(e,\crossfade));
MidiCC([~m_bcr,0,82],MacroTarget(e,\ref));

)

a.macroBus.index


MidiHidSystem.activeMacroTarget.key==\ref
(MidiHidSystem.activeMacroTarget.key==\ref)||(MidiHidSystem.activeMacroTarget.key==\reference)


(

MIDIClient.init;
~m_mpk = MidiInOutPair("MPK","MPK");
~m_xone = MidiInOutPair("XONE","XONE");
~m_bcr = MidiInOutPair("loopMIDI BCR2000-SuperCollider","loopMIDI SuperCollider-BCR2000");

a = ServerControlTarget(q,\freq);
b = MidiCC([~m_xone,0,1],a,sensitivity: 0.5);
a.currentParameterValue

c = MacroTarget(w,\amplitude);
d = MidiCC([~m_xone,0,2],c);
c.currentParameterValue
w.trace
w.set(\amplitude,0.5);

e = MacroTarget(w,\crossfade);
f =  MidiCC([~m_bcr,0,1],e);
e.outputValue

l = LangControl();
t = MidiCC([~m_bcr,0,64],l,mode: \absolute);
l.parameterValue;
l.value;
//
a.macroBus
c.macroBus
e.macroBus
l.macroBus
LangControl.dummyBus
MidiHidSystem.macroBusNr
MidiHidSystem.macroToggle
MidiHidSystem.macroToggle_(true)
MidiHidSystem.macroToggle_(false)
//
MidiCC.midiCCMappingDictionary
MidiHidSystem.resetAllLibraries

////mappings
m.addNormal([MS(~m_akai_mpk,0,7),SP(\mainSynth,\freq),{|val| val.linlin(0,127,0,1)}]);
m.addNormal([MS(~m_xone,11,3),SP(\mainSynth,\freq),{|val| val.linlin(0,127,0,1)}]);
m.addMacro([MS(~m_akai_mpk,0,1),SP(\macro_4,\crossfade),{|val| val.linlin(0,127,-1,1)}]);
m.addMacro([MS(~m_akai_mpk,0,2),SP(\macro_4,\amplitude),{|val| val.linlin(0,127,0,1)}]);
m.addMacro([MS(~m_akai_mpk,0,3),SP(\macro_4,\freq),{|val| val.linlin(0,127,0.1,1)}]);
ButtonOnOffMIDISocket([~m_fire.indexIn, 0],{m.macroToggle_(1)},{m.macroToggle_(0);
	m.resetMacroBus;
}, 48);// button which enable macroMapping mode, as indicated by macroToggle = 1
)

////midi reference functions
MIDIdef.cc(\main2, {arg ...args; args.postln});
MIDIdef.noteOn(\main3, {arg ...args; args.postln});
MIDIdef.noteOff(\main4, {arg ...args; args.postln});
MIDIdef.all;
MIDIdef.freeAll;

//refernce entries
NodeProxy.browse;
~a = nil;
~a;
~a_macroMIDI = nil;
~a_macroMIDI;
~synthDictionary;
~sD[\macro_4].get(\crossfade, {|val| val.postln});
~synthDictionary[\macro_4].get(\amplitude, {|val| val.postln});
~synthDictionary[\macro_4].get(\freq, {|val| val.postln});
~b_dummy.index;
~b_macro_1.index;
~macroToggle;
m.macroBus;
m.macroToggle;
m.normalMappingDictionary;
~sD[\mainSynth].getn(\freq,2, {|val| val.postln});
~synthDictionary[\mainSynth].trace;
~synthDictionary[\macro_4].trace;
m.resetMacroBus;

//commissioning
m;
~m_xone;
~m_xone =       MidiInOutPair(MIDIClient.sources.detectIndex { |endpoint| endpoint.name.contains("loopMIDI Port 2")},-1);
m.addNormal([MS(~m_xone,11,3),SP(\s_channel_1,\faderVolume),{|val| val.linlin(0,127,0,1)}]);
~sD[\s_channel_1].getn(\faderVolume,2, {|val| val.postln});
~sD[\s_channel_1].setVal(\faderVolume,1);

b = Bus.control;
(
{
	var output;
	output = SinOsc.kr(0.2);
	Out.kr(b,output)
}.play;
)
c = {b.getSynchronous}
c.value
3.value
LangControl
h = Trest.new();
h.hoi

0.5.linlin(0,1,0,4/128);
1/128
0.sqrt

200.linlin(0,127,0,1,\nil
	200.respondsTo(\hoi)
)

a = [];

// AbstractLangPushTarget
(
s = Server.local;
s.options.maxLogins_(2);
s.options.inDevice_("MME : Microphone (Realtek(R) Audio)");
s.options.outDevice_("MME : Speakers (Realtek(R) Audio)");
s.options.numInputBusChannels_(2);
s.options.numOutputBusChannels_(2);
s.boot;
)
~m_xone = MidiInOutPair("XONE","XONE");
t = TempoClock.new();
p = AbstractLangPushTarget.new(t,\tempo_);
m = MidiCC([~m_xone,0,1],p);
p.basicValue(1.3)
t.tempo
t.tempo_(1.5)

k =45.67
k.value_(3)


//Button
MidiHidSystem.prInit;
MidiHidSystem.resetAllLibraries;
b = MidiButton([~m_xone, 0, 60],{ MidiHidSystem.macroToggle_(true) }, { MidiHidSystem.macroToggle_(false) });
b = MidiButton([~m_xone, 0, 60],t);
t = LangBoolTarget(MidiHidSystem,\macroToggle);
t.parameterValue


true.not
1.not
0.not
1.02.not
MidiButton.midiNoteOnMappingDictionary[0][1].value
b.targetOff
MidiButton(
 MidiHidSystem.macroToggle
MidiHidSystem.macroToggle_(false)
k = 5
k = 3
t.tempo = 3
t.tempo

f = { |object,val| object = val };
f.value(t.tempo,4);
g = { |val| t.tempo = val };
g.value(4)
t.tempo
g.value

t.temp
0 ==0
0.0.class.browse
Integer.browse

1.asBoolean
\hoi.asSetter

	t = AbstractTarget.new
	t.value

	f = {|val| val**2 };
	g = {|val| var out; out = val; if(val==0){out = 3}; out};
	f.(3)
	h = t <> g
	h.value(0)
	g.value(3)

	d = Dictionary.new();
d.put(\a, 440);
d.keys; // Set[\a]
d.put(\a, nil); // removes the value 440
d.keys; // Set[]
	d.put(\hoi,LangControl.new)
	d.at(\hoi)
	d
	d.at(\doei).value