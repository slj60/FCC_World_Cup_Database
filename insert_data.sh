if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.
cat games.csv | while IFS=',' read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
  CHECK_WINNER_NAME=$($PSQL "SELECT * FROM teams WHERE name='$WINNER'")
  CHECK_OPPONENT_NAME=$($PSQL "SELECT * FROM teams WHERE name='$OPPONENT'")
  if [[ -z $CHECK_WINNER_NAME && $WINNER != "winner" ]]
  then
    INSERT_WIN_NAME_RESULT=$($PSQL "INSERT INTO teams(name) VALUES('$WINNER')")
    if [[ $INSERT_WIN_NAME_RESULT == 'INSERT 0 1' ]]
    then
      echo Inserted $WINNER
    fi
  fi
  if [[ -z $CHECK_OPPONENT_NAME && $OPPONENT != 'opponent' ]]
  then
    INSERT_OPP_NAME_RESULT=$($PSQL "INSERT INTO teams(name) VALUES('$OPPONENT')")
    if [[ $INSERT_OPP_NAME_RESULT == 'INSERT 0 1' ]]
    then
      echo Inserted $OPPONENT
    fi
  fi
  GET_WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
  GET_OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")
  INSERT_GAME_RESULT=$($PSQL "INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) VALUES($YEAR, '$ROUND', $GET_WINNER_ID, $GET_OPPONENT_ID, $WINNER_GOALS, $OPPONENT_GOALS)")  
  if [[ $INSERT_GAME_RESULT == 'INSERT 0 1' ]]
  then
    echo Inserted game: $YEAR $ROUND $WINNER vs $OPPONENT
  fi
done
