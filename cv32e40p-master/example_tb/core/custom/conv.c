#include <stdint.h>

int convolution(
    int *input,
    int *kernel,
    int size
)
{
    int sum = 0;

    for(int i = 0; i < size; i++)
    {
        for(int j = 0; j < size; j++)
        {
            sum += input[i*size+j] * kernel[i*size+j];
        }
    }

    return sum;
}


int main()
{
    int input[9] =
    {
        1,2,3,
        4,5,6,
        7,8,9
    };


    int kernel[9] =
    {
        1,0,-1,
        1,0,-1,
        1,0,-1
    };


    int result;

    result = convolution(input,kernel,3);


    while(1);

    return result;
}