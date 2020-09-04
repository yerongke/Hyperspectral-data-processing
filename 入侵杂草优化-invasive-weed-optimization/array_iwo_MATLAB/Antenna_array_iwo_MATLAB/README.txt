The code to synthesize linear antenna array using IWO technique is provided in MATLAB.
To run the program execute 'iwoantenna.m' 
The required inputs will be asked in a user friendly way.



Guide to inputs-
1.Number of runs-Enter the number of times the whole program will run.For generating statistical data we had to
run the program fifty times.
2.Number of iterations- Here you need to enter the number of iterations that will be executed in each run.
100 iterations is enough for the program to converge.
3.Number of dimensions-Here you need to enter half the number of elements in the antenna array because of its
symmetry.
4.Enter number of Sidelobe levels for the given problem
5.Enter upper limit of sidelobe
6.Enter lower limit of sidelobe.You will need to provide the two limits of all the SLL's serially.
7.Enter number of null placements
8.Enter all the null angles one by one.



FUNCTION DESCRIPTION-
1.iwoantenna                Main function
2.initialise_weeds          Function that initialises population at the beginning of each run
3.functional_value          Calculates fitness of plant
4.clamp_antenna             The weed or seed is clamped if it crosses the search space
5.array_factor              The array factor is calculated
6.trapezoidal               Here integration is performed by trapezoidal rule


OUTPUT:
The best fitness of each run ar given in command window with the array elements.The mean and standard deviation
is displayed next.The Gain(db)vs. Azimuth angle(deg) plot is displayed for the median solution.