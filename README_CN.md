# Surfing

<h1 align="center">
  <img src="./folder/logo.svg" alt="BOXMETA" width="200">
  <br>BOXMETA<br>
</h1>

<h3 align="center">Magisk, Kernelsu, APatch</h3>

<div align="center">
    <a href="https://github.com/MoGuangYu/Surfing/releases/tag/Prerelease-Alpha">
        <img alt="Android" src="https://img.shields.io/badge/Module Latestsnapshot-F05033.svg?logo=android&logoColor=white">
    </a>
    <a href="https://github.com/MoGuangYu/Surfing/releases">
    <img alt="Downloads" src="https://img.shields.io/github/downloads/MoGuangYu/Surfing/total?label=Module%20Download&labelColor=00b56a&logo=git&logoColor=white">
</a>
</div>
<br>
<div align="center">
    <a href="./README.md">English</a> | <strong>简体中文</strong>
</div>

---

本项目为 Clash/mihomo、sing-box、v2ray、xray、hysteria 的 [Magisk](https://github.com/topjohnwu/Magisk) 、 [Kernelsu](https://github.com/tiann/KernelSU) 、 [APatch](https://github.com/bmax121/APatch) 模块。支持 REDIRECT（仅 TCP）、TPROXY（TCP + UDP）透明代理，支持 TUN（TCP + UDP）亦可 REDIRECT（TCP）+ TUN（UDP） 混合模式代理。

基于上游为集成式一体服务、即刷即用   
此适用以下人群：
- 懒癌
- 小白

项目主题及配置仅围绕 [Clash/mihomo.Meta](https://github.com/MetaCubeX/Clash.Meta)  

本模块需在 Magisk/Kernelsu 环境进行使用，如果你不知道如何配置所需环境，你可能需要像 ClashForAndroid、v2rayNG、surfboard、SagerNet、AnXray 等应用程序。  

[Windows 用户](https://github.com/MoGuangYu/Surfing/releases/tag/Windows)

# Surfing用户声明及免责

欢迎使用 在使用本项目前，请您仔细阅读并理解以下声明及免责条款。通过使用本项目，即表示您同意接受以下条款和条件。以下简称 **Surfing**

## 免责声明

1. **本项目是一个开源项目，仅供学习和研究之用，不提供任何形式的担保。使用者必须对使用本项目的风险和后果负全部责任。**

2. **本项目仅为简化 Surfing 对 Clash 服务在 Android Magisk 环境中的安装和配置提供便利，并不对 Surfing 的功能和性能做出任何保证。如有任何问题或损失，本项目开发者概不负责。**

3. **本项目 Surfing 模块的使用可能会违反您所在地区的法律法规或服务提供商的使用条款。您需要自行承担使用本项目所带来的风险。本项目开发者不对您的行为或使用后果负责。**

4. **本项目开发者不对使用本项目产生的任何直接或间接损失或损害负责，包括但不限于数据丢失、设备损坏、服务中断、个人隐私泄露等。**

## 使用须知

1. **在使用本项目 Surfing 模块前，请确保您已经仔细阅读并理解 Clash 和 Magisk 的使用说明和相关文档，并遵守其规定和条款。**

2. **在使用本项目之前，请先备份您的设备数据和相关设置，以防发生意外情况。本项目开发者不对您的数据丢失或损坏负责。**

3. **请在使用本项目时遵守当地的法律法规，并尊重其他用户的合法权益。禁止使用本项目进行任何违法、滥用或侵权的行为。**

4. **如果您在使用本项目时遇到任何问题或有任何建议，欢迎您向本项目开发者反馈，但开发者对于解决问题和回应反馈没有义务和责任。**

请您在明确理解并接受上述声明及免责条款后，再决定是否使用 Surfing 模块。如果您不同意或无法接受上述条款，请立即停止使用本项目。

## 法律适用

**在使用本项目的过程中，您须遵守您所在地区的法律法规。如有任何争议，应依照当地法律法规进行解释和处理。**

## 安装

- 从 [Release](https://github.com/MoGuangYu/Surfing/releases) 页下载模块压缩包，然后通过 Magisk Manager 或 KernelSU Manager 或 APatch 安装
- 各版本变化 [📲日志.log](changelog.md)

## 卸载

 - 从 Magisk Manager 、Kernelsu Manager 、APatch 应用卸载本模块即可 [👉🏻铲屎命令](https://github.com/MoGuangYu/Surfing/blob/main/uninstall.sh#L3-L4)

## Wiki

<details>
<summary>1. 首次使用</summary>

- 安装模块后无需重启设备，可使用`Toolbox`整合并刷新客户端的更新状态
- 首次安装完成后，于`config.yaml`添加你的订阅地址，并通过开关重启一下模块服务
- 可能因网络原因不会自动下载完全部 **规则**/**订阅**，请至面板手动刷新一下
  - 如上述失败，并确保你的网络环境正常
- Web App：
  - 仅为图形辅助工具，用于便携浏览及管理后台路由数据，并无其它多余用途

<img src="./folder/Webapk.png" alt="Web UI" width="300">

> 模块已内置 Gui 可通过浏览器本地访问使用，亦或者使用 App 在线访问使用，两者本质上并无差异

</details>

#

<details>
<summary>2. 控制运行</summary>

- 可通过 **WiFi SDID** 网络控制启停
- 可通过模块开关进行 关闭/开启 控制运行服务实时生效
- 可向系统状态栏添加模块的控制开关  

<img src="./folder/KAKJFS.jpg" alt="KJFS" width="300">

[下载Apk](https://www.coolapk.com/apk/com.coolapk.market) | [复制URL](https://raw.githubusercontent.com/MoGuangYu/Surfing/main/folder/KJFSURL.md)

<img src="./folder/BJZDY.jpg" alt="KJFS" width="300">

- 进入设置

<img src="./folder/WLDR.jpg" alt="KJFS" width="300">

- 导入URL

<img src="./folder/CTSZ.jpg" alt="KJFS" width="300">

- 向状态栏自定义磁贴

</details>

#

<details>
<summary>3. 路由规则</summary>

GitHub Actions 北京时间每天早上 6 点自动构建，保证规则最新  [Wiki](https://github.com/MetaCubeX/meta-rules-dat)  

> 路由规则全使用在线链接，24小时自动更新

</details>

#

<details>
<summary>4. 后续更新</summary>

- 如果你全部使用默认配置，更新将是无感
- 支持在客户端中在线更新模块，更新后无须重启，模块开关控制 启用/关闭 ~~会临时失效，仍需重启~~ 亦或使用 Toolbox 更新
- 更新时 Clash.Meta config.yaml 配置文件会备份至
   - `config.yaml.bak`
- 更新时会备份旧文件用户配置，至
   - `box.config.bak`
- 更新时会自动提取你的订阅地址并备份，至
   - `subscribe_urls_backup.txt`
   - 自动提取备份并恢复至新配置中，适用于使用默认配置文件的
- 更新模块时不包含：
   - Geo数据库文件
   - bin文件
   - Web资源

> Ps：主要跟随上游更新，及下发一些配置

</details>

#

<details>
<summary>5. 使用问题</summary>

一、代理特定应用程序(黑白名单)
- 代理所有应用程序，除了某些特定的应用外，那么请打开 `/data/adb/box_bll/scripts/box.config` 文件，修改 `proxy_mode` 的值为 `blacklist`（默认值），在 `user_packages_list` 数组中添加元素，数组元素格式为`id标识:应用包名`，元素之间用空格隔开。即可**不代理**相应安卓用户应用。例如 `user_packages_list=("id标识:应用包名" "id标识:应用包名")`

- 只代理特定的应用程序，那么请打开 `/data/adb/box_bll/scripts/box.config` 文件，修改 `proxy_mode` 的值为 `whitelist`，在 `user_packages_list` 数组中添加元素，数组元素格式为`id标识:应用包名`，元素之间用空格隔开。即可**仅代理**相应安卓用户应用。例如 `user_packages_list=("id标识:应用包名" "id标识:应用包名")`

安卓用户组id标识：

| 标准用户 | ID  |
| -------- | --- |
| 机主     |  0  |
| 手机分身 |  10  |
| 应用多开 | 999 |

> 通常你可以在`/data/user/`找到本机所有用户组id及应用包名，使用黑白名单请勿使用fake-ip模式

二、Tun模式
- 默认开启

> 推荐开启，如非特殊需要可不开启，使用该模式前请勿使用黑白名单

三、路由规则
- 为大陆饶行
- 基本能满足大多数日常使用需求

> 如非特别严格的要求，黑白名单意义不大，使用模块自带配置即可

四、面板管理
- Magisk字体模块

> 会影响页面字体正常显示

五、局域网共享
- 开启热点让其它设备连接即可

> 其它设备若访问控制台后端，只需 (http://当前WiFi网关:9090/ui)

</details>

---

<a href="./LICENSE">
    <img alt="License" src="https://img.shields.io/github/license/MoGuangYu/Surfing.svg">
</a>


## 致谢

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
  <p> > 感谢为本项目的实现提供了宝贵的基础 < </p>
</div>
