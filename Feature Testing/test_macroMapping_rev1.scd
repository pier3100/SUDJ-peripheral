MIDIClient.init;
s.boot;
(
~bk_fallback = Bus.control(s,1);
~bk_1 = Bus.control;
~bk_2 = Bus.control;
~bk_fallback.index;
SynthDef("mainSynth",{
	var env, freq;
	freq = 400+(400*MyCon.kr(\freq,1));
	env = Env([0, 1, 0],[3, 2]);
	Out.ar(0,SinOsc.ar(freq)*EnvGen.kr(env));
	//Out.ar(0,SinOsc.ar(freq)*EnvGen.kr(env, doneAction: Done.freeSelf));
}).add;
)
(
d = Synth("mainSynth");

d.getn(\freq,2,{|val| val.postln});
d.set(\freqq,900);
d.setVal(\freq, 0.5);
d.setBus(\freq,~bk_2);
)


(
// create a key for a synth, in order to be able to refer to the synth without having to store the object itself
// Create an IdentityDictionary
~synthDictionary = IdentityDictionary.new;

// Associate the object with a key in the dictionary
~synthDictionary[\mySynthReference] = d;

// Retrieve the object using the key
~synthDictionary;
//~retrievedSynth = ~objectDictionary[t.synthKey].setVal(t.parameterKey,400);
)





//midi infrastructure
MIDIClient.init;
~m_akai_mpk = MidiInOutPair(MIDIClient.sources.detectIndex { |endpoint| endpoint.name.contains("MPKmini2")},-1);

MIDIdef.freeAll;

MIDIIn.connectAll;
(
MIDIdef.cc(\main1, {arg val, cc, chan, srcID; //this is normal mapping of knob to parameter
	~a.do({arg item, i; // the item of Array a are a tuple, where the zeroth element is an MS (MidiSource) and the first elemenet is a SP (SynthParameter)
		if(item[0].midiChannel == chan && item[0].midiCC == cc && item[0].midiDevice.indexIn == srcID)
		{~synthDictionary[item[1].synthKey].setVal(item[1].parameterKey,val.linlin(0,127,0,1))}
	});
}); // match cc 1
)


MIDIdef.cc(\main2, {arg ...args; args.postln});
MIDIdef.noteOn(\main3, {arg ...args; args.postln});
MIDIdef.noteOff(\main4, {arg ...args; args.postln});
//midi mapping
Array.browse;
a = nil;
a;
(
t = MS(10,0,5);
t.midiChannel;
y = SP(\mySynthReference,\freq);
y.synthKey;

~a = Array.new(400);
a.add([t,y]);
a.size;
a[0][0].midiDevice.indexIn;
~a.add([MS(~m_akai_mpk,0,7),SP(\mySynthReference,\freq)]);
~a;

//setting the macroBus
~b = false; //normally the button for macro mapping is not active
~b = true; //enable macro mapping
~macroBus = 5;

(
MIDIdef.cc(\main1, {arg val, cc, chan, srcID; //this is mapping for Macro
	if(~macroToggle.asBoolean){
		~a.do({arg item, i; // the item of Array a are a tuple, where the zeroth element is an MS (MidiSource) and the first elemenet is a SP (SynthParameter)
			if(item[0].midiChannel == chan && item[0].midiCC == cc && item[0].midiDevice.indexIn == srcID)
			{~objectDictionary[item[1].synthKey].setBus(item[1].parameterKey,~macroBus)}
		});
	};
}); // match cc 1
)


//toggle for Macromapping
~macroToggle = 0;
~macroToggle;
~m_fire = MidiInOutPair(MIDIClient.sources.detectIndex { |endpoint| endpoint.name.contains("FIRE")},MIDIClient.destinations.detectIndex { |endpoint| endpoint.name.contains("FIRE")});
(
ButtonOnOffMIDISocket([~m_fire.indexIn, 0],{~macroToggle = 1},{~macroToggle = 0;
	~macroBus = ~b_dummy.index;
}, 48);
)

//Macro 1
~b_dummy = Bus.control;
~b_macro_1 = Bus.control;
(
SynthDef("macro_1",{arg bus;
	Out.kr(bus,\val.kr(0));
}).add;
)

Synth.key(\macro_4,"macro_1",[\bus, ~b_macro_1]); //create a synth which we can call by key, where the key is stored in the library ~synthDictionary


//array of macro midi maps
~a_macroMIDI = Array.new(400);
~a_macroMIDI.add([MS(~m_fire,0,16),SP(\macro_4,\val)]);
~a_macroMIDI;

//mapping of macro knobs
(
MIDIdef.cc(\main1, {arg val, cc, chan, srcID; //this is normal mapping of knob to parameter
	~a_macroMIDI.do({arg item, i; // the item of Array a are a tuple, where the zeroth element is an MS (MidiSource) and the first elemenet is a SP (SynthParameter)
		if(item[0].midiChannel == chan && item[0].midiCC == cc && item[0].midiDevice.indexIn == srcID)
		{~synthDictionary[item[1].synthKey].setVal(item[1].parameterKey,val.linlin(0,127,0,1))}
	});
}); // match cc 1
)


//detecting that a macro is pressed when toggle is active
~synthDictionary;
~synthDictionary[\macro_4].get(\bus, {|val| val.postln});
~synthDictionary[\macro_3].get(\bus, {|val| ~macroBus = val});
~b_dummy.index;
~b_macro_1.index;
~macroToggle;
~macroBus;
~synthDictionary[\mySynthReference].getn(\freq,2, {|val| val.postln});

(
MIDIdef.cc(\main1, {arg val, cc, chan, srcID; //this is mapping for Macro
	if(~macroToggle.asBoolean){
		~a_macroMIDI.do({arg item, i; // the item of Array a are a tuple, where the zeroth element is an MS (MidiSource) and the first elemenet is a SP (SynthParameter)
			if(item[0].midiChannel == chan && item[0].midiCC == cc && item[0].midiDevice.indexIn == srcID)
			{~synthDictionary[item[1].synthKey].get(\bus, {|val| ~macroBus = val});}
		});
	};
}); // match cc 1
)

//setting the bus of the macro at the sidechain input of the target control
//see earlier