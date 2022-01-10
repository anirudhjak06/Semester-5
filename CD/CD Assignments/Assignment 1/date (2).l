 
%{
#include<stdio.h>
#include<string.h>
#include<stdlib.h>
int flag=0;
int i=0;
int yr=0;
char *month[]={NULL,"January","February","March","April","May","June","July","August","September","October","November","December"};
%}
  
/* Rule: whenever one or more 
newline is encounterd, add two new lines and a tab since it's a paragraph*/
%%
[\n][\n]+   {fprintf(yyout, "\n\n\t");}
.       { fprintf(yyout, "%s", yytext); }



[a-z A-Z 0-9]* {
    for(i=0;i<yyleng;i++)
        {   if(i==0 && yytext[0]>=97 && yytext[0]<=122)
                {
                    fprintf(yyout,"%c",yytext[0] - ('a' - 'A'));
        	}
            else
            	{
            	    fprintf(yyout,"%c",yytext[i]);
            	}
        }

}


([1-2][0-9]|3[0-1]|[0-2][1-9])\/(0(1|3|5|7|8)|(10|12))\/((1[0-9][0-9][0-9])|(20([0-1][0-9]|2[0-1])))                           {printDateWithYear();}
([1-2][0-9]|30|[0-2][1-9])\/0(4|6|9)\/((1[0-9][0-9][0-9])|(20([0-1][0-9]|2[0-1])))                                             {printDateWithYear();}
(0[1-9]|1[0-9]|[0-8])\/02\/((1[0-9][0-9][0-9])|(20([0-1][0-9]|2[0-1])))                                                        {printDateWithYear();}
29\/(02)\/((1[0-9][0-9][0-9])|(20([0-1][0-9]|2[0-1])))                                                                           { 
                        while(yytext[i]!='/'){
                            i++; }
                        i++;
                        while(yytext[i]!='/'){
                            i++;}
                        i++;
                        while(i<yyleng){
                            yr=(10*yr)+(yytext[i++]-'0'); }
                        if(yr%4==0||(yr%100==0&&yr%400!=0))
                        {
                            printDateWithYear();}
                    }
(([1-2][0-9]|3[0-1]|[0-2][1-9])\/(0(1|3|5|7|8)|(10|12)))|(([1-2][0-9]|30|[0-2][1-9])\/0(4|6|9))|((0[1-9]|1[0-9]|[0-8])\/02)  {
                                                                                                                printDateWithoutYear();}
                                                                                                                
((([1-2][0-9]|3[0-1]|[0-2][1-9])\/(0(1|3|5|7|8)|(10|12)))|(([1-2][0-9]|30|[0-2][1-9])\/0(4|6|9))|((0[1-9]|1[0-9]|[0-8])\/02))\/([1-9][0-9]) {
                                                                                                                printDateWithHalfYear();}
                                                                                                                
(([1-9]|[1-2][0-9]|3[0-1])[ a-zA-Z]+((1[0-9][0-9][0-9])|(20([0-1][0-9]|2[0-1])))) {  printDateWithMonthName();}

(([1-9]|[1-2][0-9]|3[0-1])[ a-zA-Z]+) { printDateWithMonthNameWithoutYear();}

(([1-9]|[1-2][0-9]|3[0-1])[ a-zA-Z]+[1-9][0-9]) {printDateWithMonthNameHalfYear();}


([a-zA-Z ]+([1-9]|[1-2][0-9]|3[0-1])[a-z ]*((1[0-9][0-9][0-9])|(20([0-1][0-9]|2[0-1])))) {printDateWithMonthbefore();}

([a-zA-Z ]+([1-9]|[1-2][0-9]|3[0-1])[a-z ]*)  {printDateWithMonthbeforewithoutyear();}

([a-zA-Z ]+([1-9]|[1-2][0-9]|3[0-1])[a-z ]*[1-9][0-9])  {printDateWithMonthbeforeHalfyear();}



.                                                           ;

%%




int printDateWithMonthbeforeHalfyear()
{
    int i=0;
    int date=0;
    int f=0;
    while(1)
    {   
        
        if(yytext[i]=='s' && yytext[i+1]=='t')
        {
            if (yytext[i-2]=='2'|| yytext[i-2]=='3')
            {
                date = (yytext[i-2]-'0')*10+(yytext[i-1]-'0');
            }
            else{date = 1;}
            break;
        }
        else if(yytext[i]=='n' && yytext[i+1]=='d')
        {
            if (yytext[i-2]=='2')
            {
                date = 22;
            }
            else{date = 2;}
            break;
        }
        else if(yytext[i]=='r' && yytext[i+1]=='d')
        {
            if (yytext[i-2]=='2')
            {
                date = 23;
            }
            else{date = 3;}
            break;
        }
        
        else if (yytext[i]=='t' && yytext[i+1]=='h')
        {
            if ((yytext[i-2]-'0')>0)
            {
                date = (yytext[i-2]-'0')*10+(yytext[i-1]-'0');
            }
            else
            {
                date = (yytext[i-1]-'0');
            }
            break;
        }
        i++;
    }
    
    if((yytext[i-2]-'0')<=3 &&(yytext[i-2]-'0')>0)
    {
        f=1;
    }
    
        if(yytext[i-5-f]=='J' && yytext[i-4-f]=='a')
        {
            int year = (yytext[i+3]-'0')*10+(yytext[i+4]-'0');
            if (year>21){year+=1900;}
            else{year+=2000;}
            fprintf(yyout,"January %d, %d",date,year);
        }
        if(yytext[i-5-f]=='F' && yytext[i-4-f]=='e')
        {
        
            int year = (yytext[i+3]-'0')*10+(yytext[i+4]-'0');
            if (year>21){year+=1900;}
            else{year+=2000;}
            fprintf(yyout,"February %d, %d",date,year);
        }
        
        if(yytext[i-5-f]=='M' && yytext[i-4-f]=='a' && yytext[i-3-f]=='r')
        {
            int year = (yytext[i+3]-'0')*10+(yytext[i+4]-'0');
            if (year>21){year+=1900;}
            else{year+=2000;}
            fprintf(yyout,"March %d, %d",date,year);
        }
        if(yytext[i-5-f]=='A' && yytext[i-4-f]=='p' )
        {
            int year = (yytext[i+3]-'0')*10+(yytext[i+4]-'0');
            if (year>21){year+=1900;}
            else{year+=2000;}
            fprintf(yyout,"April %d, %d",date,year);
        }
        if(yytext[i-5-f]=='M' && yytext[i-4-f]=='a' && yytext[i-3-f]=='y')
        {
            int year = (yytext[i+3]-'0')*10+(yytext[i+4]-'0');
            if (year>21){year+=1900;}
            else{year+=2000;}
            fprintf(yyout,"May %d, %d",date,year);
        }
        
        if(yytext[i-5-f]=='J' && yytext[i-4-f]=='u' &&yytext[i-3-f]=='n')
        {
            int year = (yytext[i+3]-'0')*10+(yytext[i+4]-'0');
            if (year>21){year+=1900;}
            else{year+=2000;}
            fprintf(yyout,"June %d, %d",date,year);
        }
        
        if(yytext[i-5-f]=='J' && yytext[i-4-f]=='l')
        {
            int year = (yytext[i+3]-'0')*10+(yytext[i+4]-'0');
            if (year>21){year+=1900;}
            else{year+=2000;}
            fprintf(yyout,"July %d, %d",date,year);
        }
        
        if(yytext[i-5-f]=='A' && yytext[i-4-f]=='u')
        {
            int year = (yytext[i+3]-'0')*10+(yytext[i+4]-'0');
            if (year>21){year+=1900;}
            else{year+=2000;}
            fprintf(yyout,"August %d, %d",date,year);
        }
        
        if(yytext[i-6-f]== 'S' )
        {
            int year = (yytext[i+3]-'0')*10+(yytext[i+4]-'0');
            if (year>21){year+=1900;}
            else{year+=2000;}
            fprintf(yyout,"September %d, %d",date,year);
        }
        
        if(yytext[i-5-f]=='O')
        {
            int year = (yytext[i+3]-'0')*10+(yytext[i+4]-'0');
            if (year>21){year+=1900;}
            else{year+=2000;}
            fprintf(yyout,"October %d, %d",date,year);
        }
        
        if(yytext[i-5-f]=='N')
        {
            int year = (yytext[i+3]-'0')*10+(yytext[i+4]-'0');
            if (year>21){year+=1900;}
            else{year+=2000;}
            fprintf(yyout,"November %d, %d",date,year);
        }
        
        if(yytext[i-5-f]=='D')
        {
            int year = (yytext[i+3]-'0')*10+(yytext[i+4]-'0');
            if (year>21){year+=1900;}
            else{year+=2000;}
            fprintf(yyout,"December %d, %d",date,year);
        }
    
    return 0;
}



int printDateWithMonthbeforewithoutyear()
{
    int i=0;
    int date=0;
    int f=0;
    while(1)
    {   
        
        if(yytext[i]=='s' && yytext[i+1]=='t')
        {
            if (yytext[i-2]=='2'|| yytext[i-2]=='3')
            {
                date = (yytext[i-2]-'0')*10+(yytext[i-1]-'0');
            }
            else{date = 1;}
            break;
        }
        else if(yytext[i]=='n' && yytext[i+1]=='d')
        {
            if (yytext[i-2]=='2')
            {
                date = 22;
            }
            else{date = 2;}
            break;
        }
        else if(yytext[i]=='r' && yytext[i+1]=='d')
        {
            if (yytext[i-2]=='2')
            {
                date = 23;
            }
            else{date = 3;}
            break;
        }
        
        else if (yytext[i]=='t' && yytext[i+1]=='h')
        {
            if ((yytext[i-2]-'0')>0)
            {
                date = (yytext[i-2]-'0')*10+(yytext[i-1]-'0');
            }
            else
            {
                date = (yytext[i-1]-'0');
            }
            break;
        }
        i++;
    }
    
    if((yytext[i-2]-'0')<=3 &&(yytext[i-2]-'0')>0)
    {
        f=1;
    }
        if(yytext[i-5-f]=='J' && yytext[i-4-f]=='a')
        {
            
            fprintf(yyout,"January %d, 2021",date);
        }
        if(yytext[i-5-f]=='F' && yytext[i-4-f]=='e')
        {
            fprintf(yyout,"February %d, 2021",date);
        }
        
        if(yytext[i-5-f]=='M' && yytext[i-4-f]=='a' && yytext[i-3-f]=='r')
        {
            fprintf(yyout,"March %d, 2021",date);
        }
        if(yytext[i-5-f]=='A' && yytext[i-4-f]=='p' )
        {
            fprintf(yyout,"April %d, 2021",date);
        }
        if(yytext[i-5-f]=='M' && yytext[i-4-f]=='a' && yytext[i-3-f]=='y')
        {
            fprintf(yyout,"May %d, 2021",date);
        }
        
        if(yytext[i-5-f]=='J' && yytext[i-4-f]=='u' &&yytext[i-3-f]=='n')
        {
            fprintf(yyout,"June %d, 2021",date);
        }
        
        if(yytext[i-5-f]=='J' && yytext[i-4-f]=='l')
        {
            fprintf(yyout,"July %d, 2021",date);
        }
        
        if(yytext[i-5-f]=='A' && yytext[i-4-f]=='u')
        {
            fprintf(yyout,"August %d, 2021",date);
        }
        
        if(yytext[i-6-f]== 'S' )
        {
            fprintf(yyout,"September %d, 2021",date);
        }
        
        if(yytext[i-5-f]=='O')
        {
            fprintf(yyout,"October %d, 2021",date);
        }
        
        if(yytext[i-5-f]=='N')
        {
            fprintf(yyout,"November %d, 2021",date);
        }
        
        if(yytext[i-5-f]=='D')
        {
            fprintf(yyout,"December %d, 2021",date);
        }
    
    return 0;

}




int printDateWithMonthbefore()
{
    int i=0;
    int date=0;
    int f=0;
    while(1)
    {   
        
        if(yytext[i]=='s' && yytext[i+1]=='t')
        {
            if (yytext[i-2]=='2'|| yytext[i-2]=='3')
            {
                date = (yytext[i-2]-'0')*10+(yytext[i-1]-'0');
            }
            else{date = 1;}
            break;
        }
        else if(yytext[i]=='n' && yytext[i+1]=='d')
        {
            if (yytext[i-2]=='2')
            {
                date = 22;
            }
            else{date = 2;}
            break;
        }
        else if(yytext[i]=='r' && yytext[i+1]=='d')
        {
            if (yytext[i-2]=='2')
            {
                date = 23;
            }
            else{date = 3;}
            break;
        }
        
        else if (yytext[i]=='t' && yytext[i+1]=='h')
        {
            if ((yytext[i-2]-'0')>0)
            {
                date = (yytext[i-2]-'0')*10+(yytext[i-1]-'0');
            }
            else
            {
                date = (yytext[i-1]-'0');
            }
            break;
        }
        i++;
    }
    
    if((yytext[i-2]-'0')<=3 &&(yytext[i-2]-'0')>0)
    {
        f=1;
    }
        if(yytext[i-5-f]=='J' && yytext[i-4-f]=='a')
        {
            
            fprintf(yyout,"January %d, %c%c%c%c",date,yytext[i+3],yytext[i+4],yytext[i+5],yytext[i+6]);
        }
        if(yytext[i-5-f]=='F' && yytext[i-4-f]=='e')
        {
            fprintf(yyout,"February %d, %c%c%c%c",date,yytext[i+3],yytext[i+4],yytext[i+5],yytext[i+6]);
        }
        
        if(yytext[i-5-f]=='M' && yytext[i-4-f]=='a' && yytext[i-3-f]=='r')
        {
            fprintf(yyout,"March %d, %c%c%c%c",date,yytext[i+3],yytext[i+4],yytext[i+5],yytext[i+6]);
        }
        if(yytext[i-5-f]=='A' && yytext[i-4-f]=='p' )
        {
            fprintf(yyout,"April %d, %c%c%c%c",date,yytext[i+3],yytext[i+4],yytext[i+5],yytext[i+6]);
        }
        if(yytext[i-5-f]=='M' && yytext[i-4-f]=='a' && yytext[i-3-f]=='y')
        {
            fprintf(yyout,"May %d, %c%c%c%c",date,yytext[i+3],yytext[i+4],yytext[i+5],yytext[i+6]);
        }
        
        if(yytext[i-5-f]=='J' && yytext[i-4-f]=='u' &&yytext[i-3-f]=='n')
        {
            fprintf(yyout,"June %d, %c%c%c%c",date,yytext[i+3],yytext[i+4],yytext[i+5],yytext[i+6]);
        }
        
        if(yytext[i-5-f]=='J' && yytext[i-4-f]=='l')
        {
            fprintf(yyout,"July %d, %c%c%c%c",date,yytext[i+3],yytext[i+4],yytext[i+5],yytext[i+6]);
        }
        
        if(yytext[i-5-f]=='A' && yytext[i-4-f]=='u')
        {
            fprintf(yyout,"August %d, %c%c%c%c",date,yytext[i+3],yytext[i+4],yytext[i+5],yytext[i+6]);
        }
        
        if(yytext[i-6-f]== 'S' )
        {
            fprintf(yyout,"September %d, %c%c%c%c",date,yytext[i+3],yytext[i+4],yytext[i+5],yytext[i+6]);
        }
        
        if(yytext[i-5-f]=='O')
        {
            fprintf(yyout,"October %d, %c%c%c%c",date,yytext[i+3],yytext[i+4],yytext[i+5],yytext[i+6]);
        }
        
        if(yytext[i-5-f]=='N')
        {
            fprintf(yyout,"November %d, %c%c%c%c",date,yytext[i+3],yytext[i+4],yytext[i+5],yytext[i+6]);
        }
        
        if(yytext[i-5-f]=='D')
        {
            fprintf(yyout,"December %d, %c%c%c%c",date,yytext[i+3],yytext[i+4],yytext[i+5],yytext[i+6]);
        }
    
    return 0;
}

int printDateWithMonthNameHalfYear(){

    int i=0;
    int date=0;
    while(1)
    {   
        
        if(yytext[i]=='s' && yytext[i+1]=='t')
        {
            if (yytext[i-2]=='2'|| yytext[i-2]=='3')
            {
                date = (yytext[i-2]-'0')*10+(yytext[i-1]-'0');
            }
            else{date = 1;}
            i+=3;
            break;
        }
        else if(yytext[i]=='n' && yytext[i+1]=='d')
        {
            if (yytext[i-2]=='2')
            {
                date = 22;
            }
            else{date = 2;}
            i+=3;
            break;
        }
        else if(yytext[i]=='r' && yytext[i+1]=='d')
        {
            if (yytext[i-2]=='2')
            {
                date = 23;
            }
            else{date = 3;}
            i+=3;
            break;
        }
        
        else if (yytext[i]=='t' && yytext[i+1]=='h')
        {
            if ((yytext[i-2]-'0')>0)
            {
                date = (yytext[i-2]-'0')*10+(yytext[i-1]-'0');
            }
            else
            {
                date = (yytext[i-1]-'0');
            }
            i+=3;
            break;
        }
        i++;
    }
    
    
    char str[] = {yytext[i],yytext[i+1],yytext[i+2]};
        
        if(str[0]=='J' && str[1]=='a')
        {
            int year = (yytext[i+4]-'0')*10+(yytext[i+5]-'0');
            if (year>21){year+=1900;}
            else{year+=2000;}
            fprintf(yyout,"January %d, %d",date,year);
        }
        if(str[0]=='F' && str[1]=='e')
        {
            int year = (yytext[i+4]-'0')*10+(yytext[i+5]-'0');
            if (year>21){year+=1900;}
            else{year+=2000;}
            fprintf(yyout,"February %d, %d",date,year);
        }
        
        if(str[0]=='M' && str[1]=='a' && str[2]=='r')
        {
            int year = (yytext[i+4]-'0')*10+(yytext[i+5]-'0');
            if (year>21){year+=1900;}
            else{year+=2000;}
            fprintf(yyout,"March %d, %d",date,year);
        }
        if(str[0]=='A' && str[1]=='p' )
        {
            int year = (yytext[i+4]-'0')*10+(yytext[i+5]-'0');
            if (year>21){year+=1900;}
            else{year+=2000;}
            fprintf(yyout,"April %d, %d",date,year);
        }
        if(str[0]=='M' && str[1]=='a' && str[2]=='y')
        {
            int year = (yytext[i+4]-'0')*10+(yytext[i+5]-'0');
            if (year>21){year+=1900;}
            else{year+=2000;}
            fprintf(yyout,"May %d, %d",date,year);
        }
        
        if(str[0]=='J' && str[1]=='u' &&str[2]=='n')
        {
            int year = (yytext[i+4]-'0')*10+(yytext[i+5]-'0');
            if (year>21){year+=1900;}
            else{year+=2000;}
            fprintf(yyout,"June %d, %d",date,year);
        }
        
        if(str[0]=='J' && str[2]=='l')
        {
            int year = (yytext[i+4]-'0')*10+(yytext[i+5]-'0');
            if (year>21){year+=1900;}
            else{year+=2000;}
            fprintf(yyout,"July %d, %d",date,year);
        }
        
        if(str[0]=='A' && str[1]=='u')
        {
            int year = (yytext[i+4]-'0')*10+(yytext[i+5]-'0');
            if (year>21){year+=1900;}
            else{year+=2000;}
            fprintf(yyout,"August %d, %d",date,year);
        }
        
        if(str[0]== 'S' )
        {
            int year = (yytext[i+5]-'0')*10+(yytext[i+6]-'0');
            if (year>21){year+=1900;}
            else{year+=2000;}
            fprintf(yyout,"September %d, %d",date,year);
        }
        
        if(str[0]=='O')
        {
            int year = (yytext[i+4]-'0')*10+(yytext[i+5]-'0');
            if (year>21){year+=1900;}
            else{year+=2000;}
            fprintf(yyout,"October %d, %d",date,year);
        }
        
        if(str[0]=='N')
        {
            int year = (yytext[i+4]-'0')*10+(yytext[i+5]-'0');
            if (year>21){year+=1900;}
            else{year+=2000;}
            fprintf(yyout,"November %d, %d",date,year);
        }
        
        if(str[0]=='D')
        {
            int year = (yytext[i+4]-'0')*10+(yytext[i+5]-'0');
            if (year>21){year+=1900;}
            else{year+=2000;}
            fprintf(yyout,"December %d, %d",date,year);
        }
        
    return 0;
    
}

int printDateWithMonthNameWithoutYear(){

    int i=0;
    int date=0;
    while(1)
    {   
        
        if(yytext[i]=='s' && yytext[i+1]=='t')
        {
            if (yytext[i-2]=='2'|| yytext[i-2]=='3')
            {
                date = (yytext[i-2]-'0')*10+(yytext[i-1]-'0');
            }
            else{date = 1;}
            i+=3;
            break;
        }
        else if(yytext[i]=='n' && yytext[i+1]=='d')
        {
            if (yytext[i-2]=='2')
            {
                date = 22;
            }
            else{date = 2;}
            i+=3;
            break;
        }
        else if(yytext[i]=='r' && yytext[i+1]=='d')
        {
            if (yytext[i-2]=='2')
            {
                date = 23;
            }
            else{date = 3;}
            i+=3;
            break;
        }
        
        else if (yytext[i]=='t' && yytext[i+1]=='h')
        {
            if ((yytext[i-2]-'0')>0)
            {
                date = (yytext[i-2]-'0')*10+(yytext[i-1]-'0');
            }
            else
            {
                date = (yytext[i-1]-'0');
            }
            i+=3;
            break;
        }
        
        i++;
    }
    
        char str[] = {yytext[i],yytext[i+1],yytext[i+2]};
        
        if(str[0]=='J' && str[1]=='a')
        {
            fprintf(yyout,"January %d, 2021",date);
        }
        if(str[0]=='F' && str[1]=='e')
        {
            fprintf(yyout,"February %d, 2021",date);
        }
        
        if(str[0]=='M' && str[1]=='a' && str[2]=='r')
        {
            fprintf(yyout,"March %d, 2021",date);
        }
        if(str[0]=='A' && str[1]=='p' )
        {
            fprintf(yyout,"April %d, 2021",date);
        }
        if(str[0]=='M' && str[1]=='a' && str[2]=='y')
        {
            fprintf(yyout,"May %d, 2021",date);
        }
        
        if(str[0]=='J' && str[1]=='u' &&str[2]=='n')
        {
            fprintf(yyout,"June %d, 2021",date);
        }
        
        if(str[0]=='J' && str[2]=='l')
        {
            fprintf(yyout,"July %d, 2021",date);
        }
        
        if(str[0]=='A' && str[1]=='u')
        {
            fprintf(yyout,"August %d, 2021",date);
        }
        
        if(str[0]== 'S' )
        {
            fprintf(yyout,"September %d, 2021",date);
        }
        
        if(str[0]=='O')
        {
            fprintf(yyout,"October %d, 2021",date);
        }
        
        if(str[0]=='N')
        {
            fprintf(yyout,"November %d, 2021",date);
        }
        
        if(str[0]=='D')
        {
            fprintf(yyout,"December %d, 2021",date);
        }
    return 0;
}

int printDateWithMonthName(){
    int i=0;
    int date=0;
    while(1)
    {   
        
        if(yytext[i]=='s' && yytext[i+1]=='t')
        {
            if (yytext[i-2]=='2'|| yytext[i-2]=='3')
            {
                date = (yytext[i-2]-'0')*10+(yytext[i-1]-'0');
            }
            else{date = 1;}
            i+=3;
            break;
        }
        else if(yytext[i]=='n' && yytext[i+1]=='d')
        {
            if (yytext[i-2]=='2')
            {
                date = 22;
            }
            else{date = 2;}
            i+=3;
            break;
        }
        else if(yytext[i]=='r' && yytext[i+1]=='d')
        {
            if (yytext[i-2]=='2')
            {
                date = 23;
            }
            else{date = 3;}
            i+=3;
            break;
        }
        
        else if (yytext[i]=='t' && yytext[i+1]=='h')
        {
            if ((yytext[i-2]-'0')>0)
            {
                date = (yytext[i-2]-'0')*10+(yytext[i-1]-'0');
            }
            else
            {
                date = (yytext[i-1]-'0');
            }
            i+=3;
            break;
        }
        
        i++;
    }
    
        char str[] = {yytext[i],yytext[i+1],yytext[i+2]};
        
        if(str[0]=='J' && str[1]=='a')
        {
            fprintf(yyout,"January %d, %c%c%c%c",date,yytext[i+4],yytext[i+5],yytext[i+6],yytext[i+7]);
        }
        if(str[0]=='F' && str[1]=='e')
        {
            fprintf(yyout,"February %d, %c%c%c%c",date,yytext[i+4],yytext[i+5],yytext[i+6],yytext[i+7]);
        }
        
        if(str[0]=='M' && str[1]=='a' && str[2]=='r')
        {
            fprintf(yyout,"March %d, %c%c%c%c",date,yytext[i+4],yytext[i+5],yytext[i+6],yytext[i+7]);
        }
        if(str[0]=='A' && str[1]=='p' )
        {
            fprintf(yyout,"April %d, %c%c%c%c",date,yytext[i+4],yytext[i+5],yytext[i+6],yytext[i+7]);
        }
        if(str[0]=='M' && str[1]=='a' && str[2]=='y')
        {
            fprintf(yyout,"May %d, %c%c%c%c",date,yytext[i+4],yytext[i+5],yytext[i+6],yytext[i+7]);
        }
        
        if(str[0]=='J' && str[1]=='u' &&str[2]=='n')
        {
            fprintf(yyout,"June %d, %c%c%c%c",date,yytext[i+4],yytext[i+5],yytext[i+6],yytext[i+7]);
        }
        
        if(str[0]=='J' && str[2]=='l')
        {
            fprintf(yyout,"July %d, %c%c%c%c",date,yytext[i+4],yytext[i+5],yytext[i+6],yytext[i+7]);
        }
        
        if(str[0]=='A' && str[1]=='u')
        {
            fprintf(yyout,"August %d, %c%c%c%c",date,yytext[i+4],yytext[i+5],yytext[i+6],yytext[i+7]);
        }
        
        if(str[0]== 'S' )
        {
            fprintf(yyout,"September %d, %c%c%c%c",date,yytext[i+5],yytext[i+6],yytext[i+7],yytext[i+8]);
        }
        
        if(str[0]=='O')
        {
            fprintf(yyout,"October %d, %c%c%c%c",date,yytext[i+4],yytext[i+5],yytext[i+6],yytext[i+7]);
        }
        
        if(str[0]=='N')
        {
            fprintf(yyout,"November %d, %c%c%c%c",date,yytext[i+4],yytext[i+5],yytext[i+6],yytext[i+7]);
        }
        
        if(str[0]=='D')
        {
            fprintf(yyout,"December %d, %c%c%c%c",date,yytext[i+4],yytext[i+5],yytext[i+6],yytext[i+7]);
        }
        
    
    return 0;
}


int printDateWithYear(){
        int i=0;
        while(yytext[i]!='/'){i++;}
        
        //fprintf(yyout,"%c\n",yytext[i+8]);
        
        
        if((yytext[i-2]=='0' && (yytext[i-1]-'0')<=9)||(yytext[i-2]!='0' &&yytext[i-2]!='1'&&yytext[i-2]!='2' &&yytext[i-2]!='3'&&(yytext[i-1]-'0')<=9)){
            
            int cal = (yytext[i+1]-'0')*10+(yytext[i+2]-'0');
            fprintf(yyout,"\n%s %c, %c%c%c%c\n",month[cal],yytext[i-1],yytext[i+4],yytext[i+5],yytext[i+6],yytext[i+7]);
        }
        else if(((yytext[i-2]-'0')<=2 && (yytext[i-1]-'0')<=9) ||((yytext[i-2]-'0')==3&&(yytext[i-1]-'0')<=1)){
            
            
            int cal = (yytext[i+1]-'0')*10+(yytext[i+2]-'0');
            fprintf(yyout,"\n%s %c%c, %c%c%c%c\n",month[cal],yytext[i-2],yytext[i-1],yytext[i+4],yytext[i+5],yytext[i+6],yytext[i+7]);
        }
        
        return 0;
}

int printDateWithHalfYear(){
        
        int i=0;
        while(yytext[i]!='/'){i++;}
        int year = (yytext[i+4]-'0')*10+(yytext[i+5]-'0');
        if(year>21){year+=1900;}
        else{year+=2000;}
        
        if((yytext[i-2]=='0' && (yytext[i-1]-'0')<=9)||(yytext[i-2]!='0' &&yytext[i-2]!='1'&&yytext[i-2]!='2' &&yytext[i-2]!='3'&&(yytext[i-1]-'0')<=9)){
            
            int cal = (yytext[i+1]-'0')*10+(yytext[i+2]-'0');
            fprintf(yyout,"\n%s %c, %d\n",month[cal],yytext[i-1],year);
        }
        else if(((yytext[i-2]-'0')<=2 && (yytext[i-1]-'0')<=9) ||((yytext[i-2]-'0')==3&&(yytext[i-1]-'0')<=1)){
            
            
            int cal = (yytext[i+1]-'0')*10+(yytext[i+2]-'0');
            fprintf(yyout,"\n%s %c%c, %d\n",month[cal],yytext[i-2],yytext[i-1],year);
        }
        
        return 0;
}

int printDateWithoutYear(){
        int i=0;
        while(yytext[i]!='/'){i++;}
        
        //fprintf(yyout,"%c\n",yytext[i+8]);
        
        
        if((yytext[i-2]=='0' && (yytext[i-1]-'0')<=9)||(yytext[i-2]!='0' &&yytext[i-2]!='1'&&yytext[i-2]!='2' &&yytext[i-2]!='3'&&(yytext[i-1]-'0')<=9)){
            
            int cal = (yytext[i+1]-'0')*10+(yytext[i+2]-'0');
            fprintf(yyout,"\n%s %c, 2021\n",month[cal],yytext[i-1]);
        }
        else if(((yytext[i-2]-'0')<=2 && (yytext[i-1]-'0')<=9) ||((yytext[i-2]-'0')==3&&(yytext[i-1]-'0')<=1)){
            
            
            int cal = (yytext[i+1]-'0')*10+(yytext[i+2]-'0');
            fprintf(yyout,"\n%s %c%c, 2021\n",month[cal],yytext[i-2],yytext[i-1]);
        }
        return 0;
}




  

  
// driver code 
int main()
{
    extern FILE *yyin, *yyout;
    yyin = fopen("Input.txt", "r+");
    yyout = fopen("Output.txt", "w");
    yylex();
    return 0;
}

int yywrap()
{
    return 1;
}