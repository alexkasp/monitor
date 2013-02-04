#pragma once
#include <signal.h>
#include "DaemonMonitor.h"
#include "Logger.h"

 
class SimpleMonitor :
	public DaemonMonitor
{
	int      pid;
    int      status;
    
    sigset_t sigset;
    siginfo_t siginfo;
	SimpleMonitor(const SimpleMonitor&);
public:

	Logger* log;

	SimpleMonitor(Daemon* daemon);
	
	virtual ~SimpleMonitor(void);
	int StartMonitor();
	virtual int Run();
	virtual int Monitoring();
	int ChildMonitoring();
	int UserMonitoring();
};

