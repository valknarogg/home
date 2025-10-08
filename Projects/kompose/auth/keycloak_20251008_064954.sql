--
-- PostgreSQL database dump
--

\restrict liCUlxQpiok7ivN6vHt8brlg0pfUuyPTUlO5nr0ftqRtGThGUM8otBygfhEOnyj

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
-- Name: admin_event_entity; Type: TABLE; Schema: public; Owner: valknar
--

CREATE TABLE public.admin_event_entity (
    id character varying(36) NOT NULL,
    admin_event_time bigint,
    realm_id character varying(255),
    operation_type character varying(255),
    auth_realm_id character varying(255),
    auth_client_id character varying(255),
    auth_user_id character varying(255),
    ip_address character varying(255),
    resource_path character varying(2550),
    representation text,
    error character varying(255),
    resource_type character varying(64),
    details_json text
);


ALTER TABLE public.admin_event_entity OWNER TO valknar;

--
-- Name: associated_policy; Type: TABLE; Schema: public; Owner: valknar
--

CREATE TABLE public.associated_policy (
    policy_id character varying(36) NOT NULL,
    associated_policy_id character varying(36) NOT NULL
);


ALTER TABLE public.associated_policy OWNER TO valknar;

--
-- Name: authentication_execution; Type: TABLE; Schema: public; Owner: valknar
--

CREATE TABLE public.authentication_execution (
    id character varying(36) NOT NULL,
    alias character varying(255),
    authenticator character varying(36),
    realm_id character varying(36),
    flow_id character varying(36),
    requirement integer,
    priority integer,
    authenticator_flow boolean DEFAULT false NOT NULL,
    auth_flow_id character varying(36),
    auth_config character varying(36)
);


ALTER TABLE public.authentication_execution OWNER TO valknar;

--
-- Name: authentication_flow; Type: TABLE; Schema: public; Owner: valknar
--

CREATE TABLE public.authentication_flow (
    id character varying(36) NOT NULL,
    alias character varying(255),
    description character varying(255),
    realm_id character varying(36),
    provider_id character varying(36) DEFAULT 'basic-flow'::character varying NOT NULL,
    top_level boolean DEFAULT false NOT NULL,
    built_in boolean DEFAULT false NOT NULL
);


ALTER TABLE public.authentication_flow OWNER TO valknar;

--
-- Name: authenticator_config; Type: TABLE; Schema: public; Owner: valknar
--

CREATE TABLE public.authenticator_config (
    id character varying(36) NOT NULL,
    alias character varying(255),
    realm_id character varying(36)
);


ALTER TABLE public.authenticator_config OWNER TO valknar;

--
-- Name: authenticator_config_entry; Type: TABLE; Schema: public; Owner: valknar
--

CREATE TABLE public.authenticator_config_entry (
    authenticator_id character varying(36) NOT NULL,
    value text,
    name character varying(255) NOT NULL
);


ALTER TABLE public.authenticator_config_entry OWNER TO valknar;

--
-- Name: broker_link; Type: TABLE; Schema: public; Owner: valknar
--

CREATE TABLE public.broker_link (
    identity_provider character varying(255) NOT NULL,
    storage_provider_id character varying(255),
    realm_id character varying(36) NOT NULL,
    broker_user_id character varying(255),
    broker_username character varying(255),
    token text,
    user_id character varying(255) NOT NULL
);


ALTER TABLE public.broker_link OWNER TO valknar;

--
-- Name: client; Type: TABLE; Schema: public; Owner: valknar
--

CREATE TABLE public.client (
    id character varying(36) NOT NULL,
    enabled boolean DEFAULT false NOT NULL,
    full_scope_allowed boolean DEFAULT false NOT NULL,
    client_id character varying(255),
    not_before integer,
    public_client boolean DEFAULT false NOT NULL,
    secret character varying(255),
    base_url character varying(255),
    bearer_only boolean DEFAULT false NOT NULL,
    management_url character varying(255),
    surrogate_auth_required boolean DEFAULT false NOT NULL,
    realm_id character varying(36),
    protocol character varying(255),
    node_rereg_timeout integer DEFAULT 0,
    frontchannel_logout boolean DEFAULT false NOT NULL,
    consent_required boolean DEFAULT false NOT NULL,
    name character varying(255),
    service_accounts_enabled boolean DEFAULT false NOT NULL,
    client_authenticator_type character varying(255),
    root_url character varying(255),
    description character varying(255),
    registration_token character varying(255),
    standard_flow_enabled boolean DEFAULT true NOT NULL,
    implicit_flow_enabled boolean DEFAULT false NOT NULL,
    direct_access_grants_enabled boolean DEFAULT false NOT NULL,
    always_display_in_console boolean DEFAULT false NOT NULL
);


ALTER TABLE public.client OWNER TO valknar;

--
-- Name: client_attributes; Type: TABLE; Schema: public; Owner: valknar
--

CREATE TABLE public.client_attributes (
    client_id character varying(36) NOT NULL,
    name character varying(255) NOT NULL,
    value text
);


ALTER TABLE public.client_attributes OWNER TO valknar;

--
-- Name: client_auth_flow_bindings; Type: TABLE; Schema: public; Owner: valknar
--

CREATE TABLE public.client_auth_flow_bindings (
    client_id character varying(36) NOT NULL,
    flow_id character varying(36),
    binding_name character varying(255) NOT NULL
);


ALTER TABLE public.client_auth_flow_bindings OWNER TO valknar;

--
-- Name: client_initial_access; Type: TABLE; Schema: public; Owner: valknar
--

CREATE TABLE public.client_initial_access (
    id character varying(36) NOT NULL,
    realm_id character varying(36) NOT NULL,
    "timestamp" integer,
    expiration integer,
    count integer,
    remaining_count integer
);


ALTER TABLE public.client_initial_access OWNER TO valknar;

--
-- Name: client_node_registrations; Type: TABLE; Schema: public; Owner: valknar
--

CREATE TABLE public.client_node_registrations (
    client_id character varying(36) NOT NULL,
    value integer,
    name character varying(255) NOT NULL
);


ALTER TABLE public.client_node_registrations OWNER TO valknar;

--
-- Name: client_scope; Type: TABLE; Schema: public; Owner: valknar
--

CREATE TABLE public.client_scope (
    id character varying(36) NOT NULL,
    name character varying(255),
    realm_id character varying(36),
    description character varying(255),
    protocol character varying(255)
);


ALTER TABLE public.client_scope OWNER TO valknar;

--
-- Name: client_scope_attributes; Type: TABLE; Schema: public; Owner: valknar
--

CREATE TABLE public.client_scope_attributes (
    scope_id character varying(36) NOT NULL,
    value character varying(2048),
    name character varying(255) NOT NULL
);


ALTER TABLE public.client_scope_attributes OWNER TO valknar;

--
-- Name: client_scope_client; Type: TABLE; Schema: public; Owner: valknar
--

CREATE TABLE public.client_scope_client (
    client_id character varying(255) NOT NULL,
    scope_id character varying(255) NOT NULL,
    default_scope boolean DEFAULT false NOT NULL
);


ALTER TABLE public.client_scope_client OWNER TO valknar;

--
-- Name: client_scope_role_mapping; Type: TABLE; Schema: public; Owner: valknar
--

CREATE TABLE public.client_scope_role_mapping (
    scope_id character varying(36) NOT NULL,
    role_id character varying(36) NOT NULL
);


ALTER TABLE public.client_scope_role_mapping OWNER TO valknar;

--
-- Name: component; Type: TABLE; Schema: public; Owner: valknar
--

CREATE TABLE public.component (
    id character varying(36) NOT NULL,
    name character varying(255),
    parent_id character varying(36),
    provider_id character varying(36),
    provider_type character varying(255),
    realm_id character varying(36),
    sub_type character varying(255)
);


ALTER TABLE public.component OWNER TO valknar;

--
-- Name: component_config; Type: TABLE; Schema: public; Owner: valknar
--

CREATE TABLE public.component_config (
    id character varying(36) NOT NULL,
    component_id character varying(36) NOT NULL,
    name character varying(255) NOT NULL,
    value text
);


ALTER TABLE public.component_config OWNER TO valknar;

--
-- Name: composite_role; Type: TABLE; Schema: public; Owner: valknar
--

CREATE TABLE public.composite_role (
    composite character varying(36) NOT NULL,
    child_role character varying(36) NOT NULL
);


ALTER TABLE public.composite_role OWNER TO valknar;

--
-- Name: credential; Type: TABLE; Schema: public; Owner: valknar
--

CREATE TABLE public.credential (
    id character varying(36) NOT NULL,
    salt bytea,
    type character varying(255),
    user_id character varying(36),
    created_date bigint,
    user_label character varying(255),
    secret_data text,
    credential_data text,
    priority integer,
    version integer DEFAULT 0
);


ALTER TABLE public.credential OWNER TO valknar;

--
-- Name: databasechangelog; Type: TABLE; Schema: public; Owner: valknar
--

CREATE TABLE public.databasechangelog (
    id character varying(255) NOT NULL,
    author character varying(255) NOT NULL,
    filename character varying(255) NOT NULL,
    dateexecuted timestamp without time zone NOT NULL,
    orderexecuted integer NOT NULL,
    exectype character varying(10) NOT NULL,
    md5sum character varying(35),
    description character varying(255),
    comments character varying(255),
    tag character varying(255),
    liquibase character varying(20),
    contexts character varying(255),
    labels character varying(255),
    deployment_id character varying(10)
);


ALTER TABLE public.databasechangelog OWNER TO valknar;

--
-- Name: databasechangeloglock; Type: TABLE; Schema: public; Owner: valknar
--

CREATE TABLE public.databasechangeloglock (
    id integer NOT NULL,
    locked boolean NOT NULL,
    lockgranted timestamp without time zone,
    lockedby character varying(255)
);


ALTER TABLE public.databasechangeloglock OWNER TO valknar;

--
-- Name: default_client_scope; Type: TABLE; Schema: public; Owner: valknar
--

CREATE TABLE public.default_client_scope (
    realm_id character varying(36) NOT NULL,
    scope_id character varying(36) NOT NULL,
    default_scope boolean DEFAULT false NOT NULL
);


ALTER TABLE public.default_client_scope OWNER TO valknar;

--
-- Name: event_entity; Type: TABLE; Schema: public; Owner: valknar
--

CREATE TABLE public.event_entity (
    id character varying(36) NOT NULL,
    client_id character varying(255),
    details_json character varying(2550),
    error character varying(255),
    ip_address character varying(255),
    realm_id character varying(255),
    session_id character varying(255),
    event_time bigint,
    type character varying(255),
    user_id character varying(255),
    details_json_long_value text
);


ALTER TABLE public.event_entity OWNER TO valknar;

--
-- Name: fed_user_attribute; Type: TABLE; Schema: public; Owner: valknar
--

CREATE TABLE public.fed_user_attribute (
    id character varying(36) NOT NULL,
    name character varying(255) NOT NULL,
    user_id character varying(255) NOT NULL,
    realm_id character varying(36) NOT NULL,
    storage_provider_id character varying(36),
    value character varying(2024),
    long_value_hash bytea,
    long_value_hash_lower_case bytea,
    long_value text
);


ALTER TABLE public.fed_user_attribute OWNER TO valknar;

--
-- Name: fed_user_consent; Type: TABLE; Schema: public; Owner: valknar
--

CREATE TABLE public.fed_user_consent (
    id character varying(36) NOT NULL,
    client_id character varying(255),
    user_id character varying(255) NOT NULL,
    realm_id character varying(36) NOT NULL,
    storage_provider_id character varying(36),
    created_date bigint,
    last_updated_date bigint,
    client_storage_provider character varying(36),
    external_client_id character varying(255)
);


ALTER TABLE public.fed_user_consent OWNER TO valknar;

--
-- Name: fed_user_consent_cl_scope; Type: TABLE; Schema: public; Owner: valknar
--

CREATE TABLE public.fed_user_consent_cl_scope (
    user_consent_id character varying(36) NOT NULL,
    scope_id character varying(36) NOT NULL
);


ALTER TABLE public.fed_user_consent_cl_scope OWNER TO valknar;

--
-- Name: fed_user_credential; Type: TABLE; Schema: public; Owner: valknar
--

CREATE TABLE public.fed_user_credential (
    id character varying(36) NOT NULL,
    salt bytea,
    type character varying(255),
    created_date bigint,
    user_id character varying(255) NOT NULL,
    realm_id character varying(36) NOT NULL,
    storage_provider_id character varying(36),
    user_label character varying(255),
    secret_data text,
    credential_data text,
    priority integer
);


ALTER TABLE public.fed_user_credential OWNER TO valknar;

--
-- Name: fed_user_group_membership; Type: TABLE; Schema: public; Owner: valknar
--

CREATE TABLE public.fed_user_group_membership (
    group_id character varying(36) NOT NULL,
    user_id character varying(255) NOT NULL,
    realm_id character varying(36) NOT NULL,
    storage_provider_id character varying(36)
);


ALTER TABLE public.fed_user_group_membership OWNER TO valknar;

--
-- Name: fed_user_required_action; Type: TABLE; Schema: public; Owner: valknar
--

CREATE TABLE public.fed_user_required_action (
    required_action character varying(255) DEFAULT ' '::character varying NOT NULL,
    user_id character varying(255) NOT NULL,
    realm_id character varying(36) NOT NULL,
    storage_provider_id character varying(36)
);


ALTER TABLE public.fed_user_required_action OWNER TO valknar;

--
-- Name: fed_user_role_mapping; Type: TABLE; Schema: public; Owner: valknar
--

CREATE TABLE public.fed_user_role_mapping (
    role_id character varying(36) NOT NULL,
    user_id character varying(255) NOT NULL,
    realm_id character varying(36) NOT NULL,
    storage_provider_id character varying(36)
);


ALTER TABLE public.fed_user_role_mapping OWNER TO valknar;

--
-- Name: federated_identity; Type: TABLE; Schema: public; Owner: valknar
--

CREATE TABLE public.federated_identity (
    identity_provider character varying(255) NOT NULL,
    realm_id character varying(36),
    federated_user_id character varying(255),
    federated_username character varying(255),
    token text,
    user_id character varying(36) NOT NULL
);


ALTER TABLE public.federated_identity OWNER TO valknar;

--
-- Name: federated_user; Type: TABLE; Schema: public; Owner: valknar
--

CREATE TABLE public.federated_user (
    id character varying(255) NOT NULL,
    storage_provider_id character varying(255),
    realm_id character varying(36) NOT NULL
);


ALTER TABLE public.federated_user OWNER TO valknar;

--
-- Name: group_attribute; Type: TABLE; Schema: public; Owner: valknar
--

CREATE TABLE public.group_attribute (
    id character varying(36) DEFAULT 'sybase-needs-something-here'::character varying NOT NULL,
    name character varying(255) NOT NULL,
    value character varying(255),
    group_id character varying(36) NOT NULL
);


ALTER TABLE public.group_attribute OWNER TO valknar;

--
-- Name: group_role_mapping; Type: TABLE; Schema: public; Owner: valknar
--

CREATE TABLE public.group_role_mapping (
    role_id character varying(36) NOT NULL,
    group_id character varying(36) NOT NULL
);


ALTER TABLE public.group_role_mapping OWNER TO valknar;

--
-- Name: identity_provider; Type: TABLE; Schema: public; Owner: valknar
--

CREATE TABLE public.identity_provider (
    internal_id character varying(36) NOT NULL,
    enabled boolean DEFAULT false NOT NULL,
    provider_alias character varying(255),
    provider_id character varying(255),
    store_token boolean DEFAULT false NOT NULL,
    authenticate_by_default boolean DEFAULT false NOT NULL,
    realm_id character varying(36),
    add_token_role boolean DEFAULT true NOT NULL,
    trust_email boolean DEFAULT false NOT NULL,
    first_broker_login_flow_id character varying(36),
    post_broker_login_flow_id character varying(36),
    provider_display_name character varying(255),
    link_only boolean DEFAULT false NOT NULL,
    organization_id character varying(255),
    hide_on_login boolean DEFAULT false
);


ALTER TABLE public.identity_provider OWNER TO valknar;

--
-- Name: identity_provider_config; Type: TABLE; Schema: public; Owner: valknar
--

CREATE TABLE public.identity_provider_config (
    identity_provider_id character varying(36) NOT NULL,
    value text,
    name character varying(255) NOT NULL
);


ALTER TABLE public.identity_provider_config OWNER TO valknar;

--
-- Name: identity_provider_mapper; Type: TABLE; Schema: public; Owner: valknar
--

CREATE TABLE public.identity_provider_mapper (
    id character varying(36) NOT NULL,
    name character varying(255) NOT NULL,
    idp_alias character varying(255) NOT NULL,
    idp_mapper_name character varying(255) NOT NULL,
    realm_id character varying(36) NOT NULL
);


ALTER TABLE public.identity_provider_mapper OWNER TO valknar;

--
-- Name: idp_mapper_config; Type: TABLE; Schema: public; Owner: valknar
--

CREATE TABLE public.idp_mapper_config (
    idp_mapper_id character varying(36) NOT NULL,
    value text,
    name character varying(255) NOT NULL
);


ALTER TABLE public.idp_mapper_config OWNER TO valknar;

--
-- Name: jgroups_ping; Type: TABLE; Schema: public; Owner: valknar
--

CREATE TABLE public.jgroups_ping (
    address character varying(200) NOT NULL,
    name character varying(200),
    cluster_name character varying(200) NOT NULL,
    ip character varying(200) NOT NULL,
    coord boolean
);


ALTER TABLE public.jgroups_ping OWNER TO valknar;

--
-- Name: keycloak_group; Type: TABLE; Schema: public; Owner: valknar
--

CREATE TABLE public.keycloak_group (
    id character varying(36) NOT NULL,
    name character varying(255),
    parent_group character varying(36) NOT NULL,
    realm_id character varying(36),
    type integer DEFAULT 0 NOT NULL,
    description character varying(255)
);


ALTER TABLE public.keycloak_group OWNER TO valknar;

--
-- Name: keycloak_role; Type: TABLE; Schema: public; Owner: valknar
--

CREATE TABLE public.keycloak_role (
    id character varying(36) NOT NULL,
    client_realm_constraint character varying(255),
    client_role boolean DEFAULT false NOT NULL,
    description character varying(255),
    name character varying(255),
    realm_id character varying(255),
    client character varying(36),
    realm character varying(36)
);


ALTER TABLE public.keycloak_role OWNER TO valknar;

--
-- Name: migration_model; Type: TABLE; Schema: public; Owner: valknar
--

CREATE TABLE public.migration_model (
    id character varying(36) NOT NULL,
    version character varying(36),
    update_time bigint DEFAULT 0 NOT NULL
);


ALTER TABLE public.migration_model OWNER TO valknar;

--
-- Name: offline_client_session; Type: TABLE; Schema: public; Owner: valknar
--

CREATE TABLE public.offline_client_session (
    user_session_id character varying(36) NOT NULL,
    client_id character varying(255) NOT NULL,
    offline_flag character varying(4) NOT NULL,
    "timestamp" integer,
    data text,
    client_storage_provider character varying(36) DEFAULT 'local'::character varying NOT NULL,
    external_client_id character varying(255) DEFAULT 'local'::character varying NOT NULL,
    version integer DEFAULT 0
);


ALTER TABLE public.offline_client_session OWNER TO valknar;

--
-- Name: offline_user_session; Type: TABLE; Schema: public; Owner: valknar
--

CREATE TABLE public.offline_user_session (
    user_session_id character varying(36) NOT NULL,
    user_id character varying(255) NOT NULL,
    realm_id character varying(36) NOT NULL,
    created_on integer NOT NULL,
    offline_flag character varying(4) NOT NULL,
    data text,
    last_session_refresh integer DEFAULT 0 NOT NULL,
    broker_session_id character varying(1024),
    version integer DEFAULT 0
);


ALTER TABLE public.offline_user_session OWNER TO valknar;

--
-- Name: org; Type: TABLE; Schema: public; Owner: valknar
--

CREATE TABLE public.org (
    id character varying(255) NOT NULL,
    enabled boolean NOT NULL,
    realm_id character varying(255) NOT NULL,
    group_id character varying(255) NOT NULL,
    name character varying(255) NOT NULL,
    description character varying(4000),
    alias character varying(255) NOT NULL,
    redirect_url character varying(2048)
);


ALTER TABLE public.org OWNER TO valknar;

--
-- Name: org_domain; Type: TABLE; Schema: public; Owner: valknar
--

CREATE TABLE public.org_domain (
    id character varying(36) NOT NULL,
    name character varying(255) NOT NULL,
    verified boolean NOT NULL,
    org_id character varying(255) NOT NULL
);


ALTER TABLE public.org_domain OWNER TO valknar;

--
-- Name: policy_config; Type: TABLE; Schema: public; Owner: valknar
--

CREATE TABLE public.policy_config (
    policy_id character varying(36) NOT NULL,
    name character varying(255) NOT NULL,
    value text
);


ALTER TABLE public.policy_config OWNER TO valknar;

--
-- Name: protocol_mapper; Type: TABLE; Schema: public; Owner: valknar
--

CREATE TABLE public.protocol_mapper (
    id character varying(36) NOT NULL,
    name character varying(255) NOT NULL,
    protocol character varying(255) NOT NULL,
    protocol_mapper_name character varying(255) NOT NULL,
    client_id character varying(36),
    client_scope_id character varying(36)
);


ALTER TABLE public.protocol_mapper OWNER TO valknar;

--
-- Name: protocol_mapper_config; Type: TABLE; Schema: public; Owner: valknar
--

CREATE TABLE public.protocol_mapper_config (
    protocol_mapper_id character varying(36) NOT NULL,
    value text,
    name character varying(255) NOT NULL
);


ALTER TABLE public.protocol_mapper_config OWNER TO valknar;

--
-- Name: realm; Type: TABLE; Schema: public; Owner: valknar
--

CREATE TABLE public.realm (
    id character varying(36) NOT NULL,
    access_code_lifespan integer,
    user_action_lifespan integer,
    access_token_lifespan integer,
    account_theme character varying(255),
    admin_theme character varying(255),
    email_theme character varying(255),
    enabled boolean DEFAULT false NOT NULL,
    events_enabled boolean DEFAULT false NOT NULL,
    events_expiration bigint,
    login_theme character varying(255),
    name character varying(255),
    not_before integer,
    password_policy character varying(2550),
    registration_allowed boolean DEFAULT false NOT NULL,
    remember_me boolean DEFAULT false NOT NULL,
    reset_password_allowed boolean DEFAULT false NOT NULL,
    social boolean DEFAULT false NOT NULL,
    ssl_required character varying(255),
    sso_idle_timeout integer,
    sso_max_lifespan integer,
    update_profile_on_soc_login boolean DEFAULT false NOT NULL,
    verify_email boolean DEFAULT false NOT NULL,
    master_admin_client character varying(36),
    login_lifespan integer,
    internationalization_enabled boolean DEFAULT false NOT NULL,
    default_locale character varying(255),
    reg_email_as_username boolean DEFAULT false NOT NULL,
    admin_events_enabled boolean DEFAULT false NOT NULL,
    admin_events_details_enabled boolean DEFAULT false NOT NULL,
    edit_username_allowed boolean DEFAULT false NOT NULL,
    otp_policy_counter integer DEFAULT 0,
    otp_policy_window integer DEFAULT 1,
    otp_policy_period integer DEFAULT 30,
    otp_policy_digits integer DEFAULT 6,
    otp_policy_alg character varying(36) DEFAULT 'HmacSHA1'::character varying,
    otp_policy_type character varying(36) DEFAULT 'totp'::character varying,
    browser_flow character varying(36),
    registration_flow character varying(36),
    direct_grant_flow character varying(36),
    reset_credentials_flow character varying(36),
    client_auth_flow character varying(36),
    offline_session_idle_timeout integer DEFAULT 0,
    revoke_refresh_token boolean DEFAULT false NOT NULL,
    access_token_life_implicit integer DEFAULT 0,
    login_with_email_allowed boolean DEFAULT true NOT NULL,
    duplicate_emails_allowed boolean DEFAULT false NOT NULL,
    docker_auth_flow character varying(36),
    refresh_token_max_reuse integer DEFAULT 0,
    allow_user_managed_access boolean DEFAULT false NOT NULL,
    sso_max_lifespan_remember_me integer DEFAULT 0 NOT NULL,
    sso_idle_timeout_remember_me integer DEFAULT 0 NOT NULL,
    default_role character varying(255)
);


ALTER TABLE public.realm OWNER TO valknar;

--
-- Name: realm_attribute; Type: TABLE; Schema: public; Owner: valknar
--

CREATE TABLE public.realm_attribute (
    name character varying(255) NOT NULL,
    realm_id character varying(36) NOT NULL,
    value text
);


ALTER TABLE public.realm_attribute OWNER TO valknar;

--
-- Name: realm_default_groups; Type: TABLE; Schema: public; Owner: valknar
--

CREATE TABLE public.realm_default_groups (
    realm_id character varying(36) NOT NULL,
    group_id character varying(36) NOT NULL
);


ALTER TABLE public.realm_default_groups OWNER TO valknar;

--
-- Name: realm_enabled_event_types; Type: TABLE; Schema: public; Owner: valknar
--

CREATE TABLE public.realm_enabled_event_types (
    realm_id character varying(36) NOT NULL,
    value character varying(255) NOT NULL
);


ALTER TABLE public.realm_enabled_event_types OWNER TO valknar;

--
-- Name: realm_events_listeners; Type: TABLE; Schema: public; Owner: valknar
--

CREATE TABLE public.realm_events_listeners (
    realm_id character varying(36) NOT NULL,
    value character varying(255) NOT NULL
);


ALTER TABLE public.realm_events_listeners OWNER TO valknar;

--
-- Name: realm_localizations; Type: TABLE; Schema: public; Owner: valknar
--

CREATE TABLE public.realm_localizations (
    realm_id character varying(255) NOT NULL,
    locale character varying(255) NOT NULL,
    texts text NOT NULL
);


ALTER TABLE public.realm_localizations OWNER TO valknar;

--
-- Name: realm_required_credential; Type: TABLE; Schema: public; Owner: valknar
--

CREATE TABLE public.realm_required_credential (
    type character varying(255) NOT NULL,
    form_label character varying(255),
    input boolean DEFAULT false NOT NULL,
    secret boolean DEFAULT false NOT NULL,
    realm_id character varying(36) NOT NULL
);


ALTER TABLE public.realm_required_credential OWNER TO valknar;

--
-- Name: realm_smtp_config; Type: TABLE; Schema: public; Owner: valknar
--

CREATE TABLE public.realm_smtp_config (
    realm_id character varying(36) NOT NULL,
    value character varying(255),
    name character varying(255) NOT NULL
);


ALTER TABLE public.realm_smtp_config OWNER TO valknar;

--
-- Name: realm_supported_locales; Type: TABLE; Schema: public; Owner: valknar
--

CREATE TABLE public.realm_supported_locales (
    realm_id character varying(36) NOT NULL,
    value character varying(255) NOT NULL
);


ALTER TABLE public.realm_supported_locales OWNER TO valknar;

--
-- Name: redirect_uris; Type: TABLE; Schema: public; Owner: valknar
--

CREATE TABLE public.redirect_uris (
    client_id character varying(36) NOT NULL,
    value character varying(255) NOT NULL
);


ALTER TABLE public.redirect_uris OWNER TO valknar;

--
-- Name: required_action_config; Type: TABLE; Schema: public; Owner: valknar
--

CREATE TABLE public.required_action_config (
    required_action_id character varying(36) NOT NULL,
    value text,
    name character varying(255) NOT NULL
);


ALTER TABLE public.required_action_config OWNER TO valknar;

--
-- Name: required_action_provider; Type: TABLE; Schema: public; Owner: valknar
--

CREATE TABLE public.required_action_provider (
    id character varying(36) NOT NULL,
    alias character varying(255),
    name character varying(255),
    realm_id character varying(36),
    enabled boolean DEFAULT false NOT NULL,
    default_action boolean DEFAULT false NOT NULL,
    provider_id character varying(255),
    priority integer
);


ALTER TABLE public.required_action_provider OWNER TO valknar;

--
-- Name: resource_attribute; Type: TABLE; Schema: public; Owner: valknar
--

CREATE TABLE public.resource_attribute (
    id character varying(36) DEFAULT 'sybase-needs-something-here'::character varying NOT NULL,
    name character varying(255) NOT NULL,
    value character varying(255),
    resource_id character varying(36) NOT NULL
);


ALTER TABLE public.resource_attribute OWNER TO valknar;

--
-- Name: resource_policy; Type: TABLE; Schema: public; Owner: valknar
--

CREATE TABLE public.resource_policy (
    resource_id character varying(36) NOT NULL,
    policy_id character varying(36) NOT NULL
);


ALTER TABLE public.resource_policy OWNER TO valknar;

--
-- Name: resource_scope; Type: TABLE; Schema: public; Owner: valknar
--

CREATE TABLE public.resource_scope (
    resource_id character varying(36) NOT NULL,
    scope_id character varying(36) NOT NULL
);


ALTER TABLE public.resource_scope OWNER TO valknar;

--
-- Name: resource_server; Type: TABLE; Schema: public; Owner: valknar
--

CREATE TABLE public.resource_server (
    id character varying(36) NOT NULL,
    allow_rs_remote_mgmt boolean DEFAULT false NOT NULL,
    policy_enforce_mode smallint NOT NULL,
    decision_strategy smallint DEFAULT 1 NOT NULL
);


ALTER TABLE public.resource_server OWNER TO valknar;

--
-- Name: resource_server_perm_ticket; Type: TABLE; Schema: public; Owner: valknar
--

CREATE TABLE public.resource_server_perm_ticket (
    id character varying(36) NOT NULL,
    owner character varying(255) NOT NULL,
    requester character varying(255) NOT NULL,
    created_timestamp bigint NOT NULL,
    granted_timestamp bigint,
    resource_id character varying(36) NOT NULL,
    scope_id character varying(36),
    resource_server_id character varying(36) NOT NULL,
    policy_id character varying(36)
);


ALTER TABLE public.resource_server_perm_ticket OWNER TO valknar;

--
-- Name: resource_server_policy; Type: TABLE; Schema: public; Owner: valknar
--

CREATE TABLE public.resource_server_policy (
    id character varying(36) NOT NULL,
    name character varying(255) NOT NULL,
    description character varying(255),
    type character varying(255) NOT NULL,
    decision_strategy smallint,
    logic smallint,
    resource_server_id character varying(36) NOT NULL,
    owner character varying(255)
);


ALTER TABLE public.resource_server_policy OWNER TO valknar;

--
-- Name: resource_server_resource; Type: TABLE; Schema: public; Owner: valknar
--

CREATE TABLE public.resource_server_resource (
    id character varying(36) NOT NULL,
    name character varying(255) NOT NULL,
    type character varying(255),
    icon_uri character varying(255),
    owner character varying(255) NOT NULL,
    resource_server_id character varying(36) NOT NULL,
    owner_managed_access boolean DEFAULT false NOT NULL,
    display_name character varying(255)
);


ALTER TABLE public.resource_server_resource OWNER TO valknar;

--
-- Name: resource_server_scope; Type: TABLE; Schema: public; Owner: valknar
--

CREATE TABLE public.resource_server_scope (
    id character varying(36) NOT NULL,
    name character varying(255) NOT NULL,
    icon_uri character varying(255),
    resource_server_id character varying(36) NOT NULL,
    display_name character varying(255)
);


ALTER TABLE public.resource_server_scope OWNER TO valknar;

--
-- Name: resource_uris; Type: TABLE; Schema: public; Owner: valknar
--

CREATE TABLE public.resource_uris (
    resource_id character varying(36) NOT NULL,
    value character varying(255) NOT NULL
);


ALTER TABLE public.resource_uris OWNER TO valknar;

--
-- Name: revoked_token; Type: TABLE; Schema: public; Owner: valknar
--

CREATE TABLE public.revoked_token (
    id character varying(255) NOT NULL,
    expire bigint NOT NULL
);


ALTER TABLE public.revoked_token OWNER TO valknar;

--
-- Name: role_attribute; Type: TABLE; Schema: public; Owner: valknar
--

CREATE TABLE public.role_attribute (
    id character varying(36) NOT NULL,
    role_id character varying(36) NOT NULL,
    name character varying(255) NOT NULL,
    value character varying(255)
);


ALTER TABLE public.role_attribute OWNER TO valknar;

--
-- Name: scope_mapping; Type: TABLE; Schema: public; Owner: valknar
--

CREATE TABLE public.scope_mapping (
    client_id character varying(36) NOT NULL,
    role_id character varying(36) NOT NULL
);


ALTER TABLE public.scope_mapping OWNER TO valknar;

--
-- Name: scope_policy; Type: TABLE; Schema: public; Owner: valknar
--

CREATE TABLE public.scope_policy (
    scope_id character varying(36) NOT NULL,
    policy_id character varying(36) NOT NULL
);


ALTER TABLE public.scope_policy OWNER TO valknar;

--
-- Name: server_config; Type: TABLE; Schema: public; Owner: valknar
--

CREATE TABLE public.server_config (
    server_config_key character varying(255) NOT NULL,
    value text NOT NULL,
    version integer DEFAULT 0
);


ALTER TABLE public.server_config OWNER TO valknar;

--
-- Name: user_attribute; Type: TABLE; Schema: public; Owner: valknar
--

CREATE TABLE public.user_attribute (
    name character varying(255) NOT NULL,
    value character varying(255),
    user_id character varying(36) NOT NULL,
    id character varying(36) DEFAULT 'sybase-needs-something-here'::character varying NOT NULL,
    long_value_hash bytea,
    long_value_hash_lower_case bytea,
    long_value text
);


ALTER TABLE public.user_attribute OWNER TO valknar;

--
-- Name: user_consent; Type: TABLE; Schema: public; Owner: valknar
--

CREATE TABLE public.user_consent (
    id character varying(36) NOT NULL,
    client_id character varying(255),
    user_id character varying(36) NOT NULL,
    created_date bigint,
    last_updated_date bigint,
    client_storage_provider character varying(36),
    external_client_id character varying(255)
);


ALTER TABLE public.user_consent OWNER TO valknar;

--
-- Name: user_consent_client_scope; Type: TABLE; Schema: public; Owner: valknar
--

CREATE TABLE public.user_consent_client_scope (
    user_consent_id character varying(36) NOT NULL,
    scope_id character varying(36) NOT NULL
);


ALTER TABLE public.user_consent_client_scope OWNER TO valknar;

--
-- Name: user_entity; Type: TABLE; Schema: public; Owner: valknar
--

CREATE TABLE public.user_entity (
    id character varying(36) NOT NULL,
    email character varying(255),
    email_constraint character varying(255),
    email_verified boolean DEFAULT false NOT NULL,
    enabled boolean DEFAULT false NOT NULL,
    federation_link character varying(255),
    first_name character varying(255),
    last_name character varying(255),
    realm_id character varying(255),
    username character varying(255),
    created_timestamp bigint,
    service_account_client_link character varying(255),
    not_before integer DEFAULT 0 NOT NULL
);


ALTER TABLE public.user_entity OWNER TO valknar;

--
-- Name: user_federation_config; Type: TABLE; Schema: public; Owner: valknar
--

CREATE TABLE public.user_federation_config (
    user_federation_provider_id character varying(36) NOT NULL,
    value character varying(255),
    name character varying(255) NOT NULL
);


ALTER TABLE public.user_federation_config OWNER TO valknar;

--
-- Name: user_federation_mapper; Type: TABLE; Schema: public; Owner: valknar
--

CREATE TABLE public.user_federation_mapper (
    id character varying(36) NOT NULL,
    name character varying(255) NOT NULL,
    federation_provider_id character varying(36) NOT NULL,
    federation_mapper_type character varying(255) NOT NULL,
    realm_id character varying(36) NOT NULL
);


ALTER TABLE public.user_federation_mapper OWNER TO valknar;

--
-- Name: user_federation_mapper_config; Type: TABLE; Schema: public; Owner: valknar
--

CREATE TABLE public.user_federation_mapper_config (
    user_federation_mapper_id character varying(36) CONSTRAINT user_federation_mapper_confi_user_federation_mapper_id_not_null NOT NULL,
    value character varying(255),
    name character varying(255) NOT NULL
);


ALTER TABLE public.user_federation_mapper_config OWNER TO valknar;

--
-- Name: user_federation_provider; Type: TABLE; Schema: public; Owner: valknar
--

CREATE TABLE public.user_federation_provider (
    id character varying(36) NOT NULL,
    changed_sync_period integer,
    display_name character varying(255),
    full_sync_period integer,
    last_sync integer,
    priority integer,
    provider_name character varying(255),
    realm_id character varying(36)
);


ALTER TABLE public.user_federation_provider OWNER TO valknar;

--
-- Name: user_group_membership; Type: TABLE; Schema: public; Owner: valknar
--

CREATE TABLE public.user_group_membership (
    group_id character varying(36) NOT NULL,
    user_id character varying(36) NOT NULL,
    membership_type character varying(255) NOT NULL
);


ALTER TABLE public.user_group_membership OWNER TO valknar;

--
-- Name: user_required_action; Type: TABLE; Schema: public; Owner: valknar
--

CREATE TABLE public.user_required_action (
    user_id character varying(36) NOT NULL,
    required_action character varying(255) DEFAULT ' '::character varying NOT NULL
);


ALTER TABLE public.user_required_action OWNER TO valknar;

--
-- Name: user_role_mapping; Type: TABLE; Schema: public; Owner: valknar
--

CREATE TABLE public.user_role_mapping (
    role_id character varying(255) NOT NULL,
    user_id character varying(36) NOT NULL
);


ALTER TABLE public.user_role_mapping OWNER TO valknar;

--
-- Name: web_origins; Type: TABLE; Schema: public; Owner: valknar
--

CREATE TABLE public.web_origins (
    client_id character varying(36) NOT NULL,
    value character varying(255) NOT NULL
);


ALTER TABLE public.web_origins OWNER TO valknar;

--
-- Name: workflow_state; Type: TABLE; Schema: public; Owner: valknar
--

CREATE TABLE public.workflow_state (
    execution_id character varying(255) NOT NULL,
    resource_id character varying(255) NOT NULL,
    workflow_id character varying(255) NOT NULL,
    workflow_provider_id character varying(255),
    resource_type character varying(255),
    scheduled_step_id character varying(255),
    scheduled_step_timestamp bigint
);


ALTER TABLE public.workflow_state OWNER TO valknar;

--
-- Data for Name: admin_event_entity; Type: TABLE DATA; Schema: public; Owner: valknar
--

COPY public.admin_event_entity (id, admin_event_time, realm_id, operation_type, auth_realm_id, auth_client_id, auth_user_id, ip_address, resource_path, representation, error, resource_type, details_json) FROM stdin;
\.


--
-- Data for Name: associated_policy; Type: TABLE DATA; Schema: public; Owner: valknar
--

COPY public.associated_policy (policy_id, associated_policy_id) FROM stdin;
\.


--
-- Data for Name: authentication_execution; Type: TABLE DATA; Schema: public; Owner: valknar
--

COPY public.authentication_execution (id, alias, authenticator, realm_id, flow_id, requirement, priority, authenticator_flow, auth_flow_id, auth_config) FROM stdin;
cf0408ac-7517-4080-a832-206dd1cc1c89	\N	auth-cookie	8ae4cef1-1f2a-403a-b938-dd85e52895b8	1c97c671-26bf-4449-9528-b9fd25aa754c	2	10	f	\N	\N
c4a684b6-1339-42d7-a8a0-0e25ceaae95c	\N	auth-spnego	8ae4cef1-1f2a-403a-b938-dd85e52895b8	1c97c671-26bf-4449-9528-b9fd25aa754c	3	20	f	\N	\N
7ae0aa12-a00f-4942-a16d-0e6a41e4efca	\N	identity-provider-redirector	8ae4cef1-1f2a-403a-b938-dd85e52895b8	1c97c671-26bf-4449-9528-b9fd25aa754c	2	25	f	\N	\N
74884672-85c0-4e8b-a6aa-d961ba696f3e	\N	\N	8ae4cef1-1f2a-403a-b938-dd85e52895b8	1c97c671-26bf-4449-9528-b9fd25aa754c	2	30	t	8f49e428-3abd-446a-a7c0-cbc4fae3316d	\N
782b0301-6eab-421a-8a2b-1fe36456e3f9	\N	auth-username-password-form	8ae4cef1-1f2a-403a-b938-dd85e52895b8	8f49e428-3abd-446a-a7c0-cbc4fae3316d	0	10	f	\N	\N
307acfa5-906e-476a-bc1a-2eaa05178ace	\N	\N	8ae4cef1-1f2a-403a-b938-dd85e52895b8	8f49e428-3abd-446a-a7c0-cbc4fae3316d	1	20	t	decbfa4c-1505-462a-bf41-17351b1d552f	\N
95409ac8-b51d-464f-aff5-13f5ee98a987	\N	conditional-user-configured	8ae4cef1-1f2a-403a-b938-dd85e52895b8	decbfa4c-1505-462a-bf41-17351b1d552f	0	10	f	\N	\N
c7eb9a75-cb1d-4ba9-b952-b9adbba4cb34	\N	conditional-credential	8ae4cef1-1f2a-403a-b938-dd85e52895b8	decbfa4c-1505-462a-bf41-17351b1d552f	0	20	f	\N	182a16e9-1ae3-45c5-8264-46726092ae1e
0c0c1fc1-8d06-4fc7-b29e-a994454c3fa5	\N	auth-otp-form	8ae4cef1-1f2a-403a-b938-dd85e52895b8	decbfa4c-1505-462a-bf41-17351b1d552f	2	30	f	\N	\N
ebb36668-1b58-455c-af29-545f9fcfa27e	\N	webauthn-authenticator	8ae4cef1-1f2a-403a-b938-dd85e52895b8	decbfa4c-1505-462a-bf41-17351b1d552f	3	40	f	\N	\N
2299a029-4950-41d4-8392-b0bab187e723	\N	auth-recovery-authn-code-form	8ae4cef1-1f2a-403a-b938-dd85e52895b8	decbfa4c-1505-462a-bf41-17351b1d552f	3	50	f	\N	\N
1c0b649e-492d-49db-8875-720ccb884b14	\N	direct-grant-validate-username	8ae4cef1-1f2a-403a-b938-dd85e52895b8	5ae4f742-7c58-4be2-9939-543ba9bd283c	0	10	f	\N	\N
874783e4-c250-43af-9dca-09a33dbd6a54	\N	direct-grant-validate-password	8ae4cef1-1f2a-403a-b938-dd85e52895b8	5ae4f742-7c58-4be2-9939-543ba9bd283c	0	20	f	\N	\N
d0e7e655-3ecb-4e7e-8034-bddd20cc1ea3	\N	\N	8ae4cef1-1f2a-403a-b938-dd85e52895b8	5ae4f742-7c58-4be2-9939-543ba9bd283c	1	30	t	80e1e400-a641-4df7-9aa5-36f74fccd618	\N
676b6ad0-e19a-4254-9085-d18a3f7ac2e5	\N	conditional-user-configured	8ae4cef1-1f2a-403a-b938-dd85e52895b8	80e1e400-a641-4df7-9aa5-36f74fccd618	0	10	f	\N	\N
23256d74-dc4a-41ce-84bb-5ca1c1404d71	\N	direct-grant-validate-otp	8ae4cef1-1f2a-403a-b938-dd85e52895b8	80e1e400-a641-4df7-9aa5-36f74fccd618	0	20	f	\N	\N
b7e80c92-5299-4a1e-9135-3a1c9417caba	\N	registration-page-form	8ae4cef1-1f2a-403a-b938-dd85e52895b8	98626a81-f977-4e16-9bff-0d55a8d7720b	0	10	t	024ac957-014b-476c-a4ec-c4570ca2f080	\N
32cd6ccb-873a-40ef-a5f1-a7a29bef18d7	\N	registration-user-creation	8ae4cef1-1f2a-403a-b938-dd85e52895b8	024ac957-014b-476c-a4ec-c4570ca2f080	0	20	f	\N	\N
4cf9dade-9b7b-4c22-b6ac-f59b6f7da1cf	\N	registration-password-action	8ae4cef1-1f2a-403a-b938-dd85e52895b8	024ac957-014b-476c-a4ec-c4570ca2f080	0	50	f	\N	\N
ebfdef8d-ee21-40c1-b9cf-c0577f9109c0	\N	registration-recaptcha-action	8ae4cef1-1f2a-403a-b938-dd85e52895b8	024ac957-014b-476c-a4ec-c4570ca2f080	3	60	f	\N	\N
816036b1-2554-4dc0-87b1-b78ecf6fb944	\N	registration-terms-and-conditions	8ae4cef1-1f2a-403a-b938-dd85e52895b8	024ac957-014b-476c-a4ec-c4570ca2f080	3	70	f	\N	\N
d06b2866-2685-4ba5-b3f0-657a7f5e1986	\N	reset-credentials-choose-user	8ae4cef1-1f2a-403a-b938-dd85e52895b8	9ad95dc3-2e49-483f-8994-41c47899c63c	0	10	f	\N	\N
5697e325-7fe3-414b-b072-e6daedc3ecea	\N	reset-credential-email	8ae4cef1-1f2a-403a-b938-dd85e52895b8	9ad95dc3-2e49-483f-8994-41c47899c63c	0	20	f	\N	\N
706c7bcf-4105-427e-b468-ac3fcf66df0d	\N	reset-password	8ae4cef1-1f2a-403a-b938-dd85e52895b8	9ad95dc3-2e49-483f-8994-41c47899c63c	0	30	f	\N	\N
2897b41f-2a1b-4379-8d9c-e82a21b508b5	\N	\N	8ae4cef1-1f2a-403a-b938-dd85e52895b8	9ad95dc3-2e49-483f-8994-41c47899c63c	1	40	t	fdf6fffc-459a-46ce-a346-0371ab62e663	\N
abc0e0ff-04b1-4bbe-8a67-57e69ac55194	\N	conditional-user-configured	8ae4cef1-1f2a-403a-b938-dd85e52895b8	fdf6fffc-459a-46ce-a346-0371ab62e663	0	10	f	\N	\N
a36fa7be-398f-4546-850d-c64a5499ec75	\N	reset-otp	8ae4cef1-1f2a-403a-b938-dd85e52895b8	fdf6fffc-459a-46ce-a346-0371ab62e663	0	20	f	\N	\N
4c2bc1bf-bed6-45b6-9a96-cee5a158ba54	\N	client-secret	8ae4cef1-1f2a-403a-b938-dd85e52895b8	decb04b4-e101-4695-a9f6-6fee96e74b95	2	10	f	\N	\N
c0ef037b-50c5-4323-9191-6fef282e4fb2	\N	client-jwt	8ae4cef1-1f2a-403a-b938-dd85e52895b8	decb04b4-e101-4695-a9f6-6fee96e74b95	2	20	f	\N	\N
8a4f2f9c-4a03-4c2b-af71-84aaf1c51dcc	\N	client-secret-jwt	8ae4cef1-1f2a-403a-b938-dd85e52895b8	decb04b4-e101-4695-a9f6-6fee96e74b95	2	30	f	\N	\N
cfffc736-da3b-49f6-ad2e-cf4f35bbe4b0	\N	client-x509	8ae4cef1-1f2a-403a-b938-dd85e52895b8	decb04b4-e101-4695-a9f6-6fee96e74b95	2	40	f	\N	\N
2c2f2a62-6817-4bfb-a49d-9a489c64b554	\N	idp-review-profile	8ae4cef1-1f2a-403a-b938-dd85e52895b8	5ae02b08-ea69-4577-8cd4-4c7ec491bdeb	0	10	f	\N	b17611cf-8729-45d5-a5b7-5fc7f9f0b523
ecda0b48-d50c-4192-acf7-c7238e70171a	\N	\N	8ae4cef1-1f2a-403a-b938-dd85e52895b8	5ae02b08-ea69-4577-8cd4-4c7ec491bdeb	0	20	t	cecb05fa-33d2-43e0-a1d1-5b99c8661042	\N
d62fcd53-b197-4452-a7c7-308f59d394ee	\N	idp-create-user-if-unique	8ae4cef1-1f2a-403a-b938-dd85e52895b8	cecb05fa-33d2-43e0-a1d1-5b99c8661042	2	10	f	\N	71feb8cd-94c7-47d5-bf70-bdf8bb4e190d
0183f30f-5f3d-411c-b946-d3ed9ce4349e	\N	\N	8ae4cef1-1f2a-403a-b938-dd85e52895b8	cecb05fa-33d2-43e0-a1d1-5b99c8661042	2	20	t	74998410-e822-4b68-ab35-c634cd8edfa6	\N
30c5edd2-cd18-414f-a561-36bacac79aa9	\N	idp-confirm-link	8ae4cef1-1f2a-403a-b938-dd85e52895b8	74998410-e822-4b68-ab35-c634cd8edfa6	0	10	f	\N	\N
9336d54f-c83c-49d0-ab1f-ebccdcc9fd9c	\N	\N	8ae4cef1-1f2a-403a-b938-dd85e52895b8	74998410-e822-4b68-ab35-c634cd8edfa6	0	20	t	87872295-cb9a-4a3d-ad9a-b3d80ec84728	\N
f04bf85f-1e03-422f-9b30-432783e5f11a	\N	idp-email-verification	8ae4cef1-1f2a-403a-b938-dd85e52895b8	87872295-cb9a-4a3d-ad9a-b3d80ec84728	2	10	f	\N	\N
df69becd-1d4a-460d-aa4a-e3bf8f299eab	\N	\N	8ae4cef1-1f2a-403a-b938-dd85e52895b8	87872295-cb9a-4a3d-ad9a-b3d80ec84728	2	20	t	2d32d8fc-643a-4345-ac25-09295d9cc568	\N
35d4d8dd-2a6e-4581-ba28-bfb7f2144235	\N	idp-username-password-form	8ae4cef1-1f2a-403a-b938-dd85e52895b8	2d32d8fc-643a-4345-ac25-09295d9cc568	0	10	f	\N	\N
050d95e7-f8c6-4cfb-b6d7-39dc97b85534	\N	\N	8ae4cef1-1f2a-403a-b938-dd85e52895b8	2d32d8fc-643a-4345-ac25-09295d9cc568	1	20	t	46575fdd-e29b-4815-848f-51f3d9bc85ef	\N
ec83769f-69dd-45dc-a141-b994ccb7c286	\N	conditional-user-configured	8ae4cef1-1f2a-403a-b938-dd85e52895b8	46575fdd-e29b-4815-848f-51f3d9bc85ef	0	10	f	\N	\N
1755a2e6-d9dd-46a6-9d83-f78e5080e48d	\N	conditional-credential	8ae4cef1-1f2a-403a-b938-dd85e52895b8	46575fdd-e29b-4815-848f-51f3d9bc85ef	0	20	f	\N	0ffb60f6-7c05-4891-844f-21668876f82f
4f6bc81d-2cab-45f7-85b6-bc1b6ea4dbce	\N	auth-otp-form	8ae4cef1-1f2a-403a-b938-dd85e52895b8	46575fdd-e29b-4815-848f-51f3d9bc85ef	2	30	f	\N	\N
1f393a04-b671-400d-bdd4-26c0640b9723	\N	webauthn-authenticator	8ae4cef1-1f2a-403a-b938-dd85e52895b8	46575fdd-e29b-4815-848f-51f3d9bc85ef	3	40	f	\N	\N
b05c48e8-0235-4ea7-93d7-594516d98931	\N	auth-recovery-authn-code-form	8ae4cef1-1f2a-403a-b938-dd85e52895b8	46575fdd-e29b-4815-848f-51f3d9bc85ef	3	50	f	\N	\N
7def557e-d75b-4eee-afe6-5238ed64a88e	\N	http-basic-authenticator	8ae4cef1-1f2a-403a-b938-dd85e52895b8	8241f734-7dc4-4059-8fd9-12aec0ad1d88	0	10	f	\N	\N
ebdf189b-80ca-487b-a643-383e3bb128f9	\N	docker-http-basic-authenticator	8ae4cef1-1f2a-403a-b938-dd85e52895b8	8cf5860b-52ca-4e22-a464-5b42ed97c657	0	10	f	\N	\N
def76156-eb6d-4a84-899e-dcb836e92738	\N	auth-cookie	460a8e4b-5528-439c-ae10-29c984c7e8f5	2e8d9ca2-b141-486e-9526-66ab9f319c55	2	10	f	\N	\N
8822ab49-a8cc-4820-a8b0-c3dd4712d1cb	\N	auth-spnego	460a8e4b-5528-439c-ae10-29c984c7e8f5	2e8d9ca2-b141-486e-9526-66ab9f319c55	3	20	f	\N	\N
3c3023b5-a13e-4531-a9b8-cecb5f9e8975	\N	identity-provider-redirector	460a8e4b-5528-439c-ae10-29c984c7e8f5	2e8d9ca2-b141-486e-9526-66ab9f319c55	2	25	f	\N	\N
1e0cae2c-8a4b-4a36-ab66-c0af16a5bd9f	\N	\N	460a8e4b-5528-439c-ae10-29c984c7e8f5	2e8d9ca2-b141-486e-9526-66ab9f319c55	2	30	t	e7ce8dff-4eff-45c6-9b92-e3bd036ac590	\N
e90ef313-3a24-4e8a-87ba-b90645c06c2e	\N	auth-username-password-form	460a8e4b-5528-439c-ae10-29c984c7e8f5	e7ce8dff-4eff-45c6-9b92-e3bd036ac590	0	10	f	\N	\N
f98f6839-27db-4bbe-8066-6bc1b2d59eb3	\N	\N	460a8e4b-5528-439c-ae10-29c984c7e8f5	e7ce8dff-4eff-45c6-9b92-e3bd036ac590	1	20	t	b7ef2750-baac-4b04-9bd1-0f4411f7af83	\N
1fec46e0-cce2-49d6-83e5-358d9cdbc1f2	\N	conditional-user-configured	460a8e4b-5528-439c-ae10-29c984c7e8f5	b7ef2750-baac-4b04-9bd1-0f4411f7af83	0	10	f	\N	\N
85e149b1-66e7-4fef-b31a-86960cad3dd9	\N	conditional-credential	460a8e4b-5528-439c-ae10-29c984c7e8f5	b7ef2750-baac-4b04-9bd1-0f4411f7af83	0	20	f	\N	5cc0e74a-c50b-454a-a4c8-3e3116a0a073
9c8972ca-1cbf-411f-a3ab-d2f0a0bbc6d7	\N	auth-otp-form	460a8e4b-5528-439c-ae10-29c984c7e8f5	b7ef2750-baac-4b04-9bd1-0f4411f7af83	2	30	f	\N	\N
49df1c3f-545b-41ef-9e20-62fa9f997cf0	\N	webauthn-authenticator	460a8e4b-5528-439c-ae10-29c984c7e8f5	b7ef2750-baac-4b04-9bd1-0f4411f7af83	3	40	f	\N	\N
c1c058b5-a686-42bd-94ce-b0656d9d11eb	\N	auth-recovery-authn-code-form	460a8e4b-5528-439c-ae10-29c984c7e8f5	b7ef2750-baac-4b04-9bd1-0f4411f7af83	3	50	f	\N	\N
be487d99-04e3-4d53-91e0-79e9150f1376	\N	\N	460a8e4b-5528-439c-ae10-29c984c7e8f5	2e8d9ca2-b141-486e-9526-66ab9f319c55	2	26	t	3bcf8aef-3be9-4c78-a4e4-896c27db9f46	\N
987e5747-2ef1-46a0-88ca-8a52cd3833d3	\N	\N	460a8e4b-5528-439c-ae10-29c984c7e8f5	3bcf8aef-3be9-4c78-a4e4-896c27db9f46	1	10	t	0adf1974-fb3f-4a73-ba47-00447bce5024	\N
8141c8a1-c5da-43d5-93b7-80494c169b21	\N	conditional-user-configured	460a8e4b-5528-439c-ae10-29c984c7e8f5	0adf1974-fb3f-4a73-ba47-00447bce5024	0	10	f	\N	\N
3913a293-f2f8-477a-839e-89ea0d761327	\N	organization	460a8e4b-5528-439c-ae10-29c984c7e8f5	0adf1974-fb3f-4a73-ba47-00447bce5024	2	20	f	\N	\N
f7f41900-a291-494a-b858-c27b1d2cf0c6	\N	direct-grant-validate-username	460a8e4b-5528-439c-ae10-29c984c7e8f5	cda6e8d0-e4b9-4dc2-85db-e800283bcc57	0	10	f	\N	\N
6f0cb484-3f79-40e0-939a-e4586ed19158	\N	direct-grant-validate-password	460a8e4b-5528-439c-ae10-29c984c7e8f5	cda6e8d0-e4b9-4dc2-85db-e800283bcc57	0	20	f	\N	\N
265c48ba-64eb-4284-b5a5-6c210412b03a	\N	\N	460a8e4b-5528-439c-ae10-29c984c7e8f5	cda6e8d0-e4b9-4dc2-85db-e800283bcc57	1	30	t	fe145775-e770-4362-b61f-28bb78dac11a	\N
21845536-eefd-4922-99b4-eaf789fcb674	\N	conditional-user-configured	460a8e4b-5528-439c-ae10-29c984c7e8f5	fe145775-e770-4362-b61f-28bb78dac11a	0	10	f	\N	\N
46c50e3b-d955-4be5-8d66-c2ef7c19b730	\N	direct-grant-validate-otp	460a8e4b-5528-439c-ae10-29c984c7e8f5	fe145775-e770-4362-b61f-28bb78dac11a	0	20	f	\N	\N
b50cb395-78ee-4770-9fda-136bced15116	\N	registration-page-form	460a8e4b-5528-439c-ae10-29c984c7e8f5	ce2ae5e6-af09-4248-9a5a-7394b862888c	0	10	t	bb09d1ab-0d16-4178-a6fa-065a064d22d0	\N
d3f0ffff-4da2-4a50-8f59-38e0a547c319	\N	registration-user-creation	460a8e4b-5528-439c-ae10-29c984c7e8f5	bb09d1ab-0d16-4178-a6fa-065a064d22d0	0	20	f	\N	\N
8a7b01e4-0f06-4c60-8c41-d60cbea21b2f	\N	registration-password-action	460a8e4b-5528-439c-ae10-29c984c7e8f5	bb09d1ab-0d16-4178-a6fa-065a064d22d0	0	50	f	\N	\N
864e2982-bb2d-4de2-88d7-92b4bd9dd24d	\N	registration-recaptcha-action	460a8e4b-5528-439c-ae10-29c984c7e8f5	bb09d1ab-0d16-4178-a6fa-065a064d22d0	3	60	f	\N	\N
4fe43099-71a8-4d78-84be-a289a9197afc	\N	registration-terms-and-conditions	460a8e4b-5528-439c-ae10-29c984c7e8f5	bb09d1ab-0d16-4178-a6fa-065a064d22d0	3	70	f	\N	\N
18e98bd2-65ea-4b55-9cea-b2e9554b5eb9	\N	reset-credentials-choose-user	460a8e4b-5528-439c-ae10-29c984c7e8f5	82c2a7d3-de01-4329-a04d-4adc75754523	0	10	f	\N	\N
80aa9f2c-8a8b-44e7-9c8e-aec5fed9d636	\N	reset-credential-email	460a8e4b-5528-439c-ae10-29c984c7e8f5	82c2a7d3-de01-4329-a04d-4adc75754523	0	20	f	\N	\N
7388a8b2-5fff-4c6d-a6bc-92cb71a689e0	\N	reset-password	460a8e4b-5528-439c-ae10-29c984c7e8f5	82c2a7d3-de01-4329-a04d-4adc75754523	0	30	f	\N	\N
b24b276b-dd96-4f20-969b-99591a28fc4f	\N	\N	460a8e4b-5528-439c-ae10-29c984c7e8f5	82c2a7d3-de01-4329-a04d-4adc75754523	1	40	t	35b6b497-3fed-4016-b4ee-aa0bdfed46ef	\N
89a4ca24-d35d-4176-8287-3538a9f55315	\N	conditional-user-configured	460a8e4b-5528-439c-ae10-29c984c7e8f5	35b6b497-3fed-4016-b4ee-aa0bdfed46ef	0	10	f	\N	\N
1b4f7086-c822-4c9f-b4e6-2fd94519cce8	\N	reset-otp	460a8e4b-5528-439c-ae10-29c984c7e8f5	35b6b497-3fed-4016-b4ee-aa0bdfed46ef	0	20	f	\N	\N
d7e98dfb-f736-4975-b5a1-ffe810fdfe19	\N	client-secret	460a8e4b-5528-439c-ae10-29c984c7e8f5	3ae459b1-c80d-45ab-823c-f0af87b8a86b	2	10	f	\N	\N
d30949aa-fcb6-472e-9ab5-dee097d81576	\N	client-jwt	460a8e4b-5528-439c-ae10-29c984c7e8f5	3ae459b1-c80d-45ab-823c-f0af87b8a86b	2	20	f	\N	\N
5dda6e8d-745a-4e25-a357-1b831c1c51cb	\N	client-secret-jwt	460a8e4b-5528-439c-ae10-29c984c7e8f5	3ae459b1-c80d-45ab-823c-f0af87b8a86b	2	30	f	\N	\N
b0a1c9e6-5002-4c8c-87f1-4db285720aa3	\N	client-x509	460a8e4b-5528-439c-ae10-29c984c7e8f5	3ae459b1-c80d-45ab-823c-f0af87b8a86b	2	40	f	\N	\N
d4d0e91b-8b2f-4117-a064-2d93249332ab	\N	idp-review-profile	460a8e4b-5528-439c-ae10-29c984c7e8f5	446b3bf0-4a92-493e-bcab-5abb61382765	0	10	f	\N	28fd1d12-a67e-4200-9096-98cdaf2e7dab
5a68d471-5f26-4cff-a565-ce10b9c4a690	\N	\N	460a8e4b-5528-439c-ae10-29c984c7e8f5	446b3bf0-4a92-493e-bcab-5abb61382765	0	20	t	1da17f65-d77f-4834-a806-53e34647f6f8	\N
17d9ad9c-b060-4332-ae39-6bec4251d5c8	\N	idp-create-user-if-unique	460a8e4b-5528-439c-ae10-29c984c7e8f5	1da17f65-d77f-4834-a806-53e34647f6f8	2	10	f	\N	83be0c6e-b69c-42cc-9c28-a87bdb481707
32871de8-1d3b-4873-99b1-3db0c2746716	\N	\N	460a8e4b-5528-439c-ae10-29c984c7e8f5	1da17f65-d77f-4834-a806-53e34647f6f8	2	20	t	d61c1134-b958-44f4-83da-cad8795e584e	\N
073311dc-2376-4f84-9b4d-092611eacec8	\N	idp-confirm-link	460a8e4b-5528-439c-ae10-29c984c7e8f5	d61c1134-b958-44f4-83da-cad8795e584e	0	10	f	\N	\N
93ecd156-108b-49ae-8dac-81c64f631f0a	\N	\N	460a8e4b-5528-439c-ae10-29c984c7e8f5	d61c1134-b958-44f4-83da-cad8795e584e	0	20	t	c7be51e4-af41-4080-a358-37f1ac25a010	\N
a168cd04-cda9-40c9-b6d9-b64652a7e4f6	\N	idp-email-verification	460a8e4b-5528-439c-ae10-29c984c7e8f5	c7be51e4-af41-4080-a358-37f1ac25a010	2	10	f	\N	\N
49f98fef-4ca7-4738-843e-0dc37214836f	\N	\N	460a8e4b-5528-439c-ae10-29c984c7e8f5	c7be51e4-af41-4080-a358-37f1ac25a010	2	20	t	bd3e170d-432b-494e-aa5c-23f3655ebead	\N
7d0b2080-e308-43bc-8ad2-266890460c8e	\N	idp-username-password-form	460a8e4b-5528-439c-ae10-29c984c7e8f5	bd3e170d-432b-494e-aa5c-23f3655ebead	0	10	f	\N	\N
a2edf769-0906-4638-b896-62164ff2c3f2	\N	\N	460a8e4b-5528-439c-ae10-29c984c7e8f5	bd3e170d-432b-494e-aa5c-23f3655ebead	1	20	t	2ba3fdbb-df3a-4f3e-b2a5-9f6e0ea2335d	\N
46b11d70-baf9-4af9-9ab1-e6e09935fe3c	\N	conditional-user-configured	460a8e4b-5528-439c-ae10-29c984c7e8f5	2ba3fdbb-df3a-4f3e-b2a5-9f6e0ea2335d	0	10	f	\N	\N
9b525ac2-9fd5-4ec2-8f6e-0fd0a7e562c5	\N	conditional-credential	460a8e4b-5528-439c-ae10-29c984c7e8f5	2ba3fdbb-df3a-4f3e-b2a5-9f6e0ea2335d	0	20	f	\N	89f4330a-70bb-473d-bdce-cfe42e09d0c9
5de58fa1-8f33-41bf-b133-7499253e7021	\N	auth-otp-form	460a8e4b-5528-439c-ae10-29c984c7e8f5	2ba3fdbb-df3a-4f3e-b2a5-9f6e0ea2335d	2	30	f	\N	\N
96c4a907-7ada-4ddb-9130-92d7e29ac6f1	\N	webauthn-authenticator	460a8e4b-5528-439c-ae10-29c984c7e8f5	2ba3fdbb-df3a-4f3e-b2a5-9f6e0ea2335d	3	40	f	\N	\N
4b320439-d6a2-47a4-af64-076d211cf809	\N	auth-recovery-authn-code-form	460a8e4b-5528-439c-ae10-29c984c7e8f5	2ba3fdbb-df3a-4f3e-b2a5-9f6e0ea2335d	3	50	f	\N	\N
27c98c74-4b9e-42aa-9b10-61921951787f	\N	\N	460a8e4b-5528-439c-ae10-29c984c7e8f5	446b3bf0-4a92-493e-bcab-5abb61382765	1	60	t	991cdb30-1835-40fe-8a18-2555a8e7baec	\N
bac63d57-024f-47ce-8b2c-fe5e3dd2cc2f	\N	conditional-user-configured	460a8e4b-5528-439c-ae10-29c984c7e8f5	991cdb30-1835-40fe-8a18-2555a8e7baec	0	10	f	\N	\N
bac77766-821d-4e5b-a680-cf2c3c651a3a	\N	idp-add-organization-member	460a8e4b-5528-439c-ae10-29c984c7e8f5	991cdb30-1835-40fe-8a18-2555a8e7baec	0	20	f	\N	\N
2e0fdb00-c947-4249-85d2-5e14f5c57441	\N	http-basic-authenticator	460a8e4b-5528-439c-ae10-29c984c7e8f5	a7f4ebac-6de4-4ffc-8126-839d319c393d	0	10	f	\N	\N
d6d763ed-2db4-4c26-81c4-c0d3f532663b	\N	docker-http-basic-authenticator	460a8e4b-5528-439c-ae10-29c984c7e8f5	5e435919-6dbd-45ad-ac50-86befa2e48d8	0	10	f	\N	\N
\.


--
-- Data for Name: authentication_flow; Type: TABLE DATA; Schema: public; Owner: valknar
--

COPY public.authentication_flow (id, alias, description, realm_id, provider_id, top_level, built_in) FROM stdin;
1c97c671-26bf-4449-9528-b9fd25aa754c	browser	Browser based authentication	8ae4cef1-1f2a-403a-b938-dd85e52895b8	basic-flow	t	t
8f49e428-3abd-446a-a7c0-cbc4fae3316d	forms	Username, password, otp and other auth forms.	8ae4cef1-1f2a-403a-b938-dd85e52895b8	basic-flow	f	t
decbfa4c-1505-462a-bf41-17351b1d552f	Browser - Conditional 2FA	Flow to determine if any 2FA is required for the authentication	8ae4cef1-1f2a-403a-b938-dd85e52895b8	basic-flow	f	t
5ae4f742-7c58-4be2-9939-543ba9bd283c	direct grant	OpenID Connect Resource Owner Grant	8ae4cef1-1f2a-403a-b938-dd85e52895b8	basic-flow	t	t
80e1e400-a641-4df7-9aa5-36f74fccd618	Direct Grant - Conditional OTP	Flow to determine if the OTP is required for the authentication	8ae4cef1-1f2a-403a-b938-dd85e52895b8	basic-flow	f	t
98626a81-f977-4e16-9bff-0d55a8d7720b	registration	Registration flow	8ae4cef1-1f2a-403a-b938-dd85e52895b8	basic-flow	t	t
024ac957-014b-476c-a4ec-c4570ca2f080	registration form	Registration form	8ae4cef1-1f2a-403a-b938-dd85e52895b8	form-flow	f	t
9ad95dc3-2e49-483f-8994-41c47899c63c	reset credentials	Reset credentials for a user if they forgot their password or something	8ae4cef1-1f2a-403a-b938-dd85e52895b8	basic-flow	t	t
fdf6fffc-459a-46ce-a346-0371ab62e663	Reset - Conditional OTP	Flow to determine if the OTP should be reset or not. Set to REQUIRED to force.	8ae4cef1-1f2a-403a-b938-dd85e52895b8	basic-flow	f	t
decb04b4-e101-4695-a9f6-6fee96e74b95	clients	Base authentication for clients	8ae4cef1-1f2a-403a-b938-dd85e52895b8	client-flow	t	t
5ae02b08-ea69-4577-8cd4-4c7ec491bdeb	first broker login	Actions taken after first broker login with identity provider account, which is not yet linked to any Keycloak account	8ae4cef1-1f2a-403a-b938-dd85e52895b8	basic-flow	t	t
cecb05fa-33d2-43e0-a1d1-5b99c8661042	User creation or linking	Flow for the existing/non-existing user alternatives	8ae4cef1-1f2a-403a-b938-dd85e52895b8	basic-flow	f	t
74998410-e822-4b68-ab35-c634cd8edfa6	Handle Existing Account	Handle what to do if there is existing account with same email/username like authenticated identity provider	8ae4cef1-1f2a-403a-b938-dd85e52895b8	basic-flow	f	t
87872295-cb9a-4a3d-ad9a-b3d80ec84728	Account verification options	Method with which to verity the existing account	8ae4cef1-1f2a-403a-b938-dd85e52895b8	basic-flow	f	t
2d32d8fc-643a-4345-ac25-09295d9cc568	Verify Existing Account by Re-authentication	Reauthentication of existing account	8ae4cef1-1f2a-403a-b938-dd85e52895b8	basic-flow	f	t
46575fdd-e29b-4815-848f-51f3d9bc85ef	First broker login - Conditional 2FA	Flow to determine if any 2FA is required for the authentication	8ae4cef1-1f2a-403a-b938-dd85e52895b8	basic-flow	f	t
8241f734-7dc4-4059-8fd9-12aec0ad1d88	saml ecp	SAML ECP Profile Authentication Flow	8ae4cef1-1f2a-403a-b938-dd85e52895b8	basic-flow	t	t
8cf5860b-52ca-4e22-a464-5b42ed97c657	docker auth	Used by Docker clients to authenticate against the IDP	8ae4cef1-1f2a-403a-b938-dd85e52895b8	basic-flow	t	t
2e8d9ca2-b141-486e-9526-66ab9f319c55	browser	Browser based authentication	460a8e4b-5528-439c-ae10-29c984c7e8f5	basic-flow	t	t
e7ce8dff-4eff-45c6-9b92-e3bd036ac590	forms	Username, password, otp and other auth forms.	460a8e4b-5528-439c-ae10-29c984c7e8f5	basic-flow	f	t
b7ef2750-baac-4b04-9bd1-0f4411f7af83	Browser - Conditional 2FA	Flow to determine if any 2FA is required for the authentication	460a8e4b-5528-439c-ae10-29c984c7e8f5	basic-flow	f	t
3bcf8aef-3be9-4c78-a4e4-896c27db9f46	Organization	\N	460a8e4b-5528-439c-ae10-29c984c7e8f5	basic-flow	f	t
0adf1974-fb3f-4a73-ba47-00447bce5024	Browser - Conditional Organization	Flow to determine if the organization identity-first login is to be used	460a8e4b-5528-439c-ae10-29c984c7e8f5	basic-flow	f	t
cda6e8d0-e4b9-4dc2-85db-e800283bcc57	direct grant	OpenID Connect Resource Owner Grant	460a8e4b-5528-439c-ae10-29c984c7e8f5	basic-flow	t	t
fe145775-e770-4362-b61f-28bb78dac11a	Direct Grant - Conditional OTP	Flow to determine if the OTP is required for the authentication	460a8e4b-5528-439c-ae10-29c984c7e8f5	basic-flow	f	t
ce2ae5e6-af09-4248-9a5a-7394b862888c	registration	Registration flow	460a8e4b-5528-439c-ae10-29c984c7e8f5	basic-flow	t	t
bb09d1ab-0d16-4178-a6fa-065a064d22d0	registration form	Registration form	460a8e4b-5528-439c-ae10-29c984c7e8f5	form-flow	f	t
82c2a7d3-de01-4329-a04d-4adc75754523	reset credentials	Reset credentials for a user if they forgot their password or something	460a8e4b-5528-439c-ae10-29c984c7e8f5	basic-flow	t	t
35b6b497-3fed-4016-b4ee-aa0bdfed46ef	Reset - Conditional OTP	Flow to determine if the OTP should be reset or not. Set to REQUIRED to force.	460a8e4b-5528-439c-ae10-29c984c7e8f5	basic-flow	f	t
3ae459b1-c80d-45ab-823c-f0af87b8a86b	clients	Base authentication for clients	460a8e4b-5528-439c-ae10-29c984c7e8f5	client-flow	t	t
446b3bf0-4a92-493e-bcab-5abb61382765	first broker login	Actions taken after first broker login with identity provider account, which is not yet linked to any Keycloak account	460a8e4b-5528-439c-ae10-29c984c7e8f5	basic-flow	t	t
1da17f65-d77f-4834-a806-53e34647f6f8	User creation or linking	Flow for the existing/non-existing user alternatives	460a8e4b-5528-439c-ae10-29c984c7e8f5	basic-flow	f	t
d61c1134-b958-44f4-83da-cad8795e584e	Handle Existing Account	Handle what to do if there is existing account with same email/username like authenticated identity provider	460a8e4b-5528-439c-ae10-29c984c7e8f5	basic-flow	f	t
c7be51e4-af41-4080-a358-37f1ac25a010	Account verification options	Method with which to verity the existing account	460a8e4b-5528-439c-ae10-29c984c7e8f5	basic-flow	f	t
bd3e170d-432b-494e-aa5c-23f3655ebead	Verify Existing Account by Re-authentication	Reauthentication of existing account	460a8e4b-5528-439c-ae10-29c984c7e8f5	basic-flow	f	t
2ba3fdbb-df3a-4f3e-b2a5-9f6e0ea2335d	First broker login - Conditional 2FA	Flow to determine if any 2FA is required for the authentication	460a8e4b-5528-439c-ae10-29c984c7e8f5	basic-flow	f	t
991cdb30-1835-40fe-8a18-2555a8e7baec	First Broker Login - Conditional Organization	Flow to determine if the authenticator that adds organization members is to be used	460a8e4b-5528-439c-ae10-29c984c7e8f5	basic-flow	f	t
a7f4ebac-6de4-4ffc-8126-839d319c393d	saml ecp	SAML ECP Profile Authentication Flow	460a8e4b-5528-439c-ae10-29c984c7e8f5	basic-flow	t	t
5e435919-6dbd-45ad-ac50-86befa2e48d8	docker auth	Used by Docker clients to authenticate against the IDP	460a8e4b-5528-439c-ae10-29c984c7e8f5	basic-flow	t	t
\.


--
-- Data for Name: authenticator_config; Type: TABLE DATA; Schema: public; Owner: valknar
--

COPY public.authenticator_config (id, alias, realm_id) FROM stdin;
182a16e9-1ae3-45c5-8264-46726092ae1e	browser-conditional-credential	8ae4cef1-1f2a-403a-b938-dd85e52895b8
b17611cf-8729-45d5-a5b7-5fc7f9f0b523	review profile config	8ae4cef1-1f2a-403a-b938-dd85e52895b8
71feb8cd-94c7-47d5-bf70-bdf8bb4e190d	create unique user config	8ae4cef1-1f2a-403a-b938-dd85e52895b8
0ffb60f6-7c05-4891-844f-21668876f82f	first-broker-login-conditional-credential	8ae4cef1-1f2a-403a-b938-dd85e52895b8
5cc0e74a-c50b-454a-a4c8-3e3116a0a073	browser-conditional-credential	460a8e4b-5528-439c-ae10-29c984c7e8f5
28fd1d12-a67e-4200-9096-98cdaf2e7dab	review profile config	460a8e4b-5528-439c-ae10-29c984c7e8f5
83be0c6e-b69c-42cc-9c28-a87bdb481707	create unique user config	460a8e4b-5528-439c-ae10-29c984c7e8f5
89f4330a-70bb-473d-bdce-cfe42e09d0c9	first-broker-login-conditional-credential	460a8e4b-5528-439c-ae10-29c984c7e8f5
\.


--
-- Data for Name: authenticator_config_entry; Type: TABLE DATA; Schema: public; Owner: valknar
--

COPY public.authenticator_config_entry (authenticator_id, value, name) FROM stdin;
0ffb60f6-7c05-4891-844f-21668876f82f	webauthn-passwordless	credentials
182a16e9-1ae3-45c5-8264-46726092ae1e	webauthn-passwordless	credentials
71feb8cd-94c7-47d5-bf70-bdf8bb4e190d	false	require.password.update.after.registration
b17611cf-8729-45d5-a5b7-5fc7f9f0b523	missing	update.profile.on.first.login
28fd1d12-a67e-4200-9096-98cdaf2e7dab	missing	update.profile.on.first.login
5cc0e74a-c50b-454a-a4c8-3e3116a0a073	webauthn-passwordless	credentials
83be0c6e-b69c-42cc-9c28-a87bdb481707	false	require.password.update.after.registration
89f4330a-70bb-473d-bdce-cfe42e09d0c9	webauthn-passwordless	credentials
\.


--
-- Data for Name: broker_link; Type: TABLE DATA; Schema: public; Owner: valknar
--

COPY public.broker_link (identity_provider, storage_provider_id, realm_id, broker_user_id, broker_username, token, user_id) FROM stdin;
\.


--
-- Data for Name: client; Type: TABLE DATA; Schema: public; Owner: valknar
--

COPY public.client (id, enabled, full_scope_allowed, client_id, not_before, public_client, secret, base_url, bearer_only, management_url, surrogate_auth_required, realm_id, protocol, node_rereg_timeout, frontchannel_logout, consent_required, name, service_accounts_enabled, client_authenticator_type, root_url, description, registration_token, standard_flow_enabled, implicit_flow_enabled, direct_access_grants_enabled, always_display_in_console) FROM stdin;
2ba16542-30d0-449e-aca5-25498bcbbaf0	t	f	master-realm	0	f	\N	\N	t	\N	f	8ae4cef1-1f2a-403a-b938-dd85e52895b8	\N	0	f	f	master Realm	f	client-secret	\N	\N	\N	t	f	f	f
088ba46b-0bc3-49fb-8452-cbe125bff9fd	t	f	account	0	t	\N	/realms/master/account/	f	\N	f	8ae4cef1-1f2a-403a-b938-dd85e52895b8	openid-connect	0	f	f	${client_account}	f	client-secret	${authBaseUrl}	\N	\N	t	f	f	f
dcfd54d7-6c78-4fea-9476-63b29e7cb5b8	t	f	account-console	0	t	\N	/realms/master/account/	f	\N	f	8ae4cef1-1f2a-403a-b938-dd85e52895b8	openid-connect	0	f	f	${client_account-console}	f	client-secret	${authBaseUrl}	\N	\N	t	f	f	f
bd4bd60b-90d3-4a34-8a18-b7c9c713fc6f	t	f	broker	0	f	\N	\N	t	\N	f	8ae4cef1-1f2a-403a-b938-dd85e52895b8	openid-connect	0	f	f	${client_broker}	f	client-secret	\N	\N	\N	t	f	f	f
38e23499-9126-46d6-8d7c-9a9058214fa6	t	t	security-admin-console	0	t	\N	/admin/master/console/	f	\N	f	8ae4cef1-1f2a-403a-b938-dd85e52895b8	openid-connect	0	f	f	${client_security-admin-console}	f	client-secret	${authAdminUrl}	\N	\N	t	f	f	f
0bc37e6d-8ce1-439d-90be-6cd8e541a904	t	t	admin-cli	0	t	\N	\N	f	\N	f	8ae4cef1-1f2a-403a-b938-dd85e52895b8	openid-connect	0	f	f	${client_admin-cli}	f	client-secret	\N	\N	\N	f	f	t	f
0333da14-7d08-4ea6-a808-2aaa7d3411f3	t	f	pivoine.art-realm	0	f	\N	\N	t	\N	f	8ae4cef1-1f2a-403a-b938-dd85e52895b8	\N	0	f	f	pivoine.art Realm	f	client-secret	\N	\N	\N	t	f	f	f
a7c21283-c174-4852-9ef6-a6d9f29c3ab9	t	f	realm-management	0	f	\N	\N	t	\N	f	460a8e4b-5528-439c-ae10-29c984c7e8f5	openid-connect	0	f	f	${client_realm-management}	f	client-secret	\N	\N	\N	t	f	f	f
36a4d1a1-9c0d-42cc-bd41-c8970391cbdb	t	f	account	0	t	\N	/realms/pivoine.art/account/	f	\N	f	460a8e4b-5528-439c-ae10-29c984c7e8f5	openid-connect	0	f	f	${client_account}	f	client-secret	${authBaseUrl}	\N	\N	t	f	f	f
1321a953-5b99-4f7c-8fa1-f263c8d3408a	t	f	account-console	0	t	\N	/realms/pivoine.art/account/	f	\N	f	460a8e4b-5528-439c-ae10-29c984c7e8f5	openid-connect	0	f	f	${client_account-console}	f	client-secret	${authBaseUrl}	\N	\N	t	f	f	f
c4965edf-d53a-4211-bf6a-3ff49d604a4c	t	f	broker	0	f	\N	\N	t	\N	f	460a8e4b-5528-439c-ae10-29c984c7e8f5	openid-connect	0	f	f	${client_broker}	f	client-secret	\N	\N	\N	t	f	f	f
b3a7f90d-7ffa-42ec-8776-295a809d64c7	t	t	security-admin-console	0	t	\N	/admin/pivoine.art/console/	f	\N	f	460a8e4b-5528-439c-ae10-29c984c7e8f5	openid-connect	0	f	f	${client_security-admin-console}	f	client-secret	${authAdminUrl}	\N	\N	t	f	f	f
6b1eebe2-bc99-4242-8673-c7737ad3ea0e	t	t	admin-cli	0	t	\N	\N	f	\N	f	460a8e4b-5528-439c-ae10-29c984c7e8f5	openid-connect	0	f	f	${client_admin-cli}	f	client-secret	\N	\N	\N	f	f	t	f
\.


--
-- Data for Name: client_attributes; Type: TABLE DATA; Schema: public; Owner: valknar
--

COPY public.client_attributes (client_id, name, value) FROM stdin;
088ba46b-0bc3-49fb-8452-cbe125bff9fd	post.logout.redirect.uris	+
dcfd54d7-6c78-4fea-9476-63b29e7cb5b8	post.logout.redirect.uris	+
dcfd54d7-6c78-4fea-9476-63b29e7cb5b8	pkce.code.challenge.method	S256
38e23499-9126-46d6-8d7c-9a9058214fa6	post.logout.redirect.uris	+
38e23499-9126-46d6-8d7c-9a9058214fa6	pkce.code.challenge.method	S256
38e23499-9126-46d6-8d7c-9a9058214fa6	client.use.lightweight.access.token.enabled	true
0bc37e6d-8ce1-439d-90be-6cd8e541a904	client.use.lightweight.access.token.enabled	true
36a4d1a1-9c0d-42cc-bd41-c8970391cbdb	post.logout.redirect.uris	+
1321a953-5b99-4f7c-8fa1-f263c8d3408a	post.logout.redirect.uris	+
1321a953-5b99-4f7c-8fa1-f263c8d3408a	pkce.code.challenge.method	S256
b3a7f90d-7ffa-42ec-8776-295a809d64c7	post.logout.redirect.uris	+
b3a7f90d-7ffa-42ec-8776-295a809d64c7	pkce.code.challenge.method	S256
b3a7f90d-7ffa-42ec-8776-295a809d64c7	client.use.lightweight.access.token.enabled	true
6b1eebe2-bc99-4242-8673-c7737ad3ea0e	client.use.lightweight.access.token.enabled	true
\.


--
-- Data for Name: client_auth_flow_bindings; Type: TABLE DATA; Schema: public; Owner: valknar
--

COPY public.client_auth_flow_bindings (client_id, flow_id, binding_name) FROM stdin;
\.


--
-- Data for Name: client_initial_access; Type: TABLE DATA; Schema: public; Owner: valknar
--

COPY public.client_initial_access (id, realm_id, "timestamp", expiration, count, remaining_count) FROM stdin;
\.


--
-- Data for Name: client_node_registrations; Type: TABLE DATA; Schema: public; Owner: valknar
--

COPY public.client_node_registrations (client_id, value, name) FROM stdin;
\.


--
-- Data for Name: client_scope; Type: TABLE DATA; Schema: public; Owner: valknar
--

COPY public.client_scope (id, name, realm_id, description, protocol) FROM stdin;
aca9bfc0-a5ba-43dd-8273-0cdda56e6da7	offline_access	8ae4cef1-1f2a-403a-b938-dd85e52895b8	OpenID Connect built-in scope: offline_access	openid-connect
eef4271b-1236-448a-a206-e8b64d341e68	role_list	8ae4cef1-1f2a-403a-b938-dd85e52895b8	SAML role list	saml
fe1c1066-e7c3-4e91-9ac8-ddca15da24ad	saml_organization	8ae4cef1-1f2a-403a-b938-dd85e52895b8	Organization Membership	saml
85198f59-8318-434a-b4c9-d3baefe584b4	profile	8ae4cef1-1f2a-403a-b938-dd85e52895b8	OpenID Connect built-in scope: profile	openid-connect
61f971fb-4c10-4fcd-9db4-733066c881cc	email	8ae4cef1-1f2a-403a-b938-dd85e52895b8	OpenID Connect built-in scope: email	openid-connect
4689d0df-5b1d-4608-97ce-bff901d53c77	address	8ae4cef1-1f2a-403a-b938-dd85e52895b8	OpenID Connect built-in scope: address	openid-connect
828b2f2f-5e4f-4e60-9e9c-df0b1872ac04	phone	8ae4cef1-1f2a-403a-b938-dd85e52895b8	OpenID Connect built-in scope: phone	openid-connect
68b53ac7-f20b-4377-b89d-8c41f4986984	roles	8ae4cef1-1f2a-403a-b938-dd85e52895b8	OpenID Connect scope for add user roles to the access token	openid-connect
ec27336a-b2a4-4d9c-8909-13b27dc0f28c	web-origins	8ae4cef1-1f2a-403a-b938-dd85e52895b8	OpenID Connect scope for add allowed web origins to the access token	openid-connect
4497a478-ab89-4f70-8b7d-ae2e2b35796e	microprofile-jwt	8ae4cef1-1f2a-403a-b938-dd85e52895b8	Microprofile - JWT built-in scope	openid-connect
5f5c1d7b-9593-4e21-ac47-e3f50ac8d2e4	acr	8ae4cef1-1f2a-403a-b938-dd85e52895b8	OpenID Connect scope for add acr (authentication context class reference) to the token	openid-connect
1fb747c6-a776-4885-97d5-78b9a258d8cb	basic	8ae4cef1-1f2a-403a-b938-dd85e52895b8	OpenID Connect scope for add all basic claims to the token	openid-connect
17183541-fd26-44aa-b4bd-6f99e80f1e16	service_account	8ae4cef1-1f2a-403a-b938-dd85e52895b8	Specific scope for a client enabled for service accounts	openid-connect
09ab32c4-ac44-4f07-8405-fa3b30ccf887	organization	8ae4cef1-1f2a-403a-b938-dd85e52895b8	Additional claims about the organization a subject belongs to	openid-connect
123ac7c2-4a9a-4072-a5fe-ff43d8100d2b	offline_access	460a8e4b-5528-439c-ae10-29c984c7e8f5	OpenID Connect built-in scope: offline_access	openid-connect
11a4af65-6453-45e2-b43c-00317d2153c9	role_list	460a8e4b-5528-439c-ae10-29c984c7e8f5	SAML role list	saml
13bd5f7d-4e62-40e0-8706-23402ab04ac7	saml_organization	460a8e4b-5528-439c-ae10-29c984c7e8f5	Organization Membership	saml
608f045b-0e6e-4c03-922f-09d24b347e54	profile	460a8e4b-5528-439c-ae10-29c984c7e8f5	OpenID Connect built-in scope: profile	openid-connect
307c64d0-1eab-46ea-8609-79fed3819c63	email	460a8e4b-5528-439c-ae10-29c984c7e8f5	OpenID Connect built-in scope: email	openid-connect
2eee947b-c014-498b-b0b9-30f9837016b3	address	460a8e4b-5528-439c-ae10-29c984c7e8f5	OpenID Connect built-in scope: address	openid-connect
f71fd363-2afb-465e-bcc3-988dab550c4e	phone	460a8e4b-5528-439c-ae10-29c984c7e8f5	OpenID Connect built-in scope: phone	openid-connect
a4ffd0fa-fdde-4bbf-b010-a33f97bbea9b	roles	460a8e4b-5528-439c-ae10-29c984c7e8f5	OpenID Connect scope for add user roles to the access token	openid-connect
7b89a72a-18eb-40e6-894d-93e9b09c6397	web-origins	460a8e4b-5528-439c-ae10-29c984c7e8f5	OpenID Connect scope for add allowed web origins to the access token	openid-connect
5705c761-1e66-4308-a8c9-f157a0c959db	microprofile-jwt	460a8e4b-5528-439c-ae10-29c984c7e8f5	Microprofile - JWT built-in scope	openid-connect
1b261132-0338-48f4-b182-f1ca8cd1d788	acr	460a8e4b-5528-439c-ae10-29c984c7e8f5	OpenID Connect scope for add acr (authentication context class reference) to the token	openid-connect
e0fe63e3-4708-4949-a7f6-623bcd0fe950	basic	460a8e4b-5528-439c-ae10-29c984c7e8f5	OpenID Connect scope for add all basic claims to the token	openid-connect
3c055df1-db4d-4498-9cbb-321d75d62b7c	service_account	460a8e4b-5528-439c-ae10-29c984c7e8f5	Specific scope for a client enabled for service accounts	openid-connect
f7f027c3-a693-42d5-b2dc-d3d7e4fa43e0	organization	460a8e4b-5528-439c-ae10-29c984c7e8f5	Additional claims about the organization a subject belongs to	openid-connect
\.


--
-- Data for Name: client_scope_attributes; Type: TABLE DATA; Schema: public; Owner: valknar
--

COPY public.client_scope_attributes (scope_id, value, name) FROM stdin;
aca9bfc0-a5ba-43dd-8273-0cdda56e6da7	true	display.on.consent.screen
aca9bfc0-a5ba-43dd-8273-0cdda56e6da7	${offlineAccessScopeConsentText}	consent.screen.text
eef4271b-1236-448a-a206-e8b64d341e68	true	display.on.consent.screen
eef4271b-1236-448a-a206-e8b64d341e68	${samlRoleListScopeConsentText}	consent.screen.text
fe1c1066-e7c3-4e91-9ac8-ddca15da24ad	false	display.on.consent.screen
85198f59-8318-434a-b4c9-d3baefe584b4	true	display.on.consent.screen
85198f59-8318-434a-b4c9-d3baefe584b4	${profileScopeConsentText}	consent.screen.text
85198f59-8318-434a-b4c9-d3baefe584b4	true	include.in.token.scope
61f971fb-4c10-4fcd-9db4-733066c881cc	true	display.on.consent.screen
61f971fb-4c10-4fcd-9db4-733066c881cc	${emailScopeConsentText}	consent.screen.text
61f971fb-4c10-4fcd-9db4-733066c881cc	true	include.in.token.scope
4689d0df-5b1d-4608-97ce-bff901d53c77	true	display.on.consent.screen
4689d0df-5b1d-4608-97ce-bff901d53c77	${addressScopeConsentText}	consent.screen.text
4689d0df-5b1d-4608-97ce-bff901d53c77	true	include.in.token.scope
828b2f2f-5e4f-4e60-9e9c-df0b1872ac04	true	display.on.consent.screen
828b2f2f-5e4f-4e60-9e9c-df0b1872ac04	${phoneScopeConsentText}	consent.screen.text
828b2f2f-5e4f-4e60-9e9c-df0b1872ac04	true	include.in.token.scope
68b53ac7-f20b-4377-b89d-8c41f4986984	true	display.on.consent.screen
68b53ac7-f20b-4377-b89d-8c41f4986984	${rolesScopeConsentText}	consent.screen.text
68b53ac7-f20b-4377-b89d-8c41f4986984	false	include.in.token.scope
ec27336a-b2a4-4d9c-8909-13b27dc0f28c	false	display.on.consent.screen
ec27336a-b2a4-4d9c-8909-13b27dc0f28c		consent.screen.text
ec27336a-b2a4-4d9c-8909-13b27dc0f28c	false	include.in.token.scope
4497a478-ab89-4f70-8b7d-ae2e2b35796e	false	display.on.consent.screen
4497a478-ab89-4f70-8b7d-ae2e2b35796e	true	include.in.token.scope
5f5c1d7b-9593-4e21-ac47-e3f50ac8d2e4	false	display.on.consent.screen
5f5c1d7b-9593-4e21-ac47-e3f50ac8d2e4	false	include.in.token.scope
1fb747c6-a776-4885-97d5-78b9a258d8cb	false	display.on.consent.screen
1fb747c6-a776-4885-97d5-78b9a258d8cb	false	include.in.token.scope
17183541-fd26-44aa-b4bd-6f99e80f1e16	false	display.on.consent.screen
17183541-fd26-44aa-b4bd-6f99e80f1e16	false	include.in.token.scope
09ab32c4-ac44-4f07-8405-fa3b30ccf887	true	display.on.consent.screen
09ab32c4-ac44-4f07-8405-fa3b30ccf887	${organizationScopeConsentText}	consent.screen.text
09ab32c4-ac44-4f07-8405-fa3b30ccf887	true	include.in.token.scope
123ac7c2-4a9a-4072-a5fe-ff43d8100d2b	true	display.on.consent.screen
123ac7c2-4a9a-4072-a5fe-ff43d8100d2b	${offlineAccessScopeConsentText}	consent.screen.text
11a4af65-6453-45e2-b43c-00317d2153c9	true	display.on.consent.screen
11a4af65-6453-45e2-b43c-00317d2153c9	${samlRoleListScopeConsentText}	consent.screen.text
13bd5f7d-4e62-40e0-8706-23402ab04ac7	false	display.on.consent.screen
608f045b-0e6e-4c03-922f-09d24b347e54	true	display.on.consent.screen
608f045b-0e6e-4c03-922f-09d24b347e54	${profileScopeConsentText}	consent.screen.text
608f045b-0e6e-4c03-922f-09d24b347e54	true	include.in.token.scope
307c64d0-1eab-46ea-8609-79fed3819c63	true	display.on.consent.screen
307c64d0-1eab-46ea-8609-79fed3819c63	${emailScopeConsentText}	consent.screen.text
307c64d0-1eab-46ea-8609-79fed3819c63	true	include.in.token.scope
2eee947b-c014-498b-b0b9-30f9837016b3	true	display.on.consent.screen
2eee947b-c014-498b-b0b9-30f9837016b3	${addressScopeConsentText}	consent.screen.text
2eee947b-c014-498b-b0b9-30f9837016b3	true	include.in.token.scope
f71fd363-2afb-465e-bcc3-988dab550c4e	true	display.on.consent.screen
f71fd363-2afb-465e-bcc3-988dab550c4e	${phoneScopeConsentText}	consent.screen.text
f71fd363-2afb-465e-bcc3-988dab550c4e	true	include.in.token.scope
a4ffd0fa-fdde-4bbf-b010-a33f97bbea9b	true	display.on.consent.screen
a4ffd0fa-fdde-4bbf-b010-a33f97bbea9b	${rolesScopeConsentText}	consent.screen.text
a4ffd0fa-fdde-4bbf-b010-a33f97bbea9b	false	include.in.token.scope
7b89a72a-18eb-40e6-894d-93e9b09c6397	false	display.on.consent.screen
7b89a72a-18eb-40e6-894d-93e9b09c6397		consent.screen.text
7b89a72a-18eb-40e6-894d-93e9b09c6397	false	include.in.token.scope
5705c761-1e66-4308-a8c9-f157a0c959db	false	display.on.consent.screen
5705c761-1e66-4308-a8c9-f157a0c959db	true	include.in.token.scope
1b261132-0338-48f4-b182-f1ca8cd1d788	false	display.on.consent.screen
1b261132-0338-48f4-b182-f1ca8cd1d788	false	include.in.token.scope
e0fe63e3-4708-4949-a7f6-623bcd0fe950	false	display.on.consent.screen
e0fe63e3-4708-4949-a7f6-623bcd0fe950	false	include.in.token.scope
3c055df1-db4d-4498-9cbb-321d75d62b7c	false	display.on.consent.screen
3c055df1-db4d-4498-9cbb-321d75d62b7c	false	include.in.token.scope
f7f027c3-a693-42d5-b2dc-d3d7e4fa43e0	true	display.on.consent.screen
f7f027c3-a693-42d5-b2dc-d3d7e4fa43e0	${organizationScopeConsentText}	consent.screen.text
f7f027c3-a693-42d5-b2dc-d3d7e4fa43e0	true	include.in.token.scope
\.


--
-- Data for Name: client_scope_client; Type: TABLE DATA; Schema: public; Owner: valknar
--

COPY public.client_scope_client (client_id, scope_id, default_scope) FROM stdin;
088ba46b-0bc3-49fb-8452-cbe125bff9fd	5f5c1d7b-9593-4e21-ac47-e3f50ac8d2e4	t
088ba46b-0bc3-49fb-8452-cbe125bff9fd	1fb747c6-a776-4885-97d5-78b9a258d8cb	t
088ba46b-0bc3-49fb-8452-cbe125bff9fd	68b53ac7-f20b-4377-b89d-8c41f4986984	t
088ba46b-0bc3-49fb-8452-cbe125bff9fd	ec27336a-b2a4-4d9c-8909-13b27dc0f28c	t
088ba46b-0bc3-49fb-8452-cbe125bff9fd	85198f59-8318-434a-b4c9-d3baefe584b4	t
088ba46b-0bc3-49fb-8452-cbe125bff9fd	61f971fb-4c10-4fcd-9db4-733066c881cc	t
088ba46b-0bc3-49fb-8452-cbe125bff9fd	aca9bfc0-a5ba-43dd-8273-0cdda56e6da7	f
088ba46b-0bc3-49fb-8452-cbe125bff9fd	09ab32c4-ac44-4f07-8405-fa3b30ccf887	f
088ba46b-0bc3-49fb-8452-cbe125bff9fd	4497a478-ab89-4f70-8b7d-ae2e2b35796e	f
088ba46b-0bc3-49fb-8452-cbe125bff9fd	828b2f2f-5e4f-4e60-9e9c-df0b1872ac04	f
088ba46b-0bc3-49fb-8452-cbe125bff9fd	4689d0df-5b1d-4608-97ce-bff901d53c77	f
dcfd54d7-6c78-4fea-9476-63b29e7cb5b8	5f5c1d7b-9593-4e21-ac47-e3f50ac8d2e4	t
dcfd54d7-6c78-4fea-9476-63b29e7cb5b8	1fb747c6-a776-4885-97d5-78b9a258d8cb	t
dcfd54d7-6c78-4fea-9476-63b29e7cb5b8	68b53ac7-f20b-4377-b89d-8c41f4986984	t
dcfd54d7-6c78-4fea-9476-63b29e7cb5b8	ec27336a-b2a4-4d9c-8909-13b27dc0f28c	t
dcfd54d7-6c78-4fea-9476-63b29e7cb5b8	85198f59-8318-434a-b4c9-d3baefe584b4	t
dcfd54d7-6c78-4fea-9476-63b29e7cb5b8	61f971fb-4c10-4fcd-9db4-733066c881cc	t
dcfd54d7-6c78-4fea-9476-63b29e7cb5b8	aca9bfc0-a5ba-43dd-8273-0cdda56e6da7	f
dcfd54d7-6c78-4fea-9476-63b29e7cb5b8	09ab32c4-ac44-4f07-8405-fa3b30ccf887	f
dcfd54d7-6c78-4fea-9476-63b29e7cb5b8	4497a478-ab89-4f70-8b7d-ae2e2b35796e	f
dcfd54d7-6c78-4fea-9476-63b29e7cb5b8	828b2f2f-5e4f-4e60-9e9c-df0b1872ac04	f
dcfd54d7-6c78-4fea-9476-63b29e7cb5b8	4689d0df-5b1d-4608-97ce-bff901d53c77	f
0bc37e6d-8ce1-439d-90be-6cd8e541a904	5f5c1d7b-9593-4e21-ac47-e3f50ac8d2e4	t
0bc37e6d-8ce1-439d-90be-6cd8e541a904	1fb747c6-a776-4885-97d5-78b9a258d8cb	t
0bc37e6d-8ce1-439d-90be-6cd8e541a904	68b53ac7-f20b-4377-b89d-8c41f4986984	t
0bc37e6d-8ce1-439d-90be-6cd8e541a904	ec27336a-b2a4-4d9c-8909-13b27dc0f28c	t
0bc37e6d-8ce1-439d-90be-6cd8e541a904	85198f59-8318-434a-b4c9-d3baefe584b4	t
0bc37e6d-8ce1-439d-90be-6cd8e541a904	61f971fb-4c10-4fcd-9db4-733066c881cc	t
0bc37e6d-8ce1-439d-90be-6cd8e541a904	aca9bfc0-a5ba-43dd-8273-0cdda56e6da7	f
0bc37e6d-8ce1-439d-90be-6cd8e541a904	09ab32c4-ac44-4f07-8405-fa3b30ccf887	f
0bc37e6d-8ce1-439d-90be-6cd8e541a904	4497a478-ab89-4f70-8b7d-ae2e2b35796e	f
0bc37e6d-8ce1-439d-90be-6cd8e541a904	828b2f2f-5e4f-4e60-9e9c-df0b1872ac04	f
0bc37e6d-8ce1-439d-90be-6cd8e541a904	4689d0df-5b1d-4608-97ce-bff901d53c77	f
bd4bd60b-90d3-4a34-8a18-b7c9c713fc6f	5f5c1d7b-9593-4e21-ac47-e3f50ac8d2e4	t
bd4bd60b-90d3-4a34-8a18-b7c9c713fc6f	1fb747c6-a776-4885-97d5-78b9a258d8cb	t
bd4bd60b-90d3-4a34-8a18-b7c9c713fc6f	68b53ac7-f20b-4377-b89d-8c41f4986984	t
bd4bd60b-90d3-4a34-8a18-b7c9c713fc6f	ec27336a-b2a4-4d9c-8909-13b27dc0f28c	t
bd4bd60b-90d3-4a34-8a18-b7c9c713fc6f	85198f59-8318-434a-b4c9-d3baefe584b4	t
bd4bd60b-90d3-4a34-8a18-b7c9c713fc6f	61f971fb-4c10-4fcd-9db4-733066c881cc	t
bd4bd60b-90d3-4a34-8a18-b7c9c713fc6f	aca9bfc0-a5ba-43dd-8273-0cdda56e6da7	f
bd4bd60b-90d3-4a34-8a18-b7c9c713fc6f	09ab32c4-ac44-4f07-8405-fa3b30ccf887	f
bd4bd60b-90d3-4a34-8a18-b7c9c713fc6f	4497a478-ab89-4f70-8b7d-ae2e2b35796e	f
bd4bd60b-90d3-4a34-8a18-b7c9c713fc6f	828b2f2f-5e4f-4e60-9e9c-df0b1872ac04	f
bd4bd60b-90d3-4a34-8a18-b7c9c713fc6f	4689d0df-5b1d-4608-97ce-bff901d53c77	f
2ba16542-30d0-449e-aca5-25498bcbbaf0	5f5c1d7b-9593-4e21-ac47-e3f50ac8d2e4	t
2ba16542-30d0-449e-aca5-25498bcbbaf0	1fb747c6-a776-4885-97d5-78b9a258d8cb	t
2ba16542-30d0-449e-aca5-25498bcbbaf0	68b53ac7-f20b-4377-b89d-8c41f4986984	t
2ba16542-30d0-449e-aca5-25498bcbbaf0	ec27336a-b2a4-4d9c-8909-13b27dc0f28c	t
2ba16542-30d0-449e-aca5-25498bcbbaf0	85198f59-8318-434a-b4c9-d3baefe584b4	t
2ba16542-30d0-449e-aca5-25498bcbbaf0	61f971fb-4c10-4fcd-9db4-733066c881cc	t
2ba16542-30d0-449e-aca5-25498bcbbaf0	aca9bfc0-a5ba-43dd-8273-0cdda56e6da7	f
2ba16542-30d0-449e-aca5-25498bcbbaf0	09ab32c4-ac44-4f07-8405-fa3b30ccf887	f
2ba16542-30d0-449e-aca5-25498bcbbaf0	4497a478-ab89-4f70-8b7d-ae2e2b35796e	f
2ba16542-30d0-449e-aca5-25498bcbbaf0	828b2f2f-5e4f-4e60-9e9c-df0b1872ac04	f
2ba16542-30d0-449e-aca5-25498bcbbaf0	4689d0df-5b1d-4608-97ce-bff901d53c77	f
38e23499-9126-46d6-8d7c-9a9058214fa6	5f5c1d7b-9593-4e21-ac47-e3f50ac8d2e4	t
38e23499-9126-46d6-8d7c-9a9058214fa6	1fb747c6-a776-4885-97d5-78b9a258d8cb	t
38e23499-9126-46d6-8d7c-9a9058214fa6	68b53ac7-f20b-4377-b89d-8c41f4986984	t
38e23499-9126-46d6-8d7c-9a9058214fa6	ec27336a-b2a4-4d9c-8909-13b27dc0f28c	t
38e23499-9126-46d6-8d7c-9a9058214fa6	85198f59-8318-434a-b4c9-d3baefe584b4	t
38e23499-9126-46d6-8d7c-9a9058214fa6	61f971fb-4c10-4fcd-9db4-733066c881cc	t
38e23499-9126-46d6-8d7c-9a9058214fa6	aca9bfc0-a5ba-43dd-8273-0cdda56e6da7	f
38e23499-9126-46d6-8d7c-9a9058214fa6	09ab32c4-ac44-4f07-8405-fa3b30ccf887	f
38e23499-9126-46d6-8d7c-9a9058214fa6	4497a478-ab89-4f70-8b7d-ae2e2b35796e	f
38e23499-9126-46d6-8d7c-9a9058214fa6	828b2f2f-5e4f-4e60-9e9c-df0b1872ac04	f
38e23499-9126-46d6-8d7c-9a9058214fa6	4689d0df-5b1d-4608-97ce-bff901d53c77	f
36a4d1a1-9c0d-42cc-bd41-c8970391cbdb	1b261132-0338-48f4-b182-f1ca8cd1d788	t
36a4d1a1-9c0d-42cc-bd41-c8970391cbdb	a4ffd0fa-fdde-4bbf-b010-a33f97bbea9b	t
36a4d1a1-9c0d-42cc-bd41-c8970391cbdb	7b89a72a-18eb-40e6-894d-93e9b09c6397	t
36a4d1a1-9c0d-42cc-bd41-c8970391cbdb	608f045b-0e6e-4c03-922f-09d24b347e54	t
36a4d1a1-9c0d-42cc-bd41-c8970391cbdb	307c64d0-1eab-46ea-8609-79fed3819c63	t
36a4d1a1-9c0d-42cc-bd41-c8970391cbdb	e0fe63e3-4708-4949-a7f6-623bcd0fe950	t
36a4d1a1-9c0d-42cc-bd41-c8970391cbdb	f7f027c3-a693-42d5-b2dc-d3d7e4fa43e0	f
36a4d1a1-9c0d-42cc-bd41-c8970391cbdb	f71fd363-2afb-465e-bcc3-988dab550c4e	f
36a4d1a1-9c0d-42cc-bd41-c8970391cbdb	5705c761-1e66-4308-a8c9-f157a0c959db	f
36a4d1a1-9c0d-42cc-bd41-c8970391cbdb	2eee947b-c014-498b-b0b9-30f9837016b3	f
36a4d1a1-9c0d-42cc-bd41-c8970391cbdb	123ac7c2-4a9a-4072-a5fe-ff43d8100d2b	f
1321a953-5b99-4f7c-8fa1-f263c8d3408a	1b261132-0338-48f4-b182-f1ca8cd1d788	t
1321a953-5b99-4f7c-8fa1-f263c8d3408a	a4ffd0fa-fdde-4bbf-b010-a33f97bbea9b	t
1321a953-5b99-4f7c-8fa1-f263c8d3408a	7b89a72a-18eb-40e6-894d-93e9b09c6397	t
1321a953-5b99-4f7c-8fa1-f263c8d3408a	608f045b-0e6e-4c03-922f-09d24b347e54	t
1321a953-5b99-4f7c-8fa1-f263c8d3408a	307c64d0-1eab-46ea-8609-79fed3819c63	t
1321a953-5b99-4f7c-8fa1-f263c8d3408a	e0fe63e3-4708-4949-a7f6-623bcd0fe950	t
1321a953-5b99-4f7c-8fa1-f263c8d3408a	f7f027c3-a693-42d5-b2dc-d3d7e4fa43e0	f
1321a953-5b99-4f7c-8fa1-f263c8d3408a	f71fd363-2afb-465e-bcc3-988dab550c4e	f
1321a953-5b99-4f7c-8fa1-f263c8d3408a	5705c761-1e66-4308-a8c9-f157a0c959db	f
1321a953-5b99-4f7c-8fa1-f263c8d3408a	2eee947b-c014-498b-b0b9-30f9837016b3	f
1321a953-5b99-4f7c-8fa1-f263c8d3408a	123ac7c2-4a9a-4072-a5fe-ff43d8100d2b	f
6b1eebe2-bc99-4242-8673-c7737ad3ea0e	1b261132-0338-48f4-b182-f1ca8cd1d788	t
6b1eebe2-bc99-4242-8673-c7737ad3ea0e	a4ffd0fa-fdde-4bbf-b010-a33f97bbea9b	t
6b1eebe2-bc99-4242-8673-c7737ad3ea0e	7b89a72a-18eb-40e6-894d-93e9b09c6397	t
6b1eebe2-bc99-4242-8673-c7737ad3ea0e	608f045b-0e6e-4c03-922f-09d24b347e54	t
6b1eebe2-bc99-4242-8673-c7737ad3ea0e	307c64d0-1eab-46ea-8609-79fed3819c63	t
6b1eebe2-bc99-4242-8673-c7737ad3ea0e	e0fe63e3-4708-4949-a7f6-623bcd0fe950	t
6b1eebe2-bc99-4242-8673-c7737ad3ea0e	f7f027c3-a693-42d5-b2dc-d3d7e4fa43e0	f
6b1eebe2-bc99-4242-8673-c7737ad3ea0e	f71fd363-2afb-465e-bcc3-988dab550c4e	f
6b1eebe2-bc99-4242-8673-c7737ad3ea0e	5705c761-1e66-4308-a8c9-f157a0c959db	f
6b1eebe2-bc99-4242-8673-c7737ad3ea0e	2eee947b-c014-498b-b0b9-30f9837016b3	f
6b1eebe2-bc99-4242-8673-c7737ad3ea0e	123ac7c2-4a9a-4072-a5fe-ff43d8100d2b	f
c4965edf-d53a-4211-bf6a-3ff49d604a4c	1b261132-0338-48f4-b182-f1ca8cd1d788	t
c4965edf-d53a-4211-bf6a-3ff49d604a4c	a4ffd0fa-fdde-4bbf-b010-a33f97bbea9b	t
c4965edf-d53a-4211-bf6a-3ff49d604a4c	7b89a72a-18eb-40e6-894d-93e9b09c6397	t
c4965edf-d53a-4211-bf6a-3ff49d604a4c	608f045b-0e6e-4c03-922f-09d24b347e54	t
c4965edf-d53a-4211-bf6a-3ff49d604a4c	307c64d0-1eab-46ea-8609-79fed3819c63	t
c4965edf-d53a-4211-bf6a-3ff49d604a4c	e0fe63e3-4708-4949-a7f6-623bcd0fe950	t
c4965edf-d53a-4211-bf6a-3ff49d604a4c	f7f027c3-a693-42d5-b2dc-d3d7e4fa43e0	f
c4965edf-d53a-4211-bf6a-3ff49d604a4c	f71fd363-2afb-465e-bcc3-988dab550c4e	f
c4965edf-d53a-4211-bf6a-3ff49d604a4c	5705c761-1e66-4308-a8c9-f157a0c959db	f
c4965edf-d53a-4211-bf6a-3ff49d604a4c	2eee947b-c014-498b-b0b9-30f9837016b3	f
c4965edf-d53a-4211-bf6a-3ff49d604a4c	123ac7c2-4a9a-4072-a5fe-ff43d8100d2b	f
a7c21283-c174-4852-9ef6-a6d9f29c3ab9	1b261132-0338-48f4-b182-f1ca8cd1d788	t
a7c21283-c174-4852-9ef6-a6d9f29c3ab9	a4ffd0fa-fdde-4bbf-b010-a33f97bbea9b	t
a7c21283-c174-4852-9ef6-a6d9f29c3ab9	7b89a72a-18eb-40e6-894d-93e9b09c6397	t
a7c21283-c174-4852-9ef6-a6d9f29c3ab9	608f045b-0e6e-4c03-922f-09d24b347e54	t
a7c21283-c174-4852-9ef6-a6d9f29c3ab9	307c64d0-1eab-46ea-8609-79fed3819c63	t
a7c21283-c174-4852-9ef6-a6d9f29c3ab9	e0fe63e3-4708-4949-a7f6-623bcd0fe950	t
a7c21283-c174-4852-9ef6-a6d9f29c3ab9	f7f027c3-a693-42d5-b2dc-d3d7e4fa43e0	f
a7c21283-c174-4852-9ef6-a6d9f29c3ab9	f71fd363-2afb-465e-bcc3-988dab550c4e	f
a7c21283-c174-4852-9ef6-a6d9f29c3ab9	5705c761-1e66-4308-a8c9-f157a0c959db	f
a7c21283-c174-4852-9ef6-a6d9f29c3ab9	2eee947b-c014-498b-b0b9-30f9837016b3	f
a7c21283-c174-4852-9ef6-a6d9f29c3ab9	123ac7c2-4a9a-4072-a5fe-ff43d8100d2b	f
b3a7f90d-7ffa-42ec-8776-295a809d64c7	1b261132-0338-48f4-b182-f1ca8cd1d788	t
b3a7f90d-7ffa-42ec-8776-295a809d64c7	a4ffd0fa-fdde-4bbf-b010-a33f97bbea9b	t
b3a7f90d-7ffa-42ec-8776-295a809d64c7	7b89a72a-18eb-40e6-894d-93e9b09c6397	t
b3a7f90d-7ffa-42ec-8776-295a809d64c7	608f045b-0e6e-4c03-922f-09d24b347e54	t
b3a7f90d-7ffa-42ec-8776-295a809d64c7	307c64d0-1eab-46ea-8609-79fed3819c63	t
b3a7f90d-7ffa-42ec-8776-295a809d64c7	e0fe63e3-4708-4949-a7f6-623bcd0fe950	t
b3a7f90d-7ffa-42ec-8776-295a809d64c7	f7f027c3-a693-42d5-b2dc-d3d7e4fa43e0	f
b3a7f90d-7ffa-42ec-8776-295a809d64c7	f71fd363-2afb-465e-bcc3-988dab550c4e	f
b3a7f90d-7ffa-42ec-8776-295a809d64c7	5705c761-1e66-4308-a8c9-f157a0c959db	f
b3a7f90d-7ffa-42ec-8776-295a809d64c7	2eee947b-c014-498b-b0b9-30f9837016b3	f
b3a7f90d-7ffa-42ec-8776-295a809d64c7	123ac7c2-4a9a-4072-a5fe-ff43d8100d2b	f
\.


--
-- Data for Name: client_scope_role_mapping; Type: TABLE DATA; Schema: public; Owner: valknar
--

COPY public.client_scope_role_mapping (scope_id, role_id) FROM stdin;
aca9bfc0-a5ba-43dd-8273-0cdda56e6da7	42a4cd37-3f8c-419d-b894-c17749889e03
123ac7c2-4a9a-4072-a5fe-ff43d8100d2b	fcf0fa2d-93b5-461b-9abb-2c1645106857
\.


--
-- Data for Name: component; Type: TABLE DATA; Schema: public; Owner: valknar
--

COPY public.component (id, name, parent_id, provider_id, provider_type, realm_id, sub_type) FROM stdin;
56caaf01-5dec-433d-9302-fb8dfa06400a	Trusted Hosts	8ae4cef1-1f2a-403a-b938-dd85e52895b8	trusted-hosts	org.keycloak.services.clientregistration.policy.ClientRegistrationPolicy	8ae4cef1-1f2a-403a-b938-dd85e52895b8	anonymous
b1f74816-cd22-4556-b1be-94cd3879e413	Consent Required	8ae4cef1-1f2a-403a-b938-dd85e52895b8	consent-required	org.keycloak.services.clientregistration.policy.ClientRegistrationPolicy	8ae4cef1-1f2a-403a-b938-dd85e52895b8	anonymous
428521a2-f5e1-4c03-bdf3-2213ee2a4630	Full Scope Disabled	8ae4cef1-1f2a-403a-b938-dd85e52895b8	scope	org.keycloak.services.clientregistration.policy.ClientRegistrationPolicy	8ae4cef1-1f2a-403a-b938-dd85e52895b8	anonymous
df50b883-8534-4171-aac0-509695c1eb90	Max Clients Limit	8ae4cef1-1f2a-403a-b938-dd85e52895b8	max-clients	org.keycloak.services.clientregistration.policy.ClientRegistrationPolicy	8ae4cef1-1f2a-403a-b938-dd85e52895b8	anonymous
3cef353d-53f0-45c7-a029-e31c3e6d0a70	Allowed Protocol Mapper Types	8ae4cef1-1f2a-403a-b938-dd85e52895b8	allowed-protocol-mappers	org.keycloak.services.clientregistration.policy.ClientRegistrationPolicy	8ae4cef1-1f2a-403a-b938-dd85e52895b8	anonymous
55467704-5092-4088-b264-aa9fd052fb5f	Allowed Client Scopes	8ae4cef1-1f2a-403a-b938-dd85e52895b8	allowed-client-templates	org.keycloak.services.clientregistration.policy.ClientRegistrationPolicy	8ae4cef1-1f2a-403a-b938-dd85e52895b8	anonymous
7db5c761-07c1-4963-aa91-33def6247dad	Allowed Protocol Mapper Types	8ae4cef1-1f2a-403a-b938-dd85e52895b8	allowed-protocol-mappers	org.keycloak.services.clientregistration.policy.ClientRegistrationPolicy	8ae4cef1-1f2a-403a-b938-dd85e52895b8	authenticated
b404d209-5b5c-4c5f-8acb-f0286772d9f8	Allowed Client Scopes	8ae4cef1-1f2a-403a-b938-dd85e52895b8	allowed-client-templates	org.keycloak.services.clientregistration.policy.ClientRegistrationPolicy	8ae4cef1-1f2a-403a-b938-dd85e52895b8	authenticated
35928cb0-d28d-4b7c-b354-9c1de3ff025d	rsa-generated	8ae4cef1-1f2a-403a-b938-dd85e52895b8	rsa-generated	org.keycloak.keys.KeyProvider	8ae4cef1-1f2a-403a-b938-dd85e52895b8	\N
c54d1de6-c04f-433b-9d21-ff10147659e2	rsa-enc-generated	8ae4cef1-1f2a-403a-b938-dd85e52895b8	rsa-enc-generated	org.keycloak.keys.KeyProvider	8ae4cef1-1f2a-403a-b938-dd85e52895b8	\N
e12e8265-fad5-4d72-a560-8445939f5c5e	hmac-generated-hs512	8ae4cef1-1f2a-403a-b938-dd85e52895b8	hmac-generated	org.keycloak.keys.KeyProvider	8ae4cef1-1f2a-403a-b938-dd85e52895b8	\N
73e41381-a7e2-4847-8e9b-b0198698bdce	aes-generated	8ae4cef1-1f2a-403a-b938-dd85e52895b8	aes-generated	org.keycloak.keys.KeyProvider	8ae4cef1-1f2a-403a-b938-dd85e52895b8	\N
36e9a0dc-b3b4-4e6d-aaa1-147618ab45af	\N	8ae4cef1-1f2a-403a-b938-dd85e52895b8	declarative-user-profile	org.keycloak.userprofile.UserProfileProvider	8ae4cef1-1f2a-403a-b938-dd85e52895b8	\N
b864fd11-ab2d-458d-9ca2-73507bf05662	rsa-generated	460a8e4b-5528-439c-ae10-29c984c7e8f5	rsa-generated	org.keycloak.keys.KeyProvider	460a8e4b-5528-439c-ae10-29c984c7e8f5	\N
c9db1d43-deb8-4f57-9196-c0d5fec3e4d1	rsa-enc-generated	460a8e4b-5528-439c-ae10-29c984c7e8f5	rsa-enc-generated	org.keycloak.keys.KeyProvider	460a8e4b-5528-439c-ae10-29c984c7e8f5	\N
a2c4dfd0-931e-4e79-aaad-e697b8448f07	hmac-generated-hs512	460a8e4b-5528-439c-ae10-29c984c7e8f5	hmac-generated	org.keycloak.keys.KeyProvider	460a8e4b-5528-439c-ae10-29c984c7e8f5	\N
0ca4e2e9-5137-4f70-90d3-5bf07a7cf7f6	aes-generated	460a8e4b-5528-439c-ae10-29c984c7e8f5	aes-generated	org.keycloak.keys.KeyProvider	460a8e4b-5528-439c-ae10-29c984c7e8f5	\N
4cadaa68-44fa-4e31-9233-5c785ff6d68f	Trusted Hosts	460a8e4b-5528-439c-ae10-29c984c7e8f5	trusted-hosts	org.keycloak.services.clientregistration.policy.ClientRegistrationPolicy	460a8e4b-5528-439c-ae10-29c984c7e8f5	anonymous
03df0298-b72c-41e9-9dab-f3214990bde2	Consent Required	460a8e4b-5528-439c-ae10-29c984c7e8f5	consent-required	org.keycloak.services.clientregistration.policy.ClientRegistrationPolicy	460a8e4b-5528-439c-ae10-29c984c7e8f5	anonymous
419cf148-4b56-4c31-bfc6-3912867cbfd8	Full Scope Disabled	460a8e4b-5528-439c-ae10-29c984c7e8f5	scope	org.keycloak.services.clientregistration.policy.ClientRegistrationPolicy	460a8e4b-5528-439c-ae10-29c984c7e8f5	anonymous
29ee13d2-640b-4ffc-b6f0-6dad67515d11	Max Clients Limit	460a8e4b-5528-439c-ae10-29c984c7e8f5	max-clients	org.keycloak.services.clientregistration.policy.ClientRegistrationPolicy	460a8e4b-5528-439c-ae10-29c984c7e8f5	anonymous
d30e4f75-2f13-4ac0-8879-dfd5f77e2c6c	Allowed Protocol Mapper Types	460a8e4b-5528-439c-ae10-29c984c7e8f5	allowed-protocol-mappers	org.keycloak.services.clientregistration.policy.ClientRegistrationPolicy	460a8e4b-5528-439c-ae10-29c984c7e8f5	anonymous
3774c482-c0a7-4d63-90ad-ef50f29649e6	Allowed Client Scopes	460a8e4b-5528-439c-ae10-29c984c7e8f5	allowed-client-templates	org.keycloak.services.clientregistration.policy.ClientRegistrationPolicy	460a8e4b-5528-439c-ae10-29c984c7e8f5	anonymous
bdfd0b15-53a8-4509-b3b6-2adf462489d0	Allowed Protocol Mapper Types	460a8e4b-5528-439c-ae10-29c984c7e8f5	allowed-protocol-mappers	org.keycloak.services.clientregistration.policy.ClientRegistrationPolicy	460a8e4b-5528-439c-ae10-29c984c7e8f5	authenticated
d020cf26-9806-46cb-b0dd-2ce1a6ee035a	Allowed Client Scopes	460a8e4b-5528-439c-ae10-29c984c7e8f5	allowed-client-templates	org.keycloak.services.clientregistration.policy.ClientRegistrationPolicy	460a8e4b-5528-439c-ae10-29c984c7e8f5	authenticated
\.


--
-- Data for Name: component_config; Type: TABLE DATA; Schema: public; Owner: valknar
--

COPY public.component_config (id, component_id, name, value) FROM stdin;
32ef88f8-01f6-4024-9544-72534df3df8a	3cef353d-53f0-45c7-a029-e31c3e6d0a70	allowed-protocol-mapper-types	oidc-sha256-pairwise-sub-mapper
9b054e61-7c6b-4fce-9d70-ccdcd0cb9fca	3cef353d-53f0-45c7-a029-e31c3e6d0a70	allowed-protocol-mapper-types	saml-user-attribute-mapper
33196990-9ce1-454c-895a-45def1f97007	3cef353d-53f0-45c7-a029-e31c3e6d0a70	allowed-protocol-mapper-types	saml-user-property-mapper
25ce8fa8-eb4a-4a07-83d4-66686630a15b	3cef353d-53f0-45c7-a029-e31c3e6d0a70	allowed-protocol-mapper-types	oidc-address-mapper
9c9cdcfe-b8e6-468a-bdc3-a0246fc67ce2	3cef353d-53f0-45c7-a029-e31c3e6d0a70	allowed-protocol-mapper-types	oidc-usermodel-property-mapper
9505e7cf-88ee-4c19-a7ec-71ca9193efcd	3cef353d-53f0-45c7-a029-e31c3e6d0a70	allowed-protocol-mapper-types	oidc-full-name-mapper
563283fc-1425-4cc8-9828-0b91e38d1638	3cef353d-53f0-45c7-a029-e31c3e6d0a70	allowed-protocol-mapper-types	saml-role-list-mapper
7a1e17c4-b795-4634-926b-79883c24432c	3cef353d-53f0-45c7-a029-e31c3e6d0a70	allowed-protocol-mapper-types	oidc-usermodel-attribute-mapper
69408a1e-90b3-455c-968c-49718252e96b	56caaf01-5dec-433d-9302-fb8dfa06400a	client-uris-must-match	true
30ddf268-5493-480b-ac25-2fd14be74fa3	56caaf01-5dec-433d-9302-fb8dfa06400a	host-sending-registration-request-must-match	true
010fb38b-94d1-4fda-99c2-87f5a091a9c6	55467704-5092-4088-b264-aa9fd052fb5f	allow-default-scopes	true
173c86a1-884d-4723-9915-36d352e09ab5	df50b883-8534-4171-aac0-509695c1eb90	max-clients	200
2f4a105f-eb17-4da6-891c-03b8a880940e	7db5c761-07c1-4963-aa91-33def6247dad	allowed-protocol-mapper-types	saml-user-property-mapper
8566d43c-8910-4ff5-8973-9348f1ba794a	7db5c761-07c1-4963-aa91-33def6247dad	allowed-protocol-mapper-types	oidc-sha256-pairwise-sub-mapper
5c9a365a-fe87-45b7-835e-624c14d052b7	7db5c761-07c1-4963-aa91-33def6247dad	allowed-protocol-mapper-types	oidc-usermodel-attribute-mapper
4c5759ee-9b45-4b72-87be-4634ce0d002e	7db5c761-07c1-4963-aa91-33def6247dad	allowed-protocol-mapper-types	oidc-usermodel-property-mapper
7f5bdc56-df86-4a4b-9b58-108eb359159b	7db5c761-07c1-4963-aa91-33def6247dad	allowed-protocol-mapper-types	saml-role-list-mapper
c4986341-81b5-4826-b8a6-d2a03e961f46	7db5c761-07c1-4963-aa91-33def6247dad	allowed-protocol-mapper-types	oidc-address-mapper
82af2a9f-74b7-4bee-89d0-fb6862f31ad1	7db5c761-07c1-4963-aa91-33def6247dad	allowed-protocol-mapper-types	oidc-full-name-mapper
0a342dd9-2589-4b10-87ac-e469475e5fc5	7db5c761-07c1-4963-aa91-33def6247dad	allowed-protocol-mapper-types	saml-user-attribute-mapper
e1d4a40c-06c6-4544-9ed7-5abd34f2553d	b404d209-5b5c-4c5f-8acb-f0286772d9f8	allow-default-scopes	true
f7ee2c25-23a0-4ccc-81bd-4ce530bd1fde	73e41381-a7e2-4847-8e9b-b0198698bdce	kid	201cd02c-2f5c-487f-a582-268c0131da6e
6e4158ce-9f7f-4db8-9a07-435594cdf15f	73e41381-a7e2-4847-8e9b-b0198698bdce	secret	-4mIgzC2DySxPd9RJPKZRw
5d6e7df9-0581-4ad9-bbb8-ddfd4c6c0480	73e41381-a7e2-4847-8e9b-b0198698bdce	priority	100
156410e0-3221-4263-9687-5bca2cf4f625	36e9a0dc-b3b4-4e6d-aaa1-147618ab45af	kc.user.profile.config	{"attributes":[{"name":"username","displayName":"${username}","validations":{"length":{"min":3,"max":255},"username-prohibited-characters":{},"up-username-not-idn-homograph":{}},"permissions":{"view":["admin","user"],"edit":["admin","user"]},"multivalued":false},{"name":"email","displayName":"${email}","validations":{"email":{},"length":{"max":255}},"permissions":{"view":["admin","user"],"edit":["admin","user"]},"multivalued":false},{"name":"firstName","displayName":"${firstName}","validations":{"length":{"max":255},"person-name-prohibited-characters":{}},"permissions":{"view":["admin","user"],"edit":["admin","user"]},"multivalued":false},{"name":"lastName","displayName":"${lastName}","validations":{"length":{"max":255},"person-name-prohibited-characters":{}},"permissions":{"view":["admin","user"],"edit":["admin","user"]},"multivalued":false}],"groups":[{"name":"user-metadata","displayHeader":"User metadata","displayDescription":"Attributes, which refer to user metadata"}]}
54ae3a3d-8e72-4105-98dc-1d4a358b9850	e12e8265-fad5-4d72-a560-8445939f5c5e	secret	exaOItSrcw00hpKUi2YnXMT5bMjdJhf9sCJxAMQGSar28OijMxgMowcqUjhwxytBVpxCtoxHFQNS4BwMiCgxBdLSwXHmVcNiO8SnMZ2O7LLHJz30Et49RcMoDZUnVe5WVDKr_O82R6fL4bjnwN_O5Az8--a7trsh5fzko8BIrPA
7dfe0902-2c7c-47e9-961f-20d15a9ab417	e12e8265-fad5-4d72-a560-8445939f5c5e	priority	100
ca5e9deb-2707-44a3-a3a7-14878fffe5ec	e12e8265-fad5-4d72-a560-8445939f5c5e	kid	6a4da8bc-fdf5-4440-8ae8-321515d7886f
286e7135-0e4e-4920-bbbc-b8ae9951a146	e12e8265-fad5-4d72-a560-8445939f5c5e	algorithm	HS512
b32c9e36-5d9c-4331-8cbe-defc5198dca3	35928cb0-d28d-4b7c-b354-9c1de3ff025d	priority	100
9ed2e1e6-5b7e-4279-8ed7-478112790190	35928cb0-d28d-4b7c-b354-9c1de3ff025d	privateKey	MIIEpAIBAAKCAQEA6BdXGmO3Gm5v9ZJF/mxbvUpgcNk1TfgaOm4G+4FduL324Jl6TzQBX6pwaJX+fgjzGfmBv9LUALa9t6qCe4sDoqKwHZS3D0r+atbv9MyK4h4ZbNzsiKryqEnti4nfPPOSn8wLOQ3ODxff/nd+HEmrCj2k3z63KB8ak/U7r9+ko4nw3YAhyx7PpwIJrn0gvmMyy0DNoEULKGQC+/BeqF6HAdAe9RzybotFDsNWjrnfB+zxZpIg9G17pLf/U1KR4CFRW3qa3rToCqgIbbxMuX6XkB9yiWxo0SkgdsEZ5Z7QhyVkvm0x+KIzFpZsMGWX9lexoQ4N+/QALvt/3i/71emBNwIDAQABAoIBAFBZrEUtmnmjHE23a1YO65/X/RV0jXjF2Ua7St2NxwWrdqoBWI/NIGCfYDVFIIs/y/IFKH9hnRX2Li5E8NGWqhaHHlPPZaT8wKH6ca6dlcN8yi6fOaCDFmle1seFXuz6IpwCByykc99T06+EbPucIYP1HXxQeRaB1jC9KQHVemlHMlmV0r6XCq3Y2YunsU0kKB8L03yue+P5b6xAAbFrpmbw+CdrK2aDaS7lfH/pR2+mQg8E61QH9DC2LvhLHDx4+V6Iv7GHXsoRq0BSjnq3LvnPTYBaw/icRB8tRIeyIpCnsRMlPiaf9g/3lAcNqZZokHGZAXK/fnko/D4Rrhs/MlECgYEA/gU5ihG++TiMS2oZkHW36oKxQaTj0lk6DdwPTuQ9ySCxEWuBy5BEIOcRlO9gKuf9GpAzFG5XL0L0TRwZIhv5+o5wE6WKKPOBMyTYZu3BEwd/aUCignCjuILtRhdBixM9KrcxD4GzyeAiIu2F6lbiJhGuDkFA8lE/JW5oPlJ0NU8CgYEA6eZdw6Toz2oqmvT5+k/ldF0kOmlSWC6dSPjX9PPw/nqq3ulq60ZpLJddrqa4f9zaAoiHtXy92TKQPOxtrqPKqYtzo1lEMoK1FenyKV3eyJH8pMSYEgyeOGxnjDdEJCAJpmRcd+aknMbeknVNDGNUkQ2U4cDN3xFzrMeEiWjQy5kCgYEAv3ZGsVfA3u4NaMZW8HiaIEtTuYvEIAca59lnPGpyW4eljuC+WyWpBDfGG8D1dkGXl476wTqNwlSv+PLlyrzVhVIZDeXnJgir6FWsOqCXt3UeRsHt+21VKbydhQgAYgglQW4Er5BuaAnlEPiAyGmmWVVYIOx0PHCarObz8Y2Kg6cCgYBiTceqqmyOf/hYGA3X/ixZs6u+QPWyyiSgvrVE5iGrUrLt7Pxa1cTuUM+2z6tLUe7ukaM3y62e03l7oYKXm49Zopp/VM0szXJ+O0zjxegUNAcS2O1w6Iy2+hiq/a9N34kuvY9/dRhKK+rvcw1m33hzXlnsZ7QexJ7xRwmVFtBqQQKBgQCtlXg9LOQL+qDwnJpvkwzTgaYWNto74z4ppWu8NoB9oxWlRX5u94wDgYaxWArXFe6flXMDqtbcuSdqO6yehs1mzj7nzQS/bnANTOfbd0urVUE/xbs/Ybw7HxKTktlvIajCfbMinpavFEW1v2QcWvh6yU7TO/BkFjoID/TjtEp7SA==
41cb4f19-0932-48b6-a70c-f64c6c6d0e46	0ca4e2e9-5137-4f70-90d3-5bf07a7cf7f6	secret	C3UH4raNO9FTmYQx4C0dJg
838baa97-aaea-45e0-a2b0-7b4380f6ec24	0ca4e2e9-5137-4f70-90d3-5bf07a7cf7f6	priority	100
d0577d6e-eafb-4088-9920-60dbf9a0a1f3	35928cb0-d28d-4b7c-b354-9c1de3ff025d	certificate	MIICmzCCAYMCBgGZr1zl/zANBgkqhkiG9w0BAQsFADARMQ8wDQYDVQQDDAZtYXN0ZXIwHhcNMjUxMDA0MTMxMzQ1WhcNMzUxMDA0MTMxNTI1WjARMQ8wDQYDVQQDDAZtYXN0ZXIwggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAwggEKAoIBAQDoF1caY7cabm/1kkX+bFu9SmBw2TVN+Bo6bgb7gV24vfbgmXpPNAFfqnBolf5+CPMZ+YG/0tQAtr23qoJ7iwOiorAdlLcPSv5q1u/0zIriHhls3OyIqvKoSe2Lid8885KfzAs5Dc4PF9/+d34cSasKPaTfPrcoHxqT9Tuv36SjifDdgCHLHs+nAgmufSC+YzLLQM2gRQsoZAL78F6oXocB0B71HPJui0UOw1aOud8H7PFmkiD0bXukt/9TUpHgIVFbepretOgKqAhtvEy5fpeQH3KJbGjRKSB2wRnlntCHJWS+bTH4ojMWlmwwZZf2V7GhDg379AAu+3/eL/vV6YE3AgMBAAEwDQYJKoZIhvcNAQELBQADggEBADdSenFZoKyMschzucmhHm3TYJNsutg036y/0X7/Nb6kfYib+6j6toLJToFfEDlhx4uF34qiAiDLoB1TWChbJDZJ1rvJmUlXnLp00WcUnMPgLAiwl1S1r0fNCY9DeN4WZQnly4MIbpCpTS8jRmL3W33FH1DVUWYYzmJiqYR09GORnNhBQMAsGpQixi0zY94RloT11/Bl6i0SIfmRvy5a/j3fhZkW6ZNmxwHCkg7FYu/QTAywUN/G6leEk2/VqdTQZQfpVQJrdYXBlJTcX9gaFmytbgox2T71UmwLlJ6OObenexGir587YCoRaGVg9eQDlKxmoV6U5ZxO/9ux4sB8wLo=
0662d70d-ad81-4343-99ef-c9a2daf4d8fc	35928cb0-d28d-4b7c-b354-9c1de3ff025d	keyUse	SIG
d10966fb-3fe7-4f47-8253-e27153f37e0a	c54d1de6-c04f-433b-9d21-ff10147659e2	keyUse	ENC
419f4af8-5b50-4cf2-a24b-a6e7f8db4e0b	c54d1de6-c04f-433b-9d21-ff10147659e2	certificate	MIICmzCCAYMCBgGZr1zmYjANBgkqhkiG9w0BAQsFADARMQ8wDQYDVQQDDAZtYXN0ZXIwHhcNMjUxMDA0MTMxMzQ1WhcNMzUxMDA0MTMxNTI1WjARMQ8wDQYDVQQDDAZtYXN0ZXIwggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAwggEKAoIBAQC/fiNT1VAoTn9OEORPd5HmeZ6Ea/YOHKS/VYN950F0g0ki1L4L3Z+lr8Qbu1VC+hPEqWxZ3bw4l2L9zbBb4lc21YFnJWgY/6pomgz+tf7HMmwXubMsSuedJ1Rxfglk66Dbk87TwzoUo7wOevtMvbp9/BtHjwOBuoWZg4s5xIfJmdaJO7uKH22wYUEyou2+XTtIlD/WDTAT932rY/0CG/Q0oH4QAgyBfFGQCvby+Z/ZoO9A1ahD1j9pjjJVJeif41DwHO4xxhkyQXd4V90i0VBEmAEnDfOr2NMLCWxDPGfA0drXcyaWdUaZWO9m7v1mUBO1UGfp5Q9RjgHhlj8L9p5BAgMBAAEwDQYJKoZIhvcNAQELBQADggEBADnBwRMuuETDa10bf+uleEkgs2HY+bpX9LClXU6iMUHLS8L09ZZRApgefPb/qS/VHhaHGPY230rCNObjEB70AAQtSwjTdZVVWFb0nKdt+RpKyEQGYgDAFI2+ZrjqhvgI3Aji99q5tUrJ6W0aC4MvrcyOpNYoeCneK5cUyq/sN+fedQdYlyV5Y9aKrTDPL0/9xrQ4FS/ZGtQLfiPT5dBq1JAFMU9C19qJfSXcbVDHKa7Xgj7qQaoedvNlUWPsdF53O3TATiiCdoQdVDgJi+YIX+BK4a2lFAihg628yYLpEQ6Fotz5bNDFJScxAkLifMDb+zuJJ7F0mSrCLBnsxBOVAFc=
c7835c06-073c-4484-b672-bdbfe9004c64	c54d1de6-c04f-433b-9d21-ff10147659e2	algorithm	RSA-OAEP
a2cdba59-fd01-4314-a8d4-1ea38853fe30	c54d1de6-c04f-433b-9d21-ff10147659e2	privateKey	MIIEowIBAAKCAQEAv34jU9VQKE5/ThDkT3eR5nmehGv2Dhykv1WDfedBdINJItS+C92fpa/EG7tVQvoTxKlsWd28OJdi/c2wW+JXNtWBZyVoGP+qaJoM/rX+xzJsF7mzLErnnSdUcX4JZOug25PO08M6FKO8Dnr7TL26ffwbR48DgbqFmYOLOcSHyZnWiTu7ih9tsGFBMqLtvl07SJQ/1g0wE/d9q2P9Ahv0NKB+EAIMgXxRkAr28vmf2aDvQNWoQ9Y/aY4yVSXon+NQ8BzuMcYZMkF3eFfdItFQRJgBJw3zq9jTCwlsQzxnwNHa13MmlnVGmVjvZu79ZlATtVBn6eUPUY4B4ZY/C/aeQQIDAQABAoIBABvS5aowM/nvUfMTZEEhtArjgANotnNdeRiuAbGhEPMvgkhz1fteY+yMqfeHlD9rm8S3A13ZaJhmcsVDBk2LiTWX9zn4BvSe7XFOdPXrls31xxv5aQ3WAmpkxRHKiO3niNNu2h4N31oRYmlOOEZxyO+2WnZe0tkeM3xXTzsBEePaXJDqBe5Kr7INCmfznlxBlAZq7PdFITXqm1luS7C6U1pvuZ4RWjmMUi4fSl+FCSW4yUqRUQiYTualq7EnokrZ0YRXSXQPi99QStiNYC0VZgm7rmTHsTVAvbY/7lHgXytpxvfwx/BJA4UQKhV+jHhm5L2RjIU7CyouTeT0F08Uu5MCgYEA6Z30CF+VQ8Y1Sl4CP6dUWvl0SSgjxRAZo3Lyysa0AFmrkMrQAf3FiJZOhUAkvK2tE4ZnD6PCaFU2uaoeHC5EgGvyoWJO+A8j9XFwvmVE0Ru7X/Ha0UsBRK/VBZyQON8EyKTP/yNP0aRxv1xCTt/AO5dUcT9KYEAe3FDofT8VtrMCgYEA0db7AT3MeQN9ZWPWIT/puVB72u4bhC1QD4ejPKmMUvMHa98GWOIWhnQOxoxxsgxaQgm/3OYZr/3kUcI1ebWsaGQ0rsPnxiBNLo6o1n3YjCQSFaRjbmFGBaqWodPHPYanP7gwVkr4TCiYcP0KettDPDun8xjJDC/rze5JxP6t8TsCgYEAsg7o9ATeQNTuwyrZ7eg8nEZrgmLsuINn9zNiqHlAss+lu2tJlWr1xwBBAsD7/y8krrAPF1WKlHj2iBaIcpQ1M+iS+rxyUhFAKA/5jbSj+fl4HE27qS/Q3Khj5a4KIr6g58jum5kveisrY14PUAyseP8DpnlF2AynOOcV/Hg7tY8CgYAgXHIrV9d/1izxhPsR96RY4vOm6M+vi7lsG7Pt+AvfAwHi/eshrARjSeS5dBFYrxUAWDaRn57YiGQ8w6GxmnXzR3jkduv4nySoCHI7Wf8aZbmwQsDe1fuRhiRi4qE4eNq0NfimZjtyq1QPIMcL+WKeGGknUWw4B+/qu1P/IHO83wKBgA9GXRPRIB/jDxVvL0GaGhSiaYmaUyRawyhTo3a5+6ri6RtO+lKovYGQ1cD7eYPehXmFjy7E9xlhuvzUDx9/RyRUXGMt4dGrHcFLFGCYIHGtx/gBWIDB/+JhT0ysEuIDsQVH/RQQqZMnDXdG8dltD1JvKhszH+mvKEQye7dLzh6i
1833912d-75f9-4294-a809-99e15ab32c71	c54d1de6-c04f-433b-9d21-ff10147659e2	priority	100
48bffdf1-0161-44e8-983f-2b5a5f09999d	a2c4dfd0-931e-4e79-aaad-e697b8448f07	priority	100
04783b5c-6297-4fa9-bff4-b98854c09582	a2c4dfd0-931e-4e79-aaad-e697b8448f07	algorithm	HS512
189ce081-0344-40c1-b9a2-91377be521fa	a2c4dfd0-931e-4e79-aaad-e697b8448f07	kid	5fb5a4e1-effe-4aa4-aa14-c0547ef9e6fa
f0df0882-a301-469f-8bfd-b421c2e404b6	a2c4dfd0-931e-4e79-aaad-e697b8448f07	secret	tu3SY-6ci2k7qqbWOSylP85eVSn5gnFXq868X_08jrv6iSE_WM8FL-JEIJGGrsNDbu9xlg8-ieVupCwU5eYAWcn2Abs6BJ-tsPhWVT3_yij3a6iMni8YaoakH8GagPMKMgGAytKRZWg08uHlB3tE4euliPoAgBOJrRwoaHbgHQc
f386ef44-b1b2-499c-9b11-f432a321ed42	c9db1d43-deb8-4f57-9196-c0d5fec3e4d1	algorithm	RSA-OAEP
2773db4e-f622-4990-99db-43cd89df4517	c9db1d43-deb8-4f57-9196-c0d5fec3e4d1	privateKey	MIIEowIBAAKCAQEArOwyOYpREjdxKe3Qus9L4DnecHsBN0779KZqRLgBebvkKUZQ+ntTNCjYBlz/5P/s+4iKJIAWq7QOFAsk2IGndw6rJIEb91O9LOuuUTDuA2wGwKyo8E0nYBcns5G7VJSDKtSPUMlWnCeNovCsJ3IbGtPM6bUkb8lqzgpeSrAkfnexus89LZ0PNjY4hHfzbkpbLRd7cAMEBty2ekO5mp+GndKbmS4kKwM1nYRQsMUwWHUwi+xVPqZPYEJ/5O163KjJG8brzsJC9iU/RTZGD/Fz4M8l+OJexdBFRrO8X7xG2W9HtxaHiKejgt5cGYsAlb/fMizP6CqYv+6byAirn4R4dQIDAQABAoIBAATtGaUv/o1BTRT/tGGOBEBYBbE4n9k+g8j9cKuSfmBEbQSL/0STfNRQkY7k2VlhvRORWTYe/AZaM8h4ZM1SLD4lCdUZZH2QQiRkdmvTtAQe8LZOdOWbnRKMtlHURfzr2iy/L3ICulfqfIt2xcC97G3AOOczhN02ZLeH7hW8nN2JaVyemTJYw5TmhbeCs4LEX9Byub0le9gVFKXek0VM3e40+wv85rj3lpFRV1HDBEfLMuzl4/6HvtJFsVQ+X6EVK+nkWlIk91cMss91YapeTTNA946iz6oUYh1Ih/xCi5elOYqfaFlW2JyiVMHw1Ii4XO+MWO2AXgYkx5jphWxvlAUCgYEA5FNrtLo6uti58MrOcQXgEXopFrnn58q0T7aMoZ+fVdAa/l17MHqqvn3r/ytgUtyt4JY7CQxVjvzLQcdxGe1+9qX71nLvYLYuupTk45oOjZH2161XO/gIpSuQpF31SGi9A+mQUf9ji8ji2hTExVlVXmfRk6aYme5gIJx1ha3egzcCgYEAweG0Lw6bhIor+zVsNu21wqllYvJFNPnNh2fQtzEkxQS2wbYEB1CYJuwNDlGnf7h0zjuC1EwhH4vYYIpmC7ieGVd0HwaiRweaHqaxfNJPAhEeZjVHoe1yld4rAoIMHy9z/MvixJXap8WlNOu8+rcDkwoT3lnMv0NBLpA0FEL1j7MCgYEAlmo2XDsLEahQ5kZUtbRvJlRZ2TTjh5nMK29ROfBUIU4VWljvHMLS1OdTnyhOLoheq8OMZKuReb8jj9P5uGDy8T3rqBzTgdzC7/vCxgXpbG4qNW9mNoVx/I20nfOf8PG/A2LMxpf+Vkoi2BQyhOgTCzxNnn1zroSRIyqvaT9fhQUCgYAz2qHOVCHT+QB6V3dx2XHbdmLfa9yGpqkJpgJ0fHhRGUmn1X6OVkfbYRa81anuxu62mcQL87CIN2bPqzRPvjjKnlE4WxXb2XSm7f5aXAU1kE6JF4bpEBCtdJYcPZvwW0iyO/WSjmHErV/aH5KTm48hLHjT50CThvFP+tFy+dWjcQKBgH+d/2aXUI/GJugYE2e+zAHjYHTtf5ElZFvprk1WG5nyLdPtNQ9/gAtepxiqkP3EEhucAv3/xhYN81ex+RupJt2U4Iw/O6YTjF/bXpnC7lRAc/59JO89bsVIm5SXyozlaSCqRhCEhTVYLVAXh8MroGSCFfqqzDKpIKVhTih1RTHn
4b1bd280-33a4-4519-9df0-ca97118bde9b	c9db1d43-deb8-4f57-9196-c0d5fec3e4d1	certificate	MIICpTCCAY0CBgGZr16YOzANBgkqhkiG9w0BAQsFADAWMRQwEgYDVQQDDAtwaXZvaW5lLmFydDAeFw0yNTEwMDQxMzE1MzZaFw0zNTEwMDQxMzE3MTZaMBYxFDASBgNVBAMMC3Bpdm9pbmUuYXJ0MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEArOwyOYpREjdxKe3Qus9L4DnecHsBN0779KZqRLgBebvkKUZQ+ntTNCjYBlz/5P/s+4iKJIAWq7QOFAsk2IGndw6rJIEb91O9LOuuUTDuA2wGwKyo8E0nYBcns5G7VJSDKtSPUMlWnCeNovCsJ3IbGtPM6bUkb8lqzgpeSrAkfnexus89LZ0PNjY4hHfzbkpbLRd7cAMEBty2ekO5mp+GndKbmS4kKwM1nYRQsMUwWHUwi+xVPqZPYEJ/5O163KjJG8brzsJC9iU/RTZGD/Fz4M8l+OJexdBFRrO8X7xG2W9HtxaHiKejgt5cGYsAlb/fMizP6CqYv+6byAirn4R4dQIDAQABMA0GCSqGSIb3DQEBCwUAA4IBAQBTqbT9chx2Feuw43uSJpdyl33N/avZqo0p4bSIuXgS3WU73tDbwYyopY0Xy6jBpR08Ye41gjrGTsxBotTSKr64mPQ1fsntI/HAuin4jv1+H58GFvYAdlY7WTRC24Lh9G/q4S8zTTCdycOuo28WFnNCcc/CfPwlKGXe9Oc8p7LzKTuaHrr7u85AqECFMGLNq0CFdDRupjis0h+uVlTmE1gPwk3YlYRUY3PZNh7heBOUfYQsOd9eCrVUURQ1IykznpQdN4TZC93IUej0J/CH6XnQZCaokbvCgw2BiReYPR1q6tXvkbI2zshLHQoAiPNAn+jHDgICsUh2Qda/TGEWCcTV
9380bf9f-4569-49eb-b678-aadff01c3793	c9db1d43-deb8-4f57-9196-c0d5fec3e4d1	keyUse	ENC
90ccbe88-6066-405e-8360-3a33fb3d1cf5	c9db1d43-deb8-4f57-9196-c0d5fec3e4d1	priority	100
c1259baa-9d0c-4609-b021-c6e2da7c9b35	0ca4e2e9-5137-4f70-90d3-5bf07a7cf7f6	kid	1f480748-b503-4a56-9e5e-236a00fca4e5
a75de25b-e42d-420d-9365-bacfe93a25d1	b864fd11-ab2d-458d-9ca2-73507bf05662	certificate	MIICpTCCAY0CBgGZr16YFDANBgkqhkiG9w0BAQsFADAWMRQwEgYDVQQDDAtwaXZvaW5lLmFydDAeFw0yNTEwMDQxMzE1MzZaFw0zNTEwMDQxMzE3MTZaMBYxFDASBgNVBAMMC3Bpdm9pbmUuYXJ0MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEA2hMao3z+0ZrA6IPY9R3n5zuKYjSp2dLWFv/sqRhvTtQc4z9j8wJf5tao+0UxyuL7kk7tbjzU0nxEw/cECzkQUdExdP3ffyOhlKz/F88PPxDaugXC1fYPTBfYHb+L+zOxanMXP9iaSlk+M4ZkokQ5UyMb5c4n2aF4CZfVprWjQ+0zhmFYdV4PeXxC+j+xIzLzVJwJjbeoI7AEnBdwvqpwr7jPMssDWD62pfJivciBCVnsRgePNuGSWpfZmeZOSOxQxxjNSRFwYODk578C2Jh7MUTooqYJOj3q8ZqidfLcXJJ+1ebC93O4BKgz56IOqdOYGopXPQOumqHmziBT0qMggwIDAQABMA0GCSqGSIb3DQEBCwUAA4IBAQCJXG+PLLkND8eDQHqq/wu9N/gddxcYowDzZFDxdDxbwjk/AmcquhoteLBgSuy8ScYB4X5EZ3DTvux2FKkk6BSIH61JgVJ/2dhpJEahKQen31o7VPVvZEQLbUX5rOTNLAIpVpEHtmMY7chsodqYjpAGGI15d0i+JB10hMlBqROUPb4rYDQmWw+A6RwKHlXBkFqArGJXZyENuwRS2HEPKEdLkKLFWYD4RA8Gp5+HGJRDUIiuErwkMtOKGOKtRU5JyyeC8gUlELuSmu5kO7cwEUrZ6PAILn4EW5BrHLx73NxKNiaXntV/DoDjD6penvgux6hTJTmDn698kIQntTcSwKFc
50d540ec-455a-4250-96c3-e8e69c7ed2a0	b864fd11-ab2d-458d-9ca2-73507bf05662	priority	100
055b580f-b811-4374-918b-ee04a9ae5ce0	b864fd11-ab2d-458d-9ca2-73507bf05662	privateKey	MIIEpAIBAAKCAQEA2hMao3z+0ZrA6IPY9R3n5zuKYjSp2dLWFv/sqRhvTtQc4z9j8wJf5tao+0UxyuL7kk7tbjzU0nxEw/cECzkQUdExdP3ffyOhlKz/F88PPxDaugXC1fYPTBfYHb+L+zOxanMXP9iaSlk+M4ZkokQ5UyMb5c4n2aF4CZfVprWjQ+0zhmFYdV4PeXxC+j+xIzLzVJwJjbeoI7AEnBdwvqpwr7jPMssDWD62pfJivciBCVnsRgePNuGSWpfZmeZOSOxQxxjNSRFwYODk578C2Jh7MUTooqYJOj3q8ZqidfLcXJJ+1ebC93O4BKgz56IOqdOYGopXPQOumqHmziBT0qMggwIDAQABAoIBAAx+PK/yCL0kUvnfF85PFMqD+DURFEv0zqwJpFq5miLXdwIzzvuMfscANDUU7TnU0Bm9KNAAbybR1LSvUY19CujNBbrQkn27olWcpY6NH6/6vLUcgGF2k8DFuu1VXGUbPIY/Kq1PMOOigjQ8dkZvhyMypzX+nfzTSceu6Z//1ucctBf7AFRTtnqzlOmuyrd2wXdfwKepRZZymfqb8mTfzRqOOu5z7ebkoX74t8q1L9w1j/lrz4aBdi8jsUcmtAExxCESiDPTxd55H42Fb02CHn9keBiuE1YMdiP3krmyICxeomueyTN2yQMl4oV8GcrvgQXKmN7eJpTZOkQnl11eJoUCgYEA9WfVj1ZKhjpsizfZpLQV7PsBMIzmhGOUQUmW4QIDEctQaQOezWCWEyMVKR0LFGXHhz4X2iiVQiS5AgcxVa3ya+xbVpyJbx3lSH0bY20h3XZHRedeVbDLl9QRYcAHtiD1NEgfrRGPkaBVV85gKc+Lb+0RP7MagasgVa4OeXhoKS0CgYEA43021xxqCrN7nM7uQTERKle/u9Nx5w0KyjqKT8qvwkgJhVUPElpapI+iXRbNrovzejQZx+vmVHcQSB9xFR0WpVntjJrfgb09Ioa7bmYVAlYdEdQfKhFaT4pg8UHGnHc4mLXbNlZCwg/8bIXm0G3HkCxocZ0ASyz0JMme/ob+Hm8CgYEAyS+3BSvZLPH4yqme5Eg/MWkWMJdS5HY+tMd/yje8DHqCEZXGOtlUL5wzXOFSlAZc7aMaKt/afb9dbSw4ZeWVOKUsvHTYtx/rOOJX8csmWEj/ZW+pBtdKEc7p8RldORML8zCtx1T+PoUTckjezWg5CClyWqaatHN2rsdjVnI/8oECgYEAxBl2Iqx9xMe/cQb4Xv4bG/MUdqbo8xFNEdKw0+OW6tUKUANowJtes6iVf8VefG5r7hXne20g2gLg6CsiYd73XIZOvfvrW31zq8WU4K/iwGbXHD1MuAjJXvOcaZwXx10GTq3FT+vAFGWPZUVwGI/pjaCaUAXU8PjJZMTg5+waNsUCgYA6WEZcSQM1TL45C8Ub/Fr2GEOIbbAHhS9PWf+2g4KnkyqX8N6Nhhko/DGh/IAzzBehgfHazpgn/9VINs6QDfo/AydE5b0/hBHPz/WLQj2p0hjtCocQB63GodsoLv747FPBQQfP+vJ5VdWMfb+5E2A6/rLuNkximOJhRaDYzRFaEg==
ca4ddb01-df40-40e7-a8f8-b26fa00fc490	b864fd11-ab2d-458d-9ca2-73507bf05662	keyUse	SIG
a11ffe6e-a213-4896-bdeb-aa5c3ce80891	4cadaa68-44fa-4e31-9233-5c785ff6d68f	host-sending-registration-request-must-match	true
8d520d9b-132b-4f8a-b121-96c47741e78e	4cadaa68-44fa-4e31-9233-5c785ff6d68f	client-uris-must-match	true
e352aef0-457f-489d-9a7c-18a2e59b4789	29ee13d2-640b-4ffc-b6f0-6dad67515d11	max-clients	200
671135b2-1712-4b57-88b5-aa79ee6264d1	d30e4f75-2f13-4ac0-8879-dfd5f77e2c6c	allowed-protocol-mapper-types	saml-role-list-mapper
55ace0c3-6441-48be-ab0b-2916a4a8893d	d30e4f75-2f13-4ac0-8879-dfd5f77e2c6c	allowed-protocol-mapper-types	oidc-usermodel-attribute-mapper
bdb6f0c8-c5c6-4629-be07-044080419588	d30e4f75-2f13-4ac0-8879-dfd5f77e2c6c	allowed-protocol-mapper-types	oidc-full-name-mapper
1ec892a3-9570-46aa-9a19-f726d897ed8d	d30e4f75-2f13-4ac0-8879-dfd5f77e2c6c	allowed-protocol-mapper-types	oidc-address-mapper
731c4589-e01d-4557-bd85-130738bf51f7	d30e4f75-2f13-4ac0-8879-dfd5f77e2c6c	allowed-protocol-mapper-types	saml-user-property-mapper
cd2ed3cd-5fdb-447a-96e2-6c99a9b816b6	d30e4f75-2f13-4ac0-8879-dfd5f77e2c6c	allowed-protocol-mapper-types	oidc-usermodel-property-mapper
ad8b2287-5f74-4c5e-9493-7dd812f155e0	d30e4f75-2f13-4ac0-8879-dfd5f77e2c6c	allowed-protocol-mapper-types	oidc-sha256-pairwise-sub-mapper
975967f2-11b1-440d-aadc-f7829e148d2a	d30e4f75-2f13-4ac0-8879-dfd5f77e2c6c	allowed-protocol-mapper-types	saml-user-attribute-mapper
a39520d6-c4b0-4037-b344-3cf0a3b8033e	3774c482-c0a7-4d63-90ad-ef50f29649e6	allow-default-scopes	true
3840ca3d-3945-4ce8-81ab-0e2608ca5966	bdfd0b15-53a8-4509-b3b6-2adf462489d0	allowed-protocol-mapper-types	oidc-usermodel-attribute-mapper
781e90e2-3aff-4dea-93d2-a03bac310b7b	bdfd0b15-53a8-4509-b3b6-2adf462489d0	allowed-protocol-mapper-types	oidc-usermodel-property-mapper
58c11cbc-06c5-4267-ab2b-e617366d8a09	bdfd0b15-53a8-4509-b3b6-2adf462489d0	allowed-protocol-mapper-types	oidc-sha256-pairwise-sub-mapper
5eb4d8aa-2925-477f-8732-3fbc716b23f3	bdfd0b15-53a8-4509-b3b6-2adf462489d0	allowed-protocol-mapper-types	oidc-full-name-mapper
ac946055-56bc-420f-9c7e-9b9ab8f19743	bdfd0b15-53a8-4509-b3b6-2adf462489d0	allowed-protocol-mapper-types	saml-role-list-mapper
8405fcfc-8de8-419a-a932-596de212f033	bdfd0b15-53a8-4509-b3b6-2adf462489d0	allowed-protocol-mapper-types	saml-user-attribute-mapper
9619c007-ebd5-4528-b56b-12079d902419	bdfd0b15-53a8-4509-b3b6-2adf462489d0	allowed-protocol-mapper-types	saml-user-property-mapper
76f497b0-4a79-41eb-8c44-c56af719c3d1	bdfd0b15-53a8-4509-b3b6-2adf462489d0	allowed-protocol-mapper-types	oidc-address-mapper
e20162cb-9c53-4e34-80d4-c3c782be8ad6	d020cf26-9806-46cb-b0dd-2ce1a6ee035a	allow-default-scopes	true
\.


--
-- Data for Name: composite_role; Type: TABLE DATA; Schema: public; Owner: valknar
--

COPY public.composite_role (composite, child_role) FROM stdin;
33a5cb28-0c54-45db-bbf7-0aceb2816172	3faa959a-d3bb-4a2e-ba67-88abac994c80
33a5cb28-0c54-45db-bbf7-0aceb2816172	2c09bb2d-06cc-427f-97dc-0d4aeea5ea0b
33a5cb28-0c54-45db-bbf7-0aceb2816172	5e402a72-1561-4690-ac36-4c820cec06b4
33a5cb28-0c54-45db-bbf7-0aceb2816172	882b1e5d-4dd7-46af-92e4-3d20c8d46a35
33a5cb28-0c54-45db-bbf7-0aceb2816172	3e50c3be-0842-4601-ad95-507ad55e0088
33a5cb28-0c54-45db-bbf7-0aceb2816172	6316ec15-da8e-4413-ad57-e413e4486e57
33a5cb28-0c54-45db-bbf7-0aceb2816172	51299522-0e29-46b1-9daa-bbea8fe3125b
33a5cb28-0c54-45db-bbf7-0aceb2816172	428bdd17-acb1-4d8d-b771-f4a400091c23
33a5cb28-0c54-45db-bbf7-0aceb2816172	b10722f8-81b3-493f-b1af-7ca192470eeb
33a5cb28-0c54-45db-bbf7-0aceb2816172	57a79214-ee05-4eee-81f7-9e979e245da7
33a5cb28-0c54-45db-bbf7-0aceb2816172	0a8b6bc6-4e3f-4392-a3fa-0288bf69c1a3
33a5cb28-0c54-45db-bbf7-0aceb2816172	8eb17802-935e-4d93-87e1-74175258d87b
33a5cb28-0c54-45db-bbf7-0aceb2816172	a8e00f94-58c8-4d14-87ce-452abb76340b
33a5cb28-0c54-45db-bbf7-0aceb2816172	510bdfa6-13a7-43a0-abc4-5afa2dff699f
33a5cb28-0c54-45db-bbf7-0aceb2816172	ad403d7a-f928-484b-bfe1-6eee16819a3a
33a5cb28-0c54-45db-bbf7-0aceb2816172	ecb0ed91-dfc0-44a3-b165-977d7fe976e5
33a5cb28-0c54-45db-bbf7-0aceb2816172	872a6f56-c435-47a7-8a47-d54664224829
33a5cb28-0c54-45db-bbf7-0aceb2816172	b416ac3c-cf43-4b4d-8323-cc8f2238c24e
3e50c3be-0842-4601-ad95-507ad55e0088	ecb0ed91-dfc0-44a3-b165-977d7fe976e5
54fe2c16-b141-4a22-b5ef-d24d35a38ccc	6df1e072-9298-447d-a3cb-b7c39b70702c
882b1e5d-4dd7-46af-92e4-3d20c8d46a35	b416ac3c-cf43-4b4d-8323-cc8f2238c24e
882b1e5d-4dd7-46af-92e4-3d20c8d46a35	ad403d7a-f928-484b-bfe1-6eee16819a3a
54fe2c16-b141-4a22-b5ef-d24d35a38ccc	7876c425-56bd-499a-bc55-dffb1b64c005
7876c425-56bd-499a-bc55-dffb1b64c005	86f8c008-455e-4764-a327-17d69cfb281c
02337920-bee1-4a50-a40e-aade334f818f	bfb0a630-3585-4cd4-a310-9950be069484
33a5cb28-0c54-45db-bbf7-0aceb2816172	b13ac2cf-8fa1-4e76-8200-9be68f702eab
54fe2c16-b141-4a22-b5ef-d24d35a38ccc	42a4cd37-3f8c-419d-b894-c17749889e03
54fe2c16-b141-4a22-b5ef-d24d35a38ccc	70b1df9b-c0af-4398-b78b-1555def75d3e
33a5cb28-0c54-45db-bbf7-0aceb2816172	afc2af5d-7da8-4039-aab4-dc8844872ded
33a5cb28-0c54-45db-bbf7-0aceb2816172	8a68ca04-3339-47ba-be7d-aabd3e26e8b5
33a5cb28-0c54-45db-bbf7-0aceb2816172	d9f6e1f3-718a-44b8-9289-b12f7dc608f8
33a5cb28-0c54-45db-bbf7-0aceb2816172	e150e283-31e4-404b-b288-09c2b303c436
33a5cb28-0c54-45db-bbf7-0aceb2816172	72b9e56d-14bd-46cd-a5a8-7b481159e4cb
33a5cb28-0c54-45db-bbf7-0aceb2816172	6a230f46-6d45-47ce-9559-7d27f3d3e570
33a5cb28-0c54-45db-bbf7-0aceb2816172	28e9e9de-3a3d-42de-b345-2ce7ff83bb25
33a5cb28-0c54-45db-bbf7-0aceb2816172	7a449afe-2eb9-469f-ad3c-ff725acf05a9
33a5cb28-0c54-45db-bbf7-0aceb2816172	177075ca-ae6c-45ea-9358-fc6d6b6ab698
33a5cb28-0c54-45db-bbf7-0aceb2816172	b4288e0c-8c07-4930-b2d7-5c44d03d4736
33a5cb28-0c54-45db-bbf7-0aceb2816172	979d735b-7332-4f3c-9094-becb2998fc12
33a5cb28-0c54-45db-bbf7-0aceb2816172	d3bb4d5f-68ee-4c21-aefd-91a59fa40394
33a5cb28-0c54-45db-bbf7-0aceb2816172	b6644991-5c9e-4668-8ace-e1b53e6d6b09
33a5cb28-0c54-45db-bbf7-0aceb2816172	de119a47-0207-4912-9af8-374b92dd60a8
33a5cb28-0c54-45db-bbf7-0aceb2816172	54a29634-c0e8-4298-88f9-5abd0e2b2f39
33a5cb28-0c54-45db-bbf7-0aceb2816172	9edfaea2-d918-478e-802c-87cc2f28caa2
33a5cb28-0c54-45db-bbf7-0aceb2816172	4e836731-0139-4bc6-ac08-6ebec077d859
d9f6e1f3-718a-44b8-9289-b12f7dc608f8	de119a47-0207-4912-9af8-374b92dd60a8
d9f6e1f3-718a-44b8-9289-b12f7dc608f8	4e836731-0139-4bc6-ac08-6ebec077d859
e150e283-31e4-404b-b288-09c2b303c436	54a29634-c0e8-4298-88f9-5abd0e2b2f39
0820ab47-f4e6-4929-8b57-1f3160fff57c	8728b3a1-4d11-4d29-b870-d4e745866866
0820ab47-f4e6-4929-8b57-1f3160fff57c	8532486b-4100-4f33-bddd-7d3de1d45e41
0820ab47-f4e6-4929-8b57-1f3160fff57c	d8f0f65b-f633-4cd2-b63b-54ce97448f80
0820ab47-f4e6-4929-8b57-1f3160fff57c	dac9d43f-1b24-4f55-8791-ab9faa3081b5
0820ab47-f4e6-4929-8b57-1f3160fff57c	c78d42be-0ac4-4528-ae73-4e4ca8ffbcae
0820ab47-f4e6-4929-8b57-1f3160fff57c	0ff76ba6-cb91-4c8d-8340-cc30709aa5db
0820ab47-f4e6-4929-8b57-1f3160fff57c	050cd0e1-c3e8-4228-9db4-1240813a0c80
0820ab47-f4e6-4929-8b57-1f3160fff57c	821a9342-9cc7-400f-986d-4b59c40f8516
0820ab47-f4e6-4929-8b57-1f3160fff57c	4f75de12-39dc-4364-b90f-34d35be6cd66
0820ab47-f4e6-4929-8b57-1f3160fff57c	6f970d95-4ce8-438f-b41d-36daf45b6f88
0820ab47-f4e6-4929-8b57-1f3160fff57c	2d237b7c-1db7-4720-8db1-8344ec0db703
0820ab47-f4e6-4929-8b57-1f3160fff57c	2120dc7d-1c4b-48d4-bbea-f004e26d22a2
0820ab47-f4e6-4929-8b57-1f3160fff57c	ca579b28-efc3-455b-ab91-7334f7e29238
0820ab47-f4e6-4929-8b57-1f3160fff57c	aca3d119-91c0-4238-9654-bb418ad8a338
0820ab47-f4e6-4929-8b57-1f3160fff57c	d33a6b59-37fe-42d4-a444-9f227273aa8a
0820ab47-f4e6-4929-8b57-1f3160fff57c	15ee3c0b-d4fa-4ff2-af53-969ad65c3094
0820ab47-f4e6-4929-8b57-1f3160fff57c	0cc66ba5-9121-45e6-9c46-8543f060565a
8a361c62-09d4-44f2-828b-be78e38e8966	e6da4ae5-a0ff-4c3b-a5b9-500de2a2ed67
d8f0f65b-f633-4cd2-b63b-54ce97448f80	aca3d119-91c0-4238-9654-bb418ad8a338
d8f0f65b-f633-4cd2-b63b-54ce97448f80	0cc66ba5-9121-45e6-9c46-8543f060565a
dac9d43f-1b24-4f55-8791-ab9faa3081b5	d33a6b59-37fe-42d4-a444-9f227273aa8a
8a361c62-09d4-44f2-828b-be78e38e8966	0ec4e6ea-0f9f-4d17-9805-5154acfcaaac
0ec4e6ea-0f9f-4d17-9805-5154acfcaaac	4a0259ee-8846-4abb-aebd-26be5f392a0c
448fe05f-fe5f-4810-9a01-80ba41c92604	5542dc51-81df-41cf-a979-55b8cb0a67c5
33a5cb28-0c54-45db-bbf7-0aceb2816172	bde0ad48-3714-4424-a028-011c3449d19a
0820ab47-f4e6-4929-8b57-1f3160fff57c	166902e1-5f23-49f2-90e4-9b8cd585a82d
8a361c62-09d4-44f2-828b-be78e38e8966	fcf0fa2d-93b5-461b-9abb-2c1645106857
8a361c62-09d4-44f2-828b-be78e38e8966	ee3e0abd-7409-4b7a-b718-b884194db528
\.


--
-- Data for Name: credential; Type: TABLE DATA; Schema: public; Owner: valknar
--

COPY public.credential (id, salt, type, user_id, created_date, user_label, secret_data, credential_data, priority, version) FROM stdin;
b1a69a1d-a9f8-4916-a31b-99255c49d350	\N	password	36bd20b1-3cb4-436c-92f6-da018e4426ee	1759584100502	My password	{"value":"SH0MUfwZsU9hcz6xB4w287xd2aex/XKOy/ar6iJ4bDk=","salt":"rvDSsC2/od6WadhDuI5WiA==","additionalParameters":{}}	{"hashIterations":5,"algorithm":"argon2","additionalParameters":{"hashLength":["32"],"memory":["7168"],"type":["id"],"version":["1.3"],"parallelism":["1"]}}	10	1
\.


--
-- Data for Name: databasechangelog; Type: TABLE DATA; Schema: public; Owner: valknar
--

COPY public.databasechangelog (id, author, filename, dateexecuted, orderexecuted, exectype, md5sum, description, comments, tag, liquibase, contexts, labels, deployment_id) FROM stdin;
1.0.0.Final-KEYCLOAK-5461	sthorger@redhat.com	META-INF/jpa-changelog-1.0.0.Final.xml	2025-10-04 13:15:20.296259	1	EXECUTED	9:6f1016664e21e16d26517a4418f5e3df	createTable tableName=APPLICATION_DEFAULT_ROLES; createTable tableName=CLIENT; createTable tableName=CLIENT_SESSION; createTable tableName=CLIENT_SESSION_ROLE; createTable tableName=COMPOSITE_ROLE; createTable tableName=CREDENTIAL; createTable tab...		\N	4.33.0	\N	\N	9583717615
1.0.0.Final-KEYCLOAK-5461	sthorger@redhat.com	META-INF/db2-jpa-changelog-1.0.0.Final.xml	2025-10-04 13:15:20.307633	2	MARK_RAN	9:828775b1596a07d1200ba1d49e5e3941	createTable tableName=APPLICATION_DEFAULT_ROLES; createTable tableName=CLIENT; createTable tableName=CLIENT_SESSION; createTable tableName=CLIENT_SESSION_ROLE; createTable tableName=COMPOSITE_ROLE; createTable tableName=CREDENTIAL; createTable tab...		\N	4.33.0	\N	\N	9583717615
1.1.0.Beta1	sthorger@redhat.com	META-INF/jpa-changelog-1.1.0.Beta1.xml	2025-10-04 13:15:20.326785	3	EXECUTED	9:5f090e44a7d595883c1fb61f4b41fd38	delete tableName=CLIENT_SESSION_ROLE; delete tableName=CLIENT_SESSION; delete tableName=USER_SESSION; createTable tableName=CLIENT_ATTRIBUTES; createTable tableName=CLIENT_SESSION_NOTE; createTable tableName=APP_NODE_REGISTRATIONS; addColumn table...		\N	4.33.0	\N	\N	9583717615
1.1.0.Final	sthorger@redhat.com	META-INF/jpa-changelog-1.1.0.Final.xml	2025-10-04 13:15:20.329213	4	EXECUTED	9:c07e577387a3d2c04d1adc9aaad8730e	renameColumn newColumnName=EVENT_TIME, oldColumnName=TIME, tableName=EVENT_ENTITY		\N	4.33.0	\N	\N	9583717615
1.2.0.Beta1	psilva@redhat.com	META-INF/jpa-changelog-1.2.0.Beta1.xml	2025-10-04 13:15:20.379828	5	EXECUTED	9:b68ce996c655922dbcd2fe6b6ae72686	delete tableName=CLIENT_SESSION_ROLE; delete tableName=CLIENT_SESSION_NOTE; delete tableName=CLIENT_SESSION; delete tableName=USER_SESSION; createTable tableName=PROTOCOL_MAPPER; createTable tableName=PROTOCOL_MAPPER_CONFIG; createTable tableName=...		\N	4.33.0	\N	\N	9583717615
1.2.0.Beta1	psilva@redhat.com	META-INF/db2-jpa-changelog-1.2.0.Beta1.xml	2025-10-04 13:15:20.383672	6	MARK_RAN	9:543b5c9989f024fe35c6f6c5a97de88e	delete tableName=CLIENT_SESSION_ROLE; delete tableName=CLIENT_SESSION_NOTE; delete tableName=CLIENT_SESSION; delete tableName=USER_SESSION; createTable tableName=PROTOCOL_MAPPER; createTable tableName=PROTOCOL_MAPPER_CONFIG; createTable tableName=...		\N	4.33.0	\N	\N	9583717615
1.2.0.RC1	bburke@redhat.com	META-INF/jpa-changelog-1.2.0.CR1.xml	2025-10-04 13:15:20.424372	7	EXECUTED	9:765afebbe21cf5bbca048e632df38336	delete tableName=CLIENT_SESSION_ROLE; delete tableName=CLIENT_SESSION_NOTE; delete tableName=CLIENT_SESSION; delete tableName=USER_SESSION_NOTE; delete tableName=USER_SESSION; createTable tableName=MIGRATION_MODEL; createTable tableName=IDENTITY_P...		\N	4.33.0	\N	\N	9583717615
1.2.0.RC1	bburke@redhat.com	META-INF/db2-jpa-changelog-1.2.0.CR1.xml	2025-10-04 13:15:20.42783	8	MARK_RAN	9:db4a145ba11a6fdaefb397f6dbf829a1	delete tableName=CLIENT_SESSION_ROLE; delete tableName=CLIENT_SESSION_NOTE; delete tableName=CLIENT_SESSION; delete tableName=USER_SESSION_NOTE; delete tableName=USER_SESSION; createTable tableName=MIGRATION_MODEL; createTable tableName=IDENTITY_P...		\N	4.33.0	\N	\N	9583717615
1.2.0.Final	keycloak	META-INF/jpa-changelog-1.2.0.Final.xml	2025-10-04 13:15:20.432019	9	EXECUTED	9:9d05c7be10cdb873f8bcb41bc3a8ab23	update tableName=CLIENT; update tableName=CLIENT; update tableName=CLIENT		\N	4.33.0	\N	\N	9583717615
1.3.0	bburke@redhat.com	META-INF/jpa-changelog-1.3.0.xml	2025-10-04 13:15:20.476369	10	EXECUTED	9:18593702353128d53111f9b1ff0b82b8	delete tableName=CLIENT_SESSION_ROLE; delete tableName=CLIENT_SESSION_PROT_MAPPER; delete tableName=CLIENT_SESSION_NOTE; delete tableName=CLIENT_SESSION; delete tableName=USER_SESSION_NOTE; delete tableName=USER_SESSION; createTable tableName=ADMI...		\N	4.33.0	\N	\N	9583717615
1.4.0	bburke@redhat.com	META-INF/jpa-changelog-1.4.0.xml	2025-10-04 13:15:20.50448	11	EXECUTED	9:6122efe5f090e41a85c0f1c9e52cbb62	delete tableName=CLIENT_SESSION_AUTH_STATUS; delete tableName=CLIENT_SESSION_ROLE; delete tableName=CLIENT_SESSION_PROT_MAPPER; delete tableName=CLIENT_SESSION_NOTE; delete tableName=CLIENT_SESSION; delete tableName=USER_SESSION_NOTE; delete table...		\N	4.33.0	\N	\N	9583717615
1.4.0	bburke@redhat.com	META-INF/db2-jpa-changelog-1.4.0.xml	2025-10-04 13:15:20.50703	12	MARK_RAN	9:e1ff28bf7568451453f844c5d54bb0b5	delete tableName=CLIENT_SESSION_AUTH_STATUS; delete tableName=CLIENT_SESSION_ROLE; delete tableName=CLIENT_SESSION_PROT_MAPPER; delete tableName=CLIENT_SESSION_NOTE; delete tableName=CLIENT_SESSION; delete tableName=USER_SESSION_NOTE; delete table...		\N	4.33.0	\N	\N	9583717615
1.5.0	bburke@redhat.com	META-INF/jpa-changelog-1.5.0.xml	2025-10-04 13:15:20.520901	13	EXECUTED	9:7af32cd8957fbc069f796b61217483fd	delete tableName=CLIENT_SESSION_AUTH_STATUS; delete tableName=CLIENT_SESSION_ROLE; delete tableName=CLIENT_SESSION_PROT_MAPPER; delete tableName=CLIENT_SESSION_NOTE; delete tableName=CLIENT_SESSION; delete tableName=USER_SESSION_NOTE; delete table...		\N	4.33.0	\N	\N	9583717615
1.6.1_from15	mposolda@redhat.com	META-INF/jpa-changelog-1.6.1.xml	2025-10-04 13:15:20.529515	14	EXECUTED	9:6005e15e84714cd83226bf7879f54190	addColumn tableName=REALM; addColumn tableName=KEYCLOAK_ROLE; addColumn tableName=CLIENT; createTable tableName=OFFLINE_USER_SESSION; createTable tableName=OFFLINE_CLIENT_SESSION; addPrimaryKey constraintName=CONSTRAINT_OFFL_US_SES_PK2, tableName=...		\N	4.33.0	\N	\N	9583717615
1.6.1_from16-pre	mposolda@redhat.com	META-INF/jpa-changelog-1.6.1.xml	2025-10-04 13:15:20.530583	15	MARK_RAN	9:bf656f5a2b055d07f314431cae76f06c	delete tableName=OFFLINE_CLIENT_SESSION; delete tableName=OFFLINE_USER_SESSION		\N	4.33.0	\N	\N	9583717615
1.6.1_from16	mposolda@redhat.com	META-INF/jpa-changelog-1.6.1.xml	2025-10-04 13:15:20.532071	16	MARK_RAN	9:f8dadc9284440469dcf71e25ca6ab99b	dropPrimaryKey constraintName=CONSTRAINT_OFFLINE_US_SES_PK, tableName=OFFLINE_USER_SESSION; dropPrimaryKey constraintName=CONSTRAINT_OFFLINE_CL_SES_PK, tableName=OFFLINE_CLIENT_SESSION; addColumn tableName=OFFLINE_USER_SESSION; update tableName=OF...		\N	4.33.0	\N	\N	9583717615
1.6.1	mposolda@redhat.com	META-INF/jpa-changelog-1.6.1.xml	2025-10-04 13:15:20.53379	17	EXECUTED	9:d41d8cd98f00b204e9800998ecf8427e	empty		\N	4.33.0	\N	\N	9583717615
1.7.0	bburke@redhat.com	META-INF/jpa-changelog-1.7.0.xml	2025-10-04 13:15:20.552972	18	EXECUTED	9:3368ff0be4c2855ee2dd9ca813b38d8e	createTable tableName=KEYCLOAK_GROUP; createTable tableName=GROUP_ROLE_MAPPING; createTable tableName=GROUP_ATTRIBUTE; createTable tableName=USER_GROUP_MEMBERSHIP; createTable tableName=REALM_DEFAULT_GROUPS; addColumn tableName=IDENTITY_PROVIDER; ...		\N	4.33.0	\N	\N	9583717615
1.8.0	mposolda@redhat.com	META-INF/jpa-changelog-1.8.0.xml	2025-10-04 13:15:20.571837	19	EXECUTED	9:8ac2fb5dd030b24c0570a763ed75ed20	addColumn tableName=IDENTITY_PROVIDER; createTable tableName=CLIENT_TEMPLATE; createTable tableName=CLIENT_TEMPLATE_ATTRIBUTES; createTable tableName=TEMPLATE_SCOPE_MAPPING; dropNotNullConstraint columnName=CLIENT_ID, tableName=PROTOCOL_MAPPER; ad...		\N	4.33.0	\N	\N	9583717615
1.8.0-2	keycloak	META-INF/jpa-changelog-1.8.0.xml	2025-10-04 13:15:20.57506	20	EXECUTED	9:f91ddca9b19743db60e3057679810e6c	dropDefaultValue columnName=ALGORITHM, tableName=CREDENTIAL; update tableName=CREDENTIAL		\N	4.33.0	\N	\N	9583717615
22.0.5-24031	keycloak	META-INF/jpa-changelog-22.0.0.xml	2025-10-04 13:15:22.495513	119	MARK_RAN	9:a60d2d7b315ec2d3eba9e2f145f9df28	customChange		\N	4.33.0	\N	\N	9583717615
1.8.0	mposolda@redhat.com	META-INF/db2-jpa-changelog-1.8.0.xml	2025-10-04 13:15:20.576855	21	MARK_RAN	9:831e82914316dc8a57dc09d755f23c51	addColumn tableName=IDENTITY_PROVIDER; createTable tableName=CLIENT_TEMPLATE; createTable tableName=CLIENT_TEMPLATE_ATTRIBUTES; createTable tableName=TEMPLATE_SCOPE_MAPPING; dropNotNullConstraint columnName=CLIENT_ID, tableName=PROTOCOL_MAPPER; ad...		\N	4.33.0	\N	\N	9583717615
1.8.0-2	keycloak	META-INF/db2-jpa-changelog-1.8.0.xml	2025-10-04 13:15:20.578457	22	MARK_RAN	9:f91ddca9b19743db60e3057679810e6c	dropDefaultValue columnName=ALGORITHM, tableName=CREDENTIAL; update tableName=CREDENTIAL		\N	4.33.0	\N	\N	9583717615
1.9.0	mposolda@redhat.com	META-INF/jpa-changelog-1.9.0.xml	2025-10-04 13:15:20.617757	23	EXECUTED	9:bc3d0f9e823a69dc21e23e94c7a94bb1	update tableName=REALM; update tableName=REALM; update tableName=REALM; update tableName=REALM; update tableName=CREDENTIAL; update tableName=CREDENTIAL; update tableName=CREDENTIAL; update tableName=REALM; update tableName=REALM; customChange; dr...		\N	4.33.0	\N	\N	9583717615
1.9.1	keycloak	META-INF/jpa-changelog-1.9.1.xml	2025-10-04 13:15:20.620744	24	EXECUTED	9:c9999da42f543575ab790e76439a2679	modifyDataType columnName=PRIVATE_KEY, tableName=REALM; modifyDataType columnName=PUBLIC_KEY, tableName=REALM; modifyDataType columnName=CERTIFICATE, tableName=REALM		\N	4.33.0	\N	\N	9583717615
1.9.1	keycloak	META-INF/db2-jpa-changelog-1.9.1.xml	2025-10-04 13:15:20.621537	25	MARK_RAN	9:0d6c65c6f58732d81569e77b10ba301d	modifyDataType columnName=PRIVATE_KEY, tableName=REALM; modifyDataType columnName=CERTIFICATE, tableName=REALM		\N	4.33.0	\N	\N	9583717615
1.9.2	keycloak	META-INF/jpa-changelog-1.9.2.xml	2025-10-04 13:15:20.820344	26	EXECUTED	9:fc576660fc016ae53d2d4778d84d86d0	createIndex indexName=IDX_USER_EMAIL, tableName=USER_ENTITY; createIndex indexName=IDX_USER_ROLE_MAPPING, tableName=USER_ROLE_MAPPING; createIndex indexName=IDX_USER_GROUP_MAPPING, tableName=USER_GROUP_MEMBERSHIP; createIndex indexName=IDX_USER_CO...		\N	4.33.0	\N	\N	9583717615
authz-2.0.0	psilva@redhat.com	META-INF/jpa-changelog-authz-2.0.0.xml	2025-10-04 13:15:20.846617	27	EXECUTED	9:43ed6b0da89ff77206289e87eaa9c024	createTable tableName=RESOURCE_SERVER; addPrimaryKey constraintName=CONSTRAINT_FARS, tableName=RESOURCE_SERVER; addUniqueConstraint constraintName=UK_AU8TT6T700S9V50BU18WS5HA6, tableName=RESOURCE_SERVER; createTable tableName=RESOURCE_SERVER_RESOU...		\N	4.33.0	\N	\N	9583717615
authz-2.5.1	psilva@redhat.com	META-INF/jpa-changelog-authz-2.5.1.xml	2025-10-04 13:15:20.849016	28	EXECUTED	9:44bae577f551b3738740281eceb4ea70	update tableName=RESOURCE_SERVER_POLICY		\N	4.33.0	\N	\N	9583717615
2.1.0-KEYCLOAK-5461	bburke@redhat.com	META-INF/jpa-changelog-2.1.0.xml	2025-10-04 13:15:20.868955	29	EXECUTED	9:bd88e1f833df0420b01e114533aee5e8	createTable tableName=BROKER_LINK; createTable tableName=FED_USER_ATTRIBUTE; createTable tableName=FED_USER_CONSENT; createTable tableName=FED_USER_CONSENT_ROLE; createTable tableName=FED_USER_CONSENT_PROT_MAPPER; createTable tableName=FED_USER_CR...		\N	4.33.0	\N	\N	9583717615
2.2.0	bburke@redhat.com	META-INF/jpa-changelog-2.2.0.xml	2025-10-04 13:15:20.875883	30	EXECUTED	9:a7022af5267f019d020edfe316ef4371	addColumn tableName=ADMIN_EVENT_ENTITY; createTable tableName=CREDENTIAL_ATTRIBUTE; createTable tableName=FED_CREDENTIAL_ATTRIBUTE; modifyDataType columnName=VALUE, tableName=CREDENTIAL; addForeignKeyConstraint baseTableName=FED_CREDENTIAL_ATTRIBU...		\N	4.33.0	\N	\N	9583717615
2.3.0	bburke@redhat.com	META-INF/jpa-changelog-2.3.0.xml	2025-10-04 13:15:20.886536	31	EXECUTED	9:fc155c394040654d6a79227e56f5e25a	createTable tableName=FEDERATED_USER; addPrimaryKey constraintName=CONSTR_FEDERATED_USER, tableName=FEDERATED_USER; dropDefaultValue columnName=TOTP, tableName=USER_ENTITY; dropColumn columnName=TOTP, tableName=USER_ENTITY; addColumn tableName=IDE...		\N	4.33.0	\N	\N	9583717615
2.4.0	bburke@redhat.com	META-INF/jpa-changelog-2.4.0.xml	2025-10-04 13:15:20.889914	32	EXECUTED	9:eac4ffb2a14795e5dc7b426063e54d88	customChange		\N	4.33.0	\N	\N	9583717615
2.5.0	bburke@redhat.com	META-INF/jpa-changelog-2.5.0.xml	2025-10-04 13:15:20.893436	33	EXECUTED	9:54937c05672568c4c64fc9524c1e9462	customChange; modifyDataType columnName=USER_ID, tableName=OFFLINE_USER_SESSION		\N	4.33.0	\N	\N	9583717615
2.5.0-unicode-oracle	hmlnarik@redhat.com	META-INF/jpa-changelog-2.5.0.xml	2025-10-04 13:15:20.894738	34	MARK_RAN	9:f9753208029f582525ed12011a19d054	modifyDataType columnName=DESCRIPTION, tableName=AUTHENTICATION_FLOW; modifyDataType columnName=DESCRIPTION, tableName=CLIENT_TEMPLATE; modifyDataType columnName=DESCRIPTION, tableName=RESOURCE_SERVER_POLICY; modifyDataType columnName=DESCRIPTION,...		\N	4.33.0	\N	\N	9583717615
2.5.0-unicode-other-dbs	hmlnarik@redhat.com	META-INF/jpa-changelog-2.5.0.xml	2025-10-04 13:15:20.907556	35	EXECUTED	9:33d72168746f81f98ae3a1e8e0ca3554	modifyDataType columnName=DESCRIPTION, tableName=AUTHENTICATION_FLOW; modifyDataType columnName=DESCRIPTION, tableName=CLIENT_TEMPLATE; modifyDataType columnName=DESCRIPTION, tableName=RESOURCE_SERVER_POLICY; modifyDataType columnName=DESCRIPTION,...		\N	4.33.0	\N	\N	9583717615
2.5.0-duplicate-email-support	slawomir@dabek.name	META-INF/jpa-changelog-2.5.0.xml	2025-10-04 13:15:20.910943	36	EXECUTED	9:61b6d3d7a4c0e0024b0c839da283da0c	addColumn tableName=REALM		\N	4.33.0	\N	\N	9583717615
2.5.0-unique-group-names	hmlnarik@redhat.com	META-INF/jpa-changelog-2.5.0.xml	2025-10-04 13:15:20.913148	37	EXECUTED	9:8dcac7bdf7378e7d823cdfddebf72fda	addUniqueConstraint constraintName=SIBLING_NAMES, tableName=KEYCLOAK_GROUP		\N	4.33.0	\N	\N	9583717615
2.5.1	bburke@redhat.com	META-INF/jpa-changelog-2.5.1.xml	2025-10-04 13:15:20.915078	38	EXECUTED	9:a2b870802540cb3faa72098db5388af3	addColumn tableName=FED_USER_CONSENT		\N	4.33.0	\N	\N	9583717615
3.0.0	bburke@redhat.com	META-INF/jpa-changelog-3.0.0.xml	2025-10-04 13:15:20.91685	39	EXECUTED	9:132a67499ba24bcc54fb5cbdcfe7e4c0	addColumn tableName=IDENTITY_PROVIDER		\N	4.33.0	\N	\N	9583717615
3.2.0-fix	keycloak	META-INF/jpa-changelog-3.2.0.xml	2025-10-04 13:15:20.917557	40	MARK_RAN	9:938f894c032f5430f2b0fafb1a243462	addNotNullConstraint columnName=REALM_ID, tableName=CLIENT_INITIAL_ACCESS		\N	4.33.0	\N	\N	9583717615
3.2.0-fix-with-keycloak-5416	keycloak	META-INF/jpa-changelog-3.2.0.xml	2025-10-04 13:15:20.918578	41	MARK_RAN	9:845c332ff1874dc5d35974b0babf3006	dropIndex indexName=IDX_CLIENT_INIT_ACC_REALM, tableName=CLIENT_INITIAL_ACCESS; addNotNullConstraint columnName=REALM_ID, tableName=CLIENT_INITIAL_ACCESS; createIndex indexName=IDX_CLIENT_INIT_ACC_REALM, tableName=CLIENT_INITIAL_ACCESS		\N	4.33.0	\N	\N	9583717615
3.2.0-fix-offline-sessions	hmlnarik	META-INF/jpa-changelog-3.2.0.xml	2025-10-04 13:15:20.922051	42	EXECUTED	9:fc86359c079781adc577c5a217e4d04c	customChange		\N	4.33.0	\N	\N	9583717615
3.2.0-fixed	keycloak	META-INF/jpa-changelog-3.2.0.xml	2025-10-04 13:15:21.610441	43	EXECUTED	9:59a64800e3c0d09b825f8a3b444fa8f4	addColumn tableName=REALM; dropPrimaryKey constraintName=CONSTRAINT_OFFL_CL_SES_PK2, tableName=OFFLINE_CLIENT_SESSION; dropColumn columnName=CLIENT_SESSION_ID, tableName=OFFLINE_CLIENT_SESSION; addPrimaryKey constraintName=CONSTRAINT_OFFL_CL_SES_P...		\N	4.33.0	\N	\N	9583717615
3.3.0	keycloak	META-INF/jpa-changelog-3.3.0.xml	2025-10-04 13:15:21.613377	44	EXECUTED	9:d48d6da5c6ccf667807f633fe489ce88	addColumn tableName=USER_ENTITY		\N	4.33.0	\N	\N	9583717615
authz-3.4.0.CR1-resource-server-pk-change-part1	glavoie@gmail.com	META-INF/jpa-changelog-authz-3.4.0.CR1.xml	2025-10-04 13:15:21.615817	45	EXECUTED	9:dde36f7973e80d71fceee683bc5d2951	addColumn tableName=RESOURCE_SERVER_POLICY; addColumn tableName=RESOURCE_SERVER_RESOURCE; addColumn tableName=RESOURCE_SERVER_SCOPE		\N	4.33.0	\N	\N	9583717615
authz-3.4.0.CR1-resource-server-pk-change-part2-KEYCLOAK-6095	hmlnarik@redhat.com	META-INF/jpa-changelog-authz-3.4.0.CR1.xml	2025-10-04 13:15:21.618636	46	EXECUTED	9:b855e9b0a406b34fa323235a0cf4f640	customChange		\N	4.33.0	\N	\N	9583717615
authz-3.4.0.CR1-resource-server-pk-change-part3-fixed	glavoie@gmail.com	META-INF/jpa-changelog-authz-3.4.0.CR1.xml	2025-10-04 13:15:21.619588	47	MARK_RAN	9:51abbacd7b416c50c4421a8cabf7927e	dropIndex indexName=IDX_RES_SERV_POL_RES_SERV, tableName=RESOURCE_SERVER_POLICY; dropIndex indexName=IDX_RES_SRV_RES_RES_SRV, tableName=RESOURCE_SERVER_RESOURCE; dropIndex indexName=IDX_RES_SRV_SCOPE_RES_SRV, tableName=RESOURCE_SERVER_SCOPE		\N	4.33.0	\N	\N	9583717615
authz-3.4.0.CR1-resource-server-pk-change-part3-fixed-nodropindex	glavoie@gmail.com	META-INF/jpa-changelog-authz-3.4.0.CR1.xml	2025-10-04 13:15:21.678001	48	EXECUTED	9:bdc99e567b3398bac83263d375aad143	addNotNullConstraint columnName=RESOURCE_SERVER_CLIENT_ID, tableName=RESOURCE_SERVER_POLICY; addNotNullConstraint columnName=RESOURCE_SERVER_CLIENT_ID, tableName=RESOURCE_SERVER_RESOURCE; addNotNullConstraint columnName=RESOURCE_SERVER_CLIENT_ID, ...		\N	4.33.0	\N	\N	9583717615
authn-3.4.0.CR1-refresh-token-max-reuse	glavoie@gmail.com	META-INF/jpa-changelog-authz-3.4.0.CR1.xml	2025-10-04 13:15:21.680671	49	EXECUTED	9:d198654156881c46bfba39abd7769e69	addColumn tableName=REALM		\N	4.33.0	\N	\N	9583717615
3.4.0	keycloak	META-INF/jpa-changelog-3.4.0.xml	2025-10-04 13:15:21.69224	50	EXECUTED	9:cfdd8736332ccdd72c5256ccb42335db	addPrimaryKey constraintName=CONSTRAINT_REALM_DEFAULT_ROLES, tableName=REALM_DEFAULT_ROLES; addPrimaryKey constraintName=CONSTRAINT_COMPOSITE_ROLE, tableName=COMPOSITE_ROLE; addPrimaryKey constraintName=CONSTR_REALM_DEFAULT_GROUPS, tableName=REALM...		\N	4.33.0	\N	\N	9583717615
3.4.0-KEYCLOAK-5230	hmlnarik@redhat.com	META-INF/jpa-changelog-3.4.0.xml	2025-10-04 13:15:21.852338	51	EXECUTED	9:7c84de3d9bd84d7f077607c1a4dcb714	createIndex indexName=IDX_FU_ATTRIBUTE, tableName=FED_USER_ATTRIBUTE; createIndex indexName=IDX_FU_CONSENT, tableName=FED_USER_CONSENT; createIndex indexName=IDX_FU_CONSENT_RU, tableName=FED_USER_CONSENT; createIndex indexName=IDX_FU_CREDENTIAL, t...		\N	4.33.0	\N	\N	9583717615
3.4.1	psilva@redhat.com	META-INF/jpa-changelog-3.4.1.xml	2025-10-04 13:15:21.854864	52	EXECUTED	9:5a6bb36cbefb6a9d6928452c0852af2d	modifyDataType columnName=VALUE, tableName=CLIENT_ATTRIBUTES		\N	4.33.0	\N	\N	9583717615
3.4.2	keycloak	META-INF/jpa-changelog-3.4.2.xml	2025-10-04 13:15:21.856691	53	EXECUTED	9:8f23e334dbc59f82e0a328373ca6ced0	update tableName=REALM		\N	4.33.0	\N	\N	9583717615
3.4.2-KEYCLOAK-5172	mkanis@redhat.com	META-INF/jpa-changelog-3.4.2.xml	2025-10-04 13:15:21.858969	54	EXECUTED	9:9156214268f09d970cdf0e1564d866af	update tableName=CLIENT		\N	4.33.0	\N	\N	9583717615
4.0.0-KEYCLOAK-6335	bburke@redhat.com	META-INF/jpa-changelog-4.0.0.xml	2025-10-04 13:15:21.862056	55	EXECUTED	9:db806613b1ed154826c02610b7dbdf74	createTable tableName=CLIENT_AUTH_FLOW_BINDINGS; addPrimaryKey constraintName=C_CLI_FLOW_BIND, tableName=CLIENT_AUTH_FLOW_BINDINGS		\N	4.33.0	\N	\N	9583717615
4.0.0-CLEANUP-UNUSED-TABLE	bburke@redhat.com	META-INF/jpa-changelog-4.0.0.xml	2025-10-04 13:15:21.864757	56	EXECUTED	9:229a041fb72d5beac76bb94a5fa709de	dropTable tableName=CLIENT_IDENTITY_PROV_MAPPING		\N	4.33.0	\N	\N	9583717615
4.0.0-KEYCLOAK-6228	bburke@redhat.com	META-INF/jpa-changelog-4.0.0.xml	2025-10-04 13:15:21.887014	57	EXECUTED	9:079899dade9c1e683f26b2aa9ca6ff04	dropUniqueConstraint constraintName=UK_JKUWUVD56ONTGSUHOGM8UEWRT, tableName=USER_CONSENT; dropNotNullConstraint columnName=CLIENT_ID, tableName=USER_CONSENT; addColumn tableName=USER_CONSENT; addUniqueConstraint constraintName=UK_JKUWUVD56ONTGSUHO...		\N	4.33.0	\N	\N	9583717615
4.0.0-KEYCLOAK-5579-fixed	mposolda@redhat.com	META-INF/jpa-changelog-4.0.0.xml	2025-10-04 13:15:22.06423	58	EXECUTED	9:139b79bcbbfe903bb1c2d2a4dbf001d9	dropForeignKeyConstraint baseTableName=CLIENT_TEMPLATE_ATTRIBUTES, constraintName=FK_CL_TEMPL_ATTR_TEMPL; renameTable newTableName=CLIENT_SCOPE_ATTRIBUTES, oldTableName=CLIENT_TEMPLATE_ATTRIBUTES; renameColumn newColumnName=SCOPE_ID, oldColumnName...		\N	4.33.0	\N	\N	9583717615
authz-4.0.0.CR1	psilva@redhat.com	META-INF/jpa-changelog-authz-4.0.0.CR1.xml	2025-10-04 13:15:22.074966	59	EXECUTED	9:b55738ad889860c625ba2bf483495a04	createTable tableName=RESOURCE_SERVER_PERM_TICKET; addPrimaryKey constraintName=CONSTRAINT_FAPMT, tableName=RESOURCE_SERVER_PERM_TICKET; addForeignKeyConstraint baseTableName=RESOURCE_SERVER_PERM_TICKET, constraintName=FK_FRSRHO213XCX4WNKOG82SSPMT...		\N	4.33.0	\N	\N	9583717615
authz-4.0.0.Beta3	psilva@redhat.com	META-INF/jpa-changelog-authz-4.0.0.Beta3.xml	2025-10-04 13:15:22.078743	60	EXECUTED	9:e0057eac39aa8fc8e09ac6cfa4ae15fe	addColumn tableName=RESOURCE_SERVER_POLICY; addColumn tableName=RESOURCE_SERVER_PERM_TICKET; addForeignKeyConstraint baseTableName=RESOURCE_SERVER_PERM_TICKET, constraintName=FK_FRSRPO2128CX4WNKOG82SSRFY, referencedTableName=RESOURCE_SERVER_POLICY		\N	4.33.0	\N	\N	9583717615
authz-4.2.0.Final	mhajas@redhat.com	META-INF/jpa-changelog-authz-4.2.0.Final.xml	2025-10-04 13:15:22.08378	61	EXECUTED	9:42a33806f3a0443fe0e7feeec821326c	createTable tableName=RESOURCE_URIS; addForeignKeyConstraint baseTableName=RESOURCE_URIS, constraintName=FK_RESOURCE_SERVER_URIS, referencedTableName=RESOURCE_SERVER_RESOURCE; customChange; dropColumn columnName=URI, tableName=RESOURCE_SERVER_RESO...		\N	4.33.0	\N	\N	9583717615
authz-4.2.0.Final-KEYCLOAK-9944	hmlnarik@redhat.com	META-INF/jpa-changelog-authz-4.2.0.Final.xml	2025-10-04 13:15:22.085825	62	EXECUTED	9:9968206fca46eecc1f51db9c024bfe56	addPrimaryKey constraintName=CONSTRAINT_RESOUR_URIS_PK, tableName=RESOURCE_URIS		\N	4.33.0	\N	\N	9583717615
4.2.0-KEYCLOAK-6313	wadahiro@gmail.com	META-INF/jpa-changelog-4.2.0.xml	2025-10-04 13:15:22.087619	63	EXECUTED	9:92143a6daea0a3f3b8f598c97ce55c3d	addColumn tableName=REQUIRED_ACTION_PROVIDER		\N	4.33.0	\N	\N	9583717615
4.3.0-KEYCLOAK-7984	wadahiro@gmail.com	META-INF/jpa-changelog-4.3.0.xml	2025-10-04 13:15:22.089433	64	EXECUTED	9:82bab26a27195d889fb0429003b18f40	update tableName=REQUIRED_ACTION_PROVIDER		\N	4.33.0	\N	\N	9583717615
4.6.0-KEYCLOAK-7950	psilva@redhat.com	META-INF/jpa-changelog-4.6.0.xml	2025-10-04 13:15:22.091013	65	EXECUTED	9:e590c88ddc0b38b0ae4249bbfcb5abc3	update tableName=RESOURCE_SERVER_RESOURCE		\N	4.33.0	\N	\N	9583717615
4.6.0-KEYCLOAK-8377	keycloak	META-INF/jpa-changelog-4.6.0.xml	2025-10-04 13:15:22.111523	66	EXECUTED	9:5c1f475536118dbdc38d5d7977950cc0	createTable tableName=ROLE_ATTRIBUTE; addPrimaryKey constraintName=CONSTRAINT_ROLE_ATTRIBUTE_PK, tableName=ROLE_ATTRIBUTE; addForeignKeyConstraint baseTableName=ROLE_ATTRIBUTE, constraintName=FK_ROLE_ATTRIBUTE_ID, referencedTableName=KEYCLOAK_ROLE...		\N	4.33.0	\N	\N	9583717615
4.6.0-KEYCLOAK-8555	gideonray@gmail.com	META-INF/jpa-changelog-4.6.0.xml	2025-10-04 13:15:22.128265	67	EXECUTED	9:e7c9f5f9c4d67ccbbcc215440c718a17	createIndex indexName=IDX_COMPONENT_PROVIDER_TYPE, tableName=COMPONENT		\N	4.33.0	\N	\N	9583717615
4.7.0-KEYCLOAK-1267	sguilhen@redhat.com	META-INF/jpa-changelog-4.7.0.xml	2025-10-04 13:15:22.130809	68	EXECUTED	9:88e0bfdda924690d6f4e430c53447dd5	addColumn tableName=REALM		\N	4.33.0	\N	\N	9583717615
4.7.0-KEYCLOAK-7275	keycloak	META-INF/jpa-changelog-4.7.0.xml	2025-10-04 13:15:22.150086	69	EXECUTED	9:f53177f137e1c46b6a88c59ec1cb5218	renameColumn newColumnName=CREATED_ON, oldColumnName=LAST_SESSION_REFRESH, tableName=OFFLINE_USER_SESSION; addNotNullConstraint columnName=CREATED_ON, tableName=OFFLINE_USER_SESSION; addColumn tableName=OFFLINE_USER_SESSION; customChange; createIn...		\N	4.33.0	\N	\N	9583717615
4.8.0-KEYCLOAK-8835	sguilhen@redhat.com	META-INF/jpa-changelog-4.8.0.xml	2025-10-04 13:15:22.15295	70	EXECUTED	9:a74d33da4dc42a37ec27121580d1459f	addNotNullConstraint columnName=SSO_MAX_LIFESPAN_REMEMBER_ME, tableName=REALM; addNotNullConstraint columnName=SSO_IDLE_TIMEOUT_REMEMBER_ME, tableName=REALM		\N	4.33.0	\N	\N	9583717615
authz-7.0.0-KEYCLOAK-10443	psilva@redhat.com	META-INF/jpa-changelog-authz-7.0.0.xml	2025-10-04 13:15:22.155083	71	EXECUTED	9:fd4ade7b90c3b67fae0bfcfcb42dfb5f	addColumn tableName=RESOURCE_SERVER		\N	4.33.0	\N	\N	9583717615
8.0.0-adding-credential-columns	keycloak	META-INF/jpa-changelog-8.0.0.xml	2025-10-04 13:15:22.158916	72	EXECUTED	9:aa072ad090bbba210d8f18781b8cebf4	addColumn tableName=CREDENTIAL; addColumn tableName=FED_USER_CREDENTIAL		\N	4.33.0	\N	\N	9583717615
8.0.0-updating-credential-data-not-oracle-fixed	keycloak	META-INF/jpa-changelog-8.0.0.xml	2025-10-04 13:15:22.163277	73	EXECUTED	9:1ae6be29bab7c2aa376f6983b932be37	update tableName=CREDENTIAL; update tableName=CREDENTIAL; update tableName=CREDENTIAL; update tableName=FED_USER_CREDENTIAL; update tableName=FED_USER_CREDENTIAL; update tableName=FED_USER_CREDENTIAL		\N	4.33.0	\N	\N	9583717615
8.0.0-updating-credential-data-oracle-fixed	keycloak	META-INF/jpa-changelog-8.0.0.xml	2025-10-04 13:15:22.164428	74	MARK_RAN	9:14706f286953fc9a25286dbd8fb30d97	update tableName=CREDENTIAL; update tableName=CREDENTIAL; update tableName=CREDENTIAL; update tableName=FED_USER_CREDENTIAL; update tableName=FED_USER_CREDENTIAL; update tableName=FED_USER_CREDENTIAL		\N	4.33.0	\N	\N	9583717615
8.0.0-credential-cleanup-fixed	keycloak	META-INF/jpa-changelog-8.0.0.xml	2025-10-04 13:15:22.175949	75	EXECUTED	9:2b9cc12779be32c5b40e2e67711a218b	dropDefaultValue columnName=COUNTER, tableName=CREDENTIAL; dropDefaultValue columnName=DIGITS, tableName=CREDENTIAL; dropDefaultValue columnName=PERIOD, tableName=CREDENTIAL; dropDefaultValue columnName=ALGORITHM, tableName=CREDENTIAL; dropColumn ...		\N	4.33.0	\N	\N	9583717615
8.0.0-resource-tag-support	keycloak	META-INF/jpa-changelog-8.0.0.xml	2025-10-04 13:15:22.194591	76	EXECUTED	9:91fa186ce7a5af127a2d7a91ee083cc5	addColumn tableName=MIGRATION_MODEL; createIndex indexName=IDX_UPDATE_TIME, tableName=MIGRATION_MODEL		\N	4.33.0	\N	\N	9583717615
9.0.0-always-display-client	keycloak	META-INF/jpa-changelog-9.0.0.xml	2025-10-04 13:15:22.196636	77	EXECUTED	9:6335e5c94e83a2639ccd68dd24e2e5ad	addColumn tableName=CLIENT		\N	4.33.0	\N	\N	9583717615
9.0.0-drop-constraints-for-column-increase	keycloak	META-INF/jpa-changelog-9.0.0.xml	2025-10-04 13:15:22.197472	78	MARK_RAN	9:6bdb5658951e028bfe16fa0a8228b530	dropUniqueConstraint constraintName=UK_FRSR6T700S9V50BU18WS5PMT, tableName=RESOURCE_SERVER_PERM_TICKET; dropUniqueConstraint constraintName=UK_FRSR6T700S9V50BU18WS5HA6, tableName=RESOURCE_SERVER_RESOURCE; dropPrimaryKey constraintName=CONSTRAINT_O...		\N	4.33.0	\N	\N	9583717615
9.0.0-increase-column-size-federated-fk	keycloak	META-INF/jpa-changelog-9.0.0.xml	2025-10-04 13:15:22.204961	79	EXECUTED	9:d5bc15a64117ccad481ce8792d4c608f	modifyDataType columnName=CLIENT_ID, tableName=FED_USER_CONSENT; modifyDataType columnName=CLIENT_REALM_CONSTRAINT, tableName=KEYCLOAK_ROLE; modifyDataType columnName=OWNER, tableName=RESOURCE_SERVER_POLICY; modifyDataType columnName=CLIENT_ID, ta...		\N	4.33.0	\N	\N	9583717615
9.0.0-recreate-constraints-after-column-increase	keycloak	META-INF/jpa-changelog-9.0.0.xml	2025-10-04 13:15:22.206038	80	MARK_RAN	9:077cba51999515f4d3e7ad5619ab592c	addNotNullConstraint columnName=CLIENT_ID, tableName=OFFLINE_CLIENT_SESSION; addNotNullConstraint columnName=OWNER, tableName=RESOURCE_SERVER_PERM_TICKET; addNotNullConstraint columnName=REQUESTER, tableName=RESOURCE_SERVER_PERM_TICKET; addNotNull...		\N	4.33.0	\N	\N	9583717615
9.0.1-add-index-to-client.client_id	keycloak	META-INF/jpa-changelog-9.0.1.xml	2025-10-04 13:15:22.223022	81	EXECUTED	9:be969f08a163bf47c6b9e9ead8ac2afb	createIndex indexName=IDX_CLIENT_ID, tableName=CLIENT		\N	4.33.0	\N	\N	9583717615
9.0.1-KEYCLOAK-12579-drop-constraints	keycloak	META-INF/jpa-changelog-9.0.1.xml	2025-10-04 13:15:22.223942	82	MARK_RAN	9:6d3bb4408ba5a72f39bd8a0b301ec6e3	dropUniqueConstraint constraintName=SIBLING_NAMES, tableName=KEYCLOAK_GROUP		\N	4.33.0	\N	\N	9583717615
9.0.1-KEYCLOAK-12579-add-not-null-constraint	keycloak	META-INF/jpa-changelog-9.0.1.xml	2025-10-04 13:15:22.226381	83	EXECUTED	9:966bda61e46bebf3cc39518fbed52fa7	addNotNullConstraint columnName=PARENT_GROUP, tableName=KEYCLOAK_GROUP		\N	4.33.0	\N	\N	9583717615
9.0.1-KEYCLOAK-12579-recreate-constraints	keycloak	META-INF/jpa-changelog-9.0.1.xml	2025-10-04 13:15:22.227115	84	MARK_RAN	9:8dcac7bdf7378e7d823cdfddebf72fda	addUniqueConstraint constraintName=SIBLING_NAMES, tableName=KEYCLOAK_GROUP		\N	4.33.0	\N	\N	9583717615
9.0.1-add-index-to-events	keycloak	META-INF/jpa-changelog-9.0.1.xml	2025-10-04 13:15:22.243888	85	EXECUTED	9:7d93d602352a30c0c317e6a609b56599	createIndex indexName=IDX_EVENT_TIME, tableName=EVENT_ENTITY		\N	4.33.0	\N	\N	9583717615
map-remove-ri	keycloak	META-INF/jpa-changelog-11.0.0.xml	2025-10-04 13:15:22.246397	86	EXECUTED	9:71c5969e6cdd8d7b6f47cebc86d37627	dropForeignKeyConstraint baseTableName=REALM, constraintName=FK_TRAF444KK6QRKMS7N56AIWQ5Y; dropForeignKeyConstraint baseTableName=KEYCLOAK_ROLE, constraintName=FK_KJHO5LE2C0RAL09FL8CM9WFW9		\N	4.33.0	\N	\N	9583717615
map-remove-ri	keycloak	META-INF/jpa-changelog-12.0.0.xml	2025-10-04 13:15:22.250005	87	EXECUTED	9:a9ba7d47f065f041b7da856a81762021	dropForeignKeyConstraint baseTableName=REALM_DEFAULT_GROUPS, constraintName=FK_DEF_GROUPS_GROUP; dropForeignKeyConstraint baseTableName=REALM_DEFAULT_ROLES, constraintName=FK_H4WPD7W4HSOOLNI3H0SW7BTJE; dropForeignKeyConstraint baseTableName=CLIENT...		\N	4.33.0	\N	\N	9583717615
12.1.0-add-realm-localization-table	keycloak	META-INF/jpa-changelog-12.0.0.xml	2025-10-04 13:15:22.253199	88	EXECUTED	9:fffabce2bc01e1a8f5110d5278500065	createTable tableName=REALM_LOCALIZATIONS; addPrimaryKey tableName=REALM_LOCALIZATIONS		\N	4.33.0	\N	\N	9583717615
default-roles	keycloak	META-INF/jpa-changelog-13.0.0.xml	2025-10-04 13:15:22.257253	89	EXECUTED	9:fa8a5b5445e3857f4b010bafb5009957	addColumn tableName=REALM; customChange		\N	4.33.0	\N	\N	9583717615
default-roles-cleanup	keycloak	META-INF/jpa-changelog-13.0.0.xml	2025-10-04 13:15:22.260964	90	EXECUTED	9:67ac3241df9a8582d591c5ed87125f39	dropTable tableName=REALM_DEFAULT_ROLES; dropTable tableName=CLIENT_DEFAULT_ROLES		\N	4.33.0	\N	\N	9583717615
13.0.0-KEYCLOAK-16844	keycloak	META-INF/jpa-changelog-13.0.0.xml	2025-10-04 13:15:22.278174	91	EXECUTED	9:ad1194d66c937e3ffc82386c050ba089	createIndex indexName=IDX_OFFLINE_USS_PRELOAD, tableName=OFFLINE_USER_SESSION		\N	4.33.0	\N	\N	9583717615
map-remove-ri-13.0.0	keycloak	META-INF/jpa-changelog-13.0.0.xml	2025-10-04 13:15:22.281862	92	EXECUTED	9:d9be619d94af5a2f5d07b9f003543b91	dropForeignKeyConstraint baseTableName=DEFAULT_CLIENT_SCOPE, constraintName=FK_R_DEF_CLI_SCOPE_SCOPE; dropForeignKeyConstraint baseTableName=CLIENT_SCOPE_CLIENT, constraintName=FK_C_CLI_SCOPE_SCOPE; dropForeignKeyConstraint baseTableName=CLIENT_SC...		\N	4.33.0	\N	\N	9583717615
13.0.0-KEYCLOAK-17992-drop-constraints	keycloak	META-INF/jpa-changelog-13.0.0.xml	2025-10-04 13:15:22.282694	93	MARK_RAN	9:544d201116a0fcc5a5da0925fbbc3bde	dropPrimaryKey constraintName=C_CLI_SCOPE_BIND, tableName=CLIENT_SCOPE_CLIENT; dropIndex indexName=IDX_CLSCOPE_CL, tableName=CLIENT_SCOPE_CLIENT; dropIndex indexName=IDX_CL_CLSCOPE, tableName=CLIENT_SCOPE_CLIENT		\N	4.33.0	\N	\N	9583717615
13.0.0-increase-column-size-federated	keycloak	META-INF/jpa-changelog-13.0.0.xml	2025-10-04 13:15:22.285856	94	EXECUTED	9:43c0c1055b6761b4b3e89de76d612ccf	modifyDataType columnName=CLIENT_ID, tableName=CLIENT_SCOPE_CLIENT; modifyDataType columnName=SCOPE_ID, tableName=CLIENT_SCOPE_CLIENT		\N	4.33.0	\N	\N	9583717615
13.0.0-KEYCLOAK-17992-recreate-constraints	keycloak	META-INF/jpa-changelog-13.0.0.xml	2025-10-04 13:15:22.286702	95	MARK_RAN	9:8bd711fd0330f4fe980494ca43ab1139	addNotNullConstraint columnName=CLIENT_ID, tableName=CLIENT_SCOPE_CLIENT; addNotNullConstraint columnName=SCOPE_ID, tableName=CLIENT_SCOPE_CLIENT; addPrimaryKey constraintName=C_CLI_SCOPE_BIND, tableName=CLIENT_SCOPE_CLIENT; createIndex indexName=...		\N	4.33.0	\N	\N	9583717615
json-string-accomodation-fixed	keycloak	META-INF/jpa-changelog-13.0.0.xml	2025-10-04 13:15:22.289959	96	EXECUTED	9:e07d2bc0970c348bb06fb63b1f82ddbf	addColumn tableName=REALM_ATTRIBUTE; update tableName=REALM_ATTRIBUTE; dropColumn columnName=VALUE, tableName=REALM_ATTRIBUTE; renameColumn newColumnName=VALUE, oldColumnName=VALUE_NEW, tableName=REALM_ATTRIBUTE		\N	4.33.0	\N	\N	9583717615
14.0.0-KEYCLOAK-11019	keycloak	META-INF/jpa-changelog-14.0.0.xml	2025-10-04 13:15:22.338117	97	EXECUTED	9:24fb8611e97f29989bea412aa38d12b7	createIndex indexName=IDX_OFFLINE_CSS_PRELOAD, tableName=OFFLINE_CLIENT_SESSION; createIndex indexName=IDX_OFFLINE_USS_BY_USER, tableName=OFFLINE_USER_SESSION; createIndex indexName=IDX_OFFLINE_USS_BY_USERSESS, tableName=OFFLINE_USER_SESSION		\N	4.33.0	\N	\N	9583717615
14.0.0-KEYCLOAK-18286	keycloak	META-INF/jpa-changelog-14.0.0.xml	2025-10-04 13:15:22.339276	98	MARK_RAN	9:259f89014ce2506ee84740cbf7163aa7	createIndex indexName=IDX_CLIENT_ATT_BY_NAME_VALUE, tableName=CLIENT_ATTRIBUTES		\N	4.33.0	\N	\N	9583717615
14.0.0-KEYCLOAK-18286-revert	keycloak	META-INF/jpa-changelog-14.0.0.xml	2025-10-04 13:15:22.348422	99	MARK_RAN	9:04baaf56c116ed19951cbc2cca584022	dropIndex indexName=IDX_CLIENT_ATT_BY_NAME_VALUE, tableName=CLIENT_ATTRIBUTES		\N	4.33.0	\N	\N	9583717615
14.0.0-KEYCLOAK-18286-supported-dbs	keycloak	META-INF/jpa-changelog-14.0.0.xml	2025-10-04 13:15:22.365556	100	EXECUTED	9:60ca84a0f8c94ec8c3504a5a3bc88ee8	createIndex indexName=IDX_CLIENT_ATT_BY_NAME_VALUE, tableName=CLIENT_ATTRIBUTES		\N	4.33.0	\N	\N	9583717615
14.0.0-KEYCLOAK-18286-unsupported-dbs	keycloak	META-INF/jpa-changelog-14.0.0.xml	2025-10-04 13:15:22.366486	101	MARK_RAN	9:d3d977031d431db16e2c181ce49d73e9	createIndex indexName=IDX_CLIENT_ATT_BY_NAME_VALUE, tableName=CLIENT_ATTRIBUTES		\N	4.33.0	\N	\N	9583717615
KEYCLOAK-17267-add-index-to-user-attributes	keycloak	META-INF/jpa-changelog-14.0.0.xml	2025-10-04 13:15:22.382401	102	EXECUTED	9:0b305d8d1277f3a89a0a53a659ad274c	createIndex indexName=IDX_USER_ATTRIBUTE_NAME, tableName=USER_ATTRIBUTE		\N	4.33.0	\N	\N	9583717615
KEYCLOAK-18146-add-saml-art-binding-identifier	keycloak	META-INF/jpa-changelog-14.0.0.xml	2025-10-04 13:15:22.38474	103	EXECUTED	9:2c374ad2cdfe20e2905a84c8fac48460	customChange		\N	4.33.0	\N	\N	9583717615
15.0.0-KEYCLOAK-18467	keycloak	META-INF/jpa-changelog-15.0.0.xml	2025-10-04 13:15:22.387758	104	EXECUTED	9:47a760639ac597360a8219f5b768b4de	addColumn tableName=REALM_LOCALIZATIONS; update tableName=REALM_LOCALIZATIONS; dropColumn columnName=TEXTS, tableName=REALM_LOCALIZATIONS; renameColumn newColumnName=TEXTS, oldColumnName=TEXTS_NEW, tableName=REALM_LOCALIZATIONS; addNotNullConstrai...		\N	4.33.0	\N	\N	9583717615
17.0.0-9562	keycloak	META-INF/jpa-changelog-17.0.0.xml	2025-10-04 13:15:22.403568	105	EXECUTED	9:a6272f0576727dd8cad2522335f5d99e	createIndex indexName=IDX_USER_SERVICE_ACCOUNT, tableName=USER_ENTITY		\N	4.33.0	\N	\N	9583717615
18.0.0-10625-IDX_ADMIN_EVENT_TIME	keycloak	META-INF/jpa-changelog-18.0.0.xml	2025-10-04 13:15:22.419539	106	EXECUTED	9:015479dbd691d9cc8669282f4828c41d	createIndex indexName=IDX_ADMIN_EVENT_TIME, tableName=ADMIN_EVENT_ENTITY		\N	4.33.0	\N	\N	9583717615
18.0.15-30992-index-consent	keycloak	META-INF/jpa-changelog-18.0.15.xml	2025-10-04 13:15:22.438912	107	EXECUTED	9:80071ede7a05604b1f4906f3bf3b00f0	createIndex indexName=IDX_USCONSENT_SCOPE_ID, tableName=USER_CONSENT_CLIENT_SCOPE		\N	4.33.0	\N	\N	9583717615
19.0.0-10135	keycloak	META-INF/jpa-changelog-19.0.0.xml	2025-10-04 13:15:22.441125	108	EXECUTED	9:9518e495fdd22f78ad6425cc30630221	customChange		\N	4.33.0	\N	\N	9583717615
20.0.0-12964-supported-dbs	keycloak	META-INF/jpa-changelog-20.0.0.xml	2025-10-04 13:15:22.456594	109	EXECUTED	9:e5f243877199fd96bcc842f27a1656ac	createIndex indexName=IDX_GROUP_ATT_BY_NAME_VALUE, tableName=GROUP_ATTRIBUTE		\N	4.33.0	\N	\N	9583717615
20.0.0-12964-supported-dbs-edb-migration	keycloak	META-INF/jpa-changelog-20.0.0.xml	2025-10-04 13:15:22.474986	110	EXECUTED	9:a6b18a8e38062df5793edbe064f4aecd	dropIndex indexName=IDX_GROUP_ATT_BY_NAME_VALUE, tableName=GROUP_ATTRIBUTE; createIndex indexName=IDX_GROUP_ATT_BY_NAME_VALUE, tableName=GROUP_ATTRIBUTE		\N	4.33.0	\N	\N	9583717615
20.0.0-12964-unsupported-dbs	keycloak	META-INF/jpa-changelog-20.0.0.xml	2025-10-04 13:15:22.475849	111	MARK_RAN	9:1a6fcaa85e20bdeae0a9ce49b41946a5	createIndex indexName=IDX_GROUP_ATT_BY_NAME_VALUE, tableName=GROUP_ATTRIBUTE		\N	4.33.0	\N	\N	9583717615
client-attributes-string-accomodation-fixed-pre-drop-index	keycloak	META-INF/jpa-changelog-20.0.0.xml	2025-10-04 13:15:22.477816	112	EXECUTED	9:04baaf56c116ed19951cbc2cca584022	dropIndex indexName=IDX_CLIENT_ATT_BY_NAME_VALUE, tableName=CLIENT_ATTRIBUTES		\N	4.33.0	\N	\N	9583717615
client-attributes-string-accomodation-fixed	keycloak	META-INF/jpa-changelog-20.0.0.xml	2025-10-04 13:15:22.480709	113	EXECUTED	9:3f332e13e90739ed0c35b0b25b7822ca	addColumn tableName=CLIENT_ATTRIBUTES; update tableName=CLIENT_ATTRIBUTES; dropColumn columnName=VALUE, tableName=CLIENT_ATTRIBUTES; renameColumn newColumnName=VALUE, oldColumnName=VALUE_NEW, tableName=CLIENT_ATTRIBUTES		\N	4.33.0	\N	\N	9583717615
client-attributes-string-accomodation-fixed-post-create-index	keycloak	META-INF/jpa-changelog-20.0.0.xml	2025-10-04 13:15:22.481429	114	MARK_RAN	9:bd2bd0fc7768cf0845ac96a8786fa735	createIndex indexName=IDX_CLIENT_ATT_BY_NAME_VALUE, tableName=CLIENT_ATTRIBUTES		\N	4.33.0	\N	\N	9583717615
21.0.2-17277	keycloak	META-INF/jpa-changelog-21.0.2.xml	2025-10-04 13:15:22.484316	115	EXECUTED	9:7ee1f7a3fb8f5588f171fb9a6ab623c0	customChange		\N	4.33.0	\N	\N	9583717615
21.1.0-19404	keycloak	META-INF/jpa-changelog-21.1.0.xml	2025-10-04 13:15:22.490716	116	EXECUTED	9:3d7e830b52f33676b9d64f7f2b2ea634	modifyDataType columnName=DECISION_STRATEGY, tableName=RESOURCE_SERVER_POLICY; modifyDataType columnName=LOGIC, tableName=RESOURCE_SERVER_POLICY; modifyDataType columnName=POLICY_ENFORCE_MODE, tableName=RESOURCE_SERVER		\N	4.33.0	\N	\N	9583717615
21.1.0-19404-2	keycloak	META-INF/jpa-changelog-21.1.0.xml	2025-10-04 13:15:22.492142	117	MARK_RAN	9:627d032e3ef2c06c0e1f73d2ae25c26c	addColumn tableName=RESOURCE_SERVER_POLICY; update tableName=RESOURCE_SERVER_POLICY; dropColumn columnName=DECISION_STRATEGY, tableName=RESOURCE_SERVER_POLICY; renameColumn newColumnName=DECISION_STRATEGY, oldColumnName=DECISION_STRATEGY_NEW, tabl...		\N	4.33.0	\N	\N	9583717615
22.0.0-17484-updated	keycloak	META-INF/jpa-changelog-22.0.0.xml	2025-10-04 13:15:22.494823	118	EXECUTED	9:90af0bfd30cafc17b9f4d6eccd92b8b3	customChange		\N	4.33.0	\N	\N	9583717615
23.0.0-12062	keycloak	META-INF/jpa-changelog-23.0.0.xml	2025-10-04 13:15:22.498265	120	EXECUTED	9:2168fbe728fec46ae9baf15bf80927b8	addColumn tableName=COMPONENT_CONFIG; update tableName=COMPONENT_CONFIG; dropColumn columnName=VALUE, tableName=COMPONENT_CONFIG; renameColumn newColumnName=VALUE, oldColumnName=VALUE_NEW, tableName=COMPONENT_CONFIG		\N	4.33.0	\N	\N	9583717615
23.0.0-17258	keycloak	META-INF/jpa-changelog-23.0.0.xml	2025-10-04 13:15:22.499877	121	EXECUTED	9:36506d679a83bbfda85a27ea1864dca8	addColumn tableName=EVENT_ENTITY		\N	4.33.0	\N	\N	9583717615
24.0.0-9758	keycloak	META-INF/jpa-changelog-24.0.0.xml	2025-10-04 13:15:22.558004	122	EXECUTED	9:502c557a5189f600f0f445a9b49ebbce	addColumn tableName=USER_ATTRIBUTE; addColumn tableName=FED_USER_ATTRIBUTE; createIndex indexName=USER_ATTR_LONG_VALUES, tableName=USER_ATTRIBUTE; createIndex indexName=FED_USER_ATTR_LONG_VALUES, tableName=FED_USER_ATTRIBUTE; createIndex indexName...		\N	4.33.0	\N	\N	9583717615
24.0.0-9758-2	keycloak	META-INF/jpa-changelog-24.0.0.xml	2025-10-04 13:15:22.560279	123	EXECUTED	9:bf0fdee10afdf597a987adbf291db7b2	customChange		\N	4.33.0	\N	\N	9583717615
24.0.0-26618-drop-index-if-present	keycloak	META-INF/jpa-changelog-24.0.0.xml	2025-10-04 13:15:22.563579	124	MARK_RAN	9:04baaf56c116ed19951cbc2cca584022	dropIndex indexName=IDX_CLIENT_ATT_BY_NAME_VALUE, tableName=CLIENT_ATTRIBUTES		\N	4.33.0	\N	\N	9583717615
24.0.0-26618-reindex	keycloak	META-INF/jpa-changelog-24.0.0.xml	2025-10-04 13:15:22.581197	125	EXECUTED	9:08707c0f0db1cef6b352db03a60edc7f	createIndex indexName=IDX_CLIENT_ATT_BY_NAME_VALUE, tableName=CLIENT_ATTRIBUTES		\N	4.33.0	\N	\N	9583717615
24.0.0-26618-edb-migration	keycloak	META-INF/jpa-changelog-24.0.0.xml	2025-10-04 13:15:22.600747	126	EXECUTED	9:2f684b29d414cd47efe3a3599f390741	dropIndex indexName=IDX_CLIENT_ATT_BY_NAME_VALUE, tableName=CLIENT_ATTRIBUTES; createIndex indexName=IDX_CLIENT_ATT_BY_NAME_VALUE, tableName=CLIENT_ATTRIBUTES		\N	4.33.0	\N	\N	9583717615
24.0.2-27228	keycloak	META-INF/jpa-changelog-24.0.2.xml	2025-10-04 13:15:22.602962	127	EXECUTED	9:eaee11f6b8aa25d2cc6a84fb86fc6238	customChange		\N	4.33.0	\N	\N	9583717615
24.0.2-27967-drop-index-if-present	keycloak	META-INF/jpa-changelog-24.0.2.xml	2025-10-04 13:15:22.603823	128	MARK_RAN	9:04baaf56c116ed19951cbc2cca584022	dropIndex indexName=IDX_CLIENT_ATT_BY_NAME_VALUE, tableName=CLIENT_ATTRIBUTES		\N	4.33.0	\N	\N	9583717615
24.0.2-27967-reindex	keycloak	META-INF/jpa-changelog-24.0.2.xml	2025-10-04 13:15:22.604913	129	MARK_RAN	9:d3d977031d431db16e2c181ce49d73e9	createIndex indexName=IDX_CLIENT_ATT_BY_NAME_VALUE, tableName=CLIENT_ATTRIBUTES		\N	4.33.0	\N	\N	9583717615
25.0.0-28265-tables	keycloak	META-INF/jpa-changelog-25.0.0.xml	2025-10-04 13:15:22.60791	130	EXECUTED	9:deda2df035df23388af95bbd36c17cef	addColumn tableName=OFFLINE_USER_SESSION; addColumn tableName=OFFLINE_CLIENT_SESSION		\N	4.33.0	\N	\N	9583717615
25.0.0-28265-index-creation	keycloak	META-INF/jpa-changelog-25.0.0.xml	2025-10-04 13:15:22.624516	131	EXECUTED	9:3e96709818458ae49f3c679ae58d263a	createIndex indexName=IDX_OFFLINE_USS_BY_LAST_SESSION_REFRESH, tableName=OFFLINE_USER_SESSION		\N	4.33.0	\N	\N	9583717615
25.0.0-28265-index-cleanup-uss-createdon	keycloak	META-INF/jpa-changelog-25.0.0.xml	2025-10-04 13:15:22.628601	132	EXECUTED	9:78ab4fc129ed5e8265dbcc3485fba92f	dropIndex indexName=IDX_OFFLINE_USS_CREATEDON, tableName=OFFLINE_USER_SESSION		\N	4.33.0	\N	\N	9583717615
25.0.0-28265-index-cleanup-uss-preload	keycloak	META-INF/jpa-changelog-25.0.0.xml	2025-10-04 13:15:22.632173	133	EXECUTED	9:de5f7c1f7e10994ed8b62e621d20eaab	dropIndex indexName=IDX_OFFLINE_USS_PRELOAD, tableName=OFFLINE_USER_SESSION		\N	4.33.0	\N	\N	9583717615
25.0.0-28265-index-cleanup-uss-by-usersess	keycloak	META-INF/jpa-changelog-25.0.0.xml	2025-10-04 13:15:22.636468	134	EXECUTED	9:6eee220d024e38e89c799417ec33667f	dropIndex indexName=IDX_OFFLINE_USS_BY_USERSESS, tableName=OFFLINE_USER_SESSION		\N	4.33.0	\N	\N	9583717615
25.0.0-28265-index-cleanup-css-preload	keycloak	META-INF/jpa-changelog-25.0.0.xml	2025-10-04 13:15:22.640367	135	EXECUTED	9:5411d2fb2891d3e8d63ddb55dfa3c0c9	dropIndex indexName=IDX_OFFLINE_CSS_PRELOAD, tableName=OFFLINE_CLIENT_SESSION		\N	4.33.0	\N	\N	9583717615
25.0.0-28265-index-2-mysql	keycloak	META-INF/jpa-changelog-25.0.0.xml	2025-10-04 13:15:22.641399	136	MARK_RAN	9:b7ef76036d3126bb83c2423bf4d449d6	createIndex indexName=IDX_OFFLINE_USS_BY_BROKER_SESSION_ID, tableName=OFFLINE_USER_SESSION		\N	4.33.0	\N	\N	9583717615
25.0.0-28265-index-2-not-mysql	keycloak	META-INF/jpa-changelog-25.0.0.xml	2025-10-04 13:15:22.657958	137	EXECUTED	9:23396cf51ab8bc1ae6f0cac7f9f6fcf7	createIndex indexName=IDX_OFFLINE_USS_BY_BROKER_SESSION_ID, tableName=OFFLINE_USER_SESSION		\N	4.33.0	\N	\N	9583717615
25.0.0-org	keycloak	META-INF/jpa-changelog-25.0.0.xml	2025-10-04 13:15:22.663721	138	EXECUTED	9:5c859965c2c9b9c72136c360649af157	createTable tableName=ORG; addUniqueConstraint constraintName=UK_ORG_NAME, tableName=ORG; addUniqueConstraint constraintName=UK_ORG_GROUP, tableName=ORG; createTable tableName=ORG_DOMAIN		\N	4.33.0	\N	\N	9583717615
unique-consentuser	keycloak	META-INF/jpa-changelog-25.0.0.xml	2025-10-04 13:15:22.668614	139	EXECUTED	9:5857626a2ea8767e9a6c66bf3a2cb32f	customChange; dropUniqueConstraint constraintName=UK_JKUWUVD56ONTGSUHOGM8UEWRT, tableName=USER_CONSENT; addUniqueConstraint constraintName=UK_LOCAL_CONSENT, tableName=USER_CONSENT; addUniqueConstraint constraintName=UK_EXTERNAL_CONSENT, tableName=...		\N	4.33.0	\N	\N	9583717615
unique-consentuser-edb-migration	keycloak	META-INF/jpa-changelog-25.0.0.xml	2025-10-04 13:15:22.67308	140	MARK_RAN	9:5857626a2ea8767e9a6c66bf3a2cb32f	customChange; dropUniqueConstraint constraintName=UK_JKUWUVD56ONTGSUHOGM8UEWRT, tableName=USER_CONSENT; addUniqueConstraint constraintName=UK_LOCAL_CONSENT, tableName=USER_CONSENT; addUniqueConstraint constraintName=UK_EXTERNAL_CONSENT, tableName=...		\N	4.33.0	\N	\N	9583717615
unique-consentuser-mysql	keycloak	META-INF/jpa-changelog-25.0.0.xml	2025-10-04 13:15:22.674229	141	MARK_RAN	9:b79478aad5adaa1bc428e31563f55e8e	customChange; dropUniqueConstraint constraintName=UK_JKUWUVD56ONTGSUHOGM8UEWRT, tableName=USER_CONSENT; addUniqueConstraint constraintName=UK_LOCAL_CONSENT, tableName=USER_CONSENT; addUniqueConstraint constraintName=UK_EXTERNAL_CONSENT, tableName=...		\N	4.33.0	\N	\N	9583717615
25.0.0-28861-index-creation	keycloak	META-INF/jpa-changelog-25.0.0.xml	2025-10-04 13:15:22.705246	142	EXECUTED	9:b9acb58ac958d9ada0fe12a5d4794ab1	createIndex indexName=IDX_PERM_TICKET_REQUESTER, tableName=RESOURCE_SERVER_PERM_TICKET; createIndex indexName=IDX_PERM_TICKET_OWNER, tableName=RESOURCE_SERVER_PERM_TICKET		\N	4.33.0	\N	\N	9583717615
26.0.0-org-alias	keycloak	META-INF/jpa-changelog-26.0.0.xml	2025-10-04 13:15:22.708464	143	EXECUTED	9:6ef7d63e4412b3c2d66ed179159886a4	addColumn tableName=ORG; update tableName=ORG; addNotNullConstraint columnName=ALIAS, tableName=ORG; addUniqueConstraint constraintName=UK_ORG_ALIAS, tableName=ORG		\N	4.33.0	\N	\N	9583717615
26.0.0-org-group	keycloak	META-INF/jpa-changelog-26.0.0.xml	2025-10-04 13:15:22.711976	144	EXECUTED	9:da8e8087d80ef2ace4f89d8c5b9ca223	addColumn tableName=KEYCLOAK_GROUP; update tableName=KEYCLOAK_GROUP; addNotNullConstraint columnName=TYPE, tableName=KEYCLOAK_GROUP; customChange		\N	4.33.0	\N	\N	9583717615
26.0.0-org-indexes	keycloak	META-INF/jpa-changelog-26.0.0.xml	2025-10-04 13:15:22.729883	145	EXECUTED	9:79b05dcd610a8c7f25ec05135eec0857	createIndex indexName=IDX_ORG_DOMAIN_ORG_ID, tableName=ORG_DOMAIN		\N	4.33.0	\N	\N	9583717615
26.0.0-org-group-membership	keycloak	META-INF/jpa-changelog-26.0.0.xml	2025-10-04 13:15:22.732998	146	EXECUTED	9:a6ace2ce583a421d89b01ba2a28dc2d4	addColumn tableName=USER_GROUP_MEMBERSHIP; update tableName=USER_GROUP_MEMBERSHIP; addNotNullConstraint columnName=MEMBERSHIP_TYPE, tableName=USER_GROUP_MEMBERSHIP		\N	4.33.0	\N	\N	9583717615
31296-persist-revoked-access-tokens	keycloak	META-INF/jpa-changelog-26.0.0.xml	2025-10-04 13:15:22.735672	147	EXECUTED	9:64ef94489d42a358e8304b0e245f0ed4	createTable tableName=REVOKED_TOKEN; addPrimaryKey constraintName=CONSTRAINT_RT, tableName=REVOKED_TOKEN		\N	4.33.0	\N	\N	9583717615
31725-index-persist-revoked-access-tokens	keycloak	META-INF/jpa-changelog-26.0.0.xml	2025-10-04 13:15:22.752607	148	EXECUTED	9:b994246ec2bf7c94da881e1d28782c7b	createIndex indexName=IDX_REV_TOKEN_ON_EXPIRE, tableName=REVOKED_TOKEN		\N	4.33.0	\N	\N	9583717615
26.0.0-idps-for-login	keycloak	META-INF/jpa-changelog-26.0.0.xml	2025-10-04 13:15:22.786864	149	EXECUTED	9:51f5fffadf986983d4bd59582c6c1604	addColumn tableName=IDENTITY_PROVIDER; createIndex indexName=IDX_IDP_REALM_ORG, tableName=IDENTITY_PROVIDER; createIndex indexName=IDX_IDP_FOR_LOGIN, tableName=IDENTITY_PROVIDER; customChange		\N	4.33.0	\N	\N	9583717615
26.0.0-32583-drop-redundant-index-on-client-session	keycloak	META-INF/jpa-changelog-26.0.0.xml	2025-10-04 13:15:22.790848	150	EXECUTED	9:24972d83bf27317a055d234187bb4af9	dropIndex indexName=IDX_US_SESS_ID_ON_CL_SESS, tableName=OFFLINE_CLIENT_SESSION		\N	4.33.0	\N	\N	9583717615
26.0.0.32582-remove-tables-user-session-user-session-note-and-client-session	keycloak	META-INF/jpa-changelog-26.0.0.xml	2025-10-04 13:15:22.797856	151	EXECUTED	9:febdc0f47f2ed241c59e60f58c3ceea5	dropTable tableName=CLIENT_SESSION_ROLE; dropTable tableName=CLIENT_SESSION_NOTE; dropTable tableName=CLIENT_SESSION_PROT_MAPPER; dropTable tableName=CLIENT_SESSION_AUTH_STATUS; dropTable tableName=CLIENT_USER_SESSION_NOTE; dropTable tableName=CLI...		\N	4.33.0	\N	\N	9583717615
26.0.0-33201-org-redirect-url	keycloak	META-INF/jpa-changelog-26.0.0.xml	2025-10-04 13:15:22.799613	152	EXECUTED	9:4d0e22b0ac68ebe9794fa9cb752ea660	addColumn tableName=ORG		\N	4.33.0	\N	\N	9583717615
29399-jdbc-ping-default	keycloak	META-INF/jpa-changelog-26.1.0.xml	2025-10-04 13:15:22.802611	153	EXECUTED	9:007dbe99d7203fca403b89d4edfdf21e	createTable tableName=JGROUPS_PING; addPrimaryKey constraintName=CONSTRAINT_JGROUPS_PING, tableName=JGROUPS_PING		\N	4.33.0	\N	\N	9583717615
26.1.0-34013	keycloak	META-INF/jpa-changelog-26.1.0.xml	2025-10-04 13:15:22.805493	154	EXECUTED	9:e6b686a15759aef99a6d758a5c4c6a26	addColumn tableName=ADMIN_EVENT_ENTITY		\N	4.33.0	\N	\N	9583717615
26.1.0-34380	keycloak	META-INF/jpa-changelog-26.1.0.xml	2025-10-04 13:15:22.807364	155	EXECUTED	9:ac8b9edb7c2b6c17a1c7a11fcf5ccf01	dropTable tableName=USERNAME_LOGIN_FAILURE		\N	4.33.0	\N	\N	9583717615
26.2.0-36750	keycloak	META-INF/jpa-changelog-26.2.0.xml	2025-10-04 13:15:22.810347	156	EXECUTED	9:b49ce951c22f7eb16480ff085640a33a	createTable tableName=SERVER_CONFIG		\N	4.33.0	\N	\N	9583717615
26.2.0-26106	keycloak	META-INF/jpa-changelog-26.2.0.xml	2025-10-04 13:15:22.812688	157	EXECUTED	9:b5877d5dab7d10ff3a9d209d7beb6680	addColumn tableName=CREDENTIAL		\N	4.33.0	\N	\N	9583717615
26.2.6-39866-duplicate	keycloak	META-INF/jpa-changelog-26.2.6.xml	2025-10-04 13:15:22.815583	158	EXECUTED	9:1dc67ccee24f30331db2cba4f372e40e	customChange		\N	4.33.0	\N	\N	9583717615
26.2.6-39866-uk	keycloak	META-INF/jpa-changelog-26.2.6.xml	2025-10-04 13:15:22.817658	159	EXECUTED	9:b70b76f47210cf0a5f4ef0e219eac7cd	addUniqueConstraint constraintName=UK_MIGRATION_VERSION, tableName=MIGRATION_MODEL		\N	4.33.0	\N	\N	9583717615
26.2.6-40088-duplicate	keycloak	META-INF/jpa-changelog-26.2.6.xml	2025-10-04 13:15:22.819896	160	EXECUTED	9:cc7e02ed69ab31979afb1982f9670e8f	customChange		\N	4.33.0	\N	\N	9583717615
26.2.6-40088-uk	keycloak	META-INF/jpa-changelog-26.2.6.xml	2025-10-04 13:15:22.821687	161	EXECUTED	9:5bb848128da7bc4595cc507383325241	addUniqueConstraint constraintName=UK_MIGRATION_UPDATE_TIME, tableName=MIGRATION_MODEL		\N	4.33.0	\N	\N	9583717615
26.3.0-groups-description	keycloak	META-INF/jpa-changelog-26.3.0.xml	2025-10-04 13:15:22.823737	162	EXECUTED	9:e1a3c05574326fb5b246b73b9a4c4d49	addColumn tableName=KEYCLOAK_GROUP		\N	4.33.0	\N	\N	9583717615
26.4.0-40933-saml-encryption-attributes	keycloak	META-INF/jpa-changelog-26.4.0.xml	2025-10-04 13:15:22.825958	163	EXECUTED	9:7e9eaba362ca105efdda202303a4fe49	customChange		\N	4.33.0	\N	\N	9583717615
26.4.0-51321	keycloak	META-INF/jpa-changelog-26.4.0.xml	2025-10-04 13:15:22.84149	164	EXECUTED	9:34bab2bc56f75ffd7e347c580874e306	createIndex indexName=IDX_EVENT_ENTITY_USER_ID_TYPE, tableName=EVENT_ENTITY		\N	4.33.0	\N	\N	9583717615
40343-workflow-state-table	keycloak	META-INF/jpa-changelog-26.4.0.xml	2025-10-04 13:15:22.871716	165	EXECUTED	9:ed3ab4723ceed210e5b5e60ac4562106	createTable tableName=WORKFLOW_STATE; addPrimaryKey constraintName=PK_WORKFLOW_STATE, tableName=WORKFLOW_STATE; addUniqueConstraint constraintName=UQ_WORKFLOW_RESOURCE, tableName=WORKFLOW_STATE; createIndex indexName=IDX_WORKFLOW_STATE_STEP, table...		\N	4.33.0	\N	\N	9583717615
\.


--
-- Data for Name: databasechangeloglock; Type: TABLE DATA; Schema: public; Owner: valknar
--

COPY public.databasechangeloglock (id, locked, lockgranted, lockedby) FROM stdin;
1	f	\N	\N
1000	f	\N	\N
\.


--
-- Data for Name: default_client_scope; Type: TABLE DATA; Schema: public; Owner: valknar
--

COPY public.default_client_scope (realm_id, scope_id, default_scope) FROM stdin;
8ae4cef1-1f2a-403a-b938-dd85e52895b8	aca9bfc0-a5ba-43dd-8273-0cdda56e6da7	f
8ae4cef1-1f2a-403a-b938-dd85e52895b8	eef4271b-1236-448a-a206-e8b64d341e68	t
8ae4cef1-1f2a-403a-b938-dd85e52895b8	fe1c1066-e7c3-4e91-9ac8-ddca15da24ad	t
8ae4cef1-1f2a-403a-b938-dd85e52895b8	85198f59-8318-434a-b4c9-d3baefe584b4	t
8ae4cef1-1f2a-403a-b938-dd85e52895b8	61f971fb-4c10-4fcd-9db4-733066c881cc	t
8ae4cef1-1f2a-403a-b938-dd85e52895b8	4689d0df-5b1d-4608-97ce-bff901d53c77	f
8ae4cef1-1f2a-403a-b938-dd85e52895b8	828b2f2f-5e4f-4e60-9e9c-df0b1872ac04	f
8ae4cef1-1f2a-403a-b938-dd85e52895b8	68b53ac7-f20b-4377-b89d-8c41f4986984	t
8ae4cef1-1f2a-403a-b938-dd85e52895b8	ec27336a-b2a4-4d9c-8909-13b27dc0f28c	t
8ae4cef1-1f2a-403a-b938-dd85e52895b8	4497a478-ab89-4f70-8b7d-ae2e2b35796e	f
8ae4cef1-1f2a-403a-b938-dd85e52895b8	5f5c1d7b-9593-4e21-ac47-e3f50ac8d2e4	t
8ae4cef1-1f2a-403a-b938-dd85e52895b8	1fb747c6-a776-4885-97d5-78b9a258d8cb	t
8ae4cef1-1f2a-403a-b938-dd85e52895b8	09ab32c4-ac44-4f07-8405-fa3b30ccf887	f
460a8e4b-5528-439c-ae10-29c984c7e8f5	123ac7c2-4a9a-4072-a5fe-ff43d8100d2b	f
460a8e4b-5528-439c-ae10-29c984c7e8f5	11a4af65-6453-45e2-b43c-00317d2153c9	t
460a8e4b-5528-439c-ae10-29c984c7e8f5	13bd5f7d-4e62-40e0-8706-23402ab04ac7	t
460a8e4b-5528-439c-ae10-29c984c7e8f5	608f045b-0e6e-4c03-922f-09d24b347e54	t
460a8e4b-5528-439c-ae10-29c984c7e8f5	307c64d0-1eab-46ea-8609-79fed3819c63	t
460a8e4b-5528-439c-ae10-29c984c7e8f5	2eee947b-c014-498b-b0b9-30f9837016b3	f
460a8e4b-5528-439c-ae10-29c984c7e8f5	f71fd363-2afb-465e-bcc3-988dab550c4e	f
460a8e4b-5528-439c-ae10-29c984c7e8f5	a4ffd0fa-fdde-4bbf-b010-a33f97bbea9b	t
460a8e4b-5528-439c-ae10-29c984c7e8f5	7b89a72a-18eb-40e6-894d-93e9b09c6397	t
460a8e4b-5528-439c-ae10-29c984c7e8f5	5705c761-1e66-4308-a8c9-f157a0c959db	f
460a8e4b-5528-439c-ae10-29c984c7e8f5	1b261132-0338-48f4-b182-f1ca8cd1d788	t
460a8e4b-5528-439c-ae10-29c984c7e8f5	e0fe63e3-4708-4949-a7f6-623bcd0fe950	t
460a8e4b-5528-439c-ae10-29c984c7e8f5	f7f027c3-a693-42d5-b2dc-d3d7e4fa43e0	f
\.


--
-- Data for Name: event_entity; Type: TABLE DATA; Schema: public; Owner: valknar
--

COPY public.event_entity (id, client_id, details_json, error, ip_address, realm_id, session_id, event_time, type, user_id, details_json_long_value) FROM stdin;
\.


--
-- Data for Name: fed_user_attribute; Type: TABLE DATA; Schema: public; Owner: valknar
--

COPY public.fed_user_attribute (id, name, user_id, realm_id, storage_provider_id, value, long_value_hash, long_value_hash_lower_case, long_value) FROM stdin;
\.


--
-- Data for Name: fed_user_consent; Type: TABLE DATA; Schema: public; Owner: valknar
--

COPY public.fed_user_consent (id, client_id, user_id, realm_id, storage_provider_id, created_date, last_updated_date, client_storage_provider, external_client_id) FROM stdin;
\.


--
-- Data for Name: fed_user_consent_cl_scope; Type: TABLE DATA; Schema: public; Owner: valknar
--

COPY public.fed_user_consent_cl_scope (user_consent_id, scope_id) FROM stdin;
\.


--
-- Data for Name: fed_user_credential; Type: TABLE DATA; Schema: public; Owner: valknar
--

COPY public.fed_user_credential (id, salt, type, created_date, user_id, realm_id, storage_provider_id, user_label, secret_data, credential_data, priority) FROM stdin;
\.


--
-- Data for Name: fed_user_group_membership; Type: TABLE DATA; Schema: public; Owner: valknar
--

COPY public.fed_user_group_membership (group_id, user_id, realm_id, storage_provider_id) FROM stdin;
\.


--
-- Data for Name: fed_user_required_action; Type: TABLE DATA; Schema: public; Owner: valknar
--

COPY public.fed_user_required_action (required_action, user_id, realm_id, storage_provider_id) FROM stdin;
\.


--
-- Data for Name: fed_user_role_mapping; Type: TABLE DATA; Schema: public; Owner: valknar
--

COPY public.fed_user_role_mapping (role_id, user_id, realm_id, storage_provider_id) FROM stdin;
\.


--
-- Data for Name: federated_identity; Type: TABLE DATA; Schema: public; Owner: valknar
--

COPY public.federated_identity (identity_provider, realm_id, federated_user_id, federated_username, token, user_id) FROM stdin;
\.


--
-- Data for Name: federated_user; Type: TABLE DATA; Schema: public; Owner: valknar
--

COPY public.federated_user (id, storage_provider_id, realm_id) FROM stdin;
\.


--
-- Data for Name: group_attribute; Type: TABLE DATA; Schema: public; Owner: valknar
--

COPY public.group_attribute (id, name, value, group_id) FROM stdin;
\.


--
-- Data for Name: group_role_mapping; Type: TABLE DATA; Schema: public; Owner: valknar
--

COPY public.group_role_mapping (role_id, group_id) FROM stdin;
\.


--
-- Data for Name: identity_provider; Type: TABLE DATA; Schema: public; Owner: valknar
--

COPY public.identity_provider (internal_id, enabled, provider_alias, provider_id, store_token, authenticate_by_default, realm_id, add_token_role, trust_email, first_broker_login_flow_id, post_broker_login_flow_id, provider_display_name, link_only, organization_id, hide_on_login) FROM stdin;
\.


--
-- Data for Name: identity_provider_config; Type: TABLE DATA; Schema: public; Owner: valknar
--

COPY public.identity_provider_config (identity_provider_id, value, name) FROM stdin;
\.


--
-- Data for Name: identity_provider_mapper; Type: TABLE DATA; Schema: public; Owner: valknar
--

COPY public.identity_provider_mapper (id, name, idp_alias, idp_mapper_name, realm_id) FROM stdin;
\.


--
-- Data for Name: idp_mapper_config; Type: TABLE DATA; Schema: public; Owner: valknar
--

COPY public.idp_mapper_config (idp_mapper_id, value, name) FROM stdin;
\.


--
-- Data for Name: jgroups_ping; Type: TABLE DATA; Schema: public; Owner: valknar
--

COPY public.jgroups_ping (address, name, cluster_name, ip, coord) FROM stdin;
uuid://00000000-0000-0000-0000-000000000019	91ded5dca9ee-27726	ISPN	172.18.0.4:7800	t
\.


--
-- Data for Name: keycloak_group; Type: TABLE DATA; Schema: public; Owner: valknar
--

COPY public.keycloak_group (id, name, parent_group, realm_id, type, description) FROM stdin;
\.


--
-- Data for Name: keycloak_role; Type: TABLE DATA; Schema: public; Owner: valknar
--

COPY public.keycloak_role (id, client_realm_constraint, client_role, description, name, realm_id, client, realm) FROM stdin;
54fe2c16-b141-4a22-b5ef-d24d35a38ccc	8ae4cef1-1f2a-403a-b938-dd85e52895b8	f	${role_default-roles}	default-roles-master	8ae4cef1-1f2a-403a-b938-dd85e52895b8	\N	\N
33a5cb28-0c54-45db-bbf7-0aceb2816172	8ae4cef1-1f2a-403a-b938-dd85e52895b8	f	${role_admin}	admin	8ae4cef1-1f2a-403a-b938-dd85e52895b8	\N	\N
3faa959a-d3bb-4a2e-ba67-88abac994c80	8ae4cef1-1f2a-403a-b938-dd85e52895b8	f	${role_create-realm}	create-realm	8ae4cef1-1f2a-403a-b938-dd85e52895b8	\N	\N
2c09bb2d-06cc-427f-97dc-0d4aeea5ea0b	2ba16542-30d0-449e-aca5-25498bcbbaf0	t	${role_create-client}	create-client	8ae4cef1-1f2a-403a-b938-dd85e52895b8	2ba16542-30d0-449e-aca5-25498bcbbaf0	\N
5e402a72-1561-4690-ac36-4c820cec06b4	2ba16542-30d0-449e-aca5-25498bcbbaf0	t	${role_view-realm}	view-realm	8ae4cef1-1f2a-403a-b938-dd85e52895b8	2ba16542-30d0-449e-aca5-25498bcbbaf0	\N
882b1e5d-4dd7-46af-92e4-3d20c8d46a35	2ba16542-30d0-449e-aca5-25498bcbbaf0	t	${role_view-users}	view-users	8ae4cef1-1f2a-403a-b938-dd85e52895b8	2ba16542-30d0-449e-aca5-25498bcbbaf0	\N
3e50c3be-0842-4601-ad95-507ad55e0088	2ba16542-30d0-449e-aca5-25498bcbbaf0	t	${role_view-clients}	view-clients	8ae4cef1-1f2a-403a-b938-dd85e52895b8	2ba16542-30d0-449e-aca5-25498bcbbaf0	\N
6316ec15-da8e-4413-ad57-e413e4486e57	2ba16542-30d0-449e-aca5-25498bcbbaf0	t	${role_view-events}	view-events	8ae4cef1-1f2a-403a-b938-dd85e52895b8	2ba16542-30d0-449e-aca5-25498bcbbaf0	\N
51299522-0e29-46b1-9daa-bbea8fe3125b	2ba16542-30d0-449e-aca5-25498bcbbaf0	t	${role_view-identity-providers}	view-identity-providers	8ae4cef1-1f2a-403a-b938-dd85e52895b8	2ba16542-30d0-449e-aca5-25498bcbbaf0	\N
428bdd17-acb1-4d8d-b771-f4a400091c23	2ba16542-30d0-449e-aca5-25498bcbbaf0	t	${role_view-authorization}	view-authorization	8ae4cef1-1f2a-403a-b938-dd85e52895b8	2ba16542-30d0-449e-aca5-25498bcbbaf0	\N
b10722f8-81b3-493f-b1af-7ca192470eeb	2ba16542-30d0-449e-aca5-25498bcbbaf0	t	${role_manage-realm}	manage-realm	8ae4cef1-1f2a-403a-b938-dd85e52895b8	2ba16542-30d0-449e-aca5-25498bcbbaf0	\N
57a79214-ee05-4eee-81f7-9e979e245da7	2ba16542-30d0-449e-aca5-25498bcbbaf0	t	${role_manage-users}	manage-users	8ae4cef1-1f2a-403a-b938-dd85e52895b8	2ba16542-30d0-449e-aca5-25498bcbbaf0	\N
0a8b6bc6-4e3f-4392-a3fa-0288bf69c1a3	2ba16542-30d0-449e-aca5-25498bcbbaf0	t	${role_manage-clients}	manage-clients	8ae4cef1-1f2a-403a-b938-dd85e52895b8	2ba16542-30d0-449e-aca5-25498bcbbaf0	\N
8eb17802-935e-4d93-87e1-74175258d87b	2ba16542-30d0-449e-aca5-25498bcbbaf0	t	${role_manage-events}	manage-events	8ae4cef1-1f2a-403a-b938-dd85e52895b8	2ba16542-30d0-449e-aca5-25498bcbbaf0	\N
a8e00f94-58c8-4d14-87ce-452abb76340b	2ba16542-30d0-449e-aca5-25498bcbbaf0	t	${role_manage-identity-providers}	manage-identity-providers	8ae4cef1-1f2a-403a-b938-dd85e52895b8	2ba16542-30d0-449e-aca5-25498bcbbaf0	\N
510bdfa6-13a7-43a0-abc4-5afa2dff699f	2ba16542-30d0-449e-aca5-25498bcbbaf0	t	${role_manage-authorization}	manage-authorization	8ae4cef1-1f2a-403a-b938-dd85e52895b8	2ba16542-30d0-449e-aca5-25498bcbbaf0	\N
ad403d7a-f928-484b-bfe1-6eee16819a3a	2ba16542-30d0-449e-aca5-25498bcbbaf0	t	${role_query-users}	query-users	8ae4cef1-1f2a-403a-b938-dd85e52895b8	2ba16542-30d0-449e-aca5-25498bcbbaf0	\N
ecb0ed91-dfc0-44a3-b165-977d7fe976e5	2ba16542-30d0-449e-aca5-25498bcbbaf0	t	${role_query-clients}	query-clients	8ae4cef1-1f2a-403a-b938-dd85e52895b8	2ba16542-30d0-449e-aca5-25498bcbbaf0	\N
872a6f56-c435-47a7-8a47-d54664224829	2ba16542-30d0-449e-aca5-25498bcbbaf0	t	${role_query-realms}	query-realms	8ae4cef1-1f2a-403a-b938-dd85e52895b8	2ba16542-30d0-449e-aca5-25498bcbbaf0	\N
b416ac3c-cf43-4b4d-8323-cc8f2238c24e	2ba16542-30d0-449e-aca5-25498bcbbaf0	t	${role_query-groups}	query-groups	8ae4cef1-1f2a-403a-b938-dd85e52895b8	2ba16542-30d0-449e-aca5-25498bcbbaf0	\N
6df1e072-9298-447d-a3cb-b7c39b70702c	088ba46b-0bc3-49fb-8452-cbe125bff9fd	t	${role_view-profile}	view-profile	8ae4cef1-1f2a-403a-b938-dd85e52895b8	088ba46b-0bc3-49fb-8452-cbe125bff9fd	\N
7876c425-56bd-499a-bc55-dffb1b64c005	088ba46b-0bc3-49fb-8452-cbe125bff9fd	t	${role_manage-account}	manage-account	8ae4cef1-1f2a-403a-b938-dd85e52895b8	088ba46b-0bc3-49fb-8452-cbe125bff9fd	\N
86f8c008-455e-4764-a327-17d69cfb281c	088ba46b-0bc3-49fb-8452-cbe125bff9fd	t	${role_manage-account-links}	manage-account-links	8ae4cef1-1f2a-403a-b938-dd85e52895b8	088ba46b-0bc3-49fb-8452-cbe125bff9fd	\N
19759291-04d7-43bb-ad1e-a62c78d2795c	088ba46b-0bc3-49fb-8452-cbe125bff9fd	t	${role_view-applications}	view-applications	8ae4cef1-1f2a-403a-b938-dd85e52895b8	088ba46b-0bc3-49fb-8452-cbe125bff9fd	\N
bfb0a630-3585-4cd4-a310-9950be069484	088ba46b-0bc3-49fb-8452-cbe125bff9fd	t	${role_view-consent}	view-consent	8ae4cef1-1f2a-403a-b938-dd85e52895b8	088ba46b-0bc3-49fb-8452-cbe125bff9fd	\N
02337920-bee1-4a50-a40e-aade334f818f	088ba46b-0bc3-49fb-8452-cbe125bff9fd	t	${role_manage-consent}	manage-consent	8ae4cef1-1f2a-403a-b938-dd85e52895b8	088ba46b-0bc3-49fb-8452-cbe125bff9fd	\N
9bd6b9ea-6017-4ab0-ad28-934b6e5b2b7f	088ba46b-0bc3-49fb-8452-cbe125bff9fd	t	${role_view-groups}	view-groups	8ae4cef1-1f2a-403a-b938-dd85e52895b8	088ba46b-0bc3-49fb-8452-cbe125bff9fd	\N
48b13b78-7113-4435-948d-98c54333637d	088ba46b-0bc3-49fb-8452-cbe125bff9fd	t	${role_delete-account}	delete-account	8ae4cef1-1f2a-403a-b938-dd85e52895b8	088ba46b-0bc3-49fb-8452-cbe125bff9fd	\N
0be59f49-8bf3-4db5-be3d-24bc986ca8f6	bd4bd60b-90d3-4a34-8a18-b7c9c713fc6f	t	${role_read-token}	read-token	8ae4cef1-1f2a-403a-b938-dd85e52895b8	bd4bd60b-90d3-4a34-8a18-b7c9c713fc6f	\N
b13ac2cf-8fa1-4e76-8200-9be68f702eab	2ba16542-30d0-449e-aca5-25498bcbbaf0	t	${role_impersonation}	impersonation	8ae4cef1-1f2a-403a-b938-dd85e52895b8	2ba16542-30d0-449e-aca5-25498bcbbaf0	\N
42a4cd37-3f8c-419d-b894-c17749889e03	8ae4cef1-1f2a-403a-b938-dd85e52895b8	f	${role_offline-access}	offline_access	8ae4cef1-1f2a-403a-b938-dd85e52895b8	\N	\N
70b1df9b-c0af-4398-b78b-1555def75d3e	8ae4cef1-1f2a-403a-b938-dd85e52895b8	f	${role_uma_authorization}	uma_authorization	8ae4cef1-1f2a-403a-b938-dd85e52895b8	\N	\N
8a361c62-09d4-44f2-828b-be78e38e8966	460a8e4b-5528-439c-ae10-29c984c7e8f5	f	${role_default-roles}	default-roles-pivoine.art	460a8e4b-5528-439c-ae10-29c984c7e8f5	\N	\N
afc2af5d-7da8-4039-aab4-dc8844872ded	0333da14-7d08-4ea6-a808-2aaa7d3411f3	t	${role_create-client}	create-client	8ae4cef1-1f2a-403a-b938-dd85e52895b8	0333da14-7d08-4ea6-a808-2aaa7d3411f3	\N
8a68ca04-3339-47ba-be7d-aabd3e26e8b5	0333da14-7d08-4ea6-a808-2aaa7d3411f3	t	${role_view-realm}	view-realm	8ae4cef1-1f2a-403a-b938-dd85e52895b8	0333da14-7d08-4ea6-a808-2aaa7d3411f3	\N
d9f6e1f3-718a-44b8-9289-b12f7dc608f8	0333da14-7d08-4ea6-a808-2aaa7d3411f3	t	${role_view-users}	view-users	8ae4cef1-1f2a-403a-b938-dd85e52895b8	0333da14-7d08-4ea6-a808-2aaa7d3411f3	\N
e150e283-31e4-404b-b288-09c2b303c436	0333da14-7d08-4ea6-a808-2aaa7d3411f3	t	${role_view-clients}	view-clients	8ae4cef1-1f2a-403a-b938-dd85e52895b8	0333da14-7d08-4ea6-a808-2aaa7d3411f3	\N
72b9e56d-14bd-46cd-a5a8-7b481159e4cb	0333da14-7d08-4ea6-a808-2aaa7d3411f3	t	${role_view-events}	view-events	8ae4cef1-1f2a-403a-b938-dd85e52895b8	0333da14-7d08-4ea6-a808-2aaa7d3411f3	\N
6a230f46-6d45-47ce-9559-7d27f3d3e570	0333da14-7d08-4ea6-a808-2aaa7d3411f3	t	${role_view-identity-providers}	view-identity-providers	8ae4cef1-1f2a-403a-b938-dd85e52895b8	0333da14-7d08-4ea6-a808-2aaa7d3411f3	\N
28e9e9de-3a3d-42de-b345-2ce7ff83bb25	0333da14-7d08-4ea6-a808-2aaa7d3411f3	t	${role_view-authorization}	view-authorization	8ae4cef1-1f2a-403a-b938-dd85e52895b8	0333da14-7d08-4ea6-a808-2aaa7d3411f3	\N
7a449afe-2eb9-469f-ad3c-ff725acf05a9	0333da14-7d08-4ea6-a808-2aaa7d3411f3	t	${role_manage-realm}	manage-realm	8ae4cef1-1f2a-403a-b938-dd85e52895b8	0333da14-7d08-4ea6-a808-2aaa7d3411f3	\N
177075ca-ae6c-45ea-9358-fc6d6b6ab698	0333da14-7d08-4ea6-a808-2aaa7d3411f3	t	${role_manage-users}	manage-users	8ae4cef1-1f2a-403a-b938-dd85e52895b8	0333da14-7d08-4ea6-a808-2aaa7d3411f3	\N
b4288e0c-8c07-4930-b2d7-5c44d03d4736	0333da14-7d08-4ea6-a808-2aaa7d3411f3	t	${role_manage-clients}	manage-clients	8ae4cef1-1f2a-403a-b938-dd85e52895b8	0333da14-7d08-4ea6-a808-2aaa7d3411f3	\N
979d735b-7332-4f3c-9094-becb2998fc12	0333da14-7d08-4ea6-a808-2aaa7d3411f3	t	${role_manage-events}	manage-events	8ae4cef1-1f2a-403a-b938-dd85e52895b8	0333da14-7d08-4ea6-a808-2aaa7d3411f3	\N
d3bb4d5f-68ee-4c21-aefd-91a59fa40394	0333da14-7d08-4ea6-a808-2aaa7d3411f3	t	${role_manage-identity-providers}	manage-identity-providers	8ae4cef1-1f2a-403a-b938-dd85e52895b8	0333da14-7d08-4ea6-a808-2aaa7d3411f3	\N
b6644991-5c9e-4668-8ace-e1b53e6d6b09	0333da14-7d08-4ea6-a808-2aaa7d3411f3	t	${role_manage-authorization}	manage-authorization	8ae4cef1-1f2a-403a-b938-dd85e52895b8	0333da14-7d08-4ea6-a808-2aaa7d3411f3	\N
de119a47-0207-4912-9af8-374b92dd60a8	0333da14-7d08-4ea6-a808-2aaa7d3411f3	t	${role_query-users}	query-users	8ae4cef1-1f2a-403a-b938-dd85e52895b8	0333da14-7d08-4ea6-a808-2aaa7d3411f3	\N
54a29634-c0e8-4298-88f9-5abd0e2b2f39	0333da14-7d08-4ea6-a808-2aaa7d3411f3	t	${role_query-clients}	query-clients	8ae4cef1-1f2a-403a-b938-dd85e52895b8	0333da14-7d08-4ea6-a808-2aaa7d3411f3	\N
9edfaea2-d918-478e-802c-87cc2f28caa2	0333da14-7d08-4ea6-a808-2aaa7d3411f3	t	${role_query-realms}	query-realms	8ae4cef1-1f2a-403a-b938-dd85e52895b8	0333da14-7d08-4ea6-a808-2aaa7d3411f3	\N
4e836731-0139-4bc6-ac08-6ebec077d859	0333da14-7d08-4ea6-a808-2aaa7d3411f3	t	${role_query-groups}	query-groups	8ae4cef1-1f2a-403a-b938-dd85e52895b8	0333da14-7d08-4ea6-a808-2aaa7d3411f3	\N
0820ab47-f4e6-4929-8b57-1f3160fff57c	a7c21283-c174-4852-9ef6-a6d9f29c3ab9	t	${role_realm-admin}	realm-admin	460a8e4b-5528-439c-ae10-29c984c7e8f5	a7c21283-c174-4852-9ef6-a6d9f29c3ab9	\N
8728b3a1-4d11-4d29-b870-d4e745866866	a7c21283-c174-4852-9ef6-a6d9f29c3ab9	t	${role_create-client}	create-client	460a8e4b-5528-439c-ae10-29c984c7e8f5	a7c21283-c174-4852-9ef6-a6d9f29c3ab9	\N
8532486b-4100-4f33-bddd-7d3de1d45e41	a7c21283-c174-4852-9ef6-a6d9f29c3ab9	t	${role_view-realm}	view-realm	460a8e4b-5528-439c-ae10-29c984c7e8f5	a7c21283-c174-4852-9ef6-a6d9f29c3ab9	\N
d8f0f65b-f633-4cd2-b63b-54ce97448f80	a7c21283-c174-4852-9ef6-a6d9f29c3ab9	t	${role_view-users}	view-users	460a8e4b-5528-439c-ae10-29c984c7e8f5	a7c21283-c174-4852-9ef6-a6d9f29c3ab9	\N
dac9d43f-1b24-4f55-8791-ab9faa3081b5	a7c21283-c174-4852-9ef6-a6d9f29c3ab9	t	${role_view-clients}	view-clients	460a8e4b-5528-439c-ae10-29c984c7e8f5	a7c21283-c174-4852-9ef6-a6d9f29c3ab9	\N
c78d42be-0ac4-4528-ae73-4e4ca8ffbcae	a7c21283-c174-4852-9ef6-a6d9f29c3ab9	t	${role_view-events}	view-events	460a8e4b-5528-439c-ae10-29c984c7e8f5	a7c21283-c174-4852-9ef6-a6d9f29c3ab9	\N
0ff76ba6-cb91-4c8d-8340-cc30709aa5db	a7c21283-c174-4852-9ef6-a6d9f29c3ab9	t	${role_view-identity-providers}	view-identity-providers	460a8e4b-5528-439c-ae10-29c984c7e8f5	a7c21283-c174-4852-9ef6-a6d9f29c3ab9	\N
050cd0e1-c3e8-4228-9db4-1240813a0c80	a7c21283-c174-4852-9ef6-a6d9f29c3ab9	t	${role_view-authorization}	view-authorization	460a8e4b-5528-439c-ae10-29c984c7e8f5	a7c21283-c174-4852-9ef6-a6d9f29c3ab9	\N
821a9342-9cc7-400f-986d-4b59c40f8516	a7c21283-c174-4852-9ef6-a6d9f29c3ab9	t	${role_manage-realm}	manage-realm	460a8e4b-5528-439c-ae10-29c984c7e8f5	a7c21283-c174-4852-9ef6-a6d9f29c3ab9	\N
4f75de12-39dc-4364-b90f-34d35be6cd66	a7c21283-c174-4852-9ef6-a6d9f29c3ab9	t	${role_manage-users}	manage-users	460a8e4b-5528-439c-ae10-29c984c7e8f5	a7c21283-c174-4852-9ef6-a6d9f29c3ab9	\N
6f970d95-4ce8-438f-b41d-36daf45b6f88	a7c21283-c174-4852-9ef6-a6d9f29c3ab9	t	${role_manage-clients}	manage-clients	460a8e4b-5528-439c-ae10-29c984c7e8f5	a7c21283-c174-4852-9ef6-a6d9f29c3ab9	\N
2d237b7c-1db7-4720-8db1-8344ec0db703	a7c21283-c174-4852-9ef6-a6d9f29c3ab9	t	${role_manage-events}	manage-events	460a8e4b-5528-439c-ae10-29c984c7e8f5	a7c21283-c174-4852-9ef6-a6d9f29c3ab9	\N
2120dc7d-1c4b-48d4-bbea-f004e26d22a2	a7c21283-c174-4852-9ef6-a6d9f29c3ab9	t	${role_manage-identity-providers}	manage-identity-providers	460a8e4b-5528-439c-ae10-29c984c7e8f5	a7c21283-c174-4852-9ef6-a6d9f29c3ab9	\N
ca579b28-efc3-455b-ab91-7334f7e29238	a7c21283-c174-4852-9ef6-a6d9f29c3ab9	t	${role_manage-authorization}	manage-authorization	460a8e4b-5528-439c-ae10-29c984c7e8f5	a7c21283-c174-4852-9ef6-a6d9f29c3ab9	\N
aca3d119-91c0-4238-9654-bb418ad8a338	a7c21283-c174-4852-9ef6-a6d9f29c3ab9	t	${role_query-users}	query-users	460a8e4b-5528-439c-ae10-29c984c7e8f5	a7c21283-c174-4852-9ef6-a6d9f29c3ab9	\N
d33a6b59-37fe-42d4-a444-9f227273aa8a	a7c21283-c174-4852-9ef6-a6d9f29c3ab9	t	${role_query-clients}	query-clients	460a8e4b-5528-439c-ae10-29c984c7e8f5	a7c21283-c174-4852-9ef6-a6d9f29c3ab9	\N
15ee3c0b-d4fa-4ff2-af53-969ad65c3094	a7c21283-c174-4852-9ef6-a6d9f29c3ab9	t	${role_query-realms}	query-realms	460a8e4b-5528-439c-ae10-29c984c7e8f5	a7c21283-c174-4852-9ef6-a6d9f29c3ab9	\N
0cc66ba5-9121-45e6-9c46-8543f060565a	a7c21283-c174-4852-9ef6-a6d9f29c3ab9	t	${role_query-groups}	query-groups	460a8e4b-5528-439c-ae10-29c984c7e8f5	a7c21283-c174-4852-9ef6-a6d9f29c3ab9	\N
e6da4ae5-a0ff-4c3b-a5b9-500de2a2ed67	36a4d1a1-9c0d-42cc-bd41-c8970391cbdb	t	${role_view-profile}	view-profile	460a8e4b-5528-439c-ae10-29c984c7e8f5	36a4d1a1-9c0d-42cc-bd41-c8970391cbdb	\N
0ec4e6ea-0f9f-4d17-9805-5154acfcaaac	36a4d1a1-9c0d-42cc-bd41-c8970391cbdb	t	${role_manage-account}	manage-account	460a8e4b-5528-439c-ae10-29c984c7e8f5	36a4d1a1-9c0d-42cc-bd41-c8970391cbdb	\N
4a0259ee-8846-4abb-aebd-26be5f392a0c	36a4d1a1-9c0d-42cc-bd41-c8970391cbdb	t	${role_manage-account-links}	manage-account-links	460a8e4b-5528-439c-ae10-29c984c7e8f5	36a4d1a1-9c0d-42cc-bd41-c8970391cbdb	\N
255a624c-98f2-49cb-82d1-adc138a9ce8c	36a4d1a1-9c0d-42cc-bd41-c8970391cbdb	t	${role_view-applications}	view-applications	460a8e4b-5528-439c-ae10-29c984c7e8f5	36a4d1a1-9c0d-42cc-bd41-c8970391cbdb	\N
5542dc51-81df-41cf-a979-55b8cb0a67c5	36a4d1a1-9c0d-42cc-bd41-c8970391cbdb	t	${role_view-consent}	view-consent	460a8e4b-5528-439c-ae10-29c984c7e8f5	36a4d1a1-9c0d-42cc-bd41-c8970391cbdb	\N
448fe05f-fe5f-4810-9a01-80ba41c92604	36a4d1a1-9c0d-42cc-bd41-c8970391cbdb	t	${role_manage-consent}	manage-consent	460a8e4b-5528-439c-ae10-29c984c7e8f5	36a4d1a1-9c0d-42cc-bd41-c8970391cbdb	\N
5badb0ad-4227-473c-ac3b-260e73ed538c	36a4d1a1-9c0d-42cc-bd41-c8970391cbdb	t	${role_view-groups}	view-groups	460a8e4b-5528-439c-ae10-29c984c7e8f5	36a4d1a1-9c0d-42cc-bd41-c8970391cbdb	\N
0db0f170-4c37-4e4b-be3c-b0b1f124c228	36a4d1a1-9c0d-42cc-bd41-c8970391cbdb	t	${role_delete-account}	delete-account	460a8e4b-5528-439c-ae10-29c984c7e8f5	36a4d1a1-9c0d-42cc-bd41-c8970391cbdb	\N
bde0ad48-3714-4424-a028-011c3449d19a	0333da14-7d08-4ea6-a808-2aaa7d3411f3	t	${role_impersonation}	impersonation	8ae4cef1-1f2a-403a-b938-dd85e52895b8	0333da14-7d08-4ea6-a808-2aaa7d3411f3	\N
166902e1-5f23-49f2-90e4-9b8cd585a82d	a7c21283-c174-4852-9ef6-a6d9f29c3ab9	t	${role_impersonation}	impersonation	460a8e4b-5528-439c-ae10-29c984c7e8f5	a7c21283-c174-4852-9ef6-a6d9f29c3ab9	\N
545b728c-b1bc-4f12-a466-ec46bfc11892	c4965edf-d53a-4211-bf6a-3ff49d604a4c	t	${role_read-token}	read-token	460a8e4b-5528-439c-ae10-29c984c7e8f5	c4965edf-d53a-4211-bf6a-3ff49d604a4c	\N
fcf0fa2d-93b5-461b-9abb-2c1645106857	460a8e4b-5528-439c-ae10-29c984c7e8f5	f	${role_offline-access}	offline_access	460a8e4b-5528-439c-ae10-29c984c7e8f5	\N	\N
ee3e0abd-7409-4b7a-b718-b884194db528	460a8e4b-5528-439c-ae10-29c984c7e8f5	f	${role_uma_authorization}	uma_authorization	460a8e4b-5528-439c-ae10-29c984c7e8f5	\N	\N
\.


--
-- Data for Name: migration_model; Type: TABLE DATA; Schema: public; Owner: valknar
--

COPY public.migration_model (id, version, update_time) FROM stdin;
is2ju	26.4.0	1759583724
\.


--
-- Data for Name: offline_client_session; Type: TABLE DATA; Schema: public; Owner: valknar
--

COPY public.offline_client_session (user_session_id, client_id, offline_flag, "timestamp", data, client_storage_provider, external_client_id, version) FROM stdin;
\.


--
-- Data for Name: offline_user_session; Type: TABLE DATA; Schema: public; Owner: valknar
--

COPY public.offline_user_session (user_session_id, user_id, realm_id, created_on, offline_flag, data, last_session_refresh, broker_session_id, version) FROM stdin;
\.


--
-- Data for Name: org; Type: TABLE DATA; Schema: public; Owner: valknar
--

COPY public.org (id, enabled, realm_id, group_id, name, description, alias, redirect_url) FROM stdin;
\.


--
-- Data for Name: org_domain; Type: TABLE DATA; Schema: public; Owner: valknar
--

COPY public.org_domain (id, name, verified, org_id) FROM stdin;
\.


--
-- Data for Name: policy_config; Type: TABLE DATA; Schema: public; Owner: valknar
--

COPY public.policy_config (policy_id, name, value) FROM stdin;
\.


--
-- Data for Name: protocol_mapper; Type: TABLE DATA; Schema: public; Owner: valknar
--

COPY public.protocol_mapper (id, name, protocol, protocol_mapper_name, client_id, client_scope_id) FROM stdin;
2a836b49-22f4-457f-a1fa-e149f1b4e174	docker-v2-allow-all-mapper	docker-v2	docker-v2-allow-all-mapper	088ba46b-0bc3-49fb-8452-cbe125bff9fd	\N
bb65b0ef-4a4a-42b6-8c83-710ca7ed9daa	docker-v2-allow-all-mapper	docker-v2	docker-v2-allow-all-mapper	dcfd54d7-6c78-4fea-9476-63b29e7cb5b8	\N
35434f2e-d7ab-4200-bb87-df70f5f2d6f9	audience resolve	openid-connect	oidc-audience-resolve-mapper	dcfd54d7-6c78-4fea-9476-63b29e7cb5b8	\N
8cbe83a1-354e-45f3-8bea-53b940d9b8b0	docker-v2-allow-all-mapper	docker-v2	docker-v2-allow-all-mapper	bd4bd60b-90d3-4a34-8a18-b7c9c713fc6f	\N
e9830057-cb51-4cc7-b22f-1b9fd3a7459b	docker-v2-allow-all-mapper	docker-v2	docker-v2-allow-all-mapper	38e23499-9126-46d6-8d7c-9a9058214fa6	\N
2b97a76b-32c7-4378-bce1-4b35b504ddf8	locale	openid-connect	oidc-usermodel-attribute-mapper	38e23499-9126-46d6-8d7c-9a9058214fa6	\N
79564338-6c40-4c52-bd9e-78c9a24b8488	docker-v2-allow-all-mapper	docker-v2	docker-v2-allow-all-mapper	0bc37e6d-8ce1-439d-90be-6cd8e541a904	\N
6a12d45d-ac80-48f7-a4ac-7eb927bf905a	role list	saml	saml-role-list-mapper	\N	eef4271b-1236-448a-a206-e8b64d341e68
5b6eba18-ed50-4675-b269-a307f020cd4d	organization	saml	saml-organization-membership-mapper	\N	fe1c1066-e7c3-4e91-9ac8-ddca15da24ad
43d9d661-ef15-49a5-a693-281dd6a702f5	full name	openid-connect	oidc-full-name-mapper	\N	85198f59-8318-434a-b4c9-d3baefe584b4
6e8230ca-a752-4d54-a178-737f57c4616c	family name	openid-connect	oidc-usermodel-attribute-mapper	\N	85198f59-8318-434a-b4c9-d3baefe584b4
cc9705a0-e33d-43b8-aeab-44b137f44aff	given name	openid-connect	oidc-usermodel-attribute-mapper	\N	85198f59-8318-434a-b4c9-d3baefe584b4
77236d33-dd31-41bf-9978-78247d571b29	middle name	openid-connect	oidc-usermodel-attribute-mapper	\N	85198f59-8318-434a-b4c9-d3baefe584b4
520d40b9-d2a8-43c8-adbe-409bfe60913c	nickname	openid-connect	oidc-usermodel-attribute-mapper	\N	85198f59-8318-434a-b4c9-d3baefe584b4
97b531ea-d211-4268-93f3-b3ed773638a8	username	openid-connect	oidc-usermodel-attribute-mapper	\N	85198f59-8318-434a-b4c9-d3baefe584b4
a148b61a-ae12-4ded-bbd5-3f2692eee3cf	profile	openid-connect	oidc-usermodel-attribute-mapper	\N	85198f59-8318-434a-b4c9-d3baefe584b4
c1428d10-f545-4070-98ce-e6293e9fcea3	picture	openid-connect	oidc-usermodel-attribute-mapper	\N	85198f59-8318-434a-b4c9-d3baefe584b4
c424f07f-8e99-4d0d-ab04-df9a672910a8	website	openid-connect	oidc-usermodel-attribute-mapper	\N	85198f59-8318-434a-b4c9-d3baefe584b4
cff6fdfd-2b5d-41af-a3da-8096ca4bc5ec	gender	openid-connect	oidc-usermodel-attribute-mapper	\N	85198f59-8318-434a-b4c9-d3baefe584b4
aa9c0ac5-3a00-4b29-ae24-637cb9416a0e	birthdate	openid-connect	oidc-usermodel-attribute-mapper	\N	85198f59-8318-434a-b4c9-d3baefe584b4
73f22243-4791-4b45-9d00-095d3c42e209	zoneinfo	openid-connect	oidc-usermodel-attribute-mapper	\N	85198f59-8318-434a-b4c9-d3baefe584b4
fff2efc5-1f61-4cf3-bf27-9cb1b4ee3bcc	locale	openid-connect	oidc-usermodel-attribute-mapper	\N	85198f59-8318-434a-b4c9-d3baefe584b4
31e0adb8-72fd-4782-897f-2a1457a1d1c4	updated at	openid-connect	oidc-usermodel-attribute-mapper	\N	85198f59-8318-434a-b4c9-d3baefe584b4
ebb6929c-e6af-4a7c-a59c-3d4b150bb115	email	openid-connect	oidc-usermodel-attribute-mapper	\N	61f971fb-4c10-4fcd-9db4-733066c881cc
d20b7b6f-28b1-46d3-a836-a6c6e72c8fee	email verified	openid-connect	oidc-usermodel-property-mapper	\N	61f971fb-4c10-4fcd-9db4-733066c881cc
00bb769e-7550-4661-a824-ea9e04d6b21d	address	openid-connect	oidc-address-mapper	\N	4689d0df-5b1d-4608-97ce-bff901d53c77
c160fe01-2825-4193-89c1-87c01879109b	phone number	openid-connect	oidc-usermodel-attribute-mapper	\N	828b2f2f-5e4f-4e60-9e9c-df0b1872ac04
be50f097-9a60-4202-aac9-6b0fef5b0125	phone number verified	openid-connect	oidc-usermodel-attribute-mapper	\N	828b2f2f-5e4f-4e60-9e9c-df0b1872ac04
f01bd35d-fc48-4682-9a61-be0cd98ef0e2	realm roles	openid-connect	oidc-usermodel-realm-role-mapper	\N	68b53ac7-f20b-4377-b89d-8c41f4986984
3c107429-eee2-4525-82fe-a8137b1f8828	client roles	openid-connect	oidc-usermodel-client-role-mapper	\N	68b53ac7-f20b-4377-b89d-8c41f4986984
d94554f7-83fb-4faa-970a-72a06cf02467	audience resolve	openid-connect	oidc-audience-resolve-mapper	\N	68b53ac7-f20b-4377-b89d-8c41f4986984
581b286b-a197-4cf9-99d1-94e677a25e68	allowed web origins	openid-connect	oidc-allowed-origins-mapper	\N	ec27336a-b2a4-4d9c-8909-13b27dc0f28c
bf44993a-33a4-4d6d-9fb5-1b5a018f0426	upn	openid-connect	oidc-usermodel-attribute-mapper	\N	4497a478-ab89-4f70-8b7d-ae2e2b35796e
2643f432-c71f-4a88-b3eb-b931b0e4ed29	groups	openid-connect	oidc-usermodel-realm-role-mapper	\N	4497a478-ab89-4f70-8b7d-ae2e2b35796e
7c701ccc-dc2f-4b6f-8aa9-58572832c265	acr loa level	openid-connect	oidc-acr-mapper	\N	5f5c1d7b-9593-4e21-ac47-e3f50ac8d2e4
9050e751-200d-474e-9c7f-39b58f9ced62	auth_time	openid-connect	oidc-usersessionmodel-note-mapper	\N	1fb747c6-a776-4885-97d5-78b9a258d8cb
248539e0-2245-4d5a-b457-5a730b986154	sub	openid-connect	oidc-sub-mapper	\N	1fb747c6-a776-4885-97d5-78b9a258d8cb
10841947-b8a8-437d-8ba2-0ef2ca425f89	Client ID	openid-connect	oidc-usersessionmodel-note-mapper	\N	17183541-fd26-44aa-b4bd-6f99e80f1e16
ce61aa6a-de4d-4747-b6a9-3ced100fded9	Client Host	openid-connect	oidc-usersessionmodel-note-mapper	\N	17183541-fd26-44aa-b4bd-6f99e80f1e16
5258cab0-21de-4816-ac9c-ec51e6b232e4	Client IP Address	openid-connect	oidc-usersessionmodel-note-mapper	\N	17183541-fd26-44aa-b4bd-6f99e80f1e16
5867f194-c4d1-428a-b1b0-b2f9545107f5	organization	openid-connect	oidc-organization-membership-mapper	\N	09ab32c4-ac44-4f07-8405-fa3b30ccf887
1911bf1b-4cf5-42b2-bcae-a5a754019d0a	docker-v2-allow-all-mapper	docker-v2	docker-v2-allow-all-mapper	a7c21283-c174-4852-9ef6-a6d9f29c3ab9	\N
d542c327-8bc1-4d0e-bda0-6320980210e4	docker-v2-allow-all-mapper	docker-v2	docker-v2-allow-all-mapper	36a4d1a1-9c0d-42cc-bd41-c8970391cbdb	\N
1bc5ca4a-892c-4777-ac06-f3255e904b17	docker-v2-allow-all-mapper	docker-v2	docker-v2-allow-all-mapper	1321a953-5b99-4f7c-8fa1-f263c8d3408a	\N
b0aab8cc-750a-435f-9e16-39ebc81718be	audience resolve	openid-connect	oidc-audience-resolve-mapper	1321a953-5b99-4f7c-8fa1-f263c8d3408a	\N
acefa9b2-0028-47a3-8eed-88e361c3aab8	docker-v2-allow-all-mapper	docker-v2	docker-v2-allow-all-mapper	c4965edf-d53a-4211-bf6a-3ff49d604a4c	\N
e1444c97-3aa4-46fb-ad54-cf64272a349e	docker-v2-allow-all-mapper	docker-v2	docker-v2-allow-all-mapper	b3a7f90d-7ffa-42ec-8776-295a809d64c7	\N
34487804-d1ee-4f11-a6ab-88fe68f8cf4a	docker-v2-allow-all-mapper	docker-v2	docker-v2-allow-all-mapper	6b1eebe2-bc99-4242-8673-c7737ad3ea0e	\N
d23cc1ca-7dd0-4a53-b2ae-4d8171ce8c9e	role list	saml	saml-role-list-mapper	\N	11a4af65-6453-45e2-b43c-00317d2153c9
2a67d5ee-0217-4957-8ed5-d4c4a2417deb	organization	saml	saml-organization-membership-mapper	\N	13bd5f7d-4e62-40e0-8706-23402ab04ac7
b4c616a4-e72b-4afd-b807-670deba912a9	full name	openid-connect	oidc-full-name-mapper	\N	608f045b-0e6e-4c03-922f-09d24b347e54
b01f237e-fad0-430a-a975-79150bc17c79	family name	openid-connect	oidc-usermodel-attribute-mapper	\N	608f045b-0e6e-4c03-922f-09d24b347e54
c3d5fde8-4bad-49f6-803c-f40f30bce3cc	given name	openid-connect	oidc-usermodel-attribute-mapper	\N	608f045b-0e6e-4c03-922f-09d24b347e54
ee5cd677-8094-4dfc-b0e2-8f048f56a3ab	middle name	openid-connect	oidc-usermodel-attribute-mapper	\N	608f045b-0e6e-4c03-922f-09d24b347e54
3470f644-691a-416e-aec5-50ffd3ba046b	nickname	openid-connect	oidc-usermodel-attribute-mapper	\N	608f045b-0e6e-4c03-922f-09d24b347e54
9b74f176-2de0-4472-b4cf-46c3bc065e3e	username	openid-connect	oidc-usermodel-attribute-mapper	\N	608f045b-0e6e-4c03-922f-09d24b347e54
1ff6f5d4-06a8-44bf-9ef8-cb9dbf39acfe	profile	openid-connect	oidc-usermodel-attribute-mapper	\N	608f045b-0e6e-4c03-922f-09d24b347e54
888cab17-b166-4bf8-85de-24bf6a9524c4	picture	openid-connect	oidc-usermodel-attribute-mapper	\N	608f045b-0e6e-4c03-922f-09d24b347e54
bbb0cba0-ced6-4bee-b811-012bdf5ffe50	website	openid-connect	oidc-usermodel-attribute-mapper	\N	608f045b-0e6e-4c03-922f-09d24b347e54
e0b1761e-e81a-4383-bd3a-c8eabc02b04d	gender	openid-connect	oidc-usermodel-attribute-mapper	\N	608f045b-0e6e-4c03-922f-09d24b347e54
3d26cbb5-99f3-405f-a975-75979303e844	birthdate	openid-connect	oidc-usermodel-attribute-mapper	\N	608f045b-0e6e-4c03-922f-09d24b347e54
3e9c31cb-7281-46be-bfdc-8583732b0f91	zoneinfo	openid-connect	oidc-usermodel-attribute-mapper	\N	608f045b-0e6e-4c03-922f-09d24b347e54
5b757a94-a489-4e35-9553-e30fb0ea2329	locale	openid-connect	oidc-usermodel-attribute-mapper	\N	608f045b-0e6e-4c03-922f-09d24b347e54
c8427d5d-0581-4bca-bf67-f9a56d571f1d	updated at	openid-connect	oidc-usermodel-attribute-mapper	\N	608f045b-0e6e-4c03-922f-09d24b347e54
dd7dd3a1-138d-4079-9f99-414cd9d4b340	email	openid-connect	oidc-usermodel-attribute-mapper	\N	307c64d0-1eab-46ea-8609-79fed3819c63
63813085-a219-40c0-bed9-ad1fadfcad89	email verified	openid-connect	oidc-usermodel-property-mapper	\N	307c64d0-1eab-46ea-8609-79fed3819c63
7029476b-a62b-41de-b3c4-b80a170a7978	address	openid-connect	oidc-address-mapper	\N	2eee947b-c014-498b-b0b9-30f9837016b3
d7947272-307e-48c9-840b-5c938bb73403	phone number	openid-connect	oidc-usermodel-attribute-mapper	\N	f71fd363-2afb-465e-bcc3-988dab550c4e
a6cf8c46-3936-4967-9fc7-f436ac5d4651	phone number verified	openid-connect	oidc-usermodel-attribute-mapper	\N	f71fd363-2afb-465e-bcc3-988dab550c4e
1332b43f-acf3-4818-965d-7360000d7d3c	realm roles	openid-connect	oidc-usermodel-realm-role-mapper	\N	a4ffd0fa-fdde-4bbf-b010-a33f97bbea9b
a0dbcb62-8139-4788-9fc8-df7239ba65f2	client roles	openid-connect	oidc-usermodel-client-role-mapper	\N	a4ffd0fa-fdde-4bbf-b010-a33f97bbea9b
c47bca4f-e29f-476b-9b88-8a1558833342	audience resolve	openid-connect	oidc-audience-resolve-mapper	\N	a4ffd0fa-fdde-4bbf-b010-a33f97bbea9b
ee2d5275-213b-4835-833c-49fbd42693e5	allowed web origins	openid-connect	oidc-allowed-origins-mapper	\N	7b89a72a-18eb-40e6-894d-93e9b09c6397
bcdf7803-02f0-4206-82c5-9a50fb2600c1	upn	openid-connect	oidc-usermodel-attribute-mapper	\N	5705c761-1e66-4308-a8c9-f157a0c959db
e70c2528-2bda-4bd1-973b-58215c07ff9d	groups	openid-connect	oidc-usermodel-realm-role-mapper	\N	5705c761-1e66-4308-a8c9-f157a0c959db
73e71a5f-0e40-4572-97be-1a58a0b7c172	acr loa level	openid-connect	oidc-acr-mapper	\N	1b261132-0338-48f4-b182-f1ca8cd1d788
e73633e3-a12c-477c-94d5-60bbcdd990ff	auth_time	openid-connect	oidc-usersessionmodel-note-mapper	\N	e0fe63e3-4708-4949-a7f6-623bcd0fe950
8f354ddc-d02b-4712-a387-0ce7a61a42e7	sub	openid-connect	oidc-sub-mapper	\N	e0fe63e3-4708-4949-a7f6-623bcd0fe950
aa6bdc28-b367-43bb-8a44-1182cfac77a3	Client ID	openid-connect	oidc-usersessionmodel-note-mapper	\N	3c055df1-db4d-4498-9cbb-321d75d62b7c
5929eff5-78be-4298-a515-116cf8a75850	Client Host	openid-connect	oidc-usersessionmodel-note-mapper	\N	3c055df1-db4d-4498-9cbb-321d75d62b7c
415cb04a-e7af-4a0d-82cb-7781c88d8e49	Client IP Address	openid-connect	oidc-usersessionmodel-note-mapper	\N	3c055df1-db4d-4498-9cbb-321d75d62b7c
039558c4-1ab0-4b5c-a238-f9a64e19428d	organization	openid-connect	oidc-organization-membership-mapper	\N	f7f027c3-a693-42d5-b2dc-d3d7e4fa43e0
999b8e69-762c-41d5-a19c-8470a1e4e1b1	locale	openid-connect	oidc-usermodel-attribute-mapper	b3a7f90d-7ffa-42ec-8776-295a809d64c7	\N
\.


--
-- Data for Name: protocol_mapper_config; Type: TABLE DATA; Schema: public; Owner: valknar
--

COPY public.protocol_mapper_config (protocol_mapper_id, value, name) FROM stdin;
2b97a76b-32c7-4378-bce1-4b35b504ddf8	true	introspection.token.claim
2b97a76b-32c7-4378-bce1-4b35b504ddf8	true	userinfo.token.claim
2b97a76b-32c7-4378-bce1-4b35b504ddf8	locale	user.attribute
2b97a76b-32c7-4378-bce1-4b35b504ddf8	true	id.token.claim
2b97a76b-32c7-4378-bce1-4b35b504ddf8	true	access.token.claim
2b97a76b-32c7-4378-bce1-4b35b504ddf8	locale	claim.name
2b97a76b-32c7-4378-bce1-4b35b504ddf8	String	jsonType.label
6a12d45d-ac80-48f7-a4ac-7eb927bf905a	false	single
6a12d45d-ac80-48f7-a4ac-7eb927bf905a	Basic	attribute.nameformat
6a12d45d-ac80-48f7-a4ac-7eb927bf905a	Role	attribute.name
31e0adb8-72fd-4782-897f-2a1457a1d1c4	true	introspection.token.claim
31e0adb8-72fd-4782-897f-2a1457a1d1c4	true	userinfo.token.claim
31e0adb8-72fd-4782-897f-2a1457a1d1c4	updatedAt	user.attribute
31e0adb8-72fd-4782-897f-2a1457a1d1c4	true	id.token.claim
31e0adb8-72fd-4782-897f-2a1457a1d1c4	true	access.token.claim
31e0adb8-72fd-4782-897f-2a1457a1d1c4	updated_at	claim.name
31e0adb8-72fd-4782-897f-2a1457a1d1c4	long	jsonType.label
43d9d661-ef15-49a5-a693-281dd6a702f5	true	introspection.token.claim
43d9d661-ef15-49a5-a693-281dd6a702f5	true	userinfo.token.claim
43d9d661-ef15-49a5-a693-281dd6a702f5	true	id.token.claim
43d9d661-ef15-49a5-a693-281dd6a702f5	true	access.token.claim
520d40b9-d2a8-43c8-adbe-409bfe60913c	true	introspection.token.claim
520d40b9-d2a8-43c8-adbe-409bfe60913c	true	userinfo.token.claim
520d40b9-d2a8-43c8-adbe-409bfe60913c	nickname	user.attribute
520d40b9-d2a8-43c8-adbe-409bfe60913c	true	id.token.claim
520d40b9-d2a8-43c8-adbe-409bfe60913c	true	access.token.claim
520d40b9-d2a8-43c8-adbe-409bfe60913c	nickname	claim.name
520d40b9-d2a8-43c8-adbe-409bfe60913c	String	jsonType.label
6e8230ca-a752-4d54-a178-737f57c4616c	true	introspection.token.claim
6e8230ca-a752-4d54-a178-737f57c4616c	true	userinfo.token.claim
6e8230ca-a752-4d54-a178-737f57c4616c	lastName	user.attribute
6e8230ca-a752-4d54-a178-737f57c4616c	true	id.token.claim
6e8230ca-a752-4d54-a178-737f57c4616c	true	access.token.claim
6e8230ca-a752-4d54-a178-737f57c4616c	family_name	claim.name
6e8230ca-a752-4d54-a178-737f57c4616c	String	jsonType.label
73f22243-4791-4b45-9d00-095d3c42e209	true	introspection.token.claim
73f22243-4791-4b45-9d00-095d3c42e209	true	userinfo.token.claim
73f22243-4791-4b45-9d00-095d3c42e209	zoneinfo	user.attribute
73f22243-4791-4b45-9d00-095d3c42e209	true	id.token.claim
73f22243-4791-4b45-9d00-095d3c42e209	true	access.token.claim
73f22243-4791-4b45-9d00-095d3c42e209	zoneinfo	claim.name
73f22243-4791-4b45-9d00-095d3c42e209	String	jsonType.label
77236d33-dd31-41bf-9978-78247d571b29	true	introspection.token.claim
77236d33-dd31-41bf-9978-78247d571b29	true	userinfo.token.claim
77236d33-dd31-41bf-9978-78247d571b29	middleName	user.attribute
77236d33-dd31-41bf-9978-78247d571b29	true	id.token.claim
77236d33-dd31-41bf-9978-78247d571b29	true	access.token.claim
77236d33-dd31-41bf-9978-78247d571b29	middle_name	claim.name
77236d33-dd31-41bf-9978-78247d571b29	String	jsonType.label
97b531ea-d211-4268-93f3-b3ed773638a8	true	introspection.token.claim
97b531ea-d211-4268-93f3-b3ed773638a8	true	userinfo.token.claim
97b531ea-d211-4268-93f3-b3ed773638a8	username	user.attribute
97b531ea-d211-4268-93f3-b3ed773638a8	true	id.token.claim
97b531ea-d211-4268-93f3-b3ed773638a8	true	access.token.claim
97b531ea-d211-4268-93f3-b3ed773638a8	preferred_username	claim.name
97b531ea-d211-4268-93f3-b3ed773638a8	String	jsonType.label
a148b61a-ae12-4ded-bbd5-3f2692eee3cf	true	introspection.token.claim
a148b61a-ae12-4ded-bbd5-3f2692eee3cf	true	userinfo.token.claim
a148b61a-ae12-4ded-bbd5-3f2692eee3cf	profile	user.attribute
a148b61a-ae12-4ded-bbd5-3f2692eee3cf	true	id.token.claim
a148b61a-ae12-4ded-bbd5-3f2692eee3cf	true	access.token.claim
a148b61a-ae12-4ded-bbd5-3f2692eee3cf	profile	claim.name
a148b61a-ae12-4ded-bbd5-3f2692eee3cf	String	jsonType.label
aa9c0ac5-3a00-4b29-ae24-637cb9416a0e	true	introspection.token.claim
aa9c0ac5-3a00-4b29-ae24-637cb9416a0e	true	userinfo.token.claim
aa9c0ac5-3a00-4b29-ae24-637cb9416a0e	birthdate	user.attribute
aa9c0ac5-3a00-4b29-ae24-637cb9416a0e	true	id.token.claim
aa9c0ac5-3a00-4b29-ae24-637cb9416a0e	true	access.token.claim
aa9c0ac5-3a00-4b29-ae24-637cb9416a0e	birthdate	claim.name
aa9c0ac5-3a00-4b29-ae24-637cb9416a0e	String	jsonType.label
c1428d10-f545-4070-98ce-e6293e9fcea3	true	introspection.token.claim
c1428d10-f545-4070-98ce-e6293e9fcea3	true	userinfo.token.claim
c1428d10-f545-4070-98ce-e6293e9fcea3	picture	user.attribute
c1428d10-f545-4070-98ce-e6293e9fcea3	true	id.token.claim
c1428d10-f545-4070-98ce-e6293e9fcea3	true	access.token.claim
c1428d10-f545-4070-98ce-e6293e9fcea3	picture	claim.name
c1428d10-f545-4070-98ce-e6293e9fcea3	String	jsonType.label
c424f07f-8e99-4d0d-ab04-df9a672910a8	true	introspection.token.claim
c424f07f-8e99-4d0d-ab04-df9a672910a8	true	userinfo.token.claim
c424f07f-8e99-4d0d-ab04-df9a672910a8	website	user.attribute
c424f07f-8e99-4d0d-ab04-df9a672910a8	true	id.token.claim
c424f07f-8e99-4d0d-ab04-df9a672910a8	true	access.token.claim
c424f07f-8e99-4d0d-ab04-df9a672910a8	website	claim.name
c424f07f-8e99-4d0d-ab04-df9a672910a8	String	jsonType.label
cc9705a0-e33d-43b8-aeab-44b137f44aff	true	introspection.token.claim
cc9705a0-e33d-43b8-aeab-44b137f44aff	true	userinfo.token.claim
cc9705a0-e33d-43b8-aeab-44b137f44aff	firstName	user.attribute
cc9705a0-e33d-43b8-aeab-44b137f44aff	true	id.token.claim
cc9705a0-e33d-43b8-aeab-44b137f44aff	true	access.token.claim
cc9705a0-e33d-43b8-aeab-44b137f44aff	given_name	claim.name
cc9705a0-e33d-43b8-aeab-44b137f44aff	String	jsonType.label
cff6fdfd-2b5d-41af-a3da-8096ca4bc5ec	true	introspection.token.claim
cff6fdfd-2b5d-41af-a3da-8096ca4bc5ec	true	userinfo.token.claim
cff6fdfd-2b5d-41af-a3da-8096ca4bc5ec	gender	user.attribute
cff6fdfd-2b5d-41af-a3da-8096ca4bc5ec	true	id.token.claim
cff6fdfd-2b5d-41af-a3da-8096ca4bc5ec	true	access.token.claim
cff6fdfd-2b5d-41af-a3da-8096ca4bc5ec	gender	claim.name
cff6fdfd-2b5d-41af-a3da-8096ca4bc5ec	String	jsonType.label
fff2efc5-1f61-4cf3-bf27-9cb1b4ee3bcc	true	introspection.token.claim
fff2efc5-1f61-4cf3-bf27-9cb1b4ee3bcc	true	userinfo.token.claim
fff2efc5-1f61-4cf3-bf27-9cb1b4ee3bcc	locale	user.attribute
fff2efc5-1f61-4cf3-bf27-9cb1b4ee3bcc	true	id.token.claim
fff2efc5-1f61-4cf3-bf27-9cb1b4ee3bcc	true	access.token.claim
fff2efc5-1f61-4cf3-bf27-9cb1b4ee3bcc	locale	claim.name
fff2efc5-1f61-4cf3-bf27-9cb1b4ee3bcc	String	jsonType.label
d20b7b6f-28b1-46d3-a836-a6c6e72c8fee	true	introspection.token.claim
d20b7b6f-28b1-46d3-a836-a6c6e72c8fee	true	userinfo.token.claim
d20b7b6f-28b1-46d3-a836-a6c6e72c8fee	emailVerified	user.attribute
d20b7b6f-28b1-46d3-a836-a6c6e72c8fee	true	id.token.claim
d20b7b6f-28b1-46d3-a836-a6c6e72c8fee	true	access.token.claim
d20b7b6f-28b1-46d3-a836-a6c6e72c8fee	email_verified	claim.name
d20b7b6f-28b1-46d3-a836-a6c6e72c8fee	boolean	jsonType.label
ebb6929c-e6af-4a7c-a59c-3d4b150bb115	true	introspection.token.claim
ebb6929c-e6af-4a7c-a59c-3d4b150bb115	true	userinfo.token.claim
ebb6929c-e6af-4a7c-a59c-3d4b150bb115	email	user.attribute
ebb6929c-e6af-4a7c-a59c-3d4b150bb115	true	id.token.claim
ebb6929c-e6af-4a7c-a59c-3d4b150bb115	true	access.token.claim
ebb6929c-e6af-4a7c-a59c-3d4b150bb115	email	claim.name
ebb6929c-e6af-4a7c-a59c-3d4b150bb115	String	jsonType.label
00bb769e-7550-4661-a824-ea9e04d6b21d	formatted	user.attribute.formatted
00bb769e-7550-4661-a824-ea9e04d6b21d	country	user.attribute.country
00bb769e-7550-4661-a824-ea9e04d6b21d	true	introspection.token.claim
00bb769e-7550-4661-a824-ea9e04d6b21d	postal_code	user.attribute.postal_code
00bb769e-7550-4661-a824-ea9e04d6b21d	true	userinfo.token.claim
00bb769e-7550-4661-a824-ea9e04d6b21d	street	user.attribute.street
00bb769e-7550-4661-a824-ea9e04d6b21d	true	id.token.claim
00bb769e-7550-4661-a824-ea9e04d6b21d	region	user.attribute.region
00bb769e-7550-4661-a824-ea9e04d6b21d	true	access.token.claim
00bb769e-7550-4661-a824-ea9e04d6b21d	locality	user.attribute.locality
be50f097-9a60-4202-aac9-6b0fef5b0125	true	introspection.token.claim
be50f097-9a60-4202-aac9-6b0fef5b0125	true	userinfo.token.claim
be50f097-9a60-4202-aac9-6b0fef5b0125	phoneNumberVerified	user.attribute
be50f097-9a60-4202-aac9-6b0fef5b0125	true	id.token.claim
be50f097-9a60-4202-aac9-6b0fef5b0125	true	access.token.claim
be50f097-9a60-4202-aac9-6b0fef5b0125	phone_number_verified	claim.name
be50f097-9a60-4202-aac9-6b0fef5b0125	boolean	jsonType.label
c160fe01-2825-4193-89c1-87c01879109b	true	introspection.token.claim
c160fe01-2825-4193-89c1-87c01879109b	true	userinfo.token.claim
c160fe01-2825-4193-89c1-87c01879109b	phoneNumber	user.attribute
c160fe01-2825-4193-89c1-87c01879109b	true	id.token.claim
c160fe01-2825-4193-89c1-87c01879109b	true	access.token.claim
c160fe01-2825-4193-89c1-87c01879109b	phone_number	claim.name
c160fe01-2825-4193-89c1-87c01879109b	String	jsonType.label
3c107429-eee2-4525-82fe-a8137b1f8828	true	introspection.token.claim
3c107429-eee2-4525-82fe-a8137b1f8828	true	multivalued
3c107429-eee2-4525-82fe-a8137b1f8828	foo	user.attribute
3c107429-eee2-4525-82fe-a8137b1f8828	true	access.token.claim
3c107429-eee2-4525-82fe-a8137b1f8828	resource_access.${client_id}.roles	claim.name
3c107429-eee2-4525-82fe-a8137b1f8828	String	jsonType.label
d94554f7-83fb-4faa-970a-72a06cf02467	true	introspection.token.claim
d94554f7-83fb-4faa-970a-72a06cf02467	true	access.token.claim
f01bd35d-fc48-4682-9a61-be0cd98ef0e2	true	introspection.token.claim
f01bd35d-fc48-4682-9a61-be0cd98ef0e2	true	multivalued
f01bd35d-fc48-4682-9a61-be0cd98ef0e2	foo	user.attribute
f01bd35d-fc48-4682-9a61-be0cd98ef0e2	true	access.token.claim
f01bd35d-fc48-4682-9a61-be0cd98ef0e2	realm_access.roles	claim.name
f01bd35d-fc48-4682-9a61-be0cd98ef0e2	String	jsonType.label
581b286b-a197-4cf9-99d1-94e677a25e68	true	introspection.token.claim
581b286b-a197-4cf9-99d1-94e677a25e68	true	access.token.claim
2643f432-c71f-4a88-b3eb-b931b0e4ed29	true	introspection.token.claim
2643f432-c71f-4a88-b3eb-b931b0e4ed29	true	multivalued
2643f432-c71f-4a88-b3eb-b931b0e4ed29	foo	user.attribute
2643f432-c71f-4a88-b3eb-b931b0e4ed29	true	id.token.claim
2643f432-c71f-4a88-b3eb-b931b0e4ed29	true	access.token.claim
2643f432-c71f-4a88-b3eb-b931b0e4ed29	groups	claim.name
2643f432-c71f-4a88-b3eb-b931b0e4ed29	String	jsonType.label
bf44993a-33a4-4d6d-9fb5-1b5a018f0426	true	introspection.token.claim
bf44993a-33a4-4d6d-9fb5-1b5a018f0426	true	userinfo.token.claim
bf44993a-33a4-4d6d-9fb5-1b5a018f0426	username	user.attribute
bf44993a-33a4-4d6d-9fb5-1b5a018f0426	true	id.token.claim
bf44993a-33a4-4d6d-9fb5-1b5a018f0426	true	access.token.claim
bf44993a-33a4-4d6d-9fb5-1b5a018f0426	upn	claim.name
bf44993a-33a4-4d6d-9fb5-1b5a018f0426	String	jsonType.label
7c701ccc-dc2f-4b6f-8aa9-58572832c265	true	introspection.token.claim
7c701ccc-dc2f-4b6f-8aa9-58572832c265	true	id.token.claim
7c701ccc-dc2f-4b6f-8aa9-58572832c265	true	access.token.claim
248539e0-2245-4d5a-b457-5a730b986154	true	introspection.token.claim
248539e0-2245-4d5a-b457-5a730b986154	true	access.token.claim
9050e751-200d-474e-9c7f-39b58f9ced62	AUTH_TIME	user.session.note
9050e751-200d-474e-9c7f-39b58f9ced62	true	introspection.token.claim
9050e751-200d-474e-9c7f-39b58f9ced62	true	id.token.claim
9050e751-200d-474e-9c7f-39b58f9ced62	true	access.token.claim
9050e751-200d-474e-9c7f-39b58f9ced62	auth_time	claim.name
9050e751-200d-474e-9c7f-39b58f9ced62	long	jsonType.label
10841947-b8a8-437d-8ba2-0ef2ca425f89	client_id	user.session.note
10841947-b8a8-437d-8ba2-0ef2ca425f89	true	introspection.token.claim
10841947-b8a8-437d-8ba2-0ef2ca425f89	true	id.token.claim
10841947-b8a8-437d-8ba2-0ef2ca425f89	true	access.token.claim
10841947-b8a8-437d-8ba2-0ef2ca425f89	client_id	claim.name
10841947-b8a8-437d-8ba2-0ef2ca425f89	String	jsonType.label
5258cab0-21de-4816-ac9c-ec51e6b232e4	clientAddress	user.session.note
5258cab0-21de-4816-ac9c-ec51e6b232e4	true	introspection.token.claim
5258cab0-21de-4816-ac9c-ec51e6b232e4	true	id.token.claim
5258cab0-21de-4816-ac9c-ec51e6b232e4	true	access.token.claim
5258cab0-21de-4816-ac9c-ec51e6b232e4	clientAddress	claim.name
5258cab0-21de-4816-ac9c-ec51e6b232e4	String	jsonType.label
ce61aa6a-de4d-4747-b6a9-3ced100fded9	clientHost	user.session.note
ce61aa6a-de4d-4747-b6a9-3ced100fded9	true	introspection.token.claim
ce61aa6a-de4d-4747-b6a9-3ced100fded9	true	id.token.claim
ce61aa6a-de4d-4747-b6a9-3ced100fded9	true	access.token.claim
ce61aa6a-de4d-4747-b6a9-3ced100fded9	clientHost	claim.name
ce61aa6a-de4d-4747-b6a9-3ced100fded9	String	jsonType.label
5867f194-c4d1-428a-b1b0-b2f9545107f5	true	introspection.token.claim
5867f194-c4d1-428a-b1b0-b2f9545107f5	true	multivalued
5867f194-c4d1-428a-b1b0-b2f9545107f5	true	id.token.claim
5867f194-c4d1-428a-b1b0-b2f9545107f5	true	access.token.claim
5867f194-c4d1-428a-b1b0-b2f9545107f5	organization	claim.name
5867f194-c4d1-428a-b1b0-b2f9545107f5	String	jsonType.label
d23cc1ca-7dd0-4a53-b2ae-4d8171ce8c9e	false	single
d23cc1ca-7dd0-4a53-b2ae-4d8171ce8c9e	Basic	attribute.nameformat
d23cc1ca-7dd0-4a53-b2ae-4d8171ce8c9e	Role	attribute.name
1ff6f5d4-06a8-44bf-9ef8-cb9dbf39acfe	true	introspection.token.claim
1ff6f5d4-06a8-44bf-9ef8-cb9dbf39acfe	true	userinfo.token.claim
1ff6f5d4-06a8-44bf-9ef8-cb9dbf39acfe	profile	user.attribute
1ff6f5d4-06a8-44bf-9ef8-cb9dbf39acfe	true	id.token.claim
1ff6f5d4-06a8-44bf-9ef8-cb9dbf39acfe	true	access.token.claim
1ff6f5d4-06a8-44bf-9ef8-cb9dbf39acfe	profile	claim.name
1ff6f5d4-06a8-44bf-9ef8-cb9dbf39acfe	String	jsonType.label
3470f644-691a-416e-aec5-50ffd3ba046b	true	introspection.token.claim
3470f644-691a-416e-aec5-50ffd3ba046b	true	userinfo.token.claim
3470f644-691a-416e-aec5-50ffd3ba046b	nickname	user.attribute
3470f644-691a-416e-aec5-50ffd3ba046b	true	id.token.claim
3470f644-691a-416e-aec5-50ffd3ba046b	true	access.token.claim
3470f644-691a-416e-aec5-50ffd3ba046b	nickname	claim.name
3470f644-691a-416e-aec5-50ffd3ba046b	String	jsonType.label
3d26cbb5-99f3-405f-a975-75979303e844	true	introspection.token.claim
3d26cbb5-99f3-405f-a975-75979303e844	true	userinfo.token.claim
3d26cbb5-99f3-405f-a975-75979303e844	birthdate	user.attribute
3d26cbb5-99f3-405f-a975-75979303e844	true	id.token.claim
3d26cbb5-99f3-405f-a975-75979303e844	true	access.token.claim
3d26cbb5-99f3-405f-a975-75979303e844	birthdate	claim.name
3d26cbb5-99f3-405f-a975-75979303e844	String	jsonType.label
3e9c31cb-7281-46be-bfdc-8583732b0f91	true	introspection.token.claim
3e9c31cb-7281-46be-bfdc-8583732b0f91	true	userinfo.token.claim
3e9c31cb-7281-46be-bfdc-8583732b0f91	zoneinfo	user.attribute
3e9c31cb-7281-46be-bfdc-8583732b0f91	true	id.token.claim
3e9c31cb-7281-46be-bfdc-8583732b0f91	true	access.token.claim
3e9c31cb-7281-46be-bfdc-8583732b0f91	zoneinfo	claim.name
3e9c31cb-7281-46be-bfdc-8583732b0f91	String	jsonType.label
5b757a94-a489-4e35-9553-e30fb0ea2329	true	introspection.token.claim
5b757a94-a489-4e35-9553-e30fb0ea2329	true	userinfo.token.claim
5b757a94-a489-4e35-9553-e30fb0ea2329	locale	user.attribute
5b757a94-a489-4e35-9553-e30fb0ea2329	true	id.token.claim
5b757a94-a489-4e35-9553-e30fb0ea2329	true	access.token.claim
5b757a94-a489-4e35-9553-e30fb0ea2329	locale	claim.name
5b757a94-a489-4e35-9553-e30fb0ea2329	String	jsonType.label
888cab17-b166-4bf8-85de-24bf6a9524c4	true	introspection.token.claim
888cab17-b166-4bf8-85de-24bf6a9524c4	true	userinfo.token.claim
888cab17-b166-4bf8-85de-24bf6a9524c4	picture	user.attribute
888cab17-b166-4bf8-85de-24bf6a9524c4	true	id.token.claim
888cab17-b166-4bf8-85de-24bf6a9524c4	true	access.token.claim
888cab17-b166-4bf8-85de-24bf6a9524c4	picture	claim.name
888cab17-b166-4bf8-85de-24bf6a9524c4	String	jsonType.label
9b74f176-2de0-4472-b4cf-46c3bc065e3e	true	introspection.token.claim
9b74f176-2de0-4472-b4cf-46c3bc065e3e	true	userinfo.token.claim
9b74f176-2de0-4472-b4cf-46c3bc065e3e	username	user.attribute
9b74f176-2de0-4472-b4cf-46c3bc065e3e	true	id.token.claim
9b74f176-2de0-4472-b4cf-46c3bc065e3e	true	access.token.claim
9b74f176-2de0-4472-b4cf-46c3bc065e3e	preferred_username	claim.name
9b74f176-2de0-4472-b4cf-46c3bc065e3e	String	jsonType.label
b01f237e-fad0-430a-a975-79150bc17c79	true	introspection.token.claim
b01f237e-fad0-430a-a975-79150bc17c79	true	userinfo.token.claim
b01f237e-fad0-430a-a975-79150bc17c79	lastName	user.attribute
b01f237e-fad0-430a-a975-79150bc17c79	true	id.token.claim
b01f237e-fad0-430a-a975-79150bc17c79	true	access.token.claim
b01f237e-fad0-430a-a975-79150bc17c79	family_name	claim.name
b01f237e-fad0-430a-a975-79150bc17c79	String	jsonType.label
b4c616a4-e72b-4afd-b807-670deba912a9	true	introspection.token.claim
b4c616a4-e72b-4afd-b807-670deba912a9	true	userinfo.token.claim
b4c616a4-e72b-4afd-b807-670deba912a9	true	id.token.claim
b4c616a4-e72b-4afd-b807-670deba912a9	true	access.token.claim
bbb0cba0-ced6-4bee-b811-012bdf5ffe50	true	introspection.token.claim
bbb0cba0-ced6-4bee-b811-012bdf5ffe50	true	userinfo.token.claim
bbb0cba0-ced6-4bee-b811-012bdf5ffe50	website	user.attribute
bbb0cba0-ced6-4bee-b811-012bdf5ffe50	true	id.token.claim
bbb0cba0-ced6-4bee-b811-012bdf5ffe50	true	access.token.claim
bbb0cba0-ced6-4bee-b811-012bdf5ffe50	website	claim.name
bbb0cba0-ced6-4bee-b811-012bdf5ffe50	String	jsonType.label
c3d5fde8-4bad-49f6-803c-f40f30bce3cc	true	introspection.token.claim
c3d5fde8-4bad-49f6-803c-f40f30bce3cc	true	userinfo.token.claim
c3d5fde8-4bad-49f6-803c-f40f30bce3cc	firstName	user.attribute
c3d5fde8-4bad-49f6-803c-f40f30bce3cc	true	id.token.claim
c3d5fde8-4bad-49f6-803c-f40f30bce3cc	true	access.token.claim
c3d5fde8-4bad-49f6-803c-f40f30bce3cc	given_name	claim.name
c3d5fde8-4bad-49f6-803c-f40f30bce3cc	String	jsonType.label
c8427d5d-0581-4bca-bf67-f9a56d571f1d	true	introspection.token.claim
c8427d5d-0581-4bca-bf67-f9a56d571f1d	true	userinfo.token.claim
c8427d5d-0581-4bca-bf67-f9a56d571f1d	updatedAt	user.attribute
c8427d5d-0581-4bca-bf67-f9a56d571f1d	true	id.token.claim
c8427d5d-0581-4bca-bf67-f9a56d571f1d	true	access.token.claim
c8427d5d-0581-4bca-bf67-f9a56d571f1d	updated_at	claim.name
c8427d5d-0581-4bca-bf67-f9a56d571f1d	long	jsonType.label
e0b1761e-e81a-4383-bd3a-c8eabc02b04d	true	introspection.token.claim
e0b1761e-e81a-4383-bd3a-c8eabc02b04d	true	userinfo.token.claim
e0b1761e-e81a-4383-bd3a-c8eabc02b04d	gender	user.attribute
e0b1761e-e81a-4383-bd3a-c8eabc02b04d	true	id.token.claim
e0b1761e-e81a-4383-bd3a-c8eabc02b04d	true	access.token.claim
e0b1761e-e81a-4383-bd3a-c8eabc02b04d	gender	claim.name
e0b1761e-e81a-4383-bd3a-c8eabc02b04d	String	jsonType.label
ee5cd677-8094-4dfc-b0e2-8f048f56a3ab	true	introspection.token.claim
ee5cd677-8094-4dfc-b0e2-8f048f56a3ab	true	userinfo.token.claim
ee5cd677-8094-4dfc-b0e2-8f048f56a3ab	middleName	user.attribute
ee5cd677-8094-4dfc-b0e2-8f048f56a3ab	true	id.token.claim
ee5cd677-8094-4dfc-b0e2-8f048f56a3ab	true	access.token.claim
ee5cd677-8094-4dfc-b0e2-8f048f56a3ab	middle_name	claim.name
ee5cd677-8094-4dfc-b0e2-8f048f56a3ab	String	jsonType.label
63813085-a219-40c0-bed9-ad1fadfcad89	true	introspection.token.claim
63813085-a219-40c0-bed9-ad1fadfcad89	true	userinfo.token.claim
63813085-a219-40c0-bed9-ad1fadfcad89	emailVerified	user.attribute
63813085-a219-40c0-bed9-ad1fadfcad89	true	id.token.claim
63813085-a219-40c0-bed9-ad1fadfcad89	true	access.token.claim
63813085-a219-40c0-bed9-ad1fadfcad89	email_verified	claim.name
63813085-a219-40c0-bed9-ad1fadfcad89	boolean	jsonType.label
dd7dd3a1-138d-4079-9f99-414cd9d4b340	true	introspection.token.claim
dd7dd3a1-138d-4079-9f99-414cd9d4b340	true	userinfo.token.claim
dd7dd3a1-138d-4079-9f99-414cd9d4b340	email	user.attribute
dd7dd3a1-138d-4079-9f99-414cd9d4b340	true	id.token.claim
dd7dd3a1-138d-4079-9f99-414cd9d4b340	true	access.token.claim
dd7dd3a1-138d-4079-9f99-414cd9d4b340	email	claim.name
dd7dd3a1-138d-4079-9f99-414cd9d4b340	String	jsonType.label
7029476b-a62b-41de-b3c4-b80a170a7978	formatted	user.attribute.formatted
7029476b-a62b-41de-b3c4-b80a170a7978	country	user.attribute.country
7029476b-a62b-41de-b3c4-b80a170a7978	true	introspection.token.claim
7029476b-a62b-41de-b3c4-b80a170a7978	postal_code	user.attribute.postal_code
7029476b-a62b-41de-b3c4-b80a170a7978	true	userinfo.token.claim
7029476b-a62b-41de-b3c4-b80a170a7978	street	user.attribute.street
7029476b-a62b-41de-b3c4-b80a170a7978	true	id.token.claim
7029476b-a62b-41de-b3c4-b80a170a7978	region	user.attribute.region
7029476b-a62b-41de-b3c4-b80a170a7978	true	access.token.claim
7029476b-a62b-41de-b3c4-b80a170a7978	locality	user.attribute.locality
a6cf8c46-3936-4967-9fc7-f436ac5d4651	true	introspection.token.claim
a6cf8c46-3936-4967-9fc7-f436ac5d4651	true	userinfo.token.claim
a6cf8c46-3936-4967-9fc7-f436ac5d4651	phoneNumberVerified	user.attribute
a6cf8c46-3936-4967-9fc7-f436ac5d4651	true	id.token.claim
a6cf8c46-3936-4967-9fc7-f436ac5d4651	true	access.token.claim
a6cf8c46-3936-4967-9fc7-f436ac5d4651	phone_number_verified	claim.name
a6cf8c46-3936-4967-9fc7-f436ac5d4651	boolean	jsonType.label
d7947272-307e-48c9-840b-5c938bb73403	true	introspection.token.claim
d7947272-307e-48c9-840b-5c938bb73403	true	userinfo.token.claim
d7947272-307e-48c9-840b-5c938bb73403	phoneNumber	user.attribute
d7947272-307e-48c9-840b-5c938bb73403	true	id.token.claim
d7947272-307e-48c9-840b-5c938bb73403	true	access.token.claim
d7947272-307e-48c9-840b-5c938bb73403	phone_number	claim.name
d7947272-307e-48c9-840b-5c938bb73403	String	jsonType.label
1332b43f-acf3-4818-965d-7360000d7d3c	true	introspection.token.claim
1332b43f-acf3-4818-965d-7360000d7d3c	true	multivalued
1332b43f-acf3-4818-965d-7360000d7d3c	foo	user.attribute
1332b43f-acf3-4818-965d-7360000d7d3c	true	access.token.claim
1332b43f-acf3-4818-965d-7360000d7d3c	realm_access.roles	claim.name
1332b43f-acf3-4818-965d-7360000d7d3c	String	jsonType.label
a0dbcb62-8139-4788-9fc8-df7239ba65f2	true	introspection.token.claim
a0dbcb62-8139-4788-9fc8-df7239ba65f2	true	multivalued
a0dbcb62-8139-4788-9fc8-df7239ba65f2	foo	user.attribute
a0dbcb62-8139-4788-9fc8-df7239ba65f2	true	access.token.claim
a0dbcb62-8139-4788-9fc8-df7239ba65f2	resource_access.${client_id}.roles	claim.name
a0dbcb62-8139-4788-9fc8-df7239ba65f2	String	jsonType.label
c47bca4f-e29f-476b-9b88-8a1558833342	true	introspection.token.claim
c47bca4f-e29f-476b-9b88-8a1558833342	true	access.token.claim
ee2d5275-213b-4835-833c-49fbd42693e5	true	introspection.token.claim
ee2d5275-213b-4835-833c-49fbd42693e5	true	access.token.claim
bcdf7803-02f0-4206-82c5-9a50fb2600c1	true	introspection.token.claim
bcdf7803-02f0-4206-82c5-9a50fb2600c1	true	userinfo.token.claim
bcdf7803-02f0-4206-82c5-9a50fb2600c1	username	user.attribute
bcdf7803-02f0-4206-82c5-9a50fb2600c1	true	id.token.claim
bcdf7803-02f0-4206-82c5-9a50fb2600c1	true	access.token.claim
bcdf7803-02f0-4206-82c5-9a50fb2600c1	upn	claim.name
bcdf7803-02f0-4206-82c5-9a50fb2600c1	String	jsonType.label
e70c2528-2bda-4bd1-973b-58215c07ff9d	true	introspection.token.claim
e70c2528-2bda-4bd1-973b-58215c07ff9d	true	multivalued
e70c2528-2bda-4bd1-973b-58215c07ff9d	foo	user.attribute
e70c2528-2bda-4bd1-973b-58215c07ff9d	true	id.token.claim
e70c2528-2bda-4bd1-973b-58215c07ff9d	true	access.token.claim
e70c2528-2bda-4bd1-973b-58215c07ff9d	groups	claim.name
e70c2528-2bda-4bd1-973b-58215c07ff9d	String	jsonType.label
73e71a5f-0e40-4572-97be-1a58a0b7c172	true	introspection.token.claim
73e71a5f-0e40-4572-97be-1a58a0b7c172	true	id.token.claim
73e71a5f-0e40-4572-97be-1a58a0b7c172	true	access.token.claim
8f354ddc-d02b-4712-a387-0ce7a61a42e7	true	introspection.token.claim
8f354ddc-d02b-4712-a387-0ce7a61a42e7	true	access.token.claim
e73633e3-a12c-477c-94d5-60bbcdd990ff	AUTH_TIME	user.session.note
e73633e3-a12c-477c-94d5-60bbcdd990ff	true	introspection.token.claim
e73633e3-a12c-477c-94d5-60bbcdd990ff	true	id.token.claim
e73633e3-a12c-477c-94d5-60bbcdd990ff	true	access.token.claim
e73633e3-a12c-477c-94d5-60bbcdd990ff	auth_time	claim.name
e73633e3-a12c-477c-94d5-60bbcdd990ff	long	jsonType.label
415cb04a-e7af-4a0d-82cb-7781c88d8e49	clientAddress	user.session.note
415cb04a-e7af-4a0d-82cb-7781c88d8e49	true	introspection.token.claim
415cb04a-e7af-4a0d-82cb-7781c88d8e49	true	id.token.claim
415cb04a-e7af-4a0d-82cb-7781c88d8e49	true	access.token.claim
415cb04a-e7af-4a0d-82cb-7781c88d8e49	clientAddress	claim.name
415cb04a-e7af-4a0d-82cb-7781c88d8e49	String	jsonType.label
5929eff5-78be-4298-a515-116cf8a75850	clientHost	user.session.note
5929eff5-78be-4298-a515-116cf8a75850	true	introspection.token.claim
5929eff5-78be-4298-a515-116cf8a75850	true	id.token.claim
5929eff5-78be-4298-a515-116cf8a75850	true	access.token.claim
5929eff5-78be-4298-a515-116cf8a75850	clientHost	claim.name
5929eff5-78be-4298-a515-116cf8a75850	String	jsonType.label
aa6bdc28-b367-43bb-8a44-1182cfac77a3	client_id	user.session.note
aa6bdc28-b367-43bb-8a44-1182cfac77a3	true	introspection.token.claim
aa6bdc28-b367-43bb-8a44-1182cfac77a3	true	id.token.claim
aa6bdc28-b367-43bb-8a44-1182cfac77a3	true	access.token.claim
aa6bdc28-b367-43bb-8a44-1182cfac77a3	client_id	claim.name
aa6bdc28-b367-43bb-8a44-1182cfac77a3	String	jsonType.label
039558c4-1ab0-4b5c-a238-f9a64e19428d	true	introspection.token.claim
039558c4-1ab0-4b5c-a238-f9a64e19428d	true	multivalued
039558c4-1ab0-4b5c-a238-f9a64e19428d	true	id.token.claim
039558c4-1ab0-4b5c-a238-f9a64e19428d	true	access.token.claim
039558c4-1ab0-4b5c-a238-f9a64e19428d	organization	claim.name
039558c4-1ab0-4b5c-a238-f9a64e19428d	String	jsonType.label
999b8e69-762c-41d5-a19c-8470a1e4e1b1	true	introspection.token.claim
999b8e69-762c-41d5-a19c-8470a1e4e1b1	true	userinfo.token.claim
999b8e69-762c-41d5-a19c-8470a1e4e1b1	locale	user.attribute
999b8e69-762c-41d5-a19c-8470a1e4e1b1	true	id.token.claim
999b8e69-762c-41d5-a19c-8470a1e4e1b1	true	access.token.claim
999b8e69-762c-41d5-a19c-8470a1e4e1b1	locale	claim.name
999b8e69-762c-41d5-a19c-8470a1e4e1b1	String	jsonType.label
\.


--
-- Data for Name: realm; Type: TABLE DATA; Schema: public; Owner: valknar
--

COPY public.realm (id, access_code_lifespan, user_action_lifespan, access_token_lifespan, account_theme, admin_theme, email_theme, enabled, events_enabled, events_expiration, login_theme, name, not_before, password_policy, registration_allowed, remember_me, reset_password_allowed, social, ssl_required, sso_idle_timeout, sso_max_lifespan, update_profile_on_soc_login, verify_email, master_admin_client, login_lifespan, internationalization_enabled, default_locale, reg_email_as_username, admin_events_enabled, admin_events_details_enabled, edit_username_allowed, otp_policy_counter, otp_policy_window, otp_policy_period, otp_policy_digits, otp_policy_alg, otp_policy_type, browser_flow, registration_flow, direct_grant_flow, reset_credentials_flow, client_auth_flow, offline_session_idle_timeout, revoke_refresh_token, access_token_life_implicit, login_with_email_allowed, duplicate_emails_allowed, docker_auth_flow, refresh_token_max_reuse, allow_user_managed_access, sso_max_lifespan_remember_me, sso_idle_timeout_remember_me, default_role) FROM stdin;
460a8e4b-5528-439c-ae10-29c984c7e8f5	60	300	300	\N	\N	\N	t	f	0	\N	pivoine.art	0	\N	f	f	f	f	EXTERNAL	1800	36000	f	f	0333da14-7d08-4ea6-a808-2aaa7d3411f3	1800	f	\N	f	f	f	f	0	1	30	6	HmacSHA1	totp	2e8d9ca2-b141-486e-9526-66ab9f319c55	ce2ae5e6-af09-4248-9a5a-7394b862888c	cda6e8d0-e4b9-4dc2-85db-e800283bcc57	82c2a7d3-de01-4329-a04d-4adc75754523	3ae459b1-c80d-45ab-823c-f0af87b8a86b	2592000	f	900	t	f	5e435919-6dbd-45ad-ac50-86befa2e48d8	0	f	0	0	8a361c62-09d4-44f2-828b-be78e38e8966
8ae4cef1-1f2a-403a-b938-dd85e52895b8	60	300	60	\N	\N	\N	t	f	0	\N	master	0	\N	f	f	f	f	EXTERNAL	1800	36000	f	f	2ba16542-30d0-449e-aca5-25498bcbbaf0	1800	f	\N	f	f	f	f	0	1	30	6	HmacSHA1	totp	1c97c671-26bf-4449-9528-b9fd25aa754c	98626a81-f977-4e16-9bff-0d55a8d7720b	5ae4f742-7c58-4be2-9939-543ba9bd283c	9ad95dc3-2e49-483f-8994-41c47899c63c	decb04b4-e101-4695-a9f6-6fee96e74b95	2592000	f	900	t	f	8cf5860b-52ca-4e22-a464-5b42ed97c657	0	f	0	0	54fe2c16-b141-4a22-b5ef-d24d35a38ccc
\.


--
-- Data for Name: realm_attribute; Type: TABLE DATA; Schema: public; Owner: valknar
--

COPY public.realm_attribute (name, realm_id, value) FROM stdin;
_browser_header.contentSecurityPolicyReportOnly	8ae4cef1-1f2a-403a-b938-dd85e52895b8	
_browser_header.xContentTypeOptions	8ae4cef1-1f2a-403a-b938-dd85e52895b8	nosniff
_browser_header.referrerPolicy	8ae4cef1-1f2a-403a-b938-dd85e52895b8	no-referrer
_browser_header.xRobotsTag	8ae4cef1-1f2a-403a-b938-dd85e52895b8	none
_browser_header.xFrameOptions	8ae4cef1-1f2a-403a-b938-dd85e52895b8	SAMEORIGIN
_browser_header.contentSecurityPolicy	8ae4cef1-1f2a-403a-b938-dd85e52895b8	frame-src 'self'; frame-ancestors 'self'; object-src 'none';
_browser_header.strictTransportSecurity	8ae4cef1-1f2a-403a-b938-dd85e52895b8	max-age=31536000; includeSubDomains
bruteForceProtected	8ae4cef1-1f2a-403a-b938-dd85e52895b8	false
permanentLockout	8ae4cef1-1f2a-403a-b938-dd85e52895b8	false
maxTemporaryLockouts	8ae4cef1-1f2a-403a-b938-dd85e52895b8	0
bruteForceStrategy	8ae4cef1-1f2a-403a-b938-dd85e52895b8	MULTIPLE
maxFailureWaitSeconds	8ae4cef1-1f2a-403a-b938-dd85e52895b8	900
minimumQuickLoginWaitSeconds	8ae4cef1-1f2a-403a-b938-dd85e52895b8	60
waitIncrementSeconds	8ae4cef1-1f2a-403a-b938-dd85e52895b8	60
quickLoginCheckMilliSeconds	8ae4cef1-1f2a-403a-b938-dd85e52895b8	1000
maxDeltaTimeSeconds	8ae4cef1-1f2a-403a-b938-dd85e52895b8	43200
failureFactor	8ae4cef1-1f2a-403a-b938-dd85e52895b8	30
realmReusableOtpCode	8ae4cef1-1f2a-403a-b938-dd85e52895b8	false
firstBrokerLoginFlowId	8ae4cef1-1f2a-403a-b938-dd85e52895b8	5ae02b08-ea69-4577-8cd4-4c7ec491bdeb
displayName	8ae4cef1-1f2a-403a-b938-dd85e52895b8	Keycloak
displayNameHtml	8ae4cef1-1f2a-403a-b938-dd85e52895b8	<div class="kc-logo-text"><span>Keycloak</span></div>
defaultSignatureAlgorithm	8ae4cef1-1f2a-403a-b938-dd85e52895b8	RS256
offlineSessionMaxLifespanEnabled	8ae4cef1-1f2a-403a-b938-dd85e52895b8	false
offlineSessionMaxLifespan	8ae4cef1-1f2a-403a-b938-dd85e52895b8	5184000
_browser_header.contentSecurityPolicyReportOnly	460a8e4b-5528-439c-ae10-29c984c7e8f5	
_browser_header.xContentTypeOptions	460a8e4b-5528-439c-ae10-29c984c7e8f5	nosniff
_browser_header.referrerPolicy	460a8e4b-5528-439c-ae10-29c984c7e8f5	no-referrer
_browser_header.xRobotsTag	460a8e4b-5528-439c-ae10-29c984c7e8f5	none
_browser_header.xFrameOptions	460a8e4b-5528-439c-ae10-29c984c7e8f5	SAMEORIGIN
_browser_header.contentSecurityPolicy	460a8e4b-5528-439c-ae10-29c984c7e8f5	frame-src 'self'; frame-ancestors 'self'; object-src 'none';
_browser_header.strictTransportSecurity	460a8e4b-5528-439c-ae10-29c984c7e8f5	max-age=31536000; includeSubDomains
bruteForceProtected	460a8e4b-5528-439c-ae10-29c984c7e8f5	false
permanentLockout	460a8e4b-5528-439c-ae10-29c984c7e8f5	false
maxTemporaryLockouts	460a8e4b-5528-439c-ae10-29c984c7e8f5	0
bruteForceStrategy	460a8e4b-5528-439c-ae10-29c984c7e8f5	MULTIPLE
maxFailureWaitSeconds	460a8e4b-5528-439c-ae10-29c984c7e8f5	900
minimumQuickLoginWaitSeconds	460a8e4b-5528-439c-ae10-29c984c7e8f5	60
waitIncrementSeconds	460a8e4b-5528-439c-ae10-29c984c7e8f5	60
quickLoginCheckMilliSeconds	460a8e4b-5528-439c-ae10-29c984c7e8f5	1000
maxDeltaTimeSeconds	460a8e4b-5528-439c-ae10-29c984c7e8f5	43200
failureFactor	460a8e4b-5528-439c-ae10-29c984c7e8f5	30
realmReusableOtpCode	460a8e4b-5528-439c-ae10-29c984c7e8f5	false
defaultSignatureAlgorithm	460a8e4b-5528-439c-ae10-29c984c7e8f5	RS256
offlineSessionMaxLifespanEnabled	460a8e4b-5528-439c-ae10-29c984c7e8f5	false
offlineSessionMaxLifespan	460a8e4b-5528-439c-ae10-29c984c7e8f5	5184000
actionTokenGeneratedByAdminLifespan	460a8e4b-5528-439c-ae10-29c984c7e8f5	43200
actionTokenGeneratedByUserLifespan	460a8e4b-5528-439c-ae10-29c984c7e8f5	300
oauth2DeviceCodeLifespan	460a8e4b-5528-439c-ae10-29c984c7e8f5	600
oauth2DevicePollingInterval	460a8e4b-5528-439c-ae10-29c984c7e8f5	5
webAuthnPolicyRpEntityName	460a8e4b-5528-439c-ae10-29c984c7e8f5	keycloak
webAuthnPolicySignatureAlgorithms	460a8e4b-5528-439c-ae10-29c984c7e8f5	ES256,RS256
webAuthnPolicyRpId	460a8e4b-5528-439c-ae10-29c984c7e8f5	
webAuthnPolicyAttestationConveyancePreference	460a8e4b-5528-439c-ae10-29c984c7e8f5	not specified
webAuthnPolicyAuthenticatorAttachment	460a8e4b-5528-439c-ae10-29c984c7e8f5	not specified
webAuthnPolicyRequireResidentKey	460a8e4b-5528-439c-ae10-29c984c7e8f5	not specified
webAuthnPolicyUserVerificationRequirement	460a8e4b-5528-439c-ae10-29c984c7e8f5	not specified
webAuthnPolicyCreateTimeout	460a8e4b-5528-439c-ae10-29c984c7e8f5	0
webAuthnPolicyAvoidSameAuthenticatorRegister	460a8e4b-5528-439c-ae10-29c984c7e8f5	false
webAuthnPolicyRpEntityNamePasswordless	460a8e4b-5528-439c-ae10-29c984c7e8f5	keycloak
webAuthnPolicySignatureAlgorithmsPasswordless	460a8e4b-5528-439c-ae10-29c984c7e8f5	ES256,RS256
webAuthnPolicyRpIdPasswordless	460a8e4b-5528-439c-ae10-29c984c7e8f5	
webAuthnPolicyAttestationConveyancePreferencePasswordless	460a8e4b-5528-439c-ae10-29c984c7e8f5	not specified
webAuthnPolicyAuthenticatorAttachmentPasswordless	460a8e4b-5528-439c-ae10-29c984c7e8f5	not specified
webAuthnPolicyRequireResidentKeyPasswordless	460a8e4b-5528-439c-ae10-29c984c7e8f5	Yes
webAuthnPolicyUserVerificationRequirementPasswordless	460a8e4b-5528-439c-ae10-29c984c7e8f5	required
webAuthnPolicyCreateTimeoutPasswordless	460a8e4b-5528-439c-ae10-29c984c7e8f5	0
webAuthnPolicyAvoidSameAuthenticatorRegisterPasswordless	460a8e4b-5528-439c-ae10-29c984c7e8f5	false
cibaBackchannelTokenDeliveryMode	460a8e4b-5528-439c-ae10-29c984c7e8f5	poll
cibaExpiresIn	460a8e4b-5528-439c-ae10-29c984c7e8f5	120
cibaInterval	460a8e4b-5528-439c-ae10-29c984c7e8f5	5
cibaAuthRequestedUserHint	460a8e4b-5528-439c-ae10-29c984c7e8f5	login_hint
parRequestUriLifespan	460a8e4b-5528-439c-ae10-29c984c7e8f5	60
firstBrokerLoginFlowId	460a8e4b-5528-439c-ae10-29c984c7e8f5	446b3bf0-4a92-493e-bcab-5abb61382765
\.


--
-- Data for Name: realm_default_groups; Type: TABLE DATA; Schema: public; Owner: valknar
--

COPY public.realm_default_groups (realm_id, group_id) FROM stdin;
\.


--
-- Data for Name: realm_enabled_event_types; Type: TABLE DATA; Schema: public; Owner: valknar
--

COPY public.realm_enabled_event_types (realm_id, value) FROM stdin;
\.


--
-- Data for Name: realm_events_listeners; Type: TABLE DATA; Schema: public; Owner: valknar
--

COPY public.realm_events_listeners (realm_id, value) FROM stdin;
8ae4cef1-1f2a-403a-b938-dd85e52895b8	jboss-logging
460a8e4b-5528-439c-ae10-29c984c7e8f5	jboss-logging
\.


--
-- Data for Name: realm_localizations; Type: TABLE DATA; Schema: public; Owner: valknar
--

COPY public.realm_localizations (realm_id, locale, texts) FROM stdin;
\.


--
-- Data for Name: realm_required_credential; Type: TABLE DATA; Schema: public; Owner: valknar
--

COPY public.realm_required_credential (type, form_label, input, secret, realm_id) FROM stdin;
password	password	t	t	8ae4cef1-1f2a-403a-b938-dd85e52895b8
password	password	t	t	460a8e4b-5528-439c-ae10-29c984c7e8f5
\.


--
-- Data for Name: realm_smtp_config; Type: TABLE DATA; Schema: public; Owner: valknar
--

COPY public.realm_smtp_config (realm_id, value, name) FROM stdin;
\.


--
-- Data for Name: realm_supported_locales; Type: TABLE DATA; Schema: public; Owner: valknar
--

COPY public.realm_supported_locales (realm_id, value) FROM stdin;
\.


--
-- Data for Name: redirect_uris; Type: TABLE DATA; Schema: public; Owner: valknar
--

COPY public.redirect_uris (client_id, value) FROM stdin;
088ba46b-0bc3-49fb-8452-cbe125bff9fd	/realms/master/account/*
dcfd54d7-6c78-4fea-9476-63b29e7cb5b8	/realms/master/account/*
38e23499-9126-46d6-8d7c-9a9058214fa6	/admin/master/console/*
36a4d1a1-9c0d-42cc-bd41-c8970391cbdb	/realms/pivoine.art/account/*
1321a953-5b99-4f7c-8fa1-f263c8d3408a	/realms/pivoine.art/account/*
b3a7f90d-7ffa-42ec-8776-295a809d64c7	/admin/pivoine.art/console/*
\.


--
-- Data for Name: required_action_config; Type: TABLE DATA; Schema: public; Owner: valknar
--

COPY public.required_action_config (required_action_id, value, name) FROM stdin;
\.


--
-- Data for Name: required_action_provider; Type: TABLE DATA; Schema: public; Owner: valknar
--

COPY public.required_action_provider (id, alias, name, realm_id, enabled, default_action, provider_id, priority) FROM stdin;
e46fb110-8f2a-46dc-a20c-0f059787b660	VERIFY_EMAIL	Verify Email	8ae4cef1-1f2a-403a-b938-dd85e52895b8	t	f	VERIFY_EMAIL	50
f3987687-1ef9-4942-ba6f-aeac20e6b7b5	UPDATE_PROFILE	Update Profile	8ae4cef1-1f2a-403a-b938-dd85e52895b8	t	f	UPDATE_PROFILE	40
b877372a-ae7f-4dd2-874e-8769336df02e	CONFIGURE_TOTP	Configure OTP	8ae4cef1-1f2a-403a-b938-dd85e52895b8	t	f	CONFIGURE_TOTP	10
613f9dae-39b2-43d8-86f0-524ed365503b	UPDATE_PASSWORD	Update Password	8ae4cef1-1f2a-403a-b938-dd85e52895b8	t	f	UPDATE_PASSWORD	30
bfa55714-526b-437d-9d04-b1470c625e45	TERMS_AND_CONDITIONS	Terms and Conditions	8ae4cef1-1f2a-403a-b938-dd85e52895b8	f	f	TERMS_AND_CONDITIONS	20
b907d787-eb55-4bcd-a216-9bceb89d0f14	delete_account	Delete Account	8ae4cef1-1f2a-403a-b938-dd85e52895b8	f	f	delete_account	60
f636224a-5730-4522-a50e-d9209772e56f	delete_credential	Delete Credential	8ae4cef1-1f2a-403a-b938-dd85e52895b8	t	f	delete_credential	110
187cf858-13c7-4c2c-b66e-e922189b4980	update_user_locale	Update User Locale	8ae4cef1-1f2a-403a-b938-dd85e52895b8	t	f	update_user_locale	1000
0c2703f4-a1bf-40e1-a696-cd39754c5b2e	UPDATE_EMAIL	Update Email	8ae4cef1-1f2a-403a-b938-dd85e52895b8	f	f	UPDATE_EMAIL	70
17558ceb-8206-4584-9910-6453c1b0f7cb	CONFIGURE_RECOVERY_AUTHN_CODES	Recovery Authentication Codes	8ae4cef1-1f2a-403a-b938-dd85e52895b8	t	f	CONFIGURE_RECOVERY_AUTHN_CODES	130
a46b60d1-5609-442b-81d0-dd57a97d34de	webauthn-register	Webauthn Register	8ae4cef1-1f2a-403a-b938-dd85e52895b8	t	f	webauthn-register	80
43d23b2a-a56d-4846-bce4-193bb1fd3e34	webauthn-register-passwordless	Webauthn Register Passwordless	8ae4cef1-1f2a-403a-b938-dd85e52895b8	t	f	webauthn-register-passwordless	90
c1a5e35f-84df-4c00-9d46-de46adeb1907	VERIFY_PROFILE	Verify Profile	8ae4cef1-1f2a-403a-b938-dd85e52895b8	t	f	VERIFY_PROFILE	100
8ea69b3a-374d-4b18-a96c-661f0811dea6	idp_link	Linking Identity Provider	8ae4cef1-1f2a-403a-b938-dd85e52895b8	t	f	idp_link	120
dd086c73-85f0-4aba-9c0b-bda4c76fe37a	VERIFY_EMAIL	Verify Email	460a8e4b-5528-439c-ae10-29c984c7e8f5	t	f	VERIFY_EMAIL	50
638a7c6d-0582-4a49-b0f3-8654e0283b51	UPDATE_PROFILE	Update Profile	460a8e4b-5528-439c-ae10-29c984c7e8f5	t	f	UPDATE_PROFILE	40
a811aa59-221f-476c-a110-856a7f65e46d	CONFIGURE_TOTP	Configure OTP	460a8e4b-5528-439c-ae10-29c984c7e8f5	t	f	CONFIGURE_TOTP	10
74f471ad-3e3c-445f-a0b5-974c8f8fc0b4	UPDATE_PASSWORD	Update Password	460a8e4b-5528-439c-ae10-29c984c7e8f5	t	f	UPDATE_PASSWORD	30
89c00949-e618-446d-99dd-c74ce92b5e01	TERMS_AND_CONDITIONS	Terms and Conditions	460a8e4b-5528-439c-ae10-29c984c7e8f5	f	f	TERMS_AND_CONDITIONS	20
5e3da9a8-0eda-40a4-9dea-3a93fa709318	delete_account	Delete Account	460a8e4b-5528-439c-ae10-29c984c7e8f5	f	f	delete_account	60
4fe447aa-9552-4ea0-8176-dbd221f1b39d	delete_credential	Delete Credential	460a8e4b-5528-439c-ae10-29c984c7e8f5	t	f	delete_credential	110
a35e49f5-14b3-420f-84d6-49b37e9a174c	update_user_locale	Update User Locale	460a8e4b-5528-439c-ae10-29c984c7e8f5	t	f	update_user_locale	1000
5ef603eb-ea48-415c-aa1c-86189c4fa5df	UPDATE_EMAIL	Update Email	460a8e4b-5528-439c-ae10-29c984c7e8f5	f	f	UPDATE_EMAIL	70
0950a5a6-0782-401c-a928-273b1f35f868	CONFIGURE_RECOVERY_AUTHN_CODES	Recovery Authentication Codes	460a8e4b-5528-439c-ae10-29c984c7e8f5	t	f	CONFIGURE_RECOVERY_AUTHN_CODES	130
9186451b-8230-47de-b664-ff3a4d45c239	webauthn-register	Webauthn Register	460a8e4b-5528-439c-ae10-29c984c7e8f5	t	f	webauthn-register	80
30ac0816-be02-4a29-a20d-545f04302c59	webauthn-register-passwordless	Webauthn Register Passwordless	460a8e4b-5528-439c-ae10-29c984c7e8f5	t	f	webauthn-register-passwordless	90
ee1b435a-3895-470f-8973-593214457796	VERIFY_PROFILE	Verify Profile	460a8e4b-5528-439c-ae10-29c984c7e8f5	t	f	VERIFY_PROFILE	100
faf96a32-5528-4e62-9e4f-903cf7c9e83c	idp_link	Linking Identity Provider	460a8e4b-5528-439c-ae10-29c984c7e8f5	t	f	idp_link	120
\.


--
-- Data for Name: resource_attribute; Type: TABLE DATA; Schema: public; Owner: valknar
--

COPY public.resource_attribute (id, name, value, resource_id) FROM stdin;
\.


--
-- Data for Name: resource_policy; Type: TABLE DATA; Schema: public; Owner: valknar
--

COPY public.resource_policy (resource_id, policy_id) FROM stdin;
\.


--
-- Data for Name: resource_scope; Type: TABLE DATA; Schema: public; Owner: valknar
--

COPY public.resource_scope (resource_id, scope_id) FROM stdin;
\.


--
-- Data for Name: resource_server; Type: TABLE DATA; Schema: public; Owner: valknar
--

COPY public.resource_server (id, allow_rs_remote_mgmt, policy_enforce_mode, decision_strategy) FROM stdin;
\.


--
-- Data for Name: resource_server_perm_ticket; Type: TABLE DATA; Schema: public; Owner: valknar
--

COPY public.resource_server_perm_ticket (id, owner, requester, created_timestamp, granted_timestamp, resource_id, scope_id, resource_server_id, policy_id) FROM stdin;
\.


--
-- Data for Name: resource_server_policy; Type: TABLE DATA; Schema: public; Owner: valknar
--

COPY public.resource_server_policy (id, name, description, type, decision_strategy, logic, resource_server_id, owner) FROM stdin;
\.


--
-- Data for Name: resource_server_resource; Type: TABLE DATA; Schema: public; Owner: valknar
--

COPY public.resource_server_resource (id, name, type, icon_uri, owner, resource_server_id, owner_managed_access, display_name) FROM stdin;
\.


--
-- Data for Name: resource_server_scope; Type: TABLE DATA; Schema: public; Owner: valknar
--

COPY public.resource_server_scope (id, name, icon_uri, resource_server_id, display_name) FROM stdin;
\.


--
-- Data for Name: resource_uris; Type: TABLE DATA; Schema: public; Owner: valknar
--

COPY public.resource_uris (resource_id, value) FROM stdin;
\.


--
-- Data for Name: revoked_token; Type: TABLE DATA; Schema: public; Owner: valknar
--

COPY public.revoked_token (id, expire) FROM stdin;
\.


--
-- Data for Name: role_attribute; Type: TABLE DATA; Schema: public; Owner: valknar
--

COPY public.role_attribute (id, role_id, name, value) FROM stdin;
\.


--
-- Data for Name: scope_mapping; Type: TABLE DATA; Schema: public; Owner: valknar
--

COPY public.scope_mapping (client_id, role_id) FROM stdin;
dcfd54d7-6c78-4fea-9476-63b29e7cb5b8	9bd6b9ea-6017-4ab0-ad28-934b6e5b2b7f
dcfd54d7-6c78-4fea-9476-63b29e7cb5b8	7876c425-56bd-499a-bc55-dffb1b64c005
1321a953-5b99-4f7c-8fa1-f263c8d3408a	0ec4e6ea-0f9f-4d17-9805-5154acfcaaac
1321a953-5b99-4f7c-8fa1-f263c8d3408a	5badb0ad-4227-473c-ac3b-260e73ed538c
\.


--
-- Data for Name: scope_policy; Type: TABLE DATA; Schema: public; Owner: valknar
--

COPY public.scope_policy (scope_id, policy_id) FROM stdin;
\.


--
-- Data for Name: server_config; Type: TABLE DATA; Schema: public; Owner: valknar
--

COPY public.server_config (server_config_key, value, version) FROM stdin;
crt_jgroups	{"prvKey":"MIIEogIBAAKCAQEAuaTGFS5nEHtvZrr2wftVfHGkIumSJ47IH1JjJJz8ezkvzV5KC2Xq64cYN6yyGggtJdm8fja1hnEXL1KdhCAVNjkUBz6FH9gr9TvbKLkr8LTAmOg4RWZfsTz76z76wyzhBppUyHo50//qPZ/005tAtYB6OdYJ6FP7hRj8ipl1hv10FNy82GYcqflleqOuh60d+hiSeBkW8Amq4uiVQdnfUY2qS7UAGHtRRT9xAqtxqldCqMWORhz77wVsEfEUDkiarebyr4LUF2BySYtPPa8FHDTBaOqu7HKSokAqVUfrXBFHHg1wq4/FN+OPW/bAOpOOnI+2Wjca8eGcUQJj+80CHwIDAQABAoIBABIllsCN5o1yAd8RA9UASTt4bY4e6eZyN4LETj4cFs9bm2rsvobKgcIs1J1Na6PnmU41Y6hGZDLODdejSkcWzpJpCVmp7vmnBNw2HsOM0kxELWPlDOpPykCsXVQ1T4e4dKi6EyaW60QB192jq+frEB8nfdf24cVADGEKCVaDdYpQqoBwAydAJ6pXkX5AEvixsqkqEPUTjBeaGUTA62voI194XqU1xORl2PiBlV9VA0S4EU5X5KTdSEgERRdWM7hui41DPi6HfpwadCFWwr1T/CI06Gqlw8AKyJjLywzPQrRJZOL5JrQnpxHLBfcg318WzqperS7JKMc1wYEQUudU7FkCgYEA7CRVdchjxLAbNhHubvbl09yY6+2Exp3uOrvr5/h1pCExTuMtFXA0Bn36hzOUsZjzdObRA2yxBAmR1KHWW802tq9oHVrW1ZcpZxc64fHaP/QxtDBD4/wpPfjWMViRrJ7yhTynSjH8q95ZVozV+sqjbO9FnRlDbwxnIMVpmYqmeDcCgYEAyUFP9d0rvgUMLKzKUI/kf6HOrAGZFx57fBcnsxV79vOllp5s4AqGMQJ19DK2HgvQXCEJpWelCtZywId5QJ1WIMo7KYNTrfTKK2i8qUgYBX9O7pjjuY84fFj3LgTSz/lRJAyUOdHSTMHgpHslKbVFRw2TtUUHt5kdwuTvjwWzAVkCgYAIuwMp2qHNqNEou5r8IUa4AYTp3Bs3mKkxJLeBGQ+IZO3Ew+Nr0n0p7Ehx7TdHJaeCn/IEVWVqB8yLdvxM4pZuRKftxekBdphCRnqX1fBCww1/YvVvnWgM8YFBy8t+/VVsFaT9ukFkPVFCQOy8W/eU1HfXahKzLVs2u/W+hoDHGwKBgHFcY6DWwtPW3gOwFImKc6fcyaAjikr2dZHxLQB3worYtNYBSMxtwSaL/0rc4a5M80FhrqBHoDRZlOuTo53cwe3YW7jHa3QZ5WLMLTChFj7Kdfh5kBQucx+/sQNv3hsdkTHgEAH9iRqJPnMHlmhG3c3m/ONnDbDCA3yLHdEO4cSJAoGAQI0dgHnhLS5puyZZ7+vuMRgmvXp5gl35VIcgYcCX82u9uGp1oYaA1y/xqt0GcCOjiCWORw1tHjzij1+5pEaSbEUjKfpqRYbU5OtC3Hg5DzuPyP6TJoSpxE4qv2LuslE09bhJe3l/WL+xzD44Yo/aaidtvHO58uJv4Kpv0QcByHE=","pubKey":"MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAuaTGFS5nEHtvZrr2wftVfHGkIumSJ47IH1JjJJz8ezkvzV5KC2Xq64cYN6yyGggtJdm8fja1hnEXL1KdhCAVNjkUBz6FH9gr9TvbKLkr8LTAmOg4RWZfsTz76z76wyzhBppUyHo50//qPZ/005tAtYB6OdYJ6FP7hRj8ipl1hv10FNy82GYcqflleqOuh60d+hiSeBkW8Amq4uiVQdnfUY2qS7UAGHtRRT9xAqtxqldCqMWORhz77wVsEfEUDkiarebyr4LUF2BySYtPPa8FHDTBaOqu7HKSokAqVUfrXBFHHg1wq4/FN+OPW/bAOpOOnI+2Wjca8eGcUQJj+80CHwIDAQAB","crt":"MIICnTCCAYUCBgGZr1zgPDANBgkqhkiG9w0BAQsFADASMRAwDgYDVQQDDAdqZ3JvdXBzMB4XDTI1MTAwNDEzMTM0M1oXDTI1MTIwMzEzMTUyM1owEjEQMA4GA1UEAwwHamdyb3VwczCCASIwDQYJKoZIhvcNAQEBBQADggEPADCCAQoCggEBALmkxhUuZxB7b2a69sH7VXxxpCLpkieOyB9SYySc/Hs5L81eSgtl6uuHGDesshoILSXZvH42tYZxFy9SnYQgFTY5FAc+hR/YK/U72yi5K/C0wJjoOEVmX7E8++s++sMs4QaaVMh6OdP/6j2f9NObQLWAejnWCehT+4UY/IqZdYb9dBTcvNhmHKn5ZXqjroetHfoYkngZFvAJquLolUHZ31GNqku1ABh7UUU/cQKrcapXQqjFjkYc++8FbBHxFA5Imq3m8q+C1BdgckmLTz2vBRw0wWjqruxykqJAKlVH61wRRx4NcKuPxTfjj1v2wDqTjpyPtlo3GvHhnFECY/vNAh8CAwEAATANBgkqhkiG9w0BAQsFAAOCAQEAEkKNZFHrINcKgYpEzsJ3VvknSrvBknpkAKds/DuTHoTSaVA1ChRjddZpis4cZILubxhM5om69A4+1TyjJGfghljqzM8CnD1GxHqXdPO+KZ2OKHAYe8AhvWw/+USdmsPpEmYxPRLNTgVnyJkkcm/c7z7Qbiuz0knnJY+3VWMCX3q5Gy5EmlIqUOTBQziG6O6wtl+hbhwTkiY+VbY3YcFgz6yEn3sG67MxLHmbz4RAJL6Fp41fW4C4e5u0nzI22mTCgjozyEpwMvLncJMRHlEehDniUjYAyZtfwB6bHo5L6q9dfk2EQI91BxB8HxLaBFLQgowV2WAFiModLqFnPyQOyA==","alias":"ea076ac2-62e2-411f-84d1-80590fec3004","generatedMillis":1759583723620}	0
JGROUPS_ADDRESS_SEQUENCE	25	25
\.


--
-- Data for Name: user_attribute; Type: TABLE DATA; Schema: public; Owner: valknar
--

COPY public.user_attribute (name, value, user_id, id, long_value_hash, long_value_hash_lower_case, long_value) FROM stdin;
\.


--
-- Data for Name: user_consent; Type: TABLE DATA; Schema: public; Owner: valknar
--

COPY public.user_consent (id, client_id, user_id, created_date, last_updated_date, client_storage_provider, external_client_id) FROM stdin;
\.


--
-- Data for Name: user_consent_client_scope; Type: TABLE DATA; Schema: public; Owner: valknar
--

COPY public.user_consent_client_scope (user_consent_id, scope_id) FROM stdin;
\.


--
-- Data for Name: user_entity; Type: TABLE DATA; Schema: public; Owner: valknar
--

COPY public.user_entity (id, email, email_constraint, email_verified, enabled, federation_link, first_name, last_name, realm_id, username, created_timestamp, service_account_client_link, not_before) FROM stdin;
36bd20b1-3cb4-436c-92f6-da018e4426ee	valknar@pivoine.art	valknar@pivoine.art	t	t	\N	Sebastian	Krüger	8ae4cef1-1f2a-403a-b938-dd85e52895b8	valknar	1759584081172	\N	0
\.


--
-- Data for Name: user_federation_config; Type: TABLE DATA; Schema: public; Owner: valknar
--

COPY public.user_federation_config (user_federation_provider_id, value, name) FROM stdin;
\.


--
-- Data for Name: user_federation_mapper; Type: TABLE DATA; Schema: public; Owner: valknar
--

COPY public.user_federation_mapper (id, name, federation_provider_id, federation_mapper_type, realm_id) FROM stdin;
\.


--
-- Data for Name: user_federation_mapper_config; Type: TABLE DATA; Schema: public; Owner: valknar
--

COPY public.user_federation_mapper_config (user_federation_mapper_id, value, name) FROM stdin;
\.


--
-- Data for Name: user_federation_provider; Type: TABLE DATA; Schema: public; Owner: valknar
--

COPY public.user_federation_provider (id, changed_sync_period, display_name, full_sync_period, last_sync, priority, provider_name, realm_id) FROM stdin;
\.


--
-- Data for Name: user_group_membership; Type: TABLE DATA; Schema: public; Owner: valknar
--

COPY public.user_group_membership (group_id, user_id, membership_type) FROM stdin;
\.


--
-- Data for Name: user_required_action; Type: TABLE DATA; Schema: public; Owner: valknar
--

COPY public.user_required_action (user_id, required_action) FROM stdin;
\.


--
-- Data for Name: user_role_mapping; Type: TABLE DATA; Schema: public; Owner: valknar
--

COPY public.user_role_mapping (role_id, user_id) FROM stdin;
54fe2c16-b141-4a22-b5ef-d24d35a38ccc	36bd20b1-3cb4-436c-92f6-da018e4426ee
33a5cb28-0c54-45db-bbf7-0aceb2816172	36bd20b1-3cb4-436c-92f6-da018e4426ee
\.


--
-- Data for Name: web_origins; Type: TABLE DATA; Schema: public; Owner: valknar
--

COPY public.web_origins (client_id, value) FROM stdin;
38e23499-9126-46d6-8d7c-9a9058214fa6	+
b3a7f90d-7ffa-42ec-8776-295a809d64c7	+
\.


--
-- Data for Name: workflow_state; Type: TABLE DATA; Schema: public; Owner: valknar
--

COPY public.workflow_state (execution_id, resource_id, workflow_id, workflow_provider_id, resource_type, scheduled_step_id, scheduled_step_timestamp) FROM stdin;
\.


--
-- Name: org_domain ORG_DOMAIN_pkey; Type: CONSTRAINT; Schema: public; Owner: valknar
--

ALTER TABLE ONLY public.org_domain
    ADD CONSTRAINT "ORG_DOMAIN_pkey" PRIMARY KEY (id, name);


--
-- Name: org ORG_pkey; Type: CONSTRAINT; Schema: public; Owner: valknar
--

ALTER TABLE ONLY public.org
    ADD CONSTRAINT "ORG_pkey" PRIMARY KEY (id);


--
-- Name: server_config SERVER_CONFIG_pkey; Type: CONSTRAINT; Schema: public; Owner: valknar
--

ALTER TABLE ONLY public.server_config
    ADD CONSTRAINT "SERVER_CONFIG_pkey" PRIMARY KEY (server_config_key);


--
-- Name: keycloak_role UK_J3RWUVD56ONTGSUHOGM184WW2-2; Type: CONSTRAINT; Schema: public; Owner: valknar
--

ALTER TABLE ONLY public.keycloak_role
    ADD CONSTRAINT "UK_J3RWUVD56ONTGSUHOGM184WW2-2" UNIQUE (name, client_realm_constraint);


--
-- Name: client_auth_flow_bindings c_cli_flow_bind; Type: CONSTRAINT; Schema: public; Owner: valknar
--

ALTER TABLE ONLY public.client_auth_flow_bindings
    ADD CONSTRAINT c_cli_flow_bind PRIMARY KEY (client_id, binding_name);


--
-- Name: client_scope_client c_cli_scope_bind; Type: CONSTRAINT; Schema: public; Owner: valknar
--

ALTER TABLE ONLY public.client_scope_client
    ADD CONSTRAINT c_cli_scope_bind PRIMARY KEY (client_id, scope_id);


--
-- Name: client_initial_access cnstr_client_init_acc_pk; Type: CONSTRAINT; Schema: public; Owner: valknar
--

ALTER TABLE ONLY public.client_initial_access
    ADD CONSTRAINT cnstr_client_init_acc_pk PRIMARY KEY (id);


--
-- Name: realm_default_groups con_group_id_def_groups; Type: CONSTRAINT; Schema: public; Owner: valknar
--

ALTER TABLE ONLY public.realm_default_groups
    ADD CONSTRAINT con_group_id_def_groups UNIQUE (group_id);


--
-- Name: broker_link constr_broker_link_pk; Type: CONSTRAINT; Schema: public; Owner: valknar
--

ALTER TABLE ONLY public.broker_link
    ADD CONSTRAINT constr_broker_link_pk PRIMARY KEY (identity_provider, user_id);


--
-- Name: component_config constr_component_config_pk; Type: CONSTRAINT; Schema: public; Owner: valknar
--

ALTER TABLE ONLY public.component_config
    ADD CONSTRAINT constr_component_config_pk PRIMARY KEY (id);


--
-- Name: component constr_component_pk; Type: CONSTRAINT; Schema: public; Owner: valknar
--

ALTER TABLE ONLY public.component
    ADD CONSTRAINT constr_component_pk PRIMARY KEY (id);


--
-- Name: fed_user_required_action constr_fed_required_action; Type: CONSTRAINT; Schema: public; Owner: valknar
--

ALTER TABLE ONLY public.fed_user_required_action
    ADD CONSTRAINT constr_fed_required_action PRIMARY KEY (required_action, user_id);


--
-- Name: fed_user_attribute constr_fed_user_attr_pk; Type: CONSTRAINT; Schema: public; Owner: valknar
--

ALTER TABLE ONLY public.fed_user_attribute
    ADD CONSTRAINT constr_fed_user_attr_pk PRIMARY KEY (id);


--
-- Name: fed_user_consent constr_fed_user_consent_pk; Type: CONSTRAINT; Schema: public; Owner: valknar
--

ALTER TABLE ONLY public.fed_user_consent
    ADD CONSTRAINT constr_fed_user_consent_pk PRIMARY KEY (id);


--
-- Name: fed_user_credential constr_fed_user_cred_pk; Type: CONSTRAINT; Schema: public; Owner: valknar
--

ALTER TABLE ONLY public.fed_user_credential
    ADD CONSTRAINT constr_fed_user_cred_pk PRIMARY KEY (id);


--
-- Name: fed_user_group_membership constr_fed_user_group; Type: CONSTRAINT; Schema: public; Owner: valknar
--

ALTER TABLE ONLY public.fed_user_group_membership
    ADD CONSTRAINT constr_fed_user_group PRIMARY KEY (group_id, user_id);


--
-- Name: fed_user_role_mapping constr_fed_user_role; Type: CONSTRAINT; Schema: public; Owner: valknar
--

ALTER TABLE ONLY public.fed_user_role_mapping
    ADD CONSTRAINT constr_fed_user_role PRIMARY KEY (role_id, user_id);


--
-- Name: federated_user constr_federated_user; Type: CONSTRAINT; Schema: public; Owner: valknar
--

ALTER TABLE ONLY public.federated_user
    ADD CONSTRAINT constr_federated_user PRIMARY KEY (id);


--
-- Name: realm_default_groups constr_realm_default_groups; Type: CONSTRAINT; Schema: public; Owner: valknar
--

ALTER TABLE ONLY public.realm_default_groups
    ADD CONSTRAINT constr_realm_default_groups PRIMARY KEY (realm_id, group_id);


--
-- Name: realm_enabled_event_types constr_realm_enabl_event_types; Type: CONSTRAINT; Schema: public; Owner: valknar
--

ALTER TABLE ONLY public.realm_enabled_event_types
    ADD CONSTRAINT constr_realm_enabl_event_types PRIMARY KEY (realm_id, value);


--
-- Name: realm_events_listeners constr_realm_events_listeners; Type: CONSTRAINT; Schema: public; Owner: valknar
--

ALTER TABLE ONLY public.realm_events_listeners
    ADD CONSTRAINT constr_realm_events_listeners PRIMARY KEY (realm_id, value);


--
-- Name: realm_supported_locales constr_realm_supported_locales; Type: CONSTRAINT; Schema: public; Owner: valknar
--

ALTER TABLE ONLY public.realm_supported_locales
    ADD CONSTRAINT constr_realm_supported_locales PRIMARY KEY (realm_id, value);


--
-- Name: identity_provider constraint_2b; Type: CONSTRAINT; Schema: public; Owner: valknar
--

ALTER TABLE ONLY public.identity_provider
    ADD CONSTRAINT constraint_2b PRIMARY KEY (internal_id);


--
-- Name: client_attributes constraint_3c; Type: CONSTRAINT; Schema: public; Owner: valknar
--

ALTER TABLE ONLY public.client_attributes
    ADD CONSTRAINT constraint_3c PRIMARY KEY (client_id, name);


--
-- Name: event_entity constraint_4; Type: CONSTRAINT; Schema: public; Owner: valknar
--

ALTER TABLE ONLY public.event_entity
    ADD CONSTRAINT constraint_4 PRIMARY KEY (id);


--
-- Name: federated_identity constraint_40; Type: CONSTRAINT; Schema: public; Owner: valknar
--

ALTER TABLE ONLY public.federated_identity
    ADD CONSTRAINT constraint_40 PRIMARY KEY (identity_provider, user_id);


--
-- Name: realm constraint_4a; Type: CONSTRAINT; Schema: public; Owner: valknar
--

ALTER TABLE ONLY public.realm
    ADD CONSTRAINT constraint_4a PRIMARY KEY (id);


--
-- Name: user_federation_provider constraint_5c; Type: CONSTRAINT; Schema: public; Owner: valknar
--

ALTER TABLE ONLY public.user_federation_provider
    ADD CONSTRAINT constraint_5c PRIMARY KEY (id);


--
-- Name: client constraint_7; Type: CONSTRAINT; Schema: public; Owner: valknar
--

ALTER TABLE ONLY public.client
    ADD CONSTRAINT constraint_7 PRIMARY KEY (id);


--
-- Name: scope_mapping constraint_81; Type: CONSTRAINT; Schema: public; Owner: valknar
--

ALTER TABLE ONLY public.scope_mapping
    ADD CONSTRAINT constraint_81 PRIMARY KEY (client_id, role_id);


--
-- Name: client_node_registrations constraint_84; Type: CONSTRAINT; Schema: public; Owner: valknar
--

ALTER TABLE ONLY public.client_node_registrations
    ADD CONSTRAINT constraint_84 PRIMARY KEY (client_id, name);


--
-- Name: realm_attribute constraint_9; Type: CONSTRAINT; Schema: public; Owner: valknar
--

ALTER TABLE ONLY public.realm_attribute
    ADD CONSTRAINT constraint_9 PRIMARY KEY (name, realm_id);


--
-- Name: realm_required_credential constraint_92; Type: CONSTRAINT; Schema: public; Owner: valknar
--

ALTER TABLE ONLY public.realm_required_credential
    ADD CONSTRAINT constraint_92 PRIMARY KEY (realm_id, type);


--
-- Name: keycloak_role constraint_a; Type: CONSTRAINT; Schema: public; Owner: valknar
--

ALTER TABLE ONLY public.keycloak_role
    ADD CONSTRAINT constraint_a PRIMARY KEY (id);


--
-- Name: admin_event_entity constraint_admin_event_entity; Type: CONSTRAINT; Schema: public; Owner: valknar
--

ALTER TABLE ONLY public.admin_event_entity
    ADD CONSTRAINT constraint_admin_event_entity PRIMARY KEY (id);


--
-- Name: authenticator_config_entry constraint_auth_cfg_pk; Type: CONSTRAINT; Schema: public; Owner: valknar
--

ALTER TABLE ONLY public.authenticator_config_entry
    ADD CONSTRAINT constraint_auth_cfg_pk PRIMARY KEY (authenticator_id, name);


--
-- Name: authentication_execution constraint_auth_exec_pk; Type: CONSTRAINT; Schema: public; Owner: valknar
--

ALTER TABLE ONLY public.authentication_execution
    ADD CONSTRAINT constraint_auth_exec_pk PRIMARY KEY (id);


--
-- Name: authentication_flow constraint_auth_flow_pk; Type: CONSTRAINT; Schema: public; Owner: valknar
--

ALTER TABLE ONLY public.authentication_flow
    ADD CONSTRAINT constraint_auth_flow_pk PRIMARY KEY (id);


--
-- Name: authenticator_config constraint_auth_pk; Type: CONSTRAINT; Schema: public; Owner: valknar
--

ALTER TABLE ONLY public.authenticator_config
    ADD CONSTRAINT constraint_auth_pk PRIMARY KEY (id);


--
-- Name: user_role_mapping constraint_c; Type: CONSTRAINT; Schema: public; Owner: valknar
--

ALTER TABLE ONLY public.user_role_mapping
    ADD CONSTRAINT constraint_c PRIMARY KEY (role_id, user_id);


--
-- Name: composite_role constraint_composite_role; Type: CONSTRAINT; Schema: public; Owner: valknar
--

ALTER TABLE ONLY public.composite_role
    ADD CONSTRAINT constraint_composite_role PRIMARY KEY (composite, child_role);


--
-- Name: identity_provider_config constraint_d; Type: CONSTRAINT; Schema: public; Owner: valknar
--

ALTER TABLE ONLY public.identity_provider_config
    ADD CONSTRAINT constraint_d PRIMARY KEY (identity_provider_id, name);


--
-- Name: policy_config constraint_dpc; Type: CONSTRAINT; Schema: public; Owner: valknar
--

ALTER TABLE ONLY public.policy_config
    ADD CONSTRAINT constraint_dpc PRIMARY KEY (policy_id, name);


--
-- Name: realm_smtp_config constraint_e; Type: CONSTRAINT; Schema: public; Owner: valknar
--

ALTER TABLE ONLY public.realm_smtp_config
    ADD CONSTRAINT constraint_e PRIMARY KEY (realm_id, name);


--
-- Name: credential constraint_f; Type: CONSTRAINT; Schema: public; Owner: valknar
--

ALTER TABLE ONLY public.credential
    ADD CONSTRAINT constraint_f PRIMARY KEY (id);


--
-- Name: user_federation_config constraint_f9; Type: CONSTRAINT; Schema: public; Owner: valknar
--

ALTER TABLE ONLY public.user_federation_config
    ADD CONSTRAINT constraint_f9 PRIMARY KEY (user_federation_provider_id, name);


--
-- Name: resource_server_perm_ticket constraint_fapmt; Type: CONSTRAINT; Schema: public; Owner: valknar
--

ALTER TABLE ONLY public.resource_server_perm_ticket
    ADD CONSTRAINT constraint_fapmt PRIMARY KEY (id);


--
-- Name: resource_server_resource constraint_farsr; Type: CONSTRAINT; Schema: public; Owner: valknar
--

ALTER TABLE ONLY public.resource_server_resource
    ADD CONSTRAINT constraint_farsr PRIMARY KEY (id);


--
-- Name: resource_server_policy constraint_farsrp; Type: CONSTRAINT; Schema: public; Owner: valknar
--

ALTER TABLE ONLY public.resource_server_policy
    ADD CONSTRAINT constraint_farsrp PRIMARY KEY (id);


--
-- Name: associated_policy constraint_farsrpap; Type: CONSTRAINT; Schema: public; Owner: valknar
--

ALTER TABLE ONLY public.associated_policy
    ADD CONSTRAINT constraint_farsrpap PRIMARY KEY (policy_id, associated_policy_id);


--
-- Name: resource_policy constraint_farsrpp; Type: CONSTRAINT; Schema: public; Owner: valknar
--

ALTER TABLE ONLY public.resource_policy
    ADD CONSTRAINT constraint_farsrpp PRIMARY KEY (resource_id, policy_id);


--
-- Name: resource_server_scope constraint_farsrs; Type: CONSTRAINT; Schema: public; Owner: valknar
--

ALTER TABLE ONLY public.resource_server_scope
    ADD CONSTRAINT constraint_farsrs PRIMARY KEY (id);


--
-- Name: resource_scope constraint_farsrsp; Type: CONSTRAINT; Schema: public; Owner: valknar
--

ALTER TABLE ONLY public.resource_scope
    ADD CONSTRAINT constraint_farsrsp PRIMARY KEY (resource_id, scope_id);


--
-- Name: scope_policy constraint_farsrsps; Type: CONSTRAINT; Schema: public; Owner: valknar
--

ALTER TABLE ONLY public.scope_policy
    ADD CONSTRAINT constraint_farsrsps PRIMARY KEY (scope_id, policy_id);


--
-- Name: user_entity constraint_fb; Type: CONSTRAINT; Schema: public; Owner: valknar
--

ALTER TABLE ONLY public.user_entity
    ADD CONSTRAINT constraint_fb PRIMARY KEY (id);


--
-- Name: user_federation_mapper_config constraint_fedmapper_cfg_pm; Type: CONSTRAINT; Schema: public; Owner: valknar
--

ALTER TABLE ONLY public.user_federation_mapper_config
    ADD CONSTRAINT constraint_fedmapper_cfg_pm PRIMARY KEY (user_federation_mapper_id, name);


--
-- Name: user_federation_mapper constraint_fedmapperpm; Type: CONSTRAINT; Schema: public; Owner: valknar
--

ALTER TABLE ONLY public.user_federation_mapper
    ADD CONSTRAINT constraint_fedmapperpm PRIMARY KEY (id);


--
-- Name: fed_user_consent_cl_scope constraint_fgrntcsnt_clsc_pm; Type: CONSTRAINT; Schema: public; Owner: valknar
--

ALTER TABLE ONLY public.fed_user_consent_cl_scope
    ADD CONSTRAINT constraint_fgrntcsnt_clsc_pm PRIMARY KEY (user_consent_id, scope_id);


--
-- Name: user_consent_client_scope constraint_grntcsnt_clsc_pm; Type: CONSTRAINT; Schema: public; Owner: valknar
--

ALTER TABLE ONLY public.user_consent_client_scope
    ADD CONSTRAINT constraint_grntcsnt_clsc_pm PRIMARY KEY (user_consent_id, scope_id);


--
-- Name: user_consent constraint_grntcsnt_pm; Type: CONSTRAINT; Schema: public; Owner: valknar
--

ALTER TABLE ONLY public.user_consent
    ADD CONSTRAINT constraint_grntcsnt_pm PRIMARY KEY (id);


--
-- Name: keycloak_group constraint_group; Type: CONSTRAINT; Schema: public; Owner: valknar
--

ALTER TABLE ONLY public.keycloak_group
    ADD CONSTRAINT constraint_group PRIMARY KEY (id);


--
-- Name: group_attribute constraint_group_attribute_pk; Type: CONSTRAINT; Schema: public; Owner: valknar
--

ALTER TABLE ONLY public.group_attribute
    ADD CONSTRAINT constraint_group_attribute_pk PRIMARY KEY (id);


--
-- Name: group_role_mapping constraint_group_role; Type: CONSTRAINT; Schema: public; Owner: valknar
--

ALTER TABLE ONLY public.group_role_mapping
    ADD CONSTRAINT constraint_group_role PRIMARY KEY (role_id, group_id);


--
-- Name: identity_provider_mapper constraint_idpm; Type: CONSTRAINT; Schema: public; Owner: valknar
--

ALTER TABLE ONLY public.identity_provider_mapper
    ADD CONSTRAINT constraint_idpm PRIMARY KEY (id);


--
-- Name: idp_mapper_config constraint_idpmconfig; Type: CONSTRAINT; Schema: public; Owner: valknar
--

ALTER TABLE ONLY public.idp_mapper_config
    ADD CONSTRAINT constraint_idpmconfig PRIMARY KEY (idp_mapper_id, name);


--
-- Name: jgroups_ping constraint_jgroups_ping; Type: CONSTRAINT; Schema: public; Owner: valknar
--

ALTER TABLE ONLY public.jgroups_ping
    ADD CONSTRAINT constraint_jgroups_ping PRIMARY KEY (address);


--
-- Name: migration_model constraint_migmod; Type: CONSTRAINT; Schema: public; Owner: valknar
--

ALTER TABLE ONLY public.migration_model
    ADD CONSTRAINT constraint_migmod PRIMARY KEY (id);


--
-- Name: offline_client_session constraint_offl_cl_ses_pk3; Type: CONSTRAINT; Schema: public; Owner: valknar
--

ALTER TABLE ONLY public.offline_client_session
    ADD CONSTRAINT constraint_offl_cl_ses_pk3 PRIMARY KEY (user_session_id, client_id, client_storage_provider, external_client_id, offline_flag);


--
-- Name: offline_user_session constraint_offl_us_ses_pk2; Type: CONSTRAINT; Schema: public; Owner: valknar
--

ALTER TABLE ONLY public.offline_user_session
    ADD CONSTRAINT constraint_offl_us_ses_pk2 PRIMARY KEY (user_session_id, offline_flag);


--
-- Name: protocol_mapper constraint_pcm; Type: CONSTRAINT; Schema: public; Owner: valknar
--

ALTER TABLE ONLY public.protocol_mapper
    ADD CONSTRAINT constraint_pcm PRIMARY KEY (id);


--
-- Name: protocol_mapper_config constraint_pmconfig; Type: CONSTRAINT; Schema: public; Owner: valknar
--

ALTER TABLE ONLY public.protocol_mapper_config
    ADD CONSTRAINT constraint_pmconfig PRIMARY KEY (protocol_mapper_id, name);


--
-- Name: redirect_uris constraint_redirect_uris; Type: CONSTRAINT; Schema: public; Owner: valknar
--

ALTER TABLE ONLY public.redirect_uris
    ADD CONSTRAINT constraint_redirect_uris PRIMARY KEY (client_id, value);


--
-- Name: required_action_config constraint_req_act_cfg_pk; Type: CONSTRAINT; Schema: public; Owner: valknar
--

ALTER TABLE ONLY public.required_action_config
    ADD CONSTRAINT constraint_req_act_cfg_pk PRIMARY KEY (required_action_id, name);


--
-- Name: required_action_provider constraint_req_act_prv_pk; Type: CONSTRAINT; Schema: public; Owner: valknar
--

ALTER TABLE ONLY public.required_action_provider
    ADD CONSTRAINT constraint_req_act_prv_pk PRIMARY KEY (id);


--
-- Name: user_required_action constraint_required_action; Type: CONSTRAINT; Schema: public; Owner: valknar
--

ALTER TABLE ONLY public.user_required_action
    ADD CONSTRAINT constraint_required_action PRIMARY KEY (required_action, user_id);


--
-- Name: resource_uris constraint_resour_uris_pk; Type: CONSTRAINT; Schema: public; Owner: valknar
--

ALTER TABLE ONLY public.resource_uris
    ADD CONSTRAINT constraint_resour_uris_pk PRIMARY KEY (resource_id, value);


--
-- Name: role_attribute constraint_role_attribute_pk; Type: CONSTRAINT; Schema: public; Owner: valknar
--

ALTER TABLE ONLY public.role_attribute
    ADD CONSTRAINT constraint_role_attribute_pk PRIMARY KEY (id);


--
-- Name: revoked_token constraint_rt; Type: CONSTRAINT; Schema: public; Owner: valknar
--

ALTER TABLE ONLY public.revoked_token
    ADD CONSTRAINT constraint_rt PRIMARY KEY (id);


--
-- Name: user_attribute constraint_user_attribute_pk; Type: CONSTRAINT; Schema: public; Owner: valknar
--

ALTER TABLE ONLY public.user_attribute
    ADD CONSTRAINT constraint_user_attribute_pk PRIMARY KEY (id);


--
-- Name: user_group_membership constraint_user_group; Type: CONSTRAINT; Schema: public; Owner: valknar
--

ALTER TABLE ONLY public.user_group_membership
    ADD CONSTRAINT constraint_user_group PRIMARY KEY (group_id, user_id);


--
-- Name: web_origins constraint_web_origins; Type: CONSTRAINT; Schema: public; Owner: valknar
--

ALTER TABLE ONLY public.web_origins
    ADD CONSTRAINT constraint_web_origins PRIMARY KEY (client_id, value);


--
-- Name: databasechangeloglock databasechangeloglock_pkey; Type: CONSTRAINT; Schema: public; Owner: valknar
--

ALTER TABLE ONLY public.databasechangeloglock
    ADD CONSTRAINT databasechangeloglock_pkey PRIMARY KEY (id);


--
-- Name: client_scope_attributes pk_cl_tmpl_attr; Type: CONSTRAINT; Schema: public; Owner: valknar
--

ALTER TABLE ONLY public.client_scope_attributes
    ADD CONSTRAINT pk_cl_tmpl_attr PRIMARY KEY (scope_id, name);


--
-- Name: client_scope pk_cli_template; Type: CONSTRAINT; Schema: public; Owner: valknar
--

ALTER TABLE ONLY public.client_scope
    ADD CONSTRAINT pk_cli_template PRIMARY KEY (id);


--
-- Name: resource_server pk_resource_server; Type: CONSTRAINT; Schema: public; Owner: valknar
--

ALTER TABLE ONLY public.resource_server
    ADD CONSTRAINT pk_resource_server PRIMARY KEY (id);


--
-- Name: client_scope_role_mapping pk_template_scope; Type: CONSTRAINT; Schema: public; Owner: valknar
--

ALTER TABLE ONLY public.client_scope_role_mapping
    ADD CONSTRAINT pk_template_scope PRIMARY KEY (scope_id, role_id);


--
-- Name: workflow_state pk_workflow_state; Type: CONSTRAINT; Schema: public; Owner: valknar
--

ALTER TABLE ONLY public.workflow_state
    ADD CONSTRAINT pk_workflow_state PRIMARY KEY (execution_id);


--
-- Name: default_client_scope r_def_cli_scope_bind; Type: CONSTRAINT; Schema: public; Owner: valknar
--

ALTER TABLE ONLY public.default_client_scope
    ADD CONSTRAINT r_def_cli_scope_bind PRIMARY KEY (realm_id, scope_id);


--
-- Name: realm_localizations realm_localizations_pkey; Type: CONSTRAINT; Schema: public; Owner: valknar
--

ALTER TABLE ONLY public.realm_localizations
    ADD CONSTRAINT realm_localizations_pkey PRIMARY KEY (realm_id, locale);


--
-- Name: resource_attribute res_attr_pk; Type: CONSTRAINT; Schema: public; Owner: valknar
--

ALTER TABLE ONLY public.resource_attribute
    ADD CONSTRAINT res_attr_pk PRIMARY KEY (id);


--
-- Name: keycloak_group sibling_names; Type: CONSTRAINT; Schema: public; Owner: valknar
--

ALTER TABLE ONLY public.keycloak_group
    ADD CONSTRAINT sibling_names UNIQUE (realm_id, parent_group, name);


--
-- Name: identity_provider uk_2daelwnibji49avxsrtuf6xj33; Type: CONSTRAINT; Schema: public; Owner: valknar
--

ALTER TABLE ONLY public.identity_provider
    ADD CONSTRAINT uk_2daelwnibji49avxsrtuf6xj33 UNIQUE (provider_alias, realm_id);


--
-- Name: client uk_b71cjlbenv945rb6gcon438at; Type: CONSTRAINT; Schema: public; Owner: valknar
--

ALTER TABLE ONLY public.client
    ADD CONSTRAINT uk_b71cjlbenv945rb6gcon438at UNIQUE (realm_id, client_id);


--
-- Name: client_scope uk_cli_scope; Type: CONSTRAINT; Schema: public; Owner: valknar
--

ALTER TABLE ONLY public.client_scope
    ADD CONSTRAINT uk_cli_scope UNIQUE (realm_id, name);


--
-- Name: user_entity uk_dykn684sl8up1crfei6eckhd7; Type: CONSTRAINT; Schema: public; Owner: valknar
--

ALTER TABLE ONLY public.user_entity
    ADD CONSTRAINT uk_dykn684sl8up1crfei6eckhd7 UNIQUE (realm_id, email_constraint);


--
-- Name: user_consent uk_external_consent; Type: CONSTRAINT; Schema: public; Owner: valknar
--

ALTER TABLE ONLY public.user_consent
    ADD CONSTRAINT uk_external_consent UNIQUE (client_storage_provider, external_client_id, user_id);


--
-- Name: resource_server_resource uk_frsr6t700s9v50bu18ws5ha6; Type: CONSTRAINT; Schema: public; Owner: valknar
--

ALTER TABLE ONLY public.resource_server_resource
    ADD CONSTRAINT uk_frsr6t700s9v50bu18ws5ha6 UNIQUE (name, owner, resource_server_id);


--
-- Name: resource_server_perm_ticket uk_frsr6t700s9v50bu18ws5pmt; Type: CONSTRAINT; Schema: public; Owner: valknar
--

ALTER TABLE ONLY public.resource_server_perm_ticket
    ADD CONSTRAINT uk_frsr6t700s9v50bu18ws5pmt UNIQUE (owner, requester, resource_server_id, resource_id, scope_id);


--
-- Name: resource_server_policy uk_frsrpt700s9v50bu18ws5ha6; Type: CONSTRAINT; Schema: public; Owner: valknar
--

ALTER TABLE ONLY public.resource_server_policy
    ADD CONSTRAINT uk_frsrpt700s9v50bu18ws5ha6 UNIQUE (name, resource_server_id);


--
-- Name: resource_server_scope uk_frsrst700s9v50bu18ws5ha6; Type: CONSTRAINT; Schema: public; Owner: valknar
--

ALTER TABLE ONLY public.resource_server_scope
    ADD CONSTRAINT uk_frsrst700s9v50bu18ws5ha6 UNIQUE (name, resource_server_id);


--
-- Name: user_consent uk_local_consent; Type: CONSTRAINT; Schema: public; Owner: valknar
--

ALTER TABLE ONLY public.user_consent
    ADD CONSTRAINT uk_local_consent UNIQUE (client_id, user_id);


--
-- Name: migration_model uk_migration_update_time; Type: CONSTRAINT; Schema: public; Owner: valknar
--

ALTER TABLE ONLY public.migration_model
    ADD CONSTRAINT uk_migration_update_time UNIQUE (update_time);


--
-- Name: migration_model uk_migration_version; Type: CONSTRAINT; Schema: public; Owner: valknar
--

ALTER TABLE ONLY public.migration_model
    ADD CONSTRAINT uk_migration_version UNIQUE (version);


--
-- Name: org uk_org_alias; Type: CONSTRAINT; Schema: public; Owner: valknar
--

ALTER TABLE ONLY public.org
    ADD CONSTRAINT uk_org_alias UNIQUE (realm_id, alias);


--
-- Name: org uk_org_group; Type: CONSTRAINT; Schema: public; Owner: valknar
--

ALTER TABLE ONLY public.org
    ADD CONSTRAINT uk_org_group UNIQUE (group_id);


--
-- Name: org uk_org_name; Type: CONSTRAINT; Schema: public; Owner: valknar
--

ALTER TABLE ONLY public.org
    ADD CONSTRAINT uk_org_name UNIQUE (realm_id, name);


--
-- Name: realm uk_orvsdmla56612eaefiq6wl5oi; Type: CONSTRAINT; Schema: public; Owner: valknar
--

ALTER TABLE ONLY public.realm
    ADD CONSTRAINT uk_orvsdmla56612eaefiq6wl5oi UNIQUE (name);


--
-- Name: user_entity uk_ru8tt6t700s9v50bu18ws5ha6; Type: CONSTRAINT; Schema: public; Owner: valknar
--

ALTER TABLE ONLY public.user_entity
    ADD CONSTRAINT uk_ru8tt6t700s9v50bu18ws5ha6 UNIQUE (realm_id, username);


--
-- Name: workflow_state uq_workflow_resource; Type: CONSTRAINT; Schema: public; Owner: valknar
--

ALTER TABLE ONLY public.workflow_state
    ADD CONSTRAINT uq_workflow_resource UNIQUE (workflow_id, resource_id);


--
-- Name: fed_user_attr_long_values; Type: INDEX; Schema: public; Owner: valknar
--

CREATE INDEX fed_user_attr_long_values ON public.fed_user_attribute USING btree (long_value_hash, name);


--
-- Name: fed_user_attr_long_values_lower_case; Type: INDEX; Schema: public; Owner: valknar
--

CREATE INDEX fed_user_attr_long_values_lower_case ON public.fed_user_attribute USING btree (long_value_hash_lower_case, name);


--
-- Name: idx_admin_event_time; Type: INDEX; Schema: public; Owner: valknar
--

CREATE INDEX idx_admin_event_time ON public.admin_event_entity USING btree (realm_id, admin_event_time);


--
-- Name: idx_assoc_pol_assoc_pol_id; Type: INDEX; Schema: public; Owner: valknar
--

CREATE INDEX idx_assoc_pol_assoc_pol_id ON public.associated_policy USING btree (associated_policy_id);


--
-- Name: idx_auth_config_realm; Type: INDEX; Schema: public; Owner: valknar
--

CREATE INDEX idx_auth_config_realm ON public.authenticator_config USING btree (realm_id);


--
-- Name: idx_auth_exec_flow; Type: INDEX; Schema: public; Owner: valknar
--

CREATE INDEX idx_auth_exec_flow ON public.authentication_execution USING btree (flow_id);


--
-- Name: idx_auth_exec_realm_flow; Type: INDEX; Schema: public; Owner: valknar
--

CREATE INDEX idx_auth_exec_realm_flow ON public.authentication_execution USING btree (realm_id, flow_id);


--
-- Name: idx_auth_flow_realm; Type: INDEX; Schema: public; Owner: valknar
--

CREATE INDEX idx_auth_flow_realm ON public.authentication_flow USING btree (realm_id);


--
-- Name: idx_cl_clscope; Type: INDEX; Schema: public; Owner: valknar
--

CREATE INDEX idx_cl_clscope ON public.client_scope_client USING btree (scope_id);


--
-- Name: idx_client_att_by_name_value; Type: INDEX; Schema: public; Owner: valknar
--

CREATE INDEX idx_client_att_by_name_value ON public.client_attributes USING btree (name, substr(value, 1, 255));


--
-- Name: idx_client_id; Type: INDEX; Schema: public; Owner: valknar
--

CREATE INDEX idx_client_id ON public.client USING btree (client_id);


--
-- Name: idx_client_init_acc_realm; Type: INDEX; Schema: public; Owner: valknar
--

CREATE INDEX idx_client_init_acc_realm ON public.client_initial_access USING btree (realm_id);


--
-- Name: idx_clscope_attrs; Type: INDEX; Schema: public; Owner: valknar
--

CREATE INDEX idx_clscope_attrs ON public.client_scope_attributes USING btree (scope_id);


--
-- Name: idx_clscope_cl; Type: INDEX; Schema: public; Owner: valknar
--

CREATE INDEX idx_clscope_cl ON public.client_scope_client USING btree (client_id);


--
-- Name: idx_clscope_protmap; Type: INDEX; Schema: public; Owner: valknar
--

CREATE INDEX idx_clscope_protmap ON public.protocol_mapper USING btree (client_scope_id);


--
-- Name: idx_clscope_role; Type: INDEX; Schema: public; Owner: valknar
--

CREATE INDEX idx_clscope_role ON public.client_scope_role_mapping USING btree (scope_id);


--
-- Name: idx_compo_config_compo; Type: INDEX; Schema: public; Owner: valknar
--

CREATE INDEX idx_compo_config_compo ON public.component_config USING btree (component_id);


--
-- Name: idx_component_provider_type; Type: INDEX; Schema: public; Owner: valknar
--

CREATE INDEX idx_component_provider_type ON public.component USING btree (provider_type);


--
-- Name: idx_component_realm; Type: INDEX; Schema: public; Owner: valknar
--

CREATE INDEX idx_component_realm ON public.component USING btree (realm_id);


--
-- Name: idx_composite; Type: INDEX; Schema: public; Owner: valknar
--

CREATE INDEX idx_composite ON public.composite_role USING btree (composite);


--
-- Name: idx_composite_child; Type: INDEX; Schema: public; Owner: valknar
--

CREATE INDEX idx_composite_child ON public.composite_role USING btree (child_role);


--
-- Name: idx_defcls_realm; Type: INDEX; Schema: public; Owner: valknar
--

CREATE INDEX idx_defcls_realm ON public.default_client_scope USING btree (realm_id);


--
-- Name: idx_defcls_scope; Type: INDEX; Schema: public; Owner: valknar
--

CREATE INDEX idx_defcls_scope ON public.default_client_scope USING btree (scope_id);


--
-- Name: idx_event_entity_user_id_type; Type: INDEX; Schema: public; Owner: valknar
--

CREATE INDEX idx_event_entity_user_id_type ON public.event_entity USING btree (user_id, type, event_time);


--
-- Name: idx_event_time; Type: INDEX; Schema: public; Owner: valknar
--

CREATE INDEX idx_event_time ON public.event_entity USING btree (realm_id, event_time);


--
-- Name: idx_fedidentity_feduser; Type: INDEX; Schema: public; Owner: valknar
--

CREATE INDEX idx_fedidentity_feduser ON public.federated_identity USING btree (federated_user_id);


--
-- Name: idx_fedidentity_user; Type: INDEX; Schema: public; Owner: valknar
--

CREATE INDEX idx_fedidentity_user ON public.federated_identity USING btree (user_id);


--
-- Name: idx_fu_attribute; Type: INDEX; Schema: public; Owner: valknar
--

CREATE INDEX idx_fu_attribute ON public.fed_user_attribute USING btree (user_id, realm_id, name);


--
-- Name: idx_fu_cnsnt_ext; Type: INDEX; Schema: public; Owner: valknar
--

CREATE INDEX idx_fu_cnsnt_ext ON public.fed_user_consent USING btree (user_id, client_storage_provider, external_client_id);


--
-- Name: idx_fu_consent; Type: INDEX; Schema: public; Owner: valknar
--

CREATE INDEX idx_fu_consent ON public.fed_user_consent USING btree (user_id, client_id);


--
-- Name: idx_fu_consent_ru; Type: INDEX; Schema: public; Owner: valknar
--

CREATE INDEX idx_fu_consent_ru ON public.fed_user_consent USING btree (realm_id, user_id);


--
-- Name: idx_fu_credential; Type: INDEX; Schema: public; Owner: valknar
--

CREATE INDEX idx_fu_credential ON public.fed_user_credential USING btree (user_id, type);


--
-- Name: idx_fu_credential_ru; Type: INDEX; Schema: public; Owner: valknar
--

CREATE INDEX idx_fu_credential_ru ON public.fed_user_credential USING btree (realm_id, user_id);


--
-- Name: idx_fu_group_membership; Type: INDEX; Schema: public; Owner: valknar
--

CREATE INDEX idx_fu_group_membership ON public.fed_user_group_membership USING btree (user_id, group_id);


--
-- Name: idx_fu_group_membership_ru; Type: INDEX; Schema: public; Owner: valknar
--

CREATE INDEX idx_fu_group_membership_ru ON public.fed_user_group_membership USING btree (realm_id, user_id);


--
-- Name: idx_fu_required_action; Type: INDEX; Schema: public; Owner: valknar
--

CREATE INDEX idx_fu_required_action ON public.fed_user_required_action USING btree (user_id, required_action);


--
-- Name: idx_fu_required_action_ru; Type: INDEX; Schema: public; Owner: valknar
--

CREATE INDEX idx_fu_required_action_ru ON public.fed_user_required_action USING btree (realm_id, user_id);


--
-- Name: idx_fu_role_mapping; Type: INDEX; Schema: public; Owner: valknar
--

CREATE INDEX idx_fu_role_mapping ON public.fed_user_role_mapping USING btree (user_id, role_id);


--
-- Name: idx_fu_role_mapping_ru; Type: INDEX; Schema: public; Owner: valknar
--

CREATE INDEX idx_fu_role_mapping_ru ON public.fed_user_role_mapping USING btree (realm_id, user_id);


--
-- Name: idx_group_att_by_name_value; Type: INDEX; Schema: public; Owner: valknar
--

CREATE INDEX idx_group_att_by_name_value ON public.group_attribute USING btree (name, ((value)::character varying(250)));


--
-- Name: idx_group_attr_group; Type: INDEX; Schema: public; Owner: valknar
--

CREATE INDEX idx_group_attr_group ON public.group_attribute USING btree (group_id);


--
-- Name: idx_group_role_mapp_group; Type: INDEX; Schema: public; Owner: valknar
--

CREATE INDEX idx_group_role_mapp_group ON public.group_role_mapping USING btree (group_id);


--
-- Name: idx_id_prov_mapp_realm; Type: INDEX; Schema: public; Owner: valknar
--

CREATE INDEX idx_id_prov_mapp_realm ON public.identity_provider_mapper USING btree (realm_id);


--
-- Name: idx_ident_prov_realm; Type: INDEX; Schema: public; Owner: valknar
--

CREATE INDEX idx_ident_prov_realm ON public.identity_provider USING btree (realm_id);


--
-- Name: idx_idp_for_login; Type: INDEX; Schema: public; Owner: valknar
--

CREATE INDEX idx_idp_for_login ON public.identity_provider USING btree (realm_id, enabled, link_only, hide_on_login, organization_id);


--
-- Name: idx_idp_realm_org; Type: INDEX; Schema: public; Owner: valknar
--

CREATE INDEX idx_idp_realm_org ON public.identity_provider USING btree (realm_id, organization_id);


--
-- Name: idx_keycloak_role_client; Type: INDEX; Schema: public; Owner: valknar
--

CREATE INDEX idx_keycloak_role_client ON public.keycloak_role USING btree (client);


--
-- Name: idx_keycloak_role_realm; Type: INDEX; Schema: public; Owner: valknar
--

CREATE INDEX idx_keycloak_role_realm ON public.keycloak_role USING btree (realm);


--
-- Name: idx_offline_uss_by_broker_session_id; Type: INDEX; Schema: public; Owner: valknar
--

CREATE INDEX idx_offline_uss_by_broker_session_id ON public.offline_user_session USING btree (broker_session_id, realm_id);


--
-- Name: idx_offline_uss_by_last_session_refresh; Type: INDEX; Schema: public; Owner: valknar
--

CREATE INDEX idx_offline_uss_by_last_session_refresh ON public.offline_user_session USING btree (realm_id, offline_flag, last_session_refresh);


--
-- Name: idx_offline_uss_by_user; Type: INDEX; Schema: public; Owner: valknar
--

CREATE INDEX idx_offline_uss_by_user ON public.offline_user_session USING btree (user_id, realm_id, offline_flag);


--
-- Name: idx_org_domain_org_id; Type: INDEX; Schema: public; Owner: valknar
--

CREATE INDEX idx_org_domain_org_id ON public.org_domain USING btree (org_id);


--
-- Name: idx_perm_ticket_owner; Type: INDEX; Schema: public; Owner: valknar
--

CREATE INDEX idx_perm_ticket_owner ON public.resource_server_perm_ticket USING btree (owner);


--
-- Name: idx_perm_ticket_requester; Type: INDEX; Schema: public; Owner: valknar
--

CREATE INDEX idx_perm_ticket_requester ON public.resource_server_perm_ticket USING btree (requester);


--
-- Name: idx_protocol_mapper_client; Type: INDEX; Schema: public; Owner: valknar
--

CREATE INDEX idx_protocol_mapper_client ON public.protocol_mapper USING btree (client_id);


--
-- Name: idx_realm_attr_realm; Type: INDEX; Schema: public; Owner: valknar
--

CREATE INDEX idx_realm_attr_realm ON public.realm_attribute USING btree (realm_id);


--
-- Name: idx_realm_clscope; Type: INDEX; Schema: public; Owner: valknar
--

CREATE INDEX idx_realm_clscope ON public.client_scope USING btree (realm_id);


--
-- Name: idx_realm_def_grp_realm; Type: INDEX; Schema: public; Owner: valknar
--

CREATE INDEX idx_realm_def_grp_realm ON public.realm_default_groups USING btree (realm_id);


--
-- Name: idx_realm_evt_list_realm; Type: INDEX; Schema: public; Owner: valknar
--

CREATE INDEX idx_realm_evt_list_realm ON public.realm_events_listeners USING btree (realm_id);


--
-- Name: idx_realm_evt_types_realm; Type: INDEX; Schema: public; Owner: valknar
--

CREATE INDEX idx_realm_evt_types_realm ON public.realm_enabled_event_types USING btree (realm_id);


--
-- Name: idx_realm_master_adm_cli; Type: INDEX; Schema: public; Owner: valknar
--

CREATE INDEX idx_realm_master_adm_cli ON public.realm USING btree (master_admin_client);


--
-- Name: idx_realm_supp_local_realm; Type: INDEX; Schema: public; Owner: valknar
--

CREATE INDEX idx_realm_supp_local_realm ON public.realm_supported_locales USING btree (realm_id);


--
-- Name: idx_redir_uri_client; Type: INDEX; Schema: public; Owner: valknar
--

CREATE INDEX idx_redir_uri_client ON public.redirect_uris USING btree (client_id);


--
-- Name: idx_req_act_prov_realm; Type: INDEX; Schema: public; Owner: valknar
--

CREATE INDEX idx_req_act_prov_realm ON public.required_action_provider USING btree (realm_id);


--
-- Name: idx_res_policy_policy; Type: INDEX; Schema: public; Owner: valknar
--

CREATE INDEX idx_res_policy_policy ON public.resource_policy USING btree (policy_id);


--
-- Name: idx_res_scope_scope; Type: INDEX; Schema: public; Owner: valknar
--

CREATE INDEX idx_res_scope_scope ON public.resource_scope USING btree (scope_id);


--
-- Name: idx_res_serv_pol_res_serv; Type: INDEX; Schema: public; Owner: valknar
--

CREATE INDEX idx_res_serv_pol_res_serv ON public.resource_server_policy USING btree (resource_server_id);


--
-- Name: idx_res_srv_res_res_srv; Type: INDEX; Schema: public; Owner: valknar
--

CREATE INDEX idx_res_srv_res_res_srv ON public.resource_server_resource USING btree (resource_server_id);


--
-- Name: idx_res_srv_scope_res_srv; Type: INDEX; Schema: public; Owner: valknar
--

CREATE INDEX idx_res_srv_scope_res_srv ON public.resource_server_scope USING btree (resource_server_id);


--
-- Name: idx_rev_token_on_expire; Type: INDEX; Schema: public; Owner: valknar
--

CREATE INDEX idx_rev_token_on_expire ON public.revoked_token USING btree (expire);


--
-- Name: idx_role_attribute; Type: INDEX; Schema: public; Owner: valknar
--

CREATE INDEX idx_role_attribute ON public.role_attribute USING btree (role_id);


--
-- Name: idx_role_clscope; Type: INDEX; Schema: public; Owner: valknar
--

CREATE INDEX idx_role_clscope ON public.client_scope_role_mapping USING btree (role_id);


--
-- Name: idx_scope_mapping_role; Type: INDEX; Schema: public; Owner: valknar
--

CREATE INDEX idx_scope_mapping_role ON public.scope_mapping USING btree (role_id);


--
-- Name: idx_scope_policy_policy; Type: INDEX; Schema: public; Owner: valknar
--

CREATE INDEX idx_scope_policy_policy ON public.scope_policy USING btree (policy_id);


--
-- Name: idx_update_time; Type: INDEX; Schema: public; Owner: valknar
--

CREATE INDEX idx_update_time ON public.migration_model USING btree (update_time);


--
-- Name: idx_usconsent_clscope; Type: INDEX; Schema: public; Owner: valknar
--

CREATE INDEX idx_usconsent_clscope ON public.user_consent_client_scope USING btree (user_consent_id);


--
-- Name: idx_usconsent_scope_id; Type: INDEX; Schema: public; Owner: valknar
--

CREATE INDEX idx_usconsent_scope_id ON public.user_consent_client_scope USING btree (scope_id);


--
-- Name: idx_user_attribute; Type: INDEX; Schema: public; Owner: valknar
--

CREATE INDEX idx_user_attribute ON public.user_attribute USING btree (user_id);


--
-- Name: idx_user_attribute_name; Type: INDEX; Schema: public; Owner: valknar
--

CREATE INDEX idx_user_attribute_name ON public.user_attribute USING btree (name, value);


--
-- Name: idx_user_consent; Type: INDEX; Schema: public; Owner: valknar
--

CREATE INDEX idx_user_consent ON public.user_consent USING btree (user_id);


--
-- Name: idx_user_credential; Type: INDEX; Schema: public; Owner: valknar
--

CREATE INDEX idx_user_credential ON public.credential USING btree (user_id);


--
-- Name: idx_user_email; Type: INDEX; Schema: public; Owner: valknar
--

CREATE INDEX idx_user_email ON public.user_entity USING btree (email);


--
-- Name: idx_user_group_mapping; Type: INDEX; Schema: public; Owner: valknar
--

CREATE INDEX idx_user_group_mapping ON public.user_group_membership USING btree (user_id);


--
-- Name: idx_user_reqactions; Type: INDEX; Schema: public; Owner: valknar
--

CREATE INDEX idx_user_reqactions ON public.user_required_action USING btree (user_id);


--
-- Name: idx_user_role_mapping; Type: INDEX; Schema: public; Owner: valknar
--

CREATE INDEX idx_user_role_mapping ON public.user_role_mapping USING btree (user_id);


--
-- Name: idx_user_service_account; Type: INDEX; Schema: public; Owner: valknar
--

CREATE INDEX idx_user_service_account ON public.user_entity USING btree (realm_id, service_account_client_link);


--
-- Name: idx_usr_fed_map_fed_prv; Type: INDEX; Schema: public; Owner: valknar
--

CREATE INDEX idx_usr_fed_map_fed_prv ON public.user_federation_mapper USING btree (federation_provider_id);


--
-- Name: idx_usr_fed_map_realm; Type: INDEX; Schema: public; Owner: valknar
--

CREATE INDEX idx_usr_fed_map_realm ON public.user_federation_mapper USING btree (realm_id);


--
-- Name: idx_usr_fed_prv_realm; Type: INDEX; Schema: public; Owner: valknar
--

CREATE INDEX idx_usr_fed_prv_realm ON public.user_federation_provider USING btree (realm_id);


--
-- Name: idx_web_orig_client; Type: INDEX; Schema: public; Owner: valknar
--

CREATE INDEX idx_web_orig_client ON public.web_origins USING btree (client_id);


--
-- Name: idx_workflow_state_provider; Type: INDEX; Schema: public; Owner: valknar
--

CREATE INDEX idx_workflow_state_provider ON public.workflow_state USING btree (resource_id, workflow_provider_id);


--
-- Name: idx_workflow_state_step; Type: INDEX; Schema: public; Owner: valknar
--

CREATE INDEX idx_workflow_state_step ON public.workflow_state USING btree (workflow_id, scheduled_step_id);


--
-- Name: user_attr_long_values; Type: INDEX; Schema: public; Owner: valknar
--

CREATE INDEX user_attr_long_values ON public.user_attribute USING btree (long_value_hash, name);


--
-- Name: user_attr_long_values_lower_case; Type: INDEX; Schema: public; Owner: valknar
--

CREATE INDEX user_attr_long_values_lower_case ON public.user_attribute USING btree (long_value_hash_lower_case, name);


--
-- Name: identity_provider fk2b4ebc52ae5c3b34; Type: FK CONSTRAINT; Schema: public; Owner: valknar
--

ALTER TABLE ONLY public.identity_provider
    ADD CONSTRAINT fk2b4ebc52ae5c3b34 FOREIGN KEY (realm_id) REFERENCES public.realm(id);


--
-- Name: client_attributes fk3c47c64beacca966; Type: FK CONSTRAINT; Schema: public; Owner: valknar
--

ALTER TABLE ONLY public.client_attributes
    ADD CONSTRAINT fk3c47c64beacca966 FOREIGN KEY (client_id) REFERENCES public.client(id);


--
-- Name: federated_identity fk404288b92ef007a6; Type: FK CONSTRAINT; Schema: public; Owner: valknar
--

ALTER TABLE ONLY public.federated_identity
    ADD CONSTRAINT fk404288b92ef007a6 FOREIGN KEY (user_id) REFERENCES public.user_entity(id);


--
-- Name: client_node_registrations fk4129723ba992f594; Type: FK CONSTRAINT; Schema: public; Owner: valknar
--

ALTER TABLE ONLY public.client_node_registrations
    ADD CONSTRAINT fk4129723ba992f594 FOREIGN KEY (client_id) REFERENCES public.client(id);


--
-- Name: redirect_uris fk_1burs8pb4ouj97h5wuppahv9f; Type: FK CONSTRAINT; Schema: public; Owner: valknar
--

ALTER TABLE ONLY public.redirect_uris
    ADD CONSTRAINT fk_1burs8pb4ouj97h5wuppahv9f FOREIGN KEY (client_id) REFERENCES public.client(id);


--
-- Name: user_federation_provider fk_1fj32f6ptolw2qy60cd8n01e8; Type: FK CONSTRAINT; Schema: public; Owner: valknar
--

ALTER TABLE ONLY public.user_federation_provider
    ADD CONSTRAINT fk_1fj32f6ptolw2qy60cd8n01e8 FOREIGN KEY (realm_id) REFERENCES public.realm(id);


--
-- Name: realm_required_credential fk_5hg65lybevavkqfki3kponh9v; Type: FK CONSTRAINT; Schema: public; Owner: valknar
--

ALTER TABLE ONLY public.realm_required_credential
    ADD CONSTRAINT fk_5hg65lybevavkqfki3kponh9v FOREIGN KEY (realm_id) REFERENCES public.realm(id);


--
-- Name: resource_attribute fk_5hrm2vlf9ql5fu022kqepovbr; Type: FK CONSTRAINT; Schema: public; Owner: valknar
--

ALTER TABLE ONLY public.resource_attribute
    ADD CONSTRAINT fk_5hrm2vlf9ql5fu022kqepovbr FOREIGN KEY (resource_id) REFERENCES public.resource_server_resource(id);


--
-- Name: user_attribute fk_5hrm2vlf9ql5fu043kqepovbr; Type: FK CONSTRAINT; Schema: public; Owner: valknar
--

ALTER TABLE ONLY public.user_attribute
    ADD CONSTRAINT fk_5hrm2vlf9ql5fu043kqepovbr FOREIGN KEY (user_id) REFERENCES public.user_entity(id);


--
-- Name: user_required_action fk_6qj3w1jw9cvafhe19bwsiuvmd; Type: FK CONSTRAINT; Schema: public; Owner: valknar
--

ALTER TABLE ONLY public.user_required_action
    ADD CONSTRAINT fk_6qj3w1jw9cvafhe19bwsiuvmd FOREIGN KEY (user_id) REFERENCES public.user_entity(id);


--
-- Name: keycloak_role fk_6vyqfe4cn4wlq8r6kt5vdsj5c; Type: FK CONSTRAINT; Schema: public; Owner: valknar
--

ALTER TABLE ONLY public.keycloak_role
    ADD CONSTRAINT fk_6vyqfe4cn4wlq8r6kt5vdsj5c FOREIGN KEY (realm) REFERENCES public.realm(id);


--
-- Name: realm_smtp_config fk_70ej8xdxgxd0b9hh6180irr0o; Type: FK CONSTRAINT; Schema: public; Owner: valknar
--

ALTER TABLE ONLY public.realm_smtp_config
    ADD CONSTRAINT fk_70ej8xdxgxd0b9hh6180irr0o FOREIGN KEY (realm_id) REFERENCES public.realm(id);


--
-- Name: realm_attribute fk_8shxd6l3e9atqukacxgpffptw; Type: FK CONSTRAINT; Schema: public; Owner: valknar
--

ALTER TABLE ONLY public.realm_attribute
    ADD CONSTRAINT fk_8shxd6l3e9atqukacxgpffptw FOREIGN KEY (realm_id) REFERENCES public.realm(id);


--
-- Name: composite_role fk_a63wvekftu8jo1pnj81e7mce2; Type: FK CONSTRAINT; Schema: public; Owner: valknar
--

ALTER TABLE ONLY public.composite_role
    ADD CONSTRAINT fk_a63wvekftu8jo1pnj81e7mce2 FOREIGN KEY (composite) REFERENCES public.keycloak_role(id);


--
-- Name: authentication_execution fk_auth_exec_flow; Type: FK CONSTRAINT; Schema: public; Owner: valknar
--

ALTER TABLE ONLY public.authentication_execution
    ADD CONSTRAINT fk_auth_exec_flow FOREIGN KEY (flow_id) REFERENCES public.authentication_flow(id);


--
-- Name: authentication_execution fk_auth_exec_realm; Type: FK CONSTRAINT; Schema: public; Owner: valknar
--

ALTER TABLE ONLY public.authentication_execution
    ADD CONSTRAINT fk_auth_exec_realm FOREIGN KEY (realm_id) REFERENCES public.realm(id);


--
-- Name: authentication_flow fk_auth_flow_realm; Type: FK CONSTRAINT; Schema: public; Owner: valknar
--

ALTER TABLE ONLY public.authentication_flow
    ADD CONSTRAINT fk_auth_flow_realm FOREIGN KEY (realm_id) REFERENCES public.realm(id);


--
-- Name: authenticator_config fk_auth_realm; Type: FK CONSTRAINT; Schema: public; Owner: valknar
--

ALTER TABLE ONLY public.authenticator_config
    ADD CONSTRAINT fk_auth_realm FOREIGN KEY (realm_id) REFERENCES public.realm(id);


--
-- Name: user_role_mapping fk_c4fqv34p1mbylloxang7b1q3l; Type: FK CONSTRAINT; Schema: public; Owner: valknar
--

ALTER TABLE ONLY public.user_role_mapping
    ADD CONSTRAINT fk_c4fqv34p1mbylloxang7b1q3l FOREIGN KEY (user_id) REFERENCES public.user_entity(id);


--
-- Name: client_scope_attributes fk_cl_scope_attr_scope; Type: FK CONSTRAINT; Schema: public; Owner: valknar
--

ALTER TABLE ONLY public.client_scope_attributes
    ADD CONSTRAINT fk_cl_scope_attr_scope FOREIGN KEY (scope_id) REFERENCES public.client_scope(id);


--
-- Name: client_scope_role_mapping fk_cl_scope_rm_scope; Type: FK CONSTRAINT; Schema: public; Owner: valknar
--

ALTER TABLE ONLY public.client_scope_role_mapping
    ADD CONSTRAINT fk_cl_scope_rm_scope FOREIGN KEY (scope_id) REFERENCES public.client_scope(id);


--
-- Name: protocol_mapper fk_cli_scope_mapper; Type: FK CONSTRAINT; Schema: public; Owner: valknar
--

ALTER TABLE ONLY public.protocol_mapper
    ADD CONSTRAINT fk_cli_scope_mapper FOREIGN KEY (client_scope_id) REFERENCES public.client_scope(id);


--
-- Name: client_initial_access fk_client_init_acc_realm; Type: FK CONSTRAINT; Schema: public; Owner: valknar
--

ALTER TABLE ONLY public.client_initial_access
    ADD CONSTRAINT fk_client_init_acc_realm FOREIGN KEY (realm_id) REFERENCES public.realm(id);


--
-- Name: component_config fk_component_config; Type: FK CONSTRAINT; Schema: public; Owner: valknar
--

ALTER TABLE ONLY public.component_config
    ADD CONSTRAINT fk_component_config FOREIGN KEY (component_id) REFERENCES public.component(id);


--
-- Name: component fk_component_realm; Type: FK CONSTRAINT; Schema: public; Owner: valknar
--

ALTER TABLE ONLY public.component
    ADD CONSTRAINT fk_component_realm FOREIGN KEY (realm_id) REFERENCES public.realm(id);


--
-- Name: realm_default_groups fk_def_groups_realm; Type: FK CONSTRAINT; Schema: public; Owner: valknar
--

ALTER TABLE ONLY public.realm_default_groups
    ADD CONSTRAINT fk_def_groups_realm FOREIGN KEY (realm_id) REFERENCES public.realm(id);


--
-- Name: user_federation_mapper_config fk_fedmapper_cfg; Type: FK CONSTRAINT; Schema: public; Owner: valknar
--

ALTER TABLE ONLY public.user_federation_mapper_config
    ADD CONSTRAINT fk_fedmapper_cfg FOREIGN KEY (user_federation_mapper_id) REFERENCES public.user_federation_mapper(id);


--
-- Name: user_federation_mapper fk_fedmapperpm_fedprv; Type: FK CONSTRAINT; Schema: public; Owner: valknar
--

ALTER TABLE ONLY public.user_federation_mapper
    ADD CONSTRAINT fk_fedmapperpm_fedprv FOREIGN KEY (federation_provider_id) REFERENCES public.user_federation_provider(id);


--
-- Name: user_federation_mapper fk_fedmapperpm_realm; Type: FK CONSTRAINT; Schema: public; Owner: valknar
--

ALTER TABLE ONLY public.user_federation_mapper
    ADD CONSTRAINT fk_fedmapperpm_realm FOREIGN KEY (realm_id) REFERENCES public.realm(id);


--
-- Name: associated_policy fk_frsr5s213xcx4wnkog82ssrfy; Type: FK CONSTRAINT; Schema: public; Owner: valknar
--

ALTER TABLE ONLY public.associated_policy
    ADD CONSTRAINT fk_frsr5s213xcx4wnkog82ssrfy FOREIGN KEY (associated_policy_id) REFERENCES public.resource_server_policy(id);


--
-- Name: scope_policy fk_frsrasp13xcx4wnkog82ssrfy; Type: FK CONSTRAINT; Schema: public; Owner: valknar
--

ALTER TABLE ONLY public.scope_policy
    ADD CONSTRAINT fk_frsrasp13xcx4wnkog82ssrfy FOREIGN KEY (policy_id) REFERENCES public.resource_server_policy(id);


--
-- Name: resource_server_perm_ticket fk_frsrho213xcx4wnkog82sspmt; Type: FK CONSTRAINT; Schema: public; Owner: valknar
--

ALTER TABLE ONLY public.resource_server_perm_ticket
    ADD CONSTRAINT fk_frsrho213xcx4wnkog82sspmt FOREIGN KEY (resource_server_id) REFERENCES public.resource_server(id);


--
-- Name: resource_server_resource fk_frsrho213xcx4wnkog82ssrfy; Type: FK CONSTRAINT; Schema: public; Owner: valknar
--

ALTER TABLE ONLY public.resource_server_resource
    ADD CONSTRAINT fk_frsrho213xcx4wnkog82ssrfy FOREIGN KEY (resource_server_id) REFERENCES public.resource_server(id);


--
-- Name: resource_server_perm_ticket fk_frsrho213xcx4wnkog83sspmt; Type: FK CONSTRAINT; Schema: public; Owner: valknar
--

ALTER TABLE ONLY public.resource_server_perm_ticket
    ADD CONSTRAINT fk_frsrho213xcx4wnkog83sspmt FOREIGN KEY (resource_id) REFERENCES public.resource_server_resource(id);


--
-- Name: resource_server_perm_ticket fk_frsrho213xcx4wnkog84sspmt; Type: FK CONSTRAINT; Schema: public; Owner: valknar
--

ALTER TABLE ONLY public.resource_server_perm_ticket
    ADD CONSTRAINT fk_frsrho213xcx4wnkog84sspmt FOREIGN KEY (scope_id) REFERENCES public.resource_server_scope(id);


--
-- Name: associated_policy fk_frsrpas14xcx4wnkog82ssrfy; Type: FK CONSTRAINT; Schema: public; Owner: valknar
--

ALTER TABLE ONLY public.associated_policy
    ADD CONSTRAINT fk_frsrpas14xcx4wnkog82ssrfy FOREIGN KEY (policy_id) REFERENCES public.resource_server_policy(id);


--
-- Name: scope_policy fk_frsrpass3xcx4wnkog82ssrfy; Type: FK CONSTRAINT; Schema: public; Owner: valknar
--

ALTER TABLE ONLY public.scope_policy
    ADD CONSTRAINT fk_frsrpass3xcx4wnkog82ssrfy FOREIGN KEY (scope_id) REFERENCES public.resource_server_scope(id);


--
-- Name: resource_server_perm_ticket fk_frsrpo2128cx4wnkog82ssrfy; Type: FK CONSTRAINT; Schema: public; Owner: valknar
--

ALTER TABLE ONLY public.resource_server_perm_ticket
    ADD CONSTRAINT fk_frsrpo2128cx4wnkog82ssrfy FOREIGN KEY (policy_id) REFERENCES public.resource_server_policy(id);


--
-- Name: resource_server_policy fk_frsrpo213xcx4wnkog82ssrfy; Type: FK CONSTRAINT; Schema: public; Owner: valknar
--

ALTER TABLE ONLY public.resource_server_policy
    ADD CONSTRAINT fk_frsrpo213xcx4wnkog82ssrfy FOREIGN KEY (resource_server_id) REFERENCES public.resource_server(id);


--
-- Name: resource_scope fk_frsrpos13xcx4wnkog82ssrfy; Type: FK CONSTRAINT; Schema: public; Owner: valknar
--

ALTER TABLE ONLY public.resource_scope
    ADD CONSTRAINT fk_frsrpos13xcx4wnkog82ssrfy FOREIGN KEY (resource_id) REFERENCES public.resource_server_resource(id);


--
-- Name: resource_policy fk_frsrpos53xcx4wnkog82ssrfy; Type: FK CONSTRAINT; Schema: public; Owner: valknar
--

ALTER TABLE ONLY public.resource_policy
    ADD CONSTRAINT fk_frsrpos53xcx4wnkog82ssrfy FOREIGN KEY (resource_id) REFERENCES public.resource_server_resource(id);


--
-- Name: resource_policy fk_frsrpp213xcx4wnkog82ssrfy; Type: FK CONSTRAINT; Schema: public; Owner: valknar
--

ALTER TABLE ONLY public.resource_policy
    ADD CONSTRAINT fk_frsrpp213xcx4wnkog82ssrfy FOREIGN KEY (policy_id) REFERENCES public.resource_server_policy(id);


--
-- Name: resource_scope fk_frsrps213xcx4wnkog82ssrfy; Type: FK CONSTRAINT; Schema: public; Owner: valknar
--

ALTER TABLE ONLY public.resource_scope
    ADD CONSTRAINT fk_frsrps213xcx4wnkog82ssrfy FOREIGN KEY (scope_id) REFERENCES public.resource_server_scope(id);


--
-- Name: resource_server_scope fk_frsrso213xcx4wnkog82ssrfy; Type: FK CONSTRAINT; Schema: public; Owner: valknar
--

ALTER TABLE ONLY public.resource_server_scope
    ADD CONSTRAINT fk_frsrso213xcx4wnkog82ssrfy FOREIGN KEY (resource_server_id) REFERENCES public.resource_server(id);


--
-- Name: composite_role fk_gr7thllb9lu8q4vqa4524jjy8; Type: FK CONSTRAINT; Schema: public; Owner: valknar
--

ALTER TABLE ONLY public.composite_role
    ADD CONSTRAINT fk_gr7thllb9lu8q4vqa4524jjy8 FOREIGN KEY (child_role) REFERENCES public.keycloak_role(id);


--
-- Name: user_consent_client_scope fk_grntcsnt_clsc_usc; Type: FK CONSTRAINT; Schema: public; Owner: valknar
--

ALTER TABLE ONLY public.user_consent_client_scope
    ADD CONSTRAINT fk_grntcsnt_clsc_usc FOREIGN KEY (user_consent_id) REFERENCES public.user_consent(id);


--
-- Name: user_consent fk_grntcsnt_user; Type: FK CONSTRAINT; Schema: public; Owner: valknar
--

ALTER TABLE ONLY public.user_consent
    ADD CONSTRAINT fk_grntcsnt_user FOREIGN KEY (user_id) REFERENCES public.user_entity(id);


--
-- Name: group_attribute fk_group_attribute_group; Type: FK CONSTRAINT; Schema: public; Owner: valknar
--

ALTER TABLE ONLY public.group_attribute
    ADD CONSTRAINT fk_group_attribute_group FOREIGN KEY (group_id) REFERENCES public.keycloak_group(id);


--
-- Name: group_role_mapping fk_group_role_group; Type: FK CONSTRAINT; Schema: public; Owner: valknar
--

ALTER TABLE ONLY public.group_role_mapping
    ADD CONSTRAINT fk_group_role_group FOREIGN KEY (group_id) REFERENCES public.keycloak_group(id);


--
-- Name: realm_enabled_event_types fk_h846o4h0w8epx5nwedrf5y69j; Type: FK CONSTRAINT; Schema: public; Owner: valknar
--

ALTER TABLE ONLY public.realm_enabled_event_types
    ADD CONSTRAINT fk_h846o4h0w8epx5nwedrf5y69j FOREIGN KEY (realm_id) REFERENCES public.realm(id);


--
-- Name: realm_events_listeners fk_h846o4h0w8epx5nxev9f5y69j; Type: FK CONSTRAINT; Schema: public; Owner: valknar
--

ALTER TABLE ONLY public.realm_events_listeners
    ADD CONSTRAINT fk_h846o4h0w8epx5nxev9f5y69j FOREIGN KEY (realm_id) REFERENCES public.realm(id);


--
-- Name: identity_provider_mapper fk_idpm_realm; Type: FK CONSTRAINT; Schema: public; Owner: valknar
--

ALTER TABLE ONLY public.identity_provider_mapper
    ADD CONSTRAINT fk_idpm_realm FOREIGN KEY (realm_id) REFERENCES public.realm(id);


--
-- Name: idp_mapper_config fk_idpmconfig; Type: FK CONSTRAINT; Schema: public; Owner: valknar
--

ALTER TABLE ONLY public.idp_mapper_config
    ADD CONSTRAINT fk_idpmconfig FOREIGN KEY (idp_mapper_id) REFERENCES public.identity_provider_mapper(id);


--
-- Name: web_origins fk_lojpho213xcx4wnkog82ssrfy; Type: FK CONSTRAINT; Schema: public; Owner: valknar
--

ALTER TABLE ONLY public.web_origins
    ADD CONSTRAINT fk_lojpho213xcx4wnkog82ssrfy FOREIGN KEY (client_id) REFERENCES public.client(id);


--
-- Name: scope_mapping fk_ouse064plmlr732lxjcn1q5f1; Type: FK CONSTRAINT; Schema: public; Owner: valknar
--

ALTER TABLE ONLY public.scope_mapping
    ADD CONSTRAINT fk_ouse064plmlr732lxjcn1q5f1 FOREIGN KEY (client_id) REFERENCES public.client(id);


--
-- Name: protocol_mapper fk_pcm_realm; Type: FK CONSTRAINT; Schema: public; Owner: valknar
--

ALTER TABLE ONLY public.protocol_mapper
    ADD CONSTRAINT fk_pcm_realm FOREIGN KEY (client_id) REFERENCES public.client(id);


--
-- Name: credential fk_pfyr0glasqyl0dei3kl69r6v0; Type: FK CONSTRAINT; Schema: public; Owner: valknar
--

ALTER TABLE ONLY public.credential
    ADD CONSTRAINT fk_pfyr0glasqyl0dei3kl69r6v0 FOREIGN KEY (user_id) REFERENCES public.user_entity(id);


--
-- Name: protocol_mapper_config fk_pmconfig; Type: FK CONSTRAINT; Schema: public; Owner: valknar
--

ALTER TABLE ONLY public.protocol_mapper_config
    ADD CONSTRAINT fk_pmconfig FOREIGN KEY (protocol_mapper_id) REFERENCES public.protocol_mapper(id);


--
-- Name: default_client_scope fk_r_def_cli_scope_realm; Type: FK CONSTRAINT; Schema: public; Owner: valknar
--

ALTER TABLE ONLY public.default_client_scope
    ADD CONSTRAINT fk_r_def_cli_scope_realm FOREIGN KEY (realm_id) REFERENCES public.realm(id);


--
-- Name: required_action_provider fk_req_act_realm; Type: FK CONSTRAINT; Schema: public; Owner: valknar
--

ALTER TABLE ONLY public.required_action_provider
    ADD CONSTRAINT fk_req_act_realm FOREIGN KEY (realm_id) REFERENCES public.realm(id);


--
-- Name: resource_uris fk_resource_server_uris; Type: FK CONSTRAINT; Schema: public; Owner: valknar
--

ALTER TABLE ONLY public.resource_uris
    ADD CONSTRAINT fk_resource_server_uris FOREIGN KEY (resource_id) REFERENCES public.resource_server_resource(id);


--
-- Name: role_attribute fk_role_attribute_id; Type: FK CONSTRAINT; Schema: public; Owner: valknar
--

ALTER TABLE ONLY public.role_attribute
    ADD CONSTRAINT fk_role_attribute_id FOREIGN KEY (role_id) REFERENCES public.keycloak_role(id);


--
-- Name: realm_supported_locales fk_supported_locales_realm; Type: FK CONSTRAINT; Schema: public; Owner: valknar
--

ALTER TABLE ONLY public.realm_supported_locales
    ADD CONSTRAINT fk_supported_locales_realm FOREIGN KEY (realm_id) REFERENCES public.realm(id);


--
-- Name: user_federation_config fk_t13hpu1j94r2ebpekr39x5eu5; Type: FK CONSTRAINT; Schema: public; Owner: valknar
--

ALTER TABLE ONLY public.user_federation_config
    ADD CONSTRAINT fk_t13hpu1j94r2ebpekr39x5eu5 FOREIGN KEY (user_federation_provider_id) REFERENCES public.user_federation_provider(id);


--
-- Name: user_group_membership fk_user_group_user; Type: FK CONSTRAINT; Schema: public; Owner: valknar
--

ALTER TABLE ONLY public.user_group_membership
    ADD CONSTRAINT fk_user_group_user FOREIGN KEY (user_id) REFERENCES public.user_entity(id);


--
-- Name: policy_config fkdc34197cf864c4e43; Type: FK CONSTRAINT; Schema: public; Owner: valknar
--

ALTER TABLE ONLY public.policy_config
    ADD CONSTRAINT fkdc34197cf864c4e43 FOREIGN KEY (policy_id) REFERENCES public.resource_server_policy(id);


--
-- Name: identity_provider_config fkdc4897cf864c4e43; Type: FK CONSTRAINT; Schema: public; Owner: valknar
--

ALTER TABLE ONLY public.identity_provider_config
    ADD CONSTRAINT fkdc4897cf864c4e43 FOREIGN KEY (identity_provider_id) REFERENCES public.identity_provider(internal_id);


--
-- PostgreSQL database dump complete
--

\unrestrict liCUlxQpiok7ivN6vHt8brlg0pfUuyPTUlO5nr0ftqRtGThGUM8otBygfhEOnyj

