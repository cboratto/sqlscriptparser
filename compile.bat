flex sqlscriptparser.lex
bison -d sqlscriptparser.y
gcc sqlscriptparser.tab.c lex.yy.c -o sqlparser.exe