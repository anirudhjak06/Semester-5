/* This Assignment has been done by Anirudh, Hardik and Himesh */
 

/*Declaration/Definition section */ 

%{
#include<stdio.h>
#include<string.h>
#include<stdlib.h>
int capital=0,dates=0,mo=0,m_count=-1,counter=0;
char *calendar[]={"January", "Febuary", "March", "April", "May", "June", "July", "August","September", "October","November","December"};

%}

/* Transition Rules Section*/

%%

[\n]+ {
	fprintf(yyout, "\n\n\t");
	capital=0;
};

([\.]+[a-z]) {
	fprintf(yyout,"%c%c",yytext[0],yytext[1]-('a' - 'A'));
};

([\.]+[ ]+[a-z]) {
	fprintf(yyout,"%c %c",yytext[0],yytext[2]-('a' - 'A'));
};

[a-z] {
  	if (capital==0)
	{
    		fprintf(yyout,"%c",yytext[0]-('a'-'A'));
  		capital=1;
	}
};

([0-9][0-9])+("st"|"nd"|"rd"|"th") {
  	counter=(int)((yytext[0])-48)*10+(int)((yytext[1])-48);
  	if (mo==1)
  	{
    		fprintf(yyout,"%s %d,",calendar[m_count],counter);
  	}
  	dates=1;
};


"Jan"|"Feb"|"Mar"|"Apr"|"May"|"Jun"|"Jul"|"Aug"|"Sept"|"Oct"|"Nov"|"Dec" {
  	for (int k=0;k<12;k++)
	{
    		if (yytext[0]==calendar[k][0] && yytext[1]==calendar[k][1] && yytext[2]==calendar[k][2])
		{
      			m_count=k;
    		}
  	}
  	if (dates==1)
	{
    		fprintf(yyout,"%s %d,",calendar[m_count],counter);
  	}
  	mo=1;
};

([a-zA-Z0-9\'\"]*) {
  	if (capital==0 && yytext[0]>='a' && yytext[0]<='z')
	{
    		yytext[0] =yytext[0]-('a' - 'A');
    		capital=1;
  	}
  	else 
	{
		capital=1;
	}
	if (dates==1 && mo==1)
	{
    		if (yytext[0]<'0' || yytext[0]>'9')
		{
    			fprintf(yyout,"2021 ");
    		}
    		dates=0;
    		mo=0;
  	}	
  	fprintf(yyout,"%s",yytext);
};



([0-9])\-([0-9][0-9])\-([0-9][0-9]) {
	fprintf(yyout,"%s 0%c, %c%c",calendar[(int)((yytext[2])-48)*10+(int)((yytext[3])-49)],yytext[0],yytext[5],yytext[6]);
};

([0-9])\-([0-9])\-([0-9][0-9][0-9][0-9]) {
	fprintf(yyout, "%s 0%c, %c%c%c%c",calendar[(int)(yytext[2])-49],yytext[0],yytext[4],yytext[5],yytext[6],yytext[7]);
};

([0-9])\-([0-9][0-9])\-([0-9][0-9][0-9][0-9]) {
  	fprintf(yyout,"%s 0%c, %c%c%c%c",calendar[(int)((yytext[2])-48)*10+(int)((yytext[3])-49)],yytext[0],yytext[5],yytext[6],yytext[7],yytext[8]);
};

([0-9][0-9])\-([0-9][0-9])\-([0-9][0-9][0-9][0-9]) {
  	fprintf(yyout,"%s %c%c, %c%c%c%c",calendar[(int)((yytext[3])-48)*10+(int)((yytext[4])-49)],yytext[0],yytext[1],yytext[6],yytext[7],yytext[8],yytext[9]);
};

([0-9][0-9])\-([0-9])\-([0-9][0-9]) {
  	fprintf(yyout,"%s %c%c, %c%c",calendar[(int)yytext[3]-49],yytext[0],yytext[1],yytext[5],yytext[6]);
};

([0-9][0-9])\-([0-9])\-([0-9][0-9][0-9][0-9]) {
  	fprintf(yyout,"%s %c%c, %c%c%c%c",calendar[(int)yytext[3]-49],yytext[0],yytext[1],yytext[5],yytext[6],yytext[7],yytext[8]);
};

([0-9])\-([0-9])\-([0-9][0-9]) {
	fprintf(yyout, "%s 0%c, %c%c%c",calendar[(int)(yytext[2])-49],yytext[0],yytext[4],yytext[5],yytext[6]);
};

([0-9][0-9])\-([0-9][0-9])\-([0-9][0-9]) {
  	fprintf(yyout,"%s %c%c, %c%c",calendar[(int)((yytext[3])-48)*10+(int)((yytext[4])-49)],yytext[0],yytext[1],yytext[6],yytext[7]);
}


%%
  
 /*Auxiliary Functions*/

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
