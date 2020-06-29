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
parse_time("01:10 PM")
parse_time("01:10:05 PM")
parse_time("01:10:05")
parse_time("13:10:05")
parse_time("1:10:05")