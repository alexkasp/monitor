//start module, this
//module for start monitor daemon
//24.01.2013 
#include "DaemonStarter.h"
#include "SimpleMonitor.h"
#include <iostream>
#include <string>
using namespace std;

int main(int argc,char** argv)
{
	Daemon obj;
<<<<<<< .mine
	obj.AddTask(new ScriptTask("/home/test.php"),Daemon::InsPlace::front);
=======
	obj.AddTask(new ScriptTask("/home/proxy /home/test.php"),Daemon::InsPlace::front);
>>>>>>> .r11
	SimpleMonitor monitor(&obj);
	DaemonStarter start(&monitor);
        start.RunDaemon();

	return 0;
}