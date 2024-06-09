#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.

echo "$($PSQL "TRUNCATE TABLE games, teams;")"

# READ THE CSV FILE
cat games.csv | while IFS=',' read -r year round winner opponent winner_goals opponent_goals

do
  # EVITATE THE FIRST LINE OF THE CSV FILE
  if [[ $year != "year" ]]
  then

    winner_id=$($PSQL "SELECT team_id FROM teams WHERE name='$winner';")

    if [[ -z $winner_id ]]

    then
      echo "$($PSQL "INSERT INTO teams(name) VALUES('$winner');")"
      winner_id=$($PSQL "SELECT team_id FROM teams WHERE name='$winner';")
    fi


    opponent_id=$($PSQL "SELECT team_id FROM teams WHERE name='$opponent';")

    if [[ -z $opponent_id ]]

    then
      echo "$($PSQL "INSERT INTO teams(name) VALUES('$opponent');")"
      opponent_id=$($PSQL "SELECT team_id FROM teams WHERE name='$opponent';")
    fi

    echo "$($PSQL "INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) VALUES($year, '$round', $winner_id, $opponent_id, $winner_goals, $opponent_goals);")"

  fi
done