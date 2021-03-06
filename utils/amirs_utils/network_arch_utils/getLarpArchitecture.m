% -------------------------------------------------------------------------
function net = getLarpArchitecture(dataset, network_arch, weight_init_sequence)
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

  fh = networkInitializationUtils;
  net.layers = {};

  if strfind(network_arch, 'custom-')
    net = getCustomLarpArchitecture(dataset, network_arch, weight_init_sequence);
    return
  end

  switch network_arch

    % ------------------------------------------------------------------------------------------------------------------------------------------------------------
    case 'larpV0P0RL0'
      % empty

    % ------------------------------------------------------------------------------------------------------------------------------------------------------------
    case 'larpV0P0RL0-single-dense-rp'
      % empty... doesn't even use convolutions... uses dense random projection matrix in loadSavedImdb.

    % ------------------------------------------------------------------------------------------------------------------------------------------------------------
    case 'larpV1P0RL0-single-sparse-rp'
      layer_number = numel(net.layers) + 1;
      net.layers{end+1} = fh.convLayer(dataset, network_arch, layer_number, 5, 3, 3, 1/100, 2, char(weight_init_sequence{1}), 'gen');
      % net.layers{end+1} = fh.poolingLayerLeNetMax(layer_number);
      % net.layers{end+1} = fh.reluLayer(layer_number);

    % ------------------------------------------------------------------------------------------------------------------------------------------------------------
    case 'larpV1P0RL0-ensemble-sparse-rp' % = 'larpV1P0RL0'
      layer_number = numel(net.layers) + 1;
      net.layers{end+1} = fh.convLayer(dataset, network_arch, layer_number, 5, 3, 64, 1/100, 2, char(weight_init_sequence{1}), 'gen');
      % net.layers{end+1} = fh.poolingLayerLeNetMax(layer_number);
      % net.layers{end+1} = fh.reluLayer(layer_number);

    % ------------------------------------------------------------------------------------------------------------------------------------------------------------
    case 'larpV1P0RL1-ensemble-sparse-rp' % = 'larpV1P0RL1'
      layer_number = numel(net.layers) + 1;
      net.layers{end+1} = fh.convLayer(dataset, network_arch, layer_number, 5, 3, 64, 1/100, 2, char(weight_init_sequence{1}), 'gen');
      % net.layers{end+1} = fh.poolingLayerLeNetMax(layer_number);
      net.layers{end+1} = fh.reluLayer(layer_number);

    % ------------------------------------------------------------------------------------------------------------------------------------------------------------
    case 'larpV1P0RL0' % = 'larpV1P0-ensemble-sparse-rp'
      layer_number = numel(net.layers) + 1;
      net.layers{end+1} = fh.convLayer(dataset, network_arch, layer_number, 5, 3, 64, 1/100, 2, char(weight_init_sequence{1}), 'gen');
      % net.layers{end+1} = fh.poolingLayerLeNetMax(layer_number);
      % net.layers{end+1} = fh.reluLayer(layer_number);

    % ------------------------------------------------------------------------------------------------------------------------------------------------------------
    case 'larpV1P0RL1' % = 'larpV1P0-ensemble-sparse-rp'
      layer_number = numel(net.layers) + 1;
      net.layers{end+1} = fh.convLayer(dataset, network_arch, layer_number, 5, 3, 64, 1/100, 2, char(weight_init_sequence{1}), 'gen');
      % net.layers{end+1} = fh.poolingLayerLeNetMax(layer_number);
      net.layers{end+1} = fh.reluLayer(layer_number);

    % ------------------------------------------------------------------------------------------------------------------------------------------------------------
    case 'larpV1P1RL1-non-decimated-pooling'
      layer_number = numel(net.layers) + 1;
      net.layers{end+1} = fh.convLayer(dataset, network_arch, layer_number, 5, 3, 64, 1/100, 2, char(weight_init_sequence{1}), 'gen');
      net.layers{end+1} = fh.poolingLayerLeNetMaxNonDecimated(layer_number);
      net.layers{end+1} = fh.reluLayer(layer_number);

    % ------------------------------------------------------------------------------------------------------------------------------------------------------------
    case 'larpV1P1RL1'
      layer_number = numel(net.layers) + 1;
      net.layers{end+1} = fh.convLayer(dataset, network_arch, layer_number, 5, 3, 64, 1/100, 2, char(weight_init_sequence{1}), 'gen');
      net.layers{end+1} = fh.poolingLayerLeNetMax(layer_number);
      net.layers{end+1} = fh.reluLayer(layer_number);

    % ------------------------------------------------------------------------------------------------------------------------------------------------------------
    case 'larpV1P1RL1-special-1'
      method = 'max';
      pool = [9,9];
      stride = 8;
      pad = [0 1 0 1];
      layer_number = numel(net.layers) + 1;
      net.layers{end+1} = fh.convLayer(dataset, network_arch, layer_number, 5, 3, 64, 1/100, 2, char(weight_init_sequence{1}), 'gen');
      net.layers{end+1} = fh.poolingLayerLeNetMax(layer_number);
      net.layers{end+1} = fh.poolingLayerSpecial(layer_number, method, pool, stride, pad);
      net.layers{end+1} = fh.reluLayer(layer_number);

    % ------------------------------------------------------------------------------------------------------------------------------------------------------------
    case 'larpV1P1RL1-special-2'
      method = 'max';
      pool = [5,5];
      stride = 4;
      pad = [0 1 0 1];
      layer_number = numel(net.layers) + 1;
      net.layers{end+1} = fh.convLayer(dataset, network_arch, layer_number, 5, 3, 16, 1/100, 2, char(weight_init_sequence{1}), 'gen');
      net.layers{end+1} = fh.poolingLayerLeNetMax(layer_number);
      net.layers{end+1} = fh.poolingLayerSpecial(layer_number, method, pool, stride, pad);
      net.layers{end+1} = fh.reluLayer(layer_number);














































    % ------------------------------------------------------------------------------------------------------------------------------------------------------------
    case 'larpV3P0RL0'
      layer_number = numel(net.layers) + 1;
      net.layers{end+1} = fh.convLayer(dataset, network_arch, layer_number, 5, 3, 32, 1/100, 2, char(weight_init_sequence{1}), 'gen');
      % net.layers{end+1} = fh.poolingLayerLeNetMax(layer_number);
      % net.layers{end+1} = fh.reluLayer(layer_number);

      layer_number = numel(net.layers) + 1;
      net.layers{end+1} = fh.convLayer(dataset, network_arch, layer_number, 5, 32, 32, 5/100, 2, char(weight_init_sequence{2}), 'gen');
      % net.layers{end+1} = fh.reluLayer(layer_number);
      % net.layers{end+1} = fh.poolingLayerLeNetAvg(layer_number);

      layer_number = numel(net.layers) + 1;
      net.layers{end+1} = fh.convLayer(dataset, network_arch, layer_number, 5, 32, 64, 5/100, 2, char(weight_init_sequence{3}), 'gen');
      % net.layers{end+1} = fh.reluLayer(layer_number);
      % net.layers{end+1} = fh.poolingLayerLeNetAvg(layer_number);

    % ------------------------------------------------------------------------------------------------------------------------------------------------------------
    case 'larpV3P0RL3'
      layer_number = numel(net.layers) + 1;
      net.layers{end+1} = fh.convLayer(dataset, network_arch, layer_number, 5, 3, 32, 1/100, 2, char(weight_init_sequence{1}), 'gen');
      % net.layers{end+1} = fh.poolingLayerLeNetMax(layer_number);
      net.layers{end+1} = fh.reluLayer(layer_number);

      layer_number = numel(net.layers) + 1;
      net.layers{end+1} = fh.convLayer(dataset, network_arch, layer_number, 5, 32, 32, 5/100, 2, char(weight_init_sequence{2}), 'gen');
      net.layers{end+1} = fh.reluLayer(layer_number);
      % net.layers{end+1} = fh.poolingLayerLeNetAvg(layer_number);

      layer_number = numel(net.layers) + 1;
      net.layers{end+1} = fh.convLayer(dataset, network_arch, layer_number, 5, 32, 64, 5/100, 2, char(weight_init_sequence{3}), 'gen');
      net.layers{end+1} = fh.reluLayer(layer_number);
      % net.layers{end+1} = fh.poolingLayerLeNetAvg(layer_number);

    % ------------------------------------------------------------------------------------------------------------------------------------------------------------
    case 'larpV3P1RL3-non-decimated-pooling'
      layer_number = numel(net.layers) + 1;
      net.layers{end+1} = fh.convLayer(dataset, network_arch, layer_number, 5, 3, 32, 1/100, 2, char(weight_init_sequence{1}), 'gen');
      % net.layers{end+1} = fh.poolingLayerLeNetMax(layer_number);
      net.layers{end+1} = fh.reluLayer(layer_number);

      layer_number = numel(net.layers) + 1;
      net.layers{end+1} = fh.convLayer(dataset, network_arch, layer_number, 5, 32, 32, 5/100, 2, char(weight_init_sequence{2}), 'gen');
      net.layers{end+1} = fh.reluLayer(layer_number);
      net.layers{end+1} = fh.poolingLayerLeNetMaxNonDecimated(layer_number);

      layer_number = numel(net.layers) + 1;
      net.layers{end+1} = fh.convLayer(dataset, network_arch, layer_number, 5, 32, 64, 5/100, 2, char(weight_init_sequence{3}), 'gen');
      net.layers{end+1} = fh.reluLayer(layer_number);
      % net.layers{end+1} = fh.poolingLayerLeNetAvg(layer_number);

    % ------------------------------------------------------------------------------------------------------------------------------------------------------------
    case 'larpV3P1RL3'
      layer_number = numel(net.layers) + 1;
      net.layers{end+1} = fh.convLayer(dataset, network_arch, layer_number, 5, 3, 32, 1/100, 2, char(weight_init_sequence{1}), 'gen');
      % net.layers{end+1} = fh.poolingLayerLeNetMax(layer_number);
      net.layers{end+1} = fh.reluLayer(layer_number);

      layer_number = numel(net.layers) + 1;
      net.layers{end+1} = fh.convLayer(dataset, network_arch, layer_number, 5, 32, 32, 5/100, 2, char(weight_init_sequence{2}), 'gen');
      net.layers{end+1} = fh.reluLayer(layer_number);
      net.layers{end+1} = fh.poolingLayerLeNetAvg(layer_number);

      layer_number = numel(net.layers) + 1;
      net.layers{end+1} = fh.convLayer(dataset, network_arch, layer_number, 5, 32, 64, 5/100, 2, char(weight_init_sequence{3}), 'gen');
      net.layers{end+1} = fh.reluLayer(layer_number);
      % net.layers{end+1} = fh.poolingLayerLeNetAvg(layer_number);

    % ------------------------------------------------------------------------------------------------------------------------------------------------------------
    case 'larpV3P2RL3'
      layer_number = numel(net.layers) + 1;
      net.layers{end+1} = fh.convLayer(dataset, network_arch, layer_number, 5, 3, 32, 1/100, 2, char(weight_init_sequence{1}), 'gen');
      net.layers{end+1} = fh.poolingLayerLeNetMax(layer_number);
      net.layers{end+1} = fh.reluLayer(layer_number);

      layer_number = numel(net.layers) + 1;
      net.layers{end+1} = fh.convLayer(dataset, network_arch, layer_number, 5, 32, 32, 5/100, 2, char(weight_init_sequence{2}), 'gen');
      net.layers{end+1} = fh.reluLayer(layer_number);
      % net.layers{end+1} = fh.poolingLayerLeNetAvg(layer_number);

      layer_number = numel(net.layers) + 1;
      net.layers{end+1} = fh.convLayer(dataset, network_arch, layer_number, 5, 32, 64, 5/100, 2, char(weight_init_sequence{3}), 'gen');
      net.layers{end+1} = fh.reluLayer(layer_number);
      net.layers{end+1} = fh.poolingLayerLeNetAvg(layer_number);

    % ------------------------------------------------------------------------------------------------------------------------------------------------------------
    case 'larpV3P3RL0'
      layer_number = numel(net.layers) + 1;
      net.layers{end+1} = fh.convLayer(dataset, network_arch, layer_number, 5, 3, 32, 1/100, 2, char(weight_init_sequence{1}), 'gen');
      net.layers{end+1} = fh.poolingLayerLeNetMax(layer_number);
      % net.layers{end+1} = fh.reluLayer(layer_number);

      layer_number = numel(net.layers) + 1;
      net.layers{end+1} = fh.convLayer(dataset, network_arch, layer_number, 5, 32, 32, 5/100, 2, char(weight_init_sequence{2}), 'gen');
      % net.layers{end+1} = fh.reluLayer(layer_number);
      net.layers{end+1} = fh.poolingLayerLeNetAvg(layer_number);

      layer_number = numel(net.layers) + 1;
      net.layers{end+1} = fh.convLayer(dataset, network_arch, layer_number, 5, 32, 64, 5/100, 2, char(weight_init_sequence{3}), 'gen');
      % net.layers{end+1} = fh.reluLayer(layer_number);
      net.layers{end+1} = fh.poolingLayerLeNetAvg(layer_number);

    % ------------------------------------------------------------------------------------------------------------------------------------------------------------
    case 'larpV3P3RL3'
      layer_number = numel(net.layers) + 1;
      net.layers{end+1} = fh.convLayer(dataset, network_arch, layer_number, 5, 3, 32, 1/100, 2, char(weight_init_sequence{1}), 'gen');
      net.layers{end+1} = fh.poolingLayerLeNetMax(layer_number);
      net.layers{end+1} = fh.reluLayer(layer_number);

      layer_number = numel(net.layers) + 1;
      net.layers{end+1} = fh.convLayer(dataset, network_arch, layer_number, 5, 32, 32, 5/100, 2, char(weight_init_sequence{2}), 'gen');
      net.layers{end+1} = fh.reluLayer(layer_number);
      net.layers{end+1} = fh.poolingLayerLeNetAvg(layer_number);

      layer_number = numel(net.layers) + 1;
      net.layers{end+1} = fh.convLayer(dataset, network_arch, layer_number, 5, 32, 64, 5/100, 2, char(weight_init_sequence{3}), 'gen');
      net.layers{end+1} = fh.reluLayer(layer_number);
      net.layers{end+1} = fh.poolingLayerLeNetAvg(layer_number);

    % ------------------------------------------------------------------------------------------------------------------------------------------------------------
    case 'larpV3P3RL3-final-conv-16-kernels-first-max-pool-then-relu'
      layer_number = numel(net.layers) + 1;
      net.layers{end+1} = fh.convLayer(dataset, network_arch, layer_number, 5, 3, 32, 1/100, 2, char(weight_init_sequence{1}), 'gen');
      net.layers{end+1} = fh.poolingLayerLeNetMax(layer_number);
      net.layers{end+1} = fh.reluLayer(layer_number);

      layer_number = numel(net.layers) + 1;
      net.layers{end+1} = fh.convLayer(dataset, network_arch, layer_number, 5, 32, 32, 5/100, 2, char(weight_init_sequence{2}), 'gen');
      net.layers{end+1} = fh.reluLayer(layer_number);
      net.layers{end+1} = fh.poolingLayerLeNetAvg(layer_number);

      layer_number = numel(net.layers) + 1;
      % net.layers{end+1} = fh.convLayer(dataset, network_arch, layer_number, 5, 32, 64, 5/100, 2, char(weight_init_sequence{3}), 'gen');
      net.layers{end+1} = fh.convLayer(dataset, network_arch, layer_number, 5, 32, 16, 5/100, 2, char(weight_init_sequence{3}), 'gen');
      net.layers{end+1} = fh.reluLayer(layer_number);
      net.layers{end+1} = fh.poolingLayerLeNetAvg(layer_number);

    % ------------------------------------------------------------------------------------------------------------------------------------------------------------
    case 'larpV3P3RL3-final-conv-16-kernels-first-relu-then-max-pool'
      layer_number = numel(net.layers) + 1;
      net.layers{end+1} = fh.convLayer(dataset, network_arch, layer_number, 5, 3, 32, 1/100, 2, char(weight_init_sequence{1}), 'gen');
      net.layers{end+1} = fh.reluLayer(layer_number);
      net.layers{end+1} = fh.poolingLayerLeNetMax(layer_number);

      layer_number = numel(net.layers) + 1;
      net.layers{end+1} = fh.convLayer(dataset, network_arch, layer_number, 5, 32, 32, 5/100, 2, char(weight_init_sequence{2}), 'gen');
      net.layers{end+1} = fh.reluLayer(layer_number);
      net.layers{end+1} = fh.poolingLayerLeNetAvg(layer_number);

      layer_number = numel(net.layers) + 1;
      % net.layers{end+1} = fh.convLayer(dataset, network_arch, layer_number, 5, 32, 64, 5/100, 2, char(weight_init_sequence{3}), 'gen');
      net.layers{end+1} = fh.convLayer(dataset, network_arch, layer_number, 5, 32, 16, 5/100, 2, char(weight_init_sequence{3}), 'gen');
      net.layers{end+1} = fh.reluLayer(layer_number);
      net.layers{end+1} = fh.poolingLayerLeNetAvg(layer_number);





















































    % ------------------------------------------------------------------------------------------------------------------------------------------------------------
    case 'larpV5P0RL5'
      layer_number = numel(net.layers) + 1;
      net.layers{end+1} = fh.convLayer(dataset, network_arch, layer_number, 5, 3, 32, 1/100, 2, char(weight_init_sequence{1}), 'gen');
      % net.layers{end+1} = fh.poolingLayerLeNetMax(layer_number);
      net.layers{end+1} = fh.reluLayer(layer_number);

      layer_number = numel(net.layers) + 1;
      net.layers{end+1} = fh.convLayer(dataset, network_arch, layer_number, 5, 32, 32, 1/100, 2, char(weight_init_sequence{2}), 'gen');
      % net.layers{end+1} = fh.poolingLayerLeNetMax(layer_number);
      net.layers{end+1} = fh.reluLayer(layer_number);

      layer_number = numel(net.layers) + 1;
      net.layers{end+1} = fh.convLayer(dataset, network_arch, layer_number, 5, 32, 32, 1/100, 2, char(weight_init_sequence{3}), 'gen');
      net.layers{end+1} = fh.reluLayer(layer_number);
      % net.layers{end+1} = fh.poolingLayerLeNetAvg(layer_number);

      layer_number = numel(net.layers) + 1;
      net.layers{end+1} = fh.convLayer(dataset, network_arch, layer_number, 5, 32, 32, 1/100, 2, char(weight_init_sequence{4}), 'gen');
      % net.layers{end+1} = fh.poolingLayerLeNetMax(layer_number);
      net.layers{end+1} = fh.reluLayer(layer_number);

      layer_number = numel(net.layers) + 1;
      net.layers{end+1} = fh.convLayer(dataset, network_arch, layer_number, 5, 32, 64, 5/100, 2, char(weight_init_sequence{5}), 'gen');
      net.layers{end+1} = fh.reluLayer(layer_number);
      % net.layers{end+1} = fh.poolingLayerLeNetAvg(layer_number);

    % ------------------------------------------------------------------------------------------------------------------------------------------------------------
    case 'larpV5P1RL5-non-decimated-pooling'
      layer_number = numel(net.layers) + 1;
      net.layers{end+1} = fh.convLayer(dataset, network_arch, layer_number, 5, 3, 32, 1/100, 2, char(weight_init_sequence{1}), 'gen');
      % net.layers{end+1} = fh.poolingLayerLeNetMax(layer_number);
      net.layers{end+1} = fh.reluLayer(layer_number);

      layer_number = numel(net.layers) + 1;
      net.layers{end+1} = fh.convLayer(dataset, network_arch, layer_number, 5, 32, 32, 1/100, 2, char(weight_init_sequence{2}), 'gen');
      % net.layers{end+1} = fh.poolingLayerLeNetMax(layer_number);
      net.layers{end+1} = fh.reluLayer(layer_number);

      layer_number = numel(net.layers) + 1;
      net.layers{end+1} = fh.convLayer(dataset, network_arch, layer_number, 5, 32, 32, 1/100, 2, char(weight_init_sequence{3}), 'gen');
      net.layers{end+1} = fh.reluLayer(layer_number);
      net.layers{end+1} = fh.poolingLayerLeNetMaxNonDecimated(layer_number);

      layer_number = numel(net.layers) + 1;
      net.layers{end+1} = fh.convLayer(dataset, network_arch, layer_number, 5, 32, 32, 1/100, 2, char(weight_init_sequence{4}), 'gen');
      % net.layers{end+1} = fh.poolingLayerLeNetMax(layer_number);
      net.layers{end+1} = fh.reluLayer(layer_number);

      layer_number = numel(net.layers) + 1;
      net.layers{end+1} = fh.convLayer(dataset, network_arch, layer_number, 5, 32, 64, 5/100, 2, char(weight_init_sequence{5}), 'gen');
      net.layers{end+1} = fh.reluLayer(layer_number);
      % net.layers{end+1} = fh.poolingLayerLeNetAvg(layer_number);

    % ------------------------------------------------------------------------------------------------------------------------------------------------------------
    case 'larpV5P1RL5'
      layer_number = numel(net.layers) + 1;
      net.layers{end+1} = fh.convLayer(dataset, network_arch, layer_number, 5, 3, 32, 1/100, 2, char(weight_init_sequence{1}), 'gen');
      % net.layers{end+1} = fh.poolingLayerLeNetMax(layer_number);
      net.layers{end+1} = fh.reluLayer(layer_number);

      layer_number = numel(net.layers) + 1;
      net.layers{end+1} = fh.convLayer(dataset, network_arch, layer_number, 5, 32, 32, 1/100, 2, char(weight_init_sequence{2}), 'gen');
      % net.layers{end+1} = fh.poolingLayerLeNetMax(layer_number);
      net.layers{end+1} = fh.reluLayer(layer_number);

      layer_number = numel(net.layers) + 1;
      net.layers{end+1} = fh.convLayer(dataset, network_arch, layer_number, 5, 32, 32, 1/100, 2, char(weight_init_sequence{3}), 'gen');
      net.layers{end+1} = fh.reluLayer(layer_number);
      net.layers{end+1} = fh.poolingLayerLeNetAvg(layer_number);

      layer_number = numel(net.layers) + 1;
      net.layers{end+1} = fh.convLayer(dataset, network_arch, layer_number, 5, 32, 32, 1/100, 2, char(weight_init_sequence{4}), 'gen');
      % net.layers{end+1} = fh.poolingLayerLeNetMax(layer_number);
      net.layers{end+1} = fh.reluLayer(layer_number);

      layer_number = numel(net.layers) + 1;
      net.layers{end+1} = fh.convLayer(dataset, network_arch, layer_number, 5, 32, 64, 5/100, 2, char(weight_init_sequence{5}), 'gen');
      net.layers{end+1} = fh.reluLayer(layer_number);
      % net.layers{end+1} = fh.poolingLayerLeNetAvg(layer_number);

    % ------------------------------------------------------------------------------------------------------------------------------------------------------------
    case 'larpV5P2RL5'
      layer_number = numel(net.layers) + 1;
      net.layers{end+1} = fh.convLayer(dataset, network_arch, layer_number, 5, 3, 32, 1/100, 2, char(weight_init_sequence{1}), 'gen');
      % net.layers{end+1} = fh.poolingLayerLeNetMax(layer_number);
      net.layers{end+1} = fh.reluLayer(layer_number);

      layer_number = numel(net.layers) + 1;
      net.layers{end+1} = fh.convLayer(dataset, network_arch, layer_number, 5, 32, 32, 1/100, 2, char(weight_init_sequence{2}), 'gen');
      net.layers{end+1} = fh.poolingLayerLeNetMax(layer_number);
      net.layers{end+1} = fh.reluLayer(layer_number);

      layer_number = numel(net.layers) + 1;
      net.layers{end+1} = fh.convLayer(dataset, network_arch, layer_number, 5, 32, 32, 1/100, 2, char(weight_init_sequence{3}), 'gen');
      net.layers{end+1} = fh.reluLayer(layer_number);
      % net.layers{end+1} = fh.poolingLayerLeNetAvg(layer_number);

      layer_number = numel(net.layers) + 1;
      net.layers{end+1} = fh.convLayer(dataset, network_arch, layer_number, 5, 32, 32, 1/100, 2, char(weight_init_sequence{4}), 'gen');
      net.layers{end+1} = fh.poolingLayerLeNetMax(layer_number);
      net.layers{end+1} = fh.reluLayer(layer_number);

      layer_number = numel(net.layers) + 1;
      net.layers{end+1} = fh.convLayer(dataset, network_arch, layer_number, 5, 32, 64, 5/100, 2, char(weight_init_sequence{5}), 'gen');
      net.layers{end+1} = fh.reluLayer(layer_number);
      % net.layers{end+1} = fh.poolingLayerLeNetAvg(layer_number);

    % ------------------------------------------------------------------------------------------------------------------------------------------------------------
    case 'larpV5P3RL5'
      layer_number = numel(net.layers) + 1;
      net.layers{end+1} = fh.convLayer(dataset, network_arch, layer_number, 5, 3, 32, 1/100, 2, char(weight_init_sequence{1}), 'gen');
      net.layers{end+1} = fh.poolingLayerLeNetMax(layer_number);
      net.layers{end+1} = fh.reluLayer(layer_number);

      layer_number = numel(net.layers) + 1;
      net.layers{end+1} = fh.convLayer(dataset, network_arch, layer_number, 5, 32, 32, 1/100, 2, char(weight_init_sequence{2}), 'gen');
      % net.layers{end+1} = fh.poolingLayerLeNetMax(layer_number);
      net.layers{end+1} = fh.reluLayer(layer_number);

      layer_number = numel(net.layers) + 1;
      net.layers{end+1} = fh.convLayer(dataset, network_arch, layer_number, 5, 32, 32, 1/100, 2, char(weight_init_sequence{3}), 'gen');
      net.layers{end+1} = fh.reluLayer(layer_number);
      net.layers{end+1} = fh.poolingLayerLeNetAvg(layer_number);

      layer_number = numel(net.layers) + 1;
      net.layers{end+1} = fh.convLayer(dataset, network_arch, layer_number, 5, 32, 32, 1/100, 2, char(weight_init_sequence{4}), 'gen');
      % net.layers{end+1} = fh.poolingLayerLeNetMax(layer_number);
      net.layers{end+1} = fh.reluLayer(layer_number);

      layer_number = numel(net.layers) + 1;
      net.layers{end+1} = fh.convLayer(dataset, network_arch, layer_number, 5, 32, 64, 5/100, 2, char(weight_init_sequence{5}), 'gen');
      net.layers{end+1} = fh.reluLayer(layer_number);
      net.layers{end+1} = fh.poolingLayerLeNetAvg(layer_number);

    % ------------------------------------------------------------------------------------------------------------------------------------------------------------
    case 'larpV5P3RL5-final-conv-16-kernels'
      layer_number = numel(net.layers) + 1;
      net.layers{end+1} = fh.convLayer(dataset, network_arch, layer_number, 5, 3, 32, 1/100, 2, char(weight_init_sequence{1}), 'gen');
      net.layers{end+1} = fh.poolingLayerLeNetMax(layer_number);
      net.layers{end+1} = fh.reluLayer(layer_number);

      layer_number = numel(net.layers) + 1;
      net.layers{end+1} = fh.convLayer(dataset, network_arch, layer_number, 5, 32, 32, 1/100, 2, char(weight_init_sequence{2}), 'gen');
      % net.layers{end+1} = fh.poolingLayerLeNetMax(layer_number);
      net.layers{end+1} = fh.reluLayer(layer_number);

      layer_number = numel(net.layers) + 1;
      net.layers{end+1} = fh.convLayer(dataset, network_arch, layer_number, 5, 32, 32, 1/100, 2, char(weight_init_sequence{3}), 'gen');
      net.layers{end+1} = fh.reluLayer(layer_number);
      net.layers{end+1} = fh.poolingLayerLeNetAvg(layer_number);

      layer_number = numel(net.layers) + 1;
      net.layers{end+1} = fh.convLayer(dataset, network_arch, layer_number, 5, 32, 32, 1/100, 2, char(weight_init_sequence{4}), 'gen');
      % net.layers{end+1} = fh.poolingLayerLeNetMax(layer_number);
      net.layers{end+1} = fh.reluLayer(layer_number);

      layer_number = numel(net.layers) + 1;
      % net.layers{end+1} = fh.convLayer(dataset, network_arch, layer_number, 5, 32, 64, 5/100, 2, char(weight_init_sequence{5}), 'gen');
      net.layers{end+1} = fh.convLayer(dataset, network_arch, layer_number, 5, 32, 16, 5/100, 2, char(weight_init_sequence{5}), 'gen');
      net.layers{end+1} = fh.reluLayer(layer_number);
      net.layers{end+1} = fh.poolingLayerLeNetAvg(layer_number);




















































    % % ------------------------------------------------------------------------------------------------------------------------------------------------------------
    % case 'larpV5P0RL0'
    %   layer_number = numel(net.layers) + 1;
    %   net.layers{end+1} = fh.convLayer(dataset, network_arch, layer_number, 5, 3, 96, 5/1000, 2, char(weight_init_sequence{1}), 'gen');
    %   % net.layers{end+1} = fh.reluLayer(layer_number);

    %   layer_number = numel(net.layers) + 1;
    %   net.layers{end+1} = fh.convLayer(dataset, network_arch, layer_number, 5, 96, 256, 5/1000, 2, char(weight_init_sequence{2}), 'gen');
    %   % net.layers{end+1} = fh.reluLayer(layer_number);
    %   % net.layers{end+1} = fh.poolingLayerAlexNet(layer_number);

    %   layer_number = numel(net.layers) + 1;
    %   net.layers{end+1} = fh.convLayer(dataset, network_arch, layer_number, 3, 256, 384, 5/1000, 1, char(weight_init_sequence{3}), 'gen');
    %   % net.layers{end+1} = fh.reluLayer(layer_number);
    %   % net.layers{end+1} = fh.poolingLayerAlexNet(layer_number);

    %   layer_number = numel(net.layers) + 1;
    %   net.layers{end+1} = fh.convLayer(dataset, network_arch, layer_number, 3, 384, 384, 5/1000, 1, char(weight_init_sequence{4}), 'gen');
    %   % net.layers{end+1} = fh.reluLayer(layer_number);

    %   layer_number = numel(net.layers) + 1;
    %   net.layers{end+1} = fh.convLayer(dataset, network_arch, layer_number, 3, 384, 256, 5/1000, 1, char(weight_init_sequence{5}), 'gen');
    %   % net.layers{end+1} = fh.reluLayer(layer_number);
    %   % net.layers{end+1} = fh.poolingLayerAlexNet(layer_number);

    % % ------------------------------------------------------------------------------------------------------------------------------------------------------------
    % case 'larpV5P0RL5'
    %   layer_number = numel(net.layers) + 1;
    %   net.layers{end+1} = fh.convLayer(dataset, network_arch, layer_number, 5, 3, 96, 5/1000, 2, char(weight_init_sequence{1}), 'gen');
    %   net.layers{end+1} = fh.reluLayer(layer_number);

    %   layer_number = numel(net.layers) + 1;
    %   net.layers{end+1} = fh.convLayer(dataset, network_arch, layer_number, 5, 96, 256, 5/1000, 2, char(weight_init_sequence{2}), 'gen');
    %   net.layers{end+1} = fh.reluLayer(layer_number);
    %   % net.layers{end+1} = fh.poolingLayerAlexNet(layer_number);

    %   layer_number = numel(net.layers) + 1;
    %   net.layers{end+1} = fh.convLayer(dataset, network_arch, layer_number, 3, 256, 384, 5/1000, 1, char(weight_init_sequence{3}), 'gen');
    %   net.layers{end+1} = fh.reluLayer(layer_number);
    %   % net.layers{end+1} = fh.poolingLayerAlexNet(layer_number);

    %   layer_number = numel(net.layers) + 1;
    %   net.layers{end+1} = fh.convLayer(dataset, network_arch, layer_number, 3, 384, 384, 5/1000, 1, char(weight_init_sequence{4}), 'gen');
    %   net.layers{end+1} = fh.reluLayer(layer_number);

    %   layer_number = numel(net.layers) + 1;
    %   net.layers{end+1} = fh.convLayer(dataset, network_arch, layer_number, 3, 384, 256, 5/1000, 1, char(weight_init_sequence{5}), 'gen');
    %   net.layers{end+1} = fh.reluLayer(layer_number);
    %   % net.layers{end+1} = fh.poolingLayerAlexNet(layer_number);

    % % ------------------------------------------------------------------------------------------------------------------------------------------------------------
    % case 'larpV5P3RL0'
    %   layer_number = numel(net.layers) + 1;
    %   net.layers{end+1} = fh.convLayer(dataset, network_arch, layer_number, 5, 3, 96, 5/1000, 2, char(weight_init_sequence{1}), 'gen');
    %   % net.layers{end+1} = fh.reluLayer(layer_number);

    %   layer_number = numel(net.layers) + 1;
    %   net.layers{end+1} = fh.convLayer(dataset, network_arch, layer_number, 5, 96, 256, 5/1000, 2, char(weight_init_sequence{2}), 'gen');
    %   % net.layers{end+1} = fh.reluLayer(layer_number);
    %   net.layers{end+1} = fh.poolingLayerAlexNet(layer_number);

    %   layer_number = numel(net.layers) + 1;
    %   net.layers{end+1} = fh.convLayer(dataset, network_arch, layer_number, 3, 256, 384, 5/1000, 1, char(weight_init_sequence{3}), 'gen');
    %   % net.layers{end+1} = fh.reluLayer(layer_number);
    %   net.layers{end+1} = fh.poolingLayerAlexNet(layer_number);

    %   layer_number = numel(net.layers) + 1;
    %   net.layers{end+1} = fh.convLayer(dataset, network_arch, layer_number, 3, 384, 384, 5/1000, 1, char(weight_init_sequence{4}), 'gen');
    %   % net.layers{end+1} = fh.reluLayer(layer_number);

    %   layer_number = numel(net.layers) + 1;
    %   net.layers{end+1} = fh.convLayer(dataset, network_arch, layer_number, 3, 384, 256, 5/1000, 1, char(weight_init_sequence{5}), 'gen');
    %   % net.layers{end+1} = fh.reluLayer(layer_number);
    %   net.layers{end+1} = fh.poolingLayerAlexNet(layer_number);

    % % ------------------------------------------------------------------------------------------------------------------------------------------------------------
    % case 'larpV5P3RL5' % AlexNet
    %   layer_number = numel(net.layers) + 1;
    %   net.layers{end+1} = fh.convLayer(dataset, network_arch, layer_number, 5, 3, 96, 5/1000, 2, char(weight_init_sequence{1}), 'gen');
    %   net.layers{end+1} = fh.reluLayer(layer_number);

    %   layer_number = numel(net.layers) + 1;
    %   net.layers{end+1} = fh.convLayer(dataset, network_arch, layer_number, 5, 96, 256, 5/1000, 2, char(weight_init_sequence{2}), 'gen');
    %   net.layers{end+1} = fh.reluLayer(layer_number);
    %   net.layers{end+1} = fh.poolingLayerAlexNet(layer_number);

    %   layer_number = numel(net.layers) + 1;
    %   net.layers{end+1} = fh.convLayer(dataset, network_arch, layer_number, 3, 256, 384, 5/1000, 1, char(weight_init_sequence{3}), 'gen');
    %   net.layers{end+1} = fh.reluLayer(layer_number);
    %   net.layers{end+1} = fh.poolingLayerAlexNet(layer_number);

    %   layer_number = numel(net.layers) + 1;
    %   net.layers{end+1} = fh.convLayer(dataset, network_arch, layer_number, 3, 384, 384, 5/1000, 1, char(weight_init_sequence{4}), 'gen');
    %   net.layers{end+1} = fh.reluLayer(layer_number);

    %   layer_number = numel(net.layers) + 1;
    %   net.layers{end+1} = fh.convLayer(dataset, network_arch, layer_number, 3, 384, 256, 5/1000, 1, char(weight_init_sequence{5}), 'gen');
    %   net.layers{end+1} = fh.reluLayer(layer_number);
    %   net.layers{end+1} = fh.poolingLayerAlexNet(layer_number);

    % % ------------------------------------------------------------------------------------------------------------------------------------------------------------
    % case 'larpV5P5RL0'
    %   layer_number = numel(net.layers) + 1;
    %   net.layers{end+1} = fh.convLayer(dataset, network_arch, layer_number, 5, 3, 96, 5/1000, 2, char(weight_init_sequence{1}), 'gen');
    %   net.layers{end+1} = fh.poolingLayerAlexNet(layer_number);
    %   % net.layers{end+1} = fh.reluLayer(layer_number);

    %   layer_number = numel(net.layers) + 1;
    %   net.layers{end+1} = fh.convLayer(dataset, network_arch, layer_number, 5, 96, 256, 5/1000, 2, char(weight_init_sequence{2}), 'gen');
    %   % net.layers{end+1} = fh.reluLayer(layer_number);
    %   net.layers{end+1} = fh.poolingLayerAlexNet(layer_number);

    %   layer_number = numel(net.layers) + 1;
    %   net.layers{end+1} = fh.convLayer(dataset, network_arch, layer_number, 3, 256, 384, 5/1000, 1, char(weight_init_sequence{3}), 'gen');
    %   % net.layers{end+1} = fh.reluLayer(layer_number);
    %   net.layers{end+1} = fh.poolingLayerAlexNet(layer_number);

    %   layer_number = numel(net.layers) + 1;
    %   net.layers{end+1} = fh.convLayer(dataset, network_arch, layer_number, 3, 384, 384, 5/1000, 1, char(weight_init_sequence{4}), 'gen');
    %   % net.layers{end+1} = fh.reluLayer(layer_number);
    %   net.layers{end+1} = fh.poolingLayerAlexNet(layer_number);

    %   layer_number = numel(net.layers) + 1;
    %   net.layers{end+1} = fh.convLayer(dataset, network_arch, layer_number, 3, 384, 256, 5/1000, 1, char(weight_init_sequence{5}), 'gen');
    %   % net.layers{end+1} = fh.reluLayer(layer_number);
    %   net.layers{end+1} = fh.poolingLayerAlexNet(layer_number);

    % % ------------------------------------------------------------------------------------------------------------------------------------------------------------
    % case 'larpV5P5RL5'
    %   layer_number = numel(net.layers) + 1;
    %   net.layers{end+1} = fh.convLayer(dataset, network_arch, layer_number, 5, 3, 96, 5/1000, 2, char(weight_init_sequence{1}), 'gen');
    %   net.layers{end+1} = fh.poolingLayerAlexNet(layer_number);
    %   net.layers{end+1} = fh.reluLayer(layer_number);

    %   layer_number = numel(net.layers) + 1;
    %   net.layers{end+1} = fh.convLayer(dataset, network_arch, layer_number, 5, 96, 256, 5/1000, 2, char(weight_init_sequence{2}), 'gen');
    %   net.layers{end+1} = fh.reluLayer(layer_number);
    %   net.layers{end+1} = fh.poolingLayerAlexNet(layer_number);

    %   layer_number = numel(net.layers) + 1;
    %   net.layers{end+1} = fh.convLayer(dataset, network_arch, layer_number, 3, 256, 384, 5/1000, 1, char(weight_init_sequence{3}), 'gen');
    %   net.layers{end+1} = fh.reluLayer(layer_number);
    %   net.layers{end+1} = fh.poolingLayerAlexNet(layer_number);

    %   layer_number = numel(net.layers) + 1;
    %   net.layers{end+1} = fh.convLayer(dataset, network_arch, layer_number, 3, 384, 384, 5/1000, 1, char(weight_init_sequence{4}), 'gen');
    %   net.layers{end+1} = fh.reluLayer(layer_number);
    %   net.layers{end+1} = fh.poolingLayerAlexNet(layer_number);

    %   layer_number = numel(net.layers) + 1;
    %   net.layers{end+1} = fh.convLayer(dataset, network_arch, layer_number, 3, 384, 256, 5/1000, 1, char(weight_init_sequence{5}), 'gen');
    %   net.layers{end+1} = fh.reluLayer(layer_number);
    %   net.layers{end+1} = fh.poolingLayerAlexNet(layer_number);

    % % ------------------------------------------------------------------------------------------------------------------------------------------------------------
    % case 'larpV8P0RL8'
    %   layer_number = numel(net.layers) + 1;
    %   net.layers{end+1} = fh.convLayer(dataset, network_arch, layer_number, 5, 3, 32, 5/1000, 2, char(weight_init_sequence{1}), 'gen');
    %   net.layers{end+1} = fh.reluLayer(layer_number);

    %   layer_number = numel(net.layers) + 1;
    %   net.layers{end+1} = fh.convLayer(dataset, network_arch, layer_number, 5, 32, 32, 5/1000, 2, char(weight_init_sequence{2}), 'gen');
    %   net.layers{end+1} = fh.reluLayer(layer_number);
    %   % net.layers{end+1} = fh.poolingLayerAlexNet(layer_number);

    %   layer_number = numel(net.layers) + 1;
    %   net.layers{end+1} = fh.convLayer(dataset, network_arch, layer_number, 3, 32, 32, 5/1000, 1, char(weight_init_sequence{3}), 'gen');
    %   net.layers{end+1} = fh.reluLayer(layer_number);
    %   % net.layers{end+1} = fh.poolingLayerAlexNet(layer_number);

    %   layer_number = numel(net.layers) + 1;
    %   net.layers{end+1} = fh.convLayer(dataset, network_arch, layer_number, 3, 32, 32, 5/1000, 1, char(weight_init_sequence{4}), 'gen');
    %   net.layers{end+1} = fh.reluLayer(layer_number);

    %   layer_number = numel(net.layers) + 1;
    %   net.layers{end+1} = fh.convLayer(dataset, network_arch, layer_number, 3, 32, 64, 5/1000, 1, char(weight_init_sequence{5}), 'gen');
    %   net.layers{end+1} = fh.reluLayer(layer_number);
    %   % net.layers{end+1} = fh.poolingLayerAlexNet(layer_number);

    %   layer_number = numel(net.layers) + 1;
    %   net.layers{end+1} = fh.convLayer(dataset, network_arch, layer_number, 3, 32, 64, 5/1000, 1, char(weight_init_sequence{5}), 'gen');
    %   net.layers{end+1} = fh.reluLayer(layer_number);
    %   % net.layers{end+1} = fh.poolingLayerAlexNet(layer_number);

    %   layer_number = numel(net.layers) + 1;
    %   net.layers{end+1} = fh.convLayer(dataset, network_arch, layer_number, 3, 32, 64, 5/1000, 1, char(weight_init_sequence{5}), 'gen');
    %   net.layers{end+1} = fh.reluLayer(layer_number);
    %   % net.layers{end+1} = fh.poolingLayerAlexNet(layer_number);

    %   layer_number = numel(net.layers) + 1;
    %   net.layers{end+1} = fh.convLayer(dataset, network_arch, layer_number, 3, 32, 64, 5/1000, 1, char(weight_init_sequence{5}), 'gen');
    %   net.layers{end+1} = fh.reluLayer(layer_number);
    %   % net.layers{end+1} = fh.poolingLayerAlexNet(layer_number);


  end
