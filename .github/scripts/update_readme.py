import os

def count_files(folder_path):
    """Count .py and .sql files in a folder"""
    if not os.path.exists(folder_path):
        print(f"DEBUG: Folder not found - {folder_path}")
        return 0
    
    try:
        files = os.listdir(folder_path)
        py_files = [f for f in files if f.endswith('.py')]
        sql_files = [f for f in files if f.endswith('.sql')]
        total = len(py_files) + len(sql_files)
        
        print(f"DEBUG: {folder_path} - .py: {len(py_files)}, .sql: {len(sql_files)}, Total: {total}")
        return total
        
    except Exception as e:
        print(f"DEBUG: Error reading {folder_path} - {e}")
        return 0

def generate_readme():
    topics = [
        ('Python/Arrays', 'Arrays'),
        ('Python/Easy', 'Easy'),
        ('SQL/Easy', 'SQL'),
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
- Python: `XXXX-problem-name.py`
- SQL: `XXX-problem-name.sql`
"""
    
    with open('README.md', 'w') as f:
        f.write(readme)
    
    print(f"README updated! Total problems: {total}")

if __name__ == "__main__":
    generate_readme()
