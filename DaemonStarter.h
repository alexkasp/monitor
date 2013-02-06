#include "DaemonMonitor.h"
#include "Logger.h"

class DaemonStarter
{
	DaemonMonitor* monitor;
	DaemonStarter(){};
	int pid;
	int status;
	int GoDeep();
	Logger* log;
public:
	DaemonStarter(DaemonMonitor* obj)
		:monitor(obj),log(new Logger())
			{};
	virtual ~DaemonStarter(){};
	int RunDaemon();
	
};