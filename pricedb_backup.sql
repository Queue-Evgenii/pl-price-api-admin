--
-- PostgreSQL database dump
--

\restrict gVY3iWc2653LDopA5rfd3c6LLSRAcqhjzlaxDMPSSwdDTQLscoDfYgsDfU5fO4W

-- Dumped from database version 13.23 (Debian 13.23-1.pgdg13+1)
-- Dumped by pg_dump version 13.23 (Debian 13.23-1.pgdg13+1)

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: user_entity_role_enum; Type: TYPE; Schema: public; Owner: myuser
--

CREATE TYPE public.user_entity_role_enum AS ENUM (
    'default',
    'admin'
);


ALTER TYPE public.user_entity_role_enum OWNER TO myuser;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: category_entity; Type: TABLE; Schema: public; Owner: myuser
--

CREATE TABLE public.category_entity (
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    slug character varying(255) NOT NULL,
    "parentId" integer,
    "orderId" integer NOT NULL,
    "siteId" integer
);


ALTER TABLE public.category_entity OWNER TO myuser;

--
-- Name: category_entity_closure; Type: TABLE; Schema: public; Owner: myuser
--

CREATE TABLE public.category_entity_closure (
    id_ancestor integer NOT NULL,
    id_descendant integer NOT NULL
);


ALTER TABLE public.category_entity_closure OWNER TO myuser;

--
-- Name: category_entity_id_seq; Type: SEQUENCE; Schema: public; Owner: myuser
--

CREATE SEQUENCE public.category_entity_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.category_entity_id_seq OWNER TO myuser;

--
-- Name: category_entity_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: myuser
--

ALTER SEQUENCE public.category_entity_id_seq OWNED BY public.category_entity.id;


--
-- Name: photo_entity; Type: TABLE; Schema: public; Owner: myuser
--

CREATE TABLE public.photo_entity (
    id integer NOT NULL,
    url character varying(255) NOT NULL,
    "orderId" integer NOT NULL,
    "isActive" boolean DEFAULT false NOT NULL,
    "categoryId" integer,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    name character varying(255)
);


ALTER TABLE public.photo_entity OWNER TO myuser;

--
-- Name: photo_entity_id_seq; Type: SEQUENCE; Schema: public; Owner: myuser
--

CREATE SEQUENCE public.photo_entity_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.photo_entity_id_seq OWNER TO myuser;

--
-- Name: photo_entity_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: myuser
--

ALTER SEQUENCE public.photo_entity_id_seq OWNED BY public.photo_entity.id;


--
-- Name: site_entity; Type: TABLE; Schema: public; Owner: myuser
--

CREATE TABLE public.site_entity (
    id integer NOT NULL,
    code character varying NOT NULL,
    name character varying,
    active boolean DEFAULT false NOT NULL
);


ALTER TABLE public.site_entity OWNER TO myuser;

--
-- Name: site_entity_id_seq; Type: SEQUENCE; Schema: public; Owner: myuser
--

CREATE SEQUENCE public.site_entity_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.site_entity_id_seq OWNER TO myuser;

--
-- Name: site_entity_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: myuser
--

ALTER SEQUENCE public.site_entity_id_seq OWNED BY public.site_entity.id;


--
-- Name: user_entity; Type: TABLE; Schema: public; Owner: myuser
--

CREATE TABLE public.user_entity (
    id integer NOT NULL,
    email character varying NOT NULL,
    password character varying NOT NULL,
    name character varying,
    role public.user_entity_role_enum DEFAULT 'default'::public.user_entity_role_enum NOT NULL
);


ALTER TABLE public.user_entity OWNER TO myuser;

--
-- Name: user_entity_id_seq; Type: SEQUENCE; Schema: public; Owner: myuser
--

CREATE SEQUENCE public.user_entity_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.user_entity_id_seq OWNER TO myuser;

--
-- Name: user_entity_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: myuser
--

ALTER SEQUENCE public.user_entity_id_seq OWNED BY public.user_entity.id;


--
-- Name: category_entity id; Type: DEFAULT; Schema: public; Owner: myuser
--

ALTER TABLE ONLY public.category_entity ALTER COLUMN id SET DEFAULT nextval('public.category_entity_id_seq'::regclass);


--
-- Name: photo_entity id; Type: DEFAULT; Schema: public; Owner: myuser
--

ALTER TABLE ONLY public.photo_entity ALTER COLUMN id SET DEFAULT nextval('public.photo_entity_id_seq'::regclass);


--
-- Name: site_entity id; Type: DEFAULT; Schema: public; Owner: myuser
--

ALTER TABLE ONLY public.site_entity ALTER COLUMN id SET DEFAULT nextval('public.site_entity_id_seq'::regclass);


--
-- Name: user_entity id; Type: DEFAULT; Schema: public; Owner: myuser
--

ALTER TABLE ONLY public.user_entity ALTER COLUMN id SET DEFAULT nextval('public.user_entity_id_seq'::regclass);


--
-- Data for Name: category_entity; Type: TABLE DATA; Schema: public; Owner: myuser
--

COPY public.category_entity (created_at, updated_at, id, name, slug, "parentId", "orderId", "siteId") FROM stdin;
2025-08-02 16:38:46.909818	2025-10-27 18:54:50.715495	10	Cennik Folii	cennik-folii	\N	1	1
2025-10-27 18:33:58.625296	2025-10-27 18:56:15.327717	28	Katalog  Narożników - Łączników - Kształtów 	katalog-naroznikow-acznikow-ksztaltow	\N	3	1
2025-11-18 16:40:50.001858	2025-11-18 16:40:50.001858	29	Program do sufitu	program-do-sufitu	\N	8	1
2025-08-02 16:39:00.59546	2025-11-25 12:47:46.999801	11	Cennik Profili	cennik-profili	\N	2	1
2025-12-09 08:08:42.317022	2025-12-09 08:08:42.317022	31	Wentylacja "Cień"	wentylacja-cien	\N	9	1
2025-08-02 16:38:36.783907	2025-12-09 09:47:49.539959	9	Akcesoria	akcesoria	\N	5	1
2025-12-09 08:09:15.238987	2025-12-09 09:48:00.366286	32	Rewizja	rewizja	\N	10	1
2025-09-02 08:20:21.759787	2025-09-02 08:20:21.759787	25	Duble Vision	duble-vision	24	1	1
2025-09-02 08:20:57.103745	2025-09-02 08:20:57.103745	26	Art and Loft	art-and-loft	24	2	1
2025-09-02 08:21:58.184947	2025-09-02 08:21:58.184947	27	Pliki do druku	pliki-do-druku	24	3	1
2025-09-01 16:51:47.092446	2025-10-27 18:44:33.82618	22	Oświetlenie szynowe magnetyczne	oswietlenie-szynowe-magnetyczne	\N	4	1
2025-09-02 08:18:34.759312	2025-10-27 18:44:49.116198	24	Katalog plików do druku	katalog-plikow-do-druku	\N	6	1
2025-09-01 18:04:04.991529	2025-10-27 18:44:49.116198	23	Produkty reklamowe	produkty-reklamowe	\N	7	1
\.


--
-- Data for Name: category_entity_closure; Type: TABLE DATA; Schema: public; Owner: myuser
--

COPY public.category_entity_closure (id_ancestor, id_descendant) FROM stdin;
9	9
10	10
11	11
22	22
23	23
24	24
25	25
24	25
26	26
24	26
27	27
24	27
28	28
29	29
31	31
32	32
\.


--
-- Data for Name: photo_entity; Type: TABLE DATA; Schema: public; Owner: myuser
--

COPY public.photo_entity (id, url, "orderId", "isActive", "categoryId", created_at, updated_at, name) FROM stdin;
106	https://polandgroups.pl/price/backend/uploads/categories/photos/1--1755754529428-896884314.JPG	1	t	10	2025-08-21 08:35:29.467667	2025-08-21 08:35:31.220109	1--1755754529428-896884314.JPG
107	https://polandgroups.pl/price/backend/uploads/categories/photos/2--1755754537121-511812335.JPG	2	t	10	2025-08-21 08:35:37.139884	2025-08-21 08:35:38.423699	2--1755754537121-511812335.JPG
117	https://polandgroups.pl/price/backend/uploads/categories/photos/1--1755756027864-441479194.JPG	1	t	11	2025-08-21 09:00:27.890097	2025-08-21 09:07:01.057816	1--1755756027864-441479194.JPG
136	https://polandgroups.pl/price/backend/uploads/categories/photos/22--1755756170159-97824603.JPG	21	t	11	2025-08-21 09:02:50.170222	2025-11-24 14:07:41.254395	22--1755756170159-97824603.JPG
132	https://polandgroups.pl/price/backend/uploads/categories/photos/18--1755756152273-110044064.JPG	17	t	11	2025-08-21 09:02:32.285373	2025-11-24 14:07:41.191	18--1755756152273-110044064.JPG
130	https://polandgroups.pl/price/backend/uploads/categories/photos/16--1755756148707-291720484.JPG	16	t	11	2025-08-21 09:02:28.729271	2025-11-24 14:08:23.361235	16--1755756148707-291720484.JPG
156	https://polandgroups.pl/price/backend/uploads/categories/photos/akcesoria-2025-5_page-0012--1756734539469-746344988.jpg	15	t	9	2025-09-01 16:48:59.483918	2025-12-16 09:03:53.418	akcesoria-2025-5_page-0012--1756734539469-746344988.jpg
143	https://polandgroups.pl/price/backend/uploads/categories/photos/14--1755756239095-658390827.JPG	14	t	11	2025-08-21 09:03:59.116056	2025-11-24 14:06:37.984839	14--1755756239095-658390827.JPG
138	https://polandgroups.pl/price/backend/uploads/categories/photos/24--1755756180039-664127985.JPG	24	t	11	2025-08-21 09:03:00.049266	2025-11-24 14:09:24.680345	24--1755756180039-664127985.JPG
150	https://polandgroups.pl/price/backend/uploads/categories/photos/akcesoria-2025-5_page-0006--1756734484493-630200953.jpg	13	t	9	2025-09-01 16:48:04.504974	2025-12-16 09:04:15.772054	akcesoria-2025-5_page-0006--1756734484493-630200953.jpg
154	https://polandgroups.pl/price/backend/uploads/categories/photos/akcesoria-2025-5_page-0010--1756734524759-756941479.jpg	24	t	9	2025-09-01 16:48:44.778678	2025-12-16 09:05:01.901953	akcesoria-2025-5_page-0010--1756734524759-756941479.jpg
152	https://polandgroups.pl/price/backend/uploads/categories/photos/akcesoria-2025-5_page-0008--1756734508481-476147118.jpg	17	t	9	2025-09-01 16:48:28.505319	2025-12-16 09:05:09.665482	akcesoria-2025-5_page-0008--1756734508481-476147118.jpg
161	https://polandgroups.pl/price/backend/uploads/categories/photos/5--1756736830127-473717731.JPG	5	t	22	2025-09-01 17:27:10.143226	2025-11-24 13:42:50.393453	5--1756736830127-473717731.JPG
163	https://polandgroups.pl/price/backend/uploads/categories/photos/7--1756736840302-906343748.JPG	7	t	22	2025-09-01 17:27:20.312864	2025-11-24 13:42:54.636921	7--1756736840302-906343748.JPG
339	https://polandgroups.pl/price/backend/uploads/categories/photos/maket-nowy-akcesoria-2025-3--1765868209498-445843508.jpg	4	t	32	2025-12-16 08:56:49.530703	2025-12-16 08:56:51.910073	maket-nowy-akcesoria-2025-3--1765868209498-445843508.jpg
157	https://polandgroups.pl/price/backend/uploads/categories/photos/1--1756736804026-605109908.JPG	0	t	22	2025-09-01 17:26:44.049389	2025-11-24 13:42:16.88203	1--1756736804026-605109908.JPG
178	https://polandgroups.pl/price/backend/uploads/categories/photos/22--1756736933675-777957036.JPG	23	t	22	2025-09-01 17:28:53.690403	2025-11-24 13:41:07.845	22--1756736933675-777957036.JPG
175	https://polandgroups.pl/price/backend/uploads/categories/photos/19--1756736920626-375681132.JPG	22	t	22	2025-09-01 17:28:40.64805	2025-11-24 13:44:46.484013	19--1756736920626-375681132.JPG
180	https://polandgroups.pl/price/backend/uploads/categories/photos/1--1756739068698-749134049.JPG	1	t	23	2025-09-01 18:04:28.718128	2025-09-01 18:04:29.924796	1--1756739068698-749134049.JPG
340	https://polandgroups.pl/price/backend/uploads/categories/photos/maket-nowy-akcesoria-2025-2--1765868278610-555361996.jpg	2	t	31	2025-12-16 08:57:58.648145	2025-12-16 08:58:10.703104	maket-nowy-akcesoria-2025-2--1765868278610-555361996.jpg
341	https://polandgroups.pl/price/backend/uploads/categories/photos/maket-nowy-akcesoria-2025(1)--1765868287231-496073069.jpg	3	t	31	2025-12-16 08:58:07.249496	2025-12-16 08:58:21.189357	maket-nowy-akcesoria-2025(1)--1765868287231-496073069.jpg
111	https://polandgroups.pl/price/backend/uploads/categories/photos/6--1755754562866-838622716.JPG	6	t	10	2025-08-21 08:36:02.879539	2025-08-21 08:36:35.314054	6--1755754562866-838622716.JPG
110	https://polandgroups.pl/price/backend/uploads/categories/photos/5--1755754558825-831285490.JPG	5	t	10	2025-08-21 08:35:58.83532	2025-08-21 08:36:36.315978	5--1755754558825-831285490.JPG
343	https://polandgroups.pl/price/backend/uploads/categories/photos/maket-nowy-akcesoria-2025-3--1765868393081-597777042.jpg	11	t	9	2025-12-16 08:59:53.095213	2025-12-16 09:04:40.893966	maket-nowy-akcesoria-2025-3--1765868393081-597777042.jpg
344	https://polandgroups.pl/price/backend/uploads/categories/photos/maket-nowy-akcesoria-2025(1)--1765868397127-431029957.jpg	7	t	9	2025-12-16 08:59:57.143329	2025-12-16 09:03:53.402774	maket-nowy-akcesoria-2025(1)--1765868397127-431029957.jpg
342	https://polandgroups.pl/price/backend/uploads/categories/photos/maket-nowy-akcesoria-2025-2--1765868389107-628666200.jpg	8	t	9	2025-12-16 08:59:49.135629	2025-12-16 09:03:53.506773	maket-nowy-akcesoria-2025-2--1765868389107-628666200.jpg
240	https://polandgroups.pl/price/backend/uploads/categories/photos/katalog-print-wood-art-&-loft(1)_page-0043--1761579340482-200624551.jpg	42	t	26	2025-10-27 17:35:40.511411	2025-10-27 17:37:11.823173	katalog-print-wood-art-&-loft(1)_page-0043--1761579340482-200624551.jpg
146	https://polandgroups.pl/price/backend/uploads/categories/photos/akcesoria-2025-5_page-0002--1756734396363-264622061.jpg	12	t	9	2025-09-01 16:46:36.387262	2025-12-16 09:04:14.375779	akcesoria-2025-5_page-0002--1756734396363-264622061.jpg
257	https://polandgroups.pl/price/backend/uploads/categories/photos/katalog-plikã³w-niebo-gaåäzie-046-050--1761582528718-872153889.jpg	10	t	27	2025-10-27 18:28:48.737054	2025-10-27 18:28:57.822899	katalog-plikã³w-niebo-gaåäzie-046-050--1761582528718-872153889.jpg
258	https://polandgroups.pl/price/backend/uploads/categories/photos/katalog-plikã³w-niebo-gaåäzie-051-055--1761582543085-158598928.jpg	11	t	27	2025-10-27 18:29:03.099969	2025-10-27 18:29:20.63898	katalog-plikã³w-niebo-gaåäzie-051-055--1761582543085-158598928.jpg
259	https://polandgroups.pl/price/backend/uploads/categories/photos/katalog-plikã³w-niebo-gaåäzie-056-060--1761582573663-864333086.jpg	12	t	27	2025-10-27 18:29:33.707373	2025-10-27 18:31:12.16735	katalog-plikã³w-niebo-gaåäzie-056-060--1761582573663-864333086.jpg
109	https://polandgroups.pl/price/backend/uploads/categories/photos/4--1755754550451-218794381.JPG	4	t	10	2025-08-21 08:35:50.467553	2025-08-21 08:36:37.120753	4--1755754550451-218794381.JPG
108	https://polandgroups.pl/price/backend/uploads/categories/photos/3--1755754544215-945082973.JPG	3	t	10	2025-08-21 08:35:44.230346	2025-08-21 08:36:38.320956	3--1755754544215-945082973.JPG
174	https://polandgroups.pl/price/backend/uploads/categories/photos/18--1756736907375-542574244.JPG	21	t	22	2025-09-01 17:28:27.391061	2025-11-24 13:44:46.489386	18--1756736907375-542574244.JPG
306	https://polandgroups.pl/price/backend/uploads/categories/photos/katalog-profil-new-8--1763986805768-273385901.jpg	29	t	11	2025-11-24 14:20:05.7896	2025-11-24 14:20:12.534934	katalog-profil-new-8--1763986805768-273385901.jpg
173	https://polandgroups.pl/price/backend/uploads/categories/photos/17--1756736900369-328971728.JPG	19	t	22	2025-09-01 17:28:20.384752	2025-11-24 13:43:21.379521	17--1756736900369-328971728.JPG
171	https://polandgroups.pl/price/backend/uploads/categories/photos/15--1756736891826-941929387.JPG	15	t	22	2025-09-01 17:28:11.836206	2025-11-24 13:43:09.142538	15--1756736891826-941929387.JPG
165	https://polandgroups.pl/price/backend/uploads/categories/photos/9--1756736855924-195614574.JPG	9	t	22	2025-09-01 17:27:35.937617	2025-11-24 13:42:58.742015	9--1756736855924-195614574.JPG
167	https://polandgroups.pl/price/backend/uploads/categories/photos/11--1756736864857-996254597.JPG	11	t	22	2025-09-01 17:27:44.869035	2025-11-24 13:43:02.283604	11--1756736864857-996254597.JPG
149	https://polandgroups.pl/price/backend/uploads/categories/photos/akcesoria-2025-5_page-0005--1756734479381-462680932.jpg	12	t	9	2025-09-01 16:47:59.401006	2025-12-16 09:04:15.7662	akcesoria-2025-5_page-0005--1756734479381-462680932.jpg
322	https://polandgroups.pl/price/backend/uploads/categories/photos/1-(1)--1765260569764-327347343.JPG	1	t	31	2025-12-09 08:09:29.7836	2025-12-09 08:10:02.152124	1-(1)--1765260569764-327347343.JPG
137	https://polandgroups.pl/price/backend/uploads/categories/photos/23--1755756174634-903108803.JPG	23	t	11	2025-08-21 09:02:54.645459	2025-11-24 14:09:36.020419	23--1755756174634-903108803.JPG
131	https://polandgroups.pl/price/backend/uploads/categories/photos/17--1755756149877-823193935.JPG	16	t	11	2025-08-21 09:02:29.884686	2025-11-24 14:08:17.561742	17--1755756149877-823193935.JPG
133	https://polandgroups.pl/price/backend/uploads/categories/photos/19--1755756154523-595138948.JPG	18	t	11	2025-08-21 09:02:34.533389	2025-11-24 14:07:41.258898	19--1755756154523-595138948.JPG
118	https://polandgroups.pl/price/backend/uploads/categories/photos/2--1755756036443-992426946.JPG	2	t	11	2025-08-21 09:00:36.462826	2025-08-21 09:07:01.994055	2--1755756036443-992426946.JPG
119	https://polandgroups.pl/price/backend/uploads/categories/photos/3--1755756044238-352519492.JPG	3	t	11	2025-08-21 09:00:44.247541	2025-08-21 09:07:03.53032	3--1755756044238-352519492.JPG
120	https://polandgroups.pl/price/backend/uploads/categories/photos/4--1755756049557-711258301.JPG	4	t	11	2025-08-21 09:00:49.57418	2025-08-21 09:07:04.81734	4--1755756049557-711258301.JPG
121	https://polandgroups.pl/price/backend/uploads/categories/photos/5--1755756055832-688108368.JPG	5	t	11	2025-08-21 09:00:55.843922	2025-08-21 09:07:06.220158	5--1755756055832-688108368.JPG
122	https://polandgroups.pl/price/backend/uploads/categories/photos/6--1755756056829-780731291.JPG	6	t	11	2025-08-21 09:00:56.842984	2025-08-21 09:07:07.618873	6--1755756056829-780731291.JPG
123	https://polandgroups.pl/price/backend/uploads/categories/photos/7--1755756059879-368924756.JPG	7	t	11	2025-08-21 09:00:59.887675	2025-08-21 09:07:08.921417	7--1755756059879-368924756.JPG
124	https://polandgroups.pl/price/backend/uploads/categories/photos/8--1755756064593-877133187.JPG	8	t	11	2025-08-21 09:01:04.607474	2025-08-21 09:07:10.317133	8--1755756064593-877133187.JPG
125	https://polandgroups.pl/price/backend/uploads/categories/photos/9--1755756114807-670557747.JPG	9	t	11	2025-08-21 09:01:54.826852	2025-08-21 09:07:11.219669	9--1755756114807-670557747.JPG
126	https://polandgroups.pl/price/backend/uploads/categories/photos/10--1755756121011-292859436.JPG	10	t	11	2025-08-21 09:02:01.022096	2025-08-21 09:07:12.62079	10--1755756121011-292859436.JPG
116	https://polandgroups.pl/price/backend/uploads/categories/photos/11--1755754584701-63589235.JPG	11	t	10	2025-08-21 08:36:24.714824	2025-08-21 08:36:30.216425	11--1755754584701-63589235.JPG
115	https://polandgroups.pl/price/backend/uploads/categories/photos/10--1755754580534-518381650.JPG	10	t	10	2025-08-21 08:36:20.548861	2025-08-21 08:36:31.018849	10--1755754580534-518381650.JPG
114	https://polandgroups.pl/price/backend/uploads/categories/photos/9--1755754577043-739061642.JPG	9	t	10	2025-08-21 08:36:17.05821	2025-08-21 08:36:32.082558	9--1755754577043-739061642.JPG
113	https://polandgroups.pl/price/backend/uploads/categories/photos/8--1755754571786-290002590.JPG	8	t	10	2025-08-21 08:36:11.796076	2025-08-21 08:36:33.31918	8--1755754571786-290002590.JPG
112	https://polandgroups.pl/price/backend/uploads/categories/photos/7--1755754568509-566321084.JPG	7	t	10	2025-08-21 08:36:08.524431	2025-08-21 08:36:34.558543	7--1755754568509-566321084.JPG
164	https://polandgroups.pl/price/backend/uploads/categories/photos/8--1756736851299-131960057.JPG	8	t	22	2025-09-01 17:27:31.318136	2025-11-24 13:42:57.404473	8--1756736851299-131960057.JPG
160	https://polandgroups.pl/price/backend/uploads/categories/photos/4--1756736823002-657404797.JPG	5	t	22	2025-09-01 17:27:03.015794	2025-11-24 13:42:38.456929	4--1756736823002-657404797.JPG
168	https://polandgroups.pl/price/backend/uploads/categories/photos/12--1756736868716-129601521.JPG	12	t	22	2025-09-01 17:27:48.725919	2025-11-24 13:43:04.028459	12--1756736868716-129601521.JPG
186	https://polandgroups.pl/price/backend/uploads/categories/photos/double-vision-polandgroup_page-0009--1756790624036-233467196.jpg	9	t	25	2025-09-02 08:23:44.060439	2025-09-02 08:33:49.634294	double-vision-polandgroup_page-0009--1756790624036-233467196.jpg
187	https://polandgroups.pl/price/backend/uploads/categories/photos/double-vision-polandgroup_page-0010--1756790633381-133476365.jpg	10	t	25	2025-09-02 08:23:53.395256	2025-09-02 08:33:50.69426	double-vision-polandgroup_page-0010--1756790633381-133476365.jpg
181	https://polandgroups.pl/price/backend/uploads/categories/photos/double-vision-polandgroup_page-0001--1756790537397-641499938.jpg	1	t	25	2025-09-02 08:22:17.418907	2025-09-02 08:33:41.002882	double-vision-polandgroup_page-0001--1756790537397-641499938.jpg
182	https://polandgroups.pl/price/backend/uploads/categories/photos/double-vision-polandgroup_page-0002--1756790558117-753033740.jpg	2	t	25	2025-09-02 08:22:38.138473	2025-09-02 08:33:41.312652	double-vision-polandgroup_page-0002--1756790558117-753033740.jpg
195	https://polandgroups.pl/price/backend/uploads/categories/photos/double-vision-polandgroup_page-0015--1756791141760-380044496.jpg	15	t	25	2025-09-02 08:32:21.774398	2025-09-02 08:33:56.664368	double-vision-polandgroup_page-0015--1756791141760-380044496.jpg
189	https://polandgroups.pl/price/backend/uploads/categories/photos/double-vision-polandgroup_page-0012--1756790647543-203538087.jpg	12	t	25	2025-09-02 08:24:07.567385	2025-09-02 08:33:52.999398	double-vision-polandgroup_page-0012--1756790647543-203538087.jpg
188	https://polandgroups.pl/price/backend/uploads/categories/photos/double-vision-polandgroup_page-0011--1756790639807-183184053.jpg	11	t	25	2025-09-02 08:23:59.818714	2025-09-02 08:33:51.940847	double-vision-polandgroup_page-0011--1756790639807-183184053.jpg
193	https://polandgroups.pl/price/backend/uploads/categories/photos/double-vision-polandgroup_page-0013--1756791121093-405179831.jpg	13	t	25	2025-09-02 08:32:01.11662	2025-09-02 08:33:54.22823	double-vision-polandgroup_page-0013--1756791121093-405179831.jpg
185	https://polandgroups.pl/price/backend/uploads/categories/photos/double-vision-polandgroup_page-0007--1756790607918-993380324.jpg	7	t	25	2025-09-02 08:23:27.939533	2025-09-02 08:33:48.614802	double-vision-polandgroup_page-0007--1756790607918-993380324.jpg
183	https://polandgroups.pl/price/backend/uploads/categories/photos/double-vision-polandgroup_page-0003--1756790574017-827443089.jpg	3	t	25	2025-09-02 08:22:54.035607	2025-09-02 08:33:42.624072	double-vision-polandgroup_page-0003--1756790574017-827443089.jpg
194	https://polandgroups.pl/price/backend/uploads/categories/photos/double-vision-polandgroup_page-0014--1756791135369-296602737.jpg	14	t	25	2025-09-02 08:32:15.404749	2025-09-02 08:33:55.459167	double-vision-polandgroup_page-0014--1756791135369-296602737.jpg
192	https://polandgroups.pl/price/backend/uploads/categories/photos/double-vision-polandgroup_page-0008--1756791092745-230908888.jpg	8	t	25	2025-09-02 08:31:32.766253	2025-09-02 08:33:48.615837	double-vision-polandgroup_page-0008--1756791092745-230908888.jpg
190	https://polandgroups.pl/price/backend/uploads/categories/photos/double-vision-polandgroup_page-0004--1756791008673-519261911.jpg	4	t	25	2025-09-02 08:30:08.689496	2025-09-02 08:33:43.858485	double-vision-polandgroup_page-0004--1756791008673-519261911.jpg
184	https://polandgroups.pl/price/backend/uploads/categories/photos/double-vision-polandgroup_page-0005--1756790590013-61975969.jpg	5	t	25	2025-09-02 08:23:10.036564	2025-09-02 08:33:48.594462	double-vision-polandgroup_page-0005--1756790590013-61975969.jpg
191	https://polandgroups.pl/price/backend/uploads/categories/photos/double-vision-polandgroup_page-0006--1756791056080-600895782.jpg	6	t	25	2025-09-02 08:30:56.100292	2025-09-02 08:33:48.611888	double-vision-polandgroup_page-0006--1756791056080-600895782.jpg
196	https://polandgroups.pl/price/backend/uploads/categories/photos/double-vision-polandgroup_page-0016--1756791151642-858508222.jpg	16	t	25	2025-09-02 08:32:31.65946	2025-09-02 08:33:57.964709	double-vision-polandgroup_page-0016--1756791151642-858508222.jpg
197	https://polandgroups.pl/price/backend/uploads/categories/photos/double-vision-polandgroup_page-0017--1756791163587-201415960.jpg	17	t	25	2025-09-02 08:32:43.607721	2025-09-02 08:33:59.259611	double-vision-polandgroup_page-0017--1756791163587-201415960.jpg
198	https://polandgroups.pl/price/backend/uploads/categories/photos/double-vision-polandgroup_page-0018--1756791179092-975332984.jpg	18	t	25	2025-09-02 08:32:59.114188	2025-09-02 08:34:00.59601	double-vision-polandgroup_page-0018--1756791179092-975332984.jpg
202	https://polandgroups.pl/price/backend/uploads/categories/photos/katalog-print-wood-art-&-loft(1)_page-0004--1761578828735-194406274.jpg	4	t	26	2025-10-27 17:27:08.7528	2025-10-27 17:37:55.226103	katalog-print-wood-art-&-loft(1)_page-0004--1761578828735-194406274.jpg
201	https://polandgroups.pl/price/backend/uploads/categories/photos/katalog-print-wood-art-&-loft(1)_page-0003--1761578821662-917558797.jpg	3	t	26	2025-10-27 17:27:01.681301	2025-10-27 17:37:56.125435	katalog-print-wood-art-&-loft(1)_page-0003--1761578821662-917558797.jpg
200	https://polandgroups.pl/price/backend/uploads/categories/photos/katalog-print-wood-art-&-loft(1)_page-0002--1761578814507-860100425.jpg	2	t	26	2025-10-27 17:26:54.526122	2025-10-27 17:37:57.527889	katalog-print-wood-art-&-loft(1)_page-0002--1761578814507-860100425.jpg
199	https://polandgroups.pl/price/backend/uploads/categories/photos/katalog-print-wood-art-&-loft(1)_page-0001--1761578805553-155468721.jpg	1	t	26	2025-10-27 17:26:45.590652	2025-10-27 17:37:58.923979	katalog-print-wood-art-&-loft(1)_page-0001--1761578805553-155468721.jpg
230	https://polandgroups.pl/price/backend/uploads/categories/photos/katalog-print-wood-art-&-loft(1)_page-0032--1761579178677-266356540.jpg	32	t	26	2025-10-27 17:32:58.689418	2025-10-27 17:37:23.222395	katalog-print-wood-art-&-loft(1)_page-0032--1761579178677-266356540.jpg
229	https://polandgroups.pl/price/backend/uploads/categories/photos/katalog-print-wood-art-&-loft(1)_page-0031--1761579172812-198792469.jpg	31	t	26	2025-10-27 17:32:52.832023	2025-10-27 17:37:24.338581	katalog-print-wood-art-&-loft(1)_page-0031--1761579172812-198792469.jpg
228	https://polandgroups.pl/price/backend/uploads/categories/photos/katalog-print-wood-art-&-loft(1)_page-0030--1761579071680-936858558.jpg	30	t	26	2025-10-27 17:31:11.713979	2025-10-27 17:37:25.324985	katalog-print-wood-art-&-loft(1)_page-0030--1761579071680-936858558.jpg
227	https://polandgroups.pl/price/backend/uploads/categories/photos/katalog-print-wood-art-&-loft(1)_page-0029--1761579030445-792331280.jpg	29	t	26	2025-10-27 17:30:30.458608	2025-10-27 17:37:26.514102	katalog-print-wood-art-&-loft(1)_page-0029--1761579030445-792331280.jpg
147	https://polandgroups.pl/price/backend/uploads/categories/photos/akcesoria-2025-5_page-0003--1756734406403-596422384.jpg	12	t	9	2025-09-01 16:46:46.419833	2025-12-16 09:03:53.52434	akcesoria-2025-5_page-0003--1756734406403-596422384.jpg
226	https://polandgroups.pl/price/backend/uploads/categories/photos/katalog-print-wood-art-&-loft(1)_page-0028--1761579020725-92622774.jpg	28	t	26	2025-10-27 17:30:20.736836	2025-10-27 17:37:27.915233	katalog-print-wood-art-&-loft(1)_page-0028--1761579020725-92622774.jpg
225	https://polandgroups.pl/price/backend/uploads/categories/photos/katalog-print-wood-art-&-loft(1)_page-0027--1761579014716-349120699.jpg	27	t	26	2025-10-27 17:30:14.726021	2025-10-27 17:37:28.727911	katalog-print-wood-art-&-loft(1)_page-0027--1761579014716-349120699.jpg
224	https://polandgroups.pl/price/backend/uploads/categories/photos/katalog-print-wood-art-&-loft(1)_page-0026--1761579011101-417800043.jpg	26	t	26	2025-10-27 17:30:11.112091	2025-10-27 17:37:29.823751	katalog-print-wood-art-&-loft(1)_page-0026--1761579011101-417800043.jpg
223	https://polandgroups.pl/price/backend/uploads/categories/photos/katalog-print-wood-art-&-loft(1)_page-0025--1761579005019-511796485.jpg	25	t	26	2025-10-27 17:30:05.029663	2025-10-27 17:37:31.122703	katalog-print-wood-art-&-loft(1)_page-0025--1761579005019-511796485.jpg
222	https://polandgroups.pl/price/backend/uploads/categories/photos/katalog-print-wood-art-&-loft(1)_page-0024--1761578996275-181875121.jpg	24	t	26	2025-10-27 17:29:56.286722	2025-10-27 17:37:31.741595	katalog-print-wood-art-&-loft(1)_page-0024--1761578996275-181875121.jpg
221	https://polandgroups.pl/price/backend/uploads/categories/photos/katalog-print-wood-art-&-loft(1)_page-0023--1761578992102-731548775.jpg	23	t	26	2025-10-27 17:29:52.113732	2025-10-27 17:37:32.92436	katalog-print-wood-art-&-loft(1)_page-0023--1761578992102-731548775.jpg
220	https://polandgroups.pl/price/backend/uploads/categories/photos/katalog-print-wood-art-&-loft(1)_page-0022--1761578985931-551776278.jpg	22	t	26	2025-10-27 17:29:45.943143	2025-10-27 17:37:33.926401	katalog-print-wood-art-&-loft(1)_page-0022--1761578985931-551776278.jpg
219	https://polandgroups.pl/price/backend/uploads/categories/photos/katalog-print-wood-art-&-loft(1)_page-0021--1761578978627-867367741.jpg	21	t	26	2025-10-27 17:29:38.649833	2025-10-27 17:37:35.752972	katalog-print-wood-art-&-loft(1)_page-0021--1761578978627-867367741.jpg
218	https://polandgroups.pl/price/backend/uploads/categories/photos/katalog-print-wood-art-&-loft(1)_page-0020--1761578968110-709205178.jpg	20	t	26	2025-10-27 17:29:28.123392	2025-10-27 17:37:36.551417	katalog-print-wood-art-&-loft(1)_page-0020--1761578968110-709205178.jpg
217	https://polandgroups.pl/price/backend/uploads/categories/photos/katalog-print-wood-art-&-loft(1)_page-0019--1761578963428-609829855.jpg	19	t	26	2025-10-27 17:29:23.441832	2025-10-27 17:37:37.6226	katalog-print-wood-art-&-loft(1)_page-0019--1761578963428-609829855.jpg
216	https://polandgroups.pl/price/backend/uploads/categories/photos/katalog-print-wood-art-&-loft(1)_page-0018--1761578959349-76111386.jpg	18	t	26	2025-10-27 17:29:19.360429	2025-10-27 17:37:38.633471	katalog-print-wood-art-&-loft(1)_page-0018--1761578959349-76111386.jpg
215	https://polandgroups.pl/price/backend/uploads/categories/photos/katalog-print-wood-art-&-loft(1)_page-0017--1761578955630-92959818.jpg	17	t	26	2025-10-27 17:29:15.650002	2025-10-27 17:37:39.829845	katalog-print-wood-art-&-loft(1)_page-0017--1761578955630-92959818.jpg
214	https://polandgroups.pl/price/backend/uploads/categories/photos/katalog-print-wood-art-&-loft(1)_page-0016--1761578940822-566145743.jpg	16	t	26	2025-10-27 17:29:00.846839	2025-10-27 17:37:40.424809	katalog-print-wood-art-&-loft(1)_page-0016--1761578940822-566145743.jpg
213	https://polandgroups.pl/price/backend/uploads/categories/photos/katalog-print-wood-art-&-loft(1)_page-0015--1761578922054-993586537.jpg	15	t	26	2025-10-27 17:28:42.077783	2025-10-27 17:37:41.750723	katalog-print-wood-art-&-loft(1)_page-0015--1761578922054-993586537.jpg
212	https://polandgroups.pl/price/backend/uploads/categories/photos/katalog-print-wood-art-&-loft(1)_page-0014--1761578908683-847218017.jpg	14	t	26	2025-10-27 17:28:28.694064	2025-10-27 17:37:42.525518	katalog-print-wood-art-&-loft(1)_page-0014--1761578908683-847218017.jpg
211	https://polandgroups.pl/price/backend/uploads/categories/photos/katalog-print-wood-art-&-loft(1)_page-0013--1761578903772-872388549.jpg	13	t	26	2025-10-27 17:28:23.790936	2025-10-27 17:37:43.918846	katalog-print-wood-art-&-loft(1)_page-0013--1761578903772-872388549.jpg
210	https://polandgroups.pl/price/backend/uploads/categories/photos/katalog-print-wood-art-&-loft(1)_page-0012--1761578889700-821514606.jpg	12	t	26	2025-10-27 17:28:09.71249	2025-10-27 17:37:44.8749	katalog-print-wood-art-&-loft(1)_page-0012--1761578889700-821514606.jpg
209	https://polandgroups.pl/price/backend/uploads/categories/photos/katalog-print-wood-art-&-loft(1)_page-0011--1761578882533-615904298.jpg	11	t	26	2025-10-27 17:28:02.549536	2025-10-27 17:37:45.534225	katalog-print-wood-art-&-loft(1)_page-0011--1761578882533-615904298.jpg
208	https://polandgroups.pl/price/backend/uploads/categories/photos/katalog-print-wood-art-&-loft(1)_page-0010--1761578876742-691901542.jpg	10	t	26	2025-10-27 17:27:56.759426	2025-10-27 17:37:46.859577	katalog-print-wood-art-&-loft(1)_page-0010--1761578876742-691901542.jpg
207	https://polandgroups.pl/price/backend/uploads/categories/photos/katalog-print-wood-art-&-loft(1)_page-0009--1761578864216-606366458.jpg	9	t	26	2025-10-27 17:27:44.238103	2025-10-27 17:37:49.222614	katalog-print-wood-art-&-loft(1)_page-0009--1761578864216-606366458.jpg
206	https://polandgroups.pl/price/backend/uploads/categories/photos/katalog-print-wood-art-&-loft(1)_page-0008--1761578857681-977166546.jpg	8	t	26	2025-10-27 17:27:37.693747	2025-10-27 17:37:50.226556	katalog-print-wood-art-&-loft(1)_page-0008--1761578857681-977166546.jpg
205	https://polandgroups.pl/price/backend/uploads/categories/photos/katalog-print-wood-art-&-loft(1)_page-0007--1761578850829-890982904.jpg	7	t	26	2025-10-27 17:27:30.841344	2025-10-27 17:37:51.641451	katalog-print-wood-art-&-loft(1)_page-0007--1761578850829-890982904.jpg
204	https://polandgroups.pl/price/backend/uploads/categories/photos/katalog-print-wood-art-&-loft(1)_page-0006--1761578846411-22835913.jpg	6	t	26	2025-10-27 17:27:26.421839	2025-10-27 17:37:52.538188	katalog-print-wood-art-&-loft(1)_page-0006--1761578846411-22835913.jpg
203	https://polandgroups.pl/price/backend/uploads/categories/photos/katalog-print-wood-art-&-loft(1)_page-0005--1761578840648-692056348.jpg	5	t	26	2025-10-27 17:27:20.668013	2025-10-27 17:37:53.837755	katalog-print-wood-art-&-loft(1)_page-0005--1761578840648-692056348.jpg
247	https://polandgroups.pl/price/backend/uploads/categories/photos/katalog-print-wood-art-&-loft(1)_page-0050--1761579415214-397532245.jpg	49	t	26	2025-10-27 17:36:55.228447	2025-10-27 17:37:04.788809	katalog-print-wood-art-&-loft(1)_page-0050--1761579415214-397532245.jpg
246	https://polandgroups.pl/price/backend/uploads/categories/photos/katalog-print-wood-art-&-loft(1)_page-0049--1761579409211-12027311.jpg	48	t	26	2025-10-27 17:36:49.218821	2025-10-27 17:37:05.52389	katalog-print-wood-art-&-loft(1)_page-0049--1761579409211-12027311.jpg
245	https://polandgroups.pl/price/backend/uploads/categories/photos/katalog-print-wood-art-&-loft(1)_page-0048--1761579404554-290885057.jpg	47	t	26	2025-10-27 17:36:44.563577	2025-10-27 17:37:06.328527	katalog-print-wood-art-&-loft(1)_page-0048--1761579404554-290885057.jpg
244	https://polandgroups.pl/price/backend/uploads/categories/photos/katalog-print-wood-art-&-loft(1)_page-0047--1761579400561-178060742.jpg	46	t	26	2025-10-27 17:36:40.574194	2025-10-27 17:37:07.924568	katalog-print-wood-art-&-loft(1)_page-0047--1761579400561-178060742.jpg
243	https://polandgroups.pl/price/backend/uploads/categories/photos/katalog-print-wood-art-&-loft(1)_page-0046--1761579396104-817912484.jpg	45	t	26	2025-10-27 17:36:36.121987	2025-10-27 17:37:08.847251	katalog-print-wood-art-&-loft(1)_page-0046--1761579396104-817912484.jpg
242	https://polandgroups.pl/price/backend/uploads/categories/photos/katalog-print-wood-art-&-loft(1)_page-0045--1761579390645-249119620.jpg	44	t	26	2025-10-27 17:36:30.662364	2025-10-27 17:37:09.940187	katalog-print-wood-art-&-loft(1)_page-0045--1761579390645-249119620.jpg
241	https://polandgroups.pl/price/backend/uploads/categories/photos/katalog-print-wood-art-&-loft(1)_page-0044--1761579378885-855380500.jpg	43	t	26	2025-10-27 17:36:18.912813	2025-10-27 17:37:10.651239	katalog-print-wood-art-&-loft(1)_page-0044--1761579378885-855380500.jpg
239	https://polandgroups.pl/price/backend/uploads/categories/photos/katalog-print-wood-art-&-loft(1)_page-0042--1761579299225-365069210.jpg	41	t	26	2025-10-27 17:34:59.415086	2025-10-27 17:37:13.124303	katalog-print-wood-art-&-loft(1)_page-0042--1761579299225-365069210.jpg
237	https://polandgroups.pl/price/backend/uploads/categories/photos/katalog-print-wood-art-&-loft(1)_page-0041--1761579230338-984037014.jpg	40	t	26	2025-10-27 17:33:50.35522	2025-10-27 17:37:14.427285	katalog-print-wood-art-&-loft(1)_page-0041--1761579230338-984037014.jpg
238	https://polandgroups.pl/price/backend/uploads/categories/photos/katalog-print-wood-art-&-loft(1)_page-0040--1761579274857-846600734.jpg	39	t	26	2025-10-27 17:34:34.881298	2025-10-27 17:37:15.61641	katalog-print-wood-art-&-loft(1)_page-0040--1761579274857-846600734.jpg
236	https://polandgroups.pl/price/backend/uploads/categories/photos/katalog-print-wood-art-&-loft(1)_page-0039--1761579218143-571322184.jpg	38	t	26	2025-10-27 17:33:38.153892	2025-10-27 17:37:17.027288	katalog-print-wood-art-&-loft(1)_page-0039--1761579218143-571322184.jpg
235	https://polandgroups.pl/price/backend/uploads/categories/photos/katalog-print-wood-art-&-loft(1)_page-0038--1761579214475-664467384.jpg	37	t	26	2025-10-27 17:33:34.488038	2025-10-27 17:37:18.022337	katalog-print-wood-art-&-loft(1)_page-0038--1761579214475-664467384.jpg
234	https://polandgroups.pl/price/backend/uploads/categories/photos/katalog-print-wood-art-&-loft(1)_page-0037--1761579208035-936358991.jpg	36	t	26	2025-10-27 17:33:28.050941	2025-10-27 17:37:19.125689	katalog-print-wood-art-&-loft(1)_page-0037--1761579208035-936358991.jpg
233	https://polandgroups.pl/price/backend/uploads/categories/photos/katalog-print-wood-art-&-loft(1)_page-0036--1761579200309-173306832.jpg	35	t	26	2025-10-27 17:33:20.334421	2025-10-27 17:37:20.224015	katalog-print-wood-art-&-loft(1)_page-0036--1761579200309-173306832.jpg
232	https://polandgroups.pl/price/backend/uploads/categories/photos/katalog-print-wood-art-&-loft(1)_page-0034--1761579190233-274349032.jpg	34	t	26	2025-10-27 17:33:10.243498	2025-10-27 17:37:21.019367	katalog-print-wood-art-&-loft(1)_page-0034--1761579190233-274349032.jpg
231	https://polandgroups.pl/price/backend/uploads/categories/photos/katalog-print-wood-art-&-loft(1)_page-0033--1761579184027-475647576.jpg	33	t	26	2025-10-27 17:33:04.039045	2025-10-27 17:37:22.121316	katalog-print-wood-art-&-loft(1)_page-0033--1761579184027-475647576.jpg
248	https://polandgroups.pl/price/backend/uploads/categories/photos/katalog-plikã³w-gwiazdiste-niebo-001-005(3)--1761582127544-145520361.jpg	1	t	27	2025-10-27 18:22:07.560407	2025-10-27 18:22:20.523219	katalog-plikã³w-gwiazdiste-niebo-001-005(3)--1761582127544-145520361.jpg
251	https://polandgroups.pl/price/backend/uploads/categories/photos/katalog-plikã³w-kosmos-planety-016-020--1761582197444-994411986.jpg	4	t	27	2025-10-27 18:23:17.466532	2025-10-27 18:23:22.965893	katalog-plikã³w-kosmos-planety-016-020--1761582197444-994411986.jpg
250	https://polandgroups.pl/price/backend/uploads/categories/photos/katalog-plikã³w-gwiazdiste-niebo-011-015-1--1761582157669-236823147.jpg	3	t	27	2025-10-27 18:22:37.686462	2025-10-27 18:23:24.325532	katalog-plikã³w-gwiazdiste-niebo-011-015-1--1761582157669-236823147.jpg
249	https://polandgroups.pl/price/backend/uploads/categories/photos/katalog-plikã³w-gwiazdiste-niebo-005-010-1--1761582149984-583077769.jpg	2	t	27	2025-10-27 18:22:30.007288	2025-10-27 18:23:27.423316	katalog-plikã³w-gwiazdiste-niebo-005-010-1--1761582149984-583077769.jpg
252	https://polandgroups.pl/price/backend/uploads/categories/photos/katalog-plikã³w-kosmos-planety-021-025--1761582202951-391034323.jpg	5	t	27	2025-10-27 18:23:22.980575	2025-10-27 18:23:27.528158	katalog-plikã³w-kosmos-planety-021-025--1761582202951-391034323.jpg
253	https://polandgroups.pl/price/backend/uploads/categories/photos/katalog-plikã³w-kosmos-planety-026-030--1761582294399-677990939.jpg	6	t	27	2025-10-27 18:24:54.431972	2025-10-27 18:24:58.428685	katalog-plikã³w-kosmos-planety-026-030--1761582294399-677990939.jpg
256	https://polandgroups.pl/price/backend/uploads/categories/photos/katalog-plikã³w-niebo-041-045--1761582337106-183785305.jpg	9	t	27	2025-10-27 18:25:37.114987	2025-10-27 18:28:32.382006	katalog-plikã³w-niebo-041-045--1761582337106-183785305.jpg
254	https://polandgroups.pl/price/backend/uploads/categories/photos/katalog-plikã³w-niebo-031-035--1761582324585-163669810.jpg	7	t	27	2025-10-27 18:25:24.613231	2025-10-27 18:28:32.43311	katalog-plikã³w-niebo-031-035--1761582324585-163669810.jpg
255	https://polandgroups.pl/price/backend/uploads/categories/photos/katalog-plikã³w-niebo-036-040--1761582331313-898977087.jpg	8	t	27	2025-10-27 18:25:31.340121	2025-10-27 18:28:33.088895	katalog-plikã³w-niebo-036-040--1761582331313-898977087.jpg
260	https://polandgroups.pl/price/backend/uploads/categories/photos/katalog-plikã³w-kwiaty-061-065--1761582667541-246668433.jpg	13	t	27	2025-10-27 18:31:07.562309	2025-10-27 18:31:13.147944	katalog-plikã³w-kwiaty-061-065--1761582667541-246668433.jpg
261	https://polandgroups.pl/price/backend/uploads/categories/photos/katalog-plikã³w-kwiaty-066-070--1761582672278-177457071.jpg	14	t	27	2025-10-27 18:31:12.293852	2025-10-27 18:31:16.625651	katalog-plikã³w-kwiaty-066-070--1761582672278-177457071.jpg
289	https://polandgroups.pl/price/backend/uploads/categories/photos/1-(26)--1761584554417-83786368.JPG	26	t	28	2025-10-27 19:02:34.427784	2025-10-27 19:03:53.937606	1-(26)--1761584554417-83786368.JPG
291	https://polandgroups.pl/price/backend/uploads/categories/photos/1-(28)--1761584565067-571935948.JPG	28	t	28	2025-10-27 19:02:45.080415	2025-10-27 19:03:57.214186	1-(28)--1761584565067-571935948.JPG
288	https://polandgroups.pl/price/backend/uploads/categories/photos/1-(25)--1761584552570-518707664.JPG	25	t	28	2025-10-27 19:02:32.612325	2025-10-27 19:03:58.018948	1-(25)--1761584552570-518707664.JPG
286	https://polandgroups.pl/price/backend/uploads/categories/photos/1-(23)--1761584537563-336097890.JPG	23	t	28	2025-10-27 19:02:17.572963	2025-10-27 19:04:03.018591	1-(23)--1761584537563-336097890.JPG
285	https://polandgroups.pl/price/backend/uploads/categories/photos/1-(22)--1761584532822-505031164.JPG	22	t	28	2025-10-27 19:02:12.837701	2025-10-27 19:04:06.013962	1-(22)--1761584532822-505031164.JPG
284	https://polandgroups.pl/price/backend/uploads/categories/photos/1-(21)--1761584518975-644612346.JPG	21	t	28	2025-10-27 19:01:58.983263	2025-10-27 19:04:10.52018	1-(21)--1761584518975-644612346.JPG
283	https://polandgroups.pl/price/backend/uploads/categories/photos/1-(20)--1761584515250-319051574.JPG	20	t	28	2025-10-27 19:01:55.269352	2025-10-27 19:04:11.415536	1-(20)--1761584515250-319051574.JPG
282	https://polandgroups.pl/price/backend/uploads/categories/photos/1-(19)--1761584490631-703016572.JPG	19	t	28	2025-10-27 19:01:30.641156	2025-10-27 19:04:12.267058	1-(19)--1761584490631-703016572.JPG
281	https://polandgroups.pl/price/backend/uploads/categories/photos/1-(18)--1761584485758-453602827.JPG	18	t	28	2025-10-27 19:01:25.767013	2025-10-27 19:04:13.317114	1-(18)--1761584485758-453602827.JPG
280	https://polandgroups.pl/price/backend/uploads/categories/photos/1-(17)--1761584480176-715306300.JPG	17	t	28	2025-10-27 19:01:20.194126	2025-10-27 19:04:14.417684	1-(17)--1761584480176-715306300.JPG
279	https://polandgroups.pl/price/backend/uploads/categories/photos/1-(16)--1761584468640-562067445.JPG	16	t	28	2025-10-27 19:01:08.649738	2025-10-27 19:04:15.712123	1-(16)--1761584468640-562067445.JPG
278	https://polandgroups.pl/price/backend/uploads/categories/photos/1-(15)--1761584463332-119830713.JPG	15	t	28	2025-10-27 19:01:03.342575	2025-10-27 19:04:16.917135	1-(15)--1761584463332-119830713.JPG
277	https://polandgroups.pl/price/backend/uploads/categories/photos/1-(14)--1761584458192-911184826.JPG	14	t	28	2025-10-27 19:00:58.22081	2025-10-27 19:04:18.318357	1-(14)--1761584458192-911184826.JPG
276	https://polandgroups.pl/price/backend/uploads/categories/photos/1-(13)--1761584446692-92551971.JPG	13	t	28	2025-10-27 19:00:46.705243	2025-10-27 19:04:18.837196	1-(13)--1761584446692-92551971.JPG
275	https://polandgroups.pl/price/backend/uploads/categories/photos/1-(12)--1761584441597-672944396.JPG	12	t	28	2025-10-27 19:00:41.61409	2025-10-27 19:04:20.7126	1-(12)--1761584441597-672944396.JPG
274	https://polandgroups.pl/price/backend/uploads/categories/photos/1-(11)--1761584437016-560744789.JPG	11	t	28	2025-10-27 19:00:37.027845	2025-10-27 19:04:21.516559	1-(11)--1761584437016-560744789.JPG
273	https://polandgroups.pl/price/backend/uploads/categories/photos/1-(10)--1761584432223-619833813.JPG	10	t	28	2025-10-27 19:00:32.234257	2025-10-27 19:04:22.442273	1-(10)--1761584432223-619833813.JPG
272	https://polandgroups.pl/price/backend/uploads/categories/photos/1-(9)--1761584427719-162986100.JPG	9	t	28	2025-10-27 19:00:27.727738	2025-10-27 19:04:24.21374	1-(9)--1761584427719-162986100.JPG
271	https://polandgroups.pl/price/backend/uploads/categories/photos/1-(8)--1761584422442-336266247.JPG	8	t	28	2025-10-27 19:00:22.450432	2025-10-27 19:04:25.453052	1-(8)--1761584422442-336266247.JPG
269	https://polandgroups.pl/price/backend/uploads/categories/photos/1-(6)--1761584412598-68134260.JPG	6	t	28	2025-10-27 19:00:12.61522	2025-10-27 19:04:28.417471	1-(6)--1761584412598-68134260.JPG
270	https://polandgroups.pl/price/backend/uploads/categories/photos/1-(7)--1761584416923-994980548.JPG	7	t	28	2025-10-27 19:00:16.929912	2025-10-27 19:04:30.815919	1-(7)--1761584416923-994980548.JPG
265	https://polandgroups.pl/price/backend/uploads/categories/photos/1-(2)--1761584392679-259332366.JPG	2	t	28	2025-10-27 18:59:52.688366	2025-10-27 19:04:31.93807	1-(2)--1761584392679-259332366.JPG
268	https://polandgroups.pl/price/backend/uploads/categories/photos/1-(5)--1761584407650-152563030.JPG	5	t	28	2025-10-27 19:00:07.659477	2025-10-27 19:04:33.421776	1-(5)--1761584407650-152563030.JPG
266	https://polandgroups.pl/price/backend/uploads/categories/photos/1-(3)--1761584397523-985801474.JPG	3	t	28	2025-10-27 18:59:57.534695	2025-10-27 19:04:33.716747	1-(3)--1761584397523-985801474.JPG
264	https://polandgroups.pl/price/backend/uploads/categories/photos/1-(1)--1761584386418-620959388.JPG	1	t	28	2025-10-27 18:59:46.442283	2025-10-27 19:04:34.815646	1-(1)--1761584386418-620959388.JPG
267	https://polandgroups.pl/price/backend/uploads/categories/photos/1-(4)--1761584402754-685361989.JPG	4	t	28	2025-10-27 19:00:02.769165	2025-10-27 19:04:36.421733	1-(4)--1761584402754-685361989.JPG
293	https://polandgroups.pl/price/backend/uploads/categories/photos/1-(31)--1761584579899-538687464.JPG	31	t	28	2025-10-27 19:02:59.909588	2025-10-27 19:03:48.520408	1-(31)--1761584579899-538687464.JPG
292	https://polandgroups.pl/price/backend/uploads/categories/photos/1-(30)--1761584574697-890620059.JPG	30	t	28	2025-10-27 19:02:54.70795	2025-10-27 19:03:49.812314	1-(30)--1761584574697-890620059.JPG
290	https://polandgroups.pl/price/backend/uploads/categories/photos/1-(27)--1761584559618-998250178.JPG	27	t	28	2025-10-27 19:02:39.626922	2025-10-27 19:03:53.924641	1-(27)--1761584559618-998250178.JPG
294	https://polandgroups.pl/price/backend/uploads/categories/photos/1-(29)--1761584601702-915013850.JPG	29	t	28	2025-10-27 19:03:21.722592	2025-10-27 19:03:57.818899	1-(29)--1761584601702-915013850.JPG
287	https://polandgroups.pl/price/backend/uploads/categories/photos/1-(24)--1761584542376-569295439.JPG	24	t	28	2025-10-27 19:02:22.384903	2025-10-27 19:03:58.01952	1-(24)--1761584542376-569295439.JPG
300	https://polandgroups.pl/price/backend/uploads/categories/photos/katalog-profil-new-2--1763985839808-270680342.jpg	13	t	11	2025-11-24 14:03:59.830897	2025-11-24 14:05:44.231658	katalog-profil-new-2--1763985839808-270680342.jpg
135	https://polandgroups.pl/price/backend/uploads/categories/photos/21--1755756165050-271645873.JPG	20	t	11	2025-08-21 09:02:45.065049	2025-11-24 14:07:41.21	21--1755756165050-271645873.JPG
296	https://polandgroups.pl/price/backend/uploads/categories/photos/maket-trek-3--1763984220211-161406110.jpg	4	t	22	2025-11-24 13:37:00.228224	2025-11-24 13:42:40.036806	maket-trek-3--1763984220211-161406110.jpg
303	https://polandgroups.pl/price/backend/uploads/categories/photos/katalog-profil-new-5--1763986396742-45533859.jpg	26	t	11	2025-11-24 14:13:16.814688	2025-11-24 14:16:26.180693	katalog-profil-new-5--1763986396742-45533859.jpg
176	https://polandgroups.pl/price/backend/uploads/categories/photos/20--1756736925429-801174540.jpg	22	t	22	2025-09-01 17:28:45.443562	2025-11-24 13:44:35.92963	20--1756736925429-801174540.jpg
177	https://polandgroups.pl/price/backend/uploads/categories/photos/21--1756736930144-588124065.JPG	23	t	22	2025-09-01 17:28:50.156079	2025-11-24 13:44:35.934732	21--1756736930144-588124065.JPG
298	https://polandgroups.pl/price/backend/uploads/categories/photos/maket-trek-1--1763984236726-603519481.jpg	17	t	22	2025-11-24 13:37:16.754218	2025-11-24 13:45:05.03692	maket-trek-1--1763984236726-603519481.jpg
295	https://polandgroups.pl/price/backend/uploads/categories/photos/maket-trek-2--1763984210916-973448446.jpg	3	t	22	2025-11-24 13:36:50.983039	2025-11-24 13:45:17.813813	maket-trek-2--1763984210916-973448446.jpg
162	https://polandgroups.pl/price/backend/uploads/categories/photos/6--1756736834286-971765418.JPG	6	t	22	2025-09-01 17:27:14.296688	2025-11-24 13:42:53.031196	6--1756736834286-971765418.JPG
166	https://polandgroups.pl/price/backend/uploads/categories/photos/10--1756736859604-521499465.JPG	10	t	22	2025-09-01 17:27:39.615029	2025-11-24 13:43:00.492524	10--1756736859604-521499465.JPG
169	https://polandgroups.pl/price/backend/uploads/categories/photos/13--1756736875127-75312948.JPG	13	t	22	2025-09-01 17:27:55.138649	2025-11-24 13:43:05.568681	13--1756736875127-75312948.JPG
297	https://polandgroups.pl/price/backend/uploads/categories/photos/maket-trek-4--1763984224505-917332200.jpg	4	t	22	2025-11-24 13:37:04.523513	2025-11-24 13:45:20.235536	maket-trek-4--1763984224505-917332200.jpg
170	https://polandgroups.pl/price/backend/uploads/categories/photos/14--1756736888667-525098288.JPG	14	t	22	2025-09-01 17:28:08.697015	2025-11-24 13:43:07.145588	14--1756736888667-525098288.JPG
134	https://polandgroups.pl/price/backend/uploads/categories/photos/20--1755756159508-389794338.JPG	19	t	11	2025-08-21 09:02:39.526144	2025-11-24 14:07:41.223	20--1755756159508-389794338.JPG
179	https://polandgroups.pl/price/backend/uploads/categories/photos/23--1756736941137-597439860.JPG	24	t	22	2025-09-01 17:29:01.148506	2025-11-24 13:41:07.998687	23--1756736941137-597439860.JPG
304	https://polandgroups.pl/price/backend/uploads/categories/photos/katalog-profil-new-6--1763986488358-326532976.jpg	27	t	11	2025-11-24 14:14:48.379032	2025-11-24 14:16:28.235989	katalog-profil-new-6--1763986488358-326532976.jpg
302	https://polandgroups.pl/price/backend/uploads/categories/photos/katalog-profil-new-4--1763986327977-483377814.jpg	25	t	11	2025-11-24 14:12:08.002567	2025-11-24 14:13:55.563384	katalog-profil-new-4--1763986327977-483377814.jpg
299	https://polandgroups.pl/price/backend/uploads/categories/photos/katalog-profil-new-1--1763985725317-588308919.jpg	12	t	11	2025-11-24 14:02:05.348508	2025-11-24 14:03:45.240212	katalog-profil-new-1--1763985725317-588308919.jpg
301	https://polandgroups.pl/price/backend/uploads/categories/photos/katalog-profil-new-3--1763986018973-753959068.jpg	15	t	11	2025-11-24 14:06:58.993048	2025-11-24 14:08:23.366626	katalog-profil-new-3--1763986018973-753959068.jpg
305	https://polandgroups.pl/price/backend/uploads/categories/photos/katalog-profil-new-7--1763986624640-244592357.jpg	28	t	11	2025-11-24 14:17:04.665953	2025-11-24 14:17:13.897585	katalog-profil-new-7--1763986624640-244592357.jpg
329	https://polandgroups.pl/price/backend/uploads/categories/photos/3-(1)--1765266638307-407075706.JPG	1	t	32	2025-12-09 09:50:38.341471	2025-12-09 09:51:07.6302	3-(1)--1765266638307-407075706.JPG
330	https://polandgroups.pl/price/backend/uploads/categories/photos/3-(2)--1765266645411-414969596.JPG	2	t	32	2025-12-09 09:50:45.437571	2025-12-09 09:51:08.432635	3-(2)--1765266645411-414969596.JPG
315	https://polandgroups.pl/price/backend/uploads/categories/photos/1-(1)--1765258798953-54803933.JPG	5	t	9	2025-12-09 07:39:58.973276	2025-12-09 08:01:29.546564	1-(1)--1765258798953-54803933.JPG
332	https://polandgroups.pl/price/backend/uploads/categories/photos/3-(4)--1765266665044-387115472.JPG	3	t	32	2025-12-09 09:51:05.05393	2025-12-16 08:56:20.087723	3-(4)--1765266665044-387115472.JPG
155	https://polandgroups.pl/price/backend/uploads/categories/photos/akcesoria-2025-5_page-0011--1756734531049-955168585.jpg	23	t	9	2025-09-01 16:48:51.059385	2025-12-16 09:05:07.329379	akcesoria-2025-5_page-0011--1756734531049-955168585.jpg
153	https://polandgroups.pl/price/backend/uploads/categories/photos/akcesoria-2025-5_page-0009--1756734513476-881189439.jpg	22	t	9	2025-09-01 16:48:33.486044	2025-12-16 09:05:07.342144	akcesoria-2025-5_page-0009--1756734513476-881189439.jpg
148	https://polandgroups.pl/price/backend/uploads/categories/photos/akcesoria-2025-5_page-0004--1756734442332-88170028.jpg	16	t	9	2025-09-01 16:47:22.352103	2025-12-16 09:05:09.575818	akcesoria-2025-5_page-0004--1756734442332-88170028.jpg
333	https://polandgroups.pl/price/backend/uploads/categories/photos/3-(1)--1765268713708-230925516.JPG	9	t	9	2025-12-09 10:25:13.752204	2025-12-16 09:03:32.003	3-(1)--1765268713708-230925516.JPG
151	https://polandgroups.pl/price/backend/uploads/categories/photos/akcesoria-2025-5_page-0007--1756734492030-369710390.jpg	14	t	9	2025-09-01 16:48:12.040088	2025-12-16 09:03:53.416	akcesoria-2025-5_page-0007--1756734492030-369710390.jpg
336	https://polandgroups.pl/price/backend/uploads/categories/photos/3-(4)--1765268733079-992566310.JPG	8	t	9	2025-12-09 10:25:33.102422	2025-12-16 09:03:53.511348	3-(4)--1765268733079-992566310.JPG
145	https://polandgroups.pl/price/backend/uploads/categories/photos/akcesoria-2025-5_page-0001--1756734353248-310015549.jpg	11	t	9	2025-09-01 16:45:53.265038	2025-12-16 09:04:10.576173	akcesoria-2025-5_page-0001--1756734353248-310015549.jpg
334	https://polandgroups.pl/price/backend/uploads/categories/photos/3-(2)--1765268719481-591658808.JPG	10	t	9	2025-12-09 10:25:19.539314	2025-12-16 09:04:40.89997	3-(2)--1765268719481-591658808.JPG
348	http://localhost/uploads/categories/photos/screenshot-2025-12-20-011304--1768054041904-562689076.png	12	f	10	2026-01-10 14:07:21.91171	2026-01-10 14:07:21.91171	screenshot-2025-12-20-011304--1768054041904-562689076.png
\.


--
-- Data for Name: site_entity; Type: TABLE DATA; Schema: public; Owner: myuser
--

COPY public.site_entity (id, code, name, active) FROM stdin;
1	pl	Polska	t
\.


--
-- Data for Name: user_entity; Type: TABLE DATA; Schema: public; Owner: myuser
--

COPY public.user_entity (id, email, password, name, role) FROM stdin;
1	elekriki_user_price	$2b$10$ulf.4ujx0iHybhflpzpgvepBzf5QSOPSgnbqp0d//thf2aACKcK72	\N	default
2	polanggroupcennik@gmail.com	$2b$10$Y7pTE.UT0BYVO.ZCwTG.jepqKsVYyjUNslIxLq8Y7Tx.iYJLlBXU2	\N	default
3	polanggroupcennik1@gmail.com	$2b$10$qtkYGWPx7i4M0Lxjv6aMeuTQK5gDnnXGvzyakIuBAmmKvGRPIGhyC	\N	admin
\.


--
-- Name: category_entity_id_seq; Type: SEQUENCE SET; Schema: public; Owner: myuser
--

SELECT pg_catalog.setval('public.category_entity_id_seq', 32, true);


--
-- Name: photo_entity_id_seq; Type: SEQUENCE SET; Schema: public; Owner: myuser
--

SELECT pg_catalog.setval('public.photo_entity_id_seq', 348, true);


--
-- Name: site_entity_id_seq; Type: SEQUENCE SET; Schema: public; Owner: myuser
--

SELECT pg_catalog.setval('public.site_entity_id_seq', 1, true);


--
-- Name: user_entity_id_seq; Type: SEQUENCE SET; Schema: public; Owner: myuser
--

SELECT pg_catalog.setval('public.user_entity_id_seq', 3, true);


--
-- Name: category_entity PK_1a38b9007ed8afab85026703a53; Type: CONSTRAINT; Schema: public; Owner: myuser
--

ALTER TABLE ONLY public.category_entity
    ADD CONSTRAINT "PK_1a38b9007ed8afab85026703a53" PRIMARY KEY (id);


--
-- Name: category_entity_closure PK_58e925551dfa6f9e027a1bfcdd4; Type: CONSTRAINT; Schema: public; Owner: myuser
--

ALTER TABLE ONLY public.category_entity_closure
    ADD CONSTRAINT "PK_58e925551dfa6f9e027a1bfcdd4" PRIMARY KEY (id_ancestor, id_descendant);


--
-- Name: user_entity PK_b54f8ea623b17094db7667d8206; Type: CONSTRAINT; Schema: public; Owner: myuser
--

ALTER TABLE ONLY public.user_entity
    ADD CONSTRAINT "PK_b54f8ea623b17094db7667d8206" PRIMARY KEY (id);


--
-- Name: site_entity PK_e2d60fc6a86778e0435cc771a3f; Type: CONSTRAINT; Schema: public; Owner: myuser
--

ALTER TABLE ONLY public.site_entity
    ADD CONSTRAINT "PK_e2d60fc6a86778e0435cc771a3f" PRIMARY KEY (id);


--
-- Name: photo_entity PK_e3a5807b27c3b7e1f36c9e65fac; Type: CONSTRAINT; Schema: public; Owner: myuser
--

ALTER TABLE ONLY public.photo_entity
    ADD CONSTRAINT "PK_e3a5807b27c3b7e1f36c9e65fac" PRIMARY KEY (id);


--
-- Name: user_entity UQ_415c35b9b3b6fe45a3b065030f5; Type: CONSTRAINT; Schema: public; Owner: myuser
--

ALTER TABLE ONLY public.user_entity
    ADD CONSTRAINT "UQ_415c35b9b3b6fe45a3b065030f5" UNIQUE (email);


--
-- Name: category_entity UQ_4bd5a4afa26650f75346238811b; Type: CONSTRAINT; Schema: public; Owner: myuser
--

ALTER TABLE ONLY public.category_entity
    ADD CONSTRAINT "UQ_4bd5a4afa26650f75346238811b" UNIQUE (slug);


--
-- Name: site_entity UQ_bce765ca5dc4358c1bc2ada2414; Type: CONSTRAINT; Schema: public; Owner: myuser
--

ALTER TABLE ONLY public.site_entity
    ADD CONSTRAINT "UQ_bce765ca5dc4358c1bc2ada2414" UNIQUE (code);


--
-- Name: IDX_752604257abad6b83f2356fdc1; Type: INDEX; Schema: public; Owner: myuser
--

CREATE INDEX "IDX_752604257abad6b83f2356fdc1" ON public.category_entity_closure USING btree (id_descendant);


--
-- Name: IDX_dd88b339486553858785284d12; Type: INDEX; Schema: public; Owner: myuser
--

CREATE INDEX "IDX_dd88b339486553858785284d12" ON public.category_entity_closure USING btree (id_ancestor);


--
-- Name: category_entity FK_46b346a8e5c9084767af11bcd4f; Type: FK CONSTRAINT; Schema: public; Owner: myuser
--

ALTER TABLE ONLY public.category_entity
    ADD CONSTRAINT "FK_46b346a8e5c9084767af11bcd4f" FOREIGN KEY ("parentId") REFERENCES public.category_entity(id);


--
-- Name: photo_entity FK_47d31be9bcaadad96974a315502; Type: FK CONSTRAINT; Schema: public; Owner: myuser
--

ALTER TABLE ONLY public.photo_entity
    ADD CONSTRAINT "FK_47d31be9bcaadad96974a315502" FOREIGN KEY ("categoryId") REFERENCES public.category_entity(id) ON DELETE CASCADE;


--
-- Name: category_entity_closure FK_752604257abad6b83f2356fdc11; Type: FK CONSTRAINT; Schema: public; Owner: myuser
--

ALTER TABLE ONLY public.category_entity_closure
    ADD CONSTRAINT "FK_752604257abad6b83f2356fdc11" FOREIGN KEY (id_descendant) REFERENCES public.category_entity(id) ON DELETE CASCADE;


--
-- Name: category_entity FK_81fec5da6c6c42311fd9cad9028; Type: FK CONSTRAINT; Schema: public; Owner: myuser
--

ALTER TABLE ONLY public.category_entity
    ADD CONSTRAINT "FK_81fec5da6c6c42311fd9cad9028" FOREIGN KEY ("siteId") REFERENCES public.site_entity(id) ON DELETE SET NULL;


--
-- Name: category_entity_closure FK_dd88b339486553858785284d12e; Type: FK CONSTRAINT; Schema: public; Owner: myuser
--

ALTER TABLE ONLY public.category_entity_closure
    ADD CONSTRAINT "FK_dd88b339486553858785284d12e" FOREIGN KEY (id_ancestor) REFERENCES public.category_entity(id) ON DELETE CASCADE;


--
-- PostgreSQL database dump complete
--

\unrestrict gVY3iWc2653LDopA5rfd3c6LLSRAcqhjzlaxDMPSSwdDTQLscoDfYgsDfU5fO4W

