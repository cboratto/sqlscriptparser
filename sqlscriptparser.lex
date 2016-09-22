%{
 #include "sqlscriptparser.tab.h"  
%}
%option noyywrap
%%
[ ]*(DAT|COD|DES|IND|JSON|XML|IDT|NUM|FLG|NAM)\_[A-Z0-9\_]+ { yylval.sval = strdup(yytext); return COLUMN;}
"CREATE TABLE"									{ yylval.sval = strdup(yytext); return CREATE_TABLE;}
"CREATE INDEX"									{ yylval.sval = strdup(yytext); return CREATE_INDEX;}
"ALTER TABLE"									{ yylval.sval = strdup(yytext); return ALTER_TABLE;}
[A-Z]+\_ADM\.[A-Z\_0-9]+					    { yylval.sval = strdup(yytext); return OWNER_OBJECT;}
[A-Z\_]+\_FK									{ yylval.sval = strdup(yytext); return FK_NAME;}
[A-Z\_]+\_PK									{ yylval.sval = strdup(yytext); return PK_NAME;}
[A-Z\_]+\_UK									{ yylval.sval = strdup(yytext); return UK_NAME;}
"FOREIGN KEY"									{ yylval.sval = strdup(yytext); return FK;}
"PRIMARY KEY"									{ yylval.sval = strdup(yytext); return PK;}
[A-Z\_]+\_CK[0-9]*								{ yylval.sval = strdup(yytext); return CHECK_NAME;}
[ ]+CHECK[ ]*									{ yylval.sval = strdup(yytext); return CHECK;}
"ADD CONSTRAINT"								{ yylval.sval = strdup(yytext); return ADD_CONSTRAINT;}
"CREATE SEQUENCE"								{ yylval.sval = strdup(yytext); return CREATE_SEQUENCE;}
"\n" 											{return FIM_COMANDO;} 
"("												/*ignore*/
")"												{}
"/"												{}
"'"												{}
"-"												{}
"_"												{}
";"												{}
"="												{}
":"												{}
">"												{}
"<"												{}
"."												{}
"*"												{}
","												{}
"+" 											{}
"?" 											{}
[A-Z0-9a-záéíóúãõäëïöüçàèìòùÁÉÍÓÚÃÕÄËÏÖÜÇÀÈÌÒÙ\[\]]*							/*ignore*/
%%

