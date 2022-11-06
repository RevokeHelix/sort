IDEAL
MODEL small
STACK 100h
DATASEG
array db 8,6,9,7,3,5,4,2,1,10
items dw 9
smaller db 0
CODESEG

proc swap
	;; function swap gets offset of array + offset added by loop as a parameter
    push bp
    mov bp,sp
	push bx
	push ax

    mov bl,[bp+4] ; move offset of first element to bl
    mov al,[BYTE PTR bx] ; move the memory cell of first element to al
    inc bx ; increase the offset to the next element
    mov ah,[BYTE PTR bx] ; move the memory cell of second element to ah
    dec bx ; decrease bx to first element
    mov [BYTE PTR bx], ah ; move second memory cell to first
    inc bx
    mov [BYTE PTR bx],al ; move first  memory cell to second

	pop bx
	pop ax
    pop bp
    ret
endp swap

proc min
	;; function swap gets offset of array + offset added by loop as a parameter
    push bp
    mov bp,sp

    push bx
    push ax

    xor ax,ax ; clear ax
    xor bx,bx ; clear bx

    mov bx,[bp+4] ; move parameter to bx
    mov al,[BYTE PTR bx] ; move first element to al
    cmp al,[BYTE PTR bx+1] ; compare al to second memory cell

    jng end1 ; if second cell is bigger jump to end
    greater:
        mov [smaller],1 ; if first cell is bigger move 1 to 'boolean' smaller
        jmp end1
    end1:
        pop bx
        pop ax 
        pop bp
        ret
endp min

start:
	mov ax, @data
	mov ds, ax
mov bx,offset array ; move bx to offset of array
outer:
	push cx
	xor cx,cx
	push bx
	inner:
		mov [smaller],0 ; clear smaller memory cell
		push bx
		call min ; call the function min to check whether [bx] is smaller than [bx+1]
		pop bx
		cmp [smaller],1 ; check is [bx] returned as smaller
		jne end2 ; if not skip to end of inner loop
		push bx ; push offset of items + offset of loop to swap func
		call swap ; if [bx] is smaller swap the memory cells of [bx] and [bx+1]
		pop bx 
		end2:
			inc cx ; increase cx to signify the loop finishing a run
			inc bx ; increase bx to increase offset of array
			cmp cx,[items] ; if cx is equal to the number of elements in the array exit inner
			jne inner
	pop bx ; return bx to its original value
	pop cx ; return cx to its original value
	inc cx ; increase number of times inner loop ran
	cmp cx,[items] ; if the number of times the inner loop ran is equal to the number of elements in the array stop
	jne outer
exit:
	mov ax, 4c00h
	int 21h
END start


