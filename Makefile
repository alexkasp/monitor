CFLAGS=-g
main: DaemonStarter.o Daemon.o Task.o myfunc.o Logger.o SimpleMonitor.o DaemonMonitor.o
	c++ $(CFLAGS) -o main main.cpp myfunc.o DaemonMonitor.o Daemon.o DaemonStarter.o Task.o Logger.o  SimpleMonitor.o
DaemonStarter.o: DaemonStarter.cpp DaemonStarter.h
	c++ $(CFLAGS) -c  DaemonStarter.cpp -o DaemonStarter.o
Daemon.o: DaemonInterface.cpp DaemonInterface.h
	c++ $(CFLAGS)  -c DaemonInterface.cpp -o Daemon.o
Task.o: DaemonTask.cpp DaemonTask.h
	c++ $(CFLAGS) -c DaemonTask.cpp -o Task.o
Logger.o: Logger.cpp Logger.h
	c++ $(CFLAGS) -c Logger.cpp -o Logger.o
SimpleMonitor.o: SimpleMonitor.cpp SimpleMonitor.h
	c++ $(CFLAGS) -c SimpleMonitor.cpp -o SimpleMonitor.o
DaemonMonitor.o: DaemonMonitor.cpp DaemonMonitor.h
	c++ $(CFLAGS) -c DaemonMonitor.cpp -o DaemonMonitor.o
myfunc.o: myfunc.cpp
	c++ $(CFLAGS) -c myfunc.cpp -o myfunc.o
clean:
	rm DaemonStarter.o Daemon.o Task.o Logger.o myfunc.o SimpleMonitor.o main