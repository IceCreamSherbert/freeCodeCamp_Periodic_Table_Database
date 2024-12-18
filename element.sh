#! /bin/bash

# Reused variables
PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"
FULLJOIN="SELECT * FROM elements FULL JOIN properties USING(atomic_number) FULL JOIN types using (type_id)"

# Message when no argument is provided
if [[ -z $1 ]]
then
  echo "Please provide an element as an argument."
else

  # Match atomic number, fetch data, save to variables, display in format
  if [[ $1 =~ ^([0-9]|10)$ ]]
  then
    MATCH_ATOMIC_NUM=$($PSQL "$FULLJOIN WHERE atomic_number = $1")
    echo "$MATCH_ATOMIC_NUM" | sed 's/|/ /g' | while read -r ID ATOMIC_NUM SYMBOL NAME MASS MELT BOIL TYPE;
    do
      echo "The element with atomic number $ATOMIC_NUM is $NAME ($SYMBOL). It's a $TYPE, with a mass of $MASS amu. $NAME has a melting point of $MELT celsius and a boiling point of $BOIL celsius."
    done
  # Match symbol, fetch data, save to variables, display in format
  elif [[ $1 =~ ^[A-Z][a-z]?$ ]]
  then
    MATCH_SYMBOL=$($PSQL "$FULLJOIN WHERE symbol = '$1'")
    echo "$MATCH_SYMBOL" | sed 's/|/ /g' | while read -r ID ATOMIC_NUM SYMBOL NAME MASS MELT BOIL TYPE
    do
      echo "The element with atomic number $ATOMIC_NUM is $NAME ($SYMBOL). It's a $TYPE, with a mass of $MASS amu. $NAME has a melting point of $MELT celsius and a boiling point of $BOIL celsius."
    done
  # Match name number, fetch data, save to variables, display in format
  elif [[ $1 =~ ^[A-Z][a-z]+$ ]]
  then
    MATCH_NAME=$($PSQL "$FULLJOIN WHERE name = '$1'")
    echo "$MATCH_NAME" | sed 's/|/ /g' | while read -r ID ATOMIC_NUM SYMBOL NAME MASS MELT BOIL TYPE
    do
      echo "The element with atomic number $ATOMIC_NUM is $NAME ($SYMBOL). It's a $TYPE, with a mass of $MASS amu. $NAME has a melting point of $MELT celsius and a boiling point of $BOIL celsius."
    done
  # No match message
  else
    echo "I could not find that element in the database."
  fi

fi
