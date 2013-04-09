%{
void FILACOLUMNA();
%}

%{
int numFila = 1, numColumna = 1;
%}
S " "
EQ {S}*={S}*
VN 1"."[0-9]+
NAMESTCHAR (:|"_"|[a-zA-Z])
NAMECHAR ({NAMESTCHAR}|"-"|"."|[0-9])
NAME {NAMESTCHAR}({NAMECHAR})*
CONTENIDO_ATRIBUTO (\"[^<\"]*\"|'[^<\"]*')
SCRIPT \"([a-z]|[A-Z]|[0-9])*\(([a-z]|[A-Z]|[0-9]|[^\n])*\)\"
PubIDChar [0-9]|[a-zA-Z]|([-'()+,./:=?;!*#@$_%]|" ")
PubIDLit "\""({PubIDChar})*"\""|'({PubIDChar})*'
SYSTLIT (\"([^"\n]*)\")|('([^\'\n]*)')
ENCNAME [a-zA-Z]([a-zA-Z]|[0-9]|"."|"_"|"-")*
ENCODNAME "\""({ENCNAME})"\""|'({ENCNAME})'
CONTENIDO_CDATA (((.)|(\n))[^\]\]>])*
ATRIBUTO "accesskey"|"class"|"contenteditable"|"contextmenu"|"dir"|"draggable"|"dropzone"|"hidden"|"id"|"inert"|"itemid"|"itemprop"|"itemref"|"itemscope"|"lang"|"spellocheck"|"style"|"tabindex"|"title"|"translate"|"version"|"xml:lang"|"xmlns"|"xmlns:xsi"|"xsi:schemaLocation"|"http-equiv"|"content"|"name"|"rel"|"media"|"type"|"title"
TAG "address"|"applet"|"abbr"|"acronym"|"article"|"aside"|"audio"|"b"|"base"|"basefont"|"big"|"blockquote"|"body"|"br"|"bdi"|"bdo"|"button"|"caption"|"center"|"cite"|"code"|"canvas"|"col"|"colgroup"|"commnad"|"dd"|"dfn"|"dir"|"div"|"dl"|"dt"|"datalist"|"del"|"details"|"dialog"|"em"|"embed"|"font"|"form"|"fieldset"|"figcaption"|"figure"|"footer"|"frame"|"frameset"|"h1"|"h2"|"h3"|"h4"|"h5"|"h6"|"head"|"hr"|"html"|"hi"|"hgroup"|"img"|"input"|"iframe"|"ins"|"isindex"|"kbd"|"keygen"|"1i"|"link"|"label"|"lagend"|"map"|"menu"|"meta"|"mark"|"meter"|"nav"|"noframes"|"noscript"|"ol"|"object"|"optgroup"|"option"|"p"|"param"|"pre"|"progress"|"q"|"rp"|"rt"|"ruby"|"s"|"section"|"source"|"span"|"summary"|"samp"|"script"|"select"|"small"|"strike"|"style"|"sub"|"sup"|"table"|"td"|"textarea"|"th"|"title"|"tr"|"tt"|"tbody"|"tfoot"|"thead"|"time"|"track"|"u"|"video"|"var"|"wbr"
EVENTO "nafterprint"|"onbeforeprint"|"onbeforeunload"|"onerror"|"onhaschange"|"onload"|"onmessage"|"onoffline"|"ononline"|"onpagehide"|"onpageshow"|"onpopstate"|"onredo"|"onresize"|"onstorage"|"onundo"|"onunload"|"onblur"|"onchange"|"oncontextmenu"|"onfocus"|"onformchange"|"onforminput"|"oninput"|"oninvalid"|"onreset"|"onselect"|"onsubmit"|"onkeydown"|"onkeypress"|"onkeyup"|"onclick"|"ondblclick"|"ondrag"|"ondragend"|"ondragenter"|"ondragleave"|"ondragover"|"ondragstart"|"ondrop"|"onmousedown"|"onmousemove"|"onmouseout"|"onmouseover"|"onmouseup"|"onmousewheel"|"onscroll"|"onabort"|"oncanplay"|"oncanplaythrough"|"ondurationchange"|"onemptied"|"onended"|"onerror"|"onloadeddata"|"onloadedmetadata"|"onloadstart"|"onpause"|"onplay"|"onplaying"|"onprogress"|"onratechang"|"onreadystatechange"|"onseeked"|"onseeking"|"onstalled"|"onsuspend"|"ontimeupdate"|"onvolumechange"|"onwaiting"

%x XMLDec 
%x DocType
%x ETags
%x ESTags
%x PubIDLit
%x SystLit
%x cDATA
%x COMENT
%x CONTENIDO 

%%
\n          		                {FILACOLUMNA(); printf(" ENTER\n "); return 100;} /* los enters valen 00 */
"<!--"					{FILACOLUMNA(); printf(" t_COMMENT");BEGIN(COMENT); return 102;} /* los comentarios valen 02 */
<COMENT>{
"--"				{error();}
((.)|(\n))			{FILACOLUMNA();}
"-->"				{FILACOLUMNA(); BEGIN(INITIAL);}
\n                             {FILACOLUMNA(); printf(" ENTER\n ");return 100;}
}

"<![CDATA["			{FILACOLUMNA(); printf(" t_cdata_ini "); BEGIN(cDATA); return 103;}
<cDATA>{
"]]>"				{FILACOLUMNA(); printf(" t_cdata_fin ");BEGIN(INITIAL);return 105;}
{CONTENIDO_CDATA}		{FILACOLUMNA(); printf(" Content_data "); return 104;}
.				{;error();}
}
   /* DEFINICION XMLDec*/
"<?xml"					{FILACOLUMNA(); printf(" t_XMLDec "); BEGIN(XMLDec); return 107;}
<XMLDec>{
"?>"				{FILACOLUMNA(); printf(" t_fin_XMLDec "); BEGIN(INITIAL);return 113;}
{S}				{FILACOLUMNA(); return 101;} /* los espacios valen 01*/
{EQ}				{FILACOLUMNA(); printf(" t_EQ "); return 106; } /* los iguales valen 06 */

(encoding)			{FILACOLUMNA(); printf(" t_encd "); return 108;}
{ENCODNAME}			{FILACOLUMNA(); printf(" t_endId "); return 109;}
  
(version)			{FILACOLUMNA(); printf(" t_vs "); return 110;}
\"{VN}\"			{FILACOLUMNA(); printf(" t_v_number ");return 111;}
'{VN}'				{FILACOLUMNA(); printf(" t_v_number ");return 112;}
\n                             {FILACOLUMNA(); printf(" ENTER\n ");return 100;}
.				{;error();}

}

 /* ------------------------------DOCTYPE------------------------------ */
"<!DOCTYPE"				{FILACOLUMNA(); printf(" t_DocType "); BEGIN(DocType);return 114;}
<DocType>{
{S}				{FILACOLUMNA();return 101;}
SYSTEM				{FILACOLUMNA();printf(" t_System "); BEGIN (SystLit);return 115;}
PUBLIC				{FILACOLUMNA();printf(" t_Public "); BEGIN (PubIDLit);return 116;}
{NAME}				{FILACOLUMNA();printf(" t_Name "); return 117;}
">"				{FILACOLUMNA(); printf(" End_Doctype "); BEGIN(INITIAL);return 120;}
\n                             {FILACOLUMNA(); printf(" ENTER\n ");return 100;}
.				{FILACOLUMNA();error();}
}

<PubIDLit>{S}			{FILACOLUMNA();return 101;}
<SystLit>{S}			{FILACOLUMNA();return 101;}
<PubIDLit>{PubIDLit}		{FILACOLUMNA(); printf(" t_PubIDLit");BEGIN(SystLit);return 118;}
<SystLit>{SYSTLIT}		{FILACOLUMNA(); printf(" t_systlit "); BEGIN(DocType);return 119;}
<SystLit>\n                    {FILACOLUMNA(); printf(" ENTER\n ");return 100;}
<PubIDLit>.			{;error();}
<SystLit>.			{;error();}

  /* ----------------------------DEFINICION ETags----------------------*/
"</"					{FILACOLUMNA(); printf(" t_ETags "); BEGIN(ETags);return 121;}
<ETags>{
{TAG}				{FILACOLUMNA(); printf(" t_TAG ");return 122;} /* return un tag*/
{S}				{FILACOLUMNA();return 101;}
{S}?">"				{FILACOLUMNA(); printf(" t_fin_ETAG ");BEGIN(INITIAL);return 123;}
\n                             {FILACOLUMNA(); printf(" ENTER\n "); return 100;}
.				{error();}
}
 
  
  
  /*-----------------------------DEFINICION ESTags-----------------------*/
"<"					{FILACOLUMNA(); printf(" t_ESTags"); BEGIN(ESTags);return 124;} 
<ESTags>{
{S}				{FILACOLUMNA();{printf(" ");}return 101;}
{EQ}				{FILACOLUMNA(); printf(" t_EQ ");return 106;}
{TAG}				{FILACOLUMNA(); printf(" t_TAG "); return 122;}

{CONTENIDO_ATRIBUTO}		{FILACOLUMNA(); printf(" t_content ");printf(" t_content_end ");return 123;}
{SCRIPT}			{FILACOLUMNA(); printf(" t_scriptcont ");return 124;}
{ATRIBUTO}	{FILACOLUMNA(); printf(" t_Atributo ");return 125;}
{EVENTO}/{EQ}{SCRIPT}		{FILACOLUMNA(); printf(" t_Script "); return 126;}
{S}?"/>"/[" "\n]*"<"		{FILACOLUMNA(); printf(" t_fin_EmTAG ");BEGIN(INITIAL);return 127;}
{S}?">"/[" "\n]*"<"		{FILACOLUMNA(); printf(" t_fin_STAG ");BEGIN(INITIAL);return 128;}
{S}?"/>"			{FILACOLUMNA(); printf(" t_fin_EmTAG ");BEGIN(CONTENIDO);return 127;}
{S}?">"				{FILACOLUMNA(); printf(" t_fin_STAG ");BEGIN(CONTENIDO);return 128;}
\n                             {FILACOLUMNA(); printf(" ENTER\n ");return 100;}
.				{error();}
} 
 /*-----------------------------DEFINICION Contenido-----------------------*/
<CONTENIDO>"&"			{error();}
<CONTENIDO>"</"			{FILACOLUMNA(); printf(" t_ETags "); BEGIN(ETags);return 121;}
<CONTENIDO>"<"			{FILACOLUMNA(); printf(" t_ESTags"); BEGIN(ESTags);return 124;}
<CONTENIDO>"]]>"/[^&<]		{error();}
<CONTENIDO>[^&<]*		{FILACOLUMNA();printf(" CONTENIDO ");return 129;}


" "			{FILACOLUMNA();return 101;}
%%

void FILACOLUMNA()
{
  if(strcmp("\n",yytext)==0)
	  {
	    numFila++;		
	    numColumna=1;
	  }
  else {
	    numColumna+= yyleng;
  }
}

int error(void)
{
    printf("\n");
    printf("ERROR!! \n");
    printf("en el numero de fila:%d\nY en la columna:%d\n", numFila, numColumna);
    exit(1);
    
}
