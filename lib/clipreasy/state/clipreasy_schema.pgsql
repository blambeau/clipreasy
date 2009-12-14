DROP TABLE IF EXISTS processes CASCADE;
CREATE TABLE processes (
  id 	            SERIAL NOT NULL,
  code            TEXT NOT NULL,
  label           TEXT NOT NULL,
  version         TEXT NOT NULL,
  description     TEXT NOT NULL DEFAULT '',
  formal_def      TEXT NOT NULL,
  sort_by         INTEGER NOT NULL DEFAULT 0,
  sleep           BOOLEAN NOT NULL DEFAULT false,
  CONSTRAINT pk_processes PRIMARY KEY (id),
  CONSTRAINT ak_processes UNIQUE (code)
);

DROP TABLE IF EXISTS statements CASCADE;
CREATE TABLE statements (
	process         BIGINT NOT NULL,
	lid             BIGINT NOT NULL,
	kind            TEXT NOT NULL,
	code            TEXT NOT NULL,
	label           TEXT NOT NULL,
  description     TEXT NOT NULL DEFAULT '',
  sort_by         INTEGER NOT NULL DEFAULT 0,
  CONSTRAINT pk_statements PRIMARY KEY (process, lid),
  CONSTRAINT fk_statement_ref_process FOREIGN KEY (process) REFERENCES processes (id)
);

DROP TABLE IF EXISTS process_executions CASCADE;
CREATE TABLE process_executions (
  process         BIGINT NOT NULL,
  id              BIGSERIAL NOT NULL,
  status          TEXT NOT NULL DEFAULT 'pending',
  started_at      TIMESTAMP NOT NULL DEFAULT current_timestamp,
  ended_at        TIMESTAMP,
  CONSTRAINT pk_process_executions PRIMARY KEY (process, id),
  CONSTRAINT fk_process_execution_ref_process FOREIGN KEY (process) REFERENCES processes (id),
  CONSTRAINT ak_process_executions UNIQUE (id)
);

DROP TABLE IF EXISTS statement_executions CASCADE;
CREATE TABLE statement_executions (
	process             BIGINT NOT NULL,
	process_execution   BIGINT NOT NULL,
	statement           BIGINT NOT NULL,
	id                  BIGSERIAL NOT NULL,
	parent              BIGINT NOT NULL,
  status              TEXT NOT NULL DEFAULT 'pending',
  started_at          TIMESTAMP NOT NULL DEFAULT current_timestamp,
  ended_at            TIMESTAMP,
  CONSTRAINT pk_statement_executions PRIMARY KEY (process, process_execution, statement, id),
  CONSTRAINT fk_statement_execution_ref_process_executions FOREIGN KEY (process, process_execution) REFERENCES process_executions (process, id),
  CONSTRAINT fk_statement_execution_ref_statement FOREIGN KEY (process, statement) REFERENCES statements (process, lid),
  CONSTRAINT fk_statement_execution_parent FOREIGN KEY (process, process_execution, statement, parent) REFERENCES statement_executions (process, process_execution, statement, id),
  CONSTRAINT ak_statement_executions UNIQUE (id)
);
