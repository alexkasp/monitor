#include "DaemonInterface.h"

class DaemonStarter
{
	Daemon daemon_obj;
	DaemonStarter(){};
	//DaemonStarter& operator=(DaemonStarter){};
public:
	DaemonStarter(Daemon):daemon_obj(Daemon){};
	virtual ~DaemonStarter();
	int RunDaemon();
};