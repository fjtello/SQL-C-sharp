declare @f as table(id int identity, fecha date);
insert into @f
	exec proc_get_datetable @startingDate = '2019-10-01', @finishingDate = '2019-11-20', @increment = 2, @interval='w';
select * from @f order by fecha
