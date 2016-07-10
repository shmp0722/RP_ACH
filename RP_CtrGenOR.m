function RP_CtrGenOR(nums)

% Generate optic radiation and optic tract with conTrack
%
% SO@ACH 2015

%% Take subject names
% [dMRI, List] = SubJect;
[dMRI, List, AMD, AMD_Ctl, RP, Ctl] = SubJect;

% nums = [23:24, 34:43]; 
% pick up your interesting subject
if notDefined('nums'),
    sprintf('Subject is not selected')
    return
end

% pick up members
for ii = nums
    Subs{ii} = List{ii};
    
    % copy LGN roi from ROIs to fs_Retinotopy2 folder   
    source1   = sprintf('%s%s',fullfile(dMRI,Subs{ii},'ROIs'),'/Lt-LGN4.mat');
    destination1 = sprintf('%s%s',fullfile(dMRI,Subs{ii},'/fs_Retinotopy2'),'/Lt-LGN4.mat'); 
    
    source2   = sprintf('%s%s',fullfile(dMRI,Subs{ii},'ROIs'),'/Rt-LGN4.mat');
    destination2 = sprintf('%s%s',fullfile(dMRI,Subs{ii},'/fs_Retinotopy2'),'/Rt-LGN4.mat'); 
    
    if ~exist(destination1);
      copyfile(source1, destination1);
    end
    
    if ~exist(destination2);
      copyfile(source2, destination2);
    end
end

%% Optic Radiation
% Set Params for contrack fiber generation

% Create params structure
ctrParams = ctrInitBatchParams;

% params
ctrParams.projectName = 'OR_divided';
ctrParams.logName = 'myConTrackLog';
ctrParams.baseDir = dMRI;
ctrParams.dtDir = 'dwi_1st';
ctrParams.roiDir = '/fs_Retinotopy2';

% pick up subjects
ctrParams.subs = Subs;

% set parameter
ctrParams.roi1 = {'Lt-LGN4','Lt-LGN4','Lt-LGN4','Rt-LGN4','Rt-LGN4','Rt-LGN4'};
ctrParams.roi2 = {'lh_Ecc0to3','lh_Ecc15to30','lh_Ecc30to90','rh_Ecc0to3','rh_Ecc15to30','rh_Ecc30to90'};

% ctrParams.roi1 = {'Rt-LGN4'};
% ctrParams.roi2 = {'rh_Ecc30to90'};

ctrParams.nSamples = 20000;
ctrParams.maxNodes = 200;
ctrParams.minNodes = 50; % defalt: 10
ctrParams.stepSize = 1;
ctrParams.pddpdfFlag = 0;
ctrParams.wmFlag = 0;
ctrParams.oi1SeedFlag = 'true';
ctrParams.oi2SeedFlag = 'true';
ctrParams.multiThread = 0;
ctrParams.xecuteSh = 0;


%% Generate OR usinig Sherbondy's contrack
[cmd, ~] = ctrInitBatchTrack(ctrParams);
system(cmd);
clear ctrParams

end
