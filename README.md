##SQL Script Parser
 
Mini project built under flex-bison to generate script validation for Oracle DDL.

## Compile

```
flex sqlscriptparser.lex
bison -d sqlscriptparser.y
gcc sqlscriptparser.tab.c lex.yy.c -o sqlparser
```

##Documentation

Redirect stdout to your bin so it can process caracter stream.

```
sqlparser < file.txt
```
