function sylldb = Reun_syllablefeatures(rdb, sessind, vocind)
% sylldb = Reun_syllablefeatures(rdb, vocind)
%
% computes syllable features from a cell array of syllables
% Dependencies: 
%   - OF_loadsyll
% INPUT:
%  - snew
% OUTPUT:
%  - syllfeats is a struct of the following features for each syllable
%      - deguid
%      - ISI
%      - syllnum
%      - timefromshock
%      - syllduration
%      - pitchmean
%      - pitchvar
%      - pitchjumpnums
%       
%      - prevpitch
%      - nextpitch
%      - prevtime
%      - nexttime
%
% nei 6/16
%



dup1 = [1800 4250];
dup2 = [4250 6000];

sylldb.dur = rdb.cl_startend_clip(vocind,2, sessind) - rdb.cl_startend_clip(vocind,1, sessind);

            sylldb.meanpitch = nan;
            sylldb.dompitch = nan;
            sylldb.amp = nan;
            sylldb.disp = nan;    
                            sylldb.meanpitch10(1,1:10) = nan;
                sylldb.dompitch10(1,1:10) = nan;
                sylldb.amp10(1,1:10) = nan;
                sylldb.disp10(1,1:10) = nan;    
                sylldb.pitchjumpnums(1,1:4) = nan;

            voc = reunion_loadvocfromclip(rdb, sessind, vocind, 'cl');
            
   if ~isempty(voc{1})
           voc{1} = voc{1}(:,1);
            if length(voc{1}) > 441
                [S, F, T] = spectrogram(voc{1}, 44100/100, 0, [400:100:16000], 44100);
            else
                [S, F, T] = spectrogram(voc{1}, length(voc{1}), 0, [400:100:16000], 44100);
            end
            syllamp = mean(abs(S));
%            syllparts = find(syllamp > .04);
            sylldispersion = OF_spec_purity(S, mean(diff(F)));            
            [jnk p_syllfrq] = max(abs(S));
         	syllfrq = F(p_syllfrq);
            
            meanpitch = sum(abs(S).* repmat(F, 1, size(F,2))) ./ repmat(sum(F), 1, size(F,2));
            
            dsf = diff(syllfrq);
            
            lsf = length(syllfrq);
            
            syllampparts = syllamp;
            
            g = floor(lsf/10);
            
            sylldb.meanpitch = meanpitch;
            sylldb.dompitch = syllfrq;
            sylldb.amp = syllampparts;
            sylldb.disp = sylldispersion;          
            
            if length(meanpitch) > 9
                for m = 1:10
                    sylldb.meanpitch10(1,m) = nanmean(meanpitch(((m-1)*g+1):(m * g)));
                    sylldb.dompitch10(1,m) = nanmedian(syllfrq(((m-1)*g+1):(m * g)));
                    sylldb.amp10(1,m) = nanmean(syllampparts(((m-1)*g+1):(m * g)));
                    sylldb.disp10(1,m) = nanmean(sylldispersion(((m-1)*g+1):(m * g)));
                end
                             
            end
            
            
            sylldb.pitchjumpnums(1,1) = length(find(dsf > dup1(1) & dsf <= dup1(2)));
            sylldb.pitchjumpnums(1,2) = length(find(dsf < -1*dup1(1) & dsf >= -1*dup1(2)));
            sylldb.pitchjumpnums(1,3) = length(find(dsf > dup2(1)));
            sylldb.pitchjumpnums(1,4) = length(find(dsf < -1*dup2(1)));
   end
            
%            if k > 1
%                sylldb.prevpitch(n) = sylldb.pitchmean(n-1);
%                sylldb.prevtime(n) = sylldb.times(n,1)-sylldb.times(n-1,2);
%            end
%            if k < size(allvocs{i,j},1)       
%                sylldb.nextpitch(n-1) = sylldb.pitchmean(n);
%                sylldb.nexttime(n-1) = sylldb.times(n,1)-sylldb.times(n-1,2);
%            end
            
          %  dsf = diff(syllfrq);
%            allsylljumps(n:n+length(syllfrq)-2,1:2) = [syllfrq(1:end-1) syllfrq(2:end)];
            
%            n = n+1;
%            dbs = 1;


%sylldb.deguid = sylldb.deguid(1:n);
%sylldb.syllnum = sylldb.syllnum(1:n);
%sylldb.times = sylldb.times(1:n,:);
%sylldb.dur = sylldb.dur(1);
%sylldb.timefromshock = sylldb.timefromshock(1:n,:);
%sylldb.pitchmean = sylldb.pitchmean(1:n);
%sylldb.pitchdisp = sylldb.pitchdisp(1:n);
%sylldb.pitchvar = sylldb.pitchvar(1:n);
%sylldb.pitch10 = sylldb.pitch10(1:n,:);
%sylldb.disp10 = sylldb.disp10(1:n,:);
%sylldb.pitchjumpnums = sylldb.pitchjumpnums(1:n,:);
