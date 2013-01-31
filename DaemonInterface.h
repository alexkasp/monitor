#include <deque>
#include <signal.h>
#include "DaemonTask.h"
#include "Logger.h"
using namespace std;

class Daemon
{		struct sigaction sigact;
		sigset_t         sigset;
		int             signo;
		int             status;

		deque<DaemonTask*> tasks;
	public:
		Logger* log;
		enum InsPlace {front,back};
		virtual int Run();
		Daemon();
		virtual ~Daemon(){};
		int InitTasks();
		int MessageHandler();
		int DestroyTasks();
		int ReloadConfig();
		int AddTask(DaemonTask* newtask,InsPlace place)
		{
			if(place==front)
				tasks.push_front(newtask);
			else
				tasks.push_back(newtask);
		};
};