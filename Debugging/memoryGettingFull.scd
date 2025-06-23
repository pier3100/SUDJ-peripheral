b = Bus.control;
b = Bus.audio;
b.index;
b.free;
a = 5
d = 7
b = Buffer.alloc(s,100);
b.addDependant(a)
c.addDependant(d);
c.removeDependant(a)
b.dependants
c.dependants.at(0)==a
b.free;
r = ~prelistenDeck.buffer;
a.bufnum
~prelistenDeck.buffer.bufnum

(
for(0,4){|i|
	~libraryConsole.bufferArray[i].bufnum.postln;
};
)

~deck1.buffer.bufnum;
~deck3.buffer.bufnum

~libraryConsole.bufferArray[0]
~deck3.buffer = ~prelistenDeck.buffer;

~prelistenDeck.buffer.bufnum
~deck1.buffer
~deck3.synth.get(\bufnum,{|b| b.postln})