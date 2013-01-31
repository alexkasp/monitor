#include "DaemonStarter.h"
#include <unistd.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <string>
using namespace std;

int DaemonStarter::RunDaemon() throw(string)
{
	pid = fork();

    if (pid == -1) // ���� �� ������� ��������� �������
    {
        // ������� �� ����� ������ � � ��������
        throw strerror(errno);
    }
	else if (!pid) // ���� ��� �������
    {
       
      //  GoDeep();
        // ������ ������� ����� ������������ �������� �� ���������
		status = monitor->StartMonitor();
        
        return status;
    }
    else // ���� ��� ��������
    {
        // �������� ������, �.�. �������� ���� ������ (������ ������) �� ���������
        return 0;
    }
	return 0;
}

int DaemonStarter::GoDeep()
{
	 // ������ ��� ��� ����������� � �������� �������
        // ��������� ���������� ��� ���� ���� �� ����������� �����, 
        // ����� � ��� ����� ���� �������� � ������� �������
        umask(0);
        
        // ������ ����� �����, ����� �� �������� �� ��������
        setsid();
        
        // ��������� � ������ �����, ���� �� ����� �� �������, �� ����� ���� ��������.
        // � ������� � ���������������� ������
        chdir("/");
        
        // ��������� ����������� �����/������/������, ��� ��� ��� ��� ������ �� �����������
        close(STDIN_FILENO);
        close(STDOUT_FILENO);
        close(STDERR_FILENO);
}