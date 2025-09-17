#include<iostream>
using namespace std;

void F1() {
	char tab[400 * 1024];
	cout << "jestem w funkcji F1" << endl;
	};

void F2() {
	char tab[400 * 1024];
	cout << "jestem w funkcji F2" << endl;
	F1();
	};

void F3() {
	char tab[400 * 1024];
	cout << "jestem w funkcji F3" << endl;
	F2();
	};

int main() {
	F1();
	F2();
	F3();
	return 0;
	};
