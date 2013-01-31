#include "Logger.h"
#include <iostream>
using namespace std;


Logger::Logger(void)
{
}


Logger::~Logger(void)
{
}

void Logger::WriteLog(string format,string value) const
{
	cout<<format<<" "<<value<<endl;
}