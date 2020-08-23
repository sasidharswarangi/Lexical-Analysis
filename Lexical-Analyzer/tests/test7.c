#include<stdio.h>
// Cube of a Number
int cube(int a)
{
	return(a*a*a);
}

/*struct abc
{
	int a;
	char b;
};*/

int main()
{
	int num = 2;
	int num2 = cube(num);
	
	printf("Cube of %d is %d", num, num2);

	return 0;
}
