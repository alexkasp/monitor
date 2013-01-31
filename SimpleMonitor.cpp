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
    
    // сигнал остановки процесса пользователем
    sigaddset(&sigset, SIGQUIT);
    
    // сигнал для остановки процесса пользователем с терминала
    sigaddset(&sigset, SIGINT);
    
    // сигнал запроса завершения процесса
    sigaddset(&sigset, SIGTERM);
    
    // сигнал посылаемый при изменении статуса дочернего процесса
    sigaddset(&sigset, SIGCHLD); 
    
    // пользовательский сигнал который мы будем использовать для обновления конфига
    sigaddset(&sigset, SIGUSR1); 
    sigprocmask(SIG_BLOCK, &sigset, NULL);

	SetPidFile(PID_FILE);

	return Run();
}

int SimpleMonitor::Run()
{
	for (;;)
    {
        // если необходимо создать потомка
        if (GetRestart())
        {
            // создаём потомка
            pid = fork();
        }
        
        SetNeedRestart();
        
        if (pid == -1) // если произошла ошибка
        {
            // запишем в лог сообщение об этом
            log->WriteLog("[MONITOR] Fork failed:", strerror(errno));
        }
        else if (!pid) // если мы потомок
        {
            // данный код выполняется в потомке
            
            // запустим функцию отвечающую за работу демона
			status = RunDaemon();
            
            // завершим процесс
            exit(status);
        }
        else // если мы родитель
        {
			Monitoring();
        }
    }
}

int SimpleMonitor::Monitoring()
{
	   // данный код выполняется в родителе
            
            // ожидаем поступление сигнала
            sigwaitinfo(&sigset, &siginfo);
            
            // если пришел сигнал от потомка
            if (siginfo.si_signo == SIGCHLD)
            {
				if(!ChildMonitoring())
					return 0;
            }
            else if (siginfo.si_signo == SIGUSR1) // если пришел сигнал что необходимо перезагрузить конфиг
            {
                UserMonitoring();
            }
            else // если пришел какой-либо другой ожидаемый сигнал
            {
                // запишем в лог информацию о пришедшем сигнале
                log->WriteLog("[MONITOR] Signal: ", strsignal(siginfo.si_signo));
                
                // убьем потомка
                kill(pid, SIGTERM);
                status = 0;
                return 0;
            }
}

int SimpleMonitor::ChildMonitoring()
{
	  // получаем статус завершение
                wait(&status);
                
                // преобразуем статус в нормальный вид
                status = WEXITSTATUS(status);

                 // если потомок завершил работу с кодом говорящем о том, что нет нужды дальше работать
                if (status == CHILD_NEED_TERMINATE)
                {
                    // запишем в лог сообщени об этом        
                   log->WriteLog("[MONITOR] Child stopped\n");
                    
                    // прервем цикл
                    return 0;
                }
                else if (status == CHILD_NEED_WORK) // если требуется перезапустить потомка
                {
                    // запишем в лог данное событие
                   log->WriteLog("[MONITOR] Child restart\n");
                }
		return 1;
}

int SimpleMonitoring::UserMonitoring()
{
	kill(pid, SIGUSR1); // перешлем его потомку
    CancelRestart(); // установим флаг что нам не надо запускать потомка заново
}