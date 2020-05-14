function AvgPrec = computeap(scores, labels)
[junk, Index] = sort(-scores); 
TrueLabel = labels(Index); 
AvgPrec = 0; 
NumPos = 0; 
for j = 1:length(TrueLabel) 
    NumPos = NumPos + (TrueLabel(j) == 1); 
    AvgPrec = AvgPrec + (TrueLabel(j) == 1) * NumPos / j; 
end; 
if (sum(TrueLabel == 1) ~= 0)  
	AvgPrec = AvgPrec / sum(TrueLabel == 1); 
end; 
	

