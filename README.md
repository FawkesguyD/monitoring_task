# Тестовое задание (junior DevOps engineer)

## Требования:
+ Запускаться при запуске системы (предпочтительно написать юнит systemd в дополнение к скрипту)
+ Отрабатывать каждую минуту
+Если процесс запущен, то стучаться(по https) на https://test.com/monitoring/test/api
+ Если процесс был перезапущен, писать в лог /var/log/monitoring.log (если процесс не запущен, то ничего не делать) 
+ Если сервер мониторинга не доступен, так же писать в лог


## Использование:
Переместить скрипт **monitoring.sh** в директорию ```/usr/local/bin/``` и выдать соответствующие права на исполнение

```
sudo cp monitoring.sh /usr/local/bin/
sudo chmod +x /usr/local/bin/monitoring.sh
```

Далее переместить сервисы в директорию ```/etc/systemd/system/``` перезагрузить демоны и запустить сервис **monitoring.timer**

```
sudo systemctl daemon-reload
sudo systemctl start monitoring.timer
```

Добавить сервис в автозагрузку при старте системы

```
sudo systemctl enable monitoring.timer
```