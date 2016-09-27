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
													  printf("\n--CREATE TABLE\n%s\n",str);

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
												  printf("\n--ADD CHECK CONSTRAINT\n%s\n",str);		
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
												  printf("\n--CREATE INDEX\n%s\n",str);
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
												  printf("\n--ADD CONSTRAINT FK\n%s\n",str);
												  
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
												  printf("\n--ADD CONSTRAINT PK\n%s\n",str);
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
												  printf("\n--ADD CONSTRAINT UK\n%s\n",str);
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
												  printf("\n--ADD COLUMN\n%s\n",str);

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
												  printf("\n--RENAME COLUMN\n%s\n",str);
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
												  printf("\n--CREATE SEQUENCE\n%s\n",str);											  
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
 fprintf(stderr, "\ERRO: %s \n", msg);
}
