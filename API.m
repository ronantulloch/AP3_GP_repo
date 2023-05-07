function [syllables, numsyl] = API(text)
newText=split(text);
newText=transpose(newText);
numsyl=[];
syl=0;
for i=1:length(newText)
    if newText(i)=="START"
    elseif newText(i)== "NEWLINE"
        numsyl=[numsyl;syl];
        syl=0;
    elseif newText(i)=="ENDLINE"

    elseif newText(i)=="FINAL"
        numsyl=[numsyl;syl];
        break;
    else
        syl=sylWord(newText(i))+syl;
        
    end
end
syllables = sum(numsyl);
end