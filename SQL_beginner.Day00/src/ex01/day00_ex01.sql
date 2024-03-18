	SELECT 
			person.name,
			person.age
	  FROM	person
	 WHERE	person.address = 'Kazan'
	   AND	person.gender = 'female'
  ORDER BY	person.name;
  