# ask for input from user (or stdin or whatever)
# for every input received:
#   if unique, keep it
#   if non-unique, report non-unique
#     bonus/extra: ...and how many times we've seen it
#       bonus/extra: interactively or via batch? Good thinking


# easy:
#   could simply collect everything, then detect duplicates and counts
#
# better:
#   use a hash or set, and detect/probe for existence, and increment a value
