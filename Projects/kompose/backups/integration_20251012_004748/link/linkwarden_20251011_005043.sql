--
-- PostgreSQL database dump
--

\restrict Jr7bpL5DlbYOT9anYLBvMPUgL3LrKNkSpKPc66trPomFLzSKpFL54Nc8y77NUXM

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
-- Name: AiTaggingMethod; Type: TYPE; Schema: public; Owner: valknar
--

CREATE TYPE public."AiTaggingMethod" AS ENUM (
    'DISABLED',
    'GENERATE',
    'PREDEFINED',
    'EXISTING'
);


ALTER TYPE public."AiTaggingMethod" OWNER TO valknar;

--
-- Name: DashboardSectionType; Type: TYPE; Schema: public; Owner: valknar
--

CREATE TYPE public."DashboardSectionType" AS ENUM (
    'STATS',
    'RECENT_LINKS',
    'PINNED_LINKS',
    'COLLECTION'
);


ALTER TYPE public."DashboardSectionType" OWNER TO valknar;

--
-- Name: LinksRouteTo; Type: TYPE; Schema: public; Owner: valknar
--

CREATE TYPE public."LinksRouteTo" AS ENUM (
    'ORIGINAL',
    'PDF',
    'READABLE',
    'MONOLITH',
    'SCREENSHOT',
    'DETAILS'
);


ALTER TYPE public."LinksRouteTo" OWNER TO valknar;

--
-- Name: Theme; Type: TYPE; Schema: public; Owner: valknar
--

CREATE TYPE public."Theme" AS ENUM (
    'dark',
    'light',
    'auto'
);


ALTER TYPE public."Theme" OWNER TO valknar;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: AccessToken; Type: TABLE; Schema: public; Owner: valknar
--

CREATE TABLE public."AccessToken" (
    id integer NOT NULL,
    name text NOT NULL,
    "userId" integer NOT NULL,
    token text NOT NULL,
    revoked boolean DEFAULT false NOT NULL,
    expires timestamp(3) without time zone NOT NULL,
    "lastUsedAt" timestamp(3) without time zone,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "updatedAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "isSession" boolean DEFAULT false NOT NULL
);


ALTER TABLE public."AccessToken" OWNER TO valknar;

--
-- Name: AccessToken_id_seq; Type: SEQUENCE; Schema: public; Owner: valknar
--

CREATE SEQUENCE public."AccessToken_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public."AccessToken_id_seq" OWNER TO valknar;

--
-- Name: AccessToken_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: valknar
--

ALTER SEQUENCE public."AccessToken_id_seq" OWNED BY public."AccessToken".id;


--
-- Name: Account; Type: TABLE; Schema: public; Owner: valknar
--

CREATE TABLE public."Account" (
    id text NOT NULL,
    "userId" integer NOT NULL,
    type text NOT NULL,
    provider text NOT NULL,
    "providerAccountId" text NOT NULL,
    refresh_token text,
    access_token text,
    expires_at integer,
    token_type text,
    scope text,
    id_token text,
    session_state text
);


ALTER TABLE public."Account" OWNER TO valknar;

--
-- Name: Collection; Type: TABLE; Schema: public; Owner: valknar
--

CREATE TABLE public."Collection" (
    id integer NOT NULL,
    name text NOT NULL,
    description text DEFAULT ''::text NOT NULL,
    color text DEFAULT '#0ea5e9'::text NOT NULL,
    "isPublic" boolean DEFAULT false NOT NULL,
    "ownerId" integer NOT NULL,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "updatedAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "parentId" integer,
    icon text,
    "iconWeight" text,
    "createdById" integer
);


ALTER TABLE public."Collection" OWNER TO valknar;

--
-- Name: Collection_id_seq; Type: SEQUENCE; Schema: public; Owner: valknar
--

CREATE SEQUENCE public."Collection_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public."Collection_id_seq" OWNER TO valknar;

--
-- Name: Collection_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: valknar
--

ALTER SEQUENCE public."Collection_id_seq" OWNED BY public."Collection".id;


--
-- Name: DashboardSection; Type: TABLE; Schema: public; Owner: valknar
--

CREATE TABLE public."DashboardSection" (
    id integer NOT NULL,
    "userId" integer NOT NULL,
    "collectionId" integer,
    type public."DashboardSectionType" NOT NULL,
    "order" integer NOT NULL,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "updatedAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE public."DashboardSection" OWNER TO valknar;

--
-- Name: DashboardSection_id_seq; Type: SEQUENCE; Schema: public; Owner: valknar
--

CREATE SEQUENCE public."DashboardSection_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public."DashboardSection_id_seq" OWNER TO valknar;

--
-- Name: DashboardSection_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: valknar
--

ALTER SEQUENCE public."DashboardSection_id_seq" OWNED BY public."DashboardSection".id;


--
-- Name: Highlight; Type: TABLE; Schema: public; Owner: valknar
--

CREATE TABLE public."Highlight" (
    id integer NOT NULL,
    color text NOT NULL,
    comment text,
    "linkId" integer NOT NULL,
    "userId" integer NOT NULL,
    "startOffset" integer NOT NULL,
    "endOffset" integer NOT NULL,
    text text NOT NULL,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "updatedAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE public."Highlight" OWNER TO valknar;

--
-- Name: Highlight_id_seq; Type: SEQUENCE; Schema: public; Owner: valknar
--

CREATE SEQUENCE public."Highlight_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public."Highlight_id_seq" OWNER TO valknar;

--
-- Name: Highlight_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: valknar
--

ALTER SEQUENCE public."Highlight_id_seq" OWNED BY public."Highlight".id;


--
-- Name: Link; Type: TABLE; Schema: public; Owner: valknar
--

CREATE TABLE public."Link" (
    id integer NOT NULL,
    name text DEFAULT ''::text NOT NULL,
    url text,
    description text DEFAULT ''::text NOT NULL,
    "collectionId" integer NOT NULL,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    pdf text,
    image text,
    "updatedAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    readable text,
    "lastPreserved" timestamp(3) without time zone,
    "textContent" text,
    type text DEFAULT 'url'::text NOT NULL,
    preview text,
    "importDate" timestamp(3) without time zone,
    monolith text,
    color text,
    icon text,
    "iconWeight" text,
    "createdById" integer,
    "aiTagged" boolean DEFAULT false NOT NULL,
    "indexVersion" integer,
    "clientSide" boolean DEFAULT false NOT NULL
);


ALTER TABLE public."Link" OWNER TO valknar;

--
-- Name: Link_id_seq; Type: SEQUENCE; Schema: public; Owner: valknar
--

CREATE SEQUENCE public."Link_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public."Link_id_seq" OWNER TO valknar;

--
-- Name: Link_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: valknar
--

ALTER SEQUENCE public."Link_id_seq" OWNED BY public."Link".id;


--
-- Name: PasswordResetToken; Type: TABLE; Schema: public; Owner: valknar
--

CREATE TABLE public."PasswordResetToken" (
    identifier text NOT NULL,
    token text NOT NULL,
    expires timestamp(3) without time zone NOT NULL,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "updatedAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE public."PasswordResetToken" OWNER TO valknar;

--
-- Name: RssSubscription; Type: TABLE; Schema: public; Owner: valknar
--

CREATE TABLE public."RssSubscription" (
    id integer NOT NULL,
    url text NOT NULL,
    name text NOT NULL,
    "lastBuildDate" timestamp(3) without time zone,
    "collectionId" integer NOT NULL,
    "ownerId" integer NOT NULL,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "updatedAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE public."RssSubscription" OWNER TO valknar;

--
-- Name: RssSubscription_id_seq; Type: SEQUENCE; Schema: public; Owner: valknar
--

CREATE SEQUENCE public."RssSubscription_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public."RssSubscription_id_seq" OWNER TO valknar;

--
-- Name: RssSubscription_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: valknar
--

ALTER SEQUENCE public."RssSubscription_id_seq" OWNED BY public."RssSubscription".id;


--
-- Name: Subscription; Type: TABLE; Schema: public; Owner: valknar
--

CREATE TABLE public."Subscription" (
    id integer NOT NULL,
    active boolean NOT NULL,
    "stripeSubscriptionId" text NOT NULL,
    "currentPeriodStart" timestamp(3) without time zone NOT NULL,
    "currentPeriodEnd" timestamp(3) without time zone NOT NULL,
    "userId" integer NOT NULL,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "updatedAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    quantity integer DEFAULT 1 NOT NULL
);


ALTER TABLE public."Subscription" OWNER TO valknar;

--
-- Name: Subscription_id_seq; Type: SEQUENCE; Schema: public; Owner: valknar
--

CREATE SEQUENCE public."Subscription_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public."Subscription_id_seq" OWNER TO valknar;

--
-- Name: Subscription_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: valknar
--

ALTER SEQUENCE public."Subscription_id_seq" OWNED BY public."Subscription".id;


--
-- Name: Tag; Type: TABLE; Schema: public; Owner: valknar
--

CREATE TABLE public."Tag" (
    id integer NOT NULL,
    name text NOT NULL,
    "ownerId" integer NOT NULL,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "updatedAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "archiveAsMonolith" boolean,
    "archiveAsPDF" boolean,
    "archiveAsReadable" boolean,
    "archiveAsScreenshot" boolean,
    "archiveAsWaybackMachine" boolean,
    "aiTag" boolean,
    "aiGenerated" boolean DEFAULT false NOT NULL
);


ALTER TABLE public."Tag" OWNER TO valknar;

--
-- Name: Tag_id_seq; Type: SEQUENCE; Schema: public; Owner: valknar
--

CREATE SEQUENCE public."Tag_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public."Tag_id_seq" OWNER TO valknar;

--
-- Name: Tag_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: valknar
--

ALTER SEQUENCE public."Tag_id_seq" OWNED BY public."Tag".id;


--
-- Name: User; Type: TABLE; Schema: public; Owner: valknar
--

CREATE TABLE public."User" (
    id integer NOT NULL,
    name text,
    username text,
    email text,
    "emailVerified" timestamp(3) without time zone,
    password text,
    "isPrivate" boolean DEFAULT false NOT NULL,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "archiveAsPDF" boolean DEFAULT true NOT NULL,
    "archiveAsScreenshot" boolean DEFAULT true NOT NULL,
    "archiveAsWaybackMachine" boolean DEFAULT false NOT NULL,
    image text,
    "updatedAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "linksRouteTo" public."LinksRouteTo" DEFAULT 'ORIGINAL'::public."LinksRouteTo" NOT NULL,
    "collectionOrder" integer[] DEFAULT ARRAY[]::integer[],
    "preventDuplicateLinks" boolean DEFAULT false NOT NULL,
    "unverifiedNewEmail" text,
    locale text DEFAULT 'en'::text NOT NULL,
    "archiveAsMonolith" boolean DEFAULT true NOT NULL,
    "parentSubscriptionId" integer,
    "referredBy" text,
    "aiPredefinedTags" text[] DEFAULT ARRAY[]::text[],
    "aiTaggingMethod" public."AiTaggingMethod" DEFAULT 'DISABLED'::public."AiTaggingMethod" NOT NULL,
    "aiTagExistingLinks" boolean DEFAULT false NOT NULL,
    "archiveAsReadable" boolean DEFAULT true NOT NULL,
    "readableFontFamily" text DEFAULT 'sans-serif'::text,
    "readableFontSize" text DEFAULT '20px'::text,
    "readableLineHeight" text DEFAULT '1.8'::text,
    "readableLineWidth" text DEFAULT 'normal'::text,
    theme public."Theme" DEFAULT 'dark'::public."Theme" NOT NULL,
    "lastPickedAt" timestamp(3) without time zone,
    "acceptPromotionalEmails" boolean DEFAULT false NOT NULL
);


ALTER TABLE public."User" OWNER TO valknar;

--
-- Name: User_id_seq; Type: SEQUENCE; Schema: public; Owner: valknar
--

CREATE SEQUENCE public."User_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public."User_id_seq" OWNER TO valknar;

--
-- Name: User_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: valknar
--

ALTER SEQUENCE public."User_id_seq" OWNED BY public."User".id;


--
-- Name: UsersAndCollections; Type: TABLE; Schema: public; Owner: valknar
--

CREATE TABLE public."UsersAndCollections" (
    "userId" integer NOT NULL,
    "collectionId" integer NOT NULL,
    "canCreate" boolean NOT NULL,
    "canUpdate" boolean NOT NULL,
    "canDelete" boolean NOT NULL,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "updatedAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE public."UsersAndCollections" OWNER TO valknar;

--
-- Name: VerificationToken; Type: TABLE; Schema: public; Owner: valknar
--

CREATE TABLE public."VerificationToken" (
    identifier text NOT NULL,
    token text NOT NULL,
    expires timestamp(3) without time zone NOT NULL,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "updatedAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE public."VerificationToken" OWNER TO valknar;

--
-- Name: WhitelistedUser; Type: TABLE; Schema: public; Owner: valknar
--

CREATE TABLE public."WhitelistedUser" (
    id integer NOT NULL,
    username text DEFAULT ''::text NOT NULL,
    "userId" integer,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "updatedAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE public."WhitelistedUser" OWNER TO valknar;

--
-- Name: WhitelistedUser_id_seq; Type: SEQUENCE; Schema: public; Owner: valknar
--

CREATE SEQUENCE public."WhitelistedUser_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public."WhitelistedUser_id_seq" OWNER TO valknar;

--
-- Name: WhitelistedUser_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: valknar
--

ALTER SEQUENCE public."WhitelistedUser_id_seq" OWNED BY public."WhitelistedUser".id;


--
-- Name: _LinkToTag; Type: TABLE; Schema: public; Owner: valknar
--

CREATE TABLE public."_LinkToTag" (
    "A" integer NOT NULL,
    "B" integer NOT NULL
);


ALTER TABLE public."_LinkToTag" OWNER TO valknar;

--
-- Name: _PinnedLinks; Type: TABLE; Schema: public; Owner: valknar
--

CREATE TABLE public."_PinnedLinks" (
    "A" integer NOT NULL,
    "B" integer NOT NULL
);


ALTER TABLE public."_PinnedLinks" OWNER TO valknar;

--
-- Name: _prisma_migrations; Type: TABLE; Schema: public; Owner: valknar
--

CREATE TABLE public._prisma_migrations (
    id character varying(36) NOT NULL,
    checksum character varying(64) NOT NULL,
    finished_at timestamp with time zone,
    migration_name character varying(255) NOT NULL,
    logs text,
    rolled_back_at timestamp with time zone,
    started_at timestamp with time zone DEFAULT now() NOT NULL,
    applied_steps_count integer DEFAULT 0 NOT NULL
);


ALTER TABLE public._prisma_migrations OWNER TO valknar;

--
-- Name: AccessToken id; Type: DEFAULT; Schema: public; Owner: valknar
--

ALTER TABLE ONLY public."AccessToken" ALTER COLUMN id SET DEFAULT nextval('public."AccessToken_id_seq"'::regclass);


--
-- Name: Collection id; Type: DEFAULT; Schema: public; Owner: valknar
--

ALTER TABLE ONLY public."Collection" ALTER COLUMN id SET DEFAULT nextval('public."Collection_id_seq"'::regclass);


--
-- Name: DashboardSection id; Type: DEFAULT; Schema: public; Owner: valknar
--

ALTER TABLE ONLY public."DashboardSection" ALTER COLUMN id SET DEFAULT nextval('public."DashboardSection_id_seq"'::regclass);


--
-- Name: Highlight id; Type: DEFAULT; Schema: public; Owner: valknar
--

ALTER TABLE ONLY public."Highlight" ALTER COLUMN id SET DEFAULT nextval('public."Highlight_id_seq"'::regclass);


--
-- Name: Link id; Type: DEFAULT; Schema: public; Owner: valknar
--

ALTER TABLE ONLY public."Link" ALTER COLUMN id SET DEFAULT nextval('public."Link_id_seq"'::regclass);


--
-- Name: RssSubscription id; Type: DEFAULT; Schema: public; Owner: valknar
--

ALTER TABLE ONLY public."RssSubscription" ALTER COLUMN id SET DEFAULT nextval('public."RssSubscription_id_seq"'::regclass);


--
-- Name: Subscription id; Type: DEFAULT; Schema: public; Owner: valknar
--

ALTER TABLE ONLY public."Subscription" ALTER COLUMN id SET DEFAULT nextval('public."Subscription_id_seq"'::regclass);


--
-- Name: Tag id; Type: DEFAULT; Schema: public; Owner: valknar
--

ALTER TABLE ONLY public."Tag" ALTER COLUMN id SET DEFAULT nextval('public."Tag_id_seq"'::regclass);


--
-- Name: User id; Type: DEFAULT; Schema: public; Owner: valknar
--

ALTER TABLE ONLY public."User" ALTER COLUMN id SET DEFAULT nextval('public."User_id_seq"'::regclass);


--
-- Name: WhitelistedUser id; Type: DEFAULT; Schema: public; Owner: valknar
--

ALTER TABLE ONLY public."WhitelistedUser" ALTER COLUMN id SET DEFAULT nextval('public."WhitelistedUser_id_seq"'::regclass);


--
-- Data for Name: AccessToken; Type: TABLE DATA; Schema: public; Owner: valknar
--

COPY public."AccessToken" (id, name, "userId", token, revoked, expires, "lastUsedAt", "createdAt", "updatedAt", "isSession") FROM stdin;
\.


--
-- Data for Name: Account; Type: TABLE DATA; Schema: public; Owner: valknar
--

COPY public."Account" (id, "userId", type, provider, "providerAccountId", refresh_token, access_token, expires_at, token_type, scope, id_token, session_state) FROM stdin;
\.


--
-- Data for Name: Collection; Type: TABLE DATA; Schema: public; Owner: valknar
--

COPY public."Collection" (id, name, description, color, "isPublic", "ownerId", "createdAt", "updatedAt", "parentId", icon, "iconWeight", "createdById") FROM stdin;
\.


--
-- Data for Name: DashboardSection; Type: TABLE DATA; Schema: public; Owner: valknar
--

COPY public."DashboardSection" (id, "userId", "collectionId", type, "order", "createdAt", "updatedAt") FROM stdin;
\.


--
-- Data for Name: Highlight; Type: TABLE DATA; Schema: public; Owner: valknar
--

COPY public."Highlight" (id, color, comment, "linkId", "userId", "startOffset", "endOffset", text, "createdAt", "updatedAt") FROM stdin;
\.


--
-- Data for Name: Link; Type: TABLE DATA; Schema: public; Owner: valknar
--

COPY public."Link" (id, name, url, description, "collectionId", "createdAt", pdf, image, "updatedAt", readable, "lastPreserved", "textContent", type, preview, "importDate", monolith, color, icon, "iconWeight", "createdById", "aiTagged", "indexVersion", "clientSide") FROM stdin;
\.


--
-- Data for Name: PasswordResetToken; Type: TABLE DATA; Schema: public; Owner: valknar
--

COPY public."PasswordResetToken" (identifier, token, expires, "createdAt", "updatedAt") FROM stdin;
\.


--
-- Data for Name: RssSubscription; Type: TABLE DATA; Schema: public; Owner: valknar
--

COPY public."RssSubscription" (id, url, name, "lastBuildDate", "collectionId", "ownerId", "createdAt", "updatedAt") FROM stdin;
\.


--
-- Data for Name: Subscription; Type: TABLE DATA; Schema: public; Owner: valknar
--

COPY public."Subscription" (id, active, "stripeSubscriptionId", "currentPeriodStart", "currentPeriodEnd", "userId", "createdAt", "updatedAt", quantity) FROM stdin;
\.


--
-- Data for Name: Tag; Type: TABLE DATA; Schema: public; Owner: valknar
--

COPY public."Tag" (id, name, "ownerId", "createdAt", "updatedAt", "archiveAsMonolith", "archiveAsPDF", "archiveAsReadable", "archiveAsScreenshot", "archiveAsWaybackMachine", "aiTag", "aiGenerated") FROM stdin;
\.


--
-- Data for Name: User; Type: TABLE DATA; Schema: public; Owner: valknar
--

COPY public."User" (id, name, username, email, "emailVerified", password, "isPrivate", "createdAt", "archiveAsPDF", "archiveAsScreenshot", "archiveAsWaybackMachine", image, "updatedAt", "linksRouteTo", "collectionOrder", "preventDuplicateLinks", "unverifiedNewEmail", locale, "archiveAsMonolith", "parentSubscriptionId", "referredBy", "aiPredefinedTags", "aiTaggingMethod", "aiTagExistingLinks", "archiveAsReadable", "readableFontFamily", "readableFontSize", "readableLineHeight", "readableLineWidth", theme, "lastPickedAt", "acceptPromotionalEmails") FROM stdin;
\.


--
-- Data for Name: UsersAndCollections; Type: TABLE DATA; Schema: public; Owner: valknar
--

COPY public."UsersAndCollections" ("userId", "collectionId", "canCreate", "canUpdate", "canDelete", "createdAt", "updatedAt") FROM stdin;
\.


--
-- Data for Name: VerificationToken; Type: TABLE DATA; Schema: public; Owner: valknar
--

COPY public."VerificationToken" (identifier, token, expires, "createdAt", "updatedAt") FROM stdin;
\.


--
-- Data for Name: WhitelistedUser; Type: TABLE DATA; Schema: public; Owner: valknar
--

COPY public."WhitelistedUser" (id, username, "userId", "createdAt", "updatedAt") FROM stdin;
\.


--
-- Data for Name: _LinkToTag; Type: TABLE DATA; Schema: public; Owner: valknar
--

COPY public."_LinkToTag" ("A", "B") FROM stdin;
\.


--
-- Data for Name: _PinnedLinks; Type: TABLE DATA; Schema: public; Owner: valknar
--

COPY public."_PinnedLinks" ("A", "B") FROM stdin;
\.


--
-- Data for Name: _prisma_migrations; Type: TABLE DATA; Schema: public; Owner: valknar
--

COPY public._prisma_migrations (id, checksum, finished_at, migration_name, logs, rolled_back_at, started_at, applied_steps_count) FROM stdin;
14bfed7a-baac-4d6c-80c4-f0fb1b89926e	9cb51e0b7636fa960d2bd9f801893d4151f9fbecb6d7514cfd9cd8926b70ca3d	2025-10-10 09:28:38.306012+00	20231105202241_modify_user_password	\N	\N	2025-10-10 09:28:38.304554+00	1
62126e9e-62bc-4b1a-adea-c8c27a6f6932	55c70f54b77312cfebf437680031d99834eef9c6e68a51c8543eac8492dd9745	2025-10-10 09:28:38.269253+00	20230719181459_init	\N	\N	2025-10-10 09:28:38.25395+00	1
ab1cbc0c-622e-4305-bc88-aba59e497439	d8c6f4b3b349fb16ccbd1497d688b680096c68ca72edddbfbc765d058394af28	2025-10-10 09:28:38.273154+00	20230804230549_created_whitelisted_users_table	\N	\N	2025-10-10 09:28:38.270002+00	1
08efc59d-39d9-4e0b-9c2e-0c0f91a4f69b	934c39317ba6450ad949f6b2a587a7e802835246f107fa0257f3daf7a73022f8	2025-10-10 09:28:38.362205+00	20240125124457_added_subcollection_relations	\N	\N	2025-10-10 09:28:38.359822+00	1
9dccb16c-911e-4fa5-b91c-d3c798448763	681260dcb66df614e7967dff5f5f46c39b7fb15d3681f75a38f605977864e6cc	2025-10-10 09:28:38.276346+00	20231019032936_modify_archive_formats	\N	\N	2025-10-10 09:28:38.273691+00	1
c5eda5f3-26a3-4a4b-822d-f36f0790d7c0	fce9de1997c278d861b5284716450a076adae6ba20038a4511e02762979fd807	2025-10-10 09:28:38.309014+00	20231108232127_recreate_table_account	\N	\N	2025-10-10 09:28:38.306458+00	1
afccf66a-5878-4307-9dd7-81dc3d8bcbb5	94b8c526fac4f4f8edfe343f88cd12b8f3d4cea22b68021a486eefada76e679d	2025-10-10 09:28:38.278814+00	20231025123038_added_pathname_to_files	\N	\N	2025-10-10 09:28:38.276961+00	1
cff26bf1-eb1c-4766-99de-416ce66a5afd	63ec66d8ab0da590b38a21f65990ba66e2a746d4aa4f04eb09575b257cd5f224	2025-10-10 09:28:38.282275+00	20231027194841_add_updated_at_fields_to_tables	\N	\N	2025-10-10 09:28:38.279371+00	1
d712f9a4-88be-4eab-9093-f2baad4a7034	8a163c9118e346560e0b34fb38b64af99dbd7baf9e378a21b4d6563eac3868f6	2025-10-10 09:28:38.340441+00	20231221174844_rename_fields_and_add_preview	\N	\N	2025-10-10 09:28:38.338737+00	1
4bde6637-77dd-4cc6-909c-9c3c3415dde5	fa3c35d7eadd8c6be9db3ac2a0d3a2f596ec8a815748d4279da9659ba581f75a	2025-10-10 09:28:38.285915+00	20231027195438_remove_unnecessary_tables	\N	\N	2025-10-10 09:28:38.283094+00	1
7eda13c8-ea2b-423b-b121-6b38a01d9be7	a996f753f96676da1967059d239ba01aeb2f2d4470fbb31283fec653f2e88090	2025-10-10 09:28:38.311787+00	20231110154938_add_blurred_favicons_field	\N	\N	2025-10-10 09:28:38.309487+00	1
5bd66fd0-4dbf-4626-9f6c-4a97d69ed85f	f0ef8943d3d8cbe2c1fcfaff76e7eafc72f5ef46b66ac762e132899e11512117	2025-10-10 09:28:38.289947+00	20231028041930_rename_image_path_to_image	\N	\N	2025-10-10 09:28:38.286518+00	1
49708f12-7cc5-46c5-9085-aaa46ecb16dc	22459156062a91d817b78a7ce4d6336deedf833671810529e14e594bb2689d14	2025-10-10 09:28:38.2921+00	20231029183108_added_readability_path_field_to_the_link_table	\N	\N	2025-10-10 09:28:38.290453+00	1
61b996ea-9302-49c0-b6f5-820b6d411fd9	5f7ced9b7f36791f759c54408fffd4ccb5d17fa9d1be4abb6fa440ae56b69043	2025-10-10 09:28:38.295188+00	20231031100017_add_last_preserved_field	\N	\N	2025-10-10 09:28:38.29316+00	1
881a6f84-93b9-4b2c-b08f-28d5aa1128a2	ee78dfd3dc12f915a51e1eecb67046b8e9804161113cd64662ef96a88055546f	2025-10-10 09:28:38.314038+00	20231111183859_add_display_link_icons_field	\N	\N	2025-10-10 09:28:38.312412+00	1
91ccdbd6-ae20-4220-99b5-dfbe5de26538	b7c1ce620956ca32575f30e6cd595244a4315631375f5baa863f91cc55d546d1	2025-10-10 09:28:38.297616+00	20231101085207_add_text_content_field	\N	\N	2025-10-10 09:28:38.295698+00	1
7c7278a0-a031-45cd-9d3d-0a4d17828379	d96792d00482778313bbdb7c0231d730d93ce4005dbdee4894a61148b4648d70	2025-10-10 09:28:38.301373+00	20231103051515_add_subscription_table	\N	\N	2025-10-10 09:28:38.298026+00	1
ccfb289d-4e84-47a5-bcc2-b1bbc9d19c35	3bc0be3660dbda9019471d6f740c8d603dc03937fd9684c79fd491b8488f266f	2025-10-10 09:28:38.304079+00	20231104052926_changed_subscription_relation	\N	\N	2025-10-10 09:28:38.301956+00	1
22669748-df8b-4a1f-a93d-89cd7fe5be14	14c2d2c0748960d4b18fb06be9b22fff505aac780caed4472aeea39571d68eb7	2025-10-10 09:28:38.343712+00	20240113051701_make_key_names_unique	\N	\N	2025-10-10 09:28:38.340885+00	1
2b9c54de-65c1-49a1-baa9-92c8376072f5	f3a156e0dbb1e4daee4da1b4c1df1bbbe230dcc6bda115db6b1ad8743722b3c1	2025-10-10 09:28:38.320687+00	20231120135053_add_apikeys_table	\N	\N	2025-10-10 09:28:38.315026+00	1
dc42457e-a3e2-4d9b-95d7-984322e5eb04	f353154915dd2140d1c7c77c41c0bc248c45f53b6ff4e3b344e2115c93babde9	2025-10-10 09:28:38.327914+00	20231120135140_rename_apikeys_to_apikey	\N	\N	2025-10-10 09:28:38.322737+00	1
e9e36a73-1a2c-414d-b242-c9b92c8fee2c	655addc3cb819db69a9c22c7733d87af49e6d7722e0118c9e43068dd61650452	2025-10-10 09:28:38.38014+00	20240310062318_added_index_to_ownerid_on_tag_model	\N	\N	2025-10-10 09:28:38.378748+00	1
01efc672-6652-4063-b3fb-2fbcd9173dec	4d1e05a7e93e1ad6952b25ad00d98ce6043b00f23676daa55184a2bfcf8da82e	2025-10-10 09:28:38.332382+00	20231120184333_set_blurred_favicon_to_false_as_default	\N	\N	2025-10-10 09:28:38.328707+00	1
8c24482b-a2eb-430e-96a7-db1c12228720	b0f4527df87014377771714ef2f5877d752ba720260a294d757e79b40d2c556a	2025-10-10 09:28:38.347389+00	20240113060555_minor_fix	\N	\N	2025-10-10 09:28:38.344399+00	1
61878063-dfe8-4ece-baaa-a91597e759a6	6bb1d126eb2b1fcecdb7f9cff1ddb9062f27cb13b387002f8944e49e3386b046	2025-10-10 09:28:38.336002+00	20231125043215_add_link_type_field	\N	\N	2025-10-10 09:28:38.333604+00	1
510870b4-9c51-4ea3-9fd7-dcb03e3a6e5d	d00e75078ac770a54bd9fa95cff1e1940aaaddeac7e7ef08b8ab0e9fc609f27e	2025-10-10 09:28:38.337979+00	20231202183159_remove_extra_fields	\N	\N	2025-10-10 09:28:38.336462+00	1
7db61d06-f9ac-48b6-8918-9a449a5abc7c	10261482e7a6c19ad08af642f73c6e3fc31c1a547074d4052f63cdb53c14ca79	2025-10-10 09:28:38.365953+00	20240207152849_add_links_route_enum_setting	\N	\N	2025-10-10 09:28:38.362674+00	1
1a97d837-65f1-4bca-93b3-671fd86b05bb	5a728d848b56eb0339c3863cb9447ed1b8f4e8b8b60dae81c8b70078fb74fee5	2025-10-10 09:28:38.355332+00	20240124192212_added_revoke_field	\N	\N	2025-10-10 09:28:38.349076+00	1
fef9e96e-0c92-437f-9100-60491a17a6f2	3e573694930f7ebcaea756030c448bba8785721592a9cb2a1fc22673a360993f	2025-10-10 09:28:38.359075+00	20240124201018_removed_name_unique_constraint	\N	\N	2025-10-10 09:28:38.355853+00	1
4c9e7641-5f94-4d14-b233-22c5f8e38294	96f4238fa8ee7c6710f99544d403d96fbe1388bb33e6dbe43b398cb5aa31aeae	2025-10-10 09:28:38.374023+00	20240305045701_add_merge_duplicate_links	\N	\N	2025-10-10 09:28:38.372232+00	1
c4fa3b4b-5efa-4097-8da9-88be7bfa777b	4ccdde786bcd681f233fbe2065ac6102efd254675fd5a867039caf5d3bdcdcf3	2025-10-10 09:28:38.369034+00	20240218080348_allow_duplicate_collection_names	\N	\N	2025-10-10 09:28:38.366767+00	1
31291b11-8e09-410b-bcea-f1bd10d56b58	3cc7ed219b8f2b1d94d1795537345d58037a2d1efdf0b273ffe79da5fb2e176f	2025-10-10 09:28:38.378246+00	20240310062152_added_indexes	\N	\N	2025-10-10 09:28:38.376601+00	1
e094df32-799f-4fda-b7fa-734a1273ea53	403357e034fe32db4b38f56a8eedbc3d0248c5a8805a2712c98504e371506e23	2025-10-10 09:28:38.371738+00	20240222050805_collection_order	\N	\N	2025-10-10 09:28:38.369588+00	1
30c9e671-534b-488b-b7ba-65ea6e66c955	91f55a40d30ce5f530a1d0d4dd5400ef1f7d03fb17858536a28b1646624d0b33	2025-10-10 09:28:38.376135+00	20240309180643_add_singlefile_archive_format	\N	\N	2025-10-10 09:28:38.374463+00	1
35ccff81-048b-4140-b2fa-a6adcfc8c46f	9aa71293df2d2fc9c90ecbf481a3cbc197843864dfe035d89d9bdbb5f59acde8	2025-10-10 09:28:38.381764+00	20240327070238_add_import_date_field_for_links	\N	\N	2025-10-10 09:28:38.380539+00	1
57e92635-0568-4df0-b413-b939f67935ab	e997fe7186f82fead578863e8f8fb9480426ef8f8ac9ad9b03fee291081c5d15	2025-10-10 09:28:38.38369+00	20240515084924_add_unverified_new_email_field_to_user_table	\N	\N	2025-10-10 09:28:38.382147+00	1
83ea2968-db87-4176-8691-5ed87f1a3acc	5ae9a9e42ccade41b1c0845f4ee406024ecf6987f692532b30731c025c805fbd	2025-10-10 09:28:38.386389+00	20240518161814_added_password_reset_token_table	\N	\N	2025-10-10 09:28:38.384148+00	1
f62c87ef-aa7b-4fa9-ba02-ffffb0b45829	658a2ad9de6192773876d10744065768d2f71764d3e221cb8d215249a3fec848	2025-10-10 09:28:38.387995+00	20240525002215_add_default_value_to_link_name	\N	\N	2025-10-10 09:28:38.38677+00	1
265e80d9-8bf8-47d9-b32e-f6f77eba6f9b	ac2065ada4b6337753cd9cee3aece7a5fceb0a0c82fc0952745fdf47263977fd	2025-10-10 09:28:38.390448+00	20240528194553_added_locale_field_for_users	\N	\N	2025-10-10 09:28:38.388426+00	1
a678829a-62b9-4323-864a-f1bc492ed4e1	563efb1021f70d7b70edb77236ea664573af9396e5be369929d370f1133be7b5	2025-10-10 09:28:38.418916+00	20241030200844_createdby_fields_can_be_null	\N	\N	2025-10-10 09:28:38.416629+00	1
a29bd5c7-6c0c-4b99-8924-7e3d27105699	03773c3992163de1b68c607260f2f03c2d18c887a0837e103832c96ef67d9f14	2025-10-10 09:28:38.392165+00	20240626225737_add_new_field_to_access_tokens	\N	\N	2025-10-10 09:28:38.390862+00	1
72f0d579-aaa7-4756-9f54-0318c4a93f73	966e67bb2447834c7f739391279977ac103a7244935fb2930fbb6f262c99c719	2025-10-10 09:28:38.396183+00	20240628013747_rename_fields	\N	\N	2025-10-10 09:28:38.392559+00	1
91cd1d0e-149e-4965-bcfd-af5f59294c4b	ae9a51949553bb4f2261dcb5f8236c420e06914dd288edfd0625344d9bd9d644	2025-10-10 09:28:38.450321+00	20250303224623_remove_field	\N	\N	2025-10-10 09:28:38.448802+00	1
c53320ea-6b3f-42d4-8e61-a2f0b261338c	d7f095144e701f65d7a3250e6b98e9c15ba9980ff1c2efb1cd2fac922743ab5b	2025-10-10 09:28:38.397835+00	20240628014129_rename_field	\N	\N	2025-10-10 09:28:38.396574+00	1
af96b80c-48d1-4d6a-bd39-853a6bf5428e	5e640c1047485e4e2dd1f7965e6cb95f2ef3ecc93a76a14c427d4b3faf909572	2025-10-10 09:28:38.42074+00	20241107123356_add_field	\N	\N	2025-10-10 09:28:38.419378+00	1
1dae52f8-7e48-4466-99d0-1062631853b3	346c2e12640ee9ffac5127abddf3bc0dec125bb42af09d7fc1f100b02e04a5b4	2025-10-10 09:28:38.399677+00	20240819003838_add_icon_related_fields_to_link_and_collection_model	\N	\N	2025-10-10 09:28:38.398205+00	1
36d2ef00-235d-4a6b-83c1-521e819d23e1	3516d97ee28afa1f0e5b48e553c2678891d10a43d2c77cfb9fee48c6b47ec600	2025-10-10 09:28:38.401514+00	20240819005010_remove_collection_model_default_color	\N	\N	2025-10-10 09:28:38.400127+00	1
065ab907-9304-4837-be08-ef5c652ff464	a03f82d637b8f984d017e89c9a7db39e788dae3c21842dc3a4b5449a63370e48	2025-10-10 09:28:38.43594+00	20250129180119_ai_tag_existing_links	\N	\N	2025-10-10 09:28:38.434417+00	1
fa00aa30-6c1b-4baf-b38a-2acd1a174c28	68c1f544cadf29f5bf24b03002ce9015008592bda21dd22ae176dfb009b4b669	2025-10-10 09:28:38.403328+00	20240820230618_add_default_value_for_collection_color	\N	\N	2025-10-10 09:28:38.401996+00	1
0a106d18-0d95-4b42-9bb9-9af1f4b60e89	1d857af5216d12a680642c57786abe47af951f7f908e9b50e74faf2bc1fbe503	2025-10-10 09:28:38.422531+00	20241129171823_add_ai_tagging_fields	\N	\N	2025-10-10 09:28:38.421118+00	1
c147e1d6-266b-47bb-b500-1d22b44d8222	de18e057c5be9b0ab9ab06a8b9ecde27b2fe132cda6eb45a74df928b6c7cbbff	2025-10-10 09:28:38.405037+00	20240924235035_add_quantity_to_subscriptions	\N	\N	2025-10-10 09:28:38.403731+00	1
578e584e-ad3d-44b0-97d9-dc233f4548b3	3af824627cd997347a126f073718060643842339c19b43b8dde75d2617676c8e	2025-10-10 09:28:38.409939+00	20241021175802_add_child_subscription_support	\N	\N	2025-10-10 09:28:38.40546+00	1
aa1b0f98-d5bf-4478-bb87-d6e498be7c1a	5b1f5fc3406a927604a0542658d2c33caace6fef212bae4665e08e37c42a200f	2025-10-10 09:28:38.412772+00	20241026161909_assign_createdby_to_collection_owners_and_make_field_required	\N	\N	2025-10-10 09:28:38.410389+00	1
e01adfbd-013a-4797-a7fd-93f9a1d17812	2bfc7ddf3cb46cf3bbecb2f29a8fe67617a0b1cfc21cc11bde7daa05357f432b	2025-10-10 09:28:38.425395+00	20241204062531_add_rss_subscriptions	\N	\N	2025-10-10 09:28:38.422912+00	1
638cf920-3672-4d83-a1fb-0a9f6cc2362c	07101e98c0c593f3e65a82d940c849fb988b7e2719fa66c1c15b486e0ec9c8a7	2025-10-10 09:28:38.414492+00	20241027093300_remove_field	\N	\N	2025-10-10 09:28:38.413151+00	1
a06825cf-7c7d-40de-9370-57bacc5b4636	f721f8cc325673697d4fec2efd7b808ecb64cf99b8ed1d5de482be6cd852e531	2025-10-10 09:28:38.41623+00	20241027104510_remove_field	\N	\N	2025-10-10 09:28:38.414988+00	1
b5bcc310-4bb5-4fc9-9d65-cf0e417db04c	087bc1353c3c02ac941ff02c6c8144a6437af2671d109dbc2977cf9e6b5b54a9	2025-10-10 09:28:38.444727+00	20250211134725_add_field_to_links	\N	\N	2025-10-10 09:28:38.443385+00	1
7183dc67-23c5-43ab-8508-d96511bd8d9d	b72cb0d6a0b58062bfcc0cdafea13b34ea589a7803a9d2ca2716f886c667efb4	2025-10-10 09:28:38.437651+00	20250131033243_add_existing_tagging_method	\N	\N	2025-10-10 09:28:38.436429+00	1
448f7ac9-4df5-4eac-aad4-193336813fa8	650a8752b344616d3fa0d2ee3e5492b6708bc212590a8e2ed4d16fe0f271e0ab	2025-10-10 09:28:38.427388+00	20241209173822_add_field	\N	\N	2025-10-10 09:28:38.425816+00	1
506bb2ea-1fa3-4676-8da0-27e11ef08853	6fb99252e6fa929a031097decaf2e12ce1f6413a7494715138edceb24904fcad	2025-10-10 09:28:38.42905+00	20241209210046_remove_pending_fields	\N	\N	2025-10-10 09:28:38.427818+00	1
ba1f6a56-6420-4caf-b7a0-72eef96848de	be830f2a6c9b36cda926c2197725514aa7fbab959e4bb890ac4907776b533f8c	2025-10-10 09:28:38.430956+00	20241231230724_add_fields	\N	\N	2025-10-10 09:28:38.429463+00	1
f079f3b6-a85b-4c40-9b1b-2f56322aac0f	6191025c7fdbb4efe5f973fe6552709cec35a11adfbf608629a8636c9bc1f8c6	2025-10-10 09:28:38.439449+00	20250201232357_add_archive_as_readable_option_for_user	\N	\N	2025-10-10 09:28:38.438087+00	1
8a6acf07-5b58-43d2-a2e0-99b06aee7a50	89384ab33959597591e6972ede1567bc915af9022ca8cfc42837c0bbfd2af1de	2025-10-10 09:28:38.432538+00	20250102211704_modify_links_route_to_enum	\N	\N	2025-10-10 09:28:38.431375+00	1
6134e293-d87a-4d16-a51c-0f7362847f4e	1603e5548342abe643fb4c18b02c46509a222e2fc0fa273f61bb07086eb7a90a	2025-10-10 09:28:38.434031+00	20250116100419_add_field_to_link_model	\N	\N	2025-10-10 09:28:38.432913+00	1
a3d35aa4-49e4-4f4c-aa99-bebc100be0ef	38e37cd41eee7abda0364755c9923062112ddd06555db640f4fd317664324db1	2025-10-10 09:28:38.441099+00	20250202201004_add_archive_options_for_tags	\N	\N	2025-10-10 09:28:38.439848+00	1
320a28e8-7f43-4a4c-a8d7-44fb9e9d155f	50a2d51c15cda6c0377deb83bb4cfe874a0c0dc363b81c43e568cac6f820e32b	2025-10-10 09:28:38.446457+00	20250215181757_add_version_to_index	\N	\N	2025-10-10 09:28:38.445134+00	1
7938aadd-11da-41b5-9c6e-88a837000005	b9cb3cce609dc883f4414bd0655c865d0a5744bd6e7da7ca8cd6ba1c778d7e75	2025-10-10 09:28:38.442971+00	20250203002023_add_ai_tagging_option_for_tags	\N	\N	2025-10-10 09:28:38.441506+00	1
3af8e9d2-4cd9-4545-92dd-d59523f2e656	71de7c5e116947bad6d6581240c8c5c61e33b1560ea895019582ad2b4d023b5e	2025-10-10 09:28:38.46444+00	20250318131012_add_referential_action_to_field	\N	\N	2025-10-10 09:28:38.462741+00	1
d081953b-260b-42df-b19f-350e2ddb65ca	c4460fd368ae55f867ae13d1bae255fb575fdbabbe7536a26a5c032242c8c982	2025-10-10 09:28:38.448385+00	20250215182023_change_field_type	\N	\N	2025-10-10 09:28:38.446874+00	1
3b0a1bae-376c-46c7-8221-d7cb8cc618c9	5c4588157152eed6477edcb505ddf8b6fb5f8b18cb918ec3c2023eeef67677c0	2025-10-10 09:28:38.462359+00	20250318130241_add_referential_action_to_field	\N	\N	2025-10-10 09:28:38.460385+00	1
7e73e1d2-d906-408c-8016-f588dbf803f0	7c412654acc6d76825db4d40817df7cf0c3cacc354ed80761273bc3c1d215c07	2025-10-10 09:28:38.453977+00	20250304145909_add_table	\N	\N	2025-10-10 09:28:38.450756+00	1
9ab9dfb2-ceac-4427-8ebb-c9fa0e9ca4d4	7b9693f64f2b7f00dbc81dd2c939ec73a09ed6ae606195457a9eec77441e634c	2025-10-10 09:28:38.45998+00	20250318123928_add_referential_actions_to_certain_fields	\N	\N	2025-10-10 09:28:38.45441+00	1
d614d95d-a395-4266-b8c0-5a4bda5ee53d	36ca7ea4b7ccc45059887d9b963f89844e8b86412f45548e35d67bc5bc90d5ca	2025-10-10 09:28:38.466061+00	20250318131228_rename_link_to_url_in_link_type	\N	\N	2025-10-10 09:28:38.464857+00	1
e0513f2a-18ce-499c-802a-eb530529c4b6	93777c1334a7356fdc7a3c2cb90513a9d57c0200f03396bc0df1f113ddd1870f	2025-10-10 09:28:38.468181+00	20250329032742_add_field	\N	\N	2025-10-10 09:28:38.466472+00	1
c622479f-261f-4a56-b14a-1d5059126e57	0b55a9d59c4272fc567e6341d0cc826de0f4a44266e0e47d0105ed8a3ab10e89	2025-10-10 09:28:38.470301+00	20250330105338_add_field	\N	\N	2025-10-10 09:28:38.46867+00	1
247261cf-3949-42db-ad3d-734839c8f442	98ffc20469e0e3f6895ed21c62a82491514fc2029ab78c7c1b79d7f0b43f52c0	2025-10-10 09:28:38.47273+00	20250404153610_remove_fields	\N	\N	2025-10-10 09:28:38.470784+00	1
c28055b3-4e61-42f8-a330-a08885388b7d	511e3a722a2df1a6414a97bac7a2aece82bd4c5b27ca201b669ce107f220db2a	2025-10-10 09:28:38.476948+00	20250601213117_add_dashboard_sections	\N	\N	2025-10-10 09:28:38.473166+00	1
4fecf748-1a06-40be-8984-66e7d1a79c6a	d1be47d161303499216c3a6e5fd3ee201d5a2d9576b4469c6fadff9ec56c478e	2025-10-10 09:28:38.47928+00	20250602104316_add_fields_to_user_model	\N	\N	2025-10-10 09:28:38.477428+00	1
aaae53d4-daf6-4ddc-a5dd-3acea26fc82b	2e561904bcb38ab70701cc669e0b8ba7b5b0d6e1eae185afbd823a6e985c714d	2025-10-10 09:28:38.481375+00	20250610113046_add_default_dashboard_sections	\N	\N	2025-10-10 09:28:38.479746+00	1
949d3fe2-0c5f-4765-af2a-dde79123ca59	2e041f6577cb8585ac0095fceb9face7ba65f9046e1e478700736277855996bf	2025-10-10 09:28:38.483706+00	20250626175441_add_defaults_for_readable_settings	\N	\N	2025-10-10 09:28:38.48181+00	1
1e2edd35-ba82-4d4e-9e76-c679de982dee	1f3127231bf257ee86b010df2c8e8d511c53739e48d3c0f94087d7defed8be9d	2025-10-10 09:28:38.486914+00	20250627132552_upgrade_to_v6	\N	\N	2025-10-10 09:28:38.484156+00	1
751f6070-2c0f-430d-9812-ae4a97b9b36d	6b36fab80af10d268404e1361269ad9555495bc621c367f831d694b1f01b3041	2025-10-10 09:28:38.488758+00	20250627155222_add_default_db_sections_fix	\N	\N	2025-10-10 09:28:38.487392+00	1
0bcd745a-7c02-42c8-8710-3bff73b4dd99	a13f1a0a5dfd86f569bc77bab8b1359339e5678654d5efd9c053eb2f5f446875	2025-10-10 09:28:38.490773+00	20250627164227_add_index_to_link_model	\N	\N	2025-10-10 09:28:38.489157+00	1
5cf007c0-cb03-4ada-831f-6e115746405d	90fdc5f9b7a471716ed1545d1251eaf64accd99e0230a90f3351cd17c05b0090	2025-10-10 09:28:38.496316+00	20250627210016_add_theme	\N	\N	2025-10-10 09:28:38.491233+00	1
711b192b-8b7b-4a74-b962-aa422304a93e	93ff6c41958b3bf5457263f29210878f39bd1b86c3cad17490a36e06504e86c3	2025-10-10 09:28:38.498534+00	20250811155703_add_field_to_links	\N	\N	2025-10-10 09:28:38.496785+00	1
c4dae6ea-751d-40e8-8af3-ebf25a21eb89	4c1d4dff1da3f9eba7712e9bf8979f02677dd10dcad090b0acd3bf9f7572d107	2025-10-10 09:28:38.500511+00	20250812205616_add_field_to_user_model	\N	\N	2025-10-10 09:28:38.499091+00	1
e69c99f6-35c2-43dc-b1e4-84c453255fcd	3e7a5e5df925d73bc485325c04cd3fc37abd67c4d55695e6edee33c2174eba0c	2025-10-10 09:28:38.502361+00	20250813025203_remove_default_from_field	\N	\N	2025-10-10 09:28:38.500932+00	1
896fe902-1f43-4b65-bcb3-e825917ee297	a37232f59765a9bb1a0c7170b60f05de79af45fc7a9059dacb988b98f6190093	2025-10-10 09:28:38.504193+00	20250826181008_add_field_to_tags	\N	\N	2025-10-10 09:28:38.502775+00	1
213ea10e-f95f-46da-b966-9baf9b0b6571	0b54ebe929a4e49ac5957e28210229fccf72a0e3deb3f7f240021bf7ede5b5d4	2025-10-10 09:28:38.506242+00	20250922133423_add_field_to_user	\N	\N	2025-10-10 09:28:38.504607+00	1
\.


--
-- Name: AccessToken_id_seq; Type: SEQUENCE SET; Schema: public; Owner: valknar
--

SELECT pg_catalog.setval('public."AccessToken_id_seq"', 1, false);


--
-- Name: Collection_id_seq; Type: SEQUENCE SET; Schema: public; Owner: valknar
--

SELECT pg_catalog.setval('public."Collection_id_seq"', 1, false);


--
-- Name: DashboardSection_id_seq; Type: SEQUENCE SET; Schema: public; Owner: valknar
--

SELECT pg_catalog.setval('public."DashboardSection_id_seq"', 1, false);


--
-- Name: Highlight_id_seq; Type: SEQUENCE SET; Schema: public; Owner: valknar
--

SELECT pg_catalog.setval('public."Highlight_id_seq"', 1, false);


--
-- Name: Link_id_seq; Type: SEQUENCE SET; Schema: public; Owner: valknar
--

SELECT pg_catalog.setval('public."Link_id_seq"', 1, false);


--
-- Name: RssSubscription_id_seq; Type: SEQUENCE SET; Schema: public; Owner: valknar
--

SELECT pg_catalog.setval('public."RssSubscription_id_seq"', 1, false);


--
-- Name: Subscription_id_seq; Type: SEQUENCE SET; Schema: public; Owner: valknar
--

SELECT pg_catalog.setval('public."Subscription_id_seq"', 1, false);


--
-- Name: Tag_id_seq; Type: SEQUENCE SET; Schema: public; Owner: valknar
--

SELECT pg_catalog.setval('public."Tag_id_seq"', 1, false);


--
-- Name: User_id_seq; Type: SEQUENCE SET; Schema: public; Owner: valknar
--

SELECT pg_catalog.setval('public."User_id_seq"', 1, false);


--
-- Name: WhitelistedUser_id_seq; Type: SEQUENCE SET; Schema: public; Owner: valknar
--

SELECT pg_catalog.setval('public."WhitelistedUser_id_seq"', 1, false);


--
-- Name: AccessToken AccessToken_pkey; Type: CONSTRAINT; Schema: public; Owner: valknar
--

ALTER TABLE ONLY public."AccessToken"
    ADD CONSTRAINT "AccessToken_pkey" PRIMARY KEY (id);


--
-- Name: Account Account_pkey; Type: CONSTRAINT; Schema: public; Owner: valknar
--

ALTER TABLE ONLY public."Account"
    ADD CONSTRAINT "Account_pkey" PRIMARY KEY (id);


--
-- Name: Collection Collection_pkey; Type: CONSTRAINT; Schema: public; Owner: valknar
--

ALTER TABLE ONLY public."Collection"
    ADD CONSTRAINT "Collection_pkey" PRIMARY KEY (id);


--
-- Name: DashboardSection DashboardSection_pkey; Type: CONSTRAINT; Schema: public; Owner: valknar
--

ALTER TABLE ONLY public."DashboardSection"
    ADD CONSTRAINT "DashboardSection_pkey" PRIMARY KEY (id);


--
-- Name: Highlight Highlight_pkey; Type: CONSTRAINT; Schema: public; Owner: valknar
--

ALTER TABLE ONLY public."Highlight"
    ADD CONSTRAINT "Highlight_pkey" PRIMARY KEY (id);


--
-- Name: Link Link_pkey; Type: CONSTRAINT; Schema: public; Owner: valknar
--

ALTER TABLE ONLY public."Link"
    ADD CONSTRAINT "Link_pkey" PRIMARY KEY (id);


--
-- Name: RssSubscription RssSubscription_pkey; Type: CONSTRAINT; Schema: public; Owner: valknar
--

ALTER TABLE ONLY public."RssSubscription"
    ADD CONSTRAINT "RssSubscription_pkey" PRIMARY KEY (id);


--
-- Name: Subscription Subscription_pkey; Type: CONSTRAINT; Schema: public; Owner: valknar
--

ALTER TABLE ONLY public."Subscription"
    ADD CONSTRAINT "Subscription_pkey" PRIMARY KEY (id);


--
-- Name: Tag Tag_pkey; Type: CONSTRAINT; Schema: public; Owner: valknar
--

ALTER TABLE ONLY public."Tag"
    ADD CONSTRAINT "Tag_pkey" PRIMARY KEY (id);


--
-- Name: User User_pkey; Type: CONSTRAINT; Schema: public; Owner: valknar
--

ALTER TABLE ONLY public."User"
    ADD CONSTRAINT "User_pkey" PRIMARY KEY (id);


--
-- Name: UsersAndCollections UsersAndCollections_pkey; Type: CONSTRAINT; Schema: public; Owner: valknar
--

ALTER TABLE ONLY public."UsersAndCollections"
    ADD CONSTRAINT "UsersAndCollections_pkey" PRIMARY KEY ("userId", "collectionId");


--
-- Name: WhitelistedUser WhitelistedUser_pkey; Type: CONSTRAINT; Schema: public; Owner: valknar
--

ALTER TABLE ONLY public."WhitelistedUser"
    ADD CONSTRAINT "WhitelistedUser_pkey" PRIMARY KEY (id);


--
-- Name: _LinkToTag _LinkToTag_AB_pkey; Type: CONSTRAINT; Schema: public; Owner: valknar
--

ALTER TABLE ONLY public."_LinkToTag"
    ADD CONSTRAINT "_LinkToTag_AB_pkey" PRIMARY KEY ("A", "B");


--
-- Name: _PinnedLinks _PinnedLinks_AB_pkey; Type: CONSTRAINT; Schema: public; Owner: valknar
--

ALTER TABLE ONLY public."_PinnedLinks"
    ADD CONSTRAINT "_PinnedLinks_AB_pkey" PRIMARY KEY ("A", "B");


--
-- Name: _prisma_migrations _prisma_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: valknar
--

ALTER TABLE ONLY public._prisma_migrations
    ADD CONSTRAINT _prisma_migrations_pkey PRIMARY KEY (id);


--
-- Name: AccessToken_token_key; Type: INDEX; Schema: public; Owner: valknar
--

CREATE UNIQUE INDEX "AccessToken_token_key" ON public."AccessToken" USING btree (token);


--
-- Name: Account_provider_providerAccountId_key; Type: INDEX; Schema: public; Owner: valknar
--

CREATE UNIQUE INDEX "Account_provider_providerAccountId_key" ON public."Account" USING btree (provider, "providerAccountId");


--
-- Name: Collection_ownerId_idx; Type: INDEX; Schema: public; Owner: valknar
--

CREATE INDEX "Collection_ownerId_idx" ON public."Collection" USING btree ("ownerId");


--
-- Name: DashboardSection_userId_collectionId_key; Type: INDEX; Schema: public; Owner: valknar
--

CREATE UNIQUE INDEX "DashboardSection_userId_collectionId_key" ON public."DashboardSection" USING btree ("userId", "collectionId");


--
-- Name: Link_collectionId_idx; Type: INDEX; Schema: public; Owner: valknar
--

CREATE INDEX "Link_collectionId_idx" ON public."Link" USING btree ("collectionId");


--
-- Name: PasswordResetToken_token_key; Type: INDEX; Schema: public; Owner: valknar
--

CREATE UNIQUE INDEX "PasswordResetToken_token_key" ON public."PasswordResetToken" USING btree (token);


--
-- Name: Subscription_stripeSubscriptionId_key; Type: INDEX; Schema: public; Owner: valknar
--

CREATE UNIQUE INDEX "Subscription_stripeSubscriptionId_key" ON public."Subscription" USING btree ("stripeSubscriptionId");


--
-- Name: Subscription_userId_key; Type: INDEX; Schema: public; Owner: valknar
--

CREATE UNIQUE INDEX "Subscription_userId_key" ON public."Subscription" USING btree ("userId");


--
-- Name: Tag_name_ownerId_key; Type: INDEX; Schema: public; Owner: valknar
--

CREATE UNIQUE INDEX "Tag_name_ownerId_key" ON public."Tag" USING btree (name, "ownerId");


--
-- Name: Tag_ownerId_idx; Type: INDEX; Schema: public; Owner: valknar
--

CREATE INDEX "Tag_ownerId_idx" ON public."Tag" USING btree ("ownerId");


--
-- Name: User_email_key; Type: INDEX; Schema: public; Owner: valknar
--

CREATE UNIQUE INDEX "User_email_key" ON public."User" USING btree (email);


--
-- Name: User_username_key; Type: INDEX; Schema: public; Owner: valknar
--

CREATE UNIQUE INDEX "User_username_key" ON public."User" USING btree (username);


--
-- Name: UsersAndCollections_userId_idx; Type: INDEX; Schema: public; Owner: valknar
--

CREATE INDEX "UsersAndCollections_userId_idx" ON public."UsersAndCollections" USING btree ("userId");


--
-- Name: VerificationToken_identifier_token_key; Type: INDEX; Schema: public; Owner: valknar
--

CREATE UNIQUE INDEX "VerificationToken_identifier_token_key" ON public."VerificationToken" USING btree (identifier, token);


--
-- Name: VerificationToken_token_key; Type: INDEX; Schema: public; Owner: valknar
--

CREATE UNIQUE INDEX "VerificationToken_token_key" ON public."VerificationToken" USING btree (token);


--
-- Name: _LinkToTag_B_index; Type: INDEX; Schema: public; Owner: valknar
--

CREATE INDEX "_LinkToTag_B_index" ON public."_LinkToTag" USING btree ("B");


--
-- Name: _PinnedLinks_B_index; Type: INDEX; Schema: public; Owner: valknar
--

CREATE INDEX "_PinnedLinks_B_index" ON public."_PinnedLinks" USING btree ("B");


--
-- Name: AccessToken AccessToken_userId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: valknar
--

ALTER TABLE ONLY public."AccessToken"
    ADD CONSTRAINT "AccessToken_userId_fkey" FOREIGN KEY ("userId") REFERENCES public."User"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: Account Account_userId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: valknar
--

ALTER TABLE ONLY public."Account"
    ADD CONSTRAINT "Account_userId_fkey" FOREIGN KEY ("userId") REFERENCES public."User"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: Collection Collection_createdById_fkey; Type: FK CONSTRAINT; Schema: public; Owner: valknar
--

ALTER TABLE ONLY public."Collection"
    ADD CONSTRAINT "Collection_createdById_fkey" FOREIGN KEY ("createdById") REFERENCES public."User"(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: Collection Collection_ownerId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: valknar
--

ALTER TABLE ONLY public."Collection"
    ADD CONSTRAINT "Collection_ownerId_fkey" FOREIGN KEY ("ownerId") REFERENCES public."User"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: Collection Collection_parentId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: valknar
--

ALTER TABLE ONLY public."Collection"
    ADD CONSTRAINT "Collection_parentId_fkey" FOREIGN KEY ("parentId") REFERENCES public."Collection"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: DashboardSection DashboardSection_collectionId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: valknar
--

ALTER TABLE ONLY public."DashboardSection"
    ADD CONSTRAINT "DashboardSection_collectionId_fkey" FOREIGN KEY ("collectionId") REFERENCES public."Collection"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: DashboardSection DashboardSection_userId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: valknar
--

ALTER TABLE ONLY public."DashboardSection"
    ADD CONSTRAINT "DashboardSection_userId_fkey" FOREIGN KEY ("userId") REFERENCES public."User"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: Highlight Highlight_linkId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: valknar
--

ALTER TABLE ONLY public."Highlight"
    ADD CONSTRAINT "Highlight_linkId_fkey" FOREIGN KEY ("linkId") REFERENCES public."Link"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: Highlight Highlight_userId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: valknar
--

ALTER TABLE ONLY public."Highlight"
    ADD CONSTRAINT "Highlight_userId_fkey" FOREIGN KEY ("userId") REFERENCES public."User"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: Link Link_collectionId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: valknar
--

ALTER TABLE ONLY public."Link"
    ADD CONSTRAINT "Link_collectionId_fkey" FOREIGN KEY ("collectionId") REFERENCES public."Collection"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: Link Link_createdById_fkey; Type: FK CONSTRAINT; Schema: public; Owner: valknar
--

ALTER TABLE ONLY public."Link"
    ADD CONSTRAINT "Link_createdById_fkey" FOREIGN KEY ("createdById") REFERENCES public."User"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: RssSubscription RssSubscription_collectionId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: valknar
--

ALTER TABLE ONLY public."RssSubscription"
    ADD CONSTRAINT "RssSubscription_collectionId_fkey" FOREIGN KEY ("collectionId") REFERENCES public."Collection"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: Subscription Subscription_userId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: valknar
--

ALTER TABLE ONLY public."Subscription"
    ADD CONSTRAINT "Subscription_userId_fkey" FOREIGN KEY ("userId") REFERENCES public."User"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: Tag Tag_ownerId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: valknar
--

ALTER TABLE ONLY public."Tag"
    ADD CONSTRAINT "Tag_ownerId_fkey" FOREIGN KEY ("ownerId") REFERENCES public."User"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: User User_parentSubscriptionId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: valknar
--

ALTER TABLE ONLY public."User"
    ADD CONSTRAINT "User_parentSubscriptionId_fkey" FOREIGN KEY ("parentSubscriptionId") REFERENCES public."Subscription"(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: UsersAndCollections UsersAndCollections_collectionId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: valknar
--

ALTER TABLE ONLY public."UsersAndCollections"
    ADD CONSTRAINT "UsersAndCollections_collectionId_fkey" FOREIGN KEY ("collectionId") REFERENCES public."Collection"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: UsersAndCollections UsersAndCollections_userId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: valknar
--

ALTER TABLE ONLY public."UsersAndCollections"
    ADD CONSTRAINT "UsersAndCollections_userId_fkey" FOREIGN KEY ("userId") REFERENCES public."User"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: WhitelistedUser WhitelistedUser_userId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: valknar
--

ALTER TABLE ONLY public."WhitelistedUser"
    ADD CONSTRAINT "WhitelistedUser_userId_fkey" FOREIGN KEY ("userId") REFERENCES public."User"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: _LinkToTag _LinkToTag_A_fkey; Type: FK CONSTRAINT; Schema: public; Owner: valknar
--

ALTER TABLE ONLY public."_LinkToTag"
    ADD CONSTRAINT "_LinkToTag_A_fkey" FOREIGN KEY ("A") REFERENCES public."Link"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: _LinkToTag _LinkToTag_B_fkey; Type: FK CONSTRAINT; Schema: public; Owner: valknar
--

ALTER TABLE ONLY public."_LinkToTag"
    ADD CONSTRAINT "_LinkToTag_B_fkey" FOREIGN KEY ("B") REFERENCES public."Tag"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: _PinnedLinks _PinnedLinks_A_fkey; Type: FK CONSTRAINT; Schema: public; Owner: valknar
--

ALTER TABLE ONLY public."_PinnedLinks"
    ADD CONSTRAINT "_PinnedLinks_A_fkey" FOREIGN KEY ("A") REFERENCES public."Link"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: _PinnedLinks _PinnedLinks_B_fkey; Type: FK CONSTRAINT; Schema: public; Owner: valknar
--

ALTER TABLE ONLY public."_PinnedLinks"
    ADD CONSTRAINT "_PinnedLinks_B_fkey" FOREIGN KEY ("B") REFERENCES public."User"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- PostgreSQL database dump complete
--

\unrestrict Jr7bpL5DlbYOT9anYLBvMPUgL3LrKNkSpKPc66trPomFLzSKpFL54Nc8y77NUXM

