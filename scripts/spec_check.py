import os
import sys

REQUIRED_SPECS = [
    "specs/_meta.md",
    "specs/functional.md",
    "specs/technical.md"
]

def check_specs():
    print("Checking for required specification files...")
    missing = []
    for spec in REQUIRED_SPECS:
        if not os.path.exists(spec):
            missing.append(spec)
            print(f"❌ Missing: {spec}")
        else:
            print(f"✅ Found: {spec}")
    
    if missing:
        print(f"\nERROR: {len(missing)} required spec files are missing.")
        sys.exit(1)
    
    print("\nAll core specifications found.")
    # Future: Add logic to parse markdown and check for specific headers/content
    sys.exit(0)

if __name__ == "__main__":
    check_specs()
