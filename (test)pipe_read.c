#include <stdio.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <unistd.h>
#include <stdlib.h>
#define MAX 100

int main(){
	FILE *fd;
	int val;
	char str[MAX];
	int cnt = 10;

	unlink("util_pipe");
	mkfifo("util_pipe", 0660);
	
	fd = fopen("util_pipe", "r");
	while(cnt--){
		if( fd != NULL){
			while(fgets(str, MAX, fd) == NULL);
		
			val = atoi(str);
			printf("util : %d \n", val);
		}
	}
	fclose(fd);
}

