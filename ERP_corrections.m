load pooled_eeg_data.mat 
%% Saving the timepoints into a variable 
timepoints = header.timeline; 
%% Creating averages per condition
average_1=mean(eeg_occiptemporal(:,:,1)); 
average_2=mean(eeg_occiptemporal(:,:,2)); 
%% Plot average of condition 1
plot(timepoints, mean(eeg_occiptemporal(:,:,1))); 
%% Adding condition 2
plot(timepoints, mean(eeg_occiptemporal(:,:,1)));
hold on;
plot(timepoints, mean(eeg_occiptemporal(:,:,2)), 'r');
hold off;
difference = mean(eeg_occiptemporal(:,:,1)) - mean(eeg_occiptemporal(:,:,2));
%% Calculating the difference between means of each subject across conditions 1 and 2
difference = mean(eeg_occiptemporal(:,:,1)) - mean(eeg_occiptemporal(:,:,2));
%% Adding the difference to a plot
hold on 
plot(timepoints, difference)
%% t-test to compute the difference between means of condition 1 and condition 2 for one timepoint
[h, p] = ttest(eeg_occiptemporal(:,1,1), eeg_occiptemporal(:,1,2));
%% t-test to compute the difference between means of condition 1 and condition 2 for all timepoints
[h, p] = ttest(eeg_occiptemporal(:,:,1), eeg_occiptemporal(:,:,2)); 
%% plot timepoints of ERP that significantly differ between condition 1 and 2
[h_fdr, p] = ttest(eeg_occiptemporal(:,:,1)); 
eeg_occiptemporal(:,:,2); 
sig_difference = mean(eeg_occiptemporal(:,:,1)) - ... 
mean(eeg_occiptemporal(:,:,2)); 
sig_difference(h_fdr==0) = NaN; 
hold on 
plot(timepoints, sig_difference);
%% Uncorrected t-test
figure;
plot(timepoints, mean(eeg_occiptemporal(:,:,1)), 'b'); %line 1
hold on;
plot(timepoints, mean(eeg_occiptemporal(:,:,2)), 'r'); %line 2
difference = mean(eeg_occiptemporal(:,:,1)) - mean(eeg_occiptemporal(:,:,2)); %line 3
hold on 
plot(timepoints, difference)
[h, p] = ttest(eeg_occiptemporal(:,:,1)), eeg_occiptemporal(:,:,2); 
sig_difference = mean(eeg_occiptemporal(:,:,1)) - mean(eeg_occiptemporal(:,:,2)); 
sig_difference(h==0) = NaN; 
hold on 
plot(timepoints, sig_difference); %line 4
% make it pretty 
legend('Condition 1', 'Condition 2', 'Difference', 'Significant Difference');
xlabel('Timepoints');
ylabel('ERP Amplitudes');
title('ERP Differences Between Condition 1 and Condition 2');
%% Template
%figure; 
% plot condition 1
% plot condition 2
% plot difference condition 1 and 2
%
% plot line where sign timepoints are highlighted (uncorrected, bonferroni,
% fdr)
%% corrected alpha
alpha = 0.05;
numTimePoints = 256;
alpha_corrected = alpha / numTimePoints; 
sig_difference_bonferroni = sig_difference;  
sig_difference_bonferroni(p >= alpha_corrected) = NaN; %this p contains the p-values from our t-test 
%% Creating the ERP with Bonferroni correction 
% copying the code for the previous plot
figure;
plot(timepoints, mean(eeg_occiptemporal(:,:,1)), 'b'); %line 1
hold on;
plot(timepoints, mean(eeg_occiptemporal(:,:,2)), 'r'); %line 2
difference = mean(eeg_occiptemporal(:,:,1)) - mean(eeg_occiptemporal(:,:,2)); %line 3
hold on 
plot(timepoints, difference)
%% new plot Bonferroni
figure;
plot(timepoints, mean(eeg_occiptemporal(:,:,1)), 'b'); %line 1
hold on;
plot(timepoints, mean(eeg_occiptemporal(:,:,2)), 'r'); %line 2
difference = mean(eeg_occiptemporal(:,:,1)) - mean(eeg_occiptemporal(:,:,2)); %line 3
hold on 
plot(timepoints, difference)
numTimePoints = length(header.timeline); 
alpha = 0.05; 
alpha_corrected = alpha / numTimePoints; 
sig_difference_bonferroni = sig_difference;  
sig_difference_bonferroni(p >= alpha_corrected) = NaN; 
hold on 
plot(timepoints, sig_difference_bonferroni, 'g') %line 4
% make it pretty 
legend('Condition 1', 'Condition 2', 'Difference', 'Bonferroni Corrected');
xlabel('Timepoints');
ylabel('ERP Amplitudes');
title('Bonferroni Corrected ERP Differences Between Condition 1 and Condition 2');
%% FDR correction 
% load fdr_bh.m
% applying the FDR correction 
sig_difference_fdr=sig_difference;  
[h_fdr]=fdr_bh(p);

% plotting the FDR correction 
figure;
plot(timepoints, mean(eeg_occiptemporal(:,:,1)), 'b'); %line 1
hold on;
plot(timepoints, mean(eeg_occiptemporal(:,:,2)), 'r'); %line 2
difference = mean(eeg_occiptemporal(:,:,1)) - mean(eeg_occiptemporal(:,:,2)); %line 3
hold on 
plot(timepoints, difference)
hold on 
%sig_difference_fdr = mean(eeg_occiptemporal(:,:,1)) - mean(eeg_occiptemporal(:,:,2)); 
sig_difference_fdr(h_fdr==0) = NaN; 
plot(timepoints, sig_difference_fdr, 'g') %line 4
% make it pretty 
legend('Condition 1', 'Condition 2', 'Difference', 'FDR Corrected');
xlabel('Timepoints');
ylabel('ERP Amplitudes');
title('FDR Corrected ERP Differences Between Condition 1 and Condition 2');