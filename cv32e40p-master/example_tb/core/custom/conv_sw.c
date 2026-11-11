#include <stdint.h>

int convolution(int *data, int *weight)
{
    int sum = 0;

    for(int i=0;i<9;i++)
    {
        sum += data[i] * weight[i];
    }

    return sum;
}


int main()
{
    int data[9] =
    {
        1,2,3,
        4,5,6,
        7,8,9
    };

    int weight[9] =
    {
        1,0,-1,
        1,0,-1,
        1,0,-1
    };


    int result;

    result = convolution(data,weight);


    while(1);

    return result;
}