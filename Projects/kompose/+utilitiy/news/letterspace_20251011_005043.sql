--
-- PostgreSQL database dump
--

\restrict Q19dhbbwN4oYNryFn4zrNlLTpPxtKQLjkEUfbdNFT6l9nWN7aAGnyXdzk57SvJH

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
-- Name: CampaignStatus; Type: TYPE; Schema: public; Owner: valknar
--

CREATE TYPE public."CampaignStatus" AS ENUM (
    'DRAFT',
    'SCHEDULED',
    'SENDING',
    'COMPLETED',
    'CANCELLED',
    'CREATING'
);


ALTER TYPE public."CampaignStatus" OWNER TO valknar;

--
-- Name: MessageStatus; Type: TYPE; Schema: public; Owner: valknar
--

CREATE TYPE public."MessageStatus" AS ENUM (
    'QUEUED',
    'PENDING',
    'SENT',
    'OPENED',
    'CLICKED',
    'FAILED',
    'RETRYING',
    'CANCELLED'
);


ALTER TYPE public."MessageStatus" OWNER TO valknar;

--
-- Name: SmtpEncryption; Type: TYPE; Schema: public; Owner: valknar
--

CREATE TYPE public."SmtpEncryption" AS ENUM (
    'STARTTLS',
    'SSL_TLS',
    'NONE'
);


ALTER TYPE public."SmtpEncryption" OWNER TO valknar;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: ApiKey; Type: TABLE; Schema: public; Owner: valknar
--

CREATE TABLE public."ApiKey" (
    id text NOT NULL,
    name text NOT NULL,
    key text NOT NULL,
    "lastUsed" timestamp(3) without time zone,
    "expiresAt" timestamp(3) without time zone,
    "organizationId" text NOT NULL,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "updatedAt" timestamp(3) without time zone NOT NULL
);


ALTER TABLE public."ApiKey" OWNER TO valknar;

--
-- Name: Campaign; Type: TABLE; Schema: public; Owner: valknar
--

CREATE TABLE public."Campaign" (
    id text NOT NULL,
    title text NOT NULL,
    description text,
    subject text,
    content text,
    "completedAt" timestamp(3) without time zone,
    status public."CampaignStatus" DEFAULT 'DRAFT'::public."CampaignStatus" NOT NULL,
    "scheduledAt" timestamp(3) without time zone,
    "htmlOnly" boolean DEFAULT false NOT NULL,
    "openTracking" boolean DEFAULT true NOT NULL,
    "organizationId" text NOT NULL,
    "templateId" text,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "updatedAt" timestamp(3) without time zone NOT NULL,
    "unsubscribedCount" integer DEFAULT 0 NOT NULL
);


ALTER TABLE public."Campaign" OWNER TO valknar;

--
-- Name: CampaignList; Type: TABLE; Schema: public; Owner: valknar
--

CREATE TABLE public."CampaignList" (
    "campaignId" text NOT NULL,
    "listId" text NOT NULL
);


ALTER TABLE public."CampaignList" OWNER TO valknar;

--
-- Name: Click; Type: TABLE; Schema: public; Owner: valknar
--

CREATE TABLE public."Click" (
    id text NOT NULL,
    "trackedLinkId" text,
    "subscriberId" text,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "updatedAt" timestamp(3) without time zone NOT NULL
);


ALTER TABLE public."Click" OWNER TO valknar;

--
-- Name: EmailDeliverySettings; Type: TABLE; Schema: public; Owner: valknar
--

CREATE TABLE public."EmailDeliverySettings" (
    id text NOT NULL,
    "rateLimit" integer DEFAULT 100 NOT NULL,
    "rateWindow" integer DEFAULT 3600 NOT NULL,
    "maxRetries" integer DEFAULT 3 NOT NULL,
    "retryDelay" integer DEFAULT 300 NOT NULL,
    concurrency integer DEFAULT 5 NOT NULL,
    "connectionTimeout" integer DEFAULT 30000 NOT NULL,
    "organizationId" text NOT NULL,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "updatedAt" timestamp(3) without time zone NOT NULL
);


ALTER TABLE public."EmailDeliverySettings" OWNER TO valknar;

--
-- Name: GeneralSettings; Type: TABLE; Schema: public; Owner: valknar
--

CREATE TABLE public."GeneralSettings" (
    id text NOT NULL,
    "defaultFromEmail" text,
    "defaultFromName" text,
    "baseURL" text,
    "organizationId" text NOT NULL,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "updatedAt" timestamp(3) without time zone NOT NULL,
    "cleanupInterval" integer DEFAULT 90 NOT NULL
);


ALTER TABLE public."GeneralSettings" OWNER TO valknar;

--
-- Name: List; Type: TABLE; Schema: public; Owner: valknar
--

CREATE TABLE public."List" (
    id text NOT NULL,
    name text NOT NULL,
    description text,
    "organizationId" text NOT NULL,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "updatedAt" timestamp(3) without time zone NOT NULL
);


ALTER TABLE public."List" OWNER TO valknar;

--
-- Name: ListSubscriber; Type: TABLE; Schema: public; Owner: valknar
--

CREATE TABLE public."ListSubscriber" (
    id text NOT NULL,
    "unsubscribedAt" timestamp(3) without time zone,
    "listId" text NOT NULL,
    "subscriberId" text NOT NULL,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "updatedAt" timestamp(3) without time zone NOT NULL
);


ALTER TABLE public."ListSubscriber" OWNER TO valknar;

--
-- Name: Message; Type: TABLE; Schema: public; Owner: valknar
--

CREATE TABLE public."Message" (
    id text NOT NULL,
    content text,
    status public."MessageStatus" DEFAULT 'QUEUED'::public."MessageStatus" NOT NULL,
    "sentAt" timestamp(3) without time zone,
    tries integer DEFAULT 0 NOT NULL,
    "lastTriedAt" timestamp(3) without time zone,
    "messageId" text,
    "subscriberId" text NOT NULL,
    "campaignId" text NOT NULL,
    error text,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "updatedAt" timestamp(3) without time zone NOT NULL
);


ALTER TABLE public."Message" OWNER TO valknar;

--
-- Name: Organization; Type: TABLE; Schema: public; Owner: valknar
--

CREATE TABLE public."Organization" (
    id text NOT NULL,
    name text NOT NULL,
    description text,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "updatedAt" timestamp(3) without time zone NOT NULL
);


ALTER TABLE public."Organization" OWNER TO valknar;

--
-- Name: SmtpSettings; Type: TABLE; Schema: public; Owner: valknar
--

CREATE TABLE public."SmtpSettings" (
    id text NOT NULL,
    host text NOT NULL,
    port integer NOT NULL,
    username text NOT NULL,
    password text NOT NULL,
    "fromEmail" text,
    "fromName" text,
    secure boolean DEFAULT true NOT NULL,
    encryption public."SmtpEncryption" DEFAULT 'STARTTLS'::public."SmtpEncryption" NOT NULL,
    timeout integer DEFAULT 30000 NOT NULL,
    "organizationId" text NOT NULL,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "updatedAt" timestamp(3) without time zone NOT NULL
);


ALTER TABLE public."SmtpSettings" OWNER TO valknar;

--
-- Name: Subscriber; Type: TABLE; Schema: public; Owner: valknar
--

CREATE TABLE public."Subscriber" (
    id text NOT NULL,
    name text,
    email text NOT NULL,
    "organizationId" text NOT NULL,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "updatedAt" timestamp(3) without time zone NOT NULL,
    "emailVerificationToken" text,
    "emailVerificationTokenExpiresAt" timestamp(3) without time zone,
    "emailVerified" boolean DEFAULT false NOT NULL
);


ALTER TABLE public."Subscriber" OWNER TO valknar;

--
-- Name: SubscriberMetadata; Type: TABLE; Schema: public; Owner: valknar
--

CREATE TABLE public."SubscriberMetadata" (
    id text NOT NULL,
    key text NOT NULL,
    value text NOT NULL,
    "subscriberId" text NOT NULL,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "updatedAt" timestamp(3) without time zone NOT NULL
);


ALTER TABLE public."SubscriberMetadata" OWNER TO valknar;

--
-- Name: Template; Type: TABLE; Schema: public; Owner: valknar
--

CREATE TABLE public."Template" (
    id text NOT NULL,
    name text NOT NULL,
    description text,
    content text NOT NULL,
    "organizationId" text NOT NULL,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "updatedAt" timestamp(3) without time zone NOT NULL
);


ALTER TABLE public."Template" OWNER TO valknar;

--
-- Name: TrackedLink; Type: TABLE; Schema: public; Owner: valknar
--

CREATE TABLE public."TrackedLink" (
    id text NOT NULL,
    url text NOT NULL,
    "campaignId" text,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "updatedAt" timestamp(3) without time zone NOT NULL
);


ALTER TABLE public."TrackedLink" OWNER TO valknar;

--
-- Name: User; Type: TABLE; Schema: public; Owner: valknar
--

CREATE TABLE public."User" (
    id text NOT NULL,
    name text NOT NULL,
    email text NOT NULL,
    password text NOT NULL,
    "pwdVersion" integer DEFAULT 1 NOT NULL,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "updatedAt" timestamp(3) without time zone NOT NULL
);


ALTER TABLE public."User" OWNER TO valknar;

--
-- Name: UserOrganization; Type: TABLE; Schema: public; Owner: valknar
--

CREATE TABLE public."UserOrganization" (
    "userId" text NOT NULL,
    "organizationId" text NOT NULL
);


ALTER TABLE public."UserOrganization" OWNER TO valknar;

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
-- Data for Name: ApiKey; Type: TABLE DATA; Schema: public; Owner: valknar
--

COPY public."ApiKey" (id, name, key, "lastUsed", "expiresAt", "organizationId", "createdAt", "updatedAt") FROM stdin;
0b0d4b01-7370-4927-a324-86ec16496f9e	SexyArt	sk_47861a02d7d5aaaf35fd74a6eb5a16037d3ab16f6838fcba814ec22d6405f34a	2025-10-06 09:11:01.919	\N	57aabb52-5e06-40d2-9d59-ca31c5521bea	2025-10-06 08:57:53.281	2025-10-06 09:11:01.922
\.


--
-- Data for Name: Campaign; Type: TABLE DATA; Schema: public; Owner: valknar
--

COPY public."Campaign" (id, title, description, subject, content, "completedAt", status, "scheduledAt", "htmlOnly", "openTracking", "organizationId", "templateId", "createdAt", "updatedAt", "unsubscribedCount") FROM stdin;
\.


--
-- Data for Name: CampaignList; Type: TABLE DATA; Schema: public; Owner: valknar
--

COPY public."CampaignList" ("campaignId", "listId") FROM stdin;
\.


--
-- Data for Name: Click; Type: TABLE DATA; Schema: public; Owner: valknar
--

COPY public."Click" (id, "trackedLinkId", "subscriberId", "createdAt", "updatedAt") FROM stdin;
\.


--
-- Data for Name: EmailDeliverySettings; Type: TABLE DATA; Schema: public; Owner: valknar
--

COPY public."EmailDeliverySettings" (id, "rateLimit", "rateWindow", "maxRetries", "retryDelay", concurrency, "connectionTimeout", "organizationId", "createdAt", "updatedAt") FROM stdin;
7e1c82a2-03fc-467f-8829-4d97dcd4b5db	100	3600	3	300	5	30000	57aabb52-5e06-40d2-9d59-ca31c5521bea	2025-10-05 07:12:48.226	2025-10-05 07:12:48.226
\.


--
-- Data for Name: GeneralSettings; Type: TABLE DATA; Schema: public; Owner: valknar
--

COPY public."GeneralSettings" (id, "defaultFromEmail", "defaultFromName", "baseURL", "organizationId", "createdAt", "updatedAt", "cleanupInterval") FROM stdin;
d79fc690-e19c-446f-a24b-a6d41284c4b4	hi@pivoine.art	Pivoine.Art	https://news.pivoine.art	57aabb52-5e06-40d2-9d59-ca31c5521bea	2025-10-05 07:12:48.226	2025-10-05 07:19:10.954	90
\.


--
-- Data for Name: List; Type: TABLE DATA; Schema: public; Owner: valknar
--

COPY public."List" (id, name, description, "organizationId", "createdAt", "updatedAt") FROM stdin;
f761303e-eaf5-47ba-ad27-702253255e45	SexyArt		57aabb52-5e06-40d2-9d59-ca31c5521bea	2025-10-05 07:13:21.777	2025-10-06 08:38:01.123
\.


--
-- Data for Name: ListSubscriber; Type: TABLE DATA; Schema: public; Owner: valknar
--

COPY public."ListSubscriber" (id, "unsubscribedAt", "listId", "subscriberId", "createdAt", "updatedAt") FROM stdin;
\.


--
-- Data for Name: Message; Type: TABLE DATA; Schema: public; Owner: valknar
--

COPY public."Message" (id, content, status, "sentAt", tries, "lastTriedAt", "messageId", "subscriberId", "campaignId", error, "createdAt", "updatedAt") FROM stdin;
\.


--
-- Data for Name: Organization; Type: TABLE DATA; Schema: public; Owner: valknar
--

COPY public."Organization" (id, name, description, "createdAt", "updatedAt") FROM stdin;
57aabb52-5e06-40d2-9d59-ca31c5521bea	Pivoine.Art		2025-10-05 07:12:48.226	2025-10-05 07:12:48.226
\.


--
-- Data for Name: SmtpSettings; Type: TABLE DATA; Schema: public; Owner: valknar
--

COPY public."SmtpSettings" (id, host, port, username, password, "fromEmail", "fromName", secure, encryption, timeout, "organizationId", "createdAt", "updatedAt") FROM stdin;
8915a092-6392-4d45-932a-e85416767031	smtp.ionos.de	465	hi@pivoine.art	jaquoment	hi@pivoine.art	Pivoine.Art	t	SSL_TLS	30000	57aabb52-5e06-40d2-9d59-ca31c5521bea	2025-10-05 07:15:13.588	2025-10-05 07:15:13.588
\.


--
-- Data for Name: Subscriber; Type: TABLE DATA; Schema: public; Owner: valknar
--

COPY public."Subscriber" (id, name, email, "organizationId", "createdAt", "updatedAt", "emailVerificationToken", "emailVerificationTokenExpiresAt", "emailVerified") FROM stdin;
\.


--
-- Data for Name: SubscriberMetadata; Type: TABLE DATA; Schema: public; Owner: valknar
--

COPY public."SubscriberMetadata" (id, key, value, "subscriberId", "createdAt", "updatedAt") FROM stdin;
\.


--
-- Data for Name: Template; Type: TABLE DATA; Schema: public; Owner: valknar
--

COPY public."Template" (id, name, description, content, "organizationId", "createdAt", "updatedAt") FROM stdin;
2a52a963-e09d-401b-b46f-5546ab34dd91	Newsletter	\N	<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">\n<html dir="ltr" lang="en">\n  <head>\n    <meta content="text/html; charset=UTF-8" http-equiv="Content-Type" />\n    <meta name="x-apple-disable-message-reformatting" />\n    <title>Dev Blog Weekly</title>\n    <div\n      style="\n        display: none;\n        overflow: hidden;\n        line-height: 1px;\n        opacity: 0;\n        max-height: 0;\n        max-width: 0;\n      "\n    ></div>\n  </head>\n  <body\n    style="\n      background-color: rgb(21, 21, 22);\n      font-family: ui-sans-serif, system-ui, sans-serif,\n        &quot;Apple Color Emoji&quot;, &quot;Segoe UI Emoji&quot;,\n        &quot;Segoe UI Symbol&quot;, &quot;Noto Color Emoji&quot;;\n      padding-top: 40px;\n      padding-bottom: 40px;\n    "\n  >\n    <!--$-->\n    <table\n      align="center"\n      width="100%"\n      border="0"\n      cellpadding="0"\n      cellspacing="0"\n      role="presentation"\n      style="\n        background-color: rgb(0, 0, 0);\n        border-radius: 8px;\n        margin-left: auto;\n        margin-right: auto;\n        padding: 24px;\n        max-width: 600px;\n      "\n    >\n      <tbody>\n        <tr style="width: 100%">\n          <td>\n            <div style="color: rgb(229, 231, 235); font-size: 16px">\n              {{content}}\n            </div>\n            <hr\n              style="\n                border-width: 1px;\n                border-color: rgb(51, 51, 51);\n                margin-top: 32px;\n                margin-bottom: 32px;\n                width: 100%;\n                border: none;\n                border-top: 1px solid #eaeaea;\n              "\n            />\n            <p\n              style="\n                font-size: 14px;\n                color: rgb(153, 153, 153);\n                margin: 0px;\n                line-height: 24px;\n                margin-bottom: 0px;\n                margin-top: 0px;\n                margin-left: 0px;\n                margin-right: 0px;\n              "\n            >\n              © 2025 Dev Blog Weekly. All rights reserved.\n            </p>\n            <p\n              style="\n                font-size: 14px;\n                color: rgb(153, 153, 153);\n                margin: 0px;\n                line-height: 24px;\n                margin-bottom: 0px;\n                margin-top: 0px;\n                margin-left: 0px;\n                margin-right: 0px;\n              "\n            >\n              123 Coding Street, Developer City, DC 12345\n            </p>\n            <p\n              style="\n                font-size: 14px;\n                color: rgb(153, 153, 153);\n                margin-top: 8px;\n                line-height: 24px;\n                margin-bottom: 16px;\n              "\n            >\n              <a\n                href="{{unsubscribe_link}}"\n                style="color: rgb(77, 33, 252); text-decoration-line: none"\n                target="_blank"\n                >Unsubscribe</a\n              >\n              <!-- -->•<!-- -->\n              <a\n                href="#"\n                style="color: rgb(77, 33, 252); text-decoration-line: none"\n                target="_blank"\n                >Update preferences</a\n              >\n            </p>\n          </td>\n        </tr>\n      </tbody>\n    </table>\n    <!--7--><!--/$-->\n  </body>\n</html>\n	57aabb52-5e06-40d2-9d59-ca31c5521bea	2025-10-05 07:12:48.226	2025-10-05 07:12:48.226
\.


--
-- Data for Name: TrackedLink; Type: TABLE DATA; Schema: public; Owner: valknar
--

COPY public."TrackedLink" (id, url, "campaignId", "createdAt", "updatedAt") FROM stdin;
\.


--
-- Data for Name: User; Type: TABLE DATA; Schema: public; Owner: valknar
--

COPY public."User" (id, name, email, password, "pwdVersion", "createdAt", "updatedAt") FROM stdin;
f6d94886-904e-48c8-b772-425b650a229e	Sebastian Krüger	valknar@pivoine.art	$2b$10$mjiTbDrFI5yE7Fexk9wVb.NNkMDFM4aymHVZ1TqJO6FESK8NrNf3.	1	2025-10-05 07:12:34.595	2025-10-05 07:12:34.595
\.


--
-- Data for Name: UserOrganization; Type: TABLE DATA; Schema: public; Owner: valknar
--

COPY public."UserOrganization" ("userId", "organizationId") FROM stdin;
f6d94886-904e-48c8-b772-425b650a229e	57aabb52-5e06-40d2-9d59-ca31c5521bea
\.


--
-- Data for Name: _prisma_migrations; Type: TABLE DATA; Schema: public; Owner: valknar
--

COPY public._prisma_migrations (id, checksum, finished_at, migration_name, logs, rolled_back_at, started_at, applied_steps_count) FROM stdin;
74b96b30-77e3-4771-a064-d1369c72074c	a2a612dfce1dfc5220b941204e2068832d3c38b0552d1182ccde2c8e7f908230	2025-10-03 08:17:32.565718+00	20250504151654_init	\N	\N	2025-10-03 08:17:32.545022+00	1
d1537ac9-ed76-4446-9fa9-2a5b4b59866f	e7789b6bf9523d900e1dd1f614e70ceec868128b084124894dbd944e73b7d0d8	2025-10-03 08:17:32.56996+00	20250507150657_double_opt_in	\N	\N	2025-10-03 08:17:32.566269+00	1
6ca89757-a175-4987-b295-2581a1ea81c4	c2c38fe78d47216874c77543476446b013d772062249ab4763fe42a8bdb83ea2	2025-10-03 08:17:32.572027+00	20250507232701_unsubscribe_count_per_campaign	\N	\N	2025-10-03 08:17:32.570439+00	1
4682b366-5a10-48c5-8aec-a15dee6bbd3b	d993ce09c2bd647b65d9f19c4c2eea8f16451b634dea65493efbb83c92562ab5	2025-10-03 08:17:32.573817+00	20250508171024_creating_state_for_campaign	\N	\N	2025-10-03 08:17:32.572501+00	1
dd62b0d6-d027-47f7-b545-116a1b956ef7	11c64e17a30a97662b5a10222855aa14a29d5613fd1c9dd37cb0cb5daf485186	2025-10-03 08:17:32.575801+00	20250509113341_cleanup_interval_to_90_days	\N	\N	2025-10-03 08:17:32.574261+00	1
7c7c5b1e-b91b-463f-821b-631d24e2f4b0	ce7abb520886218aad4a04a20d0ffcc489e2a66cb34afc4c513a70bb75483cef	2025-10-03 08:17:32.578146+00	20250516125759_indexed_updated_for_message	\N	\N	2025-10-03 08:17:32.576243+00	1
1af5b144-b4e7-4f0c-bc16-fd0b071c78f5	bba70e366bf67d6b9dffa8e866741f53eeb6e884809d7738455e9c4d0c83ac4d	2025-10-03 08:17:32.580392+00	20250530052056_message_status_update	\N	\N	2025-10-03 08:17:32.578737+00	1
\.


--
-- Name: ApiKey ApiKey_pkey; Type: CONSTRAINT; Schema: public; Owner: valknar
--

ALTER TABLE ONLY public."ApiKey"
    ADD CONSTRAINT "ApiKey_pkey" PRIMARY KEY (id);


--
-- Name: CampaignList CampaignList_pkey; Type: CONSTRAINT; Schema: public; Owner: valknar
--

ALTER TABLE ONLY public."CampaignList"
    ADD CONSTRAINT "CampaignList_pkey" PRIMARY KEY ("campaignId", "listId");


--
-- Name: Campaign Campaign_pkey; Type: CONSTRAINT; Schema: public; Owner: valknar
--

ALTER TABLE ONLY public."Campaign"
    ADD CONSTRAINT "Campaign_pkey" PRIMARY KEY (id);


--
-- Name: Click Click_pkey; Type: CONSTRAINT; Schema: public; Owner: valknar
--

ALTER TABLE ONLY public."Click"
    ADD CONSTRAINT "Click_pkey" PRIMARY KEY (id);


--
-- Name: EmailDeliverySettings EmailDeliverySettings_pkey; Type: CONSTRAINT; Schema: public; Owner: valknar
--

ALTER TABLE ONLY public."EmailDeliverySettings"
    ADD CONSTRAINT "EmailDeliverySettings_pkey" PRIMARY KEY (id);


--
-- Name: GeneralSettings GeneralSettings_pkey; Type: CONSTRAINT; Schema: public; Owner: valknar
--

ALTER TABLE ONLY public."GeneralSettings"
    ADD CONSTRAINT "GeneralSettings_pkey" PRIMARY KEY (id);


--
-- Name: ListSubscriber ListSubscriber_pkey; Type: CONSTRAINT; Schema: public; Owner: valknar
--

ALTER TABLE ONLY public."ListSubscriber"
    ADD CONSTRAINT "ListSubscriber_pkey" PRIMARY KEY (id);


--
-- Name: List List_pkey; Type: CONSTRAINT; Schema: public; Owner: valknar
--

ALTER TABLE ONLY public."List"
    ADD CONSTRAINT "List_pkey" PRIMARY KEY (id);


--
-- Name: Message Message_pkey; Type: CONSTRAINT; Schema: public; Owner: valknar
--

ALTER TABLE ONLY public."Message"
    ADD CONSTRAINT "Message_pkey" PRIMARY KEY (id);


--
-- Name: Organization Organization_pkey; Type: CONSTRAINT; Schema: public; Owner: valknar
--

ALTER TABLE ONLY public."Organization"
    ADD CONSTRAINT "Organization_pkey" PRIMARY KEY (id);


--
-- Name: SmtpSettings SmtpSettings_pkey; Type: CONSTRAINT; Schema: public; Owner: valknar
--

ALTER TABLE ONLY public."SmtpSettings"
    ADD CONSTRAINT "SmtpSettings_pkey" PRIMARY KEY (id);


--
-- Name: SubscriberMetadata SubscriberMetadata_pkey; Type: CONSTRAINT; Schema: public; Owner: valknar
--

ALTER TABLE ONLY public."SubscriberMetadata"
    ADD CONSTRAINT "SubscriberMetadata_pkey" PRIMARY KEY (id);


--
-- Name: Subscriber Subscriber_pkey; Type: CONSTRAINT; Schema: public; Owner: valknar
--

ALTER TABLE ONLY public."Subscriber"
    ADD CONSTRAINT "Subscriber_pkey" PRIMARY KEY (id);


--
-- Name: Template Template_pkey; Type: CONSTRAINT; Schema: public; Owner: valknar
--

ALTER TABLE ONLY public."Template"
    ADD CONSTRAINT "Template_pkey" PRIMARY KEY (id);


--
-- Name: TrackedLink TrackedLink_pkey; Type: CONSTRAINT; Schema: public; Owner: valknar
--

ALTER TABLE ONLY public."TrackedLink"
    ADD CONSTRAINT "TrackedLink_pkey" PRIMARY KEY (id);


--
-- Name: UserOrganization UserOrganization_pkey; Type: CONSTRAINT; Schema: public; Owner: valknar
--

ALTER TABLE ONLY public."UserOrganization"
    ADD CONSTRAINT "UserOrganization_pkey" PRIMARY KEY ("userId", "organizationId");


--
-- Name: User User_pkey; Type: CONSTRAINT; Schema: public; Owner: valknar
--

ALTER TABLE ONLY public."User"
    ADD CONSTRAINT "User_pkey" PRIMARY KEY (id);


--
-- Name: _prisma_migrations _prisma_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: valknar
--

ALTER TABLE ONLY public._prisma_migrations
    ADD CONSTRAINT _prisma_migrations_pkey PRIMARY KEY (id);


--
-- Name: ApiKey_key_key; Type: INDEX; Schema: public; Owner: valknar
--

CREATE UNIQUE INDEX "ApiKey_key_key" ON public."ApiKey" USING btree (key);


--
-- Name: EmailDeliverySettings_organizationId_key; Type: INDEX; Schema: public; Owner: valknar
--

CREATE UNIQUE INDEX "EmailDeliverySettings_organizationId_key" ON public."EmailDeliverySettings" USING btree ("organizationId");


--
-- Name: GeneralSettings_organizationId_key; Type: INDEX; Schema: public; Owner: valknar
--

CREATE UNIQUE INDEX "GeneralSettings_organizationId_key" ON public."GeneralSettings" USING btree ("organizationId");


--
-- Name: ListSubscriber_listId_subscriberId_key; Type: INDEX; Schema: public; Owner: valknar
--

CREATE UNIQUE INDEX "ListSubscriber_listId_subscriberId_key" ON public."ListSubscriber" USING btree ("listId", "subscriberId");


--
-- Name: Message_updatedAt_id_idx; Type: INDEX; Schema: public; Owner: valknar
--

CREATE INDEX "Message_updatedAt_id_idx" ON public."Message" USING btree ("updatedAt", id);


--
-- Name: SubscriberMetadata_subscriberId_key_key; Type: INDEX; Schema: public; Owner: valknar
--

CREATE UNIQUE INDEX "SubscriberMetadata_subscriberId_key_key" ON public."SubscriberMetadata" USING btree ("subscriberId", key);


--
-- Name: Subscriber_createdAt_id_idx; Type: INDEX; Schema: public; Owner: valknar
--

CREATE INDEX "Subscriber_createdAt_id_idx" ON public."Subscriber" USING btree ("createdAt", id);


--
-- Name: Subscriber_emailVerificationToken_key; Type: INDEX; Schema: public; Owner: valknar
--

CREATE UNIQUE INDEX "Subscriber_emailVerificationToken_key" ON public."Subscriber" USING btree ("emailVerificationToken");


--
-- Name: Subscriber_organizationId_email_key; Type: INDEX; Schema: public; Owner: valknar
--

CREATE UNIQUE INDEX "Subscriber_organizationId_email_key" ON public."Subscriber" USING btree ("organizationId", email);


--
-- Name: TrackedLink_url_campaignId_key; Type: INDEX; Schema: public; Owner: valknar
--

CREATE UNIQUE INDEX "TrackedLink_url_campaignId_key" ON public."TrackedLink" USING btree (url, "campaignId");


--
-- Name: User_email_key; Type: INDEX; Schema: public; Owner: valknar
--

CREATE UNIQUE INDEX "User_email_key" ON public."User" USING btree (email);


--
-- Name: ApiKey ApiKey_organizationId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: valknar
--

ALTER TABLE ONLY public."ApiKey"
    ADD CONSTRAINT "ApiKey_organizationId_fkey" FOREIGN KEY ("organizationId") REFERENCES public."Organization"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: CampaignList CampaignList_campaignId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: valknar
--

ALTER TABLE ONLY public."CampaignList"
    ADD CONSTRAINT "CampaignList_campaignId_fkey" FOREIGN KEY ("campaignId") REFERENCES public."Campaign"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: CampaignList CampaignList_listId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: valknar
--

ALTER TABLE ONLY public."CampaignList"
    ADD CONSTRAINT "CampaignList_listId_fkey" FOREIGN KEY ("listId") REFERENCES public."List"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: Campaign Campaign_organizationId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: valknar
--

ALTER TABLE ONLY public."Campaign"
    ADD CONSTRAINT "Campaign_organizationId_fkey" FOREIGN KEY ("organizationId") REFERENCES public."Organization"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: Campaign Campaign_templateId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: valknar
--

ALTER TABLE ONLY public."Campaign"
    ADD CONSTRAINT "Campaign_templateId_fkey" FOREIGN KEY ("templateId") REFERENCES public."Template"(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: Click Click_subscriberId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: valknar
--

ALTER TABLE ONLY public."Click"
    ADD CONSTRAINT "Click_subscriberId_fkey" FOREIGN KEY ("subscriberId") REFERENCES public."Subscriber"(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: Click Click_trackedLinkId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: valknar
--

ALTER TABLE ONLY public."Click"
    ADD CONSTRAINT "Click_trackedLinkId_fkey" FOREIGN KEY ("trackedLinkId") REFERENCES public."TrackedLink"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: EmailDeliverySettings EmailDeliverySettings_organizationId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: valknar
--

ALTER TABLE ONLY public."EmailDeliverySettings"
    ADD CONSTRAINT "EmailDeliverySettings_organizationId_fkey" FOREIGN KEY ("organizationId") REFERENCES public."Organization"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: GeneralSettings GeneralSettings_organizationId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: valknar
--

ALTER TABLE ONLY public."GeneralSettings"
    ADD CONSTRAINT "GeneralSettings_organizationId_fkey" FOREIGN KEY ("organizationId") REFERENCES public."Organization"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: ListSubscriber ListSubscriber_listId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: valknar
--

ALTER TABLE ONLY public."ListSubscriber"
    ADD CONSTRAINT "ListSubscriber_listId_fkey" FOREIGN KEY ("listId") REFERENCES public."List"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: ListSubscriber ListSubscriber_subscriberId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: valknar
--

ALTER TABLE ONLY public."ListSubscriber"
    ADD CONSTRAINT "ListSubscriber_subscriberId_fkey" FOREIGN KEY ("subscriberId") REFERENCES public."Subscriber"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: List List_organizationId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: valknar
--

ALTER TABLE ONLY public."List"
    ADD CONSTRAINT "List_organizationId_fkey" FOREIGN KEY ("organizationId") REFERENCES public."Organization"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: Message Message_campaignId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: valknar
--

ALTER TABLE ONLY public."Message"
    ADD CONSTRAINT "Message_campaignId_fkey" FOREIGN KEY ("campaignId") REFERENCES public."Campaign"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: Message Message_subscriberId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: valknar
--

ALTER TABLE ONLY public."Message"
    ADD CONSTRAINT "Message_subscriberId_fkey" FOREIGN KEY ("subscriberId") REFERENCES public."Subscriber"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: SmtpSettings SmtpSettings_organizationId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: valknar
--

ALTER TABLE ONLY public."SmtpSettings"
    ADD CONSTRAINT "SmtpSettings_organizationId_fkey" FOREIGN KEY ("organizationId") REFERENCES public."Organization"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: SubscriberMetadata SubscriberMetadata_subscriberId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: valknar
--

ALTER TABLE ONLY public."SubscriberMetadata"
    ADD CONSTRAINT "SubscriberMetadata_subscriberId_fkey" FOREIGN KEY ("subscriberId") REFERENCES public."Subscriber"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: Subscriber Subscriber_organizationId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: valknar
--

ALTER TABLE ONLY public."Subscriber"
    ADD CONSTRAINT "Subscriber_organizationId_fkey" FOREIGN KEY ("organizationId") REFERENCES public."Organization"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: Template Template_organizationId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: valknar
--

ALTER TABLE ONLY public."Template"
    ADD CONSTRAINT "Template_organizationId_fkey" FOREIGN KEY ("organizationId") REFERENCES public."Organization"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: TrackedLink TrackedLink_campaignId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: valknar
--

ALTER TABLE ONLY public."TrackedLink"
    ADD CONSTRAINT "TrackedLink_campaignId_fkey" FOREIGN KEY ("campaignId") REFERENCES public."Campaign"(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: UserOrganization UserOrganization_organizationId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: valknar
--

ALTER TABLE ONLY public."UserOrganization"
    ADD CONSTRAINT "UserOrganization_organizationId_fkey" FOREIGN KEY ("organizationId") REFERENCES public."Organization"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: UserOrganization UserOrganization_userId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: valknar
--

ALTER TABLE ONLY public."UserOrganization"
    ADD CONSTRAINT "UserOrganization_userId_fkey" FOREIGN KEY ("userId") REFERENCES public."User"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- PostgreSQL database dump complete
--

\unrestrict Q19dhbbwN4oYNryFn4zrNlLTpPxtKQLjkEUfbdNFT6l9nWN7aAGnyXdzk57SvJH

