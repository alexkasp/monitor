#include "DaemonInterface.h"


Daemon::Daemon():log(new Logger)
{

}
int Daemon::Run()
{
	sigact.sa_flags = SA_SIGINFO;
    // задаем функцию обработчик сигналов
    sigact.sa_sigaction = signal_error;

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
    SetFdLimit(FD_LIMIT);
    
    // запишем в лог, что наш демон стартовал
    log->WriteLog("[DAEMON] Started\n");
    
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
    return CHILD_NEED_TERMINATE;
}

int Daemon::MessageHandler()
{
	  for (;;)
        {
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
                break;
            }
        }
        
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