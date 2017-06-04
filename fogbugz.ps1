Configuration FogBugzPrerequisites
{
  Import-DscResource –ModuleName 'PSDesiredStateConfiguration'

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

Configuration xFogBugz
{
  param (
    [Parameter(Mandatory = $true)]
    [string] $fogbugzArchivePath,
    [Parameter(Mandatory = $true)]
    [string] $wwwroot
  )

  Import-DscResource -Module xWebAdministration

  FogBugzPrerequisites FogBugzPrerequisites
  {}

  Archive FogBugzDistZip
  {
    Path = $fogbugzArchivePath
    Destination = $wwwroot
  }

  xWebsite FogBugzWebsite
  {
    Ensure       = "Present"
    Name         = "FogBugz"
    State        = "Started"
    PhysicalPath = $wwwroot
    BindingInfo  = @(
      MSFT_xWebBindingInformation
      {
        Protocol = "HTTP"
        Port     = 80
      }
    )
    DependsOn       = "[Archive]FogBugzDistZip"
  }
}


$fogbugzArchive = 'C:\install\FogBugz-8.8.55.zip'
$wwwroot = 'C:\inetpub\fogbugz'

# Compile the web server prerequisites
xFogBugz -fogbugzArchivePath $fogbugzArchive -wwwroot $wwwroot

Start-DscConfiguration -Path .\xFogBugz -Verbose -Wait
