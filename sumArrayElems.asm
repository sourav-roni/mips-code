#
# Main function (i) allocates local variables -- "size", the array "a" of "size 
#                  no. of elements; 
#             (ii) reads the "size" of the array "a", and then the elements of 
#                  the array "a",
#            (iii) calls function "sumThem" passing "a"-address and "size" on 
#                  stack; the function returns the sum through the stack.
# ***********/

      .rdata
rdSize:     .asciiz "feed the no. of elements in the array\n"
rdNextEl:   .asciiz "feed the array element\n"
prArray:    .asciiz "\nthe array elements fed are:\n"
prNewline:  .asciiz "\n"
prResult:   .asciiz "\n Their sum is: %d \n"


      .text
      .globl main
main: 
      # allocate space for "size" -- space for the array "a" has to be allocated 
      # after reading "size"
      # ********/
      move $fp, $sp      #// $fp remember the sp on entry -- for leaving properly
      subu $sp, $sp, 4  #// space for "size" 

      #/* print "rdPrompt" -- $a0 to have the prompt string address, 
      #   syscall code (for print string (4) in $v0 ******/
      la $a0, rdSize
      li $v0, 4
      syscall

      #// now read "size" -- syscall code (5) in $v0 -- 
      #// read int retd. through $a0

      li $v0, 5
      syscall
      sw $v0, -4($fp)  # save "size" in memory
 
      #// now allocate 4 times $to bytes for the array
      li $t0, 4
      multu $v0, $t0       #// result words in registers "lo" and "hi"
      mflo  $t0            #// assumed that the array size is never too big

      subu $sp, $sp, $t0   #// space for array created

      #/* mapping: array starts at 0($sp), size at -4($fp) -- since there's 
      #   no index addressing modes, we have to work with these addresses in
      #   some registers ***/


      #// let's now read the array elements 
      
      move $t0, $v0    #// $t0 contains the size
      move $t1, $t0    #// $t1 is to be the looping index
      move $t2, $sp    #// starting address of the array in $t2
  
rdNext:
      la $a0, rdNextEl # first print the prompt each time
      li $v0, 4
      syscall

      #    Now read the elements

      li $v0, 5        #  // syscall code 5 (for read int) in $v0
      syscall          #  // read int in $v0
      sw $v0, 0($t2)   #  // read int in a[t2] now
      addu $t2, $t2, 4   #  // advance to next array location
      subu $t1, $t1, 1   #// dcr $t1
      bnez $t1, rdNext   # // read the next one

      ##/******* Let's examine whether data read properly -- ***/

      #// first the prompt
      la $a0, prArray
      li $v0, 4          #// print str code in $v0
      syscall
      
      #// now print the elements
      move $t1, $t0       #// $t1 contains the looping index 
      move $t2, $sp       #// $t2 contains the starting address

prNext:
      li  $v0, 1         #// print int code in $v0
      lw  $a0, 0($t2)    #// a[t2] in $a0 to print
      syscall
      addu $t2, $t2, 4   #// advance to next array location
      subu $t1, $t1, 1   #// dcr $t1
      bnez $t1, prNext   # // read the next one if any more to read

      #// now to call "sumThem" -- value retd. through $v0

      move  $a0, $sp       #// array starting address in $ao
      lw  $a1, -4($fp)   #//  "size" in $a1
      sw   $ra, -4($sp)   #// save the return address 
      jal sumThem
      move $v1, $v0      # save the result in $v1
      #// Print result
      #// first the prompt

      la $a0, prResult
      li $v0, 4          #// print str code in $v0
      syscall

      #// now print the sum (in $v0)

      move $a0, $v1      #// to print $v0 put it in $a0
      li  $v0, 1        #// print int code in $v0
      syscall

      #// now leave by restoring the return address in $ra and 
      #// entry value of $sp from $fp

      lw   $ra, -4($sp)
      move  $sp, $fp
      jr   $ra

#/************  start of subroutine "sumThem"
#  starting address of the array in $a0, "size" in $a1
#  let's not disturb the stack
#*******/

sumThem: 
       subu $v0, $v0, $v0 #// $v0 <= 0
       move $t0, $a1       #// $t0 contains the looping index
       move $t1, $a0       #// starting  of the array

repeat:
       lw    $t2, 0($t1)      # $t2 = a[t1]
       addu, $v0, $v0, $t2    #// $v0 += a[t1]
       addu  $t1, $t1, 4      #// $t1 to point to the next array element
       subu  $t0, $t0, 1      #// looping index decremented
       bnez  $t0, repeat      #// repeat if more to add

       jr $ra                 #// just return
      


