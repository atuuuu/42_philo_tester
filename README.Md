### Philosopher tester

Copy the tester.sh script in your project.

Run it with :
``bash tester.sh``

Your Makefile must support CFLAGS environment variable :


Example makefile
```
...
NAME = philo
CFLAGS **+**= -Wall -Wextra -Werror

...

%.o: %.c:

	$(CC) -c $(CFLAGS) $< -o $@

...
```


This way, my script can inject Makefile flags during compilation.
It is also how makefile handles CFLAGS if you don't define neither CFLAGS nor '%.o:%.c' rule (these are implicitely defined by make).
