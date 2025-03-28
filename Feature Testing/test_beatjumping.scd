(
MIDIClient.init;
~m_traktor = MIDIClient.destinations.detectIndex { |endpoint| endpoint.name.contains("loopMIDI Port 3")};
~m_launchpad = MidiInOutPair(MIDIClient.sources.detectIndex { |endpoint| endpoint.name.contains("MIDIIN2 (LPMiniMK3 MIDI)")},MIDIClient.destinations.detectIndex { |endpoint| endpoint.name.contains("MIDIOUT2 (LPMiniMK3 MIDI)")});
m = MIDIOut(~m_traktor);
)

x = Pseq([1],inf);

Event.eventTypes;
(
p = Pbind(
    \type, \midi,
        // this line is optional b/c noteOn is the default
        // just making it explicit here
    \midicmd, \noteOn,
    \midiout, m,    // must provide the MIDI target here
    \chan, 0,
        // degree is converted to midinote, not just frequency
	\midinote, 67,
    \sustain, 0.01,
    \amp, 1
)
)

q= p.play(quant: 1);
//control: #{ arg chan=0, ctlNum, control=125;
q.stop;
p.class;

ButtonPatternWithFeedbackMIDISocket(~m_launchpad.channel_(0),p,65);

(
s = Server.local;
s.options.maxLogins_(2);
s.options.inDevice_("ASIO : JackRouter");
s.options.outDevice_("ASIO : JackRouter");
s.options.numInputBusChannels_(10);
s.options.numOutputBusChannels_(4);
)
s.boot;
c.numPeers;
~c16th = TempoClock.new(c.tempo, 0, 0);

(
~syncClock = {
~c16th.tempo = c.tempo*4;
c.play({~c16th.beats = 0})
}
)
//syncing the clocks
(
var controller;
controller = SimpleController(c);
controller.put(\tempo, ~syncClock);
)

~c16th.tempo;
c.tempo;

(
c.play{
c.beats.postln;
~c16th.beats.postln;
}
)

~syncClock.value;

ButtonPatternWithFeedbackMIDISocket(~m_launchpad.channel_(0),~p_16thbeatjump,65);
(
~p_16thbeatjump = Pbind(
    \type, \midi,
        // this line is optional b/c noteOn is the default
        // just making it explicit here
    \midicmd, \noteOn,
    \midiout, ~m_traktor,    // must provide the MIDI target here
    \chan, 0,
        // degree is converted to midinote, not just frequency
	\midinote, 67,
    \sustain, 0.9,
    \amp, 1
);
)
ButtonPatternWithFeedbackMIDISocket(~m_launchpad.channel_(0),~p_16thbeatjump,66);


// investigating button not lighting
MIDIClient.restart;
MIDIClient.init;
n = MIDIOut(MIDIClient.destinations.detectIndex { |endpoint| endpoint.name.contains("loopMIDI Port 4")});
m = MIDIOut(MIDIClient.destinations.detectIndex { |endpoint| endpoint.name.contains("MIDIOUT2 (LPMiniMK3 MIDI)")});
u = ButtonPatternWithFeedbackMIDISocket(~m_launchpad.channel_(0),~p_16thbeatjump,66);
m.noteOn(0,45,17);
m.noteOff(0,45,41);
i = ButtonPushWithFeedbackMIDISocket(~m_launchpad.channel_(0),{arg value; value.postln},66);
