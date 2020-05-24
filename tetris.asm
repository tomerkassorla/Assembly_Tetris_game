IDEAL
MODEL small
p186
STACK 0f500h
MAX_BMP_WIDTH = 320
MAX_BMP_HEIGHT = 200
SMALL_BMP_HEIGHT = 40
SMALL_BMP_WIDTH = 40
DATASEG
	score db 0,0,0 ;מחרוזת של הניקוד המתחילה באפסים
	Sscore db 'Score:    $';מחרוזת 
	asarot db 0
	meot db 0
	shura db 0;משתנה של שורות
	y2 dw 0;yמשתנה שלא ישתנה ה
	x2 dw 0;xמשתנה שלא ישתנה ה
	yesh db 0
	x5 dw 0
	y5 dw 0
	r dw 0
	l dw 0 ;
	x3 dw 0 ;שומר ערכי X Y
	y3 dw 0 ;שומר ערכי X Y
    xx dw 0 ;מוסיף לפונקצית בודק (גבולות) את הערכים שצריך לבדוק
	z3 dw 0 ;מחליף בן במרובעים
	x1 dw 150
	y dw 0
	color1 dw 2
	rohav dw 80
	oreh dw 20
	Clock equ es:6Ch
    OneBmpLine 	db MAX_BMP_WIDTH dup (0)  ; One Color line read buffer
    ScreenLineMax 	db MAX_BMP_WIDTH dup (0)  ; One Color line read buffer
	;BMP File data
	FileHandle	dw ?
	Header 	    db 54 dup(0)
	Palette 	db 400h dup (0)
	current dw (?)
	pic1 db 'ptiha.bmp',0
	pic2 db 'inst.bmp',0
	pic3 db 'end.bmp',0
	pic4 db 'game.bmp',0
	BmpFileErrorMsg    	db 'Error At Opening Bmp File .', 0dh, 0ah,'$'
	ErrorFile           db 0
	BmpLeft dw ?
	BmpTop dw ?
	BmpColSize dw ?
	BmpRowSize dw ?	
	x db 10
	aOreh dw 1 dup(0,30,10,30,20,10,50)
	aRohav dw 1 dup (0,60,40,20,40,10,20) 
	aColor dw 1 dup(0,2,4,5,3,1,6)
CODESEG
proc hazara ;פונקציה שמאתחלת את הנתונים
	add [z3],2
	cmp [z3],14
	je z33
	jmp hazarr
z33:
	mov [z3],2
hazarr:
	mov [x1],199
	mov [y],0
	mov dx,[x1]
	mov ax,[y]
	mov [x3],dx
	mov [y3],ax
	ret
endp hazara
proc Rect ;פונקציה שמציירת מרובע לפי המשתנים
	mov bx,[z3]
	mov dx,[aOreh+bx]
	mov [oreh],dx
	push [oreh]
	mov dx,[aRohav+bx]
	mov [Rohav],dx
	push [rohav]
	push [x1]
	push [y]
	mov dx,[aColor+bx]
	mov [color1],dx
	push [color1]
	call rectpar
	ret
endp Rect
proc gvulot_game ;פונקציה שמציירת את גבולות המשחק על המסך בצבע צהוב
	pusha
	push 200	;left
	push 1
	push 88
	push 0
	push 54
	call rectpar
	push 2	;down
	push 232
	push 88
	push 198
	push 54
	call rectpar
	push 200	;right
	push 1
	push 319
	push 0
	push 54
	call rectpar
	popa
	ret
endp gvulot_game
proc hazaza ;פונקציה שמורידה את המרובע למטה
	call Rect
	mov dx,[x3]
	mov ax,[y3]
	mov [x1],dx
	mov [y],ax
	call countsec
	call Rectblack
	add [y],2
	mov dx,[x1]
	mov ax,[y]
	mov [x3],dx
	mov [y3],ax
	call bodek
	call bodekzady
	call bodekzads
	call bdikatmasah
	call keletHazaza
	ret 
endp hazaza
proc keletHazaza ;פונקציה שמקבלת קלט מקלדת ועושה מה שהמשתמש לחץ
	mov ah,1  ;check flag
	int 16h
	jz labeloo
	mov ah,0
	int 16h
	cmp ah, 04dh ;scan code-right
	je right
	cmp ah, 04bh ;scan code-left
	je left
	cmp ah, 50h ;scan code-down
	je downn
	cmp ah, 39h ;scan code-space
	je space
	cmp ah, 1 ;scan code-esc
	je bye
	cmp al,'h'
	je labelhome1
	jmp labeloo
bye:
	call ClearScreen
	jmp exit
labelhome1:
	call ClearScreen
	call keletI
	jmp label0
left:
	call RunLeft
	jmp label0
right:
	call RunRight
	jmp label0
downn:
	call Down
	jmp label0
space:
	call Rectblack 
	call sivuv
label0:
	call bodek
	call bodekzads
	call bodekzady
labeloo:
	call hazaza
labelexi:
	ret 
endp keletHazaza
proc RunRight ;פונקציה שמוזיזה את המרובע ימינה אם יש קלט מקלדת
	cmp [r],1
	je rr
	add [x1],10
	mov dx,[x1]
	mov [x3],dx
rr:
	mov [r],0
	ret
endp RunRight
proc RunLeft ;פונקציה שמוזיזה את המרובע שמאלה אם יש קלט מקלדת
	cmp [l],1
	je ll
	sub [x1],10
	mov dx,[x1]
	mov [x3],dx
ll:
	mov [l],0
	ret
endp RunLeft
proc Down ;פונקציה שמורידה את המרובע יותר מהר אם יש קלט מקלדת
	add [y],2
	mov ax,[y]
	mov [y3],ax
	ret
endp Down
proc sivuv ;switch rohav and oreh
	mov bx,[z3]
	mov ax, [oreh]
	mov dx, [rohav]
	mov [aOreh+bx], dx
	mov [oreh], dx
	mov [aRohav+bx], ax
	mov [rohav], ax
	ret
endp sivuv
proc readPixel; פונקציה שקוראת פיקסל
	mov cx,si
	mov dx,di
	mov ah,0Dh
	int 10h 
	ret
endp readPixel
proc bdikatmasah ;פונקציה שבודקת על כל המסך אם יש שורה שצריך למחוק
	mov [x5],89
	mov [y5],8
	mov cx,19
lool:
	push cx
	call bdikatmehika
	pop cx
	add [y5],10
	loop lool
	mov [yesh],0
exii:
	ret
endp bdikatmasah
proc bdikatmehika ; פונקציה שבודקת אם יש שורה מלאה, 230 על 10. אם יש אז היא בודקת איזה שואה זאת ולפי זה מעתיקה את כל החלק שמעל השורה שורה אחת למטה
	pusha
	mov [y2],0
	mov cx,10
loolahat:
	mov di,[y5]
	add di,[y2]
	inc [y2]
	push cx
	call bmehikatlinepixeles
	pop cx
	cmp [yesh],1
	je oved
	jmp rer1
oved:
	loop loolahat
	mov dx,[y5]
	mov [y2],dx
	mov ax,[y2]
	mov dl,10
	div dl
	add al,1
	mov [shura],al
	mov [yesh],0
	xor cx,cx
	mov cl,[shura]
loolo:
	push cx
	mov cx,23
	mov ax,[x5]
	mov [x2],ax
loola:
	push cx
	call yerida
	add [x2],10
	pop cx
	loop loola
	sub [y2],10
	pop cx
	loop loolo
	call points
rer1:
	popa
	ret
endp bdikatmehika
proc yerida ;.פונקציה שקוראת את הפינה הגבוהה והשמאלית של ריבוע 10 על 10 ומעתיקה אותו שורה אחת למטה (10 פיקסלים);
	mov si,[x2]
	mov di,[y2]
	sub di,10
	call readPixel
	mov ah,0
	add di,10
	push 10
	push 10
	push [x2]
	push [y2]
	push ax
	call rectpar
	ret
endp yerida
proc points ;פונקציה שמעלה את הניקוד 
	inc [asarot];point
	cmp [asarot],9
	jbe lasarot
	inc [meot]
	mov [score+1],0
	mov [asarot],0
	mov cl,[meot]
	mov [score],cl
	jmp exscore
lasarot:
	mov cl,[asarot]
	mov [score+1],cl
exscore:
	call scorep
	ret
endp points
proc bmehikatlinepixeles ;פונקציה שבודקת אם יש שורה שלמה שהיא לא שחורה אם כן מגדילה משתנה
	mov [x2],0
	mov cx,230;pixeles
bloolaha:
	push cx
	mov si,[x5]
	add si,[x2]
	mov cx,si
	mov dx,di
	mov ah,0Dh
	int 10h 
	cmp al,0
	jne notblackk
	pop cx
	jmp rer
notblackk:
	inc [x2]
	pop cx
	loop bloolaha
	mov [yesh],1 ;switch
rer:
	ret
endp bmehikatlinepixeles
proc scorep ;פונקציה שמעדכנת את נתוני הניקוד למסך
	pusha
	mov dl,1
	mov dh,1
	mov bx,0
	mov ah,2
	int 10h
	mov cl,[score]
	add cl,30h
	mov [Sscore+7],cl
	mov cl,[score+1]
	add cl,30h
	mov [Sscore+8],cl
	mov [Sscore+9],'0'
	mov dx, offset Sscore
	mov ah,9h
	int 21h
	popa
	ret
endp scorep
proc bodek ;.פונקציה שבודקת אם השורה שמתחת למרובע שחורה, אם לא מדפיסה ריבוע למסך אם כן ממשיכה כרגיל
	pusha
	mov [xx],0
	mov cx,[rohav]
labelbodek:
	push cx
	mov si,[x1]
	mov di,[y]
	mov ax,[oreh]
	inc ax
	add di,ax
	add si,[xx]
	call readPixel
	cmp al,0
	jne notblack
	inc [xx]
	pop cx
	loop labelbodek
	jmp labelexitt
notblack:
	call Rect
	cmp [y],7
	jb gameover
	jmp gamee
gameover:
	call ClearScreen
	jmp ex
gamee:
	call hazara
	call hazaza
labelexitt:
	popa
	ret
endp bodek
proc keletI ;פונקציה שמקבלת קלט מקלדת להתחלת המשחק או להוראות
labelhome:
	mov [score+1],0
	mov [score],0
	mov [current],offset pic1
	call ppic1
WaitForData:
	mov ah,0
	int 16h
	cmp al,'s'
	je label1
	cmp al,'i'
	je label2
	jmp WaitForData
label1:
	call ClearScreen
	mov [current],offset pic4
	call ppic1
	call Gamep
label2:
	call ClearScreen
	mov [current],offset pic2
	call ppic1
labe:
	mov ah,0
	int 16h
	cmp al,'h'
	je labelhome
	jmp labe
labele:
	ret
endp keletI
proc Gamep ;פונקציה שמתחילה את המסך- מכינה את המסך
	call hazara
	call gvulot_game
	call scorep
label11:
	call hazaza
	ret
endp Gamep
start:
	mov ax, @data
	mov ds, ax
	call SetGraphic 
stat:
	call keletI
ex:
	call ClearScreen
	mov [current],offset pic3
	call ppic1
	WaitForData1:
	mov ah,0
	int 16h
	cmp al,'r'
	je stat
	jmp WaitForData1
exit:
	mov ah,0
	int 16h
	mov ax,2
	int 10h
	mov ax, 4c00h
	int 21h	
proc drawPixel ;פונקציה שמציירת פיקסל על המסך
	xp equ [bp+8]
	yp equ [bp+6]
	colorP equ [bp+4]
	push bp
	mov bp,sp
	push cx
	xor bh,bh
	mov cx,xp
	mov dx,yp
	mov ax,colorp
	mov ah,0ch
	int 10h
	pop cx
	pop bp
	ret 6
endp drawPixel
proc drawLine ;פונקציה שמציירת שורת פיקסלים
	rohavp equ [bp+10]
	xp equ [bp+8]
	yp equ [bp+6]
	colorp equ[bp+4]
	push bp
	mov bp,sp
	mov cx,rohavp
label12:
push xp
	push yp
	push colorp
	call drawPixel
	inc xp
	loop label12
	pop bp
	ret 8
endp drawLine
proc rectpar ;פונקציה של ריבוע עם פרמטרים
	push cx
	orehp equ [bp+14]
	rohavp equ [bp+12]
	xp equ [bp+10]
	yp equ [bp+8]
	colorp equ[bp+6]
	push bp
	mov bp,sp
	mov cx,orehp
	mov si,xp
conti:	
	mov xp,si
	push cx
	push rohavp
	push xp 
	push yp
	push colorp
	call drawLine
	pop cx
	inc yp
	loop conti
	pop bp
	pop cx
	ret 10
endp rectpar
proc Rectblack ;פונקציה של ריבוע שחור
	pusha
	push [oreh]
	push [rohav]
	push [x1]
	push [y]
	push 0
	call rectpar
	popa
	ret
endp Rectblack
proc ppic1 ;פונקציה שמצגיה תמונה על המסך
	pusha
	mov [BmpLeft],0
	mov [BmpTop],0
	mov [BmpColSize], 320
	mov [BmpRowSize] ,200
	mov dx,[current]
	call OpenShowBmp 
	cmp [ErrorFile],1
	jne continue
	jmp exitError
exitError:
    mov dx, offset BmpFileErrorMsg
	mov ah,9
	int 21h	
continue:
	popa	
ret
endp ppic1
proc bodekzads ;פוקציה שבודקת אם צד שמאל של המרובע שחור אם כן ממשיכה אם לא מגדילה משתנה שמדלג על הפונקציה שמוזיזה שמאלה
	pusha
	mov ax,[oreh]
	dec ax
	mov [xx],ax
	mov cx,[oreh]
labelbodek1:
	mov [l],0
	push cx
	mov si,[x1]
	mov di,[y]
	add di,[xx]
	dec si
	call readPixel
	cmp al,0
	jne notblack1
	dec [xx]
	pop cx
	loop labelbodek1
	jmp labelexitt1
notblack1:
	inc [l]
	call keletHazaza
labelexitt1:
	popa
	ret
endp bodekzads
proc bodekzady ;like bodekzads רק לצד ימין
	pusha
	mov ax,[oreh]
	dec ax
	mov [xx],ax
	mov cx,[oreh]
labelbodek2:
	mov [r],0
	push cx
	mov si,[x1]
	mov di,[y]
	add di,[xx]
	add si,[rohav]
	call readPixel
	cmp al,0
	jne notblack2
	dec [xx]
	pop cx
	loop labelbodek2
	jmp labelexitt2
notblack2:
	inc [r]
	call keletHazaza
labelexitt2:
	popa
	ret
endp bodekzady
proc countsec
	pusha
	push es
	mov ax, 40h
	mov es, ax
	mov cx,1 ; number of ticks to wait
DelayLoop:
	mov ax, [Clock]
Tick:
	cmp ax, [Clock]
	je Tick
	loop DelayLoop
	pop es
	popa
ret
endp countsec
; input :
;	1.BmpLeft offset from left (where to start draw the picture) 
;	2. BmpTop offset from top
;	3. BmpColSize picture width , 
;	4. BmpRowSize bmp height 
;	5. dx offset to file name with zero at the end 
proc OpenShowBmp near
	push cx
	push bx
	call OpenBmpFile
	cmp [ErrorFile],1
	je @@ExitProc
	call ReadBmpHeader	; from  here assume bx is global param with file handle. 
	call ReadBmpPalette
	call CopyBmpPalette
	call ShowBMP 
	call CloseBmpFile
@@ExitProc:
	pop bx
	pop cx
	ret
endp OpenShowBmp	; input dx filename to open
proc OpenBmpFile	near						 
	mov ah, 3Dh
	xor al, al
	int 21h
	jc @@ErrorAtOpen
	mov [FileHandle], ax
	jmp @@ExitProc	
@@ErrorAtOpen:
	mov [ErrorFile],1
@@ExitProc:	
	ret
endp OpenBmpFile
proc CloseBmpFile near
	mov ah,3Eh
	mov bx, [FileHandle]
	int 21h
	ret
endp CloseBmpFile ; Read 54 bytes the Header
proc ReadBmpHeader	near					
	push cx
	push dx
	mov ah,3fh
	mov bx, [FileHandle]
	mov cx,54
	mov dx,offset Header
	int 21h
	pop dx
	pop cx
	ret
endp ReadBmpHeader
proc ReadBmpPalette near ; Read BMP file color palette, 256 colors * 4 bytes (400h)
						 ; 4 bytes for each color BGR + null)			
	push cx
	push dx
	mov ah,3fh
	mov cx,400h
	mov dx,offset Palette
	int 21h
	pop dx
	pop cx
	ret
endp ReadBmpPalette
; Will move out to screen memory the colors
; video ports are 3C8h for number of first color
; and 3C9h for all rest
proc CopyBmpPalette		near						
	push cx
	push dx
	mov si,offset Palette
	mov cx,256
	mov dx,3C8h
	mov al,0  ; black first							
	out dx,al ;3C8h
	inc dx	  ;3C9h
CopyNextColor:
	mov al,[si+2] 		; Red				
	shr al,2 			; divide by 4 Max (cos max is 63 and we have here max 255 ) (loosing color resolution).				
	out dx,al 						
	mov al,[si+1] 		; Green.				
	shr al,2            
	out dx,al 							
	mov al,[si] 		; Blue.				
	shr al,2            
	out dx,al 							
	add si,4 			; Point to next color.  (4 bytes for each color BGR + null)				
	loop CopyNextColor
	pop dx
	pop cx
	ret
endp CopyBmpPalette
proc ShowBMP 
; BMP graphics are saved upside-down.
; Read the graphic line by line (BmpRowSize lines in VGA format),
; displaying the lines from bottom to top.
	push cx
	mov ax, 0A000h
	mov es, ax
	mov cx,[BmpRowSize]
	mov ax,[BmpColSize] ; row size must dived by 4 so if it less we must calculate the extra padding bytes
	xor dx,dx
	mov si,4
	div si
	mov bp,dx
	mov dx,[BmpLeft]
@@NextLine:
	push cx
	push dx
	mov di,cx  ; Current Row at the small bmp (each time -1)
	add di,[BmpTop] ; add the Y on entire screen
	; next 5 lines  di will be  = cx*320 + dx , point to the correct screen line
	mov cx,di
	shl cx,6
	shl di,8
	add di,cx
	add di,dx	; small Read one line
	mov ah,3fh
	mov cx,[BmpColSize]  
	add cx,bp  ; extra  bytes to each row must be divided by 4
	mov dx,offset ScreenLineMax
	int 21h ; Copy one line into video memory
	cld ; Clear direction flag, for movsb
	mov cx,[BmpColSize]  
	mov si,offset ScreenLineMax
	rep movsb ; Copy line to the screen
	pop dx
	pop cx
	loop @@NextLine
	pop cx
	ret
endp ShowBMP 
proc  SetGraphic
	mov ax,13h   ; 320 X 200 
				 ;Mode 13h is an IBM VGA BIOS mode. It is the specific standard 256-color mode 
	int 10h
	ret
endp 	SetGraphic
 proc ClearScreen
	push 200	;left
	push 320
	push 0
	push 0
	push 0
	call rectpar
	ret
endp ClearScreen
END start