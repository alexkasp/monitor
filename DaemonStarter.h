#include "DaemonMonitor.h"

class DaemonStarter
{
	DaemonMonitor* monitor;
	DaemonStarter(){};
	int pid;
	int status;
	int GoDeep();
public:
	DaemonStarter(DaemonMonitor* obj)
		:monitor(obj)
			{};
	virtual ~DaemonStarter();
	int RunDaemon();
	
};