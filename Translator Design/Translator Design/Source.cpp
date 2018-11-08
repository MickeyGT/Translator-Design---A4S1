#include <iostream>

using namespace std;

extern int yylex();
extern int yylineno;
extern char * yytext;

int main()
{
	int token = yylex();
	while (token)
	{
		cout << yytext << '\n';

		token = yylex();
	}
	cout << "Hello world!" << endl;
	return 0;
}
