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
    // задаем функцию обработчик сигналов
  //  sigact.sa_sigaction = reinterpret_cast<void (*)(int, siginfo*, void*)>(&signal_error);

    sigemptyset(&sigact.sa_mask);

    // установим наш обработчик на сигналы
    
    sigaction(SIGFPE, &sigact, 0); // ошибка FPU
    sigaction(SIGILL, &sigact, 0); // ошибочная инструкция
    sigaction(SIGSEGV, &sigact, 0); // ошибка доступа к памяти
    sigaction(SIGBUS, &sigact, 0); // ошибка шины, при обращении к физической памяти

    sigemptyset(&sigset);
    
    // блокируем сигналы которые будем ожидать
    // сигнал остановки процесса пользователем
    sigaddset(&sigset, SIGQUIT);
    
    // сигнал для остановки процесса пользователем с терминала
    sigaddset(&sigset, SIGINT);
    
    // сигнал запроса завершения процесса
    sigaddset(&sigset, SIGTERM);
    
    // пользовательский сигнал который мы будем использовать для обновления конфига
    sigaddset(&sigset, SIGUSR1); 
    sigprocmask(SIG_BLOCK, &sigset, NULL);

    // Установим максимальное кол-во дискрипторов которое можно открыть
    //SetFdLimit(FD_LIMIT);
    // запишем в лог, что наш демон стартовал
    log->WriteLog("[DAEMON] Started\n");
//    printf("first log\n");
    // запускаем все рабочие потоки
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
    
    // вернем код не требующим перезапуска
    return 1;
}

int Daemon::MessageHandler()
{
	  for (;;)
        {
    	    printf("start wait for signals in daemon\n");
            // ждем указанных сообщений
            sigwait(&sigset, &signo);
        
            // если то сообщение обновления конфига
            if (signo == SIGUSR1)
            {
                // обновим конфиг
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
            else // если какой-либо другой сигнал, то выйдим из цикла
            {
        	printf("THIS NOT SIGUSR1\n");
                break;
            }
        }
        printf("start stopping...\n");
        // остановим все рабочеи потоки и корректно закроем всё что надо
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

    // запишем в лог что за сигнал пришел
  //  WriteLog("[DAEMON] Signal: %s, Addr: 0x%0.16X\n", strsignal(sig), si->si_addr);

    
    #if __WORDSIZE == 64 // если дело имеем с 64 битной ОС
        // получим адрес инструкции которая вызвала ошибку
        ErrorAddr = (void*)((ucontext_t*)ptr)->uc_mcontext.gregs[REG_RIP];
    #else 
        // получим адрес инструкции которая вызвала ошибку
        ErrorAddr = (void*)((ucontext_t*)ptr)->uc_mcontext.gregs[REG_EIP];
    #endif

    // произведем backtrace чтобы получить весь стек вызовов 
   // TraceSize = backtrace(Trace, 16);
   // Trace[1] = ErrorAddr;
/*
    // получим расшифровку трасировки
    Messages = backtrace_symbols(Trace, TraceSize);
    if (Messages)
    {
        log->WriteLog("== Backtrace ==\n");
        
        // запишем в лог
        for (x = 1; x < TraceSize; x++)
        {
            log->WriteLog("%s\n", Messages[x]);
        }
        
        log->WriteLog("== End Backtrace ==\n");
        free(Messages);
    }
	*/
    log->WriteLog("[DAEMON] Stopped\n");
    
    // остановим все рабочие потоки и корректно закроем всё что надо
   DestroyTasks();
    
    // завершим процесс с кодом требующим перезапуска
    return;
}
