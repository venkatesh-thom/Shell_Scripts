# Use for when you know the range.

# !/bin/bash
for i in {1..10};do 
  echo "$i"
done  

#loops
for i in {1..5}
do
    echo $i 
done  


# !/bin/bash
for i in $@
do
  echo "Hi $i"
done  

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


# for i in {1..10} → loop from 1 to 10.
# $i → current value of the loop.
# echo $i → prints the number.

# the semicolon ; is used to separate commands on the same line. In loops, it’s used to put do on the same line as for