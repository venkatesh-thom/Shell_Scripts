# !/bin/bash

# While Loops:
# Used when the number of iterations is not known and continues as long as the condition is true.
#Check if a website is working using a while loop:

while true
do
    curl https://www.google.com | grep -i google
    sleep 1
done


count=1
while [ "$count" -le 5 ];
do 
  echo "$count"
  ((count++))
done  


# 🔄 Flow of Execution
# Start: count=1
# Check condition: 1 -le 5 → ✅ true → run loop   ("Keep looping as long as $count is less than or equal to 5")
# Print → "Count: 1"
# Increment → count=2
# Repeat until count=6
# Condition fails → exit loop

count=10
while [ $count -ge 5 ]
do
    echo $count
    ((count--))
done