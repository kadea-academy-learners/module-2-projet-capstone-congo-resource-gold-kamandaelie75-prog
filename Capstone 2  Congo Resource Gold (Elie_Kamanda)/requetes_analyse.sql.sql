/* SGBD utiliser : POSTGRESQL */

/* MISSION A : Exploration et Audit (SQL) */



/* Inventaire : Compter le nombre d'engins par site */
SELECT COUNT(type) AS Engins
FROM engins 

SELECT COUNT(e.type) AS Engins,
       s.nom
FROM engins e
LEFT JOIN sites s 
ON e.id_site = s.id_site
GROUP BY s.nom

/*Jointure de contrôle : Afficher la liste des engins avec le nom de leur site respectif (au lieu de l'ID).*/
SELECT e.type AS Engins,
       s.nom AS sites
FROM engins e
LEFT JOIN sites s
ON e.id_site = s.id_site

/* Les minerai extrait avec 0 zero tonnage et teneur 
Vérification : Identifier s'il y a des jours où la production a été nulle (Tonnage = 0 */
SELECT date_prod,
       type_minerai,
	   tonnage_brut,
	   teneur
FROM production 
WHERE tonnage_brut = 0;





/* MISSION B : Intelligence Métier et KPIs (SQL Avancé)*/

/* Production Totale : Somme du tonnage brut par Province 
et par Type de Minerai.*/
SELECT p.type_minerai,
       SUM(p.tonnage_brut) AS somme,
	   s.province
FROM production p
INNER JOIN sites s
ON p.id_site = s.id_site
GROUP BY type_minerai,s.province

/* Verification pour la province de haut katanga qui n'as pas 
produit de cobalt seulement du cuivre*/
SELECT  p.type_minerai,
        p.tonnage_brut,
		s.province
FROM production p
LEFT JOIN sites s
ON p.id_site = S.id_site
WHERE s.province = 'Haut-Katanga' 
AND p.type_minerai = 'Cobalt'
/*Calcul du "Contenu Fin" : Le tonnage de métal pur (Tonnage Brut * Teneur %)*/
SELECT  type_minerai AS tonnage_brut_total,
        tonnage_brut ,
	    teneur,
		((tonnage_brut * teneur) /100) AS tonnage_pure
FROM production 
/* En groupant par type de minerai */
SELECT  
    type_minerai,
    ROUND(SUM(tonnage_brut)::numeric, 2) AS tonnage_brut_total,
    ROUND(AVG(teneur)::numeric, 2) AS teneur_moyenne,
    ROUND(SUM((tonnage_brut * teneur) / 100)::numeric, 2) AS tonnage_pur
FROM production
GROUP BY type_minerai;

/* Analyse Financière : Chiffre d'affaires total par site (Tonnage Vendu * Prix Unitaire).
*/ 
SELECT 
    s.nom,
	SUM(e.prix_unitaire_usd) AS prix_unitaire_total, 
    SUM(e.tonnage_vendu) AS tonnage_total,
    ROUND(SUM((e.tonnage_vendu * e.prix_unitaire_usd))::numeric, 2) AS chiffre_affaire
FROM exportations e
LEFT JOIN sites s 
ON e.id_site = s.id_site
GROUP BY s.nom;

/* Alerte Teneur : Lister les sites dont la teneur moyenne est inférieure à 2.5% (seuil de rentabilité)*/
SELECT p.type_minerai,
       SUM(p.teneur) AS compte,
	   s.nom
FROM production p
LEFT JOIN sites s
ON p.id_site = s.id_site
GROUP BY s.nom,p.type_minerai





