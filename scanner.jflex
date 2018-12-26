import java_cup.runtime.*;
 
%%
 
%unicode
%cup
%line
%column
 
%{
	private Symbol sym(int type) {
		return new Symbol(type, yyline, yycolumn);
	}
 
	private Symbol sym(int type, Object value) {
		return new Symbol(type, yyline, yycolumn, value);
	}
 
%}
 
/* TOKEN1 regular expression */
token1     = {hex_t1}"_"{character}{5}({character}{character})* "_"("SOS"|{xyz})?
xyz	= XY(YY)*ZZ(ZZ)*X
hex_t1 = ("-"(2[0-7] | 1[0-9a-fA-F] | [0-9a-fA-F])) | [0-9a-fA-F]{1,3} | 1[0-9a-fA-F][0-9a-fA-F][0-9a-fA-F] | 2[0-4][0-9a-fA-F][0-9a-fA-F] | 25[0-5][0-9a-fA-F] | 256[0-9a-cA-C]
character = [a-zA-Z] 


/* TOKEN2 regular expression */
token2	= {h1_token2} | {h2_token2} | {h3_token2}
h1_token2 = (1[0-6]":"[0-5][0-9]":"[0-5][0-9]) | (09":"[3-5][0-9]":"[0-5][0-9]) | (09":"2[2-9]":"[0-5][0-9]) | (09":"21":"[2-5][0-9]) | (09":"21":"1[2-9]) | (17":"43":"3[0-4]) |
		(17":"43":"[0-2][0-9]) | (17":"4[0-2]":"[0-5][0-9]) | (17":"[0-3][0-9]":"[0-5][0-9])
	
h2_token2 =  (1[0-6]":"[0-5][0-9]) | (09":"[3-5][0-9]) | (09":"2[1-9])  | (17":"4[0-3]) | (17":"[0-3][0-9])
h3_token2 = (1[0-1]":"[0-5][0-9]am) | (09":"[3-5][0-9]am) | (09":"2[1-9]am) |  (12":"[0-5][0-9]pm) | ([1-4]":"[0-5][0-9]pm) | (05":"4[0-3]pm) | (05":"[0-3][0-9]pm) 

/* TOKEN3 regular expression */                        
token3	= ("$$"(0*10*10*10* | 0*10*10*10*10*10*)) | ("&&"(X | O | (XO)*(X)? | (OX)*(O)? ) )
 



nl = \r|\n|\r\n
ws = [ \t]

q_string = \" ~ \"

compute = "COMPUTE"
to = "TO" 
time = "TIME"
expense = "EXPENSE"
extra = "EXTRA"
disc = "DISC"
euro = "euro"




uint	= 0 | [1-9][0-9]*
double2d = (([0-9]+\.[0-9]{2}) | ([0-9]*\.[0-9]{2}))
float_type = (([0-9]+\.[0-9]*) | ([0-9]*\.[0-9]+))

 

comment     = "/-" ~ "-/"
 
%%
 
";" 				{ return sym(sym.S);}
"##"				{ return sym(sym.SEP);}
{token1}			{ return sym(sym.TOKEN1);}
{token2}			{ return sym(sym.TOKEN2);}
{token3}			{ return sym(sym.TOKEN3);}
{to}				{ return sym(sym.TO);}
{disc}				{ return sym(sym.DISC);}
{euro}				{ return sym(sym.EURO);}
{compute}			{ return sym(sym.COMPUTE);}
{time}				{ return sym(sym.TIME);}
{expense}			{ return sym(sym.EXPENSE);}
{extra}				{ return sym(sym.EXTRA);}
{q_string}			{ return sym(sym.QSTRING, yytext());}
{uint}				{ return sym(sym.UINT, new Integer(yytext()));}
{double2d}			{ return sym(sym.PRICE,new Float(yytext()));}

{float_type}			{ return sym(sym.FLOAT_TYPE, new Float(yytext()));}

"-"				{ return sym(sym.LINE);}
"euro/km"			{ return sym(sym.EUROKM);}
"km"				{ return sym(sym.KM);}
"km/h"				{ return sym(sym.KMH);}
"->"				{ return sym(sym.ARROW);}
"=" 				{ return sym(sym.EQ);}
"," 				{ return sym(sym.CM);}

":" 				{ return sym(sym.COL);}
"(" 				{ return sym(sym.RO);}
")" 				{ return sym(sym.RC);}
"{" 				{ return sym(sym.SO);}
"}" 				{ return sym(sym.SC);}
"%" 				{ return sym(sym.PERC);}
 
{comment}	 		{;}
{ws}|{nl} | " "      {;}
 
.				{ System.out.println("Scanner Error: " + yytext()); }
