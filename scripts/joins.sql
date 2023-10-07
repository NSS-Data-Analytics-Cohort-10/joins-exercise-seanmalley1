-- ** How to import your data. **

-- 1. In PgAdmin, right click on Databases (under Servers -> Postgresql 15). Hover over Create, then click Database.

-- 2. Enter in the name â€˜Joinsâ€™ (not the apostrophes). Click Save.

-- 3. Left click the server â€˜Joinsâ€™. Left click Schemas. 

-- 4. Right click public and select Restore.

-- 5. Select the folder icon in the filename row. Navigate to the data folder of your repo and select the file movies.backup. Click Restore.


-- ** Movie Database project. See the file movies_erd for table\column info. **

-- 1. Give the name, release year, and worldwide gross of the lowest grossing movie.

SELECT *
FROM specs
INNER JOIN revenue
ON revenue.movie_id = specs.movie_id
ORDER BY worldwide_gross ASC

-- SELECT specs.film_title, specs.release_year, MIN(revenue.worldwide_gross)
-- FROM specs
-- INNER JOIN revenue
-- ON revenue.movie_id = specs.movie_id
-- GROUP BY specs.film_title


-- 2. What year has the highest average imdb rating?
SELECT AVG(rating.imdb_rating), specs.release_year
FROM SPECS
INNER JOIN rating
-- ON specs.movie_id = rating.movie_id
USING(movie_id)
GROUP BY release_year
ORDER BY AVG(rating.imdb_rating) DESC

-- 3. What is the highest grossing G-rated movie? Toy Story Which company distributed it?
--part 1
SELECT specs.film_title
FROM specs
LEFT JOIN revenue
USING(movie_id)
WHERE specs.mpaa_rating = 'G'
GROUP BY revenue.worldwide_gross, specs.film_title
ORDER BY revenue.worldwide_gross DESC

SELECT COUNT(*)
FROM specs

-- Toy Story
--part 2

SELECT film_title, company_name, worldwide_gross
FROM specs
INNER JOIN revenue
USING(movie_id)
INNER JOIN distributors
ON specs.domestic_distributor_id = distributors.distributor_id
WHERE specs.mpaa_rating = 'G'
GROUP BY film_title, company_name, worldwide_gross
ORDER BY revenue.worldwide_gross DESC


-- Answer: Walt Disney

-- 4. Write a query that returns, for each distributor in the distributors table, the distributor name and the number of movies associated with that distributor in the movies 
-- table. Your result set should include all of the distributors, whether or not they have any movies in the movies table.

SELECT distributors.company_name, COUNT(specs.film_title)
FROM specs
INNER JOIN distributors
ON specs.domestic_distributor_id = distributors.distributor_id
GROUP BY distributors.company_name
ORDER BY COUNT(specs.film_title) DESC

-- 5. Write a query that returns the five distributors with the highest average movie budget.
SELECT *
from specs

SELECT distributors.company_name, AVG(revenue.film_budget) as avg_film_budget
FROM specs
INNER JOIN revenue USING (movie_id)
INNER JOIN distributors ON specs.domestic_distributor_id = distributors.distributor_id
GROUP BY distributors.company_name
ORDER BY avg_film_budget DESC
LIMIT 5



-- 6. How many movies in the dataset are distributed by a company which is not headquartered in California? Which of these movies has the highest imdb rating?

SELECT COUNT(film_title), headquarters, company_name
FROM specs
FULL JOIN distributors ON domestic_distributor_id = distributor_id
FULL JOIN rating
USING (movie_id)
WHERE headquarters NOT LIKE '%CA%'
GROUP BY headquarters, company_name


-- 7. Which have a higher average rating, movies which are over two hours long or movies which are under two hours?
