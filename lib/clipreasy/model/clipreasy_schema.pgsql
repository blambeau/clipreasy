DROP TABLE IF EXISTS roles CASCADE;
CREATE TABLE roles (
	code        TEXT NOT NULL,
	label       TEXT NOT NULL,
	description TEXT NOT NULL DEFAULT '',
	CONSTRAINT pk_roles PRIMARY KEY (code)
);

DROP TABLE IF EXISTS actors CASCADE;
CREATE TABLE actors (
  id         SERIAL NOT NULL,
  login      TEXT,
  password   TEXT,
  first_name TEXT NOT NULL,
  last_name  TEXT NOT NULL,
  initials   TEXT NOT NULL,
  role       TEXT NOT NULL,
  sleep      BOOLEAN NOT NULL DEFAULT false,
  CONSTRAINT pk_actors PRIMARY KEY (id),
  CONSTRAINT ak_actors_login UNIQUE (login),
  CONSTRAINT fk_actor_has_a_role FOREIGN KEY (role) REFERENCES roles(code)
);

DROP TABLE IF EXISTS processes CASCADE;
CREATE TABLE processes (
  id 	            SERIAL NOT NULL,
  code            TEXT NOT NULL,
  label           TEXT NOT NULL,
  version         TEXT NOT NULL,
  description     TEXT NOT NULL DEFAULT '',
  formaldef       TEXT NOT NULL,
  folder          TEXT NOT NULL,
  sort_by         INTEGER NOT NULL DEFAULT 0,
  sleep           BOOLEAN NOT NULL DEFAULT false,
  business_id     INT8,
  CONSTRAINT pk_processes PRIMARY KEY (id),
  CONSTRAINT ak_processes UNIQUE (code, version)
);
DROP VIEW IF EXISTS active_processes_combo;
DROP VIEW IF EXISTS processes_combo;
CREATE VIEW processes_combo AS (
	SELECT id as value,
	       label,
         sleep
    FROM processes
   ORDER BY sort_by
);
CREATE VIEW active_processes_combo AS (
	SELECT value, label
	  FROM processes_combo
	 WHERE sleep=false
);

DROP TABLE IF EXISTS statements CASCADE;
CREATE TABLE statements (
	process         BIGINT NOT NULL,
	lid             BIGINT NOT NULL,
	parent          BIGINT NOT NULL,
	kind            TEXT NOT NULL,
	code            TEXT NOT NULL DEFAULT '',
	label           TEXT NOT NULL DEFAULT '',
	color           TEXT NOT NULL DEFAULT '',
  description     TEXT NOT NULL DEFAULT '',
  sort_by         INTEGER NOT NULL DEFAULT 0,
  business_id     INT8,
  CONSTRAINT pk_statements PRIMARY KEY (process, lid),
  CONSTRAINT fk_statement_ref_process FOREIGN KEY (process) REFERENCES processes (id),
  CONSTRAINT fk_statement_ref_parent_statement FOREIGN KEY (process, parent) REFERENCES statements (process, lid)
);
DROP VIEW IF EXISTS activities;
CREATE VIEW activities AS (
	SELECT * FROM statements 
	 WHERE kind = 'CliPrEasy::Engine::Activity'
	 ORDER BY sort_by
);

DROP TABLE IF EXISTS process_executions CASCADE;
CREATE TABLE process_executions (
  process         BIGINT NOT NULL,
  id              BIGSERIAL NOT NULL,
  status          TEXT NOT NULL DEFAULT 'pending',
  started_at      TIMESTAMP NOT NULL DEFAULT current_timestamp,
  started_by      INT8,
  deadline        TIMESTAMP,
  ended_at        TIMESTAMP,
  ended_by        INT8,
  business_id     INT8,
  CONSTRAINT pk_process_executions PRIMARY KEY (id),
  CONSTRAINT fk_process_execution_ref_process FOREIGN KEY (process) REFERENCES processes (id),
  CONSTRAINT ak_process_executions UNIQUE (process, id),
  CONSTRAINT fk_process_execution_starteb_by FOREIGN KEY (started_by) REFERENCES actors (id),
  CONSTRAINT fk_process_execution_ended_by FOREIGN KEY (ended_by) REFERENCES actors (id)
);

DROP TABLE IF EXISTS statement_executions CASCADE;
CREATE TABLE statement_executions (
	process             BIGINT NOT NULL,
	process_execution   BIGINT NOT NULL,
	statement           BIGINT NOT NULL,
	id                  BIGSERIAL NOT NULL,
	parent              BIGINT,
  status              TEXT NOT NULL DEFAULT 'pending',
  started_at          TIMESTAMP NOT NULL DEFAULT current_timestamp,
  started_by          INT8,
  deadline            TIMESTAMP,
  ended_at            TIMESTAMP,
  ended_by            INT8,
  business_id         INT8,
  CONSTRAINT pk_statement_executions PRIMARY KEY (id),
  CONSTRAINT fk_statement_execution_ref_process_executions FOREIGN KEY (process, process_execution) REFERENCES process_executions (process, id),
  CONSTRAINT fk_statement_execution_ref_statement FOREIGN KEY (process, statement) REFERENCES statements (process, lid),
  CONSTRAINT fk_statement_execution_parent FOREIGN KEY (parent) REFERENCES statement_executions (id),
  CONSTRAINT fk_statement_execution_starteb_by FOREIGN KEY (started_by) REFERENCES actors (id),
  CONSTRAINT fk_statement_execution_ended_by FOREIGN KEY (ended_by) REFERENCES actors (id)
);

DROP VIEW IF EXISTS pending_activities;
CREATE VIEW pending_activities AS 
SELECT se.process as process, 
       se.process_execution as process_execution,
       se.statement as statement,
       se.id as id,
       se.started_at as se_started_at,
       se.deadline  as se_deadline,
       se.business_id as se_business,
       pe.started_at  as pe_started_at,
       pe.deadline  as pe_deadline,
       pe.business_id as pe_business,
       p.code     as p_code,
       p.label    as p_label,
       p.business_id as p_business,
       s.code     as s_code,
       s.label    as s_label,
       s.color    as s_color,
       s.business_id as s_business
  FROM statement_executions AS se 
  INNER JOIN process_executions as pe ON se.process_execution=pe.id
  INNER JOIN statements AS s ON se.process = s.process and se.statement = s.lid
  INNER JOIN processes  AS p ON s.process = p.id
  WHERE s.kind = 'CliPrEasy::Engine::Activity'
    AND se.status = 'pending';