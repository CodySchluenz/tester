flowchart TB

    
    subgraph After["AFTER: Dual Component Template"]
        direction TB
        
        subgraph Templates["Component Templates"]
            direction LR
            
            subgraph CT2["APIConnect-Public"]
                CT2Team["Team: APIC<br/>(800 app teams)"]
                P5["Process:<br/>• Publish"]
            end
            
            subgraph CT3["APIConnect-Internal"]
                CT3Team["Team: APIC-Internal-Team<br/>(Your core team only)"]
                P6["Processes:<br/>• ZZ DONOTUSE API CONNECT<br/>• ZZ DONOTUSE Publish Test<br/>• ZZ DONOTUSE TEST V10"]
            end
        end
        
        subgraph Views2["User Views"]
            direction LR
            
            subgraph AppTeamView2["App Teams See:"]
                ATV2["Component: APIConnect-Public<br/>━━━━━━━━━━━━━━━━<br/>• Publish<br/><br/>APIConnect-Internal:<br/>NOT VISIBLE<br/><br/>Result: Clean & Simple"]
            end
            
            subgraph YourTeamView2["Your Team Sees:"]
                YTV2["Component: APIConnect-Public<br/>━━━━━━━━━━━━━━━━<br/>• Publish<br/><br/>Component: APIConnect-Internal<br/>━━━━━━━━━━━━━━━━<br/>• ZZ DONOTUSE API CONNECT<br/>• ZZ DONOTUSE Publish Test<br/>• ZZ DONOTUSE TEST V10<br/><br/>Result: Organized"]
            end
        end
        
        Templates --> Views2
    end

       subgraph Before["BEFORE: Single Component Template"]
        direction TB
        
        subgraph CT1["Component Template: APIConnect"]
            direction TB
            CT1Team["Team: APIC<br/>(800 app teams + your team)"]
            
            subgraph CT1Procs["Processes"]
                P1["Publish<br/>(Everyone should use)"]
                P2["ZZ DONOTUSE API CONNECT TEAM ONLY<br/>(Your team only - but visible to all)"]
                P3["ZZ DONOTUSE Publish Test<br/>(Your team only - but visible to all)"]
                P4["ZZ DONOTUSE TEST V10<br/>(Your team only - but visible to all)"]
            end
        end
        
        subgraph Views1["User Views"]
            direction LR
            
            subgraph AppTeamView1["App Teams See:"]
                ATV1["Component: APIConnect<br/>━━━━━━━━━━━━━━━━<br/>• Publish<br/>• ZZ DONOTUSE (can't run)<br/>• ZZ DONOTUSE (can't run)<br/>• ZZ DONOTUSE (can't run)<br/><br/>Result: Confusing UI"]
            end
            
            subgraph YourTeamView1["Your Team Sees:"]
                YTV1["Component: APIConnect<br/>━━━━━━━━━━━━━━━━<br/>• Publish<br/>• ZZ DONOTUSE (can run)<br/>• ZZ DONOTUSE (can run)<br/>• ZZ DONOTUSE (can run)<br/><br/>Result: Cluttered"]
            end
        end
        
        CT1 --> Views1
    end 
    style Before fill:#ffebee,stroke:#c62828,stroke-width:4px,color:#000
    style After fill:#e8f5e9,stroke:#2e7d32,stroke-width:4px,color:#000
    
    style CT1 fill:#ffcdd2,stroke:#d32f2f,stroke-width:3px,color:#000
    style CT2 fill:#c8e6c9,stroke:#388e3c,stroke-width:3px,color:#000
    style CT3 fill:#c8e6c9,stroke:#388e3c,stroke-width:3px,color:#000
    
    style CT1Team fill:#fff,stroke:#999,stroke-width:1px,color:#000
    style CT2Team fill:#fff,stroke:#999,stroke-width:1px,color:#000
    style CT3Team fill:#fff,stroke:#999,stroke-width:1px,color:#000
    
    style P1 fill:#a5d6a7,stroke:#1b5e20,stroke-width:2px,color:#000
    style P2 fill:#ef9a9a,stroke:#b71c1c,stroke-width:2px,color:#000
    style P3 fill:#ef9a9a,stroke:#b71c1c,stroke-width:2px,color:#000
    style P4 fill:#ef9a9a,stroke:#b71c1c,stroke-width:2px,color:#000
    style P5 fill:#a5d6a7,stroke:#1b5e20,stroke-width:2px,color:#000
    style P6 fill:#ce93d8,stroke:#6a1b9a,stroke-width:2px,color:#000
    
    style AppTeamView1 fill:#fff8e1,stroke:#f57f17,stroke-width:2px,color:#000
    style YourTeamView1 fill:#e1f5fe,stroke:#01579b,stroke-width:2px,color:#000
    style AppTeamView2 fill:#fff8e1,stroke:#f57f17,stroke-width:2px,color:#000
    style YourTeamView2 fill:#e1f5fe,stroke:#01579b,stroke-width:2px,color:#000
    style ATV1 fill:#fff8e1,stroke:#f57f17,stroke-width:1px,color:#000
    style YTV1 fill:#e1f5fe,stroke:#01579b,stroke-width:1px,color:#000
    style ATV2 fill:#fff8e1,stroke:#f57f17,stroke-width:1px,color:#000
    style YTV2 fill:#e1f5fe,stroke:#01579b,stroke-width:1px,color:#000
    
    style Views1 fill:#fafafa,stroke:#616161,stroke-width:2px,color:#000
    style Views2 fill:#fafafa,stroke:#616161,stroke-width:2px,color:#000
    style Templates fill:#fafafa,stroke:#616161,stroke-width:2px,color:#000
    style CT1Procs fill:#fff,stroke:#999,stroke-width:1px,color:#000
