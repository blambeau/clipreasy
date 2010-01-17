DROP TABLE IF EXISTS processes CASCADE;
CREATE TABLE processes (
  id 	            SERIAL NOT NULL,
  code            TEXT NOT NULL,
  label           TEXT NOT NULL,
  version         TEXT NOT NULL,
  description     TEXT NOT NULL DEFAULT '',
  formaldef       TEXT NOT NULL,
  sort_by         INTEGER NOT NULL DEFAULT 0,
  sleep           BOOLEAN NOT NULL DEFAULT false,
  CONSTRAINT pk_processes PRIMARY KEY (id),
  CONSTRAINT ak_processes UNIQUE (code, version)
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
  CONSTRAINT pk_statements PRIMARY KEY (process, lid),
  CONSTRAINT fk_statement_ref_process FOREIGN KEY (process) REFERENCES processes (id),
  CONSTRAINT fk_statement_ref_parent_statement FOREIGN KEY (process, parent) REFERENCES statements (process, lid)
);

DROP TABLE IF EXISTS process_executions CASCADE;
CREATE TABLE process_executions (
  process         BIGINT NOT NULL,
  id              BIGSERIAL NOT NULL,
  status          TEXT NOT NULL DEFAULT 'pending',
  started_at      TIMESTAMP NOT NULL DEFAULT current_timestamp,
  ended_at        TIMESTAMP,
  CONSTRAINT pk_process_executions PRIMARY KEY (id),
  CONSTRAINT fk_process_execution_ref_process FOREIGN KEY (process) REFERENCES processes (id),
  CONSTRAINT ak_process_executions UNIQUE (process, id)
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
  ended_at            TIMESTAMP,
  CONSTRAINT pk_statement_executions PRIMARY KEY (id),
  CONSTRAINT fk_statement_execution_ref_process_executions FOREIGN KEY (process, process_execution) REFERENCES process_executions (process, id),
  CONSTRAINT fk_statement_execution_ref_statement FOREIGN KEY (process, statement) REFERENCES statements (process, lid),
  CONSTRAINT fk_statement_execution_parent FOREIGN KEY (parent) REFERENCES statement_executions (id)
);

DROP VIEW IF EXISTS pending_activities;
CREATE VIEW pending_activities AS 
SELECT se.process as process, 
       se.process_execution as process_execution,
       se.statement as statement,
       se.id as id,
       se.started_at as started_at,
       p.code     as process_code,
       p.label    as process_label,
       s.code     as statement_code,
       s.label    as statement_label,
       s.color    as statement_color
  FROM statement_executions AS se 
  INNER JOIN statements AS s ON se.process = s.process and se.statement = s.lid
  INNER JOIN processes  AS p ON s.process = p.id
  WHERE s.kind = 'CliPrEasy::Engine::Activity'
    AND se.status = 'pending';