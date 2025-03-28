q = Array.series(100,0,1);
w = Array.fill(100, {1.0.rand2});
m = [q,w];
m = m.lace;
b = Buffer.alloc(s,100,2);
b.sendCollection(m);
b.loadToFloatArray(action: { arg array; a = array; { a.plot }.defer; "done".postln });
r = a.unlace(2)
for(0,a.size/2-1){|i| a[[2*i, 2*i+1]].postln}
	a[[2,3]].postln
	a

(
b = Server.default.makeBundle(false, {
    synth = Synth.newPaused(\timeTraceAr, [\busIndex, bus.index, \bufnum, buffer.bufnum], addAction: 'addToTail');
});
)
(

)
(
z = SynthDef("zpulse", { arg out=0,freq=700,sawFreq=440.0;
    Out.ar(out, SyncSaw.ar(freq,  sawFreq,0.1) )
});
s.makeBundle(nil, {
	z.send(s);
	s.sync;
    x = Synth.new("zpulse");
    a = Bus.control.set(440);
    x.map(\freq, a);
});
)