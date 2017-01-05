function imdb = loadSavedImdb(dataset, posneg_balance)
  % dataset: {'mnist-two-class', 'cifar-two-class'}
  % posneg_balance: {'unbalanced', 'balanced-low', 'balanced-high'}
  afprintf(sprintf('[INFO] Loading imdb (dataset: %s, posneg_balance: %s)\n', dataset, posneg_balance));
  switch dataset
    case 'mnist-two-class'
      switch posneg_balance
        case 'balanced-low'
          tmp = load(fullfile(getDevPath(), 'data', 'two_class_imdbs', 'saved-two-class-mnist-pos9-neg4-balanced-train-30-30.mat'));
        case 'unbalanced'
          tmp = load(fullfile(getDevPath(), 'data', 'two_class_imdbs', 'saved-two-class-mnist-pos9-neg4-unbalanced-30-6000.mat'));
        case 'balanced-high'
          tmp = load(fullfile(getDevPath(), 'data', 'two_class_imdbs', 'saved-two-class-mnist-pos9-neg4-balanced-train-6000-6000.mat'));
      end
    case 'cifar-two-class-deer-horse'
      switch posneg_balance
        case 'balanced-low'
          tmp = load(fullfile(getDevPath(), 'data', 'two_class_imdbs', 'saved-two-class-cifar-pos5-neg8-balanced-train-25-25.mat'));
        case 'unbalanced'
          tmp = load(fullfile(getDevPath(), 'data', 'two_class_imdbs', 'saved-two-class-cifar-pos5-neg8-unbalanced-25-5000.mat'));
        case 'balanced-high'
          tmp = load(fullfile(getDevPath(), 'data', 'two_class_imdbs', 'saved-two-class-cifar-pos5-neg8-balanced-train-5000-5000.mat'));
        end
    case 'cifar-two-class-deer-truck'
      switch posneg_balance
        case 'balanced-low'
          tmp = load(fullfile(getDevPath(), 'data', 'two_class_imdbs', 'saved-two-class-cifar-pos5-neg10-balanced-train-25-25.mat'));
        case 'unbalanced'
          tmp = load(fullfile(getDevPath(), 'data', 'two_class_imdbs', 'saved-two-class-cifar-pos5-neg10-unbalanced-25-5000.mat'));
        case 'balanced-high'
          tmp = load(fullfile(getDevPath(), 'data', 'two_class_imdbs', 'saved-two-class-cifar-pos5-neg10-balanced-train-5000-5000.mat'));
        end
    case 'prostate'
      fprintf('TODO: implement!')
      % TODO: fixup and test
      % opts.general.network_arch = 'prostatenet';
      % num_test_patients = 10;
      % tmp_opts.data_dir = fullfile(getDevPath(), 'matconvnet/data_1/_prostate');
      % tmp_opts.imdb_balanced_dir = fullfile(getDevPath(), 'matconvnet/data_1/balanced-prostate-prostatenet');
      % tmp_opts.imdb_balanced_path = fullfile(getDevPath(), 'matconvnet/data_1/balanced-prostate-prostatenet/imdb.mat');
      % tmp_opts.leave_out_type = 'special';
      % random_patient_indices = randperm(104);
      % tmp_opts.leaveOutIndices = random_patient_indices(1:num_test_patients);
      % tmp_opts.contrast_normalization = true;
      % tmp_opts.whitenData = true;
  end
  imdb = tmp.imdb;
  afprintf(sprintf('[INFO] done!\n'));

  % print info
  printConsoleOutputSeparator();
  fh_imdb_utils = imdbTwoClassUtils;
  fh_imdb_utils.getImdbInfo(imdb, 1);
  printConsoleOutputSeparator();
