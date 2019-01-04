function saveKiloSortResultstoMat

%% Choose the directory containing npy files from KiloSort
expDir = uigetdir('E:\Documents\DATA','Select directory with KiloSort results');

%% Read in parameters
rez = load([expDir '\rez.mat']);
params = rez.rez.ops;

%% Read spike_times.npy
spike_times = double(readNPY([expDir '\spike_times.npy'])); % samples  %%% in npy-matlab folder
spike_times_smp = spike_times;
% Convert to ms using samping rate
spike_times = spike_times/params.fs*1e3;

%% Read spike_clusters.npy
spike_clusters = double(readNPY([expDir '\spike_clusters.npy'])); % for each spike a number is assigned for cluster id

%% Combine cluster identity and time
% identity in the first column, time (ms) in the second, rows are spikes
cluster_class = [spike_clusters spike_times];

%% Read cluster_groups (attributes of clusters) noise;good; bad unit; colume: cluster id; 
formatSpec = '%f%C';
T = readtable([expDir '\cluster_groups.csv'],'Format',formatSpec);
% determine all the noise clusters
noiseID = T.cluster_id(T.group=='noise',:);
% delete noise from cluster_class
if ~isempty(noiseID)
    for i=1:length(noiseID)
        noiseRows = noiseID(i)*ones(size(cluster_class,1),1);
        theseRows = cluster_class(:,1)~=noiseRows;
        cluster_class = cluster_class(theseRows,:);
        spike_times_smp = spike_times_smp(theseRows,:);
    end
end
% determine all the single units, and send all the rest to MUA, cluster 0 (for MUA)  
goodID = T.cluster_id(T.group=='good',:);
% update all the IDs to greater than MAX  % make the good clusters to have
% id 1 to max good clusters.
goodRows = false(size(cluster_class,1),1);
if ~isempty(goodID)
    for i=1:length(goodID)
        goodRows = goodRows | cluster_class(:,1)==goodID(i);
    end
end
originalID = cluster_class(:,1);
maxID = max(cluster_class(:,1));
cluster_class(goodRows,1) = cluster_class(goodRows,1)+maxID+1;
cluster_class(cluster_class(:,1)<=maxID,1) = 0;
[~,~,ic] = unique(cluster_class(:,1));
cluster_class(:,1) = ic-1;

%% For every spike in cluster_class, take out spike shape in every channel
% load raw file
finfo = dir(params.fbinary);
nSamp = finfo.bytes/2;
% mmf = memmapfile(params.fbinary, 'Format', {'int16', [params.NchanTOT nSamp/params.NchanTOT], 'x'},'Writable',false);
% 
% numSpikes = size(spike_times_smp,1);
% spikes2=zeros(numSpikes,params.fs/1e3*4+1,params.NchanTOT);
% for ii=1:numSpikes
%     spiketime = spike_times_sub(ii); % samples
%     wf = double(mmf.Data.x(:,spiketime-params.fs/1e3*2:spiketime+params.fs/1e3*2)); % +-2ms around the spike
%     wf = permute(reshape(wf',[params.fs/1e3*4+1 1 params.NchanTOT]),[2 1 3]);
%     spikes2(ii,:,:) = wf;
% end

% saveSpikeWF(expDir,params,spike_times_smp);
%% Get median spike shape for each cluster % need codes from Saturo 
clusWFs = extractMedianWFs(cluster_class(:,1), cluster_class(:,2)/1e3, params.fs, params.fbinary, 'int16', [params.NchanTOT nSamp/params.NchanTOT], params.chanMap-1, 0.195); % gain of intan
clusWFs = permute(clusWFs,[1 3 2]); % channels, clusters, times
%% save file
chanMap = params.chanMap;
fname = [expDir '\times_polytrodeAll.mat'];
% save(fname, 'cluster_class','spikes2','chanMap');
save(fname,'cluster_class','clusWFs','originalID');
% save(fname,'cluster_class','originalID');