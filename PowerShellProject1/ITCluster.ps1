# if they exist they will be skipped. I deleted the ones prior to overwrite.


$replicas = 'SECONDARYSVR1'
foreach ($svr in $replicas)
{
	Copy-DbaAgentJob -Source PRIMARYSVR -Destination $svr |ft -AutoSize 
}

<#
Synopsis
    Copy-DbaAgentJob migrates jobs from one SQL Server to another.

Description
    By default, all jobs are copied. The -Job parameter is auto-populated for command-line completion and can be used to copy only specific jobs.
    
    If the job already exists on the destination, it will be skipped unless -Force is used.


Parameters
    -Source <DbaInstanceParameter>
        Source SQL Server. You must have sysadmin access and server version must be SQL Server version 2000 or higher.

        Required?                    true
        Position?                    1
        Default value                
        Accept pipeline input?       false
        Accept wildcard characters?  false

    -SourceSqlCredential <PSCredential>
        Allows you to login to servers using SQL Logins instead of Windows Authentication (AKA Integrated or Trusted). To use:
        
        $scred = Get-Credential, then pass $scred object to the -SourceSqlCredential parameter.
        
        Windows Authentication will be used if SourceSqlCredential is not specified. SQL Server does not accept Windows credentials being passed as credentials.
        
        To connect as a different Windows user, run PowerShell as that user.

        Required?                    false
        Position?                    2
        Default value                
        Accept pipeline input?       false
        Accept wildcard characters?  false

    -Destination <DbaInstanceParameter>
        Destination SQL Server. You must have sysadmin access and the server must be SQL Server 2000 or higher.

        Required?                    true
        Position?                    3
        Default value                
        Accept pipeline input?       false
        Accept wildcard characters?  false

    -DestinationSqlCredential <PSCredential>
        Allows you to login to servers using SQL Logins instead of Windows Authentication (AKA Integrated or Trusted). To use:
        
        $dcred = Get-Credential, then pass this $dcred to the -DestinationSqlCredential parameter.
        
        Windows Authentication will be used if DestinationSqlCredential is not specified. SQL Server does not accept Windows credentials being passed as credentials.
        
        To connect as a different Windows user, run PowerShell as that user.

        Required?                    false
        Position?                    4
        Default value                
        Accept pipeline input?       false
        Accept wildcard characters?  false

    -Job <Object[]>
        The job(s) to process. This list is auto-populated from the server. If unspecified, all jobs will be processed.

        Required?                    false
        Position?                    5
        Default value                
        Accept pipeline input?       false
        Accept wildcard characters?  false

    -ExcludeJob <Object[]>
        The job(s) to exclude. This list is auto-populated from the server.

        Required?                    false
        Position?                    6
        Default value                
        Accept pipeline input?       false
        Accept wildcard characters?  false

    -DisableOnSource <SwitchParameter>
        If this switch is enabled, the job will be disabled on the source server.

        Required?                    false
        Position?                    named
        Default value                False
        Accept pipeline input?       false
        Accept wildcard characters?  false

    -DisableOnDestination <SwitchParameter>
        If this switch is enabled, the newly migrated job will be disabled on the destination server.

        Required?                    false
        Position?                    named
        Default value                False
        Accept pipeline input?       false
        Accept wildcard characters?  false

    -Force <SwitchParameter>
        If this switch is enabled, the Job will be dropped and recreated on Destination.

        Required?                    false
        Position?                    named
        Default value                False
        Accept pipeline input?       false
        Accept wildcard characters?  false

    -Silent <SwitchParameter>
        If this switch is enabled, the internal messaging functions will be silenced.

        Required?                    false
        Position?                    named
        Default value                False
        Accept pipeline input?       false
        Accept wildcard characters?  false

    -WhatIf <SwitchParameter>
        If this switch is enabled, no actions are performed but informational messages will be displayed that explain what would happen if the command were to run.

        Required?                    false
        Position?                    named
        Default value                
        Accept pipeline input?       false
        Accept wildcard characters?  false

    -Confirm <SwitchParameter>
        If this switch is enabled, you will be prompted for confirmation before executing any operations that change state.

        Required?                    false
        Position?                    named
        Default value                
        Accept pipeline input?       false
        Accept wildcard characters?  false



Syntax
    Copy-DbaAgentJob [-Source] <DbaInstanceParameter> [[-SourceSqlCredential] <PSCredential>] [-Destination] <DbaInstanceParameter> [[-DestinationSqlCredential] <PSCredential>] [[-Job] <Object[]>] [[-ExcludeJob] <Object[]>] [-DisableOnSource ] [-DisableOnDestination ] [-Force ] [-Silent ] [-WhatIf ] [-Confirm ] [<CommonParameters>]


Notes
    Tags: Migration, Agent, Job
    Author: Chrissy LeMaire (@cl), netnerds.net
    
    Website: https://dbatools.io
    Copyright: (C) Chrissy LeMaire, clemaire@gmail.com
    License: GNU GPL v3 https://opensource.org/licenses/GPL-3.0

Examples
    -------------------------- EXAMPLE 1 --------------------------
    PS C:\>Copy-DbaAgentJob -Source sqlserver2014a -Destination sqlcluster
    
    Copies all jobs from sqlserver2014a to sqlcluster, using Windows credentials. If jobs with the same name exist on sqlcluster, they will be skipped.




    -------------------------- EXAMPLE 2 --------------------------
    PS C:\>Copy-DbaAgentJob -Source sqlserver2014a -Destination sqlcluster -Job PSJob -SourceSqlCredential $cred -Force
    
    Copies a single job, the PSJob job from sqlserver2014a to sqlcluster, using SQL credentials for sqlserver2014a and Windows credentials for sqlcluster. If a job with the same name exists on sqlcluster, it will be dropped and recreated because -Force was used.




    -------------------------- EXAMPLE 3 --------------------------
    PS C:\>Copy-DbaAgentJob -Source sqlserver2014a -Destination sqlcluster -WhatIf -Force
    
    Shows what would happen if the command were executed using force.
#>