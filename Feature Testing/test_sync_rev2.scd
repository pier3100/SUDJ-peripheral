(
~deck1.info;
c.beats.postln;
~deck1.setAsMaster;
~deck1.info;
c.beats.postln;
)

(
~deck3.info;
c.beats.postln;
~deck3.sync_(true);
~deck3.info;
c.beats.postln;
)

(
~deck1.info;
~deck3.info;
c.beats.postln;
)
~deck1.clock.phaseSync