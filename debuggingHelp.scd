//
//use .yield inside a routine to pause the routine, for me everything runs inside the main routine


// SUDJ: deck
~libraryConsole.activePlaylist.asArray
~libraryConsole.nextTrack_;
~libraryConsole.count;
t = ~libraryConsole.activeTrackArrayFiltered[~libraryConsole.count];
t.isOpen
t.loadBuffer
p = t.path
p.class
p.postln
t.openRead
~prelistenDeck.loadTrack(~libraryConsole.activeTrackArrayFiltered[~libraryConsole.count])
~deck1.loadAndPlayDouble(~prelistenDeck);
~deck1.beatJump(-8);
~deck1.playerSelected
~deck1.track.duration*~deck1.track.bpm/60
~deck1.clock.beats
~deck1.clock.beats_(460)
~deck1.endOfTrackEvent
~deck1.buffer;
~prelistenDeck.buffer;


//general
m = nil; //to free a variable
Synth.browse; //to browse a class
"Hello World!".postln;
Platform.userExtensionDir;
MethodOverride.printAll;

//server
(
s = Server.local;
s.options.maxLogins_(2);
s.options.inDevice_("ASIO : JackRouter");
s.options.outDevice_("ASIO : JackRouter");
s.options.memSize_(8192*(2**2));
s.options.numInputBusChannels_(10);
s.options.numOutputBusChannels_(8);
s.boot;
)

(
s = Server.local;
s.options.maxLogins_(2);
s.options.inDevice_("MME : Microphone (Realtek(R) Audio)");
s.options.outDevice_("MME : Speakers (Realtek(R) Audio)");
s.options.numInputBusChannels_(10);
s.options.numOutputBusChannels_(8);
s.boot;
)
s.plotTree; // show node tree
s.defaultGroup.freeAll;
Server.killAll;
Server.default.options.numInputBusChannels;
Server.default.options.maxLogins;
Server.all;
Server.allBootedServers;
s.serverRunning;
Server.default.reboot;
s.quit;
s.serverRunning;
s.status;
s.ping(n: 1, wait: 0.1, func: {"hoi".postln});
s.unresponsive;
s.volume;
s.options;
s.options.outDevice;
ServerOptions.devices;
Server.default.options.numInputBusChannels;

//synth dictionary
~sD = IdentityDictionary.new;
Synth("mainSynth").key(\mainSynth);

//scoping and inspecting
~bOutMain.scope;
~bDeck3.scope;
~bDeck1.scope;
~bCrossL.scope;
~bPreview.scope;
~b_send_3side.scope;
~bScopeAudio.index;
~deck1.synth.trace;
~deck1.synth.set(\scopeBusKr,~bScopeKr.index);
~deck1.synth.set(\scopeBusAr,~bScopeAr.index);
~timeTrace = TimeTrace.new(~bScopeAr, "C:/Users/piert/MakingMusic/SuperCollider/Data Analysis", 10);
~timeTrace.stop;
~timeTrace.start;
~timeTrace.buffer.plot;
~timeTrace.buffer.plot(minval:0,maxval:100);
~timeTrace.synth.trace;
~timeTrace.buffer.bufnum;
~timeTrace.export("C:/Users/piert/MakingMusic/SuperCollider/Data Analysis/data.csv");
~deck1.buffer.plot
~bScopeAudio.scope;
~bScopeAudio.getn(10, {|val| ("val = "+val).postln});
~b_send_3side.trace;
~sChannel3.trace;
~foa1.trace
Stethoscope.new(s,3,54);
ServerMeter.new(s,0,8);
~bDeck3.index
~bPreview.index
~bOutHeads.index
~bOutHeads.scope

//synth and synthdef
~s_mixer.get(\cross_fader,{|value| value.postln});
~sD[\s_channel_1].get(\faderVolume,{|val| val.postln});
~s_channel_1.get(\cross_fader_selectorR,{|value| value.postln});
~s_channel_1.get(\send_3_volume,{|value| value.postln});

//quarks and extensions
Quarks.install("dewdrop_lib")
Quarks.gui;

//recording
r.record(bus: ~b_out_main);
r.stopRecording;
r.isRecording;

//midi
MIDIPort.removeAt(\omni);
MIDIPort.resetAll;
MIDIClient.init;
MIDIClient.sources;
MIDIIn.connectAll;
m.normalMappingDictionary;
MIDIdef.all;
m.addNormal([MS(~m_xone,11,28),SP(\s_channel_4,\faderVolume),{|val| val.linlin(0,127,0,1)}]);
MIDIIn.connectAll;
MIDIdef.cc(\main2, {arg ...args; args.postln}).permanent = true;
MIDIdef.noteOn(\main3, {arg ...args; args.postln});
MIDIdef.noteOff(\main4, {arg ...args; args.postln});
MIDIdef.all;
MIDIdef.freeAll;
MIDIdef(\main4).free
MyMIDI2.classInit;
MyMIDI2.resetLibraries;
MyMIDI2.normalCCMappingDictionary;
MyMIDI2.plc.clock.isRunning;
MyMIDI2.normalCCMappingDictionary[4].[1].parameterBus.getSynchronous
MyMIDI2.plc.funcList1.array;
MyMIDI2.plc.funcList1.array[1].value;
MyMIDI2.plc.clock.play(MyMIDI2.plc.routine,quant:1);
MidiHidSystem.resetAllLibraries;
MidiSystem.plc
MidiHidSystem.enabled_(false);
m = MidiCC([~mXone, 11, 3], ServerTarget(~sChannel1,\faderVolume), mode:\absolute);
MidiHidSystem.post
MidiHidSystem.remove(91)

//clock
c.tempo;
c.numPeers;