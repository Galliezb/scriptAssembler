;* Projet : Labo XXX *
;************************************************************************
;* Nom de fichier: Labo XXX *
;* Date: XX-XX-XXXX *
;* *
;* Auteur: YY *
;* Haute Ecole Louvain en Hainaut *
;************************************************************************
;* Fichiers nécessaires: aucun *
;************************************************************************
;* Notes: *
;************************************************************************
    list p=16F887, f=INHX8M ; directive pour definir le processeur
    list c=90, n=60 ; directives pour le listing
    #include <p16F887.inc> ; incorporation variables spécifiques
    errorlevel -302 ; pas d'avertissements de bank
    errorlevel -305 ; pas d'avertissements de fdest

    __CONFIG _CONFIG1, _LVP_OFF & _WDT_OFF & _INTOSCIO
    __CONFIG _CONFIG2, _IESO_OFF & _FCMEN_OFF

;*************************************************************************
;* Définitions et Variables *
;*************************************************************************
    cblock 0x020
tempo1,etatled;ici vous pouvez faire vos déclarations de variables
    endc

;*************************************************************************
;* Programme principal *
;*************************************************************************
    ORG 0x000 ; vecteur reset

START
    BANKSEL TRISA   ; Selectione la banque ou TRISA se trouve
    CLRF TRISA      ; mettre le port A en OUTPUT
    BSF TRISC,3     ; On met le bouton 3 ( celui de gauche ) en INPUT
    BANKSEL ANSEL   ; select bank 4
    CLRF ANSEL      ; mettre en numérique
    CLRF STATUS     ; select bank 0
    CLRF PORTA      ; assure que les leds sont éteintes
    MOVLW 0x00      ; préparation init etatled
    MOVWF etatled,1 ; mets 0000 0000 dans la variable etatled => ETAT LED ETEINTE
    
MAINLOOP
    BTFSC etaled,0  ; Bool == 0 donc on skip pas et on lance la vérification allumage
    GOTO $+3        ; avance de 3 lignes
    BTFSS PORTC,3   ; PORTC,3 == 0 la prochaine ligne est lu SINON => NOP ( BOUTON ENFONCE )
    GOTO ALLUME     ; premiere interaction, on allume !
    BTFSS etatled,0 ; Bool == 1 donc on skip pas pour vérifier l'action d'éteindre
    GOTO $+3        ; avance de 3 lignes
    BTFSS PORTC,3   ; PORTC,3 == 1 la prochaine ligne est lu SINON => NOP ( BOUTON ENFONCE )
    GOTO ETEIND     ; se rendre au label eteind
    BTFSS PORTC,2   ; BOUTON 2 enfoncé, on allume la led !   
    GOTO PUSHALLUME ; on va allumer la led
    BTFSC PORTC,2   ; BOUTON 2 relaché, on éteind la led
    GOTO PUSHETEIND ; On éteind la led
    GOTO MAINLOOP   ; on boucle mainloop

PUSHETEIND
    BCF PORTA,7     ; on éteind la led
    GOTO MAINLOOP   ; on retourne sur mainloop

PUSHALLUME
    BSF PORTA,7     ; on allume la led
    GOTO MAINLOOP   ; on retourne sur mainloop

ETEIND
    BCF PORTA,7     ; on eteind la led 7
    BCF etatled,0   ; etat variable etaled = 0000 0000 => LED ETEINTE
    CALL WAIT       ; on attend que le bouton est relaché - ANTI SPAMMEUR !
    BTFSS PORTC,3   ; Si bouton toujours ENFONCE alors on attends encore ! Sinon on skip
    GOTO $-2        ; recule de 2 lignes
    GOTO MAINLOOP   ; On retourne en position "j'attends qu'on appuye pour allumer"

ALLUME
    BSF PORTA,7     ; on allume la led 7
    BSF etatled,0   ; etat variable etaled = 0000 0001 => LED ALLUME
    CALL WAIT       ; on attend que le bouton est relaché - ANTI SPAMMEUR !
    BTFSS PORTC,3   ; Si bouton toujours ENFONCE alors on attends encore ! Sinon on skip
    GOTO $-2        ; recul de 2 lignes
    GOTO MAINLOOP   ; On va en boucle 2 attendre qu'on appuye pour étindre !
 
WAIT
    MOVLW 0xFF      ; stock 1111 1111 dans le registre de travail
    MOVWF tempo1    ; envoi le W dans la variable tempo1
    DECFSZ tempo1,1 ; décremente tempo1 et stock dans tempo1, skip la ligne suivante si 0
    GOTO $-1        ; reviens à la ligne précédente, cool non ? Ben ouai c'est trop cool !
    RETURN          ; retourne et continue après le call qui t'as envoyé ici
    END             ; c'est fini ! on a réussi ! félicitation à toutes et tous !
