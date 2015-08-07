# Struck_Matlab
This is a matlab version of Struck:

Hare S, Saffari A, Torr P H S. Struck: Structured output tracking with kernels[C]//Computer Vision (ICCV), 2011 IEEE International Conference on. IEEE, 2011: 263-270.

####Note: 
For some reasons, I did not use the Haar features which provided in the original C++ impelmentation, instead of a HoG features.
And I utilze the particle filtering, not the sliding-window approach. So the proformance is not the same as the C++ implementation. But it will be simple to replace HoG with Haar.