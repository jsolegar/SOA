
#include <asm.h>

//int write(int fd, char *buffer, int size)
ENTRY(write)
		pushl %ebp;
		movl %esp, %ebp;
  	pushl %ebx
		movl 8(%ebp), %ebx  		    //1.Parameters passing fd -> %ebx, buffer-> %ecx, size -> %edx
		movl 12(%ebp), %ecx
		movl 16(%ebp), %edx
		movl $0x04, %eax;				    //2.syscall_table #4 -> write
		pushl %ecx;   						  //3.Store values %ecx&%edx
		pushl %edx;
		pushl $SYSENTER_WRITE	      //4.Store the return address to user mode in the user stack.
		pushl %ebp									//5.Create fake dynamic link
		movl %esp, %ebp
		sysenter;										//6. sysenter
SYSENTER_WRITE:
    popl %ebp;
    popl %edx;
    popl %edx;
    popl %ecx;
    popl %ebx;

if:
		cmpl $0, %eax;        	//8.Process the result
    jge else;
    neg %eax;
    movl %eax, errno;
    movl $-1, %eax;
else:
     popl %ebp
	   ret;								    //9.Return



// int gettime();
ENTRY(gettime)
		pushl %ebp;
		movl %esp, %ebp;
		movl $10, %eax; 					//syscall_table #10 -> gettime
		pushl %ecx;
		pushl %edx;
		pushl $SYSENTER_GETTIME
		push %ebp
		movl %esp, %ebp
		sysenter;
SYSENTER_GETTIME:
    popl %ebp;
    popl %edx;
    popl %edx;
    popl %ecx;
    popl %ebp;
    ret;
