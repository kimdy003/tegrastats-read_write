#include <sys/syscall.h>
#include <sys/types.h>
#include <sys/resource.h>
#include <sys/wait.h>
#include <stdio.h>
#include <unistd.h>
#include <string.h>
#include <stdlib.h>

#define MAX 255

int main(){
	char buff[MAX];
	FILE *gpu_stats;
	char command[100];
	char gpu[10] = "GR3D_FREQ";
	while(1){
#if 1
		FILE *fp;
		pid_t child_pid;
		child_pid = fork();
		if(child_pid == 0){
			char child_command[100];
			sprintf(child_command, "~/tegrastats > ~/doyoung/temp");
			system(child_command);
			exit(0);
		}
		
		sleep(1);
		system("kill -9 `ps -a | grep tegrastats | awk '{print $1}'` ");
		
		wait(NULL);
#endif
		gpu_stats = fopen("temp", "r");
		if(gpu_stats != NULL){
			break;
		}
	}
	
	char stat[5];
	int val;
	while(fgets(buff, MAX, gpu_stats) != NULL){
		stat[1] = '\0';

		char * ptr = strstr(buff, gpu);
		if(ptr == NULL)
			continue;

		for(int i=0; i<5; i++){
			if(*(ptr+10+i) == '%')
				break;
			stat[i] = *(ptr+10+i);
		}
		val = atoi(stat);
		printf("%d \n", val);
	}

	fclose(gpu_stats);
	return 1;
}


