export CFLAGS="-fsanitize=thread -Ofast -g"
make re --silent

if [ true ]
then
	echo "Invalid input"
	echo
	echo ./philo
	./philo
	echo
	echo ./philo ""
	./philo ""
	echo
	echo ./philo "test"
	./philo "test"
	echo
	echo ./philo "test" 1 1 1
	./philo "test" 1 1 1
	echo
	echo ./philo 9 9 9 9 9 9 9
	./philo 9 9 9 9 9 9 9
	echo
	echo ./philo -5 800 200 200 1
	./philo -5 800 200 200 1
	echo
	echo ./philo 5 -800 200 200 1
	./philo 5 -800 200 200 1
	echo
	echo ./philo 5 800 -200 200 1
	./philo 5 800 -200 200 1
	echo
	echo ./philo 5 800 200 -200 1
	./philo 5 800 200 -200 1
	echo
	echo ./philo 0 800 200 200 1
	./philo 0 800 200 200 1
	echo
	echo ./philo 3 0 200 200 1
	./philo 3 0 200 200 1
	echo
	echo ./philo 3 800 0 200 1
	./philo 3 800 0 200 1
	echo
	echo ./philo 7 800 200 0 1
	./philo 7 800 200 0 1
fi

echo
echo "./philo 1 800 200 200"
LINE_COUNT=$(./philo 1 800 200 200 | tee temp | wc -l)
if [ $LINE_COUNT != 2 ]
then
	printf "\033[031mKO\nDid you pick a fork before dying ?\n\033[0m"
	cat temp
	exit 42
else
	printf '\033[032mOK\n\033[0m' 
fi

for args in "5 800 200 200 7" "4 410 200 200 80"
do
	COUNT=$(expr "$(echo $args | cut -d' ' -f1)" '*' "$(echo $args | cut -d' ' -f5)")
	echo "Compiled with -fsanitize=thread -g :"
	echo "./philo $args"
	for i in {1..7}
	do 
		rm temp -f
		LINE_COUNT=$(./philo $args | tee temp | grep "is eating" | wc -l)
		if [ ! $LINE_COUNT -ge  $COUNT ] 
		then 
			printf '\033[031mKO\n\033[0m' 
			cat temp
			echo "Line count : $LINE_COUNT"
			exit 42 
		else 
			printf '\033[032mOK \033[0m' 
		fi 
	done
	printf '\n'
	
	export CFLAGS="-g -Ofast"
	make re --silent
	
	echo "valgrind --quiet --tool=helgrind --fair-sched=yes ./philo $args"
	for i in {1..7}
	do 
		rm temp -f
		LINE_COUNT=$(valgrind --quiet --tool=helgrind ./philo $args | tee temp | grep "is eating" | wc -l)
		if [ ! $LINE_COUNT -ge $COUNT ] 
		then 
			printf '\033[031mKO\n\033[0m' 
			cat temp
			echo "Line count : $LINE_COUNT"
			exit 42 
		else 
			printf '\033[032mOK \033[0m' 
		fi 
	done
	printf '\n'
	
	echo "valgrind --quiet --tool=drd --fair-sched=yes ./philo $args"
	for i in {1..7}
	do 
		rm temp -f
		LINE_COUNT=$(valgrind --quiet --tool=drd ./philo $args | tee temp | grep "is eating" | wc -l)
		if [ ! $LINE_COUNT -ge $COUNT ] 
		then 
			printf '\033[031mKO\n\033[0m' 
			cat temp
			echo "Line count : $LINE_COUNT"
			exit 42 
		else 
			printf '\033[032mOK \033[0m' 
		fi 
	done
	printf '\n'
done

make fclean --silent
