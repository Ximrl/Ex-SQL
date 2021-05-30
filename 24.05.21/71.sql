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

-- Задача 71 2* - Найти тех производителей ПК, все модели ПК которых имеются в таблице PC.

-- Вариант 1
select distinct maker
from product p1
where type = 'PC' 
	and not exists (
			select model 
			from product p2 
			where p1.type = p2.type 
				and p1.maker = p2.maker 
				and model not in (
						select model
						from pc
						)
			)

-- Вариант 2
select maker
from product 
	left join pc on pc.model = product.model
where type = 'PC'
group by maker
having count(product.model) = count(pc.model)