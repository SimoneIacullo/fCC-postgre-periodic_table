#!/bin/bash
shopt -s lastpipe
PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

if [[ $1 ]]
then
  INPUT=$1
  CONTROL="false"
  CHECK=$($PSQL "SELECT * FROM elements")
  echo "$CHECK" | while IFS='|' read A_N SYMBOL NAME
  do
    if [[ $INPUT == $A_N ]]
    then
      TYPE=$($PSQL "SELECT type FROM types INNER JOIN properties ON types.type_id = properties.type_id WHERE atomic_number = '$INPUT';")
      ATOMIC_MASS=$($PSQL "SELECT atomic_mass FROM properties WHERE atomic_number = '$INPUT';")
      MELTING_POINT=$($PSQL "SELECT melting_point_celsius FROM properties WHERE atomic_number = '$INPUT';")
      BOILING_POINT=$($PSQL "SELECT boiling_point_celsius FROM properties WHERE atomic_number = '$INPUT';")
      echo "The element with atomic number $A_N is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING_POINT celsius and a boiling point of $BOILING_POINT celsius."
      CONTROL="true"
    elif [[ $INPUT == $SYMBOL ]]
    then
      TYPE=$($PSQL "SELECT type FROM types INNER JOIN properties ON types.type_id = properties.type_id INNER JOIN elements ON properties.atomic_number = elements.atomic_number WHERE symbol = '$INPUT';")
      ATOMIC_MASS=$($PSQL "SELECT atomic_mass FROM properties INNER JOIN elements ON properties.atomic_number = elements.atomic_number WHERE symbol = '$INPUT';")
      MELTING_POINT=$($PSQL "SELECT melting_point_celsius FROM properties INNER JOIN elements ON properties.atomic_number = elements.atomic_number WHERE symbol = '$INPUT';")
      BOILING_POINT=$($PSQL "SELECT boiling_point_celsius FROM properties INNER JOIN elements ON properties.atomic_number = elements.atomic_number WHERE symbol = '$INPUT';")
      echo "The element with atomic number $A_N is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING_POINT celsius and a boiling point of $BOILING_POINT celsius."
      CONTROL="true"
    elif [[ $INPUT == $NAME ]]
    then
      TYPE=$($PSQL "SELECT type FROM types INNER JOIN properties ON types.type_id = properties.type_id INNER JOIN elements ON properties.atomic_number = elements.atomic_number WHERE name = '$INPUT';")
      ATOMIC_MASS=$($PSQL "SELECT atomic_mass FROM properties INNER JOIN elements ON properties.atomic_number = elements.atomic_number WHERE name = '$INPUT';")
      MELTING_POINT=$($PSQL "SELECT melting_point_celsius FROM properties INNER JOIN elements ON properties.atomic_number = elements.atomic_number WHERE name = '$INPUT';")
      BOILING_POINT=$($PSQL "SELECT boiling_point_celsius FROM properties INNER JOIN elements ON properties.atomic_number = elements.atomic_number WHERE name = '$INPUT';")
      echo "The element with atomic number $A_N is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING_POINT celsius and a boiling point of $BOILING_POINT celsius."
      CONTROL="true"
    fi
  done
  if [[ $CONTROL == "false" ]]
  then
    echo "I could not find that element in the database."
  fi
else
  echo "Please provide an element as an argument."
fi
