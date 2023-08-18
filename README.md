# Efficient Terrain Generator for Apple II
By Oleg Kobchenko

Terrain generating produces a random natural landscape for gaming, demos, and organic forms of sky clouds, plasma clouds, and even non-visual data. Arranged in a two-dimensional array for X and Y and values for height. Here the resulting 3D mesh is a flat contour made of color values with a certain area resolution (width and height in pixels) and the height range (possible colors).

Various methods for terrain generation exist. 1D Hill adds random sine curves, or progressive random mid-points, producing Brownian-looking curves. Cellular Automata Cave is a piano roll of 1D Game of Life, making organic but only 2-color contours. Voronoi Noise is interesting but too complex. Diamongd Square gradually adds random noise to a grid with averaging, thus producing nebulous features. Perlin Noise using gradients and interpolation produces highly realistic fine detail at the expense of complexity, as its marginally improved Simplex Noise. -- would be too slow for Apple II or in simpler cases would not produce a nice organic terrain.

So we use **Mean Smoothing with Mismatched Kernel**, an original approach with simple calculations, yet producing surprisingly believable terrains for its complexity. Each of 10 iterations works on the 2D array separately in each dimension: line-by-line then column-by-column – for radial smoothing. The Mean kernel convolution replaces each pixel with an average of its linear neighbors. To optimize division by shifting, we choose kernel width four -- an even number. So the starting pixel of each line oscillates by one to avoid drifting -- a small trade-off. The original image starts with random numbers in square blocks of 5x5, thus mismatching the kernel size, which prevent grid artifacts and banding. Furthermore, over 10 iterations of 2.5-pixel radius each pixel produces a receding ripple effect with radius of 25 pixels.

The DoLoRes mode provides 40x48 square pixel resolution and 16 colors. The data and calculations represented in bytes have 256 possible values. Since only 4 bits out of 8 are needed for 16 colors, to render the final surface we use the high 4 bits, thus applying a low-pass filter. The low 4 bits represent the finer granularity for the underlying smoothness. This can achieve some extra effects: cycling over the bits results in interesting palette shifting with a band-pass filter; narrowing the band can posterize the image producing walls and caves; and replacing the low bits with random noise in each iteration we can nebulize the result.

## Illustration of the algorithm using Posterizing

The **Blur** step represents the Mean smoothing. The **Posterize** step represents division and dropping of the low bits.

| Blur and Posterize steps  | Resulting Image |
| - | - |
| ![Test](image/terra.png)  | ![Test](image/terra7.png)  |
| Seed Image of random values | Expanding blocks |
| ![Test](image/terra1.png) | ![Test](image/terra2.png) |
| Generation 1 - Blur step | Generation 1 - Posterize step |
| ![Test](image/terra3.png) | ![Test](image/terra4.png) |
| Generation 2 | Generation 3 |
| ![Test](image/terra5.png) | ![Test](image/terra6.png) |
