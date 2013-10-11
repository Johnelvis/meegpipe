function [W, A, selection, obj] = learn_basis(obj, data, varargin)

% Documentation: class_fastica.txt
% Description: Learns Fastica basis functions

import fastica.fastica;

% Configuration options
approach = get_config(obj, 'Approach');
nonlin   = get_config(obj, 'Nonlinearity');

% Set the random number generator state

randSeed = get_seed(obj);

warning('off', 'MATLAB:RandStream:ActivatingLegacyGenerators');
rand('state',  randSeed); %#ok<RAND>
randn('state', randSeed); %#ok<RAND>
warning('on', 'MATLAB:RandStream:ActivatingLegacyGenerators');

obj = set_seed(obj, randSeed);

initGuess = get_init(obj, data);

[A W] = fastica(data, ...
    'verbose',      'off', ...
    'approach',     approach, ...
    'g',            nonlin, ...
    'InitGuess',    initGuess);

if isempty(W),
    W = randn(size(data,1));
    selection = [];
elseif size(W,1) < size(data,1),
    selection = 1:size(W,1);
    W = [W;randn(size(data,1)-size(W,1), size(data,2))];
else
    selection = 1:size(W,1);
end



end