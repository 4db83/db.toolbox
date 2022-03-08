function res = sample(n, urn)
% SAMPLE( n, urn )
% take n samples, with replacement, from the given urn
% urn can be:
% 1) a simple vector, as in 1:10 or sin(1:10)
% 
% 2) a matrix specifying multiplicities and values, e.g.
%    [  5 1; 
%      21 2; 
%      31 3]
%    which consists of 5 ones, 21 twos and 31 threes.
%    the multiplicities must be integers, but the values 
%    don't have to be.  
% 
% 3) a matrix specifying relative probabilities and values, e.g.
%    [ .05    1; 
%      .08532 2;
%      .55    3]
%    The relative probabilities are given in the first column
%    and the corresponding values in the second.  If the relative
%    probabilities don't add up to 1, they will be normalized
%    to one appropriately.
%    Given a choice between (2) and (3) --- for instance if
%    the probabilities are in percents, it's much faster to use
%    (2) rather than (3).  For instance,
%    sample(100, [10 0; 10 1; 80 2])
%    is much faster than
%    sample(100, [.10 0; .10 1; .80 2])
%    although the end result is the same
%
% CAUTION: in (2) and (3) above, make sure to 
% use the SEMI-COLON (and not the comma) if typing all the entries 
% on one line, e.g., [5 1; 21 2; 31 3].
%
% 4) an urn.  See URN.  See also NORMAL, UNIFORM, ...

% (c) 1998-9 by Daniel T. Kaplan, All Rights Reserved
% Version 1.0

[r,c] = size(urn);

if isstruct(urn)
   % deal with an urn, in all it's complexity
   % the idea of an urn is to allow it to include urns recursively
   % and also to preprocess the creation of the key used
   % for integer multiplicity urns
   % the algorithm should probably be the same as that used for
   % fractional multiplicities.
   
   if isfield(urn, 'id') & strcmp(urn.id,'urn')
     % it really is an urn
     if strcmp(urn.type, 'compound')
        cumulative = cumsum(urn.probs); 
        total = sum(urn.probs);
        % generate some random numbers
        rnds = total*rand(n,1);
        randinds = zeros(n,1);
        sofar = zeros(n,1);
        % loop over the outcomes to find which outcome to use for each sample
        for k=1:length(urn.probs)
           % find the ones whose res is less than cumulative(k)
           % and which haven't yet been found.
           inds = find( rnds <= cumulative(k) & ~sofar);
	   randinds(inds) = k;
           sofar(inds) = 1;
        end 
        if any(~sofar)
          error('Sample: Invalid relative probabilities.');
        end
        % now we have the random indices to the outcomes.  
        % Some of the outcomes may be URNS and need to be generated recursively
        % for efficiency, generate all of the outcomes of each type 
        % at once.
        [cnt,vls] = multiples(randinds);
	res = zeros(n,1);
        startind = 0;
        for k=1:length(cnt)
	   foo = sample(cnt(k), urn.outcomes{vls(k)});
	   res((startind+1):(startind+cnt(k))) = foo;
           startind = startind + cnt(k);
        end
        if length(res) > 1
	  res = shuffle(res);
        end
     else
        % it's an 'atomic' urn.  Just generate the numbers appropriately.
        thisurn = urn; % set variable for the next eval call.
        res = eval(sprintf(urn.generate,n));
     end
  else
     error('sample: invalid argument.  Give me an urn or vector/matrix.');
  end
elseif r==1 | c == 1
   % it's a simple vector
   inds = ceil( rand(n,1)*length(urn) );
   res = urn(inds);
elseif c == 2
   mults = urn(:,1);
   vals = urn(:,2);
   total = sum(mults);
   if all( floor(mults) == mults )
      % it the relative probabilities are integers
      expanded = expand(urn);
      res = sample(n, expanded);
   else 
      % the relative probabilities are fractions; use the slow
      % method.
      cumulative = cumsum(mults); 
      % generate some random numbers
      rnds = total*rand(n,1);
      res = zeros(n,1);
      sofar = zeros(n,1);
      % loop over the outcomes
      for k=1:r
         % find the ones whose res is less than cumulative(k)
         % and which haven't yet been found.
         inds = find( rnds <= cumulative(k) & ~sofar);
         res(inds) = vals(k);
         sofar(inds) = 1;
      end 
      if any(~sofar)
         error('Sample: Invalid relative probabilities.');
      end
   end 
end
   
   



