# programming question: what is the result of
# https://mdsol.jiveon.com/docs/DOC-7392

str = "hello world"   
str["world"] = "moon"

# the [] method on string allows for various indexing into the string, depending
# upon the parameters
# str[start, length], str[range] gives a substring or nil
# str[regex] gives the matching portion of the string or nil
# str[regex, capture] gives the matching portion as MatchData
# str[match_string] returns the portion of the string that matches
#
# the assignment then replaces that portion

