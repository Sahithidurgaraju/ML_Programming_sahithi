


USE PIXAR_FILM_DATA_EXPLORATION
GO

select *
from PIXAR_FILM_DATA_EXPLORATION.dbo.pixar_filmsnew

select column_name
from INFORMATION_SCHEMA.columns
where table_name = 'pixar_filmsnew'


--How many films are in the dataset?

select count(film) as Total_Films
from PIXAR_FILM_DATA_EXPLORATION.dbo.pixar_filmsnew

--What is the range of release years for Pixar films

select min(Year(release_date)) as First_year, max(Year(release_date)) as Last_year
from PIXAR_FILM_DATA_EXPLORATION.dbo.pixar_filmsnew

--What is the average runtime of Pixar films?

select round(Avg(run_time),2) as Average_runtime_mins
from PIXAR_FILM_DATA_EXPLORATION.dbo.pixar_filmsnew

--How many films were released each year?

select Year(release_date) as Release_Year, count(film) 
from PIXAR_FILM_DATA_EXPLORATION.dbo.pixar_filmsnew
group by Year(release_date)


--What is the average budget and revenue of Pixar films?

select avg(budget) as average_budget, avg(box_office_worldwide) as average_revenue, film
from PIXAR_FILM_DATA_EXPLORATION.dbo.pixar_filmsnew
group by film

--Which films had the highest box office revenue worldwide?
select Top 5 box_office_worldwide, film
from PIXAR_FILM_DATA_EXPLORATION.dbo.pixar_filmsnew
order by box_office_worldwide desc

--Which films had the lowest box office revenue?
select Top 5 box_office_worldwide, film
from PIXAR_FILM_DATA_EXPLORATION.dbo.pixar_filmsnew
order by box_office_worldwide asc

--Which films had the highest return on investment (ROI)?

select film, round((box_office_worldwide - budget) / nullif(budget,0),2)  as Highest_ROI
from PIXAR_FILM_DATA_EXPLORATION.dbo.pixar_filmsnew
order by Highest_ROI desc

--Are higher-budget films more successful in terms of revenue?

select (box_office_worldwide - budget) as Total_Profit, film, budget, round((box_office_worldwide - budget) / nullif(budget,0),2)  as Highest_ROI
from PIXAR_FILM_DATA_EXPLORATION.dbo.pixar_filmsnew
order by budget desc

--Which films have the highest and lowest IMDb scores?

with max_imdb_score

as
 (
 select film, imdb_score, rank() over(order by imdb_score desc) as rank
 from PIXAR_FILM_DATA_EXPLORATION.dbo.pixar_filmsnew
 )
 select *
 from max_imdb_score
 where rank <= 5;

with min_imdb_score

as
 (
 select film, imdb_score, rank() over(order by imdb_score asc) as rank
 from PIXAR_FILM_DATA_EXPLORATION.dbo.pixar_filmsnew
 )
 select *
 from min_imdb_score
 where rank <= 5;
 


--Which films have the highest Rotten Tomatoes scores?

with rotten_tomatoes_score

as
 (
 select film, rotten_tomatoes_score, rank() over(order by rotten_tomatoes_score desc) as rank
 from PIXAR_FILM_DATA_EXPLORATION.dbo.pixar_filmsnew
 )
 select *
 from rotten_tomatoes_score
 where rank <= 5;


--Do higher-rated films generate more box office revenue?
with high_rated
as
(
select film, imdb_score,box_office_worldwide, rank() over(order by imdb_score desc) as high_rank, 
           rank() over(order by imdb_score asc) as low_rank
from PIXAR_FILM_DATA_EXPLORATION.dbo.pixar_filmsnew
)
select *
from high_rated
where high_rank <=5 or low_rank <=5;


--How has the average budget of Pixar films changed over time?

select film, year(release_date) as release_year , avg(budget)
from PIXAR_FILM_DATA_EXPLORATION.dbo.pixar_filmsnew
group by year(release_date), film
order by release_year

--Has the average box office revenue increased over the years?

select avg(box_office_worldwide) as avg_box_office_revenue, year(release_date) as release_year, film
from PIXAR_FILM_DATA_EXPLORATION.dbo.pixar_filmsnew
group by year(release_date), film
order by release_year

--Are Pixar films getting longer or shorter over time?

select year(release_date),AVG(run_time) AS avg_runtime
from  PIXAR_FILM_DATA_EXPLORATION.dbo.pixar_filmsnew
group by year(release_date)
order by avg_runtime 

--count of movies by cinema_score
select cinema_score, count(film)
from PIXAR_FILM_DATA_EXPLORATION.dbo.pixar_filmsnew
group by cinema_score

--count of movies by film_rating
select film_rating, count(film)
from PIXAR_FILM_DATA_EXPLORATION.dbo.pixar_filmsnew
group by film_rating
