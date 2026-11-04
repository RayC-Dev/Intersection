#!/bin/bash
# =============================================================
#  SCRIPT DE PRATIQUE — TP Systèmes d'Exploitation
#  À partir de la Question 28
#  Lance avec : bash tp_pratique.sh
# =============================================================

# Couleurs pour l'affichage
VERT='\033[0;32m'
BLEU='\033[0;34m'
JAUNE='\033[1;33m'
ROUGE='\033[0;31m'
RESET='\033[0m'

pause() {
    echo ""
    read -p ">>> Appuie sur ENTRÉE pour continuer... " _
    echo ""
}

titre() {
    echo ""
    echo -e "${BLEU}============================================${RESET}"
    echo -e "${BLEU}  $1${RESET}"
    echo -e "${BLEU}============================================${RESET}"
}

question() {
    echo -e "${JAUNE}[Q$1]${RESET} $2"
}

explication() {
    echo -e "  ${VERT}💡 $1${RESET}"
}

cmd() {
    echo -e "  ${ROUGE}➜ Commande :${RESET} $1"
}

# -------------------------------------------------------
# PRÉPARATION : recréer l'arborescence si nécessaire
# -------------------------------------------------------
titre "PRÉPARATION — Arborescence de base"
echo "On s'assure que l'arborescence UNIX/test existe..."

mkdir -p ~/UNIX/test/rep1/rep4
mkdir -p ~/UNIX/test/rep2
touch ~/UNIX/test/rep1/fic2
touch ~/UNIX/test/rep1/rep4/fic6
echo "Il fait beau aujourd'hui." > ~/UNIX/test/rep1/rep4/fic6

echo -e "${VERT}✓ Arborescence prête !${RESET}"
pause

# -------------------------------------------------------
# PARTIE I.2 — LIENS SYMBOLIQUES ET PHYSIQUES
# -------------------------------------------------------
titre "I.2 — Liens symboliques et physiques"

cd ~/UNIX/test

# On recrée le lien physique lpfic6 pour la Q28
ln rep1/rep4/fic6 lpfic6 2>/dev/null || true

# -------------------------------------------------------
question 28 "Ajoute la ligne 'Modifié via lpfic6' à la fin de lpfic6"
cmd 'echo "Modifié via lpfic6" >> lpfic6'
explication ">> ajoute à la fin du fichier sans écraser le contenu existant"
echo "Modifié via lpfic6" >> lpfic6
echo "--- Contenu de lpfic6 après : ---"
cat lpfic6
pause

# -------------------------------------------------------
question 29 "Que voit-on dans fic6 après avoir modifié lpfic6 ?"
cmd 'cat rep1/rep4/fic6'
explication "fic6 et lpfic6 partagent le MÊME inode → même données, toujours synchronisés"
cat rep1/rep4/fic6
pause

# -------------------------------------------------------
question 30 "Retire aux membres du groupe le droit de lecture sur fic6"
cmd 'chmod g-r rep1/rep4/fic6'
explication "g-r = retirer (remove) le droit r (read) au groupe (group)"
chmod g-r rep1/rep4/fic6
ls -l rep1/rep4/fic6
pause

# -------------------------------------------------------
question 31 "Observe les droits de lpfic6 — que constates-tu ?"
cmd 'ls -l lpfic6'
explication "lpfic6 a perdu le même droit ! Les permissions sont dans l'inode, partagé par les deux."
ls -l lpfic6
pause

# -------------------------------------------------------
question 32 "Crée un lien symbolique lsfic6 sur fic6"
cmd 'ln -s rep1/rep4/fic6 lsfic6'
explication "ln -s crée un lien SYMBOLIQUE (soft link) qui contient juste le chemin textuel"
ln -s rep1/rep4/fic6 lsfic6
ls -li lpfic6 lsfic6 rep1/rep4/fic6
pause

# -------------------------------------------------------
question 33 "Examine lpfic6 et lsfic6 avec ls -li — quelle différence ?"
cmd 'ls -li lpfic6 lsfic6 rep1/rep4/fic6'
explication "lpfic6 = même inode que fic6 (lien physique, compteur à 2)"
explication "lsfic6 = inode DIFFÉRENT, type 'l', contient le chemin vers fic6"
ls -li lpfic6 lsfic6 rep1/rep4/fic6
pause

# -------------------------------------------------------
question 34 "Essaie de modifier les droits de lsfic6 — que se passe-t-il ?"
cmd 'chmod g+r lsfic6'
explication "chmod SUIT le lien symbolique → modifie les droits de fic6 (la cible), pas du lien"
explication "lsfic6 reste toujours affiché lrwxrwxrwx"
chmod g+r lsfic6
echo "--- droits de lsfic6 : ---"
ls -l lsfic6
echo "--- droits de fic6 (cible) : ---"
ls -l rep1/rep4/fic6
pause

# -------------------------------------------------------
question 35 "Retire-toi le droit x sur le répertoire rep1"
cmd 'chmod u-x rep1'
explication "Sans x sur rep1, on ne peut plus TRAVERSER le répertoire → plus aucun accès aux fichiers dedans"
chmod u-x rep1
ls -l | grep rep1
pause

# -------------------------------------------------------
question 36 "Essaie d'afficher lpfic6 puis lsfic6 — que se passe-t-il ?"
cmd 'cat lpfic6'
cmd 'cat lsfic6'
explication "lpfic6 reste lisible : accès DIRECT à l'inode, pas par chemin"
explication "lsfic6 échoue : son chemin rep1/rep4/fic6 doit TRAVERSER rep1 (pas de x)"
echo "--- Lecture de lpfic6 (lien physique) : ---"
cat lpfic6
echo ""
echo "--- Lecture de lsfic6 (lien symbolique) : ---"
cat lsfic6 2>&1 || echo "(Erreur attendue : chemin bloqué !)"
pause

# -------------------------------------------------------
question 37 "Rétablis ton accès au répertoire rep1"
cmd 'chmod u+x rep1'
explication "On remet le droit de traversée sur rep1"
chmod u+x rep1
ls -l | grep rep1
pause

# -------------------------------------------------------
question 38 "Déplace fic6 dans le répertoire rep1"
cmd 'mv rep1/rep4/fic6 rep1/'
explication "mv sur le même système de fichiers conserve l'inode, change juste l'entrée dans le répertoire"
mv rep1/rep4/fic6 rep1/
ls rep1/
pause

# -------------------------------------------------------
question 39 "Affiche lpfic6 puis lsfic6 — que se passe-t-il ?"
cmd 'cat lpfic6'
cmd 'cat lsfic6'
explication "lpfic6 fonctionne toujours : même inode, insensible au déplacement"
explication "lsfic6 est CASSÉ : son chemin rep1/rep4/fic6 n'existe plus !"
echo "--- Lecture de lpfic6 : ---"
cat lpfic6
echo ""
echo "--- Lecture de lsfic6 : ---"
cat lsfic6 2>&1 || echo "(Erreur attendue : lien cassé !)"
pause

# -------------------------------------------------------
question 40 "Remet fic6 dans rep4"
cmd 'mv rep1/fic6 rep1/rep4/'
mv rep1/fic6 rep1/rep4/
echo -e "${VERT}✓ fic6 remis dans rep4${RESET}"
pause

# -------------------------------------------------------
question 41 "Supprime le fichier fic6"
cmd 'rm rep1/rep4/fic6'
explication "rm décrémente le compteur de liens de l'inode"
explication "Si compteur > 0 (lpfic6 pointe encore dessus), l'inode N'EST PAS supprimé"
rm rep1/rep4/fic6
echo -e "${VERT}✓ fic6 supprimé${RESET}"
pause

# -------------------------------------------------------
question 42 "Affiche lpfic6 puis lsfic6 — que se passe-t-il ?"
cmd 'cat lpfic6'
cmd 'cat lsfic6'
explication "lpfic6 affiche toujours le contenu : l'inode existe tant qu'un lien y pointe"
explication "lsfic6 est cassé : le fichier cible a disparu"
echo "--- Lecture de lpfic6 : ---"
cat lpfic6
echo ""
echo "--- Lecture de lsfic6 : ---"
cat lsfic6 2>&1 || echo "(Erreur attendue : fichier introuvable !)"
pause

# -------------------------------------------------------
question 43 "Recrée le fichier fic6 dans rep4"
cmd 'touch rep1/rep4/fic6'
explication "touch crée un nouveau fichier → NOUVEL inode (différent de l'ancien fic6 !)"
touch rep1/rep4/fic6
echo "--- Inodes maintenant : ---"
ls -li rep1/rep4/fic6 lpfic6 lsfic6
pause

# -------------------------------------------------------
question 44 "Combien de liens a rep2 initialement ?"
cmd 'ls -ld rep2'
explication "Un répertoire vide a 2 liens : son entrée dans le parent + l'entrée . en lui-même"
ls -ld rep2
echo "Réponse : 2 liens"
pause

# -------------------------------------------------------
question 45 "Crée le sous-répertoire rep3 dans rep2"
cmd 'mkdir rep2/rep3'
mkdir rep2/rep3
echo -e "${VERT}✓ rep3 créé${RESET}"
pause

# -------------------------------------------------------
question 46 "Combien de liens a rep2 maintenant ?"
cmd 'ls -ld rep2'
explication "Chaque sous-répertoire ajoute +1 lien (via son entrée '..')"
ls -ld rep2
echo "Réponse : 3 liens (parent + . + .. de rep3)"
pause

# -------------------------------------------------------
question 47 "Essaie de créer un lien physique lprep4 sur rep4"
cmd 'ln rep1/rep4 lprep4'
explication "Sous Linux, les liens physiques sur répertoires sont INTERDITS (même pour root)"
ln rep1/rep4 lprep4 2>&1 || echo "(Erreur attendue : impossible sur un répertoire !)"
pause

# -------------------------------------------------------
question 48 "Vrai ou faux : la création d'un lien physique sur un répertoire est impossible ?"
explication "VRAI — Linux interdit les hard links sur répertoires pour éviter des cycles dans l'arborescence"
pause

# -------------------------------------------------------
question 49 "Crée un lien symbolique lsrep4 vers rep4"
cmd 'ln -s rep1/rep4 lsrep4'
explication "Les liens symboliques PEUVENT pointer vers des répertoires"
ln -s rep1/rep4 lsrep4
ls -l lsrep4
pause

# -------------------------------------------------------
question 50 "Crée un lien symbolique lslsrep4 vers lsrep4, dans rep2"
cmd 'ln -s ../lsrep4 rep2/lslsrep4'
explication "Le chemin dans un lien symbolique est RELATIF au répertoire où il se trouve"
explication "lslsrep4 est dans rep2, donc ../lsrep4 remonte dans test/ pour trouver lsrep4"
ln -s ../lsrep4 rep2/lslsrep4
ls -l rep2/lslsrep4
pause

# -------------------------------------------------------
question 51 "Trois manières de se déplacer dans rep4 depuis test"
cmd 'cd rep1/rep4'
cmd 'cd lsrep4'
cmd 'cd rep2/lslsrep4'
explication "Les 3 chemins mènent au même répertoire physique (rep4)"
echo "  (Test avec ls sur les 3 chemins)"
ls rep1/rep4
ls lsrep4
ls rep2/lslsrep4
pause

# -------------------------------------------------------
question 52 "Différence entre 'ls -Ral lsrep4' et 'ls -Ral lsrep4/'"
cmd 'ls -Ral lsrep4'
cmd 'ls -Ral lsrep4/'
explication "Sans / : ls décrit le lien lui-même"
explication "Avec /  : ls suit le lien et liste le CONTENU de rep4"
echo "--- Sans / (décrit le lien) : ---"
ls -Ral lsrep4
echo ""
echo "--- Avec / (suit le lien → contenu de rep4) : ---"
ls -Ral lsrep4/
pause

# -------------------------------------------------------
# PARTIE I.3 — INODES
# -------------------------------------------------------
titre "I.3 — I-nœuds (Inodes)"

# -------------------------------------------------------
question 53 "Affiche le numéro d'inode de fic2"
cmd 'ls -i rep1/fic2'
explication "ls -i affiche le numéro d'inode devant le nom du fichier"
ls -i rep1/fic2
pause

# -------------------------------------------------------
question 54 "Copie fic2 dans rep3"
cmd 'cp rep1/fic2 rep2/rep3/'
explication "cp crée un NOUVEAU fichier avec un NOUVEL inode"
cp rep1/fic2 rep2/rep3/
echo "--- Inodes de fic2 original et copie : ---"
ls -i rep1/fic2 rep2/rep3/fic2
pause

# -------------------------------------------------------
question 55 "Après copie, l'inode change-t-il ?"
explication "OUI — cp crée un nouveau fichier → nouvel inode (données dupliquées, indépendantes)"
ls -i rep1/fic2 rep2/rep3/fic2
pause

# -------------------------------------------------------
question 56 "Renomme la copie de fic2 en fic6 dans rep3"
cmd 'mv rep2/rep3/fic2 rep2/rep3/fic6'
mv rep2/rep3/fic2 rep2/rep3/fic6
echo -e "${VERT}✓ Renommé en fic6${RESET}"
ls -i rep2/rep3/fic6
pause

# -------------------------------------------------------
question 57 "Renommer change-t-il l'inode ?"
cmd 'ls -i rep2/rep3/fic6'
explication "NON — mv sur le même système de fichiers conserve l'inode, seul le nom change"
ls -i rep2/rep3/fic6
pause

# -------------------------------------------------------
question 58 "Compare les inodes de fic6 (rep4), lpfic6 et lsfic6"
cmd 'ls -li rep1/rep4/fic6 lpfic6 lsfic6'
explication "fic6 : recréé avec touch → NOUVEL inode"
explication "lpfic6 : conserve l'inode de L'ANCIEN fic6 (avant suppression)"
explication "lsfic6 : a son PROPRE inode (lien symbolique = fichier distinct)"
ls -li rep1/rep4/fic6 lpfic6 lsfic6
pause

# -------------------------------------------------------
# PARTIE II.1 — REDIRECTIONS
# -------------------------------------------------------
titre "II.1.a — Les redirections de base"

cd ~

# -------------------------------------------------------
question 59 "Que contient temp après : cat /etc/group > temp ?"
cmd 'cat /etc/group > temp'
explication "> redirige la sortie stdout vers un fichier (ÉCRASE le contenu existant)"
cat /etc/group > temp
echo "--- Premières lignes de temp : ---"
head -3 temp
pause

# -------------------------------------------------------
question 60 "Que contient temp après : cat /etc/passwd > temp ?"
cmd 'cat /etc/passwd > temp'
explication "> ÉCRASE le contenu précédent → seul /etc/passwd reste dans temp"
cat /etc/passwd > temp
echo "--- Premières lignes de temp (uniquement passwd) : ---"
head -3 temp
pause

# -------------------------------------------------------
question 61 "Que contient temp après : cat /etc/group >> temp ?"
cmd 'cat /etc/group >> temp'
explication ">> AJOUTE à la fin (append) → temp contient passwd PUIS group"
cat /etc/group >> temp
echo "--- Nombre de lignes total dans temp : ---"
wc -l temp
pause

# -------------------------------------------------------
question 62 "Différence entre 'wc temp' et 'wc < temp'"
cmd 'wc temp'
cmd 'wc < temp'
explication "wc temp : ouvre temp comme argument (affiche le nom du fichier)"
explication "wc < temp : stdin redirigé depuis temp (n'affiche pas le nom)"
echo "--- wc temp ---"
wc temp
echo "--- wc < temp ---"
wc < temp
pause

# -------------------------------------------------------
question 63 "Différence entre 'ls ; who > temp' et '(ls ; who) > temp'"
cmd 'ls ; who > temp   (seul who est redirigé)'
cmd '(ls ; who) > temp  (les deux sont redirigés)'
explication "Sans parenthèses : la redirection ne s'applique qu'à la dernière commande (who)"
explication "Avec parenthèses : le sous-shell regroupe les deux → tout va dans temp"
echo "--- Test sans parenthèses (ls s'affiche à l'écran) : ---"
ls /etc/hosts ; who > temp
echo "--- Test avec parenthèses (rien à l'écran) : ---"
(ls /etc/hosts ; who) > temp
echo "--- Contenu de temp avec parenthèses : ---"
cat temp
pause

# -------------------------------------------------------
question 64 "Supprime temp"
cmd 'rm temp'
rm temp
echo -e "${VERT}✓ temp supprimé${RESET}"
pause

# -------------------------------------------------------
titre "II.1.b — Le fichier spécial /dev/null"

# -------------------------------------------------------
question 65 "Affiche le contenu de /dev/null"
cmd 'cat /dev/null'
explication "/dev/null est toujours vide — en lecture il retourne immédiatement EOF"
cat /dev/null
echo "(rien affiché — c'est normal !)"
pause

# -------------------------------------------------------
question 66 "Affiche la taille de /dev/null"
cmd 'ls -l /dev/null'
explication "Taille = 0 (et toujours 0, peu importe ce qu'on y écrit)"
ls -l /dev/null
pause

# -------------------------------------------------------
question 67 "Ajoute /etc/passwd à la fin de /dev/null"
cmd 'cat /etc/passwd >> /dev/null'
explication "/dev/null JETTE toutes les données écrites (black hole)"
cat /etc/passwd >> /dev/null
echo -e "${VERT}✓ Écrit dans /dev/null${RESET}"
pause

# -------------------------------------------------------
question 68 "Affiche de nouveau le contenu de /dev/null — que vois-tu ?"
cmd 'cat /dev/null'
explication "Rien ! /dev/null est toujours vide même après écriture"
cat /dev/null
echo "(toujours vide !)"
pause

# -------------------------------------------------------
question 69 "Conclusion sur /dev/null"
explication "/dev/null discard toutes les données écrites → reste vide"
pause

# -------------------------------------------------------
question 70 "Quelle spécificité de /dev/null permet ce comportement ?"
explication "C'est un PÉRIPHÉRIQUE SPÉCIAL (character device) qui accepte et jette les écritures"
explication "Utilisé pour silencer les sorties indésirables"
ls -l /dev/null
pause

# -------------------------------------------------------
titre "II.1.c — Exercices redirections"

# -------------------------------------------------------
question 71 "find / -print avec les erreurs redirigées vers /dev/null"
cmd 'find / -print 2>/dev/null | head -5'
explication "2>/dev/null redirige uniquement stderr (erreurs 'permission refusée') vers le vide"
explication "stdout (les chemins trouvés) s'affiche normalement"
find / -print 2>/dev/null | head -5
pause

# -------------------------------------------------------
question 72 "find / -print avec données ET erreurs redirigées"
cmd 'find / -print &>/dev/null'
explication "&> redirige stdout ET stderr vers /dev/null → rien ne s'affiche"
find / -print &>/dev/null
echo "(aucune sortie — tout a été redirigé vers /dev/null)"
pause

# -------------------------------------------------------
question 73 "Créer pi.txt depuis le terminal sans éditeur"
cmd 'cat > pi.txt'
explication "cat sans argument lit depuis stdin (clavier) et écrit dans pi.txt"
explication "On termine la saisie avec Ctrl+D"
echo "Que j'aime à faire apprendre un nombre utile aux sages !" > pi.txt
echo "Glorieux Archimède, artiste, ingénieur," >> pi.txt
echo -e "${VERT}✓ pi.txt créé (avec echo pour cet exemple automatique)${RESET}"
echo "--- Contenu : ---"
head -2 pi.txt
pause

# -------------------------------------------------------
question 74 "Sélectionne la ligne gdm de /etc/passwd dans temp"
cmd 'grep gdm /etc/passwd > temp'
explication "grep cherche les lignes contenant 'gdm' dans /etc/passwd"
explication "> redirige le résultat dans temp"
grep gdm /etc/passwd > temp 2>/dev/null || echo "gdm non trouvé (peut varier selon la VM)"
cat temp 2>/dev/null || echo "(fichier vide si gdm absent)"
pause

# -------------------------------------------------------
question 75 "Affiche le 5e champ (séparateur ':') du fichier temp"
cmd 'cut -d: -f5 temp'
explication "cut -d: = séparateur ':', -f5 = extraire le 5e champ"
explication "Dans /etc/passwd le 5e champ = nom complet (GECOS)"
cut -d: -f5 temp 2>/dev/null || echo "(temp vide)"
pause

# -------------------------------------------------------
question 76 "Supprime temp"
cmd 'rm temp'
rm -f temp
rm -f pi.txt
echo -e "${VERT}✓ Nettoyage effectué${RESET}"
pause

# -------------------------------------------------------
titre "II.2 — Les tubes (pipes)"

# -------------------------------------------------------
question 77 "Affiche le nom de l'utilisateur gdm via un tube"
cmd 'grep gdm /etc/passwd | cut -d: -f5'
explication "| connecte la sortie de grep à l'entrée de cut → pas de fichier intermédiaire"
grep gdm /etc/passwd | cut -d: -f5 2>/dev/null || echo "(gdm absent de ce système)"
pause

# -------------------------------------------------------
question 78 "Affiche les lignes 3 à 7 de /etc/passwd"
cmd "sed -n '3,7p' /etc/passwd"
explication "sed -n = mode silencieux, '3,7p' = afficher les lignes 3 à 7"
sed -n '3,7p' /etc/passwd
pause

# -------------------------------------------------------
question 79 "Combien d'utilisateurs utilisent bash ?"
cmd 'grep bash /etc/passwd | wc -l'
explication "grep filtre les lignes contenant bash | wc -l compte le nombre de lignes"
grep bash /etc/passwd | wc -l
pause

# -------------------------------------------------------
question 80 "Combien de commandes commencent par 'less' dans /bin ?"
cmd 'ls /bin/less* | wc -l'
explication "ls /bin/less* liste tous les fichiers commençant par 'less' dans /bin"
ls /bin/less* 2>/dev/null | wc -l
pause

# -------------------------------------------------------
question 81 "Nombre de processus de root"
cmd 'ps aux | grep ^root | wc -l'
explication "grep ^root filtre les lignes COMMENÇANT par root"
explication "wc -l compte le nombre de lignes = nombre de processus"
ps aux | grep ^root | wc -l
pause

# -------------------------------------------------------
question 82 "Liste des utilisateurs ayant au moins un processus"
cmd 'ps aux | tail -n +2 | cut -d'"' '"' -f1 | sort | uniq'
explication "tail -n +2 = sauter la ligne d'en-tête (USER PID...)"
explication "cut -d' ' -f1 = extraire la 1ère colonne (nom utilisateur)"
explication "sort | uniq = trier puis supprimer les doublons"
ps aux | tail -n +2 | awk '{print $1}' | sort | uniq
pause

# -------------------------------------------------------
question 83 "Processus par utilisateur, ordre décroissant"
cmd "ps aux | tail -n +2 | cut -d' ' -f1 | sort | uniq -c | sort -rn"
explication "uniq -c = supprimer doublons ET afficher le nombre d'occurrences"
explication "sort -rn = trier en ordre décroissant (-r) numérique (-n)"
ps aux | tail -n +2 | awk '{print $1}' | sort | uniq -c | sort -rn
pause

# -------------------------------------------------------
question 84 "Arborescence des répertoires de façon incrémentale"
cmd "find . -type d | sed -e 's/[^\\/] \\// /g'"
explication "find . -type d liste tous les répertoires"
explication "sed transforme les / en espaces pour créer l'indentation"
find ~/UNIX -type d | sed -e 's/[^\/]*\//  /g; s/^  //'
pause

# -------------------------------------------------------
question 85 "Profondeur des chemins dans une arborescence"
explication "/chemin/a              → Profondeur 0 (directement dans /chemin)"
explication "/chemin/sous1/b        → Profondeur 1"
explication "/chemin/sous1/sous2/c  → Profondeur 2"
explication "/chemin/sous3/d        → Profondeur 1"
echo ""
echo "La profondeur = nombre de niveaux entre le chemin de base et le fichier"
pause

# -------------------------------------------------------
titre "✅ FIN DU SCRIPT — TP COMPLET !"
echo ""
echo -e "${VERT}Toutes les commandes ont été exécutées.${RESET}"
echo ""
echo "Rappels importants :"
echo "  • Supprimer fichier → w sur le RÉPERTOIRE PARENT"
echo "  • Traverser répertoire → x sur le RÉPERTOIRE"
echo "  • Lister répertoire → r sur le RÉPERTOIRE"
echo "  • Lien physique = même inode (survit déplacement/suppression)"
echo "  • Lien symbolique = chemin texte (cassé si cible déplacée/supprimée)"
echo "  • > écrase, >> ajoute, 2> erreurs, &> tout"
echo ""
