--
-- PostgreSQL database dump
--

\restrict oKvkA5N76F8A7rGVCgFR11FJ0l9DM2E0bsqePPNNerUnn0LhCitjzAtSdrrm8m5

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
1	None	none	1	\N	\N	\N		\N	\N	\N	\N
3	Technician	login_password	1	Cxx/0XPy6g8thrCt2IV33d5gdn51S9hcU/oZmsjmMXrrFrzXd2zyzo0cHHcKokLLOvIU9nQmePfY0FWuXJtghLE9BEUAncWXnQ==	\N	\N		\N	\N	\N	\N
\.


--
-- Data for Name: event; Type: TABLE DATA; Schema: public; Owner: valknar
--

COPY public.event (id, project_id, object_id, object_type, description, created, user_id) FROM stdin;
1	1	1	project	Project created	2025-10-10 06:25:52.693933	1
2	1	2	repository	Repository /auto created	2025-10-10 06:31:24.051229	1
3	1	9	schedule	Template ID 9 created	2025-10-10 06:41:56.551814	1
4	1	9	template	Template ID 9 updated	2025-10-10 06:43:24.458673	1
5	1	1	task	Task ID 1 (kompose.sh) WAITING	2025-10-10 06:44:30.926043	1
6	1	1	task	Task ID 1 (kompose.sh) STARTING	2025-10-10 06:44:30.92819	1
7	1	1	task	Task ID 1 (kompose.sh) finished with status ERROR	2025-10-10 06:44:30.934753	1
8	1	2	task	Task ID 2 (kompose.sh) WAITING	2025-10-10 06:45:37.930015	1
9	1	2	task	Task ID 2 (kompose.sh) STARTING	2025-10-10 06:45:37.936098	1
10	1	2	task	Task ID 2 (kompose.sh) finished with status ERROR	2025-10-10 06:45:37.940803	1
11	1	2	repository	Repository /var/lib/semaphore/auto updated	2025-10-10 06:55:38.171696	1
12	1	3	task	Task ID 3 (kompose.sh) WAITING	2025-10-10 06:56:11.610465	1
13	1	3	task	Task ID 3 (kompose.sh) STARTING	2025-10-10 06:56:11.616583	1
14	1	3	task	Task ID 3 (kompose.sh) finished with status ERROR	2025-10-10 06:56:11.625197	1
15	1	9	template	Template ID 9 updated	2025-10-10 07:00:02.733854	1
16	1	4	task	Task ID 4 (kompose.sh) WAITING	2025-10-10 07:00:13.644131	1
17	1	4	task	Task ID 4 (kompose.sh) STARTING	2025-10-10 07:00:13.645535	1
18	1	4	task	Task ID 4 (kompose.sh) finished with status ERROR	2025-10-10 07:00:13.65406	1
19	1	2	repository	Repository /var/lib/semaphore/auto/Projects/kompose updated	2025-10-10 07:01:36.038985	1
20	1	5	task	Task ID 5 (kompose.sh) WAITING	2025-10-10 07:01:46.616435	1
21	1	5	task	Task ID 5 (kompose.sh) STARTING	2025-10-10 07:01:46.617741	1
22	1	5	task	Task ID 5 (kompose.sh) finished with status ERROR	2025-10-10 07:01:46.622541	1
23	1	3	key	Access Key Technician created	2025-10-10 07:07:58.579095	1
24	1	4	inventory	Inventory VPS created	2025-10-10 07:10:49.926847	1
25	1	4	inventory	Inventory VPS updated	2025-10-10 07:11:07.692317	1
26	1	9	template	Template ID 9 updated	2025-10-10 07:11:51.915064	1
27	1	4	inventory	Inventory VPS updated	2025-10-10 07:17:00.245682	1
28	1	4	view	View Kompose created	2025-10-10 07:36:43.262316	1
29	1	5	template	Template ID 5 deleted	2025-10-10 07:37:53.87617	1
30	1	6	template	Template ID 6 deleted	2025-10-10 07:37:59.060853	1
31	1	7	template	Template ID 7 deleted	2025-10-10 07:38:18.823463	1
32	1	8	template	Template ID 8 deleted	2025-10-10 07:38:23.29356	1
33	1	1	template	Template ID 1 deleted	2025-10-10 07:38:27.988771	1
34	1	9	template	Template ID 9 deleted	2025-10-10 07:38:32.265414	1
35	1	4	template	Template ID 4 deleted	2025-10-10 07:38:36.320499	1
36	1	3	template	Template ID 3 deleted	2025-10-10 07:38:44.077305	1
37	1	2	template	Template ID 2 updated	2025-10-10 07:41:45.576184	1
38	1	2	repository	Repository /home/semaphore updated	2025-10-10 07:56:31.874263	1
39	1	1	repository	Repository https://github.com/semaphoreui/semaphore-demo.git deleted	2025-10-10 07:56:36.135176	1
40	1	6	task	Task ID 6 (Run kompose.sh with args) WAITING	2025-10-10 07:57:11.012477	1
41	1	6	task	Task ID 6 (Run kompose.sh with args) STARTING	2025-10-10 07:57:11.014376	1
42	1	6	task	Task ID 6 (Run kompose.sh with args) finished with status ERROR	2025-10-10 07:57:12.229319	1
43	1	7	task	Task ID 7 (Run kompose.sh with args) WAITING	2025-10-10 07:58:44.352554	1
44	1	7	task	Task ID 7 (Run kompose.sh with args) STARTING	2025-10-10 07:58:44.35927	1
45	1	7	task	Task ID 7 (Run kompose.sh with args) finished with status ERROR	2025-10-10 07:58:45.427463	1
46	1	8	task	Task ID 8 (Run kompose.sh with args) WAITING	2025-10-10 07:59:49.619171	1
47	1	8	task	Task ID 8 (Run kompose.sh with args) STARTING	2025-10-10 07:59:49.626172	1
48	1	8	task	Task ID 8 (Run kompose.sh with args) finished with status ERROR	2025-10-10 07:59:50.846141	1
49	1	9	task	Task ID 9 (Run kompose.sh with args) WAITING	2025-10-10 08:00:29.489923	1
50	1	9	task	Task ID 9 (Run kompose.sh with args) STARTING	2025-10-10 08:00:29.4916	1
51	1	9	task	Task ID 9 (Run kompose.sh with args) finished with status ERROR	2025-10-10 08:00:30.032126	1
52	1	10	task	Task ID 10 (Run kompose.sh with args) WAITING	2025-10-10 08:00:43.005906	1
53	1	10	task	Task ID 10 (Run kompose.sh with args) STARTING	2025-10-10 08:00:43.068162	1
54	1	10	task	Task ID 10 (Run kompose.sh with args) finished with status ERROR	2025-10-10 08:00:44.215608	1
55	1	11	task	Task ID 11 (Run kompose.sh with args) WAITING	2025-10-10 08:01:53.660816	1
56	1	11	task	Task ID 11 (Run kompose.sh with args) STARTING	2025-10-10 08:01:53.675418	1
57	1	11	task	Task ID 11 (Run kompose.sh with args) finished with status ERROR	2025-10-10 08:01:55.766687	1
58	1	12	task	Task ID 12 (Run kompose.sh with args) WAITING	2025-10-10 08:03:20.138461	1
59	1	12	task	Task ID 12 (Run kompose.sh with args) STARTING	2025-10-10 08:03:20.144667	1
60	1	12	task	Task ID 12 (Run kompose.sh with args) finished with status ERROR	2025-10-10 08:03:21.595532	1
61	1	13	task	Task ID 13 (Run kompose.sh with args) WAITING	2025-10-10 08:04:09.449801	1
62	1	13	task	Task ID 13 (Run kompose.sh with args) STARTING	2025-10-10 08:04:09.457086	1
63	1	13	task	Task ID 13 (Run kompose.sh with args) finished with status ERROR	2025-10-10 08:04:11.709935	1
64	1	14	task	Task ID 14 (Run kompose.sh with args) WAITING	2025-10-10 08:05:43.669891	1
65	1	14	task	Task ID 14 (Run kompose.sh with args) STARTING	2025-10-10 08:05:43.676204	1
66	1	14	task	Task ID 14 (Run kompose.sh with args) finished with status ERROR	2025-10-10 08:05:49.101644	1
67	1	15	task	Task ID 15 (Run kompose.sh with args) WAITING	2025-10-10 08:07:07.154469	1
68	1	15	task	Task ID 15 (Run kompose.sh with args) STARTING	2025-10-10 08:07:07.161461	1
69	1	15	task	Task ID 15 (Run kompose.sh with args) finished with status ERROR	2025-10-10 08:07:11.705014	1
70	1	16	task	Task ID 16 (Run kompose.sh with args) WAITING	2025-10-10 08:09:13.952309	1
71	1	16	task	Task ID 16 (Run kompose.sh with args) STARTING	2025-10-10 08:09:13.954013	1
72	1	16	task	Task ID 16 (Run kompose.sh with args) finished with status SUCCESS	2025-10-10 08:09:22.864624	1
73	1	2	key	Access Key Vault Password deleted	2025-10-10 08:13:56.01792	1
74	1	1	inventory	Inventory Build deleted	2025-10-10 08:22:15.695294	1
75	1	2	inventory	Inventory Dev deleted	2025-10-10 08:22:18.24467	1
76	1	3	inventory	Inventory Prod deleted	2025-10-10 08:22:21.208964	1
77	1	1	schedule	Schedule ID 1 created	2025-10-10 08:26:20.141416	1
78	1	1	schedule	Schedule ID 1 updated	2025-10-10 08:30:22.872223	1
79	1	17	task	Task ID 17 (Run kompose.sh with args) WAITING	2025-10-10 09:19:54.846401	1
80	1	17	task	Task ID 17 (Run kompose.sh with args) STARTING	2025-10-10 09:19:54.847773	1
81	1	17	task	Task ID 17 (Run kompose.sh with args) finished with status ERROR	2025-10-10 09:19:56.961161	1
82	1	2	environment	Environment Restart Containers created	2025-10-10 09:25:12.35132	1
83	1	10	schedule	Template ID 10 created	2025-10-10 09:26:27.135575	1
84	1	18	task	Task ID 18 (Run kompose.sh "*" up -d) WAITING	2025-10-10 09:27:08.335453	1
85	1	18	task	Task ID 18 (Run kompose.sh "*" up -d) STARTING	2025-10-10 09:27:08.336927	1
86	1	18	task	Task ID 18 (Run kompose.sh "*" up -d) finished with status SUCCESS	2025-10-10 09:28:41.855631	1
87	1	19	task	Task ID 19 (Run kompose.sh "*" up -d) WAITING	2025-10-10 15:17:00.502861	1
88	1	19	task	Task ID 19 (Run kompose.sh "*" up -d) STARTING	2025-10-10 15:17:00.509247	1
89	1	19	task	Task ID 19 (Run kompose.sh "*" up -d) finished with status ERROR	2025-10-10 15:17:00.778373	1
90	1	20	task	Task ID 20 (Run kompose.sh "*" up -d) WAITING	2025-10-10 15:22:43.685531	1
91	1	20	task	Task ID 20 (Run kompose.sh "*" up -d) STARTING	2025-10-10 15:22:43.686731	1
92	1	20	task	Task ID 20 (Run kompose.sh "*" up -d) finished with status ERROR	2025-10-10 15:22:43.92767	1
93	1	21	task	Task ID 21 (Run kompose.sh "*" up -d) WAITING	2025-10-10 15:24:38.87206	1
94	1	21	task	Task ID 21 (Run kompose.sh "*" up -d) STARTING	2025-10-10 15:24:38.878502	1
95	1	21	task	Task ID 21 (Run kompose.sh "*" up -d) finished with status SUCCESS	2025-10-10 15:24:47.619764	1
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
1	2025-10-10 06:25:52.668571	pivoine.art	t	\N	1		\N
\.


--
-- Data for Name: project__environment; Type: TABLE DATA; Schema: public; Owner: valknar
--

COPY public.project__environment (id, project_id, password, "json", name, env, secret_storage_id, secret_storage_key_prefix) FROM stdin;
1	1	\N	{}	Empty	\N	\N	\N
2	1	\N	{"kompose_filter":"*","kompose_command":"up -d"}	Restart Containers	{}	\N	\N
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
4	qsco1509e9wuizti	1	\N
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
4	1	static	host.docker.internal	3	VPS	\N	\N	\N	\N
\.


--
-- Data for Name: project__repository; Type: TABLE DATA; Schema: public; Owner: valknar
--

COPY public.project__repository (id, project_id, git_url, ssh_key_id, name, git_branch) FROM stdin;
2	1	/home/semaphore	1	home	
\.


--
-- Data for Name: project__schedule; Type: TABLE DATA; Schema: public; Owner: valknar
--

COPY public.project__schedule (id, template_id, project_id, cron_format, repository_id, last_commit_hash, name, active, task_params_id) FROM stdin;
1	2	1	0 0/24 * * *	\N	\N	DB Backup	t	\N
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
10	1	4	2	2	kompose.yml	[]	Run kompose.sh "*" up -d	\N		\N	\N	4	[]	f	f	f	ansible	4	\N	{}	\N	f	f
2	1	4	2	1	kompose.yml	[]	Run kompose.sh with args	\N		\N	\N	4	[{"name":"kompose_filter","title":"Filter","required":true,"default_value":"*"},{"name":"kompose_command","title":"Command","required":true,"default_value":"config"}]	f	f	f	ansible	12	\N	{}	\N	f	f
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
1	1	owner
\.


--
-- Data for Name: project__view; Type: TABLE DATA; Schema: public; Owner: valknar
--

COPY public.project__view (id, title, project_id, "position") FROM stdin;
1	Build	1	0
2	Deploy	1	1
3	Tools	1	2
4	Kompose	1	3
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
3	1	2025-10-10 20:10:20.96431	2025-10-10 22:49:17.300205		Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	f	0	t
1	1	2025-10-10 06:24:56.640257	2025-10-10 11:59:53.716734		Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	f	0	t
2	1	2025-10-10 14:50:36.516238	2025-10-10 18:27:49.36002		Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	f	0	t
\.


--
-- Data for Name: task; Type: TABLE DATA; Schema: public; Owner: valknar
--

COPY public.task (id, template_id, status, playbook, environment, created, start, "end", user_id, project_id, message, version, commit_hash, commit_message, build_task_id, arguments, inventory_id, integration_id, schedule_id, git_branch, params) FROM stdin;
10	2	error		{"kompose_filter":"*","kompose_command":"config"}	2025-10-10 08:00:42.995538	2025-10-10 08:00:43.071676	2025-10-10 08:00:44.215079	1	1		\N	\N		\N	\N	\N	\N	\N	\N	{}
19	10	error			2025-10-10 15:17:00.495247	2025-10-10 15:17:00.510989	2025-10-10 15:17:00.777765	1	1		\N	\N		\N	\N	\N	\N	\N	\N	{}
11	2	error		{"kompose_filter":"*","kompose_command":"config"}	2025-10-10 08:01:53.653988	2025-10-10 08:01:53.680392	2025-10-10 08:01:55.765759	1	1		\N	\N		\N	\N	\N	\N	\N	\N	{}
20	10	error			2025-10-10 15:22:43.679391	2025-10-10 15:22:43.687992	2025-10-10 15:22:43.92691	1	1		\N	\N		\N	\N	\N	\N	\N	\N	{}
12	2	error		{"kompose_filter":"*","kompose_command":"config"}	2025-10-10 08:03:20.131191	2025-10-10 08:03:20.147821	2025-10-10 08:03:21.594633	1	1		\N	\N		\N	\N	\N	\N	\N	\N	{}
13	2	error		{"kompose_filter":"*","kompose_command":"config"}	2025-10-10 08:04:09.43979	2025-10-10 08:04:09.46037	2025-10-10 08:04:11.709372	1	1		\N	\N		\N	\N	\N	\N	\N	\N	{}
21	10	success			2025-10-10 15:24:38.865098	2025-10-10 15:24:38.880544	2025-10-10 15:24:47.618878	1	1		\N	\N		\N	\N	\N	\N	\N	\N	{}
14	2	error		{"kompose_filter":"*","kompose_command":"config"}	2025-10-10 08:05:43.660247	2025-10-10 08:05:43.67823	2025-10-10 08:05:49.100777	1	1		\N	\N		\N	\N	\N	\N	\N	\N	{}
6	2	error		{"kompose_filter":"*","kompose_command":"config"}	2025-10-10 07:57:11.004456	2025-10-10 07:57:11.016375	2025-10-10 07:57:12.22883	1	1	kompose "*" config	\N	\N		\N	\N	\N	\N	\N	\N	{}
15	2	error		{"kompose_filter":"*","kompose_command":"config"}	2025-10-10 08:07:07.146445	2025-10-10 08:07:07.163638	2025-10-10 08:07:11.70416	1	1		\N	\N		\N	\N	\N	\N	\N	\N	{}
7	2	error		{"kompose_filter":"*","kompose_command":"config"}	2025-10-10 07:58:44.344451	2025-10-10 07:58:44.361172	2025-10-10 07:58:45.426972	1	1		\N	\N		\N	\N	\N	\N	\N	\N	{}
8	2	error		{"kompose_filter":"*","kompose_command":"config"}	2025-10-10 07:59:49.610626	2025-10-10 07:59:49.628253	2025-10-10 07:59:50.845581	1	1		\N	\N		\N	\N	\N	\N	\N	\N	{}
16	2	success		{"kompose_filter":"*","kompose_command":"config"}	2025-10-10 08:09:13.94507	2025-10-10 08:09:13.955508	2025-10-10 08:09:22.864003	1	1		\N	\N		\N	\N	\N	\N	\N	\N	{}
9	2	error		{"kompose_filter":"*","kompose_command":"config"}	2025-10-10 08:00:29.482807	2025-10-10 08:00:29.493209	2025-10-10 08:00:30.031545	1	1		\N	\N		\N	\N	\N	\N	\N	\N	{}
17	2	error			2025-10-10 09:19:54.840402	2025-10-10 09:19:54.849766	2025-10-10 09:19:56.960553	1	1		\N	\N		\N	\N	\N	\N	\N	\N	{}
18	10	success			2025-10-10 09:27:08.328421	2025-10-10 09:27:08.338638	2025-10-10 09:28:41.855039	1	1		\N	\N		\N	\N	\N	\N	\N	\N	{}
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
30	6	2025-10-10 07:57:11.012508	Task 6 added to queue
31	6	2025-10-10 07:57:11.014922	Started: 6
32	6	2025-10-10 07:57:11.014942	Run TaskRunner with template: Run kompose.sh with args\n
33	6	2025-10-10 07:57:11.016918	Preparing: 6
34	6	2025-10-10 07:57:11.016966	installing static inventory
35	6	2025-10-10 07:57:11.01725	No /home/semaphore/collections/requirements.yml file found. Skip galaxy install process.\n
36	6	2025-10-10 07:57:11.017305	No /home/semaphore/requirements.yml file found. Skip galaxy install process.\n
37	6	2025-10-10 07:57:11.017333	No /home/semaphore/collections/requirements.yml file found. Skip galaxy install process.\n
38	6	2025-10-10 07:57:11.01737	No /home/semaphore/requirements.yml file found. Skip galaxy install process.\n
39	6	2025-10-10 07:57:11.017505	No /home/semaphore/roles/requirements.yml file found. Skip galaxy install process.\n
40	6	2025-10-10 07:57:11.017514	No /home/semaphore/requirements.yml file found. Skip galaxy install process.\n
41	6	2025-10-10 07:57:11.017567	No /home/semaphore/roles/requirements.yml file found. Skip galaxy install process.\n
42	6	2025-10-10 07:57:11.017587	No /home/semaphore/requirements.yml file found. Skip galaxy install process.\n
43	6	2025-10-10 07:57:12.176701	[0;31mERROR! 'ansible.builtin.shell' is not a valid attribute for a Play[0m
44	6	2025-10-10 07:57:12.176737	[0;31m[0m
45	6	2025-10-10 07:57:12.176771	[0;31mThe error appears to be in '/home/semaphore/kompose.yml': line 3, column 3, but may[0m
46	6	2025-10-10 07:57:12.17678	[0;31mbe elsewhere in the file depending on the exact syntax problem.[0m
47	6	2025-10-10 07:57:12.176785	[0;31m[0m
48	6	2025-10-10 07:57:12.176787	[0;31mThe offending line appears to be:[0m
49	6	2025-10-10 07:57:12.176791	[0;31m[0m
50	6	2025-10-10 07:57:12.176793	[0;31m[0m
51	6	2025-10-10 07:57:12.176795	[0;31m- name: Run kompose.sh with args[0m
52	6	2025-10-10 07:57:12.176797	[0;31m  ^ here[0m
53	6	2025-10-10 07:57:12.226275	Failed to run task: exit status 4
54	7	2025-10-10 07:58:44.352576	Task 7 added to queue
55	7	2025-10-10 07:58:44.360054	Started: 7
56	7	2025-10-10 07:58:44.360071	Run TaskRunner with template: Run kompose.sh with args\n
57	7	2025-10-10 07:58:44.361891	Preparing: 7
58	7	2025-10-10 07:58:44.361999	installing static inventory
59	7	2025-10-10 07:58:44.362156	No /home/semaphore/collections/requirements.yml file found. Skip galaxy install process.\n
60	7	2025-10-10 07:58:44.362185	No /home/semaphore/requirements.yml file found. Skip galaxy install process.\n
61	7	2025-10-10 07:58:44.362217	No /home/semaphore/collections/requirements.yml file found. Skip galaxy install process.\n
62	7	2025-10-10 07:58:44.362231	No /home/semaphore/requirements.yml file found. Skip galaxy install process.\n
63	7	2025-10-10 07:58:44.362264	No /home/semaphore/roles/requirements.yml file found. Skip galaxy install process.\n
64	7	2025-10-10 07:58:44.362279	No /home/semaphore/requirements.yml file found. Skip galaxy install process.\n
65	7	2025-10-10 07:58:44.362294	No /home/semaphore/roles/requirements.yml file found. Skip galaxy install process.\n
66	7	2025-10-10 07:58:44.362304	No /home/semaphore/requirements.yml file found. Skip galaxy install process.\n
67	7	2025-10-10 07:58:45.384235	[0;31mERROR! A playbook must be a list of plays, got a <class 'ansible.parsing.yaml.objects.AnsibleMapping'> instead: /home/semaphore/kompose.yml[0m
68	7	2025-10-10 07:58:45.384276	[0;31m[0m
69	7	2025-10-10 07:58:45.384318	[0;31mThe error appears to be in '/home/semaphore/kompose.yml': line 2, column 1, but may[0m
70	7	2025-10-10 07:58:45.384344	[0;31mbe elsewhere in the file depending on the exact syntax problem.[0m
71	7	2025-10-10 07:58:45.384349	[0;31m[0m
72	7	2025-10-10 07:58:45.384355	[0;31mThe offending line appears to be:[0m
73	7	2025-10-10 07:58:45.384359	[0;31m[0m
74	7	2025-10-10 07:58:45.38436	[0;31m---[0m
75	7	2025-10-10 07:58:45.384363	[0;31mname: Kompose[0m
76	7	2025-10-10 07:58:45.384366	[0;31m^ here[0m
77	7	2025-10-10 07:58:45.424802	Failed to run task: exit status 4
78	8	2025-10-10 07:59:49.619196	Task 8 added to queue
79	8	2025-10-10 07:59:49.627453	Started: 8
80	8	2025-10-10 07:59:49.627472	Run TaskRunner with template: Run kompose.sh with args\n
81	8	2025-10-10 07:59:49.628707	Preparing: 8
82	8	2025-10-10 07:59:49.628759	installing static inventory
83	8	2025-10-10 07:59:49.628864	No /home/semaphore/collections/requirements.yml file found. Skip galaxy install process.\n
84	8	2025-10-10 07:59:49.628901	No /home/semaphore/requirements.yml file found. Skip galaxy install process.\n
85	8	2025-10-10 07:59:49.628917	No /home/semaphore/collections/requirements.yml file found. Skip galaxy install process.\n
86	8	2025-10-10 07:59:49.628922	No /home/semaphore/requirements.yml file found. Skip galaxy install process.\n
87	8	2025-10-10 07:59:49.628934	No /home/semaphore/roles/requirements.yml file found. Skip galaxy install process.\n
88	8	2025-10-10 07:59:49.628938	No /home/semaphore/requirements.yml file found. Skip galaxy install process.\n
89	8	2025-10-10 07:59:49.628943	No /home/semaphore/roles/requirements.yml file found. Skip galaxy install process.\n
90	8	2025-10-10 07:59:49.628946	No /home/semaphore/requirements.yml file found. Skip galaxy install process.\n
91	8	2025-10-10 07:59:50.78884	[0;31mERROR! A playbook must be a list of plays, got a <class 'ansible.parsing.yaml.objects.AnsibleMapping'> instead: /home/semaphore/kompose.yml[0m
92	8	2025-10-10 07:59:50.788887	[0;31m[0m
93	8	2025-10-10 07:59:50.788913	[0;31mThe error appears to be in '/home/semaphore/kompose.yml': line 2, column 1, but may[0m
94	8	2025-10-10 07:59:50.788936	[0;31mbe elsewhere in the file depending on the exact syntax problem.[0m
95	8	2025-10-10 07:59:50.788943	[0;31m[0m
96	8	2025-10-10 07:59:50.788963	[0;31mThe offending line appears to be:[0m
97	8	2025-10-10 07:59:50.788974	[0;31m[0m
98	8	2025-10-10 07:59:50.788976	[0;31m---[0m
99	8	2025-10-10 07:59:50.788979	[0;31mtasks:[0m
100	8	2025-10-10 07:59:50.788981	[0;31m^ here[0m
101	8	2025-10-10 07:59:50.838491	Failed to run task: exit status 4
102	9	2025-10-10 08:00:29.489948	Task 9 added to queue
103	9	2025-10-10 08:00:29.492321	Started: 9
104	9	2025-10-10 08:00:29.492343	Run TaskRunner with template: Run kompose.sh with args\n
105	9	2025-10-10 08:00:29.493731	Preparing: 9
106	9	2025-10-10 08:00:29.493785	installing static inventory
107	9	2025-10-10 08:00:29.493885	No /home/semaphore/collections/requirements.yml file found. Skip galaxy install process.\n
108	9	2025-10-10 08:00:29.493899	No /home/semaphore/requirements.yml file found. Skip galaxy install process.\n
109	9	2025-10-10 08:00:29.493909	No /home/semaphore/collections/requirements.yml file found. Skip galaxy install process.\n
110	9	2025-10-10 08:00:29.493914	No /home/semaphore/requirements.yml file found. Skip galaxy install process.\n
111	9	2025-10-10 08:00:29.49392	No /home/semaphore/roles/requirements.yml file found. Skip galaxy install process.\n
112	9	2025-10-10 08:00:29.493924	No /home/semaphore/requirements.yml file found. Skip galaxy install process.\n
113	9	2025-10-10 08:00:29.493928	No /home/semaphore/roles/requirements.yml file found. Skip galaxy install process.\n
114	9	2025-10-10 08:00:29.493932	No /home/semaphore/requirements.yml file found. Skip galaxy install process.\n
115	9	2025-10-10 08:00:29.969727	[0;31mERROR! A playbook must be a list of plays, got a <class 'ansible.parsing.yaml.objects.AnsibleMapping'> instead: /home/semaphore/kompose.yml[0m
116	9	2025-10-10 08:00:29.969767	[0;31m[0m
117	9	2025-10-10 08:00:29.969791	[0;31mThe error appears to be in '/home/semaphore/kompose.yml': line 2, column 1, but may[0m
118	9	2025-10-10 08:00:29.969819	[0;31mbe elsewhere in the file depending on the exact syntax problem.[0m
119	9	2025-10-10 08:00:29.969826	[0;31m[0m
120	9	2025-10-10 08:00:29.969829	[0;31mThe offending line appears to be:[0m
121	9	2025-10-10 08:00:29.969837	[0;31m[0m
122	9	2025-10-10 08:00:29.969839	[0;31m---[0m
123	9	2025-10-10 08:00:29.969842	[0;31mtasks:[0m
124	9	2025-10-10 08:00:29.969844	[0;31m^ here[0m
125	9	2025-10-10 08:00:30.0288	Failed to run task: exit status 4
126	10	2025-10-10 08:00:43.005931	Task 10 added to queue
127	10	2025-10-10 08:00:43.070408	Started: 10
128	10	2025-10-10 08:00:43.070429	Run TaskRunner with template: Run kompose.sh with args\n
129	10	2025-10-10 08:00:43.072363	Preparing: 10
130	10	2025-10-10 08:00:43.072434	installing static inventory
131	10	2025-10-10 08:00:43.072543	No /home/semaphore/collections/requirements.yml file found. Skip galaxy install process.\n
132	10	2025-10-10 08:00:43.072569	No /home/semaphore/requirements.yml file found. Skip galaxy install process.\n
133	10	2025-10-10 08:00:43.072581	No /home/semaphore/collections/requirements.yml file found. Skip galaxy install process.\n
134	10	2025-10-10 08:00:43.072586	No /home/semaphore/requirements.yml file found. Skip galaxy install process.\n
135	10	2025-10-10 08:00:43.072598	No /home/semaphore/roles/requirements.yml file found. Skip galaxy install process.\n
136	10	2025-10-10 08:00:43.072603	No /home/semaphore/requirements.yml file found. Skip galaxy install process.\n
137	10	2025-10-10 08:00:43.072609	No /home/semaphore/roles/requirements.yml file found. Skip galaxy install process.\n
138	10	2025-10-10 08:00:43.072614	No /home/semaphore/requirements.yml file found. Skip galaxy install process.\n
139	10	2025-10-10 08:00:44.162824	[0;31mERROR! 'ansible.builtin.shell' is not a valid attribute for a Play[0m
140	10	2025-10-10 08:00:44.16286	[0;31m[0m
141	10	2025-10-10 08:00:44.162994	[0;31mThe error appears to be in '/home/semaphore/kompose.yml': line 1, column 3, but may[0m
142	10	2025-10-10 08:00:44.163027	[0;31mbe elsewhere in the file depending on the exact syntax problem.[0m
143	10	2025-10-10 08:00:44.163033	[0;31m[0m
144	10	2025-10-10 08:00:44.163035	[0;31mThe offending line appears to be:[0m
145	10	2025-10-10 08:00:44.163041	[0;31m[0m
146	10	2025-10-10 08:00:44.163054	[0;31m[0m
147	10	2025-10-10 08:00:44.163057	[0;31m- name: Run kompose.sh with args[0m
148	10	2025-10-10 08:00:44.163059	[0;31m  ^ here[0m
149	10	2025-10-10 08:00:44.21257	Failed to run task: exit status 4
150	11	2025-10-10 08:01:53.660874	Task 11 added to queue
151	11	2025-10-10 08:01:53.679529	Started: 11
152	11	2025-10-10 08:01:53.67955	Run TaskRunner with template: Run kompose.sh with args\n
153	11	2025-10-10 08:01:53.699338	Preparing: 11
154	11	2025-10-10 08:01:53.69942	installing static inventory
155	11	2025-10-10 08:01:53.699545	No /home/semaphore/collections/requirements.yml file found. Skip galaxy install process.\n
156	11	2025-10-10 08:01:53.699563	No /home/semaphore/requirements.yml file found. Skip galaxy install process.\n
157	11	2025-10-10 08:01:53.699574	No /home/semaphore/collections/requirements.yml file found. Skip galaxy install process.\n
158	11	2025-10-10 08:01:53.699579	No /home/semaphore/requirements.yml file found. Skip galaxy install process.\n
159	11	2025-10-10 08:01:53.699591	No /home/semaphore/roles/requirements.yml file found. Skip galaxy install process.\n
160	11	2025-10-10 08:01:53.699596	No /home/semaphore/requirements.yml file found. Skip galaxy install process.\n
161	11	2025-10-10 08:01:53.699602	No /home/semaphore/roles/requirements.yml file found. Skip galaxy install process.\n
162	11	2025-10-10 08:01:53.699606	No /home/semaphore/requirements.yml file found. Skip galaxy install process.\n
163	11	2025-10-10 08:01:55.69541	[0;31mERROR! 'shell' is not a valid attribute for a Play[0m
164	11	2025-10-10 08:01:55.695448	[0;31m[0m
165	11	2025-10-10 08:01:55.69548	[0;31mThe error appears to be in '/home/semaphore/kompose.yml': line 1, column 3, but may[0m
166	11	2025-10-10 08:01:55.695503	[0;31mbe elsewhere in the file depending on the exact syntax problem.[0m
167	11	2025-10-10 08:01:55.69551	[0;31m[0m
168	11	2025-10-10 08:01:55.695512	[0;31mThe offending line appears to be:[0m
169	11	2025-10-10 08:01:55.695517	[0;31m[0m
170	11	2025-10-10 08:01:55.695519	[0;31m[0m
171	11	2025-10-10 08:01:55.695521	[0;31m- name: Run kompose.sh with args[0m
172	11	2025-10-10 08:01:55.695523	[0;31m  ^ here[0m
173	11	2025-10-10 08:01:55.758432	Failed to run task: exit status 4
174	12	2025-10-10 08:03:20.138485	Task 12 added to queue
175	12	2025-10-10 08:03:20.146304	Started: 12
176	12	2025-10-10 08:03:20.146326	Run TaskRunner with template: Run kompose.sh with args\n
177	12	2025-10-10 08:03:20.148357	Preparing: 12
178	12	2025-10-10 08:03:20.148468	installing static inventory
179	12	2025-10-10 08:03:20.148585	No /home/semaphore/collections/requirements.yml file found. Skip galaxy install process.\n
180	12	2025-10-10 08:03:20.148613	No /home/semaphore/requirements.yml file found. Skip galaxy install process.\n
181	12	2025-10-10 08:03:20.148622	No /home/semaphore/collections/requirements.yml file found. Skip galaxy install process.\n
182	12	2025-10-10 08:03:20.14863	No /home/semaphore/requirements.yml file found. Skip galaxy install process.\n
183	12	2025-10-10 08:03:20.148638	No /home/semaphore/roles/requirements.yml file found. Skip galaxy install process.\n
184	12	2025-10-10 08:03:20.148674	No /home/semaphore/requirements.yml file found. Skip galaxy install process.\n
185	12	2025-10-10 08:03:20.148679	No /home/semaphore/roles/requirements.yml file found. Skip galaxy install process.\n
186	12	2025-10-10 08:03:20.148684	No /home/semaphore/requirements.yml file found. Skip galaxy install process.\n
187	12	2025-10-10 08:03:21.533775	[0;31mERROR! the field 'hosts' is required but was not set[0m
188	12	2025-10-10 08:03:21.591763	Failed to run task: exit status 4
189	13	2025-10-10 08:04:09.449956	Task 13 added to queue
190	13	2025-10-10 08:04:09.459248	Started: 13
191	13	2025-10-10 08:04:09.45927	Run TaskRunner with template: Run kompose.sh with args\n
192	13	2025-10-10 08:04:09.460949	Preparing: 13
193	13	2025-10-10 08:04:09.461032	installing static inventory
194	13	2025-10-10 08:04:09.461257	No /home/semaphore/collections/requirements.yml file found. Skip galaxy install process.\n
195	13	2025-10-10 08:04:09.46128	No /home/semaphore/requirements.yml file found. Skip galaxy install process.\n
196	13	2025-10-10 08:04:09.461291	No /home/semaphore/collections/requirements.yml file found. Skip galaxy install process.\n
197	13	2025-10-10 08:04:09.461296	No /home/semaphore/requirements.yml file found. Skip galaxy install process.\n
198	13	2025-10-10 08:04:09.461305	No /home/semaphore/roles/requirements.yml file found. Skip galaxy install process.\n
199	13	2025-10-10 08:04:09.46131	No /home/semaphore/requirements.yml file found. Skip galaxy install process.\n
200	13	2025-10-10 08:04:09.461315	No /home/semaphore/roles/requirements.yml file found. Skip galaxy install process.\n
201	13	2025-10-10 08:04:09.461319	No /home/semaphore/requirements.yml file found. Skip galaxy install process.\n
202	13	2025-10-10 08:04:11.561287	
203	13	2025-10-10 08:04:11.561332	PLAY [all] *********************************************************************
204	13	2025-10-10 08:04:11.601905	
205	13	2025-10-10 08:04:11.601933	TASK [Gathering Facts] *********************************************************
206	13	2025-10-10 08:04:11.632425	[1;31mfatal: [host.docker.internal]: UNREACHABLE! => changed=false [0m
207	13	2025-10-10 08:04:11.632472	[1;31m  msg: 'Failed to connect to the host via ssh: ssh: Could not resolve hostname host.docker.internal: Name does not resolve'[0m
208	13	2025-10-10 08:04:11.632491	[1;31m  unreachable: true[0m
209	13	2025-10-10 08:04:11.632925	
210	13	2025-10-10 08:04:11.632942	PLAY RECAP *********************************************************************
211	13	2025-10-10 08:04:11.635002	[0;31mhost.docker.internal[0m       : ok=0    changed=0    [1;31munreachable=1   [0m failed=0    skipped=0    rescued=0    ignored=0   
212	13	2025-10-10 08:04:11.635016	
213	13	2025-10-10 08:04:11.706521	Failed to run task: exit status 4
214	14	2025-10-10 08:05:43.669919	Task 14 added to queue
215	14	2025-10-10 08:05:43.677307	Started: 14
216	14	2025-10-10 08:05:43.677333	Run TaskRunner with template: Run kompose.sh with args\n
217	14	2025-10-10 08:05:43.678825	Preparing: 14
218	14	2025-10-10 08:05:43.678913	installing static inventory
219	14	2025-10-10 08:05:43.67907	No /home/semaphore/collections/requirements.yml file found. Skip galaxy install process.\n
220	14	2025-10-10 08:05:43.679092	No /home/semaphore/requirements.yml file found. Skip galaxy install process.\n
221	14	2025-10-10 08:05:43.679103	No /home/semaphore/collections/requirements.yml file found. Skip galaxy install process.\n
222	14	2025-10-10 08:05:43.679204	No /home/semaphore/requirements.yml file found. Skip galaxy install process.\n
223	14	2025-10-10 08:05:43.679225	No /home/semaphore/roles/requirements.yml file found. Skip galaxy install process.\n
224	14	2025-10-10 08:05:43.679233	No /home/semaphore/requirements.yml file found. Skip galaxy install process.\n
225	14	2025-10-10 08:05:43.679239	No /home/semaphore/roles/requirements.yml file found. Skip galaxy install process.\n
226	14	2025-10-10 08:05:43.679244	No /home/semaphore/requirements.yml file found. Skip galaxy install process.\n
227	14	2025-10-10 08:05:45.018017	
228	14	2025-10-10 08:05:45.018054	PLAY [all] *********************************************************************
229	14	2025-10-10 08:05:45.053441	
230	14	2025-10-10 08:05:45.05346	TASK [Gathering Facts] *********************************************************
231	14	2025-10-10 08:05:48.844444	[1;35m[WARNING]: Platform linux on host host.docker.internal is using the discovered[0m
232	14	2025-10-10 08:05:48.844518	[1;35mPython interpreter at /usr/bin/python3.13, but future installation of another[0m
233	14	2025-10-10 08:05:48.844536	[1;35mPython interpreter could change the meaning of that path. See[0m
234	14	2025-10-10 08:05:48.844539	[1;35mhttps://docs.ansible.com/ansible-[0m
235	14	2025-10-10 08:05:48.844545	[1;35mcore/2.18/reference_appendices/interpreter_discovery.html for more information.[0m
236	14	2025-10-10 08:05:48.844491	[0;32mok: [host.docker.internal][0m
237	14	2025-10-10 08:05:48.851561	
238	14	2025-10-10 08:05:48.851586	TASK [Run kompose.sh with args] ************************************************
239	14	2025-10-10 08:05:49.030269	[0;31mfatal: [host.docker.internal]: FAILED! => [0m
240	14	2025-10-10 08:05:49.030318	[0;31m  msg: Missing sudo password[0m
241	14	2025-10-10 08:05:49.031221	
242	14	2025-10-10 08:05:49.03125	PLAY RECAP *********************************************************************
243	14	2025-10-10 08:05:49.031307	[0;31mhost.docker.internal[0m       : [0;32mok=1   [0m changed=0    unreachable=0    [0;31mfailed=1   [0m skipped=0    rescued=0    ignored=0   
244	14	2025-10-10 08:05:49.031336	
245	14	2025-10-10 08:05:49.097625	Failed to run task: exit status 2
246	15	2025-10-10 08:07:07.154511	Task 15 added to queue
247	15	2025-10-10 08:07:07.162496	Started: 15
248	15	2025-10-10 08:07:07.16252	Run TaskRunner with template: Run kompose.sh with args\n
249	15	2025-10-10 08:07:07.164364	Preparing: 15
250	15	2025-10-10 08:07:07.164434	installing static inventory
251	15	2025-10-10 08:07:07.164581	No /home/semaphore/collections/requirements.yml file found. Skip galaxy install process.\n
360	18	2025-10-10 09:27:08.337352	Started: 18
252	15	2025-10-10 08:07:07.164601	No /home/semaphore/requirements.yml file found. Skip galaxy install process.\n
253	15	2025-10-10 08:07:07.164608	No /home/semaphore/collections/requirements.yml file found. Skip galaxy install process.\n
254	15	2025-10-10 08:07:07.16462	No /home/semaphore/requirements.yml file found. Skip galaxy install process.\n
255	15	2025-10-10 08:07:07.164633	No /home/semaphore/roles/requirements.yml file found. Skip galaxy install process.\n
256	15	2025-10-10 08:07:07.16464	No /home/semaphore/requirements.yml file found. Skip galaxy install process.\n
257	15	2025-10-10 08:07:07.164646	No /home/semaphore/roles/requirements.yml file found. Skip galaxy install process.\n
258	15	2025-10-10 08:07:07.164652	No /home/semaphore/requirements.yml file found. Skip galaxy install process.\n
259	15	2025-10-10 08:07:08.689133	
260	15	2025-10-10 08:07:08.689175	PLAY [all] *********************************************************************
261	15	2025-10-10 08:07:08.728576	
262	15	2025-10-10 08:07:08.728602	TASK [Gathering Facts] *********************************************************
263	15	2025-10-10 08:07:11.375299	[1;35m[WARNING]: Platform linux on host host.docker.internal is using the discovered[0m
264	15	2025-10-10 08:07:11.375341	[0;32mok: [host.docker.internal][0m
265	15	2025-10-10 08:07:11.375355	[1;35mPython interpreter at /usr/bin/python3.13, but future installation of another[0m
266	15	2025-10-10 08:07:11.375393	[1;35mPython interpreter could change the meaning of that path. See[0m
267	15	2025-10-10 08:07:11.375425	[1;35mhttps://docs.ansible.com/ansible-[0m
268	15	2025-10-10 08:07:11.375436	[1;35mcore/2.18/reference_appendices/interpreter_discovery.html for more information.[0m
269	15	2025-10-10 08:07:11.38163	
270	15	2025-10-10 08:07:11.381642	TASK [Run kompose.sh with args] ************************************************
271	15	2025-10-10 08:07:11.631421	[0;31mfatal: [host.docker.internal]: FAILED! => changed=true [0m
272	15	2025-10-10 08:07:11.631465	[0;31m  cmd: ./kompose.sh "*" config[0m
273	15	2025-10-10 08:07:11.631512	[0;31m  delta: '0:00:00.003564'[0m
274	15	2025-10-10 08:07:11.631544	[0;31m  end: '2025-10-10 08:07:11.606181'[0m
275	15	2025-10-10 08:07:11.631557	[0;31m  msg: non-zero return code[0m
276	15	2025-10-10 08:07:11.631559	[0;31m  rc: 127[0m
277	15	2025-10-10 08:07:11.631563	[0;31m  start: '2025-10-10 08:07:11.602617'[0m
278	15	2025-10-10 08:07:11.631565	[0;31m  stderr: '/bin/bash: line 1: ./kompose.sh: No such file or directory'[0m
279	15	2025-10-10 08:07:11.631568	[0;31m  stderr_lines: <omitted>[0m
280	15	2025-10-10 08:07:11.631571	[0;31m  stdout: ''[0m
281	15	2025-10-10 08:07:11.631573	[0;31m  stdout_lines: <omitted>[0m
282	15	2025-10-10 08:07:11.632131	
283	15	2025-10-10 08:07:11.632148	PLAY RECAP *********************************************************************
284	15	2025-10-10 08:07:11.632211	[0;31mhost.docker.internal[0m       : [0;32mok=1   [0m changed=0    unreachable=0    [0;31mfailed=1   [0m skipped=0    rescued=0    ignored=0   
285	15	2025-10-10 08:07:11.632221	
286	15	2025-10-10 08:07:11.701264	Failed to run task: exit status 2
287	16	2025-10-10 08:09:13.952341	Task 16 added to queue
288	16	2025-10-10 08:09:13.954699	Started: 16
289	16	2025-10-10 08:09:13.954724	Run TaskRunner with template: Run kompose.sh with args\n
290	16	2025-10-10 08:09:13.955985	Preparing: 16
291	16	2025-10-10 08:09:13.956076	installing static inventory
292	16	2025-10-10 08:09:13.956228	No /home/semaphore/collections/requirements.yml file found. Skip galaxy install process.\n
293	16	2025-10-10 08:09:13.956266	No /home/semaphore/requirements.yml file found. Skip galaxy install process.\n
294	16	2025-10-10 08:09:13.9563	No /home/semaphore/collections/requirements.yml file found. Skip galaxy install process.\n
295	16	2025-10-10 08:09:13.956316	No /home/semaphore/requirements.yml file found. Skip galaxy install process.\n
296	16	2025-10-10 08:09:13.956345	No /home/semaphore/roles/requirements.yml file found. Skip galaxy install process.\n
297	16	2025-10-10 08:09:13.956359	No /home/semaphore/requirements.yml file found. Skip galaxy install process.\n
298	16	2025-10-10 08:09:13.956378	No /home/semaphore/roles/requirements.yml file found. Skip galaxy install process.\n
299	16	2025-10-10 08:09:13.956392	No /home/semaphore/requirements.yml file found. Skip galaxy install process.\n
300	16	2025-10-10 08:09:15.306496	
301	16	2025-10-10 08:09:15.306534	PLAY [all] *********************************************************************
302	16	2025-10-10 08:09:15.342194	
303	16	2025-10-10 08:09:15.342216	TASK [Gathering Facts] *********************************************************
304	16	2025-10-10 08:09:21.075776	[1;35m[WARNING]: Platform linux on host host.docker.internal is using the discovered[0m
305	16	2025-10-10 08:09:21.075812	[0;32mok: [host.docker.internal][0m
306	16	2025-10-10 08:09:21.075823	[1;35mPython interpreter at /usr/bin/python3.13, but future installation of another[0m
307	16	2025-10-10 08:09:21.075918	[1;35mPython interpreter could change the meaning of that path. See[0m
308	16	2025-10-10 08:09:21.075946	[1;35mhttps://docs.ansible.com/ansible-[0m
309	16	2025-10-10 08:09:21.075966	[1;35mcore/2.18/reference_appendices/interpreter_discovery.html for more information.[0m
310	16	2025-10-10 08:09:21.082383	
311	16	2025-10-10 08:09:21.082407	TASK [Run kompose.sh with args] ************************************************
312	16	2025-10-10 08:09:22.793388	[0;33mchanged: [host.docker.internal][0m
313	16	2025-10-10 08:09:22.794282	
314	16	2025-10-10 08:09:22.794307	PLAY RECAP *********************************************************************
315	16	2025-10-10 08:09:22.794325	[0;33mhost.docker.internal[0m       : [0;32mok=2   [0m [0;33mchanged=1   [0m unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
316	16	2025-10-10 08:09:22.794334	
317	17	2025-10-10 09:19:54.84643	Task 17 added to queue
318	17	2025-10-10 09:19:54.848481	Started: 17
319	17	2025-10-10 09:19:54.848502	Run TaskRunner with template: Run kompose.sh with args\n
320	17	2025-10-10 09:19:54.850262	Preparing: 17
321	17	2025-10-10 09:19:54.850317	installing static inventory
322	17	2025-10-10 09:19:54.850502	No /home/semaphore/collections/requirements.yml file found. Skip galaxy install process.\n
323	17	2025-10-10 09:19:54.850525	No /home/semaphore/requirements.yml file found. Skip galaxy install process.\n
324	17	2025-10-10 09:19:54.850539	No /home/semaphore/collections/requirements.yml file found. Skip galaxy install process.\n
325	17	2025-10-10 09:19:54.850544	No /home/semaphore/requirements.yml file found. Skip galaxy install process.\n
326	17	2025-10-10 09:19:54.85055	No /home/semaphore/roles/requirements.yml file found. Skip galaxy install process.\n
327	17	2025-10-10 09:19:54.850554	No /home/semaphore/requirements.yml file found. Skip galaxy install process.\n
328	17	2025-10-10 09:19:54.850559	No /home/semaphore/roles/requirements.yml file found. Skip galaxy install process.\n
329	17	2025-10-10 09:19:54.850562	No /home/semaphore/requirements.yml file found. Skip galaxy install process.\n
330	17	2025-10-10 09:19:55.305815	
331	17	2025-10-10 09:19:55.305846	PLAY [all] *********************************************************************
332	17	2025-10-10 09:19:55.317424	
333	17	2025-10-10 09:19:55.317433	TASK [Gathering Facts] *********************************************************
334	17	2025-10-10 09:19:56.884327	[1;35m[WARNING]: Platform linux on host host.docker.internal is using the discovered[0m
335	17	2025-10-10 09:19:56.884376	[1;35mPython interpreter at /usr/bin/python3.13, but future installation of another[0m
336	17	2025-10-10 09:19:56.884385	[0;32mok: [host.docker.internal][0m
337	17	2025-10-10 09:19:56.884407	[1;35mPython interpreter could change the meaning of that path. See[0m
338	17	2025-10-10 09:19:56.88443	[1;35mhttps://docs.ansible.com/ansible-[0m
339	17	2025-10-10 09:19:56.884435	[1;35mcore/2.18/reference_appendices/interpreter_discovery.html for more information.[0m
340	17	2025-10-10 09:19:56.889915	
341	17	2025-10-10 09:19:56.889924	TASK [Run kompose.sh with args] ************************************************
342	17	2025-10-10 09:19:56.899709	[0;31mfatal: [host.docker.internal]: FAILED! => [0m
343	17	2025-10-10 09:19:56.899761	[0;31m  msg: |-[0m
344	17	2025-10-10 09:19:56.899793	[0;31m    The task includes an option with an undefined variable.. 'kompose_filter' is undefined[0m
345	17	2025-10-10 09:19:56.899804	[0;31m  [0m
346	17	2025-10-10 09:19:56.899817	[0;31m    The error appears to be in '/home/semaphore/kompose.yml': line 3, column 5, but may[0m
347	17	2025-10-10 09:19:56.899823	[0;31m    be elsewhere in the file depending on the exact syntax problem.[0m
348	17	2025-10-10 09:19:56.899827	[0;31m  [0m
349	17	2025-10-10 09:19:56.89983	[0;31m    The offending line appears to be:[0m
350	17	2025-10-10 09:19:56.899839	[0;31m  [0m
351	17	2025-10-10 09:19:56.89984	[0;31m      tasks:[0m
352	17	2025-10-10 09:19:56.899843	[0;31m      - name: Run kompose.sh with args[0m
353	17	2025-10-10 09:19:56.899845	[0;31m        ^ here[0m
354	17	2025-10-10 09:19:56.900258	
355	17	2025-10-10 09:19:56.900269	PLAY RECAP *********************************************************************
356	17	2025-10-10 09:19:56.900304	[0;31mhost.docker.internal[0m       : [0;32mok=1   [0m changed=0    unreachable=0    [0;31mfailed=1   [0m skipped=0    rescued=0    ignored=0   
357	17	2025-10-10 09:19:56.900313	
358	17	2025-10-10 09:19:56.957661	Failed to run task: exit status 2
359	18	2025-10-10 09:27:08.335474	Task 18 added to queue
361	18	2025-10-10 09:27:08.337373	Run TaskRunner with template: Run kompose.sh "*" up -d\n
362	18	2025-10-10 09:27:08.339118	Preparing: 18
363	18	2025-10-10 09:27:08.33917	installing static inventory
364	18	2025-10-10 09:27:08.339255	No /home/semaphore/collections/requirements.yml file found. Skip galaxy install process.\n
365	18	2025-10-10 09:27:08.339273	No /home/semaphore/requirements.yml file found. Skip galaxy install process.\n
366	18	2025-10-10 09:27:08.339286	No /home/semaphore/collections/requirements.yml file found. Skip galaxy install process.\n
367	18	2025-10-10 09:27:08.33929	No /home/semaphore/requirements.yml file found. Skip galaxy install process.\n
368	18	2025-10-10 09:27:08.339295	No /home/semaphore/roles/requirements.yml file found. Skip galaxy install process.\n
369	18	2025-10-10 09:27:08.3393	No /home/semaphore/requirements.yml file found. Skip galaxy install process.\n
370	18	2025-10-10 09:27:08.339304	No /home/semaphore/roles/requirements.yml file found. Skip galaxy install process.\n
371	18	2025-10-10 09:27:08.339309	No /home/semaphore/requirements.yml file found. Skip galaxy install process.\n
372	18	2025-10-10 09:27:08.828087	
373	18	2025-10-10 09:27:08.828127	PLAY [all] *********************************************************************
374	18	2025-10-10 09:27:08.83922	
375	18	2025-10-10 09:27:08.839241	TASK [Gathering Facts] *********************************************************
376	18	2025-10-10 09:27:11.413507	[1;35m[WARNING]: Platform linux on host host.docker.internal is using the discovered[0m
377	18	2025-10-10 09:27:11.413541	[1;35mPython interpreter at /usr/bin/python3.13, but future installation of another[0m
378	18	2025-10-10 09:27:11.413575	[0;32mok: [host.docker.internal][0m
379	18	2025-10-10 09:27:11.413588	[1;35mPython interpreter could change the meaning of that path. See[0m
380	18	2025-10-10 09:27:11.413627	[1;35mhttps://docs.ansible.com/ansible-[0m
381	18	2025-10-10 09:27:11.413633	[1;35mcore/2.18/reference_appendices/interpreter_discovery.html for more information.[0m
382	18	2025-10-10 09:27:11.419476	
383	18	2025-10-10 09:27:11.419486	TASK [Run kompose.sh with args] ************************************************
384	18	2025-10-10 09:28:41.791789	[0;33mchanged: [host.docker.internal][0m
385	18	2025-10-10 09:28:41.792615	
386	18	2025-10-10 09:28:41.792663	PLAY RECAP *********************************************************************
387	18	2025-10-10 09:28:41.792812	[0;33mhost.docker.internal[0m       : [0;32mok=2   [0m [0;33mchanged=1   [0m unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
388	18	2025-10-10 09:28:41.792829	
389	19	2025-10-10 15:17:00.502904	Task 19 added to queue
390	19	2025-10-10 15:17:00.510136	Started: 19
391	19	2025-10-10 15:17:00.510159	Run TaskRunner with template: Run kompose.sh "*" up -d\n
392	19	2025-10-10 15:17:00.511529	Preparing: 19
393	19	2025-10-10 15:17:00.511595	installing static inventory
394	19	2025-10-10 15:17:00.512192	No /home/semaphore/collections/requirements.yml file found. Skip galaxy install process.\n
395	19	2025-10-10 15:17:00.51222	No /home/semaphore/requirements.yml file found. Skip galaxy install process.\n
396	19	2025-10-10 15:17:00.512233	No /home/semaphore/collections/requirements.yml file found. Skip galaxy install process.\n
397	19	2025-10-10 15:17:00.512238	No /home/semaphore/requirements.yml file found. Skip galaxy install process.\n
398	19	2025-10-10 15:17:00.512249	No /home/semaphore/roles/requirements.yml file found. Skip galaxy install process.\n
399	19	2025-10-10 15:17:00.512253	No /home/semaphore/requirements.yml file found. Skip galaxy install process.\n
400	19	2025-10-10 15:17:00.512258	No /home/semaphore/roles/requirements.yml file found. Skip galaxy install process.\n
401	19	2025-10-10 15:17:00.512262	No /home/semaphore/requirements.yml file found. Skip galaxy install process.\n
402	19	2025-10-10 15:17:00.746767	[0;31mERROR! the playbook: kompose.yml could not be found[0m
403	19	2025-10-10 15:17:00.775299	Failed to run task: exit status 1
404	20	2025-10-10 15:22:43.685557	Task 20 added to queue
405	20	2025-10-10 15:22:43.687222	Started: 20
406	20	2025-10-10 15:22:43.687247	Run TaskRunner with template: Run kompose.sh "*" up -d\n
407	20	2025-10-10 15:22:43.688473	Preparing: 20
408	20	2025-10-10 15:22:43.688525	installing static inventory
409	20	2025-10-10 15:22:43.688608	No /home/semaphore/collections/requirements.yml file found. Skip galaxy install process.\n
410	20	2025-10-10 15:22:43.688623	No /home/semaphore/requirements.yml file found. Skip galaxy install process.\n
411	20	2025-10-10 15:22:43.688635	No /home/semaphore/collections/requirements.yml file found. Skip galaxy install process.\n
412	20	2025-10-10 15:22:43.688639	No /home/semaphore/requirements.yml file found. Skip galaxy install process.\n
413	20	2025-10-10 15:22:43.688645	No /home/semaphore/roles/requirements.yml file found. Skip galaxy install process.\n
414	20	2025-10-10 15:22:43.688649	No /home/semaphore/requirements.yml file found. Skip galaxy install process.\n
415	20	2025-10-10 15:22:43.688656	No /home/semaphore/roles/requirements.yml file found. Skip galaxy install process.\n
416	20	2025-10-10 15:22:43.68866	No /home/semaphore/requirements.yml file found. Skip galaxy install process.\n
417	20	2025-10-10 15:22:43.897193	[0;31mERROR! the playbook: kompose.yml could not be found[0m
418	20	2025-10-10 15:22:43.924186	Failed to run task: exit status 1
419	21	2025-10-10 15:24:38.872119	Task 21 added to queue
420	21	2025-10-10 15:24:38.879409	Started: 21
421	21	2025-10-10 15:24:38.879429	Run TaskRunner with template: Run kompose.sh "*" up -d\n
422	21	2025-10-10 15:24:38.881125	Preparing: 21
423	21	2025-10-10 15:24:38.881173	installing static inventory
424	21	2025-10-10 15:24:38.881294	No /home/semaphore/collections/requirements.yml file found. Skip galaxy install process.\n
425	21	2025-10-10 15:24:38.881321	No /home/semaphore/requirements.yml file found. Skip galaxy install process.\n
426	21	2025-10-10 15:24:38.881333	No /home/semaphore/collections/requirements.yml file found. Skip galaxy install process.\n
427	21	2025-10-10 15:24:38.881338	No /home/semaphore/requirements.yml file found. Skip galaxy install process.\n
428	21	2025-10-10 15:24:38.881348	No /home/semaphore/roles/requirements.yml file found. Skip galaxy install process.\n
429	21	2025-10-10 15:24:38.881352	No /home/semaphore/requirements.yml file found. Skip galaxy install process.\n
430	21	2025-10-10 15:24:38.881356	No /home/semaphore/roles/requirements.yml file found. Skip galaxy install process.\n
431	21	2025-10-10 15:24:38.88136	No /home/semaphore/requirements.yml file found. Skip galaxy install process.\n
432	21	2025-10-10 15:24:40.210954	
433	21	2025-10-10 15:24:40.211036	PLAY [all] *********************************************************************
434	21	2025-10-10 15:24:40.246501	
435	21	2025-10-10 15:24:40.24657	TASK [Gathering Facts] *********************************************************
436	21	2025-10-10 15:24:42.992184	[0;32mok: [host.docker.internal][0m
437	21	2025-10-10 15:24:42.992159	[1;35m[WARNING]: Platform linux on host host.docker.internal is using the discovered[0m
438	21	2025-10-10 15:24:42.992224	[1;35mPython interpreter at /usr/bin/python3.13, but future installation of another[0m
439	21	2025-10-10 15:24:42.992289	[1;35mPython interpreter could change the meaning of that path. See[0m
440	21	2025-10-10 15:24:42.9923	[1;35mhttps://docs.ansible.com/ansible-[0m
441	21	2025-10-10 15:24:42.992303	[1;35mcore/2.18/reference_appendices/interpreter_discovery.html for more information.[0m
442	21	2025-10-10 15:24:42.998593	
443	21	2025-10-10 15:24:42.998617	TASK [Run kompose.sh with args] ************************************************
444	21	2025-10-10 15:24:47.543113	[0;33mchanged: [host.docker.internal][0m
445	21	2025-10-10 15:24:47.544113	
446	21	2025-10-10 15:24:47.544131	PLAY RECAP *********************************************************************
447	21	2025-10-10 15:24:47.544202	[0;33mhost.docker.internal[0m       : [0;32mok=2   [0m [0;33mchanged=1   [0m unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
448	21	2025-10-10 15:24:47.544215	
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
1	2025-10-07 17:38:01	admin	Admin	valknar@pivoine.art	$2a$11$stw8dPRjaP6YWz9uE/tpgO2DpwlVdYqf59ByOJW84SLLlyPU3Utii	f	f	t	f
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
trylijuswo_7hf1g9boqs-y3ftzdbhbmcw6da93ta7e=	2025-10-10 09:02:53	f	1
\.


--
-- Data for Name: user__totp; Type: TABLE DATA; Schema: public; Owner: valknar
--

COPY public.user__totp (id, user_id, url, recovery_hash, created) FROM stdin;
\.


--
-- Name: access_key_id_seq; Type: SEQUENCE SET; Schema: public; Owner: valknar
--

SELECT pg_catalog.setval('public.access_key_id_seq', 3, true);


--
-- Name: event_id_seq; Type: SEQUENCE SET; Schema: public; Owner: valknar
--

SELECT pg_catalog.setval('public.event_id_seq', 95, true);


--
-- Name: project__environment_id_seq; Type: SEQUENCE SET; Schema: public; Owner: valknar
--

SELECT pg_catalog.setval('public.project__environment_id_seq', 2, true);


--
-- Name: project__integration_alias_id_seq; Type: SEQUENCE SET; Schema: public; Owner: valknar
--

SELECT pg_catalog.setval('public.project__integration_alias_id_seq', 4, true);


--
-- Name: project__integration_extract_value_id_seq; Type: SEQUENCE SET; Schema: public; Owner: valknar
--

SELECT pg_catalog.setval('public.project__integration_extract_value_id_seq', 1, false);


--
-- Name: project__integration_id_seq; Type: SEQUENCE SET; Schema: public; Owner: valknar
--

SELECT pg_catalog.setval('public.project__integration_id_seq', 1, true);


--
-- Name: project__integration_matcher_id_seq; Type: SEQUENCE SET; Schema: public; Owner: valknar
--

SELECT pg_catalog.setval('public.project__integration_matcher_id_seq', 1, false);


--
-- Name: project__inventory_id_seq; Type: SEQUENCE SET; Schema: public; Owner: valknar
--

SELECT pg_catalog.setval('public.project__inventory_id_seq', 4, true);


--
-- Name: project__repository_id_seq; Type: SEQUENCE SET; Schema: public; Owner: valknar
--

SELECT pg_catalog.setval('public.project__repository_id_seq', 2, true);


--
-- Name: project__schedule_id_seq1; Type: SEQUENCE SET; Schema: public; Owner: valknar
--

SELECT pg_catalog.setval('public.project__schedule_id_seq1', 1, true);


--
-- Name: project__secret_storage_id_seq; Type: SEQUENCE SET; Schema: public; Owner: valknar
--

SELECT pg_catalog.setval('public.project__secret_storage_id_seq', 1, false);


--
-- Name: project__task_params_id_seq; Type: SEQUENCE SET; Schema: public; Owner: valknar
--

SELECT pg_catalog.setval('public.project__task_params_id_seq', 1, true);


--
-- Name: project__template_id_seq; Type: SEQUENCE SET; Schema: public; Owner: valknar
--

SELECT pg_catalog.setval('public.project__template_id_seq', 10, true);


--
-- Name: project__template_vault_id_seq; Type: SEQUENCE SET; Schema: public; Owner: valknar
--

SELECT pg_catalog.setval('public.project__template_vault_id_seq', 2, true);


--
-- Name: project__terraform_inventory_state_id_seq; Type: SEQUENCE SET; Schema: public; Owner: valknar
--

SELECT pg_catalog.setval('public.project__terraform_inventory_state_id_seq', 1, false);


--
-- Name: project__view_id_seq; Type: SEQUENCE SET; Schema: public; Owner: valknar
--

SELECT pg_catalog.setval('public.project__view_id_seq', 4, true);


--
-- Name: project_id_seq; Type: SEQUENCE SET; Schema: public; Owner: valknar
--

SELECT pg_catalog.setval('public.project_id_seq', 1, true);


--
-- Name: runner_id_seq; Type: SEQUENCE SET; Schema: public; Owner: valknar
--

SELECT pg_catalog.setval('public.runner_id_seq', 1, false);


--
-- Name: session_id_seq1; Type: SEQUENCE SET; Schema: public; Owner: valknar
--

SELECT pg_catalog.setval('public.session_id_seq1', 3, true);


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

SELECT pg_catalog.setval('public.task__output_id_seq', 448, true);


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

SELECT pg_catalog.setval('public.task_id_seq', 21, true);


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

\unrestrict oKvkA5N76F8A7rGVCgFR11FJ0l9DM2E0bsqePPNNerUnn0LhCitjzAtSdrrm8m5

