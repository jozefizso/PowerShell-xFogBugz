# xFogBugz

> The **xFogBugz** module contains the DSC resources for configuring Windows Server with FogBugz bug tracking software.

## Installing FogBugz

Before running the configuration script you may have to enable bigger
payloads for Windows Remote Management.

```powershell
winrm set winrm/config @{MaxEnvelopeSizekb="8192"}
```

Enable and trust the PowerShell Gallery and install required DSC modules:

```powershell
Set-PSRepository -Name PSGallery -InstallationPolicy Trusted
Install-PackageProvider -Name NuGet -MinimumVersion 2.8.5.201

Install-Module -Name xWebAdministration
```

Run the configuration script `fogbugz.ps1` to install IIS, .NET 2.0 and ASP.NET 3.5:

```powershell
.\fogbugz.ps1
```

## License

MIT License, Copyright (c) 2017 Jozef Izso
