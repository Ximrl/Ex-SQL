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

-- Задача № 77 2* - Определить дни, когда было выполнено максимальное число рейсов из Ростова ('Rostov'). 
--					Вывод: число рейсов, дата.  

-- Вариант 1
with rostov as (
	select count(distinct trip.trip_no) as qty, date
	from trip 
		join pass_in_trip on trip.trip_no = pass_in_trip.trip_no
	where town_from = 'Rostov'
	group by date
)

select qty, date 
from rostov
where qty >= ALL (select qty from rostov)

-- Вариант 2
select top(1) with ties count(distinct trip.trip_no) as qty, date
from trip 
	join pass_in_trip on trip.trip_no = pass_in_trip.trip_no
where town_from = 'Rostov'
group by date
order by qty desc