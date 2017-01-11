% -------------------------------------------------------------------------
function runAllTests(dataset, posneg_balance, gpus);
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
  opts.general.network_arch = 'lenet';

  % -------------------------------------------------------------------------
  %                                                                 opts.imdb
  % -------------------------------------------------------------------------
  opts.imdb.posneg_balance = posneg_balance;

  % -------------------------------------------------------------------------
  %                                                                opts.train
  % -------------------------------------------------------------------------
  opts.train.gpus = gpus;

  % -------------------------------------------------------------------------
  %                                                                opts.paths
  % -------------------------------------------------------------------------
  opts.paths.time_string = sprintf('%s',datetime('now', 'Format', 'd-MMM-y-HH-mm-ss'));
  opts.paths.experiment_parent_dir = getValueFromFieldOrDefault( ...
    {}, ... % TODO: this should be input_opts
    'experiment_parent_dir', ...
    fullfile(vl_rootnn, 'experiment_results'));
  opts.paths.experiment_dir = fullfile(opts.paths.experiment_parent_dir, sprintf( ...
    'test-ensemble-larp-tests-%s-%s-%s-GPU-%d', ...
    opts.paths.time_string, ...
    opts.general.dataset, ...
    opts.imdb.posneg_balance, ...
    opts.train.gpus));
  if ~exist(opts.paths.experiment_dir)
    mkdir(opts.paths.experiment_dir);
  end
  opts.paths.options_file_path = fullfile(opts.paths.experiment_dir, 'options.txt');
  % opts.paths.results_file_path = fullfile(opts.paths.experiment_dir, 'results.txt');

  % -------------------------------------------------------------------------
  %                                                    save experiment setup!
  % -------------------------------------------------------------------------
  saveStruct2File(opts, opts.paths.options_file_path, 0);

  % TODO:
  % ~~~    1. experiment_parent_dir code
  % ###    2. merge test*.m files (with shared loop function)

  % -------------------------------------------------------------------------
  %                                                            shared options
  % -------------------------------------------------------------------------
  experiment_options.experiment_parent_dir = opts.paths.experiment_dir;
  experiment_options.dataset = opts.general.dataset;
  experiment_options.network_arch = opts.general.network_arch;
  experiment_options.posneg_balance = opts.imdb.posneg_balance;
  experiment_options.gpus = opts.train.gpus;

  % -------------------------------------------------------------------------
  %                                                                single svm
  % -------------------------------------------------------------------------
  experiment_options.training_method = 'svm';
  % Exp. 1
  testKFold(experiment_options);

  % -------------------------------------------------------------------------
  %                                                              ensemble svm
  % -------------------------------------------------------------------------
  experiment_options.training_method = 'ensemble-svm';
  experiment_options.iteration_count = 5;
  % Exp. 1
  testKFold(experiment_options);

  % -------------------------------------------------------------------------
  %                                                               single tree
  % -------------------------------------------------------------------------
  % TODO...

  % -------------------------------------------------------------------------
  %                                                                    forest
  % -------------------------------------------------------------------------
  experiment_options.training_method = 'forest';
  % % Exp. 1
  % experiment_options.boosting_method = 'AdaBoostM1';
  % testKFold(experiment_options);
  % Exp. 2
  experiment_options.boosting_method = 'RUSBoost';
  testKFold(experiment_options);

  % -------------------------------------------------------------------------
  %                                                                single cnn
  % -------------------------------------------------------------------------
  experiment_options.training_method = 'single-cnn';
  % Exp. 1
  experiment_options.backprop_depth = 4;
  testKFold(experiment_options);
  % Exp. 2
  experiment_options.backprop_depth = 13;
  testKFold(experiment_options);

  % -------------------------------------------------------------------------
  %                                                              ensemble cnn
  % -------------------------------------------------------------------------
  experiment_options.training_method = 'ensemble-cnn';
  experiment_options.iteration_count = 5;

  % Exp. 1
  experiment_options.backprop_depth = 4;
  experiment_options.symmetric_weight_updates = true;
  experiment_options.symmetric_loss_updates = true;
  testKFold(experiment_options);
  % % Exp. 2
  % experiment_options.backprop_depth = 4;
  % experiment_options.symmetric_weight_updates = true;
  % experiment_options.symmetric_loss_updates = false;
  % testKFold(experiment_options);
  % % Exp. 3
  % experiment_options.backprop_depth = 4;
  % experiment_options.symmetric_weight_updates = false;
  % experiment_options.symmetric_loss_updates = true;
  % testKFold(experiment_options);
  % % Exp. 4
  % experiment_options.backprop_depth = 4;
  % experiment_options.symmetric_weight_updates = false;
  % experiment_options.symmetric_loss_updates = false;
  % testKFold(experiment_options);
  % Exp. 5
  experiment_options.backprop_depth = 13;
  experiment_options.symmetric_weight_updates = true;
  experiment_options.symmetric_loss_updates = true;
  testKFold(experiment_options);
  % % Exp. 6
  % experiment_options.backprop_depth = 13;
  % experiment_options.symmetric_weight_updates = true;
  % experiment_options.symmetric_loss_updates = false;
  % testKFold(experiment_options);
  % % Exp. 7
  % experiment_options.backprop_depth = 13;
  % experiment_options.symmetric_weight_updates = false;
  % experiment_options.symmetric_loss_updates = true;
  % testKFold(experiment_options);
  % % Exp. 8
  % experiment_options.backprop_depth = 13;
  % experiment_options.symmetric_weight_updates = false;
  % experiment_options.symmetric_loss_updates = false;
  % testKFold(experiment_options);