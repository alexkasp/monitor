main: DaemonStarter.o Daemon.o Task.o Logger.o SimpleMonitor.o
	c++ -o main main.cpp DaemonStarter.o Task.o Logger.o SimpleMonitor.o
DaemonStarter.o: Starter.cpp Starter.h
	c++ -c  Starter.cpp -o DaemonStarter.o
DaemonInterface: DaemonInterface.cpp DaemonInterface.h
	c++ -c DaemonInterface.cpp -o Daemon.o
DaemonTask: DaemonTask.cpp DaemonTask.h
	c++ -c DaemonTask.cpp -o Task.o
Logger: Logger.cpp Logger.h
	c++ -c Logger.cpp -o Logger.o
SimpleMonitor: SimpleMonitor.cpp SimpleMonitor.h
	c++ -c SimpleMonitor.cpp -o SimpleMonitor.o
clean:
	rm DaemonStarter.o Daemon.o Task.o Logger.o SimpleMonitor.o main