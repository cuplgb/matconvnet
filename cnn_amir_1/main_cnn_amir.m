function main_cnn_amir(varargin)
% -- == -- == -- == -- == -- == -- == -- == -- == -- == -- == -- == -- == -- ==
% -- ==                                                                   -- ==
% -- ==                        NETWORK ARCH                               -- ==
% -- ==                                                                   -- ==
% -- == -- == -- == -- == -- == -- == -- == -- == -- == -- == -- == -- == -- ==
  % datasetList = {'cifar', 'stl-10', 'coil-100'}; % {'mnist', 'cifar', 'stl-10', 'coil-100'}
  % datasetList = {'cifar', 'coil-100', 'mnist', 'stl-10'};
  datasetList = {'prostate'};

  % networkArch = 'mnistnet';
  % % backpropDepthList = [8, 6, 4];
  % backpropDepthList = [4];

  networkArch = 'prostatenet';
  % backpropDepthList = [13, 10, 7, 4];
  backpropDepthList = [13, 4];
  % leaveOutType = 'sample';
  % leaveOutIndices = 1:1:266;
  leaveOutType = 'patient';
  leaveOutIndices = 1:1:104;


  % networkArch = 'lenet';
  % backpropDepthList = [13, 10, 7, 4]; % no dropout
  % backpropDepthList = [14, 10, 7, 4]; % 1 x dropout after 1st layer
  % backpropDepthList = [14, 11, 8, 4]; % 1 x dropout after 3rd layer
  % backpropDepthList = [14, 11, 8, 5]; % 1 x dropout in FC
  % backpropDepthList = [15, 11, 8, 4]; % 2 x dropout after 1st and 3rd layers
  % backpropDepthList = [4];

  % networkArch = 'lenet';
  % % backpropDepthList = [13, 10, 7, 4];
  % backpropDepthList = [13];

  % networkArch = 'alexnet';
  % % backpropDepthList = [20, 18, 15, 12, 10, 7];
  % backpropDepthList = [20];

  % networkArch = 'alexnet-bnorm';
  % % backpropDepthList = [20, 18, 15, 12, 10, 7];
  % backpropDepthList = [22];

  % networkArch = 'alexnet-bottleneck';
  % backpropDepthList = [21];
  % bottleneckDivideByList = [1,2,4,8,16,32];
  bottleneckDivideByList = [1];

% -- == -- == -- == -- == -- == -- == -- == -- == -- == -- == -- == -- == -- ==
% -- ==                                                                   -- ==
% -- ==                          MORE PARAMS                              -- ==
% -- ==                                                                   -- ==
% -- == -- == -- == -- == -- == -- == -- == -- == -- == -- == -- == -- == -- ==

  weightInitSource = 'gen';  % {'load' | 'gen'}
  weightInitSequenceList = {{'compRand', 'compRand', 'compRand'}};

  % weightInitSource = 'load';  % {'load' | 'gen'}
  % weightInitSequenceList = {{'compRand', 'layerwise-1D-from-cifar', 'layerwise-1D-from-cifar'}};
  % weightInitSequenceList = { ...
  %   ... % {'1-clustered-layerwise-1D-from-cifar', '1-clustered-layerwise-1D-from-cifar', '1-clustered-layerwise-1D-from-cifar'}, ...
  %   ... % {'1-clustered-layerwise-1D-from-coil-100', '1-clustered-layerwise-1D-from-coil-100', '1-clustered-layerwise-1D-from-coil-100'}, ...
  %   ... % {'1-clustered-layerwise-1D-from-mnist', '1-clustered-layerwise-1D-from-mnist', '1-clustered-layerwise-1D-from-mnist'}, ...
  %   ... % {'1-clustered-layerwise-1D-from-stl-10', '1-clustered-layerwise-1D-from-stl-10', '1-clustered-layerwise-1D-from-stl-10'}, ...
  %   ... % {'2-clustered-layerwise-1D-from-cifar', '2-clustered-layerwise-1D-from-cifar', '2-clustered-layerwise-1D-from-cifar'}, ...
  %   {'2-clustered-layerwise-1D-from-coil-100', '2-clustered-layerwise-1D-from-coil-100', '2-clustered-layerwise-1D-from-coil-100'}, ...
  %   {'2-clustered-layerwise-1D-from-mnist', '2-clustered-layerwise-1D-from-mnist', '2-clustered-layerwise-1D-from-mnist'}, ...
  %   {'2-clustered-layerwise-1D-from-stl-10', '2-clustered-layerwise-1D-from-stl-10', '2-clustered-layerwise-1D-from-stl-10'}, ...
  %   ... % {'4-clustered-layerwise-1D-from-cifar', '4-clustered-layerwise-1D-from-cifar', '4-clustered-layerwise-1D-from-cifar'}, ...
  %   ... % {'4-clustered-layerwise-1D-from-coil-100', '4-clustered-layerwise-1D-from-coil-100', '4-clustered-layerwise-1D-from-coil-100'}, ...
  %   ... % {'4-clustered-layerwise-1D-from-mnist', '4-clustered-layerwise-1D-from-mnist', '4-clustered-layerwise-1D-from-mnist'}, ...
  %   ... % {'4-clustered-layerwise-1D-from-stl-10', '4-clustered-layerwise-1D-from-stl-10', '4-clustered-layerwise-1D-from-stl-10'}, ...
  %   ... % {'8-clustered-layerwise-1D-from-cifar', '8-clustered-layerwise-1D-from-cifar', '8-clustered-layerwise-1D-from-cifar'}, ...
  %   ... % {'8-clustered-layerwise-1D-from-coil-100', '8-clustered-layerwise-1D-from-coil-100', '8-clustered-layerwise-1D-from-coil-100'}, ...
  %   ... % {'8-clustered-layerwise-1D-from-mnist', '8-clustered-layerwise-1D-from-mnist', '8-clustered-layerwise-1D-from-mnist'}, ...
  %   ... % {'8-clustered-layerwise-1D-from-stl-10', '8-clustered-layerwise-1D-from-stl-10', '8-clustered-layerwise-1D-from-stl-10'}, ...
  %   ... % {'16-clustered-layerwise-1D-from-cifar', '16-clustered-layerwise-1D-from-cifar', '16-clustered-layerwise-1D-from-cifar'}, ...
  %   ... % {'16-clustered-layerwise-1D-from-coil-100', '16-clustered-layerwise-1D-from-coil-100', '16-clustered-layerwise-1D-from-coil-100'}, ...
  %   ... % {'16-clustered-layerwise-1D-from-mnist', '16-clustered-layerwise-1D-from-mnist', '16-clustered-layerwise-1D-from-mnist'}, ...
  %   ... % {'16-clustered-layerwise-1D-from-stl-10', '16-clustered-layerwise-1D-from-stl-10', '16-clustered-layerwise-1D-from-stl-10'}, ...
  %   {'compRand', 'compRand', 'compRand'}, ...
  %   {'kernelwise-1D-from-cifar', 'kernelwise-1D-from-cifar', 'kernelwise-1D-from-cifar'}, ...
  %   {'kernelwise-1D-from-coil-100', 'kernelwise-1D-from-coil-100', 'kernelwise-1D-from-coil-100'}, ...
  %   {'kernelwise-1D-from-mnist', 'kernelwise-1D-from-mnist', 'kernelwise-1D-from-mnist'}, ...
  %   {'kernelwise-1D-from-stl-10', 'kernelwise-1D-from-stl-10', 'kernelwise-1D-from-stl-10'}, ...
  %   {'layerwise-1D-from-cifar', 'layerwise-1D-from-cifar', 'layerwise-1D-from-cifar'}, ...
  %   {'layerwise-1D-from-coil-100', 'layerwise-1D-from-coil-100', 'layerwise-1D-from-coil-100'}, ...
  %   {'layerwise-1D-from-mnist', 'layerwise-1D-from-mnist', 'layerwise-1D-from-mnist'}, ...
  %   {'layerwise-1D-from-stl-10', 'layerwise-1D-from-stl-10', 'layerwise-1D-from-stl-10'}, ...
  % };

  % imdbPortionList = [0.1, 0.25, 0.5, 1.0];
  imdbPortionList = [1.0];

  % weightDecayList = [0.1, 0.01, 0.001, 0.0001, 0]; % Works: {0.001, 0.0001, 0} Doesn't Work: {0.1, 0.01}
  weightDecayList = [0.0001];

  debugFlag = true;

% -- == -- == -- == -- == -- == -- == -- == -- == -- == -- == -- == -- == -- ==
% -- ==                                                                   -- ==
% -- ==                           MAIN LOOP                               -- ==
% -- ==                                                                   -- ==
% -- == -- == -- == -- == -- == -- == -- == -- == -- == -- == -- == -- == -- ==
  for dataset = datasetList
    for weightInitSequence = weightInitSequenceList
      for bottleneckDivideBy = bottleneckDivideByList
        for imdbPortion = imdbPortionList
          for weightDecay = weightDecayList
            for backpropDepth = backpropDepthList
              for leaveOutIndex = leaveOutIndices
                cnn_amir( ...
                  'leaveOutType', leaveOutType, ...
                  'leaveOutIndex', leaveOutIndex, ...
                  'networkArch', networkArch, ...
                  'dataset', char(dataset), ...
                  'backpropDepth', backpropDepth, ...
                  'weightDecay', weightDecay, ...
                  'weightInitSequence', weightInitSequence{1}, ...
                  'weightInitSource', weightInitSource, ...
                  'bottleneckDivideBy', bottleneckDivideBy, ...
                  'debugFlag', debugFlag);
              end
            end
          end
        end
      end
    end
  end
