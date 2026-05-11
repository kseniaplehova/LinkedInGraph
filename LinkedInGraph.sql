-- Создание базы данных LinkedInGraph

USE master;
GO

IF EXISTS (SELECT 1 FROM sys.databases WHERE name = N'LinkedInGraph')
BEGIN
    ALTER DATABASE LinkedInGraph SET single_user WITH ROLLBACK IMMEDIATE;
    DROP DATABASE LinkedInGraph;
END

CREATE DATABASE LinkedInGraph;
GO

USE LinkedInGraph;
GO

-- СОЗДАНИЕ ТАБЛИЦ УЗЛОВ

-- УЗЕЛ 1: Professionals (Профессионалы / Коллеги)
CREATE TABLE Professionals (
    ProfessionalID INT NOT NULL PRIMARY KEY,
    FirstName NVARCHAR(100) NOT NULL,
    LastName NVARCHAR(100) NOT NULL,
    Email NVARCHAR(100),
    Phone NVARCHAR(20),
    City NVARCHAR(100),
    LinkedInProfile NVARCHAR(500),
    Industry NVARCHAR(100),
    YearsOfExperience INT
) AS NODE;
GO

-- УЗЕЛ 2: Skills (Навыки)
CREATE TABLE Skills (
    SkillID INT NOT NULL PRIMARY KEY,
    SkillName NVARCHAR(100) NOT NULL UNIQUE,
    Category NVARCHAR(100)
) AS NODE;
GO

-- УЗЕЛ 3: Companies (Компании)
CREATE TABLE Companies (
    CompanyID INT NOT NULL PRIMARY KEY,
    CompanyName NVARCHAR(200) NOT NULL,
    Industry NVARCHAR(100),
    HeadquartersCity NVARCHAR(100),
    Website NVARCHAR(500)
) AS NODE;
GO

-- СОЗДАНИЕ ТАБЛИЦ РЁБЕР

-- РЕБРО 1: WORKS_AT (Professional -> Company) "работает в"
CREATE TABLE WORKS_AT (
    JobTitle NVARCHAR(100),
    StartDate DATE,
    EndDate DATE,
    IsCurrent BIT DEFAULT 1
) AS EDGE;
GO

ALTER TABLE WORKS_AT 
ADD CONSTRAINT EC_WORKS_AT 
CONNECTION (Professionals TO Companies) ON DELETE NO ACTION;
GO

-- РЕБРО 2: HAS_SKILL (Professional -> Skill) "владеет навыком"
CREATE TABLE HAS_SKILL (
    ProficiencyLevel NVARCHAR(50) 
        CHECK (ProficiencyLevel IN (N'Beginner', N'Intermediate', N'Advanced', N'Expert')),
    DateAcquired DATE,
    EndorsementCount INT DEFAULT 0
) AS EDGE;
GO

ALTER TABLE HAS_SKILL 
ADD CONSTRAINT EC_HAS_SKILL 
CONNECTION (Professionals TO Skills) ON DELETE NO ACTION;
GO

-- РЕБРО 3: RECOMMENDS (Professional -> Professional) "рекомендует"
CREATE TABLE RECOMMENDS (
    RecommendationDate DATE DEFAULT GETDATE(),
    RelationshipType NVARCHAR(50) 
        CHECK (RelationshipType IN (N'Colleague', N'Manager', N'Client', N'Other')),
    RecommendationText NVARCHAR(500)
) AS EDGE;
GO

ALTER TABLE RECOMMENDS 
ADD CONSTRAINT EC_RECOMMENDS 
CONNECTION (Professionals TO Professionals) ON DELETE NO ACTION;
GO

-- ЗАПОЛНЕНИЕ ТАБЛИЦ УЗЛОВ

-- 1. Professionals (12 профессионалов)
INSERT INTO Professionals (ProfessionalID, FirstName, LastName, Email, Phone, City, LinkedInProfile, Industry, YearsOfExperience) VALUES
(1,  N'Иван',    N'Петров',    N'ivan.petrov@mail.com',        N'+375 29 111-22-33', N'Минск',      N'linkedin.com/in/ivanpetrov',    N'Информационные технологии', 12),
(2,  N'Мария',   N'Сидорова',  N'maria.sidorova@mail.com',     N'+375 29 222-33-44', N'Москва',      N'linkedin.com/in/mariasidorova', N'Маркетинг', 7),
(3,  N'Алексей', N'Козлов',    N'alexey.kozlov@mail.com',      N'+375 29 333-44-55', N'Санкт-Петербург', N'linkedin.com/in/alexeykozlov', N'Финансы', 15),
(4,  N'Елена',   N'Новикова',  N'elena.novikova@mail.com',     N'+375 29 444-55-66', N'Минск',      N'linkedin.com/in/elenanovikova', N'Информационные технологии', 5),
(5,  N'Дмитрий', N'Соколов',   N'dmitry.sokolov@mail.com',     N'+375 29 555-66-77', N'Киев',       N'linkedin.com/in/dmitrysokolov', N'Продажи', 9),
(6,  N'Анна',    N'Морозова',  N'anna.morozova@mail.com',      N'+375 29 666-77-88', N'Минск',      N'linkedin.com/in/annamorozova',  N'Управление персоналом', 10),
(7,  N'Сергей',  N'Волков',    N'sergey.volkov@mail.com',      N'+375 29 777-88-99', N'Москва',      N'linkedin.com/in/sergeyvolkov',  N'Информационные технологии', 8),
(8,  N'Ольга',   N'Лебедева',  N'olga.lebedeva@mail.com',      N'+375 29 888-99-00', N'Санкт-Петербург', N'linkedin.com/in/olgalebedeva', N'Маркетинг', 6),
(9,  N'Михаил',  N'Павлов',    N'mikhail.pavlov@mail.com',     N'+375 29 999-00-11', N'Минск',      N'linkedin.com/in/mikhailpavlov', N'Информационные технологии', 11),
(10, N'Татьяна', N'Егорова',   N'tatyana.egorova@mail.com',    N'+375 29 000-11-22', N'Киев',       N'linkedin.com/in/tatyanaegorova', N'Финансы', 14),
(11, N'Андрей',  N'Григорьев', N'andrey.grigoriev@mail.com',   N'+375 29 111-22-33', N'Варшава',    N'linkedin.com/in/andreygrigoriev', N'Продажи', 4),
(12, N'Наталья', N'Романова',  N'natalya.romanova@mail.com',   N'+375 29 222-33-44', N'Минск',      N'linkedin.com/in/natalyaromanova', N'Информационные технологии', 13);
GO

SELECT * FROM Professionals

-- 2. Skills (12 навыков)
INSERT INTO Skills (SkillID, SkillName, Category) VALUES
(1,  N'SQL',                 N'Базы данных'),
(2,  N'Python',              N'Программирование'),
(3,  N'Project Management',  N'Управление'),
(4,  N'Data Analysis',       N'Аналитика'),
(5,  N'Java',                N'Программирование'),
(6,  N'C#',                  N'Программирование'),
(7,  N'Marketing',           N'Маркетинг'),
(8,  N'Sales',               N'Продажи'),
(9,  N'Leadership',          N'Управление'),
(10, N'Communication',       N'Софт-скиллы'),
(11, N'Machine Learning',    N'Искусственный интеллект'),
(12, N'Cloud Computing',     N'Инфраструктура');
GO

SELECT * FROM Skills

-- 3. Companies (12 компаний)
INSERT INTO Companies (CompanyID, CompanyName, Industry, HeadquartersCity, Website) VALUES
(1,  N'EPAM Systems',      N'ИТ-услуги и разработка ПО', N'Ньютаун (США)',        N'https://www.epam.com'),
(2,  N'Microsoft',         N'Программное обеспечение',   N'Редмонд (США)',        N'https://www.microsoft.com'),
(3,  N'Google',            N'Интернет и технологии',      N'Маунтин-Вью (США)',    N'https://www.google.com'),
(4,  N'Apple',             N'Потребительская электроника',N'Купертино (США)',      N'https://www.apple.com'),
(5,  N'Amazon',            N'Электронная коммерция и облачные сервисы', N'Сиэтл (США)', N'https://www.amazon.com'),
(6,  N'Яндекс',            N'Интернет и технологии',      N'Москва (Россия)',      N'https://www.yandex.ru'),
(7,  N'Тинькофф',          N'Финансовые технологии',      N'Москва (Россия)',      N'https://www.tinkoff.ru'),
(8,  N'Сбер',              N'Банковские и IT-услуги',     N'Москва (Россия)',      N'https://www.sber.ru'),
(9,  N'VK',                N'Социальные сети и медиа',    N'Санкт-Петербург (Россия)', N'https://www.vk.com'),
(10, N'Ozon',              N'Электронная коммерция',      N'Москва (Россия)',      N'https://www.ozon.ru'),
(11, N'Wildberries',       N'Электронная коммерция',      N'Москва (Россия)',      N'https://www.wildberries.ru'),
(12, N'IBM',               N'ИТ-услуги и оборудование',   N'Армонк (США)',         N'https://www.ibm.com');
GO

SELECT * FROM Companies

-- ЗАПОЛНЕНИЕ ТАБЛИЦ РЁБЕР

-- 1. WORKS_AT: Professional -> Company
INSERT INTO WORKS_AT ($from_id, $to_id, JobTitle, StartDate, IsCurrent)
VALUES
    ((SELECT $node_id FROM Professionals WHERE ProfessionalID = 1),  (SELECT $node_id FROM Companies WHERE CompanyID = 1),  N'Senior Developer',        '2020-01-15', 1),
    ((SELECT $node_id FROM Professionals WHERE ProfessionalID = 2),  (SELECT $node_id FROM Companies WHERE CompanyID = 6),  N'Marketing Manager',       '2019-06-01', 1),
    ((SELECT $node_id FROM Professionals WHERE ProfessionalID = 3),  (SELECT $node_id FROM Companies WHERE CompanyID = 7),  N'Financial Analyst',       '2018-03-10', 1),
    ((SELECT $node_id FROM Professionals WHERE ProfessionalID = 4),  (SELECT $node_id FROM Companies WHERE CompanyID = 1),  N'Junior Data Scientist',   '2022-09-01', 1),
    ((SELECT $node_id FROM Professionals WHERE ProfessionalID = 5),  (SELECT $node_id FROM Companies WHERE CompanyID = 10), N'Sales Lead',              '2021-11-20', 1),
    ((SELECT $node_id FROM Professionals WHERE ProfessionalID = 6),  (SELECT $node_id FROM Companies WHERE CompanyID = 8),  N'HR Business Partner',     '2020-05-15', 1),
    ((SELECT $node_id FROM Professionals WHERE ProfessionalID = 7),  (SELECT $node_id FROM Companies WHERE CompanyID = 2),  N'Software Engineer',       '2021-08-01', 1),
    ((SELECT $node_id FROM Professionals WHERE ProfessionalID = 8),  (SELECT $node_id FROM Companies WHERE CompanyID = 9),  N'Content Strategist',      '2022-02-14', 1),
    ((SELECT $node_id FROM Professionals WHERE ProfessionalID = 9),  (SELECT $node_id FROM Companies WHERE CompanyID = 3),  N'DevOps Engineer',         '2019-04-10', 1),
    ((SELECT $node_id FROM Professionals WHERE ProfessionalID = 10), (SELECT $node_id FROM Companies WHERE CompanyID = 7),  N'Risk Manager',            '2020-10-01', 1),
    ((SELECT $node_id FROM Professionals WHERE ProfessionalID = 11), (SELECT $node_id FROM Companies WHERE CompanyID = 10), N'Sales Representative',    '2023-01-10', 1),
    ((SELECT $node_id FROM Professionals WHERE ProfessionalID = 12), (SELECT $node_id FROM Companies WHERE CompanyID = 1),  N'Team Lead',               '2017-05-20', 1);
GO

SELECT * FROM WORKS_AT

-- 2. HAS_SKILL: Professional -> Skill
INSERT INTO HAS_SKILL ($from_id, $to_id, ProficiencyLevel, DateAcquired, EndorsementCount)
VALUES
    ((SELECT $node_id FROM Professionals WHERE ProfessionalID = 1),  (SELECT $node_id FROM Skills WHERE SkillID = 1),  N'Expert',      '2015-01-01', 42),
    ((SELECT $node_id FROM Professionals WHERE ProfessionalID = 1),  (SELECT $node_id FROM Skills WHERE SkillID = 2),  N'Advanced',    '2016-03-01', 35),
    ((SELECT $node_id FROM Professionals WHERE ProfessionalID = 2),  (SELECT $node_id FROM Skills WHERE SkillID = 7),  N'Expert',      '2013-06-01', 28),
    ((SELECT $node_id FROM Professionals WHERE ProfessionalID = 2),  (SELECT $node_id FROM Skills WHERE SkillID = 10), N'Expert',      '2014-01-01', 31),
    ((SELECT $node_id FROM Professionals WHERE ProfessionalID = 3),  (SELECT $node_id FROM Skills WHERE SkillID = 1),  N'Advanced',    '2010-09-01', 19),
    ((SELECT $node_id FROM Professionals WHERE ProfessionalID = 3),  (SELECT $node_id FROM Skills WHERE SkillID = 4),  N'Expert',      '2011-06-01', 24),
    ((SELECT $node_id FROM Professionals WHERE ProfessionalID = 4),  (SELECT $node_id FROM Skills WHERE SkillID = 2),  N'Advanced',    '2020-02-01', 15),
    ((SELECT $node_id FROM Professionals WHERE ProfessionalID = 4),  (SELECT $node_id FROM Skills WHERE SkillID = 11), N'Intermediate','2021-05-01', 8),
    ((SELECT $node_id FROM Professionals WHERE ProfessionalID = 5),  (SELECT $node_id FROM Skills WHERE SkillID = 8),  N'Expert',      '2016-03-01', 40),
    ((SELECT $node_id FROM Professionals WHERE ProfessionalID = 5),  (SELECT $node_id FROM Skills WHERE SkillID = 10), N'Advanced',    '2017-01-01', 22),
    ((SELECT $node_id FROM Professionals WHERE ProfessionalID = 6),  (SELECT $node_id FROM Skills WHERE SkillID = 9),  N'Expert',      '2014-11-01', 33),
    ((SELECT $node_id FROM Professionals WHERE ProfessionalID = 6),  (SELECT $node_id FROM Skills WHERE SkillID = 10), N'Expert',      '2013-02-01', 45),
    ((SELECT $node_id FROM Professionals WHERE ProfessionalID = 7),  (SELECT $node_id FROM Skills WHERE SkillID = 5),  N'Advanced',    '2017-09-01', 12),
    ((SELECT $node_id FROM Professionals WHERE ProfessionalID = 7),  (SELECT $node_id FROM Skills WHERE SkillID = 6),  N'Intermediate','2018-04-01', 7),
    ((SELECT $node_id FROM Professionals WHERE ProfessionalID = 8),  (SELECT $node_id FROM Skills WHERE SkillID = 7),  N'Advanced',    '2019-05-01', 17),
    ((SELECT $node_id FROM Professionals WHERE ProfessionalID = 8),  (SELECT $node_id FROM Skills WHERE SkillID = 9),  N'Intermediate','2020-01-01', 9),
    ((SELECT $node_id FROM Professionals WHERE ProfessionalID = 9),  (SELECT $node_id FROM Skills WHERE SkillID = 12), N'Expert',      '2016-07-01', 29),
    ((SELECT $node_id FROM Professionals WHERE ProfessionalID = 9),  (SELECT $node_id FROM Skills WHERE SkillID = 1),  N'Advanced',    '2015-02-01', 18),
    ((SELECT $node_id FROM Professionals WHERE ProfessionalID = 10), (SELECT $node_id FROM Skills WHERE SkillID = 4),  N'Advanced',    '2013-06-01', 22),
    ((SELECT $node_id FROM Professionals WHERE ProfessionalID = 10), (SELECT $node_id FROM Skills WHERE SkillID = 9),  N'Intermediate','2015-01-01', 11),
    ((SELECT $node_id FROM Professionals WHERE ProfessionalID = 11), (SELECT $node_id FROM Skills WHERE SkillID = 8),  N'Intermediate','2021-05-01', 5),
    ((SELECT $node_id FROM Professionals WHERE ProfessionalID = 11), (SELECT $node_id FROM Skills WHERE SkillID = 10), N'Beginner',    '2022-01-01', 3),
    ((SELECT $node_id FROM Professionals WHERE ProfessionalID = 12), (SELECT $node_id FROM Skills WHERE SkillID = 2),  N'Expert',      '2014-11-01', 50),
    ((SELECT $node_id FROM Professionals WHERE ProfessionalID = 12), (SELECT $node_id FROM Skills WHERE SkillID = 3),  N'Expert',      '2015-08-01', 37);
GO

SELECT * FROM HAS_SKILL

-- 3. RECOMMENDS: Professional -> Professional
INSERT INTO RECOMMENDS ($from_id, $to_id, RecommendationDate, RelationshipType, RecommendationText)
VALUES
    ((SELECT $node_id FROM Professionals WHERE ProfessionalID = 1), (SELECT $node_id FROM Professionals WHERE ProfessionalID = 4),  '2023-06-15', N'Colleague', N'Отличный аналитик, быстро учится новому.'),
    ((SELECT $node_id FROM Professionals WHERE ProfessionalID = 9), (SELECT $node_id FROM Professionals WHERE ProfessionalID = 1),  '2022-12-01', N'Colleague', N'Один из лучших разработчиков в команде.'),
    ((SELECT $node_id FROM Professionals WHERE ProfessionalID = 6), (SELECT $node_id FROM Professionals WHERE ProfessionalID = 2),  '2023-03-10', N'Manager',   N'Выдающиеся организаторские способности.'),
    ((SELECT $node_id FROM Professionals WHERE ProfessionalID = 2), (SELECT $node_id FROM Professionals WHERE ProfessionalID = 8),  '2023-09-20', N'Colleague', N'Творческий и ответственный подход.'),
    ((SELECT $node_id FROM Professionals WHERE ProfessionalID = 12), (SELECT $node_id FROM Professionals WHERE ProfessionalID = 4),  '2023-11-05', N'Colleague', N'Перспективный специалист в data science.'),
    ((SELECT $node_id FROM Professionals WHERE ProfessionalID = 3), (SELECT $node_id FROM Professionals WHERE ProfessionalID = 10), '2023-07-18', N'Colleague', N'Глубокие знания в риск-менеджменте.'),
    ((SELECT $node_id FROM Professionals WHERE ProfessionalID = 10), (SELECT $node_id FROM Professionals WHERE ProfessionalID = 3),  '2023-08-22', N'Colleague', N'Надёжный партнёр в финансовом анализе.'),
    ((SELECT $node_id FROM Professionals WHERE ProfessionalID = 7), (SELECT $node_id FROM Professionals WHERE ProfessionalID = 9),  '2023-04-14', N'Colleague', N'Настоящий эксперт в облачных технологиях.'),
    ((SELECT $node_id FROM Professionals WHERE ProfessionalID = 5), (SELECT $node_id FROM Professionals WHERE ProfessionalID = 11), '2023-10-01', N'Manager',   N'Хорошие результаты в продажах.'),
    ((SELECT $node_id FROM Professionals WHERE ProfessionalID = 8), (SELECT $node_id FROM Professionals WHERE ProfessionalID = 6),  '2023-02-11', N'Client',    N'Профессиональный HR-консалтинг.'),
    ((SELECT $node_id FROM Professionals WHERE ProfessionalID = 1), (SELECT $node_id FROM Professionals WHERE ProfessionalID = 12), '2023-12-10', N'Manager',   N'Выдающийся техлид, ведёт команду к успеху.'),
    ((SELECT $node_id FROM Professionals WHERE ProfessionalID = 4), (SELECT $node_id FROM Professionals WHERE ProfessionalID = 1),  '2023-06-20', N'Colleague', N'Лучший ментор по Python и SQL.');
GO

SELECT * FROM RECOMMENDS

-- ЗАПРОСЫ С ФУНКЦИЕЙ MATCH (5 запросов)

-- 1. Найти всех профессионалов, работающих в Google, которые владеют Python на уровне Expert.
SELECT
    p.FirstName + N' ' + p.LastName AS [Профессионал],
    s.SkillName AS [Навык],
    hs.ProficiencyLevel AS [Уровень],
    c.CompanyName AS [Компания]
FROM Professionals p, HAS_SKILL hs, Skills s, WORKS_AT w, Companies c
WHERE MATCH(p-(hs)->s AND p-(w)->c)
  AND c.CompanyName = N'Google'
  AND s.SkillName = N'SQL'
  AND hs.ProficiencyLevel = N'Advanced';
GO

-- 2. Найти всех профессионалов, которым дал рекомендацию человек с навыком Leadership,
--    и показать компании, где работают рекомендованные.
SELECT
    recommender.FirstName + N' ' + recommender.LastName AS [Рекомендующий],
    recommended.FirstName + N' ' + recommended.LastName AS [Рекомендованный],
    c.CompanyName AS [Компания рекомендованного]
FROM Professionals recommender, RECOMMENDS rec, Professionals recommended, WORKS_AT w, Companies c
WHERE MATCH(recommender-(rec)->recommended AND recommended-(w)->c)
  AND EXISTS (
      SELECT 1 FROM HAS_SKILL hs, Skills s
      WHERE MATCH(recommender-(hs)->s)
        AND s.SkillName = N'Leadership'
  )
ORDER BY recommender.LastName, recommended.LastName;
GO

-- 3. Найти навыки, которыми владеют профессионалы из компании EPAM,
--    и подсчитать количество носителей каждого навыка.
SELECT
    s.SkillName AS [Навык],
    s.Category AS [Категория],
    COUNT(p.ProfessionalID) AS [Количество сотрудников]
FROM Companies c, WORKS_AT w, Professionals p, HAS_SKILL hs, Skills s
WHERE MATCH(c<-(w)-p-(hs)->s)
  AND c.CompanyName = N'EPAM Systems'
GROUP BY s.SkillName, s.Category
ORDER BY [Количество сотрудников] DESC, s.SkillName;
GO

-- 4. Найти пары профессионалов, которые взаимно рекомендовали друг друга,
--    и показать компании, в которых они работают.
SELECT
    p1.FirstName + N' ' + p1.LastName AS [Первый профессионал],
    c1.CompanyName AS [Компания первого],
    p2.FirstName + N' ' + p2.LastName AS [Второй профессионал],
    c2.CompanyName AS [Компания второго]
FROM Professionals p1, RECOMMENDS r1, Professionals p2, RECOMMENDS r2,
     WORKS_AT w1, Companies c1, WORKS_AT w2, Companies c2
WHERE MATCH(p1-(r1)->p2 AND p2-(r2)->p1
            AND p1-(w1)->c1 AND p2-(w2)->c2);
GO

-- 5. Вывести все пары профессионалов, в которых один дал рекомендацию другому, и оба при этом работают в одной компании. 
SELECT 
    recommender.FirstName + N' ' + recommender.LastName AS [Рекомендующий],
    recommended.FirstName + N' ' + recommended.LastName AS [Рекомендованный],
    c.CompanyName AS [Компания],
    rec.RelationshipType AS [Тип отношений]
FROM 
    Professionals recommender,
    RECOMMENDS rec,
    Professionals recommended,
    WORKS_AT w_recommender,
    WORKS_AT w_recommended,
    Companies c
WHERE MATCH(
    recommender-(rec)->recommended 
    AND recommender-(w_recommender)->c 
    AND recommended-(w_recommended)->c
)
ORDER BY c.CompanyName, recommender.LastName, recommended.LastName;
GO

-- ЗАПРОСЫ С ФУНКЦИЕЙ SHORTEST_PATH (2 запроса)

-- Запрос 1: Найти кратчайший путь (один или более шагов) от Ивана Петрова (ID=1)
-- до всех профессионалов, до которых можно дойти по рекомендациям.
WITH RecPaths AS (
    SELECT
        p_start.FirstName + N' ' + p_start.LastName AS [Начальный узел],
        CONCAT(
            p_start.FirstName + N' ' + p_start.LastName, N' -> ',
            STRING_AGG(p_mid.FirstName + N' ' + p_mid.LastName, N' -> ')
                WITHIN GROUP (GRAPH PATH)
        ) AS [Путь],
        COUNT(p_mid.ProfessionalID) WITHIN GROUP (GRAPH PATH) AS [Шагов],
        LAST_VALUE(p_mid.FirstName + N' ' + p_mid.LastName)
            WITHIN GROUP (GRAPH PATH) AS [Конечный узел]
    FROM
        Professionals AS p_start,
        RECOMMENDS FOR PATH AS r,
        Professionals FOR PATH AS p_mid
    WHERE MATCH(SHORTEST_PATH(p_start(-(r)->p_mid)+))
      AND p_start.ProfessionalID = 1
)
SELECT * FROM RecPaths
ORDER BY [Шагов], [Конечный узел];
GO

-- Запрос 2: Найти кратчайшие пути от Михаила Павлова (ID=9) до других профессионалов,
-- ограничив длину пути диапазоном от 1 до 5 шагов.
WITH PathLimited AS (
    SELECT
        p_start.FirstName + N' ' + p_start.LastName AS [Начальный узел],
        CONCAT(
            p_start.FirstName + N' ' + p_start.LastName, N' -> ',
            STRING_AGG(p_mid.FirstName + N' ' + p_mid.LastName, N' -> ')
                WITHIN GROUP (GRAPH PATH)
        ) AS [Путь],
        COUNT(p_mid.ProfessionalID) WITHIN GROUP (GRAPH PATH) AS [Шагов],
        LAST_VALUE(p_mid.FirstName + N' ' + p_mid.LastName)
            WITHIN GROUP (GRAPH PATH) AS [Конечный узел]
    FROM
        Professionals AS p_start,
        RECOMMENDS FOR PATH AS r,
        Professionals FOR PATH AS p_mid
    WHERE MATCH(SHORTEST_PATH(p_start(-(r)->p_mid){1,5}))
      AND p_start.ProfessionalID = 9
)
SELECT * FROM PathLimited
ORDER BY [Шагов], [Конечный узел];
GO
