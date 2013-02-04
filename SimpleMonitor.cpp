#include "SimpleMonitor.h"
#include <sys/types.h>
#include <stdio.h>
       #include <sys/wait.h>
const char PID_FILE[]= "/var/run/my_daemon.pid";

extern void SetPidFile(const char* Filename);

SimpleMonitor::SimpleMonitor(Daemon* daemon):DaemonMonitor(daemon),log(new Logger)
{
	SetNeedRestart();
}


SimpleMonitor::~SimpleMonitor(void)
{
}

int SimpleMonitor::StartMonitor()
{
	sigemptyset(&sigset);
    
    // ������ ��������� �������� �������������
    sigaddset(&sigset, SIGQUIT);
    
    // ������ ��� ��������� �������� ������������� � ���������
    sigaddset(&sigset, SIGINT);
    
    // ������ ������� ���������� ��������
    sigaddset(&sigset, SIGTERM);
    
    // ������ ���������� ��� ��������� ������� ��������� ��������
    sigaddset(&sigset, SIGCHLD); 
    
    // ���������������� ������ ������� �� ����� ������������ ��� ���������� �������
    sigaddset(&sigset, SIGUSR1); 
    sigprocmask(SIG_BLOCK, &sigset, NULL);

	SetPidFile(PID_FILE);
	printf("prepare RUN\n");
	return Run();
}

int SimpleMonitor::Run()
{
    for (;;)
    {
        // ���� ���������� ������� �������
        if (GetRestart())
        {
            // ������ �������
            pid = fork();
    	    printf("restarting daemon\n");
        }
        
        SetNeedRestart();
        
        if (pid == -1) // ���� ��������� ������
        {
            // ������� � ��� ��������� �� ����
            log->WriteLog("[MONITOR] Fork failed:", "error");
        }
        else if (!pid) // ���� �� �������
        {
            // ������ ��� ����������� � �������
        	printf("daemon start begining...\n");
            // �������� ������� ���������� �� ������ ������
			status = RunDaemon();
            
            // �������� �������
            return status;
        }
        else // ���� �� ��������
        {
		if(!Monitoring())
		    return 0;
        }
    }
}

int SimpleMonitor::Monitoring()
{
	   // ������ ��� ����������� � ��������
            
            // ������� ����������� �������
            sigwaitinfo(&sigset, &siginfo);
            printf("start monitoring\n");
            // ���� ������ ������ �� �������
            if (siginfo.si_signo == SIGCHLD)
            {
		return ChildMonitoring();
            }
            else if (siginfo.si_signo == SIGUSR1) // ���� ������ ������ ��� ���������� ������������� ������
            {
                UserMonitoring();
            }
            else if(siginfo.si_signo == SIGINT)
            {
        	kill(pid, SIGTERM);
        	return 0;	
            }
            else // ���� ������ �����-���� ������ ��������� ������
            {
                // ������� � ��� ���������� � ��������� �������
                log->WriteLog("[MONITOR] Signal: ", "error");
                
                // ����� �������
                kill(pid, SIGTERM);
                status = 0;
                return 1;
            }
}

int SimpleMonitor::ChildMonitoring()
{
	  // �������� ������ ����������
                wait(&status);
                
                // ����������� ������ � ���������� ���
                status = WEXITSTATUS(status);

                 // ���� ������� �������� ������ � ����� ��������� � ���, ��� ��� ����� ������ ��������
                if (status == 0)
                {
                    // ������� � ��� �������� �� ����        
                   log->WriteLog("[MONITOR] Child stopped\n");
                    
                    // ������� ����
                    return 0;
                }
                else if (status == 1) // ���� ��������� ������������� �������
                {
                    // ������� � ��� ������ �������
                   log->WriteLog("[MONITOR] Child restart\n");
                }
		return 1;
}

int SimpleMonitor::UserMonitoring()
{
	kill(pid, SIGUSR1); // �������� ��� �������
    CancelRestart(); // ��������� ���� ��� ��� �� ���� ��������� ������� ������
}