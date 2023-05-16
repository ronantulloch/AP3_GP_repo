% This script will get the syllables

lengths = readcell("R_Outputs\total_line_lengths.csv");
lengths = lengths(2:end, :);

for i = 1:length(lengths)
	if contains(lengths(i,1), "START")
		lengths{i,5} = syllabals(lengths(i,1)) - 3;
	elseif contains(lengths(i,1), "FINAL")
		lengths{i,5} = syllabals(lengths(i,1)) - 3;
	else 
		lengths{i,5} = syllabals(lengths(i,1)) - 4;
	end
end

save("Matlab_Outputs/syllables.mat", "lengths")
