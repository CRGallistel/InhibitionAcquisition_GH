function AM = AcqQuartiles(varargin)
% all but the last argument in varargin are column arrays of acquisition
% points from the usestat fields specified in the call. The last argument
% is a row vector of purely numerical group ID numbers. The number of
% elements in this group should match the number of arrays passed in from
% usestat fields
AM = nan(5,4);
AM(1,2:4) = 1:3; % 1st 2nd & 3rd quartile
if numel(varargin{end})==length(varargin)-1 % number of group ID numbers is
    % the same as the number of arrays for which medians will be computed
    AM(2:1+length(varargin{end})) = varargin{end}'; % group identification #s in Col 1
    for r = 1:length(varargin)-1 % filling in the medians in Col 2
        AM(r+1,2:4) = quantile(varargin{r},[.25 .5 .75]);
    end
else
    fprintf('\nError: Number of group identification numbers is not equal to number of medians!\n')
end