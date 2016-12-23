% -------------------------------------------------------------------------
function imdb = constructCifarImdb(opts)
% -------------------------------------------------------------------------
  afprintf(sprintf('[INFO] Constructing CIFAR imdb (portion = %%%d)...\n\n', opts.imdb.imdb_portion * 100));
  % Prepare the imdb structure, returns image data with mean image subtracted
  unpack_path = fullfile(opts.imdb.data_dir, 'cifar-10-batches-mat');
  files = [arrayfun(@(n) sprintf('data_batch_%d.mat', n), 1:5, 'UniformOutput', false) ...
    {'test_batch.mat'}];
  files = cellfun(@(fn) fullfile(unpack_path, fn), files, 'UniformOutput', false);
  file_set = uint8([ones(1, 5), 3]);

  if any(cellfun(@(fn) ~exist(fn, 'file'), files))
    url = 'http://www.cs.toronto.edu/~kriz/cifar-10-matlab.tar.gz';
    afprintf(sprintf('downloading %s\n', url));
    untar(url, opts.imdb.data_dir);
  end

  data = cell(1, numel(files));
  labels = cell(1, numel(files));
  sets = cell(1, numel(files));
  for fi = 1:numel(files)
    fd = load(files{fi});
    data{fi} = permute(reshape(fd.data',32,32,3,[]),[2 1 3 4]);
    labels{fi} = fd.labels' + 1; % Index from 1
    sets{fi} = repmat(file_set(fi), size(labels{fi}));
  end

  % data = im2double(cat(4, data{:}));
  data = single(cat(4, data{:}));
  labels = single(cat(2, labels{:}));
  set = cat(2, sets{:});

  % remove mean in any case
  data_mean = mean(data(:,:,:,set == 1), 4);
  data = bsxfun(@minus, data, data_mean);

  [output_data, output_labels] = choosePortionOfImdb(data(:,:,:,1:50000), labels(1:50000), opts.imdb.imdb_portion);
  data = single(cat(4, output_data, data(:,:,:,50001:60000))); % amend with test data
  labels = single(cat(2, output_labels, labels(50001:60000))); % amend with test data
  set = [ones(1, 50000 * opts.imdb.imdb_portion) 3 * ones(1, 10000)]; % all of the test portion
  number_of_train_and_test_images = size(labels, 2);
  afprintf(sprintf('[INFO] number_of_train_and_test_images in portion: %d.\n', number_of_train_and_test_images));

  % normalize by image mean and std as suggested in `An Analysis of
  % Single-Layer Networks in Unsupervised Feature Learning` Adam
  % Coates, Honglak Lee, Andrew Y. Ng

  if opts.imdb.contrastNormalization
    afprintf(sprintf('[INFO] contrast-normalizing data... '));
    z = reshape(data,[],number_of_train_and_test_images);
    z = bsxfun(@minus, z, mean(z,1));
    n = std(z,0,1);
    z = bsxfun(@times, z, mean(n) ./ max(n, 40));
    data = reshape(z, 32, 32, 3, []);
    afprintf(sprintf('done.\n'));
  end

  if opts.imdb.whiten_data
    afprintf(sprintf('[INFO] whitening data... '));
    z = reshape(data,[],number_of_train_and_test_images);
    W = z(:,set == 1)*z(:,set == 1)'/number_of_train_and_test_images;
    [V,D] = eig(W);
    % the scale is selected to approximately preserve the norm of W
    d2 = diag(D);
    en = sqrt(mean(d2));
    z = V*diag(en./max(sqrt(d2), 10))*V'*z;
    data = reshape(z, 32, 32, 3, []);
    afprintf(sprintf('done.\n'));
  end

  clNames = load(fullfile(unpack_path, 'batches.meta.mat'));

  imdb.images.data = data;
  imdb.images.labels = labels;
  imdb.images.set = set;
  imdb.meta.sets = {'train', 'val', 'test'};
  imdb.meta.classes = clNames.label_names;
  afprintf(sprintf('[INFO] Finished constructing CIFAR imdb (portion = %%%d)!\n', opts.imdb.imdb_portion * 100));

% -------------------------------------------------------------------------
function [data, labels] = choosePortionOfImdb(data, labels, portion)
% -------------------------------------------------------------------------
  % VERY INEFFICIENT
  number_of_classes = 10;
  number_of_samples = size(labels, 2);
  number_of_images_per_class = number_of_samples / number_of_classes * portion;

  label_indices = {};
  output_data = {};
  output_labels = {};
  for i = 1:number_of_classes
    label_indices{i} = (labels == i);
    afprintf(sprintf('\t[INFO] found %d images with label %d...\n', size(label_indices{i}, 2), i));
  end
  afprintf(sprintf('\n'));

  tic;
  for i = 1:number_of_classes
    afprintf(sprintf('\t[INFO] extracting images for class %d...', i));
    output_data{i} = data(:,:,:,label_indices{i});
    output_labels{i} = labels(label_indices{i});
    afprintf(sprintf('done! \t'));
    toc;
  end
  afprintf(sprintf('\n'));

  for i = 1:number_of_classes
    portioned_output_data{i} = output_data{i}(:,:,:,1:number_of_images_per_class);
    portioned_output_labels{i} = output_labels{i}(1:number_of_images_per_class);
  end

  data = single(cat(4, output_data{:}));
  labels = single(cat(2, output_labels{:}));

  % shuffle data and labels the same way
  ix = randperm(number_of_samples * portion);
  data = data(:,:,:,ix);
  labels = labels(ix);