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

-- Задача № 83 2* - Определить названия всех кораблей из таблицы Ships, которые удовлетворяют, по крайней мере, комбинации любых четырёх критериев из следующего списка:
/*					numGuns = 8
					bore = 15
					displacement = 32000
					type = bb
					launched = 1915
					class = Kongo
					country = USA 
*/

-- Вариант 1
select ship 
from (
		Select case when case when numguns = 8 then 1  else 0 end +
			case when bore = 15 then 1 else 0 end +
			case when displacement = 32000 then 1 else 0 end +
			case when type = 'bb'  then 1 else 0 end +
			case when launched = 1915 then 1 else 0 end +
			case when classes.class = 'Kongo'  then 1 else 0 end +
			case when country = 'USA'  then 1 else 0 end >= 4 then name end ship
		from ships 
			join classes on classes.class = ships.class
		group by name) as x
where ship is not null

-- Вариант 2 (Меньше операций)
select name
from ships 
	join classes on classes.class = ships.class
where case when numguns = 8 then 1  else 0 end +
	case when bore = 15 then 1 else 0 end +
	case when displacement = 32000 then 1 else 0 end +
	case when type = 'bb'  then 1 else 0 end +
	case when launched = 1915 then 1 else 0 end +
	case when classes.class = 'Kongo'  then 1 else 0 end +
	case when country = 'USA'  then 1 else 0 end >= 4