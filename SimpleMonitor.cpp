#include "SimpleMonitor.h"


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
        }
        
        SetNeedRestart();
        
        if (pid == -1) // ���� ��������� ������
        {
            // ������� � ��� ��������� �� ����
            log->WriteLog("[MONITOR] Fork failed:", strerror(errno));
        }
        else if (!pid) // ���� �� �������
        {
            // ������ ��� ����������� � �������
            
            // �������� ������� ���������� �� ������ ������
			status = RunDaemon();
            
            // �������� �������
            exit(status);
        }
        else // ���� �� ��������
        {
			Monitoring();
        }
    }
}

int SimpleMonitor::Monitoring()
{
	   // ������ ��� ����������� � ��������
            
            // ������� ����������� �������
            sigwaitinfo(&sigset, &siginfo);
            
            // ���� ������ ������ �� �������
            if (siginfo.si_signo == SIGCHLD)
            {
				if(!ChildMonitoring())
					return 0;
            }
            else if (siginfo.si_signo == SIGUSR1) // ���� ������ ������ ��� ���������� ������������� ������
            {
                UserMonitoring();
            }
            else // ���� ������ �����-���� ������ ��������� ������
            {
                // ������� � ��� ���������� � ��������� �������
                log->WriteLog("[MONITOR] Signal: ", strsignal(siginfo.si_signo));
                
                // ����� �������
                kill(pid, SIGTERM);
                status = 0;
                return 0;
            }
}

int SimpleMonitor::ChildMonitoring()
{
	  // �������� ������ ����������
                wait(&status);
                
                // ����������� ������ � ���������� ���
                status = WEXITSTATUS(status);

                 // ���� ������� �������� ������ � ����� ��������� � ���, ��� ��� ����� ������ ��������
                if (status == CHILD_NEED_TERMINATE)
                {
                    // ������� � ��� �������� �� ����        
                   log->WriteLog("[MONITOR] Child stopped\n");
                    
                    // ������� ����
                    return 0;
                }
                else if (status == CHILD_NEED_WORK) // ���� ��������� ������������� �������
                {
                    // ������� � ��� ������ �������
                   log->WriteLog("[MONITOR] Child restart\n");
                }
		return 1;
}

int SimpleMonitoring::UserMonitoring()
{
	kill(pid, SIGUSR1); // �������� ��� �������
    CancelRestart(); // ��������� ���� ��� ��� �� ���� ��������� ������� ������
}