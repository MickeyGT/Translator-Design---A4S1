%{
#include <stdio.h>
#include <stdlib.h>
extern FILE *fp;
FILE * f1;
%}

%token INT VOID UINT
%token WHILE 
%token IF ELSE SWITCH CASE BREAK DEFAULT
%token NUM ID
%token INCLUDE
%right ASGN 
%left LOR
%left LAND
%left BOR
%left BXOR
%left BAND
%left EQ NE 
%left LE GE LT GT
%left '+' '-' 
%left '*' '/' '@'
%left '~'

%nonassoc IFX IFX1
%nonassoc ELSE
  
%%

pgmstart 			: TYPE ID '(' ')' STMTS
				;

STMTS 	: '{' STMT1 '}'|
				;
STMT1			: STMT  STMT1
				|
				;

STMT 			: STMT_DECLARE    //all types of statements
				| STMT_ASSGN  
				| STMT_IF
				| STMT_WHILE
				| STMT_SWITCH
				| ';'
				;

				

EXP 			: EXP LT{push();} EXP {codegen_logical();}
				| EXP LE{push();} EXP {codegen_logical();}
				| EXP GT{push();} EXP {codegen_logical();}
				| EXP GE{push();} EXP {codegen_logical();}
				| EXP NE{push();} EXP {codegen_logical();}
				| EXP EQ{push();} EXP {codegen_logical();}
				| EXP '+'{push();} EXP {codegen_algebric();}
				| EXP '-'{push();} EXP {codegen_algebric();}
				| EXP '*'{push();} EXP {codegen_algebric();}
				| EXP '/'{push();} EXP {codegen_algebric();}
                                | EXP {push();} LOR EXP {codegen_logical();}
				| EXP {push();} LAND EXP {codegen_logical();}
				| EXP {push();} BOR EXP {codegen_logical();}
				| EXP {push();} BXOR EXP {codegen_logical();}
				| EXP {push();} BAND EXP {codegen_logical();}
				| '(' EXP ')'
				| ID {check();push();}
				| NUM {push();}
				;


STMT_IF 			: IF '(' EXP ')'  {if_label1();} STMTS ELSESTMT 
				;
ELSESTMT		: ELSE {if_label2();} STMTS {if_label3();}
				| {if_label3();}
				;

STMT_SWITCH		: SWITCH '(' EXP ')' {switch_start();} '{' SWITCHBODY '}'
				;
SWITCHBODY		: CASES {switch_end();}    
				| CASES DEFAULTSTMT {switch_end();}
				;

CASES 			: CASE NUM {switch_case();} ':' SWITCHEXP BREAKSTMT
				| 
				;
BREAKSTMT		: BREAK {switch_break();} ';' CASES
				|{switch_nobreak();} CASES 
				;

DEFAULTSTMT 	: DEFAULT {switch_default();} ':' SWITCHEXP DE  
				;

DE 				: BREAK {switch_break();}';'
				|
				;


SWITCHEXP 		: STMTS
				| STMT
				;


STMT_WHILE		:{while_start();} WHILE '(' EXP ')' {while_rep();} WHILEBODY  
				;

WHILEBODY		: STMTS {while_end();}
				| STMT {while_end();}
				;

STMT_DECLARE 	: TYPE {setType();}  ID {STMT_DECLARE();} IDS   //setting type for that line
				;


IDS 			: ';'
				| ','  ID {STMT_DECLARE();} IDS 
				;


STMT_ASSGN		: ID {push();} ASGN {push();} EXP {codegen_assign();} ';'
				;


TYPE			: INT
				| VOID
				| UINT
				;

%%
