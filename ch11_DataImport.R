# Read in tidy verse
library("tidyverse")

# read_csv file is from readr package

# Read in directly
foo_tibble = read_csv("a,b,c
											1,2,3
											4,5,6")
print(foo_tibble)

# Skip n lines
foo_tibble = read_csv("First line
											 Second line
											 # This is a comment
											 a,b,c
											 1,2,3
											 4,5,6",
											skip = 3
											)
print(foo_tibble)

# Skip comment lines beginning with #
foo_tibble = read_csv("# This is a comment
											 a,b,c
											 1,2,3
											 4,5,6",
											comment = "#"
										)
print(foo_tibble)

# Specify column names by col_names
foo_tibble = read_csv("1,2,3\n4,5,6", col_names = c("x", "y", "z"))
print(foo_tibble)

# Specify NA value
foo_tibble = read_csv("1,2,3\n4,5,6\n7,NA,9", col_names = c("x", "y", "z"), na = "NA")
print(foo_tibble)

# Parsing a vector

# Parse as logical
foo_log = str(parse_logical(c("TRUE", "FALSE", "NA")))

# Parse as integer
foo_int = str(parse_integer(c("1", "2", "3")))

# Parse as date
foo_date = str(parse_date(c("2010-01-01", "1979-10-14")))

# Parse with specifying NA value
foo = parse_integer(c("1", "231", ".", "456"), na = ".")

# Parse Numbers
# parse_double() is strict numeric parser
# parse_number() is flexible numeric parser (ignores non-numeric characters before and after the number)
foo = parse_double("1.23")
print(foo)

foo = parse_number("$100")
print(foo)

# parse_number can also extract number from sentence
#  Note: only extracts the first number it encounters
foo = parse_number("It cost $123.45")
print(foo)

foo = parse_number("5 weeks ago it cost $123.45")
print(foo)

# Parse Strings
# Get the hexadecimal representation of each letter
# Represents the ASCII encoding (i.e. the mapping from hexademical number to character)
# ASCII - American Standard Code for Information Interchange
foo = charToRaw("Hadley")
print(foo)

# Latin1 (ISO-8859-1, Western European) v. Latin2 (ISO-8859-2, Eastern European)
#  byte b1 is "+/-" in Latin1 but special 'a' character in Latin2
# UTF-8 is the preferred standard as can support both Latin1 and Latin2 characters (and emojis)
# readr always write in UTF-8 but assumes input data is UTF-8 as default, which may
# fail for older systems.  Thus, need to specify encoding
x1 = "El Ni\xf1o was particularly bad this year"
print(x1)
print(parse_character(x1))
print(parse_character(x1, locale = locale(encoding = "Latin1")))

x2 = "\x82\xb1\x82\xf1\x82\xc9\x82\xbf\x82\xcd"
print(x2)
print(parse_character(x2))
print(parse_character(x2, locale = locale(encoding = "Shift-JIS")))

# readr has a guess_encoding that will attempt to find the right encoding
# Argument to guess_encoding can be path to file or raw vector of hexadecimals
print(guess_encoding(charToRaw(x1)))
print(guess_encoding(charToRaw(x2)))

# Factors
# R uses factors to represent categorical variables that have a known set of possible values
# Define the possible values by setting the 'levels' parameter of parse factor
fruit = c("apple", "banana")
foo = parse_factor(c("apple", "banana", "bananana"), levels = fruit)
print(foo)

# Can also let R automatically determine factor levels based on entries
foo = parse_factor(c("apple", "pear", "apple", "banana", "grapes", "pear"))
print(foo)
print(levels(foo))
print(foo)

# Dates, date-times, and times
# Three parsers depending on type of time measurement

# parse_datetime() expects ISO8601 date-time
#		ISO8601 is an international standard in which the components of a date are
#		organized from biggest to smallest: year, month, day, hour, minute, second
#		This is the most important date/time standard - https://en.wikipedia.org/wiki/ISO_8601

parse_datetime("2010-10-01T2010")
#> [1] "2010-10-01 20:10:00 UTC"

# If time is omitted, it will be set to midnight
parse_datetime("20101010")
#> [1] "2010-10-10 UTC"

# parse_date() expects a 4 digit year, 2-digit month, and 2-digit day
# delimited by '-' or '/'
parse_date("2020-10-01")
parse_date("2020/10/01")

# Use hms package for parse_time
# parse_time() expects 'hour:minutes[:seconds] [am/AM/pm/PM]'
library("hms")
parse_time("01:10")
# 01:10:00
parse_time("01:10 PM")
# 13:10:00
parse_time("01:10:05 PM")
# 13:10:05
parse_time("01:10:05")
# 01:10:05
parse_time("13:10:05")
# 13:10:05

parse_date("01/02/15", "%m/%d/%y")
#> [1] "2015-01-02"
parse_date("01/02/15", "%d/%m/%y")
#> [1] "2015-02-01"
parse_date("01/02/15", "%y/%m/%d")
#> [1] "2001-02-15"
parse_date("2020-07-05", "%Y-%m-%d")
# [1] "2020-07-05"

parse_datetime("2020-07-05 06:05 PM", "%Y-%m-%d %I:%M %p")
# [1] "2020-07-05 18:05:00 UTC"

# Find current timezone
Sys.timezone()
# [1] "America/New_York"

# Get all timezones
OlsonNames()

# Unless otherwise specified, lubridate always uses UTC. UTC (Coordinated
# Universal Time) is the standard time zone used by the scientific community and
# roughly equivalent to its predecessor GMT (Greenwich Mean Time). It does not
# have DST, which makes a convenient representation for computation.
library("lubridate")
x1 = ymd_hms("2015-06-01 12:00:00", tz = "America/New_York")
#> [1] "2015-06-01 12:00:00 EDT"
ymd_hms("2015-07-05 06:14:00 PM", tz = "America/New_York")
# [1] "2015-07-05 18:14:00 EDT"
x2 <- ymd_hms("2015-06-01 18:00:00", tz = "Europe/Copenhagen")
#> [1] "2015-06-01 18:00:00 CEST"
x3 <- ymd_hms("2015-06-02 04:00:00", tz = "Pacific/Auckland")
#> [1] "2015-06-02 04:00:00 NZST"

# Section 11.4 - Parsing a file readr uses a heuristic to figure out the type of
# each column: it reads the first 1000 rows and uses some (moderately
# conservative) heuristics to figure out the type of each column. You can
# emulate this process with a character vector using guess_parser(), which
# returns readr’s best guess, and parse_guess() which uses that guess to parse
# the column:
# The heuristic tries each of the following types, stopping when it finds a match:
#
# logical: contains only “F”, “T”, “FALSE”, or “TRUE”.
# integer: contains only numeric characters (and -).
# double: contains only valid doubles (including numbers like 4.5e-5).
# number: contains valid doubles with the grouping mark inside.
# time: matches the default time_format.
# date: matches the default date_format.
# date-time: any ISO8601 date.
# If none of these rules apply, then the column will stay as a vector of strings.

# Example of a failure of read_csv strategy
# The first 1,000 lines of 2nd column are only NA, so guess is logical vector
# However, starting at row 1001, the values are dates
challenge <- read_csv(readr_example("challenge.csv"))
problems(challenge)

# Change y column to parse as date
challenge <- read_csv(
	readr_example("challenge.csv"),
	col_types = cols(
		x = col_double(),
		y = col_date()
	)
)
# Every parse_xyz() function has a corresponding col_xyz() function. You use
# parse_xyz() when the data is in a character vector in R already; you use
# col_xyz() when you want to tell readr how to load the data.

# If you want to be really strict, use stop_for_problems(): that will throw an
# error and stop your script if there are any parsing problems.
stop_for_problems(challenge)

# Strategies to help with reading data in
# Strategy 1 - increase number of rows to sample (default is 1,000)
challenge2 <- read_csv(readr_example("challenge.csv"), guess_max = 1001)
#> Parsed with column specification:
#> cols(
#>   x = col_double(),
#>   y = col_date(format = "")
#> )
challenge2
#> # A tibble: 2,000 x 2
#>       x y
#>   <dbl> <date>
#> 1   404 NA
#> 2  4172 NA
#> 3  3004 NA
#> 4   787 NA
#> 5    37 NA
#> 6  2332 NA
#> # … with 1,994 more rows

# Strategy 2 - first read in the columns as character vectors and then
# manually try to parse each column
challenge2 <- read_csv(readr_example("challenge.csv"),
											 col_types = cols(.default = col_character())
)
type_convert(challenge2)

# Can also read as a character vector of lines with read_lines() or
# or character vector of length 1 with read_file()

# Section 11.5 - writing files
# Three options:
#  write_csv()
#  write_tsv()
#  write_excel_csv() - contains a byte-order mark specifying to Excel that
#                      this is using UTF-8 encoding
write_csv(x = challenge2, path = "challenge2.csv")
write_tsv(x = challenge2, path = "challenge2.tsv")
write_excel_csv(x = challenge2, path = "challenge2_excel.csv")

# In order to write and store temporary files, can use write_rds() and
# read_rds(), which are wrappers around readRDS() and saveRDS() and utilize
# R custom binary format

# feather package - fast binary format supported across different programming
# languages
library(feather)
write_feather(challenge, "challenge.feather")
read_feather("challenge.feather")

# Feather tends to be faster than RDS and is usable outside of R. RDS supports
# list-columns (which you’ll learn about in many models); feather currently does
# not.

# Section 11.6 - Other types of data
# To get other types of data into R, we recommend starting with the tidyverse
# packages listed below. They’re certainly not perfect, but they are a good
# place to start. For rectangular data:
#
# haven reads SPSS, Stata, and SAS files.
#
# readxl reads excel files (both .xls and .xlsx).
#
# DBI, along with a database specific backend (e.g. RMySQL, RSQLite, RPostgreSQL
# etc) allows you to run SQL queries against a database and return a data frame.
#
# For hierarchical data: use jsonlite (by Jeroen Ooms) for json, and xml2 for
# XML. Jenny Bryan has some excellent worked examples at
# https://jennybc.github.io/purrr-tutorial/.
#
# For other file types, try the R data import/export manual and the rio package.