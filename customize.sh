#!/sbin/sh

SKIPUNZIP=1
ASH_STANDALONE=1

if [ "$BOOTMODE" ! = true ] ; then
  abort "Error: 请在 Magisk Manager 或 KernelSU Manager 中安装"
elif [ "$KSU" = true ] && [ "$KSU_VER_CODE" -lt 10670 ] ; then
  abort "Error: 请更新您的 KernelSU Manager 版本"
fi

if [ "$KSU" = true ] && [ "$KSU_VER_CODE" -lt 10683 ] ; then
  service_dir="/data/adb/ksu/service.d"
else 
  service_dir="/data/adb/service.d"
fi

if [ ! -d "$service_dir" ] ; then
    mkdir -p $service_dir
fi

unzip -qo "${ZIPFILE}" -x 'META-INF/*' -d $MODPATH
if [ -d /data/adb/box_bll ] ; then
  mv /data/adb/box_bll/clash/cache.db /data/adb/box_bll/clash/cache_tmp.db
  #mv /data/adb/box_bll/clash/config.yaml /data/adb/box_bll/clash/config_tmp.yaml
  #mv /data/adb/box_bll/scripts/box.config /data/adb/box_bll/scripts/box_tmp.config
  mv /data/adb/box_bll/clash/geoip.dat /data/adb/box_bll/clash/geoip_tmp.dat
  mv /data/adb/box_bll/clash/geosite.dat /data/adb/box_bll/clash/geosite_tmp.dat
  mv /data/adb/box_bll/clash/country.mmdb /data/adb/box_bll/clash/country_tmp.mmdb
  
  cp /data/adb/box_bll/clash/config.yaml /data/adb/box_bll/clash/config.yaml.bak
  cp /data/adb/box_bll/scripts/box.config /data/adb/box_bll/scripts/box.config.bak
  
  rm -rf /data/adb/box_bll/clash/dashboard/metacubexd
  cp -rf $MODPATH/box_bll/* /data/adb/box_bll/
  rm -rf $MODPATH/box_bll
  mv /data/adb/box_bll/clash/cache_tmp.db /data/adb/box_bll/clash/cache.db
  
  #mv /data/adb/box_bll/clash/config_tmp.yaml /data/adb/box_bll/clash/config.yaml
  #mv /data/adb/box_bll/scripts/box_tmp.config /data/adb/box_bll/scripts/box.config
  
  mv /data/adb/box_bll/clash/geoip_tmp.dat /data/adb/box_bll/clash/geoip.dat
  mv /data/adb/box_bll/clash/geosite_tmp.dat /data/adb/box_bll/clash/geosite.dat
  mv /data/adb/box_bll/clash/country_tmp.mmdb /data/adb/box_bll/clash/country.mmdb

  mkdir /data/adb/box_bll/clash/dashboard/metacubexd
  ln -s /data/adb/modules/Surfing/webroot/* /data/adb/box_bll/clash/dashboard/metacubexd

  ui_print "- 正在更新..."
  ui_print "- 更新完成，无需重启..."
  #ui_print "- 用户配置 box.config  无更新已保留原始文件."
  #ui_print "- 配置文件 config.yaml 无更新已保留原始文件."
  ui_print "- 配置文件已备份bak：如更新订阅需重新添加订阅链接！"
  ui_print "- 用户配置已备份bak：可自行选择重新配置或使用默认！"
else
  mv $MODPATH/box_bll /data/adb/
  ui_print "- 正在安装..."
  ui_print "- 安装完成..."
  ui_print "- 首次安装完成后，先不要重启"
  ui_print "- 请至 data/adb/box_bll/clash/config.yaml 添加订阅信息"
  ui_print "- 此模块开关就是实时 启用/关闭 首次安装使用需重启一次！"
fi

if [ "$KSU" = true ] ; then
  sed -i 's/name=Surfing/name=Surfing/g' $MODPATH/module.prop
fi

mkdir -p /data/adb/box_bll/bin/
mkdir -p /data/adb/box_bll/run/

mv -f $MODPATH/Surfing_service.sh $service_dir/

rm -f customize.sh

set_perm_recursive $MODPATH 0 0 0755 0644
set_perm_recursive /data/adb/box_bll/ 0 0 0755 0644
set_perm_recursive /data/adb/box_bll/clash/proxy_providers/ 0 0 0755 0666
set_perm_recursive /data/adb/box_bll/clash/rule/ 0 0 0755 0666
set_perm_recursive /data/adb/box_bll/scripts/ 0 0 0755 0700
set_perm_recursive /data/adb/box_bll/bin/ 0 0 0755 0700

set_perm $service_dir/Surfing_service.sh 0 0 0700

chmod ugo+x /data/adb/box_bll/scripts/*

for pid in $(pidof inotifyd) ; do
  if grep -q box.inotify /proc/${pid}/cmdline ; then
    kill ${pid}
  fi
done

inotifyd "/data/adb/box_bll/scripts/box.inotify" "/data/adb/modules/Surfing" > /dev/null 2>&1 &
