--
-- PostgreSQL database dump
--

\restrict ESd641rpf40vdy9oywgOhM8x5P1YvWM6Tb0xfVVBmF1ZEJei7xI62EjUl0dXPXY

-- Dumped from database version 16.10
-- Dumped by pg_dump version 16.10

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
-- Name: pgcrypto; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pgcrypto WITH SCHEMA public;


--
-- Name: EXTENSION pgcrypto; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION pgcrypto IS 'cryptographic functions';


--
-- Name: products_search_vector_trigger(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.products_search_vector_trigger() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    NEW.search_vector :=
        setweight(to_tsvector('simple', coalesce(NEW.product_name, '')), 'A') ||
        setweight(to_tsvector('simple', coalesce(NEW.short_description, '')), 'B') ||
        setweight(to_tsvector('simple', coalesce(NEW.product_description, '')), 'C') ||
        setweight(to_tsvector('simple', coalesce(NEW.search_keywords, '')), 'D');

    RETURN NEW;
END;
$$;


ALTER FUNCTION public.products_search_vector_trigger() OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: categories; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.categories (
    categorie_name character varying(120) NOT NULL,
    slug character varying(140),
    categorie_description text,
    image_url character varying(500),
    is_active boolean DEFAULT true,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    deleted_at timestamp with time zone,
    category_id uuid DEFAULT gen_random_uuid() NOT NULL,
    parent_id uuid
);


ALTER TABLE public.categories OWNER TO postgres;

--
-- Name: login_session; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.login_session (
    mobile character varying(15) NOT NULL,
    otp character varying(6) NOT NULL,
    is_verified boolean DEFAULT false,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    expires_at timestamp without time zone NOT NULL,
    attempts integer DEFAULT 0,
    session_id uuid DEFAULT gen_random_uuid() NOT NULL
);


ALTER TABLE public.login_session OWNER TO postgres;

--
-- Name: product_discounts; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.product_discounts (
    discount_percentage integer NOT NULL,
    discount_title character varying(100),
    discount_description character varying(255),
    start_date timestamp without time zone NOT NULL,
    end_date timestamp without time zone NOT NULL,
    is_active boolean DEFAULT true,
    product_discount_id uuid DEFAULT gen_random_uuid() NOT NULL,
    product_id uuid
);


ALTER TABLE public.product_discounts OWNER TO postgres;

--
-- Name: product_images; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.product_images (
    product_image_url character varying(1000) NOT NULL,
    alt_text character varying(500),
    "position" integer DEFAULT 0,
    created_at timestamp with time zone DEFAULT now(),
    media_type character varying(20) DEFAULT 'image'::character varying,
    product_image_id uuid DEFAULT gen_random_uuid() NOT NULL,
    product_id uuid,
    variant_id uuid
);


ALTER TABLE public.product_images OWNER TO postgres;

--
-- Name: product_price_history; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.product_price_history (
    old_price integer,
    new_price integer,
    changed_at timestamp with time zone DEFAULT now(),
    product_price_history_id uuid DEFAULT gen_random_uuid() NOT NULL,
    variant_id uuid,
    changed_by uuid
);


ALTER TABLE public.product_price_history OWNER TO postgres;

--
-- Name: product_stock_log; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.product_stock_log (
    change_type character varying(60),
    change_amount integer NOT NULL,
    note text,
    created_at timestamp with time zone DEFAULT now(),
    log_id uuid DEFAULT gen_random_uuid() NOT NULL,
    variant_id uuid,
    changed_by uuid
);


ALTER TABLE public.product_stock_log OWNER TO postgres;

--
-- Name: product_tags; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.product_tags (
    product_tag_uuid uuid DEFAULT gen_random_uuid(),
    product_id uuid NOT NULL,
    tag_id uuid NOT NULL
);


ALTER TABLE public.product_tags OWNER TO postgres;

--
-- Name: product_types; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.product_types (
    product_type_name character varying(120) NOT NULL,
    product_type_description text,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    product_type_id uuid DEFAULT gen_random_uuid() NOT NULL
);


ALTER TABLE public.product_types OWNER TO postgres;

--
-- Name: product_variants; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.product_variants (
    sku character varying(100) NOT NULL,
    variant_title character varying(200),
    fragrance character varying(150),
    weight_grams integer,
    size_label character varying(50),
    color character varying(50),
    burn_time_hours integer,
    price integer NOT NULL,
    mrp integer,
    stock integer DEFAULT 0,
    reserved_stock integer DEFAULT 0,
    low_stock_threshold integer DEFAULT 5,
    is_active boolean DEFAULT true,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    deleted_at timestamp with time zone,
    created_by uuid,
    updated_by uuid,
    variant_id uuid DEFAULT gen_random_uuid() NOT NULL,
    product_id uuid
);


ALTER TABLE public.product_variants OWNER TO postgres;

--
-- Name: products; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.products (
    sku_base character varying(255),
    product_name character varying(255) NOT NULL,
    slug character varying(255),
    short_description character varying(255),
    product_description text,
    brand character varying(255),
    search_keywords character varying(255),
    tags text[],
    is_active boolean DEFAULT true,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    deleted_at timestamp with time zone,
    created_by uuid,
    updated_by uuid,
    search_vector tsvector,
    product_id uuid DEFAULT gen_random_uuid() NOT NULL,
    product_type_id uuid,
    category_id uuid
);


ALTER TABLE public.products OWNER TO postgres;

--
-- Name: tags; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.tags (
    tag_name character varying(120) NOT NULL,
    created_at timestamp with time zone DEFAULT now(),
    tag_id uuid DEFAULT gen_random_uuid() NOT NULL
);


ALTER TABLE public.tags OWNER TO postgres;

--
-- Name: user_tokens; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.user_tokens (
    device_id character varying(255) NOT NULL,
    jwt_token character varying(1000) NOT NULL,
    refresh_token character varying(1000) NOT NULL,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    expires_at timestamp with time zone,
    status character varying(20) DEFAULT 'ACTIVE'::character varying,
    last_used_at timestamp with time zone,
    token_id uuid DEFAULT gen_random_uuid() NOT NULL,
    user_id uuid
);


ALTER TABLE public.user_tokens OWNER TO postgres;

--
-- Name: users; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.users (
    full_name character varying(100) NOT NULL,
    email character varying(120),
    mobile character varying(15),
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    is_active boolean DEFAULT true,
    updated_at timestamp with time zone DEFAULT now(),
    user_id uuid DEFAULT gen_random_uuid() NOT NULL,
    password_hash character varying(255),
    role character varying(255) DEFAULT 'CUSTOMER'::character varying NOT NULL,
    CONSTRAINT admin_password_required CHECK ((((role)::text <> 'ADMIN'::text) OR (password_hash IS NOT NULL)))
);


ALTER TABLE public.users OWNER TO postgres;

--
-- Name: variant_attributes; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.variant_attributes (
    attribute_name character varying(120) NOT NULL,
    attribute_value character varying(500),
    created_at timestamp with time zone DEFAULT now(),
    attribute_id uuid DEFAULT gen_random_uuid() NOT NULL,
    variant_id uuid
);


ALTER TABLE public.variant_attributes OWNER TO postgres;

--
-- Name: website_media; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.website_media (
    website_media_title character varying(150),
    website_media_type character varying(20) NOT NULL,
    website_media_url character varying(1000) NOT NULL,
    page_section character varying(100),
    alt_text character varying(300),
    is_active boolean DEFAULT true,
    "position" integer DEFAULT 1,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    website_media_id uuid DEFAULT gen_random_uuid() NOT NULL
);


ALTER TABLE public.website_media OWNER TO postgres;

--
-- Data for Name: categories; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.categories (categorie_name, slug, categorie_description, image_url, is_active, created_at, updated_at, deleted_at, category_id, parent_id) FROM stdin;
Candles	candles	All soy wax scented candles by Chamakk.	\N	t	2025-12-11 13:07:24.901166+05:30	2025-12-11 13:07:24.901166+05:30	\N	ff0ab5fd-44bf-4f56-a1f2-bdb92efd8593	\N
Wax Melts	wax-melts	Fragrance wax melts for burners.	\N	t	2025-12-11 13:07:24.901166+05:30	2025-12-11 13:07:24.901166+05:30	\N	0fc62ccc-0e90-4199-948b-db99ddefd4eb	\N
Wax Sachets	wax-sachets	Fragrance sachets for wardrobes and small spaces.	\N	t	2025-12-11 13:07:24.901166+05:30	2025-12-11 13:07:24.901166+05:30	\N	55642891-12f7-40ce-ae3b-681eae7eedc9	\N
Diffusers	diffusers	Aroma diffusers with fragrance oils.	\N	t	2025-12-11 13:07:24.901166+05:30	2025-12-11 13:07:24.901166+05:30	\N	d78e696b-48f1-47aa-b063-44b6865a3c90	\N
Tea Light Holders	tea-light-holders	Decorative tea light holders.	\N	t	2025-12-11 13:07:24.901166+05:30	2025-12-11 13:07:24.901166+05:30	\N	ce8b29ef-80fa-4b56-85fd-cf6adbe83a4b	\N
Clay Art Products	clay-art-products	Handcrafted clay products like diffusers and holders.	\N	t	2025-12-11 13:07:24.901166+05:30	2025-12-11 13:07:24.901166+05:30	\N	f5f2206b-de34-4baf-97a8-f65e40ec2275	\N
Gift Sets	gift-sets	Curated festival and occasion gift sets.	\N	t	2025-12-11 13:07:24.901166+05:30	2025-12-11 13:07:24.901166+05:30	\N	ce3957a8-5834-4739-87b8-918c8fef4157	\N
\.


--
-- Data for Name: login_session; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.login_session (mobile, otp, is_verified, created_at, expires_at, attempts, session_id) FROM stdin;
\.


--
-- Data for Name: product_discounts; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.product_discounts (discount_percentage, discount_title, discount_description, start_date, end_date, is_active, product_discount_id, product_id) FROM stdin;
5	Buy 1 Get 5% Off	Christmas festival offer: Buy 1 product and get 5% discount.	2025-12-20 00:00:00	2025-12-31 23:59:59	t	c1d9b816-1fc9-4dc4-bd60-e07451ee8581	ea3b80e2-dd3b-4ba5-8b4a-8eba14b7e1dc
5	Buy 1 Get 5% Off	Christmas festival offer: Buy 1 product and get 5% discount.	2025-12-20 00:00:00	2025-12-31 23:59:59	t	a456148b-cec0-41cf-9ebf-56188aed8363	bbc419c4-d5b4-49da-920a-67dd5868e7a1
5	Buy 1 Get 5% Off	Christmas festival offer: Buy 1 product and get 5% discount.	2025-12-20 00:00:00	2025-12-31 23:59:59	t	dcdfa1d6-06c7-4ab3-971d-5c6c39b8ad83	abcdc1d8-c0f4-4f00-bde9-fd0f17b714cb
5	Buy 1 Get 5% Off	Christmas festival offer: Buy 1 product and get 5% discount.	2025-12-20 00:00:00	2025-12-31 23:59:59	t	ec7ea27f-0b22-4fd8-bfe7-7de6b26fbd6e	160a90b6-e485-4a31-8150-306d453a3ef1
5	Buy 1 Get 5% Off	Christmas festival offer: Buy 1 product and get 5% discount.	2025-12-20 00:00:00	2025-12-31 23:59:59	t	680ac88e-6b19-4917-9733-d579a6c6aa26	ce452b75-f195-4e11-8595-5679576ec448
15	Buy 2 Get 15% Off	Christmas festival offer: Buy 2 products and get 15% discount.	2025-12-10 00:00:00	2025-12-31 23:59:59	t	add9ddef-94dd-4f77-b601-e6477f6a8119	ea3b80e2-dd3b-4ba5-8b4a-8eba14b7e1dc
15	Buy 2 Get 15% Off	Christmas festival offer: Buy 2 products and get 15% discount.	2025-12-10 00:00:00	2025-12-31 23:59:59	t	4bc72206-65f2-4f35-91ca-db4d03b2be5b	bbc419c4-d5b4-49da-920a-67dd5868e7a1
15	Buy 2 Get 15% Off	Christmas festival offer: Buy 2 products and get 15% discount.	2025-12-10 00:00:00	2025-12-31 23:59:59	t	dce1ba02-0721-42c2-8139-6a5907defad0	abcdc1d8-c0f4-4f00-bde9-fd0f17b714cb
15	Buy 2 Get 15% Off	Christmas festival offer: Buy 2 products and get 15% discount.	2025-12-10 00:00:00	2025-12-31 23:59:59	t	2ffe8715-5f13-448a-95f7-856f3f3c35c2	160a90b6-e485-4a31-8150-306d453a3ef1
15	Buy 2 Get 15% Off	Christmas festival offer: Buy 2 products and get 15% discount.	2025-12-10 00:00:00	2025-12-31 23:59:59	t	5303e64a-72c1-4651-a3be-ef837862caa9	ce452b75-f195-4e11-8595-5679576ec448
\.


--
-- Data for Name: product_images; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.product_images (product_image_url, alt_text, "position", created_at, media_type, product_image_id, product_id, variant_id) FROM stdin;
https://res.cloudinary.com/dtz1gpnge/image/upload/v1765339808/IMG-20251128-WA0022_cxhfn4.jpg	Cinnamon Vanilla Candle	1	2025-12-11 18:04:42.823695+05:30	image	761bce7e-910c-4df5-9098-07bf93fb57e6	ea3b80e2-dd3b-4ba5-8b4a-8eba14b7e1dc	7a4739a1-6d2b-407e-8621-34097bab1d11
https://res.cloudinary.com/dtz1gpnge/image/upload/v1765339867/eb9e1f9b-6cf7-498c-b3c6-bb7d78fbc0c1_zsxqqf.jpg	Lavender Haze Candle	1	2025-12-11 18:05:49.245571+05:30	image	7c6c2c4d-005d-4429-b73d-4bc635d6b0ad	bbc419c4-d5b4-49da-920a-67dd5868e7a1	cf59c7cf-3a97-4380-83fd-25ba800f2604
https://res.cloudinary.com/dtz1gpnge/image/upload/v1765339808/IMG-20251128-WA0025_ebnmfc.jpg	Mahogany Amber Candle	1	2025-12-11 18:06:26.425197+05:30	image	2abb4c9b-2b26-474d-891a-5c2c4d4e5bdf	abcdc1d8-c0f4-4f00-bde9-fd0f17b714cb	416f8e1c-89fb-4722-b49d-d703c6653c9f
https://res.cloudinary.com/dtz1gpnge/image/upload/v1765339807/IMG-20251128-WA0024_whdtdv.jpg	Caramel Caffeine Candle	1	2025-12-11 18:06:57.697963+05:30	image	d833d6eb-1ef7-44f6-b603-55f4b1b8dc62	160a90b6-e485-4a31-8150-306d453a3ef1	4f675ce1-0bf2-4ff1-b98b-5b33964d35b1
https://res.cloudinary.com/dtz1gpnge/image/upload/v1765339807/IMG-20251128-WA0023_tj13l3.jpg	Lime Whisper Candle	1	2025-12-11 18:07:26.220155+05:30	image	13f97fa8-89b3-4442-8b91-01c7527d0931	ce452b75-f195-4e11-8595-5679576ec448	4a9f0c42-475d-44b0-b47d-9626608b6832
\.


--
-- Data for Name: product_price_history; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.product_price_history (old_price, new_price, changed_at, product_price_history_id, variant_id, changed_by) FROM stdin;
\.


--
-- Data for Name: product_stock_log; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.product_stock_log (change_type, change_amount, note, created_at, log_id, variant_id, changed_by) FROM stdin;
\.


--
-- Data for Name: product_tags; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.product_tags (product_tag_uuid, product_id, tag_id) FROM stdin;
\.


--
-- Data for Name: product_types; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.product_types (product_type_name, product_type_description, created_at, updated_at, product_type_id) FROM stdin;
Candle	Scented soy wax candles in glass jars.	2025-12-08 19:32:53.032264+05:30	2025-12-08 19:32:53.032264+05:30	60362dc2-14e8-4e9d-8c87-511af867f9de
Wax Melt	Small scented wax pieces that melt in a warmer to release long-lasting fragrance.	2025-12-08 19:37:25.084847+05:30	2025-12-08 19:37:25.084847+05:30	f5017a96-3946-4e57-a439-773d052c4d7b
Wax Sachet	Decorative fragrance bars infused with essential oils and botanicals for wardrobes, drawers, and small spaces.	2025-12-08 19:37:25.084847+05:30	2025-12-08 19:37:25.084847+05:30	ea9c4e8a-4e58-4daf-9fb4-ff778d16c35e
Diffuser Set	A complete aroma diffuser set with fragrance oil and reed sticks for consistent room freshening.	2025-12-08 19:37:25.084847+05:30	2025-12-08 19:37:25.084847+05:30	cbb39218-5147-4dbf-b793-82e6268173dd
Tea Light Holder	Decorative holders designed to safely place tea light candles for aesthetic illumination.	2025-12-08 19:37:25.084847+05:30	2025-12-08 19:37:25.084847+05:30	dd3804c2-022c-4876-a836-7bdd6440ee20
Festival Gift Set	Specially curated festive gifting sets including candles, wax melts, and diffusers.	2025-12-08 19:37:25.084847+05:30	2025-12-08 19:37:25.084847+05:30	e7b74c94-5015-4f55-9f3d-195a2b9426be
Candle + Diffuser Combo	A combination pack of scented candles and fragrance diffusers for gifting or home décor.	2025-12-08 19:37:25.084847+05:30	2025-12-08 19:37:25.084847+05:30	51883c38-5ff2-455e-b506-76eb468faee8
Clay Art Products	Handcrafted clay-based decorative items including diffusers, tea light holders, and pottery art pieces.	2025-12-08 19:37:25.084847+05:30	2025-12-08 19:37:25.084847+05:30	a8885cb8-fed4-4ade-8730-1f9d44c96b2a
\.


--
-- Data for Name: product_variants; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.product_variants (sku, variant_title, fragrance, weight_grams, size_label, color, burn_time_hours, price, mrp, stock, reserved_stock, low_stock_threshold, is_active, created_at, updated_at, deleted_at, created_by, updated_by, variant_id, product_id) FROM stdin;
CIN-160-V1	160g – Soy Wax Candle	Cinnamon Vanilla	160	Medium	White	35	499	599	20	0	5	t	2025-12-11 17:27:22.662896+05:30	2025-12-11 17:27:22.662896+05:30	\N	\N	\N	7a4739a1-6d2b-407e-8621-34097bab1d11	ea3b80e2-dd3b-4ba5-8b4a-8eba14b7e1dc
LAV-160-V1	160g – Soy Wax Candle	Lavender Haze	160	Medium	White	35	499	599	20	0	5	t	2025-12-11 17:27:22.662896+05:30	2025-12-11 17:27:22.662896+05:30	\N	\N	\N	cf59c7cf-3a97-4380-83fd-25ba800f2604	bbc419c4-d5b4-49da-920a-67dd5868e7a1
MAH-160-V1	160g – Soy Wax Candle	Mahogany Amber	160	Medium	White	35	499	599	20	0	5	t	2025-12-11 17:27:22.662896+05:30	2025-12-11 17:27:22.662896+05:30	\N	\N	\N	416f8e1c-89fb-4722-b49d-d703c6653c9f	abcdc1d8-c0f4-4f00-bde9-fd0f17b714cb
CAR-160-V1	160g – Soy Wax Candle	Caramel Caffeine	160	Medium	White	35	499	599	20	0	5	t	2025-12-11 17:27:22.662896+05:30	2025-12-11 17:27:22.662896+05:30	\N	\N	\N	4f675ce1-0bf2-4ff1-b98b-5b33964d35b1	160a90b6-e485-4a31-8150-306d453a3ef1
LIM-160-V1	160g – Soy Wax Candle	Lime Whisper	160	Medium	White	35	499	599	20	0	5	t	2025-12-11 17:27:22.662896+05:30	2025-12-11 17:27:22.662896+05:30	\N	\N	\N	4a9f0c42-475d-44b0-b47d-9626608b6832	ce452b75-f195-4e11-8595-5679576ec448
\.


--
-- Data for Name: products; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.products (sku_base, product_name, slug, short_description, product_description, brand, search_keywords, tags, is_active, created_at, updated_at, deleted_at, created_by, updated_by, search_vector, product_id, product_type_id, category_id) FROM stdin;
CIN-160	Cinnamon Vanilla Soy Candle	cinnamon-vanilla-candle	Soy wax candle – 160g – 35hr burn time.	Premium soy wax candle with warm cinnamon and sweet vanilla fragrance.	Chamakk	cinnamon, vanilla, candle, soy wax, aroma candle	{cinnamon,vanilla,"soy candle"}	t	2025-12-11 14:24:14.898941+05:30	2025-12-11 14:24:14.898941+05:30	\N	\N	\N	'160g':8B '35hr':9B 'and':19C 'aroma':28 'burn':10B 'candle':4A,7B,15C,25,29 'cinnamon':1A,18C,23 'fragrance':22C 'premium':12C 'soy':3A,5B,13C,26 'sweet':20C 'time':11B 'vanilla':2A,21C,24 'warm':17C 'wax':6B,14C,27 'with':16C	ea3b80e2-dd3b-4ba5-8b4a-8eba14b7e1dc	60362dc2-14e8-4e9d-8c87-511af867f9de	ff0ab5fd-44bf-4f56-a1f2-bdb92efd8593
LAV-160	Lavender Haze Soy Candle	lavender-haze-candle	Relaxing lavender aroma – 160g – 35hr burn time.	Soft aromatic lavender fragrance for calm and relaxation.	Chamakk	lavender, haze, candle, soy wax, aroma candle	{lavender,aroma,"soy candle"}	t	2025-12-11 14:24:14.898941+05:30	2025-12-11 14:24:14.898941+05:30	\N	\N	\N	'160g':8B '35hr':9B 'and':18C 'aroma':7B,25 'aromatic':13C 'burn':10B 'calm':17C 'candle':4A,22,26 'for':16C 'fragrance':15C 'haze':2A,21 'lavender':1A,6B,14C,20 'relaxation':19C 'relaxing':5B 'soft':12C 'soy':3A,23 'time':11B 'wax':24	bbc419c4-d5b4-49da-920a-67dd5868e7a1	60362dc2-14e8-4e9d-8c87-511af867f9de	ff0ab5fd-44bf-4f56-a1f2-bdb92efd8593
MAH-160	Mahogany Amber Soy Candle	mahogany-amber-candle	Bold mahogany aroma – 160g – 35hr burn time.	Warm mahogany & amber blend for luxury home fragrance.	Chamakk	mahogany, amber, candle, soy wax, aroma candle	{mahogany,amber,luxury}	t	2025-12-11 14:24:14.898941+05:30	2025-12-11 14:24:14.898941+05:30	\N	\N	\N	'160g':8B '35hr':9B 'amber':2A,14C,21 'aroma':7B,25 'blend':15C 'bold':5B 'burn':10B 'candle':4A,22,26 'for':16C 'fragrance':19C 'home':18C 'luxury':17C 'mahogany':1A,6B,13C,20 'soy':3A,23 'time':11B 'warm':12C 'wax':24	abcdc1d8-c0f4-4f00-bde9-fd0f17b714cb	60362dc2-14e8-4e9d-8c87-511af867f9de	ff0ab5fd-44bf-4f56-a1f2-bdb92efd8593
CAR-160	Caramel Caffeine Soy Candle	caramel-caffeine-candle	Coffee + caramel aroma – 160g – 35hr burn time.	Rich caramel and roasted coffee fragrance.	Chamakk	caramel, coffee, caffeine, candle, soy wax, aroma candle	{coffee,caramel,"soy candle"}	t	2025-12-11 14:24:14.898941+05:30	2025-12-11 14:24:14.898941+05:30	\N	\N	\N	'160g':8B '35hr':9B 'and':14C 'aroma':7B,24 'burn':10B 'caffeine':2A,20 'candle':4A,21,25 'caramel':1A,6B,13C,18 'coffee':5B,16C,19 'fragrance':17C 'rich':12C 'roasted':15C 'soy':3A,22 'time':11B 'wax':23	160a90b6-e485-4a31-8150-306d453a3ef1	60362dc2-14e8-4e9d-8c87-511af867f9de	ff0ab5fd-44bf-4f56-a1f2-bdb92efd8593
LIM-160	Lime Whisper Soy Candle	lime-whisper-candle	Fresh lime aroma – 160g – 35hr burn time.	Refreshing lime and citrus aroma for summer.	Chamakk	lime, citrus, candle, soy wax, aroma candle	{lime,citrus,fresh}	t	2025-12-11 14:24:14.898941+05:30	2025-12-11 14:24:14.898941+05:30	\N	\N	\N	'160g':8B '35hr':9B 'and':14C 'aroma':7B,16C,24 'burn':10B 'candle':4A,21,25 'citrus':15C,20 'for':17C 'fresh':5B 'lime':1A,6B,13C,19 'refreshing':12C 'soy':3A,22 'summer':18C 'time':11B 'wax':23 'whisper':2A	ce452b75-f195-4e11-8595-5679576ec448	60362dc2-14e8-4e9d-8c87-511af867f9de	ff0ab5fd-44bf-4f56-a1f2-bdb92efd8593
\.


--
-- Data for Name: tags; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.tags (tag_name, created_at, tag_id) FROM stdin;
\.


--
-- Data for Name: user_tokens; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.user_tokens (device_id, jwt_token, refresh_token, created_at, expires_at, status, last_used_at, token_id, user_id) FROM stdin;
CHAMAKK-ADMIN-CHROME-WIN-001	eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJmN2JmYmQ3Zi1lOGE2LTQ5ZjktYjEyZi0yMjA1YjA2ZDZjNmEiLCJyb2xlIjoiUk9MRV9BRE1JTiIsImlhdCI6MTc2NTg3NzM3NSwiZXhwIjoxNzY1ODc5MTc1fQ.dNne6q0K5U1dt2qoZTc4_eTHIxk-mhkevLooc91mncU	eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJmN2JmYmQ3Zi1lOGE2LTQ5ZjktYjEyZi0yMjA1YjA2ZDZjNmEiLCJpYXQiOjE3NjU4NzczNzUsImV4cCI6MTc2NjQ4MjE3NX0.BwG7Wus3bYiBryDXBb_0WwUq9vlMjSinvAiy4zuJBsA	2025-12-16 14:59:35.399869+05:30	2025-12-16 15:29:35+05:30	REVOKED	\N	1d0713b2-c556-4051-b3b6-0b670131e58d	f7bfbd7f-e8a6-49f9-b12f-2205b06d6c6a
CHAMAKK-ADMIN-CHROME-WIN-001	eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJmN2JmYmQ3Zi1lOGE2LTQ5ZjktYjEyZi0yMjA1YjA2ZDZjNmEiLCJyb2xlIjoiUk9MRV9BRE1JTiIsImlhdCI6MTc2NTg5OTc0MiwiZXhwIjoxNzY1OTAxNTQyfQ.w4osNZIiYye15tVcgr3wFhMvcZdHuFYQP4nUvrKHhMs	eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJmN2JmYmQ3Zi1lOGE2LTQ5ZjktYjEyZi0yMjA1YjA2ZDZjNmEiLCJpYXQiOjE3NjU4OTk3NDIsImV4cCI6MTc2NjUwNDU0Mn0.YZB6DcQ1mD02ApFk638K1n21uS05399IadLsJeKB23U	2025-12-16 21:12:22.591607+05:30	2025-12-16 21:42:22+05:30	REVOKED	\N	c5cb7052-b810-454b-acf3-eea2445c7c56	f7bfbd7f-e8a6-49f9-b12f-2205b06d6c6a
	eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJmN2JmYmQ3Zi1lOGE2LTQ5ZjktYjEyZi0yMjA1YjA2ZDZjNmEiLCJyb2xlIjoiUk9MRV9BRE1JTiIsImlhdCI6MTc2NTkxNDE5MCwiZXhwIjoxNzY1OTE1OTkwfQ.Me5Focqc3c1hW_DQCcZ63UYocgkKzwQz7KNwL-zYIlY	eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJmN2JmYmQ3Zi1lOGE2LTQ5ZjktYjEyZi0yMjA1YjA2ZDZjNmEiLCJpYXQiOjE3NjU5MTQxOTAsImV4cCI6MTc2NjUxODk5MH0.HQORqXiTML6jRgrjTZQpeUelmlB1iDGDUE5z_hVlBSU	2025-12-17 01:13:10.806954+05:30	2025-12-17 01:43:10+05:30	REVOKED	\N	5269c700-54d6-489e-84a6-bba33e8d7274	f7bfbd7f-e8a6-49f9-b12f-2205b06d6c6a
2b61707b-19ee-4c5e-a8b2-c30812342515	eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJmN2JmYmQ3Zi1lOGE2LTQ5ZjktYjEyZi0yMjA1YjA2ZDZjNmEiLCJyb2xlIjoiUk9MRV9BRE1JTiIsImlhdCI6MTc2NTk1NzcwNSwiZXhwIjoxNzY1OTU5NTA1fQ.TJbb_1EfRW3_08IueSSqmgAyB8wLqKgq-UrITNV606k	eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJmN2JmYmQ3Zi1lOGE2LTQ5ZjktYjEyZi0yMjA1YjA2ZDZjNmEiLCJpYXQiOjE3NjU5NTc3MDUsImV4cCI6MTc2NjU2MjUwNX0.5VecsKNUX8x7z7SnHGNIGesgFGCBy8oR3rX_AO5YCHY	2025-12-17 13:18:25.478829+05:30	2025-12-17 13:48:25+05:30	REVOKED	\N	e8df9410-fda6-4d76-9a50-a8097fd26b8f	f7bfbd7f-e8a6-49f9-b12f-2205b06d6c6a
7bdvr1pzsff	eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJmN2JmYmQ3Zi1lOGE2LTQ5ZjktYjEyZi0yMjA1YjA2ZDZjNmEiLCJyb2xlIjoiUk9MRV9BRE1JTiIsImlhdCI6MTc2NTk2MDgzMiwiZXhwIjoxNzY1OTYyNjMyfQ.NT_13gXgnKU5arCgCIPIUAoZqCARVlhjF8HWrJJ5W_4	eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJmN2JmYmQ3Zi1lOGE2LTQ5ZjktYjEyZi0yMjA1YjA2ZDZjNmEiLCJpYXQiOjE3NjU5NjA4MzIsImV4cCI6MTc2NjU2NTYzMn0.ImkvSGMgYQ1KQ2nFjI8Pf5H4_4qUwd1-XCIWTTKX-c0	2025-12-17 14:10:32.576991+05:30	2025-12-17 14:40:32+05:30	REVOKED	\N	84956241-ab7f-406b-af2b-63a757f5b592	f7bfbd7f-e8a6-49f9-b12f-2205b06d6c6a
7bdvr1pzsff	eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJmN2JmYmQ3Zi1lOGE2LTQ5ZjktYjEyZi0yMjA1YjA2ZDZjNmEiLCJyb2xlIjoiUk9MRV9BRE1JTiIsImlhdCI6MTc2NTk2NDY0OCwiZXhwIjoxNzY1OTY2NDQ4fQ.9Xb_YgwgX8XzOz0Tcp1yqramz3Pbo9hbRoqdxeIgsk0	eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJmN2JmYmQ3Zi1lOGE2LTQ5ZjktYjEyZi0yMjA1YjA2ZDZjNmEiLCJpYXQiOjE3NjU5NjQ2NDgsImV4cCI6MTc2NjU2OTQ0OH0.zhfiSa747dsqVBwe0VUyO-B8PYoUaOQ_J6K8X2nN8hg	2025-12-17 15:14:08.890091+05:30	2025-12-17 15:44:08+05:30	ACTIVE	\N	b84f8846-6ed5-42b3-b17c-13ec220d4acc	f7bfbd7f-e8a6-49f9-b12f-2205b06d6c6a
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.users (full_name, email, mobile, created_at, is_active, updated_at, user_id, password_hash, role) FROM stdin;
Vishal Gndhi	admin@chamakk.com	9999999999	2025-12-13 20:20:27.531375+05:30	t	2025-12-13 20:20:27.531375+05:30	f7bfbd7f-e8a6-49f9-b12f-2205b06d6c6a	{bcrypt}$2a$10$vGzJ7EA3dW9q3./mErsxYenYFSNr3RhQ0s9KhUzcBQ0vnj4hEHoc2	ROLE_ADMIN
\.


--
-- Data for Name: variant_attributes; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.variant_attributes (attribute_name, attribute_value, created_at, attribute_id, variant_id) FROM stdin;
Wick Type	Cotton Wick	2025-12-11 17:48:06.938878+05:30	b56a70c9-259e-41c2-8eb7-56e36fa4596a	7a4739a1-6d2b-407e-8621-34097bab1d11
Wax Type	100% Soy Wax	2025-12-11 17:48:06.938878+05:30	3156ea89-f490-4b8b-9825-f898f006547f	7a4739a1-6d2b-407e-8621-34097bab1d11
Jar Material	Frosted Glass	2025-12-11 17:48:06.938878+05:30	f6addc8f-db4e-40e7-85b5-988d8087ed0d	7a4739a1-6d2b-407e-8621-34097bab1d11
Fragrance Notes	Warm Cinnamon + Sweet Vanilla	2025-12-11 17:48:06.938878+05:30	5d2bd833-49ed-47ae-a777-c06f176fc3a7	7a4739a1-6d2b-407e-8621-34097bab1d11
Packaging	Premium Box Packaging	2025-12-11 17:48:06.938878+05:30	3da19fac-5ebb-4ebc-aa96-28fd48e5fb25	7a4739a1-6d2b-407e-8621-34097bab1d11
Color Tone	Cream White	2025-12-11 17:48:06.938878+05:30	a69b53ce-2c6e-4ffc-b74f-8c4d9d478f98	7a4739a1-6d2b-407e-8621-34097bab1d11
Wick Type	Cotton Wick	2025-12-11 17:52:38.652221+05:30	30a08bb0-09ca-4455-88c4-f0b7bbe1ce6b	cf59c7cf-3a97-4380-83fd-25ba800f2604
Wax Type	100% Soy Wax	2025-12-11 17:52:38.652221+05:30	1245b5ac-8c9b-4b2e-90ad-303083716fd1	cf59c7cf-3a97-4380-83fd-25ba800f2604
Jar Material	Frosted Glass	2025-12-11 17:52:38.652221+05:30	39a47a6b-7429-4854-9abe-86955b8c3102	cf59c7cf-3a97-4380-83fd-25ba800f2604
Fragrance Notes	Soft Lavender + Herbal Floral	2025-12-11 17:52:38.652221+05:30	961044a0-6802-44ee-9cf4-5c5c90f86d76	cf59c7cf-3a97-4380-83fd-25ba800f2604
Packaging	Premium Box Packaging	2025-12-11 17:52:38.652221+05:30	2584a36d-1dfa-4c1d-ad71-dd78006ac7e9	cf59c7cf-3a97-4380-83fd-25ba800f2604
Color Tone	Cream White	2025-12-11 17:52:38.652221+05:30	a17bee4d-8cf1-40c1-bf0f-a3190a1cb772	cf59c7cf-3a97-4380-83fd-25ba800f2604
Wick Type	Cotton Wick	2025-12-11 17:55:35.158143+05:30	233a0aa5-0936-4a77-b236-cfc72067806f	416f8e1c-89fb-4722-b49d-d703c6653c9f
Wax Type	100% Soy Wax	2025-12-11 17:55:35.158143+05:30	c7419794-a0ba-493b-9ef7-dc7593790b34	416f8e1c-89fb-4722-b49d-d703c6653c9f
Jar Material	Frosted Glass	2025-12-11 17:55:35.158143+05:30	947c0188-2395-4954-a598-40e8b3b85bd3	416f8e1c-89fb-4722-b49d-d703c6653c9f
Fragrance Notes	Rich Mahogany + Amber Blend	2025-12-11 17:55:35.158143+05:30	5774b24b-b32f-4d94-845b-6b6d41100972	416f8e1c-89fb-4722-b49d-d703c6653c9f
Packaging	Premium Box Packaging	2025-12-11 17:55:35.158143+05:30	690e4d08-04cd-495a-afde-53c121a02990	416f8e1c-89fb-4722-b49d-d703c6653c9f
Color Tone	Cream White	2025-12-11 17:55:35.158143+05:30	6505e472-8fd1-4902-984f-44fa42e19fc1	416f8e1c-89fb-4722-b49d-d703c6653c9f
Wick Type	Cotton Wick	2025-12-11 17:56:26.049426+05:30	4e3d749b-44a9-4f1d-852d-8bedc7d75ce3	4f675ce1-0bf2-4ff1-b98b-5b33964d35b1
Wax Type	100% Soy Wax	2025-12-11 17:56:26.049426+05:30	0bee410b-a0c5-488a-a901-10419265c7fe	4f675ce1-0bf2-4ff1-b98b-5b33964d35b1
Jar Material	Frosted Glass	2025-12-11 17:56:26.049426+05:30	6d3023c7-82b7-49a4-8637-d387f37d79b7	4f675ce1-0bf2-4ff1-b98b-5b33964d35b1
Fragrance Notes	Roasted Coffee + Caramel	2025-12-11 17:56:26.049426+05:30	94a1d9d2-db4e-4cd8-9227-7e2e1c97ed3e	4f675ce1-0bf2-4ff1-b98b-5b33964d35b1
Packaging	Premium Box Packaging	2025-12-11 17:56:26.049426+05:30	b0a602f9-3300-47e1-bb91-6ea011da7ec6	4f675ce1-0bf2-4ff1-b98b-5b33964d35b1
Color Tone	Cream White	2025-12-11 17:56:26.049426+05:30	fe6a86a9-3753-4014-bbd2-3a9d41024442	4f675ce1-0bf2-4ff1-b98b-5b33964d35b1
Wick Type	Cotton Wick	2025-12-11 17:58:08.130613+05:30	a5afbb0c-94c6-4cb3-96cd-ad60104d8380	4a9f0c42-475d-44b0-b47d-9626608b6832
Wax Type	100% Soy Wax	2025-12-11 17:58:08.130613+05:30	03c82341-62e2-4684-b333-a538af8e7f2b	4a9f0c42-475d-44b0-b47d-9626608b6832
Jar Material	Frosted Glass	2025-12-11 17:58:08.130613+05:30	795eb1c7-9fef-449a-9fa2-8f5512d591b5	4a9f0c42-475d-44b0-b47d-9626608b6832
Fragrance Notes	Fresh Lime + Citrus	2025-12-11 17:58:08.130613+05:30	b623ec35-569c-437f-b90c-f0806fc5fab4	4a9f0c42-475d-44b0-b47d-9626608b6832
Packaging	Premium Box Packaging	2025-12-11 17:58:08.130613+05:30	c0e20304-8702-4535-bdca-27b5606b4b7a	4a9f0c42-475d-44b0-b47d-9626608b6832
Color Tone	Cream White	2025-12-11 17:58:08.130613+05:30	5c28f866-8cf2-4166-95f0-0f8baa57f3f2	4a9f0c42-475d-44b0-b47d-9626608b6832
\.


--
-- Data for Name: website_media; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.website_media (website_media_title, website_media_type, website_media_url, page_section, alt_text, is_active, "position", created_at, website_media_id) FROM stdin;
Homepage Intro Video	video	https://res.cloudinary.com/dtz1gpnge/video/upload/v1765340893/intro_h4p4xo.mp4	homepage	Chamakk intro brand video	t	1	2025-12-10 10:04:30.769996	e7cf85a3-8655-4db8-ba94-b2ee54d70bde
\.


--
-- Name: categories categories_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.categories
    ADD CONSTRAINT categories_pkey PRIMARY KEY (category_id);


--
-- Name: categories categories_slug_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.categories
    ADD CONSTRAINT categories_slug_key UNIQUE (slug);


--
-- Name: login_session login_session_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.login_session
    ADD CONSTRAINT login_session_pkey PRIMARY KEY (session_id);


--
-- Name: product_discounts product_discounts_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product_discounts
    ADD CONSTRAINT product_discounts_pkey PRIMARY KEY (product_discount_id);


--
-- Name: product_images product_images_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product_images
    ADD CONSTRAINT product_images_pkey PRIMARY KEY (product_image_id);


--
-- Name: product_price_history product_price_history_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product_price_history
    ADD CONSTRAINT product_price_history_pkey PRIMARY KEY (product_price_history_id);


--
-- Name: product_stock_log product_stock_log_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product_stock_log
    ADD CONSTRAINT product_stock_log_pkey PRIMARY KEY (log_id);


--
-- Name: product_tags product_tags_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product_tags
    ADD CONSTRAINT product_tags_pkey PRIMARY KEY (product_id, tag_id);


--
-- Name: product_types product_types_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product_types
    ADD CONSTRAINT product_types_pkey PRIMARY KEY (product_type_id);


--
-- Name: product_types product_types_product_type_name_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product_types
    ADD CONSTRAINT product_types_product_type_name_key UNIQUE (product_type_name);


--
-- Name: product_variants product_variants_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product_variants
    ADD CONSTRAINT product_variants_pkey PRIMARY KEY (variant_id);


--
-- Name: product_variants product_variants_sku_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product_variants
    ADD CONSTRAINT product_variants_sku_key UNIQUE (sku);


--
-- Name: products products_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.products
    ADD CONSTRAINT products_pkey PRIMARY KEY (product_id);


--
-- Name: products products_slug_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.products
    ADD CONSTRAINT products_slug_key UNIQUE (slug);


--
-- Name: tags tags_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tags
    ADD CONSTRAINT tags_pkey PRIMARY KEY (tag_id);


--
-- Name: tags tags_tag_name_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tags
    ADD CONSTRAINT tags_tag_name_key UNIQUE (tag_name);


--
-- Name: user_tokens user_tokens_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_tokens
    ADD CONSTRAINT user_tokens_pkey PRIMARY KEY (token_id);


--
-- Name: users users_email_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_key UNIQUE (email);


--
-- Name: users users_mobile_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_mobile_key UNIQUE (mobile);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (user_id);


--
-- Name: variant_attributes variant_attributes_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.variant_attributes
    ADD CONSTRAINT variant_attributes_pkey PRIMARY KEY (attribute_id);


--
-- Name: website_media website_media_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.website_media
    ADD CONSTRAINT website_media_pkey PRIMARY KEY (website_media_id);


--
-- Name: idx_categories_name; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_categories_name ON public.categories USING btree (categorie_name);


--
-- Name: idx_login_session_mobile; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_login_session_mobile ON public.login_session USING btree (mobile);


--
-- Name: idx_products_active; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_products_active ON public.products USING btree (is_active);


--
-- Name: idx_products_name; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_products_name ON public.products USING gin (to_tsvector('simple'::regconfig, (product_name)::text));


--
-- Name: idx_products_search_vector; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_products_search_vector ON public.products USING gin (search_vector);


--
-- Name: idx_users_mobile; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_users_mobile ON public.users USING btree (mobile);


--
-- Name: idx_variant_attr_name; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_variant_attr_name ON public.variant_attributes USING btree (attribute_name);


--
-- Name: idx_variants_active; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_variants_active ON public.product_variants USING btree (is_active);


--
-- Name: idx_variants_sku; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_variants_sku ON public.product_variants USING btree (sku);


--
-- Name: idx_variants_stock; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_variants_stock ON public.product_variants USING btree (stock);


--
-- Name: products trg_products_search_vector; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trg_products_search_vector BEFORE INSERT OR UPDATE ON public.products FOR EACH ROW EXECUTE FUNCTION public.products_search_vector_trigger();


--
-- Name: product_price_history fk_price_changed_by_user; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product_price_history
    ADD CONSTRAINT fk_price_changed_by_user FOREIGN KEY (changed_by) REFERENCES public.users(user_id);


--
-- Name: products fk_product_types; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.products
    ADD CONSTRAINT fk_product_types FOREIGN KEY (product_type_id) REFERENCES public.product_types(product_type_id);


--
-- Name: product_images fk_product_variants; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product_images
    ADD CONSTRAINT fk_product_variants FOREIGN KEY (variant_id) REFERENCES public.product_variants(variant_id);


--
-- Name: product_price_history fk_product_variants; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product_price_history
    ADD CONSTRAINT fk_product_variants FOREIGN KEY (variant_id) REFERENCES public.product_variants(variant_id);


--
-- Name: product_stock_log fk_product_variants; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product_stock_log
    ADD CONSTRAINT fk_product_variants FOREIGN KEY (variant_id) REFERENCES public.product_variants(variant_id);


--
-- Name: variant_attributes fk_product_variants; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.variant_attributes
    ADD CONSTRAINT fk_product_variants FOREIGN KEY (variant_id) REFERENCES public.product_variants(variant_id);


--
-- Name: product_discounts fk_products; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product_discounts
    ADD CONSTRAINT fk_products FOREIGN KEY (product_id) REFERENCES public.products(product_id);


--
-- Name: product_images fk_products; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product_images
    ADD CONSTRAINT fk_products FOREIGN KEY (product_id) REFERENCES public.products(product_id);


--
-- Name: product_variants fk_products; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product_variants
    ADD CONSTRAINT fk_products FOREIGN KEY (product_id) REFERENCES public.products(product_id);


--
-- Name: product_tags fk_products; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product_tags
    ADD CONSTRAINT fk_products FOREIGN KEY (product_id) REFERENCES public.products(product_id);


--
-- Name: products fk_products_category; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.products
    ADD CONSTRAINT fk_products_category FOREIGN KEY (category_id) REFERENCES public.categories(category_id);


--
-- Name: product_stock_log fk_stock_changed_by_user; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product_stock_log
    ADD CONSTRAINT fk_stock_changed_by_user FOREIGN KEY (changed_by) REFERENCES public.users(user_id);


--
-- Name: product_tags fk_tags; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product_tags
    ADD CONSTRAINT fk_tags FOREIGN KEY (tag_id) REFERENCES public.tags(tag_id);


--
-- Name: user_tokens fk_users; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_tokens
    ADD CONSTRAINT fk_users FOREIGN KEY (user_id) REFERENCES public.users(user_id);


--
-- PostgreSQL database dump complete
--

\unrestrict ESd641rpf40vdy9oywgOhM8x5P1YvWM6Tb0xfVVBmF1ZEJei7xI62EjUl0dXPXY

