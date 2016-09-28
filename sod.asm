  .text
  .globl main
main:
   # let's create space for n and sum -- 8 bytes
   
   subu  $fp, $sp, 4          # set frame pointer as the base reg of local vars
   subu  $sp, $sp, 8          # "int n, sum;"
                              # let &n = 0($fp) and &sum = -4($fp)

   # printf ("feed the input number:");
   la $a0, promptInp     
   li $v0, 4
   syscall

   # scanf ("%d", &n);

   li $v0, 5
   syscall                   # integer read is returned through $v0 
   sw $v0, 0($fp)            # M[$fp + 0] <= $v0 i.e., n <= $v0

   # printf ("The sum of digits of %d is:", n);

   la $a0, promptOutp
   li $v0, 4
   syscall                   # only the prompt has been printed

   # now to ptint n

   lw $a0, 0($fp)            # $a0 to have the integer to print
   li $v0, 1
   syscall
  
# To make things more efficient we shall have n in $s0 and sum in $s1
# without storing the intermediate values back in mamory

   lw $s1, -4($fp)
   sub $s1, $s1, $s1        # sum = 0;

   lw $s0, 0($fp)           # $s0 <= n   
   li $t0, 10               # division by 10 needed
repeat: 
   divu $s0, $t0            # lo <= n/10, hi <= n % 10
   mfhi $t1
   add  $s1, $s1, $t1       # sum = sum + n % 10
   mflo $s0                 # n = n /10
   bnez $s0, repeat         # repeat until n == 0

   sw $s1, -4($fp)
   
#  printf ("is %d\n", sum);
   la $a0, promptOutp1
   li $v0, 4
   syscall                   

   lw $a0, -4($fp)
   li $v0, 1
   syscall

   # now leave
   add $sp, $fp, 4   # restore the stack pointer value at entry -- dealloc local
                     # variable space 
   jr $ra            # return using the link reg.             

.data
#  all print prompts here
promptInp:   .asciiz "feed the input number:"
promptOutp:  .asciiz "The sum of digits of "
promptOutp1: .asciiz " is : %d \n"

 





#  #include <stdio.h>
#  int main()
#   { int n, sum;
#     printf ("feed the input number:");
#     scanf ("%d", &n);
#     printf ("The sum of digits of %d is:", n);
#     sum = 0;
#     while (n > 0)
#      { sum = sum + n % 10;
#        n = n / 10;
#      }
#     printf ("%d\n", sum);
#   }

