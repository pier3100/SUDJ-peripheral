//test_sync_rev1

(//server
s = Server.local;
s.options.maxLogins_(2);
s.options.inDevice_("ASIO : JackRouter");
s.options.outDevice_("ASIO : JackRouter");
s.options.numInputBusChannels_(2);
s.options.numOutputBusChannels_(2);
s.boot;
)

(//clock
c = LinkClock.new.latency_(s.latency);
c.latency_(s.latency+0.000);//adjust latter value such that it aligns with Traktor
c.numPeers;
)

//buffer
b = Buffer.read(s, "C:/Users/piert/AppData/Local/Bitwig Studio/installed-packages/5.0/Bitwig/Classic Drum Machines/ASM/Clap ASM 01 A.wav");

(//synth
x = SynthDef(\clap, { arg out = 0, bufnum = 0;
	var playBuf = PlayBuf.ar(2, b, BufRateScale.kr(bufnum));
	FreeSelfWhenDone.kr(playBuf);
    Out.ar( out,playBuf);
}).add;
)

(//define pattern
p = Pdef(\rhythm,
	Pbind(
		\instrument, \clap,
		\amp, Pseq([1], inf)//this creates an infinite pattern
	)
)
)

p.play(c,quant:4);//play the pattern

//patterns
p.stop;
p.free;
p=nil;
p;
Pdef.removeAll;

//slider
Window.closeAll;

//server
s.freeAll;
s.quit;
s.plotTree;
Server.killAll;
s.latency;
s.latency = 0.4;

//history
r.play(quant: c.beats + 1.0);.
r.free;
x.free;
x.play;

//clock
60*c.tempo;
c.beats;
c.latency;
c.permanent_(true);
c.play({x.play});
c.free;
c.stop; //use to stop the TempoClock (peer will disappear from other Link partners)
c = nil;
TempoClock.all.stop; //run multiple times to delete all clocks you have lost track off

//scheduling
(
~postinfo = { c.beats.postln; 1;};
c.schedAbs(c.nextBar,{~postinfo.() });
)
~postinfo = {"test".postln; 1;};
~postinfo = { c.beats.postln; 1;};

//P

Pseq([1], inf);

Pbind(\freq, Prand([300, 500, 231.2, 399.2], inf), \dur, 0.1).play;

(
r = Routine({
    loop {
		x.play;

    }
});
)
r.free;
