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
tempo1,tempo2,decla1,switch,estAllume;ici vous pouvez faire vos déclarations de variables
    endc

;*************************************************************************
;* Programme principal *
;*************************************************************************
    ORG 0x000 ; vecteur reset

START
    BANKSEL TRISA
    CLRF TRISA ;mettre les leds en input
    BSF TRISC,3
    BSF TRISC,2
    BANKSEL ANSEL
    CLRF ANSEL ;mettre en numérique
    CLRF STATUS
    CLRF PORTA
MAINLOOP
    BTFSS PORTC,3 ; PORTC,3 == 0 la prochaine ligne est lu SINON => NOP ( BOUTON ENFONCE )
    GOTO ALLUME ; premiere interaction, on allume !
    GOTO MAINLOOP
 
MAINLOOP2
    BTFSS PORTC,3 ; PORTC,3 == 1 la prochaine ligne est lu SINON => NOP ( BOUTON NON ENFONCE )
    GOTO ETEIND
    GOTO MAINLOOP2 ; on boucle et on atteind qu'on appuye pour eteindre
 
ETEIND
    BCF PORTA,7 ; on allume la led 7
    CALL INITWAIT ; on attend que le bouton est relaché - ANTI SPAMMEUR !
    GOTO MAINLOOP ; On retourne en position "j'attends qu'on appuye pour allumer"

ALLUME
    BSF PORTA,7 ; on allume la led 7
    CALL INITWAIT ; on attend que le bouton est relaché - ANTI SPAMMEUR !
    GOTO MAINLOOP2 ; On va en boucle 2 attendre qu'on appuye pour étindre !
 
INITWAIT
    MOVLW 0xFF ; stock 1111 1111 dans le registre de travail
    MOVWF tempo1  ; envoi le W dans la variable tempo1
    CALL WAIT
    RETURN
WAIT
    DECFSZ tempo1,1 ; décremente tempo1 et stock dans tempo1, skip la ligne suivante si 0
    GOTO $-1        ; reviens à la ligne précédente, cool non ? Ben ouai c'est trop cool !
    RETURN          ; Wait va donc attendre 256*2*200ns = 0.1024s
    END
