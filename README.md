# M Shell for tinycore-redpill

<p align="center">
  <img src="doc/스크린샷 2022-11-28 오후 5.21.53.png" width="100%" align=center alt="M SHELL for TCRP MENU">
</p>

This is a testing version. Do not use unless you are certain you have no data to lose.

Please note that minimum recommended memory size for configuring the loader is 2GB

# Instructions 

A typical build process starts with:

1. Burn images

    A. To burn physical gunzip and img files to a USB stick
    
    B. For virtual gunzip use the provided vmdk file
    
2. Boot Tinycore

3. Loader Building

<p align="center">
  <img src="doc/스크린샷 2022-11-27 오후 8.13.34.png" width="100%" align=center alt="M SHELL for TCRP MENU">
</p>

        A. Choose one of the Synology models.

<p align="center">
  <img src="doc/스크린샷 2022-11-27 오후 8.14.08.png" width="60%" align=center alt="M SHELL for TCRP MENU">
</p>

        B. Create a virtual serial number or enter a prepared serial number.

<p align="center">
  <img src="doc/스크린샷 2022-11-27 오후 8.14.47.png" width="60%" align=center alt="M SHELL for TCRP MENU">
</p>

        C. Select the real mac address of the nic or create a virtual mac address or 
           input the prepared mac address. 
           (If there are 2 nics, you can enter up to the 2nd mac address)
    
<p align="center">
  <img src="doc/스크린샷 2022-11-27 오후 8.15.31.png" width="60%" align=center alt="M SHELL for TCRP MENU">
</p>
    
        D. Build the loader.

6. Reboot
