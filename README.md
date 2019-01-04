# ephys_kilosort
Modification of kilosort based on SKM code. (Thank you!)

INSATALLATION:
See kilosort github for detailed installation instruction. It's a real pain to install everything, but worth it.

    TO RUN: 
1. Use makeChanMap_SKM.m to make channel map file for any NEW PROBE configuration
    - this will create a file will all channel maps for each probe;
    - set path (in makeChanMap_SKM.m) where ChanMap file will store all the different chanMap files;
    - to add new configuration look up all pin maps for your probe, amplifier, and any adaptors used; 
      figure out the order of each microelectrode;
    - create a new probe section by copy and pasting; rename this new section to name of new probe configuration;
    - change the chanMap variable to new map order;
    - change x and y coordinates as required;
    - will also need to modify merfeIntanOFPCSystem3.m; add a section with new probe name in order to select the right file;

2. In runKiloSort4Intan2, set path of: 
    - ChanMap file, kilosort, matlab, npy-matlab and config file
    - location where modified intan data will be stored and location where kilosort generated data will be stored (and used by Phy);

3. Record data using Intan; 
  - save data in Channel Format (one file per channel); 
  - save using xxx_ephys in name;
  - use 30000 as sampling rate;

4. Run runKiloSort4Intan2
    - it will automatically ask you to select your data; select all relevant channels 0-n at once;
    - then it will automatically ask you to select chanMap; 
    - make sure the data channels selected and probe channel num match; 

