#============================================================================
#  ppc64el routines for bandwidth, a benchmark to estimate memory transfer bandwidth.
#  Copyright (c) 2015 Raptor Engineering
#
#  This program is free software; you can redistribute it and/or modify
#  it under the terms of the GNU General Public License as published by
#  the Free Software Foundation; either ver4on 2 of the License, or
#  (at your option) any later version.
#
#  This program is distributed in the hope that it will be useful,
#  but WITHOUT ANY WARRANTY; without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#  GNU General Public License for more details.
#
#  You should have received a copy of the GNU General Public License
#  along with this program; if not, write to the Free Software
#  Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
#
#  The author of this file may be reached at tpearson@raptorengineeringinc.com.
#=============================================================================

.global	ReaderLODSQ
.global	_ReaderLODSQ

.global	ReaderLODSD
.global	_ReaderLODSD

.global	ReaderLODSW
.global	_ReaderLODSW

.global	ReaderLODSB
.global	_ReaderLODSB

.global	RandomReader
.global	RandomWriter
.global	Reader
.global	Reader_128bytes
.global	RandomReaderVSX
.global	ReaderVSX
.global	RegisterToRegister
.global	RegisterToVector
.global	StackReader
.global	StackWriter
.global	VectorToRegister
.global	VectorToVector
.global	Writer
.global	Writer_128bytes
.global	WriterVSX
.global	RandomWriterVSX
.global	_RandomReader
.global	_RandomWriter
.global	_Reader
.global	_Reader_128bytes
.global	_RandomReaderVSX
.global	_ReaderVSX
.global	_RegisterToRegister
.global	_RegisterToVector
.global	_StackReader
.global	_StackWriter
.global	_VectorToRegister
.global	_VectorToVector
.global	_Writer
.global	_Writer_128bytes
.global _WriterVSX
.global _RandomWriterVSX

.data
.align 3			# align to 8 byte boundary
stack_test_1:
	.quad	1000
stack_test_2:
	.quad	2000
stack_test_3:
	.quad	3000
stack_test_4:
	.quad	4000
stack_test_5:
	.quad	5000
stack_test_6:
	.quad	6000
stack_test_7:
	.quad	7000

# Note:
# Unix ABI for 64-bit PPC64EL v2 says integer parameters are put into these registers in this order:
#	r3, r4, r5, r6, r7, r7

.text

#------------------------------------------------------------------------------
# Name:		ReaderLODSQ
# Purpose:	Reads 64-bit values sequentially from an area of memory
#		using LD instruction.
# Params:	r3 = ptr to memory area
# 		r4 = length in bytes (inner loop count)
# 		r5 = loops (outer loop count)
#------------------------------------------------------------------------------
.align 2			# align to 4 byte boundary
ReaderLODSQ:
_ReaderLODSQ:
	stdu	r1, -32(r1)	# update and store stack pointer
	mflr	r0		# set up the stack frame
	std	r0, 16(r1)	# save the link register

	mr	r7, r4		# calculate inner loop count
	srdi	r7, r7, 3	# length in quadwords rounded down

	mr	r10, r5		# load outer loop counter
.Louter_loop_0:
	addi	r10, r10, -1
	mtctr	r7		# copy inner loop count to count register
	mr	r9, r3		# (re)load inner loop pointer address
.Linner_loop_0:
	ld	r8, 0(r9)
	addi	r9, r9, 8	# increment pointer by 1 quadword
	bdnz	.Linner_loop_0

	cmpwi	r10, 0
	bne	.Louter_loop_0

	ld	r0, 16(r1)	# restore saved link register
	mtlr	r0
	addi	r1, r1, 32	# destroy the stack frame
	blr

#------------------------------------------------------------------------------
# Name:		ReaderLODSD
# Purpose:	Reads 32-bit values sequentially from an area of memory
#		using LWZ instruction.
# Params:	r3 = ptr to memory area
# 		r4 = length in bytes (inner loop count)
# 		r5 = loops (outer loop count)
#------------------------------------------------------------------------------
.align 2			# align to 4 byte boundary
ReaderLODSD:
_ReaderLODSD:
	stdu	r1, -32(r1)	# update and store stack pointer
	mflr	r0		# set up the stack frame
	std	r0, 16(r1)	# save the link register

	mr	r7, r4		# calculate inner loop count
	srdi	r7, r7, 2	# length in doublewords rounded down

	mr	r10, r5		# load outer loop counter
.Louter_loop_1:
	addi	r10, r10, -1
	mtctr	r7		# copy inner loop count to count register
	mr	r9, r3		# (re)load inner loop pointer address
.Linner_loop_1:
	lwz	r8, 0(r9)
	addi	r9, r9, 4	# increment pointer by 1 double word
	bdnz	.Linner_loop_1

	cmpwi	r10, 0
	bne	.Louter_loop_1

	ld	r0, 16(r1)	# restore saved link register
	mtlr	r0
	addi	r1, r1, 32	# destroy the stack frame
	blr

#------------------------------------------------------------------------------
# Name:		ReaderLODSW
# Purpose:	Reads 16-bit values sequentially from an area of memory
#		using LHZ instruction.
# Params:	r3 = ptr to memory area
# 		r4 = length in bytes (inner loop count)
# 		r5 = loops (outer loop count)
#------------------------------------------------------------------------------
.align 2			# align to 4 byte boundary
ReaderLODSW:
_ReaderLODSW:
	stdu	r1, -32(r1)	# update and store stack pointer
	mflr	r0		# set up the stack frame
	std	r0, 16(r1)	# save the link register

	mr	r7, r4		# calculate inner loop count
	srdi	r7, r7, 1	# length in words rounded down

	mr	r10, r5		# load outer loop counter
.Louter_loop_2:
	addi	r10, r10, -1
	mtctr	r7		# copy inner loop count to count register
	mr	r9, r3		# (re)load inner loop pointer address
.Linner_loop_2:
	lhz	r8, 0(r9)
	addi	r9, r9, 2	# increment pointer by 1 word
	bdnz	.Linner_loop_2

	cmpwi	r10, 0
	bne	.Louter_loop_2

	ld	r0, 16(r1)	# restore saved link register
	mtlr	r0
	addi	r1, r1, 32	# destroy the stack frame
	blr

#------------------------------------------------------------------------------
# Name:		ReaderLODSB
# Purpose:	Reads 16-bit values sequentially from an area of memory
#		using LDBZ instruction.
# Params:	r3 = ptr to memory area
# 		r4 = length in bytes (inner loop count)
# 		r5 = loops (outer loop count)
#------------------------------------------------------------------------------
.align 2			# align to 4 byte boundary
ReaderLODSB:
_ReaderLODSB:
	stdu	r1, -32(r1)	# update and store stack pointer
	mflr	r0		# set up the stack frame
	std	r0, 16(r1)	# save the link register

	mr	r10, r5		# load outer loop counter
.Louter_loop_3:
	addi	r10, r10, -1
	mtctr	r4		# copy inner loop count to count register
	mr	r9, r3		# (re)load inner loop pointer address
.Linner_loop_3:
	lbz	r8, 0(r9)
	addi	r9, r9, 1	# increment pointer by 1 byte
	bdnz	.Linner_loop_3

	cmpwi	r10, 0
	bne	.Louter_loop_3

	ld	r0, 16(r1)	# restore saved link register
	mtlr	r0
	addi	r1, r1, 32	# destroy the stack frame
	blr

 
#------------------------------------------------------------------------------
# Name:		Reader
# Purpose:	Reads 64-bit values sequentially from an area of memory.
# Params:	r3 = ptr to memory area
# 		r4 = length in bytes
# 		r5 = loops
#------------------------------------------------------------------------------
.align 3			# align to 8 byte boundary
Reader:
_Reader:
	stdu	r1, -32(r1)	# update and store stack pointer
	mflr	r0		# set up the stack frame
	std	r0, 16(r1)	# save the link register

	mr	r7, r4		# calculate inner loop count
	srdi	r7, r7, 8	# length in bytes / 256

	mr	r10, r5		# load outer loop counter
.Louter_loop_4:
	addi	r10, r10, -1
	mtctr	r7		# copy inner loop count to count register
	mr	r9, r3		# (re)load inner loop pointer address
.Linner_loop_4:
	ld	r8, 0(r9)
	ld	r8, 8(r9)
	ld	r8, 16(r9)
	ld	r8, 24(r9)
	ld	r8, 32(r9)
	ld	r8, 40(r9)
	ld	r8, 48(r9)
	ld	r8, 56(r9)
	ld	r8, 64(r9)
	ld	r8, 72(r9)
	ld	r8, 80(r9)
	ld	r8, 88(r9)
	ld	r8, 96(r9)
	ld	r8, 104(r9)
	ld	r8, 112(r9)
	ld	r8, 120(r9)
	ld	r8, 128(r9)
	ld	r8, 136(r9)
	ld	r8, 144(r9)
	ld	r8, 152(r9)
	ld	r8, 160(r9)
	ld	r8, 168(r9)
	ld	r8, 176(r9)
	ld	r8, 184(r9)
	ld	r8, 192(r9)
	ld	r8, 200(r9)
	ld	r8, 208(r9)
	ld	r8, 216(r9)
	ld	r8, 224(r9)
	ld	r8, 232(r9)
	ld	r8, 240(r9)
	ld	r8, 248(r9)
	addi	r9, r9, 256	# increment pointer by 256 bytes
	bdnz	.Linner_loop_4

	cmpwi	r10, 0
	bne	.Louter_loop_4

	ld	r0, 16(r1)	# restore saved link register
	mtlr	r0
	addi	r1, r1, 32	# destroy the stack frame
	blr

#------------------------------------------------------------------------------
# Name:		Reader_128bytes
# Purpose:	Reads 64-bit values sequentially from an area of memory.
# Params:	r3 = ptr to memory area
# 		r4 = length in bytes
# 		r5 = loops
#------------------------------------------------------------------------------
.align 3			# align to 8 byte boundary
Reader_128bytes:
_Reader_128bytes:
	stdu	r1, -32(r1)	# update and store stack pointer
	mflr	r0		# set up the stack frame
	std	r0, 16(r1)	# save the link register

	mr	r7, r4		# calculate inner loop count
	srdi	r7, r7, 7	# length in bytes / 128

	mr	r10, r5		# load outer loop counter
.Louter_loop_5:
	addi	r10, r10, -1
	mtctr	r7		# copy inner loop count to count register
	mr	r9, r3		# (re)load inner loop pointer address
.Linner_loop_5:
	ld	r8, 0(r9)
	ld	r8, 8(r9)
	ld	r8, 16(r9)
	ld	r8, 24(r9)
	ld	r8, 32(r9)
	ld	r8, 40(r9)
	ld	r8, 48(r9)
	ld	r8, 56(r9)
	ld	r8, 64(r9)
	ld	r8, 72(r9)
	ld	r8, 80(r9)
	ld	r8, 88(r9)
	ld	r8, 96(r9)
	ld	r8, 104(r9)
	ld	r8, 112(r9)
	ld	r8, 120(r9)
	addi	r9, r9, 128	# increment pointer by 128 bytes
	bdnz	.Linner_loop_5

	cmpwi	r10, 0
	bne	.Louter_loop_5

	ld	r0, 16(r1)	# restore saved link register
	mtlr	r0
	addi	r1, r1, 32	# destroy the stack frame
	blr

#------------------------------------------------------------------------------
# Name:		RandomReaderVSX
# Purpose:	Reads 128-bit values randomly from an area of memory.
# Params:	r3 = ptr to array of chunk pointers
# 		r4 = # of chunks
# 		r5 = loops
#------------------------------------------------------------------------------
.align 3			# align to 8 byte boundary
RandomReaderVSX:
_RandomReaderVSX:
	stdu	r1, -152(r1)	# update and store stack pointer
	mflr	r0		# set up the stack frame
	std	r0, 16(r1)	# save the link register
	std	r14, 24(r1)	# save r14
	std	r15, 32(r1)	# save r15
	std	r16, 40(r1)	# save r16
	std	r17, 48(r1)	# save r17
	std	r18, 56(r1)	# save r18
	std	r19, 64(r1)	# save r19
	std	r20, 72(r1)	# save r20
	std	r21, 80(r1)	# save r21
	std	r22, 88(r1)	# save r22
	std	r23, 96(r1)	# save r23
	std	r24, 104(r1)	# save r24
	std	r25, 112(r1)	# save r25
	std	r26, 120(r1)	# save r26
	std	r27, 128(r1)	# save r27
	std	r28, 136(r1)	# save r28

	li	r12, 240	# initialize read offset registers
	li	r14, 128
	li	r15, 64
	li	r16, 208
	li	r17, 112
	li	r18, 176
	li	r19, 144
	li	r20, 0

	li	r21, 96
	li	r22, 16
	li	r23, 192
	li	r24, 160
	li	r25, 32
	li	r26, 48
	li	r27, 224
	li	r28, 80

	mr	r10, r5		# load outer loop counter
.Louter_vsx_loop_0:
	addi	r10, r10, -1
	mr	r11, r4		# copy inner loop count to inner loop count register
.Linner_vsx_loop_0:
	addi	r11, r11, -1
	mr	r7, r11		# (re)calculate inner loop data offset
	sldi	r7, r7, 3
	ldx	r9, r3, r7	# (re)compute inner loop start pointer

	lxvd2x	v0, r12, r9
	lxvd2x	v0, r14, r9
	lxvd2x	v0, r15, r9
	lxvd2x	v0, r16, r9
	lxvd2x	v0, r17, r9
	lxvd2x	v0, r18, r9
	lxvd2x	v0, r19, r9
	lxvd2x	v0, r20, r9

	lxvd2x	v0, r21, r9
	lxvd2x	v0, r22, r9
	lxvd2x	v0, r23, r9
	lxvd2x	v0, r24, r9
	lxvd2x	v0, r25, r9
	lxvd2x	v0, r26, r9
	lxvd2x	v0, r27, r9
	lxvd2x	v0, r28, r9

	cmpwi	r11, 0
	bne	.Linner_vsx_loop_0

	cmpwi	r10, 0
	bne	.Louter_vsx_loop_0

	ld	r28, 136(r1)	# restore r28
	ld	r27, 128(r1)	# restore r27
	ld	r26, 120(r1)	# restore r26
	ld	r25, 112(r1)	# restore r25
	ld	r24, 104(r1)	# restore r24
	ld	r23, 96(r1)	# restore r23
	ld	r22, 88(r1)	# restore r22
	ld	r21, 80(r1)	# restore r21
	ld	r20, 72(r1)	# restore r20
	ld	r19, 64(r1)	# restore r19
	ld	r18, 56(r1)	# restore r18
	ld	r17, 48(r1)	# restore r17
	ld	r16, 40(r1)	# restore r16
	ld	r15, 32(r1)	# restore r15
	ld	r14, 24(r1)	# restore r14
	ld	r0, 16(r1)	# restore saved link register
	mtlr	r0
	addi	r1, r1, 152	# destroy the stack frame
	blr

#------------------------------------------------------------------------------
# Name:		ReaderVSX
# Purpose:	Reads 128-bit values sequentially from an area of memory.
# Params:	r3 = ptr to memory area
# 		r4 = length in bytes
# 		r5 = loops
#------------------------------------------------------------------------------
.align 3			# align to 8 byte boundary
ReaderVSX:
_ReaderVSX:
	stdu	r1, -144(r1)	# update and store stack pointer
	mflr	r0		# set up the stack frame
	std	r0, 16(r1)	# save the link register
	std	r14, 24(r1)	# save r14
	std	r15, 32(r1)	# save r15
	std	r16, 40(r1)	# save r16
	std	r17, 48(r1)	# save r17
	std	r18, 56(r1)	# save r18
	std	r19, 64(r1)	# save r19
	std	r20, 72(r1)	# save r20
	std	r21, 80(r1)	# save r21
	std	r22, 88(r1)	# save r22
	std	r23, 96(r1)	# save r23
	std	r24, 104(r1)	# save r24
	std	r25, 112(r1)	# save r25
	std	r26, 120(r1)	# save r26
	std	r27, 128(r1)	# save r27

	mr	r7, r4		# calculate inner loop count
	srdi	r7, r7, 8	# length in bytes / 256

	li	r11, 0		# initialize read offset registers
	li	r12, 16
	li	r14, 32
	li	r15, 48
	li	r16, 64
	li	r17, 80
	li	r18, 96
	li	r19, 112

	li	r20, 128
	li	r21, 144
	li	r22, 160
	li	r23, 176
	li	r24, 192
	li	r25, 208
	li	r26, 224
	li	r27, 240

	mr	r10, r5		# load outer loop counter
.Louter_vsx_loop_1:
	addi	r10, r10, -1
	mtctr	r7		# copy inner loop count to count register
	mr	r9, r3		# (re)load inner loop pointer address
.Linner_vsx_loop_1:
	lxvd2x	v0, r11, r9
	lxvd2x	v0, r12, r9
	lxvd2x	v0, r14, r9
	lxvd2x	v0, r15, r9
	lxvd2x	v0, r16, r9
	lxvd2x	v0, r17, r9
	lxvd2x	v0, r18, r9
	lxvd2x	v0, r19, r9

	lxvd2x	v0, r20, r9
	lxvd2x	v0, r21, r9
	lxvd2x	v0, r22, r9
	lxvd2x	v0, r23, r9
	lxvd2x	v0, r24, r9
	lxvd2x	v0, r25, r9
	lxvd2x	v0, r26, r9
	lxvd2x	v0, r27, r9

	addi	r9, r9, 256	# increment pointer by 256 bytes
	bdnz	.Linner_vsx_loop_1

	cmpwi	r10, 0
	bne	.Louter_vsx_loop_1

	ld	r27, 128(r1)	# restore r27
	ld	r26, 120(r1)	# restore r26
	ld	r25, 112(r1)	# restore r25
	ld	r24, 104(r1)	# restore r24
	ld	r23, 96(r1)	# restore r23
	ld	r22, 88(r1)	# restore r22
	ld	r21, 80(r1)	# restore r21
	ld	r20, 72(r1)	# restore r20
	ld	r19, 64(r1)	# restore r19
	ld	r18, 56(r1)	# restore r18
	ld	r17, 48(r1)	# restore r17
	ld	r16, 40(r1)	# restore r16
	ld	r15, 32(r1)	# restore r15
	ld	r14, 24(r1)	# restore r14
	ld	r0, 16(r1)	# restore saved link register
	mtlr	r0
	addi	r1, r1, 144	# destroy the stack frame
	blr

#------------------------------------------------------------------------------
# Name:		RandomReader
# Purpose:	Reads 64-bit values randomly from an area of memory.
# Params:	r3 = ptr to array of chunk pointers
# 		r4 = # of chunks
# 		r5 = loops
#------------------------------------------------------------------------------
.align 3			# align to 8 byte boundary
RandomReader:
_RandomReader:
	stdu	r1, -32(r1)	# update and store stack pointer
	mflr	r0		# set up the stack frame
	std	r0, 16(r1)	# save the link register

	mr	r10, r5		# load outer loop counter
.Louter_loop_6:
	addi	r10, r10, -1
	mr	r11, r4		# copy inner loop count to inner loop count register
.Linner_loop_6:
	addi	r11, r11, -1
	mr	r7, r11		# (re)calculate inner loop data offset
	sldi	r7, r7, 3
	ldx	r9, r3, r7	# (re)compute inner loop start pointer
	ld	r8, 96(r9)
	ld	r8, 0(r9)
	ld	r8, 120(r9)
	ld	r8, 184(r9)
	ld	r8, 160(r9)
	ld	r8, 176(r9)
	ld	r8, 112(r9)
	ld	r8, 80(r9)
	ld	r8, 32(r9)
	ld	r8, 128(r9)
	ld	r8, 88(r9)
	ld	r8, 40(r9)
	ld	r8, 48(r9)
	ld	r8, 72(r9)
	ld	r8, 200(r9)
	ld	r8, 24(r9)
	ld	r8, 152(r9)
	ld	r8, 16(r9)
	ld	r8, 248(r9)
	ld	r8, 56(r9)
	ld	r8, 240(r9)
	ld	r8, 208(r9)
	ld	r8, 104(r9)
	ld	r8, 216(r9)
	ld	r8, 136(r9)
	ld	r8, 232(r9)
	ld	r8, 64(r9)
	ld	r8, 224(r9)
	ld	r8, 144(r9)
	ld	r8, 192(r9)
	ld	r8, 8(r9)
	ld	r8, 168(r9)
	cmpwi	r11, 0
	bne	.Linner_loop_6

	cmpwi	r10, 0
	bne	.Louter_loop_6

	ld	r0, 16(r1)	# restore saved link register
	mtlr	r0
	addi	r1, r1, 32	# destroy the stack frame
	blr

#------------------------------------------------------------------------------
# Name:		RandomWriter
# Purpose:	Writes 64-bit values randomly to an area of memory.
# Params:	r3 = ptr to array of chunk pointers
# 		r4 = # of chunks
# 		r5 = loops
# 		r6 = datum to write
#------------------------------------------------------------------------------
.align 3			# align to 8 byte boundary
RandomWriter:
_RandomWriter:
	stdu	r1, -32(r1)	# update and store stack pointer
	mflr	r0		# set up the stack frame
	std	r0, 16(r1)	# save the link register

	mr	r10, r5		# load outer loop counter
.Louter_loop_7:
	addi	r10, r10, -1
	mr	r11, r4		# copy inner loop count to inner loop count register
.Linner_loop_7:
	addi	r11, r11, -1
	mr	r7, r11		# (re)calculate inner loop data offset
	sldi	r7, r7, 3
	ldx	r9, r3, r7	# (re)compute inner loop start pointer
	std	r8, 96(r9)
	std	r8, 0(r9)
	std	r8, 120(r9)
	std	r8, 184(r9)
	std	r8, 160(r9)
	std	r8, 176(r9)
	std	r8, 112(r9)
	std	r8, 80(r9)
	std	r8, 32(r9)
	std	r8, 128(r9)
	std	r8, 88(r9)
	std	r8, 40(r9)
	std	r8, 48(r9)
	std	r8, 72(r9)
	std	r8, 200(r9)
	std	r8, 24(r9)
	std	r8, 152(r9)
	std	r8, 16(r9)
	std	r8, 248(r9)
	std	r8, 56(r9)
	std	r8, 240(r9)
	std	r8, 208(r9)
	std	r8, 104(r9)
	std	r8, 216(r9)
	std	r8, 136(r9)
	std	r8, 232(r9)
	std	r8, 64(r9)
	std	r8, 224(r9)
	std	r8, 144(r9)
	std	r8, 192(r9)
	std	r8, 8(r9)
	std	r8, 168(r9)
	cmpwi	r11, 0
	bne	.Linner_loop_7

	cmpwi	r10, 0
	bne	.Louter_loop_7

	ld	r0, 16(r1)	# restore saved link register
	mtlr	r0
	addi	r1, r1, 32	# destroy the stack frame
	blr

#------------------------------------------------------------------------------
# Name:		WriterVSX
# Purpose:	Writes 128-bit value sequentially to an area of memory.
# Params:	r3 = ptr to memory area
# 		r4 = length in bytes
# 		r5 = loops
# 		r6 = quad to write
#------------------------------------------------------------------------------
.align 3			# align to 8 byte boundary
WriterVSX:
_WriterVSX:
	stdu	r1, -144(r1)	# update and store stack pointer
	mflr	r0		# set up the stack frame
	std	r0, 16(r1)	# save the link register
	std	r14, 24(r1)	# save r14
	std	r15, 32(r1)	# save r15
	std	r16, 40(r1)	# save r16
	std	r17, 48(r1)	# save r17
	std	r18, 56(r1)	# save r18
	std	r19, 64(r1)	# save r19
	std	r20, 72(r1)	# save r20
	std	r21, 80(r1)	# save r21
	std	r22, 88(r1)	# save r22
	std	r23, 96(r1)	# save r23
	std	r24, 104(r1)	# save r24
	std	r25, 112(r1)	# save r25
	std	r26, 120(r1)	# save r26
	std	r27, 128(r1)	# save r27

	mtvsrd	vs1, r6		# load value to write into vector register

	mr	r7, r4		# calculate inner loop count
	srdi	r7, r7, 8	# length in bytes / 256

	li	r11, 0		# initialize write offset registers
	li	r12, 16
	li	r14, 32
	li	r15, 48
	li	r16, 64
	li	r17, 80
	li	r18, 96
	li	r19, 112

	li	r20, 128
	li	r21, 144
	li	r22, 160
	li	r23, 176
	li	r24, 192
	li	r25, 208
	li	r26, 224
	li	r27, 240

	mr	r10, r5		# load outer loop counter
.Louter_vsx_loop_2:
	addi	r10, r10, -1
	mtctr	r7		# copy inner loop count to count register
	mr	r9, r3		# (re)load inner loop pointer address
.Linner_vsx_loop_2:
	stxvd2x	v0, r11, r9
	stxvd2x	v0, r12, r9
	stxvd2x	v0, r14, r9
	stxvd2x	v0, r15, r9
	stxvd2x	v0, r16, r9
	stxvd2x	v0, r17, r9
	stxvd2x	v0, r18, r9
	stxvd2x	v0, r19, r9

	stxvd2x	v0, r20, r9
	stxvd2x	v0, r21, r9
	stxvd2x	v0, r22, r9
	stxvd2x	v0, r23, r9
	stxvd2x	v0, r24, r9
	stxvd2x	v0, r25, r9
	stxvd2x	v0, r26, r9
	stxvd2x	v0, r27, r9

	addi	r9, r9, 256	# increment pointer by 256 bytes
	bdnz	.Linner_vsx_loop_2

	cmpwi	r10, 0
	bne	.Louter_vsx_loop_2

	ld	r27, 128(r1)	# restore r27
	ld	r26, 120(r1)	# restore r26
	ld	r25, 112(r1)	# restore r25
	ld	r24, 104(r1)	# restore r24
	ld	r23, 96(r1)	# restore r23
	ld	r22, 88(r1)	# restore r22
	ld	r21, 80(r1)	# restore r21
	ld	r20, 72(r1)	# restore r20
	ld	r19, 64(r1)	# restore r19
	ld	r18, 56(r1)	# restore r18
	ld	r17, 48(r1)	# restore r17
	ld	r16, 40(r1)	# restore r16
	ld	r15, 32(r1)	# restore r15
	ld	r14, 24(r1)	# restore r14
	ld	r0, 16(r1)	# restore saved link register
	mtlr	r0
	addi	r1, r1, 144	# destroy the stack frame
	blr

#------------------------------------------------------------------------------
# Name:		RandomWriterVSX
# Purpose:	Writes 128-bit values randomly to an area of memory.
# Params:	r3 = ptr to memory area
# 		r4 = length in bytes
# 		r5 = loops
# 		r6 = quad to write
#------------------------------------------------------------------------------
.align 3			# align to 8 byte boundary
RandomWriterVSX:
_RandomWriterVSX:
	stdu	r1, -152(r1)	# update and store stack pointer
	mflr	r0		# set up the stack frame
	std	r0, 16(r1)	# save the link register
	std	r14, 24(r1)	# save r14
	std	r15, 32(r1)	# save r15
	std	r16, 40(r1)	# save r16
	std	r17, 48(r1)	# save r17
	std	r18, 56(r1)	# save r18
	std	r19, 64(r1)	# save r19
	std	r20, 72(r1)	# save r20
	std	r21, 80(r1)	# save r21
	std	r22, 88(r1)	# save r22
	std	r23, 96(r1)	# save r23
	std	r24, 104(r1)	# save r24
	std	r25, 112(r1)	# save r25
	std	r26, 120(r1)	# save r26
	std	r27, 128(r1)	# save r27
	std	r28, 136(r1)	# save r28

	mtvsrd	vs1, r6		# load value to write into vector register

	li	r12, 240	# initialize write offset registers
	li	r14, 128
	li	r15, 64
	li	r16, 208
	li	r17, 112
	li	r18, 176
	li	r19, 144
	li	r20, 0

	li	r21, 96
	li	r22, 16
	li	r23, 192
	li	r24, 160
	li	r25, 32
	li	r26, 48
	li	r27, 224
	li	r28, 80

	mr	r10, r5		# load outer loop counter
.Louter_vsx_loop_3:
	addi	r10, r10, -1
	mr	r11, r4		# copy inner loop count to inner loop count register
.Linner_vsx_loop_3:
	addi	r11, r11, -1
	mr	r7, r11		# (re)calculate inner loop data offset
	sldi	r7, r7, 3
	ldx	r9, r3, r7	# (re)compute inner loop start pointer

	stxvd2x	v0, r12, r9
	stxvd2x	v0, r14, r9
	stxvd2x	v0, r15, r9
	stxvd2x	v0, r16, r9
	stxvd2x	v0, r17, r9
	stxvd2x	v0, r18, r9
	stxvd2x	v0, r19, r9
	stxvd2x	v0, r20, r9

	stxvd2x	v0, r21, r9
	stxvd2x	v0, r22, r9
	stxvd2x	v0, r23, r9
	stxvd2x	v0, r24, r9
	stxvd2x	v0, r25, r9
	stxvd2x	v0, r26, r9
	stxvd2x	v0, r27, r9
	stxvd2x	v0, r28, r9

	cmpwi	r11, 0
	bne	.Linner_vsx_loop_3

	cmpwi	r10, 0
	bne	.Louter_vsx_loop_3

	ld	r28, 136(r1)	# restore r28
	ld	r27, 128(r1)	# restore r27
	ld	r26, 120(r1)	# restore r26
	ld	r25, 112(r1)	# restore r25
	ld	r24, 104(r1)	# restore r24
	ld	r23, 96(r1)	# restore r23
	ld	r22, 88(r1)	# restore r22
	ld	r21, 80(r1)	# restore r21
	ld	r20, 72(r1)	# restore r20
	ld	r19, 64(r1)	# restore r19
	ld	r18, 56(r1)	# restore r18
	ld	r17, 48(r1)	# restore r17
	ld	r16, 40(r1)	# restore r16
	ld	r15, 32(r1)	# restore r15
	ld	r14, 24(r1)	# restore r14
	ld	r0, 16(r1)	# restore saved link register
	mtlr	r0
	addi	r1, r1, 152	# destroy the stack frame
	blr

#------------------------------------------------------------------------------
# Name:		Writer
# Purpose:	Writes 64-bit value sequentially to an area of memory.
# Params:	r3 = ptr to memory area
# 		r4 = length in bytes
# 		r5 = loops
# 		r6 = quad to write
#------------------------------------------------------------------------------
.align 3			# align to 8 byte boundary
Writer:
_Writer:
	stdu	r1, -32(r1)	# update and store stack pointer
	mflr	r0		# set up the stack frame
	std	r0, 16(r1)	# save the link register

	mr	r7, r4		# calculate inner loop count
	srdi	r7, r7, 8	# length in bytes / 256

	mr	r10, r5		# load outer loop counter
.Louter_loop_8:
	addi	r10, r10, -1
	mtctr	r7		# copy inner loop count to count register
	mr	r9, r3		# (re)load inner loop pointer address
.Linner_loop_8:
	std	r6, 0(r9)
	std	r6, 8(r9)
	std	r6, 16(r9)
	std	r6, 24(r9)
	std	r6, 32(r9)
	std	r6, 40(r9)
	std	r6, 48(r9)
	std	r6, 56(r9)
	std	r6, 64(r9)
	std	r6, 72(r9)
	std	r6, 80(r9)
	std	r6, 88(r9)
	std	r6, 96(r9)
	std	r6, 104(r9)
	std	r6, 112(r9)
	std	r6, 120(r9)
	std	r6, 128(r9)
	std	r6, 136(r9)
	std	r6, 144(r9)
	std	r6, 152(r9)
	std	r6, 160(r9)
	std	r6, 168(r9)
	std	r6, 176(r9)
	std	r6, 184(r9)
	std	r6, 192(r9)
	std	r6, 200(r9)
	std	r6, 208(r9)
	std	r6, 216(r9)
	std	r6, 224(r9)
	std	r6, 232(r9)
	std	r6, 240(r9)
	std	r6, 248(r9)
	addi	r9, r9, 256	# increment pointer by 256 bytes
	bdnz	.Linner_loop_8

	cmpwi	r10, 0
	bne	.Louter_loop_8

	ld	r0, 16(r1)	# restore saved link register
	mtlr	r0
	addi	r1, r1, 32	# destroy the stack frame
	blr

#------------------------------------------------------------------------------
# Name:		Writer_128bytes
# Purpose:	Writes 64-bit value sequentially to an area of memory.
# Params:	r3 = ptr to memory area
# 		r4 = length in bytes
# 		r5 = loops
# 		r6 = quad to write
#------------------------------------------------------------------------------
.align 3			# align to 8 byte boundary
Writer_128bytes:
_Writer_128bytes:
	stdu	r1, -32(r1)	# update and store stack pointer
	mflr	r0		# set up the stack frame
	std	r0, 16(r1)	# save the link register

	mr	r7, r4		# calculate inner loop count
	srdi	r7, r7, 7	# length in bytes / 128

	mr	r10, r5		# load outer loop counter
.Louter_loop_9:
	addi	r10, r10, -1
	mtctr	r7		# copy inner loop count to count register
	mr	r9, r3		# (re)load inner loop pointer address
.Linner_loop_9:
	std	r6, 0(r9)
	std	r6, 8(r9)
	std	r6, 16(r9)
	std	r6, 24(r9)
	std	r6, 32(r9)
	std	r6, 40(r9)
	std	r6, 48(r9)
	std	r6, 56(r9)
	std	r6, 64(r9)
	std	r6, 72(r9)
	std	r6, 80(r9)
	std	r6, 88(r9)
	std	r6, 96(r9)
	std	r6, 104(r9)
	std	r6, 112(r9)
	std	r6, 120(r9)
	addi	r9, r9, 128	# increment pointer by 128 bytes
	bdnz	.Linner_loop_9

	cmpwi	r10, 0
	bne	.Louter_loop_9

	ld	r0, 16(r1)	# restore saved link register
	mtlr	r0
	addi	r1, r1, 32	# destroy the stack frame
	blr

#------------------------------------------------------------------------------
# Name:		StackReader
# Purpose:	Reads 64-bit values off the stack into registers of
#		the main register set, effectively testing L1 cache access
#		*and* effective-address calculation speed.
# Params:	r3 = loops
#------------------------------------------------------------------------------
.align 3			# align to 8 byte boundary
StackReader:
_StackReader:
	stdu	r1, -128(r1)	# update and store stack pointer
	mflr	r0		# set up the stack frame
	std	r0, 16(r1)	# save the link register
	mr	r5, r1		# save stack pointer for testing
	addi	r5, r5, 32	# increment saved testing stack pointer

	# push qword 7000
	lis	r4, stack_test_7@highest	# load stack_test_7 bits 48-63 into r4 bits 16-31
	ori	r4, r4, stack_test_7@higher	# load stack_test_7 bits 32-47 into r4 bits  0-15
	rldicr  r4, r4, 32, 31			# rotate r4's low word into r4's high word
	oris    r4, r4, stack_test_7@h 		# load stack_test_7 bits 16-31 into r4 bits 16-31
	ori     r4, r4, stack_test_7@l		# load stack_test_7 bits  0-15 into r4 bits  0-15
	std	r4, 48(r5)

	# push qword 6000
	lis	r4, stack_test_6@highest	# load stack_test_6 bits 48-63 into r4 bits 16-31
	ori	r4, r4, stack_test_6@higher	# load stack_test_6 bits 32-47 into r4 bits  0-15
	rldicr  r4, r4, 32, 31			# rotate r4's low word into r4's high word
	oris    r4, r4, stack_test_6@h 		# load stack_test_6 bits 16-31 into r4 bits 16-31
	ori     r4, r4, stack_test_6@l		# load stack_test_6 bits  0-15 into r4 bits  0-15
	std	r4, 40(r5)

	# push qword 5000
	lis	r4, stack_test_5@highest	# load stack_test_5 bits 48-63 into r4 bits 16-31
	ori	r4, r4, stack_test_5@higher	# load stack_test_5 bits 32-47 into r4 bits  0-15
	rldicr  r4, r4, 32, 31			# rotate r4's low word into r4's high word
	oris    r4, r4, stack_test_5@h 		# load stack_test_5 bits 16-31 into r4 bits 16-31
	ori     r4, r4, stack_test_5@l		# load stack_test_5 bits  0-15 into r4 bits  0-15
	std	r4, 32(r5)

	# push qword 4000
	lis	r4, stack_test_4@highest	# load stack_test_4 bits 48-63 into r4 bits 16-31
	ori	r4, r4, stack_test_4@higher	# load stack_test_4 bits 32-47 into r4 bits  0-15
	rldicr  r4, r4, 32, 31			# rotate r4's low word into r4's high word
	oris    r4, r4, stack_test_4@h 		# load stack_test_4 bits 16-31 into r4 bits 16-31
	ori     r4, r4, stack_test_4@l		# load stack_test_4 bits  0-15 into r4 bits  0-15
	std	r4, 24(r5)

	# push qword 3000
	lis	r4, stack_test_3@highest	# load stack_test_3 bits 48-63 into r4 bits 16-31
	ori	r4, r4, stack_test_3@higher	# load stack_test_3 bits 32-47 into r4 bits  0-15
	rldicr  r4, r4, 32, 31			# rotate r4's low word into r4's high word
	oris    r4, r4, stack_test_3@h 		# load stack_test_3 bits 16-31 into r4 bits 16-31
	ori     r4, r4, stack_test_3@l		# load stack_test_3 bits  0-15 into r4 bits  0-15
	std	r4, 16(r5)

	# push qword 2000
	lis	r4, stack_test_2@highest	# load stack_test_2 bits 48-63 into r4 bits 16-31
	ori	r4, r4, stack_test_2@higher	# load stack_test_2 bits 32-47 into r4 bits  0-15
	rldicr  r4, r4, 32, 31			# rotate r4's low word into r4's high word
	oris    r4, r4, stack_test_2@h 		# load stack_test_2 bits 16-31 into r4 bits 16-31
	ori     r4, r4, stack_test_2@l		# load stack_test_2 bits  0-15 into r4 bits  0-15
	std	r4, 8(r5)

	# push qword 1000
	lis	r4, stack_test_1@highest	# load stack_test_1 bits 48-63 into r4 bits 16-31
	ori	r4, r4, stack_test_1@higher	# load stack_test_1 bits 32-47 into r4 bits  0-15
	rldicr  r4, r4, 32, 31			# rotate r4's low word into r4's high word
	oris    r4, r4, stack_test_1@h 		# load stack_test_1 bits 16-31 into r4 bits 16-31
	ori     r4, r4, stack_test_1@l		# load stack_test_1 bits  0-15 into r4 bits  0-15
	std	r4, 0(r5)

	mtctr	r3		# copy loop count to count register
.Lstack_loop_0:
	ld	r8, 0(r5)
	ld	r8, 16(r5)
	ld	r8, 24(r5)
	ld	r8, 32(r5)
	ld	r8, 40(r5)
	ld	r8, 8(r5)
	ld	r8, 48(r5)
	ld	r8, 0(r5)
	ld	r8, 0(r5)
	ld	r8, 16(r5)
	ld	r8, 24(r5)
	ld	r8, 32(r5)
	ld	r8, 40(r5)
	ld	r8, 8(r5)
	ld	r8, 48(r5)
	ld	r8, 0(r5)
	ld	r8, 0(r5)
	ld	r8, 16(r5)
	ld	r8, 24(r5)
	ld	r8, 32(r5)
	ld	r8, 40(r5)
	ld	r8, 8(r5)
	ld	r8, 48(r5)
	ld	r8, 8(r5)
	ld	r8, 8(r5)
	ld	r8, 16(r5)
	ld	r8, 24(r5)
	ld	r8, 32(r5)
	ld	r8, 40(r5)
	ld	r8, 8(r5)
	ld	r8, 48(r5)
	ld	r8, 8(r5)
	bdnz	.Lstack_loop_0

	ld	r0, 16(r1)	# restore saved link register
	mtlr	r0
	addi	r1, r1, 128	# destroy the stack frame
	blr

#------------------------------------------------------------------------------
# Name:		StackWriter
# Purpose:	Writes 64-bit values into the stack from registers of
#		the main register set, effectively testing L1 cache access
#		*and* effective-address calculation speed.
# Params:	r3 = loops
#------------------------------------------------------------------------------
.align 3			# align to 8 byte boundary
StackWriter:
_StackWriter:
	stdu	r1, -128(r1)	# update and store stack pointer
	mflr	r0		# set up the stack frame
	std	r0, 16(r1)	# save the link register
	mr	r5, r1		# save stack pointer for testing
	addi	r5, r5, 32	# increment saved testing stack pointer

	# push qword 7000
	lis	r4, stack_test_7@highest	# load stack_test_7 bits 48-63 into r4 bits 16-31
	ori	r4, r4, stack_test_7@higher	# load stack_test_7 bits 32-47 into r4 bits  0-15
	rldicr  r4, r4, 32, 31			# rotate r4's low word into r4's high word
	oris    r4, r4, stack_test_7@h 		# load stack_test_7 bits 16-31 into r4 bits 16-31
	ori     r4, r4, stack_test_7@l		# load stack_test_7 bits  0-15 into r4 bits  0-15
	std	r4, 48(r5)

	# push qword 6000
	lis	r4, stack_test_6@highest	# load stack_test_6 bits 48-63 into r4 bits 16-31
	ori	r4, r4, stack_test_6@higher	# load stack_test_6 bits 32-47 into r4 bits  0-15
	rldicr  r4, r4, 32, 31			# rotate r4's low word into r4's high word
	oris    r4, r4, stack_test_6@h 		# load stack_test_6 bits 16-31 into r4 bits 16-31
	ori     r4, r4, stack_test_6@l		# load stack_test_6 bits  0-15 into r4 bits  0-15
	std	r4, 40(r5)

	# push qword 5000
	lis	r4, stack_test_5@highest	# load stack_test_5 bits 48-63 into r4 bits 16-31
	ori	r4, r4, stack_test_5@higher	# load stack_test_5 bits 32-47 into r4 bits  0-15
	rldicr  r4, r4, 32, 31			# rotate r4's low word into r4's high word
	oris    r4, r4, stack_test_5@h 		# load stack_test_5 bits 16-31 into r4 bits 16-31
	ori     r4, r4, stack_test_5@l		# load stack_test_5 bits  0-15 into r4 bits  0-15
	std	r4, 32(r5)

	# push qword 4000
	lis	r4, stack_test_4@highest	# load stack_test_4 bits 48-63 into r4 bits 16-31
	ori	r4, r4, stack_test_4@higher	# load stack_test_4 bits 32-47 into r4 bits  0-15
	rldicr  r4, r4, 32, 31			# rotate r4's low word into r4's high word
	oris    r4, r4, stack_test_4@h 		# load stack_test_4 bits 16-31 into r4 bits 16-31
	ori     r4, r4, stack_test_4@l		# load stack_test_4 bits  0-15 into r4 bits  0-15
	std	r4, 24(r5)

	# push qword 3000
	lis	r4, stack_test_3@highest	# load stack_test_3 bits 48-63 into r4 bits 16-31
	ori	r4, r4, stack_test_3@higher	# load stack_test_3 bits 32-47 into r4 bits  0-15
	rldicr  r4, r4, 32, 31			# rotate r4's low word into r4's high word
	oris    r4, r4, stack_test_3@h 		# load stack_test_3 bits 16-31 into r4 bits 16-31
	ori     r4, r4, stack_test_3@l		# load stack_test_3 bits  0-15 into r4 bits  0-15
	std	r4, 16(r5)

	# push qword 2000
	lis	r4, stack_test_2@highest	# load stack_test_2 bits 48-63 into r4 bits 16-31
	ori	r4, r4, stack_test_2@higher	# load stack_test_2 bits 32-47 into r4 bits  0-15
	rldicr  r4, r4, 32, 31			# rotate r4's low word into r4's high word
	oris    r4, r4, stack_test_2@h 		# load stack_test_2 bits 16-31 into r4 bits 16-31
	ori     r4, r4, stack_test_2@l		# load stack_test_2 bits  0-15 into r4 bits  0-15
	std	r4, 8(r5)

	# push qword 1000
	lis	r4, stack_test_1@highest	# load stack_test_1 bits 48-63 into r4 bits 16-31
	ori	r4, r4, stack_test_1@higher	# load stack_test_1 bits 32-47 into r4 bits  0-15
	rldicr  r4, r4, 32, 31			# rotate r4's low word into r4's high word
	oris    r4, r4, stack_test_1@h 		# load stack_test_1 bits 16-31 into r4 bits 16-31
	ori     r4, r4, stack_test_1@l		# load stack_test_1 bits  0-15 into r4 bits  0-15
	std	r4, 0(r5)

	mtctr	r3		# copy loop count to count register
.Lstack_loop_1:
	std	r8, 0(r5)
	std	r8, 16(r5)
	std	r8, 24(r5)
	std	r8, 32(r5)
	std	r8, 40(r5)
	std	r8, 8(r5)
	std	r8, 48(r5)
	std	r8, 0(r5)
	std	r8, 0(r5)
	std	r8, 16(r5)
	std	r8, 24(r5)
	std	r8, 32(r5)
	std	r8, 40(r5)
	std	r8, 8(r5)
	std	r8, 48(r5)
	std	r8, 0(r5)
	std	r8, 0(r5)
	std	r8, 16(r5)
	std	r8, 24(r5)
	std	r8, 32(r5)
	std	r8, 40(r5)
	std	r8, 8(r5)
	std	r8, 48(r5)
	std	r8, 8(r5)
	std	r8, 8(r5)
	std	r8, 16(r5)
	std	r8, 24(r5)
	std	r8, 32(r5)
	std	r8, 40(r5)
	std	r8, 8(r5)
	std	r8, 48(r5)
	std	r8, 8(r5)
	bdnz	.Lstack_loop_1

	ld	r0, 16(r1)	# restore saved link register
	mtlr	r0
	addi	r1, r1, 128	# destroy the stack frame
	blr

#------------------------------------------------------------------------------
# Name:		RegisterToRegister
# Purpose:	Reads/writes 64-bit values between registers of 
#		the main register set.
# Params:	r3 = loops
#------------------------------------------------------------------------------
.align 3			# align to 8 byte boundary
RegisterToRegister:
_RegisterToRegister:
	stdu	r1, -32(r1)	# update and store stack pointer
	mflr	r0		# set up the stack frame
	std	r0, 16(r1)	# save the link register

	mtctr	r3		# copy loop count to count register
.Lreg_loop_0:
	mr	r8, r9
	mr	r8, r7
	mr	r8, r6
	mr	r8, r5
	mr	r8, r4
	mr	r8, r10
	mr	r8, r11
	mr	r8, r9
	mr	r8, r9
	mr	r8, r7
	mr	r8, r6
	mr	r8, r5
	mr	r8, r4
	mr	r8, r10
	mr	r8, r11
	mr	r8, r9
	mr	r8, r9
	mr	r8, r7
	mr	r8, r6
	mr	r8, r5
	mr	r8, r4
	mr	r8, r10
	mr	r8, r11
	mr	r8, r9
	mr	r8, r9
	mr	r8, r7
	mr	r8, r6
	mr	r8, r5
	mr	r8, r4
	mr	r8, r10
	mr	r8, r11
	mr	r8, r9
	bdnz	.Lreg_loop_0

	ld	r0, 16(r1)	# restore saved link register
	mtlr	r0
	addi	r1, r1, 32	# destroy the stack frame
	blr

#------------------------------------------------------------------------------
# Name:		VectorToVector
# Purpose:	Reads/writes 128-bit values between registers of 
#		the vector register set, in this case AltiVec.
# Params:	r3 = loops
#------------------------------------------------------------------------------
.align 3			# align to 8 byte boundary
VectorToVector:
_VectorToVector:
	stdu	r1, -32(r1)	# update and store stack pointer
	mflr	r0		# set up the stack frame
	std	r0, 16(r1)	# save the link register

	mtctr	r3		# copy loop count to count register
.Lreg_loop_1:
	vmr	vs0, vs1	# Each move moves 16 bytes, so we need 16
	vmr	vs0, vs2	# moves to transfer a 256 byte chunk.
	vmr	vs0, vs3
	vmr	vs2, vs0
	vmr	vs1, vs2
	vmr	vs2, vs1
	vmr	vs0, vs3
	vmr	vs3, vs1

	vmr	vs3, vs2
	vmr	vs1, vs3
	vmr	vs2, vs1
	vmr	vs0, vs1
	vmr	vs1, vs2
	vmr	vs0, vs1
	vmr	vs0, vs3
	vmr	vs3, vs0
	bdnz	.Lreg_loop_1

	ld	r0, 16(r1)	# restore saved link register
	mtlr	r0
	addi	r1, r1, 32	# destroy the stack frame
	blr

#------------------------------------------------------------------------------
# Name:		RegisterToVector
# Purpose:	Writes 64-bit main register values into 128-bit vector register
#		clearing the upper unused bits.
# Params:	r3 = loops
#------------------------------------------------------------------------------
.align 3			# align to 8 byte boundary
RegisterToVector:
_RegisterToVector:
	stdu	r1, -32(r1)	# update and store stack pointer
	mflr	r0		# set up the stack frame
	std	r0, 16(r1)	# save the link register

	mtctr	r3		# copy loop count to count register
.Lreg_loop_2:
	mtvsrd	vs1, r8 	# Each movq transfers 8 bytes, so we need
	mtvsrd	vs2, r5		# 32 transfers to move a 256-byte chunk.
	mtvsrd	vs3, r9
	mtvsrd	vs1, r7
	mtvsrd	vs2, r5
	mtvsrd	vs3, r10
	mtvsrd	vs0, r4
	mtvsrd	vs0, r6

	mtvsrd	vs0, r8
	mtvsrd	vs1, r5
	mtvsrd	vs2, r9
	mtvsrd	vs3, r7
	mtvsrd	vs0, r5
	mtvsrd	vs3, r10
	mtvsrd	vs2, r4
	mtvsrd	vs1, r6

	mtvsrd	vs0, r8
	mtvsrd	vs1, r5
	mtvsrd	vs2, r9
	mtvsrd	vs3, r7
	mtvsrd	vs0, r5
	mtvsrd	vs3, r10
	mtvsrd	vs2, r4
	mtvsrd	vs1, r6

	mtvsrd	vs0, r8
	mtvsrd	vs1, r5
	mtvsrd	vs2, r9
	mtvsrd	vs3, r7
	mtvsrd	vs0, r5
	mtvsrd	vs3, r10
	mtvsrd	vs2, r4
	mtvsrd	vs1, r6
	bdnz	.Lreg_loop_2

	ld	r0, 16(r1)	# restore saved link register
	mtlr	r0
	addi	r1, r1, 32	# destroy the stack frame
	blr

#------------------------------------------------------------------------------
# Name:		VectorToRegister
# Purpose:	Writes lower 64 bits of vector register into 64-bit main 
#		register.
# Params:	r3 = loops
#------------------------------------------------------------------------------
.align 3			# align to 8 byte boundary
VectorToRegister:
_VectorToRegister:
	stdu	r1, -32(r1)	# update and store stack pointer
	mflr	r0		# set up the stack frame
	std	r0, 16(r1)	# save the link register

	mtctr	r3		# copy loop count to count register
.Lreg_loop_3:
	mfvsrd	r6, vs1
	mfvsrd	r6, vs2
	mfvsrd	r6, vs3
	mfvsrd	r6, vs1
	mfvsrd	r6, vs2
	mfvsrd	r6, vs3
	mfvsrd	r6, vs0
	mfvsrd	r6, vs0

	mfvsrd	r6, vs0
	mfvsrd	r6, vs1
	mfvsrd	r6, vs2
	mfvsrd	r6, vs3
	mfvsrd	r6, vs0
	mfvsrd	r6, vs3
	mfvsrd	r6, vs2
	mfvsrd	r6, vs1

	mfvsrd	r6, vs0
	mfvsrd	r6, vs1
	mfvsrd	r6, vs2
	mfvsrd	r6, vs3
	mfvsrd	r6, vs0
	mfvsrd	r6, vs3
	mfvsrd	r6, vs2
	mfvsrd	r6, vs1

	mfvsrd	r6, vs0
	mfvsrd	r6, vs1
	mfvsrd	r6, vs2
	mfvsrd	r6, vs3
	mfvsrd	r6, vs0
	mfvsrd	r6, vs3
	mfvsrd	r6, vs2
	mfvsrd	r6, vs1
	bdnz	.Lreg_loop_3

	ld	r0, 16(r1)	# restore saved link register
	mtlr	r0
	addi	r1, r1, 32	# destroy the stack frame
	blr
