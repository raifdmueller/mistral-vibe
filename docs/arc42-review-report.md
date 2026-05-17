# arc42 Dokumentations-Review — Mistral Vibe

**Geprüftes Dokument:** `docs/arc42.adoc` (Single-File-Layout, Typ C)
**Begleitartefakte herangezogen:** `architecture-decisions.adoc`, `specification.adoc`, `entity_model.md`, `use_cases/`, `OPEN_QUESTIONS.adoc`, `QUESTION_TREE.adoc`, `PRD.adoc`
**Review-Modus:** Vollständiges Review (12 Sektionen + 7 Konfliktdimensionen)
**Hinweis:** Das Dokument wurde aus Quellcode rückentwickelt; kein Team verfügbar. `[OPEN — see Q-X.Y]`-Markierungen werden als ehrliche Lücken bewertet, nicht als Defekte — außer wo eine `[OPEN]`-Markierung aus Code beantwortbar wäre oder das Dokument überzieht.

---

## Gesamtübersicht

| Sektion | Status | Befunde |
|---------|--------|---------|
| 1. Einführung und Ziele | 🟡 | Stakeholder-Tabelle fehlt; Qualitätsziele ohne Szenarien; Anforderungsüberblick ohne Verweis auf bestehende Use Cases. |
| 2. Randbedingungen | 🟡 | Vollständig und code-belegt, aber keine Kategorisierung (technisch/organisatorisch/Konventionen) und keine Konsequenzen. |
| 3. Kontext und Scope | 🟡 | Gutes Kontextdiagramm, aber kein fachlicher/technischer Kontext getrennt; keine Schnittstellentabelle mit Ein-/Ausgaben. |
| 4. Lösungsstrategie | 🟢 | Kompakt, code-belegt, Qualitätsziel-Bezug erkennbar; Rationale ehrlich als `[OPEN]`. |
| 5. Bausteinsicht | 🟡 | L1 + L2 vorhanden, aber Bausteine ohne strukturierte Blackbox-Beschreibungen (Zweck/Schnittstelle/Verantwortung). |
| 6. Laufzeitsicht | 🟡 | Nur ein Szenario; Fehler-/Betriebsszenarien und ACP/Teleport als `[OPEN]` — teils aus Code ableitbar. |
| 7. Verteilungssicht | 🟡 | Diagramm vorhanden, aber kein explizites Baustein-zu-Knoten-Mapping; keine Umgebungen (dev/test/prod). |
| 8. Querschnittliche Konzepte | 🟢 | Stärkste Sektion: STRIDE-Threat-Model mit T-IDs, Mitigations mit Rückverweis, Test/Observability/Error-Handling/Config sauber. |
| 9. Architekturentscheidungen | 🟡 | 5 ADRs in Nygard-Format ausgelagert, korrekt; aber S9 selbst nennt keine verworfenen Alternativen und keine Zeitstempel. |
| 10. Qualitätsanforderungen | 🔴 | Faktisch leer — nur ein `[OPEN]`-Verweis; keine Qualitätsszenarien, kein Qualitätsbaum. |
| 11. Risiken und technische Schulden | 🟡 | 4 Risiken benannt, code-belegt, aber ohne Priorisierung und ohne Gegenmaßnahmen. |
| 12. Glossar | 🟢 | Kompakt, konsistent, deckt die Ubiquitous-Language-Begriffe ab. |

**Gesamtstatus: 🔴** — wegen der faktisch leeren Sektion 10 (kritischer Befund). Ohne S10 wäre das Dokument 🟡: solide rückentwickelte Doku mit ehrlichen Lücken, aber unvollständigen Pflichtteilen.

---

## Sektions-Reviews

### Sektion 1: Einführung und Ziele

#### [S1-01] Stakeholder-Tabelle fehlt vollständig
**Schwere:** 🟡 Empfehlung
**Datei:** `docs/arc42.adoc` — "Introduction and Goals"
**Kriterium:** arc42 1.3 Stakeholder — eigener Abschnitt mit Rolle/Beschreibung/Erwartung
**Befund:** Es gibt keinen Stakeholder-Abschnitt. Die Personas sind in `PRD.adoc` und den Use Cases vorhanden (Developer, CI-Operator, IDE-Client), werden aber in S1 nicht zusammengeführt.
**Änderungsvorschlag:**
> Füge nach den Qualitätszielen einen Abschnitt "Stakeholders" ein:
> | Rolle | Beschreibung | Erwartung an die Architektur |
> | Developer | Nutzt Vibe interaktiv im Terminal | Kontrolle über Tools, schnelle Turns, keine Datenlecks |
> | CI/Automation Operator | Treibt `vibe -p` in Skripten | Deterministisches Headless-Verhalten, Kosten-/Turn-Limits |
> | IDE/ACP-Integrator | Bettet den Agenten ein | Stabiler ACP-Vertrag |
> | Maintainer/Contributor | Erweitert Engine, Tools, Skills | Klare Ports, strikte Lint-/Type-Gates |
> Markiere die Priorisierung der Segmente mit `[OPEN — see Q1.6]`.

#### [S1-02] Qualitätsziele ohne Szenarien und ohne Verweis auf Sektion 10
**Schwere:** 🟡 Empfehlung
**Datei:** `docs/arc42.adoc` — Qualitätsziel-Tabelle
**Kriterium:** arc42 1.2 — Qualitätsziele sollten ein konkretes Szenario tragen und auf S10 verweisen
**Befund:** Die drei Qualitätsziele (Maintainability, Security, Usability) sind durch Code-Signale belegt, aber jedes nennt nur "warum es im Code sichtbar ist", kein messbares Szenario. Ein Verweis auf S10 fehlt.
**Änderungsvorschlag:**
> Ergänze die Tabelle um eine Spalte "Szenario (siehe Sektion 10)" und verweise im Fließtext: "Messbare Szenarien zu diesen Zielen stehen in Sektion 10 (derzeit `[OPEN — see Q3.10]`)."

#### [S1-03] Anforderungsüberblick verweist nicht auf die vorhandenen Use Cases
**Schwere:** 🟢 Hinweis
**Datei:** `docs/arc42.adoc` — Einleitungsabsatz
**Kriterium:** arc42 1.1 — Verweis auf existierende Anforderungsdokumente
**Befund:** 15 fully-dressed Use Cases existieren unter `docs/use_cases/`, werden in S1 aber nicht referenziert.
**Änderungsvorschlag:**
> Ergänze: "Die funktionalen Anforderungen sind als 15 User-Goal Use Cases in `docs/use_cases/` (UC-001…UC-015) dokumentiert."

### Sektion 2: Randbedingungen

#### [S2-01] Constraints nicht kategorisiert
**Schwere:** 🟡 Empfehlung
**Datei:** `docs/arc42.adoc` — "Constraints"
**Kriterium:** arc42 Sektion 2 — Trennung technisch / organisatorisch / Konventionen
**Befund:** Die fünf Constraints stehen als flache Liste. Python ≥ 3.12 und UNIX-Target sind technisch; `uv`-managed, Pyright-Gate, "no relative imports" sind Konventionen; Apache-2.0 ist organisatorisch/rechtlich. Die Vermischung erschwert die Lesbarkeit.
**Änderungsvorschlag:**
> Gliedere in drei Unterabschnitte "Technische Randbedingungen", "Konventionen", "Organisatorische Randbedingungen" und ordne die fünf Punkte zu.

#### [S2-02] Konsequenzen der Constraints nicht benannt
**Schwere:** 🟢 Hinweis
**Datei:** `docs/arc42.adoc` — "Constraints"
**Kriterium:** arc42 Sektion 2 — Konsequenzen / Freiheitsgrade erläutern
**Befund:** Es wird nicht gesagt, was die Constraints für die Architektur bedeuten (z.B. "Python ≥ 3.12 ⇒ moderne Typsyntax nutzbar; UNIX-Target ⇒ Windows-Pfad-/Keyring-Sonderfälle bleiben best-effort").
**Änderungsvorschlag:**
> Ergänze je Constraint eine kurze Konsequenz-Spalte.

### Sektion 3: Kontext und Scope

#### [S3-01] Fachlicher und technischer Kontext nicht getrennt
**Schwere:** 🟡 Empfehlung
**Datei:** `docs/arc42.adoc` — "Context and Scope"
**Kriterium:** arc42 3.1 / 3.2
**Befund:** Es gibt ein gutes C4-Kontextdiagramm, aber keine Trennung in fachlichen (3.1) und technischen (3.2) Kontext und keine begleitende Tabelle der Kommunikationspartner.
**Änderungsvorschlag:**
> Ergänze eine Tabelle "Kommunikationspartner": je Partner (Developer, Automation Script, IDE/ACP, LLM APIs, MCP-Server, Vibe Code Cloud, Local OS, PyPI/GitHub) eine Zeile mit fachlicher Ein-/Ausgabe und technischem Kanal/Protokoll (HTTPS, stdio, JSON-RPC, WS). Das Diagramm trägt die Kanäle bereits — die Tabelle macht sie für S3.2 explizit.

#### [S3-02] Keine explizite Risikobetrachtung im Kontext
**Schwere:** 🟢 Hinweis
**Datei:** `docs/arc42.adoc` — "Context and Scope"
**Befund:** Externe Schnittstellen (LLM-API, MCP-Server, Cloud) sind sicherheitsrelevant; S8.1 behandelt sie als Threats. Ein Querverweis von S3 auf das Threat-Model fehlt.
**Änderungsvorschlag:**
> Ergänze: "Sicherheitsrisiken dieser externen Schnittstellen sind im Threat Model (Sektion 8.1, T-003/T-005/T-006) erfasst."

### Sektion 4: Lösungsstrategie

Keine kritischen Befunde. Die Sektion ist kompakt, jede strategische Festlegung ist code-belegt, und der Bezug zu den Qualitätszielen (Hexagonal ⇒ Maintainability/Testability; TUI-Entkopplung ⇒ Reusability) ist erkennbar. Die fehlende Rationale ist ehrlich als `[OPEN — see Q3.9]` markiert.

#### [S4-01] Qualitätsziel-Zuordnung nur implizit
**Schwere:** 🟢 Hinweis
**Datei:** `docs/arc42.adoc` — "Solution Strategy"
**Kriterium:** arc42 Sektion 4 — explizite Zuordnung Qualitätsziel ↔ Lösungsansatz
**Befund:** Der Leser muss die Zuordnung selbst herstellen. Usability (Qualitätsziel 3) hat keinen sichtbaren strategischen Ansatz in S4.
**Änderungsvorschlag:**
> Ergänze pro Strategiepunkt das adressierte Qualitätsziel in Klammern, und füge einen vierten Punkt für Usability hinzu (z.B. "Rich Textual TUI mit Autocompletion und Onboarding-Wizard — adressiert Usability").

### Sektion 5: Bausteinsicht

#### [S5-01] Bausteine ohne strukturierte Blackbox-Beschreibung
**Schwere:** 🟡 Empfehlung
**Datei:** `docs/arc42.adoc` — "Building Block View"
**Kriterium:** arc42 5.1 — jede Blackbox mit Zweck, Schnittstelle, Verzeichnis/Verantwortung
**Befund:** L1 und L2 haben gute C4-Diagramme, aber die Bausteine werden nur in einem Fließsatz beschrieben (`vibe/core` ist die Engine ...). Es fehlt eine konsistente Tabelle: Baustein | Verantwortung | Schnittstelle | Verzeichnis. Die Diagramm-Tooltips tragen Teile davon, ersetzen aber keine Blackbox-Liste.
**Änderungsvorschlag:**
> Ergänze für L1 und L2 je eine Tabelle "Baustein | Verantwortung | Wichtige Schnittstelle | Quellverzeichnis" (für L1: vibe/cli, vibe/acp, vibe/setup, vibe/core; für L2 die acht Komponenten). Daten dafür stehen im Code und sind aus den C4-Diagrammen ableitbar.

### Sektion 6: Laufzeitsicht

#### [S6-01] Nur ein Laufzeitszenario; ableitbare Szenarien als `[OPEN]` markiert
**Schwere:** 🟡 Empfehlung
**Datei:** `docs/arc42.adoc` — "Runtime View"
**Kriterium:** arc42 Sektion 6 — mehrere architekturrelevante Szenarien, inkl. Fehler-/Betriebsszenarien
**Befund:** Der eine "agent turn" ist gut modelliert. ACP-Session und Teleport sind als `[OPEN — see Q3.6]` markiert. Das ist teilweise berechtigt (genaue Fehler-/Cancellation-Kanten brauchen Team-Bestätigung), aber der grobe Ablauf von ACP-Session und Teleport ist aus `vibe/acp/` und der Teleport-Logik im Code ableitbar und sollte zumindest skizziert werden. Auch ein Fehlerszenario (Tool-Permission verweigert, Price-Limit greift) ist aus dem vorhandenen Diagramm bereits halb sichtbar.
**Änderungsvorschlag:**
> Ergänze zwei skizzenhafte Sequenzdiagramme (ACP-Session-Start, Teleport-Handoff) auf Basis von `vibe/acp/` und markiere nur die unbestätigten Fehler-/Cancellation-Kanten als `[OPEN — see Q3.6]`, statt das ganze Szenario offen zu lassen.

### Sektion 7: Verteilungssicht

#### [S7-01] Kein explizites Software-zu-Knoten-Mapping
**Schwere:** 🟡 Empfehlung
**Datei:** `docs/arc42.adoc` — "Deployment View"
**Kriterium:** arc42 Sektion 7 — Mapping der Bausteine (S5) auf Infrastruktur
**Befund:** Das Deployment-Diagramm zeigt "Developer Machine" mit dem App-Artefakt und `~/.vibe`. Es wird aber nicht gesagt, dass alle vier L1-Bausteine (cli, acp, setup, core) im selben Prozess/Artefakt auf der Developer Machine laufen. Bei einem Single-Node-System ist eine minimale Darstellung akzeptabel, das Mapping sollte aber ein Satz sein.
**Änderungsvorschlag:**
> Ergänze: "Alle Bausteine aus Sektion 5 (cli, acp, setup, core) sind in das eine `mistral-vibe`-Artefakt gebündelt und laufen als ein Prozess auf der Developer Machine; es gibt keine dev/test/prod-Trennung auf Infrastrukturebene."

### Sektion 8: Querschnittliche Konzepte

Stärkste Sektion des Dokuments. STRIDE-Threat-Model mit T-IDs (T-001…T-008), Security-Mitigations mit Rückverweis auf die geschlossenen T-IDs, Test/Observability/Error-Handling/Configuration sind echte Konzepte und code-belegt. Der residuale Threat T-007 (kein Audit-Trail) ist ehrlich offen gehalten.

#### [S8-01] Verweis auf das Domänen-/Entity-Modell fehlt
**Schwere:** 🟢 Hinweis
**Datei:** `docs/arc42.adoc` — "Crosscutting Concepts"
**Kriterium:** arc42 Sektion 8 — ein fachliches oder technisches Datenmodell sollte referenziert sein
**Befund:** Ein ausgearbeitetes Entity-Modell existiert in `docs/entity_model.md` (VIBE_CONFIG, SESSION, MESSAGE, TOOL, PERMISSION_RULE …), wird in S8 aber nicht erwähnt.
**Änderungsvorschlag:**
> Ergänze einen Unterabschnitt "8.7 Domänenmodell" mit einem Satz und Verweis: "Die konzeptuellen Entitäten und ihre Beziehungen sind in `docs/entity_model.md` modelliert (es gibt keine relationale Datenbank; Persistenz erfolgt über Dateien und den OS-Keyring)."

### Sektion 9: Architekturentscheidungen

Die fünf ADRs in `architecture-decisions.adoc` sind formal sauber (Nygard: Status/Context/Decision/Consequences) und tragen je eine 3-Punkt-Pugh-Matrix. Die folgenden Befunde betreffen S9 im Hauptdokument bzw. die ausgelagerte Datei.

#### [S9-01] Verworfene Alternativen nur als Pugh-Baseline, nicht im Fließtext
**Schwere:** 🟡 Empfehlung
**Datei:** `docs/architecture-decisions.adoc` — ADR-001…005
**Kriterium:** arc42 Sektion 9 / Nygard — verworfene Alternativen dokumentieren
**Befund:** Jede ADR nennt im Pugh-Matrix-Header eine Baseline-Alternative (Direct calls, Mistral-only client, Single global config, SQLite, UI-coupled engine), aber der `Decision`-Abschnitt erklärt nicht, warum die Alternative verworfen wurde. Das ist aus Code nicht voll belegbar — die Markierung "Confirmed fit … ?" / `[OPEN — see Q3.9]` ist insoweit korrekt.
**Änderungsvorschlag:**
> Ergänze je ADR im `Consequences`- oder einem neuen `Rejected alternatives`-Absatz einen Satz zur Baseline, soweit code-belegbar; verbleibende Begründungslücken mit `[OPEN — see Q3.9]` markieren.

#### [S9-02] Keine Zeitstempel/Daten an den ADRs
**Schwere:** 🟢 Hinweis
**Datei:** `docs/architecture-decisions.adoc`
**Kriterium:** arc42 Sektion 9 / Nygard — Entscheidungen sollten datiert sein
**Befund:** Keine ADR trägt ein Datum. Bei rückentwickelten ADRs ist ein exaktes Datum nicht ermittelbar, aber das Datum der Recovery sollte vermerkt sein.
**Änderungsvorschlag:**
> Ergänze je ADR "*Date*: recovered <YYYY-MM> from source v2.9.6".

### Sektion 10: Qualitätsanforderungen

#### [S10-01] Sektion faktisch leer — keine Qualitätsszenarien
**Schwere:** 🔴 Kritisch
**Datei:** `docs/arc42.adoc` — "Quality Requirements"
**Kriterium:** arc42 Sektion 10 — Qualitätsszenarien mit Stimulus und Metrik; Konkretisierung aller Ziele aus 1.2
**Befund:** Die Sektion enthält nur zwei `[OPEN]`-Verweise. Messbare SLAs (Startup-Zeit, Turn-Latenz, Speicher) erfordern zu Recht Team-Input (`Q3.10`). Aber: Nicht jedes Qualitätsszenario braucht eine vom Team gesetzte Zahl. Für die Top-Ziele Maintainability und Security lassen sich falsifizierbare Szenarien aus dem Code formulieren, ohne ein Team zu befragen — z.B. "Ein neuer LLM-Provider wird durch Hinzufügen genau einer Adapter-Datei integriert, ohne Änderung an `vibe/core/agent_loop.py`" (Change-Szenario, prüfbar) oder "Projekt-lokale `config.toml` aus einem nicht vertrauten Ordner wird nicht geladen (`UntrustedLayerError`)" (Security-Szenario, durch Test belegbar). Eine vollständig leere Pflichtsektion ist ein kritischer Befund.
**Änderungsvorschlag:**
> Ergänze mindestens drei code-belegbare Qualitätsszenarien (je ein Change-, Usage- und Fault-Szenario) für Maintainability und Security im Format "Quelle/Stimulus → Reaktion → Metrik". Behalte den `[OPEN — see Q3.10]`-Verweis nur für die zahlenbasierten Performance-SLAs (Startup, Latenz, Speicher) bei.

### Sektion 11: Risiken und technische Schulden

#### [S11-01] Risiken weder priorisiert noch mit Gegenmaßnahmen versehen
**Schwere:** 🟡 Empfehlung
**Datei:** `docs/arc42.adoc` — "Risks and Technical Debt"
**Kriterium:** arc42 Sektion 11 — Priorisierung und konkrete Maßnahmen je Risiko
**Befund:** Vier Risiken sind sauber identifiziert und code-belegt (ruff preview, Teleport-Flag, ~40 Dependencies, undokumentierte Failure-Modes). Es fehlt jedoch (a) eine Priorisierung/Einstufung und (b) je Risiko eine vorgeschlagene Maßnahme.
**Änderungsvorschlag:**
> Wandle die Liste in eine Tabelle "Risiko | Einstufung (hoch/mittel/niedrig) | Maßnahme" um. Beispiel: "Curl-Pipe-Install — mittel — Checksum-/Signatur-Verifikation des Install-Skripts dokumentieren (`[OPEN — see Q5.4]`)."

#### [S11-02] Threat-Model-Residualrisiko T-007 nicht in S11 gespiegelt
**Schwere:** 🟢 Hinweis
**Datei:** `docs/arc42.adoc` — "Risks and Technical Debt" vs. "8.2 Security"
**Befund:** S8.2 weist T-007 (kein durabler Audit-Trail) explizit als Residualrisiko aus, S11 listet es nicht.
**Änderungsvorschlag:**
> Ergänze in S11 ein Risiko "Kein durabler Audit-Trail von Tool-Freigaben (Residualrisiko T-007, siehe Sektion 8.2)".

### Sektion 12: Glossar

Keine kritischen Befunde. Das Glossar ist kompakt, alphabetisch nahe geordnet, deckt die Ubiquitous-Language-Begriffe ab und ist mit dem Entity-Modell konsistent.

#### [S12-01] Wenige im Dokument verwendete Begriffe fehlen
**Schwere:** 🟢 Hinweis
**Datei:** `docs/arc42.adoc` — "Glossary"
**Kriterium:** arc42 Sektion 12 — im Dokument verwendete Fachbegriffe sollten definiert sein
**Befund:** Die Begriffe *Port / Adapter (Hexagonal)*, *ACP*, *Trust Gate* und *Permission Rule* werden im Dokument verwendet (S4, S3, S8.2), stehen aber nicht im Glossar. *Trusted Folder* ist enthalten, *Trust Gate* als zugehöriger Mechanismus nicht.
**Änderungsvorschlag:**
> Ergänze die Begriffe *ACP* ("Agent Client Protocol — JSON-RPC-Schnittstelle, über die ein IDE den Agenten einbettet"), *Port / Adapter* und *Trust Gate*.

---

## Sektionsübergreifende Konflikte

| Konfliktdimension | Status | Befunde |
|---|---|---|
| Qualitätsstrang (S1 ↔ S4 ↔ S10) | 🔴 | S10 leer ⇒ kein Qualitätsziel ist durch ein messbares Szenario konkretisiert; Usability ohne Strategieansatz. |
| Strategie ↔ Entscheidungen (S4 ↔ S9) | 🟢 | Strategie und die fünf ADRs sind konsistent aligned; keine Widersprüche. |
| Constraint-Compliance (S2 ↔ S4/S8/S9) | 🟢 | Keine Constraint-Verletzung; Strategie/Konzepte/ADRs bleiben im gesetzten Rahmen. |
| Kontext ↔ Bausteine (S3 ↔ S5) | 🟡 | Kontext kennt 8 externe Partner, Bausteinsicht L1 zeigt nur 2 davon explizit. |
| Sichten-Konsistenz (S5 ↔ S6 ↔ S7) | 🟡 | Mehrere L2-Bausteine kommen in keinem Laufzeitszenario vor; Verteilungssicht nennt keine S5-Bausteine namentlich. |
| Konzepte ↔ Entscheidungen (S8 ↔ S9) | 🟢 | Saubere Trennung; Threat-Model/Security korrekt als Konzept, Strukturwahl korrekt als ADR. |
| Risiken ↔ Qualität (S11 ↔ S1/S10) | 🟡 | Risiken treffen Maintainability/Security, ein expliziter Bezug zu den Qualitätszielen fehlt. |

### 1. Qualitätsstrang (S1 ↔ S4 ↔ S10)

#### Zuordnungsmatrix

| Qualitätsziel (S1.2) | Strategieansatz (S4) | Szenario (S10) | Status |
|---|---|---|---|
| Maintainability | Hexagonal Ports & Adapters | — (S10 leer) | ⚠️ Lücke |
| Security | Trust-Gate, Tool-Permissioning (in S8.2, nicht S4) | — (S10 leer) | ⚠️ Lücke |
| Usability | kein expliziter S4-Ansatz | — (S10 leer) | ❌ Lücke beidseitig |

#### [KQS-01] Kein Qualitätsziel durch messbares Szenario konkretisiert
**Konflikttyp:** K1 (nicht adressiertes Qualitätsziel) + K5 (Messbarkeits-Lücke)
**Schwere:** 🔴 Kritisch
**Betroffene Dateien:**
- `docs/arc42.adoc` — S1.2 nennt drei Qualitätsziele
- `docs/arc42.adoc` — S10 enthält keine Szenarien
**Beschreibung:** Keines der drei Qualitätsziele wird in S10 durch ein falsifizierbares Szenario belegt. Damit ist die zentrale Architekturbegründung nicht überprüfbar.
**Lösungsvorschlag:** Siehe S10-01 — drei code-belegbare Szenarien je für Maintainability und Security ergänzen.

#### [KQS-02] Usability ohne strategischen Ansatz in S4
**Konflikttyp:** K1
**Schwere:** 🟡 Warnung
**Betroffene Dateien:**
- `docs/arc42.adoc` — S1.2 listet Usability als Qualitätsziel
- `docs/arc42.adoc` — S4 nennt nur Hexagonal, Agent-Loop, LLM-Backends, TUI-Entkopplung
**Beschreibung:** Usability ist als Top-3-Ziel deklariert, aber kein Strategiepunkt adressiert es. Die TUI-Entkopplung dient Reusability, nicht primär Usability.
**Lösungsvorschlag:** Siehe S4-01 — Strategiepunkt für die Rich-TUI/Autocompletion/Onboarding-Wizard ergänzen.

### 2. Strategie ↔ Entscheidungen (S4 ↔ S9)

#### Zuordnungsmatrix

| Strategische Festlegung (S4) | Zugehörige Entscheidung(en) (S9) | Status |
|---|---|---|
| Hexagonal Ports & Adapters | ADR-001 | ✅ Aligned |
| Pluggable LLM-Backends via Factory | ADR-002 | ✅ Aligned |
| Streaming async Agent-Loop + Middleware | (keine ADR) | 🔲 Lücke — strategisch relevant, aber tolerierbar |
| TUI entkoppelt vom Engine | ADR-005 | ✅ Aligned |
| (Config-Trust-Gate, in S8 dokumentiert) | ADR-003 | ✅ Aligned |
| (File-based Sessions, in S8.5 dokumentiert) | ADR-004 | ✅ Aligned |

#### [KSE-01] Agent-Loop-Architektur strategisch genannt, aber ohne ADR
**Konflikttyp:** K4 (nicht durch Entscheidung gestützte Strategie)
**Schwere:** 🟢 Hinweis
**Betroffene Dateien:**
- `docs/arc42.adoc` — S4 "Streaming async agent loop"
- `docs/architecture-decisions.adoc` — keine ADR dazu
**Beschreibung:** Der asynchrone Agent-Loop mit Middleware-Pipeline ist eine grundlegende Festlegung. Eine eigene ADR fehlt. Da die Entscheidung weitgehend technisch zwingend ist (Streaming-LLM ⇒ async), ist dies nur ein Hinweis.
**Lösungsvorschlag:** Optional eine ADR-006 "Single async Agent-Loop mit Middleware-Pipeline" ergänzen oder im ADR-Dokument vermerken, dass diese Festlegung bewusst nicht als ADR geführt wird.

### 3. Constraint-Compliance (S2 ↔ S4/S8/S9)

#### Constraint-Compliance-Matrix

| Constraint (S2) | Kategorie | S4 | S8 | S9 | Status |
|---|---|---|---|---|---|
| Python ≥ 3.12 | Technisch | ✅ | ✅ | ✅ | ✅ Eingehalten |
| `uv`-managed | Konvention | ✅ | ✅ | ✅ | ✅ Eingehalten |
| Strict Pyright, keine relativen Imports | Konvention | ✅ | ✅ | ✅ | ✅ Eingehalten |
| UNIX-Target, Windows best-effort | Technisch | ✅ | ✅ | ✅ | ✅ Eingehalten |
| Apache-2.0 | Organisatorisch | ✅ | ✅ | ✅ | ✅ Eingehalten |

Keine Konflikte. Keine Festlegung in S4/S8/S9 verletzt einen Constraint.

### 4. Kontext ↔ Bausteine (S3 ↔ S5)

#### Schnittstellenvergleich

| Externer Partner (S3) | In Kontext (S3) | In Bausteinsicht L1 (S5) | Status |
|---|---|---|---|
| Developer | ✅ | ✅ | ✅ Konsistent |
| Automation Script (`vibe -p`) | ✅ | ❌ nicht im L1-Diagramm | ⚠️ Lücke |
| IDE / ACP Client | ✅ | ❌ (ACP-Bridge ist Baustein, der Client fehlt als Akteur) | ⚠️ teilweise |
| LLM APIs | ✅ | ✅ | ✅ Konsistent |
| MCP-Server / Connectors | ✅ | ❌ nicht im L1-Diagramm | ⚠️ Lücke |
| Vibe Code Cloud | ✅ | ❌ nicht im L1-Diagramm | ⚠️ Lücke |
| Local OS | ✅ | ❌ nicht im L1-Diagramm | ⚠️ Lücke |
| PyPI / GitHub | ✅ | ❌ nicht im L1-Diagramm | ⚠️ Lücke |

#### [KKB-01] L1-Bausteinsicht zeigt nur einen Teil der Kontext-Partner
**Konflikttyp:** K1 (Kontextschnittstelle ohne Zuordnung in Bausteinsicht)
**Schwere:** 🟡 Warnung
**Betroffene Dateien:**
- `docs/arc42.adoc` — S3 Kontextdiagramm (8 externe Partner)
- `docs/arc42.adoc` — S5 L1-Diagramm (zeigt nur Developer und LLM APIs)
**Beschreibung:** Das L1-Diagramm reduziert die externen Partner auf Developer und LLM APIs. Die ACP-Bridge ist als Baustein vorhanden, der externe IDE/ACP-Client erscheint aber nicht; MCP-Server, Cloud, OS und Update-Registry fehlen ganz. Ein L1-Whitebox-Diagramm darf vereinfachen, aber die wichtigen externen Schnittstellen sollten konsistent mit S3 sichtbar sein.
**Lösungsvorschlag:** Ergänze im L1-Diagramm die externen Akteure `System_Ext` für IDE/ACP-Client, MCP-Server und Local OS (mindestens die, mit denen Bausteine direkt sprechen), oder vermerke im Text ausdrücklich, dass das L1-Diagramm bewusst nur die zwei wichtigsten Partner zeigt und die übrigen im Kontextdiagramm (S3) stehen.

### 5. Sichten-Konsistenz (S5 ↔ S6 ↔ S7)

#### Baustein-Kreuzreferenz

| Baustein | Bausteinsicht (S5) | Laufzeitsicht (S6) | Verteilungssicht (S7) | Status |
|---|---|---|---|---|
| CLI / TUI | ✅ L1 | ⚠️ als "Developer"-Einstieg impliziert | ⚠️ im Artefakt impliziert | 🟡 |
| ACP Bridge | ✅ L1 | ❌ nicht referenziert | ⚠️ impliziert | ⚠️ Lücke |
| Setup Wizards | ✅ L1 | ❌ nicht referenziert | ⚠️ impliziert | ⚠️ Lücke |
| Agent Loop (L2) | ✅ L2 | ✅ "Agent Loop" | ⚠️ impliziert | ✅ |
| Middleware (L2) | ✅ L2 | ✅ "Middleware" | — | ✅ |
| Tool Manager (L2) | ✅ L2 | ✅ "Tool" | — | ✅ |
| LLM Backends (L2) | ✅ L2 | ✅ "LLM Backend" | — | ✅ |
| Config (L2) | ✅ L2 | ❌ nicht im Szenario | — | 🟢 (Hilfskomponente) |
| Sessions (L2) | ✅ L2 | ✅ "Session Log" | ✅ `~/.vibe` | ✅ |
| Skills & Agents (L2) | ✅ L2 | ❌ nicht referenziert | — | ⚠️ Lücke |
| Telemetry & Teleport (L2) | ✅ L2 | ❌ nicht referenziert (Teleport `[OPEN]`) | ⚠️ Cloud-Pfad | ⚠️ Lücke |

#### [KSV-01] Mehrere Bausteine in keinem Laufzeitszenario
**Konflikttyp:** K3 (verwaister Baustein)
**Schwere:** 🟡 Warnung
**Betroffene Dateien:**
- `docs/arc42.adoc` — S5 definiert ACP-Bridge, Setup, Skills & Agents, Telemetry & Teleport
- `docs/arc42.adoc` — S6 enthält nur das eine "agent turn"-Szenario
**Beschreibung:** Vier Bausteine kommen in keinem Laufzeitszenario vor. Ursache ist nicht ein überflüssiger Baustein, sondern der Mangel an Szenarien (siehe S6-01). Skills & Agents werden im "agent turn" nicht gezeigt, obwohl die Tool-Loop sie nutzt.
**Lösungsvorschlag:** Mit den zusätzlichen Szenarien aus S6-01 (ACP-Start, Teleport) ACP-Bridge und Telemetry/Teleport abdecken; im "agent turn"-Diagramm den Schritt "Tool Manager lädt Skill/Subagent" ergänzen.

#### [KSV-02] Verteilungssicht referenziert keine S5-Bausteine namentlich
**Konflikttyp:** K2 (Mapping unklar)
**Schwere:** 🟡 Warnung
**Betroffene Dateien:**
- `docs/arc42.adoc` — S7 zeigt nur ein "mistral-vibe"-Artefakt
- `docs/arc42.adoc` — S5 definiert vier L1-Bausteine
**Beschreibung:** Die Verteilungssicht nennt keinen einzigen Baustein aus S5. Der Leser kann das Software-Hardware-Mapping nicht nachvollziehen.
**Lösungsvorschlag:** Siehe S7-01 — einen Satz ergänzen, dass alle vier L1-Bausteine in das eine Artefakt gebündelt sind.

### 6. Konzepte ↔ Entscheidungen (S8 ↔ S9)

#### Zuordnungsanalyse

| Element | Sektion | Korrekte Zuordnung? | Bezug |
|---|---|---|---|
| Threat Model (STRIDE) | S8.1 | ✅ Korrekt | Konzept (Querschnitt) |
| Security-Mitigations | S8.2 | ✅ Korrekt | Konzept; Trust-Gate-Wahl ist als ADR-003 separat |
| Test-Strategie | S8.3 | ✅ Korrekt | Konzept |
| Observability | S8.4 | ✅ Korrekt | Konzept |
| Error Handling | S8.5 | ✅ Korrekt | Konzept |
| Configuration (Layered TOML) | S8.6 | ✅ Korrekt | Konzept; Layering+Trust-Gate als ADR-003 separat |

Keine echten Konflikte. Die Trennung WIE (S8) vs. WAS/WARUM (S9) ist sauber: Das Konfigurations-Konzept (S8.6) beschreibt die Mechanik, ADR-003 begründet die Entscheidung — kein redundanter Doppelinhalt, sondern korrekte Verweisstruktur.

### 7. Risiken ↔ Qualität (S11 ↔ S1/S10)

#### Zuordnungsmatrix

| Qualitätsziel (S1.2) | Bedrohende Risiken (S11) | Maßnahmen | Status |
|---|---|---|---|
| Maintainability | ruff preview / Lint-Surface; ~40 Dependencies | keine benannt | ⚠️ Lücke |
| Security | Curl-Pipe-Install (Supply-Chain); Teleport-Flag | keine benannt | ⚠️ Lücke |
| Usability | — kein Risiko genannt | — | 🟢 (vertretbar) |

#### [KRQ-01] Qualitätsrisiken ohne benannte Gegenmaßnahme
**Konflikttyp:** K2 (unmitigiertes Qualitätsrisiko)
**Schwere:** 🟡 Warnung
**Betroffene Dateien:**
- `docs/arc42.adoc` — S11 listet vier Risiken
- `docs/arc42.adoc` — S1.2 / S10
**Beschreibung:** Die Supply-Chain-Risiken (Curl-Pipe-Install, ~40 Dependencies) gefährden direkt das Qualitätsziel Security bzw. Maintainability, S11 nennt aber keine Maßnahme und stellt keinen Bezug zu den Qualitätszielen her.
**Lösungsvorschlag:** Siehe S11-01 — Maßnahmenspalte ergänzen und je Risiko das betroffene Qualitätsziel benennen.

#### [KRQ-02] Qualitätsziel-Bezug der Risiken nicht explizit
**Konflikttyp:** K1 (Bezug fehlt)
**Schwere:** 🟢 Hinweis
**Beschreibung:** S11 ordnet kein Risiko einem Qualitätsziel zu. Der Zusammenhang ist erkennbar, aber nicht dokumentiert.
**Lösungsvorschlag:** In der S11-Tabelle eine Spalte "betroffenes Qualitätsziel" ergänzen.

---

## Konfliktkarte

| Sektion | Involviert in Konflikten |
|---|---|
| S10 — Qualitätsanforderungen | 3 |
| S1 — Einführung/Ziele | 3 |
| S5 — Bausteinsicht | 3 |
| S11 — Risiken | 2 |
| S4 — Lösungsstrategie | 2 |
| S6 — Laufzeitsicht | 2 |
| S3 — Kontext | 1 |
| S7 — Verteilungssicht | 1 |
| S9 — Entscheidungen | 1 |

---

## Zusammenfassung

| Kategorie | Anzahl |
|---|---|
| 🔴 Kritische Befunde | 2 |
| 🟡 Warnungen / Empfehlungen | 14 |
| 🟢 Hinweise | 11 |

**Cross-Section-Konflikte gesamt:** 7 (davon 1 kritisch, 4 Warnungen, 2 Hinweise) über 7 geprüfte Dimensionen; 3 Dimensionen konfliktfrei (🟢).

**Gesamtverdikt: 🔴** — getragen von genau einem kritischen Strukturmangel (leere Sektion 10) und dessen Folgekonflikt (KQS-01). Inhaltlich ist das Dokument für eine code-rückentwickelte Doku überdurchschnittlich: Sektionen 4, 8 und 12 sind vorbildlich, jede Aussage ist `file:line`-belegt, und Lücken sind ehrlich als `[OPEN]` markiert statt erfunden. Die meisten Befunde sind Formalmängel (fehlende Tabellen, fehlende Kategorisierung), keine inhaltlichen Fehler.

### Bewertung der `[OPEN]`-Markierungen

Die meisten `[OPEN]`-Markierungen sind berechtigte, ehrliche Lücken (Rationale der ADRs, Performance-SLAs, Erfolgsmetriken, Persona-Priorisierung — alles ohne Team nicht belegbar). **Über-offen markiert** sind jedoch:
- **S10 / Q3.10** — zahlenbasierte SLAs brauchen das Team, aber Change- und Security-Szenarien sind aus Code falsifizierbar formulierbar; die *komplett* leere Sektion überzieht die `[OPEN]`-Logik.
- **S6 / Q3.6** — der grobe Ablauf von ACP-Session und Teleport ist aus `vibe/acp/` ableitbar; nur die Fehler-/Cancellation-Kanten brauchen Bestätigung.

Keine Stelle wurde als *Über-Claim* identifiziert: Das Dokument behauptet nirgends mehr, als der Code hergibt — im Gegenteil, es ist eher zu zurückhaltend.

### Handlungsempfehlungen

1. **Sektion 10 füllen (🔴, behebt KQS-01):** Mindestens drei code-belegbare Qualitätsszenarien für Maintainability und Security ergänzen; `[OPEN — see Q3.10]` nur noch für Performance-SLAs behalten.
2. **Qualitätsstrang schließen (🟡):** Usability-Strategieansatz in S4 ergänzen; Qualitätsziele in S1.2 mit Szenario-Spalte und S10-Verweis versehen.
3. **Bausteinsicht vervollständigen (🟡):** Blackbox-Tabellen für L1/L2 (Verantwortung, Schnittstelle, Verzeichnis); externe Partner im L1-Diagramm mit S3 abgleichen oder Vereinfachung explizit vermerken.
4. **Laufzeit- und Verteilungssicht erweitern (🟡):** ACP- und Teleport-Szenario skizzieren (behebt KSV-01); Software-zu-Knoten-Mapping als ein Satz ergänzen (behebt KSV-02).
5. **Risiken operationalisieren (🟡):** S11 in eine Tabelle mit Einstufung, Maßnahme und betroffenem Qualitätsziel umbauen; Residualrisiko T-007 aufnehmen.
6. **Formalia (🟢):** Stakeholder-Tabelle in S1, Constraint-Kategorisierung in S2, fachlich/technischer Kontext getrennt in S3, ADR-Datierung, Glossar um ACP/Port/Trust-Gate ergänzen.
