function AM = AcqMedians(varargin)
% all but the last argument in varargin are column arrays of acquisition
% points from the usestat fields specified in the call. The last argument
% is a row vector of purely numerical group ID numbers. The number of
% elements in this group should match the number of arrays passed in from
% usestat fields
if numel(varargin{end})==length(varargin)-1 % number of group ID numbers is
    % the same as the number of arrays for which medians will be computed
    AM(:,1) = varargin{end}'; % group identification #s in Col 1
    for r = 1:length(varargin)-1 % filling in the medians in Col 2
        AM(r,2) = median(varargin{r});
    end
else
    fprintf('\nError: Number of group identification numbers is not equal to number of medians!\n')
end

AM(AM(:,2)==1500,2) = nan; % medians of 1500 converted to nans,
% because we initialized estimated acquisition points to 1500 for graphic
% reasons (so that failures to acquire were evident in cumulative
% distributions of acquisition points). 1500 is more than the total # of
% trials  