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
ggplot(data = mpg) + geom_point(mapping = aes(x = displ, y = hwy))

# Follows the template:
# ggplot(data = <DATA>) + <GEOM_FUNCTION>(mapping = aes(<MAPPINGS>))
# ggplot() creates coordinate system that can have layers added
# geom_point() is a layer for creating a scatter plot
#  within each layer, there is a mapping argument that defines how variables in the dataset are mapped to visual properties
#  requires aes() method (for 'Aesthetic'), the specifies which variables within the ggplot data should be used to map to the x and y axes
#    Aesthetic mapping describe how variables in the data are mapped to visual properties (aesthetics) of geoms
