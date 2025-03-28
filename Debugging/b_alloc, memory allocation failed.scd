~drumMachine.bufferArray.bufferArray[3].plot
b = ~drumMachine.bufferArray.bufferArray[3];
b.plot;
c = Buffer.alloc(s,10,2);
b.copyData(c,0,0,-1);
c.plot;

// solved; made sure the getn methods in Buffer.copyTrimmed get frames multiplied with numChannels, to account for interleaved multiChannel data