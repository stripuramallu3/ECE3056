//////////////////////////////////////
// Course: ECE-3056, Fall 2015
// Instructor: Sudhakar Yalamanchili
// Assignment 2: EnergyModel.c
//
// Name: Sreeramamurthy Tripuramallu
// GTID: 903057502
//////////////////////////////////////


#include <stdio.h>
#include <stdlib.h>
#include <math.h>

#define ARRAY_WIDTH 256  // Use 256 x 256 images for Assignment 2

int main (int argc, char *argv[])
{
  if (argc<3)
    {
      printf("Usage: <Input File with DCT of Image> <Name of File for writing Truncated DCT of Image> <int:Number of terms to discard in truncated DCT>\n");
      exit(-1);
    }

  FILE *inputfp;
  FILE *outputfp;
  double *array[ARRAY_WIDTH];
  int dctTerms = atoi(argv[3]);
  int idx = 0;
  int j = 0;
  int i = 0;
  char *buffer = NULL;
  char *ptr = NULL;
  size_t len = 0;
  ssize_t read;

  double numerator = 0;
  double denominator = 0;
  double reconstructionError = 0;
  double energy = 0;
  double power = 0;



  double test; // Can be removed. Only exists to test Skeleton code is working correctly
  double test_write;  // Can be removed. Only exists to test Skeleton code is working correctly

  // Open the input/file and read the DCT of the image of interest
  inputfp = fopen (argv[1], "r");      //open file as read only
  if (!inputfp)
    {
      fprintf (stderr, "failed to open file for reading\n");
      return 1;
    }
    // This is an example of how you read from an input file
    // and store the result in your own data structure (whichever
    // you like to choose).
    //
  while ((read = getline (&buffer, &len, inputfp)) != -1)
    {
        array[idx] = malloc (sizeof (array));
    // strtof() function converts the string pointed by the char pointer
    // into 'double'
        for (j = 0, ptr = buffer; j < ARRAY_WIDTH; j++, ptr++)
            array [idx][j] = strtof(ptr, &ptr); //Test line to validate Skeleton code can read from csv file

        idx++;

    }

    // Loop to display the array read from the file

    for (i=0; i<idx; i++) {
        printf ("\narray[%d][] =", i);

        for (j=0; j<ARRAY_WIDTH; j++)
            printf (" %lf", array[i][j]);
    }

    puts ("");

  fclose (inputfp);
//open file
outputfp = fopen(argv[2], "w");
//nested for-loop to traverse through array
for (i = 0; i < ARRAY_WIDTH; i++) {
    for (j = 0; j < ARRAY_WIDTH; j++) {
      //checks if the location of the pixel is outside the bounds
      if (i >= (ARRAY_WIDTH - dctTerms) || j >= (ARRAY_WIDTH - dctTerms)) {
        //if so, then prints a zero and update the numerator
        fprintf(outputfp, "0,");
        numerator += pow(array[i][j], 2);
      } else {
        //if not, then just print the original value of the array
        fprintf(outputfp, "%61f,", array[i][j]);
      }
      //update the value of the denominator
      denominator += pow(array[i][j], 2);
    }
  }
  //calcualte the reconstruction error
  reconstructionError = 100 * sqrt(numerator/denominator);

  //calculate energy, and use that to determine power
  energy = pow((ARRAY_WIDTH - dctTerms), 3);
  power = energy * 30;

  //print the power and reconstruction error
  printf("Energy: %f", energy); 
  printf("Power in fWatts: " "%f fwatts\n", power);
  printf("Reconstruction Error Percent: " "%f%%\n", reconstructionError);



  // Open the output/second file and write the contents of truncated DCT matrix into it
  if (outputfp == NULL)
    {
      fprintf(stderr, "Can't open output file %s!\n", argv[2]);
      exit(1);
    }

    test_write = array[2][2];

  fclose (outputfp);
  return 0;
}
