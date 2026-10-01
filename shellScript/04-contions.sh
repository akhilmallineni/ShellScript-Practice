#!/bin/bash

num1=10

if [ $num1 -gt 5 ]; then
    echo "$num1 is greater than 5"
elif [ $num1 -eq 5 ]; then
    echo "$num1 is equal to 5"
elif [ $num1 -lt 5 ]; then
    echo "$num1 is less than 5"
elif [ $num1 -ne 5 ]; then
    echo "$num1 is not equal to 5"
else
    echo "$num1 is not greater than 5"
fi


MOVIES=("RRR" "Varanasi" "Pushpa") # index always starts from 0
echo "Movies are: ${MOVIES[@]}"
echo "First movie is: ${MOVIES[0]}"
echo "Second movie is: ${MOVIES[1]}"
echo "Third movie is: ${MOVIES[2]}"