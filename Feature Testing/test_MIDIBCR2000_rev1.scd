MIDIClient.init;

// BCR is connected to Xone, so both devices have midi flowing through the Xone Midi in/out; Xone uses channel 12 to 16; currently all BCR input arrives at channel 1

~m_BCR =       MidiInOutPair(MIDIClient.sources.detectIndex { |endpoint| endpoint.name.contains("BCR2000-SuperCollider")},MIDIClient.destinations.detectIndex { |endpoint| endpoint.name.contains("SuperCollider-BCR2000")});
~mOut = MIDIOut(~m_BCR.indexOut);
~mOut.control(0,81,100);

BasicMIDIControl([~m_BCR.indexIn, \omni], 8, { arg val; ~tempoIntegrator.slope_(val.linlin(0,127,-0.1,0.1 ))});
ButtonOnMIDISocket([~m_BCR.indexIn, \omni],{arg val; ~tempoIntegrator.slope_(0)},8);
~tempoIntegrator.slope;

s.boot;
Server.killAll;
m = MidiNormal([MS(~m_BCR,0,9),SP(\s_channel_1,\faderVolume),{|val| val.linlin(0,127,0,1)}])
n = MidiNormal([MS(~m_BCR,0,10),SP(\s_channel_1,\faderVolume),{|val| val.linlin(0,127,0,1)}])
m.macroBus
n.macroBus
m.resetMacroBus;
m = nil;
n = nil;
b = Bus.audio(s);
b.rate
b.index;
c = Bus();
b.index;
d = Bus.control(s);
d.index;
e = Bus.control(s);
e.index;
f = Bus.control(s);
f.index;

i = [11];
i[0]=1
o = i;
o.value

x = [2];
x[0]=3;
u = x[0]**2;
u.value;
u = {arg val; val*2};
i = Test(u);
i.value;
2*3

t = Tee(3,4);
t.value;
t.aa;
t.bb;
t.aa_(7)

y = Test(t);
y.value;

t = Tee(3,4);
SP.init(t);
e = SP([3]);
r = SP([4]);
e.lib.value;
r.lib.value;
t.aa_(8);
t.currentEnvironment
Tee.currentEnvironment

Object.currentEnvironment
currentEnvironment.push
Environment.stack.removeAt(1);
Environment.stack[1]=nil;
Environment.stack;
Node.setLibrary(Tee(3,4));
Node.getLibrary;


v = s.get(\len,{|val| ^val});
v
d = NP(s,\hoi,10,20);
w = NP(s,\hoi,14,20);
w.synthKey.set(\len,3);
d.synthKey.get(\len,_.postln);
t = Tee(3,4);
l = LangTarget(t,\aa_,3,4);
l.value(10);
t.perform(\aa_,4)
t
a = [1,2,3];a.isArray;

c = CCAbstractTarget(a,\len,10,14);
c.type==\Other
y.class.superclasses.includes("class Node")
q = y.class.superclasses
q.includes(Node)


p = ClockedIntegrator.new(0.1)
p.next;
p.slope = 0.1;
p.slope;
(
SynthDef("s1",{arg len;
	var env, sound;
	sound = SinOsc.ar();
	env = Env([0, 1, 0],[len, 1]);
	Out.ar(0,sound*EnvGen.kr(env));
}).add;
)
(
y = Synth("s1");
MyMIDI2.classInit;
~m_xone =       MidiInOutPair(MIDIClient.sources.detectIndex { |endpoint| endpoint.name.contains("XONE")},-1);
)
MidiCC(\normal,[~m_xone,0,8],CCAbstractTarget(y,\len,0,1));
MidiCC(\normal,[~m_xone,0,7],CCAbstractTarget(p,\slope_,0,1));
c = CCAbstractTarget(p,\slope,0,1);
c.value(100);
c.type
c.object
p.perform(\slope_,0.5);
o = p.perform(\slope);
o
p.slope

y.get(\len,_.postln);
MyMIDI2.normalCCMappingDictionary
d = MyMIDI2.buttonOnMappingDictionary
d[0][0].midiDevice
MyMIDI2.initialized
MIDIdef.all
\slope.asString++"_".asSymbol

~m_xone.indexIn

//
(
s = Server.local;
s.options.maxLogins_(2);
s.options.inDevice_("MME : Microphone (Realtek(R) Audio)");
s.options.outDevice_("MME : Speakers (Realtek(R) Audio)");
s.options.numInputBusChannels_(2);
s.options.numOutputBusChannels_(2);
s.boot;
)

(
SynthDef("channel_mixer", {arg input_bus, send_1_volume, send_2_volume, send_3_volume, send_3side_volume,  que, cross_fader_selectorL = 0, cross_fader_selectorR = 0; var fader_volume,channel_output;
    fader_volume = ServerControl.kr(\faderVolume,0);
    Out.ar(~b_send_1,     In.ar(input_bus,2) * VolumeFaderCurve.kr(send_1_volume));
    Out.ar(~b_send_2,     In.ar(input_bus,2) * VolumeFaderCurve.kr(send_2_volume));
    Out.ar(~b_send_3,     In.ar(input_bus,2) * VolumeFaderCurve.kr(send_3_volume));
    Out.ar(~b_send_3side, In.ar(input_bus,2) * VolumeFaderCurve.kr(send_3side_volume));
    channel_output = In.ar(input_bus,2) * VolumeFaderCurve.kr(fader_volume);
    Out.ar(~b_cross_L,channel_output*cross_fader_selectorL);
    Out.ar(~b_cross_R,channel_output*cross_fader_selectorR);
    Out.ar(~b_cross_bypass,channel_output*(1-cross_fader_selectorL)*(1-cross_fader_selectorR));
    Out.ar(~b_out_heads, In.ar(input_bus,2)*que);
}).add;
)

MyMIDI2.classInit;
MyMIDI2.resetLibraries
~m_xone =       MidiInOutPair(MIDIClient.sources.detectIndex { |endpoint| endpoint.name.contains("XONE")},-1);

q = Synth("channel_mixer",[\input_bus, ~b_deck_1]);

MidiButton([~m_xone,11,8],PushButtonNodeTarget(q,\cross_fader_selectorL));
MidiButton([~m_xone,11,9],PushButtonNodeTarget(q,\cross_fader_selectorR));

MidiCC(\normal,[~m_xone,0,8],CCAbstractTarget(q,\faderVolume,0,1));


q.getn(\faderVolume,3,_.postln);
p = PushButtonNodeTarget(q,\cross_fader_selectorR);
p.off;
p.on;

Bus(100).get({|val| val.postln})
Bus.new(rate: 'control', index: 3, numChannels: 2).get({|val| (3*val[0]+val[1]+5).postln})
l = LangControl.new;
l.parameterValue_(3);
l.value

MidiCC(\normal,[~m_xone,0,8],CCAbstractTarget(l,\parameterValue,0,1));

c = CCAbstractTarget(l,\parameterValue,0,1)
c.key
~key = \parameterValue;
n = (~key.asString++"_").asSymbol;
~key.class;
n.class;
l.perform(n,10)

~plcLibrary = Array.fill(400);
~plcLibrary[10]=100
l = nil;
l.isNil
u = FunctionList.new(~plcLibrary)
u.array = [nil];
u.array

//plc functionality
(
~fl_plc = FunctionList.new; // all functions in this list will be evaluated at each cycly of the plc
~fl_plcMacro = FunctionList.new; // here all the mapping from server to language takes place
~c_plc = TempoClock.new(1000);// set plc rate in Hz
~r_plc = Routine{
	inf.do{ |i|
	~c_plc.timeToNextBeat.wait; //wait till next cyle start
	~fl_plc.value;      //run all functions
	~fl_plcMacro.value;
	0.1.wait;       //should be lower then cycle length, is required in order to make sure not two cycles are computed directly after each other
	};
};
~r_plc.play(~c_plc,quant:1); // schedule the routine on the clock
)

MyMIDI2.classInit(~fl_plcMacro);
~m_xone =       MidiInOutPair(MIDIClient.sources.detectIndex { |endpoint| endpoint.name.contains("XONE")},-1);
~m_xone.indexIn
//macros
(
SynthDef("macro_LFO",{arg bus;
	var output, amplitude;
	amplitude = \amplitude.kr(0);
	output = SinOsc.kr(\freq.kr(0.1), 0, amplitude/2, amplitude/2 );
	Out.kr(bus,[\crossfade.kr(-1),output]);
}).add;
)

~sy = Synth("macro_LFO",[\bus, ~b_macro_1])
MidiCC(\macro,[~m_xone,0,4],CCAbstractTarget(~sy,\amplitude,0,1));
~sy.get(\amplitude,_.postln)

MyMIDI2.macroToggle_(0);
MyMIDI2.macroToggle
MyMIDI2.initialized
MidiButton([~m_xone, 0, 60],{MyMIDI2.macroToggle_(1)},{MyMIDI2.macroToggle_(0);MyMIDI2.resetMacroBus});// butt

{~isDual.hoi}.try({~isDual=0});
~isDual

t = \hoi;
o = [\hoi, \doei];
o.includes(t).not;
"% is not a valid mode".format(t);
a = Array.fill(*[2,3])

//
(
s = Server.local;
s.options.maxLogins_(2);
s.options.inDevice_("MME : Microphone (Realtek(R) Audio)");
s.options.outDevice_("MME : Speakers (Realtek(R) Audio)");
s.options.numInputBusChannels_(2);
s.options.numOutputBusChannels_(2);
s.boot;
)


(
~b_deck_1 = Bus.audio(s,2);
~b_deck_2 = Bus.audio(s,2);
~b_deck_3 = Bus.audio(s,2);
~b_deck_4 = Bus.audio(s,2);
~b_preview = Bus.audio(s,2);
~b_send_1 = Bus.audio(s,2);
~b_send_2 = Bus.audio(s,2);
~b_send_3 = Bus.audio(s,2);
~b_send_3side = Bus.audio(s,2);
~b_cross_L = Bus.audio(s,2);
~b_cross_R = Bus.audio(s,2);
~b_cross_bypass = Bus.audio(s,2);
~b_out_main = Bus.audio(s,2);
~b_out_heads = Bus.audio(s,2);

//control busses
~b_macro_1 = Bus.control(s,2);
~b_macro_1.set(-1,1);
)

(
~fl_plc = FunctionList.new; // all functions in this list will be evaluated at each cycly of the plc
~fl_plcMacro = FunctionList.new; // here all the mapping from server to language takes place
~c_plc = TempoClock.new(1);// set plc rate in Hz
~r_plc = Routine{
	inf.do{ |i|
	~c_plc.timeToNextBeat.wait; //wait till next cyle start
	~fl_plc.value;      //run all functions
	~fl_plcMacro.value;
	0.1.wait;       //should be lower then cycle length, is required in order to make sure not two cycles are computed directly after each other
	};
};
~r_plc.play(~c_plc,quant:1); // schedule the routine on the clock
)

~c_plc.tempo_(2)

l = LangControl();
l.value;
l.val = 2;

MyMIDI2.classInit();
~m_xone = MidiInOutPair("XONE","XONE");
~midiOut = MIDIOut(~m_xone.indexOut);

c = CCAbstractTarget(l,\val,mode: \relative, sensitivity:1/128/2);
m = MidiCC(\normal,[~m_xone,0,8],c);
c.sensitivity
c.value(127);
u = UpdateMidiCC([~m_xone,0,8].asMidiSource,CCAbstractTarget(l,\val,sensitivity:1/128/2));
u.value
f = {u.value};
~fl_plc.addFunc(f);
~fl_plc.array
u.prepareMessage;
u.target.object.val

(
SynthDef("channel_mixer", {arg input_bus, send_1_volume, send_2_volume, send_3_volume, send_3side_volume,  que, cross_fader_selectorL = 0, cross_fader_selectorR = 0; var fader_volume,channel_output;
    fader_volume = ServerControl.kr(\faderVolume,0);
    Out.ar(~b_send_1,     In.ar(input_bus,2) * VolumeFaderCurve.kr(send_1_volume));
    Out.ar(~b_send_2,     In.ar(input_bus,2) * VolumeFaderCurve.kr(send_2_volume));
    Out.ar(~b_send_3,     In.ar(input_bus,2) * VolumeFaderCurve.kr(send_3_volume));
    Out.ar(~b_send_3side, In.ar(input_bus,2) * VolumeFaderCurve.kr(send_3side_volume));
    channel_output = In.ar(input_bus,2) * VolumeFaderCurve.kr(fader_volume);
    Out.ar(~b_cross_L,channel_output*cross_fader_selectorL);
    Out.ar(~b_cross_R,channel_output*cross_fader_selectorR);
    Out.ar(~b_cross_bypass,channel_output*(1-cross_fader_selectorL)*(1-cross_fader_selectorR));
    Out.ar(~b_out_heads, In.ar(input_bus,2)*que);
}).add;
)
q = Synth("channel_mixer",[\input_bus, ~b_deck_1]);
w = Synth("channel_mixer",[\input_bus, ~b_deck_1]);
q.getn(\faderVolume,2,_.postln)
q.set
q.setControlBus(\faderVolume,1);

v =CCAbstractTarget(q,\faderVolume,\relative,sensitivity:1/128/2)
MidiCC(\normal,[~m_xone,0,7],v)
MyMIDI2.resetLibraries

b = UpdateMidiCC([~m_xone,0,7].asMidiSource,v);
b.value
n = {b.value};
~fl_plc.addFunc(n);
b.prepareMessage
v.currentOutputValue
v.macroBus
v.parameterBus
v.type
v.basicValue(1);
v.currentParameterValue
v.type==\Node
v.object
v.key
v.object.get(v.key,{|val| ~currentValueVar = val});
~currentValueVar
q.get(\faderVolume,_.postln);
(
        var currentValueVar;
        if(v.type==\Node){
            v.object.get(v.key,{|val| currentValueVar = val; val.postln});
	 currentValueVar.postln;
        }{
            currentValueVar = v.object.perform(v.keyGetter); // for other Objects
        };
        currentValueVar.postln;
)
//
MyMIDI2.normalCCMappingDictionary
MyMIDI2.resetLibraries;
MidiCC(\normal,[~m_xone,0,8],{|val| val.postln});
MIDIClient.sources

MIDIClient.init
MIDIClient.initialized
MIDIIn.connectAll
MIDIOut.disconnect

(
       MIDIClient.initialized.not.if{MIDIClient.init()};
        MIDIIn.connectAll;
MIDIdef.cc(\main2, {arg ...args; args.postln});
)
j = ~b_macro_1.getSynchronous
~b_macro_1.index
~b_macro_1.numChannels
p = Bus(~b_macro_1.index);
p.getnSynchronous(2)
d.isNil.if({Bus.control(numChannels:2)});

//
MyMIDI2.normalCCMappingDictionary

//macros
(
SynthDef("macro_LFO",{arg bus;
	var output, amplitude;
	amplitude = \amplitude.kr(0);
	output = SinOsc.kr(\freq.kr(0.1), 0, amplitude/2, amplitude/2 );
	Out.kr(bus,[\crossfade.kr(-1),output]);
}).add;
)
m = Synth("macro_LFO",[\bus, ~b_macro_1]); //create a synth which we can call by key, where the key is stored in the library ~synthDictionary
~b_macro_1.index
MyMIDI2.b_dummy
MidiCC(\macro,[~m_xone,0,1],CCAbstractTarget(m,\amplitude,\relative,sensitivity:1/128/2));
MyMIDI2.macroBus
MyMIDI2.macroToggle
MyMIDI2.normalCCMappingDictionary[1].[1].parameterBus.numChannels
0.0.asInteger
MidiButton([~m_xone, 0, 60],{MyMIDI2.macroToggle_(1)},{MyMIDI2.macroToggle_(0);MyMIDI2.resetMacroBus});// butt