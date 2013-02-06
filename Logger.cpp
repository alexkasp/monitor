#include "Logger.h"
#include <iostream>
#include <fstream>
using namespace std;


ofstream file;

Logger::Logger(void)
{
	file.open("/home/log",fstream::out);
}


Logger::~Logger(void)
{
}

void Logger::WriteLog(string format,string value) const
{
    if(!value.empty())
	file<<format<<" "<<endl;
    else
	file<<format<<endl;

}