Real_number             [0-9]+\.[0-9]+
Integer_number          [0-9]+
String_value            (?:'"')(((?:\\\")*|[^\"])*)(?:'"')
Identifier              [A-Za-z][A-Za-z0-9]*
Symbol                  ^\"[A-Za-z]\\?\"?\"
 
%%


\{[A-Za-z ]*\}          { /* skip */ }
\s+                     { /* skip */ }
\n                      { /* skip */ }
\s                      { return 'WS'; }
"def"                   { return 'DEF'; }
"integer"               { return 'INT'; }
"real"                  { return 'FLOAT'; }
"string"                { return 'STRING'; }
"symbol"                { return 'SYMB'; }
"logic"                 { return 'LOGIC'; }
"true"                  { return 'TRUE'; }
"false"                 { return 'FALSE'; }
"boolean"               { return 'BOOLEAN'; }
"none"                  { return 'NONE'; }
"for"                   { return 'FOR'; }
"from"                  { return 'FROM'; }
"to"                    { return 'TO'; }
"in"                    { return 'IN'; }
"run"                   { return 'RUN'; }
"end"                   { return 'END'; }
"loop"                  { return 'LOOP'; }
"when"                  { return 'WHEN'; }
"if"                    { return 'IF'; }
"then"                  { return 'THEN'; }
"else"                  { return 'ELSE'; }
"struct"                { return 'STRUCT'; }
"property"              { return 'PROPERTY'; }
"begin"                 { return 'BEGIN'; }
"fn"                    { return 'FN'; }
"return"                { return 'RET'; }
"=>"                    { return '=>'; }
":"                     { return 'OF'; }
";"                     { return ';'; }
","                     { return ','; }
":"                     { return 'DECLARATION'; }
"="                     { return 'ATTRIBUTION'; }
"+"                     { return '+'; }
"-"                     { return '-'; }
"<"                     { return '<'; }
">"                     { return '>'; }
"*"                     { return '*'; }
"/"                     { return '/'; }
"%"                     { return '%'; }
"["                     { return '['; }
"]"                     { return ']'; }
"("                     { return 'LP'; }
")"                     { return 'RP'; }
"&&"                    { return 'AND'; }
"||"                    { return 'OR'; }
"!"                     { return 'NOT'; }
"\r?\n"                 { return 'NEWLINE';}
'\r\n\r\n'              { return 'EMPTYLINE';}



"def" 		            { return 'DEF'; }
{Real_number}           { return 'REAL_NUMBER'; }
{Integer_number}        { return 'INTEGER_NUMBER'; }
{Symbol}                { return 'SYMBOL';}
{String_value}          { return 'STRING_VALUE'; }
{Identifier}            { return 'IDENTIFIER'; }