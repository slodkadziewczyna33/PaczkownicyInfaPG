#include<iostream>

using namespace std;

int main(){
	char napis[20] = "Jakis Napis";
	int i, j;

	for(i = 0; napis[i]; i++) 
		if(napis[i] <= 'z' && napis[i] >= 'a')
			napis[i] += 'A' - 'a';

	cout << napis;
	return 0;
}