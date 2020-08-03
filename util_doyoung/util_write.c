#include <sys/syscall.h>
#include <sys/types.h>
#include <sys/resource.h>
#include <sys/stat.h>
#include <stdio.h>
#include <unistd.h>
#include <string.h>
#include <stdlib.h>

void utilization(){
	int util_val;
	int util_size = 300;
	char buff[util_size];
	char command[100];
	FILE *gpu_stats;
	char gpu[10] = "GR3D_FREQ";
	char stat[3];
	FILE *util_file;

	//sprintf(command, "~/tegrastats > ~/hojin/gpu/darknet_gpu_thread/util_temp");
	//execl("/bin/sh", "sh", "-c", command, (char *)0);
#if 1
	pid_t pid;
	pid = fork();
	if(pid ==0){
		//sprintf(command, "~/tegrastats > ~/hojin/gpu/darknet_gpu_thread/util_temp");
		//execl("/bin/sh", "sh", "-c", command, (char *)0);
		//_exit(127);

		system("~/tegrastats > ~/hojin/gpu/darknet_gpu_thread/util_temp");
		exit(0);

	}
#endif
	
	gpu_stats = fopen("util_temp", "r");
	while(fgets(buff, util_size, gpu_stats) == NULL);

	system("kill -9 `ps -a | grep tegrastats | awk '{print $1}'` "); 

	char * ptr = strstr(buff, gpu);
	if(ptr == NULL)
		printf("\n No Util. info\n");	
	
	for(int i=0; i<3; i++){
		if(*(ptr+10+i) == '%')
			break;
		stat[i] = *(ptr+10+i);
		util_val = atoi(stat);
	}
	fclose(gpu_stats);
	
	do{
		util_file = fopen("util_pipe", "w");

	}while(util_file == NULL);

	printf("util : %d \n", util_val);
	fprintf(util_file, "%d", util_val);

	system("cat /dev/null > ~/doyoung/temp");
	fclose(util_file);
	
	return;
}

int main(){
	system("rm util_pipe");
	int cnt = 20;
	while(1){
		utilization();
	}
}	
