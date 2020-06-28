# Check if tidyverse is installed.  If not, install
if(! "tidyverse" %in% rownames(installed.packages())){
	cat("Installing tidyverse...")

	# Specify type="binary" for Windows since installation from source is typically unsuccessful
	install.packages("tidyverse", dependencies=T, type="binary")

}

# Update packages from previous version
#update.packages(checkBuilt=T, ask=F)

# Load in tidyverse
library("tidyverse")

# mpg is a sample dataframe in ggplot2 that lists US EPA metrics for 38 cars

# Create a plot between engine size (displ) and highway gas mileage (hwy)
# Note this will not display a graph if sourced
#  Requires 'source with echo' or explicit print of the object
mpg_plot = ggplot(data = mpg) + geom_point(mapping = aes(x = displ, y = hwy))
print(mpg_plot)


# Follows the template:
# ggplot(data = <DATA>) + <GEOM_FUNCTION>(mapping = aes(<MAPPINGS>))
# ggplot() creates coordinate system that can have layers added
# geom_point() is a layer for creating a scatter plot
#  within each layer, there is a mapping argument that defines how variables in the dataset are mapped to visual properties
#  requires aes() method (for 'Aesthetic'), the specifies which variables within the ggplot data should be used to map to the x and y axes
#    Aesthetic mapping describe how variables in the data are mapped to visual properties (aesthetics) of geoms

# Create a plot between engine size (displ) and highway gas mileage (hwy) and color by car type (class)
# Note this will not display a graph if sourced
ggplot(data = mpg) + geom_point(mapping = aes(x = displ, y = hwy, color = class))

# Create a plot between engine size (displ) and highway gas mileage (hwy),
# color by car type (class), size by cylinders
#  Note: size should only be used for ordered variables
# Note this will not display a graph if sourced
ggplot(data = mpg) + geom_point(mapping = aes(x = displ, y = hwy, color = class, size = cyl))

# Create a plot between engine size (displ) and highway gas mileage (hwy),
# color by car type (class), size by cylinders (cyl), shape by fuel type
#  Note: size should only be used for ordered variables
#  Note: shape will only display six descrete shapes
# Note this will not display a graph if sourced
ggplot(data = mpg) +
	geom_point(mapping = aes(x = displ, y = hwy, color = class,
													 size = cyl, shape = fl
													)
						)

# Setting aesthetics outside the aes() will apply aesthetic to entire pointset
ggplot(data = mpg) +
	geom_point(mapping = aes(x = displ, y = hwy), color = "blue", size = 2, shape = 18)

# Facets
# Subplots that each display one subset of the data (e.g. trellis)
# Set trellis variable by prepending with '~'
ggplot(data = mpg) +
	geom_point(mapping = aes(x = displ, y = hwy)) +
	facet_wrap(~ class, nrow = 2)

# facet_grid is a two-way trellis
ggplot(data = mpg) +
	geom_point(mapping = aes(x = displ, y = hwy)) +
	facet_grid(drv ~ class)

ggplot(data = mpg) +
	geom_point(mapping = aes(x = displ, y = hwy)) +
	facet_wrap(~ class)

# facet_grid can also take a "." argument as a substitute for a variable.
# This means don't trellis in this direction.  So essentially these two are the same
# facet_wrap(~ class, nrow = 1)
# facet_grid(. ~ class)