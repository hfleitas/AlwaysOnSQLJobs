if db_id('DBAWork') is null
begin
	create database DBAWork
end
go

use dbawork
go
create or alter procedure [dbo].[uspTest]
	@tbd as date null
as 
begin
	set @tbd =  isnull(@tbd,dateadd(day, - day(getdate()), getdate()))
	select @tbd as MonthEnding 
end
go

use tempdb
go
alter database dbawork set offline
go

--error
if 1=0
begin
	--job step here:
	declare @var as date = dateadd(day, -1, getdate())
	execute dbawork.dbo.uspTest @tbd = @var
end
else begin
	print '0'
end
go

--pass
if 1=0
begin
	--job step here:
	declare @var as date = dateadd(day, -1, getdate())
	execute dbawork.dbo.uspTest --@tbd = @var
end
else begin
	print '0 --pass: no var.'
end
go

--fixed
if 1=0
begin
	--job step here:
	declare @tbd as date = dateadd(day, -1, getdate())
	exec sp_executesql N'execute dbawork.dbo.uspTest @tbd = @tbd',  
		N'@tbd  date',  
		@tbd = @tbd;
end
else begin
	print '0 --fixed: dynamic sql'
end
go

--revert.
alter database dbawork set online