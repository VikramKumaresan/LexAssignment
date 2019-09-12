/*Definitions Section*/
%{
    #include<stdio.h> 
    //#include<string.h>   
%}

/*Rules Section*/
%%
[ ] {printf(" ");}
[a-zA-Z]*e[a-zA-Z]* {replaceAndPrint();}
%%
//Function Section

int yywrap(){return 0;} 

void replaceAndPrint(){
    char* traverser= yytext;

    while(*traverser != '\0'){
        if(*traverser == 'e'){
            printf("i");
        }
        else{
            printf("%c",*traverser);
        }
        traverser++;
    }
}

int main(){    
    // Start parsing
    yylex(); 
    return 0; 
} 