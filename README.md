
# Surfing

<h1 align="center">
  <img src="./folder/Logo.png" alt="CLASHMETA" width="200">
  <br>CLASHMETA<br>
</h1>

<h3 align="center">Magisk or Kernelsu</h3>

<div align="center">
    <a href="https://github.com/MoGuangYu/Surfing/releases/tag/Prerelease-Alpha">
        <img alt="Android" src="https://img.shields.io/badge/Module Latestsnapshot-F05033.svg?logo=android&logoColor=white">
    </a>
    <a href="https://github.com/MoGuangYu/Surfing/releases/tag/v6.8.1">
        <img alt="Downloads" src="https://img.shields.io/github/downloads/MoGuangYu/Surfing/v6.8.1/total?label=Download@v6.8.1&labelColor=00b56a&logo=git&logoColor=white">
    </a>
</div>

#

**English** | [简体中文](./README_CN.md)  

This project is a [Magisk](https://github.com/topjohnwu/Magisk) and [Kernelsu](https://github.com/tiann/KernelSU) module for Clash, sing-box, v2ray, and xray. It supports REDIRECT (TCP only), TPROXY (TCP + UDP) transparent proxy, TUN (TCP + UDP), and a mixed mode proxy with REDIRECT (TCP) + TUN (UDP).

Based on the upstream for integrated services, flash and use. This is suitable for the following people:
- Procrastinators
- Beginners

The project theme and configuration revolve around [Clash.Meta](https://github.com/MetaCubeX/Clash.Meta).  

This module needs to be used in the Magisk/Kernelsu environment. If you dont know how to configure the required environment, you may need apps like ClashForAndroid, v2rayNG, surfboard, SagerNet, AnXray, etc.

# Surfing User Declaration and Disclaimer

Welcome to use Surfing. Before using this project, please carefully read and understand the following statements and disclaimers. By using this project, you agree to accept the following terms and conditions. Hereinafter referred to as **Surfing**.

## Disclaimer

1. **This project is an open-source project for learning and research purposes only and does not provide any form of guarantee. Users must bear full responsibility for the risks and consequences of using this project.**

2. **This project is only for the convenience of simplifying the installation and configuration of Surfing for Clash services in the Android Magisk environment. It does not make any guarantees about the functionality and performance of Surfing. The developer of this project is not responsible for any problems or losses.**

3. **The use of this projects Surfing module may violate the laws and regulations of your region or the terms of service of service providers. You need to bear the risks of using this project on your own. The developer of this project is not responsible for your actions or the consequences of use.**

4. **The developer of this project is not responsible for any direct or indirect losses or damages resulting from the use of this project, including but not limited to data loss, device damage, service interruption, personal privacy leaks, etc.**

## Instructions for Use

1. **Before using the Surfing module, please make sure you have carefully read and understood the usage instructions and related documents of Clash and Magisk and comply with their rules and terms.**

2. **Before using this project, back up your device data and related settings to prevent unexpected situations. The developer of this project is not responsible for your data loss or damage.**

3. **Please comply with local laws and regulations and respect the legitimate rights and interests of other users when using this project. It is forbidden to use this project for illegal, abusive, or infringing activities.**

4. **If you encounter any problems or have any suggestions when using this project, you are welcome to provide feedback to the developer of this project, but the developer is not obligated to resolve issues or respond to feedback.**

Please decide whether to use the Surfing module only after clearly understanding and accepting the above statements and disclaimers. If you do not agree or cannot accept the above terms, please stop using this project immediately.

## Applicable Law

**During the use of this project, you must comply with the laws and regulations of your region. In case of any disputes, interpretation and resolution should be carried out in accordance with local laws and regulations.**

## Installation

- Download the module zip file from the [Release](https://github.com/MoGuangYu/Surfing/releases) page and install it through Magisk Manager or KernelSU Manager.
- Various version changes [📲changelog.md](changelog.md)

## Uninstallation

- You can uninstall this module from Magisk Manager or KernelSU Manager.

## Wiki

<details>
<summary>1. Firsttime Usage</summary>

- After successfully adding the subscription address, restart your phone. The complete rule files may not be automatically downloaded due to network issues. Manually navigate to the rule page at the bottom right of the proxy page on the Web App and click the refresh icon to update/download rule files. If you cant use the app due to network issues, please copy and open it in a browser:
  - `127.0.0.1:9090/ui`
  - If the above fails, try switching the module on and make sure your network environment is normal.
- Web App official: [Download](https://github.com/MoGuangYu/Surfing/raw/main/folder/Web_v5.5_release.apk) | [View Source Code](./folder/main.lua)
  - It is only a graphical tool for portable browsing and managing backend routing data, with no other additional uses.

> The module has a built-in GUI that can be accessed locally through a browser or online using the app. There is essentially no difference between the two.
</details>

#

<details>
<summary>2. Control Operation</summary>

- You can enable or disable real-time control of the running service through the module switch.
</details>

#

<details>
<summary>3. Script Updates</summary>

- UpdateGeo.sh script is used to update Geo database files in one click and requires the curl command. Please make sure you have already installed the curl command before running the script, and execute the following commands in the terminal one by one:
  - `pkg update`
  - `pkg install curl`
- If there are selective prompts during the installation process, select "Y" and press Enter.
- Termux App official: [Download](https://f-droid.org/repo/com.termux_118.apk)

> About the Geo database: GitHub Actions automatically builds it at 6 a.m. Beijing time every day to ensure the latest rules. It is used for routing rule matching to achieve precise diversion. The scripts updates will permanently point to the latest version, so youcan manually update it once a month.
</details>

#

<details>
<summary>4. Subsequent Updates</summary>

- Supports online module updates in Magisk Manager.
- No need to restart after the update, the service takes effect in real time.
- During the update, the Clash.Meta config.yaml configuration file will be backed up to:
   - `/data/adb/box_bll/clash/config.yaml.bak`
- During the update, the old user configuration files will be backed up to:
   - `/data/adb/box_bll/scripts/box.config.bak`
- Module updates will not include updates to database files:
   - geoip.dat, geosite.dat, country.mmdb

- Module updates will not include updates to database files. You can manually update them through the Web metacubexd configuration page or the script.

> Note: Updates mainly follow the upstream updates and issue some configurations.
</details>

#

<details>
<summary>5. Usage Issues</summary>

I. Proxy Specific Applications (Blacklist/Whitelist)
- If you want to proxy all applications except specific ones, open the `/data/adb/box_bll/scripts/box.config` file, change the value of `proxy_mode` to `blacklist` (default), and add elements to the `user_packages_list` array. The format of array elements is `id identifier: app package name`, separated by spaces. This will make the module **not proxy** the respective Android apps. For example: `user_packages_list=("id identifier: app package name" "id identifier: app package name")`

- If you only want to proxy specific applications, open the `/data/adb/box_bll/scripts/box.config` file, change the value of `proxy_mode` to `whitelist`, and add elements to the `user_packages_list` array in the same format. This will make the module **only proxy** the respective Android apps. For example: `user_packages_list=("id identifier: app package name" "id identifier: app package name")`

Android User Group Identifiers:

| Standard User | ID  |
| -------- | --- |
| Owner     |  0  |
| Second Space | 10  |
| Clone Apps | 999 |

> You can typically find all user group identifiers and app package names in `/data/user/` on your device. Avoid using the fake IP mode with blacklists/whitelists.

II. Tun Mode
- Disabled by default

> Not recommended for general use unless you have special requirements. Do not use blacklists/whitelists with this mode.

III. Routing Rules
- For bypassing China mainland.
- The rules are maintained by the developer and can satisfy most usage needs.

> Unless you have very strict requirements, blacklists/whitelists may not be very meaningful. You can use the modules built-in configuration.

IV. LAN Sharing
- Enable hotspot and let other devices connect.

> If other devices want to access the console backend, just use http://currentWiFiGateway:9090/ui
</details>

---

<a href="./LICENSE">
    <img alt="License" src="https://img.shields.io/github/license/MoGuangYu/Surfing.svg">
</a>

## Acknowledgments

<a href="https://github.com/CHIZI-0618">
  <p align="center">
    <img src="https://github.com/CHIZI-0618.png" width="100" height="100" alt="CHIZI-0618">
    <br>
    <strong>CHIZI-0618</strong>
  </p>
</a>

<div align="center">
  <a href="https://github.com/MetaCubeX"><strong>MetaCubeX</strong></a>
</div>

<div align="center">
  <a href="https://github.com/Loyalsoldier"><strong>Loyalsoldier</strong></a>
</div>
<div align="center">
  <p> > Thanks for providing valuable foundation for the implementation of this project. < </p>
</div>

