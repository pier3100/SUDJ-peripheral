t = TempoCLock; // LinkClock.new gives comparable results
o = Bus.control;
(
SynthDef("test",{
	var out;
	out = Sweep.kr();
	Out.kr(o,out);
}).play
)

~old = 0;

(// see if there is a whole number of blocksize between last two synchronous reads, for different assumed buffersizes
var new, ar;
new = o.getSynchronous;
ar = [(new - ~old)/(64/s.sampleRate),(new - ~old)/(128/s.sampleRate),(new - ~old)/(256/s.sampleRate),(new - ~old)/(512/s.sampleRate)];
~old = new;
ar;
)


d = o.getSynchronous - t.beats; // offset
(o.getSynchronous - t.beats - d) * 1000; // difference between TempoClock and synth Sweep in ms

1000/s.sampleRate*s.options.blockSize; // blocksize in ms

// so error between language and server is a factor 5 higher than the blockSize

// reference on the forum
// https://scsynth.org/t/imperfection-of-language-based-timing/350/10

s.options.hardwareBufferSize

s.boot;

(
fork {
	var cond = CondVar.new;
	var start;
	var replyCount = 0;
	var num = 5;
	var resp;

	b = Bus.control(s, 1);
	a = { Sweep.kr(0, 1) }.play(outbus: b);

	// ensure the synth is running
	OSCFunc({
		cond.signalAll
	}, '/n_go', s.addr, argTemplate: [a.nodeID]).oneShot;
	cond.wait;

	start = thisThread.beats;

	z = Array(num);

	// keeping the async replies lined up with the array is tricky
	// this is basically queuing the replies up
	resp = OSCFunc({ |msg|
		z[replyCount][1] = msg[2];
		replyCount = replyCount + 1;
		cond.signalAll;
	}, '/c_set', s.addr, argTemplate: [b.index]);

	fork {
		num.do {
			z = z.add([
				thisThread.beats - start + s.latency,
				nil,
				b.getSynchronous + s.latency
			]);

			s.makeBundle(s.latency, { b.get { nil } });

			0.1.wait;
		};
	};

	cond.wait { replyCount >= num };

	a.free; b.free; resp.free;

	z.do(_.postln);
	"".postln;
	z.flop.collect(_.differentiate).do(_.postln);
};
)

[0.2, 0.18140590190887, 0.22321995422244]
[0.3, 0.28154194355011, 0.31609977483749]
[0.4, 0.38167801499367, 0.40897959172726]
[0.5, 0.4818140566349, 0.50185940861702]
[0.6, 0.58195012807846, 0.61795918345451]

[0.2, 0.1, 0.1, 0.1, 0.1]
[0.18140590190887, 0.10013604164124, 0.10013607144356, 0.10013604164124, 0.10013607144356]
[0.22321995422244, 0.092879820615053, 0.092879816889763, 0.092879816889763, 0.11609977483749]