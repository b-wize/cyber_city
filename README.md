This is a brief collection of some of the detection logic searches I've built over the last few years. These are as general as possible to keep them modular. The table names are intentionally left as comments to be swapped out to a person's individual environment.\
The work here is informed by real enterprise security experience from my Security Architecture & Engineering work, meaning these detections are built around real threats that show up, not just hypotheticals. If something is in here, it's because it was worth building.

What's here
- Sentinel Detections — KQL queries for Microsoft Sentinel, covering a range of threat scenarios including package manager abuse and third-party library monitoring
- Sumo Logic Detections — equivalent detection logic for Sumo Logic environments
- PowerShell Scripts — automation tooling built for real operational use
- Threat Modeling — a STRIDE-based threat model for generic enterprise IT environments, written to be forked and adapted
- Security frameworks and process design, including a capability-driven software review framework built to replace manual approval queues with a repeatable, automatable decision model

How to use it\
Swap the commented table names to match your environment and you're most of the way there. The detections are modular by design utilizing portable logic without major edits regardless of how your environment is structured. If you're using the Sentinel watchlist-based detections, there are notes in the relevant files on how to set those up.

Why it's built this way\
I'd rather publish something for everyone than something environment-specific that no one can use. Fork, adapt, share, make it yours.
