!#/bin/bash


str_problema="problema$1.pddl"
str_dominio="dominio$1.pddl"

./ff -o ${str_dominio} -f ${str_problema} -O -g 1 -h 1 
