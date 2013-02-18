#include <deque>
#include <signal.h>
#include "ScriptTask.h"
#include "Logger.h"
#include<pthread.h>
using namespace std;

class Daemon
{		struct sigaction sigact;
		sigset_t         sigset;
		int             signo;
		int             status;

		deque<pair<DaemonTask*,pthread_t>> tasks;
	public:
		Logger* log;
		enum InsPlace {front,back};
		virtual int Run();
		Daemon();
		virtual ~Daemon()
		{
			
			for(auto x=tasks.begin();x!=tasks.end();++x)
				delete (*x).first;
		};
		static void TaskStarter(PVOID params)
		{
				DaemonTask* task =  (DaemonTask*)params;
				task->Run();
		}

		int InitTasks();
		int MessageHandler();
		int DestroyTasks();
		int ReloadConfig();
		void signal_error(int sig, siginfo_t *si, void *ptr);
		int AddTask(DaemonTask* newtask,InsPlace place)
		{
			if(place==front)
				tasks.push_front(make_pair(newtask,0));
			else
				tasks.push_back(make_pair(newtask,0));
		};
};