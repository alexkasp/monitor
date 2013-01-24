main: DaemonStarter.o
	c++ -o main main.cpp DaemonStarter.o
DaemonStarter.o: Starter.cpp Starter.h
	c++ -c  Starter.cpp -o DaemonStarter.o
clean:
	rm DaemonStarter.o main