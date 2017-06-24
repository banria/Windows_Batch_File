@echo off & setlocal enabledelayedexpansion
pushd %~dp0
set /a init_count=0
set /a log_count=0
set /a login_count=0
set /a getlen_count=0
set /a opendir_count=0
set /a rmall_count=0
set /a ftp_count=0
if exist $log.bat del /q $log.bat
if exist $login.bat del /q $login.bat
if exist $getlen.bat del /q $getlen.bat
if exist $opendir.bat del /q $opendir.bat
if exist $rmall.bat del /q $rmall.bat
if exist $ftp.bat del /q $ftp.bat
echo 请注意
echo 	需要配置环境变量
echo 		BATCH_PATH		该文件的路径 （需要添加到环境变量path中）
echo 		hiden_user		$login.bat登陆用户名
echo 		hiden_pwd		$login.bat登陆密码
echo 	%~dp0config 路径下 $fpt.txt 为 $ftp.bat 的配置文件
echo 		格式为：IP地址^|登录名^|密码
echo 	%~dp0log 为日志文件
echo.
set /a time_cnt=5
echo 请仔细阅读后配置！！！！！！！！
echo.
:time_start
echo 倒计时 %time_cnt% 秒
set /a time_cnt-=1
ping -n 2 127.1>nul
if %time_cnt% geq 0 goto :time_start
pause
for /f "delims=" %%a in ('type %~nx0') do (
	set /a init_count+=1
	if "%%a" equ "rem $log.bat" (
		echo 生成文件：$log.bat
		echo 开始行数：!init_count!
		set /a log_count=!init_count!
	)	
	if "%%a" equ "rem $login.bat" (
		echo 生成文件：$login.bat
		echo 开始行数：!init_count!
		set /a login_count=!init_count!
	)
	if "%%a" equ "rem $getlen.bat" (
		echo 生成文件：$getlen.bat
		echo 开始行数：!init_count!
		set /a getlen_count=!init_count!
	)
	if "%%a" equ "rem $opendir.bat" (
		echo 生成文件：$opendir.bat
		echo 开始行数：!init_count!
		set /a opendir_count=!init_count!
	)
	if "%%a" equ "rem $rmall.bat" (
		echo 生成文件：$rmall.bat
		echo 开始行数：!init_count!
		set /a rmall_count=!init_count!
	)
	if "%%a" equ "rem $ftp.bat" (
		echo 生成文件：$ftp.bat
		echo 开始行数：!init_count!
		set /a ftp_count=!init_count!
	)
	if !log_count! neq 0 (
		if !login_count! equ 0 (
			echo %%a >>$log.bat
		)
	)
	if !login_count! neq 0 (
		if !getlen_count! equ 0 (
			echo %%a >>$login.bat
		)
	)
	if !getlen_count! neq 0 (
		if !opendir_count! equ 0 (
			echo %%a >>$getlen.bat
		)
	)
	if !opendir_count! neq 0 (
		if !rmall_count! equ 0 (
			echo %%a >>$opendir.bat
		)
	)
	if !rmall_count! neq 0 (
		if !ftp_count! equ 0 (
			echo %%a >>$rmall.bat
		)
	)
	if !ftp_count! neq 0 (	
		echo %%a >> $ftp.bat
	)    
)
if not exist log  mkdir log
if not exist config  mkdir config
echo.
echo 初始化完毕，按任意键退出...
pause > nul & exit


rem $log.bat
@echo off & setlocal enabledelayedexpansion
rem 请使用 call $log 你需要打印的日志 路径参数1 路径参数2
rem 日志路径：环境变量%BATCH_PATH%\log
set trim_out=
for /f "tokens=1,2* delims= " %%a in ("%cmdcmdline%") do (
	set cmd_path=%%~a
	call :trim %%~c
)
if [%~1] equ [] (
	echo 请使用  call $log 你需要打印的日志
	exit /b 1
)
set yyyy=%date:~0,4%
set mm=%date:~5,2%
set dd=%date:~8,2%
set hh=%time:~0,2%
if /i %hh% LSS 10 (set hh=0%time:~1,1%)
set mi=%time:~3,2%
set ss=%time:~6,2%
set curTime=%yyyy%-%mm%-%dd% %hh%:%mi%:%ss%
set log_path=%BATCH_PATH%\log
if not exist %log_path% (
  echo 创建日志目录 %log_path%
  mkdir %log_path% > NUL
)
set log=%log_path%\%yyyy%%mm%%dd%.log
if [!trim_out!] equ [] (
echo 【%curTime%】!cmd_path!%~2%~3^> %~1 >> %log%
) else (
echo 【%curTime%】!trim_out!%~2%~3^> %~1 >> %log%
)
exit /b 0
:trim
set trim_out=%~1
goto :eof


rem $login.bat
@echo off
rem 请使用 call $login [default|nocount] [default|nocount] 来登陆
rem default 为默认账户登陆模式，nocount 为不进行失败次数计数模式(即只有一次机会)
rem 失败计数
set /a cnt=3
rem 默认账户
set defaultAc=banirasama

set /a inputMode=0
if [%2] equ [] (
  call :model %1
) else (
  call :model %1
  call :model %2
)

:login_start
echo 请使用账户密码登录，以便于继续操作
if %inputMode% equ 0 (
  call :input
) else (
  call :default
)
if %account% equ %hiden_user% (
 if %password% equ %hiden_pwd% (
    cls
    echo 成功登录！
    call $log "成功登录！账号：%account%" %~n0
    exit /b 0
 ) else (
    call :pwdCount %cnt%
    exit /b 2
 )
) else (
 call :pwdCount %cnt%
 exit /b 1
)
echo 未知错误！
exit /b 3

:model
rem 默认账户模式
if /i [%1] equ [default] (
  set account=%defaultAc%
  set /a inputMode=1
  call $log "登录模式：默认账户模式"  %~n0
)
rem 不计数模式
if /i [%1] equ [noCount] (
  set /a cnt=1
  call $log "登录模式：不计数模式"  %~n0
) 
goto :eof

:input
set /p account=account(账户):
set /p password=password(密码):
goto :eof

:default
echo 已使用默认账户
set /p password=password(密码):
goto :eof

:pwdCount
set /a cnt=%1-1
if %cnt% equ 0 (
  cls
  echo 账户或密码密码错误！
  call $log "账户或密码密码错误！"  %~n0
  call $log "尝试登录账号：%account%" %~n0
) else (
  cls
  echo 当前剩余错误次数%cnt%次
  echo.  
  goto :login_start
)
goto :eof

rem $getlen.bat
@echo off
rem 最多支持99个字符
set len1=999999999988888888887777777777666666666655555555554444444444333333333322222222221111111111
set len2=9876543210987654321098765432109876543210987654321098765432109876543210987654321098765432109876543210
set str=%~1
set temp1=%str%%len1%
set temp2=%str%%len2%
set len=%temp1:~99,1%%temp2:~99,1%
call $log 字符串[%str%]长度为%len% %~n0
exit /b %len%


rem $opendir.bat
@echo off
if [%~1] equ [] (
echo 请传入目录参数！
pause > nul & exit /b 1
) else (
pushd %~1 ||  (
echo 目录 %~1 不存在！
call $log 目录 %~1 不存在！ %~n0
pause > nul & exit /b 1
)
popd
)
start "exeplore.exe" %~1
call $log 打开目录%~1 %~n0
exit /b 0


rem $rmall.bat
@echo off & setlocal enabledelayedexpansion
set trim_path=
set trim_batch=
for /f "tokens=1,2* delims= " %%a in ("%cmdcmdline%") do (
	call :trim %%~c
)
pushd !trim_path!
echo !trim_path!目录下的所有文件都将被删除！！！！
echo 无法恢复，请登陆以便于继续！！
echo.
call $login nocount
if %errorlevel% neq 0 (
	pause & exit
)
for /f "delims=" %%i in ('dir /b') do (
	if %%i neq !trim_batch! (
		call :rm_file_dir %%~i
	)	
)
pause & exit
:trim
set trim_path=%~dp1
set trim_batch=%~nx1
goto :eof
:rm_file_dir
echo  %~1
dir/ad %~1 >nul 2>nul&&(
	rmdir /s /q %~1 > NUL && (
	call $log "删除文件夹[%~1]" %~n0
	)
)||(
	del /q %~1 > NUL && (
	call $log "删除文件[%~1]" %~n0
	)
)
goto :eof


rem $ftp.bat
@echo off
call $log FTP获取文件 %~n0
set cfg_file=%~dp0\config\%~n0.txt
set ftp_tmp=%temp%\$ftp_cfg.txt
set download_dir=d:\download\ftp
set /a ftp_flag=0
set /a ftp_cnt=0
if not exist %cfg_file% (
  call $log  %cfg_file%配置文件不存在 %~n0
)
for /f "delims=| tokens=1,2,3" %%a in (%cfg_file%) do (
 set /a ftp_cnt+=1
 if %%b equ %~1 (
    set /a ftp_flag=1
    call $log 登陆ip:%%a %~n0
    call $log 登陆账号:%%b %~n0
    if exist %ftp_tmp% (
    	del /q %ftp_tmp% 
    )
    echo open %%a >>%ftp_tmp%
    echo user %%b >>%ftp_tmp%
    echo %%c >>%ftp_tmp%
    echo lcd %download_dir% >>%ftp_tmp%
    ftp -n -s:%ftp_tmp%
    call $opendir %download_dir%
 )
)
if %ftp_cnt% equ 0 (
   call $log %cfg_file%文件内容为空 %~n0
)
if %ftp_flag% equ 0 (
   call $log %%~1配置数据不存在 %~n0
)
exit /b 0
