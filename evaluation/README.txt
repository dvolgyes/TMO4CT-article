Usage:

This directory should be enough to regenerate every image and number
used in the article, if the proper tools are installed.

Theoretically, executing "make" should be enough.

Note that there is a tiny change between TMQI.m and the
original code: matlab uses 'blkproc' and 'blockproc' function
names too, even though they refer to the same code.
Octave only allows 'blockproc'. This has been fixed in this
updated version.
