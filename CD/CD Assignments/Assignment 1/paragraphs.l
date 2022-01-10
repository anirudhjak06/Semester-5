 
%{
#include<stdio.h>
#include<string.h>
%}
  
/* Rule: whenever one or more 
newline is encounterd, add two new lines and a tab since it's a paragraph*/
%%
[\n]+   {fprintf(yyout, "\n\n\t");}
.       { fprintf(yyout, "%s", yytext); }
%%
  

  
// driver code 
int main()
{
    extern FILE *yyin, *yyout;
    yyin = fopen("Input.txt", "r");
    yyout = fopen("Output.txt", "w");
    yylex();
    return 0;
}

int yywrap()
{
    return 1;
}