Advent of Code 2022

Note:  A lot of these solutions likely suck due to time pressures or lack of knowledge on my part.  I won't go back to previous solutions to "fix" them, even if I come up with a better way to do it.  Should be a good reference for any learning I *might* be doing.

I heard about this exercise a few months ago and figured I'd give it a shot.  There is a typically an exponential decrease in the number of coders able to successfully solve all 25 days of AoC ... let's see how far I get.

Day 1:  Adding groups of numbers.  Pretty easy.

Day 2:  Rock, paper, scissors.  Very un-graceful/brute force method to solve this one, cuz I was busy and didn't want to think too hard.

Day 3:  Converting character sequences to numbers, then manipulating those numbers.  Haven't had a lot of practice with advanced sequence iterators and manipulators, so this was interesting.

Day 4:  4am after 15 hours of work and have to be back at work in eight hours means I put very little thought into this one and just brute-forced it.  Still, it worked on the first try!  Not proud of it, but done.

Day 5:  Combining regex and sequences.  Cool stuff and more elegant (though likely not very efficient) than the previous brute-force work.  The two methods for today's parts could've been combined into a single function to prevent repeated code, but I split them out to be able to more easily return answers from each part independently.

Day 6:  A surprisingly straight-forward solution to this one, and short.

Day 7:  Ouch.  Recursions and summations and reverse propogation, oh my.  Learned some new stuff today (Tables, string scans).  Needed some help to get over a summation hurdle, so had to consult the experts over on the nim forums.  Way more difficult that day 6, though I think this could be much simpler.  This doesn't bode well...

Day 8:  Not too bad, just iterating through a few sequences and using some basic algorithm functions.  Not very graceful, runs through a 100x100 forest in about 0.03 seconds, not including compilation time.

Day 9:  Initially attacked this all wrong until I realized it was simple coordinate addition.  Handled a couple edge cases and done!

Day 10:  Pretty straightforward: add and check position.  Rinse and repeat.

Day 11:  Mostly straightforward, but the drop in worry divisor in the second part threw me for a loop for a while.  Just needed a big number to divide everything by to prevent the integer overflow.

Day 12:  Running behind!  Work and family commitments kept me away for a few days.  I learned of the whole Dijkstra algorithm, apparently after everyone else in the world.  Finding the distance up the hill was pretty straightforward once I figured out how to code the algorithm.  However, for the way down, instead of checking the shortest path for each available 'a', I reversed the algorithm and started from 'E' to find the closest 'a', making the process way faster.  Neat.

Day 13: Still behind.  Tried to do this via npeg for a while with about 99% success, but it had a lot of trouble with recursion on empty lists list `[[[]]]`, so I moved over to json since the inputs all looks like arrays.  Pretty easy after that.  The final portion of the code with all the `foldl` was code I picked up elsewhere as I my mind isn't obtuse enough for that.

Day 14:  This one was interesting.  It didn't have to be done with an actual grid of sequences, but I did it that way to visualize it when I was debugging.  I need to learn a bit more about sequence modification (`map`, etc.), but I did write my first effective iterator in this exercise, so there's that.

Day 15:  Had to redo Part 2 because it was soooo sloooow.  Found some interesting ideas on the megathread and implemented one of them to drop the processing time from hours to milliseconds.  Lots of really smart people out there, apparently I'm not among them.

Day 16:  Oh, good lord.  I had no idea how to start (or finish) this one.  After a bit of research, I stumbled onto the floyd-warshall method for using matrix math to calculate the required distances to each valve, so building all the matrices was easy.  I had no idea where to go from there and after spending (wasting?) several hours trying to start a solution, I consulted the megathread and fully lifted the pressure calculation portion.  I realized that I'd reached a limitation on this puzzle, so I used it as a learning experience.  Also, forced the use of npeg to parse the input, which worked great.  Scanf has been working, but I wanted to try something different here.

Day 17:  Ugh.  No files.  Corrupted before I could finish part 2.  Might come back to this.  (edit) Throwing up someone else's work here just to have a record for reference if I ever need it.  Part 1 is just Tetris, which was pretty easy.  Something happened with my files and corrupted my source code before I finished Part 2.  Only 1 star for me today because my Part 1 worked (on the first try!).  Part 2 was too demoralizing the first time for me to go back and re-attempt, so here's someone else's code for you too look at (note:  this code didn't work for my input, but was very close).

Day 18:  Nice.  Pretty straightforward, especially Part 1.  Basic flood filling did the trick for Part 2.

Day 19:  Still working... my brain hurts.  (edit) So looks like this is just going to be a learning experiment for me.  I really had no idea how to approach this, though I understood it needed a DFS/BFS analysis to get it done.  I'm not quite there in nim, so the code for this day is not mine **at all**.  No star for me today, but keeping this here in case I need some learning later on.

Day 20:  Nice break from the constant optimizing (of which I am obviously not very good at).  Pretty simple implementation of a circular buffer/array.