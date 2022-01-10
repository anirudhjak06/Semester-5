 
%{
#include<stdio.h>
#include<string.h>
int capital=0;
%}

%%

[\n]+ {fprintf(yyout, "\n\n\t");
	capital=0;
};
([\.]+[a-z]) {fprintf(yyout,"%c%c",yytext[0],yytext[1]-('a' - 'A'));};
[a-z] {
  if (capital==0){
    fprintf(yyout,"%c",yytext[0]-('a'-'A'));
  capital=1;}
  };
([a-zA-Z0-9\'\"]*) {
  if (capital==0 && yytext[0]>='a' && yytext[0]<='z'){
    yytext[0] =yytext[0]-('a' - 'A');
    capital=1;
  }
  else capital=1;	
  fprintf(yyout,"%s",yytext);
};
([\.]+[ ]+[a-z]) {fprintf(yyout,"%c %c",yytext[0],yytext[2]-('a' - 'A'));}


%%
  

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
