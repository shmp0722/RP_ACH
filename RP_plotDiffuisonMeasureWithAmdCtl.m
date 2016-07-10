function RP_plotDiffuisonMeasureWithAmdCtl(vals,fibID,SavePath)
% Plot figure 5 showing individual FA value along the core of OR and optic tract.
%
% Repository dependencies
%    VISTASOFT
%    AFQ
%    LHON2
%
% SO Vista lab, 2014
%
% Shumpei Ogawa 2014

%% Identify the directories and subject types in the study
% The full call can be
[~, ~, AMD, AMD_Ctl, RP, Ctl] = SubJect;

% Load ACH data
TPdata = '/media/HDPC-UT/dMRI_data/Results/ACH_0210.mat';
load(TPdata);

%
if notDefined('vals')
    vals = 'fa';
end

if notDefined('fibID')
    fibID = 1;
end

if notDefined('SavePath')
    SavePath = '/media/HDPC-UT/dMRI_data/Results/RP_plots3';
end
%% 
%% ACH{subjectID, fiberID}
% c.e ACH{8,1};
% subject = AMD-08-YA-20150426;
% fiber   = 'fg_OT_5K_85_Optic-Chiasm_Lt-LGN4_2015-07-13_18.48.12-41_Right-Cerebral-White-Matter_Ctrk100_AFQ_89'

% retrieve FA data from all subject

% vals = struct2table(ACH{1,1}.vals);

% Get the subject lists
for n = 1 :length(ACH)
    if  isstruct(ACH{n ,1})
        Names{n} = ACH{n,1}.subjectName;
    end
end

%
All_sub = [RP,AMD_C,Ctl];
% %%
% Val =  {'fa','md','rd','ad'};
% for ValID = 1: length(Val)
%     % Val =  fieldnames(ACH{1,1}.vals);
%     
%     % vals =  zeros(length(All_sub),length(ACH{1,1}.vals.fa));    
%     fbName = {'L-OT','R-OT','L-OR','R-OR','LOR0-3','ROR0-3','LOR15-30','ROR15-30'...
%         'LOR30-90','ROR30-90'};
%     
%     for fiberID = 1:length(fbName)
%         
%         for subjectID = 1:length(All_sub)
%             vals(subjectID,:) = ACH{subjectID,fiberID}.vals.(Val{ValID});
%         end
%     end
% end

%% Figure
% indivisual FA value along optic tract
% if fibID< 5,
% take values
fbName = {'L-OT','R-OT','L-OR','R-OR','LOR0-3','ROR0-3','LOR15-30','ROR15-30'...
    'LOR30-90','ROR30-90'};
% package to cnotain
nodes =  length(ACH{10,fibID}.vals.fa);
fa = nan(length(ACH), nodes);
md = fa;
ad = fa;
rd = fa;

% unite values 
for subID = 1:length(ACH);
    if isempty(ACH{subID,fibID});
        fa(subID,:) =nan(1,nodes);
    else
        fa(subID,:) =  ACH{subID,fibID}.vals.fa;
    end;
    
    if isempty(ACH{subID,fibID});
        md(subID,:) =nan(1,nodes);
    else
        md(subID,:) = ACH{subID,fibID}.vals.md;
    end;
    
    if isempty(ACH{subID,fibID});
        rd(subID,:) =nan(1,nodes);
    else
        rd(subID,:) = ACH{subID,fibID}.vals.rd;
    end;
    
    if isempty(ACH{subID,fibID});
        ad(subID,:) =nan(1,nodes);
    else
        ad(subID,:) = ACH{subID,fibID}.vals.ad;
    end;
end

vals = lower(vals);
switch vals
    case 'fa'
        val_C  = fa(Ctl,:);
        val_AC = fa(AMD_Ctl,:);
        val_RP = fa(RP,:);
        val_AMD = fa(AMD,:);

    case 'md'
        val_C  = md(Ctl,:);
        val_AC = md(AMD_Ctl,:);
        val_RP = md(RP,:);
        val_AMD = md(AMD,:);

    case 'ad'
        val_C  = ad(Ctl,:);
        val_AC = ad(AMD_Ctl,:);
        val_RP = ad(RP,:);
        val_AMD = ad(AMD,:);

    case 'rd'
        val_C  = rd(Ctl,:);
        val_AC = rd(AMD_Ctl,:);
        val_RP = rd(RP,:);
        val_AMD = rd(AMD,:);

end

%
% CTL_data = val_AC;
% RP_data  = val_RP;
AMD_data  = val_AMD;

%% compare tract profile with AMD_Ctl

% % ANOVA
%  group =2;
%  M = length(AMD_Ctl);
%  pac = nan(M,group);
%  
%  
% for jj= 1: nodes
%     pac(:,1)= val_AC(:,jj);
%     pac(1:8,2)= val_AMD(:,jj);    
%     [p(jj),~,stats(jj)] = anova1(pac,[],'off');
% %     co = multcompare(stats(jj),'display','off');
% %     C{jj}=co;
% end
% Portion =  p<0.05; % where is most effected
% 
% Portion = Portion+0;


%% Wilcoxon Single rank test
% container
group =2;
pac = nan(length(All_sub),group);

for jj= 1: nodes  
    pac(1:length(RP),1)= val_RP(:,jj);
    pac(1:length([AMD_C,Ctl]),2)= [val_AC(:,jj);val_C(:,jj)];
    
    [p(jj),h(jj),~] = signrank(pac(:,1),pac(:,2));
%     co = multcompare(stats(jj),'display','off');
%     C{jj}=co;
end

% logical 2 double
h = h+0;

%%
G = figure; hold on;
X = 1:length(h);
c = lines(length(h));

bar(X,h*3,1.0,'EdgeColor','none')

% Control
st = nanstd(val_AC);
m   = nanmean(val_AC,1);

% render control subjects range
A3 = area(m+2*st);
A1 = area(m+st);
A2 = area(m-st);
A4 = area(m-2*st);

% set color and style
set(A1,'FaceColor',[0.6 0.6 0.6],'linestyle','none')
set(A2,'FaceColor',[0.8 0.8 0.8],'linestyle','none')
set(A3,'FaceColor',[0.8 0.8 0.8],'linestyle','none')
set(A4,'FaceColor',[1 1 1],'linestyle','none')

plot(m,'color',[0 0 0], 'linewidth',3 )

% add individual FA plot
for k = 1:length(AMD) %1:length(subDir)
    plot(X,AMD_data(k,:),'Color',c(k,:),...
        'linewidth',1);
end
m   = nanmean(AMD_data,1);
plot(X,m,'Color',c(3,:) ,'linewidth',3)

T = title(sprintf('%s comparing to AMD_C', fbName{fibID}));
ylabel(upper(vals))
xlabel('Location')

% set Y limit 
Xlim = (m+2*st);
A =  round(max(Xlim(10:40))+0.2,1);

Y = (m-2*st);
B =  round(min(Y(10:40))-0.2,1);

b = [B,A];

if b(1)<0;b(1)=0;end;
set(gca,'ylim',b,'yTick',b);


hold off;

% Save current figure
if ~isempty(SavePath) 
    saveas(G,fullfile(SavePath, [vals,'_',T.String,'.eps']),'psc2')
    saveas(G,fullfile(SavePath, [vals,'_',T.String]),'bmp')
end

return
