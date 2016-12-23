function fh = cnnRusboost()
  % assign function handles so we can call these local functions from elsewhere
  fh.getInitialImdb = @getInitialImdb;
  fh.mainCNNRusboost = @mainCNNRusboost;
  fh.kFoldCNNRusboost = @kFoldCNNRusboost;
  fh.testAllEnsembleModelsOnTestImdb = @testAllEnsembleModelsOnTestImdb;
  fh.saveKFoldResults = @saveKFoldResults;
  fh.printKFoldResults = @printKFoldResults;

% -------------------------------------------------------------------------
function folds = kFoldCNNRusboost()
% -------------------------------------------------------------------------
  % -------------------------------------------------------------------------
  %                                                               opts.general
  % -------------------------------------------------------------------------
  opts.general.dataset = 'mnist-two-class-unbalanced';
  switch opts.general.dataset
    case 'mnist-two-class-unbalanced'
      opts.general.network_arch = 'lenet';
    case 'prostate'
      opts.general.network_arch = 'prostatenet';
  end
  opts.general.number_of_folds = 1;
  opts.general.iteration_count_limit = 3;

  % -------------------------------------------------------------------------
  %                                                                  opts.imdb
  % -------------------------------------------------------------------------
  switch opts.general.dataset
    case 'mnist-two-class-unbalanced'
      opts.imdb.source = 'load'; % {'gen', 'load'}
    case 'prostate'
      opts.imdb.num_patients = 104;
      opts.imdb.leave_out_type = 'special';
      opts.imdb.contrast_normalization = true;
      % opts.imdb.whitenData = true;
      opts.imdb.train_balance = false;
      opts.imdb.train_augment_negative = 'none';
      opts.imdb.train_augment_positive = 'none';
      opts.imdb.test_balance = false;
      opts.imdb.test_augment_negative = 'none';
      opts.imdb.test_augment_positive = 'none';
  end

  % -------------------------------------------------------------------------
  %                                                                opts.paths
  % -------------------------------------------------------------------------
  opts.paths.data_dir = ...
    fullfile(getDevPath(), 'data', 'source', sprintf('%s', opts.general.dataset));
  opts.paths.time_string = ...
    sprintf('%s',datetime('now', 'Format', 'd-MMM-y-HH-mm-ss'));
  opts.paths.experiment_dir = ...
    fullfile( ...
      'experiment_results', ...
      sprintf('k-fold-rusboost-%s', opts.paths.time_string));
  if ~exist(opts.paths.experiment_dir)
    mkdir(opts.paths.experiment_dir);
  end
  opts.paths.folds_file_path = fullfile(opts.paths.experiment_dir, 'folds.mat');
  opts.paths.options_file_path = fullfile(opts.paths.experiment_dir, 'options.txt');
  opts.paths.results_file_path = fullfile(opts.paths.experiment_dir, 'results.txt');

  % -------------------------------------------------------------------------
  %                                                    save experiment setup!
  % -------------------------------------------------------------------------
  saveStruct2File(opts, opts.paths.options_file_path, 0);

  % -------------------------------------------------------------------------
  %                                                                     start
  % -------------------------------------------------------------------------
  afprintf(sprintf( ...
    '[INFO] Running K-fold CNN Rusboost (K = %d)...\n', ...
    opts.general.number_of_folds), 1);

  % -------------------------------------------------------------------------
  %                                             create the imdb for each fold
  % -------------------------------------------------------------------------
  imdbs = {}; % separate so don't have to save ~1.5 GB of imdbs!!!

  switch opts.general.dataset
    case 'mnist-two-class-unbalanced'
      for i = 1:opts.general.number_of_folds
        afprintf(sprintf('\n'));
        afprintf(sprintf('[INFO] Constructing / loading imdb for fold #%d...\n', i));
        switch opts.imdb.source
          case 'gen'
            imdb = constructMnistUnbalancedTwoClassImdb( ...
              opts.paths.data_dir, ...
              opts.general.network_arch);
          case 'load'
            tmp = load(fullfile(getDevPath(), 'data', 'saved-two-class-mnist.mat'));
            imdb = tmp.imdb;
        end
        imdbs{i} = imdb;
        afprintf(sprintf('[INFO] done!\n'));
      end
    case 'prostate'
      patients_per_fold = ceil(opts.imdb.num_patients / opts.general.number_of_folds);
      random_patient_indices = randperm(104);
      for i = 1:opts.general.number_of_folds
        afprintf(sprintf('\n'));
        afprintf(sprintf('[INFO] Randomly dividing for fold #%d...\n', i));
        start_index = 1 + (i - 1) * patients_per_fold;
        end_index = min(104, i * patients_per_fold);
        folds.(sprintf('fold_%d', i)).patient_indices = ...
          random_patient_indices(start_index : end_index);
        afprintf(sprintf('[INFO] done!\n'));
        afprintf(sprintf('[INFO] Constructing imdb for fold #%d...\n', i));
        opts.imdb.leave_out_indices = folds.(sprintf('fold_%d', i)).patient_indices;
        imdb = constructProstateImdb(opts.imdb);
        imdbs{i} = imdb;
        afprintf(sprintf('[INFO] done!\n'));
      end
  end

  % -------------------------------------------------------------------------
  %                                        train ensemble larp for each fold!
  % -------------------------------------------------------------------------
  single_ensemble_options.dataset = opts.general.dataset;
  single_ensemble_options.network_arch = opts.general.network_arch;
  single_ensemble_options.iteration_count = opts.general.iteration_count_limit;
  single_ensemble_options.experiment_parent_dir = opts.paths.experiment_dir;
  for i = 1:opts.general.number_of_folds
    afprintf(sprintf('[INFO] Running cnn_rusboost on fold #%d...\n', i));
    single_ensemble_options.imdb = imdbs{i};
    [ ...
      folds.(sprintf('fold_%d', i)).ensemble_models, ...
      folds.(sprintf('fold_%d', i)).weighted_results, ...
    ] = mainCNNRusboost(single_ensemble_options);
    % overwrite and save results so far
    save(opts.paths.folds_file_path, 'folds');
    saveKFoldResults(folds, opts.paths.results_file_path);
  end

  % -------------------------------------------------------------------------
  %                                                             print results
  % -------------------------------------------------------------------------
  printKFoldResults(folds);

% -------------------------------------------------------------------------
function [ensemble_models, weighted_results] = mainCNNRusboost(ensemble_options)
% -------------------------------------------------------------------------
  % -------------------------------------------------------------------------
  %                                                              opts.general
  % -------------------------------------------------------------------------
  imdb = getValueFromFieldOrDefault(ensemble_options, 'imdb', struct());
  opts.general.dataset = getValueFromFieldOrDefault( ...
    ensemble_options, ...
    'dataset', ...
    'prostate');
  opts.general.network_arch = getValueFromFieldOrDefault( ...
    ensemble_options, ...
    'network_arch', ...
    'prostatenet');
  opts.general.iteration_count = getValueFromFieldOrDefault( ...
    ensemble_options, ...
    'iteration_count', ...
    5);
  opts.general.random_undersampling_ratio = (50/50);

  % -------------------------------------------------------------------------
  %                                                                opts.paths
  % -------------------------------------------------------------------------
  opts.paths.time_string = sprintf('%s',datetime('now', 'Format', 'd-MMM-y-HH-mm-ss'));
  opts.paths.experiment_parent_dir = getValueFromFieldOrDefault( ...
    ensemble_options, ...
    'experiment_parent_dir', ...
    fullfile(vl_rootnn, 'experiment_results'));
  opts.paths.experiment_dir = fullfile(opts.paths.experiment_parent_dir, sprintf( ...
    'rusboost-%s-%s-%s', ...
    opts.general.dataset, ...
    opts.general.network_arch, ...
    opts.paths.time_string));
  if ~exist(opts.paths.experiment_dir)
    mkdir(opts.paths.experiment_dir);
  end
  opts.paths.options_file_path = fullfile(opts.paths.experiment_dir, 'options.txt');
  opts.paths.results_file_path = fullfile(opts.paths.experiment_dir, 'results.txt');
  opts.paths.ensemble_models_file_path = fullfile(opts.paths.experiment_dir, 'ensemble_models.mat');

  % -------------------------------------------------------------------------
  %                                                   opts.single_cnn_options
  % -------------------------------------------------------------------------
  opts.single_cnn_options.dataset = opts.general.dataset;
  opts.single_cnn_options.network_arch = opts.general.network_arch;
  opts.single_cnn_options.experiment_parent_dir = opts.paths.experiment_dir;
  opts.single_cnn_options.weight_init_source = 'gen';
  opts.single_cnn_options.weight_init_sequence = {'compRand', 'compRand', 'compRand'};
  opts.single_cnn_options.gpus = ifNotMacSetGpu(2);
  opts.single_cnn_options.backprop_depth = 13;
  opts.single_cnn_options.debug_flag = false;

  % -------------------------------------------------------------------------
  %                                                    save experiment setup!
  % -------------------------------------------------------------------------
  saveStruct2File(opts, opts.paths.options_file_path, 0);

  % -------------------------------------------------------------------------
  %                     2. process the imdb to separate positive and negative
  %                               samples (to be randomly-undersampled later)
  % -------------------------------------------------------------------------

  [ ...
    data_train, ...
    data_train_positive, ...
    data_train_negative, ...
    data_train_count, ...
    data_train_positive_count, ...
    data_train_negative_count, ...
    labels_train, ...
    data_test, ...
    data_test_positive, ...
    data_test_negative, ...
    data_test_count, ...
    data_test_positive_count, ...
    data_test_negative_count, ...
    labels_test, ...
  ] = getImdbInfo(imdb, 1);

  % -------------------------------------------------------------------------
  %                                     3. initialize training sample weights
  % -------------------------------------------------------------------------
  % W stores the weights of the instances in each row for every iteration of
  % boosting. Weights for all the instances are initialized by 1/m for the
  % first iteration.
  W = 1 / data_train_count * ones(1, data_train_count);

  % L stores pseudo loss values, H stores hypothesis, B stores (1/beta)
  % values that is used as the weight of the % hypothesis while forming the
  % final hypothesis. % All of the following are of length <=T and stores
  % values for every iteration of the boosting process.
  L = [];
  H = {};
  B = [];

  t = 1; % loop counter
  count = 1; % number of times the same boosting iteration have been repeated

  % -------------------------------------------------------------------------
  %                       4. create training (barebones) and validation imdbs
  % -------------------------------------------------------------------------
  training_resampled_imdb = constructPartialImdb([], [], 3); % barebones; filled in below
  validation_imdb = constructPartialImdb(data_train, labels_train, 3);
  test_imdb = constructPartialImdb(data_test, labels_test, 3);

  % -------------------------------------------------------------------------
  %                              5. go through T iterations of RUSBoost, each
  %                                              training a CNN over E epochs
  % -------------------------------------------------------------------------
  printConsoleOutputSeparator();
  ensemble_models = {};
  while t <= opts.general.iteration_count
    afprintf(sprintf('\n'));
    afprintf(sprintf('[INFO] Boosting iteration #%d (attempt %d)...\n', t, count));

    % Resampling NEG_DATA with weights of positive example
    afprintf(sprintf('[INFO] Resampling negative and positive data (ratio = %3.6f)... ', opts.general.random_undersampling_ratio));

    [resampled_data, resampled_labels] = ...
      resampleData(data_train, labels_train, W(t, :), opts.general.random_undersampling_ratio);
    afprintf(sprintf('done!\n'));

    training_resampled_imdb.images.data = single(resampled_data);
    training_resampled_imdb.images.labels = single(resampled_labels);
    training_resampled_imdb.images.set = 1 * ones(length(resampled_labels), 1);

    afprintf(sprintf('[INFO] Training model (negative: %d, positive: %d)...\n', ...
      numel(find(resampled_labels == 1)), ...
      numel(find(resampled_labels == 2))));
    opts.single_cnn_options.imdb = training_resampled_imdb;
    [net, ~] = cnnAmir(opts.single_cnn_options);

    % IMPORTANT NOTE: we randomly undersample when training a model, but then,
    % we use all of the training samples (in their order) to update weights.
    afprintf(sprintf('[INFO] Computing validation set predictions (negative: %d, positive: %d)...\n', ...
      data_train_negative_count, ...
      data_train_positive_count));
    validation_predictions = getPredictionsFromNetOnImdb(net, validation_imdb, 3);
    [ ...
      validation_acc, ...
      validation_sens, ...
      validation_spec, ...
    ] = getAccSensSpec(labels_train, validation_predictions, true);

    % Computing the pseudo loss of hypothesis 'model'
    afprintf(sprintf('[INFO] Computing pseudo loss... '));
    negative_to_positive_ratio = data_train_negative_count / data_train_positive_count;
    loss = 0;
    for i = 1:data_train_count
      if labels_train(i) == validation_predictions(i)
        continue;
      else
        loss = loss + W(t, i);
      end
    end
    fprintf('Loss: %6.5f\n', loss);

    % If count exceeds a pre-defined threshold (5 in the current implementation)
    % the loop is broken and rolled back to the state where loss > 0.5 was not
    % encountered.
    if count > 5
      L = L(1:t-1);
      H = H(1:t-1);
      B = B(1:t-1);
      afprintf(sprintf('Too many iterations have loss > 0.5\n'));
      afprintf(sprintf('Aborting boosting...\n'));
      break;
    end

    % If the loss is greater than 1/2, it means that an inverted hypothesis
    % would perform better. In such cases, do not take that hypothesis into
    % consideration and repeat the same iteration. 'count' keeps counts of
    % the number of times the same boosting iteration have been repeated
    if loss > 0.5
      count = count + 1;
      continue;
    else
      count = 1;
    end

    H{t} = net; % Hypothesis function / Trained CNN Network
    L(t) = loss; % Pseudo-loss at each iteration
    beta = loss / (1 - loss); % Setting weight update parameter 'beta'.
    B(t) = log(1 / beta); % Weight of the hypothesis

    % % At the final iteration there is no need to update the weights any
    % % further
    % if t == opts.general.iteration_count
    %     break;
    % end

    % Updating weight
    afprintf(sprintf('[INFO] Updating weights... '));
    for i = 1:data_train_count
      if labels_train(i) == validation_predictions(i)
        W(t + 1, i) = W(t, i) * beta;
      else
        if labels_train(i) == 2
          % W(t + 1, i) = min(negative_to_positive_ratio, 5) * W(t, i);
          W(t + 1, i) = W(t, i);
        else
          W(t + 1, i) = W(t, i);
        end
      end
    end
    fprintf('done!\n');

    % Normalizing the weight for the next iteration
    sum_W = sum(W(t + 1, :));
    for i = 1:data_train_count
      W(t + 1, i) = W(t + 1, i) / sum_W;
    end

    % -------------------------------------------------------------------------
    %                                       6. test on single model of ensemble
    % -------------------------------------------------------------------------
    afprintf(sprintf('[INFO] Computing test set predictions (negative: %d, positive: %d)...\n', ...
      data_test_negative_count, ...
      data_test_positive_count));
    test_predictions = getPredictionsFromNetOnImdb(net, test_imdb, 3);
    [ ...
      test_acc, ...
      test_sens, ...
      test_spec, ...
    ] = getAccSensSpec(labels_test, test_predictions, true);

    % -------------------------------------------------------------------------
    %                                          7. save single model of ensemble
    % -------------------------------------------------------------------------
    afprintf(sprintf('[INFO] Saving model and info... '));
    ensemble_models{t}.model_net = H{t};
    ensemble_models{t}.model_loss = L(t);
    ensemble_models{t}.model_weight = B(t);
    ensemble_models{t}.train_negative_count = numel(find(resampled_labels == 1));
    ensemble_models{t}.train_positive_count = numel(find(resampled_labels == 2));
    ensemble_models{t}.validation_negative_count = data_train_negative_count;
    ensemble_models{t}.validation_positive_count = data_train_positive_count;
    ensemble_models{t}.validation_predictions = validation_predictions;
    ensemble_models{t}.validation_labels = labels_train;
    ensemble_models{t}.validation_accuracy = validation_acc;
    ensemble_models{t}.validation_sensitivity = validation_sens;
    ensemble_models{t}.validation_specificity = validation_spec;
    ensemble_models{t}.validation_weights_pre_update = W(t,:);
    ensemble_models{t}.validation_weights_post_update = W(t + 1,:);
    ensemble_models{t}.test_negative_count = data_test_negative_count;
    ensemble_models{t}.test_positive_count = data_test_positive_count;
    ensemble_models{t}.test_predictions = test_predictions;
    ensemble_models{t}.test_labels = labels_test;
    ensemble_models{t}.test_accuracy = test_acc;
    ensemble_models{t}.test_sensitivity = test_sens;
    ensemble_models{t}.test_specificity = test_spec;
    save(opts.paths.ensemble_models_file_path, 'ensemble_models');
    fprintf('done!\n');
    plotThisShit(ensemble_models, opts.paths.experiment_dir);
    % Incrementing loop counter
    t = t + 1;
  end

  % -------------------------------------------------------------------------
  % 8. test on test set, keeping in mind beta's between each mode
  % -------------------------------------------------------------------------
  % The final hypothesis is calculated and tested on the test set simulteneously
  printConsoleOutputSeparator();
  weighted_results = testAllEnsembleModelsOnTestImdb(ensemble_models, imdb);
  printConsoleOutputSeparator();

% -------------------------------------------------------------------------
function [ ...
  data_train, ...
  data_train_positive, ...
  data_train_negative, ...
  data_train_count, ...
  data_train_positive_count, ...
  data_train_negative_count, ...
  labels_train, ...
  data_test, ...
  data_test_positive, ...
  data_test_negative, ...
  data_test_count, ...
  data_test_positive_count, ...
  data_test_negative_count, ...
  labels_test] = getImdbInfo(imdb, print_info)
% -------------------------------------------------------------------------

  % indices
  train_indices = imdb.images.set == 1;
  train_positive_indices = bsxfun(@and, imdb.images.labels == 2, imdb.images.set == 1);
  train_negative_indices = bsxfun(@and, imdb.images.labels == 1, imdb.images.set == 1);
  test_indices = imdb.images.set == 3;
  test_positive_indices = bsxfun(@and, imdb.images.labels == 2, imdb.images.set == 3);
  test_negative_indices = bsxfun(@and, imdb.images.labels == 1, imdb.images.set == 3);

  % train set
  data_train = imdb.images.data(:,:,:,train_indices);
  data_train_positive = imdb.images.data(:,:,:,train_positive_indices);
  data_train_negative = imdb.images.data(:,:,:,train_negative_indices);
  data_train_count = size(data_train, 4);
  data_train_positive_count = size(data_train_positive, 4);
  data_train_negative_count = size(data_train_negative, 4);
  labels_train = imdb.images.labels(train_indices);

  % test set
  data_test = imdb.images.data(:,:,:,test_indices);
  data_test_positive = imdb.images.data(:,:,:,test_positive_indices);
  data_test_negative = imdb.images.data(:,:,:,test_negative_indices);
  data_test_count = size(data_test, 4);
  data_test_positive_count = size(data_test_positive, 4);
  data_test_negative_count = size(data_test_negative, 4);
  labels_test = imdb.images.labels(test_indices);

  if print_info
    afprintf(sprintf('[INFO] TRAINING SET: total: %d, positive: %d, negative: %d\n', ...
      data_train_count, ...
      data_train_negative_count, ...
      data_train_positive_count));
    afprintf(sprintf('[INFO] TESTING SET: total: %d, positive: %d, negative: %d\n', ...
      data_test_count, ...
      data_test_negative_count, ...
      data_test_positive_count));
  end

% -------------------------------------------------------------------------
function [resampled_data, resampled_labels] = resampleData(data, labels, weights, ratio)
% -------------------------------------------------------------------------
  % -------------------------------------------------------------------------
  % Initial stuff
  % -------------------------------------------------------------------------
  data_negative = data(:,:,:,labels == 1);
  data_positive = data(:,:,:,labels == 2);
  data_count = size(data, 4);
  data_negative_count = size(data_negative, 4);
  data_positive_count = size(data_positive, 4);
  data_negative_indices = find(labels == 1);
  data_positive_indices = find(labels == 2);

  % -------------------------------------------------------------------------
  % Random Under-sampling (RUS): Negative Data
  % -------------------------------------------------------------------------
  weights_negative_indices = weights(1, data_negative_indices);
  downsampled_data_negative_count = round(data_positive_count * ratio);
  % just random sampling.... horrendously wrong
  % downsampled_data_negative_indices = randsample(data_negative_indices, downsampled_data_negative_count, false);
  % TODO: the line below is weighted sampling w/ replacement; the most accurate
  % way is to weighted randsample w/o replacement
  downsampled_data_negative_indices = randsample( ...
    data_negative_indices, ...
    downsampled_data_negative_count, ...
    true, ...
    weights_negative_indices);
  downsampled_data_negative = data(:,:,:, downsampled_data_negative_indices);


  % -------------------------------------------------------------------------
  % Weighted Upsampling (more weight -> more repeat): Negative & Positive Data
  % -------------------------------------------------------------------------
  max_repeat_negative = 25;
  max_repeat_positive = 200;
  normalized_weights = weights / min(weights);
  repeat_counts = ceil(normalized_weights);
  for j = data_negative_indices
    if repeat_counts(j) > max_repeat_negative
      repeat_counts(j) = max_repeat_negative;
    end
  end
  for j = data_positive_indices
    if repeat_counts(j) > max_repeat_positive
      repeat_counts(j) = max_repeat_positive;
    end
  end

  negative_repeat_counts = repeat_counts(downsampled_data_negative_indices);
  positive_repeat_counts = repeat_counts(data_positive_indices);

  upsampled_data_negative = upsample(downsampled_data_negative, negative_repeat_counts);
  upsampled_data_positive = upsample(data_positive, positive_repeat_counts);

  % -------------------------------------------------------------------------
  % Putting it all together
  % -------------------------------------------------------------------------
  resampled_data_negative_count = size(upsampled_data_negative, 4);
  resampled_data_positive_count = size(upsampled_data_positive, 4);
  resampled_data_all = cat(4, upsampled_data_negative, upsampled_data_positive);
  resampled_labels_all = cat( ...
    2, ...
    1 * ones(1, resampled_data_negative_count), ...
    2 * ones(1, resampled_data_positive_count));

  % -------------------------------------------------------------------------
  % Shuffle this to mixup order of negative and positive in imdb so we don't
  % have the CNN overtrain in 1 particular direction. Only shuffling for
  % training; later weights are calculated and updated for all training data.
  % -------------------------------------------------------------------------
  ix = randperm(size(resampled_data_all, 4));
  resampled_data = resampled_data_all(:,:,:,ix);
  resampled_labels = resampled_labels_all(ix);

% -------------------------------------------------------------------------
function [upsampled_data] = upsample(data, repeat_counts)
  % remember, data is 4D, with N 3D samples
% -------------------------------------------------------------------------
  assert(size(data, 4) == length(repeat_counts));
  total_repeat_count = sum(repeat_counts);
  upsampled_data = zeros(size(data, 1), size(data, 2), size(data, 3), total_repeat_count);
  counter = 1;
  for i = 1:length(repeat_counts)
    sample_repeat_count = repeat_counts(i);
    % repeated_sample = repmat(data(:,:,:,i), [1,1,1,sample_repeat_count]);
    repeated_sample_4D_matrix = augmentSample(data(:,:,:,i), sample_repeat_count, 'rotate-flip');
    upsampled_data(:,:,:, counter : counter + sample_repeat_count - 1) = repeated_sample_4D_matrix;
    counter = counter + sample_repeat_count;
  end

% -------------------------------------------------------------------------
function [repeated_sample_4D_matrix] = augmentSample(sample, repeat_count, augment_type)
  % augment_type = {'repmat', 'rotate', 'flip', 'rotate-flip'}
% -------------------------------------------------------------------------
  repeated_sample_4D_matrix = zeros(size(sample, 1), size(sample, 2), size(sample, 3), repeat_count);
  switch augment_type
    case 'repmat'
      repeated_sample_4D_matrix = repmat(sample, [1,1,1,repeat_count]);
    case 'rotate'
      degrees = linspace(0, 360, repeat_count);
      index = 1;
      for degree = degrees
        rotated_3D_image = imrotate(sample, degree, 'crop');
        repeated_sample_4D_matrix(:,:,:,index) = rotated_3D_image;
        index = index + 1;
      end
    case 'rotate-flip'
      degrees = linspace(0, 360, floor(repeat_count / 2));
      index = 1;
      for degree = degrees
        rotated_3D_image = imrotate(sample, degree, 'crop');
        repeated_sample_4D_matrix(:,:,:,index) = rotated_3D_image;
        repeated_sample_4D_matrix(:,:,:,index + 1) = fliplr(rotated_3D_image);
        index = index + 2;
      end
      if mod(repeat_count, 2)
        % because of the `floor()` above, the last index of
        % repeated_sample_4D_matrixhas not been augmented yet...
        % just make it a simple copy of sample.
        repeated_sample_4D_matrix(:,:,:,end) = sample;
      end
  end

% -------------------------------------------------------------------------
function imdb = constructPartialImdb(data, labels, set_number)
% -------------------------------------------------------------------------
  imdb.images.data = data;
  imdb.images.labels = labels;
  imdb.images.set = set_number * ones(length(labels), 1);
  imdb.meta.sets = {'train', 'val', 'test'};

% % -------------------------------------------------------------------------
% function imdb = getInitialImdb()
% % -------------------------------------------------------------------------
%   afprintf(sprintf('[INFO] Loading saved imdb... '));
%   imdbPath = fullfile(getDevPath(), '/matconvnet/data_1/_prostate/_saved_prostate_imdb.mat');
%   imdb = load(imdbPath);
%   imdb = imdb.imdb;
%   afprintf(sprintf('done!\n'));

% -------------------------------------------------------------------------
function plotThisShit(ensemble_models, experiment_dir)
% -------------------------------------------------------------------------
  num_models_in_ensemble = numel(ensemble_models);
  ensemble_models_validation_accuracy = zeros(1, num_models_in_ensemble);
  ensemble_models_validation_sensitivity = zeros(1, num_models_in_ensemble);
  ensemble_models_validation_specificity = zeros(1, num_models_in_ensemble);
  ensemble_models_test_accuracy = zeros(1, num_models_in_ensemble);
  ensemble_models_test_sensitivity = zeros(1, num_models_in_ensemble);
  ensemble_models_test_specificity = zeros(1, num_models_in_ensemble);
  for i = 1:num_models_in_ensemble
    ensemble_models_validation_accuracy(i) = ensemble_models{i}.validation_accuracy;
    ensemble_models_validation_sensitivity(i) = ensemble_models{i}.validation_sensitivity;
    ensemble_models_validation_specificity(i) = ensemble_models{i}.validation_specificity;
    ensemble_models_test_accuracy(i) = ensemble_models{i}.test_accuracy;
    ensemble_models_test_sensitivity(i) = ensemble_models{i}.test_sensitivity;
    ensemble_models_test_specificity(i) = ensemble_models{i}.test_specificity;
  end
  figure(2);
  clf;
  model_fig_path = fullfile(experiment_dir, 'incremental-performance.pdf');
  xlabel('training epoch'); ylabel('error');
  title('performance');
  grid on;
  hold on;
  plot(1:num_models_in_ensemble, ensemble_models_validation_accuracy, 'r.-', 'linewidth', 2);
  plot(1:num_models_in_ensemble, ensemble_models_validation_sensitivity, 'g.-', 'linewidth', 2);
  plot(1:num_models_in_ensemble, ensemble_models_validation_specificity, 'b.-', 'linewidth', 2);
  plot(1:num_models_in_ensemble, ensemble_models_test_accuracy, 'r.--', 'linewidth', 2);
  plot(1:num_models_in_ensemble, ensemble_models_test_sensitivity, 'g.--', 'linewidth', 2);
  plot(1:num_models_in_ensemble, ensemble_models_test_specificity, 'b.--', 'linewidth', 2);
  leg = { ...
    'val acc', ...
    'val sens', ...
    'val spec', ...
    'test acc', ...
    'test sens', ...
    'test spec', ...
  };
  set(legend(leg{:}),'color','none');
  drawnow;
  print(2, model_fig_path, '-dpdf');
%_p-------------------------------------------------------------------------
function weighted_results = testAllEnsembleModelsOnTestImdb(ensemble_models, imdb)
% -------------------------------------------------------------------------
  fprintf('\n');
  afprintf(sprintf('[INFO] ENSEMBLE RESULTS ON TEST SET: \n'));
  printConsoleOutputSeparator();
  % -------------------------------------------------------------------------
  % Initial stuff
  % -------------------------------------------------------------------------
  data_test = imdb.images.data(:,:,:,imdb.images.set == 3);
  labels_test = imdb.images.labels(imdb.images.set == 3);
  data_test_negative = data_test(:,:,:,labels_test == 1);
  data_test_positive = data_test(:,:,:,labels_test == 2);
  data_test_count = size(data_test, 4);
  data_test_negative_count = size(data_test_negative, 4);
  data_test_positive_count = size(data_test_positive, 4);

  % -------------------------------------------------------------------------
  % Construct IMDB
  % -------------------------------------------------------------------------
  test_imdb = constructPartialImdb(data_test, labels_test, 3);

  H = {};
  B = zeros(1, numel(ensemble_models));
  for i = 1:numel(B)
    H{i} = ensemble_models{i}.model_net;
    B(i) = ensemble_models{i}.model_weight;
  end
  assert(numel(H) == numel(B))
  B = B / sum(B);

  weighted_test_set_predictions = zeros(data_test_count, 2);
  test_set_predictions_per_model = {};
  for i = 1:size(H, 2) % looping through all trained networks
    afprintf(sprintf('\n'));
    afprintf(sprintf('[INFO] Computing test set predictions for model #%d (negative: %d, positive: %d)...\n', ...
      i, ...
      data_test_negative_count, ...
      data_test_positive_count));
    net = H{i};
    test_set_predictions_per_model{i} = getPredictionsFromNetOnImdb(net, test_imdb, 3);
    [acc, sens, spec] = getAccSensSpec(labels_test, test_set_predictions_per_model{i}, true);
  end

  for i = 1:data_test_count
    % Calculating the total weight of the class labels from all the models
    % produced during boosting
    wt_negative = 0; % class 1
    wt_positive = 0; % class 2
    for j = 1:size(H, 2) % looping through all trained networks
       p = test_set_predictions_per_model{j}(i);
       if p == 2 % if is positive
           wt_positive = wt_positive + B(j);
       else
           wt_negative = wt_negative + B(j);
       end
    end

    if (wt_positive > wt_negative)
        weighted_test_set_predictions(i,:) = [2 wt_positive];
    else
        weighted_test_set_predictions(i,:) = [1 wt_negative];
    end
  end

  % -------------------------------------------------------------------------
  % 7. done, go treat yourself to something sugary!
  % -------------------------------------------------------------------------
  printConsoleOutputSeparator();
  predictions_test = weighted_test_set_predictions(:, 1)';
  [weighted_acc, weighted_sens, weighted_spec] = getAccSensSpec(labels_test, predictions_test, false);
  afprintf(sprintf('Model weights: '))
  disp(B);
  afprintf(sprintf('[INFO] Weighted Acc: %3.6f\n', weighted_acc));
  afprintf(sprintf('[INFO] Weighted Sens: %3.6f\n', weighted_sens));
  afprintf(sprintf('[INFO] Weighted Spec: %3.6f\n', weighted_spec));
  weighted_results.test_acc = weighted_acc;
  weighted_results.test_sens = weighted_sens;
  weighted_results.test_spec = weighted_spec;

% -------------------------------------------------------------------------
function results = getKFoldResults(folds)
% -------------------------------------------------------------------------
  all_folds_acc = [];
  all_folds_sens = [];
  all_folds_spec = [];
  all_folds_ensemble_count = [];
  number_of_folds = numel(fields(folds));
  for i = 1:number_of_folds
    for j = 1:numel(folds.(sprintf('fold_%d', i)).ensemble_models)
      % results.(sprintf('fold_%d', i)).weight(j) = ...
      %   folds.(sprintf('fold_%d', i)).ensemble_models{j}.model_weight; % weight is normalized a bunch of times after each iter...
      results.(sprintf('fold_%d', i)).validation_acc(j) = ...
        folds.(sprintf('fold_%d', i)).ensemble_models{j}.validation_accuracy;
      results.(sprintf('fold_%d', i)).validation_sens(j) = ...
        folds.(sprintf('fold_%d', i)).ensemble_models{j}.validation_sensitivity;
      results.(sprintf('fold_%d', i)).validation_spec(j) = ...
        folds.(sprintf('fold_%d', i)).ensemble_models{j}.validation_specificity;
      results.(sprintf('fold_%d', i)).test_acc(j) = ...
        folds.(sprintf('fold_%d', i)).ensemble_models{j}.test_accuracy;
      results.(sprintf('fold_%d', i)).test_sens(j) = ...
        folds.(sprintf('fold_%d', i)).ensemble_models{j}.test_sensitivity;
      results.(sprintf('fold_%d', i)).test_spec(j) = ...
        folds.(sprintf('fold_%d', i)).ensemble_models{j}.test_specificity;
    end
    results.(sprintf('fold_%d', i)).weighted_acc = ...
      folds.(sprintf('fold_%d', i)).weighted_results.test_acc;
    results.(sprintf('fold_%d', i)).weighted_sens = ...
      folds.(sprintf('fold_%d', i)).weighted_results.test_sens;
    results.(sprintf('fold_%d', i)).weighted_spec = ...
      folds.(sprintf('fold_%d', i)).weighted_results.test_spec;
  end

  for i = 1:number_of_folds
    all_folds_acc(i) = folds.(sprintf('fold_%d', i)).weighted_results.test_acc;
    all_folds_sens(i) = folds.(sprintf('fold_%d', i)).weighted_results.test_sens;
    all_folds_spec(i) = folds.(sprintf('fold_%d', i)).weighted_results.test_spec;
    all_folds_ensemble_count(i) = numel(folds.(sprintf('fold_%d', i)).ensemble_models);
  end
  results.kfold_acc_avg = mean(all_folds_acc);
  results.kfold_sens_avg = mean(all_folds_sens);
  results.kfold_spec_avg = mean(all_folds_spec);
  results.kfold_ensemble_count_avg = mean(all_folds_ensemble_count);

  results.kfold_acc_std = std(all_folds_acc);
  results.kfold_sens_std = std(all_folds_sens);
  results.kfold_spec_std = std(all_folds_spec);
  results.kfold_ensemble_count_std = std(all_folds_ensemble_count);

% -------------------------------------------------------------------------
function saveKFoldResults(folds, results_file_path)
% -------------------------------------------------------------------------
  results = getKFoldResults(folds);
  saveStruct2File(results, results_file_path, 0);

% _p------------------------------------------------------------------------
function printKFoldResults(folds)
% -------------------------------------------------------------------------
  format shortG
  % for i = 1:numel(folds)
  %   afprintf(sprintf('Fold #%d Weighted RusBoost Performance:\n', i));
  %   disp(folds.(sprintf('fold_%d', i)).weighted_results);
  % end
  results = getKFoldResults(folds);
  afprintf(sprintf(' -- -- -- -- -- -- -- -- -- ALL FOLDS -- -- -- -- -- -- -- -- -- \n'));
  afprintf(sprintf(' -- -- -- -- -- -- -- -- -- TODO AMIR! -- -- -- -- -- -- -- -- -- \n'));
  % afprintf(sprintf('acc: %3.6f, std: %3.6f\n', mean(results.all_folds_acc), std(results.all_folds_acc)));
  % afprintf(sprintf('sens: %3.6f, std: %3.6f\n', mean(results.all_folds_sens), std(results.all_folds_sens)));
  % afprintf(sprintf('spec: %3.6f, std: %3.6f\n', mean(results.all_folds_spec), std(results.all_folds_spec)));
  % afprintf(sprintf('ensemble count: %3.6f, std: %3.6f\n', mean(results.all_folds_ensemble_count), std(results.all_folds_ensemble_count)));
