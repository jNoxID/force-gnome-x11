#!/usr/bin/env bash
set -Eeuo pipefail

log()  { printf '\033[1;34m[+]\033[0m %s\n' "$*"; }
warn() { printf '\033[1;33m[!]\033[0m %s\n' "$*"; }
die()  { printf '\033[1;31m[x]\033[0m %s\n' "$*" >&2; exit 1; }

[[ $EUID -eq 0 ]] || die "Lance ce script avec sudo."

GDM_CONF="/etc/gdm3/daemon.conf"

[[ -f "$GDM_CONF" ]] || die "Fichier $GDM_CONF introuvable. GDM3 ne semble pas installé."

log "Sauvegarde de la configuration GDM..."
cp -a "$GDM_CONF" "${GDM_CONF}.backup.$(date +%Y%m%d-%H%M%S)"

log "Désactivation de Wayland dans GDM..."

if grep -qE '^[#[:space:]]*WaylandEnable=' "$GDM_CONF"; then
    sed -i 's/^[#[:space:]]*WaylandEnable=.*/WaylandEnable=false/' "$GDM_CONF"
else
    sed -i '/^\[daemon\]/a WaylandEnable=false' "$GDM_CONF"
fi

log "Vérification des sessions X11 disponibles..."

if [[ -d /usr/share/xsessions ]]; then
    ls -1 /usr/share/xsessions || true
else
    warn "/usr/share/xsessions introuvable."
fi

log "Configuration terminée."
echo
echo "Après redémarrage de la session, vérifie avec :"
echo
echo "    echo \$XDG_SESSION_TYPE"
echo
echo "Le résultat attendu est : x11"
echo

read -r -p "Redémarrer GDM maintenant ? [y/N] " answer

case "${answer,,}" in
    y|yes|o|oui)
        log "Redémarrage de GDM..."
        systemctl restart gdm3
        ;;
    *)
        warn "Redémarrage non effectué."
        warn "Tu peux le faire plus tard avec : sudo systemctl restart gdm3"
        ;;
esac