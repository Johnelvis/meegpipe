function obj = mr(sr, varargin)
% MR - Pipeline for removing MR artifacts from simultaneous EEG-fMRI

import meegpipe.*;
import misc.process_arguments;
import misc.isnatural;

if nargin < 1 || isempty(sr) || ~isnatural(sr),
    error('The data sampling rate must be provided');
end

opt.TR          = 2.605;  % For testing purposes
opt.NbSlices    = 1;     % Number of slices per volume, for testing only
[~, opt] = process_arguments(opt, varargin);

[~, pipeName] = fileparts(mfilename('fullpath'));


% A node to fix the timings of the TR events
fixEventTimeNode = node.fix_event_time.new(...
    'DataSelector',     pset.selector.sensor_idx(1), ...
    'EventSelector',    physioset.event.class_selector('Class', 'tr'), ...
    'Offset',           -round(opt.TR*sr), ...
    'Duration',         round(opt.TR*sr), ...
    'MaxShift',         5);

% A node to correct MR artifacts using a template
% 'DataSelector',     pset.selector.sensor_idx(1:3), ...
mraNode = node.mra.new(...   
    'EventSelector',    physioset.event.class_selector('Class', 'tr'), ...
    'TR',               opt.TR, ...
    'NbSlices',         opt.NbSlices, ...
    'NN',               10, ...
    'TemplateFunc',     @(x) mean(x,2), ...
    'SearchWindow',     400, ...
    'LPF',              40);

obj = node.pipeline.new('NodeList', ...
    {...
    fixEventTimeNode, ...
    mraNode ...
    }, ...
    ...
    'Name', pipeName, ...
    'Save', true, ...  
    varargin{:});




end