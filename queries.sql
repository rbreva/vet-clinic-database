/*Queries that provide answers to the questions from all projects.*/

/*Find all animals whose name ends in "mon".*/
SELECT * FROM animals WHERE name LIKE '%mon';

/*List the name of all animals born between 2016 and 2019.*/
SELECT name FROM animals WHERE date_of_birth BETWEEN '2016-01-01' AND '2019-12-31';

/*List the name of all animals that are neutered and have less than 3 escape attempts.*/
SELECT name FROM animals WHERE neutered = true AND escape_attempts < 3;

/*List the date of birth of all animals named either "Agumon" or "Pikachu".*/
SELECT date_of_birth FROM animals WHERE name = 'Agumon' OR name = 'Pikachu';

/*List name and escape attempts of animals that weigh more than 10.5kg*/
SELECT name, escape_attempts FROM animals WHERE weight_kg > 10.5;

/*Find all animals that are neutered.*/
SELECT * FROM animals WHERE neutered = true;

/*Find all animals not named Gabumon.*/
SELECT * FROM animals WHERE NOT name = 'Gabumon';

/*Find all animals with a weight between 10.4kg and 17.3kg (including the animals with the weights that equals precisely 10.4kg or 17.3kg)*/
SELECT * FROM animals WHERE weight_kg BETWEEN 10.4 AND 17.3;


/*Inside a transaction update the animals table by setting the species column to unspecified. Verify that change was made. Then roll back the change and verify that the species columns went back to the state before the transaction.*/
BEGIN;
UPDATE animals SET species = 'unspecified';
ROLLBACK;

/*Inside a transaction:
Update the animals table by setting the species column to digimon for all animals that have a name ending in mon.
Update the animals table by setting the species column to pokemon for all animals that don't have species already set.
Commit the transaction.
Verify that change was made and persists after commit.*/
BEGIN;
UPDATE animals SET species = 'digimon' WHERE name LIKE '%mon';
UPDATE animals SET species = 'pokemon' WHERE species IS NULL;
COMMIT;

/*Now, take a deep breath and... Inside a transaction delete all records in the animals table, then roll back the transaction.
After the rollback verify if all records in the animals table still exists. After that, you can start breathing as usual.*/
BEGIN;
DELETE FROM animals;
ROLLBACK;

/*Inside a transaction:
Delete all animals born after Jan 1st, 2022.
Create a savepoint for the transaction.
Update all animals' weight to be their weight multiplied by -1.
Rollback to the savepoint
Update all animals' weights that are negative to be their weight multiplied by -1.
Commit transaction*/
BEGIN;
DELETE FROM animals WHERE date_of_birth > '2022-01-01';
SAVEPOINT animals_weight;
UPDATE animals SET weight_kg = weight_kg * -1;
ROLLBACK TO animals_weight;
UPDATE animals SET weight_kg = weight_kg * -1 WHERE weight_kg < 0;
COMMIT;

/*How many animals are there?*/
SELECT COUNT(*) FROM animals;

/*How many animals have never tried to escape?*/
SELECT COUNT(*) FROM animals WHERE escape_attempts = 0;

/*What is the average weight of animals?*/
SELECT AVG(weight_kg) FROM animals;

/*Who escapes the most, neutered or not neutered animals?*/
SELECT MAX(escape_attempts) FROM animals GROUP BY neutered;

/*What is the minimum and maximum weight of each type of animal?*/
SELECT MIN(weight_kg), MAX(weight_kg) FROM animals GROUP BY species;

/*What is the average number of escape attempts per animal type of those born between 1990 and 2000?*/
SELECT AVG(escape_attempts) FROM animals WHERE date_of_birth BETWEEN '1990-01-01' AND '2000-12-31' GROUP BY species;


/*What animals belong to Melody Pond?*/
SELECT name FROM animals JOIN owners ON owners.full_name = 'Melody Pond' AND owners.id = animals.owner_id;

/*List of all animals that are pokemon (their type is Pokemon).*/
SELECT animals.name FROM animals JOIN species ON species.name = 'Pokemon' AND animals.species_id = species.id;

/*List all owners and their animals, remember to include those that don't own any animal.*/
SELECT owners.full_name, animals.name FROM owners LEFT JOIN animals ON owners.id=animals.owner_id ORDER BY full_name;

/*How many animals are there per species?*/
SELECT species.name, COUNT(animals.name) FROM animals JOIN species ON animals.species_id = species.id GROUP BY species.id;

/*List all Digimon owned by Jennifer Orwell.*/
SELECT animals.name FROM animals JOIN owners ON animals.owner_id = owners.id JOIN species ON animals.species_id = species.id WHERE species.name='Digimon' AND owners.full_name='Jennifer Orwell';

/*List all animals owned by Dean Winchester that haven't tried to escape.*/
SELECT animals.name FROM animals JOIN owners ON animals.owner_id = owners.id WHERE owners.full_name='Dean Winchester' AND escape_attempts=0;

/*Who owns the most animals?*/
SELECT owners.full_name, COUNT(animals.name) FROM animals JOIN owners ON animals.owner_id = owners.id GROUP BY owners.full_name ORDER BY COUNT DESC LIMIT 1;



/*Who was the last animal seen by William Tatcher?*/
SELECT vets.name, animals.name, date_of_visit FROM visits JOIN animals ON animals.id = animals_id JOIN vets ON vets.id = vets_id WHERE vets.name = 'William Tatcher'ORDER BY date_of_visit DESC LIMIT 1;

/*How many different animals did Stephanie Mendez see?*/
SELECT vets.name, COUNT(animals.name) FROM visits JOIN animals ON animals.id = animals_id JOIN vets ON vets.id = vets_id WHERE vets.name = 'Stephanie Mendez' GROUP BY vets.name;

/*List all vets and their specialties, including vets with no specialties.*/
SELECT vets.name, species.name FROM vets LEFT JOIN specializations ON vets.id = vets_id LEFT JOIN species ON species.id = species_id ORDER BY vets.name;

/*List all animals that visited Stephanie Mendez between April 1st and August 30th, 2020.*/
SELECT vets.name, animals.name, date_of_visit FROM visits JOIN animals ON animals.id = animals_id JOIN vets ON vets.id = vets_id WHERE vets.name = 'Stephanie Mendez' AND date_of_visit BETWEEN '2020-04-01' AND '2020-08-30' ORDER BY animals.name;

/*What animal has the most visits to vets?*/
SELECT animals.name, COUNT(animals.name) FROM visits JOIN animals ON animals.id = animals_id GROUP BY animals.name ORDER BY COUNT(animals.name) DESC LIMIT 1;

/*Who was Maisy Smith's first visit?*/
SELECT animals.name, date_of_visit FROM visits JOIN animals ON animals.id = animals_id JOIN vets ON vets.id = vets_id WHERE vets.name = 'Maisy Smith' ORDER BY date_of_visit ASC LIMIT 1;

/*Details for most recent visit: animal information, vet information, and date of visit.*/
SELECT * FROM visits JOIN animals ON animals.id = animals_id JOIN vets ON vets.id = vets_id ORDER BY date_of_visit DESC LIMIT 1;

/*How many visits were with a vet that did not specialize in that animal's species?*/
SELECT COUNT(*) FROM visits JOIN animals ON animals.id = animals_id JOIN vets ON vets.id = vets_id JOIN specializations ON specializations.vets_id = vets.id WHERE specializations.species_id != animals.species_id;

/*What specialty should Maisy Smith consider getting? Look for the species she gets the most.*/
SELECT species.name FROM visits JOIN animals ON animals.id = animals_id JOIN vets ON vets.id = vets_id JOIN species ON species.id = species_id WHERE vets.name = 'Maisy Smith' GROUP BY species.name ORDER BY COUNT(species.name) DESC LIMIT 1;


/*---- ------*/

explain analyze SELECT COUNT(*) FROM visits where animals_id = 4;
explain analyze SELECT * FROM visits where vets_id = 2;
explain analyze SELECT * FROM owners where email = 'owner_18327@mail.com';


