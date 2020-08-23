%{
	#include <stdio.h>
	#include <string.h>
	

	struct symboltable
	{
		char name[100];
		char type[100];
		int length;
	}ST[1001];

	struct constanttable
	{
		char name[100];
		char type[100];
		int length;
	}CT[1001];

	int hash(char *str)
	{
		int value = 0;
		for(int i = 0 ; i < strlen(str) ; i++)
		{
			value = 10*value + (str[i] - 'A');
			value = value % 1001;
			while(value < 0)
				value = value + 1001;
		}
		return value;
	}

	int lookupST(char *str)
	{
		int value = hash(str);
		if(ST[value].length == 0)
		{
			return 0;
		}
		else if(strcmp(ST[value].name,str)==0)
		{
			return 1;
		}
		else
		{
			for(int i = value + 1 ; i!=value ; i = (i+1)%1001)
	    	{
	    		if(strcmp(ST[i].name,str)==0)
	    		{
	    			return 1;
	    		}
	    	}
	    	return 0;
	    }
	}

	int lookupCT(char *str)
	{
		int value = hash(str);
		if(CT[value].length == 0)
			return 0;
		else if(strcmp(CT[value].name,str)==0)
			return 1;
		else
		{
			for(int i = value + 1 ; i!=value ; i = (i+1)%1001)
			{
				if(strcmp(CT[i].name,str)==0)
				{
					return 1;
				}
			}
			return 0;
		}
	}

	void insertST(char *str1, char *str2)
	{
		if(lookupST(str1))
		{
		    return;
	    }
		else
		{
			int value = hash(str1);
			if(ST[value].length == 0)
			{
				strcpy(ST[value].name,str1);
				strcpy(ST[value].type,str2);
				ST[value].length = strlen(str1);
				return;
			}

			int pos = 0;

			for (int i = value + 1 ; i!=value ; i = (i+1)%1001)
			{
				if(ST[i].length == 0)
				{
					pos = i;
					break;
				}
			}

			strcpy(ST[pos].name,str1);
			strcpy(ST[pos].type,str2);
			ST[pos].length = strlen(str1);
		}
	}

	void insertCT(char *str1, char *str2)
	{
		if(lookupCT(str1))
			return;
		else
		{
			int value = hash(str1);
			if(CT[value].length == 0)
			{
				strcpy(CT[value].name,str1);
				strcpy(CT[value].type,str2);
				CT[value].length = strlen(str1);
				return;
			}

			int pos = 0;

			for (int i = value + 1 ; i!=value ; i = (i+1)%1001)
			{
				if(CT[i].length == 0)
				{
					pos = i;
					break;
				}
			}

			strcpy(CT[pos].name,str1);
			strcpy(CT[pos].type,str2);
			CT[pos].length = strlen(str1);
		}
	}

	void printST()
	{
		for(int i = 0 ; i < 1001 ; i++)
		{
			if(ST[i].length == 0)
			{
				continue;
			}

			printf("\t%s\t%s\n",ST[i].name, ST[i].type);
		}
	}

	void printCT()
	{
		for(int i = 0 ; i < 1001 ; i++)
		{
			if(CT[i].length == 0)
				continue;

			printf("\t%s\t%s\n",CT[i].name, CT[i].type);
		}
	}

%}

DE "define"
IN "include"

operator [[<][=]|[>][=]|[=][=]|[!][=]|[>]|[<]|[\|][\|]|[&][&]|[\!]|[=]|[\^]|[\+][=]|[\-][=]|[\*][=]|[\/][=]|[\%][=]|[\+][\+]|[\-][\-]|[\+]|[\-]|[\*]|[\/]|[\%]|[&]|[\|]|[~]|[<][<]|[>][>]]


%%
yyleng
([#][" "]*({IN})[ ]*([<]?)([A-Za-z]+)[.]?([A-Za-z]*)([>]?))/["\n"|\/|" "|"\t"] {printf("\t%s \t\t----------Pre Processor directive\n",yytext);}	//Matches #include<stdio.h>
([#][" "]*({DE})[" "]*([A-Za-z]+)(" ")*[0-9]+)/["\n"|\/|" "|"\t"] {printf("\t%s \t\t---------Macro\n",yytext);} //Matches macro
\/\/(.*) {printf("\t%s \t\t---------- Single line comment\n", yytext);}				
\/\*([^*]|[\r\n]|(\*+([^*/]|[\r\n])))*\*+\/  {printf("\t%s \t\t--------- Multi line comment\n", yytext);}
[ \n\t] ;
; {printf("\t%s \t\t--------- SemiColon delimiter\n", yytext);}
, {printf("\t%s \t\t--------- Comma delimiter\n", yytext);}
\{ {printf("\t%s \t\t--------- Opening braces\n", yytext);}
\} {printf("\t%s \t\t--------- Closing braces\n", yytext);}
\( {printf("\t%s \t\t--------- Opening brackets\n", yytext);}
\) {printf("\t%s \t\t--------- Closing brackets\n", yytext);}
\[ {printf("\t%s \t\t--------- Square Opening brackets\n", yytext);}
\] {printf("\t%s \t\t--------- Square Closing brackets\n", yytext);}
\: {printf("\t%s \t\t--------- Colon Delimiter\n", yytext);}
\\ {printf("\t%s \t\t--------- Fslash\n", yytext);}
\. {printf("\t%s \t\t--------- Dot Delimiter\n", yytext);}
auto|break|case|char|const|continue|default|do|double|else|enum|extern|float|for|goto|if|int|long|register|return|short|signed|sizeof|static|struct|switch|typedef|union|unsigned|void|volatile|while|main/[\(|" "|\{|;|:|"\n"|"\t"] {printf("\t%s \t\t---------- keyword\n", yytext); insertST(yytext, "keyword");}
\"[^\n]*\"/[;|,|\)] {printf("\t%s \t\t--------- String Constant\n", yytext); insertCT(yytext,"String Constant");}
\'[A-Z|a-z]\'/[;|,|\)|:] {printf("\t%s \t\t---------- Character Constant\n", yytext); insertCT(yytext,"Character Constant");}
[a-z|A-Z]([a-z|A-Z]|[0-9])*/\[ {printf("\t%s \t\t--------- Array Identifier\n", yytext); insertST(yytext, "Identifier");}

{operator}/[a-z]|[0-9]|;|" "|[A-Z]|\(|\"|\'|\)|\n|\t {printf("\t%s \t\t--------- Operator\n", yytext);} 

[1-9][0-9]*|0/[;|,|" "|\)|<|>|=|\!|\||&|\+|\-|\*|\/|\%|~|\]|\}|:|\n|\t|\^] {printf("\t%s \t\t--------- Number Constant\n", yytext); insertCT(yytext, "Nunmber Constant");}
([0-9]*)\.([0-9]+)/[;|,|" "|\)|<|>|=|\!|\||&|\+|\-|\*|\/|\%|~|\n|\t|\^] {printf("\t%s \t\t--------- Floating Constant\n", yytext); insertCT(yytext, "Floating Constant");}
[A-Za-z_][A-Za-z_0-9]*/[" "|;|,|\(|\)|<|>|=|\!|\||&|\+|\-|\*|\/|\%|~|\n|\.|\{|\^|\t] {printf("\t%s \t\t--------- Identifier\n", yytext); insertST(yytext, "Identifier");}


(.?) {
		if(yytext[0]=='#')
		{
       		printf("\tError in Pre-Processor directive at line no. %d\n",yyleng);
       	}
	    else if(yytext[0]=='/')
	    {
       		printf("\tERR_UNMATCHED_COMMENT at line no. %d\n",yyleng);
       	}
       	else if(yytext[0]=='"')
       	{
       		printf("\tERR_INCOMPLETE_STRING at line no. %d\n",yyleng);
       	}
       	else
       	{
       		printf("\tERROR at line no. %d\n",yyleng);
       	}
       	printf("\t%s\n", yytext);
       	return 0;
}

%%

int main(int argc , char **argv){

    printf("-----------------------------------------------------------------------------------------------------------\n\n");

	int i;
	for (i=0;i<1001;i++){
		ST[i].length=0;
		CT[i].length=0;
	}

	yyin = fopen(argv[1],"r");
	yylex();
	
	printf("\n\n\tSYMBOL TABLE\n\n");
	printST();
	printf("\n\n\tCONSTANT TABLE\n\n");
	printCT();
}

int yywrap(){
    return 1;
}