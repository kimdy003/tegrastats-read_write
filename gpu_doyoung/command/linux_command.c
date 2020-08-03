#include <sys/syscall.h>
#include <sys/types.h>
#include <sys/resource.h>
#include <sys/wait.h>
#include <stdio.h>
#include <unistd.h>
#include <string.h>
#include <stdlib.h>

#define MAX 300

int main(){
	char buff[MAX];
	FILE *gpu_stats;
	char command[100];
	char gpu[10] = "GR3D_FREQ";
	char stat[3];
	int val;
	int cnt = 10;
#if 1
	pid_t pid;
	pid = fork();
	if(pid ==0){
		while(cnt--){
			printf("child process\n");
			sprintf(command, "~/tegrastats > ~/doyoung/temp");
			system(command);
		}
			//sprintf(command, "~/tegrastats > ~/doyoung/temp");
			//execl("/bin/sh", "sh", "-c", command, (char *)0);
		//_exit(127);
	}
#endif 

	while(cnt--){
		printf("parent process\n");
		gpu_stats = fopen("temp", "r");
		while(fgets(buff, MAX, gpu_stats) == NULL);

		system("kill -9 `ps -a | grep tegrastats | awk '{print $1}'` ");
		//fseek(gpu_stats, 0, SEEK_SET); 

		char * ptr = strstr(buff, gpu);
		if(ptr == NULL)
			printf("\n No Util. info\n");	
	
		for(int i=0; i<3; i++){
			if(*(ptr+10+i) == '%')
				break;
			stat[i] = *(ptr+10+i);
		}
		val = atoi(stat);
		printf("%d \n", val);
		system("cat /dev/null > ~/doyoung/temp");
		fclose(gpu_stats);
	}

	//fclose(gpu_stats);
	return 1;
}


