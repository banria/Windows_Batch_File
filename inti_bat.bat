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
echo ��ע��
echo 	��Ҫ���û�������
echo 		BATCH_PATH		���ļ���·�� ����Ҫ��ӵ���������path�У�
echo 		hiden_user		$login.bat��½�û���
echo 		hiden_pwd		$login.bat��½����
echo 	%~dp0config ·���� $fpt.txt Ϊ $ftp.bat �������ļ�
echo 		��ʽΪ��IP��ַ^|��¼��^|����
echo 	%~dp0log Ϊ��־�ļ�
echo.
set /a time_cnt=5
echo ����ϸ�Ķ������ã���������������
echo.
:time_start
echo ����ʱ %time_cnt% ��
set /a time_cnt-=1
ping -n 2 127.1>nul
if %time_cnt% geq 0 goto :time_start
pause
for /f "delims=" %%a in ('type %~nx0') do (
	set /a init_count+=1
	if "%%a" equ "rem $log.bat" (
		echo �����ļ���$log.bat
		echo ��ʼ������!init_count!
		set /a log_count=!init_count!
	)	
	if "%%a" equ "rem $login.bat" (
		echo �����ļ���$login.bat
		echo ��ʼ������!init_count!
		set /a login_count=!init_count!
	)
	if "%%a" equ "rem $getlen.bat" (
		echo �����ļ���$getlen.bat
		echo ��ʼ������!init_count!
		set /a getlen_count=!init_count!
	)
	if "%%a" equ "rem $opendir.bat" (
		echo �����ļ���$opendir.bat
		echo ��ʼ������!init_count!
		set /a opendir_count=!init_count!
	)
	if "%%a" equ "rem $rmall.bat" (
		echo �����ļ���$rmall.bat
		echo ��ʼ������!init_count!
		set /a rmall_count=!init_count!
	)
	if "%%a" equ "rem $ftp.bat" (
		echo �����ļ���$ftp.bat
		echo ��ʼ������!init_count!
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
echo ��ʼ����ϣ���������˳�...
pause > nul & exit


rem $log.bat
@echo off & setlocal enabledelayedexpansion
rem ��ʹ�� call $log ����Ҫ��ӡ����־ ·������1 ·������2
rem ��־·������������%BATCH_PATH%\log
set trim_out=
for /f "tokens=1,2* delims= " %%a in ("%cmdcmdline%") do (
	set cmd_path=%%~a
	call :trim %%~c
)
if [%~1] equ [] (
	echo ��ʹ��  call $log ����Ҫ��ӡ����־
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
  echo ������־Ŀ¼ %log_path%
  mkdir %log_path% > NUL
)
set log=%log_path%\%yyyy%%mm%%dd%.log
if [!trim_out!] equ [] (
echo ��%curTime%��!cmd_path!%~2%~3^> %~1 >> %log%
) else (
echo ��%curTime%��!trim_out!%~2%~3^> %~1 >> %log%
)
exit /b 0
:trim
set trim_out=%~1
goto :eof


rem $login.bat
@echo off
rem ��ʹ�� call $login [default|nocount] [default|nocount] ����½
rem default ΪĬ���˻���½ģʽ��nocount Ϊ������ʧ�ܴ�������ģʽ(��ֻ��һ�λ���)
rem ʧ�ܼ���
set /a cnt=3
rem Ĭ���˻�
set defaultAc=banirasama

set /a inputMode=0
if [%2] equ [] (
  call :model %1
) else (
  call :model %1
  call :model %2
)

:login_start
echo ��ʹ���˻������¼���Ա��ڼ�������
if %inputMode% equ 0 (
  call :input
) else (
  call :default
)
if %account% equ %hiden_user% (
 if %password% equ %hiden_pwd% (
    cls
    echo �ɹ���¼��
    call $log "�ɹ���¼���˺ţ�%account%" %~n0
    exit /b 0
 ) else (
    call :pwdCount %cnt%
    exit /b 2
 )
) else (
 call :pwdCount %cnt%
 exit /b 1
)
echo δ֪����
exit /b 3

:model
rem Ĭ���˻�ģʽ
if /i [%1] equ [default] (
  set account=%defaultAc%
  set /a inputMode=1
  call $log "��¼ģʽ��Ĭ���˻�ģʽ"  %~n0
)
rem ������ģʽ
if /i [%1] equ [noCount] (
  set /a cnt=1
  call $log "��¼ģʽ��������ģʽ"  %~n0
) 
goto :eof

:input
set /p account=account(�˻�):
set /p password=password(����):
goto :eof

:default
echo ��ʹ��Ĭ���˻�
set /p password=password(����):
goto :eof

:pwdCount
set /a cnt=%1-1
if %cnt% equ 0 (
  cls
  echo �˻��������������
  call $log "�˻��������������"  %~n0
  call $log "���Ե�¼�˺ţ�%account%" %~n0
) else (
  cls
  echo ��ǰʣ��������%cnt%��
  echo.  
  goto :login_start
)
goto :eof

rem $getlen.bat
@echo off
rem ���֧��99���ַ�
set len1=999999999988888888887777777777666666666655555555554444444444333333333322222222221111111111
set len2=9876543210987654321098765432109876543210987654321098765432109876543210987654321098765432109876543210
set str=%~1
set temp1=%str%%len1%
set temp2=%str%%len2%
set len=%temp1:~99,1%%temp2:~99,1%
call $log �ַ���[%str%]����Ϊ%len% %~n0
exit /b %len%


rem $opendir.bat
@echo off
if [%~1] equ [] (
echo �봫��Ŀ¼������
pause > nul & exit /b 1
) else (
pushd %~1 ||  (
echo Ŀ¼ %~1 �����ڣ�
call $log Ŀ¼ %~1 �����ڣ� %~n0
pause > nul & exit /b 1
)
popd
)
start "exeplore.exe" %~1
call $log ��Ŀ¼%~1 %~n0
exit /b 0


rem $rmall.bat
@echo off & setlocal enabledelayedexpansion
set trim_path=
set trim_batch=
for /f "tokens=1,2* delims= " %%a in ("%cmdcmdline%") do (
	call :trim %%~c
)
pushd !trim_path!
echo !trim_path!Ŀ¼�µ������ļ�������ɾ����������
echo �޷��ָ������½�Ա��ڼ�������
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
	call $log "ɾ���ļ���[%~1]" %~n0
	)
)||(
	del /q %~1 > NUL && (
	call $log "ɾ���ļ�[%~1]" %~n0
	)
)
goto :eof


rem $ftp.bat
@echo off
call $log FTP��ȡ�ļ� %~n0
set cfg_file=%~dp0\config\%~n0.txt
set ftp_tmp=%temp%\$ftp_cfg.txt
set download_dir=d:\download\ftp
set /a ftp_flag=0
set /a ftp_cnt=0
if not exist %cfg_file% (
  call $log  %cfg_file%�����ļ������� %~n0
)
for /f "delims=| tokens=1,2,3" %%a in (%cfg_file%) do (
 set /a ftp_cnt+=1
 if %%b equ %~1 (
    set /a ftp_flag=1
    call $log ��½ip:%%a %~n0
    call $log ��½�˺�:%%b %~n0
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
   call $log %cfg_file%�ļ�����Ϊ�� %~n0
)
if %ftp_flag% equ 0 (
   call $log %%~1�������ݲ����� %~n0
)
exit /b 0
