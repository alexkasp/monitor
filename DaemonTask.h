#pragma once
#include "DaemonTask.h"

class DaemonTask
{
public:
	virtual int Run() =0;
	DaemonTask(void);
	virtual ~DaemonTask(void);
};

