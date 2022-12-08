/* Database schema to keep the structure of entire database. */

CREATE TABLE animals (  
  id INT GENERATED ALWAYS AS IDENTITY,
  name VARCHAR(250),
  date_of_birth DATE,
  escape_attempts INT,
  neutered BOOLEAN,
  weight_kg DECIMAL,
  PRIMARY KEY (id)
);

ALTER TABLE animals ADD species VARCHAR(50);

/*Create a table named owners*/

CREATE TABLE owners (  
  id INT GENERATED ALWAYS AS IDENTITY,
  full_name VARCHAR(250),
  age INT,
  PRIMARY KEY (id)
);

/*Create a table named species*/

CREATE TABLE species (  
  id INT GENERATED ALWAYS AS IDENTITY,
  name VARCHAR(250),
  PRIMARY KEY (id)
);

/*Modify animals table*/

  /*Remove column species*/
ALTER TABLE animals DROP species;

  /*Add column species_id which is a foreign key referencing species table*/
ALTER TABLE animals ADD species_id INT;
ALTER TABLE animals ADD FOREIGN KEY (species_id) REFERENCES species(id);

  /*Add column owner_id which is a foreign key referencing the owners table*/
ALTER TABLE animals ADD owner_id INT;
ALTER TABLE animals ADD FOREIGN KEY (species_id) REFERENCES owners(id);
