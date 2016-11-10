dataDir = '/Volumes/Amir/results/';

epochNum = 50;
epochFile = sprintf('net-epoch-%d.mat', epochNum);
fprintf('Loading files...'); i = 1;

subDataDir = '2016-11-10-10; STL10; LeNet; FC+{0-3}; 2x2D_mult_randn_3x1D';
fc_plus_3_2x2D_mult_randn_3x1D = load(fullfile(dataDir, subDataDir, 'stl-10-lenet-10-Nov-2016-01-28-03-GPU1', epochFile)); fprintf('\t%d', i); i = i + 1;
fc_plus_2_2x2D_mult_randn_3x1D = load(fullfile(dataDir, subDataDir, 'stl-10-lenet-10-Nov-2016-01-33-32-GPU1', epochFile)); fprintf('\t%d', i); i = i + 1;
fc_plus_1_2x2D_mult_randn_3x1D = load(fullfile(dataDir, subDataDir, 'stl-10-lenet-10-Nov-2016-01-38-24-GPU1', epochFile)); fprintf('\t%d', i); i = i + 1;
fc_plus_0_2x2D_mult_randn_3x1D = load(fullfile(dataDir, subDataDir, 'stl-10-lenet-10-Nov-2016-01-42-43-GPU1', epochFile)); fprintf('\t%d', i); i = i + 1;

subDataDir = '2016-11-10-10; STL10; LeNet; FC+{0-3}; 2x2D_mult_randn_3xcompRand';
fc_plus_3_2x2D_mult_randn_3xcompRand = load(fullfile(dataDir, subDataDir, 'stl-10-lenet-10-Nov-2016-12-37-11-GPU2', epochFile)); fprintf('\t%d', i); i = i + 1;
fc_plus_2_2x2D_mult_randn_3xcompRand = load(fullfile(dataDir, subDataDir, 'stl-10-lenet-10-Nov-2016-12-42-32-GPU2', epochFile)); fprintf('\t%d', i); i = i + 1;
fc_plus_1_2x2D_mult_randn_3xcompRand = load(fullfile(dataDir, subDataDir, 'stl-10-lenet-10-Nov-2016-12-47-21-GPU2', epochFile)); fprintf('\t%d', i); i = i + 1;
fc_plus_0_2x2D_mult_randn_3xcompRand = load(fullfile(dataDir, subDataDir, 'stl-10-lenet-10-Nov-2016-12-51-41-GPU2', epochFile)); fprintf('\t%d', i); i = i + 1;

subDataDir = '2016-11-10-10; STL10; LeNet; FC+{0-3}; 2x2D_shiftflip_3x1D';
fc_plus_3_2x2D_shiftflip_3x1D = load(fullfile(dataDir, subDataDir, 'stl-10-lenet-10-Nov-2016-00-50-38-GPU1', epochFile)); fprintf('\t%d', i); i = i + 1;
fc_plus_2_2x2D_shiftflip_3x1D = load(fullfile(dataDir, subDataDir, 'stl-10-lenet-10-Nov-2016-00-56-09-GPU1', epochFile)); fprintf('\t%d', i); i = i + 1;
fc_plus_1_2x2D_shiftflip_3x1D = load(fullfile(dataDir, subDataDir, 'stl-10-lenet-10-Nov-2016-01-01-03-GPU1', epochFile)); fprintf('\t%d', i); i = i + 1;
fc_plus_0_2x2D_shiftflip_3x1D = load(fullfile(dataDir, subDataDir, 'stl-10-lenet-10-Nov-2016-01-05-26-GPU1', epochFile)); fprintf('\t%d', i); i = i + 1;

subDataDir = '2016-11-10-10; STL10; LeNet; FC+{0-3}; 2x2D_shiftflip_3xcompRand';
fc_plus_3_2x2D_shiftflip_3xcompRand = load(fullfile(dataDir, subDataDir, 'stl-10-lenet-10-Nov-2016-01-09-20-GPU1', epochFile)); fprintf('\t%d', i); i = i + 1;
fc_plus_2_2x2D_shiftflip_3xcompRand = load(fullfile(dataDir, subDataDir, 'stl-10-lenet-10-Nov-2016-01-14-52-GPU1', epochFile)); fprintf('\t%d', i); i = i + 1;
fc_plus_1_2x2D_shiftflip_3xcompRand = load(fullfile(dataDir, subDataDir, 'stl-10-lenet-10-Nov-2016-01-19-46-GPU1', epochFile)); fprintf('\t%d', i); i = i + 1;
fc_plus_0_2x2D_shiftflip_3xcompRand = load(fullfile(dataDir, subDataDir, 'stl-10-lenet-10-Nov-2016-01-24-08-GPU1', epochFile)); fprintf('\t%d', i); i = i + 1;

subDataDir = '2016-11-10-10; STL10; LeNet; FC+{0-3}; 5x1D';
fc_plus_3_5x1D = load(fullfile(dataDir, subDataDir, 'stl-10-lenet-10-Nov-2016-00-12-38-GPU1', epochFile)); fprintf('\t%d', i); i = i + 1;
fc_plus_2_5x1D = load(fullfile(dataDir, subDataDir, 'stl-10-lenet-10-Nov-2016-00-18-08-GPU1', epochFile)); fprintf('\t%d', i); i = i + 1;
fc_plus_1_5x1D = load(fullfile(dataDir, subDataDir, 'stl-10-lenet-10-Nov-2016-00-23-10-GPU1', epochFile)); fprintf('\t%d', i); i = i + 1;
fc_plus_0_5x1D = load(fullfile(dataDir, subDataDir, 'stl-10-lenet-10-Nov-2016-00-27-40-GPU1', epochFile)); fprintf('\t%d', i); i = i + 1;

subDataDir = '2016-11-10-10; STL10; LeNet; FC+{0-3}; 5xcompRand';
fc_plus_3_5xcompRand = load(fullfile(dataDir, subDataDir, 'stl-10-lenet-10-Nov-2016-12-05-05-GPU2', epochFile)); fprintf('\t%d', i); i = i + 1;
fc_plus_2_5xcompRand = load(fullfile(dataDir, subDataDir, 'stl-10-lenet-10-Nov-2016-12-10-38-GPU2', epochFile)); fprintf('\t%d', i); i = i + 1;
fc_plus_1_5xcompRand = load(fullfile(dataDir, subDataDir, 'stl-10-lenet-10-Nov-2016-12-15-28-GPU2', epochFile)); fprintf('\t%d', i); i = i + 1;
fc_plus_0_5xcompRand = load(fullfile(dataDir, subDataDir, 'stl-10-lenet-10-Nov-2016-12-19-47-GPU2', epochFile)); fprintf('\t%d', i); i = i + 1;

fprintf('\nDone!');

for backPropDepth = 0:3
  for resultType = {'train', 'val'}
    resultType = char(resultType);
    h = figure;
    experiment = sprintf('Varying Weight Initialization Schemes - FC + %d', backPropDepth);
    exp_1 = eval(sprintf('fc_plus_%d_2x2D_mult_randn_3x1D', backPropDepth));
    exp_2 = eval(sprintf('fc_plus_%d_2x2D_mult_randn_3xcompRand', backPropDepth));
    exp_5 = eval(sprintf('fc_plus_%d_2x2D_shiftflip_3x1D', backPropDepth));
    exp_6 = eval(sprintf('fc_plus_%d_2x2D_shiftflip_3xcompRand', backPropDepth));
    exp_11 = eval(sprintf('fc_plus_%d_5x1D', backPropDepth));
    exp_12 = eval(sprintf('fc_plus_%d_5xcompRand', backPropDepth));

    plot( ...
      1:1:epochNum, [exp_1.info.(resultType).error(1,:)], 'y', ...
      1:1:epochNum, [exp_2.info.(resultType).error(1,:)], 'y--', ...
      1:1:epochNum, [exp_5.info.(resultType).error(1,:)], 'm', ...
      1:1:epochNum, [exp_6.info.(resultType).error(1,:)], 'm--', ...
      1:1:epochNum, [exp_11.info.(resultType).error(1,:)], 'r', ...
      1:1:epochNum, [exp_12.info.(resultType).error(1,:)], 'k', ...
      'LineWidth', 2);
    grid on
    title(experiment);
    legend(...
      '2x2D mult randn + 3x1D', ...
      '2x2D mult randn + 3xcompRand', ...
      '2x2D shiftflip + 3x1D', ...
      '2x2D shiftflip + 3xcompRand', ...
      '5x1D', ...
      '5xcompRand');
    xlabel('epoch')
    % ylabel('Training Error');
    ylim([0,1]);
    switch resultType
      case 'train'
        ylabel('Training Error');
        fileName = sprintf('Training Comparison - %s.png', experiment);
      case 'val'
        ylabel('Validation Error');
        fileName = sprintf('Validation Comparison - %s.png', experiment);
    end
    saveas(h, fileName);
  end
end














% == == == == == == == == == == == == == == == == == == == == == == == == == ==
% == == == == == == == == == == == == == == == == == == == == == == == == == ==

% dataDir = '/Volumes/Amir-1/results/';
% subDataDir_compRand = '2016-10-27-28; FC+0-5; compRand weights; weight decay = T; bottlenecks = F';
% subDataDir_1D = '2016-10-25-26; FC+0-5; input whitening = T; 1D dist sampling';
% subDataDir_2D_mult = '2016-11-04-06; AlexNet; FC+{0-5}; 2x2D-mult + 3xcompRand';
% subDataDir_2D_super = '2016-11-04-06; AlexNet; FC+{0-5}; 2x2D-super + 3xcompRand';
% subDataDir_2D_posneg = '2016-11-04-06; AlexNet; FC+{0-5}; 2x2D-posneg + 3xcompRand';
% epochNum = 50;
% epochFile = sprintf('net-epoch-%d.mat', epochNum);
% fprintf('Loading files...'); i = 1;

% % BackPropDepth = 20;
% % w_compRand = load(fullfile(dataDir, subDataDir_compRand, 'cifar-alex-net-28-Oct-2016-08-07-32-GPU2', epochFile)); fprintf('\t%d', i); i = i + 1;
% % w_1D = load(fullfile(dataDir, subDataDir_1D, 'cifar-alex-net-25-Oct-2016-22-37-50-GPU1', epochFile)); fprintf('\t%d', i); i = i + 1;
% % w_2D_mult = load(fullfile(dataDir, subDataDir_2D_mult, 'cifar-alex-net-4-Nov-2016-17-29-44-GPU1', epochFile)); fprintf('\t%d', i); i = i + 1;
% % w_2D_super = load(fullfile(dataDir, subDataDir_2D_super, 'cifar-alexnet-6-Nov-2016-08-37-30-GPU1', epochFile)); fprintf('\t%d', i); i = i + 1;
% % w_2D_posneg = load(fullfile(dataDir, subDataDir_2D_posneg, 'cifar-alexnet-5-Nov-2016-20-10-41-GPU1', epochFile)); fprintf('\t%d', i); i = i + 1;

% BackPropDepth = 7;
% w_1D = load(fullfile(dataDir, subDataDir_1D, 'cifar-alex-net-26-Oct-2016-10-45-32-GPU1', epochFile)); fprintf('\t%d', i); i = i + 1;
% w_compRand = load(fullfile(dataDir, subDataDir_compRand, 'cifar-alex-net-28-Oct-2016-17-00-20-GPU2', epochFile)); fprintf('\t%d', i); i = i + 1;
% w_2D_mult = load(fullfile(dataDir, subDataDir_2D_mult, 'cifar-alex-net-5-Nov-2016-01-28-38-GPU1', epochFile)); fprintf('\t%d', i); i = i + 1;
% w_2D_posneg = load(fullfile(dataDir, subDataDir_2D_posneg, 'cifar-alexnet-6-Nov-2016-02-58-42-GPU1', epochFile)); fprintf('\t%d', i); i = i + 1;
% w_2D_super = load(fullfile(dataDir, subDataDir_2D_super, 'cifar-alexnet-6-Nov-2016-11-00-08-GPU1', epochFile)); fprintf('\t%d', i); i = i + 1;

% fprintf('\nDone!');

% h = figure;
% plot( ...
%   1:1:epochNum, [w_compRand.info.train.error(1,:)], ...
%   1:1:epochNum, [w_1D.stats.train.top1err], ...
%   1:1:epochNum, [w_2D_mult.info.train.error(1,:)], ...
%   1:1:epochNum, [w_2D_super.info.train.error(1,:)], ...
%   1:1:epochNum, [w_2D_posneg.info.train.error(1,:)], ...
%   'LineWidth', 2);
% grid on
% title(sprintf('Training Accuracy - BackProp Depth %d', BackPropDepth));
% legend(...
%   'compRand', ...
%   '1D', ...
%   '2D mult', ...
%   '2D super', ...
%   '2D posneg');
% xlabel('epoch')
% ylabel('Training Error');
% saveas(h, sprintf('Training Comparison - %d.png', epochNum));

% h = figure;
% plot( ...
%   1:1:epochNum, [w_compRand.info.val.error(1,:)], ...
%   1:1:epochNum, [w_1D.stats.val.top1err], ...
%   1:1:epochNum, [w_2D_mult.info.val.error(1,:)], ...
%   1:1:epochNum, [w_2D_super.info.val.error(1,:)], ...
%   1:1:epochNum, [w_2D_posneg.info.val.error(1,:)], ...
%   'LineWidth', 2);
% grid on
% title(sprintf('Validation Accuracy - BackProp Depth %d', BackPropDepth));
% legend(...
%   'compRand', ...
%   '1D', ...
%   '2D mult', ...
%   '2D super', ...
%   '2D posneg');
% xlabel('epoch')
% ylabel('Validation Error');
% saveas(h, sprintf('Validation Comparison - %d.png', epochNum));


% == == == == == == == == == == == == == == == == == == == == == == == == == ==
% == == == == == == == == == == == == == == == == == == == == == == == == == ==


% dataDir = '/Volumes/Amir-1/results/';
% subDataDir = '2016-11-04-06; AlexNet; FC+{0-5}; 2x2D-posneg + 3xcompRand';
% epochNum = 50;
% epochFile = sprintf('net-epoch-%d.mat', epochNum);
% fprintf('Loading files...'); i = 1;

% fc_plus_5 = load(fullfile(dataDir, subDataDir, 'cifar-alexnet-5-Nov-2016-20-10-41-GPU1', epochFile)); fprintf('\t%d', i); i = i + 1;
% fc_plus_4 = load(fullfile(dataDir, subDataDir, 'cifar-alexnet-5-Nov-2016-22-18-04-GPU1', epochFile)); fprintf('\t%d', i); i = i + 1;
% fc_plus_3 = load(fullfile(dataDir, subDataDir, 'cifar-alexnet-6-Nov-2016-00-15-48-GPU1', epochFile)); fprintf('\t%d', i); i = i + 1;
% fc_plus_2 = load(fullfile(dataDir, subDataDir, 'cifar-alexnet-6-Nov-2016-01-40-22-GPU1', epochFile)); fprintf('\t%d', i); i = i + 1;
% fc_plus_1 = load(fullfile(dataDir, subDataDir, 'cifar-alexnet-6-Nov-2016-01-53-33-GPU1', epochFile)); fprintf('\t%d', i); i = i + 1;
% fc_only = load(fullfile(dataDir, subDataDir, 'cifar-alexnet-6-Nov-2016-02-58-42-GPU1', epochFile)); fprintf('\t%d', i); i = i + 1;
% fprintf('\nDone!');

% h = figure;
% plot( ...
%   1:1:epochNum, [fc_only.info.train.error(1,:)], ... % [fc_only.stats.train.top1err], ... .info.train.error
%   1:1:epochNum, [fc_plus_1.info.train.error(1,:)], ... % [fc_plus_1.stats.train.top1err], ...
%   1:1:epochNum, [fc_plus_2.info.train.error(1,:)], ... % [fc_plus_2.stats.train.top1err], ...
%   1:1:epochNum, [fc_plus_3.info.train.error(1,:)], ... % [fc_plus_3.stats.train.top1err], ...
%   1:1:epochNum, [fc_plus_4.info.train.error(1,:)], ... % [fc_plus_4.stats.train.top1err], ...
%   1:1:epochNum, [fc_plus_5.info.train.error(1,:)], ... % [fc_plus_5.stats.train.top1err], ...
%   'LineWidth', 2);
% grid on
% title('Effects of Varying BackProp Depth on Training Accuracy');
% legend(...
%   'training on FC ONLY', ...
%   'training on FC + 1 blocks', ...
%   'training on FC + 2 blocks', ...
%   'training on FC + 3 blocks', ...
%   'training on FC + 4 blocks', ...
%   'training on FC + 5 blocks (FULL)');
% xlabel('epoch')
% ylabel('Training Error');
% saveas(h, sprintf('Training Comparison - %d.png', epochNum));

% h = figure;
% plot( ...
%   1:1:epochNum, [fc_only.info.val.error(1,:)], ... % [fc_only.stats.val.top1err], ...
%   1:1:epochNum, [fc_plus_1.info.val.error(1,:)], ... % [fc_plus_1.stats.val.top1err], ...
%   1:1:epochNum, [fc_plus_2.info.val.error(1,:)], ... % [fc_plus_2.stats.val.top1err], ...
%   1:1:epochNum, [fc_plus_3.info.val.error(1,:)], ... % [fc_plus_3.stats.val.top1err], ...
%   1:1:epochNum, [fc_plus_4.info.val.error(1,:)], ... % [fc_plus_4.stats.val.top1err], ...
%   1:1:epochNum, [fc_plus_5.info.val.error(1,:)], ... % [fc_plus_5.stats.val.top1err], ...
%   'LineWidth', 2);
% grid on
% title('Effects of Varying BackProp Depth on Validation Accuracy');
% legend(...
%   'training on FC ONLY', ...
%   'training on FC + 1 blocks', ...
%   'training on FC + 2 blocks', ...
%   'training on FC + 3 blocks', ...
%   'training on FC + 4 blocks', ...
%   'training on FC + 5 blocks (FULL)');
% xlabel('epoch')
% ylabel('Validation Error');
% saveas(h, sprintf('Validation Comparison - %d.png', epochNum));


% == == == == == == == == == == == == == == == == == == == == == == == == == ==
% == == == == == == == == == == == == == == == == == == == == == == == == == ==


% dataDir = '/Volumes/Amir-1/results/';
% subDataDir = '2016-11-1-1; FC+5; compRand weights; CIFAR portion = 50; testing different weight decays';
% epochNum = 50;
% epochFile = sprintf('net-epoch-%d.mat', epochNum);
% fprintf('Loading files...'); i = 1;


% weight_decay_1e_1 = load(fullfile(dataDir, subDataDir, 'cifar-alex-net-1-Nov-2016-15-37-00-GPU1', epochFile)); fprintf('\t%d', i); i = i + 1;
% weight_decay_1e_2 = load(fullfile(dataDir, subDataDir, 'cifar-alex-net-1-Nov-2016-16-46-28-GPU1', epochFile)); fprintf('\t%d', i); i = i + 1;
% weight_decay_1e_3 = load(fullfile(dataDir, subDataDir, 'cifar-alex-net-1-Nov-2016-17-57-49-GPU1', epochFile)); fprintf('\t%d', i); i = i + 1;
% weight_decay_1e_4 = load(fullfile(dataDir, subDataDir, 'cifar-alex-net-1-Nov-2016-19-08-39-GPU1', epochFile)); fprintf('\t%d', i); i = i + 1;
% weight_decay_0 = load(fullfile(dataDir, subDataDir, 'cifar-alex-net-1-Nov-2016-20-18-55-GPU1', epochFile)); fprintf('\t%d', i); i = i + 1;
% fprintf('\nDone!');

% figure;
% plot( ...
%   1:1:epochNum, [weight_decay_0.info.train.error(1,:)], ...
%   1:1:epochNum, [weight_decay_1e_4.info.train.error(1,:)], ...
%   1:1:epochNum, [weight_decay_1e_3.info.train.error(1,:)], ...
%   1:1:epochNum, [weight_decay_1e_2.info.train.error(1,:)], ...
%   1:1:epochNum, [weight_decay_1e_1.info.train.error(1,:)], ...
%   'LineWidth', 2);
% grid on
% title('Effects of Varying Weight Decay on Training Accuracy');
% legend(...
%   'weight decay = 0', ...
%   'weight decay = 1e-4', ...
%   'weight decay = 1e-3', ...
%   'weight decay = 1e-2', ...
%   'weight decay = 1e-1');
% xlabel('epoch')
% ylabel('Training Error');

% figure;
% plot( ...
%   1:1:epochNum, [weight_decay_0.info.val.error(1,:)], ...
%   1:1:epochNum, [weight_decay_1e_4.info.val.error(1,:)], ...
%   1:1:epochNum, [weight_decay_1e_3.info.val.error(1,:)], ...
%   1:1:epochNum, [weight_decay_1e_2.info.val.error(1,:)], ...
%   1:1:epochNum, [weight_decay_1e_1.info.val.error(1,:)], ...
%   'LineWidth', 2);
% grid on
% title('Effects of Varying Weight Decay on Validation Accuracy');
% legend(...
%   'weight decay = 0', ...
%   'weight decay = 1e-4', ...
%   'weight decay = 1e-3', ...
%   'weight decay = 1e-2', ...
%   'weight decay = 1e-1');
% xlabel('epoch')
% ylabel('Validation Error');


% == == == == == == == == == == == == == == == == == == == == == == == == == ==
% == == == == == == == == == == == == == == == == == == == == == == == == == ==


% dataDir = '/Volumes/Amir-1/results/';
% subDataDir = '2016-11-01-02; AlexNet; testing different bottle neck compresson ratios; layers 1, 2 ';
% epochNum = 50;
% epochFile = sprintf('net-epoch-%d.mat', epochNum);
% fprintf('Loading files...'); i = 1;


% bottle_neck_divide_by_1 = load(fullfile(dataDir, subDataDir, 'cifar-alex-net-bottle-neck-1-Nov-2016-23-50-31-GPU2', epochFile)); fprintf('\t%d', i); i = i + 1;
% bottle_neck_divide_by_2 = load(fullfile(dataDir, subDataDir, 'cifar-alex-net-bottle-neck-2-Nov-2016-03-25-34-GPU2', epochFile)); fprintf('\t%d', i); i = i + 1;
% bottle_neck_divide_by_4 = load(fullfile(dataDir, subDataDir, 'cifar-alex-net-bottle-neck-2-Nov-2016-06-02-52-GPU2', epochFile)); fprintf('\t%d', i); i = i + 1;
% bottle_neck_divide_by_8 = load(fullfile(dataDir, subDataDir, 'cifar-alex-net-bottle-neck-2-Nov-2016-08-14-13-GPU2', epochFile)); fprintf('\t%d', i); i = i + 1;
% bottle_neck_divide_by_16 = load(fullfile(dataDir, subDataDir, 'cifar-alex-net-bottle-neck-2-Nov-2016-10-17-47-GPU2', epochFile)); fprintf('\t%d', i); i = i + 1;

% fprintf('\nDone!');

% figure;
% plot( ...
%   1:1:epochNum, [bottle_neck_divide_by_1.info.train.error(1,:)], ...
%   1:1:epochNum, [bottle_neck_divide_by_2.info.train.error(1,:)], ...
%   1:1:epochNum, [bottle_neck_divide_by_4.info.train.error(1,:)], ...
%   1:1:epochNum, [bottle_neck_divide_by_8.info.train.error(1,:)], ...
%   1:1:epochNum, [bottle_neck_divide_by_16.info.train.error(1,:)], ...
%   'LineWidth', 2);
% grid on
% title('Effects of Varying Bottle Neck Compresson on Training Accuracy');
% legend(...
%   'bottle neck divide by = 1', ...
%   'bottle neck divide by = 2', ...
%   'bottle neck divide by = 4', ...
%   'bottle neck divide by = 8', ...
%   'bottle neck divide by = 16');
% xlabel('epoch')
% ylabel('Training Error');

% figure;
% plot( ...
%   1:1:epochNum, [bottle_neck_divide_by_1.info.val.error(1,:)], ...
%   1:1:epochNum, [bottle_neck_divide_by_2.info.val.error(1,:)], ...
%   1:1:epochNum, [bottle_neck_divide_by_4.info.val.error(1,:)], ...
%   1:1:epochNum, [bottle_neck_divide_by_8.info.val.error(1,:)], ...
%   1:1:epochNum, [bottle_neck_divide_by_16.info.val.error(1,:)], ...
%   'LineWidth', 2);
% grid on
% title('Effects of Varying Bottle Neck Compresson on Validation Accuracy');
% legend(...
%   'bottle neck divide by = 1', ...
%   'bottle neck divide by = 2', ...
%   'bottle neck divide by = 4', ...
%   'bottle neck divide by = 8', ...
%   'bottle neck divide by = 16');
% xlabel('epoch')
% ylabel('Validation Error');


% % == == == == == == == == == == == == == == == == == == == == == == == == == ==
% % == == == == == == == == == == == == == == == == == == == == == == == == == ==


% dataDir = '/Volumes/Amir-1/results/';
% subDataDir = '2016-11-03-03; LeNet; testing different bottle neck compresson ratios; layers 1 & layers 1, 2 ';
% epochNum = 20;
% epochFile = sprintf('net-epoch-%d.mat', epochNum);
% fprintf('Loading files...'); i = 1;

% cifar_lenet_1_1 = load(fullfile(dataDir, subDataDir, 'cifar-lenet-1-1', epochFile)); fprintf('\t%d', i); i = i + 1;
% cifar_lenet_1_2 = load(fullfile(dataDir, subDataDir, 'cifar-lenet-1-2', epochFile)); fprintf('\t%d', i); i = i + 1;
% cifar_lenet_1_4 = load(fullfile(dataDir, subDataDir, 'cifar-lenet-1-4', epochFile)); fprintf('\t%d', i); i = i + 1;
% cifar_lenet_1_8 = load(fullfile(dataDir, subDataDir, 'cifar-lenet-1-8', epochFile)); fprintf('\t%d', i); i = i + 1;
% cifar_lenet_1_16 = load(fullfile(dataDir, subDataDir, 'cifar-lenet-1-16', epochFile)); fprintf('\t%d', i); i = i + 1;
% cifar_lenet_2_1 = load(fullfile(dataDir, subDataDir, 'cifar-lenet-2-1', epochFile)); fprintf('\t%d', i); i = i + 1;
% cifar_lenet_2_2 = load(fullfile(dataDir, subDataDir, 'cifar-lenet-2-2', epochFile)); fprintf('\t%d', i); i = i + 1;
% cifar_lenet_2_4 = load(fullfile(dataDir, subDataDir, 'cifar-lenet-2-4', epochFile)); fprintf('\t%d', i); i = i + 1;
% cifar_lenet_2_8 = load(fullfile(dataDir, subDataDir, 'cifar-lenet-2-8', epochFile)); fprintf('\t%d', i); i = i + 1;
% cifar_lenet_2_16 = load(fullfile(dataDir, subDataDir, 'cifar-lenet-2-16', epochFile)); fprintf('\t%d', i); i = i + 1;
% cifar_lenet_no_bottle_neck = load(fullfile(dataDir, subDataDir, 'cifar-lenet-no-bottle-neck', epochFile)); fprintf('\t%d', i); i = i + 1;

% fprintf('\nDone!');

% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
% % number of bottle necks = 1
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
% getCompressionRate = @(k) (96 + 64*(32+k))/(3168);

% h = figure;
% plot( ...
%   1:1:epochNum, [cifar_lenet_1_1.info.train.error(1,:)], ...
%   1:1:epochNum, [cifar_lenet_1_2.info.train.error(1,:)], ...
%   1:1:epochNum, [cifar_lenet_1_4.info.train.error(1,:)], ...
%   1:1:epochNum, [cifar_lenet_1_8.info.train.error(1,:)], ...
%   1:1:epochNum, [cifar_lenet_1_16.info.train.error(1,:)], ...
%   1:1:epochNum, [cifar_lenet_no_bottle_neck.info.train.error(1,:)], ...
%   'k--', ...
%   'LineWidth', 2);
% grid on
% title('Effects of Varying Bottle Neck Compression on Training Accuracy');
% legend(...
%   sprintf('bottle-neck count = 1; k = 1, [conv] size: %3.2f', getCompressionRate(1)), ...
%   sprintf('bottle-neck count = 1; k = 2, [conv] size: %3.2f', getCompressionRate(2)), ...
%   sprintf('bottle-neck count = 1; k = 4, [conv] size: %3.2f', getCompressionRate(4)), ...
%   sprintf('bottle-neck count = 1; k = 8, [conv] size: %3.2f', getCompressionRate(8)), ...
%   sprintf('bottle-neck count = 1; k = 16, [conv] size: %3.2f', getCompressionRate(16)), ...
%   sprintf('NO bottle-neck[conv] size: %3.2f', 1.00));
% xlabel('epoch')
% ylabel('Training Error');
% saveas(h,'Training Comparison - 1 bottle necks.png')

% h = figure;
% plot( ...
%   1:1:epochNum, [cifar_lenet_1_1.info.val.error(1,:)], ...
%   1:1:epochNum, [cifar_lenet_1_2.info.val.error(1,:)], ...
%   1:1:epochNum, [cifar_lenet_1_4.info.val.error(1,:)], ...
%   1:1:epochNum, [cifar_lenet_1_8.info.val.error(1,:)], ...
%   1:1:epochNum, [cifar_lenet_1_16.info.val.error(1,:)], ...
%   1:1:epochNum, [cifar_lenet_no_bottle_neck.info.val.error(1,:)], ...
%   'k--', ...
%   'LineWidth', 2);
% grid on
% title('Effects of Varying Bottle Neck Compression on Validation Accuracy');
% legend(...
%   sprintf('bottle-neck count = 1; k = 1, [conv] size: %3.2f', getCompressionRate(1)), ...
%   sprintf('bottle-neck count = 1; k = 2, [conv] size: %3.2f', getCompressionRate(2)), ...
%   sprintf('bottle-neck count = 1; k = 4, [conv] size: %3.2f', getCompressionRate(4)), ...
%   sprintf('bottle-neck count = 1; k = 8, [conv] size: %3.2f', getCompressionRate(8)), ...
%   sprintf('bottle-neck count = 1; k = 16, [conv] size: %3.2f', getCompressionRate(16)), ...
%   sprintf('NO bottle-neck[conv] size: %3.2f', 1.00));
% xlabel('epoch')
% ylabel('Validation Error');
% saveas(h,'Validation Comparison - 1 bottle necks.png')

% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
% % number of bottle necks = 2
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
% getCompressionRate = @(k) (96 + 160*k)/(3168);
% h = figure;
% plot( ...
%   1:1:epochNum, [cifar_lenet_2_1.info.train.error(1,:)], ...
%   1:1:epochNum, [cifar_lenet_2_2.info.train.error(1,:)], ...
%   1:1:epochNum, [cifar_lenet_2_4.info.train.error(1,:)], ...
%   1:1:epochNum, [cifar_lenet_2_8.info.train.error(1,:)], ...
%   1:1:epochNum, [cifar_lenet_2_16.info.train.error(1,:)], ...
%   1:1:epochNum, [cifar_lenet_no_bottle_neck.info.train.error(1,:)], ...
%   'k--', ...
%   'LineWidth', 2);
% grid on
% title('Effects of Varying Bottle Neck Compression on Training Accuracy');
% legend(...
%   sprintf('bottle-neck count = 2; k = 1, [conv] size: %3.2f', getCompressionRate(1)), ...
%   sprintf('bottle-neck count = 2; k = 2, [conv] size: %3.2f', getCompressionRate(2)), ...
%   sprintf('bottle-neck count = 2; k = 4, [conv] size: %3.2f', getCompressionRate(4)), ...
%   sprintf('bottle-neck count = 2; k = 8, [conv] size: %3.2f', getCompressionRate(8)), ...
%   sprintf('bottle-neck count = 2; k = 16, [conv] size: %3.2f', getCompressionRate(16)), ...
%   sprintf('NO bottle-neck[conv] size: %3.2f', 1.00));
% xlabel('epoch')
% ylabel('Training Error');
% saveas(h,'Training Comparison - 2 bottle necks.png')

% h = figure;
% plot( ...
%   1:1:epochNum, [cifar_lenet_2_1.info.val.error(1,:)], ...
%   1:1:epochNum, [cifar_lenet_2_2.info.val.error(1,:)], ...
%   1:1:epochNum, [cifar_lenet_2_4.info.val.error(1,:)], ...
%   1:1:epochNum, [cifar_lenet_2_8.info.val.error(1,:)], ...
%   1:1:epochNum, [cifar_lenet_2_16.info.val.error(1,:)], ...
%   1:1:epochNum, [cifar_lenet_no_bottle_neck.info.val.error(1,:)], ...
%   'k--', ...
%   'LineWidth', 2);
% grid on
% title('Effects of Varying Bottle Neck Compression on Validation Accuracy');
% legend(...
%   sprintf('bottle-neck count = 2; k = 1, [conv] size: %3.2f', getCompressionRate(1)), ...
%   sprintf('bottle-neck count = 2; k = 2, [conv] size: %3.2f', getCompressionRate(2)), ...
%   sprintf('bottle-neck count = 2; k = 4, [conv] size: %3.2f', getCompressionRate(4)), ...
%   sprintf('bottle-neck count = 2; k = 8, [conv] size: %3.2f', getCompressionRate(8)), ...
%   sprintf('bottle-neck count = 2; k = 16, [conv] size: %3.2f', getCompressionRate(16)), ...
%   sprintf('NO bottle-neck[conv] size: %3.2f', 1.00));
% xlabel('epoch')
% ylabel('Validation Error');
% saveas(h,'Validation Comparison - 2 bottle necks.png')
