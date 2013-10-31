function obj = load(filename)
% LOAD - Loads a pset.pset object from a .mat file
%
%
% obj = load(filename)
%
% Where
%
% FILENAME is the full path to the .mat file
%
%
% See also: pset.pset, pset


import mperl.file.spec.rel2abs
import pset.pset;

if iscell(filename),
   obj = cell(size(filename));
   for i = 1:numel(filename)
      obj{i} = pset.load(filename{i});      
   end
   return;
end

filename = rel2abs(filename);

tmp = load(filename, '-mat');

obj = tmp.obj;
[path, name] = fileparts(filename);
[~, ~, extOld] = fileparts(get_datafile(obj));
obj.DataFile = [path '/' name extOld];
obj.HdrFile = filename;