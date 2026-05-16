# Intersection — Comparateur de données haute performance
---

##  Le Problème & La Solution

*   **Le problème :** Comparer deux listes de diffusion, des inventaires ou des colonnes Excel de milliers de lignes est souvent fastidieux (ouverture de gros logiciels, formules `RECHERCHEV` complexes, perte de temps).
*   **La solution :** **Intersection** offre un outil "Drag & Drop" instantané, accessible directement dans le navigateur. Il nettoie la donnée automatiquement et livre les résultats en moins de 10 millisecondes.

##  Fonctionnalités Clés

*    **Analyse Multi-Format :** Support complet du Glisser-Déposer pour les fichiers `.xlsx`, `.xls` et `.csv` (via SheetJS), ainsi que le copier-coller de texte brut.
*    **Performance Absolue :** Algorithme d'intersection optimisé avec une complexité temporelle en $O(n)$ grâce à l'utilisation de structures de données `Set` en JavaScript. Gère plus de 50 000 lignes sans ralentissement.
*    **Nettoyage Automatique :** Tolérance aux erreurs grâce au nettoyage automatique des espaces blancs (*trim*) et à l'exclusion des lignes vides.

##  Stack Technique

*   **Frontend :** HTML5 / CSS3 
*   **Logique :** JavaScript 
