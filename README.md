# ephys_kilosort
Modification of kilosort based on SKM code. (Thank you!)

INSATALLATION:
See kilosort github for detailed installation instruction. It's a real pain to install everything, but worth it.

    TO RUN: 
1. makeChanMap_SKM.m to make channel map file for any NEW PROBE configuration
    - this will create a file will all channel maps for each probe;
    - set path (in makeChanMap_SKM.m) where ChanMap file will store all the different chanMap files;
    - to add new configuration look up all pin maps for your probe, amplifier, and any adaptors used; 
      figure out the order of each microelectrode;
    - create a new probe section by copy and pasting; rename this new section to name of new probe configuration;
    - change the chanMap variable to new map order;
    - change x and y coordinates as required;
    - will also need to modify merfeIntanOFPCSystem3.m; add a section with new probe name in order to select the right file;

2. in runKiloSort4Intan2 set path of: 
  2.1 ChanMap file, kilosort, matlab, npy-matlab and config file
  2.2 location where modified intan data will be stored and location where kilosort generated data will be stored (and used by Phy);

3. record data using Intan; 
  2.1 save data in Channel Format (one file per channel); 
  2.2 save using xxx_ephys in name;
  2.3 use 30000 as sampling rate;

4. run runKiloSort4Intan2
  5.1 it will automatically ask you to select your data; select all relevant channels 0-n at once;
  5.2 then it will automatically ask you to select chanMap; 
  5.3 make sure the data channels selected and probe channel num match; 

