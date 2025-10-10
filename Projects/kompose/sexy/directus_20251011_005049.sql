--
-- PostgreSQL database dump
--

\restrict kHaSmq4pzphfyKS1cgbEfBxXPPJEZNokzfZYTVTz0MdM9wEWRpxGHentE1L9eUf

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

--
-- Name: topology; Type: SCHEMA; Schema: -; Owner: valknar
--

CREATE SCHEMA topology;


ALTER SCHEMA topology OWNER TO valknar;

--
-- Name: SCHEMA topology; Type: COMMENT; Schema: -; Owner: valknar
--

COMMENT ON SCHEMA topology IS 'PostGIS Topology schema';


--
-- Name: hstore; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS hstore WITH SCHEMA public;


--
-- Name: EXTENSION hstore; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION hstore IS 'data type for storing sets of (key, value) pairs';


--
-- Name: st_asbinary(text); Type: FUNCTION; Schema: public; Owner: valknar
--

CREATE FUNCTION public.st_asbinary(text) RETURNS bytea
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$ SELECT ST_AsBinary($1::geometry);$_$;


ALTER FUNCTION public.st_asbinary(text) OWNER TO valknar;

--
-- Name: st_astext(bytea); Type: FUNCTION; Schema: public; Owner: valknar
--

CREATE FUNCTION public.st_astext(bytea) RETURNS text
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$ SELECT ST_AsText($1::geometry);$_$;


ALTER FUNCTION public.st_astext(bytea) OWNER TO valknar;

--
-- Name: gist_geometry_ops; Type: OPERATOR FAMILY; Schema: public; Owner: valknar
--

CREATE OPERATOR FAMILY public.gist_geometry_ops USING gist;


ALTER OPERATOR FAMILY public.gist_geometry_ops USING gist OWNER TO valknar;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: directus_access; Type: TABLE; Schema: public; Owner: valknar
--

CREATE TABLE public.directus_access (
    id uuid NOT NULL,
    role uuid,
    "user" uuid,
    policy uuid NOT NULL,
    sort integer
);


ALTER TABLE public.directus_access OWNER TO valknar;

--
-- Name: directus_activity; Type: TABLE; Schema: public; Owner: valknar
--

CREATE TABLE public.directus_activity (
    id integer NOT NULL,
    action character varying(45) NOT NULL,
    "user" uuid,
    "timestamp" timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    ip character varying(50),
    user_agent text,
    collection character varying(64) NOT NULL,
    item character varying(255) NOT NULL,
    origin character varying(255)
);


ALTER TABLE public.directus_activity OWNER TO valknar;

--
-- Name: directus_activity_id_seq; Type: SEQUENCE; Schema: public; Owner: valknar
--

CREATE SEQUENCE public.directus_activity_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.directus_activity_id_seq OWNER TO valknar;

--
-- Name: directus_activity_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: valknar
--

ALTER SEQUENCE public.directus_activity_id_seq OWNED BY public.directus_activity.id;


--
-- Name: directus_collections; Type: TABLE; Schema: public; Owner: valknar
--

CREATE TABLE public.directus_collections (
    collection character varying(64) NOT NULL,
    icon character varying(64),
    note text,
    display_template character varying(255),
    hidden boolean DEFAULT false NOT NULL,
    singleton boolean DEFAULT false NOT NULL,
    translations json,
    archive_field character varying(64),
    archive_app_filter boolean DEFAULT true NOT NULL,
    archive_value character varying(255),
    unarchive_value character varying(255),
    sort_field character varying(64),
    accountability character varying(255) DEFAULT 'all'::character varying,
    color character varying(255),
    item_duplication_fields json,
    sort integer,
    "group" character varying(64),
    collapse character varying(255) DEFAULT 'open'::character varying NOT NULL,
    preview_url character varying(255),
    versioning boolean DEFAULT false NOT NULL
);


ALTER TABLE public.directus_collections OWNER TO valknar;

--
-- Name: directus_comments; Type: TABLE; Schema: public; Owner: valknar
--

CREATE TABLE public.directus_comments (
    id uuid NOT NULL,
    collection character varying(64) NOT NULL,
    item character varying(255) NOT NULL,
    comment text NOT NULL,
    date_created timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    date_updated timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    user_created uuid,
    user_updated uuid
);


ALTER TABLE public.directus_comments OWNER TO valknar;

--
-- Name: directus_dashboards; Type: TABLE; Schema: public; Owner: valknar
--

CREATE TABLE public.directus_dashboards (
    id uuid NOT NULL,
    name character varying(255) NOT NULL,
    icon character varying(64) DEFAULT 'dashboard'::character varying NOT NULL,
    note text,
    date_created timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    user_created uuid,
    color character varying(255)
);


ALTER TABLE public.directus_dashboards OWNER TO valknar;

--
-- Name: directus_extensions; Type: TABLE; Schema: public; Owner: valknar
--

CREATE TABLE public.directus_extensions (
    enabled boolean DEFAULT true NOT NULL,
    id uuid NOT NULL,
    folder character varying(255) NOT NULL,
    source character varying(255) NOT NULL,
    bundle uuid
);


ALTER TABLE public.directus_extensions OWNER TO valknar;

--
-- Name: directus_fields; Type: TABLE; Schema: public; Owner: valknar
--

CREATE TABLE public.directus_fields (
    id integer NOT NULL,
    collection character varying(64) NOT NULL,
    field character varying(64) NOT NULL,
    special character varying(64),
    interface character varying(64),
    options json,
    display character varying(64),
    display_options json,
    readonly boolean DEFAULT false NOT NULL,
    hidden boolean DEFAULT false NOT NULL,
    sort integer,
    width character varying(30) DEFAULT 'full'::character varying,
    translations json,
    note text,
    conditions json,
    required boolean DEFAULT false,
    "group" character varying(64),
    validation json,
    validation_message text
);


ALTER TABLE public.directus_fields OWNER TO valknar;

--
-- Name: directus_fields_id_seq; Type: SEQUENCE; Schema: public; Owner: valknar
--

CREATE SEQUENCE public.directus_fields_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.directus_fields_id_seq OWNER TO valknar;

--
-- Name: directus_fields_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: valknar
--

ALTER SEQUENCE public.directus_fields_id_seq OWNED BY public.directus_fields.id;


--
-- Name: directus_files; Type: TABLE; Schema: public; Owner: valknar
--

CREATE TABLE public.directus_files (
    id uuid NOT NULL,
    storage character varying(255) NOT NULL,
    filename_disk character varying(255),
    filename_download character varying(255) NOT NULL,
    title character varying(255),
    type character varying(255),
    folder uuid,
    uploaded_by uuid,
    created_on timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    modified_by uuid,
    modified_on timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    charset character varying(50),
    filesize bigint,
    width integer,
    height integer,
    duration integer,
    embed character varying(200),
    description text,
    location text,
    tags text,
    metadata json,
    focal_point_x integer,
    focal_point_y integer,
    tus_id character varying(64),
    tus_data json,
    uploaded_on timestamp with time zone
);


ALTER TABLE public.directus_files OWNER TO valknar;

--
-- Name: directus_flows; Type: TABLE; Schema: public; Owner: valknar
--

CREATE TABLE public.directus_flows (
    id uuid NOT NULL,
    name character varying(255) NOT NULL,
    icon character varying(64),
    color character varying(255),
    description text,
    status character varying(255) DEFAULT 'active'::character varying NOT NULL,
    trigger character varying(255),
    accountability character varying(255) DEFAULT 'all'::character varying,
    options json,
    operation uuid,
    date_created timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    user_created uuid
);


ALTER TABLE public.directus_flows OWNER TO valknar;

--
-- Name: directus_folders; Type: TABLE; Schema: public; Owner: valknar
--

CREATE TABLE public.directus_folders (
    id uuid NOT NULL,
    name character varying(255) NOT NULL,
    parent uuid
);


ALTER TABLE public.directus_folders OWNER TO valknar;

--
-- Name: directus_migrations; Type: TABLE; Schema: public; Owner: valknar
--

CREATE TABLE public.directus_migrations (
    version character varying(255) NOT NULL,
    name character varying(255) NOT NULL,
    "timestamp" timestamp with time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.directus_migrations OWNER TO valknar;

--
-- Name: directus_notifications; Type: TABLE; Schema: public; Owner: valknar
--

CREATE TABLE public.directus_notifications (
    id integer NOT NULL,
    "timestamp" timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    status character varying(255) DEFAULT 'inbox'::character varying,
    recipient uuid NOT NULL,
    sender uuid,
    subject character varying(255) NOT NULL,
    message text,
    collection character varying(64),
    item character varying(255)
);


ALTER TABLE public.directus_notifications OWNER TO valknar;

--
-- Name: directus_notifications_id_seq; Type: SEQUENCE; Schema: public; Owner: valknar
--

CREATE SEQUENCE public.directus_notifications_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.directus_notifications_id_seq OWNER TO valknar;

--
-- Name: directus_notifications_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: valknar
--

ALTER SEQUENCE public.directus_notifications_id_seq OWNED BY public.directus_notifications.id;


--
-- Name: directus_operations; Type: TABLE; Schema: public; Owner: valknar
--

CREATE TABLE public.directus_operations (
    id uuid NOT NULL,
    name character varying(255),
    key character varying(255) NOT NULL,
    type character varying(255) NOT NULL,
    position_x integer NOT NULL,
    position_y integer NOT NULL,
    options json,
    resolve uuid,
    reject uuid,
    flow uuid NOT NULL,
    date_created timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    user_created uuid
);


ALTER TABLE public.directus_operations OWNER TO valknar;

--
-- Name: directus_panels; Type: TABLE; Schema: public; Owner: valknar
--

CREATE TABLE public.directus_panels (
    id uuid NOT NULL,
    dashboard uuid NOT NULL,
    name character varying(255),
    icon character varying(64) DEFAULT NULL::character varying,
    color character varying(10),
    show_header boolean DEFAULT false NOT NULL,
    note text,
    type character varying(255) NOT NULL,
    position_x integer NOT NULL,
    position_y integer NOT NULL,
    width integer NOT NULL,
    height integer NOT NULL,
    options json,
    date_created timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    user_created uuid
);


ALTER TABLE public.directus_panels OWNER TO valknar;

--
-- Name: directus_permissions; Type: TABLE; Schema: public; Owner: valknar
--

CREATE TABLE public.directus_permissions (
    id integer NOT NULL,
    collection character varying(64) NOT NULL,
    action character varying(10) NOT NULL,
    permissions json,
    validation json,
    presets json,
    fields text,
    policy uuid NOT NULL
);


ALTER TABLE public.directus_permissions OWNER TO valknar;

--
-- Name: directus_permissions_id_seq; Type: SEQUENCE; Schema: public; Owner: valknar
--

CREATE SEQUENCE public.directus_permissions_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.directus_permissions_id_seq OWNER TO valknar;

--
-- Name: directus_permissions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: valknar
--

ALTER SEQUENCE public.directus_permissions_id_seq OWNED BY public.directus_permissions.id;


--
-- Name: directus_policies; Type: TABLE; Schema: public; Owner: valknar
--

CREATE TABLE public.directus_policies (
    id uuid NOT NULL,
    name character varying(100) NOT NULL,
    icon character varying(64) DEFAULT 'badge'::character varying NOT NULL,
    description text,
    ip_access text,
    enforce_tfa boolean DEFAULT false NOT NULL,
    admin_access boolean DEFAULT false NOT NULL,
    app_access boolean DEFAULT false NOT NULL
);


ALTER TABLE public.directus_policies OWNER TO valknar;

--
-- Name: directus_presets; Type: TABLE; Schema: public; Owner: valknar
--

CREATE TABLE public.directus_presets (
    id integer NOT NULL,
    bookmark character varying(255),
    "user" uuid,
    role uuid,
    collection character varying(64),
    search character varying(100),
    layout character varying(100) DEFAULT 'tabular'::character varying,
    layout_query json,
    layout_options json,
    refresh_interval integer,
    filter json,
    icon character varying(64) DEFAULT 'bookmark'::character varying,
    color character varying(255)
);


ALTER TABLE public.directus_presets OWNER TO valknar;

--
-- Name: directus_presets_id_seq; Type: SEQUENCE; Schema: public; Owner: valknar
--

CREATE SEQUENCE public.directus_presets_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.directus_presets_id_seq OWNER TO valknar;

--
-- Name: directus_presets_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: valknar
--

ALTER SEQUENCE public.directus_presets_id_seq OWNED BY public.directus_presets.id;


--
-- Name: directus_relations; Type: TABLE; Schema: public; Owner: valknar
--

CREATE TABLE public.directus_relations (
    id integer NOT NULL,
    many_collection character varying(64) NOT NULL,
    many_field character varying(64) NOT NULL,
    one_collection character varying(64),
    one_field character varying(64),
    one_collection_field character varying(64),
    one_allowed_collections text,
    junction_field character varying(64),
    sort_field character varying(64),
    one_deselect_action character varying(255) DEFAULT 'nullify'::character varying NOT NULL
);


ALTER TABLE public.directus_relations OWNER TO valknar;

--
-- Name: directus_relations_id_seq; Type: SEQUENCE; Schema: public; Owner: valknar
--

CREATE SEQUENCE public.directus_relations_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.directus_relations_id_seq OWNER TO valknar;

--
-- Name: directus_relations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: valknar
--

ALTER SEQUENCE public.directus_relations_id_seq OWNED BY public.directus_relations.id;


--
-- Name: directus_revisions; Type: TABLE; Schema: public; Owner: valknar
--

CREATE TABLE public.directus_revisions (
    id integer NOT NULL,
    activity integer NOT NULL,
    collection character varying(64) NOT NULL,
    item character varying(255) NOT NULL,
    data json,
    delta json,
    parent integer,
    version uuid
);


ALTER TABLE public.directus_revisions OWNER TO valknar;

--
-- Name: directus_revisions_id_seq; Type: SEQUENCE; Schema: public; Owner: valknar
--

CREATE SEQUENCE public.directus_revisions_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.directus_revisions_id_seq OWNER TO valknar;

--
-- Name: directus_revisions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: valknar
--

ALTER SEQUENCE public.directus_revisions_id_seq OWNED BY public.directus_revisions.id;


--
-- Name: directus_roles; Type: TABLE; Schema: public; Owner: valknar
--

CREATE TABLE public.directus_roles (
    id uuid NOT NULL,
    name character varying(100) NOT NULL,
    icon character varying(64) DEFAULT 'supervised_user_circle'::character varying NOT NULL,
    description text,
    parent uuid
);


ALTER TABLE public.directus_roles OWNER TO valknar;

--
-- Name: directus_sessions; Type: TABLE; Schema: public; Owner: valknar
--

CREATE TABLE public.directus_sessions (
    token character varying(64) NOT NULL,
    "user" uuid,
    expires timestamp with time zone NOT NULL,
    ip character varying(255),
    user_agent text,
    share uuid,
    origin character varying(255),
    next_token character varying(64)
);


ALTER TABLE public.directus_sessions OWNER TO valknar;

--
-- Name: directus_settings; Type: TABLE; Schema: public; Owner: valknar
--

CREATE TABLE public.directus_settings (
    id integer NOT NULL,
    project_name character varying(100) DEFAULT 'Directus'::character varying NOT NULL,
    project_url character varying(255),
    project_color character varying(255) DEFAULT '#6644FF'::character varying NOT NULL,
    project_logo uuid,
    public_foreground uuid,
    public_background uuid,
    public_note text,
    auth_login_attempts integer DEFAULT 25,
    auth_password_policy character varying(100),
    storage_asset_transform character varying(7) DEFAULT 'all'::character varying,
    storage_asset_presets json,
    custom_css text,
    storage_default_folder uuid,
    basemaps json,
    mapbox_key character varying(255),
    module_bar json,
    project_descriptor character varying(100),
    default_language character varying(255) DEFAULT 'en-US'::character varying NOT NULL,
    custom_aspect_ratios json,
    public_favicon uuid,
    default_appearance character varying(255) DEFAULT 'auto'::character varying NOT NULL,
    default_theme_light character varying(255),
    theme_light_overrides json,
    default_theme_dark character varying(255),
    theme_dark_overrides json,
    report_error_url character varying(255),
    report_bug_url character varying(255),
    report_feature_url character varying(255),
    public_registration boolean DEFAULT false NOT NULL,
    public_registration_verify_email boolean DEFAULT true NOT NULL,
    public_registration_role uuid,
    public_registration_email_filter json,
    visual_editor_urls json,
    accepted_terms boolean DEFAULT false,
    project_id uuid,
    mcp_enabled boolean DEFAULT false NOT NULL,
    mcp_allow_deletes boolean DEFAULT false NOT NULL,
    mcp_prompts_collection character varying(255) DEFAULT NULL::character varying,
    mcp_system_prompt_enabled boolean DEFAULT true NOT NULL,
    mcp_system_prompt text
);


ALTER TABLE public.directus_settings OWNER TO valknar;

--
-- Name: directus_settings_id_seq; Type: SEQUENCE; Schema: public; Owner: valknar
--

CREATE SEQUENCE public.directus_settings_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.directus_settings_id_seq OWNER TO valknar;

--
-- Name: directus_settings_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: valknar
--

ALTER SEQUENCE public.directus_settings_id_seq OWNED BY public.directus_settings.id;


--
-- Name: directus_shares; Type: TABLE; Schema: public; Owner: valknar
--

CREATE TABLE public.directus_shares (
    id uuid NOT NULL,
    name character varying(255),
    collection character varying(64) NOT NULL,
    item character varying(255) NOT NULL,
    role uuid,
    password character varying(255),
    user_created uuid,
    date_created timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    date_start timestamp with time zone,
    date_end timestamp with time zone,
    times_used integer DEFAULT 0,
    max_uses integer
);


ALTER TABLE public.directus_shares OWNER TO valknar;

--
-- Name: directus_translations; Type: TABLE; Schema: public; Owner: valknar
--

CREATE TABLE public.directus_translations (
    id uuid NOT NULL,
    language character varying(255) NOT NULL,
    key character varying(255) NOT NULL,
    value text NOT NULL
);


ALTER TABLE public.directus_translations OWNER TO valknar;

--
-- Name: directus_users; Type: TABLE; Schema: public; Owner: valknar
--

CREATE TABLE public.directus_users (
    id uuid NOT NULL,
    first_name character varying(50),
    last_name character varying(50),
    email character varying(128),
    password character varying(255),
    location character varying(255),
    title character varying(50),
    description text,
    tags json,
    avatar uuid,
    language character varying(255) DEFAULT NULL::character varying,
    tfa_secret character varying(255),
    status character varying(16) DEFAULT 'active'::character varying NOT NULL,
    role uuid,
    token character varying(255),
    last_access timestamp with time zone,
    last_page character varying(255),
    provider character varying(128) DEFAULT 'default'::character varying NOT NULL,
    external_identifier character varying(255),
    auth_data json,
    email_notifications boolean DEFAULT true,
    appearance character varying(255),
    theme_dark character varying(255),
    theme_light character varying(255),
    theme_light_overrides json,
    theme_dark_overrides json,
    text_direction character varying(255) DEFAULT 'auto'::character varying NOT NULL,
    website character varying(255),
    slug character varying(255) DEFAULT NULL::character varying NOT NULL,
    join_date timestamp without time zone NOT NULL,
    featured boolean DEFAULT false,
    artist_name character varying(255),
    banner uuid
);


ALTER TABLE public.directus_users OWNER TO valknar;

--
-- Name: directus_versions; Type: TABLE; Schema: public; Owner: valknar
--

CREATE TABLE public.directus_versions (
    id uuid NOT NULL,
    key character varying(64) NOT NULL,
    name character varying(255),
    collection character varying(64) NOT NULL,
    item character varying(255) NOT NULL,
    hash character varying(255),
    date_created timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    date_updated timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    user_created uuid,
    user_updated uuid,
    delta json
);


ALTER TABLE public.directus_versions OWNER TO valknar;

--
-- Name: directus_webhooks; Type: TABLE; Schema: public; Owner: valknar
--

CREATE TABLE public.directus_webhooks (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    method character varying(10) DEFAULT 'POST'::character varying NOT NULL,
    url character varying(255) NOT NULL,
    status character varying(10) DEFAULT 'active'::character varying NOT NULL,
    data boolean DEFAULT true NOT NULL,
    actions character varying(100) NOT NULL,
    collections character varying(255) NOT NULL,
    headers json,
    was_active_before_deprecation boolean DEFAULT false NOT NULL,
    migrated_flow uuid
);


ALTER TABLE public.directus_webhooks OWNER TO valknar;

--
-- Name: directus_webhooks_id_seq; Type: SEQUENCE; Schema: public; Owner: valknar
--

CREATE SEQUENCE public.directus_webhooks_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.directus_webhooks_id_seq OWNER TO valknar;

--
-- Name: directus_webhooks_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: valknar
--

ALTER SEQUENCE public.directus_webhooks_id_seq OWNED BY public.directus_webhooks.id;


--
-- Name: junction_directus_users_files; Type: TABLE; Schema: public; Owner: valknar
--

CREATE TABLE public.junction_directus_users_files (
    id integer NOT NULL,
    directus_users_id uuid,
    directus_files_id uuid
);


ALTER TABLE public.junction_directus_users_files OWNER TO valknar;

--
-- Name: junction_directus_users_files_id_seq; Type: SEQUENCE; Schema: public; Owner: valknar
--

CREATE SEQUENCE public.junction_directus_users_files_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.junction_directus_users_files_id_seq OWNER TO valknar;

--
-- Name: junction_directus_users_files_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: valknar
--

ALTER SEQUENCE public.junction_directus_users_files_id_seq OWNED BY public.junction_directus_users_files.id;


--
-- Name: sexy_articles; Type: TABLE; Schema: public; Owner: valknar
--

CREATE TABLE public.sexy_articles (
    id uuid NOT NULL,
    status character varying(255) DEFAULT 'draft'::character varying NOT NULL,
    user_created uuid,
    date_created timestamp with time zone,
    date_updated timestamp with time zone,
    slug character varying(255) DEFAULT NULL::character varying,
    title character varying(255),
    excerpt text,
    content text,
    image uuid NOT NULL,
    tags json,
    publish_date timestamp without time zone,
    category character varying(255),
    featured boolean DEFAULT false,
    author uuid
);


ALTER TABLE public.sexy_articles OWNER TO valknar;

--
-- Name: sexy_videos; Type: TABLE; Schema: public; Owner: valknar
--

CREATE TABLE public.sexy_videos (
    id uuid NOT NULL,
    status character varying(255) DEFAULT 'draft'::character varying NOT NULL,
    user_created uuid,
    date_created timestamp with time zone,
    date_updated timestamp with time zone,
    slug character varying(255),
    title character varying(255),
    image uuid,
    upload_date timestamp without time zone,
    premium boolean,
    featured boolean,
    tags json,
    movie uuid,
    description text
);


ALTER TABLE public.sexy_videos OWNER TO valknar;

--
-- Name: sexy_videos_directus_users; Type: TABLE; Schema: public; Owner: valknar
--

CREATE TABLE public.sexy_videos_directus_users (
    id integer NOT NULL,
    sexy_videos_id uuid,
    directus_users_id uuid
);


ALTER TABLE public.sexy_videos_directus_users OWNER TO valknar;

--
-- Name: sexy_videos_directus_users_id_seq; Type: SEQUENCE; Schema: public; Owner: valknar
--

CREATE SEQUENCE public.sexy_videos_directus_users_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.sexy_videos_directus_users_id_seq OWNER TO valknar;

--
-- Name: sexy_videos_directus_users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: valknar
--

ALTER SEQUENCE public.sexy_videos_directus_users_id_seq OWNED BY public.sexy_videos_directus_users.id;


--
-- Name: directus_activity id; Type: DEFAULT; Schema: public; Owner: valknar
--

ALTER TABLE ONLY public.directus_activity ALTER COLUMN id SET DEFAULT nextval('public.directus_activity_id_seq'::regclass);


--
-- Name: directus_fields id; Type: DEFAULT; Schema: public; Owner: valknar
--

ALTER TABLE ONLY public.directus_fields ALTER COLUMN id SET DEFAULT nextval('public.directus_fields_id_seq'::regclass);


--
-- Name: directus_notifications id; Type: DEFAULT; Schema: public; Owner: valknar
--

ALTER TABLE ONLY public.directus_notifications ALTER COLUMN id SET DEFAULT nextval('public.directus_notifications_id_seq'::regclass);


--
-- Name: directus_permissions id; Type: DEFAULT; Schema: public; Owner: valknar
--

ALTER TABLE ONLY public.directus_permissions ALTER COLUMN id SET DEFAULT nextval('public.directus_permissions_id_seq'::regclass);


--
-- Name: directus_presets id; Type: DEFAULT; Schema: public; Owner: valknar
--

ALTER TABLE ONLY public.directus_presets ALTER COLUMN id SET DEFAULT nextval('public.directus_presets_id_seq'::regclass);


--
-- Name: directus_relations id; Type: DEFAULT; Schema: public; Owner: valknar
--

ALTER TABLE ONLY public.directus_relations ALTER COLUMN id SET DEFAULT nextval('public.directus_relations_id_seq'::regclass);


--
-- Name: directus_revisions id; Type: DEFAULT; Schema: public; Owner: valknar
--

ALTER TABLE ONLY public.directus_revisions ALTER COLUMN id SET DEFAULT nextval('public.directus_revisions_id_seq'::regclass);


--
-- Name: directus_settings id; Type: DEFAULT; Schema: public; Owner: valknar
--

ALTER TABLE ONLY public.directus_settings ALTER COLUMN id SET DEFAULT nextval('public.directus_settings_id_seq'::regclass);


--
-- Name: directus_webhooks id; Type: DEFAULT; Schema: public; Owner: valknar
--

ALTER TABLE ONLY public.directus_webhooks ALTER COLUMN id SET DEFAULT nextval('public.directus_webhooks_id_seq'::regclass);


--
-- Name: junction_directus_users_files id; Type: DEFAULT; Schema: public; Owner: valknar
--

ALTER TABLE ONLY public.junction_directus_users_files ALTER COLUMN id SET DEFAULT nextval('public.junction_directus_users_files_id_seq'::regclass);


--
-- Name: sexy_videos_directus_users id; Type: DEFAULT; Schema: public; Owner: valknar
--

ALTER TABLE ONLY public.sexy_videos_directus_users ALTER COLUMN id SET DEFAULT nextval('public.sexy_videos_directus_users_id_seq'::regclass);


--
-- Data for Name: directus_access; Type: TABLE DATA; Schema: public; Owner: valknar
--

COPY public.directus_access (id, role, "user", policy, sort) FROM stdin;
9463b336-0252-43b3-858d-502c8101bf36	ea3a9127-2b65-462c-85a8-dbafe9b4fe24	\N	5f2a2bd8-588f-4ef7-8613-fa826e0b224d	\N
32084f66-b9e3-4192-b990-96b72afc8844	a1300aaa-0205-47d8-97a7-6166ac924e50	\N	338928fb-f8ee-4450-8b24-4854dd8bc7e0	\N
aa848283-ea71-4c25-8e2f-e9024bce0d4f	55da25e6-9a87-4264-92e8-9066fdcf9c07	\N	7f06bc6a-6c55-4672-aedc-1c25b42dca52	\N
11fa655a-6998-4c6b-b35f-42fd174d4536	f1d1d90f-9a4a-4199-bc70-f9cd3cccd99f	\N	656e614d-a1aa-4b89-936a-e2c730fc85e1	1
b4f61dcc-b54e-4b3e-8a5e-bfbf029f6349	\N	4d310101-f7b1-47fe-982a-efe4abf25c55	656e614d-a1aa-4b89-936a-e2c730fc85e1	1
77084e57-682d-43e0-b570-acaf9fe94b1f	\N	4d310101-f7b1-47fe-982a-efe4abf25c55	7f06bc6a-6c55-4672-aedc-1c25b42dca52	\N
21e031ff-632d-46e5-97bb-959a5fef2538	\N	4d310101-f7b1-47fe-982a-efe4abf25c55	5f2a2bd8-588f-4ef7-8613-fa826e0b224d	\N
1e42d4ff-0ead-4651-a283-7b21a158d5ea	\N	\N	f575bea7-7260-4d81-a931-81d762f2b47d	\N
\.


--
-- Data for Name: directus_activity; Type: TABLE DATA; Schema: public; Owner: valknar
--

COPY public.directus_activity (id, action, "user", "timestamp", ip, user_agent, collection, item, origin) FROM stdin;
1	login	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-05 20:46:19.189+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_users	4d310101-f7b1-47fe-982a-efe4abf25c55	http://localhost:8055
2	update	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-05 20:46:26.145+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_settings	1	http://localhost:8055
3	create	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-06 08:36:20.78+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_flows	35c3047d-fcdc-43a5-a58d-a34ce17f32f0	http://localhost:8055
4	update	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-06 08:40:32.414+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_flows	35c3047d-fcdc-43a5-a58d-a34ce17f32f0	http://localhost:8055
5	create	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-06 08:53:37.24+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_operations	6d4e66b9-7474-4b10-8926-30eb97beeefc	http://localhost:8055
6	update	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-06 08:53:37.266+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_flows	35c3047d-fcdc-43a5-a58d-a34ce17f32f0	http://localhost:8055
7	create	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-06 08:55:24.669+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_roles	a1300aaa-0205-47d8-97a7-6166ac924e50	http://localhost:8055
8	update	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-06 08:59:07.115+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_roles	a1300aaa-0205-47d8-97a7-6166ac924e50	http://localhost:8055
9	create	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-06 08:59:16.449+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_roles	55da25e6-9a87-4264-92e8-9066fdcf9c07	http://localhost:8055
10	update	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-06 09:00:27.303+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_roles	55da25e6-9a87-4264-92e8-9066fdcf9c07	http://localhost:8055
11	update	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-06 09:00:55.415+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_roles	55da25e6-9a87-4264-92e8-9066fdcf9c07	http://localhost:8055
12	create	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-06 09:02:53.314+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_fields	1	http://localhost:8055
13	create	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-06 09:02:53.332+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_fields	2	http://localhost:8055
14	create	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-06 09:02:53.349+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_fields	3	http://localhost:8055
15	create	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-06 09:02:53.371+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_fields	4	http://localhost:8055
16	create	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-06 09:02:53.394+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_fields	5	http://localhost:8055
17	create	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-06 09:02:53.433+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_collections	sexy_videos	http://localhost:8055
18	update	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-06 09:05:12.708+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_collections	sexy_videos	http://localhost:8055
19	delete	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-06 09:10:48.06+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_collections	sexy_videos	http://localhost:8055
20	delete	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-06 09:10:48.083+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_fields	1	http://localhost:8055
21	delete	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-06 09:10:48.084+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_fields	2	http://localhost:8055
22	delete	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-06 09:10:48.091+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_fields	3	http://localhost:8055
23	delete	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-06 09:10:48.097+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_fields	4	http://localhost:8055
24	delete	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-06 09:10:48.104+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_fields	5	http://localhost:8055
25	create	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-06 09:11:47.947+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_fields	6	http://localhost:8055
26	create	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-06 09:11:47.99+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_fields	7	http://localhost:8055
27	create	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-06 09:11:48.025+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_fields	8	http://localhost:8055
28	create	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-06 09:11:48.065+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_fields	9	http://localhost:8055
29	create	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-06 09:11:48.09+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_fields	10	http://localhost:8055
30	create	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-06 09:11:48.119+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_fields	11	http://localhost:8055
31	create	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-06 09:11:48.158+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_collections	sexy_videos	http://localhost:8055
32	update	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-06 09:12:37.048+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_fields	8	http://localhost:8055
33	update	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-06 09:12:44.896+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_fields	8	http://localhost:8055
34	delete	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-06 09:13:34.419+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_collections	sexy_videos	http://localhost:8055
35	delete	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-06 09:13:34.443+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_fields	6	http://localhost:8055
36	delete	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-06 09:13:34.446+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_fields	7	http://localhost:8055
37	delete	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-06 09:13:34.447+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_fields	8	http://localhost:8055
38	delete	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-06 09:13:34.449+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_fields	9	http://localhost:8055
39	delete	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-06 09:13:34.45+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_fields	10	http://localhost:8055
40	delete	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-06 09:13:34.452+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_fields	11	http://localhost:8055
41	create	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-06 09:14:53.756+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_fields	12	http://localhost:8055
42	create	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-06 09:14:53.776+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_fields	13	http://localhost:8055
43	create	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-06 09:14:53.794+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_fields	14	http://localhost:8055
44	create	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-06 09:14:53.808+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_fields	15	http://localhost:8055
45	create	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-06 09:14:53.823+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_fields	16	http://localhost:8055
46	create	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-06 09:14:53.853+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_fields	17	http://localhost:8055
47	create	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-06 09:14:53.879+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_collections	sexy_videos	http://localhost:8055
48	update	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-06 09:15:44.146+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_fields	12	http://localhost:8055
49	update	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-06 09:17:51.111+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_collections	sexy_videos	http://localhost:8055
50	update	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-06 09:20:12.516+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_settings	1	http://localhost:8055
51	create	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-06 09:20:51.149+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_folders	c214c905-885b-4d66-a6a1-6527b0606200	http://localhost:8055
52	update	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-06 09:21:29.375+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_settings	1	http://localhost:8055
53	update	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-06 09:29:50.27+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_settings	1	http://localhost:8055
54	create	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-06 09:33:33.19+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_files	82dd90a8-35f7-4b16-9928-0bedb4a1fab8	http://localhost:8055
55	delete	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-06 09:33:33.252+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_files	82dd90a8-35f7-4b16-9928-0bedb4a1fab8	http://localhost:8055
56	create	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-06 09:33:43.875+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_files	85fed315-0396-4d60-b23b-e32ef1d2d8a1	http://localhost:8055
57	delete	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-06 09:33:43.913+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_files	85fed315-0396-4d60-b23b-e32ef1d2d8a1	http://localhost:8055
58	create	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-06 09:35:27.334+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_folders	3eaf8f03-dbfe-4c73-b513-5cc588de6457	http://localhost:8055
59	create	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-06 09:37:21.502+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_files	8ad7e858-0c83-4d88-bb50-3680f1cfa9c2	http://localhost:8055
60	update	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-06 09:38:47.887+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_settings	1	http://localhost:8055
61	update	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-06 09:39:46.608+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_settings	1	http://localhost:8055
62	create	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-06 09:41:14.434+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_policies	338928fb-f8ee-4450-8b24-4854dd8bc7e0	http://localhost:8055
63	create	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-06 09:41:14.537+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_permissions	1	http://localhost:8055
64	create	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-06 09:41:14.549+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_permissions	2	http://localhost:8055
65	create	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-06 09:41:14.573+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_permissions	3	http://localhost:8055
66	create	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-06 09:41:14.591+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_permissions	4	http://localhost:8055
67	create	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-06 09:41:14.618+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_permissions	5	http://localhost:8055
68	create	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-06 09:41:14.668+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_permissions	6	http://localhost:8055
69	create	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-06 09:41:14.697+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_permissions	7	http://localhost:8055
70	create	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-06 09:41:14.754+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_permissions	8	http://localhost:8055
71	create	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-06 09:41:14.78+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_permissions	9	http://localhost:8055
72	create	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-06 09:41:14.804+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_permissions	10	http://localhost:8055
73	create	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-06 09:41:14.826+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_permissions	11	http://localhost:8055
74	create	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-06 09:41:14.846+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_permissions	12	http://localhost:8055
75	create	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-06 09:41:14.863+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_permissions	13	http://localhost:8055
76	create	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-06 09:41:14.878+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_permissions	14	http://localhost:8055
77	create	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-06 09:41:14.9+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_permissions	15	http://localhost:8055
78	create	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-06 09:41:14.911+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_permissions	16	http://localhost:8055
79	create	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-06 09:41:14.919+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_permissions	17	http://localhost:8055
80	create	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-06 09:41:14.945+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_permissions	18	http://localhost:8055
81	create	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-06 09:41:14.958+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_permissions	19	http://localhost:8055
82	create	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-06 09:41:14.977+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_permissions	20	http://localhost:8055
83	create	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-06 09:42:22.075+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_access	32084f66-b9e3-4192-b990-96b72afc8844	http://localhost:8055
84	create	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-06 09:42:22.107+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_permissions	21	http://localhost:8055
85	update	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-06 09:42:22.14+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_policies	338928fb-f8ee-4450-8b24-4854dd8bc7e0	http://localhost:8055
86	update	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-06 09:42:50.111+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_policies	338928fb-f8ee-4450-8b24-4854dd8bc7e0	http://localhost:8055
87	create	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-06 09:43:07.411+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_policies	7f06bc6a-6c55-4672-aedc-1c25b42dca52	http://localhost:8055
88	create	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-06 09:47:32.283+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_access	aa848283-ea71-4c25-8e2f-e9024bce0d4f	http://localhost:8055
89	create	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-06 09:47:32.313+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_permissions	22	http://localhost:8055
90	create	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-06 09:47:32.327+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_permissions	23	http://localhost:8055
91	create	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-06 09:47:32.35+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_permissions	24	http://localhost:8055
92	create	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-06 09:47:32.371+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_permissions	25	http://localhost:8055
93	create	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-06 09:47:32.382+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_permissions	26	http://localhost:8055
94	update	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-06 09:47:32.413+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_policies	7f06bc6a-6c55-4672-aedc-1c25b42dca52	http://localhost:8055
95	create	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-06 10:10:53.428+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_fields	18	http://localhost:8055
96	create	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-06 10:12:28.251+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_fields	19	http://localhost:8055
97	update	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-06 10:14:26.738+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_fields	12	http://localhost:8055
98	update	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-06 10:16:21.492+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_fields	12	http://localhost:8055
99	create	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-06 10:16:51.367+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_fields	20	http://localhost:8055
100	update	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-06 10:17:11.049+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_fields	12	http://localhost:8055
101	update	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-06 10:17:11.085+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_fields	13	http://localhost:8055
102	update	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-06 10:17:11.119+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_fields	14	http://localhost:8055
103	update	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-06 10:17:11.148+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_fields	15	http://localhost:8055
104	update	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-06 10:17:11.181+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_fields	16	http://localhost:8055
105	update	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-06 10:17:11.21+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_fields	17	http://localhost:8055
106	update	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-06 10:17:11.23+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_fields	20	http://localhost:8055
107	update	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-06 10:17:11.265+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_fields	18	http://localhost:8055
108	update	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-06 10:17:11.295+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_fields	19	http://localhost:8055
109	create	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-06 10:19:14.118+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_fields	21	http://localhost:8055
110	update	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-06 10:20:49.718+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_fields	12	http://localhost:8055
111	update	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-06 10:20:49.755+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_fields	14	http://localhost:8055
112	update	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-06 10:20:49.79+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_fields	15	http://localhost:8055
113	update	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-06 10:20:49.831+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_fields	16	http://localhost:8055
114	update	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-06 10:20:49.852+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_fields	17	http://localhost:8055
115	update	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-06 10:20:49.887+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_fields	20	http://localhost:8055
116	update	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-06 10:20:49.926+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_fields	13	http://localhost:8055
117	update	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-06 10:20:49.979+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_fields	18	http://localhost:8055
118	update	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-06 10:20:50.028+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_fields	19	http://localhost:8055
119	update	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-06 10:20:50.066+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_fields	21	http://localhost:8055
120	update	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-06 10:25:07.213+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_fields	12	http://localhost:8055
121	update	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-06 10:25:17.237+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_fields	14	http://localhost:8055
122	update	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-06 10:25:17.278+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_fields	15	http://localhost:8055
123	update	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-06 10:25:17.315+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_fields	16	http://localhost:8055
124	update	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-06 10:25:17.355+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_fields	17	http://localhost:8055
125	update	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-06 10:25:17.392+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_fields	20	http://localhost:8055
126	update	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-06 10:25:17.428+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_fields	12	http://localhost:8055
127	update	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-06 10:25:17.474+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_fields	13	http://localhost:8055
128	update	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-06 10:25:17.534+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_fields	18	http://localhost:8055
129	update	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-06 10:25:17.569+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_fields	19	http://localhost:8055
130	update	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-06 10:25:17.598+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_fields	21	http://localhost:8055
131	create	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-06 10:27:07.01+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_fields	22	http://localhost:8055
132	update	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-06 10:27:17.043+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_fields	14	http://localhost:8055
133	update	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-06 10:27:17.056+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_fields	15	http://localhost:8055
134	update	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-06 10:27:17.094+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_fields	16	http://localhost:8055
135	update	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-06 10:27:17.114+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_fields	17	http://localhost:8055
136	update	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-06 10:27:17.142+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_fields	20	http://localhost:8055
137	update	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-06 10:27:17.169+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_fields	12	http://localhost:8055
138	update	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-06 10:27:17.206+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_fields	13	http://localhost:8055
139	update	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-06 10:27:17.239+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_fields	18	http://localhost:8055
140	update	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-06 10:27:17.261+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_fields	19	http://localhost:8055
141	update	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-06 10:27:17.29+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_fields	22	http://localhost:8055
142	update	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-06 10:27:17.318+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_fields	21	http://localhost:8055
143	update	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-06 10:38:19.528+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_flows	35c3047d-fcdc-43a5-a58d-a34ce17f32f0	http://localhost:8055
144	delete	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-06 10:41:49.067+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_flows	35c3047d-fcdc-43a5-a58d-a34ce17f32f0	http://localhost:8055
145	login	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-07 08:43:59.008+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_users	4d310101-f7b1-47fe-982a-efe4abf25c55	http://localhost:5173
146	login	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-08 09:12:42.394+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_users	4d310101-f7b1-47fe-982a-efe4abf25c55	http://localhost:5173
147	update	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-08 19:27:44.441+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_users	4d310101-f7b1-47fe-982a-efe4abf25c55	http://localhost:5173
148	create	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-08 19:29:11.994+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_files	99c47c3d-4865-4361-a545-f38e54fccb0b	http://localhost:5173
149	update	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-08 19:29:15.88+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_users	4d310101-f7b1-47fe-982a-efe4abf25c55	http://localhost:5173
150	update	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-08 19:30:53.221+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_folders	c214c905-885b-4d66-a6a1-6527b0606200	http://localhost:5173
151	update	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-08 19:31:25.483+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_settings	1	http://localhost:5173
152	create	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-08 19:34:08.718+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_fields	23	http://localhost:5173
153	create	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-08 19:34:08.724+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_fields	24	http://localhost:5173
154	create	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-08 19:34:08.733+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_fields	25	http://localhost:5173
155	create	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-08 19:34:08.744+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_fields	26	http://localhost:5173
156	create	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-08 19:34:08.754+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_fields	27	http://localhost:5173
157	create	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-08 19:34:08.772+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_collections	sexy_articles	http://localhost:5173
158	create	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-08 19:35:10.382+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_fields	28	http://localhost:5173
159	delete	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-08 19:35:22.729+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_fields	28	http://localhost:5173
160	create	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-08 19:35:42.224+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_fields	29	http://localhost:5173
161	update	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-08 19:37:05.498+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_fields	29	http://localhost:5173
162	create	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-08 19:37:22.561+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_fields	30	http://localhost:5173
163	create	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-08 19:37:57.091+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_fields	31	http://localhost:5173
164	create	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-08 19:39:01.751+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_fields	32	http://localhost:5173
165	update	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-08 19:39:24.39+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_fields	32	http://localhost:5173
166	create	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-08 19:40:07.715+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_folders	452680cc-8e19-4352-a943-21520d3f3621	http://localhost:5173
167	create	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-08 19:41:07.32+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_fields	33	http://localhost:5173
168	update	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-08 19:41:47.285+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_fields	33	http://localhost:5173
169	create	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-08 19:42:51.355+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_fields	34	http://localhost:5173
170	create	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-08 19:43:29.091+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_fields	35	http://localhost:5173
171	create	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-08 19:45:04.326+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_fields	36	http://localhost:5173
172	create	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-08 19:45:39.89+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_fields	37	http://localhost:5173
173	update	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-08 19:46:20.942+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_collections	sexy_articles	http://localhost:5173
174	create	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-08 19:49:44.205+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_files	f718185e-fd82-4f16-971d-88baf2d069de	http://localhost:5173
175	create	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-08 19:51:34.585+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	sexy_articles	327b53b3-1a3b-4859-bcc6-2e831e3d9b62	http://localhost:5173
176	create	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-08 20:03:50.478+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_permissions	27	http://localhost:5173
177	update	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-08 20:03:50.497+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_policies	abf8a154-5b1c-4a46-ac9c-7300570f4f17	http://localhost:5173
178	create	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-08 20:29:17.367+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_permissions	28	http://localhost:5173
179	update	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-08 20:29:17.385+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_policies	abf8a154-5b1c-4a46-ac9c-7300570f4f17	http://localhost:5173
180	update	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-08 20:36:13.57+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_permissions	28	http://localhost:5173
181	update	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-08 20:36:13.583+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_policies	abf8a154-5b1c-4a46-ac9c-7300570f4f17	http://localhost:5173
182	update	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-08 20:51:27.313+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	sexy_articles	327b53b3-1a3b-4859-bcc6-2e831e3d9b62	http://localhost:5173
183	create	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-08 21:15:44.999+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_fields	38	http://localhost:5173
184	update	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-08 21:16:17.151+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	sexy_articles	327b53b3-1a3b-4859-bcc6-2e831e3d9b62	http://localhost:5173
185	update	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-08 21:16:30.954+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_fields	23	http://localhost:5173
186	update	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-08 21:16:30.971+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_fields	24	http://localhost:5173
187	update	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-08 21:16:30.997+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_fields	25	http://localhost:5173
188	update	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-08 21:16:31.018+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_fields	26	http://localhost:5173
189	update	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-08 21:16:31.034+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_fields	27	http://localhost:5173
190	update	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-08 21:16:31.058+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_fields	29	http://localhost:5173
191	update	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-08 21:16:31.079+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_fields	38	http://localhost:5173
192	update	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-08 21:16:31.09+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_fields	30	http://localhost:5173
193	update	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-08 21:16:31.116+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_fields	31	http://localhost:5173
194	update	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-08 21:16:31.134+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_fields	32	http://localhost:5173
195	update	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-08 21:16:31.144+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_fields	33	http://localhost:5173
196	update	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-08 21:16:31.151+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_fields	34	http://localhost:5173
197	update	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-08 21:16:31.158+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_fields	35	http://localhost:5173
198	update	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-08 21:16:31.185+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_fields	36	http://localhost:5173
199	update	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-08 21:16:31.212+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_fields	37	http://localhost:5173
200	delete	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-08 21:25:10.402+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_fields	38	http://localhost:5173
201	create	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-08 21:28:18.31+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_fields	39	http://localhost:5173
202	update	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-08 21:28:28.172+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_fields	23	http://localhost:5173
203	update	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-08 21:28:28.182+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_fields	24	http://localhost:5173
204	update	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-08 21:28:28.19+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_fields	25	http://localhost:5173
205	update	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-08 21:28:28.221+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_fields	26	http://localhost:5173
206	update	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-08 21:28:28.242+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_fields	27	http://localhost:5173
207	update	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-08 21:28:28.249+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_fields	29	http://localhost:5173
208	update	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-08 21:28:28.256+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_fields	30	http://localhost:5173
209	update	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-08 21:28:28.279+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_fields	39	http://localhost:5173
210	update	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-08 21:28:28.297+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_fields	31	http://localhost:5173
211	update	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-08 21:28:28.31+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_fields	32	http://localhost:5173
212	update	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-08 21:28:28.317+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_fields	33	http://localhost:5173
213	update	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-08 21:28:28.328+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_fields	34	http://localhost:5173
214	update	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-08 21:28:28.348+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_fields	35	http://localhost:5173
215	update	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-08 21:28:28.356+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_fields	36	http://localhost:5173
216	update	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-08 21:28:28.373+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_fields	37	http://localhost:5173
217	update	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-08 21:28:48.427+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	sexy_articles	327b53b3-1a3b-4859-bcc6-2e831e3d9b62	http://localhost:5173
218	create	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-08 23:38:44.677+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_roles	f1d1d90f-9a4a-4199-bc70-f9cd3cccd99f	http://localhost:5173
219	create	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-08 23:41:15.928+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_permissions	29	http://localhost:5173
220	create	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-08 23:41:15.949+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_permissions	30	http://localhost:5173
221	create	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-08 23:41:15.959+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_permissions	31	http://localhost:5173
222	create	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-08 23:41:15.983+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_permissions	32	http://localhost:5173
223	create	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-08 23:41:15.999+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_permissions	33	http://localhost:5173
224	create	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-08 23:41:16.012+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_policies	656e614d-a1aa-4b89-936a-e2c730fc85e1	http://localhost:5173
225	create	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-08 23:41:16.037+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_access	11fa655a-6998-4c6b-b35f-42fd174d4536	http://localhost:5173
226	update	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-08 23:41:16.057+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_roles	f1d1d90f-9a4a-4199-bc70-f9cd3cccd99f	http://localhost:5173
227	update	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-08 23:41:43.312+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_roles	f1d1d90f-9a4a-4199-bc70-f9cd3cccd99f	http://localhost:5173
228	update	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-08 23:42:51.472+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_fields	39	http://localhost:5173
229	create	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-08 23:44:07.038+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_access	b4f61dcc-b54e-4b3e-8a5e-bfbf029f6349	http://localhost:5173
230	update	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-08 23:44:07.058+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_users	4d310101-f7b1-47fe-982a-efe4abf25c55	http://localhost:5173
231	update	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-08 23:46:22.129+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_users	4d310101-f7b1-47fe-982a-efe4abf25c55	http://localhost:5173
232	update	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-08 23:48:13.651+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_fields	39	http://localhost:5173
233	create	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-08 23:58:17.525+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_fields	40	http://localhost:5173
234	update	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-08 23:59:38.263+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_users	4d310101-f7b1-47fe-982a-efe4abf25c55	http://localhost:5173
235	update	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-09 00:26:48.61+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_users	4d310101-f7b1-47fe-982a-efe4abf25c55	http://localhost:5173
236	update	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-09 00:28:54.599+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_permissions	28	http://localhost:5173
237	update	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-09 00:28:54.614+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_policies	abf8a154-5b1c-4a46-ac9c-7300570f4f17	http://localhost:5173
238	delete	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-09 01:41:45.77+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_collections	sexy_videos	http://localhost:5173
239	delete	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-09 01:41:45.794+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_fields	12	http://localhost:5173
240	delete	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-09 01:41:45.797+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_fields	13	http://localhost:5173
241	delete	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-09 01:41:45.798+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_fields	14	http://localhost:5173
242	delete	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-09 01:41:45.801+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_fields	15	http://localhost:5173
243	delete	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-09 01:41:45.805+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_fields	16	http://localhost:5173
244	delete	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-09 01:41:45.807+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_fields	17	http://localhost:5173
245	delete	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-09 01:41:45.812+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_fields	18	http://localhost:5173
246	delete	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-09 01:41:45.817+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_fields	19	http://localhost:5173
247	delete	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-09 01:41:45.821+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_fields	20	http://localhost:5173
248	delete	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-09 01:41:45.824+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_fields	21	http://localhost:5173
249	delete	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-09 01:41:45.827+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_fields	22	http://localhost:5173
256	delete	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-09 02:37:02.855+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_collections	sexy_models	http://localhost:5173
257	delete	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-09 02:37:02.862+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_fields	41	http://localhost:5173
258	delete	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-09 02:37:02.864+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_fields	42	http://localhost:5173
259	delete	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-09 02:37:02.868+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_fields	43	http://localhost:5173
260	delete	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-09 02:37:02.873+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_fields	44	http://localhost:5173
261	delete	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-09 02:37:02.878+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_fields	45	http://localhost:5173
250	create	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-09 01:42:19.809+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_fields	41	http://localhost:5173
251	create	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-09 01:42:19.829+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_fields	42	http://localhost:5173
252	create	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-09 01:42:19.84+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_fields	43	http://localhost:5173
253	create	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-09 01:42:19.86+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_fields	44	http://localhost:5173
254	create	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-09 01:42:19.868+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_fields	45	http://localhost:5173
255	create	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-09 01:42:19.891+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_collections	sexy_models	http://localhost:5173
262	create	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-09 02:53:11.459+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_fields	46	http://localhost:5173
263	create	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-09 02:53:11.475+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_fields	47	http://localhost:5173
264	create	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-09 02:53:11.497+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_fields	48	http://localhost:5173
265	create	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-09 02:53:11.516+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_fields	49	http://localhost:5173
266	create	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-09 02:53:11.524+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_fields	50	http://localhost:5173
267	create	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-09 02:53:11.529+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_collections	sexy_models	http://localhost:5173
268	update	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-09 02:55:42.182+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_collections	sexy_models	http://localhost:5173
269	create	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-09 02:55:59.51+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_fields	51	http://localhost:5173
270	update	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-09 02:56:38.558+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_fields	51	http://localhost:5173
271	create	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-09 02:56:56.399+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_fields	52	http://localhost:5173
272	create	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-09 03:04:31.754+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_folders	3c744e72-03ef-432d-9c16-ac0a343b2499	http://localhost:5173
273	create	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-09 03:04:50.596+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_folders	7360b85c-3bb7-4334-ba81-2f46575ea056	http://localhost:5173
274	create	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-09 03:11:13.601+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_fields	53	http://localhost:5173
275	create	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-09 03:12:16.153+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_fields	54	http://localhost:5173
276	create	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-09 03:12:28.651+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_fields	55	http://localhost:5173
277	create	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-09 03:22:20.114+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_permissions	34	http://localhost:5173
278	update	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-09 03:22:20.181+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_policies	abf8a154-5b1c-4a46-ac9c-7300570f4f17	http://localhost:5173
279	update	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-09 03:59:49.409+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_settings	1	http://localhost:5173
280	update	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-09 04:04:21.804+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_settings	1	http://localhost:5173
281	update	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-09 04:06:23.726+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_settings	1	http://localhost:5173
282	update	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-09 04:13:54.228+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_settings	1	http://localhost:5173
283	create	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-09 04:41:37.147+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_fields	56	http://localhost:5173
284	create	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-09 04:46:09.97+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_fields	57	http://localhost:5173
285	update	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-09 04:46:18.762+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_fields	46	http://localhost:5173
286	update	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-09 04:46:18.793+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_fields	47	http://localhost:5173
287	update	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-09 04:46:18.826+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_fields	48	http://localhost:5173
288	update	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-09 04:46:18.851+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_fields	49	http://localhost:5173
289	update	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-09 04:46:18.894+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_fields	50	http://localhost:5173
290	update	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-09 04:46:18.936+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_fields	51	http://localhost:5173
291	update	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-09 04:46:18.965+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_fields	52	http://localhost:5173
292	update	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-09 04:46:18.982+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_fields	57	http://localhost:5173
293	update	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-09 04:46:19.015+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_fields	53	http://localhost:5173
294	update	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-09 04:46:19.043+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_fields	54	http://localhost:5173
295	update	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-09 04:46:19.073+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_fields	55	http://localhost:5173
296	update	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-09 04:46:19.103+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_fields	56	http://localhost:5173
297	create	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-09 04:47:04.674+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_fields	58	http://localhost:5173
298	update	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-09 04:47:11.904+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_fields	46	http://localhost:5173
299	update	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-09 04:47:11.915+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_fields	47	http://localhost:5173
300	update	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-09 04:47:11.921+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_fields	48	http://localhost:5173
301	update	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-09 04:47:11.931+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_fields	49	http://localhost:5173
302	update	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-09 04:47:11.957+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_fields	50	http://localhost:5173
303	update	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-09 04:47:11.977+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_fields	51	http://localhost:5173
304	update	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-09 04:47:11.985+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_fields	52	http://localhost:5173
305	update	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-09 04:47:11.991+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_fields	58	http://localhost:5173
306	update	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-09 04:47:12.005+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_fields	57	http://localhost:5173
307	update	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-09 04:47:12.025+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_fields	53	http://localhost:5173
308	update	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-09 04:47:12.046+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_fields	54	http://localhost:5173
309	update	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-09 04:47:12.052+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_fields	55	http://localhost:5173
310	update	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-09 04:47:12.058+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_fields	56	http://localhost:5173
311	update	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-09 05:28:54.723+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_settings	1	http://localhost:5173
312	create	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-09 05:31:43.366+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_fields	59	http://localhost:5173
313	update	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-09 05:31:51.77+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_fields	46	http://localhost:5173
314	update	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-09 05:31:51.781+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_fields	47	http://localhost:5173
315	update	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-09 05:31:51.791+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_fields	48	http://localhost:5173
316	update	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-09 05:31:51.817+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_fields	49	http://localhost:5173
317	update	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-09 05:31:51.846+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_fields	50	http://localhost:5173
318	update	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-09 05:31:51.855+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_fields	51	http://localhost:5173
319	update	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-09 05:31:51.862+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_fields	52	http://localhost:5173
320	update	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-09 05:31:51.91+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_fields	58	http://localhost:5173
321	update	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-09 05:31:51.928+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_fields	59	http://localhost:5173
322	update	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-09 05:31:51.957+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_fields	57	http://localhost:5173
323	update	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-09 05:31:51.983+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_fields	53	http://localhost:5173
324	update	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-09 05:31:52.007+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_fields	54	http://localhost:5173
325	update	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-09 05:31:52.031+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_fields	55	http://localhost:5173
326	update	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-09 05:31:52.047+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_fields	56	http://localhost:5173
327	update	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-09 05:34:23.86+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_fields	59	http://localhost:5173
328	create	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-09 05:35:24.683+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_access	77084e57-682d-43e0-b570-acaf9fe94b1f	http://localhost:5173
329	update	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-09 05:35:24.688+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_policies	7f06bc6a-6c55-4672-aedc-1c25b42dca52	http://localhost:5173
330	create	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-09 05:38:22.953+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_files	5c8a6bfe-c55f-4b7c-aea4-a59e407e7a9d	http://localhost:5173
335	update	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-09 05:55:46.646+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_fields	54	http://localhost:5173
337	create	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-09 06:50:43.22+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_fields	60	http://localhost:5173
339	create	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-09 10:08:24.796+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_fields	61	http://localhost:5173
340	create	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-09 10:08:24.823+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_fields	62	http://localhost:5173
341	create	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-09 10:08:24.835+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_fields	63	http://localhost:5173
342	create	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-09 10:08:24.858+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_fields	64	http://localhost:5173
343	create	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-09 10:08:24.863+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_fields	65	http://localhost:5173
344	create	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-09 10:08:24.868+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_collections	sexy_videos	http://localhost:5173
345	create	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-09 10:08:38.222+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_fields	66	http://localhost:5173
346	update	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-09 10:08:52.624+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_fields	66	http://localhost:5173
347	create	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-09 10:09:11.247+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_fields	67	http://localhost:5173
348	create	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-09 10:10:00.226+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_fields	68	http://localhost:5173
349	create	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-09 10:10:27.729+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_fields	69	http://localhost:5173
350	update	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-09 10:11:02.124+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_fields	55	http://localhost:5173
351	update	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-09 10:11:07.821+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_fields	46	http://localhost:5173
352	update	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-09 10:11:07.83+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_fields	47	http://localhost:5173
353	update	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-09 10:11:07.848+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_fields	48	http://localhost:5173
354	update	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-09 10:11:07.876+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_fields	49	http://localhost:5173
355	update	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-09 10:11:07.903+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_fields	50	http://localhost:5173
356	update	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-09 10:11:07.923+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_fields	51	http://localhost:5173
357	update	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-09 10:11:07.93+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_fields	52	http://localhost:5173
358	update	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-09 10:11:07.947+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_fields	58	http://localhost:5173
359	update	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-09 10:11:07.965+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_fields	59	http://localhost:5173
360	update	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-09 10:11:07.984+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_fields	57	http://localhost:5173
361	update	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-09 10:11:07.993+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_fields	53	http://localhost:5173
362	update	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-09 10:11:07.999+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_fields	55	http://localhost:5173
363	update	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-09 10:11:08.015+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_fields	54	http://localhost:5173
364	update	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-09 10:11:08.035+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_fields	56	http://localhost:5173
365	update	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-09 10:11:08.06+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_fields	60	http://localhost:5173
366	create	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-09 10:11:46.62+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_fields	70	http://localhost:5173
367	create	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-09 10:12:26.748+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_fields	71	http://localhost:5173
368	create	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-09 10:12:49.693+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_fields	72	http://localhost:5173
369	create	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-09 10:13:50.229+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_permissions	35	http://localhost:5173
370	update	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-09 10:13:50.268+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_policies	abf8a154-5b1c-4a46-ac9c-7300570f4f17	http://localhost:5173
371	update	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-09 10:14:13.928+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_settings	1	http://localhost:5173
372	login	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-09 12:20:22.017+00	78.51.138.64	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_users	4d310101-f7b1-47fe-982a-efe4abf25c55	https://sexy.pivoine.art
381	update	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-11 17:18:04.12+00	77.179.93.184	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_users	4d310101-f7b1-47fe-982a-efe4abf25c55	https://sexy.pivoine.art
382	login	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-11 17:18:32.268+00	77.179.93.184	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_users	4d310101-f7b1-47fe-982a-efe4abf25c55	https://sexy.pivoine.art
383	login	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-11 17:33:23.861+00	77.179.93.184	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_users	4d310101-f7b1-47fe-982a-efe4abf25c55	https://sexy.pivoine.art
384	login	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-11 17:34:43.955+00	77.179.93.184	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_users	4d310101-f7b1-47fe-982a-efe4abf25c55	https://sexy.pivoine.art
385	login	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-11 17:37:59.645+00	77.179.93.184	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_users	4d310101-f7b1-47fe-982a-efe4abf25c55	https://sexy.pivoine.art
386	login	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-11 17:42:42.978+00	77.179.93.184	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_users	4d310101-f7b1-47fe-982a-efe4abf25c55	https://sexy.pivoine.art
373	create	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-09 12:22:36.213+00	78.51.138.64	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_access	21e031ff-632d-46e5-97bb-959a5fef2538	https://sexy.pivoine.art
374	update	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-09 12:22:36.229+00	78.51.138.64	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_policies	5f2a2bd8-588f-4ef7-8613-fa826e0b224d	https://sexy.pivoine.art
387	login	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-11 17:56:55.878+00	77.179.93.184	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_users	4d310101-f7b1-47fe-982a-efe4abf25c55	https://sexy.pivoine.art
375	login	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-10 08:28:36.533+00	77.181.157.105	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_users	4d310101-f7b1-47fe-982a-efe4abf25c55	https://sexy.pivoine.art
388	login	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-13 10:07:31.702+00	77.184.214.165	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_users	4d310101-f7b1-47fe-982a-efe4abf25c55	https://sexy.pivoine.art
389	login	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-13 10:11:42.888+00	77.184.214.165	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_users	4d310101-f7b1-47fe-982a-efe4abf25c55	https://sexy.pivoine.art
390	login	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-13 10:14:46.46+00	77.184.214.165	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_users	4d310101-f7b1-47fe-982a-efe4abf25c55	https://sexy.pivoine.art
376	create	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-10 08:29:22.617+00	77.181.157.105	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_permissions	36	https://sexy.pivoine.art
377	update	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-10 08:29:22.634+00	77.181.157.105	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_policies	abf8a154-5b1c-4a46-ac9c-7300570f4f17	https://sexy.pivoine.art
391	login	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-13 13:54:36.231+00	77.184.214.165	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_users	4d310101-f7b1-47fe-982a-efe4abf25c55	https://sexy.pivoine.art
378	login	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-11 15:29:35.028+00	77.179.93.184	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_users	4d310101-f7b1-47fe-982a-efe4abf25c55	https://sexy.pivoine.art
392	update	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-13 13:59:08.725+00	77.184.214.165	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_users	4d310101-f7b1-47fe-982a-efe4abf25c55	https://sexy.pivoine.art
379	login	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-11 16:37:56.877+00	77.179.93.184	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_users	4d310101-f7b1-47fe-982a-efe4abf25c55	https://sexy.pivoine.art
380	login	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-11 17:14:23.733+00	77.179.93.184	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_users	4d310101-f7b1-47fe-982a-efe4abf25c55	https://sexy.pivoine.art
393	login	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-13 14:20:24.195+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_users	4d310101-f7b1-47fe-982a-efe4abf25c55	http://localhost:5173
399	update	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-13 14:40:04.812+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_files	0a509923-853d-44e7-ad76-b6e6bdf89ba5	http://localhost:5173
400	update	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-13 14:40:39.463+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_settings	1	http://localhost:5173
394	update	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-13 14:34:36.566+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_collections	sexy_articles	http://localhost:5173
401	update	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-13 14:51:28.776+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_settings	1	http://localhost:5173
402	create	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-14 07:21:28.261+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_files	ba90004e-5150-43dd-bf3e-699ee1b4d0a9	http://localhost:5173
395	update	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-13 14:35:06.297+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_collections	sexy_videos	http://localhost:5173
396	login	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-13 14:37:43.438+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_users	4d310101-f7b1-47fe-982a-efe4abf25c55	http://localhost:5173
405	login	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-14 09:18:22.837+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_users	4d310101-f7b1-47fe-982a-efe4abf25c55	http://localhost:5173
397	update	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-13 14:38:32.439+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_settings	1	http://localhost:5173
406	update	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-14 09:37:53.126+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_settings	1	http://localhost:5173
398	create	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-13 14:39:34.987+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_files	0a509923-853d-44e7-ad76-b6e6bdf89ba5	http://localhost:5173
407	login	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-15 19:14:28.972+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_users	4d310101-f7b1-47fe-982a-efe4abf25c55	http://localhost:5173
413	delete	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-15 20:05:22.787+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_users	b7483587-1a86-4dfa-9787-9ae70d89802b	http://localhost:5173
421	create	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-16 10:30:10.82+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_permissions	37	http://localhost:5173
422	update	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-16 10:30:10.852+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_policies	abf8a154-5b1c-4a46-ac9c-7300570f4f17	http://localhost:5173
451	update	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-16 11:21:20.583+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_policies	7f06bc6a-6c55-4672-aedc-1c25b42dca52	http://localhost:5173
453	update	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-16 11:23:29.554+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_policies	656e614d-a1aa-4b89-936a-e2c730fc85e1	http://localhost:5173
460	update	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-16 11:35:20.233+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_users	4d310101-f7b1-47fe-982a-efe4abf25c55	http://localhost:5173
472	create	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-16 12:00:15.278+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_permissions	39	http://localhost:5173
473	update	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-16 12:00:15.314+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_policies	abf8a154-5b1c-4a46-ac9c-7300570f4f17	http://localhost:5173
531	update	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-16 12:11:27.522+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_permissions	57	http://localhost:5173
532	update	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-16 12:11:27.537+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_policies	abf8a154-5b1c-4a46-ac9c-7300570f4f17	http://localhost:5173
542	create	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-16 12:45:27.828+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_permissions	67	http://localhost:5173
543	update	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-16 12:45:27.838+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_policies	abf8a154-5b1c-4a46-ac9c-7300570f4f17	http://localhost:5173
548	update	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-16 12:57:54.267+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_policies	abf8a154-5b1c-4a46-ac9c-7300570f4f17	http://localhost:5173
549	update	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-16 12:57:54.282+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_access	34e30350-eb02-4888-80b1-d09b6dcc85e8	http://localhost:5173
554	delete	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-16 13:01:08.765+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_policies	895bd74b-97d6-4bae-87fa-8741a717127e	http://localhost:5173
582	create	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-16 13:05:37.246+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_permissions	90	http://localhost:5173
583	create	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-16 13:05:37.267+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_permissions	91	http://localhost:5173
584	create	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-16 13:05:37.277+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_permissions	92	http://localhost:5173
585	create	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-16 13:05:37.297+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_permissions	93	http://localhost:5173
586	create	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-16 13:05:37.316+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_permissions	94	http://localhost:5173
587	create	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-16 13:05:37.337+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_permissions	95	http://localhost:5173
588	create	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-16 13:05:37.347+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_permissions	96	http://localhost:5173
589	create	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-16 13:05:37.384+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_permissions	97	http://localhost:5173
590	create	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-16 13:05:37.408+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_permissions	98	http://localhost:5173
591	create	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-16 13:05:37.422+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_permissions	99	http://localhost:5173
592	update	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-16 13:05:37.443+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_policies	f575bea7-7260-4d81-a931-81d762f2b47d	http://localhost:5173
605	delete	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-16 13:06:38.89+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_permissions	81	http://localhost:5173
606	delete	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-16 13:06:38.895+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_permissions	82	http://localhost:5173
607	delete	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-16 13:06:38.899+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_permissions	83	http://localhost:5173
608	delete	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-16 13:06:38.901+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_permissions	84	http://localhost:5173
609	delete	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-16 13:06:38.904+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_permissions	85	http://localhost:5173
610	delete	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-16 13:06:38.906+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_permissions	86	http://localhost:5173
611	delete	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-16 13:06:38.914+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_permissions	87	http://localhost:5173
408	update	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-15 19:19:04.956+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_settings	1	http://localhost:5173
414	delete	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-15 20:08:07.214+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_users	0b0773cc-614b-44bb-a6a4-c341662f6992	http://localhost:5173
423	delete	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-16 10:50:37.407+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_permissions	37	http://localhost:5173
424	update	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-16 10:50:37.453+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_policies	abf8a154-5b1c-4a46-ac9c-7300570f4f17	http://localhost:5173
454	update	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-16 11:24:03.93+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_policies	7f06bc6a-6c55-4672-aedc-1c25b42dca52	http://localhost:5173
455	update	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-16 11:24:18.515+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_policies	338928fb-f8ee-4450-8b24-4854dd8bc7e0	http://localhost:5173
461	update	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-16 11:40:12.781+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_users	543f4d0b-e346-4e5e-8aca-4a9b35d5fab6	http://localhost:5173
463	delete	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-16 11:41:19.365+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_files	ba90004e-5150-43dd-bf3e-699ee1b4d0a9	http://localhost:5173
464	delete	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-16 11:41:19.376+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_files	5c8a6bfe-c55f-4b7c-aea4-a59e407e7a9d	http://localhost:5173
466	update	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-16 11:41:44.79+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_users	543f4d0b-e346-4e5e-8aca-4a9b35d5fab6	http://localhost:5173
621	delete	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-16 13:06:38.942+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_permissions	98	http://localhost:5173
474	update	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-16 12:01:45.506+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_policies	abf8a154-5b1c-4a46-ac9c-7300570f4f17	http://localhost:5173
533	update	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-16 12:12:24.221+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_permissions	57	http://localhost:5173
534	update	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-16 12:12:24.236+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_policies	abf8a154-5b1c-4a46-ac9c-7300570f4f17	http://localhost:5173
544	update	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-16 12:49:01.417+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_policies	abf8a154-5b1c-4a46-ac9c-7300570f4f17	http://localhost:5173
550	delete	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-16 12:59:08.061+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_policies	abf8a154-5b1c-4a46-ac9c-7300570f4f17	http://localhost:5173
555	create	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-16 13:03:28.05+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_permissions	68	http://localhost:5173
556	create	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-16 13:03:28.067+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_permissions	69	http://localhost:5173
557	create	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-16 13:03:28.085+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_permissions	70	http://localhost:5173
558	create	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-16 13:03:28.109+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_permissions	71	http://localhost:5173
559	update	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-16 13:03:28.14+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_policies	f575bea7-7260-4d81-a931-81d762f2b47d	http://localhost:5173
560	create	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-16 13:04:43.986+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_permissions	72	http://localhost:5173
561	create	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-16 13:04:44.012+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_permissions	73	http://localhost:5173
562	create	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-16 13:04:44.021+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_permissions	74	http://localhost:5173
563	create	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-16 13:04:44.033+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_permissions	75	http://localhost:5173
564	create	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-16 13:04:44.051+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_permissions	76	http://localhost:5173
565	create	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-16 13:04:44.083+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_permissions	77	http://localhost:5173
566	create	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-16 13:04:44.097+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_permissions	78	http://localhost:5173
567	create	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-16 13:04:44.114+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_permissions	79	http://localhost:5173
568	create	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-16 13:04:44.119+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_permissions	80	http://localhost:5173
569	create	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-16 13:04:44.129+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_permissions	81	http://localhost:5173
570	create	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-16 13:04:44.145+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_permissions	82	http://localhost:5173
571	create	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-16 13:04:44.166+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_permissions	83	http://localhost:5173
572	create	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-16 13:04:44.181+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_permissions	84	http://localhost:5173
573	create	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-16 13:04:44.189+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_permissions	85	http://localhost:5173
409	delete	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-15 19:40:27.386+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_users	e52a7c50-f67a-4cf9-8943-4cf79085d707	http://localhost:5173
415	delete	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-16 09:09:19.482+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_users	6100cd72-3c35-451d-8690-7b6e95529546	http://localhost:5173
425	delete	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-16 11:05:44.898+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_collections	sexy_models	http://localhost:5173
426	delete	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-16 11:05:44.931+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_fields	46	http://localhost:5173
427	delete	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-16 11:05:44.939+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_fields	47	http://localhost:5173
428	delete	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-16 11:05:44.945+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_fields	48	http://localhost:5173
429	delete	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-16 11:05:44.951+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_fields	49	http://localhost:5173
430	delete	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-16 11:05:44.959+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_fields	50	http://localhost:5173
431	delete	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-16 11:05:44.967+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_fields	51	http://localhost:5173
432	delete	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-16 11:05:44.974+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_fields	52	http://localhost:5173
433	delete	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-16 11:05:44.98+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_fields	53	http://localhost:5173
434	delete	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-16 11:05:44.987+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_fields	54	http://localhost:5173
435	delete	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-16 11:05:44.998+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_fields	55	http://localhost:5173
436	delete	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-16 11:05:45.002+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_fields	56	http://localhost:5173
437	delete	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-16 11:05:45.006+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_fields	57	http://localhost:5173
438	delete	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-16 11:05:45.011+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_fields	58	http://localhost:5173
439	delete	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-16 11:05:45.015+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_fields	59	http://localhost:5173
440	delete	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-16 11:05:45.022+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_fields	60	http://localhost:5173
456	create	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-16 11:30:53.849+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_fields	75	http://localhost:5173
462	update	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-16 11:40:57.892+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_users	543f4d0b-e346-4e5e-8aca-4a9b35d5fab6	http://localhost:5173
465	create	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-16 11:41:41.474+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_files	14dc2f96-fa93-4b64-b0a5-1b8e586fe0e4	http://localhost:5173
475	create	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-16 12:03:50.672+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_permissions	40	http://localhost:5173
476	create	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-16 12:03:50.686+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_permissions	41	http://localhost:5173
477	create	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-16 12:03:50.7+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_permissions	42	http://localhost:5173
478	create	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-16 12:03:50.733+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_permissions	43	http://localhost:5173
479	create	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-16 12:03:50.758+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_permissions	44	http://localhost:5173
480	create	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-16 12:03:50.777+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_permissions	45	http://localhost:5173
481	create	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-16 12:03:50.783+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_permissions	46	http://localhost:5173
482	create	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-16 12:03:50.788+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_permissions	47	http://localhost:5173
483	create	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-16 12:03:50.793+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_permissions	48	http://localhost:5173
484	create	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-16 12:03:50.802+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_permissions	49	http://localhost:5173
485	create	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-16 12:03:50.818+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_permissions	50	http://localhost:5173
486	create	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-16 12:03:50.848+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_permissions	51	http://localhost:5173
487	create	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-16 12:03:50.872+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_permissions	52	http://localhost:5173
488	create	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-16 12:03:50.884+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_permissions	53	http://localhost:5173
410	delete	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-15 19:48:34.517+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_users	4af58c47-115f-4e65-b308-8aeca0fa5013	http://localhost:5173
416	update	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-16 09:33:47.01+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_users	4d310101-f7b1-47fe-982a-efe4abf25c55	http://localhost:5173
441	update	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-16 11:07:29.468+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_permissions	28	http://localhost:5173
442	update	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-16 11:07:29.518+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_policies	abf8a154-5b1c-4a46-ac9c-7300570f4f17	http://localhost:5173
443	create	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-16 11:12:15.827+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_fields	73	http://localhost:5173
444	update	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-16 11:12:20.947+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_fields	73	http://localhost:5173
445	update	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-16 11:12:21.001+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_fields	40	http://localhost:5173
446	create	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-16 11:12:43.435+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_fields	74	http://localhost:5173
447	update	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-16 11:13:28.661+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_fields	73	http://localhost:5173
622	delete	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-16 13:06:38.949+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_permissions	99	http://localhost:5173
457	update	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-16 11:31:25.819+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_users	4d310101-f7b1-47fe-982a-efe4abf25c55	http://localhost:5173
467	update	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-16 11:43:12.923+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_roles	55da25e6-9a87-4264-92e8-9066fdcf9c07	http://localhost:5173
489	create	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-16 12:03:50.89+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_permissions	54	http://localhost:5173
490	create	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-16 12:03:50.897+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_permissions	55	http://localhost:5173
491	create	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-16 12:03:50.908+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_permissions	56	http://localhost:5173
492	create	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-16 12:03:50.952+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_permissions	57	http://localhost:5173
493	create	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-16 12:03:50.974+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_permissions	58	http://localhost:5173
494	create	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-16 12:03:50.987+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_permissions	59	http://localhost:5173
495	create	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-16 12:03:50.995+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_permissions	60	http://localhost:5173
496	create	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-16 12:03:51.006+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_permissions	61	http://localhost:5173
497	create	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-16 12:03:51.024+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_permissions	62	http://localhost:5173
498	create	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-16 12:03:51.052+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_permissions	63	http://localhost:5173
499	create	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-16 12:03:51.084+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_permissions	64	http://localhost:5173
500	delete	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-16 12:03:51.103+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_permissions	28	http://localhost:5173
501	delete	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-16 12:03:51.104+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_permissions	36	http://localhost:5173
502	delete	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-16 12:03:51.105+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_permissions	38	http://localhost:5173
503	delete	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-16 12:03:51.106+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_permissions	39	http://localhost:5173
504	update	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-16 12:03:51.112+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_policies	abf8a154-5b1c-4a46-ac9c-7300570f4f17	http://localhost:5173
535	update	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-16 12:21:21.493+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_permissions	57	http://localhost:5173
536	update	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-16 12:21:21.509+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_policies	abf8a154-5b1c-4a46-ac9c-7300570f4f17	http://localhost:5173
545	update	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-16 12:50:02.998+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_policies	abf8a154-5b1c-4a46-ac9c-7300570f4f17	http://localhost:5173
551	create	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-16 12:59:51.344+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_policies	f575bea7-7260-4d81-a931-81d762f2b47d	http://localhost:5173
552	create	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-16 12:59:51.36+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_access	1e42d4ff-0ead-4651-a283-7b21a158d5ea	http://localhost:5173
574	create	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-16 13:04:44.2+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_permissions	86	http://localhost:5173
575	create	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-16 13:04:44.231+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_permissions	87	http://localhost:5173
411	delete	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-15 19:52:25.676+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_users	d0ecda60-51e5-4d20-8335-8e5b3fb8a697	http://localhost:5173
417	delete	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-16 09:38:26.501+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_users	9d1a3cdc-1703-4c8c-9c18-0549026af93c	http://localhost:5173
418	update	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-16 09:44:38.171+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_fields	40	http://localhost:5173
448	update	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-16 11:14:26.282+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_users	4d310101-f7b1-47fe-982a-efe4abf25c55	http://localhost:5173
458	update	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-16 11:32:21.3+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_users	4d310101-f7b1-47fe-982a-efe4abf25c55	http://localhost:5173
468	update	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-16 11:55:33.33+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_permissions	28	http://localhost:5173
469	update	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-16 11:55:33.338+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_policies	abf8a154-5b1c-4a46-ac9c-7300570f4f17	http://localhost:5173
505	update	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-16 12:07:45.389+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_permissions	57	http://localhost:5173
506	delete	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-16 12:07:45.439+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_permissions	41	http://localhost:5173
507	delete	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-16 12:07:45.448+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_permissions	43	http://localhost:5173
508	delete	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-16 12:07:45.452+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_permissions	44	http://localhost:5173
509	delete	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-16 12:07:45.457+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_permissions	45	http://localhost:5173
510	delete	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-16 12:07:45.461+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_permissions	46	http://localhost:5173
511	delete	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-16 12:07:45.465+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_permissions	47	http://localhost:5173
512	delete	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-16 12:07:45.47+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_permissions	48	http://localhost:5173
513	delete	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-16 12:07:45.475+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_permissions	49	http://localhost:5173
514	delete	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-16 12:07:45.478+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_permissions	50	http://localhost:5173
515	delete	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-16 12:07:45.483+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_permissions	51	http://localhost:5173
516	delete	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-16 12:07:45.487+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_permissions	52	http://localhost:5173
517	delete	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-16 12:07:45.495+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_permissions	53	http://localhost:5173
518	delete	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-16 12:07:45.499+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_permissions	54	http://localhost:5173
519	delete	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-16 12:07:45.502+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_permissions	55	http://localhost:5173
520	delete	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-16 12:07:45.511+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_permissions	56	http://localhost:5173
521	delete	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-16 12:07:45.521+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_permissions	58	http://localhost:5173
522	delete	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-16 12:07:45.527+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_permissions	59	http://localhost:5173
523	delete	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-16 12:07:45.534+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_permissions	60	http://localhost:5173
524	delete	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-16 12:07:45.541+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_permissions	61	http://localhost:5173
525	delete	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-16 12:07:45.547+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_permissions	62	http://localhost:5173
526	delete	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-16 12:07:45.552+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_permissions	63	http://localhost:5173
527	delete	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-16 12:07:45.556+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_permissions	64	http://localhost:5173
528	update	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-16 12:07:45.587+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_policies	abf8a154-5b1c-4a46-ac9c-7300570f4f17	http://localhost:5173
537	update	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-16 12:22:48.822+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_permissions	57	http://localhost:5173
538	update	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-16 12:22:48.837+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_policies	abf8a154-5b1c-4a46-ac9c-7300570f4f17	http://localhost:5173
546	update	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-16 12:51:19.203+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_policies	abf8a154-5b1c-4a46-ac9c-7300570f4f17	http://localhost:5173
412	delete	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-15 19:58:26.143+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_users	39ef1043-acb1-4a83-a6cd-eaf7d70d8279	http://localhost:5173
419	update	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-16 10:00:54.101+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_permissions	28	http://localhost:5173
420	update	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-16 10:00:54.128+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_policies	abf8a154-5b1c-4a46-ac9c-7300570f4f17	http://localhost:5173
449	update	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-16 11:21:03.782+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_permissions	28	http://localhost:5173
450	update	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-16 11:21:03.836+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_policies	abf8a154-5b1c-4a46-ac9c-7300570f4f17	http://localhost:5173
452	update	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-16 11:22:54.84+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_policies	656e614d-a1aa-4b89-936a-e2c730fc85e1	http://localhost:5173
459	create	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-16 11:34:47.096+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_fields	76	http://localhost:5173
470	create	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-16 11:59:17.059+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_permissions	38	http://localhost:5173
471	update	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-16 11:59:17.085+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_policies	abf8a154-5b1c-4a46-ac9c-7300570f4f17	http://localhost:5173
529	update	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-16 12:09:31.376+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_permissions	57	http://localhost:5173
530	update	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-16 12:09:31.421+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_policies	abf8a154-5b1c-4a46-ac9c-7300570f4f17	http://localhost:5173
539	create	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-16 12:44:08.175+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_permissions	65	http://localhost:5173
540	create	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-16 12:44:08.204+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_permissions	66	http://localhost:5173
541	update	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-16 12:44:08.218+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_policies	abf8a154-5b1c-4a46-ac9c-7300570f4f17	http://localhost:5173
547	update	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-16 12:55:13.375+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_policies	abf8a154-5b1c-4a46-ac9c-7300570f4f17	http://localhost:5173
553	create	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-16 13:00:26.719+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_policies	895bd74b-97d6-4bae-87fa-8741a717127e	http://localhost:5173
576	create	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-16 13:04:44.251+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_permissions	88	http://localhost:5173
577	create	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-16 13:04:44.264+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_permissions	89	http://localhost:5173
578	update	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-16 13:04:44.281+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_permissions	71	http://localhost:5173
579	update	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-16 13:04:44.289+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_permissions	70	http://localhost:5173
580	update	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-16 13:04:44.3+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_policies	f575bea7-7260-4d81-a931-81d762f2b47d	http://localhost:5173
581	update	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-16 13:04:44.345+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_access	1e42d4ff-0ead-4651-a283-7b21a158d5ea	http://localhost:5173
593	update	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-16 13:06:38.753+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_permissions	70	http://localhost:5173
594	update	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-16 13:06:38.769+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_permissions	95	http://localhost:5173
595	update	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-16 13:06:38.785+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_permissions	73	http://localhost:5173
596	update	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-16 13:06:38.822+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_permissions	72	http://localhost:5173
597	update	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-16 13:06:38.852+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_permissions	71	http://localhost:5173
598	delete	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-16 13:06:38.866+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_permissions	74	http://localhost:5173
599	delete	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-16 13:06:38.867+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_permissions	75	http://localhost:5173
600	delete	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-16 13:06:38.868+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_permissions	76	http://localhost:5173
601	delete	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-16 13:06:38.872+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_permissions	77	http://localhost:5173
602	delete	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-16 13:06:38.874+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_permissions	78	http://localhost:5173
603	delete	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-16 13:06:38.878+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_permissions	79	http://localhost:5173
604	delete	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-16 13:06:38.881+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_permissions	80	http://localhost:5173
612	delete	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-16 13:06:38.918+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_permissions	88	http://localhost:5173
613	delete	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-16 13:06:38.92+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_permissions	89	http://localhost:5173
614	delete	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-16 13:06:38.923+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_permissions	90	http://localhost:5173
615	delete	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-16 13:06:38.928+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_permissions	91	http://localhost:5173
616	delete	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-16 13:06:38.931+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_permissions	92	http://localhost:5173
617	delete	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-16 13:06:38.935+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_permissions	93	http://localhost:5173
618	delete	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-16 13:06:38.937+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_permissions	94	http://localhost:5173
619	delete	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-16 13:06:38.939+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_permissions	96	http://localhost:5173
620	delete	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-16 13:06:38.94+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_permissions	97	http://localhost:5173
623	update	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-16 13:06:38.955+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_policies	f575bea7-7260-4d81-a931-81d762f2b47d	http://localhost:5173
624	update	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-16 13:08:44.751+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_permissions	71	http://localhost:5173
625	update	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-16 13:08:44.773+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_policies	f575bea7-7260-4d81-a931-81d762f2b47d	http://localhost:5173
626	update	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-16 13:09:37.917+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_permissions	71	http://localhost:5173
627	update	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-16 13:09:37.924+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_policies	f575bea7-7260-4d81-a931-81d762f2b47d	http://localhost:5173
628	update	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-16 13:11:15.985+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_permissions	71	http://localhost:5173
629	update	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-16 13:11:15.996+00	172.18.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_policies	f575bea7-7260-4d81-a931-81d762f2b47d	http://localhost:5173
630	login	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-20 13:53:57.281+00	172.19.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_users	4d310101-f7b1-47fe-982a-efe4abf25c55	http://localhost:5173
670	login	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-20 20:43:20.629+00	172.19.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_users	4d310101-f7b1-47fe-982a-efe4abf25c55	http://localhost:5173
631	update	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-20 13:55:29.745+00	172.19.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_fields	73	http://localhost:5173
632	update	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-20 13:55:53.465+00	172.19.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_fields	74	http://localhost:5173
633	update	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-20 13:56:14.402+00	172.19.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_fields	75	http://localhost:5173
634	update	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-20 13:57:14.339+00	172.19.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_fields	76	http://localhost:5173
635	update	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-20 13:58:07.332+00	172.19.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_fields	76	http://localhost:5173
636	update	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-20 14:02:06.279+00	172.19.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_fields	76	http://localhost:5173
637	update	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-20 14:04:45.418+00	172.19.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_fields	76	http://localhost:5173
638	update	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-20 14:05:49.522+00	172.19.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_fields	76	http://localhost:5173
639	update	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-20 14:06:28.433+00	172.19.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_fields	76	http://localhost:5173
640	update	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-20 14:06:55.341+00	172.19.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_fields	76	http://localhost:5173
641	update	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-20 14:08:31.74+00	172.19.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_fields	76	http://localhost:5173
642	update	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-20 14:09:09.579+00	172.19.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_fields	76	http://localhost:5173
643	update	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-20 14:11:10.24+00	172.19.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_fields	74	http://localhost:5173
644	update	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-20 14:50:49.197+00	172.19.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_fields	75	http://localhost:5173
645	update	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-20 14:59:40.84+00	172.19.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_fields	73	http://localhost:5173
646	update	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-20 14:59:52.227+00	172.19.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_fields	74	http://localhost:5173
647	update	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-20 14:59:58.83+00	172.19.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_fields	75	http://localhost:5173
648	update	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-20 15:08:29.162+00	172.19.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_fields	73	http://localhost:5173
649	update	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-20 15:19:45.967+00	172.19.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_fields	74	http://localhost:5173
650	update	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-20 15:19:53.925+00	172.19.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_fields	75	http://localhost:5173
651	update	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-20 15:27:28.083+00	172.19.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_fields	76	http://localhost:5173
652	update	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-20 15:27:36.657+00	172.19.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_fields	75	http://localhost:5173
653	update	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-20 15:27:45.885+00	172.19.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_fields	74	http://localhost:5173
654	create	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-20 15:32:02.503+00	172.19.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_permissions	100	http://localhost:5173
655	update	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-20 15:32:02.526+00	172.19.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_policies	338928fb-f8ee-4450-8b24-4854dd8bc7e0	http://localhost:5173
656	delete	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-20 16:54:49.617+00	172.19.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_fields	73	http://localhost:5173
657	create	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-20 16:55:07.299+00	172.19.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_fields	77	http://localhost:5173
658	update	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-20 16:55:15.873+00	172.19.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_fields	77	http://localhost:5173
659	update	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-20 16:55:15.899+00	172.19.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_fields	40	http://localhost:5173
660	update	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-20 16:55:15.915+00	172.19.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_fields	74	http://localhost:5173
661	update	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-20 16:55:15.941+00	172.19.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_fields	75	http://localhost:5173
662	update	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-20 16:55:15.971+00	172.19.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_fields	76	http://localhost:5173
663	update	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-20 16:59:08.999+00	172.19.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_users	543f4d0b-e346-4e5e-8aca-4a9b35d5fab6	http://localhost:5173
664	update	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-20 16:59:22.904+00	172.19.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_users	4d310101-f7b1-47fe-982a-efe4abf25c55	http://localhost:5173
665	delete	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-20 16:59:53.364+00	172.19.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_users	1dae9c9a-0752-4772-adf3-94b5d00d7e0e	http://localhost:5173
666	update	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-20 19:38:09.149+00	172.19.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_users	4d310101-f7b1-47fe-982a-efe4abf25c55	http://localhost:5173
667	update	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-20 19:38:21.771+00	172.19.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_users	4d310101-f7b1-47fe-982a-efe4abf25c55	http://localhost:5173
668	update	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-20 19:38:29.752+00	172.19.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_users	4d310101-f7b1-47fe-982a-efe4abf25c55	http://localhost:5173
669	update	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-20 20:19:37.508+00	172.19.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_users	4d310101-f7b1-47fe-982a-efe4abf25c55	http://localhost:5173
671	login	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-20 20:50:56.54+00	77.181.250.163	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	directus_users	4d310101-f7b1-47fe-982a-efe4abf25c55	https://sexy.pivoine.art
672	login	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-20 21:12:32.361+00	77.181.250.163	Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Mobile Safari/537.36	directus_users	4d310101-f7b1-47fe-982a-efe4abf25c55	https://sexy.pivoine.art
673	update	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-20 21:14:30.748+00	77.181.250.163	Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Mobile Safari/537.36	directus_users	4d310101-f7b1-47fe-982a-efe4abf25c55	https://sexy.pivoine.art
674	login	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-21 01:10:25.692+00	77.184.200.164	Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Mobile Safari/537.36	directus_users	4d310101-f7b1-47fe-982a-efe4abf25c55	https://sexy.pivoine.art
675	update	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-21 01:11:02.137+00	77.184.200.164	Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Mobile Safari/537.36	directus_users	4d310101-f7b1-47fe-982a-efe4abf25c55	https://sexy.pivoine.art
676	update	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-21 01:11:27.351+00	77.184.200.164	Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Mobile Safari/537.36	directus_users	4d310101-f7b1-47fe-982a-efe4abf25c55	https://sexy.pivoine.art
677	update	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-21 01:11:33.599+00	77.184.200.164	Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Mobile Safari/537.36	directus_users	4d310101-f7b1-47fe-982a-efe4abf25c55	https://sexy.pivoine.art
678	update	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-21 01:11:40.136+00	77.184.200.164	Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Mobile Safari/537.36	directus_users	4d310101-f7b1-47fe-982a-efe4abf25c55	https://sexy.pivoine.art
679	update	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-21 01:12:12.688+00	77.184.200.164	Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Mobile Safari/537.36	directus_users	4d310101-f7b1-47fe-982a-efe4abf25c55	https://sexy.pivoine.art
680	login	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-21 01:13:00.376+00	77.184.200.164	Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Mobile Safari/537.36	directus_users	4d310101-f7b1-47fe-982a-efe4abf25c55	https://sexy.pivoine.art
681	update	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-21 01:13:15.449+00	77.184.200.164	Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Mobile Safari/537.36	directus_users	4d310101-f7b1-47fe-982a-efe4abf25c55	https://sexy.pivoine.art
682	update	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-21 01:13:32.895+00	77.184.200.164	Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Mobile Safari/537.36	directus_users	4d310101-f7b1-47fe-982a-efe4abf25c55	https://sexy.pivoine.art
683	login	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-21 01:35:21.221+00	77.184.200.164	Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Mobile Safari/537.36	directus_users	4d310101-f7b1-47fe-982a-efe4abf25c55	https://sexy.pivoine.art
684	update	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-21 01:35:44.237+00	77.184.200.164	Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Mobile Safari/537.36	directus_users	4d310101-f7b1-47fe-982a-efe4abf25c55	https://sexy.pivoine.art
685	update	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-21 01:36:55.621+00	77.184.200.164	Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Mobile Safari/537.36	directus_users	4d310101-f7b1-47fe-982a-efe4abf25c55	https://sexy.pivoine.art
686	update	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-21 01:37:08.947+00	77.184.200.164	Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Mobile Safari/537.36	directus_users	4d310101-f7b1-47fe-982a-efe4abf25c55	https://sexy.pivoine.art
687	login	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-21 09:30:48.681+00	176.3.139.166	Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Mobile Safari/537.36	directus_users	4d310101-f7b1-47fe-982a-efe4abf25c55	https://sexy.pivoine.art
688	update	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-21 10:21:22.97+00	77.184.200.164	Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Mobile Safari/537.36	directus_users	4d310101-f7b1-47fe-982a-efe4abf25c55	https://sexy.pivoine.art
689	login	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-21 16:35:52.142+00	172.19.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_users	4d310101-f7b1-47fe-982a-efe4abf25c55	http://localhost:5173
712	create	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-22 17:07:35.022+00	172.19.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_files	00b43d74-632e-4170-b385-26782ac3f442	http://localhost:5173
756	login	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-26 00:37:52.121+00	172.19.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_users	4d310101-f7b1-47fe-982a-efe4abf25c55	http://localhost:5173
757	login	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-26 00:45:10.784+00	172.19.0.1	Mozilla/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.5 Mobile/15E148 Safari/604.1	directus_users	4d310101-f7b1-47fe-982a-efe4abf25c55	http://localhost:5173
832	login	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-26 20:46:49.558+00	172.19.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_users	4d310101-f7b1-47fe-982a-efe4abf25c55	http://localhost:5173
866	delete	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-27 17:56:32.17+00	172.19.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_fields	94	http://localhost:5173
867	create	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-27 17:57:16.445+00	172.19.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_fields	95	http://localhost:5173
870	delete	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-27 18:00:38.369+00	172.19.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_fields	96	http://localhost:5173
871	create	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-27 18:01:31.858+00	172.19.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_fields	97	http://localhost:5173
872	create	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-27 18:01:32.084+00	172.19.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_fields	98	http://localhost:5173
873	create	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-27 18:01:32.091+00	172.19.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_collections	junction_directus_users_videos	http://localhost:5173
874	create	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-27 18:01:32.223+00	172.19.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_fields	99	http://localhost:5173
875	create	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-27 18:01:32.404+00	172.19.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_fields	100	http://localhost:5173
876	create	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-27 18:01:32.591+00	172.19.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_fields	101	http://localhost:5173
903	create	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-27 22:37:10.083+00	172.19.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_files	83c90c5c-5877-482c-8043-daa4d28e58de	http://localhost:5173
944	update	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-28 01:44:03.876+00	172.19.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_permissions	71	http://localhost:5173
945	update	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-28 01:44:03.938+00	172.19.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_policies	f575bea7-7260-4d81-a931-81d762f2b47d	http://localhost:5173
969	update	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-28 11:34:29.501+00	172.19.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_files	65637bef-30e5-4605-8d79-59c8814baa40	http://localhost:5173
970	update	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-28 11:34:29.586+00	172.19.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_files	65637bef-30e5-4605-8d79-59c8814baa40	http://localhost:5173
998	update	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-28 13:53:35.461+00	172.19.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_files	65637bef-30e5-4605-8d79-59c8814baa40	http://localhost:5173
999	update	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-28 13:53:35.522+00	172.19.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_files	65637bef-30e5-4605-8d79-59c8814baa40	http://localhost:5173
1001	delete	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-28 13:54:04.359+00	172.19.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_files	65637bef-30e5-4605-8d79-59c8814baa40	http://localhost:5173
690	update	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-21 16:45:14.93+00	172.19.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_permissions	71	http://localhost:5173
691	update	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-21 16:45:14.952+00	172.19.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_policies	f575bea7-7260-4d81-a931-81d762f2b47d	http://localhost:5173
713	update	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-22 17:07:51.327+00	172.19.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_users	4d310101-f7b1-47fe-982a-efe4abf25c55	http://localhost:5173
759	login	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-26 13:22:24.888+00	172.19.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_users	4d310101-f7b1-47fe-982a-efe4abf25c55	http://localhost:5173
760	create	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-26 13:23:29.927+00	172.19.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_folders	26657630-d9cd-47a3-9e45-9831f3674f97	http://localhost:5173
761	create	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-26 13:24:08.06+00	172.19.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_folders	3f83c727-9c90-4e0d-871f-ab81c295043a	http://localhost:5173
763	delete	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-26 13:26:02.526+00	172.19.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_fields	69	http://localhost:5173
764	create	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-26 13:27:17.026+00	172.19.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_fields	78	http://localhost:5173
765	create	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-26 13:28:05.082+00	172.19.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_fields	79	http://localhost:5173
766	create	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-26 13:28:05.33+00	172.19.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_fields	80	http://localhost:5173
767	create	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-26 13:28:05.335+00	172.19.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_collections	sexy_videos_directus_users	http://localhost:5173
768	create	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-26 13:28:05.471+00	172.19.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_fields	81	http://localhost:5173
833	create	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-26 20:47:33.359+00	172.19.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_permissions	102	http://localhost:5173
834	delete	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-26 20:47:33.378+00	172.19.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_permissions	101	http://localhost:5173
835	update	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-26 20:47:33.384+00	172.19.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_policies	f575bea7-7260-4d81-a931-81d762f2b47d	http://localhost:5173
868	delete	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-27 17:57:55.588+00	172.19.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_fields	95	http://localhost:5173
869	create	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-27 17:59:48.436+00	172.19.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_fields	96	http://localhost:5173
916	create	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-27 23:28:35.757+00	172.19.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_files	bfe902fa-b686-428f-9bd1-a63aba784034	http://localhost:5173
919	create	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-27 23:29:18.956+00	172.19.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_files	2f1293ca-a23e-4f8c-9f11-9ab095c793e1	http://localhost:5173
920	update	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-27 23:29:22.19+00	172.19.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_users	4d310101-f7b1-47fe-982a-efe4abf25c55	http://localhost:5173
946	login	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-28 01:59:51.912+00	172.19.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_users	4d310101-f7b1-47fe-982a-efe4abf25c55	http://localhost:5173
971	update	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-28 11:45:13.441+00	172.19.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_files	65637bef-30e5-4605-8d79-59c8814baa40	http://localhost:5173
972	update	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-28 11:45:13.56+00	172.19.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_files	65637bef-30e5-4605-8d79-59c8814baa40	http://localhost:5173
692	update	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-21 16:46:44.207+00	172.19.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_permissions	71	http://localhost:5173
693	update	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-21 16:46:44.234+00	172.19.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_policies	f575bea7-7260-4d81-a931-81d762f2b47d	http://localhost:5173
714	delete	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-22 17:26:01.93+00	172.19.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_files	00b43d74-632e-4170-b385-26782ac3f442	http://localhost:5173
762	update	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-26 13:25:14.796+00	172.19.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_folders	3f83c727-9c90-4e0d-871f-ab81c295043a	http://localhost:5173
769	create	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-26 13:28:05.762+00	172.19.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_fields	82	http://localhost:5173
770	update	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-26 13:29:26.913+00	172.19.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_fields	79	http://localhost:5173
771	update	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-26 13:29:36.515+00	172.19.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_fields	61	http://localhost:5173
772	update	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-26 13:29:36.532+00	172.19.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_fields	62	http://localhost:5173
773	update	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-26 13:29:36.551+00	172.19.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_fields	63	http://localhost:5173
774	update	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-26 13:29:36.581+00	172.19.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_fields	64	http://localhost:5173
775	update	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-26 13:29:36.595+00	172.19.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_fields	65	http://localhost:5173
776	update	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-26 13:29:36.607+00	172.19.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_fields	66	http://localhost:5173
777	update	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-26 13:29:36.622+00	172.19.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_fields	67	http://localhost:5173
778	update	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-26 13:29:36.633+00	172.19.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_fields	68	http://localhost:5173
779	update	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-26 13:29:36.651+00	172.19.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_fields	79	http://localhost:5173
780	update	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-26 13:29:36.662+00	172.19.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_fields	70	http://localhost:5173
781	update	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-26 13:29:36.671+00	172.19.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_fields	71	http://localhost:5173
782	update	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-26 13:29:36.689+00	172.19.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_fields	72	http://localhost:5173
783	update	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-26 13:29:36.698+00	172.19.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_fields	78	http://localhost:5173
784	create	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-26 13:31:36.303+00	172.19.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_fields	83	http://localhost:5173
785	update	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-26 13:31:45.346+00	172.19.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_fields	61	http://localhost:5173
786	update	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-26 13:31:45.361+00	172.19.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_fields	62	http://localhost:5173
787	update	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-26 13:31:45.369+00	172.19.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_fields	63	http://localhost:5173
788	update	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-26 13:31:45.383+00	172.19.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_fields	64	http://localhost:5173
789	update	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-26 13:31:45.399+00	172.19.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_fields	65	http://localhost:5173
790	update	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-26 13:31:45.418+00	172.19.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_fields	66	http://localhost:5173
791	update	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-26 13:31:45.432+00	172.19.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_fields	67	http://localhost:5173
792	update	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-26 13:31:45.446+00	172.19.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_fields	68	http://localhost:5173
793	update	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-26 13:31:45.454+00	172.19.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_fields	83	http://localhost:5173
794	update	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-26 13:31:45.468+00	172.19.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_fields	79	http://localhost:5173
795	update	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-26 13:31:45.484+00	172.19.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_fields	70	http://localhost:5173
796	update	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-26 13:31:45.495+00	172.19.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_fields	71	http://localhost:5173
797	update	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-26 13:31:45.501+00	172.19.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_fields	72	http://localhost:5173
798	update	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-26 13:31:45.517+00	172.19.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_fields	78	http://localhost:5173
836	login	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-26 21:33:15.09+00	172.19.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_users	4d310101-f7b1-47fe-982a-efe4abf25c55	http://localhost:5173
694	login	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-22 00:45:38.393+00	172.19.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_users	4d310101-f7b1-47fe-982a-efe4abf25c55	http://localhost:5173
695	update	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-22 00:49:40.174+00	172.19.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_users	4d310101-f7b1-47fe-982a-efe4abf25c55	http://localhost:5173
696	update	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-22 00:49:50.222+00	172.19.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_users	4d310101-f7b1-47fe-982a-efe4abf25c55	http://localhost:5173
715	create	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-22 18:08:34.508+00	172.19.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_files	b09b0973-ba94-4d25-be82-e332fdd53940	http://localhost:5173
716	update	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-22 18:08:34.611+00	172.19.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_users	4d310101-f7b1-47fe-982a-efe4abf25c55	http://localhost:5173
717	delete	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-22 18:09:16.067+00	172.19.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_files	b09b0973-ba94-4d25-be82-e332fdd53940	http://localhost:5173
718	create	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-22 18:09:25.561+00	172.19.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_files	aaee7bff-e6ce-426c-9abd-8cc11e91de8e	http://localhost:5173
719	update	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-22 18:09:25.645+00	172.19.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_users	4d310101-f7b1-47fe-982a-efe4abf25c55	http://localhost:5173
720	create	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-22 18:10:25.821+00	172.19.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_files	98ffb887-23d2-4e02-9635-3c7da1170121	http://localhost:5173
799	update	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-26 13:54:28.939+00	172.19.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_fields	68	http://localhost:5173
800	create	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-26 13:55:27.904+00	172.19.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_files	bab78ff3-10bf-4fc6-9e3a-6e58bb6655b1	http://localhost:5173
837	create	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-26 21:34:59.441+00	172.19.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_fields	85	http://localhost:5173
877	delete	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-27 18:03:11.035+00	172.19.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_fields	97	http://localhost:5173
917	create	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-27 23:28:51.753+00	172.19.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_files	b85b3008-f592-4676-8c84-666e0a60423d	http://localhost:5173
918	update	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-27 23:28:56.492+00	172.19.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_users	543f4d0b-e346-4e5e-8aca-4a9b35d5fab6	http://localhost:5173
922	update	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-27 23:31:04.519+00	172.19.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_files	b85b3008-f592-4676-8c84-666e0a60423d	http://localhost:5173
926	create	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-27 23:31:44.555+00	172.19.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_files	e77c58c1-f718-4b7a-b34c-c42861c8122f	http://localhost:5173
927	update	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-27 23:32:18.781+00	172.19.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_users	4d310101-f7b1-47fe-982a-efe4abf25c55	http://localhost:5173
947	create	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-28 02:02:05.035+00	172.19.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_files	d3f53a9b-bbce-436c-a6f4-04e5ef120d7e	http://localhost:5173
973	update	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-28 11:46:08.92+00	172.19.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_files	65637bef-30e5-4605-8d79-59c8814baa40	http://localhost:5173
974	update	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-28 11:46:08.941+00	172.19.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_files	65637bef-30e5-4605-8d79-59c8814baa40	http://localhost:5173
697	update	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-22 06:42:49.249+00	172.19.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_users	4d310101-f7b1-47fe-982a-efe4abf25c55	http://localhost:5173
698	update	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-22 06:44:00.949+00	172.19.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_users	4d310101-f7b1-47fe-982a-efe4abf25c55	http://localhost:5173
699	login	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-22 11:36:02.287+00	172.19.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_users	4d310101-f7b1-47fe-982a-efe4abf25c55	http://localhost:5173
721	update	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-22 18:10:58.843+00	172.19.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_users	543f4d0b-e346-4e5e-8aca-4a9b35d5fab6	http://localhost:5173
801	create	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-26 13:56:46.03+00	172.19.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_files	3001a83c-3033-4dd1-b3ac-c910bdb1ef2c	http://localhost:5173
802	create	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-26 13:56:55.561+00	172.19.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	sexy_videos_directus_users	1	http://localhost:5173
803	create	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-26 13:56:55.564+00	172.19.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	sexy_videos_directus_users	2	http://localhost:5173
804	create	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-26 13:56:55.568+00	172.19.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	sexy_videos	75296c46-3c71-4182-a4ce-416722377d76	http://localhost:5173
805	update	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-26 13:57:11.056+00	172.19.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	sexy_videos	75296c46-3c71-4182-a4ce-416722377d76	http://localhost:5173
838	delete	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-26 21:37:44.408+00	172.19.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_fields	85	http://localhost:5173
839	create	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-26 21:39:16.654+00	172.19.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_fields	86	http://localhost:5173
840	delete	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-26 21:39:51.289+00	172.19.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_fields	86	http://localhost:5173
841	create	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-26 21:40:36.439+00	172.19.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_fields	87	http://localhost:5173
842	delete	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-26 21:41:11.25+00	172.19.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_fields	87	http://localhost:5173
843	create	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-26 21:42:53.716+00	172.19.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_fields	88	http://localhost:5173
844	delete	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-26 21:44:13.79+00	172.19.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_fields	88	http://localhost:5173
845	create	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-26 21:46:48.132+00	172.19.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_fields	89	http://localhost:5173
846	create	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-26 21:46:48.359+00	172.19.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_fields	90	http://localhost:5173
847	create	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-26 21:46:48.381+00	172.19.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_collections	sexy_videos_comments	http://localhost:5173
848	create	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-26 21:46:48.496+00	172.19.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_fields	91	http://localhost:5173
849	create	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-26 21:46:48.666+00	172.19.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_fields	92	http://localhost:5173
850	create	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-26 21:46:48.857+00	172.19.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_fields	93	http://localhost:5173
878	delete	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-27 18:04:09.067+00	172.19.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_collections	junction_directus_users_videos	http://localhost:5173
879	delete	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-27 18:04:09.093+00	172.19.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_fields	98	http://localhost:5173
880	delete	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-27 18:04:09.096+00	172.19.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_fields	99	http://localhost:5173
881	delete	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-27 18:04:09.101+00	172.19.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_fields	100	http://localhost:5173
882	delete	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-27 18:04:09.108+00	172.19.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_fields	101	http://localhost:5173
921	delete	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-27 23:30:50.531+00	172.19.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_files	bfe902fa-b686-428f-9bd1-a63aba784034	http://localhost:5173
923	delete	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-27 23:31:15.769+00	172.19.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_files	98ffb887-23d2-4e02-9635-3c7da1170121	http://localhost:5173
924	delete	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-27 23:31:15.773+00	172.19.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_files	aaee7bff-e6ce-426c-9abd-8cc11e91de8e	http://localhost:5173
925	delete	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-27 23:31:33.236+00	172.19.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_files	2f1293ca-a23e-4f8c-9f11-9ab095c793e1	http://localhost:5173
948	update	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-28 02:02:49.93+00	172.19.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_users	4d310101-f7b1-47fe-982a-efe4abf25c55	http://localhost:5173
949	login	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-28 08:13:35.797+00	172.19.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_users	4d310101-f7b1-47fe-982a-efe4abf25c55	http://localhost:5173
700	update	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-22 12:02:20.782+00	172.19.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_fields	40	http://localhost:5173
722	create	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-22 18:11:39.887+00	172.19.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_files	98e7a436-12c0-4c5b-8738-cf93a86b2a4d	http://localhost:5173
723	update	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-22 18:11:39.983+00	172.19.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_users	4d310101-f7b1-47fe-982a-efe4abf25c55	http://localhost:5173
724	create	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-22 18:11:48.402+00	172.19.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_files	fee51247-fdad-4a6b-96a5-ce0e263daa2d	http://localhost:5173
725	update	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-22 18:11:48.498+00	172.19.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_users	4d310101-f7b1-47fe-982a-efe4abf25c55	http://localhost:5173
726	delete	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-22 19:13:35.219+00	172.19.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_files	fee51247-fdad-4a6b-96a5-ce0e263daa2d	http://localhost:5173
727	update	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-22 19:13:35.311+00	172.19.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_users	4d310101-f7b1-47fe-982a-efe4abf25c55	http://localhost:5173
728	create	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-22 19:13:54.481+00	172.19.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_files	81ae7ebe-2ece-457e-817b-e5dab626c6f7	http://localhost:5173
729	update	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-22 19:13:54.582+00	172.19.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_users	4d310101-f7b1-47fe-982a-efe4abf25c55	http://localhost:5173
730	delete	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-22 19:15:36.743+00	172.19.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_files	81ae7ebe-2ece-457e-817b-e5dab626c6f7	http://localhost:5173
731	create	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-22 19:15:36.832+00	172.19.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_files	b605cbfd-d9c6-47de-97e5-a4c2b4100c28	http://localhost:5173
732	update	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-22 19:15:36.972+00	172.19.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_users	4d310101-f7b1-47fe-982a-efe4abf25c55	http://localhost:5173
733	delete	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-22 19:15:46.949+00	172.19.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_files	b605cbfd-d9c6-47de-97e5-a4c2b4100c28	http://localhost:5173
734	create	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-22 19:15:47.012+00	172.19.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_files	470442ff-7eeb-4536-b5ac-6538e569c5b0	http://localhost:5173
735	update	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-22 19:15:47.116+00	172.19.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_users	4d310101-f7b1-47fe-982a-efe4abf25c55	http://localhost:5173
736	delete	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-22 19:17:32.783+00	172.19.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_files	470442ff-7eeb-4536-b5ac-6538e569c5b0	http://localhost:5173
737	update	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-22 19:17:32.859+00	172.19.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_users	4d310101-f7b1-47fe-982a-efe4abf25c55	http://localhost:5173
738	create	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-22 19:17:40.675+00	172.19.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_files	60f8b2e5-c2a8-4f2a-8262-e2db6e2f33eb	http://localhost:5173
739	update	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-22 19:17:40.785+00	172.19.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_users	4d310101-f7b1-47fe-982a-efe4abf25c55	http://localhost:5173
806	create	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-26 14:17:26.828+00	172.19.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_fields	84	http://localhost:5173
807	update	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-26 14:17:38.141+00	172.19.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_fields	61	http://localhost:5173
808	update	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-26 14:17:38.16+00	172.19.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_fields	62	http://localhost:5173
809	update	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-26 14:17:38.176+00	172.19.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_fields	63	http://localhost:5173
810	update	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-26 14:17:38.193+00	172.19.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_fields	64	http://localhost:5173
811	update	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-26 14:17:38.212+00	172.19.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_fields	65	http://localhost:5173
812	update	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-26 14:17:38.244+00	172.19.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_fields	66	http://localhost:5173
813	update	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-26 14:17:38.27+00	172.19.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_fields	67	http://localhost:5173
814	update	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-26 14:17:38.279+00	172.19.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_fields	84	http://localhost:5173
815	update	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-26 14:17:38.307+00	172.19.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_fields	68	http://localhost:5173
816	update	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-26 14:17:38.319+00	172.19.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_fields	83	http://localhost:5173
817	update	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-26 14:17:38.33+00	172.19.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_fields	79	http://localhost:5173
818	update	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-26 14:17:38.341+00	172.19.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_fields	70	http://localhost:5173
819	update	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-26 14:17:38.359+00	172.19.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_fields	71	http://localhost:5173
701	update	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-22 12:02:40.751+00	172.19.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_users	4d310101-f7b1-47fe-982a-efe4abf25c55	http://localhost:5173
740	delete	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-22 19:29:22.672+00	172.19.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_files	60f8b2e5-c2a8-4f2a-8262-e2db6e2f33eb	http://localhost:5173
741	delete	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-22 19:29:22.676+00	172.19.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_files	98e7a436-12c0-4c5b-8738-cf93a86b2a4d	http://localhost:5173
820	update	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-26 14:17:38.37+00	172.19.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_fields	72	http://localhost:5173
821	update	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-26 14:17:38.377+00	172.19.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_fields	78	http://localhost:5173
851	create	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-26 22:56:54.845+00	172.19.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_comments	034e7209-1751-4797-bab4-519a3d4f2eac	http://localhost:5173
852	create	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-26 22:57:28.002+00	172.19.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_comments	992cfc88-fcaf-4c7e-8f39-d6ba9c7f6d94	http://localhost:5173
853	delete	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-26 23:01:08.71+00	172.19.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_fields	89	http://localhost:5173
883	delete	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-27 18:30:30.18+00	172.19.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_collections	sexy_videos_comments	http://localhost:5173
884	delete	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-27 18:30:30.207+00	172.19.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_fields	90	http://localhost:5173
885	delete	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-27 18:30:30.214+00	172.19.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_fields	91	http://localhost:5173
886	delete	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-27 18:30:30.228+00	172.19.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_fields	92	http://localhost:5173
887	delete	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-27 18:30:30.234+00	172.19.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_fields	93	http://localhost:5173
928	update	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-27 23:34:56.776+00	172.19.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	junction_directus_users_files	1	http://localhost:5173
929	update	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-27 23:34:56.791+00	172.19.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_users	4d310101-f7b1-47fe-982a-efe4abf25c55	http://localhost:5173
950	update	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-28 09:26:43.627+00	172.19.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_files	3001a83c-3033-4dd1-b3ac-c910bdb1ef2c	http://localhost:5173
951	update	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-28 09:26:43.719+00	172.19.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_files	3001a83c-3033-4dd1-b3ac-c910bdb1ef2c	http://localhost:5173
977	update	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-28 11:54:29.815+00	172.19.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_files	65637bef-30e5-4605-8d79-59c8814baa40	http://localhost:5173
702	update	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-22 12:04:08.454+00	172.19.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_fields	40	http://localhost:5173
742	update	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-22 19:29:57.611+00	172.19.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_users	4d310101-f7b1-47fe-982a-efe4abf25c55	http://localhost:5173
822	update	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-26 14:18:32.933+00	172.19.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	sexy_videos	75296c46-3c71-4182-a4ce-416722377d76	http://localhost:5173
854	create	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-26 23:18:48.259+00	172.19.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_comments	6fd98c72-bc4f-4737-b327-0ef803f85d94	http://localhost:5173
888	create	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-27 18:39:15.968+00	172.19.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_folders	a21e028c-52de-4bc2-8b74-2633194267ab	http://localhost:5173
889	update	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-27 18:39:27.618+00	172.19.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_folders	5f184291-9a58-4914-9756-ad910378bd90	http://localhost:5173
890	create	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-27 18:39:39.454+00	172.19.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_folders	4cb93083-f3f7-4a61-a80f-d56fd9e6ee62	http://localhost:5173
930	create	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-28 00:35:15.633+00	172.19.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_permissions	103	http://localhost:5173
931	update	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-28 00:35:15.653+00	172.19.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_policies	f575bea7-7260-4d81-a931-81d762f2b47d	http://localhost:5173
952	update	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-28 10:53:23.144+00	172.19.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_files	3001a83c-3033-4dd1-b3ac-c910bdb1ef2c	http://localhost:5173
953	update	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-28 10:53:23.213+00	172.19.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_files	3001a83c-3033-4dd1-b3ac-c910bdb1ef2c	http://localhost:5173
978	update	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-28 11:56:50.805+00	172.19.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_files	65637bef-30e5-4605-8d79-59c8814baa40	http://localhost:5173
703	update	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-22 12:04:32.608+00	172.19.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_users	4d310101-f7b1-47fe-982a-efe4abf25c55	http://localhost:5173
743	login	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-23 12:31:27.727+00	172.19.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_users	4d310101-f7b1-47fe-982a-efe4abf25c55	http://localhost:5173
823	update	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-26 15:08:24.323+00	172.19.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	sexy_videos	75296c46-3c71-4182-a4ce-416722377d76	http://localhost:5173
855	delete	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-27 06:33:33.265+00	172.19.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_comments	6fd98c72-bc4f-4737-b327-0ef803f85d94	http://localhost:5173
856	delete	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-27 06:33:38.043+00	172.19.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_comments	992cfc88-fcaf-4c7e-8f39-d6ba9c7f6d94	http://localhost:5173
857	delete	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-27 06:33:42.662+00	172.19.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_comments	034e7209-1751-4797-bab4-519a3d4f2eac	http://localhost:5173
891	create	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-27 18:40:21.886+00	172.19.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_fields	102	http://localhost:5173
892	create	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-27 18:40:22.186+00	172.19.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_fields	103	http://localhost:5173
893	create	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-27 18:40:22.2+00	172.19.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_collections	junction_directus_users_files	http://localhost:5173
894	create	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-27 18:40:22.366+00	172.19.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_fields	104	http://localhost:5173
895	create	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-27 18:40:22.575+00	172.19.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_fields	105	http://localhost:5173
932	create	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-28 00:39:58.548+00	172.19.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_folders	9fd092ff-9e7b-48f0-b26c-bcead509ba9e	http://localhost:5173
954	update	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-28 10:57:40.366+00	172.19.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_files	3001a83c-3033-4dd1-b3ac-c910bdb1ef2c	http://localhost:5173
955	update	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-28 10:57:40.399+00	172.19.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_files	3001a83c-3033-4dd1-b3ac-c910bdb1ef2c	http://localhost:5173
979	update	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-28 12:06:04.002+00	172.19.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	sexy_videos	75296c46-3c71-4182-a4ce-416722377d76	http://localhost:5173
704	update	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-22 12:04:50.357+00	172.19.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_users	4d310101-f7b1-47fe-982a-efe4abf25c55	http://localhost:5173
705	update	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-22 12:06:56.779+00	172.19.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_fields	40	http://localhost:5173
744	login	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-24 16:56:27.999+00	172.19.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_users	4d310101-f7b1-47fe-982a-efe4abf25c55	http://localhost:5173
824	update	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-26 16:15:42.639+00	172.19.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	sexy_videos	75296c46-3c71-4182-a4ce-416722377d76	http://localhost:5173
858	create	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-27 06:39:42.195+00	172.19.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_comments	b88bda2d-0df8-4857-a274-49e9d690a4b0	http://localhost:5173
896	update	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-27 18:41:22.389+00	172.19.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_fields	102	http://localhost:5173
933	create	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-28 00:43:32.569+00	172.19.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_fields	106	http://localhost:5173
956	update	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-28 10:58:52.478+00	172.19.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_files	3001a83c-3033-4dd1-b3ac-c910bdb1ef2c	http://localhost:5173
957	update	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-28 10:58:52.545+00	172.19.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_files	3001a83c-3033-4dd1-b3ac-c910bdb1ef2c	http://localhost:5173
980	update	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-28 12:12:35.864+00	172.19.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	sexy_videos	75296c46-3c71-4182-a4ce-416722377d76	http://localhost:5173
706	update	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-22 16:06:35.29+00	172.19.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_users	4d310101-f7b1-47fe-982a-efe4abf25c55	http://localhost:5173
745	login	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-25 13:42:50.947+00	172.19.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_users	4d310101-f7b1-47fe-982a-efe4abf25c55	http://localhost:5173
746	login	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-25 13:44:44.509+00	172.19.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_users	4d310101-f7b1-47fe-982a-efe4abf25c55	http://localhost:5173
747	login	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-25 13:47:43.591+00	172.19.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_users	4d310101-f7b1-47fe-982a-efe4abf25c55	http://localhost:5173
748	login	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-25 14:00:21.052+00	172.19.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_users	4d310101-f7b1-47fe-982a-efe4abf25c55	http://localhost:5173
825	update	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-26 16:17:34.315+00	172.19.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	sexy_videos	75296c46-3c71-4182-a4ce-416722377d76	http://localhost:5173
859	create	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-27 06:45:25.426+00	172.19.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_comments	3ecb593a-ab0f-459f-9b19-cdeeb44d4d03	http://localhost:5173
897	create	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-27 19:07:51.88+00	172.19.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	junction_directus_users_files	1	http://localhost:5173
898	update	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-27 19:07:51.885+00	172.19.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_users	4d310101-f7b1-47fe-982a-efe4abf25c55	http://localhost:5173
934	create	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-28 01:21:02.085+00	172.19.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_files	cecf7ce8-388a-43a9-b9bc-2ab4d44d3f7f	http://localhost:5173
958	update	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-28 11:09:28.447+00	172.19.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_files	3001a83c-3033-4dd1-b3ac-c910bdb1ef2c	http://localhost:5173
959	update	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-28 11:09:28.512+00	172.19.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_files	3001a83c-3033-4dd1-b3ac-c910bdb1ef2c	http://localhost:5173
981	update	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-28 12:14:28.735+00	172.19.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	sexy_videos	75296c46-3c71-4182-a4ce-416722377d76	http://localhost:5173
982	update	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-28 12:15:55.868+00	172.19.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	sexy_videos	75296c46-3c71-4182-a4ce-416722377d76	http://localhost:5173
707	update	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-22 16:06:45.424+00	172.19.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_users	543f4d0b-e346-4e5e-8aca-4a9b35d5fab6	http://localhost:5173
749	login	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-25 14:18:48.016+00	172.19.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_users	4d310101-f7b1-47fe-982a-efe4abf25c55	http://localhost:5173
750	login	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-25 16:58:21.019+00	172.19.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_users	4d310101-f7b1-47fe-982a-efe4abf25c55	http://localhost:5173
826	update	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-26 16:19:24.983+00	172.19.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	sexy_videos	75296c46-3c71-4182-a4ce-416722377d76	http://localhost:5173
860	create	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-27 06:46:37.971+00	172.19.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_comments	f47d9c79-a6db-482b-8c87-094c198bef0b	http://localhost:5173
899	create	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-27 22:37:09.909+00	172.19.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_files	498e539a-7c86-44e3-9824-9a5bb0cc979e	http://localhost:5173
904	create	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-27 22:37:10.108+00	172.19.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_files	69dfefa0-643d-44cd-8f08-bc68177a38a8	http://localhost:5173
905	create	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-27 22:37:10.447+00	172.19.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_files	318207c2-3846-4383-b0e2-60925992f781	http://localhost:5173
935	update	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-28 01:22:32.723+00	172.19.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_users	543f4d0b-e346-4e5e-8aca-4a9b35d5fab6	http://localhost:5173
960	update	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-28 11:11:26.277+00	172.19.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_files	3001a83c-3033-4dd1-b3ac-c910bdb1ef2c	http://localhost:5173
961	update	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-28 11:11:26.344+00	172.19.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_files	3001a83c-3033-4dd1-b3ac-c910bdb1ef2c	http://localhost:5173
983	update	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-28 12:20:08.733+00	172.19.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	sexy_videos	75296c46-3c71-4182-a4ce-416722377d76	http://localhost:5173
708	delete	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-22 16:07:28.143+00	172.19.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_files	14dc2f96-fa93-4b64-b0a5-1b8e586fe0e4	http://localhost:5173
709	delete	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-22 16:07:28.144+00	172.19.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_files	99c47c3d-4865-4361-a545-f38e54fccb0b	http://localhost:5173
751	login	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-25 21:07:12.44+00	172.19.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_users	4d310101-f7b1-47fe-982a-efe4abf25c55	http://localhost:5173
754	login	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-25 23:53:27.49+00	172.19.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_users	4d310101-f7b1-47fe-982a-efe4abf25c55	http://localhost:5173
827	update	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-26 16:19:44.76+00	172.19.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	sexy_videos	75296c46-3c71-4182-a4ce-416722377d76	http://localhost:5173
828	login	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-26 20:32:50.207+00	172.19.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_users	4d310101-f7b1-47fe-982a-efe4abf25c55	http://localhost:5173
861	delete	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-27 07:05:07.865+00	172.19.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_comments	f47d9c79-a6db-482b-8c87-094c198bef0b	http://localhost:5173
862	delete	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-27 07:05:12.847+00	172.19.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_comments	3ecb593a-ab0f-459f-9b19-cdeeb44d4d03	http://localhost:5173
863	delete	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-27 07:05:17.946+00	172.19.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_comments	b88bda2d-0df8-4857-a274-49e9d690a4b0	http://localhost:5173
900	create	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-27 22:37:10.021+00	172.19.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_files	6435caee-2da5-444a-b378-8c341bba6720	http://localhost:5173
906	create	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-27 22:37:10.452+00	172.19.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_files	4be0073d-a30a-4bd3-937c-4da917f3833f	http://localhost:5173
936	update	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-28 01:23:45.026+00	172.19.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_permissions	71	http://localhost:5173
937	update	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-28 01:23:45.072+00	172.19.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_policies	f575bea7-7260-4d81-a931-81d762f2b47d	http://localhost:5173
962	update	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-28 11:14:28.889+00	172.19.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_files	3001a83c-3033-4dd1-b3ac-c910bdb1ef2c	http://localhost:5173
963	update	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-28 11:14:28.96+00	172.19.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_files	3001a83c-3033-4dd1-b3ac-c910bdb1ef2c	http://localhost:5173
964	create	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-28 11:15:17.169+00	172.19.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_files	65637bef-30e5-4605-8d79-59c8814baa40	http://localhost:5173
984	update	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-28 12:40:09.621+00	172.19.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_files	65637bef-30e5-4605-8d79-59c8814baa40	http://localhost:5173
985	update	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-28 12:40:09.656+00	172.19.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_files	65637bef-30e5-4605-8d79-59c8814baa40	http://localhost:5173
710	delete	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-22 16:07:33.397+00	172.19.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_folders	3c744e72-03ef-432d-9c16-ac0a343b2499	http://localhost:5173
752	login	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-25 21:15:39.48+00	172.19.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_users	4d310101-f7b1-47fe-982a-efe4abf25c55	http://localhost:5173
753	login	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-25 23:02:40.4+00	172.19.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_users	4d310101-f7b1-47fe-982a-efe4abf25c55	http://localhost:5173
829	login	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-26 20:45:23.931+00	172.19.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_users	4d310101-f7b1-47fe-982a-efe4abf25c55	http://localhost:5173
864	login	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-27 16:53:40.701+00	172.19.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_users	4d310101-f7b1-47fe-982a-efe4abf25c55	http://localhost:5173
901	create	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-27 22:37:10.026+00	172.19.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_files	9715bf21-05ce-4169-993b-a04edebe29af	http://localhost:5173
907	create	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-27 22:37:19.243+00	172.19.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	junction_directus_users_files	2	http://localhost:5173
908	create	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-27 22:37:19.248+00	172.19.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	junction_directus_users_files	3	http://localhost:5173
909	create	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-27 22:37:19.252+00	172.19.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	junction_directus_users_files	4	http://localhost:5173
910	create	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-27 22:37:19.268+00	172.19.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	junction_directus_users_files	5	http://localhost:5173
911	create	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-27 22:37:19.28+00	172.19.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	junction_directus_users_files	6	http://localhost:5173
912	create	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-27 22:37:19.283+00	172.19.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	junction_directus_users_files	7	http://localhost:5173
913	create	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-27 22:37:19.298+00	172.19.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	junction_directus_users_files	8	http://localhost:5173
914	create	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-27 22:37:19.307+00	172.19.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	junction_directus_users_files	9	http://localhost:5173
915	update	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-27 22:37:19.314+00	172.19.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_users	543f4d0b-e346-4e5e-8aca-4a9b35d5fab6	http://localhost:5173
938	login	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-28 01:33:30.528+00	172.19.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_users	4d310101-f7b1-47fe-982a-efe4abf25c55	http://localhost:5173
939	create	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-28 01:33:55.632+00	172.19.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_permissions	104	http://localhost:5173
940	update	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-28 01:33:55.752+00	172.19.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_policies	f575bea7-7260-4d81-a931-81d762f2b47d	http://localhost:5173
941	login	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-28 01:41:49.623+00	172.19.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_users	4d310101-f7b1-47fe-982a-efe4abf25c55	http://localhost:5173
965	update	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-28 11:18:58.247+00	172.19.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_files	65637bef-30e5-4605-8d79-59c8814baa40	http://localhost:5173
966	update	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-28 11:18:58.277+00	172.19.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_files	65637bef-30e5-4605-8d79-59c8814baa40	http://localhost:5173
986	update	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-28 13:44:04.22+00	172.19.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_files	65637bef-30e5-4605-8d79-59c8814baa40	http://localhost:5173
987	update	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-28 13:44:04.327+00	172.19.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_files	65637bef-30e5-4605-8d79-59c8814baa40	http://localhost:5173
990	update	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-28 13:46:45.748+00	172.19.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_files	65637bef-30e5-4605-8d79-59c8814baa40	http://localhost:5173
991	update	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-28 13:46:45.819+00	172.19.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_files	65637bef-30e5-4605-8d79-59c8814baa40	http://localhost:5173
992	update	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-28 13:49:54.256+00	172.19.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_files	65637bef-30e5-4605-8d79-59c8814baa40	http://localhost:5173
993	update	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-28 13:49:54.349+00	172.19.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_files	65637bef-30e5-4605-8d79-59c8814baa40	http://localhost:5173
711	create	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-22 16:07:52.13+00	172.19.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_folders	5f184291-9a58-4914-9756-ad910378bd90	http://localhost:5173
755	login	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-26 00:11:04.669+00	172.19.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_users	4d310101-f7b1-47fe-982a-efe4abf25c55	http://localhost:5173
758	login	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-26 03:53:41.001+00	172.19.0.1	Mozilla/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.5 Mobile/15E148 Safari/604.1	directus_users	4d310101-f7b1-47fe-982a-efe4abf25c55	http://localhost:5173
830	create	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-26 20:45:55.835+00	172.19.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_permissions	101	http://localhost:5173
831	update	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-26 20:45:55.873+00	172.19.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_policies	f575bea7-7260-4d81-a931-81d762f2b47d	http://localhost:5173
865	create	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-27 17:54:23.856+00	172.19.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_fields	94	http://localhost:5173
902	create	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-27 22:37:10.049+00	172.19.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_files	7779e362-8703-411d-882d-690fd1970566	http://localhost:5173
942	create	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-28 01:42:37.808+00	172.19.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_permissions	105	http://localhost:5173
943	update	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-28 01:42:37.917+00	172.19.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_policies	f575bea7-7260-4d81-a931-81d762f2b47d	http://localhost:5173
967	update	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-28 11:19:21.507+00	172.19.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_files	65637bef-30e5-4605-8d79-59c8814baa40	http://localhost:5173
968	update	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-28 11:19:21.608+00	172.19.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_files	65637bef-30e5-4605-8d79-59c8814baa40	http://localhost:5173
975	update	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-28 11:46:38.136+00	172.19.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_files	65637bef-30e5-4605-8d79-59c8814baa40	http://localhost:5173
976	update	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-28 11:46:38.181+00	172.19.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_files	65637bef-30e5-4605-8d79-59c8814baa40	http://localhost:5173
988	update	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-28 13:45:20.315+00	172.19.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_files	65637bef-30e5-4605-8d79-59c8814baa40	http://localhost:5173
989	update	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-28 13:45:20.372+00	172.19.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_files	65637bef-30e5-4605-8d79-59c8814baa40	http://localhost:5173
994	update	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-28 13:51:31.755+00	172.19.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_files	65637bef-30e5-4605-8d79-59c8814baa40	http://localhost:5173
995	update	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-28 13:51:31.815+00	172.19.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_files	65637bef-30e5-4605-8d79-59c8814baa40	http://localhost:5173
996	update	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-28 13:52:27.554+00	172.19.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_files	65637bef-30e5-4605-8d79-59c8814baa40	http://localhost:5173
997	update	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-28 13:52:27.588+00	172.19.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_files	65637bef-30e5-4605-8d79-59c8814baa40	http://localhost:5173
1000	update	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-28 13:53:35.693+00	172.19.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_files	65637bef-30e5-4605-8d79-59c8814baa40	http://localhost:5173
1002	update	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-28 13:54:25.749+00	172.19.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_files	3001a83c-3033-4dd1-b3ac-c910bdb1ef2c	http://localhost:5173
1003	update	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-28 13:54:25.812+00	172.19.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_files	3001a83c-3033-4dd1-b3ac-c910bdb1ef2c	http://localhost:5173
1004	update	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-28 13:54:25.939+00	172.19.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_files	3001a83c-3033-4dd1-b3ac-c910bdb1ef2c	http://localhost:5173
1005	login	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-10-08 02:06:45.036+00	78.51.149.168	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	directus_users	4d310101-f7b1-47fe-982a-efe4abf25c55	https://sexy.pivoine.art
1015	update	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-10-08 02:30:35.16+00	78.51.149.168	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	sexy_videos	299cf96a-8cfc-43d4-81a9-41c5f327808f	https://sexy.pivoine.art
1006	create	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-10-08 02:15:21.39+00	78.51.149.168	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	directus_files	7de97669-fcfb-414c-b64f-3ea1dbf0ce17	https://sexy.pivoine.art
1007	delete	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-10-08 02:15:21.4+00	78.51.149.168	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	directus_files	7de97669-fcfb-414c-b64f-3ea1dbf0ce17	https://sexy.pivoine.art
1008	create	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-10-08 02:17:22.376+00	78.51.149.168	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	directus_files	b5c8e028-43c0-4eea-9b69-a3478d3f219b	https://sexy.pivoine.art
1009	create	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-10-08 02:17:43.617+00	78.51.149.168	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	directus_files	009f5bad-9a8a-401e-9cb1-5792fa41337f	https://sexy.pivoine.art
1010	create	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-10-08 02:21:02.828+00	78.51.149.168	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	sexy_videos_directus_users	3	https://sexy.pivoine.art
1011	create	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-10-08 02:21:02.831+00	78.51.149.168	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	sexy_videos	299cf96a-8cfc-43d4-81a9-41c5f327808f	https://sexy.pivoine.art
1012	update	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-10-08 02:21:11.728+00	78.51.149.168	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	sexy_videos	75296c46-3c71-4182-a4ce-416722377d76	https://sexy.pivoine.art
1014	update	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-10-08 02:24:35.626+00	78.51.149.168	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	sexy_videos	299cf96a-8cfc-43d4-81a9-41c5f327808f	https://sexy.pivoine.art
1013	login	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-10-08 02:23:22.089+00	78.51.149.168	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	directus_users	4d310101-f7b1-47fe-982a-efe4abf25c55	https://sexy.pivoine.art
\.


--
-- Data for Name: directus_collections; Type: TABLE DATA; Schema: public; Owner: valknar
--

COPY public.directus_collections (collection, icon, note, display_template, hidden, singleton, translations, archive_field, archive_app_filter, archive_value, unarchive_value, sort_field, accountability, color, item_duplication_fields, sort, "group", collapse, preview_url, versioning) FROM stdin;
sexy_articles	newsmode	\N	\N	f	f	[{"language":"en-US","translation":"Sexy Articles","singular":"Article","plural":"Articles"}]	status	t	archived	draft	\N	all	\N	\N	\N	\N	open	\N	t
sexy_videos	videocam	\N	\N	f	f	\N	status	t	archived	draft	\N	all	\N	\N	\N	\N	open	\N	f
sexy_videos_directus_users	import_export	\N	\N	t	f	\N	\N	t	\N	\N	\N	all	\N	\N	\N	\N	open	\N	f
junction_directus_users_files	import_export	\N	\N	t	f	\N	\N	t	\N	\N	\N	all	\N	\N	\N	\N	open	\N	f
\.


--
-- Data for Name: directus_comments; Type: TABLE DATA; Schema: public; Owner: valknar
--

COPY public.directus_comments (id, collection, item, comment, date_created, date_updated, user_created, user_updated) FROM stdin;
\.


--
-- Data for Name: directus_dashboards; Type: TABLE DATA; Schema: public; Owner: valknar
--

COPY public.directus_dashboards (id, name, icon, note, date_created, user_created, color) FROM stdin;
\.


--
-- Data for Name: directus_extensions; Type: TABLE DATA; Schema: public; Owner: valknar
--

COPY public.directus_extensions (enabled, id, folder, source, bundle) FROM stdin;
t	9b117170-0651-4be5-9ab5-5a04e31d04b1	sexy.pivoine.art	local	\N
t	0ebf9103-670c-4db8-b669-b35e8fc76595	theme	local	9b117170-0651-4be5-9ab5-5a04e31d04b1
t	dd068b41-21d6-483f-a77e-806ab0206dd6	hook	local	9b117170-0651-4be5-9ab5-5a04e31d04b1
t	c68a7782-aef8-4fc2-a899-c1e49d74fd27	endpoint	local	9b117170-0651-4be5-9ab5-5a04e31d04b1
\.


--
-- Data for Name: directus_fields; Type: TABLE DATA; Schema: public; Owner: valknar
--

COPY public.directus_fields (id, collection, field, special, interface, options, display, display_options, readonly, hidden, sort, width, translations, note, conditions, required, "group", validation, validation_message) FROM stdin;
29	sexy_articles	slug	\N	input	{"slug":true}	\N	\N	f	f	6	full	\N	\N	\N	t	\N	\N	\N
30	sexy_articles	title	\N	input	\N	\N	\N	f	f	7	full	\N	\N	\N	t	\N	\N	\N
31	sexy_articles	excerpt	\N	input-multiline	{"trim":true}	\N	\N	f	f	9	full	\N	\N	\N	t	\N	\N	\N
32	sexy_articles	content	\N	input-rich-text-html	{"toolbar":["bold","italic","underline","h2","h3","numlist","bullist","removeformat","blockquote","customLink","hr","fullscreen","code"],"folder":"c214c905-885b-4d66-a6a1-6527b0606200"}	\N	\N	f	f	10	full	\N	\N	\N	t	\N	\N	\N
33	sexy_articles	image	file	file-image	{"folder":"452680cc-8e19-4352-a943-21520d3f3621"}	\N	\N	f	f	11	full	\N	\N	\N	t	\N	\N	\N
34	sexy_articles	tags	cast-json	tags	{"capitalization":"auto-format","whitespace":"_"}	\N	\N	f	f	12	full	\N	\N	\N	f	\N	\N	\N
23	sexy_articles	id	uuid	input	\N	\N	\N	t	t	1	full	\N	\N	\N	f	\N	\N	\N
24	sexy_articles	status	\N	select-dropdown	{"choices":[{"text":"$t:published","value":"published","color":"var(--theme--primary)"},{"text":"$t:draft","value":"draft","color":"var(--theme--foreground)"},{"text":"$t:archived","value":"archived","color":"var(--theme--warning)"}]}	labels	{"showAsDot":true,"choices":[{"text":"$t:published","value":"published","color":"var(--theme--primary)","foreground":"var(--theme--primary)","background":"var(--theme--primary-background)"},{"text":"$t:draft","value":"draft","color":"var(--theme--foreground)","foreground":"var(--theme--foreground)","background":"var(--theme--background-normal)"},{"text":"$t:archived","value":"archived","color":"var(--theme--warning)","foreground":"var(--theme--warning)","background":"var(--theme--warning-background)"}]}	f	f	2	full	\N	\N	\N	f	\N	\N	\N
25	sexy_articles	user_created	user-created	select-dropdown-m2o	{"template":"{{avatar}} {{first_name}} {{last_name}}"}	user	\N	t	t	3	half	\N	\N	\N	f	\N	\N	\N
26	sexy_articles	date_created	date-created	datetime	\N	datetime	{"relative":true}	t	t	4	half	\N	\N	\N	f	\N	\N	\N
27	sexy_articles	date_updated	date-updated	datetime	\N	datetime	{"relative":true}	t	t	5	half	\N	\N	\N	f	\N	\N	\N
35	sexy_articles	publish_date	\N	datetime	\N	\N	\N	f	f	13	full	\N	\N	\N	t	\N	\N	\N
36	sexy_articles	category	\N	input	\N	\N	\N	f	f	14	full	\N	\N	\N	t	\N	\N	\N
37	sexy_articles	featured	cast-boolean	boolean	{"label":"Featured"}	\N	\N	f	f	15	full	\N	\N	\N	f	\N	\N	\N
39	sexy_articles	author	m2o	select-dropdown-m2o	{"enableLink":true,"filter":{"_and":[{"policies":{"policy":{"name":{"_eq":"Editor"}}}}]}}	\N	\N	f	f	8	full	\N	\N	\N	t	\N	\N	\N
77	directus_users	artist_name	\N	input	\N	\N	\N	f	f	1	full	\N	\N	\N	t	\N	\N	\N
74	directus_users	slug	\N	input	\N	\N	\N	f	f	3	full	\N	\N	[{"name":"Enable for role \\"Administrator\\"","rule":{"_and":[{"role":{"_eq":"ea3a9127-2b65-462c-85a8-dbafe9b4fe24"}}]},"readonly":false}]	t	\N	\N	\N
75	directus_users	join_date	\N	datetime	{"format":"short"}	\N	\N	f	f	4	full	\N	\N	\N	t	\N	\N	\N
76	directus_users	featured	cast-boolean	boolean	{"label":"Featured"}	\N	\N	f	f	5	full	\N	\N	\N	f	\N	\N	\N
72	sexy_videos	featured	cast-boolean	boolean	{"label":"Featured"}	\N	\N	f	f	14	full	\N	\N	\N	f	\N	\N	\N
78	sexy_videos	tags	cast-json	tags	\N	\N	\N	f	f	15	full	\N	\N	\N	f	\N	\N	\N
40	directus_users	website	\N	input	\N	\N	\N	f	f	2	full	\N	\N	\N	f	\N	\N	\N
80	sexy_videos_directus_users	id	\N	\N	\N	\N	\N	f	t	1	full	\N	\N	\N	f	\N	\N	\N
81	sexy_videos_directus_users	sexy_videos_id	\N	\N	\N	\N	\N	f	t	2	full	\N	\N	\N	f	\N	\N	\N
82	sexy_videos_directus_users	directus_users_id	\N	\N	\N	\N	\N	f	t	3	full	\N	\N	\N	f	\N	\N	\N
65	sexy_videos	date_updated	date-updated	datetime	\N	datetime	{"relative":true}	t	t	5	half	\N	\N	\N	f	\N	\N	\N
63	sexy_videos	user_created	user-created	select-dropdown-m2o	{"template":"{{avatar}} {{first_name}} {{last_name}}"}	user	\N	t	t	3	half	\N	\N	\N	f	\N	\N	\N
61	sexy_videos	id	uuid	input	\N	\N	\N	t	t	1	full	\N	\N	\N	f	\N	\N	\N
62	sexy_videos	status	\N	select-dropdown	{"choices":[{"text":"$t:published","value":"published","color":"var(--theme--primary)"},{"text":"$t:draft","value":"draft","color":"var(--theme--foreground)"},{"text":"$t:archived","value":"archived","color":"var(--theme--warning)"}]}	labels	{"showAsDot":true,"choices":[{"text":"$t:published","value":"published","color":"var(--theme--primary)","foreground":"var(--theme--primary)","background":"var(--theme--primary-background)"},{"text":"$t:draft","value":"draft","color":"var(--theme--foreground)","foreground":"var(--theme--foreground)","background":"var(--theme--background-normal)"},{"text":"$t:archived","value":"archived","color":"var(--theme--warning)","foreground":"var(--theme--warning)","background":"var(--theme--warning-background)"}]}	f	f	2	full	\N	\N	\N	f	\N	\N	\N
64	sexy_videos	date_created	date-created	datetime	\N	datetime	{"relative":true}	t	t	4	half	\N	\N	\N	f	\N	\N	\N
66	sexy_videos	slug	\N	input	{"slug":true,"trim":true}	\N	\N	f	f	6	full	\N	\N	\N	t	\N	\N	\N
67	sexy_videos	title	\N	input	\N	\N	\N	f	f	7	full	\N	\N	\N	t	\N	\N	\N
84	sexy_videos	description	\N	input-multiline	{"trim":true}	\N	\N	f	f	8	full	\N	\N	\N	t	\N	\N	\N
68	sexy_videos	image	file	file-image	{"folder":"26657630-d9cd-47a3-9e45-9831f3674f97"}	\N	\N	f	f	9	full	\N	\N	\N	t	\N	\N	\N
83	sexy_videos	movie	file	file	{"folder":"3f83c727-9c90-4e0d-871f-ab81c295043a","filter":{"_and":[{"type":{"_eq":"video/mp4"}}]}}	\N	\N	f	f	10	full	\N	\N	\N	t	\N	\N	\N
79	sexy_videos	models	m2m	list-m2m	\N	\N	\N	f	f	11	full	\N	\N	\N	t	\N	\N	\N
70	sexy_videos	upload_date	\N	datetime	\N	\N	\N	f	f	12	full	\N	\N	\N	t	\N	\N	\N
71	sexy_videos	premium	cast-boolean	boolean	{"label":"Premium"}	\N	\N	f	f	13	full	\N	\N	\N	f	\N	\N	\N
103	junction_directus_users_files	id	\N	\N	\N	\N	\N	f	t	1	full	\N	\N	\N	f	\N	\N	\N
104	junction_directus_users_files	directus_users_id	\N	\N	\N	\N	\N	f	t	2	full	\N	\N	\N	f	\N	\N	\N
105	junction_directus_users_files	directus_files_id	\N	\N	\N	\N	\N	f	t	3	full	\N	\N	\N	f	\N	\N	\N
102	directus_users	photos	files	files	{"filter":{"_and":[{"type":{"_starts_with":"image"}}]},"folder":"4cb93083-f3f7-4a61-a80f-d56fd9e6ee62"}	\N	\N	f	f	6	full	\N	\N	\N	f	\N	\N	\N
106	directus_users	banner	file	file-image	{"folder":"9fd092ff-9e7b-48f0-b26c-bcead509ba9e"}	\N	\N	f	f	7	full	\N	\N	\N	f	\N	\N	\N
\.


--
-- Data for Name: directus_files; Type: TABLE DATA; Schema: public; Owner: valknar
--

COPY public.directus_files (id, storage, filename_disk, filename_download, title, type, folder, uploaded_by, created_on, modified_by, modified_on, charset, filesize, width, height, duration, embed, description, location, tags, metadata, focal_point_x, focal_point_y, tus_id, tus_data, uploaded_on) FROM stdin;
8ad7e858-0c83-4d88-bb50-3680f1cfa9c2	local	8ad7e858-0c83-4d88-bb50-3680f1cfa9c2.png	duality-mask.png	Duality Mask	image/png	3eaf8f03-dbfe-4c73-b513-5cc588de6457	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-06 09:37:21.496+00	\N	2025-09-06 09:37:21.567+00	\N	24411	512	512	\N	\N	\N	\N	\N	{}	\N	\N	\N	\N	2025-09-06 09:37:21.564+00
f718185e-fd82-4f16-971d-88baf2d069de	local	f718185e-fd82-4f16-971d-88baf2d069de.webp	babe.webp	Babe	image/webp	452680cc-8e19-4352-a943-21520d3f3621	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-08 19:49:44.202+00	\N	2025-09-08 19:49:44.253+00	\N	287108	4032	3024	\N	\N	\N	\N	\N	{}	\N	\N	\N	\N	2025-09-08 19:49:44.249+00
0a509923-853d-44e7-ad76-b6e6bdf89ba5	local	0a509923-853d-44e7-ad76-b6e6bdf89ba5.ico	favicon.ico	Favicon	image/vnd.microsoft.icon	3eaf8f03-dbfe-4c73-b513-5cc588de6457	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-13 14:39:34.98+00	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-13 14:40:04.809+00	\N	15406	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	2025-09-13 14:39:35.018+00
69dfefa0-643d-44cd-8f08-bc68177a38a8	local	69dfefa0-643d-44cd-8f08-bc68177a38a8.png	luna-belle-4.png	Luna Belle 4	image/png	4cb93083-f3f7-4a61-a80f-d56fd9e6ee62	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-27 22:37:10.084+00	\N	2025-09-27 22:37:10.379+00	\N	1861259	1024	1024	\N	\N	\N	\N	\N	{}	\N	\N	\N	\N	2025-09-27 22:37:10.377+00
4be0073d-a30a-4bd3-937c-4da917f3833f	local	4be0073d-a30a-4bd3-937c-4da917f3833f.png	luna-belle-2.png	Luna Belle 2	image/png	4cb93083-f3f7-4a61-a80f-d56fd9e6ee62	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-27 22:37:10.443+00	\N	2025-09-27 22:37:10.516+00	\N	1814169	1024	1024	\N	\N	\N	\N	\N	{}	\N	\N	\N	\N	2025-09-27 22:37:10.515+00
318207c2-3846-4383-b0e2-60925992f781	local	318207c2-3846-4383-b0e2-60925992f781.png	luna-belle-3.png	Luna Belle 3	image/png	4cb93083-f3f7-4a61-a80f-d56fd9e6ee62	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-27 22:37:10.435+00	\N	2025-09-27 22:37:10.543+00	\N	1744358	1024	1024	\N	\N	\N	\N	\N	{}	\N	\N	\N	\N	2025-09-27 22:37:10.542+00
bab78ff3-10bf-4fc6-9e3a-6e58bb6655b1	local	bab78ff3-10bf-4fc6-9e3a-6e58bb6655b1.png	sexybelle.png	Sexybelle	image/png	7360b85c-3bb7-4334-ba81-2f46575ea056	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-26 13:55:27.9+00	\N	2025-09-26 13:55:27.952+00	\N	1614172	1920	1080	\N	\N	\N	\N	\N	{}	\N	\N	\N	\N	2025-09-26 13:55:27.951+00
498e539a-7c86-44e3-9824-9a5bb0cc979e	local	498e539a-7c86-44e3-9824-9a5bb0cc979e.png	luna-belle-1.png	Luna Belle 1	image/png	4cb93083-f3f7-4a61-a80f-d56fd9e6ee62	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-27 22:37:09.88+00	\N	2025-09-27 22:37:10.25+00	\N	1631478	1024	1024	\N	\N	\N	\N	\N	{}	\N	\N	\N	\N	2025-09-27 22:37:10.247+00
9715bf21-05ce-4169-993b-a04edebe29af	local	9715bf21-05ce-4169-993b-a04edebe29af.png	luna-belle-7.png	Luna Belle 7	image/png	4cb93083-f3f7-4a61-a80f-d56fd9e6ee62	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-27 22:37:10.009+00	\N	2025-09-27 22:37:10.283+00	\N	1659265	1024	1024	\N	\N	\N	\N	\N	{}	\N	\N	\N	\N	2025-09-27 22:37:10.262+00
6435caee-2da5-444a-b378-8c341bba6720	local	6435caee-2da5-444a-b378-8c341bba6720.png	luna-belle-8.png	Luna Belle 8	image/png	4cb93083-f3f7-4a61-a80f-d56fd9e6ee62	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-27 22:37:10.001+00	\N	2025-09-27 22:37:10.298+00	\N	1765247	1024	1024	\N	\N	\N	\N	\N	{}	\N	\N	\N	\N	2025-09-27 22:37:10.271+00
83c90c5c-5877-482c-8043-daa4d28e58de	local	83c90c5c-5877-482c-8043-daa4d28e58de.png	luna-belle-5.png	Luna Belle 5	image/png	4cb93083-f3f7-4a61-a80f-d56fd9e6ee62	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-27 22:37:10.078+00	\N	2025-09-27 22:37:10.305+00	\N	1558281	1024	1024	\N	\N	\N	\N	\N	{}	\N	\N	\N	\N	2025-09-27 22:37:10.274+00
7779e362-8703-411d-882d-690fd1970566	local	7779e362-8703-411d-882d-690fd1970566.png	luna-belle-6.png	Luna Belle 6	image/png	4cb93083-f3f7-4a61-a80f-d56fd9e6ee62	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-27 22:37:10.039+00	\N	2025-09-27 22:37:10.311+00	\N	1693598	1024	1024	\N	\N	\N	\N	\N	{}	\N	\N	\N	\N	2025-09-27 22:37:10.289+00
b85b3008-f592-4676-8c84-666e0a60423d	local	b85b3008-f592-4676-8c84-666e0a60423d.png	luna-belle.png	Luna Belle	image/png	5f184291-9a58-4914-9756-ad910378bd90	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-27 23:28:51.741+00	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-27 23:31:04.513+00	\N	880827	720	720	\N	\N	\N	\N	\N	{}	\N	\N	\N	\N	2025-09-27 23:28:51.787+00
e77c58c1-f718-4b7a-b34c-c42861c8122f	local	e77c58c1-f718-4b7a-b34c-c42861c8122f.png	valknar.png	Valknar	image/png	5f184291-9a58-4914-9756-ad910378bd90	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-27 23:31:44.543+00	\N	2025-09-27 23:31:44.601+00	\N	732852	720	720	\N	\N	\N	\N	\N	{}	\N	\N	\N	\N	2025-09-27 23:31:44.598+00
cecf7ce8-388a-43a9-b9bc-2ab4d44d3f7f	local	cecf7ce8-388a-43a9-b9bc-2ab4d44d3f7f.png	luna-belle.png	Luna Belle	image/png	9fd092ff-9e7b-48f0-b26c-bcead509ba9e	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-28 01:21:02.058+00	\N	2025-09-28 01:21:02.65+00	\N	7318566	2048	2048	\N	\N	\N	\N	\N	{}	\N	\N	\N	\N	2025-09-28 01:21:02.634+00
d3f53a9b-bbce-436c-a6f4-04e5ef120d7e	local	d3f53a9b-bbce-436c-a6f4-04e5ef120d7e.png	valknar.png	Valknar	image/png	9fd092ff-9e7b-48f0-b26c-bcead509ba9e	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-28 02:02:05.025+00	\N	2025-09-28 02:02:05.248+00	\N	4755642	2048	2048	\N	\N	\N	\N	\N	{}	\N	\N	\N	\N	2025-09-28 02:02:05.242+00
3001a83c-3033-4dd1-b3ac-c910bdb1ef2c	local	3001a83c-3033-4dd1-b3ac-c910bdb1ef2c.mp4	sexybelle.mp4	Sexybelle	video/mp4	3f83c727-9c90-4e0d-871f-ab81c295043a	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-26 13:56:46.013+00	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-28 13:54:25.924+00	\N	40114279	\N	\N	18	\N	\N	\N	\N	\N	\N	\N	\N	\N	2025-09-28 13:54:25.774+00
b5c8e028-43c0-4eea-9b69-a3478d3f219b	local	b5c8e028-43c0-4eea-9b69-a3478d3f219b.png	videoframe_0.png	Videoframe 0	image/png	26657630-d9cd-47a3-9e45-9831f3674f97	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-10-08 02:17:22.374+00	\N	2025-10-08 02:17:22.935+00	\N	1467255	1888	1080	\N	\N	\N	\N	\N	{}	\N	\N	\N	\N	2025-10-08 02:17:22.933+00
009f5bad-9a8a-401e-9cb1-5792fa41337f	local	009f5bad-9a8a-401e-9cb1-5792fa41337f.mp4	SexyArt - In The Opera.mp4	Sexy Art   in the Opera	video/mp4	3f83c727-9c90-4e0d-871f-ab81c295043a	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-10-08 02:17:43.615+00	\N	2025-10-08 02:17:46.788+00	\N	8565141	\N	\N	70	\N	\N	\N	\N	\N	\N	\N	\N	\N	2025-10-08 02:17:46.787+00
\.


--
-- Data for Name: directus_flows; Type: TABLE DATA; Schema: public; Owner: valknar
--

COPY public.directus_flows (id, name, icon, color, description, status, trigger, accountability, options, operation, date_created, user_created) FROM stdin;
\.


--
-- Data for Name: directus_folders; Type: TABLE DATA; Schema: public; Owner: valknar
--

COPY public.directus_folders (id, name, parent) FROM stdin;
3eaf8f03-dbfe-4c73-b513-5cc588de6457	branding	\N
c214c905-885b-4d66-a6a1-6527b0606200	sexy	\N
452680cc-8e19-4352-a943-21520d3f3621	articles	c214c905-885b-4d66-a6a1-6527b0606200
7360b85c-3bb7-4334-ba81-2f46575ea056	videos	c214c905-885b-4d66-a6a1-6527b0606200
26657630-d9cd-47a3-9e45-9831f3674f97	images	7360b85c-3bb7-4334-ba81-2f46575ea056
3f83c727-9c90-4e0d-871f-ab81c295043a	movies	7360b85c-3bb7-4334-ba81-2f46575ea056
a21e028c-52de-4bc2-8b74-2633194267ab	users	c214c905-885b-4d66-a6a1-6527b0606200
5f184291-9a58-4914-9756-ad910378bd90	avatars	a21e028c-52de-4bc2-8b74-2633194267ab
4cb93083-f3f7-4a61-a80f-d56fd9e6ee62	photos	a21e028c-52de-4bc2-8b74-2633194267ab
9fd092ff-9e7b-48f0-b26c-bcead509ba9e	banners	a21e028c-52de-4bc2-8b74-2633194267ab
\.


--
-- Data for Name: directus_migrations; Type: TABLE DATA; Schema: public; Owner: valknar
--

COPY public.directus_migrations (version, name, "timestamp") FROM stdin;
20201028A	Remove Collection Foreign Keys	2025-09-05 20:10:57.109317+00
20201029A	Remove System Relations	2025-09-05 20:10:57.119133+00
20201029B	Remove System Collections	2025-09-05 20:10:57.129317+00
20201029C	Remove System Fields	2025-09-05 20:10:57.143127+00
20201105A	Add Cascade System Relations	2025-09-05 20:10:57.212625+00
20201105B	Change Webhook URL Type	2025-09-05 20:10:57.22542+00
20210225A	Add Relations Sort Field	2025-09-05 20:10:57.235836+00
20210304A	Remove Locked Fields	2025-09-05 20:10:57.240527+00
20210312A	Webhooks Collections Text	2025-09-05 20:10:57.248818+00
20210331A	Add Refresh Interval	2025-09-05 20:10:57.252855+00
20210415A	Make Filesize Nullable	2025-09-05 20:10:57.262127+00
20210416A	Add Collections Accountability	2025-09-05 20:10:57.267697+00
20210422A	Remove Files Interface	2025-09-05 20:10:57.271418+00
20210506A	Rename Interfaces	2025-09-05 20:10:57.291139+00
20210510A	Restructure Relations	2025-09-05 20:10:57.307282+00
20210518A	Add Foreign Key Constraints	2025-09-05 20:10:57.315255+00
20210519A	Add System Fk Triggers	2025-09-05 20:10:57.346411+00
20210521A	Add Collections Icon Color	2025-09-05 20:10:57.351863+00
20210525A	Add Insights	2025-09-05 20:10:57.379702+00
20210608A	Add Deep Clone Config	2025-09-05 20:10:57.385276+00
20210626A	Change Filesize Bigint	2025-09-05 20:10:57.405193+00
20210716A	Add Conditions to Fields	2025-09-05 20:10:57.411526+00
20210721A	Add Default Folder	2025-09-05 20:10:57.421946+00
20210802A	Replace Groups	2025-09-05 20:10:57.429268+00
20210803A	Add Required to Fields	2025-09-05 20:10:57.433659+00
20210805A	Update Groups	2025-09-05 20:10:57.440605+00
20210805B	Change Image Metadata Structure	2025-09-05 20:10:57.448753+00
20210811A	Add Geometry Config	2025-09-05 20:10:57.453842+00
20210831A	Remove Limit Column	2025-09-05 20:10:57.45929+00
20210903A	Add Auth Provider	2025-09-05 20:10:57.481518+00
20210907A	Webhooks Collections Not Null	2025-09-05 20:10:57.493587+00
20210910A	Move Module Setup	2025-09-05 20:10:57.501377+00
20210920A	Webhooks URL Not Null	2025-09-05 20:10:57.514125+00
20210924A	Add Collection Organization	2025-09-05 20:10:57.524651+00
20210927A	Replace Fields Group	2025-09-05 20:10:57.539248+00
20210927B	Replace M2M Interface	2025-09-05 20:10:57.544552+00
20210929A	Rename Login Action	2025-09-05 20:10:57.549483+00
20211007A	Update Presets	2025-09-05 20:10:57.5588+00
20211009A	Add Auth Data	2025-09-05 20:10:57.563128+00
20211016A	Add Webhook Headers	2025-09-05 20:10:57.567319+00
20211103A	Set Unique to User Token	2025-09-05 20:10:57.573218+00
20211103B	Update Special Geometry	2025-09-05 20:10:57.577076+00
20211104A	Remove Collections Listing	2025-09-05 20:10:57.581204+00
20211118A	Add Notifications	2025-09-05 20:10:57.598806+00
20211211A	Add Shares	2025-09-05 20:10:57.62456+00
20211230A	Add Project Descriptor	2025-09-05 20:10:57.631221+00
20220303A	Remove Default Project Color	2025-09-05 20:10:57.644527+00
20220308A	Add Bookmark Icon and Color	2025-09-05 20:10:57.651639+00
20220314A	Add Translation Strings	2025-09-05 20:10:57.657516+00
20220322A	Rename Field Typecast Flags	2025-09-05 20:10:57.665825+00
20220323A	Add Field Validation	2025-09-05 20:10:57.670818+00
20220325A	Fix Typecast Flags	2025-09-05 20:10:57.676834+00
20220325B	Add Default Language	2025-09-05 20:10:57.689122+00
20220402A	Remove Default Value Panel Icon	2025-09-05 20:10:57.700489+00
20220429A	Add Flows	2025-09-05 20:10:57.743462+00
20220429B	Add Color to Insights Icon	2025-09-05 20:10:57.74908+00
20220429C	Drop Non Null From IP of Activity	2025-09-05 20:10:57.754987+00
20220429D	Drop Non Null From Sender of Notifications	2025-09-05 20:10:57.760674+00
20220614A	Rename Hook Trigger to Event	2025-09-05 20:10:57.765448+00
20220801A	Update Notifications Timestamp Column	2025-09-05 20:10:57.77586+00
20220802A	Add Custom Aspect Ratios	2025-09-05 20:10:57.780582+00
20220826A	Add Origin to Accountability	2025-09-05 20:10:57.786725+00
20230401A	Update Material Icons	2025-09-05 20:10:57.798028+00
20230525A	Add Preview Settings	2025-09-05 20:10:57.802678+00
20230526A	Migrate Translation Strings	2025-09-05 20:10:57.815062+00
20230721A	Require Shares Fields	2025-09-05 20:10:57.822819+00
20230823A	Add Content Versioning	2025-09-05 20:10:57.845115+00
20230927A	Themes	2025-09-05 20:10:57.867972+00
20231009A	Update CSV Fields to Text	2025-09-05 20:10:57.876577+00
20231009B	Update Panel Options	2025-09-05 20:10:57.881505+00
20231010A	Add Extensions	2025-09-05 20:10:57.889494+00
20231215A	Add Focalpoints	2025-09-05 20:10:57.895158+00
20240122A	Add Report URL Fields	2025-09-05 20:10:57.900769+00
20240204A	Marketplace	2025-09-05 20:10:57.936733+00
20240305A	Change Useragent Type	2025-09-05 20:10:57.953535+00
20240311A	Deprecate Webhooks	2025-09-05 20:10:57.964952+00
20240422A	Public Registration	2025-09-05 20:10:57.972291+00
20240515A	Add Session Window	2025-09-05 20:10:57.976951+00
20240701A	Add Tus Data	2025-09-05 20:10:57.981335+00
20240716A	Update Files Date Fields	2025-09-05 20:10:57.989821+00
20240806A	Permissions Policies	2025-09-05 20:10:58.042633+00
20240817A	Update Icon Fields Length	2025-09-05 20:10:58.089674+00
20240909A	Separate Comments	2025-09-05 20:10:58.10771+00
20240909B	Consolidate Content Versioning	2025-09-05 20:10:58.113252+00
20240924A	Migrate Legacy Comments	2025-09-05 20:10:58.12305+00
20240924B	Populate Versioning Deltas	2025-09-05 20:10:58.129224+00
20250224A	Visual Editor	2025-09-05 20:10:58.134338+00
20250609A	License Banner	2025-09-05 20:10:58.140361+00
20250613A	Add Project ID	2025-09-05 20:10:58.15793+00
20250718A	Add Direction	2025-09-05 20:10:58.162157+00
20250813A	Add MCP	2025-09-17 11:49:37.399032+00
\.


--
-- Data for Name: directus_notifications; Type: TABLE DATA; Schema: public; Owner: valknar
--

COPY public.directus_notifications (id, "timestamp", status, recipient, sender, subject, message, collection, item) FROM stdin;
\.


--
-- Data for Name: directus_operations; Type: TABLE DATA; Schema: public; Owner: valknar
--

COPY public.directus_operations (id, name, key, type, position_x, position_y, options, resolve, reject, flow, date_created, user_created) FROM stdin;
\.


--
-- Data for Name: directus_panels; Type: TABLE DATA; Schema: public; Owner: valknar
--

COPY public.directus_panels (id, dashboard, name, icon, color, show_header, note, type, position_x, position_y, width, height, options, date_created, user_created) FROM stdin;
\.


--
-- Data for Name: directus_permissions; Type: TABLE DATA; Schema: public; Owner: valknar
--

COPY public.directus_permissions (id, collection, action, permissions, validation, presets, fields, policy) FROM stdin;
1	directus_collections	read	{}	\N	\N	*	338928fb-f8ee-4450-8b24-4854dd8bc7e0
2	directus_fields	read	{}	\N	\N	*	338928fb-f8ee-4450-8b24-4854dd8bc7e0
3	directus_relations	read	{}	\N	\N	*	338928fb-f8ee-4450-8b24-4854dd8bc7e0
4	directus_translations	read	{}	\N	\N	*	338928fb-f8ee-4450-8b24-4854dd8bc7e0
5	directus_activity	read	{"user":{"_eq":"$CURRENT_USER"}}	\N	\N	*	338928fb-f8ee-4450-8b24-4854dd8bc7e0
6	directus_comments	read	{"user_created":{"_eq":"$CURRENT_USER"}}	\N	\N	*	338928fb-f8ee-4450-8b24-4854dd8bc7e0
7	directus_comments	create	{}	{"comment":{"_nnull":true}}	\N	*	338928fb-f8ee-4450-8b24-4854dd8bc7e0
8	directus_comments	update	{"user_created":{"_eq":"$CURRENT_USER"}}	\N	\N	comment	338928fb-f8ee-4450-8b24-4854dd8bc7e0
9	directus_comments	delete	{"user_created":{"_eq":"$CURRENT_USER"}}	\N	\N	*	338928fb-f8ee-4450-8b24-4854dd8bc7e0
10	directus_presets	read	{"_or":[{"user":{"_eq":"$CURRENT_USER"}},{"_and":[{"user":{"_null":true}},{"role":{"_eq":"$CURRENT_ROLE"}}]},{"_and":[{"user":{"_null":true}},{"role":{"_null":true}}]}]}	\N	\N	*	338928fb-f8ee-4450-8b24-4854dd8bc7e0
11	directus_presets	create	{}	{"user":{"_eq":"$CURRENT_USER"}}	\N	*	338928fb-f8ee-4450-8b24-4854dd8bc7e0
12	directus_presets	update	{"user":{"_eq":"$CURRENT_USER"}}	{"user":{"_eq":"$CURRENT_USER"}}	\N	*	338928fb-f8ee-4450-8b24-4854dd8bc7e0
13	directus_presets	delete	{"user":{"_eq":"$CURRENT_USER"}}	\N	\N	*	338928fb-f8ee-4450-8b24-4854dd8bc7e0
14	directus_roles	read	{"id":{"_in":"$CURRENT_ROLES"}}	\N	\N	*	338928fb-f8ee-4450-8b24-4854dd8bc7e0
15	directus_settings	read	{}	\N	\N	*	338928fb-f8ee-4450-8b24-4854dd8bc7e0
16	directus_translations	read	{}	\N	\N	*	338928fb-f8ee-4450-8b24-4854dd8bc7e0
17	directus_notifications	read	{"recipient":{"_eq":"$CURRENT_USER"}}	\N	\N	*	338928fb-f8ee-4450-8b24-4854dd8bc7e0
18	directus_notifications	update	{"recipient":{"_eq":"$CURRENT_USER"}}	\N	\N	status	338928fb-f8ee-4450-8b24-4854dd8bc7e0
19	directus_shares	read	{"user_created":{"_eq":"$CURRENT_USER"}}	\N	\N	*	338928fb-f8ee-4450-8b24-4854dd8bc7e0
20	directus_users	read	{"id":{"_eq":"$CURRENT_USER"}}	\N	\N	id,first_name,last_name,last_page,email,password,location,title,description,tags,preferences_divider,avatar,language,appearance,theme_light,theme_dark,tfa_secret,status,role	338928fb-f8ee-4450-8b24-4854dd8bc7e0
29	sexy_articles	create	\N	\N	\N	*	656e614d-a1aa-4b89-936a-e2c730fc85e1
30	sexy_articles	read	\N	\N	\N	*	656e614d-a1aa-4b89-936a-e2c730fc85e1
31	sexy_articles	update	\N	\N	\N	*	656e614d-a1aa-4b89-936a-e2c730fc85e1
32	sexy_articles	delete	\N	\N	\N	*	656e614d-a1aa-4b89-936a-e2c730fc85e1
33	sexy_articles	share	\N	\N	\N	*	656e614d-a1aa-4b89-936a-e2c730fc85e1
68	sexy_articles	read	\N	\N	\N	*	f575bea7-7260-4d81-a931-81d762f2b47d
69	sexy_videos	read	\N	\N	\N	*	f575bea7-7260-4d81-a931-81d762f2b47d
70	directus_files	read	\N	\N	\N	*	f575bea7-7260-4d81-a931-81d762f2b47d
95	directus_access	read	\N	\N	\N	*	f575bea7-7260-4d81-a931-81d762f2b47d
73	directus_policies	read	\N	\N	\N	*	f575bea7-7260-4d81-a931-81d762f2b47d
72	directus_roles	read	\N	\N	\N	*	f575bea7-7260-4d81-a931-81d762f2b47d
100	directus_users	update	{"_and":[{"id":{"_eq":"$CURRENT_USER"}}]}	\N	\N	first_name,username,last_name,website,password,avatar,tags,title,description,location	338928fb-f8ee-4450-8b24-4854dd8bc7e0
102	sexy_videos_directus_users	read	\N	\N	\N	*	f575bea7-7260-4d81-a931-81d762f2b47d
103	junction_directus_users_files	read	\N	\N	\N	*	f575bea7-7260-4d81-a931-81d762f2b47d
104	directus_permissions	read	\N	\N	\N	*	f575bea7-7260-4d81-a931-81d762f2b47d
105	directus_comments	read	\N	\N	\N	*	f575bea7-7260-4d81-a931-81d762f2b47d
71	directus_users	read	{"_and":[{"_or":[{"role":{"name":{"_eq":"Model"}}},{"policies":{"policy":{"name":{"_eq":"Model"}}}}]}]}	\N	\N	username,website,slug,join_date,avatar,featured,location,title,description,tags,policies,role,id,artist_name,last_name,first_name,banner,photos	f575bea7-7260-4d81-a931-81d762f2b47d
\.


--
-- Data for Name: directus_policies; Type: TABLE DATA; Schema: public; Owner: valknar
--

COPY public.directus_policies (id, name, icon, description, ip_access, enforce_tfa, admin_access, app_access) FROM stdin;
5f2a2bd8-588f-4ef7-8613-fa826e0b224d	Administrator	verified	$t:admin_description	\N	f	t	t
656e614d-a1aa-4b89-936a-e2c730fc85e1	Editor	ink_pen	\N	\N	f	f	t
7f06bc6a-6c55-4672-aedc-1c25b42dca52	Model	missed_video_call	\N	\N	f	f	t
338928fb-f8ee-4450-8b24-4854dd8bc7e0	Viewer	eyeglasses	\N	\N	f	f	t
f575bea7-7260-4d81-a931-81d762f2b47d	Public	public	\N	\N	f	f	f
\.


--
-- Data for Name: directus_presets; Type: TABLE DATA; Schema: public; Owner: valknar
--

COPY public.directus_presets (id, bookmark, "user", role, collection, search, layout, layout_query, layout_options, refresh_interval, filter, icon, color) FROM stdin;
2	\N	4d310101-f7b1-47fe-982a-efe4abf25c55	\N	sexy_articles	\N	\N	{"tabular":{"page":1}}	\N	\N	\N	bookmark	\N
6	\N	4d310101-f7b1-47fe-982a-efe4abf25c55	\N	sexy_videos	\N	\N	{"tabular":{"page":1}}	\N	\N	\N	bookmark	\N
5	\N	4d310101-f7b1-47fe-982a-efe4abf25c55	\N	directus_users	\N	cards	{"cards":{"sort":["email"],"page":1}}	{"cards":{"icon":"account_circle","title":"{{ first_name }} {{ last_name }}","subtitle":"{{ email }}","size":4}}	\N	\N	bookmark	\N
1	\N	4d310101-f7b1-47fe-982a-efe4abf25c55	\N	directus_files	\N	cards	{"cards":{"sort":["-uploaded_on"],"page":1}}	{"cards":{"icon":"insert_drive_file","title":"{{ title }}","subtitle":"{{ type }} • {{ filesize }}","size":4,"imageFit":"crop"}}	\N	\N	bookmark	\N
\.


--
-- Data for Name: directus_relations; Type: TABLE DATA; Schema: public; Owner: valknar
--

COPY public.directus_relations (id, many_collection, many_field, one_collection, one_field, one_collection_field, one_allowed_collections, junction_field, sort_field, one_deselect_action) FROM stdin;
6	sexy_articles	user_created	directus_users	\N	\N	\N	\N	\N	nullify
7	sexy_articles	image	directus_files	\N	\N	\N	\N	\N	nullify
8	sexy_articles	author	directus_users	\N	\N	\N	\N	\N	nullify
14	sexy_videos	user_created	directus_users	\N	\N	\N	\N	\N	nullify
15	sexy_videos	image	directus_files	\N	\N	\N	\N	\N	nullify
17	sexy_videos_directus_users	sexy_videos_id	sexy_videos	models	\N	\N	directus_users_id	\N	nullify
18	sexy_videos	movie	directus_files	\N	\N	\N	\N	\N	nullify
16	sexy_videos_directus_users	directus_users_id	directus_users	\N	\N	\N	sexy_videos_id	\N	nullify
25	junction_directus_users_files	directus_files_id	directus_files	\N	\N	\N	directus_users_id	\N	nullify
26	junction_directus_users_files	directus_users_id	directus_users	photos	\N	\N	directus_files_id	\N	nullify
27	directus_users	banner	directus_files	\N	\N	\N	\N	\N	nullify
\.


--
-- Data for Name: directus_revisions; Type: TABLE DATA; Schema: public; Owner: valknar
--

COPY public.directus_revisions (id, activity, collection, item, data, delta, parent, version) FROM stdin;
1	2	directus_settings	1	{"id":1,"project_name":"Directus","project_url":null,"project_color":"#6644FF","project_logo":null,"public_foreground":null,"public_background":null,"public_note":null,"auth_login_attempts":25,"auth_password_policy":null,"storage_asset_transform":"all","storage_asset_presets":null,"custom_css":null,"storage_default_folder":null,"basemaps":null,"mapbox_key":null,"module_bar":null,"project_descriptor":null,"default_language":"en-US","custom_aspect_ratios":null,"public_favicon":null,"default_appearance":"auto","default_theme_light":null,"theme_light_overrides":null,"default_theme_dark":null,"theme_dark_overrides":null,"report_error_url":null,"report_bug_url":null,"report_feature_url":null,"public_registration":false,"public_registration_verify_email":true,"public_registration_role":null,"public_registration_email_filter":null,"visual_editor_urls":null,"accepted_terms":true,"project_id":"01991b80-eceb-7715-aebb-b0b1fbf67973"}	{"accepted_terms":true}	\N	\N
2	3	directus_flows	35c3047d-fcdc-43a5-a58d-a34ce17f32f0	{"name":"Login","icon":"bolt","color":null,"description":null,"status":"inactive","accountability":"all","trigger":"webhook","options":{}}	{"name":"Login","icon":"bolt","color":null,"description":null,"status":"inactive","accountability":"all","trigger":"webhook","options":{}}	\N	\N
3	4	directus_flows	35c3047d-fcdc-43a5-a58d-a34ce17f32f0	{"id":"35c3047d-fcdc-43a5-a58d-a34ce17f32f0","name":"Login","icon":"bolt","color":null,"description":null,"status":"inactive","trigger":"event","accountability":"all","options":{"type":"filter","return":"$all","scope":["auth.create","items.create"],"collections":["directus_roles","directus_users"]},"operation":null,"date_created":"2025-09-06T08:36:20.768Z","user_created":"4d310101-f7b1-47fe-982a-efe4abf25c55","operations":[]}	{"name":"Login","icon":"bolt","color":null,"description":null,"status":"inactive","trigger":"event","accountability":"all","options":{"type":"filter","return":"$all","scope":["auth.create","items.create"],"collections":["directus_roles","directus_users"]}}	\N	\N
5	6	directus_flows	35c3047d-fcdc-43a5-a58d-a34ce17f32f0	{"id":"35c3047d-fcdc-43a5-a58d-a34ce17f32f0","name":"Login","icon":"bolt","color":null,"description":null,"status":"inactive","trigger":"event","accountability":"all","options":{"type":"filter","return":"$all","scope":["auth.create","items.create"],"collections":["directus_roles","directus_users"]},"operation":"6d4e66b9-7474-4b10-8926-30eb97beeefc","date_created":"2025-09-06T08:36:20.768Z","user_created":"4d310101-f7b1-47fe-982a-efe4abf25c55","operations":["6d4e66b9-7474-4b10-8926-30eb97beeefc"]}	{"operation":"6d4e66b9-7474-4b10-8926-30eb97beeefc"}	\N	\N
4	5	directus_operations	6d4e66b9-7474-4b10-8926-30eb97beeefc	{"flow":"35c3047d-fcdc-43a5-a58d-a34ce17f32f0","position_x":19,"position_y":1,"name":"Run Script","key":"exec_soxu8","type":"exec","options":{"code":"module.exports = async function(data) {\\n\\t// Do something...\\n\\treturn {};\\n}"}}	{"flow":"35c3047d-fcdc-43a5-a58d-a34ce17f32f0","position_x":19,"position_y":1,"name":"Run Script","key":"exec_soxu8","type":"exec","options":{"code":"module.exports = async function(data) {\\n\\t// Do something...\\n\\treturn {};\\n}"}}	5	\N
6	7	directus_roles	a1300aaa-0205-47d8-97a7-6166ac924e50	{"name":"Viewer"}	{"name":"Viewer"}	\N	\N
7	8	directus_roles	a1300aaa-0205-47d8-97a7-6166ac924e50	{"id":"a1300aaa-0205-47d8-97a7-6166ac924e50","name":"Viewer","icon":"eyeglasses","description":"As viewer is capable of watching videos, he paid for.","parent":null,"children":[],"policies":[],"users":[]}	{"icon":"eyeglasses","description":"As viewer is capable of watching videos, he paid for."}	\N	\N
8	9	directus_roles	55da25e6-9a87-4264-92e8-9066fdcf9c07	{"name":"Creator"}	{"name":"Creator"}	\N	\N
9	10	directus_roles	55da25e6-9a87-4264-92e8-9066fdcf9c07	{"id":"55da25e6-9a87-4264-92e8-9066fdcf9c07","name":"Creator","icon":"supervised_user_circle","description":"A creator is capable of creating videos by uploading them.","parent":null,"children":[],"policies":[],"users":[]}	{"description":"A creator is capable of creating videos by uploading them."}	\N	\N
10	11	directus_roles	55da25e6-9a87-4264-92e8-9066fdcf9c07	{"id":"55da25e6-9a87-4264-92e8-9066fdcf9c07","name":"Creator","icon":"missed_video_call","description":"A creator is capable of creating videos by uploading them.","parent":null,"children":[],"policies":[],"users":[]}	{"icon":"missed_video_call"}	\N	\N
11	12	directus_fields	1	{"sort":1,"hidden":true,"interface":"input","readonly":true,"field":"id","collection":"sexy_videos"}	{"sort":1,"hidden":true,"interface":"input","readonly":true,"field":"id","collection":"sexy_videos"}	\N	\N
12	13	directus_fields	2	{"sort":2,"width":"full","options":{"choices":[{"text":"$t:published","value":"published","color":"var(--theme--primary)"},{"text":"$t:draft","value":"draft","color":"var(--theme--foreground)"},{"text":"$t:archived","value":"archived","color":"var(--theme--warning)"}]},"interface":"select-dropdown","display":"labels","display_options":{"showAsDot":true,"choices":[{"text":"$t:published","value":"published","color":"var(--theme--primary)","foreground":"var(--theme--primary)","background":"var(--theme--primary-background)"},{"text":"$t:draft","value":"draft","color":"var(--theme--foreground)","foreground":"var(--theme--foreground)","background":"var(--theme--background-normal)"},{"text":"$t:archived","value":"archived","color":"var(--theme--warning)","foreground":"var(--theme--warning)","background":"var(--theme--warning-background)"}]},"field":"status","collection":"sexy_videos"}	{"sort":2,"width":"full","options":{"choices":[{"text":"$t:published","value":"published","color":"var(--theme--primary)"},{"text":"$t:draft","value":"draft","color":"var(--theme--foreground)"},{"text":"$t:archived","value":"archived","color":"var(--theme--warning)"}]},"interface":"select-dropdown","display":"labels","display_options":{"showAsDot":true,"choices":[{"text":"$t:published","value":"published","color":"var(--theme--primary)","foreground":"var(--theme--primary)","background":"var(--theme--primary-background)"},{"text":"$t:draft","value":"draft","color":"var(--theme--foreground)","foreground":"var(--theme--foreground)","background":"var(--theme--background-normal)"},{"text":"$t:archived","value":"archived","color":"var(--theme--warning)","foreground":"var(--theme--warning)","background":"var(--theme--warning-background)"}]},"field":"status","collection":"sexy_videos"}	\N	\N
13	14	directus_fields	3	{"sort":3,"special":["user-created"],"interface":"select-dropdown-m2o","options":{"template":"{{avatar}} {{first_name}} {{last_name}}"},"display":"user","readonly":true,"hidden":true,"width":"half","field":"user_created","collection":"sexy_videos"}	{"sort":3,"special":["user-created"],"interface":"select-dropdown-m2o","options":{"template":"{{avatar}} {{first_name}} {{last_name}}"},"display":"user","readonly":true,"hidden":true,"width":"half","field":"user_created","collection":"sexy_videos"}	\N	\N
14	15	directus_fields	4	{"sort":4,"special":["date-created"],"interface":"datetime","readonly":true,"hidden":true,"width":"half","display":"datetime","display_options":{"relative":true},"field":"date_created","collection":"sexy_videos"}	{"sort":4,"special":["date-created"],"interface":"datetime","readonly":true,"hidden":true,"width":"half","display":"datetime","display_options":{"relative":true},"field":"date_created","collection":"sexy_videos"}	\N	\N
676	928	junction_directus_users_files	1	{"id":1,"directus_users_id":null,"directus_files_id":null}	{"directus_users_id":null}	\N	\N
15	16	directus_fields	5	{"sort":5,"special":["date-updated"],"interface":"datetime","readonly":true,"hidden":true,"width":"half","display":"datetime","display_options":{"relative":true},"field":"date_updated","collection":"sexy_videos"}	{"sort":5,"special":["date-updated"],"interface":"datetime","readonly":true,"hidden":true,"width":"half","display":"datetime","display_options":{"relative":true},"field":"date_updated","collection":"sexy_videos"}	\N	\N
16	17	directus_collections	sexy_videos	{"archive_field":"status","archive_value":"archived","unarchive_value":"draft","singleton":false,"collection":"sexy_videos"}	{"archive_field":"status","archive_value":"archived","unarchive_value":"draft","singleton":false,"collection":"sexy_videos"}	\N	\N
17	18	directus_collections	sexy_videos	{"collection":"sexy_videos","icon":"video_file","note":null,"display_template":null,"hidden":false,"singleton":false,"translations":[{"language":"en-US","translation":"Sexy Videos","singular":"Video","plural":"Videos"}],"archive_field":"status","archive_app_filter":true,"archive_value":"archived","unarchive_value":"draft","sort_field":null,"accountability":"all","color":null,"item_duplication_fields":null,"sort":null,"group":null,"collapse":"open","preview_url":null,"versioning":true}	{"icon":"video_file","translations":[{"language":"en-US","translation":"Sexy Videos","singular":"Video","plural":"Videos"}],"versioning":true}	\N	\N
18	25	directus_fields	6	{"sort":1,"interface":"input","readonly":false,"hidden":false,"field":"id","collection":"sexy_videos"}	{"sort":1,"interface":"input","readonly":false,"hidden":false,"field":"id","collection":"sexy_videos"}	\N	\N
19	26	directus_fields	7	{"sort":2,"width":"full","options":{"choices":[{"text":"$t:published","value":"published","color":"var(--theme--primary)"},{"text":"$t:draft","value":"draft","color":"var(--theme--foreground)"},{"text":"$t:archived","value":"archived","color":"var(--theme--warning)"}]},"interface":"select-dropdown","display":"labels","display_options":{"showAsDot":true,"choices":[{"text":"$t:published","value":"published","color":"var(--theme--primary)","foreground":"var(--theme--primary)","background":"var(--theme--primary-background)"},{"text":"$t:draft","value":"draft","color":"var(--theme--foreground)","foreground":"var(--theme--foreground)","background":"var(--theme--background-normal)"},{"text":"$t:archived","value":"archived","color":"var(--theme--warning)","foreground":"var(--theme--warning)","background":"var(--theme--warning-background)"}]},"field":"status","collection":"sexy_videos"}	{"sort":2,"width":"full","options":{"choices":[{"text":"$t:published","value":"published","color":"var(--theme--primary)"},{"text":"$t:draft","value":"draft","color":"var(--theme--foreground)"},{"text":"$t:archived","value":"archived","color":"var(--theme--warning)"}]},"interface":"select-dropdown","display":"labels","display_options":{"showAsDot":true,"choices":[{"text":"$t:published","value":"published","color":"var(--theme--primary)","foreground":"var(--theme--primary)","background":"var(--theme--primary-background)"},{"text":"$t:draft","value":"draft","color":"var(--theme--foreground)","foreground":"var(--theme--foreground)","background":"var(--theme--background-normal)"},{"text":"$t:archived","value":"archived","color":"var(--theme--warning)","foreground":"var(--theme--warning)","background":"var(--theme--warning-background)"}]},"field":"status","collection":"sexy_videos"}	\N	\N
20	27	directus_fields	8	{"sort":3,"interface":"input","hidden":true,"field":"sort","collection":"sexy_videos"}	{"sort":3,"interface":"input","hidden":true,"field":"sort","collection":"sexy_videos"}	\N	\N
21	28	directus_fields	9	{"sort":4,"special":["user-created"],"interface":"select-dropdown-m2o","options":{"template":"{{avatar}} {{first_name}} {{last_name}}"},"display":"user","readonly":true,"hidden":true,"width":"half","field":"user_created","collection":"sexy_videos"}	{"sort":4,"special":["user-created"],"interface":"select-dropdown-m2o","options":{"template":"{{avatar}} {{first_name}} {{last_name}}"},"display":"user","readonly":true,"hidden":true,"width":"half","field":"user_created","collection":"sexy_videos"}	\N	\N
22	29	directus_fields	10	{"sort":5,"special":["date-created"],"interface":"datetime","readonly":true,"hidden":true,"width":"half","display":"datetime","display_options":{"relative":true},"field":"date_created","collection":"sexy_videos"}	{"sort":5,"special":["date-created"],"interface":"datetime","readonly":true,"hidden":true,"width":"half","display":"datetime","display_options":{"relative":true},"field":"date_created","collection":"sexy_videos"}	\N	\N
23	30	directus_fields	11	{"sort":6,"special":["date-updated"],"interface":"datetime","readonly":true,"hidden":true,"width":"half","display":"datetime","display_options":{"relative":true},"field":"date_updated","collection":"sexy_videos"}	{"sort":6,"special":["date-updated"],"interface":"datetime","readonly":true,"hidden":true,"width":"half","display":"datetime","display_options":{"relative":true},"field":"date_updated","collection":"sexy_videos"}	\N	\N
24	31	directus_collections	sexy_videos	{"sort_field":"sort","archive_field":"status","archive_value":"archived","unarchive_value":"draft","singleton":false,"collection":"sexy_videos"}	{"sort_field":"sort","archive_field":"status","archive_value":"archived","unarchive_value":"draft","singleton":false,"collection":"sexy_videos"}	\N	\N
25	32	directus_fields	8	{"id":8,"collection":"sexy_videos","field":"sort","special":null,"interface":"input","options":null,"display":null,"display_options":null,"readonly":false,"hidden":false,"sort":3,"width":"full","translations":null,"note":null,"conditions":null,"required":false,"group":null,"validation":null,"validation_message":null}	{"collection":"sexy_videos","field":"sort","hidden":false}	\N	\N
26	33	directus_fields	8	{"id":8,"collection":"sexy_videos","field":"sort","special":null,"interface":"input","options":null,"display":null,"display_options":null,"readonly":false,"hidden":true,"sort":3,"width":"full","translations":null,"note":null,"conditions":null,"required":false,"group":null,"validation":null,"validation_message":null}	{"collection":"sexy_videos","field":"sort","hidden":true}	\N	\N
27	41	directus_fields	12	{"sort":1,"interface":"input","readonly":false,"hidden":false,"field":"slug","collection":"sexy_videos"}	{"sort":1,"interface":"input","readonly":false,"hidden":false,"field":"slug","collection":"sexy_videos"}	\N	\N
41	56	directus_files	85fed315-0396-4d60-b23b-e32ef1d2d8a1	{"filename_download":"android-chrome-512x512.png","storage":"local","type":"image/png","title":"Android Chrome 512x512.png","folder":"c214c905-885b-4d66-a6a1-6527b0606200"}	{"filename_download":"android-chrome-512x512.png","storage":"local","type":"image/png","title":"Android Chrome 512x512.png","folder":"c214c905-885b-4d66-a6a1-6527b0606200"}	\N	\N
53	69	directus_permissions	7	{"policy":"338928fb-f8ee-4450-8b24-4854dd8bc7e0","permissions":{},"validation":{"comment":{"_nnull":true}},"presets":null,"fields":["*"],"system":true,"collection":"directus_comments","action":"create"}	{"policy":"338928fb-f8ee-4450-8b24-4854dd8bc7e0","permissions":{},"validation":{"comment":{"_nnull":true}},"presets":null,"fields":["*"],"system":true,"collection":"directus_comments","action":"create"}	\N	\N
142	162	directus_fields	30	{"sort":7,"interface":"input","special":null,"required":true,"collection":"sexy_articles","field":"title"}	{"sort":7,"interface":"input","special":null,"required":true,"collection":"sexy_articles","field":"title"}	\N	\N
28	42	directus_fields	13	{"sort":2,"width":"full","options":{"choices":[{"text":"$t:published","value":"published","color":"var(--theme--primary)"},{"text":"$t:draft","value":"draft","color":"var(--theme--foreground)"},{"text":"$t:archived","value":"archived","color":"var(--theme--warning)"}]},"interface":"select-dropdown","display":"labels","display_options":{"showAsDot":true,"choices":[{"text":"$t:published","value":"published","color":"var(--theme--primary)","foreground":"var(--theme--primary)","background":"var(--theme--primary-background)"},{"text":"$t:draft","value":"draft","color":"var(--theme--foreground)","foreground":"var(--theme--foreground)","background":"var(--theme--background-normal)"},{"text":"$t:archived","value":"archived","color":"var(--theme--warning)","foreground":"var(--theme--warning)","background":"var(--theme--warning-background)"}]},"field":"status","collection":"sexy_videos"}	{"sort":2,"width":"full","options":{"choices":[{"text":"$t:published","value":"published","color":"var(--theme--primary)"},{"text":"$t:draft","value":"draft","color":"var(--theme--foreground)"},{"text":"$t:archived","value":"archived","color":"var(--theme--warning)"}]},"interface":"select-dropdown","display":"labels","display_options":{"showAsDot":true,"choices":[{"text":"$t:published","value":"published","color":"var(--theme--primary)","foreground":"var(--theme--primary)","background":"var(--theme--primary-background)"},{"text":"$t:draft","value":"draft","color":"var(--theme--foreground)","foreground":"var(--theme--foreground)","background":"var(--theme--background-normal)"},{"text":"$t:archived","value":"archived","color":"var(--theme--warning)","foreground":"var(--theme--warning)","background":"var(--theme--warning-background)"}]},"field":"status","collection":"sexy_videos"}	\N	\N
29	43	directus_fields	14	{"sort":3,"interface":"input","hidden":true,"field":"sort","collection":"sexy_videos"}	{"sort":3,"interface":"input","hidden":true,"field":"sort","collection":"sexy_videos"}	\N	\N
30	44	directus_fields	15	{"sort":4,"special":["user-created"],"interface":"select-dropdown-m2o","options":{"template":"{{avatar}} {{first_name}} {{last_name}}"},"display":"user","readonly":true,"hidden":true,"width":"half","field":"user_created","collection":"sexy_videos"}	{"sort":4,"special":["user-created"],"interface":"select-dropdown-m2o","options":{"template":"{{avatar}} {{first_name}} {{last_name}}"},"display":"user","readonly":true,"hidden":true,"width":"half","field":"user_created","collection":"sexy_videos"}	\N	\N
31	45	directus_fields	16	{"sort":5,"special":["date-created"],"interface":"datetime","readonly":true,"hidden":true,"width":"half","display":"datetime","display_options":{"relative":true},"field":"date_created","collection":"sexy_videos"}	{"sort":5,"special":["date-created"],"interface":"datetime","readonly":true,"hidden":true,"width":"half","display":"datetime","display_options":{"relative":true},"field":"date_created","collection":"sexy_videos"}	\N	\N
32	46	directus_fields	17	{"sort":6,"special":["date-updated"],"interface":"datetime","readonly":true,"hidden":true,"width":"half","display":"datetime","display_options":{"relative":true},"field":"date_updated","collection":"sexy_videos"}	{"sort":6,"special":["date-updated"],"interface":"datetime","readonly":true,"hidden":true,"width":"half","display":"datetime","display_options":{"relative":true},"field":"date_updated","collection":"sexy_videos"}	\N	\N
33	47	directus_collections	sexy_videos	{"sort_field":"sort","archive_field":"status","archive_value":"archived","unarchive_value":"draft","singleton":false,"collection":"sexy_videos"}	{"sort_field":"sort","archive_field":"status","archive_value":"archived","unarchive_value":"draft","singleton":false,"collection":"sexy_videos"}	\N	\N
34	48	directus_fields	12	{"id":12,"collection":"sexy_videos","field":"slug","special":null,"interface":"input","options":null,"display":null,"display_options":null,"readonly":false,"hidden":false,"sort":1,"width":"full","translations":null,"note":null,"conditions":null,"required":true,"group":null,"validation":null,"validation_message":null}	{"collection":"sexy_videos","field":"slug","required":true}	\N	\N
35	49	directus_collections	sexy_videos	{"collection":"sexy_videos","icon":"video_file","note":null,"display_template":null,"hidden":false,"singleton":false,"translations":null,"archive_field":"status","archive_app_filter":true,"archive_value":"archived","unarchive_value":"draft","sort_field":"sort","accountability":"all","color":null,"item_duplication_fields":null,"sort":null,"group":null,"collapse":"open","preview_url":null,"versioning":true}	{"icon":"video_file","versioning":true}	\N	\N
36	50	directus_settings	1	{"id":1,"project_name":"Directus","project_url":null,"project_color":"#6644FF","project_logo":null,"public_foreground":null,"public_background":null,"public_note":null,"auth_login_attempts":25,"auth_password_policy":null,"storage_asset_transform":"all","storage_asset_presets":null,"custom_css":null,"storage_default_folder":null,"basemaps":null,"mapbox_key":null,"module_bar":null,"project_descriptor":null,"default_language":"en-US","custom_aspect_ratios":null,"public_favicon":null,"default_appearance":"auto","default_theme_light":null,"theme_light_overrides":null,"default_theme_dark":null,"theme_dark_overrides":null,"report_error_url":null,"report_bug_url":null,"report_feature_url":null,"public_registration":true,"public_registration_verify_email":true,"public_registration_role":"a1300aaa-0205-47d8-97a7-6166ac924e50","public_registration_email_filter":null,"visual_editor_urls":null,"accepted_terms":true,"project_id":"01991b80-eceb-7715-aebb-b0b1fbf67973"}	{"public_registration":true,"public_registration_role":"a1300aaa-0205-47d8-97a7-6166ac924e50"}	\N	\N
37	51	directus_folders	c214c905-885b-4d66-a6a1-6527b0606200	{"name":"videos"}	{"name":"videos"}	\N	\N
38	52	directus_settings	1	{"id":1,"project_name":"Sexy.Art","project_url":"https://sexy.pivoine.art","project_color":"#6644FF","project_logo":null,"public_foreground":null,"public_background":null,"public_note":null,"auth_login_attempts":25,"auth_password_policy":null,"storage_asset_transform":"all","storage_asset_presets":null,"custom_css":null,"storage_default_folder":null,"basemaps":null,"mapbox_key":null,"module_bar":null,"project_descriptor":null,"default_language":"en-US","custom_aspect_ratios":null,"public_favicon":null,"default_appearance":"auto","default_theme_light":null,"theme_light_overrides":null,"default_theme_dark":null,"theme_dark_overrides":null,"report_error_url":null,"report_bug_url":null,"report_feature_url":null,"public_registration":true,"public_registration_verify_email":true,"public_registration_role":"a1300aaa-0205-47d8-97a7-6166ac924e50","public_registration_email_filter":null,"visual_editor_urls":null,"accepted_terms":true,"project_id":"01991b80-eceb-7715-aebb-b0b1fbf67973"}	{"project_name":"Sexy.Art","project_url":"https://sexy.pivoine.art"}	\N	\N
40	54	directus_files	82dd90a8-35f7-4b16-9928-0bedb4a1fab8	{"filename_download":"android-chrome-512x512.png","storage":"local","type":"image/png","title":"Android Chrome 512x512.png","folder":"c214c905-885b-4d66-a6a1-6527b0606200"}	{"filename_download":"android-chrome-512x512.png","storage":"local","type":"image/png","title":"Android Chrome 512x512.png","folder":"c214c905-885b-4d66-a6a1-6527b0606200"}	\N	\N
138	157	directus_collections	sexy_articles	{"archive_field":"status","archive_value":"archived","unarchive_value":"draft","singleton":false,"collection":"sexy_articles"}	{"archive_field":"status","archive_value":"archived","unarchive_value":"draft","singleton":false,"collection":"sexy_articles"}	\N	\N
39	53	directus_settings	1	{"id":1,"project_name":"Sexy.Art","project_url":"https://sexy.pivoine.art","project_color":"#6644FF","project_logo":null,"public_foreground":null,"public_background":null,"public_note":null,"auth_login_attempts":25,"auth_password_policy":"/(?=^.{8,}$)(?=.*\\\\d)(?=.*[a-z])(?=.*[A-Z])(?=.*[!@#$%^&*()_+}{';'?>.<,])(?!.*\\\\s).*$/","storage_asset_transform":"presets","storage_asset_presets":[{"key":"sexy-video-thumbnail","fit":"cover","width":600,"height":null,"quality":80,"withoutEnlargement":true,"format":"webp","transforms":[]},{"key":"sexy-video-banner","fit":"cover","width":1920,"quality":80,"withoutEnlargement":false,"format":"webp","transforms":[]},{"key":"sexy-video-preview","fit":"cover","width":1080,"quality":80,"withoutEnlargement":true,"format":"webp","transforms":[]}],"custom_css":null,"storage_default_folder":"c214c905-885b-4d66-a6a1-6527b0606200","basemaps":null,"mapbox_key":null,"module_bar":[{"type":"module","id":"content","enabled":true},{"type":"module","id":"visual","enabled":false},{"type":"module","id":"users","enabled":true},{"type":"module","id":"files","enabled":true},{"type":"module","id":"insights","enabled":true},{"type":"link","id":"docs","enabled":true,"name":"$t:documentation","icon":"help","url":"https://docs.directus.io"},{"type":"module","id":"settings","enabled":true,"locked":true},{"id":"JpYiQQKgf-i3unxAY1efo","type":"link","enabled":true,"url":"/files/videos","name":"Sexy Videos","icon":"videocam"}],"project_descriptor":null,"default_language":"en-US","custom_aspect_ratios":null,"public_favicon":null,"default_appearance":"auto","default_theme_light":null,"theme_light_overrides":null,"default_theme_dark":null,"theme_dark_overrides":null,"report_error_url":null,"report_bug_url":null,"report_feature_url":null,"public_registration":true,"public_registration_verify_email":true,"public_registration_role":"a1300aaa-0205-47d8-97a7-6166ac924e50","public_registration_email_filter":null,"visual_editor_urls":null,"accepted_terms":true,"project_id":"01991b80-eceb-7715-aebb-b0b1fbf67973"}	{"auth_password_policy":"/(?=^.{8,}$)(?=.*\\\\d)(?=.*[a-z])(?=.*[A-Z])(?=.*[!@#$%^&*()_+}{';'?>.<,])(?!.*\\\\s).*$/","storage_asset_transform":"presets","storage_asset_presets":[{"key":"sexy-video-thumbnail","fit":"cover","width":600,"height":null,"quality":80,"withoutEnlargement":true,"format":"webp","transforms":[]},{"key":"sexy-video-banner","fit":"cover","width":1920,"quality":80,"withoutEnlargement":false,"format":"webp","transforms":[]},{"key":"sexy-video-preview","fit":"cover","width":1080,"quality":80,"withoutEnlargement":true,"format":"webp","transforms":[]}],"storage_default_folder":"c214c905-885b-4d66-a6a1-6527b0606200","module_bar":[{"type":"module","id":"content","enabled":true},{"type":"module","id":"visual","enabled":false},{"type":"module","id":"users","enabled":true},{"type":"module","id":"files","enabled":true},{"type":"module","id":"insights","enabled":true},{"type":"link","id":"docs","enabled":true,"name":"$t:documentation","icon":"help","url":"https://docs.directus.io"},{"type":"module","id":"settings","enabled":true,"locked":true},{"id":"JpYiQQKgf-i3unxAY1efo","type":"link","enabled":true,"url":"/files/videos","name":"Sexy Videos","icon":"videocam"}]}	\N	\N
42	58	directus_folders	3eaf8f03-dbfe-4c73-b513-5cc588de6457	{"name":"branding"}	{"name":"branding"}	\N	\N
45	61	directus_settings	1	{"id":1,"project_name":"Sexy.Art","project_url":"https://sexy.pivoine.art","project_color":"#6644FF","project_logo":"8ad7e858-0c83-4d88-bb50-3680f1cfa9c2","public_foreground":null,"public_background":null,"public_note":"Where Love Meets Artistry","auth_login_attempts":25,"auth_password_policy":"/(?=^.{8,}$)(?=.*\\\\d)(?=.*[a-z])(?=.*[A-Z])(?=.*[!@#$%^&*()_+}{';'?>.<,])(?!.*\\\\s).*$/","storage_asset_transform":"presets","storage_asset_presets":[{"key":"sexy-video-thumbnail","fit":"cover","width":600,"height":null,"quality":80,"withoutEnlargement":true,"format":"webp","transforms":[]},{"key":"sexy-video-banner","fit":"cover","width":1920,"quality":80,"withoutEnlargement":false,"format":"webp","transforms":[]},{"key":"sexy-video-preview","fit":"cover","width":1080,"quality":80,"withoutEnlargement":true,"format":"webp","transforms":[]}],"custom_css":null,"storage_default_folder":"c214c905-885b-4d66-a6a1-6527b0606200","basemaps":null,"mapbox_key":null,"module_bar":[{"type":"module","id":"content","enabled":true},{"type":"module","id":"visual","enabled":false},{"type":"module","id":"users","enabled":true},{"type":"module","id":"files","enabled":true},{"type":"module","id":"insights","enabled":true},{"type":"link","id":"docs","enabled":true,"name":"$t:documentation","icon":"help","url":"https://docs.directus.io"},{"type":"module","id":"settings","enabled":true,"locked":true},{"id":"JpYiQQKgf-i3unxAY1efo","type":"link","enabled":true,"url":"/files/videos","name":"Sexy Videos","icon":"videocam"}],"project_descriptor":null,"default_language":"en-US","custom_aspect_ratios":null,"public_favicon":null,"default_appearance":"auto","default_theme_light":null,"theme_light_overrides":null,"default_theme_dark":null,"theme_dark_overrides":null,"report_error_url":null,"report_bug_url":null,"report_feature_url":null,"public_registration":true,"public_registration_verify_email":true,"public_registration_role":"a1300aaa-0205-47d8-97a7-6166ac924e50","public_registration_email_filter":null,"visual_editor_urls":null,"accepted_terms":true,"project_id":"01991b80-eceb-7715-aebb-b0b1fbf67973"}	{"public_note":"Where Love Meets Artistry"}	\N	\N
43	59	directus_files	8ad7e858-0c83-4d88-bb50-3680f1cfa9c2	{"folder":"3eaf8f03-dbfe-4c73-b513-5cc588de6457","title":"Duality Mask","filename_download":"duality-mask.png","type":"image/png","storage":"local"}	{"folder":"3eaf8f03-dbfe-4c73-b513-5cc588de6457","title":"Duality Mask","filename_download":"duality-mask.png","type":"image/png","storage":"local"}	\N	\N
44	60	directus_settings	1	{"id":1,"project_name":"Sexy.Art","project_url":"https://sexy.pivoine.art","project_color":"#6644FF","project_logo":"8ad7e858-0c83-4d88-bb50-3680f1cfa9c2","public_foreground":null,"public_background":null,"public_note":null,"auth_login_attempts":25,"auth_password_policy":"/(?=^.{8,}$)(?=.*\\\\d)(?=.*[a-z])(?=.*[A-Z])(?=.*[!@#$%^&*()_+}{';'?>.<,])(?!.*\\\\s).*$/","storage_asset_transform":"presets","storage_asset_presets":[{"key":"sexy-video-thumbnail","fit":"cover","width":600,"height":null,"quality":80,"withoutEnlargement":true,"format":"webp","transforms":[]},{"key":"sexy-video-banner","fit":"cover","width":1920,"quality":80,"withoutEnlargement":false,"format":"webp","transforms":[]},{"key":"sexy-video-preview","fit":"cover","width":1080,"quality":80,"withoutEnlargement":true,"format":"webp","transforms":[]}],"custom_css":null,"storage_default_folder":"c214c905-885b-4d66-a6a1-6527b0606200","basemaps":null,"mapbox_key":null,"module_bar":[{"type":"module","id":"content","enabled":true},{"type":"module","id":"visual","enabled":false},{"type":"module","id":"users","enabled":true},{"type":"module","id":"files","enabled":true},{"type":"module","id":"insights","enabled":true},{"type":"link","id":"docs","enabled":true,"name":"$t:documentation","icon":"help","url":"https://docs.directus.io"},{"type":"module","id":"settings","enabled":true,"locked":true},{"id":"JpYiQQKgf-i3unxAY1efo","type":"link","enabled":true,"url":"/files/videos","name":"Sexy Videos","icon":"videocam"}],"project_descriptor":null,"default_language":"en-US","custom_aspect_ratios":null,"public_favicon":null,"default_appearance":"auto","default_theme_light":null,"theme_light_overrides":null,"default_theme_dark":null,"theme_dark_overrides":null,"report_error_url":null,"report_bug_url":null,"report_feature_url":null,"public_registration":true,"public_registration_verify_email":true,"public_registration_role":"a1300aaa-0205-47d8-97a7-6166ac924e50","public_registration_email_filter":null,"visual_editor_urls":null,"accepted_terms":true,"project_id":"01991b80-eceb-7715-aebb-b0b1fbf67973"}	{"project_logo":"8ad7e858-0c83-4d88-bb50-3680f1cfa9c2"}	\N	\N
46	62	directus_policies	338928fb-f8ee-4450-8b24-4854dd8bc7e0	{"name":"Viewer","admin_access":false,"app_access":true}	{"name":"Viewer","admin_access":false,"app_access":true}	\N	\N
47	63	directus_permissions	1	{"policy":"338928fb-f8ee-4450-8b24-4854dd8bc7e0","permissions":{},"validation":null,"presets":null,"fields":["*"],"system":true,"collection":"directus_collections","action":"read"}	{"policy":"338928fb-f8ee-4450-8b24-4854dd8bc7e0","permissions":{},"validation":null,"presets":null,"fields":["*"],"system":true,"collection":"directus_collections","action":"read"}	\N	\N
48	64	directus_permissions	2	{"policy":"338928fb-f8ee-4450-8b24-4854dd8bc7e0","permissions":{},"validation":null,"presets":null,"fields":["*"],"system":true,"collection":"directus_fields","action":"read"}	{"policy":"338928fb-f8ee-4450-8b24-4854dd8bc7e0","permissions":{},"validation":null,"presets":null,"fields":["*"],"system":true,"collection":"directus_fields","action":"read"}	\N	\N
49	65	directus_permissions	3	{"policy":"338928fb-f8ee-4450-8b24-4854dd8bc7e0","permissions":{},"validation":null,"presets":null,"fields":["*"],"system":true,"collection":"directus_relations","action":"read"}	{"policy":"338928fb-f8ee-4450-8b24-4854dd8bc7e0","permissions":{},"validation":null,"presets":null,"fields":["*"],"system":true,"collection":"directus_relations","action":"read"}	\N	\N
50	66	directus_permissions	4	{"policy":"338928fb-f8ee-4450-8b24-4854dd8bc7e0","permissions":{},"validation":null,"presets":null,"fields":["*"],"system":true,"collection":"directus_translations","action":"read"}	{"policy":"338928fb-f8ee-4450-8b24-4854dd8bc7e0","permissions":{},"validation":null,"presets":null,"fields":["*"],"system":true,"collection":"directus_translations","action":"read"}	\N	\N
51	67	directus_permissions	5	{"policy":"338928fb-f8ee-4450-8b24-4854dd8bc7e0","permissions":{"user":{"_eq":"$CURRENT_USER"}},"validation":null,"presets":null,"fields":["*"],"system":true,"collection":"directus_activity","action":"read"}	{"policy":"338928fb-f8ee-4450-8b24-4854dd8bc7e0","permissions":{"user":{"_eq":"$CURRENT_USER"}},"validation":null,"presets":null,"fields":["*"],"system":true,"collection":"directus_activity","action":"read"}	\N	\N
52	68	directus_permissions	6	{"policy":"338928fb-f8ee-4450-8b24-4854dd8bc7e0","permissions":{"user_created":{"_eq":"$CURRENT_USER"}},"validation":null,"presets":null,"fields":["*"],"system":true,"collection":"directus_comments","action":"read"}	{"policy":"338928fb-f8ee-4450-8b24-4854dd8bc7e0","permissions":{"user_created":{"_eq":"$CURRENT_USER"}},"validation":null,"presets":null,"fields":["*"],"system":true,"collection":"directus_comments","action":"read"}	\N	\N
549	761	directus_folders	3f83c727-9c90-4e0d-871f-ab81c295043a	{"name":"movies","parent":"26657630-d9cd-47a3-9e45-9831f3674f97"}	{"name":"movies","parent":"26657630-d9cd-47a3-9e45-9831f3674f97"}	\N	\N
54	70	directus_permissions	8	{"policy":"338928fb-f8ee-4450-8b24-4854dd8bc7e0","permissions":{"user_created":{"_eq":"$CURRENT_USER"}},"validation":null,"presets":null,"fields":["comment"],"system":true,"collection":"directus_comments","action":"update"}	{"policy":"338928fb-f8ee-4450-8b24-4854dd8bc7e0","permissions":{"user_created":{"_eq":"$CURRENT_USER"}},"validation":null,"presets":null,"fields":["comment"],"system":true,"collection":"directus_comments","action":"update"}	\N	\N
55	71	directus_permissions	9	{"policy":"338928fb-f8ee-4450-8b24-4854dd8bc7e0","permissions":{"user_created":{"_eq":"$CURRENT_USER"}},"validation":null,"presets":null,"fields":["*"],"system":true,"collection":"directus_comments","action":"delete"}	{"policy":"338928fb-f8ee-4450-8b24-4854dd8bc7e0","permissions":{"user_created":{"_eq":"$CURRENT_USER"}},"validation":null,"presets":null,"fields":["*"],"system":true,"collection":"directus_comments","action":"delete"}	\N	\N
56	72	directus_permissions	10	{"policy":"338928fb-f8ee-4450-8b24-4854dd8bc7e0","permissions":{"_or":[{"user":{"_eq":"$CURRENT_USER"}},{"_and":[{"user":{"_null":true}},{"role":{"_eq":"$CURRENT_ROLE"}}]},{"_and":[{"user":{"_null":true}},{"role":{"_null":true}}]}]},"validation":null,"presets":null,"fields":["*"],"system":true,"collection":"directus_presets","action":"read"}	{"policy":"338928fb-f8ee-4450-8b24-4854dd8bc7e0","permissions":{"_or":[{"user":{"_eq":"$CURRENT_USER"}},{"_and":[{"user":{"_null":true}},{"role":{"_eq":"$CURRENT_ROLE"}}]},{"_and":[{"user":{"_null":true}},{"role":{"_null":true}}]}]},"validation":null,"presets":null,"fields":["*"],"system":true,"collection":"directus_presets","action":"read"}	\N	\N
57	73	directus_permissions	11	{"policy":"338928fb-f8ee-4450-8b24-4854dd8bc7e0","permissions":{},"validation":{"user":{"_eq":"$CURRENT_USER"}},"presets":null,"fields":["*"],"system":true,"collection":"directus_presets","action":"create"}	{"policy":"338928fb-f8ee-4450-8b24-4854dd8bc7e0","permissions":{},"validation":{"user":{"_eq":"$CURRENT_USER"}},"presets":null,"fields":["*"],"system":true,"collection":"directus_presets","action":"create"}	\N	\N
58	74	directus_permissions	12	{"policy":"338928fb-f8ee-4450-8b24-4854dd8bc7e0","permissions":{"user":{"_eq":"$CURRENT_USER"}},"validation":{"user":{"_eq":"$CURRENT_USER"}},"presets":null,"fields":["*"],"system":true,"collection":"directus_presets","action":"update"}	{"policy":"338928fb-f8ee-4450-8b24-4854dd8bc7e0","permissions":{"user":{"_eq":"$CURRENT_USER"}},"validation":{"user":{"_eq":"$CURRENT_USER"}},"presets":null,"fields":["*"],"system":true,"collection":"directus_presets","action":"update"}	\N	\N
59	75	directus_permissions	13	{"policy":"338928fb-f8ee-4450-8b24-4854dd8bc7e0","permissions":{"user":{"_eq":"$CURRENT_USER"}},"validation":null,"presets":null,"fields":["*"],"system":true,"collection":"directus_presets","action":"delete"}	{"policy":"338928fb-f8ee-4450-8b24-4854dd8bc7e0","permissions":{"user":{"_eq":"$CURRENT_USER"}},"validation":null,"presets":null,"fields":["*"],"system":true,"collection":"directus_presets","action":"delete"}	\N	\N
60	76	directus_permissions	14	{"policy":"338928fb-f8ee-4450-8b24-4854dd8bc7e0","permissions":{"id":{"_in":"$CURRENT_ROLES"}},"validation":null,"presets":null,"fields":["*"],"system":true,"collection":"directus_roles","action":"read"}	{"policy":"338928fb-f8ee-4450-8b24-4854dd8bc7e0","permissions":{"id":{"_in":"$CURRENT_ROLES"}},"validation":null,"presets":null,"fields":["*"],"system":true,"collection":"directus_roles","action":"read"}	\N	\N
61	77	directus_permissions	15	{"policy":"338928fb-f8ee-4450-8b24-4854dd8bc7e0","permissions":{},"validation":null,"presets":null,"fields":["*"],"system":true,"collection":"directus_settings","action":"read"}	{"policy":"338928fb-f8ee-4450-8b24-4854dd8bc7e0","permissions":{},"validation":null,"presets":null,"fields":["*"],"system":true,"collection":"directus_settings","action":"read"}	\N	\N
62	78	directus_permissions	16	{"policy":"338928fb-f8ee-4450-8b24-4854dd8bc7e0","permissions":{},"validation":null,"presets":null,"fields":["*"],"system":true,"collection":"directus_translations","action":"read"}	{"policy":"338928fb-f8ee-4450-8b24-4854dd8bc7e0","permissions":{},"validation":null,"presets":null,"fields":["*"],"system":true,"collection":"directus_translations","action":"read"}	\N	\N
63	79	directus_permissions	17	{"policy":"338928fb-f8ee-4450-8b24-4854dd8bc7e0","permissions":{"recipient":{"_eq":"$CURRENT_USER"}},"validation":null,"presets":null,"fields":["*"],"system":true,"collection":"directus_notifications","action":"read"}	{"policy":"338928fb-f8ee-4450-8b24-4854dd8bc7e0","permissions":{"recipient":{"_eq":"$CURRENT_USER"}},"validation":null,"presets":null,"fields":["*"],"system":true,"collection":"directus_notifications","action":"read"}	\N	\N
64	80	directus_permissions	18	{"policy":"338928fb-f8ee-4450-8b24-4854dd8bc7e0","permissions":{"recipient":{"_eq":"$CURRENT_USER"}},"validation":null,"presets":null,"fields":["status"],"system":true,"collection":"directus_notifications","action":"update"}	{"policy":"338928fb-f8ee-4450-8b24-4854dd8bc7e0","permissions":{"recipient":{"_eq":"$CURRENT_USER"}},"validation":null,"presets":null,"fields":["status"],"system":true,"collection":"directus_notifications","action":"update"}	\N	\N
65	81	directus_permissions	19	{"policy":"338928fb-f8ee-4450-8b24-4854dd8bc7e0","permissions":{"user_created":{"_eq":"$CURRENT_USER"}},"validation":null,"presets":null,"fields":["*"],"system":true,"collection":"directus_shares","action":"read"}	{"policy":"338928fb-f8ee-4450-8b24-4854dd8bc7e0","permissions":{"user_created":{"_eq":"$CURRENT_USER"}},"validation":null,"presets":null,"fields":["*"],"system":true,"collection":"directus_shares","action":"read"}	\N	\N
66	82	directus_permissions	20	{"policy":"338928fb-f8ee-4450-8b24-4854dd8bc7e0","permissions":{"id":{"_eq":"$CURRENT_USER"}},"validation":null,"presets":null,"fields":["id","first_name","last_name","last_page","email","password","location","title","description","tags","preferences_divider","avatar","language","appearance","theme_light","theme_dark","tfa_secret","status","role"],"system":true,"collection":"directus_users","action":"read"}	{"policy":"338928fb-f8ee-4450-8b24-4854dd8bc7e0","permissions":{"id":{"_eq":"$CURRENT_USER"}},"validation":null,"presets":null,"fields":["id","first_name","last_name","last_page","email","password","location","title","description","tags","preferences_divider","avatar","language","appearance","theme_light","theme_dark","tfa_secret","status","role"],"system":true,"collection":"directus_users","action":"read"}	\N	\N
69	85	directus_policies	338928fb-f8ee-4450-8b24-4854dd8bc7e0	{"id":"338928fb-f8ee-4450-8b24-4854dd8bc7e0","name":"Viewer","icon":"badge","description":null,"ip_access":null,"enforce_tfa":true,"admin_access":false,"app_access":true,"permissions":[1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21],"users":["32084f66-b9e3-4192-b990-96b72afc8844"],"roles":["32084f66-b9e3-4192-b990-96b72afc8844"]}	{"enforce_tfa":true}	\N	\N
67	83	directus_access	32084f66-b9e3-4192-b990-96b72afc8844	{"policy":"338928fb-f8ee-4450-8b24-4854dd8bc7e0","role":{"id":"a1300aaa-0205-47d8-97a7-6166ac924e50"}}	{"policy":"338928fb-f8ee-4450-8b24-4854dd8bc7e0","role":{"id":"a1300aaa-0205-47d8-97a7-6166ac924e50"}}	69	\N
140	160	directus_fields	29	{"sort":6,"interface":"input","special":null,"required":true,"collection":"sexy_articles","field":"slug"}	{"sort":6,"interface":"input","special":null,"required":true,"collection":"sexy_articles","field":"slug"}	\N	\N
68	84	directus_permissions	21	{"policy":"338928fb-f8ee-4450-8b24-4854dd8bc7e0","permissions":null,"validation":null,"fields":["*"],"presets":null,"collection":"sexy_videos","action":"read"}	{"policy":"338928fb-f8ee-4450-8b24-4854dd8bc7e0","permissions":null,"validation":null,"fields":["*"],"presets":null,"collection":"sexy_videos","action":"read"}	69	\N
70	86	directus_policies	338928fb-f8ee-4450-8b24-4854dd8bc7e0	{"id":"338928fb-f8ee-4450-8b24-4854dd8bc7e0","name":"Viewer","icon":"eyeglasses","description":null,"ip_access":null,"enforce_tfa":true,"admin_access":false,"app_access":true,"permissions":[1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21],"users":["32084f66-b9e3-4192-b990-96b72afc8844"],"roles":["32084f66-b9e3-4192-b990-96b72afc8844"]}	{"icon":"eyeglasses"}	\N	\N
71	87	directus_policies	7f06bc6a-6c55-4672-aedc-1c25b42dca52	{"name":"Creator","admin_access":true,"app_access":true}	{"name":"Creator","admin_access":true,"app_access":true}	\N	\N
72	88	directus_access	aa848283-ea71-4c25-8e2f-e9024bce0d4f	{"policy":"7f06bc6a-6c55-4672-aedc-1c25b42dca52","role":{"id":"55da25e6-9a87-4264-92e8-9066fdcf9c07"}}	{"policy":"7f06bc6a-6c55-4672-aedc-1c25b42dca52","role":{"id":"55da25e6-9a87-4264-92e8-9066fdcf9c07"}}	78	\N
73	89	directus_permissions	22	{"policy":"7f06bc6a-6c55-4672-aedc-1c25b42dca52","permissions":null,"validation":null,"fields":["*"],"presets":null,"collection":"sexy_videos","action":"create"}	{"policy":"7f06bc6a-6c55-4672-aedc-1c25b42dca52","permissions":null,"validation":null,"fields":["*"],"presets":null,"collection":"sexy_videos","action":"create"}	78	\N
78	94	directus_policies	7f06bc6a-6c55-4672-aedc-1c25b42dca52	{"id":"7f06bc6a-6c55-4672-aedc-1c25b42dca52","name":"Creator","icon":"missed_video_call","description":null,"ip_access":null,"enforce_tfa":true,"admin_access":false,"app_access":true,"permissions":[22,23,24,25,26],"users":["aa848283-ea71-4c25-8e2f-e9024bce0d4f"],"roles":["aa848283-ea71-4c25-8e2f-e9024bce0d4f"]}	{"icon":"missed_video_call","enforce_tfa":true,"admin_access":false}	\N	\N
74	90	directus_permissions	23	{"policy":"7f06bc6a-6c55-4672-aedc-1c25b42dca52","permissions":null,"validation":null,"fields":["*"],"presets":null,"collection":"sexy_videos","action":"read"}	{"policy":"7f06bc6a-6c55-4672-aedc-1c25b42dca52","permissions":null,"validation":null,"fields":["*"],"presets":null,"collection":"sexy_videos","action":"read"}	78	\N
75	91	directus_permissions	24	{"policy":"7f06bc6a-6c55-4672-aedc-1c25b42dca52","permissions":{"_and":[{"user_created":{"id":{"_eq":"$CURRENT_USER.id"}}}]},"validation":null,"fields":["*"],"presets":null,"collection":"sexy_videos","action":"update"}	{"policy":"7f06bc6a-6c55-4672-aedc-1c25b42dca52","permissions":{"_and":[{"user_created":{"id":{"_eq":"$CURRENT_USER.id"}}}]},"validation":null,"fields":["*"],"presets":null,"collection":"sexy_videos","action":"update"}	78	\N
76	92	directus_permissions	25	{"policy":"7f06bc6a-6c55-4672-aedc-1c25b42dca52","permissions":{"_and":[{"user_created":{"id":{"_eq":"$CURRENT_USER.id"}}}]},"validation":null,"fields":["*"],"presets":null,"collection":"sexy_videos","action":"delete"}	{"policy":"7f06bc6a-6c55-4672-aedc-1c25b42dca52","permissions":{"_and":[{"user_created":{"id":{"_eq":"$CURRENT_USER.id"}}}]},"validation":null,"fields":["*"],"presets":null,"collection":"sexy_videos","action":"delete"}	78	\N
77	93	directus_permissions	26	{"policy":"7f06bc6a-6c55-4672-aedc-1c25b42dca52","permissions":null,"validation":null,"fields":["*"],"presets":null,"collection":"sexy_videos","action":"share"}	{"policy":"7f06bc6a-6c55-4672-aedc-1c25b42dca52","permissions":null,"validation":null,"fields":["*"],"presets":null,"collection":"sexy_videos","action":"share"}	78	\N
79	95	directus_fields	18	{"sort":7,"interface":"file-image","special":["file"],"required":true,"options":{"folder":"c214c905-885b-4d66-a6a1-6527b0606200","enableSelect":false,"filter":{"_and":[{"width":{"_eq":"1920"}}]}},"collection":"sexy_videos","field":"preview"}	{"sort":7,"interface":"file-image","special":["file"],"required":true,"options":{"folder":"c214c905-885b-4d66-a6a1-6527b0606200","enableSelect":false,"filter":{"_and":[{"width":{"_eq":"1920"}}]}},"collection":"sexy_videos","field":"preview"}	\N	\N
80	96	directus_fields	19	{"sort":8,"interface":"file","special":["file"],"required":true,"options":{"folder":"c214c905-885b-4d66-a6a1-6527b0606200","filter":{"_and":[{"type":{"_contains":"video"}}]}},"collection":"sexy_videos","field":"media"}	{"sort":8,"interface":"file","special":["file"],"required":true,"options":{"folder":"c214c905-885b-4d66-a6a1-6527b0606200","filter":{"_and":[{"type":{"_contains":"video"}}]}},"collection":"sexy_videos","field":"media"}	\N	\N
81	97	directus_fields	12	{"id":12,"collection":"sexy_videos","field":"slug","special":null,"interface":"input","options":{"slug":true,"masked":true,"trim":true},"display":null,"display_options":null,"readonly":false,"hidden":false,"sort":1,"width":"full","translations":null,"note":null,"conditions":null,"required":true,"group":null,"validation":null,"validation_message":null}	{"collection":"sexy_videos","field":"slug","options":{"slug":true,"masked":true,"trim":true}}	\N	\N
82	98	directus_fields	12	{"id":12,"collection":"sexy_videos","field":"slug","special":null,"interface":null,"options":{"slug":true,"masked":true,"trim":true},"display":null,"display_options":null,"readonly":false,"hidden":false,"sort":1,"width":"full","translations":null,"note":null,"conditions":null,"required":true,"group":null,"validation":null,"validation_message":null}	{"collection":"sexy_videos","field":"slug","interface":null}	\N	\N
83	99	directus_fields	20	{"sort":9,"interface":"input","special":null,"required":true,"collection":"sexy_videos","field":"title"}	{"sort":9,"interface":"input","special":null,"required":true,"collection":"sexy_videos","field":"title"}	\N	\N
84	100	directus_fields	12	{"id":12,"collection":"sexy_videos","field":"slug","special":null,"interface":null,"options":{"slug":true,"masked":true,"trim":true},"display":null,"display_options":null,"readonly":false,"hidden":false,"sort":1,"width":"full","translations":null,"note":null,"conditions":null,"required":true,"group":null,"validation":null,"validation_message":null}	{"collection":"sexy_videos","field":"slug","sort":1,"group":null}	\N	\N
85	101	directus_fields	13	{"id":13,"collection":"sexy_videos","field":"status","special":null,"interface":"select-dropdown","options":{"choices":[{"text":"$t:published","value":"published","color":"var(--theme--primary)"},{"text":"$t:draft","value":"draft","color":"var(--theme--foreground)"},{"text":"$t:archived","value":"archived","color":"var(--theme--warning)"}]},"display":"labels","display_options":{"showAsDot":true,"choices":[{"text":"$t:published","value":"published","color":"var(--theme--primary)","foreground":"var(--theme--primary)","background":"var(--theme--primary-background)"},{"text":"$t:draft","value":"draft","color":"var(--theme--foreground)","foreground":"var(--theme--foreground)","background":"var(--theme--background-normal)"},{"text":"$t:archived","value":"archived","color":"var(--theme--warning)","foreground":"var(--theme--warning)","background":"var(--theme--warning-background)"}]},"readonly":false,"hidden":false,"sort":2,"width":"full","translations":null,"note":null,"conditions":null,"required":false,"group":null,"validation":null,"validation_message":null}	{"collection":"sexy_videos","field":"status","sort":2,"group":null}	\N	\N
86	102	directus_fields	14	{"id":14,"collection":"sexy_videos","field":"sort","special":null,"interface":"input","options":null,"display":null,"display_options":null,"readonly":false,"hidden":true,"sort":3,"width":"full","translations":null,"note":null,"conditions":null,"required":false,"group":null,"validation":null,"validation_message":null}	{"collection":"sexy_videos","field":"sort","sort":3,"group":null}	\N	\N
87	103	directus_fields	15	{"id":15,"collection":"sexy_videos","field":"user_created","special":["user-created"],"interface":"select-dropdown-m2o","options":{"template":"{{avatar}} {{first_name}} {{last_name}}"},"display":"user","display_options":null,"readonly":true,"hidden":true,"sort":4,"width":"half","translations":null,"note":null,"conditions":null,"required":false,"group":null,"validation":null,"validation_message":null}	{"collection":"sexy_videos","field":"user_created","sort":4,"group":null}	\N	\N
88	104	directus_fields	16	{"id":16,"collection":"sexy_videos","field":"date_created","special":["date-created"],"interface":"datetime","options":null,"display":"datetime","display_options":{"relative":true},"readonly":true,"hidden":true,"sort":5,"width":"half","translations":null,"note":null,"conditions":null,"required":false,"group":null,"validation":null,"validation_message":null}	{"collection":"sexy_videos","field":"date_created","sort":5,"group":null}	\N	\N
89	105	directus_fields	17	{"id":17,"collection":"sexy_videos","field":"date_updated","special":["date-updated"],"interface":"datetime","options":null,"display":"datetime","display_options":{"relative":true},"readonly":true,"hidden":true,"sort":6,"width":"half","translations":null,"note":null,"conditions":null,"required":false,"group":null,"validation":null,"validation_message":null}	{"collection":"sexy_videos","field":"date_updated","sort":6,"group":null}	\N	\N
90	106	directus_fields	20	{"id":20,"collection":"sexy_videos","field":"title","special":null,"interface":"input","options":null,"display":null,"display_options":null,"readonly":false,"hidden":false,"sort":7,"width":"full","translations":null,"note":null,"conditions":null,"required":true,"group":null,"validation":null,"validation_message":null}	{"collection":"sexy_videos","field":"title","sort":7,"group":null}	\N	\N
91	107	directus_fields	18	{"id":18,"collection":"sexy_videos","field":"preview","special":["file"],"interface":"file-image","options":{"folder":"c214c905-885b-4d66-a6a1-6527b0606200","enableSelect":false,"filter":{"_and":[{"width":{"_eq":"1920"}}]}},"display":null,"display_options":null,"readonly":false,"hidden":false,"sort":8,"width":"full","translations":null,"note":null,"conditions":null,"required":true,"group":null,"validation":null,"validation_message":null}	{"collection":"sexy_videos","field":"preview","sort":8,"group":null}	\N	\N
92	108	directus_fields	19	{"id":19,"collection":"sexy_videos","field":"media","special":["file"],"interface":"file","options":{"folder":"c214c905-885b-4d66-a6a1-6527b0606200","filter":{"_and":[{"type":{"_contains":"video"}}]}},"display":null,"display_options":null,"readonly":false,"hidden":false,"sort":9,"width":"full","translations":null,"note":null,"conditions":null,"required":true,"group":null,"validation":null,"validation_message":null}	{"collection":"sexy_videos","field":"media","sort":9,"group":null}	\N	\N
93	109	directus_fields	21	{"sort":10,"interface":"tags","special":["cast-json"],"collection":"sexy_videos","field":"tags"}	{"sort":10,"interface":"tags","special":["cast-json"],"collection":"sexy_videos","field":"tags"}	\N	\N
94	110	directus_fields	12	{"id":12,"collection":"sexy_videos","field":"slug","special":null,"interface":null,"options":{"slug":true,"masked":true,"trim":true},"display":null,"display_options":null,"readonly":false,"hidden":false,"sort":1,"width":"full","translations":null,"note":null,"conditions":null,"required":true,"group":null,"validation":null,"validation_message":null}	{"collection":"sexy_videos","field":"slug","sort":1,"group":null}	\N	\N
95	111	directus_fields	14	{"id":14,"collection":"sexy_videos","field":"sort","special":null,"interface":"input","options":null,"display":null,"display_options":null,"readonly":false,"hidden":true,"sort":2,"width":"full","translations":null,"note":null,"conditions":null,"required":false,"group":null,"validation":null,"validation_message":null}	{"collection":"sexy_videos","field":"sort","sort":2,"group":null}	\N	\N
96	112	directus_fields	15	{"id":15,"collection":"sexy_videos","field":"user_created","special":["user-created"],"interface":"select-dropdown-m2o","options":{"template":"{{avatar}} {{first_name}} {{last_name}}"},"display":"user","display_options":null,"readonly":true,"hidden":true,"sort":3,"width":"half","translations":null,"note":null,"conditions":null,"required":false,"group":null,"validation":null,"validation_message":null}	{"collection":"sexy_videos","field":"user_created","sort":3,"group":null}	\N	\N
97	113	directus_fields	16	{"id":16,"collection":"sexy_videos","field":"date_created","special":["date-created"],"interface":"datetime","options":null,"display":"datetime","display_options":{"relative":true},"readonly":true,"hidden":true,"sort":4,"width":"half","translations":null,"note":null,"conditions":null,"required":false,"group":null,"validation":null,"validation_message":null}	{"collection":"sexy_videos","field":"date_created","sort":4,"group":null}	\N	\N
98	114	directus_fields	17	{"id":17,"collection":"sexy_videos","field":"date_updated","special":["date-updated"],"interface":"datetime","options":null,"display":"datetime","display_options":{"relative":true},"readonly":true,"hidden":true,"sort":5,"width":"half","translations":null,"note":null,"conditions":null,"required":false,"group":null,"validation":null,"validation_message":null}	{"collection":"sexy_videos","field":"date_updated","sort":5,"group":null}	\N	\N
99	115	directus_fields	20	{"id":20,"collection":"sexy_videos","field":"title","special":null,"interface":"input","options":null,"display":null,"display_options":null,"readonly":false,"hidden":false,"sort":6,"width":"full","translations":null,"note":null,"conditions":null,"required":true,"group":null,"validation":null,"validation_message":null}	{"collection":"sexy_videos","field":"title","sort":6,"group":null}	\N	\N
100	116	directus_fields	13	{"id":13,"collection":"sexy_videos","field":"status","special":null,"interface":"select-dropdown","options":{"choices":[{"text":"$t:published","value":"published","color":"var(--theme--primary)"},{"text":"$t:draft","value":"draft","color":"var(--theme--foreground)"},{"text":"$t:archived","value":"archived","color":"var(--theme--warning)"}]},"display":"labels","display_options":{"showAsDot":true,"choices":[{"text":"$t:published","value":"published","color":"var(--theme--primary)","foreground":"var(--theme--primary)","background":"var(--theme--primary-background)"},{"text":"$t:draft","value":"draft","color":"var(--theme--foreground)","foreground":"var(--theme--foreground)","background":"var(--theme--background-normal)"},{"text":"$t:archived","value":"archived","color":"var(--theme--warning)","foreground":"var(--theme--warning)","background":"var(--theme--warning-background)"}]},"readonly":false,"hidden":false,"sort":7,"width":"full","translations":null,"note":null,"conditions":null,"required":false,"group":null,"validation":null,"validation_message":null}	{"collection":"sexy_videos","field":"status","sort":7,"group":null}	\N	\N
553	766	directus_fields	80	{"sort":1,"hidden":true,"field":"id","collection":"sexy_videos_directus_users"}	{"sort":1,"hidden":true,"field":"id","collection":"sexy_videos_directus_users"}	\N	\N
101	117	directus_fields	18	{"id":18,"collection":"sexy_videos","field":"preview","special":["file"],"interface":"file-image","options":{"folder":"c214c905-885b-4d66-a6a1-6527b0606200","enableSelect":false,"filter":{"_and":[{"width":{"_eq":"1920"}}]}},"display":null,"display_options":null,"readonly":false,"hidden":false,"sort":8,"width":"full","translations":null,"note":null,"conditions":null,"required":true,"group":null,"validation":null,"validation_message":null}	{"collection":"sexy_videos","field":"preview","sort":8,"group":null}	\N	\N
102	118	directus_fields	19	{"id":19,"collection":"sexy_videos","field":"media","special":["file"],"interface":"file","options":{"folder":"c214c905-885b-4d66-a6a1-6527b0606200","filter":{"_and":[{"type":{"_contains":"video"}}]}},"display":null,"display_options":null,"readonly":false,"hidden":false,"sort":9,"width":"full","translations":null,"note":null,"conditions":null,"required":true,"group":null,"validation":null,"validation_message":null}	{"collection":"sexy_videos","field":"media","sort":9,"group":null}	\N	\N
103	119	directus_fields	21	{"id":21,"collection":"sexy_videos","field":"tags","special":["cast-json"],"interface":"tags","options":null,"display":null,"display_options":null,"readonly":false,"hidden":false,"sort":10,"width":"full","translations":null,"note":null,"conditions":null,"required":false,"group":null,"validation":null,"validation_message":null}	{"collection":"sexy_videos","field":"tags","sort":10,"group":null}	\N	\N
104	120	directus_fields	12	{"id":12,"collection":"sexy_videos","field":"slug","special":null,"interface":"input","options":{"slug":true,"masked":true,"trim":true},"display":null,"display_options":{},"readonly":false,"hidden":false,"sort":1,"width":"full","translations":null,"note":null,"conditions":null,"required":true,"group":null,"validation":null,"validation_message":null}	{"collection":"sexy_videos","field":"slug","interface":"input","display":null,"display_options":{}}	\N	\N
105	121	directus_fields	14	{"id":14,"collection":"sexy_videos","field":"sort","special":null,"interface":"input","options":null,"display":null,"display_options":null,"readonly":false,"hidden":true,"sort":1,"width":"full","translations":null,"note":null,"conditions":null,"required":false,"group":null,"validation":null,"validation_message":null}	{"collection":"sexy_videos","field":"sort","sort":1,"group":null}	\N	\N
106	122	directus_fields	15	{"id":15,"collection":"sexy_videos","field":"user_created","special":["user-created"],"interface":"select-dropdown-m2o","options":{"template":"{{avatar}} {{first_name}} {{last_name}}"},"display":"user","display_options":null,"readonly":true,"hidden":true,"sort":2,"width":"half","translations":null,"note":null,"conditions":null,"required":false,"group":null,"validation":null,"validation_message":null}	{"collection":"sexy_videos","field":"user_created","sort":2,"group":null}	\N	\N
107	123	directus_fields	16	{"id":16,"collection":"sexy_videos","field":"date_created","special":["date-created"],"interface":"datetime","options":null,"display":"datetime","display_options":{"relative":true},"readonly":true,"hidden":true,"sort":3,"width":"half","translations":null,"note":null,"conditions":null,"required":false,"group":null,"validation":null,"validation_message":null}	{"collection":"sexy_videos","field":"date_created","sort":3,"group":null}	\N	\N
108	124	directus_fields	17	{"id":17,"collection":"sexy_videos","field":"date_updated","special":["date-updated"],"interface":"datetime","options":null,"display":"datetime","display_options":{"relative":true},"readonly":true,"hidden":true,"sort":4,"width":"half","translations":null,"note":null,"conditions":null,"required":false,"group":null,"validation":null,"validation_message":null}	{"collection":"sexy_videos","field":"date_updated","sort":4,"group":null}	\N	\N
109	125	directus_fields	20	{"id":20,"collection":"sexy_videos","field":"title","special":null,"interface":"input","options":null,"display":null,"display_options":null,"readonly":false,"hidden":false,"sort":5,"width":"full","translations":null,"note":null,"conditions":null,"required":true,"group":null,"validation":null,"validation_message":null}	{"collection":"sexy_videos","field":"title","sort":5,"group":null}	\N	\N
110	126	directus_fields	12	{"id":12,"collection":"sexy_videos","field":"slug","special":null,"interface":"input","options":{"slug":true,"masked":true,"trim":true},"display":null,"display_options":{},"readonly":false,"hidden":false,"sort":6,"width":"full","translations":null,"note":null,"conditions":null,"required":true,"group":null,"validation":null,"validation_message":null}	{"collection":"sexy_videos","field":"slug","sort":6,"group":null}	\N	\N
111	127	directus_fields	13	{"id":13,"collection":"sexy_videos","field":"status","special":null,"interface":"select-dropdown","options":{"choices":[{"text":"$t:published","value":"published","color":"var(--theme--primary)"},{"text":"$t:draft","value":"draft","color":"var(--theme--foreground)"},{"text":"$t:archived","value":"archived","color":"var(--theme--warning)"}]},"display":"labels","display_options":{"showAsDot":true,"choices":[{"text":"$t:published","value":"published","color":"var(--theme--primary)","foreground":"var(--theme--primary)","background":"var(--theme--primary-background)"},{"text":"$t:draft","value":"draft","color":"var(--theme--foreground)","foreground":"var(--theme--foreground)","background":"var(--theme--background-normal)"},{"text":"$t:archived","value":"archived","color":"var(--theme--warning)","foreground":"var(--theme--warning)","background":"var(--theme--warning-background)"}]},"readonly":false,"hidden":false,"sort":7,"width":"full","translations":null,"note":null,"conditions":null,"required":false,"group":null,"validation":null,"validation_message":null}	{"collection":"sexy_videos","field":"status","sort":7,"group":null}	\N	\N
112	128	directus_fields	18	{"id":18,"collection":"sexy_videos","field":"preview","special":["file"],"interface":"file-image","options":{"folder":"c214c905-885b-4d66-a6a1-6527b0606200","enableSelect":false,"filter":{"_and":[{"width":{"_eq":"1920"}}]}},"display":null,"display_options":null,"readonly":false,"hidden":false,"sort":8,"width":"full","translations":null,"note":null,"conditions":null,"required":true,"group":null,"validation":null,"validation_message":null}	{"collection":"sexy_videos","field":"preview","sort":8,"group":null}	\N	\N
113	129	directus_fields	19	{"id":19,"collection":"sexy_videos","field":"media","special":["file"],"interface":"file","options":{"folder":"c214c905-885b-4d66-a6a1-6527b0606200","filter":{"_and":[{"type":{"_contains":"video"}}]}},"display":null,"display_options":null,"readonly":false,"hidden":false,"sort":9,"width":"full","translations":null,"note":null,"conditions":null,"required":true,"group":null,"validation":null,"validation_message":null}	{"collection":"sexy_videos","field":"media","sort":9,"group":null}	\N	\N
114	130	directus_fields	21	{"id":21,"collection":"sexy_videos","field":"tags","special":["cast-json"],"interface":"tags","options":null,"display":null,"display_options":null,"readonly":false,"hidden":false,"sort":10,"width":"full","translations":null,"note":null,"conditions":null,"required":false,"group":null,"validation":null,"validation_message":null}	{"collection":"sexy_videos","field":"tags","sort":10,"group":null}	\N	\N
143	163	directus_fields	31	{"sort":8,"interface":"input-multiline","special":null,"required":true,"options":{"trim":true},"collection":"sexy_articles","field":"excerpt"}	{"sort":8,"interface":"input-multiline","special":null,"required":true,"options":{"trim":true},"collection":"sexy_articles","field":"excerpt"}	\N	\N
115	131	directus_fields	22	{"sort":11,"interface":"input-rich-text-md","special":null,"required":true,"options":{"folder":"c214c905-885b-4d66-a6a1-6527b0606200"},"collection":"sexy_videos","field":"description"}	{"sort":11,"interface":"input-rich-text-md","special":null,"required":true,"options":{"folder":"c214c905-885b-4d66-a6a1-6527b0606200"},"collection":"sexy_videos","field":"description"}	\N	\N
116	132	directus_fields	14	{"id":14,"collection":"sexy_videos","field":"sort","special":null,"interface":"input","options":null,"display":null,"display_options":null,"readonly":false,"hidden":true,"sort":1,"width":"full","translations":null,"note":null,"conditions":null,"required":false,"group":null,"validation":null,"validation_message":null}	{"collection":"sexy_videos","field":"sort","sort":1,"group":null}	\N	\N
117	133	directus_fields	15	{"id":15,"collection":"sexy_videos","field":"user_created","special":["user-created"],"interface":"select-dropdown-m2o","options":{"template":"{{avatar}} {{first_name}} {{last_name}}"},"display":"user","display_options":null,"readonly":true,"hidden":true,"sort":2,"width":"half","translations":null,"note":null,"conditions":null,"required":false,"group":null,"validation":null,"validation_message":null}	{"collection":"sexy_videos","field":"user_created","sort":2,"group":null}	\N	\N
118	134	directus_fields	16	{"id":16,"collection":"sexy_videos","field":"date_created","special":["date-created"],"interface":"datetime","options":null,"display":"datetime","display_options":{"relative":true},"readonly":true,"hidden":true,"sort":3,"width":"half","translations":null,"note":null,"conditions":null,"required":false,"group":null,"validation":null,"validation_message":null}	{"collection":"sexy_videos","field":"date_created","sort":3,"group":null}	\N	\N
119	135	directus_fields	17	{"id":17,"collection":"sexy_videos","field":"date_updated","special":["date-updated"],"interface":"datetime","options":null,"display":"datetime","display_options":{"relative":true},"readonly":true,"hidden":true,"sort":4,"width":"half","translations":null,"note":null,"conditions":null,"required":false,"group":null,"validation":null,"validation_message":null}	{"collection":"sexy_videos","field":"date_updated","sort":4,"group":null}	\N	\N
120	136	directus_fields	20	{"id":20,"collection":"sexy_videos","field":"title","special":null,"interface":"input","options":null,"display":null,"display_options":null,"readonly":false,"hidden":false,"sort":5,"width":"full","translations":null,"note":null,"conditions":null,"required":true,"group":null,"validation":null,"validation_message":null}	{"collection":"sexy_videos","field":"title","sort":5,"group":null}	\N	\N
121	137	directus_fields	12	{"id":12,"collection":"sexy_videos","field":"slug","special":null,"interface":"input","options":{"slug":true,"masked":true,"trim":true},"display":null,"display_options":{},"readonly":false,"hidden":false,"sort":6,"width":"full","translations":null,"note":null,"conditions":null,"required":true,"group":null,"validation":null,"validation_message":null}	{"collection":"sexy_videos","field":"slug","sort":6,"group":null}	\N	\N
122	138	directus_fields	13	{"id":13,"collection":"sexy_videos","field":"status","special":null,"interface":"select-dropdown","options":{"choices":[{"text":"$t:published","value":"published","color":"var(--theme--primary)"},{"text":"$t:draft","value":"draft","color":"var(--theme--foreground)"},{"text":"$t:archived","value":"archived","color":"var(--theme--warning)"}]},"display":"labels","display_options":{"showAsDot":true,"choices":[{"text":"$t:published","value":"published","color":"var(--theme--primary)","foreground":"var(--theme--primary)","background":"var(--theme--primary-background)"},{"text":"$t:draft","value":"draft","color":"var(--theme--foreground)","foreground":"var(--theme--foreground)","background":"var(--theme--background-normal)"},{"text":"$t:archived","value":"archived","color":"var(--theme--warning)","foreground":"var(--theme--warning)","background":"var(--theme--warning-background)"}]},"readonly":false,"hidden":false,"sort":7,"width":"full","translations":null,"note":null,"conditions":null,"required":false,"group":null,"validation":null,"validation_message":null}	{"collection":"sexy_videos","field":"status","sort":7,"group":null}	\N	\N
123	139	directus_fields	18	{"id":18,"collection":"sexy_videos","field":"preview","special":["file"],"interface":"file-image","options":{"folder":"c214c905-885b-4d66-a6a1-6527b0606200","enableSelect":false,"filter":{"_and":[{"width":{"_eq":"1920"}}]}},"display":null,"display_options":null,"readonly":false,"hidden":false,"sort":8,"width":"full","translations":null,"note":null,"conditions":null,"required":true,"group":null,"validation":null,"validation_message":null}	{"collection":"sexy_videos","field":"preview","sort":8,"group":null}	\N	\N
124	140	directus_fields	19	{"id":19,"collection":"sexy_videos","field":"media","special":["file"],"interface":"file","options":{"folder":"c214c905-885b-4d66-a6a1-6527b0606200","filter":{"_and":[{"type":{"_contains":"video"}}]}},"display":null,"display_options":null,"readonly":false,"hidden":false,"sort":9,"width":"full","translations":null,"note":null,"conditions":null,"required":true,"group":null,"validation":null,"validation_message":null}	{"collection":"sexy_videos","field":"media","sort":9,"group":null}	\N	\N
125	141	directus_fields	22	{"id":22,"collection":"sexy_videos","field":"description","special":null,"interface":"input-rich-text-md","options":{"folder":"c214c905-885b-4d66-a6a1-6527b0606200"},"display":null,"display_options":null,"readonly":false,"hidden":false,"sort":10,"width":"full","translations":null,"note":null,"conditions":null,"required":true,"group":null,"validation":null,"validation_message":null}	{"collection":"sexy_videos","field":"description","sort":10,"group":null}	\N	\N
126	142	directus_fields	21	{"id":21,"collection":"sexy_videos","field":"tags","special":["cast-json"],"interface":"tags","options":null,"display":null,"display_options":null,"readonly":false,"hidden":false,"sort":11,"width":"full","translations":null,"note":null,"conditions":null,"required":false,"group":null,"validation":null,"validation_message":null}	{"collection":"sexy_videos","field":"tags","sort":11,"group":null}	\N	\N
127	143	directus_flows	35c3047d-fcdc-43a5-a58d-a34ce17f32f0	{"id":"35c3047d-fcdc-43a5-a58d-a34ce17f32f0","name":"Register User","icon":"bolt","color":null,"description":null,"status":"inactive","trigger":"event","accountability":"all","options":{"type":"filter","return":"$all","scope":["auth.create","items.create"],"collections":["directus_roles","directus_users"]},"operation":"6d4e66b9-7474-4b10-8926-30eb97beeefc","date_created":"2025-09-06T08:36:20.768Z","user_created":"4d310101-f7b1-47fe-982a-efe4abf25c55","operations":["6d4e66b9-7474-4b10-8926-30eb97beeefc"]}	{"name":"Register User","icon":"bolt","color":null,"description":null,"status":"inactive","trigger":"event","accountability":"all","options":{"type":"filter","return":"$all","scope":["auth.create","items.create"],"collections":["directus_roles","directus_users"]}}	\N	\N
141	161	directus_fields	29	{"id":29,"collection":"sexy_articles","field":"slug","special":null,"interface":"input","options":{"slug":true},"display":null,"display_options":null,"readonly":false,"hidden":false,"sort":6,"width":"full","translations":null,"note":null,"conditions":null,"required":true,"group":null,"validation":null,"validation_message":null}	{"collection":"sexy_articles","field":"slug","interface":"input","options":{"slug":true}}	\N	\N
128	147	directus_users	4d310101-f7b1-47fe-982a-efe4abf25c55	{"id":"4d310101-f7b1-47fe-982a-efe4abf25c55","first_name":"Sebastian","last_name":"Krüger","email":"admin@pivoine.art","password":"**********","location":null,"title":null,"description":null,"tags":null,"avatar":null,"language":null,"tfa_secret":null,"status":"active","role":"ea3a9127-2b65-462c-85a8-dbafe9b4fe24","token":null,"last_access":"2025-09-08T19:25:45.859Z","last_page":"/users/4d310101-f7b1-47fe-982a-efe4abf25c55","provider":"default","external_identifier":null,"auth_data":null,"email_notifications":true,"appearance":null,"theme_dark":null,"theme_light":null,"theme_light_overrides":null,"theme_dark_overrides":null,"text_direction":"auto","policies":[]}	{"first_name":"Sebastian","last_name":"Krüger","email":"admin@pivoine.art","password":"**********"}	\N	\N
129	148	directus_files	99c47c3d-4865-4361-a545-f38e54fccb0b	{"title":"Sebastian","filename_download":"sebastian.jpg","type":"image/jpeg","storage":"local","folder":"c214c905-885b-4d66-a6a1-6527b0606200"}	{"title":"Sebastian","filename_download":"sebastian.jpg","type":"image/jpeg","storage":"local","folder":"c214c905-885b-4d66-a6a1-6527b0606200"}	\N	\N
130	149	directus_users	4d310101-f7b1-47fe-982a-efe4abf25c55	{"id":"4d310101-f7b1-47fe-982a-efe4abf25c55","first_name":"Sebastian","last_name":"Krüger","email":"admin@pivoine.art","password":"**********","location":null,"title":null,"description":null,"tags":null,"avatar":"99c47c3d-4865-4361-a545-f38e54fccb0b","language":null,"tfa_secret":null,"status":"active","role":"ea3a9127-2b65-462c-85a8-dbafe9b4fe24","token":null,"last_access":"2025-09-08T19:25:45.859Z","last_page":"/users/4d310101-f7b1-47fe-982a-efe4abf25c55","provider":"default","external_identifier":null,"auth_data":null,"email_notifications":true,"appearance":null,"theme_dark":null,"theme_light":null,"theme_light_overrides":null,"theme_dark_overrides":null,"text_direction":"auto","policies":[]}	{"avatar":"99c47c3d-4865-4361-a545-f38e54fccb0b"}	\N	\N
131	150	directus_folders	c214c905-885b-4d66-a6a1-6527b0606200	{"id":"c214c905-885b-4d66-a6a1-6527b0606200","name":"sexy","parent":null}	{"name":"sexy"}	\N	\N
132	151	directus_settings	1	{"id":1,"project_name":"Sexy.Art","project_url":"https://sexy.pivoine.art","project_color":"#6644FF","project_logo":"8ad7e858-0c83-4d88-bb50-3680f1cfa9c2","public_foreground":null,"public_background":null,"public_note":"Where Love Meets Artistry","auth_login_attempts":25,"auth_password_policy":"/(?=^.{8,}$)(?=.*\\\\d)(?=.*[a-z])(?=.*[A-Z])(?=.*[!@#$%^&*()_+}{';'?>.<,])(?!.*\\\\s).*$/","storage_asset_transform":"presets","storage_asset_presets":[{"key":"sexy-video-thumbnail","fit":"cover","width":600,"height":null,"quality":80,"withoutEnlargement":true,"format":"webp","transforms":[]},{"key":"sexy-video-banner","fit":"cover","width":1920,"quality":80,"withoutEnlargement":false,"format":"webp","transforms":[]},{"key":"sexy-video-preview","fit":"cover","width":1080,"quality":80,"withoutEnlargement":true,"format":"webp","transforms":[]}],"custom_css":null,"storage_default_folder":"c214c905-885b-4d66-a6a1-6527b0606200","basemaps":null,"mapbox_key":null,"module_bar":[{"type":"module","id":"content","enabled":true},{"type":"module","id":"visual","enabled":false},{"type":"module","id":"users","enabled":true},{"type":"module","id":"files","enabled":true},{"type":"module","id":"insights","enabled":true},{"type":"link","id":"docs","enabled":true,"name":"$t:documentation","icon":"help","url":"https://docs.directus.io"},{"type":"module","id":"settings","enabled":true,"locked":true},{"id":"JpYiQQKgf-i3unxAY1efo","type":"link","enabled":true,"url":"/files/sexy","name":"Sexy Videos","icon":"videocam"}],"project_descriptor":null,"default_language":"en-US","custom_aspect_ratios":null,"public_favicon":null,"default_appearance":"auto","default_theme_light":null,"theme_light_overrides":null,"default_theme_dark":null,"theme_dark_overrides":null,"report_error_url":null,"report_bug_url":null,"report_feature_url":null,"public_registration":true,"public_registration_verify_email":true,"public_registration_role":"a1300aaa-0205-47d8-97a7-6166ac924e50","public_registration_email_filter":null,"visual_editor_urls":null,"accepted_terms":true,"project_id":"01991b80-eceb-7715-aebb-b0b1fbf67973"}	{"module_bar":[{"type":"module","id":"content","enabled":true},{"type":"module","id":"visual","enabled":false},{"type":"module","id":"users","enabled":true},{"type":"module","id":"files","enabled":true},{"type":"module","id":"insights","enabled":true},{"type":"link","id":"docs","enabled":true,"name":"$t:documentation","icon":"help","url":"https://docs.directus.io"},{"type":"module","id":"settings","enabled":true,"locked":true},{"id":"JpYiQQKgf-i3unxAY1efo","type":"link","enabled":true,"url":"/files/sexy","name":"Sexy Videos","icon":"videocam"}]}	\N	\N
133	152	directus_fields	23	{"sort":1,"hidden":true,"readonly":true,"interface":"input","special":["uuid"],"field":"id","collection":"sexy_articles"}	{"sort":1,"hidden":true,"readonly":true,"interface":"input","special":["uuid"],"field":"id","collection":"sexy_articles"}	\N	\N
134	153	directus_fields	24	{"sort":2,"width":"full","options":{"choices":[{"text":"$t:published","value":"published","color":"var(--theme--primary)"},{"text":"$t:draft","value":"draft","color":"var(--theme--foreground)"},{"text":"$t:archived","value":"archived","color":"var(--theme--warning)"}]},"interface":"select-dropdown","display":"labels","display_options":{"showAsDot":true,"choices":[{"text":"$t:published","value":"published","color":"var(--theme--primary)","foreground":"var(--theme--primary)","background":"var(--theme--primary-background)"},{"text":"$t:draft","value":"draft","color":"var(--theme--foreground)","foreground":"var(--theme--foreground)","background":"var(--theme--background-normal)"},{"text":"$t:archived","value":"archived","color":"var(--theme--warning)","foreground":"var(--theme--warning)","background":"var(--theme--warning-background)"}]},"field":"status","collection":"sexy_articles"}	{"sort":2,"width":"full","options":{"choices":[{"text":"$t:published","value":"published","color":"var(--theme--primary)"},{"text":"$t:draft","value":"draft","color":"var(--theme--foreground)"},{"text":"$t:archived","value":"archived","color":"var(--theme--warning)"}]},"interface":"select-dropdown","display":"labels","display_options":{"showAsDot":true,"choices":[{"text":"$t:published","value":"published","color":"var(--theme--primary)","foreground":"var(--theme--primary)","background":"var(--theme--primary-background)"},{"text":"$t:draft","value":"draft","color":"var(--theme--foreground)","foreground":"var(--theme--foreground)","background":"var(--theme--background-normal)"},{"text":"$t:archived","value":"archived","color":"var(--theme--warning)","foreground":"var(--theme--warning)","background":"var(--theme--warning-background)"}]},"field":"status","collection":"sexy_articles"}	\N	\N
135	154	directus_fields	25	{"sort":3,"special":["user-created"],"interface":"select-dropdown-m2o","options":{"template":"{{avatar}} {{first_name}} {{last_name}}"},"display":"user","readonly":true,"hidden":true,"width":"half","field":"user_created","collection":"sexy_articles"}	{"sort":3,"special":["user-created"],"interface":"select-dropdown-m2o","options":{"template":"{{avatar}} {{first_name}} {{last_name}}"},"display":"user","readonly":true,"hidden":true,"width":"half","field":"user_created","collection":"sexy_articles"}	\N	\N
136	155	directus_fields	26	{"sort":4,"special":["date-created"],"interface":"datetime","readonly":true,"hidden":true,"width":"half","display":"datetime","display_options":{"relative":true},"field":"date_created","collection":"sexy_articles"}	{"sort":4,"special":["date-created"],"interface":"datetime","readonly":true,"hidden":true,"width":"half","display":"datetime","display_options":{"relative":true},"field":"date_created","collection":"sexy_articles"}	\N	\N
137	156	directus_fields	27	{"sort":5,"special":["date-updated"],"interface":"datetime","readonly":true,"hidden":true,"width":"half","display":"datetime","display_options":{"relative":true},"field":"date_updated","collection":"sexy_articles"}	{"sort":5,"special":["date-updated"],"interface":"datetime","readonly":true,"hidden":true,"width":"half","display":"datetime","display_options":{"relative":true},"field":"date_updated","collection":"sexy_articles"}	\N	\N
139	158	directus_fields	28	{"sort":6,"interface":"input","special":null,"required":true,"collection":"sexy_articles","field":"slu"}	{"sort":6,"interface":"input","special":null,"required":true,"collection":"sexy_articles","field":"slu"}	\N	\N
144	164	directus_fields	32	{"sort":9,"interface":"input-rich-text-html","special":null,"required":true,"options":{"toolbar":["bold","italic","underline","h1","h2","h3","numlist","bullist","removeformat","blockquote","customLink","hr","fullscreen","code"],"folder":"c214c905-885b-4d66-a6a1-6527b0606200"},"collection":"sexy_articles","field":"content"}	{"sort":9,"interface":"input-rich-text-html","special":null,"required":true,"options":{"toolbar":["bold","italic","underline","h1","h2","h3","numlist","bullist","removeformat","blockquote","customLink","hr","fullscreen","code"],"folder":"c214c905-885b-4d66-a6a1-6527b0606200"},"collection":"sexy_articles","field":"content"}	\N	\N
145	165	directus_fields	32	{"id":32,"collection":"sexy_articles","field":"content","special":null,"interface":"input-rich-text-html","options":{"toolbar":["bold","italic","underline","h2","h3","numlist","bullist","removeformat","blockquote","customLink","hr","fullscreen","code"],"folder":"c214c905-885b-4d66-a6a1-6527b0606200"},"display":null,"display_options":null,"readonly":false,"hidden":false,"sort":9,"width":"full","translations":null,"note":null,"conditions":null,"required":true,"group":null,"validation":null,"validation_message":null}	{"collection":"sexy_articles","field":"content","options":{"toolbar":["bold","italic","underline","h2","h3","numlist","bullist","removeformat","blockquote","customLink","hr","fullscreen","code"],"folder":"c214c905-885b-4d66-a6a1-6527b0606200"}}	\N	\N
146	166	directus_folders	452680cc-8e19-4352-a943-21520d3f3621	{"name":"articles","parent":"c214c905-885b-4d66-a6a1-6527b0606200"}	{"name":"articles","parent":"c214c905-885b-4d66-a6a1-6527b0606200"}	\N	\N
147	167	directus_fields	33	{"sort":10,"interface":"file-image","special":["file"],"required":true,"options":{"folder":"c214c905-885b-4d66-a6a1-6527b0606200"},"collection":"sexy_articles","field":"image"}	{"sort":10,"interface":"file-image","special":["file"],"required":true,"options":{"folder":"c214c905-885b-4d66-a6a1-6527b0606200"},"collection":"sexy_articles","field":"image"}	\N	\N
148	168	directus_fields	33	{"id":33,"collection":"sexy_articles","field":"image","special":["file"],"interface":"file-image","options":{"folder":"452680cc-8e19-4352-a943-21520d3f3621"},"display":null,"display_options":null,"readonly":false,"hidden":false,"sort":10,"width":"full","translations":null,"note":null,"conditions":null,"required":true,"group":null,"validation":null,"validation_message":null}	{"collection":"sexy_articles","field":"image","options":{"folder":"452680cc-8e19-4352-a943-21520d3f3621"}}	\N	\N
149	169	directus_fields	34	{"sort":11,"interface":"tags","special":["cast-json"],"options":{"capitalization":"auto-format","whitespace":"_"},"collection":"sexy_articles","field":"tags"}	{"sort":11,"interface":"tags","special":["cast-json"],"options":{"capitalization":"auto-format","whitespace":"_"},"collection":"sexy_articles","field":"tags"}	\N	\N
150	170	directus_fields	35	{"sort":12,"interface":"datetime","special":null,"required":true,"collection":"sexy_articles","field":"publish_date"}	{"sort":12,"interface":"datetime","special":null,"required":true,"collection":"sexy_articles","field":"publish_date"}	\N	\N
151	171	directus_fields	36	{"sort":13,"interface":"input","special":null,"required":true,"collection":"sexy_articles","field":"category"}	{"sort":13,"interface":"input","special":null,"required":true,"collection":"sexy_articles","field":"category"}	\N	\N
152	172	directus_fields	37	{"sort":14,"interface":"boolean","special":["cast-boolean"],"options":{"label":"Featured"},"collection":"sexy_articles","field":"featured"}	{"sort":14,"interface":"boolean","special":["cast-boolean"],"options":{"label":"Featured"},"collection":"sexy_articles","field":"featured"}	\N	\N
153	173	directus_collections	sexy_articles	{"collection":"sexy_articles","icon":null,"note":null,"display_template":null,"hidden":false,"singleton":false,"translations":[{"language":"en-US","translation":"Sexy Articles","singular":"Article","plural":"Articles"}],"archive_field":"status","archive_app_filter":true,"archive_value":"archived","unarchive_value":"draft","sort_field":null,"accountability":"all","color":null,"item_duplication_fields":null,"sort":null,"group":null,"collapse":"open","preview_url":null,"versioning":true}	{"translations":[{"language":"en-US","translation":"Sexy Articles","singular":"Article","plural":"Articles"}],"versioning":true}	\N	\N
154	174	directus_files	f718185e-fd82-4f16-971d-88baf2d069de	{"folder":"452680cc-8e19-4352-a943-21520d3f3621","title":"Babe","filename_download":"babe.webp","type":"image/webp","storage":"local"}	{"folder":"452680cc-8e19-4352-a943-21520d3f3621","title":"Babe","filename_download":"babe.webp","type":"image/webp","storage":"local"}	\N	\N
155	175	sexy_articles	327b53b3-1a3b-4859-bcc6-2e831e3d9b62	{"status":"published","title":"Model Spotlight: Luna Belle's Creative Journey","slug":"model-spotlight-luna-belle","excerpt":"Discover how Luna Belle combines artistic vision with intimate expression to create captivating content.","content":"<p>Intimate photography is more than just capturing moments&mdash;it's about telling stories of love, connection, and vulnerability through the lens. In this comprehensive guide, we'll explore the artistic and technical aspects that make intimate photography truly captivating.</p>\\n<h2>Understanding the Art Form</h2>\\n<p>Intimate photography requires a delicate balance between technical skill and emotional intelligence. The photographer must create an environment where subjects feel comfortable, safe, and free to express their authentic selves.</p>\\n<p>The key to successful intimate photography lies in building trust with your subjects. This trust allows for genuine moments of vulnerability and connection that translate beautifully through the camera.</p>\\n<h2>Technical Considerations</h2>\\n<p>While the emotional aspect is crucial, technical proficiency cannot be overlooked. Here are some essential technical considerations:</p>\\n<h3>Lighting</h3>\\n<p>Natural light is often the most flattering for intimate photography. Golden hour provides warm, soft light that enhances skin tones and creates a romantic atmosphere. When shooting indoors, large windows provide beautiful, diffused light.</p>\\n<h3>Composition</h3>\\n<p>Composition in intimate photography should guide the viewer's eye to the emotional core of the image. Use leading lines, framing, and negative space to create visual interest while maintaining focus on the connection between subjects.</p>\\n<h2>Creating the Right Environment</h2>\\n<p>The environment plays a crucial role in intimate photography. Whether shooting in a studio, bedroom, or outdoor location, the space should feel safe and comfortable for your subjects.</p>\\n<p>Consider the following when preparing your shooting environment:</p>\\n<ul>\\n<li>Ensure privacy and minimize distractions</li>\\n<li>Maintain comfortable temperature</li>\\n<li>Have robes or coverings readily available</li>\\n<li>Play soft, ambient music to help subjects relax</li>\\n</ul>\\n<h2>Posing and Direction</h2>\\n<p>Posing for intimate photography should feel natural and unforced. Instead of rigid poses, encourage movement and interaction between subjects. Guide them through emotions rather than specific positions.</p>\\n<p>Some effective directing techniques include:</p>\\n<ul>\\n<li>Ask subjects to whisper something sweet to each other</li>\\n<li>Encourage gentle touches and caresses</li>\\n<li>Capture moments between poses</li>\\n<li>Focus on hands, eyes, and subtle expressions</li>\\n</ul>\\n<h2>Post-Processing for Intimate Photography</h2>\\n<p>Post-processing should enhance the mood and emotion of your intimate photographs without overwhelming the natural beauty of the moment. Subtle adjustments to exposure, contrast, and color grading can significantly impact the final result.</p>\\n<p>Consider these post-processing tips:</p>\\n<ul>\\n<li>Maintain natural skin tones</li>\\n<li>Use subtle vignetting to draw focus</li>\\n<li>Enhance the warmth of the lighting</li>\\n<li>Remove distracting elements carefully</li>\\n</ul>\\n<h2>Conclusion</h2>\\n<p>Intimate photography is a beautiful art form that celebrates human connection and vulnerability. By combining technical skill with emotional intelligence, photographers can create images that not only capture moments but also tell powerful stories of love and intimacy.</p>\\n<p>Remember, the most important aspect of intimate photography is respect&mdash;for your subjects, for the art form, and for the trust that has been placed in you as the photographer.</p>","image":"f718185e-fd82-4f16-971d-88baf2d069de","tags":["Creativity","Journey"],"publish_date":"2025-09-04T12:00:00","category":"Spotlight","featured":true}	{"status":"published","title":"Model Spotlight: Luna Belle's Creative Journey","slug":"model-spotlight-luna-belle","excerpt":"Discover how Luna Belle combines artistic vision with intimate expression to create captivating content.","content":"<p>Intimate photography is more than just capturing moments&mdash;it's about telling stories of love, connection, and vulnerability through the lens. In this comprehensive guide, we'll explore the artistic and technical aspects that make intimate photography truly captivating.</p>\\n<h2>Understanding the Art Form</h2>\\n<p>Intimate photography requires a delicate balance between technical skill and emotional intelligence. The photographer must create an environment where subjects feel comfortable, safe, and free to express their authentic selves.</p>\\n<p>The key to successful intimate photography lies in building trust with your subjects. This trust allows for genuine moments of vulnerability and connection that translate beautifully through the camera.</p>\\n<h2>Technical Considerations</h2>\\n<p>While the emotional aspect is crucial, technical proficiency cannot be overlooked. Here are some essential technical considerations:</p>\\n<h3>Lighting</h3>\\n<p>Natural light is often the most flattering for intimate photography. Golden hour provides warm, soft light that enhances skin tones and creates a romantic atmosphere. When shooting indoors, large windows provide beautiful, diffused light.</p>\\n<h3>Composition</h3>\\n<p>Composition in intimate photography should guide the viewer's eye to the emotional core of the image. Use leading lines, framing, and negative space to create visual interest while maintaining focus on the connection between subjects.</p>\\n<h2>Creating the Right Environment</h2>\\n<p>The environment plays a crucial role in intimate photography. Whether shooting in a studio, bedroom, or outdoor location, the space should feel safe and comfortable for your subjects.</p>\\n<p>Consider the following when preparing your shooting environment:</p>\\n<ul>\\n<li>Ensure privacy and minimize distractions</li>\\n<li>Maintain comfortable temperature</li>\\n<li>Have robes or coverings readily available</li>\\n<li>Play soft, ambient music to help subjects relax</li>\\n</ul>\\n<h2>Posing and Direction</h2>\\n<p>Posing for intimate photography should feel natural and unforced. Instead of rigid poses, encourage movement and interaction between subjects. Guide them through emotions rather than specific positions.</p>\\n<p>Some effective directing techniques include:</p>\\n<ul>\\n<li>Ask subjects to whisper something sweet to each other</li>\\n<li>Encourage gentle touches and caresses</li>\\n<li>Capture moments between poses</li>\\n<li>Focus on hands, eyes, and subtle expressions</li>\\n</ul>\\n<h2>Post-Processing for Intimate Photography</h2>\\n<p>Post-processing should enhance the mood and emotion of your intimate photographs without overwhelming the natural beauty of the moment. Subtle adjustments to exposure, contrast, and color grading can significantly impact the final result.</p>\\n<p>Consider these post-processing tips:</p>\\n<ul>\\n<li>Maintain natural skin tones</li>\\n<li>Use subtle vignetting to draw focus</li>\\n<li>Enhance the warmth of the lighting</li>\\n<li>Remove distracting elements carefully</li>\\n</ul>\\n<h2>Conclusion</h2>\\n<p>Intimate photography is a beautiful art form that celebrates human connection and vulnerability. By combining technical skill with emotional intelligence, photographers can create images that not only capture moments but also tell powerful stories of love and intimacy.</p>\\n<p>Remember, the most important aspect of intimate photography is respect&mdash;for your subjects, for the art form, and for the trust that has been placed in you as the photographer.</p>","image":"f718185e-fd82-4f16-971d-88baf2d069de","tags":["Creativity","Journey"],"publish_date":"2025-09-04T12:00:00","category":"Spotlight","featured":true}	\N	\N
156	176	directus_permissions	27	{"policy":"abf8a154-5b1c-4a46-ac9c-7300570f4f17","permissions":null,"validation":null,"fields":["*"],"presets":null,"collection":"sexy_articles","action":"read"}	{"policy":"abf8a154-5b1c-4a46-ac9c-7300570f4f17","permissions":null,"validation":null,"fields":["*"],"presets":null,"collection":"sexy_articles","action":"read"}	\N	\N
157	178	directus_permissions	28	{"policy":"abf8a154-5b1c-4a46-ac9c-7300570f4f17","permissions":null,"validation":null,"fields":["*"],"presets":null,"collection":"directus_users","action":"read"}	{"policy":"abf8a154-5b1c-4a46-ac9c-7300570f4f17","permissions":null,"validation":null,"fields":["*"],"presets":null,"collection":"directus_users","action":"read"}	\N	\N
158	180	directus_permissions	28	{"id":28,"collection":"directus_users","action":"read","permissions":null,"validation":null,"presets":null,"fields":["first_name","last_name","description","tags","avatar","title","location"],"policy":"abf8a154-5b1c-4a46-ac9c-7300570f4f17"}	{"collection":"directus_users","action":"read","permissions":null,"validation":null,"presets":null,"fields":["first_name","last_name","description","tags","avatar","title","location"],"policy":"abf8a154-5b1c-4a46-ac9c-7300570f4f17"}	\N	\N
159	182	sexy_articles	327b53b3-1a3b-4859-bcc6-2e831e3d9b62	{"id":"327b53b3-1a3b-4859-bcc6-2e831e3d9b62","status":"published","user_created":"4d310101-f7b1-47fe-982a-efe4abf25c55","date_created":"2025-09-08T19:51:34.582Z","date_updated":"2025-09-08T20:51:27.311Z","slug":"model-spotlight-luna-belle","title":"Model Spotlight: Luna Belle's Creative Journey","excerpt":"Discover how Luna Belle combines artistic vision with intimate expression to create captivating content.","content":"<p>Intimate photography is more than just capturing moments&mdash;it's about telling stories of love, connection, and vulnerability through the lens. In this comprehensive guide, we'll explore the artistic and technical aspects that make intimate photography truly captivating.</p>\\n<h2>Understanding the Art Form</h2>\\n<p>Intimate photography requires a delicate balance between technical skill and emotional intelligence. The photographer must create an environment where subjects feel comfortable, safe, and free to express their authentic selves.</p>\\n<p>The key to successful intimate photography lies in building trust with your subjects. This trust allows for genuine moments of vulnerability and connection that translate beautifully through the camera.</p>\\n<h2>Technical Considerations</h2>\\n<p>While the emotional aspect is crucial, technical proficiency cannot be overlooked. Here are some essential technical considerations:</p>\\n<h3>Lighting</h3>\\n<p>Natural light is often the most flattering for intimate photography. Golden hour provides warm, soft light that enhances skin tones and creates a romantic atmosphere. When shooting indoors, large windows provide beautiful, diffused light.</p>\\n<h3>Composition</h3>\\n<p>Composition in intimate photography should guide the viewer's eye to the emotional core of the image. Use leading lines, framing, and negative space to create visual interest while maintaining focus on the connection between subjects.</p>\\n<h2>Creating the Right Environment</h2>\\n<p>The environment plays a crucial role in intimate photography. Whether shooting in a studio, bedroom, or outdoor location, the space should feel safe and comfortable for your subjects.</p>\\n<p>Consider the following when preparing your shooting environment:</p>\\n<ul>\\n<li>Ensure privacy and minimize distractions</li>\\n<li>Maintain comfortable temperature</li>\\n<li>Have robes or coverings readily available</li>\\n<li>Play soft, ambient music to help subjects relax</li>\\n</ul>\\n<h2>Posing and Direction</h2>\\n<p>Posing for intimate photography should feel natural and unforced. Instead of rigid poses, encourage movement and interaction between subjects. Guide them through emotions rather than specific positions.</p>\\n<p>Some effective directing techniques include:</p>\\n<ul>\\n<li>Ask subjects to whisper something sweet to each other</li>\\n<li>Encourage gentle touches and caresses</li>\\n<li>Capture moments between poses</li>\\n<li>Focus on hands, eyes, and subtle expressions</li>\\n</ul>\\n<h2>Post-Processing for Intimate Photography</h2>\\n<p>Post-processing should enhance the mood and emotion of your intimate photographs without overwhelming the natural beauty of the moment. Subtle adjustments to exposure, contrast, and color grading can significantly impact the final result.</p>\\n<p>Consider these post-processing tips:</p>\\n<ul>\\n<li>Maintain natural skin tones</li>\\n<li>Use subtle vignetting to draw focus</li>\\n<li>Enhance the warmth of the lighting</li>\\n<li>Remove distracting elements carefully</li>\\n</ul>\\n<h2>Conclusion</h2>\\n<p>Intimate photography is a beautiful art form that celebrates human connection and vulnerability. By combining technical skill with emotional intelligence, photographers can create images that not only capture moments but also tell powerful stories of love and intimacy.</p>\\n<p>Remember, the most important aspect of intimate photography is respect&mdash;for your subjects, for the art form, and for the trust that has been placed in you as the photographer.</p>","image":"f718185e-fd82-4f16-971d-88baf2d069de","tags":["Creativity","Journey"],"publish_date":"2025-09-04T12:00:00","category":"Spotlight","featured":false}	{"featured":false,"date_updated":"2025-09-08T20:51:27.311Z"}	\N	\N
160	183	directus_fields	38	{"sort":15,"interface":"collection-item-dropdown","special":["cast-json"],"options":{"selectedCollection":"directus_users"},"required":true,"collection":"sexy_articles","field":"author"}	{"sort":15,"interface":"collection-item-dropdown","special":["cast-json"],"options":{"selectedCollection":"directus_users"},"required":true,"collection":"sexy_articles","field":"author"}	\N	\N
161	184	sexy_articles	327b53b3-1a3b-4859-bcc6-2e831e3d9b62	{"id":"327b53b3-1a3b-4859-bcc6-2e831e3d9b62","status":"published","user_created":"4d310101-f7b1-47fe-982a-efe4abf25c55","date_created":"2025-09-08T19:51:34.582Z","date_updated":"2025-09-08T21:16:17.149Z","slug":"model-spotlight-luna-belle","title":"Model Spotlight: Luna Belle's Creative Journey","excerpt":"Discover how Luna Belle combines artistic vision with intimate expression to create captivating content.","content":"<p>Intimate photography is more than just capturing moments&mdash;it's about telling stories of love, connection, and vulnerability through the lens. In this comprehensive guide, we'll explore the artistic and technical aspects that make intimate photography truly captivating.</p>\\n<h2>Understanding the Art Form</h2>\\n<p>Intimate photography requires a delicate balance between technical skill and emotional intelligence. The photographer must create an environment where subjects feel comfortable, safe, and free to express their authentic selves.</p>\\n<p>The key to successful intimate photography lies in building trust with your subjects. This trust allows for genuine moments of vulnerability and connection that translate beautifully through the camera.</p>\\n<h2>Technical Considerations</h2>\\n<p>While the emotional aspect is crucial, technical proficiency cannot be overlooked. Here are some essential technical considerations:</p>\\n<h3>Lighting</h3>\\n<p>Natural light is often the most flattering for intimate photography. Golden hour provides warm, soft light that enhances skin tones and creates a romantic atmosphere. When shooting indoors, large windows provide beautiful, diffused light.</p>\\n<h3>Composition</h3>\\n<p>Composition in intimate photography should guide the viewer's eye to the emotional core of the image. Use leading lines, framing, and negative space to create visual interest while maintaining focus on the connection between subjects.</p>\\n<h2>Creating the Right Environment</h2>\\n<p>The environment plays a crucial role in intimate photography. Whether shooting in a studio, bedroom, or outdoor location, the space should feel safe and comfortable for your subjects.</p>\\n<p>Consider the following when preparing your shooting environment:</p>\\n<ul>\\n<li>Ensure privacy and minimize distractions</li>\\n<li>Maintain comfortable temperature</li>\\n<li>Have robes or coverings readily available</li>\\n<li>Play soft, ambient music to help subjects relax</li>\\n</ul>\\n<h2>Posing and Direction</h2>\\n<p>Posing for intimate photography should feel natural and unforced. Instead of rigid poses, encourage movement and interaction between subjects. Guide them through emotions rather than specific positions.</p>\\n<p>Some effective directing techniques include:</p>\\n<ul>\\n<li>Ask subjects to whisper something sweet to each other</li>\\n<li>Encourage gentle touches and caresses</li>\\n<li>Capture moments between poses</li>\\n<li>Focus on hands, eyes, and subtle expressions</li>\\n</ul>\\n<h2>Post-Processing for Intimate Photography</h2>\\n<p>Post-processing should enhance the mood and emotion of your intimate photographs without overwhelming the natural beauty of the moment. Subtle adjustments to exposure, contrast, and color grading can significantly impact the final result.</p>\\n<p>Consider these post-processing tips:</p>\\n<ul>\\n<li>Maintain natural skin tones</li>\\n<li>Use subtle vignetting to draw focus</li>\\n<li>Enhance the warmth of the lighting</li>\\n<li>Remove distracting elements carefully</li>\\n</ul>\\n<h2>Conclusion</h2>\\n<p>Intimate photography is a beautiful art form that celebrates human connection and vulnerability. By combining technical skill with emotional intelligence, photographers can create images that not only capture moments but also tell powerful stories of love and intimacy.</p>\\n<p>Remember, the most important aspect of intimate photography is respect&mdash;for your subjects, for the art form, and for the trust that has been placed in you as the photographer.</p>","image":"f718185e-fd82-4f16-971d-88baf2d069de","tags":["Creativity","Journey"],"publish_date":"2025-09-04T12:00:00","category":"Spotlight","featured":false,"author":{"key":"4d310101-f7b1-47fe-982a-efe4abf25c55","collection":"directus_users"}}	{"author":{"key":"4d310101-f7b1-47fe-982a-efe4abf25c55","collection":"directus_users"},"date_updated":"2025-09-08T21:16:17.149Z"}	\N	\N
162	185	directus_fields	23	{"id":23,"collection":"sexy_articles","field":"id","special":["uuid"],"interface":"input","options":null,"display":null,"display_options":null,"readonly":true,"hidden":true,"sort":1,"width":"full","translations":null,"note":null,"conditions":null,"required":false,"group":null,"validation":null,"validation_message":null}	{"collection":"sexy_articles","field":"id","sort":1,"group":null}	\N	\N
550	762	directus_folders	3f83c727-9c90-4e0d-871f-ab81c295043a	{"id":"3f83c727-9c90-4e0d-871f-ab81c295043a","name":"movies","parent":"7360b85c-3bb7-4334-ba81-2f46575ea056"}	{"parent":"7360b85c-3bb7-4334-ba81-2f46575ea056"}	\N	\N
163	186	directus_fields	24	{"id":24,"collection":"sexy_articles","field":"status","special":null,"interface":"select-dropdown","options":{"choices":[{"text":"$t:published","value":"published","color":"var(--theme--primary)"},{"text":"$t:draft","value":"draft","color":"var(--theme--foreground)"},{"text":"$t:archived","value":"archived","color":"var(--theme--warning)"}]},"display":"labels","display_options":{"showAsDot":true,"choices":[{"text":"$t:published","value":"published","color":"var(--theme--primary)","foreground":"var(--theme--primary)","background":"var(--theme--primary-background)"},{"text":"$t:draft","value":"draft","color":"var(--theme--foreground)","foreground":"var(--theme--foreground)","background":"var(--theme--background-normal)"},{"text":"$t:archived","value":"archived","color":"var(--theme--warning)","foreground":"var(--theme--warning)","background":"var(--theme--warning-background)"}]},"readonly":false,"hidden":false,"sort":2,"width":"full","translations":null,"note":null,"conditions":null,"required":false,"group":null,"validation":null,"validation_message":null}	{"collection":"sexy_articles","field":"status","sort":2,"group":null}	\N	\N
164	187	directus_fields	25	{"id":25,"collection":"sexy_articles","field":"user_created","special":["user-created"],"interface":"select-dropdown-m2o","options":{"template":"{{avatar}} {{first_name}} {{last_name}}"},"display":"user","display_options":null,"readonly":true,"hidden":true,"sort":3,"width":"half","translations":null,"note":null,"conditions":null,"required":false,"group":null,"validation":null,"validation_message":null}	{"collection":"sexy_articles","field":"user_created","sort":3,"group":null}	\N	\N
165	188	directus_fields	26	{"id":26,"collection":"sexy_articles","field":"date_created","special":["date-created"],"interface":"datetime","options":null,"display":"datetime","display_options":{"relative":true},"readonly":true,"hidden":true,"sort":4,"width":"half","translations":null,"note":null,"conditions":null,"required":false,"group":null,"validation":null,"validation_message":null}	{"collection":"sexy_articles","field":"date_created","sort":4,"group":null}	\N	\N
166	189	directus_fields	27	{"id":27,"collection":"sexy_articles","field":"date_updated","special":["date-updated"],"interface":"datetime","options":null,"display":"datetime","display_options":{"relative":true},"readonly":true,"hidden":true,"sort":5,"width":"half","translations":null,"note":null,"conditions":null,"required":false,"group":null,"validation":null,"validation_message":null}	{"collection":"sexy_articles","field":"date_updated","sort":5,"group":null}	\N	\N
167	190	directus_fields	29	{"id":29,"collection":"sexy_articles","field":"slug","special":null,"interface":"input","options":{"slug":true},"display":null,"display_options":null,"readonly":false,"hidden":false,"sort":6,"width":"full","translations":null,"note":null,"conditions":null,"required":true,"group":null,"validation":null,"validation_message":null}	{"collection":"sexy_articles","field":"slug","sort":6,"group":null}	\N	\N
168	191	directus_fields	38	{"id":38,"collection":"sexy_articles","field":"author","special":["cast-json"],"interface":"collection-item-dropdown","options":{"selectedCollection":"directus_users"},"display":null,"display_options":null,"readonly":false,"hidden":false,"sort":7,"width":"full","translations":null,"note":null,"conditions":null,"required":true,"group":null,"validation":null,"validation_message":null}	{"collection":"sexy_articles","field":"author","sort":7,"group":null}	\N	\N
169	192	directus_fields	30	{"id":30,"collection":"sexy_articles","field":"title","special":null,"interface":"input","options":null,"display":null,"display_options":null,"readonly":false,"hidden":false,"sort":8,"width":"full","translations":null,"note":null,"conditions":null,"required":true,"group":null,"validation":null,"validation_message":null}	{"collection":"sexy_articles","field":"title","sort":8,"group":null}	\N	\N
170	193	directus_fields	31	{"id":31,"collection":"sexy_articles","field":"excerpt","special":null,"interface":"input-multiline","options":{"trim":true},"display":null,"display_options":null,"readonly":false,"hidden":false,"sort":9,"width":"full","translations":null,"note":null,"conditions":null,"required":true,"group":null,"validation":null,"validation_message":null}	{"collection":"sexy_articles","field":"excerpt","sort":9,"group":null}	\N	\N
171	194	directus_fields	32	{"id":32,"collection":"sexy_articles","field":"content","special":null,"interface":"input-rich-text-html","options":{"toolbar":["bold","italic","underline","h2","h3","numlist","bullist","removeformat","blockquote","customLink","hr","fullscreen","code"],"folder":"c214c905-885b-4d66-a6a1-6527b0606200"},"display":null,"display_options":null,"readonly":false,"hidden":false,"sort":10,"width":"full","translations":null,"note":null,"conditions":null,"required":true,"group":null,"validation":null,"validation_message":null}	{"collection":"sexy_articles","field":"content","sort":10,"group":null}	\N	\N
172	195	directus_fields	33	{"id":33,"collection":"sexy_articles","field":"image","special":["file"],"interface":"file-image","options":{"folder":"452680cc-8e19-4352-a943-21520d3f3621"},"display":null,"display_options":null,"readonly":false,"hidden":false,"sort":11,"width":"full","translations":null,"note":null,"conditions":null,"required":true,"group":null,"validation":null,"validation_message":null}	{"collection":"sexy_articles","field":"image","sort":11,"group":null}	\N	\N
173	196	directus_fields	34	{"id":34,"collection":"sexy_articles","field":"tags","special":["cast-json"],"interface":"tags","options":{"capitalization":"auto-format","whitespace":"_"},"display":null,"display_options":null,"readonly":false,"hidden":false,"sort":12,"width":"full","translations":null,"note":null,"conditions":null,"required":false,"group":null,"validation":null,"validation_message":null}	{"collection":"sexy_articles","field":"tags","sort":12,"group":null}	\N	\N
174	197	directus_fields	35	{"id":35,"collection":"sexy_articles","field":"publish_date","special":null,"interface":"datetime","options":null,"display":null,"display_options":null,"readonly":false,"hidden":false,"sort":13,"width":"full","translations":null,"note":null,"conditions":null,"required":true,"group":null,"validation":null,"validation_message":null}	{"collection":"sexy_articles","field":"publish_date","sort":13,"group":null}	\N	\N
175	198	directus_fields	36	{"id":36,"collection":"sexy_articles","field":"category","special":null,"interface":"input","options":null,"display":null,"display_options":null,"readonly":false,"hidden":false,"sort":14,"width":"full","translations":null,"note":null,"conditions":null,"required":true,"group":null,"validation":null,"validation_message":null}	{"collection":"sexy_articles","field":"category","sort":14,"group":null}	\N	\N
176	199	directus_fields	37	{"id":37,"collection":"sexy_articles","field":"featured","special":["cast-boolean"],"interface":"boolean","options":{"label":"Featured"},"display":null,"display_options":null,"readonly":false,"hidden":false,"sort":15,"width":"full","translations":null,"note":null,"conditions":null,"required":false,"group":null,"validation":null,"validation_message":null}	{"collection":"sexy_articles","field":"featured","sort":15,"group":null}	\N	\N
177	201	directus_fields	39	{"sort":16,"interface":"select-dropdown-m2o","special":["m2o"],"required":true,"options":{"enableLink":true},"collection":"sexy_articles","field":"author"}	{"sort":16,"interface":"select-dropdown-m2o","special":["m2o"],"required":true,"options":{"enableLink":true},"collection":"sexy_articles","field":"author"}	\N	\N
178	202	directus_fields	23	{"id":23,"collection":"sexy_articles","field":"id","special":["uuid"],"interface":"input","options":null,"display":null,"display_options":null,"readonly":true,"hidden":true,"sort":1,"width":"full","translations":null,"note":null,"conditions":null,"required":false,"group":null,"validation":null,"validation_message":null}	{"collection":"sexy_articles","field":"id","sort":1,"group":null}	\N	\N
179	203	directus_fields	24	{"id":24,"collection":"sexy_articles","field":"status","special":null,"interface":"select-dropdown","options":{"choices":[{"text":"$t:published","value":"published","color":"var(--theme--primary)"},{"text":"$t:draft","value":"draft","color":"var(--theme--foreground)"},{"text":"$t:archived","value":"archived","color":"var(--theme--warning)"}]},"display":"labels","display_options":{"showAsDot":true,"choices":[{"text":"$t:published","value":"published","color":"var(--theme--primary)","foreground":"var(--theme--primary)","background":"var(--theme--primary-background)"},{"text":"$t:draft","value":"draft","color":"var(--theme--foreground)","foreground":"var(--theme--foreground)","background":"var(--theme--background-normal)"},{"text":"$t:archived","value":"archived","color":"var(--theme--warning)","foreground":"var(--theme--warning)","background":"var(--theme--warning-background)"}]},"readonly":false,"hidden":false,"sort":2,"width":"full","translations":null,"note":null,"conditions":null,"required":false,"group":null,"validation":null,"validation_message":null}	{"collection":"sexy_articles","field":"status","sort":2,"group":null}	\N	\N
180	204	directus_fields	25	{"id":25,"collection":"sexy_articles","field":"user_created","special":["user-created"],"interface":"select-dropdown-m2o","options":{"template":"{{avatar}} {{first_name}} {{last_name}}"},"display":"user","display_options":null,"readonly":true,"hidden":true,"sort":3,"width":"half","translations":null,"note":null,"conditions":null,"required":false,"group":null,"validation":null,"validation_message":null}	{"collection":"sexy_articles","field":"user_created","sort":3,"group":null}	\N	\N
181	205	directus_fields	26	{"id":26,"collection":"sexy_articles","field":"date_created","special":["date-created"],"interface":"datetime","options":null,"display":"datetime","display_options":{"relative":true},"readonly":true,"hidden":true,"sort":4,"width":"half","translations":null,"note":null,"conditions":null,"required":false,"group":null,"validation":null,"validation_message":null}	{"collection":"sexy_articles","field":"date_created","sort":4,"group":null}	\N	\N
182	206	directus_fields	27	{"id":27,"collection":"sexy_articles","field":"date_updated","special":["date-updated"],"interface":"datetime","options":null,"display":"datetime","display_options":{"relative":true},"readonly":true,"hidden":true,"sort":5,"width":"half","translations":null,"note":null,"conditions":null,"required":false,"group":null,"validation":null,"validation_message":null}	{"collection":"sexy_articles","field":"date_updated","sort":5,"group":null}	\N	\N
183	207	directus_fields	29	{"id":29,"collection":"sexy_articles","field":"slug","special":null,"interface":"input","options":{"slug":true},"display":null,"display_options":null,"readonly":false,"hidden":false,"sort":6,"width":"full","translations":null,"note":null,"conditions":null,"required":true,"group":null,"validation":null,"validation_message":null}	{"collection":"sexy_articles","field":"slug","sort":6,"group":null}	\N	\N
184	208	directus_fields	30	{"id":30,"collection":"sexy_articles","field":"title","special":null,"interface":"input","options":null,"display":null,"display_options":null,"readonly":false,"hidden":false,"sort":7,"width":"full","translations":null,"note":null,"conditions":null,"required":true,"group":null,"validation":null,"validation_message":null}	{"collection":"sexy_articles","field":"title","sort":7,"group":null}	\N	\N
185	209	directus_fields	39	{"id":39,"collection":"sexy_articles","field":"author","special":["m2o"],"interface":"select-dropdown-m2o","options":{"enableLink":true},"display":null,"display_options":null,"readonly":false,"hidden":false,"sort":8,"width":"full","translations":null,"note":null,"conditions":null,"required":true,"group":null,"validation":null,"validation_message":null}	{"collection":"sexy_articles","field":"author","sort":8,"group":null}	\N	\N
186	210	directus_fields	31	{"id":31,"collection":"sexy_articles","field":"excerpt","special":null,"interface":"input-multiline","options":{"trim":true},"display":null,"display_options":null,"readonly":false,"hidden":false,"sort":9,"width":"full","translations":null,"note":null,"conditions":null,"required":true,"group":null,"validation":null,"validation_message":null}	{"collection":"sexy_articles","field":"excerpt","sort":9,"group":null}	\N	\N
187	211	directus_fields	32	{"id":32,"collection":"sexy_articles","field":"content","special":null,"interface":"input-rich-text-html","options":{"toolbar":["bold","italic","underline","h2","h3","numlist","bullist","removeformat","blockquote","customLink","hr","fullscreen","code"],"folder":"c214c905-885b-4d66-a6a1-6527b0606200"},"display":null,"display_options":null,"readonly":false,"hidden":false,"sort":10,"width":"full","translations":null,"note":null,"conditions":null,"required":true,"group":null,"validation":null,"validation_message":null}	{"collection":"sexy_articles","field":"content","sort":10,"group":null}	\N	\N
188	212	directus_fields	33	{"id":33,"collection":"sexy_articles","field":"image","special":["file"],"interface":"file-image","options":{"folder":"452680cc-8e19-4352-a943-21520d3f3621"},"display":null,"display_options":null,"readonly":false,"hidden":false,"sort":11,"width":"full","translations":null,"note":null,"conditions":null,"required":true,"group":null,"validation":null,"validation_message":null}	{"collection":"sexy_articles","field":"image","sort":11,"group":null}	\N	\N
189	213	directus_fields	34	{"id":34,"collection":"sexy_articles","field":"tags","special":["cast-json"],"interface":"tags","options":{"capitalization":"auto-format","whitespace":"_"},"display":null,"display_options":null,"readonly":false,"hidden":false,"sort":12,"width":"full","translations":null,"note":null,"conditions":null,"required":false,"group":null,"validation":null,"validation_message":null}	{"collection":"sexy_articles","field":"tags","sort":12,"group":null}	\N	\N
190	214	directus_fields	35	{"id":35,"collection":"sexy_articles","field":"publish_date","special":null,"interface":"datetime","options":null,"display":null,"display_options":null,"readonly":false,"hidden":false,"sort":13,"width":"full","translations":null,"note":null,"conditions":null,"required":true,"group":null,"validation":null,"validation_message":null}	{"collection":"sexy_articles","field":"publish_date","sort":13,"group":null}	\N	\N
191	215	directus_fields	36	{"id":36,"collection":"sexy_articles","field":"category","special":null,"interface":"input","options":null,"display":null,"display_options":null,"readonly":false,"hidden":false,"sort":14,"width":"full","translations":null,"note":null,"conditions":null,"required":true,"group":null,"validation":null,"validation_message":null}	{"collection":"sexy_articles","field":"category","sort":14,"group":null}	\N	\N
250	295	directus_fields	55	{"id":55,"collection":"sexy_models","field":"category","special":null,"interface":"input","options":null,"display":null,"display_options":null,"readonly":false,"hidden":false,"sort":11,"width":"full","translations":null,"note":null,"conditions":null,"required":false,"group":null,"validation":null,"validation_message":null}	{"collection":"sexy_models","field":"category","sort":11,"group":null}	\N	\N
192	216	directus_fields	37	{"id":37,"collection":"sexy_articles","field":"featured","special":["cast-boolean"],"interface":"boolean","options":{"label":"Featured"},"display":null,"display_options":null,"readonly":false,"hidden":false,"sort":15,"width":"full","translations":null,"note":null,"conditions":null,"required":false,"group":null,"validation":null,"validation_message":null}	{"collection":"sexy_articles","field":"featured","sort":15,"group":null}	\N	\N
193	217	sexy_articles	327b53b3-1a3b-4859-bcc6-2e831e3d9b62	{"id":"327b53b3-1a3b-4859-bcc6-2e831e3d9b62","status":"published","user_created":"4d310101-f7b1-47fe-982a-efe4abf25c55","date_created":"2025-09-08T19:51:34.582Z","date_updated":"2025-09-08T21:28:48.422Z","slug":"model-spotlight-luna-belle","title":"Model Spotlight: Luna Belle's Creative Journey","excerpt":"Discover how Luna Belle combines artistic vision with intimate expression to create captivating content.","content":"<p>Intimate photography is more than just capturing moments&mdash;it's about telling stories of love, connection, and vulnerability through the lens. In this comprehensive guide, we'll explore the artistic and technical aspects that make intimate photography truly captivating.</p>\\n<h2>Understanding the Art Form</h2>\\n<p>Intimate photography requires a delicate balance between technical skill and emotional intelligence. The photographer must create an environment where subjects feel comfortable, safe, and free to express their authentic selves.</p>\\n<p>The key to successful intimate photography lies in building trust with your subjects. This trust allows for genuine moments of vulnerability and connection that translate beautifully through the camera.</p>\\n<h2>Technical Considerations</h2>\\n<p>While the emotional aspect is crucial, technical proficiency cannot be overlooked. Here are some essential technical considerations:</p>\\n<h3>Lighting</h3>\\n<p>Natural light is often the most flattering for intimate photography. Golden hour provides warm, soft light that enhances skin tones and creates a romantic atmosphere. When shooting indoors, large windows provide beautiful, diffused light.</p>\\n<h3>Composition</h3>\\n<p>Composition in intimate photography should guide the viewer's eye to the emotional core of the image. Use leading lines, framing, and negative space to create visual interest while maintaining focus on the connection between subjects.</p>\\n<h2>Creating the Right Environment</h2>\\n<p>The environment plays a crucial role in intimate photography. Whether shooting in a studio, bedroom, or outdoor location, the space should feel safe and comfortable for your subjects.</p>\\n<p>Consider the following when preparing your shooting environment:</p>\\n<ul>\\n<li>Ensure privacy and minimize distractions</li>\\n<li>Maintain comfortable temperature</li>\\n<li>Have robes or coverings readily available</li>\\n<li>Play soft, ambient music to help subjects relax</li>\\n</ul>\\n<h2>Posing and Direction</h2>\\n<p>Posing for intimate photography should feel natural and unforced. Instead of rigid poses, encourage movement and interaction between subjects. Guide them through emotions rather than specific positions.</p>\\n<p>Some effective directing techniques include:</p>\\n<ul>\\n<li>Ask subjects to whisper something sweet to each other</li>\\n<li>Encourage gentle touches and caresses</li>\\n<li>Capture moments between poses</li>\\n<li>Focus on hands, eyes, and subtle expressions</li>\\n</ul>\\n<h2>Post-Processing for Intimate Photography</h2>\\n<p>Post-processing should enhance the mood and emotion of your intimate photographs without overwhelming the natural beauty of the moment. Subtle adjustments to exposure, contrast, and color grading can significantly impact the final result.</p>\\n<p>Consider these post-processing tips:</p>\\n<ul>\\n<li>Maintain natural skin tones</li>\\n<li>Use subtle vignetting to draw focus</li>\\n<li>Enhance the warmth of the lighting</li>\\n<li>Remove distracting elements carefully</li>\\n</ul>\\n<h2>Conclusion</h2>\\n<p>Intimate photography is a beautiful art form that celebrates human connection and vulnerability. By combining technical skill with emotional intelligence, photographers can create images that not only capture moments but also tell powerful stories of love and intimacy.</p>\\n<p>Remember, the most important aspect of intimate photography is respect&mdash;for your subjects, for the art form, and for the trust that has been placed in you as the photographer.</p>","image":"f718185e-fd82-4f16-971d-88baf2d069de","tags":["Creativity","Journey"],"publish_date":"2025-09-04T12:00:00","category":"Spotlight","featured":false,"author":"4d310101-f7b1-47fe-982a-efe4abf25c55"}	{"author":"4d310101-f7b1-47fe-982a-efe4abf25c55","date_updated":"2025-09-08T21:28:48.422Z"}	\N	\N
194	218	directus_roles	f1d1d90f-9a4a-4199-bc70-f9cd3cccd99f	{"name":"Editor"}	{"name":"Editor"}	\N	\N
195	219	directus_permissions	29	{"policy":"656e614d-a1aa-4b89-936a-e2c730fc85e1","permissions":null,"validation":null,"fields":["*"],"presets":null,"collection":"sexy_articles","action":"create"}	{"policy":"656e614d-a1aa-4b89-936a-e2c730fc85e1","permissions":null,"validation":null,"fields":["*"],"presets":null,"collection":"sexy_articles","action":"create"}	200	\N
196	220	directus_permissions	30	{"policy":"656e614d-a1aa-4b89-936a-e2c730fc85e1","permissions":null,"validation":null,"fields":["*"],"presets":null,"collection":"sexy_articles","action":"read"}	{"policy":"656e614d-a1aa-4b89-936a-e2c730fc85e1","permissions":null,"validation":null,"fields":["*"],"presets":null,"collection":"sexy_articles","action":"read"}	200	\N
197	221	directus_permissions	31	{"policy":"656e614d-a1aa-4b89-936a-e2c730fc85e1","permissions":null,"validation":null,"fields":["*"],"presets":null,"collection":"sexy_articles","action":"update"}	{"policy":"656e614d-a1aa-4b89-936a-e2c730fc85e1","permissions":null,"validation":null,"fields":["*"],"presets":null,"collection":"sexy_articles","action":"update"}	200	\N
198	222	directus_permissions	32	{"policy":"656e614d-a1aa-4b89-936a-e2c730fc85e1","permissions":null,"validation":null,"fields":["*"],"presets":null,"collection":"sexy_articles","action":"delete"}	{"policy":"656e614d-a1aa-4b89-936a-e2c730fc85e1","permissions":null,"validation":null,"fields":["*"],"presets":null,"collection":"sexy_articles","action":"delete"}	200	\N
199	223	directus_permissions	33	{"policy":"656e614d-a1aa-4b89-936a-e2c730fc85e1","permissions":null,"validation":null,"fields":["*"],"presets":null,"collection":"sexy_articles","action":"share"}	{"policy":"656e614d-a1aa-4b89-936a-e2c730fc85e1","permissions":null,"validation":null,"fields":["*"],"presets":null,"collection":"sexy_articles","action":"share"}	200	\N
200	224	directus_policies	656e614d-a1aa-4b89-936a-e2c730fc85e1	{"name":"Editor","icon":"ink_pen","permissions":{"create":[{"policy":"+","permissions":null,"validation":null,"fields":["*"],"presets":null,"collection":"sexy_articles","action":"create"},{"policy":"+","permissions":null,"validation":null,"fields":["*"],"presets":null,"collection":"sexy_articles","action":"read"},{"policy":"+","permissions":null,"validation":null,"fields":["*"],"presets":null,"collection":"sexy_articles","action":"update"},{"policy":"+","permissions":null,"validation":null,"fields":["*"],"presets":null,"collection":"sexy_articles","action":"delete"},{"policy":"+","permissions":null,"validation":null,"fields":["*"],"presets":null,"collection":"sexy_articles","action":"share"}],"update":[],"delete":[]},"enforce_tfa":true}	{"name":"Editor","icon":"ink_pen","permissions":{"create":[{"policy":"+","permissions":null,"validation":null,"fields":["*"],"presets":null,"collection":"sexy_articles","action":"create"},{"policy":"+","permissions":null,"validation":null,"fields":["*"],"presets":null,"collection":"sexy_articles","action":"read"},{"policy":"+","permissions":null,"validation":null,"fields":["*"],"presets":null,"collection":"sexy_articles","action":"update"},{"policy":"+","permissions":null,"validation":null,"fields":["*"],"presets":null,"collection":"sexy_articles","action":"delete"},{"policy":"+","permissions":null,"validation":null,"fields":["*"],"presets":null,"collection":"sexy_articles","action":"share"}],"update":[],"delete":[]},"enforce_tfa":true}	201	\N
202	226	directus_roles	f1d1d90f-9a4a-4199-bc70-f9cd3cccd99f	{"id":"f1d1d90f-9a4a-4199-bc70-f9cd3cccd99f","name":"Editor","icon":"ink_pen","description":null,"parent":null,"children":[],"policies":["11fa655a-6998-4c6b-b35f-42fd174d4536"],"users":[]}	{"icon":"ink_pen"}	\N	\N
201	225	directus_access	11fa655a-6998-4c6b-b35f-42fd174d4536	{"policy":{"name":"Editor","icon":"ink_pen","permissions":{"create":[{"policy":"+","permissions":null,"validation":null,"fields":["*"],"presets":null,"collection":"sexy_articles","action":"create"},{"policy":"+","permissions":null,"validation":null,"fields":["*"],"presets":null,"collection":"sexy_articles","action":"read"},{"policy":"+","permissions":null,"validation":null,"fields":["*"],"presets":null,"collection":"sexy_articles","action":"update"},{"policy":"+","permissions":null,"validation":null,"fields":["*"],"presets":null,"collection":"sexy_articles","action":"delete"},{"policy":"+","permissions":null,"validation":null,"fields":["*"],"presets":null,"collection":"sexy_articles","action":"share"}],"update":[],"delete":[]},"enforce_tfa":true},"sort":1,"role":"f1d1d90f-9a4a-4199-bc70-f9cd3cccd99f"}	{"policy":{"name":"Editor","icon":"ink_pen","permissions":{"create":[{"policy":"+","permissions":null,"validation":null,"fields":["*"],"presets":null,"collection":"sexy_articles","action":"create"},{"policy":"+","permissions":null,"validation":null,"fields":["*"],"presets":null,"collection":"sexy_articles","action":"read"},{"policy":"+","permissions":null,"validation":null,"fields":["*"],"presets":null,"collection":"sexy_articles","action":"update"},{"policy":"+","permissions":null,"validation":null,"fields":["*"],"presets":null,"collection":"sexy_articles","action":"delete"},{"policy":"+","permissions":null,"validation":null,"fields":["*"],"presets":null,"collection":"sexy_articles","action":"share"}],"update":[],"delete":[]},"enforce_tfa":true},"sort":1,"role":"f1d1d90f-9a4a-4199-bc70-f9cd3cccd99f"}	202	\N
203	227	directus_roles	f1d1d90f-9a4a-4199-bc70-f9cd3cccd99f	{"id":"f1d1d90f-9a4a-4199-bc70-f9cd3cccd99f","name":"Editor","icon":"ink_pen","description":"As an editor i can write magazine articles.","parent":null,"children":[],"policies":["11fa655a-6998-4c6b-b35f-42fd174d4536"],"users":[]}	{"description":"As an editor i can write magazine articles."}	\N	\N
204	228	directus_fields	39	{"id":39,"collection":"sexy_articles","field":"author","special":["m2o"],"interface":"select-dropdown-m2o","options":{"enableLink":true,"filter":{"_and":[{"role":{"name":{"_contains":"Editor"}}}]}},"display":null,"display_options":null,"readonly":false,"hidden":false,"sort":8,"width":"full","translations":null,"note":null,"conditions":null,"required":true,"group":null,"validation":null,"validation_message":null}	{"collection":"sexy_articles","field":"author","options":{"enableLink":true,"filter":{"_and":[{"role":{"name":{"_contains":"Editor"}}}]}}}	\N	\N
205	229	directus_access	b4f61dcc-b54e-4b3e-8a5e-bfbf029f6349	{"user":"4d310101-f7b1-47fe-982a-efe4abf25c55","policy":{"id":"656e614d-a1aa-4b89-936a-e2c730fc85e1"},"sort":1}	{"user":"4d310101-f7b1-47fe-982a-efe4abf25c55","policy":{"id":"656e614d-a1aa-4b89-936a-e2c730fc85e1"},"sort":1}	\N	\N
325	373	directus_access	21e031ff-632d-46e5-97bb-959a5fef2538	{"policy":"5f2a2bd8-588f-4ef7-8613-fa826e0b224d","user":{"id":"4d310101-f7b1-47fe-982a-efe4abf25c55"}}	{"policy":"5f2a2bd8-588f-4ef7-8613-fa826e0b224d","user":{"id":"4d310101-f7b1-47fe-982a-efe4abf25c55"}}	\N	\N
206	231	directus_users	4d310101-f7b1-47fe-982a-efe4abf25c55	{"id":"4d310101-f7b1-47fe-982a-efe4abf25c55","first_name":"Sebastian","last_name":"Krüger","email":"admin@pivoine.art","password":"**********","location":null,"title":null,"description":null,"tags":null,"avatar":"99c47c3d-4865-4361-a545-f38e54fccb0b","language":null,"tfa_secret":"**********","status":"active","role":"ea3a9127-2b65-462c-85a8-dbafe9b4fe24","token":null,"last_access":"2025-09-08T23:44:33.071Z","last_page":"/users/4d310101-f7b1-47fe-982a-efe4abf25c55","provider":"default","external_identifier":null,"auth_data":null,"email_notifications":true,"appearance":null,"theme_dark":null,"theme_light":null,"theme_light_overrides":null,"theme_dark_overrides":null,"text_direction":"auto","policies":["b4f61dcc-b54e-4b3e-8a5e-bfbf029f6349"]}	{"tfa_secret":"**********"}	\N	\N
207	232	directus_fields	39	{"id":39,"collection":"sexy_articles","field":"author","special":["m2o"],"interface":"select-dropdown-m2o","options":{"enableLink":true,"filter":{"_and":[{"policies":{"policy":{"name":{"_eq":"Editor"}}}}]}},"display":null,"display_options":null,"readonly":false,"hidden":false,"sort":8,"width":"full","translations":null,"note":null,"conditions":null,"required":true,"group":null,"validation":null,"validation_message":null}	{"collection":"sexy_articles","field":"author","options":{"enableLink":true,"filter":{"_and":[{"policies":{"policy":{"name":{"_eq":"Editor"}}}}]}}}	\N	\N
208	233	directus_fields	40	{"sort":1,"interface":"input","special":null,"collection":"directus_users","field":"website"}	{"sort":1,"interface":"input","special":null,"collection":"directus_users","field":"website"}	\N	\N
209	234	directus_users	4d310101-f7b1-47fe-982a-efe4abf25c55	{"id":"4d310101-f7b1-47fe-982a-efe4abf25c55","first_name":"Sebastian","last_name":"Krüger","email":"admin@pivoine.art","password":"**********","location":null,"title":null,"description":null,"tags":null,"avatar":"99c47c3d-4865-4361-a545-f38e54fccb0b","language":null,"tfa_secret":"**********","status":"active","role":"ea3a9127-2b65-462c-85a8-dbafe9b4fe24","token":null,"last_access":"2025-09-08T23:44:33.071Z","last_page":"/users/4d310101-f7b1-47fe-982a-efe4abf25c55","provider":"default","external_identifier":null,"auth_data":null,"email_notifications":true,"appearance":null,"theme_dark":null,"theme_light":null,"theme_light_overrides":null,"theme_dark_overrides":null,"text_direction":"auto","website":"pivoine.art","policies":["b4f61dcc-b54e-4b3e-8a5e-bfbf029f6349"]}	{"website":"pivoine.art"}	\N	\N
251	296	directus_fields	56	{"id":56,"collection":"sexy_models","field":"banner_image","special":["file"],"interface":"file-image","options":{"folder":"3c744e72-03ef-432d-9c16-ac0a343b2499"},"display":null,"display_options":null,"readonly":false,"hidden":false,"sort":12,"width":"full","translations":null,"note":null,"conditions":null,"required":false,"group":null,"validation":null,"validation_message":null}	{"collection":"sexy_models","field":"banner_image","sort":12,"group":null}	\N	\N
210	235	directus_users	4d310101-f7b1-47fe-982a-efe4abf25c55	{"id":"4d310101-f7b1-47fe-982a-efe4abf25c55","first_name":"Sebastian","last_name":"Krüger","email":"admin@pivoine.art","password":"**********","location":null,"title":null,"description":"Visionary leader with 15+ years in digital media and content creation.","tags":null,"avatar":"99c47c3d-4865-4361-a545-f38e54fccb0b","language":null,"tfa_secret":"**********","status":"active","role":"ea3a9127-2b65-462c-85a8-dbafe9b4fe24","token":null,"last_access":"2025-09-08T23:44:33.071Z","last_page":"/users/4d310101-f7b1-47fe-982a-efe4abf25c55","provider":"default","external_identifier":null,"auth_data":null,"email_notifications":true,"appearance":null,"theme_dark":null,"theme_light":null,"theme_light_overrides":null,"theme_dark_overrides":null,"text_direction":"auto","website":"pivoine.art","policies":["b4f61dcc-b54e-4b3e-8a5e-bfbf029f6349"]}	{"description":"Visionary leader with 15+ years in digital media and content creation."}	\N	\N
211	236	directus_permissions	28	{"id":28,"collection":"directus_users","action":"read","permissions":null,"validation":null,"presets":null,"fields":["first_name","last_name","description","tags","avatar","title","location"],"policy":"abf8a154-5b1c-4a46-ac9c-7300570f4f17"}	{"collection":"directus_users","action":"read","permissions":null,"validation":null,"presets":null,"fields":["first_name","last_name","description","tags","avatar","title","location"],"policy":"abf8a154-5b1c-4a46-ac9c-7300570f4f17"}	\N	\N
212	250	directus_fields	41	{"sort":1,"hidden":true,"readonly":true,"interface":"input","special":["uuid"],"field":"id","collection":"sexy_models"}	{"sort":1,"hidden":true,"readonly":true,"interface":"input","special":["uuid"],"field":"id","collection":"sexy_models"}	\N	\N
213	251	directus_fields	42	{"sort":2,"width":"full","options":{"choices":[{"text":"$t:published","value":"published","color":"var(--theme--primary)"},{"text":"$t:draft","value":"draft","color":"var(--theme--foreground)"},{"text":"$t:archived","value":"archived","color":"var(--theme--warning)"}]},"interface":"select-dropdown","display":"labels","display_options":{"showAsDot":true,"choices":[{"text":"$t:published","value":"published","color":"var(--theme--primary)","foreground":"var(--theme--primary)","background":"var(--theme--primary-background)"},{"text":"$t:draft","value":"draft","color":"var(--theme--foreground)","foreground":"var(--theme--foreground)","background":"var(--theme--background-normal)"},{"text":"$t:archived","value":"archived","color":"var(--theme--warning)","foreground":"var(--theme--warning)","background":"var(--theme--warning-background)"}]},"field":"status","collection":"sexy_models"}	{"sort":2,"width":"full","options":{"choices":[{"text":"$t:published","value":"published","color":"var(--theme--primary)"},{"text":"$t:draft","value":"draft","color":"var(--theme--foreground)"},{"text":"$t:archived","value":"archived","color":"var(--theme--warning)"}]},"interface":"select-dropdown","display":"labels","display_options":{"showAsDot":true,"choices":[{"text":"$t:published","value":"published","color":"var(--theme--primary)","foreground":"var(--theme--primary)","background":"var(--theme--primary-background)"},{"text":"$t:draft","value":"draft","color":"var(--theme--foreground)","foreground":"var(--theme--foreground)","background":"var(--theme--background-normal)"},{"text":"$t:archived","value":"archived","color":"var(--theme--warning)","foreground":"var(--theme--warning)","background":"var(--theme--warning-background)"}]},"field":"status","collection":"sexy_models"}	\N	\N
214	252	directus_fields	43	{"sort":3,"special":["user-created"],"interface":"select-dropdown-m2o","options":{"template":"{{avatar}} {{first_name}} {{last_name}}"},"display":"user","readonly":true,"hidden":true,"width":"half","field":"user_created","collection":"sexy_models"}	{"sort":3,"special":["user-created"],"interface":"select-dropdown-m2o","options":{"template":"{{avatar}} {{first_name}} {{last_name}}"},"display":"user","readonly":true,"hidden":true,"width":"half","field":"user_created","collection":"sexy_models"}	\N	\N
215	253	directus_fields	44	{"sort":4,"special":["date-created"],"interface":"datetime","readonly":true,"hidden":true,"width":"half","display":"datetime","display_options":{"relative":true},"field":"date_created","collection":"sexy_models"}	{"sort":4,"special":["date-created"],"interface":"datetime","readonly":true,"hidden":true,"width":"half","display":"datetime","display_options":{"relative":true},"field":"date_created","collection":"sexy_models"}	\N	\N
216	254	directus_fields	45	{"sort":5,"special":["date-updated"],"interface":"datetime","readonly":true,"hidden":true,"width":"half","display":"datetime","display_options":{"relative":true},"field":"date_updated","collection":"sexy_models"}	{"sort":5,"special":["date-updated"],"interface":"datetime","readonly":true,"hidden":true,"width":"half","display":"datetime","display_options":{"relative":true},"field":"date_updated","collection":"sexy_models"}	\N	\N
217	255	directus_collections	sexy_models	{"archive_field":"status","archive_value":"archived","unarchive_value":"draft","singleton":false,"collection":"sexy_models"}	{"archive_field":"status","archive_value":"archived","unarchive_value":"draft","singleton":false,"collection":"sexy_models"}	\N	\N
218	262	directus_fields	46	{"sort":1,"hidden":true,"readonly":true,"interface":"input","special":["uuid"],"field":"id","collection":"sexy_models"}	{"sort":1,"hidden":true,"readonly":true,"interface":"input","special":["uuid"],"field":"id","collection":"sexy_models"}	\N	\N
219	263	directus_fields	47	{"sort":2,"width":"full","options":{"choices":[{"text":"$t:published","value":"published","color":"var(--theme--primary)"},{"text":"$t:draft","value":"draft","color":"var(--theme--foreground)"},{"text":"$t:archived","value":"archived","color":"var(--theme--warning)"}]},"interface":"select-dropdown","display":"labels","display_options":{"showAsDot":true,"choices":[{"text":"$t:published","value":"published","color":"var(--theme--primary)","foreground":"var(--theme--primary)","background":"var(--theme--primary-background)"},{"text":"$t:draft","value":"draft","color":"var(--theme--foreground)","foreground":"var(--theme--foreground)","background":"var(--theme--background-normal)"},{"text":"$t:archived","value":"archived","color":"var(--theme--warning)","foreground":"var(--theme--warning)","background":"var(--theme--warning-background)"}]},"field":"status","collection":"sexy_models"}	{"sort":2,"width":"full","options":{"choices":[{"text":"$t:published","value":"published","color":"var(--theme--primary)"},{"text":"$t:draft","value":"draft","color":"var(--theme--foreground)"},{"text":"$t:archived","value":"archived","color":"var(--theme--warning)"}]},"interface":"select-dropdown","display":"labels","display_options":{"showAsDot":true,"choices":[{"text":"$t:published","value":"published","color":"var(--theme--primary)","foreground":"var(--theme--primary)","background":"var(--theme--primary-background)"},{"text":"$t:draft","value":"draft","color":"var(--theme--foreground)","foreground":"var(--theme--foreground)","background":"var(--theme--background-normal)"},{"text":"$t:archived","value":"archived","color":"var(--theme--warning)","foreground":"var(--theme--warning)","background":"var(--theme--warning-background)"}]},"field":"status","collection":"sexy_models"}	\N	\N
252	297	directus_fields	58	{"sort":13,"interface":"datetime","special":null,"required":true,"collection":"sexy_models","field":"join_date"}	{"sort":13,"interface":"datetime","special":null,"required":true,"collection":"sexy_models","field":"join_date"}	\N	\N
220	264	directus_fields	48	{"sort":3,"special":["user-created"],"interface":"select-dropdown-m2o","options":{"template":"{{avatar}} {{first_name}} {{last_name}}"},"display":"user","readonly":true,"hidden":true,"width":"half","field":"user_created","collection":"sexy_models"}	{"sort":3,"special":["user-created"],"interface":"select-dropdown-m2o","options":{"template":"{{avatar}} {{first_name}} {{last_name}}"},"display":"user","readonly":true,"hidden":true,"width":"half","field":"user_created","collection":"sexy_models"}	\N	\N
221	265	directus_fields	49	{"sort":4,"special":["date-created"],"interface":"datetime","readonly":true,"hidden":true,"width":"half","display":"datetime","display_options":{"relative":true},"field":"date_created","collection":"sexy_models"}	{"sort":4,"special":["date-created"],"interface":"datetime","readonly":true,"hidden":true,"width":"half","display":"datetime","display_options":{"relative":true},"field":"date_created","collection":"sexy_models"}	\N	\N
222	266	directus_fields	50	{"sort":5,"special":["date-updated"],"interface":"datetime","readonly":true,"hidden":true,"width":"half","display":"datetime","display_options":{"relative":true},"field":"date_updated","collection":"sexy_models"}	{"sort":5,"special":["date-updated"],"interface":"datetime","readonly":true,"hidden":true,"width":"half","display":"datetime","display_options":{"relative":true},"field":"date_updated","collection":"sexy_models"}	\N	\N
223	267	directus_collections	sexy_models	{"archive_field":"status","archive_value":"archived","unarchive_value":"draft","singleton":false,"collection":"sexy_models"}	{"archive_field":"status","archive_value":"archived","unarchive_value":"draft","singleton":false,"collection":"sexy_models"}	\N	\N
224	268	directus_collections	sexy_models	{"collection":"sexy_models","icon":"star_shine","note":null,"display_template":null,"hidden":false,"singleton":false,"translations":[{"language":"en-US","translation":"Sexy Models","singular":"Model","plural":"Models"}],"archive_field":"status","archive_app_filter":true,"archive_value":"archived","unarchive_value":"draft","sort_field":null,"accountability":"all","color":null,"item_duplication_fields":null,"sort":null,"group":null,"collapse":"open","preview_url":null,"versioning":true}	{"icon":"star_shine","translations":[{"language":"en-US","translation":"Sexy Models","singular":"Model","plural":"Models"}],"versioning":true}	\N	\N
225	269	directus_fields	51	{"sort":6,"interface":"input","special":null,"required":true,"collection":"sexy_models","field":"slug"}	{"sort":6,"interface":"input","special":null,"required":true,"collection":"sexy_models","field":"slug"}	\N	\N
226	270	directus_fields	51	{"id":51,"collection":"sexy_models","field":"slug","special":null,"interface":"input","options":{"slug":true,"trim":true},"display":null,"display_options":null,"readonly":false,"hidden":false,"sort":6,"width":"full","translations":null,"note":null,"conditions":null,"required":true,"group":null,"validation":null,"validation_message":null}	{"collection":"sexy_models","field":"slug","options":{"slug":true,"trim":true}}	\N	\N
227	271	directus_fields	52	{"sort":7,"interface":"input","special":null,"required":true,"collection":"sexy_models","field":"name"}	{"sort":7,"interface":"input","special":null,"required":true,"collection":"sexy_models","field":"name"}	\N	\N
228	272	directus_folders	3c744e72-03ef-432d-9c16-ac0a343b2499	{"name":"models","parent":"c214c905-885b-4d66-a6a1-6527b0606200"}	{"name":"models","parent":"c214c905-885b-4d66-a6a1-6527b0606200"}	\N	\N
229	273	directus_folders	7360b85c-3bb7-4334-ba81-2f46575ea056	{"name":"videos","parent":"c214c905-885b-4d66-a6a1-6527b0606200"}	{"name":"videos","parent":"c214c905-885b-4d66-a6a1-6527b0606200"}	\N	\N
230	274	directus_fields	53	{"sort":8,"interface":"file-image","special":["file"],"required":true,"options":{"folder":"3c744e72-03ef-432d-9c16-ac0a343b2499"},"collection":"sexy_models","field":"image"}	{"sort":8,"interface":"file-image","special":["file"],"required":true,"options":{"folder":"3c744e72-03ef-432d-9c16-ac0a343b2499"},"collection":"sexy_models","field":"image"}	\N	\N
231	275	directus_fields	54	{"sort":9,"interface":"tags","special":["cast-json"],"options":{"whitespace":"","capitalization":"auto-format"},"collection":"sexy_models","field":"tags"}	{"sort":9,"interface":"tags","special":["cast-json"],"options":{"whitespace":"","capitalization":"auto-format"},"collection":"sexy_models","field":"tags"}	\N	\N
232	276	directus_fields	55	{"sort":10,"interface":"input","special":null,"collection":"sexy_models","field":"category"}	{"sort":10,"interface":"input","special":null,"collection":"sexy_models","field":"category"}	\N	\N
233	277	directus_permissions	34	{"policy":"abf8a154-5b1c-4a46-ac9c-7300570f4f17","permissions":null,"validation":null,"fields":["*"],"presets":null,"collection":"sexy_models","action":"read"}	{"policy":"abf8a154-5b1c-4a46-ac9c-7300570f4f17","permissions":null,"validation":null,"fields":["*"],"presets":null,"collection":"sexy_models","action":"read"}	\N	\N
234	279	directus_settings	1	{"id":1,"project_name":"Sexy.Art","project_url":"https://sexy.pivoine.art","project_color":"#6644FF","project_logo":"8ad7e858-0c83-4d88-bb50-3680f1cfa9c2","public_foreground":null,"public_background":null,"public_note":"Where Love Meets Artistry","auth_login_attempts":25,"auth_password_policy":"/(?=^.{8,}$)(?=.*\\\\d)(?=.*[a-z])(?=.*[A-Z])(?=.*[!@#$%^&*()_+}{';'?>.<,])(?!.*\\\\s).*$/","storage_asset_transform":"presets","storage_asset_presets":[{"key":"sexy-thumbnail","fit":"cover","width":600,"height":null,"quality":80,"withoutEnlargement":true,"format":"webp","transforms":[]},{"key":"sexy-banner","fit":"cover","width":1920,"quality":80,"withoutEnlargement":false,"format":"webp","transforms":[]},{"key":"sexy-preview","fit":"cover","width":1080,"quality":80,"withoutEnlargement":true,"format":"webp","transforms":[]}],"custom_css":null,"storage_default_folder":"c214c905-885b-4d66-a6a1-6527b0606200","basemaps":null,"mapbox_key":null,"module_bar":[{"type":"module","id":"content","enabled":true},{"type":"module","id":"visual","enabled":false},{"type":"module","id":"users","enabled":true},{"type":"module","id":"files","enabled":true},{"type":"module","id":"insights","enabled":true},{"type":"link","id":"docs","enabled":true,"name":"$t:documentation","icon":"help","url":"https://docs.directus.io"},{"type":"module","id":"settings","enabled":true,"locked":true},{"id":"JpYiQQKgf-i3unxAY1efo","type":"link","enabled":true,"url":"/files/sexy","name":"Sexy Videos","icon":"videocam"}],"project_descriptor":null,"default_language":"en-US","custom_aspect_ratios":null,"public_favicon":null,"default_appearance":"auto","default_theme_light":null,"theme_light_overrides":null,"default_theme_dark":null,"theme_dark_overrides":null,"report_error_url":null,"report_bug_url":null,"report_feature_url":null,"public_registration":true,"public_registration_verify_email":true,"public_registration_role":"a1300aaa-0205-47d8-97a7-6166ac924e50","public_registration_email_filter":null,"visual_editor_urls":null,"accepted_terms":true,"project_id":"01991b80-eceb-7715-aebb-b0b1fbf67973"}	{"storage_asset_presets":[{"key":"sexy-thumbnail","fit":"cover","width":600,"height":null,"quality":80,"withoutEnlargement":true,"format":"webp","transforms":[]},{"key":"sexy-banner","fit":"cover","width":1920,"quality":80,"withoutEnlargement":false,"format":"webp","transforms":[]},{"key":"sexy-preview","fit":"cover","width":1080,"quality":80,"withoutEnlargement":true,"format":"webp","transforms":[]}]}	\N	\N
253	298	directus_fields	46	{"id":46,"collection":"sexy_models","field":"id","special":["uuid"],"interface":"input","options":null,"display":null,"display_options":null,"readonly":true,"hidden":true,"sort":1,"width":"full","translations":null,"note":null,"conditions":null,"required":false,"group":null,"validation":null,"validation_message":null}	{"collection":"sexy_models","field":"id","sort":1,"group":null}	\N	\N
280	325	directus_fields	55	{"id":55,"collection":"sexy_models","field":"category","special":null,"interface":"input","options":null,"display":null,"display_options":null,"readonly":false,"hidden":false,"sort":13,"width":"full","translations":null,"note":null,"conditions":null,"required":false,"group":null,"validation":null,"validation_message":null}	{"collection":"sexy_models","field":"category","sort":13,"group":null}	\N	\N
235	280	directus_settings	1	{"id":1,"project_name":"Sexy.Art","project_url":"https://sexy.pivoine.art","project_color":"#6644FF","project_logo":"8ad7e858-0c83-4d88-bb50-3680f1cfa9c2","public_foreground":null,"public_background":null,"public_note":"Where Love Meets Artistry","auth_login_attempts":25,"auth_password_policy":"/(?=^.{8,}$)(?=.*\\\\d)(?=.*[a-z])(?=.*[A-Z])(?=.*[!@#$%^&*()_+}{';'?>.<,])(?!.*\\\\s).*$/","storage_asset_transform":"presets","storage_asset_presets":null,"custom_css":null,"storage_default_folder":"c214c905-885b-4d66-a6a1-6527b0606200","basemaps":null,"mapbox_key":null,"module_bar":[{"type":"module","id":"content","enabled":true},{"type":"module","id":"visual","enabled":false},{"type":"module","id":"users","enabled":true},{"type":"module","id":"files","enabled":true},{"type":"module","id":"insights","enabled":true},{"type":"link","id":"docs","enabled":true,"name":"$t:documentation","icon":"help","url":"https://docs.directus.io"},{"type":"module","id":"settings","enabled":true,"locked":true},{"id":"JpYiQQKgf-i3unxAY1efo","type":"link","enabled":true,"url":"/files/sexy","name":"Sexy Videos","icon":"videocam"}],"project_descriptor":null,"default_language":"en-US","custom_aspect_ratios":null,"public_favicon":null,"default_appearance":"auto","default_theme_light":null,"theme_light_overrides":null,"default_theme_dark":null,"theme_dark_overrides":null,"report_error_url":null,"report_bug_url":null,"report_feature_url":null,"public_registration":true,"public_registration_verify_email":true,"public_registration_role":"a1300aaa-0205-47d8-97a7-6166ac924e50","public_registration_email_filter":null,"visual_editor_urls":null,"accepted_terms":true,"project_id":"01991b80-eceb-7715-aebb-b0b1fbf67973"}	{"storage_asset_presets":null}	\N	\N
237	282	directus_settings	1	{"id":1,"project_name":"Sexy.Art","project_url":"https://sexy.pivoine.art","project_color":"#6644FF","project_logo":"8ad7e858-0c83-4d88-bb50-3680f1cfa9c2","public_foreground":null,"public_background":null,"public_note":"Where Love Meets Artistry","auth_login_attempts":25,"auth_password_policy":"/(?=^.{8,}$)(?=.*\\\\d)(?=.*[a-z])(?=.*[A-Z])(?=.*[!@#$%^&*()_+}{';'?>.<,])(?!.*\\\\s).*$/","storage_asset_transform":"presets","storage_asset_presets":[{"key":"mini","fit":"cover","width":300,"height":300,"quality":80,"withoutEnlargement":false,"format":"webp","transforms":[]},{"key":"thumbnail","fit":"cover","width":600,"height":400,"quality":80,"withoutEnlargement":false,"format":"webp","transforms":[]},{"key":"medium","fit":"cover","width":1200,"height":900,"quality":80,"withoutEnlargement":false,"format":"webp","transforms":[]},{"key":"banner","fit":"cover","width":2000,"height":1000,"quality":80,"withoutEnlargement":false,"format":"webp","transforms":[]}],"custom_css":null,"storage_default_folder":"c214c905-885b-4d66-a6a1-6527b0606200","basemaps":null,"mapbox_key":null,"module_bar":[{"type":"module","id":"content","enabled":true},{"type":"module","id":"visual","enabled":false},{"type":"module","id":"users","enabled":true},{"type":"module","id":"files","enabled":true},{"type":"module","id":"insights","enabled":true},{"type":"link","id":"docs","enabled":true,"name":"$t:documentation","icon":"help","url":"https://docs.directus.io"},{"type":"module","id":"settings","enabled":true,"locked":true},{"id":"JpYiQQKgf-i3unxAY1efo","type":"link","enabled":true,"url":"/files/sexy","name":"Sexy Videos","icon":"videocam"}],"project_descriptor":null,"default_language":"en-US","custom_aspect_ratios":null,"public_favicon":null,"default_appearance":"auto","default_theme_light":null,"theme_light_overrides":null,"default_theme_dark":null,"theme_dark_overrides":null,"report_error_url":null,"report_bug_url":null,"report_feature_url":null,"public_registration":true,"public_registration_verify_email":true,"public_registration_role":"a1300aaa-0205-47d8-97a7-6166ac924e50","public_registration_email_filter":null,"visual_editor_urls":null,"accepted_terms":true,"project_id":"01991b80-eceb-7715-aebb-b0b1fbf67973"}	{"storage_asset_presets":[{"key":"mini","fit":"cover","width":300,"height":300,"quality":80,"withoutEnlargement":false,"format":"webp","transforms":[]},{"key":"thumbnail","fit":"cover","width":600,"height":400,"quality":80,"withoutEnlargement":false,"format":"webp","transforms":[]},{"key":"medium","fit":"cover","width":1200,"height":900,"quality":80,"withoutEnlargement":false,"format":"webp","transforms":[]},{"key":"banner","fit":"cover","width":2000,"height":1000,"quality":80,"withoutEnlargement":false,"format":"webp","transforms":[]}]}	\N	\N
254	299	directus_fields	47	{"id":47,"collection":"sexy_models","field":"status","special":null,"interface":"select-dropdown","options":{"choices":[{"text":"$t:published","value":"published","color":"var(--theme--primary)"},{"text":"$t:draft","value":"draft","color":"var(--theme--foreground)"},{"text":"$t:archived","value":"archived","color":"var(--theme--warning)"}]},"display":"labels","display_options":{"showAsDot":true,"choices":[{"text":"$t:published","value":"published","color":"var(--theme--primary)","foreground":"var(--theme--primary)","background":"var(--theme--primary-background)"},{"text":"$t:draft","value":"draft","color":"var(--theme--foreground)","foreground":"var(--theme--foreground)","background":"var(--theme--background-normal)"},{"text":"$t:archived","value":"archived","color":"var(--theme--warning)","foreground":"var(--theme--warning)","background":"var(--theme--warning-background)"}]},"readonly":false,"hidden":false,"sort":2,"width":"full","translations":null,"note":null,"conditions":null,"required":false,"group":null,"validation":null,"validation_message":null}	{"collection":"sexy_models","field":"status","sort":2,"group":null}	\N	\N
236	281	directus_settings	1	{"id":1,"project_name":"Sexy.Art","project_url":"https://sexy.pivoine.art","project_color":"#6644FF","project_logo":"8ad7e858-0c83-4d88-bb50-3680f1cfa9c2","public_foreground":null,"public_background":null,"public_note":"Where Love Meets Artistry","auth_login_attempts":25,"auth_password_policy":"/(?=^.{8,}$)(?=.*\\\\d)(?=.*[a-z])(?=.*[A-Z])(?=.*[!@#$%^&*()_+}{';'?>.<,])(?!.*\\\\s).*$/","storage_asset_transform":"presets","storage_asset_presets":[{"key":"mini","fit":"cover","width":300,"height":300,"quality":80,"withoutEnlargement":false,"format":"webp","transforms":[]}],"custom_css":null,"storage_default_folder":"c214c905-885b-4d66-a6a1-6527b0606200","basemaps":null,"mapbox_key":null,"module_bar":[{"type":"module","id":"content","enabled":true},{"type":"module","id":"visual","enabled":false},{"type":"module","id":"users","enabled":true},{"type":"module","id":"files","enabled":true},{"type":"module","id":"insights","enabled":true},{"type":"link","id":"docs","enabled":true,"name":"$t:documentation","icon":"help","url":"https://docs.directus.io"},{"type":"module","id":"settings","enabled":true,"locked":true},{"id":"JpYiQQKgf-i3unxAY1efo","type":"link","enabled":true,"url":"/files/sexy","name":"Sexy Videos","icon":"videocam"}],"project_descriptor":null,"default_language":"en-US","custom_aspect_ratios":null,"public_favicon":null,"default_appearance":"auto","default_theme_light":null,"theme_light_overrides":null,"default_theme_dark":null,"theme_dark_overrides":null,"report_error_url":null,"report_bug_url":null,"report_feature_url":null,"public_registration":true,"public_registration_verify_email":true,"public_registration_role":"a1300aaa-0205-47d8-97a7-6166ac924e50","public_registration_email_filter":null,"visual_editor_urls":null,"accepted_terms":true,"project_id":"01991b80-eceb-7715-aebb-b0b1fbf67973"}	{"storage_asset_presets":[{"key":"mini","fit":"cover","width":300,"height":300,"quality":80,"withoutEnlargement":false,"format":"webp","transforms":[]}]}	\N	\N
238	283	directus_fields	56	{"sort":11,"interface":"file-image","special":["file"],"required":false,"options":{"folder":"3c744e72-03ef-432d-9c16-ac0a343b2499"},"collection":"sexy_models","field":"banner_image"}	{"sort":11,"interface":"file-image","special":["file"],"required":false,"options":{"folder":"3c744e72-03ef-432d-9c16-ac0a343b2499"},"collection":"sexy_models","field":"banner_image"}	\N	\N
239	284	directus_fields	57	{"sort":12,"interface":"input-rich-text-html","special":null,"required":true,"options":{"toolbar":["bold","italic","underline","h2","h3","numlist","bullist","removeformat","blockquote","customLink","hr","fullscreen","code"]},"collection":"sexy_models","field":"bio"}	{"sort":12,"interface":"input-rich-text-html","special":null,"required":true,"options":{"toolbar":["bold","italic","underline","h2","h3","numlist","bullist","removeformat","blockquote","customLink","hr","fullscreen","code"]},"collection":"sexy_models","field":"bio"}	\N	\N
240	285	directus_fields	46	{"id":46,"collection":"sexy_models","field":"id","special":["uuid"],"interface":"input","options":null,"display":null,"display_options":null,"readonly":true,"hidden":true,"sort":1,"width":"full","translations":null,"note":null,"conditions":null,"required":false,"group":null,"validation":null,"validation_message":null}	{"collection":"sexy_models","field":"id","sort":1,"group":null}	\N	\N
241	286	directus_fields	47	{"id":47,"collection":"sexy_models","field":"status","special":null,"interface":"select-dropdown","options":{"choices":[{"text":"$t:published","value":"published","color":"var(--theme--primary)"},{"text":"$t:draft","value":"draft","color":"var(--theme--foreground)"},{"text":"$t:archived","value":"archived","color":"var(--theme--warning)"}]},"display":"labels","display_options":{"showAsDot":true,"choices":[{"text":"$t:published","value":"published","color":"var(--theme--primary)","foreground":"var(--theme--primary)","background":"var(--theme--primary-background)"},{"text":"$t:draft","value":"draft","color":"var(--theme--foreground)","foreground":"var(--theme--foreground)","background":"var(--theme--background-normal)"},{"text":"$t:archived","value":"archived","color":"var(--theme--warning)","foreground":"var(--theme--warning)","background":"var(--theme--warning-background)"}]},"readonly":false,"hidden":false,"sort":2,"width":"full","translations":null,"note":null,"conditions":null,"required":false,"group":null,"validation":null,"validation_message":null}	{"collection":"sexy_models","field":"status","sort":2,"group":null}	\N	\N
242	287	directus_fields	48	{"id":48,"collection":"sexy_models","field":"user_created","special":["user-created"],"interface":"select-dropdown-m2o","options":{"template":"{{avatar}} {{first_name}} {{last_name}}"},"display":"user","display_options":null,"readonly":true,"hidden":true,"sort":3,"width":"half","translations":null,"note":null,"conditions":null,"required":false,"group":null,"validation":null,"validation_message":null}	{"collection":"sexy_models","field":"user_created","sort":3,"group":null}	\N	\N
243	288	directus_fields	49	{"id":49,"collection":"sexy_models","field":"date_created","special":["date-created"],"interface":"datetime","options":null,"display":"datetime","display_options":{"relative":true},"readonly":true,"hidden":true,"sort":4,"width":"half","translations":null,"note":null,"conditions":null,"required":false,"group":null,"validation":null,"validation_message":null}	{"collection":"sexy_models","field":"date_created","sort":4,"group":null}	\N	\N
244	289	directus_fields	50	{"id":50,"collection":"sexy_models","field":"date_updated","special":["date-updated"],"interface":"datetime","options":null,"display":"datetime","display_options":{"relative":true},"readonly":true,"hidden":true,"sort":5,"width":"half","translations":null,"note":null,"conditions":null,"required":false,"group":null,"validation":null,"validation_message":null}	{"collection":"sexy_models","field":"date_updated","sort":5,"group":null}	\N	\N
245	290	directus_fields	51	{"id":51,"collection":"sexy_models","field":"slug","special":null,"interface":"input","options":{"slug":true,"trim":true},"display":null,"display_options":null,"readonly":false,"hidden":false,"sort":6,"width":"full","translations":null,"note":null,"conditions":null,"required":true,"group":null,"validation":null,"validation_message":null}	{"collection":"sexy_models","field":"slug","sort":6,"group":null}	\N	\N
246	291	directus_fields	52	{"id":52,"collection":"sexy_models","field":"name","special":null,"interface":"input","options":null,"display":null,"display_options":null,"readonly":false,"hidden":false,"sort":7,"width":"full","translations":null,"note":null,"conditions":null,"required":true,"group":null,"validation":null,"validation_message":null}	{"collection":"sexy_models","field":"name","sort":7,"group":null}	\N	\N
247	292	directus_fields	57	{"id":57,"collection":"sexy_models","field":"bio","special":null,"interface":"input-rich-text-html","options":{"toolbar":["bold","italic","underline","h2","h3","numlist","bullist","removeformat","blockquote","customLink","hr","fullscreen","code"]},"display":null,"display_options":null,"readonly":false,"hidden":false,"sort":8,"width":"full","translations":null,"note":null,"conditions":null,"required":true,"group":null,"validation":null,"validation_message":null}	{"collection":"sexy_models","field":"bio","sort":8,"group":null}	\N	\N
248	293	directus_fields	53	{"id":53,"collection":"sexy_models","field":"image","special":["file"],"interface":"file-image","options":{"folder":"3c744e72-03ef-432d-9c16-ac0a343b2499"},"display":null,"display_options":null,"readonly":false,"hidden":false,"sort":9,"width":"full","translations":null,"note":null,"conditions":null,"required":true,"group":null,"validation":null,"validation_message":null}	{"collection":"sexy_models","field":"image","sort":9,"group":null}	\N	\N
249	294	directus_fields	54	{"id":54,"collection":"sexy_models","field":"tags","special":["cast-json"],"interface":"tags","options":{"whitespace":"","capitalization":"auto-format"},"display":null,"display_options":null,"readonly":false,"hidden":false,"sort":10,"width":"full","translations":null,"note":null,"conditions":null,"required":false,"group":null,"validation":null,"validation_message":null}	{"collection":"sexy_models","field":"tags","sort":10,"group":null}	\N	\N
255	300	directus_fields	48	{"id":48,"collection":"sexy_models","field":"user_created","special":["user-created"],"interface":"select-dropdown-m2o","options":{"template":"{{avatar}} {{first_name}} {{last_name}}"},"display":"user","display_options":null,"readonly":true,"hidden":true,"sort":3,"width":"half","translations":null,"note":null,"conditions":null,"required":false,"group":null,"validation":null,"validation_message":null}	{"collection":"sexy_models","field":"user_created","sort":3,"group":null}	\N	\N
256	301	directus_fields	49	{"id":49,"collection":"sexy_models","field":"date_created","special":["date-created"],"interface":"datetime","options":null,"display":"datetime","display_options":{"relative":true},"readonly":true,"hidden":true,"sort":4,"width":"half","translations":null,"note":null,"conditions":null,"required":false,"group":null,"validation":null,"validation_message":null}	{"collection":"sexy_models","field":"date_created","sort":4,"group":null}	\N	\N
257	302	directus_fields	50	{"id":50,"collection":"sexy_models","field":"date_updated","special":["date-updated"],"interface":"datetime","options":null,"display":"datetime","display_options":{"relative":true},"readonly":true,"hidden":true,"sort":5,"width":"half","translations":null,"note":null,"conditions":null,"required":false,"group":null,"validation":null,"validation_message":null}	{"collection":"sexy_models","field":"date_updated","sort":5,"group":null}	\N	\N
258	303	directus_fields	51	{"id":51,"collection":"sexy_models","field":"slug","special":null,"interface":"input","options":{"slug":true,"trim":true},"display":null,"display_options":null,"readonly":false,"hidden":false,"sort":6,"width":"full","translations":null,"note":null,"conditions":null,"required":true,"group":null,"validation":null,"validation_message":null}	{"collection":"sexy_models","field":"slug","sort":6,"group":null}	\N	\N
259	304	directus_fields	52	{"id":52,"collection":"sexy_models","field":"name","special":null,"interface":"input","options":null,"display":null,"display_options":null,"readonly":false,"hidden":false,"sort":7,"width":"full","translations":null,"note":null,"conditions":null,"required":true,"group":null,"validation":null,"validation_message":null}	{"collection":"sexy_models","field":"name","sort":7,"group":null}	\N	\N
260	305	directus_fields	58	{"id":58,"collection":"sexy_models","field":"join_date","special":null,"interface":"datetime","options":null,"display":null,"display_options":null,"readonly":false,"hidden":false,"sort":8,"width":"full","translations":null,"note":null,"conditions":null,"required":true,"group":null,"validation":null,"validation_message":null}	{"collection":"sexy_models","field":"join_date","sort":8,"group":null}	\N	\N
261	306	directus_fields	57	{"id":57,"collection":"sexy_models","field":"bio","special":null,"interface":"input-rich-text-html","options":{"toolbar":["bold","italic","underline","h2","h3","numlist","bullist","removeformat","blockquote","customLink","hr","fullscreen","code"]},"display":null,"display_options":null,"readonly":false,"hidden":false,"sort":9,"width":"full","translations":null,"note":null,"conditions":null,"required":true,"group":null,"validation":null,"validation_message":null}	{"collection":"sexy_models","field":"bio","sort":9,"group":null}	\N	\N
262	307	directus_fields	53	{"id":53,"collection":"sexy_models","field":"image","special":["file"],"interface":"file-image","options":{"folder":"3c744e72-03ef-432d-9c16-ac0a343b2499"},"display":null,"display_options":null,"readonly":false,"hidden":false,"sort":10,"width":"full","translations":null,"note":null,"conditions":null,"required":true,"group":null,"validation":null,"validation_message":null}	{"collection":"sexy_models","field":"image","sort":10,"group":null}	\N	\N
263	308	directus_fields	54	{"id":54,"collection":"sexy_models","field":"tags","special":["cast-json"],"interface":"tags","options":{"whitespace":"","capitalization":"auto-format"},"display":null,"display_options":null,"readonly":false,"hidden":false,"sort":11,"width":"full","translations":null,"note":null,"conditions":null,"required":false,"group":null,"validation":null,"validation_message":null}	{"collection":"sexy_models","field":"tags","sort":11,"group":null}	\N	\N
264	309	directus_fields	55	{"id":55,"collection":"sexy_models","field":"category","special":null,"interface":"input","options":null,"display":null,"display_options":null,"readonly":false,"hidden":false,"sort":12,"width":"full","translations":null,"note":null,"conditions":null,"required":false,"group":null,"validation":null,"validation_message":null}	{"collection":"sexy_models","field":"category","sort":12,"group":null}	\N	\N
265	310	directus_fields	56	{"id":56,"collection":"sexy_models","field":"banner_image","special":["file"],"interface":"file-image","options":{"folder":"3c744e72-03ef-432d-9c16-ac0a343b2499"},"display":null,"display_options":null,"readonly":false,"hidden":false,"sort":13,"width":"full","translations":null,"note":null,"conditions":null,"required":false,"group":null,"validation":null,"validation_message":null}	{"collection":"sexy_models","field":"banner_image","sort":13,"group":null}	\N	\N
278	323	directus_fields	53	{"id":53,"collection":"sexy_models","field":"image","special":["file"],"interface":"file-image","options":{"folder":"3c744e72-03ef-432d-9c16-ac0a343b2499"},"display":null,"display_options":null,"readonly":false,"hidden":false,"sort":11,"width":"full","translations":null,"note":null,"conditions":null,"required":true,"group":null,"validation":null,"validation_message":null}	{"collection":"sexy_models","field":"image","sort":11,"group":null}	\N	\N
279	324	directus_fields	54	{"id":54,"collection":"sexy_models","field":"tags","special":["cast-json"],"interface":"tags","options":{"whitespace":"","capitalization":"auto-format"},"display":null,"display_options":null,"readonly":false,"hidden":false,"sort":12,"width":"full","translations":null,"note":null,"conditions":null,"required":false,"group":null,"validation":null,"validation_message":null}	{"collection":"sexy_models","field":"tags","sort":12,"group":null}	\N	\N
311	357	directus_fields	52	{"id":52,"collection":"sexy_models","field":"name","special":null,"interface":"input","options":null,"display":null,"display_options":null,"readonly":false,"hidden":false,"sort":7,"width":"full","translations":null,"note":null,"conditions":null,"required":true,"group":null,"validation":null,"validation_message":null}	{"collection":"sexy_models","field":"name","sort":7,"group":null}	\N	\N
326	376	directus_permissions	36	{"policy":"abf8a154-5b1c-4a46-ac9c-7300570f4f17","permissions":null,"validation":null,"fields":["*"],"presets":null,"collection":"directus_files","action":"read"}	{"policy":"abf8a154-5b1c-4a46-ac9c-7300570f4f17","permissions":null,"validation":null,"fields":["*"],"presets":null,"collection":"directus_files","action":"read"}	\N	\N
329	394	directus_collections	sexy_articles	{"collection":"sexy_articles","icon":"newsmode","note":null,"display_template":null,"hidden":false,"singleton":false,"translations":[{"language":"en-US","translation":"Sexy Articles","singular":"Article","plural":"Articles"}],"archive_field":"status","archive_app_filter":true,"archive_value":"archived","unarchive_value":"draft","sort_field":null,"accountability":"all","color":null,"item_duplication_fields":null,"sort":null,"group":null,"collapse":"open","preview_url":null,"versioning":true}	{"icon":"newsmode"}	\N	\N
266	311	directus_settings	1	{"id":1,"project_name":"Sexy.Art","project_url":"https://sexy.pivoine.art","project_color":"#6644FF","project_logo":"8ad7e858-0c83-4d88-bb50-3680f1cfa9c2","public_foreground":null,"public_background":null,"public_note":"Where Love Meets Artistry","auth_login_attempts":25,"auth_password_policy":"/(?=^.{8,}$)(?=.*\\\\d)(?=.*[a-z])(?=.*[A-Z])(?=.*[!@#$%^&*()_+}{';'?>.<,])(?!.*\\\\s).*$/","storage_asset_transform":"presets","storage_asset_presets":[{"key":"mini","fit":"cover","width":300,"height":300,"quality":80,"withoutEnlargement":false,"format":"webp","transforms":[]},{"key":"preview","fit":"cover","width":600,"height":400,"quality":80,"withoutEnlargement":false,"format":"webp","transforms":[]},{"key":"medium","fit":"cover","width":1200,"height":900,"quality":80,"withoutEnlargement":false,"format":"webp","transforms":[]},{"key":"banner","fit":"cover","width":2000,"height":1000,"quality":80,"withoutEnlargement":false,"format":"webp","transforms":[]},{"key":"thumbnail","fit":"cover","width":600,"height":600,"quality":80,"withoutEnlargement":false,"format":"webp","transforms":[]}],"custom_css":null,"storage_default_folder":"c214c905-885b-4d66-a6a1-6527b0606200","basemaps":null,"mapbox_key":null,"module_bar":[{"type":"module","id":"content","enabled":true},{"type":"module","id":"visual","enabled":false},{"type":"module","id":"users","enabled":true},{"type":"module","id":"files","enabled":true},{"type":"module","id":"insights","enabled":true},{"type":"link","id":"docs","enabled":true,"name":"$t:documentation","icon":"help","url":"https://docs.directus.io"},{"type":"module","id":"settings","enabled":true,"locked":true},{"id":"JpYiQQKgf-i3unxAY1efo","type":"link","enabled":true,"url":"/files/sexy","name":"Sexy Videos","icon":"videocam"}],"project_descriptor":null,"default_language":"en-US","custom_aspect_ratios":null,"public_favicon":null,"default_appearance":"auto","default_theme_light":null,"theme_light_overrides":null,"default_theme_dark":null,"theme_dark_overrides":null,"report_error_url":null,"report_bug_url":null,"report_feature_url":null,"public_registration":true,"public_registration_verify_email":true,"public_registration_role":"a1300aaa-0205-47d8-97a7-6166ac924e50","public_registration_email_filter":null,"visual_editor_urls":null,"accepted_terms":true,"project_id":"01991b80-eceb-7715-aebb-b0b1fbf67973"}	{"storage_asset_presets":[{"key":"mini","fit":"cover","width":300,"height":300,"quality":80,"withoutEnlargement":false,"format":"webp","transforms":[]},{"key":"preview","fit":"cover","width":600,"height":400,"quality":80,"withoutEnlargement":false,"format":"webp","transforms":[]},{"key":"medium","fit":"cover","width":1200,"height":900,"quality":80,"withoutEnlargement":false,"format":"webp","transforms":[]},{"key":"banner","fit":"cover","width":2000,"height":1000,"quality":80,"withoutEnlargement":false,"format":"webp","transforms":[]},{"key":"thumbnail","fit":"cover","width":600,"height":600,"quality":80,"withoutEnlargement":false,"format":"webp","transforms":[]}]}	\N	\N
267	312	directus_fields	59	{"sort":14,"interface":"select-dropdown-m2o","special":["m2o"],"required":true,"options":{"enableLink":true},"collection":"sexy_models","field":"user"}	{"sort":14,"interface":"select-dropdown-m2o","special":["m2o"],"required":true,"options":{"enableLink":true},"collection":"sexy_models","field":"user"}	\N	\N
268	313	directus_fields	46	{"id":46,"collection":"sexy_models","field":"id","special":["uuid"],"interface":"input","options":null,"display":null,"display_options":null,"readonly":true,"hidden":true,"sort":1,"width":"full","translations":null,"note":null,"conditions":null,"required":false,"group":null,"validation":null,"validation_message":null}	{"collection":"sexy_models","field":"id","sort":1,"group":null}	\N	\N
269	314	directus_fields	47	{"id":47,"collection":"sexy_models","field":"status","special":null,"interface":"select-dropdown","options":{"choices":[{"text":"$t:published","value":"published","color":"var(--theme--primary)"},{"text":"$t:draft","value":"draft","color":"var(--theme--foreground)"},{"text":"$t:archived","value":"archived","color":"var(--theme--warning)"}]},"display":"labels","display_options":{"showAsDot":true,"choices":[{"text":"$t:published","value":"published","color":"var(--theme--primary)","foreground":"var(--theme--primary)","background":"var(--theme--primary-background)"},{"text":"$t:draft","value":"draft","color":"var(--theme--foreground)","foreground":"var(--theme--foreground)","background":"var(--theme--background-normal)"},{"text":"$t:archived","value":"archived","color":"var(--theme--warning)","foreground":"var(--theme--warning)","background":"var(--theme--warning-background)"}]},"readonly":false,"hidden":false,"sort":2,"width":"full","translations":null,"note":null,"conditions":null,"required":false,"group":null,"validation":null,"validation_message":null}	{"collection":"sexy_models","field":"status","sort":2,"group":null}	\N	\N
270	315	directus_fields	48	{"id":48,"collection":"sexy_models","field":"user_created","special":["user-created"],"interface":"select-dropdown-m2o","options":{"template":"{{avatar}} {{first_name}} {{last_name}}"},"display":"user","display_options":null,"readonly":true,"hidden":true,"sort":3,"width":"half","translations":null,"note":null,"conditions":null,"required":false,"group":null,"validation":null,"validation_message":null}	{"collection":"sexy_models","field":"user_created","sort":3,"group":null}	\N	\N
271	316	directus_fields	49	{"id":49,"collection":"sexy_models","field":"date_created","special":["date-created"],"interface":"datetime","options":null,"display":"datetime","display_options":{"relative":true},"readonly":true,"hidden":true,"sort":4,"width":"half","translations":null,"note":null,"conditions":null,"required":false,"group":null,"validation":null,"validation_message":null}	{"collection":"sexy_models","field":"date_created","sort":4,"group":null}	\N	\N
272	317	directus_fields	50	{"id":50,"collection":"sexy_models","field":"date_updated","special":["date-updated"],"interface":"datetime","options":null,"display":"datetime","display_options":{"relative":true},"readonly":true,"hidden":true,"sort":5,"width":"half","translations":null,"note":null,"conditions":null,"required":false,"group":null,"validation":null,"validation_message":null}	{"collection":"sexy_models","field":"date_updated","sort":5,"group":null}	\N	\N
273	318	directus_fields	51	{"id":51,"collection":"sexy_models","field":"slug","special":null,"interface":"input","options":{"slug":true,"trim":true},"display":null,"display_options":null,"readonly":false,"hidden":false,"sort":6,"width":"full","translations":null,"note":null,"conditions":null,"required":true,"group":null,"validation":null,"validation_message":null}	{"collection":"sexy_models","field":"slug","sort":6,"group":null}	\N	\N
274	319	directus_fields	52	{"id":52,"collection":"sexy_models","field":"name","special":null,"interface":"input","options":null,"display":null,"display_options":null,"readonly":false,"hidden":false,"sort":7,"width":"full","translations":null,"note":null,"conditions":null,"required":true,"group":null,"validation":null,"validation_message":null}	{"collection":"sexy_models","field":"name","sort":7,"group":null}	\N	\N
275	320	directus_fields	58	{"id":58,"collection":"sexy_models","field":"join_date","special":null,"interface":"datetime","options":null,"display":null,"display_options":null,"readonly":false,"hidden":false,"sort":8,"width":"full","translations":null,"note":null,"conditions":null,"required":true,"group":null,"validation":null,"validation_message":null}	{"collection":"sexy_models","field":"join_date","sort":8,"group":null}	\N	\N
276	321	directus_fields	59	{"id":59,"collection":"sexy_models","field":"user","special":["m2o"],"interface":"select-dropdown-m2o","options":{"enableLink":true},"display":null,"display_options":null,"readonly":false,"hidden":false,"sort":9,"width":"full","translations":null,"note":null,"conditions":null,"required":true,"group":null,"validation":null,"validation_message":null}	{"collection":"sexy_models","field":"user","sort":9,"group":null}	\N	\N
277	322	directus_fields	57	{"id":57,"collection":"sexy_models","field":"bio","special":null,"interface":"input-rich-text-html","options":{"toolbar":["bold","italic","underline","h2","h3","numlist","bullist","removeformat","blockquote","customLink","hr","fullscreen","code"]},"display":null,"display_options":null,"readonly":false,"hidden":false,"sort":10,"width":"full","translations":null,"note":null,"conditions":null,"required":true,"group":null,"validation":null,"validation_message":null}	{"collection":"sexy_models","field":"bio","sort":10,"group":null}	\N	\N
281	326	directus_fields	56	{"id":56,"collection":"sexy_models","field":"banner_image","special":["file"],"interface":"file-image","options":{"folder":"3c744e72-03ef-432d-9c16-ac0a343b2499"},"display":null,"display_options":null,"readonly":false,"hidden":false,"sort":14,"width":"full","translations":null,"note":null,"conditions":null,"required":false,"group":null,"validation":null,"validation_message":null}	{"collection":"sexy_models","field":"banner_image","sort":14,"group":null}	\N	\N
282	327	directus_fields	59	{"id":59,"collection":"sexy_models","field":"user","special":["m2o"],"interface":"select-dropdown-m2o","options":{"enableLink":true,"filter":{"_and":[{"policies":{"policy":{"name":{"_eq":"Creator"}}}}]}},"display":null,"display_options":null,"readonly":false,"hidden":false,"sort":9,"width":"full","translations":null,"note":null,"conditions":null,"required":true,"group":null,"validation":null,"validation_message":null}	{"collection":"sexy_models","field":"user","options":{"enableLink":true,"filter":{"_and":[{"policies":{"policy":{"name":{"_eq":"Creator"}}}}]}}}	\N	\N
283	328	directus_access	77084e57-682d-43e0-b570-acaf9fe94b1f	{"policy":"7f06bc6a-6c55-4672-aedc-1c25b42dca52","user":{"id":"4d310101-f7b1-47fe-982a-efe4abf25c55"}}	{"policy":"7f06bc6a-6c55-4672-aedc-1c25b42dca52","user":{"id":"4d310101-f7b1-47fe-982a-efe4abf25c55"}}	\N	\N
284	330	directus_files	5c8a6bfe-c55f-4b7c-aea4-a59e407e7a9d	{"folder":"3c744e72-03ef-432d-9c16-ac0a343b2499","title":"Valknar","filename_download":"valknar.gif","type":"image/gif","storage":"local"}	{"folder":"3c744e72-03ef-432d-9c16-ac0a343b2499","title":"Valknar","filename_download":"valknar.gif","type":"image/gif","storage":"local"}	\N	\N
289	335	directus_fields	54	{"id":54,"collection":"sexy_models","field":"tags","special":["cast-json"],"interface":"tags","options":{"whitespace":"","capitalization":"uppercase"},"display":null,"display_options":null,"readonly":false,"hidden":false,"sort":12,"width":"full","translations":null,"note":null,"conditions":null,"required":false,"group":null,"validation":null,"validation_message":null}	{"collection":"sexy_models","field":"tags","options":{"whitespace":"","capitalization":"uppercase"}}	\N	\N
291	337	directus_fields	60	{"sort":15,"interface":"boolean","special":["cast-boolean"],"options":{"label":"Featured"},"collection":"sexy_models","field":"featured"}	{"sort":15,"interface":"boolean","special":["cast-boolean"],"options":{"label":"Featured"},"collection":"sexy_models","field":"featured"}	\N	\N
293	339	directus_fields	61	{"sort":1,"hidden":true,"readonly":true,"interface":"input","special":["uuid"],"field":"id","collection":"sexy_videos"}	{"sort":1,"hidden":true,"readonly":true,"interface":"input","special":["uuid"],"field":"id","collection":"sexy_videos"}	\N	\N
308	354	directus_fields	49	{"id":49,"collection":"sexy_models","field":"date_created","special":["date-created"],"interface":"datetime","options":null,"display":"datetime","display_options":{"relative":true},"readonly":true,"hidden":true,"sort":4,"width":"half","translations":null,"note":null,"conditions":null,"required":false,"group":null,"validation":null,"validation_message":null}	{"collection":"sexy_models","field":"date_created","sort":4,"group":null}	\N	\N
309	355	directus_fields	50	{"id":50,"collection":"sexy_models","field":"date_updated","special":["date-updated"],"interface":"datetime","options":null,"display":"datetime","display_options":{"relative":true},"readonly":true,"hidden":true,"sort":5,"width":"half","translations":null,"note":null,"conditions":null,"required":false,"group":null,"validation":null,"validation_message":null}	{"collection":"sexy_models","field":"date_updated","sort":5,"group":null}	\N	\N
310	356	directus_fields	51	{"id":51,"collection":"sexy_models","field":"slug","special":null,"interface":"input","options":{"slug":true,"trim":true},"display":null,"display_options":null,"readonly":false,"hidden":false,"sort":6,"width":"full","translations":null,"note":null,"conditions":null,"required":true,"group":null,"validation":null,"validation_message":null}	{"collection":"sexy_models","field":"slug","sort":6,"group":null}	\N	\N
294	340	directus_fields	62	{"sort":2,"width":"full","options":{"choices":[{"text":"$t:published","value":"published","color":"var(--theme--primary)"},{"text":"$t:draft","value":"draft","color":"var(--theme--foreground)"},{"text":"$t:archived","value":"archived","color":"var(--theme--warning)"}]},"interface":"select-dropdown","display":"labels","display_options":{"showAsDot":true,"choices":[{"text":"$t:published","value":"published","color":"var(--theme--primary)","foreground":"var(--theme--primary)","background":"var(--theme--primary-background)"},{"text":"$t:draft","value":"draft","color":"var(--theme--foreground)","foreground":"var(--theme--foreground)","background":"var(--theme--background-normal)"},{"text":"$t:archived","value":"archived","color":"var(--theme--warning)","foreground":"var(--theme--warning)","background":"var(--theme--warning-background)"}]},"field":"status","collection":"sexy_videos"}	{"sort":2,"width":"full","options":{"choices":[{"text":"$t:published","value":"published","color":"var(--theme--primary)"},{"text":"$t:draft","value":"draft","color":"var(--theme--foreground)"},{"text":"$t:archived","value":"archived","color":"var(--theme--warning)"}]},"interface":"select-dropdown","display":"labels","display_options":{"showAsDot":true,"choices":[{"text":"$t:published","value":"published","color":"var(--theme--primary)","foreground":"var(--theme--primary)","background":"var(--theme--primary-background)"},{"text":"$t:draft","value":"draft","color":"var(--theme--foreground)","foreground":"var(--theme--foreground)","background":"var(--theme--background-normal)"},{"text":"$t:archived","value":"archived","color":"var(--theme--warning)","foreground":"var(--theme--warning)","background":"var(--theme--warning-background)"}]},"field":"status","collection":"sexy_videos"}	\N	\N
295	341	directus_fields	63	{"sort":3,"special":["user-created"],"interface":"select-dropdown-m2o","options":{"template":"{{avatar}} {{first_name}} {{last_name}}"},"display":"user","readonly":true,"hidden":true,"width":"half","field":"user_created","collection":"sexy_videos"}	{"sort":3,"special":["user-created"],"interface":"select-dropdown-m2o","options":{"template":"{{avatar}} {{first_name}} {{last_name}}"},"display":"user","readonly":true,"hidden":true,"width":"half","field":"user_created","collection":"sexy_videos"}	\N	\N
296	342	directus_fields	64	{"sort":4,"special":["date-created"],"interface":"datetime","readonly":true,"hidden":true,"width":"half","display":"datetime","display_options":{"relative":true},"field":"date_created","collection":"sexy_videos"}	{"sort":4,"special":["date-created"],"interface":"datetime","readonly":true,"hidden":true,"width":"half","display":"datetime","display_options":{"relative":true},"field":"date_created","collection":"sexy_videos"}	\N	\N
297	343	directus_fields	65	{"sort":5,"special":["date-updated"],"interface":"datetime","readonly":true,"hidden":true,"width":"half","display":"datetime","display_options":{"relative":true},"field":"date_updated","collection":"sexy_videos"}	{"sort":5,"special":["date-updated"],"interface":"datetime","readonly":true,"hidden":true,"width":"half","display":"datetime","display_options":{"relative":true},"field":"date_updated","collection":"sexy_videos"}	\N	\N
551	764	directus_fields	78	{"sort":13,"interface":"tags","special":["cast-json"],"collection":"sexy_videos","field":"tags"}	{"sort":13,"interface":"tags","special":["cast-json"],"collection":"sexy_videos","field":"tags"}	\N	\N
298	344	directus_collections	sexy_videos	{"archive_field":"status","archive_value":"archived","unarchive_value":"draft","singleton":false,"collection":"sexy_videos"}	{"archive_field":"status","archive_value":"archived","unarchive_value":"draft","singleton":false,"collection":"sexy_videos"}	\N	\N
299	345	directus_fields	66	{"sort":6,"interface":"input","special":null,"required":true,"collection":"sexy_videos","field":"slug"}	{"sort":6,"interface":"input","special":null,"required":true,"collection":"sexy_videos","field":"slug"}	\N	\N
300	346	directus_fields	66	{"id":66,"collection":"sexy_videos","field":"slug","special":null,"interface":"input","options":{"slug":true,"trim":true},"display":null,"display_options":null,"readonly":false,"hidden":false,"sort":6,"width":"full","translations":null,"note":null,"conditions":null,"required":true,"group":null,"validation":null,"validation_message":null}	{"collection":"sexy_videos","field":"slug","options":{"slug":true,"trim":true}}	\N	\N
301	347	directus_fields	67	{"sort":7,"interface":"input","special":null,"required":true,"collection":"sexy_videos","field":"title"}	{"sort":7,"interface":"input","special":null,"required":true,"collection":"sexy_videos","field":"title"}	\N	\N
302	348	directus_fields	68	{"sort":8,"interface":"file-image","special":["file"],"options":{"folder":"7360b85c-3bb7-4334-ba81-2f46575ea056"},"required":true,"collection":"sexy_videos","field":"image"}	{"sort":8,"interface":"file-image","special":["file"],"options":{"folder":"7360b85c-3bb7-4334-ba81-2f46575ea056"},"required":true,"collection":"sexy_videos","field":"image"}	\N	\N
303	349	directus_fields	69	{"sort":9,"interface":"input","special":null,"required":true,"collection":"sexy_videos","field":"category"}	{"sort":9,"interface":"input","special":null,"required":true,"collection":"sexy_videos","field":"category"}	\N	\N
304	350	directus_fields	55	{"id":55,"collection":"sexy_models","field":"category","special":null,"interface":"input","options":null,"display":null,"display_options":null,"readonly":false,"hidden":false,"sort":13,"width":"full","translations":null,"note":null,"conditions":null,"required":true,"group":null,"validation":null,"validation_message":null}	{"collection":"sexy_models","field":"category","required":true}	\N	\N
305	351	directus_fields	46	{"id":46,"collection":"sexy_models","field":"id","special":["uuid"],"interface":"input","options":null,"display":null,"display_options":null,"readonly":true,"hidden":true,"sort":1,"width":"full","translations":null,"note":null,"conditions":null,"required":false,"group":null,"validation":null,"validation_message":null}	{"collection":"sexy_models","field":"id","sort":1,"group":null}	\N	\N
306	352	directus_fields	47	{"id":47,"collection":"sexy_models","field":"status","special":null,"interface":"select-dropdown","options":{"choices":[{"text":"$t:published","value":"published","color":"var(--theme--primary)"},{"text":"$t:draft","value":"draft","color":"var(--theme--foreground)"},{"text":"$t:archived","value":"archived","color":"var(--theme--warning)"}]},"display":"labels","display_options":{"showAsDot":true,"choices":[{"text":"$t:published","value":"published","color":"var(--theme--primary)","foreground":"var(--theme--primary)","background":"var(--theme--primary-background)"},{"text":"$t:draft","value":"draft","color":"var(--theme--foreground)","foreground":"var(--theme--foreground)","background":"var(--theme--background-normal)"},{"text":"$t:archived","value":"archived","color":"var(--theme--warning)","foreground":"var(--theme--warning)","background":"var(--theme--warning-background)"}]},"readonly":false,"hidden":false,"sort":2,"width":"full","translations":null,"note":null,"conditions":null,"required":false,"group":null,"validation":null,"validation_message":null}	{"collection":"sexy_models","field":"status","sort":2,"group":null}	\N	\N
307	353	directus_fields	48	{"id":48,"collection":"sexy_models","field":"user_created","special":["user-created"],"interface":"select-dropdown-m2o","options":{"template":"{{avatar}} {{first_name}} {{last_name}}"},"display":"user","display_options":null,"readonly":true,"hidden":true,"sort":3,"width":"half","translations":null,"note":null,"conditions":null,"required":false,"group":null,"validation":null,"validation_message":null}	{"collection":"sexy_models","field":"user_created","sort":3,"group":null}	\N	\N
312	358	directus_fields	58	{"id":58,"collection":"sexy_models","field":"join_date","special":null,"interface":"datetime","options":null,"display":null,"display_options":null,"readonly":false,"hidden":false,"sort":8,"width":"full","translations":null,"note":null,"conditions":null,"required":true,"group":null,"validation":null,"validation_message":null}	{"collection":"sexy_models","field":"join_date","sort":8,"group":null}	\N	\N
313	359	directus_fields	59	{"id":59,"collection":"sexy_models","field":"user","special":["m2o"],"interface":"select-dropdown-m2o","options":{"enableLink":true,"filter":{"_and":[{"policies":{"policy":{"name":{"_eq":"Creator"}}}}]}},"display":null,"display_options":null,"readonly":false,"hidden":false,"sort":9,"width":"full","translations":null,"note":null,"conditions":null,"required":true,"group":null,"validation":null,"validation_message":null}	{"collection":"sexy_models","field":"user","sort":9,"group":null}	\N	\N
314	360	directus_fields	57	{"id":57,"collection":"sexy_models","field":"bio","special":null,"interface":"input-rich-text-html","options":{"toolbar":["bold","italic","underline","h2","h3","numlist","bullist","removeformat","blockquote","customLink","hr","fullscreen","code"]},"display":null,"display_options":null,"readonly":false,"hidden":false,"sort":10,"width":"full","translations":null,"note":null,"conditions":null,"required":true,"group":null,"validation":null,"validation_message":null}	{"collection":"sexy_models","field":"bio","sort":10,"group":null}	\N	\N
315	361	directus_fields	53	{"id":53,"collection":"sexy_models","field":"image","special":["file"],"interface":"file-image","options":{"folder":"3c744e72-03ef-432d-9c16-ac0a343b2499"},"display":null,"display_options":null,"readonly":false,"hidden":false,"sort":11,"width":"full","translations":null,"note":null,"conditions":null,"required":true,"group":null,"validation":null,"validation_message":null}	{"collection":"sexy_models","field":"image","sort":11,"group":null}	\N	\N
316	362	directus_fields	55	{"id":55,"collection":"sexy_models","field":"category","special":null,"interface":"input","options":null,"display":null,"display_options":null,"readonly":false,"hidden":false,"sort":12,"width":"full","translations":null,"note":null,"conditions":null,"required":true,"group":null,"validation":null,"validation_message":null}	{"collection":"sexy_models","field":"category","sort":12,"group":null}	\N	\N
317	363	directus_fields	54	{"id":54,"collection":"sexy_models","field":"tags","special":["cast-json"],"interface":"tags","options":{"whitespace":"","capitalization":"uppercase"},"display":null,"display_options":null,"readonly":false,"hidden":false,"sort":13,"width":"full","translations":null,"note":null,"conditions":null,"required":false,"group":null,"validation":null,"validation_message":null}	{"collection":"sexy_models","field":"tags","sort":13,"group":null}	\N	\N
486	657	directus_fields	77	{"sort":6,"interface":"input","special":null,"required":true,"collection":"directus_users","field":"artist_name"}	{"sort":6,"interface":"input","special":null,"required":true,"collection":"directus_users","field":"artist_name"}	\N	\N
318	364	directus_fields	56	{"id":56,"collection":"sexy_models","field":"banner_image","special":["file"],"interface":"file-image","options":{"folder":"3c744e72-03ef-432d-9c16-ac0a343b2499"},"display":null,"display_options":null,"readonly":false,"hidden":false,"sort":14,"width":"full","translations":null,"note":null,"conditions":null,"required":false,"group":null,"validation":null,"validation_message":null}	{"collection":"sexy_models","field":"banner_image","sort":14,"group":null}	\N	\N
319	365	directus_fields	60	{"id":60,"collection":"sexy_models","field":"featured","special":["cast-boolean"],"interface":"boolean","options":{"label":"Featured"},"display":null,"display_options":null,"readonly":false,"hidden":false,"sort":15,"width":"full","translations":null,"note":null,"conditions":null,"required":false,"group":null,"validation":null,"validation_message":null}	{"collection":"sexy_models","field":"featured","sort":15,"group":null}	\N	\N
320	366	directus_fields	70	{"sort":10,"interface":"datetime","special":null,"required":true,"collection":"sexy_videos","field":"upload_date"}	{"sort":10,"interface":"datetime","special":null,"required":true,"collection":"sexy_videos","field":"upload_date"}	\N	\N
321	367	directus_fields	71	{"sort":11,"interface":"boolean","special":["cast-boolean"],"options":{"label":"Premium"},"collection":"sexy_videos","field":"premium"}	{"sort":11,"interface":"boolean","special":["cast-boolean"],"options":{"label":"Premium"},"collection":"sexy_videos","field":"premium"}	\N	\N
322	368	directus_fields	72	{"sort":12,"interface":"boolean","special":["cast-boolean"],"options":{"label":"Featured"},"collection":"sexy_videos","field":"featured"}	{"sort":12,"interface":"boolean","special":["cast-boolean"],"options":{"label":"Featured"},"collection":"sexy_videos","field":"featured"}	\N	\N
323	369	directus_permissions	35	{"policy":"abf8a154-5b1c-4a46-ac9c-7300570f4f17","permissions":null,"validation":null,"fields":["*"],"presets":null,"collection":"sexy_videos","action":"read"}	{"policy":"abf8a154-5b1c-4a46-ac9c-7300570f4f17","permissions":null,"validation":null,"fields":["*"],"presets":null,"collection":"sexy_videos","action":"read"}	\N	\N
324	371	directus_settings	1	{"id":1,"project_name":"Sexy.Art","project_url":"https://sexy.pivoine.art","project_color":"#6644FF","project_logo":"8ad7e858-0c83-4d88-bb50-3680f1cfa9c2","public_foreground":null,"public_background":null,"public_note":"Where Love Meets Artistry","auth_login_attempts":25,"auth_password_policy":"/(?=^.{8,}$)(?=.*\\\\d)(?=.*[a-z])(?=.*[A-Z])(?=.*[!@#$%^&*()_+}{';'?>.<,])(?!.*\\\\s).*$/","storage_asset_transform":"presets","storage_asset_presets":[{"key":"mini","fit":"cover","width":300,"height":300,"quality":80,"withoutEnlargement":false,"format":"webp","transforms":[]},{"key":"preview","fit":"cover","width":600,"height":400,"quality":80,"withoutEnlargement":false,"format":"webp","transforms":[]},{"key":"medium","fit":"cover","width":1200,"height":900,"quality":80,"withoutEnlargement":false,"format":"webp","transforms":[]},{"key":"banner","fit":"cover","width":2000,"height":1000,"quality":80,"withoutEnlargement":false,"format":"webp","transforms":[]},{"key":"thumbnail","fit":"cover","width":600,"height":600,"quality":80,"withoutEnlargement":false,"format":"webp","transforms":[]}],"custom_css":null,"storage_default_folder":"c214c905-885b-4d66-a6a1-6527b0606200","basemaps":null,"mapbox_key":null,"module_bar":[{"type":"module","id":"content","enabled":true},{"type":"module","id":"visual","enabled":false},{"type":"module","id":"users","enabled":true},{"type":"module","id":"files","enabled":true},{"type":"module","id":"insights","enabled":true},{"type":"link","id":"docs","enabled":true,"name":"$t:documentation","icon":"help","url":"https://docs.directus.io"},{"type":"module","id":"settings","enabled":true,"locked":true}],"project_descriptor":null,"default_language":"en-US","custom_aspect_ratios":null,"public_favicon":null,"default_appearance":"auto","default_theme_light":null,"theme_light_overrides":null,"default_theme_dark":null,"theme_dark_overrides":null,"report_error_url":null,"report_bug_url":null,"report_feature_url":null,"public_registration":true,"public_registration_verify_email":true,"public_registration_role":"a1300aaa-0205-47d8-97a7-6166ac924e50","public_registration_email_filter":null,"visual_editor_urls":null,"accepted_terms":true,"project_id":"01991b80-eceb-7715-aebb-b0b1fbf67973"}	{"module_bar":[{"type":"module","id":"content","enabled":true},{"type":"module","id":"visual","enabled":false},{"type":"module","id":"users","enabled":true},{"type":"module","id":"files","enabled":true},{"type":"module","id":"insights","enabled":true},{"type":"link","id":"docs","enabled":true,"name":"$t:documentation","icon":"help","url":"https://docs.directus.io"},{"type":"module","id":"settings","enabled":true,"locked":true}]}	\N	\N
327	381	directus_users	4d310101-f7b1-47fe-982a-efe4abf25c55	{"id":"4d310101-f7b1-47fe-982a-efe4abf25c55","first_name":"Sebastian","last_name":"Krüger","email":"admin@pivoine.art","password":"**********","location":null,"title":null,"description":"Visionary leader with 15+ years in digital media and content creation.","tags":null,"avatar":"99c47c3d-4865-4361-a545-f38e54fccb0b","language":null,"tfa_secret":null,"status":"active","role":"ea3a9127-2b65-462c-85a8-dbafe9b4fe24","token":null,"last_access":"2025-09-11T17:14:23.736Z","last_page":"/users/4d310101-f7b1-47fe-982a-efe4abf25c55","provider":"default","external_identifier":null,"auth_data":null,"email_notifications":true,"appearance":null,"theme_dark":null,"theme_light":null,"theme_light_overrides":null,"theme_dark_overrides":null,"text_direction":"auto","website":"pivoine.art","policies":["b4f61dcc-b54e-4b3e-8a5e-bfbf029f6349","77084e57-682d-43e0-b570-acaf9fe94b1f","21e031ff-632d-46e5-97bb-959a5fef2538"]}	{"tfa_secret":null}	\N	\N
328	392	directus_users	4d310101-f7b1-47fe-982a-efe4abf25c55	{"id":"4d310101-f7b1-47fe-982a-efe4abf25c55","first_name":"Sebastian","last_name":"Krüger","email":"admin@pivoine.art","password":"**********","location":null,"title":null,"description":"Visionary leader with 15+ years in digital media and content creation.","tags":null,"avatar":"99c47c3d-4865-4361-a545-f38e54fccb0b","language":null,"tfa_secret":"**********","status":"active","role":"ea3a9127-2b65-462c-85a8-dbafe9b4fe24","token":null,"last_access":"2025-09-13T13:57:23.141Z","last_page":"/users/4d310101-f7b1-47fe-982a-efe4abf25c55","provider":"default","external_identifier":null,"auth_data":null,"email_notifications":true,"appearance":null,"theme_dark":null,"theme_light":null,"theme_light_overrides":null,"theme_dark_overrides":null,"text_direction":"auto","website":"pivoine.art","policies":["b4f61dcc-b54e-4b3e-8a5e-bfbf029f6349","77084e57-682d-43e0-b570-acaf9fe94b1f","21e031ff-632d-46e5-97bb-959a5fef2538"]}	{"tfa_secret":"**********"}	\N	\N
330	395	directus_collections	sexy_videos	{"collection":"sexy_videos","icon":"videocam","note":null,"display_template":null,"hidden":false,"singleton":false,"translations":null,"archive_field":"status","archive_app_filter":true,"archive_value":"archived","unarchive_value":"draft","sort_field":null,"accountability":"all","color":null,"item_duplication_fields":null,"sort":null,"group":null,"collapse":"open","preview_url":null,"versioning":false}	{"icon":"videocam"}	\N	\N
336	402	directus_files	ba90004e-5150-43dd-bf3e-699ee1b4d0a9	{"folder":"3c744e72-03ef-432d-9c16-ac0a343b2499","title":"Luna Belle","filename_download":"luna-belle.jpg","type":"image/jpeg","storage":"local"}	{"folder":"3c744e72-03ef-432d-9c16-ac0a343b2499","title":"Luna Belle","filename_download":"luna-belle.jpg","type":"image/jpeg","storage":"local"}	\N	\N
462	631	directus_fields	73	{"id":73,"collection":"directus_users","field":"username","special":null,"interface":"input","options":{"trim":true},"display":null,"display_options":null,"readonly":false,"hidden":false,"sort":1,"width":"full","translations":null,"note":null,"conditions":null,"required":true,"group":null,"validation":null,"validation_message":null}	{"collection":"directus_users","field":"username","required":true}	\N	\N
463	632	directus_fields	74	{"id":74,"collection":"directus_users","field":"slug","special":null,"interface":"input","options":null,"display":null,"display_options":null,"readonly":false,"hidden":false,"sort":3,"width":"full","translations":null,"note":null,"conditions":null,"required":true,"group":null,"validation":null,"validation_message":null}	{"collection":"directus_users","field":"slug","required":true}	\N	\N
331	397	directus_settings	1	{"id":1,"project_name":"Sexy.Art","project_url":"https://sexy.pivoine.art","project_color":"#6644FF","project_logo":"8ad7e858-0c83-4d88-bb50-3680f1cfa9c2","public_foreground":null,"public_background":null,"public_note":"Where Love Meets Artistry","auth_login_attempts":25,"auth_password_policy":"/(?=^.{8,}$)(?=.*\\\\d)(?=.*[a-z])(?=.*[A-Z])(?=.*[!@#$%^&*()_+}{';'?>.<,])(?!.*\\\\s).*$/","storage_asset_transform":"presets","storage_asset_presets":[{"key":"mini","fit":"cover","width":300,"height":300,"quality":80,"withoutEnlargement":false,"format":"webp","transforms":[]},{"key":"preview","fit":"cover","width":600,"height":400,"quality":80,"withoutEnlargement":false,"format":"webp","transforms":[]},{"key":"medium","fit":"cover","width":1200,"height":900,"quality":80,"withoutEnlargement":false,"format":"webp","transforms":[]},{"key":"banner","fit":"cover","width":2000,"height":1000,"quality":80,"withoutEnlargement":false,"format":"webp","transforms":[]},{"key":"thumbnail","fit":"cover","width":600,"height":600,"quality":80,"withoutEnlargement":false,"format":"webp","transforms":[]}],"custom_css":null,"storage_default_folder":"c214c905-885b-4d66-a6a1-6527b0606200","basemaps":null,"mapbox_key":null,"module_bar":[{"type":"module","id":"content","enabled":true},{"type":"module","id":"visual","enabled":false},{"type":"module","id":"users","enabled":true},{"type":"module","id":"files","enabled":true},{"type":"module","id":"insights","enabled":true},{"type":"link","id":"docs","enabled":true,"name":"$t:documentation","icon":"help","url":"https://docs.directus.io"},{"type":"module","id":"settings","enabled":true,"locked":true}],"project_descriptor":"Where Love Meets Artistry","default_language":"en-US","custom_aspect_ratios":null,"public_favicon":null,"default_appearance":"auto","default_theme_light":null,"theme_light_overrides":null,"default_theme_dark":null,"theme_dark_overrides":null,"report_error_url":null,"report_bug_url":null,"report_feature_url":null,"public_registration":true,"public_registration_verify_email":true,"public_registration_role":"a1300aaa-0205-47d8-97a7-6166ac924e50","public_registration_email_filter":null,"visual_editor_urls":null,"accepted_terms":true,"project_id":"01991b80-eceb-7715-aebb-b0b1fbf67973"}	{"project_descriptor":"Where Love Meets Artistry"}	\N	\N
332	398	directus_files	0a509923-853d-44e7-ad76-b6e6bdf89ba5	{"title":"Favicon","filename_download":"favicon.ico","type":"image/vnd.microsoft.icon","storage":"local","folder":"c214c905-885b-4d66-a6a1-6527b0606200"}	{"title":"Favicon","filename_download":"favicon.ico","type":"image/vnd.microsoft.icon","storage":"local","folder":"c214c905-885b-4d66-a6a1-6527b0606200"}	\N	\N
339	406	directus_settings	1	{"id":1,"project_name":"Sexy.Art","project_url":"https://sexy.pivoine.art","project_color":"#CE47EB","project_logo":"8ad7e858-0c83-4d88-bb50-3680f1cfa9c2","public_foreground":null,"public_background":null,"public_note":"Where Love Meets Artistry","auth_login_attempts":25,"auth_password_policy":"/(?=^.{8,}$)(?=.*\\\\d)(?=.*[a-z])(?=.*[A-Z])(?=.*[!@#$%^&*()_+}{';'?>.<,])(?!.*\\\\s).*$/","storage_asset_transform":"presets","storage_asset_presets":[{"key":"mini","fit":"cover","width":300,"height":300,"quality":80,"withoutEnlargement":false,"format":"webp","transforms":[]},{"key":"preview","fit":"cover","width":600,"height":400,"quality":80,"withoutEnlargement":false,"format":"webp","transforms":[]},{"key":"medium","fit":"cover","width":1200,"height":900,"quality":80,"withoutEnlargement":false,"format":"webp","transforms":[]},{"key":"banner","fit":"cover","width":2000,"height":1000,"quality":80,"withoutEnlargement":false,"format":"webp","transforms":[]},{"key":"thumbnail","fit":"cover","width":600,"height":600,"quality":80,"withoutEnlargement":false,"format":"webp","transforms":[]}],"custom_css":null,"storage_default_folder":"c214c905-885b-4d66-a6a1-6527b0606200","basemaps":null,"mapbox_key":null,"module_bar":[{"type":"module","id":"content","enabled":true},{"type":"module","id":"visual","enabled":false},{"type":"module","id":"users","enabled":true},{"type":"module","id":"files","enabled":true},{"type":"module","id":"insights","enabled":true},{"type":"link","id":"docs","enabled":true,"name":"$t:documentation","icon":"help","url":"https://docs.directus.io"},{"type":"module","id":"settings","enabled":true,"locked":true}],"project_descriptor":"Where Love Meets Artistry","default_language":"en-US","custom_aspect_ratios":null,"public_favicon":"0a509923-853d-44e7-ad76-b6e6bdf89ba5","default_appearance":"auto","default_theme_light":null,"theme_light_overrides":null,"default_theme_dark":"@sexy.pivoine.art/theme","theme_dark_overrides":null,"report_error_url":null,"report_bug_url":null,"report_feature_url":null,"public_registration":true,"public_registration_verify_email":true,"public_registration_role":"a1300aaa-0205-47d8-97a7-6166ac924e50","public_registration_email_filter":null,"visual_editor_urls":null,"accepted_terms":true,"project_id":"01991b80-eceb-7715-aebb-b0b1fbf67973"}	{"project_color":"#CE47EB"}	\N	\N
333	399	directus_files	0a509923-853d-44e7-ad76-b6e6bdf89ba5	{"id":"0a509923-853d-44e7-ad76-b6e6bdf89ba5","storage":"local","filename_disk":"0a509923-853d-44e7-ad76-b6e6bdf89ba5.ico","filename_download":"favicon.ico","title":"Favicon","type":"image/vnd.microsoft.icon","folder":"3eaf8f03-dbfe-4c73-b513-5cc588de6457","uploaded_by":"4d310101-f7b1-47fe-982a-efe4abf25c55","created_on":"2025-09-13T14:39:34.980Z","modified_by":"4d310101-f7b1-47fe-982a-efe4abf25c55","modified_on":"2025-09-13T14:40:04.809Z","charset":null,"filesize":"15406","width":null,"height":null,"duration":null,"embed":null,"description":null,"location":null,"tags":null,"metadata":null,"focal_point_x":null,"focal_point_y":null,"tus_id":null,"tus_data":null,"uploaded_on":"2025-09-13T14:39:35.018Z"}	{"folder":"3eaf8f03-dbfe-4c73-b513-5cc588de6457","modified_by":"4d310101-f7b1-47fe-982a-efe4abf25c55","modified_on":"2025-09-13T14:40:04.809Z"}	\N	\N
387	490	directus_permissions	55	{"collection":"directus_folders","action":"update","permissions":{},"fields":["*"],"policy":"abf8a154-5b1c-4a46-ac9c-7300570f4f17"}	{"collection":"directus_folders","action":"update","permissions":{},"fields":["*"],"policy":"abf8a154-5b1c-4a46-ac9c-7300570f4f17"}	397	\N
388	491	directus_permissions	56	{"collection":"directus_folders","action":"delete","permissions":{},"policy":"abf8a154-5b1c-4a46-ac9c-7300570f4f17"}	{"collection":"directus_folders","action":"delete","permissions":{},"policy":"abf8a154-5b1c-4a46-ac9c-7300570f4f17"}	397	\N
389	492	directus_permissions	57	{"collection":"directus_users","action":"read","permissions":{},"fields":["*"],"policy":"abf8a154-5b1c-4a46-ac9c-7300570f4f17"}	{"collection":"directus_users","action":"read","permissions":{},"fields":["*"],"policy":"abf8a154-5b1c-4a46-ac9c-7300570f4f17"}	397	\N
334	400	directus_settings	1	{"id":1,"project_name":"Sexy.Art","project_url":"https://sexy.pivoine.art","project_color":"#6644FF","project_logo":"8ad7e858-0c83-4d88-bb50-3680f1cfa9c2","public_foreground":null,"public_background":null,"public_note":"Where Love Meets Artistry","auth_login_attempts":25,"auth_password_policy":"/(?=^.{8,}$)(?=.*\\\\d)(?=.*[a-z])(?=.*[A-Z])(?=.*[!@#$%^&*()_+}{';'?>.<,])(?!.*\\\\s).*$/","storage_asset_transform":"presets","storage_asset_presets":[{"key":"mini","fit":"cover","width":300,"height":300,"quality":80,"withoutEnlargement":false,"format":"webp","transforms":[]},{"key":"preview","fit":"cover","width":600,"height":400,"quality":80,"withoutEnlargement":false,"format":"webp","transforms":[]},{"key":"medium","fit":"cover","width":1200,"height":900,"quality":80,"withoutEnlargement":false,"format":"webp","transforms":[]},{"key":"banner","fit":"cover","width":2000,"height":1000,"quality":80,"withoutEnlargement":false,"format":"webp","transforms":[]},{"key":"thumbnail","fit":"cover","width":600,"height":600,"quality":80,"withoutEnlargement":false,"format":"webp","transforms":[]}],"custom_css":null,"storage_default_folder":"c214c905-885b-4d66-a6a1-6527b0606200","basemaps":null,"mapbox_key":null,"module_bar":[{"type":"module","id":"content","enabled":true},{"type":"module","id":"visual","enabled":false},{"type":"module","id":"users","enabled":true},{"type":"module","id":"files","enabled":true},{"type":"module","id":"insights","enabled":true},{"type":"link","id":"docs","enabled":true,"name":"$t:documentation","icon":"help","url":"https://docs.directus.io"},{"type":"module","id":"settings","enabled":true,"locked":true}],"project_descriptor":"Where Love Meets Artistry","default_language":"en-US","custom_aspect_ratios":null,"public_favicon":"0a509923-853d-44e7-ad76-b6e6bdf89ba5","default_appearance":"auto","default_theme_light":null,"theme_light_overrides":null,"default_theme_dark":null,"theme_dark_overrides":null,"report_error_url":null,"report_bug_url":null,"report_feature_url":null,"public_registration":true,"public_registration_verify_email":true,"public_registration_role":"a1300aaa-0205-47d8-97a7-6166ac924e50","public_registration_email_filter":null,"visual_editor_urls":null,"accepted_terms":true,"project_id":"01991b80-eceb-7715-aebb-b0b1fbf67973"}	{"public_favicon":"0a509923-853d-44e7-ad76-b6e6bdf89ba5"}	\N	\N
335	401	directus_settings	1	{"id":1,"project_name":"Sexy.Art","project_url":"https://sexy.pivoine.art","project_color":"#6644FF","project_logo":"8ad7e858-0c83-4d88-bb50-3680f1cfa9c2","public_foreground":null,"public_background":null,"public_note":"Where Love Meets Artistry","auth_login_attempts":25,"auth_password_policy":"/(?=^.{8,}$)(?=.*\\\\d)(?=.*[a-z])(?=.*[A-Z])(?=.*[!@#$%^&*()_+}{';'?>.<,])(?!.*\\\\s).*$/","storage_asset_transform":"presets","storage_asset_presets":[{"key":"mini","fit":"cover","width":300,"height":300,"quality":80,"withoutEnlargement":false,"format":"webp","transforms":[]},{"key":"preview","fit":"cover","width":600,"height":400,"quality":80,"withoutEnlargement":false,"format":"webp","transforms":[]},{"key":"medium","fit":"cover","width":1200,"height":900,"quality":80,"withoutEnlargement":false,"format":"webp","transforms":[]},{"key":"banner","fit":"cover","width":2000,"height":1000,"quality":80,"withoutEnlargement":false,"format":"webp","transforms":[]},{"key":"thumbnail","fit":"cover","width":600,"height":600,"quality":80,"withoutEnlargement":false,"format":"webp","transforms":[]}],"custom_css":null,"storage_default_folder":"c214c905-885b-4d66-a6a1-6527b0606200","basemaps":null,"mapbox_key":null,"module_bar":[{"type":"module","id":"content","enabled":true},{"type":"module","id":"visual","enabled":false},{"type":"module","id":"users","enabled":true},{"type":"module","id":"files","enabled":true},{"type":"module","id":"insights","enabled":true},{"type":"link","id":"docs","enabled":true,"name":"$t:documentation","icon":"help","url":"https://docs.directus.io"},{"type":"module","id":"settings","enabled":true,"locked":true}],"project_descriptor":"Where Love Meets Artistry","default_language":"en-US","custom_aspect_ratios":null,"public_favicon":"0a509923-853d-44e7-ad76-b6e6bdf89ba5","default_appearance":"auto","default_theme_light":null,"theme_light_overrides":null,"default_theme_dark":"@sexy.pivoine.art/theme","theme_dark_overrides":null,"report_error_url":null,"report_bug_url":null,"report_feature_url":null,"public_registration":true,"public_registration_verify_email":true,"public_registration_role":"a1300aaa-0205-47d8-97a7-6166ac924e50","public_registration_email_filter":null,"visual_editor_urls":null,"accepted_terms":true,"project_id":"01991b80-eceb-7715-aebb-b0b1fbf67973"}	{"default_theme_dark":"@sexy.pivoine.art/theme"}	\N	\N
464	633	directus_fields	75	{"id":75,"collection":"directus_users","field":"join_date","special":null,"interface":"datetime","options":{"format":"short"},"display":null,"display_options":null,"readonly":false,"hidden":false,"sort":4,"width":"full","translations":null,"note":null,"conditions":null,"required":true,"group":null,"validation":null,"validation_message":null}	{"collection":"directus_users","field":"join_date","required":true}	\N	\N
340	408	directus_settings	1	{"id":1,"project_name":"Sexy.Art","project_url":"https://sexy.pivoine.art","project_color":"#CE47EB","project_logo":"8ad7e858-0c83-4d88-bb50-3680f1cfa9c2","public_foreground":null,"public_background":null,"public_note":"Where Love Meets Artistry","auth_login_attempts":25,"auth_password_policy":"/^.{8,}$/","storage_asset_transform":"presets","storage_asset_presets":[{"key":"mini","fit":"cover","width":300,"height":300,"quality":80,"withoutEnlargement":false,"format":"webp","transforms":[]},{"key":"preview","fit":"cover","width":600,"height":400,"quality":80,"withoutEnlargement":false,"format":"webp","transforms":[]},{"key":"medium","fit":"cover","width":1200,"height":900,"quality":80,"withoutEnlargement":false,"format":"webp","transforms":[]},{"key":"banner","fit":"cover","width":2000,"height":1000,"quality":80,"withoutEnlargement":false,"format":"webp","transforms":[]},{"key":"thumbnail","fit":"cover","width":600,"height":600,"quality":80,"withoutEnlargement":false,"format":"webp","transforms":[]}],"custom_css":null,"storage_default_folder":"c214c905-885b-4d66-a6a1-6527b0606200","basemaps":null,"mapbox_key":null,"module_bar":[{"type":"module","id":"content","enabled":true},{"type":"module","id":"visual","enabled":false},{"type":"module","id":"users","enabled":true},{"type":"module","id":"files","enabled":true},{"type":"module","id":"insights","enabled":true},{"type":"link","id":"docs","enabled":true,"name":"$t:documentation","icon":"help","url":"https://docs.directus.io"},{"type":"module","id":"settings","enabled":true,"locked":true}],"project_descriptor":"Where Love Meets Artistry","default_language":"en-US","custom_aspect_ratios":null,"public_favicon":"0a509923-853d-44e7-ad76-b6e6bdf89ba5","default_appearance":"auto","default_theme_light":null,"theme_light_overrides":null,"default_theme_dark":"@sexy.pivoine.art/theme","theme_dark_overrides":null,"report_error_url":null,"report_bug_url":null,"report_feature_url":null,"public_registration":true,"public_registration_verify_email":true,"public_registration_role":"a1300aaa-0205-47d8-97a7-6166ac924e50","public_registration_email_filter":null,"visual_editor_urls":null,"accepted_terms":true,"project_id":"01991b80-eceb-7715-aebb-b0b1fbf67973"}	{"auth_password_policy":"/^.{8,}$/"}	\N	\N
360	458	directus_users	4d310101-f7b1-47fe-982a-efe4abf25c55	{"id":"4d310101-f7b1-47fe-982a-efe4abf25c55","first_name":"Sebastian","last_name":"Krüger","email":"valknar@pivoine.art","password":"**********","location":null,"title":null,"description":"Visionary leader with 15+ years in digital media and content creation.","tags":["Love","Sex","Design","Art"],"avatar":"99c47c3d-4865-4361-a545-f38e54fccb0b","language":null,"tfa_secret":"**********","status":"active","role":"ea3a9127-2b65-462c-85a8-dbafe9b4fe24","token":null,"last_access":"2025-09-16T10:34:16.386Z","last_page":"/users/4d310101-f7b1-47fe-982a-efe4abf25c55","provider":"default","external_identifier":null,"auth_data":null,"email_notifications":true,"appearance":null,"theme_dark":null,"theme_light":null,"theme_light_overrides":null,"theme_dark_overrides":null,"text_direction":"auto","website":"pivoine.art","username":"Valknar","slug":"valknar","join_date":"2025-09-09T12:00:00","policies":["b4f61dcc-b54e-4b3e-8a5e-bfbf029f6349","77084e57-682d-43e0-b570-acaf9fe94b1f","21e031ff-632d-46e5-97bb-959a5fef2538"]}	{"tags":["Love","Sex","Design","Art"]}	\N	\N
390	493	directus_permissions	58	{"collection":"directus_users","action":"update","permissions":{"id":{"_eq":"$CURRENT_USER"}},"fields":["first_name","last_name","email","password","location","title","description","avatar","language","appearance","theme_light","theme_dark","theme_light_overrides","theme_dark_overrides","tfa_secret"],"policy":"abf8a154-5b1c-4a46-ac9c-7300570f4f17"}	{"collection":"directus_users","action":"update","permissions":{"id":{"_eq":"$CURRENT_USER"}},"fields":["first_name","last_name","email","password","location","title","description","avatar","language","appearance","theme_light","theme_dark","theme_light_overrides","theme_dark_overrides","tfa_secret"],"policy":"abf8a154-5b1c-4a46-ac9c-7300570f4f17"}	397	\N
391	494	directus_permissions	59	{"collection":"directus_roles","action":"read","permissions":{},"fields":["*"],"policy":"abf8a154-5b1c-4a46-ac9c-7300570f4f17"}	{"collection":"directus_roles","action":"read","permissions":{},"fields":["*"],"policy":"abf8a154-5b1c-4a46-ac9c-7300570f4f17"}	397	\N
392	495	directus_permissions	60	{"collection":"directus_shares","action":"read","permissions":{"_or":[{"role":{"_eq":"$CURRENT_ROLE"}},{"role":{"_null":true}}]},"fields":["*"],"policy":"abf8a154-5b1c-4a46-ac9c-7300570f4f17"}	{"collection":"directus_shares","action":"read","permissions":{"_or":[{"role":{"_eq":"$CURRENT_ROLE"}},{"role":{"_null":true}}]},"fields":["*"],"policy":"abf8a154-5b1c-4a46-ac9c-7300570f4f17"}	397	\N
393	496	directus_permissions	61	{"collection":"directus_shares","action":"create","permissions":{},"fields":["*"],"policy":"abf8a154-5b1c-4a46-ac9c-7300570f4f17"}	{"collection":"directus_shares","action":"create","permissions":{},"fields":["*"],"policy":"abf8a154-5b1c-4a46-ac9c-7300570f4f17"}	397	\N
394	497	directus_permissions	62	{"collection":"directus_shares","action":"update","permissions":{"user_created":{"_eq":"$CURRENT_USER"}},"fields":["*"],"policy":"abf8a154-5b1c-4a46-ac9c-7300570f4f17"}	{"collection":"directus_shares","action":"update","permissions":{"user_created":{"_eq":"$CURRENT_USER"}},"fields":["*"],"policy":"abf8a154-5b1c-4a46-ac9c-7300570f4f17"}	397	\N
395	498	directus_permissions	63	{"collection":"directus_shares","action":"delete","permissions":{"user_created":{"_eq":"$CURRENT_USER"}},"fields":["*"],"policy":"abf8a154-5b1c-4a46-ac9c-7300570f4f17"}	{"collection":"directus_shares","action":"delete","permissions":{"user_created":{"_eq":"$CURRENT_USER"}},"fields":["*"],"policy":"abf8a154-5b1c-4a46-ac9c-7300570f4f17"}	397	\N
341	416	directus_users	4d310101-f7b1-47fe-982a-efe4abf25c55	{"id":"4d310101-f7b1-47fe-982a-efe4abf25c55","first_name":"Sebastian","last_name":"Krüger","email":"valknar@pivoine.art","password":"**********","location":null,"title":null,"description":"Visionary leader with 15+ years in digital media and content creation.","tags":null,"avatar":"99c47c3d-4865-4361-a545-f38e54fccb0b","language":null,"tfa_secret":"**********","status":"active","role":"ea3a9127-2b65-462c-85a8-dbafe9b4fe24","token":null,"last_access":"2025-09-16T08:47:17.956Z","last_page":"/users/4d310101-f7b1-47fe-982a-efe4abf25c55","provider":"default","external_identifier":null,"auth_data":null,"email_notifications":true,"appearance":null,"theme_dark":null,"theme_light":null,"theme_light_overrides":null,"theme_dark_overrides":null,"text_direction":"auto","website":"pivoine.art","policies":["b4f61dcc-b54e-4b3e-8a5e-bfbf029f6349","77084e57-682d-43e0-b570-acaf9fe94b1f","21e031ff-632d-46e5-97bb-959a5fef2538"]}	{"email":"valknar@pivoine.art"}	\N	\N
361	459	directus_fields	76	{"sort":5,"interface":"boolean","special":["cast-boolean"],"required":false,"options":{"label":"Featured"},"collection":"directus_users","field":"featured"}	{"sort":5,"interface":"boolean","special":["cast-boolean"],"required":false,"options":{"label":"Featured"},"collection":"directus_users","field":"featured"}	\N	\N
396	499	directus_permissions	64	{"collection":"directus_flows","action":"read","permissions":{"trigger":{"_eq":"manual"}},"fields":["id","status","name","icon","color","options","trigger"],"policy":"abf8a154-5b1c-4a46-ac9c-7300570f4f17"}	{"collection":"directus_flows","action":"read","permissions":{"trigger":{"_eq":"manual"}},"fields":["id","status","name","icon","color","options","trigger"],"policy":"abf8a154-5b1c-4a46-ac9c-7300570f4f17"}	397	\N
408	544	directus_policies	abf8a154-5b1c-4a46-ac9c-7300570f4f17	{"id":"abf8a154-5b1c-4a46-ac9c-7300570f4f17","name":"$t:public_label","icon":"public","description":"$t:public_description","ip_access":null,"enforce_tfa":false,"admin_access":false,"app_access":true,"permissions":[27,35,40,42,57,65,66,67],"users":["34e30350-eb02-4888-80b1-d09b6dcc85e8"],"roles":["34e30350-eb02-4888-80b1-d09b6dcc85e8"]}	{"app_access":true}	\N	\N
426	564	directus_permissions	76	{"policy":"f575bea7-7260-4d81-a931-81d762f2b47d","permissions":null,"validation":null,"fields":["*"],"presets":null,"collection":"directus_users","action":"delete"}	{"policy":"f575bea7-7260-4d81-a931-81d762f2b47d","permissions":null,"validation":null,"fields":["*"],"presets":null,"collection":"directus_users","action":"delete"}	442	\N
637	872	directus_fields	98	{"sort":1,"hidden":true,"field":"id","collection":"junction_directus_users_videos"}	{"sort":1,"hidden":true,"field":"id","collection":"junction_directus_users_videos"}	\N	\N
427	565	directus_permissions	77	{"policy":"f575bea7-7260-4d81-a931-81d762f2b47d","permissions":null,"validation":null,"fields":["*"],"presets":null,"collection":"directus_users","action":"share"}	{"policy":"f575bea7-7260-4d81-a931-81d762f2b47d","permissions":null,"validation":null,"fields":["*"],"presets":null,"collection":"directus_users","action":"share"}	442	\N
428	566	directus_permissions	78	{"policy":"f575bea7-7260-4d81-a931-81d762f2b47d","permissions":null,"validation":null,"fields":["*"],"presets":null,"collection":"directus_roles","action":"create"}	{"policy":"f575bea7-7260-4d81-a931-81d762f2b47d","permissions":null,"validation":null,"fields":["*"],"presets":null,"collection":"directus_roles","action":"create"}	442	\N
429	567	directus_permissions	79	{"policy":"f575bea7-7260-4d81-a931-81d762f2b47d","permissions":null,"validation":null,"fields":["*"],"presets":null,"collection":"directus_roles","action":"update"}	{"policy":"f575bea7-7260-4d81-a931-81d762f2b47d","permissions":null,"validation":null,"fields":["*"],"presets":null,"collection":"directus_roles","action":"update"}	442	\N
430	568	directus_permissions	80	{"policy":"f575bea7-7260-4d81-a931-81d762f2b47d","permissions":null,"validation":null,"fields":["*"],"presets":null,"collection":"directus_roles","action":"delete"}	{"policy":"f575bea7-7260-4d81-a931-81d762f2b47d","permissions":null,"validation":null,"fields":["*"],"presets":null,"collection":"directus_roles","action":"delete"}	442	\N
431	569	directus_permissions	81	{"policy":"f575bea7-7260-4d81-a931-81d762f2b47d","permissions":null,"validation":null,"fields":["*"],"presets":null,"collection":"directus_roles","action":"share"}	{"policy":"f575bea7-7260-4d81-a931-81d762f2b47d","permissions":null,"validation":null,"fields":["*"],"presets":null,"collection":"directus_roles","action":"share"}	442	\N
432	570	directus_permissions	82	{"policy":"f575bea7-7260-4d81-a931-81d762f2b47d","permissions":null,"validation":null,"fields":["*"],"presets":null,"collection":"directus_policies","action":"create"}	{"policy":"f575bea7-7260-4d81-a931-81d762f2b47d","permissions":null,"validation":null,"fields":["*"],"presets":null,"collection":"directus_policies","action":"create"}	442	\N
433	571	directus_permissions	83	{"policy":"f575bea7-7260-4d81-a931-81d762f2b47d","permissions":null,"validation":null,"fields":["*"],"presets":null,"collection":"directus_policies","action":"update"}	{"policy":"f575bea7-7260-4d81-a931-81d762f2b47d","permissions":null,"validation":null,"fields":["*"],"presets":null,"collection":"directus_policies","action":"update"}	442	\N
434	572	directus_permissions	84	{"policy":"f575bea7-7260-4d81-a931-81d762f2b47d","permissions":null,"validation":null,"fields":["*"],"presets":null,"collection":"directus_policies","action":"delete"}	{"policy":"f575bea7-7260-4d81-a931-81d762f2b47d","permissions":null,"validation":null,"fields":["*"],"presets":null,"collection":"directus_policies","action":"delete"}	442	\N
435	573	directus_permissions	85	{"policy":"f575bea7-7260-4d81-a931-81d762f2b47d","permissions":null,"validation":null,"fields":["*"],"presets":null,"collection":"directus_policies","action":"share"}	{"policy":"f575bea7-7260-4d81-a931-81d762f2b47d","permissions":null,"validation":null,"fields":["*"],"presets":null,"collection":"directus_policies","action":"share"}	442	\N
436	574	directus_permissions	86	{"policy":"f575bea7-7260-4d81-a931-81d762f2b47d","permissions":null,"validation":null,"fields":["*"],"presets":null,"collection":"directus_files","action":"create"}	{"policy":"f575bea7-7260-4d81-a931-81d762f2b47d","permissions":null,"validation":null,"fields":["*"],"presets":null,"collection":"directus_files","action":"create"}	442	\N
437	575	directus_permissions	87	{"policy":"f575bea7-7260-4d81-a931-81d762f2b47d","permissions":null,"validation":null,"fields":["*"],"presets":null,"collection":"directus_files","action":"update"}	{"policy":"f575bea7-7260-4d81-a931-81d762f2b47d","permissions":null,"validation":null,"fields":["*"],"presets":null,"collection":"directus_files","action":"update"}	442	\N
438	576	directus_permissions	88	{"policy":"f575bea7-7260-4d81-a931-81d762f2b47d","permissions":null,"validation":null,"fields":["*"],"presets":null,"collection":"directus_files","action":"delete"}	{"policy":"f575bea7-7260-4d81-a931-81d762f2b47d","permissions":null,"validation":null,"fields":["*"],"presets":null,"collection":"directus_files","action":"delete"}	442	\N
342	418	directus_fields	40	{"id":40,"collection":"directus_users","field":"website","special":null,"interface":"input","options":null,"display":null,"display_options":null,"readonly":false,"hidden":false,"sort":1,"width":"full","translations":null,"note":null,"conditions":null,"required":false,"group":null,"validation":null,"validation_message":null}	{"collection":"directus_users","field":"website"}	\N	\N
362	460	directus_users	4d310101-f7b1-47fe-982a-efe4abf25c55	{"id":"4d310101-f7b1-47fe-982a-efe4abf25c55","first_name":"Sebastian","last_name":"Krüger","email":"valknar@pivoine.art","password":"**********","location":null,"title":null,"description":"Visionary leader with 15+ years in digital media and content creation.","tags":["Love","Sex","Design","Art"],"avatar":"99c47c3d-4865-4361-a545-f38e54fccb0b","language":null,"tfa_secret":"**********","status":"active","role":"ea3a9127-2b65-462c-85a8-dbafe9b4fe24","token":null,"last_access":"2025-09-16T10:34:16.386Z","last_page":"/users/4d310101-f7b1-47fe-982a-efe4abf25c55","provider":"default","external_identifier":null,"auth_data":null,"email_notifications":true,"appearance":null,"theme_dark":null,"theme_light":null,"theme_light_overrides":null,"theme_dark_overrides":null,"text_direction":"auto","website":"pivoine.art","username":"Valknar","slug":"valknar","join_date":"2025-09-09T12:00:00","featured":true,"policies":["b4f61dcc-b54e-4b3e-8a5e-bfbf029f6349","77084e57-682d-43e0-b570-acaf9fe94b1f","21e031ff-632d-46e5-97bb-959a5fef2538"]}	{"featured":true}	\N	\N
399	528	directus_policies	abf8a154-5b1c-4a46-ac9c-7300570f4f17	{"id":"abf8a154-5b1c-4a46-ac9c-7300570f4f17","name":"$t:public_label","icon":"public","description":"$t:public_description","ip_access":null,"enforce_tfa":false,"admin_access":false,"app_access":false,"permissions":[27,35,40,42,57],"users":["34e30350-eb02-4888-80b1-d09b6dcc85e8"],"roles":["34e30350-eb02-4888-80b1-d09b6dcc85e8"]}	{"admin_access":false}	\N	\N
398	505	directus_permissions	57	{"id":57,"collection":"directus_users","action":"read","permissions":{"_and":[{"policies":{"policy":{"name":{"_eq":"Model"}}}}]},"validation":null,"presets":null,"fields":["website","slug","join_date","featured","title","description","tags","username","avatar","location","id"],"policy":"abf8a154-5b1c-4a46-ac9c-7300570f4f17"}	{"collection":"directus_users","action":"read","permissions":{"_and":[{"policies":{"policy":{"name":{"_eq":"Model"}}}}]},"validation":null,"presets":null,"fields":["website","slug","join_date","featured","title","description","tags","username","avatar","location","id"],"policy":"abf8a154-5b1c-4a46-ac9c-7300570f4f17"}	399	\N
409	545	directus_policies	abf8a154-5b1c-4a46-ac9c-7300570f4f17	{"id":"abf8a154-5b1c-4a46-ac9c-7300570f4f17","name":"$t:public_label","icon":"public","description":"$t:public_description","ip_access":null,"enforce_tfa":false,"admin_access":true,"app_access":true,"permissions":[27,35,40,42,57,65,66,67],"users":["34e30350-eb02-4888-80b1-d09b6dcc85e8"],"roles":["34e30350-eb02-4888-80b1-d09b6dcc85e8"]}	{"admin_access":true}	\N	\N
439	577	directus_permissions	89	{"policy":"f575bea7-7260-4d81-a931-81d762f2b47d","permissions":null,"validation":null,"fields":["*"],"presets":null,"collection":"directus_files","action":"share"}	{"policy":"f575bea7-7260-4d81-a931-81d762f2b47d","permissions":null,"validation":null,"fields":["*"],"presets":null,"collection":"directus_files","action":"share"}	442	\N
440	578	directus_permissions	71	{"id":71,"collection":"directus_users","action":"read","permissions":null,"validation":null,"presets":null,"fields":["*"],"policy":"f575bea7-7260-4d81-a931-81d762f2b47d"}	{"collection":"directus_users","action":"read","permissions":null,"validation":null,"presets":null,"fields":["*"],"policy":"f575bea7-7260-4d81-a931-81d762f2b47d"}	442	\N
441	579	directus_permissions	70	{"id":70,"collection":"directus_files","action":"read","permissions":null,"validation":null,"presets":null,"fields":["*"],"policy":"f575bea7-7260-4d81-a931-81d762f2b47d"}	{"collection":"directus_files","action":"read","permissions":null,"validation":null,"presets":null,"fields":["*"],"policy":"f575bea7-7260-4d81-a931-81d762f2b47d"}	442	\N
443	581	directus_access	1e42d4ff-0ead-4651-a283-7b21a158d5ea	{"id":"1e42d4ff-0ead-4651-a283-7b21a158d5ea","role":null,"user":null,"policy":"f575bea7-7260-4d81-a931-81d762f2b47d","sort":null}	{"policy":"f575bea7-7260-4d81-a931-81d762f2b47d"}	\N	\N
442	580	directus_policies	f575bea7-7260-4d81-a931-81d762f2b47d	{"id":"f575bea7-7260-4d81-a931-81d762f2b47d","name":"Public","icon":"public","description":null,"ip_access":null,"enforce_tfa":false,"admin_access":false,"app_access":false,"permissions":[68,69,70,71,72,73,74,75,76,77,78,79,80,81,82,83,84,85,86,87,88,89],"users":["1e42d4ff-0ead-4651-a283-7b21a158d5ea"],"roles":["1e42d4ff-0ead-4651-a283-7b21a158d5ea"]}	{"admin_access":false}	443	\N
343	419	directus_permissions	28	{"id":28,"collection":"directus_users","action":"read","permissions":null,"validation":null,"presets":null,"fields":["*"],"policy":"abf8a154-5b1c-4a46-ac9c-7300570f4f17"}	{"collection":"directus_users","action":"read","permissions":null,"validation":null,"presets":null,"fields":["*"],"policy":"abf8a154-5b1c-4a46-ac9c-7300570f4f17"}	\N	\N
363	461	directus_users	543f4d0b-e346-4e5e-8aca-4a9b35d5fab6	{"id":"543f4d0b-e346-4e5e-8aca-4a9b35d5fab6","first_name":"Palina","last_name":"Rojinski","email":"palina@pivoine.art","password":"**********","location":null,"title":null,"description":"Award-winning model, dancer and actress with 15+ years of experience.","tags":null,"avatar":null,"language":null,"tfa_secret":null,"status":"active","role":"a1300aaa-0205-47d8-97a7-6166ac924e50","token":null,"last_access":null,"last_page":null,"provider":"default","external_identifier":null,"auth_data":null,"email_notifications":true,"appearance":null,"theme_dark":null,"theme_light":null,"theme_light_overrides":null,"theme_dark_overrides":null,"text_direction":"auto","website":"pivoine.art","username":"Luna Belle","slug":"luna-belle","join_date":"2025-09-09T12:00:00","featured":true,"policies":[]}	{"description":"Award-winning model, dancer and actress with 15+ years of experience.","website":"pivoine.art","username":"Luna Belle","slug":"luna-belle","join_date":"2025-09-09T12:00:00","featured":true}	\N	\N
366	466	directus_users	543f4d0b-e346-4e5e-8aca-4a9b35d5fab6	{"id":"543f4d0b-e346-4e5e-8aca-4a9b35d5fab6","first_name":"Palina","last_name":"Rojinski","email":"palina@pivoine.art","password":"**********","location":null,"title":null,"description":"Award-winning model, dancer and actress with 15+ years of experience.","tags":["Love","Sex","Design","Art"],"avatar":"14dc2f96-fa93-4b64-b0a5-1b8e586fe0e4","language":null,"tfa_secret":null,"status":"active","role":"55da25e6-9a87-4264-92e8-9066fdcf9c07","token":null,"last_access":null,"last_page":null,"provider":"default","external_identifier":null,"auth_data":null,"email_notifications":true,"appearance":null,"theme_dark":null,"theme_light":null,"theme_light_overrides":null,"theme_dark_overrides":null,"text_direction":"auto","website":"pivoine.art","username":"Luna Belle","slug":"luna-belle","join_date":"2025-09-09T12:00:00","featured":true,"policies":[]}	{"avatar":"14dc2f96-fa93-4b64-b0a5-1b8e586fe0e4"}	\N	\N
400	529	directus_permissions	57	{"id":57,"collection":"directus_users","action":"read","permissions":{"_and":[{"policies":{"policy":{"name":{"_eq":"Model"}}}},{"_or":[]},{"role":{"name":{"_eq":"Model"}}}]},"validation":null,"presets":null,"fields":["website","slug","join_date","featured","title","description","tags","username","avatar","location","id"],"policy":"abf8a154-5b1c-4a46-ac9c-7300570f4f17"}	{"collection":"directus_users","action":"read","permissions":{"_and":[{"policies":{"policy":{"name":{"_eq":"Model"}}}},{"_or":[]},{"role":{"name":{"_eq":"Model"}}}]},"validation":null,"presets":null,"fields":["website","slug","join_date","featured","title","description","tags","username","avatar","location","id"],"policy":"abf8a154-5b1c-4a46-ac9c-7300570f4f17"}	\N	\N
410	546	directus_policies	abf8a154-5b1c-4a46-ac9c-7300570f4f17	{"id":"abf8a154-5b1c-4a46-ac9c-7300570f4f17","name":"$t:public_label","icon":"public","description":"$t:public_description","ip_access":null,"enforce_tfa":false,"admin_access":false,"app_access":false,"permissions":[27,35,40,42,57,65,66,67],"users":["34e30350-eb02-4888-80b1-d09b6dcc85e8"],"roles":["34e30350-eb02-4888-80b1-d09b6dcc85e8"]}	{"admin_access":false,"app_access":false}	\N	\N
444	582	directus_permissions	90	{"policy":"f575bea7-7260-4d81-a931-81d762f2b47d","permissions":null,"validation":null,"fields":["*"],"presets":null,"collection":"directus_fields","action":"read"}	{"policy":"f575bea7-7260-4d81-a931-81d762f2b47d","permissions":null,"validation":null,"fields":["*"],"presets":null,"collection":"directus_fields","action":"read"}	\N	\N
445	583	directus_permissions	91	{"policy":"f575bea7-7260-4d81-a931-81d762f2b47d","permissions":null,"validation":null,"fields":["*"],"presets":null,"collection":"directus_fields","action":"create"}	{"policy":"f575bea7-7260-4d81-a931-81d762f2b47d","permissions":null,"validation":null,"fields":["*"],"presets":null,"collection":"directus_fields","action":"create"}	\N	\N
446	584	directus_permissions	92	{"policy":"f575bea7-7260-4d81-a931-81d762f2b47d","permissions":null,"validation":null,"fields":["*"],"presets":null,"collection":"directus_fields","action":"update"}	{"policy":"f575bea7-7260-4d81-a931-81d762f2b47d","permissions":null,"validation":null,"fields":["*"],"presets":null,"collection":"directus_fields","action":"update"}	\N	\N
447	585	directus_permissions	93	{"policy":"f575bea7-7260-4d81-a931-81d762f2b47d","permissions":null,"validation":null,"fields":["*"],"presets":null,"collection":"directus_fields","action":"delete"}	{"policy":"f575bea7-7260-4d81-a931-81d762f2b47d","permissions":null,"validation":null,"fields":["*"],"presets":null,"collection":"directus_fields","action":"delete"}	\N	\N
448	586	directus_permissions	94	{"policy":"f575bea7-7260-4d81-a931-81d762f2b47d","permissions":null,"validation":null,"fields":["*"],"presets":null,"collection":"directus_fields","action":"share"}	{"policy":"f575bea7-7260-4d81-a931-81d762f2b47d","permissions":null,"validation":null,"fields":["*"],"presets":null,"collection":"directus_fields","action":"share"}	\N	\N
449	587	directus_permissions	95	{"policy":"f575bea7-7260-4d81-a931-81d762f2b47d","permissions":null,"validation":null,"fields":["*"],"presets":null,"collection":"directus_access","action":"read"}	{"policy":"f575bea7-7260-4d81-a931-81d762f2b47d","permissions":null,"validation":null,"fields":["*"],"presets":null,"collection":"directus_access","action":"read"}	\N	\N
450	588	directus_permissions	96	{"policy":"f575bea7-7260-4d81-a931-81d762f2b47d","permissions":null,"validation":null,"fields":["*"],"presets":null,"collection":"directus_access","action":"create"}	{"policy":"f575bea7-7260-4d81-a931-81d762f2b47d","permissions":null,"validation":null,"fields":["*"],"presets":null,"collection":"directus_access","action":"create"}	\N	\N
451	589	directus_permissions	97	{"policy":"f575bea7-7260-4d81-a931-81d762f2b47d","permissions":null,"validation":null,"fields":["*"],"presets":null,"collection":"directus_access","action":"update"}	{"policy":"f575bea7-7260-4d81-a931-81d762f2b47d","permissions":null,"validation":null,"fields":["*"],"presets":null,"collection":"directus_access","action":"update"}	\N	\N
452	590	directus_permissions	98	{"policy":"f575bea7-7260-4d81-a931-81d762f2b47d","permissions":null,"validation":null,"fields":["*"],"presets":null,"collection":"directus_access","action":"delete"}	{"policy":"f575bea7-7260-4d81-a931-81d762f2b47d","permissions":null,"validation":null,"fields":["*"],"presets":null,"collection":"directus_access","action":"delete"}	\N	\N
453	591	directus_permissions	99	{"policy":"f575bea7-7260-4d81-a931-81d762f2b47d","permissions":null,"validation":null,"fields":["*"],"presets":null,"collection":"directus_access","action":"share"}	{"policy":"f575bea7-7260-4d81-a931-81d762f2b47d","permissions":null,"validation":null,"fields":["*"],"presets":null,"collection":"directus_access","action":"share"}	\N	\N
344	421	directus_permissions	37	{"policy":"abf8a154-5b1c-4a46-ac9c-7300570f4f17","permissions":null,"validation":null,"fields":["*"],"presets":null,"collection":"directus_policies","action":"read"}	{"policy":"abf8a154-5b1c-4a46-ac9c-7300570f4f17","permissions":null,"validation":null,"fields":["*"],"presets":null,"collection":"directus_policies","action":"read"}	\N	\N
364	462	directus_users	543f4d0b-e346-4e5e-8aca-4a9b35d5fab6	{"id":"543f4d0b-e346-4e5e-8aca-4a9b35d5fab6","first_name":"Palina","last_name":"Rojinski","email":"palina@pivoine.art","password":"**********","location":null,"title":null,"description":"Award-winning model, dancer and actress with 15+ years of experience.","tags":["Love","Sex","Design","Art"],"avatar":null,"language":null,"tfa_secret":null,"status":"active","role":"55da25e6-9a87-4264-92e8-9066fdcf9c07","token":null,"last_access":null,"last_page":null,"provider":"default","external_identifier":null,"auth_data":null,"email_notifications":true,"appearance":null,"theme_dark":null,"theme_light":null,"theme_light_overrides":null,"theme_dark_overrides":null,"text_direction":"auto","website":"pivoine.art","username":"Luna Belle","slug":"luna-belle","join_date":"2025-09-09T12:00:00","featured":true,"policies":[]}	{"tags":["Love","Sex","Design","Art"],"role":"55da25e6-9a87-4264-92e8-9066fdcf9c07"}	\N	\N
365	465	directus_files	14dc2f96-fa93-4b64-b0a5-1b8e586fe0e4	{"title":"Luna Belle","filename_download":"luna-belle.jpg","type":"image/jpeg","storage":"local","folder":"c214c905-885b-4d66-a6a1-6527b0606200"}	{"title":"Luna Belle","filename_download":"luna-belle.jpg","type":"image/jpeg","storage":"local","folder":"c214c905-885b-4d66-a6a1-6527b0606200"}	\N	\N
401	531	directus_permissions	57	{"id":57,"collection":"directus_users","action":"read","permissions":{"_and":[{"policies":{"policy":{"name":{"_eq":"Model"}}}},{"_or":[{"role":{"name":{"_eq":"Model"}}}]}]},"validation":null,"presets":null,"fields":["website","slug","join_date","featured","title","description","tags","username","avatar","location","id"],"policy":"abf8a154-5b1c-4a46-ac9c-7300570f4f17"}	{"collection":"directus_users","action":"read","permissions":{"_and":[{"policies":{"policy":{"name":{"_eq":"Model"}}}},{"_or":[{"role":{"name":{"_eq":"Model"}}}]}]},"validation":null,"presets":null,"fields":["website","slug","join_date","featured","title","description","tags","username","avatar","location","id"],"policy":"abf8a154-5b1c-4a46-ac9c-7300570f4f17"}	\N	\N
411	547	directus_policies	abf8a154-5b1c-4a46-ac9c-7300570f4f17	{"id":"abf8a154-5b1c-4a46-ac9c-7300570f4f17","name":"$t:public_label","icon":"public","description":"$t:public_description","ip_access":null,"enforce_tfa":false,"admin_access":true,"app_access":true,"permissions":[27,35,40,42,57,65,66,67],"users":["34e30350-eb02-4888-80b1-d09b6dcc85e8"],"roles":["34e30350-eb02-4888-80b1-d09b6dcc85e8"]}	{"admin_access":true,"app_access":true}	\N	\N
454	593	directus_permissions	70	{"id":70,"collection":"directus_files","action":"read","permissions":null,"validation":null,"presets":null,"fields":["*"],"policy":"f575bea7-7260-4d81-a931-81d762f2b47d"}	{"collection":"directus_files","action":"read","permissions":null,"validation":null,"presets":null,"fields":["*"],"policy":"f575bea7-7260-4d81-a931-81d762f2b47d"}	\N	\N
455	594	directus_permissions	95	{"id":95,"collection":"directus_access","action":"read","permissions":null,"validation":null,"presets":null,"fields":["*"],"policy":"f575bea7-7260-4d81-a931-81d762f2b47d"}	{"collection":"directus_access","action":"read","permissions":null,"validation":null,"presets":null,"fields":["*"],"policy":"f575bea7-7260-4d81-a931-81d762f2b47d"}	\N	\N
456	595	directus_permissions	73	{"id":73,"collection":"directus_policies","action":"read","permissions":null,"validation":null,"presets":null,"fields":["*"],"policy":"f575bea7-7260-4d81-a931-81d762f2b47d"}	{"collection":"directus_policies","action":"read","permissions":null,"validation":null,"presets":null,"fields":["*"],"policy":"f575bea7-7260-4d81-a931-81d762f2b47d"}	\N	\N
457	596	directus_permissions	72	{"id":72,"collection":"directus_roles","action":"read","permissions":null,"validation":null,"presets":null,"fields":["*"],"policy":"f575bea7-7260-4d81-a931-81d762f2b47d"}	{"collection":"directus_roles","action":"read","permissions":null,"validation":null,"presets":null,"fields":["*"],"policy":"f575bea7-7260-4d81-a931-81d762f2b47d"}	\N	\N
458	597	directus_permissions	71	{"id":71,"collection":"directus_users","action":"read","permissions":null,"validation":null,"presets":null,"fields":["*"],"policy":"f575bea7-7260-4d81-a931-81d762f2b47d"}	{"collection":"directus_users","action":"read","permissions":null,"validation":null,"presets":null,"fields":["*"],"policy":"f575bea7-7260-4d81-a931-81d762f2b47d"}	\N	\N
345	441	directus_permissions	28	{"id":28,"collection":"directus_users","action":"read","permissions":{"_and":[{"policies":{"policy":{"name":{"_eq":"Creator"}}}}]},"validation":null,"presets":null,"fields":["first_name","website","email","password","avatar","location","title","description","tags","preferences_divider","language","text_direction","tfa_secret","email_notifications","theming_divider","appearance","theme_light","theme_light_overrides","theme_dark","theme_dark_overrides","admin_divider","status","role","policies","token","id","last_page","last_access","provider","external_identifier","auth_data","last_name"],"policy":"abf8a154-5b1c-4a46-ac9c-7300570f4f17"}	{"collection":"directus_users","action":"read","permissions":{"_and":[{"policies":{"policy":{"name":{"_eq":"Creator"}}}}]},"validation":null,"presets":null,"fields":["first_name","website","email","password","avatar","location","title","description","tags","preferences_divider","language","text_direction","tfa_secret","email_notifications","theming_divider","appearance","theme_light","theme_light_overrides","theme_dark","theme_dark_overrides","admin_divider","status","role","policies","token","id","last_page","last_access","provider","external_identifier","auth_data","last_name"],"policy":"abf8a154-5b1c-4a46-ac9c-7300570f4f17"}	\N	\N
346	443	directus_fields	73	{"sort":2,"interface":"input","special":null,"collection":"directus_users","field":"username"}	{"sort":2,"interface":"input","special":null,"collection":"directus_users","field":"username"}	\N	\N
347	444	directus_fields	73	{"id":73,"collection":"directus_users","field":"username","special":null,"interface":"input","options":null,"display":null,"display_options":null,"readonly":false,"hidden":false,"sort":1,"width":"full","translations":null,"note":null,"conditions":null,"required":false,"group":null,"validation":null,"validation_message":null}	{"collection":"directus_users","field":"username","sort":1,"group":null}	\N	\N
348	445	directus_fields	40	{"id":40,"collection":"directus_users","field":"website","special":null,"interface":"input","options":null,"display":null,"display_options":null,"readonly":false,"hidden":false,"sort":2,"width":"full","translations":null,"note":null,"conditions":null,"required":false,"group":null,"validation":null,"validation_message":null}	{"collection":"directus_users","field":"website","sort":2,"group":null}	\N	\N
349	446	directus_fields	74	{"sort":3,"interface":"input","special":null,"collection":"directus_users","field":"slug"}	{"sort":3,"interface":"input","special":null,"collection":"directus_users","field":"slug"}	\N	\N
350	447	directus_fields	73	{"id":73,"collection":"directus_users","field":"username","special":null,"interface":"input","options":{"trim":true},"display":null,"display_options":null,"readonly":false,"hidden":false,"sort":1,"width":"full","translations":null,"note":null,"conditions":null,"required":false,"group":null,"validation":null,"validation_message":null}	{"collection":"directus_users","field":"username","options":{"trim":true}}	\N	\N
367	467	directus_roles	55da25e6-9a87-4264-92e8-9066fdcf9c07	{"id":"55da25e6-9a87-4264-92e8-9066fdcf9c07","name":"Model","icon":"missed_video_call","description":"A creator is capable of creating videos by uploading them.","parent":null,"children":[],"policies":["aa848283-ea71-4c25-8e2f-e9024bce0d4f"],"users":["543f4d0b-e346-4e5e-8aca-4a9b35d5fab6"]}	{"name":"Model"}	\N	\N
402	533	directus_permissions	57	{"id":57,"collection":"directus_users","action":"read","permissions":{"_and":[{"_or":[{"role":{"name":{"_eq":"Model"}}},{"policies":{"policy":{"name":{"_eq":"Model"}}}}]}]},"validation":null,"presets":null,"fields":["website","slug","join_date","featured","title","description","tags","username","avatar","location","id"],"policy":"abf8a154-5b1c-4a46-ac9c-7300570f4f17"}	{"collection":"directus_users","action":"read","permissions":{"_and":[{"_or":[{"role":{"name":{"_eq":"Model"}}},{"policies":{"policy":{"name":{"_eq":"Model"}}}}]}]},"validation":null,"presets":null,"fields":["website","slug","join_date","featured","title","description","tags","username","avatar","location","id"],"policy":"abf8a154-5b1c-4a46-ac9c-7300570f4f17"}	\N	\N
413	549	directus_access	34e30350-eb02-4888-80b1-d09b6dcc85e8	{"id":"34e30350-eb02-4888-80b1-d09b6dcc85e8","role":null,"user":null,"policy":"abf8a154-5b1c-4a46-ac9c-7300570f4f17","sort":1}	{"policy":"abf8a154-5b1c-4a46-ac9c-7300570f4f17"}	\N	\N
412	548	directus_policies	abf8a154-5b1c-4a46-ac9c-7300570f4f17	{"id":"abf8a154-5b1c-4a46-ac9c-7300570f4f17","name":"$t:public_label","icon":"public","description":"$t:public_description","ip_access":null,"enforce_tfa":false,"admin_access":false,"app_access":false,"permissions":[27,35,40,42,57,65,66,67],"users":["34e30350-eb02-4888-80b1-d09b6dcc85e8"],"roles":["34e30350-eb02-4888-80b1-d09b6dcc85e8"]}	{"admin_access":false,"app_access":false}	413	\N
459	624	directus_permissions	71	{"id":71,"collection":"directus_users","action":"read","permissions":null,"validation":null,"presets":null,"fields":["username","website","slug","join_date","avatar","featured","location","title","description","tags"],"policy":"f575bea7-7260-4d81-a931-81d762f2b47d"}	{"collection":"directus_users","action":"read","permissions":null,"validation":null,"presets":null,"fields":["username","website","slug","join_date","avatar","featured","location","title","description","tags"],"policy":"f575bea7-7260-4d81-a931-81d762f2b47d"}	\N	\N
351	448	directus_users	4d310101-f7b1-47fe-982a-efe4abf25c55	{"id":"4d310101-f7b1-47fe-982a-efe4abf25c55","first_name":"Sebastian","last_name":"Krüger","email":"valknar@pivoine.art","password":"**********","location":null,"title":null,"description":"Visionary leader with 15+ years in digital media and content creation.","tags":null,"avatar":"99c47c3d-4865-4361-a545-f38e54fccb0b","language":null,"tfa_secret":"**********","status":"active","role":"ea3a9127-2b65-462c-85a8-dbafe9b4fe24","token":null,"last_access":"2025-09-16T10:34:16.386Z","last_page":"/users/4d310101-f7b1-47fe-982a-efe4abf25c55","provider":"default","external_identifier":null,"auth_data":null,"email_notifications":true,"appearance":null,"theme_dark":null,"theme_light":null,"theme_light_overrides":null,"theme_dark_overrides":null,"text_direction":"auto","website":"pivoine.art","username":"Valknar","slug":"valknar","policies":["b4f61dcc-b54e-4b3e-8a5e-bfbf029f6349","77084e57-682d-43e0-b570-acaf9fe94b1f","21e031ff-632d-46e5-97bb-959a5fef2538"]}	{"username":"Valknar","slug":"valknar"}	\N	\N
368	468	directus_permissions	28	{"id":28,"collection":"directus_users","action":"read","permissions":null,"validation":null,"presets":null,"fields":["*"],"policy":"abf8a154-5b1c-4a46-ac9c-7300570f4f17"}	{"collection":"directus_users","action":"read","permissions":null,"validation":null,"presets":null,"fields":["*"],"policy":"abf8a154-5b1c-4a46-ac9c-7300570f4f17"}	\N	\N
403	535	directus_permissions	57	{"id":57,"collection":"directus_users","action":"read","permissions":null,"validation":null,"presets":null,"fields":["*"],"policy":"abf8a154-5b1c-4a46-ac9c-7300570f4f17"}	{"collection":"directus_users","action":"read","permissions":null,"validation":null,"presets":null,"fields":["*"],"policy":"abf8a154-5b1c-4a46-ac9c-7300570f4f17"}	\N	\N
415	552	directus_access	1e42d4ff-0ead-4651-a283-7b21a158d5ea	{"policy":{"name":"Public","icon":"public"}}	{"policy":{"name":"Public","icon":"public"}}	\N	\N
414	551	directus_policies	f575bea7-7260-4d81-a931-81d762f2b47d	{"name":"Public","icon":"public"}	{"name":"Public","icon":"public"}	415	\N
460	626	directus_permissions	71	{"id":71,"collection":"directus_users","action":"read","permissions":null,"validation":null,"presets":null,"fields":["username","website","slug","join_date","avatar","featured","location","title","description","tags","policies","role","id"],"policy":"f575bea7-7260-4d81-a931-81d762f2b47d"}	{"collection":"directus_users","action":"read","permissions":null,"validation":null,"presets":null,"fields":["username","website","slug","join_date","avatar","featured","location","title","description","tags","policies","role","id"],"policy":"f575bea7-7260-4d81-a931-81d762f2b47d"}	\N	\N
352	449	directus_permissions	28	{"id":28,"collection":"directus_users","action":"read","permissions":{"_and":[{"policies":{"policy":{"name":{"_eq":"Creator"}}}}]},"validation":null,"presets":null,"fields":["website","avatar","location","title","description","tags","username","id","slug"],"policy":"abf8a154-5b1c-4a46-ac9c-7300570f4f17"}	{"collection":"directus_users","action":"read","permissions":{"_and":[{"policies":{"policy":{"name":{"_eq":"Creator"}}}}]},"validation":null,"presets":null,"fields":["website","avatar","location","title","description","tags","username","id","slug"],"policy":"abf8a154-5b1c-4a46-ac9c-7300570f4f17"}	\N	\N
354	452	directus_policies	656e614d-a1aa-4b89-936a-e2c730fc85e1	{"id":"656e614d-a1aa-4b89-936a-e2c730fc85e1","name":"Editor","icon":"ink_pen","description":null,"ip_access":null,"enforce_tfa":false,"admin_access":false,"app_access":false,"permissions":[29,30,31,32,33],"users":["11fa655a-6998-4c6b-b35f-42fd174d4536","b4f61dcc-b54e-4b3e-8a5e-bfbf029f6349"],"roles":["11fa655a-6998-4c6b-b35f-42fd174d4536","b4f61dcc-b54e-4b3e-8a5e-bfbf029f6349"]}	{"enforce_tfa":false}	\N	\N
369	470	directus_permissions	38	{"policy":"abf8a154-5b1c-4a46-ac9c-7300570f4f17","permissions":null,"validation":null,"fields":["*"],"presets":null,"collection":"directus_policies","action":"read"}	{"policy":"abf8a154-5b1c-4a46-ac9c-7300570f4f17","permissions":null,"validation":null,"fields":["*"],"presets":null,"collection":"directus_policies","action":"read"}	\N	\N
404	537	directus_permissions	57	{"id":57,"collection":"directus_users","action":"read","permissions":null,"validation":null,"presets":null,"fields":["*"],"policy":"abf8a154-5b1c-4a46-ac9c-7300570f4f17"}	{"collection":"directus_users","action":"read","permissions":null,"validation":null,"presets":null,"fields":["*"],"policy":"abf8a154-5b1c-4a46-ac9c-7300570f4f17"}	\N	\N
416	553	directus_policies	895bd74b-97d6-4bae-87fa-8741a717127e	{"name":"Public Test","admin_access":false,"app_access":false}	{"name":"Public Test","admin_access":false,"app_access":false}	\N	\N
461	628	directus_permissions	71	{"id":71,"collection":"directus_users","action":"read","permissions":{"_and":[{"_or":[{"role":{"name":{"_eq":"Model"}}},{"policies":{"policy":{"name":{"_eq":"Model"}}}}]}]},"validation":null,"presets":null,"fields":["username","website","slug","join_date","avatar","featured","location","title","description","tags","policies","role","id"],"policy":"f575bea7-7260-4d81-a931-81d762f2b47d"}	{"collection":"directus_users","action":"read","permissions":{"_and":[{"_or":[{"role":{"name":{"_eq":"Model"}}},{"policies":{"policy":{"name":{"_eq":"Model"}}}}]}]},"validation":null,"presets":null,"fields":["username","website","slug","join_date","avatar","featured","location","title","description","tags","policies","role","id"],"policy":"f575bea7-7260-4d81-a931-81d762f2b47d"}	\N	\N
353	451	directus_policies	7f06bc6a-6c55-4672-aedc-1c25b42dca52	{"id":"7f06bc6a-6c55-4672-aedc-1c25b42dca52","name":"Model","icon":"missed_video_call","description":null,"ip_access":null,"enforce_tfa":true,"admin_access":false,"app_access":true,"permissions":[],"users":["aa848283-ea71-4c25-8e2f-e9024bce0d4f","77084e57-682d-43e0-b570-acaf9fe94b1f"],"roles":["aa848283-ea71-4c25-8e2f-e9024bce0d4f","77084e57-682d-43e0-b570-acaf9fe94b1f"]}	{"name":"Model"}	\N	\N
355	453	directus_policies	656e614d-a1aa-4b89-936a-e2c730fc85e1	{"id":"656e614d-a1aa-4b89-936a-e2c730fc85e1","name":"Editor","icon":"ink_pen","description":null,"ip_access":null,"enforce_tfa":false,"admin_access":false,"app_access":true,"permissions":[29,30,31,32,33],"users":["11fa655a-6998-4c6b-b35f-42fd174d4536","b4f61dcc-b54e-4b3e-8a5e-bfbf029f6349"],"roles":["11fa655a-6998-4c6b-b35f-42fd174d4536","b4f61dcc-b54e-4b3e-8a5e-bfbf029f6349"]}	{"app_access":true}	\N	\N
370	472	directus_permissions	39	{"policy":"abf8a154-5b1c-4a46-ac9c-7300570f4f17","permissions":null,"validation":null,"fields":["*"],"presets":null,"collection":"directus_roles","action":"read"}	{"policy":"abf8a154-5b1c-4a46-ac9c-7300570f4f17","permissions":null,"validation":null,"fields":["*"],"presets":null,"collection":"directus_roles","action":"read"}	\N	\N
405	539	directus_permissions	65	{"policy":"abf8a154-5b1c-4a46-ac9c-7300570f4f17","permissions":null,"validation":null,"fields":["*"],"presets":null,"collection":"directus_policies","action":"read"}	{"policy":"abf8a154-5b1c-4a46-ac9c-7300570f4f17","permissions":null,"validation":null,"fields":["*"],"presets":null,"collection":"directus_policies","action":"read"}	\N	\N
406	540	directus_permissions	66	{"policy":"abf8a154-5b1c-4a46-ac9c-7300570f4f17","permissions":null,"validation":null,"fields":["*"],"presets":null,"collection":"directus_roles","action":"read"}	{"policy":"abf8a154-5b1c-4a46-ac9c-7300570f4f17","permissions":null,"validation":null,"fields":["*"],"presets":null,"collection":"directus_roles","action":"read"}	\N	\N
421	559	directus_policies	f575bea7-7260-4d81-a931-81d762f2b47d	{"id":"f575bea7-7260-4d81-a931-81d762f2b47d","name":"Public","icon":"public","description":null,"ip_access":null,"enforce_tfa":false,"admin_access":true,"app_access":false,"permissions":[68,69,70,71],"users":["1e42d4ff-0ead-4651-a283-7b21a158d5ea"],"roles":["1e42d4ff-0ead-4651-a283-7b21a158d5ea"]}	{"admin_access":true}	\N	\N
417	555	directus_permissions	68	{"policy":"f575bea7-7260-4d81-a931-81d762f2b47d","permissions":null,"validation":null,"fields":["*"],"presets":null,"collection":"sexy_articles","action":"read"}	{"policy":"f575bea7-7260-4d81-a931-81d762f2b47d","permissions":null,"validation":null,"fields":["*"],"presets":null,"collection":"sexy_articles","action":"read"}	421	\N
418	556	directus_permissions	69	{"policy":"f575bea7-7260-4d81-a931-81d762f2b47d","permissions":null,"validation":null,"fields":["*"],"presets":null,"collection":"sexy_videos","action":"read"}	{"policy":"f575bea7-7260-4d81-a931-81d762f2b47d","permissions":null,"validation":null,"fields":["*"],"presets":null,"collection":"sexy_videos","action":"read"}	421	\N
419	557	directus_permissions	70	{"policy":"f575bea7-7260-4d81-a931-81d762f2b47d","permissions":null,"validation":null,"fields":["*"],"presets":null,"collection":"directus_files","action":"read"}	{"policy":"f575bea7-7260-4d81-a931-81d762f2b47d","permissions":null,"validation":null,"fields":["*"],"presets":null,"collection":"directus_files","action":"read"}	421	\N
420	558	directus_permissions	71	{"policy":"f575bea7-7260-4d81-a931-81d762f2b47d","permissions":null,"validation":null,"fields":["*"],"presets":null,"collection":"directus_users","action":"read"}	{"policy":"f575bea7-7260-4d81-a931-81d762f2b47d","permissions":null,"validation":null,"fields":["*"],"presets":null,"collection":"directus_users","action":"read"}	421	\N
422	560	directus_permissions	72	{"policy":"f575bea7-7260-4d81-a931-81d762f2b47d","permissions":null,"validation":null,"fields":["*"],"presets":null,"collection":"directus_roles","action":"read"}	{"policy":"f575bea7-7260-4d81-a931-81d762f2b47d","permissions":null,"validation":null,"fields":["*"],"presets":null,"collection":"directus_roles","action":"read"}	442	\N
423	561	directus_permissions	73	{"policy":"f575bea7-7260-4d81-a931-81d762f2b47d","permissions":null,"validation":null,"fields":["*"],"presets":null,"collection":"directus_policies","action":"read"}	{"policy":"f575bea7-7260-4d81-a931-81d762f2b47d","permissions":null,"validation":null,"fields":["*"],"presets":null,"collection":"directus_policies","action":"read"}	442	\N
424	562	directus_permissions	74	{"policy":"f575bea7-7260-4d81-a931-81d762f2b47d","permissions":null,"validation":null,"fields":["*"],"presets":null,"collection":"directus_users","action":"create"}	{"policy":"f575bea7-7260-4d81-a931-81d762f2b47d","permissions":null,"validation":null,"fields":["*"],"presets":null,"collection":"directus_users","action":"create"}	442	\N
552	765	directus_fields	79	{"sort":14,"interface":"list-m2m","special":["m2m"],"collection":"sexy_videos","field":"models"}	{"sort":14,"interface":"list-m2m","special":["m2m"],"collection":"sexy_videos","field":"models"}	\N	\N
425	563	directus_permissions	75	{"policy":"f575bea7-7260-4d81-a931-81d762f2b47d","permissions":null,"validation":null,"fields":["*"],"presets":null,"collection":"directus_users","action":"update"}	{"policy":"f575bea7-7260-4d81-a931-81d762f2b47d","permissions":null,"validation":null,"fields":["*"],"presets":null,"collection":"directus_users","action":"update"}	442	\N
356	454	directus_policies	7f06bc6a-6c55-4672-aedc-1c25b42dca52	{"id":"7f06bc6a-6c55-4672-aedc-1c25b42dca52","name":"Model","icon":"missed_video_call","description":null,"ip_access":null,"enforce_tfa":false,"admin_access":false,"app_access":true,"permissions":[],"users":["aa848283-ea71-4c25-8e2f-e9024bce0d4f","77084e57-682d-43e0-b570-acaf9fe94b1f"],"roles":["aa848283-ea71-4c25-8e2f-e9024bce0d4f","77084e57-682d-43e0-b570-acaf9fe94b1f"]}	{"enforce_tfa":false}	\N	\N
357	455	directus_policies	338928fb-f8ee-4450-8b24-4854dd8bc7e0	{"id":"338928fb-f8ee-4450-8b24-4854dd8bc7e0","name":"Viewer","icon":"eyeglasses","description":null,"ip_access":null,"enforce_tfa":false,"admin_access":false,"app_access":true,"permissions":[1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20],"users":["32084f66-b9e3-4192-b990-96b72afc8844"],"roles":["32084f66-b9e3-4192-b990-96b72afc8844"]}	{"enforce_tfa":false}	\N	\N
371	474	directus_policies	abf8a154-5b1c-4a46-ac9c-7300570f4f17	{"id":"abf8a154-5b1c-4a46-ac9c-7300570f4f17","name":"$t:public_label","icon":"public","description":"$t:public_description","ip_access":null,"enforce_tfa":false,"admin_access":false,"app_access":true,"permissions":[27,28,35,36,38,39],"users":["34e30350-eb02-4888-80b1-d09b6dcc85e8"],"roles":["34e30350-eb02-4888-80b1-d09b6dcc85e8"]}	{"app_access":true}	\N	\N
407	542	directus_permissions	67	{"policy":"abf8a154-5b1c-4a46-ac9c-7300570f4f17","permissions":null,"validation":null,"fields":["*"],"presets":null,"collection":"directus_permissions","action":"read"}	{"policy":"abf8a154-5b1c-4a46-ac9c-7300570f4f17","permissions":null,"validation":null,"fields":["*"],"presets":null,"collection":"directus_permissions","action":"read"}	\N	\N
358	456	directus_fields	75	{"sort":4,"interface":"datetime","special":null,"options":{"format":"short"},"collection":"directus_users","field":"join_date"}	{"sort":4,"interface":"datetime","special":null,"options":{"format":"short"},"collection":"directus_users","field":"join_date"}	\N	\N
359	457	directus_users	4d310101-f7b1-47fe-982a-efe4abf25c55	{"id":"4d310101-f7b1-47fe-982a-efe4abf25c55","first_name":"Sebastian","last_name":"Krüger","email":"valknar@pivoine.art","password":"**********","location":null,"title":null,"description":"Visionary leader with 15+ years in digital media and content creation.","tags":null,"avatar":"99c47c3d-4865-4361-a545-f38e54fccb0b","language":null,"tfa_secret":"**********","status":"active","role":"ea3a9127-2b65-462c-85a8-dbafe9b4fe24","token":null,"last_access":"2025-09-16T10:34:16.386Z","last_page":"/users/4d310101-f7b1-47fe-982a-efe4abf25c55","provider":"default","external_identifier":null,"auth_data":null,"email_notifications":true,"appearance":null,"theme_dark":null,"theme_light":null,"theme_light_overrides":null,"theme_dark_overrides":null,"text_direction":"auto","website":"pivoine.art","username":"Valknar","slug":"valknar","join_date":"2025-09-09T12:00:00","policies":["b4f61dcc-b54e-4b3e-8a5e-bfbf029f6349","77084e57-682d-43e0-b570-acaf9fe94b1f","21e031ff-632d-46e5-97bb-959a5fef2538"]}	{"join_date":"2025-09-09T12:00:00"}	\N	\N
397	504	directus_policies	abf8a154-5b1c-4a46-ac9c-7300570f4f17	{"id":"abf8a154-5b1c-4a46-ac9c-7300570f4f17","name":"$t:public_label","icon":"public","description":"$t:public_description","ip_access":null,"enforce_tfa":false,"admin_access":true,"app_access":false,"permissions":[27,35,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59,60,61,62,63,64],"users":["34e30350-eb02-4888-80b1-d09b6dcc85e8"],"roles":["34e30350-eb02-4888-80b1-d09b6dcc85e8"]}	{"admin_access":true,"app_access":false}	\N	\N
372	475	directus_permissions	40	{"collection":"directus_comments","action":"read","permissions":{},"fields":["*"],"policy":"abf8a154-5b1c-4a46-ac9c-7300570f4f17"}	{"collection":"directus_comments","action":"read","permissions":{},"fields":["*"],"policy":"abf8a154-5b1c-4a46-ac9c-7300570f4f17"}	397	\N
373	476	directus_permissions	41	{"collection":"directus_files","action":"create","permissions":{},"fields":["*"],"policy":"abf8a154-5b1c-4a46-ac9c-7300570f4f17"}	{"collection":"directus_files","action":"create","permissions":{},"fields":["*"],"policy":"abf8a154-5b1c-4a46-ac9c-7300570f4f17"}	397	\N
374	477	directus_permissions	42	{"collection":"directus_files","action":"read","permissions":{},"fields":["*"],"policy":"abf8a154-5b1c-4a46-ac9c-7300570f4f17"}	{"collection":"directus_files","action":"read","permissions":{},"fields":["*"],"policy":"abf8a154-5b1c-4a46-ac9c-7300570f4f17"}	397	\N
375	478	directus_permissions	43	{"collection":"directus_files","action":"update","permissions":{},"fields":["*"],"policy":"abf8a154-5b1c-4a46-ac9c-7300570f4f17"}	{"collection":"directus_files","action":"update","permissions":{},"fields":["*"],"policy":"abf8a154-5b1c-4a46-ac9c-7300570f4f17"}	397	\N
376	479	directus_permissions	44	{"collection":"directus_files","action":"delete","permissions":{},"fields":["*"],"policy":"abf8a154-5b1c-4a46-ac9c-7300570f4f17"}	{"collection":"directus_files","action":"delete","permissions":{},"fields":["*"],"policy":"abf8a154-5b1c-4a46-ac9c-7300570f4f17"}	397	\N
377	480	directus_permissions	45	{"collection":"directus_dashboards","action":"create","permissions":{},"fields":["*"],"policy":"abf8a154-5b1c-4a46-ac9c-7300570f4f17"}	{"collection":"directus_dashboards","action":"create","permissions":{},"fields":["*"],"policy":"abf8a154-5b1c-4a46-ac9c-7300570f4f17"}	397	\N
378	481	directus_permissions	46	{"collection":"directus_dashboards","action":"read","permissions":{},"fields":["*"],"policy":"abf8a154-5b1c-4a46-ac9c-7300570f4f17"}	{"collection":"directus_dashboards","action":"read","permissions":{},"fields":["*"],"policy":"abf8a154-5b1c-4a46-ac9c-7300570f4f17"}	397	\N
379	482	directus_permissions	47	{"collection":"directus_dashboards","action":"update","permissions":{},"fields":["*"],"policy":"abf8a154-5b1c-4a46-ac9c-7300570f4f17"}	{"collection":"directus_dashboards","action":"update","permissions":{},"fields":["*"],"policy":"abf8a154-5b1c-4a46-ac9c-7300570f4f17"}	397	\N
380	483	directus_permissions	48	{"collection":"directus_dashboards","action":"delete","permissions":{},"fields":["*"],"policy":"abf8a154-5b1c-4a46-ac9c-7300570f4f17"}	{"collection":"directus_dashboards","action":"delete","permissions":{},"fields":["*"],"policy":"abf8a154-5b1c-4a46-ac9c-7300570f4f17"}	397	\N
381	484	directus_permissions	49	{"collection":"directus_panels","action":"create","permissions":{},"fields":["*"],"policy":"abf8a154-5b1c-4a46-ac9c-7300570f4f17"}	{"collection":"directus_panels","action":"create","permissions":{},"fields":["*"],"policy":"abf8a154-5b1c-4a46-ac9c-7300570f4f17"}	397	\N
382	485	directus_permissions	50	{"collection":"directus_panels","action":"read","permissions":{},"fields":["*"],"policy":"abf8a154-5b1c-4a46-ac9c-7300570f4f17"}	{"collection":"directus_panels","action":"read","permissions":{},"fields":["*"],"policy":"abf8a154-5b1c-4a46-ac9c-7300570f4f17"}	397	\N
383	486	directus_permissions	51	{"collection":"directus_panels","action":"update","permissions":{},"fields":["*"],"policy":"abf8a154-5b1c-4a46-ac9c-7300570f4f17"}	{"collection":"directus_panels","action":"update","permissions":{},"fields":["*"],"policy":"abf8a154-5b1c-4a46-ac9c-7300570f4f17"}	397	\N
384	487	directus_permissions	52	{"collection":"directus_panels","action":"delete","permissions":{},"fields":["*"],"policy":"abf8a154-5b1c-4a46-ac9c-7300570f4f17"}	{"collection":"directus_panels","action":"delete","permissions":{},"fields":["*"],"policy":"abf8a154-5b1c-4a46-ac9c-7300570f4f17"}	397	\N
385	488	directus_permissions	53	{"collection":"directus_folders","action":"create","permissions":{},"fields":["*"],"policy":"abf8a154-5b1c-4a46-ac9c-7300570f4f17"}	{"collection":"directus_folders","action":"create","permissions":{},"fields":["*"],"policy":"abf8a154-5b1c-4a46-ac9c-7300570f4f17"}	397	\N
386	489	directus_permissions	54	{"collection":"directus_folders","action":"read","permissions":{},"fields":["*"],"policy":"abf8a154-5b1c-4a46-ac9c-7300570f4f17"}	{"collection":"directus_folders","action":"read","permissions":{},"fields":["*"],"policy":"abf8a154-5b1c-4a46-ac9c-7300570f4f17"}	397	\N
465	634	directus_fields	76	{"id":76,"collection":"directus_users","field":"featured","special":["cast-boolean"],"interface":"boolean","options":{"label":"Featured"},"display":null,"display_options":null,"readonly":true,"hidden":false,"sort":5,"width":"full","translations":null,"note":null,"conditions":null,"required":false,"group":null,"validation":null,"validation_message":null}	{"collection":"directus_users","field":"featured","readonly":true}	\N	\N
466	635	directus_fields	76	{"id":76,"collection":"directus_users","field":"featured","special":["cast-boolean"],"interface":"boolean","options":{"label":"Featured"},"display":null,"display_options":null,"readonly":false,"hidden":true,"sort":5,"width":"full","translations":null,"note":null,"conditions":null,"required":false,"group":null,"validation":null,"validation_message":null}	{"collection":"directus_users","field":"featured","readonly":false,"hidden":true}	\N	\N
467	636	directus_fields	76	{"id":76,"collection":"directus_users","field":"featured","special":["cast-boolean"],"interface":"boolean","options":{"label":"Featured"},"display":null,"display_options":null,"readonly":true,"hidden":false,"sort":5,"width":"full","translations":null,"note":null,"conditions":[{"name":"Enable for role \\"Administrator\\"","rule":null,"readonly":false}],"required":false,"group":null,"validation":null,"validation_message":null}	{"collection":"directus_users","field":"featured","readonly":true,"hidden":false,"conditions":[{"name":"Enable for role \\"Administrator\\"","rule":null,"readonly":false}]}	\N	\N
473	642	directus_fields	76	{"id":76,"collection":"directus_users","field":"featured","special":["cast-boolean"],"interface":"boolean","options":{"label":"Featured"},"display":null,"display_options":null,"readonly":true,"hidden":false,"sort":5,"width":"full","translations":null,"note":null,"conditions":[{"name":"Enable for role \\"Administrator\\"","rule":{"_and":[{"role":{"_eq":"ea3a9127-2b65-462c-85a8-dbafe9b4fe24"}}]},"readonly":false}],"required":false,"group":null,"validation":null,"validation_message":null}	{"collection":"directus_users","field":"featured","conditions":[{"name":"Enable for role \\"Administrator\\"","rule":{"_and":[{"role":{"_eq":"ea3a9127-2b65-462c-85a8-dbafe9b4fe24"}}]},"readonly":false}]}	\N	\N
487	658	directus_fields	77	{"id":77,"collection":"directus_users","field":"artist_name","special":null,"interface":"input","options":null,"display":null,"display_options":null,"readonly":false,"hidden":false,"sort":1,"width":"full","translations":null,"note":null,"conditions":null,"required":true,"group":null,"validation":null,"validation_message":null}	{"collection":"directus_users","field":"artist_name","sort":1,"group":null}	\N	\N
488	659	directus_fields	40	{"id":40,"collection":"directus_users","field":"website","special":null,"interface":"input","options":null,"display":null,"display_options":null,"readonly":false,"hidden":false,"sort":2,"width":"full","translations":null,"note":null,"conditions":null,"required":false,"group":null,"validation":null,"validation_message":null}	{"collection":"directus_users","field":"website","sort":2,"group":null}	\N	\N
489	660	directus_fields	74	{"id":74,"collection":"directus_users","field":"slug","special":null,"interface":"input","options":null,"display":null,"display_options":null,"readonly":false,"hidden":false,"sort":3,"width":"full","translations":null,"note":null,"conditions":[{"name":"Enable for role \\"Administrator\\"","rule":{"_and":[{"role":{"_eq":"ea3a9127-2b65-462c-85a8-dbafe9b4fe24"}}]},"readonly":false}],"required":true,"group":null,"validation":null,"validation_message":null}	{"collection":"directus_users","field":"slug","sort":3,"group":null}	\N	\N
490	661	directus_fields	75	{"id":75,"collection":"directus_users","field":"join_date","special":null,"interface":"datetime","options":{"format":"short"},"display":null,"display_options":null,"readonly":false,"hidden":false,"sort":4,"width":"full","translations":null,"note":null,"conditions":null,"required":true,"group":null,"validation":null,"validation_message":null}	{"collection":"directus_users","field":"join_date","sort":4,"group":null}	\N	\N
491	662	directus_fields	76	{"id":76,"collection":"directus_users","field":"featured","special":["cast-boolean"],"interface":"boolean","options":{"label":"Featured"},"display":null,"display_options":null,"readonly":false,"hidden":false,"sort":5,"width":"full","translations":null,"note":null,"conditions":null,"required":false,"group":null,"validation":null,"validation_message":null}	{"collection":"directus_users","field":"featured","sort":5,"group":null}	\N	\N
497	669	directus_users	4d310101-f7b1-47fe-982a-efe4abf25c55	{"id":"4d310101-f7b1-47fe-982a-efe4abf25c55","first_name":"Sebastian","last_name":"Krüger","email":"valknar@pivoine.art","password":"**********","location":null,"title":null,"description":"Visionary leader with 15+ years in digital media and content creation.","tags":["Love","Sex","Design","Art"],"avatar":"99c47c3d-4865-4361-a545-f38e54fccb0b","language":null,"tfa_secret":null,"status":"active","role":"ea3a9127-2b65-462c-85a8-dbafe9b4fe24","token":null,"last_access":"2025-09-20T14:11:18.648Z","last_page":"/settings/data-model/directus_users","provider":"default","external_identifier":null,"auth_data":null,"email_notifications":true,"appearance":null,"theme_dark":null,"theme_light":null,"theme_light_overrides":null,"theme_dark_overrides":null,"text_direction":"auto","website":"pivoine.art","slug":"valknar","join_date":"2025-09-09T12:00:00","featured":true,"artist_name":"Valknar","policies":["b4f61dcc-b54e-4b3e-8a5e-bfbf029f6349","77084e57-682d-43e0-b570-acaf9fe94b1f","21e031ff-632d-46e5-97bb-959a5fef2538"]}	{"tfa_secret":null}	\N	\N
468	637	directus_fields	76	{"id":76,"collection":"directus_users","field":"featured","special":["cast-boolean"],"interface":"boolean","options":{"label":"Featured"},"display":null,"display_options":null,"readonly":true,"hidden":false,"sort":5,"width":"full","translations":null,"note":null,"conditions":[{"name":"Enable for role \\"Administrator\\"","rule":{"_and":[{"role":{"_eq":"4d310101-f7b1-47fe-982a-efe4abf25c55"}}]},"readonly":false}],"required":false,"group":null,"validation":null,"validation_message":null}	{"collection":"directus_users","field":"featured","conditions":[{"name":"Enable for role \\"Administrator\\"","rule":{"_and":[{"role":{"_eq":"4d310101-f7b1-47fe-982a-efe4abf25c55"}}]},"readonly":false}]}	\N	\N
474	643	directus_fields	74	{"id":74,"collection":"directus_users","field":"slug","special":null,"interface":"input","options":null,"display":null,"display_options":null,"readonly":true,"hidden":false,"sort":3,"width":"full","translations":null,"note":null,"conditions":[{"name":"Enable for role \\"Administrator\\"","rule":{"_and":[{"role":{"_eq":"ea3a9127-2b65-462c-85a8-dbafe9b4fe24"}}]},"readonly":false}],"required":true,"group":null,"validation":null,"validation_message":null}	{"collection":"directus_users","field":"slug","readonly":true,"conditions":[{"name":"Enable for role \\"Administrator\\"","rule":{"_and":[{"role":{"_eq":"ea3a9127-2b65-462c-85a8-dbafe9b4fe24"}}]},"readonly":false}],"required":true}	\N	\N
492	663	directus_users	543f4d0b-e346-4e5e-8aca-4a9b35d5fab6	{"id":"543f4d0b-e346-4e5e-8aca-4a9b35d5fab6","first_name":"Palina","last_name":"Rojinski","email":"palina@pivoine.art","password":"**********","location":null,"title":null,"description":"Award-winning model, dancer and actress with 15+ years of experience.","tags":["Love","Sex","Design","Art"],"avatar":"14dc2f96-fa93-4b64-b0a5-1b8e586fe0e4","language":null,"tfa_secret":null,"status":"active","role":"55da25e6-9a87-4264-92e8-9066fdcf9c07","token":null,"last_access":null,"last_page":null,"provider":"default","external_identifier":null,"auth_data":null,"email_notifications":true,"appearance":null,"theme_dark":null,"theme_light":null,"theme_light_overrides":null,"theme_dark_overrides":null,"text_direction":"auto","website":"pivoine.art","slug":"luna-belle","join_date":"2025-09-09T12:00:00","featured":true,"artist_name":"Luna Belle","policies":[]}	{"slug":"luna-belle","artist_name":"Luna Belle"}	\N	\N
469	638	directus_fields	76	{"id":76,"collection":"directus_users","field":"featured","special":["cast-boolean"],"interface":"boolean","options":{"label":"Featured"},"display":null,"display_options":null,"readonly":true,"hidden":false,"sort":5,"width":"full","translations":null,"note":null,"conditions":[{"name":"Enable for role \\"Administrator\\"","rule":{"_and":[{"role":{"_eq":"4d310101-f7b1-47fe-982a-efe4abf25c55"}}]},"readonly":false}],"required":false,"group":null,"validation":null,"validation_message":null}	{"collection":"directus_users","field":"featured"}	\N	\N
475	644	directus_fields	75	{"id":75,"collection":"directus_users","field":"join_date","special":null,"interface":"datetime","options":{"format":"short"},"display":null,"display_options":null,"readonly":true,"hidden":false,"sort":4,"width":"full","translations":null,"note":null,"conditions":null,"required":true,"group":null,"validation":null,"validation_message":null}	{"collection":"directus_users","field":"join_date","readonly":true}	\N	\N
493	664	directus_users	4d310101-f7b1-47fe-982a-efe4abf25c55	{"id":"4d310101-f7b1-47fe-982a-efe4abf25c55","first_name":"Sebastian","last_name":"Krüger","email":"valknar@pivoine.art","password":"**********","location":null,"title":null,"description":"Visionary leader with 15+ years in digital media and content creation.","tags":["Love","Sex","Design","Art"],"avatar":"99c47c3d-4865-4361-a545-f38e54fccb0b","language":null,"tfa_secret":"**********","status":"active","role":"ea3a9127-2b65-462c-85a8-dbafe9b4fe24","token":null,"last_access":"2025-09-20T14:11:18.648Z","last_page":"/settings/data-model/directus_users","provider":"default","external_identifier":null,"auth_data":null,"email_notifications":true,"appearance":null,"theme_dark":null,"theme_light":null,"theme_light_overrides":null,"theme_dark_overrides":null,"text_direction":"auto","website":"pivoine.art","slug":"valknar","join_date":"2025-09-09T12:00:00","featured":true,"artist_name":"Valknar","policies":["b4f61dcc-b54e-4b3e-8a5e-bfbf029f6349","77084e57-682d-43e0-b570-acaf9fe94b1f","21e031ff-632d-46e5-97bb-959a5fef2538"]}	{"slug":"valknar","artist_name":"Valknar"}	\N	\N
470	639	directus_fields	76	{"id":76,"collection":"directus_users","field":"featured","special":["cast-boolean"],"interface":"boolean","options":{"label":"Featured"},"display":null,"display_options":null,"readonly":false,"hidden":false,"sort":5,"width":"full","translations":null,"note":null,"conditions":[{"name":"Enable for role \\"Administrator\\"","rule":{"_and":[{"role":{"_eq":"4d310101-f7b1-47fe-982a-efe4abf25c55"}}]},"readonly":false}],"required":false,"group":null,"validation":null,"validation_message":null}	{"collection":"directus_users","field":"featured","readonly":false}	\N	\N
471	640	directus_fields	76	{"id":76,"collection":"directus_users","field":"featured","special":["cast-boolean"],"interface":"boolean","options":{"label":"Featured"},"display":null,"display_options":null,"readonly":false,"hidden":false,"sort":5,"width":"full","translations":null,"note":null,"conditions":[{"name":"Enable for role \\"Administrator\\"","rule":{"_and":[{"role":{"_neq":"4d310101-f7b1-47fe-982a-efe4abf25c55"}}]},"readonly":true}],"required":false,"group":null,"validation":null,"validation_message":null}	{"collection":"directus_users","field":"featured","conditions":[{"name":"Enable for role \\"Administrator\\"","rule":{"_and":[{"role":{"_neq":"4d310101-f7b1-47fe-982a-efe4abf25c55"}}]},"readonly":true}]}	\N	\N
476	645	directus_fields	73	{"id":73,"collection":"directus_users","field":"username","special":null,"interface":"input","options":{"trim":true},"display":null,"display_options":null,"readonly":false,"hidden":false,"sort":1,"width":"full","translations":null,"note":null,"conditions":null,"required":false,"group":null,"validation":null,"validation_message":null}	{"collection":"directus_users","field":"username","required":false}	\N	\N
477	646	directus_fields	74	{"id":74,"collection":"directus_users","field":"slug","special":null,"interface":"input","options":null,"display":null,"display_options":null,"readonly":true,"hidden":false,"sort":3,"width":"full","translations":null,"note":null,"conditions":[{"name":"Enable for role \\"Administrator\\"","rule":{"_and":[{"role":{"_eq":"ea3a9127-2b65-462c-85a8-dbafe9b4fe24"}}]},"readonly":false}],"required":false,"group":null,"validation":null,"validation_message":null}	{"collection":"directus_users","field":"slug","required":false}	\N	\N
478	647	directus_fields	75	{"id":75,"collection":"directus_users","field":"join_date","special":null,"interface":"datetime","options":{"format":"short"},"display":null,"display_options":null,"readonly":true,"hidden":false,"sort":4,"width":"full","translations":null,"note":null,"conditions":null,"required":false,"group":null,"validation":null,"validation_message":null}	{"collection":"directus_users","field":"join_date","required":false}	\N	\N
479	648	directus_fields	73	{"id":73,"collection":"directus_users","field":"username","special":null,"interface":"input","options":{"trim":true},"display":null,"display_options":null,"readonly":false,"hidden":false,"sort":1,"width":"full","translations":null,"note":null,"conditions":null,"required":true,"group":null,"validation":null,"validation_message":null}	{"collection":"directus_users","field":"username","required":true}	\N	\N
480	649	directus_fields	74	{"id":74,"collection":"directus_users","field":"slug","special":null,"interface":"input","options":null,"display":null,"display_options":null,"readonly":true,"hidden":false,"sort":3,"width":"full","translations":null,"note":null,"conditions":[{"name":"Enable for role \\"Administrator\\"","rule":{"_and":[{"role":{"_eq":"ea3a9127-2b65-462c-85a8-dbafe9b4fe24"}}]},"readonly":false}],"required":true,"group":null,"validation":null,"validation_message":null}	{"collection":"directus_users","field":"slug","required":true}	\N	\N
481	650	directus_fields	75	{"id":75,"collection":"directus_users","field":"join_date","special":null,"interface":"datetime","options":{"format":"short"},"display":null,"display_options":null,"readonly":true,"hidden":false,"sort":4,"width":"full","translations":null,"note":null,"conditions":null,"required":true,"group":null,"validation":null,"validation_message":null}	{"collection":"directus_users","field":"join_date","required":true}	\N	\N
482	651	directus_fields	76	{"id":76,"collection":"directus_users","field":"featured","special":["cast-boolean"],"interface":"boolean","options":{"label":"Featured"},"display":null,"display_options":null,"readonly":false,"hidden":false,"sort":5,"width":"full","translations":null,"note":null,"conditions":null,"required":false,"group":null,"validation":null,"validation_message":null}	{"collection":"directus_users","field":"featured","readonly":false,"conditions":null}	\N	\N
483	652	directus_fields	75	{"id":75,"collection":"directus_users","field":"join_date","special":null,"interface":"datetime","options":{"format":"short"},"display":null,"display_options":null,"readonly":false,"hidden":false,"sort":4,"width":"full","translations":null,"note":null,"conditions":null,"required":true,"group":null,"validation":null,"validation_message":null}	{"collection":"directus_users","field":"join_date","readonly":false}	\N	\N
484	653	directus_fields	74	{"id":74,"collection":"directus_users","field":"slug","special":null,"interface":"input","options":null,"display":null,"display_options":null,"readonly":false,"hidden":false,"sort":3,"width":"full","translations":null,"note":null,"conditions":[{"name":"Enable for role \\"Administrator\\"","rule":{"_and":[{"role":{"_eq":"ea3a9127-2b65-462c-85a8-dbafe9b4fe24"}}]},"readonly":false}],"required":true,"group":null,"validation":null,"validation_message":null}	{"collection":"directus_users","field":"slug","readonly":false}	\N	\N
494	666	directus_users	4d310101-f7b1-47fe-982a-efe4abf25c55	{"id":"4d310101-f7b1-47fe-982a-efe4abf25c55","first_name":"Sebastian","last_name":"Krüger","email":"valknar@pivoine.art","password":"**********","location":null,"title":null,"description":"Visionary leader with 15+ years in digital media and content creation.","tags":["Love","Sex","Design","Art"],"avatar":"99c47c3d-4865-4361-a545-f38e54fccb0b","language":null,"tfa_secret":"**********","status":"active","role":"ea3a9127-2b65-462c-85a8-dbafe9b4fe24","token":null,"last_access":"2025-09-20T14:11:18.648Z","last_page":"/settings/data-model/directus_users","provider":"default","external_identifier":null,"auth_data":null,"email_notifications":true,"appearance":null,"theme_dark":null,"theme_light":null,"theme_light_overrides":null,"theme_dark_overrides":null,"text_direction":"auto","website":"pivoine.art","slug":"valknar","join_date":"2025-09-09T12:00:00","featured":true,"artist_name":"Valknar","policies":["b4f61dcc-b54e-4b3e-8a5e-bfbf029f6349","77084e57-682d-43e0-b570-acaf9fe94b1f","21e031ff-632d-46e5-97bb-959a5fef2538"]}	{"first_name":"Sebastian","last_name":"Krüger","slug":"valknar","artist_name":"Valknar"}	\N	\N
472	641	directus_fields	76	{"id":76,"collection":"directus_users","field":"featured","special":["cast-boolean"],"interface":"boolean","options":{"label":"Featured"},"display":null,"display_options":null,"readonly":true,"hidden":false,"sort":5,"width":"full","translations":null,"note":null,"conditions":[{"name":"Enable for role \\"Administrator\\"","rule":{"_and":[{"role":{"_eq":"ea3a9127-2b65-462c-85a8-dbafe9b4fe24"}}]},"readonly":true}],"required":false,"group":null,"validation":null,"validation_message":null}	{"collection":"directus_users","field":"featured","readonly":true,"conditions":[{"name":"Enable for role \\"Administrator\\"","rule":{"_and":[{"role":{"_eq":"ea3a9127-2b65-462c-85a8-dbafe9b4fe24"}}]},"readonly":true}]}	\N	\N
485	654	directus_permissions	100	{"policy":"338928fb-f8ee-4450-8b24-4854dd8bc7e0","permissions":{"_and":[{"id":{"_eq":"$CURRENT_USER"}}]},"validation":null,"fields":["first_name","username","last_name","website","password","avatar","tags","title","description","location"],"presets":null,"collection":"directus_users","action":"update"}	{"policy":"338928fb-f8ee-4450-8b24-4854dd8bc7e0","permissions":{"_and":[{"id":{"_eq":"$CURRENT_USER"}}]},"validation":null,"fields":["first_name","username","last_name","website","password","avatar","tags","title","description","location"],"presets":null,"collection":"directus_users","action":"update"}	\N	\N
495	667	directus_users	4d310101-f7b1-47fe-982a-efe4abf25c55	{"id":"4d310101-f7b1-47fe-982a-efe4abf25c55","first_name":"Sebastian","last_name":"Krüger","email":"valknar@pivoine.art","password":"**********","location":null,"title":null,"description":"Visionary leader with 15+ years in digital media and content creation.","tags":["Love","Sex","Design","Art"],"avatar":"99c47c3d-4865-4361-a545-f38e54fccb0b","language":null,"tfa_secret":"**********","status":"active","role":"ea3a9127-2b65-462c-85a8-dbafe9b4fe24","token":null,"last_access":"2025-09-20T14:11:18.648Z","last_page":"/settings/data-model/directus_users","provider":"default","external_identifier":null,"auth_data":null,"email_notifications":true,"appearance":null,"theme_dark":null,"theme_light":null,"theme_light_overrides":null,"theme_dark_overrides":null,"text_direction":"auto","website":"pivoine.art","slug":"valknars","join_date":"2025-09-09T12:00:00","featured":true,"artist_name":"Valknars","policies":["b4f61dcc-b54e-4b3e-8a5e-bfbf029f6349","77084e57-682d-43e0-b570-acaf9fe94b1f","21e031ff-632d-46e5-97bb-959a5fef2538"]}	{"first_name":"Sebastian","last_name":"Krüger","slug":"valknars","artist_name":"Valknars"}	\N	\N
496	668	directus_users	4d310101-f7b1-47fe-982a-efe4abf25c55	{"id":"4d310101-f7b1-47fe-982a-efe4abf25c55","first_name":"Sebastian","last_name":"Krüger","email":"valknar@pivoine.art","password":"**********","location":null,"title":null,"description":"Visionary leader with 15+ years in digital media and content creation.","tags":["Love","Sex","Design","Art"],"avatar":"99c47c3d-4865-4361-a545-f38e54fccb0b","language":null,"tfa_secret":"**********","status":"active","role":"ea3a9127-2b65-462c-85a8-dbafe9b4fe24","token":null,"last_access":"2025-09-20T14:11:18.648Z","last_page":"/settings/data-model/directus_users","provider":"default","external_identifier":null,"auth_data":null,"email_notifications":true,"appearance":null,"theme_dark":null,"theme_light":null,"theme_light_overrides":null,"theme_dark_overrides":null,"text_direction":"auto","website":"pivoine.art","slug":"valknar","join_date":"2025-09-09T12:00:00","featured":true,"artist_name":"Valknar","policies":["b4f61dcc-b54e-4b3e-8a5e-bfbf029f6349","77084e57-682d-43e0-b570-acaf9fe94b1f","21e031ff-632d-46e5-97bb-959a5fef2538"]}	{"first_name":"Sebastian","last_name":"Krüger","slug":"valknar","artist_name":"Valknar"}	\N	\N
510	690	directus_permissions	71	{"id":71,"collection":"directus_users","action":"read","permissions":{"_and":[{"_or":[{"role":{"name":{"_eq":"Model"}}},{"policies":{"policy":{"name":{"_eq":"Model"}}}}]}]},"validation":null,"presets":null,"fields":["username","website","slug","join_date","avatar","featured","location","title","description","tags","policies","role","id"],"policy":"f575bea7-7260-4d81-a931-81d762f2b47d"}	{"collection":"directus_users","action":"read","permissions":{"_and":[{"_or":[{"role":{"name":{"_eq":"Model"}}},{"policies":{"policy":{"name":{"_eq":"Model"}}}}]}]},"validation":null,"presets":null,"fields":["username","website","slug","join_date","avatar","featured","location","title","description","tags","policies","role","id"],"policy":"f575bea7-7260-4d81-a931-81d762f2b47d"}	\N	\N
498	673	directus_users	4d310101-f7b1-47fe-982a-efe4abf25c55	{"id":"4d310101-f7b1-47fe-982a-efe4abf25c55","first_name":"Sebastian","last_name":"Krüger","email":"valknar@pivoine.art","password":"**********","location":null,"title":null,"description":"Visionary leader with 15+ years in digital media and content creation.","tags":["Love","Sex","Design","Art"],"avatar":"99c47c3d-4865-4361-a545-f38e54fccb0b","language":null,"tfa_secret":null,"status":"active","role":"ea3a9127-2b65-462c-85a8-dbafe9b4fe24","token":null,"last_access":"2025-09-20T21:13:12.789Z","last_page":"/users/4d310101-f7b1-47fe-982a-efe4abf25c55","provider":"default","external_identifier":null,"auth_data":null,"email_notifications":true,"appearance":null,"theme_dark":null,"theme_light":null,"theme_light_overrides":null,"theme_dark_overrides":null,"text_direction":"auto","website":"pivoine.art","slug":"valknar","join_date":"2025-09-09T12:00:00","featured":true,"artist_name":"Valknar","policies":["b4f61dcc-b54e-4b3e-8a5e-bfbf029f6349","77084e57-682d-43e0-b570-acaf9fe94b1f","21e031ff-632d-46e5-97bb-959a5fef2538"]}	{"first_name":"Sebastian","last_name":"Krüger","slug":"valknar","artist_name":"Valknar"}	\N	\N
505	682	directus_users	4d310101-f7b1-47fe-982a-efe4abf25c55	{"id":"4d310101-f7b1-47fe-982a-efe4abf25c55","first_name":"Sebastian","last_name":"Krüger","email":"valknar@pivoine.art","password":"**********","location":null,"title":null,"description":"Visionary leader with 15+ years in digital media and content creation.","tags":["Love","Sex","Design","Art"],"avatar":"99c47c3d-4865-4361-a545-f38e54fccb0b","language":null,"tfa_secret":null,"status":"active","role":"ea3a9127-2b65-462c-85a8-dbafe9b4fe24","token":null,"last_access":"2025-09-21T01:13:00.378Z","last_page":"/users/4d310101-f7b1-47fe-982a-efe4abf25c55","provider":"default","external_identifier":null,"auth_data":null,"email_notifications":true,"appearance":null,"theme_dark":null,"theme_light":null,"theme_light_overrides":null,"theme_dark_overrides":null,"text_direction":"auto","website":"pivoine.art","slug":"valknar","join_date":"2025-09-09T12:00:00","featured":true,"artist_name":"Valknar","policies":["b4f61dcc-b54e-4b3e-8a5e-bfbf029f6349","77084e57-682d-43e0-b570-acaf9fe94b1f","21e031ff-632d-46e5-97bb-959a5fef2538"]}	{"first_name":"Sebastian","last_name":"Krüger","slug":"valknar","artist_name":"Valknar"}	\N	\N
506	684	directus_users	4d310101-f7b1-47fe-982a-efe4abf25c55	{"id":"4d310101-f7b1-47fe-982a-efe4abf25c55","first_name":"Sebastian","last_name":"Krüger","email":"valknar@pivoine.art","password":"**********","location":null,"title":null,"description":"Visionary leader with 15+ years in digital media and content creation.","tags":["Love","Sex","Design","Art"],"avatar":"99c47c3d-4865-4361-a545-f38e54fccb0b","language":null,"tfa_secret":null,"status":"active","role":"ea3a9127-2b65-462c-85a8-dbafe9b4fe24","token":null,"last_access":"2025-09-21T01:35:21.222Z","last_page":"/users/4d310101-f7b1-47fe-982a-efe4abf25c55","provider":"default","external_identifier":null,"auth_data":null,"email_notifications":true,"appearance":null,"theme_dark":null,"theme_light":null,"theme_light_overrides":null,"theme_dark_overrides":null,"text_direction":"auto","website":"pivoine.art","slug":"valknar","join_date":"2025-09-09T12:00:00","featured":true,"artist_name":"Valknar","policies":["b4f61dcc-b54e-4b3e-8a5e-bfbf029f6349","77084e57-682d-43e0-b570-acaf9fe94b1f","21e031ff-632d-46e5-97bb-959a5fef2538"]}	{"first_name":"Sebastian","last_name":"Krüger","slug":"valknar","artist_name":"Valknar"}	\N	\N
507	685	directus_users	4d310101-f7b1-47fe-982a-efe4abf25c55	{"id":"4d310101-f7b1-47fe-982a-efe4abf25c55","first_name":"Sebastian","last_name":"Krüger","email":"valknar@pivoine.art","password":"**********","location":null,"title":null,"description":"Visionary leader with 15+ years in digital media and content creation.","tags":["Love","Sex","Design","Art"],"avatar":"99c47c3d-4865-4361-a545-f38e54fccb0b","language":null,"tfa_secret":null,"status":"active","role":"ea3a9127-2b65-462c-85a8-dbafe9b4fe24","token":null,"last_access":"2025-09-21T01:35:21.222Z","last_page":"/users/4d310101-f7b1-47fe-982a-efe4abf25c55","provider":"default","external_identifier":null,"auth_data":null,"email_notifications":true,"appearance":null,"theme_dark":null,"theme_light":null,"theme_light_overrides":null,"theme_dark_overrides":null,"text_direction":"auto","website":"pivoine.art","slug":"valknar-the-gullu","join_date":"2025-09-09T12:00:00","featured":true,"artist_name":"Valknar the gullu","policies":["b4f61dcc-b54e-4b3e-8a5e-bfbf029f6349","77084e57-682d-43e0-b570-acaf9fe94b1f","21e031ff-632d-46e5-97bb-959a5fef2538"]}	{"first_name":"Sebastian","last_name":"Krüger","slug":"valknar-the-gullu","artist_name":"Valknar the gullu"}	\N	\N
508	686	directus_users	4d310101-f7b1-47fe-982a-efe4abf25c55	{"id":"4d310101-f7b1-47fe-982a-efe4abf25c55","first_name":"Sebastian","last_name":"Krüger","email":"valknar@pivoine.art","password":"**********","location":null,"title":null,"description":"Visionary leader with 15+ years in digital media and content creation.","tags":["Love","Sex","Design","Art"],"avatar":"99c47c3d-4865-4361-a545-f38e54fccb0b","language":null,"tfa_secret":null,"status":"active","role":"ea3a9127-2b65-462c-85a8-dbafe9b4fe24","token":null,"last_access":"2025-09-21T01:35:21.222Z","last_page":"/users/4d310101-f7b1-47fe-982a-efe4abf25c55","provider":"default","external_identifier":null,"auth_data":null,"email_notifications":true,"appearance":null,"theme_dark":null,"theme_light":null,"theme_light_overrides":null,"theme_dark_overrides":null,"text_direction":"auto","website":"pivoine.art","slug":"valknar","join_date":"2025-09-09T12:00:00","featured":true,"artist_name":"Valknar","policies":["b4f61dcc-b54e-4b3e-8a5e-bfbf029f6349","77084e57-682d-43e0-b570-acaf9fe94b1f","21e031ff-632d-46e5-97bb-959a5fef2538"]}	{"first_name":"Sebastian","last_name":"Krüger","slug":"valknar","artist_name":"Valknar"}	\N	\N
509	688	directus_users	4d310101-f7b1-47fe-982a-efe4abf25c55	{"id":"4d310101-f7b1-47fe-982a-efe4abf25c55","first_name":"Sebastian","last_name":"Krüger","email":"valknar@pivoine.art","password":"**********","location":null,"title":null,"description":"Visionary leader with 15+ years in digital media and content creation.","tags":["Love","Sex","Design","Art"],"avatar":"99c47c3d-4865-4361-a545-f38e54fccb0b","language":null,"tfa_secret":null,"status":"active","role":"ea3a9127-2b65-462c-85a8-dbafe9b4fe24","token":null,"last_access":"2025-09-21T09:30:48.685Z","last_page":"/users/4d310101-f7b1-47fe-982a-efe4abf25c55","provider":"default","external_identifier":null,"auth_data":null,"email_notifications":true,"appearance":null,"theme_dark":null,"theme_light":null,"theme_light_overrides":null,"theme_dark_overrides":null,"text_direction":"auto","website":"pivoine.art","slug":"valknar","join_date":"2025-09-09T12:00:00","featured":true,"artist_name":"Valknar","policies":["b4f61dcc-b54e-4b3e-8a5e-bfbf029f6349","77084e57-682d-43e0-b570-acaf9fe94b1f","21e031ff-632d-46e5-97bb-959a5fef2538"]}	{"first_name":"Sebastian","last_name":"Krüger","slug":"valknar","artist_name":"Valknar"}	\N	\N
516	700	directus_fields	40	{"id":40,"collection":"directus_users","field":"website","special":null,"interface":"input","options":null,"display":null,"display_options":null,"readonly":false,"hidden":false,"sort":2,"width":"full","translations":null,"note":null,"conditions":null,"required":false,"group":null,"validation":{"_and":[{"website":{"_regex":"/(http(s)?:\\\\/\\\\/.)?(www\\\\.)?[-a-zA-Z0-9@:%._\\\\+~#=]{2,256}\\\\.[a-z]{2,6}\\\\b([-a-zA-Z0-9@:%_\\\\+.~#?&//=]*)/"}}]},"validation_message":null}	{"collection":"directus_users","field":"website","validation":{"_and":[{"website":{"_regex":"/(http(s)?:\\\\/\\\\/.)?(www\\\\.)?[-a-zA-Z0-9@:%._\\\\+~#=]{2,256}\\\\.[a-z]{2,6}\\\\b([-a-zA-Z0-9@:%_\\\\+.~#?&//=]*)/"}}]}}	\N	\N
499	675	directus_users	4d310101-f7b1-47fe-982a-efe4abf25c55	{"id":"4d310101-f7b1-47fe-982a-efe4abf25c55","first_name":"Sebastian","last_name":"Krüger","email":"valknar@pivoine.art","password":"**********","location":null,"title":null,"description":"Visionary leader with 15+ years in digital media and content creation.","tags":["Love","Sex","Design","Art"],"avatar":"99c47c3d-4865-4361-a545-f38e54fccb0b","language":null,"tfa_secret":null,"status":"active","role":"ea3a9127-2b65-462c-85a8-dbafe9b4fe24","token":null,"last_access":"2025-09-21T01:10:25.694Z","last_page":"/users/4d310101-f7b1-47fe-982a-efe4abf25c55","provider":"default","external_identifier":null,"auth_data":null,"email_notifications":true,"appearance":null,"theme_dark":null,"theme_light":null,"theme_light_overrides":null,"theme_dark_overrides":null,"text_direction":"auto","website":"pivoine.art","slug":"valknar","join_date":"2025-09-09T12:00:00","featured":true,"artist_name":"Valknar","policies":["b4f61dcc-b54e-4b3e-8a5e-bfbf029f6349","77084e57-682d-43e0-b570-acaf9fe94b1f","21e031ff-632d-46e5-97bb-959a5fef2538"]}	{"first_name":"Sebastian","last_name":"Krüger","slug":"valknar","artist_name":"Valknar"}	\N	\N
500	676	directus_users	4d310101-f7b1-47fe-982a-efe4abf25c55	{"id":"4d310101-f7b1-47fe-982a-efe4abf25c55","first_name":"Sebastian","last_name":"Krüger","email":"valknar@pivoine.art","password":"**********","location":null,"title":null,"description":"Visionary leader with 15+ years in digital media and content creation.","tags":["Love","Sex","Design","Art"],"avatar":"99c47c3d-4865-4361-a545-f38e54fccb0b","language":null,"tfa_secret":null,"status":"active","role":"ea3a9127-2b65-462c-85a8-dbafe9b4fe24","token":null,"last_access":"2025-09-21T01:10:25.694Z","last_page":"/users/4d310101-f7b1-47fe-982a-efe4abf25c55","provider":"default","external_identifier":null,"auth_data":null,"email_notifications":true,"appearance":null,"theme_dark":null,"theme_light":null,"theme_light_overrides":null,"theme_dark_overrides":null,"text_direction":"auto","website":"pivoine.art","slug":"valknars","join_date":"2025-09-09T12:00:00","featured":true,"artist_name":"Valknars","policies":["b4f61dcc-b54e-4b3e-8a5e-bfbf029f6349","77084e57-682d-43e0-b570-acaf9fe94b1f","21e031ff-632d-46e5-97bb-959a5fef2538"]}	{"first_name":"Sebastian","last_name":"Krüger","slug":"valknars","artist_name":"Valknars"}	\N	\N
501	677	directus_users	4d310101-f7b1-47fe-982a-efe4abf25c55	{"id":"4d310101-f7b1-47fe-982a-efe4abf25c55","first_name":"Sebastian","last_name":"Krüger","email":"valknar@pivoine.art","password":"**********","location":null,"title":null,"description":"Visionary leader with 15+ years in digital media and content creation.","tags":["Love","Sex","Design","Art"],"avatar":"99c47c3d-4865-4361-a545-f38e54fccb0b","language":null,"tfa_secret":null,"status":"active","role":"ea3a9127-2b65-462c-85a8-dbafe9b4fe24","token":null,"last_access":"2025-09-21T01:10:25.694Z","last_page":"/users/4d310101-f7b1-47fe-982a-efe4abf25c55","provider":"default","external_identifier":null,"auth_data":null,"email_notifications":true,"appearance":null,"theme_dark":null,"theme_light":null,"theme_light_overrides":null,"theme_dark_overrides":null,"text_direction":"auto","website":"pivoine.art","slug":"valknar","join_date":"2025-09-09T12:00:00","featured":true,"artist_name":"Valknar","policies":["b4f61dcc-b54e-4b3e-8a5e-bfbf029f6349","77084e57-682d-43e0-b570-acaf9fe94b1f","21e031ff-632d-46e5-97bb-959a5fef2538"]}	{"first_name":"Sebastian","last_name":"Krüger","slug":"valknar","artist_name":"Valknar"}	\N	\N
502	678	directus_users	4d310101-f7b1-47fe-982a-efe4abf25c55	{"id":"4d310101-f7b1-47fe-982a-efe4abf25c55","first_name":"Sebastian","last_name":"Krüger","email":"valknar@pivoine.art","password":"**********","location":null,"title":null,"description":"Visionary leader with 15+ years in digital media and content creation.","tags":["Love","Sex","Design","Art"],"avatar":"99c47c3d-4865-4361-a545-f38e54fccb0b","language":null,"tfa_secret":null,"status":"active","role":"ea3a9127-2b65-462c-85a8-dbafe9b4fe24","token":null,"last_access":"2025-09-21T01:10:25.694Z","last_page":"/users/4d310101-f7b1-47fe-982a-efe4abf25c55","provider":"default","external_identifier":null,"auth_data":null,"email_notifications":true,"appearance":null,"theme_dark":null,"theme_light":null,"theme_light_overrides":null,"theme_dark_overrides":null,"text_direction":"auto","website":"pivoine.art","slug":"valknar","join_date":"2025-09-09T12:00:00","featured":true,"artist_name":"Valknar","policies":["b4f61dcc-b54e-4b3e-8a5e-bfbf029f6349","77084e57-682d-43e0-b570-acaf9fe94b1f","21e031ff-632d-46e5-97bb-959a5fef2538"]}	{"first_name":"Sebastian","last_name":"Krüger","slug":"valknar","artist_name":"Valknar"}	\N	\N
503	679	directus_users	4d310101-f7b1-47fe-982a-efe4abf25c55	{"id":"4d310101-f7b1-47fe-982a-efe4abf25c55","first_name":"Sebastian","last_name":"Krüger","email":"valknar@pivoine.art","password":"**********","location":null,"title":null,"description":"Visionary leader with 15+ years in digital media and content creation.","tags":["Love","Sex","Design","Art"],"avatar":"99c47c3d-4865-4361-a545-f38e54fccb0b","language":null,"tfa_secret":null,"status":"active","role":"ea3a9127-2b65-462c-85a8-dbafe9b4fe24","token":null,"last_access":"2025-09-21T01:10:25.694Z","last_page":"/users/4d310101-f7b1-47fe-982a-efe4abf25c55","provider":"default","external_identifier":null,"auth_data":null,"email_notifications":true,"appearance":null,"theme_dark":null,"theme_light":null,"theme_light_overrides":null,"theme_dark_overrides":null,"text_direction":"auto","website":"pivoine.art","slug":"valknar","join_date":"2025-09-09T12:00:00","featured":true,"artist_name":"Valknar","policies":["b4f61dcc-b54e-4b3e-8a5e-bfbf029f6349","77084e57-682d-43e0-b570-acaf9fe94b1f","21e031ff-632d-46e5-97bb-959a5fef2538"]}	{"first_name":"Sebastian","last_name":"Krüger","slug":"valknar","artist_name":"Valknar"}	\N	\N
504	681	directus_users	4d310101-f7b1-47fe-982a-efe4abf25c55	{"id":"4d310101-f7b1-47fe-982a-efe4abf25c55","first_name":"Sebastian","last_name":"Krüger","email":"valknar@pivoine.art","password":"**********","location":null,"title":null,"description":"Visionary leader with 15+ years in digital media and content creation.","tags":["Love","Sex","Design","Art"],"avatar":"99c47c3d-4865-4361-a545-f38e54fccb0b","language":null,"tfa_secret":null,"status":"active","role":"ea3a9127-2b65-462c-85a8-dbafe9b4fe24","token":null,"last_access":"2025-09-21T01:13:00.378Z","last_page":"/users/4d310101-f7b1-47fe-982a-efe4abf25c55","provider":"default","external_identifier":null,"auth_data":null,"email_notifications":true,"appearance":null,"theme_dark":null,"theme_light":null,"theme_light_overrides":null,"theme_dark_overrides":null,"text_direction":"auto","website":"pivoine.art","slug":"valknarjjjjjkkkkkk","join_date":"2025-09-09T12:00:00","featured":true,"artist_name":"Valknarjjjjjkkkkkk","policies":["b4f61dcc-b54e-4b3e-8a5e-bfbf029f6349","77084e57-682d-43e0-b570-acaf9fe94b1f","21e031ff-632d-46e5-97bb-959a5fef2538"]}	{"first_name":"Sebastian","last_name":"Krüger","slug":"valknarjjjjjkkkkkk","artist_name":"Valknarjjjjjkkkkkk"}	\N	\N
518	702	directus_fields	40	{"id":40,"collection":"directus_users","field":"website","special":null,"interface":"input","options":null,"display":null,"display_options":null,"readonly":false,"hidden":false,"sort":2,"width":"full","translations":null,"note":null,"conditions":null,"required":false,"group":null,"validation":{"_and":[{"website":{"_regex":"/^(http(s)?:\\\\/\\\\/.)?(www\\\\.)?[-a-zA-Z0-9@:%._\\\\+~#=]{2,256}\\\\.[a-z]{2,6}\\\\b([-a-zA-Z0-9@:%_\\\\+.~#?&//=]*)$/"}}]},"validation_message":null}	{"collection":"directus_users","field":"website","validation":{"_and":[{"website":{"_regex":"/^(http(s)?:\\\\/\\\\/.)?(www\\\\.)?[-a-zA-Z0-9@:%._\\\\+~#=]{2,256}\\\\.[a-z]{2,6}\\\\b([-a-zA-Z0-9@:%_\\\\+.~#?&//=]*)$/"}}]}}	\N	\N
511	692	directus_permissions	71	{"id":71,"collection":"directus_users","action":"read","permissions":{"_and":[{"_or":[{"role":{"name":{"_eq":"Model"}}},{"policies":{"policy":{"name":{"_eq":"Model"}}}}]}]},"validation":null,"presets":null,"fields":["username","website","slug","join_date","avatar","featured","location","title","description","tags","policies","role","id","artist_name","last_name","first_name"],"policy":"f575bea7-7260-4d81-a931-81d762f2b47d"}	{"collection":"directus_users","action":"read","permissions":{"_and":[{"_or":[{"role":{"name":{"_eq":"Model"}}},{"policies":{"policy":{"name":{"_eq":"Model"}}}}]}]},"validation":null,"presets":null,"fields":["username","website","slug","join_date","avatar","featured","location","title","description","tags","policies","role","id","artist_name","last_name","first_name"],"policy":"f575bea7-7260-4d81-a931-81d762f2b47d"}	\N	\N
512	695	directus_users	4d310101-f7b1-47fe-982a-efe4abf25c55	{"id":"4d310101-f7b1-47fe-982a-efe4abf25c55","first_name":"Sebastian","last_name":"Krüger","email":"valknar@pivoine.art","password":"**********","location":null,"title":null,"description":"Visionary leader with 15+ years in digital media and content creation.","tags":["Love","Sex","Design","Art","Diesel"],"avatar":"99c47c3d-4865-4361-a545-f38e54fccb0b","language":null,"tfa_secret":null,"status":"active","role":"ea3a9127-2b65-462c-85a8-dbafe9b4fe24","token":null,"last_access":"2025-09-22T00:45:38.398Z","last_page":"/settings/policies","provider":"default","external_identifier":null,"auth_data":null,"email_notifications":true,"appearance":null,"theme_dark":null,"theme_light":null,"theme_light_overrides":null,"theme_dark_overrides":null,"text_direction":"auto","website":"pivoine.art","slug":"valknar","join_date":"2025-09-09T12:00:00","featured":true,"artist_name":"Valknar","policies":["b4f61dcc-b54e-4b3e-8a5e-bfbf029f6349","77084e57-682d-43e0-b570-acaf9fe94b1f","21e031ff-632d-46e5-97bb-959a5fef2538"]}	{"first_name":"Sebastian","last_name":"Krüger","description":"Visionary leader with 15+ years in digital media and content creation.","tags":["Love","Sex","Design","Art","Diesel"],"slug":"valknar","artist_name":"Valknar"}	\N	\N
513	696	directus_users	4d310101-f7b1-47fe-982a-efe4abf25c55	{"id":"4d310101-f7b1-47fe-982a-efe4abf25c55","first_name":"Sebastian","last_name":"Krüger","email":"valknar@pivoine.art","password":"**********","location":null,"title":null,"description":"Visionary leader with 15+ years in digital media and content creation.","tags":["Love","Sex","Design","Art"],"avatar":"99c47c3d-4865-4361-a545-f38e54fccb0b","language":null,"tfa_secret":null,"status":"active","role":"ea3a9127-2b65-462c-85a8-dbafe9b4fe24","token":null,"last_access":"2025-09-22T00:45:38.398Z","last_page":"/settings/policies","provider":"default","external_identifier":null,"auth_data":null,"email_notifications":true,"appearance":null,"theme_dark":null,"theme_light":null,"theme_light_overrides":null,"theme_dark_overrides":null,"text_direction":"auto","website":"pivoine.art","slug":"valknar","join_date":"2025-09-09T12:00:00","featured":true,"artist_name":"Valknar","policies":["b4f61dcc-b54e-4b3e-8a5e-bfbf029f6349","77084e57-682d-43e0-b570-acaf9fe94b1f","21e031ff-632d-46e5-97bb-959a5fef2538"]}	{"first_name":"Sebastian","last_name":"Krüger","description":"Visionary leader with 15+ years in digital media and content creation.","tags":["Love","Sex","Design","Art"],"slug":"valknar","artist_name":"Valknar"}	\N	\N
514	697	directus_users	4d310101-f7b1-47fe-982a-efe4abf25c55	{"id":"4d310101-f7b1-47fe-982a-efe4abf25c55","first_name":"Sebastian","last_name":"Krüger","email":"valknar@pivoine.art","password":"**********","location":null,"title":null,"description":"Visionary leader with 15+ years in digital media and content creation.","tags":["Love","Sex","Design","Art"],"avatar":"99c47c3d-4865-4361-a545-f38e54fccb0b","language":null,"tfa_secret":null,"status":"active","role":"ea3a9127-2b65-462c-85a8-dbafe9b4fe24","token":null,"last_access":"2025-09-22T00:45:38.398Z","last_page":"/settings/policies","provider":"default","external_identifier":null,"auth_data":null,"email_notifications":true,"appearance":null,"theme_dark":null,"theme_light":null,"theme_light_overrides":null,"theme_dark_overrides":null,"text_direction":"auto","website":"pivoine.art","slug":"valknar","join_date":"2025-09-09T12:00:00","featured":true,"artist_name":"Valknar","policies":["b4f61dcc-b54e-4b3e-8a5e-bfbf029f6349","77084e57-682d-43e0-b570-acaf9fe94b1f","21e031ff-632d-46e5-97bb-959a5fef2538"]}	{"email":"valknar@pivoine.art","password":"**********"}	\N	\N
515	698	directus_users	4d310101-f7b1-47fe-982a-efe4abf25c55	{"id":"4d310101-f7b1-47fe-982a-efe4abf25c55","first_name":"Sebastian","last_name":"Krüger","email":"valknar@pivoine.art","password":"**********","location":null,"title":null,"description":"Visionary leader with 15+ years in digital media and content creation.","tags":["Love","Sex","Design","Art"],"avatar":"99c47c3d-4865-4361-a545-f38e54fccb0b","language":null,"tfa_secret":null,"status":"active","role":"ea3a9127-2b65-462c-85a8-dbafe9b4fe24","token":null,"last_access":"2025-09-22T00:45:38.398Z","last_page":"/settings/policies","provider":"default","external_identifier":null,"auth_data":null,"email_notifications":true,"appearance":null,"theme_dark":null,"theme_light":null,"theme_light_overrides":null,"theme_dark_overrides":null,"text_direction":"auto","website":"pivoine.art","slug":"valknar","join_date":"2025-09-09T12:00:00","featured":true,"artist_name":"Valknar","policies":["b4f61dcc-b54e-4b3e-8a5e-bfbf029f6349","77084e57-682d-43e0-b570-acaf9fe94b1f","21e031ff-632d-46e5-97bb-959a5fef2538"]}	{"email":"valknar@pivoine.art","password":"**********"}	\N	\N
517	701	directus_users	4d310101-f7b1-47fe-982a-efe4abf25c55	{"id":"4d310101-f7b1-47fe-982a-efe4abf25c55","first_name":"Sebastian","last_name":"Krüger","email":"valknar@pivoine.art","password":"**********","location":null,"title":null,"description":"Visionary leader with 15+ years in digital media and content creation.","tags":["Love","Sex","Design","Art"],"avatar":"99c47c3d-4865-4361-a545-f38e54fccb0b","language":null,"tfa_secret":null,"status":"active","role":"ea3a9127-2b65-462c-85a8-dbafe9b4fe24","token":null,"last_access":"2025-09-22T11:51:15.325Z","last_page":"/users/4d310101-f7b1-47fe-982a-efe4abf25c55","provider":"default","external_identifier":null,"auth_data":null,"email_notifications":true,"appearance":null,"theme_dark":null,"theme_light":null,"theme_light_overrides":null,"theme_dark_overrides":null,"text_direction":"auto","website":"http:/pivoine.art","slug":"valknar","join_date":"2025-09-09T12:00:00","featured":true,"artist_name":"Valknar","policies":["b4f61dcc-b54e-4b3e-8a5e-bfbf029f6349","77084e57-682d-43e0-b570-acaf9fe94b1f","21e031ff-632d-46e5-97bb-959a5fef2538"]}	{"website":"http:/pivoine.art"}	\N	\N
524	711	directus_folders	5f184291-9a58-4914-9756-ad910378bd90	{"name":"avatars","parent":"c214c905-885b-4d66-a6a1-6527b0606200"}	{"name":"avatars","parent":"c214c905-885b-4d66-a6a1-6527b0606200"}	\N	\N
525	712	directus_files	00b43d74-632e-4170-b385-26782ac3f442	{"folder":"5f184291-9a58-4914-9756-ad910378bd90","title":"Sebastian","filename_download":"sebastian.jpg","type":"image/jpeg","storage":"local"}	{"folder":"5f184291-9a58-4914-9756-ad910378bd90","title":"Sebastian","filename_download":"sebastian.jpg","type":"image/jpeg","storage":"local"}	\N	\N
527	715	directus_files	b09b0973-ba94-4d25-be82-e332fdd53940	{"folder":"5f184291-9a58-4914-9756-ad910378bd90","title":"Sebastian","filename_download":"sebastian.jpg","type":"image/jpeg","storage":"local"}	{"folder":"5f184291-9a58-4914-9756-ad910378bd90","title":"Sebastian","filename_download":"sebastian.jpg","type":"image/jpeg","storage":"local"}	\N	\N
519	703	directus_users	4d310101-f7b1-47fe-982a-efe4abf25c55	{"id":"4d310101-f7b1-47fe-982a-efe4abf25c55","first_name":"Sebastian","last_name":"Krüger","email":"valknar@pivoine.art","password":"**********","location":null,"title":null,"description":"Visionary leader with 15+ years in digital media and content creation.","tags":["Love","Sex","Design","Art"],"avatar":"99c47c3d-4865-4361-a545-f38e54fccb0b","language":null,"tfa_secret":null,"status":"active","role":"ea3a9127-2b65-462c-85a8-dbafe9b4fe24","token":null,"last_access":"2025-09-22T12:04:20.547Z","last_page":"/users/4d310101-f7b1-47fe-982a-efe4abf25c55","provider":"default","external_identifier":null,"auth_data":null,"email_notifications":true,"appearance":null,"theme_dark":null,"theme_light":null,"theme_light_overrides":null,"theme_dark_overrides":null,"text_direction":"auto","website":"http:pivoine.art","slug":"valknar","join_date":"2025-09-09T12:00:00","featured":true,"artist_name":"Valknar","policies":["b4f61dcc-b54e-4b3e-8a5e-bfbf029f6349","77084e57-682d-43e0-b570-acaf9fe94b1f","21e031ff-632d-46e5-97bb-959a5fef2538"]}	{"website":"http:pivoine.art"}	\N	\N
520	704	directus_users	4d310101-f7b1-47fe-982a-efe4abf25c55	{"id":"4d310101-f7b1-47fe-982a-efe4abf25c55","first_name":"Sebastian","last_name":"Krüger","email":"valknar@pivoine.art","password":"**********","location":null,"title":null,"description":"Visionary leader with 15+ years in digital media and content creation.","tags":["Love","Sex","Design","Art"],"avatar":"99c47c3d-4865-4361-a545-f38e54fccb0b","language":null,"tfa_secret":null,"status":"active","role":"ea3a9127-2b65-462c-85a8-dbafe9b4fe24","token":null,"last_access":"2025-09-22T12:04:20.547Z","last_page":"/users/4d310101-f7b1-47fe-982a-efe4abf25c55","provider":"default","external_identifier":null,"auth_data":null,"email_notifications":true,"appearance":null,"theme_dark":null,"theme_light":null,"theme_light_overrides":null,"theme_dark_overrides":null,"text_direction":"auto","website":"pivoine.art","slug":"valknar","join_date":"2025-09-09T12:00:00","featured":true,"artist_name":"Valknar","policies":["b4f61dcc-b54e-4b3e-8a5e-bfbf029f6349","77084e57-682d-43e0-b570-acaf9fe94b1f","21e031ff-632d-46e5-97bb-959a5fef2538"]}	{"website":"pivoine.art"}	\N	\N
521	705	directus_fields	40	{"id":40,"collection":"directus_users","field":"website","special":null,"interface":"input","options":null,"display":null,"display_options":null,"readonly":false,"hidden":false,"sort":2,"width":"full","translations":null,"note":null,"conditions":null,"required":false,"group":null,"validation":null,"validation_message":null}	{"collection":"directus_users","field":"website","validation":null}	\N	\N
522	706	directus_users	4d310101-f7b1-47fe-982a-efe4abf25c55	{"id":"4d310101-f7b1-47fe-982a-efe4abf25c55","first_name":"Sebastian","last_name":"Krüger","email":"valknar@pivoine.art","password":"**********","location":null,"title":null,"description":"Visionary leader with 15+ years in digital media and content creation.","tags":["Love","Sex","Design","Art"],"avatar":null,"language":null,"tfa_secret":null,"status":"active","role":"ea3a9127-2b65-462c-85a8-dbafe9b4fe24","token":null,"last_access":"2025-09-22T12:04:20.547Z","last_page":"/users/4d310101-f7b1-47fe-982a-efe4abf25c55","provider":"default","external_identifier":null,"auth_data":null,"email_notifications":true,"appearance":null,"theme_dark":null,"theme_light":null,"theme_light_overrides":null,"theme_dark_overrides":null,"text_direction":"auto","website":"pivoine.art","slug":"valknar","join_date":"2025-09-09T12:00:00","featured":true,"artist_name":"Valknar","policies":["b4f61dcc-b54e-4b3e-8a5e-bfbf029f6349","77084e57-682d-43e0-b570-acaf9fe94b1f","21e031ff-632d-46e5-97bb-959a5fef2538"]}	{"avatar":null}	\N	\N
523	707	directus_users	543f4d0b-e346-4e5e-8aca-4a9b35d5fab6	{"id":"543f4d0b-e346-4e5e-8aca-4a9b35d5fab6","first_name":"Palina","last_name":"Rojinski","email":"palina@pivoine.art","password":"**********","location":null,"title":null,"description":"Award-winning model, dancer and actress with 15+ years of experience.","tags":["Love","Sex","Design","Art"],"avatar":null,"language":null,"tfa_secret":null,"status":"active","role":"55da25e6-9a87-4264-92e8-9066fdcf9c07","token":null,"last_access":null,"last_page":null,"provider":"default","external_identifier":null,"auth_data":null,"email_notifications":true,"appearance":null,"theme_dark":null,"theme_light":null,"theme_light_overrides":null,"theme_dark_overrides":null,"text_direction":"auto","website":"pivoine.art","slug":"luna-belle","join_date":"2025-09-09T12:00:00","featured":true,"artist_name":"Luna Belle","policies":[]}	{"avatar":null}	\N	\N
526	713	directus_users	4d310101-f7b1-47fe-982a-efe4abf25c55	{"id":"4d310101-f7b1-47fe-982a-efe4abf25c55","first_name":"Sebastian","last_name":"Krüger","email":"valknar@pivoine.art","password":"**********","location":null,"title":null,"description":"Visionary leader with 15+ years in digital media and content creation.","tags":["Love","Sex","Design","Art"],"avatar":"00b43d74-632e-4170-b385-26782ac3f442","language":null,"tfa_secret":null,"status":"active","role":"ea3a9127-2b65-462c-85a8-dbafe9b4fe24","token":null,"last_access":"2025-09-22T12:04:20.547Z","last_page":"/users/4d310101-f7b1-47fe-982a-efe4abf25c55","provider":"default","external_identifier":null,"auth_data":null,"email_notifications":true,"appearance":null,"theme_dark":null,"theme_light":null,"theme_light_overrides":null,"theme_dark_overrides":null,"text_direction":"auto","website":"pivoine.art","slug":"valknar","join_date":"2025-09-09T12:00:00","featured":true,"artist_name":"Valknar","policies":["b4f61dcc-b54e-4b3e-8a5e-bfbf029f6349","77084e57-682d-43e0-b570-acaf9fe94b1f","21e031ff-632d-46e5-97bb-959a5fef2538"]}	{"avatar":"00b43d74-632e-4170-b385-26782ac3f442"}	\N	\N
528	716	directus_users	4d310101-f7b1-47fe-982a-efe4abf25c55	{"id":"4d310101-f7b1-47fe-982a-efe4abf25c55","first_name":"Sebastian","last_name":"Krüger","email":"valknar@pivoine.art","password":"**********","location":null,"title":null,"description":"Visionary leader with 15+ years in digital media and content creation.","tags":["Love","Sex","Design","Art"],"avatar":"b09b0973-ba94-4d25-be82-e332fdd53940","language":null,"tfa_secret":null,"status":"active","role":"ea3a9127-2b65-462c-85a8-dbafe9b4fe24","token":null,"last_access":"2025-09-22T12:04:20.547Z","last_page":"/users","provider":"default","external_identifier":null,"auth_data":null,"email_notifications":true,"appearance":null,"theme_dark":null,"theme_light":null,"theme_light_overrides":null,"theme_dark_overrides":null,"text_direction":"auto","website":"pivoine.art","slug":"valknar","join_date":"2025-09-09T12:00:00","featured":true,"artist_name":"Valknar","policies":["b4f61dcc-b54e-4b3e-8a5e-bfbf029f6349","77084e57-682d-43e0-b570-acaf9fe94b1f","21e031ff-632d-46e5-97bb-959a5fef2538"]}	{"first_name":"Sebastian","last_name":"Krüger","description":"Visionary leader with 15+ years in digital media and content creation.","tags":["Love","Sex","Design","Art"],"avatar":"b09b0973-ba94-4d25-be82-e332fdd53940","slug":"valknar","artist_name":"Valknar"}	\N	\N
529	718	directus_files	aaee7bff-e6ce-426c-9abd-8cc11e91de8e	{"folder":"5f184291-9a58-4914-9756-ad910378bd90","title":"Sebastian","filename_download":"sebastian.jpg","type":"image/jpeg","storage":"local"}	{"folder":"5f184291-9a58-4914-9756-ad910378bd90","title":"Sebastian","filename_download":"sebastian.jpg","type":"image/jpeg","storage":"local"}	\N	\N
742	1006	directus_files	7de97669-fcfb-414c-b64f-3ea1dbf0ce17	{"folder":"26657630-d9cd-47a3-9e45-9831f3674f97","title":"Videoframe 0","filename_download":"videoframe_0.png","type":"image/png","storage":"local"}	{"folder":"26657630-d9cd-47a3-9e45-9831f3674f97","title":"Videoframe 0","filename_download":"videoframe_0.png","type":"image/png","storage":"local"}	\N	\N
530	719	directus_users	4d310101-f7b1-47fe-982a-efe4abf25c55	{"id":"4d310101-f7b1-47fe-982a-efe4abf25c55","first_name":"Sebastian","last_name":"Krüger","email":"valknar@pivoine.art","password":"**********","location":null,"title":null,"description":"Visionary leader with 15+ years in digital media and content creation.","tags":["Love","Sex","Design","Art"],"avatar":"aaee7bff-e6ce-426c-9abd-8cc11e91de8e","language":null,"tfa_secret":null,"status":"active","role":"ea3a9127-2b65-462c-85a8-dbafe9b4fe24","token":null,"last_access":"2025-09-22T12:04:20.547Z","last_page":"/users","provider":"default","external_identifier":null,"auth_data":null,"email_notifications":true,"appearance":null,"theme_dark":null,"theme_light":null,"theme_light_overrides":null,"theme_dark_overrides":null,"text_direction":"auto","website":"pivoine.art","slug":"valknar","join_date":"2025-09-09T12:00:00","featured":true,"artist_name":"Valknar","policies":["b4f61dcc-b54e-4b3e-8a5e-bfbf029f6349","77084e57-682d-43e0-b570-acaf9fe94b1f","21e031ff-632d-46e5-97bb-959a5fef2538"]}	{"first_name":"Sebastian","last_name":"Krüger","description":"Visionary leader with 15+ years in digital media and content creation.","tags":["Love","Sex","Design","Art"],"avatar":"aaee7bff-e6ce-426c-9abd-8cc11e91de8e","slug":"valknar","artist_name":"Valknar"}	\N	\N
531	720	directus_files	98ffb887-23d2-4e02-9635-3c7da1170121	{"folder":"5f184291-9a58-4914-9756-ad910378bd90","title":"Luna Belle","filename_download":"luna-belle.jpg","type":"image/jpeg","storage":"local"}	{"folder":"5f184291-9a58-4914-9756-ad910378bd90","title":"Luna Belle","filename_download":"luna-belle.jpg","type":"image/jpeg","storage":"local"}	\N	\N
532	721	directus_users	543f4d0b-e346-4e5e-8aca-4a9b35d5fab6	{"id":"543f4d0b-e346-4e5e-8aca-4a9b35d5fab6","first_name":"Palina","last_name":"Rojinski","email":"palina@pivoine.art","password":"**********","location":null,"title":null,"description":"Award-winning model, dancer and actress with 15+ years of experience.","tags":["Love","Sex","Design","Art"],"avatar":"98ffb887-23d2-4e02-9635-3c7da1170121","language":null,"tfa_secret":null,"status":"active","role":"55da25e6-9a87-4264-92e8-9066fdcf9c07","token":null,"last_access":null,"last_page":null,"provider":"default","external_identifier":null,"auth_data":null,"email_notifications":true,"appearance":null,"theme_dark":null,"theme_light":null,"theme_light_overrides":null,"theme_dark_overrides":null,"text_direction":"auto","website":"pivoine.art","slug":"luna-belle","join_date":"2025-09-09T12:00:00","featured":true,"artist_name":"Luna Belle","policies":[]}	{"avatar":"98ffb887-23d2-4e02-9635-3c7da1170121"}	\N	\N
533	722	directus_files	98e7a436-12c0-4c5b-8738-cf93a86b2a4d	{"folder":"5f184291-9a58-4914-9756-ad910378bd90","title":"Palina","filename_download":"palina.jpg","type":"image/jpeg","storage":"local"}	{"folder":"5f184291-9a58-4914-9756-ad910378bd90","title":"Palina","filename_download":"palina.jpg","type":"image/jpeg","storage":"local"}	\N	\N
534	723	directus_users	4d310101-f7b1-47fe-982a-efe4abf25c55	{"id":"4d310101-f7b1-47fe-982a-efe4abf25c55","first_name":"Sebastian","last_name":"Krüger","email":"valknar@pivoine.art","password":"**********","location":null,"title":null,"description":"Visionary leader with 15+ years in digital media and content creation.","tags":["Love","Sex","Design","Art"],"avatar":"98e7a436-12c0-4c5b-8738-cf93a86b2a4d","language":null,"tfa_secret":null,"status":"active","role":"ea3a9127-2b65-462c-85a8-dbafe9b4fe24","token":null,"last_access":"2025-09-22T18:11:03.551Z","last_page":"/users","provider":"default","external_identifier":null,"auth_data":null,"email_notifications":true,"appearance":null,"theme_dark":null,"theme_light":null,"theme_light_overrides":null,"theme_dark_overrides":null,"text_direction":"auto","website":"pivoine.art","slug":"valknar","join_date":"2025-09-09T12:00:00","featured":true,"artist_name":"Valknar","policies":["b4f61dcc-b54e-4b3e-8a5e-bfbf029f6349","77084e57-682d-43e0-b570-acaf9fe94b1f","21e031ff-632d-46e5-97bb-959a5fef2538"]}	{"first_name":"Sebastian","last_name":"Krüger","description":"Visionary leader with 15+ years in digital media and content creation.","tags":["Love","Sex","Design","Art"],"avatar":"98e7a436-12c0-4c5b-8738-cf93a86b2a4d","slug":"valknar","artist_name":"Valknar"}	\N	\N
535	724	directus_files	fee51247-fdad-4a6b-96a5-ce0e263daa2d	{"folder":"5f184291-9a58-4914-9756-ad910378bd90","title":"Sebastian","filename_download":"sebastian.jpg","type":"image/jpeg","storage":"local"}	{"folder":"5f184291-9a58-4914-9756-ad910378bd90","title":"Sebastian","filename_download":"sebastian.jpg","type":"image/jpeg","storage":"local"}	\N	\N
536	725	directus_users	4d310101-f7b1-47fe-982a-efe4abf25c55	{"id":"4d310101-f7b1-47fe-982a-efe4abf25c55","first_name":"Sebastian","last_name":"Krüger","email":"valknar@pivoine.art","password":"**********","location":null,"title":null,"description":"Visionary leader with 15+ years in digital media and content creation.","tags":["Love","Sex","Design","Art"],"avatar":"fee51247-fdad-4a6b-96a5-ce0e263daa2d","language":null,"tfa_secret":null,"status":"active","role":"ea3a9127-2b65-462c-85a8-dbafe9b4fe24","token":null,"last_access":"2025-09-22T18:11:03.551Z","last_page":"/users","provider":"default","external_identifier":null,"auth_data":null,"email_notifications":true,"appearance":null,"theme_dark":null,"theme_light":null,"theme_light_overrides":null,"theme_dark_overrides":null,"text_direction":"auto","website":"pivoine.art","slug":"valknar","join_date":"2025-09-09T12:00:00","featured":true,"artist_name":"Valknar","policies":["b4f61dcc-b54e-4b3e-8a5e-bfbf029f6349","77084e57-682d-43e0-b570-acaf9fe94b1f","21e031ff-632d-46e5-97bb-959a5fef2538"]}	{"first_name":"Sebastian","last_name":"Krüger","description":"Visionary leader with 15+ years in digital media and content creation.","tags":["Love","Sex","Design","Art"],"avatar":"fee51247-fdad-4a6b-96a5-ce0e263daa2d","slug":"valknar","artist_name":"Valknar"}	\N	\N
537	727	directus_users	4d310101-f7b1-47fe-982a-efe4abf25c55	{"id":"4d310101-f7b1-47fe-982a-efe4abf25c55","first_name":"Sebastian","last_name":"Krüger","email":"valknar@pivoine.art","password":"**********","location":null,"title":null,"description":"Visionary leader with 15+ years in digital media and content creation.","tags":["Love","Sex","Design","Art"],"avatar":"fee51247-fdad-4a6b-96a5-ce0e263daa2d","language":null,"tfa_secret":null,"status":"active","role":"ea3a9127-2b65-462c-85a8-dbafe9b4fe24","token":null,"last_access":"2025-09-22T18:11:03.551Z","last_page":"/users","provider":"default","external_identifier":null,"auth_data":null,"email_notifications":true,"appearance":null,"theme_dark":null,"theme_light":null,"theme_light_overrides":null,"theme_dark_overrides":null,"text_direction":"auto","website":"pivoine.art","slug":"valknar","join_date":"2025-09-09T12:00:00","featured":true,"artist_name":"Valknar","policies":["b4f61dcc-b54e-4b3e-8a5e-bfbf029f6349","77084e57-682d-43e0-b570-acaf9fe94b1f","21e031ff-632d-46e5-97bb-959a5fef2538"]}	{"first_name":"Sebastian","last_name":"Krüger","description":"Visionary leader with 15+ years in digital media and content creation.","tags":["Love","Sex","Design","Art"],"slug":"valknar","artist_name":"Valknar"}	\N	\N
538	728	directus_files	81ae7ebe-2ece-457e-817b-e5dab626c6f7	{"folder":"5f184291-9a58-4914-9756-ad910378bd90","title":"Sebastian","filename_download":"sebastian.jpg","type":"image/jpeg","storage":"local"}	{"folder":"5f184291-9a58-4914-9756-ad910378bd90","title":"Sebastian","filename_download":"sebastian.jpg","type":"image/jpeg","storage":"local"}	\N	\N
539	729	directus_users	4d310101-f7b1-47fe-982a-efe4abf25c55	{"id":"4d310101-f7b1-47fe-982a-efe4abf25c55","first_name":"Sebastian","last_name":"Krüger","email":"valknar@pivoine.art","password":"**********","location":null,"title":null,"description":"Visionary leader with 15+ years in digital media and content creation.","tags":["Love","Sex","Design","Art"],"avatar":"81ae7ebe-2ece-457e-817b-e5dab626c6f7","language":null,"tfa_secret":null,"status":"active","role":"ea3a9127-2b65-462c-85a8-dbafe9b4fe24","token":null,"last_access":"2025-09-22T18:11:03.551Z","last_page":"/users","provider":"default","external_identifier":null,"auth_data":null,"email_notifications":true,"appearance":null,"theme_dark":null,"theme_light":null,"theme_light_overrides":null,"theme_dark_overrides":null,"text_direction":"auto","website":"pivoine.art","slug":"valknar","join_date":"2025-09-09T12:00:00","featured":true,"artist_name":"Valknar","policies":["b4f61dcc-b54e-4b3e-8a5e-bfbf029f6349","77084e57-682d-43e0-b570-acaf9fe94b1f","21e031ff-632d-46e5-97bb-959a5fef2538"]}	{"first_name":"Sebastian","last_name":"Krüger","description":"Visionary leader with 15+ years in digital media and content creation.","tags":["Love","Sex","Design","Art"],"avatar":"81ae7ebe-2ece-457e-817b-e5dab626c6f7","slug":"valknar","artist_name":"Valknar"}	\N	\N
540	731	directus_files	b605cbfd-d9c6-47de-97e5-a4c2b4100c28	{"folder":"5f184291-9a58-4914-9756-ad910378bd90","title":"Palina","filename_download":"palina.jpg","type":"image/jpeg","storage":"local"}	{"folder":"5f184291-9a58-4914-9756-ad910378bd90","title":"Palina","filename_download":"palina.jpg","type":"image/jpeg","storage":"local"}	\N	\N
541	732	directus_users	4d310101-f7b1-47fe-982a-efe4abf25c55	{"id":"4d310101-f7b1-47fe-982a-efe4abf25c55","first_name":"Sebastian","last_name":"Krüger","email":"valknar@pivoine.art","password":"**********","location":null,"title":null,"description":"Visionary leader with 15+ years in digital media and content creation.","tags":["Love","Sex","Design","Art"],"avatar":"b605cbfd-d9c6-47de-97e5-a4c2b4100c28","language":null,"tfa_secret":null,"status":"active","role":"ea3a9127-2b65-462c-85a8-dbafe9b4fe24","token":null,"last_access":"2025-09-22T18:11:03.551Z","last_page":"/users","provider":"default","external_identifier":null,"auth_data":null,"email_notifications":true,"appearance":null,"theme_dark":null,"theme_light":null,"theme_light_overrides":null,"theme_dark_overrides":null,"text_direction":"auto","website":"pivoine.art","slug":"valknar","join_date":"2025-09-09T12:00:00","featured":true,"artist_name":"Valknar","policies":["b4f61dcc-b54e-4b3e-8a5e-bfbf029f6349","77084e57-682d-43e0-b570-acaf9fe94b1f","21e031ff-632d-46e5-97bb-959a5fef2538"]}	{"first_name":"Sebastian","last_name":"Krüger","description":"Visionary leader with 15+ years in digital media and content creation.","tags":["Love","Sex","Design","Art"],"avatar":"b605cbfd-d9c6-47de-97e5-a4c2b4100c28","slug":"valknar","artist_name":"Valknar"}	\N	\N
542	734	directus_files	470442ff-7eeb-4536-b5ac-6538e569c5b0	{"folder":"5f184291-9a58-4914-9756-ad910378bd90","title":"Sebastian","filename_download":"sebastian.jpg","type":"image/jpeg","storage":"local"}	{"folder":"5f184291-9a58-4914-9756-ad910378bd90","title":"Sebastian","filename_download":"sebastian.jpg","type":"image/jpeg","storage":"local"}	\N	\N
543	735	directus_users	4d310101-f7b1-47fe-982a-efe4abf25c55	{"id":"4d310101-f7b1-47fe-982a-efe4abf25c55","first_name":"Sebastian","last_name":"Krüger","email":"valknar@pivoine.art","password":"**********","location":null,"title":null,"description":"Visionary leader with 15+ years in digital media and content creation.","tags":["Love","Sex","Design","Art"],"avatar":"470442ff-7eeb-4536-b5ac-6538e569c5b0","language":null,"tfa_secret":null,"status":"active","role":"ea3a9127-2b65-462c-85a8-dbafe9b4fe24","token":null,"last_access":"2025-09-22T18:11:03.551Z","last_page":"/users","provider":"default","external_identifier":null,"auth_data":null,"email_notifications":true,"appearance":null,"theme_dark":null,"theme_light":null,"theme_light_overrides":null,"theme_dark_overrides":null,"text_direction":"auto","website":"pivoine.art","slug":"valknar","join_date":"2025-09-09T12:00:00","featured":true,"artist_name":"Valknar","policies":["b4f61dcc-b54e-4b3e-8a5e-bfbf029f6349","77084e57-682d-43e0-b570-acaf9fe94b1f","21e031ff-632d-46e5-97bb-959a5fef2538"]}	{"first_name":"Sebastian","last_name":"Krüger","description":"Visionary leader with 15+ years in digital media and content creation.","tags":["Love","Sex","Design","Art"],"avatar":"470442ff-7eeb-4536-b5ac-6538e569c5b0","slug":"valknar","artist_name":"Valknar"}	\N	\N
544	737	directus_users	4d310101-f7b1-47fe-982a-efe4abf25c55	{"id":"4d310101-f7b1-47fe-982a-efe4abf25c55","first_name":"Sebastian","last_name":"Krüger","email":"valknar@pivoine.art","password":"**********","location":null,"title":null,"description":"Visionary leader with 15+ years in digital media and content creation.","tags":["Love","Sex","Design","Art"],"avatar":"470442ff-7eeb-4536-b5ac-6538e569c5b0","language":null,"tfa_secret":null,"status":"active","role":"ea3a9127-2b65-462c-85a8-dbafe9b4fe24","token":null,"last_access":"2025-09-22T18:11:03.551Z","last_page":"/users","provider":"default","external_identifier":null,"auth_data":null,"email_notifications":true,"appearance":null,"theme_dark":null,"theme_light":null,"theme_light_overrides":null,"theme_dark_overrides":null,"text_direction":"auto","website":"pivoine.art","slug":"valknar","join_date":"2025-09-09T12:00:00","featured":true,"artist_name":"Valknar","policies":["b4f61dcc-b54e-4b3e-8a5e-bfbf029f6349","77084e57-682d-43e0-b570-acaf9fe94b1f","21e031ff-632d-46e5-97bb-959a5fef2538"]}	{"first_name":"Sebastian","last_name":"Krüger","description":"Visionary leader with 15+ years in digital media and content creation.","tags":["Love","Sex","Design","Art"],"slug":"valknar","artist_name":"Valknar"}	\N	\N
548	760	directus_folders	26657630-d9cd-47a3-9e45-9831f3674f97	{"name":"images","parent":"7360b85c-3bb7-4334-ba81-2f46575ea056"}	{"name":"images","parent":"7360b85c-3bb7-4334-ba81-2f46575ea056"}	\N	\N
545	738	directus_files	60f8b2e5-c2a8-4f2a-8262-e2db6e2f33eb	{"folder":"5f184291-9a58-4914-9756-ad910378bd90","title":"Sebastian","filename_download":"sebastian.jpg","type":"image/jpeg","storage":"local"}	{"folder":"5f184291-9a58-4914-9756-ad910378bd90","title":"Sebastian","filename_download":"sebastian.jpg","type":"image/jpeg","storage":"local"}	\N	\N
546	739	directus_users	4d310101-f7b1-47fe-982a-efe4abf25c55	{"id":"4d310101-f7b1-47fe-982a-efe4abf25c55","first_name":"Sebastian","last_name":"Krüger","email":"valknar@pivoine.art","password":"**********","location":null,"title":null,"description":"Visionary leader with 15+ years in digital media and content creation.","tags":["Love","Sex","Design","Art"],"avatar":"60f8b2e5-c2a8-4f2a-8262-e2db6e2f33eb","language":null,"tfa_secret":null,"status":"active","role":"ea3a9127-2b65-462c-85a8-dbafe9b4fe24","token":null,"last_access":"2025-09-22T18:11:03.551Z","last_page":"/users","provider":"default","external_identifier":null,"auth_data":null,"email_notifications":true,"appearance":null,"theme_dark":null,"theme_light":null,"theme_light_overrides":null,"theme_dark_overrides":null,"text_direction":"auto","website":"pivoine.art","slug":"valknar","join_date":"2025-09-09T12:00:00","featured":true,"artist_name":"Valknar","policies":["b4f61dcc-b54e-4b3e-8a5e-bfbf029f6349","77084e57-682d-43e0-b570-acaf9fe94b1f","21e031ff-632d-46e5-97bb-959a5fef2538"]}	{"first_name":"Sebastian","last_name":"Krüger","description":"Visionary leader with 15+ years in digital media and content creation.","tags":["Love","Sex","Design","Art"],"avatar":"60f8b2e5-c2a8-4f2a-8262-e2db6e2f33eb","slug":"valknar","artist_name":"Valknar"}	\N	\N
547	742	directus_users	4d310101-f7b1-47fe-982a-efe4abf25c55	{"id":"4d310101-f7b1-47fe-982a-efe4abf25c55","first_name":"Sebastian","last_name":"Krüger","email":"valknar@pivoine.art","password":"**********","location":null,"title":null,"description":"Visionary leader with 15+ years in digital media and content creation.","tags":["Love","Sex","Design","Art"],"avatar":"aaee7bff-e6ce-426c-9abd-8cc11e91de8e","language":null,"tfa_secret":null,"status":"active","role":"ea3a9127-2b65-462c-85a8-dbafe9b4fe24","token":null,"last_access":"2025-09-22T18:11:03.551Z","last_page":"/users/4d310101-f7b1-47fe-982a-efe4abf25c55","provider":"default","external_identifier":null,"auth_data":null,"email_notifications":true,"appearance":null,"theme_dark":null,"theme_light":null,"theme_light_overrides":null,"theme_dark_overrides":null,"text_direction":"auto","website":"pivoine.art","slug":"valknar","join_date":"2025-09-09T12:00:00","featured":true,"artist_name":"Valknar","policies":["b4f61dcc-b54e-4b3e-8a5e-bfbf029f6349","77084e57-682d-43e0-b570-acaf9fe94b1f","21e031ff-632d-46e5-97bb-959a5fef2538"]}	{"avatar":"aaee7bff-e6ce-426c-9abd-8cc11e91de8e"}	\N	\N
554	767	directus_collections	sexy_videos_directus_users	{"hidden":true,"icon":"import_export","collection":"sexy_videos_directus_users"}	{"hidden":true,"icon":"import_export","collection":"sexy_videos_directus_users"}	\N	\N
555	768	directus_fields	81	{"sort":2,"hidden":true,"collection":"sexy_videos_directus_users","field":"sexy_videos_id"}	{"sort":2,"hidden":true,"collection":"sexy_videos_directus_users","field":"sexy_videos_id"}	\N	\N
556	769	directus_fields	82	{"sort":3,"hidden":true,"collection":"sexy_videos_directus_users","field":"directus_users_id"}	{"sort":3,"hidden":true,"collection":"sexy_videos_directus_users","field":"directus_users_id"}	\N	\N
557	770	directus_fields	79	{"id":79,"collection":"sexy_videos","field":"models","special":["m2m"],"interface":"list-m2m","options":null,"display":null,"display_options":null,"readonly":false,"hidden":false,"sort":14,"width":"full","translations":null,"note":null,"conditions":null,"required":true,"group":null,"validation":null,"validation_message":null}	{"collection":"sexy_videos","field":"models","required":true,"validation":null}	\N	\N
558	771	directus_fields	61	{"id":61,"collection":"sexy_videos","field":"id","special":["uuid"],"interface":"input","options":null,"display":null,"display_options":null,"readonly":true,"hidden":true,"sort":1,"width":"full","translations":null,"note":null,"conditions":null,"required":false,"group":null,"validation":null,"validation_message":null}	{"collection":"sexy_videos","field":"id","sort":1,"group":null}	\N	\N
559	772	directus_fields	62	{"id":62,"collection":"sexy_videos","field":"status","special":null,"interface":"select-dropdown","options":{"choices":[{"text":"$t:published","value":"published","color":"var(--theme--primary)"},{"text":"$t:draft","value":"draft","color":"var(--theme--foreground)"},{"text":"$t:archived","value":"archived","color":"var(--theme--warning)"}]},"display":"labels","display_options":{"showAsDot":true,"choices":[{"text":"$t:published","value":"published","color":"var(--theme--primary)","foreground":"var(--theme--primary)","background":"var(--theme--primary-background)"},{"text":"$t:draft","value":"draft","color":"var(--theme--foreground)","foreground":"var(--theme--foreground)","background":"var(--theme--background-normal)"},{"text":"$t:archived","value":"archived","color":"var(--theme--warning)","foreground":"var(--theme--warning)","background":"var(--theme--warning-background)"}]},"readonly":false,"hidden":false,"sort":2,"width":"full","translations":null,"note":null,"conditions":null,"required":false,"group":null,"validation":null,"validation_message":null}	{"collection":"sexy_videos","field":"status","sort":2,"group":null}	\N	\N
560	773	directus_fields	63	{"id":63,"collection":"sexy_videos","field":"user_created","special":["user-created"],"interface":"select-dropdown-m2o","options":{"template":"{{avatar}} {{first_name}} {{last_name}}"},"display":"user","display_options":null,"readonly":true,"hidden":true,"sort":3,"width":"half","translations":null,"note":null,"conditions":null,"required":false,"group":null,"validation":null,"validation_message":null}	{"collection":"sexy_videos","field":"user_created","sort":3,"group":null}	\N	\N
561	774	directus_fields	64	{"id":64,"collection":"sexy_videos","field":"date_created","special":["date-created"],"interface":"datetime","options":null,"display":"datetime","display_options":{"relative":true},"readonly":true,"hidden":true,"sort":4,"width":"half","translations":null,"note":null,"conditions":null,"required":false,"group":null,"validation":null,"validation_message":null}	{"collection":"sexy_videos","field":"date_created","sort":4,"group":null}	\N	\N
562	775	directus_fields	65	{"id":65,"collection":"sexy_videos","field":"date_updated","special":["date-updated"],"interface":"datetime","options":null,"display":"datetime","display_options":{"relative":true},"readonly":true,"hidden":true,"sort":5,"width":"half","translations":null,"note":null,"conditions":null,"required":false,"group":null,"validation":null,"validation_message":null}	{"collection":"sexy_videos","field":"date_updated","sort":5,"group":null}	\N	\N
563	776	directus_fields	66	{"id":66,"collection":"sexy_videos","field":"slug","special":null,"interface":"input","options":{"slug":true,"trim":true},"display":null,"display_options":null,"readonly":false,"hidden":false,"sort":6,"width":"full","translations":null,"note":null,"conditions":null,"required":true,"group":null,"validation":null,"validation_message":null}	{"collection":"sexy_videos","field":"slug","sort":6,"group":null}	\N	\N
564	777	directus_fields	67	{"id":67,"collection":"sexy_videos","field":"title","special":null,"interface":"input","options":null,"display":null,"display_options":null,"readonly":false,"hidden":false,"sort":7,"width":"full","translations":null,"note":null,"conditions":null,"required":true,"group":null,"validation":null,"validation_message":null}	{"collection":"sexy_videos","field":"title","sort":7,"group":null}	\N	\N
565	778	directus_fields	68	{"id":68,"collection":"sexy_videos","field":"image","special":["file"],"interface":"file-image","options":{"folder":"7360b85c-3bb7-4334-ba81-2f46575ea056"},"display":null,"display_options":null,"readonly":false,"hidden":false,"sort":8,"width":"full","translations":null,"note":null,"conditions":null,"required":true,"group":null,"validation":null,"validation_message":null}	{"collection":"sexy_videos","field":"image","sort":8,"group":null}	\N	\N
566	779	directus_fields	79	{"id":79,"collection":"sexy_videos","field":"models","special":["m2m"],"interface":"list-m2m","options":null,"display":null,"display_options":null,"readonly":false,"hidden":false,"sort":9,"width":"full","translations":null,"note":null,"conditions":null,"required":true,"group":null,"validation":null,"validation_message":null}	{"collection":"sexy_videos","field":"models","sort":9,"group":null}	\N	\N
567	780	directus_fields	70	{"id":70,"collection":"sexy_videos","field":"upload_date","special":null,"interface":"datetime","options":null,"display":null,"display_options":null,"readonly":false,"hidden":false,"sort":10,"width":"full","translations":null,"note":null,"conditions":null,"required":true,"group":null,"validation":null,"validation_message":null}	{"collection":"sexy_videos","field":"upload_date","sort":10,"group":null}	\N	\N
568	781	directus_fields	71	{"id":71,"collection":"sexy_videos","field":"premium","special":["cast-boolean"],"interface":"boolean","options":{"label":"Premium"},"display":null,"display_options":null,"readonly":false,"hidden":false,"sort":11,"width":"full","translations":null,"note":null,"conditions":null,"required":false,"group":null,"validation":null,"validation_message":null}	{"collection":"sexy_videos","field":"premium","sort":11,"group":null}	\N	\N
569	782	directus_fields	72	{"id":72,"collection":"sexy_videos","field":"featured","special":["cast-boolean"],"interface":"boolean","options":{"label":"Featured"},"display":null,"display_options":null,"readonly":false,"hidden":false,"sort":12,"width":"full","translations":null,"note":null,"conditions":null,"required":false,"group":null,"validation":null,"validation_message":null}	{"collection":"sexy_videos","field":"featured","sort":12,"group":null}	\N	\N
570	783	directus_fields	78	{"id":78,"collection":"sexy_videos","field":"tags","special":["cast-json"],"interface":"tags","options":null,"display":null,"display_options":null,"readonly":false,"hidden":false,"sort":13,"width":"full","translations":null,"note":null,"conditions":null,"required":false,"group":null,"validation":null,"validation_message":null}	{"collection":"sexy_videos","field":"tags","sort":13,"group":null}	\N	\N
638	873	directus_collections	junction_directus_users_videos	{"hidden":true,"icon":"import_export","collection":"junction_directus_users_videos"}	{"hidden":true,"icon":"import_export","collection":"junction_directus_users_videos"}	\N	\N
571	784	directus_fields	83	{"sort":14,"interface":"file","special":["file"],"required":true,"options":{"folder":"3f83c727-9c90-4e0d-871f-ab81c295043a","filter":{"_and":[{"type":{"_eq":"video/mp4"}}]}},"collection":"sexy_videos","field":"movie"}	{"sort":14,"interface":"file","special":["file"],"required":true,"options":{"folder":"3f83c727-9c90-4e0d-871f-ab81c295043a","filter":{"_and":[{"type":{"_eq":"video/mp4"}}]}},"collection":"sexy_videos","field":"movie"}	\N	\N
572	785	directus_fields	61	{"id":61,"collection":"sexy_videos","field":"id","special":["uuid"],"interface":"input","options":null,"display":null,"display_options":null,"readonly":true,"hidden":true,"sort":1,"width":"full","translations":null,"note":null,"conditions":null,"required":false,"group":null,"validation":null,"validation_message":null}	{"collection":"sexy_videos","field":"id","sort":1,"group":null}	\N	\N
573	786	directus_fields	62	{"id":62,"collection":"sexy_videos","field":"status","special":null,"interface":"select-dropdown","options":{"choices":[{"text":"$t:published","value":"published","color":"var(--theme--primary)"},{"text":"$t:draft","value":"draft","color":"var(--theme--foreground)"},{"text":"$t:archived","value":"archived","color":"var(--theme--warning)"}]},"display":"labels","display_options":{"showAsDot":true,"choices":[{"text":"$t:published","value":"published","color":"var(--theme--primary)","foreground":"var(--theme--primary)","background":"var(--theme--primary-background)"},{"text":"$t:draft","value":"draft","color":"var(--theme--foreground)","foreground":"var(--theme--foreground)","background":"var(--theme--background-normal)"},{"text":"$t:archived","value":"archived","color":"var(--theme--warning)","foreground":"var(--theme--warning)","background":"var(--theme--warning-background)"}]},"readonly":false,"hidden":false,"sort":2,"width":"full","translations":null,"note":null,"conditions":null,"required":false,"group":null,"validation":null,"validation_message":null}	{"collection":"sexy_videos","field":"status","sort":2,"group":null}	\N	\N
574	787	directus_fields	63	{"id":63,"collection":"sexy_videos","field":"user_created","special":["user-created"],"interface":"select-dropdown-m2o","options":{"template":"{{avatar}} {{first_name}} {{last_name}}"},"display":"user","display_options":null,"readonly":true,"hidden":true,"sort":3,"width":"half","translations":null,"note":null,"conditions":null,"required":false,"group":null,"validation":null,"validation_message":null}	{"collection":"sexy_videos","field":"user_created","sort":3,"group":null}	\N	\N
575	788	directus_fields	64	{"id":64,"collection":"sexy_videos","field":"date_created","special":["date-created"],"interface":"datetime","options":null,"display":"datetime","display_options":{"relative":true},"readonly":true,"hidden":true,"sort":4,"width":"half","translations":null,"note":null,"conditions":null,"required":false,"group":null,"validation":null,"validation_message":null}	{"collection":"sexy_videos","field":"date_created","sort":4,"group":null}	\N	\N
576	789	directus_fields	65	{"id":65,"collection":"sexy_videos","field":"date_updated","special":["date-updated"],"interface":"datetime","options":null,"display":"datetime","display_options":{"relative":true},"readonly":true,"hidden":true,"sort":5,"width":"half","translations":null,"note":null,"conditions":null,"required":false,"group":null,"validation":null,"validation_message":null}	{"collection":"sexy_videos","field":"date_updated","sort":5,"group":null}	\N	\N
577	790	directus_fields	66	{"id":66,"collection":"sexy_videos","field":"slug","special":null,"interface":"input","options":{"slug":true,"trim":true},"display":null,"display_options":null,"readonly":false,"hidden":false,"sort":6,"width":"full","translations":null,"note":null,"conditions":null,"required":true,"group":null,"validation":null,"validation_message":null}	{"collection":"sexy_videos","field":"slug","sort":6,"group":null}	\N	\N
578	791	directus_fields	67	{"id":67,"collection":"sexy_videos","field":"title","special":null,"interface":"input","options":null,"display":null,"display_options":null,"readonly":false,"hidden":false,"sort":7,"width":"full","translations":null,"note":null,"conditions":null,"required":true,"group":null,"validation":null,"validation_message":null}	{"collection":"sexy_videos","field":"title","sort":7,"group":null}	\N	\N
579	792	directus_fields	68	{"id":68,"collection":"sexy_videos","field":"image","special":["file"],"interface":"file-image","options":{"folder":"7360b85c-3bb7-4334-ba81-2f46575ea056"},"display":null,"display_options":null,"readonly":false,"hidden":false,"sort":8,"width":"full","translations":null,"note":null,"conditions":null,"required":true,"group":null,"validation":null,"validation_message":null}	{"collection":"sexy_videos","field":"image","sort":8,"group":null}	\N	\N
580	793	directus_fields	83	{"id":83,"collection":"sexy_videos","field":"movie","special":["file"],"interface":"file","options":{"folder":"3f83c727-9c90-4e0d-871f-ab81c295043a","filter":{"_and":[{"type":{"_eq":"video/mp4"}}]}},"display":null,"display_options":null,"readonly":false,"hidden":false,"sort":9,"width":"full","translations":null,"note":null,"conditions":null,"required":true,"group":null,"validation":null,"validation_message":null}	{"collection":"sexy_videos","field":"movie","sort":9,"group":null}	\N	\N
581	794	directus_fields	79	{"id":79,"collection":"sexy_videos","field":"models","special":["m2m"],"interface":"list-m2m","options":null,"display":null,"display_options":null,"readonly":false,"hidden":false,"sort":10,"width":"full","translations":null,"note":null,"conditions":null,"required":true,"group":null,"validation":null,"validation_message":null}	{"collection":"sexy_videos","field":"models","sort":10,"group":null}	\N	\N
582	795	directus_fields	70	{"id":70,"collection":"sexy_videos","field":"upload_date","special":null,"interface":"datetime","options":null,"display":null,"display_options":null,"readonly":false,"hidden":false,"sort":11,"width":"full","translations":null,"note":null,"conditions":null,"required":true,"group":null,"validation":null,"validation_message":null}	{"collection":"sexy_videos","field":"upload_date","sort":11,"group":null}	\N	\N
583	796	directus_fields	71	{"id":71,"collection":"sexy_videos","field":"premium","special":["cast-boolean"],"interface":"boolean","options":{"label":"Premium"},"display":null,"display_options":null,"readonly":false,"hidden":false,"sort":12,"width":"full","translations":null,"note":null,"conditions":null,"required":false,"group":null,"validation":null,"validation_message":null}	{"collection":"sexy_videos","field":"premium","sort":12,"group":null}	\N	\N
584	797	directus_fields	72	{"id":72,"collection":"sexy_videos","field":"featured","special":["cast-boolean"],"interface":"boolean","options":{"label":"Featured"},"display":null,"display_options":null,"readonly":false,"hidden":false,"sort":13,"width":"full","translations":null,"note":null,"conditions":null,"required":false,"group":null,"validation":null,"validation_message":null}	{"collection":"sexy_videos","field":"featured","sort":13,"group":null}	\N	\N
585	798	directus_fields	78	{"id":78,"collection":"sexy_videos","field":"tags","special":["cast-json"],"interface":"tags","options":null,"display":null,"display_options":null,"readonly":false,"hidden":false,"sort":14,"width":"full","translations":null,"note":null,"conditions":null,"required":false,"group":null,"validation":null,"validation_message":null}	{"collection":"sexy_videos","field":"tags","sort":14,"group":null}	\N	\N
586	799	directus_fields	68	{"id":68,"collection":"sexy_videos","field":"image","special":["file"],"interface":"file-image","options":{"folder":"26657630-d9cd-47a3-9e45-9831f3674f97"},"display":null,"display_options":null,"readonly":false,"hidden":false,"sort":8,"width":"full","translations":null,"note":null,"conditions":null,"required":true,"group":null,"validation":null,"validation_message":null}	{"collection":"sexy_videos","field":"image","options":{"folder":"26657630-d9cd-47a3-9e45-9831f3674f97"}}	\N	\N
587	800	directus_files	bab78ff3-10bf-4fc6-9e3a-6e58bb6655b1	{"folder":"7360b85c-3bb7-4334-ba81-2f46575ea056","title":"Sexybelle","filename_download":"sexybelle.png","type":"image/png","storage":"local"}	{"folder":"7360b85c-3bb7-4334-ba81-2f46575ea056","title":"Sexybelle","filename_download":"sexybelle.png","type":"image/png","storage":"local"}	\N	\N
588	801	directus_files	3001a83c-3033-4dd1-b3ac-c910bdb1ef2c	{"folder":"3f83c727-9c90-4e0d-871f-ab81c295043a","title":"Sexybelle","filename_download":"sexybelle.mp4","type":"video/mp4","storage":"local"}	{"folder":"3f83c727-9c90-4e0d-871f-ab81c295043a","title":"Sexybelle","filename_download":"sexybelle.mp4","type":"video/mp4","storage":"local"}	\N	\N
591	804	sexy_videos	75296c46-3c71-4182-a4ce-416722377d76	{"title":"SexyArt / SexyBelle","slug":"sexyart-sexybelle","models":{"create":[{"sexy_videos_id":"+","directus_users_id":{"id":"543f4d0b-e346-4e5e-8aca-4a9b35d5fab6"}},{"sexy_videos_id":"+","directus_users_id":{"id":"4d310101-f7b1-47fe-982a-efe4abf25c55"}}],"update":[],"delete":[]},"upload_date":"2025-09-26T15:48:00","featured":true,"image":"bab78ff3-10bf-4fc6-9e3a-6e58bb6655b1","movie":"3001a83c-3033-4dd1-b3ac-c910bdb1ef2c"}	{"title":"SexyArt / SexyBelle","slug":"sexyart-sexybelle","models":{"create":[{"sexy_videos_id":"+","directus_users_id":{"id":"543f4d0b-e346-4e5e-8aca-4a9b35d5fab6"}},{"sexy_videos_id":"+","directus_users_id":{"id":"4d310101-f7b1-47fe-982a-efe4abf25c55"}}],"update":[],"delete":[]},"upload_date":"2025-09-26T15:48:00","featured":true,"image":"bab78ff3-10bf-4fc6-9e3a-6e58bb6655b1","movie":"3001a83c-3033-4dd1-b3ac-c910bdb1ef2c"}	\N	\N
589	802	sexy_videos_directus_users	1	{"sexy_videos_id":"75296c46-3c71-4182-a4ce-416722377d76","directus_users_id":{"id":"543f4d0b-e346-4e5e-8aca-4a9b35d5fab6"}}	{"sexy_videos_id":"75296c46-3c71-4182-a4ce-416722377d76","directus_users_id":{"id":"543f4d0b-e346-4e5e-8aca-4a9b35d5fab6"}}	591	\N
590	803	sexy_videos_directus_users	2	{"sexy_videos_id":"75296c46-3c71-4182-a4ce-416722377d76","directus_users_id":{"id":"4d310101-f7b1-47fe-982a-efe4abf25c55"}}	{"sexy_videos_id":"75296c46-3c71-4182-a4ce-416722377d76","directus_users_id":{"id":"4d310101-f7b1-47fe-982a-efe4abf25c55"}}	591	\N
592	805	sexy_videos	75296c46-3c71-4182-a4ce-416722377d76	{"id":"75296c46-3c71-4182-a4ce-416722377d76","status":"published","user_created":"4d310101-f7b1-47fe-982a-efe4abf25c55","date_created":"2025-09-26T13:56:55.554Z","date_updated":"2025-09-26T13:57:11.054Z","slug":"sexyart-sexybelle","title":"SexyArt / SexyBelle","image":"bab78ff3-10bf-4fc6-9e3a-6e58bb6655b1","upload_date":"2025-09-26T15:48:00","premium":null,"featured":true,"tags":null,"movie":"3001a83c-3033-4dd1-b3ac-c910bdb1ef2c","models":[1,2]}	{"status":"published","date_updated":"2025-09-26T13:57:11.054Z"}	\N	\N
593	806	directus_fields	84	{"sort":15,"interface":"input-multiline","special":null,"required":true,"options":{"trim":true},"collection":"sexy_videos","field":"description"}	{"sort":15,"interface":"input-multiline","special":null,"required":true,"options":{"trim":true},"collection":"sexy_videos","field":"description"}	\N	\N
594	807	directus_fields	61	{"id":61,"collection":"sexy_videos","field":"id","special":["uuid"],"interface":"input","options":null,"display":null,"display_options":null,"readonly":true,"hidden":true,"sort":1,"width":"full","translations":null,"note":null,"conditions":null,"required":false,"group":null,"validation":null,"validation_message":null}	{"collection":"sexy_videos","field":"id","sort":1,"group":null}	\N	\N
595	808	directus_fields	62	{"id":62,"collection":"sexy_videos","field":"status","special":null,"interface":"select-dropdown","options":{"choices":[{"text":"$t:published","value":"published","color":"var(--theme--primary)"},{"text":"$t:draft","value":"draft","color":"var(--theme--foreground)"},{"text":"$t:archived","value":"archived","color":"var(--theme--warning)"}]},"display":"labels","display_options":{"showAsDot":true,"choices":[{"text":"$t:published","value":"published","color":"var(--theme--primary)","foreground":"var(--theme--primary)","background":"var(--theme--primary-background)"},{"text":"$t:draft","value":"draft","color":"var(--theme--foreground)","foreground":"var(--theme--foreground)","background":"var(--theme--background-normal)"},{"text":"$t:archived","value":"archived","color":"var(--theme--warning)","foreground":"var(--theme--warning)","background":"var(--theme--warning-background)"}]},"readonly":false,"hidden":false,"sort":2,"width":"full","translations":null,"note":null,"conditions":null,"required":false,"group":null,"validation":null,"validation_message":null}	{"collection":"sexy_videos","field":"status","sort":2,"group":null}	\N	\N
596	809	directus_fields	63	{"id":63,"collection":"sexy_videos","field":"user_created","special":["user-created"],"interface":"select-dropdown-m2o","options":{"template":"{{avatar}} {{first_name}} {{last_name}}"},"display":"user","display_options":null,"readonly":true,"hidden":true,"sort":3,"width":"half","translations":null,"note":null,"conditions":null,"required":false,"group":null,"validation":null,"validation_message":null}	{"collection":"sexy_videos","field":"user_created","sort":3,"group":null}	\N	\N
597	810	directus_fields	64	{"id":64,"collection":"sexy_videos","field":"date_created","special":["date-created"],"interface":"datetime","options":null,"display":"datetime","display_options":{"relative":true},"readonly":true,"hidden":true,"sort":4,"width":"half","translations":null,"note":null,"conditions":null,"required":false,"group":null,"validation":null,"validation_message":null}	{"collection":"sexy_videos","field":"date_created","sort":4,"group":null}	\N	\N
598	811	directus_fields	65	{"id":65,"collection":"sexy_videos","field":"date_updated","special":["date-updated"],"interface":"datetime","options":null,"display":"datetime","display_options":{"relative":true},"readonly":true,"hidden":true,"sort":5,"width":"half","translations":null,"note":null,"conditions":null,"required":false,"group":null,"validation":null,"validation_message":null}	{"collection":"sexy_videos","field":"date_updated","sort":5,"group":null}	\N	\N
639	874	directus_fields	99	{"sort":2,"hidden":true,"collection":"junction_directus_users_videos","field":"directus_users_id"}	{"sort":2,"hidden":true,"collection":"junction_directus_users_videos","field":"directus_users_id"}	\N	\N
640	875	directus_fields	100	{"sort":3,"hidden":true,"collection":"junction_directus_users_videos","field":"item"}	{"sort":3,"hidden":true,"collection":"junction_directus_users_videos","field":"item"}	\N	\N
641	876	directus_fields	101	{"sort":4,"hidden":true,"collection":"junction_directus_users_videos","field":"collection"}	{"sort":4,"hidden":true,"collection":"junction_directus_users_videos","field":"collection"}	\N	\N
642	888	directus_folders	a21e028c-52de-4bc2-8b74-2633194267ab	{"name":"users","parent":"c214c905-885b-4d66-a6a1-6527b0606200"}	{"name":"users","parent":"c214c905-885b-4d66-a6a1-6527b0606200"}	\N	\N
599	812	directus_fields	66	{"id":66,"collection":"sexy_videos","field":"slug","special":null,"interface":"input","options":{"slug":true,"trim":true},"display":null,"display_options":null,"readonly":false,"hidden":false,"sort":6,"width":"full","translations":null,"note":null,"conditions":null,"required":true,"group":null,"validation":null,"validation_message":null}	{"collection":"sexy_videos","field":"slug","sort":6,"group":null}	\N	\N
600	813	directus_fields	67	{"id":67,"collection":"sexy_videos","field":"title","special":null,"interface":"input","options":null,"display":null,"display_options":null,"readonly":false,"hidden":false,"sort":7,"width":"full","translations":null,"note":null,"conditions":null,"required":true,"group":null,"validation":null,"validation_message":null}	{"collection":"sexy_videos","field":"title","sort":7,"group":null}	\N	\N
601	814	directus_fields	84	{"id":84,"collection":"sexy_videos","field":"description","special":null,"interface":"input-multiline","options":{"trim":true},"display":null,"display_options":null,"readonly":false,"hidden":false,"sort":8,"width":"full","translations":null,"note":null,"conditions":null,"required":true,"group":null,"validation":null,"validation_message":null}	{"collection":"sexy_videos","field":"description","sort":8,"group":null}	\N	\N
602	815	directus_fields	68	{"id":68,"collection":"sexy_videos","field":"image","special":["file"],"interface":"file-image","options":{"folder":"26657630-d9cd-47a3-9e45-9831f3674f97"},"display":null,"display_options":null,"readonly":false,"hidden":false,"sort":9,"width":"full","translations":null,"note":null,"conditions":null,"required":true,"group":null,"validation":null,"validation_message":null}	{"collection":"sexy_videos","field":"image","sort":9,"group":null}	\N	\N
603	816	directus_fields	83	{"id":83,"collection":"sexy_videos","field":"movie","special":["file"],"interface":"file","options":{"folder":"3f83c727-9c90-4e0d-871f-ab81c295043a","filter":{"_and":[{"type":{"_eq":"video/mp4"}}]}},"display":null,"display_options":null,"readonly":false,"hidden":false,"sort":10,"width":"full","translations":null,"note":null,"conditions":null,"required":true,"group":null,"validation":null,"validation_message":null}	{"collection":"sexy_videos","field":"movie","sort":10,"group":null}	\N	\N
604	817	directus_fields	79	{"id":79,"collection":"sexy_videos","field":"models","special":["m2m"],"interface":"list-m2m","options":null,"display":null,"display_options":null,"readonly":false,"hidden":false,"sort":11,"width":"full","translations":null,"note":null,"conditions":null,"required":true,"group":null,"validation":null,"validation_message":null}	{"collection":"sexy_videos","field":"models","sort":11,"group":null}	\N	\N
605	818	directus_fields	70	{"id":70,"collection":"sexy_videos","field":"upload_date","special":null,"interface":"datetime","options":null,"display":null,"display_options":null,"readonly":false,"hidden":false,"sort":12,"width":"full","translations":null,"note":null,"conditions":null,"required":true,"group":null,"validation":null,"validation_message":null}	{"collection":"sexy_videos","field":"upload_date","sort":12,"group":null}	\N	\N
606	819	directus_fields	71	{"id":71,"collection":"sexy_videos","field":"premium","special":["cast-boolean"],"interface":"boolean","options":{"label":"Premium"},"display":null,"display_options":null,"readonly":false,"hidden":false,"sort":13,"width":"full","translations":null,"note":null,"conditions":null,"required":false,"group":null,"validation":null,"validation_message":null}	{"collection":"sexy_videos","field":"premium","sort":13,"group":null}	\N	\N
607	820	directus_fields	72	{"id":72,"collection":"sexy_videos","field":"featured","special":["cast-boolean"],"interface":"boolean","options":{"label":"Featured"},"display":null,"display_options":null,"readonly":false,"hidden":false,"sort":14,"width":"full","translations":null,"note":null,"conditions":null,"required":false,"group":null,"validation":null,"validation_message":null}	{"collection":"sexy_videos","field":"featured","sort":14,"group":null}	\N	\N
608	821	directus_fields	78	{"id":78,"collection":"sexy_videos","field":"tags","special":["cast-json"],"interface":"tags","options":null,"display":null,"display_options":null,"readonly":false,"hidden":false,"sort":15,"width":"full","translations":null,"note":null,"conditions":null,"required":false,"group":null,"validation":null,"validation_message":null}	{"collection":"sexy_videos","field":"tags","sort":15,"group":null}	\N	\N
609	822	sexy_videos	75296c46-3c71-4182-a4ce-416722377d76	{"id":"75296c46-3c71-4182-a4ce-416722377d76","status":"published","user_created":"4d310101-f7b1-47fe-982a-efe4abf25c55","date_created":"2025-09-26T13:56:55.554Z","date_updated":"2025-09-26T14:18:32.932Z","slug":"sexyart-sexybelle","title":"SexyArt / SexyBelle","image":"bab78ff3-10bf-4fc6-9e3a-6e58bb6655b1","upload_date":"2025-09-26T15:48:00","premium":null,"featured":true,"tags":null,"movie":"3001a83c-3033-4dd1-b3ac-c910bdb1ef2c","description":"TODO","models":[1,2]}	{"description":"TODO","date_updated":"2025-09-26T14:18:32.932Z"}	\N	\N
610	823	sexy_videos	75296c46-3c71-4182-a4ce-416722377d76	{"id":"75296c46-3c71-4182-a4ce-416722377d76","status":"published","user_created":"4d310101-f7b1-47fe-982a-efe4abf25c55","date_created":"2025-09-26T13:56:55.554Z","date_updated":"2025-09-26T15:08:24.320Z","slug":"sexyart-sexybelle","title":"SexyArt / SexyBelle","image":"bab78ff3-10bf-4fc6-9e3a-6e58bb6655b1","upload_date":"2025-09-26T15:48:00","premium":null,"featured":true,"tags":null,"movie":"3001a83c-3033-4dd1-b3ac-c910bdb1ef2c","description":"Luna Belle - candy girl","models":[1,2]}	{"description":"Luna Belle - candy girl","date_updated":"2025-09-26T15:08:24.320Z"}	\N	\N
611	824	sexy_videos	75296c46-3c71-4182-a4ce-416722377d76	{"id":"75296c46-3c71-4182-a4ce-416722377d76","status":"published","user_created":"4d310101-f7b1-47fe-982a-efe4abf25c55","date_created":"2025-09-26T13:56:55.554Z","date_updated":"2025-09-26T16:15:42.631Z","slug":"sexyart-sexybelle","title":"SexyArt / SexyBelle","image":"bab78ff3-10bf-4fc6-9e3a-6e58bb6655b1","upload_date":"2025-09-26T15:48:00","premium":null,"featured":true,"tags":["Funky","Sex","Love","Kiss"],"movie":"3001a83c-3033-4dd1-b3ac-c910bdb1ef2c","description":"Luna Belle - candy girl","models":[1,2]}	{"tags":["Funky","Sex","Love","Kiss"],"date_updated":"2025-09-26T16:15:42.631Z"}	\N	\N
612	825	sexy_videos	75296c46-3c71-4182-a4ce-416722377d76	{"id":"75296c46-3c71-4182-a4ce-416722377d76","status":"published","user_created":"4d310101-f7b1-47fe-982a-efe4abf25c55","date_created":"2025-09-26T13:56:55.554Z","date_updated":"2025-09-26T16:17:34.314Z","slug":"sexyart-sexybelle","title":"SexyArt / SexyBelle","image":"bab78ff3-10bf-4fc6-9e3a-6e58bb6655b1","upload_date":"2025-09-26T15:48:00","premium":null,"featured":true,"tags":["Funky","Sex","Love","Kiss"],"movie":"3001a83c-3033-4dd1-b3ac-c910bdb1ef2c","description":"____                _       _   ____                    _ \\n / ___|___  _ __ ___ (_)_ __ ( ) / ___|  ___   ___  _ __ | |\\n| |   / _ \\\\| '_ ` _ \\\\| | '_ \\\\|/  \\\\___ \\\\ / _ \\\\ / _ \\\\| '_ \\\\| |\\n| |__| (_) | | | | | | | | | |    ___) | (_) | (_) | | | |_|\\n \\\\____\\\\___/|_| |_| |_|_|_| |_|   |____/ \\\\___/ \\\\___/|_| |_(_)","models":[1,2]}	{"description":"____                _       _   ____                    _ \\n / ___|___  _ __ ___ (_)_ __ ( ) / ___|  ___   ___  _ __ | |\\n| |   / _ \\\\| '_ ` _ \\\\| | '_ \\\\|/  \\\\___ \\\\ / _ \\\\ / _ \\\\| '_ \\\\| |\\n| |__| (_) | | | | | | | | | |    ___) | (_) | (_) | | | |_|\\n \\\\____\\\\___/|_| |_| |_|_|_| |_|   |____/ \\\\___/ \\\\___/|_| |_(_)","date_updated":"2025-09-26T16:17:34.314Z"}	\N	\N
613	826	sexy_videos	75296c46-3c71-4182-a4ce-416722377d76	{"id":"75296c46-3c71-4182-a4ce-416722377d76","status":"published","user_created":"4d310101-f7b1-47fe-982a-efe4abf25c55","date_created":"2025-09-26T13:56:55.554Z","date_updated":"2025-09-26T16:19:24.982Z","slug":"sexyart-sexybelle","title":"SexyArt / SexyBelle","image":"bab78ff3-10bf-4fc6-9e3a-6e58bb6655b1","upload_date":"2025-09-26T15:48:00","premium":null,"featured":true,"tags":["Funky","Sex","Love","Kiss"],"movie":"3001a83c-3033-4dd1-b3ac-c910bdb1ef2c","description":"Comin' Soon","models":[1,2]}	{"description":"Comin' Soon","date_updated":"2025-09-26T16:19:24.982Z"}	\N	\N
614	827	sexy_videos	75296c46-3c71-4182-a4ce-416722377d76	{"id":"75296c46-3c71-4182-a4ce-416722377d76","status":"published","user_created":"4d310101-f7b1-47fe-982a-efe4abf25c55","date_created":"2025-09-26T13:56:55.554Z","date_updated":"2025-09-26T16:19:44.753Z","slug":"sexyart-sexybelle","title":"SexyArt / SexyBelle","image":"bab78ff3-10bf-4fc6-9e3a-6e58bb6655b1","upload_date":"2025-09-26T15:48:00","premium":null,"featured":true,"tags":["Funky","Sex","Love","Kiss"],"movie":"3001a83c-3033-4dd1-b3ac-c910bdb1ef2c","description":"Comin' Soon!!!!!!!","models":[1,2]}	{"description":"Comin' Soon!!!!!!!","date_updated":"2025-09-26T16:19:44.753Z"}	\N	\N
615	830	directus_permissions	101	{"policy":"f575bea7-7260-4d81-a931-81d762f2b47d","permissions":null,"validation":null,"fields":["*"],"presets":null,"collection":"directus_permissions","action":"read"}	{"policy":"f575bea7-7260-4d81-a931-81d762f2b47d","permissions":null,"validation":null,"fields":["*"],"presets":null,"collection":"directus_permissions","action":"read"}	\N	\N
616	833	directus_permissions	102	{"policy":"f575bea7-7260-4d81-a931-81d762f2b47d","permissions":null,"validation":null,"fields":["*"],"presets":null,"collection":"sexy_videos_directus_users","action":"read"}	{"policy":"f575bea7-7260-4d81-a931-81d762f2b47d","permissions":null,"validation":null,"fields":["*"],"presets":null,"collection":"sexy_videos_directus_users","action":"read"}	\N	\N
617	837	directus_fields	85	{"sort":16,"interface":"select-dropdown-m2o","special":["m2o"],"collection":"sexy_videos","field":"comments"}	{"sort":16,"interface":"select-dropdown-m2o","special":["m2o"],"collection":"sexy_videos","field":"comments"}	\N	\N
618	839	directus_fields	86	{"sort":16,"interface":"list-o2m","special":["o2m"],"options":{"enableLink":true},"collection":"sexy_videos","field":"comments"}	{"sort":16,"interface":"list-o2m","special":["o2m"],"options":{"enableLink":true},"collection":"sexy_videos","field":"comments"}	\N	\N
619	841	directus_fields	87	{"sort":16,"interface":"list-o2m","special":["o2m"],"collection":"sexy_videos","field":"comments"}	{"sort":16,"interface":"list-o2m","special":["o2m"],"collection":"sexy_videos","field":"comments"}	\N	\N
620	843	directus_fields	88	{"sort":16,"interface":"list-o2m","special":["o2m"],"options":{"enableLink":true,"sort":"date_created","sortDirection":"-"},"collection":"sexy_videos","field":"comments"}	{"sort":16,"interface":"list-o2m","special":["o2m"],"options":{"enableLink":true,"sort":"date_created","sortDirection":"-"},"collection":"sexy_videos","field":"comments"}	\N	\N
621	845	directus_fields	89	{"sort":16,"interface":"list-m2a","special":["m2a"],"options":{"sort":null,"selectedCollection":"directus_comments"},"collection":"sexy_videos","field":"comments"}	{"sort":16,"interface":"list-m2a","special":["m2a"],"options":{"sort":null,"selectedCollection":"directus_comments"},"collection":"sexy_videos","field":"comments"}	\N	\N
622	846	directus_fields	90	{"sort":1,"hidden":true,"field":"id","collection":"sexy_videos_comments"}	{"sort":1,"hidden":true,"field":"id","collection":"sexy_videos_comments"}	\N	\N
623	847	directus_collections	sexy_videos_comments	{"hidden":true,"icon":"import_export","collection":"sexy_videos_comments"}	{"hidden":true,"icon":"import_export","collection":"sexy_videos_comments"}	\N	\N
624	848	directus_fields	91	{"sort":2,"hidden":true,"collection":"sexy_videos_comments","field":"sexy_videos_id"}	{"sort":2,"hidden":true,"collection":"sexy_videos_comments","field":"sexy_videos_id"}	\N	\N
625	849	directus_fields	92	{"sort":3,"hidden":true,"collection":"sexy_videos_comments","field":"item"}	{"sort":3,"hidden":true,"collection":"sexy_videos_comments","field":"item"}	\N	\N
626	850	directus_fields	93	{"sort":4,"hidden":true,"collection":"sexy_videos_comments","field":"collection"}	{"sort":4,"hidden":true,"collection":"sexy_videos_comments","field":"collection"}	\N	\N
627	851	directus_comments	034e7209-1751-4797-bab4-519a3d4f2eac	{"collection":"sexy_videos","item":"75296c46-3c71-4182-a4ce-416722377d76","comment":"I love you baby!"}	{"collection":"sexy_videos","item":"75296c46-3c71-4182-a4ce-416722377d76","comment":"I love you baby!"}	\N	\N
628	852	directus_comments	992cfc88-fcaf-4c7e-8f39-d6ba9c7f6d94	{"collection":"sexy_videos","item":"75296c46-3c71-4182-a4ce-416722377d76","comment":"qqweqwe"}	{"collection":"sexy_videos","item":"75296c46-3c71-4182-a4ce-416722377d76","comment":"qqweqwe"}	\N	\N
629	854	directus_comments	6fd98c72-bc4f-4737-b327-0ef803f85d94	{"collection":"sexy_videos","item":"75296c46-3c71-4182-a4ce-416722377d76","comment":"yxc"}	{"collection":"sexy_videos","item":"75296c46-3c71-4182-a4ce-416722377d76","comment":"yxc"}	\N	\N
630	858	directus_comments	b88bda2d-0df8-4857-a274-49e9d690a4b0	{"collection":"sexy_videos","item":"75296c46-3c71-4182-a4ce-416722377d76","comment":"sdf"}	{"collection":"sexy_videos","item":"75296c46-3c71-4182-a4ce-416722377d76","comment":"sdf"}	\N	\N
631	859	directus_comments	3ecb593a-ab0f-459f-9b19-cdeeb44d4d03	{"collection":"sexy_videos","item":"75296c46-3c71-4182-a4ce-416722377d76","comment":"sdf"}	{"collection":"sexy_videos","item":"75296c46-3c71-4182-a4ce-416722377d76","comment":"sdf"}	\N	\N
632	860	directus_comments	f47d9c79-a6db-482b-8c87-094c198bef0b	{"collection":"sexy_videos","item":"75296c46-3c71-4182-a4ce-416722377d76","comment":"sdffsdf"}	{"collection":"sexy_videos","item":"75296c46-3c71-4182-a4ce-416722377d76","comment":"sdffsdf"}	\N	\N
633	865	directus_fields	94	{"sort":6,"interface":"list-o2m","special":["o2m"],"options":{"enableLink":true},"collection":"directus_users","field":"videos"}	{"sort":6,"interface":"list-o2m","special":["o2m"],"options":{"enableLink":true},"collection":"directus_users","field":"videos"}	\N	\N
634	867	directus_fields	95	{"sort":6,"interface":"select-dropdown-m2o","special":["m2o"],"collection":"directus_users","field":"videos"}	{"sort":6,"interface":"select-dropdown-m2o","special":["m2o"],"collection":"directus_users","field":"videos"}	\N	\N
635	869	directus_fields	96	{"sort":6,"interface":"collection-item-dropdown","special":["cast-json"],"options":{"selectedCollection":"sexy_videos_directus_users","template":"{{sexy_videos_id.title}}","filter":{"_and":[{"directus_users_id":{"_eq":"$CURRENT_USER"}}]}},"collection":"directus_users","field":"videos"}	{"sort":6,"interface":"collection-item-dropdown","special":["cast-json"],"options":{"selectedCollection":"sexy_videos_directus_users","template":"{{sexy_videos_id.title}}","filter":{"_and":[{"directus_users_id":{"_eq":"$CURRENT_USER"}}]}},"collection":"directus_users","field":"videos"}	\N	\N
636	871	directus_fields	97	{"sort":6,"interface":"list-m2a","special":["m2a"],"collection":"directus_users","field":"videos"}	{"sort":6,"interface":"list-m2a","special":["m2a"],"collection":"directus_users","field":"videos"}	\N	\N
643	889	directus_folders	5f184291-9a58-4914-9756-ad910378bd90	{"id":"5f184291-9a58-4914-9756-ad910378bd90","name":"avatars","parent":"a21e028c-52de-4bc2-8b74-2633194267ab"}	{"parent":"a21e028c-52de-4bc2-8b74-2633194267ab"}	\N	\N
644	890	directus_folders	4cb93083-f3f7-4a61-a80f-d56fd9e6ee62	{"name":"photos","parent":"a21e028c-52de-4bc2-8b74-2633194267ab"}	{"name":"photos","parent":"a21e028c-52de-4bc2-8b74-2633194267ab"}	\N	\N
645	891	directus_fields	102	{"sort":6,"interface":"files","special":["files"],"options":{"filter":{"_and":[{"type":{"_starts_with":"image"}}]},"folder":"c214c905-885b-4d66-a6a1-6527b0606200"},"collection":"directus_users","field":"photos"}	{"sort":6,"interface":"files","special":["files"],"options":{"filter":{"_and":[{"type":{"_starts_with":"image"}}]},"folder":"c214c905-885b-4d66-a6a1-6527b0606200"},"collection":"directus_users","field":"photos"}	\N	\N
646	892	directus_fields	103	{"sort":1,"hidden":true,"field":"id","collection":"junction_directus_users_files"}	{"sort":1,"hidden":true,"field":"id","collection":"junction_directus_users_files"}	\N	\N
647	893	directus_collections	junction_directus_users_files	{"hidden":true,"icon":"import_export","collection":"junction_directus_users_files"}	{"hidden":true,"icon":"import_export","collection":"junction_directus_users_files"}	\N	\N
648	894	directus_fields	104	{"sort":2,"hidden":true,"collection":"junction_directus_users_files","field":"directus_users_id"}	{"sort":2,"hidden":true,"collection":"junction_directus_users_files","field":"directus_users_id"}	\N	\N
649	895	directus_fields	105	{"sort":3,"hidden":true,"collection":"junction_directus_users_files","field":"directus_files_id"}	{"sort":3,"hidden":true,"collection":"junction_directus_users_files","field":"directus_files_id"}	\N	\N
650	896	directus_fields	102	{"id":102,"collection":"directus_users","field":"photos","special":["files"],"interface":"files","options":{"filter":{"_and":[{"type":{"_starts_with":"image"}}]},"folder":"4cb93083-f3f7-4a61-a80f-d56fd9e6ee62"},"display":null,"display_options":null,"readonly":false,"hidden":false,"sort":6,"width":"full","translations":null,"note":null,"conditions":null,"required":false,"group":null,"validation":null,"validation_message":null}	{"collection":"directus_users","field":"photos","options":{"filter":{"_and":[{"type":{"_starts_with":"image"}}]},"folder":"4cb93083-f3f7-4a61-a80f-d56fd9e6ee62"}}	\N	\N
651	897	junction_directus_users_files	1	{"directus_users_id":"4d310101-f7b1-47fe-982a-efe4abf25c55","directus_files_id":{"id":"aaee7bff-e6ce-426c-9abd-8cc11e91de8e"}}	{"directus_users_id":"4d310101-f7b1-47fe-982a-efe4abf25c55","directus_files_id":{"id":"aaee7bff-e6ce-426c-9abd-8cc11e91de8e"}}	\N	\N
652	899	directus_files	498e539a-7c86-44e3-9824-9a5bb0cc979e	{"folder":"4cb93083-f3f7-4a61-a80f-d56fd9e6ee62","title":"Luna Belle 1","filename_download":"luna-belle-1.png","type":"image/png","storage":"local"}	{"folder":"4cb93083-f3f7-4a61-a80f-d56fd9e6ee62","title":"Luna Belle 1","filename_download":"luna-belle-1.png","type":"image/png","storage":"local"}	\N	\N
653	900	directus_files	6435caee-2da5-444a-b378-8c341bba6720	{"folder":"4cb93083-f3f7-4a61-a80f-d56fd9e6ee62","title":"Luna Belle 8","filename_download":"luna-belle-8.png","type":"image/png","storage":"local"}	{"folder":"4cb93083-f3f7-4a61-a80f-d56fd9e6ee62","title":"Luna Belle 8","filename_download":"luna-belle-8.png","type":"image/png","storage":"local"}	\N	\N
654	901	directus_files	9715bf21-05ce-4169-993b-a04edebe29af	{"folder":"4cb93083-f3f7-4a61-a80f-d56fd9e6ee62","title":"Luna Belle 7","filename_download":"luna-belle-7.png","type":"image/png","storage":"local"}	{"folder":"4cb93083-f3f7-4a61-a80f-d56fd9e6ee62","title":"Luna Belle 7","filename_download":"luna-belle-7.png","type":"image/png","storage":"local"}	\N	\N
655	902	directus_files	7779e362-8703-411d-882d-690fd1970566	{"folder":"4cb93083-f3f7-4a61-a80f-d56fd9e6ee62","title":"Luna Belle 6","filename_download":"luna-belle-6.png","type":"image/png","storage":"local"}	{"folder":"4cb93083-f3f7-4a61-a80f-d56fd9e6ee62","title":"Luna Belle 6","filename_download":"luna-belle-6.png","type":"image/png","storage":"local"}	\N	\N
656	903	directus_files	83c90c5c-5877-482c-8043-daa4d28e58de	{"folder":"4cb93083-f3f7-4a61-a80f-d56fd9e6ee62","title":"Luna Belle 5","filename_download":"luna-belle-5.png","type":"image/png","storage":"local"}	{"folder":"4cb93083-f3f7-4a61-a80f-d56fd9e6ee62","title":"Luna Belle 5","filename_download":"luna-belle-5.png","type":"image/png","storage":"local"}	\N	\N
657	904	directus_files	69dfefa0-643d-44cd-8f08-bc68177a38a8	{"folder":"4cb93083-f3f7-4a61-a80f-d56fd9e6ee62","title":"Luna Belle 4","filename_download":"luna-belle-4.png","type":"image/png","storage":"local"}	{"folder":"4cb93083-f3f7-4a61-a80f-d56fd9e6ee62","title":"Luna Belle 4","filename_download":"luna-belle-4.png","type":"image/png","storage":"local"}	\N	\N
658	905	directus_files	318207c2-3846-4383-b0e2-60925992f781	{"folder":"4cb93083-f3f7-4a61-a80f-d56fd9e6ee62","title":"Luna Belle 3","filename_download":"luna-belle-3.png","type":"image/png","storage":"local"}	{"folder":"4cb93083-f3f7-4a61-a80f-d56fd9e6ee62","title":"Luna Belle 3","filename_download":"luna-belle-3.png","type":"image/png","storage":"local"}	\N	\N
659	906	directus_files	4be0073d-a30a-4bd3-937c-4da917f3833f	{"folder":"4cb93083-f3f7-4a61-a80f-d56fd9e6ee62","title":"Luna Belle 2","filename_download":"luna-belle-2.png","type":"image/png","storage":"local"}	{"folder":"4cb93083-f3f7-4a61-a80f-d56fd9e6ee62","title":"Luna Belle 2","filename_download":"luna-belle-2.png","type":"image/png","storage":"local"}	\N	\N
660	907	junction_directus_users_files	2	{"directus_users_id":"543f4d0b-e346-4e5e-8aca-4a9b35d5fab6","directus_files_id":{"id":"498e539a-7c86-44e3-9824-9a5bb0cc979e"}}	{"directus_users_id":"543f4d0b-e346-4e5e-8aca-4a9b35d5fab6","directus_files_id":{"id":"498e539a-7c86-44e3-9824-9a5bb0cc979e"}}	\N	\N
661	908	junction_directus_users_files	3	{"directus_users_id":"543f4d0b-e346-4e5e-8aca-4a9b35d5fab6","directus_files_id":{"id":"6435caee-2da5-444a-b378-8c341bba6720"}}	{"directus_users_id":"543f4d0b-e346-4e5e-8aca-4a9b35d5fab6","directus_files_id":{"id":"6435caee-2da5-444a-b378-8c341bba6720"}}	\N	\N
662	909	junction_directus_users_files	4	{"directus_users_id":"543f4d0b-e346-4e5e-8aca-4a9b35d5fab6","directus_files_id":{"id":"9715bf21-05ce-4169-993b-a04edebe29af"}}	{"directus_users_id":"543f4d0b-e346-4e5e-8aca-4a9b35d5fab6","directus_files_id":{"id":"9715bf21-05ce-4169-993b-a04edebe29af"}}	\N	\N
663	910	junction_directus_users_files	5	{"directus_users_id":"543f4d0b-e346-4e5e-8aca-4a9b35d5fab6","directus_files_id":{"id":"7779e362-8703-411d-882d-690fd1970566"}}	{"directus_users_id":"543f4d0b-e346-4e5e-8aca-4a9b35d5fab6","directus_files_id":{"id":"7779e362-8703-411d-882d-690fd1970566"}}	\N	\N
664	911	junction_directus_users_files	6	{"directus_users_id":"543f4d0b-e346-4e5e-8aca-4a9b35d5fab6","directus_files_id":{"id":"83c90c5c-5877-482c-8043-daa4d28e58de"}}	{"directus_users_id":"543f4d0b-e346-4e5e-8aca-4a9b35d5fab6","directus_files_id":{"id":"83c90c5c-5877-482c-8043-daa4d28e58de"}}	\N	\N
665	912	junction_directus_users_files	7	{"directus_users_id":"543f4d0b-e346-4e5e-8aca-4a9b35d5fab6","directus_files_id":{"id":"69dfefa0-643d-44cd-8f08-bc68177a38a8"}}	{"directus_users_id":"543f4d0b-e346-4e5e-8aca-4a9b35d5fab6","directus_files_id":{"id":"69dfefa0-643d-44cd-8f08-bc68177a38a8"}}	\N	\N
666	913	junction_directus_users_files	8	{"directus_users_id":"543f4d0b-e346-4e5e-8aca-4a9b35d5fab6","directus_files_id":{"id":"318207c2-3846-4383-b0e2-60925992f781"}}	{"directus_users_id":"543f4d0b-e346-4e5e-8aca-4a9b35d5fab6","directus_files_id":{"id":"318207c2-3846-4383-b0e2-60925992f781"}}	\N	\N
667	914	junction_directus_users_files	9	{"directus_users_id":"543f4d0b-e346-4e5e-8aca-4a9b35d5fab6","directus_files_id":{"id":"4be0073d-a30a-4bd3-937c-4da917f3833f"}}	{"directus_users_id":"543f4d0b-e346-4e5e-8aca-4a9b35d5fab6","directus_files_id":{"id":"4be0073d-a30a-4bd3-937c-4da917f3833f"}}	\N	\N
668	916	directus_files	bfe902fa-b686-428f-9bd1-a63aba784034	{"title":"Freepik  Comic Art Graphic Novel Art Comic Illustration Hig  94936","filename_download":"freepik__comic-art-graphic-novel-art-comic-illustration-hig__94936.png","type":"image/png","storage":"local","folder":"c214c905-885b-4d66-a6a1-6527b0606200"}	{"title":"Freepik  Comic Art Graphic Novel Art Comic Illustration Hig  94936","filename_download":"freepik__comic-art-graphic-novel-art-comic-illustration-hig__94936.png","type":"image/png","storage":"local","folder":"c214c905-885b-4d66-a6a1-6527b0606200"}	\N	\N
669	917	directus_files	b85b3008-f592-4676-8c84-666e0a60423d	{"title":"Luna Belle","filename_download":"luna-belle.png","type":"image/png","storage":"local","folder":"c214c905-885b-4d66-a6a1-6527b0606200"}	{"title":"Luna Belle","filename_download":"luna-belle.png","type":"image/png","storage":"local","folder":"c214c905-885b-4d66-a6a1-6527b0606200"}	\N	\N
670	918	directus_users	543f4d0b-e346-4e5e-8aca-4a9b35d5fab6	{"id":"543f4d0b-e346-4e5e-8aca-4a9b35d5fab6","first_name":"Palina","last_name":"Rojinski","email":"palina@pivoine.art","password":"**********","location":null,"title":null,"description":"Award-winning model, dancer and actress with 15+ years of experience.","tags":["Love","Sex","Design","Art"],"avatar":"b85b3008-f592-4676-8c84-666e0a60423d","language":null,"tfa_secret":null,"status":"active","role":"55da25e6-9a87-4264-92e8-9066fdcf9c07","token":null,"last_access":null,"last_page":null,"provider":"default","external_identifier":null,"auth_data":null,"email_notifications":true,"appearance":null,"theme_dark":null,"theme_light":null,"theme_light_overrides":null,"theme_dark_overrides":null,"text_direction":"auto","website":"pivoine.art","slug":"luna-belle","join_date":"2025-09-09T12:00:00","featured":true,"artist_name":"Luna Belle","photos":[2,3,4,5,6,7,8,9],"policies":[]}	{"avatar":"b85b3008-f592-4676-8c84-666e0a60423d"}	\N	\N
671	919	directus_files	2f1293ca-a23e-4f8c-9f11-9ab095c793e1	{"title":"Valknar","filename_download":"valknar.png","type":"image/png","storage":"local","folder":"c214c905-885b-4d66-a6a1-6527b0606200"}	{"title":"Valknar","filename_download":"valknar.png","type":"image/png","storage":"local","folder":"c214c905-885b-4d66-a6a1-6527b0606200"}	\N	\N
672	920	directus_users	4d310101-f7b1-47fe-982a-efe4abf25c55	{"id":"4d310101-f7b1-47fe-982a-efe4abf25c55","first_name":"Sebastian","last_name":"Krüger","email":"valknar@pivoine.art","password":"**********","location":null,"title":null,"description":"Visionary leader with 15+ years in digital media and content creation.","tags":["Love","Sex","Design","Art"],"avatar":"2f1293ca-a23e-4f8c-9f11-9ab095c793e1","language":null,"tfa_secret":null,"status":"active","role":"ea3a9127-2b65-462c-85a8-dbafe9b4fe24","token":null,"last_access":"2025-09-27T18:40:54.010Z","last_page":"/users/4d310101-f7b1-47fe-982a-efe4abf25c55","provider":"default","external_identifier":null,"auth_data":null,"email_notifications":true,"appearance":null,"theme_dark":null,"theme_light":null,"theme_light_overrides":null,"theme_dark_overrides":null,"text_direction":"auto","website":"pivoine.art","slug":"valknar","join_date":"2025-09-09T12:00:00","featured":true,"artist_name":"Valknar","photos":[1],"policies":["b4f61dcc-b54e-4b3e-8a5e-bfbf029f6349","77084e57-682d-43e0-b570-acaf9fe94b1f","21e031ff-632d-46e5-97bb-959a5fef2538"]}	{"avatar":"2f1293ca-a23e-4f8c-9f11-9ab095c793e1"}	\N	\N
673	922	directus_files	b85b3008-f592-4676-8c84-666e0a60423d	{"id":"b85b3008-f592-4676-8c84-666e0a60423d","storage":"local","filename_disk":"b85b3008-f592-4676-8c84-666e0a60423d.png","filename_download":"luna-belle.png","title":"Luna Belle","type":"image/png","folder":"5f184291-9a58-4914-9756-ad910378bd90","uploaded_by":"4d310101-f7b1-47fe-982a-efe4abf25c55","created_on":"2025-09-27T23:28:51.741Z","modified_by":"4d310101-f7b1-47fe-982a-efe4abf25c55","modified_on":"2025-09-27T23:31:04.513Z","charset":null,"filesize":"880827","width":720,"height":720,"duration":null,"embed":null,"description":null,"location":null,"tags":null,"metadata":{},"focal_point_x":null,"focal_point_y":null,"tus_id":null,"tus_data":null,"uploaded_on":"2025-09-27T23:28:51.787Z"}	{"folder":"5f184291-9a58-4914-9756-ad910378bd90","modified_by":"4d310101-f7b1-47fe-982a-efe4abf25c55","modified_on":"2025-09-27T23:31:04.513Z"}	\N	\N
674	926	directus_files	e77c58c1-f718-4b7a-b34c-c42861c8122f	{"folder":"5f184291-9a58-4914-9756-ad910378bd90","title":"Valknar","filename_download":"valknar.png","type":"image/png","storage":"local"}	{"folder":"5f184291-9a58-4914-9756-ad910378bd90","title":"Valknar","filename_download":"valknar.png","type":"image/png","storage":"local"}	\N	\N
675	927	directus_users	4d310101-f7b1-47fe-982a-efe4abf25c55	{"id":"4d310101-f7b1-47fe-982a-efe4abf25c55","first_name":"Sebastian","last_name":"Krüger","email":"valknar@pivoine.art","password":"**********","location":null,"title":null,"description":"Visionary leader with 15+ years in digital media and content creation.","tags":["Love","Sex","Design","Art"],"avatar":"e77c58c1-f718-4b7a-b34c-c42861c8122f","language":null,"tfa_secret":null,"status":"active","role":"ea3a9127-2b65-462c-85a8-dbafe9b4fe24","token":null,"last_access":"2025-09-27T23:30:17.719Z","last_page":"/users/4d310101-f7b1-47fe-982a-efe4abf25c55","provider":"default","external_identifier":null,"auth_data":null,"email_notifications":true,"appearance":null,"theme_dark":null,"theme_light":null,"theme_light_overrides":null,"theme_dark_overrides":null,"text_direction":"auto","website":"pivoine.art","slug":"valknar","join_date":"2025-09-09T12:00:00","featured":true,"artist_name":"Valknar","photos":[1],"policies":["b4f61dcc-b54e-4b3e-8a5e-bfbf029f6349","77084e57-682d-43e0-b570-acaf9fe94b1f","21e031ff-632d-46e5-97bb-959a5fef2538"]}	{"avatar":"e77c58c1-f718-4b7a-b34c-c42861c8122f"}	\N	\N
677	930	directus_permissions	103	{"policy":"f575bea7-7260-4d81-a931-81d762f2b47d","permissions":null,"validation":null,"fields":["*"],"presets":null,"collection":"junction_directus_users_files","action":"read"}	{"policy":"f575bea7-7260-4d81-a931-81d762f2b47d","permissions":null,"validation":null,"fields":["*"],"presets":null,"collection":"junction_directus_users_files","action":"read"}	\N	\N
678	932	directus_folders	9fd092ff-9e7b-48f0-b26c-bcead509ba9e	{"name":"banners","parent":"a21e028c-52de-4bc2-8b74-2633194267ab"}	{"name":"banners","parent":"a21e028c-52de-4bc2-8b74-2633194267ab"}	\N	\N
679	933	directus_fields	106	{"sort":7,"interface":"file-image","special":["file"],"options":{"folder":"9fd092ff-9e7b-48f0-b26c-bcead509ba9e"},"collection":"directus_users","field":"banner"}	{"sort":7,"interface":"file-image","special":["file"],"options":{"folder":"9fd092ff-9e7b-48f0-b26c-bcead509ba9e"},"collection":"directus_users","field":"banner"}	\N	\N
680	934	directus_files	cecf7ce8-388a-43a9-b9bc-2ab4d44d3f7f	{"folder":"9fd092ff-9e7b-48f0-b26c-bcead509ba9e","title":"Luna Belle","filename_download":"luna-belle.png","type":"image/png","storage":"local"}	{"folder":"9fd092ff-9e7b-48f0-b26c-bcead509ba9e","title":"Luna Belle","filename_download":"luna-belle.png","type":"image/png","storage":"local"}	\N	\N
681	935	directus_users	543f4d0b-e346-4e5e-8aca-4a9b35d5fab6	{"id":"543f4d0b-e346-4e5e-8aca-4a9b35d5fab6","first_name":"Palina","last_name":"Rojinski","email":"palina@pivoine.art","password":"**********","location":null,"title":null,"description":"Award-winning model, dancer and actress with 15+ years of experience.","tags":["Love","Sex","Design","Art"],"avatar":"b85b3008-f592-4676-8c84-666e0a60423d","language":null,"tfa_secret":null,"status":"active","role":"55da25e6-9a87-4264-92e8-9066fdcf9c07","token":null,"last_access":null,"last_page":null,"provider":"default","external_identifier":null,"auth_data":null,"email_notifications":true,"appearance":null,"theme_dark":null,"theme_light":null,"theme_light_overrides":null,"theme_dark_overrides":null,"text_direction":"auto","website":"pivoine.art","slug":"luna-belle","join_date":"2025-09-09T12:00:00","featured":true,"artist_name":"Luna Belle","banner":"cecf7ce8-388a-43a9-b9bc-2ab4d44d3f7f","photos":[2,3,4,5,6,7,8,9],"policies":[]}	{"banner":"cecf7ce8-388a-43a9-b9bc-2ab4d44d3f7f"}	\N	\N
682	936	directus_permissions	71	{"id":71,"collection":"directus_users","action":"read","permissions":{"_and":[{"_or":[{"role":{"name":{"_eq":"Model"}}},{"policies":{"policy":{"name":{"_eq":"Model"}}}}]}]},"validation":null,"presets":null,"fields":["username","website","slug","join_date","avatar","featured","location","title","description","tags","policies","role","id","artist_name","last_name","first_name","banner"],"policy":"f575bea7-7260-4d81-a931-81d762f2b47d"}	{"collection":"directus_users","action":"read","permissions":{"_and":[{"_or":[{"role":{"name":{"_eq":"Model"}}},{"policies":{"policy":{"name":{"_eq":"Model"}}}}]}]},"validation":null,"presets":null,"fields":["username","website","slug","join_date","avatar","featured","location","title","description","tags","policies","role","id","artist_name","last_name","first_name","banner"],"policy":"f575bea7-7260-4d81-a931-81d762f2b47d"}	\N	\N
683	939	directus_permissions	104	{"policy":"f575bea7-7260-4d81-a931-81d762f2b47d","permissions":null,"validation":null,"fields":["*"],"presets":null,"collection":"directus_permissions","action":"read"}	{"policy":"f575bea7-7260-4d81-a931-81d762f2b47d","permissions":null,"validation":null,"fields":["*"],"presets":null,"collection":"directus_permissions","action":"read"}	\N	\N
684	942	directus_permissions	105	{"policy":"f575bea7-7260-4d81-a931-81d762f2b47d","permissions":null,"validation":null,"fields":["*"],"presets":null,"collection":"directus_comments","action":"read"}	{"policy":"f575bea7-7260-4d81-a931-81d762f2b47d","permissions":null,"validation":null,"fields":["*"],"presets":null,"collection":"directus_comments","action":"read"}	\N	\N
685	944	directus_permissions	71	{"id":71,"collection":"directus_users","action":"read","permissions":{"_and":[{"_or":[{"role":{"name":{"_eq":"Model"}}},{"policies":{"policy":{"name":{"_eq":"Model"}}}}]}]},"validation":null,"presets":null,"fields":["username","website","slug","join_date","avatar","featured","location","title","description","tags","policies","role","id","artist_name","last_name","first_name","banner","photos"],"policy":"f575bea7-7260-4d81-a931-81d762f2b47d"}	{"collection":"directus_users","action":"read","permissions":{"_and":[{"_or":[{"role":{"name":{"_eq":"Model"}}},{"policies":{"policy":{"name":{"_eq":"Model"}}}}]}]},"validation":null,"presets":null,"fields":["username","website","slug","join_date","avatar","featured","location","title","description","tags","policies","role","id","artist_name","last_name","first_name","banner","photos"],"policy":"f575bea7-7260-4d81-a931-81d762f2b47d"}	\N	\N
686	947	directus_files	d3f53a9b-bbce-436c-a6f4-04e5ef120d7e	{"folder":"9fd092ff-9e7b-48f0-b26c-bcead509ba9e","title":"Valknar","filename_download":"valknar.png","type":"image/png","storage":"local"}	{"folder":"9fd092ff-9e7b-48f0-b26c-bcead509ba9e","title":"Valknar","filename_download":"valknar.png","type":"image/png","storage":"local"}	\N	\N
687	948	directus_users	4d310101-f7b1-47fe-982a-efe4abf25c55	{"id":"4d310101-f7b1-47fe-982a-efe4abf25c55","first_name":"Sebastian","last_name":"Krüger","email":"valknar@pivoine.art","password":"**********","location":null,"title":null,"description":"Visionary leader with 15+ years in digital media and content creation.","tags":["Love","Sex","Design","Art"],"avatar":"e77c58c1-f718-4b7a-b34c-c42861c8122f","language":null,"tfa_secret":null,"status":"active","role":"ea3a9127-2b65-462c-85a8-dbafe9b4fe24","token":null,"last_access":"2025-09-28T01:59:51.920Z","last_page":"/users/4d310101-f7b1-47fe-982a-efe4abf25c55","provider":"default","external_identifier":null,"auth_data":null,"email_notifications":true,"appearance":null,"theme_dark":null,"theme_light":null,"theme_light_overrides":null,"theme_dark_overrides":null,"text_direction":"auto","website":"pivoine.art","slug":"valknar","join_date":"2025-09-09T12:00:00","featured":true,"artist_name":"Valknar","banner":"d3f53a9b-bbce-436c-a6f4-04e5ef120d7e","photos":[],"policies":["b4f61dcc-b54e-4b3e-8a5e-bfbf029f6349","77084e57-682d-43e0-b570-acaf9fe94b1f","21e031ff-632d-46e5-97bb-959a5fef2538"]}	{"banner":"d3f53a9b-bbce-436c-a6f4-04e5ef120d7e"}	\N	\N
688	950	directus_files	3001a83c-3033-4dd1-b3ac-c910bdb1ef2c	{"id":"3001a83c-3033-4dd1-b3ac-c910bdb1ef2c","storage":"local","filename_disk":"3001a83c-3033-4dd1-b3ac-c910bdb1ef2c.mp4","filename_download":"sexybelle.mp4","title":"Sexybelle","type":"video/mp4","folder":"3f83c727-9c90-4e0d-871f-ab81c295043a","uploaded_by":"4d310101-f7b1-47fe-982a-efe4abf25c55","created_on":"2025-09-26T13:56:46.013Z","modified_by":"4d310101-f7b1-47fe-982a-efe4abf25c55","modified_on":"2025-09-28T09:26:43.624Z","charset":null,"filesize":"40114279","width":null,"height":null,"duration":null,"embed":null,"description":null,"location":null,"tags":null,"metadata":null,"focal_point_x":null,"focal_point_y":null,"tus_id":null,"tus_data":null,"uploaded_on":"2025-09-26T13:56:46.815Z"}	{"storage":"local","filename_disk":"3001a83c-3033-4dd1-b3ac-c910bdb1ef2c.mp4","filename_download":"sexybelle.mp4","title":"Sexybelle","type":"video/mp4","folder":"3f83c727-9c90-4e0d-871f-ab81c295043a","description":null,"metadata":null,"modified_by":"4d310101-f7b1-47fe-982a-efe4abf25c55","modified_on":"2025-09-28T09:26:43.624Z"}	\N	\N
689	951	directus_files	3001a83c-3033-4dd1-b3ac-c910bdb1ef2c	{"id":"3001a83c-3033-4dd1-b3ac-c910bdb1ef2c","storage":"local","filename_disk":"3001a83c-3033-4dd1-b3ac-c910bdb1ef2c.mp4","filename_download":"sexybelle.mp4","title":"Sexybelle","type":"video/mp4","folder":"3f83c727-9c90-4e0d-871f-ab81c295043a","uploaded_by":"4d310101-f7b1-47fe-982a-efe4abf25c55","created_on":"2025-09-26T13:56:46.013Z","modified_by":"4d310101-f7b1-47fe-982a-efe4abf25c55","modified_on":"2025-09-28T09:26:43.717Z","charset":null,"filesize":"40114279","width":null,"height":null,"duration":null,"embed":null,"description":null,"location":null,"tags":null,"metadata":null,"focal_point_x":null,"focal_point_y":null,"tus_id":null,"tus_data":null,"uploaded_on":"2025-09-28T09:26:43.687Z"}	{"modified_by":"4d310101-f7b1-47fe-982a-efe4abf25c55","modified_on":"2025-09-28T09:26:43.717Z"}	\N	\N
690	952	directus_files	3001a83c-3033-4dd1-b3ac-c910bdb1ef2c	{"id":"3001a83c-3033-4dd1-b3ac-c910bdb1ef2c","storage":"local","filename_disk":"3001a83c-3033-4dd1-b3ac-c910bdb1ef2c.mp4","filename_download":"sexybelle.mp4","title":"Sexybelle","type":"video/mp4","folder":"3f83c727-9c90-4e0d-871f-ab81c295043a","uploaded_by":"4d310101-f7b1-47fe-982a-efe4abf25c55","created_on":"2025-09-26T13:56:46.013Z","modified_by":"4d310101-f7b1-47fe-982a-efe4abf25c55","modified_on":"2025-09-28T10:53:23.139Z","charset":null,"filesize":"40114279","width":null,"height":null,"duration":null,"embed":null,"description":null,"location":null,"tags":null,"metadata":null,"focal_point_x":null,"focal_point_y":null,"tus_id":null,"tus_data":null,"uploaded_on":"2025-09-28T09:26:43.687Z"}	{"storage":"local","filename_disk":"3001a83c-3033-4dd1-b3ac-c910bdb1ef2c.mp4","filename_download":"sexybelle.mp4","title":"Sexybelle","type":"video/mp4","folder":"3f83c727-9c90-4e0d-871f-ab81c295043a","description":null,"metadata":null,"modified_by":"4d310101-f7b1-47fe-982a-efe4abf25c55","modified_on":"2025-09-28T10:53:23.139Z"}	\N	\N
691	953	directus_files	3001a83c-3033-4dd1-b3ac-c910bdb1ef2c	{"id":"3001a83c-3033-4dd1-b3ac-c910bdb1ef2c","storage":"local","filename_disk":"3001a83c-3033-4dd1-b3ac-c910bdb1ef2c.mp4","filename_download":"sexybelle.mp4","title":"Sexybelle","type":"video/mp4","folder":"3f83c727-9c90-4e0d-871f-ab81c295043a","uploaded_by":"4d310101-f7b1-47fe-982a-efe4abf25c55","created_on":"2025-09-26T13:56:46.013Z","modified_by":"4d310101-f7b1-47fe-982a-efe4abf25c55","modified_on":"2025-09-28T10:53:23.211Z","charset":null,"filesize":"40114279","width":null,"height":null,"duration":null,"embed":null,"description":null,"location":null,"tags":null,"metadata":null,"focal_point_x":null,"focal_point_y":null,"tus_id":null,"tus_data":null,"uploaded_on":"2025-09-28T10:53:23.184Z"}	{"modified_by":"4d310101-f7b1-47fe-982a-efe4abf25c55","modified_on":"2025-09-28T10:53:23.211Z"}	\N	\N
692	954	directus_files	3001a83c-3033-4dd1-b3ac-c910bdb1ef2c	{"id":"3001a83c-3033-4dd1-b3ac-c910bdb1ef2c","storage":"local","filename_disk":"3001a83c-3033-4dd1-b3ac-c910bdb1ef2c.mp4","filename_download":"sexybelle.mp4","title":"Sexybelle","type":"video/mp4","folder":"3f83c727-9c90-4e0d-871f-ab81c295043a","uploaded_by":"4d310101-f7b1-47fe-982a-efe4abf25c55","created_on":"2025-09-26T13:56:46.013Z","modified_by":"4d310101-f7b1-47fe-982a-efe4abf25c55","modified_on":"2025-09-28T10:57:40.360Z","charset":null,"filesize":"40114279","width":null,"height":null,"duration":null,"embed":null,"description":null,"location":null,"tags":null,"metadata":null,"focal_point_x":null,"focal_point_y":null,"tus_id":null,"tus_data":null,"uploaded_on":"2025-09-28T10:53:23.184Z"}	{"storage":"local","filename_disk":"3001a83c-3033-4dd1-b3ac-c910bdb1ef2c.mp4","filename_download":"sexybelle.mp4","title":"Sexybelle","type":"video/mp4","folder":"3f83c727-9c90-4e0d-871f-ab81c295043a","description":null,"metadata":null,"modified_by":"4d310101-f7b1-47fe-982a-efe4abf25c55","modified_on":"2025-09-28T10:57:40.360Z"}	\N	\N
693	955	directus_files	3001a83c-3033-4dd1-b3ac-c910bdb1ef2c	{"id":"3001a83c-3033-4dd1-b3ac-c910bdb1ef2c","storage":"local","filename_disk":"3001a83c-3033-4dd1-b3ac-c910bdb1ef2c.mp4","filename_download":"sexybelle.mp4","title":"Sexybelle","type":"video/mp4","folder":"3f83c727-9c90-4e0d-871f-ab81c295043a","uploaded_by":"4d310101-f7b1-47fe-982a-efe4abf25c55","created_on":"2025-09-26T13:56:46.013Z","modified_by":"4d310101-f7b1-47fe-982a-efe4abf25c55","modified_on":"2025-09-28T10:57:40.393Z","charset":null,"filesize":"40114279","width":null,"height":null,"duration":null,"embed":null,"description":null,"location":null,"tags":null,"metadata":null,"focal_point_x":null,"focal_point_y":null,"tus_id":null,"tus_data":null,"uploaded_on":"2025-09-28T10:57:40.376Z"}	{"modified_by":"4d310101-f7b1-47fe-982a-efe4abf25c55","modified_on":"2025-09-28T10:57:40.393Z"}	\N	\N
694	956	directus_files	3001a83c-3033-4dd1-b3ac-c910bdb1ef2c	{"id":"3001a83c-3033-4dd1-b3ac-c910bdb1ef2c","storage":"local","filename_disk":"3001a83c-3033-4dd1-b3ac-c910bdb1ef2c.mp4","filename_download":"sexybelle.mp4","title":"Sexybelle","type":"video/mp4","folder":"3f83c727-9c90-4e0d-871f-ab81c295043a","uploaded_by":"4d310101-f7b1-47fe-982a-efe4abf25c55","created_on":"2025-09-26T13:56:46.013Z","modified_by":"4d310101-f7b1-47fe-982a-efe4abf25c55","modified_on":"2025-09-28T10:58:52.476Z","charset":null,"filesize":"40114279","width":null,"height":null,"duration":null,"embed":null,"description":null,"location":null,"tags":null,"metadata":null,"focal_point_x":null,"focal_point_y":null,"tus_id":null,"tus_data":null,"uploaded_on":"2025-09-28T10:57:40.376Z"}	{"storage":"local","filename_disk":"3001a83c-3033-4dd1-b3ac-c910bdb1ef2c.mp4","filename_download":"sexybelle.mp4","title":"Sexybelle","type":"video/mp4","folder":"3f83c727-9c90-4e0d-871f-ab81c295043a","description":null,"metadata":null,"modified_by":"4d310101-f7b1-47fe-982a-efe4abf25c55","modified_on":"2025-09-28T10:58:52.476Z"}	\N	\N
695	957	directus_files	3001a83c-3033-4dd1-b3ac-c910bdb1ef2c	{"id":"3001a83c-3033-4dd1-b3ac-c910bdb1ef2c","storage":"local","filename_disk":"3001a83c-3033-4dd1-b3ac-c910bdb1ef2c.mp4","filename_download":"sexybelle.mp4","title":"Sexybelle","type":"video/mp4","folder":"3f83c727-9c90-4e0d-871f-ab81c295043a","uploaded_by":"4d310101-f7b1-47fe-982a-efe4abf25c55","created_on":"2025-09-26T13:56:46.013Z","modified_by":"4d310101-f7b1-47fe-982a-efe4abf25c55","modified_on":"2025-09-28T10:58:52.542Z","charset":null,"filesize":"40114279","width":null,"height":null,"duration":null,"embed":null,"description":null,"location":null,"tags":null,"metadata":null,"focal_point_x":null,"focal_point_y":null,"tus_id":null,"tus_data":null,"uploaded_on":"2025-09-28T10:58:52.512Z"}	{"modified_by":"4d310101-f7b1-47fe-982a-efe4abf25c55","modified_on":"2025-09-28T10:58:52.542Z"}	\N	\N
696	958	directus_files	3001a83c-3033-4dd1-b3ac-c910bdb1ef2c	{"id":"3001a83c-3033-4dd1-b3ac-c910bdb1ef2c","storage":"local","filename_disk":"3001a83c-3033-4dd1-b3ac-c910bdb1ef2c.mp4","filename_download":"sexybelle.mp4","title":"Sexybelle","type":"video/mp4","folder":"3f83c727-9c90-4e0d-871f-ab81c295043a","uploaded_by":"4d310101-f7b1-47fe-982a-efe4abf25c55","created_on":"2025-09-26T13:56:46.013Z","modified_by":"4d310101-f7b1-47fe-982a-efe4abf25c55","modified_on":"2025-09-28T11:09:28.445Z","charset":null,"filesize":"40114279","width":null,"height":null,"duration":null,"embed":null,"description":null,"location":null,"tags":null,"metadata":null,"focal_point_x":null,"focal_point_y":null,"tus_id":null,"tus_data":null,"uploaded_on":"2025-09-28T10:58:52.512Z"}	{"storage":"local","filename_disk":"3001a83c-3033-4dd1-b3ac-c910bdb1ef2c.mp4","filename_download":"sexybelle.mp4","title":"Sexybelle","type":"video/mp4","folder":"3f83c727-9c90-4e0d-871f-ab81c295043a","description":null,"metadata":null,"modified_by":"4d310101-f7b1-47fe-982a-efe4abf25c55","modified_on":"2025-09-28T11:09:28.445Z"}	\N	\N
697	959	directus_files	3001a83c-3033-4dd1-b3ac-c910bdb1ef2c	{"id":"3001a83c-3033-4dd1-b3ac-c910bdb1ef2c","storage":"local","filename_disk":"3001a83c-3033-4dd1-b3ac-c910bdb1ef2c.mp4","filename_download":"sexybelle.mp4","title":"Sexybelle","type":"video/mp4","folder":"3f83c727-9c90-4e0d-871f-ab81c295043a","uploaded_by":"4d310101-f7b1-47fe-982a-efe4abf25c55","created_on":"2025-09-26T13:56:46.013Z","modified_by":"4d310101-f7b1-47fe-982a-efe4abf25c55","modified_on":"2025-09-28T11:09:28.511Z","charset":null,"filesize":"40114279","width":null,"height":null,"duration":null,"embed":null,"description":null,"location":null,"tags":null,"metadata":null,"focal_point_x":null,"focal_point_y":null,"tus_id":null,"tus_data":null,"uploaded_on":"2025-09-28T11:09:28.493Z"}	{"modified_by":"4d310101-f7b1-47fe-982a-efe4abf25c55","modified_on":"2025-09-28T11:09:28.511Z"}	\N	\N
698	960	directus_files	3001a83c-3033-4dd1-b3ac-c910bdb1ef2c	{"id":"3001a83c-3033-4dd1-b3ac-c910bdb1ef2c","storage":"local","filename_disk":"3001a83c-3033-4dd1-b3ac-c910bdb1ef2c.mp4","filename_download":"sexybelle.mp4","title":"Sexybelle","type":"video/mp4","folder":"3f83c727-9c90-4e0d-871f-ab81c295043a","uploaded_by":"4d310101-f7b1-47fe-982a-efe4abf25c55","created_on":"2025-09-26T13:56:46.013Z","modified_by":"4d310101-f7b1-47fe-982a-efe4abf25c55","modified_on":"2025-09-28T11:11:26.275Z","charset":null,"filesize":"40114279","width":null,"height":null,"duration":null,"embed":null,"description":null,"location":null,"tags":null,"metadata":null,"focal_point_x":null,"focal_point_y":null,"tus_id":null,"tus_data":null,"uploaded_on":"2025-09-28T11:09:28.493Z"}	{"storage":"local","filename_disk":"3001a83c-3033-4dd1-b3ac-c910bdb1ef2c.mp4","filename_download":"sexybelle.mp4","title":"Sexybelle","type":"video/mp4","folder":"3f83c727-9c90-4e0d-871f-ab81c295043a","description":null,"metadata":null,"modified_by":"4d310101-f7b1-47fe-982a-efe4abf25c55","modified_on":"2025-09-28T11:11:26.275Z"}	\N	\N
699	961	directus_files	3001a83c-3033-4dd1-b3ac-c910bdb1ef2c	{"id":"3001a83c-3033-4dd1-b3ac-c910bdb1ef2c","storage":"local","filename_disk":"3001a83c-3033-4dd1-b3ac-c910bdb1ef2c.mp4","filename_download":"sexybelle.mp4","title":"Sexybelle","type":"video/mp4","folder":"3f83c727-9c90-4e0d-871f-ab81c295043a","uploaded_by":"4d310101-f7b1-47fe-982a-efe4abf25c55","created_on":"2025-09-26T13:56:46.013Z","modified_by":"4d310101-f7b1-47fe-982a-efe4abf25c55","modified_on":"2025-09-28T11:11:26.343Z","charset":null,"filesize":"40114279","width":null,"height":null,"duration":null,"embed":null,"description":null,"location":null,"tags":null,"metadata":null,"focal_point_x":null,"focal_point_y":null,"tus_id":null,"tus_data":null,"uploaded_on":"2025-09-28T11:11:26.319Z"}	{"modified_by":"4d310101-f7b1-47fe-982a-efe4abf25c55","modified_on":"2025-09-28T11:11:26.343Z"}	\N	\N
700	962	directus_files	3001a83c-3033-4dd1-b3ac-c910bdb1ef2c	{"id":"3001a83c-3033-4dd1-b3ac-c910bdb1ef2c","storage":"local","filename_disk":"3001a83c-3033-4dd1-b3ac-c910bdb1ef2c.mp4","filename_download":"sexybelle.mp4","title":"Sexybelle","type":"video/mp4","folder":"3f83c727-9c90-4e0d-871f-ab81c295043a","uploaded_by":"4d310101-f7b1-47fe-982a-efe4abf25c55","created_on":"2025-09-26T13:56:46.013Z","modified_by":"4d310101-f7b1-47fe-982a-efe4abf25c55","modified_on":"2025-09-28T11:14:28.872Z","charset":null,"filesize":"40114279","width":null,"height":null,"duration":null,"embed":null,"description":null,"location":null,"tags":null,"metadata":null,"focal_point_x":null,"focal_point_y":null,"tus_id":null,"tus_data":null,"uploaded_on":"2025-09-28T11:11:26.319Z"}	{"storage":"local","filename_disk":"3001a83c-3033-4dd1-b3ac-c910bdb1ef2c.mp4","filename_download":"sexybelle.mp4","title":"Sexybelle","type":"video/mp4","folder":"3f83c727-9c90-4e0d-871f-ab81c295043a","description":null,"metadata":null,"modified_by":"4d310101-f7b1-47fe-982a-efe4abf25c55","modified_on":"2025-09-28T11:14:28.872Z"}	\N	\N
701	963	directus_files	3001a83c-3033-4dd1-b3ac-c910bdb1ef2c	{"id":"3001a83c-3033-4dd1-b3ac-c910bdb1ef2c","storage":"local","filename_disk":"3001a83c-3033-4dd1-b3ac-c910bdb1ef2c.mp4","filename_download":"sexybelle.mp4","title":"Sexybelle","type":"video/mp4","folder":"3f83c727-9c90-4e0d-871f-ab81c295043a","uploaded_by":"4d310101-f7b1-47fe-982a-efe4abf25c55","created_on":"2025-09-26T13:56:46.013Z","modified_by":"4d310101-f7b1-47fe-982a-efe4abf25c55","modified_on":"2025-09-28T11:14:28.951Z","charset":null,"filesize":"40114279","width":null,"height":null,"duration":null,"embed":null,"description":null,"location":null,"tags":null,"metadata":null,"focal_point_x":null,"focal_point_y":null,"tus_id":null,"tus_data":null,"uploaded_on":"2025-09-28T11:14:28.944Z"}	{"modified_by":"4d310101-f7b1-47fe-982a-efe4abf25c55","modified_on":"2025-09-28T11:14:28.951Z"}	\N	\N
702	964	directus_files	65637bef-30e5-4605-8d79-59c8814baa40	{"folder":"c214c905-885b-4d66-a6a1-6527b0606200","title":"Sexybelle","filename_download":"sexybelle.mp4","type":"video/mp4","storage":"local"}	{"folder":"c214c905-885b-4d66-a6a1-6527b0606200","title":"Sexybelle","filename_download":"sexybelle.mp4","type":"video/mp4","storage":"local"}	\N	\N
703	965	directus_files	65637bef-30e5-4605-8d79-59c8814baa40	{"id":"65637bef-30e5-4605-8d79-59c8814baa40","storage":"local","filename_disk":"65637bef-30e5-4605-8d79-59c8814baa40.mp4","filename_download":"sexybelle.mp4","title":"Sexybelle","type":"video/mp4","folder":"c214c905-885b-4d66-a6a1-6527b0606200","uploaded_by":"4d310101-f7b1-47fe-982a-efe4abf25c55","created_on":"2025-09-28T11:15:17.162Z","modified_by":"4d310101-f7b1-47fe-982a-efe4abf25c55","modified_on":"2025-09-28T11:18:58.246Z","charset":null,"filesize":"40114279","width":null,"height":null,"duration":null,"embed":null,"description":null,"location":null,"tags":null,"metadata":null,"focal_point_x":null,"focal_point_y":null,"tus_id":null,"tus_data":null,"uploaded_on":"2025-09-28T11:15:17.558Z"}	{"storage":"local","filename_disk":"65637bef-30e5-4605-8d79-59c8814baa40.mp4","filename_download":"sexybelle.mp4","title":"Sexybelle","type":"video/mp4","folder":"c214c905-885b-4d66-a6a1-6527b0606200","description":null,"metadata":null,"modified_by":"4d310101-f7b1-47fe-982a-efe4abf25c55","modified_on":"2025-09-28T11:18:58.246Z"}	\N	\N
743	1008	directus_files	b5c8e028-43c0-4eea-9b69-a3478d3f219b	{"folder":"26657630-d9cd-47a3-9e45-9831f3674f97","title":"Videoframe 0","filename_download":"videoframe_0.png","type":"image/png","storage":"local"}	{"folder":"26657630-d9cd-47a3-9e45-9831f3674f97","title":"Videoframe 0","filename_download":"videoframe_0.png","type":"image/png","storage":"local"}	\N	\N
704	966	directus_files	65637bef-30e5-4605-8d79-59c8814baa40	{"id":"65637bef-30e5-4605-8d79-59c8814baa40","storage":"local","filename_disk":"65637bef-30e5-4605-8d79-59c8814baa40.mp4","filename_download":"sexybelle.mp4","title":"Sexybelle","type":"video/mp4","folder":"c214c905-885b-4d66-a6a1-6527b0606200","uploaded_by":"4d310101-f7b1-47fe-982a-efe4abf25c55","created_on":"2025-09-28T11:15:17.162Z","modified_by":"4d310101-f7b1-47fe-982a-efe4abf25c55","modified_on":"2025-09-28T11:18:58.276Z","charset":null,"filesize":"40114279","width":null,"height":null,"duration":null,"embed":null,"description":null,"location":null,"tags":null,"metadata":null,"focal_point_x":null,"focal_point_y":null,"tus_id":null,"tus_data":null,"uploaded_on":"2025-09-28T11:18:58.273Z"}	{"modified_by":"4d310101-f7b1-47fe-982a-efe4abf25c55","modified_on":"2025-09-28T11:18:58.276Z"}	\N	\N
705	967	directus_files	65637bef-30e5-4605-8d79-59c8814baa40	{"id":"65637bef-30e5-4605-8d79-59c8814baa40","storage":"local","filename_disk":"65637bef-30e5-4605-8d79-59c8814baa40.mp4","filename_download":"sexybelle.mp4","title":"Sexybelle","type":"video/mp4","folder":"c214c905-885b-4d66-a6a1-6527b0606200","uploaded_by":"4d310101-f7b1-47fe-982a-efe4abf25c55","created_on":"2025-09-28T11:15:17.162Z","modified_by":"4d310101-f7b1-47fe-982a-efe4abf25c55","modified_on":"2025-09-28T11:19:21.499Z","charset":null,"filesize":"40114279","width":null,"height":null,"duration":null,"embed":null,"description":null,"location":null,"tags":null,"metadata":null,"focal_point_x":null,"focal_point_y":null,"tus_id":null,"tus_data":null,"uploaded_on":"2025-09-28T11:18:58.273Z"}	{"storage":"local","filename_disk":"65637bef-30e5-4605-8d79-59c8814baa40.mp4","filename_download":"sexybelle.mp4","title":"Sexybelle","type":"video/mp4","folder":"c214c905-885b-4d66-a6a1-6527b0606200","description":null,"metadata":null,"modified_by":"4d310101-f7b1-47fe-982a-efe4abf25c55","modified_on":"2025-09-28T11:19:21.499Z"}	\N	\N
706	968	directus_files	65637bef-30e5-4605-8d79-59c8814baa40	{"id":"65637bef-30e5-4605-8d79-59c8814baa40","storage":"local","filename_disk":"65637bef-30e5-4605-8d79-59c8814baa40.mp4","filename_download":"sexybelle.mp4","title":"Sexybelle","type":"video/mp4","folder":"c214c905-885b-4d66-a6a1-6527b0606200","uploaded_by":"4d310101-f7b1-47fe-982a-efe4abf25c55","created_on":"2025-09-28T11:15:17.162Z","modified_by":"4d310101-f7b1-47fe-982a-efe4abf25c55","modified_on":"2025-09-28T11:19:21.605Z","charset":null,"filesize":"40114279","width":null,"height":null,"duration":null,"embed":null,"description":null,"location":null,"tags":null,"metadata":null,"focal_point_x":null,"focal_point_y":null,"tus_id":null,"tus_data":null,"uploaded_on":"2025-09-28T11:19:21.584Z"}	{"modified_by":"4d310101-f7b1-47fe-982a-efe4abf25c55","modified_on":"2025-09-28T11:19:21.605Z"}	\N	\N
707	969	directus_files	65637bef-30e5-4605-8d79-59c8814baa40	{"id":"65637bef-30e5-4605-8d79-59c8814baa40","storage":"local","filename_disk":"65637bef-30e5-4605-8d79-59c8814baa40.mp4","filename_download":"sexybelle.mp4","title":"Sexybelle","type":"video/mp4","folder":"c214c905-885b-4d66-a6a1-6527b0606200","uploaded_by":"4d310101-f7b1-47fe-982a-efe4abf25c55","created_on":"2025-09-28T11:15:17.162Z","modified_by":"4d310101-f7b1-47fe-982a-efe4abf25c55","modified_on":"2025-09-28T11:34:29.493Z","charset":null,"filesize":"40114279","width":null,"height":null,"duration":null,"embed":null,"description":null,"location":null,"tags":null,"metadata":null,"focal_point_x":null,"focal_point_y":null,"tus_id":null,"tus_data":null,"uploaded_on":"2025-09-28T11:19:21.584Z"}	{"storage":"local","filename_disk":"65637bef-30e5-4605-8d79-59c8814baa40.mp4","filename_download":"sexybelle.mp4","title":"Sexybelle","type":"video/mp4","folder":"c214c905-885b-4d66-a6a1-6527b0606200","description":null,"metadata":null,"modified_by":"4d310101-f7b1-47fe-982a-efe4abf25c55","modified_on":"2025-09-28T11:34:29.493Z"}	\N	\N
708	970	directus_files	65637bef-30e5-4605-8d79-59c8814baa40	{"id":"65637bef-30e5-4605-8d79-59c8814baa40","storage":"local","filename_disk":"65637bef-30e5-4605-8d79-59c8814baa40.mp4","filename_download":"sexybelle.mp4","title":"Sexybelle","type":"video/mp4","folder":"c214c905-885b-4d66-a6a1-6527b0606200","uploaded_by":"4d310101-f7b1-47fe-982a-efe4abf25c55","created_on":"2025-09-28T11:15:17.162Z","modified_by":"4d310101-f7b1-47fe-982a-efe4abf25c55","modified_on":"2025-09-28T11:34:29.576Z","charset":null,"filesize":"40114279","width":null,"height":null,"duration":null,"embed":null,"description":null,"location":null,"tags":null,"metadata":null,"focal_point_x":null,"focal_point_y":null,"tus_id":null,"tus_data":null,"uploaded_on":"2025-09-28T11:34:29.569Z"}	{"modified_by":"4d310101-f7b1-47fe-982a-efe4abf25c55","modified_on":"2025-09-28T11:34:29.576Z"}	\N	\N
709	971	directus_files	65637bef-30e5-4605-8d79-59c8814baa40	{"id":"65637bef-30e5-4605-8d79-59c8814baa40","storage":"local","filename_disk":"65637bef-30e5-4605-8d79-59c8814baa40.mp4","filename_download":"sexybelle.mp4","title":"Sexybelle","type":"video/mp4","folder":"c214c905-885b-4d66-a6a1-6527b0606200","uploaded_by":"4d310101-f7b1-47fe-982a-efe4abf25c55","created_on":"2025-09-28T11:15:17.162Z","modified_by":"4d310101-f7b1-47fe-982a-efe4abf25c55","modified_on":"2025-09-28T11:45:13.439Z","charset":null,"filesize":"40114279","width":null,"height":null,"duration":null,"embed":null,"description":null,"location":null,"tags":null,"metadata":null,"focal_point_x":null,"focal_point_y":null,"tus_id":null,"tus_data":null,"uploaded_on":"2025-09-28T11:34:29.569Z"}	{"storage":"local","filename_disk":"65637bef-30e5-4605-8d79-59c8814baa40.mp4","filename_download":"sexybelle.mp4","title":"Sexybelle","type":"video/mp4","folder":"c214c905-885b-4d66-a6a1-6527b0606200","description":null,"metadata":null,"modified_by":"4d310101-f7b1-47fe-982a-efe4abf25c55","modified_on":"2025-09-28T11:45:13.439Z"}	\N	\N
710	972	directus_files	65637bef-30e5-4605-8d79-59c8814baa40	{"id":"65637bef-30e5-4605-8d79-59c8814baa40","storage":"local","filename_disk":"65637bef-30e5-4605-8d79-59c8814baa40.mp4","filename_download":"sexybelle.mp4","title":"Sexybelle","type":"video/mp4","folder":"c214c905-885b-4d66-a6a1-6527b0606200","uploaded_by":"4d310101-f7b1-47fe-982a-efe4abf25c55","created_on":"2025-09-28T11:15:17.162Z","modified_by":"4d310101-f7b1-47fe-982a-efe4abf25c55","modified_on":"2025-09-28T11:45:13.556Z","charset":null,"filesize":"40114279","width":null,"height":null,"duration":null,"embed":null,"description":null,"location":null,"tags":null,"metadata":null,"focal_point_x":null,"focal_point_y":null,"tus_id":null,"tus_data":null,"uploaded_on":"2025-09-28T11:45:13.541Z"}	{"modified_by":"4d310101-f7b1-47fe-982a-efe4abf25c55","modified_on":"2025-09-28T11:45:13.556Z"}	\N	\N
711	973	directus_files	65637bef-30e5-4605-8d79-59c8814baa40	{"id":"65637bef-30e5-4605-8d79-59c8814baa40","storage":"local","filename_disk":"65637bef-30e5-4605-8d79-59c8814baa40.mp4","filename_download":"sexybelle.mp4","title":"Sexybelle","type":"video/mp4","folder":"c214c905-885b-4d66-a6a1-6527b0606200","uploaded_by":"4d310101-f7b1-47fe-982a-efe4abf25c55","created_on":"2025-09-28T11:15:17.162Z","modified_by":"4d310101-f7b1-47fe-982a-efe4abf25c55","modified_on":"2025-09-28T11:46:08.913Z","charset":null,"filesize":"40114279","width":null,"height":null,"duration":null,"embed":null,"description":null,"location":null,"tags":null,"metadata":null,"focal_point_x":null,"focal_point_y":null,"tus_id":null,"tus_data":null,"uploaded_on":"2025-09-28T11:45:13.541Z"}	{"storage":"local","filename_disk":"65637bef-30e5-4605-8d79-59c8814baa40.mp4","filename_download":"sexybelle.mp4","title":"Sexybelle","type":"video/mp4","folder":"c214c905-885b-4d66-a6a1-6527b0606200","description":null,"metadata":null,"modified_by":"4d310101-f7b1-47fe-982a-efe4abf25c55","modified_on":"2025-09-28T11:46:08.913Z"}	\N	\N
712	974	directus_files	65637bef-30e5-4605-8d79-59c8814baa40	{"id":"65637bef-30e5-4605-8d79-59c8814baa40","storage":"local","filename_disk":"65637bef-30e5-4605-8d79-59c8814baa40.mp4","filename_download":"sexybelle.mp4","title":"Sexybelle","type":"video/mp4","folder":"c214c905-885b-4d66-a6a1-6527b0606200","uploaded_by":"4d310101-f7b1-47fe-982a-efe4abf25c55","created_on":"2025-09-28T11:15:17.162Z","modified_by":"4d310101-f7b1-47fe-982a-efe4abf25c55","modified_on":"2025-09-28T11:46:08.940Z","charset":null,"filesize":"40114279","width":null,"height":null,"duration":null,"embed":null,"description":null,"location":null,"tags":null,"metadata":null,"focal_point_x":null,"focal_point_y":null,"tus_id":null,"tus_data":null,"uploaded_on":"2025-09-28T11:46:08.937Z"}	{"modified_by":"4d310101-f7b1-47fe-982a-efe4abf25c55","modified_on":"2025-09-28T11:46:08.940Z"}	\N	\N
713	975	directus_files	65637bef-30e5-4605-8d79-59c8814baa40	{"id":"65637bef-30e5-4605-8d79-59c8814baa40","storage":"local","filename_disk":"65637bef-30e5-4605-8d79-59c8814baa40.mp4","filename_download":"sexybelle.mp4","title":"Sexybelle","type":"video/mp4","folder":"c214c905-885b-4d66-a6a1-6527b0606200","uploaded_by":"4d310101-f7b1-47fe-982a-efe4abf25c55","created_on":"2025-09-28T11:15:17.162Z","modified_by":"4d310101-f7b1-47fe-982a-efe4abf25c55","modified_on":"2025-09-28T11:46:38.133Z","charset":null,"filesize":"40114279","width":null,"height":null,"duration":null,"embed":null,"description":null,"location":null,"tags":null,"metadata":null,"focal_point_x":null,"focal_point_y":null,"tus_id":null,"tus_data":null,"uploaded_on":"2025-09-28T11:46:08.937Z"}	{"storage":"local","filename_disk":"65637bef-30e5-4605-8d79-59c8814baa40.mp4","filename_download":"sexybelle.mp4","title":"Sexybelle","type":"video/mp4","folder":"c214c905-885b-4d66-a6a1-6527b0606200","description":null,"metadata":null,"modified_by":"4d310101-f7b1-47fe-982a-efe4abf25c55","modified_on":"2025-09-28T11:46:38.133Z"}	\N	\N
714	976	directus_files	65637bef-30e5-4605-8d79-59c8814baa40	{"id":"65637bef-30e5-4605-8d79-59c8814baa40","storage":"local","filename_disk":"65637bef-30e5-4605-8d79-59c8814baa40.mp4","filename_download":"sexybelle.mp4","title":"Sexybelle","type":"video/mp4","folder":"c214c905-885b-4d66-a6a1-6527b0606200","uploaded_by":"4d310101-f7b1-47fe-982a-efe4abf25c55","created_on":"2025-09-28T11:15:17.162Z","modified_by":"4d310101-f7b1-47fe-982a-efe4abf25c55","modified_on":"2025-09-28T11:46:38.177Z","charset":null,"filesize":"40114279","width":null,"height":null,"duration":null,"embed":null,"description":null,"location":null,"tags":null,"metadata":null,"focal_point_x":null,"focal_point_y":null,"tus_id":null,"tus_data":null,"uploaded_on":"2025-09-28T11:46:38.169Z"}	{"modified_by":"4d310101-f7b1-47fe-982a-efe4abf25c55","modified_on":"2025-09-28T11:46:38.177Z"}	\N	\N
715	977	directus_files	65637bef-30e5-4605-8d79-59c8814baa40	{"id":"65637bef-30e5-4605-8d79-59c8814baa40","storage":"local","filename_disk":"65637bef-30e5-4605-8d79-59c8814baa40.mp4","filename_download":"sexybelle.mp4","title":"Sexybelle","type":"video/mp4","folder":"c214c905-885b-4d66-a6a1-6527b0606200","uploaded_by":"4d310101-f7b1-47fe-982a-efe4abf25c55","created_on":"2025-09-28T11:15:17.162Z","modified_by":"4d310101-f7b1-47fe-982a-efe4abf25c55","modified_on":"2025-09-28T11:54:29.811Z","charset":null,"filesize":"40114279","width":null,"height":null,"duration":null,"embed":null,"description":"Sexybelle","location":null,"tags":null,"metadata":null,"focal_point_x":null,"focal_point_y":null,"tus_id":null,"tus_data":null,"uploaded_on":"2025-09-28T11:46:38.169Z"}	{"description":"Sexybelle","modified_by":"4d310101-f7b1-47fe-982a-efe4abf25c55","modified_on":"2025-09-28T11:54:29.811Z"}	\N	\N
716	978	directus_files	65637bef-30e5-4605-8d79-59c8814baa40	{"id":"65637bef-30e5-4605-8d79-59c8814baa40","storage":"local","filename_disk":"65637bef-30e5-4605-8d79-59c8814baa40.mp4","filename_download":"sexybelle.mp4","title":"Sexybelle","type":"video/mp4","folder":"c214c905-885b-4d66-a6a1-6527b0606200","uploaded_by":"4d310101-f7b1-47fe-982a-efe4abf25c55","created_on":"2025-09-28T11:15:17.162Z","modified_by":"4d310101-f7b1-47fe-982a-efe4abf25c55","modified_on":"2025-09-28T11:56:50.803Z","charset":null,"filesize":"40114279","width":null,"height":null,"duration":null,"embed":null,"description":"Sexy","location":null,"tags":null,"metadata":null,"focal_point_x":null,"focal_point_y":null,"tus_id":null,"tus_data":null,"uploaded_on":"2025-09-28T11:46:38.169Z"}	{"description":"Sexy","modified_by":"4d310101-f7b1-47fe-982a-efe4abf25c55","modified_on":"2025-09-28T11:56:50.803Z"}	\N	\N
717	979	sexy_videos	75296c46-3c71-4182-a4ce-416722377d76	{"id":"75296c46-3c71-4182-a4ce-416722377d76","status":"published","user_created":"4d310101-f7b1-47fe-982a-efe4abf25c55","date_created":"2025-09-26T13:56:55.554Z","date_updated":"2025-09-28T12:06:04.000Z","slug":"sexyart-sexybelle","title":"SexyArt / SexyBelle","image":"bab78ff3-10bf-4fc6-9e3a-6e58bb6655b1","upload_date":"2025-09-26T15:48:00","premium":null,"featured":true,"tags":["Funky","Sex","Love","Kiss"],"movie":"3001a83c-3033-4dd1-b3ac-c910bdb1ef2c","description":"Comin' Soon!!!!!!","models":[1,2]}	{"description":"Comin' Soon!!!!!!","date_updated":"2025-09-28T12:06:04.000Z"}	\N	\N
718	980	sexy_videos	75296c46-3c71-4182-a4ce-416722377d76	{"id":"75296c46-3c71-4182-a4ce-416722377d76","status":"published","user_created":"4d310101-f7b1-47fe-982a-efe4abf25c55","date_created":"2025-09-26T13:56:55.554Z","date_updated":"2025-09-28T12:12:35.860Z","slug":"sexyart-sexybelle","title":"SexyArt / SexyBelle","image":"bab78ff3-10bf-4fc6-9e3a-6e58bb6655b1","upload_date":"2025-09-26T15:48:00","premium":null,"featured":true,"tags":["Funky","Sex","Love","Kiss"],"movie":"3001a83c-3033-4dd1-b3ac-c910bdb1ef2c","description":"Comin' Soon!!!!!!!","models":[1,2]}	{"description":"Comin' Soon!!!!!!!","date_updated":"2025-09-28T12:12:35.860Z"}	\N	\N
719	981	sexy_videos	75296c46-3c71-4182-a4ce-416722377d76	{"id":"75296c46-3c71-4182-a4ce-416722377d76","status":"published","user_created":"4d310101-f7b1-47fe-982a-efe4abf25c55","date_created":"2025-09-26T13:56:55.554Z","date_updated":"2025-09-28T12:14:28.729Z","slug":"sexyart-sexybelle","title":"SexyArt / SexyBelle","image":"bab78ff3-10bf-4fc6-9e3a-6e58bb6655b1","upload_date":"2025-09-26T15:48:00","premium":null,"featured":true,"tags":["Funky","Sex","Love","Kiss"],"movie":"3001a83c-3033-4dd1-b3ac-c910bdb1ef2c","description":"Comin' Soon!!!!!!","models":[1,2]}	{"description":"Comin' Soon!!!!!!","date_updated":"2025-09-28T12:14:28.729Z"}	\N	\N
720	982	sexy_videos	75296c46-3c71-4182-a4ce-416722377d76	{"id":"75296c46-3c71-4182-a4ce-416722377d76","status":"published","user_created":"4d310101-f7b1-47fe-982a-efe4abf25c55","date_created":"2025-09-26T13:56:55.554Z","date_updated":"2025-09-28T12:15:55.864Z","slug":"sexyart-sexybelle","title":"SexyArt / SexyBelle","image":"bab78ff3-10bf-4fc6-9e3a-6e58bb6655b1","upload_date":"2025-09-26T15:48:00","premium":null,"featured":true,"tags":["Funky","Sex","Love","Kiss"],"movie":"3001a83c-3033-4dd1-b3ac-c910bdb1ef2c","description":"Comin' Soon!!!!!!!","models":[1,2]}	{"description":"Comin' Soon!!!!!!!","date_updated":"2025-09-28T12:15:55.864Z"}	\N	\N
744	1009	directus_files	009f5bad-9a8a-401e-9cb1-5792fa41337f	{"folder":"3f83c727-9c90-4e0d-871f-ab81c295043a","title":"Sexy Art   in the Opera","filename_download":"SexyArt - In The Opera.mp4","type":"video/mp4","storage":"local"}	{"folder":"3f83c727-9c90-4e0d-871f-ab81c295043a","title":"Sexy Art   in the Opera","filename_download":"SexyArt - In The Opera.mp4","type":"video/mp4","storage":"local"}	\N	\N
721	983	sexy_videos	75296c46-3c71-4182-a4ce-416722377d76	{"id":"75296c46-3c71-4182-a4ce-416722377d76","status":"published","user_created":"4d310101-f7b1-47fe-982a-efe4abf25c55","date_created":"2025-09-26T13:56:55.554Z","date_updated":"2025-09-28T12:20:08.730Z","slug":"sexyart-sexybelle","title":"SexyArt / SexyBelle","image":"bab78ff3-10bf-4fc6-9e3a-6e58bb6655b1","upload_date":"2025-09-26T15:48:00","premium":null,"featured":true,"tags":["Funky","Sex","Love","Kiss"],"movie":"3001a83c-3033-4dd1-b3ac-c910bdb1ef2c","description":"Comin' Soon!!!!!!","models":[1,2]}	{"description":"Comin' Soon!!!!!!","date_updated":"2025-09-28T12:20:08.730Z"}	\N	\N
722	984	directus_files	65637bef-30e5-4605-8d79-59c8814baa40	{"id":"65637bef-30e5-4605-8d79-59c8814baa40","storage":"local","filename_disk":"65637bef-30e5-4605-8d79-59c8814baa40.mp4","filename_download":"sexybelle.mp4","title":"Sexybelle","type":"video/mp4","folder":"c214c905-885b-4d66-a6a1-6527b0606200","uploaded_by":"4d310101-f7b1-47fe-982a-efe4abf25c55","created_on":"2025-09-28T11:15:17.162Z","modified_by":"4d310101-f7b1-47fe-982a-efe4abf25c55","modified_on":"2025-09-28T12:40:09.613Z","charset":null,"filesize":"40114279","width":null,"height":null,"duration":null,"embed":null,"description":"Sexy","location":null,"tags":null,"metadata":null,"focal_point_x":null,"focal_point_y":null,"tus_id":null,"tus_data":null,"uploaded_on":"2025-09-28T11:46:38.169Z"}	{"storage":"local","filename_disk":"65637bef-30e5-4605-8d79-59c8814baa40.mp4","filename_download":"sexybelle.mp4","title":"Sexybelle","type":"video/mp4","folder":"c214c905-885b-4d66-a6a1-6527b0606200","description":"Sexy","metadata":null,"modified_by":"4d310101-f7b1-47fe-982a-efe4abf25c55","modified_on":"2025-09-28T12:40:09.613Z"}	\N	\N
723	985	directus_files	65637bef-30e5-4605-8d79-59c8814baa40	{"id":"65637bef-30e5-4605-8d79-59c8814baa40","storage":"local","filename_disk":"65637bef-30e5-4605-8d79-59c8814baa40.mp4","filename_download":"sexybelle.mp4","title":"Sexybelle","type":"video/mp4","folder":"c214c905-885b-4d66-a6a1-6527b0606200","uploaded_by":"4d310101-f7b1-47fe-982a-efe4abf25c55","created_on":"2025-09-28T11:15:17.162Z","modified_by":"4d310101-f7b1-47fe-982a-efe4abf25c55","modified_on":"2025-09-28T12:40:09.652Z","charset":null,"filesize":"40114279","width":null,"height":null,"duration":null,"embed":null,"description":"Sexy","location":null,"tags":null,"metadata":null,"focal_point_x":null,"focal_point_y":null,"tus_id":null,"tus_data":null,"uploaded_on":"2025-09-28T12:40:09.640Z"}	{"modified_by":"4d310101-f7b1-47fe-982a-efe4abf25c55","modified_on":"2025-09-28T12:40:09.652Z"}	\N	\N
724	986	directus_files	65637bef-30e5-4605-8d79-59c8814baa40	{"id":"65637bef-30e5-4605-8d79-59c8814baa40","storage":"local","filename_disk":"65637bef-30e5-4605-8d79-59c8814baa40.mp4","filename_download":"sexybelle.mp4","title":"Sexybelle","type":"video/mp4","folder":"c214c905-885b-4d66-a6a1-6527b0606200","uploaded_by":"4d310101-f7b1-47fe-982a-efe4abf25c55","created_on":"2025-09-28T11:15:17.162Z","modified_by":"4d310101-f7b1-47fe-982a-efe4abf25c55","modified_on":"2025-09-28T13:44:04.205Z","charset":null,"filesize":"40114279","width":null,"height":null,"duration":null,"embed":null,"description":"Sexy","location":null,"tags":null,"metadata":null,"focal_point_x":null,"focal_point_y":null,"tus_id":null,"tus_data":null,"uploaded_on":"2025-09-28T12:40:09.640Z"}	{"storage":"local","filename_disk":"65637bef-30e5-4605-8d79-59c8814baa40.mp4","filename_download":"sexybelle.mp4","title":"Sexybelle","type":"video/mp4","folder":"c214c905-885b-4d66-a6a1-6527b0606200","description":"Sexy","metadata":null,"modified_by":"4d310101-f7b1-47fe-982a-efe4abf25c55","modified_on":"2025-09-28T13:44:04.205Z"}	\N	\N
725	987	directus_files	65637bef-30e5-4605-8d79-59c8814baa40	{"id":"65637bef-30e5-4605-8d79-59c8814baa40","storage":"local","filename_disk":"65637bef-30e5-4605-8d79-59c8814baa40.mp4","filename_download":"sexybelle.mp4","title":"Sexybelle","type":"video/mp4","folder":"c214c905-885b-4d66-a6a1-6527b0606200","uploaded_by":"4d310101-f7b1-47fe-982a-efe4abf25c55","created_on":"2025-09-28T11:15:17.162Z","modified_by":"4d310101-f7b1-47fe-982a-efe4abf25c55","modified_on":"2025-09-28T13:44:04.320Z","charset":null,"filesize":"40114279","width":null,"height":null,"duration":null,"embed":null,"description":"Sexy","location":null,"tags":null,"metadata":null,"focal_point_x":null,"focal_point_y":null,"tus_id":null,"tus_data":null,"uploaded_on":"2025-09-28T13:44:04.295Z"}	{"modified_by":"4d310101-f7b1-47fe-982a-efe4abf25c55","modified_on":"2025-09-28T13:44:04.320Z"}	\N	\N
726	988	directus_files	65637bef-30e5-4605-8d79-59c8814baa40	{"id":"65637bef-30e5-4605-8d79-59c8814baa40","storage":"local","filename_disk":"65637bef-30e5-4605-8d79-59c8814baa40.mp4","filename_download":"sexybelle.mp4","title":"Sexybelle","type":"video/mp4","folder":"c214c905-885b-4d66-a6a1-6527b0606200","uploaded_by":"4d310101-f7b1-47fe-982a-efe4abf25c55","created_on":"2025-09-28T11:15:17.162Z","modified_by":"4d310101-f7b1-47fe-982a-efe4abf25c55","modified_on":"2025-09-28T13:45:20.288Z","charset":null,"filesize":"40114279","width":null,"height":null,"duration":null,"embed":null,"description":"Sexy","location":null,"tags":null,"metadata":null,"focal_point_x":null,"focal_point_y":null,"tus_id":null,"tus_data":null,"uploaded_on":"2025-09-28T13:44:04.295Z"}	{"storage":"local","filename_disk":"65637bef-30e5-4605-8d79-59c8814baa40.mp4","filename_download":"sexybelle.mp4","title":"Sexybelle","type":"video/mp4","folder":"c214c905-885b-4d66-a6a1-6527b0606200","description":"Sexy","metadata":null,"modified_by":"4d310101-f7b1-47fe-982a-efe4abf25c55","modified_on":"2025-09-28T13:45:20.288Z"}	\N	\N
727	989	directus_files	65637bef-30e5-4605-8d79-59c8814baa40	{"id":"65637bef-30e5-4605-8d79-59c8814baa40","storage":"local","filename_disk":"65637bef-30e5-4605-8d79-59c8814baa40.mp4","filename_download":"sexybelle.mp4","title":"Sexybelle","type":"video/mp4","folder":"c214c905-885b-4d66-a6a1-6527b0606200","uploaded_by":"4d310101-f7b1-47fe-982a-efe4abf25c55","created_on":"2025-09-28T11:15:17.162Z","modified_by":"4d310101-f7b1-47fe-982a-efe4abf25c55","modified_on":"2025-09-28T13:45:20.360Z","charset":null,"filesize":"40114279","width":null,"height":null,"duration":null,"embed":null,"description":"Sexy","location":null,"tags":null,"metadata":null,"focal_point_x":null,"focal_point_y":null,"tus_id":null,"tus_data":null,"uploaded_on":"2025-09-28T13:45:20.348Z"}	{"modified_by":"4d310101-f7b1-47fe-982a-efe4abf25c55","modified_on":"2025-09-28T13:45:20.360Z"}	\N	\N
728	990	directus_files	65637bef-30e5-4605-8d79-59c8814baa40	{"id":"65637bef-30e5-4605-8d79-59c8814baa40","storage":"local","filename_disk":"65637bef-30e5-4605-8d79-59c8814baa40.mp4","filename_download":"sexybelle.mp4","title":"Sexybelle","type":"video/mp4","folder":"c214c905-885b-4d66-a6a1-6527b0606200","uploaded_by":"4d310101-f7b1-47fe-982a-efe4abf25c55","created_on":"2025-09-28T11:15:17.162Z","modified_by":"4d310101-f7b1-47fe-982a-efe4abf25c55","modified_on":"2025-09-28T13:46:45.726Z","charset":null,"filesize":"40114279","width":null,"height":null,"duration":null,"embed":null,"description":"Sexy","location":null,"tags":null,"metadata":null,"focal_point_x":null,"focal_point_y":null,"tus_id":null,"tus_data":null,"uploaded_on":"2025-09-28T13:45:20.348Z"}	{"storage":"local","filename_disk":"65637bef-30e5-4605-8d79-59c8814baa40.mp4","filename_download":"sexybelle.mp4","title":"Sexybelle","type":"video/mp4","folder":"c214c905-885b-4d66-a6a1-6527b0606200","description":"Sexy","metadata":null,"modified_by":"4d310101-f7b1-47fe-982a-efe4abf25c55","modified_on":"2025-09-28T13:46:45.726Z"}	\N	\N
729	991	directus_files	65637bef-30e5-4605-8d79-59c8814baa40	{"id":"65637bef-30e5-4605-8d79-59c8814baa40","storage":"local","filename_disk":"65637bef-30e5-4605-8d79-59c8814baa40.mp4","filename_download":"sexybelle.mp4","title":"Sexybelle","type":"video/mp4","folder":"c214c905-885b-4d66-a6a1-6527b0606200","uploaded_by":"4d310101-f7b1-47fe-982a-efe4abf25c55","created_on":"2025-09-28T11:15:17.162Z","modified_by":"4d310101-f7b1-47fe-982a-efe4abf25c55","modified_on":"2025-09-28T13:46:45.818Z","charset":null,"filesize":"40114279","width":null,"height":null,"duration":null,"embed":null,"description":"Sexy","location":null,"tags":null,"metadata":null,"focal_point_x":null,"focal_point_y":null,"tus_id":null,"tus_data":null,"uploaded_on":"2025-09-28T13:46:45.805Z"}	{"modified_by":"4d310101-f7b1-47fe-982a-efe4abf25c55","modified_on":"2025-09-28T13:46:45.818Z"}	\N	\N
730	992	directus_files	65637bef-30e5-4605-8d79-59c8814baa40	{"id":"65637bef-30e5-4605-8d79-59c8814baa40","storage":"local","filename_disk":"65637bef-30e5-4605-8d79-59c8814baa40.mp4","filename_download":"sexybelle.mp4","title":"Sexybelle","type":"video/mp4","folder":"c214c905-885b-4d66-a6a1-6527b0606200","uploaded_by":"4d310101-f7b1-47fe-982a-efe4abf25c55","created_on":"2025-09-28T11:15:17.162Z","modified_by":"4d310101-f7b1-47fe-982a-efe4abf25c55","modified_on":"2025-09-28T13:49:54.250Z","charset":null,"filesize":"40114279","width":null,"height":null,"duration":null,"embed":null,"description":"Sexy","location":null,"tags":null,"metadata":null,"focal_point_x":null,"focal_point_y":null,"tus_id":null,"tus_data":null,"uploaded_on":"2025-09-28T13:46:45.805Z"}	{"storage":"local","filename_disk":"65637bef-30e5-4605-8d79-59c8814baa40.mp4","filename_download":"sexybelle.mp4","title":"Sexybelle","type":"video/mp4","folder":"c214c905-885b-4d66-a6a1-6527b0606200","description":"Sexy","metadata":null,"modified_by":"4d310101-f7b1-47fe-982a-efe4abf25c55","modified_on":"2025-09-28T13:49:54.250Z"}	\N	\N
731	993	directus_files	65637bef-30e5-4605-8d79-59c8814baa40	{"id":"65637bef-30e5-4605-8d79-59c8814baa40","storage":"local","filename_disk":"65637bef-30e5-4605-8d79-59c8814baa40.mp4","filename_download":"sexybelle.mp4","title":"Sexybelle","type":"video/mp4","folder":"c214c905-885b-4d66-a6a1-6527b0606200","uploaded_by":"4d310101-f7b1-47fe-982a-efe4abf25c55","created_on":"2025-09-28T11:15:17.162Z","modified_by":"4d310101-f7b1-47fe-982a-efe4abf25c55","modified_on":"2025-09-28T13:49:54.331Z","charset":null,"filesize":"40114279","width":null,"height":null,"duration":null,"embed":null,"description":"Sexy","location":null,"tags":null,"metadata":null,"focal_point_x":null,"focal_point_y":null,"tus_id":null,"tus_data":null,"uploaded_on":"2025-09-28T13:49:54.315Z"}	{"modified_by":"4d310101-f7b1-47fe-982a-efe4abf25c55","modified_on":"2025-09-28T13:49:54.331Z"}	\N	\N
732	994	directus_files	65637bef-30e5-4605-8d79-59c8814baa40	{"id":"65637bef-30e5-4605-8d79-59c8814baa40","storage":"local","filename_disk":"65637bef-30e5-4605-8d79-59c8814baa40.mp4","filename_download":"sexybelle.mp4","title":"Sexybelle","type":"video/mp4","folder":"c214c905-885b-4d66-a6a1-6527b0606200","uploaded_by":"4d310101-f7b1-47fe-982a-efe4abf25c55","created_on":"2025-09-28T11:15:17.162Z","modified_by":"4d310101-f7b1-47fe-982a-efe4abf25c55","modified_on":"2025-09-28T13:51:31.753Z","charset":null,"filesize":"40114279","width":null,"height":null,"duration":null,"embed":null,"description":"Sexy","location":null,"tags":null,"metadata":null,"focal_point_x":null,"focal_point_y":null,"tus_id":null,"tus_data":null,"uploaded_on":"2025-09-28T13:49:54.315Z"}	{"storage":"local","filename_disk":"65637bef-30e5-4605-8d79-59c8814baa40.mp4","filename_download":"sexybelle.mp4","title":"Sexybelle","type":"video/mp4","folder":"c214c905-885b-4d66-a6a1-6527b0606200","description":"Sexy","metadata":null,"modified_by":"4d310101-f7b1-47fe-982a-efe4abf25c55","modified_on":"2025-09-28T13:51:31.753Z"}	\N	\N
733	995	directus_files	65637bef-30e5-4605-8d79-59c8814baa40	{"id":"65637bef-30e5-4605-8d79-59c8814baa40","storage":"local","filename_disk":"65637bef-30e5-4605-8d79-59c8814baa40.mp4","filename_download":"sexybelle.mp4","title":"Sexybelle","type":"video/mp4","folder":"c214c905-885b-4d66-a6a1-6527b0606200","uploaded_by":"4d310101-f7b1-47fe-982a-efe4abf25c55","created_on":"2025-09-28T11:15:17.162Z","modified_by":"4d310101-f7b1-47fe-982a-efe4abf25c55","modified_on":"2025-09-28T13:51:31.807Z","charset":null,"filesize":"40114279","width":null,"height":null,"duration":null,"embed":null,"description":"Sexy","location":null,"tags":null,"metadata":null,"focal_point_x":null,"focal_point_y":null,"tus_id":null,"tus_data":null,"uploaded_on":"2025-09-28T13:51:31.786Z"}	{"modified_by":"4d310101-f7b1-47fe-982a-efe4abf25c55","modified_on":"2025-09-28T13:51:31.807Z"}	\N	\N
734	996	directus_files	65637bef-30e5-4605-8d79-59c8814baa40	{"id":"65637bef-30e5-4605-8d79-59c8814baa40","storage":"local","filename_disk":"65637bef-30e5-4605-8d79-59c8814baa40.mp4","filename_download":"sexybelle.mp4","title":"Sexybelle","type":"video/mp4","folder":"c214c905-885b-4d66-a6a1-6527b0606200","uploaded_by":"4d310101-f7b1-47fe-982a-efe4abf25c55","created_on":"2025-09-28T11:15:17.162Z","modified_by":"4d310101-f7b1-47fe-982a-efe4abf25c55","modified_on":"2025-09-28T13:52:27.551Z","charset":null,"filesize":"40114279","width":null,"height":null,"duration":null,"embed":null,"description":"Sexy","location":null,"tags":null,"metadata":null,"focal_point_x":null,"focal_point_y":null,"tus_id":null,"tus_data":null,"uploaded_on":"2025-09-28T13:51:31.786Z"}	{"storage":"local","filename_disk":"65637bef-30e5-4605-8d79-59c8814baa40.mp4","filename_download":"sexybelle.mp4","title":"Sexybelle","type":"video/mp4","folder":"c214c905-885b-4d66-a6a1-6527b0606200","description":"Sexy","metadata":null,"modified_by":"4d310101-f7b1-47fe-982a-efe4abf25c55","modified_on":"2025-09-28T13:52:27.551Z"}	\N	\N
735	997	directus_files	65637bef-30e5-4605-8d79-59c8814baa40	{"id":"65637bef-30e5-4605-8d79-59c8814baa40","storage":"local","filename_disk":"65637bef-30e5-4605-8d79-59c8814baa40.mp4","filename_download":"sexybelle.mp4","title":"Sexybelle","type":"video/mp4","folder":"c214c905-885b-4d66-a6a1-6527b0606200","uploaded_by":"4d310101-f7b1-47fe-982a-efe4abf25c55","created_on":"2025-09-28T11:15:17.162Z","modified_by":"4d310101-f7b1-47fe-982a-efe4abf25c55","modified_on":"2025-09-28T13:52:27.587Z","charset":null,"filesize":"40114279","width":null,"height":null,"duration":null,"embed":null,"description":"Sexy","location":null,"tags":null,"metadata":null,"focal_point_x":null,"focal_point_y":null,"tus_id":null,"tus_data":null,"uploaded_on":"2025-09-28T13:52:27.581Z"}	{"modified_by":"4d310101-f7b1-47fe-982a-efe4abf25c55","modified_on":"2025-09-28T13:52:27.587Z"}	\N	\N
736	998	directus_files	65637bef-30e5-4605-8d79-59c8814baa40	{"id":"65637bef-30e5-4605-8d79-59c8814baa40","storage":"local","filename_disk":"65637bef-30e5-4605-8d79-59c8814baa40.mp4","filename_download":"sexybelle.mp4","title":"Sexybelle","type":"video/mp4","folder":"c214c905-885b-4d66-a6a1-6527b0606200","uploaded_by":"4d310101-f7b1-47fe-982a-efe4abf25c55","created_on":"2025-09-28T11:15:17.162Z","modified_by":"4d310101-f7b1-47fe-982a-efe4abf25c55","modified_on":"2025-09-28T13:53:35.455Z","charset":null,"filesize":"40114279","width":null,"height":null,"duration":null,"embed":null,"description":"Sexy","location":null,"tags":null,"metadata":null,"focal_point_x":null,"focal_point_y":null,"tus_id":null,"tus_data":null,"uploaded_on":"2025-09-28T13:52:27.581Z"}	{"storage":"local","filename_disk":"65637bef-30e5-4605-8d79-59c8814baa40.mp4","filename_download":"sexybelle.mp4","title":"Sexybelle","type":"video/mp4","folder":"c214c905-885b-4d66-a6a1-6527b0606200","description":"Sexy","metadata":null,"modified_by":"4d310101-f7b1-47fe-982a-efe4abf25c55","modified_on":"2025-09-28T13:53:35.455Z"}	\N	\N
737	999	directus_files	65637bef-30e5-4605-8d79-59c8814baa40	{"id":"65637bef-30e5-4605-8d79-59c8814baa40","storage":"local","filename_disk":"65637bef-30e5-4605-8d79-59c8814baa40.mp4","filename_download":"sexybelle.mp4","title":"Sexybelle","type":"video/mp4","folder":"c214c905-885b-4d66-a6a1-6527b0606200","uploaded_by":"4d310101-f7b1-47fe-982a-efe4abf25c55","created_on":"2025-09-28T11:15:17.162Z","modified_by":"4d310101-f7b1-47fe-982a-efe4abf25c55","modified_on":"2025-09-28T13:53:35.515Z","charset":null,"filesize":"40114279","width":null,"height":null,"duration":null,"embed":null,"description":"Sexy","location":null,"tags":null,"metadata":null,"focal_point_x":null,"focal_point_y":null,"tus_id":null,"tus_data":null,"uploaded_on":"2025-09-28T13:53:35.492Z"}	{"modified_by":"4d310101-f7b1-47fe-982a-efe4abf25c55","modified_on":"2025-09-28T13:53:35.515Z"}	\N	\N
738	1000	directus_files	65637bef-30e5-4605-8d79-59c8814baa40	{"id":"65637bef-30e5-4605-8d79-59c8814baa40","storage":"local","filename_disk":"65637bef-30e5-4605-8d79-59c8814baa40.mp4","filename_download":"sexybelle.mp4","title":"Sexybelle","type":"video/mp4","folder":"c214c905-885b-4d66-a6a1-6527b0606200","uploaded_by":"4d310101-f7b1-47fe-982a-efe4abf25c55","created_on":"2025-09-28T11:15:17.162Z","modified_by":"4d310101-f7b1-47fe-982a-efe4abf25c55","modified_on":"2025-09-28T13:53:35.685Z","charset":null,"filesize":"40114279","width":null,"height":null,"duration":18,"embed":null,"description":"Sexy","location":null,"tags":null,"metadata":null,"focal_point_x":null,"focal_point_y":null,"tus_id":null,"tus_data":null,"uploaded_on":"2025-09-28T13:53:35.492Z"}	{"duration":18,"modified_by":"4d310101-f7b1-47fe-982a-efe4abf25c55","modified_on":"2025-09-28T13:53:35.685Z"}	\N	\N
739	1002	directus_files	3001a83c-3033-4dd1-b3ac-c910bdb1ef2c	{"id":"3001a83c-3033-4dd1-b3ac-c910bdb1ef2c","storage":"local","filename_disk":"3001a83c-3033-4dd1-b3ac-c910bdb1ef2c.mp4","filename_download":"sexybelle.mp4","title":"Sexybelle","type":"video/mp4","folder":"3f83c727-9c90-4e0d-871f-ab81c295043a","uploaded_by":"4d310101-f7b1-47fe-982a-efe4abf25c55","created_on":"2025-09-26T13:56:46.013Z","modified_by":"4d310101-f7b1-47fe-982a-efe4abf25c55","modified_on":"2025-09-28T13:54:25.740Z","charset":null,"filesize":"40114279","width":null,"height":null,"duration":null,"embed":null,"description":null,"location":null,"tags":null,"metadata":null,"focal_point_x":null,"focal_point_y":null,"tus_id":null,"tus_data":null,"uploaded_on":"2025-09-28T11:14:28.944Z"}	{"storage":"local","filename_disk":"3001a83c-3033-4dd1-b3ac-c910bdb1ef2c.mp4","filename_download":"sexybelle.mp4","title":"Sexybelle","type":"video/mp4","folder":"3f83c727-9c90-4e0d-871f-ab81c295043a","description":null,"metadata":null,"modified_by":"4d310101-f7b1-47fe-982a-efe4abf25c55","modified_on":"2025-09-28T13:54:25.740Z"}	\N	\N
740	1003	directus_files	3001a83c-3033-4dd1-b3ac-c910bdb1ef2c	{"id":"3001a83c-3033-4dd1-b3ac-c910bdb1ef2c","storage":"local","filename_disk":"3001a83c-3033-4dd1-b3ac-c910bdb1ef2c.mp4","filename_download":"sexybelle.mp4","title":"Sexybelle","type":"video/mp4","folder":"3f83c727-9c90-4e0d-871f-ab81c295043a","uploaded_by":"4d310101-f7b1-47fe-982a-efe4abf25c55","created_on":"2025-09-26T13:56:46.013Z","modified_by":"4d310101-f7b1-47fe-982a-efe4abf25c55","modified_on":"2025-09-28T13:54:25.798Z","charset":null,"filesize":"40114279","width":null,"height":null,"duration":null,"embed":null,"description":null,"location":null,"tags":null,"metadata":null,"focal_point_x":null,"focal_point_y":null,"tus_id":null,"tus_data":null,"uploaded_on":"2025-09-28T13:54:25.774Z"}	{"modified_by":"4d310101-f7b1-47fe-982a-efe4abf25c55","modified_on":"2025-09-28T13:54:25.798Z"}	\N	\N
741	1004	directus_files	3001a83c-3033-4dd1-b3ac-c910bdb1ef2c	{"id":"3001a83c-3033-4dd1-b3ac-c910bdb1ef2c","storage":"local","filename_disk":"3001a83c-3033-4dd1-b3ac-c910bdb1ef2c.mp4","filename_download":"sexybelle.mp4","title":"Sexybelle","type":"video/mp4","folder":"3f83c727-9c90-4e0d-871f-ab81c295043a","uploaded_by":"4d310101-f7b1-47fe-982a-efe4abf25c55","created_on":"2025-09-26T13:56:46.013Z","modified_by":"4d310101-f7b1-47fe-982a-efe4abf25c55","modified_on":"2025-09-28T13:54:25.924Z","charset":null,"filesize":"40114279","width":null,"height":null,"duration":18,"embed":null,"description":null,"location":null,"tags":null,"metadata":null,"focal_point_x":null,"focal_point_y":null,"tus_id":null,"tus_data":null,"uploaded_on":"2025-09-28T13:54:25.774Z"}	{"duration":18,"modified_by":"4d310101-f7b1-47fe-982a-efe4abf25c55","modified_on":"2025-09-28T13:54:25.924Z"}	\N	\N
746	1011	sexy_videos	299cf96a-8cfc-43d4-81a9-41c5f327808f	{"slug":"sexyart-in-the-opera","title":"SexyArt - In The Opera","models":{"create":[{"sexy_videos_id":"+","directus_users_id":{"id":"543f4d0b-e346-4e5e-8aca-4a9b35d5fab6"}}],"update":[],"delete":[]},"upload_date":"2025-10-08T04:09:37","featured":true,"tags":["Matrue","Love","Sex","Music"],"image":"b5c8e028-43c0-4eea-9b69-a3478d3f219b","movie":"009f5bad-9a8a-401e-9cb1-5792fa41337f","status":"published","description":"Mit Gewitter und Sturm aus fernem Meer -\\nMein Mädel, bin dir nah'! Hurrah!\\nHurrah! Über turmhohe Flut vom Süden her\\nMein Mädel, ich bin da! Hurrah!\\nMein Mädel, wenn nicht Südwind wär\\nIch nimmer wohl käm' zu dir;\\nAch lieber Südwind, blas' noch mehr\\nMein Mädel verlangt nach mir . ."}	{"slug":"sexyart-in-the-opera","title":"SexyArt - In The Opera","models":{"create":[{"sexy_videos_id":"+","directus_users_id":{"id":"543f4d0b-e346-4e5e-8aca-4a9b35d5fab6"}}],"update":[],"delete":[]},"upload_date":"2025-10-08T04:09:37","featured":true,"tags":["Matrue","Love","Sex","Music"],"image":"b5c8e028-43c0-4eea-9b69-a3478d3f219b","movie":"009f5bad-9a8a-401e-9cb1-5792fa41337f","status":"published","description":"Mit Gewitter und Sturm aus fernem Meer -\\nMein Mädel, bin dir nah'! Hurrah!\\nHurrah! Über turmhohe Flut vom Süden her\\nMein Mädel, ich bin da! Hurrah!\\nMein Mädel, wenn nicht Südwind wär\\nIch nimmer wohl käm' zu dir;\\nAch lieber Südwind, blas' noch mehr\\nMein Mädel verlangt nach mir . ."}	\N	\N
745	1010	sexy_videos_directus_users	3	{"sexy_videos_id":"299cf96a-8cfc-43d4-81a9-41c5f327808f","directus_users_id":{"id":"543f4d0b-e346-4e5e-8aca-4a9b35d5fab6"}}	{"sexy_videos_id":"299cf96a-8cfc-43d4-81a9-41c5f327808f","directus_users_id":{"id":"543f4d0b-e346-4e5e-8aca-4a9b35d5fab6"}}	746	\N
747	1012	sexy_videos	75296c46-3c71-4182-a4ce-416722377d76	{"id":"75296c46-3c71-4182-a4ce-416722377d76","status":"published","user_created":"4d310101-f7b1-47fe-982a-efe4abf25c55","date_created":"2025-09-26T13:56:55.554Z","date_updated":"2025-10-08T02:21:11.727Z","slug":"sexyart-sexybelle","title":"SexyArt - SexyBelle","image":"bab78ff3-10bf-4fc6-9e3a-6e58bb6655b1","upload_date":"2025-09-26T15:48:00","premium":null,"featured":true,"tags":["Funky","Sex","Love","Kiss"],"movie":"3001a83c-3033-4dd1-b3ac-c910bdb1ef2c","description":"Comin' Soon!!!!!!","models":[1,2]}	{"title":"SexyArt - SexyBelle","date_updated":"2025-10-08T02:21:11.727Z"}	\N	\N
748	1014	sexy_videos	299cf96a-8cfc-43d4-81a9-41c5f327808f	{"id":"299cf96a-8cfc-43d4-81a9-41c5f327808f","status":"published","user_created":"4d310101-f7b1-47fe-982a-efe4abf25c55","date_created":"2025-10-08T02:21:02.825Z","date_updated":"2025-10-08T02:24:35.625Z","slug":"sexyart-in-the-opera","title":"SexyArt - In The Opera","image":"b5c8e028-43c0-4eea-9b69-a3478d3f219b","upload_date":"2025-10-08T00:24:00","premium":null,"featured":true,"tags":["Matrue","Love","Sex","Music"],"movie":"009f5bad-9a8a-401e-9cb1-5792fa41337f","description":"Mit Gewitter und Sturm aus fernem Meer -\\nMein Mädel, bin dir nah'! Hurrah!\\nHurrah! Über turmhohe Flut vom Süden her\\nMein Mädel, ich bin da! Hurrah!\\nMein Mädel, wenn nicht Südwind wär\\nIch nimmer wohl käm' zu dir;\\nAch lieber Südwind, blas' noch mehr\\nMein Mädel verlangt nach mir . .","models":[3]}	{"upload_date":"2025-10-08T00:24:00","date_updated":"2025-10-08T02:24:35.625Z"}	\N	\N
749	1015	sexy_videos	299cf96a-8cfc-43d4-81a9-41c5f327808f	{"id":"299cf96a-8cfc-43d4-81a9-41c5f327808f","status":"published","user_created":"4d310101-f7b1-47fe-982a-efe4abf25c55","date_created":"2025-10-08T02:21:02.825Z","date_updated":"2025-10-08T02:30:35.159Z","slug":"sexyart-in-the-opera","title":"SexyArt - In The Opera","image":"b5c8e028-43c0-4eea-9b69-a3478d3f219b","upload_date":"2025-10-08T00:24:00","premium":null,"featured":true,"tags":["Mature","Sex","Love","Music"],"movie":"009f5bad-9a8a-401e-9cb1-5792fa41337f","description":"Mit Gewitter und Sturm aus fernem Meer -\\nMein Mädel, bin dir nah'! Hurrah!\\nHurrah! Über turmhohe Flut vom Süden her\\nMein Mädel, ich bin da! Hurrah!\\nMein Mädel, wenn nicht Südwind wär\\nIch nimmer wohl käm' zu dir;\\nAch lieber Südwind, blas' noch mehr\\nMein Mädel verlangt nach mir . .","models":[3]}	{"tags":["Mature","Sex","Love","Music"],"date_updated":"2025-10-08T02:30:35.159Z"}	\N	\N
\.


--
-- Data for Name: directus_roles; Type: TABLE DATA; Schema: public; Owner: valknar
--

COPY public.directus_roles (id, name, icon, description, parent) FROM stdin;
ea3a9127-2b65-462c-85a8-dbafe9b4fe24	Administrator	verified	$t:admin_description	\N
a1300aaa-0205-47d8-97a7-6166ac924e50	Viewer	eyeglasses	As viewer is capable of watching videos, he paid for.	\N
f1d1d90f-9a4a-4199-bc70-f9cd3cccd99f	Editor	ink_pen	As an editor i can write magazine articles.	\N
55da25e6-9a87-4264-92e8-9066fdcf9c07	Model	missed_video_call	A creator is capable of creating videos by uploading them.	\N
\.


--
-- Data for Name: directus_sessions; Type: TABLE DATA; Schema: public; Owner: valknar
--

COPY public.directus_sessions (token, "user", expires, ip, user_agent, share, origin, next_token) FROM stdin;
ddBPC9NlSVdcSd1e0MlpauKlSqWW4Ki0o7zBs6ARgs1DPwAqgH3fnb-vq4lmN8i-	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-10-08 02:37:30.447+00	78.51.149.168	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	\N	https://sexy.pivoine.art	DQbJhWgTzIR68ja4Yd1PcvaxL58dYryZNdNWwtxLHvLhrgolFe8KutlGz-D3xxr2
DQbJhWgTzIR68ja4Yd1PcvaxL58dYryZNdNWwtxLHvLhrgolFe8KutlGz-D3xxr2	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-10-09 02:37:20.447+00	78.51.149.168	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	\N	https://sexy.pivoine.art	\N
\.


--
-- Data for Name: directus_settings; Type: TABLE DATA; Schema: public; Owner: valknar
--

COPY public.directus_settings (id, project_name, project_url, project_color, project_logo, public_foreground, public_background, public_note, auth_login_attempts, auth_password_policy, storage_asset_transform, storage_asset_presets, custom_css, storage_default_folder, basemaps, mapbox_key, module_bar, project_descriptor, default_language, custom_aspect_ratios, public_favicon, default_appearance, default_theme_light, theme_light_overrides, default_theme_dark, theme_dark_overrides, report_error_url, report_bug_url, report_feature_url, public_registration, public_registration_verify_email, public_registration_role, public_registration_email_filter, visual_editor_urls, accepted_terms, project_id, mcp_enabled, mcp_allow_deletes, mcp_prompts_collection, mcp_system_prompt_enabled, mcp_system_prompt) FROM stdin;
1	Sexy.Art	https://sexy.pivoine.art	#CE47EB	8ad7e858-0c83-4d88-bb50-3680f1cfa9c2	\N	\N	Where Love Meets Artistry	25	/^.{8,}$/	presets	[{"key":"mini","fit":"cover","width":300,"height":300,"quality":80,"withoutEnlargement":false,"format":"webp","transforms":[]},{"key":"preview","fit":"cover","width":600,"height":400,"quality":80,"withoutEnlargement":false,"format":"webp","transforms":[]},{"key":"medium","fit":"cover","width":1200,"height":900,"quality":80,"withoutEnlargement":false,"format":"webp","transforms":[]},{"key":"banner","fit":"cover","width":2000,"height":1000,"quality":80,"withoutEnlargement":false,"format":"webp","transforms":[]},{"key":"thumbnail","fit":"cover","width":600,"height":600,"quality":80,"withoutEnlargement":false,"format":"webp","transforms":[]}]	\N	c214c905-885b-4d66-a6a1-6527b0606200	\N	\N	[{"type":"module","id":"content","enabled":true},{"type":"module","id":"visual","enabled":false},{"type":"module","id":"users","enabled":true},{"type":"module","id":"files","enabled":true},{"type":"module","id":"insights","enabled":true},{"type":"link","id":"docs","enabled":true,"name":"$t:documentation","icon":"help","url":"https://docs.directus.io"},{"type":"module","id":"settings","enabled":true,"locked":true}]	Where Love Meets Artistry	en-US	\N	0a509923-853d-44e7-ad76-b6e6bdf89ba5	auto	\N	\N	@sexy.pivoine.art/theme	\N	\N	\N	\N	t	t	a1300aaa-0205-47d8-97a7-6166ac924e50	\N	\N	t	01991b80-eceb-7715-aebb-b0b1fbf67973	f	f	\N	t	\N
\.


--
-- Data for Name: directus_shares; Type: TABLE DATA; Schema: public; Owner: valknar
--

COPY public.directus_shares (id, name, collection, item, role, password, user_created, date_created, date_start, date_end, times_used, max_uses) FROM stdin;
\.


--
-- Data for Name: directus_translations; Type: TABLE DATA; Schema: public; Owner: valknar
--

COPY public.directus_translations (id, language, key, value) FROM stdin;
\.


--
-- Data for Name: directus_users; Type: TABLE DATA; Schema: public; Owner: valknar
--

COPY public.directus_users (id, first_name, last_name, email, password, location, title, description, tags, avatar, language, tfa_secret, status, role, token, last_access, last_page, provider, external_identifier, auth_data, email_notifications, appearance, theme_dark, theme_light, theme_light_overrides, theme_dark_overrides, text_direction, website, slug, join_date, featured, artist_name, banner) FROM stdin;
543f4d0b-e346-4e5e-8aca-4a9b35d5fab6	Palina	Rojinski	palina@pivoine.art	$argon2id$v=19$m=65536,t=3,p=4$ad2kKJ4YUQwjIpPCN/CdhQ$LwyZbpm0bx+p49y9x02UFNI4GepTW4vIrFaN3tuIs0E	\N	\N	Award-winning model, dancer and actress with 15+ years of experience.	["Love","Sex","Design","Art"]	b85b3008-f592-4676-8c84-666e0a60423d	\N	\N	active	55da25e6-9a87-4264-92e8-9066fdcf9c07	\N	\N	\N	default	\N	\N	t	\N	\N	\N	\N	\N	auto	pivoine.art	luna-belle	2025-09-09 12:00:00	t	Luna Belle	cecf7ce8-388a-43a9-b9bc-2ab4d44d3f7f
4d310101-f7b1-47fe-982a-efe4abf25c55	Sebastian	Krüger	valknar@pivoine.art	$argon2id$v=19$m=65536,t=3,p=4$vtigbG/p86I0WqpqZviaLA$V6BYW2C9h8t/IMVIS26fIAwO4J1zTCoLM71NoiVduKw	\N	\N	Visionary leader with 15+ years in digital media and content creation.	["Love","Sex","Design","Art"]	e77c58c1-f718-4b7a-b34c-c42861c8122f	\N	\N	active	ea3a9127-2b65-462c-85a8-dbafe9b4fe24	\N	2025-10-08 02:37:20.451+00	/content/sexy_videos	default	\N	\N	t	\N	\N	\N	\N	\N	auto	pivoine.art	valknar	2025-09-09 12:00:00	t	Valknar	d3f53a9b-bbce-436c-a6f4-04e5ef120d7e
\.


--
-- Data for Name: directus_versions; Type: TABLE DATA; Schema: public; Owner: valknar
--

COPY public.directus_versions (id, key, name, collection, item, hash, date_created, date_updated, user_created, user_updated, delta) FROM stdin;
\.


--
-- Data for Name: directus_webhooks; Type: TABLE DATA; Schema: public; Owner: valknar
--

COPY public.directus_webhooks (id, name, method, url, status, data, actions, collections, headers, was_active_before_deprecation, migrated_flow) FROM stdin;
\.


--
-- Data for Name: junction_directus_users_files; Type: TABLE DATA; Schema: public; Owner: valknar
--

COPY public.junction_directus_users_files (id, directus_users_id, directus_files_id) FROM stdin;
2	543f4d0b-e346-4e5e-8aca-4a9b35d5fab6	498e539a-7c86-44e3-9824-9a5bb0cc979e
3	543f4d0b-e346-4e5e-8aca-4a9b35d5fab6	6435caee-2da5-444a-b378-8c341bba6720
4	543f4d0b-e346-4e5e-8aca-4a9b35d5fab6	9715bf21-05ce-4169-993b-a04edebe29af
5	543f4d0b-e346-4e5e-8aca-4a9b35d5fab6	7779e362-8703-411d-882d-690fd1970566
6	543f4d0b-e346-4e5e-8aca-4a9b35d5fab6	83c90c5c-5877-482c-8043-daa4d28e58de
7	543f4d0b-e346-4e5e-8aca-4a9b35d5fab6	69dfefa0-643d-44cd-8f08-bc68177a38a8
8	543f4d0b-e346-4e5e-8aca-4a9b35d5fab6	318207c2-3846-4383-b0e2-60925992f781
9	543f4d0b-e346-4e5e-8aca-4a9b35d5fab6	4be0073d-a30a-4bd3-937c-4da917f3833f
1	\N	\N
\.


--
-- Data for Name: sexy_articles; Type: TABLE DATA; Schema: public; Owner: valknar
--

COPY public.sexy_articles (id, status, user_created, date_created, date_updated, slug, title, excerpt, content, image, tags, publish_date, category, featured, author) FROM stdin;
327b53b3-1a3b-4859-bcc6-2e831e3d9b62	published	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-08 19:51:34.582+00	2025-09-08 21:28:48.422+00	model-spotlight-luna-belle	Model Spotlight: Luna Belle's Creative Journey	Discover how Luna Belle combines artistic vision with intimate expression to create captivating content.	<p>Intimate photography is more than just capturing moments&mdash;it's about telling stories of love, connection, and vulnerability through the lens. In this comprehensive guide, we'll explore the artistic and technical aspects that make intimate photography truly captivating.</p>\n<h2>Understanding the Art Form</h2>\n<p>Intimate photography requires a delicate balance between technical skill and emotional intelligence. The photographer must create an environment where subjects feel comfortable, safe, and free to express their authentic selves.</p>\n<p>The key to successful intimate photography lies in building trust with your subjects. This trust allows for genuine moments of vulnerability and connection that translate beautifully through the camera.</p>\n<h2>Technical Considerations</h2>\n<p>While the emotional aspect is crucial, technical proficiency cannot be overlooked. Here are some essential technical considerations:</p>\n<h3>Lighting</h3>\n<p>Natural light is often the most flattering for intimate photography. Golden hour provides warm, soft light that enhances skin tones and creates a romantic atmosphere. When shooting indoors, large windows provide beautiful, diffused light.</p>\n<h3>Composition</h3>\n<p>Composition in intimate photography should guide the viewer's eye to the emotional core of the image. Use leading lines, framing, and negative space to create visual interest while maintaining focus on the connection between subjects.</p>\n<h2>Creating the Right Environment</h2>\n<p>The environment plays a crucial role in intimate photography. Whether shooting in a studio, bedroom, or outdoor location, the space should feel safe and comfortable for your subjects.</p>\n<p>Consider the following when preparing your shooting environment:</p>\n<ul>\n<li>Ensure privacy and minimize distractions</li>\n<li>Maintain comfortable temperature</li>\n<li>Have robes or coverings readily available</li>\n<li>Play soft, ambient music to help subjects relax</li>\n</ul>\n<h2>Posing and Direction</h2>\n<p>Posing for intimate photography should feel natural and unforced. Instead of rigid poses, encourage movement and interaction between subjects. Guide them through emotions rather than specific positions.</p>\n<p>Some effective directing techniques include:</p>\n<ul>\n<li>Ask subjects to whisper something sweet to each other</li>\n<li>Encourage gentle touches and caresses</li>\n<li>Capture moments between poses</li>\n<li>Focus on hands, eyes, and subtle expressions</li>\n</ul>\n<h2>Post-Processing for Intimate Photography</h2>\n<p>Post-processing should enhance the mood and emotion of your intimate photographs without overwhelming the natural beauty of the moment. Subtle adjustments to exposure, contrast, and color grading can significantly impact the final result.</p>\n<p>Consider these post-processing tips:</p>\n<ul>\n<li>Maintain natural skin tones</li>\n<li>Use subtle vignetting to draw focus</li>\n<li>Enhance the warmth of the lighting</li>\n<li>Remove distracting elements carefully</li>\n</ul>\n<h2>Conclusion</h2>\n<p>Intimate photography is a beautiful art form that celebrates human connection and vulnerability. By combining technical skill with emotional intelligence, photographers can create images that not only capture moments but also tell powerful stories of love and intimacy.</p>\n<p>Remember, the most important aspect of intimate photography is respect&mdash;for your subjects, for the art form, and for the trust that has been placed in you as the photographer.</p>	f718185e-fd82-4f16-971d-88baf2d069de	["Creativity","Journey"]	2025-09-04 12:00:00	Spotlight	f	4d310101-f7b1-47fe-982a-efe4abf25c55
\.


--
-- Data for Name: sexy_videos; Type: TABLE DATA; Schema: public; Owner: valknar
--

COPY public.sexy_videos (id, status, user_created, date_created, date_updated, slug, title, image, upload_date, premium, featured, tags, movie, description) FROM stdin;
75296c46-3c71-4182-a4ce-416722377d76	published	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-09-26 13:56:55.554+00	2025-10-08 02:21:11.727+00	sexyart-sexybelle	SexyArt - SexyBelle	bab78ff3-10bf-4fc6-9e3a-6e58bb6655b1	2025-09-26 15:48:00	\N	t	["Funky","Sex","Love","Kiss"]	3001a83c-3033-4dd1-b3ac-c910bdb1ef2c	Comin' Soon!!!!!!
299cf96a-8cfc-43d4-81a9-41c5f327808f	published	4d310101-f7b1-47fe-982a-efe4abf25c55	2025-10-08 02:21:02.825+00	2025-10-08 02:30:35.159+00	sexyart-in-the-opera	SexyArt - In The Opera	b5c8e028-43c0-4eea-9b69-a3478d3f219b	2025-10-08 00:24:00	\N	t	["Mature","Sex","Love","Music"]	009f5bad-9a8a-401e-9cb1-5792fa41337f	Mit Gewitter und Sturm aus fernem Meer -\nMein Mädel, bin dir nah'! Hurrah!\nHurrah! Über turmhohe Flut vom Süden her\nMein Mädel, ich bin da! Hurrah!\nMein Mädel, wenn nicht Südwind wär\nIch nimmer wohl käm' zu dir;\nAch lieber Südwind, blas' noch mehr\nMein Mädel verlangt nach mir . .
\.


--
-- Data for Name: sexy_videos_directus_users; Type: TABLE DATA; Schema: public; Owner: valknar
--

COPY public.sexy_videos_directus_users (id, sexy_videos_id, directus_users_id) FROM stdin;
1	75296c46-3c71-4182-a4ce-416722377d76	543f4d0b-e346-4e5e-8aca-4a9b35d5fab6
2	75296c46-3c71-4182-a4ce-416722377d76	4d310101-f7b1-47fe-982a-efe4abf25c55
3	299cf96a-8cfc-43d4-81a9-41c5f327808f	543f4d0b-e346-4e5e-8aca-4a9b35d5fab6
\.


--
-- Name: directus_activity_id_seq; Type: SEQUENCE SET; Schema: public; Owner: valknar
--

SELECT pg_catalog.setval('public.directus_activity_id_seq', 1015, true);


--
-- Name: directus_fields_id_seq; Type: SEQUENCE SET; Schema: public; Owner: valknar
--

SELECT pg_catalog.setval('public.directus_fields_id_seq', 106, true);


--
-- Name: directus_notifications_id_seq; Type: SEQUENCE SET; Schema: public; Owner: valknar
--

SELECT pg_catalog.setval('public.directus_notifications_id_seq', 1, false);


--
-- Name: directus_permissions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: valknar
--

SELECT pg_catalog.setval('public.directus_permissions_id_seq', 105, true);


--
-- Name: directus_presets_id_seq; Type: SEQUENCE SET; Schema: public; Owner: valknar
--

SELECT pg_catalog.setval('public.directus_presets_id_seq', 6, true);


--
-- Name: directus_relations_id_seq; Type: SEQUENCE SET; Schema: public; Owner: valknar
--

SELECT pg_catalog.setval('public.directus_relations_id_seq', 27, true);


--
-- Name: directus_revisions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: valknar
--

SELECT pg_catalog.setval('public.directus_revisions_id_seq', 749, true);


--
-- Name: directus_settings_id_seq; Type: SEQUENCE SET; Schema: public; Owner: valknar
--

SELECT pg_catalog.setval('public.directus_settings_id_seq', 1, true);


--
-- Name: directus_webhooks_id_seq; Type: SEQUENCE SET; Schema: public; Owner: valknar
--

SELECT pg_catalog.setval('public.directus_webhooks_id_seq', 1, false);


--
-- Name: junction_directus_users_files_id_seq; Type: SEQUENCE SET; Schema: public; Owner: valknar
--

SELECT pg_catalog.setval('public.junction_directus_users_files_id_seq', 9, true);


--
-- Name: sexy_videos_directus_users_id_seq; Type: SEQUENCE SET; Schema: public; Owner: valknar
--

SELECT pg_catalog.setval('public.sexy_videos_directus_users_id_seq', 3, true);


--
-- Name: directus_access directus_access_pkey; Type: CONSTRAINT; Schema: public; Owner: valknar
--

ALTER TABLE ONLY public.directus_access
    ADD CONSTRAINT directus_access_pkey PRIMARY KEY (id);


--
-- Name: directus_activity directus_activity_pkey; Type: CONSTRAINT; Schema: public; Owner: valknar
--

ALTER TABLE ONLY public.directus_activity
    ADD CONSTRAINT directus_activity_pkey PRIMARY KEY (id);


--
-- Name: directus_collections directus_collections_pkey; Type: CONSTRAINT; Schema: public; Owner: valknar
--

ALTER TABLE ONLY public.directus_collections
    ADD CONSTRAINT directus_collections_pkey PRIMARY KEY (collection);


--
-- Name: directus_comments directus_comments_pkey; Type: CONSTRAINT; Schema: public; Owner: valknar
--

ALTER TABLE ONLY public.directus_comments
    ADD CONSTRAINT directus_comments_pkey PRIMARY KEY (id);


--
-- Name: directus_dashboards directus_dashboards_pkey; Type: CONSTRAINT; Schema: public; Owner: valknar
--

ALTER TABLE ONLY public.directus_dashboards
    ADD CONSTRAINT directus_dashboards_pkey PRIMARY KEY (id);


--
-- Name: directus_extensions directus_extensions_pkey; Type: CONSTRAINT; Schema: public; Owner: valknar
--

ALTER TABLE ONLY public.directus_extensions
    ADD CONSTRAINT directus_extensions_pkey PRIMARY KEY (id);


--
-- Name: directus_fields directus_fields_pkey; Type: CONSTRAINT; Schema: public; Owner: valknar
--

ALTER TABLE ONLY public.directus_fields
    ADD CONSTRAINT directus_fields_pkey PRIMARY KEY (id);


--
-- Name: directus_files directus_files_pkey; Type: CONSTRAINT; Schema: public; Owner: valknar
--

ALTER TABLE ONLY public.directus_files
    ADD CONSTRAINT directus_files_pkey PRIMARY KEY (id);


--
-- Name: directus_flows directus_flows_operation_unique; Type: CONSTRAINT; Schema: public; Owner: valknar
--

ALTER TABLE ONLY public.directus_flows
    ADD CONSTRAINT directus_flows_operation_unique UNIQUE (operation);


--
-- Name: directus_flows directus_flows_pkey; Type: CONSTRAINT; Schema: public; Owner: valknar
--

ALTER TABLE ONLY public.directus_flows
    ADD CONSTRAINT directus_flows_pkey PRIMARY KEY (id);


--
-- Name: directus_folders directus_folders_pkey; Type: CONSTRAINT; Schema: public; Owner: valknar
--

ALTER TABLE ONLY public.directus_folders
    ADD CONSTRAINT directus_folders_pkey PRIMARY KEY (id);


--
-- Name: directus_migrations directus_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: valknar
--

ALTER TABLE ONLY public.directus_migrations
    ADD CONSTRAINT directus_migrations_pkey PRIMARY KEY (version);


--
-- Name: directus_notifications directus_notifications_pkey; Type: CONSTRAINT; Schema: public; Owner: valknar
--

ALTER TABLE ONLY public.directus_notifications
    ADD CONSTRAINT directus_notifications_pkey PRIMARY KEY (id);


--
-- Name: directus_operations directus_operations_pkey; Type: CONSTRAINT; Schema: public; Owner: valknar
--

ALTER TABLE ONLY public.directus_operations
    ADD CONSTRAINT directus_operations_pkey PRIMARY KEY (id);


--
-- Name: directus_operations directus_operations_reject_unique; Type: CONSTRAINT; Schema: public; Owner: valknar
--

ALTER TABLE ONLY public.directus_operations
    ADD CONSTRAINT directus_operations_reject_unique UNIQUE (reject);


--
-- Name: directus_operations directus_operations_resolve_unique; Type: CONSTRAINT; Schema: public; Owner: valknar
--

ALTER TABLE ONLY public.directus_operations
    ADD CONSTRAINT directus_operations_resolve_unique UNIQUE (resolve);


--
-- Name: directus_panels directus_panels_pkey; Type: CONSTRAINT; Schema: public; Owner: valknar
--

ALTER TABLE ONLY public.directus_panels
    ADD CONSTRAINT directus_panels_pkey PRIMARY KEY (id);


--
-- Name: directus_permissions directus_permissions_pkey; Type: CONSTRAINT; Schema: public; Owner: valknar
--

ALTER TABLE ONLY public.directus_permissions
    ADD CONSTRAINT directus_permissions_pkey PRIMARY KEY (id);


--
-- Name: directus_policies directus_policies_pkey; Type: CONSTRAINT; Schema: public; Owner: valknar
--

ALTER TABLE ONLY public.directus_policies
    ADD CONSTRAINT directus_policies_pkey PRIMARY KEY (id);


--
-- Name: directus_presets directus_presets_pkey; Type: CONSTRAINT; Schema: public; Owner: valknar
--

ALTER TABLE ONLY public.directus_presets
    ADD CONSTRAINT directus_presets_pkey PRIMARY KEY (id);


--
-- Name: directus_relations directus_relations_pkey; Type: CONSTRAINT; Schema: public; Owner: valknar
--

ALTER TABLE ONLY public.directus_relations
    ADD CONSTRAINT directus_relations_pkey PRIMARY KEY (id);


--
-- Name: directus_revisions directus_revisions_pkey; Type: CONSTRAINT; Schema: public; Owner: valknar
--

ALTER TABLE ONLY public.directus_revisions
    ADD CONSTRAINT directus_revisions_pkey PRIMARY KEY (id);


--
-- Name: directus_roles directus_roles_pkey; Type: CONSTRAINT; Schema: public; Owner: valknar
--

ALTER TABLE ONLY public.directus_roles
    ADD CONSTRAINT directus_roles_pkey PRIMARY KEY (id);


--
-- Name: directus_sessions directus_sessions_pkey; Type: CONSTRAINT; Schema: public; Owner: valknar
--

ALTER TABLE ONLY public.directus_sessions
    ADD CONSTRAINT directus_sessions_pkey PRIMARY KEY (token);


--
-- Name: directus_settings directus_settings_pkey; Type: CONSTRAINT; Schema: public; Owner: valknar
--

ALTER TABLE ONLY public.directus_settings
    ADD CONSTRAINT directus_settings_pkey PRIMARY KEY (id);


--
-- Name: directus_shares directus_shares_pkey; Type: CONSTRAINT; Schema: public; Owner: valknar
--

ALTER TABLE ONLY public.directus_shares
    ADD CONSTRAINT directus_shares_pkey PRIMARY KEY (id);


--
-- Name: directus_translations directus_translations_pkey; Type: CONSTRAINT; Schema: public; Owner: valknar
--

ALTER TABLE ONLY public.directus_translations
    ADD CONSTRAINT directus_translations_pkey PRIMARY KEY (id);


--
-- Name: directus_users directus_users_email_unique; Type: CONSTRAINT; Schema: public; Owner: valknar
--

ALTER TABLE ONLY public.directus_users
    ADD CONSTRAINT directus_users_email_unique UNIQUE (email);


--
-- Name: directus_users directus_users_external_identifier_unique; Type: CONSTRAINT; Schema: public; Owner: valknar
--

ALTER TABLE ONLY public.directus_users
    ADD CONSTRAINT directus_users_external_identifier_unique UNIQUE (external_identifier);


--
-- Name: directus_users directus_users_pkey; Type: CONSTRAINT; Schema: public; Owner: valknar
--

ALTER TABLE ONLY public.directus_users
    ADD CONSTRAINT directus_users_pkey PRIMARY KEY (id);


--
-- Name: directus_users directus_users_slug_unique; Type: CONSTRAINT; Schema: public; Owner: valknar
--

ALTER TABLE ONLY public.directus_users
    ADD CONSTRAINT directus_users_slug_unique UNIQUE (slug);


--
-- Name: directus_users directus_users_token_unique; Type: CONSTRAINT; Schema: public; Owner: valknar
--

ALTER TABLE ONLY public.directus_users
    ADD CONSTRAINT directus_users_token_unique UNIQUE (token);


--
-- Name: directus_versions directus_versions_pkey; Type: CONSTRAINT; Schema: public; Owner: valknar
--

ALTER TABLE ONLY public.directus_versions
    ADD CONSTRAINT directus_versions_pkey PRIMARY KEY (id);


--
-- Name: directus_webhooks directus_webhooks_pkey; Type: CONSTRAINT; Schema: public; Owner: valknar
--

ALTER TABLE ONLY public.directus_webhooks
    ADD CONSTRAINT directus_webhooks_pkey PRIMARY KEY (id);


--
-- Name: junction_directus_users_files junction_directus_users_files_pkey; Type: CONSTRAINT; Schema: public; Owner: valknar
--

ALTER TABLE ONLY public.junction_directus_users_files
    ADD CONSTRAINT junction_directus_users_files_pkey PRIMARY KEY (id);


--
-- Name: sexy_articles sexy_articles_pkey; Type: CONSTRAINT; Schema: public; Owner: valknar
--

ALTER TABLE ONLY public.sexy_articles
    ADD CONSTRAINT sexy_articles_pkey PRIMARY KEY (id);


--
-- Name: sexy_articles sexy_articles_slug_unique; Type: CONSTRAINT; Schema: public; Owner: valknar
--

ALTER TABLE ONLY public.sexy_articles
    ADD CONSTRAINT sexy_articles_slug_unique UNIQUE (slug);


--
-- Name: sexy_videos_directus_users sexy_videos_directus_users_pkey; Type: CONSTRAINT; Schema: public; Owner: valknar
--

ALTER TABLE ONLY public.sexy_videos_directus_users
    ADD CONSTRAINT sexy_videos_directus_users_pkey PRIMARY KEY (id);


--
-- Name: sexy_videos sexy_videos_pkey; Type: CONSTRAINT; Schema: public; Owner: valknar
--

ALTER TABLE ONLY public.sexy_videos
    ADD CONSTRAINT sexy_videos_pkey PRIMARY KEY (id);


--
-- Name: directus_users_slug_index; Type: INDEX; Schema: public; Owner: valknar
--

CREATE INDEX directus_users_slug_index ON public.directus_users USING btree (slug);


--
-- Name: sexy_articles_slug_index; Type: INDEX; Schema: public; Owner: valknar
--

CREATE INDEX sexy_articles_slug_index ON public.sexy_articles USING btree (slug);


--
-- Name: directus_access directus_access_policy_foreign; Type: FK CONSTRAINT; Schema: public; Owner: valknar
--

ALTER TABLE ONLY public.directus_access
    ADD CONSTRAINT directus_access_policy_foreign FOREIGN KEY (policy) REFERENCES public.directus_policies(id) ON DELETE CASCADE;


--
-- Name: directus_access directus_access_role_foreign; Type: FK CONSTRAINT; Schema: public; Owner: valknar
--

ALTER TABLE ONLY public.directus_access
    ADD CONSTRAINT directus_access_role_foreign FOREIGN KEY (role) REFERENCES public.directus_roles(id) ON DELETE CASCADE;


--
-- Name: directus_access directus_access_user_foreign; Type: FK CONSTRAINT; Schema: public; Owner: valknar
--

ALTER TABLE ONLY public.directus_access
    ADD CONSTRAINT directus_access_user_foreign FOREIGN KEY ("user") REFERENCES public.directus_users(id) ON DELETE CASCADE;


--
-- Name: directus_collections directus_collections_group_foreign; Type: FK CONSTRAINT; Schema: public; Owner: valknar
--

ALTER TABLE ONLY public.directus_collections
    ADD CONSTRAINT directus_collections_group_foreign FOREIGN KEY ("group") REFERENCES public.directus_collections(collection);


--
-- Name: directus_comments directus_comments_user_created_foreign; Type: FK CONSTRAINT; Schema: public; Owner: valknar
--

ALTER TABLE ONLY public.directus_comments
    ADD CONSTRAINT directus_comments_user_created_foreign FOREIGN KEY (user_created) REFERENCES public.directus_users(id) ON DELETE SET NULL;


--
-- Name: directus_comments directus_comments_user_updated_foreign; Type: FK CONSTRAINT; Schema: public; Owner: valknar
--

ALTER TABLE ONLY public.directus_comments
    ADD CONSTRAINT directus_comments_user_updated_foreign FOREIGN KEY (user_updated) REFERENCES public.directus_users(id);


--
-- Name: directus_dashboards directus_dashboards_user_created_foreign; Type: FK CONSTRAINT; Schema: public; Owner: valknar
--

ALTER TABLE ONLY public.directus_dashboards
    ADD CONSTRAINT directus_dashboards_user_created_foreign FOREIGN KEY (user_created) REFERENCES public.directus_users(id) ON DELETE SET NULL;


--
-- Name: directus_files directus_files_folder_foreign; Type: FK CONSTRAINT; Schema: public; Owner: valknar
--

ALTER TABLE ONLY public.directus_files
    ADD CONSTRAINT directus_files_folder_foreign FOREIGN KEY (folder) REFERENCES public.directus_folders(id) ON DELETE SET NULL;


--
-- Name: directus_files directus_files_modified_by_foreign; Type: FK CONSTRAINT; Schema: public; Owner: valknar
--

ALTER TABLE ONLY public.directus_files
    ADD CONSTRAINT directus_files_modified_by_foreign FOREIGN KEY (modified_by) REFERENCES public.directus_users(id);


--
-- Name: directus_files directus_files_uploaded_by_foreign; Type: FK CONSTRAINT; Schema: public; Owner: valknar
--

ALTER TABLE ONLY public.directus_files
    ADD CONSTRAINT directus_files_uploaded_by_foreign FOREIGN KEY (uploaded_by) REFERENCES public.directus_users(id);


--
-- Name: directus_flows directus_flows_user_created_foreign; Type: FK CONSTRAINT; Schema: public; Owner: valknar
--

ALTER TABLE ONLY public.directus_flows
    ADD CONSTRAINT directus_flows_user_created_foreign FOREIGN KEY (user_created) REFERENCES public.directus_users(id) ON DELETE SET NULL;


--
-- Name: directus_folders directus_folders_parent_foreign; Type: FK CONSTRAINT; Schema: public; Owner: valknar
--

ALTER TABLE ONLY public.directus_folders
    ADD CONSTRAINT directus_folders_parent_foreign FOREIGN KEY (parent) REFERENCES public.directus_folders(id);


--
-- Name: directus_notifications directus_notifications_recipient_foreign; Type: FK CONSTRAINT; Schema: public; Owner: valknar
--

ALTER TABLE ONLY public.directus_notifications
    ADD CONSTRAINT directus_notifications_recipient_foreign FOREIGN KEY (recipient) REFERENCES public.directus_users(id) ON DELETE CASCADE;


--
-- Name: directus_notifications directus_notifications_sender_foreign; Type: FK CONSTRAINT; Schema: public; Owner: valknar
--

ALTER TABLE ONLY public.directus_notifications
    ADD CONSTRAINT directus_notifications_sender_foreign FOREIGN KEY (sender) REFERENCES public.directus_users(id);


--
-- Name: directus_operations directus_operations_flow_foreign; Type: FK CONSTRAINT; Schema: public; Owner: valknar
--

ALTER TABLE ONLY public.directus_operations
    ADD CONSTRAINT directus_operations_flow_foreign FOREIGN KEY (flow) REFERENCES public.directus_flows(id) ON DELETE CASCADE;


--
-- Name: directus_operations directus_operations_reject_foreign; Type: FK CONSTRAINT; Schema: public; Owner: valknar
--

ALTER TABLE ONLY public.directus_operations
    ADD CONSTRAINT directus_operations_reject_foreign FOREIGN KEY (reject) REFERENCES public.directus_operations(id);


--
-- Name: directus_operations directus_operations_resolve_foreign; Type: FK CONSTRAINT; Schema: public; Owner: valknar
--

ALTER TABLE ONLY public.directus_operations
    ADD CONSTRAINT directus_operations_resolve_foreign FOREIGN KEY (resolve) REFERENCES public.directus_operations(id);


--
-- Name: directus_operations directus_operations_user_created_foreign; Type: FK CONSTRAINT; Schema: public; Owner: valknar
--

ALTER TABLE ONLY public.directus_operations
    ADD CONSTRAINT directus_operations_user_created_foreign FOREIGN KEY (user_created) REFERENCES public.directus_users(id) ON DELETE SET NULL;


--
-- Name: directus_panels directus_panels_dashboard_foreign; Type: FK CONSTRAINT; Schema: public; Owner: valknar
--

ALTER TABLE ONLY public.directus_panels
    ADD CONSTRAINT directus_panels_dashboard_foreign FOREIGN KEY (dashboard) REFERENCES public.directus_dashboards(id) ON DELETE CASCADE;


--
-- Name: directus_panels directus_panels_user_created_foreign; Type: FK CONSTRAINT; Schema: public; Owner: valknar
--

ALTER TABLE ONLY public.directus_panels
    ADD CONSTRAINT directus_panels_user_created_foreign FOREIGN KEY (user_created) REFERENCES public.directus_users(id) ON DELETE SET NULL;


--
-- Name: directus_permissions directus_permissions_policy_foreign; Type: FK CONSTRAINT; Schema: public; Owner: valknar
--

ALTER TABLE ONLY public.directus_permissions
    ADD CONSTRAINT directus_permissions_policy_foreign FOREIGN KEY (policy) REFERENCES public.directus_policies(id) ON DELETE CASCADE;


--
-- Name: directus_presets directus_presets_role_foreign; Type: FK CONSTRAINT; Schema: public; Owner: valknar
--

ALTER TABLE ONLY public.directus_presets
    ADD CONSTRAINT directus_presets_role_foreign FOREIGN KEY (role) REFERENCES public.directus_roles(id) ON DELETE CASCADE;


--
-- Name: directus_presets directus_presets_user_foreign; Type: FK CONSTRAINT; Schema: public; Owner: valknar
--

ALTER TABLE ONLY public.directus_presets
    ADD CONSTRAINT directus_presets_user_foreign FOREIGN KEY ("user") REFERENCES public.directus_users(id) ON DELETE CASCADE;


--
-- Name: directus_revisions directus_revisions_activity_foreign; Type: FK CONSTRAINT; Schema: public; Owner: valknar
--

ALTER TABLE ONLY public.directus_revisions
    ADD CONSTRAINT directus_revisions_activity_foreign FOREIGN KEY (activity) REFERENCES public.directus_activity(id) ON DELETE CASCADE;


--
-- Name: directus_revisions directus_revisions_parent_foreign; Type: FK CONSTRAINT; Schema: public; Owner: valknar
--

ALTER TABLE ONLY public.directus_revisions
    ADD CONSTRAINT directus_revisions_parent_foreign FOREIGN KEY (parent) REFERENCES public.directus_revisions(id);


--
-- Name: directus_revisions directus_revisions_version_foreign; Type: FK CONSTRAINT; Schema: public; Owner: valknar
--

ALTER TABLE ONLY public.directus_revisions
    ADD CONSTRAINT directus_revisions_version_foreign FOREIGN KEY (version) REFERENCES public.directus_versions(id) ON DELETE CASCADE;


--
-- Name: directus_roles directus_roles_parent_foreign; Type: FK CONSTRAINT; Schema: public; Owner: valknar
--

ALTER TABLE ONLY public.directus_roles
    ADD CONSTRAINT directus_roles_parent_foreign FOREIGN KEY (parent) REFERENCES public.directus_roles(id);


--
-- Name: directus_sessions directus_sessions_share_foreign; Type: FK CONSTRAINT; Schema: public; Owner: valknar
--

ALTER TABLE ONLY public.directus_sessions
    ADD CONSTRAINT directus_sessions_share_foreign FOREIGN KEY (share) REFERENCES public.directus_shares(id) ON DELETE CASCADE;


--
-- Name: directus_sessions directus_sessions_user_foreign; Type: FK CONSTRAINT; Schema: public; Owner: valknar
--

ALTER TABLE ONLY public.directus_sessions
    ADD CONSTRAINT directus_sessions_user_foreign FOREIGN KEY ("user") REFERENCES public.directus_users(id) ON DELETE CASCADE;


--
-- Name: directus_settings directus_settings_project_logo_foreign; Type: FK CONSTRAINT; Schema: public; Owner: valknar
--

ALTER TABLE ONLY public.directus_settings
    ADD CONSTRAINT directus_settings_project_logo_foreign FOREIGN KEY (project_logo) REFERENCES public.directus_files(id);


--
-- Name: directus_settings directus_settings_public_background_foreign; Type: FK CONSTRAINT; Schema: public; Owner: valknar
--

ALTER TABLE ONLY public.directus_settings
    ADD CONSTRAINT directus_settings_public_background_foreign FOREIGN KEY (public_background) REFERENCES public.directus_files(id);


--
-- Name: directus_settings directus_settings_public_favicon_foreign; Type: FK CONSTRAINT; Schema: public; Owner: valknar
--

ALTER TABLE ONLY public.directus_settings
    ADD CONSTRAINT directus_settings_public_favicon_foreign FOREIGN KEY (public_favicon) REFERENCES public.directus_files(id);


--
-- Name: directus_settings directus_settings_public_foreground_foreign; Type: FK CONSTRAINT; Schema: public; Owner: valknar
--

ALTER TABLE ONLY public.directus_settings
    ADD CONSTRAINT directus_settings_public_foreground_foreign FOREIGN KEY (public_foreground) REFERENCES public.directus_files(id);


--
-- Name: directus_settings directus_settings_public_registration_role_foreign; Type: FK CONSTRAINT; Schema: public; Owner: valknar
--

ALTER TABLE ONLY public.directus_settings
    ADD CONSTRAINT directus_settings_public_registration_role_foreign FOREIGN KEY (public_registration_role) REFERENCES public.directus_roles(id) ON DELETE SET NULL;


--
-- Name: directus_settings directus_settings_storage_default_folder_foreign; Type: FK CONSTRAINT; Schema: public; Owner: valknar
--

ALTER TABLE ONLY public.directus_settings
    ADD CONSTRAINT directus_settings_storage_default_folder_foreign FOREIGN KEY (storage_default_folder) REFERENCES public.directus_folders(id) ON DELETE SET NULL;


--
-- Name: directus_shares directus_shares_collection_foreign; Type: FK CONSTRAINT; Schema: public; Owner: valknar
--

ALTER TABLE ONLY public.directus_shares
    ADD CONSTRAINT directus_shares_collection_foreign FOREIGN KEY (collection) REFERENCES public.directus_collections(collection) ON DELETE CASCADE;


--
-- Name: directus_shares directus_shares_role_foreign; Type: FK CONSTRAINT; Schema: public; Owner: valknar
--

ALTER TABLE ONLY public.directus_shares
    ADD CONSTRAINT directus_shares_role_foreign FOREIGN KEY (role) REFERENCES public.directus_roles(id) ON DELETE CASCADE;


--
-- Name: directus_shares directus_shares_user_created_foreign; Type: FK CONSTRAINT; Schema: public; Owner: valknar
--

ALTER TABLE ONLY public.directus_shares
    ADD CONSTRAINT directus_shares_user_created_foreign FOREIGN KEY (user_created) REFERENCES public.directus_users(id) ON DELETE SET NULL;


--
-- Name: directus_users directus_users_banner_foreign; Type: FK CONSTRAINT; Schema: public; Owner: valknar
--

ALTER TABLE ONLY public.directus_users
    ADD CONSTRAINT directus_users_banner_foreign FOREIGN KEY (banner) REFERENCES public.directus_files(id) ON DELETE SET NULL;


--
-- Name: directus_users directus_users_role_foreign; Type: FK CONSTRAINT; Schema: public; Owner: valknar
--

ALTER TABLE ONLY public.directus_users
    ADD CONSTRAINT directus_users_role_foreign FOREIGN KEY (role) REFERENCES public.directus_roles(id) ON DELETE SET NULL;


--
-- Name: directus_versions directus_versions_collection_foreign; Type: FK CONSTRAINT; Schema: public; Owner: valknar
--

ALTER TABLE ONLY public.directus_versions
    ADD CONSTRAINT directus_versions_collection_foreign FOREIGN KEY (collection) REFERENCES public.directus_collections(collection) ON DELETE CASCADE;


--
-- Name: directus_versions directus_versions_user_created_foreign; Type: FK CONSTRAINT; Schema: public; Owner: valknar
--

ALTER TABLE ONLY public.directus_versions
    ADD CONSTRAINT directus_versions_user_created_foreign FOREIGN KEY (user_created) REFERENCES public.directus_users(id) ON DELETE SET NULL;


--
-- Name: directus_versions directus_versions_user_updated_foreign; Type: FK CONSTRAINT; Schema: public; Owner: valknar
--

ALTER TABLE ONLY public.directus_versions
    ADD CONSTRAINT directus_versions_user_updated_foreign FOREIGN KEY (user_updated) REFERENCES public.directus_users(id);


--
-- Name: directus_webhooks directus_webhooks_migrated_flow_foreign; Type: FK CONSTRAINT; Schema: public; Owner: valknar
--

ALTER TABLE ONLY public.directus_webhooks
    ADD CONSTRAINT directus_webhooks_migrated_flow_foreign FOREIGN KEY (migrated_flow) REFERENCES public.directus_flows(id) ON DELETE SET NULL;


--
-- Name: junction_directus_users_files junction_directus_users_files_directus_files_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: valknar
--

ALTER TABLE ONLY public.junction_directus_users_files
    ADD CONSTRAINT junction_directus_users_files_directus_files_id_foreign FOREIGN KEY (directus_files_id) REFERENCES public.directus_files(id) ON DELETE SET NULL;


--
-- Name: junction_directus_users_files junction_directus_users_files_directus_users_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: valknar
--

ALTER TABLE ONLY public.junction_directus_users_files
    ADD CONSTRAINT junction_directus_users_files_directus_users_id_foreign FOREIGN KEY (directus_users_id) REFERENCES public.directus_users(id) ON DELETE SET NULL;


--
-- Name: sexy_articles sexy_articles_author_foreign; Type: FK CONSTRAINT; Schema: public; Owner: valknar
--

ALTER TABLE ONLY public.sexy_articles
    ADD CONSTRAINT sexy_articles_author_foreign FOREIGN KEY (author) REFERENCES public.directus_users(id) ON DELETE SET NULL;


--
-- Name: sexy_articles sexy_articles_image_foreign; Type: FK CONSTRAINT; Schema: public; Owner: valknar
--

ALTER TABLE ONLY public.sexy_articles
    ADD CONSTRAINT sexy_articles_image_foreign FOREIGN KEY (image) REFERENCES public.directus_files(id);


--
-- Name: sexy_articles sexy_articles_user_created_foreign; Type: FK CONSTRAINT; Schema: public; Owner: valknar
--

ALTER TABLE ONLY public.sexy_articles
    ADD CONSTRAINT sexy_articles_user_created_foreign FOREIGN KEY (user_created) REFERENCES public.directus_users(id);


--
-- Name: sexy_videos_directus_users sexy_videos_directus_users_directus_users_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: valknar
--

ALTER TABLE ONLY public.sexy_videos_directus_users
    ADD CONSTRAINT sexy_videos_directus_users_directus_users_id_foreign FOREIGN KEY (directus_users_id) REFERENCES public.directus_users(id) ON DELETE SET NULL;


--
-- Name: sexy_videos_directus_users sexy_videos_directus_users_sexy_videos_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: valknar
--

ALTER TABLE ONLY public.sexy_videos_directus_users
    ADD CONSTRAINT sexy_videos_directus_users_sexy_videos_id_foreign FOREIGN KEY (sexy_videos_id) REFERENCES public.sexy_videos(id) ON DELETE SET NULL;


--
-- Name: sexy_videos sexy_videos_image_foreign; Type: FK CONSTRAINT; Schema: public; Owner: valknar
--

ALTER TABLE ONLY public.sexy_videos
    ADD CONSTRAINT sexy_videos_image_foreign FOREIGN KEY (image) REFERENCES public.directus_files(id) ON DELETE SET NULL;


--
-- Name: sexy_videos sexy_videos_movie_foreign; Type: FK CONSTRAINT; Schema: public; Owner: valknar
--

ALTER TABLE ONLY public.sexy_videos
    ADD CONSTRAINT sexy_videos_movie_foreign FOREIGN KEY (movie) REFERENCES public.directus_files(id) ON DELETE SET NULL;


--
-- Name: sexy_videos sexy_videos_user_created_foreign; Type: FK CONSTRAINT; Schema: public; Owner: valknar
--

ALTER TABLE ONLY public.sexy_videos
    ADD CONSTRAINT sexy_videos_user_created_foreign FOREIGN KEY (user_created) REFERENCES public.directus_users(id);


--
-- Name: SCHEMA public; Type: ACL; Schema: -; Owner: pg_database_owner
--

REVOKE USAGE ON SCHEMA public FROM PUBLIC;
GRANT ALL ON SCHEMA public TO PUBLIC;


--
-- PostgreSQL database dump complete
--

\unrestrict kHaSmq4pzphfyKS1cgbEfBxXPPJEZNokzfZYTVTz0MdM9wEWRpxGHentE1L9eUf

