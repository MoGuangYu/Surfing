local hotupdate = "true"
_G.Remotehotupdate = hotupdate
if _G.Remotehotupdate == "false" then
    return _G.Remotehotupdate
end

Http.get(url2 .. "?t=" .. os.time(), nil, "UTF-8", headers, function(code, content)
    if code == 200 and content then
        local pushNotification = content:match("推送通知:%s*(.-)\n") or "关"
        local menuTitle = content:match("菜单标题:%s*(.-)\n") or "信息通知"
        
        more.onClick = function()
            local pop = PopupMenu(activity, more)
            local menu = pop.Menu
            
            menu.add("清除数据").onMenuItemClick = function(a)
                local builder = AlertDialog.Builder(activity)
                builder.setTitle("注意")
                builder.setMessage("此操作会清除自身全部数据并退出！")
                builder.setPositiveButton("确定", function(dialog, which)
                    activity.finish()
                    if activity.getPackageName() ~= "net.fusionapp" then
                        os.execute("pm clear " .. activity.getPackageName())
                    end
                end)
                builder.setNegativeButton("取消", nil)
                builder.setCancelable(false)
                builder.show()
            end
            
            menu.add("设置URL").onMenuItemClick = function(a)
                local builder = AlertDialog.Builder(activity)
                builder.setTitle("设置URL")
                builder.setMessage("请输入要设置默认访问的链接：")
                local input = EditText(activity)
                input.setHint("http:// 或 https:// 开头...")
                builder.setView(input)
                builder.setPositiveButton("确定", function(dialog, which)
                    local url = input.getText().toString()
                    if url ~= "" and string.match(url, "^https?://[%w%._%-]+[%w%._%/?&%=%-]*") then
                        defaultUrl = url
                        webView.loadUrl(defaultUrl)
                        saveDefaultUrl(defaultUrl)
                    else
                        local errorDialog = AlertDialog.Builder(activity)
                        errorDialog.setTitle("错误")
                        errorDialog.setMessage("请输入有效的URL链接！")
                        errorDialog.setPositiveButton("确定", function(dialog, which) end)
                        errorDialog.setCancelable(false)
                        errorDialog.show()
                    end
                end)
                builder.setNegativeButton("取消", nil)
                builder.setCancelable(false)
                builder.show()
            end
            
            menu.add("IP 检查").onMenuItemClick = function(a)
                local subPop = PopupMenu(activity, more)
                local subMenu = subPop.Menu
                subMenu.add("IPW_CN").onMenuItemClick = function(b)
                    local url = "https://ipw.cn/"
                    webView.loadUrl(url)
                end
                subMenu.add("纯IPv6测试").onMenuItemClick = function(b)
                    local url = "https://ipv6.test-ipv6.com/"
                    webView.loadUrl(url)
                end
                subMenu.add("网站延迟").onMenuItemClick = function(b)
                    local url = "https://ip.skk.moe/simple"
                    webView.loadUrl(url)
                end
                subMenu.add("DNS泄露测试").onMenuItemClick = function(b)
                    local url = "https://www.browserscan.net/zh/dns-leak"
                    webView.loadUrl(url)
                end
                subMenu.add("DNS泄露测试").onMenuItemClick = function(b)
                    local url = "https://surfshark.com/zh/dns-leak-test"
                    webView.loadUrl(url)
                end
                subPop.show()
            end
            
            menu.add("切换面板").onMenuItemClick = function(a)
                local subPop = PopupMenu(activity, more)
                local subMenu = subPop.Menu
                subMenu.add("Meta").onMenuItemClick = function(b)
                    local url = "https://metacubex.github.io/metacubexd/#/proxies"
                    webView.loadUrl(url)
                    defaultUrl = url
                    saveDefaultUrl(defaultUrl)
                end
                subMenu.add("Yacd").onMenuItemClick = function(b)
                    local url = "https://yacd.mereith.com/#/proxies"
                    webView.loadUrl(url)
                    defaultUrl = url
                    saveDefaultUrl(defaultUrl)
                end
                subMenu.add("Zash").onMenuItemClick = function(b)
                    local url = "https://board.zash.run.place/#/proxies"
                    webView.loadUrl(url)
                    defaultUrl = url
                    saveDefaultUrl(defaultUrl)
                end
                subMenu.add("Local（本地端口）").onMenuItemClick = function(b)
                    local url = "http://127.0.0.1:9090/ui/#/proxies"
                    webView.loadUrl(url)
                    defaultUrl = url
                    saveDefaultUrl(defaultUrl)
                end
                subPop.show()
            end
            
            local function getLastCommitTime()
                Http.get(url .. "?t=" .. os.time(), nil, "UTF-8", headers, function(code, content)
                    if code == 200 and content then
                        local commitDate = content:match('"date"%s*:%s*"([^"]+)"')
                        if commitDate then
                            commitDate = commitDate:gsub("T", " "):gsub("Z", "")
                            local timestamp = os.time({
                                year = tonumber(commitDate:sub(1, 4)),
                                month = tonumber(commitDate:sub(6, 7)),
                                day = tonumber(commitDate:sub(9, 10)),
                                hour = tonumber(commitDate:sub(12, 13)),
                                min = tonumber(commitDate:sub(15, 16)),
                                sec = tonumber(commitDate:sub(18, 19))
                            })
                            timestamp = timestamp + 8 * 60 * 60
                            local formattedDate = os.date("%Y-%m-%d %H:%M:%S", timestamp)
                            showVersionInfo(formattedDate, updateLog)
                        else
                            showVersionInfo("获取失败！")
                        end
                    else
                        showVersionInfo("获取失败，错误码：" .. tostring(code))
                    end
                end)
            end
            
            local JSONObject = luajava.bindClass("org.json.JSONObject")
            
            function showVersionInfo(updateTime, updateLog)
                local ssb = SpannableStringBuilder()
                
                local startVersion = ssb.length()
                local metadataTitle = "Version " .. version .. "\n"
                ssb.append(metadataTitle)
                local endVersion = ssb.length()
                ssb.setSpan(StyleSpan(Typeface.BOLD), startVersion, endVersion, 0)
                ssb.setSpan(ForegroundColorSpan(0xFF000000), startVersion, endVersion, 0)
                ssb.setSpan(RelativeSizeSpan(1.2), startVersion, endVersion, 0)
                
                local startTimestamp = ssb.length()
                local timestamp = "Timestamp：" .. updateTime .. " " .. version .. "\n\n"
                ssb.append(timestamp)
                local endTimestamp = ssb.length()
                ssb.setSpan(ForegroundColorSpan(0xFF444444), startTimestamp, endTimestamp, 0)
                
                local startLog = ssb.length()
                local updateLogTitle = "更新日志:\n"
                ssb.append(updateLogTitle)
                local endLog = ssb.length()
                ssb.setSpan(StyleSpan(Typeface.BOLD), startLog, endLog, 0)
                ssb.setSpan(ForegroundColorSpan(0xFF000000), startLog, endLog, 0)
                ssb.setSpan(RelativeSizeSpan(1), startLog, endLog, 0)
                
                local startContent = ssb.length()
                local logContent = (updateLog or "获取失败...") .. "\n\n"
                ssb.append(logContent)
                local endContent = ssb.length()
                ssb.setSpan(ForegroundColorSpan(0xFF888888), startContent, endContent, 0)
                ssb.setSpan(RelativeSizeSpan(0.9), startContent, endContent, 0)
                
                local textView = TextView(activity)
                textView.setText(ssb)
                textView.setTextSize(15)
                textView.setPadding(50, 30, 50, 30)
                textView.setTextIsSelectable(true)
                
                local builder = AlertDialog.Builder(activity)
                builder.setView(textView)
                builder.setNegativeButton("Git", function(dialog, which)
                    activity.startActivity(Intent(Intent.ACTION_VIEW, Uri.parse("https://github.com/MoGuangYu/Surfing")))
                end)
                builder.setPositiveButton("少儿频道", function(dialog, which)
                    activity.startActivity(Intent(Intent.ACTION_VIEW, Uri.parse("https://t.me/+vvlXyWYl6HowMTBl")))
                end)
                builder.setNeutralButton("取消", nil)
                builder.setCancelable(false)
                local dialog = builder.show()
                
                Http.get("https://api.ip.sb/geoip", nil, "UTF-8", headers, function(geoCode, geoContent)
                    if geoCode == 200 and geoContent then
                        local obj = JSONObject(geoContent)
                        local timezone = obj.optString("timezone", "获取失败...")
                        local isp = obj.optString("isp", "获取失败...")
                        local asn = obj.opttring("asn", "获取失败...")
                        local ip = obj.optString("ip", "获取失败...")
                        
                        local startGeo = ssb.length()
                        local geoInfo = "\n" ..
                                      "" .. timezone .. "\n" ..
                                      "" .. isp .. "\n" ..
                                      "ASN: " .. asn .. "\n" ..
                                      "IPv4: " .. ip .. "\n"
                        
                        Http.get("https://api-ipv6.ip.sb/ip", nil, "UTF-8", headers, function(ipv6Code, ipv6Content)
                            if ipv6Code == 200 and ipv6Content and ipv6Content:match("%S") then
                                geoInfo = geoInfo .. "IPv6: " .. ipv6Content:gsub("%s+", "") .. "\n"
                            end
                            
                            ssb.append(geoInfo)
                            local endGeo = ssb.length()
                            ssb.setSpan(ForegroundColorSpan(0xFF444444), startGeo, endGeo, 0)
                            textView.setText(ssb)
                            
                            local startCopyright = ssb.length()
                            local copyrightText = "\n@Surfing Webbrowser 2023."
                            ssb.append(copyrightText)
                            local endCopyright = ssb.length()
                            ssb.setSpan(ForegroundColorSpan(0xFF444444), startCopyright, endCopyright, 0)
                            textView.setText(ssb)
                        end)
                    end
                end)
            end
            
            menu.add("版本信息").onMenuItemClick = function(a)
                getLastCommitTime()
            end
            
            menu.add("点我闪退(Exit)").onMenuItemClick = function(a)
                activity.finish()
                os.exit(0)
            end
            
            if pushNotification == "开" then
                menu.add(menuTitle).onMenuItemClick = function(a)
                    Toast.makeText(activity, "正在拉取中...", Toast.LENGTH_SHORT).show()
                    Handler().postDelayed(function()
                        loadInfo()
                    end, 2700)
                end
            end
            pop.show()
        end
    else
        -- 失败处理逻辑
    end
end)

return _G.Remotehotupdate