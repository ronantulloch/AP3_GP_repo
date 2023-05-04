function [syllables, line_syl] = API(text)
line_syl = [];


i = 1;
while text(i) ~= "FINAL"
i = i + 1;
count = 0;
while text(i) ~= "NEWLINE"
	if text(i) == "START"
	count = count;
	i=i+1;
	elseif text(i) == "ENDLINE"
	count = count;
	i=i+1;
	else
%find a method of counting the number of syllables.
	count = hyphenate(text(i));
	i=i+1;
end
end
	line_syl = [line_syl, count]
end
syllables = sum(line_syl);
end