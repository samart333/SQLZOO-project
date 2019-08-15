-- Select country of Germany

SELECT population FROM world
  WHERE name = 'Germany'



-- Select country of Sweden, Norway and Denmark

SELECT name, population FROM world
  WHERE name IN ('Sweden', 'Norway', 'Denmark');


-- Select countries with area between 200000 and 250000

SELECT name, area FROM world
WHERE area BETWEEN 200000 AND 250000



-- tutorial 2 Select from world

-- Show name, continent, population from world

select name, continent, population
from world

-- Show the name for the countries that have a population of at least 200 million
SELECT name FROM world
WHERE population >= 200000000


-- Give the name and the per capita GDP for those countries with a population of at least 200 million.
select name, gdp/population
from world
where population >= 200000000

-- Show the name and population in millions for the countries of the continent 'South America'. Divide the population by 1000000 to get population in millions.
select name, population/1000000
from world
where continent = 'South America'


-- Show the name and population for France, Germany, Italy
select name, population
from world
where name = 'France'
or name = 'Germany'
or name = 'Italy'

-- Show the countries which have a name that includes the word 'United'
select name
from world
where name like '%United%

-- Show the countries that are big by area or big by population. Show name, population and area

select name, population, area
from world
where area > 3000000 or population > 250000000

-- Exclusive OR (XOR). Show the countries that are big by area or big by population but not both. Show name, population and area.

select name, population, area
from world
where area > 3000000 xor population > 250000000

-- For South America show population in millions and GDP in billions both to 2 decimal places.

select name, round(population/1000000, 2), round(gdp/1000000000, 2)
from world
where continent = 'South America'

-- Show per-capita GDP for the trillion dollar countries to the nearest $1000.
select name, round(gdp/population, -3)
from world
where gdp >= 1000000000000

-- Show the name and capital where the name and the capital have the same number of characters.
SELECT name, capital
  FROM world
 WHERE length(name) = length(capital)

-- Show the name and the capital where the first letters of each match. Don't include countries where the name and the capital are the same word.
SELECT name, capital
FROM world
where left(name, 1) = left(capital, 1)and name <> capital

-- Query to show find the country that has all the vowels and no spaces in its name.

SELECT name
FROM world
WHERE name LIKE '%a%' AND name LIKE '%e%' AND name LIKE '%i%' AND name LIKE '%o%' AND name LIKE '%u%'
AND name NOT LIKE '% %';


tutorial 3
-- Change the query shown so that it displays Nobel prizes for 1950.

SELECT yr, subject, winner
  FROM nobel
 WHERE yr = 1950

-- Show who won the 1962 prize for Literature.
SELECT winner
  FROM nobel
 WHERE yr = 1962
   AND subject = 'Literature'

-- Show the year and subject that won 'Albert Einstein' his prize.
select yr, subject
from nobel
where winner = 'Albert Einstein'

-- Give the name of the 'Peace' winners since the year 2000, including 2000.
select winner
from nobel
where subject = 'Peace' and yr >= 2000

-- Show all details (yr, subject, winner) of the Literature prize winners for 1980 to 1989 inclusive.
select *
from nobel
where subject = 'Literature' and yr between 1980 and 1989

-- Show all details of the presidential winners:
Theodore Roosevelt
Woodrow Wilson
Jimmy Carter
Barack Obama

SELECT *
FROM nobel
 WHERE winner in ('Theodore Roosevelt', 'Woodrow Wilson', 'Jimmy Carter', 'Barack Obama')

-- Show the winners with first name John
select winner
from nobel
where winner like 'John%'

-- Show the year, subject, and name of Physics winners for 1980 together with the Chemistry winners for 1984.
select yr, subject, winner
from nobel
where subject in ('Physics') and yr = 1980 or subject in ('Chemistry') and yr = 1984

-- Show the year, subject, and name of winners for 1980 excluding Chemistry and Medicine
select yr, subject, winner
from nobel
where yr = 1980 and subject not in ('Chemistry', 'Medicine')

-- Show year, subject, and name of people who won a 'Medicine' prize in an early year (before 1910, not including 1910) together with winners of a 'Literature' prize in a later year (after 2004, including 2004)
select yr, subject, winner
from nobel
where subject = 'Medicine' and yr < 1910 or subject = 'Literature' and yr >= 2004

-- Find all details of the prize won by PETER GRÜNBERG
select *
from nobel
where winner = 'PETER GRÜNBERG'

-- Find all details of the prize won by EUGENE O'NEILL
select *
from nobel
where winner = 'EUGENE O''NEILL'

-- List the winners, year and subject where the winner starts with Sir. Show the the most recent first, then by name order.
select winner, yr, subject
from nobel
where winner like 'Sir%'
order by yr desc

-- Show the 1984 winners and subject ordered by subject and winner name; but list Chemistry and Physics last.
SELECT winner, subject
  FROM nobel
 WHERE yr=1984
 ORDER BY subject IN ('Physics','Chemistry'), subject, winner

-- Tutorial Select within select

-- List each country name where the population is larger than that of 'Russia'.
SELECT name FROM world
  WHERE population >
     (SELECT population FROM world
      WHERE name='Russia')

-- Show the countries in Europe with a per capita GDP greater than 'United Kingdom'.

select name
from world
where gdp/population > (select gdp/population from world where name = 'United Kingdom') and continent = 'Europe'

-- List the name and continent of countries in the continents containing either Argentina or Australia. Order by name of the country.
select name, continent
from world
where continent = (select continent from world where name = 'Australia') or continent = (select continent from world where name = 'Argentina')
order by name

-- Which country has a population that is more than Canada but less than Poland? Show the name and the population.
select name, population
from world 
where population > (select population from world where name = 'Canada') and population < (select population from world where name = 'Poland')

-- Show the name and the population of each country in Europe. Show the population as a percentage of the population of Germany.
select name, concat(round(100*population/(select population from world where name ='Germany')), '%') as percentage_of_GermanPopulation
from world
where continent = 'Europe'

-- Which countries have a GDP greater than every country in Europe? [Give the name only.] (Some countries may have NULL gdp values)
select name
from world
where gdp > ALL(select gdp from world where gdp > 0 and continent = 'Europe')

-- Find the largest country (by area) in each continent, show the continent, the name and the area:
SELECT continent, name, area FROM world x
  WHERE area >= ALL
    (SELECT area FROM world y
        WHERE y.continent=x.continent
          AND area>0)

-- List each continent and the name of the country that comes first alphabetically.
select continent, name 
from world x
where x.name <= all(select y.name from world y where x.continent = y.continent)
order by name

-- Find the continents where all countries have a population <= 25000000. Then find the names of the countries associated with these continents. Show name, continent and population.


SELECT name, continent, population 
FROM world AS x
WHERE 25000000 > ALL(SELECT population FROM world AS y
WHERE x.continent = y.continent AND population > 0);
   
-- Some countries have populations more than three times that of any of their neighbours (in the same continent). Give the countries and continents.

SELECT name, continent 
FROM world AS x
WHERE population > ALL(SELECT population*3 
                    FROM world AS y
                    WHERE y.continent = x.continent 
                    AND y.name != x.name);



SELECT name, region 
FROM bbc x
 WHERE population < ALL (SELECT population/3 FROM bbc y WHERE y.region = x.region AND y.name != x.name)


-- TUTORIAL SUM() AND COUNT()

-- Show the total population of the world.

SELECT sum(population)
FROM world

-- List all the continents - just once each.
select distinct continent
from world

-- Give the total GDP of Africa
select sum(gdp)
from world
where continent = 'Africa'

-- How many countries have an area of at least 1000000
select count(name)
from world
where area > 1000000

-- What is the total population of ('Estonia', 'Latvia', 'Lithuania')

select sum(population)
from world
where name in('Estonia', 'Latvia', 'Lithuania')

-- For each continent show the continent and number of countries.
select continent, count(name)
from world
group by continent

-- For each continent show the continent and number of countries with populations of at least 10 million.
select continent, count(name)
from world
group by continent
having population > 10000000

-- List the continents that have a total population of at least 100 million.
select continent
from world
GROUP BY continent 
HAVING SUM(population) >= 100000000;

-- TUTORIAL JOINS

-- Modify it to show the matchid and player name for all goals scored by Germany. To identify German players, check for: teamid = 'GER'

SELECT matchid, player 
FROM goal 
WHERE teamid = 'GER'

-- Show id, stadium, team1, team2 for just game 1012

SELECT id,stadium,team1,team2
  FROM game
where id = 1012

-- Modify it to show the player, teamid, stadium and mdate for every German goal.
SELECT player,teamid, stadium, mdate
  FROM game JOIN goal ON (id=matchid)
where teamid = 'GER'

-- Show the team1, team2 and player for every goal scored by a player called Mario player LIKE 'Mario%'
select team1, team2, player
from game
join goal
on game.id = goal.matchid
where player LIKE 'Mario%'

-- Show player, teamid, coach, gtime for all goals scored in the first 10 minutes gtime<=10

SELECT player, teamid, coach, gtime
  FROM goal
goal JOIN eteam
 on teamid=id
 WHERE gtime<=10

--  List the the dates of the matches and the name of the team in which 'Fernando Santos' was the team1 coach.

select game.mdate, eteam.teamname
from game
game join eteam
on team1 = eteam.id
where team1 = 'GRE'

-- List the player for every goal scored in a game where the stadium was 'National Stadium, Warsaw'

select goal.player
from goal
goal join game
on goal.matchid = game.id
where game.stadium = 'National Stadium, Warsaw'


-- Instead show the name of all players who scored a goal against Germany.

SELECT distinct player
FROM game 
game JOIN goal 
ON id = matchid
WHERE (team1='GER' or team2='GER') and teamid != 'GER'

-- Show teamname and the total number of goals scored.
SELECT teamname, count(gtime)
FROM eteam 
eteam JOIN goal 
ON id=teamid
group by teamname
ORDER BY teamname

-- Show the stadium and the number of goals scored in each stadium.
select game.stadium, count(gtime) as goals
from goal
goal join game
on goal.matchid = game.id
group by game.stadium
order by goals

-- For every match involving 'POL', show the matchid, date and the number of goals scored.
SELECT distinct matchid, mdate, count(teamid)
FROM game
game JOIN goal
ON game.id = goal.matchid
WHERE (team1 = 'POL' OR team2 = 'POL')
group by matchid, mdate

-- For every match where 'GER' scored, show matchid, match date and the number of goals scored by 'GER'
select matchid, mdate, count(teamid)
from goal
goal join game
on goal.matchid = game.id
where goal.teamid = 'GER'
group by matchid, mdate

-- Sort your result by mdate, matchid, team1 and team2.
SELECT mdate, team1, sum(CASE WHEN teamid=team1 THEN 1 ELSE 0 END) score1, team2, sum(CASE WHEN teamid=team2 THEN 1 ELSE 0 END) score2
from game
game left join goal
on game.id = goal.matchid
group by mdate, team1, team2


-- TUTORIAL MORE JOINS
-- List the films where the yr is 1962 [Show id, title]

SELECT id, title
 FROM movie
 WHERE yr=1962

--  Give year of 'Citizen Kane'.
SELECT yr
from movie
where title= 'Citizen Kane'

-- List all of the Star Trek movies, include the id, title and yr (all of these movies include the words Star Trek in the title). Order results by year.
select id, title, yr
from movie
where title like '%Star Trek%'
order by yr

-- What id number does the actor 'Glenn Close' have?
select id
from actor
where name = 'Glenn Close'

-- What is the id of the film 'Casablanca'
select id
from movie
where title = 'Casablanca'

-- Use movieid=11768, (or whatever value you got from the previous question)

select name
from actor
actor join casting
on actor.id = casting.actorid
where movieid = 11768


-- Obtain the cast list for the film 'Alien'

select name
from actor
actor join casting
on actor.id = casting.actorid
where movieid = 10522

-- List the films in which 'Harrison Ford' has appeared

select title
from movie
movie join casting
on movie.id = casting.movieid
where actorid = 2216

-- List the films where 'Harrison Ford' has appeared - but not in the starring role. [Note: the ord field of casting gives the position of the actor. If ord=1 then this actor is in the starring role]
select title
from movie
movie join casting
on movie.id = casting.movieid
where actorid = 2216 and ord != 1

-- List the films together with the leading star for all 1962 films.

select title, actor.name
from movie
movie join casting
on movie.id = casting.movieid
join actor
on casting.actorid = actor.id
where ord = 1 and yr = 1962

-- Which were the busiest years for 'Rock Hudson', show the year and the number of movies he made each year for any year in which he made more than 2 movies.
SELECT yr, COUNT(title)
FROM movie 
JOIN casting 
ON movie.id=movieid
JOIN actor   
ON actorid=actor.id
WHERE name='Rock Hudson'
GROUP BY yr
HAVING COUNT(title) > 2

-- List the film title and the leading actor for all of the films 'Julie Andrews' played in.

select title, name
  from movie join casting on (movie.id = casting.movieid 
                              AND ord=1 )
             join actor on (actorid=actor.id)
  where movie.id IN (
       SELECT movieid FROM casting
         WHERE actorid IN (
          179)) 


-- Obtain a list, in alphabetical order, of actors who've had at least 30 starring roles.
select distinct name
from actor
join casting
on actor.id=casting.actorid and ord=1
group by name
having count(ord)>=30 
order by name

-- List the films released in the year 1978 ordered by the number of actors in the cast, then by title.

select distinct title, count(actorid)
from movie
join casting
on movie.id=casting.movieid
where yr=1978
group by title
order by count(actorid) desc, title

-- List all the people who have worked with 'Art Garfunkel'.

select actor.name
from actor
join casting
on actor.id=casting.actorid
where movieid IN (10095, 11434, 13630) and actor.name != 'Art Garfunkel'

-- TUTORIAL USING NULL

-- List the teachers who have NULL for their department.

select name
from teacher
where dept is null

-- Note the INNER JOIN misses the teachers with no department and the departments with no teacher.

SELECT teacher.name, dept.name
 FROM teacher INNER JOIN dept
           ON (teacher.dept=dept.id)


-- Use a different JOIN so that all teachers are listed.

select teacher.name, dept.name
from teacher 
left join dept
on teacher.dept=dept.id

-- Use a different JOIN so that all departments are listed.

select teacher.name, dept.name
from teacher 
right join dept
on teacher.dept=dept.id

-- Show teacher name and mobile number or '07986 444 2266'

select name, coalesce(mobile, '07986 444 2266')
from teacher

-- Use the COALESCE function and a LEFT JOIN to print the teacher name and department name. Use the string 'None' where there is no department.

select teacher.name, coalesce(dept.name, 'None')
from teacher
left join dept
on teacher.dept=dept.id


-- Use COUNT to show the number of teachers and the number of mobile phones.
select count(teacher.id), count(teacher.mobile)
from teacher


-- Use COUNT and GROUP BY dept.name to show each department and the number of staff. Use a RIGHT JOIN to ensure that the Engineering department is listed.
select dept.name, count(teacher.dept)
from teacher
right join dept
on teacher.dept=dept.id
group by dept.name

-- Use CASE to show the name of each teacher followed by 'Sci' if the teacher is in dept 1 or 2 and 'Art' otherwise.
select teacher.name,
CASE WHEN teacher.dept = 1 then 'Sci' WHEN teacher.dept=2 then 'Sci' ELSE 'Art' END
from teacher

-- Use CASE to show the name of each teacher followed by 'Sci' if the teacher is in dept 1 or 2, show 'Art' if the teacher's dept is 3 and 'None' otherwise.
select teacher.name, CASE WHEN teacher.dept=1 then 'Sci' WHEN teacher.dept=2 then 'Sci' WHEN teacher.dept=3 then 'Art' ELSE 'None' END
from teacher 

-- TUTORAIL SELF JOIN

-- How many stops are in the database.

select count(stops.name)
from stops


-- Find the id value for the stop 'Craiglockhart'
select stops.id
from stops
where stops.name='Craiglockhart'

-- Give the id and the name for the stops on the '4' 'LRT' service.
select id, name
from stops
join route
on stops.id = route.stop
where route.company='LRT'and num='4'

-- The query shown gives the number of routes that visit either London Road (149) or Craiglockhart (53). Run the query and notice the two services that link these stops have a count of 2. Add a HAVING clause to restrict the output to these two routes.

SELECT company, num, COUNT(*)
FROM route WHERE stop=149 OR stop=53
GROUP BY company, num
having num=4 or num=45

-- Execute the self join shown and observe that b.stop gives all the places you can get to from Craiglockhart, without changing routes. Change the query so that it shows the services from Craiglockhart to London Road.
SELECT a.company, a.num, a.stop, b.stop
FROM route a JOIN route b ON
  (a.company=b.company AND a.num=b.num)
WHERE a.stop=53 and b.stop=149

-- The query shown is similar to the previous one, however by joining two copies of the stops table we can refer to stops by name rather than by number. Change the query so that the services between 'Craiglockhart' and 'London Road' are shown. If you are tired of these places try 'Fairmilehead' against 'Tollcross'
SELECT a.company, a.num, stopa.name, stopb.name
FROM route a JOIN route b ON
  (a.company=b.company AND a.num=b.num)
  JOIN stops stopa ON (a.stop=stopa.id)
  JOIN stops stopb ON (b.stop=stopb.id)
WHERE stopa.name='Craiglockhart' and stopb.name='London Road'

-- Give a list of all the services which connect stops 115 and 137 ('Haymarket' and 'Leith')
SELECT a.company, a.num
FROM route a JOIN route b ON
  (a.company=b.company AND a.num=b.num)
WHERE a.stop=115 and b.stop=137
group by a.company, a.num

-- Give a list of the services which connect the stops 'Craiglockhart' and 'Tollcross'
select a.company, a.num
from route a
join route b on (a.company=b.company AND a.num=b.num)
join stops stopa on a.stop=stopa.id
join stops stopb on b.stop=stopb.id
WHERE stopa.name='Craiglockhart' and stopb.name='Tollcross'

-- Give a distinct list of the stops which may be reached from 'Craiglockhart' by taking one bus, including 'Craiglockhart' itself, offered by the LRT company. Include the company and bus no. of the relevant services.

select stops.name, route.company, route.num
from route
join stops on route.stop=stops.id
where route.company='LRT' and route.num in (10, 27, 4, 45, 47)
group by stops.name, route.company, route.num
order by num


-- Find the routes involving two buses that can go from Craiglockhart to Lochend.
-- Show the bus no. and company for the first bus, the name of the stop for the transfer,
-- and the bus no. and company for the second bus.

select a.num, stopa.name
from route a
join route b
on (a.company=b.company AND a.num=b.num)
join stops stopa on a.stop=stopa.id
join stops stopb on b.stop=stopb.id
where a.num in (10, 27, 4, 45, 47)



