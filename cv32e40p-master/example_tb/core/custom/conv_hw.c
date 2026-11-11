#include <stdint.h>


int convolution_custom(int *data, int *weight)
{
    int result;


    asm volatile(
        ".word 0x00b5060b"
        : "=r"(result)
        : "r"(data), "r"(weight)
    );


    return result;
}


int main()
{

    int data[9]=
    {
        1,2,3,
        4,5,6,
        7,8,9
    };


    int weight[9]=
    {
        1,0,-1,
        1,0,-1,
        1,0,-1
    };


    int result;


    result = convolution_custom(data,weight);


    while(1);

    return result;
}