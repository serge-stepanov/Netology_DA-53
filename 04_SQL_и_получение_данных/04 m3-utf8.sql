--=============== МОДУЛЬ 3. ОСНОВЫ SQL =======================================
--= ПОМНИТЕ, ЧТО НЕОБХОДИМО УСТАНОВИТЬ ВЕРНОЕ СОЕДИНЕНИЕ И ВЫБРАТЬ СХЕМУ PUBLIC===========
SET search_path TO public;

--======== ОСНОВНАЯ ЧАСТЬ ==============

--ЗАДАНИЕ №1
--Выведите для каждого покупателя его адрес проживания, 
--город и страну проживания.

select concat(c.last_name, ' ', c.first_name) as "Customer name", a.address, c1.city, c2.country
from customer c 
join address a using (address_id)
join city c1 on a.city_id =c1.city_id  
join country c2 on c1.country_id = c2.country_id

--ЗАДАНИЕ №2
--С помощью SQL-запроса посчитайте для каждого магазина количество его покупателей.

select store_id as "ID мазгазина", count(email) as "Количество покупателей"
from customer c 
group by store_id 

--Доработайте запрос и выведите только те магазины, 
--у которых количество покупателей больше 300-от.
--Для решения используйте фильтрацию по сгруппированным строкам 
--с использованием функции агрегации.

select store_id as "ID мазгазина", count(email) as "Количество покупателей"
from customer c 
group by store_id 
having count(email) > 300

-- Доработайте запрос, добавив в него информацию о городе магазина, 
--а также фамилию и имя продавца, который работает в этом магазине.

select c.store_id as "ID мазгазина", count(c.email) as "Количество покупателей", c1.city as "Город", s2.last_name ||' '|| s2.first_name as "Имя сотрудника"
from customer c 
join store s on c.store_id = s.store_id 
join address a on s.address_id = a.address_id 
join city c1 on a.city_id = c1.city_id 
join staff s2 on s.store_id = s2.store_id 
group by c.store_id, c1.city, s2.last_name, s2.first_name 
having count(c.email) > 300

--ЗАДАНИЕ №3
--Выведите ТОП-5 покупателей, 
--которые взяли в аренду за всё время наибольшее количество фильмов

select c.last_name ||' '||c.first_name as "Фамилия и имя покупателя", count(r.rental_date) as "Количество фильмов"
from customer c 
join rental r ON c.customer_id =r.customer_id 
group by c.last_name, c.first_name, r.customer_id
order by "Количество фильмов" desc 
limit 5

--ЗАДАНИЕ №4
--Посчитайте для каждого покупателя 4 аналитических показателя:
--  1. количество фильмов, которые он взял в аренду
--  2. общую стоимость платежей за аренду всех фильмов (значение округлите до целого числа)
--  3. минимальное значение платежа за аренду фильма
--  4. максимальное значение платежа за аренду фильма

select c.last_name ||' '||c.first_name as "Фамилия и имя покупателя", count(r.rental_date) as "Количество фильмов", round(sum(p.amount)) as "Общая стоимость платежей", min(p.amount) as "Минимальная стоимость платежа", max(p.amount) as "Максимальная стоимость платежа" 
from customer c 
join rental r ON c.customer_id =r.customer_id
join payment p on r.rental_id = p.rental_id 
group by c.last_name, c.first_name, r.customer_id

--ЗАДАНИЕ №5
--Используя данные из таблицы городов составьте одним запросом всевозможные пары городов таким образом,
 --чтобы в результате не было пар с одинаковыми названиями городов. 
 --Для решения необходимо использовать декартово произведение.
 
select c.city, c2.city 
from city c 
cross join city c2
where c.city > c2.city 


--ЗАДАНИЕ №6
--Используя данные из таблицы rental о дате выдачи фильма в аренду (поле rental_date)
--и дате возврата фильма (поле return_date), 
--вычислите для каждого покупателя среднее количество дней, за которые покупатель возвращает фильмы.
 
select customer_id as "ID покупателя", round(avg(return_date::date - rental_date::date), 2) as "Среднее количество дней на возврат"
from rental r 
group by customer_id
order by 1

--======== ДОПОЛНИТЕЛЬНАЯ ЧАСТЬ ==============

--ЗАДАНИЕ №1
--Посчитайте для каждого фильма сколько раз его брали в аренду и значение общей стоимости аренды фильма за всё время.

select f.title "Название фильма", f.rating "Рейтинг", c."name" "Жанр", f.release_year "Год выпуска", l."name" "Язык", count(r.rental_date) "Количество аренд", sum(p.amount) "Общая стоимость аренды" 
from film f 
join film_category fc on f.film_id =fc.film_id 
join category c on fc.category_id =c.category_id
join "language" l on f.language_id = l.language_id 
join inventory i on f.film_id =i.film_id 
join rental r on i.inventory_id =r.inventory_id 
join payment p on r.rental_id = p.rental_id 
group by f.title, f.rating, c."name", f.release_year, l."name"

--ЗАДАНИЕ №2
--Доработайте запрос из предыдущего задания и выведите с помощью запроса фильмы, которые ни разу не брали в аренду.





--ЗАДАНИЕ №3
--Посчитайте количество продаж, выполненных каждым продавцом. Добавьте вычисляемую колонку "Премия".
--Если количество продаж превышает 7300, то значение в колонке будет "Да", иначе должно быть значение "Нет".

select staff_id, count(rental_id), 
case 
	when count(rental_id) > 7300 then 'Да'
	else 'Нет'
end as "Премия"
from payment p 
group by staff_id 






