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
# Passa arquivo como parametro
sqlparser /fool/bar/file.txt

# Printa na tela os comandos de validação
sqlparser /fool/bar/file.txt -p

# Append dos comandos no arquivo passado como parametro
sqlparser /fool/bar/file.txt -a
```
