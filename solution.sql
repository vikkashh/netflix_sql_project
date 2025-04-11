-- netflix project
drop table if exists netflix;
CREATE TABLE netflix
(show_id varchar(6),
type varchar(10),
title varchar(150),
director varchar(208),
casts varchar(1000),
country varchar(150),
date_added varchar(50),
release_year int,
rating varchar(10),
duration varchar(15),
listed_in varchar(100),
description varchar(250)
);

select * from netflix


select distinct type from netflix


select * from netflix

-- 15 business problem
-- 1. count the number of movies vs tv shows
select count(show_id) as total_movie,type from netflix
group by type

-- find the most common rating for movies and tv shows
select type,rating from
       (select type,count(*), rank() over(partition by type order by count(*) desc ) as ranking,  
        rating from netflix
        group by rating ,type
       )t1
		where ranking =1

-- 3- list all the movie releases in the specific year i.e 2020
select title , release_year from netflix
where release_year = 2020 and
      type= 'Movie'


-- 4- find the top 5 countries with the most content on netflix
select country,count(title) from netflix

group by country
order by count(title) desc

select 
     unnest(string_to_array(country,',')) as new_country,
	 count(show_id) as total_content
	 from netflix
	 group by new_country
	 order by total_content desc limit 5

--5 identify  the longest movie
select type , duration, title from netflix
where type = 'Movie' and duration=(select max(duration) from netflix)


-- 6 find the content added in the last five years
 select * from netflix
 where 
 to_date(date_added,'month dd,yyyy') >= current_date - interval '5 years'

  -- 7 find all the movies/tv shows by director 'rajiv chilika'\
  select * from netflix
  where director ilike '%Rajiv Chilaka%'


  -- 8 list all the tv show with more than 5 season
  select *
  from netflix
  where 
    type = 'TV Show' and 
	split_part(duration,' ', 1) :: numeric> 5


-- 9 count the number of content items in each genre
select count(show_id) ,
unnest(string_to_array(listed_in,',')) as genre from netflix
group by 2
	




-- 10 find each year and the average numbers of content release in india
--on netflix . return top 5 year with highest avg content release 

select extract(year from to_date(date_added , 'month dd yyyy')) as year,
count(*) , count(*):: numeric/(select count(*) from netflix
                       where country='India'):: numeric * 100 as avg
					   from netflix
where country = 'India'
group by 1

-- 11 list all the movies that are documentries

select * from netflix
where listed_in ilike '%documentaries%'


--12 fiind all content without a director
select * from netflix 
where director is null


-- 13 find how many movies actor 'salman khan' appeared in last 10 years !

select *, unnest(string_to_array(casts,',')) as actors from netflix 
where casts ilike '%salman khan%'
and release_year > extract(year from current_date)- 10




-- 14 find the top 10 actors who have appeared in the highest number of movies produced in india
select count(title) ,
unnest(string_to_array(casts,',')) as actor from netflix
where country = 'India'
group by actor
order by count(title) desc limit 10


--15  categories the content based on the prence of the keywords 'kills' and 'violence'
-- in the description field . label content containing these keywords as 'bad'
-- and all other content as 'good'. count how many item fall into each category
with new_table 
as 
(
select *,
case 
when 
    description ilike '%kill%' or
	description ilike '%violence%' then 'bad_content'
	else 'good content'
end category
from netflix
)
select 
 category,
 count(*) as total_content
from new_table 
group by 1

 






