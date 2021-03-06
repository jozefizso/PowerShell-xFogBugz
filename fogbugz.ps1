Configuration FogBugzPrerequisites
{
  Import-DscResource -ModuleName PSDscResources

  # Web Server (IIS)
  WindowsFeature Web-Server
  {
    Name = "Web-Server"
    Ensure = "Present"
  }

  # Common HTTP Features
  WindowsFeature Web-Common-Http
  {
    Name = "Web-Common-Http"
    Ensure = "Present"
  }

  # Default Document
  WindowsFeature Web-Default-Doc
  {
    Name = "Web-Default-Doc"
    Ensure = "Present"
  }

  # Directory Browsing
  WindowsFeature Web-Dir-Browsing
  {
    Name = "Web-Dir-Browsing"
    Ensure = "Present"
  }

  # HTTP Errors
  WindowsFeature Web-Http-Errors
  {
    Name = "Web-Http-Errors"
    Ensure = "Present"
  }

  # Static Content
  WindowsFeature Web-Static-Content
  {
    Name = "Web-Static-Content"
    Ensure = "Present"
  }


  # Health and Diagnostics
  WindowsFeature Web-Health
  {
    Name = "Web-Health"
    Ensure = "Present"
  }

  # HTTP Logging
  WindowsFeature Web-Http-Logging
  {
    Name = "Web-Http-Logging"
    Ensure = "Present"
  }


  # Performance
  WindowsFeature Web-Performance
  {
    Name = "Web-Performance"
    Ensure = "Present"
  }

  # Static Content Compression
  WindowsFeature Web-Stat-Compression
  {
    Name = "Web-Stat-Compression"
    Ensure = "Present"
  }


  # Security
  WindowsFeature Web-Security
  {
    Name = "Web-Security"
    Ensure = "Present"
  }

  # Request Filtering
  WindowsFeature Web-Filtering
  {
    Name = "Web-Filtering"
    Ensure = "Present"
  }


  # .NET Extensibility 3.5
  WindowsFeature Web-Net-Ext
  {
    Name = "Web-Net-Ext"
    Ensure = "Present"
  }

  # ASP.NET 3.5
  WindowsFeature Web-Asp-Net
  {
    Name = "Web-Asp-Net"
    Ensure = "Present"
  }



  # ISAPI Extensions
  WindowsFeature Web-ISAPI-Ext
  {
    Name = "Web-ISAPI-Ext"
    Ensure = "Present"
  }

  # ISAPI Filters
  WindowsFeature Web-ISAPI-Filter
  {
    Name = "Web-ISAPI-Filter"
    Ensure = "Present"
  }


  # Management Tools
  WindowsFeature Web-Mgmt-Tools
  {
    Name = "Web-Mgmt-Tools"
    Ensure = "Present"
  }

  # IIS Management Console
  WindowsFeature Web-Mgmt-Console
  {
    Name = "Web-Mgmt-Console"
    Ensure = "Present"
  }

  # IIS 6 Management Compatibility
  WindowsFeature Web-Mgmt-Compat
  {
    Name = "Web-Mgmt-Compat"
    Ensure = "Present"
  }

  # IIS 6 Metabase Compatibility
  WindowsFeature Web-Metabase
  {
    Name = "Web-Metabase"
    Ensure = "Present"
  }


  # IIS 6 Scripting Tools
  WindowsFeature Web-Lgcy-Scripting
  {
    Name = "Web-Lgcy-Scripting"
    Ensure = "Present"
  }

  # IIS 6 WMI Compatibility
  WindowsFeature Web-WMI
  {
    Name = "Web-WMI"
    Ensure = "Present"
  }

  # IIS Management Scripts and Tools
  WindowsFeature Web-Scripting-Tools
  {
    Name = "Web-Scripting-Tools"
    Ensure = "Present"
  }



  # .NET Framework 3.5 Features
  WindowsFeature NET-Framework-Features
  {
    Name = "NET-Framework-Features"
    Ensure = "Present"
  }

  # .NET Framework 3.5 (includes .NET 2.0 and 3.0)
  WindowsFeature NET-Framework-Core
  {
    Name = "NET-Framework-Core"
    Ensure = "Present"
  }
}

Configuration xFogBugzRegistrySettings
{
  param (
    [Parameter(Mandatory = $true)]
    [string] $wwwroot,
    [Parameter(Mandatory = $true)]
    [string] $dbHost,
    [Parameter(Mandatory = $true)]
    [string] $dbPort = 3306,
    [Parameter(Mandatory = $true)]
    [string] $dbName,
    [Parameter(Mandatory = $true)]
    [string] $dbUser,
    [Parameter(Mandatory = $true)]
    [string] $dbPassword
  )

  Import-DscResource -ModuleName xPSDesiredStateConfiguration

  $installId = $wwwroot.Replace('\', '/')
  $regPath = "HKLM:\SOFTWARE\Fog Creek Software\FogBugz\$installId"
  $localMachineName = $env:COMPUTERNAME

  xRegistry FogBugzRegistry_sConnectionString
  {
      Key         = "$regPath"
      ValueName   = "sConnectionString"
      # Option=16384 (= Treat BIGINT columns as INT columns)
      ValueData   = "Driver={mysql};Server=$dbHost;Port=$dbPort;Database=$dbName;User=$dbUser;Password=$dbPassword;Option=16387"
      Ensure      = "Present"
      Force       = $true
  }

  xRegistry FogBugzRegistry_sInstallerUrl
  {
      Key         = "$regPath"
      ValueName   = "sInstallerUrl"
      ValueData   = "http://$localMachineName/"
      Ensure      = "Present"
      Force       = $true
  }

  xRegistry FogBugzRegistry_sURL
  {
      Key         = "$regPath"
      ValueName   = "sURL"
      ValueData   = "http://$localMachineName"
      Ensure      = "Present"
      Force       = $true
  }

  xRegistry FogBugzRegistry_sLanguage
  {
      Key         = "$regPath"
      ValueName   = "sLanguage"
      ValueData   = "en-us"
      Ensure      = "Present"
      Force       = $true
  }

  xRegistry FogBugzRegistry_sRegistryVersion
  {
      Key         = "$regPath"
      ValueName   = "sRegistryVersion"
      ValueData   = "4"
      Ensure      = "Present"
      Force       = $true
  }

  xRegistry FogBugzRegistry_fDemo
  {
      Key         = "$regPath"
      ValueName   = "fDemo"
      ValueData   = "0"
      Ensure      = "Present"
      Force       = $true
  }

  xRegistry FogBugzRegistry_fDebug
  {
      Key         = "$regPath"
      ValueName   = "fDebug"
      ValueData   = "0"
      Ensure      = "Present"
      Force       = $true
  }

  xScript ScriptExample
  {
    SetScript = {
      $acl = Get-Acl -Path 'HKLM:\SOFTWARE\Fog Creek Software\FogBugz'
      $rule = New-Object System.Security.AccessControl.RegistryAccessRule("FogBugz", "FullControl", "ContainerInherit", "None", "Allow")
      $acl.SetAccessRule($rule)
      $acl | Set-Acl -Path 'HKLM:\SOFTWARE\Fog Creek Software\FogBugz'
    }
    TestScript = {
      $acl = Get-Acl -Path 'HKLM:\SOFTWARE\Fog Creek Software\FogBugz'
      $fbAcl = $acl.Access | Where-Object { $_.IdentityReference -eq "$env:COMPUTERNAME\FogBugz" }

      return $fbAcl -and ($fbAcl.RegistryRights -eq 'FullControl') -and ($fbAcl.AccessControlType -eq 'Allow') -and ($fbAcl.InheritanceFlags -eq 'ContainerInherit')
    }
    GetScript = {
      $acl = Get-Acl -Path 'HKLM:\SOFTWARE\Fog Creek Software\FogBugz'

      return @{
          Result = $acl
      }
    }
  }
}

Configuration xFogBugz
{
  param (
    [Parameter(Mandatory = $true)]
    [string] $fogbugzDeployPath,
    [Parameter(Mandatory = $true)]
    [PSCredential] $user
  )

  Import-DscResource -Module PSDscResources
  Import-DscResource -Module xWebAdministration
  Import-DscResource -Module cNtfsAccessControl

  Node localhost
  {
    $wwwroot = $fogbugzDeployPath + '\website'

    FogBugzPrerequisites FogBugzPrerequisites
    {}

    File FogBugzDist
    {
      Type = "Directory"
      DestinationPath = $fogbugzDeployPath
      Ensure = "Present"
    }

    xWebsite FogBugzWebsite
    {
      Ensure       = "Present"
      Name         = "FogBugz"
      State        = "Started"
      ApplicationPool = "FogBugz AppPool"
      PhysicalPath = "$wwwroot"
      BindingInfo  = @(
        MSFT_xWebBindingInformation
        {
          Protocol = "HTTP"
          Port     = 80
          HostName = $env:COMPUTERNAME
        }
      )
      DependsOn       = "[File]FogBugzDist", "[xWebAppPool]FogBugzWebsiteAppPool", "[FogBugzPrerequisites]FogBugzPrerequisites"
    }

    xWebAppPool FogBugzWebsiteAppPool
    {
      Ensure = "Present"
      Name = "FogBugz AppPool"
      State = "Started"
      AutoStart = $true
      IdentityType = "SpecificUser"
      Credential = $user
      LoadUserProfile = $true
      ManagedRuntimeVersion = "v2.0"
      ManagedPipelineMode = "Integrated"
      StartMode = "AlwaysRunning"
    }

    # The Service resource requires PSDscResources@2.7.0.0 to correctly configure Windows Service
    Service FogBugzMaintenanceService
    {
      Name        = "FogBugz Maintenance Service"
      Description = "Performs regular maintenance on FogBugz databases"
      StartupType = "Automatic"
      State       = "Running"
      Path        = "$fogbugzDeployPath\Accessories\FogBugzMaint.exe"
      Credential  = $user
      DependsOn   = "[User]FogBugzUserAccount", "[File]FogBugzDist"
    }

    User FogBugzUserAccount
    {
      UserName = "FogBugz"
      Description = "Account for running FogBugz website and maintanance service."
      Disabled = $false
      FullName = "FogBugz User"
      Password = $user
      PasswordChangeNotAllowed = $true
      PasswordChangeRequired = $false
      PasswordNeverExpires = $true
      Ensure = "Present"
    }

    GroupSet FogBugzUserGroupMembership
    {
      GroupName        = @("IIS_IUSRS")
      MembersToInclude = @("FogBugz")
      #DependsOn        = "[User]FogBugzUserAccount"
      Ensure           = "Present"
    }

    cNtfsPermissionEntry FogBugzWebsiteRootPermissions
    {
      Principal = "FogBugz"
      Path      = "$fogbugzDeployPath"
      AccessControlInformation = @(
        cNtfsAccessControlInformation
        {
          AccessControlType = "Allow"
          FileSystemRights = "Read"
        }
      )
      DependsOn = "[User]FogBugzUserAccount", "[File]FogBugzDist"
      Ensure    = "Present"
    }

    File FogBugzWebsiteFileUploadsDirectory
    {
      Type = "Directory"
      DestinationPath = "$fogbugzDeployPath\FileUploads"
      Ensure = "Present"
    }

    cNtfsPermissionEntry FogBugzWebsiteUploadPermissions
    {
      Principal = "FogBugz"
      Path      = "$fogbugzDeployPath\FileUploads"
      AccessControlInformation = @(
        cNtfsAccessControlInformation
        {
          AccessControlType = "Allow"
          FileSystemRights = "Read,Write"
        }
      )
      DependsOn = "[User]FogBugzUserAccount", "[File]FogBugzWebsiteFileUploadsDirectory"
      Ensure    = "Present"
    }

    cNtfsPermissionEntry FogBugzWebsitePluginsPermissions
    {
      Principal = "FogBugz"
      Path      = "$fogbugzDeployPath\plugins"
      AccessControlInformation = @(
        cNtfsAccessControlInformation
        {
          AccessControlType = "Allow"
          FileSystemRights = "FullControl"
        }
      )
      DependsOn = "[User]FogBugzUserAccount"
      Ensure    = "Present"
    }

    cNtfsPermissionEntry FogBugzWebsiteBinPermissions
    {
      Principal = "FogBugz"
      Path      = "$fogbugzDeployPath\Website\bin"
      AccessControlInformation = @(
        cNtfsAccessControlInformation
        {
          AccessControlType = "Allow"
          FileSystemRights = "ReadAndExecute"
        }
      )
      DependsOn = "[User]FogBugzUserAccount"
      Ensure    = "Present"
    }

    cNtfsPermissionEntry FogBugzWebsiteAccessoriesPermissions
    {
      Principal = "FogBugz"
      Path      = "$fogbugzDeployPath\Accessories"
      AccessControlInformation = @(
        cNtfsAccessControlInformation
        {
          AccessControlType = "Allow"
          FileSystemRights = "Read,Write"
        }
      )
      DependsOn = "[User]FogBugzUserAccount"
      Ensure    = "Present"
    }
  }
}

$config = @{
  AllNodes = @(
    @{
      NodeName = "localhost"
      PSDscAllowPlainTextPassword = $true
    }
  )
}

$fogbugzDeployPath = 'C:\inetpub\fogbugz'
$wwwroot = $fogbugzDeployPath + '\website'

$username = "FogBugz"
$password = 'FogBugzPwd1234!@#$' | ConvertTo-SecureString -AsPlainText -Force
$credential = New-Object System.Management.Automation.PSCredential($username, $password)

# Compile the web server prerequisites
xFogBugz -ConfigurationData $config -fogbugzDeployPath $fogbugzDeployPath -user $credential
Start-DscConfiguration -Path .\xFogBugz -Verbose -Wait -Force

# Compile database configuration
$dbHost = "localhost"
$dbPort = 3306
$dbName = "fogbugz"
$dbUser = "fb_user"
$dbPassword = 'FogBugzPwd1234!@#$'

#xFogBugzRegistrySettings -wwwroot $wwwroot -dbHost $dbHost -dbPort $dbPort -dbName $dbName -dbUser $dbUser -dbPassword $dbPassword
#Start-DscConfiguration -Path .\xFogBugzRegistrySettings -Verbose -Wait -Force

