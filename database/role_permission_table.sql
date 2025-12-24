--
-- PostgreSQL database dump
--

--\restrict Qdi03XSr9U4p49o5vn5Gr9D52T2orgiTaSxVV7ay43B2fcFtSAUswkfeCDUgnTu

-- Dumped from database version 16.10
-- Dumped by pg_dump version 16.10

-- Started on 2025-12-24 16:19:10

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

SET default_table_access_method = heap;

--
-- TOC entry 232 (class 1259 OID 17167)
-- Name: permissions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.permissions (
    permission_id uuid DEFAULT gen_random_uuid() NOT NULL,
    permission_code character varying(100) NOT NULL,
    description character varying(255),
    created_at timestamp with time zone DEFAULT now(),
    is_active boolean DEFAULT true NOT NULL,
    updated_at timestamp with time zone
);


--
-- TOC entry 233 (class 1259 OID 17178)
-- Name: role_permissions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.role_permissions (
    role_permission_id uuid DEFAULT gen_random_uuid() NOT NULL,
    role_id uuid NOT NULL,
    permission_id uuid NOT NULL,
    created_at timestamp with time zone DEFAULT now()
);


--
-- TOC entry 231 (class 1259 OID 17156)
-- Name: roles; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.roles (
    role_id uuid DEFAULT gen_random_uuid() NOT NULL,
    role_name character varying(255) NOT NULL,
    description character varying(255),
    created_at timestamp with time zone DEFAULT now()
);


--
-- TOC entry 4989 (class 0 OID 17167)
-- Dependencies: 232
-- Data for Name: permissions; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.permissions (permission_id, permission_code, description, created_at, is_active, updated_at) FROM stdin;
0edf2ef9-8a44-4ae9-918d-850f71e10913	PRODUCT_CREATE	Create products	2025-12-21 22:18:53.79536+05:30	t	2025-12-21 22:18:53.79536+05:30
82c0be24-8d72-4c42-97e9-11b567d4e6b1	PRODUCT_UPDATE	Update products	2025-12-21 22:18:53.79536+05:30	t	2025-12-21 22:18:53.79536+05:30
b9c101d7-5f41-4b30-8979-5b0dc745ef32	PRODUCT_DELETE	Delete products	2025-12-21 22:18:53.79536+05:30	t	2025-12-21 22:18:53.79536+05:30
d4365ebe-269f-4c92-a9ac-ac5e290513a6	ORDER_VIEW	View orders	2025-12-21 22:18:53.79536+05:30	t	2025-12-21 22:18:53.79536+05:30
94c64c8e-b1dd-4ce6-ad25-d5941028d068	USER_BLOCK	Block users	2025-12-21 22:18:53.79536+05:30	t	2025-12-21 22:18:53.79536+05:30
\.


--
-- TOC entry 4990 (class 0 OID 17178)
-- Dependencies: 233
-- Data for Name: role_permissions; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.role_permissions (role_permission_id, role_id, permission_id, created_at) FROM stdin;
21647649-18df-41a4-b534-2341a1111465	7e540a8f-6888-4323-bf43-5bfb0fa2e234	0edf2ef9-8a44-4ae9-918d-850f71e10913	2025-12-21 22:19:10.582863+05:30
e65bd930-24dd-4b22-a03b-6e25bcd096d6	7e540a8f-6888-4323-bf43-5bfb0fa2e234	82c0be24-8d72-4c42-97e9-11b567d4e6b1	2025-12-21 22:19:10.582863+05:30
1c0b4d27-2e5f-4517-877f-0fe19e1840d2	7e540a8f-6888-4323-bf43-5bfb0fa2e234	d4365ebe-269f-4c92-a9ac-ac5e290513a6	2025-12-21 22:19:10.582863+05:30
\.


--
-- TOC entry 4988 (class 0 OID 17156)
-- Dependencies: 231
-- Data for Name: roles; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.roles (role_id, role_name, description, created_at) FROM stdin;
7e540a8f-6888-4323-bf43-5bfb0fa2e234	ADMIN	Standard admin	2025-12-21 22:18:22.891166+05:30
5354dbf2-6ec4-49d6-be66-2ac126f6bbfb	SUPER_ADMIN	Full system access	2025-12-21 22:18:22.891166+05:30
\.


--
-- TOC entry 4834 (class 2606 OID 17218)
-- Name: permissions permissions_code_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.permissions
    ADD CONSTRAINT permissions_code_key UNIQUE (permission_code);


--
-- TOC entry 4836 (class 2606 OID 17177)
-- Name: permissions permissions_permission_code_key; Type: CONSTRAINT; Schema: public; Owner: -
--

-- ALTER TABLE ONLY public.permissions
   -- ADD CONSTRAINT permissions_permission_code_key UNIQUE (permission_code);


--
-- TOC entry 4838 (class 2606 OID 17175)
-- Name: permissions permissions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.permissions
    ADD CONSTRAINT permissions_pkey PRIMARY KEY (permission_id);


--
-- TOC entry 4840 (class 2606 OID 17184)
-- Name: role_permissions role_permissions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.role_permissions
    ADD CONSTRAINT role_permissions_pkey PRIMARY KEY (role_permission_id);


--
-- TOC entry 4830 (class 2606 OID 17164)
-- Name: roles roles_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.roles
    ADD CONSTRAINT roles_pkey PRIMARY KEY (role_id);


--
-- TOC entry 4832 (class 2606 OID 17214)
-- Name: roles roles_role_name_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.roles
    ADD CONSTRAINT roles_role_name_key UNIQUE (role_name);


--
-- TOC entry 4842 (class 2606 OID 17186)
-- Name: role_permissions uq_role_permission; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.role_permissions
    ADD CONSTRAINT uq_role_permission UNIQUE (role_id, permission_id);


--
-- TOC entry 4843 (class 2606 OID 17192)
-- Name: role_permissions fk_permission; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.role_permissions
    ADD CONSTRAINT fk_permission FOREIGN KEY (permission_id) REFERENCES public.permissions(permission_id) ON DELETE CASCADE;


--
-- TOC entry 4844 (class 2606 OID 17187)
-- Name: role_permissions fk_role; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.role_permissions
    ADD CONSTRAINT fk_role FOREIGN KEY (role_id) REFERENCES public.roles(role_id) ON DELETE CASCADE;


-- Completed on 2025-12-24 16:19:10

--
-- PostgreSQL database dump complete
--

--\unrestrict Qdi03XSr9U4p49o5vn5Gr9D52T2orgiTaSxVV7ay43B2fcFtSAUswkfeCDUgnTu

