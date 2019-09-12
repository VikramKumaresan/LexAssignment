/*Definitions Section*/
%{
    #include<stdio.h> 
    int isInLoop=0;

    char iteratorVariableName[20]; 
    int iteratorVariableNamePointer=0;

    char loopCondition[20]; 
    int loopConditionPointer=0;

    char iteratorIncrement[20]; 
    int iteratorIncrementPointer=0;
%}

/*Rules Section*/
%%
for[ ]*[(]{1}[ ]*[a-zA-Z0-9=]+;                    {preDeclaredVariable();}
for[ ]*[(]{1}[ ]*int[ ]*[a-zA-Z=0-9]+;             {newDeclaredVariable();}

[a-zA-Z ]+[<>!= ]+[a-zA-Z0-9 ]+;                   {fetchLoopCondition();}

[a-zA-Z0-9]+[+-]{2}[ ]*[)][ ]*[{]                  {fetchIteratorIncrement();}
[a-zA-Z0-9]+[ ]*=[ a-zA-Z0-9+-]+[ ]*[)][ ]*[{]     {fetchIteratorIncrement();}

[}]                                                {finishWhileLoop();}
%%
//Function Section

int yywrap(){return 0;} 

void preDeclaredVariable(){
    isInLoop=1;

    char* traverser = yytext;
    while(*traverser!='('){
        traverser++;
    }

    traverser++;

    while(*traverser!=';'){
        if(*traverser!=' '){
            iteratorVariableName[iteratorVariableNamePointer]=*traverser;
            iteratorVariableNamePointer++;
        }
        traverser++;
    }
    iteratorVariableName[iteratorVariableNamePointer]='\0';

    //Print out initialization
    printf("%s;\n",iteratorVariableName);
}

void newDeclaredVariable(){
    isInLoop=1;

    char* traverser = yytext;
    while(*traverser!='('){
        traverser++;
    }

    traverser++;

    while(*traverser!=';'){
        iteratorVariableName[iteratorVariableNamePointer]=*traverser;
        iteratorVariableNamePointer++;
        traverser++;
    }
    iteratorVariableName[iteratorVariableNamePointer]='\0';

    //Print out declaration+initialization
    printf("%s;\n",iteratorVariableName);
}

void fetchLoopCondition(){
    
    if(loopConditionPointer!=0){
        printf("%s",yytext);
        return;
    }

    char* traverser = yytext;

    while(*traverser!=';'){
        loopCondition[loopConditionPointer]=*traverser;
        loopConditionPointer++;
        traverser++;
    }
    loopCondition[loopConditionPointer]='\0';

    //Print while loop
    printf("while(%s)\{\n",loopCondition);
}

void fetchIteratorIncrement(){
    char* traverser = yytext;

    while(*traverser!=')'){
        iteratorIncrement[iteratorIncrementPointer]=*traverser;
        iteratorIncrementPointer++;
        traverser++;
    }
    iteratorIncrement[iteratorIncrementPointer]='\0';
}

void finishWhileLoop(){
    printf("\n%s;\n",iteratorIncrement);
    printf("}\n");

    iteratorVariableNamePointer=0;
    loopConditionPointer=0;
    iteratorIncrementPointer=0;
}

int main(){    
    //Read from input file
    extern FILE *yyin; 
    yyin = fopen("input.txt", "r"); 
    
    // Start parsing
    yylex(); 
    return 0; 
} 