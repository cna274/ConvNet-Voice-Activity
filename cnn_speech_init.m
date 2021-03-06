function net = cnn_speech_init(varargin)
opts.networkType = 'simplenn' ;
opts = vl_argparse(opts, varargin) ;

lr = [.1 2] ;

% Define network CIFAR10-quick
net.layers = {} ;

% Block 1
net.layers{end+1} = struct('type', 'conv', ...
                           'weights', {{0.01*randn(5,5,1,40, 'single'), zeros(1, 40, 'single')}}, ...
                           'learningRate', lr, ...
                           'stride', 1, ...
                           'pad', 2) ;
net.layers{end+1} = struct('type', 'pool', ...
                           'method', 'max', ...
                           'pool', [3 3], ...
                           'stride', 2, ...
                           'pad', [0 1 0 1]) ;
net.layers{end+1} = struct('type', 'relu') ;

% % Block 2
net.layers{end+1} = struct('type', 'conv', ...
                           'weights', {{0.05*randn(5,5,40,40, 'single'), zeros(1,40,'single')}}, ...
                           'learningRate', lr, ...
                           'stride', 1, ...
                           'pad', 2) ;
net.layers{end+1} = struct('type', 'relu') ;
% net.layers{end+1} = struct('type', 'pool', ...
%                            'method', 'avg', ...
%                            'pool', [3 3], ...
%                            'stride', 2, ...
%                            'pad', [0 1 0 1]) ; % Emulate caffe
% 
% % Block 3
net.layers{end+1} = struct('type', 'conv', ...
                           'weights', {{0.05*randn(5,5,40,40, 'single'), zeros(1,40,'single')}}, ...
                           'learningRate', lr, ...
                           'stride', 1, ...
                           'pad', 2) ;

net.layers{end+1} = struct('type', 'pool', ...
                           'method', 'avg', ...
                           'pool', [3 3], ...
                           'stride', 2, ...
                           'pad', [0 1 0 1]) ; % Emulate caffe
net.layers{end+1} = struct('type', 'relu') ;
% net.layers{end+1} = struct('type', 'pool', ...
%                            'method', 'avg', ...
%                            'pool', [3 2], ...
%                            'stride', 2, ...
%                            'pad', [0 1 0 1]) ; % Emulate caffe

% % Block 4
net.layers{end+1} = struct('type', 'conv', ...
                           'weights', {{0.05*randn(5,5,40,40, 'single'), zeros(1,40,'single')}}, ...
                           'learningRate', lr, ...
                           'stride', 1, ...
                           'pad', 2) ;

net.layers{end+1} = struct('type', 'pool', ...
                           'method', 'avg', ...
                           'pool', [3 3], ...
                           'stride', 2, ...
                           'pad', [0 1 0 1]) ; % Emulate caffe
net.layers{end+1} = struct('type', 'relu') ;
% Block 5
net.layers{end+1} = struct('type', 'conv', ...
                           'weights', {{0.05*randn(5,5,40,2, 'single'), zeros(1,2,'single')}}, ...
                           'learningRate', lr, ...
                           'stride', 1, ...
                           'pad', 0) ;

                       
%
% %block 6
% net.layers{end+1} = struct('type', 'conv', ...
%                            'weights', {{0.05*randn(20,20,20,2, 'single'), zeros(1,2,'single')}}, ...
%                            'learningRate', .1*lr, ...
%                            'stride', 1, ...
%                            'pad', 0) ;

% Loss layer
net.layers{end+1} = struct('type', 'softmaxloss') ;

% Meta parameters
net.meta.inputSize = [40 40 1] ;
net.meta.trainOpts.learningRate = [0.08*ones(1,5) 0.05*ones(1,15) 0.005*ones(1,3) 0.0005*ones(1,3)];
net.meta.trainOpts.weightDecay = 0.0001 ;
net.meta.trainOpts.batchSize = 100 ;
net.meta.trainOpts.numEpochs = numel(net.meta.trainOpts.learningRate) ;

% Fill in default values
net = vl_simplenn_tidy(net) ;

% Switch to DagNN if requested
switch lower(opts.networkType)
  case 'simplenn'
    % done
  case 'dagnn'
    net = dagnn.DagNN.fromSimpleNN(net, 'canonicalNames', true) ;
    net.addLayer('error', dagnn.Loss('loss', 'classerror'), ...
             {'prediction','label'}, 'error') ;
  otherwise
    assert(false) ;
end

