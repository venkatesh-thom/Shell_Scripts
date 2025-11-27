#!/bin/bash 



#wc -l – Prints the number of lines in a file.
#wc -w – prints the number of words in a file.
#wc -c – Displays the count of bytes in a file.
#wc -m – prints the count of characters from a file.
#wc -L – prints only the length of the longest line in a file.


### 1 method
file="count-words.txt"
count=0
while  IFS= read -r  line;
do
    #echo $line
    count=$((count+1))
done < "$file"
echo "number of lines with awk :"
awk 'END { print NR }' $file
echo "number of lines with sed  :"
sed -n '$=' $file

echo "number of words with wc :"
wc -w $file

echo "number of character with wc :"
wc -m $file