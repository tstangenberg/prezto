#
# Defines Pandoc <http://johnmacfarlane.net/pandoc> aliases and functions.
#
# Authors:
#   Thorben Stangenberg <thorben@stangenberg.net>
#

# Return if requirements are not found.
if (( ! $+commands[pandoc] )); then
  echo "pandoc is not installed --> prezto module pandoc not active"
  return 1
fi


#
# Aliases
#

#
# Functions
#

#  convert the given file to html
function pan {
  if [[ -f "$1" ]]
  then
  	pandoc -o $1.html $1
  fi
}
