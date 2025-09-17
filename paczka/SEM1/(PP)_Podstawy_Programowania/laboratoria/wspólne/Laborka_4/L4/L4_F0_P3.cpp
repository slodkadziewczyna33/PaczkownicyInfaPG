#include<stdlib.h>
#include<iostream>
#include<time.h>

#define WIELK 250

using namespace std;

int main(){
	const double oceny[] = {2, 3, 3.5, 4, 4.5, 5, 5.5}; 
	int wyniki[WIELK], stat[7] = {}, i;
	srand(time(NULL));
	for(i = 0; i < WIELK; i++)
		wyniki[i] = rand()%7;	//losujemy indeks oceny
	for(i = 0; i < WIELK; i++)
		stat[wyniki[i]]++;

	for(i = 0; i < 7; i++)
		cout << oceny[i] << " - " << stat[i] << endl;
	return 0;
}