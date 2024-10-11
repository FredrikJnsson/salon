#! /bin/bash

PSQL="psql -X --username=freecodecamp --dbname=salon --tuples-only -c"



BOOK_MENU() {
  echo -e "\n1) hair\n2) beard\n3) fade"
  read SERVICE_ID_SELECTED
  if [[ $SERVICE_ID_SELECTED != [1-3] ]]
  then
    BOOK_MENU
  else
    echo -e "\nWhat is your phone number?"
    read CUSTOMER_PHONE
    CUSTOMER_INPUT=$($PSQL"SELECT phone FROM customers WHERE phone = '$CUSTOMER_PHONE'")
    if [[ -z $CUSTOMER_INPUT ]]
    then
      echo What is your name?
      read CUSTOMER_NAME
      INSERT_CUSTOMER_ID=$($PSQL "INSERT INTO customers(phone, name) VALUES('$CUSTOMER_PHONE', '$CUSTOMER_NAME')")
    fi
    echo -e "\nWhat time?"
    read SERVICE_TIME
    #get customer id
    CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone = '$CUSTOMER_PHONE'")
    #INSERT RESULTS IN appointments table
    CUSTOMER_RESULT=$($PSQL "INSERT INTO appointments(customer_id, service_id, time) VALUES($CUSTOMER_ID, $SERVICE_ID_SELECTED, '$SERVICE_TIME')") 
    if [[ $CUSTOMER_RESULT == "INSERT 0 1" ]]
    then
      SERVICE_SELECTED=$($PSQL "SELECT name FROM services WHERE service_id = $SERVICE_ID_SELECTED")
      echo "I have put you down for a $SERVICE_SELECTED at $SERVICE_TIME, $CUSTOMER_NAME."
    fi  
  fi
}

BOOK_MENU
