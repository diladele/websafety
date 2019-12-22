Web Safety for Squid
====================

Web Safety is an ICAP web filter that integrates with existing Squid proxy server and provides rich content and web filtering functionality to sanitize Internet traffic passing into internal home/enterprise network.

Main features of the application are:

- filters encrypted HTTPS traffic using Squid's SSL-Bump and Peek-n-Splice techologies
- blocks pornography and explicit (adult) contents by deep inspecting HTML contents and URLs (like Dansguardian)
- scans downloaded files for viruses (using eCAP ClamAV module)
- blocks file downloads
- performs group based web filtering (e.g. adults or admins are not filtered, kids or office workers are filtered extensively)
- controls web usage by categories (e.g. social networks are not allowed, explicit material is not allowed for childred)
- removes annoying web ads 
- protects online privacy by disallowing access to web trackers

Web Safety runs on modern versions of CentOS, Debian/Raspberry PI and Ubuntu Linux, providing comprehensive web filtering solution easily manageble from Web UI.

More information at https://www.diladele.com
