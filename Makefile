Ich entwickle ein Nintendo-DS-Homebrew-Projekt namens „ginseng_strip_gta“ mit devkitPro/devkitARM, libnds, GitHub Actions und einem Nintendo DS mit TWiLight Menu++.

Bitte überprüfe und korrigiere mein Projekt sehr gründlich. Ich möchte KEINE halbfertige oder spekulative Lösung. Berücksichtige alle folgenden bisherigen Probleme:

1. Die Makefile war mehrfach vollständig dupliziert und dadurch strukturell kaputt.
2. Es gab mehrfach doppelte `all:`-, `clean:`-, `.nds`-, `.elf`- und Dependency-Regeln.
3. Es gab fehlerhafte bzw. zusammengeklebte Zeilen wie `all:#---------------------------------------------------------------------------------`.
4. Es gab mindestens eine falsche Dependency-Dateiendung `*.ds` statt `*.d`.
5. Die Makefile wurde zeitweise im falschen Unterordner abgelegt.
6. GitHub Actions meldete:
   `No targets specified and no makefile found`
   und anschließend:
   `Process completed with exit code 2`.
7. Deshalb muss überprüft werden, dass GitHub Actions tatsächlich im Verzeichnis arbeitet, in dem die Makefile liegt.
8. Die gewünschte Projektstruktur ist:
   
   Projekt-Hauptordner/
   ├── Makefile
   ├── source/
   │   └── main.c
   └── include/

9. In der Makefile soll `SOURCES := source` verwendet werden und `INCLUDES := include`.
10. Die Makefile muss eine echte, saubere devkitPro/devkitARM-NDS-Makefile sein und darf keine mehrfach kopierten Abschnitte enthalten.
11. Der Build soll eine `.nds`-Datei mit dem Namen `ginseng_strip_gta.nds` erzeugen.
12. Die Lösung soll für einen ARM9/libnds-Nintendo-DS-Homebrew-Build geeignet sein.
13. GitHub Actions soll die Makefile im Repository-Hauptverzeichnis finden und daraus die `.nds` bauen.
14. Warnungen über Node 20/Node 24 oder die zukünftige Ubuntu-`latest`-Migration sollen nicht fälschlicherweise als eigentliche Makefile-Fehler behandelt werden.
15. TWiLight Menu++ und nds-bootstrap sollen erst dann weiter untersucht werden, wenn der Build selbst nachweislich korrekt funktioniert.
16. Der frühere nds-bootstrap-Fehler darf nicht einfach als Makefile-Problem behauptet werden. Erst den Build und die erzeugte ROM-Struktur korrekt herstellen.
17. Prüfe insbesondere Pfade, Dateinamen, Einrückungen, Make-Syntax, `endif`, Targets, Dependency-Regeln und GitHub-Actions-Arbeitsverzeichnis.
18. Verwende keine erfundenen Dateien oder Pfade.
19. Wenn etwas aus meinen Angaben nicht sicher hervorgeht, markiere es ausdrücklich als Unsicherheit.
20. Gib mir am Ende eine vollständig bereinigte Lösung, nicht nur einzelne Änderungen.

Wichtig:
- Erstelle eine EINZIGE saubere Makefile.
- Keine Duplikate.
- Keine unnötigen Regeln.
- Keine `*.ds`-Dependency.
- Die Makefile muss im Repository-Hauptordner liegen, auf derselben Ebene wie `source` und `include`.
- Die GitHub-Actions-Konfiguration muss zur tatsächlichen Projektstruktur passen.
- Wenn die Workflow-Datei angepasst werden muss, gib mir ebenfalls die vollständige korrigierte Workflow-Datei.
- Prüfe, ob der Workflow wirklich `make` im richtigen Verzeichnis ausführt.
- Prüfe, ob die erzeugte `.nds` anschließend als GitHub-Actions-Artefakt hochgeladen wird.
- Gib mir danach eine kurze Schritt-für-Schritt-Anleitung, was ich auf GitHub klicken bzw. ändern muss.

Hier ist der bisherige problematische Makefile-Inhalt. Analysiere ihn als Fehlerquelle und ersetze ihn vollständig durch eine saubere Version, statt einzelne Teile daraus weiterzuverwenden:

[HIER DEN BISHERIGEN MAKEFILE-INHALT EINFÜGEN]

Ziel:
Am Ende möchte ich einen erfolgreichen grünen GitHub-Actions-Build haben, eine korrekt erzeugte `ginseng_strip_gta.nds` und erst danach testen wir die ROM auf dem Nintendo DS.
