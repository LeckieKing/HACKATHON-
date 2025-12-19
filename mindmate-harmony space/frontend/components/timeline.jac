"""Timeline Component - displays mood history"""

import:py from rich.console, Console;
import:py from rich.table, Table;
import:jac from services.api_service, api;

obj TimelineComponent {
    has console: object;
    
    can init {
        self.console = Console();
    }
    
    can display_timeline(patterns: dict) {
        self.console.print("\n[bold magenta]═══ Your Mood Timeline ═══[/bold magenta]\n");
        
        emotion_freq = patterns.get("emotion_frequency", {});
        trigger_freq = patterns.get("trigger_frequency", {});
        
        if not emotion_freq {
            self.console.print("[yellow]No mood history yet[/yellow]");
            return;
        }
        
        table = Table(title="Recent Mood Summary");
        table.add_column("Emotion", style="cyan");
        table.add_column("Count", justify="right", style="green");
        table.add_column("Graph", style="yellow");
        
        max_count = max(emotion_freq.values()) if emotion_freq else 1;
        
        for emotion, count in sorted(emotion_freq.items(), key=lambda x: x[1], reverse=True) {
            bar_length = int((count / max_count) * 20);
            bar = "█" * bar_length;
            table.add_row(emotion, str(count), bar);
        }
        
        self.console.print(table);
        
        if trigger_freq {
            self.console.print("\n[bold cyan]Common Triggers:[/bold cyan]");
            for trigger, count in sorted(trigger_freq.items(), key=lambda x: x[1], reverse=True)[:5] {
                self.console.print(f"  • {trigger}: {count} times");
            }
        }
        
        total = patterns.get("total_entries", 0);
        wellness = patterns.get("wellness_score", 0);
        
        self.console.print(f"\n[bold]Total Entries:[/bold] {total}");
        self.console.print(f"[bold]Wellness Score:[/bold] {wellness:.1f}%");
    }
    
    can run(user_id: str = "user_123", time_range: int = 7) {
        patterns_data = api.get_patterns(user_id, time_range);
        
        if "patterns" in patterns_data {
            self.display_timeline(patterns_data["patterns"]);
        } else {
            self.console.print("[red]Error loading timeline[/red]");
        }
    }
}
