/*
Схема БД состоит из четырех таблиц:
Product(maker, model, type)
PC(code, model, speed, ram, hd, cd, price)
Laptop(code, model, speed, ram, hd, price, screen)
Printer(code, model, color, type, price)
Таблица Product представляет производителя (maker), номер модели (model) и тип ('PC' - ПК, 'Laptop' - ПК-блокнот или 'Printer' - принтер).
Предполагается, что номера моделей в таблице Product уникальны для всех производителей и типов продуктов. 
В таблице PC для каждого ПК, однозначно определяемого уникальным кодом – code, указаны 
модель – model (внешний ключ к таблице Product), 
скорость - speed (процессора в мегагерцах), 
объем памяти - ram (в мегабайтах), 
размер диска - hd (в гигабайтах), 
скорость считывающего устройства - cd (например, '4x') 
и цена - price. 
Таблица Laptop аналогична таблице РС за исключением того, что вместо скорости CD содержит размер экрана -screen (в дюймах). 
В таблице Printer для каждой модели принтера указывается, 
является ли он цветным - color ('y', если цветной), 
тип принтера - type (лазерный – 'Laser', струйный – 'Jet' или матричный – 'Matrix') 
и цена - price.
*/

-- Задача № 82 2* - В наборе записей из таблицы PC, отсортированном по столбцу code (по возрастанию) найти среднее значение цены для каждой шестерки подряд идущих ПК.
--					Вывод: значение code, которое является первым в наборе из шести строк, среднее значение цены в наборе.

-- Вариант 1
with pcs as (
	select row_number() over (order by code) num, code, price
	from pc
)

Select p1.code, avg(p2.price)
from psc p1 
	join psc p2 on p1.num >= p2.num - 5 
		and p2.num >= p1.num
group by p1.num, p1.code
having count(*) = 6

-- Вариант 2 (Использование оконных функций)
with cte as (
	select code, row_number() over (order by code) num,
		avg(price) over(order by code rows between current row and 5 FOLLOWING) as avg_price, count(*) over () as row_count
	from pc)

select code, avg_price
from cte
where row_count >= num + 5