#include "DaemonInterface.h"
#include <stdio.h>

#define FD_LIMIT 10

void SetPidFile(const char* Filename);


Daemon::Daemon():log(new Logger)
{

}
int Daemon::Run()
{
    printf("now we in daemon\n");
	sigact.sa_flags = SA_SIGINFO;
    // ������ ������� ���������� ��������
  //  sigact.sa_sigaction = reinterpret_cast<void (*)(int, siginfo*, void*)>(&signal_error);

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
    //SetFdLimit(FD_LIMIT);
    // ������� � ���, ��� ��� ����� ���������
    log->WriteLog("[DAEMON] Started\n");
//    printf("first log\n");
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
    return 1;
}

int Daemon::MessageHandler()
{
	  for (;;)
        {
    	    printf("start wait for signals in daemon\n");
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
        	printf("THIS NOT SIGUSR1\n");
                break;
            }
        }
        printf("start stopping...\n");
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

void Daemon::signal_error(int sig, siginfo_t *si, void *ptr)
{
    void* ErrorAddr;
    void* Trace[16];
    int    x;
    int    TraceSize;
    char** Messages;

    // ������� � ��� ��� �� ������ ������
  //  WriteLog("[DAEMON] Signal: %s, Addr: 0x%0.16X\n", strsignal(sig), si->si_addr);

    
    #if __WORDSIZE == 64 // ���� ���� ����� � 64 ������ ��
        // ������� ����� ���������� ������� ������� ������
        ErrorAddr = (void*)((ucontext_t*)ptr)->uc_mcontext.gregs[REG_RIP];
    #else 
        // ������� ����� ���������� ������� ������� ������
        ErrorAddr = (void*)((ucontext_t*)ptr)->uc_mcontext.gregs[REG_EIP];
    #endif

    // ���������� backtrace ����� �������� ���� ���� ������� 
   // TraceSize = backtrace(Trace, 16);
   // Trace[1] = ErrorAddr;
/*
    // ������� ����������� ����������
    Messages = backtrace_symbols(Trace, TraceSize);
    if (Messages)
    {
        log->WriteLog("== Backtrace ==\n");
        
        // ������� � ���
        for (x = 1; x < TraceSize; x++)
        {
            log->WriteLog("%s\n", Messages[x]);
        }
        
        log->WriteLog("== End Backtrace ==\n");
        free(Messages);
    }
	*/
    log->WriteLog("[DAEMON] Stopped\n");
    
    // ��������� ��� ������� ������ � ��������� ������� �� ��� ����
   DestroyTasks();
    
    // �������� ������� � ����� ��������� �����������
    return;
}
