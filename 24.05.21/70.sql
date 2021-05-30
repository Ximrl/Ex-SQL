/*
Рассматривается БД кораблей, участвовавших во второй мировой войне. Имеются следующие отношения:
Classes (class, type, country, numGuns, bore, displacement)
Ships (name, class, launched)
Battles (name, date)
Outcomes (ship, battle, result)
Корабли в «классах» построены по одному и тому же проекту, и классу присваивается либо имя первого корабля, построенного по данному проекту, либо названию класса дается имя проекта, которое не совпадает ни с одним из кораблей в БД. 
Корабль, давший название классу, называется головным.
Отношение Classes содержит имя класса, тип (bb для боевого (линейного) корабля или bc для боевого крейсера), страну, в которой построен корабль, число главных орудий, калибр орудий (диаметр ствола орудия в дюймах) и водоизмещение ( вес в тоннах). 
В отношении Ships записаны название корабля, имя его класса и год спуска на воду. 
В отношение Battles включены название и дата битвы, в которой участвовали корабли, 
В отношении Outcomes – результат участия данного корабля в битве (потоплен-sunk, поврежден - damaged или невредим - OK).
Замечания. 	1) В отношение Outcomes могут входить корабли, отсутствующие в отношении Ships. 
			2) Потопленный корабль в последующих битвах участия не принимает.
*/

-- Задача № 70 2* - Укажите сражения, в которых участвовало по меньшей мере три корабля одной и той же страны.

-- Вариант 1
select distinct battle
from classes as c 
	left join ships as s on c.class = s.class 
	join outcomes as o on o.ship = s.name 
		-- Собираем данные о всех кораблях
		or (c.class = o.ship 
			and o.ship not in (
					select name 
					from ships
					)
			)
group by  battle, country
having count(*) > 2

-- Вариант 2 (Меньше cost в почти 3 раза)
select distinct battle 
from (
	select battle, ship, country
	from classes  as c
		join ships as s on c.class = s.class
		join Outcomes on ships.name = outcomes.ship
			-- находятся корабли из таблицы ships, участвовашие в сражении
	union
	-- добавление "головных" кораблей
	select battle, ship, country
	from Outcomes as o
		join Classes as c on o.ship = c.class
	) as X
GROUP BY battle, country
HAVING COUNT(*) > 2