%{
 #include "sqlscriptparser.tab.h"  
%}
%option noyywrap
%%
"("												/*ignore*/
[ ]*(DAT|COD|DES|IND|JSON|XML|IDT|NUM|FLG|NAM)\_[A-Z0-9\_]+ { yylval.sval = strdup(yytext); return COLUMN;}
"CREATE TABLE"									{ yylval.sval = strdup(yytext); return CREATE_TABLE;}
"CREATE INDEX"									{ yylval.sval = strdup(yytext); return CREATE_INDEX;}
"ALTER TABLE"									{ yylval.sval = strdup(yytext); return ALTER_TABLE;}
[A-Z]+\_ADM\.[A-Z\_0-9]+					    { yylval.sval = strdup(yytext); return OWNER_OBJECT;}
[A-Z\_]+\_FK									{ yylval.sval = strdup(yytext); return FK_NAME;}
"FOREIGN KEY"									{ yylval.sval = strdup(yytext); return FK;}
[A-Z\_]+\_CK[0-9]*								{ yylval.sval = strdup(yytext); return CHECK_NAME;}
[ ]+CHECK[ ]*									{ yylval.sval = strdup(yytext); return CHECK;}
"ADD CONSTRAINT"								{ yylval.sval = strdup(yytext); return ADD_CONSTRAINT;}
"\n" 											{return FIM_COMANDO;} 
")"												{}
"/"												{}
"'"												{}
"-"												{}
";"												{}
"="												{}
":"												{}
">"												{}
"<"												{}
"."												{}
"*"												{}
[\sA-Z0-9\_a-z\(\)\,]*							/*ignore*/
%%

