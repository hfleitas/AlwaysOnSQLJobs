# AlwaysOnSQLJobs
Sync SQL Jobs across AlwaysOn replicas.

## WhoIsActive (runs every 30 secs)

* step 1: LoggingActivity
```
if exists (select 1 
	from  sys.dm_hadr_availability_replica_states as ars
	inner join sys.availability_group_listeners as agl on ars.group_id = agl.group_id
	inner join sys.availability_replicas as arcn on arcn.replica_id = ars.replica_id
	where ars.role_desc = 'PRIMARY'
	and ars.operational_state_desc = 'ONLINE'
	and agl.dns_name = 'LG1'
	and arcn.replica_server_name = @@SERVERNAME)

begin
	--job step here:
	execute uspLogWhoIsActive
end

else begin
	print 'Server is not Primary for LG.'
end
```

* step 2: AGFailoverBackupMaintJobs 
```
if exists (select 1 
	from  sys.dm_hadr_availability_replica_states as ars
	inner join sys.availability_group_listeners as agl on ars.group_id = agl.group_id
	inner join sys.availability_replicas as arcn on arcn.replica_id = ars.replica_id
	where ars.role_desc = 'PRIMARY'
	and ars.operational_state_desc = 'ONLINE'
	and agl.dns_name = 'LG1'
	and arcn.replica_server_name = @@SERVERNAME)

begin
	--job step here:
	if exists (select top 1 1 from msdb.dbo.sysjobs where enabled = 0 and name in ('Backup.CheckDBs', 'Backup.Diff', 'Backup.Indexes', 'Backup.TLogs', 'Backup.UserDBs'))
	begin
		execute msdb.dbo.sp_update_job @job_name = 'Backup.CheckDBs', @enabled=1
		execute msdb.dbo.sp_update_job @job_name = 'Backup.Diff', @enabled=1
		execute msdb.dbo.sp_update_job @job_name = 'Backup.Indexes', @enabled=1
		execute msdb.dbo.sp_update_job @job_name = 'Backup.TLogs', @enabled=1
		execute msdb.dbo.sp_update_job @job_name = 'Backup.UserDBs', @enabled=1
	end
	else begin
		print 'Jobs are already Enabled.'
	end
end
else begin
	print 'Server is not Primary for LG. Disabling Jobs.'
	if exists (select 1 
		from  sys.dm_hadr_availability_replica_states as ars
		inner join sys.availability_group_listeners as agl on ars.group_id = agl.group_id
		inner join sys.availability_replicas as arcn on arcn.replica_id = ars.replica_id
		where ars.role_desc = 'SECONDARY'
		and (ars.operational_state_desc is null or ars.operational_state_desc='ONLINE')
		and agl.dns_name = 'LG1'
		and arcn.replica_server_name = @@SERVERNAME)
	begin
		--job step here:
		if exists (select top 1 1 from msdb.dbo.sysjobs where enabled = 1 and name in ('Backup.CheckDBs', 'Backup.Diff', 'Backup.Indexes', 'Backup.TLogs', 'Backup.UserDBs'))
		begin
			execute msdb.dbo.sp_update_job @job_name = 'Backup.CheckDBs', @enabled=0
			execute msdb.dbo.sp_update_job @job_name = 'Backup.Diff', @enabled=0
			execute msdb.dbo.sp_update_job @job_name = 'Backup.Indexes', @enabled=0
			execute msdb.dbo.sp_update_job @job_name = 'Backup.TLogs', @enabled=0
			execute msdb.dbo.sp_update_job @job_name = 'Backup.UserDBs', @enabled=0
		end
		else begin
			print 'Jobs are already Disabled.'
		end
	end 
else begin
	print 'Server is not Primary for LG.'
end
end
```

* step 3: AlertRedoQueueSize
```
if exists (select 1 
	from  sys.dm_hadr_availability_replica_states as ars
	inner join sys.availability_group_listeners as agl on ars.group_id = agl.group_id
	inner join sys.availability_replicas as arcn on arcn.replica_id = ars.replica_id
	where ars.role_desc = 'PRIMARY'
	and ars.operational_state_desc = 'ONLINE'
	and agl.dns_name = 'LG1'
	and arcn.replica_server_name = @@SERVERNAME)

begin
	--job step here:
	execute dbawork.dbo.uspAlertRedoQueueSize
end

else begin
	print 'Server is not Primary for LG.'
end
```
