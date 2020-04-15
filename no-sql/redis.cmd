echo off
cls
echo ��� ��� � ���� windows, � redis ������� ⮫쪮 � ࠬ��� �����ᮢ�� ��⥬,
echo � ��� ࠧ���稢��� �ࢥ� � ���� ���⥩��� ��� �����.
echo ��� �⮣� ����, ��⠭�������, ����᪠� �����:
echo https://hub.docker.com/editions/community/docker-ce-desktop-windows
echo ����� �믮���� ������� � ��������� ��ப� (cmd.exe):
echo.
echo 1. C��稢��� ��ࠧ � redis � �����:
echo on
docker pull redis
@echo 2. ������稢��� � ����᪠�� ��ࠧ � ।�ᮬ:
docker run --name test-redis -d redis
@REM docker start test-redis
@echo 3. ���뢠�� 襫�/��������� ��ப� ��ࠧ� � ।�ᮬ.
@echo ����� ����室��� ����� ������� ������:
@echo redis-cli (��� ����᪠ ���᮫쭮�� ������ ��� ।��)
@echo ����� ���� ������� � ������ ।��:
@echo.
@echo ������� 1.
@echo � ���� ������ Redis ������� �������� ��� ������ ���饭�� � ��।������� IP-���ᮢ.
@echo ��襭��:
@echo ��� ������� ���饭�� � ��।������� IP-���ᮢ ����� ᤥ���� ���⠡���� visits,
@echo ��� � ����⢥ ���祩 ����� ��⠡���� ���� 㪠�뢠���� ip-����,
@echo � � ����⢥ ���祭�� ����� ��⠡���� �㤥� 㪠�뢠���� ������⢮ ���饭��.
@echo �� �� ���饭�� �� ᠩ� �� ��।��� � ।�� �������:
@echo HINCRBY visits [����-����] 1 (���ਬ�� HINCRBY visits 192.168.1.1 1)
@echo � �⢥� �ࠧ� �� ����砥� ⥪�饥 ������⢮ ���饭�� � �⮣� ����.
@echo ��� ⮣� ��-�� ��ᬮ���� �� ���饭�� � ��� ���ᮢ:
@echo HGETALL visits (������ ��ப� - ���� ����, ��� - ������⢮ ���饭�� � ���)
@echo ��� ⮣� ��-�� 㧭��� ������⢮ ���饭�� � ��।�������� ����:
@echo HGET visits 192.168.1.1
@echo.
@echo ������� 2.
@echo 2. �� ����� ���� ������ Redis ��� ������ ���᪠ ����� ���짮��⥫� 
@echo �� ���஭���� ����� � ������, ���� ���஭���� ���� ���짮��⥫� 
@echo �� ��� �����.
@echo ��襭��:
@echo ��᪮�쪮 � ����, ।�� �� �����⢫�� ���� �� ���祭��.
@echo ����� ��� �襭�� ⠪�� ����� ����� ᤥ���� ��� ��⠡����,
@echo email_by_uname ��� �࠭���� ������� �� ���� ���짮��⥫�,
@echo � uname_by_email �࠭���� ����� �� ����� �����.
@echo �����塞 ��⠡���� ��⮢묨 ����묨:
@echo HMSET email_by_uname admin admin@geekbrains.ru aleksey aleksey@skhom.ru alisa alisa@example.com
@echo HMSET uname_by_email admin@geekbrains.ru admin aleksey@skhom.ru aleksey alisa@example.com alisa
@echo ����� ��� ⮣� �� �� ������� ����� ���짮��⥫� � ����� admin
@echo �믮��塞 HGET email_by_uname admin
@echo � ��� ⮣� �� �� 㧭��� ୥�� ���짮��⥫� � ���⮩ aleksey@skhom.ru
@echo �믮��塞 HGET uname_by_email aleksey@skhom.ru
@echo ==================================================================
@echo redis-cli (�� ���뢠�� ���� � ।��-���)
docker exec -it /test-redis /bin/bash
pause