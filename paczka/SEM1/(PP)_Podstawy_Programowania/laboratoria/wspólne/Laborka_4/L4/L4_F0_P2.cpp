#include<iostream>

#define WIELK 6

using namespace std;

int main(){
	int tab1[WIELK], tab2[WIELK], zlozenie[2*WIELK], i, j, k;

	for(i = 0; i < WIELK; i++)
		cin >> tab1[i];
	for(i = 0; i < WIELK; i++)
		cin >> tab2[i];
	for(i = 0, j = 0, k = 0; k < 2 * WIELK; k++){
		if(k % 2 == 0){
			zlozenie[k] = tab1[i];
			i++;
		}else{
			zlozenie[k] = tab2[j];
			j++;
		}
	} 
	for(k = 0; k < 2 * WIELK; k++)
		cout << zlozenie[k] << " ";
	return 0;
}