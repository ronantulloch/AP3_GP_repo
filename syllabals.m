function num  = syllabals(word)

data = webread("https://api.datamuse.com/words","sp", word,"qe","sp","md","s");

if iscell(data)
    num = data{1}.numSyllables;
else
    num = data.numSyllables;
end

end