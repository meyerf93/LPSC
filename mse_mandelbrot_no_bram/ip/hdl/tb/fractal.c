#include <stdio.h>
#include <unistd.h>
#include <stdlib.h>
#include<string.h>
#include <time.h>
#include <math.h>

#define rayon2 4.0
struct complex_number{
	float real;
	float imaginary;
	int iteration;
	float zn_real;
	float zn_imaginary;
};

int dectobin(int a){
int k, c;

for (c = 15; c >= 0; c--)
  {
    k = a >> c;
 
    if (k & 1)
      printf("1");
    else
      printf("0");
  }

}


int fractal (int debug,struct complex_number *c){
	
	int n = 0;
	
    c->zn_real = 0;
    c->zn_imaginary = 0;
        
    float zn1_real;
    float zn1_imaginary;
    if(debug)	{
    	printf("N\tZn_r\t\tZn_i\t\tRayon\n"); 
     	printf("--------------------------------------------------------\n");  
     } 
    for(int i = 0; i<101 ; i++){
    	if(debug)	printf("%d\t",i);
		zn1_real = (c->zn_real*c->zn_real - c->zn_imaginary* c->zn_imaginary + c->real);
		zn1_imaginary = (2*c->zn_real*c->zn_imaginary + c->imaginary);        
		
		if(debug){
			printf("%f\t",zn1_real);
			dectobin((int)(zn1_real*4096));
			printf("\t");
		}
		if(debug){
			printf("%f\t",zn1_imaginary);
			dectobin((int)(zn1_imaginary*4096));
			printf("\t");
		}
		c->zn_real = zn1_real;
		c->zn_imaginary = zn1_imaginary;
		if(debug)printf(" %f\n",(c->zn_real*c->zn_real)+(c->zn_imaginary*c->zn_imaginary));		
		if(rayon2 < ((c->zn_real*c->zn_real)+(c->zn_imaginary*c->zn_imaginary))){
			break;
		}
		n++;
    }
    if(n >= 100)	n=0;
    c->iteration = n; 
    
	return n;
}


int main(int argc, char *argv[])
{
		
		
		
        printf("Fractal %f\n",atof("4.901"));
		struct complex_number c;
		
		if(argc <= 1){
			printf("Enter a complex number :\n");
			printf("Real:\t");
			scanf("%f",&(c.real));

			printf("Imaginary:\t");
			scanf("%f",&(c.imaginary));		      
       	}
       	else{
       		c.real = atof(argv[1]);
       		c.imaginary = atof(argv[2]);	
       	}
       	
       	printf("Number is:\t%f+i*%f\n",c.real,c.imaginary);
        printf("--------------------------------------------------------\n");
        fractal(1,&c);
        printf("--------------------------------------------------------\n");
        
        printf("n:%d\tZn_r:%f\tZn_i:%f\n",c.iteration,c.zn_real,c.zn_imaginary);
        
}

