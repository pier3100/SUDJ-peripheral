b = Buffer.read(s, "C:/Users/piert/MakingMusic/Samples/leaves-crunching-6954-bounce-2.wav");
b.numFrames;


(
SynthDef("wind",{arg buf, rate = 1, pos = 0, pan = 0;
	var env,out,bufLength;
	bufLength = BufDur.kr(buf);
	out = PlayBuf.ar(2,buf,rate, startPos: bufLength.rand);
	env = Env(levels: [0,1,0],times: [1,1]);
	Out.ar(0,Pan2.ar(out,pos)*EnvGen.ar(env, doneAction: Done.freeSelf));
}).add;
)

n = 0.1;

(
f = {Synth("wind",[\buf, b, \rate, 1+0.2.rand, \pos, 0, \pan, 2.0.rand -1]);
	n.rand;
}
)

(
c = TempoClock.new();
c.sched(1,f);
)