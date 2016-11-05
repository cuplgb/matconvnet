function net = cnn_amir_init(varargin)
opts.networkArch = 'alexnet';
opts.dataset = 'cifar';
opts.backpropDepth = 20; % [20, 18, 15, 12, 10, 7];
opts.weightDecay = 0.0001; % Works: {0.001, 0.0001, 0} Doesn't Work: {0.1, 0.01}
opts.weightInitType = 'compRand'; % {'compRand', '1D', '2D-mult', '2D-super', '2D-posneg', '2D-positive'}
opts.weightInitSource = 'gen'; % {'load' | 'gen'}
opts.bottleneckDivideBy = 1;
opts = vl_argparse(opts, varargin);

tic;
rng(0);
net.layers = {};
% Meta parameters
switch opts.networkArch
  case 'lenet'
    net.meta.trainOpts.learningRate = [0.01*ones(1,5) 0.005*ones(1,25) 0.001*ones(1,10) 0.0005*ones(1,5) 0.0001*ones(1,5)];
  case 'alexnet'
    switch opts.weightInitType
      case 'compRand'
        % VERIFIED: weights completely random (goes down after 50 * 0.001 to %86 then after 230 epochs to ~%60)
        net.meta.trainOpts.learningRate = [0.01*ones(1,5) 0.005*ones(1,25) 0.001*ones(1,10) 0.0005*ones(1,5) 0.0001*ones(1,5)];
      case '1D'
        % VERIFIED: weights random from pre-train 1D (with or without whitening)
        net.meta.trainOpts.learningRate = [0.01*ones(1,5) 0.005*ones(1,25) 0.001*ones(1,10) 0.0005*ones(1,5) 0.0001*ones(1,5)];
      case '2D-mult'
        % TESTING.... weights random from pre-train 2D-mult (with whitening)
        net.meta.trainOpts.learningRate = [0.01*ones(1,5) 0.005*ones(1,25) 0.001*ones(1,10) 0.0005*ones(1,5) 0.0001*ones(1,5)];
      case '2D-super'
        % TESTING.... weights random from pre-train 2D-super (with whitening)
        % net.meta.trainOpts.learningRate = [1*ones(1,15)  0.005*ones(1,15) 0.001*ones(1,10) 0.0005*ones(1,5) 0.0001*ones(1,5)];
        % net.meta.trainOpts.learningRate = [0.1*ones(1,15)  0.005*ones(1,15) 0.001*ones(1,10) 0.0005*ones(1,5) 0.0001*ones(1,5)];
        % net.meta.trainOpts.learningRate = [0.01*ones(1,15)  0.005*ones(1,15) 0.001*ones(1,10) 0.0005*ones(1,5) 0.0001*ones(1,5)];
        net.meta.trainOpts.learningRate = [0.01*ones(1,5) 0.005*ones(1,25) 0.001*ones(1,10) 0.0005*ones(1,5) 0.0001*ones(1,5)];
        % net.meta.trainOpts.learningRate = [0.005*ones(1,100)];
      case '2D-posneg'
        % TESTING.... weights random from pre-train 2D (with whitening)
        net.meta.trainOpts.learningRate = [0.01*ones(1,5) 0.005*ones(1,25) 0.001*ones(1,10) 0.0005*ones(1,5) 0.0001*ones(1,5)];
        % net.meta.trainOpts.learningRate = [0.005*ones(1,100)];
    end
  case 'alexnet-bnorm'
    switch opts.weightInitType
      case 'compRand'
        % TESTING: weights completely random (goes down after 50 * 0.001 to %86 then after 230 epochs to ~%60)
        net.meta.trainOpts.learningRate = [0.01*ones(1,5) 0.005*ones(1,25) 0.001*ones(1,10) 0.0005*ones(1,5) 0.0001*ones(1,5)];
      case '1D'
        % TESTING: weights random from pre-train 1D (with or without whitening)
        net.meta.trainOpts.learningRate = [0.01*ones(1,5) 0.005*ones(1,25) 0.001*ones(1,10) 0.0005*ones(1,5) 0.0001*ones(1,5)];
      case '2D-mult'
        % TESTING.... weights random from pre-train 2D-mult (with whitening)
        net.meta.trainOpts.learningRate = [0.01*ones(1,5) 0.005*ones(1,25) 0.001*ones(1,10) 0.0005*ones(1,5) 0.0001*ones(1,5)];
      case '2D-super'
        % TESTING.... weights random from pre-train 2D-super (with whitening)
        net.meta.trainOpts.learningRate = [0.01*ones(1,5) 0.005*ones(1,25) 0.001*ones(1,10) 0.0005*ones(1,5) 0.0001*ones(1,5)];
        % net.meta.trainOpts.learningRate = [0.005*ones(1,100)];
      case '2D-posneg'
        % TESTING.... weights random from pre-train 2D (with whitening)
        net.meta.trainOpts.learningRate = [0.01*ones(1,5) 0.005*ones(1,25) 0.001*ones(1,10) 0.0005*ones(1,5) 0.0001*ones(1,5)];
        % net.meta.trainOpts.learningRate = [0.005*ones(1,100)];
    end
  case 'alexnet-bottleneck'
    % net.meta.trainOpts.learningRate = [0.01*ones(1,15)  0.005*ones(1,15) 0.001*ones(1,10) 0.0005*ones(1,5) 0.0001*ones(1,5)];
    net.meta.trainOpts.learningRate = [0.005*ones(1,50)];
end

net.meta.trainOpts.weightInitType = opts.weightInitType;
net.meta.trainOpts.weightInitSource = opts.weightInitSource;
net.meta.trainOpts.backpropDepth = opts.backpropDepth;
net.meta.trainOpts.numEpochs = numel(net.meta.trainOpts.learningRate);
net.meta.inputSize = [32 32 3];
net.meta.trainOpts.weightDecay = opts.weightDecay;
net.meta.trainOpts.batchSize = 100;
opts = vl_argparse(opts, varargin);

switch opts.networkArch
  case 'lenet'
    % --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --
    % --- --- ---                                                     --- --- --
    % --- --- ---                     LENET                           --- --- --
    % --- --- ---                                                     --- --- --
    % --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --
    layerNumber = 1;
    net.layers{end+1} = convLayer(layerNumber, 5, 3, 32, 1/100, 2, opts.weightInitType, opts.weightInitSource, opts.networkArch);
    net.layers{end+1} = poolingLayerLeNetMax(layerNumber);
    net.layers{end+1} = reluLayer(layerNumber);

    % --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --
    layerNumber = layerNumber + 3;
    net.layers{end+1} = convLayer(layerNumber, 5, 32, 32, 5/100, 2, opts.weightInitType, opts.weightInitSource, opts.networkArch);
    net.layers{end+1} = poolingLayerLeNetAvg(layerNumber);
    net.layers{end+1} = reluLayer(layerNumber);

    % --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --
    layerNumber = layerNumber + 3;
    net.layers{end+1} = convLayer(layerNumber, 5, 32, 64, 5/100, 2, opts.weightInitType, opts.weightInitSource, opts.networkArch);
    net.layers{end+1} = poolingLayerLeNetAvg(layerNumber);
    net.layers{end+1} = reluLayer(layerNumber);

    % --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --
    % FULLY CONNECTED
    layerNumber = layerNumber + 3;
    net.layers{end+1} = convLayer(layerNumber, 4, 64, 64, 5/100, 0, 'compRand', 'gen', opts.networkArch);
    net.layers{end+1} = reluLayer(layerNumber);

    % --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --
    layerNumber = layerNumber + 2;
    net.layers{end+1} = convLayer(layerNumber, 1, 64, 10, 5/100, 0, 'compRand', 'gen', opts.networkArch);

    % --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --
    % Loss layer
    net.layers{end+1} = struct('type', 'softmaxloss');
  case 'alexnet'
    % --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --
    % --- --- ---                                                     --- --- --
    % --- --- ---                   ALEXNET                           --- --- --
    % --- --- ---                                                     --- --- --
    % --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --
    layerNumber = 1;
    % net.layers{end+1} = convLayer(layerNumber, 5, 3, 96, 5/1000, 2, opts.weightInitType, opts.weightInitSource, opts.networkArch);
    net.layers{end+1} = convLayer(layerNumber, 5, 3, 96, 5/1000, 2, '2D-posneg', opts.weightInitSource, opts.networkArch);
    net.layers{end+1} = reluLayer(layerNumber);

    % --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --
    layerNumber = layerNumber + 2;
    % net.layers{end+1} = convLayer(layerNumber, 5, 96, 256, 5/1000, 2, opts.weightInitType, opts.weightInitSource, opts.networkArch);
    net.layers{end+1} = convLayer(layerNumber, 5, 96, 256, 5/1000, 2, '2D-posneg', opts.weightInitSource, opts.networkArch);
    net.layers{end+1} = reluLayer(layerNumber);
    net.layers{end+1} = poolingLayerAlexNet(layerNumber);

    % --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --
    layerNumber = layerNumber + 3;
    net.layers{end+1} = convLayer(layerNumber, 3, 256, 384, 5/1000, 1, opts.weightInitType, opts.weightInitSource, opts.networkArch);
    net.layers{end+1} = reluLayer(layerNumber);
    net.layers{end+1} = poolingLayerAlexNet(layerNumber);

    % --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --
    layerNumber = layerNumber + 3;
    net.layers{end+1} = convLayer(layerNumber, 3, 384, 384, 5/1000, 1, opts.weightInitType, opts.weightInitSource, opts.networkArch);
    net.layers{end+1} = reluLayer(layerNumber);

    % --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --
    layerNumber = layerNumber + 2;
    net.layers{end+1} = convLayer(layerNumber, 3, 384, 256, 5/1000, 1, opts.weightInitType, opts.weightInitSource, opts.networkArch);
    net.layers{end+1} = reluLayer(layerNumber);
    net.layers{end+1} = poolingLayerAlexNet(layerNumber);

    % --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --
    % FULLY CONNECTED
    layerNumber = layerNumber + 3;
    net.layers{end+1} = convLayer(layerNumber, 4, 256, 128, 5/1000, 0, 'compRand', 'gen', opts.networkArch);
    net.layers{end+1} = reluLayer(layerNumber);

    % --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --
    layerNumber = layerNumber + 2;
    net.layers{end+1} = convLayer(layerNumber, 1, 128, 64, 5/100, 0, 'compRand', 'gen', opts.networkArch);
    net.layers{end+1} = reluLayer(layerNumber);

    % --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --
    layerNumber = layerNumber + 2;
    net.layers{end+1} = convLayer(layerNumber, 1, 64, 10, 5/100, 0, 'compRand', 'gen', opts.networkArch);
    net.layers{end+1} = reluLayer(layerNumber);

    % --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --
    % Loss layer
    net.layers{end+1} = struct('type', 'softmaxloss');
  case 'alexnet-bnorm'
    % --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --
    % --- --- ---                                                     --- --- --
    % --- --- ---                ALEXNET-BNORM                        --- --- --
    % --- --- ---                                                     --- --- --
    % --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --
    layerNumber = 1;
    net.layers{end+1} = convLayer(layerNumber, 5, 3, 96, 5/1000, 2, opts.weightInitType, opts.weightInitSource, opts.networkArch);
    % net.layers{end+1} = bnormLayer(layerNumber, 96);
    net.layers{end+1} = reluLayer(layerNumber);

    % --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --
    layerNumber = layerNumber + 2;
    net.layers{end+1} = convLayer(layerNumber, 5, 96, 256, 5/1000, 2, opts.weightInitType, opts.weightInitSource, opts.networkArch);
    net.layers{end+1} = bnormLayer(layerNumber, 256);
    net.layers{end+1} = reluLayer(layerNumber);
    net.layers{end+1} = poolingLayerAlexNet(layerNumber);

    % --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --
    layerNumber = layerNumber + 3;
    net.layers{end+1} = convLayer(layerNumber, 3, 256, 384, 5/1000, 1, opts.weightInitType, opts.weightInitSource, opts.networkArch);
    % net.layers{end+1} = bnormLayer(layerNumber, 384);
    net.layers{end+1} = reluLayer(layerNumber);
    net.layers{end+1} = poolingLayerAlexNet(layerNumber);

    % --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --
    layerNumber = layerNumber + 3;
    net.layers{end+1} = convLayer(layerNumber, 3, 384, 384, 5/1000, 1, opts.weightInitType, opts.weightInitSource, opts.networkArch);
    % net.layers{end+1} = bnormLayer(layerNumber, 384);
    net.layers{end+1} = reluLayer(layerNumber);

    % --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --
    layerNumber = layerNumber + 2;
    net.layers{end+1} = convLayer(layerNumber, 3, 384, 256, 5/1000, 1, opts.weightInitType, opts.weightInitSource, opts.networkArch);
    net.layers{end+1} = bnormLayer(layerNumber, 256);
    net.layers{end+1} = reluLayer(layerNumber);
    net.layers{end+1} = poolingLayerAlexNet(layerNumber);

    % --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --
    % FULLY CONNECTED
    layerNumber = layerNumber + 3;
    net.layers{end+1} = convLayer(layerNumber, 4, 256, 128, 5/1000, 0, 'compRand', 'gen', opts.networkArch);
    net.layers{end+1} = reluLayer(layerNumber);

    % --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --
    layerNumber = layerNumber + 2;
    net.layers{end+1} = convLayer(layerNumber, 1, 128, 64, 5/100, 0, 'compRand', 'gen', opts.networkArch);
    net.layers{end+1} = reluLayer(layerNumber);

    % --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --
    layerNumber = layerNumber + 2;
    net.layers{end+1} = convLayer(layerNumber, 1, 64, 10, 5/100, 0, 'compRand', 'gen', opts.networkArch);
    net.layers{end+1} = reluLayer(layerNumber);

    % --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --
    % Loss layer
    net.layers{end+1} = struct('type', 'softmaxloss');
  case 'alexnet-bottleneck'
    % --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --
    % --- --- ---                                                     --- --- --
    % --- --- ---               ALEXNET-BOTTLENECK                    --- --- --
    % --- --- ---                                                     --- --- --
    % --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --
    % k = [1,4,8,16,32]
    k = opts.bottleneckDivideBy;
    layerNumber = 1;
    net.layers{end+1} = convLayer(layerNumber, 5, 3, 96, 5/1000, 2, 'compRand', 'gen', opts.networkArch);
    net.layers{end+1} = reluLayer(layerNumber);

    % --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --
    layerNumber = layerNumber + 2;
    % net.layers{end+1} = convLayer(layerNumber, 5, 96, 256, 5/1000, 2, 'compRand', 'gen', opts.networkArch);
    net.layers{end+1} = convLayer(layerNumber, 5, 96, 96/k, 5/1000, 2, 'compRand', 'gen', opts.networkArch);
    net.layers{end+1} = convLayer(layerNumber, 5, 96/k, 256, 5/1000, 2, 'compRand', 'gen', opts.networkArch);
    net.layers{end+1} = reluLayer(layerNumber);
    net.layers{end+1} = poolingLayerAlexNet(layerNumber);

    % --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --
    layerNumber = layerNumber + 3;
    net.layers{end+1} = convLayer(layerNumber, 3, 256, 384, 5/1000, 1, 'compRand', 'gen', opts.networkArch);
    % net.layers{end+1} = convLayer(layerNumber, 3, 256, 256/k, 5/1000, 1, 'compRand', 'gen', opts.networkArch);
    % net.layers{end+1} = convLayer(layerNumber, 3, 256/k, 384, 5/1000, 1, 'compRand', 'gen', opts.networkArch);
    net.layers{end+1} = reluLayer(layerNumber);
    net.layers{end+1} = poolingLayerAlexNet(layerNumber);

    % --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --
    layerNumber = layerNumber + 3;
    net.layers{end+1} = convLayer(layerNumber, 3, 384, 384, 5/1000, 1, 'compRand', 'gen', opts.networkArch);
    % net.layers{end+1} = convLayer(layerNumber, 3, 384, 384/k, 5/1000, 1, 'compRand', 'gen', opts.networkArch);
    % net.layers{end+1} = convLayer(layerNumber, 3, 384/k, 384, 5/1000, 1, 'compRand', 'gen', opts.networkArch);
    net.layers{end+1} = reluLayer(layerNumber);

    % --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --
    layerNumber = layerNumber + 2;
    net.layers{end+1} = convLayer(layerNumber, 3, 384, 256, 5/1000, 1, 'compRand', 'gen', opts.networkArch);
    % net.layers{end+1} = convLayer(layerNumber, 3, 384, 384/k, 5/1000, 1, 'compRand', 'gen', opts.networkArch);
    % net.layers{end+1} = convLayer(layerNumber, 3, 384/k, 256, 5/1000, 1, 'compRand', 'gen', opts.networkArch);
    net.layers{end+1} = reluLayer(layerNumber);
    net.layers{end+1} = poolingLayerAlexNet(layerNumber);

    % --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --
    % FULLY CONNECTED
    layerNumber = layerNumber + 3;
    net.layers{end+1} = convLayer(layerNumber, 4, 256, 128, 5/1000, 0, 'compRand', 'gen', opts.networkArch);
    net.layers{end+1} = reluLayer(layerNumber);

    % --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --
    layerNumber = layerNumber + 2;
    net.layers{end+1} = convLayer(layerNumber, 1, 128, 64, 5/100, 0, 'compRand', 'gen', opts.networkArch);
    net.layers{end+1} = reluLayer(layerNumber);

    % --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --
    layerNumber = layerNumber + 2;
    net.layers{end+1} = convLayer(layerNumber, 1, 64, 10, 5/100, 0, 'compRand', 'gen', opts.networkArch);
    net.layers{end+1} = reluLayer(layerNumber);

    % --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --
    % Loss layer
    net.layers{end+1} = struct('type', 'softmaxloss');
end

% --------------------------------------------------------------------
function structuredLayer = convLayer(layerNumber, k, m, n, init_multiplier, pad, weightInitType, weightInitSource, networkArch);
  % weightInitType = {'compRand', '1D', '2D-mult', '2D-super', '2D-posneg', '2D-positive'}
  % weightInitSource = {'load' | 'gen'}
% --------------------------------------------------------------------
  switch weightInitSource
    case 'load'
      layerWeights = loadWeights(networkArch, layerNumber, weightInitType);
    case 'gen'
      if ~strcmp(weightInitType, 'compRand') % if weightInitType = {'1D' ,'2D-posneg','2D-mult', '2D-super'}
        utils = networkExtractionUtils;
        baselineWeights = loadWeights(networkArch, layerNumber, 'baseline'); % used for its size
      end
      switch weightInitType
        case 'compRand'
          layerWeights{1} = init_multiplier * randn(k, k, m, n, 'single');
          layerWeights{2} = zeros(1, n, 'single');
        case '1D'
          layerWeights = utils.gen1DGaussianWeightsFromBaseline(baselineWeights, layerNumber);
        case '2D-mult'
          layerWeights = utils.gen2DGaussianMultWeightsFromBaseline(baselineWeights, layerNumber);
        case '2D-super'
          layerWeights = utils.gen2DGaussianSuperWeightsFromBaseline(baselineWeights, layerNumber);
        case '2D-posneg'
          layerWeights = utils.gen2DGaussianPosNegWeightsFromBaseline(baselineWeights, layerNumber);
        otherwise
          throwException('unrecognized command');
      end
  end
  % if strcmp(weightInitType, '2D-posneg') || strcmp(weightInitType, '2D-mult') || strcmp(weightInitType, '2D-super')
  %   layerWeights2{1} = layerWeights{1} * .1;
  %   layerWeights2{2} = layerWeights{2} * .1;
  %   structuredLayer = constructConvLayer(layerNumber, layerWeights2, pad);
  % end
  structuredLayer = constructConvLayer(layerNumber, layerWeights, pad);

% --------------------------------------------------------------------
function weights = loadWeights(networkArch, layerNumber, weightInitType)
  % weightInitType = {
  %   'compRand' |
  %   'baseline' |
  %   '1D' |
  %   '2D-posneg' |
  %   '2D-mult' |
  %   '2D-super'
  % }
% --------------------------------------------------------------------
  fprintf( ...
    '[INFO] Loading %s weights (layer %d) from saved directory...\t', ...
    weightInitType, ...
    layerNumber);
  devPath = getDevPath();

  % subDirPath = fullfile('data', 'cifar-alexnet', sprintf('+8epoch-%s', weightInitType));
  % TODO: search subtstring... if networkArch starts with 'alexnet' use the 'alexnet' folder
  switch networkArch
    case 'lenet'
      subDirPath = fullfile('data', 'cifar-lenet', sprintf('+8epoch-%s', weightInitType));
    otherwise % {'alexnet', 'alexnet-bnorm', 'alexnet-bottleneck', ...}
      subDirPath = fullfile('data', 'cifar-alexnet', sprintf('+8epoch-%s', weightInitType));
  end
  fileNameSuffix = sprintf('-layer-%d.mat', layerNumber);
  tmp = load(fullfile(devPath, subDirPath, sprintf('W1%s', fileNameSuffix)));
  weights{1} = tmp.W1;
  tmp = load(fullfile(devPath, subDirPath, sprintf('W2%s', fileNameSuffix)));
  weights{2} = tmp.W2;
  fprintf('Done!\n');

% --------------------------------------------------------------------
function structuredLayer = constructConvLayer(index, weights, pad)
% --------------------------------------------------------------------
  structuredLayer = struct( ...
    'type', 'conv', ...
    'name', sprintf('conv%s', index), ...
    'weights', {weights}, ...
    'stride', 1, ...
    'pad', pad);

% --------------------------------------------------------------------
function structuredLayer = reluLayer(layerNumber)
% --------------------------------------------------------------------
  structuredLayer = struct( ...
    'type', 'relu', ...
    'name', sprintf('relu%s', layerNumber));

% --------------------------------------------------------------------
function structuredLayer = poolingLayer(layerNumber)
% --------------------------------------------------------------------
  structuredLayer = struct( ...
    'type', 'pool', ...
    'name', sprintf('pool%s', layerNumber), ...
    'method', 'max', ...
    'pool', [2 2], ...
    'stride', 2, ...
    'pad', 0); % Emulate caffe

% --------------------------------------------------------------------
function structuredLayer = poolingLayerAlexNet(layerNumber)
% --------------------------------------------------------------------
  structuredLayer = struct( ...
    'type', 'pool', ...
    'name', sprintf('pool%s', layerNumber), ...
    'method', 'max', ...
    'pool', [3 3], ...
    'stride', 2, ...
    'pad', [0 1 0 1]); % Emulate caffe

% --------------------------------------------------------------------
function structuredLayer = poolingLayerLeNetAvg(layerNumber)
% --------------------------------------------------------------------
  structuredLayer = struct( ...
    'type', 'pool', ...
    'name', sprintf('pool%s', layerNumber), ...
    'method', 'avg', ...
    'pool', [3 3], ...
    'stride', 2, ...
    'pad', [0 1 0 1]); % Emulate caffe

% --------------------------------------------------------------------
function structuredLayer = poolingLayerLeNetMax(layerNumber)
% --------------------------------------------------------------------
  structuredLayer = struct( ...
    'type', 'pool', ...
    'name', sprintf('pool%s', layerNumber), ...
    'method', 'max', ...
    'pool', [3 3], ...
    'stride', 2, ...
    'pad', [0 1 0 1]); % Emulate caffe

% --------------------------------------------------------------------
function structuredLayer = bnormLayer(layerNumber, ndim)
% --------------------------------------------------------------------
  structuredLayer = struct( ...
    'type', 'bnorm', ...
    'weights', {{ones(ndim, 1, 'single'), zeros(ndim, 1, 'single')}}, ...
    'learningRate', [1 1], ...
    'weightDecay', [0 0]);

% --------------------------------------------------------------------
function throwException(msg)
% --------------------------------------------------------------------
  msgID = 'MYFUN:BadIndex';
  throw(MException(msgID,msg));
