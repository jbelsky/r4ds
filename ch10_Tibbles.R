# Open the library tidyverse
library("tidyverse")

# Can coerce standard R dataframes into tibbles with as_tibble() function
as_tibble(iris)

# tibble constructor
#   Note: auto-recycles inputs of length 1 (e.g. y = 1 for all 5 values)
#   Note: can refer to values just created (e.g. z variable defined by x and y variables)
foo_tibble = tibble(
	x = 1:5,
	y = 1,
	z = x ^ 2 + y
)

# Can also use tribble() (transposed tribble)
foo_tribble = tribble(
	~x, ~y, ~z,
	#-- | -- | --
	"a", 2, 3.6,
	"b", 1, 8.5
)
#print(foo_tribble)

# parameter n controls how many rows are displayed
# width = Inf will display all columns
foo_tribble %>% print(n = 1, width = Inf)

# RStudio built-in data viewer by %>% View()
#foo_tibble %>% View()

df = tibble(
	x = runif(5),
	y = rnorm(5)
)

# Subset with either $ or [[ ]]
# enframe() and deframe()
