#!/bin/bash


PSQL="psql -X --username=freecodecamp --dbname=salon --tuples-only -c"

MAIN_MENU() {
  echo -e "\n~~~~ MY SALON ~~~~\n"

  echo -e "Welcome to My Salon, how can I help you?\n"

  LIST_OF_SERVICES=$($PSQL "SELECT * FROM services;")

  echo "$LIST_OF_SERVICES" | while read ID SERVICE
  do
    echo "$ID) $SERVICE" | sed 's/ |//'
  done

  read SERVICE_ID_SELECTED

  if [[ ! $SERVICE_ID_SELECTED =~ ^[0-9]+$ ]]
  then
  MAIN_MENU "Please enter a number from the list"
  else
  
  echo -e "What's your phone number?\n"
  read CUSTOMER_PHONE

  CUSTOMER_NAME=$($PSQL "SELECT name FROM customers WHERE phone='$CUSTOMER_PHONE'")

  if [[ -z "$CUSTOMER_NAME" ]]
  then
  echo -e "I don't have a record for that phone number, what's your name?\n"
  read CUSTOMER_NAME
  INSERT_CUSTOMER=$($PSQL "INSERT INTO customers (phone,name) VALUES ('$CUSTOMER_PHONE', '$CUSTOMER_NAME');")
  SERVICE_NAME=$($PSQL "SELECT name FROM services WHERE service_id = $SERVICE_ID_SELECTED")
  echo -e "What time would you like your"$SERVICE_NAME", "$CUSTOMER_NAME"?\n"
  read SERVICE_TIME
  #Get customer ID
  CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone='$CUSTOMER_PHONE'" )

  #APPEND CUSTOMER INTO CUSTOMERS AND APPOINTMENT INTO APPOINTMENTS TABLES
  INSERT_APPOINTMENT=$($PSQL "INSERT INTO appointments (customer_id, service_id, time) VALUES ($CUSTOMER_ID, $SERVICE_ID_SELECTED, '$SERVICE_TIME')")

  if [[ "$INSERT_APPOINTMENT" == "INSERT 0 1" ]]
  then
  echo I have put you down for a"$SERVICE_NAME" at "$SERVICE_TIME", "$CUSTOMER_NAME".
  fi

  else
  echo -e "What time would you like your"$SERVICE_NAME","$CUSTOMER_NAME"?\n"
  SERVICE_NAME=$($PSQL "SELECT name FROM services WHERE service_id = $SERVICE_ID_SELECTED")
  
  read SERVICE_TIME
  #Get customer ID
  CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone='$CUSTOMER_PHONE'" )

  #APPEND CUSTOMER INTO CUSTOMERS AND APPOINTMENT INTO APPOINTMENTS TABLES
  INSERT_APPOINTMENT=$($PSQL "INSERT INTO appointments (customer_id, service_id, time) VALUES ($CUSTOMER_ID, $SERVICE_ID_SELECTED, '$SERVICE_TIME')")
  echo I have put you down for a"$SERVICE_NAME" at "$SERVICE_TIME","$CUSTOMER_NAME".

  fi
  fi

}



MAIN_MENU