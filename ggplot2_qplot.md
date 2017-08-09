ggplot2\_qplot
================

qplot basics
------------

-   Basic call: qplot(x, y, data,...)
-   You must tell qplot where the data comes from
-   Data must be in a data frame
-   Plots components:
    -   aesthetics: how data is mapped to size and color
    -   geoms: geometric objects like points, shapes, and lines
    -   facets: for conditional plots
    -   stats: statistical transformations like binning, quantiles, and smoothing
    -   scales: what scale an aesthetic map uses
    -   coordinate system
-   Factors are important for indicating subsets of data
-   qplot masks a lot of functionality, for many cases that is fine
    -   If you are looking to do something out of the scope of qplot's capabilities, switch to ggplot

**References:**

-   Majority of examples draw directly from the following sources
    -   website: <http://ggplot2.org>
    -   <http://ggplot2.org/book/>
    -   Coursera: Data Science (Johns Hopkins University), Exploratory Data Analysis, Course Material, ggplot2

Examples
--------

``` r
library(ggplot2)
```

    ## Warning: package 'ggplot2' was built under R version 3.4.1

``` r
library(gridExtra)
```

    ## Warning: package 'gridExtra' was built under R version 3.4.1

``` r
set.seed(1410) # Make the sample reproducible
dsmall <- diamonds[sample(nrow(diamonds), 100), ] # Make a random subset of diamonds
head(diamonds)
```

    ## # A tibble: 6 x 10
    ##   carat       cut color clarity depth table price     x     y     z
    ##   <dbl>     <ord> <ord>   <ord> <dbl> <dbl> <int> <dbl> <dbl> <dbl>
    ## 1  0.23     Ideal     E     SI2  61.5    55   326  3.95  3.98  2.43
    ## 2  0.21   Premium     E     SI1  59.8    61   326  3.89  3.84  2.31
    ## 3  0.23      Good     E     VS1  56.9    65   327  4.05  4.07  2.31
    ## 4  0.29   Premium     I     VS2  62.4    58   334  4.20  4.23  2.63
    ## 5  0.31      Good     J     SI2  63.3    58   335  4.34  4.35  2.75
    ## 6  0.24 Very Good     J    VVS2  62.8    57   336  3.94  3.96  2.48

**Variable definitions:**

-   **carat: **weight of the diamond (0.2--5.01)
-   **cut: **quality of the cut (Fair, Good, Very Good, Premium, Ideal)
-   **color: **diamond color, from J (worst) to D (best)
-   **clarity: **a measurement of how clear the diamond is (I1 (worst), SI2, SI1, VS2, VS1, VVS2, VVS1, IF (best))
-   **depth: **total depth percentage = z / mean(x, y) = 2 \* z / (x + y) (43--79)
-   **table: **width of top of diamond relative to widest point (43--95)
-   **price: ** price in US dollars ($326--$18,823)
-   **x: **length in mm (0--10.74)
-   **y: **width in mm (0--58.9)
-   **z: **depth in mm (0--31.8)

**Basic qplot:**

Carat is to price, carat is to log of price, carat is to mm<sup>3</sup>

``` r
plot1 <- qplot(carat, price, data = diamonds)
plot2 <- qplot(log(carat), log(price), data = diamonds)
plot3 <- qplot(carat, x * y * z, data = diamonds)
grid.arrange(plot1, plot2, plot3, nrow = 2)
```

![](ggplot2_qplot_files/figure-markdown_github-ascii_identifiers/example%20basic%20qplot-1.png)

**Plot point modifications by factor:**

Mapping point color to diamond color (left), and point shape to cut quality (right), and a combination there of (below)

``` r
plot1 <- qplot(carat, price, data = dsmall, colour = color)
plot2 <- qplot(carat, price, data = dsmall, shape = cut)
grid.arrange(plot1, plot2, ncol = 2)
```

![](ggplot2_qplot_files/figure-markdown_github-ascii_identifiers/example%20points%20by%20factor-1.png)

``` r
qplot(carat, price, data = dsmall, colour = color, shape = cut)
```

![](ggplot2_qplot_files/figure-markdown_github-ascii_identifiers/example%20points%20by%20factor%202-1.png)

**Use of transparency:**

Affecting transparency to highlight density by reducing the alpha value from 1/10 (left) to 1/100 (middle) to 1/200 (right) makes it possible to see where the bulk of the points lie.

``` r
plot1 <- qplot(carat, price, data = diamonds, alpha = I(1/10))
plot2 <- qplot(carat, price, data = diamonds, alpha = I(1/100))
plot3 <- qplot(carat, price, data = diamonds, alpha = I(1/200))
grid.arrange(plot1, plot2, plot3, ncol = 3)
```

![](ggplot2_qplot_files/figure-markdown_github-ascii_identifiers/example%20transparency-1.png)

**Adding curves:**

Smooth curves added to scatterplots of carat vs. price. The dsmall dataset (left) and the full dataset (right). Methods available for smoothing function via geom\_smooth(), {lm, glm, gam, loess, rlm}. Default smooth sets loess for &lt; 1000 observations, otherwise gam is used with formula = y ~ s(x, bs = "cs").

``` r
plot1 <- qplot(carat, price, data = dsmall, geom = c("point", "smooth"))
plot2 <- qplot(carat, price, data = diamonds, geom = c("point", "smooth"))
grid.arrange(plot1, plot2, ncol = 2)
```

    ## `geom_smooth()` using method = 'loess'

    ## `geom_smooth()` using method = 'gam'

![](ggplot2_qplot_files/figure-markdown_github-ascii_identifiers/example%20curves-1.png)

**Jitter and boxplot:**

Using jittering (left) and boxplots (right) to investigate the distribution of price per carat, conditional on color. As the color improves (from left to right) the spread of values decreases, but there is little change in the center of the distribution.

``` r
plot1 <- qplot(color, price / carat, data = diamonds, geom = "jitter")
plot2 <- qplot(color, price / carat, data = diamonds, geom = "boxplot")
grid.arrange(plot1, plot2, ncol=2)
```

![](ggplot2_qplot_files/figure-markdown_github-ascii_identifiers/example%20jitter%20vs%20boxplot-1.png)

**Jitter + transparency:**

Introduce transparency, from left to right: 1/5, 1/50, 1/200. As the opacity decreases we begin to see where the bulk of the data lies. However, the boxplot still does much better.

``` r
plot1 <- qplot(color, price / carat, data = diamonds, geom = "jitter",
 alpha = I(1 / 5))
plot2 <- qplot(color, price / carat, data = diamonds, geom = "jitter",
 alpha = I(1 / 50))
plot3 <- qplot(color, price / carat, data = diamonds, geom = "jitter",
 alpha = I(1 / 200))
grid.arrange(plot1, plot2, plot3, ncol=3)
```

![](ggplot2_qplot_files/figure-markdown_github-ascii_identifiers/example%20jitter%20and%20transparency-1.png)

**Histogram and density:**

Displaying the distribution of diamonds, geom = "histogram" (left), geom = "density".

``` r
plot1 <- qplot(carat, data = diamonds, geom = "histogram")
plot2 <- qplot(carat, data = diamonds, geom = "density")
grid.arrange(plot1, plot2, ncol=2)
```

    ## `stat_bin()` using `bins = 30`. Pick better value with `binwidth`.

![](ggplot2_qplot_files/figure-markdown_github-ascii_identifiers/example%20histogram%20vs%20density-1.png)

**Vary binwidth:**

Binwidths from left to right: 1, 0.1 and 0.01 carats. Only diamonds between 0 and 3 carats shown.

``` r
plot1 <- qplot(carat, data = diamonds, geom = "histogram", binwidth = 1, 
  xlim = c(0,3))
plot2 <- qplot(carat, data = diamonds, geom = "histogram", binwidth = 0.1,
  xlim = c(0,3))
plot3 <- qplot(carat, data = diamonds, geom = "histogram", binwidth = 0.01,
  xlim = c(0,3))
grid.arrange(plot1, plot2, plot3, ncol=3)
```

    ## Warning: Removed 32 rows containing non-finite values (stat_bin).

    ## Warning: Removed 32 rows containing non-finite values (stat_bin).

    ## Warning: Removed 32 rows containing non-finite values (stat_bin).

![](ggplot2_qplot_files/figure-markdown_github-ascii_identifiers/example%20binwidth-1.png)

**Mapping a categorical variable to an aesthetic:**

Mapping a categorical variable to an aesthetic will automatically split up the geom by that variable. (Left) Density plots are overlaid and (right) histograms are stacked.

``` r
plot1 <- qplot(carat, data = diamonds, geom = "density", colour = color)
plot2 <- qplot(carat, data = diamonds, geom = "histogram", fill = color)
grid.arrange(plot1, plot2, ncol=2)
```

    ## `stat_bin()` using `bins = 30`. Pick better value with `binwidth`.

![](ggplot2_qplot_files/figure-markdown_github-ascii_identifiers/example%20category%20to%20aesthetic-1.png)

**Weight:**

Bar charts of diamond color. The left plot shows counts and the right plot is weighted by weight = carat to show the total weight of diamonds of each color.

``` r
plot1 <- qplot(color, data = diamonds, geom = "bar")
plot2 <- qplot(color, data = diamonds, geom = "bar", weight = carat) +
  scale_y_continuous("carat")
grid.arrange(plot1, plot2, ncol=2)
```

![](ggplot2_qplot_files/figure-markdown_github-ascii_identifiers/example%20weight-1.png)

**Line graphs:**

Two time series measuring amount of unemployment. (Left) Percent of population that is unemployed and (right) median number of weeks unemployed. Plots created with geom="line".

``` r
head(economics)
```

    ## # A tibble: 6 x 6
    ##         date   pce    pop psavert uempmed unemploy
    ##       <date> <dbl>  <int>   <dbl>   <dbl>    <int>
    ## 1 1967-07-01 507.4 198712    12.5     4.5     2944
    ## 2 1967-08-01 510.5 198911    12.5     4.7     2945
    ## 3 1967-09-01 516.3 199113    11.7     4.6     2958
    ## 4 1967-10-01 512.9 199311    12.5     4.9     3143
    ## 5 1967-11-01 518.1 199498    12.5     4.7     3066
    ## 6 1967-12-01 525.8 199657    12.1     4.8     3018

``` r
plot1 <- qplot(date, unemploy / pop, data = economics, geom = "line")
plot2 <- qplot(date, uempmed, data = economics, geom = "line")
grid.arrange(plot1, plot2, ncol=2)
```

![](ggplot2_qplot_files/figure-markdown_github-ascii_identifiers/example%20line%20graphs-1.png)

**Path plots:**

Path plots illustrating the relationship between percent of people unemployed and median length of unemployment. (Left) Scatterplot with overlaid path. (Right) Pure path plot colored by year.

``` r
year <- function(x) as.POSIXlt(x)$year + 1900
plot1 <- qplot(unemploy / pop, uempmed, data = economics, 
   geom = c("point", "path"))
plot2 <- qplot(unemploy / pop, uempmed, data = economics, 
  geom = "path", colour = year(date)) + scale_size_area()
grid.arrange(plot1, plot2, ncol=2)
```

![](ggplot2_qplot_files/figure-markdown_github-ascii_identifiers/example%20path%20plots-1.png)

**Facets, histogram broken down by facet:**

Histograms showing the distribution of carat conditional on color. (Left) Bars show counts and (right) bars show densities (proportions of the whole). The density plot makes it easier to compare distributions ignoring the relative abundance of diamonds within each color.

High-quality diamonds (color D) are skewed towards small sizes, and as quality declines the distribution becomes more flat.

``` r
plot1 <- qplot(carat, data = diamonds, facets = color ~ ., 
  geom = "histogram", binwidth = 0.1, xlim = c(0, 3))
plot2 <- qplot(carat, ..density.., data = diamonds, facets = color ~ .,
  geom = "histogram", binwidth = 0.1, xlim = c(0, 3))
grid.arrange(plot1, plot2, ncol=2)
```

    ## Warning: Removed 32 rows containing non-finite values (stat_bin).

    ## Warning: Removed 32 rows containing non-finite values (stat_bin).

![](ggplot2_qplot_files/figure-markdown_github-ascii_identifiers/example%20histogram%20count%20vs%20histogram%20density%20by%20facet-1.png)

**Facet with non default trend:**

Carat is to price, faceted by color, color scaled by cut, with trend lines across cut set to method "lm".

``` r
qplot(carat, price, data=diamonds, color=cut, 
      facets = .~color) + 
        geom_smooth(method="lm")
```

![](ggplot2_qplot_files/figure-markdown_github-ascii_identifiers/example%20facet%20and%20multi-trend-1.png)

**Two facets with non default trend:**

Carat between \[0,3\] is to price, faceted by color and clarity, color scaled by cut, with trend lines across cut set to method "lm".

Ew, too much data

``` r
qplot(carat, price, data=diamonds, color=cut, 
      facets = clarity~color, xlim = c(0,3)) + 
        geom_smooth(method="lm")
```

    ## Warning: Removed 32 rows containing non-finite values (stat_smooth).

    ## Warning in qt((1 - level)/2, df): NaNs produced

    ## Warning: Removed 32 rows containing missing values (geom_point).

![](ggplot2_qplot_files/figure-markdown_github-ascii_identifiers/example%20multi-facet%20and%20multi-trend-1.png)
