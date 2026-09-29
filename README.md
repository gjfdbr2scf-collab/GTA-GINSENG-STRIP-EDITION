# Ginseng Strip GTA

Ein Nintendo-DS/DSi-Spielprojekt auf Basis von devkitPro/libnds.

## Enthaltene Spielgrundlagen
- Startmenü mit Deutsch/English
- Username-Eingabe
- Skin-Auswahl
- Third-Person-/First-Person-Kameramodus per SELECT
- Spielwelt-Grundgerüst
- Unterer Bildschirm mit Karte, Handy, Musik und situationsabhängig Radio
- Kompass
- markierte Sonderorte
- Fahrzeuge und Flugzeug-Grundsystem
- Militärbasis und Spezialfahrzeuge
- SECRET-Funktion für Spezialfahrzeuge
- laufende Tastenhilfe
- Missions-/Geld-/Spielerzustände

## Build
Das Projekt ist für eine aktuelle devkitPro/devkitARM-Umgebung mit libnds gedacht.

1. Projektordner in eine devkitPro-Umgebung kopieren.
2. `make` ausführen.
3. Die erzeugte DS-ROM kann anschließend mit einem Emulator oder auf Hardware geprüft werden.

Hinweis: Die Grafik- und Soundressourcen sind bewusst als einfache Platzhalter angelegt; die Spielarchitektur ist so strukturiert, dass sie durch echte Assets ersetzt werden kann.

## Änderung dieser Version
- Startinitialisierung auf reinen 2D-Modus umgestellt, um den weißen Bildschirm des Prototyps zu vermeiden.
- Ein echter NDS-Build bzw. Hardwaretest wurde hier nicht durchgeführt.


## GitHub Actions Build

Dieses Projekt enthält einen GitHub-Actions-Workflow unter
`.github/workflows/build.yml`.

Der Workflow verwendet den offiziellen `devkitpro/devkitarm`-Container auf
einem GitHub-hosted Runner. Dadurch muss devkitARM/devkitPro nicht lokal
auf Windows installiert sein.

Nach einem Push oder Pull Request wird `make` ausgeführt. Die fertige
`ginseng_strip_gta.nds` wird anschließend als GitHub-Actions-Artefakt
hochgeladen.
