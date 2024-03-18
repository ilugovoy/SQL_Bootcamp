  SELECT person.name, COUNT(*) AS count_of_visits -- подсчет количества посещений для каждого person_id
    FROM person_visits
	JOIN person ON person.id = person_visits.person_id
GROUP BY person.name, person_visits.person_id
ORDER BY count_of_visits DESC, person.name
   LIMIT 4;
