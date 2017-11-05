;    CP/M BIOS for CP/M-H8
;    Copyright (C) 2010 Sprite_tm
;    Copyright (C) 2017 kagura1050
;
;    This program is free software: you can redistribute it and/or modify
;    it under the terms of the GNU General Public License as published by
;    the Free Software Foundation, either version 3 of the License, or
;    (at your option) any later version.
;
;    This program is distributed in the hope that it will be useful,
;    but WITHOUT ANY WARRANTY; without even the implied warranty of
;    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;    GNU General Public License for more details.
;
;    You should have received a copy of the GNU General Public License
;    along with this program.  If not, see <http://www.gnu.org/licenses/>.

;msize:	equ	62	;size of available RAM in k

bias:	equ	(msize-20) * 1024 
ccp:	equ	$3400+bias	;base of cpm ccp
bdos:	equ	ccp+$806	;base of bdos
bios:	equ	ccp+$1600	;base of bios
cdisk:	equ	$0004		;current disk number (0 ... 15)
iobyte:	equ	$0003		;intel iobyte
buff:	equ	$0080		;default buffer address
retry:	equ	3		;max retries on disk i/o before error

cr:	equ	13
lf:	equ	10

WRITE_FUNC: equ	6
BOOT_FUNC:  equ 5

	org	bios
nsects:	equ	(bios-ccp)/128	;warm start sector count
	
	jp boot
wboote:	
	jp wboot
	jp const
	jp conin
	jp conout
	jp list
	jp punch
	jp reader
	jp home
	jp seldsk
	jp settrk
	jp setsec
	jp setdma
	jp read
	jp write
	jp listst
	jp sectran

signon:
	db	cr,lf
	db	msize/10+'0'
	db	msize - (msize/10)*10 + '0'	;modulo doesn't work?
	db	"k cp/m vers 2.2"
	db	cr,lf,0

boot:
	ld	sp,buff
	ld	hl,signon
	call	prmsg
	xor	a
	ld	(iobyte),a
	ld	(cdisk),a
	jp	wboot 

wboot:	;re-load CP/M
	ld	sp,buff
	ld	c,0
	call	seldsk
	call	home
	ld	b,nsects
	ld	c,0		;track
	ld	d,1		;sektor (0 based)
	ld	hl,ccp
load1:
	push	bc
	push	de
	push	hl
	ld	c,d
	ld	b,0
	call	setsec
	pop	bc
	push	bc
	call	setdma
	call	read
	cp	0		;read error?
	jp	nz,wboot
	
	pop	hl
	ld	de,128
	add	hl,de
	pop	de
	pop	bc
	dec	b
	jp	z,gocpm
	
	inc	d
	ld	a,d
	cp	64		;if sector >= 26 then change tracks
	jp	c,load1
	
	ld	d,0
	inc	c
	push	bc
	push	de
	push	hl
	ld	b,0
	call	settrk	
	pop	hl
	pop	de
	pop	bc
	jp	load1
	
gocpm:
	ld	a,0c3h
	ld	(0),a
	ld	hl,wboote
	ld	(1),hl
	ld	(5),a
	ld	hl,bdos
	ld	(6),hl
		
	ld	bc,buff
	call	setdma
	ld	a,(cdisk)
	ld	c,a
	jp	ccp

const:
	in a,(0)
	ret

conin:
	in a,(0)
	cp $ff
	jp nz,conin

	in a,(1)
	ret

conout:
	ld a,c
	out (2),a
	ret

list:
	ret

listst:
	ld a,0
	ret

punch:
	ret

reader:
	ld a,$1F
	ret

seldsk:
	ld hl,0			;error return code
	ld a,c
	out (15),a
	cp 0			;only one disk supportet
	jp nz,seldsk_na
	ld hl,dph		;return disk parameter header address
seldsk_na:
	ret

home:
	push af
	ld a,0
	out (16),a
	out (17),a	;add neko Java.
	pop af
	ret
	
settrk:
	push af
	ld a,c
	out (16),a
	ld a,b		;add neko Java
	out (17),a	;add neko Java
	pop af
	ret

setsec:
	ld a,c
	out (18),a
	ret

setdma:
	ld a,c
	out (20),a
	ld a,b
	out (21),a
	ret

read:
	ld a,1
	out (22),a
	in a,(23)	;mod neko Java
	ret

write:
	ld a,2
	out (22),a
	in a,(23)	;mod neko Java
	ret

sectran:
	;translate sector bc using table at de, res into hl
	ld h,b
	ld l,c
	ld a,d
	or e
	ret z
	ex de,hl
	add hl,bc
	ld l,(hl)
	ld h,0
	ret

prmsg:
	ld	a,(hl)
	or	a
	ret	z
	push	hl
	ld	c,a
	call	conout
	pop	hl
	inc	hl
	jp	prmsg
	

;Disk Parameter Header
dph:
	dw 0 ;XLT: Address of translation table
	dw 0 ;000: Scratchpad
	dw 0 ;000: Scratchpad
	dw 0 ;000: Scratchpad
	dw dirbuf ;DIRBUF: Address of a dirbuff scratchpad
	dw dpb ;DPB: Address of a disk parameter block
	dw chk ;CSV: Address of scratchpad area for changed disks
	dw all ;ALV: Address of an allocation info scratchpad

dpb:
	dw 64 ;SPT: sectors per track
	db 4 ;BSH: data allocation block shift factor
	db 15 ;BLM: Data Allocation Mask
	db 0 ;Extent mask
	dw 971 ;DSM: Disk storage capacity
	dw 127 ;DRM, no of directory entries
	db 192 ;AL0
	db 0 ;AL1
	dw 32 ;CKS, size of dir check vector
	dw 1 ;OFF, no of reserved tracks
	

trans:
	db 0

dirbuf:
	ds 128

chk:
	ds 32

all:
	ds 122
;end

