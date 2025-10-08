CREATE DATABASE directus;
CREATE DATABASE letterspace;
CREATE DATABASE umami;
CREATE DATABASE keycloak;

CREATE USER monitoring WITH PASSWORD 'monitoring';
GRANT pg_monitor TO monitoring;
GRANT SELECT ON pg_stat_database TO monitoring;
