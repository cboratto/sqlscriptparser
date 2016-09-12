%{
#include<stdio.h>
#include<string.h>
#include<stdlib.h>
#include <unistd.h>
void yyerror(char *); 
extern char * yytext;

void changedir(char *);
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
%token <sval> FK_NAME
%token <sval> ADD_CONSTRAINT
%token <sval> COLUMN

%token <sval> CHECK
%token <sval> CHECK_NAME

%token FIM_COMANDO
%start linhas

%%
linhas : 
	| linhas instrucao
 ;

instrucao: CREATE_TABLE OWNER_OBJECT FIM_COMANDO  {   
													  char *owner;
													  char *object;
													  owner = strtok ($2,".");
													  object = strtok (NULL, ".");
													  char str[1024];
													  strcpy(str,"select case count(1) when 1 then 'ok' else 'error' end from dba_tables t where t.owner='");
													  strcat(str,owner);
													  strcat(str,"' and t.table_name='");
													  strcat(str,object);
													  strcat(str,"';");
													  printf("\n--CREATE TABLE\n%s\n",str);
													  //printf("select case count(1) when 1 then 'ok' else 'error' end from dba_tables t where t.owner='%s' and t.table_name='%s';\n",owner,object); 
													  }
													  
	| CREATE_INDEX OWNER_OBJECT OWNER_OBJECT COLUMN FIM_COMANDO      { 
												  char *owner;
												  char *object;
												  owner = strtok ($2,".");
												  object = strtok (NULL, ".");		
												  char str[1024];
												  strcpy(str,"select case count(1) when 1 then 'ok' else 'error' end from dba_indexes t where t.owner='");
												  strcat(str,owner);
												  strcat(str,"' and t.index_name='");
												  strcat(str,object);
												  strcat(str,"';");
												  printf("\n--CREATE INDEX\n%s\n",str);
												  //printf("select case count(1) when 1 then 'ok' else 'error' end from dba_indexes t where t.owner='%s' and t.index_name='%s';\n",owner,object); 
												  }
	| ALTER_TABLE OWNER_OBJECT ADD_CONSTRAINT FK_NAME  FK COLUMN OWNER_OBJECT COLUMN FIM_COMANDO { 
												  char *owner;
												  char *object;
												  owner = strtok ($2,".");
												  char str[1024];
												  strcpy(str,"select case count(1) when 1 then 'ok' else 'error' end from dba_constraints t where t.owner='");
												  strcat(str,owner);
												  strcat(str,"' and t.constraint_name='");
												  strcat(str,$4);
												  strcat(str,"';");
												  printf("\n--ADD CONSTRAINT FK\n%s\n",str);
												  //printf("select case count(1) when 1 then 'ok' else 'error' end from dba_constraints t where t.owner='%s' and t.constraint_name='%s';\n",owner,$4);
												  }

	| ALTER_TABLE OWNER_OBJECT COLUMN FIM_COMANDO { char *owner;
												    char *object;
												  owner = strtok ($2,".");
												  object = strtok (NULL, ".");
												  char str[1024];
												  strcpy(str,"select case count(1) when 1 then 'ok' else 'error' end from dba_tab_columns t where t.owner='");
												  strcat(str,owner);
												  strcat(str,"' and t.table_name='");
												  strcat(str,object);
												  strcat(str,"' and t.column_name='");
												  strcat(str,$3);
												  strcat(str,"';");
												  printf("\n--ADD COLUMN\n%s\n",str);
												  //printf("select case count(1) when 1 then 'ok' else 'error' end from dba_tab_columns t where t.owner='%s' and t.table_name='%s' and t.column_name='%s';\n",owner,object,$3);
												  }
	
	| ALTER_TABLE OWNER_OBJECT ADD_CONSTRAINT CHECK_NAME CHECK COLUMN FIM_COMANDO { 
												  char *owner;
												  char *object;
												  owner = strtok ($2,".");
												  char str[1024];
												  strcpy(str,"select case count(1) when 1 then 'ok' else 'error' end from dba_constraints t where t.owner='");
												  strcat(str,owner);
												  strcat(str,"' and t.constraint_name='");
												  strcat(str,$4);
												  strcat(str,"';");
												  printf("\n--ADD CHECK CONSTRAINT\n%s\n",str);
												  //printf("select case count(1) when 1 then 'ok' else 'error' end from dba_constraints t where t.owner='%s' and t.constraint_name='%s';\n",owner,$4);
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
 
 return yyparse();
}

/* função usada pelo bison para dar mensagens de erro */
void yyerror(char *msg)
{
 fprintf(stderr, "erro: %s \n", msg);
}
