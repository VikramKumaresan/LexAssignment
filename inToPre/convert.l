/*Definitions Section*/
%{
    #include<stdio.h> 
    #include<string.h>

    FILE *fptr;
    char inputString[100];

    char operandStack[100][100];
    int operandStackPointer=0;
    
    char operatorStack[100];   
    int operatorStackPointer=0;
%}

/*Rules Section*/
%%
[a-zA-Z]    {pushToOperandStack();}
[-\/*+()]   {pushToOperatorStack();}
[\n]        {printReversed();}
%%
//Function Section

int yywrap(){return 0;} 

void prepareInputString(){
    char letter=fgetc(fptr);

    char tempString[100];
    int tempStringPointer=0,inputStringPointer=0;

    while(letter != EOF){
        tempString[tempStringPointer]=letter;
        letter=fgetc(fptr);
        tempStringPointer++;
    }

    //Reverse input
    for(tempStringPointer=tempStringPointer-1;tempStringPointer>=0;tempStringPointer--){
        if(tempString[tempStringPointer] == '('){
            inputString[inputStringPointer]=')';
        }
        else if(tempString[tempStringPointer] == ')'){
            inputString[inputStringPointer]='(';
        }
        else{
            inputString[inputStringPointer]=tempString[tempStringPointer];
        }

        inputStringPointer++;
    }

    //Add new line and \0
    inputString[inputStringPointer]='\n';
    inputStringPointer++;
    inputString[inputStringPointer]='\0';
}

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

void printReversed(){
    for(int i=strlen(operandStack[0])-1;i>=0;i--){
        printf("%c",operandStack[0][i]);
    }
    printf("\n");
}

int main(){    
    //Connect input file
    fptr=fopen("input.txt","r");

    //Prepare input
    prepareInputString();

    // Start parsing
    yy_scan_string(inputString);
    yylex();

    return 0; 
} 