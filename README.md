# ephys_kilosort
Modification of kilosort based on SKM code. (Thank you!)

INSATALLATION:
See kilosort github for detailed installation instruction. It's a real pain to install everything, but worth it.

TO RUN: 
1. makeChanMap_SKM.m to make channel map file for any NEW PROBE configuration
2. record data using Intan; save data in Channel Format (one file per channel); save using xxx_ephys in name.
3. run mergeIntanOFPCSystem2(savePath); this will create a single data file efficiently conbining all data in kilosort format;
4. change paths in runKiloSort4Intan2 (if necessaryl ie created new channel map config or changed location of data)
5. run runKiloSort4Intan2

