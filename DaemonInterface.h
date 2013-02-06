#include <deque>
#include <signal.h>
#include "ScriptTask.h"
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
		virtual ~Daemon()
		{
			
			for(auto x=tasks.begin();x!=tasks.end();++x)
				delete (*x);
		};
		int InitTasks();
		int MessageHandler();
		int DestroyTasks();
		int ReloadConfig();
		void signal_error(int sig, siginfo_t *si, void *ptr);
		int AddTask(DaemonTask* newtask,InsPlace place)
		{
			if(place==front)
				tasks.push_front(newtask);
			else
				tasks.push_back(newtask);
		};
};