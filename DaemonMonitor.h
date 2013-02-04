#pragma once
#include <string>
#include "DaemonInterface.h"
using namespace std;

class DaemonMonitor
{
	Daemon* daemon;
	int      need_start;
public:
	DaemonMonitor(Daemon* obj);
	virtual ~DaemonMonitor(void);
	virtual int StartMonitor() =0;
	//int SetPidFile(char* Filename);
	//virtual void WriteLog(string msg,string param);
	virtual int Monitoring() =0;
	int RunDaemon(){return daemon->Run();};
	void SetNeedRestart(){need_start=1;};
	void CancelRestart(){need_start=0;};
	int GetRestart(){return need_start;};
};

