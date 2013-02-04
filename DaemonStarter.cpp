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

    if (pid == -1) // если не удалось запустить потомка
    {
        // выведем на экран ошибку и её описание
       cout<<"error creatin pid"<<endl;
    }
    else if (!pid) // если это потомок
    {
	cout<<"child pid"<<endl;   
        GoDeep();
        // Данная функция будет осуществлять слежение за процессом
		status = monitor->StartMonitor();
        
        return status;
    }
    else // если это родитель
    {
        // завершим процес, т.к. основную свою задачу (запуск демона) мы выполнили
        return 0;
    }
	return 0;
}

int DaemonStarter::GoDeep()
{
	 // данный код уже выполняется в процессе потомка
        // разрешаем выставлять все биты прав на создаваемые файлы, 
        // иначе у нас могут быть проблемы с правами доступа
        umask(0);
        
        // создаём новый сеанс, чтобы не зависеть от родителя
        setsid();
        
        // переходим в корень диска, если мы этого не сделаем, то могут быть проблемы.
        // к примеру с размантированием дисков
        chdir("/");
        
        // закрываем дискрипторы ввода/вывода/ошибок, так как нам они больше не понадобятся
        close(STDIN_FILENO);
        close(STDOUT_FILENO);
        close(STDERR_FILENO);
}