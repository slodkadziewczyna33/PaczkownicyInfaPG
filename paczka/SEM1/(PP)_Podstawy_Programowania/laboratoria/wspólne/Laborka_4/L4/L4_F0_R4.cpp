#include<iostream>

#define SIZE 45
using namespace std;
enum direction {RIGHT, DOWN, LEFT, UP};


int main(){
	char tab[SIZE][SIZE] ;
	int i, j, granicai = 0, granicaj = 0, test = 1 ;
	for(i = 0; i< SIZE; i++)for(j = 0; j < SIZE; j++) tab[i][j] = ' ';
	i = j = 0;
	direction dir = RIGHT;
	while(test){
		switch(dir){
		case RIGHT:{ 
			if(j < SIZE - granicaj){
				tab[i][j] = '*';
				j++;
			}else{
				dir = DOWN;  
				//granicaj += 2;
				j--;
				i++;
			}
			break;
		}
		case DOWN:{ 
			if(i < SIZE - granicai){
				tab[i][j] = '*';
				i++;
			}else{
				dir = LEFT;  
				granicai += 2;
				i--;
				j--;
			}
			break;
		}
		case LEFT:{ 
			if(j >= granicaj){
				tab[i][j] = '*';
				j--;
			}else{
				dir = UP;  
				granicaj += 2;
				j++;
				i--;
			}
			break;
		}
		case UP:{ 
			if(i >= granicai){
				tab[i][j] = '*';
				i--;
			}else{
				dir = RIGHT;  
				//granicai += 2;
				i++;
				j++;
			}
			break;
		}
		}
		if((i == SIZE / 2 || i == SIZE / 2 + 1)&&(j == SIZE / 2  || j == SIZE / 2 + 1)) test = 0;  
	}
	for(i = 0; i < SIZE; i++){
		for(j = 0; j < SIZE; j++)
			cout << tab[i][j];
		cout << endl;
	}
	
	return 0;
}