--
-- PostgreSQL database dump
--

-- Dumped from database version 9.6.6
-- Dumped by pg_dump version 9.6.1

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: dbo; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA dbo;


ALTER SCHEMA dbo OWNER TO postgres;

--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


SET search_path = public, pg_catalog;

--
-- Name: canaddmission(integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION canaddmission(_id integer) RETURNS boolean
    LANGUAGE plpgsql
    AS $$
BEGIN
    IF ( (SELECT "rank" FROM "ranks" WHERE "rankId" = getUserRank(_id)) = 'Champion' ) THEN
        RETURN TRUE;
    ELSE
        RETURN FALSE;
    END IF;
END
$$;


ALTER FUNCTION public.canaddmission(_id integer) OWNER TO postgres;

--
-- Name: checkkickoff(integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION checkkickoff(mission integer) RETURNS timestamp with time zone
    LANGUAGE plpgsql
    AS $$
DECLARE
	ret TIMESTAMP with time zone;
BEGIN
	SELECT INTO ret "kickoff" FROM "missions" WHERE "missionId" = mission;
	RETURN ret;
END
$$;


ALTER FUNCTION public.checkkickoff(mission integer) OWNER TO postgres;

--
-- Name: getlevelpoints(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION getlevelpoints() RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE
	ret Integer;
BEGIN
    IF (SELECT count(*)::int FROM "levels") > 0 THEN
        SELECT INTO ret "minimumPoints" FROM "levels" WHERE "levelId" = (SELECT max("levelId")::int FROM "levels");
        ret := ret * 2;
    ELSE
        ret := 1000;
    END IF; 
    RETURN ret;
END
$$;


ALTER FUNCTION public.getlevelpoints() OWNER TO postgres;

--
-- Name: getuserrank(integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION getuserrank(_id integer) RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE
    ret INTEGER;
BEGIN
    SELECT INTO ret "level" FROM "users" WHERE "userId" = _id;
    SELECT INTO ret "rank" FROM "levels" WHERE "levelId" = ret;
    RETURN ret;
END
$$;


ALTER FUNCTION public.getuserrank(_id integer) OWNER TO postgres;

--
-- Name: insertbookmission(character varying, text, integer, integer, timestamp with time zone, integer, integer, character varying, integer, integer, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION insertbookmission(_name character varying, _details text, _duration integer, _points integer, _kickoff timestamp with time zone, _suggestor integer, _cost integer, _bookname character varying, _language integer, _subject integer, _pageamount integer) RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
    INSERT INTO "public"."missions" ("name","details","duration","points","type","kickoff","suggestor","cost") VALUES(_Name,_Details,_Duration,_Points,'B',_Kickoff,_Suggestor,_Cost);
    INSERT INTO "public"."bookMissions" ("id","bookName","language","subject","pageAmount") VALUES ((SELECT max("missionId")::int FROM "missions"),_BookName,_Language,_Subject,_PageAmount);
END
$$;


ALTER FUNCTION public.insertbookmission(_name character varying, _details text, _duration integer, _points integer, _kickoff timestamp with time zone, _suggestor integer, _cost integer, _bookname character varying, _language integer, _subject integer, _pageamount integer) OWNER TO postgres;

--
-- Name: insertlanguagemission(character varying, text, integer, integer, timestamp with time zone, integer, integer, integer, integer, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION insertlanguagemission(_name character varying, _details text, _duration integer, _points integer, _kickoff timestamp with time zone, _suggestor integer, _cost integer, _vocabularyamount integer, _language integer, _languagelevel integer) RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
    INSERT INTO "public"."missions" ("name","details","duration","points","type","kickoff","suggestor","cost") VALUES(_Name,_Details,_Duration,_Points,'L',_Kickoff,_Suggestor,_Cost);
    INSERT INTO "public"."languageMissions" ("id","vocabularyAmount","language","languageLevel") VALUES ((SELECT max("missionId")::int FROM "missions"),_VocabularyAmount,_Language,_LanguageLevel);
END
$$;


ALTER FUNCTION public.insertlanguagemission(_name character varying, _details text, _duration integer, _points integer, _kickoff timestamp with time zone, _suggestor integer, _cost integer, _vocabularyamount integer, _language integer, _languagelevel integer) OWNER TO postgres;

--
-- Name: insertlevels(integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION insertlevels(i integer) RETURNS void
    LANGUAGE plpgsql
    AS $$
DECLARE
	j Integer;
BEGIN
    j := 1;
	WHILE i >= j LOOP
        INSERT INTO "public"."levels" ("level","rank","minimumPoints" ) VALUES (j, ((j+1)/2), getLevelPoints());
        j := j+1;
    END LOOP;
END
$$;


ALTER FUNCTION public.insertlevels(i integer) OWNER TO postgres;

--
-- Name: insertscientificmission(character varying, text, integer, integer, timestamp with time zone, integer, integer, integer, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION insertscientificmission(_name character varying, _details text, _duration integer, _points integer, _kickoff timestamp with time zone, _suggestor integer, _cost integer, _subject integer, _scientificpaperno integer) RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
    INSERT INTO "public"."missions" ("name","details","duration","points","type","kickoff","suggestor","cost") VALUES(_Name,_Details,_Duration,_Points,'F',_Kickoff,_Suggestor,_Cost);
    INSERT INTO "public"."scientificMissions" ("id","subject","scientificPaperNo") VALUES ((SELECT max("missionId")::int FROM "missions"),_Subject,_ScientificPaperNo);
END
$$;


ALTER FUNCTION public.insertscientificmission(_name character varying, _details text, _duration integer, _points integer, _kickoff timestamp with time zone, _suggestor integer, _cost integer, _subject integer, _scientificpaperno integer) OWNER TO postgres;

--
-- Name: insertsportmission(character varying, text, integer, integer, timestamp with time zone, integer, integer, integer, integer, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION insertsportmission(_name character varying, _details text, _duration integer, _points integer, _kickoff timestamp with time zone, _suggestor integer, _cost integer, _calories integer, _progresstime integer, _type integer) RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
    INSERT INTO "public"."missions" ("name","details","duration","points","type","kickoff","suggestor","cost") VALUES(_Name,_Details,_Duration,_Points,'S',_Kickoff,_Suggestor,_Cost);
    INSERT INTO "public"."sportMissions" ("id","calories","progressTime","type") VALUES ((SELECT max("missionId")::int FROM "missions"),_Calories,_ProgressTime,_Type);
END
$$;


ALTER FUNCTION public.insertsportmission(_name character varying, _details text, _duration integer, _points integer, _kickoff timestamp with time zone, _suggestor integer, _cost integer, _calories integer, _progresstime integer, _type integer) OWNER TO postgres;

--
-- Name: ondeletesubmission(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION ondeletesubmission() RETURNS trigger
    LANGUAGE plpgsql
    AS $_$
BEGIN
    EXECUTE 'DELETE FROM missions WHERE "missionId" = $1' USING OLD."id";
    RETURN OLD;
END
$_$;


ALTER FUNCTION public.ondeletesubmission() OWNER TO postgres;

--
-- Name: ondeletesubuser(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION ondeletesubuser() RETURNS trigger
    LANGUAGE plpgsql
    AS $_$
BEGIN
    EXECUTE 'DELETE FROM AspNetUsers WHERE "Id" = $1' USING OLD."aspUserId";
    RETURN OLD;
END
$_$;


ALTER FUNCTION public.ondeletesubuser() OWNER TO postgres;

SET search_path = dbo, pg_catalog;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: __MigrationHistory; Type: TABLE; Schema: dbo; Owner: postgres
--

CREATE TABLE "__MigrationHistory" (
    "MigrationId" character varying(150) DEFAULT ''::character varying NOT NULL,
    "ContextKey" character varying(300) DEFAULT ''::character varying NOT NULL,
    "Model" bytea DEFAULT '\x'::bytea NOT NULL,
    "ProductVersion" character varying(32) DEFAULT ''::character varying NOT NULL
);


ALTER TABLE "__MigrationHistory" OWNER TO postgres;

SET search_path = public, pg_catalog;

--
-- Name: AspNetRoles; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE "AspNetRoles" (
    "Id" character varying(128) DEFAULT ''::character varying NOT NULL,
    "Name" character varying(256) DEFAULT ''::character varying NOT NULL
);


ALTER TABLE "AspNetRoles" OWNER TO postgres;

--
-- Name: AspNetUserClaims; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE "AspNetUserClaims" (
    "Id" integer NOT NULL,
    "ClaimType" text,
    "ClaimValue" text,
    "UserId" character varying(128) DEFAULT ''::character varying NOT NULL
);


ALTER TABLE "AspNetUserClaims" OWNER TO postgres;

--
-- Name: AspNetUserClaims_Id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE "AspNetUserClaims_Id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE "AspNetUserClaims_Id_seq" OWNER TO postgres;

--
-- Name: AspNetUserClaims_Id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE "AspNetUserClaims_Id_seq" OWNED BY "AspNetUserClaims"."Id";


--
-- Name: AspNetUserLogins; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE "AspNetUserLogins" (
    "LoginProvider" character varying(128) DEFAULT ''::character varying NOT NULL,
    "ProviderKey" character varying(128) DEFAULT ''::character varying NOT NULL,
    "UserId" character varying(128) DEFAULT ''::character varying NOT NULL
);


ALTER TABLE "AspNetUserLogins" OWNER TO postgres;

--
-- Name: AspNetUserRoles; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE "AspNetUserRoles" (
    "UserId" character varying(128) DEFAULT ''::character varying NOT NULL,
    "RoleId" character varying(128) DEFAULT ''::character varying NOT NULL
);


ALTER TABLE "AspNetUserRoles" OWNER TO postgres;

--
-- Name: AspNetUsers; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE "AspNetUsers" (
    "Id" character varying(128) DEFAULT ''::character varying NOT NULL,
    "AccessFailedCount" integer DEFAULT 0 NOT NULL,
    "Email" character varying(256),
    "EmailConfirmed" boolean DEFAULT false NOT NULL,
    "LockoutEnabled" boolean DEFAULT false NOT NULL,
    "LockoutEndDateUtc" timestamp without time zone,
    "PasswordHash" text,
    "PhoneNumber" text,
    "PhoneNumberConfirmed" boolean DEFAULT false NOT NULL,
    "SecurityStamp" text,
    "TwoFactorEnabled" boolean DEFAULT false NOT NULL,
    "UserName" character varying(256) DEFAULT ''::character varying NOT NULL
);


ALTER TABLE "AspNetUsers" OWNER TO postgres;

--
-- Name: bookMissions; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE "bookMissions" (
    id integer NOT NULL,
    "bookName" character varying(64) NOT NULL,
    language integer,
    subject integer,
    "pageAmount" integer
);


ALTER TABLE "bookMissions" OWNER TO postgres;

--
-- Name: comments; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE comments (
    "commentId" integer NOT NULL,
    comment character varying(256) NOT NULL,
    "user" integer NOT NULL,
    mission integer NOT NULL,
    date timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE comments OWNER TO postgres;

--
-- Name: comments_commentId_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE "comments_commentId_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE "comments_commentId_seq" OWNER TO postgres;

--
-- Name: comments_commentId_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE "comments_commentId_seq" OWNED BY comments."commentId";


--
-- Name: follows; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE follows (
    "followId" integer NOT NULL,
    followed integer NOT NULL,
    follower integer NOT NULL
);


ALTER TABLE follows OWNER TO postgres;

--
-- Name: follows_followId_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE "follows_followId_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE "follows_followId_seq" OWNER TO postgres;

--
-- Name: follows_followId_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE "follows_followId_seq" OWNED BY follows."followId";


--
-- Name: language; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE language (
    "languageId" integer NOT NULL,
    language character varying(32) NOT NULL
);


ALTER TABLE language OWNER TO postgres;

--
-- Name: languageLevel; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE "languageLevel" (
    "languageLevelId" integer NOT NULL,
    "languageLevel" character varying(32) NOT NULL
);


ALTER TABLE "languageLevel" OWNER TO postgres;

--
-- Name: languageLevel_languageLevelId_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE "languageLevel_languageLevelId_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE "languageLevel_languageLevelId_seq" OWNER TO postgres;

--
-- Name: languageLevel_languageLevelId_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE "languageLevel_languageLevelId_seq" OWNED BY "languageLevel"."languageLevelId";


--
-- Name: languageMissions; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE "languageMissions" (
    id integer NOT NULL,
    "vocabularyAmount" integer NOT NULL,
    language integer,
    "languageLevel" integer,
    CONSTRAINT vocabularyamount_ck CHECK (("vocabularyAmount" > 0))
);


ALTER TABLE "languageMissions" OWNER TO postgres;

--
-- Name: language_languageId_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE "language_languageId_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE "language_languageId_seq" OWNER TO postgres;

--
-- Name: language_languageId_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE "language_languageId_seq" OWNED BY language."languageId";


--
-- Name: levels; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE levels (
    "levelId" integer NOT NULL,
    level integer NOT NULL,
    rank integer NOT NULL,
    "minimumPoints" integer DEFAULT getlevelpoints() NOT NULL,
    CONSTRAINT level_ck CHECK ((level > 0)),
    CONSTRAINT minimumpoints_ck CHECK (("minimumPoints" > 0))
);


ALTER TABLE levels OWNER TO postgres;

--
-- Name: levels_levelId_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE "levels_levelId_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE "levels_levelId_seq" OWNER TO postgres;

--
-- Name: levels_levelId_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE "levels_levelId_seq" OWNED BY levels."levelId";


--
-- Name: missionTag; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE "missionTag" (
    "missionTagId" integer NOT NULL,
    tag integer NOT NULL,
    mission integer NOT NULL
);


ALTER TABLE "missionTag" OWNER TO postgres;

--
-- Name: missionTag_missionTagId_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE "missionTag_missionTagId_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE "missionTag_missionTagId_seq" OWNER TO postgres;

--
-- Name: missionTag_missionTagId_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE "missionTag_missionTagId_seq" OWNED BY "missionTag"."missionTagId";


--
-- Name: missions; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE missions (
    "missionId" integer NOT NULL,
    name character varying(64) NOT NULL,
    details text NOT NULL,
    duration integer NOT NULL,
    points integer NOT NULL,
    type character varying(1) NOT NULL,
    kickoff timestamp with time zone NOT NULL,
    suggestor integer NOT NULL,
    cost integer NOT NULL,
    CONSTRAINT duration_ck CHECK ((duration > 0)),
    CONSTRAINT suggestor_ck CHECK (canaddmission(suggestor)),
    CONSTRAINT type_ck CHECK ((((type)::text ~~ 'B'::text) OR ((type)::text ~~ 'S'::text) OR ((type)::text ~~ 'F'::text) OR ((type)::text ~~ 'L'::text)))
);


ALTER TABLE missions OWNER TO postgres;

--
-- Name: missions_missionId_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE "missions_missionId_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE "missions_missionId_seq" OWNER TO postgres;

--
-- Name: missions_missionId_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE "missions_missionId_seq" OWNED BY missions."missionId";


--
-- Name: notifications; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE notifications (
    "notificationId" integer NOT NULL,
    "notificatedUser" integer NOT NULL,
    "fromUser" integer NOT NULL,
    content text NOT NULL,
    date timestamp with time zone DEFAULT now() NOT NULL,
    "aboutMission" integer
);


ALTER TABLE notifications OWNER TO postgres;

--
-- Name: ranks; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE ranks (
    "rankId" integer NOT NULL,
    rank character varying(64) NOT NULL,
    "rankColor" integer NOT NULL
);


ALTER TABLE ranks OWNER TO postgres;

--
-- Name: ranks_rankId_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE "ranks_rankId_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE "ranks_rankId_seq" OWNER TO postgres;

--
-- Name: ranks_rankId_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE "ranks_rankId_seq" OWNED BY ranks."rankId";


--
-- Name: scientificMissions; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE "scientificMissions" (
    id integer NOT NULL,
    subject integer,
    "scientificPaperNo" integer,
    CONSTRAINT scientificpaperno_ck CHECK (("scientificPaperNo" > 0))
);


ALTER TABLE "scientificMissions" OWNER TO postgres;

--
-- Name: sportMissions; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE "sportMissions" (
    id integer NOT NULL,
    calories integer NOT NULL,
    "progressTime" integer,
    type integer,
    CONSTRAINT calories_ck CHECK ((calories > 0)),
    CONSTRAINT progresstime_ck CHECK (("progressTime" > 0))
);


ALTER TABLE "sportMissions" OWNER TO postgres;

--
-- Name: sportTypes; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE "sportTypes" (
    "sportTypeId" integer NOT NULL,
    "sportType" character varying(64) NOT NULL
);


ALTER TABLE "sportTypes" OWNER TO postgres;

--
-- Name: sportTypes_sportTypeId_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE "sportTypes_sportTypeId_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE "sportTypes_sportTypeId_seq" OWNER TO postgres;

--
-- Name: sportTypes_sportTypeId_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE "sportTypes_sportTypeId_seq" OWNED BY "sportTypes"."sportTypeId";


--
-- Name: subjects; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE subjects (
    "subjectId" integer NOT NULL,
    subject character varying(64) NOT NULL
);


ALTER TABLE subjects OWNER TO postgres;

--
-- Name: subjects_subjectId_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE "subjects_subjectId_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE "subjects_subjectId_seq" OWNER TO postgres;

--
-- Name: subjects_subjectId_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE "subjects_subjectId_seq" OWNED BY subjects."subjectId";


--
-- Name: tags; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE tags (
    "tagId" integer NOT NULL,
    tag character varying(16) NOT NULL
);


ALTER TABLE tags OWNER TO postgres;

--
-- Name: tags_tagId_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE "tags_tagId_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE "tags_tagId_seq" OWNER TO postgres;

--
-- Name: tags_tagId_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE "tags_tagId_seq" OWNED BY tags."tagId";


--
-- Name: userMission; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE "userMission" (
    "userMissionId" integer NOT NULL,
    "user" integer NOT NULL,
    mission integer NOT NULL,
    "joiningDate" timestamp with time zone NOT NULL,
    completed boolean NOT NULL,
    CONSTRAINT joiningdate_ck CHECK (("joiningDate" < checkkickoff(mission)))
);


ALTER TABLE "userMission" OWNER TO postgres;

--
-- Name: userMission_userMissionId_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE "userMission_userMissionId_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE "userMission_userMissionId_seq" OWNER TO postgres;

--
-- Name: userMission_userMissionId_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE "userMission_userMissionId_seq" OWNED BY "userMission"."userMissionId";


--
-- Name: userTag; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE "userTag" (
    "userTagId" integer NOT NULL,
    "user" integer NOT NULL,
    tag integer NOT NULL
);


ALTER TABLE "userTag" OWNER TO postgres;

--
-- Name: userTag_userTagId_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE "userTag_userTagId_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE "userTag_userTagId_seq" OWNER TO postgres;

--
-- Name: userTag_userTagId_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE "userTag_userTagId_seq" OWNED BY "userTag"."userTagId";


--
-- Name: users; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE users (
    "userId" integer NOT NULL,
    "aspUserId" character varying(128) NOT NULL,
    name character varying(32) NOT NULL,
    surname character varying(32) NOT NULL,
    birthdate date NOT NULL,
    autobiyography text,
    "profileImage" text,
    "lastActiveDate" timestamp with time zone,
    level integer NOT NULL,
    points integer NOT NULL,
    CONSTRAINT birthdate_ck CHECK ((birthdate < ('now'::text)::date)),
    CONSTRAINT points_ck CHECK ((points > 0))
);


ALTER TABLE users OWNER TO postgres;

--
-- Name: users_userId_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE "users_userId_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE "users_userId_seq" OWNER TO postgres;

--
-- Name: users_userId_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE "users_userId_seq" OWNED BY users."userId";


--
-- Name: votes; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE votes (
    "voteId" integer NOT NULL,
    vote integer NOT NULL,
    "user" integer NOT NULL,
    mission integer NOT NULL,
    CONSTRAINT vote_ck CHECK (((vote = '-1'::integer) OR (vote = 1)))
);


ALTER TABLE votes OWNER TO postgres;

--
-- Name: votes_voteId_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE "votes_voteId_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE "votes_voteId_seq" OWNER TO postgres;

--
-- Name: votes_voteId_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE "votes_voteId_seq" OWNED BY votes."voteId";


--
-- Name: AspNetUserClaims Id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "AspNetUserClaims" ALTER COLUMN "Id" SET DEFAULT nextval('"AspNetUserClaims_Id_seq"'::regclass);


--
-- Name: comments commentId; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY comments ALTER COLUMN "commentId" SET DEFAULT nextval('"comments_commentId_seq"'::regclass);


--
-- Name: follows followId; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY follows ALTER COLUMN "followId" SET DEFAULT nextval('"follows_followId_seq"'::regclass);


--
-- Name: language languageId; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY language ALTER COLUMN "languageId" SET DEFAULT nextval('"language_languageId_seq"'::regclass);


--
-- Name: languageLevel languageLevelId; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "languageLevel" ALTER COLUMN "languageLevelId" SET DEFAULT nextval('"languageLevel_languageLevelId_seq"'::regclass);


--
-- Name: levels levelId; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY levels ALTER COLUMN "levelId" SET DEFAULT nextval('"levels_levelId_seq"'::regclass);


--
-- Name: missionTag missionTagId; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "missionTag" ALTER COLUMN "missionTagId" SET DEFAULT nextval('"missionTag_missionTagId_seq"'::regclass);


--
-- Name: missions missionId; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY missions ALTER COLUMN "missionId" SET DEFAULT nextval('"missions_missionId_seq"'::regclass);


--
-- Name: ranks rankId; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY ranks ALTER COLUMN "rankId" SET DEFAULT nextval('"ranks_rankId_seq"'::regclass);


--
-- Name: sportTypes sportTypeId; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "sportTypes" ALTER COLUMN "sportTypeId" SET DEFAULT nextval('"sportTypes_sportTypeId_seq"'::regclass);


--
-- Name: subjects subjectId; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY subjects ALTER COLUMN "subjectId" SET DEFAULT nextval('"subjects_subjectId_seq"'::regclass);


--
-- Name: tags tagId; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY tags ALTER COLUMN "tagId" SET DEFAULT nextval('"tags_tagId_seq"'::regclass);


--
-- Name: userMission userMissionId; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "userMission" ALTER COLUMN "userMissionId" SET DEFAULT nextval('"userMission_userMissionId_seq"'::regclass);


--
-- Name: userTag userTagId; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "userTag" ALTER COLUMN "userTagId" SET DEFAULT nextval('"userTag_userTagId_seq"'::regclass);


--
-- Name: users userId; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY users ALTER COLUMN "userId" SET DEFAULT nextval('"users_userId_seq"'::regclass);


--
-- Name: votes voteId; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY votes ALTER COLUMN "voteId" SET DEFAULT nextval('"votes_voteId_seq"'::regclass);


SET search_path = dbo, pg_catalog;

--
-- Data for Name: __MigrationHistory; Type: TABLE DATA; Schema: dbo; Owner: postgres
--

INSERT INTO "__MigrationHistory" VALUES ('201712101546395_InitialCreate', 'MiMissionProject.Models.ApplicationDbContext', '\x1f8b0800000000000400ed5cdb6ee436127d0fb0ff20e871e1b43c9ecd2031ba1338ed7162c4b74c7b82bc0d6889ddd68e442a22e5d858ec97e5219f945f485177f1a24bb7fae2c52240302d92a78ac543b2582cfaaf3ffe9c7ef71c06d6138e994fc9cc7e3339b62d4c5ceaf96435b313befcf26bfbbb6ffff1c5f4bd173e5bbf14f5de8a7ad092b099fdc87974ea38cc7dc4216293d07763cae8924f5c1a3ac8a3cec9f1f137ce9b370e06081bb02c6bfa2121dc0f71fa037ece297171c413145c530f072cff0e258b14d5ba4121661172f1ccbef6af7d26b4b88be9bfb1cb275913db3a0b7c04ea2c70b0b42d4408e58843b5d38f0c2f784cc96a11c10714dcbf4418ea2d51c070de89d3aa7adffe1c9f88fe3855c302ca4d18a7e140c0376f73033972f3b5cc6c97060413be0753f317d1ebd48c33fbd2c3e9a70f340003c8024fe7412c2acfec3bcaf82ac68b9faf26672cbac17c52b49c64981731e0fd4ee3cf933ae491d5bfe1514929609ef8efc89a27014f623c2338e1310a002d79087cf727fc724f3f6332234910d4fb073d84b2c607f804e488700c0ae165d96bdb729aed1cb961d9acd626b305300866846d5da3e72b4c56fc11e6cac9d7b675e13f63aff89253ea23f1610241231e27f0f30614460f012ecb9d5699e2ff2d524fbe7a378ad41bf4e4afd20197e4c3748961367dc0415aca1efd289b548d41fe9457bb8869287e375995957e5ad024764567a8b1ca3d8a579837b59b3a15657b1159406d81cc05ec81125aa8a7925a5b55f4621dfe1722763d070a7db72bb737cfcea208062c2594b0481bcd0cbbd3448238b2e48aff5f09159967ae8b19bb407e80bd39058fa150e192f0b72783e1de878034c2cada430af8334b3f0e7169b4ef29301a91c13a5f51f7334df87b22da8c87e69d238e3f72b700143feffdb013e00e3106ab9cf723628f2d96847f8e60c9bb474af04d123e8819b73b59a38ddd02bb490c0bc982a330da7a0fee7fa717c8e5341e892b6295dab72b320f901fea7d11693dfd5454adfc117d0dc5273154d3f9256daa5ed1954ffaa95a5435ab9ad5e85435af36545501d64fd3bca659d1b442a79e59add13cbd7484b6e0eaa5b807eaeb6db6659bf6cb9af116b072e01f30c1316c05de1de21cc7a4b27bd76a91da4e08dbfa3a974afa0505c9f645edc6fb5d6b0ea4537f0b7320c53dd03990ea069f9f7c4f78043d8e3d456580ef555f7fa2ea9e699266bbf6931bdddcb5f0fd4e9233c6a8eba7dcd704b7f22045537ff07eadee8845d61b39ea011d0372fb627b832fd0375b26d52d39c701e6d83a73b3e0df1c311779aa19a143de00c58add53a35815fd682af74f4526301dc7a21112271406b3d3275c9d163e71fd08059d56925af6dcb844df4b1972c9398e3011023b2dd147b83eec211428e54883d265a1a953635c3b110d1eaa69ccbbdcd56adc9568c44e38d9e1271b7899fb6a5b2166bbc57640ce7693f451c018c2db0741f373495f02c887944323a8743a32103477a47642d0a6c5f640d0a6495e1d41b3e368dff197cea68746cfe6a178f7db7aabb9f6c0cd863d0e8c9a99ef096d38b4c0b14acff30751889fb9e648067ae6a73296bbba324504f802f36678a6f277b57ea8d30e2293a80db0225a07687ee5a70029136a807245dcae55bbdc8b18005bc4d85a61f3b55f82ad7140c5ae5f7dd62a9a2f486572f63a7d943d2bd9a090bcd761a186a32184bc78353bdec328a618ac6a983ebef0106fb8d6b17c305a0cd4e1b91a8c547466742b15d4ecb692ce211be2926d6425c97d3258a9e8cce856ca39da6d248d5330c02dd8c844cd2d7ca4c956443acadda62c9b3a593254fe61ea18b2a6a6d7288a7cb2aa6551e55fac45964235ff72313cad28cc301c9769b28b4a6d4b499cc66885a552100d9a5ef831e3e788a30724e23c732f54aa69f756c3f25f88ac6f9fea2016fb40515bfc3b6b61bab26f6cb8aa4792035d403743e1d6a411740d09f4cd2d91da8602146b82f6731a2421317b59e6d6d9855dbd7df64545983a92fe8a17a5984cf1759bf6ef353aeacc1873a44a4f66fdd13243986c5ef8a175ab9b7c53334a11aaaaa398c2577b1b3d934b337cc4649771f88075226c6786697252ea609ae2fed879824a1d2fff3410a396c2a080d5cafaa3ca69287554b96c0dd42a1d450b5c15f7c76e66aad4619b250310ebe9280dc07ac15a7886f1d2d7e82f414a40a9434b45fd31d534933aac5ada1fb94a389157d203dec38c0799cd36b1ecc0bbd92e66c0d8ceb258bbffaf83d43e0fc4ca6ff815b0fcfb305af5df9e0f8052c653df6694ca821d9b51ca80615edf1bd7e2cdb5bdf52edf8cd9b8eb6e2c966d77fdaf821ecac94fae524a2f4f80d2496f9a9fbaba1fd128c7b0ac8a6d1566849343b462bf05d5976b44fc25663c4be2b0bf99bc9bbc931edd1cce031887312fd09c534daf609aa3b48394ac2714bb8f2856332536782d52622a31e84be2e1e799fd9fb4d1691ace10ff4a3f1f5997ec23f17f4ba0e03e4eb0f55f35c973fc04a675adbef3470fbd8d7af9eba7ace591751bc37c39b58e2553ae33becd97104394c95a6ea0ccdacf235eed64323e38f009ffd766ef0d742a4a536bfdd7050f9406233d2dd80c4a7e5720de78b2ec8831ac9fba8706d9fdda401cf50dc18630e3185ffb36601dcd4c69ff6b6925e7fcf75e6e8a867bdc5034c79d5d2c3dd9cad0993d3d70209474ea75a8a1664aaf83b2c7dd7083cce83578f0cad28bc7daf334c9c363411f207546cb173e9414e12a7963bf99c1bb4c066eb9e6f99fca013e80ac354d16cefe337d77cd355334f6c0d32587e5f31e18d9f2dcacfd67edee9a6ca638ed81936d506eee81716d5ffbe79e99d67b0bdd7ba6ad9a3464b855d18576bb3269b3c8f7cc8ed2578ac083cca9ccde3deab3b7da324f3b6456555ae59a33c764d9caf451442b353a250feb71bef3b77639afd329d99075d9263edf0b5ac5e7753ac51bd219f79112ac4d28d4a569772c6b6d394eaf2905b8d1938e8cf32e17b6f5c6fc3565fc8e6294c60432dcf9be9e04df514c32e6d41990d0ab5edfc2565afb4b89b09d337f554188bf9b48b0dbd844cb3a9764498bbd5cd2a8a822c56bae31471eecb06731f797c8e5502cee43d207dd691c51dc3f3c60ef92dc263c4a387419870f4123f8257c8236f969d67253e7e96d94fe1d9231ba006afad0057c4bbe4ffcc02bf5bed084880c10c2d9c843b9622cb908e9ae5e4aa41b4a7a02e5e62b7da47b1c460180b15bb2404f781ddd807e577885dc972a1a6802e91e88a6d9a7e73e5ac528643946d51e7e0287bdf0f9dbbf01d1109b5330540000', '6.1.3-40302');


SET search_path = public, pg_catalog;

--
-- Data for Name: AspNetRoles; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- Data for Name: AspNetUserClaims; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- Name: AspNetUserClaims_Id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('"AspNetUserClaims_Id_seq"', 1, false);


--
-- Data for Name: AspNetUserLogins; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- Data for Name: AspNetUserRoles; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- Data for Name: AspNetUsers; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO "AspNetUsers" VALUES ('bc0f1d13-ea02-41c5-862c-56dcbd1ce072', 0, 'alisafaya@gmail.com', false, true, NULL, 'AG8aGGKMCoN0AvbS4yKYyEL8dwWRg3ZBvuFtjzgUnCr2B0Yf3rEmZmScuzxPqWis6Q==', NULL, false, 'b1754d3e-6fa3-4627-9fa2-4c6ced88d9ac', false, 'alisafaya@gmail.com');


--
-- Data for Name: bookMissions; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO "bookMissions" VALUES (1, 'Kukla', 18, 31, 50);


--
-- Data for Name: comments; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- Name: comments_commentId_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('"comments_commentId_seq"', 1, false);


--
-- Data for Name: follows; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- Name: follows_followId_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('"follows_followId_seq"', 1, false);


--
-- Data for Name: language; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO language VALUES (1, 'Albanian');
INSERT INTO language VALUES (2, 'Arabic');
INSERT INTO language VALUES (3, 'Bulgarian');
INSERT INTO language VALUES (4, 'Chinese');
INSERT INTO language VALUES (5, 'Dutch');
INSERT INTO language VALUES (6, 'English');
INSERT INTO language VALUES (7, 'French');
INSERT INTO language VALUES (8, 'German');
INSERT INTO language VALUES (9, 'Greek');
INSERT INTO language VALUES (10, 'Indonesian');
INSERT INTO language VALUES (11, 'Japanese');
INSERT INTO language VALUES (12, 'Italian');
INSERT INTO language VALUES (13, 'Korean');
INSERT INTO language VALUES (14, 'Portuguese');
INSERT INTO language VALUES (15, 'Russian');
INSERT INTO language VALUES (16, 'Spanish');
INSERT INTO language VALUES (17, 'Swedish');
INSERT INTO language VALUES (18, 'Turkish');
INSERT INTO language VALUES (19, 'Ukrainian');


--
-- Data for Name: languageLevel; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO "languageLevel" VALUES (1, 'A1');
INSERT INTO "languageLevel" VALUES (2, 'A2');
INSERT INTO "languageLevel" VALUES (3, 'B1');
INSERT INTO "languageLevel" VALUES (4, 'B2');
INSERT INTO "languageLevel" VALUES (5, 'C1');
INSERT INTO "languageLevel" VALUES (6, 'C2');


--
-- Name: languageLevel_languageLevelId_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('"languageLevel_languageLevelId_seq"', 6, true);


--
-- Data for Name: languageMissions; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO "languageMissions" VALUES (3, 250, 6, 4);


--
-- Name: language_languageId_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('"language_languageId_seq"', 19, true);


--
-- Data for Name: levels; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO levels VALUES (1, 1, 1, 1000);
INSERT INTO levels VALUES (2, 2, 1, 2000);
INSERT INTO levels VALUES (3, 3, 2, 4000);
INSERT INTO levels VALUES (4, 4, 2, 8000);
INSERT INTO levels VALUES (5, 5, 3, 16000);
INSERT INTO levels VALUES (6, 6, 3, 32000);
INSERT INTO levels VALUES (7, 7, 4, 64000);
INSERT INTO levels VALUES (8, 8, 4, 128000);
INSERT INTO levels VALUES (9, 9, 5, 256000);
INSERT INTO levels VALUES (10, 10, 5, 512000);


--
-- Name: levels_levelId_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('"levels_levelId_seq"', 10, true);


--
-- Data for Name: missionTag; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- Name: missionTag_missionTagId_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('"missionTag_missionTagId_seq"', 1, false);


--
-- Data for Name: missions; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO missions VALUES (1, 'Read a 10 pages', 'you have to read at least 10 pages everyday through this mission to win the points', 120, 500, 'B', '2017-12-15 00:00:00+03', 1, 50);
INSERT INTO missions VALUES (2, 'Do a research', 'you have a research on specific subject and get its latest results', 72, 1000, 'F', '2017-12-17 00:00:00+03', 1, 150);
INSERT INTO missions VALUES (3, 'Memorize 25 vocabulary a day', 'memorize at least 25 words from the ... language for 10 days to win this mission', 120, 700, 'L', '2017-12-11 00:00:00+03', 1, 100);
INSERT INTO missions VALUES (4, 'Walk 20 km', 'you will try to walk total 20 km through this mission duration to win the points', 168, 1000, 'S', '2017-12-20 00:00:00+03', 1, 250);


--
-- Name: missions_missionId_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('"missions_missionId_seq"', 4, true);


--
-- Data for Name: notifications; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- Data for Name: ranks; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO ranks VALUES (1, 'Newbie', 1);
INSERT INTO ranks VALUES (2, 'Achiever', 2);
INSERT INTO ranks VALUES (3, 'Expert', 3);
INSERT INTO ranks VALUES (4, 'Master', 4);
INSERT INTO ranks VALUES (5, 'Champion', 5);


--
-- Name: ranks_rankId_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('"ranks_rankId_seq"', 5, true);


--
-- Data for Name: scientificMissions; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO "scientificMissions" VALUES (2, 2, 3);


--
-- Data for Name: sportMissions; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO "sportMissions" VALUES (4, 2000, NULL, 12);


--
-- Data for Name: sportTypes; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO "sportTypes" VALUES (1, 'Running');
INSERT INTO "sportTypes" VALUES (2, 'Swimming');
INSERT INTO "sportTypes" VALUES (3, 'kick-Boxing');
INSERT INTO "sportTypes" VALUES (4, 'Cycle');
INSERT INTO "sportTypes" VALUES (5, 'Football');
INSERT INTO "sportTypes" VALUES (6, 'Climbing');
INSERT INTO "sportTypes" VALUES (7, 'Racing');
INSERT INTO "sportTypes" VALUES (8, 'skiing');
INSERT INTO "sportTypes" VALUES (9, 'Surfing');
INSERT INTO "sportTypes" VALUES (10, 'Basketball');
INSERT INTO "sportTypes" VALUES (11, 'Volleyball');
INSERT INTO "sportTypes" VALUES (12, 'Walking');
INSERT INTO "sportTypes" VALUES (13, 'Tennis');


--
-- Name: sportTypes_sportTypeId_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('"sportTypes_sportTypeId_seq"', 13, true);


--
-- Data for Name: subjects; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO subjects VALUES (1, 'History');
INSERT INTO subjects VALUES (2, 'Universe');
INSERT INTO subjects VALUES (3, 'Galaxies');
INSERT INTO subjects VALUES (4, 'Psychology');
INSERT INTO subjects VALUES (5, 'Personal growth');
INSERT INTO subjects VALUES (6, 'Food');
INSERT INTO subjects VALUES (7, 'Technology');
INSERT INTO subjects VALUES (8, 'Culture');
INSERT INTO subjects VALUES (9, 'Mind');
INSERT INTO subjects VALUES (10, 'Language');
INSERT INTO subjects VALUES (11, 'Learning');
INSERT INTO subjects VALUES (12, 'Art');
INSERT INTO subjects VALUES (13, 'Physics');
INSERT INTO subjects VALUES (14, 'Maths');
INSERT INTO subjects VALUES (15, 'Energy');
INSERT INTO subjects VALUES (16, 'Anatomy');
INSERT INTO subjects VALUES (17, 'Chemistry');
INSERT INTO subjects VALUES (18, 'Climate');
INSERT INTO subjects VALUES (19, 'Economy');
INSERT INTO subjects VALUES (20, 'Humans');
INSERT INTO subjects VALUES (21, 'Music');
INSERT INTO subjects VALUES (22, 'Myths');
INSERT INTO subjects VALUES (23, 'NASA');
INSERT INTO subjects VALUES (24, 'Social science');
INSERT INTO subjects VALUES (25, 'Politics');
INSERT INTO subjects VALUES (26, 'Sports');
INSERT INTO subjects VALUES (27, 'Human rights');
INSERT INTO subjects VALUES (28, 'Quantum theory');
INSERT INTO subjects VALUES (29, 'Einstein');
INSERT INTO subjects VALUES (30, 'Computer');
INSERT INTO subjects VALUES (31, 'Liturature');
INSERT INTO subjects VALUES (32, 'Poetry');


--
-- Name: subjects_subjectId_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('"subjects_subjectId_seq"', 32, true);


--
-- Data for Name: tags; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO tags VALUES (1, 'Relax');
INSERT INTO tags VALUES (2, 'Challenge');
INSERT INTO tags VALUES (3, 'Entertain');
INSERT INTO tags VALUES (4, 'New');
INSERT INTO tags VALUES (5, 'Fitness');
INSERT INTO tags VALUES (6, 'Skilled');
INSERT INTO tags VALUES (7, 'Racing');
INSERT INTO tags VALUES (8, 'Motion');
INSERT INTO tags VALUES (9, 'Learn');
INSERT INTO tags VALUES (10, 'Achieve');


--
-- Name: tags_tagId_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('"tags_tagId_seq"', 10, true);


--
-- Data for Name: userMission; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- Name: userMission_userMissionId_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('"userMission_userMissionId_seq"', 1, false);


--
-- Data for Name: userTag; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- Name: userTag_userTagId_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('"userTag_userTagId_seq"', 1, false);


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO users VALUES (1, 'bc0f1d13-ea02-41c5-862c-56dcbd1ce072', 'ali', 'safaya', '1997-04-02', NULL, NULL, '2017-09-15 00:00:00+03', 9, 333000);


--
-- Name: users_userId_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('"users_userId_seq"', 1, true);


--
-- Data for Name: votes; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- Name: votes_voteId_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('"votes_voteId_seq"', 1, false);


SET search_path = dbo, pg_catalog;

--
-- Name: __MigrationHistory PK_dbo.__MigrationHistory; Type: CONSTRAINT; Schema: dbo; Owner: postgres
--

ALTER TABLE ONLY "__MigrationHistory"
    ADD CONSTRAINT "PK_dbo.__MigrationHistory" PRIMARY KEY ("MigrationId", "ContextKey");


SET search_path = public, pg_catalog;

--
-- Name: AspNetRoles PK_public.AspNetRoles; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "AspNetRoles"
    ADD CONSTRAINT "PK_public.AspNetRoles" PRIMARY KEY ("Id");


--
-- Name: AspNetUserClaims PK_public.AspNetUserClaims; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "AspNetUserClaims"
    ADD CONSTRAINT "PK_public.AspNetUserClaims" PRIMARY KEY ("Id");


--
-- Name: AspNetUserLogins PK_public.AspNetUserLogins; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "AspNetUserLogins"
    ADD CONSTRAINT "PK_public.AspNetUserLogins" PRIMARY KEY ("LoginProvider", "ProviderKey", "UserId");


--
-- Name: AspNetUserRoles PK_public.AspNetUserRoles; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "AspNetUserRoles"
    ADD CONSTRAINT "PK_public.AspNetUserRoles" PRIMARY KEY ("UserId", "RoleId");


--
-- Name: AspNetUsers PK_public.AspNetUsers; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "AspNetUsers"
    ADD CONSTRAINT "PK_public.AspNetUsers" PRIMARY KEY ("Id");


--
-- Name: bookMissions bookmission_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "bookMissions"
    ADD CONSTRAINT bookmission_pk PRIMARY KEY (id);


--
-- Name: comments comments_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY comments
    ADD CONSTRAINT comments_pk PRIMARY KEY ("commentId");


--
-- Name: follows follows_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY follows
    ADD CONSTRAINT follows_pk PRIMARY KEY ("followId");


--
-- Name: language language_language_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY language
    ADD CONSTRAINT language_language_key UNIQUE (language);


--
-- Name: language language_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY language
    ADD CONSTRAINT language_pk PRIMARY KEY ("languageId");


--
-- Name: languageLevel languagelevel_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "languageLevel"
    ADD CONSTRAINT languagelevel_pk PRIMARY KEY ("languageLevelId");


--
-- Name: languageMissions languagemissions_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "languageMissions"
    ADD CONSTRAINT languagemissions_pk PRIMARY KEY (id);


--
-- Name: levels levels_level_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY levels
    ADD CONSTRAINT levels_level_key UNIQUE (level);


--
-- Name: levels levels_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY levels
    ADD CONSTRAINT levels_pk PRIMARY KEY ("levelId");


--
-- Name: missions missions_name_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY missions
    ADD CONSTRAINT missions_name_key UNIQUE (name);


--
-- Name: missions missions_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY missions
    ADD CONSTRAINT missions_pk PRIMARY KEY ("missionId");


--
-- Name: missionTag missiontag_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "missionTag"
    ADD CONSTRAINT missiontag_pk PRIMARY KEY ("missionTagId");


--
-- Name: notifications notifications_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY notifications
    ADD CONSTRAINT notifications_pk PRIMARY KEY ("notificationId");


--
-- Name: ranks ranks_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY ranks
    ADD CONSTRAINT ranks_pk PRIMARY KEY ("rankId");


--
-- Name: scientificMissions scientificmissions_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "scientificMissions"
    ADD CONSTRAINT scientificmissions_pk PRIMARY KEY (id);


--
-- Name: sportTypes sportTypes_sportType_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "sportTypes"
    ADD CONSTRAINT "sportTypes_sportType_key" UNIQUE ("sportType");


--
-- Name: sportMissions sportmissions_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "sportMissions"
    ADD CONSTRAINT sportmissions_pk PRIMARY KEY (id);


--
-- Name: sportTypes sporttypes_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "sportTypes"
    ADD CONSTRAINT sporttypes_pk PRIMARY KEY ("sportTypeId");


--
-- Name: subjects subjects_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY subjects
    ADD CONSTRAINT subjects_pk PRIMARY KEY ("subjectId");


--
-- Name: subjects subjects_subject_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY subjects
    ADD CONSTRAINT subjects_subject_key UNIQUE (subject);


--
-- Name: tags tags_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY tags
    ADD CONSTRAINT tags_pk PRIMARY KEY ("tagId");


--
-- Name: tags tags_tag_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY tags
    ADD CONSTRAINT tags_tag_key UNIQUE (tag);


--
-- Name: userMission usermission_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "userMission"
    ADD CONSTRAINT usermission_pk PRIMARY KEY ("userMissionId");


--
-- Name: votes usermission_un; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY votes
    ADD CONSTRAINT usermission_un UNIQUE ("user", mission);


--
-- Name: users users_aspUserId_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY users
    ADD CONSTRAINT "users_aspUserId_key" UNIQUE ("aspUserId");


--
-- Name: users users_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY users
    ADD CONSTRAINT users_pk PRIMARY KEY ("userId");


--
-- Name: userTag usertag_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "userTag"
    ADD CONSTRAINT usertag_pk PRIMARY KEY ("userTagId");


--
-- Name: votes votes_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY votes
    ADD CONSTRAINT votes_pk PRIMARY KEY ("voteId");


--
-- Name: AspNetRoles_RoleNameIndex; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX "AspNetRoles_RoleNameIndex" ON "AspNetRoles" USING btree ("Name");


--
-- Name: AspNetUserClaims_IX_UserId; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "AspNetUserClaims_IX_UserId" ON "AspNetUserClaims" USING btree ("UserId");


--
-- Name: AspNetUserLogins_IX_UserId; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "AspNetUserLogins_IX_UserId" ON "AspNetUserLogins" USING btree ("UserId");


--
-- Name: AspNetUserRoles_IX_RoleId; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "AspNetUserRoles_IX_RoleId" ON "AspNetUserRoles" USING btree ("RoleId");


--
-- Name: AspNetUserRoles_IX_UserId; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "AspNetUserRoles_IX_UserId" ON "AspNetUserRoles" USING btree ("UserId");


--
-- Name: AspNetUsers_UserNameIndex; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX "AspNetUsers_UserNameIndex" ON "AspNetUsers" USING btree ("UserName");


--
-- Name: bookMissions ondeletebookmission; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER ondeletebookmission AFTER DELETE ON "bookMissions" FOR EACH ROW EXECUTE PROCEDURE ondeletesubmission();


--
-- Name: languageMissions ondeletelanguagemission; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER ondeletelanguagemission AFTER DELETE ON "languageMissions" FOR EACH ROW EXECUTE PROCEDURE ondeletesubmission();


--
-- Name: scientificMissions ondeletesciencemission; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER ondeletesciencemission AFTER DELETE ON "scientificMissions" FOR EACH ROW EXECUTE PROCEDURE ondeletesubmission();


--
-- Name: sportMissions ondeletesportmission; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER ondeletesportmission AFTER DELETE ON "sportMissions" FOR EACH ROW EXECUTE PROCEDURE ondeletesubmission();


--
-- Name: users ondeletesubusertrigger; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER ondeletesubusertrigger AFTER DELETE ON users FOR EACH ROW EXECUTE PROCEDURE ondeletesubuser();


--
-- Name: AspNetUserClaims FK_public.AspNetUserClaims_public.AspNetUsers_UserId; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "AspNetUserClaims"
    ADD CONSTRAINT "FK_public.AspNetUserClaims_public.AspNetUsers_UserId" FOREIGN KEY ("UserId") REFERENCES "AspNetUsers"("Id") ON DELETE CASCADE;


--
-- Name: AspNetUserLogins FK_public.AspNetUserLogins_public.AspNetUsers_UserId; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "AspNetUserLogins"
    ADD CONSTRAINT "FK_public.AspNetUserLogins_public.AspNetUsers_UserId" FOREIGN KEY ("UserId") REFERENCES "AspNetUsers"("Id") ON DELETE CASCADE;


--
-- Name: AspNetUserRoles FK_public.AspNetUserRoles_public.AspNetRoles_RoleId; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "AspNetUserRoles"
    ADD CONSTRAINT "FK_public.AspNetUserRoles_public.AspNetRoles_RoleId" FOREIGN KEY ("RoleId") REFERENCES "AspNetRoles"("Id") ON DELETE CASCADE;


--
-- Name: AspNetUserRoles FK_public.AspNetUserRoles_public.AspNetUsers_UserId; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "AspNetUserRoles"
    ADD CONSTRAINT "FK_public.AspNetUserRoles_public.AspNetUsers_UserId" FOREIGN KEY ("UserId") REFERENCES "AspNetUsers"("Id") ON DELETE CASCADE;


--
-- Name: bookMissions bookMission_fk0; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "bookMissions"
    ADD CONSTRAINT "bookMission_fk0" FOREIGN KEY (id) REFERENCES missions("missionId") ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: bookMissions bookMission_fk1; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "bookMissions"
    ADD CONSTRAINT "bookMission_fk1" FOREIGN KEY (language) REFERENCES language("languageId") ON UPDATE SET NULL ON DELETE SET NULL;


--
-- Name: bookMissions bookMission_fk2; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "bookMissions"
    ADD CONSTRAINT "bookMission_fk2" FOREIGN KEY (subject) REFERENCES subjects("subjectId") ON UPDATE SET NULL ON DELETE SET NULL;


--
-- Name: comments comments_fk0; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY comments
    ADD CONSTRAINT comments_fk0 FOREIGN KEY ("user") REFERENCES users("userId") ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: comments comments_fk1; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY comments
    ADD CONSTRAINT comments_fk1 FOREIGN KEY (mission) REFERENCES missions("missionId") ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: follows follows_fk0; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY follows
    ADD CONSTRAINT follows_fk0 FOREIGN KEY (followed) REFERENCES users("userId") ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: follows follows_fk1; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY follows
    ADD CONSTRAINT follows_fk1 FOREIGN KEY (follower) REFERENCES users("userId") ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: languageMissions languageMissions_fk0; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "languageMissions"
    ADD CONSTRAINT "languageMissions_fk0" FOREIGN KEY (id) REFERENCES missions("missionId") ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: languageMissions languageMissions_fk1; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "languageMissions"
    ADD CONSTRAINT "languageMissions_fk1" FOREIGN KEY (language) REFERENCES language("languageId") ON UPDATE SET NULL ON DELETE SET NULL;


--
-- Name: languageMissions languageMissions_fk2; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "languageMissions"
    ADD CONSTRAINT "languageMissions_fk2" FOREIGN KEY ("languageLevel") REFERENCES "languageLevel"("languageLevelId") ON UPDATE SET NULL ON DELETE SET NULL;


--
-- Name: levels levels_fk0; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY levels
    ADD CONSTRAINT levels_fk0 FOREIGN KEY (rank) REFERENCES ranks("rankId");


--
-- Name: missionTag missionTag_fk0; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "missionTag"
    ADD CONSTRAINT "missionTag_fk0" FOREIGN KEY (tag) REFERENCES tags("tagId") ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: missionTag missionTag_fk1; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "missionTag"
    ADD CONSTRAINT "missionTag_fk1" FOREIGN KEY (mission) REFERENCES missions("missionId") ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: missions mission_fk0; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY missions
    ADD CONSTRAINT mission_fk0 FOREIGN KEY (suggestor) REFERENCES users("userId");


--
-- Name: notifications notifications_fk0; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY notifications
    ADD CONSTRAINT notifications_fk0 FOREIGN KEY ("notificatedUser") REFERENCES users("userId") ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: notifications notifications_fk1; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY notifications
    ADD CONSTRAINT notifications_fk1 FOREIGN KEY ("fromUser") REFERENCES users("userId") ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: notifications notifications_fk2; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY notifications
    ADD CONSTRAINT notifications_fk2 FOREIGN KEY ("aboutMission") REFERENCES missions("missionId") ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: scientificMissions scientificMissions_fk0; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "scientificMissions"
    ADD CONSTRAINT "scientificMissions_fk0" FOREIGN KEY (id) REFERENCES missions("missionId") ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: scientificMissions scientificMissions_fk1; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "scientificMissions"
    ADD CONSTRAINT "scientificMissions_fk1" FOREIGN KEY (subject) REFERENCES subjects("subjectId") ON UPDATE SET NULL ON DELETE SET NULL;


--
-- Name: sportMissions sportMissions_fk0; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "sportMissions"
    ADD CONSTRAINT "sportMissions_fk0" FOREIGN KEY (id) REFERENCES missions("missionId") ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: sportMissions sportMissions_fk1; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "sportMissions"
    ADD CONSTRAINT "sportMissions_fk1" FOREIGN KEY (type) REFERENCES "sportTypes"("sportTypeId") ON UPDATE SET NULL ON DELETE SET NULL;


--
-- Name: users userId_FK; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY users
    ADD CONSTRAINT "userId_FK" FOREIGN KEY ("aspUserId") REFERENCES "AspNetUsers"("Id") ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: userMission userMission_fk0; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "userMission"
    ADD CONSTRAINT "userMission_fk0" FOREIGN KEY ("user") REFERENCES users("userId") ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: userMission userMission_fk1; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "userMission"
    ADD CONSTRAINT "userMission_fk1" FOREIGN KEY (mission) REFERENCES missions("missionId") ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: userTag userTag_fk0; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "userTag"
    ADD CONSTRAINT "userTag_fk0" FOREIGN KEY ("user") REFERENCES users("userId") ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: userTag userTag_fk1; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "userTag"
    ADD CONSTRAINT "userTag_fk1" FOREIGN KEY (tag) REFERENCES tags("tagId") ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: users users_fk0; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY users
    ADD CONSTRAINT users_fk0 FOREIGN KEY (level) REFERENCES levels("levelId");


--
-- Name: votes votes_fk0; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY votes
    ADD CONSTRAINT votes_fk0 FOREIGN KEY ("user") REFERENCES users("userId") ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: votes votes_fk1; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY votes
    ADD CONSTRAINT votes_fk1 FOREIGN KEY (mission) REFERENCES missions("missionId") ON UPDATE CASCADE ON DELETE CASCADE;


--
-- PostgreSQL database dump complete
--

