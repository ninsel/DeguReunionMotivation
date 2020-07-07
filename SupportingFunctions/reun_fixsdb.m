function sdbnew = reun_fixsdb(sdb)
%
t = 10; %window for the moving average
        %careful here as we may already have smoothed the spectrograms, so
        %at this point all brief changes are being pretty heavily filtered
        %out

sdbnew = sdb;
for i = 1:size(sdb,1)
	for j = 1:size(sdb,2)
    	if ~isempty(sdb(i,j).dur)
         	dp = sdb(i,j).dompitch;
         	ind400 = find(dp == 400);
         	dp(ind400) = nan;
        	q = movmean(dp, t, 'omitnan');      
            sdbnew(i,j).dompitch = q;
            if length(q) >= 10
            	sdbnew(i,j).dompitch10(1,:) = resample(fillmissing(q, 'nearest'), 10, length(q));
            else
                dbs = 1;
            end
        end
    end
end
            
    