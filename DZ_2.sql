SELECT 'Серенкова Елена';
1.Простые выборки
-- первый запрос
SELECT * FROM ratings LIMIT 10;

-- второй запрос
(SELECT * FROM links WHERE imdbid LIKE '%42' LIMIT 10) UNION ALL ( (SELECT * FROM links WHERE movieid > '100')
 INTERSECT (SELECT * FROM links WHERE movieid < '1000')
LIMIT 10);
2. Сложные выборки
-- 2.1 выбрать из таблицы links все imdb_id, которым ставили рейтинг 5
SELECT imdbid, ratings
FROM links
JOIN ratings
		ON links.movieid=ratings.movieid
WHERE rating =5
LIMIT 10;

--3.1 Посчитать число фильмов без оценок

SELECT COUNT(*)
FROM public.links
LEFT JOIN public.ratings
    ON links.movieid=ratings.movieid
WHERE ratings.movieid IS NULL;




--3.2 GROUP BY, HAVING вывести top-10 пользователей, у который средний рейтинг выше 3.5.

SELECT userid, AVG(rating)
FROM ratings
GROUP BY userid 
HAVING AVG(rating) > 3.5
ORDER BY AVG(rating) DESC
LIMIT 10;



--4.1 достать 10 imbdId из links у которых средний рейтинг больше 3.5 

SELECT l.imdbid, t.movieid
FROM links as l
JOIN 
    (SELECT movieid, AVG(rating)
    FROM ratings
    GROUP BY movieid
    HAVING AVG(rating) > 3.5) as t
      on t.movieid=l.movieid
LIMIT 10;

ИЛИ

SELECT imdbid
FROM links 
WHERE movieid IN (
    SELECT movieid
    FROM ratings
    GROUP BY movieid
    HAVING AVG(rating) > 3.5 )
LIMIT 10;



--запрос 4.1 Подсчитать средний рейтинг по всем пользователям, которые попали под условие - то есть в ответе должно быть одно число.

SELECT AVG (rating_avr)
FROM (
SELECT l.imdbid, t.movieid, rating_avr
FROM links as l
JOIN 
    (SELECT movieid, AVG(rating) as rating_avr
    FROM ratings
    GROUP BY movieid
    HAVING AVG(rating) > 3.5) as t
on t.movieid=l.movieid
LIMIT 10) as itog;



--запрос 4.2 - Common Table Expressions: посчитать средний рейтинг по пользователям, у которых более 10 оценок

WITH table_itog
AS
    (
    WITH number_rating_userid
    AS 
        (
        SELECT userid,
	        COUNT (rating) as rating_count,
	        AVG (rating) as rating_avarage
        FROM ratings
        GROUP BY userid, rating
        ) 
    SELECT *
    FROM number_rating_userid
    WHERE rating_count > 10
    )
SELECT AVG (rating_avarage)
FROM table_itog
;

__________________________
Считаем число рейтингов по каждому пользвателю
SELECT userid,
COUNT (*)
FROM ratings
GROUP BY userid; 