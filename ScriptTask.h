#pragma once
#include <string>
#include "DaemonTask.h"

class ScriptTask: public DaemonTask
{
	const std::string commandstr;
	ScriptTask(void);
public:
	ScriptTask(const char* command);
	~ScriptTask(void);
	int Run();
};

