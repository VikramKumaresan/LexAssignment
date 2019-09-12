/*Definitions Section*/
%{
    #include<stdio.h> 
    char operandStack[100][100];
    int operandStackPointer=0;
    
    char operatorStack[100];   
    int operatorStackPointer=0;
%}

/*Rules Section*/
%%
[a-zA-Z]    {pushToOperandStack();}
[-\/*+()]   {pushToOperatorStack();}
[\n]        {printf("%s\n",operandStack[operandStackPointer-1]);}
%%
//Function Section

int yywrap(){return 0;} 

void pushToOperandStack(){

    char* traverser = yytext;
    int stringIndex=0;

    while(*traverser != '\0'){
        operandStack[operandStackPointer][stringIndex]=*traverser;

        traverser++;
        stringIndex++;
    }
    operandStack[operandStackPointer][stringIndex]='\0';    
    
    operandStackPointer++;

    //printf("Pushed to Operand Stack = %s\n",operandStack[operandStackPointer-1]);
}

void pushToOperatorStack(){

    if(yytext[0] == '('){
        operatorStack[operatorStackPointer]=yytext[0];
        operatorStackPointer++;
        //printf("Pushed to Operator Stack = %c\n",operatorStack[operatorStackPointer-1]);
        return;
    }

    if(yytext[0] == ')'){
        while(operatorStack[operatorStackPointer-1] != '('){
            performOperation(); //Complete
        }
        operatorStackPointer--;
        return;
    }

    while(isPerformOperation() == 1){
        performOperation();
    }

    operatorStack[operatorStackPointer]=yytext[0];
    operatorStackPointer++;
    //printf("Pushed to Operator Stack = %c\n",operatorStack[operatorStackPointer-1]);
}

int isPerformOperation(){
    int topOfOperatorStack;

    if(operatorStack[operatorStackPointer-1] == '('){
        return 0;
    }
    else if(operatorStack[operatorStackPointer-1] == '+' || operatorStack[operatorStackPointer-1] == '-'){
        topOfOperatorStack=1;
    }
    else if(operatorStack[operatorStackPointer-1] == '*' || operatorStack[operatorStackPointer-1] == '/'){
        topOfOperatorStack=2;
    }

    int incomingOperator;

    if(yytext[0] == '+' || yytext[0] == '-'){
        incomingOperator=1;
    }
    else if(yytext[0] == '*' || yytext[0] == '/'){
        incomingOperator=2;
    }

    if(topOfOperatorStack>incomingOperator){
        return 1;
    }
    return 0;

}

void performOperation(){
    char tempString[100];
    int tempStringPointer=0;

    int stringIndex=0;

    //Copy operand1 to tempString
    while(operandStack[operandStackPointer-2][stringIndex] != '\0'){
        tempString[tempStringPointer]=operandStack[operandStackPointer-2][stringIndex];
        tempStringPointer++;
        stringIndex++;
    }

    //Copy operand2 to tempString
    stringIndex=0;
    while(operandStack[operandStackPointer-1][stringIndex] != '\0'){
        tempString[tempStringPointer]=operandStack[operandStackPointer-1][stringIndex];
        tempStringPointer++;
        stringIndex++;
    }

    //Copy operator to tempString
    tempString[tempStringPointer]=operatorStack[operatorStackPointer-1];
    tempStringPointer++;
    operatorStackPointer--;

    tempString[tempStringPointer]='\0';

    //Copy tempString to operandStack
    for(stringIndex=0;stringIndex<=tempStringPointer;stringIndex++){
        operandStack[operandStackPointer-2][stringIndex] = tempString[stringIndex];
    }

    operandStackPointer--;

    //printf("Performed Operation = %s\n",operandStack[operandStackPointer-1]);
}

int main(){    
    //Connect input file
    extern FILE *yyin;
    yyin=fopen("input.txt","r");

    // Start parsing
    yylex(); 
    return 0; 
} 