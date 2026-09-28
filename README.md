# Guide des Familles - Communauté de Communes Berry Loire Puisaye

Site web d'information à destination des familles du territoire de la Communauté de Communes Berry Loire Puisaye (CCBLP) : petite enfance, enfance, jeunesse, parentalité, loisirs, accès aux droits, interlocuteurs et structures locales.

**Site en ligne :** https://communicationparentalite.github.io/guide-des-familles-ccblp/

---

## Sommaire

1. [Contenu du site](#contenu-du-site)
2. [Comment le site fonctionne](#comment-le-site-fonctionne)
3. [Mettre à jour le contenu](#mettre-à-jour-le-contenu)
4. [Ajouter une nouvelle page](#ajouter-une-nouvelle-page)
5. [Publication automatique](#publication-automatique)
6. [Recherche, sitemap et référencement](#recherche-sitemap-et-référencement)
7. [Bonnes pratiques](#bonnes-pratiques)
8. [Fichiers hérités à nettoyer](#fichiers-hérités-à-nettoyer)
9. [Contact](#contact)

---

## Contenu du site

| Page | Fichier | Contenu |
|---|---|---|
| Accueil | `index.html` | Présentation du guide et accès aux rubriques |
| Interlocuteurs | `interlocuteurs.html` | Institutions et partenaires (CAF, MSA, PMI, ADS...) |
| Arrivée d'un enfant | `arrivee-enfant.html` | Démarches et informations pour les nouveaux parents |
| Petite enfance (0-5 ans) | `petite-enfance.html` | Guichet unique, multi-accueils, MAM, assistants maternels, LAEP, PMI |
| Enfance | `enfance.html` | Écoles, périscolaire, accompagnement à la scolarité |
| Jeunesse | `jeunesse.html` | Actions et structures pour les jeunes |
| Parentalité | `parentalite.html` | Soutien et ateliers pour les parents |
| Loisirs | `loisirs.html` | Activités culturelles, sportives et de loisirs |
| Vivre ensemble | `vivre-ensemble.html` | Vie sociale, animation et solidarité locale |
| Accès aux droits | `acces-droits.html` | Aides, services et démarches |
| Glossaire | `glossaire.html` | Signification des sigles utilisés dans le guide |
| Mentions légales | `mentions-legales.html` | Informations légales |

---

## Comment le site fonctionne

C'est un **site statique** : uniquement du HTML, du CSS et du JavaScript, sans base de données ni framework. Il est hébergé gratuitement par **GitHub Pages**.

Fichiers importants :

- **`script.js`** : le fichier central. Il génère automatiquement, sur toutes les pages, l'**en-tête**, le **menu de navigation** et le **pied de page**, et gère les accordéons (sections dépliables), les boutons « Lire la suite » et l'impression par section.
- **`styles.css`** : la feuille de style utilisée par toutes les pages.
- **`fonts.css`** et le dossier **`fonts/`** : les polices du site.
- **`carte-ecoles.js`** et les fichiers **`.geojson`** : la carte interactive des écoles.
- **Une couleur par rubrique** : chaque page a une classe (par exemple `page-petite-enfance`) qui définit ses couleurs. Le bloc de couleurs est déclaré dans la balise `<style>` de la page.

> **Important :** ne modifiez pas le texte `<!-- LAST_UPDATED -->` dans `script.js`. Il est remplacé automatiquement, à chaque publication, par la date de dernière mise à jour affichée sur le site.

---

## Mettre à jour le contenu

Tout se fait directement depuis l'interface web de GitHub, sans installer de logiciel.

### Modifier un texte, un horaire, un numéro de téléphone

1. Sur GitHub, ouvrez le fichier de la page concernée (par exemple `petite-enfance.html`).
2. Cliquez sur l'icône crayon (Edit this file).
3. Utilisez `Ctrl + F` pour retrouver le texte à modifier, puis corrigez-le.
4. Cliquez sur **Commit changes**, avec un court message (par exemple « Mise à jour horaires multi-accueil »).
5. Attendez 1 à 2 minutes : le site se met à jour tout seul.

### Ajouter ou remplacer une image

1. **Add file** puis **Upload files**, et déposez l'image à la racine du dépôt.
2. Référencez-la dans la page avec `<img src="nom-du-fichier.png" alt="Description de l'image">`.

Pour les noms de fichiers : minuscules, tirets à la place des espaces, pas d'accents ni de double extension (`marelle-briare.png` plutôt que `Marelle Briare.png`). Renseignez toujours un texte `alt` descriptif (accessibilité).

### Ajouter un sigle au glossaire

Dans `glossaire.html`, copiez un bloc existant et adaptez-le :

```html
<div class="glossaire-item">
    <dt>SIGLE<span class="glossaire-sigle-full">Signification complète</span></dt>
    <dd>Explication en une ou deux phrases simples.</dd>
</div>
```

Placez-le dans la bonne lettre, en respectant l'ordre alphabétique. Si la lettre n'existe pas encore, ajoutez aussi son titre de section et son lien dans la navigation A-Z en haut de page.

---

## Ajouter une nouvelle page

1. **Dupliquer une page existante** proche de ce que vous voulez faire (par exemple `acces-droits.html`) et la renommer en minuscules avec des tirets (`ma-page.html`).
2. Dans le nouveau fichier, adapter :
   - la balise `<title>` et les balises `og:title`, `og:description`, `og:url`, `og:image` (l'adresse doit contenir `guide-des-familles-ccblp`) ;
   - la classe du `<body>` (par exemple `page-ma-page`) et le bloc de couleurs correspondant ;
   - le contenu.
3. **Ajouter la page au menu** dans `script.js` (fonction du menu de navigation, et liste des pages pour la mise en évidence de la page active). Pour une page « utilitaire », on peut ne l'ajouter que dans le pied de page (fonction `initFooter`), comme pour le glossaire et les mentions légales.
4. **Ajouter la page à `sitemap.xml`** (un bloc `<url>` de plus).
5. Valider (commit) : la page est automatiquement indexée par la recherche interne.

---

## Publication automatique

Le fichier `.github/workflows/deploy.yml` s'exécute à chaque modification de la branche `main` (donc à chaque « Commit changes »). Il :

1. récupère la date du dernier commit et l'injecte dans `script.js` (date « Dernière mise à jour ») ;
2. construit l'index de la recherche interne avec **Pagefind** ;
3. déploie le site sur GitHub Pages.

Pour suivre une publication : onglet **Actions** du dépôt (une coche verte signifie que c'est en ligne). En cas d'échec, une croix rouge apparaît : ouvrez l'exécution pour lire le message d'erreur.

---

## Recherche, sitemap et référencement

- **Recherche interne** : l'icône de recherche de l'en-tête utilise Pagefind. L'index est reconstruit à chaque publication, il n'y a rien à faire.
- **`sitemap.xml`** : liste des pages du site pour les moteurs de recherche. À compléter quand une page est ajoutée, et à mettre à jour (`lastmod`) si besoin.
- **`robots.txt`** : indique aux moteurs de recherche où se trouve le sitemap. Le nom doit être exactement `robots.txt` (avec un « s »).

---

## Bonnes pratiques

- **Écrire comme les familles cherchent** : glisser le mot courant à côté du terme administratif (« crèche » pour multi-accueil, « nounou » pour assistant maternel...). C'est ce qui rend la recherche interne pertinente.
- **Vérifier régulièrement** les horaires, adresses, numéros de téléphone et adresses e-mail : ce sont les informations qui changent le plus.
- **Vérifier après chaque modification** que la page s'affiche bien sur téléphone.
- **Ne jamais publier de données personnelles** de particuliers (uniquement des coordonnées professionnelles de structures).
- Toujours renseigner le **texte alternatif** (`alt`) des images.

---

## Fichiers hérités à nettoyer

Certains fichiers ne sont plus utilisés par le site et peuvent être supprimés (à vérifier avant suppression) :

- `INSTRUCTIONS.md` : mode d'emploi d'une ancienne version du site (ancien nom de dépôt, ancienne structure).
- `style.css` : ancienne feuille de style, remplacée par `styles.css`.
- `robot.txt` : doublon mal nommé, le bon fichier est `robots.txt`.
- Fichiers `*_texte.txt` : textes sources ayant servi à rédiger les pages.
- Images `*_page-XXX.png` non utilisées dans les pages : à conserver seulement si elles sont référencées par un fichier HTML.

---

## Contact

- **Contenu du guide** (informations, mises à jour) : Communauté de Communes Berry Loire Puisaye, 42 rue des Prés Gris, 45250 Briare, contact@cc-berryloirepuisaye.fr, 02 38 37 03 84.
- **Suivi technique du site** : *[à compléter : nom et adresse e-mail de la personne référente]*

---

© Communauté de Communes Berry Loire Puisaye - Tous droits réservés.
