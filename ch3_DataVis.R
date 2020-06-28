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