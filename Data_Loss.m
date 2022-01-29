% DataLoss


topLevelFolder = pwd; % or whatever,
% Get a list of all files and folders in this folder.
files = dir(topLevelFolder);
% Get a logical vector that tells which is a directory.
dirFlags = [files.isdir];
% Extract only those that are directories.
subFolders = files(dirFlags); % A structure with extra info.
% Remove the .'s
subFolders(ismember( {subFolders.name}, {'.', '..'})) = [];  %remove . and ..

split_lens = [0,1,(5:5:100)];
for i = 1:size(split_lens,2)
    % create filepaths
    out(i).foldername = [pwd,'\split_',char(string(split_lens(i)))];
    % list split lengths
    out(i).split_len = split_lens(i);
    % parse the tictoc.txt files
    tictoc = readtable([out(i).foldername,'\eventer.output\ALL_events\tictoc.txt']);
    % pull out the number of cores
    out(i).num_cores = table2array(tictoc(2,4));
    % pull out the duration (in s)
    out(i).duration = table2array(tictoc(3,4));
    % parse the summary.txt
    summary = readtable([out(i).foldername,'\eventer.output\ALL_events\summary.txt']);
    % pull out the events detected
    out(i).event_count = table2array(summary(3,2));
end
figure; 
yyaxis left; plot([out(:).split_len],[out(:).duration],'linewidth',2); ylabel('Duration (s)')
yyaxis right; plot([out(:).split_len],[out(:).event_count],'linewidth',2); ylabel('Events detected (%)'); ylim([0 100])
box off; set(gca,'linewidth',2); set(gcf,'color','white'); xlabel('Split Length (s)')
legend('Duration','Event Count','linewidth',1,'location','southeast')
title('Duration and Events Detected against split times for 100s long 1Hz recording')