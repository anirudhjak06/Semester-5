%{
#include<stdio.h>
#include<stdlib.h>
#include<string.h>
char *months[]={"January", "Febuary", "March", "April", "May", "June", "July", "August","September", "October","November","December"};
int flag=0,dateflag=0,monflag=0,monthNumber=-1,date=0;
%}

/* Rules Section*/

%%
[a-z] {
  if (flag==0){
    fprintf(yyout,"%c",yytext[0]-('a'-'A'));
  flag=1;}
  };
([\.]+[a-z]) {fprintf(yyout,"%c%c",yytext[0],yytext[1]-('a' - 'A'));};
([\.]+[ ]+[a-z]) {fprintf(yyout,"%c %c",yytext[0],yytext[2]-('a' - 'A'));};
([0-9][0-9])\-([0-9][0-9])\-([0-9][0-9][0-9][0-9]) {
  fprintf(yyout,"%s %c%c, %c%c%c%c",months[(int)((yytext[3])-48)*10+(int)((yytext[4])-49)],yytext[0],yytext[1],yytext[6],yytext[7],yytext[8],yytext[9]);
  };
([0-9])\-([0-9][0-9])\-([0-9][0-9][0-9][0-9]) {
  fprintf(yyout,"%s 0%c, %c%c%c%c",months[(int)((yytext[2])-48)*10+(int)((yytext[3])-49)],yytext[0],yytext[5],yytext[6],yytext[7],yytext[8]);
  };
([0-9][0-9])\-([0-9])\-([0-9][0-9][0-9][0-9]) {
  fprintf(yyout,"%s %c%c, %c%c%c%c",months[(int)yytext[3]-49],yytext[0],yytext[1],yytext[5],yytext[6],yytext[7],yytext[8]);
  };
([0-9])\-([0-9])\-([0-9][0-9][0-9][0-9]) {
fprintf(yyout, "%s 0%c, %c%c%c%c",months[(int)(yytext[2])-49],yytext[0],yytext[4],yytext[5],yytext[6],yytext[7]);};

([0-9][0-9])\-([0-9][0-9])\-([0-9][0-9]) {
  fprintf(yyout,"%s %c%c, %c%c",months[(int)((yytext[3])-48)*10+(int)((yytext[4])-49)],yytext[0],yytext[1],yytext[6],yytext[7]);
  };
([0-9])\-([0-9][0-9])\-([0-9][0-9]) {
  fprintf(yyout,"%s 0%c, %c%c",months[(int)((yytext[2])-48)*10+(int)((yytext[3])-49)],yytext[0],yytext[5],yytext[6]);
  };
([0-9][0-9])\-([0-9])\-([0-9][0-9]) {
  fprintf(yyout,"%s %c%c, %c%c",months[(int)yytext[3]-49],yytext[0],yytext[1],yytext[5],yytext[6]);
  };
([0-9])\-([0-9])\-([0-9][0-9]) {
fprintf(yyout, "%s 0%c, %c%c%c",months[(int)(yytext[2])-49],yytext[0],yytext[4],yytext[5],yytext[6]);}

([0-9][0-9])+("st"|"nd"|"rd"|"th") {
  date=(int)((yytext[0])-48)*10+(int)((yytext[1])-48);
  if (monflag==1)
  {
    fprintf(yyout,"%s %d,",months[monthNumber],date);
  }
  dateflag=1;
};
"Jan"|"Feb"|"Mar"|"Apr"|"May"|"Jun"|"Jul"|"Aug"|"Sep"|"Oct"|"Nov"|"Dec" {
  for (int i=0;i<12;i++){
    if (yytext[0]==months[i][0] && yytext[1]==months[i][1] && yytext[2]==months[i][2]){
      monthNumber=i;
    }
  }
  if (dateflag==1){
    fprintf(yyout,"%s %d,",months[monthNumber],date);
  }
  monflag=1;
};

([a-zA-Z0-9\'\"]*) {
  if (flag==0 && yytext[0]>='a' && yytext[0]<='z'){
    yytext[0] =yytext[0]-('a' - 'A');
    flag=1;
  }
  else flag=1;
  if (dateflag==1 && monflag==1){
    if (yytext[0]<'0' || yytext[0]>'9'){
    fprintf(yyout,"2021 ");
    }
    dateflag=0;
    monflag=0;
  }
  fprintf(yyout,"%s",yytext);
  }
[\n]+   {fprintf(yyout, "\n\n\t");
flag=0;
}
%%


int main()
{   
	extern FILE *yyin, *yyout;
    yyin = fopen("input.txt", "r");
    yyout = fopen("output.txt", "w");
    yylex (); 

    
	return 0;
}
int yywrap()
{
    return 1;
}




