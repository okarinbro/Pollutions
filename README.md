# Pollutions

**API modułu pollutions:**

* createMonitor - tworzy i zwraca nowy monitor zanieczyszczeń;
* addStation - dodaje do monitora wpis o nowej stacji pomiarowej (nazwa i współrzędne geograficzne), zwraca zaktualizowany monitor;
* addValue - dodaje odczyt ze stacji (współrzędne geograficzne lub nazwa stacji, data, typ pomiaru, wartość), zwraca zaktualizowany monitor;
* removeValue - usuwa odczyt ze stacji (współrzędne geograficzne lub nazwa stacji, data, typ pomiaru), zwraca zaktualizowany monitor;
* getOneValue - zwraca wartość pomiaru o zadanym typie, z zadanej daty i stacji;
* getStationMean - zwraca średnią wartość parametru danego typu z zadanej stacji;
* getDailyMean - zwraca średnią wartość parametru danego typu, danego dnia na wszystkich stacjach;
