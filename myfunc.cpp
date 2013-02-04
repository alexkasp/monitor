#include <stdio.h>
 #include <sys/types.h>
       #include <unistd.h>


void SetPidFile(const char* Filename)
{
    FILE* f;
    printf("SetPidFile %s\n",Filename);
    f = fopen(Filename, "w+");
    if (f)
    {
        fprintf(f, "%u", getpid());
        fclose(f);
    }
}