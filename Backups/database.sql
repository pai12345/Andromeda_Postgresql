--
-- PostgreSQL database dump
--

-- Dumped from database version 12.4 (Debian 12.4-1.pgdg100+1)
-- Dumped by pg_dump version 12.4 (Debian 12.4-1.pgdg100+1)

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
-- Name: pg_trgm; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pg_trgm WITH SCHEMA public;


--
-- Name: EXTENSION pg_trgm; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION pg_trgm IS 'text similarity measurement and index searching based on trigrams';


--
-- Name: pgcrypto; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pgcrypto WITH SCHEMA public;


--
-- Name: EXTENSION pgcrypto; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION pgcrypto IS 'cryptographic functions';


--
-- Name: customers_addcustomer_procedure(character varying, character varying, text, text, integer, date, text); Type: PROCEDURE; Schema: public; Owner: postgresadmin
--

CREATE PROCEDURE public.customers_addcustomer_procedure(name_input character varying, title_input character varying, address_input text, email_input text, contactnumber_input integer, dateofbirth_input date, password_input text)
    LANGUAGE sql
    AS $$
INSERT INTO public."Customers"(name,title,address,email,contactnumber,dateofbirth,password) VALUES(name_input,title_input,address_input,email_input,contactnumber_input,dateofbirth_input,password_input)
$$;


ALTER PROCEDURE public.customers_addcustomer_procedure(name_input character varying, title_input character varying, address_input text, email_input text, contactnumber_input integer, dateofbirth_input date, password_input text) OWNER TO postgresadmin;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: Customers; Type: TABLE; Schema: public; Owner: postgresadmin
--

CREATE TABLE public."Customers" (
    customerid integer NOT NULL,
    name character varying(100) NOT NULL,
    title character varying(5),
    address text NOT NULL,
    email text NOT NULL,
    contactnumber integer NOT NULL,
    dateofbirth date,
    password text NOT NULL
);


ALTER TABLE public."Customers" OWNER TO postgresadmin;

--
-- Name: TABLE "Customers"; Type: COMMENT; Schema: public; Owner: postgresadmin
--

COMMENT ON TABLE public."Customers" IS 'Table for Customers';


--
-- Name: customers_getallcustomers_view(); Type: FUNCTION; Schema: public; Owner: postgresadmin
--

CREATE FUNCTION public.customers_getallcustomers_view() RETURNS TABLE(customerdetails public."Customers")
    LANGUAGE sql
    AS $$
SELECT * FROM public.customers_getcustomer_view 
$$;


ALTER FUNCTION public.customers_getallcustomers_view() OWNER TO postgresadmin;

--
-- Name: customers_getcustomer_function(text, text); Type: FUNCTION; Schema: public; Owner: postgresadmin
--

CREATE FUNCTION public.customers_getcustomer_function(emailid text, passwordid text) RETURNS TABLE(customerid integer, name character varying, title character varying, address text, email text, contactnumber integer, dateofbirth date)
    LANGUAGE sql
    AS $$
SELECT customerid, name, title, address, email, contactnumber, dateofbirth FROM public."customers_getcustomer_view" WHERE email=emailid AND password=crypt(passwordid, password);
$$;


ALTER FUNCTION public.customers_getcustomer_function(emailid text, passwordid text) OWNER TO postgresadmin;

--
-- Name: Products; Type: TABLE; Schema: public; Owner: postgresadmin
--

CREATE TABLE public."Products" (
    productid integer NOT NULL,
    name character varying(100) NOT NULL,
    type character varying(100) NOT NULL,
    description text NOT NULL,
    quantity integer NOT NULL,
    price real NOT NULL,
    unitsinstock integer NOT NULL,
    suppliername text NOT NULL,
    currency character varying(5) NOT NULL,
    tags text NOT NULL,
    CONSTRAINT check_price CHECK ((price >= (0)::double precision))
);


ALTER TABLE public."Products" OWNER TO postgresadmin;

--
-- Name: TABLE "Products"; Type: COMMENT; Schema: public; Owner: postgresadmin
--

COMMENT ON TABLE public."Products" IS 'Table for Products';


--
-- Name: products_getall_function(); Type: FUNCTION; Schema: public; Owner: postgresadmin
--

CREATE FUNCTION public.products_getall_function() RETURNS TABLE(allproducts public."Products")
    LANGUAGE sql
    AS $$
SELECT * FROM public.products_getallproducts_view;
$$;


ALTER FUNCTION public.products_getall_function() OWNER TO postgresadmin;

--
-- Name: products_searchengine_view; Type: VIEW; Schema: public; Owner: postgresadmin
--

CREATE VIEW public.products_searchengine_view AS
 SELECT "Products".name,
    "Products".suppliername,
    "Products".tags
   FROM public."Products"
  WITH LOCAL CHECK OPTION;


ALTER TABLE public.products_searchengine_view OWNER TO postgresadmin;

--
-- Name: products_searchengine_function(text); Type: FUNCTION; Schema: public; Owner: postgresadmin
--

CREATE FUNCTION public.products_searchengine_function(tagsearch text) RETURNS TABLE(productsearch public.products_searchengine_view)
    LANGUAGE sql
    AS $$
SELECT * FROM public."products_searchengine_view" WHERE tags LIKE ('%'||tagsearch||'%');
$$;


ALTER FUNCTION public.products_searchengine_function(tagsearch text) OWNER TO postgresadmin;

--
-- Name: Customers_customerid_seq; Type: SEQUENCE; Schema: public; Owner: postgresadmin
--

ALTER TABLE public."Customers" ALTER COLUMN customerid ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public."Customers_customerid_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: Feedback; Type: TABLE; Schema: public; Owner: postgresadmin
--

CREATE TABLE public."Feedback" (
    feedbackid integer NOT NULL,
    customerid integer NOT NULL,
    productid integer,
    orderid integer,
    comments jsonb,
    survey jsonb
);


ALTER TABLE public."Feedback" OWNER TO postgresadmin;

--
-- Name: TABLE "Feedback"; Type: COMMENT; Schema: public; Owner: postgresadmin
--

COMMENT ON TABLE public."Feedback" IS 'Table for Customer comments, feedback and response';


--
-- Name: Master; Type: TABLE; Schema: public; Owner: postgresadmin
--

CREATE TABLE public."Master" (
    name character varying(100) NOT NULL,
    description text NOT NULL,
    id integer NOT NULL
);


ALTER TABLE public."Master" OWNER TO postgresadmin;

--
-- Name: TABLE "Master"; Type: COMMENT; Schema: public; Owner: postgresadmin
--

COMMENT ON TABLE public."Master" IS 'Master Table having details of all other Tables in Commerce DB';


--
-- Name: Master_id_seq; Type: SEQUENCE; Schema: public; Owner: postgresadmin
--

ALTER TABLE public."Master" ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public."Master_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: Offers; Type: TABLE; Schema: public; Owner: postgresadmin
--

CREATE TABLE public."Offers" (
    offerid integer NOT NULL,
    customerid integer,
    productid integer NOT NULL,
    discount real NOT NULL,
    suppliername text NOT NULL
);


ALTER TABLE public."Offers" OWNER TO postgresadmin;

--
-- Name: TABLE "Offers"; Type: COMMENT; Schema: public; Owner: postgresadmin
--

COMMENT ON TABLE public."Offers" IS 'Table for offers';


--
-- Name: Orders; Type: TABLE; Schema: public; Owner: postgresadmin
--

CREATE TABLE public."Orders" (
    orderid integer NOT NULL,
    type character varying(100) NOT NULL,
    orderdate timestamp without time zone NOT NULL,
    customerid integer NOT NULL,
    suppliername text NOT NULL,
    shippingdate timestamp without time zone NOT NULL,
    shippingaddress text NOT NULL,
    orderunits integer NOT NULL,
    arrivaldate timestamp without time zone NOT NULL
);


ALTER TABLE public."Orders" OWNER TO postgresadmin;

--
-- Name: TABLE "Orders"; Type: COMMENT; Schema: public; Owner: postgresadmin
--

COMMENT ON TABLE public."Orders" IS 'Table for Orders';


--
-- Name: Products_productid_seq; Type: SEQUENCE; Schema: public; Owner: postgresadmin
--

ALTER TABLE public."Products" ALTER COLUMN productid ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public."Products_productid_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: customers_getcustomer_view; Type: VIEW; Schema: public; Owner: postgresadmin
--

CREATE VIEW public.customers_getcustomer_view AS
 SELECT "Customers".customerid,
    "Customers".name,
    "Customers".title,
    "Customers".address,
    "Customers".email,
    "Customers".contactnumber,
    "Customers".dateofbirth,
    "Customers".password
   FROM public."Customers"
  WITH LOCAL CHECK OPTION;


ALTER TABLE public.customers_getcustomer_view OWNER TO postgresadmin;

--
-- Name: products_getallproducts_view; Type: VIEW; Schema: public; Owner: postgresadmin
--

CREATE VIEW public.products_getallproducts_view AS
 SELECT "Products".productid,
    "Products".name,
    "Products".type,
    "Products".description,
    "Products".quantity,
    "Products".price,
    "Products".unitsinstock,
    "Products".suppliername,
    "Products".currency,
    "Products".tags
   FROM public."Products"
  WITH LOCAL CHECK OPTION;


ALTER TABLE public.products_getallproducts_view OWNER TO postgresadmin;

--
-- Data for Name: Customers; Type: TABLE DATA; Schema: public; Owner: postgresadmin
--

COPY public."Customers" (customerid, name, title, address, email, contactnumber, dateofbirth, password) FROM stdin;
1	admin	Admin		admin@admin.com	0	\N	$2a$06$qOtBfo.xfCvo781ytkkfMe1CMam1iGwgFs.Q/U4LhOqip97fEe/6W
3	Eric Wagner	MR	Berlin	EricWagner@andromeda.com	30213	1992-01-01	$2a$06$wflL8ZyZ/OFPOcjJCWouP.8E0NifCgUkK5ARUcCl5amE4BG1FOPN6
\.


--
-- Data for Name: Feedback; Type: TABLE DATA; Schema: public; Owner: postgresadmin
--

COPY public."Feedback" (feedbackid, customerid, productid, orderid, comments, survey) FROM stdin;
\.


--
-- Data for Name: Master; Type: TABLE DATA; Schema: public; Owner: postgresadmin
--

COPY public."Master" (name, description, id) FROM stdin;
Customers	Table having details of Customers	1
Orders	Table having details of Orders	2
Products	Table having details of Products	3
Offers	Table having details of Offers	4
\.


--
-- Data for Name: Offers; Type: TABLE DATA; Schema: public; Owner: postgresadmin
--

COPY public."Offers" (offerid, customerid, productid, discount, suppliername) FROM stdin;
\.


--
-- Data for Name: Orders; Type: TABLE DATA; Schema: public; Owner: postgresadmin
--

COPY public."Orders" (orderid, type, orderdate, customerid, suppliername, shippingdate, shippingaddress, orderunits, arrivaldate) FROM stdin;
\.


--
-- Data for Name: Products; Type: TABLE DATA; Schema: public; Owner: postgresadmin
--

COPY public."Products" (productid, name, type, description, quantity, price, unitsinstock, suppliername, currency, tags) FROM stdin;
13	Sensodyne Tooth Fresh	Health	Freshen your teeth and remove all cavities	16	470.5	27	Sensodyne	INR	Tooth,Paste,Health,Sensodyne
7	Wrist Band	Sports	Attractive wrist band made with fine leather	4	1500	20	Puma	INR	Wrist Band",Sports,Puma
5	Harry Potter and the Half Blood Prince	Books	Mystery surrounds Harry and his gang as they prepare for new adventures	7	4000	10	Bloomsbury	INR	Harry Potter,Books,Bloomsbury
8	Sports Shoes Black	Sports	Black sport shoes with high quality premium fit	4	4500	8	Nike	INR	Sports Shoes,Sports,Nike
9	Winter Goggles	Sports	Winter Googles to protect yourself from the cold	6	6500	10	Nike	INR	Winter Goggles,Sports,Nike
21	Queens Bed	Home	Bed made for a queen, built with high qulaity teak	3	75999	4	Royal Oak	INR	Queens Bed,Bed,Home,Royal Oak
10	Fresh Carrots - Organic	Groceries	Homegrown Fresh Carrots	2	100	5	Reliance	INR	Carrots,Fresh,Organic,Groceries,Reliance
19	Casual Shirts - Stipe	Fashion	Casual Shirts Stripped and made with style	11	3520.7	30	Lewis	INR	Casual Shirts Stipped,Shirts,Fashion,Lewis
15	Clear Blue	Health	Smooth and Clear soap to free your skin of all toxins	8	330.7	18	Pears	INR	Clear Blue,Soap,Health,Pears
17	Pistol silver	Toys	Amuse yourself to the design and history of Deutsch	5	330	18	Bruder	INR	Pistol silver,Pistol,Toys,Bruder
18	Black Leather Jacket	Fashion	Leather jacket made with fine desing and elegance to make you standout	9	4530.7	18	Van Heusen	INR	Black Leather Jacket,Jacket,Fashion,Van Heusen
22	Sturdy - Study Table	Home	Table for you. Made with teak and polished to last	3	47000	4	Bernhardt	INR	Sturdy Study Table,Table,Furniture,Home,Bernhardt
23	Solid Wood - Sofa	Home	Sofa made with antiquity and Style.Made with rosewood and Oak	2	67000	6	Solid Wood	INR	Solid Wood Sofa,Sofa,Furniture,Home,Solid Wood
14	Ultra Soft Baby ToothBrush	Health	Ultra Soft with high precision to remove all cavities	12	370.5	17	Sensodyne	INR	Tooth,Brush,Health,Sensodyne
16	British Bus - Red	Toys	British design bus made to entertain	3	130	28	Funskool	INR	British Bus Red,Bus,Toys,Funskool
6	Weltskrieg	Books	Immurse yourself in rich history of the past	3	2000	10	Hoffman und Campe	INR	Weltskrieg,Books,Hoffman und Campe
20	Slim Jeans - Dark Blue	Fashion	Slim fit jeans made with quality and style	8	2720.7	10	Lee	INR	Slim Jeans,Jeans,Fashion,Lee
11	Fresh Lettuce - Organic	Groceries	Homegrown Fresh Lettuce	5	60	7	Heritage	INR	Lettuce,Fresh,Organic,Groceries,Heritage
1	MacBook Pro	Electronics	he higher-end MacBook Pro features a larger 16-inch Retina display, slimmer bezels, an updated keyboard with a scissor mechanism instead of a butterfly mechanism, up to 64GB RAM, up to 8TB of storage, and AMD Radeon Pro 5000M Series graphics cards	5	100000	10	Apple	INR	MacBook,Laptop,Apple
2	iPhone	Electronics	the best, most advanced iPhone ever, packed with unique innovations that improve all the ways iPhone is used every day	1	70000	5	Apple	INR	iPhone,Mobile,Apple
3	Samsung Smart Ultra HD TV	Electronics	Immerse yourself in the picture with a wider range of colours. Crystal Display ensures optimized colour expression so you can see every subtlety	10	200000	4	Samsung	INR	Television,TV,Samsung
4	Narnia Prince Caspian	Books	Journey with Prince Caspian to save Narnia	4	3000	20	HarperCollins	INR	Narnia,Books,HarperCollins
12	Fresh Onions - Organic	Groceries	Homegrown Fresh Onions	11	70	17	Unilever	INR	Onion,Fresh,Organic,Groceries,Unilever
\.


--
-- Name: Customers_customerid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgresadmin
--

SELECT pg_catalog.setval('public."Customers_customerid_seq"', 3, true);


--
-- Name: Master_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgresadmin
--

SELECT pg_catalog.setval('public."Master_id_seq"', 1, false);


--
-- Name: Products_productid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgresadmin
--

SELECT pg_catalog.setval('public."Products_productid_seq"', 1, false);


--
-- Name: Customers Customers_pkey; Type: CONSTRAINT; Schema: public; Owner: postgresadmin
--

ALTER TABLE ONLY public."Customers"
    ADD CONSTRAINT "Customers_pkey" PRIMARY KEY (customerid);


--
-- Name: Feedback Feedback_pkey; Type: CONSTRAINT; Schema: public; Owner: postgresadmin
--

ALTER TABLE ONLY public."Feedback"
    ADD CONSTRAINT "Feedback_pkey" PRIMARY KEY (feedbackid);


--
-- Name: Master Master_pkey; Type: CONSTRAINT; Schema: public; Owner: postgresadmin
--

ALTER TABLE ONLY public."Master"
    ADD CONSTRAINT "Master_pkey" PRIMARY KEY (id);


--
-- Name: Offers Offers_pkey; Type: CONSTRAINT; Schema: public; Owner: postgresadmin
--

ALTER TABLE ONLY public."Offers"
    ADD CONSTRAINT "Offers_pkey" PRIMARY KEY (offerid);


--
-- Name: Orders Orders_pkey; Type: CONSTRAINT; Schema: public; Owner: postgresadmin
--

ALTER TABLE ONLY public."Orders"
    ADD CONSTRAINT "Orders_pkey" PRIMARY KEY (orderid);


--
-- Name: Products Products_pkey; Type: CONSTRAINT; Schema: public; Owner: postgresadmin
--

ALTER TABLE ONLY public."Products"
    ADD CONSTRAINT "Products_pkey" PRIMARY KEY (productid);


--
-- Name: Customers contactnumber_ukey; Type: CONSTRAINT; Schema: public; Owner: postgresadmin
--

ALTER TABLE ONLY public."Customers"
    ADD CONSTRAINT contactnumber_ukey UNIQUE (contactnumber);


--
-- Name: Customers email_ukey; Type: CONSTRAINT; Schema: public; Owner: postgresadmin
--

ALTER TABLE ONLY public."Customers"
    ADD CONSTRAINT email_ukey UNIQUE (email);


--
-- Name: Master name_ukey; Type: CONSTRAINT; Schema: public; Owner: postgresadmin
--

ALTER TABLE ONLY public."Master"
    ADD CONSTRAINT name_ukey UNIQUE (name);


--
-- Name: SearchPatternidx; Type: INDEX; Schema: public; Owner: postgresadmin
--

CREATE INDEX "SearchPatternidx" ON public."Products" USING gin (tags public.gin_trgm_ops);


--
-- Name: INDEX "SearchPatternidx"; Type: COMMENT; Schema: public; Owner: postgresadmin
--

COMMENT ON INDEX public."SearchPatternidx" IS 'Index for Search Engine';


--
-- PostgreSQL database dump complete
--

