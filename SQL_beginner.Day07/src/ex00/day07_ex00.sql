  SELECT person_id, COUNT(*) AS count_of_visits -- подсчет количества посещений для каждого person_id
    FROM person_visits
GROUP BY person_id
ORDER BY count_of_visits DESC, person_id ASC;
