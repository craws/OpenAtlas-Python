--
-- PostgreSQL database dump
--

-- Dumped from database version 11.5 (Debian 11.5-1+deb10u1)
-- Dumped by pg_dump version 11.5 (Debian 11.5-1+deb10u1)

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
-- Data for Name: class; Type: TABLE DATA; Schema: model; Owner: openatlas
--

INSERT INTO model.class VALUES (1, 'E56', 'Language', '2019-12-12 17:08:42.016696', NULL, 'This class is a specialization of E55 Type and comprises the natural languages in the sense of concepts. 
This type is used categorically in the model without reference to instances of it, i.e. the Model does not foresee the description of instances of instances of E56 Language, e.g.: “instances of  Mandarin Chinese”.
It is recommended that internationally or nationally agreed codes and terminology are used to denote instances of E56 Language, such as those defined in ISO 639:1988. 
');
INSERT INTO model.class VALUES (2, 'E69', 'Death', '2019-12-12 17:08:42.016696', NULL, 'This class comprises the deaths of human beings. 
If a person is killed, their death should be instantiated as E69 Death and as E7 Activity. The death or perishing of other living beings should be documented using E64 End of Existence.
');
INSERT INTO model.class VALUES (3, 'E42', 'Identifier', '2019-12-12 17:08:42.016696', NULL, 'This class comprises strings or codes assigned to instances of E1 CRM Entity in order to identify them uniquely and permanently within the context of one or more organisations. Such codes are often known as inventory numbers, registration codes, etc. and are typically composed of alphanumeric sequences. The class E42 Identifier is not normally used for machine-generated identifiers used for automated processing unless these are also used by human agents.');
INSERT INTO model.class VALUES (4, 'E90', 'Symbolic Object', '2019-12-12 17:08:42.016696', NULL, 'This class comprises identifiable symbols and any aggregation of symbols, such as characters, identifiers, traffic signs, emblems, texts, data sets, images, musical scores, multimedia objects, computer program code or mathematical formulae that have an objectively recognizable structure and that are documented as single units.
	It includes sets of signs of any nature, which may serve to designate something, or to communicate some propositional content.
	An instance of E90 Symbolic Object does not depend on a specific physical carrier, which can include human memory, and it can exist on one or more carriers simultaneously. An instance of E90 Symbolic Object may or may not have a specific meaning, for example an arbitrary character string.
	In some cases, the content of an instance of E90 Symbolic Object may completely be represented by a serialized content model, such.. as the property P3 has note allows for describing this content model…P3.1 has type: E55 Type to specify the encoding..
');
INSERT INTO model.class VALUES (5, 'E28', 'Conceptual Object', '2019-12-12 17:08:42.016696', NULL, 'This class comprises non-material products of our minds and other human produced data that 		have become objects of a discourse about their identity, circumstances of creation or historical 		implication. The production of such information may have been supported by the use of    		technical devices such as cameras or computers.
Characteristically, instances of this class are created, invented or thought by someone, and then may be documented or communicated between persons. Instances of E28 Conceptual Object have the ability to exist on more than one particular carrier at the same time, such as paper, electronic signals, marks, audio media, paintings, photos, human memories, etc.
They cannot be destroyed. They exist as long as they can be found on at least one carrier or in at least one human memory. Their existence ends when the last carrier and the last memory are lost. 
');
INSERT INTO model.class VALUES (6, 'E83', 'Type Creation', '2019-12-12 17:08:42.016696', NULL, 'This class comprises activities formally defining new types of items. 
It is typically a rigorous scholarly or scientific process that ensures a type is exhaustively described and appropriately named. In some cases, particularly in archaeology and the life sciences, E83 Type Creation requires the identification of an exemplary specimen and the publication of the type definition in an appropriate scholarly forum. The activity of E83 Type Creation is central to research in the life sciences, where a type would be referred to as a “taxon,” the type description as a “protologue,” and the exemplary specimens as “orgininal element” or “holotype”.
');
INSERT INTO model.class VALUES (7, 'E6', 'Destruction', '2019-12-12 17:08:42.016696', NULL, 'This class comprises events that destroy one or more instances of E18 Physical Thing such that they lose their identity as the subjects of documentation.  
Some destruction events are intentional, while others are independent of human activity. Intentional destruction may be documented by classifying the event as both an E6 Destruction and E7 Activity. 
The decision to document an object as destroyed, transformed or modified is context sensitive: 
1.  If the matter remaining from the destruction is not documented, the event is modelled solely as E6 Destruction. 
2. An event should also be documented using E81 Transformation if it results in the destruction of one or more objects and the simultaneous production of others using parts or material from the original. In this case, the new items have separate identities. Matter is preserved, but identity is not.
3. When the initial identity of the changed instance of E18 Physical Thing is preserved, the event should be documented as E11 Modification. 
');
INSERT INTO model.class VALUES (8, 'E38', 'Image', '2019-12-12 17:08:42.016696', NULL, 'This class comprises distributions of form, tone and colour that may be found on surfaces such as photos, paintings, prints and sculptures or directly on electronic media. 
The degree to which variations in the distribution of form and colour affect the identity of an instance of E38 Image depends on a given purpose. The original painting of the Mona Lisa in the Louvre may be said to bear the same instance of E38 Image as reproductions in the form of transparencies, postcards, posters or T-shirts, even though they may differ in size and carrier and may vary in tone and colour. The images in a “spot the difference” competition are not the same with respect to their context, however similar they may at first appear.
');
INSERT INTO model.class VALUES (9, 'E67', 'Birth', '2019-12-12 17:08:42.016696', NULL, 'This class comprises the births of human beings. E67 Birth is a biological event focussing on the context of people coming into life. (E63 Beginning of Existence comprises the coming into life of any living beings). 
Twins, triplets etc. are brought into life by the same E67 Birth event. The introduction of the E67 Birth event as a documentation element allows the description of a range of family relationships in a simple model. Suitable extensions may describe more details and the complexity of motherhood with the intervention of modern medicine. In this model, the biological father is not seen as a necessary participant in the E67 Birth event.
');
INSERT INTO model.class VALUES (10, 'E79', 'Part Addition', '2019-12-12 17:08:42.016696', NULL, 'This class comprises activities that result in an instance of E24 Physical Man-Made Thing being increased, enlarged or augmented by the addition of a part. 
Typical scenarios include the attachment of an accessory, the integration of a component, the addition of an element to an aggregate object, or the accessioning of an object into a curated E78 Collection. Objects to which parts are added are, by definition, man-made, since the addition of a part implies a human activity. Following the addition of parts, the resulting man-made assemblages are treated objectively as single identifiable wholes, made up of constituent or component parts bound together either physically (for example the engine becoming a part of the car), or by sharing a common purpose (such as the 32 chess pieces that make up a chess set). This class of activities forms a basis for reasoning about the history and continuity of identity of objects that are integrated into other objects over time, such as precious gemstones being repeatedly incorporated into different items of jewellery, or cultural artifacts being added to different museum instances of E78 Collection over their lifespan.
');
INSERT INTO model.class VALUES (11, 'E30', 'Right', '2019-12-12 17:08:42.016696', NULL, 'This class comprises legal privileges concerning material and immaterial things or their derivatives. 
These include reproduction and property rights');
INSERT INTO model.class VALUES (12, 'E36', 'Visual Item', '2019-12-12 17:08:42.016696', NULL, 'This class comprises the intellectual or conceptual aspects of recognisable marks and images.
This class does not intend to describe the idiosyncratic characteristics of an individual physical embodiment of a visual item, but the underlying prototype. For example, a mark such as the ICOM logo is generally considered to be the same logo when used on any number of publications. The size, orientation and colour may change, but the logo remains uniquely identifiable. The same is true of images that are reproduced many times. This means that visual items are independent of their physical support. 
The class E36 Visual Item provides a means of identifying and linking together instances of E24 Physical Man-Made Thing that carry the same visual symbols, marks or images etc. The property P62 depicts (is depicted by) between E24 Physical Man-Made Thing and depicted subjects (E1 CRM Entity) can be regarded as a short-cut of the more fully developed path from E24 Physical Man-Made Thing through P65 shows visual item (is shown by), E36 Visual Item, P138 represents (has representation) to E1CRM Entity, which in addition captures the optical features of the depiction.  
');
INSERT INTO model.class VALUES (13, 'E41', 'Appellation', '2019-12-12 17:08:42.016696', NULL, 'This class comprises signs, either meaningful or not, or arrangements of signs following a specific syntax, that are used or can be used to refer to and identify a specific instance of some class or category within a certain context.
Instances of E41 Appellation do not identify things by their meaning, even if they happen to have one, but instead by convention, tradition, or agreement. Instances of E41 Appellation are cultural constructs; as such, they have a context, a history, and a use in time and space by some group of users. A given instance of E41 Appellation can have alternative forms, i.e., other instances of E41 Appellation that are always regarded as equivalent independent from the thing it denotes. 
Specific subclasses of E41 Appellation should be used when instances of E41 Appellation of a characteristic form are used for particular objects. Instances of E49 Time Appellation, for example, which take the form of instances of E50 Date, can be easily recognised.
E41 Appellation should not be confused with the act of naming something. Cf. E15 Identifier Assignment
');
INSERT INTO model.class VALUES (14, 'E87', 'Curation Activity', '2019-12-12 17:08:42.016696', NULL, 'This class comprises the activities that result in the continuity of management and the preservation and evolution of instances of E78 Collection, following an implicit or explicit curation plan. 
It specializes the notion of activity into the curation of a collection and allows the history of curation to be recorded.
Items are accumulated and organized following criteria like subject, chronological period, material type, style of art etc. and can be added or removed from an E78 Collection for a specific purpose and/or audience. The initial aggregation of items of a collection is regarded as an instance of E12 Production Event while the activity of evolving, preserving and promoting a collection is regarded as an instance of E87 Curation Activity.
');
INSERT INTO model.class VALUES (15, 'E15', 'Identifier Assignment', '2019-12-12 17:08:42.016696', NULL, 'This class comprises activities that result in the allocation of an identifier to an instance of E1 CRM Entity. An E15 Identifier Assignment may include the creation of the identifier from multiple constituents, which themselves may be instances of E41 Appellation. The syntax and kinds of constituents to be used may be declared in a rule constituting an instance of E29 Design or Procedure.
Examples of such identifiers include Find Numbers, Inventory Numbers, uniform titles in the sense of librarianship and Digital Object Identifiers (DOI). Documenting the act of identifier assignment and deassignment is especially useful when objects change custody or the identification system of an organization is changed. In order to keep track of the identity of things in such cases, it is important to document by whom, when and for what purpose an identifier is assigned to an item.
The fact that an identifier is a preferred one for an organisation can be expressed by using the property E1 CRM Entity. P48 has preferred identifier (is preferred identifier of): E42 Identifier. It can better be expressed in a context independent form by assigning a suitable E55 Type, such as “preferred identifier assignment”, to the respective instance of E15 Identifier Assignment via the P2 has type property.
');
INSERT INTO model.class VALUES (16, 'E74', 'Group', '2019-12-12 17:08:42.016696', NULL, 'This class comprises any gatherings or organizations of E39 Actors that act collectively or in a similar way due to any form of unifying relationship. In the wider sense this class also comprises official positions which used to be regarded in certain contexts as one actor, independent of the current holder of the office, such as the president of a country. In such cases, it may happen that the Group never had more than one member. A joint pseudonym (i.e., a name that seems indicative of an individual but that is actually used as a persona by two or more people) is a particular case of E74 Group.
A gathering of people becomes an E74 Group when it exhibits organizational characteristics usually typified by a set of ideas or beliefs held in common, or actions performed together. These might be communication, creating some common artifact, a common purpose such as study, worship, business, sports, etc. Nationality can be modeled as membership in an E74 Group (cf. HumanML markup). Married couples and other concepts of family are regarded as particular examples of E74 Group.
');
INSERT INTO model.class VALUES (17, 'E20', 'Biological Object', '2019-12-12 17:08:42.016696', NULL, 'This class comprises individual items of a material nature, which live, have lived or are natural products of or from living organisms. 
Artificial objects that incorporate biological elements, such as Victorian butterfly frames, can be documented as both instances of E20 Biological Object and E22 Man-Made Object. 
');
INSERT INTO model.class VALUES (18, 'E24', 'Physical Man-Made Thing', '2019-12-12 17:08:42.016696', NULL, 'This class comprises all persistent physical items that are purposely created by human activity.
This class comprises man-made objects, such as a swords, and man-made features, such as rock art. No assumptions are made as to the extent of modification required to justify regarding an object as man-made. For example, a “cup and ring” carving on bedrock is regarded as instance of E24 Physical Man-Made Thing. 
');
INSERT INTO model.class VALUES (19, 'E82', 'Actor Appellation', '2019-12-12 17:08:42.016696', NULL, 'This class comprises any sort of name, number, code or symbol characteristically used to identify an E39 Actor. 
An E39 Actor will typically have more than one E82 Actor Appellation, and instances of E82 Actor Appellation in turn may have alternative representations. The distinction between corporate and personal names, which is particularly important in library applications, should be made by explicitly linking the E82 Actor Appellation to an instance of either E21 Person or E74 Group/E40 Legal Body. If this is not possible, the distinction can be made through the use of the P2 has type mechanism. 
');
INSERT INTO model.class VALUES (20, 'E47', 'Spatial Coordinates', '2019-12-12 17:08:42.016696', NULL, 'This class comprises the textual or numeric information required to locate specific instances of E53 Place within schemes of spatial identification. 

Coordinates are a specific form of E44 Place Appellation, that is, a means of referring to a particular E53 Place. Coordinates are not restricted to longitude, latitude and altitude. Any regular system of reference that maps onto an E19 Physical Object can be used to generate coordinates.
');
INSERT INTO model.class VALUES (21, 'E80', 'Part Removal', '2019-12-12 17:08:42.016696', NULL, 'This class comprises the activities that result in an instance of E18 Physical Thing being decreased by the removal of a part.
Typical scenarios include the detachment of an accessory, the removal of a component or part of a composite object, or the deaccessioning of an object from a curated E78 Collection. If the E80 Part Removal results in the total decomposition of the original object into pieces, such that the whole ceases to exist, the activity should instead be modelled as an E81 Transformation, i.e. a simultaneous destruction and production. In cases where the part removed has no discernible identity prior to its removal but does have an identity subsequent to its removal, the activity should be regarded as both E80 Part Removal and E12 Production. This class of activities forms a basis for reasoning about the history, and continuity of identity over time, of objects that are removed from other objects, such as precious gemstones being extracted from different items of jewelry, or cultural artifacts being deaccessioned from different museum collections over their lifespan.
');
INSERT INTO model.class VALUES (22, 'E22', 'Man-Made Object', '2019-12-12 17:08:42.016696', NULL, 'This class comprises physical objects purposely created by human activity.
No assumptions are made as to the extent of modification required to justify regarding an object as man-made. For example, an inscribed piece of rock or a preserved butterfly are both regarded as instances of E22 Man-Made Object.
');
INSERT INTO model.class VALUES (23, 'E3', 'Condition State', '2019-12-12 17:08:42.016696', NULL, 'This class comprises the states of objects characterised by a certain condition over a time-span. 
An instance of this class describes the prevailing physical condition of any material object or feature during a specific E52 Time Span. In general, the time-span for which a certain condition can be asserted may be shorter than the real time-span, for which this condition held.
 The nature of that condition can be described using P2 has type. For example, the E3 Condition State “condition of the SS Great Britain between 22 September 1846 and 27 August 1847” can be characterized as E55 Type “wrecked”. 
');
INSERT INTO model.class VALUES (24, 'E19', 'Physical Object', '2019-12-12 17:08:42.016696', NULL, 'This class comprises items of a material nature that are units for documentation and have physical boundaries that separate them completely in an objective way from other objects. 
The class also includes all aggregates of objects made for functional purposes of whatever kind, independent of physical coherence, such as a set of chessmen. Typically, instances of E19 Physical Object can be moved (if not too heavy).
In some contexts, such objects, except for aggregates, are also called “bona fide objects” (Smith & Varzi, 2000, pp.401-420), i.e. naturally defined objects. 
The decision as to what is documented as a complete item, rather than by its parts or components, may be a purely administrative decision or may be a result of the order in which the item was acquired.
');
INSERT INTO model.class VALUES (25, 'E27', 'Site', '2019-12-12 17:08:42.016696', NULL, 'This class comprises pieces of land or sea floor. 
In contrast to the purely geometric notion of E53 Place, this class describes constellations of matter on the surface of the Earth or other celestial body, which can be represented by photographs, paintings and maps.
 Instances of E27 Site are composed of relatively immobile material items and features in a particular configuration at a particular location');
INSERT INTO model.class VALUES (26, 'E93', 'Presence', '2019-12-12 17:08:42.016696', NULL, 'This class comprises instances of E92 Spacetime Volume that result from intersection of instances of E92 Spacetime Volume with an instance of E52 Time-Span.  The identity of an instance of this class is determined by the identities of the  constituing spacetime volume and the time-span. 
	
This class can be used to define temporal snapshots at a particular time-span, such as the extent of the Roman Empire at 33 B.C., or the extent occupied by a museum object at rest in an exhibit. In particular, it can be used to define the spatial projection of a spacetime volume during a particular time-span,  such as the maximal spatial extent of a flood at some particular hour, or all areas covered by the Poland within the 20th century AD.
');
INSERT INTO model.class VALUES (27, 'E77', 'Persistent Item', '2019-12-12 17:08:42.016696', NULL, 'This class comprises items that have a persistent identity, sometimes known as “endurants” in philosophy. 
They can be repeatedly recognized within the duration of their existence by identity criteria rather than by continuity or observation. Persistent Items can be either physical entities, such as people, animals or things, or conceptual entities such as ideas, concepts, products of the imagination or common names.
The criteria that determine the identity of an item are often difficult to establish -; the decision depends largely on the judgement of the observer. For example, a building is regarded as no longer existing if it is dismantled and the materials reused in a different configuration. On the other hand, human beings go through radical and profound changes during their life-span, affecting both material composition and form, yet preserve their identity by other criteria. Similarly, inanimate objects may be subject to exchange of parts and matter. The class E77 Persistent Item does not take any position about the nature of the applicable identity criteria and if actual knowledge about identity of an instance of this class exists. There may be cases, where the identity of an E77 Persistent Item is not decidable by a certain state of knowledge.
The main classes of objects that fall outside the scope the E77 Persistent Item class are temporal objects such as periods, events and acts, and descriptive properties. ');
INSERT INTO model.class VALUES (28, 'E58', 'Measurement Unit', '2019-12-12 17:08:42.016696', NULL, 'This class is a specialization of E55 Type and comprises the types of measurement units: feet, inches, centimetres, litres, lumens, etc. 
This type is used categorically in the model without reference to instances of it, i.e. the Model does not foresee the description of instances of instances of E58 Measurement Unit, e.g.: “instances of cm”.
Syst?me International (SI) units or internationally recognized non-SI terms should be used whenever possible. (ISO 1000:1992). Archaic Measurement Units used in historical records should be preserved.
');
INSERT INTO model.class VALUES (29, 'E13', 'Attribute Assignment', '2019-12-12 17:08:42.016696', NULL, 'This class comprises the actions of making assertions about properties of an object or any relation between two items or concepts. 
This class allows the documentation of how the respective assignment came about, and whose opinion it was. All the attributes or properties assigned in such an action can also be seen as directly attached to the respective item or concept, possibly as a collection of contradictory values. All cases of properties in this model that are also described indirectly through an action are characterised as "short cuts" of this action. This redundant modelling of two alternative views is preferred because many implementations may have good reasons to model either the action or the short cut, and the relation between both alternatives can be captured by simple rules. 
In particular, the class describes the actions of people making propositions and statements during certain museum procedures, e.g. the person and date when a condition statement was made, an identifier was assigned, the museum object was measured, etc. Which kinds of such assignments and statements need to be documented explicitly in structures of a schema rather than free text, depends on if this information should be accessible by structured queries. 
');
INSERT INTO model.class VALUES (30, 'E26', 'Physical Feature', '2019-12-12 17:08:42.016696', NULL, 'This class comprises identifiable features that are physically attached in an integral way to particular physical objects. 
Instances of E26 Physical Feature share many of the attributes of instances of E19 Physical Object. They may have a one-, two- or three-dimensional geometric extent, but there are no natural borders that separate them completely in an objective way from the carrier objects. For example, a doorway is a feature but the door itself, being attached by hinges, is not. 
Instances of E26 Physical Feature can be features in a narrower sense, such as scratches, holes, reliefs, surface colours, reflection zones in an opal crystal or a density change in a piece of wood. In the wider sense, they are portions of particular objects with partially imaginary borders, such as the core of the Earth, an area of property on the surface of the Earth, a landscape or the head of a contiguous marble statue. They can be measured and dated, and it is sometimes possible to state who or what is or was responsible for them. They cannot be separated from the carrier object, but a segment of the carrier object may be identified (or sometimes removed) carrying the complete feature. 
This definition coincides with the definition of "fiat objects" (Smith & Varzi, 2000, pp.401-420), with the exception of aggregates of “bona fide objects”. 
');
INSERT INTO model.class VALUES (31, 'E31', 'Document', '2019-12-12 17:08:42.016696', NULL, 'This class comprises identifiable immaterial items that make propositions about reality.
These propositions may be expressed in text, graphics, images, audiograms, videograms or by other similar means. Documentation databases are regarded as a special case of E31 Document. This class should not be confused with the term “document” in Information Technology, which is compatible with E73 Information Object.
');
INSERT INTO model.class VALUES (32, 'E45', 'Address', '2019-12-12 17:08:42.016696', NULL, 'This class comprises identifiers expressed in coding systems for places, such as postal addresses used for mailing.
An E45 Address can be considered both as the name of an E53 Place and as an E51 Contact Point for an E39 Actor. This dual aspect is reflected in the multiple inheritance. However, some forms of mailing addresses, such as a postal box, are only instances of E51 Contact Point, since they do not identify any particular Place. These should not be documented as instances of E45 Address.
');
INSERT INTO model.class VALUES (33, 'E21', 'Person', '2019-12-12 17:08:42.016696', NULL, 'This class comprises real persons who live or are assumed to have lived. 
Legendary figures that may have existed, such as Ulysses and King Arthur, fall into this class if the documentation refers to them as historical figures. In cases where doubt exists as to whether several persons are in fact identical, multiple instances can be created and linked to indicate their relationship. The CRM does not propose a specific form to support reasoning about possible identity.
');
INSERT INTO model.class VALUES (34, 'E71', 'Man-Made Thing', '2019-12-12 17:08:42.016696', NULL, 'This class comprises discrete, identifiable man-made items that are documented as single units. 
These items are either intellectual products or man-made physical things, and are characterized by relative stability. They may for instance have a solid physical form, an electronic encoding, or they may be logical concepts or structures.
');
INSERT INTO model.class VALUES (35, 'E12', 'Production', '2019-12-12 17:08:42.016696', NULL, 'This class comprises activities that are designed to, and succeed in, creating one or more new items. 
It specializes the notion of modification into production. The decision as to whether or not an object is regarded as new is context sensitive. Normally, items are considered “new” if there is no obvious overall similarity between them and the consumed items and material used in their production. In other cases, an item is considered “new” because it becomes relevant to documentation by a modification. For example, the scribbling of a name on a potsherd may make it a voting token. The original potsherd may not be worth documenting, in contrast to the inscribed one. 
This entity can be collective: the printing of a thousand books, for example, would normally be considered a single event. 
An event should also be documented using E81 Transformation if it results in the destruction of one or more objects and the simultaneous production of others using parts or material from the originals. In this case, the new items have separate identities and matter is preserved, but identity is not.
');
INSERT INTO model.class VALUES (36, 'E86', 'Leaving', '2019-12-12 17:08:42.016696', NULL, 'This class comprises the activities that result in an instance of E39 Actor to be disassociated from an instance of E74 Group. This class does not imply initiative by either party. It may be the initiative of a third party. 
Typical scenarios include the termination of membership in a social organisation, ending the employment at a company, divorce, and the end of tenure of somebody in an official position.');
INSERT INTO model.class VALUES (37, 'E5', 'Event', '2019-12-12 17:08:42.016696', NULL, 'This class comprises changes of states in cultural, social or physical systems, regardless of scale, brought about by a series or group of coherent physical, cultural, technological or legal phenomena. Such changes of state will affect instances of E77 Persistent Item or its subclasses.
The distinction between an E5 Event and an E4 Period is partly a question of the scale of observation. Viewed at a coarse level of detail, an E5 Event is an ‘instantaneous’ change of state. At a fine level, the E5 Event can be analysed into its component phenomena within a space and time frame, and as such can be seen as an E4 Period. The reverse is not necessarily the case: not all instances of E4 Period give rise to a noteworthy change of state.
');
INSERT INTO model.class VALUES (38, 'E33', 'Linguistic Object', '2019-12-12 17:08:42.016696', NULL, 'This class comprises identifiable expressions in natural language or languages. 
Instances of E33 Linguistic Object can be expressed in many ways: e.g. as written texts, recorded speech or sign language. However, the CRM treats instances of E33 Linguistic Object independently from the medium or method by which they are expressed. Expressions in formal languages, such as computer code or mathematical formulae, are not treated as instances of E33 Linguistic Object by the CRM. These should be modelled as instances of E73 Information Object.
The text of an instance of E33 Linguistic Object can be documented in a note by P3 has note: E62 String
');
INSERT INTO model.class VALUES (39, 'E34', 'Inscription', '2019-12-12 17:08:42.016696', NULL, 'This class comprises recognisable, short texts attached to instances of E24 Physical Man-Made Thing. 
The transcription of the text can be documented in a note by P3 has note: E62 String. The alphabet used can be documented by P2 has type: E55 Type. This class does not intend to describe the idiosyncratic characteristics of an individual physical embodiment of an inscription, but the underlying prototype. The physical embodiment is modelled in the CRM as E24 Physical Man-Made Thing.
The relationship of a physical copy of a book to the text it contains is modelled using E84 Information Carrier. P128 carries (is carried by): E33 Linguistic Object. 
');
INSERT INTO model.class VALUES (40, 'E70', 'Thing', '2019-12-12 17:08:42.016696', NULL, 'This general class comprises discrete, identifiable, instances of E77 Persistent Item that are documented as single units, that either consist of matter or depend on being carried by matter and are characterized by relative stability.
They may be intellectual products or physical things. They may for instance have a solid physical form, an electronic encoding, or they may be a logical concept or structure.
');
INSERT INTO model.class VALUES (41, 'E8', 'Acquisition', '2019-12-12 17:08:42.016696', NULL, 'This class comprises transfers of legal ownership from one or more instances of E39 Actor to one or more other instances of E39 Actor. 
The class also applies to the establishment or loss of ownership of instances of E18 Physical Thing. It does not, however, imply changes of any other kinds of right. The recording of the donor and/or recipient is optional. It is possible that in an instance of E8 Acquisition there is either no donor or no recipient. Depending on the circumstances, it may describe:
1.	the beginning of ownership
2.	the end of ownership
3.	the transfer of ownership
4.	the acquisition from an unknown source 
5.	the loss of title due to destruction of the item
It may also describe events where a collector appropriates legal title, for example by annexation or field collection. The interpretation of the museum notion of "accession" differs between institutions. The CRM therefore models legal ownership (E8 Acquisition) and physical custody (E10 Transfer of Custody) separately. Institutions will then model their specific notions of accession and deaccession as combinations of these.
');
INSERT INTO model.class VALUES (42, 'E40', 'Legal Body', '2019-12-12 17:08:42.016696', NULL, 'This class comprises institutions or groups of people that have obtained a legal recognition as a group and can act collectively as agents.  
This means that they can perform actions, own property, create or destroy things and can be held collectively responsible for their actions like individual people. The term ''personne morale'' is often used for this in French. 
');
INSERT INTO model.class VALUES (43, 'E25', 'Man-Made Feature', '2019-12-12 17:08:42.016696', NULL, 'This class comprises physical features that are purposely created by human activity, such as scratches, artificial caves, artificial water channels, etc. 
No assumptions are made as to the extent of modification required to justify regarding a feature as man-made. For example, rock art or even “cup and ring” carvings on bedrock a regarded as types of E25 Man-Made Feature.
');
INSERT INTO model.class VALUES (44, 'E64', 'End of Existence', '2019-12-12 17:08:42.016696', NULL, 'This class comprises events that end the existence of any E77 Persistent Item. 
It may be used for temporal reasoning about things (physical items, groups of people, living beings) ceasing to exist; it serves as a hook for determination of a terminus postquem and antequem. In cases where substance from a Persistent Item continues to exist in a new form, the process would be documented by E81 Transformation.
');
INSERT INTO model.class VALUES (45, 'E85', 'Joining', '2019-12-12 17:08:42.016696', NULL, 'This class comprises the activities that result in an instance of E39 Actor becoming a member of an instance of E74 Group. This class does not imply initiative by either party. It may be the initiative of a third party.
Typical scenarios include becoming a member of a social organisation, becoming employee of a company, marriage, the adoption of a child by a family and the inauguration of somebody into an official position. 
');
INSERT INTO model.class VALUES (46, 'E50', 'Date', '2019-12-12 17:08:42.016696', NULL, 'This class comprises specific forms of E49 Time Appellation.');
INSERT INTO model.class VALUES (47, 'E72', 'Legal Object', '2019-12-12 17:08:42.016696', NULL, 'This class comprises those material or immaterial items to which instances of E30 Right, such as the right of ownership or use, can be applied. 
This is true for all E18 Physical Thing. In the case of instances of E28 Conceptual Object, however, the identity of the E28 Conceptual Object or the method of its use may be too ambiguous to reliably establish instances of E30 Right, as in the case of taxa and inspirations. Ownership of corporations is currently regarded as out of scope of the CRM. 
');
INSERT INTO model.class VALUES (48, 'E44', 'Place Appellation', '2019-12-12 17:08:42.016696', NULL, 'This class comprises any sort of identifier characteristically used to refer to an E53 Place. 
Instances of E44 Place Appellation may vary in their degree of precision and their meaning may vary over time - the same instance of E44 Place Appellation may be used to refer to several places, either because of cultural shifts, or because objects used as reference points have moved around. Instances of E44 Place Appellation can be extremely varied in form: postal addresses, instances of E47 Spatial Coordinate, and parts of buildings can all be considered as instances of E44 Place Appellation.
');
INSERT INTO model.class VALUES (49, 'E17', 'Type Assignment', '2019-12-12 17:08:42.016696', NULL, 'This class comprises the actions of classifying items of whatever kind. Such items include objects, specimens, people, actions and concepts. 
This class allows for the documentation of the context of classification acts in cases where the value of the classification depends on the personal opinion of the classifier, and the date that the classification was made. This class also encompasses the notion of "determination," i.e. the systematic and molecular identification of a specimen in biology. 
');
INSERT INTO model.class VALUES (50, 'E66', 'Formation', '2019-12-12 17:08:42.016696', NULL, 'This class comprises events that result in the formation of a formal or informal E74 Group of people, such as a club, society, association, corporation or nation. 
E66 Formation does not include the arbitrary aggregation of people who do not act as a collective.
The formation of an instance of E74 Group does not require that the group is populated with members at the time of formation. In order to express the joining of members at the time of formation, the respective activity should be simultaneously an instance of both E66 Formation and E85 Joining. 
');
INSERT INTO model.class VALUES (51, 'E51', 'Contact Point', '2019-12-12 17:08:42.016696', NULL, 'This class comprises identifiers employed, or understood, by communication services to direct communications to an instance of E39 Actor. These include E-mail addresses, telephone numbers, post office boxes, Fax numbers, URLs etc. Most postal addresses can be considered both as instances of E44 Place Appellation and E51 Contact Point. In such cases the subclass E45 Address should be used. 
URLs are addresses used by machines to access another machine through an http request. Since the accessed machine acts on behalf of the E39 Actor providing the machine, URLs are considered as instances of E51 Contact Point to that E39 Actor.
');
INSERT INTO model.class VALUES (52, 'E78', 'Collection', '2019-12-12 17:08:42.016696', NULL, 'This class comprises aggregations of instances of E18 Physical Thing that are assembled and maintained ("curated" and "preserved", in museological terminology) by one or more instances of E39 Actor over time for a specific purpose and audience, and according to a particular collection development plan.  
Items may be added or removed from an E78 Collection in pursuit of this plan. This class should not be confused with the E39 Actor maintaining the E78 Collection often referred to with the name of the E78 Collection (e.g. “The Wallace Collection decided…”).
Collective objects in the general sense, like a tomb full of gifts, a folder with stamps or a set of chessmen, should be documented as instances of E19 Physical Object, and not as instances of E78 Collection. This is because they form wholes either because they are physically bound together or because they are kept together for their functionality.
');
INSERT INTO model.class VALUES (53, 'E46', 'Section Definition', '2019-12-12 17:08:42.016696', NULL, 'This class comprises areas of objects referred to in terms specific to the general geometry or structure of its kind. 
The ''prow'' of the boat, the ''frame'' of the picture, the ''front'' of the building are all instances of E46 Section Definition. The class highlights the fact that parts of objects can be treated as locations. This holds in particular for features without natural boundaries, such as the “head” of a marble statue made out of one block (cf. E53 Place). In answer to the question ''where is the signature?'' one might reply ''on the lower left corner''. (Section Definition is closely related to the term “segment” in Gerstl, P.& Pribbenow, S, 1996 “ A conceptual theory of part – whole relations and its applications”, Data & Knowledge 	Engineering 20 305-322, North Holland- Elsevier ).
');
INSERT INTO model.class VALUES (54, 'E49', 'Time Appellation', '2019-12-12 17:08:42.016696', NULL, 'This class comprises all forms of names or codes, such as historical periods, and dates, which are characteristically used to refer to a specific E52 Time-Span. 
The instances of E49 Time Appellation may vary in their degree of precision, and they may be relative to other time frames, “Before Christ” for example. Instances of E52 Time-Span are often defined by reference to a cultural period or an event e.g. ‘the duration of the Ming Dynasty’.');
INSERT INTO model.class VALUES (55, 'E68', 'Dissolution', '2019-12-12 17:08:42.016696', NULL, 'This class comprises the events that result in the formal or informal termination of an E74 Group of people. 
If the dissolution was deliberate, the Dissolution event should also be instantiated as an E7 Activity.
');
INSERT INTO model.class VALUES (56, 'E37', 'Mark', '2019-12-12 17:08:42.016696', NULL, 'This class comprises symbols, signs, signatures or short texts applied to instances of E24 Physical Man-Made Thing by arbitrary techniques in order to indicate the creator, owner, dedications, purpose, etc. 
This class specifically excludes features that have no semantic significance, such as scratches or tool marks. These should be documented as instances of E25 Man-Made Feature. 
');
INSERT INTO model.class VALUES (57, 'E9', 'Move', '2019-12-12 17:08:42.016696', NULL, 'This class comprises changes of the physical location of the instances of E19 Physical Object. 
Note, that the class E9 Move inherits the property P7 took place at (witnessed): E53 Place. This property should be used to describe the trajectory or a larger area within which a move takes place, whereas the properties P26 moved to (was destination of), P27 moved from (was origin of) describe the start and end points only. Moves may also be documented to consist of other moves (via P9 consists of (forms part of)), in order to describe intermediate stages on a trajectory. In that case, start and end points of the partial moves should match appropriately between each other and with the overall event.
');
INSERT INTO model.class VALUES (58, 'E65', 'Creation', '2019-12-12 17:08:42.016696', NULL, 'This class comprises events that result in the creation of conceptual items or immaterial products, such as legends, poems, texts, music, images, movies, laws, types etc.
');
INSERT INTO model.class VALUES (59, 'E57', 'Material', '2019-12-12 17:08:42.016696', NULL, 'This class is a specialization of E55 Type and comprises the concepts of materials. 
Instances of E57 Material may denote properties of matter before its use, during its use, and as incorporated in an object, such as ultramarine powder, tempera paste, reinforced concrete. Discrete pieces of raw-materials kept in museums, such as bricks, sheets of fabric, pieces of metal, should be modelled individually in the same way as other objects. Discrete used or processed pieces, such as the stones from Nefer Titi''s temple, should be modelled as parts (cf. P46 is composed of).
This type is used categorically in the model without reference to instances of it, i.e. the Model does not foresee the description of instances of instances of E57 Material, e.g.: “instances of  gold”.
It is recommended that internationally or nationally agreed codes and terminology are used.');
INSERT INTO model.class VALUES (60, 'E32', 'Authority Document', '2019-12-12 17:08:42.016696', NULL, 'This class comprises encyclopaedia, thesauri, authority lists and other documents that define terminology or conceptual systems for consistent use.
');
INSERT INTO model.class VALUES (61, 'E63', 'Beginning of Existence', '2019-12-12 17:08:42.016696', NULL, 'This class comprises events that bring into existence any E77 Persistent Item. 
It may be used for temporal reasoning about things (intellectual products, physical items, groups of people, living beings) beginning to exist; it serves as a hook for determination of a terminus post quem and ante quem. ');
INSERT INTO model.class VALUES (62, 'E16', 'Measurement', '2019-12-12 17:08:42.016696', NULL, 'This class comprises actions measuring physical properties and other values that can be determined by a systematic procedure. 
Examples include measuring the monetary value of a collection of coins or the running time of a specific video cassette. 
The E16 Measurement may use simple counting or tools, such as yardsticks or radiation detection devices. The interest is in the method and care applied, so that the reliability of the result may be judged at a later stage, or research continued on the associated documents. The date of the event is important for dimensions, which may change value over time, such as the length of an object subject to shrinkage. Details of methods and devices are best handled as free text, whereas basic techniques such as "carbon 14 dating" should be encoded using P2 has type (is type of:) E55 Type.
');
INSERT INTO model.class VALUES (63, 'E54', 'Dimension', '2019-12-12 17:08:42.016696', NULL, 'This class comprises quantifiable properties that can be measured by some calibrated means and can be approximated by values, i.e. points or regions in a mathematical or conceptual space, such as natural or real numbers, RGB values etc.
An instance of E54 Dimension represents the true quantity, independent from its numerical approximation, e.g. in inches or in cm. The properties of the class E54 Dimension allow for expressing the numerical approximation of the values of an instance of E54 Dimension. If the true values belong to a non-discrete space, such as spatial distances, it is recommended to record them as approximations by intervals or regions of indeterminacy enclosing the assumed true values. For instance, a length of 5 cm may be recorded as 4.5-5.5 cm, according to the precision of the respective observation. Note, that interoperability of values described in different units depends critically on the representation as value regions.
Numerical approximations in archaic instances of E58 Measurement Unit used in historical records should be preserved. Equivalents corresponding to current knowledge should be recorded as additional instances of E54 Dimension as appropriate.
');
INSERT INTO model.class VALUES (64, 'E84', 'Information Carrier', '2019-12-12 17:08:42.016696', NULL, 'This class comprises all instances of E22 Man-Made Object that are explicitly designed to act as persistent physical carriers for instances of E73 Information Object.
An E84 Information Carrier may or may not contain information, e.g., a diskette. Note that any E18 Physical Thing may carry information, such as an E34 Inscription. However, unless it was specifically designed for this purpose, it is not an Information Carrier. Therefore the property P128 carries (is carried by) applies to E18 Physical Thing in general.
	');
INSERT INTO model.class VALUES (65, 'E48', 'Place Name', '2019-12-12 17:08:42.016696', NULL, 'This class comprises particular and common forms of E44 Place Appellation. 
Place Names may change their application over time: the name of an E53 Place may change, and a name may be reused for a different E53 Place. Instances of E48 Place Name are typically subject to place name gazetteers.');
INSERT INTO model.class VALUES (66, 'E52', 'Time-Span', '2019-12-12 17:08:42.016696', NULL, 'This class comprises abstract temporal extents, in the sense of Galilean physics, having a beginning, an end and a duration. 
Time Span has no other semantic connotations. Time-Spans are used to define the temporal extent of instances of E4 Period, E5 Event and any other phenomena valid for a certain time. An E52 Time-Span may be identified by one or more instances of E49 Time Appellation. 
Since our knowledge of history is imperfect, instances of E52 Time-Span can best be considered as approximations of the actual Time-Spans of temporal entities. The properties of E52 Time-Span are intended to allow these approximations to be expressed precisely.  An extreme case of approximation, might, for example, define an E52 Time-Span having unknown beginning, end and duration. Used as a common E52 Time-Span for two events, it would nevertheless define them as being simultaneous, even if nothing else was known. 
	Automatic processing and querying of instances of E52 Time-Span is facilitated if data can be parsed into an E61 Time Primitive.
');
INSERT INTO model.class VALUES (67, 'E39', 'Actor', '2019-12-12 17:08:42.016696', NULL, 'This class comprises people, either individually or in groups, who have the potential to perform intentional actions of kinds for which someone may be held responsible.
The CRM does not attempt to model the inadvertent actions of such actors. Individual people should be documented as instances of E21 Person, whereas groups should be documented as instances of either E74 Group or its subclass E40 Legal Body.
');
INSERT INTO model.class VALUES (68, 'E75', 'Conceptual Object Appellation', '2019-12-12 17:08:42.016696', NULL, 'This class comprises appellations that are by their form or syntax specific to identifying instances of E28 Conceptual Object, such as intellectual products, standardized patterns etc.');
INSERT INTO model.class VALUES (69, 'E53', 'Place', '2019-12-12 17:08:42.016696', NULL, 'This class comprises extents in space, in particular on the surface of the earth, in the pure sense of physics: independent from temporal phenomena and matter. 
The instances of E53 Place are usually determined by reference to the position of “immobile” objects such as buildings, cities, mountains, rivers, or dedicated geodetic marks. A Place can be determined by combining a frame of reference and a location with respect to this frame. It may be identified by one or more instances of E44 Place Appellation.
 It is sometimes argued that instances of E53 Place are best identified by global coordinates or absolute reference systems. However, relative references are often more relevant in the context of cultural documentation and tend to be more precise. In particular, we are often interested in position in relation to large, mobile objects, such as ships. For example, the Place at which Nelson died is known with reference to a large mobile object – H.M.S Victory. A resolution of this Place in terms of absolute coordinates would require knowledge of the movements of the vessel and the precise time of death, either of which may be revised, and the result would lack historical and cultural relevance.
Any object can serve as a frame of reference for E53 Place determination. The model foresees the notion of a "section" of an E19 Physical Object as a valid E53 Place determination.');
INSERT INTO model.class VALUES (70, 'E73', 'Information Object', '2019-12-12 17:08:42.016696', NULL, 'This class comprises identifiable immaterial items, such as a poems, jokes, data sets, images, texts, multimedia objects, procedural prescriptions, computer program code, algorithm or mathematical formulae, that have an objectively recognizable structure and are documented as single units. The encoding structure known as a "named graph" also falls under this class, so that each "named graph" is an instance of an E73 Information Object. 
An E73 Information Object does not depend on a specific physical carrier, which can include human memory, and it can exist on one or more carriers simultaneously. 
Instances of E73 Information Object of a linguistic nature should be declared as instances of the E33 Linguistic Object subclass. Instances of E73 Information Object of a documentary nature should be declared as instances of the E31 Document subclass. Conceptual items such as types and classes are not instances of E73 Information Object, nor are ideas without a reproducible expression. 
 ');
INSERT INTO model.class VALUES (71, 'E7', 'Activity', '2019-12-12 17:08:42.016696', NULL, 'This class comprises actions intentionally carried out by instances of E39 Actor that result in changes of state in the cultural, social, or physical systems documented. 
This notion includes complex, composite and long-lasting actions such as the building of a settlement or a war, as well as simple, short-lived actions such as the opening of a door.
');
INSERT INTO model.class VALUES (72, 'E55', 'Type', '2019-12-12 17:08:42.016696', NULL, 'This class comprises concepts denoted by terms from thesauri and controlled vocabularies used to characterize and classify instances of CRM classes. Instances of E55 Type represent concepts  in contrast to instances of E41 Appellation which are used to name instances of CRM classes. 
E55 Type is the CRM’s interface to domain specific ontologies and thesauri. These can be represented in the CRM as subclasses of E55 Type, forming hierarchies of terms, i.e. instances of E55 Type linked via P127 has broader  term (has narrower term). Such hierarchies may be extended with additional properties. 
');
INSERT INTO model.class VALUES (73, 'E10', 'Transfer of Custody', '2019-12-12 17:08:42.016696', NULL, 'This class comprises transfers of physical custody of objects between instances of E39 Actor. 
The recording of the donor and/or recipient is optional. It is possible that in an instance of E10 Transfer of Custody there is either no donor or no recipient. Depending on the circumstances it may describe:
1.	the beginning of custody 
2.	the end of custody 
3.	the transfer of custody 
4.	the receipt of custody from an unknown source
5.	the declared loss of an object
The distinction between the legal responsibility for custody and the actual physical possession of the object should be expressed using the property P2 has type (is type of). A specific case of transfer of custody is theft.
The interpretation of the museum notion of "accession" differs between institutions. The CRM therefore models legal ownership and physical custody separately. Institutions will then model their specific notions of accession and deaccession as combinations of these.
');
INSERT INTO model.class VALUES (74, 'E29', 'Design or Procedure', '2019-12-12 17:08:42.016696', NULL, 'This class comprises documented plans for the execution of actions in order to achieve a result of a specific quality, form or contents. In particular it comprises plans for deliberate human activities that may result in the modification or production of instances of E24 Physical Thing. 
Instances of E29 Design or Procedure can be structured in parts and sequences or depend on others. This is modelled using P69 has association with (is associated with). 
Designs or procedures can be seen as one of the following:
1.	A schema for the activities it describes
2.	A schema of the products that result from their application. 
3.	An independent intellectual product that may have never been applied, such as Leonardo da Vinci’s famous plans for flying machines.
Because designs or procedures may never be applied or only partially executed, the CRM models a loose relationship between the plan and the respective product.
');
INSERT INTO model.class VALUES (75, 'E11', 'Modification', '2019-12-12 17:08:42.016696', NULL, 'This class comprises all instances of E7 Activity that create, alter or change E24 Physical Man-Made Thing. 
This class includes the production of an item from raw materials, and other so far undocumented objects, and the preventive treatment or restoration of an object for conservation. 
Since the distinction between modification and production is not always clear, modification is regarded as the more generally applicable concept. This implies that some items may be consumed or destroyed in a Modification, and that others may be produced as a result of it. An event should also be documented using E81 Transformation if it results in the destruction of one or more objects and the simultaneous production of others using parts or material from the originals. In this case, the new items have separate identities. 
If the instance of the E29 Design or Procedure utilized for the modification prescribes the use of specific materials, they should be documented using property P68 foresees use of (use foreseen by): E57 Material of E29 Design or Procedure, rather than via P126 employed (was employed in): E57 Material.
');
INSERT INTO model.class VALUES (76, 'E35', 'Title', '2019-12-12 17:08:42.016696', NULL, 'This class comprises the names assigned to works, such as texts, artworks or pieces of music. 
Titles are proper noun phrases or verbal phrases, and should not be confused with generic object names such as “chair”, “painting” or “book” (the latter are common nouns that stand for instances of E55 Type). Titles may be assigned by the creator of the work itself, or by a social group. 
This class also comprises the translations of titles that are used as surrogates for the original titles in different social contexts.
');
INSERT INTO model.class VALUES (77, 'E89', 'Propositional Object', '2019-12-12 17:08:42.016696', NULL, 'This class comprises immaterial items, including but not limited to stories, plots, procedural prescriptions, algorithms, laws of physics or images that are, or represent in some sense, sets of propositions about real or imaginary things and that are documented as single units or serve as topics of discourse. 
	
This class also comprises items that are “about” something in the sense of a subject. In the wider sense, this class includes expressions of psychological value such as non-figural art and musical themes. However, conceptual items such as types and classes are not instances of E89 Propositional Object. This should not be confused with the definition of a type, which is indeed an instance of E89 Propositional Object.
');
INSERT INTO model.class VALUES (78, 'E4', 'Period', '2019-12-12 17:08:42.016696', NULL, 'This class comprises sets of coherent phenomena or cultural manifestations occurring in time and space.

It is the social or physical coherence of these phenomena that identify an E4 Period and not the associated spatiotemporal extent. This extent is only the "ground" or space in an abstract physical sense that the actual process of growth, spread and retreat has covered. Consequently, different periods can overlap and coexist in time and space, such as when a nomadic culture exists in the same area and time as a sedentary culture. This also means that overlapping land use rights, common among first nations, amounts to overlapping periods.

Often, this class is used to describe prehistoric or historic periods such as the "Neolithic Period", the "Ming Dynasty" or the "McCarthy Era", but also geopolitical units and activities of settlements are regarded as special cases of E4 Period. However, there are no assumptions about the scale of the associated phenomena. In particular all events are seen as synthetic processes consisting of coherent phenomena. Therefore E4 Period is a superclass of E5 Event. For example, a modern clinical E67 Birth can be seen as both an atomic E5 Event and as an E4 Period that consists of multiple activities performed by multiple instances of E39 Actor.

As the actual extent of an E4 Period in spacetime we regard the trajectories of the participating physical things during their participation in an instance of E4 Period. This includes the open spaces via which these things have interacted and the spaces by which they had the potential to interact during that period or event in the way defined by the type of the respective period or event. Examples include the air in a meeting room transferring the voices of the participants. Since these phenomena are fuzzy, we assume the spatiotemporal extent to be contiguous, except for cases of phenomena spreading out over islands or other separated areas, including geopolitical units distributed over disconnected areas such as islands or colonies.

Whether the trajectories necessary for participants to travel between these areas are regarded as part of the spatiotemporal extent or not has to be decided in each case based on a concrete analysis, taking use of the sea for other purposes than travel, such as fishing, into consideration. One may also argue that the activities to govern disconnected areas imply travelling through spaces connecting them and that these areas hence are spatially connected in a way, but it appears counterintuitive to consider for instance travel routes in international waters as extensions of geopolitical units.

Consequently, an instance of E4 Period may occupy a number of disjoint spacetime volumes, however there must not be a discontinuity in the  timespan covered by these spacetime volumes. This means that an instance of E4 Period must be contiguous in time. If it has ended in all areas, it has ended as a whole. However it may end in one area before another, such as in the Polynesian migration, and it continues as long as it is ongoing in at least  one area.

We model E4 Period as a subclass of E2 Temporal Entity and of E92 Spacetime volume. The latter is intended as a phenomenal spacetime volume as defined in CRMgeo (Doerr and Hiebel 2013). By virtue of this multiple inheritance we can discuss the physical extent of an E4 Period without representing each instance of it together with an instance of its associated spacetime volume. This model combines two quite different kinds of substance: an instance of E4 Period is a phenomena while a space-time volume is an aggregation of points in spacetime. However, the real spatiotemporal extent of an instance of E4 Period is regarded to be unique to it due to all its details and fuzziness; its identity and existence depends uniquely on the identity of the instance of E4 Period. Therefore this multiple inheritance is unambiguous and effective and furthermore corresponds to the intuitions of natural language.

There are two different conceptualisations of ''artistic style'', defined either by physical features or by historical context. For example, “Impressionism” can be viewed as a period lasting from approximately 1870 to 1905 during which paintings with particular characteristics were produced by a group of artists that included (among others) Monet, Renoir, Pissarro, Sisley and Degas. Alternatively, it can be regarded as a style applicable to all paintings sharing the characteristics of the works produced by the Impressionist painters, regardless of historical context. The first interpretation is an instance of E4 Period, and the second defines morphological object types that fall under E55 Type.

Another specific case of an E4 Period is the set of activities and phenomena associated with a settlement, such as the populated period of Nineveh.
');
INSERT INTO model.class VALUES (79, 'E14', 'Condition Assessment', '2019-12-12 17:08:42.016696', NULL, 'This class describes the act of assessing the state of preservation of an object during a particular period. 
The condition assessment may be carried out by inspection, measurement or through historical research. This class is used to document circumstances of the respective assessment that may be relevant to interpret its quality at a later stage, or to continue research on related documents. 
');
INSERT INTO model.class VALUES (80, 'E1', 'CRM Entity', '2019-12-12 17:08:42.016696', NULL, 'This class comprises all things in the universe of discourse of the CIDOC Conceptual Reference Model. 
It is an abstract concept providing for three general properties:
1.	Identification by name or appellation, and in particular by a preferred identifier
2.	Classification by type, allowing further refinement of the specific subclass an instance belongs to 
3.	Attachment of free text for the expression of anything not captured by formal properties
With the exception of E59 Primitive Value, all other classes within the CRM are directly or indirectly specialisations of E1 CRM Entity. 
');
INSERT INTO model.class VALUES (81, 'E92', 'Spacetime Volume', '2019-12-12 17:08:42.016696', NULL, 'This class comprises 4 dimensional point sets (volumes) in physical spacetime regardless its true geometric form. They may derive their identity from being the extent of a material phenomenon or from being the interpretation of an expression defining an extent in spacetime. 
	Intersections of instances of E92 Spacetime Volume, Place and Timespan are also regarded as instances of E92 Spacetime Volume.  An instance of E92 Spacetime Volume is either contiguous or composed of a finite number of contiguous subsets. 
	Its boundaries may be fuzzy due to the properties of the phenomena it derives from or due to the limited precision up to which defining expression can be identified with a real extent in spacetime. The duration of existence of an instance of a spacetime volume is trivially its projection on time.
');
INSERT INTO model.class VALUES (82, 'E2', 'Temporal Entity', '2019-12-12 17:08:42.016696', NULL, 'This class comprises all phenomena, such as the instances of E4 Periods, E5 Events and states, which happen over a limited extent in time. 
	In some contexts, these are also called perdurants. This class is disjoint from E77 Persistent Item. This is an abstract class and has no direct instances. E2 Temporal Entity is specialized into E4 Period, which applies to a particular geographic area (defined with a greater or lesser degree of precision), and E3 Condition State, which applies to instances of E18 Physical Thing.
');
INSERT INTO model.class VALUES (83, 'E18', 'Physical Thing', '2019-12-12 17:08:42.016696', NULL, 'This class comprises all persistent physical items with a relatively stable form, man-made or natural.

Depending on the existence of natural boundaries of such things, the CRM distinguishes the instances of E19 Physical Object from instances of E26 Physical Feature, such as holes, rivers, pieces of land etc. Most instances of E19 Physical Object can be moved (if not too heavy), whereas features are integral to the surrounding matter.

An instance of E18 Physical Thing occupies not only a particular geometric space, but in the course of its existence it also forms a trajectory through spacetime, which occupies a real, that is phenomenal, volume in spacetime. We include in the occupied space the space filled by the matter of the physical thing and all its inner spaces, such as the interior of a box. Physical things consisting of aggregations of physically unconnected objects, such as a set of chessmen, occupy a number of individually contiguous spacetime volumes equal to the number of unconnected objects that constitute the set.

We model E18 Physical Thing to be a subclass of E72 Legal Object and of E92 Spacetime volume. The latter is intended as a phenomenal spacetime volume as defined in CRMgeo (Doerr and Hiebel 2013). By virtue of this multiple inheritance we can discuss the physical extent of an E18 Physical Thing without representing each instance of it together with an instance of its associated spacetime volume. This model combines two quite different kinds of substance: an instance of E18 Physical Thing is matter while a spacetime volume is an aggregation of points in spacetime. However, the real spatiotemporal extent of an instance of E18 Physical Thing is regarded to be unique to it, due to all its details and fuzziness; its identity and existence depends uniquely on the identity of the instance of E18 Physical Thing. Therefore this multiple inheritance is unambiguous and effective and furthermore corresponds to the intuitions of natural language.

The CIDOC CRM is generally not concerned with amounts of matter in fluid or gaseous states. 
');
INSERT INTO model.class VALUES (84, 'E81', 'Transformation', '2019-12-12 17:08:42.016696', NULL, 'This class comprises the events that result in the simultaneous destruction of one or more than one E77 Persistent Item and the creation of one or more than one E77 Persistent Item that preserves recognizable substance from the first one(s) but has fundamentally different nature and identity. 
Although the old and the new instances of E77 Persistent Item are treated as discrete entities having separate, unique identities, they are causally connected through the E81 Transformation; the destruction of the old E77 Persistent Item(s) directly causes the creation of the new one(s) using or preserving some relevant substance. Instances of E81 Transformation are therefore distinct from re-classifications (documented using E17 Type Assignment) or modifications (documented using E11 Modification) of objects that do not fundamentally change their nature or identity. Characteristic cases are reconstructions and repurposing of historical buildings or ruins, fires leaving buildings in ruins, taxidermy of specimen in natural history and the reorganization of a corporate body into a new one.
');


--
-- Data for Name: class_i18n; Type: TABLE DATA; Schema: model; Owner: openatlas
--

INSERT INTO model.class_i18n VALUES (1, 'E56', 'de', 'Sprache', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (2, 'E56', 'en', 'Language', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (3, 'E56', 'fr', 'Langue', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (4, 'E56', 'ru', 'Язык', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (5, 'E56', 'el', 'Γλώσσα', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (6, 'E56', 'pt', 'Língua', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (7, 'E56', 'zh', '语言', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (8, 'E69', 'de', 'Tod', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (9, 'E69', 'en', 'Death', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (10, 'E69', 'fr', 'Mort', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (11, 'E69', 'ru', 'Смерть', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (12, 'E69', 'el', 'Θάνατος', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (13, 'E69', 'pt', 'Morte', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (14, 'E69', 'zh', '死亡', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (15, 'E42', 'de', 'Kennung', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (16, 'E42', 'en', 'Identifier', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (17, 'E42', 'fr', 'Identificateur d''objet', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (18, 'E42', 'ru', 'Идентификатор Объекта', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (19, 'E42', 'el', 'Κωδικός Αναγνώρισης', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (20, 'E42', 'pt', 'Identificador de Objeto', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (21, 'E42', 'zh', '标识符', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (22, 'E90', 'de', 'Symbolisches Objekt', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (23, 'E90', 'en', 'Symbolic Object', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (24, 'E90', 'zh', '符号物件', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (25, 'E28', 'de', 'Begrifflicher Gegenstand', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (26, 'E28', 'en', 'Conceptual Object', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (27, 'E28', 'fr', 'Objet conceptuel', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (28, 'E28', 'ru', 'Концептуальный Объект', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (29, 'E28', 'el', 'Νοητικό Αντικείμενο', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (30, 'E28', 'pt', 'Objeto Conceitual', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (31, 'E28', 'zh', '概念物件', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (32, 'E83', 'de', 'Typuserfindung', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (33, 'E83', 'en', 'Type Creation', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (34, 'E83', 'fr', 'Création de type', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (35, 'E83', 'ru', 'Создание Типа', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (36, 'E83', 'el', 'Δημιουργία Τύπου', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (37, 'E83', 'pt', 'Criação de Tipo', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (38, 'E83', 'zh', '类型创造', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (39, 'E6', 'de', 'Zerstörung', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (40, 'E6', 'en', 'Destruction', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (41, 'E6', 'fr', 'Destruction', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (42, 'E6', 'ru', 'Разрушение', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (43, 'E6', 'el', 'Καταστροφή', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (44, 'E6', 'pt', 'Destruição', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (45, 'E6', 'zh', '摧毁', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (46, 'E38', 'de', 'Bild', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (47, 'E38', 'en', 'Image', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (48, 'E38', 'fr', 'Image', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (49, 'E38', 'ru', 'Изображение', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (50, 'E38', 'el', 'Εικόνα', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (51, 'E38', 'pt', 'Imagem', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (52, 'E38', 'zh', '图像', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (53, 'E67', 'de', 'Geburt', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (54, 'E67', 'en', 'Birth', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (55, 'E67', 'fr', 'Naissance', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (56, 'E67', 'ru', 'Рождение', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (57, 'E67', 'el', 'Γέννηση', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (58, 'E67', 'pt', 'Nascimento', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (59, 'E67', 'zh', '诞生', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (60, 'E79', 'de', 'Teilhinzufügung', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (61, 'E79', 'en', 'Part Addition', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (62, 'E79', 'fr', 'Addition d''élément', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (63, 'E79', 'ru', 'Добавление Части', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (64, 'E79', 'el', 'Προσθήκη Μερών', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (65, 'E79', 'pt', 'Adição de Parte', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (66, 'E79', 'zh', '部件增加', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (67, 'E30', 'de', 'Recht', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (68, 'E30', 'en', 'Right', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (69, 'E30', 'fr', 'Droit', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (70, 'E30', 'ru', 'Право', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (71, 'E30', 'el', 'Δικαίωμα', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (72, 'E30', 'pt', 'Direitos', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (73, 'E30', 'zh', '权限', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (74, 'E36', 'de', 'Bildliches', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (75, 'E36', 'en', 'Visual Item', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (76, 'E36', 'fr', 'Item visuel', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (77, 'E36', 'ru', 'Визуальный Предмет', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (78, 'E36', 'el', 'Οπτικό Στοιχείο', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (79, 'E36', 'pt', 'Item Visual', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (80, 'E36', 'zh', '视觉项目', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (81, 'E41', 'de', 'Benennung', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (82, 'E41', 'en', 'Appellation', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (83, 'E41', 'fr', 'Appellation', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (84, 'E41', 'ru', 'Обозначение', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (85, 'E41', 'el', 'Ονομασία', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (86, 'E41', 'pt', 'Designação', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (87, 'E41', 'zh', '称号', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (88, 'E87', 'de', 'Kuratorische Tätigkeit', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (89, 'E87', 'en', 'Curation Activity', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (90, 'E87', 'zh', '典藏管理', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (91, 'E15', 'de', 'Kennzeichenzuweisung', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (92, 'E15', 'en', 'Identifier Assignment', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (93, 'E15', 'fr', 'Attribution d’identificateur', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (94, 'E15', 'ru', 'Назначение Идентификатора', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (95, 'E15', 'el', 'Απόδοση Αναγνωριστικού', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (96, 'E15', 'pt', 'Atribuição de Identificador', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (97, 'E15', 'zh', '标识符指定', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (98, 'E74', 'de', 'Menschliche Gruppe', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (99, 'E74', 'en', 'Group', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (100, 'E74', 'fr', 'Groupe', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (101, 'E74', 'ru', 'Группа', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (102, 'E74', 'el', 'Ομάδα', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (103, 'E74', 'pt', 'Grupo', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (104, 'E74', 'zh', '群组', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (105, 'E20', 'de', 'Biologischer Gegenstand', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (106, 'E20', 'en', 'Biological Object', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (107, 'E20', 'fr', 'Objet biologique', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (108, 'E20', 'ru', 'Биологический Объект', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (109, 'E20', 'el', 'Βιολογικό Ακτικείμενο', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (110, 'E20', 'pt', 'Objeto Biológico', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (111, 'E20', 'zh', '生物体', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (112, 'E24', 'de', 'Hergestelltes', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (113, 'E24', 'en', 'Physical Man-Made Thing', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (114, 'E24', 'fr', 'Chose matérielle fabriquée', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (115, 'E24', 'ru', 'Физическая Рукотворная Вещь', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (116, 'E24', 'el', 'Ανθρωπογενές Υλικό Πράγμα', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (117, 'E24', 'pt', 'Coisa Material Fabricada', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (118, 'E24', 'zh', '人造实体物', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (119, 'E82', 'de', 'Akteurbenennung', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (120, 'E82', 'en', 'Actor Appellation', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (121, 'E82', 'fr', 'Appellation d''agent', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (122, 'E82', 'ru', 'Обозначение Агента', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (123, 'E82', 'el', 'Ονομασία Δράστη', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (124, 'E82', 'pt', 'Designação de Agente', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (125, 'E82', 'zh', '角色称号', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (126, 'E47', 'de', 'Raumkoordinaten', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (127, 'E47', 'en', 'Spatial Coordinates', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (128, 'E47', 'fr', 'Coordonnées spatiales', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (129, 'E47', 'ru', 'Пространственные Координаты', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (130, 'E47', 'el', 'Χωρικές Συντεταγμένες', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (131, 'E47', 'pt', 'Coordenadas Espaciais', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (132, 'E47', 'zh', '空间坐标', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (133, 'E80', 'de', 'Teilentfernung', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (134, 'E80', 'en', 'Part Removal', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (135, 'E80', 'fr', 'Soustraction d''élément', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (136, 'E80', 'ru', 'Удаление Части', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (137, 'E80', 'el', 'Αφαίρεση Μερών', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (138, 'E80', 'pt', 'Remoção de Parte', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (139, 'E80', 'zh', '部件删除', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (140, 'E22', 'de', 'Künstlicher Gegenstand', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (141, 'E22', 'en', 'Man-Made Object', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (142, 'E22', 'fr', 'Objet fabriqué', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (143, 'E22', 'ru', 'Рукотворный Объект', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (144, 'E22', 'el', 'Ανθρωπογενές Αντικείμενο', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (145, 'E22', 'pt', 'Objeto Fabricado', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (146, 'E22', 'zh', '人造物件', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (147, 'E3', 'de', 'Zustandsphase', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (148, 'E3', 'en', 'Condition State', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (149, 'E3', 'fr', 'État matériel', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (150, 'E3', 'ru', 'Состояние', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (151, 'E3', 'el', 'Κατάσταση', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (152, 'E3', 'pt', 'Estado Material', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (153, 'E3', 'zh', '状态', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (154, 'E19', 'de', 'Materieller Gegenstand', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (155, 'E19', 'en', 'Physical Object', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (156, 'E19', 'fr', 'Objet matériel', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (157, 'E19', 'ru', 'Физический Объект', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (158, 'E19', 'el', 'Υλικό Αντικείμενο', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (159, 'E19', 'pt', 'Objeto Material', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (160, 'E19', 'zh', '实体物件', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (161, 'E27', 'de', 'Gelände', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (162, 'E27', 'en', 'Site', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (163, 'E27', 'fr', 'Site', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (164, 'E27', 'ru', 'Участок', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (165, 'E27', 'el', 'Φυσικός Χώρος', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (166, 'E27', 'pt', 'Lugar', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (167, 'E27', 'zh', '场地', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (168, 'E93', 'en', 'Presence', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (169, 'E77', 'de', 'Seiendes', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (170, 'E77', 'en', 'Persistent Item', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (171, 'E77', 'fr', 'Entité persistante', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (172, 'E77', 'ru', 'Постоянная Сущность', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (173, 'E77', 'el', 'Ον', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (174, 'E77', 'pt', 'Entidade Persistente', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (175, 'E77', 'zh', '持续性项目', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (176, 'E58', 'de', 'Maßeinheit', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (177, 'E58', 'en', 'Measurement Unit', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (178, 'E58', 'fr', 'Unité de mesure', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (179, 'E58', 'ru', 'Единица Измерения', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (180, 'E58', 'el', 'Μονάδα Μέτρησης', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (181, 'E58', 'pt', 'Unidade de Medida', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (182, 'E58', 'zh', '测量单位', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (183, 'E13', 'de', 'Merkmalszuweisung', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (184, 'E13', 'en', 'Attribute Assignment', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (185, 'E13', 'fr', 'Affectation d''attribut', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (186, 'E13', 'ru', 'Присвоение Атрибута', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (187, 'E13', 'el', 'Απόδοση Ιδιοτήτων', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (188, 'E13', 'pt', 'Atribuição de Característica', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (189, 'E13', 'zh', '屬性指定', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (190, 'E26', 'de', 'Materielles Merkmal', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (191, 'E26', 'en', 'Physical Feature', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (192, 'E26', 'fr', 'Caractéristique matérielle', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (193, 'E26', 'ru', 'Физический Признак', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (194, 'E26', 'el', 'Υλικό Μόρφωμα', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (195, 'E26', 'pt', 'Característica Material', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (196, 'E26', 'zh', '实体外貌表征', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (197, 'E31', 'de', 'Dokument', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (198, 'E31', 'en', 'Document', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (199, 'E31', 'fr', 'Document', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (200, 'E31', 'ru', 'Документ', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (201, 'E31', 'el', 'Τεκμήριο', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (202, 'E31', 'pt', 'Documento', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (203, 'E31', 'zh', '文献', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (204, 'E45', 'de', 'Adresse', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (205, 'E45', 'en', 'Address', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (206, 'E45', 'fr', 'Adresse', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (207, 'E45', 'ru', 'Адрес', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (208, 'E45', 'el', 'Διεύθυνση', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (209, 'E45', 'pt', 'Endereço', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (210, 'E45', 'zh', '地址', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (211, 'E21', 'de', 'Person', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (212, 'E21', 'en', 'Person', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (213, 'E21', 'fr', 'Personne', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (214, 'E21', 'ru', 'Личность', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (215, 'E21', 'el', 'Πρόσωπο', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (216, 'E21', 'pt', 'Pessoa', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (217, 'E21', 'zh', '人物', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (218, 'E71', 'de', 'Künstliches', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (219, 'E71', 'en', 'Man-Made Thing', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (220, 'E71', 'fr', 'Chose fabriquée', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (221, 'E71', 'ru', 'Рукотворная Вещь', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (222, 'E71', 'el', 'Ανθρώπινο Δημιούργημα', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (223, 'E71', 'pt', 'Coisa Fabricada', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (224, 'E71', 'zh', '人造物', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (225, 'E12', 'de', 'Herstellung', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (226, 'E12', 'en', 'Production', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (227, 'E12', 'fr', 'Production', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (228, 'E12', 'ru', 'Событие Производства', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (229, 'E12', 'el', 'Παραγωγή', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (230, 'E12', 'pt', 'Produção', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (231, 'E12', 'zh', '生产', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (232, 'E86', 'de', 'Austritt', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (233, 'E86', 'en', 'Leaving', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (234, 'E86', 'zh', '脱离', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (235, 'E5', 'de', 'Ereignis', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (236, 'E5', 'en', 'Event', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (237, 'E5', 'fr', 'Événement', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (238, 'E5', 'ru', 'Событие', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (239, 'E5', 'el', 'Συμβάν', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (240, 'E5', 'pt', 'Evento', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (241, 'E5', 'zh', '事件', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (242, 'E33', 'de', 'Sprachlicher Gegenstand', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (243, 'E33', 'en', 'Linguistic Object', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (244, 'E33', 'fr', 'Objet linguistique', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (245, 'E33', 'ru', 'Линвистический Объект', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (246, 'E33', 'el', 'Γλωσσικό Αντικείμενο', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (247, 'E33', 'pt', 'Objeto Lingüístico', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (248, 'E33', 'zh', '语言物件', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (249, 'E34', 'de', 'Inschrift', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (250, 'E34', 'en', 'Inscription', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (251, 'E34', 'fr', 'Inscription', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (252, 'E34', 'ru', 'Надпись', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (253, 'E34', 'el', 'Επιγραφή', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (254, 'E34', 'pt', 'Inscrição', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (255, 'E34', 'zh', '题字', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (256, 'E70', 'de', 'Sache', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (257, 'E70', 'en', 'Thing', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (258, 'E70', 'fr', 'Chose', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (259, 'E70', 'el', 'Πράγμα', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (260, 'E70', 'pt', 'Coisa', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (261, 'E70', 'zh', '万物', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (262, 'E8', 'de', 'Erwerb', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (263, 'E8', 'en', 'Acquisition', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (264, 'E8', 'fr', 'Acquisition', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (265, 'E8', 'ru', 'Событие Приобретения', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (266, 'E8', 'el', 'Απόκτηση', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (267, 'E8', 'pt', 'Aquisição', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (268, 'E8', 'zh', '征集取得', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (269, 'E40', 'de', 'Juristische Person', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (270, 'E40', 'en', 'Legal Body', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (271, 'E40', 'fr', 'Collectivité', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (272, 'E40', 'ru', 'Юридическое Лицо', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (273, 'E40', 'el', 'Νομικό Πρόσωπο', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (274, 'E40', 'pt', 'Pessoa Jurídica', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (275, 'E40', 'zh', '法律组织', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (276, 'E25', 'de', 'Hergestelltes Merkmal', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (277, 'E25', 'en', 'Man-Made Feature', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (278, 'E25', 'fr', 'Caractéristique fabriquée', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (279, 'E25', 'ru', 'Искусственный Признак', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (280, 'E25', 'el', 'Ανθρωπογενές Μόρφωμα', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (281, 'E25', 'pt', 'Característica Fabricada', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (282, 'E25', 'zh', '人造外貌表征', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (283, 'E64', 'de', 'Daseinsende', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (284, 'E64', 'en', 'End of Existence', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (285, 'E64', 'fr', 'Fin d''existence', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (286, 'E64', 'ru', 'Конец Существования', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (287, 'E64', 'el', 'Τέλος Ύπαρξης', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (288, 'E64', 'pt', 'Fim da Existência', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (289, 'E64', 'zh', '存在结束', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (290, 'E85', 'de', 'Beitritt', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (291, 'E85', 'en', 'Joining', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (292, 'E85', 'zh', '加入', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (293, 'E50', 'de', 'Datum', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (294, 'E50', 'en', 'Date', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (295, 'E50', 'fr', 'Date', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (296, 'E50', 'ru', 'Дата', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (297, 'E50', 'el', 'Ημερομηνία', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (298, 'E50', 'pt', 'Data', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (299, 'E50', 'zh', '日期', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (300, 'E72', 'de', 'Rechtsobjekt', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (301, 'E72', 'en', 'Legal Object', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (302, 'E72', 'fr', 'Objet juridique', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (303, 'E72', 'ru', 'Объект Права', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (304, 'E72', 'el', 'Νομικό Αντικείμενο', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (305, 'E72', 'pt', 'Objeto Jurídico', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (306, 'E72', 'zh', '法律物件', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (307, 'E44', 'de', 'Ortsbenennung', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (308, 'E44', 'en', 'Place Appellation', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (309, 'E44', 'fr', 'Appellation de lieu', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (310, 'E44', 'ru', 'Обозначение Места', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (311, 'E44', 'el', 'Ονομασία Τόπου', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (312, 'E44', 'pt', 'Designação de Local', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (313, 'E44', 'zh', '地点称号', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (314, 'E17', 'de', 'Typuszuweisung', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (315, 'E17', 'en', 'Type Assignment', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (316, 'E17', 'fr', 'Attribution de type', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (317, 'E17', 'ru', 'Присвоение Типа', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (318, 'E17', 'el', 'Απόδοση Τύπου', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (319, 'E17', 'pt', 'Atribuição de Tipo', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (320, 'E17', 'zh', '类型指定', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (321, 'E66', 'de', 'Gruppenbildung', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (322, 'E66', 'en', 'Formation', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (323, 'E66', 'fr', 'Formation', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (324, 'E66', 'ru', 'Событие Формирования', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (325, 'E66', 'el', 'Συγκρότηση Ομάδας', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (326, 'E66', 'pt', 'Formação', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (327, 'E66', 'zh', '组成', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (328, 'E51', 'de', 'Kontaktpunkt', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (329, 'E51', 'en', 'Contact Point', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (330, 'E51', 'fr', 'Coordonnées individuelles', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (331, 'E51', 'ru', 'Контакт', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (332, 'E51', 'el', 'Στοιχείο Επικοινωνίας', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (333, 'E51', 'pt', 'Ponto de Contato', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (334, 'E51', 'zh', '联系方式', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (335, 'E78', 'de', 'Sammlung', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (336, 'E78', 'en', 'Collection', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (337, 'E78', 'fr', 'Collection', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (338, 'E78', 'ru', 'Коллекция', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (339, 'E78', 'el', 'Συλλογή', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (340, 'E78', 'pt', 'Coleção', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (341, 'E78', 'zh', '收藏', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (342, 'E46', 'de', 'Abschnittsdefinition', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (343, 'E46', 'en', 'Section Definition', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (344, 'E46', 'fr', 'Désignation de section', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (345, 'E46', 'ru', 'Определение Района', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (346, 'E46', 'el', 'Ονομασία Τμήματος', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (347, 'E46', 'pt', 'Designação de Seção', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (348, 'E46', 'zh', '区域定义', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (349, 'E49', 'de', 'Zeitbenennung', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (350, 'E49', 'en', 'Time Appellation', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (351, 'E49', 'fr', 'Appellation temporelle', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (352, 'E49', 'ru', 'Обозначение Времени', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (353, 'E49', 'el', 'Ονομασία Χρόνου', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (354, 'E49', 'pt', 'Designação de Tempo', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (355, 'E49', 'zh', '时间称号', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (356, 'E68', 'de', 'Gruppenauflösung', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (357, 'E68', 'en', 'Dissolution', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (358, 'E68', 'fr', 'Dissolution', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (359, 'E68', 'ru', 'Роспуск', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (360, 'E68', 'el', 'Διάλυση Ομάδας', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (361, 'E68', 'pt', 'Dissolução', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (362, 'E68', 'zh', '解散', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (363, 'E37', 'de', 'Marke', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (364, 'E37', 'en', 'Mark', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (365, 'E37', 'fr', 'Marque', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (366, 'E37', 'ru', 'Пометка', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (367, 'E37', 'el', 'Σήμανση', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (368, 'E37', 'pt', 'Marca', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (369, 'E37', 'zh', '标志', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (370, 'E9', 'de', 'Objektbewegung', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (371, 'E9', 'en', 'Move', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (372, 'E9', 'fr', 'Déplacement', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (373, 'E9', 'ru', 'Перемещение', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (374, 'E9', 'el', 'Μετακίνηση', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (375, 'E9', 'pt', 'Locomoção', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (376, 'E9', 'zh', '移动', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (377, 'E65', 'de', 'Begriffliche Schöpfung', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (378, 'E65', 'en', 'Creation', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (379, 'E65', 'fr', 'Création', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (380, 'E65', 'ru', 'Событие Творения', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (381, 'E65', 'el', 'Δημιουργία', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (382, 'E65', 'pt', 'Criação', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (383, 'E65', 'zh', '创造', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (384, 'E57', 'de', 'Material', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (385, 'E57', 'en', 'Material', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (386, 'E57', 'fr', 'Matériau', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (387, 'E57', 'ru', 'Материал', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (388, 'E57', 'el', 'Υλικό', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (389, 'E57', 'pt', 'Material', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (390, 'E57', 'zh', '材料', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (391, 'E32', 'de', 'Referenzdokument', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (392, 'E32', 'en', 'Authority Document', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (393, 'E32', 'fr', 'Document de référence', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (394, 'E32', 'ru', 'Официальный Документ', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (395, 'E32', 'el', 'Πηγή Καθιερωμένων Όρων', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (396, 'E32', 'pt', 'Documento de Referência', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (397, 'E32', 'zh', '权威文献', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (398, 'E63', 'de', 'Daseinsbeginn', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (399, 'E63', 'en', 'Beginning of Existence', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (400, 'E63', 'fr', 'Début d''existence', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (401, 'E63', 'ru', 'Начало Существования', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (402, 'E63', 'el', 'Αρχή Ύπαρξης', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (403, 'E63', 'pt', 'Início da Existência', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (404, 'E63', 'zh', '存在开始', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (405, 'E16', 'de', 'Messung', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (406, 'E16', 'en', 'Measurement', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (407, 'E16', 'fr', 'Mesurage', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (408, 'E16', 'ru', 'Событие Измерения', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (409, 'E16', 'el', 'Μέτρηση', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (410, 'E16', 'pt', 'Medição', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (411, 'E16', 'zh', '测量', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (412, 'E54', 'de', 'Maß', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (413, 'E54', 'en', 'Dimension', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (414, 'E54', 'fr', 'Dimensions', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (415, 'E54', 'ru', 'Величина', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (416, 'E54', 'el', 'Μέγεθος', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (417, 'E54', 'pt', 'Dimensão', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (418, 'E54', 'zh', '规模数量', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (419, 'E84', 'de', 'Informationsträger', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (420, 'E84', 'en', 'Information Carrier', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (421, 'E84', 'fr', 'Support d''information', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (422, 'E84', 'ru', 'Носитель Информации', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (423, 'E84', 'el', 'Φορέας Πληροφορίας', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (424, 'E84', 'pt', 'Suporte de Informação', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (425, 'E84', 'zh', '信息载体', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (426, 'E48', 'de', 'Orts- oder Flurname', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (427, 'E48', 'en', 'Place Name', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (428, 'E48', 'fr', 'Toponyme', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (429, 'E48', 'ru', 'Название Места', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (430, 'E48', 'el', 'Τοπωνύμιο', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (431, 'E48', 'pt', 'Nome de Local', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (432, 'E48', 'zh', '地名', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (433, 'E52', 'de', 'Zeitspanne', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (434, 'E52', 'en', 'Time-Span', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (435, 'E52', 'fr', 'Durée', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (436, 'E52', 'ru', 'Интервал Времени', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (437, 'E52', 'el', 'Χρονικό Διάστημα', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (438, 'E52', 'pt', 'Período de Tempo', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (439, 'E52', 'zh', '时段', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (440, 'E39', 'de', 'Akteur', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (441, 'E39', 'en', 'Actor', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (442, 'E39', 'fr', 'Agent', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (443, 'E39', 'ru', 'Агент', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (444, 'E39', 'el', 'Δράστης', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (445, 'E39', 'pt', 'Agente', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (446, 'E39', 'zh', '角色', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (447, 'E75', 'de', 'Begriff- oder Konzeptbenennung ', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (448, 'E75', 'en', 'Conceptual Object Appellation', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (449, 'E75', 'fr', 'Appellation d''objet conceptuel', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (450, 'E75', 'ru', 'Обозначение Концептуального Объекта', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (451, 'E75', 'el', 'Ονομασία Νοητικού Αντικειμένου', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (452, 'E75', 'pt', 'Designação de Objeto Conceitual', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (453, 'E75', 'zh', '概念物件称号', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (454, 'E53', 'de', 'Ort', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (455, 'E53', 'en', 'Place', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (456, 'E53', 'fr', 'Lieu', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (457, 'E53', 'ru', 'Место', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (458, 'E53', 'el', 'Τόπος', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (459, 'E53', 'pt', 'Local', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (460, 'E53', 'zh', '地点', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (461, 'E73', 'de', 'Informationsgegenstand', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (462, 'E73', 'en', 'Information Object', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (463, 'E73', 'fr', 'Objet d''information', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (464, 'E73', 'ru', 'Информационный Объект', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (465, 'E73', 'el', 'Πληροφοριακό Αντικείμενο', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (466, 'E73', 'pt', 'Objeto de Informação', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (467, 'E73', 'zh', '信息物件', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (468, 'E7', 'de', 'Handlung', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (469, 'E7', 'en', 'Activity', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (470, 'E7', 'fr', 'Activité', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (471, 'E7', 'ru', 'Деятельность', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (472, 'E7', 'el', 'Δράση', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (473, 'E7', 'pt', 'Atividade', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (474, 'E7', 'zh', '活动', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (475, 'E55', 'de', 'Typus', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (476, 'E55', 'en', 'Type', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (477, 'E55', 'fr', 'Type', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (478, 'E55', 'ru', 'Тип', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (479, 'E55', 'el', 'Τύπος', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (480, 'E55', 'pt', 'Tipo', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (481, 'E55', 'zh', '类型', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (482, 'E10', 'de', 'Übertragung des Gewahrsams', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (483, 'E10', 'en', 'Transfer of Custody', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (484, 'E10', 'fr', 'Changement de détenteur', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (485, 'E10', 'ru', 'Передача Опеки', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (486, 'E10', 'el', 'Μεταβίβαση  Κατοχής', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (487, 'E10', 'pt', 'Transferência de Custódia', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (488, 'E10', 'zh', '保管作业转移', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (489, 'E29', 'de', 'Entwurf oder Verfahren', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (490, 'E29', 'en', 'Design or Procedure', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (491, 'E29', 'fr', 'Conception ou procédure', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (492, 'E29', 'ru', 'Проект или Процедура', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (493, 'E29', 'el', 'Σχέδιο', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (494, 'E29', 'pt', 'Projeto ou Procedimento', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (495, 'E29', 'zh', '设计或程序', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (496, 'E11', 'de', 'Bearbeitung', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (497, 'E11', 'en', 'Modification', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (498, 'E11', 'fr', 'Modification', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (499, 'E11', 'ru', 'Событие Изменения', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (500, 'E11', 'el', 'Τροποποίηση', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (501, 'E11', 'pt', 'Modificação', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (502, 'E11', 'zh', '修改', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (503, 'E35', 'de', 'Titel', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (504, 'E35', 'en', 'Title', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (505, 'E35', 'fr', 'Titre', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (506, 'E35', 'ru', 'Заголовок', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (507, 'E35', 'el', ' Τίτλος', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (508, 'E35', 'pt', 'Título', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (509, 'E35', 'zh', '题目', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (510, 'E89', 'de', 'Aussagenobjekt', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (511, 'E89', 'en', 'Propositional Object', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (512, 'E89', 'zh', '陈述性物件', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (513, 'E4', 'de', 'Phase', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (514, 'E4', 'en', 'Period', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (515, 'E4', 'fr', 'Période', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (516, 'E4', 'ru', 'Период', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (517, 'E4', 'el', 'Περίοδος', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (518, 'E4', 'pt', 'Período', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (519, 'E4', 'zh', '期间', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (520, 'E14', 'de', 'Zustandsfeststellung', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (521, 'E14', 'en', 'Condition Assessment', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (522, 'E14', 'fr', 'Expertise de l''état matériel', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (523, 'E14', 'ru', 'Оценка Состояния', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (524, 'E14', 'el', 'Εκτίμηση Κατάστασης', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (525, 'E14', 'pt', 'Avaliação do Estado Material', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (526, 'E14', 'zh', '状态评估', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (527, 'E1', 'de', 'CRM Entität', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (528, 'E1', 'en', 'CRM Entity', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (529, 'E1', 'fr', 'Entité CRM', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (530, 'E1', 'ru', 'CRM Сущность', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (531, 'E1', 'el', 'Οντότητα CIDOC CRM', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (532, 'E1', 'pt', 'Entidade CRM', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (533, 'E1', 'zh', 'CRM实体', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (534, 'E92', 'en', 'Spacetime Volume', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (535, 'E2', 'de', 'Geschehendes', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (536, 'E2', 'en', 'Temporal Entity', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (537, 'E2', 'fr', 'Entité temporelle', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (538, 'E2', 'ru', 'Временная Сущность', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (539, 'E2', 'el', 'Έγχρονη  Οντότητα', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (540, 'E2', 'pt', 'Entidade Temporal', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (541, 'E2', 'zh', '时间实体', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (542, 'E18', 'de', 'Materielles', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (543, 'E18', 'en', 'Physical Thing', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (544, 'E18', 'fr', 'Chose matérielle', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (545, 'E18', 'ru', 'Физическая Вещь', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (546, 'E18', 'el', 'Υλικό Πράγμα', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (547, 'E18', 'pt', 'Coisa Material', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (548, 'E18', 'zh', '实体物', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (549, 'E81', 'de', 'Umwandlung', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (550, 'E81', 'en', 'Transformation', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (551, 'E81', 'fr', 'Transformation', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (552, 'E81', 'ru', 'Трансформация', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (553, 'E81', 'el', 'Μετατροπή', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (554, 'E81', 'pt', 'Transformação', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_i18n VALUES (555, 'E81', 'zh', '转变', '2019-12-12 17:08:42.016696', NULL);


--
-- Data for Name: class_inheritance; Type: TABLE DATA; Schema: model; Owner: openatlas
--

INSERT INTO model.class_inheritance VALUES (1, 'E55', 'E56', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_inheritance VALUES (2, 'E64', 'E69', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_inheritance VALUES (3, 'E41', 'E42', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_inheritance VALUES (4, 'E72', 'E90', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_inheritance VALUES (5, 'E28', 'E90', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_inheritance VALUES (6, 'E71', 'E28', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_inheritance VALUES (7, 'E65', 'E83', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_inheritance VALUES (8, 'E64', 'E6', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_inheritance VALUES (9, 'E36', 'E38', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_inheritance VALUES (10, 'E63', 'E67', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_inheritance VALUES (11, 'E11', 'E79', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_inheritance VALUES (12, 'E89', 'E30', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_inheritance VALUES (13, 'E73', 'E36', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_inheritance VALUES (14, 'E90', 'E41', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_inheritance VALUES (15, 'E7', 'E87', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_inheritance VALUES (16, 'E13', 'E15', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_inheritance VALUES (17, 'E39', 'E74', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_inheritance VALUES (18, 'E19', 'E20', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_inheritance VALUES (19, 'E71', 'E24', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_inheritance VALUES (20, 'E18', 'E24', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_inheritance VALUES (21, 'E41', 'E82', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_inheritance VALUES (22, 'E44', 'E47', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_inheritance VALUES (23, 'E11', 'E80', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_inheritance VALUES (24, 'E24', 'E22', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_inheritance VALUES (25, 'E19', 'E22', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_inheritance VALUES (26, 'E2', 'E3', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_inheritance VALUES (27, 'E18', 'E19', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_inheritance VALUES (28, 'E26', 'E27', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_inheritance VALUES (29, 'E92', 'E93', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_inheritance VALUES (30, 'E1', 'E77', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_inheritance VALUES (31, 'E55', 'E58', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_inheritance VALUES (32, 'E7', 'E13', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_inheritance VALUES (33, 'E18', 'E26', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_inheritance VALUES (34, 'E73', 'E31', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_inheritance VALUES (35, 'E51', 'E45', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_inheritance VALUES (36, 'E44', 'E45', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_inheritance VALUES (37, 'E39', 'E21', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_inheritance VALUES (38, 'E20', 'E21', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_inheritance VALUES (39, 'E70', 'E71', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_inheritance VALUES (40, 'E11', 'E12', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_inheritance VALUES (41, 'E63', 'E12', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_inheritance VALUES (42, 'E7', 'E86', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_inheritance VALUES (43, 'E4', 'E5', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_inheritance VALUES (44, 'E73', 'E33', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_inheritance VALUES (45, 'E37', 'E34', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_inheritance VALUES (46, 'E33', 'E34', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_inheritance VALUES (47, 'E77', 'E70', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_inheritance VALUES (48, 'E7', 'E8', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_inheritance VALUES (49, 'E74', 'E40', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_inheritance VALUES (50, 'E24', 'E25', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_inheritance VALUES (51, 'E26', 'E25', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_inheritance VALUES (52, 'E5', 'E64', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_inheritance VALUES (53, 'E7', 'E85', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_inheritance VALUES (54, 'E49', 'E50', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_inheritance VALUES (55, 'E70', 'E72', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_inheritance VALUES (56, 'E41', 'E44', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_inheritance VALUES (57, 'E13', 'E17', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_inheritance VALUES (58, 'E63', 'E66', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_inheritance VALUES (59, 'E7', 'E66', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_inheritance VALUES (60, 'E41', 'E51', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_inheritance VALUES (61, 'E24', 'E78', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_inheritance VALUES (62, 'E44', 'E46', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_inheritance VALUES (63, 'E41', 'E49', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_inheritance VALUES (64, 'E64', 'E68', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_inheritance VALUES (65, 'E36', 'E37', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_inheritance VALUES (66, 'E7', 'E9', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_inheritance VALUES (67, 'E7', 'E65', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_inheritance VALUES (68, 'E63', 'E65', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_inheritance VALUES (69, 'E55', 'E57', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_inheritance VALUES (70, 'E31', 'E32', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_inheritance VALUES (71, 'E5', 'E63', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_inheritance VALUES (72, 'E13', 'E16', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_inheritance VALUES (73, 'E1', 'E54', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_inheritance VALUES (74, 'E22', 'E84', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_inheritance VALUES (75, 'E44', 'E48', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_inheritance VALUES (76, 'E1', 'E52', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_inheritance VALUES (77, 'E77', 'E39', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_inheritance VALUES (78, 'E41', 'E75', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_inheritance VALUES (79, 'E1', 'E53', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_inheritance VALUES (80, 'E90', 'E73', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_inheritance VALUES (81, 'E89', 'E73', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_inheritance VALUES (82, 'E5', 'E7', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_inheritance VALUES (83, 'E28', 'E55', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_inheritance VALUES (84, 'E7', 'E10', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_inheritance VALUES (85, 'E73', 'E29', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_inheritance VALUES (86, 'E7', 'E11', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_inheritance VALUES (87, 'E33', 'E35', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_inheritance VALUES (88, 'E41', 'E35', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_inheritance VALUES (89, 'E28', 'E89', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_inheritance VALUES (90, 'E92', 'E4', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_inheritance VALUES (91, 'E2', 'E4', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_inheritance VALUES (92, 'E13', 'E14', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_inheritance VALUES (93, 'E1', 'E92', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_inheritance VALUES (94, 'E1', 'E2', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_inheritance VALUES (95, 'E72', 'E18', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_inheritance VALUES (96, 'E92', 'E18', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_inheritance VALUES (97, 'E64', 'E81', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.class_inheritance VALUES (98, 'E63', 'E81', '2019-12-12 17:08:42.016696', NULL);


--
-- Data for Name: property; Type: TABLE DATA; Schema: model; Owner: openatlas
--

INSERT INTO model.property VALUES (1, 'P95', 'E74', 'E66', 'has formed', 'was formed by', '2019-12-12 17:08:42.016696', NULL, 'This property links the founding or E66 Formation for an E74 Group with the Group itself.');
INSERT INTO model.property VALUES (2, 'P21', 'E55', 'E7', 'had general purpose', 'was purpose of', '2019-12-12 17:08:42.016696', NULL, 'This property describes an intentional relationship between an E7 Activity and some general goal or purpose. 
This may involve activities intended as preparation for some type of activity or event. P21had general purpose (was purpose of) differs from P20 had specific purpose (was purpose of) in that no occurrence of an event is implied as the purpose. 
');
INSERT INTO model.property VALUES (3, 'P26', 'E53', 'E9', 'moved to', 'was destination of', '2019-12-12 17:08:42.016696', NULL, 'This property identifies a destination of a E9 Move. 
A move will be linked to a destination, such as the move of an artefact from storage to display. A move may be linked to many terminal instances of E53 Place by multiple instances of this property. In this case the move describes a distribution of a set of objects. The area of the move includes the origin(s), route and destination(s).
Therefore the described destination is an instance of E53 Place which P89 falls within (contains) the instance of E53 Place the move P7 took place at.
');
INSERT INTO model.property VALUES (4, 'P165', 'E90', 'E73', 'incorporates', 'is incorporated in', '2019-12-12 17:08:42.016696', NULL, 'This property associates an instance of E73 Information Object with an instance of E90 Symbolic Object (or any of its subclasses) that was included in it.
This property makes it possible to recognise the autonomous status of the incorporated signs, which were created in a distinct context, and can be incorporated in many distinct self-contained expressions, and to highlight the difference between structural and accidental whole-part relationships between conceptual entities.
It accounts for many cultural facts that are quite frequent and significant: the inclusion of a poem in an anthology, the re-use of an operatic aria in a new opera, the use of a reproduction of a painting for a book cover or a CD booklet, the integration of textual quotations, the presence of lyrics in a song that sets those lyrics to music, the presence of the text of a play in a movie based on that play, etc.
In particular, this property allows for modelling relationships of different levels of symbolic specificity, such as the natural language words making up a particular text, the characters making up the words and punctuation, the choice of fonts and page layout for the characters.
A digital photograph of a manuscript page incorporates the text of the manuscript page.
	');
INSERT INTO model.property VALUES (5, 'P149', 'E75', 'E28', 'is identified by', 'identifies', '2019-12-12 17:08:42.016696', NULL, 'This property identifies an instance of E28 Conceptual Object using an instance of E75 Conceptual Object Appellation.');
INSERT INTO model.property VALUES (6, 'P33', 'E29', 'E7', 'used specific technique', 'was used by', '2019-12-12 17:08:42.016696', NULL, 'This property identifies a specific instance of E29 Design or Procedure in order to carry out an instance of E7 Activity or parts of it. 
The property differs from P32 used general technique (was technique of) in that P33 refers to an instance of E29 Design or Procedure, which is a concrete information object in its own right rather than simply being a term or a method known by tradition. 
Typical examples would include intervention plans for conservation or the construction plans of a building.
');
INSERT INTO model.property VALUES (7, 'P39', 'E1', 'E16', 'measured', 'was measured by', '2019-12-12 17:08:42.016696', NULL, 'This property associates an instance of E16 Measurement with the instance of E1 CRM Entity to which it applied. An instance of E1 CRM Entity may be measured more than once. Material and immaterial things and processes may be measured, e.g. the number of words in a text, or the duration of an event.
');
INSERT INTO model.property VALUES (8, 'P130', 'E70', 'E70', 'shows features of', 'features are also found on', '2019-12-12 17:08:42.016696', NULL, 'This property generalises the notions of "copy of" and "similar to" into a directed relationship, where
the domain expresses the derivative, if such a direction can be established.
Otherwise, the relationship is symmetric. If the reason for similarity is a sort of derivation process, i.e.,
that the creator has used or had in mind the form of a particular thing during the creation or production,
this process should be explicitly modelled. Moreover it expresses similarity in cases that can be stated
between two objects only, without historical knowledge about its reasons.
	');
INSERT INTO model.property VALUES (9, 'P9', 'E4', 'E4', 'consists of', 'forms part of', '2019-12-12 17:08:42.016696', NULL, 'This property associates an instance of E4 Period with another instance of E4 Period that is defined by a subset of the phenomena that define the former. Therefore the spacetime volume of the latter must fall within the spacetime volume of the former.
');
INSERT INTO model.property VALUES (10, 'P102', 'E35', 'E71', 'has title', 'is title of', '2019-12-12 17:08:42.016696', NULL, 'This property describes the E35 Title applied to an instance of E71 Man-Made Thing. The E55 Type of Title is assigned in a sub property.
The P102.1 has type property of the P102 has title (is title of) property enables the relationship between the Title and the thing to be further clarified, for example, if the Title was a given Title, a supplied Title etc.
It allows any man-made material or immaterial thing to be given a Title. It is possible to imagine a Title being created without a specific object in mind.
');
INSERT INTO model.property VALUES (11, 'P48', 'E42', 'E1', 'has preferred identifier', 'is preferred identifier of', '2019-12-12 17:08:42.016696', NULL, 'This property records the preferred E42 Identifier that was used to identify an instance of E1 CRM Entity at the time this property was recorded.
More than one preferred identifier may have been assigned to an item over time.
Use of this property requires an external mechanism for assigning temporal validity to the respective CRM instance.
P48 has preferred identifier (is preferred identifier of), is a shortcut for the path from E1 CRM Entity through P140 assigned attribute to (was attributed by), E15 Identifier Assignment, P37 assigned (was assigned by) to E42 Identifier. The fact that an identifier is a preferred one for an organisation can be better expressed in a context independent form by assigning a suitable E55 Type to the respective instance of E15 Identifier Assignment using the P2 has type property.
');
INSERT INTO model.property VALUES (12, 'P5', 'E3', 'E3', 'consists of', 'forms part of', '2019-12-12 17:08:42.016696', NULL, 'This property describes the decomposition of an E3 Condition State into discrete, subsidiary states. 
It is assumed that the sub-states into which the condition state is analysed form a logical whole - although the entire story may not be completely known – and that the sub-states are in fact constitutive of the general condition state. For example, a general condition state of “in ruins” may be decomposed into the individual stages of decay');
INSERT INTO model.property VALUES (13, 'P30', 'E18', 'E10', 'transferred custody of', 'custody transferred through', '2019-12-12 17:08:42.016696', NULL, 'This property identifies an item or items of E18 Physical Thing concerned in an E10 Transfer of Custody activity. 
The property will typically describe the object that is handed over by an E39 Actor to another Actor’s custody. On occasion, physical custody may be transferred involuntarily or illegally – through accident, unsolicited donation, or theft.
');
INSERT INTO model.property VALUES (14, 'P114', 'E2', 'E2', 'is equal in time to', NULL, '2019-12-12 17:08:42.016696', NULL, 'This symmetric property allows the instances of E2 Temporal Entity with the same E52 Time-Span to be equated. 
This property is only necessary if the time span is unknown (otherwise the equivalence can be calculated).
This property is the same as the "equal" relationship of Allen’s temporal logic (Allen, 1983, pp. 832-843).
');
INSERT INTO model.property VALUES (15, 'P35', 'E3', 'E14', 'has identified', 'was identified by', '2019-12-12 17:08:42.016696', NULL, 'This property identifies the E3 Condition State that was observed in an E14 Condition Assessment activity.');
INSERT INTO model.property VALUES (16, 'P96', 'E21', 'E67', 'by mother', 'gave birth', '2019-12-12 17:08:42.016696', NULL, 'This property links an E67 Birth event to an E21 Person as a participant in the role of birth-giving mother.

Note that biological fathers are not necessarily participants in the Birth (see P97 from father (was father for)). The Person being born is linked to the Birth with the property P98 brought into life (was born). This is not intended for use with general natural history material, only people. There is no explicit method for modelling conception and gestation except by using extensions. This is a sub-property of P11 had participant (participated in).
');
INSERT INTO model.property VALUES (17, 'P111', 'E18', 'E79', 'added', 'was added by', '2019-12-12 17:08:42.016696', NULL, 'This property identifies the E18 Physical Thing that is added during an E79 Part Addition activity
');
INSERT INTO model.property VALUES (18, 'P121', 'E53', 'E53', 'overlaps with', NULL, '2019-12-12 17:08:42.016696', NULL, 'This symmetric property allows the instances of E53 Place with overlapping geometric extents to be associated with each other. 
It does not specify anything about the shared area. This property is purely spatial, in contrast to Allen operators, which are purely temporal.
');
INSERT INTO model.property VALUES (19, 'P134', 'E7', 'E7', 'continued', 'was continued by', '2019-12-12 17:08:42.016696', NULL, 'This property associates two instances of E7 Activity, where the domain is considered as an intentional continuation of the range. A continuation of an activity may happen when the continued activity is still ongoing or after the continued activity has completely ended. The continuing activity may have started already before it decided to continue the other one. Continuation implies a coherence of intentions and outcomes of the involved activities.
');
INSERT INTO model.property VALUES (20, 'P4', 'E52', 'E2', 'has time-span', 'is time-span of', '2019-12-12 17:08:42.016696', NULL, 'This property describes the temporal confinement of an instance of an E2 Temporal Entity.
The related E52 Time-Span is understood as the real Time-Span during which the phenomena were active, which make up the temporal entity instance. It does not convey any other meaning than a positioning on the “time-line” of chronology. The Time-Span in turn is approximated by a set of dates (E61 Time Primitive). A temporal entity can have in reality only one Time-Span, but there may exist alternative opinions about it, which we would express by assigning multiple Time-Spans. Related temporal entities may share a Time-Span. Time-Spans may have completely unknown dates but other descriptions by which we can infer knowledge.
');
INSERT INTO model.property VALUES (21, 'P25', 'E19', 'E9', 'moved', 'moved by', '2019-12-12 17:08:42.016696', NULL, 'This property identifies an instance of E19 Physical Object that was moved by a move event. A move must concern at least one object.

The property implies the object''s passive participation. For example, Monet''s painting "Impression sunrise" was moved for the first Impressionist exhibition in 1874. 
');
INSERT INTO model.property VALUES (22, 'P104', 'E30', 'E72', 'is subject to', 'applies to', '2019-12-12 17:08:42.016696', NULL, 'This property links a particular E72 Legal Object to the instances of E30 Right to which it is subject.
The Right is held by an E39 Actor as described by P75 possesses (is possessed by).
');
INSERT INTO model.property VALUES (23, 'P56', 'E26', 'E19', 'bears feature', 'is found on', '2019-12-12 17:08:42.016696', NULL, 'This property links an instance of E19 Physical Object to an instance of E26 Physical Feature that it bears.
An E26 Physical Feature can only exist on one object. One object may bear more than one E26 Physical Feature. An E27 Site should be considered as an E26 Physical Feature on the surface of the Earth.
An instance B of E26 Physical Feature being a detail of the structure of another instance A of E26 Physical Feature can be linked to B by use of the property P46 is composed of (forms part of). This implies that the subfeature B is P56i found on the same E19 Physical Object as A.
P56 bears feature (is found on) is a shortcut. A more detailed representation can make use of the fully developed (i.e. indirect) path from E19 Physical Object through P59 has section (is located on or
Definition of the CIDOC Conceptual Reference Model 149 within), E53 Place, P53 has former or current location (is former or current location of) to E26 Physical Feature.
');
INSERT INTO model.property VALUES (24, 'P119', 'E2', 'E2', 'meets in time with', 'is met in time by', '2019-12-12 17:08:42.016696', NULL, 'This property indicates that one E2 Temporal Entity immediately follows another. 
It implies a particular order between the two entities: if A meets in time with B, then A must precede B. This property is only necessary if the relevant time spans are unknown (otherwise the relationship can be calculated). 
This property is the same as the "meets / met-by" relationships of Allen’s temporal logic (Allen, 1983, pp. 832-843).
');
INSERT INTO model.property VALUES (25, 'P32', 'E55', 'E7', 'used general technique', 'was technique of', '2019-12-12 17:08:42.016696', NULL, 'This property identifies the technique or method that was employed in an activity.
These techniques should be drawn from an external E55 Type hierarchy of consistent terminology of general techniques or methods such as embroidery, oil-painting, carbon dating, etc. Specific documented techniques should be described as instances of E29 Design or Procedure. This property identifies the technique that was employed in an act of modification.
');
INSERT INTO model.property VALUES (26, 'P28', 'E39', 'E10', 'custody surrendered by', 'surrendered custody through', '2019-12-12 17:08:42.016696', NULL, 'This property identifies the E39 Actor or Actors who surrender custody of an instance of E18 Physical Thing in an E10 Transfer of Custody activity. 
The property will typically describe an Actor surrendering custody of an object when it is handed over to someone else’s care. On occasion, physical custody may be surrendered involuntarily – through accident, loss or theft.
In reality, custody is either transferred to someone or from someone, or both.
');
INSERT INTO model.property VALUES (27, 'P34', 'E18', 'E14', 'concerned', 'was assessed by', '2019-12-12 17:08:42.016696', NULL, 'This property identifies the E18 Physical Thing that was assessed during an E14 Condition Assessment activity. 
Conditions may be assessed either by direct observation or using recorded evidence. In the latter case the E18 Physical Thing does not need to be present or extant.
');
INSERT INTO model.property VALUES (28, 'P1', 'E41', 'E1', 'is identified by', 'identifies', '2019-12-12 17:08:42.016696', NULL, 'This property describes the naming or identification of any real world item by a name or any other identifier. 
This property is intended for identifiers in general use, which form part of the world the model intends to describe, and not merely for internal database identifiers which are specific to a technical system, unless these latter also have a more general use outside the technical context. This property includes in particular identification by mathematical expressions such as coordinate systems used for the identification of instances of E53 Place. The property does not reveal anything about when, where and by whom this identifier was used. A more detailed representation can be made using the fully developed (i.e. indirect) path through E15 Identifier Assignment.
');
INSERT INTO model.property VALUES (29, 'P41', 'E1', 'E17', 'classified', 'was classified by', '2019-12-12 17:08:42.016696', NULL, 'This property records the item to which a type was assigned in an E17 Type Assignment activity.
Any instance of a CRM entity may be assigned a type through type assignment. Type assignment events allow a more detailed path from E1 CRM Entity through P41 classified (was classified), E17 Type Assignment, P42 assigned (was assigned by) to E55 Type for assigning types to objects compared to the shortcut offered by P2 has type (is type of).
');
INSERT INTO model.property VALUES (90, 'P17', 'E1', 'E7', 'was motivated by', 'motivated', '2019-12-12 17:08:42.016696', NULL, 'This property describes an item or items that are regarded as a reason for carrying out the E7 Activity. 
For example, the discovery of a large hoard of treasure may call for a celebration, an order from head quarters can start a military manoeuvre. 
');
INSERT INTO model.property VALUES (30, 'P20', 'E5', 'E7', 'had specific purpose', 'was purpose of', '2019-12-12 17:08:42.016696', NULL, 'This property identifies the relationship between a preparatory activity and the event it is intended to be preparation for.
This includes activities, orders and other organisational actions, taken in preparation for other activities or events. 
P20 had specific purpose (was purpose of) implies that an activity succeeded in achieving its aim. If it does not succeed, such as the setting of a trap that did not catch anything, one may document the unrealized intention using P21 had general purpose (was purpose of):E55 Type and/or  P33 used specific technique (was used by): E29 Design or Procedure.');
INSERT INTO model.property VALUES (31, 'P91', 'E58', 'E54', 'has unit', 'is unit of', '2019-12-12 17:08:42.016696', NULL, 'This property shows the type of unit an E54 Dimension was expressed in.');
INSERT INTO model.property VALUES (32, 'P42', 'E55', 'E17', 'assigned', 'was assigned by', '2019-12-12 17:08:42.016696', NULL, 'This property records the type that was assigned to an entity by an E17 Type Assignment activity. 
Type assignment events allow a more detailed path from E1 CRM Entity through P41 classified (was classified by), E17 Type Assignment, P42 assigned (was assigned by) to E55 Type for assigning types to objects compared to the shortcut offered by P2 has type (is type of).
For example, a fragment of an antique vessel could be assigned the type “attic red figured belly handled amphora” by expert A. The same fragment could be assigned the type “shoulder handled amphora” by expert B.
A Type may be intellectually constructed independent from assigning an instance of it.
');
INSERT INTO model.property VALUES (33, 'P107', 'E39', 'E74', 'has current or former member', 'is current or former member of', '2019-12-12 17:08:42.016696', NULL, 'This property relates an E39 Actor to the E74 Group of which that E39 Actor is a member.
Groups, Legal Bodies and Persons, may all be members of Groups. A Group necessarily consists of more than one member.
This property is a shortcut of the more fully developed path from E74 Group through P144 joined with (gained member by), E85 Joining, P143 joined (was joined by) to E39 Actor
The property P107.1 kind of member can be used to specify the type of membership or the role the member has in the group. 
');
INSERT INTO model.property VALUES (34, 'P75', 'E30', 'E39', 'possesses', 'is possessed by', '2019-12-12 17:08:42.016696', NULL, 'This property identifies former or current instances of E30 Rights held by an E39 Actor.');
INSERT INTO model.property VALUES (35, 'P62', 'E1', 'E24', 'depicts', 'is depicted by', '2019-12-12 17:08:42.016696', NULL, 'This property identifies something that is depicted by an instance of E24 Physical Man-Made Thing. Depicting is meant in the sense that the surface of the E24 Physical Man-Made Thing shows, through its passive optical qualities or form, a representation of the entity depicted. It does not pertain to inscriptions or any other information encoding.

This property is a shortcut of the more fully developed path from E24 Physical Man-Made Thing through P65 shows visual item (is shown by), E36 Visual Item, P138 represents (has representation) to E1 CRM Entity. P62.1 mode of depiction allows the nature of the depiction to be refined.
');
INSERT INTO model.property VALUES (36, 'P99', 'E74', 'E68', 'dissolved', 'was dissolved by', '2019-12-12 17:08:42.016696', NULL, 'This property links the disbanding or E68 Dissolution of an E74 Group to the Group itself.');
INSERT INTO model.property VALUES (37, 'P129', 'E1', 'E89', 'is about', 'is subject of', '2019-12-12 17:08:42.016696', NULL, 'This property documents that an E89 Propositional Object has as subject an instance of E1 CRM Entity. 
');
INSERT INTO model.property VALUES (38, 'P65', 'E36', 'E24', 'shows visual item', 'is shown by', '2019-12-12 17:08:42.016696', NULL, 'This property documents an E36 Visual Item shown by an instance of E24 Physical Man-Made Thing.
This property is similar to P62 depicts (is depicted by) in that it associates an item of E24 Physical Man-Made Thing with a visual representation. However, P65 shows visual item (is shown by) differs from the P62 depicts (is depicted by) property in that it makes no claims about what the E36 Visual Item is deemed to represent. E36 Visual Item identifies a recognisable image or visual symbol, regardless of what this image may or may not represent.
For example, all recent British coins bear a portrait of Queen Elizabeth II, a fact that is correctly documented using P62 depicts (is depicted by). Different portraits have been used at different periods, however. P65 shows visual item (is shown by) can be used to refer to a particular portrait.
P65 shows visual item (is shown by) may also be used for Visual Items such as signs, marks and symbols, for example the ''Maltese Cross'' or the ''copyright symbol’ that have no particular representational content. 
This property is part of the fully developed path from E24 Physical Man-Made Thing through P65 shows visual item (is shown by), E36 Visual Item, P138 represents (has representation) to E1 CRM Entity which is shortcut by, P62 depicts (is depicted by).
');
INSERT INTO model.property VALUES (39, 'P116', 'E2', 'E2', 'starts', 'is started by', '2019-12-12 17:08:42.016696', NULL, 'This property allows the starting point for a E2 Temporal Entity to be situated by reference to the starting point of another temporal entity of longer duration.  
This property is only necessary if the time span is unknown (otherwise the relationship can be calculated). This property is the same as the "starts / started-by" relationships of Allen’s temporal logic (Allen, 1983, pp. 832-843).
');
INSERT INTO model.property VALUES (40, 'P55', 'E53', 'E19', 'has current location', 'currently holds', '2019-12-12 17:08:42.016696', NULL, 'This property records the location of an E19 Physical Object at the time of validity of the record or database containing the statement that uses this property. 
	This property is a specialisation of P53 has former or current location (is former or current location of). It indicates that the E53 Place associated with the E19 Physical Object is the current location of the object. The property does not allow any indication of how long the Object has been at the current location. 
P55 has current location (currently holds) is a shortcut. A more detailed representation can make use of the fully developed (i.e. indirect) path from E19 Physical Object through P25 moved (moved by), E9 Move P26 moved to (was destination of) to E53 Place if and only if this Move is the most recent.
');
INSERT INTO model.property VALUES (41, 'P14', 'E39', 'E7', 'carried out by', 'performed', '2019-12-12 17:08:42.016696', NULL, 'This property describes the active participation of an E39 Actor in an E7 Activity. 
It implies causal or legal responsibility. The P14.1 in the role of property of the property allows the nature of an Actor’s participation to be specified.
');
INSERT INTO model.property VALUES (42, 'P136', 'E1', 'E83', 'was based on', 'supported type creation', '2019-12-12 17:08:42.016696', NULL, 'This property identifies one or more items that were used as evidence to declare a new E55 Type.
The examination of these items is often the only objective way to understand the precise characteristics of a new Type. Such items should be deposited in a museum or similar institution for that reason. The taxonomic role renders the specific relationship of each item to the Type, such as "holotype" or "original element".
');
INSERT INTO model.property VALUES (43, 'P68', 'E57', 'E29', 'foresees use of', 'use foreseen by', '2019-12-12 17:08:42.016696', NULL, 'This property identifies an E57 Material foreseeen to be used by an E29 Design or Procedure. 
E29 Designs and procedures commonly foresee the use of particular E57 Materials. The fabrication of adobe bricks, for example, requires straw, clay and water. This property enables this to be documented.
This property is not intended for the documentation of E57 Materials that were used on a particular occasion when an instance of E29 Design or Procedure was executed.
');
INSERT INTO model.property VALUES (120, 'P74', 'E53', 'E39', 'has current or former residence', 'is current or former residence of', '2019-12-12 17:08:42.016696', NULL, 'This property describes the current or former E53 Place of residence of an E39 Actor. 
The residence may be either the Place where the Actor resides, or a legally registered address of any kind.
');
INSERT INTO model.property VALUES (44, 'P92', 'E77', 'E63', 'brought into existence', 'was brought into existence by', '2019-12-12 17:08:42.016696', NULL, 'This property allows an E63 Beginning of Existence event to be linked to the E77 Persistent Item brought into existence by it.
It allows a “start” to be attached to any Persistent Item being documented i.e. E70 Thing, E72 Legal Object, E39 Actor, E41 Appellation, E51 Contact Point and E55 Type');
INSERT INTO model.property VALUES (45, 'P7', 'E53', 'E4', 'took place at', 'witnessed', '2019-12-12 17:08:42.016696', NULL, 'This property describes the spatial location of an instance of E4 Period. 

The related E53 Place should be seen as an approximation of the geographical area within which the phenomena that characterise the period in question occurred. P7took place at (witnessed) does not convey any meaning other than spatial positioning (generally on the surface of the earth).  For example, the period "Révolution française" can be said to have taken place in “France”, the “Victorian” period, may be said to have taken place in “Britain” and its colonies, as well as other parts of Europe and north America.
A period can take place at multiple locations.
It is a shortcut of the more fully developed path from E4 Period through P161 has spatial projection, E53 Place, P89 falls within (contains) to E53 Place. 
');
INSERT INTO model.property VALUES (46, 'P78', 'E49', 'E52', 'is identified by', 'identifies', '2019-12-12 17:08:42.016696', NULL, 'This property identifies an E52 Time-Span using an E49Time Appellation.');
INSERT INTO model.property VALUES (47, 'P16', 'E70', 'E7', 'used specific object', 'was used for', '2019-12-12 17:08:42.016696', NULL, 'This property describes the use of material or immaterial things in a way essential to the performance or the outcome of an E7 Activity. 
This property typically applies to tools, instruments, moulds, raw materials and items embedded in a product. It implies that the presence of the object in question was a necessary condition for the action. For example, the activity of writing this text required the use of a computer. An immaterial thing can be used if at least one of its carriers is present. For example, the software tools on a computer.
Another example is the use of a particular name by a particular group of people over some span to identify a thing, such as a settlement. In this case, the physical carriers of this name are at least the people understanding its use.
');
INSERT INTO model.property VALUES (48, 'P161', 'E53', 'E92', 'has spatial projection', 'is spatial projection of', '2019-12-12 17:08:42.016696', NULL, 'This property associates an instance of a E92 Spacetime Volume with an instance of E53 Place that is the result of the spatial projection of the instance of a E92 Spacetime Volume on a reference space. In general there can be more than one useful reference space to describe the spatial projection of a spacetime volume, such as that of a battle ship versus that of the seafloor. Therefore the projection is not unique.
This is part of the fully developed path that is shortcut by P7took place at (witnessed).The more fully developed path from E4 Period through P161 has spatial projection, E53 Place, P89 falls within (contains) to E53 Place. 
	');
INSERT INTO model.property VALUES (49, 'P87', 'E44', 'E53', 'is identified by', 'identifies', '2019-12-12 17:08:42.016696', NULL, 'This property identifies an E53 Place using an E44 Place Appellation. 
Examples of Place Appellations used to identify Places include instances of E48 Place Name, addresses, E47 Spatial Coordinates etc.
');
INSERT INTO model.property VALUES (50, 'P51', 'E39', 'E18', 'has former or current owner', 'is former or current owner of', '2019-12-12 17:08:42.016696', NULL, 'This property identifies the E39 Actor that is or has been the legal owner (i.e. title holder) of an instance of E18 Physical Thing at some time.
The distinction with P52 has current owner (is current owner of) is that P51 has former or current owner (is former or current owner of) does not indicate whether the specified owners are current. P51 has former or current owner (is former or current owner of) is a shortcut for the more detailed path from E18 Physical Thing through P24 transferred title of (changed ownership through), E8 Acquisition, P23 transferred title from (surrendered title through), or P22 transferred title to (acquired title through) to E39 Actor.
');
INSERT INTO model.property VALUES (51, 'P67', 'E1', 'E89', 'refers to', 'is referred to by', '2019-12-12 17:08:42.016696', NULL, 'This property documents that an E89 Propositional Object makes a statement about an instance of E1 CRM Entity. P67 refers to (is referred to by) has the P67.1 has type link to an instance of E55 Type. This is intended to allow a more detailed description of the type of reference. This differs from P129 is about (is subject of), which describes the primary subject or subjects of the E89 Propositional Object.
');
INSERT INTO model.property VALUES (52, 'P108', 'E24', 'E12', 'has produced', 'was produced by', '2019-12-12 17:08:42.016696', NULL, 'This property identifies the E24 Physical Man-Made Thing that came into existence as a result of an E12 Production.
The identity of an instance of E24 Physical Man-Made Thing is not defined by its matter, but by its existence as a subject of documentation. An E12 Production can result in the creation of multiple instances of E24 Physical Man-Made Thing.
');
INSERT INTO model.property VALUES (53, 'P58', 'E46', 'E18', 'has section definition', 'defines section', '2019-12-12 17:08:42.016696', NULL, 'This property links an area (section) named by a E46 Section Definition to the instance of E18 Physical Thing upon which it is found.
The CRM handles sections as locations (instances of E53 Place) within or on E18 Physical Thing that are identified by E46 Section Definitions. Sections need not be discrete and separable components or parts of an object.
This is part of a more developed path from E18 Physical Thing through P58, E46 Section Definition, P87 is identified by (identifies) that allows a more precise definition of a location found on an object than the shortcut P59 has section (is located on or within).
A particular instance of a Section Definition only applies to one instance of Physical Thing.');
INSERT INTO model.property VALUES (54, 'P100', 'E21', 'E69', 'was death of', 'died in', '2019-12-12 17:08:42.016696', NULL, 'This property property links an E69 Death event to the E21 Person that died.');
INSERT INTO model.property VALUES (55, 'P150', 'E55', 'E55', 'defines typical parts of', 'defines typical wholes for', '2019-12-12 17:08:42.016696', NULL, 'This property associates an instance of E55 Type “A” with an instance of E55 Type “B”, when items
of type “A” typically form part of items of type “B”, such as “car motors” and “cars”.
It allows types to be organised into hierarchies based on one type describing a typical part of another.
This property is equivalent to "broader term partitive (BTP)" as defined in ISO 2788 and
“broaderPartitive” in SKOS.
');
INSERT INTO model.property VALUES (56, 'P133', 'E92', 'E92', 'is separated from', NULL, '2019-12-12 17:08:42.016696', NULL, 'This symmetric property associates two instances of E92 Spacetime Volume that have no extent in
common.
');
INSERT INTO model.property VALUES (57, 'P105', 'E39', 'E72', 'right held by', 'has right on', '2019-12-12 17:08:42.016696', NULL, 'This property identifies the E39 Actor who holds the instances of E30 Right to an E72 Legal Object.
	It is a superproperty of P52 has current owner (is current owner of) because ownership is a right that is held on the owned object.
P105 right held by (has right on) is a shortcut of the fully developed path from E72 Legal Object through P104 is subject to (applies to), E30 Right, P75 possesses (is possessed by) to E39 Actor.
');
INSERT INTO model.property VALUES (58, 'P44', 'E3', 'E18', 'has condition', 'is condition of', '2019-12-12 17:08:42.016696', NULL, 'This property records an E3 Condition State for some E18 Physical Thing.
It is a shortcut of the more fully developed path from E18 Physical Thing through P34 concerned (was assessed by), E14 Condition Assessment P35 has identified (was identified by) to E3 Condition State. It offers no information about how and when the E3 Condition State was established, nor by whom. 
An instance of Condition State is specific to an instance of Physical Thing.
');
INSERT INTO model.property VALUES (59, 'P2', 'E55', 'E1', 'has type', 'is type of', '2019-12-12 17:08:42.016696', NULL, 'This property allows sub typing of CRM entities - a form of specialisation – through the use of a terminological hierarchy, or thesaurus. 
The CRM is intended to focus on the high-level entities and relationships needed to describe data structures. Consequently, it does not specialise entities any further than is required for this immediate purpose. However, entities in the isA hierarchy of the CRM may by specialised into any number of sub entities, which can be defined in the E55 Type hierarchy. E51 Contact Point, for example, may be specialised into “e-mail address”, “telephone number”, “post office box”, “URL” etc. none of which figures explicitly in the CRM hierarchy. Sub typing obviously requires consistency between the meaning of the terms assigned and the more general intent of the CRM entity in question.
');
INSERT INTO model.property VALUES (60, 'P135', 'E55', 'E83', 'created type', 'was created by', '2019-12-12 17:08:42.016696', NULL, 'This property identifies the E55 Type, which is created in an E83Type Creation activity.');
INSERT INTO model.property VALUES (61, 'P142', 'E90', 'E15', 'used constituent', 'was used in', '2019-12-12 17:08:42.016696', NULL, 'This property associates the event of assigning an instance of E42 Identifier to an entity, with  the instances of E41 Appellation that were used as elements of the identifier.
');
INSERT INTO model.property VALUES (62, 'P166', 'E92', 'E93', 'was a presence of', 'had presence', '2019-12-12 17:08:42.016696', NULL, 'This property relates an E93 Presence with the STV it is part of… 
	');
INSERT INTO model.property VALUES (63, 'P40', 'E54', 'E16', 'observed dimension', 'was observed in', '2019-12-12 17:08:42.016696', NULL, 'This property records the dimension that was observed in an E16 Measurement Event.
E54 Dimension can be any quantifiable aspect of E70 Thing. Weight, image colour depth and monetary value are dimensions in this sense. One measurement activity may determine more than one dimension of one object.
Dimensions may be determined either by direct observation or using recorded evidence. In the latter case the measured Thing does not need to be present or extant.
Even though knowledge of the value of a dimension requires measurement, the dimension may be an object of discourse prior to, or even without, any measurement being made.
');
INSERT INTO model.property VALUES (64, 'P19', 'E71', 'E7', 'was intended use of', 'was made for', '2019-12-12 17:08:42.016696', NULL, 'This property relates an E7 Activity with objects created specifically for use in the activity. 
This is distinct from the intended use of an item in some general type of activity such as the book of common prayer which was intended for use in Church of England services (see P101 had as general use (was use of)).');
INSERT INTO model.property VALUES (65, 'P22', 'E39', 'E8', 'transferred title to', 'acquired title through', '2019-12-12 17:08:42.016696', NULL, 'This property identifies the E39 Actor that acquires the legal ownership of an object as a result of an E8 Acquisition. 
The property will typically describe an Actor purchasing or otherwise acquiring an object from another Actor. However, title may also be acquired, without any corresponding loss of title by another Actor, through legal fieldwork such as hunting, shooting or fishing.
In reality the title is either transferred to or from someone, or both.
');
INSERT INTO model.property VALUES (66, 'P97', 'E21', 'E67', 'from father', 'was father for', '2019-12-12 17:08:42.016696', NULL, 'This property links an E67 Birth event to an E21 Person in the role of biological father.
Note that biological fathers are not seen as necessary participants in the Birth, whereas birth-giving mothers are (see P96 by mother (gave birth)). The Person being born is linked to the Birth with the property P98 brought into life (was born).
This is not intended for use with general natural history material, only people. There is no explicit method for modelling conception and gestation except by using extensions. 
A Birth event is normally (but not always) associated with one biological father.
');
INSERT INTO model.property VALUES (67, 'P138', 'E1', 'E36', 'represents', 'has representation', '2019-12-12 17:08:42.016696', NULL, 'This property establishes the relationship between an E36 Visual Item and the entity that it visually represents.
Any entity may be represented visually. This property is part of the fully developed path from E24 Physical Man-Made Thing through P65 shows visual item (is shown by), E36 Visual Item, P138 represents (has representation) to E1 CRM Entity, which is shortcut by P62depicts (is depicted by). P138.1 mode of representation allows the nature of the representation to be refined.
This property is also used for the relationship between an original and a digitisation of the original by the use of techniques such as digital photography, flatbed or infrared scanning. Digitisation is here seen as a process with a mechanical, causal component rendering the spatial distribution of structural and optical properties of the original and does not necessarily include any visual similarity identifiable by human observation.
');
INSERT INTO model.property VALUES (68, 'P73', 'E33', 'E33', 'has translation', 'is translation of', '2019-12-12 17:08:42.016696', NULL, 'This property describes the source and target of instances of E33Linguistic Object involved in a translation.
When a Linguistic Object is translated into a new language it becomes a new Linguistic Object, despite being conceptually similar to the source object.
');
INSERT INTO model.property VALUES (69, 'P106', 'E90', 'E90', 'is composed of', 'forms part of', '2019-12-12 17:08:42.016696', NULL, 'This property associates an instance of E90 Symbolic Object with a part of it that is by itself an instance of E90 Symbolic Object, such as fragments of texts or clippings from an image.
');
INSERT INTO model.property VALUES (70, 'P112', 'E24', 'E80', 'diminished', 'was diminished by', '2019-12-12 17:08:42.016696', NULL, 'This property identifies the E24 Physical Man-Made Thing that was diminished by E80 Part Removal.
Although a Part removal activity normally concerns only one item of Physical Man-Made Thing, it is possible to imagine circumstances under which more than one item might be diminished by a single Part Removal activity. 
');
INSERT INTO model.property VALUES (71, 'P71', 'E1', 'E32', 'lists', 'is listed in', '2019-12-12 17:08:42.016696', NULL, 'This property documents a source E32 Authority Document for an instance of an E1 CRM Entity.
');
INSERT INTO model.property VALUES (72, 'P167', 'E53', 'E93', 'at', 'was place of', '2019-12-12 17:08:42.016696', NULL, 'This property points to a wider area in which my thing /event was… 
	');
INSERT INTO model.property VALUES (73, 'P45', 'E57', 'E18', 'consists of', 'is incorporated in', '2019-12-12 17:08:42.016696', NULL, 'This property identifies the instances of E57 Materials of which an instance of E18 Physical Thing is composed.
All physical things consist of physical materials. P45 consists of (is incorporated in) allows the different Materials to be recorded. P45 consists of (is incorporated in) refers here to observed Material as opposed to the consumed raw material.
A Material, such as a theoretical alloy, may not have any physical instances');
INSERT INTO model.property VALUES (74, 'P146', 'E74', 'E86', 'separated from', 'lost member by', '2019-12-12 17:08:42.016696', NULL, 'This property identifies the instance of E74 Group an instance of E39 Actor leaves through an instance of E86 Leaving.
Although a Leaving activity normally concerns only one instance of E74 Group, it is possible to imagine circumstances under which leaving one E74 Group implies leaving another E74 Group as well.
');
INSERT INTO model.property VALUES (104, 'P98', 'E21', 'E67', 'brought into life', 'was born', '2019-12-12 17:08:42.016696', NULL, 'This property links an E67Birth event to an E21 Person in the role of offspring.
Twins, triplets etc. are brought into life by the same Birth event. This is not intended for use with general Natural History material, only people. There is no explicit method for modelling conception and gestation except by using extensions.
');
INSERT INTO model.property VALUES (121, 'P147', 'E78', 'E87', 'curated', 'was curated by', '2019-12-12 17:08:42.016696', NULL, 'This property associates an instance of E87 Curation Activity with the instance of E78 Collection that is subject of that  curation activity.
');
INSERT INTO model.property VALUES (75, 'P156', 'E53', 'E18', 'occupies', 'is occupied by', '2019-12-12 17:08:42.016696', NULL, 'This property describes the largest volume in space that an instance of E18 Physical Thing has occupied at any time during its existence, with respect to the reference space relative to itself. This allows you to describe the thing itself as a place that may contain other things, such as a box that may contain coins. In other words, it is the volume that contains all the points which the thing has covered at some time during its existence. In the case of an E26 Physical Feature the default reference space is the one in which the object that bears the feature or at least the surrounding matter of the feature is at rest. In this case there is a 1:1 relation of E26 Feature and E53 Place. For simplicity of implementation multiple inheritance (E26 Feature IsA E53 Place) may be a practical approach.

For instances of E19 Physical Objects the default reference space is the one which is at rest to the object itself, i.e. which moves together with the object. We include in the occupied space the space filled by the matter of the physical thing and all its inner spaces. 

This property is a subproperty of P161 has spatial projection because it refers to its own domain as reference space for its range, whereas P161 has spatial projection may refer to a place in terms of any reference space. For some instances of E18 Physical Object the relative stability of form may not be sufficient to define a useful local reference space, for instance for an amoeba. In such cases the fully developed path to an external reference space and using a temporal validity component may be adequate to determine the place they have occupied.

In contrast to P156  occupies, the property P53 has former or current location identifies an instance of E53 Place at which a thing is or has been for some unspecified time span.  Further it does not constrain the reference space of the referred instance of P53 Place.
	');
INSERT INTO model.property VALUES (76, 'P76', 'E51', 'E39', 'has contact point', 'provides access to', '2019-12-12 17:08:42.016696', NULL, 'This property identifies an E51 Contact Point of any type that provides access to an E39 Actor by any communication method, such as e-mail or fax.
');
INSERT INTO model.property VALUES (77, 'P128', 'E90', 'E18', 'carries', 'is carried by', '2019-12-12 17:08:42.016696', NULL, 'This property identifies an E90 Symbolic Object carried by an instance of E18 Physical Thing.
');
INSERT INTO model.property VALUES (78, 'P24', 'E18', 'E8', 'transferred title of', 'changed ownership through', '2019-12-12 17:08:42.016696', NULL, 'This property identifies the E18 Physical Thing or things involved in an E8 Acquisition. 
In reality, an acquisition must refer to at least one transferred item.
');
INSERT INTO model.property VALUES (79, 'P84', 'E54', 'E52', 'had at most duration', 'was maximum duration of', '2019-12-12 17:08:42.016696', NULL, 'This property describes the maximum length of time covered by an E52 Time-Span. 
It allows an E52 Time-Span to be associated with an E54 Dimension representing it’s maximum duration (i.e. it’s outer boundary) independent from the actual beginning and end.
');
INSERT INTO model.property VALUES (80, 'P27', 'E53', 'E9', 'moved from', 'was origin of', '2019-12-12 17:08:42.016696', NULL, 'This property identifies a starting E53 Place of an E9 Move.

A move will be linked to an origin, such as the move of an artefact from storage to display. A move may be linked to many starting instances of E53 Place by multiple instances of this property. In this case the move describes the picking up of a set of objects. The area of the move includes the origin(s), route and destination(s).
Therefore the described origin is an instance of E53 Place which P89 falls within (contains) the instance of E53 Place the move P7 took place at.
');
INSERT INTO model.property VALUES (81, 'P37', 'E42', 'E15', 'assigned', 'was assigned by', '2019-12-12 17:08:42.016696', NULL, 'This property records the identifier that was assigned to an item in an Identifier Assignment activity.
The same identifier may be assigned on more than one occasion.
An Identifier might be created prior to an assignment.
');
INSERT INTO model.property VALUES (82, 'P118', 'E2', 'E2', 'overlaps in time with', 'is overlapped in time by', '2019-12-12 17:08:42.016696', NULL, 'This property identifies an overlap between the instances of E52 Time-Span of two instances of E2 Temporal Entity. 
It implies a temporal order between the two entities: if A overlaps in time B, then A must start before B, and B must end after A. This property is only necessary if the relevant time spans are unknown (otherwise the relationship can be calculated).
This property is the same as the "overlaps / overlapped-by" relationships of Allen’s temporal logic (Allen, 1983, pp. 832-843).
');
INSERT INTO model.property VALUES (83, 'P110', 'E24', 'E79', 'augmented', 'was augmented by', '2019-12-12 17:08:42.016696', NULL, 'This property identifies the E24 Physical Man-Made Thing that is added to (augmented) in an E79 Part Addition.
Although a Part Addition event normally concerns only one item of Physical Man-Made Thing, it is possible to imagine circumstances under which more than one item might be added to (augmented). For example, the artist Jackson Pollock trailing paint onto multiple canvasses.
');
INSERT INTO model.property VALUES (84, 'P93', 'E77', 'E64', 'took out of existence', 'was taken out of existence by', '2019-12-12 17:08:42.016696', NULL, 'This property allows an E64 End of Existence event to be linked to the E77 Persistent Item taken out of existence by it.
In the case of immaterial things, the E64 End of Existence is considered to take place with the destruction of the last physical carrier.
This allows an “end” to be attached to any Persistent Item being documented i.e. E70 Thing, E72 Legal Object, E39 Actor, E41 Appellation, E51 Contact Point and E55 Type. For many Persistent Items we know the maximum life-span and can infer, that they must have ended to exist. We assume in that case an End of Existence, which may be as unnoticeable as forgetting the secret knowledge by the last representative of some indigenous nation.
');
INSERT INTO model.property VALUES (85, 'P31', 'E24', 'E11', 'has modified', 'was modified by', '2019-12-12 17:08:42.016696', NULL, 'This property identifies the E24 Physical Man-Made Thing modified in an E11 Modification.
If a modification is applied to a non-man-made object, it is regarded as an E22 Man-Made Object from that time onwards. 
');
INSERT INTO model.property VALUES (86, 'P72', 'E56', 'E33', 'has language', 'is language of', '2019-12-12 17:08:42.016696', NULL, 'This property describes the E56 Language of an E33 Linguistic Object. 
Linguistic Objects are composed in one or more human Languages. This property allows these languages to be documented.
');
INSERT INTO model.property VALUES (87, 'P70', 'E1', 'E31', 'documents', 'is documented in', '2019-12-12 17:08:42.016696', NULL, 'This property describes the CRM Entities documented by instances of E31 Document.
Documents may describe any conceivable entity, hence the link to the highest-level entity in the CRM hierarchy. This property is intended for cases where a reference is regarded as being of a documentary character, in the scholarly or scientific sense.
');
INSERT INTO model.property VALUES (88, 'P23', 'E39', 'E8', 'transferred title from', 'surrendered title through', '2019-12-12 17:08:42.016696', NULL, 'This property identifies the E39 Actor or Actors who relinquish legal ownership as the result of an E8 Acquisition.
The property will typically be used to describe a person donating or selling an object to a museum. In reality title is either transferred to or from someone, or both.
');
INSERT INTO model.property VALUES (89, 'P50', 'E39', 'E18', 'has current keeper', 'is current keeper of', '2019-12-12 17:08:42.016696', NULL, 'This property identifies the E39 Actor or Actors who had custody of an instance of E18 Physical Thing at the time of validity of the record or database containing the statement that uses this property.
	P50 has current keeper (is current keeper of) is a shortcut for the more detailed path from E18 Physical Thing through P30 transferred custody of (custody transferred through), E10 Transfer of Custody, P29 custody received by (received custody through) to E39 Actor.
');
INSERT INTO model.property VALUES (91, 'P53', 'E53', 'E18', 'has former or current location', 'is former or current location of', '2019-12-12 17:08:42.016696', NULL, 'This property allows an instance of E53 Place to be associated as the former or current location of an instance of E18 Physical Thing.
In the case of E19 Physical Objects, the property does not allow any indication of the Time-Span during which the Physical Object was located at this Place, nor if this is the current location.
In the case of immobile objects, the Place would normally correspond to the Place of creation.
P53 has former or current location (is former or current location of) is a shortcut. A more detailed representation can make use of the fully developed (i.e. indirect) path from E19 Physical Object through P25 moved (moved by), E9 Move, P26 moved to (was destination of) or P27 moved from (was origin of) to E53 Place.
');
INSERT INTO model.property VALUES (92, 'P132', 'E92', 'E92', 'overlaps with', NULL, '2019-12-12 17:08:42.016696', NULL, 'This symmetric property associates two instances of E92 Spacetime Volume that have some of their
extent in common.
');
INSERT INTO model.property VALUES (93, 'P124', 'E77', 'E81', 'transformed', 'was transformed by', '2019-12-12 17:08:42.016696', NULL, 'This property identifies the E77 Persistent Item or items that cease to exist due to a E81 Transformation. 
It is replaced by the result of the Transformation, which becomes a new unit of documentation. The continuity between both items, the new and the old, is expressed by the link to the common Transformation.
');
INSERT INTO model.property VALUES (94, 'P131', 'E82', 'E39', 'is identified by', 'identifies', '2019-12-12 17:08:42.016696', NULL, 'This property identifies a name used specifically to identify an E39 Actor. 
This property is a specialisation of P1 is identified by (identifies) is identified by.
');
INSERT INTO model.property VALUES (95, 'P12', 'E77', 'E5', 'occurred in the presence of', 'was present at', '2019-12-12 17:08:42.016696', NULL, 'This property describes the active or passive presence of an E77 Persistent Item in an E5 Event without implying any specific role. 
It connects the history of a thing with the E53 Place and E50 Date of an event. For example, an object may be the desk, now in a museum on which a treaty was signed. The presence of an immaterial thing implies the presence of at least one of its carriers.
');
INSERT INTO model.property VALUES (96, 'P69', 'E29', 'E29', 'is associated with', NULL, '2019-12-12 17:08:42.016696', NULL, 'This property generalises relationships like whole-part, sequence, prerequisite or inspired by between instances of E29 Design or Procedure. Any instance of E29 Design or Procedure may be associated with other designs or procedures. The property is considered to be symmetrical unless otherwise indicated by P69.1 has type.
The P69.1 has type property of P69 has association with allows the nature of the association to be specified reading from domain to range; examples of types of association between instances of E29 Design or Procedure include: has part, follows, requires, etc.
The property can typically be used to model the decomposition of the description of a complete workflow into a series of separate procedures.
');
INSERT INTO model.property VALUES (97, 'P137', 'E55', 'E1', 'exemplifies', 'is exemplified by', '2019-12-12 17:08:42.016696', NULL, 'This property allows an item to be declared as a particular example of an E55 Type or taxon
	The P137.1 in the taxonomic role property of P137 exemplifies (is exemplified by) allows differentiation of taxonomic roles. The taxonomic role renders the specific relationship of this example to the Type, such as "prototypical", "archetypical", "lectotype", etc. The taxonomic role "lectotype" is not associated with the Type Creation (E83) itself, but selected in a later phase.
');
INSERT INTO model.property VALUES (98, 'P52', 'E39', 'E18', 'has current owner', 'is current owner of', '2019-12-12 17:08:42.016696', NULL, 'This property identifies the E21 Person, E74 Group or E40 Legal Body that was the owner of an instance of E18 Physical Thing at the time of validity of the record or database containing the statement that uses this property.
P52 has current owner (is current owner of) is a shortcut for the more detailed path from E18 Physical Thing through P24 transferred title of (changed ownership through), E8 Acquisition, P22 transferred title to (acquired title through) to E39 Actor, if and only if this acquisition event is the most recent.
');
INSERT INTO model.property VALUES (99, 'P164', 'E52', 'E93', 'during', 'was time-span of', '2019-12-12 17:08:42.016696', NULL, 'This property relates an instance of E93 Presence with an arbitrary instance of E52 Time-Span that
defines the section of the spacetime volume that this instance of E93 Presence is related to by the property P166 was a presence of (had presence).
	');
INSERT INTO model.property VALUES (100, 'P49', 'E39', 'E18', 'has former or current keeper', 'is former or current keeper of', '2019-12-12 17:08:42.016696', NULL, '
This property identifies the E39 Actor or Actors who have or have had custody of an instance of E18 Physical Thing at
some time. This property leaves open the question if parts of this physical thing have
been added or removed during the time-spans it has been under the custody of this
actor, but it is required that at least a part which can unambiguously be identified as
representing the whole has been under this custody for its whole time. The way, in
which a representative part is defined, should ensure that it is unambiguous who keeps
a part and who the whole and should be consistent with the identity criteria of the kept
instance of E18 Physical Thing.
The distinction with P50 has current keeper (is current keeper of) is that P49 has former or current
keeper (is former or current keeper of) leaves open the question as to whether the specified keepers are
current.
P49 has former or current keeper (is former or current keeper of) is a shortcut for the more detailed
path from E18 Physical Thing through P30 transferred custody of (custody transferred through), E10
Transfer of Custody, P28 custody surrendered by (surrendered custody through) or P29 custody
received by (received custody through) to E39 Actor.
');
INSERT INTO model.property VALUES (101, 'P144', 'E74', 'E85', 'joined with', 'gained member by', '2019-12-12 17:08:42.016696', NULL, 'This property identifies the instance of E74 Group of which an instance of E39 Actor becomes a member through an instance of E85 Joining.
Although a Joining activity normally concerns only one instance of E74 Group, it is possible to imagine circumstances under which becoming member of one Group implies becoming member of another Group as well. 
Joining events allow for describing people becoming members of a group with a more detailed path from E74 Group through P144 joined with (gained member by), E85 Joining, P143 joined (was joined by) to E39 Actor, compared to the shortcut offered by P107 has current or former member (is current or former member of).
The property P144.1 kind of member can be used to specify the type of membership or the role the member has in the group. 
');
INSERT INTO model.property VALUES (102, 'P8', 'E18', 'E4', 'took place on or within', 'witnessed', '2019-12-12 17:08:42.016696', NULL, 'This property describes the location of an instance of E4 Period with respect to an E19 Physical Object. 
P8 took place on or within (witnessed) is a shortcut of the more fully developed path from E4 Period through P7 took place at, E53 Place, P156 occupies (is occupied by) to E18 Physical Thing.

It describes a period that can be located with respect to the space defined by an E19 Physical Object such as a ship or a building. The precise geographical location of the object during the period in question may be unknown or unimportant. 
For example, the French and German armistice of 22 June 1940 was signed in the same railway carriage as the armistice of 11 November 1918.
');
INSERT INTO model.property VALUES (103, 'P15', 'E1', 'E7', 'was influenced by', 'influenced', '2019-12-12 17:08:42.016696', NULL, 'This is a high level property, which captures the relationship between an E7 Activity and anything that may have had some bearing upon it.
The property has more specific sub properties.
');
INSERT INTO model.property VALUES (105, 'P152', 'E21', 'E21', 'has parent', 'is parent of', '2019-12-12 17:08:42.016696', NULL, 'This property associates an instance of E21 Person with another instance of E21 Person who plays the role of the first instance’s parent, regardless of whether the relationship is biological parenthood, assumed or pretended biological parenthood or an equivalent legal status of rights and obligations obtained by a social or legal act. 
	This property is, among others, a shortcut of the fully developed paths from ‘E21Person’ through ‘P98i was born’, ‘E67 Birth’, ‘P96 by mother’ to ‘E21 Person’, and from ‘E21Person’ through ‘P98i was born’, ‘E67 Birth’, ‘P97 from father’ to ‘E21 Person’.
	');
INSERT INTO model.property VALUES (106, 'P43', 'E54', 'E70', 'has dimension', 'is dimension of', '2019-12-12 17:08:42.016696', NULL, 'This property records a E54 Dimension of some E70 Thing.
It is a shortcut of the more fully developed path from E70 Thing through P39 measured (was measured by), E16 Measurement P40 observed dimension (was observed in) to E54 Dimension. It offers no information about how and when an E54 Dimension was established, nor by whom.
An instance of E54 Dimension is specific to an instance of E70 Thing.
');
INSERT INTO model.property VALUES (107, 'P38', 'E42', 'E15', 'deassigned', 'was deassigned by', '2019-12-12 17:08:42.016696', NULL, 'This property records the identifier that was deassigned from an instance of E1 CRM Entity.
Deassignment of an identifier may be necessary when an item is taken out of an inventory, a new numbering system is introduced or items are merged or split up. 
The same identifier may be deassigned on more than one occasion.
');
INSERT INTO model.property VALUES (108, 'P123', 'E77', 'E81', 'resulted in', 'resulted from', '2019-12-12 17:08:42.016696', NULL, 'This property identifies the E77 Persistent Item or items that are the result of an E81 Transformation. 
New items replace the transformed item or items, which cease to exist as units of documentation. The physical continuity between the old and the new is expressed by the link to the common Transformation.
');
INSERT INTO model.property VALUES (109, 'P103', 'E55', 'E71', 'was intended for', 'was intention of', '2019-12-12 17:08:42.016696', NULL, 'This property links an instance of E71 Man-Made Thing to an E55 Type of usage. 
It creates a property between specific man-made things, both physical and immaterial, to Types of intended methods and techniques of use. Note: A link between specific man-made things and a specific use activity should be expressed using P19 was intended use of (was made for).');
INSERT INTO model.property VALUES (110, 'P86', 'E52', 'E52', 'falls within', 'contains', '2019-12-12 17:08:42.016696', NULL, 'This property describes the inclusion relationship between two instances of E52 Time-Span.
This property supports the notion that a Time-Span’s temporal extent falls within the temporal extent of another Time-Span. It addresses temporal containment only, and no contextual link between the two instances of Time-Span is implied.
');
INSERT INTO model.property VALUES (111, 'P140', 'E1', 'E13', 'assigned attribute to', 'was attributed by', '2019-12-12 17:08:42.016696', NULL, 'This property indicates the item to which an attribute or relation is assigned. ');
INSERT INTO model.property VALUES (112, 'P139', 'E41', 'E41', 'has alternative form', NULL, '2019-12-12 17:08:42.016696', NULL, 'This property establishes a relationship of equivalence between two instances of E41 Appellation independent from any item identified by them. It is a dynamic asymmetric relationship, where the range expresses the derivative, if such a direction can be established. Otherwise, the relationship is symmetric. The relationship is not transitive.
The equivalence applies to all cases of use of an instance of E41 Appellation. Multiple names assigned to an object, which are not equivalent for all things identified with a specific instance of E41 Appellation, should be modelled as repeated values of P1 is identified by (identifies). 
P139.1 has type allows the type of derivation, such as “transliteration from Latin 1 to ASCII” be refined..
');
INSERT INTO model.property VALUES (113, 'P94', 'E28', 'E65', 'has created', 'was created by', '2019-12-12 17:08:42.016696', NULL, 'This property allows a conceptual E65 Creation to be linked to the E28 Conceptual Object created by it. 
It represents the act of conceiving the intellectual content of the E28 Conceptual Object. It does not represent the act of creating the first physical carrier of the E28 Conceptual Object. As an example, this is the composition of a poem, not its commitment to paper.
');
INSERT INTO model.property VALUES (114, 'P115', 'E2', 'E2', 'finishes', 'is finished by', '2019-12-12 17:08:42.016696', NULL, 'This property allows the ending point for a E2 Temporal Entity to be situated by reference to the ending point of another temporal entity of longer duration.  
This property is only necessary if the time span is unknown (otherwise the relationship can be calculated). This property is the same as the "finishes / finished-by" relationships of Allen’s temporal logic (Allen, 1983, pp. 832-843).
');
INSERT INTO model.property VALUES (115, 'P46', 'E18', 'E18', 'is composed of', 'forms part of', '2019-12-12 17:08:42.016696', NULL, 'This property allows instances of E18 Physical Thing to be analysed into component elements.

Component elements, since they are themselves instances of E18 Physical Thing, may be further analysed into sub-components, thereby creating a hierarchy of part decomposition. An instance of E18 Physical Thing may be shared between multiple wholes, for example two buildings may share a common wall. This property does not specify when and for how long a component element resided in the respective whole. If  a component is not part of a whole from the beginning of existence or until the end of existence of the whole, the classes E79 Part Addition and E90 Part Removal can be used to document when a component became part of a particular whole and/or when it stopped being a part of it. For the time-span of being part of the respective whole, the component is completely contained in the place the whole occupies.

This property is intended to describe specific components that are individually documented, rather than general aspects. Overall descriptions of the structure of an instance of E18 Physical Thing are captured by the P3 has note property.

The instances of E57 Material of which an item of E18 Physical Thing is composed should be documented using P45 consists of (is incorporated in).
');
INSERT INTO model.property VALUES (116, 'P126', 'E57', 'E11', 'employed', 'was employed in', '2019-12-12 17:08:42.016696', NULL, 'This property identifies E57 Material employed in an E11 Modification.
The E57 Material used during the E11 Modification does not necessarily become incorporated into the E24 Physical Man-Made Thing that forms the subject of the E11 Modification.
');
INSERT INTO model.property VALUES (117, 'P143', 'E39', 'E85', 'joined', 'was joined by', '2019-12-12 17:08:42.016696', NULL, 'This property identifies the instance of E39 Actor that becomes member of a E74 Group in an E85 Joining.
 	Joining events allow for describing people becoming members of a group with a more detailed path from E74 Group through P144 joined with (gained member by), E85 Joining, P143 joined (was joined by) to E39 Actor, compared to the shortcut offered by P107 has current or former member (is current or former member of).
');
INSERT INTO model.property VALUES (118, 'P160', 'E52', 'E92', 'has temporal projection', 'is temporal projection of', '2019-12-12 17:08:42.016696', NULL, 'This property describes the temporal projection of an instance of an E92 Spacetime Volume. The property P4 has time-span is the same as P160 has temporal projection if it is used to document an instance of E4 Period or any subclass of it. 
	');
INSERT INTO model.property VALUES (119, 'P10', 'E92', 'E92', 'falls within', 'contains', '2019-12-12 17:08:42.016696', NULL, 'This property associates an instance of E92 Spacetime Volume with another instance of E92 Spacetime Volume that falls within the latter. In other words, all points in the former are also points in the latter.
');
INSERT INTO model.property VALUES (122, 'P59', 'E53', 'E18', 'has section', 'is located on or within', '2019-12-12 17:08:42.016696', NULL, 'This property links an area to the instance of E18 Physical Thing upon which it is found.
It is typically used when a named E46 Section Definition is not appropriate.
E18 Physical Thing may be subdivided into arbitrary regions. 
P59 has section (is located on or within) is a shortcut. If the E53 Place is identified by a Section Definition, a more detailed representation can make use of the fully developed (i.e. indirect) path from E18 Physical Thing through P58 has section definition (defines section), E46 Section Definition, P87 is identified by (identifies) to E53 Place. A Place can only be located on or within one Physical Object.
');
INSERT INTO model.property VALUES (123, 'P109', 'E39', 'E78', 'has current or former curator', 'is current or former curator of', '2019-12-12 17:08:42.016696', NULL, 'This property identifies the E39 Actor or Actors who assume or have assumed overall curatorial responsibility for an E78 Collection.

It does not allow a history of curation to be recorded. This would require use of an Event  initiating a curator being responsible for  a Collection.
');
INSERT INTO model.property VALUES (124, 'P122', 'E53', 'E53', 'borders with', NULL, '2019-12-12 17:08:42.016696', NULL, 'This symmetric property allows the instances of E53 Place which share common borders to be related as such. 
This property is purely spatial, in contrast to Allen operators, which are purely temporal.
');
INSERT INTO model.property VALUES (125, 'P101', 'E55', 'E70', 'had as general use', 'was use of', '2019-12-12 17:08:42.016696', NULL, 'This property links an instance of E70 Thing to an E55 Type of usage.
It allows the relationship between particular things, both physical and immaterial, and general methods and techniques of use to be documented. Thus it can be asserted that a baseball bat had a general use for sport and a specific use for threatening people during the Great Train Robbery.
');
INSERT INTO model.property VALUES (126, 'P148', 'E89', 'E89', 'has component', 'is component of', '2019-12-12 17:08:42.016696', NULL, 'This property associates an instance of E89 Propositional Object with a structural part of it that is by itself an instance of E89 Propositional Object.');
INSERT INTO model.property VALUES (127, 'P54', 'E53', 'E19', 'has current permanent location', 'is current permanent location of', '2019-12-12 17:08:42.016696', NULL, 'This property records the foreseen permanent location of an instance of E19 Physical Object at the time of validity of the record or database containing the statement that uses this property.
P54 has current permanent location (is current permanent location of) is similar to P55 has current location (currently holds). However, it indicates the E53 Place currently reserved for an object, such as the permanent storage location or a permanent exhibit location. The object may be temporarily removed from the permanent location, for example when used in temporary exhibitions or loaned to another institution. The object may never actually be located at its permanent location.
');
INSERT INTO model.property VALUES (128, 'P125', 'E55', 'E7', 'used object of type', 'was type of object used in', '2019-12-12 17:08:42.016696', NULL, 'This property defines the kind of objects used in an E7 Activity, when the specific instance is either unknown or not of interest, such as use of "a hammer".
');
INSERT INTO model.property VALUES (129, 'P120', 'E2', 'E2', 'occurs before', 'occurs after', '2019-12-12 17:08:42.016696', NULL, 'This property identifies the relative chronological sequence of two temporal entities. 
It implies that a temporal gap exists between the end of A and the start of B. This property is only necessary if the relevant time spans are unknown (otherwise the relationship can be calculated).
This property is the same as the "before / after" relationships of Allen’s temporal logic (Allen, 1983, pp. 832-843).
');
INSERT INTO model.property VALUES (130, 'P151', 'E74', 'E66', 'was formed from', 'participated in', '2019-12-12 17:08:42.016696', NULL, 'This property associates an instance of E66 Formation with an instance of E74 Group from which the new group was formed preserving a sense of continuity such as in mission, membership or tradition.
	');
INSERT INTO model.property VALUES (131, 'P29', 'E39', 'E10', 'custody received by', 'received custody through', '2019-12-12 17:08:42.016696', NULL, 'This property identifies the E39 Actor or Actors who receive custody of an instance of E18 Physical Thing in an E10 Transfer of Custody activity. 
The property will typically describe Actors receiving custody of an object when it is handed over from another Actor’s care. On occasion, physical custody may be received involuntarily or illegally – through accident, unsolicited donation, or theft.
In reality, custody is either transferred to someone or from someone, or both.
');
INSERT INTO model.property VALUES (132, 'P89', 'E53', 'E53', 'falls within', 'contains', '2019-12-12 17:08:42.016696', NULL, 'This property identifies an instance of E53 Place that falls wholly within the extent of another E53 Place.
It addresses spatial containment only, and does not imply any relationship between things or phenomena occupying these places.
');
INSERT INTO model.property VALUES (133, 'P117', 'E2', 'E2', 'occurs during', 'includes', '2019-12-12 17:08:42.016696', NULL, 'This property allows the entire E52 Time-Span of an E2 Temporal Entity to be situated within the Time-Span of another temporal entity that starts before and ends after the included temporal entity.   
This property is only necessary if the time span is unknown (otherwise the relationship can be calculated). This property is the same as the "during / includes" relationships of Allen’s temporal logic (Allen, 1983, pp. 832-843).
');
INSERT INTO model.property VALUES (134, 'P127', 'E55', 'E55', 'has broader term', 'has narrower term', '2019-12-12 17:08:42.016696', NULL, 'This property identifies a super-Type to which an E55 Type is related. 
		It allows Types to be organised into hierarchies. This is the sense of "broader term generic  		(BTG)" as defined in ISO 2788
');
INSERT INTO model.property VALUES (135, 'P13', 'E18', 'E6', 'destroyed', 'was destroyed by', '2019-12-12 17:08:42.016696', NULL, 'This property allows specific instances of E18 Physical Thing that have been destroyed to be related to a destruction event. 
Destruction implies the end of an item’s life as a subject of cultural documentation – the physical matter of which the item was composed may in fact continue to exist. A destruction event may be contiguous with a Production that brings into existence a derived object composed partly of matter from the destroyed object.
');
INSERT INTO model.property VALUES (136, 'P113', 'E18', 'E80', 'removed', 'was removed by', '2019-12-12 17:08:42.016696', NULL, 'This property identifies the E18 Physical Thing that is removed during an E80 Part Removal activity.');
INSERT INTO model.property VALUES (137, 'P11', 'E39', 'E5', 'had participant', 'participated in', '2019-12-12 17:08:42.016696', NULL, 'This property describes the active or passive participation of instances of E39 Actors in an E5 Event. 
It connects the life-line of the related E39 Actor with the E53 Place and E50 Date of the event. The property implies that the Actor was involved in the event but does not imply any causal relationship. The subject of a portrait can be said to have participated in the creation of the portrait.
');
INSERT INTO model.property VALUES (138, 'P83', 'E54', 'E52', 'had at least duration', 'was minimum duration of', '2019-12-12 17:08:42.016696', NULL, 'This property describes the minimum length of time covered by an E52 Time-Span. 
It allows an E52 Time-Span to be associated with an E54 Dimension representing it’s minimum duration (i.e. it’s inner boundary) independent from the actual beginning and end.
');
INSERT INTO model.property VALUES (139, 'P157', 'E18', 'E53', 'is at rest relative to', 'provides reference space for', '2019-12-12 17:08:42.016696', NULL, 'This property associates an instance of P53 Place with the instance of E18 Physical Thing that determines a reference space for this instance of P53 Place by being at rest with respect to this reference space. The relative stability of form of an E18 Physical Thing defines its default reference space. The reference space is not spatially limited to the referred thing. For example, a ship determines a reference space in terms of which other ships in its neighbourhood may be described. Larger constellations of matter, such as continental plates, may comprise many physical features that are at rest with them and define the same reference space.
	');
INSERT INTO model.property VALUES (140, 'P141', 'E1', 'E13', 'assigned', 'was assigned by', '2019-12-12 17:08:42.016696', NULL, 'This property indicates the attribute that was assigned or the item that was related to the item denoted by a property P140 assigned attribute to in an Attribute assignment action.
');
INSERT INTO model.property VALUES (141, 'P145', 'E39', 'E86', 'separated', 'left by', '2019-12-12 17:08:42.016696', NULL, 'This property identifies the instance of E39 Actor that leaves an instance of E74 Group through an instance of E86 Leaving.');
INSERT INTO model.property VALUES (142, 'OA7', 'E39', 'E39', 'has relationship to', NULL, '2019-12-12 17:08:42.016696', NULL, 'OA7 is used to link two Actors (E39) via a certain relationship E39 Actor linked with E39 Actor: E39 (Actor) - P11i (participated in) - E5 (Event) - P11 (had participant) - E39 (Actor) Example: [ Stefan (E21)] participated in [ Relationship from Stefan to Joachim (E5)] had participant [Joachim (E21)] The connecting event is defined by an entity of class E55 (Type): [Relationship from Stefan to Joachim (E5)] has type [Son to Father (E55)]');
INSERT INTO model.property VALUES (143, 'OA8', 'E53', 'E77', ' begins in', NULL, '2019-12-12 17:08:42.016696', NULL, 'OA8 is used to link the beginning of a persistent item''s (E77) life span (or time of usage) with a certain place. E.g to document the birthplace of a person. E77 Persistent Item linked with a E53 Place: E77 (Persistent Item) - P92i (was brought into existence by) - E63 (Beginning of Existence) - P7 (took place at) - E53 (Place) Example: [Albert Einstein (E21)] was brought into existence by [Birth of Albert Einstein (E12)] took place at [Ulm (E53)]');
INSERT INTO model.property VALUES (144, 'OA9', 'E53', 'E77', ' begins in', NULL, '2019-12-12 17:08:42.016696', NULL, 'OA9 is used to link the end of a persistent item''s (E77) life span (or time of usage) with a certain place. E.g to document a person''s place of death. E77 Persistent Item linked with a E53 Place: E77 (Persistent Item) - P93i (was taken out of existence by) - E64 (End of Existence) - P7 (took place at) - E53 (Place) Example: [Albert Einstein (E21)] was taken out of by [Death of Albert Einstein (E12)] took place at [Princeton (E53)]');


--
-- Data for Name: property_i18n; Type: TABLE DATA; Schema: model; Owner: openatlas
--

INSERT INTO model.property_i18n VALUES (1, 'P95', 'de', 'hat gebildet', '2019-12-12 17:08:42.016696', NULL, 'wurde gebildet von');
INSERT INTO model.property_i18n VALUES (2, 'P95', 'en', 'has formed', '2019-12-12 17:08:42.016696', NULL, 'was formed by');
INSERT INTO model.property_i18n VALUES (3, 'P95', 'fr', 'a fondé', '2019-12-12 17:08:42.016696', NULL, 'a été fondé par');
INSERT INTO model.property_i18n VALUES (4, 'P95', 'ru', 'сформировал', '2019-12-12 17:08:42.016696', NULL, 'была сформирована посредством');
INSERT INTO model.property_i18n VALUES (5, 'P95', 'el', 'σχημάτισε', '2019-12-12 17:08:42.016696', NULL, 'σχηματίστηκε από');
INSERT INTO model.property_i18n VALUES (6, 'P95', 'pt', 'formou', '2019-12-12 17:08:42.016696', NULL, 'foi formado por');
INSERT INTO model.property_i18n VALUES (7, 'P95', 'zh', '组成了', '2019-12-12 17:08:42.016696', NULL, '被组成於');
INSERT INTO model.property_i18n VALUES (8, 'P21', 'de', 'hatte den allgemeinen Zweck', '2019-12-12 17:08:42.016696', NULL, 'war Zweck von');
INSERT INTO model.property_i18n VALUES (9, 'P21', 'en', 'had general purpose', '2019-12-12 17:08:42.016696', NULL, 'was purpose of');
INSERT INTO model.property_i18n VALUES (10, 'P21', 'fr', 'avait pour but général', '2019-12-12 17:08:42.016696', NULL, 'était le but de');
INSERT INTO model.property_i18n VALUES (11, 'P21', 'ru', 'имел общую цель', '2019-12-12 17:08:42.016696', NULL, 'был целью для');
INSERT INTO model.property_i18n VALUES (12, 'P21', 'el', 'είχε γενικό σκοπό', '2019-12-12 17:08:42.016696', NULL, 'ήταν σκοπός του/της');
INSERT INTO model.property_i18n VALUES (13, 'P21', 'pt', 'tinha propósito geral', '2019-12-12 17:08:42.016696', NULL, 'era o propósito de');
INSERT INTO model.property_i18n VALUES (14, 'P21', 'zh', '有通用目地', '2019-12-12 17:08:42.016696', NULL, '可利用');
INSERT INTO model.property_i18n VALUES (15, 'P26', 'de', 'bewegte bis zu', '2019-12-12 17:08:42.016696', NULL, 'war Zielort von');
INSERT INTO model.property_i18n VALUES (16, 'P26', 'en', 'moved to', '2019-12-12 17:08:42.016696', NULL, 'was destination of');
INSERT INTO model.property_i18n VALUES (17, 'P26', 'fr', 'a déplacé vers', '2019-12-12 17:08:42.016696', NULL, 'a été la destination de');
INSERT INTO model.property_i18n VALUES (18, 'P26', 'ru', 'перемещен в', '2019-12-12 17:08:42.016696', NULL, 'был пунктом назначения для');
INSERT INTO model.property_i18n VALUES (19, 'P26', 'el', 'μετακινήθηκε προς', '2019-12-12 17:08:42.016696', NULL, 'ήταν προορισμός του/της');
INSERT INTO model.property_i18n VALUES (20, 'P26', 'pt', 'locomoveu para', '2019-12-12 17:08:42.016696', NULL, 'era destinação de');
INSERT INTO model.property_i18n VALUES (21, 'P26', 'zh', '移入物件至', '2019-12-12 17:08:42.016696', NULL, '被作为移入地於');
INSERT INTO model.property_i18n VALUES (22, 'P165', 'en', 'incorporates', '2019-12-12 17:08:42.016696', NULL, 'is incorporated in');
INSERT INTO model.property_i18n VALUES (23, 'P149', 'en', 'is identified by', '2019-12-12 17:08:42.016696', NULL, 'identifies');
INSERT INTO model.property_i18n VALUES (24, 'P33', 'de', 'benutzte das bestimmte Verfahren', '2019-12-12 17:08:42.016696', NULL, 'wurde benutzt von');
INSERT INTO model.property_i18n VALUES (25, 'P33', 'en', 'used specific technique', '2019-12-12 17:08:42.016696', NULL, 'was used by');
INSERT INTO model.property_i18n VALUES (26, 'P33', 'fr', 'a employé comme technique spécifique', '2019-12-12 17:08:42.016696', NULL, 'a été employée par');
INSERT INTO model.property_i18n VALUES (27, 'P33', 'ru', 'использовал особую технику', '2019-12-12 17:08:42.016696', NULL, 'был использован посредством');
INSERT INTO model.property_i18n VALUES (28, 'P33', 'el', 'χρησιμοποίησε συγκεκριμένη τεχνική', '2019-12-12 17:08:42.016696', NULL, 'χρησιμοποιήθηκε για');
INSERT INTO model.property_i18n VALUES (29, 'P33', 'pt', 'usou técnica específica', '2019-12-12 17:08:42.016696', NULL, 'foi usada por');
INSERT INTO model.property_i18n VALUES (30, 'P33', 'zh', '使用特定技术', '2019-12-12 17:08:42.016696', NULL, '被特别使用於');
INSERT INTO model.property_i18n VALUES (31, 'P39', 'de', 'vermaß', '2019-12-12 17:08:42.016696', NULL, 'wurde vermessen durch');
INSERT INTO model.property_i18n VALUES (32, 'P39', 'en', 'measured', '2019-12-12 17:08:42.016696', NULL, 'was measured by');
INSERT INTO model.property_i18n VALUES (33, 'P39', 'fr', 'a mesuré', '2019-12-12 17:08:42.016696', NULL, 'a été mesuré par');
INSERT INTO model.property_i18n VALUES (34, 'P39', 'ru', 'измерил', '2019-12-12 17:08:42.016696', NULL, 'был измерен посредством');
INSERT INTO model.property_i18n VALUES (35, 'P39', 'el', 'μέτρησε', '2019-12-12 17:08:42.016696', NULL, 'μετρήθηκε από');
INSERT INTO model.property_i18n VALUES (36, 'P39', 'pt', 'mediu', '2019-12-12 17:08:42.016696', NULL, 'foi medida por');
INSERT INTO model.property_i18n VALUES (37, 'P39', 'zh', '测量了', '2019-12-12 17:08:42.016696', NULL, '被测量於');
INSERT INTO model.property_i18n VALUES (38, 'P130', 'de', 'zeigt Merkmale von', '2019-12-12 17:08:42.016696', NULL, 'Merkmale auch auf');
INSERT INTO model.property_i18n VALUES (39, 'P130', 'en', 'shows features of', '2019-12-12 17:08:42.016696', NULL, 'features are also found on');
INSERT INTO model.property_i18n VALUES (40, 'P130', 'fr', 'présente des caractéristiques de', '2019-12-12 17:08:42.016696', NULL, 'a des caractéristiques se trouvant aussi sur');
INSERT INTO model.property_i18n VALUES (41, 'P130', 'ru', 'демонстрирует признаки', '2019-12-12 17:08:42.016696', NULL, 'признаки также найдены на');
INSERT INTO model.property_i18n VALUES (42, 'P130', 'el', 'παρουσιάζει χαρακτηριστικά του/της', '2019-12-12 17:08:42.016696', NULL, 'χαρακτηριστικά του βρίσκονται επίσης σε');
INSERT INTO model.property_i18n VALUES (43, 'P130', 'pt', 'apresenta características de', '2019-12-12 17:08:42.016696', NULL, 'características são também encontradas em');
INSERT INTO model.property_i18n VALUES (44, 'P130', 'zh', '外观特征原出现於', '2019-12-12 17:08:42.016696', NULL, '外观特征被复制於');
INSERT INTO model.property_i18n VALUES (45, 'P9', 'de', 'setzt sich zusammen aus', '2019-12-12 17:08:42.016696', NULL, 'bildet Teil von');
INSERT INTO model.property_i18n VALUES (46, 'P9', 'en', 'consists of', '2019-12-12 17:08:42.016696', NULL, 'forms part of');
INSERT INTO model.property_i18n VALUES (47, 'P9', 'fr', 'consiste en', '2019-12-12 17:08:42.016696', NULL, 'fait partie de');
INSERT INTO model.property_i18n VALUES (48, 'P9', 'ru', 'состоит из', '2019-12-12 17:08:42.016696', NULL, 'формирует часть');
INSERT INTO model.property_i18n VALUES (49, 'P9', 'el', 'αποτελείται από', '2019-12-12 17:08:42.016696', NULL, 'αποτελεί μέρος του/της');
INSERT INTO model.property_i18n VALUES (50, 'P9', 'pt', 'consiste de', '2019-12-12 17:08:42.016696', NULL, 'faz parte de');
INSERT INTO model.property_i18n VALUES (51, 'P9', 'zh', '包含子时期', '2019-12-12 17:08:42.016696', NULL, '附属於');
INSERT INTO model.property_i18n VALUES (52, 'P102', 'de', 'trägt den Titel', '2019-12-12 17:08:42.016696', NULL, 'ist der Titel von');
INSERT INTO model.property_i18n VALUES (53, 'P102', 'en', 'has title', '2019-12-12 17:08:42.016696', NULL, 'is title of');
INSERT INTO model.property_i18n VALUES (54, 'P102', 'fr', 'a pour titre', '2019-12-12 17:08:42.016696', NULL, 'est le titre de');
INSERT INTO model.property_i18n VALUES (55, 'P102', 'ru', 'имеет заголовок', '2019-12-12 17:08:42.016696', NULL, 'является заголовком для');
INSERT INTO model.property_i18n VALUES (56, 'P102', 'el', 'έχει τίτλο', '2019-12-12 17:08:42.016696', NULL, 'είναι τίτλος του/της');
INSERT INTO model.property_i18n VALUES (57, 'P102', 'pt', 'tem título', '2019-12-12 17:08:42.016696', NULL, 'é título de');
INSERT INTO model.property_i18n VALUES (58, 'P102', 'zh', '有标题', '2019-12-12 17:08:42.016696', NULL, '被用为标题来称呼');
INSERT INTO model.property_i18n VALUES (59, 'P48', 'de', 'hat bevorzugtes Kennzeichen', '2019-12-12 17:08:42.016696', NULL, 'ist bevorzugtes Kennzeichen für');
INSERT INTO model.property_i18n VALUES (60, 'P48', 'en', 'has preferred identifier', '2019-12-12 17:08:42.016696', NULL, 'is preferred identifier of');
INSERT INTO model.property_i18n VALUES (61, 'P48', 'fr', 'a pour identificateur retenu', '2019-12-12 17:08:42.016696', NULL, 'est l’identificateur retenu de');
INSERT INTO model.property_i18n VALUES (62, 'P48', 'ru', 'имеет предпочтительный идентификатор', '2019-12-12 17:08:42.016696', NULL, 'является предпочтительным идентификатором для');
INSERT INTO model.property_i18n VALUES (63, 'P48', 'el', 'έχει προτιμώμενο αναγνωριστικό', '2019-12-12 17:08:42.016696', NULL, 'είναι προτιμώμενο αναγνωριστικό');
INSERT INTO model.property_i18n VALUES (64, 'P48', 'pt', 'tem identificador preferido', '2019-12-12 17:08:42.016696', NULL, 'é o identificador preferido de');
INSERT INTO model.property_i18n VALUES (65, 'P48', 'zh', '有首选标识符', '2019-12-12 17:08:42.016696', NULL, '首选标识符的标的物是');
INSERT INTO model.property_i18n VALUES (66, 'P5', 'de', 'besteht aus', '2019-12-12 17:08:42.016696', NULL, 'bildet Teil von');
INSERT INTO model.property_i18n VALUES (67, 'P5', 'en', 'consists of', '2019-12-12 17:08:42.016696', NULL, 'forms part of');
INSERT INTO model.property_i18n VALUES (68, 'P5', 'fr', 'consiste en', '2019-12-12 17:08:42.016696', NULL, 'fait partie de');
INSERT INTO model.property_i18n VALUES (69, 'P5', 'ru', 'состоит из', '2019-12-12 17:08:42.016696', NULL, 'формирует часть');
INSERT INTO model.property_i18n VALUES (70, 'P5', 'el', 'αποτελείται από', '2019-12-12 17:08:42.016696', NULL, 'αποτελεί μέρος του/της');
INSERT INTO model.property_i18n VALUES (71, 'P5', 'pt', 'consiste de', '2019-12-12 17:08:42.016696', NULL, 'faz parte de');
INSERT INTO model.property_i18n VALUES (72, 'P5', 'zh', '包含', '2019-12-12 17:08:42.016696', NULL, '组成了');
INSERT INTO model.property_i18n VALUES (73, 'P30', 'de', 'übertrug Gewahrsam über', '2019-12-12 17:08:42.016696', NULL, 'wechselte Gewahrsam durch');
INSERT INTO model.property_i18n VALUES (154, 'P119', 'el', 'προηγείται', '2019-12-12 17:08:42.016696', NULL, 'έπεται');
INSERT INTO model.property_i18n VALUES (74, 'P30', 'en', 'transferred custody of', '2019-12-12 17:08:42.016696', NULL, 'custody transferred through');
INSERT INTO model.property_i18n VALUES (75, 'P30', 'fr', 'changement de détenteur concernant', '2019-12-12 17:08:42.016696', NULL, 'a changé de détenteur du fait de');
INSERT INTO model.property_i18n VALUES (76, 'P30', 'ru', 'передало опеку на', '2019-12-12 17:08:42.016696', NULL, 'опека передана через');
INSERT INTO model.property_i18n VALUES (77, 'P30', 'el', 'μετεβίβασε κατοχή του/της/των', '2019-12-12 17:08:42.016696', NULL, 'άλλαξε κατοχή μέσω');
INSERT INTO model.property_i18n VALUES (78, 'P30', 'pt', 'transferida custódia de', '2019-12-12 17:08:42.016696', NULL, 'custódia transferida por meio de');
INSERT INTO model.property_i18n VALUES (79, 'P30', 'zh', '有保管标的物', '2019-12-12 17:08:42.016696', NULL, '被移转了保管作业於');
INSERT INTO model.property_i18n VALUES (80, 'P114', 'de', 'zeitgleich zu', '2019-12-12 17:08:42.016696', NULL, NULL);
INSERT INTO model.property_i18n VALUES (81, 'P114', 'en', 'is equal in time to', '2019-12-12 17:08:42.016696', NULL, NULL);
INSERT INTO model.property_i18n VALUES (82, 'P114', 'fr', 'est temporellement égale à', '2019-12-12 17:08:42.016696', NULL, NULL);
INSERT INTO model.property_i18n VALUES (83, 'P114', 'ru', 'равен по времени', '2019-12-12 17:08:42.016696', NULL, NULL);
INSERT INTO model.property_i18n VALUES (84, 'P114', 'el', 'συμπίπτει χρονικά με', '2019-12-12 17:08:42.016696', NULL, NULL);
INSERT INTO model.property_i18n VALUES (85, 'P114', 'pt', 'é temporalmente igual a', '2019-12-12 17:08:42.016696', NULL, NULL);
INSERT INTO model.property_i18n VALUES (86, 'P114', 'zh', '时段相同於', '2019-12-12 17:08:42.016696', NULL, NULL);
INSERT INTO model.property_i18n VALUES (87, 'P35', 'de', 'hat identifiziert', '2019-12-12 17:08:42.016696', NULL, 'wurde identifiziert durch');
INSERT INTO model.property_i18n VALUES (88, 'P35', 'en', 'has identified', '2019-12-12 17:08:42.016696', NULL, 'was identified by');
INSERT INTO model.property_i18n VALUES (89, 'P35', 'fr', 'a identifié', '2019-12-12 17:08:42.016696', NULL, 'est identifié par');
INSERT INTO model.property_i18n VALUES (90, 'P35', 'ru', 'идентифицировал', '2019-12-12 17:08:42.016696', NULL, 'идентифицирован посредством');
INSERT INTO model.property_i18n VALUES (91, 'P35', 'el', 'έχει διαπιστώσει', '2019-12-12 17:08:42.016696', NULL, 'έχει διαπιστωθεί από');
INSERT INTO model.property_i18n VALUES (92, 'P35', 'pt', 'identificou', '2019-12-12 17:08:42.016696', NULL, 'foi identificado por');
INSERT INTO model.property_i18n VALUES (93, 'P35', 'zh', '评估认定了', '2019-12-12 17:08:42.016696', NULL, '被评估认定於');
INSERT INTO model.property_i18n VALUES (94, 'P96', 'de', 'durch Mutter', '2019-12-12 17:08:42.016696', NULL, 'gebar');
INSERT INTO model.property_i18n VALUES (95, 'P96', 'en', 'by mother', '2019-12-12 17:08:42.016696', NULL, 'gave birth');
INSERT INTO model.property_i18n VALUES (96, 'P96', 'fr', 'de mère', '2019-12-12 17:08:42.016696', NULL, 'a donné naissance à');
INSERT INTO model.property_i18n VALUES (97, 'P96', 'ru', 'посредством матери', '2019-12-12 17:08:42.016696', NULL, 'дал рождение');
INSERT INTO model.property_i18n VALUES (98, 'P96', 'el', 'είχε μητέρα', '2019-12-12 17:08:42.016696', NULL, 'ήταν μητέρα του/της');
INSERT INTO model.property_i18n VALUES (99, 'P96', 'pt', 'pela mãe', '2019-12-12 17:08:42.016696', NULL, 'deu nascimento');
INSERT INTO model.property_i18n VALUES (100, 'P96', 'zh', '来自生母', '2019-12-12 17:08:42.016696', NULL, '成为生母於');
INSERT INTO model.property_i18n VALUES (101, 'P111', 'de', 'fügte hinzu', '2019-12-12 17:08:42.016696', NULL, 'wurde hinzugefügt durch');
INSERT INTO model.property_i18n VALUES (102, 'P111', 'en', 'added', '2019-12-12 17:08:42.016696', NULL, 'was added by');
INSERT INTO model.property_i18n VALUES (103, 'P111', 'fr', 'a ajouté', '2019-12-12 17:08:42.016696', NULL, 'a été ajouté par');
INSERT INTO model.property_i18n VALUES (104, 'P111', 'ru', 'добавил', '2019-12-12 17:08:42.016696', NULL, 'был добавлен посредством');
INSERT INTO model.property_i18n VALUES (105, 'P111', 'el', 'προσέθεσε', '2019-12-12 17:08:42.016696', NULL, 'προστέθηκε από');
INSERT INTO model.property_i18n VALUES (106, 'P111', 'pt', 'adicionou', '2019-12-12 17:08:42.016696', NULL, 'foi adicionado por');
INSERT INTO model.property_i18n VALUES (107, 'P111', 'zh', '附加上部件', '2019-12-12 17:08:42.016696', NULL, '被附加於');
INSERT INTO model.property_i18n VALUES (108, 'P121', 'de', 'überlappt mit', '2019-12-12 17:08:42.016696', NULL, NULL);
INSERT INTO model.property_i18n VALUES (109, 'P121', 'en', 'overlaps with', '2019-12-12 17:08:42.016696', NULL, NULL);
INSERT INTO model.property_i18n VALUES (110, 'P121', 'fr', 'chevauche', '2019-12-12 17:08:42.016696', NULL, NULL);
INSERT INTO model.property_i18n VALUES (111, 'P121', 'ru', 'пересекается с', '2019-12-12 17:08:42.016696', NULL, NULL);
INSERT INTO model.property_i18n VALUES (112, 'P121', 'el', 'επικαλύπτεται με', '2019-12-12 17:08:42.016696', NULL, NULL);
INSERT INTO model.property_i18n VALUES (113, 'P121', 'pt', 'sobrepõe com', '2019-12-12 17:08:42.016696', NULL, NULL);
INSERT INTO model.property_i18n VALUES (114, 'P121', 'zh', '空间重叠于', '2019-12-12 17:08:42.016696', NULL, NULL);
INSERT INTO model.property_i18n VALUES (115, 'P134', 'de', 'setzte sich fort in', '2019-12-12 17:08:42.016696', NULL, 'wurde fortgesetzt durch');
INSERT INTO model.property_i18n VALUES (116, 'P134', 'en', 'continued', '2019-12-12 17:08:42.016696', NULL, 'was continued by');
INSERT INTO model.property_i18n VALUES (117, 'P134', 'fr', 'est la suite de', '2019-12-12 17:08:42.016696', NULL, 'a été continuée par');
INSERT INTO model.property_i18n VALUES (118, 'P134', 'ru', 'продолжил', '2019-12-12 17:08:42.016696', NULL, 'был продолжен');
INSERT INTO model.property_i18n VALUES (119, 'P134', 'el', 'συνέχισε', '2019-12-12 17:08:42.016696', NULL, 'συνεχίστηκε από');
INSERT INTO model.property_i18n VALUES (120, 'P134', 'pt', 'continuou', '2019-12-12 17:08:42.016696', NULL, 'foi continuada por');
INSERT INTO model.property_i18n VALUES (121, 'P134', 'zh', '延续了', '2019-12-12 17:08:42.016696', NULL, '有延续活动');
INSERT INTO model.property_i18n VALUES (122, 'P4', 'de', 'hat Zeitspanne', '2019-12-12 17:08:42.016696', NULL, 'ist Zeitspanne von');
INSERT INTO model.property_i18n VALUES (123, 'P4', 'en', 'has time-span', '2019-12-12 17:08:42.016696', NULL, 'is time-span of');
INSERT INTO model.property_i18n VALUES (124, 'P4', 'fr', 'a pour durée', '2019-12-12 17:08:42.016696', NULL, 'est la durée de');
INSERT INTO model.property_i18n VALUES (125, 'P4', 'ru', 'имеет временной отрезок', '2019-12-12 17:08:42.016696', NULL, 'является временным отрезком для');
INSERT INTO model.property_i18n VALUES (126, 'P4', 'el', 'βρισκόταν σε εξέλιξη', '2019-12-12 17:08:42.016696', NULL, 'είναι χρονικό διάστημα του/της');
INSERT INTO model.property_i18n VALUES (127, 'P4', 'pt', 'tem período de tempo', '2019-12-12 17:08:42.016696', NULL, 'é o período de tempo de');
INSERT INTO model.property_i18n VALUES (128, 'P4', 'zh', '发生时段是', '2019-12-12 17:08:42.016696', NULL, '开始并完成了');
INSERT INTO model.property_i18n VALUES (129, 'P25', 'de', 'bewegte', '2019-12-12 17:08:42.016696', NULL, 'wurde bewegt durch');
INSERT INTO model.property_i18n VALUES (130, 'P25', 'en', 'moved', '2019-12-12 17:08:42.016696', NULL, 'moved by');
INSERT INTO model.property_i18n VALUES (131, 'P25', 'fr', 'a déplacé', '2019-12-12 17:08:42.016696', NULL, 'a été déplacé par');
INSERT INTO model.property_i18n VALUES (132, 'P25', 'ru', 'переместил', '2019-12-12 17:08:42.016696', NULL, 'перемещен посредством');
INSERT INTO model.property_i18n VALUES (133, 'P25', 'el', 'μετεκίνησε', '2019-12-12 17:08:42.016696', NULL, 'μετακινήθηκε από');
INSERT INTO model.property_i18n VALUES (134, 'P25', 'pt', 'locomoveu', '2019-12-12 17:08:42.016696', NULL, 'foi locomovido por');
INSERT INTO model.property_i18n VALUES (135, 'P25', 'zh', '移动了', '2019-12-12 17:08:42.016696', NULL, '被移动於');
INSERT INTO model.property_i18n VALUES (136, 'P104', 'de', 'Gegenstand von', '2019-12-12 17:08:42.016696', NULL, 'findet Anwendung auf');
INSERT INTO model.property_i18n VALUES (137, 'P104', 'en', 'is subject to', '2019-12-12 17:08:42.016696', NULL, 'applies to');
INSERT INTO model.property_i18n VALUES (138, 'P104', 'fr', 'est sujet à', '2019-12-12 17:08:42.016696', NULL, 's’applique à');
INSERT INTO model.property_i18n VALUES (139, 'P104', 'ru', 'является объектом для', '2019-12-12 17:08:42.016696', NULL, 'применяется к');
INSERT INTO model.property_i18n VALUES (140, 'P104', 'el', 'υπόκειται σε', '2019-12-12 17:08:42.016696', NULL, 'ισχύει για');
INSERT INTO model.property_i18n VALUES (141, 'P104', 'pt', 'está sujeito à', '2019-12-12 17:08:42.016696', NULL, 'se aplicam à');
INSERT INTO model.property_i18n VALUES (142, 'P104', 'zh', '受制於', '2019-12-12 17:08:42.016696', NULL, '被应用於');
INSERT INTO model.property_i18n VALUES (143, 'P56', 'de', 'trägt Merkmal', '2019-12-12 17:08:42.016696', NULL, 'wird gefunden auf');
INSERT INTO model.property_i18n VALUES (144, 'P56', 'en', 'bears feature', '2019-12-12 17:08:42.016696', NULL, 'is found on');
INSERT INTO model.property_i18n VALUES (145, 'P56', 'fr', 'présente pour caractéristique', '2019-12-12 17:08:42.016696', NULL, 'se trouve sur');
INSERT INTO model.property_i18n VALUES (146, 'P56', 'ru', 'несет признак', '2019-12-12 17:08:42.016696', NULL, 'найден на');
INSERT INTO model.property_i18n VALUES (147, 'P56', 'el', 'φέρει μόρφωμα', '2019-12-12 17:08:42.016696', NULL, 'βρίσκεται σε');
INSERT INTO model.property_i18n VALUES (148, 'P56', 'pt', 'possui característica', '2019-12-12 17:08:42.016696', NULL, 'é encontrada em');
INSERT INTO model.property_i18n VALUES (149, 'P56', 'zh', '有外貌表征', '2019-12-12 17:08:42.016696', NULL, '被见於');
INSERT INTO model.property_i18n VALUES (150, 'P119', 'de', 'trifft zeitlich auf', '2019-12-12 17:08:42.016696', NULL, 'wird zeitlich getroffen von');
INSERT INTO model.property_i18n VALUES (151, 'P119', 'en', 'meets in time with', '2019-12-12 17:08:42.016696', NULL, 'is met in time by');
INSERT INTO model.property_i18n VALUES (152, 'P119', 'fr', 'est temporellement contiguë avec', '2019-12-12 17:08:42.016696', NULL, 'est immédiatement précédé par');
INSERT INTO model.property_i18n VALUES (153, 'P119', 'ru', 'следует во времени за', '2019-12-12 17:08:42.016696', NULL, 'предшествует во времени');
INSERT INTO model.property_i18n VALUES (155, 'P119', 'pt', 'é temporalmente contíguo com', '2019-12-12 17:08:42.016696', NULL, 'é imediatamente precedido por');
INSERT INTO model.property_i18n VALUES (156, 'P119', 'zh', '紧接续了', '2019-12-12 17:08:42.016696', NULL, '紧接续於');
INSERT INTO model.property_i18n VALUES (157, 'P32', 'de', 'benutzte das allgemeine Verfahren', '2019-12-12 17:08:42.016696', NULL, 'war Verfahren von');
INSERT INTO model.property_i18n VALUES (158, 'P32', 'en', 'used general technique', '2019-12-12 17:08:42.016696', NULL, 'was technique of');
INSERT INTO model.property_i18n VALUES (159, 'P32', 'fr', 'a employé comme technique générique', '2019-12-12 17:08:42.016696', NULL, 'a été la technique mise en œuvre dans');
INSERT INTO model.property_i18n VALUES (160, 'P32', 'ru', 'использовал общую технику', '2019-12-12 17:08:42.016696', NULL, 'был техникой для');
INSERT INTO model.property_i18n VALUES (161, 'P32', 'el', 'χρησιμοποίησε γενική τεχνική', '2019-12-12 17:08:42.016696', NULL, 'ήταν τεχνική του/της');
INSERT INTO model.property_i18n VALUES (162, 'P32', 'pt', 'usou técnica geral', '2019-12-12 17:08:42.016696', NULL, 'foi técnica da');
INSERT INTO model.property_i18n VALUES (163, 'P32', 'zh', '使用通用技术', '2019-12-12 17:08:42.016696', NULL, '被使用於');
INSERT INTO model.property_i18n VALUES (164, 'P28', 'de', 'übergab Gewahrsam an', '2019-12-12 17:08:42.016696', NULL, 'wurde Gewahrsam übergeben durch');
INSERT INTO model.property_i18n VALUES (165, 'P28', 'en', 'custody surrendered by', '2019-12-12 17:08:42.016696', NULL, 'surrendered custody through');
INSERT INTO model.property_i18n VALUES (166, 'P28', 'fr', 'changement de détenteur au détriment de', '2019-12-12 17:08:42.016696', NULL, 'a cessé d’être détenteur à cause de');
INSERT INTO model.property_i18n VALUES (167, 'P28', 'ru', 'опека отдана', '2019-12-12 17:08:42.016696', NULL, 'опека отдана через');
INSERT INTO model.property_i18n VALUES (168, 'P28', 'el', 'μετεβίβασε κατοχή από', '2019-12-12 17:08:42.016696', NULL, 'παρέδωσε κατοχή μέσω');
INSERT INTO model.property_i18n VALUES (169, 'P28', 'pt', 'custódia concedida por', '2019-12-12 17:08:42.016696', NULL, 'final da custódia por meio de');
INSERT INTO model.property_i18n VALUES (170, 'P28', 'zh', '有原保管人', '2019-12-12 17:08:42.016696', NULL, '交出保管作业於');
INSERT INTO model.property_i18n VALUES (171, 'P34', 'de', 'betraf', '2019-12-12 17:08:42.016696', NULL, 'wurde beurteilt durch');
INSERT INTO model.property_i18n VALUES (172, 'P34', 'en', 'concerned', '2019-12-12 17:08:42.016696', NULL, 'was assessed by');
INSERT INTO model.property_i18n VALUES (173, 'P34', 'fr', 'a concerné', '2019-12-12 17:08:42.016696', NULL, 'expertisé par le biais de');
INSERT INTO model.property_i18n VALUES (174, 'P34', 'ru', 'имел дело с', '2019-12-12 17:08:42.016696', NULL, 'был оценен посредством');
INSERT INTO model.property_i18n VALUES (175, 'P34', 'el', 'αφορούσε σε', '2019-12-12 17:08:42.016696', NULL, 'εκτιμήθηκε από');
INSERT INTO model.property_i18n VALUES (176, 'P34', 'pt', 'interessada', '2019-12-12 17:08:42.016696', NULL, 'foi avaliada por');
INSERT INTO model.property_i18n VALUES (177, 'P34', 'zh', '评估了', '2019-12-12 17:08:42.016696', NULL, '被评估於');
INSERT INTO model.property_i18n VALUES (178, 'P1', 'de', 'wird bezeichnet als', '2019-12-12 17:08:42.016696', NULL, 'bezeichnet');
INSERT INTO model.property_i18n VALUES (179, 'P1', 'en', 'is identified by', '2019-12-12 17:08:42.016696', NULL, 'identifies');
INSERT INTO model.property_i18n VALUES (180, 'P1', 'fr', 'est identifiée par', '2019-12-12 17:08:42.016696', NULL, 'identifie');
INSERT INTO model.property_i18n VALUES (181, 'P1', 'ru', 'идентифицируется посредством', '2019-12-12 17:08:42.016696', NULL, 'идентифицирует');
INSERT INTO model.property_i18n VALUES (182, 'P1', 'el', 'αναγνωρίζεται ως', '2019-12-12 17:08:42.016696', NULL, 'είναι αναγνωριστικό');
INSERT INTO model.property_i18n VALUES (183, 'P1', 'pt', 'é identificado por', '2019-12-12 17:08:42.016696', NULL, 'identifica');
INSERT INTO model.property_i18n VALUES (184, 'P1', 'zh', '有识别称号', '2019-12-12 17:08:42.016696', NULL, '被用来识别');
INSERT INTO model.property_i18n VALUES (185, 'P41', 'de', 'klassifizierte', '2019-12-12 17:08:42.016696', NULL, 'wurde klassifiziert durch');
INSERT INTO model.property_i18n VALUES (186, 'P41', 'en', 'classified', '2019-12-12 17:08:42.016696', NULL, 'was classified by');
INSERT INTO model.property_i18n VALUES (187, 'P41', 'fr', 'a classifié', '2019-12-12 17:08:42.016696', NULL, 'a été classifiée par le biais de');
INSERT INTO model.property_i18n VALUES (188, 'P41', 'ru', 'классифицировал', '2019-12-12 17:08:42.016696', NULL, 'был классифицирован посредством');
INSERT INTO model.property_i18n VALUES (189, 'P41', 'el', 'χαρακτήρισε', '2019-12-12 17:08:42.016696', NULL, 'χαρακτηρίσθηκε από');
INSERT INTO model.property_i18n VALUES (190, 'P41', 'pt', 'classificou', '2019-12-12 17:08:42.016696', NULL, 'foi classificada por');
INSERT INTO model.property_i18n VALUES (191, 'P41', 'zh', '分类了', '2019-12-12 17:08:42.016696', NULL, '被分类於');
INSERT INTO model.property_i18n VALUES (192, 'P20', 'de', 'hatte den bestimmten Zweck', '2019-12-12 17:08:42.016696', NULL, 'war Zweck von');
INSERT INTO model.property_i18n VALUES (193, 'P20', 'en', 'had specific purpose', '2019-12-12 17:08:42.016696', NULL, 'was purpose of');
INSERT INTO model.property_i18n VALUES (194, 'P20', 'fr', 'avait pour but spécifique', '2019-12-12 17:08:42.016696', NULL, 'était le but de');
INSERT INTO model.property_i18n VALUES (195, 'P20', 'ru', 'имел конкретную цель', '2019-12-12 17:08:42.016696', NULL, 'был целью для');
INSERT INTO model.property_i18n VALUES (196, 'P20', 'el', 'είχε συγκεκριμένο σκοπό', '2019-12-12 17:08:42.016696', NULL, 'ήταν σκοπός του/της');
INSERT INTO model.property_i18n VALUES (197, 'P20', 'pt', 'tinha propósito específico', '2019-12-12 17:08:42.016696', NULL, 'era o propósito de');
INSERT INTO model.property_i18n VALUES (198, 'P20', 'zh', '有特定目地', '2019-12-12 17:08:42.016696', NULL, '之準備活動是');
INSERT INTO model.property_i18n VALUES (199, 'P91', 'de', 'hat Einheit', '2019-12-12 17:08:42.016696', NULL, 'ist Einheit von');
INSERT INTO model.property_i18n VALUES (200, 'P91', 'en', 'has unit', '2019-12-12 17:08:42.016696', NULL, 'is unit of');
INSERT INTO model.property_i18n VALUES (201, 'P91', 'fr', 'a pour unité', '2019-12-12 17:08:42.016696', NULL, 'est l''unité de');
INSERT INTO model.property_i18n VALUES (202, 'P91', 'ru', 'имеет единицу', '2019-12-12 17:08:42.016696', NULL, 'является единицей для');
INSERT INTO model.property_i18n VALUES (203, 'P91', 'el', 'έχει μονάδα μέτρησης', '2019-12-12 17:08:42.016696', NULL, 'αποτελεί μονάδα μέτρησης του/της');
INSERT INTO model.property_i18n VALUES (204, 'P91', 'pt', 'tem unidade', '2019-12-12 17:08:42.016696', NULL, 'é unidade de');
INSERT INTO model.property_i18n VALUES (205, 'P91', 'zh', '有单位', '2019-12-12 17:08:42.016696', NULL, '被当做单位来表示');
INSERT INTO model.property_i18n VALUES (206, 'P42', 'de', 'wies zu', '2019-12-12 17:08:42.016696', NULL, 'wurde zugewiesen durch');
INSERT INTO model.property_i18n VALUES (207, 'P42', 'en', 'assigned', '2019-12-12 17:08:42.016696', NULL, 'was assigned by');
INSERT INTO model.property_i18n VALUES (208, 'P42', 'fr', 'a attribué', '2019-12-12 17:08:42.016696', NULL, 'a été attribué par');
INSERT INTO model.property_i18n VALUES (209, 'P42', 'ru', 'назначил', '2019-12-12 17:08:42.016696', NULL, 'был присвоен посредством');
INSERT INTO model.property_i18n VALUES (210, 'P42', 'el', 'απέδωσε ως ιδιότητα', '2019-12-12 17:08:42.016696', NULL, 'αποδόθηκε από');
INSERT INTO model.property_i18n VALUES (211, 'P42', 'pt', 'atribuiu', '2019-12-12 17:08:42.016696', NULL, 'foi atribuído por');
INSERT INTO model.property_i18n VALUES (212, 'P42', 'zh', '指定类型为', '2019-12-12 17:08:42.016696', NULL, '被指定类型於');
INSERT INTO model.property_i18n VALUES (213, 'P107', 'de', 'hat derzeitiges oder früheres Mitglied', '2019-12-12 17:08:42.016696', NULL, 'ist derzeitiges oder früheres Mitglied von');
INSERT INTO model.property_i18n VALUES (214, 'P107', 'en', 'has current or former member', '2019-12-12 17:08:42.016696', NULL, 'is current or former member of');
INSERT INTO model.property_i18n VALUES (215, 'P107', 'fr', 'a pour membre actuel ou ancien', '2019-12-12 17:08:42.016696', NULL, 'est actuel ou ancien membre de');
INSERT INTO model.property_i18n VALUES (216, 'P107', 'ru', 'имеет действующего или бывшего члена', '2019-12-12 17:08:42.016696', NULL, 'является действующим или бывшим членом');
INSERT INTO model.property_i18n VALUES (217, 'P107', 'el', 'έχει ή είχε μέλος', '2019-12-12 17:08:42.016696', NULL, 'είναι ή ήταν μέλος του/της');
INSERT INTO model.property_i18n VALUES (218, 'P107', 'pt', 'tem ou teve membro', '2019-12-12 17:08:42.016696', NULL, 'é ou foi membro de');
INSERT INTO model.property_i18n VALUES (219, 'P107', 'zh', '有现任或前任成员', '2019-12-12 17:08:42.016696', NULL, '目前或曾经加入群组');
INSERT INTO model.property_i18n VALUES (220, 'P75', 'de', 'besitzt', '2019-12-12 17:08:42.016696', NULL, 'sind im Besitz von');
INSERT INTO model.property_i18n VALUES (221, 'P75', 'en', 'possesses', '2019-12-12 17:08:42.016696', NULL, 'is possessed by');
INSERT INTO model.property_i18n VALUES (222, 'P75', 'fr', 'est détenteur de', '2019-12-12 17:08:42.016696', NULL, 'est détenu par');
INSERT INTO model.property_i18n VALUES (223, 'P75', 'ru', 'владеет', '2019-12-12 17:08:42.016696', NULL, 'принадлежит');
INSERT INTO model.property_i18n VALUES (224, 'P75', 'el', 'κατέχει', '2019-12-12 17:08:42.016696', NULL, 'κατέχεται από');
INSERT INTO model.property_i18n VALUES (225, 'P75', 'pt', 'é detentor de', '2019-12-12 17:08:42.016696', NULL, 'são detidos por');
INSERT INTO model.property_i18n VALUES (226, 'P75', 'zh', '拥有', '2019-12-12 17:08:42.016696', NULL, '有拥有者');
INSERT INTO model.property_i18n VALUES (227, 'P62', 'de', 'bildet ab', '2019-12-12 17:08:42.016696', NULL, 'wird abgebildet durch');
INSERT INTO model.property_i18n VALUES (228, 'P62', 'en', 'depicts', '2019-12-12 17:08:42.016696', NULL, 'is depicted by');
INSERT INTO model.property_i18n VALUES (229, 'P62', 'fr', 'figure', '2019-12-12 17:08:42.016696', NULL, 'est figurée sur');
INSERT INTO model.property_i18n VALUES (230, 'P62', 'ru', 'описывает', '2019-12-12 17:08:42.016696', NULL, 'описан посредством');
INSERT INTO model.property_i18n VALUES (231, 'P62', 'el', 'απεικονίζει', '2019-12-12 17:08:42.016696', NULL, 'απεικονίζεται σε');
INSERT INTO model.property_i18n VALUES (232, 'P62', 'pt', 'retrata', '2019-12-12 17:08:42.016696', NULL, 'é retratada por');
INSERT INTO model.property_i18n VALUES (233, 'P62', 'zh', '描绘', '2019-12-12 17:08:42.016696', NULL, '被描绘於');
INSERT INTO model.property_i18n VALUES (234, 'P99', 'de', 'löste auf', '2019-12-12 17:08:42.016696', NULL, 'wurde aufgelöst durch');
INSERT INTO model.property_i18n VALUES (235, 'P99', 'en', 'dissolved', '2019-12-12 17:08:42.016696', NULL, 'was dissolved by');
INSERT INTO model.property_i18n VALUES (236, 'P99', 'fr', 'a dissous', '2019-12-12 17:08:42.016696', NULL, 'a été dissous par');
INSERT INTO model.property_i18n VALUES (237, 'P99', 'ru', 'распустил', '2019-12-12 17:08:42.016696', NULL, 'был распущен посредством');
INSERT INTO model.property_i18n VALUES (238, 'P99', 'el', 'διέλυσε', '2019-12-12 17:08:42.016696', NULL, 'διαλύθηκε από');
INSERT INTO model.property_i18n VALUES (239, 'P99', 'pt', 'dissolveu', '2019-12-12 17:08:42.016696', NULL, 'foi dissolvido por');
INSERT INTO model.property_i18n VALUES (240, 'P99', 'zh', '解散了', '2019-12-12 17:08:42.016696', NULL, '被解散於');
INSERT INTO model.property_i18n VALUES (241, 'P129', 'de', 'handelt über', '2019-12-12 17:08:42.016696', NULL, 'wird behandelt in');
INSERT INTO model.property_i18n VALUES (242, 'P129', 'en', 'is about', '2019-12-12 17:08:42.016696', NULL, 'is subject of');
INSERT INTO model.property_i18n VALUES (243, 'P129', 'fr', 'est au sujet de', '2019-12-12 17:08:42.016696', NULL, 'est le sujet de');
INSERT INTO model.property_i18n VALUES (244, 'P129', 'ru', 'касается', '2019-12-12 17:08:42.016696', NULL, 'является предметом для');
INSERT INTO model.property_i18n VALUES (245, 'P129', 'el', 'έχει ως θέμα', '2019-12-12 17:08:42.016696', NULL, 'είναι θέμα  του/της');
INSERT INTO model.property_i18n VALUES (246, 'P129', 'pt', 'é sobre', '2019-12-12 17:08:42.016696', NULL, 'é assunto de');
INSERT INTO model.property_i18n VALUES (247, 'P129', 'zh', '陈述关於', '2019-12-12 17:08:42.016696', NULL, '被陈述於');
INSERT INTO model.property_i18n VALUES (248, 'P65', 'de', 'zeigt Bildliches', '2019-12-12 17:08:42.016696', NULL, 'wird gezeigt durch');
INSERT INTO model.property_i18n VALUES (249, 'P65', 'en', 'shows visual item', '2019-12-12 17:08:42.016696', NULL, 'is shown by');
INSERT INTO model.property_i18n VALUES (250, 'P65', 'fr', 'présente l''item visuel', '2019-12-12 17:08:42.016696', NULL, 'est présenté par');
INSERT INTO model.property_i18n VALUES (251, 'P65', 'ru', 'показывает визуальный предмет', '2019-12-12 17:08:42.016696', NULL, 'показан посредством');
INSERT INTO model.property_i18n VALUES (252, 'P65', 'el', 'εμφανίζει οπτικό στοιχείο', '2019-12-12 17:08:42.016696', NULL, 'εμφανίζεται σε');
INSERT INTO model.property_i18n VALUES (253, 'P65', 'pt', 'apresenta item visual', '2019-12-12 17:08:42.016696', NULL, 'é apresentado por');
INSERT INTO model.property_i18n VALUES (254, 'P65', 'zh', '显示视觉项目', '2019-12-12 17:08:42.016696', NULL, '被显示於');
INSERT INTO model.property_i18n VALUES (255, 'P116', 'de', 'beginnt', '2019-12-12 17:08:42.016696', NULL, 'wurde begonnen mit');
INSERT INTO model.property_i18n VALUES (256, 'P116', 'en', 'starts', '2019-12-12 17:08:42.016696', NULL, 'is started by');
INSERT INTO model.property_i18n VALUES (257, 'P116', 'fr', 'commence', '2019-12-12 17:08:42.016696', NULL, 'est commencée par');
INSERT INTO model.property_i18n VALUES (258, 'P116', 'ru', 'начинает', '2019-12-12 17:08:42.016696', NULL, 'начинается');
INSERT INTO model.property_i18n VALUES (259, 'P116', 'el', 'αρχίζει', '2019-12-12 17:08:42.016696', NULL, 'αρχίζει με');
INSERT INTO model.property_i18n VALUES (260, 'P116', 'pt', 'inicia', '2019-12-12 17:08:42.016696', NULL, 'é iniciada por');
INSERT INTO model.property_i18n VALUES (261, 'P116', 'zh', '开始了', '2019-12-12 17:08:42.016696', NULL, '被开始于');
INSERT INTO model.property_i18n VALUES (262, 'P55', 'de', 'hat derzeitigen Standort', '2019-12-12 17:08:42.016696', NULL, 'hält derzeitig');
INSERT INTO model.property_i18n VALUES (263, 'P55', 'en', 'has current location', '2019-12-12 17:08:42.016696', NULL, 'currently holds');
INSERT INTO model.property_i18n VALUES (264, 'P55', 'fr', 'a pour localisation actuelle', '2019-12-12 17:08:42.016696', NULL, 'est localisation actuelle de');
INSERT INTO model.property_i18n VALUES (265, 'P55', 'ru', 'в данный момент находится в', '2019-12-12 17:08:42.016696', NULL, 'в данный момент содержит');
INSERT INTO model.property_i18n VALUES (266, 'P55', 'el', 'βρίσκεται σε', '2019-12-12 17:08:42.016696', NULL, 'είναι θέση του');
INSERT INTO model.property_i18n VALUES (267, 'P55', 'pt', 'é localizado em', '2019-12-12 17:08:42.016696', NULL, 'é localização atual de');
INSERT INTO model.property_i18n VALUES (268, 'P55', 'zh', '目前被置放於', '2019-12-12 17:08:42.016696', NULL, '目前置放了');
INSERT INTO model.property_i18n VALUES (269, 'P14', 'de', 'wurde ausgeführt von', '2019-12-12 17:08:42.016696', NULL, 'führte aus');
INSERT INTO model.property_i18n VALUES (270, 'P14', 'en', 'carried out by', '2019-12-12 17:08:42.016696', NULL, 'performed');
INSERT INTO model.property_i18n VALUES (271, 'P14', 'fr', 'réalisée par', '2019-12-12 17:08:42.016696', NULL, 'a exécuté');
INSERT INTO model.property_i18n VALUES (272, 'P14', 'ru', 'выполнялся', '2019-12-12 17:08:42.016696', NULL, 'выполнял');
INSERT INTO model.property_i18n VALUES (273, 'P14', 'el', 'πραγματοποιήθηκε από', '2019-12-12 17:08:42.016696', NULL, 'πραγματοποίησε');
INSERT INTO model.property_i18n VALUES (274, 'P14', 'pt', 'realizada por', '2019-12-12 17:08:42.016696', NULL, 'executou');
INSERT INTO model.property_i18n VALUES (275, 'P14', 'zh', '有执行者', '2019-12-12 17:08:42.016696', NULL, '执行了');
INSERT INTO model.property_i18n VALUES (276, 'P136', 'de', 'stützte sich auf', '2019-12-12 17:08:42.016696', NULL, 'belegte');
INSERT INTO model.property_i18n VALUES (277, 'P136', 'en', 'was based on', '2019-12-12 17:08:42.016696', NULL, 'supported type creation');
INSERT INTO model.property_i18n VALUES (278, 'P136', 'fr', 's’est fondée sur', '2019-12-12 17:08:42.016696', NULL, 'a justifié la création de type');
INSERT INTO model.property_i18n VALUES (279, 'P136', 'ru', 'был основан на', '2019-12-12 17:08:42.016696', NULL, 'поддержал создание типа');
INSERT INTO model.property_i18n VALUES (280, 'P136', 'el', 'βασίστηκε σε', '2019-12-12 17:08:42.016696', NULL, 'υποστήριξε τη δημιουργία τύπου');
INSERT INTO model.property_i18n VALUES (281, 'P136', 'pt', 'foi baseado em', '2019-12-12 17:08:42.016696', NULL, 'suportou a criação de tipo');
INSERT INTO model.property_i18n VALUES (282, 'P136', 'zh', '根据了', '2019-12-12 17:08:42.016696', NULL, '提供證據给类型创造');
INSERT INTO model.property_i18n VALUES (283, 'P68', 'de', ' sieht den Gebrauch vor von', '2019-12-12 17:08:42.016696', NULL, 'vorgesehen für Gebrauch durch defined');
INSERT INTO model.property_i18n VALUES (284, 'P68', 'en', 'foresees use of', '2019-12-12 17:08:42.016696', NULL, 'use foreseen by');
INSERT INTO model.property_i18n VALUES (285, 'P68', 'fr', 'utilise habituellement', '2019-12-12 17:08:42.016696', NULL, 'est habituellement utilisé par');
INSERT INTO model.property_i18n VALUES (286, 'P68', 'ru', 'обычно применяет', '2019-12-12 17:08:42.016696', NULL, 'обычно используется посредством');
INSERT INTO model.property_i18n VALUES (287, 'P68', 'el', 'συνήθως χρησιμοποιεί', '2019-12-12 17:08:42.016696', NULL, 'συνήθως χρησιμοποιείται από');
INSERT INTO model.property_i18n VALUES (288, 'P68', 'pt', 'normalmente emprega', '2019-12-12 17:08:42.016696', NULL, 'é empregado por');
INSERT INTO model.property_i18n VALUES (289, 'P68', 'zh', '指定使用材料', '2019-12-12 17:08:42.016696', NULL, '被指定使用於');
INSERT INTO model.property_i18n VALUES (290, 'P92', 'de', 'brachte in Existenz', '2019-12-12 17:08:42.016696', NULL, 'wurde in Existenz gebracht durch');
INSERT INTO model.property_i18n VALUES (291, 'P92', 'en', 'brought into existence', '2019-12-12 17:08:42.016696', NULL, 'was brought into existence by');
INSERT INTO model.property_i18n VALUES (292, 'P92', 'fr', 'a fait exister', '2019-12-12 17:08:42.016696', NULL, 'a commencé à exister du fait de');
INSERT INTO model.property_i18n VALUES (293, 'P92', 'ru', 'создал', '2019-12-12 17:08:42.016696', NULL, 'был создан посредством');
INSERT INTO model.property_i18n VALUES (294, 'P92', 'el', 'γέννησε', '2019-12-12 17:08:42.016696', NULL, 'γεννήθηκε από');
INSERT INTO model.property_i18n VALUES (295, 'P92', 'pt', 'trouxe à existência', '2019-12-12 17:08:42.016696', NULL, 'passou a existir por');
INSERT INTO model.property_i18n VALUES (296, 'P92', 'zh', '开始了', '2019-12-12 17:08:42.016696', NULL, '被开始於');
INSERT INTO model.property_i18n VALUES (297, 'P7', 'de', 'fand statt in', '2019-12-12 17:08:42.016696', NULL, 'bezeugte');
INSERT INTO model.property_i18n VALUES (298, 'P7', 'en', 'took place at', '2019-12-12 17:08:42.016696', NULL, 'witnessed');
INSERT INTO model.property_i18n VALUES (299, 'P7', 'fr', 'a eu lieu dans', '2019-12-12 17:08:42.016696', NULL, 'a été témoin de');
INSERT INTO model.property_i18n VALUES (300, 'P7', 'ru', 'совершался на', '2019-12-12 17:08:42.016696', NULL, 'был местом совершения');
INSERT INTO model.property_i18n VALUES (301, 'P7', 'el', 'έλαβε χώρα σε', '2019-12-12 17:08:42.016696', NULL, 'υπήρξε τόπος του');
INSERT INTO model.property_i18n VALUES (302, 'P7', 'pt', 'ocorreu em', '2019-12-12 17:08:42.016696', NULL, 'testemunhou');
INSERT INTO model.property_i18n VALUES (303, 'P7', 'zh', '发生地在', '2019-12-12 17:08:42.016696', NULL, '发生过');
INSERT INTO model.property_i18n VALUES (304, 'P78', 'de', 'wird bezeichnet als', '2019-12-12 17:08:42.016696', NULL, 'bezeichnet');
INSERT INTO model.property_i18n VALUES (305, 'P78', 'en', 'is identified by', '2019-12-12 17:08:42.016696', NULL, 'identifies');
INSERT INTO model.property_i18n VALUES (306, 'P78', 'fr', 'est identifiée par', '2019-12-12 17:08:42.016696', NULL, 'identifie');
INSERT INTO model.property_i18n VALUES (307, 'P78', 'ru', 'идентифицируется посредством', '2019-12-12 17:08:42.016696', NULL, 'идентифицирует');
INSERT INTO model.property_i18n VALUES (308, 'P78', 'el', 'αναγνωρίζεται ως', '2019-12-12 17:08:42.016696', NULL, 'είναι αναγνωριστικό');
INSERT INTO model.property_i18n VALUES (309, 'P78', 'pt', 'é identificado por ', '2019-12-12 17:08:42.016696', NULL, 'identifica');
INSERT INTO model.property_i18n VALUES (310, 'P78', 'zh', '有识别称号', '2019-12-12 17:08:42.016696', NULL, '被用来识别');
INSERT INTO model.property_i18n VALUES (311, 'P16', 'de', 'benutzte das bestimmte Objekt', '2019-12-12 17:08:42.016696', NULL, 'wurde benutzt für');
INSERT INTO model.property_i18n VALUES (312, 'P16', 'en', 'used specific object', '2019-12-12 17:08:42.016696', NULL, 'was used for');
INSERT INTO model.property_i18n VALUES (313, 'P16', 'fr', 'a utilisé l''objet spécifique', '2019-12-12 17:08:42.016696', NULL, 'a été utilisé pour');
INSERT INTO model.property_i18n VALUES (314, 'P16', 'ru', 'использовал особый объект', '2019-12-12 17:08:42.016696', NULL, 'был использован для');
INSERT INTO model.property_i18n VALUES (315, 'P16', 'el', 'χρησιμοποίησε αντικείμενο', '2019-12-12 17:08:42.016696', NULL, 'χρησιμοποιήθηκε για');
INSERT INTO model.property_i18n VALUES (316, 'P16', 'pt', 'usou objeto específico', '2019-12-12 17:08:42.016696', NULL, 'foi usado por');
INSERT INTO model.property_i18n VALUES (317, 'P16', 'zh', '使用特定物', '2019-12-12 17:08:42.016696', NULL, '被用於');
INSERT INTO model.property_i18n VALUES (318, 'P161', 'en', 'has spatial projection', '2019-12-12 17:08:42.016696', NULL, 'is spatial projection of');
INSERT INTO model.property_i18n VALUES (319, 'P87', 'de', 'wird bezeichnet als', '2019-12-12 17:08:42.016696', NULL, 'bezeichnet');
INSERT INTO model.property_i18n VALUES (320, 'P87', 'en', 'is identified by', '2019-12-12 17:08:42.016696', NULL, 'identifies');
INSERT INTO model.property_i18n VALUES (321, 'P87', 'fr', 'est identifié par', '2019-12-12 17:08:42.016696', NULL, 'identifie');
INSERT INTO model.property_i18n VALUES (322, 'P87', 'ru', 'идентифицируется посредством', '2019-12-12 17:08:42.016696', NULL, 'идентифицирует');
INSERT INTO model.property_i18n VALUES (323, 'P87', 'el', 'αναγνωρίζεται ως', '2019-12-12 17:08:42.016696', NULL, 'είναι αναγνωριστικό');
INSERT INTO model.property_i18n VALUES (324, 'P87', 'pt', 'é identificado por', '2019-12-12 17:08:42.016696', NULL, 'identifica');
INSERT INTO model.property_i18n VALUES (325, 'P87', 'zh', '有辨认码', '2019-12-12 17:08:42.016696', NULL, '被用来辨认');
INSERT INTO model.property_i18n VALUES (326, 'P51', 'de', 'hat früheren oder derzeitigen Besitzer ', '2019-12-12 17:08:42.016696', NULL, 'ist früherer oder derzeitiger Besitzer von');
INSERT INTO model.property_i18n VALUES (327, 'P51', 'en', 'has former or current owner', '2019-12-12 17:08:42.016696', NULL, 'is former or current owner of');
INSERT INTO model.property_i18n VALUES (328, 'P51', 'fr', 'est ou a été possédée par', '2019-12-12 17:08:42.016696', NULL, 'est ou a été propriétaire de');
INSERT INTO model.property_i18n VALUES (329, 'P51', 'ru', 'имеет бывшего или текущего владельца', '2019-12-12 17:08:42.016696', NULL, 'является бывшим или текущим владельцем для');
INSERT INTO model.property_i18n VALUES (330, 'P51', 'el', 'έχει ή είχε ιδιοκτήτη', '2019-12-12 17:08:42.016696', NULL, 'είναι ή ήταν ιδιοκτήτης του/της');
INSERT INTO model.property_i18n VALUES (331, 'P51', 'pt', 'é ou foi propriedade de', '2019-12-12 17:08:42.016696', NULL, 'é ou foi proprietário de');
INSERT INTO model.property_i18n VALUES (332, 'P51', 'zh', '有前任或现任物主', '2019-12-12 17:08:42.016696', NULL, '目前或曾经拥有');
INSERT INTO model.property_i18n VALUES (333, 'P67', 'de', 'verweist auf', '2019-12-12 17:08:42.016696', NULL, 'wird angeführt von');
INSERT INTO model.property_i18n VALUES (334, 'P67', 'en', 'refers to', '2019-12-12 17:08:42.016696', NULL, 'is referred to by');
INSERT INTO model.property_i18n VALUES (335, 'P67', 'fr', 'fait référence à', '2019-12-12 17:08:42.016696', NULL, 'est référencé par');
INSERT INTO model.property_i18n VALUES (336, 'P67', 'ru', 'ссылается на', '2019-12-12 17:08:42.016696', NULL, 'имеет ссылку на себя от');
INSERT INTO model.property_i18n VALUES (337, 'P67', 'el', 'αναφέρεται σε', '2019-12-12 17:08:42.016696', NULL, 'αναφέρεται από');
INSERT INTO model.property_i18n VALUES (338, 'P67', 'pt', 'referencia', '2019-12-12 17:08:42.016696', NULL, 'é referenciado por');
INSERT INTO model.property_i18n VALUES (339, 'P67', 'zh', '论及', '2019-12-12 17:08:42.016696', NULL, '被论及於');
INSERT INTO model.property_i18n VALUES (340, 'P108', 'de', 'hat hergestellt', '2019-12-12 17:08:42.016696', NULL, 'wurde hergestellt durch');
INSERT INTO model.property_i18n VALUES (341, 'P108', 'en', 'has produced', '2019-12-12 17:08:42.016696', NULL, 'was produced by');
INSERT INTO model.property_i18n VALUES (342, 'P108', 'fr', 'a produit', '2019-12-12 17:08:42.016696', NULL, 'a été produit par');
INSERT INTO model.property_i18n VALUES (343, 'P108', 'ru', 'произвел', '2019-12-12 17:08:42.016696', NULL, 'был произведен посредством');
INSERT INTO model.property_i18n VALUES (344, 'P108', 'el', 'παρήγαγε', '2019-12-12 17:08:42.016696', NULL, 'παρήχθη από');
INSERT INTO model.property_i18n VALUES (345, 'P108', 'pt', 'produziu', '2019-12-12 17:08:42.016696', NULL, 'foi produzido por');
INSERT INTO model.property_i18n VALUES (346, 'P108', 'zh', '有产出物', '2019-12-12 17:08:42.016696', NULL, '被制作於');
INSERT INTO model.property_i18n VALUES (347, 'P58', 'de', 'hat Abschittsdefinition', '2019-12-12 17:08:42.016696', NULL, 'definiert Abschitt auf oder von');
INSERT INTO model.property_i18n VALUES (348, 'P58', 'en', 'has section definition', '2019-12-12 17:08:42.016696', NULL, 'defines section');
INSERT INTO model.property_i18n VALUES (349, 'P58', 'fr', 'a pour désignation de section', '2019-12-12 17:08:42.016696', NULL, 'définit une section de');
INSERT INTO model.property_i18n VALUES (350, 'P58', 'ru', 'имеет определение района', '2019-12-12 17:08:42.016696', NULL, 'определяет район');
INSERT INTO model.property_i18n VALUES (351, 'P58', 'el', 'έχει ορισμό τμήματος', '2019-12-12 17:08:42.016696', NULL, 'ορίζει τμήμα σε');
INSERT INTO model.property_i18n VALUES (352, 'P58', 'pt', 'tem designação de seção', '2019-12-12 17:08:42.016696', NULL, 'define uma seção de');
INSERT INTO model.property_i18n VALUES (353, 'P58', 'zh', '有区域定义', '2019-12-12 17:08:42.016696', NULL, '界定了区域於');
INSERT INTO model.property_i18n VALUES (354, 'P100', 'de', 'Tod von', '2019-12-12 17:08:42.016696', NULL, 'starb in');
INSERT INTO model.property_i18n VALUES (355, 'P100', 'en', 'was death of', '2019-12-12 17:08:42.016696', NULL, 'died in');
INSERT INTO model.property_i18n VALUES (356, 'P100', 'fr', 'a été la mort de', '2019-12-12 17:08:42.016696', NULL, 'est mort par');
INSERT INTO model.property_i18n VALUES (357, 'P100', 'ru', 'был смертью для', '2019-12-12 17:08:42.016696', NULL, 'умер в');
INSERT INTO model.property_i18n VALUES (358, 'P100', 'el', 'ήταν θάνατος του/της', '2019-12-12 17:08:42.016696', NULL, 'πέθανε σε');
INSERT INTO model.property_i18n VALUES (359, 'P100', 'pt', 'foi a morte para ', '2019-12-12 17:08:42.016696', NULL, 'morreu em');
INSERT INTO model.property_i18n VALUES (360, 'P100', 'zh', '灭亡了', '2019-12-12 17:08:42.016696', NULL, '死亡於');
INSERT INTO model.property_i18n VALUES (361, 'P150', 'en', 'defines typical parts of', '2019-12-12 17:08:42.016696', NULL, 'defines typical wholes for');
INSERT INTO model.property_i18n VALUES (362, 'P133', 'de', 'getrennt von', '2019-12-12 17:08:42.016696', NULL, NULL);
INSERT INTO model.property_i18n VALUES (363, 'P133', 'en', 'is separated from', '2019-12-12 17:08:42.016696', NULL, NULL);
INSERT INTO model.property_i18n VALUES (364, 'P133', 'fr', 'est séparée de', '2019-12-12 17:08:42.016696', NULL, NULL);
INSERT INTO model.property_i18n VALUES (365, 'P133', 'ru', 'отделен от', '2019-12-12 17:08:42.016696', NULL, NULL);
INSERT INTO model.property_i18n VALUES (366, 'P133', 'el', 'διαχωρίζεται από', '2019-12-12 17:08:42.016696', NULL, NULL);
INSERT INTO model.property_i18n VALUES (367, 'P133', 'pt', 'é separado de', '2019-12-12 17:08:42.016696', NULL, NULL);
INSERT INTO model.property_i18n VALUES (368, 'P133', 'zh', '时空不重叠于', '2019-12-12 17:08:42.016696', NULL, NULL);
INSERT INTO model.property_i18n VALUES (369, 'P105', 'de', 'Rechte stehen zu', '2019-12-12 17:08:42.016696', NULL, 'hat Rechte an');
INSERT INTO model.property_i18n VALUES (370, 'P105', 'en', 'right held by', '2019-12-12 17:08:42.016696', NULL, 'has right on');
INSERT INTO model.property_i18n VALUES (371, 'P105', 'fr', 'droit détenu par', '2019-12-12 17:08:42.016696', NULL, 'détient un droit sur');
INSERT INTO model.property_i18n VALUES (372, 'P105', 'ru', 'право принадлежит', '2019-12-12 17:08:42.016696', NULL, 'владеет правом на');
INSERT INTO model.property_i18n VALUES (373, 'P105', 'el', 'δικαίωμα κατέχεται από', '2019-12-12 17:08:42.016696', NULL, 'έχει δικαίωμα σε');
INSERT INTO model.property_i18n VALUES (374, 'P105', 'pt', 'são direitos de ', '2019-12-12 17:08:42.016696', NULL, 'possui direitos sobre');
INSERT INTO model.property_i18n VALUES (375, 'P105', 'zh', '有权限持有者', '2019-12-12 17:08:42.016696', NULL, '持有权限来管制');
INSERT INTO model.property_i18n VALUES (376, 'P44', 'de', 'hat Zustand', '2019-12-12 17:08:42.016696', NULL, 'ist Zustand von');
INSERT INTO model.property_i18n VALUES (377, 'P44', 'en', 'has condition', '2019-12-12 17:08:42.016696', NULL, 'is condition of');
INSERT INTO model.property_i18n VALUES (378, 'P44', 'fr', 'a pour état matériel', '2019-12-12 17:08:42.016696', NULL, 'état matériel de');
INSERT INTO model.property_i18n VALUES (379, 'P44', 'ru', 'имеет условие', '2019-12-12 17:08:42.016696', NULL, 'является условием для');
INSERT INTO model.property_i18n VALUES (380, 'P44', 'el', 'έχει κατάσταση', '2019-12-12 17:08:42.016696', NULL, 'είναι κατάσταση του');
INSERT INTO model.property_i18n VALUES (381, 'P44', 'pt', 'tem estado material ', '2019-12-12 17:08:42.016696', NULL, 'estado material de');
INSERT INTO model.property_i18n VALUES (382, 'P44', 'zh', '有状态', '2019-12-12 17:08:42.016696', NULL, '描述的标的物是');
INSERT INTO model.property_i18n VALUES (383, 'P2', 'de', 'hat den Typus', '2019-12-12 17:08:42.016696', NULL, 'ist Typus von');
INSERT INTO model.property_i18n VALUES (384, 'P2', 'en', 'has type', '2019-12-12 17:08:42.016696', NULL, 'is type of');
INSERT INTO model.property_i18n VALUES (385, 'P2', 'fr', 'est de type', '2019-12-12 17:08:42.016696', NULL, 'est le type de');
INSERT INTO model.property_i18n VALUES (386, 'P2', 'ru', 'имеет тип', '2019-12-12 17:08:42.016696', NULL, 'является типом для');
INSERT INTO model.property_i18n VALUES (387, 'P2', 'el', 'έχει τύπο', '2019-12-12 17:08:42.016696', NULL, 'είναι ο τύπος του/της');
INSERT INTO model.property_i18n VALUES (388, 'P2', 'pt', 'é do tipo', '2019-12-12 17:08:42.016696', NULL, 'é o tipo de');
INSERT INTO model.property_i18n VALUES (389, 'P2', 'zh', '有类型', '2019-12-12 17:08:42.016696', NULL, '被用来分类');
INSERT INTO model.property_i18n VALUES (390, 'P135', 'de', 'erschuf Typus', '2019-12-12 17:08:42.016696', NULL, 'wurde geschaffen durch');
INSERT INTO model.property_i18n VALUES (391, 'P135', 'en', 'created type', '2019-12-12 17:08:42.016696', NULL, 'was created by');
INSERT INTO model.property_i18n VALUES (392, 'P135', 'fr', 'a créé le type', '2019-12-12 17:08:42.016696', NULL, 'a été créé par');
INSERT INTO model.property_i18n VALUES (393, 'P135', 'ru', 'создал тип', '2019-12-12 17:08:42.016696', NULL, 'был создан посредством');
INSERT INTO model.property_i18n VALUES (394, 'P135', 'el', 'δημιούργησε τύπο', '2019-12-12 17:08:42.016696', NULL, 'δημιουργήθηκε από');
INSERT INTO model.property_i18n VALUES (395, 'P135', 'pt', 'criou tipo', '2019-12-12 17:08:42.016696', NULL, 'foi criado por');
INSERT INTO model.property_i18n VALUES (396, 'P135', 'zh', '创造了类型', '2019-12-12 17:08:42.016696', NULL, '被创造於');
INSERT INTO model.property_i18n VALUES (397, 'P142', 'de', 'benutzte Bestandteil', '2019-12-12 17:08:42.016696', NULL, 'wurde benutzt in');
INSERT INTO model.property_i18n VALUES (398, 'P142', 'en', 'used constituent', '2019-12-12 17:08:42.016696', NULL, 'was used in');
INSERT INTO model.property_i18n VALUES (399, 'P142', 'zh', '使用称号构成部分', '2019-12-12 17:08:42.016696', NULL, '被用来构成称号於');
INSERT INTO model.property_i18n VALUES (400, 'P166', 'en', 'was a presence of', '2019-12-12 17:08:42.016696', NULL, 'had presence');
INSERT INTO model.property_i18n VALUES (401, 'P40', 'de', 'beobachtete Dimension', '2019-12-12 17:08:42.016696', NULL, 'wurde beobachtet in');
INSERT INTO model.property_i18n VALUES (402, 'P40', 'en', 'observed dimension', '2019-12-12 17:08:42.016696', NULL, 'was observed in');
INSERT INTO model.property_i18n VALUES (403, 'P40', 'fr', 'a relevé comme dimension', '2019-12-12 17:08:42.016696', NULL, 'a été relevée au cours de');
INSERT INTO model.property_i18n VALUES (404, 'P40', 'ru', 'определил величину', '2019-12-12 17:08:42.016696', NULL, 'наблюдался в');
INSERT INTO model.property_i18n VALUES (405, 'P40', 'el', 'παρατήρησε', '2019-12-12 17:08:42.016696', NULL, 'παρατηρήθηκε από');
INSERT INTO model.property_i18n VALUES (406, 'P40', 'pt', 'verificou a dimensão', '2019-12-12 17:08:42.016696', NULL, 'foi verificada durante');
INSERT INTO model.property_i18n VALUES (407, 'P40', 'zh', '观察认定的规模是', '2019-12-12 17:08:42.016696', NULL, '被观察认定於');
INSERT INTO model.property_i18n VALUES (408, 'P19', 'de', 'war beabsichtigteter Gebrauch von ', '2019-12-12 17:08:42.016696', NULL, 'wurde hergestellt für');
INSERT INTO model.property_i18n VALUES (409, 'P19', 'en', 'was intended use of', '2019-12-12 17:08:42.016696', NULL, 'was made for');
INSERT INTO model.property_i18n VALUES (410, 'P19', 'fr', 'était l''utilisation prévue de', '2019-12-12 17:08:42.016696', NULL, 'a été fabriquée pour');
INSERT INTO model.property_i18n VALUES (411, 'P19', 'ru', 'был предполагаемым использованием для', '2019-12-12 17:08:42.016696', NULL, 'был создан для');
INSERT INTO model.property_i18n VALUES (412, 'P19', 'el', 'ήταν προορισμένη χρήση του', '2019-12-12 17:08:42.016696', NULL, 'έγινε για');
INSERT INTO model.property_i18n VALUES (413, 'P19', 'pt', 'era prevista a utilização de', '2019-12-12 17:08:42.016696', NULL, 'foi feito para');
INSERT INTO model.property_i18n VALUES (414, 'P19', 'zh', '特别使用了', '2019-12-12 17:08:42.016696', NULL, '被制造来用於');
INSERT INTO model.property_i18n VALUES (415, 'P22', 'de', 'übertrug Besitztitel auf', '2019-12-12 17:08:42.016696', NULL, 'erwarb Besitztitel durch');
INSERT INTO model.property_i18n VALUES (416, 'P22', 'en', 'transferred title to', '2019-12-12 17:08:42.016696', NULL, 'acquired title through');
INSERT INTO model.property_i18n VALUES (417, 'P22', 'fr', 'a fait passer le droit de propriété à', '2019-12-12 17:08:42.016696', NULL, 'a acquis le droit de propriété du fait de');
INSERT INTO model.property_i18n VALUES (418, 'P22', 'ru', 'передал право собственности', '2019-12-12 17:08:42.016696', NULL, 'получил право собственности через');
INSERT INTO model.property_i18n VALUES (419, 'P22', 'el', 'μετεβίβασε τον τίτλο σε', '2019-12-12 17:08:42.016696', NULL, 'απέκτησε τον τίτλο μέσω');
INSERT INTO model.property_i18n VALUES (420, 'P22', 'pt', 'transferiu os direitos de propriedade para', '2019-12-12 17:08:42.016696', NULL, 'adquiriu os direitos de propriedade por meio da');
INSERT INTO model.property_i18n VALUES (421, 'P22', 'zh', '转交所有权给', '2019-12-12 17:08:42.016696', NULL, '获取所有权於');
INSERT INTO model.property_i18n VALUES (422, 'P97', 'de', 'gab Vaterschaft', '2019-12-12 17:08:42.016696', NULL, 'war Vater für');
INSERT INTO model.property_i18n VALUES (423, 'P97', 'en', 'from father', '2019-12-12 17:08:42.016696', NULL, 'was father for');
INSERT INTO model.property_i18n VALUES (424, 'P97', 'fr', 'de père', '2019-12-12 17:08:42.016696', NULL, 'a été père dans');
INSERT INTO model.property_i18n VALUES (425, 'P97', 'ru', 'от отца', '2019-12-12 17:08:42.016696', NULL, 'был отцом для');
INSERT INTO model.property_i18n VALUES (426, 'P97', 'el', 'είχε πατέρα', '2019-12-12 17:08:42.016696', NULL, 'ήταν πατέρας του/της');
INSERT INTO model.property_i18n VALUES (427, 'P97', 'pt', 'pelo pai', '2019-12-12 17:08:42.016696', NULL, 'foi pai para');
INSERT INTO model.property_i18n VALUES (428, 'P97', 'zh', '来自父亲', '2019-12-12 17:08:42.016696', NULL, '成为生父於');
INSERT INTO model.property_i18n VALUES (429, 'P138', 'de', 'stellt dar', '2019-12-12 17:08:42.016696', NULL, 'wird dargestellt durch');
INSERT INTO model.property_i18n VALUES (430, 'P138', 'en', 'represents', '2019-12-12 17:08:42.016696', NULL, 'has representation');
INSERT INTO model.property_i18n VALUES (431, 'P138', 'fr', 'représente', '2019-12-12 17:08:42.016696', NULL, 'est représentée par');
INSERT INTO model.property_i18n VALUES (432, 'P138', 'ru', 'представляет', '2019-12-12 17:08:42.016696', NULL, 'имеет представление');
INSERT INTO model.property_i18n VALUES (433, 'P138', 'el', 'παριστάνει', '2019-12-12 17:08:42.016696', NULL, 'παριστάνεται από');
INSERT INTO model.property_i18n VALUES (434, 'P138', 'pt', 'representa', '2019-12-12 17:08:42.016696', NULL, 'tem representação');
INSERT INTO model.property_i18n VALUES (435, 'P138', 'zh', '描绘了', '2019-12-12 17:08:42.016696', NULL, '有图像描绘');
INSERT INTO model.property_i18n VALUES (436, 'P73', 'de', 'hat Übersetzung', '2019-12-12 17:08:42.016696', NULL, 'ist Übersetzung von');
INSERT INTO model.property_i18n VALUES (437, 'P73', 'en', 'has translation', '2019-12-12 17:08:42.016696', NULL, 'is translation of');
INSERT INTO model.property_i18n VALUES (438, 'P73', 'fr', 'a pour traduction', '2019-12-12 17:08:42.016696', NULL, 'est la traduction de');
INSERT INTO model.property_i18n VALUES (439, 'P73', 'ru', 'имеет перевод', '2019-12-12 17:08:42.016696', NULL, 'является переводом');
INSERT INTO model.property_i18n VALUES (440, 'P73', 'el', 'έχει μετάφραση', '2019-12-12 17:08:42.016696', NULL, 'είναι μετάφραση του/της');
INSERT INTO model.property_i18n VALUES (441, 'P73', 'pt', 'tem tradução', '2019-12-12 17:08:42.016696', NULL, 'é tradução de');
INSERT INTO model.property_i18n VALUES (442, 'P73', 'zh', '有译文', '2019-12-12 17:08:42.016696', NULL, '翻译自');
INSERT INTO model.property_i18n VALUES (443, 'P106', 'de', ' ist zusammengesetzt aus', '2019-12-12 17:08:42.016696', NULL, 'bildet Teil von');
INSERT INTO model.property_i18n VALUES (444, 'P106', 'en', 'is composed of', '2019-12-12 17:08:42.016696', NULL, 'forms part of');
INSERT INTO model.property_i18n VALUES (445, 'P106', 'fr', 'est composé de', '2019-12-12 17:08:42.016696', NULL, 'fait partie de');
INSERT INTO model.property_i18n VALUES (446, 'P106', 'ru', 'составлен из', '2019-12-12 17:08:42.016696', NULL, 'формирует часть');
INSERT INTO model.property_i18n VALUES (447, 'P106', 'el', 'αποτελείται από', '2019-12-12 17:08:42.016696', NULL, 'αποτελεί μέρος του/της');
INSERT INTO model.property_i18n VALUES (448, 'P106', 'pt', 'é composto de', '2019-12-12 17:08:42.016696', NULL, 'faz parte de');
INSERT INTO model.property_i18n VALUES (449, 'P106', 'zh', '有组成元素', '2019-12-12 17:08:42.016696', NULL, '组成了');
INSERT INTO model.property_i18n VALUES (450, 'P112', 'de', 'verminderte', '2019-12-12 17:08:42.016696', NULL, 'wurde vermindert durch');
INSERT INTO model.property_i18n VALUES (451, 'P112', 'en', 'diminished', '2019-12-12 17:08:42.016696', NULL, 'was diminished by');
INSERT INTO model.property_i18n VALUES (452, 'P112', 'fr', 'a diminué', '2019-12-12 17:08:42.016696', NULL, 'a été diminué par');
INSERT INTO model.property_i18n VALUES (453, 'P112', 'ru', 'уменьшил', '2019-12-12 17:08:42.016696', NULL, 'был уменьшен посредством');
INSERT INTO model.property_i18n VALUES (454, 'P112', 'el', 'εξάλειψε', '2019-12-12 17:08:42.016696', NULL, 'εξαλείφθηκε από');
INSERT INTO model.property_i18n VALUES (455, 'P112', 'pt', 'diminuiu', '2019-12-12 17:08:42.016696', NULL, 'foi diminuído por');
INSERT INTO model.property_i18n VALUES (456, 'P112', 'zh', '缩减了', '2019-12-12 17:08:42.016696', NULL, '被缩减於');
INSERT INTO model.property_i18n VALUES (457, 'P71', 'de', 'listet', '2019-12-12 17:08:42.016696', NULL, 'wird aufgelistet in');
INSERT INTO model.property_i18n VALUES (458, 'P71', 'en', 'lists', '2019-12-12 17:08:42.016696', NULL, 'is listed in');
INSERT INTO model.property_i18n VALUES (459, 'P71', 'fr', 'définit', '2019-12-12 17:08:42.016696', NULL, 'est défini par');
INSERT INTO model.property_i18n VALUES (686, 'P123', 'fr', 'a eu pour résultat', '2019-12-12 17:08:42.016696', NULL, 'est le résultat de');
INSERT INTO model.property_i18n VALUES (460, 'P71', 'ru', 'перечисляет', '2019-12-12 17:08:42.016696', NULL, 'перечислен в');
INSERT INTO model.property_i18n VALUES (461, 'P71', 'el', 'περιλαμβάνει', '2019-12-12 17:08:42.016696', NULL, 'περιλαμβάνεται σε');
INSERT INTO model.property_i18n VALUES (462, 'P71', 'pt', 'define', '2019-12-12 17:08:42.016696', NULL, 'é definido por');
INSERT INTO model.property_i18n VALUES (463, 'P71', 'zh', '条列出', '2019-12-12 17:08:42.016696', NULL, '被条列於');
INSERT INTO model.property_i18n VALUES (464, 'P167', 'en', 'at', '2019-12-12 17:08:42.016696', NULL, 'was place of');
INSERT INTO model.property_i18n VALUES (465, 'P45', 'de', 'besteht aus', '2019-12-12 17:08:42.016696', NULL, 'ist enthalten in');
INSERT INTO model.property_i18n VALUES (466, 'P45', 'en', 'consists of', '2019-12-12 17:08:42.016696', NULL, 'is incorporated in');
INSERT INTO model.property_i18n VALUES (467, 'P45', 'fr', 'consiste en', '2019-12-12 17:08:42.016696', NULL, 'est présent dans');
INSERT INTO model.property_i18n VALUES (468, 'P45', 'ru', 'составлен из', '2019-12-12 17:08:42.016696', NULL, 'входит в состав');
INSERT INTO model.property_i18n VALUES (469, 'P45', 'el', 'αποτελείται από', '2019-12-12 17:08:42.016696', NULL, 'είναι ενσωματωμένος/η/ο σε');
INSERT INTO model.property_i18n VALUES (470, 'P45', 'pt', 'consiste de', '2019-12-12 17:08:42.016696', NULL, 'está presente em');
INSERT INTO model.property_i18n VALUES (471, 'P45', 'zh', '有构成材料', '2019-12-12 17:08:42.016696', NULL, '被用来构成');
INSERT INTO model.property_i18n VALUES (472, 'P146', 'de', 'entließ von', '2019-12-12 17:08:42.016696', NULL, 'verlor Mitglied durch');
INSERT INTO model.property_i18n VALUES (473, 'P146', 'en', 'separated from', '2019-12-12 17:08:42.016696', NULL, 'lost member by');
INSERT INTO model.property_i18n VALUES (474, 'P146', 'zh', '脱离了群组', '2019-12-12 17:08:42.016696', NULL, '失去成员於');
INSERT INTO model.property_i18n VALUES (475, 'P156', 'en', 'occupies', '2019-12-12 17:08:42.016696', NULL, 'is occupied by');
INSERT INTO model.property_i18n VALUES (476, 'P76', 'de', 'hat Kontaktpunkt', '2019-12-12 17:08:42.016696', NULL, 'bietet Zugang zu');
INSERT INTO model.property_i18n VALUES (477, 'P76', 'en', 'has contact point', '2019-12-12 17:08:42.016696', NULL, 'provides access to');
INSERT INTO model.property_i18n VALUES (478, 'P76', 'fr', 'a pour coordonnées individuelles', '2019-12-12 17:08:42.016696', NULL, 'permettent de contacter');
INSERT INTO model.property_i18n VALUES (479, 'P76', 'ru', 'имеет контакт', '2019-12-12 17:08:42.016696', NULL, 'предоставляет доступ к');
INSERT INTO model.property_i18n VALUES (480, 'P76', 'el', 'έχει σημείο επικοινωνίας', '2019-12-12 17:08:42.016696', NULL, 'παρέχει πρόσβαση σε');
INSERT INTO model.property_i18n VALUES (481, 'P76', 'pt', 'possui ponto de contato', '2019-12-12 17:08:42.016696', NULL, 'é ponto de contado de');
INSERT INTO model.property_i18n VALUES (482, 'P76', 'zh', '有联系方式', '2019-12-12 17:08:42.016696', NULL, '被用来联系');
INSERT INTO model.property_i18n VALUES (483, 'P128', 'de', 'trägt', '2019-12-12 17:08:42.016696', NULL, 'wird getragen von');
INSERT INTO model.property_i18n VALUES (484, 'P128', 'en', 'carries', '2019-12-12 17:08:42.016696', NULL, 'is carried by');
INSERT INTO model.property_i18n VALUES (485, 'P128', 'fr', 'est le support de', '2019-12-12 17:08:42.016696', NULL, 'a pour support');
INSERT INTO model.property_i18n VALUES (486, 'P128', 'ru', 'несет', '2019-12-12 17:08:42.016696', NULL, 'переносится посредством');
INSERT INTO model.property_i18n VALUES (487, 'P128', 'el', 'φέρει', '2019-12-12 17:08:42.016696', NULL, 'φέρεται από');
INSERT INTO model.property_i18n VALUES (488, 'P128', 'pt', 'é o suporte de', '2019-12-12 17:08:42.016696', NULL, 'é suportado por');
INSERT INTO model.property_i18n VALUES (489, 'P128', 'zh', '承载信息', '2019-12-12 17:08:42.016696', NULL, '被承载于');
INSERT INTO model.property_i18n VALUES (490, 'P24', 'de', 'übertrug Besitz über', '2019-12-12 17:08:42.016696', NULL, 'ging über in Besitz durch');
INSERT INTO model.property_i18n VALUES (491, 'P24', 'en', 'transferred title of', '2019-12-12 17:08:42.016696', NULL, 'changed ownership through');
INSERT INTO model.property_i18n VALUES (492, 'P24', 'fr', 'a fait passer le droit de propriété sur', '2019-12-12 17:08:42.016696', NULL, 'a changé de mains du fait de');
INSERT INTO model.property_i18n VALUES (493, 'P24', 'ru', 'передал право собственности на', '2019-12-12 17:08:42.016696', NULL, 'сменил владельца через');
INSERT INTO model.property_i18n VALUES (494, 'P24', 'el', 'μετεβίβασε τον τίτλο του/της', '2019-12-12 17:08:42.016696', NULL, 'άλλαξε ιδιοκτησία μέσω');
INSERT INTO model.property_i18n VALUES (495, 'P24', 'pt', 'transferiu os direitos de propriedade sobre o', '2019-12-12 17:08:42.016696', NULL, 'mudou de proprietário por meio de');
INSERT INTO model.property_i18n VALUES (496, 'P24', 'zh', '转移所有权的标的物是', '2019-12-12 17:08:42.016696', NULL, '转移了所有权於');
INSERT INTO model.property_i18n VALUES (497, 'P84', 'de', 'hatte Höchstdauer', '2019-12-12 17:08:42.016696', NULL, 'war längste Dauer von');
INSERT INTO model.property_i18n VALUES (498, 'P84', 'en', 'had at most duration', '2019-12-12 17:08:42.016696', NULL, 'was maximum duration of');
INSERT INTO model.property_i18n VALUES (499, 'P84', 'fr', 'a duré au plus', '2019-12-12 17:08:42.016696', NULL, 'a été la durée maximum de');
INSERT INTO model.property_i18n VALUES (500, 'P84', 'ru', 'имеет длительность меньше чем', '2019-12-12 17:08:42.016696', NULL, 'был максимальной длительностью для');
INSERT INTO model.property_i18n VALUES (501, 'P84', 'el', 'είχε μέγιστη διάρκεια', '2019-12-12 17:08:42.016696', NULL, 'είναι μέγιστη διάρκεια του/της');
INSERT INTO model.property_i18n VALUES (502, 'P84', 'pt', 'durou no máximo', '2019-12-12 17:08:42.016696', NULL, 'foi a duração máxima de');
INSERT INTO model.property_i18n VALUES (503, 'P84', 'zh', '时间最多持续了', '2019-12-12 17:08:42.016696', NULL, NULL);
INSERT INTO model.property_i18n VALUES (504, 'P27', 'de', 'bewegte weg von', '2019-12-12 17:08:42.016696', NULL, 'war Ausgangsort von');
INSERT INTO model.property_i18n VALUES (505, 'P27', 'en', 'moved from', '2019-12-12 17:08:42.016696', NULL, 'was origin of');
INSERT INTO model.property_i18n VALUES (506, 'P27', 'fr', 'a retiré de', '2019-12-12 17:08:42.016696', NULL, 'a été l''origine de');
INSERT INTO model.property_i18n VALUES (507, 'P27', 'ru', 'перемещен из', '2019-12-12 17:08:42.016696', NULL, 'был исходной точкой для');
INSERT INTO model.property_i18n VALUES (508, 'P27', 'el', 'μετακινήθηκε από', '2019-12-12 17:08:42.016696', NULL, 'ήταν αφετηρία του/της');
INSERT INTO model.property_i18n VALUES (509, 'P27', 'pt', 'locomoveu de', '2019-12-12 17:08:42.016696', NULL, 'era origem de');
INSERT INTO model.property_i18n VALUES (510, 'P27', 'zh', '有移出地', '2019-12-12 17:08:42.016696', NULL, '被作为移出地於');
INSERT INTO model.property_i18n VALUES (511, 'P37', 'de', 'wies zu', '2019-12-12 17:08:42.016696', NULL, 'wurde zugewiesen durch');
INSERT INTO model.property_i18n VALUES (512, 'P37', 'en', 'assigned', '2019-12-12 17:08:42.016696', NULL, 'was assigned by');
INSERT INTO model.property_i18n VALUES (513, 'P37', 'fr', 'a attribué', '2019-12-12 17:08:42.016696', NULL, 'a été attribuée par');
INSERT INTO model.property_i18n VALUES (514, 'P37', 'ru', 'назначил', '2019-12-12 17:08:42.016696', NULL, 'был присвоен посредством');
INSERT INTO model.property_i18n VALUES (515, 'P37', 'el', 'απέδωσε', '2019-12-12 17:08:42.016696', NULL, 'αποδόθηκε ως ιδιότητα από');
INSERT INTO model.property_i18n VALUES (516, 'P37', 'pt', 'atribuiu', '2019-12-12 17:08:42.016696', NULL, 'foi atribuído por');
INSERT INTO model.property_i18n VALUES (517, 'P37', 'zh', '指定标识符为', '2019-12-12 17:08:42.016696', NULL, '被指定为标识符於');
INSERT INTO model.property_i18n VALUES (518, 'P118', 'de', 'überlappt zeitlich mit', '2019-12-12 17:08:42.016696', NULL, 'wird zeitlich überlappt von');
INSERT INTO model.property_i18n VALUES (519, 'P118', 'en', 'overlaps in time with', '2019-12-12 17:08:42.016696', NULL, 'is overlapped in time by');
INSERT INTO model.property_i18n VALUES (520, 'P118', 'fr', 'est partiellement recouverte dans le temps par', '2019-12-12 17:08:42.016696', NULL, 'recouvre partiellement dans le temps');
INSERT INTO model.property_i18n VALUES (521, 'P118', 'ru', 'перекрывает во времени', '2019-12-12 17:08:42.016696', NULL, 'перекрывается во времени');
INSERT INTO model.property_i18n VALUES (522, 'P118', 'el', 'προηγείται μερικώς επικαλύπτοντας', '2019-12-12 17:08:42.016696', NULL, 'έπεται μερικώς επικαλυπτόμενο');
INSERT INTO model.property_i18n VALUES (523, 'P118', 'pt', 'sobrepõe temporalmente', '2019-12-12 17:08:42.016696', NULL, 'é sobreposto temporalmente por');
INSERT INTO model.property_i18n VALUES (524, 'P118', 'zh', '时段重叠了', '2019-12-12 17:08:42.016696', NULL, '时段被重叠于');
INSERT INTO model.property_i18n VALUES (525, 'P110', 'de', 'erweiterte', '2019-12-12 17:08:42.016696', NULL, 'wurde erweitert durch');
INSERT INTO model.property_i18n VALUES (526, 'P110', 'en', 'augmented', '2019-12-12 17:08:42.016696', NULL, 'was augmented by');
INSERT INTO model.property_i18n VALUES (527, 'P110', 'fr', 'a augmenté', '2019-12-12 17:08:42.016696', NULL, 'a été augmenté par');
INSERT INTO model.property_i18n VALUES (528, 'P110', 'ru', 'увеличил', '2019-12-12 17:08:42.016696', NULL, 'был увеличен посредством');
INSERT INTO model.property_i18n VALUES (529, 'P110', 'el', 'επαύξησε', '2019-12-12 17:08:42.016696', NULL, 'επαυξήθηκε από');
INSERT INTO model.property_i18n VALUES (530, 'P110', 'pt', 'aumentou', '2019-12-12 17:08:42.016696', NULL, 'foi aumentada por');
INSERT INTO model.property_i18n VALUES (531, 'P110', 'zh', '扩增了', '2019-12-12 17:08:42.016696', NULL, '被扩增於');
INSERT INTO model.property_i18n VALUES (532, 'P93', 'de', 'beendete die Existenz von', '2019-12-12 17:08:42.016696', NULL, 'wurde seiner Existenz beraubt durch');
INSERT INTO model.property_i18n VALUES (533, 'P93', 'en', 'took out of existence', '2019-12-12 17:08:42.016696', NULL, 'was taken out of existence by');
INSERT INTO model.property_i18n VALUES (534, 'P93', 'fr', 'a fait cesser d’exister', '2019-12-12 17:08:42.016696', NULL, 'a cessé d’exister du fait de');
INSERT INTO model.property_i18n VALUES (535, 'P93', 'ru', 'положил конец существованию', '2019-12-12 17:08:42.016696', NULL, 'прекратил существование посредством');
INSERT INTO model.property_i18n VALUES (536, 'P93', 'el', 'αναίρεσε', '2019-12-12 17:08:42.016696', NULL, 'αναιρέθηκε από');
INSERT INTO model.property_i18n VALUES (537, 'P93', 'pt', 'cessou a existência de', '2019-12-12 17:08:42.016696', NULL, 'deixou de existir');
INSERT INTO model.property_i18n VALUES (538, 'P93', 'zh', '结束了', '2019-12-12 17:08:42.016696', NULL, '被结束於');
INSERT INTO model.property_i18n VALUES (539, 'P31', 'de', 'veränderte', '2019-12-12 17:08:42.016696', NULL, 'wurde verändert durch');
INSERT INTO model.property_i18n VALUES (540, 'P31', 'en', 'has modified', '2019-12-12 17:08:42.016696', NULL, 'was modified by');
INSERT INTO model.property_i18n VALUES (541, 'P31', 'fr', 'a modifié', '2019-12-12 17:08:42.016696', NULL, 'a été modifié par');
INSERT INTO model.property_i18n VALUES (542, 'P31', 'ru', 'изменил', '2019-12-12 17:08:42.016696', NULL, 'был изменен посредством');
INSERT INTO model.property_i18n VALUES (543, 'P31', 'el', 'τροποποίησε', '2019-12-12 17:08:42.016696', NULL, 'τροποποιήθηκε από');
INSERT INTO model.property_i18n VALUES (544, 'P31', 'pt', 'modificou', '2019-12-12 17:08:42.016696', NULL, 'foi modificada por');
INSERT INTO model.property_i18n VALUES (545, 'P31', 'zh', '修改了', '2019-12-12 17:08:42.016696', NULL, '被修改於');
INSERT INTO model.property_i18n VALUES (546, 'P72', 'de', 'hat Sprache', '2019-12-12 17:08:42.016696', NULL, 'ist Sprache von');
INSERT INTO model.property_i18n VALUES (547, 'P72', 'en', 'has language', '2019-12-12 17:08:42.016696', NULL, 'is language of');
INSERT INTO model.property_i18n VALUES (548, 'P72', 'fr', 'est en langue', '2019-12-12 17:08:42.016696', NULL, 'est la langue de');
INSERT INTO model.property_i18n VALUES (549, 'P72', 'ru', 'имеет язык', '2019-12-12 17:08:42.016696', NULL, 'является языком для');
INSERT INTO model.property_i18n VALUES (550, 'P72', 'el', 'έχει γλώσσα', '2019-12-12 17:08:42.016696', NULL, 'είναι γλώσσα του/της');
INSERT INTO model.property_i18n VALUES (551, 'P72', 'pt', 'é da língua ', '2019-12-12 17:08:42.016696', NULL, 'é a língua de');
INSERT INTO model.property_i18n VALUES (552, 'P72', 'zh', '使用语言', '2019-12-12 17:08:42.016696', NULL, '被用来撰写');
INSERT INTO model.property_i18n VALUES (553, 'P70', 'de', 'belegt', '2019-12-12 17:08:42.016696', NULL, 'wird belegt in');
INSERT INTO model.property_i18n VALUES (554, 'P70', 'en', 'documents', '2019-12-12 17:08:42.016696', NULL, 'is documented in');
INSERT INTO model.property_i18n VALUES (555, 'P70', 'fr', 'mentionne', '2019-12-12 17:08:42.016696', NULL, 'est mentionnée dans');
INSERT INTO model.property_i18n VALUES (556, 'P70', 'ru', 'документирует', '2019-12-12 17:08:42.016696', NULL, 'документирован в');
INSERT INTO model.property_i18n VALUES (557, 'P70', 'el', 'τεκμηριώνει', '2019-12-12 17:08:42.016696', NULL, 'τεκμηριώνεται σε');
INSERT INTO model.property_i18n VALUES (558, 'P70', 'pt', 'documenta', '2019-12-12 17:08:42.016696', NULL, 'é documentado em');
INSERT INTO model.property_i18n VALUES (559, 'P70', 'zh', '记录了', '2019-12-12 17:08:42.016696', NULL, '被记录於');
INSERT INTO model.property_i18n VALUES (560, 'P23', 'de', 'übertrug Besitztitel von', '2019-12-12 17:08:42.016696', NULL, 'trat Besitztitel ab in');
INSERT INTO model.property_i18n VALUES (561, 'P23', 'en', 'transferred title from', '2019-12-12 17:08:42.016696', NULL, 'surrendered title through');
INSERT INTO model.property_i18n VALUES (562, 'P23', 'fr', 'a fait passer le droit de propriété de', '2019-12-12 17:08:42.016696', NULL, 'a perdu le droit de propriété du fait de');
INSERT INTO model.property_i18n VALUES (563, 'P23', 'ru', 'передал право собственности от', '2019-12-12 17:08:42.016696', NULL, 'право собственности отдано через');
INSERT INTO model.property_i18n VALUES (564, 'P23', 'el', 'μετεβίβασε τον τίτλο από', '2019-12-12 17:08:42.016696', NULL, 'παρέδωσε τον τίτλο μέσω');
INSERT INTO model.property_i18n VALUES (565, 'P23', 'pt', 'transferiu os direitos de propriedade de', '2019-12-12 17:08:42.016696', NULL, 'perdeu os direitos de propriedade por meio da');
INSERT INTO model.property_i18n VALUES (566, 'P23', 'zh', '原所有权者是', '2019-12-12 17:08:42.016696', NULL, '交出所有权於');
INSERT INTO model.property_i18n VALUES (567, 'P50', 'de', 'hat derzeitigen Betreuer', '2019-12-12 17:08:42.016696', NULL, 'ist derzeitiger Betreuer von');
INSERT INTO model.property_i18n VALUES (568, 'P50', 'en', 'has current keeper', '2019-12-12 17:08:42.016696', NULL, 'is current keeper of');
INSERT INTO model.property_i18n VALUES (569, 'P50', 'fr', 'est actuellement détenu par', '2019-12-12 17:08:42.016696', NULL, 'est actuel détenteur de');
INSERT INTO model.property_i18n VALUES (570, 'P50', 'ru', 'имеет текущего смотрителя', '2019-12-12 17:08:42.016696', NULL, 'является текущим смотрителем для');
INSERT INTO model.property_i18n VALUES (571, 'P50', 'el', 'είναι στην κατοχή του', '2019-12-12 17:08:42.016696', NULL, 'κατέχει');
INSERT INTO model.property_i18n VALUES (572, 'P50', 'pt', 'é guardada por', '2019-12-12 17:08:42.016696', NULL, 'é guardador de');
INSERT INTO model.property_i18n VALUES (573, 'P50', 'zh', '有现任保管者', '2019-12-12 17:08:42.016696', NULL, '目前保管');
INSERT INTO model.property_i18n VALUES (574, 'P17', 'de', 'wurde angeregt durch', '2019-12-12 17:08:42.016696', NULL, 'regte an');
INSERT INTO model.property_i18n VALUES (575, 'P17', 'en', 'was motivated by', '2019-12-12 17:08:42.016696', NULL, 'motivated');
INSERT INTO model.property_i18n VALUES (576, 'P17', 'fr', 'a été motivée par', '2019-12-12 17:08:42.016696', NULL, 'a motivé');
INSERT INTO model.property_i18n VALUES (577, 'P17', 'ru', 'был обусловлен посредством', '2019-12-12 17:08:42.016696', NULL, 'обусловил');
INSERT INTO model.property_i18n VALUES (578, 'P17', 'el', 'είχε ως αφορμή', '2019-12-12 17:08:42.016696', NULL, 'ήταν αφορμή');
INSERT INTO model.property_i18n VALUES (579, 'P17', 'pt', 'foi motivado por', '2019-12-12 17:08:42.016696', NULL, 'motivou');
INSERT INTO model.property_i18n VALUES (580, 'P17', 'zh', '有促动事物', '2019-12-12 17:08:42.016696', NULL, '促动了');
INSERT INTO model.property_i18n VALUES (581, 'P53', 'de', 'hat früheren oder derzeitigen Standort', '2019-12-12 17:08:42.016696', NULL, 'ist früherer oder derzeitiger Standort von');
INSERT INTO model.property_i18n VALUES (582, 'P53', 'en', 'has former or current location', '2019-12-12 17:08:42.016696', NULL, 'is former or current location of');
INSERT INTO model.property_i18n VALUES (583, 'P53', 'fr', 'a ou a eu pour localisation', '2019-12-12 17:08:42.016696', NULL, 'est ou a été localisation de');
INSERT INTO model.property_i18n VALUES (584, 'P53', 'ru', 'имеет текущее или бывшее местоположение', '2019-12-12 17:08:42.016696', NULL, 'является текущим или бывшим местоположением для');
INSERT INTO model.property_i18n VALUES (585, 'P53', 'el', 'βρίσκεται ή βρισκόταν σε', '2019-12-12 17:08:42.016696', NULL, 'είναι ή ήταν θέση του');
INSERT INTO model.property_i18n VALUES (586, 'P53', 'pt', 'é ou foi localizada em', '2019-12-12 17:08:42.016696', NULL, 'é ou foi localização de');
INSERT INTO model.property_i18n VALUES (587, 'P53', 'zh', '目前或曾经被置放於', '2019-12-12 17:08:42.016696', NULL, '目前或曾经被置放了');
INSERT INTO model.property_i18n VALUES (588, 'P132', 'de', 'überlappt mit', '2019-12-12 17:08:42.016696', NULL, NULL);
INSERT INTO model.property_i18n VALUES (589, 'P132', 'en', 'overlaps with', '2019-12-12 17:08:42.016696', NULL, NULL);
INSERT INTO model.property_i18n VALUES (590, 'P132', 'fr', 'chevauche', '2019-12-12 17:08:42.016696', NULL, NULL);
INSERT INTO model.property_i18n VALUES (591, 'P132', 'ru', 'пересекается с', '2019-12-12 17:08:42.016696', NULL, NULL);
INSERT INTO model.property_i18n VALUES (592, 'P132', 'el', 'επικαλύπτεται με', '2019-12-12 17:08:42.016696', NULL, NULL);
INSERT INTO model.property_i18n VALUES (593, 'P132', 'pt', 'sobrepõe', '2019-12-12 17:08:42.016696', NULL, NULL);
INSERT INTO model.property_i18n VALUES (594, 'P132', 'zh', '时空重叠于', '2019-12-12 17:08:42.016696', NULL, NULL);
INSERT INTO model.property_i18n VALUES (595, 'P124', 'de', 'wandelte um', '2019-12-12 17:08:42.016696', NULL, 'wurde umgewandelt durch');
INSERT INTO model.property_i18n VALUES (596, 'P124', 'en', 'transformed', '2019-12-12 17:08:42.016696', NULL, 'was transformed by');
INSERT INTO model.property_i18n VALUES (597, 'P124', 'fr', 'a transformé', '2019-12-12 17:08:42.016696', NULL, 'a été transformé par');
INSERT INTO model.property_i18n VALUES (598, 'P124', 'ru', 'трансформировал', '2019-12-12 17:08:42.016696', NULL, 'был трансформирован посредством');
INSERT INTO model.property_i18n VALUES (599, 'P124', 'el', 'μετέτρεψε', '2019-12-12 17:08:42.016696', NULL, 'μετατράπηκε από');
INSERT INTO model.property_i18n VALUES (600, 'P124', 'pt', 'transformou', '2019-12-12 17:08:42.016696', NULL, 'foi transformado por');
INSERT INTO model.property_i18n VALUES (601, 'P124', 'zh', '转变了', '2019-12-12 17:08:42.016696', NULL, '被转变於');
INSERT INTO model.property_i18n VALUES (602, 'P131', 'de', 'wird identifziert durch', '2019-12-12 17:08:42.016696', NULL, 'identifiziert');
INSERT INTO model.property_i18n VALUES (603, 'P131', 'en', 'is identified by', '2019-12-12 17:08:42.016696', NULL, 'identifies');
INSERT INTO model.property_i18n VALUES (604, 'P131', 'fr', 'est identifié par', '2019-12-12 17:08:42.016696', NULL, 'identifie');
INSERT INTO model.property_i18n VALUES (605, 'P131', 'ru', 'идентифицируется посредством', '2019-12-12 17:08:42.016696', NULL, 'идентифицирует');
INSERT INTO model.property_i18n VALUES (606, 'P131', 'el', 'αναγνωρίζεται ως', '2019-12-12 17:08:42.016696', NULL, 'είναι αναγνωριστικό');
INSERT INTO model.property_i18n VALUES (607, 'P131', 'pt', 'é identificado por', '2019-12-12 17:08:42.016696', NULL, 'identifica');
INSERT INTO model.property_i18n VALUES (608, 'P131', 'zh', '有称号', '2019-12-12 17:08:42.016696', NULL, '被用来识别');
INSERT INTO model.property_i18n VALUES (609, 'P12', 'de', 'fand statt im Beisein von', '2019-12-12 17:08:42.016696', NULL, 'war anwesend bei');
INSERT INTO model.property_i18n VALUES (610, 'P12', 'en', 'occurred in the presence of', '2019-12-12 17:08:42.016696', NULL, 'was present at');
INSERT INTO model.property_i18n VALUES (611, 'P12', 'fr', 'est arrivé en présence de', '2019-12-12 17:08:42.016696', NULL, 'était présent à');
INSERT INTO model.property_i18n VALUES (612, 'P12', 'ru', 'появился в присутствии', '2019-12-12 17:08:42.016696', NULL, 'присутствовал при');
INSERT INTO model.property_i18n VALUES (613, 'P12', 'el', 'συνέβη παρουσία του/της', '2019-12-12 17:08:42.016696', NULL, 'ήταν παρών/παρούσα/παρόν σε');
INSERT INTO model.property_i18n VALUES (614, 'P12', 'pt', 'ocorreu na presença de', '2019-12-12 17:08:42.016696', NULL, 'estava presente no');
INSERT INTO model.property_i18n VALUES (615, 'P12', 'zh', '发生现场存在', '2019-12-12 17:08:42.016696', NULL, '当时在场於');
INSERT INTO model.property_i18n VALUES (616, 'P69', 'de', 'ist verbunden mit', '2019-12-12 17:08:42.016696', NULL, NULL);
INSERT INTO model.property_i18n VALUES (617, 'P69', 'en', 'is associated with', '2019-12-12 17:08:42.016696', NULL, NULL);
INSERT INTO model.property_i18n VALUES (618, 'P69', 'fr', 'est associée à', '2019-12-12 17:08:42.016696', NULL, NULL);
INSERT INTO model.property_i18n VALUES (619, 'P69', 'ru', 'ассоциирован с', '2019-12-12 17:08:42.016696', NULL, NULL);
INSERT INTO model.property_i18n VALUES (620, 'P69', 'el', 'σχετίζεται με', '2019-12-12 17:08:42.016696', NULL, NULL);
INSERT INTO model.property_i18n VALUES (621, 'P69', 'pt', 'é associado com', '2019-12-12 17:08:42.016696', NULL, NULL);
INSERT INTO model.property_i18n VALUES (622, 'P69', 'zh', '相关於', '2019-12-12 17:08:42.016696', NULL, NULL);
INSERT INTO model.property_i18n VALUES (623, 'P137', 'de', 'erläutert', '2019-12-12 17:08:42.016696', NULL, 'erläutert durch Beispiel');
INSERT INTO model.property_i18n VALUES (624, 'P137', 'en', 'exemplifies', '2019-12-12 17:08:42.016696', NULL, 'is exemplified by');
INSERT INTO model.property_i18n VALUES (625, 'P137', 'fr', 'exemplifie', '2019-12-12 17:08:42.016696', NULL, 'est exemplifié par');
INSERT INTO model.property_i18n VALUES (626, 'P137', 'ru', 'поясняет', '2019-12-12 17:08:42.016696', NULL, 'поясняется посредством');
INSERT INTO model.property_i18n VALUES (627, 'P137', 'el', 'δειγματίζει', '2019-12-12 17:08:42.016696', NULL, 'δειγματίζεται από');
INSERT INTO model.property_i18n VALUES (628, 'P137', 'pt', 'é exemplificado por', '2019-12-12 17:08:42.016696', NULL, 'exemplifica');
INSERT INTO model.property_i18n VALUES (629, 'P137', 'zh', '例示了', '2019-12-12 17:08:42.016696', NULL, '有例示');
INSERT INTO model.property_i18n VALUES (630, 'P52', 'de', 'hat derzeitigen Besitzer', '2019-12-12 17:08:42.016696', NULL, 'ist derzeitiger Besitzer von');
INSERT INTO model.property_i18n VALUES (631, 'P52', 'en', 'has current owner', '2019-12-12 17:08:42.016696', NULL, 'is current owner of');
INSERT INTO model.property_i18n VALUES (632, 'P52', 'fr', 'est actuellement possédée par', '2019-12-12 17:08:42.016696', NULL, 'est le propriétaire actuel de');
INSERT INTO model.property_i18n VALUES (633, 'P52', 'ru', 'имеет текущего владельца', '2019-12-12 17:08:42.016696', NULL, 'является текущим владельцем для');
INSERT INTO model.property_i18n VALUES (634, 'P52', 'el', 'έχει ιδιοκτήτη', '2019-12-12 17:08:42.016696', NULL, 'είναι ιδιοκτήτης του');
INSERT INTO model.property_i18n VALUES (635, 'P52', 'pt', 'é propriedade de', '2019-12-12 17:08:42.016696', NULL, 'é proprietário de');
INSERT INTO model.property_i18n VALUES (636, 'P52', 'zh', '有现任物主', '2019-12-12 17:08:42.016696', NULL, '目前拥有');
INSERT INTO model.property_i18n VALUES (637, 'P164', 'en', 'during', '2019-12-12 17:08:42.016696', NULL, 'was time-span of');
INSERT INTO model.property_i18n VALUES (638, 'P49', 'de', 'hat früheren oder derzeitigen Betreuer', '2019-12-12 17:08:42.016696', NULL, 'ist früherer oder derzeitiger Betreuer von');
INSERT INTO model.property_i18n VALUES (639, 'P49', 'en', 'has former or current keeper', '2019-12-12 17:08:42.016696', NULL, 'is former or current keeper of');
INSERT INTO model.property_i18n VALUES (640, 'P49', 'fr', 'est ou a été détenu par', '2019-12-12 17:08:42.016696', NULL, 'est ou a été détenteur de');
INSERT INTO model.property_i18n VALUES (641, 'P49', 'ru', 'имеет бывшего или текущего смотрителя', '2019-12-12 17:08:42.016696', NULL, 'является бывшим или текущим смотрителем для');
INSERT INTO model.property_i18n VALUES (642, 'P49', 'el', 'είναι ή ήταν στην κατοχή του', '2019-12-12 17:08:42.016696', NULL, 'κατέχει ή κατείχε');
INSERT INTO model.property_i18n VALUES (643, 'P49', 'pt', 'é ou foi guardada por', '2019-12-12 17:08:42.016696', NULL, 'é ou foi guardador de');
INSERT INTO model.property_i18n VALUES (644, 'P49', 'zh', '有前任或现任保管者', '2019-12-12 17:08:42.016696', NULL, '目前或曾经保管');
INSERT INTO model.property_i18n VALUES (645, 'P144', 'de', 'verband mit', '2019-12-12 17:08:42.016696', NULL, 'erwarb Mitglied durch');
INSERT INTO model.property_i18n VALUES (646, 'P144', 'en', 'joined with', '2019-12-12 17:08:42.016696', NULL, 'gained member by');
INSERT INTO model.property_i18n VALUES (647, 'P144', 'zh', '加入成员到', '2019-12-12 17:08:42.016696', NULL, '获得成员於');
INSERT INTO model.property_i18n VALUES (648, 'P8', 'de', 'fand statt auf oder innerhalb von ', '2019-12-12 17:08:42.016696', NULL, 'bezeugte');
INSERT INTO model.property_i18n VALUES (649, 'P8', 'en', 'took place on or within', '2019-12-12 17:08:42.016696', NULL, 'witnessed');
INSERT INTO model.property_i18n VALUES (650, 'P8', 'fr', 'a eu lieu sur ou dans', '2019-12-12 17:08:42.016696', NULL, 'a été témoin de');
INSERT INTO model.property_i18n VALUES (651, 'P8', 'ru', 'имел место на или в', '2019-12-12 17:08:42.016696', NULL, 'являлся местом для');
INSERT INTO model.property_i18n VALUES (652, 'P8', 'el', 'έλαβε χώρα σε ή εντός', '2019-12-12 17:08:42.016696', NULL, 'υπήρξε τόπος του');
INSERT INTO model.property_i18n VALUES (653, 'P8', 'pt', 'ocorreu em ou dentro', '2019-12-12 17:08:42.016696', NULL, 'testemunhou');
INSERT INTO model.property_i18n VALUES (654, 'P8', 'zh', '发生所在物件是', '2019-12-12 17:08:42.016696', NULL, '发生过');
INSERT INTO model.property_i18n VALUES (655, 'P15', 'de', 'wurde beeinflußt durch', '2019-12-12 17:08:42.016696', NULL, 'beeinflußte');
INSERT INTO model.property_i18n VALUES (656, 'P15', 'en', 'was influenced by', '2019-12-12 17:08:42.016696', NULL, 'influenced');
INSERT INTO model.property_i18n VALUES (657, 'P15', 'fr', 'a été influencée par', '2019-12-12 17:08:42.016696', NULL, 'a influencé');
INSERT INTO model.property_i18n VALUES (658, 'P15', 'ru', 'находился под влиянием', '2019-12-12 17:08:42.016696', NULL, 'оказал влияние на');
INSERT INTO model.property_i18n VALUES (659, 'P15', 'el', 'επηρεάστηκε από', '2019-12-12 17:08:42.016696', NULL, 'επηρέασε');
INSERT INTO model.property_i18n VALUES (660, 'P15', 'pt', 'foi influenciado por ', '2019-12-12 17:08:42.016696', NULL, 'influenciou');
INSERT INTO model.property_i18n VALUES (661, 'P15', 'zh', '有影响事物', '2019-12-12 17:08:42.016696', NULL, '影响了');
INSERT INTO model.property_i18n VALUES (662, 'P98', 'de', 'brachte zur Welt', '2019-12-12 17:08:42.016696', NULL, 'wurde geboren durch');
INSERT INTO model.property_i18n VALUES (663, 'P98', 'en', 'brought into life', '2019-12-12 17:08:42.016696', NULL, 'was born');
INSERT INTO model.property_i18n VALUES (664, 'P98', 'fr', 'a donné vie à', '2019-12-12 17:08:42.016696', NULL, 'est né');
INSERT INTO model.property_i18n VALUES (665, 'P98', 'ru', 'породил', '2019-12-12 17:08:42.016696', NULL, 'был рожден');
INSERT INTO model.property_i18n VALUES (666, 'P98', 'el', 'έφερε στη ζωή', '2019-12-12 17:08:42.016696', NULL, 'γεννήθηκε');
INSERT INTO model.property_i18n VALUES (667, 'P98', 'pt', 'trouxe à vida', '2019-12-12 17:08:42.016696', NULL, 'veio à vida pelo');
INSERT INTO model.property_i18n VALUES (668, 'P98', 'zh', '诞生了', '2019-12-12 17:08:42.016696', NULL, '诞生於');
INSERT INTO model.property_i18n VALUES (669, 'P152', 'en', 'has parent', '2019-12-12 17:08:42.016696', NULL, 'is parent of');
INSERT INTO model.property_i18n VALUES (670, 'P43', 'de', 'hat Dimension', '2019-12-12 17:08:42.016696', NULL, 'ist Dimension von');
INSERT INTO model.property_i18n VALUES (671, 'P43', 'en', 'has dimension', '2019-12-12 17:08:42.016696', NULL, 'is dimension of');
INSERT INTO model.property_i18n VALUES (672, 'P43', 'fr', 'a pour dimension', '2019-12-12 17:08:42.016696', NULL, 'est dimension de');
INSERT INTO model.property_i18n VALUES (673, 'P43', 'ru', 'имеет величину', '2019-12-12 17:08:42.016696', NULL, 'является величиной для');
INSERT INTO model.property_i18n VALUES (674, 'P43', 'el', 'έχει μέγεθος', '2019-12-12 17:08:42.016696', NULL, 'είναι μέγεθος του');
INSERT INTO model.property_i18n VALUES (675, 'P43', 'pt', 'tem dimensão', '2019-12-12 17:08:42.016696', NULL, 'é dimensão de');
INSERT INTO model.property_i18n VALUES (676, 'P43', 'zh', '有规模数量', '2019-12-12 17:08:42.016696', NULL, '估量的标的物是');
INSERT INTO model.property_i18n VALUES (677, 'P38', 'de', ' hob Zuweisung auf von', '2019-12-12 17:08:42.016696', NULL, 'wurde aufgehoben durch');
INSERT INTO model.property_i18n VALUES (678, 'P38', 'en', 'deassigned', '2019-12-12 17:08:42.016696', NULL, 'was deassigned by');
INSERT INTO model.property_i18n VALUES (679, 'P38', 'fr', 'a désattribué', '2019-12-12 17:08:42.016696', NULL, 'a été désattribué par');
INSERT INTO model.property_i18n VALUES (680, 'P38', 'ru', 'отменил назначение', '2019-12-12 17:08:42.016696', NULL, 'был отменен посредством');
INSERT INTO model.property_i18n VALUES (681, 'P38', 'el', 'ακύρωσε', '2019-12-12 17:08:42.016696', NULL, 'ακυρώθηκε από');
INSERT INTO model.property_i18n VALUES (682, 'P38', 'pt', 'retirou a atribuição do', '2019-12-12 17:08:42.016696', NULL, 'foi retirada a atribuição por');
INSERT INTO model.property_i18n VALUES (683, 'P38', 'zh', '取消标识符', '2019-12-12 17:08:42.016696', NULL, '被取消标识符於');
INSERT INTO model.property_i18n VALUES (684, 'P123', 'de', 'ergab', '2019-12-12 17:08:42.016696', NULL, 'ergab sich aus');
INSERT INTO model.property_i18n VALUES (685, 'P123', 'en', 'resulted in', '2019-12-12 17:08:42.016696', NULL, 'resulted from');
INSERT INTO model.property_i18n VALUES (687, 'P123', 'ru', 'повлек появление', '2019-12-12 17:08:42.016696', NULL, 'был результатом');
INSERT INTO model.property_i18n VALUES (688, 'P123', 'el', 'είχε ως αποτέλεσμα', '2019-12-12 17:08:42.016696', NULL, 'προέκυψε από');
INSERT INTO model.property_i18n VALUES (689, 'P123', 'pt', 'resultou em', '2019-12-12 17:08:42.016696', NULL, 'resultado de');
INSERT INTO model.property_i18n VALUES (690, 'P123', 'zh', '转变出', '2019-12-12 17:08:42.016696', NULL, '肇因於');
INSERT INTO model.property_i18n VALUES (691, 'P103', 'de', 'bestimmt für', '2019-12-12 17:08:42.016696', NULL, 'war Bestimmung von');
INSERT INTO model.property_i18n VALUES (692, 'P103', 'en', 'was intended for', '2019-12-12 17:08:42.016696', NULL, 'was intention of');
INSERT INTO model.property_i18n VALUES (693, 'P103', 'fr', 'était destiné à', '2019-12-12 17:08:42.016696', NULL, 'était la raison d''être de');
INSERT INTO model.property_i18n VALUES (694, 'P103', 'ru', 'был задуман для', '2019-12-12 17:08:42.016696', NULL, 'был интенцией для');
INSERT INTO model.property_i18n VALUES (695, 'P103', 'el', 'προοριζόταν για', '2019-12-12 17:08:42.016696', NULL, 'ήταν προορισμός του');
INSERT INTO model.property_i18n VALUES (696, 'P103', 'pt', 'era destinado à', '2019-12-12 17:08:42.016696', NULL, 'era a destinação de');
INSERT INTO model.property_i18n VALUES (697, 'P103', 'zh', '被制作来用於', '2019-12-12 17:08:42.016696', NULL, NULL);
INSERT INTO model.property_i18n VALUES (698, 'P86', 'de', 'fällt in', '2019-12-12 17:08:42.016696', NULL, 'enthält');
INSERT INTO model.property_i18n VALUES (699, 'P86', 'en', 'falls within', '2019-12-12 17:08:42.016696', NULL, 'contains');
INSERT INTO model.property_i18n VALUES (700, 'P86', 'fr', 's’insère dans', '2019-12-12 17:08:42.016696', NULL, 'inclut');
INSERT INTO model.property_i18n VALUES (701, 'P86', 'ru', 'содержится в', '2019-12-12 17:08:42.016696', NULL, 'содержит');
INSERT INTO model.property_i18n VALUES (702, 'P86', 'el', 'περιέχεται σε', '2019-12-12 17:08:42.016696', NULL, 'περιέχει');
INSERT INTO model.property_i18n VALUES (703, 'P86', 'pt', 'está contido em', '2019-12-12 17:08:42.016696', NULL, 'contém');
INSERT INTO model.property_i18n VALUES (704, 'P86', 'zh', '时间上被涵盖於', '2019-12-12 17:08:42.016696', NULL, '时间上涵盖了');
INSERT INTO model.property_i18n VALUES (705, 'P140', 'de', 'wies Merkmal zu', '2019-12-12 17:08:42.016696', NULL, 'bekam Merkmal zugewiesen durch');
INSERT INTO model.property_i18n VALUES (706, 'P140', 'en', 'assigned attribute to', '2019-12-12 17:08:42.016696', NULL, 'was attributed by');
INSERT INTO model.property_i18n VALUES (707, 'P140', 'fr', 'a affecté un attribut à', '2019-12-12 17:08:42.016696', NULL, 'a reçu un attribut par');
INSERT INTO model.property_i18n VALUES (708, 'P140', 'ru', 'присвоил атрибут для', '2019-12-12 17:08:42.016696', NULL, 'получил атрибут посредством');
INSERT INTO model.property_i18n VALUES (709, 'P140', 'el', 'απέδωσε ιδιότητα σε', '2019-12-12 17:08:42.016696', NULL, 'χαρακτηρίστηκε από');
INSERT INTO model.property_i18n VALUES (710, 'P140', 'pt', 'atribuiu atributo para', '2019-12-12 17:08:42.016696', NULL, 'foi atribuído por');
INSERT INTO model.property_i18n VALUES (711, 'P140', 'zh', '指定属性给', '2019-12-12 17:08:42.016696', NULL, '被指定属性於');
INSERT INTO model.property_i18n VALUES (712, 'P139', 'de', 'hat alternative Form', '2019-12-12 17:08:42.016696', NULL, NULL);
INSERT INTO model.property_i18n VALUES (713, 'P139', 'en', 'has alternative form', '2019-12-12 17:08:42.016696', NULL, NULL);
INSERT INTO model.property_i18n VALUES (714, 'P139', 'fr', 'a pour autre forme', '2019-12-12 17:08:42.016696', NULL, NULL);
INSERT INTO model.property_i18n VALUES (715, 'P139', 'ru', 'имеет альтернативную форму', '2019-12-12 17:08:42.016696', NULL, NULL);
INSERT INTO model.property_i18n VALUES (716, 'P139', 'el', 'έχει εναλλακτική μορφή', '2019-12-12 17:08:42.016696', NULL, NULL);
INSERT INTO model.property_i18n VALUES (717, 'P139', 'pt', 'tem forma alternativa', '2019-12-12 17:08:42.016696', NULL, NULL);
INSERT INTO model.property_i18n VALUES (718, 'P139', 'zh', '有替代称号', '2019-12-12 17:08:42.016696', NULL, NULL);
INSERT INTO model.property_i18n VALUES (719, 'P94', 'de', 'hat erschaffen', '2019-12-12 17:08:42.016696', NULL, 'wurde erschaffen durch');
INSERT INTO model.property_i18n VALUES (720, 'P94', 'en', 'has created', '2019-12-12 17:08:42.016696', NULL, 'was created by');
INSERT INTO model.property_i18n VALUES (721, 'P94', 'fr', 'a créé', '2019-12-12 17:08:42.016696', NULL, 'a été créé par');
INSERT INTO model.property_i18n VALUES (722, 'P94', 'ru', 'создал', '2019-12-12 17:08:42.016696', NULL, 'был создан посредством');
INSERT INTO model.property_i18n VALUES (723, 'P94', 'el', 'δημιούργησε', '2019-12-12 17:08:42.016696', NULL, 'δημιουργήθηκε από');
INSERT INTO model.property_i18n VALUES (724, 'P94', 'pt', 'criou', '2019-12-12 17:08:42.016696', NULL, 'foi criado por');
INSERT INTO model.property_i18n VALUES (725, 'P94', 'zh', '创造了', '2019-12-12 17:08:42.016696', NULL, '被创造於');
INSERT INTO model.property_i18n VALUES (726, 'P115', 'de', 'beendet', '2019-12-12 17:08:42.016696', NULL, 'wurde beendet mit');
INSERT INTO model.property_i18n VALUES (727, 'P115', 'en', 'finishes', '2019-12-12 17:08:42.016696', NULL, 'is finished by');
INSERT INTO model.property_i18n VALUES (728, 'P115', 'fr', 'termine', '2019-12-12 17:08:42.016696', NULL, 'est terminée par');
INSERT INTO model.property_i18n VALUES (729, 'P115', 'ru', 'заканчивает', '2019-12-12 17:08:42.016696', NULL, 'заканчивается');
INSERT INTO model.property_i18n VALUES (730, 'P115', 'el', 'περατώνει', '2019-12-12 17:08:42.016696', NULL, 'περατώνεται με');
INSERT INTO model.property_i18n VALUES (731, 'P115', 'pt', 'finaliza', '2019-12-12 17:08:42.016696', NULL, 'é finalizada por');
INSERT INTO model.property_i18n VALUES (732, 'P115', 'zh', '结束了', '2019-12-12 17:08:42.016696', NULL, '被结束于');
INSERT INTO model.property_i18n VALUES (733, 'P46', 'de', 'ist zusammengesetzt aus', '2019-12-12 17:08:42.016696', NULL, 'bildet Teil von');
INSERT INTO model.property_i18n VALUES (734, 'P46', 'en', 'is composed of', '2019-12-12 17:08:42.016696', NULL, 'forms part of');
INSERT INTO model.property_i18n VALUES (735, 'P46', 'fr', 'est composée de', '2019-12-12 17:08:42.016696', NULL, 'fait partie de');
INSERT INTO model.property_i18n VALUES (736, 'P46', 'ru', 'составлен из', '2019-12-12 17:08:42.016696', NULL, 'формирует часть');
INSERT INTO model.property_i18n VALUES (737, 'P46', 'el', 'αποτελείται από', '2019-12-12 17:08:42.016696', NULL, 'αποτελεί μέρος του/της');
INSERT INTO model.property_i18n VALUES (738, 'P46', 'pt', 'é composto de', '2019-12-12 17:08:42.016696', NULL, 'faz parte de');
INSERT INTO model.property_i18n VALUES (739, 'P46', 'zh', '有组件', '2019-12-12 17:08:42.016696', NULL, '被用来组成');
INSERT INTO model.property_i18n VALUES (740, 'P126', 'de', 'verwendete', '2019-12-12 17:08:42.016696', NULL, 'wurde verwendet bei');
INSERT INTO model.property_i18n VALUES (741, 'P126', 'en', 'employed', '2019-12-12 17:08:42.016696', NULL, 'was employed in');
INSERT INTO model.property_i18n VALUES (742, 'P126', 'fr', 'a employé', '2019-12-12 17:08:42.016696', NULL, 'a été employé dans');
INSERT INTO model.property_i18n VALUES (743, 'P126', 'ru', 'использовал', '2019-12-12 17:08:42.016696', NULL, 'использовался в');
INSERT INTO model.property_i18n VALUES (744, 'P126', 'el', 'χρησιμοποίησε', '2019-12-12 17:08:42.016696', NULL, 'χρησιμοποιήθηκε σε');
INSERT INTO model.property_i18n VALUES (745, 'P126', 'pt', 'empregou', '2019-12-12 17:08:42.016696', NULL, 'foi empregado em');
INSERT INTO model.property_i18n VALUES (746, 'P126', 'zh', '采用了材料', '2019-12-12 17:08:42.016696', NULL, '被使用於');
INSERT INTO model.property_i18n VALUES (747, 'P143', 'de', 'verband', '2019-12-12 17:08:42.016696', NULL, 'wurde verbunden durch');
INSERT INTO model.property_i18n VALUES (748, 'P143', 'en', 'joined', '2019-12-12 17:08:42.016696', NULL, 'was joined by');
INSERT INTO model.property_i18n VALUES (749, 'P143', 'zh', '加入了成员', '2019-12-12 17:08:42.016696', NULL, '被加入为成员於');
INSERT INTO model.property_i18n VALUES (750, 'P160', 'en', 'has temporal projection', '2019-12-12 17:08:42.016696', NULL, 'is temporal projection of');
INSERT INTO model.property_i18n VALUES (751, 'P10', 'de', 'fällt in', '2019-12-12 17:08:42.016696', NULL, 'enthält');
INSERT INTO model.property_i18n VALUES (752, 'P10', 'en', 'falls within', '2019-12-12 17:08:42.016696', NULL, 'contains');
INSERT INTO model.property_i18n VALUES (753, 'P10', 'fr', 's’insère dans le cours de', '2019-12-12 17:08:42.016696', NULL, 'contient');
INSERT INTO model.property_i18n VALUES (754, 'P10', 'ru', 'находится в пределах', '2019-12-12 17:08:42.016696', NULL, 'содержит');
INSERT INTO model.property_i18n VALUES (755, 'P10', 'el', 'εμπίπτει', '2019-12-12 17:08:42.016696', NULL, 'περιλαμβάνει');
INSERT INTO model.property_i18n VALUES (756, 'P10', 'pt', 'está contido em', '2019-12-12 17:08:42.016696', NULL, 'contém');
INSERT INTO model.property_i18n VALUES (757, 'P10', 'zh', '发生时间涵盖於', '2019-12-12 17:08:42.016696', NULL, '时间上涵盖');
INSERT INTO model.property_i18n VALUES (758, 'P74', 'de', 'hat derzeitigen oder früheren Sitz', '2019-12-12 17:08:42.016696', NULL, 'ist derzeitiger oder früherer Sitz von');
INSERT INTO model.property_i18n VALUES (759, 'P74', 'en', 'has current or former residence', '2019-12-12 17:08:42.016696', NULL, 'is current or former residence of');
INSERT INTO model.property_i18n VALUES (760, 'P74', 'fr', 'réside ou a résidé à', '2019-12-12 17:08:42.016696', NULL, 'est ou a été la résidence de');
INSERT INTO model.property_i18n VALUES (761, 'P74', 'ru', 'имеет текущее или бывшее местожительства', '2019-12-12 17:08:42.016696', NULL, 'является текущим или бывшим местом жительства для');
INSERT INTO model.property_i18n VALUES (762, 'P74', 'el', 'έχει ή είχε κατοικία', '2019-12-12 17:08:42.016696', NULL, 'είναι ή ήταν κατοικία του/της');
INSERT INTO model.property_i18n VALUES (763, 'P74', 'pt', 'reside ou residiu em', '2019-12-12 17:08:42.016696', NULL, 'é ou foi residência de');
INSERT INTO model.property_i18n VALUES (764, 'P74', 'zh', '目前或曾经居住於', '2019-12-12 17:08:42.016696', NULL, '历年来的居住者包括');
INSERT INTO model.property_i18n VALUES (765, 'P147', 'de', 'betreute kuratorisch', '2019-12-12 17:08:42.016696', NULL, 'wurde kuratorisch betreut durch');
INSERT INTO model.property_i18n VALUES (766, 'P147', 'en', 'curated', '2019-12-12 17:08:42.016696', NULL, 'was curated by');
INSERT INTO model.property_i18n VALUES (767, 'P147', 'zh', '典藏管理了', '2019-12-12 17:08:42.016696', NULL, '被典藏管理於');
INSERT INTO model.property_i18n VALUES (768, 'P59', 'de', 'hat Bereich', '2019-12-12 17:08:42.016696', NULL, 'befindet sich auf oder in');
INSERT INTO model.property_i18n VALUES (769, 'P59', 'en', 'has section', '2019-12-12 17:08:42.016696', NULL, 'is located on or within');
INSERT INTO model.property_i18n VALUES (770, 'P59', 'fr', 'a pour section', '2019-12-12 17:08:42.016696', NULL, 'se situe sur ou dans');
INSERT INTO model.property_i18n VALUES (771, 'P59', 'ru', 'имеет район', '2019-12-12 17:08:42.016696', NULL, 'находится на или внутри');
INSERT INTO model.property_i18n VALUES (772, 'P59', 'el', 'έχει τομέα', '2019-12-12 17:08:42.016696', NULL, 'βρίσκεται σε ή εντός');
INSERT INTO model.property_i18n VALUES (773, 'P59', 'pt', 'tem seção', '2019-12-12 17:08:42.016696', NULL, 'está localizada sobre ou dentro de');
INSERT INTO model.property_i18n VALUES (774, 'P59', 'zh', '有区域', '2019-12-12 17:08:42.016696', NULL, '位於');
INSERT INTO model.property_i18n VALUES (775, 'P109', 'de', 'hat derzeitigen oder früheren Kurator', '2019-12-12 17:08:42.016696', NULL, 'ist derzeitiger oder früherer Kurator von');
INSERT INTO model.property_i18n VALUES (776, 'P109', 'en', 'has current or former curator', '2019-12-12 17:08:42.016696', NULL, 'is current or former curator of');
INSERT INTO model.property_i18n VALUES (777, 'P109', 'fr', 'a pour conservateur actuel ou ancien', '2019-12-12 17:08:42.016696', NULL, 'est ou a été le conservateur de');
INSERT INTO model.property_i18n VALUES (778, 'P109', 'ru', 'имеет действующего или бывшего хранителя', '2019-12-12 17:08:42.016696', NULL, 'является действующим или бывшим хранителем');
INSERT INTO model.property_i18n VALUES (779, 'P109', 'el', 'έχει ή είχε επιμελητή', '2019-12-12 17:08:42.016696', NULL, 'είναι ή ήταν επιμελητής του/της');
INSERT INTO model.property_i18n VALUES (780, 'P109', 'pt', 'tem ou teve curador', '2019-12-12 17:08:42.016696', NULL, 'é ou foi curador de');
INSERT INTO model.property_i18n VALUES (781, 'P109', 'zh', '有现任或前任典藏管理员', '2019-12-12 17:08:42.016696', NULL, '目前或曾经典藏管理');
INSERT INTO model.property_i18n VALUES (782, 'P122', 'de', 'grenzt an', '2019-12-12 17:08:42.016696', NULL, NULL);
INSERT INTO model.property_i18n VALUES (783, 'P122', 'en', 'borders with', '2019-12-12 17:08:42.016696', NULL, NULL);
INSERT INTO model.property_i18n VALUES (784, 'P122', 'fr', 'jouxte', '2019-12-12 17:08:42.016696', NULL, NULL);
INSERT INTO model.property_i18n VALUES (785, 'P122', 'ru', 'граничит с', '2019-12-12 17:08:42.016696', NULL, NULL);
INSERT INTO model.property_i18n VALUES (786, 'P122', 'el', 'συνορεύει με', '2019-12-12 17:08:42.016696', NULL, NULL);
INSERT INTO model.property_i18n VALUES (787, 'P122', 'pt', 'fronteira com', '2019-12-12 17:08:42.016696', NULL, NULL);
INSERT INTO model.property_i18n VALUES (788, 'P122', 'zh', '接壤于', '2019-12-12 17:08:42.016696', NULL, NULL);
INSERT INTO model.property_i18n VALUES (789, 'P101', 'de', 'hatte die allgemeine Verwendung', '2019-12-12 17:08:42.016696', NULL, 'war die Verwendung von');
INSERT INTO model.property_i18n VALUES (790, 'P101', 'en', 'had as general use', '2019-12-12 17:08:42.016696', NULL, 'was use of');
INSERT INTO model.property_i18n VALUES (791, 'P101', 'fr', 'avait comme utilisation générale', '2019-12-12 17:08:42.016696', NULL, 'était l’utilisation de');
INSERT INTO model.property_i18n VALUES (792, 'P101', 'ru', 'имел основное применение', '2019-12-12 17:08:42.016696', NULL, 'был применением для');
INSERT INTO model.property_i18n VALUES (793, 'P101', 'el', 'είχε ως γενική χρήση', '2019-12-12 17:08:42.016696', NULL, 'ήταν χρήση του/της');
INSERT INTO model.property_i18n VALUES (794, 'P101', 'pt', 'tem como uso geral', '2019-12-12 17:08:42.016696', NULL, 'foi uso de');
INSERT INTO model.property_i18n VALUES (795, 'P101', 'zh', '被惯用於', '2019-12-12 17:08:42.016696', NULL, '可使用');
INSERT INTO model.property_i18n VALUES (796, 'P148', 'de', 'hat Bestandteil', '2019-12-12 17:08:42.016696', NULL, 'ist Bestandteil von');
INSERT INTO model.property_i18n VALUES (797, 'P148', 'en', 'has component', '2019-12-12 17:08:42.016696', NULL, 'is component of');
INSERT INTO model.property_i18n VALUES (798, 'P148', 'zh', '有组件', '2019-12-12 17:08:42.016696', NULL, '被用来组成');
INSERT INTO model.property_i18n VALUES (799, 'P54', 'de', 'hat derzeitigen permanenten Standort', '2019-12-12 17:08:42.016696', NULL, 'ist derzeitiger permanenter Standort von');
INSERT INTO model.property_i18n VALUES (800, 'P54', 'en', 'has current permanent location', '2019-12-12 17:08:42.016696', NULL, 'is current permanent location of');
INSERT INTO model.property_i18n VALUES (801, 'P54', 'fr', 'a actuellement pour localisation à demeure', '2019-12-12 17:08:42.016696', NULL, 'est actuellement localisation à demeure de');
INSERT INTO model.property_i18n VALUES (802, 'P54', 'ru', 'имеет текущее постоянное местоположение', '2019-12-12 17:08:42.016696', NULL, 'является текущим постоянным местоположением для');
INSERT INTO model.property_i18n VALUES (803, 'P54', 'el', 'έχει μόνιμη θέση', '2019-12-12 17:08:42.016696', NULL, 'είναι μόνιμη θέση του/της');
INSERT INTO model.property_i18n VALUES (804, 'P54', 'pt', 'é localizado permanentemente em', '2019-12-12 17:08:42.016696', NULL, 'é localização permanente de');
INSERT INTO model.property_i18n VALUES (805, 'P54', 'zh', '目前的永久位置位於', '2019-12-12 17:08:42.016696', NULL, '目前被用来永久置放');
INSERT INTO model.property_i18n VALUES (806, 'P125', 'de', 'benutzte Objekt des Typus', '2019-12-12 17:08:42.016696', NULL, 'Objekt des Typus ... wurde benutzt in');
INSERT INTO model.property_i18n VALUES (807, 'P125', 'en', 'used object of type', '2019-12-12 17:08:42.016696', NULL, 'was type of object used in');
INSERT INTO model.property_i18n VALUES (808, 'P125', 'fr', 'a employé un objet du type', '2019-12-12 17:08:42.016696', NULL, 'était le type d’objet employé par');
INSERT INTO model.property_i18n VALUES (809, 'P125', 'ru', 'использовал объект типа', '2019-12-12 17:08:42.016696', NULL, 'был типом объекта использованного в');
INSERT INTO model.property_i18n VALUES (810, 'P125', 'el', 'χρησιμοποίησε αντικείμενο τύπου', '2019-12-12 17:08:42.016696', NULL, 'ήταν o τύπος αντικείμενου που χρησιμοποιήθηκε σε');
INSERT INTO model.property_i18n VALUES (811, 'P125', 'pt', 'usou objeto do tipo', '2019-12-12 17:08:42.016696', NULL, 'foi tipo do objeto usado em');
INSERT INTO model.property_i18n VALUES (812, 'P125', 'zh', '有使用物件类型', '2019-12-12 17:08:42.016696', NULL, '被使用於');
INSERT INTO model.property_i18n VALUES (813, 'P120', 'de', 'kommt vor', '2019-12-12 17:08:42.016696', NULL, 'kommt nach');
INSERT INTO model.property_i18n VALUES (814, 'P120', 'en', 'occurs before', '2019-12-12 17:08:42.016696', NULL, 'occurs after');
INSERT INTO model.property_i18n VALUES (815, 'P120', 'fr', 'a lieu avant', '2019-12-12 17:08:42.016696', NULL, 'a lieu après');
INSERT INTO model.property_i18n VALUES (816, 'P120', 'ru', 'появляется до', '2019-12-12 17:08:42.016696', NULL, 'появляется после');
INSERT INTO model.property_i18n VALUES (817, 'P120', 'el', 'εμφανίζεται πριν', '2019-12-12 17:08:42.016696', NULL, 'εμφανίζεται μετά');
INSERT INTO model.property_i18n VALUES (818, 'P120', 'pt', 'ocorre antes', '2019-12-12 17:08:42.016696', NULL, 'ocorre depois');
INSERT INTO model.property_i18n VALUES (819, 'P120', 'zh', '发生时段先於', '2019-12-12 17:08:42.016696', NULL, '发生时段后於');
INSERT INTO model.property_i18n VALUES (820, 'P151', 'en', 'was formed from', '2019-12-12 17:08:42.016696', NULL, 'participated in');
INSERT INTO model.property_i18n VALUES (821, 'P29', 'de', 'übertrug Gewahrsam auf', '2019-12-12 17:08:42.016696', NULL, 'erhielt Gewahrsam durch');
INSERT INTO model.property_i18n VALUES (822, 'P29', 'en', 'custody received by', '2019-12-12 17:08:42.016696', NULL, 'received custody through');
INSERT INTO model.property_i18n VALUES (823, 'P29', 'fr', 'changement de détenteur au profit de', '2019-12-12 17:08:42.016696', NULL, 'est devenu détenteur grâce à');
INSERT INTO model.property_i18n VALUES (824, 'P29', 'ru', 'опека получена', '2019-12-12 17:08:42.016696', NULL, 'получил опеку через');
INSERT INTO model.property_i18n VALUES (825, 'P29', 'el', 'μετεβίβασε κατοχή σε', '2019-12-12 17:08:42.016696', NULL, 'παρέλαβε κατοχή μέσω');
INSERT INTO model.property_i18n VALUES (826, 'P29', 'pt', 'custódia recebida por', '2019-12-12 17:08:42.016696', NULL, 'início da custódia por meio de');
INSERT INTO model.property_i18n VALUES (827, 'P29', 'zh', '移转保管作业给', '2019-12-12 17:08:42.016696', NULL, '取得保管作业於');
INSERT INTO model.property_i18n VALUES (828, 'P89', 'de', 'fällt in', '2019-12-12 17:08:42.016696', NULL, 'enthält');
INSERT INTO model.property_i18n VALUES (829, 'P89', 'en', 'falls within', '2019-12-12 17:08:42.016696', NULL, 'contains');
INSERT INTO model.property_i18n VALUES (830, 'P89', 'fr', 's’insère dans', '2019-12-12 17:08:42.016696', NULL, 'inclut');
INSERT INTO model.property_i18n VALUES (831, 'P89', 'ru', 'содержится в', '2019-12-12 17:08:42.016696', NULL, 'содержит');
INSERT INTO model.property_i18n VALUES (832, 'P89', 'el', 'περιέχεται σε', '2019-12-12 17:08:42.016696', NULL, 'περιέχει');
INSERT INTO model.property_i18n VALUES (833, 'P89', 'pt', 'está contido em', '2019-12-12 17:08:42.016696', NULL, 'contém');
INSERT INTO model.property_i18n VALUES (834, 'P89', 'zh', '空间上被包围於', '2019-12-12 17:08:42.016696', NULL, '空间上包含了');
INSERT INTO model.property_i18n VALUES (835, 'P117', 'de', 'fällt in', '2019-12-12 17:08:42.016696', NULL, 'beinhaltet');
INSERT INTO model.property_i18n VALUES (836, 'P117', 'en', 'occurs during', '2019-12-12 17:08:42.016696', NULL, 'includes');
INSERT INTO model.property_i18n VALUES (837, 'P117', 'fr', 'a lieu pendant', '2019-12-12 17:08:42.016696', NULL, 'comporte');
INSERT INTO model.property_i18n VALUES (838, 'P117', 'ru', 'появляется во течение', '2019-12-12 17:08:42.016696', NULL, 'включает');
INSERT INTO model.property_i18n VALUES (839, 'P117', 'el', 'εμφανίζεται κατά τη διάρκεια', '2019-12-12 17:08:42.016696', NULL, 'περιλαμβάνει');
INSERT INTO model.property_i18n VALUES (840, 'P117', 'pt', 'ocorre durante', '2019-12-12 17:08:42.016696', NULL, 'inclui');
INSERT INTO model.property_i18n VALUES (841, 'P117', 'zh', '时段被涵盖於', '2019-12-12 17:08:42.016696', NULL, '时段涵盖了');
INSERT INTO model.property_i18n VALUES (842, 'P127', 'de', 'hat den Oberbegriff', '2019-12-12 17:08:42.016696', NULL, 'hat den Unterbegriff');
INSERT INTO model.property_i18n VALUES (843, 'P127', 'en', 'has broader term', '2019-12-12 17:08:42.016696', NULL, 'has narrower term');
INSERT INTO model.property_i18n VALUES (844, 'P127', 'fr', 'a pour terme générique', '2019-12-12 17:08:42.016696', NULL, 'a pour terme spécifique');
INSERT INTO model.property_i18n VALUES (845, 'P127', 'ru', 'имеет вышестоящий термин', '2019-12-12 17:08:42.016696', NULL, NULL);
INSERT INTO model.property_i18n VALUES (846, 'P127', 'el', 'έχει ευρύτερο όρο', '2019-12-12 17:08:42.016696', NULL, 'έχει στενότερο όρο');
INSERT INTO model.property_i18n VALUES (847, 'P127', 'pt', 'tem termo genérico', '2019-12-12 17:08:42.016696', NULL, 'tem termo específico');
INSERT INTO model.property_i18n VALUES (848, 'P127', 'zh', '有广义术语', '2019-12-12 17:08:42.016696', NULL, '有狭义术语');
INSERT INTO model.property_i18n VALUES (849, 'P13', 'de', 'zerstörte', '2019-12-12 17:08:42.016696', NULL, 'wurde zerstört durch');
INSERT INTO model.property_i18n VALUES (850, 'P13', 'en', 'destroyed', '2019-12-12 17:08:42.016696', NULL, 'was destroyed by');
INSERT INTO model.property_i18n VALUES (851, 'P13', 'fr', 'a détruit', '2019-12-12 17:08:42.016696', NULL, 'a été détruite par');
INSERT INTO model.property_i18n VALUES (852, 'P13', 'ru', 'уничтожил', '2019-12-12 17:08:42.016696', NULL, 'был уничтожен посредством');
INSERT INTO model.property_i18n VALUES (853, 'P13', 'el', 'κατέστρεψε', '2019-12-12 17:08:42.016696', NULL, 'καταστράφηκε από');
INSERT INTO model.property_i18n VALUES (854, 'P13', 'pt', 'destruiu', '2019-12-12 17:08:42.016696', NULL, 'foi destruído por');
INSERT INTO model.property_i18n VALUES (855, 'P13', 'zh', '毁灭了', '2019-12-12 17:08:42.016696', NULL, '被毁灭於');
INSERT INTO model.property_i18n VALUES (856, 'P113', 'de', 'entfernte', '2019-12-12 17:08:42.016696', NULL, 'wurde entfernt durch');
INSERT INTO model.property_i18n VALUES (857, 'P113', 'en', 'removed', '2019-12-12 17:08:42.016696', NULL, 'was removed by');
INSERT INTO model.property_i18n VALUES (858, 'P113', 'fr', 'a enlevé', '2019-12-12 17:08:42.016696', NULL, 'a été enlevée par');
INSERT INTO model.property_i18n VALUES (859, 'P113', 'ru', 'удален', '2019-12-12 17:08:42.016696', NULL, 'был удален посредством');
INSERT INTO model.property_i18n VALUES (860, 'P113', 'el', 'αφαίρεσε', '2019-12-12 17:08:42.016696', NULL, 'αφαιρέθηκε από');
INSERT INTO model.property_i18n VALUES (861, 'P113', 'pt', 'removeu', '2019-12-12 17:08:42.016696', NULL, 'foi removido por');
INSERT INTO model.property_i18n VALUES (862, 'P113', 'zh', '移除了', '2019-12-12 17:08:42.016696', NULL, '被移除於');
INSERT INTO model.property_i18n VALUES (863, 'P11', 'de', 'hatte Teilnehmer', '2019-12-12 17:08:42.016696', NULL, 'nahm Teil an');
INSERT INTO model.property_i18n VALUES (864, 'P11', 'en', 'had participant', '2019-12-12 17:08:42.016696', NULL, 'participated in');
INSERT INTO model.property_i18n VALUES (865, 'P11', 'fr', 'a eu pour participant', '2019-12-12 17:08:42.016696', NULL, 'a participé à');
INSERT INTO model.property_i18n VALUES (866, 'P11', 'ru', 'имел участника', '2019-12-12 17:08:42.016696', NULL, 'участвовал в');
INSERT INTO model.property_i18n VALUES (867, 'P11', 'el', 'είχε συμμέτοχο', '2019-12-12 17:08:42.016696', NULL, 'συμμετείχε σε');
INSERT INTO model.property_i18n VALUES (868, 'P11', 'pt', 'tem participante', '2019-12-12 17:08:42.016696', NULL, 'participa em');
INSERT INTO model.property_i18n VALUES (869, 'P11', 'zh', '有参与者', '2019-12-12 17:08:42.016696', NULL, '参与了');
INSERT INTO model.property_i18n VALUES (870, 'P83', 'de', 'hatte Mindestdauer', '2019-12-12 17:08:42.016696', NULL, 'war Mindestdauer von');
INSERT INTO model.property_i18n VALUES (871, 'P83', 'en', 'had at least duration', '2019-12-12 17:08:42.016696', NULL, 'was minimum duration of');
INSERT INTO model.property_i18n VALUES (872, 'P83', 'fr', 'a duré au moins', '2019-12-12 17:08:42.016696', NULL, 'a été la durée minimum de');
INSERT INTO model.property_i18n VALUES (873, 'P83', 'ru', 'имеет длительность по крайней мере больше чем', '2019-12-12 17:08:42.016696', NULL, 'был минимальной длительностью для');
INSERT INTO model.property_i18n VALUES (874, 'P83', 'el', 'είχε ελάχιστη διάρκεια', '2019-12-12 17:08:42.016696', NULL, 'είναι ελάχιστη διάρκεια του/της');
INSERT INTO model.property_i18n VALUES (875, 'P83', 'pt', 'durou no mínimo', '2019-12-12 17:08:42.016696', NULL, 'foi a duração mínima de');
INSERT INTO model.property_i18n VALUES (876, 'P83', 'zh', '时间最少持续了', '2019-12-12 17:08:42.016696', NULL, NULL);
INSERT INTO model.property_i18n VALUES (877, 'P157', 'en', 'is at rest relative to', '2019-12-12 17:08:42.016696', NULL, 'provides reference space for');
INSERT INTO model.property_i18n VALUES (878, 'P141', 'de', 'wies zu', '2019-12-12 17:08:42.016696', NULL, 'wurde zugewiesen durch');
INSERT INTO model.property_i18n VALUES (879, 'P141', 'en', 'assigned', '2019-12-12 17:08:42.016696', NULL, 'was assigned by');
INSERT INTO model.property_i18n VALUES (880, 'P141', 'fr', 'a attribué', '2019-12-12 17:08:42.016696', NULL, 'a été attribué par');
INSERT INTO model.property_i18n VALUES (881, 'P141', 'ru', 'присвоил', '2019-12-12 17:08:42.016696', NULL, 'был присвоен посредством');
INSERT INTO model.property_i18n VALUES (882, 'P141', 'el', 'απέδωσε', '2019-12-12 17:08:42.016696', NULL, 'αποδόθηκε από');
INSERT INTO model.property_i18n VALUES (883, 'P141', 'pt', 'atribuiu', '2019-12-12 17:08:42.016696', NULL, 'foi atribuído por');
INSERT INTO model.property_i18n VALUES (884, 'P141', 'zh', '指定了属性值', '2019-12-12 17:08:42.016696', NULL, '被指定了属性值於');
INSERT INTO model.property_i18n VALUES (885, 'P145', 'de', 'entließ', '2019-12-12 17:08:42.016696', NULL, 'wurde entlassen durch');
INSERT INTO model.property_i18n VALUES (886, 'P145', 'en', 'separated', '2019-12-12 17:08:42.016696', NULL, 'left by');
INSERT INTO model.property_i18n VALUES (887, 'P145', 'zh', '分离了成员', '2019-12-12 17:08:42.016696', NULL, '脱离群组於');
INSERT INTO model.property_i18n VALUES (888, 'OA7', 'en', 'has relationship to', '2019-12-12 17:08:42.016696', NULL, NULL);
INSERT INTO model.property_i18n VALUES (889, 'OA7', 'de', 'hat Beziehung zu', '2019-12-12 17:08:42.016696', NULL, NULL);
INSERT INTO model.property_i18n VALUES (890, 'OA8', 'en', 'begins in', '2019-12-12 17:08:42.016696', NULL, NULL);
INSERT INTO model.property_i18n VALUES (891, 'OA8', 'de', 'beginnt in', '2019-12-12 17:08:42.016696', NULL, NULL);
INSERT INTO model.property_i18n VALUES (892, 'OA9', 'en', 'ends in', '2019-12-12 17:08:42.016696', NULL, NULL);
INSERT INTO model.property_i18n VALUES (893, 'OA9', 'de', 'endet in', '2019-12-12 17:08:42.016696', NULL, NULL);


--
-- Data for Name: property_inheritance; Type: TABLE DATA; Schema: model; Owner: openatlas
--

INSERT INTO model.property_inheritance VALUES (1, 'P92', 'P95', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.property_inheritance VALUES (2, 'P106', 'P165', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.property_inheritance VALUES (3, 'P1', 'P149', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.property_inheritance VALUES (4, 'P16', 'P33', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.property_inheritance VALUES (5, 'P140', 'P39', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.property_inheritance VALUES (6, 'P10', 'P9', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.property_inheritance VALUES (7, 'P1', 'P102', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.property_inheritance VALUES (8, 'P1', 'P48', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.property_inheritance VALUES (9, 'P141', 'P35', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.property_inheritance VALUES (10, 'P11', 'P96', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.property_inheritance VALUES (11, 'P12', 'P111', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.property_inheritance VALUES (12, 'P16', 'P111', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.property_inheritance VALUES (13, 'P15', 'P134', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.property_inheritance VALUES (14, 'P12', 'P25', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.property_inheritance VALUES (15, 'P46', 'P56', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.property_inheritance VALUES (16, 'P125', 'P32', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.property_inheritance VALUES (17, 'P14', 'P28', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.property_inheritance VALUES (18, 'P140', 'P34', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.property_inheritance VALUES (19, 'P140', 'P41', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.property_inheritance VALUES (20, 'P141', 'P42', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.property_inheritance VALUES (21, 'P93', 'P99', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.property_inheritance VALUES (22, 'P11', 'P99', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.property_inheritance VALUES (23, 'P67', 'P129', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.property_inheritance VALUES (24, 'P128', 'P65', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.property_inheritance VALUES (25, 'P53', 'P55', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.property_inheritance VALUES (26, 'P11', 'P14', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.property_inheritance VALUES (27, 'P15', 'P136', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.property_inheritance VALUES (28, 'P67', 'P68', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.property_inheritance VALUES (29, 'P12', 'P92', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.property_inheritance VALUES (30, 'P1', 'P78', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.property_inheritance VALUES (31, 'P15', 'P16', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.property_inheritance VALUES (32, 'P12', 'P16', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.property_inheritance VALUES (33, 'P1', 'P87', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.property_inheritance VALUES (34, 'P31', 'P108', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.property_inheritance VALUES (35, 'P92', 'P108', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.property_inheritance VALUES (36, 'P93', 'P100', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.property_inheritance VALUES (37, 'P94', 'P135', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.property_inheritance VALUES (38, 'P16', 'P142', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.property_inheritance VALUES (39, 'P141', 'P40', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.property_inheritance VALUES (40, 'P14', 'P22', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.property_inheritance VALUES (41, 'P67', 'P138', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.property_inheritance VALUES (42, 'P130', 'P73', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.property_inheritance VALUES (43, 'P31', 'P112', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.property_inheritance VALUES (44, 'P67', 'P71', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.property_inheritance VALUES (45, 'P11', 'P146', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.property_inheritance VALUES (46, 'P161', 'P156', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.property_inheritance VALUES (47, 'P130', 'P128', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.property_inheritance VALUES (48, 'P141', 'P37', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.property_inheritance VALUES (49, 'P31', 'P110', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.property_inheritance VALUES (50, 'P12', 'P93', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.property_inheritance VALUES (51, 'P12', 'P31', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.property_inheritance VALUES (52, 'P67', 'P70', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.property_inheritance VALUES (53, 'P14', 'P23', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.property_inheritance VALUES (54, 'P49', 'P50', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.property_inheritance VALUES (55, 'P15', 'P17', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.property_inheritance VALUES (56, 'P93', 'P124', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.property_inheritance VALUES (57, 'P1', 'P131', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.property_inheritance VALUES (58, 'P2', 'P137', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.property_inheritance VALUES (59, 'P105', 'P52', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.property_inheritance VALUES (60, 'P51', 'P52', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.property_inheritance VALUES (61, 'P160', 'P164', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.property_inheritance VALUES (62, 'P11', 'P144', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.property_inheritance VALUES (63, 'P92', 'P98', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.property_inheritance VALUES (64, 'P141', 'P38', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.property_inheritance VALUES (65, 'P92', 'P123', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.property_inheritance VALUES (66, 'P92', 'P94', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.property_inheritance VALUES (67, 'P11', 'P143', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.property_inheritance VALUES (68, 'P49', 'P109', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.property_inheritance VALUES (69, 'P11', 'P151', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.property_inheritance VALUES (70, 'P14', 'P29', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.property_inheritance VALUES (71, 'P93', 'P13', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.property_inheritance VALUES (72, 'P12', 'P113', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.property_inheritance VALUES (73, 'P12', 'P11', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.property_inheritance VALUES (74, 'P59', 'P157', '2019-12-12 17:08:42.016696', NULL);
INSERT INTO model.property_inheritance VALUES (75, 'P11', 'P145', '2019-12-12 17:08:42.016696', NULL);


--
-- Name: class_i18n_id_seq; Type: SEQUENCE SET; Schema: model; Owner: openatlas
--

SELECT pg_catalog.setval('model.class_i18n_id_seq', 555, true);


--
-- Name: class_id_seq; Type: SEQUENCE SET; Schema: model; Owner: openatlas
--

SELECT pg_catalog.setval('model.class_id_seq', 84, true);


--
-- Name: class_inheritance_id_seq; Type: SEQUENCE SET; Schema: model; Owner: openatlas
--

SELECT pg_catalog.setval('model.class_inheritance_id_seq', 98, true);


--
-- Name: property_i18n_id_seq; Type: SEQUENCE SET; Schema: model; Owner: openatlas
--

SELECT pg_catalog.setval('model.property_i18n_id_seq', 893, true);


--
-- Name: property_id_seq; Type: SEQUENCE SET; Schema: model; Owner: openatlas
--

SELECT pg_catalog.setval('model.property_id_seq', 144, true);


--
-- Name: property_inheritance_id_seq; Type: SEQUENCE SET; Schema: model; Owner: openatlas
--

SELECT pg_catalog.setval('model.property_inheritance_id_seq', 75, true);


--
-- PostgreSQL database dump complete
--

