# Отключить Safe Mode (ошибка: Cannot create file/user/cloudera/voyna-i-mir-tom-1.txt._COPYING_. Name node is in safe mode.)
sudo -u hdfs hdfs dfsadmin -safemode leave

# Загрузка файлов из локальной системы в файловую систему (ФС) Hadoop
hdfs dfs -copyFromLocal /home/cloudera/voyna-i-mir-tom-1.txt /home/cloudera/voyna-i-mir-tom-2.txt /home/cloudera/voyna-i-mir-tom-3.txt /home/cloudera/voyna-i-mir-tom-4.txt /user/cloudera

# Вывод содержимого директории /user/cloudera
hdfs dfs -ls
# Вывод:
# Found 4 items
# -rw-r--r--   1 cloudera cloudera     736519 2022-12-02 19:38 voyna-i-mir-tom-1.txt
# -rw-r--r--   1 cloudera cloudera     770324 2022-12-02 19:37 voyna-i-mir-tom-2.txt
# -rw-r--r--   1 cloudera cloudera     843205 2022-12-02 19:37 voyna-i-mir-tom-3.txt
# -rw-r--r--   1 cloudera cloudera     697960 2022-12-02 19:37 voyna-i-mir-tom-4.txt


# Сжатие 4-х томов в один файл, -nl добавляет пустую строку между содержимом файлов
hdfs dfs -getmerge -nl voyna-i-mir-tom-1.txt voyna-i-mir-tom-2.txt voyna-i-mir-tom-3.txt voyna-i-mir-tom-4.txt /home/cloudera/voyna-i-mir-merged.txt

# Поскольку команда -getmerge создает файл в локальной файловой системе, загрузим этот файл в ФС Hadoop
hdfs dfs -copyFromLocal /home/cloudera/voyna-i-mir-merged.txt /user/cloudera

# Изменение прав доступа к файлу:
# Полный доступ для владельца файла
# Возможность читать и выполнять для сторонних пользователей
hdfs dfs -chmod 764 voyna-i-mir-merged.txt

# Повторный вывод содержимого папки
hdfs dfs -ls
# Вывод:
# Found 5 items
# -rwxrw-r--   1 cloudera cloudera    3048012 2022-12-02 19:57 voyna-i-mir-merged.txt
# -rw-r--r--   1 cloudera cloudera     736519 2022-12-02 19:38 voyna-i-mir-tom-1.txt
# -rw-r--r--   1 cloudera cloudera     770324 2022-12-02 19:37 voyna-i-mir-tom-2.txt
# -rw-r--r--   1 cloudera cloudera     843205 2022-12-02 19:37 voyna-i-mir-tom-3.txt
# -rw-r--r--   1 cloudera cloudera     697960 2022-12-02 19:37 voyna-i-mir-tom-4.txt

# Команда вывода размера файла (флаг -h делает вывод читабельным)
hdfs dfs -du -h voyna-i-mir-merged.txt
# Вывод:
# 2.9 M  2.9 M  voyna-i-mir-merged.txt

# Изменение фактора репликации на 2
dfs dfs -setrep -w 2 voyna-i-mir-merged.txt
# Вывод:
# Replication 2 set: voyna-i-mir-merged.txt
# Waiting for voyna-i-mir-merged.txt ..............................

# Вопрос: что такое "Waiting for voyna-i-mir-merged.txt ....."?
# Судя по выводу нижеследующей команды,
# команда изменения фактора репликации успешно выполнилась,
# но она не завершается никак, просто увеличивается количество точек после "Waiting for..."
# Пришлось прервать "Waiting..." через Ctrl+C. Так должно быть?
# Или у меня что-то не так? И что именно?


# Проверка изменения фактора репликации
hdfs dfs -du -h voyna-i-mir-merged.txt
# Вывод:
# 2.9 M  5.8 M  voyna-i-mir-merged.txt

# Подсчет количества строк в файле
fs dfs -cat voyna-i-mir-merged.txt | wc -l

# Вывод:
# 10276


