--
-- PostgreSQL database dump
--

\restrict yabgCC53Rs35t0KZjrxdydnQ7MjYYBRqlOJIqBte2nv3R8pW2kYE9mFyhRxwphS

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
6d7ac639-d2da-4312-afe1-20143d18f08b	f2398e3b-d5f3-4dc3-8580-aba6e9ae3ef2	7ed84c2c-0250-49b6-9320-bae5cbb51f17	title	SexyArt - In The Opera	\N	\N	1	2025-10-08 06:54:13.947+00
a928c2e5-f3ac-45f5-b406-7c7f3a26835b	f2398e3b-d5f3-4dc3-8580-aba6e9ae3ef2	7ed84c2c-0250-49b6-9320-bae5cbb51f17	id	009f5bad-9a8a-401e-9cb1-5792fa41337f	\N	\N	1	2025-10-08 06:54:13.947+00
3ebfeaef-97b6-4012-bb5b-b54387d59ce2	f2398e3b-d5f3-4dc3-8580-aba6e9ae3ef2	51dbeb1f-182a-4f3e-9a1a-a619e3c5cd21	title	SexyArt - In The Opera	\N	\N	1	2025-10-08 20:35:33.739+00
eb191ef1-b688-4b5c-8dec-6dd1e3fc6100	f2398e3b-d5f3-4dc3-8580-aba6e9ae3ef2	51dbeb1f-182a-4f3e-9a1a-a619e3c5cd21	id	009f5bad-9a8a-401e-9cb1-5792fa41337f	\N	\N	1	2025-10-08 20:35:33.739+00
9492d7d6-c803-413c-9757-668a01ebca29	f2398e3b-d5f3-4dc3-8580-aba6e9ae3ef2	40442766-5350-47d8-b8c2-4df08d3d19c0	title	SexyArt - In The Opera	\N	\N	1	2025-10-09 13:04:16.495+00
56cb0aaf-d0c1-41ae-b0b3-ba09de9eb0ad	f2398e3b-d5f3-4dc3-8580-aba6e9ae3ef2	40442766-5350-47d8-b8c2-4df08d3d19c0	id	009f5bad-9a8a-401e-9cb1-5792fa41337f	\N	\N	1	2025-10-09 13:04:16.495+00
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
289724a1-74d9-5b4e-ad15-cb975bce8af0	26158eb8-e0ae-4985-aa91-2f4a652f8ccb	ios	iOS	mobile	390x844	de-DE	DE	DE-BW	Ravensburg	2025-10-10 10:10:23.124+00	\N
6f5a5afd-56bd-551a-94fe-dce02a4aef1d	f2398e3b-d5f3-4dc3-8580-aba6e9ae3ef2	ios	iOS	mobile	390x844	de-DE	DE	DE-BW	Ravensburg	2025-10-10 10:12:08.562+00	\N
9b165958-6406-5f6f-ae0f-2449eb13a060	f2398e3b-d5f3-4dc3-8580-aba6e9ae3ef2	chrome	Android OS	mobile	384x832	de-DE	DE	DE-BW	Stuttgart	2025-10-10 16:10:45.793+00	\N
9d2fa501-82d8-5640-9723-7eb0c35b1da7	26158eb8-e0ae-4985-aa91-2f4a652f8ccb	chrome	Android OS	mobile	384x832	de-DE	DE	DE-BW	Stuttgart	2025-10-10 16:10:53.872+00	\N
8a42e904-911c-5347-90ec-e0dadbc6e26b	26158eb8-e0ae-4985-aa91-2f4a652f8ccb	safari	Mac OS	desktop	2560x1440	de-DE	DE	DE-BW	Freiburg im Breisgau	2025-10-10 19:02:12.077+00	\N
20c48e50-1baf-5ae0-8c7b-1d4bf036aa41	f2398e3b-d5f3-4dc3-8580-aba6e9ae3ef2	safari	Mac OS	desktop	2560x1440	de-DE	DE	DE-BW	Freiburg im Breisgau	2025-10-10 19:02:17.313+00	\N
98a9cf0a-d48f-5203-9084-d5fd5b43b56d	26158eb8-e0ae-4985-aa91-2f4a652f8ccb	chrome	Linux	desktop	2327x1309	de-DE	\N	\N	\N	2025-10-08 03:56:53.171+00	\N
4e15819d-166c-5b35-bee3-bef499917fd7	f2398e3b-d5f3-4dc3-8580-aba6e9ae3ef2	chrome	Linux	desktop	2327x1309	de-DE	\N	\N	\N	2025-10-08 03:56:58.313+00	\N
69b3e2a4-ee82-5465-b163-a8904cdc4691	26158eb8-e0ae-4985-aa91-2f4a652f8ccb	safari	Mac OS	laptop	1388x768	en-US	DE	\N	\N	2025-10-08 07:56:56.367+00	\N
563d1af3-a1cd-5d23-b65d-f5c0a9a93c98	26158eb8-e0ae-4985-aa91-2f4a652f8ccb	ios	iOS	mobile	428x926	de-DE	DE	DE-BW	Freiburg im Breisgau	2025-10-08 20:27:55.909+00	\N
720b49a6-c417-5cbd-a7b1-e783d571896a	f2398e3b-d5f3-4dc3-8580-aba6e9ae3ef2	ios	iOS	mobile	428x926	de-DE	DE	DE-BW	Freiburg im Breisgau	2025-10-08 20:27:57.778+00	\N
642989a0-0629-5ca9-a4fa-317dee44d700	f2398e3b-d5f3-4dc3-8580-aba6e9ae3ef2	chrome	Android OS	mobile	384x832	de-DE	DE	DE-BW	Stuttgart	2025-10-08 20:35:27.967+00	\N
cb0e96db-7819-5400-8208-383f768ed9b3	26158eb8-e0ae-4985-aa91-2f4a652f8ccb	safari	Mac OS	laptop	1388x768	en-US	DE	\N	\N	2025-10-09 00:18:58.229+00	\N
c7e98b5b-8032-5ad6-bc62-fbe6b1d88315	26158eb8-e0ae-4985-aa91-2f4a652f8ccb	ios	iOS	mobile	375x667	de-DE	DE	DE-BW	Freiburg im Breisgau	2025-10-09 18:15:38.532+00	\N
50b9130a-0f33-5a22-a2c4-d29e1456fe14	f2398e3b-d5f3-4dc3-8580-aba6e9ae3ef2	ios	iOS	mobile	375x667	de-DE	DE	DE-BW	Freiburg im Breisgau	2025-10-09 18:15:56.918+00	\N
ea53dba7-722c-5318-a56e-41db7006092b	f2398e3b-d5f3-4dc3-8580-aba6e9ae3ef2	chrome	Android OS	mobile	384x832	de-DE	DE	DE-BW	Stuttgart	2025-10-09 22:09:27.309+00	\N
c3d9a41b-04de-53d1-84bb-df79f5bad89f	26158eb8-e0ae-4985-aa91-2f4a652f8ccb	chrome	Android OS	mobile	384x832	de-DE	DE	DE-HE	Bad Soden am Taunus	2025-10-10 04:58:28.365+00	\N
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
7046b369-a030-4fef-ac7e-b930f1c356c6	f2398e3b-d5f3-4dc3-8580-aba6e9ae3ef2	4e15819d-166c-5b35-bee3-bef499917fd7	2025-10-08 06:53:59.924+00	/videos/sexyart-in-the-opera/		\N	\N	\N	SexyArt | SexyArt - In The Opera	1	\N	e454410a-337b-518b-b587-7c831b6073ec	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	sexy.pivoine.art
7ed84c2c-0250-49b6-9320-bae5cbb51f17	f2398e3b-d5f3-4dc3-8580-aba6e9ae3ef2	4e15819d-166c-5b35-bee3-bef499917fd7	2025-10-08 06:54:13.947+00	/videos/sexyart-in-the-opera/		\N	\N	\N	SexyArt | SexyArt - In The Opera	2	play-video	e454410a-337b-518b-b587-7c831b6073ec	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	sexy.pivoine.art
97ee830d-9329-4c65-8bd3-df7d557b276b	26158eb8-e0ae-4985-aa91-2f4a652f8ccb	69b3e2a4-ee82-5465-b163-a8904cdc4691	2025-10-08 07:56:56.366+00	/		\N	\N	\N	Pivoine.Art | Valknar’s	1	\N	8aa21887-cc6e-59c7-9295-63a7a9cf1fcf	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	pivoine.art
48fa0e5e-3dcf-4fc7-bbf0-d48e2664181e	26158eb8-e0ae-4985-aa91-2f4a652f8ccb	563d1af3-a1cd-5d23-b65d-f5c0a9a93c98	2025-10-08 20:27:55.908+00	/		\N	\N	\N	Pivoine.Art | Valknar’s	1	\N	f8678287-3506-5e24-9ca4-07992d12f31d	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	pivoine.art
f0580cf2-f5ab-4562-86b5-d08c9b044135	f2398e3b-d5f3-4dc3-8580-aba6e9ae3ef2	720b49a6-c417-5cbd-a7b1-e783d571896a	2025-10-08 20:27:57.777+00	/		/		pivoine.art	SexyArt | Where Love Meets Artistry	1	\N	6c8745b9-6a32-5ee4-b41c-c2d3110b2df5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	sexy.pivoine.art
bdf99012-79ad-4196-b4c0-10525208dc3f	f2398e3b-d5f3-4dc3-8580-aba6e9ae3ef2	720b49a6-c417-5cbd-a7b1-e783d571896a	2025-10-08 20:28:16.144+00	/models/valknar/		/		sexy.pivoine.art	SexyArt | Valknar	1	\N	6c8745b9-6a32-5ee4-b41c-c2d3110b2df5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	sexy.pivoine.art
29f1d7f0-9ee4-40f9-b5c3-d8d734ff92a5	f2398e3b-d5f3-4dc3-8580-aba6e9ae3ef2	720b49a6-c417-5cbd-a7b1-e783d571896a	2025-10-08 20:28:19.076+00	/videos/sexyart-sexybelle/		/models/valknar/		sexy.pivoine.art	SexyArt | SexyArt - SexyBelle	1	\N	6c8745b9-6a32-5ee4-b41c-c2d3110b2df5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	sexy.pivoine.art
8e4cea1f-8cdd-4ac2-bac7-438e56e1ca9a	f2398e3b-d5f3-4dc3-8580-aba6e9ae3ef2	642989a0-0629-5ca9-a4fa-317dee44d700	2025-10-08 20:35:27.966+00	/		\N	\N	\N	SexyArt | Where Love Meets Artistry	1	\N	50345b82-d0b7-5ba9-a865-913f587a8cac	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	sexy.pivoine.art
1abb1831-6d9d-4494-9576-619e5e3e6bab	f2398e3b-d5f3-4dc3-8580-aba6e9ae3ef2	642989a0-0629-5ca9-a4fa-317dee44d700	2025-10-08 20:35:31.901+00	/videos/sexyart-in-the-opera/		/		sexy.pivoine.art	SexyArt | SexyArt - In The Opera	1	\N	50345b82-d0b7-5ba9-a865-913f587a8cac	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	sexy.pivoine.art
51dbeb1f-182a-4f3e-9a1a-a619e3c5cd21	f2398e3b-d5f3-4dc3-8580-aba6e9ae3ef2	642989a0-0629-5ca9-a4fa-317dee44d700	2025-10-08 20:35:33.739+00	/videos/sexyart-in-the-opera/		/		sexy.pivoine.art	SexyArt | SexyArt - In The Opera	2	play-video	50345b82-d0b7-5ba9-a865-913f587a8cac	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	sexy.pivoine.art
3f09cbb8-adc8-4c87-95d6-962d31379b23	f2398e3b-d5f3-4dc3-8580-aba6e9ae3ef2	642989a0-0629-5ca9-a4fa-317dee44d700	2025-10-08 21:21:22.892+00	/		\N	\N	\N	SexyArt | Where Love Meets Artistry	1	\N	2e759c33-c6a9-520e-b850-b81ca7f25c72	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	sexy.pivoine.art
0ac262c3-1818-4dcc-9022-77d87db6a232	26158eb8-e0ae-4985-aa91-2f4a652f8ccb	cb0e96db-7819-5400-8208-383f768ed9b3	2025-10-09 00:18:58.229+00	/		\N	\N	\N	Pivoine.Art | Valknar’s	1	\N	327b0a09-4b0c-532f-a260-e31d54afa2d2	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	pivoine.art
556cd1ce-ded9-49a7-9354-d7034d5a9fd3	f2398e3b-d5f3-4dc3-8580-aba6e9ae3ef2	4e15819d-166c-5b35-bee3-bef499917fd7	2025-10-09 13:04:06.924+00	/		\N	\N	\N	SexyArt | Where Love Meets Artistry	1	\N	b98e924d-972a-5a16-bebb-d7e08c3d767c	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	sexy.pivoine.art
a0a5831c-bba9-4a11-811b-bb56f1ebf571	f2398e3b-d5f3-4dc3-8580-aba6e9ae3ef2	4e15819d-166c-5b35-bee3-bef499917fd7	2025-10-09 13:04:14.646+00	/videos/sexyart-in-the-opera/		/		sexy.pivoine.art	SexyArt | SexyArt - In The Opera	1	\N	b98e924d-972a-5a16-bebb-d7e08c3d767c	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	sexy.pivoine.art
40442766-5350-47d8-b8c2-4df08d3d19c0	f2398e3b-d5f3-4dc3-8580-aba6e9ae3ef2	4e15819d-166c-5b35-bee3-bef499917fd7	2025-10-09 13:04:16.495+00	/videos/sexyart-in-the-opera/		/		sexy.pivoine.art	SexyArt | SexyArt - In The Opera	2	play-video	b98e924d-972a-5a16-bebb-d7e08c3d767c	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	sexy.pivoine.art
2fd5b28a-fc23-429f-8306-bfb1e07cd362	26158eb8-e0ae-4985-aa91-2f4a652f8ccb	98a9cf0a-d48f-5203-9084-d5fd5b43b56d	2025-10-09 16:05:02.65+00	/		\N	\N	\N	Pivoine.Art | Valknar’s	1	\N	fbaa9308-d4b1-579e-bc2e-ec763ff4a63a	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	pivoine.art
d56671b1-6391-4bed-801d-7783a86fb687	26158eb8-e0ae-4985-aa91-2f4a652f8ccb	98a9cf0a-d48f-5203-9084-d5fd5b43b56d	2025-10-09 16:05:15.982+00	/		\N	\N	\N	Pivoine.Art | Valknar’s	1	\N	fbaa9308-d4b1-579e-bc2e-ec763ff4a63a	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	pivoine.art
06840724-deaf-4b86-8efa-71655238a6db	26158eb8-e0ae-4985-aa91-2f4a652f8ccb	98a9cf0a-d48f-5203-9084-d5fd5b43b56d	2025-10-09 16:07:42.214+00	/		\N	\N	\N	Pivoine.Art | Valknar’s	1	\N	fbaa9308-d4b1-579e-bc2e-ec763ff4a63a	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	pivoine.art
a907f39b-a42a-4596-aa2a-62af7b4de2c0	26158eb8-e0ae-4985-aa91-2f4a652f8ccb	98a9cf0a-d48f-5203-9084-d5fd5b43b56d	2025-10-09 16:10:44.451+00	/		\N	\N	\N	Pivoine.Art | Valknar’s	1	\N	fbaa9308-d4b1-579e-bc2e-ec763ff4a63a	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	pivoine.art
b763479d-fa28-41e1-bdf8-d49dcb697066	26158eb8-e0ae-4985-aa91-2f4a652f8ccb	98a9cf0a-d48f-5203-9084-d5fd5b43b56d	2025-10-09 16:10:48.477+00	/		\N	\N	\N	Pivoine.Art | Valknar’s	1	\N	fbaa9308-d4b1-579e-bc2e-ec763ff4a63a	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	pivoine.art
fdc875a8-cc63-4646-9c85-d23fa39e5b34	26158eb8-e0ae-4985-aa91-2f4a652f8ccb	98a9cf0a-d48f-5203-9084-d5fd5b43b56d	2025-10-09 16:39:03.206+00	/		\N	\N	\N	Pivoine.Art | Valknar’s	1	\N	fbaa9308-d4b1-579e-bc2e-ec763ff4a63a	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	pivoine.art
031a4ac9-e588-4616-92a5-81aa441d321a	26158eb8-e0ae-4985-aa91-2f4a652f8ccb	98a9cf0a-d48f-5203-9084-d5fd5b43b56d	2025-10-09 16:39:04.744+00	/		\N	\N	\N	Pivoine.Art | Valknar’s	1	\N	fbaa9308-d4b1-579e-bc2e-ec763ff4a63a	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	pivoine.art
afb9a8c3-c6f2-4f6d-a21a-724bad7394f9	26158eb8-e0ae-4985-aa91-2f4a652f8ccb	98a9cf0a-d48f-5203-9084-d5fd5b43b56d	2025-10-09 17:31:16.591+00	/		\N	\N	\N	Pivoine.Art | Valknar’s	1	\N	268a28a4-575e-5f23-8603-5c990768a83f	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	pivoine.art
51573197-03c5-473e-9f18-cf76a1be506d	26158eb8-e0ae-4985-aa91-2f4a652f8ccb	c7e98b5b-8032-5ad6-bc62-fbe6b1d88315	2025-10-09 18:15:38.531+00	/		\N	\N	\N	Pivoine.Art | Valknar’s	1	\N	058ee2a2-0885-5bc7-90ba-1a1f3eedaac4	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	pivoine.art
2b890a24-f220-4a21-af96-d6589d91b32c	f2398e3b-d5f3-4dc3-8580-aba6e9ae3ef2	50b9130a-0f33-5a22-a2c4-d29e1456fe14	2025-10-09 18:15:56.917+00	/		/		pivoine.art	SexyArt | Where Love Meets Artistry	1	\N	3ad0c2bd-5226-58ca-a92a-114157f2a58b	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	sexy.pivoine.art
e9440834-7aae-4a2f-9563-eed621f2fb8b	f2398e3b-d5f3-4dc3-8580-aba6e9ae3ef2	4e15819d-166c-5b35-bee3-bef499917fd7	2025-10-09 20:07:21.68+00	/		\N	\N	\N	SexyArt | Where Love Meets Artistry	1	\N	209764f9-b381-5fa9-a56b-a68b58fdd923	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	sexy.pivoine.art
945db833-1721-42f9-91bf-c488622f61d2	f2398e3b-d5f3-4dc3-8580-aba6e9ae3ef2	ea53dba7-722c-5318-a56e-41db7006092b	2025-10-09 22:09:27.308+00	/		\N	\N	\N	SexyArt | Where Love Meets Artistry	1	\N	17271d8c-b64b-58a9-a629-8d0c737b5dbe	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	sexy.pivoine.art
141ceda3-b7bc-48a1-8525-21857def34bb	f2398e3b-d5f3-4dc3-8580-aba6e9ae3ef2	ea53dba7-722c-5318-a56e-41db7006092b	2025-10-09 22:34:15.178+00	/		\N	\N	\N	SexyArt | Where Love Meets Artistry	1	\N	17271d8c-b64b-58a9-a629-8d0c737b5dbe	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	sexy.pivoine.art
ad653e7f-f88f-44a6-a19b-47992cca027c	26158eb8-e0ae-4985-aa91-2f4a652f8ccb	c3d9a41b-04de-53d1-84bb-df79f5bad89f	2025-10-10 04:58:28.364+00	/		\N	\N	\N	Pivoine.Art | Valknar’s	1	\N	992449e5-bcf0-5a1f-bfd8-3977df2a58ce	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	pivoine.art
12b0b31c-1a06-461d-8318-98ab881aa840	26158eb8-e0ae-4985-aa91-2f4a652f8ccb	c3d9a41b-04de-53d1-84bb-df79f5bad89f	2025-10-10 04:58:29.298+00	/		\N	\N	\N	Pivoine.Art | Valknar’s	1	\N	992449e5-bcf0-5a1f-bfd8-3977df2a58ce	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	pivoine.art
966de540-e49a-4a0a-b0a8-eb48f3fd2e2d	f2398e3b-d5f3-4dc3-8580-aba6e9ae3ef2	4e15819d-166c-5b35-bee3-bef499917fd7	2025-10-10 05:37:44.351+00	/		\N	\N	\N	SexyArt | Where Love Meets Artistry	1	\N	b239fa47-ab62-5141-b5a2-9546e33a133f	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	sexy.pivoine.art
80260ee2-6c1b-4c5a-92c6-688ea05070da	f2398e3b-d5f3-4dc3-8580-aba6e9ae3ef2	4e15819d-166c-5b35-bee3-bef499917fd7	2025-10-10 05:51:15.453+00	/		\N	\N	\N	SexyArt | Where Love Meets Artistry	1	\N	b239fa47-ab62-5141-b5a2-9546e33a133f	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	sexy.pivoine.art
fd83eafc-9db1-4600-9736-f438a54dc6c7	f2398e3b-d5f3-4dc3-8580-aba6e9ae3ef2	4e15819d-166c-5b35-bee3-bef499917fd7	2025-10-10 06:24:06.659+00	/		\N	\N	\N	SexyArt | Where Love Meets Artistry	1	\N	53fbc5d8-7726-5df6-96fc-2c700e5bf296	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	sexy.pivoine.art
afc9c52e-f514-4b6d-bb4c-afc5db30b40a	f2398e3b-d5f3-4dc3-8580-aba6e9ae3ef2	4e15819d-166c-5b35-bee3-bef499917fd7	2025-10-10 06:40:40.873+00	/		\N	\N	\N	SexyArt | Where Love Meets Artistry	1	\N	53fbc5d8-7726-5df6-96fc-2c700e5bf296	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	sexy.pivoine.art
8250cdac-9fdd-4bb6-88e3-12a04616e65d	f2398e3b-d5f3-4dc3-8580-aba6e9ae3ef2	4e15819d-166c-5b35-bee3-bef499917fd7	2025-10-10 07:26:04.891+00	/		\N	\N	\N	SexyArt | Where Love Meets Artistry	1	\N	c76a099f-312a-56e9-864e-75b29e42f10e	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	sexy.pivoine.art
2fffa3bf-f601-4866-96ba-ddd55da6b02c	26158eb8-e0ae-4985-aa91-2f4a652f8ccb	98a9cf0a-d48f-5203-9084-d5fd5b43b56d	2025-10-10 07:35:58.53+00	/		\N	\N	\N	Pivoine.Art | Valknar’s	1	\N	c8d00cbc-086a-5d7e-a35b-d8a35c0b2700	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	pivoine.art
5f3fe41b-0eda-4c51-9576-602c3d6a3cef	f2398e3b-d5f3-4dc3-8580-aba6e9ae3ef2	4e15819d-166c-5b35-bee3-bef499917fd7	2025-10-10 07:48:07.876+00	/		\N	\N	\N	SexyArt | Where Love Meets Artistry	1	\N	c76a099f-312a-56e9-864e-75b29e42f10e	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	sexy.pivoine.art
3ed2c098-edb0-4899-be36-c9f91e222a23	f2398e3b-d5f3-4dc3-8580-aba6e9ae3ef2	4e15819d-166c-5b35-bee3-bef499917fd7	2025-10-10 08:56:43.56+00	/		\N	\N	\N	SexyArt | Where Love Meets Artistry	1	\N	510bc8b1-63a4-59b8-a8d7-d0f0a47da9c3	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	sexy.pivoine.art
85fe37f2-6e56-433e-ba05-8e79ddac1935	f2398e3b-d5f3-4dc3-8580-aba6e9ae3ef2	4e15819d-166c-5b35-bee3-bef499917fd7	2025-10-10 09:00:29.329+00	/		\N	\N	\N	SexyArt | Where Love Meets Artistry	1	\N	5ec6676e-ad20-5c23-b8a7-98e75710243d	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	sexy.pivoine.art
c0ea43c2-b57f-4272-bc05-2e8f36f74cf8	f2398e3b-d5f3-4dc3-8580-aba6e9ae3ef2	4e15819d-166c-5b35-bee3-bef499917fd7	2025-10-10 09:04:05.171+00	/		\N	\N	\N	SexyArt | Where Love Meets Artistry	1	\N	5ec6676e-ad20-5c23-b8a7-98e75710243d	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	sexy.pivoine.art
09801d7a-5628-4347-949f-3c489f002747	26158eb8-e0ae-4985-aa91-2f4a652f8ccb	289724a1-74d9-5b4e-ad15-cb975bce8af0	2025-10-10 10:10:23.123+00	/music/stuttgart		\N	\N	\N	Stuttgart | Valknar’s	1	\N	c42c0a27-5f77-59eb-8d76-18261e321d2c	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	pivoine.art
2c5f1192-37b7-42a4-88f8-1a1462e6ecc6	26158eb8-e0ae-4985-aa91-2f4a652f8ccb	289724a1-74d9-5b4e-ad15-cb975bce8af0	2025-10-10 10:12:07.408+00	/		\N	\N	\N	Pivoine.Art | Valknar’s	1	\N	c42c0a27-5f77-59eb-8d76-18261e321d2c	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	pivoine.art
412f0277-1fa0-4c3b-b1e7-5cdbafed01cb	f2398e3b-d5f3-4dc3-8580-aba6e9ae3ef2	6f5a5afd-56bd-551a-94fe-dce02a4aef1d	2025-10-10 10:12:08.561+00	/		/		pivoine.art	SexyArt | Where Love Meets Artistry	1	\N	76e3b34b-f23e-5f7f-a02b-6629f0e967c6	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	sexy.pivoine.art
8b302e07-4d3c-422a-94ec-4acb103ad197	f2398e3b-d5f3-4dc3-8580-aba6e9ae3ef2	6f5a5afd-56bd-551a-94fe-dce02a4aef1d	2025-10-10 10:12:24.332+00	/models/		/		sexy.pivoine.art	SexyArt | Our Models	1	\N	76e3b34b-f23e-5f7f-a02b-6629f0e967c6	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	sexy.pivoine.art
743c2b67-10bc-4d71-a7bd-d2933092c1f7	f2398e3b-d5f3-4dc3-8580-aba6e9ae3ef2	6f5a5afd-56bd-551a-94fe-dce02a4aef1d	2025-10-10 10:12:34.876+00	/videos/		/models/		sexy.pivoine.art	SexyArt | Your Videos	1	\N	76e3b34b-f23e-5f7f-a02b-6629f0e967c6	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	sexy.pivoine.art
fae49887-b3f7-454f-8e0d-bdfa48c21f69	f2398e3b-d5f3-4dc3-8580-aba6e9ae3ef2	6f5a5afd-56bd-551a-94fe-dce02a4aef1d	2025-10-10 10:12:40.422+00	/magazine/		/videos/		sexy.pivoine.art	SexyArt | SexyArt Magazine	1	\N	76e3b34b-f23e-5f7f-a02b-6629f0e967c6	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	sexy.pivoine.art
a0ab5917-5722-4337-acd3-7f8069f0eeae	f2398e3b-d5f3-4dc3-8580-aba6e9ae3ef2	6f5a5afd-56bd-551a-94fe-dce02a4aef1d	2025-10-10 10:12:46.914+00	/		/magazine/		sexy.pivoine.art	SexyArt | Where Love Meets Artistry	1	\N	76e3b34b-f23e-5f7f-a02b-6629f0e967c6	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	sexy.pivoine.art
0c5cfcc5-e5e5-4422-a24b-f4e9636a359f	f2398e3b-d5f3-4dc3-8580-aba6e9ae3ef2	6f5a5afd-56bd-551a-94fe-dce02a4aef1d	2025-10-10 10:13:19.304+00	/		/		pivoine.art	SexyArt | Where Love Meets Artistry	1	\N	76e3b34b-f23e-5f7f-a02b-6629f0e967c6	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	sexy.pivoine.art
292f58c8-73b8-41d4-85a4-91f9de215c1b	26158eb8-e0ae-4985-aa91-2f4a652f8ccb	98a9cf0a-d48f-5203-9084-d5fd5b43b56d	2025-10-10 14:50:29.178+00	/		\N	\N	\N	Pivoine.Art | Valknar’s	1	\N	5fdfa4e4-91dc-52b6-913a-9f6cfb34f751	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	pivoine.art
240510c6-3e5a-4b14-a028-4e0dbd08b7bf	f2398e3b-d5f3-4dc3-8580-aba6e9ae3ef2	9b165958-6406-5f6f-ae0f-2449eb13a060	2025-10-10 16:10:45.792+00	/		\N	\N	\N	SexyArt | Where Love Meets Artistry	1	\N	e2203e01-f19f-5ff7-9daf-99f725581a69	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	sexy.pivoine.art
ebc8a37f-17a8-4c85-8c22-be59287690e8	26158eb8-e0ae-4985-aa91-2f4a652f8ccb	9d2fa501-82d8-5640-9723-7eb0c35b1da7	2025-10-10 16:10:53.871+00	/		\N	\N	\N	Pivoine.Art | Valknar’s	1	\N	db3aaf3d-3844-560e-a057-7b5910dde944	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	pivoine.art
723b395b-b399-4995-bb57-b1f069ddcb9d	26158eb8-e0ae-4985-aa91-2f4a652f8ccb	8a42e904-911c-5347-90ec-e0dadbc6e26b	2025-10-10 19:02:12.076+00	/		\N	\N	\N	Pivoine.Art | Valknar’s	1	\N	2a26eccc-885d-5843-a3bf-a51ced5eae0f	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	pivoine.art
eaff29ea-8e3d-4503-b198-2fe8264f6f02	f2398e3b-d5f3-4dc3-8580-aba6e9ae3ef2	20c48e50-1baf-5ae0-8c7b-1d4bf036aa41	2025-10-10 19:02:17.312+00	/		/		pivoine.art	SexyArt | Where Love Meets Artistry	1	\N	3ac21c52-1e2c-57aa-b4db-ff89410c85b8	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	sexy.pivoine.art
bec3211b-0d69-4321-8945-c17cb116ca79	f2398e3b-d5f3-4dc3-8580-aba6e9ae3ef2	20c48e50-1baf-5ae0-8c7b-1d4bf036aa41	2025-10-10 19:02:31.221+00	/about/		/		sexy.pivoine.art	SexyArt | About SexyArt	1	\N	3ac21c52-1e2c-57aa-b4db-ff89410c85b8	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	sexy.pivoine.art
ee84a283-58e8-4f57-8aa9-1fc53ef8035d	f2398e3b-d5f3-4dc3-8580-aba6e9ae3ef2	20c48e50-1baf-5ae0-8c7b-1d4bf036aa41	2025-10-10 19:03:01.627+00	/imprint/		/about/		sexy.pivoine.art	SexyArt | Imprint	1	\N	3ac21c52-1e2c-57aa-b4db-ff89410c85b8	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	sexy.pivoine.art
c65a49ae-cf3b-42b9-b877-43e4c53a0c38	f2398e3b-d5f3-4dc3-8580-aba6e9ae3ef2	20c48e50-1baf-5ae0-8c7b-1d4bf036aa41	2025-10-10 19:03:08.24+00	/videos/		/imprint/		sexy.pivoine.art	SexyArt | Your Videos	1	\N	3ac21c52-1e2c-57aa-b4db-ff89410c85b8	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	sexy.pivoine.art
a90cbd58-d586-4d74-a93e-2d035293a3bc	26158eb8-e0ae-4985-aa91-2f4a652f8ccb	98a9cf0a-d48f-5203-9084-d5fd5b43b56d	2025-10-10 19:04:47.511+00	/		\N	\N	\N	Pivoine.Art | Valknar’s	1	\N	825adefc-780a-5bac-88d9-643726857637	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	pivoine.art
2b9c1280-298d-4d30-96cc-24d0512918e3	f2398e3b-d5f3-4dc3-8580-aba6e9ae3ef2	4e15819d-166c-5b35-bee3-bef499917fd7	2025-10-10 19:05:59.219+00	/		\N	\N	\N	SexyArt | Where Love Meets Artistry	1	\N	1f35916a-111f-566d-9780-fa494f49fa8b	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	sexy.pivoine.art
876a81dc-e7df-4251-a1a0-91ce7cc7e2a5	f2398e3b-d5f3-4dc3-8580-aba6e9ae3ef2	4e15819d-166c-5b35-bee3-bef499917fd7	2025-10-10 19:06:02.722+00	/		\N	\N	\N	SexyArt | Where Love Meets Artistry	1	\N	1f35916a-111f-566d-9780-fa494f49fa8b	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	sexy.pivoine.art
743e9398-aa05-4d89-83ae-dcc99fe733a3	f2398e3b-d5f3-4dc3-8580-aba6e9ae3ef2	4e15819d-166c-5b35-bee3-bef499917fd7	2025-10-10 19:21:18.547+00	/		\N	\N	\N	SexyArt | Where Love Meets Artistry	1	\N	1f35916a-111f-566d-9780-fa494f49fa8b	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	sexy.pivoine.art
7eaeeda9-ae33-4b68-b2d9-7a1037f54b15	26158eb8-e0ae-4985-aa91-2f4a652f8ccb	98a9cf0a-d48f-5203-9084-d5fd5b43b56d	2025-10-10 19:56:32.83+00	/		\N	\N	\N	Pivoine.Art | Valknar’s	1	\N	825adefc-780a-5bac-88d9-643726857637	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	pivoine.art
2d3dff44-3732-4ea6-9802-cfc12bb037f1	26158eb8-e0ae-4985-aa91-2f4a652f8ccb	98a9cf0a-d48f-5203-9084-d5fd5b43b56d	2025-10-10 22:48:40.889+00	/		\N	\N	\N	Pivoine.Art | Valknar’s	1	\N	a171b181-e277-5230-bb26-9828778bcd5e	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	pivoine.art
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

\unrestrict yabgCC53Rs35t0KZjrxdydnQ7MjYYBRqlOJIqBte2nv3R8pW2kYE9mFyhRxwphS

