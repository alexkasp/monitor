#include "DaemonInterface.h"


Daemon::Daemon():log(new Logger)
{

}
int Daemon::Run()
{
	sigact.sa_flags = SA_SIGINFO;
    // ������ ������� ���������� ��������
    sigact.sa_sigaction = signal_error;

    sigemptyset(&sigact.sa_mask);

    // ��������� ��� ���������� �� �������
    
    sigaction(SIGFPE, &sigact, 0); // ������ FPU
    sigaction(SIGILL, &sigact, 0); // ��������� ����������
    sigaction(SIGSEGV, &sigact, 0); // ������ ������� � ������
    sigaction(SIGBUS, &sigact, 0); // ������ ����, ��� ��������� � ���������� ������

    sigemptyset(&sigset);
    
    // ��������� ������� ������� ����� �������
    // ������ ��������� �������� �������������
    sigaddset(&sigset, SIGQUIT);
    
    // ������ ��� ��������� �������� ������������� � ���������
    sigaddset(&sigset, SIGINT);
    
    // ������ ������� ���������� ��������
    sigaddset(&sigset, SIGTERM);
    
    // ���������������� ������ ������� �� ����� ������������ ��� ���������� �������
    sigaddset(&sigset, SIGUSR1); 
    sigprocmask(SIG_BLOCK, &sigset, NULL);

    // ��������� ������������ ���-�� ������������ ������� ����� �������
    SetFdLimit(FD_LIMIT);
    
    // ������� � ���, ��� ��� ����� ���������
    log->WriteLog("[DAEMON] Started\n");
    
    // ��������� ��� ������� ������
    status = InitTasks();
	 if (!status)
     {
		return MessageHandler();
	 }
	 else
	 {
	     log->WriteLog("[DAEMON] Create work thread failed\n");
     }

     log->WriteLog("[DAEMON] Stopped\n");
    
    // ������ ��� �� ��������� �����������
    return CHILD_NEED_TERMINATE;
}

int Daemon::MessageHandler()
{
	  for (;;)
        {
            // ���� ��������� ���������
            sigwait(&sigset, &signo);
        
            // ���� �� ��������� ���������� �������
            if (signo == SIGUSR1)
            {
                // ������� ������
                status = ReloadConfig();
                if (status == 0)
                {
                    log->WriteLog("[DAEMON] Reload config failed\n");
                }
                else
                {
                    log->WriteLog("[DAEMON] Reload config OK\n");
                }
            }
            else // ���� �����-���� ������ ������, �� ������ �� �����
            {
                break;
            }
        }
        
        // ��������� ��� ������� ������ � ��������� ������� �� ��� ����
        return DestroyTasks();
}

int Daemon::InitTasks()
{
	return 0;
}

int Daemon::DestroyTasks()
{
	return 0;
}

int Daemon::ReloadConfig()
{
	return 1;
}