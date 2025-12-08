--
-- PostgreSQL database dump
--

\restrict ndZ9eUyQD6NdA0zUBCdboj8ZYEFufKVsDWOi3hH5gUx1g7eYUa0J3df4mPqm7mQ

-- Dumped from database version 16.11
-- Dumped by pg_dump version 16.11

-- Started on 2025-12-06 17:28:03

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

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 219 (class 1259 OID 16418)
-- Name: login_session; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.login_session (
    session_id bigint NOT NULL,
    mobile character varying(15) NOT NULL,
    otp character varying(6) NOT NULL,
    is_verified boolean DEFAULT false,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    expires_at timestamp without time zone NOT NULL,
    attempts integer DEFAULT 0
);


ALTER TABLE public.login_session OWNER TO postgres;

--
-- TOC entry 218 (class 1259 OID 16417)
-- Name: login_session_session_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.login_session ALTER COLUMN session_id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.login_session_session_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 215 (class 1259 OID 16398)
-- Name: product; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.product (
    id integer NOT NULL,
    product_name character varying(100)[]
);


ALTER TABLE public.product OWNER TO postgres;

--
-- TOC entry 221 (class 1259 OID 16426)
-- Name: user_tokens; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.user_tokens (
    token_id bigint NOT NULL,
    user_id bigint,
    device_id character varying(255) NOT NULL,
    jwt_token character varying(500) NOT NULL,
    refresh_token character varying(500) NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    expires_at timestamp without time zone,
    status character varying(20) DEFAULT 'ACTIVE'::character varying,
    last_used_at timestamp without time zone
);


ALTER TABLE public.user_tokens OWNER TO postgres;

--
-- TOC entry 220 (class 1259 OID 16425)
-- Name: user_tokens_token_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.user_tokens ALTER COLUMN token_id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.user_tokens_token_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 217 (class 1259 OID 16406)
-- Name: users; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.users (
    user_id bigint NOT NULL,
    full_name character varying(100) NOT NULL,
    email character varying(120),
    mobile character varying(15),
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    is_active boolean DEFAULT true,
    updated_at timestamp without time zone DEFAULT now()
);


ALTER TABLE public.users OWNER TO postgres;

--
-- TOC entry 216 (class 1259 OID 16405)
-- Name: users_user_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.users_user_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.users_user_id_seq OWNER TO postgres;

--
-- TOC entry 4931 (class 0 OID 0)
-- Dependencies: 216
-- Name: users_user_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.users_user_id_seq OWNED BY public.users.user_id;


--
-- TOC entry 4749 (class 2604 OID 16409)
-- Name: users user_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users ALTER COLUMN user_id SET DEFAULT nextval('public.users_user_id_seq'::regclass);


--
-- TOC entry 4923 (class 0 OID 16418)
-- Dependencies: 219
-- Data for Name: login_session; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.login_session (session_id, mobile, otp, is_verified, created_at, expires_at, attempts) FROM stdin;
\.


--
-- TOC entry 4919 (class 0 OID 16398)
-- Dependencies: 215
-- Data for Name: product; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.product (id, product_name) FROM stdin;
\.


--
-- TOC entry 4925 (class 0 OID 16426)
-- Dependencies: 221
-- Data for Name: user_tokens; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.user_tokens (token_id, user_id, device_id, jwt_token, refresh_token, created_at, expires_at, status, last_used_at) FROM stdin;
\.


--
-- TOC entry 4921 (class 0 OID 16406)
-- Dependencies: 217
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.users (user_id, full_name, email, mobile, created_at, is_active, updated_at) FROM stdin;
\.


--
-- TOC entry 4932 (class 0 OID 0)
-- Dependencies: 218
-- Name: login_session_session_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.login_session_session_id_seq', 1, false);


--
-- TOC entry 4933 (class 0 OID 0)
-- Dependencies: 220
-- Name: user_tokens_token_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.user_tokens_token_id_seq', 1, false);


--
-- TOC entry 4934 (class 0 OID 0)
-- Dependencies: 216
-- Name: users_user_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.users_user_id_seq', 1, false);


--
-- TOC entry 4769 (class 2606 OID 16424)
-- Name: login_session login_session_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.login_session
    ADD CONSTRAINT login_session_pkey PRIMARY KEY (session_id);


--
-- TOC entry 4759 (class 2606 OID 16404)
-- Name: product product_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product
    ADD CONSTRAINT product_pkey PRIMARY KEY (id);


--
-- TOC entry 4772 (class 2606 OID 16434)
-- Name: user_tokens user_tokens_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_tokens
    ADD CONSTRAINT user_tokens_pkey PRIMARY KEY (token_id);


--
-- TOC entry 4774 (class 2606 OID 16436)
-- Name: user_tokens user_tokens_user_id_device_id_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_tokens
    ADD CONSTRAINT user_tokens_user_id_device_id_key UNIQUE (user_id, device_id);


--
-- TOC entry 4762 (class 2606 OID 16414)
-- Name: users users_email_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_key UNIQUE (email);


--
-- TOC entry 4764 (class 2606 OID 16416)
-- Name: users users_mobile_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_mobile_key UNIQUE (mobile);


--
-- TOC entry 4766 (class 2606 OID 16412)
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (user_id);


--
-- TOC entry 4767 (class 1259 OID 16446)
-- Name: idx_login_session_mobile; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_login_session_mobile ON public.login_session USING btree (mobile);


--
-- TOC entry 4770 (class 1259 OID 16447)
-- Name: idx_user_tokens_user; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_user_tokens_user ON public.user_tokens USING btree (user_id);


--
-- TOC entry 4760 (class 1259 OID 16445)
-- Name: idx_users_mobile; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_users_mobile ON public.users USING btree (mobile);


--
-- TOC entry 4775 (class 2606 OID 16437)
-- Name: user_tokens user_tokens_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_tokens
    ADD CONSTRAINT user_tokens_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(user_id) ON DELETE CASCADE;


-- Completed on 2025-12-06 17:28:04

--
-- PostgreSQL database dump complete
--

\unrestrict ndZ9eUyQD6NdA0zUBCdboj8ZYEFufKVsDWOi3hH5gUx1g7eYUa0J3df4mPqm7mQ

