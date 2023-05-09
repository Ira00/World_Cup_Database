#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.
echo $($PSQL "TRUNCATE TABLE games, teams;")

cat games.csv | while IFS="," read year round winner opponent winner_goals opponent_goals
do
  if [[ $year != 'year' ]]
  then
    winner_id="$($PSQL "select team_id from teams where name='$winner'")"
    if [[ -z $winner_id ]]
    then
      INSERT_WINNER_RESULT=$($PSQL "INSERT INTO teams(name) VALUES('$winner')")
      if [[ $INSERT_WINNER_RESULT == "INSERT 0 1" ]]
      then
        echo Inserted into teams, $winner
      fi
      winner_id=$($PSQL "SELECT team_id FROM teams WHERE name='$winner'")
    fi
    
    opponent_id="$($PSQL "select team_id from teams where name='$opponent'")"
    if [[ -z $opponent_id ]]
    then 
      INSERT_OPPONENT_RESULT=$($PSQL "INSERT INTO teams(name) VALUES('$opponent')")
      if [[ $INSERT_OPPONENT_RESULT == "INSERT 0 1" ]]
      then
        echo Inserted into teams, $opponent
      fi
      opponent_id=$($PSQL "SELECT team_id FROM teams WHERE name='$opponent'")
    fi

    INSERT_INTO_GAMES=$($PSQL "INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) VALUES($year, '$round', $winner_id, $opponent_id, $winner_goals, $opponent_goals)")
    if [[ $INSERT_INTO_GAMES == "INSERT 0 1" ]]
    then
      echo Inserted into games $year, $round, $winner_id, $opponent_id, $winner_goals, $opponent_goals
    fi

  fi
done