# LinkedInGraph

A graph database of a LinkedIn-style professional network built on MS SQL Server graph tables (`AS NODE` / `AS EDGE`) and queried with `MATCH` and `SHORTEST_PATH`.

**University project — BSU, Faculty of Mechanics and Mathematics** (assignment no. 37: professional network with colleagues, skills and companies).

## What's inside

- `LinkedInGraph.sql` — one script that recreates the database, the schema, sample data and all queries.
- **3 node tables:** `Professionals`, `Skills`, `Companies`.
- **3 edge tables** with edge constraints (`CONNECTION ... ON DELETE NO ACTION`):
  - `WORKS_AT` (Professional → Company): job title, start/end date, current flag;
  - `HAS_SKILL` (Professional → Skill): proficiency level (`CHECK`: Beginner / Intermediate / Advanced / Expert), date acquired, endorsement count;
  - `RECOMMENDS` (Professional → Professional): date, relationship type (Colleague / Manager / Client / Other), text.
- **Sample data:** 12 professionals, 12 skills, 12 companies, 12 `WORKS_AT`, 24 `HAS_SKILL` and 8 `RECOMMENDS` edges.
- **5 queries with `MATCH`** and **2 queries with `SHORTEST_PATH`** (recommendation chains).
- `Diagrams.drawio` — draw.io diagrams of the model (6 pages).
- `LinkedInGraph.pbix` — Power BI report on top of the database.
- `img/` — screenshots (Companies, Professionals, Skills).
- `LinkedInGraph.bak` — SQL Server backup of the database.
- `Task.txt`, `NewTask.txt` — the original assignment texts (in Russian).

## Example queries

Skills of EPAM Systems employees, with the number of people who have each skill:

```sql
SELECT s.SkillName, s.Category, COUNT(p.ProfessionalID) AS [Employees]
FROM Companies c, WORKS_AT w, Professionals p, HAS_SKILL hs, Skills s
WHERE MATCH(c<-(w)-p-(hs)->s)
  AND c.CompanyName = N'EPAM Systems'
GROUP BY s.SkillName, s.Category
ORDER BY [Employees] DESC, s.SkillName;
```

Pairs who recommended each other:

```sql
WHERE MATCH(p1-(r1)->p2 AND p2-(r2)->p1
            AND p1-(w1)->c1 AND p2-(w2)->c2);
```

Shortest recommendation chains from one person (1 to 5 hops):

```sql
WHERE MATCH(SHORTEST_PATH(p_start(-(r)->p_mid){1,5}))
  AND p_start.ProfessionalID = 9
```

## Tech stack

MS SQL Server 2019+ (graph tables, edge constraints and `SHORTEST_PATH`), T-SQL, draw.io, Power BI.

## How to run

1. Open `LinkedInGraph.sql` in SQL Server Management Studio, connected to a SQL Server 2019 or newer instance.
2. Execute the script. It drops and recreates the `LinkedInGraph` database, so do not run it on a server where that name is in use.
3. Run the query blocks at the end of the file one by one.

Alternatively, restore `LinkedInGraph.bak`. Open `LinkedInGraph.pbix` in Power BI Desktop and `Diagrams.drawio` in draw.io.

## Author

Ksenia Plehova — [GitHub](https://github.com/kseniaplehova)
