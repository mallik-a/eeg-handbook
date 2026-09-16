% Spectral analyses: Time-frequency with Morlet wavelet analysis, power spectral density, topoplots
clc
clear
close all

%% Preprocessing 
% Be sure that fieldtrip has been added to your path. The tutorial has been
% designed with fieldtrip-20240110

cfg = [];                                    % Create an empty configuration structure
cfg.dataset = 'oddball1_mc_downsampled_eeg.vhdr';  % Specify the EEG dataset to preprocess

% Define trials based on responses
cfg.trialdef.prestim    = 1.5;                % Time window before the event (in seconds)
cfg.trialdef.poststim   = 2.0;                % Time window after the event (in seconds)
cfg.trialdef.eventtype  = 'STI102';           % Name of the trigger channel
cfg.trialdef.eventvalue = [256, 4096];        % Event codes: 256 for button press left, 4096 for button press right
cfg.trialfun            = 'ft_trialfun_general';  % Specify the trial function to use for defining trials
cfg                     = ft_definetrial(cfg);    % Define the trials based on the event information in cfg

% Preprocess EEG data
cfg.demean              = 'yes';              % Remove mean value from the data - DC offset correction
cfg.dftfilter           = 'yes';              % Apply a DFT filter to remove specific frequencies
cfg.dftfreq             = [50 100];           % Frequencies to filter out (50 Hz and 100 Hz)
cfg.reref               = 'yes';              % Re-reference the data
cfg.refchannel          = 'all';              % Use all channels for re-referencing

data                    = ft_preprocessing(cfg);  % Preprocess the EEG data with the specified configuration

%% Compute power spectra for power spectral density plot

cfg         = [];                            % Create a new empty configuration structure
cfg.output  = 'pow';                         % Set output to power spectrum
cfg.channel = 'EEG126';                      % Specify the channel to analyze
cfg.method  = 'mtmfft';                      % Use multitaper method for Fourier transform
cfg.taper   = 'hanning';                     % Use Hanning taper
cfg.foi     = 7:40;                          % Frequencies of interest from 7 Hz to 40 Hz

cfg.trials   = find(data.trialinfo(:,1) == 256); % Select trials with event code 256 (button press left)
spectr_left  = ft_freqanalysis(cfg, data);      % Perform frequency analysis for left button press

cfg.trials   = find(data.trialinfo(:,1) == 4096); % Select trials with event code 4096 (button press right)
spectr_right = ft_freqanalysis(cfg, data);        % Perform frequency analysis for right button press

% Visualising the power spectrum

figure;                                   % Create a new figure
hold on;                                  % Hold the plot for multiple lines
plot(spectr_left.freq, (spectr_left.powspctrm), 'linewidth', 2); % Plot left button press power spectrum
plot(spectr_left.freq, (spectr_right.powspctrm), 'linewidth', 2); % Plot right button press power spectrum
legend('Button press left', 'Button press right'); % Add legend
xlabel('Frequency (Hz)');                  % Label x-axis
ylabel('Power (\mu V^2)');                 % Label y-axis


%% Time-frequency analysis Morlet wavelet

cfg            = [];                            % Create a new empty configuration structure
cfg.output     = 'pow';                         % Calculate the power spectrum
cfg.channel    = 'all';                         % Include all channels
cfg.method     = 'wavelet';                     % Select Morlet wavelet method
cfg.width      = 7;                             % Number of cycles (typical values range from 4 to 7)
cfg.toi        = -1 : 0.05 : 1.5;               % Time window of interest from -1s to 1.5s in 0.05s steps
cfg.foi        = 1:40;                          % Frequencies of interest from 1 Hz to 40 Hz (in 1 Hz steps)

cfg.trials     = find(data.trialinfo(:,1) == 256); % Select trials with event code 256 (button press left)
wave_left      = ft_freqanalysis(cfg, data);      % Perform time-frequency analysis for left button press

cfg.trials     = find(data.trialinfo(:,1) == 4096); % Select trials with event code 4096 (button press right)
wave_right     = ft_freqanalysis(cfg, data);        % Perform time-frequency analysis for right button press

% Time-frequency plot 

cfg          = [];                             % Create an empty configuration structure
cfg.colorbar = 'yes';                          % Enable color bar to show the scale of power values
cfg.zlim     = 'maxabs';                       % Set color limits to the maximum absolute value to ensure symmetric color scaling
cfg.ylim     = [10 Inf];                       % Define the frequency range for plotting, starting from 10 Hz upwards (focusing on the alpha band and higher)
cfg.layout   = 'natmeg_customized_eeg1005.lay';% Specify the layout for plotting the EEG data
cfg.channel  = 'EEG126';                       % Select the EEG channel to plot

figure;                                        % Create a new figure
ft_singleplotTFR(cfg, wave_left);              % Plot the time-frequency response for the left-hand reaction using the specified configuration
title('Left hand reaction');                   % Add a title to the plot for the left-hand reaction

figure;                                        % Create a new figure
ft_singleplotTFR(cfg, wave_right);             % Plot the time-frequency response for the right-hand reaction using the specified configuration
title('Right hand reaction');                  % Add a title to the plot for the right-hand reaction


%% Time-frequency plot difference left vs right

cfg            = [];                           % Create a new empty configuration structure
cfg.parameter  = 'powspctrm';                  % Specify parameter to operate on (power spectrum)
cfg.operation  = '(x1-x2)/(x1+x2)';            % Define operation to compute difference between conditions

wave_difference = ft_math(cfg, wave_right, wave_left);  % Compute the difference between right and left conditions

cfg          = [];                             % Create a new empty configuration structure
cfg.colorbar = 'yes';                          % Display colour bar
cfg.zlim     = 'maxabs';                       % Use maximum absolute value for colour limits
cfg.layout   = 'natmeg_customized_eeg1005.lay';% Specify the layout for the plot
cfg.channel  = 'EEG126';                       % Specify the channel to plot

figure;                                        % Create a new figure
ft_singleplotTFR(cfg, wave_difference);        % Plot the time-frequency representation of the difference
title('Left vs right hand reaction');          % Add title to the plot


%% Topoplot - difference between conditions

cfg              = [];                             % Create an empty configuration structure
cfg.baseline     = [-0.5 -0.1];                    % Define the baseline period (-0.5 to -0.1 seconds) for baseline correction
cfg.baselinetype = 'relative';                     % Use a relative baseline, which normalizes the power values relative to the baseline period
cfg.xlim         = [0.4 0.8];                      % Time window for plotting (0.4 to 0.8 seconds)
cfg.ylim         = [16 24];                        % Frequency range for plotting (16 to 24 Hz)
cfg.zlim         = 'maxabs';                       % Use maximum absolute value for color limits to ensure symmetric scaling
cfg.marker       = 'on';                           % Show electrode markers on the topoplot
cfg.colorbar     = 'yes';                          % Enable color bar to show the scale of power values
cfg.layout       = 'natmeg_customized_eeg1005.lay';% Specify the layout for plotting the EEG data

figure;                                            % Create a new figure
ft_topoplotTFR(cfg, wave_left);                    % Plot the topography of the time-frequency response for the left-hand reaction using the specified configuration
title('Left hand reaction');                       % Add a title to the plot for the left-hand reaction

figure;                                            % Create a new figure
ft_topoplotTFR(cfg, wave_right);                   % Plot the topography of the time-frequency response for the right-hand reaction using the specified configuration
title('Right hand reaction');                      % Add a title to the plot for the right-hand reaction

cfg = [];
cfg.parameter    = 'powspctrm';
cfg.operation    = '(x1-x2)/(x1+x2)';

tfr_difference = ft_math(cfg, wave_right, wave_left);

cfg = [];
cfg.xlim         = [0.4 0.8];
cfg.ylim         = [16 24];
cfg.zlim         = 'maxabs';
cfg.marker       = 'on';
cfg.colorbar     = 'yes';
cfg.layout       = 'natmeg_customized_eeg1005.lay';

figure;
ft_topoplotTFR(cfg, tfr_difference);
title('Left vs right hand reaction');