function disp(t)
%DISP Display information of DTREE object.
%
%   See also GET, READ, SET, WRITE.

%   M. Misiti, Y. Misiti, G. Oppenheim, J.M. Poggi 22-Dec-2006.
%   Last Revision 08-May-2012.
%   Copyright 1995-2020 The MathWorks, Inc.

% Get wavelet packet tree information.
order = treeord(t);
depth = treedpth(t);
tn = leaves(t);
dataSize = read(t,'sizes',0);

headerStr = char(...
	getWavMSG('Wavelet:moreMSGRF:WDECTREE_OBJ_Head'), ...
    sprintf('%s','===============================') ...
	);

infoStr = char(...
	getWavMSG('Wavelet:moreMSGRF:Tree_OBJ_Size'), ...
	getWavMSG('Wavelet:moreMSGRF:Tree_OBJ_Order'), ...
	getWavMSG('Wavelet:moreMSGRF:Tree_OBJ_Depth'), ...
	getWavMSG('Wavelet:moreMSGRF:Tree_OBJ_TN')  ...
	);

	
% Setting Strings.
%-----------------
tn = tn';
nb_tn = length(tn);
lStr = '['; 
if nb_tn>16 , nb_tn = 16; rStr = ' ...]'; else  rStr = ']'; end
tnStr = [lStr int2str(tn(1:nb_tn)) rStr];
addLen = 20;
sep = '-';
sepStr = sep(ones(1,size(infoStr,2)+addLen));	


% Displaying.
%------------
disp(' ')
disp(headerStr);
ind = 1;     disp([infoStr(ind,:) , '[' int2str(dataSize) ']'])
ind = ind+1; disp([infoStr(ind,:) , int2str(order)])
ind = ind+1; disp([infoStr(ind,:) , int2str(depth)])
ind = ind+1; disp([infoStr(ind,:) , tnStr])
disp(sepStr);
disp(' ')
