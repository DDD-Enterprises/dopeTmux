Corrected dopeTask Series B v2 bundle for tmux-host, authored against the strict TaskPacket schema and observed tp series executor rules.

Contains:
- TP-18.json
- TP-09.json
- TP-10.json
- TP-01.json
- TP-02.json

Series:
- tmux-host-work-series-b-v2

Chain:
- TP-18 root
- TP-09 depends on TP-18
- TP-10 depends on TP-09
- TP-01 depends on TP-10
- TP-02 depends on TP-01 and is the single final packet

Execution note:
Run this after the repo bootstrap, corrected Series A, and the UI/state groundwork are in place.
