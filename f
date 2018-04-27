1.
#include<stdlib.h>
#include<stdio.h>
#include<fcntl.h>
#include<string.h>
#include<sys/stat.h>
#include<unistd.h>
int main(int argc,char* argv[])
{
int source,dest,n;
char buf;
int filesize;
int i;
if(argc!=3){
fprintf(stderr,"usage %s <source><dest>",argv[0]);
exit(-1);
}
if((source=open(argv[1],O_RDONLY))<0)
{fprintf(stderr,"can'topensource\n");
exit(-1);
}
if((dest=open(argv[2],O_WRONLY|O_CREAT|O_TRUNC))<0)
{fprintf(stderr,"can'tcreatedest\n");
exit(-1);
}
filesize=lseek(source,(off_t)0,SEEK_END);
printf("Sourcefilesizeis%d\n",filesize);
for(i=filesize-1;i>=0;i--)
{
lseek(source,(off_t)i,SEEK_SET);
if((n=read(source,&buf,1))!=1){
fprintf(stderr,"can'tread1byte");
exit(-1);
}
if((n=write(dest,&buf,1))!=1){
fprintf(stderr,"can'twrite1byte");
exit(-1);
}
}
write(STDOUT_FILENO,"DONE\n",5);
close(source);
close(dest);
return 0;
}



2.
#include<stdio.h>
#include<unistd.h>
#include<fcntl.h>
#include<fcntl.h>
#include<string.h>
#include<sys/stat.h>
#include<unistd.h>
#include<sys/types.h>
int main()
{
int file=0,n;
char buffer[25];
if((file=open("2testfile.txt",O_RDONLY))<-1)
printf("fileopenerror\n");
if(read(file,buffer,20)!=20)
printf("filereadoperationfailed\n");
else
write(STDOUT_FILENO,buffer,20);
printf("\n");
if(lseek(file,10,SEEK_SET)<0)
printf("lseek operation to beginning of file failed\n");

if(read(file,buffer,20)!=20)

printf("file read operation failed\n");
else
write(STDOUT_FILENO,buffer,20);
printf("\n");
if(lseek(file,10,SEEK_CUR)<0)
printf("lseek operation to beginning of file failed\n");

if(read(file,buffer,20)!=20)

printf("file read operation failed \n");
else
write(STDOUT_FILENO,buffer,20);
printf("\n");
if((n=lseek(file,0,SEEK_END))<0)
printf("lseek operation to end of file failed\n");
printf("sizeoffileis%dbytes\n",n);
close(file);
return 0;
}



3.
#include<unistd.h>
#include<stdio.h>
#include<sys/stat.h>
#include<sys/types.h>
int main(int argc,char**argv)
{
if(argc!=2)
return 1;
struct stat fileStat;
if(stat(argv[1],&fileStat)<0)
return 1;
printf("Informationfor%s\n",argv[1]);
printf("---------------------------\n");
printf("FileSize:\t\t%dbytes\n",fileStat.st_size);
printf("NumberofLinks:\t%d\n",fileStat.st_nlink);
printf("Fileinode:\t\t%d\n",fileStat.st_ino);
printf("FilePermissions:\t");
printf((S_ISDIR(fileStat.st_mode))?"d":"-");
printf((fileStat.st_mode&S_IRUSR)?"r":"-");
printf((fileStat.st_mode&S_IWUSR)?"w":"-");
printf((fileStat.st_mode&S_IXUSR)?"x":"-");
printf((fileStat.st_mode&S_IRGRP)?"r":"-");
printf((fileStat.st_mode&S_IWGRP)?"w":"-");
printf((fileStat.st_mode&S_IXGRP)?"x":"-");
printf((fileStat.st_mode&S_IROTH)?"r":"-");
printf((fileStat.st_mode&S_IWOTH)?"w":"-");
printf((fileStat.st_mode&S_IXOTH)?"x":"-");
printf("\n\n");
printf("Thefile%sasymboliclink\n",(S_ISLNK(fileStat.st_mode))?"is":"is not");
return 0;
}


4.
#include<stdio.h>

#include<unistd.h>

#include<fcntl.h>

#include<dirent.h>

#include<time.h>
int main(int argc,char*argv[])
{
struct dirent *dir;
struct stat mystat;
DIR*dp;
dp=opendir(".");
if(dp)
{
while(dir=readdir(dp))
{
stat(dir->d_name,&mystat);//inodemodeuidguidaccess_time
printf("%ld%o%d%d%s%s\n",mystat.st_ino,mystat.st_mode,mystat.st_uid,mystat.st_gid,ctime(&mystat.st_atime),dir->d_name);
}
}
}

5.
#include<stdio.h>

#include<fcntl.h>

#include<unistd.h>

#include<dirent.h>

int main()

{
DIR*dp;

struct dirent *dir;

int fd,n;

dp=opendir(".");//opencurrentdirectory

if(dp)
{
while((dir=readdir(dp))!=NULL)
{

fd=open(dir->d_name,O_RDWR,0777);
n=lseek(fd,0,SEEK_END);

if(!n)
{

unlink(dir->d_name);

}

}

}

}


6.
#include<stdio.h>
#include<fcntl.h>
#include<stdlib.h>
#include<unistd.h>
#include<sys/types.h>
#include<sys/stat.h>
int main(int argc,char*argv[])
{
if(argc==3)
{
printf("Hardlinking%sand%s",argv[1],argv[2]);
if(link(argv[1],argv[2])==0)
printf("\nHardlinkcreated");
else
printf("\nLinknotcreated");
}
else if(argc==4)
{
printf("Softlinking%sand%s",argv[1],argv[2]);
if(symlink(argv[1],argv[2])==0)
printf("\nSoftlinkcreated");
else
printf("\nLinknotcreated");
}
}


7.
#include<stdio.h>
#include<sys/stat.h>
#include<sys/types.h>
#include<unistd.h>
#include<utime.h>
#include<time.h>
#include<fcntl.h>
int main(int argc,char*argv[])//copyingctimeandmtimeofargv[2]toargv[1]
{
int fd;
struct stat statbuf_1;
struct stat statbuf_2;
struct utimbuf times;
if(stat(argv[1],&statbuf_1)<0)
printf("Error!\n");
if(stat(argv[2],&statbuf_2)<0)
printf("Error!\n");
printf("BeforeCopying...\n");
printf("Access Time %s\nModificationTime%s\n",ctime(&statbuf_1.st_atime),ctime(&statbuf_1.st_mtime));
times.modtime=statbuf_2.st_mtime;
times.actime=statbuf_2.st_atime;
if(utime(argv[1],&times)<0)
printf("Errorcopyingtime\n");
if(stat(argv[1],&statbuf_1)<0)
printf("Error!\n");
printf("AfterCopying...\n");
printf("Access Time %s\nModificationTime%s\n",ctime(&statbuf_1.st_atime),ctime(&statbuf_1.st_mtime));
}


8.
#include<setjmp.h>
#include<stdio.h>
#include<stdlib.h>
static void f1(int,int,int,int);
static void f2(void);
static jmp_buf jmpbuffer;
static int globval;
int main(void)
{
int autoval;
register int regival;
volatile int volaval;
static int statval;
globval=1;autoval=2;regival=3;volaval=4;statval=5;
if(setjmp(jmpbuffer)!=0)
{
printf("afterlongjmp:\n");
printf("globval=%d,autoval=%d,regival=%d,volaval=%d,statval=%d\n",globval,autoval,regival,volaval,statval);
exit(0);
}
/*
*Changevariablesaftersetjmp,butbeforelongjmp.
*/
globval=95;autoval=96;regival=97;volaval=98;
statval=99;
f1(autoval,regival,volaval,statval);/*neverreturns*/
exit(0);

}
static void f1(int i,int j,int k,int l)
{
printf("inf1():\n");
printf("globval=%d,autoval=%d,regival=%d,volaval=%d,statval=%d\n",globval,i,j,k,l);
globval=10000;
j=10000;
f2();
}
static void f2(void)
{
longjmp(jmpbuffer,1);
}

9.
#include<stdio.h>
#include<stdlib.h>
#include<fcntl.h>
int main(int argc,char*argv[])
{
int n;
char line[100];
int fd1,fd2;
fd1=open(argv[1],O_RDONLY);
if(fd1<0)
{
printf("cannotopenthefile\n");
exit(1);
}
fd2=open(argv[2],O_WRONLY|O_CREAT|O_TRUNC,0666);
if(fd1<0)
{
printf("cannotopenthefile\n");
exit(1);
}
n=read(fd1,line,sizeof(line));
while(n!=0)
{
write(fd2,line,n);
n=read(fd1,line,sizeof(line));
}
printf("done!!!\n");
return 0;
}


10.
#include<stdio.h>
#include<stdlib.h>
#include<sys/wait.h>
int main(void)
{
pid_t pid;
if((pid=fork())<0){
printf("forkerror");
}
else if(pid==0){/*firstchild*/
if((pid=fork())<0)
printf("forkerror");
else if(pid>0)
exit(0);
sleep(2);
printf("secondchild,parentpid=%ld\n",(long)getppid());
exit(0);
}
if(waitpid(pid,NULL,0)!=pid)
printf("waitpiderror");
exit(0);
}



11.
#include<stdio.h>
#include<unistd.h>
static void charatatime(char*);
int main(void)
{
pid_t pid;
if((pid=fork())<0)
{
printf("forkerror");
}
else if(pid==0)
{
charatatime("outputfromchildaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa\n");
}
else
{
charatatime("outputfromparentbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb\n");
}
exit(0);
}
static void charatatime(char*str)
{
char*ptr;
int c;
setbuf(stdout,NULL);/*setunbuffered*/
for(ptr=str;(c=*ptr++)!=0;)
putc(c,stdout);
}


12.
#include<stdio.h>
#include<stdlib.h>
#include<sys/stat.h>
#include<sys/types.h>
#include<unistd.h>

void deamonize()
{
pid_t pid=fork();

if(pid<0)
fprintf(stderr,"ErrorForking\n");
else if (pid)
{
printf("PIDofChild%d\n",pid);
exit(0);//killtheparentprocess,childisorphandedandrunsinthebg
}

umask(0);
if(chdir("/")<0)
printf("Errorchangingdirectory\n");
if(setsid()<0)//makethechildprocessthesessionleader
printf("Errorcreatingsession\n");

printf("DemonCreated!\n");

}
int main()
{
deamonize();
system("ps -axj");
return 0;
}



13.
#include<stdio.h>
#include<unistd.h>
#include<signal.h>
struct sigaction sig;
void handler(int val)
{
printf("InterruptReceived!\n");
sig.sa_handler=SIG_DFL;
sigaction(SIGINT,&sig,0);
}
int main()
{
sig.sa_flags=0;
sigemptyset(&sig.sa_mask);
sigaddset(&sig.sa_mask,SIGINT);//listenonlyforSIGNIT
sig.sa_handler=handler;
sigaction(SIGINT,&sig,0);
while(1)
{
printf("ProgressisHappiness!\n");
sleep(1);
}
}


14.
#include<stdio.h>
#include<unistd.h>
#include<signal.h>
struct sigaction sig;
void handler(int val)
{
printf("InterruptReceived!\n");
sig.sa_handler=SIG_DFL;
sigaction(SIGINT,&sig,0);
}
int main()
{
sig.sa_flags=0;
sigemptyset(&sig.sa_mask);
sigaddset(&sig.sa_mask,SIGINT);//listenonlyforSIGNIT
sig.sa_handler=handler;
sigaction(SIGINT,&sig,0);
while(1)
{
printf("ProgressisHappiness!\n");
sleep(1);
}
}
