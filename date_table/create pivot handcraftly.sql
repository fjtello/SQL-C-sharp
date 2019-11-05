
declare @f as table (id int identity, fecha date);

insert into @f
	exec proc_get_datetable @startingDate = '2019-10-01', @finishingDate = '2019-10-10'

if object_id('tempdb..#t') is not null
	drop table [tempdb]..#t;

create table #t (id int identity(1,1), code varchar(10));

declare @qf as date; set @qf = (select min(fecha) from @f);
declare @total_rows as int; set @total_rows = (select count(*) from @f where fecha >= @qf);
declare @q as int; set @q = (select count(*) from @f where fecha >= @qf);

declare @sql_table_add as varchar(255);

while (@q > 0)
	begin
		set @sql_table_add = N'alter table #t add [' + convert(varchar(10), @qf) + '] decimal(10,3);';
		EXECUTE(@sql_table_add);

		set @qf = (select MIN(fecha) from @f where fecha > @qf);
		set @q = (select count(*) from @f where fecha >= @qf);
	end

select * from #t
