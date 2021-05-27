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

-- Задача № 75 2* - Для тех производителей, у которых есть продукты с известной ценой хотя бы в одной из таблиц Laptop, PC, Printer найти максимальные цены на каждый из типов продукции.
--					Вывод: maker, максимальная цена на ноутбуки, максимальная цена на ПК, максимальная цена на принтеры.
--					Для отсутствующих продуктов/цен использовать NULL. 

-- Вариант 1
select maker, max(laptop.price) as laptop, max(pc.price) as pc, max(printer.price) as printer
from product as p 
	left join laptop on p.model = laptop.model 
	full join pc on pc.model = p.model 
	left join printer on p.model = printer.model
	-- Объединение всех данных с информацией производителя
where laptop.price is not null 
	or pc.price is not null 
	or printer.price is not null
group by maker

-- Вариант 2 (Меньше cost)
select maker, max(laptop), max(pc), max(printer)
from product 
	join (
			select model, price as laptop, null as pc, null as printer 
			from laptop
			union all
			select model, null, price, null 
			from pc
			union all
			select model, null, null, price 
			from printer
	) as prices on product.model = prices.model
	-- Объединение всех даных через union
where coalesce(laptop, pc, printer) is not null
group by maker