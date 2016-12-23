function [net, results] = cnn_amir(inputs_opts)
  run(fullfile(fileparts(mfilename('fullpath')), ...
    '..', 'matlab', 'vl_setupnn.m'));

  % -------------------------------------------------------------------------
  %                                                              opts.general
  % -------------------------------------------------------------------------
  opts.general.dataset = getValueFromFieldOrDefault(inputs_opts, 'dataset', 'cifar');
  opts.general.network_arch = getValueFromFieldOrDefault(inputs_opts, 'network_arch', 'lenet');
  opts.general.debug_flag = getValueFromFieldOrDefault(inputs_opts, 'debug_flag', true);

  % -------------------------------------------------------------------------
  %                                                                  opts.net
  % -------------------------------------------------------------------------
  opts.net.net = getValueFromFieldOrDefault(inputs_opts, 'network', struct()); % may optionally pass in the network
  opts.net.weight_init_source = getValueFromFieldOrDefault(inputs_opts, 'weight_init_source', 'gen');
  opts.net.weight_init_sequence = getValueFromFieldOrDefault(inputs_opts, 'weight_init_sequence', {'compRand', 'compRand', 'compRand'});

  % -------------------------------------------------------------------------
  %                                                                 opts.imdb
  % -------------------------------------------------------------------------
  opts.imdb.imdb = getValueFromFieldOrDefault(inputs_opts, 'imdb', struct()); % may optionally pass in the imdb
  opts.imdb.data_dir = fullfile(getDevPath(), 'data', 'source', sprintf('%s', opts.general.dataset));
  opts.imdb.whiten_data = getValueFromFieldOrDefault(inputs_opts, 'whiten_data', true);
  opts.imdb.contrast_normalization = getValueFromFieldOrDefault(inputs_opts, 'contrast_normalization', true);
  opts.imdb.regen = getValueFromFieldOrDefault(inputs_opts, 'regen', false);
  opts.imdb.portion = getValueFromFieldOrDefault(inputs_opts, 'portion', 1.0);

  % -------------------------------------------------------------------------
  %                                                                opts.train
  % -------------------------------------------------------------------------
  opts.train.gpus = getValueFromFieldOrDefault(inputs_opts, 'gpus', getDefaultProcessor());
  opts.train.backprop_depth = getValueFromFieldOrDefault(inputs_opts, 'backprop_depth', 4);
  opts.train.batch_size = getValueFromFieldOrDefault(inputs_opts, 'batch_size', 100);
  opts.train.error_function = getErrorFunctionForDataset(opts.general.dataset);
  opts.train.learning_rate = getValueFromFieldOrDefault(inputs_opts, 'learning_rate', [0.05*ones(1,10) 0.005*ones(1,20) 0.001*ones(1,20)]);
  opts.train.num_epochs = getValueFromFieldOrDefault(inputs_opts, 'num_epochs', numel(opts.train.learning_rate));
  opts.train.weight_decay = getValueFromFieldOrDefault(inputs_opts, 'weight_decay', 0.0001);

  % -------------------------------------------------------------------------
  %                                                                opts.other
  % -------------------------------------------------------------------------
  opts.other.backprop_depth_string = sprintf('bpd-%02d', opts.train.backprop_depth);
  opts.other.time_string = sprintf('%s',datetime('now', 'Format', 'd-MMM-y-HH-mm-ss'));
  opts.other.processor_string = getProcessorStringFromProcessorList(opts.train.gpus);

  % -------------------------------------------------------------------------
  %                                                                opts.paths
  % -------------------------------------------------------------------------
  opts.paths.experiment_parent_dir = getValueFromFieldOrDefault( ...
    inputs_opts, ...
    'experiment_parent_dir', ...
    fullfile(vl_rootnn, 'experiment_results'));
  opts.paths.experiment_dir = fullfile(opts.paths.experiment_parent_dir, sprintf( ...
    '%s-%s-%s-%s-%s', ...
    opts.general.dataset, ...
    opts.general.network_arch, ...
    opts.other.time_string, ...
    opts.other.processor_string, ...
    opts.other.backprop_depth_string));
  opts.paths.imdb_dir = fullfile(getDevPath(), 'data', 'imdb', sprintf( ...
    '%s-%s', ...
    opts.general.dataset, ...
    opts.general.network_arch));
  opts.paths.imdb_path = fullfile(opts.paths.imdb_dir, 'imdb.mat');
  opts.paths.options_file_path = fullfile(opts.paths.experiment_dir, 'options.txt');
  opts.paths.results_file_path = fullfile(opts.paths.experiment_dir, 'results.txt');

  % create dirs if not exist
  if ~exist(opts.paths.experiment_dir)
    mkdir(opts.paths.experiment_dir);
  end
  if ~exist(opts.paths.imdb_dir)
    mkdir(opts.paths.imdb_dir);
  end

  % -------------------------------------------------------------------------
  %                                                               get network
  % -------------------------------------------------------------------------
  output_opts = cnnAmirInit(opts);
  opts.net = mergeStructs(opts.net, output_opts.net);
  opts.train = mergeStructs(opts.train, output_opts.train);
  % opts.train.weight_init_sequence = printWeightInitSequence(opts.net.weight_init_sequence); % TODO really needed?

  % -------------------------------------------------------------------------
  %                                                                  get imdb
  % -------------------------------------------------------------------------
  if numel(fields(opts.imdb.imdb)) % meaning an imdb was passed in as input
    imdb = opts.imdb.imdb;
  else
    if ~opts.imdb.regen && exist(opts.paths.imdb_path, 'file') % if already created, and we're not asking for regen
      imdb = load(opts.paths.imdb_path);
    else % else just construct the imdb
      switch opts.general.dataset
        case 'prostate'
          imdb = constructProstateImdb(opts);
        case 'cifar'
          imdb = constructCifarImdb(opts);
        case 'coil-100'
          imdb = constructCOIL100Imdb(opts);
        case 'mnist'
          imdb = constructMnistImdb(opts);
        case 'mnist-two-class-unbalanced'
          imdb = constructMnistUnbalancedTwoClassImdb(opts.imdb.data_dir, opts.general.network_arch);
        case 'stl-10'
          imdb = constructSTL10Imdb(opts);
      end
      if opts.general.debug_flag; afprintf(sprintf('[INFO] saving new imdb... ')); end;
      save(opts.paths.imdb_path, '-struct', 'imdb');
      if opts.general.debug_flag; afprintf(sprintf('done.\n\n')); end;
    end
  end
  opts.imdb.imdb = imdb;

  % -------------------------------------------------------------------------
  %                          save experiment setup (don't save imdb or net!!)
  % -------------------------------------------------------------------------
  opts_copy = opts;
  % opts_copy.net = rmfield(opts_copy.net, 'net');
  % opts_copy.imdb = rmfield(opts_copy.imdb, 'imdb');
  opts_copy.net.net = '< too large to print net >';
  opts_copy.imdb.imdb = '< too large to print imdb >';
  saveStruct2File(opts_copy, opts.paths.options_file_path, 0);

  % -------------------------------------------------------------------------
  %               TESTING (REMOVE): testing balanced imdb into single network
  % -------------------------------------------------------------------------
  data_train = imdb.images.data(:,:,:,imdb.images.set == 1);
  labels_train = imdb.images.labels(imdb.images.set == 1);
  data_test = imdb.images.data(:,:,:,imdb.images.set == 3);
  labels_test = imdb.images.labels(imdb.images.set == 3);

  [resampled_data_train, resampled_labels_train] = balanceTrainingData(data_train, labels_train, 50 / 50);
  imdb.images.data = single(cat(4, resampled_data_train, data_test));
  imdb.images.labels = single(cat(2, resampled_labels_train, labels_test));
  imdb.images.set = cat(2, 1 * ones(1, length(resampled_labels_train)), 3 * ones(1, length(labels_test)));

  fh_imdb_utils = imdbUtils;
  [~] = fh_imdb_utils.getImdbInfo(imdb, true);
  opts.imdb.imdb = imdb;

  % -------------------------------------------------------------------------
  %                                                                     train
  % -------------------------------------------------------------------------
  [net, info] = cnnTrain(opts.net.net, opts.imdb.imdb, getBatch(), ...
    opts.train, ...
    'experiment_dir', opts.paths.experiment_dir, ...
    'debug_flag', opts.general.debug_flag, ...
    'val', find(opts.imdb.imdb.images.set == 3));

  % -------------------------------------------------------------------------
  %                                             delete all but last net files
  % -------------------------------------------------------------------------
  for epoch = 1:opts.train.num_epochs - 1
    file_name = sprintf('net-epoch-%d.mat', epoch);
    delete(fullfile(opts.paths.experiment_dir, file_name));
  end

  % -------------------------------------------------------------------------
  %                                        accuracy, sensitivity, specificity
  % -------------------------------------------------------------------------
  % TODO: should net & imdb even be part of the opts file?? no!
  [ST,~] = dbstack();
  results = {};
  if strcmp(ST(2).file, 'mainCnnAmir.m')
    predictions_train = getPredictionsFromNetOnImdb(net, imdb, 1);
    predictions_test = getPredictionsFromNetOnImdb(net, imdb, 3);
    labels_train = imdb.images.labels(imdb.images.set == 1);
    labels_test = imdb.images.labels(imdb.images.set == 3);
    [ ...
      results.train.acc, ...
      results.train.sens, ...
      results.train.spec, ...
    ] = getAccSensSpec(labels_train, predictions_train, true);
    [ ...
      results.test.acc, ...
      results.test.sens, ...
      results.test.spec, ...
    ] = getAccSensSpec(labels_test, predictions_test, true);
    saveStruct2File(results, opts.paths.results_file_path, 0);
  end
  results.info = info;

% -------------------------------------------------------------------------
function error_function = getErrorFunctionForDataset(dataset)
% -------------------------------------------------------------------------
  if strcmp(dataset, 'prostate')
    error_function = 'multiclass-prostate';
  else
    error_function = 'multiclass';
  end

% -------------------------------------------------------------------------
function processor = getDefaultProcessor()
% -------------------------------------------------------------------------
  if ispc
    processor = [1]; % GPU at index 1
  else
    processor = [];
  end

% -------------------------------------------------------------------------
function processor_string = getProcessorStringFromProcessorList(processor_list)
% -------------------------------------------------------------------------
  if numel(processor_list)
    processor_string = sprintf('GPU-%d', processor_list(1));
  else
    processor_string = 'CPU';
  end

% -------------------------------------------------------------------------
function fn = getBatch()
% -------------------------------------------------------------------------
  fn = @(x,y) getSimpleNNBatch(x,y);

% -------------------------------------------------------------------------
function [images, labels] = getSimpleNNBatch(imdb, batch)
% -------------------------------------------------------------------------
  images = imdb.images.data(:,:,:,batch);
  labels = imdb.images.labels(1,batch);
  if rand > 0.5, images=fliplr(images); end

% -------------------------------------------------------------------------
function [resampled_data, resampled_labels] = balanceTrainingData(data, labels, ratio)
% -------------------------------------------------------------------------
  %% -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  % Initial stuff
  %% -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  data_healthy = data(:,:,:,labels == 1);
  data_cancer = data(:,:,:,labels == 2);
  data_count = size(data, 4);
  data_healthy_count = size(data_healthy, 4);
  data_cancer_count = size(data_cancer, 4);
  data_healthy_indices = find(labels == 1);
  data_cancer_indices = find(labels == 2);

  %% -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  % Random Under-sampling (RUS): Healthy Data
  %% -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  downsampled_data_healthy_count = round(data_cancer_count * ratio);
  downsampled_data_healthy_indices = randsample(data_healthy_indices, downsampled_data_healthy_count, false);
  downsampled_data_healthy = data(:,:,:, downsampled_data_healthy_indices);

  % %% -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  % % Weighted Upsampling (more weight -> more repeat): Healthy & Cancer Data
  % %% -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  % max_repeat_healthy = 25;
  % max_repeat_cancer = 200;
  % normalized_weights = weights / min(weights);
  % repeat_counts = ceil(normalized_weights);
  % for j = data_healthy_indices
  %   if repeat_counts(j) > max_repeat_healthy
  %     repeat_counts(j) = max_repeat_healthy;
  %   end
  % end
  % for j = data_cancer_indices
  %   if repeat_counts(j) > max_repeat_cancer
  %     repeat_counts(j) = max_repeat_cancer;
  %   end
  % end

  % healthy_repeat_counts = repeat_counts(downsampled_data_healthy_indices);
  % cancer_repeat_counts = repeat_counts(data_cancer_indices);

  % upsampled_data_healthy = upsample(downsampled_data_healthy, healthy_repeat_counts);
  % upsampled_data_cancer = upsample(data_cancer, cancer_repeat_counts);

  %% -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  % Putting it all together
  %% -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  resampled_data_healthy_count = size(downsampled_data_healthy, 4);
  resampled_data_cancer_count = size(data_cancer, 4);
  resampled_data_all = cat(4, downsampled_data_healthy, data_cancer);
  resampled_labels_all = cat( ...
    2, ...
    1 * ones(1, resampled_data_healthy_count), ...
    2 * ones(1, resampled_data_cancer_count));

  %% -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  % Shuffle this to mixup order of healthy and cancer in imdb so we don't
  % have the CNN overtrain in 1 particular direction. Only shuffling for
  % training; later weights are calculated and updated for all training data.
  %% -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  ix = randperm(size(resampled_data_all, 4));
  resampled_data = resampled_data_all(:,:,:,ix);
  resampled_labels = resampled_labels_all(ix);