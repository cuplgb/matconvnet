function results = testForest(input_opts)

  % -------------------------------------------------------------------------
  %                                                              opts.general
  % -------------------------------------------------------------------------
  opts.general.dataset = getValueFromFieldOrDefault(input_opts, 'dataset', 'mnist-two-class');

  % -------------------------------------------------------------------------
  %                                                                 opts.imdb
  % -------------------------------------------------------------------------
  opts.imdb.posneg_balance = getValueFromFieldOrDefault(input_opts, 'posneg_balance', 'unbalanced');
  imdb = loadSavedImdb(dataset, posneg_balance);

  % -------------------------------------------------------------------------
  %                                                                opts.train
  % -------------------------------------------------------------------------
  opts.train.num_examples = size(imdb.images.data, 4);
  opts.train.num_features = 3072;
  opts.train.num_trees = 1000;
  opts.train.boosting_method = getValueFromFieldOrDefault(input_opts, 'boosting_method', 'AdaBoostM1'); % {'AdaBoostM1', 'RUSBoost'}

  % -------------------------------------------------------------------------
  %                                                                opts.paths
  % -------------------------------------------------------------------------
  opts.paths.time_string = sprintf('%s',datetime('now', 'Format', 'd-MMM-y-HH-mm-ss'));
  opts.paths.experiment_parent_dir = getValueFromFieldOrDefault( ...
    input_opts, ...
    'experiment_parent_dir', ...
    fullfile(vl_rootnn, 'experiment_results'));
  opts.paths.experiment_dir = fullfile(opts.paths.experiment_parent_dir, sprintf( ...
    'test-forest-%s-%s-%s', ...
    opts.general.dataset, ...
    opts.general.network_arch, ...
    opts.paths.time_string));
  if ~exist(opts.paths.experiment_dir)
    mkdir(opts.paths.experiment_dir);
  end
  opts.paths.options_file_path = fullfile(opts.paths.experiment_dir, 'options.txt');
  opts.paths.results_file_path = fullfile(opts.paths.experiment_dir, 'results.txt');

  % -------------------------------------------------------------------------
  %                                                    save experiment setup!
  % -------------------------------------------------------------------------
  saveStruct2File(opts, opts.paths.options_file_path, 0);

  %% %% %% %% %% %% %% %% %% %% %% %% %% %% %% %% %% %% %% %% %% %% %% %% %% %% %%

  images = reshape(imdb.images.data, 3072, [])';
  labels = imdb.images.labels;
  Y = labels(1:opts.train.num_examples);
  cov_type = images(1:opts.train.num_examples,1:opts.train.num_features);
  is_train = imdb.images.set == 1;
  is_test = imdb.images.set == 3;

  %% %% %% %% %% %% %% %% %% %% %% %% %% %% %% %% %% %% %% %% %% %% %% %% %% %% %%
  all_tests_rus_trees = {};
  all_tests_results = {};
  test_repeat_count = 10;
  for i = 1: test_repeat_count
    printConsoleOutputSeparator();
    afprintf(sprintf('\nTest #%d\n', i));
    t = templateTree('MinLeafSize',5);
    tic
    rus_tree = fitensemble( ...
      cov_type(is_train,:), ...
      Y(is_train), ...
      opts.train.boosting_method, ...
      opts.train.num_trees, ...
      t, ...
      'LearnRate', 0.1, ...
      'nprint', 50);
    toc
    all_tests_rus_trees{i} = rus_tree;

    %% %% %% %% %% %% %% %% %% %% %% %% %% %% %% %% %% %% %% %% %% %% %% %% %% %% %%

    l_loss = loss(rus_tree, cov_type(is_test,:), Y(is_test), 'mode', 'cumulative');

    %% %% %% %% %% %% %% %% %% %% %% %% %% %% %% %% %% %% %% %% %% %% %% %% %% %% %%

    % figure;
    % tic
    % plot(l_loss);
    % toc
    % grid on;
    % xlabel('Number of trees');
    % ylabel('Test classification error');

    %% %% %% %% %% %% %% %% %% %% %% %% %% %% %% %% %% %% %% %% %% %% %% %% %% %% %%

    tic
    Yfit = predict(rus_tree, cov_type(is_test,:));
    toc
    tab = tabulate(Y(is_test));
    confusion_matrix = bsxfun(@rdivide, confusionmat(Y(is_test), Yfit), tab(:,2)) * 100;

    acc = (1 - l_loss(end)) * 100;
    spec = confusion_matrix(1,1);
    sens = confusion_matrix(2,2);

    afprintf(sprintf('[INFO] Acc: %6.2f\n', acc));
    afprintf(sprintf('[INFO] Sens: %6.2f\n', sens));
    afprintf(sprintf('[INFO] Spec: %6.2f\n', spec));
    printConsoleOutputSeparator();

    results.test_acc(i) = acc;
    results.test_sens(i) = sens;
    results.test_spec(i) = spec;
  end

  results.test_acc_mean = mean(results.test_acc);
  results.test_sens_mean = mean(results.test_sens);
  results.test_spec_mean = mean(results.test_spec);
  results.test_acc_std = std(results.test_acc);
  results.test_sens_std = std(results.test_sens);
  results.test_spec_std = std(results.test_spec);
  saveStruct2File(results, opts.paths.results_file_path, 0);