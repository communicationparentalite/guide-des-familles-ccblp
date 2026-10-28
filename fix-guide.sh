#!/bin/bash
# ============================================================
# fix-guide.sh
# Corrige automatiquement :
#   1. Les URLs Open Graph restantes en guide-des-familles/
#   2. Le bug d'ID du city-stade Beaulieu dans loisirs.html
#   3. Le </p> en trop dans loisirs.html
#   4. Les coquilles (caf.frr, labelisé, philosphe, anternne, parentalie_)
# ============================================================

set -e  # Arrête le script à la moindre erreur

# --- Vérification : on est bien à la racine du projet ---
if [ ! -f "script.js" ] || [ ! -f "index.html" ]; then
    echo "❌ Erreur : ce script doit être lancé à la racine du projet"
    echo "   (là où se trouvent script.js et index.html)"
    exit 1
fi

echo "🔧 Correction du Guide des Familles"
echo "======================================"
echo ""

# ============================================================
# 1. URLs Open Graph : guide-des-familles/ → guide-des-familles-ccblp/
# ============================================================
echo "📌 1/4 — Correction des URLs Open Graph…"

FILES_HTML=$(ls *.html 2>/dev/null || true)
COUNT_URL=0

for f in $FILES_HTML; do
    # On ne remplace QUE si l'URL n'est pas déjà en -ccblp
    # Utilisation de perl pour le negative lookahead (sed ne le supporte pas)
    if grep -q "guide-des-familles/" "$f" 2>/dev/null; then
        perl -i -pe 's{https://communicationparentalite\.github\.io/guide-des-familles/(?!ccblp)}{https://communicationparentalite.github.io/guide-des-familles-ccblp/}g' "$f"
        echo "   ✅ $f"
        COUNT_URL=$((COUNT_URL + 1))
    fi
done

if [ $COUNT_URL -eq 0 ]; then
    echo "   (aucune URL à corriger)"
else
    echo "   → $COUNT_URL fichier(s) corrigé(s)"
fi
echo ""

# ============================================================
# 2. Bug d'ID city-stade Beaulieu dans loisirs.html
# ============================================================
echo "📌 2/4 — Correction du city-stade Beaulieu (loisirs.html)…"

if [ -f "loisirs.html" ]; then
    # On cible précisément le bloc de Beaulieu pour ne pas toucher aux autres
    # On remplace les 4 occurrences dans le bloc de Beaulieu uniquement
    perl -i -0pe 's{
        (<div\s+class="accordion-card\s+lieu-card"\s+id=")city_beaulieu(".*?
        <input\s+type="checkbox"\s+id=")print-city-briare("\s+class="print-checkbox"\s+data-print-target=")city-briare(".*?
        <label\s+for=")print-city-briare(">Imprimer\s+ce\s+city-stade</label>)
    }{$1city-beaulieu$2print-city-beaulieu$3city-beaulieu$4print-city-beaulieu$5}xs' loisirs.html

    echo "   ✅ loisirs.html — city-stade Beaulieu corrigé"
else
    echo "   ⚠️  loisirs.html introuvable, étape ignorée"
fi
echo ""

# ============================================================
# 3. </p> en trop dans loisirs.html (Squares Beaulieu)
# ============================================================
echo "📌 3/4 — Correction du </p> en trop (loisirs.html)…"

if [ -f "loisirs.html" ]; then
    # Remplace "</p></p>" par "</p>" (uniquement dans le contexte des squares Beaulieu)
    perl -i -pe 's{<p>Espace jeux au Jardin des 5 sens, rue des Vergers</p></p>}{<p>Espace jeux au Jardin des 5 sens, rue des Vergers</p>}g' loisirs.html
    echo "   ✅ loisirs.html — </p> en trop corrigé"
else
    echo "   ⚠️  loisirs.html introuvable, étape ignorée"
fi
echo ""

# ============================================================
# 4. Coquilles diverses
# ============================================================
echo "📌 4/4 — Correction des coquilles…"

# 4.1 — acces-droits.html : www.caf.frr → www.caf.fr
if [ -f "acces-droits.html" ]; then
    perl -i -pe 's{www\.caf\.frr}{www.caf.fr}g' acces-droits.html
    echo "   ✅ acces-droits.html — www.caf.frr → www.caf.fr"
fi

# 4.2 — acces-droits.html : labelisé → labellisé
if [ -f "acces-droits.html" ]; then
    perl -i -pe 's{labelisé}{labellisé}g; s{labelisée}{labellisée}g' acces-droits.html
    echo "   ✅ acces-droits.html — labelisé → labellisé"
fi

# 4.3 — jeunesse.html : philosphe → philosophe
if [ -f "jeunesse.html" ]; then
    perl -i -pe 's{philosphe}{philosophe}g' jeunesse.html
    echo "   ✅ jeunesse.html — philosphe → philosophe"
fi

# 4.4 — parentalite.html : anternne → antenne (dans l'URL loiret.fr)
if [ -f "parentalite.html" ]; then
    perl -i -pe 's{-anternne-de-gien}{-antenne-de-gien}g' parentalite.html
    echo "   ✅ parentalite.html — anternne → antenne (URL)"
fi

# 4.5 — parentalite.html : parentalie_adomicile45.png → parentalite_adomicile45.png
if [ -f "parentalite.html" ]; then
    perl -i -pe 's{parentalie_adomicile45\.png}{parentalite_adomicile45.png}g' parentalite.html
    echo "   ✅ parentalite.html — parentalie_ → parentalite_ (image)"
fi

echo ""
echo "======================================"
echo "✅ Terminé !"
echo ""
echo "🔍 Vérification finale :"
echo ""

# Vérification : plus aucune URL guide-des-familles/ sans -ccblp
REMAINING=$(grep -rn "guide-des-familles/" --include="*.html" . 2>/dev/null | grep -v "guide-des-familles-ccblp" | wc -l || echo 0)

if [ "$REMAINING" -eq 0 ]; then
    echo "   ✅ Toutes les URLs sont en guide-des-familles-ccblp/"
else
    echo "   ⚠️  $REMAINING occurrence(s) restante(s) :"
    grep -rn "guide-des-familles/" --include="*.html" . 2>/dev/null | grep -v "guide-des-familles-ccblp"
fi

echo ""
echo "📋 Prochaines étapes :"
echo "   1. Vérifiez les modifications : git diff"
echo "   2. Committez : git add -A && git commit -m \"Corrections URLs + coquilles + bug city-stade\""
echo "   3. Poussez : git push"
echo ""
