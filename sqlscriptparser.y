%{
#include<stdio.h>
#include<string.h>
#include<stdlib.h>
#include <unistd.h>
void yyerror(char *); 
extern char * yytext;

//Referencia externa
extern FILE * yyin;
//Apontamento para arquivo
char fullfilename[2048];

//Print na tela o comando
int printOnScreen=0;
//Realizar o append
int appendStmt=0;

//Primeira vez a imprimir script validador
int primeiraVez=1;

void writeStmt(char *stmt, char *tipoStmt);
%}

%union {
	char *sval;
}

%token <sval> OWNER_OBJECT

%token <sval> COMANDO
%token <sval> CREATE_TABLE
%token <sval> CREATE_INDEX
%token <sval> ALTER_TABLE
%token <sval> FK
%token <sval> PK
%token <sval> UK
%token <sval> FK_NAME
%token <sval> PK_NAME
%token <sval> UK_NAME
%token <sval> ADD_CONSTRAINT
%token <sval> DROP_CONSTRAINT
%token <sval> COLUMN
%token <sval> CREATE_SEQUENCE


%token <sval> CHECK
%token <sval> CHECK_NAME

%token FIM_COMANDO
%start linhas

%%
linhas : 
	| linhas instrucao
 ;

constraint :
	| FK
	| PK
	| UK
	;
	

instrucao: CREATE_TABLE OWNER_OBJECT FIM_COMANDO  {   													  
													  char *owner;
													  char *object;
													  owner = strtok ($2,".");
													  object = strtok (NULL, ".");
													  char str[1024];
													  strcpy(str,"select '");
													  strcat(str, object);
													  strcat(str, "' as obj, case count(1) when 1 then 'ok' else 'error' end as status from dba_tables t where t.owner=upper('");
													  strcat(str,owner);
													  strcat(str,"') and t.table_name=upper('");
													  strcat(str,object);
													  strcat(str,"') union all");													  													  
													  if (printOnScreen) {
														printf("\n--CREATE TABLE\n%s\n",str);
													  }				
													  if (appendStmt) {
														 writeStmt(str,"--CREATE TABLE");
													  }													  
														
													  }
	| ALTER_TABLE OWNER_OBJECT ADD_CONSTRAINT CHECK_NAME CHECK COLUMN FIM_COMANDO { 
												  char *owner;
												  char *object;
												  owner = strtok ($2,".");
												  char str[1024];
												  strcpy(str,"select '");
												  strcat(str,$4);												 
												  strcat(str,"' as obj, case count(1) when 1 then 'ok' else 'error' end from dba_constraints t where t.owner=upper('");
												  strcat(str,owner);
												  strcat(str,"') and t.constraint_name=upper('");
												  strcat(str,$4);
												  strcat(str,"') union all ");												  
												  if (printOnScreen) {
													 printf("\n--ADD CHECK CONSTRAINT\n%s\n",str);
												  }				
												  if (appendStmt) {
													 writeStmt(str,"--ADD CHECK CONSTRAINT");
												  }
												  
												  }		
												  
	| ALTER_TABLE OWNER_OBJECT DROP_CONSTRAINT CHECK_NAME FIM_COMANDO {}		
													  
	| CREATE_INDEX OWNER_OBJECT OWNER_OBJECT COLUMN FIM_COMANDO      { 
												  char *owner;
												  char *object;
												  owner = strtok ($2,".");
												  object = strtok (NULL, ".");		
												  char str[1024];
												  strcpy(str,"select '");
												  strcat(str,object);												  
												  strcat(str,"' as obj, case count(1) when 1 then 'ok' else 'error' end as status from dba_indexes t where t.owner=upper('");
												  strcat(str,owner);
												  strcat(str,"') and t.index_name=upper('");
												  strcat(str,object);
												  strcat(str,"') union all ");												  
												  if (printOnScreen) {
													 printf("\n--CREATE INDEX\n%s\n",str);
												  }
												  if (appendStmt) {
													 writeStmt(str,"--CREATE INDEX");
												  }
												  
												  }
	| ALTER_TABLE OWNER_OBJECT ADD_CONSTRAINT FK_NAME  constraint COLUMN OWNER_OBJECT COLUMN FIM_COMANDO { 
												  char *owner;
												  char *object;
												  owner = strtok ($2,".");
												  char str[1024];
												  strcpy(str,"select '");
												  strcat(str,$4);
												  strcat(str,"' obj, case count(1) when 1 then 'ok' else 'error' end as status from dba_constraints t where t.owner=upper('");
												  strcat(str,owner);
												  strcat(str,"') and t.constraint_name=upper('");
												  strcat(str,$4);
												  strcat(str,"') union all ");												  
												  if (printOnScreen) {
													 printf("\n--ADD CONSTRAINT FK\n%s\n",str);
												  }
												  if (appendStmt) {
													 writeStmt(str,"--ADD CONSTRAINT FK");
												  }
												  
												  
												  }

	| ALTER_TABLE OWNER_OBJECT ADD_CONSTRAINT PK_NAME constraint COLUMN FIM_COMANDO { 
												  char *owner;
												  char *object;
												  owner = strtok ($2,".");
												  char str[1024];
												  strcpy(str,"select '");
												  strcat(str,$4);
												  strcat(str,"' as obj, case count(1) when 1 then 'ok' else 'error' end as status from dba_constraints t where t.owner=upper('");
												  strcat(str,owner);
												  strcat(str,"') and t.constraint_name=upper('");
												  strcat(str,$4);
												  strcat(str,"') union all ");												  
												  if (printOnScreen) {
													 printf("\n--ADD CONSTRAINT PK\n%s\n",str);
												  }	
												  if (appendStmt) {
													 writeStmt(str,"--ADD CONSTRAINT PK");
												  }
												  
												  }
												  
	| ALTER_TABLE OWNER_OBJECT ADD_CONSTRAINT UK_NAME constraint COLUMN FIM_COMANDO { 
												  char *owner;
												  char *object;
												  owner = strtok ($2,".");
												  char str[1024];
												  strcpy(str,"select '");
												  strcat(str,$4);
												  strcat(str,"' as obj, case count(1) when 1 then 'ok' else 'error' end as status from dba_constraints t where t.owner=upper('");
												  strcat(str,owner);
												  strcat(str,"') and t.constraint_name=upper('");
												  strcat(str,$4);
												  strcat(str,"') union all ");												  
												  if (printOnScreen) {
													 printf("\n--ADD CONSTRAINT UK\n%s\n",str);
												  }	
												  if (appendStmt) {
													writeStmt(str,"--ADD CONSTRAINT UK");  
												  }
												  
												  }

	| ALTER_TABLE OWNER_OBJECT COLUMN FIM_COMANDO { char *owner;
												    char *object;
												  owner = strtok ($2,".");
												  object = strtok (NULL, ".");
												  char str[1024];
												  strcpy(str,"select '");
												  strcat(str,object);
												  strcat(str,"-");
												  strcat(str,$3);												  
												  strcat(str,"' as obj, case count(1) when 1 then 'ok' else 'error' end from dba_tab_columns t where t.owner=upper('");
												  strcat(str,owner);
												  strcat(str,"') and t.table_name=upper('");
												  strcat(str,object);
												  strcat(str,"') and t.column_name=upper(trim('");
												  strcat(str,$3);
												  strcat(str,"')) union all ");
												  if (printOnScreen) {
													 printf("\n--ADD COLUMN\n%s\n",str);
												  }			
												  if (appendStmt) {
													  writeStmt(str,"--ADD COLUMN");
												  }
												  

												  }
	
	| ALTER_TABLE OWNER_OBJECT COLUMN COLUMN FIM_COMANDO { char *owner;
												    char *object;
												  owner = strtok ($2,".");
												  object = strtok (NULL, ".");
												  char str[1024];
												  strcpy(str,"select '");
												  strcat(str,object);
												  strcat(str,"-");
												  strcat(str,$3);												  
												  strcat(str,"' as obj, case count(1) when 1 then 'ok' else 'error' end from dba_tab_columns t where t.owner=upper('");
												  strcat(str,owner);
												  strcat(str,"') and t.table_name=upper('");
												  strcat(str,object);
												  strcat(str,"' and t.column_name=upper(trim('");
												  strcat(str,$3);
												  strcat(str,"')) union all ");												  
												  if (printOnScreen) {
													 printf("\n--RENAME COLUMN\n%s\n",str);
												  }
												  if (appendStmt) {
													 writeStmt(str,"--RENAME COLUMN");
												  }
												  
												  }
	
										 
	| CREATE_SEQUENCE OWNER_OBJECT FIM_COMANDO { 
												  char *owner;
												  char *object;
												  owner = strtok ($2,".");
												  object = strtok (NULL, ".");
												  char str[1024];
												  strcpy(str,"select '");
												  strcat(str,object);
												  strcat(str,"' as obj, case count(1) when 1 then 'ok' else 'error' end from dba_sequences t where t.sequence_owner=upper('");
												  strcat(str,owner);
												  strcat(str,"') and t.sequence_name=upper('");
												  strcat(str,object);
												  strcat(str,"') union all ");												  
												  if (printOnScreen) {
													 printf("\n--CREATE SEQUENCE\n%s\n",str);
												  }
												  if (appendStmt) {
													 writeStmt(str,"--CREATE SEQUENCE");
												  }
												  
												  }												  

												  
	| FIM_COMANDO 					{} 
	| OWNER_OBJECT 					{}
	| FK_NAME						{}		
	| CHECK_NAME					{}
	| COLUMN						{}	
//
 ;

%%

int main(int argc, char **argv)
{

	//Copiando	
	int i;	
	for (i=1; i < argc; i++) {	
		if (strcmp("-p",argv[i])==0 ) {
			printOnScreen=1;
		} else if (strcmp("-a",argv[i])==0 ) {
			appendStmt=1;
		}else {
			strcpy(fullfilename, argv[i]);	
		}		
	}

	yyin = fopen(fullfilename, "r");
	return yyparse();
}

/*********************************************
	Funcao de append
*********************************************/
void writeStmt(char *stmt, char *tipoStmt) {	

   	FILE * fp;		
	fp = fopen(fullfilename, "a");
	
	if (primeiraVez==1) {
		fprintf(fp, "\n/*********************************\n\tSCRIPT VALIDACAO\n*********************************/\n",tipoStmt, stmt);
		primeiraVez=0;
	}
	fprintf(fp, "%s\n%s\n",tipoStmt, stmt);
	fclose(fp);
		
}

/* função usada pelo bison para dar mensagens de erro */
void yyerror(char *msg)
{
 fprintf(stderr, "\ERRO: %s \n", msg);
}
