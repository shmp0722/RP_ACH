function RunCtrSH


%%
[dMRI, List, AMD, AMD_Ctl, RP, Ctl] = SubJect;

%%
for kk = AMD(2:8);
    Shdir = fullfile(dMRI,List{kk},'dwi_1st/fibers/conTrack/OR_divided');
    cd(Shdir)
    %%
    SH  = dir('*.sh');
    
    if ~isempty(SH);
        parfor ii = 1:length(SH)
            cmd = sprintf('./%s',SH(ii).name);
            system(cmd)
        end
    end
end

%
%     % Helper function: throw an error if the system call doesn't work as
% % expected:
%     function [status, result] = syscall(cmd_str)
%         % Allow for noops:
%         if strcmp(cmd_str, '')
%             return
%         end
%         fprintf('[%s]: Executing "%s" \n', mfilename, cmd_str);
%         [status, result] = system(cmd_str);
%         if status~=0
%             error(result);
%         end
%     end
%
%
%