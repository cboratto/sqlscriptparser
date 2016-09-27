%{
 #include "sqlscriptparser.tab.h"  
%}
%option noyywrap
%%
[ ]*([Dd][Aa][Tt]|[Cc][Oo][Dd]|[Dd][Ee][Ss]|[Ii][Nn][Dd]|[Jj][Ss][Oo][Nn]|[Xx][Mm][Ll]|[Ii][Dd][Tt]|[Nn][Uu][Mm]|[Ff][Ll][Gg]|[Nn][Aa][Mm])\_[a-zA-Z0-9\_]+ 						{ yylval.sval = strdup(yytext); return COLUMN;}
[Cc][Rr][Ee][Aa][Tt][Ee][ ]+[Tt][Aa][Bb][Ll][Ee]									{ yylval.sval = strdup(yytext); return CREATE_TABLE;}
[Cc][Rr][Ee][Aa][Tt][Ee][ ]+[Ii][Nn][Dd][Ee][Xx]									{ yylval.sval = strdup(yytext); return CREATE_INDEX;}
[Aa][Ll][Tt][Ee][Rr][ ]+[Tt][Aa][Bb][Ll][Ee]										{ yylval.sval = strdup(yytext); return ALTER_TABLE;}
[A-Za-z]+\_[Aa][Dd][Mm]\.[a-zA-Z\_0-9]+					    						{ yylval.sval = strdup(yytext); return OWNER_OBJECT;}
[A-Za-z\_]+\_[Ff][Kk]																{ yylval.sval = strdup(yytext); return FK_NAME;}
[A-Za-z\_]+\_[Pp][Kk]																{ yylval.sval = strdup(yytext); return PK_NAME;}
[A-Za-z\_]+\_[Uu][Kk]																{ yylval.sval = strdup(yytext); return UK_NAME;}
[Ff][Oo][Rr][Ee][Ii][Gg][Nn][ ]+[Kk][Ee][Yy]										{ yylval.sval = strdup(yytext); return FK;}
[Pp][Rr][Ii][Mm][Aa][Rr][Yy][ ]+[Kk][Ee][Yy]										{ yylval.sval = strdup(yytext); return PK;}
[A-Za-z\_]+\_[Cc][Kk][0-9]*															{ yylval.sval = strdup(yytext); return CHECK_NAME;}
[ ]+[Cc][Hh][Ee][Cc][Kk][ ]*														{ yylval.sval = strdup(yytext); return CHECK;}
[Aa][Dd][Dd][ ]+[Cc][Oo][Nn][Ss][Tt][Rr][Aa][Ii][Nn][Tt]							{ yylval.sval = strdup(yytext); return ADD_CONSTRAINT;}
[Dd][Rr][Oo][Pp][ ]+[Cc][Oo][Nn][Ss][Tt][Rr][Aa][Ii][Nn][Tt]						{ yylval.sval = strdup(yytext); return DROP_CONSTRAINT;}
[Cc][Rr][Ee][Aa][Tt][Ee][ ]+[Ss][Ee][Qq][Uu][Ee][Nn][Cc][Ee]						{ yylval.sval = strdup(yytext); return CREATE_SEQUENCE;}
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
[A-Z0-9a-záéíóúãõäëïöüçàèìòùÁÉÍÓÚÃÕÄËÏÖÜÇÀÈÌÒÙ\[\]\|]*							/*ignore*/
%%

