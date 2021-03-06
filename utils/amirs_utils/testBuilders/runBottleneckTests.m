% -------------------------------------------------------------------------
function runBottleneckTests(dataset, network_arch, gpus)
% -------------------------------------------------------------------------
% Copyright (c) 2017, Amir-Hossein Karimi
% All rights reserved.

% Redistribution and use in source and binary forms, with or without
% modification, are permitted provided that the following conditions are
% met:
%     * Redistributions of source code must retain the above copyright
%       notice, this list of conditions and the following disclaimer.
%     * Redistributions in binary form must reproduce the above copyright
%       notice, this list of conditions and the following disclaimer in
%       the documentation and/or other materials provided with the distribution

% THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
% AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
% IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
% ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE
% LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
% CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
% SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
% INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
% CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
% ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
% POSSIBILITY OF SUCH DAMAGE.

  % -------------------------------------------------------------------------
  %                                                              opts.general
  % -------------------------------------------------------------------------
  opts.general.dataset = dataset;
  opts.general.network_arch = network_arch;
  opts.imdb.dataset = opts.general.dataset;
  if isTwoClassImdb(dataset)
    opts.imdb.posneg_balance = 'unbalanced';
  else
    opts.imdb.network_arch = opts.general.network_arch;
  end

  % -------------------------------------------------------------------------
  %                                                                 opts.imdb
  % -------------------------------------------------------------------------
  imdb = loadSavedImdb(opts.imdb, 1);

  % -------------------------------------------------------------------------
  %                                                                opts.train
  % -------------------------------------------------------------------------
  opts.train.gpus = gpus;

  % -------------------------------------------------------------------------
  %                                                                opts.paths
  % -------------------------------------------------------------------------
  opts.paths.time_string = sprintf('%s', char(datetime('now', 'Format', 'd-MMM-y-HH-mm-ss')));
  opts.paths.experiment_parent_dir = getValueFromFieldOrDefault( ...
    {}, ... % TODO: this should be input_opts
    'experiment_parent_dir', ...
    fullfile(vl_rootnn, 'experiment_results'));
  opts.paths.experiment_dir = fullfile(opts.paths.experiment_parent_dir, sprintf( ...
    'test-bottleneck-tests-%s-%s-%s-GPU-%d', ...
    opts.paths.time_string, ...
    opts.general.dataset, ...
    opts.general.network_arch, ...
    opts.train.gpus));
  if ~exist(opts.paths.experiment_dir)
    mkdir(opts.paths.experiment_dir);
  end
  opts.paths.options_file_path = fullfile(opts.paths.experiment_dir, '_options.txt');
  % opts.paths.results_file_path = fullfile(opts.paths.experiment_dir, '_results.txt');

  % -------------------------------------------------------------------------
  %                                                    save experiment setup!
  % -------------------------------------------------------------------------
  saveStruct2File(opts, opts.paths.options_file_path, 0);

  % -------------------------------------------------------------------------
  %                                                            shared options
  % -------------------------------------------------------------------------
  single_cnn_options.imdb = imdb;
  single_cnn_options.dataset = opts.general.dataset;
  single_cnn_options.network_arch = opts.general.network_arch;
  single_cnn_options.experiment_parent_dir = opts.paths.experiment_dir;
  single_cnn_options.gpus = opts.train.gpus;
  single_cnn_options.debug_flag = false;

  switch opts.general.network_arch
    case 'lenet'
      bottleneck_structures = { ...
        [], ...
        [32], ...
        [16], ...
        [8], ...
        [4], ...
        [2], ...
        [1], ...
        [32, 32], ...
        [16, 16], ...
        [8, 8], ...
        [4, 4], ...
        [2, 2], ...
        [1, 1], ...
      };
      base_depth = 13;
    case 'alexnet'
      bottleneck_structures = { ...
        [], ...
        [32], ...
        ... [16], ...
        [8], ...
        ...[4], ...
        [2], ...
        ... [1], ...
        [32, 32], ...
        ... [16, 16], ...
        [8, 8], ...
        ...[4, 4], ...
        [2, 2], ...
        ... [1, 1], ...
        [32, 32, 32], ...
        ... [16, 16, 16], ...
        [8, 8, 8], ...
        ...[4, 4, 4], ...
        [2, 2, 2], ...
        ... [1, 1, 1], ...
        [32, 32, 32, 32], ...
        ... [16, 16, 16, 16], ...
        [8, 8, 8, 8], ...
        ...[4, 4, 4, 4], ...
        [2, 2, 2, 2], ...
        ... [1, 1, 1, 1], ...
      };
      base_depth = 20;
  end

  for bottleneck_structure = bottleneck_structures
    afprintf(sprintf('bottleneck structure: '));
    disp(bottleneck_structure);
    single_cnn_options.bottleneck_structure = bottleneck_structure{1};
    single_cnn_options.backprop_depth = base_depth + numel(bottleneck_structure{1});
    testCnn(single_cnn_options);
  end
