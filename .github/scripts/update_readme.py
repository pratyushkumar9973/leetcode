import os

def count_files(folder_path):
    """Count .py files in a folder"""
    if not os.path.exists(folder_path):
        return 0
    return len([f for f in os.listdir(folder_path) if f.endswith('.py')])

def generate_readme():
    topics = [
        ('Python/Arrays', 'Arrays'),
        ('Python/Easy', 'Easy'),
        ('Python/SQL', 'SQL'),
    ]
    
    readme = """# LeetCode Solutions
My daily LeetCode practice in Python.

## Topics

| Topic | Status | Files | Link |
|-------|--------|-------|------|
"""
    
    total = 0
    for folder, name in topics:
        count = count_files(folder)
        total += count
        status = "🟢 Active" if count > 0 else "⚪ Empty"
        link = f"[View]({folder}/)" if count > 0 else "—"
        readme += f"| {folder}/ | {status} | {count} | {link} |\n"
    
    readme += f"""
## Progress

| Topic | Solved |
|-------|--------|
"""
    
    for folder, name in topics:
        count = count_files(folder)
        readme += f"| {name} | {count} |\n"
    
    readme += f"| **Total** | **{total}** |\n"
    
    readme += """
## File Naming Convention
`XXXX-problem-name.py` (e.g., `0001-two-sum.py`)
"""
    
    with open('README.md', 'w') as f:
        f.write(readme)
    
    print(f"README updated! Total problems: {total}")

if __name__ == "__main__":
    generate_readme()
