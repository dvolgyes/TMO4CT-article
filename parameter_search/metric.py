#!/usr/bin/python3
from skimage.measure import shannon_entropy
import scipy
import scipy.stats
import imageio
import sys
import numpy as np
from skimage.measure import shannon_entropy
import skimage
from skimage.filters.rank import entropy
from skimage.morphology import disk

import matplotlib.pyplot as plt


def eprint(*args, **kwargs):
    print(*args, file=sys.stderr, **kwargs)


def grad_magnitude(img):
    a, b = np.gradient(img)
    return np.sqrt(np.sum(np.power(a, 2.0)+np.power(b, 2.0)))/a.size


if __name__ == "__main__":

    version = tuple(map(int, skimage.__version__.split('.')))
    if version < (0, 14, 0):
        eprint('Skimage had a wrong shannon_entropy implementation.')
        eprint('Please, use v.0.14.0 or higher.')
        sys.exit(1)

    for f in sys.argv[1:]:
        img = imageio.imread(f)
        if len(img.shape) == 3:
            if (np.any(img[..., 0] != img[..., 1]) or
                    np.any(img[..., 0] != img[..., 2])):
                # Only grayscale images can be evaluated!
                img = np.median(img,axis=2)
            else:
                img = img[..., 0]
        print("%s  %.3f %.2f" % (f, grad_magnitude(img), shannon_entropy(img), ))
