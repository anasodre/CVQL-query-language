%option noyywrap
%{

#include <stdio.h>
#include <string.h>
#include "test_query.tab.h"
void showError();
%}


alpha       ([a-zA-Z_0-9._/""])+
operator     [<>=]

%%

[ \t]+           ;
"CLUSTER"       {sscanf(yytext, "%s", yylval.name); printf("CLUSTER\n"); return (CLUSTER);}
"FROM"          {sscanf(yytext, "%s", yylval.name); printf("FROM\n"); return (FROM);}
"WITH"          {sscanf(yytext, "%s", yylval.name); printf("WITH\n"); return (WITH);}
"SELECT"        {sscanf(yytext, "%s", yylval.name); printf("SELECT\n"); return(SELECT);}
"WHERE"         {sscanf(yytext, "%s", yylval.name); printf("WHERE\n"); return(WHERE);}
"AND"           {sscanf(yytext, "%s", yylval.name); printf("AND\n"); return(AND);}
"GROUP"         {sscanf(yytext, "%s", yylval.name); printf("GROUP\n"); return(GROUP);}
"SOFT"          {sscanf(yytext, "%s", yylval.name); printf("SOFT\n"); return(SOFT);}
"MUST"          {sscanf(yytext, "%s", yylval.name); printf("MUST\n"); return(MUST);}
"CANNOT"        {sscanf(yytext, "%s", yylval.name); printf("CANNOT "); return(CANNOT);}
"LINK"          {sscanf(yytext, "%s", yylval.name); printf("LINK\n"); return(LINK);}
"BY"            {sscanf(yytext, "%s", yylval.name); printf("BY\n"); return(BY);}
"IN"            {sscanf(yytext, "%s", yylval.name); printf("IN\n"); return(IN);}
"AS"            {sscanf(yytext, "%s", yylval.name); printf("AS\n"); return(AS);}
"VISUALIZE"     {sscanf(yytext, "%s", yylval.name); printf("VISUALIZE\n"); return(VISUALIZE);}
{alpha}			{sscanf(yytext, "%s", yylval.name); printf("%s\n",yylval.name); return (TERM);}
{operator}		{sscanf(yytext, "%s", yylval.name); printf("%s\n",yylval.name); return (OPERATOR);}
";"      		{sscanf(yytext, "%s", yylval.name); return (SEMICOLON);}
","             {sscanf(yytext, "%s", yylval.name); printf(",\n"); return(COMMA);}
"("             {sscanf(yytext, "%s", yylval.name); printf("P_LEFT\n"); return(P_LEFT);}
")"             {sscanf(yytext, "%s", yylval.name); printf("P_RIGHT\n"); return(P_RIGHT);}
"*"             {sscanf(yytext, "%s", yylval.name); printf("*\n"); return(ASTERISK);}
.      		    {showError(); return(OTHER);}

%%


void showError(){
    printf("Other input");
}