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

-- Задача 65 3* - Пронумеровать уникальные пары {maker, type} из Product, упорядочив их следующим образом:
-- 				- имя производителя (maker) по возрастанию;
-- 				- тип продукта (type) в порядке PC, Laptop, Printer.
-- 				  Если некий производитель выпускает несколько типов продукции, то выводить его имя только в первой строке;
-- 				  остальные строки для ЭТОГО производителя должны содержать пустую строку символов (''). 

-- Вариант 1 (не самый хороший, первое что пришло в голову)
select row_number() over (order by maker, number) as num, 
	case 
		when type = 'PC' then maker 
		when type <> 'PC' 
			and maker in (
							select maker 
							from product where type = 'PC'
						) then ''
		when type = 'laptop' 
			and maker not in (
								select maker 
								from product where type = 'PC'
							) then maker
		when type <> 'laptop' 
			and maker in (
							select maker 
							from product where type = 'Laptop'
						) then ''
		else maker 
	end  as marker, 
	type
from (
		select distinct maker, type 
		from product
	) as table1 
	join (
			select 1 as number, 'PC' as types
			union all
			select 2 as number, 'Laptop' as types
			union all
			select 3 as number, 'Printer' as types
		) as num_order on num_order.types = table1.type
	-- Соединение таблицы с производителей/типов с необходимым для вывода порядком типов

-- Вариант 2 (Считаю  более оптимальным)
select row_number() over( order by maker, case 
										when type = 'PC' then 1 
										when type = 'Laptop' then 2 
										when type = 'Printer' then 3 
										end) as num,
	case 
		when type = 'PC' then maker 
		when type <> 'PC' 
			and maker in (
							select maker 
							from product where type = 'PC'
						) then ''
		when type = 'laptop' 
			and maker not in (
								select maker 
								from product where type = 'PC'
							) then maker
		when type <> 'laptop' 
			and maker in (
							select maker 
							from product where type = 'Laptop'
						) then ''
		else maker 
	end  as marker, 
	type
from (
		select distinct maker, type 
		from product
	) as table1