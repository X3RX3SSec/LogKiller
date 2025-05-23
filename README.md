# LogKiller
Simple Log Killer for various Linux systems

![Screenshot_20250220-074631_Termux (1)_1](https://github.com/user-attachments/assets/1a38fa9a-6a74-425d-8acf-0dc006452ab6)


🔹 How to Use LogKiller👇
💲./logkiller.sh --help

2️⃣ Auto-Run Mode (--silent)
Runs without prompts, wipes all logs securely.

💲./logkiller.sh --silent

3️⃣ Dry-Run Mode (--dry-run)
Preview logs before deletion (no actual deletion).
💲./logkiller.sh --dry-run

4️⃣ Self-Destruct Mode (--self-destruct)
Script deletes itself after execution.
💲./logkiller.sh --self-destruct

5️⃣ Logging Mode (--log)
Saves deleted log files in /tmp/logkiller_report.txt.
💲./logkiller.sh --log

6️⃣ Full Mode (--silent --log --backup --self-destruct)
Does everything in one go! (requires root)
💲sudo ./logkiller.sh --silent --log --backup --self-destruct


🟣 Execute directly via bash (one-liner)
⚠️ Warning: Always inspect scripts before executing them this way ⚠️

💲curl -sL https://raw.githubusercontent.com/X3RX3SSec/LogKiller/main/LogKiller.sh | bash

🟣 Download and run manually

💲curl -o LogKiller.sh https://raw.githubusercontent.com/X3RX3SSec/LogKiller/main/LogKiller.sh
chmod +x LogKiller.sh
./LogKiller.sh

🎈Pro Tip (if you want a reusable command):
Create a short alias in your .bashrc or .zshrc:🎈

💲alias logkiller='curl -sL https://raw.githubusercontent.com/X3RX3SSec/LogKiller/main/LogKiller.sh | bash'

⬆️ Then just run logkiller from anywhere.



‼️I am not responsible for any file loss, use this tool at your own risk‼️

For more log entries or idea's just send me a DM on Instagram @mindfuckerrrr or make a request 💪🏻
