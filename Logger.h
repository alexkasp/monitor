#pragma once
#include <string>
using namespace std;
class Logger
{
public:
	Logger(void);
	~Logger(void);
	virtual void WriteLog(string,string=NULL) const;
};

