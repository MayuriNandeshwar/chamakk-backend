--
-- PostgreSQL database dump
--

\restrict 5Ksrv3GUtwWmcek1gNvF1WDgceXxebCUXWEzVXtgk6mcqYzUj5zkNV2OAAED258

-- Dumped from database version 16.10
-- Dumped by pg_dump version 16.10

-- Started on 2025-12-27 11:21:23

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
-- TOC entry 2 (class 3079 OID 16727)
-- Name: pgcrypto; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pgcrypto WITH SCHEMA public;


--
-- TOC entry 5517 (class 0 OID 0)
-- Dependencies: 2
-- Name: EXTENSION pgcrypto; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION pgcrypto IS 'cryptographic functions';


--
-- TOC entry 296 (class 1255 OID 16693)
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
-- TOC entry 257 (class 1259 OID 17589)
-- Name: activity_logs; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.activity_logs (
    log_id uuid DEFAULT gen_random_uuid() NOT NULL,
    user_id uuid,
    action character varying(100),
    entity_type character varying(50),
    entity_id uuid,
    metadata jsonb,
    ip_address character varying(45),
    created_at timestamp with time zone DEFAULT now()
);


ALTER TABLE public.activity_logs OWNER TO postgres;

--
-- TOC entry 245 (class 1259 OID 17416)
-- Name: addresses; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.addresses (
    address_id uuid DEFAULT gen_random_uuid() NOT NULL,
    user_id uuid NOT NULL,
    full_name character varying(200) NOT NULL,
    phone character varying(15) NOT NULL,
    address_line1 character varying(255) NOT NULL,
    address_line2 character varying(255),
    city character varying(100) NOT NULL,
    state character varying(100) NOT NULL,
    pincode character varying(10) NOT NULL,
    country character varying(100) DEFAULT 'India'::character varying,
    address_type character varying(20) DEFAULT 'HOME'::character varying,
    is_default boolean DEFAULT false,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    CONSTRAINT addresses_address_type_check CHECK (((address_type)::text = ANY ((ARRAY['HOME'::character varying, 'WORK'::character varying, 'OTHER'::character varying])::text[])))
);


ALTER TABLE public.addresses OWNER TO postgres;

--
-- TOC entry 235 (class 1259 OID 17251)
-- Name: cart_items; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.cart_items (
    cart_item_id uuid DEFAULT gen_random_uuid() NOT NULL,
    cart_id uuid NOT NULL,
    variant_id uuid NOT NULL,
    quantity integer NOT NULL,
    price_at_add integer NOT NULL,
    added_at timestamp with time zone DEFAULT now(),
    CONSTRAINT cart_items_quantity_check CHECK ((quantity > 0))
);


ALTER TABLE public.cart_items OWNER TO postgres;

--
-- TOC entry 234 (class 1259 OID 17236)
-- Name: carts; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.carts (
    cart_id uuid DEFAULT gen_random_uuid() NOT NULL,
    user_id uuid NOT NULL,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    status character varying(20) DEFAULT 'ACTIVE'::character varying
);


ALTER TABLE public.carts OWNER TO postgres;

--
-- TOC entry 219 (class 1259 OID 16528)
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
-- TOC entry 256 (class 1259 OID 17580)
-- Name: contact_submissions; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.contact_submissions (
    submission_id uuid DEFAULT gen_random_uuid() NOT NULL,
    name character varying(150),
    email character varying(120),
    phone character varying(15),
    message text,
    created_at timestamp with time zone DEFAULT now()
);


ALTER TABLE public.contact_submissions OWNER TO postgres;

--
-- TOC entry 251 (class 1259 OID 17503)
-- Name: coupon_usage; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.coupon_usage (
    coupon_usage_id uuid DEFAULT gen_random_uuid() NOT NULL,
    coupon_id uuid NOT NULL,
    user_id uuid NOT NULL,
    order_id uuid,
    used_at timestamp with time zone DEFAULT now()
);


ALTER TABLE public.coupon_usage OWNER TO postgres;

--
-- TOC entry 250 (class 1259 OID 17490)
-- Name: coupons; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.coupons (
    coupon_id uuid DEFAULT gen_random_uuid() NOT NULL,
    coupon_code character varying(50) NOT NULL,
    description character varying(255),
    discount_type character varying(20) NOT NULL,
    discount_value integer NOT NULL,
    min_order_amount integer DEFAULT 0,
    max_discount integer,
    usage_limit integer,
    per_user_limit integer DEFAULT 1,
    start_date timestamp with time zone NOT NULL,
    end_date timestamp with time zone NOT NULL,
    is_active boolean DEFAULT true,
    created_at timestamp with time zone DEFAULT now(),
    CONSTRAINT coupons_discount_type_check CHECK (((discount_type)::text = ANY ((ARRAY['PERCENT'::character varying, 'FLAT'::character varying])::text[])))
);


ALTER TABLE public.coupons OWNER TO postgres;

--
-- TOC entry 246 (class 1259 OID 17437)
-- Name: customer_profile; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.customer_profile (
    user_id uuid NOT NULL,
    total_orders integer DEFAULT 0,
    total_spent integer DEFAULT 0,
    last_order_at timestamp with time zone,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now()
);


ALTER TABLE public.customer_profile OWNER TO postgres;

--
-- TOC entry 249 (class 1259 OID 17475)
-- Name: discount_products; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.discount_products (
    discount_id uuid NOT NULL,
    product_id uuid NOT NULL
);


ALTER TABLE public.discount_products OWNER TO postgres;

--
-- TOC entry 248 (class 1259 OID 17466)
-- Name: discounts; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.discounts (
    discount_id uuid DEFAULT gen_random_uuid() NOT NULL,
    discount_title character varying(150) NOT NULL,
    discount_description character varying(255),
    discount_type character varying(20) NOT NULL,
    discount_value integer NOT NULL,
    start_date timestamp with time zone NOT NULL,
    end_date timestamp with time zone NOT NULL,
    is_active boolean DEFAULT true,
    created_at timestamp with time zone DEFAULT now(),
    CONSTRAINT discounts_discount_type_check CHECK (((discount_type)::text = ANY ((ARRAY['PERCENT'::character varying, 'FLAT'::character varying])::text[])))
);


ALTER TABLE public.discounts OWNER TO postgres;

--
-- TOC entry 237 (class 1259 OID 17296)
-- Name: failed_login_attempts; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.failed_login_attempts (
    attempt_id uuid DEFAULT gen_random_uuid() NOT NULL,
    email character varying(120),
    mobile character varying(15),
    ip_address character varying(45) NOT NULL,
    attempted_at timestamp with time zone DEFAULT now()
);


ALTER TABLE public.failed_login_attempts OWNER TO postgres;

--
-- TOC entry 233 (class 1259 OID 17219)
-- Name: inventory; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.inventory (
    inventory_id uuid DEFAULT gen_random_uuid() NOT NULL,
    variant_id uuid NOT NULL,
    available_quantity integer DEFAULT 0 NOT NULL,
    reserved_quantity integer DEFAULT 0 NOT NULL,
    low_stock_threshold integer DEFAULT 5,
    updated_at timestamp with time zone DEFAULT now()
);


ALTER TABLE public.inventory OWNER TO postgres;

--
-- TOC entry 216 (class 1259 OID 16464)
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
-- TOC entry 255 (class 1259 OID 17570)
-- Name: newsletter_subscribers; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.newsletter_subscribers (
    subscriber_id uuid DEFAULT gen_random_uuid() NOT NULL,
    email character varying(120) NOT NULL,
    is_active boolean DEFAULT true,
    subscribed_at timestamp with time zone DEFAULT now()
);


ALTER TABLE public.newsletter_subscribers OWNER TO postgres;

--
-- TOC entry 247 (class 1259 OID 17451)
-- Name: order_addresses; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.order_addresses (
    order_address_id uuid DEFAULT gen_random_uuid() NOT NULL,
    order_id uuid NOT NULL,
    full_name character varying(200) NOT NULL,
    phone character varying(15) NOT NULL,
    address_line1 character varying(255) NOT NULL,
    address_line2 character varying(255),
    city character varying(100) NOT NULL,
    state character varying(100) NOT NULL,
    pincode character varying(10) NOT NULL,
    country character varying(100) DEFAULT 'India'::character varying,
    created_at timestamp with time zone DEFAULT now()
);


ALTER TABLE public.order_addresses OWNER TO postgres;

--
-- TOC entry 242 (class 1259 OID 17370)
-- Name: order_items; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.order_items (
    order_item_id uuid NOT NULL,
    order_id uuid NOT NULL,
    variant_id uuid NOT NULL,
    product_name character varying(255) NOT NULL,
    variant_title character varying(255),
    quantity integer NOT NULL,
    unit_price integer NOT NULL,
    total_price integer NOT NULL,
    created_at timestamp with time zone DEFAULT now()
);


ALTER TABLE public.order_items OWNER TO postgres;

--
-- TOC entry 243 (class 1259 OID 17383)
-- Name: order_status_history; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.order_status_history (
    history_id uuid NOT NULL,
    order_id uuid NOT NULL,
    status character varying(30) NOT NULL,
    note text,
    changed_at timestamp with time zone DEFAULT now(),
    changed_by uuid
);


ALTER TABLE public.order_status_history OWNER TO postgres;

--
-- TOC entry 241 (class 1259 OID 17357)
-- Name: orders; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.orders (
    order_id uuid NOT NULL,
    order_number character varying(30) NOT NULL,
    user_id uuid NOT NULL,
    status character varying(30) NOT NULL,
    payment_status character varying(30) NOT NULL,
    subtotal integer NOT NULL,
    discount_amount integer DEFAULT 0,
    tax_amount integer DEFAULT 0,
    shipping_amount integer DEFAULT 0,
    total_amount integer NOT NULL,
    payment_attempts integer DEFAULT 0,
    placed_at timestamp with time zone,
    cancelled_at timestamp with time zone,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now()
);


ALTER TABLE public.orders OWNER TO postgres;

--
-- TOC entry 238 (class 1259 OID 17305)
-- Name: password_reset_tokens; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.password_reset_tokens (
    reset_id uuid DEFAULT gen_random_uuid() NOT NULL,
    user_id uuid NOT NULL,
    token character varying(255) NOT NULL,
    expires_at timestamp with time zone NOT NULL,
    used boolean DEFAULT false,
    created_at timestamp with time zone DEFAULT now()
);


ALTER TABLE public.password_reset_tokens OWNER TO postgres;

--
-- TOC entry 244 (class 1259 OID 17397)
-- Name: payments; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.payments (
    payment_id uuid NOT NULL,
    order_id uuid NOT NULL,
    provider character varying(30),
    provider_payment_id character varying(100),
    provider_order_id character varying(100),
    amount integer NOT NULL,
    currency character varying(10) DEFAULT 'INR'::character varying,
    status character varying(30) NOT NULL,
    attempt_number integer NOT NULL,
    initiated_at timestamp with time zone,
    completed_at timestamp with time zone,
    created_at timestamp with time zone DEFAULT now()
);


ALTER TABLE public.payments OWNER TO postgres;

--
-- TOC entry 231 (class 1259 OID 17167)
-- Name: permissions; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.permissions (
    permission_id uuid DEFAULT gen_random_uuid() NOT NULL,
    permission_code character varying(100) NOT NULL,
    description character varying(255),
    created_at timestamp with time zone DEFAULT now(),
    is_active boolean DEFAULT true NOT NULL,
    updated_at timestamp with time zone
);


ALTER TABLE public.permissions OWNER TO postgres;

--
-- TOC entry 240 (class 1259 OID 17338)
-- Name: product_bundle_items; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.product_bundle_items (
    bundle_id uuid NOT NULL,
    child_product_id uuid NOT NULL,
    quantity integer DEFAULT 1 NOT NULL
);


ALTER TABLE public.product_bundle_items OWNER TO postgres;

--
-- TOC entry 228 (class 1259 OID 16700)
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
-- TOC entry 223 (class 1259 OID 16617)
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
    variant_id uuid,
    is_primary boolean DEFAULT false
);


ALTER TABLE public.product_images OWNER TO postgres;

--
-- TOC entry 227 (class 1259 OID 16680)
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
-- TOC entry 226 (class 1259 OID 16664)
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
-- TOC entry 225 (class 1259 OID 16648)
-- Name: product_tags; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.product_tags (
    product_tag_uuid uuid DEFAULT gen_random_uuid(),
    product_id uuid NOT NULL,
    tag_id uuid NOT NULL
);


ALTER TABLE public.product_tags OWNER TO postgres;

--
-- TOC entry 218 (class 1259 OID 16515)
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
-- TOC entry 221 (class 1259 OID 16576)
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
-- TOC entry 239 (class 1259 OID 17324)
-- Name: product_visibility; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.product_visibility (
    visibility_id uuid DEFAULT gen_random_uuid() NOT NULL,
    product_id uuid NOT NULL,
    show_on_home boolean DEFAULT false,
    show_in_collections boolean DEFAULT false,
    priority integer DEFAULT 0,
    valid_from timestamp with time zone,
    valid_to timestamp with time zone
);


ALTER TABLE public.product_visibility OWNER TO postgres;

--
-- TOC entry 220 (class 1259 OID 16549)
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
    is_active boolean DEFAULT true,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    deleted_at timestamp with time zone,
    created_by uuid,
    updated_by uuid,
    search_vector tsvector,
    product_id uuid DEFAULT gen_random_uuid() NOT NULL,
    product_type_id uuid,
    category_id uuid,
    is_featured boolean DEFAULT false,
    is_manual_bestseller boolean DEFAULT false,
    seo_title character varying(255),
    seo_description text,
    seo_keywords character varying(500)
);


ALTER TABLE public.products OWNER TO postgres;

--
-- TOC entry 252 (class 1259 OID 17525)
-- Name: refunds; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.refunds (
    refund_id uuid DEFAULT gen_random_uuid() NOT NULL,
    order_id uuid NOT NULL,
    payment_id uuid,
    refund_amount integer NOT NULL,
    refund_reason character varying(255),
    refund_status character varying(20),
    processed_at timestamp with time zone,
    created_at timestamp with time zone DEFAULT now(),
    CONSTRAINT refunds_refund_status_check CHECK (((refund_status)::text = ANY ((ARRAY['REQUESTED'::character varying, 'APPROVED'::character varying, 'PROCESSED'::character varying, 'FAILED'::character varying])::text[])))
);


ALTER TABLE public.refunds OWNER TO postgres;

--
-- TOC entry 253 (class 1259 OID 17538)
-- Name: reviews; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.reviews (
    review_id uuid DEFAULT gen_random_uuid() NOT NULL,
    product_id uuid NOT NULL,
    user_id uuid NOT NULL,
    rating integer,
    comment text,
    is_approved boolean DEFAULT false,
    created_at timestamp with time zone DEFAULT now(),
    CONSTRAINT reviews_rating_check CHECK (((rating >= 1) AND (rating <= 5)))
);


ALTER TABLE public.reviews OWNER TO postgres;

--
-- TOC entry 232 (class 1259 OID 17178)
-- Name: role_permissions; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.role_permissions (
    role_permission_id uuid DEFAULT gen_random_uuid() NOT NULL,
    role_id uuid NOT NULL,
    permission_id uuid NOT NULL,
    created_at timestamp with time zone DEFAULT now()
);


ALTER TABLE public.role_permissions OWNER TO postgres;

--
-- TOC entry 230 (class 1259 OID 17156)
-- Name: roles; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.roles (
    role_id uuid DEFAULT gen_random_uuid() NOT NULL,
    role_name character varying(255) NOT NULL,
    description character varying(255),
    created_at timestamp with time zone DEFAULT now()
);


ALTER TABLE public.roles OWNER TO postgres;

--
-- TOC entry 258 (class 1259 OID 17598)
-- Name: settings; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.settings (
    setting_key character varying(100) NOT NULL,
    setting_value text,
    updated_at timestamp with time zone DEFAULT now()
);


ALTER TABLE public.settings OWNER TO postgres;

--
-- TOC entry 224 (class 1259 OID 16639)
-- Name: tags; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.tags (
    tag_name character varying(120) NOT NULL,
    created_at timestamp with time zone DEFAULT now(),
    tag_id uuid DEFAULT gen_random_uuid() NOT NULL
);


ALTER TABLE public.tags OWNER TO postgres;

--
-- TOC entry 236 (class 1259 OID 17275)
-- Name: user_roles; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.user_roles (
    user_role_id uuid DEFAULT gen_random_uuid() NOT NULL,
    user_id uuid NOT NULL,
    role_id uuid NOT NULL,
    assigned_at timestamp with time zone DEFAULT now()
);


ALTER TABLE public.user_roles OWNER TO postgres;

--
-- TOC entry 259 (class 1259 OID 17658)
-- Name: user_sessions; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.user_sessions (
    session_id uuid DEFAULT gen_random_uuid() NOT NULL,
    user_id uuid NOT NULL,
    refresh_token text NOT NULL,
    device_id text NOT NULL,
    device_type character varying(20),
    ip_address inet,
    user_agent text,
    status character varying(20) NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    last_used_at timestamp without time zone,
    expires_at timestamp without time zone NOT NULL,
    revoked_reason text,
    CONSTRAINT user_sessions_status_check CHECK (((status)::text = ANY ((ARRAY['ACTIVE'::character varying, 'REVOKED'::character varying, 'EXPIRED'::character varying])::text[])))
);


ALTER TABLE public.user_sessions OWNER TO postgres;

--
-- TOC entry 217 (class 1259 OID 16484)
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
    role_id uuid
);


ALTER TABLE public.users OWNER TO postgres;

--
-- TOC entry 222 (class 1259 OID 16600)
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
-- TOC entry 229 (class 1259 OID 16716)
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
-- TOC entry 254 (class 1259 OID 17561)
-- Name: wishlists; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.wishlists (
    wishlist_id uuid DEFAULT gen_random_uuid() NOT NULL,
    user_id uuid NOT NULL,
    product_id uuid NOT NULL,
    created_at timestamp with time zone DEFAULT now()
);


ALTER TABLE public.wishlists OWNER TO postgres;

--
-- TOC entry 5509 (class 0 OID 17589)
-- Dependencies: 257
-- Data for Name: activity_logs; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.activity_logs (log_id, user_id, action, entity_type, entity_id, metadata, ip_address, created_at) FROM stdin;
\.


--
-- TOC entry 5497 (class 0 OID 17416)
-- Dependencies: 245
-- Data for Name: addresses; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.addresses (address_id, user_id, full_name, phone, address_line1, address_line2, city, state, pincode, country, address_type, is_default, created_at, updated_at) FROM stdin;
\.


--
-- TOC entry 5487 (class 0 OID 17251)
-- Dependencies: 235
-- Data for Name: cart_items; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.cart_items (cart_item_id, cart_id, variant_id, quantity, price_at_add, added_at) FROM stdin;
\.


--
-- TOC entry 5486 (class 0 OID 17236)
-- Dependencies: 234
-- Data for Name: carts; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.carts (cart_id, user_id, created_at, updated_at, status) FROM stdin;
\.


--
-- TOC entry 5471 (class 0 OID 16528)
-- Dependencies: 219
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
-- TOC entry 5508 (class 0 OID 17580)
-- Dependencies: 256
-- Data for Name: contact_submissions; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.contact_submissions (submission_id, name, email, phone, message, created_at) FROM stdin;
\.


--
-- TOC entry 5503 (class 0 OID 17503)
-- Dependencies: 251
-- Data for Name: coupon_usage; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.coupon_usage (coupon_usage_id, coupon_id, user_id, order_id, used_at) FROM stdin;
\.


--
-- TOC entry 5502 (class 0 OID 17490)
-- Dependencies: 250
-- Data for Name: coupons; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.coupons (coupon_id, coupon_code, description, discount_type, discount_value, min_order_amount, max_discount, usage_limit, per_user_limit, start_date, end_date, is_active, created_at) FROM stdin;
\.


--
-- TOC entry 5498 (class 0 OID 17437)
-- Dependencies: 246
-- Data for Name: customer_profile; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.customer_profile (user_id, total_orders, total_spent, last_order_at, created_at, updated_at) FROM stdin;
\.


--
-- TOC entry 5501 (class 0 OID 17475)
-- Dependencies: 249
-- Data for Name: discount_products; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.discount_products (discount_id, product_id) FROM stdin;
\.


--
-- TOC entry 5500 (class 0 OID 17466)
-- Dependencies: 248
-- Data for Name: discounts; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.discounts (discount_id, discount_title, discount_description, discount_type, discount_value, start_date, end_date, is_active, created_at) FROM stdin;
\.


--
-- TOC entry 5489 (class 0 OID 17296)
-- Dependencies: 237
-- Data for Name: failed_login_attempts; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.failed_login_attempts (attempt_id, email, mobile, ip_address, attempted_at) FROM stdin;
\.


--
-- TOC entry 5485 (class 0 OID 17219)
-- Dependencies: 233
-- Data for Name: inventory; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.inventory (inventory_id, variant_id, available_quantity, reserved_quantity, low_stock_threshold, updated_at) FROM stdin;
15bab089-f543-4a4e-afa3-b68a0c552932	7a4739a1-6d2b-407e-8621-34097bab1d11	20	0	5	2025-12-26 22:20:22.242497+05:30
264e6c0e-a75f-43aa-b8cd-ac9e5c0e0352	cf59c7cf-3a97-4380-83fd-25ba800f2604	20	0	5	2025-12-26 22:20:22.242497+05:30
783fba1d-747d-4f78-8e05-d30b57a6ec9c	416f8e1c-89fb-4722-b49d-d703c6653c9f	20	0	5	2025-12-26 22:20:22.242497+05:30
4b2a282e-e623-4e73-a72d-c5a4e09e89db	4f675ce1-0bf2-4ff1-b98b-5b33964d35b1	20	0	5	2025-12-26 22:20:22.242497+05:30
7063e615-1ff9-4c12-8557-16411c45e820	4a9f0c42-475d-44b0-b47d-9626608b6832	20	0	5	2025-12-26 22:20:22.242497+05:30
\.


--
-- TOC entry 5468 (class 0 OID 16464)
-- Dependencies: 216
-- Data for Name: login_session; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.login_session (mobile, otp, is_verified, created_at, expires_at, attempts, session_id) FROM stdin;
\.


--
-- TOC entry 5507 (class 0 OID 17570)
-- Dependencies: 255
-- Data for Name: newsletter_subscribers; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.newsletter_subscribers (subscriber_id, email, is_active, subscribed_at) FROM stdin;
\.


--
-- TOC entry 5499 (class 0 OID 17451)
-- Dependencies: 247
-- Data for Name: order_addresses; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.order_addresses (order_address_id, order_id, full_name, phone, address_line1, address_line2, city, state, pincode, country, created_at) FROM stdin;
\.


--
-- TOC entry 5494 (class 0 OID 17370)
-- Dependencies: 242
-- Data for Name: order_items; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.order_items (order_item_id, order_id, variant_id, product_name, variant_title, quantity, unit_price, total_price, created_at) FROM stdin;
\.


--
-- TOC entry 5495 (class 0 OID 17383)
-- Dependencies: 243
-- Data for Name: order_status_history; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.order_status_history (history_id, order_id, status, note, changed_at, changed_by) FROM stdin;
\.


--
-- TOC entry 5493 (class 0 OID 17357)
-- Dependencies: 241
-- Data for Name: orders; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.orders (order_id, order_number, user_id, status, payment_status, subtotal, discount_amount, tax_amount, shipping_amount, total_amount, payment_attempts, placed_at, cancelled_at, created_at, updated_at) FROM stdin;
\.


--
-- TOC entry 5490 (class 0 OID 17305)
-- Dependencies: 238
-- Data for Name: password_reset_tokens; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.password_reset_tokens (reset_id, user_id, token, expires_at, used, created_at) FROM stdin;
\.


--
-- TOC entry 5496 (class 0 OID 17397)
-- Dependencies: 244
-- Data for Name: payments; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.payments (payment_id, order_id, provider, provider_payment_id, provider_order_id, amount, currency, status, attempt_number, initiated_at, completed_at, created_at) FROM stdin;
\.


--
-- TOC entry 5483 (class 0 OID 17167)
-- Dependencies: 231
-- Data for Name: permissions; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.permissions (permission_id, permission_code, description, created_at, is_active, updated_at) FROM stdin;
0edf2ef9-8a44-4ae9-918d-850f71e10913	PRODUCT_CREATE	Create products	2025-12-21 22:18:53.79536+05:30	t	2025-12-21 22:18:53.79536+05:30
82c0be24-8d72-4c42-97e9-11b567d4e6b1	PRODUCT_UPDATE	Update products	2025-12-21 22:18:53.79536+05:30	t	2025-12-21 22:18:53.79536+05:30
b9c101d7-5f41-4b30-8979-5b0dc745ef32	PRODUCT_DELETE	Delete products	2025-12-21 22:18:53.79536+05:30	t	2025-12-21 22:18:53.79536+05:30
d4365ebe-269f-4c92-a9ac-ac5e290513a6	ORDER_VIEW	View orders	2025-12-21 22:18:53.79536+05:30	t	2025-12-21 22:18:53.79536+05:30
94c64c8e-b1dd-4ce6-ad25-d5941028d068	USER_BLOCK	Block users	2025-12-21 22:18:53.79536+05:30	t	2025-12-21 22:18:53.79536+05:30
\.


--
-- TOC entry 5492 (class 0 OID 17338)
-- Dependencies: 240
-- Data for Name: product_bundle_items; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.product_bundle_items (bundle_id, child_product_id, quantity) FROM stdin;
\.


--
-- TOC entry 5480 (class 0 OID 16700)
-- Dependencies: 228
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
-- TOC entry 5475 (class 0 OID 16617)
-- Dependencies: 223
-- Data for Name: product_images; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.product_images (product_image_url, alt_text, "position", created_at, media_type, product_image_id, product_id, variant_id, is_primary) FROM stdin;
https://res.cloudinary.com/dtz1gpnge/image/upload/v1765339808/IMG-20251128-WA0022_cxhfn4.jpg	Cinnamon Vanilla Candle	1	2025-12-11 18:04:42.823695+05:30	image	761bce7e-910c-4df5-9098-07bf93fb57e6	ea3b80e2-dd3b-4ba5-8b4a-8eba14b7e1dc	7a4739a1-6d2b-407e-8621-34097bab1d11	f
https://res.cloudinary.com/dtz1gpnge/image/upload/v1765339867/eb9e1f9b-6cf7-498c-b3c6-bb7d78fbc0c1_zsxqqf.jpg	Lavender Haze Candle	1	2025-12-11 18:05:49.245571+05:30	image	7c6c2c4d-005d-4429-b73d-4bc635d6b0ad	bbc419c4-d5b4-49da-920a-67dd5868e7a1	cf59c7cf-3a97-4380-83fd-25ba800f2604	f
https://res.cloudinary.com/dtz1gpnge/image/upload/v1765339808/IMG-20251128-WA0025_ebnmfc.jpg	Mahogany Amber Candle	1	2025-12-11 18:06:26.425197+05:30	image	2abb4c9b-2b26-474d-891a-5c2c4d4e5bdf	abcdc1d8-c0f4-4f00-bde9-fd0f17b714cb	416f8e1c-89fb-4722-b49d-d703c6653c9f	f
https://res.cloudinary.com/dtz1gpnge/image/upload/v1765339807/IMG-20251128-WA0024_whdtdv.jpg	Caramel Caffeine Candle	1	2025-12-11 18:06:57.697963+05:30	image	d833d6eb-1ef7-44f6-b603-55f4b1b8dc62	160a90b6-e485-4a31-8150-306d453a3ef1	4f675ce1-0bf2-4ff1-b98b-5b33964d35b1	f
https://res.cloudinary.com/dtz1gpnge/image/upload/v1765339807/IMG-20251128-WA0023_tj13l3.jpg	Lime Whisper Candle	1	2025-12-11 18:07:26.220155+05:30	image	13f97fa8-89b3-4442-8b91-01c7527d0931	ce452b75-f195-4e11-8595-5679576ec448	4a9f0c42-475d-44b0-b47d-9626608b6832	f
\.


--
-- TOC entry 5479 (class 0 OID 16680)
-- Dependencies: 227
-- Data for Name: product_price_history; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.product_price_history (old_price, new_price, changed_at, product_price_history_id, variant_id, changed_by) FROM stdin;
\.


--
-- TOC entry 5478 (class 0 OID 16664)
-- Dependencies: 226
-- Data for Name: product_stock_log; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.product_stock_log (change_type, change_amount, note, created_at, log_id, variant_id, changed_by) FROM stdin;
\.


--
-- TOC entry 5477 (class 0 OID 16648)
-- Dependencies: 225
-- Data for Name: product_tags; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.product_tags (product_tag_uuid, product_id, tag_id) FROM stdin;
\.


--
-- TOC entry 5470 (class 0 OID 16515)
-- Dependencies: 218
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
-- TOC entry 5473 (class 0 OID 16576)
-- Dependencies: 221
-- Data for Name: product_variants; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.product_variants (sku, variant_title, fragrance, weight_grams, size_label, color, burn_time_hours, price, mrp, is_active, created_at, updated_at, deleted_at, created_by, updated_by, variant_id, product_id) FROM stdin;
CIN-160-V1	160g – Soy Wax Candle	Cinnamon Vanilla	160	Medium	White	35	499	599	t	2025-12-11 17:27:22.662896+05:30	2025-12-11 17:27:22.662896+05:30	\N	\N	\N	7a4739a1-6d2b-407e-8621-34097bab1d11	ea3b80e2-dd3b-4ba5-8b4a-8eba14b7e1dc
LAV-160-V1	160g – Soy Wax Candle	Lavender Haze	160	Medium	White	35	499	599	t	2025-12-11 17:27:22.662896+05:30	2025-12-11 17:27:22.662896+05:30	\N	\N	\N	cf59c7cf-3a97-4380-83fd-25ba800f2604	bbc419c4-d5b4-49da-920a-67dd5868e7a1
MAH-160-V1	160g – Soy Wax Candle	Mahogany Amber	160	Medium	White	35	499	599	t	2025-12-11 17:27:22.662896+05:30	2025-12-11 17:27:22.662896+05:30	\N	\N	\N	416f8e1c-89fb-4722-b49d-d703c6653c9f	abcdc1d8-c0f4-4f00-bde9-fd0f17b714cb
CAR-160-V1	160g – Soy Wax Candle	Caramel Caffeine	160	Medium	White	35	499	599	t	2025-12-11 17:27:22.662896+05:30	2025-12-11 17:27:22.662896+05:30	\N	\N	\N	4f675ce1-0bf2-4ff1-b98b-5b33964d35b1	160a90b6-e485-4a31-8150-306d453a3ef1
LIM-160-V1	160g – Soy Wax Candle	Lime Whisper	160	Medium	White	35	499	599	t	2025-12-11 17:27:22.662896+05:30	2025-12-11 17:27:22.662896+05:30	\N	\N	\N	4a9f0c42-475d-44b0-b47d-9626608b6832	ce452b75-f195-4e11-8595-5679576ec448
\.


--
-- TOC entry 5491 (class 0 OID 17324)
-- Dependencies: 239
-- Data for Name: product_visibility; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.product_visibility (visibility_id, product_id, show_on_home, show_in_collections, priority, valid_from, valid_to) FROM stdin;
\.


--
-- TOC entry 5472 (class 0 OID 16549)
-- Dependencies: 220
-- Data for Name: products; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.products (sku_base, product_name, slug, short_description, product_description, brand, search_keywords, is_active, created_at, updated_at, deleted_at, created_by, updated_by, search_vector, product_id, product_type_id, category_id, is_featured, is_manual_bestseller, seo_title, seo_description, seo_keywords) FROM stdin;
CIN-160	Cinnamon Vanilla Soy Candle	cinnamon-vanilla-candle	Soy wax candle – 160g – 35hr burn time.	Premium soy wax candle with warm cinnamon and sweet vanilla fragrance.	Chamakk	cinnamon, vanilla, candle, soy wax, aroma candle	t	2025-12-11 14:24:14.898941+05:30	2025-12-11 14:24:14.898941+05:30	\N	\N	\N	'160g':8B '35hr':9B 'and':19C 'aroma':28 'burn':10B 'candle':4A,7B,15C,25,29 'cinnamon':1A,18C,23 'fragrance':22C 'premium':12C 'soy':3A,5B,13C,26 'sweet':20C 'time':11B 'vanilla':2A,21C,24 'warm':17C 'wax':6B,14C,27 'with':16C	ea3b80e2-dd3b-4ba5-8b4a-8eba14b7e1dc	60362dc2-14e8-4e9d-8c87-511af867f9de	ff0ab5fd-44bf-4f56-a1f2-bdb92efd8593	f	f	\N	\N	\N
LAV-160	Lavender Haze Soy Candle	lavender-haze-candle	Relaxing lavender aroma – 160g – 35hr burn time.	Soft aromatic lavender fragrance for calm and relaxation.	Chamakk	lavender, haze, candle, soy wax, aroma candle	t	2025-12-11 14:24:14.898941+05:30	2025-12-11 14:24:14.898941+05:30	\N	\N	\N	'160g':8B '35hr':9B 'and':18C 'aroma':7B,25 'aromatic':13C 'burn':10B 'calm':17C 'candle':4A,22,26 'for':16C 'fragrance':15C 'haze':2A,21 'lavender':1A,6B,14C,20 'relaxation':19C 'relaxing':5B 'soft':12C 'soy':3A,23 'time':11B 'wax':24	bbc419c4-d5b4-49da-920a-67dd5868e7a1	60362dc2-14e8-4e9d-8c87-511af867f9de	ff0ab5fd-44bf-4f56-a1f2-bdb92efd8593	f	f	\N	\N	\N
MAH-160	Mahogany Amber Soy Candle	mahogany-amber-candle	Bold mahogany aroma – 160g – 35hr burn time.	Warm mahogany & amber blend for luxury home fragrance.	Chamakk	mahogany, amber, candle, soy wax, aroma candle	t	2025-12-11 14:24:14.898941+05:30	2025-12-11 14:24:14.898941+05:30	\N	\N	\N	'160g':8B '35hr':9B 'amber':2A,14C,21 'aroma':7B,25 'blend':15C 'bold':5B 'burn':10B 'candle':4A,22,26 'for':16C 'fragrance':19C 'home':18C 'luxury':17C 'mahogany':1A,6B,13C,20 'soy':3A,23 'time':11B 'warm':12C 'wax':24	abcdc1d8-c0f4-4f00-bde9-fd0f17b714cb	60362dc2-14e8-4e9d-8c87-511af867f9de	ff0ab5fd-44bf-4f56-a1f2-bdb92efd8593	f	f	\N	\N	\N
CAR-160	Caramel Caffeine Soy Candle	caramel-caffeine-candle	Coffee + caramel aroma – 160g – 35hr burn time.	Rich caramel and roasted coffee fragrance.	Chamakk	caramel, coffee, caffeine, candle, soy wax, aroma candle	t	2025-12-11 14:24:14.898941+05:30	2025-12-11 14:24:14.898941+05:30	\N	\N	\N	'160g':8B '35hr':9B 'and':14C 'aroma':7B,24 'burn':10B 'caffeine':2A,20 'candle':4A,21,25 'caramel':1A,6B,13C,18 'coffee':5B,16C,19 'fragrance':17C 'rich':12C 'roasted':15C 'soy':3A,22 'time':11B 'wax':23	160a90b6-e485-4a31-8150-306d453a3ef1	60362dc2-14e8-4e9d-8c87-511af867f9de	ff0ab5fd-44bf-4f56-a1f2-bdb92efd8593	f	f	\N	\N	\N
LIM-160	Lime Whisper Soy Candle	lime-whisper-candle	Fresh lime aroma – 160g – 35hr burn time.	Refreshing lime and citrus aroma for summer.	Chamakk	lime, citrus, candle, soy wax, aroma candle	t	2025-12-11 14:24:14.898941+05:30	2025-12-11 14:24:14.898941+05:30	\N	\N	\N	'160g':8B '35hr':9B 'and':14C 'aroma':7B,16C,24 'burn':10B 'candle':4A,21,25 'citrus':15C,20 'for':17C 'fresh':5B 'lime':1A,6B,13C,19 'refreshing':12C 'soy':3A,22 'summer':18C 'time':11B 'wax':23 'whisper':2A	ce452b75-f195-4e11-8595-5679576ec448	60362dc2-14e8-4e9d-8c87-511af867f9de	ff0ab5fd-44bf-4f56-a1f2-bdb92efd8593	f	f	\N	\N	\N
\.


--
-- TOC entry 5504 (class 0 OID 17525)
-- Dependencies: 252
-- Data for Name: refunds; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.refunds (refund_id, order_id, payment_id, refund_amount, refund_reason, refund_status, processed_at, created_at) FROM stdin;
\.


--
-- TOC entry 5505 (class 0 OID 17538)
-- Dependencies: 253
-- Data for Name: reviews; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.reviews (review_id, product_id, user_id, rating, comment, is_approved, created_at) FROM stdin;
\.


--
-- TOC entry 5484 (class 0 OID 17178)
-- Dependencies: 232
-- Data for Name: role_permissions; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.role_permissions (role_permission_id, role_id, permission_id, created_at) FROM stdin;
21647649-18df-41a4-b534-2341a1111465	7e540a8f-6888-4323-bf43-5bfb0fa2e234	0edf2ef9-8a44-4ae9-918d-850f71e10913	2025-12-21 22:19:10.582863+05:30
e65bd930-24dd-4b22-a03b-6e25bcd096d6	7e540a8f-6888-4323-bf43-5bfb0fa2e234	82c0be24-8d72-4c42-97e9-11b567d4e6b1	2025-12-21 22:19:10.582863+05:30
1c0b4d27-2e5f-4517-877f-0fe19e1840d2	7e540a8f-6888-4323-bf43-5bfb0fa2e234	d4365ebe-269f-4c92-a9ac-ac5e290513a6	2025-12-21 22:19:10.582863+05:30
\.


--
-- TOC entry 5482 (class 0 OID 17156)
-- Dependencies: 230
-- Data for Name: roles; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.roles (role_id, role_name, description, created_at) FROM stdin;
7e540a8f-6888-4323-bf43-5bfb0fa2e234	ADMIN	Standard admin	2025-12-21 22:18:22.891166+05:30
5354dbf2-6ec4-49d6-be66-2ac126f6bbfb	SUPER_ADMIN	Full system access	2025-12-21 22:18:22.891166+05:30
\.


--
-- TOC entry 5510 (class 0 OID 17598)
-- Dependencies: 258
-- Data for Name: settings; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.settings (setting_key, setting_value, updated_at) FROM stdin;
\.


--
-- TOC entry 5476 (class 0 OID 16639)
-- Dependencies: 224
-- Data for Name: tags; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.tags (tag_name, created_at, tag_id) FROM stdin;
\.


--
-- TOC entry 5488 (class 0 OID 17275)
-- Dependencies: 236
-- Data for Name: user_roles; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.user_roles (user_role_id, user_id, role_id, assigned_at) FROM stdin;
78212c6c-e545-4838-8518-496e2ac4e78d	f7bfbd7f-e8a6-49f9-b12f-2205b06d6c6a	7e540a8f-6888-4323-bf43-5bfb0fa2e234	2025-12-26 22:44:17.797611+05:30
\.


--
-- TOC entry 5511 (class 0 OID 17658)
-- Dependencies: 259
-- Data for Name: user_sessions; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.user_sessions (session_id, user_id, refresh_token, device_id, device_type, ip_address, user_agent, status, created_at, last_used_at, expires_at, revoked_reason) FROM stdin;
\.


--
-- TOC entry 5469 (class 0 OID 16484)
-- Dependencies: 217
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.users (full_name, email, mobile, created_at, is_active, updated_at, user_id, password_hash, role_id) FROM stdin;
Vishal Gndhi	admin@chamakk.com	9999999999	2025-12-13 20:20:27.531375+05:30	t	2025-12-13 20:20:27.531375+05:30	f7bfbd7f-e8a6-49f9-b12f-2205b06d6c6a	{bcrypt}$2a$10$vGzJ7EA3dW9q3./mErsxYenYFSNr3RhQ0s9KhUzcBQ0vnj4hEHoc2	7e540a8f-6888-4323-bf43-5bfb0fa2e234
\.


--
-- TOC entry 5474 (class 0 OID 16600)
-- Dependencies: 222
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
-- TOC entry 5481 (class 0 OID 16716)
-- Dependencies: 229
-- Data for Name: website_media; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.website_media (website_media_title, website_media_type, website_media_url, page_section, alt_text, is_active, "position", created_at, website_media_id) FROM stdin;
Homepage Intro Video	video	https://res.cloudinary.com/dtz1gpnge/video/upload/v1765340893/intro_h4p4xo.mp4	homepage	Chamakk intro brand video	t	1	2025-12-10 10:04:30.769996	e7cf85a3-8655-4db8-ba94-b2ee54d70bde
\.


--
-- TOC entry 5506 (class 0 OID 17561)
-- Dependencies: 254
-- Data for Name: wishlists; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.wishlists (wishlist_id, user_id, product_id, created_at) FROM stdin;
\.


--
-- TOC entry 5270 (class 2606 OID 17597)
-- Name: activity_logs activity_logs_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.activity_logs
    ADD CONSTRAINT activity_logs_pkey PRIMARY KEY (log_id);


--
-- TOC entry 5223 (class 2606 OID 17429)
-- Name: addresses addresses_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.addresses
    ADD CONSTRAINT addresses_pkey PRIMARY KEY (address_id);


--
-- TOC entry 5186 (class 2606 OID 17260)
-- Name: cart_items cart_items_cart_id_variant_id_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cart_items
    ADD CONSTRAINT cart_items_cart_id_variant_id_key UNIQUE (cart_id, variant_id);


--
-- TOC entry 5188 (class 2606 OID 17258)
-- Name: cart_items cart_items_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cart_items
    ADD CONSTRAINT cart_items_pkey PRIMARY KEY (cart_item_id);


--
-- TOC entry 5177 (class 2606 OID 17243)
-- Name: carts carts_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.carts
    ADD CONSTRAINT carts_pkey PRIMARY KEY (cart_id);


--
-- TOC entry 5179 (class 2606 OID 17245)
-- Name: carts carts_user_id_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.carts
    ADD CONSTRAINT carts_user_id_key UNIQUE (user_id);


--
-- TOC entry 5101 (class 2606 OID 16886)
-- Name: categories categories_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.categories
    ADD CONSTRAINT categories_pkey PRIMARY KEY (category_id);


--
-- TOC entry 5103 (class 2606 OID 16540)
-- Name: categories categories_slug_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.categories
    ADD CONSTRAINT categories_slug_key UNIQUE (slug);


--
-- TOC entry 5268 (class 2606 OID 17588)
-- Name: contact_submissions contact_submissions_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.contact_submissions
    ADD CONSTRAINT contact_submissions_pkey PRIMARY KEY (submission_id);


--
-- TOC entry 5247 (class 2606 OID 17509)
-- Name: coupon_usage coupon_usage_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.coupon_usage
    ADD CONSTRAINT coupon_usage_pkey PRIMARY KEY (coupon_usage_id);


--
-- TOC entry 5241 (class 2606 OID 17502)
-- Name: coupons coupons_coupon_code_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.coupons
    ADD CONSTRAINT coupons_coupon_code_key UNIQUE (coupon_code);


--
-- TOC entry 5243 (class 2606 OID 17500)
-- Name: coupons coupons_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.coupons
    ADD CONSTRAINT coupons_pkey PRIMARY KEY (coupon_id);


--
-- TOC entry 5228 (class 2606 OID 17445)
-- Name: customer_profile customer_profile_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.customer_profile
    ADD CONSTRAINT customer_profile_pkey PRIMARY KEY (user_id);


--
-- TOC entry 5238 (class 2606 OID 17479)
-- Name: discount_products discount_products_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.discount_products
    ADD CONSTRAINT discount_products_pkey PRIMARY KEY (discount_id, product_id);


--
-- TOC entry 5235 (class 2606 OID 17474)
-- Name: discounts discounts_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.discounts
    ADD CONSTRAINT discounts_pkey PRIMARY KEY (discount_id);


--
-- TOC entry 5195 (class 2606 OID 17302)
-- Name: failed_login_attempts failed_login_attempts_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.failed_login_attempts
    ADD CONSTRAINT failed_login_attempts_pkey PRIMARY KEY (attempt_id);


--
-- TOC entry 5172 (class 2606 OID 17228)
-- Name: inventory inventory_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.inventory
    ADD CONSTRAINT inventory_pkey PRIMARY KEY (inventory_id);


--
-- TOC entry 5174 (class 2606 OID 17230)
-- Name: inventory inventory_variant_id_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.inventory
    ADD CONSTRAINT inventory_variant_id_key UNIQUE (variant_id);


--
-- TOC entry 5079 (class 2606 OID 16888)
-- Name: login_session login_session_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.login_session
    ADD CONSTRAINT login_session_pkey PRIMARY KEY (session_id);


--
-- TOC entry 5264 (class 2606 OID 17579)
-- Name: newsletter_subscribers newsletter_subscribers_email_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.newsletter_subscribers
    ADD CONSTRAINT newsletter_subscribers_email_key UNIQUE (email);


--
-- TOC entry 5266 (class 2606 OID 17577)
-- Name: newsletter_subscribers newsletter_subscribers_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.newsletter_subscribers
    ADD CONSTRAINT newsletter_subscribers_pkey PRIMARY KEY (subscriber_id);


--
-- TOC entry 5232 (class 2606 OID 17460)
-- Name: order_addresses order_addresses_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.order_addresses
    ADD CONSTRAINT order_addresses_pkey PRIMARY KEY (order_address_id);


--
-- TOC entry 5215 (class 2606 OID 17377)
-- Name: order_items order_items_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.order_items
    ADD CONSTRAINT order_items_pkey PRIMARY KEY (order_item_id);


--
-- TOC entry 5217 (class 2606 OID 17390)
-- Name: order_status_history order_status_history_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.order_status_history
    ADD CONSTRAINT order_status_history_pkey PRIMARY KEY (history_id);


--
-- TOC entry 5210 (class 2606 OID 17369)
-- Name: orders orders_order_number_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.orders
    ADD CONSTRAINT orders_order_number_key UNIQUE (order_number);


--
-- TOC entry 5212 (class 2606 OID 17367)
-- Name: orders orders_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.orders
    ADD CONSTRAINT orders_pkey PRIMARY KEY (order_id);


--
-- TOC entry 5200 (class 2606 OID 17312)
-- Name: password_reset_tokens password_reset_tokens_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.password_reset_tokens
    ADD CONSTRAINT password_reset_tokens_pkey PRIMARY KEY (reset_id);


--
-- TOC entry 5202 (class 2606 OID 17314)
-- Name: password_reset_tokens password_reset_tokens_token_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.password_reset_tokens
    ADD CONSTRAINT password_reset_tokens_token_key UNIQUE (token);


--
-- TOC entry 5221 (class 2606 OID 17403)
-- Name: payments payments_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.payments
    ADD CONSTRAINT payments_pkey PRIMARY KEY (payment_id);


--
-- TOC entry 5161 (class 2606 OID 17218)
-- Name: permissions permissions_code_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.permissions
    ADD CONSTRAINT permissions_code_key UNIQUE (permission_code);


--
-- TOC entry 5163 (class 2606 OID 17177)
-- Name: permissions permissions_permission_code_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.permissions
    ADD CONSTRAINT permissions_permission_code_key UNIQUE (permission_code);


--
-- TOC entry 5165 (class 2606 OID 17175)
-- Name: permissions permissions_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.permissions
    ADD CONSTRAINT permissions_pkey PRIMARY KEY (permission_id);


--
-- TOC entry 5206 (class 2606 OID 17343)
-- Name: product_bundle_items product_bundle_items_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product_bundle_items
    ADD CONSTRAINT product_bundle_items_pkey PRIMARY KEY (bundle_id, child_product_id);


--
-- TOC entry 5153 (class 2606 OID 16904)
-- Name: product_discounts product_discounts_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product_discounts
    ADD CONSTRAINT product_discounts_pkey PRIMARY KEY (product_discount_id);


--
-- TOC entry 5134 (class 2606 OID 16911)
-- Name: product_images product_images_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product_images
    ADD CONSTRAINT product_images_pkey PRIMARY KEY (product_image_id);


--
-- TOC entry 5151 (class 2606 OID 16930)
-- Name: product_price_history product_price_history_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product_price_history
    ADD CONSTRAINT product_price_history_pkey PRIMARY KEY (product_price_history_id);


--
-- TOC entry 5147 (class 2606 OID 16937)
-- Name: product_stock_log product_stock_log_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product_stock_log
    ADD CONSTRAINT product_stock_log_pkey PRIMARY KEY (log_id);


--
-- TOC entry 5143 (class 2606 OID 16998)
-- Name: product_tags product_tags_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product_tags
    ADD CONSTRAINT product_tags_pkey PRIMARY KEY (product_id, tag_id);


--
-- TOC entry 5096 (class 2606 OID 16897)
-- Name: product_types product_types_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product_types
    ADD CONSTRAINT product_types_pkey PRIMARY KEY (product_type_id);


--
-- TOC entry 5098 (class 2606 OID 16526)
-- Name: product_types product_types_product_type_name_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product_types
    ADD CONSTRAINT product_types_product_type_name_key UNIQUE (product_type_name);


--
-- TOC entry 5124 (class 2606 OID 16918)
-- Name: product_variants product_variants_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product_variants
    ADD CONSTRAINT product_variants_pkey PRIMARY KEY (variant_id);


--
-- TOC entry 5126 (class 2606 OID 17098)
-- Name: product_variants product_variants_sku_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product_variants
    ADD CONSTRAINT product_variants_sku_key UNIQUE (sku);


--
-- TOC entry 5204 (class 2606 OID 17332)
-- Name: product_visibility product_visibility_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product_visibility
    ADD CONSTRAINT product_visibility_pkey PRIMARY KEY (visibility_id);


--
-- TOC entry 5115 (class 2606 OID 16890)
-- Name: products products_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.products
    ADD CONSTRAINT products_pkey PRIMARY KEY (product_id);


--
-- TOC entry 5117 (class 2606 OID 17142)
-- Name: products products_slug_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.products
    ADD CONSTRAINT products_slug_key UNIQUE (slug);


--
-- TOC entry 5251 (class 2606 OID 17532)
-- Name: refunds refunds_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.refunds
    ADD CONSTRAINT refunds_pkey PRIMARY KEY (refund_id);


--
-- TOC entry 5255 (class 2606 OID 17548)
-- Name: reviews reviews_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.reviews
    ADD CONSTRAINT reviews_pkey PRIMARY KEY (review_id);


--
-- TOC entry 5257 (class 2606 OID 17550)
-- Name: reviews reviews_product_id_user_id_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.reviews
    ADD CONSTRAINT reviews_product_id_user_id_key UNIQUE (product_id, user_id);


--
-- TOC entry 5167 (class 2606 OID 17184)
-- Name: role_permissions role_permissions_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.role_permissions
    ADD CONSTRAINT role_permissions_pkey PRIMARY KEY (role_permission_id);


--
-- TOC entry 5157 (class 2606 OID 17164)
-- Name: roles roles_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.roles
    ADD CONSTRAINT roles_pkey PRIMARY KEY (role_id);


--
-- TOC entry 5159 (class 2606 OID 17214)
-- Name: roles roles_role_name_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.roles
    ADD CONSTRAINT roles_role_name_key UNIQUE (role_name);


--
-- TOC entry 5275 (class 2606 OID 17605)
-- Name: settings settings_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.settings
    ADD CONSTRAINT settings_pkey PRIMARY KEY (setting_key);


--
-- TOC entry 5136 (class 2606 OID 16951)
-- Name: tags tags_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tags
    ADD CONSTRAINT tags_pkey PRIMARY KEY (tag_id);


--
-- TOC entry 5138 (class 2606 OID 16647)
-- Name: tags tags_tag_name_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tags
    ADD CONSTRAINT tags_tag_name_key UNIQUE (tag_name);


--
-- TOC entry 5183 (class 2606 OID 17356)
-- Name: carts uq_cart_user; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.carts
    ADD CONSTRAINT uq_cart_user UNIQUE (user_id);


--
-- TOC entry 5169 (class 2606 OID 17186)
-- Name: role_permissions uq_role_permission; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.role_permissions
    ADD CONSTRAINT uq_role_permission UNIQUE (role_id, permission_id);


--
-- TOC entry 5191 (class 2606 OID 17283)
-- Name: user_roles uq_user_role; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_roles
    ADD CONSTRAINT uq_user_role UNIQUE (user_id, role_id);


--
-- TOC entry 5084 (class 2606 OID 17272)
-- Name: users uq_users_email; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT uq_users_email UNIQUE (email);


--
-- TOC entry 5086 (class 2606 OID 17274)
-- Name: users uq_users_mobile; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT uq_users_mobile UNIQUE (mobile);


--
-- TOC entry 5193 (class 2606 OID 17281)
-- Name: user_roles user_roles_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_roles
    ADD CONSTRAINT user_roles_pkey PRIMARY KEY (user_role_id);


--
-- TOC entry 5280 (class 2606 OID 17667)
-- Name: user_sessions user_sessions_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_sessions
    ADD CONSTRAINT user_sessions_pkey PRIMARY KEY (session_id);


--
-- TOC entry 5282 (class 2606 OID 17669)
-- Name: user_sessions user_sessions_refresh_token_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_sessions
    ADD CONSTRAINT user_sessions_refresh_token_key UNIQUE (refresh_token);


--
-- TOC entry 5088 (class 2606 OID 16501)
-- Name: users users_email_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_key UNIQUE (email);


--
-- TOC entry 5090 (class 2606 OID 16503)
-- Name: users users_mobile_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_mobile_key UNIQUE (mobile);


--
-- TOC entry 5092 (class 2606 OID 16955)
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (user_id);


--
-- TOC entry 5129 (class 2606 OID 16962)
-- Name: variant_attributes variant_attributes_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.variant_attributes
    ADD CONSTRAINT variant_attributes_pkey PRIMARY KEY (attribute_id);


--
-- TOC entry 5155 (class 2606 OID 16970)
-- Name: website_media website_media_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.website_media
    ADD CONSTRAINT website_media_pkey PRIMARY KEY (website_media_id);


--
-- TOC entry 5260 (class 2606 OID 17567)
-- Name: wishlists wishlists_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.wishlists
    ADD CONSTRAINT wishlists_pkey PRIMARY KEY (wishlist_id);


--
-- TOC entry 5262 (class 2606 OID 17569)
-- Name: wishlists wishlists_user_id_product_id_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.wishlists
    ADD CONSTRAINT wishlists_user_id_product_id_key UNIQUE (user_id, product_id);


--
-- TOC entry 5271 (class 1259 OID 17657)
-- Name: idx_activity_date; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_activity_date ON public.activity_logs USING btree (created_at DESC);


--
-- TOC entry 5272 (class 1259 OID 17656)
-- Name: idx_activity_entity; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_activity_entity ON public.activity_logs USING btree (entity_type, entity_id);


--
-- TOC entry 5273 (class 1259 OID 17655)
-- Name: idx_activity_user; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_activity_user ON public.activity_logs USING btree (user_id);


--
-- TOC entry 5224 (class 1259 OID 17435)
-- Name: idx_addresses_user; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_addresses_user ON public.addresses USING btree (user_id);


--
-- TOC entry 5189 (class 1259 OID 17410)
-- Name: idx_cart_items_cart; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_cart_items_cart ON public.cart_items USING btree (cart_id);


--
-- TOC entry 5180 (class 1259 OID 17409)
-- Name: idx_cart_user; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_cart_user ON public.carts USING btree (user_id);


--
-- TOC entry 5181 (class 1259 OID 17646)
-- Name: idx_carts_updated; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_carts_updated ON public.carts USING btree (updated_at DESC);


--
-- TOC entry 5104 (class 1259 OID 17615)
-- Name: idx_categories_active; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_categories_active ON public.categories USING btree (is_active);


--
-- TOC entry 5105 (class 1259 OID 16547)
-- Name: idx_categories_name; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_categories_name ON public.categories USING btree (categorie_name);


--
-- TOC entry 5106 (class 1259 OID 17614)
-- Name: idx_categories_parent; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_categories_parent ON public.categories USING btree (parent_id);


--
-- TOC entry 5248 (class 1259 OID 17638)
-- Name: idx_coupon_usage_coupon; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_coupon_usage_coupon ON public.coupon_usage USING btree (coupon_id);


--
-- TOC entry 5249 (class 1259 OID 17637)
-- Name: idx_coupon_usage_user; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_coupon_usage_user ON public.coupon_usage USING btree (user_id);


--
-- TOC entry 5244 (class 1259 OID 17636)
-- Name: idx_coupons_active_dates; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_coupons_active_dates ON public.coupons USING btree (is_active, start_date, end_date);


--
-- TOC entry 5229 (class 1259 OID 17650)
-- Name: idx_customer_profile_orders; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_customer_profile_orders ON public.customer_profile USING btree (total_orders DESC);


--
-- TOC entry 5230 (class 1259 OID 17651)
-- Name: idx_customer_profile_spent; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_customer_profile_spent ON public.customer_profile USING btree (total_spent DESC);


--
-- TOC entry 5239 (class 1259 OID 17634)
-- Name: idx_discount_products_product; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_discount_products_product ON public.discount_products USING btree (product_id);


--
-- TOC entry 5236 (class 1259 OID 17633)
-- Name: idx_discounts_active_dates; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_discounts_active_dates ON public.discounts USING btree (is_active, start_date, end_date);


--
-- TOC entry 5196 (class 1259 OID 17303)
-- Name: idx_failed_login_email; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_failed_login_email ON public.failed_login_attempts USING btree (email);


--
-- TOC entry 5197 (class 1259 OID 17304)
-- Name: idx_failed_login_ip; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_failed_login_ip ON public.failed_login_attempts USING btree (ip_address);


--
-- TOC entry 5170 (class 1259 OID 17640)
-- Name: idx_inventory_low_stock; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_inventory_low_stock ON public.inventory USING btree (available_quantity) WHERE (available_quantity <= low_stock_threshold);


--
-- TOC entry 5076 (class 1259 OID 16506)
-- Name: idx_login_session_mobile; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_login_session_mobile ON public.login_session USING btree (mobile);


--
-- TOC entry 5077 (class 1259 OID 17295)
-- Name: idx_login_session_mobile_active; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_login_session_mobile_active ON public.login_session USING btree (mobile, is_verified);


--
-- TOC entry 5213 (class 1259 OID 17413)
-- Name: idx_order_items_order; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_order_items_order ON public.order_items USING btree (order_id);


--
-- TOC entry 5207 (class 1259 OID 17412)
-- Name: idx_orders_status; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_orders_status ON public.orders USING btree (status);


--
-- TOC entry 5208 (class 1259 OID 17411)
-- Name: idx_orders_user; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_orders_user ON public.orders USING btree (user_id);


--
-- TOC entry 5218 (class 1259 OID 17414)
-- Name: idx_payments_order; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_payments_order ON public.payments USING btree (order_id);


--
-- TOC entry 5219 (class 1259 OID 17415)
-- Name: idx_payments_status; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_payments_status ON public.payments USING btree (status);


--
-- TOC entry 5148 (class 1259 OID 17644)
-- Name: idx_price_history_date; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_price_history_date ON public.product_price_history USING btree (changed_at DESC);


--
-- TOC entry 5149 (class 1259 OID 17643)
-- Name: idx_price_history_variant; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_price_history_variant ON public.product_price_history USING btree (variant_id);


--
-- TOC entry 5130 (class 1259 OID 17629)
-- Name: idx_product_images_primary; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_product_images_primary ON public.product_images USING btree (is_primary) WHERE (is_primary = true);


--
-- TOC entry 5131 (class 1259 OID 17627)
-- Name: idx_product_images_product; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_product_images_product ON public.product_images USING btree (product_id);


--
-- TOC entry 5132 (class 1259 OID 17628)
-- Name: idx_product_images_variant; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_product_images_variant ON public.product_images USING btree (variant_id);


--
-- TOC entry 5140 (class 1259 OID 17631)
-- Name: idx_product_tags_product; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_product_tags_product ON public.product_tags USING btree (product_id);


--
-- TOC entry 5141 (class 1259 OID 17632)
-- Name: idx_product_tags_tag; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_product_tags_tag ON public.product_tags USING btree (tag_id);


--
-- TOC entry 5108 (class 1259 OID 16695)
-- Name: idx_products_active; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_products_active ON public.products USING btree (is_active);


--
-- TOC entry 5109 (class 1259 OID 17621)
-- Name: idx_products_category; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_products_category ON public.products USING btree (category_id);


--
-- TOC entry 5110 (class 1259 OID 17623)
-- Name: idx_products_created; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_products_created ON public.products USING btree (created_at DESC);


--
-- TOC entry 5111 (class 1259 OID 17120)
-- Name: idx_products_name; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_products_name ON public.products USING gin (to_tsvector('simple'::regconfig, (product_name)::text));


--
-- TOC entry 5112 (class 1259 OID 16692)
-- Name: idx_products_search_vector; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_products_search_vector ON public.products USING gin (search_vector);


--
-- TOC entry 5113 (class 1259 OID 17622)
-- Name: idx_products_type; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_products_type ON public.products USING btree (product_type_id);


--
-- TOC entry 5198 (class 1259 OID 17320)
-- Name: idx_reset_token; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_reset_token ON public.password_reset_tokens USING btree (token);


--
-- TOC entry 5252 (class 1259 OID 17653)
-- Name: idx_reviews_approved; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_reviews_approved ON public.reviews USING btree (is_approved);


--
-- TOC entry 5253 (class 1259 OID 17652)
-- Name: idx_reviews_product; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_reviews_product ON public.reviews USING btree (product_id);


--
-- TOC entry 5144 (class 1259 OID 17642)
-- Name: idx_stock_log_created; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_stock_log_created ON public.product_stock_log USING btree (created_at DESC);


--
-- TOC entry 5145 (class 1259 OID 17641)
-- Name: idx_stock_log_variant; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_stock_log_variant ON public.product_stock_log USING btree (variant_id);


--
-- TOC entry 5276 (class 1259 OID 17677)
-- Name: idx_user_sessions_expires; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_user_sessions_expires ON public.user_sessions USING btree (expires_at);


--
-- TOC entry 5277 (class 1259 OID 17676)
-- Name: idx_user_sessions_status; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_user_sessions_status ON public.user_sessions USING btree (status);


--
-- TOC entry 5278 (class 1259 OID 17675)
-- Name: idx_user_sessions_user; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_user_sessions_user ON public.user_sessions USING btree (user_id);


--
-- TOC entry 5080 (class 1259 OID 17609)
-- Name: idx_users_active; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_users_active ON public.users USING btree (is_active);


--
-- TOC entry 5081 (class 1259 OID 16508)
-- Name: idx_users_mobile; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_users_mobile ON public.users USING btree (mobile);


--
-- TOC entry 5082 (class 1259 OID 17608)
-- Name: idx_users_role; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_users_role ON public.users USING btree (role_id);


--
-- TOC entry 5127 (class 1259 OID 16615)
-- Name: idx_variant_attr_name; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_variant_attr_name ON public.variant_attributes USING btree (attribute_name);


--
-- TOC entry 5119 (class 1259 OID 16697)
-- Name: idx_variants_active; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_variants_active ON public.product_variants USING btree (is_active);


--
-- TOC entry 5120 (class 1259 OID 17626)
-- Name: idx_variants_price; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_variants_price ON public.product_variants USING btree (price);


--
-- TOC entry 5121 (class 1259 OID 17625)
-- Name: idx_variants_product; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_variants_product ON public.product_variants USING btree (product_id);


--
-- TOC entry 5122 (class 1259 OID 17099)
-- Name: idx_variants_sku; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_variants_sku ON public.product_variants USING btree (sku);


--
-- TOC entry 5184 (class 1259 OID 17645)
-- Name: ux_carts_user; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX ux_carts_user ON public.carts USING btree (user_id);


--
-- TOC entry 5107 (class 1259 OID 17613)
-- Name: ux_categories_slug; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX ux_categories_slug ON public.categories USING btree (slug);


--
-- TOC entry 5245 (class 1259 OID 17635)
-- Name: ux_coupons_code; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX ux_coupons_code ON public.coupons USING btree (coupon_code);


--
-- TOC entry 5225 (class 1259 OID 17649)
-- Name: ux_default_address; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX ux_default_address ON public.addresses USING btree (user_id) WHERE (is_default = true);


--
-- TOC entry 5226 (class 1259 OID 17436)
-- Name: ux_default_address_per_user; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX ux_default_address_per_user ON public.addresses USING btree (user_id) WHERE (is_default = true);


--
-- TOC entry 5175 (class 1259 OID 17639)
-- Name: ux_inventory_variant; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX ux_inventory_variant ON public.inventory USING btree (variant_id);


--
-- TOC entry 5233 (class 1259 OID 17648)
-- Name: ux_order_addresses_order; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX ux_order_addresses_order ON public.order_addresses USING btree (order_id);


--
-- TOC entry 5099 (class 1259 OID 17616)
-- Name: ux_product_types_name; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX ux_product_types_name ON public.product_types USING btree (product_type_name);


--
-- TOC entry 5118 (class 1259 OID 17620)
-- Name: ux_products_slug; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX ux_products_slug ON public.products USING btree (slug);


--
-- TOC entry 5139 (class 1259 OID 17630)
-- Name: ux_tags_name; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX ux_tags_name ON public.tags USING btree (tag_name);


--
-- TOC entry 5093 (class 1259 OID 17606)
-- Name: ux_users_email; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX ux_users_email ON public.users USING btree (email);


--
-- TOC entry 5094 (class 1259 OID 17607)
-- Name: ux_users_mobile; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX ux_users_mobile ON public.users USING btree (mobile);


--
-- TOC entry 5258 (class 1259 OID 17654)
-- Name: ux_wishlist_user_product; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX ux_wishlist_user_product ON public.wishlists USING btree (user_id, product_id);


--
-- TOC entry 5324 (class 2620 OID 16694)
-- Name: products trg_products_search_vector; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trg_products_search_vector BEFORE INSERT OR UPDATE ON public.products FOR EACH ROW EXECUTE FUNCTION public.products_search_vector_trigger();


--
-- TOC entry 5312 (class 2606 OID 17430)
-- Name: addresses fk_address_user; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.addresses
    ADD CONSTRAINT fk_address_user FOREIGN KEY (user_id) REFERENCES public.users(user_id) ON DELETE CASCADE;


--
-- TOC entry 5307 (class 2606 OID 17349)
-- Name: product_bundle_items fk_bundle_child; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product_bundle_items
    ADD CONSTRAINT fk_bundle_child FOREIGN KEY (child_product_id) REFERENCES public.products(product_id) ON DELETE CASCADE;


--
-- TOC entry 5308 (class 2606 OID 17344)
-- Name: product_bundle_items fk_bundle_parent; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product_bundle_items
    ADD CONSTRAINT fk_bundle_parent FOREIGN KEY (bundle_id) REFERENCES public.products(product_id) ON DELETE CASCADE;


--
-- TOC entry 5301 (class 2606 OID 17261)
-- Name: cart_items fk_cart_item_cart; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cart_items
    ADD CONSTRAINT fk_cart_item_cart FOREIGN KEY (cart_id) REFERENCES public.carts(cart_id);


--
-- TOC entry 5302 (class 2606 OID 17266)
-- Name: cart_items fk_cart_item_variant; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cart_items
    ADD CONSTRAINT fk_cart_item_variant FOREIGN KEY (variant_id) REFERENCES public.product_variants(variant_id);


--
-- TOC entry 5300 (class 2606 OID 17246)
-- Name: carts fk_cart_user; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.carts
    ADD CONSTRAINT fk_cart_user FOREIGN KEY (user_id) REFERENCES public.users(user_id);


--
-- TOC entry 5317 (class 2606 OID 17510)
-- Name: coupon_usage fk_coupon_usage_coupon; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.coupon_usage
    ADD CONSTRAINT fk_coupon_usage_coupon FOREIGN KEY (coupon_id) REFERENCES public.coupons(coupon_id);


--
-- TOC entry 5318 (class 2606 OID 17520)
-- Name: coupon_usage fk_coupon_usage_order; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.coupon_usage
    ADD CONSTRAINT fk_coupon_usage_order FOREIGN KEY (order_id) REFERENCES public.orders(order_id);


--
-- TOC entry 5319 (class 2606 OID 17515)
-- Name: coupon_usage fk_coupon_usage_user; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.coupon_usage
    ADD CONSTRAINT fk_coupon_usage_user FOREIGN KEY (user_id) REFERENCES public.users(user_id);


--
-- TOC entry 5313 (class 2606 OID 17446)
-- Name: customer_profile fk_customer_profile_user; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.customer_profile
    ADD CONSTRAINT fk_customer_profile_user FOREIGN KEY (user_id) REFERENCES public.users(user_id) ON DELETE CASCADE;


--
-- TOC entry 5315 (class 2606 OID 17480)
-- Name: discount_products fk_dp_discount; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.discount_products
    ADD CONSTRAINT fk_dp_discount FOREIGN KEY (discount_id) REFERENCES public.discounts(discount_id) ON DELETE CASCADE;


--
-- TOC entry 5316 (class 2606 OID 17485)
-- Name: discount_products fk_dp_product; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.discount_products
    ADD CONSTRAINT fk_dp_product FOREIGN KEY (product_id) REFERENCES public.products(product_id) ON DELETE CASCADE;


--
-- TOC entry 5299 (class 2606 OID 17231)
-- Name: inventory fk_inventory_variant; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.inventory
    ADD CONSTRAINT fk_inventory_variant FOREIGN KEY (variant_id) REFERENCES public.product_variants(variant_id);


--
-- TOC entry 5314 (class 2606 OID 17461)
-- Name: order_addresses fk_order_address_order; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.order_addresses
    ADD CONSTRAINT fk_order_address_order FOREIGN KEY (order_id) REFERENCES public.orders(order_id) ON DELETE CASCADE;


--
-- TOC entry 5297 (class 2606 OID 17192)
-- Name: role_permissions fk_permission; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.role_permissions
    ADD CONSTRAINT fk_permission FOREIGN KEY (permission_id) REFERENCES public.permissions(permission_id) ON DELETE CASCADE;


--
-- TOC entry 5294 (class 2606 OID 17019)
-- Name: product_price_history fk_price_changed_by_user; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product_price_history
    ADD CONSTRAINT fk_price_changed_by_user FOREIGN KEY (changed_by) REFERENCES public.users(user_id);


--
-- TOC entry 5284 (class 2606 OID 16898)
-- Name: products fk_product_types; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.products
    ADD CONSTRAINT fk_product_types FOREIGN KEY (product_type_id) REFERENCES public.product_types(product_type_id);


--
-- TOC entry 5288 (class 2606 OID 16924)
-- Name: product_images fk_product_variants; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product_images
    ADD CONSTRAINT fk_product_variants FOREIGN KEY (variant_id) REFERENCES public.product_variants(variant_id);


--
-- TOC entry 5295 (class 2606 OID 16931)
-- Name: product_price_history fk_product_variants; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product_price_history
    ADD CONSTRAINT fk_product_variants FOREIGN KEY (variant_id) REFERENCES public.product_variants(variant_id);


--
-- TOC entry 5292 (class 2606 OID 16938)
-- Name: product_stock_log fk_product_variants; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product_stock_log
    ADD CONSTRAINT fk_product_variants FOREIGN KEY (variant_id) REFERENCES public.product_variants(variant_id);


--
-- TOC entry 5287 (class 2606 OID 16963)
-- Name: variant_attributes fk_product_variants; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.variant_attributes
    ADD CONSTRAINT fk_product_variants FOREIGN KEY (variant_id) REFERENCES public.product_variants(variant_id);


--
-- TOC entry 5296 (class 2606 OID 16905)
-- Name: product_discounts fk_products; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product_discounts
    ADD CONSTRAINT fk_products FOREIGN KEY (product_id) REFERENCES public.products(product_id);


--
-- TOC entry 5289 (class 2606 OID 16912)
-- Name: product_images fk_products; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product_images
    ADD CONSTRAINT fk_products FOREIGN KEY (product_id) REFERENCES public.products(product_id);


--
-- TOC entry 5286 (class 2606 OID 16919)
-- Name: product_variants fk_products; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product_variants
    ADD CONSTRAINT fk_products FOREIGN KEY (product_id) REFERENCES public.products(product_id);


--
-- TOC entry 5290 (class 2606 OID 16945)
-- Name: product_tags fk_products; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product_tags
    ADD CONSTRAINT fk_products FOREIGN KEY (product_id) REFERENCES public.products(product_id);


--
-- TOC entry 5285 (class 2606 OID 16891)
-- Name: products fk_products_category; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.products
    ADD CONSTRAINT fk_products_category FOREIGN KEY (category_id) REFERENCES public.categories(category_id);


--
-- TOC entry 5320 (class 2606 OID 17533)
-- Name: refunds fk_refund_order; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.refunds
    ADD CONSTRAINT fk_refund_order FOREIGN KEY (order_id) REFERENCES public.orders(order_id);


--
-- TOC entry 5305 (class 2606 OID 17315)
-- Name: password_reset_tokens fk_reset_user; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.password_reset_tokens
    ADD CONSTRAINT fk_reset_user FOREIGN KEY (user_id) REFERENCES public.users(user_id) ON DELETE CASCADE;


--
-- TOC entry 5321 (class 2606 OID 17551)
-- Name: reviews fk_review_product; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.reviews
    ADD CONSTRAINT fk_review_product FOREIGN KEY (product_id) REFERENCES public.products(product_id);


--
-- TOC entry 5322 (class 2606 OID 17556)
-- Name: reviews fk_review_user; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.reviews
    ADD CONSTRAINT fk_review_user FOREIGN KEY (user_id) REFERENCES public.users(user_id);


--
-- TOC entry 5298 (class 2606 OID 17187)
-- Name: role_permissions fk_role; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.role_permissions
    ADD CONSTRAINT fk_role FOREIGN KEY (role_id) REFERENCES public.roles(role_id) ON DELETE CASCADE;


--
-- TOC entry 5293 (class 2606 OID 17024)
-- Name: product_stock_log fk_stock_changed_by_user; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product_stock_log
    ADD CONSTRAINT fk_stock_changed_by_user FOREIGN KEY (changed_by) REFERENCES public.users(user_id);


--
-- TOC entry 5291 (class 2606 OID 16999)
-- Name: product_tags fk_tags; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product_tags
    ADD CONSTRAINT fk_tags FOREIGN KEY (tag_id) REFERENCES public.tags(tag_id);


--
-- TOC entry 5283 (class 2606 OID 17197)
-- Name: users fk_user_role; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT fk_user_role FOREIGN KEY (role_id) REFERENCES public.roles(role_id);


--
-- TOC entry 5303 (class 2606 OID 17289)
-- Name: user_roles fk_user_roles_role; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_roles
    ADD CONSTRAINT fk_user_roles_role FOREIGN KEY (role_id) REFERENCES public.roles(role_id) ON DELETE CASCADE;


--
-- TOC entry 5304 (class 2606 OID 17284)
-- Name: user_roles fk_user_roles_user; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_roles
    ADD CONSTRAINT fk_user_roles_user FOREIGN KEY (user_id) REFERENCES public.users(user_id) ON DELETE CASCADE;


--
-- TOC entry 5323 (class 2606 OID 17670)
-- Name: user_sessions fk_user_sessions_user; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_sessions
    ADD CONSTRAINT fk_user_sessions_user FOREIGN KEY (user_id) REFERENCES public.users(user_id) ON DELETE CASCADE;


--
-- TOC entry 5306 (class 2606 OID 17333)
-- Name: product_visibility fk_visibility_product; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product_visibility
    ADD CONSTRAINT fk_visibility_product FOREIGN KEY (product_id) REFERENCES public.products(product_id) ON DELETE CASCADE;


--
-- TOC entry 5309 (class 2606 OID 17378)
-- Name: order_items order_items_order_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.order_items
    ADD CONSTRAINT order_items_order_id_fkey FOREIGN KEY (order_id) REFERENCES public.orders(order_id);


--
-- TOC entry 5310 (class 2606 OID 17391)
-- Name: order_status_history order_status_history_order_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.order_status_history
    ADD CONSTRAINT order_status_history_order_id_fkey FOREIGN KEY (order_id) REFERENCES public.orders(order_id);


--
-- TOC entry 5311 (class 2606 OID 17404)
-- Name: payments payments_order_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.payments
    ADD CONSTRAINT payments_order_id_fkey FOREIGN KEY (order_id) REFERENCES public.orders(order_id);


-- Completed on 2025-12-27 11:21:23

--
-- PostgreSQL database dump complete
--

\unrestrict 5Ksrv3GUtwWmcek1gNvF1WDgceXxebCUXWEzVXtgk6mcqYzUj5zkNV2OAAED258

