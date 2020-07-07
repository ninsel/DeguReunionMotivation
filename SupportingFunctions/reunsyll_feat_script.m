%
% reunsyll_feat_script
%
%

%sdb = struct;

 for i = 1:length(rdb.paircode)
    fprintf(' %d...', i);
    indvoc = find(~isnan(rdb.cl_startend_clip(:,1,i)));
    for j = 1:length(indvoc)
        %    fprintf(' %d, %d...', i,j);
        sylldb = Reun_syllablefeatures(rdb, i, j);
        if i == 1 & j == 1
            sdb = sylldb;
        else
            sdb(i,j) = sylldb;    
        end
    end
    save('C:\YDRIVE\Degu\reunion\sdbtemp.mat', 'sdb');
end