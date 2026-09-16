% EEG Data Preprocessing Script

%% Section 1: Load the Dataset
% Loading the dataset
[ALLEEG, EEG, CURRENTSET, ALLCOM] = eeglab;
EEG = pop_loadset('filename', 'pp010405.set', 'filepath', 'C:\\UvA\\Semester 2\\Neuroimaging EEG\\week 3\\EEG_data_subj1_full\\');
[ALLEEG, EEG, CURRENTSET] = eeg_store(ALLEEG, EEG, 0);

%% Section 2: Rereference to Fz
% Rereference the EEG data, excluding HEOG (channels 49) and VEOG (channels 50)
EEG = pop_reref(EEG, 31, 'exclude', [49 50]);
pop_eegplot(EEG, 1, 1, 1);
[ALLEEG, EEG, CURRENTSET] = pop_newset(ALLEEG, EEG, 1, 'setname', 'reref-Fz.pp010405', 'gui', 'off');

%% Section 3: Filter Data
% Filter the data to keep frequencies between 1 and 20 Hz
EEG = pop_eegfiltnew(EEG, 'locutoff', 1, 'hicutoff', 20, 'plotfreqz', 1);
pop_eegplot(EEG, 1, 1, 1);
[ALLEEG, EEG, CURRENTSET] = pop_newset(ALLEEG, EEG, 2, 'setname', 'plots.reref-Fz.pp010405', 'gui', 'off');

%% Section 4: Create Epochs
% Create epochs from 0.3 seconds before stimulus onset until 1.2 seconds post-stimulus
EEG = pop_epoch(EEG, {}, [-0.3 1.2], 'newname', 'reref-Fz.pp010405 epochs', 'epochinfo', 'yes');
pop_eegplot(EEG, 1, 1, 1);
[ALLEEG, EEG, CURRENTSET] = pop_newset(ALLEEG, EEG, 3, 'retrieve', 2, 'study', 0);

%% Section 5: Baseline Correction
% Perform baseline correction from -300 ms to 0 ms
EEG = pop_rmbase(EEG, [-300 0], []);
pop_eegplot(EEG, 1, 1, 1);
[ALLEEG, EEG, CURRENTSET] = pop_newset(ALLEEG, EEG, 4, 'setname', 'reref-Fz.pp010405 epochs rm', 'gui', 'off');

%% Section 6: Trial Rejection
% Trial rejection - removing abnormal values (defined as below -75 µV or above 75 µV)
EEG = pop_eegthresh(EEG, 1, [1:49], -75, 75, -0.30078, 1.195, 2, 0);
EEG = eeg_rejsuperpose(EEG, 1, 1, 1, 1, 1, 1, 1, 1);
pop_eegplot(EEG, 1, 1, 1);
[ALLEEG, EEG, CURRENTSET] = pop_newset(ALLEEG, EEG, 5, 'retrieve', 4, 'study', 0);

% Re-reject epochs 
EEG = pop_rejepoch(EEG, [6:8 10 11 12 14 16 17 18 21:3:27 28 31 33 37 38:40 42 45:3:51 55 56 58 60 61 65 66:75 77 83 84:86 89 91 94 95:104 106 107 108 110:2:114 115:118 120 121 124 125:127 129 130 131 133 136 137:142 144 145:157 159 160 161 165 166 168 169 170 172 173:175 177 178:183 185 186 187 189 190:195 197 198:200 206 207:211 213 218 219:221 223 224:226 228 229:236 238 239 242 247 248:250 253 255 257 258:270 274 275:281 283 284:286 289 290:302 313 316 326 330 331 333 334:336 338 339 340 343 344 345 347 352 353 356 357 364 365 366 368 369 371 372 374 375:390 394 396 397:417 420 421 422 424 425:441 443 444:461 463 464:470 472 473:478 481 482 486 487 492 494 495:497 500 501 503 504:507 509 511 512:523 525 526 529 532 533 534 536 537:543 545 546:548 550 551:559 561 562:577 579 581 582 584 585:588 590 594 595 596 598 599 601 602 604 605:609 611:2:615 616:618 622 625 628 632 633 634 636 637:640 642 643:649 651 652 657 658 659 661 662:665 667 668:675 677 678:680 685 687 689 690:696 698 699 701 702:704 706 707:719 721 722:724 726 727 728 732 735 738 739 743 744:754 757 758 760 761:768 771 772 773 775 776 777 780 781:783 786 787:796 798 799:807 809 810:812 814 816 817:819 821 822:827 830 831:840 842 843:860 862 864 865:869 871 872 874 875:895 897 898:909 911 912:914 919 921 922 925 927 928 939 940 941 943:2:949 952 954 960 962 965 967 968 970 971 973 974:986 989 990 994 995 997 998 999 1004 1008 1009 1013 1014 1018 1019:1023 1025 1026:1031 1033 1034:1043 1045 1046:1059 1062 1063 1065 1066:1071 1073 1074 1076 1077:1086 1089 1090 1091 1094 1095:1099 1103 1106 1107:1111 1113 1114 1116 1120 1121 1122 1125 1126 1128 1129:1133 1138 1140 1142 1143 1145 1146:1148 1150 1151:1172 1175 1176 1177 1181 1183 1184:1186 1188 1189:1197 1199 1200], 0);
EEG = eeg_rejsuperpose(EEG, 1, 1, 1, 1, 1, 1, 1, 1);

%% Section 7: Save Pre-processed Dataset
% Save the preprocessed dataset under a different name
EEG = pop_saveset(EEG, 'filename', 'subj1_preprocessed.set', 'filepath', 'C:\\UvA\\Semester 2\\Neuroimaging EEG\\week 3\\EEG_data_subj1_full\\');

%% Bonus I
% EEG Data Preprocessing Script for Subjects 1, 2 and 3

% Define the list of subjects and their file paths
subjects = {'EEG_data_subj1_full', 'EEG_data_subj2_full', 'EEG_data_subj3_full'};
filepaths = {'C:\\UvA\\Semester 2\\Neuroimaging EEG\\week 3\\EEG_data_subj1_full\\', ...
             'C:\\UvA\\Semester 2\\Neuroimaging EEG\\week 3\\EEG_data_subj2_full\\', ...
             'C:\\UvA\\Semester 2\\Neuroimaging EEG\\week 3\\EEG_data_subj3_full\\'};

% Define the output file path
output_path = 'C:\\UvA\\Semester 2\\Neuroimaging EEG\\week 3\\EEG_data_preprocessed\\';

% Loop over each subject
for i = 1:length(subjects)
    % Define subject-specific variables
    subject_file = subjects{i};
    subject_path = filepaths{i};

    %% Section 1: Load the Dataset
    % Loading the dataset
    [ALLEEG, EEG, CURRENTSET, ALLCOM] = eeglab;
    EEG = pop_loadset('allsubjects', subject_file, 'C:\\UvA\\Semester 2\\Neuroimaging EEG\\week 3\\EEG_data_preprocessed\\', subject_path);
    [ALLEEG, EEG, CURRENTSET] = eeg_store(ALLEEG, EEG, 0);

    %% Section 2: Rereference to Fz
    % Rereference the EEG data, excluding HEOG (channels 49) and VEOG (channels 50)
    EEG = pop_reref(EEG, 31, 'exclude', [49 50]);
    pop_eegplot(EEG, 1, 1, 1);
    [ALLEEG, EEG, CURRENTSET] = pop_newset(ALLEEG, EEG, 1, 'setname', ['reref-Fz.' subject_file], 'gui', 'off');

    %% Section 3: Filter Data
    % Filter the data to keep frequencies between 1 and 20 Hz
    EEG = pop_eegfiltnew(EEG, 'locutoff', 1, 'hicutoff', 20, 'plotfreqz', 1);
    pop_eegplot(EEG, 1, 1, 1);
    [ALLEEG, EEG, CURRENTSET] = pop_newset(ALLEEG, EEG, 2, 'setname', ['plots.reref-Fz.' subject_file], 'gui', 'off');

    %% Section 4: Create Epochs
    % Create epochs from 0.3 seconds before stimulus onset until 1.2 seconds post-stimulus
    EEG = pop_epoch(EEG, {}, [-0.3 1.2], 'newname', ['reref-Fz.' subject_file ' epochs'], 'epochinfo', 'yes');
    pop_eegplot(EEG, 1, 1, 1);
    [ALLEEG, EEG, CURRENTSET] = pop_newset(ALLEEG, EEG, 3, 'retrieve', 2, 'study', 0);

    %% Section 5: Baseline Correction
    % Perform baseline correction from -300 ms to 0 ms
    EEG = pop_rmbase(EEG, [-300 0], []);
    pop_eegplot(EEG, 1, 1, 1);
    [ALLEEG, EEG, CURRENTSET] = pop_newset(ALLEEG, EEG, 4, 'setname', ['reref-Fz.' subject_file ' epochs rm'], 'gui', 'off');

    %% Section 6: Trial Rejection
    % Trial rejection - removing abnormal values (defined as below -75 µV or above 75 µV)
    EEG = pop_eegthresh(EEG, 1, 1:49, -75, 75, -0.30078, 1.195, 2, 0);
    EEG = eeg_rejsuperpose(EEG, 1, 1, 1, 1, 1, 1, 1, 1);
    pop_eegplot(EEG, 1, 1, 1);
    [ALLEEG, EEG, CURRENTSET] = pop_newset(ALLEEG, EEG, 5, 'retrieve', 4, 'study', 0);

    % Re-reject epochs (if needed as per original structure)
    EEG = pop_rejepoch(EEG, [6:8 10 11 12 14 16 17 18 21:3:27 28 31 33 37 38:40 42 45:3:51 55 56 58 60 61 65 66:75 77 83 84:86 89 91 94 95:104 106 107 108 110:2:114 115:118 120 121 124 125:127 129 130 131 133 136 137:142 144 145:157 159 160 161 165 166 168 169 170 172 173:175 177 178:183 185 186 187 189 190:195 197 198:200 206 207:211 213 218 219:221 223 224:226 228 229:236 238 239 242 247 248:250 253 255 257 258:270 274 275:281 283 284:286 289 290:302 313 316 326 330 331 333 334:336 338 339 340 343 344 345 347 352 353 356 357 364 365 366 368 369 371 372 374 375:390 394 396 397:417 420 421 422 424 425:441 443 444:461 463 464:470 472 473:478 481 482 486 487 492 494 495:497 500 501 503 504:507 509 511 512:523 525 526 529 532 533 534 536 537:543 545 546:548 550 551:559 561 562:577 579 581 582 584 585:588 590 594 595 596 598 599 601 602 604 605:609 611:2:615 616:618 622 625 628 632 633 634 636 637:640 642 643:649 651 652 657 658 659 661 662:665 667 668:675 677 678:680 685 687 689 690:696 698 699 701 702:704 706 707:719 721 722:724 726 727 728 732 735 738 739 743 744:754 757 758 760 761:768 771 772 773 775 776 777 780 781:783 786 787:796 798 799:807 809 810:812 814 816 817:819 821 822:827 830 831:840 842 843:860 862 864 865:869 871 872 874 875:895 897 898:909 911 912:914 919 921 922 925 927 928 939 940 941 943:2:949 952 954 960 962 965 967 968 970 971 973 974:986 989 990 994 995 997 998 999 1004 1008 1009 1013 1014 1018 1019:1023 1025 1026:1031 1033 1034:1043 1045 1046:1059 1062 1063 1065 1066:1071 1073 1074 1076 1077:1086 1089 1090 1091 1094 1095:1099 1103 1106 1107:1111 1113 1114 1116 1120 1121 1122 1125 1126 1128 1129:1133 1138 1140 1142 1143 1145 1146:1148 1150 1151:1172 1175 1176 1177 1181 1183 1184:1186 1188 1189:1197 1199 1200], 0);
    EEG = eeg_rejsuperpose(EEG, 1, 1, 1, 1, 1, 1, 1, 1);

    %% Section 7: Save Pre-processed Dataset
    % Save the preprocessed dataset under a different name
    EEG = pop_saveset(EEG, 'allsubjects', ['preprocessed_' subject_file], 'C:\\UvA\\Semester 2\\Neuroimaging EEG\\week 3\\EEG_data_preprocessed\\', output_path);
end

% End of Script
