function syl=sylWord(word)    
temp=char(word);
    temparvowel=[];
    temparcon=[];
    for j=1:length(temp)
        if temp(j)=='a'||temp(j)=='e'||temp(j)=='i'||temp(j)=='o'||temp(j)=='u'||temp(j)=='y'
            temparvowel=[temparvowel j];
        else
            temparcon=[temparcon j];
        end
    end
    check=0;
    for k=1:length(temparvowel)-1
    if temparvowel(k+1)-temparvowel(k)>1
    check=check+1;
    end
    end
    if length(temp)<=3
        check=0;
    end
    check=check+1;
	syl=check;
end
