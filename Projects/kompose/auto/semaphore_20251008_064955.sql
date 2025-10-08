--
-- PostgreSQL database dump
--

\restrict Ftcokghp0DYHVxoRJfyaVIXsVtlxPc122QJufD7uBbkodWlXeKdrj7Aw9dRc7Gl

-- Dumped from database version 18.0 (Debian 18.0-1.pgdg13+3)
-- Dumped by pg_dump version 18.0 (Debian 18.0-1.pgdg13+3)

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: access_key; Type: TABLE; Schema: public; Owner: valknar
--

CREATE TABLE public.access_key (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    type character varying(255) NOT NULL,
    project_id integer,
    secret text,
    environment_id integer,
    user_id integer,
    owner character varying(20) DEFAULT ''::character varying NOT NULL,
    plain text,
    storage_id integer,
    source_storage_id integer,
    source_storage_key character varying(1000)
);


ALTER TABLE public.access_key OWNER TO valknar;

--
-- Name: access_key_id_seq; Type: SEQUENCE; Schema: public; Owner: valknar
--

CREATE SEQUENCE public.access_key_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.access_key_id_seq OWNER TO valknar;

--
-- Name: access_key_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: valknar
--

ALTER SEQUENCE public.access_key_id_seq OWNED BY public.access_key.id;


--
-- Name: event; Type: TABLE; Schema: public; Owner: valknar
--

CREATE TABLE public.event (
    id integer NOT NULL,
    project_id integer,
    object_id integer,
    object_type character varying(20) DEFAULT ''::character varying,
    description text,
    created timestamp without time zone CONSTRAINT event_created_not_null1 NOT NULL,
    user_id integer
);


ALTER TABLE public.event OWNER TO valknar;

--
-- Name: event_backup_5784568; Type: TABLE; Schema: public; Owner: valknar
--

CREATE TABLE public.event_backup_5784568 (
    project_id integer,
    object_id integer,
    object_type character varying(20) DEFAULT ''::character varying,
    description text,
    created timestamp without time zone CONSTRAINT event_created_not_null NOT NULL,
    user_id integer
);


ALTER TABLE public.event_backup_5784568 OWNER TO valknar;

--
-- Name: event_id_seq; Type: SEQUENCE; Schema: public; Owner: valknar
--

CREATE SEQUENCE public.event_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.event_id_seq OWNER TO valknar;

--
-- Name: event_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: valknar
--

ALTER SEQUENCE public.event_id_seq OWNED BY public.event.id;


--
-- Name: migrations; Type: TABLE; Schema: public; Owner: valknar
--

CREATE TABLE public.migrations (
    version character varying(255) NOT NULL,
    upgraded_date timestamp without time zone,
    notes text
);


ALTER TABLE public.migrations OWNER TO valknar;

--
-- Name: option; Type: TABLE; Schema: public; Owner: valknar
--

CREATE TABLE public.option (
    key character varying(255) NOT NULL,
    value character varying(1000) NOT NULL
);


ALTER TABLE public.option OWNER TO valknar;

--
-- Name: project; Type: TABLE; Schema: public; Owner: valknar
--

CREATE TABLE public.project (
    id integer NOT NULL,
    created timestamp without time zone NOT NULL,
    name character varying(255) NOT NULL,
    alert boolean DEFAULT false NOT NULL,
    alert_chat character varying(30) DEFAULT ''::character varying,
    max_parallel_tasks integer DEFAULT 0 NOT NULL,
    type character varying(20) DEFAULT ''::character varying,
    default_secret_storage_id integer
);


ALTER TABLE public.project OWNER TO valknar;

--
-- Name: project__environment; Type: TABLE; Schema: public; Owner: valknar
--

CREATE TABLE public.project__environment (
    id integer NOT NULL,
    project_id integer NOT NULL,
    password character varying(255),
    "json" text NOT NULL,
    name character varying(255),
    env text,
    secret_storage_id integer,
    secret_storage_key_prefix character varying(1000)
);


ALTER TABLE public.project__environment OWNER TO valknar;

--
-- Name: project__environment_id_seq; Type: SEQUENCE; Schema: public; Owner: valknar
--

CREATE SEQUENCE public.project__environment_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.project__environment_id_seq OWNER TO valknar;

--
-- Name: project__environment_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: valknar
--

ALTER SEQUENCE public.project__environment_id_seq OWNED BY public.project__environment.id;


--
-- Name: project__integration; Type: TABLE; Schema: public; Owner: valknar
--

CREATE TABLE public.project__integration (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    project_id integer NOT NULL,
    template_id integer NOT NULL,
    auth_method character varying(15) DEFAULT 'none'::character varying NOT NULL,
    auth_secret_id integer,
    auth_header character varying(255),
    searchable boolean DEFAULT false NOT NULL,
    task_params_id integer
);


ALTER TABLE public.project__integration OWNER TO valknar;

--
-- Name: project__integration_alias; Type: TABLE; Schema: public; Owner: valknar
--

CREATE TABLE public.project__integration_alias (
    id integer NOT NULL,
    alias character varying(50) NOT NULL,
    project_id integer NOT NULL,
    integration_id integer
);


ALTER TABLE public.project__integration_alias OWNER TO valknar;

--
-- Name: project__integration_alias_id_seq; Type: SEQUENCE; Schema: public; Owner: valknar
--

CREATE SEQUENCE public.project__integration_alias_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.project__integration_alias_id_seq OWNER TO valknar;

--
-- Name: project__integration_alias_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: valknar
--

ALTER SEQUENCE public.project__integration_alias_id_seq OWNED BY public.project__integration_alias.id;


--
-- Name: project__integration_extract_value; Type: TABLE; Schema: public; Owner: valknar
--

CREATE TABLE public.project__integration_extract_value (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    integration_id integer NOT NULL,
    value_source character varying(255) NOT NULL,
    body_data_type character varying(255),
    key character varying(255),
    variable character varying(255),
    variable_type character varying(255)
);


ALTER TABLE public.project__integration_extract_value OWNER TO valknar;

--
-- Name: project__integration_extract_value_id_seq; Type: SEQUENCE; Schema: public; Owner: valknar
--

CREATE SEQUENCE public.project__integration_extract_value_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.project__integration_extract_value_id_seq OWNER TO valknar;

--
-- Name: project__integration_extract_value_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: valknar
--

ALTER SEQUENCE public.project__integration_extract_value_id_seq OWNED BY public.project__integration_extract_value.id;


--
-- Name: project__integration_id_seq; Type: SEQUENCE; Schema: public; Owner: valknar
--

CREATE SEQUENCE public.project__integration_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.project__integration_id_seq OWNER TO valknar;

--
-- Name: project__integration_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: valknar
--

ALTER SEQUENCE public.project__integration_id_seq OWNED BY public.project__integration.id;


--
-- Name: project__integration_matcher; Type: TABLE; Schema: public; Owner: valknar
--

CREATE TABLE public.project__integration_matcher (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    integration_id integer NOT NULL,
    match_type character varying(255),
    method character varying(255),
    body_data_type character varying(255),
    key character varying(510),
    value character varying(510)
);


ALTER TABLE public.project__integration_matcher OWNER TO valknar;

--
-- Name: project__integration_matcher_id_seq; Type: SEQUENCE; Schema: public; Owner: valknar
--

CREATE SEQUENCE public.project__integration_matcher_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.project__integration_matcher_id_seq OWNER TO valknar;

--
-- Name: project__integration_matcher_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: valknar
--

ALTER SEQUENCE public.project__integration_matcher_id_seq OWNED BY public.project__integration_matcher.id;


--
-- Name: project__inventory; Type: TABLE; Schema: public; Owner: valknar
--

CREATE TABLE public.project__inventory (
    id integer NOT NULL,
    project_id integer NOT NULL,
    type character varying(255) NOT NULL,
    inventory text NOT NULL,
    ssh_key_id integer,
    name character varying(255),
    become_key_id integer,
    template_id integer,
    repository_id integer,
    runner_tag character varying(255)
);


ALTER TABLE public.project__inventory OWNER TO valknar;

--
-- Name: project__inventory_id_seq; Type: SEQUENCE; Schema: public; Owner: valknar
--

CREATE SEQUENCE public.project__inventory_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.project__inventory_id_seq OWNER TO valknar;

--
-- Name: project__inventory_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: valknar
--

ALTER SEQUENCE public.project__inventory_id_seq OWNED BY public.project__inventory.id;


--
-- Name: project__repository; Type: TABLE; Schema: public; Owner: valknar
--

CREATE TABLE public.project__repository (
    id integer NOT NULL,
    project_id integer NOT NULL,
    git_url text NOT NULL,
    ssh_key_id integer NOT NULL,
    name character varying(255),
    git_branch character varying(255) DEFAULT ''::character varying NOT NULL
);


ALTER TABLE public.project__repository OWNER TO valknar;

--
-- Name: project__repository_id_seq; Type: SEQUENCE; Schema: public; Owner: valknar
--

CREATE SEQUENCE public.project__repository_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.project__repository_id_seq OWNER TO valknar;

--
-- Name: project__repository_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: valknar
--

ALTER SEQUENCE public.project__repository_id_seq OWNED BY public.project__repository.id;


--
-- Name: project__schedule; Type: TABLE; Schema: public; Owner: valknar
--

CREATE TABLE public.project__schedule (
    id integer CONSTRAINT project__schedule_id_not_null1 NOT NULL,
    template_id integer NOT NULL,
    project_id integer CONSTRAINT project__schedule_project_id_not_null1 NOT NULL,
    cron_format character varying(255) CONSTRAINT project__schedule_cron_format_not_null1 NOT NULL,
    repository_id integer,
    last_commit_hash character varying(64),
    name character varying(100) DEFAULT ''::character varying NOT NULL,
    active boolean DEFAULT true NOT NULL,
    task_params_id integer
);


ALTER TABLE public.project__schedule OWNER TO valknar;

--
-- Name: project__schedule_id_seq1; Type: SEQUENCE; Schema: public; Owner: valknar
--

CREATE SEQUENCE public.project__schedule_id_seq1
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.project__schedule_id_seq1 OWNER TO valknar;

--
-- Name: project__schedule_id_seq1; Type: SEQUENCE OWNED BY; Schema: public; Owner: valknar
--

ALTER SEQUENCE public.project__schedule_id_seq1 OWNED BY public.project__schedule.id;


--
-- Name: project__secret_storage; Type: TABLE; Schema: public; Owner: valknar
--

CREATE TABLE public.project__secret_storage (
    id integer NOT NULL,
    project_id integer NOT NULL,
    name character varying(100) NOT NULL,
    type character varying(20) NOT NULL,
    params text,
    readonly boolean DEFAULT false NOT NULL
);


ALTER TABLE public.project__secret_storage OWNER TO valknar;

--
-- Name: project__secret_storage_id_seq; Type: SEQUENCE; Schema: public; Owner: valknar
--

CREATE SEQUENCE public.project__secret_storage_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.project__secret_storage_id_seq OWNER TO valknar;

--
-- Name: project__secret_storage_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: valknar
--

ALTER SEQUENCE public.project__secret_storage_id_seq OWNED BY public.project__secret_storage.id;


--
-- Name: project__task_params; Type: TABLE; Schema: public; Owner: valknar
--

CREATE TABLE public.project__task_params (
    id integer NOT NULL,
    environment text,
    project_id integer NOT NULL,
    arguments text,
    inventory_id integer,
    git_branch character varying(255),
    params text,
    version character varying(20),
    message character varying(250)
);


ALTER TABLE public.project__task_params OWNER TO valknar;

--
-- Name: project__task_params_id_seq; Type: SEQUENCE; Schema: public; Owner: valknar
--

CREATE SEQUENCE public.project__task_params_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.project__task_params_id_seq OWNER TO valknar;

--
-- Name: project__task_params_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: valknar
--

ALTER SEQUENCE public.project__task_params_id_seq OWNED BY public.project__task_params.id;


--
-- Name: project__template; Type: TABLE; Schema: public; Owner: valknar
--

CREATE TABLE public.project__template (
    id integer NOT NULL,
    project_id integer NOT NULL,
    inventory_id integer,
    repository_id integer NOT NULL,
    environment_id integer,
    playbook character varying(255) NOT NULL,
    arguments text,
    name character varying(100) CONSTRAINT project__template_alias_not_null NOT NULL,
    description text,
    type character varying(10) DEFAULT ''::character varying NOT NULL,
    start_version character varying(20),
    build_template_id integer,
    view_id integer,
    survey_vars text,
    autorun boolean DEFAULT false,
    allow_override_args_in_task boolean DEFAULT false NOT NULL,
    suppress_success_alerts boolean DEFAULT false NOT NULL,
    app character varying(50) DEFAULT ''::character varying NOT NULL,
    tasks integer DEFAULT 0 NOT NULL,
    git_branch character varying(255),
    task_params text,
    runner_tag character varying(50),
    allow_override_branch_in_task boolean DEFAULT false NOT NULL,
    allow_parallel_tasks boolean DEFAULT false NOT NULL
);


ALTER TABLE public.project__template OWNER TO valknar;

--
-- Name: project__template_id_seq; Type: SEQUENCE; Schema: public; Owner: valknar
--

CREATE SEQUENCE public.project__template_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.project__template_id_seq OWNER TO valknar;

--
-- Name: project__template_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: valknar
--

ALTER SEQUENCE public.project__template_id_seq OWNED BY public.project__template.id;


--
-- Name: project__template_vault; Type: TABLE; Schema: public; Owner: valknar
--

CREATE TABLE public.project__template_vault (
    id integer NOT NULL,
    project_id integer NOT NULL,
    template_id integer NOT NULL,
    vault_key_id integer,
    name character varying(255),
    type character varying(20) DEFAULT 'password'::character varying NOT NULL,
    script text
);


ALTER TABLE public.project__template_vault OWNER TO valknar;

--
-- Name: project__template_vault_id_seq; Type: SEQUENCE; Schema: public; Owner: valknar
--

CREATE SEQUENCE public.project__template_vault_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.project__template_vault_id_seq OWNER TO valknar;

--
-- Name: project__template_vault_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: valknar
--

ALTER SEQUENCE public.project__template_vault_id_seq OWNED BY public.project__template_vault.id;


--
-- Name: project__terraform_inventory_alias; Type: TABLE; Schema: public; Owner: valknar
--

CREATE TABLE public.project__terraform_inventory_alias (
    alias character varying(100) NOT NULL,
    project_id integer NOT NULL,
    inventory_id integer NOT NULL,
    auth_key_id integer NOT NULL
);


ALTER TABLE public.project__terraform_inventory_alias OWNER TO valknar;

--
-- Name: project__terraform_inventory_state; Type: TABLE; Schema: public; Owner: valknar
--

CREATE TABLE public.project__terraform_inventory_state (
    id integer NOT NULL,
    project_id integer NOT NULL,
    inventory_id integer NOT NULL,
    state text NOT NULL,
    created timestamp without time zone NOT NULL,
    task_id integer
);


ALTER TABLE public.project__terraform_inventory_state OWNER TO valknar;

--
-- Name: project__terraform_inventory_state_id_seq; Type: SEQUENCE; Schema: public; Owner: valknar
--

CREATE SEQUENCE public.project__terraform_inventory_state_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.project__terraform_inventory_state_id_seq OWNER TO valknar;

--
-- Name: project__terraform_inventory_state_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: valknar
--

ALTER SEQUENCE public.project__terraform_inventory_state_id_seq OWNED BY public.project__terraform_inventory_state.id;


--
-- Name: project__user; Type: TABLE; Schema: public; Owner: valknar
--

CREATE TABLE public.project__user (
    project_id integer NOT NULL,
    user_id integer NOT NULL,
    role character varying(50) DEFAULT 'manager'::character varying NOT NULL
);


ALTER TABLE public.project__user OWNER TO valknar;

--
-- Name: project__view; Type: TABLE; Schema: public; Owner: valknar
--

CREATE TABLE public.project__view (
    id integer NOT NULL,
    title character varying(100) NOT NULL,
    project_id integer NOT NULL,
    "position" integer NOT NULL
);


ALTER TABLE public.project__view OWNER TO valknar;

--
-- Name: project__view_id_seq; Type: SEQUENCE; Schema: public; Owner: valknar
--

CREATE SEQUENCE public.project__view_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.project__view_id_seq OWNER TO valknar;

--
-- Name: project__view_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: valknar
--

ALTER SEQUENCE public.project__view_id_seq OWNED BY public.project__view.id;


--
-- Name: project_id_seq; Type: SEQUENCE; Schema: public; Owner: valknar
--

CREATE SEQUENCE public.project_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.project_id_seq OWNER TO valknar;

--
-- Name: project_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: valknar
--

ALTER SEQUENCE public.project_id_seq OWNED BY public.project.id;


--
-- Name: runner; Type: TABLE; Schema: public; Owner: valknar
--

CREATE TABLE public.runner (
    id integer NOT NULL,
    project_id integer,
    token character varying(255) NOT NULL,
    webhook character varying(1000) DEFAULT ''::character varying NOT NULL,
    max_parallel_tasks integer DEFAULT 0 NOT NULL,
    name character varying(100) DEFAULT ''::character varying NOT NULL,
    active boolean DEFAULT true NOT NULL,
    public_key text,
    tag character varying(200) DEFAULT ''::character varying NOT NULL,
    touched timestamp without time zone,
    cleaning_requested timestamp without time zone
);


ALTER TABLE public.runner OWNER TO valknar;

--
-- Name: runner_id_seq; Type: SEQUENCE; Schema: public; Owner: valknar
--

CREATE SEQUENCE public.runner_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.runner_id_seq OWNER TO valknar;

--
-- Name: runner_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: valknar
--

ALTER SEQUENCE public.runner_id_seq OWNED BY public.runner.id;


--
-- Name: session; Type: TABLE; Schema: public; Owner: valknar
--

CREATE TABLE public.session (
    id integer CONSTRAINT session_id_not_null1 NOT NULL,
    user_id integer CONSTRAINT session_user_id_not_null1 NOT NULL,
    created timestamp without time zone CONSTRAINT session_created_not_null1 NOT NULL,
    last_active timestamp without time zone CONSTRAINT session_last_active_not_null1 NOT NULL,
    ip character varying(39) DEFAULT ''::character varying CONSTRAINT session_ip_not_null1 NOT NULL,
    user_agent text CONSTRAINT session_user_agent_not_null1 NOT NULL,
    expired boolean DEFAULT false CONSTRAINT session_expired_not_null1 NOT NULL,
    verification_method integer DEFAULT 0 NOT NULL,
    verified boolean DEFAULT false NOT NULL
);


ALTER TABLE public.session OWNER TO valknar;

--
-- Name: session_id_seq1; Type: SEQUENCE; Schema: public; Owner: valknar
--

CREATE SEQUENCE public.session_id_seq1
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.session_id_seq1 OWNER TO valknar;

--
-- Name: session_id_seq1; Type: SEQUENCE OWNED BY; Schema: public; Owner: valknar
--

ALTER SEQUENCE public.session_id_seq1 OWNED BY public.session.id;


--
-- Name: task; Type: TABLE; Schema: public; Owner: valknar
--

CREATE TABLE public.task (
    id integer NOT NULL,
    template_id integer NOT NULL,
    status character varying(255) NOT NULL,
    playbook character varying(255) NOT NULL,
    environment text,
    created timestamp without time zone,
    start timestamp without time zone,
    "end" timestamp without time zone,
    user_id integer,
    project_id integer,
    message character varying(250) DEFAULT ''::character varying NOT NULL,
    version character varying(20),
    commit_hash character varying(64),
    commit_message character varying(100) DEFAULT ''::character varying NOT NULL,
    build_task_id integer,
    arguments text,
    inventory_id integer,
    integration_id integer,
    schedule_id integer,
    git_branch character varying(255),
    params text
);


ALTER TABLE public.task OWNER TO valknar;

--
-- Name: task__ansible_error; Type: TABLE; Schema: public; Owner: valknar
--

CREATE TABLE public.task__ansible_error (
    id integer NOT NULL,
    task_id integer NOT NULL,
    project_id integer NOT NULL,
    task character varying(250) NOT NULL,
    error character varying(1000) NOT NULL,
    host character varying(250)
);


ALTER TABLE public.task__ansible_error OWNER TO valknar;

--
-- Name: task__ansible_error_id_seq; Type: SEQUENCE; Schema: public; Owner: valknar
--

CREATE SEQUENCE public.task__ansible_error_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.task__ansible_error_id_seq OWNER TO valknar;

--
-- Name: task__ansible_error_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: valknar
--

ALTER SEQUENCE public.task__ansible_error_id_seq OWNED BY public.task__ansible_error.id;


--
-- Name: task__ansible_host; Type: TABLE; Schema: public; Owner: valknar
--

CREATE TABLE public.task__ansible_host (
    id integer NOT NULL,
    task_id integer NOT NULL,
    project_id integer NOT NULL,
    host character varying(250) NOT NULL,
    failed integer NOT NULL,
    ignored integer NOT NULL,
    changed integer NOT NULL,
    ok integer NOT NULL,
    rescued integer NOT NULL,
    skipped integer NOT NULL,
    unreachable integer NOT NULL
);


ALTER TABLE public.task__ansible_host OWNER TO valknar;

--
-- Name: task__ansible_host_id_seq; Type: SEQUENCE; Schema: public; Owner: valknar
--

CREATE SEQUENCE public.task__ansible_host_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.task__ansible_host_id_seq OWNER TO valknar;

--
-- Name: task__ansible_host_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: valknar
--

ALTER SEQUENCE public.task__ansible_host_id_seq OWNED BY public.task__ansible_host.id;


--
-- Name: task__output; Type: TABLE; Schema: public; Owner: valknar
--

CREATE TABLE public.task__output (
    id bigint NOT NULL,
    task_id integer CONSTRAINT task__output_task_id_not_null1 NOT NULL,
    "time" timestamp without time zone CONSTRAINT task__output_time_not_null1 NOT NULL,
    output text CONSTRAINT task__output_output_not_null1 NOT NULL
);


ALTER TABLE public.task__output OWNER TO valknar;

--
-- Name: task__output_id_seq; Type: SEQUENCE; Schema: public; Owner: valknar
--

CREATE SEQUENCE public.task__output_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.task__output_id_seq OWNER TO valknar;

--
-- Name: task__output_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: valknar
--

ALTER SEQUENCE public.task__output_id_seq OWNED BY public.task__output.id;


--
-- Name: task__stage; Type: TABLE; Schema: public; Owner: valknar
--

CREATE TABLE public.task__stage (
    id integer NOT NULL,
    task_id integer NOT NULL,
    start timestamp without time zone,
    start_output_id bigint,
    "end" timestamp without time zone,
    end_output_id bigint,
    type character varying(100)
);


ALTER TABLE public.task__stage OWNER TO valknar;

--
-- Name: task__stage_id_seq; Type: SEQUENCE; Schema: public; Owner: valknar
--

CREATE SEQUENCE public.task__stage_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.task__stage_id_seq OWNER TO valknar;

--
-- Name: task__stage_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: valknar
--

ALTER SEQUENCE public.task__stage_id_seq OWNED BY public.task__stage.id;


--
-- Name: task__stage_result; Type: TABLE; Schema: public; Owner: valknar
--

CREATE TABLE public.task__stage_result (
    id integer NOT NULL,
    task_id integer NOT NULL,
    stage_id integer NOT NULL,
    "json" text
);


ALTER TABLE public.task__stage_result OWNER TO valknar;

--
-- Name: task__stage_result_id_seq; Type: SEQUENCE; Schema: public; Owner: valknar
--

CREATE SEQUENCE public.task__stage_result_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.task__stage_result_id_seq OWNER TO valknar;

--
-- Name: task__stage_result_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: valknar
--

ALTER SEQUENCE public.task__stage_result_id_seq OWNED BY public.task__stage_result.id;


--
-- Name: task_id_seq; Type: SEQUENCE; Schema: public; Owner: valknar
--

CREATE SEQUENCE public.task_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.task_id_seq OWNER TO valknar;

--
-- Name: task_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: valknar
--

ALTER SEQUENCE public.task_id_seq OWNED BY public.task.id;


--
-- Name: user; Type: TABLE; Schema: public; Owner: valknar
--

CREATE TABLE public."user" (
    id integer NOT NULL,
    created timestamp without time zone NOT NULL,
    username character varying(255) NOT NULL,
    name character varying(255) NOT NULL,
    email character varying(255) NOT NULL,
    password character varying(255) NOT NULL,
    alert boolean DEFAULT false NOT NULL,
    external boolean DEFAULT false NOT NULL,
    admin boolean DEFAULT true NOT NULL,
    pro boolean DEFAULT false NOT NULL
);


ALTER TABLE public."user" OWNER TO valknar;

--
-- Name: user__email_otp; Type: TABLE; Schema: public; Owner: valknar
--

CREATE TABLE public.user__email_otp (
    id integer NOT NULL,
    user_id integer NOT NULL,
    code character varying(250) NOT NULL,
    created timestamp without time zone NOT NULL
);


ALTER TABLE public.user__email_otp OWNER TO valknar;

--
-- Name: user__email_otp_id_seq; Type: SEQUENCE; Schema: public; Owner: valknar
--

CREATE SEQUENCE public.user__email_otp_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.user__email_otp_id_seq OWNER TO valknar;

--
-- Name: user__email_otp_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: valknar
--

ALTER SEQUENCE public.user__email_otp_id_seq OWNED BY public.user__email_otp.id;


--
-- Name: user__token; Type: TABLE; Schema: public; Owner: valknar
--

CREATE TABLE public.user__token (
    id character varying(44) CONSTRAINT user__token_id_not_null1 NOT NULL,
    created timestamp without time zone CONSTRAINT user__token_created_not_null1 NOT NULL,
    expired boolean DEFAULT false CONSTRAINT user__token_expired_not_null1 NOT NULL,
    user_id integer CONSTRAINT user__token_user_id_not_null1 NOT NULL
);


ALTER TABLE public.user__token OWNER TO valknar;

--
-- Name: user__totp; Type: TABLE; Schema: public; Owner: valknar
--

CREATE TABLE public.user__totp (
    id integer NOT NULL,
    user_id integer NOT NULL,
    url character varying(250) NOT NULL,
    recovery_hash character varying(250) NOT NULL,
    created timestamp without time zone NOT NULL
);


ALTER TABLE public.user__totp OWNER TO valknar;

--
-- Name: user__totp_id_seq; Type: SEQUENCE; Schema: public; Owner: valknar
--

CREATE SEQUENCE public.user__totp_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.user__totp_id_seq OWNER TO valknar;

--
-- Name: user__totp_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: valknar
--

ALTER SEQUENCE public.user__totp_id_seq OWNED BY public.user__totp.id;


--
-- Name: user_id_seq; Type: SEQUENCE; Schema: public; Owner: valknar
--

CREATE SEQUENCE public.user_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.user_id_seq OWNER TO valknar;

--
-- Name: user_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: valknar
--

ALTER SEQUENCE public.user_id_seq OWNED BY public."user".id;


--
-- Name: access_key id; Type: DEFAULT; Schema: public; Owner: valknar
--

ALTER TABLE ONLY public.access_key ALTER COLUMN id SET DEFAULT nextval('public.access_key_id_seq'::regclass);


--
-- Name: event id; Type: DEFAULT; Schema: public; Owner: valknar
--

ALTER TABLE ONLY public.event ALTER COLUMN id SET DEFAULT nextval('public.event_id_seq'::regclass);


--
-- Name: project id; Type: DEFAULT; Schema: public; Owner: valknar
--

ALTER TABLE ONLY public.project ALTER COLUMN id SET DEFAULT nextval('public.project_id_seq'::regclass);


--
-- Name: project__environment id; Type: DEFAULT; Schema: public; Owner: valknar
--

ALTER TABLE ONLY public.project__environment ALTER COLUMN id SET DEFAULT nextval('public.project__environment_id_seq'::regclass);


--
-- Name: project__integration id; Type: DEFAULT; Schema: public; Owner: valknar
--

ALTER TABLE ONLY public.project__integration ALTER COLUMN id SET DEFAULT nextval('public.project__integration_id_seq'::regclass);


--
-- Name: project__integration_alias id; Type: DEFAULT; Schema: public; Owner: valknar
--

ALTER TABLE ONLY public.project__integration_alias ALTER COLUMN id SET DEFAULT nextval('public.project__integration_alias_id_seq'::regclass);


--
-- Name: project__integration_extract_value id; Type: DEFAULT; Schema: public; Owner: valknar
--

ALTER TABLE ONLY public.project__integration_extract_value ALTER COLUMN id SET DEFAULT nextval('public.project__integration_extract_value_id_seq'::regclass);


--
-- Name: project__integration_matcher id; Type: DEFAULT; Schema: public; Owner: valknar
--

ALTER TABLE ONLY public.project__integration_matcher ALTER COLUMN id SET DEFAULT nextval('public.project__integration_matcher_id_seq'::regclass);


--
-- Name: project__inventory id; Type: DEFAULT; Schema: public; Owner: valknar
--

ALTER TABLE ONLY public.project__inventory ALTER COLUMN id SET DEFAULT nextval('public.project__inventory_id_seq'::regclass);


--
-- Name: project__repository id; Type: DEFAULT; Schema: public; Owner: valknar
--

ALTER TABLE ONLY public.project__repository ALTER COLUMN id SET DEFAULT nextval('public.project__repository_id_seq'::regclass);


--
-- Name: project__schedule id; Type: DEFAULT; Schema: public; Owner: valknar
--

ALTER TABLE ONLY public.project__schedule ALTER COLUMN id SET DEFAULT nextval('public.project__schedule_id_seq1'::regclass);


--
-- Name: project__secret_storage id; Type: DEFAULT; Schema: public; Owner: valknar
--

ALTER TABLE ONLY public.project__secret_storage ALTER COLUMN id SET DEFAULT nextval('public.project__secret_storage_id_seq'::regclass);


--
-- Name: project__task_params id; Type: DEFAULT; Schema: public; Owner: valknar
--

ALTER TABLE ONLY public.project__task_params ALTER COLUMN id SET DEFAULT nextval('public.project__task_params_id_seq'::regclass);


--
-- Name: project__template id; Type: DEFAULT; Schema: public; Owner: valknar
--

ALTER TABLE ONLY public.project__template ALTER COLUMN id SET DEFAULT nextval('public.project__template_id_seq'::regclass);


--
-- Name: project__template_vault id; Type: DEFAULT; Schema: public; Owner: valknar
--

ALTER TABLE ONLY public.project__template_vault ALTER COLUMN id SET DEFAULT nextval('public.project__template_vault_id_seq'::regclass);


--
-- Name: project__terraform_inventory_state id; Type: DEFAULT; Schema: public; Owner: valknar
--

ALTER TABLE ONLY public.project__terraform_inventory_state ALTER COLUMN id SET DEFAULT nextval('public.project__terraform_inventory_state_id_seq'::regclass);


--
-- Name: project__view id; Type: DEFAULT; Schema: public; Owner: valknar
--

ALTER TABLE ONLY public.project__view ALTER COLUMN id SET DEFAULT nextval('public.project__view_id_seq'::regclass);


--
-- Name: runner id; Type: DEFAULT; Schema: public; Owner: valknar
--

ALTER TABLE ONLY public.runner ALTER COLUMN id SET DEFAULT nextval('public.runner_id_seq'::regclass);


--
-- Name: session id; Type: DEFAULT; Schema: public; Owner: valknar
--

ALTER TABLE ONLY public.session ALTER COLUMN id SET DEFAULT nextval('public.session_id_seq1'::regclass);


--
-- Name: task id; Type: DEFAULT; Schema: public; Owner: valknar
--

ALTER TABLE ONLY public.task ALTER COLUMN id SET DEFAULT nextval('public.task_id_seq'::regclass);


--
-- Name: task__ansible_error id; Type: DEFAULT; Schema: public; Owner: valknar
--

ALTER TABLE ONLY public.task__ansible_error ALTER COLUMN id SET DEFAULT nextval('public.task__ansible_error_id_seq'::regclass);


--
-- Name: task__ansible_host id; Type: DEFAULT; Schema: public; Owner: valknar
--

ALTER TABLE ONLY public.task__ansible_host ALTER COLUMN id SET DEFAULT nextval('public.task__ansible_host_id_seq'::regclass);


--
-- Name: task__output id; Type: DEFAULT; Schema: public; Owner: valknar
--

ALTER TABLE ONLY public.task__output ALTER COLUMN id SET DEFAULT nextval('public.task__output_id_seq'::regclass);


--
-- Name: task__stage id; Type: DEFAULT; Schema: public; Owner: valknar
--

ALTER TABLE ONLY public.task__stage ALTER COLUMN id SET DEFAULT nextval('public.task__stage_id_seq'::regclass);


--
-- Name: task__stage_result id; Type: DEFAULT; Schema: public; Owner: valknar
--

ALTER TABLE ONLY public.task__stage_result ALTER COLUMN id SET DEFAULT nextval('public.task__stage_result_id_seq'::regclass);


--
-- Name: user id; Type: DEFAULT; Schema: public; Owner: valknar
--

ALTER TABLE ONLY public."user" ALTER COLUMN id SET DEFAULT nextval('public.user_id_seq'::regclass);


--
-- Name: user__email_otp id; Type: DEFAULT; Schema: public; Owner: valknar
--

ALTER TABLE ONLY public.user__email_otp ALTER COLUMN id SET DEFAULT nextval('public.user__email_otp_id_seq'::regclass);


--
-- Name: user__totp id; Type: DEFAULT; Schema: public; Owner: valknar
--

ALTER TABLE ONLY public.user__totp ALTER COLUMN id SET DEFAULT nextval('public.user__totp_id_seq'::regclass);


--
-- Data for Name: access_key; Type: TABLE DATA; Schema: public; Owner: valknar
--

COPY public.access_key (id, name, type, project_id, secret, environment_id, user_id, owner, plain, storage_id, source_storage_id, source_storage_key) FROM stdin;
\.


--
-- Data for Name: event; Type: TABLE DATA; Schema: public; Owner: valknar
--

COPY public.event (id, project_id, object_id, object_type, description, created, user_id) FROM stdin;
\.


--
-- Data for Name: event_backup_5784568; Type: TABLE DATA; Schema: public; Owner: valknar
--

COPY public.event_backup_5784568 (project_id, object_id, object_type, description, created, user_id) FROM stdin;
\.


--
-- Data for Name: migrations; Type: TABLE DATA; Schema: public; Owner: valknar
--

COPY public.migrations (version, upgraded_date, notes) FROM stdin;
0.0.0	2025-10-07 17:38:00.948158	\N
1.0.0	2025-10-07 17:38:00.951471	\N
1.2.0	2025-10-07 17:38:00.953004	\N
1.3.0	2025-10-07 17:38:00.954388	\N
1.4.0	2025-10-07 17:38:00.956144	\N
1.5.0	2025-10-07 17:38:00.958394	\N
1.6.0	2025-10-07 17:38:00.960132	\N
1.7.0	2025-10-07 17:38:00.961111	\N
1.8.0	2025-10-07 17:38:00.962086	\N
1.9.0	2025-10-07 17:38:00.962981	\N
2.2.1	2025-10-07 17:38:00.965999	\N
2.3.0	2025-10-07 17:38:00.968778	\N
2.3.1	2025-10-07 17:38:00.972588	\N
2.3.2	2025-10-07 17:38:00.975928	\N
2.4.0	2025-10-07 17:38:00.977338	\N
2.5.0	2025-10-07 17:38:00.978661	\N
2.5.2	2025-10-07 17:38:00.979979	\N
2.7.1	2025-10-07 17:38:00.981324	\N
2.7.4	2025-10-07 17:38:00.982651	\N
2.7.6	2025-10-07 17:38:00.984186	\N
2.7.8	2025-10-07 17:38:00.986866	\N
2.7.9	2025-10-07 17:38:00.988925	\N
2.7.10	2025-10-07 17:38:00.990152	\N
2.7.12	2025-10-07 17:38:00.991791	\N
2.7.13	2025-10-07 17:38:00.994643	\N
2.8.0	2025-10-07 17:38:00.997812	\N
2.8.1	2025-10-07 17:38:00.999417	\N
2.8.7	2025-10-07 17:38:01.000969	\N
2.8.8	2025-10-07 17:38:01.00403	\N
2.8.20	2025-10-07 17:38:01.0074	\N
2.8.25	2025-10-07 17:38:01.009612	\N
2.8.26	2025-10-07 17:38:01.011356	\N
2.8.36	2025-10-07 17:38:01.013273	\N
2.8.38	2025-10-07 17:38:01.018535	\N
2.8.39	2025-10-07 17:38:01.021912	\N
2.8.40	2025-10-07 17:38:01.024093	\N
2.8.42	2025-10-07 17:38:01.025171	\N
2.8.51	2025-10-07 17:38:01.026541	\N
2.8.57	2025-10-07 17:38:01.027804	\N
2.8.58	2025-10-07 17:38:01.028859	\N
2.8.91	2025-10-07 17:38:01.030151	\N
2.9.6	2025-10-07 17:38:01.031962	\N
2.9.46	2025-10-07 17:38:01.033537	\N
2.9.60	2025-10-07 17:38:01.03941	\N
2.9.61	2025-10-07 17:38:01.047411	\N
2.9.62	2025-10-07 17:38:01.051244	\N
2.9.70	2025-10-07 17:38:01.053277	\N
2.9.97	2025-10-07 17:38:01.05494	\N
2.9.100	2025-10-07 17:38:01.056489	\N
2.10.12	2025-10-07 17:38:01.05842	\N
2.10.15	2025-10-07 17:38:01.060695	\N
2.10.16	2025-10-07 17:38:01.06302	\N
2.10.24	2025-10-07 17:38:01.066567	\N
2.10.26	2025-10-07 17:38:01.068454	\N
2.10.28	2025-10-07 17:38:01.070129	\N
2.10.33	2025-10-07 17:38:01.073411	\N
2.10.46	2025-10-07 17:38:01.075164	\N
2.11.5	2025-10-07 17:38:01.079358	\N
2.12.0	2025-10-07 17:38:01.084133	\N
2.12.3	2025-10-07 17:38:01.086943	\N
2.12.4	2025-10-07 17:38:01.089015	\N
2.12.5	2025-10-07 17:38:01.090371	\N
2.12.15	2025-10-07 17:38:01.092009	\N
2.13.0	2025-10-07 17:38:01.093683	\N
2.14.0	2025-10-07 17:38:01.096429	\N
2.14.1	2025-10-07 17:38:01.098116	\N
2.14.5	2025-10-07 17:38:01.100036	\N
2.14.7	2025-10-07 17:38:01.101508	\N
2.14.12	2025-10-07 17:38:01.102838	\N
2.15.0	2025-10-07 17:38:01.106864	\N
2.15.1	2025-10-07 17:38:01.108626	\N
2.15.2	2025-10-07 17:38:01.111172	\N
2.15.3	2025-10-07 17:38:01.115813	\N
2.15.4	2025-10-07 17:38:01.11719	\N
2.16.0	2025-10-07 17:38:01.122039	\N
2.16.1	2025-10-07 17:38:01.123349	\N
2.16.2	2025-10-07 17:38:01.126531	\N
\.


--
-- Data for Name: option; Type: TABLE DATA; Schema: public; Owner: valknar
--

COPY public.option (key, value) FROM stdin;
\.


--
-- Data for Name: project; Type: TABLE DATA; Schema: public; Owner: valknar
--

COPY public.project (id, created, name, alert, alert_chat, max_parallel_tasks, type, default_secret_storage_id) FROM stdin;
\.


--
-- Data for Name: project__environment; Type: TABLE DATA; Schema: public; Owner: valknar
--

COPY public.project__environment (id, project_id, password, "json", name, env, secret_storage_id, secret_storage_key_prefix) FROM stdin;
\.


--
-- Data for Name: project__integration; Type: TABLE DATA; Schema: public; Owner: valknar
--

COPY public.project__integration (id, name, project_id, template_id, auth_method, auth_secret_id, auth_header, searchable, task_params_id) FROM stdin;
\.


--
-- Data for Name: project__integration_alias; Type: TABLE DATA; Schema: public; Owner: valknar
--

COPY public.project__integration_alias (id, alias, project_id, integration_id) FROM stdin;
\.


--
-- Data for Name: project__integration_extract_value; Type: TABLE DATA; Schema: public; Owner: valknar
--

COPY public.project__integration_extract_value (id, name, integration_id, value_source, body_data_type, key, variable, variable_type) FROM stdin;
\.


--
-- Data for Name: project__integration_matcher; Type: TABLE DATA; Schema: public; Owner: valknar
--

COPY public.project__integration_matcher (id, name, integration_id, match_type, method, body_data_type, key, value) FROM stdin;
\.


--
-- Data for Name: project__inventory; Type: TABLE DATA; Schema: public; Owner: valknar
--

COPY public.project__inventory (id, project_id, type, inventory, ssh_key_id, name, become_key_id, template_id, repository_id, runner_tag) FROM stdin;
\.


--
-- Data for Name: project__repository; Type: TABLE DATA; Schema: public; Owner: valknar
--

COPY public.project__repository (id, project_id, git_url, ssh_key_id, name, git_branch) FROM stdin;
\.


--
-- Data for Name: project__schedule; Type: TABLE DATA; Schema: public; Owner: valknar
--

COPY public.project__schedule (id, template_id, project_id, cron_format, repository_id, last_commit_hash, name, active, task_params_id) FROM stdin;
\.


--
-- Data for Name: project__secret_storage; Type: TABLE DATA; Schema: public; Owner: valknar
--

COPY public.project__secret_storage (id, project_id, name, type, params, readonly) FROM stdin;
\.


--
-- Data for Name: project__task_params; Type: TABLE DATA; Schema: public; Owner: valknar
--

COPY public.project__task_params (id, environment, project_id, arguments, inventory_id, git_branch, params, version, message) FROM stdin;
\.


--
-- Data for Name: project__template; Type: TABLE DATA; Schema: public; Owner: valknar
--

COPY public.project__template (id, project_id, inventory_id, repository_id, environment_id, playbook, arguments, name, description, type, start_version, build_template_id, view_id, survey_vars, autorun, allow_override_args_in_task, suppress_success_alerts, app, tasks, git_branch, task_params, runner_tag, allow_override_branch_in_task, allow_parallel_tasks) FROM stdin;
\.


--
-- Data for Name: project__template_vault; Type: TABLE DATA; Schema: public; Owner: valknar
--

COPY public.project__template_vault (id, project_id, template_id, vault_key_id, name, type, script) FROM stdin;
\.


--
-- Data for Name: project__terraform_inventory_alias; Type: TABLE DATA; Schema: public; Owner: valknar
--

COPY public.project__terraform_inventory_alias (alias, project_id, inventory_id, auth_key_id) FROM stdin;
\.


--
-- Data for Name: project__terraform_inventory_state; Type: TABLE DATA; Schema: public; Owner: valknar
--

COPY public.project__terraform_inventory_state (id, project_id, inventory_id, state, created, task_id) FROM stdin;
\.


--
-- Data for Name: project__user; Type: TABLE DATA; Schema: public; Owner: valknar
--

COPY public.project__user (project_id, user_id, role) FROM stdin;
\.


--
-- Data for Name: project__view; Type: TABLE DATA; Schema: public; Owner: valknar
--

COPY public.project__view (id, title, project_id, "position") FROM stdin;
\.


--
-- Data for Name: runner; Type: TABLE DATA; Schema: public; Owner: valknar
--

COPY public.runner (id, project_id, token, webhook, max_parallel_tasks, name, active, public_key, tag, touched, cleaning_requested) FROM stdin;
\.


--
-- Data for Name: session; Type: TABLE DATA; Schema: public; Owner: valknar
--

COPY public.session (id, user_id, created, last_active, ip, user_agent, expired, verification_method, verified) FROM stdin;
\.


--
-- Data for Name: task; Type: TABLE DATA; Schema: public; Owner: valknar
--

COPY public.task (id, template_id, status, playbook, environment, created, start, "end", user_id, project_id, message, version, commit_hash, commit_message, build_task_id, arguments, inventory_id, integration_id, schedule_id, git_branch, params) FROM stdin;
\.


--
-- Data for Name: task__ansible_error; Type: TABLE DATA; Schema: public; Owner: valknar
--

COPY public.task__ansible_error (id, task_id, project_id, task, error, host) FROM stdin;
\.


--
-- Data for Name: task__ansible_host; Type: TABLE DATA; Schema: public; Owner: valknar
--

COPY public.task__ansible_host (id, task_id, project_id, host, failed, ignored, changed, ok, rescued, skipped, unreachable) FROM stdin;
\.


--
-- Data for Name: task__output; Type: TABLE DATA; Schema: public; Owner: valknar
--

COPY public.task__output (id, task_id, "time", output) FROM stdin;
\.


--
-- Data for Name: task__stage; Type: TABLE DATA; Schema: public; Owner: valknar
--

COPY public.task__stage (id, task_id, start, start_output_id, "end", end_output_id, type) FROM stdin;
\.


--
-- Data for Name: task__stage_result; Type: TABLE DATA; Schema: public; Owner: valknar
--

COPY public.task__stage_result (id, task_id, stage_id, "json") FROM stdin;
\.


--
-- Data for Name: user; Type: TABLE DATA; Schema: public; Owner: valknar
--

COPY public."user" (id, created, username, name, email, password, alert, external, admin, pro) FROM stdin;
1	2025-10-07 17:38:01	admin	Admin	valknar@pivoine.art	$2a$11$V121rhO47bQ3MNf98JBayeJ.QDJon2XcvVsgoqU5XXRgHKmcwqPfW	f	f	t	f
\.


--
-- Data for Name: user__email_otp; Type: TABLE DATA; Schema: public; Owner: valknar
--

COPY public.user__email_otp (id, user_id, code, created) FROM stdin;
\.


--
-- Data for Name: user__token; Type: TABLE DATA; Schema: public; Owner: valknar
--

COPY public.user__token (id, created, expired, user_id) FROM stdin;
\.


--
-- Data for Name: user__totp; Type: TABLE DATA; Schema: public; Owner: valknar
--

COPY public.user__totp (id, user_id, url, recovery_hash, created) FROM stdin;
\.


--
-- Name: access_key_id_seq; Type: SEQUENCE SET; Schema: public; Owner: valknar
--

SELECT pg_catalog.setval('public.access_key_id_seq', 1, false);


--
-- Name: event_id_seq; Type: SEQUENCE SET; Schema: public; Owner: valknar
--

SELECT pg_catalog.setval('public.event_id_seq', 1, false);


--
-- Name: project__environment_id_seq; Type: SEQUENCE SET; Schema: public; Owner: valknar
--

SELECT pg_catalog.setval('public.project__environment_id_seq', 1, false);


--
-- Name: project__integration_alias_id_seq; Type: SEQUENCE SET; Schema: public; Owner: valknar
--

SELECT pg_catalog.setval('public.project__integration_alias_id_seq', 1, false);


--
-- Name: project__integration_extract_value_id_seq; Type: SEQUENCE SET; Schema: public; Owner: valknar
--

SELECT pg_catalog.setval('public.project__integration_extract_value_id_seq', 1, false);


--
-- Name: project__integration_id_seq; Type: SEQUENCE SET; Schema: public; Owner: valknar
--

SELECT pg_catalog.setval('public.project__integration_id_seq', 1, false);


--
-- Name: project__integration_matcher_id_seq; Type: SEQUENCE SET; Schema: public; Owner: valknar
--

SELECT pg_catalog.setval('public.project__integration_matcher_id_seq', 1, false);


--
-- Name: project__inventory_id_seq; Type: SEQUENCE SET; Schema: public; Owner: valknar
--

SELECT pg_catalog.setval('public.project__inventory_id_seq', 1, false);


--
-- Name: project__repository_id_seq; Type: SEQUENCE SET; Schema: public; Owner: valknar
--

SELECT pg_catalog.setval('public.project__repository_id_seq', 1, false);


--
-- Name: project__schedule_id_seq1; Type: SEQUENCE SET; Schema: public; Owner: valknar
--

SELECT pg_catalog.setval('public.project__schedule_id_seq1', 1, false);


--
-- Name: project__secret_storage_id_seq; Type: SEQUENCE SET; Schema: public; Owner: valknar
--

SELECT pg_catalog.setval('public.project__secret_storage_id_seq', 1, false);


--
-- Name: project__task_params_id_seq; Type: SEQUENCE SET; Schema: public; Owner: valknar
--

SELECT pg_catalog.setval('public.project__task_params_id_seq', 1, false);


--
-- Name: project__template_id_seq; Type: SEQUENCE SET; Schema: public; Owner: valknar
--

SELECT pg_catalog.setval('public.project__template_id_seq', 1, false);


--
-- Name: project__template_vault_id_seq; Type: SEQUENCE SET; Schema: public; Owner: valknar
--

SELECT pg_catalog.setval('public.project__template_vault_id_seq', 1, false);


--
-- Name: project__terraform_inventory_state_id_seq; Type: SEQUENCE SET; Schema: public; Owner: valknar
--

SELECT pg_catalog.setval('public.project__terraform_inventory_state_id_seq', 1, false);


--
-- Name: project__view_id_seq; Type: SEQUENCE SET; Schema: public; Owner: valknar
--

SELECT pg_catalog.setval('public.project__view_id_seq', 1, false);


--
-- Name: project_id_seq; Type: SEQUENCE SET; Schema: public; Owner: valknar
--

SELECT pg_catalog.setval('public.project_id_seq', 1, false);


--
-- Name: runner_id_seq; Type: SEQUENCE SET; Schema: public; Owner: valknar
--

SELECT pg_catalog.setval('public.runner_id_seq', 1, false);


--
-- Name: session_id_seq1; Type: SEQUENCE SET; Schema: public; Owner: valknar
--

SELECT pg_catalog.setval('public.session_id_seq1', 1, false);


--
-- Name: task__ansible_error_id_seq; Type: SEQUENCE SET; Schema: public; Owner: valknar
--

SELECT pg_catalog.setval('public.task__ansible_error_id_seq', 1, false);


--
-- Name: task__ansible_host_id_seq; Type: SEQUENCE SET; Schema: public; Owner: valknar
--

SELECT pg_catalog.setval('public.task__ansible_host_id_seq', 1, false);


--
-- Name: task__output_id_seq; Type: SEQUENCE SET; Schema: public; Owner: valknar
--

SELECT pg_catalog.setval('public.task__output_id_seq', 1, false);


--
-- Name: task__stage_id_seq; Type: SEQUENCE SET; Schema: public; Owner: valknar
--

SELECT pg_catalog.setval('public.task__stage_id_seq', 1, false);


--
-- Name: task__stage_result_id_seq; Type: SEQUENCE SET; Schema: public; Owner: valknar
--

SELECT pg_catalog.setval('public.task__stage_result_id_seq', 1, false);


--
-- Name: task_id_seq; Type: SEQUENCE SET; Schema: public; Owner: valknar
--

SELECT pg_catalog.setval('public.task_id_seq', 1, false);


--
-- Name: user__email_otp_id_seq; Type: SEQUENCE SET; Schema: public; Owner: valknar
--

SELECT pg_catalog.setval('public.user__email_otp_id_seq', 1, false);


--
-- Name: user__totp_id_seq; Type: SEQUENCE SET; Schema: public; Owner: valknar
--

SELECT pg_catalog.setval('public.user__totp_id_seq', 1, false);


--
-- Name: user_id_seq; Type: SEQUENCE SET; Schema: public; Owner: valknar
--

SELECT pg_catalog.setval('public.user_id_seq', 1, true);


--
-- Name: access_key access_key_pkey; Type: CONSTRAINT; Schema: public; Owner: valknar
--

ALTER TABLE ONLY public.access_key
    ADD CONSTRAINT access_key_pkey PRIMARY KEY (id);


--
-- Name: event event_pkey; Type: CONSTRAINT; Schema: public; Owner: valknar
--

ALTER TABLE ONLY public.event
    ADD CONSTRAINT event_pkey PRIMARY KEY (id);


--
-- Name: migrations migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: valknar
--

ALTER TABLE ONLY public.migrations
    ADD CONSTRAINT migrations_pkey PRIMARY KEY (version);


--
-- Name: option option_pkey; Type: CONSTRAINT; Schema: public; Owner: valknar
--

ALTER TABLE ONLY public.option
    ADD CONSTRAINT option_pkey PRIMARY KEY (key);


--
-- Name: project__environment project__environment_pkey; Type: CONSTRAINT; Schema: public; Owner: valknar
--

ALTER TABLE ONLY public.project__environment
    ADD CONSTRAINT project__environment_pkey PRIMARY KEY (id);


--
-- Name: project__integration_alias project__integration_alias_alias_key; Type: CONSTRAINT; Schema: public; Owner: valknar
--

ALTER TABLE ONLY public.project__integration_alias
    ADD CONSTRAINT project__integration_alias_alias_key UNIQUE (alias);


--
-- Name: project__integration_alias project__integration_alias_pkey; Type: CONSTRAINT; Schema: public; Owner: valknar
--

ALTER TABLE ONLY public.project__integration_alias
    ADD CONSTRAINT project__integration_alias_pkey PRIMARY KEY (id);


--
-- Name: project__integration_extract_value project__integration_extract_value_pkey; Type: CONSTRAINT; Schema: public; Owner: valknar
--

ALTER TABLE ONLY public.project__integration_extract_value
    ADD CONSTRAINT project__integration_extract_value_pkey PRIMARY KEY (id);


--
-- Name: project__integration_matcher project__integration_matcher_pkey; Type: CONSTRAINT; Schema: public; Owner: valknar
--

ALTER TABLE ONLY public.project__integration_matcher
    ADD CONSTRAINT project__integration_matcher_pkey PRIMARY KEY (id);


--
-- Name: project__integration project__integration_pkey; Type: CONSTRAINT; Schema: public; Owner: valknar
--

ALTER TABLE ONLY public.project__integration
    ADD CONSTRAINT project__integration_pkey PRIMARY KEY (id);


--
-- Name: project__inventory project__inventory_pkey; Type: CONSTRAINT; Schema: public; Owner: valknar
--

ALTER TABLE ONLY public.project__inventory
    ADD CONSTRAINT project__inventory_pkey PRIMARY KEY (id);


--
-- Name: project__repository project__repository_pkey; Type: CONSTRAINT; Schema: public; Owner: valknar
--

ALTER TABLE ONLY public.project__repository
    ADD CONSTRAINT project__repository_pkey PRIMARY KEY (id);


--
-- Name: project__schedule project__schedule_pkey1; Type: CONSTRAINT; Schema: public; Owner: valknar
--

ALTER TABLE ONLY public.project__schedule
    ADD CONSTRAINT project__schedule_pkey1 PRIMARY KEY (id);


--
-- Name: project__secret_storage project__secret_storage_pkey; Type: CONSTRAINT; Schema: public; Owner: valknar
--

ALTER TABLE ONLY public.project__secret_storage
    ADD CONSTRAINT project__secret_storage_pkey PRIMARY KEY (id);


--
-- Name: project__task_params project__task_params_pkey; Type: CONSTRAINT; Schema: public; Owner: valknar
--

ALTER TABLE ONLY public.project__task_params
    ADD CONSTRAINT project__task_params_pkey PRIMARY KEY (id);


--
-- Name: project__template project__template_pkey; Type: CONSTRAINT; Schema: public; Owner: valknar
--

ALTER TABLE ONLY public.project__template
    ADD CONSTRAINT project__template_pkey PRIMARY KEY (id);


--
-- Name: project__template_vault project__template_vault_pkey; Type: CONSTRAINT; Schema: public; Owner: valknar
--

ALTER TABLE ONLY public.project__template_vault
    ADD CONSTRAINT project__template_vault_pkey PRIMARY KEY (id);


--
-- Name: project__template_vault project__template_vault_template_id_vault_key_id_name_key; Type: CONSTRAINT; Schema: public; Owner: valknar
--

ALTER TABLE ONLY public.project__template_vault
    ADD CONSTRAINT project__template_vault_template_id_vault_key_id_name_key UNIQUE (template_id, vault_key_id, name);


--
-- Name: project__terraform_inventory_alias project__terraform_inventory_alias_pkey; Type: CONSTRAINT; Schema: public; Owner: valknar
--

ALTER TABLE ONLY public.project__terraform_inventory_alias
    ADD CONSTRAINT project__terraform_inventory_alias_pkey PRIMARY KEY (alias);


--
-- Name: project__terraform_inventory_state project__terraform_inventory_state_pkey; Type: CONSTRAINT; Schema: public; Owner: valknar
--

ALTER TABLE ONLY public.project__terraform_inventory_state
    ADD CONSTRAINT project__terraform_inventory_state_pkey PRIMARY KEY (id);


--
-- Name: project__user project__user_project_id_user_id_key; Type: CONSTRAINT; Schema: public; Owner: valknar
--

ALTER TABLE ONLY public.project__user
    ADD CONSTRAINT project__user_project_id_user_id_key UNIQUE (project_id, user_id);


--
-- Name: project__view project__view_pkey; Type: CONSTRAINT; Schema: public; Owner: valknar
--

ALTER TABLE ONLY public.project__view
    ADD CONSTRAINT project__view_pkey PRIMARY KEY (id);


--
-- Name: project project_pkey; Type: CONSTRAINT; Schema: public; Owner: valknar
--

ALTER TABLE ONLY public.project
    ADD CONSTRAINT project_pkey PRIMARY KEY (id);


--
-- Name: runner runner_pkey; Type: CONSTRAINT; Schema: public; Owner: valknar
--

ALTER TABLE ONLY public.runner
    ADD CONSTRAINT runner_pkey PRIMARY KEY (id);


--
-- Name: session session_pkey1; Type: CONSTRAINT; Schema: public; Owner: valknar
--

ALTER TABLE ONLY public.session
    ADD CONSTRAINT session_pkey1 PRIMARY KEY (id);


--
-- Name: task__ansible_error task__ansible_error_pkey; Type: CONSTRAINT; Schema: public; Owner: valknar
--

ALTER TABLE ONLY public.task__ansible_error
    ADD CONSTRAINT task__ansible_error_pkey PRIMARY KEY (id);


--
-- Name: task__ansible_host task__ansible_host_pkey; Type: CONSTRAINT; Schema: public; Owner: valknar
--

ALTER TABLE ONLY public.task__ansible_host
    ADD CONSTRAINT task__ansible_host_pkey PRIMARY KEY (id);


--
-- Name: task__output task__output_pkey; Type: CONSTRAINT; Schema: public; Owner: valknar
--

ALTER TABLE ONLY public.task__output
    ADD CONSTRAINT task__output_pkey PRIMARY KEY (id);


--
-- Name: task__stage task__stage_pkey; Type: CONSTRAINT; Schema: public; Owner: valknar
--

ALTER TABLE ONLY public.task__stage
    ADD CONSTRAINT task__stage_pkey PRIMARY KEY (id);


--
-- Name: task__stage_result task__stage_result_pkey; Type: CONSTRAINT; Schema: public; Owner: valknar
--

ALTER TABLE ONLY public.task__stage_result
    ADD CONSTRAINT task__stage_result_pkey PRIMARY KEY (id);


--
-- Name: task task_pkey; Type: CONSTRAINT; Schema: public; Owner: valknar
--

ALTER TABLE ONLY public.task
    ADD CONSTRAINT task_pkey PRIMARY KEY (id);


--
-- Name: user__email_otp user__email_otp_code_key; Type: CONSTRAINT; Schema: public; Owner: valknar
--

ALTER TABLE ONLY public.user__email_otp
    ADD CONSTRAINT user__email_otp_code_key UNIQUE (code);


--
-- Name: user__email_otp user__email_otp_pkey; Type: CONSTRAINT; Schema: public; Owner: valknar
--

ALTER TABLE ONLY public.user__email_otp
    ADD CONSTRAINT user__email_otp_pkey PRIMARY KEY (id);


--
-- Name: user__token user__token_pkey1; Type: CONSTRAINT; Schema: public; Owner: valknar
--

ALTER TABLE ONLY public.user__token
    ADD CONSTRAINT user__token_pkey1 PRIMARY KEY (id);


--
-- Name: user__totp user__totp_pkey; Type: CONSTRAINT; Schema: public; Owner: valknar
--

ALTER TABLE ONLY public.user__totp
    ADD CONSTRAINT user__totp_pkey PRIMARY KEY (id);


--
-- Name: user__totp user__totp_user_id_key; Type: CONSTRAINT; Schema: public; Owner: valknar
--

ALTER TABLE ONLY public.user__totp
    ADD CONSTRAINT user__totp_user_id_key UNIQUE (user_id);


--
-- Name: user user_email_key; Type: CONSTRAINT; Schema: public; Owner: valknar
--

ALTER TABLE ONLY public."user"
    ADD CONSTRAINT user_email_key UNIQUE (email);


--
-- Name: user user_pkey; Type: CONSTRAINT; Schema: public; Owner: valknar
--

ALTER TABLE ONLY public."user"
    ADD CONSTRAINT user_pkey PRIMARY KEY (id);


--
-- Name: user user_username_key; Type: CONSTRAINT; Schema: public; Owner: valknar
--

ALTER TABLE ONLY public."user"
    ADD CONSTRAINT user_username_key UNIQUE (username);


--
-- Name: expired; Type: INDEX; Schema: public; Owner: valknar
--

CREATE INDEX expired ON public.session USING btree (expired);


--
-- Name: task__output_time_idx; Type: INDEX; Schema: public; Owner: valknar
--

CREATE INDEX task__output_time_idx ON public.task__output USING btree ("time");


--
-- Name: user_id; Type: INDEX; Schema: public; Owner: valknar
--

CREATE INDEX user_id ON public.session USING btree (user_id);


--
-- Name: access_key access_key_environment_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: valknar
--

ALTER TABLE ONLY public.access_key
    ADD CONSTRAINT access_key_environment_id_fkey FOREIGN KEY (environment_id) REFERENCES public.project__environment(id) ON DELETE CASCADE;


--
-- Name: access_key access_key_project_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: valknar
--

ALTER TABLE ONLY public.access_key
    ADD CONSTRAINT access_key_project_id_fkey FOREIGN KEY (project_id) REFERENCES public.project(id) ON DELETE SET NULL;


--
-- Name: access_key access_key_source_storage_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: valknar
--

ALTER TABLE ONLY public.access_key
    ADD CONSTRAINT access_key_source_storage_id_fkey FOREIGN KEY (source_storage_id) REFERENCES public.project__secret_storage(id);


--
-- Name: access_key access_key_storage_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: valknar
--

ALTER TABLE ONLY public.access_key
    ADD CONSTRAINT access_key_storage_id_fkey FOREIGN KEY (storage_id) REFERENCES public.project__secret_storage(id) ON DELETE CASCADE;


--
-- Name: access_key access_key_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: valknar
--

ALTER TABLE ONLY public.access_key
    ADD CONSTRAINT access_key_user_id_fkey FOREIGN KEY (user_id) REFERENCES public."user"(id) ON DELETE CASCADE;


--
-- Name: event event_project_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: valknar
--

ALTER TABLE ONLY public.event
    ADD CONSTRAINT event_project_id_fkey FOREIGN KEY (project_id) REFERENCES public.project(id) ON DELETE CASCADE;


--
-- Name: event_backup_5784568 event_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: valknar
--

ALTER TABLE ONLY public.event_backup_5784568
    ADD CONSTRAINT event_user_id_fkey FOREIGN KEY (user_id) REFERENCES public."user"(id);


--
-- Name: event event_user_id_fkey1; Type: FK CONSTRAINT; Schema: public; Owner: valknar
--

ALTER TABLE ONLY public.event
    ADD CONSTRAINT event_user_id_fkey1 FOREIGN KEY (user_id) REFERENCES public."user"(id) ON DELETE SET NULL;


--
-- Name: project__environment project__environment_project_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: valknar
--

ALTER TABLE ONLY public.project__environment
    ADD CONSTRAINT project__environment_project_id_fkey FOREIGN KEY (project_id) REFERENCES public.project(id) ON DELETE CASCADE;


--
-- Name: project__environment project__environment_secret_storage_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: valknar
--

ALTER TABLE ONLY public.project__environment
    ADD CONSTRAINT project__environment_secret_storage_id_fkey FOREIGN KEY (secret_storage_id) REFERENCES public.project__secret_storage(id);


--
-- Name: project__integration_alias project__integration_alias_integration_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: valknar
--

ALTER TABLE ONLY public.project__integration_alias
    ADD CONSTRAINT project__integration_alias_integration_id_fkey FOREIGN KEY (integration_id) REFERENCES public.project__integration(id) ON DELETE CASCADE;


--
-- Name: project__integration_alias project__integration_alias_project_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: valknar
--

ALTER TABLE ONLY public.project__integration_alias
    ADD CONSTRAINT project__integration_alias_project_id_fkey FOREIGN KEY (project_id) REFERENCES public.project(id) ON DELETE CASCADE;


--
-- Name: project__integration project__integration_auth_secret_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: valknar
--

ALTER TABLE ONLY public.project__integration
    ADD CONSTRAINT project__integration_auth_secret_id_fkey FOREIGN KEY (auth_secret_id) REFERENCES public.access_key(id) ON DELETE SET NULL;


--
-- Name: project__integration_extract_value project__integration_extract_value_integration_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: valknar
--

ALTER TABLE ONLY public.project__integration_extract_value
    ADD CONSTRAINT project__integration_extract_value_integration_id_fkey FOREIGN KEY (integration_id) REFERENCES public.project__integration(id) ON DELETE CASCADE;


--
-- Name: project__integration_matcher project__integration_matcher_integration_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: valknar
--

ALTER TABLE ONLY public.project__integration_matcher
    ADD CONSTRAINT project__integration_matcher_integration_id_fkey FOREIGN KEY (integration_id) REFERENCES public.project__integration(id) ON DELETE CASCADE;


--
-- Name: project__integration project__integration_project_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: valknar
--

ALTER TABLE ONLY public.project__integration
    ADD CONSTRAINT project__integration_project_id_fkey FOREIGN KEY (project_id) REFERENCES public.project(id) ON DELETE CASCADE;


--
-- Name: project__integration project__integration_task_params_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: valknar
--

ALTER TABLE ONLY public.project__integration
    ADD CONSTRAINT project__integration_task_params_id_fkey FOREIGN KEY (task_params_id) REFERENCES public.project__task_params(id);


--
-- Name: project__integration project__integration_template_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: valknar
--

ALTER TABLE ONLY public.project__integration
    ADD CONSTRAINT project__integration_template_id_fkey FOREIGN KEY (template_id) REFERENCES public.project__template(id) ON DELETE CASCADE;


--
-- Name: project__inventory project__inventory_become_key_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: valknar
--

ALTER TABLE ONLY public.project__inventory
    ADD CONSTRAINT project__inventory_become_key_id_fkey FOREIGN KEY (become_key_id) REFERENCES public.access_key(id);


--
-- Name: project__inventory project__inventory_holder_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: valknar
--

ALTER TABLE ONLY public.project__inventory
    ADD CONSTRAINT project__inventory_holder_id_fkey FOREIGN KEY (template_id) REFERENCES public.project__template(id) ON DELETE SET NULL;


--
-- Name: project__inventory project__inventory_project_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: valknar
--

ALTER TABLE ONLY public.project__inventory
    ADD CONSTRAINT project__inventory_project_id_fkey FOREIGN KEY (project_id) REFERENCES public.project(id) ON DELETE CASCADE;


--
-- Name: project__inventory project__inventory_repository_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: valknar
--

ALTER TABLE ONLY public.project__inventory
    ADD CONSTRAINT project__inventory_repository_id_fkey FOREIGN KEY (repository_id) REFERENCES public.project__repository(id) ON DELETE SET NULL;


--
-- Name: project__inventory project__inventory_ssh_key_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: valknar
--

ALTER TABLE ONLY public.project__inventory
    ADD CONSTRAINT project__inventory_ssh_key_id_fkey FOREIGN KEY (ssh_key_id) REFERENCES public.access_key(id);


--
-- Name: project__repository project__repository_project_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: valknar
--

ALTER TABLE ONLY public.project__repository
    ADD CONSTRAINT project__repository_project_id_fkey FOREIGN KEY (project_id) REFERENCES public.project(id) ON DELETE CASCADE;


--
-- Name: project__repository project__repository_ssh_key_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: valknar
--

ALTER TABLE ONLY public.project__repository
    ADD CONSTRAINT project__repository_ssh_key_id_fkey FOREIGN KEY (ssh_key_id) REFERENCES public.access_key(id);


--
-- Name: project__schedule project__schedule_project_id_fkey1; Type: FK CONSTRAINT; Schema: public; Owner: valknar
--

ALTER TABLE ONLY public.project__schedule
    ADD CONSTRAINT project__schedule_project_id_fkey1 FOREIGN KEY (project_id) REFERENCES public.project(id) ON DELETE CASCADE;


--
-- Name: project__schedule project__schedule_repository_id_fkey1; Type: FK CONSTRAINT; Schema: public; Owner: valknar
--

ALTER TABLE ONLY public.project__schedule
    ADD CONSTRAINT project__schedule_repository_id_fkey1 FOREIGN KEY (repository_id) REFERENCES public.project__repository(id);


--
-- Name: project__schedule project__schedule_task_params_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: valknar
--

ALTER TABLE ONLY public.project__schedule
    ADD CONSTRAINT project__schedule_task_params_id_fkey FOREIGN KEY (task_params_id) REFERENCES public.project__task_params(id);


--
-- Name: project__schedule project__schedule_template_id_fkey1; Type: FK CONSTRAINT; Schema: public; Owner: valknar
--

ALTER TABLE ONLY public.project__schedule
    ADD CONSTRAINT project__schedule_template_id_fkey1 FOREIGN KEY (template_id) REFERENCES public.project__template(id) ON DELETE CASCADE;


--
-- Name: project__secret_storage project__secret_storage_project_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: valknar
--

ALTER TABLE ONLY public.project__secret_storage
    ADD CONSTRAINT project__secret_storage_project_id_fkey FOREIGN KEY (project_id) REFERENCES public.project(id) ON DELETE CASCADE;


--
-- Name: project__task_params project__task_params_inventory_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: valknar
--

ALTER TABLE ONLY public.project__task_params
    ADD CONSTRAINT project__task_params_inventory_id_fkey FOREIGN KEY (inventory_id) REFERENCES public.project__inventory(id) ON DELETE CASCADE;


--
-- Name: project__task_params project__task_params_project_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: valknar
--

ALTER TABLE ONLY public.project__task_params
    ADD CONSTRAINT project__task_params_project_id_fkey FOREIGN KEY (project_id) REFERENCES public.project(id) ON DELETE CASCADE;


--
-- Name: project__template project__template_build_template_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: valknar
--

ALTER TABLE ONLY public.project__template
    ADD CONSTRAINT project__template_build_template_id_fkey FOREIGN KEY (build_template_id) REFERENCES public.project__template(id);


--
-- Name: project__template project__template_environment_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: valknar
--

ALTER TABLE ONLY public.project__template
    ADD CONSTRAINT project__template_environment_id_fkey FOREIGN KEY (environment_id) REFERENCES public.project__environment(id);


--
-- Name: project__template project__template_inventory_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: valknar
--

ALTER TABLE ONLY public.project__template
    ADD CONSTRAINT project__template_inventory_id_fkey FOREIGN KEY (inventory_id) REFERENCES public.project__inventory(id);


--
-- Name: project__template project__template_project_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: valknar
--

ALTER TABLE ONLY public.project__template
    ADD CONSTRAINT project__template_project_id_fkey FOREIGN KEY (project_id) REFERENCES public.project(id) ON DELETE CASCADE;


--
-- Name: project__template project__template_repository_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: valknar
--

ALTER TABLE ONLY public.project__template
    ADD CONSTRAINT project__template_repository_id_fkey FOREIGN KEY (repository_id) REFERENCES public.project__repository(id);


--
-- Name: project__template_vault project__template_vault_project_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: valknar
--

ALTER TABLE ONLY public.project__template_vault
    ADD CONSTRAINT project__template_vault_project_id_fkey FOREIGN KEY (project_id) REFERENCES public.project(id) ON DELETE CASCADE;


--
-- Name: project__template_vault project__template_vault_template_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: valknar
--

ALTER TABLE ONLY public.project__template_vault
    ADD CONSTRAINT project__template_vault_template_id_fkey FOREIGN KEY (template_id) REFERENCES public.project__template(id) ON DELETE CASCADE;


--
-- Name: project__template_vault project__template_vault_vault_key_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: valknar
--

ALTER TABLE ONLY public.project__template_vault
    ADD CONSTRAINT project__template_vault_vault_key_id_fkey FOREIGN KEY (vault_key_id) REFERENCES public.access_key(id) ON DELETE CASCADE;


--
-- Name: project__template project__template_view_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: valknar
--

ALTER TABLE ONLY public.project__template
    ADD CONSTRAINT project__template_view_id_fkey FOREIGN KEY (view_id) REFERENCES public.project__view(id) ON DELETE SET NULL;


--
-- Name: project__terraform_inventory_alias project__terraform_inventory_alias_auth_key_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: valknar
--

ALTER TABLE ONLY public.project__terraform_inventory_alias
    ADD CONSTRAINT project__terraform_inventory_alias_auth_key_id_fkey FOREIGN KEY (auth_key_id) REFERENCES public.access_key(id);


--
-- Name: project__terraform_inventory_alias project__terraform_inventory_alias_inventory_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: valknar
--

ALTER TABLE ONLY public.project__terraform_inventory_alias
    ADD CONSTRAINT project__terraform_inventory_alias_inventory_id_fkey FOREIGN KEY (inventory_id) REFERENCES public.project__inventory(id) ON DELETE CASCADE;


--
-- Name: project__terraform_inventory_alias project__terraform_inventory_alias_project_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: valknar
--

ALTER TABLE ONLY public.project__terraform_inventory_alias
    ADD CONSTRAINT project__terraform_inventory_alias_project_id_fkey FOREIGN KEY (project_id) REFERENCES public.project(id) ON DELETE CASCADE;


--
-- Name: project__terraform_inventory_state project__terraform_inventory_state_inventory_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: valknar
--

ALTER TABLE ONLY public.project__terraform_inventory_state
    ADD CONSTRAINT project__terraform_inventory_state_inventory_id_fkey FOREIGN KEY (inventory_id) REFERENCES public.project__inventory(id) ON DELETE CASCADE;


--
-- Name: project__terraform_inventory_state project__terraform_inventory_state_project_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: valknar
--

ALTER TABLE ONLY public.project__terraform_inventory_state
    ADD CONSTRAINT project__terraform_inventory_state_project_id_fkey FOREIGN KEY (project_id) REFERENCES public.project(id) ON DELETE CASCADE;


--
-- Name: project__terraform_inventory_state project__terraform_inventory_state_task_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: valknar
--

ALTER TABLE ONLY public.project__terraform_inventory_state
    ADD CONSTRAINT project__terraform_inventory_state_task_id_fkey FOREIGN KEY (task_id) REFERENCES public.task(id) ON DELETE SET NULL;


--
-- Name: project__user project__user_project_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: valknar
--

ALTER TABLE ONLY public.project__user
    ADD CONSTRAINT project__user_project_id_fkey FOREIGN KEY (project_id) REFERENCES public.project(id) ON DELETE CASCADE;


--
-- Name: project__user project__user_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: valknar
--

ALTER TABLE ONLY public.project__user
    ADD CONSTRAINT project__user_user_id_fkey FOREIGN KEY (user_id) REFERENCES public."user"(id) ON DELETE CASCADE;


--
-- Name: project__view project__view_project_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: valknar
--

ALTER TABLE ONLY public.project__view
    ADD CONSTRAINT project__view_project_id_fkey FOREIGN KEY (project_id) REFERENCES public.project(id) ON DELETE CASCADE;


--
-- Name: project project_default_secret_storage_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: valknar
--

ALTER TABLE ONLY public.project
    ADD CONSTRAINT project_default_secret_storage_id_fkey FOREIGN KEY (default_secret_storage_id) REFERENCES public.project__secret_storage(id);


--
-- Name: runner runner_project_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: valknar
--

ALTER TABLE ONLY public.runner
    ADD CONSTRAINT runner_project_id_fkey FOREIGN KEY (project_id) REFERENCES public.project(id) ON DELETE CASCADE;


--
-- Name: task__ansible_error task__ansible_error_project_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: valknar
--

ALTER TABLE ONLY public.task__ansible_error
    ADD CONSTRAINT task__ansible_error_project_id_fkey FOREIGN KEY (project_id) REFERENCES public.project(id) ON DELETE CASCADE;


--
-- Name: task__ansible_error task__ansible_error_task_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: valknar
--

ALTER TABLE ONLY public.task__ansible_error
    ADD CONSTRAINT task__ansible_error_task_id_fkey FOREIGN KEY (task_id) REFERENCES public.task(id) ON DELETE CASCADE;


--
-- Name: task__ansible_host task__ansible_host_project_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: valknar
--

ALTER TABLE ONLY public.task__ansible_host
    ADD CONSTRAINT task__ansible_host_project_id_fkey FOREIGN KEY (project_id) REFERENCES public.project(id) ON DELETE CASCADE;


--
-- Name: task__ansible_host task__ansible_host_task_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: valknar
--

ALTER TABLE ONLY public.task__ansible_host
    ADD CONSTRAINT task__ansible_host_task_id_fkey FOREIGN KEY (task_id) REFERENCES public.task(id) ON DELETE CASCADE;


--
-- Name: task__output task__output_task_id_fkey1; Type: FK CONSTRAINT; Schema: public; Owner: valknar
--

ALTER TABLE ONLY public.task__output
    ADD CONSTRAINT task__output_task_id_fkey1 FOREIGN KEY (task_id) REFERENCES public.task(id) ON DELETE CASCADE;


--
-- Name: task__stage task__stage_end_output_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: valknar
--

ALTER TABLE ONLY public.task__stage
    ADD CONSTRAINT task__stage_end_output_id_fkey FOREIGN KEY (end_output_id) REFERENCES public.task__output(id) ON DELETE SET NULL;


--
-- Name: task__stage_result task__stage_result_stage_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: valknar
--

ALTER TABLE ONLY public.task__stage_result
    ADD CONSTRAINT task__stage_result_stage_id_fkey FOREIGN KEY (stage_id) REFERENCES public.task__stage(id) ON DELETE CASCADE;


--
-- Name: task__stage_result task__stage_result_task_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: valknar
--

ALTER TABLE ONLY public.task__stage_result
    ADD CONSTRAINT task__stage_result_task_id_fkey FOREIGN KEY (task_id) REFERENCES public.task(id) ON DELETE CASCADE;


--
-- Name: task__stage task__stage_start_output_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: valknar
--

ALTER TABLE ONLY public.task__stage
    ADD CONSTRAINT task__stage_start_output_id_fkey FOREIGN KEY (start_output_id) REFERENCES public.task__output(id) ON DELETE SET NULL;


--
-- Name: task__stage task__stage_task_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: valknar
--

ALTER TABLE ONLY public.task__stage
    ADD CONSTRAINT task__stage_task_id_fkey FOREIGN KEY (task_id) REFERENCES public.task(id) ON DELETE CASCADE;


--
-- Name: task task_build_task_id_fk_y38rt; Type: FK CONSTRAINT; Schema: public; Owner: valknar
--

ALTER TABLE ONLY public.task
    ADD CONSTRAINT task_build_task_id_fk_y38rt FOREIGN KEY (build_task_id) REFERENCES public.task(id) ON DELETE SET NULL;


--
-- Name: task task_integration_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: valknar
--

ALTER TABLE ONLY public.task
    ADD CONSTRAINT task_integration_id_fkey FOREIGN KEY (integration_id) REFERENCES public.project__integration(id) ON DELETE SET NULL;


--
-- Name: task task_inventory_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: valknar
--

ALTER TABLE ONLY public.task
    ADD CONSTRAINT task_inventory_id_fkey FOREIGN KEY (inventory_id) REFERENCES public.project__inventory(id) ON DELETE SET NULL;


--
-- Name: task task_project_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: valknar
--

ALTER TABLE ONLY public.task
    ADD CONSTRAINT task_project_id_fkey FOREIGN KEY (project_id) REFERENCES public.project(id);


--
-- Name: task task_schedule_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: valknar
--

ALTER TABLE ONLY public.task
    ADD CONSTRAINT task_schedule_id_fkey FOREIGN KEY (schedule_id) REFERENCES public.project__schedule(id) ON DELETE SET NULL;


--
-- Name: task task_template_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: valknar
--

ALTER TABLE ONLY public.task
    ADD CONSTRAINT task_template_id_fkey FOREIGN KEY (template_id) REFERENCES public.project__template(id) ON DELETE CASCADE;


--
-- Name: user__email_otp user__email_otp_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: valknar
--

ALTER TABLE ONLY public.user__email_otp
    ADD CONSTRAINT user__email_otp_user_id_fkey FOREIGN KEY (user_id) REFERENCES public."user"(id) ON DELETE CASCADE;


--
-- Name: user__token user__token_user_id_fkey1; Type: FK CONSTRAINT; Schema: public; Owner: valknar
--

ALTER TABLE ONLY public.user__token
    ADD CONSTRAINT user__token_user_id_fkey1 FOREIGN KEY (user_id) REFERENCES public."user"(id) ON DELETE CASCADE;


--
-- Name: user__totp user__totp_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: valknar
--

ALTER TABLE ONLY public.user__totp
    ADD CONSTRAINT user__totp_user_id_fkey FOREIGN KEY (user_id) REFERENCES public."user"(id) ON DELETE CASCADE;


--
-- PostgreSQL database dump complete
--

\unrestrict Ftcokghp0DYHVxoRJfyaVIXsVtlxPc122QJufD7uBbkodWlXeKdrj7Aw9dRc7Gl

