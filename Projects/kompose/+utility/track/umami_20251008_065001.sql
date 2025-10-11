--
-- PostgreSQL database dump
--

\restrict qFLeMhL9EcmHQkcdUv11HFLl8cM2o86GnCCrm0KNKGmeMCVBWrPbDQMdHMBz6yI

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
-- Name: pgcrypto; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pgcrypto WITH SCHEMA public;


--
-- Name: EXTENSION pgcrypto; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION pgcrypto IS 'cryptographic functions';


SET default_tablespace = '';

SET default_table_access_method = heap;

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
-- Name: event_data; Type: TABLE; Schema: public; Owner: valknar
--

CREATE TABLE public.event_data (
    event_data_id uuid NOT NULL,
    website_id uuid NOT NULL,
    website_event_id uuid NOT NULL,
    data_key character varying(500) NOT NULL,
    string_value character varying(500),
    number_value numeric(19,4),
    date_value timestamp(6) with time zone,
    data_type integer NOT NULL,
    created_at timestamp(6) with time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.event_data OWNER TO valknar;

--
-- Name: report; Type: TABLE; Schema: public; Owner: valknar
--

CREATE TABLE public.report (
    report_id uuid NOT NULL,
    user_id uuid NOT NULL,
    website_id uuid NOT NULL,
    type character varying(200) NOT NULL,
    name character varying(200) NOT NULL,
    description character varying(500) NOT NULL,
    parameters jsonb NOT NULL,
    created_at timestamp(6) with time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp(6) with time zone
);


ALTER TABLE public.report OWNER TO valknar;

--
-- Name: revenue; Type: TABLE; Schema: public; Owner: valknar
--

CREATE TABLE public.revenue (
    revenue_id uuid NOT NULL,
    website_id uuid NOT NULL,
    session_id uuid NOT NULL,
    event_id uuid NOT NULL,
    event_name character varying(50) NOT NULL,
    currency character varying(100) NOT NULL,
    revenue numeric(19,4),
    created_at timestamp(6) with time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.revenue OWNER TO valknar;

--
-- Name: segment; Type: TABLE; Schema: public; Owner: valknar
--

CREATE TABLE public.segment (
    segment_id uuid NOT NULL,
    website_id uuid NOT NULL,
    type character varying(200) NOT NULL,
    name character varying(200) NOT NULL,
    parameters jsonb NOT NULL,
    created_at timestamp(6) with time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp(6) with time zone
);


ALTER TABLE public.segment OWNER TO valknar;

--
-- Name: session; Type: TABLE; Schema: public; Owner: valknar
--

CREATE TABLE public.session (
    session_id uuid NOT NULL,
    website_id uuid NOT NULL,
    browser character varying(20),
    os character varying(20),
    device character varying(20),
    screen character varying(11),
    language character varying(35),
    country character(2),
    region character varying(20),
    city character varying(50),
    created_at timestamp(6) with time zone DEFAULT CURRENT_TIMESTAMP,
    distinct_id character varying(50)
);


ALTER TABLE public.session OWNER TO valknar;

--
-- Name: session_data; Type: TABLE; Schema: public; Owner: valknar
--

CREATE TABLE public.session_data (
    session_data_id uuid NOT NULL,
    website_id uuid NOT NULL,
    session_id uuid NOT NULL,
    data_key character varying(500) NOT NULL,
    string_value character varying(500),
    number_value numeric(19,4),
    date_value timestamp(6) with time zone,
    data_type integer NOT NULL,
    created_at timestamp(6) with time zone DEFAULT CURRENT_TIMESTAMP,
    distinct_id character varying(50)
);


ALTER TABLE public.session_data OWNER TO valknar;

--
-- Name: team; Type: TABLE; Schema: public; Owner: valknar
--

CREATE TABLE public.team (
    team_id uuid NOT NULL,
    name character varying(50) NOT NULL,
    access_code character varying(50),
    created_at timestamp(6) with time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp(6) with time zone,
    deleted_at timestamp(6) with time zone,
    logo_url character varying(2183)
);


ALTER TABLE public.team OWNER TO valknar;

--
-- Name: team_user; Type: TABLE; Schema: public; Owner: valknar
--

CREATE TABLE public.team_user (
    team_user_id uuid NOT NULL,
    team_id uuid NOT NULL,
    user_id uuid NOT NULL,
    role character varying(50) NOT NULL,
    created_at timestamp(6) with time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp(6) with time zone
);


ALTER TABLE public.team_user OWNER TO valknar;

--
-- Name: user; Type: TABLE; Schema: public; Owner: valknar
--

CREATE TABLE public."user" (
    user_id uuid NOT NULL,
    username character varying(255) NOT NULL,
    password character varying(60) NOT NULL,
    role character varying(50) NOT NULL,
    created_at timestamp(6) with time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp(6) with time zone,
    deleted_at timestamp(6) with time zone,
    display_name character varying(255),
    logo_url character varying(2183)
);


ALTER TABLE public."user" OWNER TO valknar;

--
-- Name: website; Type: TABLE; Schema: public; Owner: valknar
--

CREATE TABLE public.website (
    website_id uuid NOT NULL,
    name character varying(100) NOT NULL,
    domain character varying(500),
    share_id character varying(50),
    reset_at timestamp(6) with time zone,
    user_id uuid,
    created_at timestamp(6) with time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp(6) with time zone,
    deleted_at timestamp(6) with time zone,
    created_by uuid,
    team_id uuid
);


ALTER TABLE public.website OWNER TO valknar;

--
-- Name: website_event; Type: TABLE; Schema: public; Owner: valknar
--

CREATE TABLE public.website_event (
    event_id uuid NOT NULL,
    website_id uuid NOT NULL,
    session_id uuid NOT NULL,
    created_at timestamp(6) with time zone DEFAULT CURRENT_TIMESTAMP,
    url_path character varying(500) NOT NULL,
    url_query character varying(500),
    referrer_path character varying(500),
    referrer_query character varying(500),
    referrer_domain character varying(500),
    page_title character varying(500),
    event_type integer DEFAULT 1 NOT NULL,
    event_name character varying(50),
    visit_id uuid NOT NULL,
    tag character varying(50),
    fbclid character varying(255),
    gclid character varying(255),
    li_fat_id character varying(255),
    msclkid character varying(255),
    ttclid character varying(255),
    twclid character varying(255),
    utm_campaign character varying(255),
    utm_content character varying(255),
    utm_medium character varying(255),
    utm_source character varying(255),
    utm_term character varying(255),
    hostname character varying(100)
);


ALTER TABLE public.website_event OWNER TO valknar;

--
-- Data for Name: _prisma_migrations; Type: TABLE DATA; Schema: public; Owner: valknar
--

COPY public._prisma_migrations (id, checksum, finished_at, migration_name, logs, rolled_back_at, started_at, applied_steps_count) FROM stdin;
833ac2b4-8027-433b-9af2-f054ecb0055b	65f0f9ee4a3b432e7fa917795033254887497a849d95acf7d9cb4ff24b45f98f	2025-09-30 16:34:18.718627+00	01_init	\N	\N	2025-09-30 16:34:18.706382+00	1
1dc2255b-907c-4751-a442-5cd1d8faf369	4cc3c14482cb8700574cbdbdb478a93ccd1cabb0aeed37dfffb77a80278ce575	2025-09-30 16:34:18.722915+00	02_report_schema_session_data	\N	\N	2025-09-30 16:34:18.719116+00	1
c66ee6fe-9c3e-41f2-a375-cafa93c0e57b	baf86a7adc077bc46ea646d86aabc5f613aeb311e63894366979a18f6a9ca48c	2025-09-30 16:34:18.727794+00	03_metric_performance_index	\N	\N	2025-09-30 16:34:18.7234+00	1
c6ea0fc8-870f-490f-ac75-74e137d12f99	eb0e4ae2ef5204bc67ddb248358a402cd3bd88567d710f808f16c5124e5fd9cb	2025-09-30 16:34:18.731574+00	04_team_redesign	\N	\N	2025-09-30 16:34:18.728287+00	1
96632bdc-d990-42b4-b1f7-2b44982be685	12e5b277e41da871b0768118937cef221c4d4f9c3206b719fffba86324df7a11	2025-09-30 16:34:18.734337+00	05_add_visit_id	\N	\N	2025-09-30 16:34:18.732052+00	1
83fe0e40-7d56-4778-ad6f-cabfadd0b8c4	fcd8585d077229bb2a16ae4705a79a5bc31cf6cbca089de99f4b1c19cb0a0a17	2025-09-30 16:34:18.737057+00	06_session_data	\N	\N	2025-09-30 16:34:18.734799+00	1
150c08af-a69c-48ff-b576-f099e8e81ac3	c38c9605d759b3b00f94076c929b6081d7dbd01a25d2955909fc8d1a6e3276b4	2025-09-30 16:34:18.739163+00	07_add_tag	\N	\N	2025-09-30 16:34:18.737521+00	1
63ec0b30-99f0-4a39-8caf-cd6d74102d58	ad640f709cd22434c088d577a2cf124c275fe3dc53ca249a542ae05af66b07b6	2025-09-30 16:34:18.741356+00	08_add_utm_clid	\N	\N	2025-09-30 16:34:18.739633+00	1
e0ba33c7-7fa8-4c35-8854-e2286dd963e0	e94d9993b17ac5c330ae3f872fd5869fb8095a3f3a7d31d2aaade73dc45fbe9c	2025-09-30 16:34:18.744531+00	09_update_hostname_region	\N	\N	2025-09-30 16:34:18.741814+00	1
2ec6bbc9-bef3-46c8-bf42-f1d52ff8a8bc	6ece5066ccec715ca8a07b65eafde7f96d110c0638b2d2187398fd1a79770ff6	2025-09-30 16:34:18.74646+00	10_add_distinct_id	\N	\N	2025-09-30 16:34:18.744984+00	1
47f564ac-d8ea-4235-85d8-3eb06210eda4	e7421573e8b15f8a5c3e0928f1564ab43b3855d7c6634a36d87ece68196900e5	2025-09-30 16:34:18.749115+00	11_add_segment	\N	\N	2025-09-30 16:34:18.746918+00	1
f470fdda-3297-459b-9f65-dab40602bcc8	f74b307b6e62c8457f32c4bae0beb99e26eb384467755912714abdfeae9e09af	2025-09-30 16:34:18.752741+00	12_update_report_parameter	\N	\N	2025-09-30 16:34:18.749594+00	1
7427479b-5911-4929-ae19-b26dd82d0b91	53180616f450ac033a60143ff9b7c3656205947809c7979a51991922e7f326ad	2025-09-30 16:34:18.755989+00	13_add_revenue	\N	\N	2025-09-30 16:34:18.753195+00	1
\.


--
-- Data for Name: event_data; Type: TABLE DATA; Schema: public; Owner: valknar
--

COPY public.event_data (event_data_id, website_id, website_event_id, data_key, string_value, number_value, date_value, data_type, created_at) FROM stdin;
86312c38-411c-4ce7-a87a-19d3e17cfc6e	f2398e3b-d5f3-4dc3-8580-aba6e9ae3ef2	9a7be3d8-b3c6-49bc-a505-b810edd12315	title	SexyArt - In The Opera	\N	\N	1	2025-10-08 02:28:50.574+00
ce530416-b487-4c50-a6a5-252cf5a2e37d	f2398e3b-d5f3-4dc3-8580-aba6e9ae3ef2	9a7be3d8-b3c6-49bc-a505-b810edd12315	id	009f5bad-9a8a-401e-9cb1-5792fa41337f	\N	\N	1	2025-10-08 02:28:50.574+00
\.


--
-- Data for Name: report; Type: TABLE DATA; Schema: public; Owner: valknar
--

COPY public.report (report_id, user_id, website_id, type, name, description, parameters, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: revenue; Type: TABLE DATA; Schema: public; Owner: valknar
--

COPY public.revenue (revenue_id, website_id, session_id, event_id, event_name, currency, revenue, created_at) FROM stdin;
\.


--
-- Data for Name: segment; Type: TABLE DATA; Schema: public; Owner: valknar
--

COPY public.segment (segment_id, website_id, type, name, parameters, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: session; Type: TABLE DATA; Schema: public; Owner: valknar
--

COPY public.session (session_id, website_id, browser, os, device, screen, language, country, region, city, created_at, distinct_id) FROM stdin;
df5e456a-7abd-5b7b-a6dc-ed57c4775369	26158eb8-e0ae-4985-aa91-2f4a652f8ccb	chrome	Linux	desktop	2327x1309	de-DE	DE	DE-RP	Mainz	2025-10-08 01:54:16.506+00	\N
6363a49c-c5c3-58db-8e14-7182141e9a56	f2398e3b-d5f3-4dc3-8580-aba6e9ae3ef2	chrome	Linux	desktop	2327x1309	de-DE	DE	DE-RP	Mainz	2025-10-08 02:02:47.32+00	\N
98a9cf0a-d48f-5203-9084-d5fd5b43b56d	26158eb8-e0ae-4985-aa91-2f4a652f8ccb	chrome	Linux	desktop	2327x1309	de-DE	\N	\N	\N	2025-10-08 03:56:53.171+00	\N
4e15819d-166c-5b35-bee3-bef499917fd7	f2398e3b-d5f3-4dc3-8580-aba6e9ae3ef2	chrome	Linux	desktop	2327x1309	de-DE	\N	\N	\N	2025-10-08 03:56:58.313+00	\N
\.


--
-- Data for Name: session_data; Type: TABLE DATA; Schema: public; Owner: valknar
--

COPY public.session_data (session_data_id, website_id, session_id, data_key, string_value, number_value, date_value, data_type, created_at, distinct_id) FROM stdin;
\.


--
-- Data for Name: team; Type: TABLE DATA; Schema: public; Owner: valknar
--

COPY public.team (team_id, name, access_code, created_at, updated_at, deleted_at, logo_url) FROM stdin;
\.


--
-- Data for Name: team_user; Type: TABLE DATA; Schema: public; Owner: valknar
--

COPY public.team_user (team_user_id, team_id, user_id, role, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: user; Type: TABLE DATA; Schema: public; Owner: valknar
--

COPY public."user" (user_id, username, password, role, created_at, updated_at, deleted_at, display_name, logo_url) FROM stdin;
41e2b680-648e-4b09-bcd7-3e2b10c06264	admin	$2b$10$BUli0c.muyCW1ErNJc3jL.vFRFtFJWrT8/GcR4A.sUdCznaXiqFXa	admin	2025-09-30 16:34:18.707669+00	\N	\N	\N	\N
\.


--
-- Data for Name: website; Type: TABLE DATA; Schema: public; Owner: valknar
--

COPY public.website (website_id, name, domain, share_id, reset_at, user_id, created_at, updated_at, deleted_at, created_by, team_id) FROM stdin;
26158eb8-e0ae-4985-aa91-2f4a652f8ccb	pivoine.art	pivoine.art	\N	\N	41e2b680-648e-4b09-bcd7-3e2b10c06264	2025-09-30 16:35:01.996+00	2025-09-30 16:35:01.996+00	\N	41e2b680-648e-4b09-bcd7-3e2b10c06264	\N
f2398e3b-d5f3-4dc3-8580-aba6e9ae3ef2	sexy.pivoine.art	sexy.pivoine.art	\N	\N	41e2b680-648e-4b09-bcd7-3e2b10c06264	2025-09-30 16:35:16.575+00	2025-09-30 16:35:16.575+00	\N	41e2b680-648e-4b09-bcd7-3e2b10c06264	\N
\.


--
-- Data for Name: website_event; Type: TABLE DATA; Schema: public; Owner: valknar
--

COPY public.website_event (event_id, website_id, session_id, created_at, url_path, url_query, referrer_path, referrer_query, referrer_domain, page_title, event_type, event_name, visit_id, tag, fbclid, gclid, li_fat_id, msclkid, ttclid, twclid, utm_campaign, utm_content, utm_medium, utm_source, utm_term, hostname) FROM stdin;
9b857702-bfe3-4135-989a-82afa920d5aa	26158eb8-e0ae-4985-aa91-2f4a652f8ccb	df5e456a-7abd-5b7b-a6dc-ed57c4775369	2025-10-08 01:54:16.502+00	/		\N	\N	\N	Pivoine.Art | Valknar’s	1	\N	819500c8-876e-5b5d-9373-8e43b31e15d1	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	pivoine.art
8468b061-ba18-4d27-9f3a-1dad73e088e6	26158eb8-e0ae-4985-aa91-2f4a652f8ccb	df5e456a-7abd-5b7b-a6dc-ed57c4775369	2025-10-08 01:54:29.184+00	/		\N	\N	\N	Pivoine.Art | Valknar’s	1	\N	819500c8-876e-5b5d-9373-8e43b31e15d1	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	pivoine.art
7839e4ea-7a26-452a-8a99-7c879f1ba853	f2398e3b-d5f3-4dc3-8580-aba6e9ae3ef2	6363a49c-c5c3-58db-8e14-7182141e9a56	2025-10-08 02:02:47.319+00	/		\N	\N	\N	SexyArt | Oops! An Error Occured	1	\N	1773f022-1be0-5609-a555-fb52301966ff	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	sexy.pivoine.art
87fe56c7-2547-409d-92ce-e8b8638bf380	f2398e3b-d5f3-4dc3-8580-aba6e9ae3ef2	6363a49c-c5c3-58db-8e14-7182141e9a56	2025-10-08 02:02:52.569+00	/models/		/		sexy.pivoine.art	SexyArt | Oops! An Error Occured	1	\N	1773f022-1be0-5609-a555-fb52301966ff	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	sexy.pivoine.art
31bf12fc-7bf3-4ed8-861b-0ff35beb8931	f2398e3b-d5f3-4dc3-8580-aba6e9ae3ef2	6363a49c-c5c3-58db-8e14-7182141e9a56	2025-10-08 02:02:57.203+00	/models/		\N	\N	\N	SexyArt | Oops! An Error Occured	1	\N	1773f022-1be0-5609-a555-fb52301966ff	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	sexy.pivoine.art
60a95bcb-c60c-4c7b-8425-05bcfb36547c	f2398e3b-d5f3-4dc3-8580-aba6e9ae3ef2	6363a49c-c5c3-58db-8e14-7182141e9a56	2025-10-08 02:03:16.221+00	/api/admin		\N	\N	\N	SexyArt | Oops! Page Not Found	1	\N	1773f022-1be0-5609-a555-fb52301966ff	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	sexy.pivoine.art
2092c2f6-01f2-427e-ad9c-98be85ed569a	f2398e3b-d5f3-4dc3-8580-aba6e9ae3ef2	6363a49c-c5c3-58db-8e14-7182141e9a56	2025-10-08 02:03:42.287+00	/api/admin		\N	\N	\N	SexyArt | Oops! Page Not Found	1	\N	1773f022-1be0-5609-a555-fb52301966ff	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	sexy.pivoine.art
820d3139-9f7b-43c0-9d36-8dc5be47899b	f2398e3b-d5f3-4dc3-8580-aba6e9ae3ef2	6363a49c-c5c3-58db-8e14-7182141e9a56	2025-10-08 02:04:53.78+00	/		\N	\N	\N	SexyArt | Where Love Meets Artistry	1	\N	1773f022-1be0-5609-a555-fb52301966ff	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	sexy.pivoine.art
d0296dc8-5f18-492d-9ab1-625772abf91a	f2398e3b-d5f3-4dc3-8580-aba6e9ae3ef2	6363a49c-c5c3-58db-8e14-7182141e9a56	2025-10-08 02:05:02.23+00	/magazine/		/		sexy.pivoine.art	SexyArt | SexyArt Magazine	1	\N	1773f022-1be0-5609-a555-fb52301966ff	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	sexy.pivoine.art
3e1bebe7-7a2c-4240-b542-43bb187fbffc	f2398e3b-d5f3-4dc3-8580-aba6e9ae3ef2	6363a49c-c5c3-58db-8e14-7182141e9a56	2025-10-08 02:05:04.388+00	/videos/		/magazine/		sexy.pivoine.art	SexyArt | Your Videos	1	\N	1773f022-1be0-5609-a555-fb52301966ff	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	sexy.pivoine.art
39bd6382-538e-4a19-9dd3-4fb5b3f367a1	f2398e3b-d5f3-4dc3-8580-aba6e9ae3ef2	6363a49c-c5c3-58db-8e14-7182141e9a56	2025-10-08 02:06:37.053+00	/		\N	\N	\N	SexyArt | Where Love Meets Artistry	1	\N	1773f022-1be0-5609-a555-fb52301966ff	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	sexy.pivoine.art
f1cc4ee9-5cfb-4e0a-b503-ef107af86868	f2398e3b-d5f3-4dc3-8580-aba6e9ae3ef2	6363a49c-c5c3-58db-8e14-7182141e9a56	2025-10-08 02:06:43.605+00	/login/		/		sexy.pivoine.art	SexyArt | Sign In	1	\N	1773f022-1be0-5609-a555-fb52301966ff	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	sexy.pivoine.art
0b9bc00d-cc26-48d2-82be-6e5cffbd9e7e	f2398e3b-d5f3-4dc3-8580-aba6e9ae3ef2	6363a49c-c5c3-58db-8e14-7182141e9a56	2025-10-08 02:06:45.919+00	/videos/		/login/		sexy.pivoine.art	SexyArt | Your Videos	1	\N	1773f022-1be0-5609-a555-fb52301966ff	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	sexy.pivoine.art
2462cba8-a55e-4710-81b1-a42cc6b2806b	f2398e3b-d5f3-4dc3-8580-aba6e9ae3ef2	6363a49c-c5c3-58db-8e14-7182141e9a56	2025-10-08 02:21:18.735+00	/videos/		\N	\N	\N	SexyArt | Your Videos	1	\N	1773f022-1be0-5609-a555-fb52301966ff	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	sexy.pivoine.art
057c39e8-86df-4b7e-a492-726d72659b57	f2398e3b-d5f3-4dc3-8580-aba6e9ae3ef2	6363a49c-c5c3-58db-8e14-7182141e9a56	2025-10-08 02:21:22.669+00	/videos/		\N	\N	\N	SexyArt | Your Videos	1	\N	1773f022-1be0-5609-a555-fb52301966ff	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	sexy.pivoine.art
5ab54e5a-b509-448f-b0b9-cd33cce9192f	f2398e3b-d5f3-4dc3-8580-aba6e9ae3ef2	6363a49c-c5c3-58db-8e14-7182141e9a56	2025-10-08 02:21:25.962+00	/models/		/videos/		sexy.pivoine.art	SexyArt | Our Models	1	\N	1773f022-1be0-5609-a555-fb52301966ff	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	sexy.pivoine.art
a5b76a2c-ae2d-4798-acd9-1a975be9d2df	f2398e3b-d5f3-4dc3-8580-aba6e9ae3ef2	6363a49c-c5c3-58db-8e14-7182141e9a56	2025-10-08 02:21:28.324+00	/videos/		/models/		sexy.pivoine.art	SexyArt | Your Videos	1	\N	1773f022-1be0-5609-a555-fb52301966ff	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	sexy.pivoine.art
71126ff1-ddb9-407f-96bf-005597a772ee	f2398e3b-d5f3-4dc3-8580-aba6e9ae3ef2	6363a49c-c5c3-58db-8e14-7182141e9a56	2025-10-08 02:21:31.127+00	/videos/		\N	\N	\N	SexyArt | Your Videos	1	\N	1773f022-1be0-5609-a555-fb52301966ff	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	sexy.pivoine.art
0f4f61c3-d4fd-4a22-93b1-70fdf3ac0e4e	f2398e3b-d5f3-4dc3-8580-aba6e9ae3ef2	6363a49c-c5c3-58db-8e14-7182141e9a56	2025-10-08 02:21:56.557+00	/		/videos/		sexy.pivoine.art	SexyArt | Where Love Meets Artistry	1	\N	1773f022-1be0-5609-a555-fb52301966ff	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	sexy.pivoine.art
832ec70a-8083-4c17-941c-7e6bfc8c9184	f2398e3b-d5f3-4dc3-8580-aba6e9ae3ef2	6363a49c-c5c3-58db-8e14-7182141e9a56	2025-10-08 02:22:00.955+00	/		\N	\N	\N	SexyArt | Where Love Meets Artistry	1	\N	1773f022-1be0-5609-a555-fb52301966ff	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	sexy.pivoine.art
6a1b40de-5eb9-4a68-b450-c13825527e8d	f2398e3b-d5f3-4dc3-8580-aba6e9ae3ef2	6363a49c-c5c3-58db-8e14-7182141e9a56	2025-10-08 02:22:06.326+00	/login/		/		sexy.pivoine.art	SexyArt | Sign In	1	\N	1773f022-1be0-5609-a555-fb52301966ff	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	sexy.pivoine.art
70a482f2-ad39-40ad-b616-1854e4b90fe4	f2398e3b-d5f3-4dc3-8580-aba6e9ae3ef2	6363a49c-c5c3-58db-8e14-7182141e9a56	2025-10-08 02:22:08.659+00	/		/login/		sexy.pivoine.art	SexyArt | Where Love Meets Artistry	1	\N	1773f022-1be0-5609-a555-fb52301966ff	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	sexy.pivoine.art
90d39ad9-c899-4eaf-ab24-2af324f2ace3	f2398e3b-d5f3-4dc3-8580-aba6e9ae3ef2	6363a49c-c5c3-58db-8e14-7182141e9a56	2025-10-08 02:22:59.988+00	/		\N	\N	\N	SexyArt | Where Love Meets Artistry	1	\N	1773f022-1be0-5609-a555-fb52301966ff	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	sexy.pivoine.art
6172612f-d5d4-48e9-a743-31f551e24409	f2398e3b-d5f3-4dc3-8580-aba6e9ae3ef2	6363a49c-c5c3-58db-8e14-7182141e9a56	2025-10-08 02:23:06.291+00	/videos/		/		sexy.pivoine.art	SexyArt | Your Videos	1	\N	1773f022-1be0-5609-a555-fb52301966ff	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	sexy.pivoine.art
fb448c37-f331-487e-a039-04c516c18da6	f2398e3b-d5f3-4dc3-8580-aba6e9ae3ef2	6363a49c-c5c3-58db-8e14-7182141e9a56	2025-10-08 02:23:11.016+00	/		/videos/		sexy.pivoine.art	SexyArt | Where Love Meets Artistry	1	\N	1773f022-1be0-5609-a555-fb52301966ff	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	sexy.pivoine.art
0f7869c6-523a-4d0e-bcb4-06b8773a0e81	f2398e3b-d5f3-4dc3-8580-aba6e9ae3ef2	6363a49c-c5c3-58db-8e14-7182141e9a56	2025-10-08 02:24:40.513+00	/		\N	\N	\N	SexyArt | Where Love Meets Artistry	1	\N	1773f022-1be0-5609-a555-fb52301966ff	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	sexy.pivoine.art
5de82d5e-4b67-4343-a9e9-f96522272425	f2398e3b-d5f3-4dc3-8580-aba6e9ae3ef2	6363a49c-c5c3-58db-8e14-7182141e9a56	2025-10-08 02:24:52.64+00	/		\N	\N	\N	SexyArt | Where Love Meets Artistry	1	\N	1773f022-1be0-5609-a555-fb52301966ff	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	sexy.pivoine.art
b2301919-ed36-4466-8d5d-c28aa6d9027d	f2398e3b-d5f3-4dc3-8580-aba6e9ae3ef2	6363a49c-c5c3-58db-8e14-7182141e9a56	2025-10-08 02:28:25.951+00	/videos/		/		sexy.pivoine.art	SexyArt | Your Videos	1	\N	1773f022-1be0-5609-a555-fb52301966ff	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	sexy.pivoine.art
a01ccd36-c154-4a7f-8a61-d5950fef7819	f2398e3b-d5f3-4dc3-8580-aba6e9ae3ef2	6363a49c-c5c3-58db-8e14-7182141e9a56	2025-10-08 02:28:46.996+00	/videos/sexyart-in-the-opera/		/videos/		sexy.pivoine.art	SexyArt | SexyArt - In The Opera	1	\N	1773f022-1be0-5609-a555-fb52301966ff	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	sexy.pivoine.art
9a7be3d8-b3c6-49bc-a505-b810edd12315	f2398e3b-d5f3-4dc3-8580-aba6e9ae3ef2	6363a49c-c5c3-58db-8e14-7182141e9a56	2025-10-08 02:28:50.574+00	/videos/sexyart-in-the-opera/		/videos/		sexy.pivoine.art	SexyArt | SexyArt - In The Opera	2	play-video	1773f022-1be0-5609-a555-fb52301966ff	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	sexy.pivoine.art
d217bf19-532a-4983-b10c-ce4a3f60816f	f2398e3b-d5f3-4dc3-8580-aba6e9ae3ef2	6363a49c-c5c3-58db-8e14-7182141e9a56	2025-10-08 02:37:25.377+00	/videos/sexyart-in-the-opera/		\N	\N	\N	SexyArt | SexyArt - In The Opera	1	\N	1773f022-1be0-5609-a555-fb52301966ff	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	sexy.pivoine.art
2a5b85ce-f4bd-44a6-b597-3e8f01c29f37	f2398e3b-d5f3-4dc3-8580-aba6e9ae3ef2	6363a49c-c5c3-58db-8e14-7182141e9a56	2025-10-08 02:37:28.19+00	/		/videos/sexyart-in-the-opera/		sexy.pivoine.art	SexyArt | Where Love Meets Artistry	1	\N	1773f022-1be0-5609-a555-fb52301966ff	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	sexy.pivoine.art
117f3fbe-68d9-48b1-9115-e212836fcb97	f2398e3b-d5f3-4dc3-8580-aba6e9ae3ef2	6363a49c-c5c3-58db-8e14-7182141e9a56	2025-10-08 03:17:09.95+00	/		\N	\N	\N	SexyArt | Where Love Meets Artistry	1	\N	d84fc565-66ba-5380-be31-1da4bf3e29a0	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	sexy.pivoine.art
e271d359-3d71-4567-95ca-08919e771e78	26158eb8-e0ae-4985-aa91-2f4a652f8ccb	df5e456a-7abd-5b7b-a6dc-ed57c4775369	2025-10-08 03:28:53.079+00	/		\N	\N	\N	Pivoine.Art | Valknar’s	1	\N	76288120-2567-5aa6-adc2-635a1ed20c50	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	pivoine.art
d3e3c622-640d-4cee-8b75-af367566a897	26158eb8-e0ae-4985-aa91-2f4a652f8ccb	df5e456a-7abd-5b7b-a6dc-ed57c4775369	2025-10-08 03:33:58.713+00	/		\N	\N	\N	Pivoine.Art | Valknar’s	1	\N	76288120-2567-5aa6-adc2-635a1ed20c50	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	pivoine.art
3a9fed41-7529-45e0-8084-a94c1f5b012a	26158eb8-e0ae-4985-aa91-2f4a652f8ccb	98a9cf0a-d48f-5203-9084-d5fd5b43b56d	2025-10-08 03:56:53.17+00	/		\N	\N	\N	Pivoine.Art | Valknar’s	1	\N	eb42c2b6-3af9-5bfe-9281-cf4bfa4674ea	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	pivoine.art
a47e3d1e-3378-453f-8f6f-ecde9e886250	26158eb8-e0ae-4985-aa91-2f4a652f8ccb	98a9cf0a-d48f-5203-9084-d5fd5b43b56d	2025-10-08 03:56:53.739+00	/		\N	\N	\N	Pivoine.Art | Valknar’s	1	\N	eb42c2b6-3af9-5bfe-9281-cf4bfa4674ea	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	pivoine.art
5689f8ca-f269-40fc-832c-e9e672b35397	f2398e3b-d5f3-4dc3-8580-aba6e9ae3ef2	4e15819d-166c-5b35-bee3-bef499917fd7	2025-10-08 03:56:58.312+00	/		\N	\N	\N	SexyArt | Where Love Meets Artistry	1	\N	84bb580f-2551-573e-a177-155c40614d01	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	sexy.pivoine.art
7db91c01-75d5-472b-b4b0-f1fb448eed55	26158eb8-e0ae-4985-aa91-2f4a652f8ccb	98a9cf0a-d48f-5203-9084-d5fd5b43b56d	2025-10-08 05:35:53.372+00	/		\N	\N	\N	Pivoine.Art | Valknar’s	1	\N	beba31fc-6dba-5d69-9fc3-dc673b44838c	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	pivoine.art
2282d8a1-c6c3-493e-95d7-7a015ba03151	26158eb8-e0ae-4985-aa91-2f4a652f8ccb	98a9cf0a-d48f-5203-9084-d5fd5b43b56d	2025-10-08 05:35:57.724+00	/		\N	\N	\N	Pivoine.Art | Valknar’s	1	\N	beba31fc-6dba-5d69-9fc3-dc673b44838c	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	pivoine.art
708bcd6a-6086-408b-b97f-5b48b71296d4	26158eb8-e0ae-4985-aa91-2f4a652f8ccb	98a9cf0a-d48f-5203-9084-d5fd5b43b56d	2025-10-08 06:16:47.847+00	/		\N	\N	\N	Pivoine.Art | Valknar’s	1	\N	b3faf6ba-72ff-57f7-8e35-5fa3ca13ea12	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	pivoine.art
9667e6d8-b9a0-45f9-b2fd-2ca87059835f	26158eb8-e0ae-4985-aa91-2f4a652f8ccb	98a9cf0a-d48f-5203-9084-d5fd5b43b56d	2025-10-08 06:17:17.373+00	/		\N	\N	\N	Pivoine.Art | Valknar’s	1	\N	b3faf6ba-72ff-57f7-8e35-5fa3ca13ea12	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	pivoine.art
e4353bb3-10e4-4f94-a7b9-92cc73ce5dea	f2398e3b-d5f3-4dc3-8580-aba6e9ae3ef2	4e15819d-166c-5b35-bee3-bef499917fd7	2025-10-08 06:45:17.686+00	/		\N	\N	\N	SexyArt | Where Love Meets Artistry	1	\N	e454410a-337b-518b-b587-7c831b6073ec	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	sexy.pivoine.art
4960f084-346e-4d1f-a747-b5deddb619e4	f2398e3b-d5f3-4dc3-8580-aba6e9ae3ef2	4e15819d-166c-5b35-bee3-bef499917fd7	2025-10-08 06:45:23.483+00	/		\N	\N	\N	SexyArt | Where Love Meets Artistry	1	\N	e454410a-337b-518b-b587-7c831b6073ec	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	sexy.pivoine.art
6bfa1f19-9ee3-4058-bb2d-ec2f9f11f06e	f2398e3b-d5f3-4dc3-8580-aba6e9ae3ef2	4e15819d-166c-5b35-bee3-bef499917fd7	2025-10-08 06:46:07.833+00	/		\N	\N	\N	SexyArt | Where Love Meets Artistry	1	\N	e454410a-337b-518b-b587-7c831b6073ec	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	sexy.pivoine.art
fa557a8c-e43b-455b-9784-83b35880815e	f2398e3b-d5f3-4dc3-8580-aba6e9ae3ef2	4e15819d-166c-5b35-bee3-bef499917fd7	2025-10-08 06:46:15.709+00	/videos/sexyart-in-the-opera/		/		sexy.pivoine.art	SexyArt | SexyArt - In The Opera	1	\N	e454410a-337b-518b-b587-7c831b6073ec	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	sexy.pivoine.art
02d2ae60-948f-4150-9648-2c57bbb0e786	f2398e3b-d5f3-4dc3-8580-aba6e9ae3ef2	4e15819d-166c-5b35-bee3-bef499917fd7	2025-10-08 06:47:01.686+00	/videos/sexyart-in-the-opera/		\N	\N	\N	SexyArt | SexyArt - In The Opera	1	\N	e454410a-337b-518b-b587-7c831b6073ec	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	sexy.pivoine.art
5b1c920d-4af6-463e-9466-24eb8dd62816	f2398e3b-d5f3-4dc3-8580-aba6e9ae3ef2	4e15819d-166c-5b35-bee3-bef499917fd7	2025-10-08 06:47:35.818+00	/videos/sexyart-in-the-opera/		\N	\N	\N	SexyArt | SexyArt - In The Opera	1	\N	e454410a-337b-518b-b587-7c831b6073ec	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	sexy.pivoine.art
d8eae487-721b-4ccf-b50e-a68ff345fcc1	f2398e3b-d5f3-4dc3-8580-aba6e9ae3ef2	4e15819d-166c-5b35-bee3-bef499917fd7	2025-10-08 06:47:40.976+00	/		/videos/sexyart-in-the-opera/		sexy.pivoine.art	SexyArt | Where Love Meets Artistry	1	\N	e454410a-337b-518b-b587-7c831b6073ec	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	sexy.pivoine.art
5cae3022-8e8e-4dd6-80ca-80fc56874202	f2398e3b-d5f3-4dc3-8580-aba6e9ae3ef2	4e15819d-166c-5b35-bee3-bef499917fd7	2025-10-08 06:47:52.266+00	/videos/sexyart-in-the-opera/		/		sexy.pivoine.art	SexyArt | SexyArt - In The Opera	1	\N	e454410a-337b-518b-b587-7c831b6073ec	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	sexy.pivoine.art
8def7ae7-86ba-4ca4-a38c-b07602f804a9	f2398e3b-d5f3-4dc3-8580-aba6e9ae3ef2	4e15819d-166c-5b35-bee3-bef499917fd7	2025-10-08 06:47:54.752+00	/videos/sexyart-in-the-opera/		\N	\N	\N	SexyArt | SexyArt - In The Opera	1	\N	e454410a-337b-518b-b587-7c831b6073ec	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	sexy.pivoine.art
f7c38053-7b8e-49dc-b8be-48abd51ff721	f2398e3b-d5f3-4dc3-8580-aba6e9ae3ef2	4e15819d-166c-5b35-bee3-bef499917fd7	2025-10-08 06:47:58.696+00	/magazine/		/videos/sexyart-in-the-opera/		sexy.pivoine.art	SexyArt | SexyArt Magazine	1	\N	e454410a-337b-518b-b587-7c831b6073ec	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	sexy.pivoine.art
2c28a4c6-54d1-48ae-842b-403fc2191626	f2398e3b-d5f3-4dc3-8580-aba6e9ae3ef2	4e15819d-166c-5b35-bee3-bef499917fd7	2025-10-08 06:48:01.566+00	/about/		/magazine/		sexy.pivoine.art	SexyArt | About SexyArt	1	\N	e454410a-337b-518b-b587-7c831b6073ec	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	sexy.pivoine.art
4b549c97-83f7-4b7c-8e14-0c354c700adb	f2398e3b-d5f3-4dc3-8580-aba6e9ae3ef2	4e15819d-166c-5b35-bee3-bef499917fd7	2025-10-08 06:48:11.529+00	/videos/		/about/		sexy.pivoine.art	SexyArt | Your Videos	1	\N	e454410a-337b-518b-b587-7c831b6073ec	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	sexy.pivoine.art
8aefed28-3e3e-4303-aeb1-670f9024ed32	f2398e3b-d5f3-4dc3-8580-aba6e9ae3ef2	4e15819d-166c-5b35-bee3-bef499917fd7	2025-10-08 06:48:16.419+00	/videos/sexyart-in-the-opera/		/videos/		sexy.pivoine.art	SexyArt | SexyArt - In The Opera	1	\N	e454410a-337b-518b-b587-7c831b6073ec	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	sexy.pivoine.art
9e74c8af-7139-4f5b-8f32-59c773918718	f2398e3b-d5f3-4dc3-8580-aba6e9ae3ef2	4e15819d-166c-5b35-bee3-bef499917fd7	2025-10-08 06:48:22.027+00	/videos/		\N	\N	\N	SexyArt | Your Videos	1	\N	e454410a-337b-518b-b587-7c831b6073ec	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	sexy.pivoine.art
4a6719ef-2332-4a21-bff5-4e5a5af06588	f2398e3b-d5f3-4dc3-8580-aba6e9ae3ef2	4e15819d-166c-5b35-bee3-bef499917fd7	2025-10-08 06:48:24.018+00	/videos/sexyart-in-the-opera/		/videos/		sexy.pivoine.art	SexyArt | SexyArt - In The Opera	1	\N	e454410a-337b-518b-b587-7c831b6073ec	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	sexy.pivoine.art
\.


--
-- Name: _prisma_migrations _prisma_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: valknar
--

ALTER TABLE ONLY public._prisma_migrations
    ADD CONSTRAINT _prisma_migrations_pkey PRIMARY KEY (id);


--
-- Name: event_data event_data_pkey; Type: CONSTRAINT; Schema: public; Owner: valknar
--

ALTER TABLE ONLY public.event_data
    ADD CONSTRAINT event_data_pkey PRIMARY KEY (event_data_id);


--
-- Name: report report_pkey; Type: CONSTRAINT; Schema: public; Owner: valknar
--

ALTER TABLE ONLY public.report
    ADD CONSTRAINT report_pkey PRIMARY KEY (report_id);


--
-- Name: revenue revenue_pkey; Type: CONSTRAINT; Schema: public; Owner: valknar
--

ALTER TABLE ONLY public.revenue
    ADD CONSTRAINT revenue_pkey PRIMARY KEY (revenue_id);


--
-- Name: segment segment_pkey; Type: CONSTRAINT; Schema: public; Owner: valknar
--

ALTER TABLE ONLY public.segment
    ADD CONSTRAINT segment_pkey PRIMARY KEY (segment_id);


--
-- Name: session_data session_data_pkey; Type: CONSTRAINT; Schema: public; Owner: valknar
--

ALTER TABLE ONLY public.session_data
    ADD CONSTRAINT session_data_pkey PRIMARY KEY (session_data_id);


--
-- Name: session session_pkey; Type: CONSTRAINT; Schema: public; Owner: valknar
--

ALTER TABLE ONLY public.session
    ADD CONSTRAINT session_pkey PRIMARY KEY (session_id);


--
-- Name: team team_pkey; Type: CONSTRAINT; Schema: public; Owner: valknar
--

ALTER TABLE ONLY public.team
    ADD CONSTRAINT team_pkey PRIMARY KEY (team_id);


--
-- Name: team_user team_user_pkey; Type: CONSTRAINT; Schema: public; Owner: valknar
--

ALTER TABLE ONLY public.team_user
    ADD CONSTRAINT team_user_pkey PRIMARY KEY (team_user_id);


--
-- Name: user user_pkey; Type: CONSTRAINT; Schema: public; Owner: valknar
--

ALTER TABLE ONLY public."user"
    ADD CONSTRAINT user_pkey PRIMARY KEY (user_id);


--
-- Name: website_event website_event_pkey; Type: CONSTRAINT; Schema: public; Owner: valknar
--

ALTER TABLE ONLY public.website_event
    ADD CONSTRAINT website_event_pkey PRIMARY KEY (event_id);


--
-- Name: website website_pkey; Type: CONSTRAINT; Schema: public; Owner: valknar
--

ALTER TABLE ONLY public.website
    ADD CONSTRAINT website_pkey PRIMARY KEY (website_id);


--
-- Name: event_data_created_at_idx; Type: INDEX; Schema: public; Owner: valknar
--

CREATE INDEX event_data_created_at_idx ON public.event_data USING btree (created_at);


--
-- Name: event_data_website_event_id_idx; Type: INDEX; Schema: public; Owner: valknar
--

CREATE INDEX event_data_website_event_id_idx ON public.event_data USING btree (website_event_id);


--
-- Name: event_data_website_id_created_at_data_key_idx; Type: INDEX; Schema: public; Owner: valknar
--

CREATE INDEX event_data_website_id_created_at_data_key_idx ON public.event_data USING btree (website_id, created_at, data_key);


--
-- Name: event_data_website_id_created_at_idx; Type: INDEX; Schema: public; Owner: valknar
--

CREATE INDEX event_data_website_id_created_at_idx ON public.event_data USING btree (website_id, created_at);


--
-- Name: event_data_website_id_idx; Type: INDEX; Schema: public; Owner: valknar
--

CREATE INDEX event_data_website_id_idx ON public.event_data USING btree (website_id);


--
-- Name: report_name_idx; Type: INDEX; Schema: public; Owner: valknar
--

CREATE INDEX report_name_idx ON public.report USING btree (name);


--
-- Name: report_report_id_key; Type: INDEX; Schema: public; Owner: valknar
--

CREATE UNIQUE INDEX report_report_id_key ON public.report USING btree (report_id);


--
-- Name: report_type_idx; Type: INDEX; Schema: public; Owner: valknar
--

CREATE INDEX report_type_idx ON public.report USING btree (type);


--
-- Name: report_user_id_idx; Type: INDEX; Schema: public; Owner: valknar
--

CREATE INDEX report_user_id_idx ON public.report USING btree (user_id);


--
-- Name: report_website_id_idx; Type: INDEX; Schema: public; Owner: valknar
--

CREATE INDEX report_website_id_idx ON public.report USING btree (website_id);


--
-- Name: revenue_revenue_id_key; Type: INDEX; Schema: public; Owner: valknar
--

CREATE UNIQUE INDEX revenue_revenue_id_key ON public.revenue USING btree (revenue_id);


--
-- Name: revenue_session_id_idx; Type: INDEX; Schema: public; Owner: valknar
--

CREATE INDEX revenue_session_id_idx ON public.revenue USING btree (session_id);


--
-- Name: revenue_website_id_created_at_idx; Type: INDEX; Schema: public; Owner: valknar
--

CREATE INDEX revenue_website_id_created_at_idx ON public.revenue USING btree (website_id, created_at);


--
-- Name: revenue_website_id_idx; Type: INDEX; Schema: public; Owner: valknar
--

CREATE INDEX revenue_website_id_idx ON public.revenue USING btree (website_id);


--
-- Name: revenue_website_id_session_id_created_at_idx; Type: INDEX; Schema: public; Owner: valknar
--

CREATE INDEX revenue_website_id_session_id_created_at_idx ON public.revenue USING btree (website_id, session_id, created_at);


--
-- Name: segment_segment_id_key; Type: INDEX; Schema: public; Owner: valknar
--

CREATE UNIQUE INDEX segment_segment_id_key ON public.segment USING btree (segment_id);


--
-- Name: segment_website_id_idx; Type: INDEX; Schema: public; Owner: valknar
--

CREATE INDEX segment_website_id_idx ON public.segment USING btree (website_id);


--
-- Name: session_created_at_idx; Type: INDEX; Schema: public; Owner: valknar
--

CREATE INDEX session_created_at_idx ON public.session USING btree (created_at);


--
-- Name: session_data_created_at_idx; Type: INDEX; Schema: public; Owner: valknar
--

CREATE INDEX session_data_created_at_idx ON public.session_data USING btree (created_at);


--
-- Name: session_data_session_id_created_at_idx; Type: INDEX; Schema: public; Owner: valknar
--

CREATE INDEX session_data_session_id_created_at_idx ON public.session_data USING btree (session_id, created_at);


--
-- Name: session_data_session_id_idx; Type: INDEX; Schema: public; Owner: valknar
--

CREATE INDEX session_data_session_id_idx ON public.session_data USING btree (session_id);


--
-- Name: session_data_website_id_created_at_data_key_idx; Type: INDEX; Schema: public; Owner: valknar
--

CREATE INDEX session_data_website_id_created_at_data_key_idx ON public.session_data USING btree (website_id, created_at, data_key);


--
-- Name: session_data_website_id_idx; Type: INDEX; Schema: public; Owner: valknar
--

CREATE INDEX session_data_website_id_idx ON public.session_data USING btree (website_id);


--
-- Name: session_session_id_key; Type: INDEX; Schema: public; Owner: valknar
--

CREATE UNIQUE INDEX session_session_id_key ON public.session USING btree (session_id);


--
-- Name: session_website_id_created_at_browser_idx; Type: INDEX; Schema: public; Owner: valknar
--

CREATE INDEX session_website_id_created_at_browser_idx ON public.session USING btree (website_id, created_at, browser);


--
-- Name: session_website_id_created_at_city_idx; Type: INDEX; Schema: public; Owner: valknar
--

CREATE INDEX session_website_id_created_at_city_idx ON public.session USING btree (website_id, created_at, city);


--
-- Name: session_website_id_created_at_country_idx; Type: INDEX; Schema: public; Owner: valknar
--

CREATE INDEX session_website_id_created_at_country_idx ON public.session USING btree (website_id, created_at, country);


--
-- Name: session_website_id_created_at_device_idx; Type: INDEX; Schema: public; Owner: valknar
--

CREATE INDEX session_website_id_created_at_device_idx ON public.session USING btree (website_id, created_at, device);


--
-- Name: session_website_id_created_at_idx; Type: INDEX; Schema: public; Owner: valknar
--

CREATE INDEX session_website_id_created_at_idx ON public.session USING btree (website_id, created_at);


--
-- Name: session_website_id_created_at_language_idx; Type: INDEX; Schema: public; Owner: valknar
--

CREATE INDEX session_website_id_created_at_language_idx ON public.session USING btree (website_id, created_at, language);


--
-- Name: session_website_id_created_at_os_idx; Type: INDEX; Schema: public; Owner: valknar
--

CREATE INDEX session_website_id_created_at_os_idx ON public.session USING btree (website_id, created_at, os);


--
-- Name: session_website_id_created_at_region_idx; Type: INDEX; Schema: public; Owner: valknar
--

CREATE INDEX session_website_id_created_at_region_idx ON public.session USING btree (website_id, created_at, region);


--
-- Name: session_website_id_created_at_screen_idx; Type: INDEX; Schema: public; Owner: valknar
--

CREATE INDEX session_website_id_created_at_screen_idx ON public.session USING btree (website_id, created_at, screen);


--
-- Name: session_website_id_idx; Type: INDEX; Schema: public; Owner: valknar
--

CREATE INDEX session_website_id_idx ON public.session USING btree (website_id);


--
-- Name: team_access_code_idx; Type: INDEX; Schema: public; Owner: valknar
--

CREATE INDEX team_access_code_idx ON public.team USING btree (access_code);


--
-- Name: team_access_code_key; Type: INDEX; Schema: public; Owner: valknar
--

CREATE UNIQUE INDEX team_access_code_key ON public.team USING btree (access_code);


--
-- Name: team_team_id_key; Type: INDEX; Schema: public; Owner: valknar
--

CREATE UNIQUE INDEX team_team_id_key ON public.team USING btree (team_id);


--
-- Name: team_user_team_id_idx; Type: INDEX; Schema: public; Owner: valknar
--

CREATE INDEX team_user_team_id_idx ON public.team_user USING btree (team_id);


--
-- Name: team_user_team_user_id_key; Type: INDEX; Schema: public; Owner: valknar
--

CREATE UNIQUE INDEX team_user_team_user_id_key ON public.team_user USING btree (team_user_id);


--
-- Name: team_user_user_id_idx; Type: INDEX; Schema: public; Owner: valknar
--

CREATE INDEX team_user_user_id_idx ON public.team_user USING btree (user_id);


--
-- Name: user_user_id_key; Type: INDEX; Schema: public; Owner: valknar
--

CREATE UNIQUE INDEX user_user_id_key ON public."user" USING btree (user_id);


--
-- Name: user_username_key; Type: INDEX; Schema: public; Owner: valknar
--

CREATE UNIQUE INDEX user_username_key ON public."user" USING btree (username);


--
-- Name: website_created_at_idx; Type: INDEX; Schema: public; Owner: valknar
--

CREATE INDEX website_created_at_idx ON public.website USING btree (created_at);


--
-- Name: website_created_by_idx; Type: INDEX; Schema: public; Owner: valknar
--

CREATE INDEX website_created_by_idx ON public.website USING btree (created_by);


--
-- Name: website_event_created_at_idx; Type: INDEX; Schema: public; Owner: valknar
--

CREATE INDEX website_event_created_at_idx ON public.website_event USING btree (created_at);


--
-- Name: website_event_session_id_idx; Type: INDEX; Schema: public; Owner: valknar
--

CREATE INDEX website_event_session_id_idx ON public.website_event USING btree (session_id);


--
-- Name: website_event_visit_id_idx; Type: INDEX; Schema: public; Owner: valknar
--

CREATE INDEX website_event_visit_id_idx ON public.website_event USING btree (visit_id);


--
-- Name: website_event_website_id_created_at_event_name_idx; Type: INDEX; Schema: public; Owner: valknar
--

CREATE INDEX website_event_website_id_created_at_event_name_idx ON public.website_event USING btree (website_id, created_at, event_name);


--
-- Name: website_event_website_id_created_at_hostname_idx; Type: INDEX; Schema: public; Owner: valknar
--

CREATE INDEX website_event_website_id_created_at_hostname_idx ON public.website_event USING btree (website_id, created_at, hostname);


--
-- Name: website_event_website_id_created_at_idx; Type: INDEX; Schema: public; Owner: valknar
--

CREATE INDEX website_event_website_id_created_at_idx ON public.website_event USING btree (website_id, created_at);


--
-- Name: website_event_website_id_created_at_page_title_idx; Type: INDEX; Schema: public; Owner: valknar
--

CREATE INDEX website_event_website_id_created_at_page_title_idx ON public.website_event USING btree (website_id, created_at, page_title);


--
-- Name: website_event_website_id_created_at_referrer_domain_idx; Type: INDEX; Schema: public; Owner: valknar
--

CREATE INDEX website_event_website_id_created_at_referrer_domain_idx ON public.website_event USING btree (website_id, created_at, referrer_domain);


--
-- Name: website_event_website_id_created_at_tag_idx; Type: INDEX; Schema: public; Owner: valknar
--

CREATE INDEX website_event_website_id_created_at_tag_idx ON public.website_event USING btree (website_id, created_at, tag);


--
-- Name: website_event_website_id_created_at_url_path_idx; Type: INDEX; Schema: public; Owner: valknar
--

CREATE INDEX website_event_website_id_created_at_url_path_idx ON public.website_event USING btree (website_id, created_at, url_path);


--
-- Name: website_event_website_id_created_at_url_query_idx; Type: INDEX; Schema: public; Owner: valknar
--

CREATE INDEX website_event_website_id_created_at_url_query_idx ON public.website_event USING btree (website_id, created_at, url_query);


--
-- Name: website_event_website_id_idx; Type: INDEX; Schema: public; Owner: valknar
--

CREATE INDEX website_event_website_id_idx ON public.website_event USING btree (website_id);


--
-- Name: website_event_website_id_session_id_created_at_idx; Type: INDEX; Schema: public; Owner: valknar
--

CREATE INDEX website_event_website_id_session_id_created_at_idx ON public.website_event USING btree (website_id, session_id, created_at);


--
-- Name: website_event_website_id_visit_id_created_at_idx; Type: INDEX; Schema: public; Owner: valknar
--

CREATE INDEX website_event_website_id_visit_id_created_at_idx ON public.website_event USING btree (website_id, visit_id, created_at);


--
-- Name: website_share_id_idx; Type: INDEX; Schema: public; Owner: valknar
--

CREATE INDEX website_share_id_idx ON public.website USING btree (share_id);


--
-- Name: website_share_id_key; Type: INDEX; Schema: public; Owner: valknar
--

CREATE UNIQUE INDEX website_share_id_key ON public.website USING btree (share_id);


--
-- Name: website_team_id_idx; Type: INDEX; Schema: public; Owner: valknar
--

CREATE INDEX website_team_id_idx ON public.website USING btree (team_id);


--
-- Name: website_user_id_idx; Type: INDEX; Schema: public; Owner: valknar
--

CREATE INDEX website_user_id_idx ON public.website USING btree (user_id);


--
-- Name: website_website_id_key; Type: INDEX; Schema: public; Owner: valknar
--

CREATE UNIQUE INDEX website_website_id_key ON public.website USING btree (website_id);


--
-- PostgreSQL database dump complete
--

\unrestrict qFLeMhL9EcmHQkcdUv11HFLl8cM2o86GnCCrm0KNKGmeMCVBWrPbDQMdHMBz6yI

