Windows Add-on 
----------------------------------------
Author: Splunk
Source type(s): MonitorWare, NTSyslog, Snare, WinEventLog, DhcpSrvLog, WMI, WindowsUpdateLog, WinRegistry
Has index-time operations: true, this add-on must be placed on indexers
Input requirements: This add-on supports multiple sources; see the "Using this add-on" section for details.
Supported product(s): 
* Microsoft DHCP server
* Windows event logs (provided by Splunk, MonitorWare, NTSyslog, or Snare)
* Windows update logs
* Windows registry (via the Splunk's change monitoring system)
* Microsoft Internet Authentication Service (IAS)

New in this release:
--------------------------
Per minor change to CIM for patch and update status reporting (SPL-50858):
The Windows Add-on (Splunk_TA_windows) was updated to accommodate Common Information Model (CIM) changes to "patch/update" reporting.  This change has been applied to the "WindowsUpdateLog", "WMI:Update" and "WinEventLog:System" (EventCode 17, 18, 19) source types.
"package_title" has been aliased to "signature"
"package" has been aliased to "signature_id"

Per accommodate new Endpoint Change data model (SPL-50859):
The Windows Add-on (Splunk_TA_windows) was updated to accommodate Common Information Model (CIM) changes to "endpoint change" reporting.  This change is applied to the "fs_notification" and "WinRegistry" source types.
The specific field names and data types are documented in the "Change Analysis" section of the Common Information Model Field Reference in the Data Source Integration Manual in the Splunk App for PCI Compliance documentation - http://docs.splunk.com/Documentation/PCI/DataSource/CommonInformationModelFieldReference#Change_Analysis
Note: All changes are backwards compatible with Enterprise Security 2.0.x, which does not yet conform to the updated model.

Using this add-on:
----------------------------------------
Configuration: Manual
Ports for automatic configuration: None
Scripted input setup: Not applicable


The Windows Add-on supports multiple products. The methods to incorporate each log type varies. Below is a breakdown of the various log types and how to enable them.
    
    _____________________________________
    Microsoft DHCP Server:
    Microsoft DHCP server logs are stored in a text file on the DHCP server. These files can be imported by monitoring the file directly and manually assigning a source type of DhcpSrvLog. By default, the logs are stored in %windir%\System32\Dhcp. See http://technet.microsoft.com/en-us/library/dd183591(WS.10).aspx for additional information.
    
    _____________________________________
    Windows Event Logs:
    Windows event logs can be obtained by actively gathering them with a Splunk Forwarder, remotely with Splunk via WMI, or accepting them via 3rd party syslog (such as Snare or Monitorware). If using syslog, add a data input that corresponds to the product that is forwarding the logs.

Here is an example input (in transforms.conf) for processing Windows syslog data from Snare:
    
         [source::udp:514]
         SHOULD_LINEMERGE=false
         TRANSFORMS-force_sourcetype_for_snare_syslog = force_sourcetype_for_snare
         TRANSFORMS-force_host_for_snare_syslog = force_host_for_snare
         TRANSFORMS-force_source_for_snare_syslog = force_source_for_snare
    
    To obtain the Windows Event Logs via deployed Splunk Forwarders, see deployment-apps/README
    To obtain the Windows Event Logs via WMI, configure WMI per Splunk's documentation: http://docs.splunk.com/Documentation/Splunk/latest/Data/MonitorWMIdata
    
    ** To collect Windows event logs via NTSyslog, do the following:
    1.  Disable the replication blacklist for ntsyslog_mappings.csv in $SPLUNK_HOME/etc/apps/Splunk_TA_windows/local/distsearch.conf:
    [replicationBlacklist]
    nontsyslogmappings = 
    
    2.  Enable the following setting in $SPLUNK_HOME/etc/apps/Splunk-TA-windows/local/props.conf:
    [source::NTSyslog:Security]
    LOOKUP-2action_EventCode_for_ntsyslog = ntsyslog_mappings NTSyslogID OUTPUTNEW action,EventCode,EventCode as signature_id
    
    _____________________________________
    Windows Update Logs:
    Windows update logs will be automatically discovered within the Windows Event Logs. See the "Windows Event Logs" section above for how to incorporate Windows Event Logs.
    
    _____________________________________
    Microsoft Internet Authentication Service (IAS):
    Microsoft Internet Authentication Service logs will be automatically discovered within the Windows Event Logs, see the "Windows Event Logs" section above for how to incorporate Windows Event Logs.
    
    _____________________________________
    Windows Registry:
    See http://docs.splunk.com/Documentation/Splunk/latest/Data/MonitorWindowsregistrydata for information on how to configure registry monitoring.
    
    
 Copyright (C) 2005-2012 Splunk Inc. All Rights Reserved.
