#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.

echo $($PSQL "TRUNCATE games,teams")

cat games.csv | while IFS="," read -r year round winner opponent winner_goals opponent_goals;
do
  if [[ $year != 'year' && $round != 'round' && $winner != 'winner' && $opponent != 'opponent' && $winner_goals != 'winner_goals' && $opponent_goals != 'opponent_goals' ]]
   then
   #get winner id
   WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$winner'");
   #if not found
   if [[  -z $WINNER_ID  ]]
   #insert team_id
     then
     #insert team
     INSERT_WINNER=$($PSQL "INSERT INTO teams(name) VALUES('$winner')");
     if [[ $INSERT_WINNER == "INSERT 0 1" ]]
      then 
        echo $INSERT_WINNER
     #get winners
     WINNER_ID=$($PSQL"SELECT team_id FROM teams WHERE name='$winner'")
     WINNER_NAME=$($PSQL "SELECT name FROM teams WHERE team_id='$WINNER_ID'");
     echo "Insert success : ${WINNER_NAME}";
   fi
   fi

   #get opponent_id
   OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name= '$opponent'")
   #if not found
   if [[ -z $OPPONENT_ID ]]
   #insert team_id
   then
      #insert team
      INSERT_OPPONENT=$($PSQL "INSERT INTO teams(name) VALUES('$opponent')")
      # if inserted success
      if [[ $INSERT_OPPONENT == "INSERT 0 1" ]]
      then 
        echo $INSERT_OPPONENT
        # get new team_id
        OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$opponent'")
        OPPONENT_NAME=$($PSQL "SELECT name FROM teams WHERE team_id='$OPPONENT_ID'")
        echo "Insert success : ${OPPONENT_NAME}"
      fi
   fi

   #insert into games table
  INSERT_GAMES=$($PSQL "INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) VALUES($year,'$round',$WINNER_ID,$OPPONENT_ID,$winner_goals, $opponent_goals)")
    if [[ $INSERT_GAMES == "INSERT 0 1" ]]
    then
      echo $INSERT_GAMES;
      echo "Insert success : $year,'$round',$winner_id,$opponent_id,$winner_goals, $opponent_goals";
    fi
   fi
done
