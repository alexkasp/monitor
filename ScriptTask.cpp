#include "ScriptTask.h"


ScriptTask::ScriptTask(const char* command):DaemonTask(),commandstr(command)
{
}


ScriptTask::~ScriptTask(void)
{
}


int ScriptTask::Run()
{
    printf("%s\n",commandstr.c_str());
	if(system(commandstr.c_str())>0)
	    printf("success\n");
	 else
	    printf("error\n");
}	