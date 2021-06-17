/*
Схема БД состоит из четырех отношений:
Company (ID_comp, name)
Trip(trip_no, ID_comp, plane, town_from, town_to, time_out, time_in)
Passenger(ID_psg, name)
Pass_in_trip(trip_no, date, ID_psg, place)
Таблица Company содержит идентификатор и название компании, осуществляющей перевозку пассажиров. 
Таблица Trip содержит информацию о рейсах: номер рейса, идентификатор компании, тип самолета, город отправления, город прибытия, время отправления и время прибытия. 
Таблица Passenger содержит идентификатор и имя пассажира. 
Таблица Pass_in_trip содержит информацию о полетах: номер рейса, дата вылета (день), идентификатор пассажира и место, на котором он сидел во время полета. 
При этом следует иметь в виду, что
- рейсы выполняются ежедневно, а длительность полета любого рейса менее суток; town_from <> town_to;
- время и дата учитывается относительно одного часового пояса;
- время отправления и прибытия указывается с точностью до минуты;
- среди пассажиров могут быть однофамильцы (одинаковые значения поля name, например, Bruce Willis);
- номер места в салоне – это число с буквой; число определяет номер ряда, буква (a – d) – место в ряду слева направо в алфавитном порядке;
- связи и ограничения показаны на схеме данных.
*/

-- Задача № 76 2* - Определить время, проведенное в полетах, для пассажиров, летавших всегда на разных местах.
--					Вывод: имя пассажира, время в минутах. 

-- Вариант 1
select name, sum(
	case 
		when time_out < time_in 
		then datediff (mi, time_out, time_in) 
		else 24*60 - (datepart(hh,time_out)*60 + datepart(mi,time_out)) + datepart(hh,time_in)*60 + datepart(mi,time_in)
		end
	)
from passenger 
	join pass_in_trip on passenger.ID_psg = pass_in_trip.ID_psg 
	join trip on trip.trip_no = pass_in_trip.trip_no
group by name, passenger.id_psg
having count(place) = count(distinct place)

-- Вариант 2 (Дешевле в 3 раза)
select name, sum (minutes) as minutes
	from (
		select id_psg, case 
			when datediff(mi, time_out, time_in) > 0 
			then datediff (mi, time_out, time_in) 
			else datediff(mi, time_out, time_in)+ 1440 
			end as minutes
		from pass_in_trip 
			join trip on trip.trip_no = pass_in_trip.trip_no
		) as min join passenger on passenger.id_psg = min.id_psg
where passenger.id_psg in (
		select id_psg 
		from pass_in_trip
		group by id_psg
		having count(place) = count(distinct place)
		)
group by name, passenger.id_psg