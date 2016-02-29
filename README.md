## Project Coleslaw

A simple implementation of the classic parlor game 'Salad Bowl' (aka 'Celebrity'). A charades-style game where where everyone writes down 1 person, 1 place, and 1 thing on individual scraps of paper and then combines them all in a bowl. The group is split into two teams: we'll call Team A and Team B. First, someone from Team A stands up, picks an item out of the bowl (in our case it would appear on their app) and tries to get the rest of their team to guess what the item is (without using the word). The person does this as many times as they can in 1 minute (they're allowed as many passes as they need). After this, a person from Team B stands up and does the same, then a new person from Team A, etc.

## Flows

### Logged out
- Static series of pages explaining how the game works
- Sign-up / log-in

### Create a game
- Options for start of game
  - Manual
  - Automatic [Optional]
- Assign people
  - Manual
  - Automatic [Optional]

### Join a game
- Enter name
- Take picture / choose picture [Optional]

### When manually creating the objects
- Enter person
- Enter place
- Enter thing

### Game
- Push notification (“You’re up!”)
- Before turn starts
  - Timer at 1:00
  - Button to start the round
  - Score summary
- During gameplay
  - Item on screen
  - Timer counting down
  - Success button
  - Pass / fail button
- End of round screen
  - Summary of pts in round
  - Avatar / name of next person
- End of game screen
  - Winner / losers
  - Score summary
