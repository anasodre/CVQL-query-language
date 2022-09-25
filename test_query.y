%{
	#include <stdio.h>
	#include <string.h>
	#include <mysql.h>
	#define NUM_WORDS 10000
	#define MAX_STRING_SIZE 60
	#define MAX_LIST 2
	#define begin 0

	char subqueryList[NUM_WORDS] = "";
	char attrList[NUM_WORDS] = "";
	char plotType[NUM_WORDS] = "";
	char inpList[NUM_WORDS] = "";
	char plotList[NUM_WORDS] = "";
	extern FILE* yyin;

	int its_func_op (char *word);
	void add_word(char *word, char *list);
	void print_array(char *list);
	void store_attr(FILE* yyin, char *type, char *list);
	int yylex();
	int yyerror(char *s);
;

%}

%token TERM NUM OTHER SEMICOLON COMMA CLUSTER FROM WITH SELECT
%token WHERE AND GROUP P_LEFT P_RIGHT GREATER LESS
%token EQUAL SOFT MUST CANNOT LINK BY IN ASTERISK OPERATOR
%token VISUALIZE AS

%type <name> TERM
%type <name> SELECT
%type <name> FROM
%type <name> WITH
%type <name> WHERE
%type <name> GROUP
%type <name> BY
%type <name> AND
%type <number> NUM
%type <name> OPERATOR
%type <name> COMMA
%type <name> ASTERISK
%type <name> P_LEFT
%type <name> P_RIGHT

%union{
	char name[20];
    int number;
}

%%

prog:
  statement
;

statement: CLUSTER attributes FROM data
		 | CLUSTER attributes FROM data VISUALIZE columns AS visOption 
		 | CLUSTER attributes FROM data VISUALIZE AS visOption WITH inputation
;
attributes: ASTERISK
          | attr
;
attr: attributename 
	| attributename COMMA { add_word($2, attrList); } attr
;
attributename: TERM { add_word($1, attrList); }
;
data: P_LEFT seqStr P_RIGHT { store_attr(yyin,"subqueryList ", subqueryList); 
							  store_attr(yyin,"\nattrList ", attrList);
							  print_array(subqueryList); }
;
seqStr: part
	  | part COMMA { add_word($2, subqueryList); } seqStr
	  | part P_LEFT { add_word($2, subqueryList); } seqStr P_RIGHT { add_word($5, subqueryList); } seqStr
;
part: identifier part
	| TERM { add_word($1, subqueryList); }
	| TERM { add_word($1, subqueryList); } part
	| TERM OPERATOR TERM { add_word($1, subqueryList);
						   add_word($2, subqueryList);
						   add_word($3, subqueryList); }
	| TERM OPERATOR TERM { add_word($1, subqueryList);
						   add_word($2, subqueryList);
						   add_word($3, subqueryList); } part
	| TERM OPERATOR OPERATOR TERM { add_word($1, subqueryList);
						   add_word($2, subqueryList);
						   add_word($3, subqueryList);
						   add_word($4, subqueryList); } part
	| TERM OPERATOR NUM { add_word($1, subqueryList);
						   add_word($2, subqueryList);
						   char aux[2];
						   sprintf(aux, "%d", $3);
						   add_word(aux, subqueryList); }
	| ASTERISK { add_word($1, subqueryList); } part
;
identifier: SELECT { add_word($1, subqueryList); }
		  |	FROM { add_word($1, subqueryList); }
		  | WITH { add_word($1, subqueryList); }
		  | WHERE { add_word($1, subqueryList); }
		  | AND { add_word($1, subqueryList); }
		  | GROUP BY { add_word($1, subqueryList); add_word($2, subqueryList); }
;
visOption: TERM { add_word($1, plotType); 
				  store_attr(yyin,"\nplotList ", plotList);
				  store_attr(yyin,"\nplotType", plotType); }
;
inputation: TERM { add_word($1, inpList); store_attr(yyin,"\ninpList ", inpList); }
;
columns: TERM { add_word($1, plotList); }
	   | TERM COMMA { add_word($1, plotList); add_word($2, plotList); } columns
;
%%

int its_func_op (char *word) {
	char reserved_list[MAX_LIST][MAX_STRING_SIZE] =
	{ "SUM", "<" };

	int i;
	for (i = begin; i < MAX_LIST; i++) {
		if (!strcmp(reserved_list[i], word)) {
			printf("%s \n %s \n -", reserved_list[i], word);
			return 1;
		}
	}

	return 0;
}

void add_word(char *word, char *list) {
	strcat(list, word);
	
	// todo criar uma lista de funcoes para checar
	if (!its_func_op(word))
		strcat(list, " ");
}

void print_array(char *list) {
	printf("%s\n",list);
}

void store_attr(FILE* yyin, char *type, char *list) {
	yyin = fopen("attr.txt","a+");

	if(yyin == NULL) {
    	perror("Error opening file");
    	exit(0);
   	}

	fputs(type, yyin);
	fputs(list, yyin);

	fclose(yyin);
}

int yyerror(char *s) {
	printf("Error: %s\n", s);
	return 0;
}

int main(int argc, char *argv[]) {
    yyparse();
    return 0;
}