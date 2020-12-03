
rem for /f "tokens=1,2 delims=:" %%w IN ('%~d0')do set homedir=%%w && %homedir%:
set homedir=%~d0 && set homedir=%homedir: =% && %homedir% && cd "%~dp0"

set paperdir1=paper_server
if not exist %paperdir1% md %paperdir1%
set eulafile1=%paperdir1%\eula.txt


if "%~1"=="/forceupdate" del /f /q *.jar
if "%~1"=="/forceupdate" call :latestpapermcbuild

if not exist "%paperdir1%\LatestPaperMc.jar" if not exist *.jar call :latestpapermcbuild
if not exist "%paperdir1%\LatestPaperMc.jar" if not exist *.jar Echo Latest PaperMC.jar not downloaded to workdir
if not exist "%paperdir1%\LatestPaperMc.jar" if not exist *.jar goto exit


:start1
for /f "tokens=1 delims=?" %%a in ('dir /b /a-d /od *paper*.jar') do set jar1=%%a


copy /y %jar1% %paperdir1%\
del /f /q %jar1%

echo #By changing the setting below to TRUE you are indicating your agreement to our EULA (https://account.mojang.com/documents/minecraft_eula).> %eulafile1%
echo #You also agree that tacos are tasty, and the best food in the world.>> %eulafile1%
echo #Tue -%date%-%time%- >> %eulafile1%
echo eula=true>> %eulafile1%

if not exist "%paperdir1%\server.properties" call :serverprop1

cd %paperdir1%\

set startcmd1=java -Xms1G -Xmx4G -XX:+UseG1GC -XX:+ParallelRefProcEnabled -XX:MaxGCPauseMillis=200 -XX:+UnlockExperimentalVMOptions -XX:+DisableExplicitGC -XX:+AlwaysPreTouch -XX:G1NewSizePercent=30 -XX:G1MaxNewSizePercent=40 -XX:G1HeapRegionSize=8M -XX:G1ReservePercent=20 -XX:G1HeapWastePercent=5 -XX:G1MixedGCCountTarget=4 -XX:InitiatingHeapOccupancyPercent=15 -XX:G1MixedGCLiveThresholdPercent=90 -XX:G1RSetUpdatingPauseTimePercent=5 -XX:SurvivorRatio=32 -XX:+PerfDisableSharedMem -XX:MaxTenuringThreshold=1 -Dusing.aikars.flags=https://mcflags.emc.gs -Daikars.new.flags=true -jar %jar1% nogui

%startcmd1%


goto exit

:serverprop1
echo #Minecraft server properties> "%paperdir1%\server.properties"
echo #Tue Dec 01 16:46:00 CET 2020>> "%paperdir1%\server.properties"
echo spawn-protection=16 >> "%paperdir1%\server.properties"
echo max-tick-time=60000 >> "%paperdir1%\server.properties"
echo query.port=25565 >> "%paperdir1%\server.properties"
echo generator-settings=>> "%paperdir1%\server.properties"
echo sync-chunk-writes=true>> "%paperdir1%\server.properties"
echo force-gamemode=false>> "%paperdir1%\server.properties"
echo allow-nether=true>> "%paperdir1%\server.properties"
echo enforce-whitelist=false>> "%paperdir1%\server.properties"
echo gamemode=survival>> "%paperdir1%\server.properties"
echo broadcast-console-to-ops=true>> "%paperdir1%\server.properties"
echo enable-query=false>> "%paperdir1%\server.properties"
echo player-idle-timeout=0 >> "%paperdir1%\server.properties"
echo text-filtering-config=>> "%paperdir1%\server.properties"
echo difficulty=easy>> "%paperdir1%\server.properties"
echo spawn-monsters=true>> "%paperdir1%\server.properties"
echo broadcast-rcon-to-ops=true>> "%paperdir1%\server.properties"
echo op-permission-level=4 >> "%paperdir1%\server.properties"
echo pvp=true>> "%paperdir1%\server.properties"
echo entity-broadcast-range-percentage=100 >> "%paperdir1%\server.properties"
echo snooper-enabled=true>> "%paperdir1%\server.properties"
echo level-type=default>> "%paperdir1%\server.properties"
echo hardcore=false>> "%paperdir1%\server.properties"
echo enable-status=true>> "%paperdir1%\server.properties"
echo enable-command-block=false>> "%paperdir1%\server.properties"
echo max-players=20 >> "%paperdir1%\server.properties"
echo network-compression-threshold=256 >> "%paperdir1%\server.properties"
echo resource-pack-sha1=>> "%paperdir1%\server.properties"
echo max-world-size=29999984 >> "%paperdir1%\server.properties"
echo function-permission-level=2 >> "%paperdir1%\server.properties"
echo rcon.port=25575 >> "%paperdir1%\server.properties"
echo server-port=25565 >> "%paperdir1%\server.properties"
echo debug=false>> "%paperdir1%\server.properties"
echo server-ip=>> "%paperdir1%\server.properties"
echo spawn-npcs=true>> "%paperdir1%\server.properties"
echo allow-flight=false>> "%paperdir1%\server.properties"
echo level-name=world>> "%paperdir1%\server.properties"
echo view-distance=10 >> "%paperdir1%\server.properties"
echo resource-pack=>> "%paperdir1%\server.properties"
echo spawn-animals=true>> "%paperdir1%\server.properties"
echo white-list=false>> "%paperdir1%\server.properties"
echo rcon.password=>> "%paperdir1%\server.properties"
echo generate-structures=true>> "%paperdir1%\server.properties"
echo max-build-height=256 >> "%paperdir1%\server.properties"
echo online-mode=true>> "%paperdir1%\server.properties"
echo level-seed=>> "%paperdir1%\server.properties"
echo use-native-transport=true>> "%paperdir1%\server.properties"
echo prevent-proxy-connections=false>> "%paperdir1%\server.properties"
echo enable-jmx-monitoring=false>> "%paperdir1%\server.properties"
echo enable-rcon=false>> "%paperdir1%\server.properties"
echo rate-limit=0 >> "%paperdir1%\server.properties"
echo motd=A Minecraft Server>> "%paperdir1%\server.properties"

goto :eof


:latestpapermcbuild
rem https://papermc.io/ci/job/Paper-1.16/lastStableBuild/

cmd.exe /c certutil.exe -urlcache -split -f "https://papermc.io/ci/job/Paper-1.16/lastStableBuild/artifact/paperclip.jar" LatestPaperMc.jar
goto :eof

:exit
cd ..
