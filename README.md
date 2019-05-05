# Pollutions

**API modułu pollutions:**

* createMonitor/0 - tworzy i zwraca nowy monitor zanieczyszczeń;
* addStation/3 - dodaje do monitora wpis o nowej stacji pomiarowej (nazwa i współrzędne geograficzne), zwraca zaktualizowany monitor;
* addValue/5 - dodaje odczyt ze stacji (współrzędne geograficzne lub nazwa stacji, data, typ pomiaru, wartość), zwraca zaktualizowany monitor;
* removeValue/4 - usuwa odczyt ze stacji (współrzędne geograficzne lub nazwa stacji, data, typ pomiaru), zwraca zaktualizowany monitor;
* getOneValue/4 - zwraca wartość pomiaru o zadanym typie, z zadanej daty i stacji;
* getStationMean/3 - zwraca średnią wartość parametru danego typu z zadanej stacji;
* getDailyMean/3 - zwraca średnią wartość parametru danego typu, danego dnia na wszystkich stacjach;
