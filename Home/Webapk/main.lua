local hotupdate = "true"
_G.Remotehotupdate = hotupdate

require "luajava"
require "import"

import "android.app.*"
import "android.os.*"
import "android.widget.*"
import "android.view.*"
import "android.content.Intent"
import "android.net.Uri"
import "android.view.KeyEvent"
import "androidx.appcompat.widget.PopupMenu"
import "androidx.cardview.widget.CardView"
import "android.content.Context"
import "androidx.swiperefreshlayout.widget.SwipeRefreshLayout"
import "android.os.Build"
import "android.app.PendingIntent"
import "androidx.core.app.NotificationCompat"
import "android.app.NotificationManager"
import "android.os.Bundle"
import "androidx.appcompat.app.AppCompatActivity"
import "java.lang.String"
import "java.lang.System"
import "android.app.NotificationChannel"
import "com.androlua.Http"
import "androidx.appcompat.app.AlertDialog"
import "android.app.AlertDialog"
import "android.content.SharedPreferences"
import "android.preference.PreferenceManager"
import "android.widget.LinearLayout"
import "android.widget.ScrollView"
import "android.widget.TextView"
import "android.widget.Button"
import "android.widget.Toast"
import "android.text.SpannableStringBuilder"
import "android.text.style.StyleSpan"
import "android.text.style.ForegroundColorSpan"
import "android.text.style.RelativeSizeSpan"
import "android.graphics.Typeface"
state = "android"

if _G.Remotehotupdate == "false" then
    return _G.Remotehotupdate
end

local url = "https://api.github.com/repos/MoGuangYu/Surfing/commits?sha=rm&path=Home/Webapk/main.lua&per_page=1"
local url1 = "https://raw.githubusercontent.com/MoGuangYu/rules/refs/heads/rm/Home/Webupdated.txt"
local url2 = "https://raw.githubusercontent.com/MoGuangYu/rules/refs/heads/rm/Home/Webnotify.txt"
local headers = {
  ["User-Agent"] = "Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/133.0.0.0 Mobile Safari/537.36"
}

function styleScrollView(sv)
  sv.setVerticalScrollBarEnabled(true)
  sv.setScrollbarFadingEnabled(false)
  if sv.setScrollBarStyle then
    sv.setScrollBarStyle(0x00000000)
  end
end

local updateLog = "v6.3.5\n1、优化一些已知问题..."
function checkForUpdate()
  Http.get(url1 .. "?t=" .. os.time(), nil, "UTF-8", headers, function(code, content)
    if code == 200 then
      local version = content:match("推送版本号:%s*([%w%.]+)")
      local updateLog = content:match("更新日志:%s*{(.-)}") or "暂无更新日志"
      local forceUpdate = content:match("强制更新:%s*(.-)\n") or "关"
      local downloadLink = content:match("下载链接:%s*(https?://[%w%._%?%=/&-]+)")

      updateLog = updateLog:match("^%s*(.-)%s*$")

      local ColorDrawable = import "android.graphics.drawable.ColorDrawable"

      local function parseVersion(ver)
        local t = {}
        for num in ver:gmatch("%d+") do
          table.insert(t, tonumber(num))
        end
        return t
      end

      local function isNewVersion(localVer, remoteVer)
        local lv = parseVersion(localVer)
        local rv = parseVersion(remoteVer)
        for i = 1, math.max(#lv, #rv) do
          local l = lv[i] or 0
          local r = rv[i] or 0
          if l < r then
            return true
          elseif l > r then
            return false
          end
        end
        return false
      end

      local packinfo = activity.getPackageManager().getPackageInfo(activity.getPackageName(), 0)
      local localVersion = tostring(packinfo.versionName)
      local remoteVersion = tostring(version)

      if isNewVersion(localVersion, remoteVersion) then
        local updateDialog = AlertDialog.Builder(activity)

        local titleTV = TextView(activity)
        titleTV.setText("发现新版本：" .. version)
        titleTV.setTextSize(20)        
        titleTV.setTextColor(0xFF000000) 
        titleTV.setPadding(65, 30, 50, 15)  
        titleTV.getPaint().setFakeBoldText(false)  
        
        updateDialog.setCustomTitle(titleTV)  

        local updateLogTV = TextView(activity)
        updateLogTV.setText(updateLog)
        updateLogTV.setPadding(50, 10, 50, 30)
        updateLogTV.setTextSize(15)
        updateLogTV.setTextColor(0xFF333333)
        updateLogTV.setTextIsSelectable(true)

        local scrollContainer = ScrollView(activity)
        scrollContainer.setPadding(20, 10, 20, 10)
        styleScrollView(scrollContainer)
        scrollContainer.setLayoutParams(
          LinearLayout.LayoutParams(
            LinearLayout.LayoutParams.MATCH_PARENT, 
            LinearLayout.LayoutParams.MATCH_PARENT
          )
        )
        scrollContainer.addView(updateLogTV)

        local outerLayout = LinearLayout(activity)
        outerLayout.setOrientation(LinearLayout.VERTICAL)
        local spacing = TextView(activity)
        spacing.setHeight(20)
        outerLayout.addView(spacing)
        outerLayout.addView(scrollContainer)

        updateDialog.setView(outerLayout)

        if forceUpdate == "开" then
          updateDialog.setNegativeButton(nil, nil)  
        else
          updateDialog.setNegativeButton("取消", function(dialog, which) end)
        end

        updateDialog.setPositiveButton("获取", function(dialog, which)
          if not (downloadLink and downloadLink:match("^https?://")) then
            Toast.makeText(activity, "下载链接无效", Toast.LENGTH_SHORT).show()
            return
          end
          local viewIntent = Intent("android.intent.action.VIEW", Uri.parse(downloadLink))
          activity.startActivity(viewIntent)
          activity.finish()
        end)

        updateDialog.setCancelable(false)  

        local dialog = updateDialog.create()
        dialog.show()

        local window = dialog.getWindow()
        window.setBackgroundDrawable(ColorDrawable(0xFFFFFFFF))
        window.getDecorView().setPadding(20, 20, 20, 20)

        updateLogTV.requestLayout()
        window.getDecorView().postDelayed(function()
          local contentHeight = updateLogTV.getHeight()
          local layoutParams = window.getAttributes()
          if contentHeight < 985 then
            layoutParams.height = WindowManager.LayoutParams.WRAP_CONTENT
          else
            layoutParams.height = 985
          end
          window.setAttributes(layoutParams)
        end, 100)

        import "android.graphics.drawable.GradientDrawable"
        local bg = GradientDrawable()
        bg.setColor(0xFFFFFFFF)
        bg.setCornerRadius(30)
        window.setBackgroundDrawable(bg)
      end
    else
      print("请求失败，错误码:", code)
    end
  end)
end

activity.getWindow().getDecorView().postDelayed(function()
  checkForUpdate()
end, 3000)

function loadInfo()
  local dialog = nil
  Http.get(url2 .. "?t=" .. os.time(), nil, "UTF-8", headers, function(code, content)
    if code == 200 and content then
      local pushNotification = content:match("推送通知:%s*(.-)\n") or "关"
      local darkTheme = content:match("深色主题:%s*(.-){") or "关"
      local titleText = content:match("内容标题:%s*(.-)\n") or "公告"
      local contentCenter = content:match("内容居中:%s*(.-)\n") or "关"
      local infoContent = content:match("信息内容:%s*{(.-)}") or "暂无内容"
      local buttonText = content:match("按钮标题:%s*(.-)\n") or "确定"
      
      infoContent = infoContent:match("^%s*(.-)%s*$")

      local UIColor, btColor, nrColor
      if darkTheme == "开" then
        UIColor = content:match("then%s*UIColor%s*=%s*\"(.-)\"") or "#222222"
        btColor = content:match("then%s*btColor%s*=%s*\"(.-)\"") or "#ffffff"
        nrColor = content:match("then%s*nrColor%s*=%s*\"(.-)\"") or "#dfffffff"
      else
        UIColor = content:match("else.-UIColor%s*=%s*\"(.-)\"") or "#ffffff"
        btColor = content:match("else.-btColor%s*=%s*\"(.-)\"") or "#000000"
        nrColor = content:match("else.-nrColor%s*=%s*\"(.-)\"") or "#333333"
      end

      local function hexToColor(hex)
        hex = hex:gsub("#", "")
        return tonumber("0xFF" .. hex)
      end

      if pushNotification == "关" then
        Toast.makeText(activity, "当前未启用！", Toast.LENGTH_SHORT).show()
        return
      end

      local LinearLayout = import "android.widget.LinearLayout"
      local TextView = import "android.widget.TextView"
      local ScrollView = import "android.widget.ScrollView"
      local GradientDrawable = import "android.graphics.drawable.GradientDrawable"
      local WindowManager = import "android.view.WindowManager"
      local KeyEvent = import "android.view.KeyEvent"
      local Gravity = import "android.view.Gravity"

      local mainLayout = LinearLayout(activity)
      mainLayout.setOrientation(LinearLayout.VERTICAL)

      local titleTV = TextView(activity)
      titleTV.getPaint().setFakeBoldText(true)
      titleTV.setText(titleText)
      titleTV.setTextSize(20)
      titleTV.setTextColor(hexToColor(btColor))
      titleTV.setGravity(Gravity.LEFT)
      titleTV.setPadding(65, 30, 50, 20)

      local contentTV = TextView(activity)
      contentTV.setText(infoContent)
      contentTV.setTextSize(15)
      contentTV.setTextColor(hexToColor(nrColor))
      if contentCenter == "开" then
        contentTV.setGravity(Gravity.CENTER)
      else
        contentTV.setGravity(Gravity.LEFT)
      end
      contentTV.setPadding(50, 20, 50, 20)
      contentTV.setTextIsSelectable(true)

      local scrollView = ScrollView(activity)
      styleScrollView(scrollView)
      scrollView.setLayoutParams(
        LinearLayout.LayoutParams(
          LinearLayout.LayoutParams.MATCH_PARENT,
          LinearLayout.LayoutParams.MATCH_PARENT
        )
      )
      scrollView.setPadding(20, 10, 20, 10)
      scrollView.addView(contentTV)

      local button = TextView(activity)
      button.setText(buttonText)
      button.setTextSize(15)
      button.setTextColor(0xFFFFFFFF)
      button.setGravity(Gravity.CENTER)
      button.setPadding(50, 20, 50, 20)

      local buttonBg = GradientDrawable()
      buttonBg.setColor(hexToColor("#007BFF"))
      buttonBg.setCornerRadius(20)
      button.setBackgroundDrawable(buttonBg)
      
      button.setOnClickListener(function()
        if dialog then
          dialog.dismiss()
        end
      end)

      local buttonLayout = LinearLayout(activity)
      buttonLayout.setGravity(Gravity.RIGHT)
      buttonLayout.setPadding(0, 30, 65, 30)
      buttonLayout.addView(button)

      mainLayout.addView(titleTV)
      mainLayout.addView(scrollView, LinearLayout.LayoutParams(-1, 0, 1))
      mainLayout.addView(buttonLayout)

      dialog = AlertDialog.Builder(activity).create()
      dialog.show()
      dialog.setCancelable(true)
      dialog.setCanceledOnTouchOutside(false)
      dialog.getWindow().setContentView(mainLayout)

      local bg = GradientDrawable()
      bg.setColor(hexToColor(UIColor))
      bg.setCornerRadius(30)
      dialog.getWindow().setBackgroundDrawable(bg)

      dialog.setOnKeyListener(function(dialog, keyCode, event)
        if keyCode == KeyEvent.KEYCODE_BACK then
          return true
        end
        return false
      end)

      dialog.getWindow().getDecorView().postDelayed(function()
        local contentHeight = contentTV.getHeight()
        local layoutParams = dialog.getWindow().getAttributes()
        if contentHeight < 985 then
          layoutParams.height = WindowManager.LayoutParams.WRAP_CONTENT
        else
          layoutParams.height = 985
        end
        dialog.getWindow().setAttributes(layoutParams)
      end, 100)

      dialog.show()
    else
      print("请求失败，错误码:", code)
    end
  end)
end

function checkNetworkConnection()
  local connectivityManager = activity.getSystemService(Context.CONNECTIVITY_SERVICE)
  local networkInfo = connectivityManager.getActiveNetworkInfo()
  if networkInfo and networkInfo.isConnected() then
    return true
  else
    return false
  end
end

function saveDefaultUrl(url)
  local editor = preferences.edit()
  editor.putString("defaultUrl", url)
  editor.apply()
end

function loadDefaultUrl()
  return preferences.getString("defaultUrl", "")
end

if not checkNetworkConnection() then
  local Toast = luajava.bindClass("android.widget.Toast")
  Toast.makeText(activity, "请检查你的网络设置", Toast.LENGTH_SHORT).show()
  activity.finish()
  return
end

activity.getWindow().setNavigationBarColor(0xFFF2F2F2)
activity.getWindow().setStatusBarColor(0xFF202020)

local swipeRefreshLayout = SwipeRefreshLayout(activity)

local layout = {
  LinearLayout,
  orientation = "vertical",
  layout_width = "match_parent",
  layout_height = "match_parent",
  gravity = "center",
  backgroundColor = "0xFF202020",
  {
    LinearLayout,
    orientation = "horizontal",
    gravity = "center",
    layout_width = "fill",
    layout_height = "60dp",
    backgroundColor = "0xFF202020",
    {
      CardView,
      layout_margin = "0dp",
      layout_gravity = "center",
      layout_marginLeft = "10dp",
      layout_marginRight = "10dp",
      elevation = "0",
      layout_width = "fill",
      CardBackgroundColor = "0xffffffff",
      layout_height = "45dp",
      radius = "25dp",
      {
        LinearLayout, 
        orientation = "horizontal", 
        gravity = "center",
        layout_width = "fill",
        layout_height = "fill",
        backgroundColor = "",
        {
          ImageView,
          id = "avatar",
          src = "img/home.png",
          layout_width = "25dp",
          layout_height = "25dp",
          layout_marginLeft = "10dp",
          colorFilter = "0xFF000000",
          scaleType = "fitXY",
        },
        {
          EditText,
          id = "ed",
          layout_weight = "1",
          layout_height = "wrap",
          textSize = "15sp",
          hintTextColor = "0xFF000000",
          textColor = "0xff000000",
          Hint = "Search...",
          imeOptions = "actionSearch",
          singleLine = true,
          enabled = true
        },
        {
          ImageView,
          src = "img/language.png",
          layout_width = "23dp",
          layout_height = "23dp",
          layout_marginLeft = "10dp",
          colorFilter = "0xff888888",
          scaleType = "fitXY",
          onClick = function()
            webView.loadUrl("https://ip.skk.moe/")
          end
        },
        {
          ImageView,
          src = "img/vpn_lock.png",
          layout_width = "23dp",
          layout_height = "23dp",
          layout_marginLeft = "10dp",
          colorFilter = "0xff888888",
          scaleType = "fitXY",
          onClick = function()
            webView.loadUrl("https://browserleaks.com/ip/")
          end
        },
        {
          ImageView,
          src = "img/refresh1.png",
          layout_width = "23.5dp",
          layout_height = "23.5dp",
          layout_marginLeft = "10dp",
          colorFilter = "0xff888888",
          scaleType = "fitXY",
          onClick = function()
            webView.reload()
          end
        },
        {
          ImageView,
          id = "more",
          src = "img/more_vert.png",
          layout_width = "25dp",
          layout_height = "fill",
          layout_marginLeft = "10dp",
          layout_marginRight = "10dp",
          colorFilter = "0xff888888",
          scaleType = "centerInside"
        }
      }
    }
  },
  {
    LuaWebView,
    layout_width = "fill",
    layout_height = "fill",
    id = "webView"
  }
}

swipeRefreshLayout.addView(loadlayout(layout))

swipeRefreshLayout.setEnabled(false)

local THRESHOLD = 5  

swipeRefreshLayout.setOnChildScrollUpCallback(luajava.createProxy(
  "androidx.swiperefreshlayout.widget.SwipeRefreshLayout$OnChildScrollUpCallback", {
    canChildScrollUp = function(parent, child)
      return webView.getScrollY() > THRESHOLD
    end
  }
))

swipeRefreshLayout.setOnRefreshListener(luajava.createProxy(
  "androidx.swiperefreshlayout.widget.SwipeRefreshLayout$OnRefreshListener", {
    onRefresh = function()
      webView.reload()
      swipeRefreshLayout.post(function()
        swipeRefreshLayout.setRefreshing(false)
      end)
    end
  }
))

preferences = activity.getSharedPreferences("settings", Context.MODE_PRIVATE)

local defaultUrl = loadDefaultUrl()
if defaultUrl == "" then
  defaultUrl = "http://127.0.0.1:9090/ui/#/proxies"
end

activity.setContentView(swipeRefreshLayout)

local rootLayout = activity.findViewById(android.R.id.content)

local webViewClient = {
  shouldOverrideUrlLoading = function(view, url)
    if url:match("^market://") or url:match("^intent://") then
      return true
    end
    return false
  end
}
webView.setWebViewClient(webViewClient)

webView.loadUrl(defaultUrl)

function saveDefaultUrl(url)
  local editor = preferences.edit()
  editor.putString("defaultUrl", url)
  editor.apply()
end

avatar.onClick = function()
  if defaultUrl ~= "" then
    webView.loadUrl(defaultUrl)
  else
    webView.loadUrl("http://127.0.0.1:9090/ui/#/proxies")
  end
end

ed.setOnKeyListener({
  onKey = function(v, keyCode, event)
    if (KeyEvent.KEYCODE_ENTER == keyCode and KeyEvent.ACTION_DOWN == event.getAction()) then
      webView.loadUrl("https://www.google.com/search?q=" .. ed.text)
      local inputMethodManager = activity.getSystemService(Context.INPUT_METHOD_SERVICE)
      inputMethodManager.hideSoftInputFromWindow(ed.getWindowToken(), 0)
      return true
    end
  end
})

webView.setWebViewClient({
  onPageStarted = function(view, url, favicon)
    local inputMethodManager = activity.getSystemService(Context.INPUT_METHOD_SERVICE)
    inputMethodManager.hideSoftInputFromWindow(ed.getWindowToken(), 0)
  end,
  
  onPageFinished = function(view, url)
    local inputMethodManager = activity.getSystemService(Context.INPUT_METHOD_SERVICE)
    inputMethodManager.hideSoftInputFromWindow(ed.getWindowToken(), 0)
  end
})

activity.getWindow().setSoftInputMode(WindowManager.LayoutParams.SOFT_INPUT_ADJUST_RESIZE)

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

            function showVersionInfo(updateTime, updateLog)
                local ssb = SpannableStringBuilder()
                local metadataTitle = "Metadata\n"
                ssb.append(metadataTitle)
                ssb.setSpan(StyleSpan(Typeface.BOLD), 0, #metadataTitle, 0)
                ssb.setSpan(ForegroundColorSpan(0xFF000000), 0, #metadataTitle, 0)
                ssb.setSpan(RelativeSizeSpan(1.2), 0, #metadataTitle, 0)

                local timestamp = "Timestamp: " .. updateTime .. "\n\n"
                local startTimestamp = #ssb
                ssb.append(timestamp)
                local endTimestamp = #ssb
                ssb.setSpan(ForegroundColorSpan(0xFF444444), startTimestamp, endTimestamp, 0)

                local updateLogTitle = "更新日志:\n"
                local startLog = #ssb
                ssb.append(updateLogTitle)
                local endLog = #ssb
                ssb.setSpan(StyleSpan(Typeface.BOLD), startLog, endLog, 0)
                ssb.setSpan(ForegroundColorSpan(0xFF000000), startLog, endLog, 0)
                ssb.setSpan(RelativeSizeSpan(1), startLog, endLog, 0)

                local logContent = (updateLog or "暂无更新日志...") .. "\n\n\n"
                local startContent = #ssb
                ssb.append(logContent)
                local endContent = #ssb
                ssb.setSpan(ForegroundColorSpan(0xFF888888), startContent, endContent, 0)

                local copyrightText = "@Surfing Webbrowser 2023"
                local startCopyright = #ssb
                ssb.append(copyrightText)
                local endCopyright = #ssb
                ssb.setSpan(ForegroundColorSpan(0xFF444444), startCopyright, endCopyright, 0)

                local textView = TextView(activity)
                textView.setText(ssb)
                textView.setTextSize(15)
                textView.setPadding(50, 30, 50, 30)

                local builder = AlertDialog.Builder(activity)
                builder.setView(textView)
                builder.setNegativeButton("Git", function(dialog, which)
                    activity.startActivity(Intent(Intent.ACTION_VIEW, Uri.parse("https://github.com/MoGuangYu/rules")))
                end)
                builder.setPositiveButton("少儿频道", function(dialog, which)
                    activity.startActivity(Intent(Intent.ACTION_VIEW, Uri.parse("https://t.me/+vvlXyWYl6HowMTBl")))
                end)
                builder.setNeutralButton("取消", nil)
                builder.setCancelable(false)
                builder.show()
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
        print("请求失败，错误码:", code)
    end
end)

webView.loadUrl(defaultUrl)

local lastBackgroundTime = 0
local isInBackground = false

function onPause()
  lastBackgroundTime = os.time()
  isInBackground = true
end

function onResume()
  if isInBackground then
    local currentTime = os.time()
    local backgroundTime = currentTime - lastBackgroundTime
    
    if backgroundTime >= 120 then
      webView.reload()
    end
    
    isInBackground = false
    lastBackgroundTime = 0
  end
end

local AGREED_KEY = "agreed_disclaimer"

local preferences = PreferenceManager.getDefaultSharedPreferences(activity)

local agreed = preferences.getBoolean(AGREED_KEY, false)

if not agreed then
  Handler().postDelayed(function()
    local dialog = AlertDialog.Builder(activity)
      .setCancelable(false)
      .create()

    local layout = {
      LinearLayout;
      orientation = 'vertical';
      padding = '16dp';
      {
        ScrollView;
        layout_width = 'match_parent';
        layout_height = '468dp';
        {
          TextView;
          layout_width = 'match_parent';
          layout_height = 'wrap_content';
          text = [[
在使用之前，请仔细下滑阅读以下免责协议。使用即表示您默许同意遵守本协议的所有条款和条件。

1. 目的
本程序是基于CLASH/MIHOMO的GUI便携浏览工具，旨在方便使用查看和管理代理的相关信息。此程序仅供学习研究之用，并无其它用途。

2. 免责声明
本程序仅作为浏览工具提供，不提供任何代理服务。我们不对您通过本程序访问的任何内容的准确性、合法性、安全性或完整性承担任何责任。您在使用本程序时应自行承担风险。

3. 第三方链接
本程序可能包含指向第三方网站或资源的链接，这些仅供您参考。我们对这些第三方网站或资源的内容、隐私政策、服务或产品的可用性不承担任何责任。您应自行判断并承担使用这些第三方链接的风险。

4. 法律合规
在使用本程序时，您应遵守适用的法律法规。您对通过本程序访问的任何内容的使用应符合当地相关法律法规，包括但不限于版权法、隐私法和计算机犯罪法。

5. 修改和终止
我们保留根据需要随时修改或终止本免责协议的权利。任何修改将在本程序上发布并生效。继续使用本程序即表示您接受修改后的免责协议。

请确保在使用本程序之前仔细阅读并理解本免责协议的所有条款和条件。如果您不同意本程序协议的任何部分，请立即卸载停止使用本程序。

修订时间：2025年03月07日
          ]];
          padding = '10dp';
        };
      };
      {
        Button;
        layout_width = 'match_parent';
        layout_height = 'wrap_content';
        text = "同意";
        onClick = function()
          local editor = preferences.edit()
          editor.putBoolean(AGREED_KEY, true)
          editor.apply()
          Toast.makeText(activity, "已阅读并同意", Toast.LENGTH_SHORT).show()
          dialog.dismiss()
        end;
      };
      {
        Button;
        layout_width = 'match_parent';
        layout_height = 'wrap_content';
        text = "不同意";
        onClick = function()
          local packageUri = "package:" .. activity.getPackageName()
          local uninstallIntent = Intent(Intent.ACTION_DELETE, Uri.parse(packageUri))
          activity.startActivity(uninstallIntent)
          activity.finish()
        end;
      };
    }
    local layoutContext = ContextThemeWrapper(activity, android.R.style.Theme_Material_Light)

    local contentView = loadlayout(layout, layoutContext)

    dialog.setView(contentView)

    dialog.show()
  end, 3000)
end

return _G.Remotehotupdate
