#!/bin/bash

# For Loops:
# Used when the number of iterations is known. For example, printing numbers from 1 to 100.

#!/bin/bash
for i in {1..100}
do
    echo $i
done

#Basic Syntax
for var in item1 item2 item3; 
    do
    echo "item : " $var 
done


###  Loop over words
for color in red green blue;
    do
    echo "Color: $color"
done

 
###Loop over numbers
for i in {1..5}; 
    do
    echo "Number: $i"
done

### loop over steps
for i in {1..10..3};
   do 
   echo "Step::number:$i"
done

### Loop over files in a directory

for file in *.sh;
   do 
   echo "File in :$file"
done


#!/bin/bash

fruits=("apple" "banana" "cherry" "date")
for fruit in "${fruits[@]}"; 
    do
    echo "Current fruit: $fruit"
done


### Output redirecting into sleep.txt file ===> echo $i >>sleep.txt
for i in $(seq 1 10);do echo $i >>sleep.txt; sleep 1;done
