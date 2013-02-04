#include "DaemonStarter.h"
#include <unistd.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <string>
#include <iostream>
using namespace std;

int DaemonStarter::RunDaemon()
{
	pid = fork();

    if (pid == -1) // ���� �� ������� ��������� �������
    {
        // ������� �� ����� ������ � � ��������
       cout<<"error creatin pid"<<endl;
    }
    else if (!pid) // ���� ��� �������
    {
	cout<<"child pid"<<endl;   
        GoDeep();
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