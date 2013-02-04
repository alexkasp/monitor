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
	printf("prepare RUN\n");
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
    	    printf("restarting daemon\n");
        }
        
        SetNeedRestart();
        
        if (pid == -1) // если произошла ошибка
        {
            // запишем в лог сообщение об этом
            log->WriteLog("[MONITOR] Fork failed:", "error");
        }
        else if (!pid) // если мы потомок
        {
            // данный код выполняется в потомке
        	printf("daemon start begining...\n");
            // запустим функцию отвечающую за работу демона
			status = RunDaemon();
            
            // завершим процесс
            return status;
        }
        else // если мы родитель
        {
		if(!Monitoring())
		    return 0;
        }
    }
}

int SimpleMonitor::Monitoring()
{
	   // данный код выполняется в родителе
            
            // ожидаем поступление сигнала
            sigwaitinfo(&sigset, &siginfo);
            printf("start monitoring\n");
            // если пришел сигнал от потомка
            if (siginfo.si_signo == SIGCHLD)
            {
		return ChildMonitoring();
            }
            else if (siginfo.si_signo == SIGUSR1) // если пришел сигнал что необходимо перезагрузить конфиг
            {
                UserMonitoring();
            }
            else if(siginfo.si_signo == SIGINT)
            {
        	kill(pid, SIGTERM);
        	return 0;	
            }
            else // если пришел какой-либо другой ожидаемый сигнал
            {
                // запишем в лог информацию о пришедшем сигнале
                log->WriteLog("[MONITOR] Signal: ", "error");
                
                // убьем потомка
                kill(pid, SIGTERM);
                status = 0;
                return 1;
            }
}

int SimpleMonitor::ChildMonitoring()
{
	  // получаем статус завершение
                wait(&status);
                
                // преобразуем статус в нормальный вид
                status = WEXITSTATUS(status);

                 // если потомок завершил работу с кодом говорящем о том, что нет нужды дальше работать
                if (status == 0)
                {
                    // запишем в лог сообщени об этом        
                   log->WriteLog("[MONITOR] Child stopped\n");
                    
                    // прервем цикл
                    return 0;
                }
                else if (status == 1) // если требуется перезапустить потомка
                {
                    // запишем в лог данное событие
                   log->WriteLog("[MONITOR] Child restart\n");
                }
		return 1;
}

int SimpleMonitor::UserMonitoring()
{
	kill(pid, SIGUSR1); // перешлем его потомку
    CancelRestart(); // установим флаг что нам не надо запускать потомка заново
}