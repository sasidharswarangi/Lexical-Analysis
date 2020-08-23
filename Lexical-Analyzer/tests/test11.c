//if-else
//switch-case
//++ operator, -- operator
//return

#include<stdio.h>

int main()
{
    int x;
    char a = 'p';
    if(a == 'p') {
        return 1;
    } else {
        a++;
        ++x;
    }

    switch(a) {
        case 'p':
            a++;
            break;
        case 'q':
            a--;
            break;
        case 'r':
            a = a + 2;
            break;
        case x:
            exit(0);

        default:
            a = a + 3;
    }
    printf("%c",a);
}