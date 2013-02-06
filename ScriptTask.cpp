#include "ScriptTask.h"


ScriptTask::ScriptTask(const char* command):DaemonTask(),commandstr(command)
{
}


ScriptTask::~ScriptTask(void)
{
}


int ScriptTask::Run()
{
	system(commandstr.c_str());
}