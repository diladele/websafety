Web Safety for Squid
====================

Web Safety is a simple and powerful web filtering proxy / secure web gateway that provides rich content and web filtering functionality to sanitize Internet traffic passing into internal home/school/enterprise network. It may be used to block illegal or potentially malicious file downloads, remove annoying advertisements, prevent access to various categories of the web sites and block resources with explicit content.

The application is easily deployed and managed, requires minimal external dependencies, very robust and runs with excellent performance.
Main features of the application are:

- filters encrypted HTTPS traffic using Squid's SSL-Bump and Peek-n-Splice technologies
- blocks pornography and explicit (adult) contents by deep inspecting HTML contents and URLs (like Dansguardian)
- scans downloaded files for viruses (using eCAP ClamAV module)
- blocks file downloads
- performs group based web filtering (e.g. adults or admins are not filtered, kids or office workers are filtered extensively)
- controls web usage by categories (e.g. social networks are not allowed, explicit material is not allowed for children)
- removes annoying web ads 
- protects online privacy by disallowing access to web trackers

Fully configured versions of Web Safety can be quickly deployed as virtual appliance in VMware vSphere/ESXi, Microsoft Hyper-V, Microsoft Azure Cloud and Amazon AWS. It is also possible to install it on your real hardware by following installation tutorials in the Administrator Guide.

More information at https://www.diladele.com/websafety/
