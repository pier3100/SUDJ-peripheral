b = Buffer.read(s, "C:/Users/piert/MakingMusic/Samples/leaves-crunching-6954-bounce-2.wav");

(
SynthDef("wind",{arg buf, rate = 1, pos = 0, pan = 0;
	var env,out,bufLength;
	bufLength = BufDur.kr(buf);
	out = PlayBuf.ar(2,buf,rate, startPos: bufLength.rand);
	env = Env(levels: [0,1,0],times: [0.1,0.1]);
	Out.ar(0,Pan2.ar(out,pan)*EnvGen.ar(env, doneAction: Done.freeSelf));
}).add;
)

n = 0.01;
n = 0.03;
n = 0.05;
n = 0.07;

Stethoscope.new();

(
t = {var rate = 0.1;
	rate = rate+0.2.rand;
}
)
o = Object;
o.



(
f = {var rate;

	Synth("wind",[\buf,b ,\rate, 1+1.0.rand, \pos, 0, \pan, 2.0.rand -1]);
	n.asFloat.rand;
}
)

d = Dictionary.newFrom([\hello, 9, \whello, "world"]);
d.getPairs;
[hello, 9, \whello, "world"]

(
c = TempoClock.new();
c.sched(1,f);
)